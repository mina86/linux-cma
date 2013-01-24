#!/bin/sh -e

if [ -n "$3" ]; then
	[ -e /dev/cma_test ] || insmod cma_test.ko
	echo "Allocating $(($3 * 128)) MiB CMA memory."
	for i in $(seq $3); do
		echo $(( 128 * 1024 )) >/dev/cma_test
	done
fi

size=$(( ${2:-900} * 1024 * 1024 ))

echo "First read of ${2:-900} MiB"
time ./seq-read rand 1 $size

echo "Subsequent ${1:-100} reads of ${2:-900} MiB"
time ./seq-read rand ${1:-100} $size

read && /sbin/reboot
