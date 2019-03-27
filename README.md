# Food-Photo-Classifier-App

The purpose of the project is to build a image classification app that allows users to upload or take photos of food. The project includes the scripts used for all stages of the development of the app.
1) Web scrape food images off Google Image by downloading source links using js, which are then used to download source images in R (See **google-image-js-script.txt** and **web-scraping.R**)
2) Preprocess the downloaded images and use them to train a convolutional neural network using keras with tensorflow-gpu as the backend (See **model-training.R**)
3) Load the model outputted from the previous step and make predictions of new images (See **prediction.R**)
4) Build a web app using the outputted model using Shiny (See **app.R**)
5) Build an Android app with the web app created using Android Studio and WebView

## Built With

* [keras](https://keras.rstudio.com/) - a high-level neural networks API developed with a focus on enabling fast experimentation
* [EBImage](https://www.bioconductor.org/packages/release/bioc/html/EBImage.html) - R package that provides general purpose functionality for image processing and analysis
* [tidyverse](https://www.tidyverse.org/) -  An opinionated collection of R packages designed for data science
* [rvest](https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html) - R package for web scraping
* [WebView](https://developer.android.com/reference/android/webkit/WebView) - WebView objects allow you to display web content as part of your activity layout in an Android app

## Authors

* **Jiawei Long** - [peterljw](https://github.com/peterljw)
