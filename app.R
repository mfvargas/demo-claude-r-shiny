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
      ),
      hr(),
      h4("Variables"),
      tags$dl(
        tags$dt("mpg"), tags$dd("Millas por galon"),
        tags$dt("cyl"), tags$dd("Numero de cilindros"),
        tags$dt("disp"), tags$dd("Desplazamiento del motor (cu.in.)"),
        tags$dt("hp"), tags$dd("Caballos de fuerza"),
        tags$dt("drat"), tags$dd("Relacion del eje trasero"),
        tags$dt("wt"), tags$dd("Peso (miles de libras)"),
        tags$dt("qsec"), tags$dd("Tiempo en 1/4 de milla (seg)"),
        tags$dt("vs"), tags$dd("Motor: 0 = V, 1 = recto"),
        tags$dt("am"), tags$dd("Transmision: 0 = auto, 1 = manual"),
        tags$dt("gear"), tags$dd("Numero de marchas"),
        tags$dt("carb"), tags$dd("Numero de carburadores")
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
