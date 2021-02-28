library(sparklyr)

# set SPARK_HOME environment variable
# Sys.setenv('SPARK_HOME' = '/usr/local/spark')
SPARK_DRIVER_HOST_IP = Sys.getenv('SPARK_DRIVER_HOST_IP')  # system('bash -c "hostname -I"', intern=TRUE)  # '172.17.0.X'
SPARK_DRIVER_PORT = Sys.getenv('SPARK_DRIVER_PORT')
SPARK_DRIVER_BLOCKMANAGER_PORT = as.numeric(SPARK_DRIVER_PORT)+1
Sys.setenv('MASTER'='yarn')
Sys.setenv('HADOOP_CONF_DIR'='/fsobzen/workspace/hadoop/etc/hadoop')
Sys.setenv('SPARK_CONF_DIR'='/fsobzen/workspace/spark/conf')

# set spark config
scfg = list(
  "spark.driver.host"="loca-ml-gpu",
  "spark.driver.port"=SPARK_DRIVER_PORT,
  "spark.driver.blockManager.port"=SPARK_DRIVER_BLOCKMANAGER_PORT,
  "spark.driver.bindAddress"=SPARK_DRIVER_HOST_IP,
  "spark.sql.catalogImplementation"="hive",
  "spark.hadoop.fs.permissions.umask-mode"="000",
  "hive.metastore.uris"="thrift://loca-edge1:9083",
  "spark.sql.warehouse.dir"="/user/hive/warehouse",
  "spark.driver.extraClassPath"="sparkling-water-assembly_2.12-3.32.0.3-1-3.0-all.jar",
  "spark.executor.extraClassPath"="sparkling-water-assembly_2.12-3.32.0.3-1-3.0-all.jar"
)
#scfg$sparklyr.jars.default <- "/fsobzen/workspace/hive/jdbc/hive-jdbc-3.1.2-standalone.jar"
scfg$sparklyr.jars.default <- "/fsobzen/workspace/hive/lib/hive-jdbc-3.1.2.jar"
Sys.setenv('CLASSPATH'='/fsobzen/workspace/hadoop/etc/hadoop:/fsobzen/workspace/hadoop/share/hadoop/common/lib/*:/fsobzen/workspace/hadoop/share/hadoop/common/*:/fsobzen/workspace/hadoop/share/hadoop/hdfs:/fsobzen/workspace/hadoop/share/hadoop/hdfs/lib/*:/fsobzen/workspace/hadoop/share/hadoop/hdfs/*:/fsobzen/workspace/hadoop/share/hadoop/mapreduce/lib/*:/fsobzen/workspace/hadoop/share/hadoop/mapreduce/*:/fsobzen/workspace/hadoop/share/hadoop/yarn:/fsobzen/workspace/hadoop/share/hadoop/yarn/lib/*:/fsobzen/workspace/hadoop/share/hadoop/yarn/*')
Sys.setenv('HADOOP_CLASSPATH'='/fsobzen/workspace/hadoop/etc/hadoop:/fsobzen/workspace/hadoop/share/hadoop/common/lib/*:/fsobzen/workspace/hadoop/share/hadoop/common/*:/fsobzen/workspace/hadoop/share/hadoop/hdfs:/fsobzen/workspace/hadoop/share/hadoop/hdfs/lib/*:/fsobzen/workspace/hadoop/share/hadoop/hdfs/*:/fsobzen/workspace/hadoop/share/hadoop/mapreduce/lib/*:/fsobzen/workspace/hadoop/share/hadoop/mapreduce/*:/fsobzen/workspace/hadoop/share/hadoop/yarn:/fsobzen/workspace/hadoop/share/hadoop/yarn/lib/*:/fsobzen/workspace/hadoop/share/hadoop/yarn/*')
Sys.setenv('SPARK_DIST_CLASSPATH'='/fsobzen/workspace/hadoop/etc/hadoop:/fsobzen/workspace/hadoop/share/hadoop/common/lib/*:/fsobzen/workspace/hadoop/share/hadoop/common/*:/fsobzen/workspace/hadoop/share/hadoop/hdfs:/fsobzen/workspace/hadoop/share/hadoop/hdfs/lib/*:/fsobzen/workspace/hadoop/share/hadoop/hdfs/*:/fsobzen/workspace/hadoop/share/hadoop/mapreduce/lib/*:/fsobzen/workspace/hadoop/share/hadoop/mapreduce/*:/fsobzen/workspace/hadoop/share/hadoop/yarn:/fsobzen/workspace/hadoop/share/hadoop/yarn/lib/*:/fsobzen/workspace/hadoop/share/hadoop/yarn/*')
library(h2o)
library(rsparkling)

# connect to spark
options(sparklyr.log.console = TRUE)
options("sparklyr.log.console" = TRUE)
options(rsparkling.sparklingwater.version = "3.0.1")
options(rsparkling.sparklingwater.location = "/home/ecube/sparkling-water/jars/sparkling-water-assembly_2.12-3.32.0.3-1-3.0-all.jar")
sc = spark_connect(
  master='yarn',
  app_name = 'sparklyr-hive-test',
  config = scfg,
  version = "3.0.1"
)

