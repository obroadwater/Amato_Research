library(tidyverse)
library(readxl)

path <- "Translated_Files"

list.files(path)

rbind(list.files(path)[[1]], list.files(path)[[2]])

rbind(read_excel(paste0(path, "/",list.files(path)[[1]])), read_excel(paste0(path, "/",list.files(path)[[2]])))
read_excel(paste0(path, "/",list.files(path)[[1]]))


combine_translated <- function(folder_path){
  count_obs <- 0
  df_to_ret <- data.frame()
  files <- list.files(folder_path)
  first_file = TRUE
  for(file in files){
    #print(file)
    xl <- read_excel(paste0(folder_path, "/", file), col_types = "text")
    count_obs <- count_obs + nrow(xl)
    if (first_file){
      df_to_ret <- xl
    }else{
      df_to_ret <- rbind(df_to_ret, xl)
    }
    #print(df_to_ret)
    first_file <- FALSE
  }
  print(count_obs)
  return(df_to_ret)
}

data_2025 <- combine_translated(path)

write_csv(data_2025, file = "data/translated_data_2025.csv")
