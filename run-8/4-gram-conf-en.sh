#! /bin/bash
#
# Configuration parameters for disjunct distributions.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19008
export PROMPT="scheme@(run-8)"
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-en.conf

# Location of the database containing MPG pairs
export MST_DB=${ROCKS_DATA_DIR}/r8-merge.rdb
export MST_DB=${ROCKS_DATA_DIR}/r9-sim-200.rdb
export MST_DB=${ROCKS_DATA_DIR}/r9-merge-c.rdb
export MST_DB=${ROCKS_DATA_DIR}/r9-merge-d.rdb
export MST_DB=${ROCKS_DATA_DIR}/r9-merge-f.rdb

export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"
