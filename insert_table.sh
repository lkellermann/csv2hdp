#!/bin/bash
################################################################################
# Filename: ./csv2hdp/insert.sh                                                #
# Path: ./csv2hdp                                                              #
# Created Date: Sunday, July 25th 2021, 10:25:49 am                            #
# Author: lkellermann                                                          #
#                                                                              #
# Copyright (c) 2021 CompanyName                                               #
################################################################################

USAGE_MSG="#TODO"
path_to_insert="./absquery/insert.sql"

get_columns_from_source() {
    # TODO: given a table in Hive, get its columns.
    # get columns from $source
    columns="column_a,column_b,column_c"
}

while test "$#" -gt 0; do
    case "$1" in

    -h | --help)
        echo "$USAGE_MSG"
        exit 0
        ;;

    -s | --source)
        shift
        if test "$#" -gt 0; then
            source="$1"
        fi
        ;;

    -d | --destiny)
        shift
        if test "$#" -gt 0; then
            destiny="$1"
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

get_columns_from_source

INSERT_STATEMENT=$(sed -e "s/\${COLUMNS}/$columns/" \
    -e "s/\${DESTINY}/$destiny/" \
    -e "s/\${SOURCE}/$source/" "$path_to_insert")

echo "Executing insert_statement.sh"
echo "$INSERT_STATEMENT"
