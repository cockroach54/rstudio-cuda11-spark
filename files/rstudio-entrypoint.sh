#!/bin/bash

#
# Copyright (c) Obzen.
#

set -e

# #####################
# # workspace
# #####################
source /etc/profile.d/hadoop-compilation.sh

#####################
# for Renviron.site
#####################
renvsite=$R_HOME/etc/Renviron.site
echo ""  >> $renvsite
echo "Set Renviron file..." >> $renvsite
echo "### for hdfs and spark" >> $renvsite
echo JAVA_HOME=${JAVA_HOME} >> $renvsite
echo HADOOP_HOME=${HADOOP_HOME} >> $renvsite
echo SPARK_HOME=${SPARK_HOME} >> $renvsite
echo HIVE_HOME=${HIVE_HOME} >> $renvsite
echo SPARK_DRIVER_PORT=${SPARK_DRIVER_PORT} >> $renvsite
echo SPARK_DRIVER_HOST_IP=${SPARK_DRIVER_HOST_IP} >> $renvsite
echo ""  >> $renvsite
echo "### for gpu" >> $renvsite
echo CUDA_HOME=${CUDA_HOME} >> $renvsite
echo LD_LIBRARY_PATH=${LD_LIBRARY_PATH} >> $renvsite
echo RETICULATE_PYTHON=${RETICULATE_PYTHON} >> $renvsite
echo TENSORFLOW_PYTHON=${TENSORFLOW_PYTHON} >> $renvsite
echo ""  >> $renvsite
echo ""  >> $renvsite


#####################
# result
#####################
echo "[INFO] PATH=$PATH"
echo "[INFO] SPARK_DRIVER_HOST_IP=$SPARK_DRIVER_HOST_IP"
echo "[INFO] HADOOP_CONF_DIR=$HADOOP_CONF_DIR"
# echo "[INFO] WORKSPACE_SHARE_GROUP=$WORKSPACE_SHARE_GROUP"
# echo "[INFO] WORKSPACE_SHARE_GROUP_UID=$WORKSPACE_SHARE_GROUP_UID"
# echo "[INFO] WORKSPACE_SHARE_GROUP_GID=$WORKSPACE_SHARE_GROUP_GID"
echo "[INFO] WEBDFS=$WEBDFS"
echo "Executing the command: $@"
exec "$@"

