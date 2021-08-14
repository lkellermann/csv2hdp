#!/bin/bash
command="$1;"
/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 <<EOF
$command
EOF
#echo "$command"
