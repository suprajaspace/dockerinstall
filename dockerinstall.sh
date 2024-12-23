LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Please run this script with root priveleges $N" | tee -a $LOG_FILE
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is...$R FAILED $N"  | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}

echo "Script started executing at: $(date)" | tee -a $LOG_FILE

CHECK_ROOT

yum install -y yum-utils &>>$LOG_FILE
VALIDATE $? "step 1"

yum config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo &>>$LOG_FILE
VALIDATE $? "step 2"

yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin -y docker-compose-plugin -y &>>$LOG_FILE
VALIDATE $? "step 3"

systemctl start docker &>>$LOG_FILE
VALIDATE $? "step 4"

systemctl status docker &>>$LOG_FILE
VALIDATE $? "step 5"
usermod -aG docker ec2-user &>>$LOG_FILE
VALIDATE $? "step 6"

docker ps
VALIDATE $? "step 7"

docker images
VALIDATE $? "step 8"



