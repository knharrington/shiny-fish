# server.R

function(input, output, session) {
  
  # Create a reactiveValues object to store the Google Sheet data
  data_store <- reactiveValues(data = NULL)
  
  # Function to fetch and update the data from Google Sheet
  update_sheet_data <- function() {
    tryCatch({
      sheet_data <- read_sheet(ss = sheet_id, sheet = "main")
      data_store$data <- sheet_data
    }, error = function(e) {
      showNotification("Error reading Google Sheet", type="error")
      print(paste("Error reading sheet:", e))
    })
  }
  
  # Fetch initial data on app start-up
  update_sheet_data()
  
  # Confirm new data entries
  observeEvent(input$submit, {
    ask_confirmation(
      inputId = "confirm",
      title = "Confirm Observations",
      btn_colors = c("#dd4b39","#3b8dbc")
    )
  })
  
  # Add confirmation to data entry collection
  observeEvent(input$confirm,{
    
    # Record new data entries if confirmed
    if (isTRUE(input$confirm)) {
      
      # Record timestamp of recording
      timestamp <- Sys.time()
      
      # Handle length inputs
      lengthm <- 0
      
      # handle water temp inputs
      waterdegc <- 0
      
      # Record longitude
      if (input$check_loc == "Yes") {
        if (input$geolocation == TRUE) {
          lon <- as.numeric(input$long)
        } else { 
          show_alert("Error writing data",
                     text = "Unable to retrieve location. Please enter manually.",
                     type="error", btn_colors = "#dd4b39")
          return(NULL)
        }
        shinyjs::enable("submit")
      } else {
        lon <- as.numeric(input$text_long)
      }
      
      print(lon)
      if (is.na(lon) || lon > -82.996 || lon < -90.500 || is.null(lon)) {
        show_alert("Error writing data",
                   text = "Valid longitudes are between -90.5W and -83W.",
                   type="error", btn_colors = "#dd4b39")
        shinyjs::enable("submit")
        return(NULL)  
      }
      
      # record latitude
      if (input$check_loc == "Yes") {
        if (input$geolocation == TRUE) {
          lat <- as.numeric(input$lat)
        } else {
          show_alert("Error writing data",
                     text = "Unable to retrieve location. Please enter manually.",
                     type="error", btn_colors = "#dd4b39")
          return(NULL)
        }
        shinyjs::enable("submit")
      } else {
        lat <- as.numeric(input$text_lat)
      }
      
      print(lat)
      if (is.na(lat) || lat < 28.90000 || lat > 30.692 || is.null(lat)) {
        show_alert("Error writing data",
                   text = "Valid latitudes are between 28.9N and 30.6N.",
                   type="error", btn_colors = "#dd4b39")
        shinyjs::enable("submit")
        return(NULL)  
      }
      
      # Compile responses into a data table
      response_data <- data.table(
        Species = input$select_species,
        Length_M = lengthm,
        Water_DegC = waterdegc,
        DateTime_UTC = timestamp,
        Latitude = lat,
        Longitude = lon,
        Notes = input$notes
      ) 
      
      # Merge the new responses with the existing Google Sheet
      tryCatch({
        sheet_append(data = response_data,
                      ss = sheet_id,
                      sheet = "main")
        # Handle connectivity errors
        update_sheet_data()
      }, error = function(e) {
        showNotification("Error writing to Google Sheet", type="error")
      })
      
      # Success alert
      show_alert("Data updated successfully", type="success", btn_colors = "#3b8dbc")
      
      # Enable a new submission
      shinyjs::enable("submit")
      
    # If confirmation does not occur, exit data appending process  
    } else if (isFALSE(input$confirm)) {
      return(NULL)
      shinyjs::enable("submit")
    }
  }, ignoreNULL = TRUE) # End input confirm
  
} # session