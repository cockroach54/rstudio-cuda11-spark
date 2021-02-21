# docker stop rstudio-test
# docker rm rstudio-test
# docker rmi rstudio-test:1.0
main_user=ecube
repo_host=loca-repo1


if [ "$1" == "gpu" ]; then 
  # gpu ver
  echo build gpu ver
  docker build --build-arg repo_host=$repo_host -t rstudio-test-gpu:cuda11.0 --add-host $repo_host:10.36.20.53 -f Dockerfile.gpu .
else
  # cpu ver
  echo build cpu only ver
  docker build --build-arg repo_host=$repo_host -t rstudio-test:1.1 --add-host $repo_host:10.36.20.53 -f Dockerfile .
fi

# docker image prune