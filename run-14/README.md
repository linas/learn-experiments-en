
Experiment 14
=============
Very similar to run-12, but with some a-priori fixes of known
dataset bugs. This includes:

* Removal of all CrossSections inadvetently stored in the
  sim dataset.
* Removal of all Shapes (i.e. marginals) followed by a
  recomputation of the same marginals.


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

October 2022
------------
API changes. Instead of calling
```
(in-group-cluster covr-obj 0.7 0.9 6 200 3000)
```
must call as
```
(in-group-mi-cluster covr-obj 200 3000
	#:QUORUM 0.7 #:COMMONALITY 0.9  #:NOISE 6)
```
The above will also place each merge in it's own space-frame.

This code seemss to be buggy. Working on it.

Repeatedly call this then exit and restart.
```
(in-group-mi-cluster covr-obj 200 5
   #:QUORUM 0.7 #:COMMONALITY 0.9  #:NOISE 6)
```

After the first round:
```
(r14-i6)> (cog-report-counts)
$1 = ((PredicateNode . 48) (ListLink . 467287) (MemberLink . 19) (AnyNode . 7) (Connector . 17072) (ConnectorDir . 2) (ConnectorSeq . 253111) (Section . 1124713) (ShapeLink . 1023407) (CrossSection . 2485678) (VariableNode . 1) (EvaluationLink . 9501) (TypeNode . 6) (TypeChoice . 3) (AnchorNode . 1) (WordNode . 9495) (WordClassNode . 5))
(r14-i6)> (cog-rocks-stats storage-node)
Connected to `rocks:///home/ubuntu/data//r14-junk.rdb`
Database contents:

Database contents:
  Next aid: 198009597  Frames f@: 6
  Atoms/Links/Nodes a@: 28073481 l@: 28059919 n@: 13277
  Keys/Incoming/Hash k@: 59976951 i@: 58086575 h@: 0

  Height Distribution:
    z1@: 12490473
    z2@: 13712038
    z3@: 1857689

  Number of Frame tops: 1
  Frame top: `MI-merge layer 5`
  Size   Name
    27181103    `(uuid . 1)`
    78803       `MI-merge layer 1`
    352791      `MI-merge layer 2`
    19254       `MI-merge layer 3`
    128597      `MI-merge layer 4`
    312933      `MI-merge layer 5`

