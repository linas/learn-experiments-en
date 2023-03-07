Experiment 18
=============
November 2022

The changes to LG in expt-17 now opens the door for a unified
pair-parsing, MST-parsing, gram-parsing and clustering, as an
integrated, continuous system. This should be much better, but
requires bring-up.

So here we go.

files
* `r18-pairs.rdb` -- block-counted pairs, for fanfic only.


Bringup Notes
-------------
Gonna cheat a bit, start with `run-1-marg-tranche-123.rdb` --
this has all pairs, untrimmed, but with marginals.
No that fails.

Well, try two things:
(1) MST parsing with LG
(2) GOE from pairs

Next ... items:
* Use uniform sentence lengths DONE
config OBSERVE `(observe-block TEXT)`


batch-pairs -- run-common
make-any-link-api -- used

------

Should cog-push-atomspace be cow?  (not documented!)

Check old code:
-----------
This is for the old pe-sentence observe code:
fanfic
total cpu time: 4514 minutes
(monitor-parse-rate "foo")
foo done=547692 rate=9.716 sentences per sec
(gc-time-taken . 149815788883396) == 2497 minutes!
 (heap-size . 12095488)
 (gc-times . 624593)

so 1.14 gc's per sentence NUTS!!
and 2497 / 4514 = 55% of cpu spent in GC ouch!

(ListLink . 6630619)
(EvaluationLink . 6630619)
(WordNode . 67703)
(SentenceNode "ANY" (ctv 1 0 547692)) ; count matches above
(ParseNode "ANY" (ctv 1 0 1.29022e+07)) ; approx 24 * nsent
tot-lines: 2199812 approx 4 * nsent
tot-cnct: 565697 nsent plus a few manual commands
cpu: 270893.022 secs  user: 221046.679  sys: 49846.343
maxrss: 26023264 KB  majflt: 56  inblk: 48  outblk: 178783224
18.2 G virt 16.1 G resident
(count-all) ; 13328951 == 13M so about 1.2KB per atom
wc pair-counted/fanfic/ * == 547703
