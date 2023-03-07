Experiment 19
=============
Feb 2023

Big changes since expt-18:
* Change atomspace to use EdgeLink not EvaluationLink
* Major redo of LG for MST parsing.

An unfulfilled goal from run-18:
* Unified pair-parsing, MST-parsing, gram-parsing and clustering,
  as an integrated, continuous system. This remains an out-of-reach
  dream.

Procedure
---------
Start from scratch.

* Copy fanfic to `textx/betax`.
* `guile -l cogserver.scm`
* `cd ~/src/learn/run-common`
* `. ~/experiments/run-19/0-pipeline.sh`
* `./process-corpus.sh ~/experiments/run-19/2-pair-conf-en.sh`
* Wait several days ... started 15 Feb 18:20 ...
