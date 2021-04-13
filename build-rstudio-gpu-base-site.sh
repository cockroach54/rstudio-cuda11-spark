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

NAME=rstudio-gpu-base-site
TAG="loca-1.0"

echo "Working for ${REGISTRY}/${NAME}:${TAG}"

repo_host=loca-repo1


# gpu ver
echo build gpu ver
docker build --build-arg repo_host=$repo_host --add-host $repo_host:10.36.20.53 -t ${REGISTRY}/${NAME}:${TAG} -f Dockerfile-${NAME} .

# docker image prune
