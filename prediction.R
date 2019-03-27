library(keras)
library(EBImage)

labels <- readRDS("labels.RDS")
pred_model <- load_model_hdf5("model-9.h5")

path <- "C:/Users/Kyria/Desktop/Coding/Projects/2019/School/M280/classification/food_classification/test_images/rice/rice3047.png"
img <- readImage(path)
predict_class <- function(img, labels) {
  test_img <- img %>%
    resize(128, 128) %>%
    toRGB() 
  dim(test_img) <- c(1, 128, 128, 3)
  index <- pred_model %>%
    predict_classes(test_img)
  return(labels[index+1])
}
display(img)
print(predict_class(img, labels))
