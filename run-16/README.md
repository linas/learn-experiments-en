
Experiment 16
=============
Started 4 October 2022

Merging using Gaussian Orthogonal Ensemble experiments.

Copy the data file:
```
cd ~/data
cp -pr r15-goe-6k.rdb r16-merge.rdb
```

The `r15-goe-6k.rdb` file contains MI pairs out to N=6K and also
GOE similarities out to M=1000.

Configure the pipeline:
```
cd ~/experiments/run-16
. 0-pipeline.sh
. 4-gram-conf-en.sh
cd ~/src/learn/run/
./run-tmux.sh
```

Get ready to rumble!
```
cd ~/src/learn/run-common/
guile -l cogserver-gram.scm
```

Manual load of similarity data:
```
(define pca (make-pseudo-cset-api)) ; shapes not needed to fetch sims.
(define pcs (add-pair-stars pca))
(define smi (add-similarity-api pcs #f "shape-mi"))

; Need to fetch all pairs, because the similarity object doesn't
; automate this.
(smi 'fetch-pairs) ;;; same as (load-atoms-of-type 'Similarity)
```

Then access similarites and verify something is there:
```
(define gos (add-similarity-api smi #f "goe"))
(gos 'pair-count (Word "she") (Word "he"))
(gos 'get-count (Similarity (Word "she") (Word "he")))

(define (add-goe-sim LLOBJ)
	(define (get-ref PR IDX)
		; Expect FloatValue always IDX=0 is the MI sims, and 1 is the RMI
		(cog-value-ref (LLOBJ 'get-count PR) IDX))

	(lambda (message . args)
		(case message
			((get-count)  (get-ref (car args) 0))
			; ((pair-count)  (get-ref (car args) 0))
			(else		(apply LLOBJ (cons message args))))
	))

(define goe (add-goe-sim gos))
```

Merge
-----
Now start doing merges.

```
(define layer-one (cog-new-atomspace "layer one" (cog-atomspace)))
(cog-set-atomspace! layer-one)
(store-frames layer-one)
```

entry point
goe-cluster agglo-goe.scm

```
(define sha (add-covering-sections pcs))
(define LLOBJ sha)


(define NRANK 1000)
(define words-with-sims (take ranked-words NRANK))
(define all-cosi (gos 'get-all-elts))
(length all-cosi)
(define uniq-cosi
   (remove (lambda (PR) (equal? (gar PR) (gdr PR))) all-cosi))
(define sorted-pairs (sort uniq-cosi lessi))


(define start-pr (car sorted-pairs))
(optimal-in-group theta-sim
	(gar start-pr) (gdr start-pr)
	words-with-sims
	#:epsi-step 0.01
	#:win-size 0.02
	#:max-epsi 0.3  ; for theta sim
	#:lower-bound -0.7  ; for theta sim
	#:max-jump 2.5
)
```

Stats
=====
Here we go:

```
(define e (make-elapsed-secs))
(load-atoms-of-type 'Similarity)
(format #t "Fetched in ~A secs\n" (e))
Fetched in 1956 secs

(define smi (add-similarity-api covr-obj #f "goe"))
(smi 'fetch-pairs)

(define level-one (cog-new-atomspace (cog-atomspace)))
(cog-set-atomspace! level-one)
(store-frames (cog-atomspace))
(define touched (goe-cluster covr-obj 100))
```

Results:
```
Sorted 499500 GOE pairs in 664 secs
Found 1000 words with GOE sims
------ Round 0 Next in line:
goe-theta= 0.0183 cos= 0.9998 mi= 7.6915 (`60w`, `50w`)
goe-theta= 0.0677 cos= 0.9977 mi= 7.0143 (`Ag`, `Ap`)
goe-theta= 0.1206 cos= 0.9927 mi= 6.8538 (`60w`, `6d`)
goe-theta= 0.1248 cos= 0.9922 mi= 6.7958 (`6d`, `50w`)
goe-theta= 0.1468 cos= 0.9892 mi= 6.9751 (`6d`, `Ap`)
goe-theta= 0.1538 cos= 0.9882 mi= 6.8176 (`60w`, `Ap`)
goe-theta= 0.1583 cos= 0.9875 mi= 6.7567 (`Ap`, `50w`)
goe-theta= 0.1586 cos= 0.9875 mi= 7.0401 (`26`, `13`)
goe-theta= 0.1654 cos= 0.9864 mi= 7.0198 (`Ag`, `Jl`)
goe-theta= 0.1654 cos= 0.9863 mi= 6.9765 (`6d`, `Ag`)
goe-theta= 0.1715 cos= 0.9853 mi= 6.8190 (`60w`, `Ag`)
goe-theta= 0.1757 cos= 0.9846 mi= 6.7582 (`Ag`, `50w`)

 (cog-report-counts)
((PredicateNode . 56) (ListLink . 418856) (MemberLink . 236) (AnyNode . 7) (Connector . 17253) (ConnectorDir . 2) (ConnectorSeq . 272509) (Section . 1322160) (ShapeLink . 1148630) (CrossSection . 3050065) (VariableNode . 1) (EvaluationLink . 9496) (TypeNode . 6) (TypeChoice . 3) (AnchorNode . 1) (SimilarityLink . 18003000) (SchemaNode . 1) (RocksStorageNode . 1) (WordNode . 9495) (WordClassNode . 100))

(cog-rocks-stats storage-node)
Connected to `rocks:///home/ubuntu/data//r16-merge.rdb`
Database contents:
  Next aid: 215551431  Frames f@: 102
  Atoms/Links/Nodes a@: 45615219 l@: 45601570 n@: 13364
  Keys/Incoming/Hash k@: 76268143 i@: 92666883 h@: 0

  Height Distribution:
    z1@: 30467601
    z2@: 13501872
    z3@: 1632378

  Number of Frame tops: 1
  Frame top: `GOE-merge layer 100`
  Size   Name
    45160170    `(uuid . 1)`
    15  `(uuid . 3)`
    90  `GOE-merge layer 1`
    25  `GOE-merge layer 2`
    548 `GOE-merge layer 3`
    186 `GOE-merge layer 4`
    88  `GOE-merge layer 5`
    56  `GOE-merge layer 6`
    1085        `GOE-merge layer 7`
    456 `GOE-merge layer 8`
    397 `GOE-merge layer 9`
    106 `GOE-merge layer 10`
    748 `GOE-merge layer 11`
...
    11153       `GOE-merge layer 92`
    5007        `GOE-merge layer 93`
    4554        `GOE-merge layer 94`
    1460        `GOE-merge layer 95`
    1054        `GOE-merge layer 96`
    10188       `GOE-merge layer 97`
    122 `GOE-merge layer 98`
    10739       `GOE-merge layer 99`
    1431        `GOE-merge layer 100`
```

(length touched)
336

(make-merge-logger LLOBJ)

(define wc (cog-get-atoms 'WordClass))
(length wc)
; 100
(cog-incoming-by-type (car wc) 'Member)

(fold (lambda (I S) (+ S (cog-incoming-size-by-type I 'Member))) 0 wc)
; 236




Debug
=====

```
(define * (f X #:key (foo 1) (bar 2))
	(define Y 42)
	(format #t "yes ~A ~A ~A ~A\n" X foo bar Y))
(f 1 #:foo 2 #:bar 3)
```

Atomspace frames:
-- what if atomspace is created/stored with the same name as existing
atomspace?   Ouch!? Currently has no effect...

; --------------------------------

That's all folks!
