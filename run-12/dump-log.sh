#! /bin/sh

dumpi(){
	echo "(dump-log star-obj \"/tmp/r12-log\" print-log)\n" \
		"(dump-log star-obj \"/tmp/r12-cls\" print-merges)\n" | nc -q0 localhost $1
}

dumpp(){
	echo "(dump-log star-obj \"/tmp/r12-p-log\" print-log)\n" \
		"(dump-log star-obj \"/tmp/r12-p-cls\" print-merges)\n" | nc -q0 localhost $1
}

# The imprecise dumps
dumpi 20412
# dumpi 20312
# dumpi 20212
dumpi 20112

# The precise dumps
dumpp 19612
dumpp 19712
dumpp 19812
dumpp 21812