Unix max open files rlimit cur: 1024 rlimit max: 1048576
```

WTF, still borken??
Or is this OK?


------ Round 1 Next in line:
ranked-MI = 9.1864 MI = 9.4480 (`—`, `+`)
ranked-MI = 9.1428 MI = 5.0203 (`;`, `,`)
ranked-MI = 9.0413 MI = 4.6066 (`is`, `was`)
ranked-MI = 9.0177 MI = 4.8309 (`and`, `but`)
ranked-MI = 8.9218 MI = 5.8340 (`.`, `?`)
ranked-MI = 8.9079 MI = 7.1134 (`!`, `?`)
------ Start MI-based merge 1 with seed pair `—` and `+`
In-group size=6: `—` `”` `_` `)` `(` `[`
------ merge-majority: Merge 6679 of 8348 sections in 14 secs
------ merge-majority: Remaining 15043 of 21577 cross in 41 secs


------ Round 2 Next in line:
ranked-MI = 9.1428 MI = 5.0203 (`;`, `,`)
ranked-MI = 9.0959 MI = 9.3359 (`—`, `+`)
ranked-MI = 9.0413 MI = 4.6066 (`is`, `was`)
------ Start MI-based merge 2 with seed pair `;` and `,`
In-group size=3: `,` `;` `:`
------ merge-majority: Merge 33124 of 41743 sections in 78 secs
------ merge-majority: Remaining 92082 of 111616 cross in 247 secs


------ Round 3 Next in line:
ranked-MI = 9.0959 MI = 9.3359 (`—`, `+`)
ranked-MI = 9.0413 MI = 4.6066 (`is`, `was`)
ranked-MI = 9.0177 MI = 4.8309 (`and`, `but`)
------ Start MI-based merge 3 with seed pair `—` and `+`
In-group size=2: `+` `—`
------ merge-majority: Merge 1058 of 1205 sections in 2 secs
------ merge-majority: Remaining 3384 of 3805 cross in 8 secs

------ Round 4 Next in line:
ranked-MI = 9.0413 MI = 4.6066 (`is`, `was`)
ranked-MI = 9.0177 MI = 4.8309 (`and`, `but`)
ranked-MI = 8.9218 MI = 5.8340 (`.`, `?`)
ranked-MI = 8.9079 MI = 7.1134 (`!`, `?`)
ranked-MI = 8.8475 MI = 4.8992 (`It`, `He`)
------ Start MI-based merge 4 with seed pair `is` and `was`
In-group size=2: `was` `is`
------ merge-majority: Merge 12229 of 13071 sections in 30 secs
------ merge-majority: Remaining 36120 of 39463 cross in 90 secs

------ Round 5 Next in line:
ranked-MI = 9.0177 MI = 4.8309 (`and`, `but`)
ranked-MI = 8.9218 MI = 5.8340 (`.`, `?`)
ranked-MI = 8.9079 MI = 7.1134 (`!`, `?`)
ranked-MI = 8.8475 MI = 4.8992 (`It`, `He`)
ranked-MI = 8.2707 MI = 5.3147 (`”`, `"`)
------ Start MI-based merge 5 with seed pair `and` and `but`
In-group size=6: `but` `and` `for` `as` `or` `than`
------ merge-majority: Merge 28471 of 32744 sections in 77 secs
------ merge-majority: Remaining 65265 of 77584 cross in 196 secs


>>>>>>>>>>>>>>>


------ Round 6 Next in line:
ranked-MI = 8.9218 MI = 5.8340 (`.`, `?`)
ranked-MI = 8.9079 MI = 7.1134 (`!`, `?`)
ranked-MI = 8.8475 MI = 4.8992 (`It`, `He`)
------ Start MI-based merge 6 with seed pair `.` and `?`
Initial in-group size=5: `?` `.` `###LEFT-WALL###` `!` `]`
In-group size=2: `?` `!`
------ merge-majority: Merge 4030 of 4307 sections in 7 secs
------ merge-majority: Remaining 10858 of 12599 cross in 29 secs
------ Merged into `? !` in 183 secs

Will recompute sims for 2 words (232 unaffected) out of 234
MI(`!`, `!`) = 13.151rank-MI = 11.746
MI(`.`, `!`) = 8.7373rank-MI = 9.5080
MI(`?`, `!`) = 12.362rank-MI = 11.510
MI(`?`, `?`) = 13.335rank-MI = 13.036
MI(`.`, `?`) = 9.2545rank-MI = 10.579
Recomputed sims for 2 words out of 234 in 489 secs
MI(`? !`, `? !`) = 13.121rank-MI = 13.205

------ Round 7 Next in line:
ranked-MI = 12.625 MI = 12.425 (`?`, `? !`)
ranked-MI = 11.608 MI = 11.961 (`!`, `? !`)
ranked-MI = 11.510 MI = 12.362 (`!`, `?`)
ranked-MI = 10.579 MI = 9.2545 (`.`, `?`)
ranked-MI = 10.529 MI = 8.7053 (`.`, `? !`)
ranked-MI = 9.5080 MI = 8.7373 (`!`, `.`)
ranked-MI = 8.8475 MI = 4.8992 (`It`, `He`)

------ Start MI-based merge 7 with seed pair `?` and `? !`
Initial in-group size=4: `? !` `?` `.` `###LEFT-WALL###`
Best: size=2 overlap = 681 of 2661 disjuncts, commonality= 25.59%
In-group size=2: `? !` `?`
------ merge-majority: Merge 4018 of 4101 sections in 10 secs
------ merge-majority: Remaining 10953 of 12156 cross in 33 secs



========
