
Experiment 12
=============
Sanity check.  Apparently, files from run-10 are not consistent
with linkage (have connectors that cannot connect to words) and
also have spurious marginals in them. The goal here is to get to
the bottom of things, and try to have a clean dataset... again.

```
time cp -r run-1-t1234-tsup-1-1-1.rdb  r12-trim.rdb

(define cset-obj (make-pseudo-cset-api))
(cset-obj 'fetch-pairs)
(define stars-obj (add-pair-stars cset-obj))

(check-linkability stars-obj)
```
OK, that passes, as before. So ?

... r9-sim-200.rdb with csets-only tests OK.
Also with cover-obj tests OK
also OK after implode-sections.   So ... is it the merges??

-------------------------------------------------------
Anyway, above checks were not bi-directional on the linkages.
So, from scratch:
```
cp -r run-1-t1234-tsup-1-1-1.rdb  r12-trim.rdb

(define cset-obj (make-pseudo-cset-api))
(cset-obj 'fetch-pairs)
(define stars-obj (add-pair-stars cset-obj))
(load "cleanup.scm")
(check-gram-dataset stars-obj)
(cleanup-gram-dataset stars-obj)
(stars-obj 'clobber)
(cleanup-gram-dataset stars-obj)  ; yes, run it twice
(check-gram-dataset stars-obj)

;;;;; marginals-mst.scm   ; copy by hand.
(define btr (batch-transpose stars-obj))
(btr 'clobber)
(btr 'mmt-marginals)
(print-matrix-summary-report stars-obj)

cp -pr r12-trim.rdb r12-mst.rdb
```

OK so I think that's good. Now add shapes.
```
;;; Run marginals-mst-shape.scm by hand
(define csc (add-covering-sections cset-obj))
(csc 'explode-sections)
(define btr (batch-transpose csc))
(btr 'clobber)
(btr 'mmt-marginals)

cp -pr r12-trim.rdb r12-shape.rdb
```
So the above yeilds a dataset with shape marginals. But, for merging,
we've been using the ranked MI, so we need that too.
```
(define csc (add-covering-sections cset-obj))
(csc 'explode-sections)
(batch-all-pair-mi csc)
Finished with MI computations; this took 2.496 hours.

cp -pr r12-trim.rdb r12-mi.rdb
```

OK, now, precompute similarity:
```
guile -l cogserver-gram.scm
(setup-initial-similarities star-obj 200)
; Done computing MI similarity in 5929 secs


cp -pr r12-trim.rdb r12-mi-sim200.rdb
```

Now make sure that merging preserves the clean structure.
Right?
```
(in-group-cluster covr-obj 0.8 0.2 4 200 1 #f)
(load "cleanup.scm")
(check-gram-dataset covr-obj)
```

Run-12 clustering
=================
Run 8 total clustering efforts. These are
```
(in-group-cluster covr-obj 0.6 0.2 4 200 3000 #t)
(in-group-cluster covr-obj 0.7 0.2 4 200 3000 #t)
(in-group-cluster covr-obj 0.8 0.2 4 200 3000 #t)
(in-group-cluster covr-obj 0.8 0.2 1 200 3000 #t)

(in-group-cluster covr-obj 0.7 0.2 1 200 3000)
(in-group-cluster covr-obj 0.7 0.2 2 200 3000)
(in-group-cluster covr-obj 0.7 0.2 3 200 3000)
(in-group-cluster covr-obj 0.7 0.2 4 200 3000)
```
and the correspondingly-named rocks files.

Run with
`HUGETLB_MORECORE=yes LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libhugetlbfs.so.0 guile -l cogserver-gram.scm`

---------------
8 Feb 2022

