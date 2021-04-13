#!/bin/sh

registry_url="prireg:5000"

if [ -z "$1" ]
then 
  echo "No argument supplied, set registry to ${registry_url}"
    REGISTRY=${registry_url}
  else
    echo "Set registry to $1"
    REGISTRY=$1
fi

NAME=rstudio-cpu-base-site
TAG=loca-1.0


#################################
# Workspace
WORKSPACE_USER="ecube02"
WORKSPACE_SHARE_GROUP="locas"
WORKSPACE_SHARE_GROUP_DIR="locas"
NB_UID=$(id -u $WORKSPACE_USER)
NB_GID=$(id -g $WORKSPACE_USER)
WORKSPACE_SHARE_GROUP_UID=65534
WORKSPACE_SHARE_GROUP_GID=5002

#################################
# Spark
SPARK_DRIVER_PORT="33005"
SPARK_DRIVER_BLOCMANAGER_PORT="33006"

#################################
# Jupyter
JUPYTER_TOKEN="ecubetoken"
RSTUDIO_WEB_PORT="1880"
# H2O_PORT="64323"

echo "Working for docker image [${NAME}:${TAG}]"

# docker run -it --rm \
docker run -it -d \
           --name lsw-test \
           -e USER=$WORKSPACE_USER -e PASSWORD=$WORKSPACE_USER -e USERID=$(id -u $WORKSPACE_USER) -e GROUPID=$(id -g $WORKSPACE_USER) \
           -e WORKSPACE_SHARE_GROUP=$WORKSPACE_SHARE_GROUP \
           -e WORKSPACE_SHARE_GROUP_UID=$WORKSPACE_SHARE_GROUP_UID \
           -e WORKSPACE_SHARE_GROUP_GID=$WORKSPACE_SHARE_GROUP_GID \
           -e SPARK_DRIVER_PORT=$SPARK_DRIVER_PORT \
           -e SPARK_DRIVER_BLOCMANAGER_PORT=$SPARK_DRIVER_BLOCMANAGER_PORT \
           -p $RSTUDIO_WEB_PORT:8787 \
           -p $SPARK_DRIVER_PORT:$SPARK_DRIVER_PORT \
           -p $SPARK_DRIVER_BLOCMANAGER_PORT:$SPARK_DRIVER_BLOCMANAGER_PORT \
           -v /home/$USER/workspace-rstudio/lsw-dev/sample-rscripts:/home/$WORKSPACE_USER/sample-rscripts \
           -v /fsobzen/workspace:/fsobzen/workspace:ro \
           -v /mnt/repo/share/$WORKSPACE_SHARE_GROUP_DIR:/share \
           -v /mnt/repo/user/$WORKSPACE_USER:/user \
           -v /etc/localtime:/etc/localtime:ro \
           ${REGISTRY}/${NAME}:${TAG}

# spark web ui port 4040 은 spark history 서버 있으므로 굳이 바인딩하지 않음

# [hadoop cluster web UI] : http://49.50.174.99:50070
# [yarn cluster web UI] : http://49.50.174.99:8088/cluster/apps/RUNNING
# [spark history] : http://118.67.132.19:10003/
