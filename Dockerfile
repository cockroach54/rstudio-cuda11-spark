# cpu only ver
FROM lsw-rstudio:cpu

ARG repo_host
RUN rm -rf /etc/apt/sources.list.d/*
ADD files/sources.list /etc/apt/sources.list
ADD files/pip.conf /etc/pip.conf
ADD files/Rprofile.site /etc/R/Rprofile.site
ADD files/Rprofile.site /usr/local/lib/R/etc/

# install java 1.8
RUN apt-get update && \
    apt-get --assume-yes install openjdk-8-jdk
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64


RUN apt install -y curl libssl-dev libcurl4-openssl-dev libxml2-dev libv8-dev libbz2-dev libpcre2-dev liblzma-dev &&\
  Rscript -e "install.packages(c('jsonlite', 'RCurl'), repos='http://$repo_host/cran')" &&\
  Rscript -e "install.packages('stringi', configure.vars='ICUDT_DIR=~', repos='http://$repo_host/cran')" &&\
  Rscript -e "install.packages(c('openxlsx', 'dplyr', 'tidyr', 'ggplot2',\
  'readxl', 'magrittr', 'treemap', 'plotly', 'data.table',\
  'zoo', 'rpart', 'rattle', 'lime', 'shiny', \
  'randomForest', 'reshape2', 'xgboost', 'reshape', 'gbm'), repos='http://$repo_host/cran')"


# ----------sparklyR----------
# for add JAVA_HOME config
# rsparkling은 CRAN버전은 유지보수 안되므로 직접 레포에서 설치
# install.packages("rsparkling", type = "source", repos = "http://h2o-release.s3.amazonaws.com/sparkling-water/spark-3.0/3.32.0.3-1-3.0/R")
RUN R CMD javareconf &&\
    Rscript -e "install.packages(c('sparklyr', 'DBI', 'RJDBC'))"


# ----------h2o----------
COPY files/h2o-3.32.0.3.zip /usr/local/h2o-3.32.0.3.zip
RUN  unzip /usr/local/h2o-3.32.0.3.zip -d /usr/local &&\
  R CMD INSTALL /usr/local/h2o-3.32.0.3/R/h2o_3.32.0.3.tar.gz &&\
  rm /usr/local/h2o-3.32.0.3.zip &&\
  rm -rf h2o-3.32.0.3


# ------------set system env and Renviron.site for Rstudio
COPY ./files/hadoop-compilation.sh /etc/profile.d/
COPY ./files/rstudio-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/rstudio-entrypoint.sh"]
CMD ["/init"]