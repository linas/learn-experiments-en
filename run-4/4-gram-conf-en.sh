#! /bin/bash
#
# Configuration parameters for disjunct distributions.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19006
export PROMPT="scheme@(run-4)"
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-en.conf

# Location of the database containing MPG pairs
export MST_DB=${ROCKS_DATA_DIR}/r4-mpg-marg.rdb
export MST_DB=${ROCKS_DATA_DIR}/r4-zfil-10-4-2-pass-1.rdb
export MST_DB=${ROCKS_DATA_DIR}/r4-zfil-10-4-2-pass-2.rdb
export MST_DB=${ROCKS_DATA_DIR}/r4-zfil-10-4-2-pass-3.rdb
export MST_DB=${ROCKS_DATA_DIR}/r4-zfil-10-4-2-pass-4.rdb
export MST_DB=${ROCKS_DATA_DIR}/r4-zfil-10-4-2-pass-5.rdb
export MST_DB=${ROCKS_DATA_DIR}/r4-zfil-10-4-2-pass-6.rdb
export MST_DB=${ROCKS_DATA_DIR}/r4-zfil-10-4-2-pass-7.rdb

export MST_DB=${ROCKS_DATA_DIR}/r4-mpg-marg.rdb
export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"
