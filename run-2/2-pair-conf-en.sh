#! /bin/bash
#
# Configuration parameters for English word-pair counting.
# See `2-pair-conf.sh` for documentation of these parameters.
# ------------

# Directory where corpora files can be found
export CORPORA_DIR=$TEXT_DIR/alpha-guten-tranche-1
# export CORPORA_DIR=$TEXT_DIR/alpha-fanfic-tranche-2

# File processing grunge.
export IN_PROCESS_DIR=pair-split
export COMPLETED_DIR=pair-counted-tranche-1
export MSG="Splitting and word-pair counting"

# Enable sentence splitting.
export SENTENCE_SPLIT=true
export SPLIT_LANG=en

# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=17005
export PROMPT="scheme@(en-pairs)"
export COGSERVER_CONF=${CONFIG_DIR}/2-cogserver/cogserver-pairs-en.conf

# Scheme function name for word-pair counting
export OBSERVE="observe-text"

# Location of the database where pair counts will be accumulated
export PAIRS_DB=${ROCKS_DATA_DIR}/en_pairs-t1.rdb
export STORAGE_NODE="(RocksStorageNode \"rocks://${PAIRS_DB}\")"
