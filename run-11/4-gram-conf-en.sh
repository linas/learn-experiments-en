#! /bin/bash
#
# Configuration parameters for disjunct distributions.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19011
export PORT=20411
export PORT=20211
export PROMPT="scheme@(run-11-imp4)"
export PROMPT="scheme@(run-11-imp2)"
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-n4.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-n3.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-n2.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i4.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i2.conf

# Location of the database containing MPG pairs
export MST_DB=${ROCKS_DATA_DIR}/r9-sim-200+mi.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-mrg-q0.7-c0.2-n4.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-mrg-q0.7-c0.2-n3.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-mrg-q0.7-c0.2-n2.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-imp-q0.7-c0.2-n4.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-imp-q0.7-c0.2-n2.rdb

export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"
