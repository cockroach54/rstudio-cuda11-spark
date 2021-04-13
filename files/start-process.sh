#!/bin/bash -x

# ======================================================
#
# Licensed to the OBZEN
# Daemon Controller
#
# ======================================================

daemon_type=rstudio

# check "The rstudio server is already running"
PID=`ps -ef | grep "rstudio-server" | grep "rserver" | grep -v grep | awk '{print $2}'`
if [ ! -z "$PID" ]; then
  echo "[WARN] The R-Sdtudio server is already running... PID[$PID]."
  exit 0
fi

for line in $( cat /etc/environment ) ; do export $line > /dev/null; done
nohup rstudio-server start > /dev/null 2>&1 &
#nohup /usr/local/bin/${daemon_type}-entrypoint.sh rstudio-server start > /dev/null 2>&1 &

sleep 1

PID=$!
echo "${daemon_type} is started... PID:[$PID]"
