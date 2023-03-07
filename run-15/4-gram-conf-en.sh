#! /bin/bash
#
# Configuration parameters for disjunct distributions.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19015
export PORT=20015

export PROMPT="(r15-500)"
export PROMPT="(r15-6k)"
export PROMPT="(r15-2500)"
export PROMPT="(r15-goe)"

# export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-sim500.conf

# Location of the database containing MPG pairs
export MST_DB=${ROCKS_DATA_DIR}/r15-sim500.rdb
export MST_DB=${ROCKS_DATA_DIR}/r15-sim2500.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r15-sim6000.rdb
export MST_DB=${ROCKS_DATA_DIR}/r15-goe.rdb

export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"