# Spin-up an External H2O Cluster
# Run on a HOST, not a CONTAINER
# ... 과연 일반 사용자에게 Edge Node에 접근 권한을 줄지??
# mkdir h2o-external
# cd h2o-external
# wget http://loca-repo1/etc/h2o-3.32.0.3-hdp3.1.zip
# wget http://loca-repo1/etc/sparkling-water-3.32.0.3-1-3.0.zip
# unzip h2o-3.32.0.3-hdp3.1.zip
# ln -s h2o-3.32.0.3-hdp3.1 h2o
# unzip sparkling-water-3.32.0.3-1-3.0.zip
# ln -s sparkling-water-3.32.0.3-1-3.0 sparkling-water
# H2O_DRIVER_JAR=h2o/h2odriver.jar
# SW_EXTENSIONS_ASSEMBLY=sparkling-water/jars/sparkling-water-assembly-extensions_2.12-3.32.0.3-1-3.0-all.jar
# hadoop jar $H2O_DRIVER_JAR -libjars $SW_EXTENSIONS_ASSEMBLY -sw_ext_backend -jobname test-h2o -nodes 3 -mapperXmx 8g -driverport 33009

# Create H2O Context using External Kluster
h2oConf <- H2OConf()
h2oConf$set("spark.ext.h2o.user.name", "ecube")
h2oConf$set("spark.ext.h2o.password", "ecube")
#h2oConf$set("spark.ext.h2o.node.network.mask", "ecube")
h2oConf$set("spark.ext.h2o.cluster.start.timeout", "3000")
#h2oConf$set("spark.ext.h2o.external.driver.if", "loca-ml-gpu")
h2oConf$set("spark.ext.h2o.external.driver.if", "loca-ml-gpu")
h2oConf$set("spark.ext.h2o.external.driver.port", "33010")
h2oConf$set("spark.ext.h2o.external.start.mode", "auto")
h2oConf$set("spark.ext.h2o.external.auto.start.backend", "yarn")
h2oConf$set("spark.ext.h2o.external.cluster.size", "3")
h2oConf$set("spark.ext.h2o.external.h2o.driver", "/home/ecube/h2o/h2odriver.jar")
h2oConf$set("spark.ext.h2o.external.yarn.queue", "root.ecube")
h2oConf$set("spark.ext.h2o.external.run.as.user", "ecube")
h2oConf$set("spark.ext.h2o.external.hdfs.dir", "/user/ecube/")
h2oConf$set("spark.ext.h2o.cluster.info.name", "notify_container-ecube-h2o")
#h2oConf$set("spark.ext.h2o.node.network.mask", "10.36.0.0")
# h2oConf$set("spark.ext.h2o.cloud.name", "container-ecube-h2o")
h2oConf$set("spark.ext.h2o.backend.cluster.mode", "external")
h2oConf$set("spark.ext.h2o.base.port", "33008")
# h2oConf$set("spark.ext.h2o.external.extra.jars", "/home/ecube/sparkling-water/jars/sparkling-water-assembly-extensions_2.12-3.32.0.3-1-3.0-all.jar")
h2oConf$set("spark.ext.h2o.fail.on.unsupported.spark.param", "false")
#h2oConf$set("spark.ext.h2o.cloud.representative", "10.36.9.27:54321")
#h2oConf$setBasePort(33010)
hc <- H2OContext.getOrCreate(h2oConf)

# check connection here http://49.50.174.99:8088/cluster
library(dplyr)
mtcars_tbl <- copy_to(sc, mtcars, overwrite = TRUE)
mtcars_tbl

mtcars_hf <- hc$asH2OFrame(mtcars_tbl)
mtcars_hf

y <- "mpg"
x <- setdiff(names(mtcars_hf), y)

splits <- h2o.splitFrame(mtcars_hf, ratios = 0.7, seed = 1)

fit <- h2o.gbm(x = x,
               y = y,
               training_frame = splits[[1]],
               min_rows = 1,
               seed = 1)
print(fit)

aml <- h2o.automl(x, y, training_frame =  splits[[1]], validation_frame = splits[[2]], max_runtime_secs = 30)
print(aml)
lb <- h2o.get_leaderboard(aml)
aml_fit <- h2o.getModel(lb[1,1])

perf <- h2o.performance(aml_fit, newdata = splits[[2]])
print(perf)

pred_hf <- h2o.predict(aml_fit, newdata = splits[[2]])
head(pred_hf)

pred_sdf <- hc$asSparkFrame(pred_hf)
head(pred_sdf)

spark_write_table(mtcars_tbl, "default.mtcars_tbl")
spark_write_table(pred_sdf, "default.pred_sdf")

dbGetQuery(sc, "SELECT * FROM default.mtcars_tbl")
dbGetQuery(sc, "SELECT * FROM default.pred_sdf")

# disconnect spark session
spark_disconnect(sc)
