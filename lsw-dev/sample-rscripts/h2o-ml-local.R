library(h2o)

# init h2o 
h2o.init()

# get data
iris_hdf = as.h2o(iris)
# iris_hdf = h2o.importFile('iris.csv')  # data from local file
print(iris_hdf)

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

