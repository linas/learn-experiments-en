#! /bin/bash
#
# Configuration parameters for disjunct distributions.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19014
export PORT=20014
# export PORT=20114
# export PORT=20214
# export PORT=20314
# export PORT=20414

export PROMPT="(r14)"
export PROMPT="(r14-i0)"
# export PROMPT="(r14-i1)"
# export PROMPT="(r14-i2)"
# export PROMPT="(r14-i3)"
# export PROMPT="(r14-i4)"

export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i0.conf
# export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i1.conf
# export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i2.conf
# export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i3.conf
# export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i4.conf

# Location of the database containing MPG pairs
export MST_DB=${ROCKS_DATA_DIR}/r14-sim200.rdb
export MST_DB=${ROCKS_DATA_DIR}/r14-imp-q0.7-c0.9-n0.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r14-imp-q0.7-c0.9-n1.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r14-imp-q0.7-c0.9-n2.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r14-imp-q0.7-c0.9-n3.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r14-imp-q0.7-c0.9-n4.rdb

export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"
