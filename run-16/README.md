
Experiment 16
=============
Started 4 October 2022

Merging using Gaussian Orthogonal Ensemble experiments.

Copy the data file:
```
cd ~/data
cp -pr r15-goe-6k.rdb r16-merge.rdb
```

The `r15-goe-6k.rdb` file contains MI pairs out to N=6K and also
GOE similarities out to M=1000.

Configure the pipeline:
```
cd ~/experiments/run-16
. 0-pipeline.sh
. 4-gram-conf-en.sh
cd ~/src/learn/run/
./run-tmux.sh
```

Get ready to rumble!
```
cd ~/src/learn/run-common/
guile -l cogserver-gram.scm
```

Verify everything looks good.
```
(cog-report-counts)
```

Merge
-----
Now start doing merges.


; --------------------------------

That's all folks!
