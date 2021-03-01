lgbm은 현재 opencl 작동 에러로 미설치
sparklingr은 h2o context port configuration시 java class에러로 미설치
  - sparkling-shell scalar 버전은 가능
    - http://docs.h2o.ai/sparkling-water/3.0/latest-stable/doc/install/install_and_start.html#run-on-hadoop
  - CRAN은 더이상 유지보수 안하므로 아래 명령어로 직접 해당 버전 설치
    - install.packages("rsparkling", type = "source", repos = "http://h2o-release.s3.amazonaws.com/sparkling-water/spark-3.0/3.32.0.3-1-3.0/R")
    - http://docs.h2o.ai/sparkling-water/3.0/latest-stable/doc/rsparkling.html