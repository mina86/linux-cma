all: malloc seq_read

%: %.c
	$(CC) -O3 -pedantic -std=c99 -Wall -Werror -o $@ $<

rand-1g:
	trap 'rm -f -- rand.tmp rand.tmp2' 0; \
	head -c 4096 /dev/urandom >rand.tmp; \
	for i in $$(seq 18); do \
		cat rand.tmp rand.tmp >rand.tmp2 && mv rand.tmp2 rand.tmp; \
	done; \
	mv rand.tmp $@
