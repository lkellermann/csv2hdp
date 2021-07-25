create table if not exists ${DATABASE}.${TABLE}(
    ${fields}
)
stored as parquet
location ${hadoop_file_location};
