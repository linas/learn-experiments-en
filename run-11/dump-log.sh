#! /bin/sh

dumpi(){
	echo "(dump-log star-obj \"/tmp/r11-log\" print-log)\n" \
		"(dump-log star-obj \"/tmp/r11-cls\" print-merges)\n" | nc -q0 localhost $1
}

dumpp(){
	echo "(dump-log star-obj \"/tmp/r11-p-log\" print-log)\n" \
		"(dump-log star-obj \"/tmp/r11-p-cls\" print-merges)\n" | nc -q0 localhost $1
}

dumpi 20411
dumpi 20311
dumpi 20211
dumpi 20111

dumpp 19611
dumpp 19711
dumpp 19811
dumpp 21811
