Experiment 19
=============
Feb 2023

Big changes since expt-18:
* Change atomspace to use EdgeLink not EvaluationLink
* Major redo of LG for MST parsing.

An unfulfilled goal from run-18:
* Unified pair-parsing, MST-parsing, gram-parsing and clustering,
  as an integrated, continuous system. This remains an out-of-reach
  dream.

Files:
------
* `r19-pair-plain.rdb` -- pair-counts only, no marginals. See below.
* `r19-pair-marge.rdb` -- pair-counts & marginals & pair MI.
* `r19-sect-part.rdb` -- Sections from 43 articles, as written
                         hold 17M out of 25M atoms.
                         No counting of any bond links, here.
* `r19-sect-pall.rdb` -- As above, but with BondNodes.
                         All 25M of 25M atoms


Procedure
---------
Start from scratch.

* Copy fanfic to `textx/betax`.
* `guile -l cogserver.scm`
* `cd ~/src/learn/run-common`
* `. ~/experiments/run-19/0-pipeline.sh`
* `./process-corpus.sh ~/experiments/run-19/2-pair-conf-en.sh`
* Wait several days ... started 15 Feb 18:20 ... done 17 Feb 16:05
* (monitor-parse-rate "foo") says:
  done=6508938 rate=39.41 per sec
* Hmm. Upon completion, says:
  (EdgeLink . 7557354) (WordNode . 67334)
  which differs from run-18. Number of words differs; last time it was
  (WordNode . 67369) and so ... how did those words get lost??
  Is this explainable by segmentation alternatives, plus random sampling,
  so that some alternatives never got sampled, this time ???
* Also, a LOT fewer edges: only 3/4ths of the previous
  (EvaluationLink . 9935011) I don't know how to hand-wave this away due
  to random sampling. Oh ... but I can wave it away, because the block
  size was reduced to 9 from 12, so, actually, that's right!
* Grand total 10.8 GB RSS.  (count-all) reports 15182065
  so 711 Bytes/Atom. Wow! That's an all-time low!

