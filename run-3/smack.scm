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
(define wl-1-det "the" "a" "that" "this" "an" "some" "any" "these" "those" "most")
(define wl-2-prep "of" "to" "in" "with" "for" "at" "on" "by" "from" "up")
(define wl-3-verb-ir "was" "is" "had" "be" "have" "were" "are" "would" "been" "will")
(define wl-4-verb-act "said" "like" "do" "did" "know" "made" "see" "go" "came" "come")
(define wl-5-pronoun "I" "he" "it" "you" "him" "she" "they" "me" "them" "we")
(define wl-6-posessive "his" "her" "my" "thier" "your" "its" "our" "ones")
(define wl-7-adverb "that" "as" "not" "no" "there" "about" "only" "then" "very" "just")
(define wl-8-conj "and" "but" "or" "so" "if" "than" "both" "either" "yet" "nor")
(define wl-9-adj "all" "one" "other" "little" "even" "good" "great" "long" "old" "many")
(define wl-10-wh "which" "who" "when" "what" "where" "why" "how" "while" "whatever" "whose")
(define wl-11-noun "time" "man" "way" "eyes" "day" "hand" "head" "men" "face" "place")
(define wl-12-aux "can" "should" "could" "may" "must" "might" "shall" "cannot" "am" "has")

(define clusters
	(list
		(cons "wl-1-det" wl-1-detp)
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
				LST)
		(define retv (append RV stuff))
		(if (nil? (cdr LST)) retv
			(mkpr (car LST) (cdr LST) retv))))

	(mkpr (car wlist) (cdr wlist) '())
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
	(define hi -1e6)
	(define hipr #f)
	(for-each
		(lambda (item)
			(define val (cdr item))
			(if (> val hi)
				(begin
					(set! hipr item)
					(set! hi val))))
		alist)
	hipr)

(define (wavg alist)
	(define avg 0)
	(for-each
		(lambda (item) (set! avg (+ avg (cdr item))))
		alist)
	(/ avg (length alist))
)

(define (wrms alist avg)
	(define rms 0)
	(for-each
		(lambda (item) (set! rms (+ rms (* (cdr item) (cdr item)))))
		alist)
	(sqrt (- (/ rms (length alist)) (* avg avg)))
)

; ------------------------------------------

; First, the shapeless disjuncts
(define cset-obj (make-pseudo-cset-api))
(define cstars (add-pair-stars cset-obj))
(define cmi  (add-symmetric-mi-compute cstars))
;
(define (plain-mi swa swb)
	(cmi 'mmt-fmi (Word swa) (Word swb)))

; ------------------------------------------
;
; Report intra-cluster stats for just one cluster
(define (intra-report CLU func)
	(define stats (intra-apply (cdr CLU) func))
	(define lo (wmin stats))
	(define hi (wmax stats))
	(define av (wavg stats))
	(define rm (wrms stats av))
	(format #t "cluster ~A:\n" (car CLU))
	(format #t "\tmin ~A ~6f " (car lo) (cdr lo))
	(format #t "\tmax ~A ~6f " (car hi) (cdr hi))
	(format #t "\tavg: ~6f " av)
	(format #t "\trms: ~6f\n" rm)
	*unspecified*
)

; Report intra-cluster stats
(define (intra-report-all func)
	(for-each
		(lambda (CLU) (intra-report CLU func))
		clusters)
	*unspecified*
)

(intra-report-all plain-mi)

; ------------------------------------------
;
; Report inter-cluster stats for two cluster
(define (inter-report CLUA CLUB func)
	(define stats (inter-apply (cdr CLUA) (cdr CLUB) func))
	(define lo (wmin stats))
	(define hi (wmax stats))
	(define av (wavg stats))
	(define rm (wrms stats av))
	(format #t "cluster ~A vs ~A:\n" (car CLUA) (car CLUB))
	(format #t "\tmin ~A ~6f " (car lo) (cdr lo))
	(format #t "\tmax ~A ~6f " (car hi) (cdr hi))
	(format #t "\tavg: ~6f " av)
	(format #t "\trms: ~6f\n" rm)
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