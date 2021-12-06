#!/bin/bash
command="$1;"
"$HIVE_HOME"/bin/beeline -u "$HIVE_JDBC" <<EOF
$command
EOF
