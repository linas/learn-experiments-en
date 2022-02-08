
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
```

---------------
