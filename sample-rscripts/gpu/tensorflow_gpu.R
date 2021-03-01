library(keras)

# Let’s start by loading and preparing the MNIST dataset. The values of thee pixels are integers between 0 and 255 and we will convert them to floats between 0 and 1.
mnist <- dataset_mnist()
mnist$train$x <- mnist$train$x/255
mnist$test$x <- mnist$test$x/255

# Now, let’s define the a Keras model using the sequential API.
model <- keras_model_sequential() %>% 
  layer_flatten(input_shape = c(28, 28)) %>% 
  layer_dense(units = 128, activation = "relu") %>% 
  layer_dropout(0.2) %>% 
  layer_dense(10, activation = "softmax")

summary(model)

model %>% 
  compile(
    loss = "sparse_categorical_crossentropy",
    optimizer = "adam",
    metrics = "accuracy"
  )

model %>% 
  fit(
    x = mnist$train$x, y = mnist$train$y,
    epochs = 5,
    validation_split = 0.3,
    verbose = 2
  )

predictions <- predict(model, mnist$test$x)
head(predictions, 2)


model %>% 
  evaluate(mnist$test$x, mnist$test$y, verbose = 0)
