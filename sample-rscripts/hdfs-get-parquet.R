### hdfs 파일 로컬로 가져오기
getwd()
system("mkdir data")

# hdfs 목표 파일들 확인
system("hdfs dfs -ls hdfs://obz-hdfs-ha/user/ecube/my.hive")

# get non partitioned data from hdfs
system("hdfs dfs -get hdfs://obz-hdfs-ha/user/ecube/my.hive/ratings_predictions_full /home/ecube02/data/non-part")
# get partitioned data from hdfs
system("hdfs dfs -get hdfs://obz-hdfs-ha/user/ecube/my.hive/ratings_predictions_parts /home/ecube02/data/part")


# 로컬 파일들 확인
system("ls -l data/non-part")
system("ls -l data/part")


### arrow 패키지 설치 필요
### 아래 명령어로 CRAN에서 설치하면 snappy등의 압축 코덱들 빠질 수 있으므로 소스 받아서 직접 설치
### install.packages('arrow')  # https://arrow.apache.org/docs/r/reference/read_parquet.html

library(arrow)

# 단일 파일 로드
fp="/home/ecube02/data/non-part/000000_0"
df = read_parquet(
  fp,
  as_data_frame = TRUE
)
dim(df)


# 디렉토리 전체 로드 (파이썬과는 다르게 arrow::read_parquet는 단일파일만 읽어옴)
# /home/ecube02/data/non-part
# ├── 000000_0
# ├── 000001_0
# └── 000002_0

fp="/home/ecube02/data/non-part/*"
df <-data.table::rbindlist(
  lapply(Sys.glob(fp), read_parquet)
)
dim(df)


# 파티셔닝 된 디렉토리 두 단계로 리커시브하게 전체 로드
# /home/ecube02/data/part
# ├── movie_bucket=0
# │   └── 000000_0
# ├── movie_bucket=1
# │   └── 000000_0
# ├── movie_bucket=10
# │   └── 000000_0
# ├── movie_bucket=2
# │   └── 000000_0
# ├── movie_bucket=3
# │   └── 000000_0
# ├── movie_bucket=4
# │   └── 000000_0
# ├── movie_bucket=5
# │   └── 000000_0
# ├── movie_bucket=6
# │   └── 000000_0
# ├── movie_bucket=7
# │   └── 000000_0
# ├── movie_bucket=8
# │   └── 000000_0
# └── movie_bucket=9
#     └── 000000_0

fp="/home/ecube02/data/part/**/*"
df <-data.table::rbindlist(
  lapply(Sys.glob(fp), read_parquet)
)
dim(df)

