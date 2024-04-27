# Script Settings and Resources
library(keyring)
library(RMariaDB)
library(tidyverse)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Data Import and Cleaning
# Connect MariaDB
conn <-dbConnect(MariaDB(),
                 user="seo00082",
                 password=key_get("latis-mysql","seo00082"),
                 host="mysql-prod5.oit.umn.edu",
                 port=3306,
                 ssl.ca='mysql_hotel_umn_20220728_interm.cer')
# For any procedure that doesn't return a table
dbExecute(conn, "USE cla_tntlab;")

# Import three datasets by using dbGetQuery (for any proceduer that returns a table)
employees_tbl <-  dbGetQuery(conn, "SELECT * FROM cla_tntlab.datascience_employees;")
testscores_tbl <- dbGetQuery(conn, "SELECT * FROM cla_tntlab.datascience_testscores;") 
offices_tbl <- dbGetQuery(conn, "SELECT * FROM cla_tntlab.datascience_offices;")

# Export tbls as csv (save in the data file) by using write_csv
write_csv(employees_tbl, "../data/employees.csv")
write_csv(testscores_tbl, "../data/testscores.csv")
write_csv(offices_tbl, "../data/offices.csv")

# Make week13_tbl by combining 3 csv
week13_tbl <- employees_tbl %>%
  left_join(testscores_tbl, by = "employee_id") %>%
  left_join(offices_tbl, by = c("city" = "office")) %>%
  filter(!is.na(test_score))

# Export tbls as csv (save in the out file)
write_csv(week13_tbl, "../out/week13.csv")

# Analysis
# 4-1. the total number of managers (count rows): 549 
total_managers <- week13_tbl %>%
  nrow()
print(total_managers)

# 4_2. the total number of unique managers: 549
unique_managers <- week13_tbl %>%
  select(employee_id) %>%
  unique() %>%
  nrow()
print(unique_managers)

# 4-3. A summary of the number of managers split by location
# city          num_manager
# 1 Chicago                61
# 2 Houston                20
# 3 New York              183
# 4 Orlando                20
# 5 San Francisco          48
# 6 Toronto               189

city_managers <- week13_tbl %>% 
  #  only include those who were not originally hired as managers
  filter(manager_hire == "N") %>%
  # split by location
  group_by(city) %>%
  # summary the number of managers
  summarize(num_manager = n())
print(city_managers)

# 

