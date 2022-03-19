
Experiment 14
=============
Very similar to run-12, but with some a-priori fixes of known
dataset bugs. This includes:

* Removal of all CrossSections inadvetently stored in the
  sim dataset.
* Removal of all Shapes (i.e. marginals) followed by a
  recomutation of the same marginals.


```
cp -pr r12-mi-sim200.rdb r14-sim200.rdb
guile -l cogserver.scm
(load-atoms-of-type 'Shape)
(for-each cog-delete-recursive! (cog-get-atoms 'Shape))
```
Then exit and restart:
```
guile -l cogserver-gram.scm
(star-obj 'clobber)
; (define cfq (make-compute-freq star-obj))
; (cfq 'init-freq)
; (cfq 'cache-all)
; Oh No!!! Need to storeobj all pairs incuding CrossSecitons!
; (define enc (add-entropy-compute star-obj))
; (enc 'cache-all-left-entropy)
; (enc 'cache-all-right-entropy)

(define btr (batch-transpose star-obj))
(btr 'mmt-marginals)
```

The frequencies and entropies are needed only because we are logging
progress; except for logging, these are not otherwise needed.
... and I'm not tracking them any longer. They've been a huge pain
in the butt. Not only do they need recomputation, but they also
depend on the freq obj to stores freqs on CrossSections ... which
we are NOT storing in the DB! So Basically, all is borked unless
we store CrossSections.

I guess that's why run-12 stored CrossSections ... but only intially.
After a crash and restart, the run-12 had the wrong frequencies on the
CrossSections, which inhibited the restarts. What an effing mess that
was.  Painful, lost several weeks of time.

I think the similarities are still valid from before.
```
(print-matrix-summary-report star-obj)

Rows: 9495 Columns: 1015850  == log_2 13.2130 x 19.9543
Size: 2717117.0  log_2 size: 21.3736
Fraction non-zero: 2.8170E-4 Sparsity: 11.7936  Rarity: 4.79004
Total obs: 22643824.0  Avg obs/pair: 8.33377  log_2 avg: 3.05897
Entropy Tot: 19.4210  Left: 16.5007  Right: 8.46831  MI: 5.54801
MM^T support=193557505.0     count=131743839840.0     entropy=18.117
```


Run-14 clustering
=================
Run 4 total clustering efforts. These are
```
cp -pr r14-sim200.rdb r14-imp-q0.7-c0.9-n0.rdb
cp -pr r14-sim200.rdb r14-imp-q0.7-c0.9-n1.rdb
cp -pr r14-sim200.rdb r14-imp-q0.7-c0.9-n3.rdb
cp -pr r14-sim200.rdb r14-imp-q0.7-c0.9-n6.rdb

(in-group-cluster covr-obj 0.7 0.9 0 200 3000)
(in-group-cluster covr-obj 0.7 0.9 1 200 3000)
(in-group-cluster covr-obj 0.7 0.9 3 200 3000)
(in-group-cluster covr-obj 0.7 0.9 6 200 3000)
```
and the correspondingly-named rocks files.

Do NOT use HUGETLB -- this burns when running out of ram,
the malloc just .. fails, and everything fucks up.

Notable differences from run-12:
* This will log the orthogonality of the clusters
* Setting commonality to 0.9 eliminates that variable
* Uses the new exhaustive-jaccard implementation to create groups.

========
