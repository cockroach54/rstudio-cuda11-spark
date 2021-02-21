library(sparklyr)

# set SPARK_HOME environment variable
Sys.setenv('SPARK_HOME' = '/usr/local/spark')
SPARK_DRIVER_PORT = Sys.getenv('SPARK_DRIVER_PORT')
SPARK_DRIVER_BLOCKMANAGER_PORT = as.numeric(SPARK_DRIVER_PORT)+1

# set spark config
ipaddr = system('bash -c "hostname -I"', intern=TRUE)  # '172.17.0.X'
scfg = list(
  "spark.driver.host"="loca-ml-gpu",
  "spark.driver.port"=SPARK_DRIVER_PORT,
  "spark.driver.blockManager.port"=SPARK_DRIVER_BLOCKMANAGER_PORT,
  "spark.driver.bindAddress"=ipaddr
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
