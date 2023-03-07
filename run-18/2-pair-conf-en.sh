#! /bin/bash
#
# Configuration parameters for Planar MPG parsing.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=20018
export PROMPT="[0;34mscheme@(pairs-18)[0m "
export OCPROMPT="[0;32mcogserver@(pairs-18)[0m "
export LOGFILE=/tmp/cogserver-pairs-en.log

# Location where pair counts will accumulate.
export PAIRS_DB=${ROCKS_DATA_DIR}/r18-pair.rdb
export PAIRS_DB=${ROCKS_DATA_DIR}/r18-junk.rdb
export STORAGE_NODE="(RocksStorageNode \"rocks://${PAIRS_DB}\")"

export CORPORA_DIR=$TEXT_DIR/beta-pages
export CORPORA_DIR=$TEXT_DIR/betax

# Files will be moved from the above, to the below, as they
# get processed. This allows interrupted processes to be restarted,
# without repeating earlier work.
export IN_PROCESS_DIR=pair-split
export COMPLETED_DIR=pair-counted
export MSG="Word-pair counting"

# Enable sentence splitting.
export SENTENCE_SPLIT=false
export SENTENCE_SPLIT=true
export SPLIT_LANG=en
export OBSERVE="observe-text"
