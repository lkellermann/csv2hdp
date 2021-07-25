#!/bin/bash
################################################################################
# Filename: ./csv2hdp/csv2hdp.sh                                               #
# Path: ./csv2hdp                                                              #
# Created Date: Saturday, July 17th 2021, 12:44:19 pm                          #
# Author: lkellermann                                                          #
#                                                                              #
# Copyright (c) 2021 CompanyName                                               #
################################################################################
USAGE_MSG="
Usage $(basename "$0") [OPTIONS] 
    -h, --help          Shows help message and exit.
    -f, --file          Path to csv file that will be transfered to Hadoop.
    -d, --database      Database where the table will be created.
#TODO: addapt this sketch to run in Hadoop.
"

drop_table() {
    # Function to generate the drop_table statement
    local statement="drop table if exists $1.$2;"
    echo "$statement"
}

while test "$#" -gt 0; do
    case "$1" in

    -h | --help)
        echo "$USAGE_MSG"
        exit 0
        ;;

    -f | --file)
        shift
        if test "$#" -gt 0; then

            file_path="$1"
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

external_table="external_$table"

# TODO: function that generates path_to_external string dynamically.
hadoop_file_location="path_to_external"

drop_table "$database" "$table" # Drop table if already exists:
./create_table.sh "$file_path" "$external_table" "$database" "$hadoop_file_location"
./create_table.sh "$file_path" "$table" "$database"
./insert_table.sh --source "$database.$external_table" --destiny "$database.$table"
drop_table "$database" "$external_table"
