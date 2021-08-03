;
; smack.scm
; Tools for running the Similarity Smackdown.
;
(use-modules (srfi srfi-1))

; ------------------------------------------
; Load all words, only.  Takes 30 seconds
; (fetch-all-words)
; (define wds (cog-get-atoms 'WordNode))

; Get sorted list of most frequent words.
(define (top-words)
	(define wds (cog-get-atoms 'WordNode))

	(define tops
		(sort wds
			(lambda (wa wb) (> (cog-count wa) (cog-count wb)))))

	(take tops 100)
)

; ------------------------------------------
;
; Official word lists.
;
(define wl-1-det (list "the" "a" "that" "this" "an" "some" "any" "these" "those" "most"))
(define wl-2-prep (list "of" "to" "in" "with" "for" "at" "on" "by" "from" "up"))
(define wl-3-verb-ir (list "was" "is" "had" "be" "have" "were" "are" "would" "been" "will"))
(define wl-4-verb-act (list "said" "like" "do" "did" "know" "made" "see" "go" "came" "come"))
(define wl-5-pronoun (list "I" "he" "it" "you" "him" "she" "they" "me" "them" "we"))
(define wl-6-posessive (list "his" "her" "my" "thier" "your" "its" "our" "ones"))
(define wl-7-adverb (list "that" "as" "not" "no" "there" "about" "only" "then" "very" "just"))
(define wl-8-conj (list "and" "but" "or" "so" "if" "than" "both" "either" "yet" "nor"))
(define wl-9-adj (list "all" "one" "other" "little" "even" "good" "great" "long" "old" "many"))
(define wl-10-wh (list "which" "who" "when" "what" "where" "why" "how" "while" "whatever" "whose"))
(define wl-11-noun (list "time" "man" "way" "eyes" "day" "hand" "head" "men" "face" "place"))
(define wl-12-aux (list "can" "should" "could" "may" "must" "might" "shall" "cannot" "am" "has"))

(define clusters
	(list
		(cons "wl-1-det" wl-1-det)
		(cons "wl-2-prep" wl-2-prep)
		(cons "wl-3-verb-ir" wl-3-verb-ir)
		(cons "wl-4-verb-act" wl-4-verb-act)
		(cons "wl-5-pronoun" wl-5-pronoun)
		(cons "wl-6-posessive" wl-6-posessive)
		(cons "wl-7-adverb" wl-7-adverb)
		(cons "wl-8-conj" wl-8-conj)
		(cons "wl-9-adj" wl-9-adj)
		(cons "wl-10-wh" wl-10-wh)
		(cons "wl-11-noun" wl-11-noun)
		(cons "wl-12-aux" wl-12-aux)))

; ------------------------------------------
; Given a word-list, and a function, apply function to pairs from the
; word-list. Return an assoc-list of function results.
(define (intra-apply wlist func)
	(define (mkpr ELEM LST RV)
		(define stuff
			(map
				(lambda (WB) (cons (cons ELEM WB) (func ELEM WB)))
				LST))
		(define retv (append RV stuff))
		(if (nil? (cdr LST)) retv
			(mkpr (car LST) (cdr LST) retv)))

	(if (nil? (cdr wlist)) '()
		(mkpr (car wlist) (cdr wlist) '()))
)

; ------------------------------------------
; Given two word-lists, and a function, apply function to pairs
; chosen from each word-list. Return an assoc-list of function results.
(define (inter-apply wla wlb func)
	(concatenate
		(map
			(lambda (WA)
				(map
					(lambda (WB) (cons (cons WA WB) (func WA WB)))
					wlb)
			)
			wla))
)

; ------------------------------------------
; Given an assoc list of pairs and values, find the min, max,
; the unweighted mean, and the unweighted rms.

(define (wgood alist)
	(define cnt 0)
	(for-each
		(lambda (item)
			(define val (cdr item))
			(if (< -inf.0 val)
				(set! cnt (+ 1 cnt))))
		alist)
	cnt)

(define (wmin alist)
	(define lo 1e6)
	(define lopr #f)
	(for-each
		(lambda (item)
			(define val (cdr item))
			(if (< val lo)
				(begin
					(set! lopr item)
					(set! lo val))))
		alist)
	lopr)

(define (wmax alist)
	(define hi -inf.0)
	(define hipr #f)
	(for-each
		(lambda (item)
			(define val (cdr item))
			(if (>= val hi)
				(begin
					(set! hipr item)
					(set! hi val))))
		alist)
	hipr)

(define (wavg alist)
	(define avg 0)
	(define sum 0)
	(for-each
		(lambda (item)
			(if (< -inf.0 (cdr item))
				(begin
					(set! sum (+ sum 1))
					(set! avg (+ avg (cdr item))))))
		alist)
	(if (< 0 sum) (/ avg sum) -inf.0)
)

(define (wrms alist avg)
	(define rms 0)
	(define sum 0)
	(for-each
		(lambda (item)
			(if (< -inf.0 (cdr item))
				(begin
					(set! sum (+ sum 1))
					(set! rms (+ rms (* (cdr item) (cdr item)))))))
		alist)
	(if (< 0 sum) (sqrt (- (/ rms sum) (* avg avg))) -inf.0)
)

; ------------------------------------------

; A needed filtering utility.
(define cset-obj (make-pseudo-cset-api))
(define cstars (add-pair-stars cset-obj))

(define (have-word? sw)
	(not (nil?
		(find (lambda (w) (equal? w (Word sw))) (cstars 'left-basis)))))

; ------------------------------------------
;
; Report intra-cluster stats for just one cluster
(define (intra-report CLU func)
	(define words (filter have-word? (cdr CLU)))
	(define stats (intra-apply words func))
	(define lo (wmin stats))
	(define hi (wmax stats))
	(define av (wavg stats))
	(define rm (wrms stats av))
	(format #t "cluster ~A has ~D words and ~D pairs:\n"
		(car CLU) (length words) (wgood stats))
	(format #t "   min ~A ~5f" (car lo) (cdr lo))
	(format #t "   max ~A ~5f" (car hi) (cdr hi))
	(format #t "   avg: ~5f" av)
	(format #t "   rms: ~5f\n" rm)
	*unspecified*
)

; Report intra-cluster stats
(define (intra-report-all func)
	(for-each
		(lambda (CLU) (intra-report CLU func))
		clusters)
	*unspecified*
)

(define (intra-all-mean func)
	(define tot 0)
	(define avg 0)
	(define rms 0)
	(define (intra-sum CLU)
		(define words (filter have-word? (cdr CLU)))
		(define stats (intra-apply words func))
		(define av (wavg stats))
		(define rm (wrms stats av))
		(define nu (wgood stats))
		(set! tot (+ tot nu))
		(set! avg (+ avg (* nu av)))
		(set! rms (+ rms (* nu (+ (* rm rm) (* av av)))))
		(format #t ".")
		(force-output)
	)

	(for-each intra-sum clusters)
	(newline)

	(set! avg (/ avg tot))
	(set! rms (sqrt (- (/ rms tot) (* avg avg))))
	(format #t "Total intra ~D mean= ~6f rms = ~5f\n" tot avg rms)
	(cons avg rms)
)

; ------------------------------------------
;
; Report inter-cluster stats for two cluster
(define (inter-report CLUA CLUB func)
	(define wla (filter have-word? (cdr CLUA)))
	(define wlb (filter have-word? (cdr CLUB)))
	(define stats (inter-apply wla wlb func))
	(define lo (wmin stats))
	(define hi (wmax stats))
	(define av (wavg stats))
	(define rm (wrms stats av))
	(format #t "cluster ~A vs ~A pairs: ~D\n" (car CLUA) (car CLUB) (wgood stats))
	(format #t "   min ~A ~5f" (car lo) (cdr lo))
	(format #t "   max ~A ~5f" (car hi) (cdr hi))
	(format #t "   avg: ~5f" av)
	(format #t "   rms: ~5f\n" rm)
	*unspecified*
)

; Report inter-cluster stats
(define (inter-report-all func)
	(define (repr CLUA CLST)
		(for-each
			(lambda (CLUB) (inter-report CLUA CLUB func))
			CLST)
		(if (not (nil? (cdr CLST)))
			(repr (car CLST) (cdr CLST))))

	(repr (car clusters) (cdr clusters))
	*unspecified*
)

(define (inter-all-mean func)
	(define tot 0)
	(define avg 0)
	(define rms 0)


	(define (inter-sum CLUA CLUB func)
		(define wla (filter have-word? (cdr CLUA)))
		(define wlb (filter have-word? (cdr CLUB)))
		(define stats (inter-apply wla wlb func))
		(define av (wavg stats))
		(define rm (wrms stats av))
		(define nu (wgood stats))
		(if (< 0 nu)
			(begin
				(set! tot (+ tot nu))
				(set! avg (+ avg (* nu av)))
				(set! rms (+ rms (* nu (+ (* rm rm) (* av av)))))
			))
		(format #t ".")
		(force-output)
	)

	(define (repr CLUA CLST)
		(for-each
			(lambda (CLUB) (inter-sum CLUA CLUB func))
			CLST)
		(if (not (nil? (cdr CLST)))
			(repr (car CLST) (cdr CLST))))

	(repr (car clusters) (cdr clusters))
	(newline)

	(set! avg (/ avg tot))
	(set! rms (sqrt (- (/ rms tot) (* avg avg))))
	(format #t "Total inter ~D mean= ~6f rms = ~5f\n" tot avg rms)

	(cons avg rms)
)

; ------------------------------------------
; Other measures.

(define-public (add-symmetric-cosine-compute LLOBJ)
	(define GET-CNT 'get-count)

	(let* (
			(star-obj (add-pair-stars LLOBJ))
			(prod-obj  (add-support-compute
				(add-tuple-math star-obj * GET-CNT)))
		)

      ; -------------
      ; Return the cosine product of column A and column B
      (define (compute-left-cosine COL-A COL-B)
         (/ (prod-obj 'left-count (list COL-A COL-B))
				(sqrt (*
					(prod-obj 'left-count (list COL-A COL-A))
					(prod-obj 'left-count (list COL-B COL-B))))))

      ; Return the vector product of row A and row B
      (define (compute-right-cosine ROW-A ROW-B)
         (/ (prod-obj 'right-count (list ROW-A ROW-B))
				(sqrt (*
					(prod-obj 'right-count (list ROW-A ROW-A))
					(prod-obj 'right-count (list ROW-B ROW-B))))))


		; -------------
		; Methods on this class.
		(lambda (message . args)
			(case message
				((mtm-cosine)      (apply compute-left-cosine args))
				((mmt-cosine)      (apply compute-right-cosine args))
				(else              (apply LLOBJ (cons message args))))
	)))


; ------------------------------------------
; Run stuff

; First, the shapeless disjuncts
(define cmi  (add-symmetric-mi-compute cstars))
;
; Now with shapes.
(define csc (add-covering-sections cstars))
(define smi (add-symmetric-mi-compute csc))

;
(define (plain-mi swa swb)
	(cmi 'mmt-fmi (Word swa) (Word swb))
)

(define (shape-mi swa swb)
	(smi 'mmt-fmi (Word swa) (Word swb))
)

(define (log2 x) (if (< 0.0 x) (/ (log x) (log 2.0)) -inf.0))

; vi == variation of information
(define (plain-vi swa swb)
	(define mi (cmi 'mmt-fmi (Word swa) (Word swb)))
	(define h (- (log2 (cmi 'mmt-joint-prob (Word swa) (Word swb)))))
	(if (< h 100) (- h mi) -inf.0)
)

(define (shape-vi swa swb)
	(define mi (smi 'mmt-fmi (Word swa) (Word swb)))
	(define h (- (log2 (smi 'mmt-joint-prob (Word swa) (Word swb)))))
	(if (< h 100) (- h mi) -inf.0)
)

(define (plain-nvi swa swb)
	(define mi (cmi 'mmt-fmi (Word swa) (Word swb)))
	(define h (- (log2 (cmi 'mmt-joint-prob (Word swa) (Word swb)))))
	(/ mi h)
)

(define (shape-nvi swa swb)
	(define mi (smi 'mmt-fmi (Word swa) (Word swb)))
	(define h (- (log2 (smi 'mmt-joint-prob (Word swa) (Word swb)))))
	(/ mi h)
)

(define csu (add-support-compute cstars))
(define ssu (add-support-compute csc))

(define (plain-joint swa swb)
	(define j (cmi 'mmt-joint-prob (Word swa) (Word swb)))
	(define tot (csu 'total-count-right))
	(define ma (/ (csu 'right-count (Word swa)) tot))
	(define mb (/ (csu 'right-count (Word swb)) tot))
	(log2 (/ j (* ma mb)))
)

(define (shape-joint swa swb)
	(define j (smi 'mmt-joint-prob (Word swa) (Word swb)))
	(define tot (ssu 'total-count-right))
	(define ma (/ (ssu 'right-count (Word swa)) tot))
	(define mb (/ (ssu 'right-count (Word swb)) tot))
	(log2 (/ j (* ma mb)))
)

(define cco (add-symmetric-cosine-compute cstars))
(define sco (add-symmetric-cosine-compute csc))

(define csi (add-similarity-compute cstars))
(define ssi (add-similarity-compute csc))

(define (plain-cosine swa swb)
	; (cco 'mmt-cosine (Word swa) (Word swb))
	(csi 'right-cosine (Word swa) (Word swb))
)

(define (shape-cosine swa swb)
	; (sco 'mmt-cosine (Word swa) (Word swb))
	(ssi 'right-cosine (Word swa) (Word swb))
)

(define (plain-logcos swa swb)
	(log2 (csi 'right-cosine (Word swa) (Word swb)))
)

(define (shape-logcos swa swb)
	(log2 (ssi 'right-cosine (Word swa) (Word swb)))
)

(define (plain-overlap swa swb)
	(log2 (csi 'right-overlap (Word swa) (Word swb)))
)

(define (shape-overlap swa swb)
	(log2 (ssi 'right-overlap (Word swa) (Word swb)))
)

(define (plain-jaccard swa swb)
	(log2 (- 1.0 (csi 'right-cond-jacc (Word swa) (Word swb))))
)

(define (shape-jaccard swa swb)
	(log2 (- 1.0 (ssi 'right-cond-jacc (Word swa) (Word swb))))
)

(define (plain-prjacc swa swb)
	(log2 (- 1.0 (csi 'right-prjaccard (Word swa) (Word swb))))
)

(define (shape-prjacc swa swb)
	(log2 (- 1.0 (ssi 'right-prjaccard (Word swa) (Word swb))))
)


(define (do-report fun name)
	(format #t "Start work on ~A\n" name)
	; (intra-report-all fun)
	(define intra (intra-all-mean fun))
	; (inter-report-all fun)
	(define inter (inter-all-mean fun))
	(define sep (/ (- (car intra) (car inter)) (max (cdr intra) (cdr inter))))
	(format #t "Separation = ~5f\n" (abs sep))
	(format #t "---------------\n")
)

; (do-report plain-mi)
; (do-report shape-mi)
; (do-report plain-joint)
; (do-report shape-joint)
; (do-report plain-cosine)

(define (report-plain)
	(do-report plain-mi "plain-mi")
	(do-report plain-joint "plain-joint")
	(do-report plain-cosine "plain-cosine")
	(do-report plain-logcos "plain-logcos")
	(do-report plain-overlap "plain-overlap")
	(do-report plain-jaccard "plain-jaccard")
	(do-report plain-prjacc "plain-prjacc")
)

(define (report-plain-vi)
	(do-report plain-vi "plain-vi")
	(do-report plain-nvi "plain-nvi")
)

(define (report-shape)
	(do-report shape-mi "shape-mi")
	(do-report shape-joint "shape-joint")
	(do-report shape-cosine "shape-cosine")
	(do-report shape-logcos "shape-logcos")
	(do-report shape-overlap "shape-overlap")
	(do-report shape-jaccard "shape-jaccard")
	(do-report shape-prjacc "shape-prjacc")
)

(define (report-shape-vi)
	(do-report shape-vi "shape-vi")
	(do-report shape-nvi "shape-nvi")
)

