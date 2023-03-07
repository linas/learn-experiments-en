#! /bin/bash
#
# Configuration parameters for Planar MPG parsing.
#
# IPv4 hostname and port number of where the cogserver is running.
export HOSTNAME=localhost
export PORT=19019
export OCPROMPT="[0;32mcogserver@(pairs-19)[0m "
export PROMPT="scheme@(pairs-19) "
export LOGFILE=/tmp/cogserver-bond-en.log

# Location where pair counts will accumulate.
export PAIRS_DB=${ROCKS_DATA_DIR}/r19-pair.rdb
export STORAGE_NODE="(RocksStorageNode \"rocks://${PAIRS_DB}\")"

export CORPORA_DIR=$TEXT_DIR/beta-pages
export CORPORA_DIR=$TEXT_DIR/betax

# Files will be moved from the above, to the below, as they
# get processed. This allows interrupted processes to be restarted,
# without repeating earlier work.
export IN_PROCESS_DIR=pair-split
export COMPLETED_DIR=pair-counted
export MSG="Word-pair counting"

# Use block submission
export OBSERVE="observe-block-pairs"

# -----------
