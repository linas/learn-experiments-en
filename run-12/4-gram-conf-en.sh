#! /bin/bash
#
# Configuration parameters for disjunct distributions.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19012
export PORT=19612
export PORT=19712
export PORT=19812
export PORT=21812
export PORT=20112
# export PORT=20212
# export PORT=20312
# export PORT=20412

export PROMPT="(r12-p6)"
export PROMPT="(r12-p7)"
export PROMPT="(r12-p8)"
export PROMPT="(r12-p8-1)"
export PROMPT="(r12-i1)"
# export PROMPT="(r12-i2)"
# export PROMPT="(r12-i3)"
# export PROMPT="(r12-i4)"

export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-p6.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-p7.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-p8.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-p8-1.conf
export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i1.conf
# export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i2.conf
# export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i3.conf
# export COGSERVER_CONF=${CONFIG_DIR}/4-cogserver/cogserver-gram-i4.conf

# Location of the database containing MPG pairs
export MST_DB=${ROCKS_DATA_DIR}/r12-prc-q0.6-c0.2-n4.rdb
export MST_DB=${ROCKS_DATA_DIR}/r12-prc-q0.7-c0.2-n4.rdb
export MST_DB=${ROCKS_DATA_DIR}/r12-prc-q0.8-c0.2-n4.rdb
export MST_DB=${ROCKS_DATA_DIR}/r12-prc-q0.8-c0.2-n1.rdb
export MST_DB=${ROCKS_DATA_DIR}/r12-imp-q0.7-c0.2-n1.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r12-imp-q0.7-c0.2-n2.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r12-imp-q0.7-c0.2-n3-ext.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r12-imp-q0.7-c0.2-n4.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r12-imp-q0.7-c0.2-n4-ext.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r12-wtf.rdb

export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"
