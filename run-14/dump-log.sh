#! /bin/sh

dumpi(){
	echo "(dump-log star-obj \"/tmp/r12-log\" print-log)\n" \
		"(dump-log star-obj \"/tmp/r12-cls\" print-merges)\n" | nc -q0 localhost $1
}

# The imprecise dumps
dumpi 20414
# dumpi 20314
# dumpi 20214
# dumpi 20114
