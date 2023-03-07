#! /bin/bash
#
# 0-pipeline.sh
#
# Master file for configuration parameters for langugage learning.
# This particular file is aimed at artificial-language/corpus
# generation and processing.
# ----------

# Location where processing scripts are installed.
# export COMMON_DIR=/usr/local/share/opencog/learn/run-common
export COMMON_DIR=/home/ubuntu/src/learn/run-common

export TEXT_DIR=/home/ubuntu/textx

export ROCKS_DATA_DIR=/home/ubuntu/data/

# Directory in which configuration parameters (including this file)
# are located. Obtained automatically; don't change.
export CONFIG_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# The master config file, which is this file.  Don't change.
export MASTER_CONFIG_FILE=${CONFIG_DIR}/$( basename "${BASH_SOURCE[0]}" )

export PAIR_CONF_FILE=$CONFIG_DIR/2-pair-conf-en.sh
export MST_CONF_FILE=$CONFIG_DIR/3-mst-conf-en.sh
