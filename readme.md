# Rstudio with GPU Docker Container
- R(4.0.3)
- Rstudio(1.4.1103) 
- cuda(11.0)
- ubuntu 18.04

---

## directory 
- dev
  - deprecated files and some memo note
  - it is not need at runtime
- docker-gpu
  - parent docker image Dockerfiles with some binaries
  - [tensorflow] > [r-ver] > [rstudio] > [R packages](가장 바깥 Dockerfile) 순으로 빌드
- files
  - binaries for container
    - for repop setting
    - for shell command
    - ...
- hadoop-bin
  - for connection to HDFS Cluster
  - HADOOP Client 3.1.4
  - Spark Client 3.0.1
  - Hive 
- sample-rscript
  - sample script for packages

## build container
- CPU
  - `./build.sh`
- GPU
  - `./build.sh gpu`  

## demo
- user
  - `ecube`: hdfs, spark, rstudio 사용
  - `ruser01,02,03`: rstudio 만 사용, rgroup으로 묶여서 서로 홈디렉토리 읽기 가능
- CPU 버전 컨테이너는 R 3.6버전
  - 4.0.3 공식 버전에 처음 시작 안되는 오류 있음
  - 최적화 안되있어서 사용 비추천
- GPU  
  - CUDA 11.0 버전 사용
  - tensorflow, xgboost, h2o4gpu 패키지는 gpu에서 학습


---
## packages
![](etc/pkgs.png)

## dev tip
- 현재 r-ver 에서 R 설치 후 /usr/local/cuda 내의 일부 파일들이 삭제되는 에러 있음
  - NVCC 등도 날아가서 추후 패키지 빌드 불가
  - 지금은 마지막에 삭제된 바이너리 다시 COPY해주는 방법으로 임시 사용 중