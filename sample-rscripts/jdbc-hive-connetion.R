library(RJDBC)  # https://www.rdocumentation.org/packages/RJDBC/versions/0.2-8/topics/JDBC
library(DBI)  # https://www.rdocumentation.org/packages/DBI/versions/0.5-1

# make jdbc connection
jdbc_driver = JDBC(classPath="/usr/local/hive/jdbc/hive-jdbc-3.1.2-standalone.jar")
# jdbc_driver = JDBC("org.apache.hive.jdbc.HiveDriver", classPath="/usr/local/hive/jdbc/hive-jdbc-3.1.2-standalone.jar")
conn = dbConnect(jdbc_driver, "jdbc:hive2://loca-edge1:10000", user='ecube')

# get sample table
dbGetQuery(conn, "SHOW DATABASES")
df = dbGetQuery(conn, "SELECT * FROM default.test_iris")
# colnames(df)
# [1] "test_iris.sepal_length" "test_iris.sepal_width"  "test_iris.petal_length"
# [4] "test_iris.petal_width"  "test_iris.species" 

# 컬럼명에 '.' 있으면 파싱 에러나므로 제외
colnames(df) = c("sepal_length", "sepal_width", "petal_length", "petal_width", "species")

# # -------------------INSERT DATA----------------------
# # write dataframe as table
# # hive 미지원... 테이블 생성은 되지만 update문을 지원하지 않아서 데이터 쓰기 불가
# # hive는 애초에 배치작업이므로 불필요
# # dbWriteTable(conn, "default.jdbc_iris", df) 명령어 에러남

# # 이렇게 insert문으로는 입력 가능
# # 아래 함수를 이용해 insert문 string으로 변경 가능
# # insertsql = sqlAppendTable(conn, "default.jdbc_iris", df)
# dbGetQuery(conn, "CREATE TABLE IF NOT EXISTS default.jdbc_iris(
#   sepal_length DOUBLE, 
#   sepal_width DOUBLE, 
#   petal_length DOUBLE, 
#   petal_width DOUBLE, 
#   species STRING)"
#   )
# dbGetQuery(conn, "INSERT INTO default.jdbc_iris VALUES(1.2, 2.0, 3.2, 4.1, 'setosa')")
# dbGetQuery(conn, "SELECT * FROM default.jdbc_iris")
# dbGetQuery(conn, "DROP TABLE default.jdbc_iris")

# # can check real data path with command below
# # /usr/local/hadoop/bin/hdfs dfs -ls /user/hive/warehouse
# # -------------------INSERT DATA----------------------


# disconnect spark session
dbDisconnect(conn)

