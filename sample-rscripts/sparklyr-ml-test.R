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
  app_name = 'sparklyr-ml-test',
  config = scfg
)

# check connection here http://49.50.174.99:8088/cluster


# load data from HDFS
movies = spark_read_csv(sc, path='/user/ecube/ratings/movie.csv')
ratings = spark_read_csv(
  sc, 
  path='/user/ecube/ratings/ratings.csv',
  infer_schema=FALSE,
  columns = list(
    'idx' = 'integer',
    'userId'='integer',
    'movieId'='integer',
    'rating'='double',
    'timestamp'='character'
  )
)


# show data dimension
print(c(sdf_nrow(movies), sdf_ncol(movies)))
print(c(sdf_nrow(ratings), sdf_ncol(ratings)))



# make preference column for ALS
library(dplyr)
ratings = ratings %>%
  mutate(preference = if_else(rating>=4, 1, 0))

# https://spark.rstudio.com/mlib/
# split data
partitions = sdf_random_split(ratings, training = 0.80, test = 0.20, seed = 777)

# train ALS model
# https://spark.rstudio.com/reference/ml_als.html
model = ml_als(
  partitions$training,
  max_iter = 10,
  rating_col = 'preference',
  user_col = 'userId',
  item_col = 'movieId',
  cold_start_strategy = 'drop'
)

# predict ratings
predictions = ml_predict(model, partitions$test)
print(predictions)

# recommend items
recommends = ml_recommend(model, type='item', n=1)
print(recommends)

# disconnect spark session
spark_disconnect(sc)
