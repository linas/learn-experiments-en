
Experiment 17
=============
October 2022 concluded Nov 2022

Goal
----
Development and debug of LG dictionary API.

Summary
-------
* The disjuncts in `r16-merge.rdb` and `r13-all-in-one.rdb` are
  insufficient to generate interesting sentences. There are too
  few of them.
* Apparently, trimming has depleted the ranks. Thus, although they
  "look good" when examine individually, they're not rich enough to
  be used.
* The LG `dict-atomese` backend was extended to use word-pairs and
  also ANY links.
* Existing disjuncts can be supplemented with optional single links
  taken from word-pairs. This explodes the RAM usage in LG, up to
  10 GB or 20GB or maybe more, depending.
* This suggests clustering should be more aggressive.
* Since the LG atomese dict can now use single word-pairs, that means
  it can do MST/MPG parsing. Thus, we can get rid of the atomspace
  MST parser.
* The LG backend can also suppliment disjuncts with ANY links.
* The MST/MPG mode can also use ANY links.
* As a result, the LG parser can do all of it -- random-tree ANY
  parsing, MST/MPG parsing, and Section/disjunct parsing.
* This creates a possibility of doing "continuous learning": learning
  word pairs and disjuncts at the same time.
* However, the more complex portions cannot run until marginals
  recomputed. This suggests a natural awake/asleep cycle. During the
  awake cycle, data is ingested. During the asleep cycle, marginals
  are (re-) computed, MI is (re-)computed, similarities are updated.
  This is very nice, it gets rid of the pipeline.
* So it seems like it's time to abolish the pipeline.
* BTW, we can do GOE similarity with just word-pair MI. So clustering
  can begin before disjuncts have been created.

Experiment 18 starts this process.

process
-------
startup
```
cd ~/data
cp -pr r16-merge.rdb r17-parse.rdb

guile -l cogserver-lg.scm

vi test-dict/storage.dict and verify

link-parser test-dict
```

Issues
------
* Some sections don't have costs
  -- The sections that have WordClassNodes in them!
  -- Becuase this is the GOE dataset, these have not been computed yet.
* Repeated sentences because repeated linakges.  #1348


Link Generator
--------------
Using the GOE merge up to 100 dataset. `r16-merge.rdb`

Conclude:
* First impression: the generated sentences are terrible.
* But why?
* Perhaps the trimming cut out too much. Rarely observed sections
  are probably needed for a full grammar.
* There's a way to spin this as good news: The generated text shows
  a very strong preference for things that look like chapter titles
  and table-of-contents entries. This suggests that the generator is
  dreaming of "entitites"; that perhaps entities will not require
  special considerations?

