#!/usr/bin/with-contenv bash 

# set application home
APP_HOME="$(dirname "$(cd "$(dirname "$0")"; "pwd")")"
echo "[INFO] MGMT_REST_HOME:[${APP_HOME}]"

JVM_SIZE=128M

# check "The mgmt-rest server is already running"
PID=`ps -ef | grep java | grep -v grep | grep ${APP_HOME} | grep MgmtRest | awk '{print $2}'`
if [ ! -z "$PID" ]; then
  echo "[WARN] The application is already running... PID[$PID], HOME[$APP_HOME]."
  exit 1
fi

JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
echo "[INFO] JAVA_HOME :$JAVA_HOME"

#
# JVM options. See http://java.sun.com/javase/technologies/hotspot/vmoptions.jsp for more details.
#
# ADD YOUR/CHANGE ADDITIONAL OPTIONS HERE
#
#JVM_OPTS="-Xms3g -Xmx3g -server -XX:+AggressiveOpts -XX:MaxMetaspaceSize=256m"
JVM_OPTS="-Xms$JVM_SIZE -Xmx$JVM_SIZE -server"

#
# Uncomment the following GC settings if you see spikes in your throughput due to Garbage Collection.
#
JVM_OPTS="\
    ${JVM_OPTS} \
    -XX:+UseG1GC"

#
# Uncomment to set preference for IPv4 stack.
#
JVM_OPTS="${JVM_OPTS} -Djava.net.preferIPv4Stack=true"

#
# Miscellaneous JVM options
#
JVM_OPTS="\
    ${JVM_OPTS} \
    -Dlog4j.configuration=file:${APP_HOME}/config/log4j.properties \
    -Drest.home=${APP_HOME}"

#
# Uncomment to set JMX opstions
#
#JMX_OPT="\
#    -Dcom.sun.management.jmxremote \
#    -Dcom.sun.management.jmxremote.port=9999 \
#    -Dcom.sun.management.jmxremote.ssl=false \
#    -Dcom.sun.management.jmxremote.authenticate=false"

# 
# set the event loop execute time to 10 seconds (note the input is in NS)
#
VERTX_OPT="-Ddaemon.home=$APP_HOME -Dvertx.options.maxEventLoopExecuteTime=100000000000"

MAIN_CLASS=com.obzen.workspace.MgmtRest

LIB=${APP_HOME}/libs
CLASSPATH=.:${APP_HOME}:${APP_HOME}/config:${LIB}/*
echo $CLASSPATH
RUN_JAVA=$JAVA_HOME/bin/java

exec $RUN_JAVA -cp $CLASSPATH ${VERTX_OPT:-} ${JMX_OPT:-} $JVM_OPTS $MAIN_CLASS

sleep 1
PID=$!
echo "[INFO] Mgmt REST server is started... PID:[$PID]"
