#!/bin/bash
REPOSITORY=/home/ubuntu/app

echo "> 현재 구동중인 애플리케이션 pid 확인"

# 수행 중인 애플리케이션 프로세스 ID => 구동 중이면 종료하기 위함
CURRENT_PID=$(pgrep -fla java | grep jar | awk '{print $1}')

echo "현재 구동중인 어플리케이션 pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
    echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
    echo "> kill -15 $CURRENT_PID"
    kill -15 $CURRENT_PID
    sleep 5
fi

echo "> 새 어플리케이션 배포"

JAR_NAME=$(ls -tr $REPOSITORY/*SNAPSHOT.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

chmod +x $JAR_NAME # Jar 파일은 실행 권한이 없는 상태이므로 권한 부여

echo "> $JAR_NAME 실행"

nohup java -jar -Dspring.config.location=classpath:/application.yml,/home/ubuntu/app/application-real-db.yml $JAR_NAME > /home/ubuntu/nohup.out 2>&1 &


