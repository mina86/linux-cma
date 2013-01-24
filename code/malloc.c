#include <stdlib.h>
#include <stdio.h>

int main(void) {
	long i = 0;
	while (1) {
		*(char *)malloc(4096) = '1';
		printf("\r%10ld", ++i * 4);
		fflush(stdout);
	}
}
