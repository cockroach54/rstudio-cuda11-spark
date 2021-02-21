# docker build -t lsw-base:cuda11.0 --build-arg ARCH= .
repo_host=loca-repo1
docker build -t lsw-base:cuda11.0 --add-host $repo_host:10.36.20.53 .