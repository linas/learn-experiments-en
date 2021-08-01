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

; First, the shapeless disjuncts
(define cset-obj (make-pseudo-cset-api))
(define cstars (add-pair-stars cset-obj))
(define cmi  (add-symmetric-mi-compute cstars))
;
(define csc (add-covering-sections cset-obj))
(define smi (add-symmetric-mi-compute csc))

;
(define (plain-mi swa swb)
	(cmi 'mmt-fmi (Word swa) (Word swb))
)

(define (shape-mi swa swb)
	(smi 'mmt-fmi (Word swa) (Word swb))
)

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
	*unspecified*
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
	*unspecified*
)

; ------------------------------------------
; Run stuff

(define (do-plain-mi)
	(intra-report-all plain-mi)
	(intra-all-mean plain-mi)
	; (inter-report-all plain-mi)
	(inter-all-mean plain-mi))

(define (do-shape-mi)
	(intra-report-all shape-mi)
	(intra-all-mean shape-mi)
	; (inter-report-all shape-mi)
	(inter-all-mean shape-mi))
