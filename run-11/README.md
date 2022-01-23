
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
