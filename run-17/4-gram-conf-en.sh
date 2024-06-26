#! /bin/bash
#
# Configuration parameters for disjunct distributions.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19017
export PORT=20017

export PROMPT="(r17)"
export PROMPT="(r17-all)"

export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-all.conf

# Location of the database containing MPG pairs
export MST_DB=${ROCKS_DATA_DIR}/r17-parse.rdb
export ALL_DB=${ROCKS_DATA_DIR}/r17-all-in-one.rdb

export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"
export STORAGE_NODE="(RocksStorageNode \"rocks://${ALL_DB}\")"
