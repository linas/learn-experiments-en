#! /bin/bash
#
# Configuration parameters for Planar MPG parsing.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=20118
export PROMPT="mpg@(run-18)"
export OCPROMPT="[0;32mcogserver-mpg@(run-18) [0m"
export LOGFILE=/tmp/cogserver-mst-en.log

# Location of the database where MPG counts will accumulate.
export MST_DB=${ROCKS_DATA_DIR}/r18-bond.rdb
export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"

# Message printed for each processed file
export MSG="MPG-Processing"

export CORPORA_DIR=/home/ubuntu/textx/pair-counted

export IN_PROCESS_DIR=mpg-split
export COMPLETED_DIR=mpg-done

