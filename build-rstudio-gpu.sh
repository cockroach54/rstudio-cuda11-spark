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

NAME=rstudio-gpu
TAG="loca-1.0"

echo "Working for ${REGISTRY}/${NAME}:${TAG}"

docker build -t ${REGISTRY}/${NAME}:${TAG} -f Dockerfile-${NAME} .

