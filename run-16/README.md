
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
```

entry point
goe-cluster agglo-goe.scm


; --------------------------------

That's all folks!
