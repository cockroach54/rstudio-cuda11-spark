#!/bin/sh

if [ -z "$1" ]; then 
  echo "No argument supplied exit process"
  exit 1
fi

docker run -it --rm --gpus=all $1 bash