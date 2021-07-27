#! /bin/bash
#
# Configuration parameters for Planar MPG parsing.
#
# export CORPORA_DIR=$TEXT_DIR/pair-counted-tranche-1
# export CORPORA_DIR=$TEXT_DIR/pair-counted-tranche-2
export CORPORA_DIR=$TEXT_DIR/pair-counted-tranche-3

# Directories where in-process and completed files will be moved.
export IN_PROCESS_DIR=mpg-split
# export COMPLETED_DIR=mpg-done-tranche-1
# export COMPLETED_DIR=mpg-done-tranche-2
export COMPLETED_DIR=mpg-done-tranche-3

export SENTENCE_SPLIT=true
export SPLIT_LANG=en

# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=18006
export PROMPT="scheme@(mpg-parse)"
export COGSERVER_CONF=${CONFIG_DIR}/3-cogserver/cogserver-mst-en.conf

# Scheme function name for planar MST parsing.
export OBSERVE="observe-mpg"

# Location of the database where disjunct counts will be accumulated
# export MST_DB=${ROCKS_DATA_DIR}/run-1-en_mpg-tranche-1.rdb
# export MST_DB=${ROCKS_DATA_DIR}/run-1-en_mpg-tranche-12.rdb
# export MST_DB=${ROCKS_DATA_DIR}/run-1-en_mpg-tranche-123.rdb
export MST_DB=${ROCKS_DATA_DIR}/run-1-en_mpg-tranche-1234.rdb
export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"

# Message printed for each processed file
export MSG="MPG-Processing"
