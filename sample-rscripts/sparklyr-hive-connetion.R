library(sparklyr)

# set SPARK_HOME environment variable
# Sys.setenv('SPARK_HOME' = '/usr/local/spark')
SPARK_DRIVER_HOST_IP = Sys.getenv('SPARK_DRIVER_HOST_IP')  # system('bash -c "hostname -I"', intern=TRUE)  # '172.17.0.X'
SPARK_DRIVER_PORT = Sys.getenv('SPARK_DRIVER_PORT')
SPARK_DRIVER_BLOCKMANAGER_PORT = as.numeric(SPARK_DRIVER_PORT)+1

# set spark config
scfg = list(
  "spark.driver.host"="loca-ml-gpu",
  "spark.driver.port"=SPARK_DRIVER_PORT,
  "spark.driver.blockManager.port"=SPARK_DRIVER_BLOCKMANAGER_PORT,
  "spark.driver.bindAddress"=SPARK_DRIVER_HOST_IP,
  "spark.sql.catalogImplementation"="hive",
  "spark.hadoop.fs.permissions.umask-mode"="000",
  "hive.metastore.uris"="thrift://loca-edge1:9083",
  "spark.sql.warehouse.dir"="/user/hive/warehouse"
)

# connect to spark
sc = spark_connect(
  master='yarn',
  app_name = 'sparklyr-hive-test',
  config = scfg
)

# check connection here http://49.50.174.99:8088/cluster


# load data from local
library(data.table)
df = as.data.table(iris)
# df = fread('~/iris.csv') # loiad from file system

# make data.table spark.dataframe
# it saved as temporary view
sdf = copy_to(sc, df, 'iris', overwrite = TRUE)
print(sdf)

# help for query DB easily
library(DBI)
dbGetQuery(sc, "SHOW DATABASES")
# can do same thing as below
# invoke(hive_context(sc), 'sql', 'SHOW DATABASES') %>% collect()

# save temporary view as hive table
dbGetQuery(sc, "CREATE TABLE IF NOT EXISTS default.test_iris AS SELECT * FROM iris")
# can check real data path with command below
# /usr/local/hadoop/bin/hdfs dfs -ls /user/hive/warehouse

# disconnect spark session
spark_disconnect(sc)