The imprecise `(in-group-cluster covr-obj 0.7 0.2 2 200 3000)`
job crashed at iteration 176. After bug-fixes and restart, it fails
to move forward:
```
Throw to key `bad-summation' with args `(compute-total-entropy "Left and
right entropy sums fail to be equal: 23.73641651069839
27.248554685599636\n")'.
```

Choices: start from zero, or just recompute marginals (batch-mi).
Lets try batch-mi first:
```
(batch-all-pair-mi covr-obj)
Finished with MI computations; this took 4.449 hours.
```

Fuu. Crashes because
`(WordClassNode "perhaps by where no after without with each from since these had during I’m of are were others")`
did not have support on it.

Seems that the above batch failed to recompute for this one...
How did that happen?


Crashed immediately, with
```
Throw to key `bad-summation' with args `(compute-total-entropy "Left and
right entropy sums fail to be equal: 19.136441476785922
19.1239452333717\n")'.
```

Conclude: batch summation missed something, and when added by hand,
I failed to recompute both left and right.  Clearly there is a bug,
and it might be a significant bug, and I am going to pretend it is not
there cause I don't have the time to deal with it right now.

The damaged files are
```
r12-imp-q0.7-c0.2-n2.rdb-175-maybe-mildly-bork
r12-imp-q0.7-c0.2-n2.rdb-175-fresh-marginals
```
and the fresh-marginals is missing support for the above word-class
(and what else is it missing?)


I'm going to restart, fresh.
---------------
21 Feb 2022
-----------
Five jobs halted due to failure to get hugepages. Crap.
These are
```
r12-prc-q0.8-c0.2-n1.rdb-139-crash
```
and the four imprecise. The four imprecise won't start due to some
bug with quotes in some class names.

The precise crashes with unbalanced marginals.
```
------ Start merge 139 with seed pair `his their the` and `his`
Initial in-group size=6: `his` `his their the` `a` `my` `any` `our`
In-group size=6 overlap = 211 of 77350 disjuncts, commonality= 0.27%
In-group size=5 overlap = 473 of 75644 disjuncts, commonality= 0.63%
In-group size=4 overlap = 2548 of 73290 disjuncts, commonality= 3.48%
In-group size=3 overlap = 7974 of 69555 disjuncts, commonality= 11.46%
In-group size=2 overlap = 3271 of 24675 disjuncts, commonality= 13.26%
In-group size=2: `his` `his their the`
------ merge-majority: Merge 6064 of 7767 sections in 7 secs
------ merge-majority: Remaining 4355 of 16906 cross in 18 secs
------ Merged into `his his their the` in 57 secs
------ Find affected basis of (7114, 65210) in 204 secs
------ Recomputed entropies in 329 secs
ice-9/boot-9.scm:1669:16: In procedure raise-exception:
Throw to key `bad-summation' with args `(compute-total-entropy "Left and
right entropy sums fail to be equal: 20.829045669971702
25.023068763264902\n")'.
```
So then:
```
(batch-all-pair-mi covr-obj)
Finished with MI computations; this took 2.824 hours.
```
That seems to do the trick.

Spoke too soon .. after two iterations, it fails again:
```
Throw to key `bad-summation' with args `(compute-total-entropy "Left and right entropy sums fail to be equal: 19.055120243768545 19.04535087816835\n")'.
```
So the basis is borked somehow...

Recomputed MI, restart, merge goes then fails with
```
Throw to key `bad-membership' with args `(merge-majority "No counts on
word class!")'.
```

Abandon all hope. Kill this, and restart completly from scratch.
Crap.

-----------------------------------------------------------------

The other is a care-dump:
In cogserver-gram.scm:
20:0  2 ()
In opencog/matrix/direct-sum.scm:
189:24  1 (_ _ . _)
In unknown file:
0 (opencog-extension dflt-fetch-incoming-by-type (# #))
ERROR: In procedure opencog-extension:
Atomspace C++ exception:
(dflt-fetch-incoming-by-type Missing closing paren in StringValue:  "+ —
” _ ) [" "+ [ "
```

Seems like it was bad escaping in `ValueSexpr.cc` ... oh well.

---------------------------------
So, the above is now fixed .... but log files:
r12-cls-q0.7-c0.2-n4.dat is missing records 941 to 953 but says "start
merge 1057 " so wtf ....

Also r12-cls-q0.7-c0.2-n1.dat is missing 369 to 1204 but says "start
merge 1342" so another big wtf.

So I guess the crash caused the logs to not get written ...
crap.

-----------
and now imprecise-2 is failing with unbalanced ....
and try
```
(batch-all-pair-mi covr-obj)
```

and imprecise-3 also crashes with unbalanced...
and imprecise 1 and 4 ... so all 4 crashed.
Re-batching on all four, see if we get lucky....

after rebatching, 3 dies with
```
Throw to key `bad-membership' with args `(merge-majority "No counts on word class!")'.
```

after rebatchng, 2 dies with unbalanced marginals ... and so do 1 and 4.
So end of the line on all the imprecise datasets.

========
25 Feb 2022

OK, try to do some data analysis on what we got.
First, save the good copies:
```
cp -pr r12-imp-q0.7-c0.2-n3.rdb r12-imp-q0.7-c0.2-n3-ext.rdb
cp -pr r12-imp-q0.7-c0.2-n4.rdb r12-imp-q0.7-c0.2-n4-ext.rdb
```
and work with the ext files.

So what's the deal with the marginals? Why is recomputing them not
enough? Who is missing what? Didn't we go through this once before?
like maybe in run-10? But that was during merges.  Start all over
again.  See the notes.

Ahh. The files contain CrossSections that were never deleted.
1) delete the CrossSections
2) exit, restart normally,
3) run the cleanup scripts to remove bogus marginals
4) recompute entropy marginals:
5) recompute mmt
6) perform experiments

Huh. This might be enough to revive the halted runs!

To redo the entropies:
(star-obj 'clobber)
(define cfq (make-compute-freq star-obj))
(cfq 'init-freq)
(cfq 'cache-all-left-freqs)
(cfq 'cache-all-right-freqs)
(define enc (add-entropy-compute star-obj))
(enc 'cache-all-left-entropy)
(enc 'cache-all-right-entropy)

Then the mmt:
(define btr (batch-transpose star-obj))
(btr 'mmt-marginals)

Well, but then some of the similarities are clearly bad, because
they were not recomputed in earlier merges. In particular, noise=1
fails this way. Getting tedious. Seems best to restart with the new
code.

Abandon ship. I'm tired of patching the problems. That, plus the
new "orthogonality" metric sounds intersting. Also the new
jaccard-membership implementation is intrigueing. Also, set
commonality to 0.9 to just avoid that. So restart fresh in
run-14.

========
