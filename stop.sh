#!/bin/sh

if [ "$1" == "gpu" ]; then 
  # gpu ver
  echo stop gpu container and remove it.
  docker stop rstudio-test-gpu
  docker rm rstudio-test-gpu
else
  # cpu ver
  echo stop cpu container and remove it.
  docker stop rstudio-test
  docker rm rstudio-test
fi