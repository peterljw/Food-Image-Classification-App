library(readtext)
library(stringr)
path <- "C:/Users/Kyria/Desktop/Coding/Projects/2019/School/M280/classification/food_classification/images"
# downloadImages <- function(files, brand, outPath=path){
#   for(i in 1:length(files)){
#     try(download.file(files[i], destfile = paste0(outPath, "/", brand, "_", i, ".", file_ext(basename(files[i]))), mode = 'wb'))
#   }
# }

downloadImages <- function(files, brand, outPath=path){
  for(i in 1:length(files)){
    try(download.file(files[i], destfile = paste0(outPath, "/", brand, "_", i, ".jpg"), mode = 'wb'))
  }
}
urls <- readtext("rice.txt")[[2]]
urls <- str_split(urls, "\n")[[1]]
downloadImages(urls, "rice")