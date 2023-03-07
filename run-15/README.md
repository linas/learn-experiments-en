
Experiment 15
=============
Gaussian Orthogonal Ensemble experiments.

* Expansion of the size of the similarity matrix.

Copy the data file:
```
cd ~/data
cp -pr r14-sim200.rdb r15-sim500.rdb
```

Configure the pipeline:
```
cd ~/experiments/run-15
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
```

Now compute more similarities:
```
(setup-initial-similarities star-obj 500)
```

---------
