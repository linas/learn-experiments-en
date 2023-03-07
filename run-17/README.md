
Experiment 17
=============
Development and debug of LG dictionary API.

startup
cd ~/data
cp -pr xxx r17-parse.rdb

guile -l cogserver-lg.scm

vi test-dict/storage.dict and verify

link-parser test-dict


Issues:

-----------

link-generator -l ../data/baz -s2

two words
# Linkages found: 141

LEFT-WALL NOTES .
LEFT-WALL No .
LEFT-WALL John .
LEFT-WALL II .
LEFT-WALL A .
LEFT-WALL III .
LEFT-WALL Jack .
LEFT-WALL Jack ?
LEFT-WALL IV .
LEFT-WALL L .
LEFT-WALL V .
LEFT-WALL Well .

three words
# Linkages found: 1861

LEFT-WALL God knows !
LEFT-WALL He is .
LEFT-WALL His family .
LEFT-WALL it is .

four words
# Linkages found: 19347

LEFT-WALL It is right .
LEFT-WALL I never had .


five words
# Linkages found: 387333

LEFT-WALL ‘ No shit . ’
LEFT-WALL ‘ I won’t . ’
LEFT-WALL This is a conclusion .
LEFT-WALL Well , what happened .
LEFT-WALL One of you all .

-s6
# Linkages found: 9078835


LEFT-WALL Winter comes , to believe .
LEFT-WALL This word is to that .
LEFT-WALL In any other way . ”
LEFT-WALL In none of those days .
LEFT-WALL American . An ordinary man .

-s8
# Linkages found: 2147483647

LEFT-WALL Winter comes , the delight of the two
LEFT-WALL Winter is , it wants to . ”
LEFT-WALL In London , the large part , is

-s9
# Linkages found: 2147483647
LEFT-WALL Winter comes , in good time as I .
Dwight . No - one thousand pounds . '
. A poor boy , about 100 yards .
, and have them brought up to Jack .
Here is a tale of A cry of the


LEFT-WALL Winter comes , in good time as I .
# linkage-cost=-0.929099
            LEFT-WALL    -0.929  MIAN+
        <MIAN- JPNH+>     0.000  MIAN- JPNH+
        <JPNH- LRXF+>     0.000  JPNH- LRXF+
        <LRXF- SYWF+>     0.000  LRXF- SYWF+
        <SYWF- BGNK+>     0.000  SYWF- BGNK+
        <BGNK- ZTNK+>     0.000  BGNK- ZTNK+
        <ZTNK- JUQT+>     0.000  ZTNK- JUQT+
        <JUQT- OWLS+>     0.000  JUQT- OWLS+
        <OWLS- ZULS+>     0.000  OWLS- ZULS+
              <ZULS->     0.000  ZULS-

	Unique linkage, cost vector = (UNUSED=0 DIS=-8.36 LEN=0)

    +---EF---+--ZG-+-SK+SO+AIO+BQAB+HWBB+RQCB+GLGB+
    |        |     |   |  |   |    |    |    |    |
LEFT-WALL Winter comes , in good time  as    I    .

            LEFT-WALL    -0.929  EF+
               Winter    -2.391  EF- ZG+
                comes    -2.504  ZG- SK+
                    ,    -0.322  SK- SO+
                   in    -0.308  SO- AIO+
                 good    -1.149  AIO- BQAB+
                 time    -0.957  BQAB- HWBB+
                   as    -0.244  HWBB- RQCB+
                    I     0.064  RQCB- GLGB+
                    .     0.376  GLGB-

      linkage = linkage_create(i, sent, opts);
         char *disjuncts = linkage_print_disjuncts(linkage);
   linkage_disjunct_cost(linkage)
   return linkage->lifo.disjunct_cost;

if (!IS_GENERATION(sent->dict))
      compute_chosen_words(sent, linkage, opts);

float linkage_get_disjunct_cost(const Linkage linkage, WordIdx w)

--cost-max=

prepare/build-disjuncts.c:




wtf
only the wall has a cost???


```

linkage_disjunct_cost(linkage),
print_sentences


========
