library(shiny)
library(shinydashboard)
library(shinythemes)
library(keras)
library(imager)

# helper functions
predict_class <- function(img, pred_model, labels) {
  test_img <- load.image(img) %>%
    resize(128, 128)
  dim(test_img) <- c(1, 128, 128, 3)
  index <- pred_model %>%
    predict_classes(test_img)
  return(labels[index+1])
}

# load labels and models
labels <- readRDS("labels.RDS")
model <- load_model_hdf5("model-9.h5")

# -----UI-----
ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Food Photo Classifier"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Image Upload", tabName = "image", icon = icon("image"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "image",
               fluidRow(
                 column(12,
                        box(width = NULL,
                            fileInput(
                              inputId = "img",
                              label = "Upload Your Photo",
                              buttonLabel = icon("camera"),
                              accept = c('image/png', 'image/jpeg','image/jpg')
                            )
                        )
                 )
                 ),
              
              fluidRow(
                column(12,
                       verbatimTextOutput("result", placeholder = TRUE)
                )
              ),
  
              
              fluidRow(
                 column(12,
                        box(width = NULL, solidHeader = TRUE,
                           imageOutput(outputId = "display"))
                 )
              )
      )
    )
  )
)

# -----Server-----
server <- function(input, output) {
  
  rec <- reactive({gsub("\\\\", "/", input$img$datapath)})
  
  output$display <- renderImage({
    if(is.null(input$img)){
      list(src = "sample.jpg", width = "100%", height = "400px") #fix auto scales
    }else{
      list(src = rec(), width = "100%", height = "400px") #fix auto scales
    }
  }, deleteFile = !is.null(input$img))
  
  output$result <- renderText({
    if(is.null(input$img)){
      "Please photograph your food in a similar fashion."
    }else{
      paste("Classification Result: ", predict_class(rec(), model, labels), sep="")
    }
  })

}

# Run the application
shinyApp(ui = ui, server = server)