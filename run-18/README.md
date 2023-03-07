Experiment 18
=============
November 2022

The changes to LG in expt-17 now opens the door for a unified
pair-parsing, MST-parsing, gram-parsing and clustering, as an
integrated, continuous system. This should be much better, but
requires bring-up.

So here we go.

files
* `r18-bond-plain.rdb` -- 9935011 pairs and 67369 words.
  Block-counted pairs, for fanfic only. No marginals.
  Uses `(BondNode "Any")` for the pair predicate.
  
* `r18-bond-marge.rdb` -- pairs with MI values on them

Procedure
---------
Start from scratch.

* Copy fanfic to `textx/betax`.
* `guile -l cogserver.scm`
* `cd ~/src/learn/run-common`
* `. ~/experiments/run-18/0-pipeline.sh`
* `./process-corpus.sh ~/experiments/run-18/2-pair-conf-en.sh`
* Wait several days ... 4 days.
  18691 minutes CPU = 311 hours = 13 days CPU time.
  15.2GB RAM resident at end.
  Rate: 21 parses per second.
  Issues: gc runs way too often; collects 250K each run, takes 0.1 secs
  per run, uses 50% of total CPU time, seems to try to keep size at 10M
* See below, run `run-common/marginals-pair.scm`
  to bulk compute pair MI's.


Plan
----

Try the following things:

* do MST parsing with LG
* compute GOE from pairs


Bringup Notes
-------------


TODO:
* ParseNode should have cost on it... but lg-atomsemse does
  not write it yet...
* Should cog-push-atomspace be cow?  (not documented!)

DONE:
* Use uniform sentence lengths DONE


Check old code:
---------------
This is for the old per-sentence observe code:
```
fanfic
total cpu time: 4514 minutes
(monitor-parse-rate "foo")
foo done=547692 rate=9.716 sentences per sec
(gc-time-taken . 149815788883396) == 2497 minutes!
 (heap-size . 12095488)
 (gc-times . 624593)
```
so 1.14 gc's per sentence NUTS!!
and 2497 / 4514 = 55% of cpu spent in GC ouch!
```
(ListLink . 6630619)
(EvaluationLink . 6630619)
(WordNode . 67703)
(SentenceNode "ANY" (ctv 1 0 547692)) ; count matches above
(ParseNode "ANY" (ctv 1 0 1.29022e+07)) ; approx 24 * nsent
tot-lines: 2199812 approx 4 * nsent
tot-cnct: 565697 nsent plus a few manual commands
cpu: 270893.022 secs  user: 221046.679  sys: 49846.343
maxrss: 26023264 KB  majflt: 56  inblk: 48  outblk: 178783224
18.2 G virt 16.1 G resident
(count-all) ; 13328951 == 13M so about 1.2KB per atom
wc pair-counted/fanfic/ * == 547703
```
----------------------

Punt
====
I got bored doing the proxying below. It's been a distraction.
So I'm gonna brute-force compute pair MI as before. How does that
go, again?


```
guile -l run-common/marginals-pair.scm
```
13 GB to load
Elapsed time to load pairs: 707 secs ... 938 secs
Start computing the basis
Support: found num left= 67443 num right= 67456 in 1336 secs
Support: found num left= 67354 num right= 67368 in 1400 secs
Hmm.. why'd that change?

18 GB after computation ... 16.6GB
Finished with MI computations; this took 1.784 hours.
Finished with MI computations; this took 1.842 hours.


It works:
```
link-parser run-config/dict-combined
```



