# ui.R

fluidPage(
  
  titlePanel("shiny-fish"),
  
  sidebarLayout(
    sidebarPanel(
      h4("About the app"),
      helpText("help text example"),
      selectInput("filter_species", label="Select Species", choices = sort(unique()), selected = "Sandbar Shark",
                  selectize = TRUE, multiple=TRUE),
      sliderInput()
    ), # sidebarPanel
    
    mainPanel(
      wellPanel(
        fluidRow(
          column(
            width = 4,
            selectInput("select_species", label="Select Species", choices = sort(species_list)),
          ),
          column(
            width = 4,
          ),
          column(
            width = 4,
          )
        ), # fluidRow
        br(),
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