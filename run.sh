#!/bin/sh

registry_url="prireg:5000"


NAME=rstudio-test
TAG="1.1"

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
          -p 8787:8787 \
          -p 4041:4041 -p 31001-31010:31001-31010 \
          -e ROOT=TRUE \
          -e USER=$main_user -e PASSWORD=$main_user -e USERID=$(id -u $main_user) -e GROUPID=$(id -g $main_user) -e UMASK=002 \
          -v /fsdata/usr_home/$main_user:/home/$main_user \
          -v /home/$main_user/rstudio-spark-notebook/hadoop-bin/hadoop:/usr/local/hadoop:ro \
          -v /home/$main_user/rstudio-spark-notebook/hadoop-bin/hive:/usr/local/hive:ro \
          -v /home/$main_user/rstudio-spark-notebook/hadoop-bin/spark:/usr/local/spark:ro \
          ${NAME}:${TAG}
          # rocker/rstudio:3.6.3-ubuntu18.04 bash

# -p 54321-54330:54321-54330 # for h2o 
# spark web ui port 4040 -> 4041
