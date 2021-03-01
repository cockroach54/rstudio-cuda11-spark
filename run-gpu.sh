#!/bin/sh

# MAIN_USER=ecube
MAIN_USER=$USER
NAME=rstudio-test-gpu
TAG=cuda11.0

echo "Working for dockr image [${NAME}:${TAG}]"


# docker run -it --rm \
docker run -it -d \
          --name ${NAME} \
          --add-host loca-repo1:10.36.20.53 \
          --add-host loca-edge1:10.36.8.112 \
          --add-host loca-name:10.36.15.24 \
          --add-host loca-dn-001:10.36.21.175 \
          --add-host loca-dn-002:10.36.9.27 \
          --add-host loca-dn-003:10.36.14.123 \
          --add-host loca-ml-gpu:10.41.40.154 \
          --gpus=all \
          -p 1880:8787 \
          -p 33001-33010:33001-33010 \
          -e SPARK_DRIVER_PORT=33001 \
          -e ROOT=TRUE \
          -e USER=$MAIN_USER -e PASSWORD=$MAIN_USER -e USERID=$(id -u $MAIN_USER) -e GROUPID=$(id -g $MAIN_USER) -e UMASK=002 \
          -v /fsobzen/workspace:/fsobzen/workspace:ro \
          -v /etc/localtime:/etc/localtime:ro \
          -v /home/$MAIN_USER/rstudio-spark-docker/sample-rscripts:/home/$MAIN_USER/sample-rscripts \
          ${NAME}:${TAG}

# spark web ui port 4040 은 sparkhistory 서버 있으므로 굳이 바인딩하지 않음

# [hadoop cluster web UI] : http://49.50.174.99:50070
# [yarn cluster web UI] : http://49.50.174.99:8088/cluster/apps/RUNNING
# [spark history] : http://118.67.132.19:10003/
