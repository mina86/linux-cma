#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char **argv) {
	unsigned long pos, size, max_size, i, times;
	char *end1 = NULL, *end2 = NULL;
	volatile char *buf;
	struct stat fst;
	int fd;

	times    = argc >= 3 ? strtoul(argv[2], &end1, 0) : 1;
	max_size = argc >= 4 ? strtoul(argv[3], &end2, 0) : ULONG_MAX;
	if (argc > 4 || (end1 && *end1) || !times ||
	    (end2 && *end2) || max_size < 4096) {
		fprintf(stderr, "usage: %s <file> [<times>] [<size>]\n", *argv);
		return 1;
	}

	fd = open(argv[1], O_RDONLY);
	if (fd < 0 || fstat(fd, &fst) < 0) {
show_errno:
		fprintf(stderr, "%s: %s\n", argv[1], strerror(errno));
		return 1;
	}

	size = fst.st_size & ~4095UL;
	if (!size) {
		fprintf(stderr, "%s: %s\n", argv[1], "file is too small");
		return 1;
	}
	if (size > max_size)
		size = max_size & ~4095UL;
	printf("size: %lu, %lu pages\n", size, size / 4096);

	buf = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
	if (!buf)
		goto show_errno;

	for (i = 0; i < times; ++i) {
		printf("\r%6lu / %6lu", i, times);
		for (pos = 0; pos < size; pos += 4096)
			buf[pos];
	}
	printf("\r%6lu / %6lu\nDone.\n", i, times);
	return 0;
}
