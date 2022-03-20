Experiment-13
=============
This is not an experiment, it is just a staging area for config
files to do some random explorations of stuff.

Data archive is at
`/home2/linas/src/novamente/data`
and
`/home2/linas/src/novamente/data/rocks-archive`

To restore, type
`sudo cp -pr /home2/linas/src/novamente/data/rocks-archive/r3-mpg-marg.rdb /data/lxc-databases/learn-en/rootfs/data`

Datasets
--------
* `run-1-en_pairs-tranche-12345.rdb` -- I think this is what the name
  implies; its just the pairs.
* `run-1-marg-tranche-12345.rdb` -- above, with marginals ... seems not
  to exist? Presumably because we ran out of RAM to compute the
  marginals? Should we try again?
* `run-1-marg-tranche-1234.rdb` -- Biggest pair file which does have
  marginals.
* `run-1-t1234-tsup-1-1-1.rdb` -- Pairs, trimed to 1,1,1, with support
  marginals.
* `r3-mpg-marg.rdb` -- A "badly-trimmed" dataset, but for which we
  report stats if the agi-22 article.

* `run-1-t123-clean-1-1-1.rdb` is a copy of run-1-t123-tsup-1-1-1.rdb
     with exhaustive trimming applied to (w,d pairs).  The cleanup:
     (cleanup-gram-dataset cset-stars)
     This results in only 7K words in the dataset!  Which means that
     - The marginals are for the earlier, untrimmed dataset
     - The word-pair MI is for the full, untrimmed dataset.
     Still takes 20 mins to load, and 13.6 GB
     Because I guess lots of low-quality MI pairs ...

* `r13-one-sim200.rdb` -- copy of r14-sim200.rdb which has word-sims
     for the top-200 word-pairs. It also has the following stuff:
     -- Word pairs, from long ago.  These are trimmed to remove all
        word-pairs with MI of 1.1 or less, leaving 3.9M pairs.
     -- word-pair MI that are appropriate, prior to this trim.
     -- word-disjunct pairs, with shape marginals on them.

* `r13-all-in-one.rdb` -- copy of above, with addtional similarities


Notes
-----
Pair-count histograms
```
guile -l cogserver-mst.scm
```

Then use `density-of-states.scm` from diary utils.


`r13-all-in-one.rdb` Notes
--------------------------

* copy of r14-sim200.rdb which has word-sims
* Takes 35 minutes to load word-pairs and taks 24GB RAM
* 13206 WordNodes
* 12420426 -- 12M word-pairs

Marginals say:
```
Rows: 58251 Columns: 58573  == log_2 15.8300 x 15.8379
Size: 26173771.0  log_2 size: 24.6416
Fraction non-zero: 7.6712E-3 Sparsity: 7.02632  Rarity: 8.80765
Total obs: 1346347214.0  Avg obs/pair: 51.4388  log_2 avg: 5.68478
Entropy Tot: 17.9341  Left: 9.70115  Right: 9.47621  MI: 1.24330
```
So this is clearly for the non-trimmed word-pairs.


To delete word-pairs with MI less than 0.0:
```
(define pair-obj (make-any-link-api))
(pair-obj 'fetch-pairs)
(define pair-stars (add-pair-stars pair-obj))
(print-matrix-summary-report pair-stars)
(define pair-freq (add-pair-freq-api pair-stars))
```
Then
```
(define all-pairs (pair-stars 'get-all-elts))
(length all-pairs)
$4 = 12399182

(define CUT 0.5)
(for-each (lambda (PR)
	(when (< (pair-freq 'pair-fmi PR) CUT)
		(cog-delete-recursive! (gdr PR))))
	all-pairs)
```
This leaves 5M pairs behind.
5021032 pairs

(define CUT 1.1) ;; leaves 3.9M pairs behind.
3878193 pairs

Close and re-open, load pairs.  Takes 600 secs to load.
Takes 6.8 GB RAM  and has 10634 words.
Load all words ...
There are 13206 words.  in total.

Load csets, grows to 8.2G
total of 833833 sections, 204680 connector seqs
(which matches matrix summary report exactly. Yay!)

Now run cleanup...

Now 6.5G to load word-pairs, 9280 words.
Then 7.9 GB to load sections
8.3 G after loading sections.

((PredicateNode . 19) (ListLink . 3906154) (AnyNode . 4) (Connector .
17060) (ConnectorDir . 2) (ConnectorSeq . 204680) (Section . 833833)
(EvaluationLink . 3691978) (TypeNode . 2) (SimilarityLink . 20100)
(SchemaNode . 1) (RocksStorageNode . 1) (WordNode . 9496) (LgLinkNode .
1))


More similarities
-----------------
```
(define cset-obj (make-pseudo-cset-api))
(define covr-obj (add-covering-sections cset-obj))
(covr-obj 'fetch-pairs)
(covr-obj 'explode-sections)
(define star-obj covr-obj)

(setup-initial-similarities star-obj 500)
```

---------------
