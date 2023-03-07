
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
(define* (f X #:key (foo 1) (bar 2))
	(define Y 42)
	(format #t "yes ~A ~A ~A ~A\n" X foo bar Y))
(f 1 #:foo 2 #:bar 3)
```

; --------------------------------

That's all folks!
