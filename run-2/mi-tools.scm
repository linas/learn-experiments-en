;
; mi-tools.scm
;
; Tools for exploration of MI by hand.
;
; Instructions for use:
; rm -r r2-gram-shape-40-junk.rdb
; cp -pr r2-mpg-trim-40-8-5.rdb r2-gram-shape-40-junk.rdb
; ./run-gram-cogserver.sh
;

(use-modules (srfi srfi-1))

; First, the shapeless disjuncts
(define cset-obj (make-pseudo-cset-api))
(define cstars (add-pair-stars cset-obj))
(define cmi  (add-symmetric-mi-compute cstars))

; Now, with shapes.
(define covr-obj (add-covering-sections cset-obj))
(define star-obj covr-obj)

(define pmi (add-symmetric-mi-compute star-obj))
(define (get-mi wa wb) (pmi 'mmt-fmi wa wb))
(define (ent swa swb)
	(format #t "~5f\n" (get-mi (Word swa) (Word swb))) *unspecified*)

; Above prints cset+shape MI, prints the cset-only MI.
; Only one of these two will work.
(define (ext swa swb)
	(format #t "~5f\n"
		(cmi 'mmt-fmi (Word swa) (Word swb)))
	*unspecified*)

; Examples:
; (ent "of" "to")  3.720 -- looks reasonable.
; (ent "of" "in")  4.443
; (ent "to" "in")  3.019
; ------------------------------------------------------------

; Return a sorted list of MI values between a word and all others.
(define (almi sw)
	(define wlist (cog-get-atoms 'WordNode))
	(define w (WordNode sw))
	(define prli
		(map
			; (lambda (aw) (cons aw (cmi 'mmt-fmi w aw)))
			(lambda (aw) (cons aw (pmi 'mmt-fmi w aw)))
			wlist))
	(sort prli
		(lambda (cla clb) (< (cdr cla) (cdr clb))))
)

; MI to selected words.
; (define slist (list "him" "me" "example" "us" "them" "speak" "instance" "happen" "difference" "themselves" "himself" "live" "why" "listen" "herself" "behind" "myself" "her" "try" "say" ))
(define (lmi sw slist)
	(define wlist (map WordNode slist))
	(define w (WordNode sw))
	(define prli
		(map
			; (lambda (aw) (cons aw (cmi 'mmt-fmi w aw)))
			(lambda (aw) (cons aw (pmi 'mmt-fmi w aw)))
			wlist))
)

; ------------------------------------------------------------
; The fraction to merge is a linear ramp, starting at zero
; at the cutoff, and ramping up to one when these are very
; similar.
(define (frac swa swb)
   (define WA (Word swa))
   (define WB (Word swb))
   (define CUTOFF 3.0)
   (define milo (min (get-mi WA WA) (get-mi WB WB)))
   (define fmi (get-mi WA WB))
   (/ (- fmi CUTOFF) (- milo CUTOFF)))
(define (pfrac swa swb)
   (format #t "~5f\n" (frac swa swb)) *unspecified*)

; For cutoff of 3.0, we get
; (pfrac "of" "to") 0.187   -- yuck too low!
; (pfrac "of" "in") 0.535   -- higher than expected...
; (pfrac "to" "in") 0.007   -- well, barely above cutoff so not surprising!?

(define (mi-fraction WA WB)
   (define CUTOFF 3.0)
   (define milo (min (get-mi WA WA) (get-mi WB WB)))
   (define fmi (get-mi WA WB))
   (/ (- fmi CUTOFF) (- milo CUTOFF)))

(define (start-clu swa swb)
   (define STARS star-obj)
   (define WA (Word swa))
   (define WB (Word swb))
   (define psu (add-support-compute STARS))
   (define cls (STARS 'make-cluster WA WB))
   (start-cluster psu cls WA WB mi-fraction 4.0 #t))

; Example usage:
; (start-clu "of" "to")
; ------ Create: Merged 7620 sections in 4.000 secs; 1905.0 scts/sec
; ------ Create: Revised 7620 shapes in 8.000 secs; 952.50 scts/sec
; ------ Create: cleanup 1 in 3.000 secs; 0.3333 ops/sec

(define (clobber swa swb)
   (define WA (Word swa))
   (define WB (Word swb))
	(define clu (star-obj 'make-cluster WA WB))

	(define psu (add-support-compute star-obj))
	(psu 'clobber)
	(define ptc (add-transpose-compute star-obj))
	(ptc 'clobber)

	(psu 'set-right-marginals clu)
	(psu 'set-right-marginals WA)
	(psu 'set-right-marginals WB)

	(ptc 'set-mmt-marginals clu)
	(ptc 'set-mmt-marginals WA)
	(ptc 'set-mmt-marginals WB)

	*unspecified*
)

(define of-to (WordClassNode "of to"))
(define (prj swa)
	(format #t "~5f\n" (get-mi of-to (Word swa))) *unspecified*)


(define (jp swa swb)
	(format #t "~8g\n" (pmi 'mmt-joint-prob (Word swa) (Word swb))) *unspecified*)

; Compute the total entropy for two words. (pre-merger)
(define (pre-merge-mi swa swb)
	(define wa (Word swa))
	(define wb (Word swb))
	(define tot-prob (+
		(pmi 'mmt-joint-prob wa wa)
		(* 2 (pmi 'mmt-joint-prob wa wb))
		(pmi 'mmt-joint-prob wb wb)))

	(define tot-mi (+
		(* (pmi 'mmt-joint-prob wa wa) (pmi 'mmt-fmi wa wa))
		(* 2 (pmi 'mmt-joint-prob wa wb) (pmi 'mmt-fmi wa wb))
		(* (pmi 'mmt-joint-prob wb wb) (pmi 'mmt-fmi wb wb))))

	(format #t "Tot prob=~8g tot mi=~8g  fmi=~6f\n"
		tot-prob tot-mi (/ tot-mi tot-prob))

	*unspecified*
)

(define (post-merge-mi swa swb FRAC)
	(define wa (Word swa))
	(define wb (Word swb))
	(define clu (star-obj 'make-cluster wa wb))

	; Compute the merge
	(define (mi-frac WA WB) FRAC)
	(define psu (add-support-compute star-obj))
	(start-cluster psu clu wa wb mi-frac 4.0 #t)
	(clobber swa swb)

	(format #t "Report for merge of `~A` and `~A` - ~A\n" swa swb clu)
	(define paa (pmi 'mmt-joint-prob wa wa))
	(define pab (pmi 'mmt-joint-prob wa wb))
	(define pbb (pmi 'mmt-joint-prob wb wb))

	(format #t "paa pab pbb = ~8g ~8g ~8g\n" paa pab pbb)

	(define pgg (pmi 'mmt-joint-prob clu clu))
	(define pga (pmi 'mmt-joint-prob clu wa))
	(define pgb (pmi 'mmt-joint-prob clu wb))
	(format #t "pgg pga pgb = ~8g ~8g ~8g\n" pgg pga pgb)


	(define maa (pmi 'mmt-fmi wa wa))
	(define mab (pmi 'mmt-fmi wa wb))
	(define mbb (pmi 'mmt-fmi wb wb))

	(format #t "MI maa mab mbb = ~6f ~6f ~6f\n" maa mab mbb)

	(define mgg (pmi 'mmt-fmi clu clu))
	(define mga (pmi 'mmt-fmi clu wa))
	(define mgb (pmi 'mmt-fmi clu wb))

	(set! mga (if (< mga -100) -100 mga))
	(set! mgb (if (< mgb -100) -100 mgb))
	(format #t "mgg mga mgb = ~6f ~6f ~6f\n" mgg mga mgb)


	(define tot-prob (+ paa pbb pgg (* 2 (+ pga pgb))))

	(define tot-mi (+
		(* paa maa) (* pbb mbb) (* pgg mgg)
			(* 2 (+ (* pga mga) (* pgb mgb)))))

	(format #t "Tot prob= ~8g tot mi= ~8g  fmi= ~6f\n"
		tot-prob tot-mi (/ tot-mi tot-prob))

	*unspecified*
)

; ===============================
