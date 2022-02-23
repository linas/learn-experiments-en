Restart of English language-learning. July 2021
===============================================

Directories:
* run-1 -- attempt to have a perfect run-through of everything. (July 2021)
* run-2 -- work with a flawed copy of tranche-1 only
* run-3 -- Similarity Smackdown - compare MI to overlap, jaccard, etc. (Aug 2021)
* run-4 -- Deep trimming of datasets (Sept 2021)
* run-5 -- Trimming of word-pair files.
* run-6 -- All similarities between top-ranked words.
* run-7 -- Exploring one merge at a time.
* run-8 -- Exploring one merge at a time, w/shapes, and more merges.
* run-9 -- Bringup of production ranked merge.


Databases in the `~/data` directory
===================================
The assorted run-1-*.rdb databases are "master copies" of the best
runs with the properly, correctly applied processing.  These took
a long time to generate, and need to be archived. They are imperfect:
right from the get-go, there's some bug with escaping quotes that
needlessly pollutes these files. However ... that bug has not been
found yet, has not been fixed yet, and we haven't re-run anything,
so the below will do.

* run-1-en_pairs-tranche-1.rdb -- run-1 guten-tranche-1 only.
* run-1-en_pairs-tranche-12.rdb -- run-1 guten-tranche-1 and 2.
* run-1-en_pairs-tranche-12*.rdb -- etc.

* run-1-t1*-trim-1-1-1.rdb -- MPG-parsed and trimmed to remove words,
     disjuncts, and sections with a count of 1. Includes MM^T marginals
     (but for word-disjunct pairs only) and redone pair marginals.
     This amount of trimming was not enough! See below.

* run-1-t1*-tsup-1-1-1.rdb -- As above, but also removed all words, disjuncts
     with a support of only 1. See see run-5, run-6 and diary part three.
     This is the correct amount to trim!  Includes MM^T marginals.
     ... but the MM^T marginals are only on the (w,d) pairs, and NOT
     on the shapes. The merge work needs shapes!

* run-1-t1*-shape.rdb -- Copy of above, with MM^T marginals on shapes.
     This is on the fat side, as it still retains the original
     word-pairs. It also contains the (un-needed) support and MM^T
     on the shapeless (w,d) pairs.

Junk Databases
==============
The following were generated in various experiments, but do not
need to be archived, they can be deleted.

* r2-en_pairs.rdb -- just pair counts for guten-tranche-1 only.
     Above is missing 400+ files. There were some crashes.
     Part of run-2 -- includes MI

* r2-mpg_parse.rdb -- MPG disjunct counts for above aka run-2.
     This includes the MM^T marginals.

* r3-* -- Assorted Similarilty Smackdown databases.

* r6-similarity-tsup.rdb -- copy of run-1-t1234-tsup-1-1-1.rdb with MI for
     word-pairs between the top 1200 wordvecs computed.

* r7-merge.rdb -- individual merge experiments.
* r8-merge.rdb -- individual merge experiments.
* r9-merge.rdb -- Bringup of production merge.

...THE END...