Stats:
* (Sentence "ANY" (ctv 1 0 6.50894e+06))
* (Parse "ANY" (ctv 1 0 3.90536e+07)
  -- six parses per sentence.
* (gc-stats)  (gc-times . 6517579) so that's one GC per sentence... ouch
* total time: 23499 minutes, gc-time: 12627 minutes so 53% of CPU in GC.
  Ouch. I think I know why, its the gar/gdr or word-pairs.
* real    2741m46.211s elapsed time to submit.
* find pair-counted/fanfic |wc 4476
  This does not match the master count; seems a few files got lost...
* find ~/text-master-copy/alpha-fanfic-tranche-2/split-books/ |wc 4499
* `(Anchor "Num blocks" (ctv 1 0 4433))` so some didn't get counted!?
* telnet tot-cnct: 22376 -- how is this possible!?
* telnet stalls: 4461 -- one stall per file. This makes sense.

* wc pair-counted/fanfic/ * 442522 --- this is the number of lines.
  vs. 444835 in master copy. No great loss.
* telnet top command says: tot-lines: 469306 which is 6% more than
  number of lines in files, so... a few lines to open scm connection,
  etc.

* wc pair-counted/fanfic/ *  6597219 -- number of words -- about equal
  to number of sentences, makes sense, one sentence per slide, and num
  slides is same as num words.
* `(Anchor "Slides" (ctv 1 0 6.50894e+06))` so this is a bit less than
  the number of words ... where did they go? Hmm Its about 12 * 4433 less
  which lops off the last 12 bytes of each slide. So that's OK, then.

So this all looks good.


Pair Marginals
--------------
Next, recompute pair marginals.
```
guile -l run-common/marginals-pair.scm
```

Before batching:
Elapsed time to load pairs: 559 secs
(count-all) 15182063      -> 27K Atoms/sec
RSS 8.9GB --> 586 Bytes/Atom

After batching:
(count-all) 15451385
13.6g RSS -> 880 Bytes/Atom

Time to reload pairs (after batching): 714 secs  --> 21.6K/sec
11.8G RSS -> 764 Bytes/Atom -- Yayy!

Disjunct-counting
-----------------
Text in `~/textx/pair-counted/fanfic`
script `run/3-mst-parsing/mst-submit.sh`

Slow-ish, 4 seconds per sentence .. up to 8 average...
One gc per sentence! (... exactly one...)
Poorly parallel. Why?


After parsing 34 files (avg less than 10 a day. Ouch)
Remaining: 4443 files to process
CPU: 8666 minutes = 144 hours

(WordNode . 73535)
(Section . 798330)
(ConnectorSeq . 612178)
(BondNode . 4312068)
(EdgeLink . 12020259)
(ListLink . 7704182)
Note : edge = list+bond because each list gets used twice: once
with ANY bond and once with ID bond, but not all pairs got ID'ed.

Strangely, number of words went up .. by a lot. Started with
(WordNode . 67334)
so what are all these extra words?

Total 42832 Sentence parsed,  128496 parses, exacty 3 parses per sent.
12 words per sentence, so 12 * 128496 samples = 1541952 = 1.5M words
so avg of 1541952 / 798330 = 1.931 sections per word. Ouch.

8666 minutes ==> 12.1 seconds cpu/sentence
Most of this is not parsing, but is dict lookup. I think...

Total: 25534613 atoms = 25.5M
145.5 GB RSS = 5700 bytes/atom incl LG overhead.

Rocks holds 17M atoms ... out of 25M ... what hasn't been stored???
Rocks: DB-version=2 multi-space=0 initial aid=17063577

(elapse (lambda ()
	(for-each store-atom (cog-get-atoms 'BondNode))))
initial aid=21295564 so clearly the BondNodes were not written.
It's not written by LG, as there is no real motive for LG to do it.
However, ... `learn/scm/parse/lg-parser.scm` was not yet deployed,
and so no bond links counting was done (yet).
```
(elapse (lambda ()
	(for-each store-referrers (cog-get-atoms 'BondNode))))

(for-each store-atom (cog-get-atoms 'EdgeLink))


(define (elapse THUNK)
	(define start (current-time))
	(THUNK)
	(format #t "Took ~D secs\n" (- (current-time) start)))
```
-----------
Hmm. after reloading, its 16.1 GB RSS
Loading only pairs and bond, get
 (WordNode . 68358)

After loading Sections, the number of WordNodes is unchanged.
So what were these other word-nodes, created during parsing??

(elapse (lambda ()
	(load-atoms-of-type 'Section)))


Grand total RSS 16.9GB for 25529437 atoms -> 662 Bytes/atom

So why is this RSS so much smaller?
Deleted the `(LgDictNode "pair-dict")` which should have freed the dict.
So where did all that RAM go?
Who was using it?
Could it really be fragmentation?
Is LG leaking on dict close?
Is there some frame leak?
WTF?


(define all-words (cog-get-atoms 'WordNode))
(length all-words)
68358

(define now-words (atoms-subtract new-words all-words))
(length (now-words)) ; 2900
(define nti (filter (lambda (W) (< 0 (cog-incoming-size W))) now-words))
(length nti) ; 328

(+ 68358 328) ; 68686
(WordNode . 68686) ; Yayy!

The new words, with a non-empty incoming set, got incorporated into
sections and were saved correctly. Good.  (The new words are from
tokenization failing to split words, and then using ANY link to link
them. This is happening because there weren't enough pairs to provide
a sufficiently low-cost MST parse. Huh.



TODO:
-----
* Count MST pair edges used. DONE
* Save pair edges, to have a perma-record. DONE
* Fix LG caching of ID's to make above work. DONE
* Save link ID every time. DONE
* Restore of edges on restart. DONE
* Counts on SentenceNode and ParseNode must be per-stage.
* Data analyize MST-used edges vs. rand.
* Data-analyze the new disjuncts.

* Modify rocks-storage to report what atoms are being stored.
  (Similar to cog-report-counts format)
* Provide an "is this stored already?" function.
