# ui.R

fluidPage(
  
  titlePanel("shiny-fish"),
  
  sidebarLayout(
    sidebarPanel(
      h4("About the app"),
      helpText("help text example"),
      sliderInput()
    ), # sidebarPanel
    
    mainPanel(
      wellPanel(
        fluidRow(
          column(),
          column(),
          column()
        ), # fluidRow
        fluidRow(
          column(),
          column(),
          column()
        ) # fluidRow
      ), # wellPanel
      tabsetPanel(
        tabPanel("Map",
                 leafletOutput()
        ),
        tabPanel("Plot",
                 plotlyOutput()
        ),
        tabPanel("Table",
                 DTOutput()
        )
      ) # tabsetPanel
    ) # mainPanel
  
  ) # sidebarLayout
) # fluidPage