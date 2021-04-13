#!/usr/bin/with-contenv bash

#
# Copyright (c) Obzen.
#

set -x


#####################
# rstudio
export ROOT=TRUE
export UMASK=002

#####################
# workspace
export REPO_HOST=loca-repo1
export NAMENODE_HOST=loca-name
export HIVE_HOST=loca-edge1

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/fsobzen/workspace/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export SPARK_HOME=/fsobzen/workspace/spark
export SPARK_DIST_CLASSPATH=$($HADOOP_HOME/bin/hadoop classpath)
export HIVE_HOME=/fsobzen/workspace/hive
export HIVE_CONF_DIR=$HIVE_HOME/conf
export WEBDFS=http://$NAMENODE_HOST:14000
export MASTER=yarn
export PATH=$PATH:$HADOOP_HOME/bin:$SPARK_HOME/bin:$HIVE_HOME/bin

#####################
# spark
#export SPARK_DRIVER_HOST_IP=10.41.40.154
export SPARK_DRIVER_HOST_IP=$SPARK_DRIVER_HOST_IP
export SPARK_DRIVER_PORT=$SPARK_DRIVER_PORT
export SPARK_DRIVER_BLOCMANAGER_PORT=$SPARK_DRIVER_BLOCMANAGER_PORT

#####################
# for Renviron.site
#####################
renvsite=$R_HOME/etc/Renviron.site
echo ""  >> $renvsite
echo "### Set Renviron file..." >> $renvsite
echo "### for hdfs and spark" >> $renvsite
echo JAVA_HOME=${JAVA_HOME} >> $renvsite
echo HADOOP_HOME=${HADOOP_HOME} >> $renvsite
echo HADOOP_CONF_DIR=${HADOOP_CONF_DIR} >> $renvsite
echo SPARK_HOME=${SPARK_HOME} >> $renvsite
echo HIVE_HOME=${HIVE_HOME} >> $renvsite
echo HIVE_HOST=${HIVE_HOST} >> $renvsite
echo SPARK_DRIVER_PORT=${SPARK_DRIVER_PORT} >> $renvsite
echo SPARK_DRIVER_BLOCMANAGER_PORT=${SPARK_DRIVER_BLOCMANAGER_PORT} >> $renvsite
echo SPARK_DRIVER_HOST_IP=${SPARK_DRIVER_HOST_IP} >> $renvsite
echo SPARK_DIST_CLASSPATH=${SPARK_DIST_CLASSPATH} >> $renvsite
echo WEBDFS=${WEBDFS} >> $renvsite
echo TZ=${TZ} >> $renvsite
echo ""  >> $renvsite
echo "### for gpu" >> $renvsite
echo CUDA_HOME=${CUDA_HOME} >> $renvsite
echo LD_LIBRARY_PATH=${LD_LIBRARY_PATH} >> $renvsite
echo RETICULATE_PYTHON=${RETICULATE_PYTHON} >> $renvsite
echo TENSORFLOW_PYTHON=${TENSORFLOW_PYTHON} >> $renvsite
echo ""  >> $renvsite
echo ""  >> $renvsite

#####################
# /etc/hosts
echo "10.36.20.53   loca-repo1" >> /etc/hosts
echo "10.41.40.154  loca-ml-gpu" >> /etc/hosts
echo "10.36.21.221  loca-ecube1" >> /etc/hosts
echo "10.36.8.112   loca-edge1" >> /etc/hosts
echo "10.36.15.24   loca-name" >> /etc/hosts
echo "10.36.21.175  loca-dn-001" >> /etc/hosts
echo "10.36.9.27    loca-dn-002" >> /etc/hosts
echo "10.36.14.123  loca-dn-003" >> /etc/hosts

# Allow the container to be started with `--user`
if [ "$(id -u)" = '0' ]; then
    chmod 4755 /usr/bin/sudo
fi

######################################################
# set pip.conf
######################################################
export PIP_FILE=/etc/pip.conf
sed -i -e "s/loca-repo1/${REPO_HOST}/g" ${PIP_FILE}
echo "[INFO] Setting $PIP_FILE has done (repo_host=${REPO_HOST}) !"

######################################################
# set sources.list
######################################################
export SOURCES_LIST_FILE=/etc/apt/sources.list
sed -i -e "s/loca-repo1/${REPO_HOST}/g" ${SOURCES_LIST_FILE}
echo "[INFO] Setting $SOURCES_LIST_FILE has done (repo_host=${REPO_HOST}) !"

echo "[INFO] PATH=$PATH"
echo "[INFO] SPARK_DRIVER_HOST_IP=$SPARK_DRIVER_HOST_IP"
echo "[INFO] SPARK_DRIVER_PORT=$SPARK_DRIVER_PORT"
echo "[INFO] SPARK_DRIVER_BLOCMANAGER_PORT=$SPARK_DRIVER_BLOCMANAGER_PORT"
echo "[INFO] HADOOP_CONF_DIR=$HADOOP_CONF_DIR"
echo "[INFO] WORKSPACE_SHARE_GROUP=$WORKSPACE_SHARE_GROUP"
echo "[INFO] WORKSPACE_SHARE_GROUP_UID=$WORKSPACE_SHARE_GROUP_UID"
echo "[INFO] WORKSPACE_SHARE_GROUP_GID=$WORKSPACE_SHARE_GROUP_GID"
echo "[INFO] WEBDFS=$WEBDFS"
echo "[INFO] Strarting the R-Studio server by ${USER} (${USERID}:${GROUPID}) !"
#echo "Executing the command: $@"
#exec "$@"
