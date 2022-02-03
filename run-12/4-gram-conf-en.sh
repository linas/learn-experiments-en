#! /bin/bash
#
# Configuration parameters for disjunct distributions.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19012
export PROMPT="scheme@(run-12)"
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram.conf

# Location of the database containing MPG pairs
export MST_DB=${ROCKS_DATA_DIR}/r12-trim.rdb

export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"
