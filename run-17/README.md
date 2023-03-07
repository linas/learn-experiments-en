
Experiment 17
=============
Development and debug of LG dictionary API.

startup
cd ~/data
cp -pr r16-merge.rdb r17-parse.rdb

guile -l cogserver-lg.scm

vi test-dict/storage.dict and verify

link-parser test-dict


Issues:
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
load /usr/local/lib/opencog/modules/libwthru-proxy.so
config SexprShellModule libwthru-proxy.so
(cog-report-counts)

vi test-dict/storage.dict and verify


--------
fetch-atom -> getAtom-> cog-node or cog-link
-> cog_node
->cog-keys->alist
-> cog_keys_alist

fetch->value -> fetch_value -> loadValue -> cog-value
->cog_value
load-atoms-of-ty -> fetch_all_atoms_of_type ->loadType -> cog-get-atoms
load-atomsp -> load_atomspace -> loadAtomSpace -> cog-get-atoms
-> cog_get_atoms



18080
tcpdump port 18080


WTF -- capture while cogserver running:

18:21:07.634384 IP 162.218.65.161.26526 > fanny.18080: Flags [S], seq 3806261560, win 64240, options [mss 1460,sackOK,TS val 4001273613 ecr 0,nop,wscale 7], length 0
18:21:07.634503 IP fanny.18080 > 162.218.65.161.26526: Flags [S.], seq 1921315049, ack 3806261561, win 65160, options [mss 1460,sackOK,TS val 3818867504 ecr 4001273613,nop,wscale 7], length 0
18:21:07.674908 IP 162.218.65.161.26526 > fanny.18080: Flags [.], ack 1, win 502, options [nop,nop,TS val 4001273653 ecr 3818867504], length 0
18:21:07.674909 IP 162.218.65.161.26526 > fanny.18080: Flags [P.], seq 1:9, ack 1, win 502, options [nop,nop,TS val 4001273653 ecr 3818867504], length 8
18:21:07.675090 IP fanny.18080 > 162.218.65.161.26526: Flags [.], ack 9, win 509, options [nop,nop,TS val 3818867545 ecr 4001273653], length 0
18:21:07.714578 IP 162.218.65.161.26526 > fanny.18080: Flags [P.], seq 9:263, ack 1, win 502, options [nop,nop,TS val 4001273693 ecr 3818867545], length 254
18:21:07.714638 IP fanny.18080 > 162.218.65.161.26526: Flags [.], ack 263, win 508, options [nop,nop,TS val 3818867584 ecr 4001273693], length 0
18:21:07.714824 IP fanny.18080 > 162.218.65.161.26526: Flags [P.], seq 1:52, ack 263, win 508, options [nop,nop,TS val 3818867585 ecr 4001273693], length 51
18:21:07.715010 IP fanny.18080 > 162.218.65.161.26526: Flags [F.], seq 52, ack 263, win 508, options [nop,nop,TS val 3818867585 ecr 4001273693], length 0
18:21:07.754258 IP 162.218.65.161.26526 > fanny.18080: Flags [.], ack 52, win 502, options [nop,nop,TS val 4001273733 ecr 3818867585], length 0
18:21:07.794968 IP 162.218.65.161.26526 > fanny.18080: Flags [.], ack 53, win 502, options [nop,nop,TS val 4001273773 ecr 3818867585], length 0
18:21:08.675209 IP 162.218.65.161.26526 > fanny.18080: Flags [R.], seq 263, ack 53, win 502, options [nop,nop,TS val 4001274654 ecr 3818867585], length 0

six seconds later;:
18:21:13.675706 IP 162.218.65.162.51792 > fanny.18080: Flags [S], seq 2737485821, win 64240, options [mss 1460,sackOK,TS val 3478766769 ecr 0,nop,wscale 7], length 0
18:21:13.675792 IP fanny.18080 > 162.218.65.162.51792: Flags [S.], seq 1947561967, ack 2737485822, win 65160, options [mss 1460,sackOK,TS val 4271182257 ecr 3478766769,nop,wscale 7], length 0


cogserver not running:

listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
18:31:38.001729 IP 162.218.65.176.3564 > fanny.18080: Flags [S], seq 1151307629, win 64240, options [mss 1460,sackOK,TS val 2122991075 ecr 0,nop,wscale 7], length 0
18:31:38.001814 IP fanny.18080 > 162.218.65.176.3564: Flags [R.], seq 0, ack 1151307630, win 0, length 0
18:32:38.051786 IP 162.218.65.177.24117 > fanny.18080: Flags [S], seq 3510207828, win 64240, options [mss 1460,sackOK,TS val 634899544 ecr 0,nop,wscale 7], length 0
18:32:38.051881 IP fanny.18080 > 162.218.65.177.24117: Flags [R.], seq 0, ack 3510207829, win 0, length 0
18:33:38.093977 IP 162.218.65.178.62064 > fanny.18080: Flags [S], seq 460061136, win 64240, options [mss 1460,sackOK,TS val 844071500 ecr 0,nop,wscale 7], length 0
18:33:38.094084 IP fanny.18080 > 162.218.65.178.62064: Flags [R.], seq 0, ack 460061137, win 0, length 0

wtf the server is not even runnig!!!
Note exactly 6 seconds apart

dig -x 162.218.65.176
65.218.162.in-addr.arpa. 10572	IN	SOA	ns00.forked.net. admin.forked.net. 2017090700 86400 3600 604800 21600

Oregon Colocation and Dedicated Servers - Oregon

18:41:39.458582 IP 162.218.65.186.11904 > fanny.18080: Flags [S], seq 1938192295, win 64240, options [mss 1460,sackOK,TS val 2011110984 ecr 0,nop,wscale 7], length 0
18:41:39.458688 IP fanny.18080 > 162.218.65.186.11904: Flags [R.], seq 0, ack 1938192296, win 0, length 0

Then not in step:
soon 
18:42:01.972516 IP 162.218.65.219.17306 > fanny.18080: Flags [S], seq 1827998968, win 64240, options [mss 1460,sackOK,TS val 3632543284 ecr 0,nop,wscale 7], length 0
18:42:01.972624 IP fanny.18080 > 162.218.65.219.17306: Flags [R.], seq 0, ack 1827998969, win 0, length 0

oh its monerod
tcpdump port 18080
tcpdump net 162.218.65/24



========
