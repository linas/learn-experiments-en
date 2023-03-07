
Experiment 15
=============
Started 21 Sept 2022 Finished 2 October 2022

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
The r15-sim500.rdb has 125250 MI's stored in SimilarityLink's
     i.e. N(N+1)/2 of them, out to N=500.
The r15-sim2500.rdb has N(N+1)/2 = 3126250 MI's stored in
    SimilarityLink's for N=2500.
The r15-sim6000.rdb has MI's in SimilarityLink's for N=6000

So: r15-goe-2500.rdb has MI similarities out to N=2500 and has GOE
similarities out to M=1000. It also has F_2 similarities out to M=250.
See learn-lang-diary/utils/orthogonal-ensemble.scm for the API to access
these, and tools for graphing them.

Next, r15-goe-6k.rdb has MI similarities out to N=6000 and has GOE
similarities out to M=1000.

Not sure what r15-goe-500.rdb has in it.


Data Analysis
-------------

Code in learn-lang-diary/utils/orthogonal-ensemble.scm

OK, So, like a first run of bulk goe computations is now possible.
Lets try it.  Use scripts in ortho-compute.scm

cp -pr r15-sim2500.rdb r15-goe.rdb
guile -l cogserver-gram.scm

Do we really need the gram part?
We do, in order to be able to create a list of ranked words.

(goe 'mean-rms)
; (-1.4053400751699667 2.898486631855367)
(gor 'mean-rms)
; (-2.1492146508638945 2.9517800711660547)


(loop-upper-diagonal dot-prod allwo 0 250)
(loop-upper-diagonal dot-prod allwo 0 500)
(loop-upper-diagonal dot-prod allwo 0 1000)

(loop-upper-diagonal dot-prod allwo 500 20)
(loop-upper-diagonal dot-prod allwo 550 100)
(loop-upper-diagonal dot-prod allwo 650 300)

; --------------------------------

cp -pr r15-sim500.rdb r15-goe-500.rdb

; --------------------------------

cp -pr r15-sim6000.rdb r15-goe-6k.rdb

(goe 'mean-rms)
; (-0.7240391833706027 2.6398276840879658)
(gor 'mean-rms)
; (-2.754334601252323 2.601919247381592)

(loop-upper-diagonal dot-prod allwo 0 250)

; --------------------------------

That's all folks!
