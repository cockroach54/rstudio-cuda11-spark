library(sparklyr)

# set SPARK_HOME environment variable
# Sys.setenv('SPARK_HOME' = '/usr/local/spark')
# SPARK_DRIVER_HOST_IP = Sys.getenv('SPARK_DRIVER_HOST_IP')  # 현재 entrypoint에 호스트 주소로 하드코딩되어 있어서 에러남
SPARK_DRIVER_HOST_IP = system('bash -c "hostname -i"', intern=TRUE)  # '172.17.0.X' (컨테이너의 주소 필요)
SPARK_DRIVER_PORT = Sys.getenv('SPARK_DRIVER_PORT')
SPARK_DRIVER_BLOCKMANAGER_PORT = as.numeric(SPARK_DRIVER_PORT)+1

# set spark config
scfg = list(
  "spark.driver.host"="loca-ml-gpu",
  "spark.driver.port"=SPARK_DRIVER_PORT,
  "spark.driver.blockManager.port"=SPARK_DRIVER_BLOCKMANAGER_PORT,
  "spark.driver.bindAddress"=SPARK_DRIVER_HOST_IP
)


# connect to spark
sc = spark_connect(
  master='yarn',
  app_name = 'sparklyr-connection-test',
  config = scfg
)


# check connection here http://49.50.174.99:8088/cluster

# disconnect spark session
spark_disconnect(sc)