```
link-generator -l ../data/baz -s2

#define cost-scale -0.2;      <<< Note minus sign needed for invesion
#define cost-offset 0.0;
#define cost-cutoff 8.0;
#define cost-default 1.0;     <<< used below. Too much?


two words
# Linkages found: 141

Top 50 only:

LEFT-WALL Chapter 1 # linkage-cost= -4.052
LEFT-WALL II .  # linkage-cost= -3.511
LEFT-WALL 3 .  # linkage-cost= -3.474
LEFT-WALL “ _ # linkage-cost= -2.749
LEFT-WALL . XVI # linkage-cost= -1.600
LEFT-WALL . XIII # linkage-cost= -1.573
LEFT-WALL . XII # linkage-cost= -1.503
LEFT-WALL . Notes # linkage-cost= -1.501
LEFT-WALL . II # linkage-cost= -1.416
LEFT-WALL . M # linkage-cost= -0.554
# Bye.

All of them:
# Linkages found: 155

LEFT-WALL THE END # linkage-cost= -6.530
LEFT-WALL PART II # linkage-cost= -5.961
LEFT-WALL BOOK III # linkage-cost= -5.839
LEFT-WALL A Japanese # linkage-cost= -5.132
LEFT-WALL ' Tis # linkage-cost= -5.121
LEFT-WALL CHAPTER XIX # linkage-cost= -5.071
LEFT-WALL ... \\\\\\\\\\\\\\\ # linkage-cost= -4.995
LEFT-WALL CHAPTER X # linkage-cost= -4.976
LEFT-WALL CHAPTER VII # linkage-cost= -4.901


# Sentence length: 3
# Linkages found: 2399
# Linkages generated: 500

LEFT-WALL THE END PAGE # linkage-cost= -8.131
LEFT-WALL The French ambassador # linkage-cost= -7.157
LEFT-WALL BOOK VI .  # linkage-cost= -6.654
LEFT-WALL Harry repeated .  # linkage-cost= -6.542
LEFT-WALL Part II .  # linkage-cost= -6.513
LEFT-WALL * * * # linkage-cost= -6.296
LEFT-WALL _ CHAPTER V # linkage-cost= -6.293
LEFT-WALL The principal -- # linkage-cost= -6.153
LEFT-WALL [ 12 ] # linkage-cost= -6.114
LEFT-WALL Mary replied .  # linkage-cost= -5.873


# Sentence length: 4
# Linkages found: 20626
# Linkages generated: 500
LEFT-WALL The New Testament -- # linkage-cost= -9.312
LEFT-WALL The French ambassador -- # linkage-cost= -8.695
LEFT-WALL Princess Mary . XXX # linkage-cost= -8.540
LEFT-WALL Centuries . CHAPTER VI # linkage-cost= -8.308
LEFT-WALL * * * * # linkage-cost= -8.260
LEFT-WALL Princess Mary . L # linkage-cost= -7.842
LEFT-WALL 213 . CHAPTER IX # linkage-cost= -7.810



four words (with the bad ordering)
# Linkages found: 19347
LEFT-WALL It is right .
LEFT-WALL I never had .


five words (bad ordering)
# Linkages found: 387333
LEFT-WALL ‘ No shit . ’
LEFT-WALL ‘ I won’t . ’
LEFT-WALL This is a conclusion .
LEFT-WALL Well , what happened .
LEFT-WALL One of you all .

six words (bad ordering)
# Linkages found: 9078835
LEFT-WALL Winter comes , to believe .
LEFT-WALL This word is to that .
LEFT-WALL In any other way . ”
LEFT-WALL In none of those days .
LEFT-WALL American . An ordinary man .

# Sentence length: 6
# Linkages found: 8945830
# Linkages generated: 500
LEFT-WALL THE END PAGE 1 . ) # linkage-cost= -12.827
LEFT-WALL Johnny . 12mo . $ 1.00 # linkage-cost= -12.078
LEFT-WALL Part III . chap . ” # linkage-cost= -11.306
LEFT-WALL Part IV . chap . ” # linkage-cost= -11.304
LEFT-WALL E . T . C .  # linkage-cost= -10.331
LEFT-WALL Yes ! God forgive me !  # linkage-cost= -10.300
LEFT-WALL “ A tale of An unexpected # linkage-cost= -10.235
LEFT-WALL A bright smile and a formal # linkage-cost= -10.045
LEFT-WALL Jack looked over the road --


eight words (bad ordering)
# Linkages found: 2147483647
LEFT-WALL Winter comes , the delight of the two
LEFT-WALL Winter is , it wants to . ”
LEFT-WALL In London , the large part , is


nine words (bad ordering)
# Linkages found: 2147483647
LEFT-WALL Winter comes , in good time as I .
Dwight . No - one thousand pounds . '
. A poor boy , about 100 yards .
, and have them brought up to Jack .
Here is a tale of A cry of the


# Sentence length: 10
# Linkages found: 2147483647
# Linkages generated: 500
LEFT-WALL SIR : — DEAR SIR : I am sorry .  # linkage-cost= -19.612
LEFT-WALL THE END PAGE 1 . ii . 3 ) .  # linkage-cost= -19.094
LEFT-WALL Princess Mary . 12mo . $ 10 , 17 ) # linkage-cost= -18.536
LEFT-WALL SIR : — DEAR SIR : I see the effect # linkage-cost= -18.052
LEFT-WALL THE END PAGE 1 . _ , ” etc .  # linkage-cost= -17.952
LEFT-WALL THE END PAGE 1 . ’ — _ me .  # linkage-cost= -17.251
LEFT-WALL A bell rang , the treatment of all that ?  # linkage-cost= -14.803
LEFT-WALL Jack leaned forward , trying to . ” 2 .  # linkage-cost= -14.764
LEFT-WALL notes in the time Take me for ever . VII # linkage-cost= -14.004
LEFT-WALL ###LEFT-WALL### It is one ! He started laughing . NOTES # linkage-cost= -14.003
LEFT-WALL A blind man , should be successful , as ' # linkage-cost= -13.962
LEFT-WALL THE PAGE 1 . _ ] It was clear .  # linkage-cost= -13.954
LEFT-WALL A soft voice , when our men from the two # linkage-cost= -13.759
```

Word Pairs
----------
Can we repeat this trick, using word-pairs? i.e. can we emulate MST
parsing using LG ???

Also debug the pass-thru proxy...

See run-13/README.md for a description of datasets.

startup
cd ~/data
cp -pr r13-all-in-one.rdb r17-all-in-one.rdb

. ~/experiments/run-17/4-gram-conf-en.sh

# Load nothing
guile -l cogserver.scm

rlwrap telnet localhost 20017
rlwrap telnet 10.0.3.208 20017
load /usr/local/lib/opencog/modules/libw-thru-proxy.so
config SexprShellModule libr-thru-proxy.so
# not needed config SexprShellModule libw-thru-proxy.so
(cog-report-counts)

