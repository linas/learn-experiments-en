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

# Location where the text corpus and the dictionary files are located.
# This allows different corpora to be used in different experiments.
export TEXT_DIR=/home/ubuntu/text/

# Location where the RocksDB databases are kept. This allows different
# experiments to re-use the same filenames, changing only the directory.
# It is recommended that this be located on an SSD disk, for
# performance.
# If you are using Postgres, just delete `ROCKS_DATA_DIR`.
export ROCKS_DATA_DIR=/home/ubuntu/data/

# Directory in which configuration parameters (including this file)
# are located. Obtained automatically; don't change.
export CONFIG_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# The master config file, which is this file.  Don't change.
export MASTER_CONFIG_FILE=${CONFIG_DIR}/$( basename "${BASH_SOURCE[0]}" )

# File containing pair-counting configuration.
# Change this as desired.
export PAIR_CONF_FILE=$CONFIG_DIR/2-pair-conf-en.sh

# File containing MST-parsing configuration.
export MST_CONF_FILE=$CONFIG_DIR/3-mst-conf.sh

# File containing grammatical-class configuration
export GRAM_CONF_FILE=$CONFIG_DIR/4-gram-conf.sh

# File containing dictionary export configuration
export EXPORT_CONF_FILE=$CONFIG_DIR/5-export-conf.sh
