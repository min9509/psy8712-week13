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
dbExecute(conn, "USE cla_tntlab;")

# Import three datasets 
employees_tbl <-  dbGetQuery(conn, "SELECT * FROM cla_tntlab.datascience_employees;")
testscores_tbl <- dbGetQuery(conn, "SELECT * FROM cla_tntlab.datascience_testscores;") 
offices_tbl <- dbGetQuery(conn, "SELECT * FROM cla_tntlab.datascience_offices;")

# Export tbls as csv (save in the data file)
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

