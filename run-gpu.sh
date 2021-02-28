#!/bin/sh

NAME=rstudio-test-gpu
TAG=cuda11.0

echo "Working for ${NAME}:${TAG}"

# main_user=ecube
main_user=$USER
mkdir -p /fsdata/usr_home/$main_user
chown $main_user:$main_user /fsdata/usr_home/$main_user
chmod 770 /fsdata/usr_home/$main_user

# https://hub.docker.com/r/rocker/rstudio
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
          -e USER=$main_user -e PASSWORD=$main_user -e USERID=$(id -u $main_user) -e GROUPID=$(id -g $main_user) -e UMASK=002 \
          -v /fsobzen/workspace:/fsobzen/workspace:ro \
          -v /etc/localtime:/etc/localtime:ro \
          -v /home/$main_user/rstudio-spark-docker/sample-rscripts:/home/$main_user/sample-rscripts \
          ${NAME}:${TAG}
          # -v /fsdata/usr_home/$main_user:/home/$main_user \
          # ${NAME}:${TAG} bash

