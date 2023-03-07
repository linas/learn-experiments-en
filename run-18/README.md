Experiment 18
=============
November 2022

The changes to LG in expt-17 now opens the door for a unified
pair-parsing, MST-parsing, gram-parsing and clustering, as an
integrated, continuous system. This should be much better, but
requires bring-up.

So here we go.

Gonna cheat a bit, start with `run-1-marg-tranche-123.rdb` --
this has all pairs, untrimmed, but with marginals.

Well, try two things:
(1) MST parsing with LG
(2) GOE from pairs

Plan items:
* Use uniform sentence lengths


Bugs
\"This \\is \\\\a \\\\\\test, right?\"\\\\

Backslash issue...
(use-modules (opencog) (opencog persist) (opencog persist-rocks))
(define rsn (RocksStorage "rocks:///tmp/foo.rdb"))
(cog-open rsn)
(store-atom (Concept "\"robber"))
(store-atom (Concept "\\\"ohh"))
(store-atom (Concept "\\\\\"gorp"))
(store-atom (Concept "\\\\\\\"forp"))
(cog-close rsn)
 works great.
