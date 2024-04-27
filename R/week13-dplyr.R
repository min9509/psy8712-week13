# Script Settings and Resources
install.packages("keyring")
library(keyring)
install.packages("RMariaDB")
library(RMariaDB)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

conn <-dbConnect(MariaDB(),
                 user="seo00082",
                 password=key_get("latis-mysql","seo00082"),
                 host="mysql-prod5.oit.umn.edu",
                 port=3306,
                 ssl.ca='../mysql_hotel_umn_20220728_interm.cer')

