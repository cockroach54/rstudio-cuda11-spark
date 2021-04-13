#!/bin/bash -x

# ======================================================
#
# Licensed to the OBZEN
# Daemon Controller
#
# ======================================================

daemon_type=rstudio
echo "[INFO] ${daemon_type}_PROC_NAME:[${daemon_type}]"

PID=`ps -ef | grep "rstudio-server" | grep "rserver" | grep -v grep | awk '{print $2}'`
if [ -z "${PID:-}" ] 
then
    echo "${daemon_type} is not running... Process Name:[$daemon_type]"
    exit 1
else
    echo "${daemon_type} server is stopping... PID:[$PID]"
    rstudio-server stop
    sleep 2;
    
    loopcnt=0
    pscnt=0
    while [ $loopcnt -lt 5 ]; do
        pscnt=`ps -ef | grep "rstudio-server" | grep "rserver" | grep -v grep | wc -l`
        if [ $pscnt -ne 0 ]; then
            loopcnt=$(( $loopcnt + 1 ))
            sleep 2
        else
            break;
        fi
    done
    
    if [ $pscnt -eq 0 ]; then
        echo "${daemon_type} is stopped."
    else
        echo "FAILED to stop ${daemon_type}!  PID:[$PID]"
        echo "stop ${daemon_type} in force(kill -9)!"
        kill -9 $PID
    fi
fi

# kill other process (except 1 process)
SUB_PIDS=$(ps -ef --no-headers | grep -v "mgmt-rest" | grep -v "s6-svscan" | grep -v "s6-supervise" |  grep -v grep | awk '{print $2}')
for SUB_PID in $SUB_PIDS; do
    if [ $SUB_PID -ne 1 ]; then
        kill $SUB_PID
        echo "[INFO] sub_pid=$SUB_PID was killed" 
    fi
done

# confirm the process was killed
loopcnt=0
pscnt=`ps -ef --no-headers | grep -v "mgmt-rest" | grep -v "s6-svscan" | grep -v "s6-supervise" | grep -v grep | wc -l`
if [ $pscnt -ne 0 ]; then
    sleep 2
    SUB_PIDS=$(ps -ef --no-headers | grep -v "mgmt-rest" | grep -v "s6-svscan" | grep -v "s6-supervise" | grep -v grep | awk '{print $2}')
    for SUB_PID in $SUB_PIDS; do
        if [ $SUB_PID -ne 1 ]; then
            kill -9 $SUB_PID
            echo "[WARN] sub_pid=$SUB_PID was killed in force(kill -9)!" 
        fi
    done
fi
