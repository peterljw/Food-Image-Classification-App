# #######################################

library(keras)
# k = backend()
# install_keras(tensorflow = "gpu")
library(dplyr)

# define parameters
img_width <- 128
img_height <- 128
target_size <- c(img_width, img_height)
channels <- 3
batch_size <- 32
epochs <- 100
train_image_files_path <- "C:/Users/Kyria/Desktop/Coding/Projects/2019/School/M280/classification/food_classification/train_images"
valid_image_files_path <- "C:/Users/Kyria/Desktop/Coding/Projects/2019/School/M280/classification/food_classification/test_images"
food_list <- list.files(train_image_files_path)
output_n <- length(food_list)

# load images
train_data_gen = image_data_generator(
  rescale = 1/255
)

valid_data_gen <- image_data_generator(
  rescale = 1/255
)

# training images
train_image_array_gen <- flow_images_from_directory(train_image_files_path, 
                                                    train_data_gen,
                                                    target_size = target_size,
                                                    class_mode = "categorical",
                                                    classes = food_list)

# validation images
valid_image_array_gen <- flow_images_from_directory(valid_image_files_path, 
                                                    valid_data_gen,
                                                    target_size = target_size,
                                                    class_mode = "categorical",
                                                    classes = food_list)

# info
cat("Number of images per class:")
table(factor(train_image_array_gen$classes))
cat("\nClass label vs index mapping:\n")
train_image_array_gen$class_indices

food_classes_indices <- train_image_array_gen$class_indices
# saveRDS(names(unlist(food_classes_indices)), "labels.RDS")

# number of training samples
train_samples <- train_image_array_gen$n
# number of validation samples
valid_samples <- valid_image_array_gen$n

# model
# initialise model
model <- keras_model_sequential()

# add layers
model %>%
  layer_conv_2d(filter = 32, kernel_size = c(3,3), padding = "same", input_shape = c(img_width, img_height, channels), kernel_regularizer = regularizer_l2(0.02)) %>%
  layer_activation("relu") %>%
  layer_max_pooling_2d(pool_size = c(2,2)) %>%
  
  # Second hidden layer
  layer_conv_2d(filter = 64, kernel_size = c(3,3), padding = "same", kernel_regularizer = regularizer_l2(0.02)) %>% #overfitting tuning
  layer_activation("relu") %>%
  layer_batch_normalization() %>%
  
  # Use max pooling
  layer_max_pooling_2d(pool_size = c(2,2)) %>%
  layer_dropout(0.25) %>%
  
  # Flatten max filtered output into feature vector 
  # and feed into dense layer
  layer_flatten() %>%
  layer_dense(512, kernel_regularizer = regularizer_l2(0.03)) %>%
  layer_activation("relu") %>%
  layer_dropout(0.3) %>% #overfitting tuning
  layer_dense(128, kernel_regularizer = regularizer_l2(0.01)) %>%
  layer_activation("relu") %>%
  layer_dropout(0.3) %>% #overfitting tuning
  
  # Outputs from dense layer are projected onto output layer
  layer_dense(output_n) %>% 
  layer_activation("softmax")

# compile
model %>% compile(
  loss = "categorical_crossentropy",
  optimizer = optimizer_rmsprop(lr = 0.0005, decay = 1e-6),
  metrics = "accuracy"
)
summary(model)

# fit
hist <- model %>% fit_generator(
  # training data
  train_image_array_gen,
  
  # epochs
  steps_per_epoch = batch_size, 
  epochs = epochs, 
  
  # validation data
  validation_data = valid_image_array_gen,
  validation_steps = as.integer(valid_samples / batch_size),
  
  # print progress
  verbose = 2,
  callbacks = list(
    # save best model after every epoch
    callback_model_checkpoint("C:/Users/Kyria/Desktop/Coding/Projects/2019/School/M280/classification/food_classification/class10.h5", save_best_only = TRUE)
  )
)

#######################################