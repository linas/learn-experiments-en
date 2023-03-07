
Experiment 17
=============
Development and debug of LG dictionary API.

startup
cd ~/data
cp -pr xxx r17-parse.rdb

guile -l cogserver-lg.scm

vi test-dict/storage.dict and verify

link-parser test-dict


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



```



========
