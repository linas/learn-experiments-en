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
(define pmi (add-symmetric-mi-compute star-obj))
(define (get-mi wa wb) (pmi 'mmt-fmi wa wb))
(define (ent swa swb)
	(format #t "~5f\n" (get-mi (Word swa) (Word swb))) *unspecified*)

; Examples:
; (ent "of" "to")  3.720 -- looks reasonable.
; (ent "of" "in")  4.443
; (ent "to" "in")  3.019

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
	(define sclu (string-append swb " " swb))
	(define clu (WordClassNode sclu))

	(define psu (add-support-compute star-obj))
	(psu 'clobber)
	(psu 'set-right-marginals clu)
	(psu 'set-right-marginals WA)
	(psu 'set-right-marginals WB)

	(define ptc (add-transpose-compute star-obj))
	(ptc 'clobber)
	(ptc 'set-mmt-marginals clu)
	(ptc 'set-mmt-marginals WA)
	(ptc 'set-mmt-marginals WB)
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
	*unspecified*)

; ===============================
