#!/bin/bash
################################################################################
# Filename: ./csv2hdp/csv2hdp.sh                                               #
# Path: ./csv2hdp                                                              #
# Created Date: Saturday, July 17th 2021, 12:44:19 pm                          #
# Author: lkellermann                                                          #
#                                                                              #
# ASCII ART:                                                                   #
#            https://patorjk.com/                                              #
#            Font name: Doh                                                    #
#                                                                              #
# Copyright (c) 2021 CompanyName                                               #
################################################################################
USAGE_MSG="
\e[36m
                                                                                                        dddddddd
                                                      222222222222222   hhhhhhh                         d::::::d
                                                     2:::::::::::::::22 h:::::h                         d::::::d
                                                     2::::::222222:::::2h:::::h                         d::::::d
                                                     2222222     2:::::2h:::::h                         d:::::d
    cccccccccccccccc    ssssssssssvvvvvvv           vvvvvvv      2:::::2 h::::h hhhhh           ddddddddd:::::dppppp   ppppppppp
  cc:::::::::::::::c  ss::::::::::sv:::::v         v:::::v       2:::::2 h::::hh:::::hhh      dd::::::::::::::dp::::ppp:::::::::p
 c:::::::::::::::::css:::::::::::::sv:::::v       v:::::v     2222::::2  h::::::::::::::hh   d::::::::::::::::dp:::::::::::::::::p
c:::::::cccccc:::::cs::::::ssss:::::sv:::::v     v:::::v 22222::::::22   h:::::::hhh::::::h d:::::::ddddd:::::dpp::::::ppppp::::::p
c::::::c     ccccccc s:::::s  ssssss  v:::::v   v:::::v22::::::::222     h::::::h   h::::::hd::::::d    d:::::d p:::::p     p:::::p
c:::::c                s::::::s        v:::::v v:::::v2:::::22222        h:::::h     h:::::hd:::::d     d:::::d p:::::p     p:::::p
c:::::c                   s::::::s      v:::::v:::::v2:::::2             h:::::h     h:::::hd:::::d     d:::::d p:::::p     p:::::p
c::::::c     cccccccssssss   s:::::s     v:::::::::v 2:::::2             h:::::h     h:::::hd:::::d     d:::::d p:::::p    p::::::p
c:::::::cccccc:::::cs:::::ssss::::::s     v:::::::v  2:::::2       222222h:::::h     h:::::hd::::::ddddd::::::ddp:::::ppppp:::::::p
 c:::::::::::::::::cs::::::::::::::s       v:::::v   2::::::2222222:::::2h:::::h     h:::::h d:::::::::::::::::dp::::::::::::::::p
  cc:::::::::::::::c s:::::::::::ss         v:::v    2::::::::::::::::::2h:::::h     h:::::h  d:::::::::ddd::::dp::::::::::::::pp
    cccccccccccccccc  sssssssssss            vvv     22222222222222222222hhhhhhh     hhhhhhh   ddddddddd   dddddp::::::pppppppp
                                                                                                                p:::::p
                                                                                                                p:::::p
                                                                                                               p:::::::p
                                                                                                               p:::::::p
                                                                                                               p:::::::p
                                                                                                               ppppppppp
\e[39m

A simple shell script to transfer a local server CSV file into Hive.

Usage $(basename "$0") [OPTIONS]
    -h, --help          Show this help message and exit.
    -f, --file          Source file path.
    -d, --database      Destiny database.

\e[4mExample\e[24m:
\e[100m csv2hdp.sh --file sample.csv --database default\e[49m

\e[4mExpected behavior\e[24m: the \e[100m sample.csv\e[49m file in this folder will be placed into \e[100m\"default\"\e[49m Hive database.

\e[4mWhat if...?\e[24m
    - My file has the same name as an existing table in provided database?
        The new file will replace the existing table.

"

drop_table() {
    local statement="drop table if exists $database.$table;" # Generates Hive drop statement.
    $CSV2HDP/run_in_beeline.sh "$statement"                  # Run Hive drop statement.
}

create_table() {

    local fields
    fields="$(get_fields)"

    local define_delimiter="row format delimited fields terminated by ','"
    local create_query="create table if not exists $database.$table($fields) $define_delimiter;"
    local load_data="load data inpath \"$hadoop_file_location\" overwrite into table $database.$table;"

    "$CSV2HDP"/run_in_beeline.sh "$create_query$load_data"
}

get_fields() {
    line=$(head -n 1 "$file_path")

    declare -a array

    IFS=, read -ra COLUMNS <<<"$line" # Generates an array COLUMNS from CSV header.

    cnt=${#COLUMNS[@]} # Get number of elements in COLUMNS
    i=1                # Iterator

    #  Iterates over each element in COLUMNS array to create another array of elements
    #   `<field1> string,`, `<field2> string,` ... `<fieldn> string`
    for record in "${COLUMNS[@]}"; do

        if [ $i -lt $cnt ]; then
            comma=","
        fi

        if [ $i -eq $cnt ]; then
            comma=""
        fi

        new_line="$record string $comma "

        array[${#array[@]}]=$new_line
        i=$((i + 1))
    done

    # Return elements of the new array as a string `<field1> string, <field2> string, ... <fieldn> string`
    echo "${array[*]}"
}

while test "$#" -gt 0; do
    case "$1" in

    -h | --help)
        echo -e "$USAGE_MSG"
        exit 0
        ;;

    -f | --file)
        shift
        if test "$#" -gt 0; then

            file_name="$1"
            file_path="$STAGING_CSV"/"$file_name"
            table="$(basename -s .csv "$file_path")"
            echo "Creating query to file $file_path"
        fi
        ;;

    -d | --database)
        shift
        if test "$#" -gt 0; then
            database="$1"
        fi
        ;;
    *)
        if test -n "$1"; then # Only runs this test if the $1 is not empty.
            echo "Invalid option. Please, run with -h or --help to get support."
            exit 1
        fi
        ;;
    esac
    shift
done

hive_staging="$HIVE_HOME/staging/$database/$table" # Staging server directory to store headless file.
hadoop_file_location="$hive_staging/$file_name"    # Hadoop HDFS file path.
local_file_location="$hadoop_file_location"        # File path to server local headless file.

mkdir -p "$hive_staging"                    # Create/overwrite file folder.
sed 1d "$file_path" >"$local_file_location" # Remove header and create/overwrite file to staging headless directory.

hadoop fs -mkdir -p "$hive_staging"                                        # Create directory in HDFS to store the file.
hadoop fs -copyFromLocal -f "$local_file_location" "$hadoop_file_location" # Copy headless file to HDFS.
hdfs dfs -chmod -R 777 "$hadoop_file_location"                             # Give permissions to Hive user to modify the headless file.

drop_table   # Drop Hive table if already exists:
create_table # Create table from headless file in HDFS.

rm -v "$local_file_location" # Remove headless file from staging server path.
