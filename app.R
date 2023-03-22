library(shiny)
library(duckdb)
library(ggplot2)

# Connect to the DuckDB database
db <- dbConnect(duckdb(), dbdir="palmerpenguins.duckdb", read_only=TRUE)

# Define the UI
ui <- fluidPage(
  titlePanel("Penguins Explorer"),
  markdown("See https://github.com/stephenturner/duckpenguins"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("species", "Select a species:",
                   choices = c("Adelie", "Gentoo", "Chinstrap"),
                   selected = "Adelie")
    ),
    mainPanel(
      plotOutput("plot")
    )
  ),
  br(),
  markdown("This app was made with the following ChatGPT prompt:"),
  img(src="chatgpt.png")
)

# Define the server
server <- function(input, output) {
  # Query the database based on the selected species
  data <- reactive({
    query <- sprintf("SELECT bill_length_mm, flipper_length_mm
                      FROM penguins
                      WHERE species = '%s'", input$species)
    dbGetQuery(db, query)
  })

  # Create the plot
  output$plot <- renderPlot({
    ggplot(data(), aes(x = bill_length_mm, y = flipper_length_mm)) +
      geom_point() +
      ggtitle(paste("Species:", input$species))
  })
}

onStop(function() dbDisconnect(con))

# Run the app
shinyApp(ui = ui, server = server)