vi test-dict/storage.dict and verify

(use-modules (opencog) (opencog persist) (opencog persist-cog))
(use-modules (opencog nlp))
(define csn (CogStorageNode "cog://10.0.3.208:20017"))
(cog-open csn)
(fetch-incoming-by-type (Word "it") 'Section)

(for-each cog-extract-recursive! (cog-get-atoms 'Word))


(fetch-incoming-by-type (Word "it") 'List)
(car (cog-get-atoms 'List))

(fetch-incoming-by-type (car (cog-get-atoms 'List)) 'Evaluation)

(EvaluationLink (ctv 1 0 225)
  (LgLinkNode "ANY")
  (ListLink
    (WordNode "aimed")
    (WordNode "it")))

(define e (car (cog-get-atoms 'Evaluation)))
(cog-keys e)
(PredicateNode "*-Mutual Info Key-*")
(cog-value e (PredicateNode "*-Mutual Info Key-*"))


--------
(cog-link 'List (Word "the") (Word "dog"))
(cog-incoming-by-type (List  (Word "the") (Word "dog")) 'Evaluation)
(cog-incoming-by-type (List  (Word "dog") (Word "watched")) 'Evaluation)

links for the - dog - watched -the -cat

There is
(cog-link 'List (Word "###LEFT-WALL###") (Word "the"))
but it has no incomnig link?


as_boolean_lookup
count_sections

printf("duuude %s after sects %d\n", germ->get_name().c_str(), size_of_expression(orhead));
```

the dog watched the bird
duuude ###LEFT-WALL### after sects 347
duuude the after sects 55451
duuude dog after sects 122
duuude watched after sects 103
duuude bird after sects 92

duude wrd=###LEFT-WALL### ndj=3606
duude wrd=cat ndj=2664
duude wrd=bird ndj=3327
duude wrd=dog ndj=3231

fuuuuu w 1-prai and 1 any
duude wrd=###LEFT-WALL### nsect=484402
duude wrd=the nsect=154637219
duude wrd=dog nsect=112345
duude wrd=watched nsect=131297
duude wrd=bird nsect=86753

1 pair 0 any
duude wrd=###LEFT-WALL### nsect=483598
duude wrd=the nsect=154528167
duude wrd=dog nsect=112137
duude wrd=watched nsect=131113
duude wrd=bird nsect=86597

 2 pair
duude wrd=###LEFT-WALL### nsect=966802
duude wrd=the nsect=309000325
duude wrd=dog nsect=224145
duude wrd=watched nsect=262121
duude wrd=bird nsect=173099

 3 pair
duude wrd=###LEFT-WALL### nsect=1450006
duude wrd=the nsect=463472483
duude wrd=dog nsect=336153
duude wrd=watched nsect=393129
duude wrd=bird nsect=259601


	Linkage 1, cost vector = (UNUSED=1 DIS=-2.91 LEN=3)

           +---------ATE--------+
           +OLE+-VBG-+-RGD-+-ATE+
           |   |     |     |    |
LEFT-WALL the dog watched the bird

linkparser>
	Linkage 6, cost vector = (UNUSED=1 DIS=-2.29 LEN=3)

           +---------ATE--------+
           |   +-VBG-+-RGD-+-ATE+
           |   |     |     |    |
LEFT-WALL the dog watched the bird


L+ or K+ or E+ or J+ or I+ or H+ or G+ or E+ or A+ or C+ or D+ or B+


M+ or K+ or J+ or I+ or H+ or F+ or E+ & or C+ & or A+ & or B+

duuude got sects 604 for ###LEFT-WALL###


;        +-------A-------+
;        |     +----D----+----I---+
;        |     | +---E---+---H--+ |
;        |     | | +--F--+--G-+ | |
;        |     | | |     |    | | |
;    LEFT-WALL 1 2 3 fountain 4 5 6
;
; The expected disjunct on the word 'fountain' is
;
;      F- & E- & D- & A- & G+ & H+ & I+

level playing field

John saw a cat


todo - later bool lookup too DONE
-- add pairs to disjuncts DONE
-- change to middle DONE
-- allow unknown words DONE

lots of repeated parses bug report

linkage_get_disjunct_cost
   return linkage->lifo.disjunct_cost;

struct Disjunct_struct
{
   Connector *left, *right;

->multi
->desc->string
->desc->uc_length; uc_start;
lkg->link_array[i].rw

Link *          link_array;
struct Link_s
{
   size_t lw;              /* Offset into Linkage->word NOT Sentence->word */
   size_t rw;              /* Offset into Linkage->word NOT Sentence->word */
   Connector * lc;
   Connector * rc;

../prepare/build-disjuncts.c:
struct condesc_struct

13 17 -- 29 bingo

========
