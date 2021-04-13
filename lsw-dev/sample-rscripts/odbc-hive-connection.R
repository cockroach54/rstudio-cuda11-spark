library(odbc)

host_ip    = "loca-edge1"
host_port  = 10000
uid        = 'ecube02'
pwd        = 'obzcom1!'

# Sample for DSN-less connection
# Assuming user has installed Cloudera's Hive ODBC Driver
odbc_driver = "/opt/cloudera/hiveodbc/lib/64/libclouderahiveodbc64.so"
dsn_string = paste0(';Host=', host_ip,
                    ';Port=', host_port,
                    ";AuthMech=3",
                    ";UID=", uid,
                    ";PWD=",pwd,
                    ';')

conn <- odbc::dbConnect(drv = odbc::odbc(),
                       dsn = dsn_string,
                       driver = odbc_driver
                       )


# IF /etc/odbcinst.ini has been configured
# [ODBC Drivers]
# HiveODBC=Installed
# 
# [HiveODBC]
# Description=Cloudera ODBC Driver for Apache Hive (64-bit)
# Driver=/opt/cloudera/hiveodbc/lib/64/libclouderahiveodbc64.so
odbc_driver = "HiveODBC"

# IF /etc/odbc.ini has been configured
# [LocaHive]
# Driver=HiveODBC
# Description=LOCA Hive
# Host=loca-edge1
# Port=10000
# AuthMech=3
# HiveServerType=2
# ThriftTransport=1
conn <- odbc::dbConnect(drv = odbc::odbc(),
                       dsn = "LocaHive",
                       uid = uid,
                       pwd = pwd
                       )

odbc::dbGetQuery(conn, "SHOW TABLES")

DBI::dbExecute(conn, "CREATE DATABASE IF NOT EXISTS default")

odbc::dbDisconnect(conn)
