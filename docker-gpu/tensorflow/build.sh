# docker build -t lsw-base:cuda11.0 --build-arg ARCH= .
repo_host=loca-repo1
docker build -t prireg:5000/rstudio-gpu-r-ver-base:loca-1.0 --add-host $repo_host:10.36.20.53 .
