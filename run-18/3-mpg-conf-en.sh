#! /bin/bash
#
# Configuration parameters for Planar MPG parsing.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19018
export PROMPT="[0;34mscheme@(run-18) [0m"
export OCPROMPT="[0;32mcogserver@(run-18) [0m"
export LOGFILE=/tmp/cogserver-mst-en.log

# Location of the database containing MPG pairs
export MST_DB=${ROCKS_DATA_DIR}/r18-mpg.rdb
export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"

# Message printed for each processed file
export MSG="MPG-Processing"
