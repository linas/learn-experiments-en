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
; Given an assoc list of pairs and values, find the min, max,
; the unweighted mean, and the unweighted rms. Then print these
; out.

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
	(/ avg (length alist)))
