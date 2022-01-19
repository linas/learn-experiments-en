#! /bin/bash
#
# Configuration parameters for disjunct distributions.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19010
export PROMPT="scheme@(run-10)"
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-en.conf

# Location of the database containing MPG pairs
export MST_DB=${ROCKS_DATA_DIR}/run-1-t1234-shape.rdb
export MST_DB=${ROCKS_DATA_DIR}/r10-merge.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r10-singles.rdb
export MST_DB=${ROCKS_DATA_DIR}/r10-mrg-q0.6-c0.3.rdb
export MST_DB=${ROCKS_DATA_DIR}/r10-mrg-q0.7-c0.4.rdb
export MST_DB=${ROCKS_DATA_DIR}/r10-mrg-q0.8-c0.5.rdb
export MST_DB=${ROCKS_DATA_DIR}/r9-sim-200+entropy.rdb
export MST_DB=${ROCKS_DATA_DIR}/r9-sim-200+mi.rdb

export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"
