
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
(define cfq (make-compute-freq star-obj))
(cfq 'init-freq)
(cfq 'cache-all-left-freqs)
(cfq 'cache-all-right-freqs)
(define enc (add-entropy-compute star-obj))
(enc 'cache-all-left-entropy)
(enc 'cache-all-right-entropy)

(define btr (batch-transpose star-obj))
(btr 'mmt-marginals)
```

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
Run 3 total clustering efforts. These are
```
cp -pr r14-sim200.rdb r14-imp-q0.7-c0.9-n0.rdb
cp -pr r14-sim200.rdb r14-imp-q0.7-c0.9-n1.rdb
cp -pr r14-sim200.rdb r14-imp-q0.7-c0.9-n3.rdb

(in-group-cluster covr-obj 0.7 0.9 0 200 3000)
(in-group-cluster covr-obj 0.7 0.9 1 200 3000)
(in-group-cluster covr-obj 0.7 0.9 3 200 3000)
```
and the correspondingly-named rocks files.

Do NOT use HUGETLB -- this burns when running out of ram,
the malloc just .. fails, and everything fucks up.

Notable differences from run-12:
* This will log the orhtogonality of the clusters
* Setting commonality to 0.9 eliminates that variable
* Uses the new exhaustive-jaccard implementation to create groups.

========
