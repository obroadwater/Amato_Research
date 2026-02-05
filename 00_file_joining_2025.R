library(tidyverse)
library(readxl)
library(hms)


# rbind(list.files(path)[[1]], list.files(path)[[2]])
# 
# rbind(read_excel("Translated_Files/20250322_Aoka_Yayan_Uhit_Radi_FL_translated.xlsx"), read_excel("Translated_Files/20250404_Aoka_Uhit_FL_Translated.xlsx") |> 
#         rename("Focal activity start time" = `focal activity start time`,
#                "Time of arrival" = `Time of Arrival`,
#                "Species of tree" = `Species of Tree`))


#colnames(read_excel("Translated_Files/20250322_Aoka_Yayan_Uhit_Radi_FL_translated.xlsx")) == colnames(read_excel("Translated_Files/20250404_Aoka_Uhit_FL_Translated.xlsx"))

test <- read_excel("Translated_Jan_Feb_March/20250315_Ewat_Herman_Rama_NN_translated.xlsx", col_types = "text")

res <- read_excel("Translated_Jan_Feb_March/20250315_Ewat_Herman_Rama_NN_translated.xlsx", col_types = "text") |> 
  mutate(Date = date(as_datetime(as.numeric(Date) * 86400,
                            origin = "1899-12-30")),
         `Time of arrival` = as_datetime(as.numeric(`Time of arrival`) * 86400,
                                         origin = Date),
         `Focal start time` = as_datetime(as.numeric(`Focal start time`) * 86400,
                                         origin = Date),
         `Focal activity start time` = as_datetime(as.numeric(`Focal activity start time`) * 86400,
                                         origin = Date),
         `Feeding start time` = as_datetime(as.numeric(`Feeding start time`) * 86400,
                                         origin = Date),
         `Feeding end time` = as_datetime(as.numeric(`Feeding end time`) * 86400,
                                         origin = Date),
         `Start time feeding rate` = as_datetime(as.numeric(`Start time feeding rate`) * 86400,
                                         origin = Date),
         `End time feeding rate` = as_datetime(as.numeric(`End time feeding rate`) * 86400,
                                                 origin = Date))


#read_excel(paste0(path, "/",list.files(path)[[1]]))

#col_nums_error <- list("20250415_Ewit_yayan_radi_rama_NN_TO_Translated.xlsx", "20250315_Ewat_Herman_Rama_NN_translated.xlsx")


combine_translated <- function(folder_path){
  count_obs <- 0
  df_to_ret <- data.frame()
  files <- list.files(folder_path)
  first_file = TRUE
  for(file in files){
    print(file)
    xl <- read_excel(paste0(folder_path, "/", file), col_types = "text")
    count_obs <- count_obs + nrow(xl)
    if (first_file){
      df_to_ret <- xl
    }else{
      df_to_ret <- rbind(df_to_ret, xl)
    }
    first_file <- FALSE
  }
  print(count_obs)
  return(df_to_ret)
}


up_through_march <- combine_translated("Translated_Jan_Feb_March")
rest <- combine_translated("Translated_Apr_May")
data_2025 <- rbind(up_through_march, rest |> 
        rename("Focal activity start time" = `focal activity start time`,
               "Time of arrival" = `Time of Arrival`,
               "Species of tree" = `Species of Tree`))

data_2025_clean <- data_2025 |> 
  mutate(Date = date(as_datetime(as.numeric(Date) * 86400,
                                 origin = "1899-12-30")),
         `Time of arrival` = as_datetime(as.numeric(`Time of arrival`) * 86400,
                                         origin = Date),
         `Focal start time` = as_datetime(as.numeric(`Focal start time`) * 86400,
                                          origin = Date),
         `Focal activity start time` = as_datetime(as.numeric(`Focal activity start time`) * 86400,
                                                   origin = Date),
         `Feeding start time` = as_datetime(as.numeric(`Feeding start time`) * 86400,
                                            origin = Date),
         `Feeding end time` = as_datetime(as.numeric(`Feeding end time`) * 86400,
                                          origin = Date),
         `Start time feeding rate` = as_datetime(as.numeric(`Start time feeding rate`) * 86400,
                                                 origin = Date),
         `End time feeding rate` = as_datetime(as.numeric(`End time feeding rate`) * 86400,
                                               origin = Date),
         Visibility = as.numeric(Visibility),
         Activity = as.factor(Activity),
         `Amount eaten` = as.numeric(`Amount eaten`),
         `Tree canopy height` = as.factor(`Tree canopy height`)) |> 
  janitor::clean_names()

data_2025_clean <- data_2025_clean |> 
  mutate(part_of_fruit_eaten = as.factor(part_of_fruit_eaten),
         seed_eating_activity = as.factor(seed_eating_activity))

data_2025 |> 
  distinct(`Tree canopy height`)

data_2025_clean |> 
  distinct(tree_number)

write_csv(data_2025, file = "data/translated_data_2025.csv")
write_csv(data_2025_clean, file = "data/translated_data_2025_clean.csv")

