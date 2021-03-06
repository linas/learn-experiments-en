
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

then use #t to indicate "precise" similarity recomputation:
```
(in-group-cluster covr-obj 0.7 0.2 4 200 3000 #t)
(print-matrix-summary-report star-obj)
```

Log of merge activity:
```
(dump-log star-obj "/tmp/r11-xxx-log" print-log)
(dump-log star-obj "/tmp/r11-xxx-cls" print-merges)
```
actually use `dump-log.sh` instead

For speed, there are also "imprecise" computations:
Noise of 4:
```
r11-imp-q0.7-c0.2-n4.rdb
(in-group-cluster covr-obj 0.7 0.2 4 200 3000 #f)
```

Also imprecise noise of 3:
```
r11-imp-q0.7-c0.2-n3.rdb
(in-group-cluster covr-obj 0.7 0.2 3 200 3000 #f)
```

Imprecise Noise of 2:
```
r11-imp-q0.7-c0.2-n2.rdb
(in-group-cluster covr-obj 0.7 0.2 2 200 3000 #f)
```
Log of above may be garbled at merge 59; it crashed, and the log format
may be changed..... never mind. Restarted from scratch.


Imprecise Noise of 1:
```
r11-imp-q0.7-c0.2-n1.rdb
(in-group-cluster covr-obj 0.7 0.2 1 200 3000 #f)
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

Halted, power outage from snowstorm 4 Feb 2022 stopped everything
r11-imp-q0.7-c0.2-n1.rdb had 250 merges

LG Export
---------
Lets try export again:
```
cp -pr r11-imp-q0.7-c0.2-n1.rdb r11-export-trim.rdb

(define cset-obj (make-pseudo-cset-api))
(define gram-obj (add-gram-class-api cset-obj))
(gram-obj 'fetch-pairs)
(load "cleanup.scm")
(cleanup-gram-dataset gram-obj)
(cleanup-gram-dataset gram-obj)
(check-gram-dataset gram-obj)

cp -pr r11-export-trim.rdb r11-export-100-gcf.rdb

(define cset-obj (make-pseudo-cset-api))
(define cov (add-covering-sections cset-obj)) ; must do this
(cov 'fetch-pairs)
(check-gram-dataset cov)
; (cleanup-gram-dataset cov)  ; Not needed; above should be OK.

(define sin (add-singleton-classes cov))
(sin 'create-hi-count-singles 100)  ; whence the name export-100
After trimming, 5866 words left, out of 9573
Created 5866 singleton word classes in 5687 secs

So that's a pretty big sample. And too wayyy too long.

(cleanup-gram-dataset cov)
(cleanup-gram-dataset cov)
(cleanup-gram-dataset cov)
(check-gram-dataset cov)

; Ooops, should not have done this, see below.
(define gcf (add-word-remover cov #t))

(gcf 'left-basis-size) ; 5944
(gcf 'right-basis-size) ; 206202 OK, I guess

(batch-all-pair-mi gcf)
Finished with MI computations; this took 0.269 hours.

(use-modules (opencog nlp lg-export))
(export-csets gcf "/tmp/dict.db" "EN_us")

Finished inserting 720997 records in 229 secs (3148.5/sec)
```
---------------------
Try again.
```
cp -pr r11-export-100-gcf.rdb r11-export-100.rdb

(define cset-obj (make-pseudo-cset-api))
(define cov (add-covering-sections cset-obj)) ; must do this
(cov 'fetch-pairs)
(cleanup-gram-dataset cov)  ; Yes, its needed.
(cleanup-gram-dataset cov)  ; ... at least twice...
(check-gram-dataset cov)

(define (is-word-class? ITEM) (eq? 'WordClassNode (cog-type ITEM))
(cov 'implode-sections)
(linking-trim cov is-word-class?)

(cleanup-gram-dataset cov)
(cleanup-gram-dataset cov) ; ... at least twice ...

(cov 'explode-sections)
(batch-all-pair-mi cov)
Finished with MI computations; this took 2.549 hours.

Rows: 5877 Columns: 933026
Size: 2348063.0
Total observations: 21856976.0
Entropy Total: 18.680   Left: 16.229   Right: 8.5677
Total MI: 6.1172
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
