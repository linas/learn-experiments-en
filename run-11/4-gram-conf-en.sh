#! /bin/bash
#
# Configuration parameters for disjunct distributions.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=20111
export PORT=20211
export PORT=20311
export PORT=20411
export PORT=19611
export PORT=19711
export PORT=19811
export PROMPT="scheme@(run-11-imp1)"
export PROMPT="scheme@(run-11-imp2)"
export PROMPT="scheme@(run-11-imp3)"
export PROMPT="scheme@(run-11-imp4)"
export PROMPT="scheme@(run-11-prc6)"
export PROMPT="scheme@(run-11-prc7)"
export PROMPT="scheme@(run-11-prc8)"
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i1.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i2.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i3.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i4.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-p6.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-p7.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-p8.conf

# Location of the database containing MPG pairs
export MST_DB=${ROCKS_DATA_DIR}/r9-sim-200+mi.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-mrg-q0.7-c0.2-n4.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-fibers.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-imp-q0.7-c0.2-n1.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-imp-q0.7-c0.2-n2.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-imp-q0.7-c0.2-n3.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-imp-q0.7-c0.2-n4.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-mrg-q0.6-c0.2-n4.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-mrg-q0.7-c0.2-n4.rdb
export MST_DB=${ROCKS_DATA_DIR}/r11-mrg-q0.8-c0.2-n4.rdb

export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"
