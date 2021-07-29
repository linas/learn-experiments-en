#! /bin/bash
#
# Configuration parameters for Planar MPG parsing.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19006
export PROMPT="scheme@(run-3)"
export COGSERVER_CONF=${CONFIG_DIR}/3-cogserver/cogserver-mst-en.conf

# Location of the database containing MPG pairs
export MST_DB=${ROCKS_DATA_DIR}/r3-mpg-marg.rdb
export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"

# Message printed for each processed file
export MSG="MPG-Processing"
