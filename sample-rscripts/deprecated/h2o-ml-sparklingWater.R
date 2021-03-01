library(sparklyr)

# Sys.setenv('SPARK_HOME' = '/usr/local/spark')
SPARK_DRIVER_PORT = Sys.getenv('SPARK_DRIVER_PORT')
SPARK_DRIVER_BLOCKMANAGER_PORT = as.numeric(SPARK_DRIVER_PORT)+1

# install.packages("rsparkling", type = "source", repos = "http://h2o-release.s3.amazonaws.com/sparkling-water/spark-3.0/3.32.0.3-1-3.0/R")
# http://docs.h2o.ai/sparkling-water/3.0/latest-stable/doc/rsparkling.html

library(rsparkling)

# set spark config
ipaddr = system('bash -c "hostname -I"', intern=TRUE)  # '172.17.0.X'
scfg = list(
  "spark.driver.host"="loca-ml-gpu",
  "spark.driver.port"=SPARK_DRIVER_PORT,
  "spark.driver.blockManager.port"=SPARK_DRIVER_BLOCKMANAGER_PORT,
  "spark.driver.bindAddress"=ipaddr,
  "spark.sql.catalogImplementation"="hive",
  "spark.hadoop.fs.permissions.umask-mode"="000",
  "hive.metastore.uris"="thrift://loca-edge1:9083",
  "spark.sql.warehouse.dir"="/user/hive/warehouse"
)


# connect to spark
sc = spark_connect(
  master='yarn',
  app_name = 'sparklingWater-r-test',
  config = scfg
)

# sc = spark_connect(master = "local")



# disconnect spark session
spark_disconnect(sc)


# Sys.setenv(HADOOP_HOME="/usr/local/hadoop")
# Sys.setenv(HADOOP_CONF_DIR="/usr/local/hadoop/etc/hadoop")
# Sys.setenv(MASTER="yarn")

h2oConf = H2OConf()

h2oConf$set("spark.ext.h2o.base.port", 31009)
h2oConf$set("spark.ext.h2o.cloud.name", "haha")
h2oConf$set("spark.ext.h2o.cloud.timeout", 50000)

h2oConf$basePort()
h2oConf$setClientBasePort('31009')


hc = H2OContext.getOrCreate()


iris = spark_read_csv(sc, path='/user/ecube/iris.csv')

# library(dplyr)
iris_sdf <- copy_to(sc, iris, overwrite = TRUE)
iris_hdf = hc$asH2OFrame(iris_sdf)




library(h2o)

# # init h2o 
# h2o.init()
# 
# # get data
# iris = h2o.importFile('iris.csv')
# print(iris)

# split train/test data
data = h2o.splitFrame(iris_hdf, ratios=0.8, seed = 777)
names(data) = c("train","test")

# train mdoel
model = h2o.glm(
  training_frame = data$train, 
  validation_frame = data$test, 
  y = 'Species',
  family='multinomial',
  solver='L_BFGS'
)
# model = h2o.xgboost(
#   training_frame = data$train,
#   validation_frame = data$test,
#   y = 'Species' 
# )


# show confusion matrix
h2o.confusionMatrix(model, valid=T)

# show model result
summary(model)
perf = h2o.performance(model, newdata=data$test)
h2o.mean_per_class_error(perf)  # https://docs.h2o.ai/h2o/latest-stable/h2o-docs/performance-and-prediction.html

# plot variable importance
h2o.varimp_plot(model)

# predict for new data
h2o.predict(model, newdata=data$test)


# stop h2o
h2o.shutdown()

