#!/bin/bash

export REPO_HOST=loca-repo1
export NAMENODE_HOST=loca-name
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
