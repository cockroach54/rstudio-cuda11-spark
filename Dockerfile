# FROM prireg:5000/rstudio-4.0:18.04
FROM rocker/rstudio:3.6.3-ubuntu18.04

ARG repo_host
RUN rm -rf /etc/apt/sources.list.d/*
ADD sources.list /etc/apt/sources.list
ADD pip.conf /etc/pip.conf
ADD Rprofile.site /etc/R/Rprofile.site
ADD Rprofile.site /usr/local/lib/R/etc/

# install java 1.8
RUN apt-get update && \
    apt-get --assume-yes install openjdk-8-jdk
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64


RUN apt install -y curl libssl-dev libcurl4-openssl-dev libxml2-dev libv8-dev libbz2-dev libpcre2-dev liblzma-dev &&\
  wget "http://$repo_host/etc/h2o-3.32.0.3.zip" -O ~/h2o-3.32.0.3.zip &&\
  wget "http://$repo_host/etc/icudt61l.zip" -O ~/icudt61l.zip &&\
  unzip ~/h2o-3.32.0.3.zip -d ~ &&\
  Rscript -e "install.packages(c('jsonlite', 'RCurl'), repos='http://$repo_host/cran')" &&\
  Rscript -e "install.packages('stringi', configure.vars='ICUDT_DIR=~', repos='http://$repo_host/cran')" &&\
  R CMD INSTALL ~/h2o-3.32.0.3/R/h2o_3.32.0.3.tar.gz &&\
  Rscript -e "install.packages(c('openxlsx', 'dplyr', 'tidyr', 'ggplot2',\
  'readxl', 'magrittr', 'treemap', 'plotly', 'data.table',\
  'zoo', 'rpart', 'rattle', 'lime', 'shiny', \
  'randomForest', 'reshape2', 'xgboost', 'reshape', 'gbm'), repos='http://$repo_host/cran')"

# for add JAVA_HOME config
RUN R CMD javareconf
RUN Rscript -e "install.packages(c('sparklyr', 'DBI', 'RJDBC'), repos='http://$repo_host/cran')"

# Set hadoop & spark environment variables
# 빅팀에서 전역변수 설정 지양하므로 hadoop-env.sh, spark-env.sh 등에서 런타임에 설정되도록 변경
# ENV HADOOP_HOME /usr/local/hadoop
# ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
# ENV SPARK_HOME /usr/local/spark
# ENV HIVE_HOME /usr/local/hive
# ENV PATH=${PATH}:${HADOOP_HOME}/bin:${SPARK_HOME}/bin:${HIVE_HOME}/bin
