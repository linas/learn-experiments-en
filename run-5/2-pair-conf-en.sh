#! /bin/bash
#
# Configuration parameters for English word-pair counting.
# See `2-pair-conf.sh` for documentation of these parameters.
# ------------

# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=17005
export PROMPT="scheme@(en-pairs)"
export COGSERVER_CONF=${CONFIG_DIR}/2-cogserver/cogserver-pairs-en.conf

# Location of the trimmed database
export PAIRS_DB=${ROCKS_DATA_DIR}/r5-prs1-trim-1-1-1.rdb
export PAIRS_DB=${ROCKS_DATA_DIR}/r5-prs1-trim-5-5-2.rdb
export PAIRS_DB=${ROCKS_DATA_DIR}/r5-prs1-trim-10-10-4.rdb
export PAIRS_DB=${ROCKS_DATA_DIR}/r5-prs1-trim-20-20-6.rdb
export PAIRS_DB=${ROCKS_DATA_DIR}/r5-prs1-trim-40-40-8.rdb
export PAIRS_DB=${ROCKS_DATA_DIR}/r5-prs1-trim-80-80-12.rdb

export STORAGE_NODE="(RocksStorageNode \"rocks://${PAIRS_DB}\")"
