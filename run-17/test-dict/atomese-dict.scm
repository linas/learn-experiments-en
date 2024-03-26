;
; Demo Atomese Dictionary.
;
; This file contains some example Atomese dictionary entries,
; written in the style of scheme s-expressions. This is NOT a great
; way to encode dictionaries, but it does give a general flavor
; of what Atomese looks like.
;
; It is intended that this file can be read in using the
; FileStorageNode provided by the AtomSpace.
;
; ---------------------------------------------------------------------
; The four sections below allow one and only one phrase to be parsed:
; "level playing field".

(Section
	(Word "###LEFT-WALL###")
	(ConnectorSeq
		(Connector (Word "level") (ConnectorDir "+"))))

(Section
	(Word "level")
	(ConnectorSeq
		(Connector (Word "###LEFT-WALL###") (ConnectorDir "-"))
		(Connector (Word "playing") (ConnectorDir "+"))))

(Section
	(Word "playing")
	(ConnectorSeq
		(Connector (Word "level") (ConnectorDir "-"))
		(Connector (Word "field") (ConnectorDir "+"))))

(Section
	(Word "field")
	(ConnectorSeq
		(Connector (Word "playing") (ConnectorDir "-"))))

; ---------------------------------------------------------------------
; The data below allows a collection of very similar sentences
; to be parsed. They all have the form "Mary saw a bird", with
; a choice of subjects, objects, verbs and determiners possible,
; as listed below.

(Section
	(Word "###LEFT-WALL###")
	(ConnectorSeq
		(Connector (WordClass "person") (ConnectorDir "+"))))

(Member (Word "Mary") (WordClass "person"))
(Member (Word "John") (WordClass "person"))
(Member (Word "Olga") (WordClass "person"))
(Member (Word "Sasha") (WordClass "person"))

(Section
	(WordClass "person")
	(ConnectorSeq
		(Connector (Word "###LEFT-WALL###") (ConnectorDir "-"))
		(Connector (WordClass "verb") (ConnectorDir "+"))))

(Member (Word "saw") (WordClass "verb"))
(Member (Word "heard") (WordClass "verb"))

(Section
	(WordClass "verb")
	(ConnectorSeq
		(Connector (WordClass "person") (ConnectorDir "-"))
		(Connector (WordClass "animal") (ConnectorDir "+"))))

(Member (Word "bird") (WordClass "animal"))
(Member (Word "cat") (WordClass "animal"))
(Member (Word "dog") (WordClass "animal"))

(Section
	(WordClass "animal")
	(ConnectorSeq
		(Connector (WordClass "verb") (ConnectorDir "-"))
		(Connector (WordClass "determiner") (ConnectorDir "-"))))

(Member (Word "the") (WordClass "determiner"))
(Member (Word "a") (WordClass "determiner"))
(Member (Word "this") (WordClass "determiner"))
(Member (Word "that") (WordClass "determiner"))

(Section
	(WordClass "determiner")
	(ConnectorSeq
		(Connector (WordClass "animal") (ConnectorDir "+"))))

; ---------------------------------------------------------------------
; The LG 'cost' can be taken from any FloatValue located on a Section.
; The location of that cost is configurable in the dict file; the demo
; uses `(Predicate "*-Mutual Info Key cover-section")` as the location
; key, and specifies the zero-based index into the vector as 1.  The
; number is taken to be the MI, so minux the cost.  The larger the MI,
; the lower the cost.
;
; Reminder: the costs below can be views by saying `!!saw` and `!!the`
; at the LG command-line prompt.

(cog-set-value!
	(Section
		(WordClass "determiner")
		(ConnectorSeq
			(Connector (WordClass "animal") (ConnectorDir "+"))))
	(Predicate "*-Mutual Info Key cover-section")
	(FloatValue 0 3.1))

(cog-set-value!
	(Section
		(WordClass "verb")
		(ConnectorSeq
			(Connector (WordClass "person") (ConnectorDir "-"))
			(Connector (WordClass "animal") (ConnectorDir "+"))))
	(Predicate "*-Mutual Info Key cover-section")
	(FloatValue 555 2.4))  ; The `555` is meaningles and ignored.

; ---------------------------------------------------------------------
