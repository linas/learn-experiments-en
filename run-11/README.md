
Run-11 -- Deep Merge
--------------------
Jan 2021

Run-10 failed to keep all the stats that we wanted. More importantly,
there was the discovery that perhaps regular MI is better for in-group
voting. There were also assorted minor bugs.

Run-11 goes deep. It uses regular MI for the in-group formation. It
explores the effect of the noise parameter, as it seems to have the
greatest effect after QUORUM.

To run this:
```
cd ~/data
cp -pr r9-sim-200+mi.rdb r11-mrg-q0.7-c0.2-n4.rdb
. ~/experiments/run-11/4-gram-conf-en.sh
cd ~/src/learn/run-common
guile -l cogserver-gram.scm
```

then
```
(in-group-cluster covr-obj 0.7 0.2 4 200 3000)
(print-matrix-summary-report star-obj)
```

Log of merge activity:
```
(print-log #t)
(print-merges #t)
```

Also noise of 3:
```
r11-mrg-q0.7-c0.2-n3.rdb
(in-group-cluster covr-obj 0.7 0.2 3 200 3000)
```

Noise of 2:
```
r11-mrg-q0.7-c0.2-n2.rdb
(in-group-cluster covr-obj 0.7 0.2 2 200 3000)
```


Sample output from n=3
----------------------
```
------ Start merge 1 with seed pair `—` and `+`
Initial in-group size=8: `+` `—` `”` `_` `)` `[` `(` `]`
In-group size=8 overlap = 12 of 13987 disjuncts, commonality= 0.09%
In-group size=7 overlap = 25 of 13400 disjuncts, commonality= 0.19%
In-group size=6 overlap = 45 of 12840 disjuncts, commonality= 0.35%
In-group size=5 overlap = 40 of 12004 disjuncts, commonality= 0.33%
In-group size=6: `+` `—` `”` `_` `)` `[`
------ merge-majority: Merge 4884 of 7957 sections in 11 secs
------ merge-majority: Remaining 12502 of 22863 cross in 37 secs
------ Merged into `+ — ” _ ) [` in 106 secs
------ Find affected basis of (12857, 98371) in 542 secs
------ Recomputed entropies in 725 secs
------ Recomputed MMT marginals in 2527 secs
------ Recomputed MI in 299 secs
------ Completed merge in 2932 secs
------ Extended the universe in 119 secs
```

Appendix of How-to notes below.
===============================

Recompute the marginals
------------------------
Not needed; just left-over notes from run-10 about run-9:

To recompute the marginals, do this:
Starting point is a copy of `run-1-t1234-tsup-1-1-1.rdb`.
Start from scratch with the shapes:

```
$ cp -pr run-1-t1234-tsup-1-1-1.rdb run-1-t1234-shape.rdb
```
Then recompute by running `marginals-mst-shape.scm` aka
`run/3-mst-parsing/compute-mst-marginals.sh`
```
. 0-pipeline.sh
cd ${COMMON_DIR}/
../run/3-mst-parsing/compute-mst-marginals.sh
```

OK, this gives the same-old:
```
Wildcard: (EvaluationLink (ctv 0 0 2.29426e+07)
  (PredicateNode "*-Direct Sum Wild (gram-class⊕cross-section)")
  (AnyNode "left-wild-direct-sum")
  (AnyNode "right-wild-direct-sum"))
```

Base layer of similarities
--------------------------
Not needed, we have these from run-9. The entropies were redone in r10.

Track entropies, too.
```
cp -pr r9-sim-200.rdb r9-sim-200+entropy.rdb
guile -l cogserver-gram.scm
(define cfr (make-compute-freq star-obj))
(cfr 'init-freq)
(cfr 'cache-all)
; 2777968 -- correct
(define ent-obj (add-entropy-compute star-obj))
(ent-obj 'cache-all-right-entropy)
; Finished right entropy subtotals in 107 secs
(ent-obj 'right-entropy) ; 8.514785640953038
(define store-obj (make-store  star-obj))
(store-obj 'store-wildcards)
```
Cannot cache, cause the right's are missing.

du -s
9578520 r9-sim-200.rdb
9866940 r9-sim-200+entropy.rdb
9727580 r9-sim-200+mi.rdb


Track all MI:
```
cp -pr r9-sim-200.rdb r9-sim-200+mi.rdb
guile -l cogserver-gram.scm
(batch-all-pair-mi star-obj)
```
Finished with MI computations; this took 3.134 hours.

du -s
9727580 r9-sim-200+mi.rdb
Elapsed time to load cross-sections: 475 seconds
which is much longer than the earlier
Elapsed time to load cross-sections: 113 seconds
Entropy Total: 19.463   Left: 16.535   Right: 8.5148
Total MI: 5.5865

-------------------------------------------

The End
-------
