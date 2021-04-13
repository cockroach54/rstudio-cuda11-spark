library(h2o4gpu)


# Setup dataset
x <- iris[1:4]
y <- as.integer(iris$Species) - 1

# Initialize and train the classifier
model <- h2o4gpu.random_forest_classifier() %>% fit(x, y)
### 아래 모형들은 아직 h2o4gpu가 개발단계라서 그런지 제대로 수행되지 않음
# model <- h2o4gpu.gradient_boosting_classifier(objective='multi:softmax') %>% fit(x, y)
# model <- h2o4gpu.kmeans(n_clusters=3) %>% fit(x)

# Make predictions
predictions <- model %>% predict(x)
print(predictions)

