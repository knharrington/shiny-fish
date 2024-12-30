# global.R

# Load libraries
{
  library(tidyverse)
  library(data.table)
  library(sf)
  
  library(shiny)
  library(leaflet)
  library(plotly)
  library(DT)
  #library(kableExtra)
  #library(htmlwidgets)
  #library(shinyWidgets)
  
  library(googledrive)
  library(googlesheets4)
}

##### Do this once upon initial setup then comment out #####
# options(gargle_oauth_cache = ".secrets")
# googlesheets4::gs4_auth()
# googlesheets4::gs4_create(name = "shiny-fish",
#                           sheets = "main")
# sheet_id <- googledrive::drive_get("shiny-fish")$id
# column_names <- c("Species", "Length_M", "Water_DegC", "Time_UTC", "Latitude", "Longitude")
# response_data <- data.table(matrix(ncol = length(column_names), nrow = 0))
# setnames(response_data, column_names)
# sheet_write(data = response_data,
#             ss = sheet_id,
#             sheet = "main")

# Set Google Sheet information
options(
  gargle_oauth_email = TRUE,
  gargle_oauth_cache = ".secrets",
  gargle_oauth_path = NULL
)
googledrive::drive_auth(cache = ".secrets", email = "knharrington@mote.org")
googlesheets4::gs4_auth(token = drive_token())
sheet_id <- googledrive::drive_get("shiny-fish")$id
