#! /bin/bash
#
# Configuration parameters for English word-pair counting.
# See `2-pair-conf.sh` for documentation of these parameters.
# ------------

# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=17013
export PROMPT="scheme@(en-pairs)"
export PROMPT="scheme@(r13-marg)"
export COGSERVER_CONF=${CONFIG_DIR}/2-cogserver/cogserver-pairs-en.conf

# Location of the raw pairs database
export PAIRS_DB=${ROCKS_DATA_DIR}/run-1-marg-tranche-1234.rdb
export PAIRS_DB=${ROCKS_DATA_DIR}/run-1-en_pairs-tranche-1234.rdb
export PAIRS_DB=${ROCKS_DATA_DIR}/run-1-en_pairs-tranche-123.rdb
export PAIRS_DB=${ROCKS_DATA_DIR}/run-1-marg-tranche-123.rdb
# export PAIRS_DB=${ROCKS_DATA_DIR}/r3-mpg-marg.rdb
export PAIRS_DB=${ROCKS_DATA_DIR}/run-1-t12-tsup-1-1-1.rdb
export PAIRS_DB=${ROCKS_DATA_DIR}/run-1-t123-tsup-1-1-1.rdb
export PAIRS_DB=${ROCKS_DATA_DIR}/run-1-t123-clean-1-1-1.rdb

export STORAGE_NODE="(RocksStorageNode \"rocks://${PAIRS_DB}\")"
