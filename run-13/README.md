Experiment-13
=============
This is not an experiment, it is just a staging area for config
files to do some random explorations of stuff.

Data archive is at
`/home2/linas/src/novamente/data`
and
`/home2/linas/src/novamente/data/rocks-archive`

To restore, type
`sudo cp -pr /home2/linas/src/novamente/data/rocks-archive/r3-mpg-marg.rdb /data/lxc-databases/learn-en/rootfs/data`

Datasets
--------
* `run-1-en_pairs-tranche-12345.rdb` -- I think this is what the name
  implies; its just the pairs.
* `run-1-marg-tranche-12345.rdb` -- above, with marginals ... seems not
  to exist? Presumably because we ran out of RAM to compute the
  marginals? Should we try again?
* `run-1-marg-tranche-1234.rdb` -- Biggest pair file which does have
  marginals.
* `run-1-t1234-tsup-1-1-1.rdb` -- Pairs, trimed to 1,1,1, with support
  marginals.
* `r3-mpg-marg.rdb` -- A "badly-trimmed" dataset, but for which we
  report stats if the agi-22 article.

Notes
-----
Pair-count histograms
```
guile -l cogserver-mst.scm
```

Then use `density-of-states.scm` from diary utils.
---------------
