# rhdfs 패키지의 경우 지원하는 하둡 버전이 낮아서 사용하지 않습니다
# https://github.com/RevolutionAnalytics/RHadoop/wiki/Installing-RHadoop-on-RHEL#system-requirements

# Set and add hadoop bin path
Sys.setenv('HADOOP_HOME' = '/usr/local/hadoop')
Sys.setenv('PATH' = paste(Sys.getenv("PATH"), '/usr/local/hadoop/bin', sep = ':'))

library(data.table)

read_hdfs = function(fpath){
  command = paste0("hdfs dfs -text ", fpath)
  df = fread(cmd=command)
  return(df)
}

write_hdfs = function(df, fpath){
  command = paste0('hdfs dfs -put -f - ', fpath)
  p_in <- pipe(command, 'w')
  sink(file = p_in)
  fwrite(df)
  sink()
  close(p_in) 
}

# read file from hdfs
df = read_hdfs("hdfs:///user/ecube/iris.csv")  # absolute path
# df = read_hdfs("iris.csv")  # path starts at user home
print(df)

# write dataframe to hdfs
write_hdfs(df, "hdfs:///user/ecube/iris3.csv")

# check result with command below
# /usr/local/hadoop/bin/hdfs dfs -ls /user/ecube/iris3.csv
system('hdfs dfs -ls /user/ecube/iris3.csv')

