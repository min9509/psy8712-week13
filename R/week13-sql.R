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
# 4-1. the total number of managers (count rows): 549
dbGetQuery(conn, 
  "SELECT COUNT(*) AS total_manager
   FROM cla_tntlab.datascience_employees AS e
   INNER JOIN cla_tntlab.datascience_testscores AS t 
   ON e.employee_id = t.employee_id;"
)

# 4_2. the total number of unique managers: 549
dbGetQuery(conn, 
"SELECT COUNT(DISTINCT e.employee_id) AS unique_manager
FROM cla_tntlab.datascience_employees AS e
INNER JOIN cla_tntlab.datascience_testscores AS t 
ON e.employee_id = t.employee_id;"
)

# 4-3. A summary of the number of managers split by location
#            city num_managers (Part of results)
# 1       Chicago           62
# 2       Houston           21
# 3      New York          187
# ... 

dbGetQuery(conn,
"SELECT city, COUNT(DISTINCT e.employee_id) AS num_managers
FROM cla_tntlab.datascience_employees AS e
LEFT JOIN cla_tntlab.datascience_testscores AS t 
ON e.employee_id = t.employee_id
LEFT JOIN cla_tntlab.datascience_offices AS o 
ON city = 'office'
WHERE manager_hire = 'N'
GROUP BY city;"
)

# 4-4. the mean and standard deviation


# 4-5. Each manager's location classification