Proxy setup
===========
On server:
```
guile -l cogserver.scm

; This takes too long:
; (display (monitor-storage))

(cog-report-counts)
(cog-push-atomspace)

```
On localhost,
[follow demo](https://github.com/opencog/atomspace/blob/master/examples/atomspace/persist-proxy.scm)

So this:
```
(use-modules (opencog) (opencog persist))
(use-modules (opencog persist-cog))
(use-modules (opencog nlp))
(define sto (CogStorageNode "cog://10.0.3.208:20018"))

(cog-open sto)

(cog-set-proxy!
	(ProxyParameters
		(ReadThruProxy "rthru pairs")
		(List
			(RocksStorageNode "rocks:///home/ubuntu/data/r18-pair.rdb"))))

(cog-proxy-open)
; That's odd .. this does a second open, which succeeds!? Huh??
; Because the second one has one slash, not two...!!

(fetch-atom (Word "house"))
(fetch-atom (List (Word "the") (Word "house")))
(define pr (List (Word "the") (Word "house")))
(fetch-incoming-set pr)
(define epr (car (cog-incoming-set pr)))
; Above works.
```

Above proves the basic proxy works. Just like before.

Earlier, from `(opencog matrix)` we had this:
Run the below in the client. The 'pair count fails, because there's
no fetch.
```
(use-modules (opencog matrix))
(use-modules (opencog learn))
(define ala (make-any-link-api))
(define alc (add-count-api ala))
(define als (add-storage-count alc))
(define ady (add-dynamic-mi als))
(ady 'formula)
(cog-incoming-by-type (ady 'formula) 'DefineLink)
(ady 'pair-count (Word "the") (Word "horse"))
```

So we want to move that formula to the server, to install that
formula into a `DynamicDataProxy`. But how? Well lets try it.

So we set up a proxy. First, test basic operation of a basic proxy.

```
(use-modules (opencog) (opencog persist))
(use-modules (opencog persist-cog))
(use-modules (opencog matrix))
(use-modules (opencog nlp) (opencog learn))
(define sto (CogStorageNode "cog://10.0.3.208:20018"))

(cog-open sto)

; Define some stuff we plan to send to the CogServer
(define rsn (RocksStorageNode "rocks:///home/ubuntu/data/r18-pair.rdb"))

(define tvp (PredicateNode "*-TruthValueKey-*"))
(define dgc (DefinedProcedureNode "get-cnt"))
(define dfc (DefineLink dgc
	(Lambda (Variable "X")  (FetchValueOf (Variable "X") tvp rsn))))

(define ddp (DynamicDataProxy "dyn-cnt"))
(cog-set-value! ddp tvp dgc)

(store-atom dfc)
(store-atom ddp)
(cog-set-proxy! ddp)

(cog-proxy-open)

(fetch-atom (Word "the"))
(cog-keys (Word "the"))
(cog-value (Word "the") tvp)
```

OK, so above works as expected -- it dynamically fetches the
requested value, without using the read-through proxy.  Let's
see if we can get fancier. We have two choices: Do the MI
computation on the server side, and on the client side. The
should be enough to do it on the client side (but so should
the read-thru proxy.)  Lets test the simpler case first:
client-side.
```
(use-modules (opencog matrix))
(use-modules (opencog learn))
(define ala (make-any-link-api))
(define alc (add-count-api ala))
(define als (add-storage-count alc))
(define ady (add-dynamic-mi als))
(define dpn (ady 'formula))
(define form (car (cog-incoming-by-type dpn 'DefineLink)))

(define ppn (DefinedProcedure "*-put-MI-*))
(define pfm
	(Define ppn
		(Lambda
			(VariableList
				(VariableNode "$L")
				(VariableNode "$R"))
			(
... define the FetchValueOf variant ...
```

Argh. Plan:
Give Dynamic proxy that gets formula from vertex atom.
This formula computes MI. It has to be this:

(define vtx (ala 'make-pair (Word "the") (Word "house")))


(ala 'left-element

(Lambda (Variable "vtx")
	(DoExec
		(ExecutionOutput
			(DefinedProcedureNode "*-dynamic MI ANY")
			(OutgoingOf (Variable "vtx") (Number 1)) ; gets ListLink
		)))

----

Unified parser testing
----------------------
Hmm test the dict.
```
guile -l cogserver.scm
(define ala (make-any-link-api))
(ala 'fetch-pairs)

(define ala    (make-evaluation-pair-api
      (LgLinkNode "ANY")
      'WordNode
      'WordNode
      (AnyNode "left-word")
      (AnyNode "right-word")
      "ANY"
      "Link Grammar ANY link Word Pairs"))

(ala 'fetch-pairs)
; Elapsed time to load pairs: 1306 secs
; 16 GB

(define psa (make-pseudo-cset-api))
(define psc (add-count-api psa))
(define dict (LgDictNode "/home/ubuntu/src/learn/run-config/dict-combined"))
(define parser (make-disjunct-counter psc dict))
(parser "this is a test")
(cog-get-atoms 'Section)
```

What's missing? Weighting?
What the heck. Let's do a full MST parse, using a weight of 1.0
and see what happens.

export CORPORA_DIR=/home/ubuntu/textx/pair-counted


----
