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

Files:
------
* `r19-pair-plain.rdb` -- pair-counts only, no marginals. See below.


Procedure
---------
Start from scratch.

* Copy fanfic to `textx/betax`.
* `guile -l cogserver.scm`
* `cd ~/src/learn/run-common`
* `. ~/experiments/run-19/0-pipeline.sh`
* `./process-corpus.sh ~/experiments/run-19/2-pair-conf-en.sh`
* Wait several days ... started 15 Feb 18:20 ... done 17 Feb 16:05
* (monitor-parse-rate "foo") says:
  done=6508938 rate=39.41 per sec
* Hmm. Upon completion, says:
  (EdgeLink . 7557354) (WordNode . 67334)
  which differs from run-18. Number of words differs; last time it was
  (WordNode . 67369) and so ... how did those words get lost??
  Is this explainable by segmentation alternatives, plus random sampling,
  so that some alternatives never got sampled, this time ???
* Also, a LOT fewer edges: only 3/4ths of the previous
  (EvaluationLink . 9935011) I don't know how to hand-wave this away due
  to random sampling. Oh ... but I can wave it away, because the block
  size was reduced to 9 from 12, so, actually, that's right!
* Grand total 10.8 GB RSS.  (count-all) reports 15182065
  so 711 Bytes/Atom. Wow! That's an all-time low!

Stats:
* (Sentence "ANY" (ctv 1 0 6.50894e+06))
* (Parse "ANY" (ctv 1 0 3.90536e+07)
  -- six parses per sentence.
* (gc-stats)  (gc-times . 6517579) so that's one GC per sentence... ouch
* total time: 23499 minutes, gc-time: 12627 minutes so 53% of CPU in GC.
  Ouch. I think I know why, its the gar/gdr or word-pairs.
* real    2741m46.211s elapsed time to submit.
* find pair-counted/fanfic |wc 4476
  This does not match the official count; seems a few files got lost...
* find ~/text-master-copy/alpha-fanfic-tranche-2/split-books/ |wc 4499
* telnet tot-cnct: 22376 -- how is this possible!?
* telnet stalls: 4461 -- one stall per file. This makes sense.

* wc pair-counted/fanfic/ * 442522 --- this is the number of lines.
  vs. 444835 in master copy. No great loss.
* telnet top command says: tot-lines: 469306 which is 6% more than
  number of lines in files, so... a few lines to open scm connection,
  etc.

* wc pair-counted/fanfic/ *  6597219 -- number of words -- about equal
  to number of sentences, makes sense, one sentence per slide, and num
  slides is same as num words.

So this all looks good.
