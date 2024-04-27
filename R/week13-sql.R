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
# Count all rows in the joined tables
dbGetQuery(conn, 
  "SELECT COUNT(*) AS total_manager
   FROM cla_tntlab.datascience_employees AS e
   INNER JOIN cla_tntlab.datascience_testscores AS t 
   ON e.employee_id = t.employee_id;"
  )

# 4_2. the total number of unique managers: 549
# Count the distinct employee IDs
dbGetQuery(conn,"SELECT COUNT(DISTINCT e.employee_id) AS unique_manager 
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
           ON e.city = o.office WHERE manager_hire = 'N' 
           GROUP BY city;"
           )

# 4-4. the mean and standard deviation
# performance_group mean_employment sd_employment
# 1            Bottom         4.74206     0.5348718
# 2            Middle         4.58061     0.5082812
# 3               Top         4.32581     0.5989064
dbGetQuery(conn, 
           "SELECT performance_group,
           AVG(yrs_employed) AS mean_employment,
           STDDEV(yrs_employed) AS sd_employment
           FROM cla_tntlab.datascience_employees AS e
           INNER JOIN (
           SELECT DISTINCT employee_id
           FROM cla_tntlab.datascience_testscores
           ) AS t ON e.employee_id = t.employee_id
           GROUP BY performance_group;"
           )

# 4-5. Each manager's location classification
# location_type employee_id test_score 
# 1        Suburban    c764744b        485
# 2        Suburban    8205a876        439
# 3        Suburban    1be5eccb        402
# ... 
dbGetQuery(conn, 
           "SELECT o.type AS location_type, e.employee_id, t.test_score
           FROM cla_tntlab.datascience_employees AS e
           LEFT JOIN cla_tntlab.datascience_testscores AS t
           ON e.employee_id = t.employee_id
           LEFT JOIN cla_tntlab.datascience_offices AS o
           ON e.city = o.office
           ORDER BY o.type ASC, t.test_score DESC;"
           )
