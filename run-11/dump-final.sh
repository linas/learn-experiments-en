#! /bin/sh

dumpi(){
	export STORAGE_NODE="(RocksStorage \"$MST_DB\")"
	echo -e "(sleep 1)\n" \
		"(define cset-obj (make-pseudo-cset-api))\n" \
		"(define covr-obj (add-covering-sections cset-obj))\n" \
		"(define star-obj covr-obj)\n" \
		"(fetch-atom (star-obj 'wild-wild))\n" \
		"(dump-log star-obj \"/tmp/r11-log\" print-log)\n" \
		"(dump-log star-obj \"/tmp/r11-cls\" print-merges)\n" \
		"(exit-server)\n" | guile -l cogserver.scm
}

dumpp(){
	export STORAGE_NODE="(RocksStorage \"$MST_DB\")"
	echo -e "(sleep 1)\n" \
		"(define cset-obj (make-pseudo-cset-api))\n" \
		"(define covr-obj (add-covering-sections cset-obj))\n" \
		"(define star-obj covr-obj)\n" \
		"(fetch-atom (star-obj 'wild-wild))\n" \
		"(dump-log star-obj \"/tmp/r11-p-log\" print-log)\n" \
		"(dump-log star-obj \"/tmp/r11-p-cls\" print-merges)\n" \
		"(exit-server)\n" | guile -l cogserver.scm
}

export MST_DB=${ROCKS_DATA_DIR}/r11-imp-q0.7-c0.2-n1.rdb
dumpi
export MST_DB=${ROCKS_DATA_DIR}/r11-imp-q0.7-c0.2-n2.rdb
dumpi
export MST_DB=${ROCKS_DATA_DIR}/r11-imp-q0.7-c0.2-n3.rdb
dumpi
export MST_DB=${ROCKS_DATA_DIR}/r11-imp-q0.7-c0.2-n4.rdb
dumpi
export MST_DB=${ROCKS_DATA_DIR}/r11-mrg-q0.6-c0.2-n4.rdb
dumpp
export MST_DB=${ROCKS_DATA_DIR}/r11-mrg-q0.7-c0.2-n4.rdb
dumpp
export MST_DB=${ROCKS_DATA_DIR}/r11-mrg-q0.8-c0.2-n4.rdb
dumpp
export MST_DB=${ROCKS_DATA_DIR}/r11-mrg-q0.8-c0.2-n1.rdb
dumpp
