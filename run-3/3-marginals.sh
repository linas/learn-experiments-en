#! /bin/bash
#
# Configuration parameters for computing MMT marginals
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19002
export PROMPT="scheme@(run-3ma)"
export COGSERVER_CONF=${CONFIG_DIR}/3-cogserver/marg.conf
export COGSERVER_CONF=${CONFIG_DIR}/3-cogserver/shape.conf
# export COGSERVER_CONF=${CONFIG_DIR}/3-cogserver/smack.conf
# export COGSERVER_CONF=${CONFIG_DIR}/3-cogserver/shape.conf
# export COGSERVER_CONF=${CONFIG_DIR}/3-cogserver/shupe.conf

# Location of the database containing MPG pairs
export MST_DB=${ROCKS_DATA_DIR}/r3-mpg-marg.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-filt-1280-256-160-marg.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-filt-640-128-80-marg.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-filt-320-64-40-marg.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-filt-160-32-20-marg.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-filt-80-16-10-marg.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-filt-40-8-5-marg.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-filt-20-4-2-marg.rdb

# export MST_DB=${ROCKS_DATA_DIR}/r3-filt-640-128-80-shape.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-filt-320-64-40-shape.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-filt-160-32-20-shape.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-filt-80-16-10-shape.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-filt-40-8-5-shape.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-filt-20-4-2-shape.rdb

# export MST_DB=${ROCKS_DATA_DIR}/r3-zfil-640-128-80-marg.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-zfil-320-64-40-marg.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-zfil-160-32-20-marg.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-zfil-80-16-10-marg.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-zfil-40-8-5-marg.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-zfil-20-4-2-marg.rdb

# export MST_DB=${ROCKS_DATA_DIR}/r3-zfil-640-128-80-shape.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-zfil-320-64-40-shape.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-zfil-160-32-20-shape.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-zfil-80-16-10-shape.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-zfil-40-8-5-shape.rdb
# export MST_DB=${ROCKS_DATA_DIR}/r3-zfil-20-4-2-shape.rdb

export STORAGE_NODE="(RocksStorageNode \"rocks://${MST_DB}\")"
