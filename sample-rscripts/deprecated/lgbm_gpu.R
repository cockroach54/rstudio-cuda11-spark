# https://github.com/microsoft/LightGBM/tree/master/R-package/demo

library(lightgbm)
library(methods)

# Load in the agaricus dataset
data(agaricus.train, package = "lightgbm")
data(agaricus.test, package = "lightgbm")
dtrain <- lgb.Dataset(agaricus.train$data, label = agaricus.train$label)
dtest <- lgb.Dataset.create.valid(dtrain, data = agaricus.test$data, label = agaricus.test$label)

valids <- list(eval = dtest, train = dtrain)
#--------------------Advanced features ---------------------------
# advanced: start from an initial base prediction
print("Start running example to start from an initial prediction")

# Train lightgbm for 1 round
param <- list(
    num_leaves = 4L
    , learning_rate = 1.0
    , nthread = 2L
    , objective = "binary"
    , device = "gpu"
)
bst <- lgb.train(param, dtrain, 1L, valids = valids)

# Note: we need the margin value instead of transformed prediction in set_init_score
ptrain <- predict(bst, agaricus.train$data, rawscore = TRUE)
ptest  <- predict(bst, agaricus.test$data, rawscore = TRUE)
