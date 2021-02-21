#!/bin/bash

if [ -z "$1" ]; then 
  echo "No argument supplied exit process"
  exit 1
fi
new_user=$1

# R 유저 더 필요한 경우 ruser01, ruser02도 생성
# host os에 계정 없으므로 hdfs, spark는 사용불가, R은 사용 가능
groupadd rgroup 
new_user=lsw
useradd -m $new_user -g rgroup -G sudo 
echo -e "$new_user\n$new_user"| passwd $new_user 