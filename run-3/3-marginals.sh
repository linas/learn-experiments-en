#! /bin/bash
#
# Configuration parameters for computing MMT marginals
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19002
export PROMPT="scheme@(run-3ma)"
export COGSERVER_CONF=${CONFIG_DIR}/3-cogserver/marg.conf

# Location of the database containing MPG pairs
# export MST_DB=${ROCKS_DATA_DIR}/r3-mpg-marg.rdb
export MST_DB=${ROCKS_DATA_DIR}/r3-filt-1280-256-160-marg.rdb
export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"