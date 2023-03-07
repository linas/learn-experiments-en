
Experiment 15
=============
Started 21 Sept 2022

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
(cog-report-counts)
```

More Similarities
-----------------

Now compute more similarities. This will auto-load existing
similarities.
```
(setup-initial-similarities star-obj 500)
(setup-initial-similarities star-obj 2500)
(setup-initial-similarities star-obj 6000)
```

The r14-sim200.rdb has 20116(?) SimilarityLink's
The r14-sim500.rdb has 125250 SimilarityLink's
The r14-sim2500.rdb has 3126250 SimilarityLink's
The r14-sim6000.rdb has  SimilarityLink's

Data Analysis
-------------

Code in learn-lang-diary/utils/orthogonal-ensemble.scm

---------
