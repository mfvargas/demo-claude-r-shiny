library(shiny)
library(ggplot2)
library(DT)

ui <- fluidPage(
  titlePanel("Explorador de mtcars"),
  p("Visualizacion interactiva del dataset Motor Trend Car Road Tests (1974)"),

  sidebarLayout(
    sidebarPanel(
      selectInput("x_var", "Variable eje X:",
        choices = names(mtcars),
        selected = "wt"
      ),
      selectInput("y_var", "Variable eje Y:",
        choices = names(mtcars),
        selected = "mpg"
      ),
      selectInput("color_var", "Variable de color:",
        choices = names(mtcars),
        selected = "cyl"
      )
    ),

    mainPanel(
      plotOutput("scatter_plot"),
      hr(),
      DTOutput("data_table")
    )
  )
)

server <- function(input, output) {
  output$scatter_plot <- renderPlot({
    ggplot(mtcars, aes(
      x = .data[[input$x_var]],
      y = .data[[input$y_var]],
      color = factor(.data[[input$color_var]])
    )) +
      geom_point(size = 3) +
      geom_smooth(method = "lm", se = TRUE, color = "steelblue") +
      labs(
        x = input$x_var,
        y = input$y_var,
        color = input$color_var
      ) +
      theme_minimal()
  })

  output$data_table <- renderDT({
    datatable(mtcars, options = list(pageLength = 10))
  })
}

shinyApp(ui = ui, server = server)
