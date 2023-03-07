Experiment 18
=============
November 2022

The changes to LG in expt-17 now opens the door for a unified
pair-parsing, MST-parsing, gram-parsing and clustering, as an
integrated, continuous system. This should be much better, but
requires bring-up.

So here we go.

files
* `r18-pair-plain.rdb` -- block-counted pairs, for fanfic only.
  No marginals; counted with the pre-marginal code.

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

```
