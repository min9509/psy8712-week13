# Script Settings and Resources
library(keyring)
library(RMariaDB)
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

# Analysis
# 4-1. the total number of managers (count rows): 

# 4_2. the total number of unique managers: 


# 4-3. A summary of the number of managers split by location


# 4-4. the mean and standard deviation


# 4-5. Each manager's location classification
