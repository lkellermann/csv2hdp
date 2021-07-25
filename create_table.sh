#!/bin/bash
################################################################################
# Filename: ./csv2hdp/create_statement.sh                                      #
# Path: ./csv2hdp                                                              #
# Created Date: Saturday, July 17th 2021, 2:58:34 pm                           #
# Author: lkellermann                                                          #
#                                                                              #
# Copyright (c) 2021 CompanyName                                               #
################################################################################

defines_path_to_create() {
    # Choose between create_external.sql or create.sql statement deppending on
    # the hadoop_file_location argument. If we provide this argument the script will
    # create the table as an external table pointing to the specified location in
    # HDFS. If don't a empty table will be created.
    if test -n "$hadoop_file_location"; then
        path_to_create="./absquery/create_external.sql"

    else
        path_to_create="./absquery/create.sql"

    fi
}

file_path="$1"
table="$2"
database="$3"
hadoop_file_location="$4"
defines_path_to_create

line=$(head -n 1 "$file_path")

as_string=" as string"
declare -a array
# Generates an array COLUMNS from the
# CSV header.
IFS=, read -ra COLUMNS <<<"$line"

cnt=${#COLUMNS[@]} # Number of columns
i=1
# Build an array of strings to build part of the create
# statement
for record in "${COLUMNS[@]}"; do

    if [ $i -lt $cnt ]; then
        comma=","
    fi

    if [ $i -eq $cnt ]; then
        comma=""
    fi

    new_line="$record $as_string$comma\n"

    array[${#array[@]}]=$new_line
    i=$((i + 1))
done

fields="${array[*]}" <$path_to_create

QUERY_BUILDER_CREATE_STATEMENT=$(sed -e "s/\${fields}/$fields/" \
    -e "s/\${DATABASE}/$database/" \
    -e "s/\${TABLE}/$table/" \
    -e "s/\${hadoop_file_location}/$hadoop_file_location/" "$path_to_create")

echo "Executing build_create_statement.sh\n"
echo "$QUERY_BUILDER_CREATE_STATEMENT"
