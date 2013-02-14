LATEX := latex -halt-on-error -file-line-error -output-directory=build

TEXINPUTS := .:$(HOME)/bsc/:
export TEXINPUTS

all: cma-bsc.pdf


build/deps: find-deps.sh $(wildcard src/*.tex)
	@exec mkdir -p build
	@DEPS_TARGET=build/cma-bsc.dvi exec sh $^ >$@

build/cma-bsc.dvi: src/main.tex
build/cma-bsc.dvi: $(wildcard src/*.*)
build/cma-bsc.dvi: $(wildcard code/*.*)

-include build/deps


%.pdf: build/%.dvi
	exec dvipdf $< $@


build/cma-bsc.dvi:
	@exec mkdir -p build
	exec $(LATEX) $<
	( cd build; exec bibtex main )
	exec $(LATEX) $<
	exec $(LATEX) $<
	exec mv -- build/main.dvi $@


build/%.eps: img/%.svg
	@exec mkdir -p build
	exec inkscape -z -D --file=$^ --export-eps=$@

build/%.eps: img/%.dia
	@exec mkdir -p build
	exec dia -l -t eps -e $@ $<

build/%.eps: img/%.jpg
	@exec mkdir -p build
	exec convert $^ $@

build/%.eps: img/%.png
	@exec mkdir -p build
	exec convert $^ $@


RELEASE_TYPE	:= praca
RELEASE_BASE	:= Nazarewicz_Michal-CMA-$(RELEASE_TYPE)
release: $(RELEASE_BASE).pdf $(RELEASE_BASE).zip $(RELEASE_BASE).tar.bz2
release: $(RELEASE_BASE).tar.gz $(RELEASE_BASE).tar.xz

$(RELEASE_BASE).pdf: cma-bsc.pdf
	cp -- $^ $@

$(RELEASE_BASE).zip:
	git archive --format=zip --prefix=$(basename $@)/ -o $@ HEAD

.INTERMEDIATE: $(RELEASE_BASE).tar
$(RELEASE_BASE).tar:
	git archive --format=tar --prefix=$(basename $@)/ -o $@ HEAD

$(RELEASE_BASE).tar.gz: $(RELEASE_BASE).tar
	gzip -9 <$^ >$@

$(RELEASE_BASE).tar.bz2: $(RELEASE_BASE).tar
	bzip2 -9 <$^ >$@

$(RELEASE_BASE).tar.xz: $(RELEASE_BASE).tar
	xz -9 <$^ >$@

.PHONY: $(RELEASE_BASE).zip $(RELEASE_BASE).tar


.DELETE_ON_ERROR:

iso-full: iso-source img/seq-read-times.ods code/seq_read.c code/Makefile code/run_test.sh code/malloc.c
	mkdir -p $@
	cp -Rl -- $</* $@/
	mv -- $@/README.full.txt $@/README.txt
	rm -- $@/README.text.txt
	ln -f -- img/seq-read-times.ods code/seq_read.c code/Makefile code/run_test.sh code/malloc.c $@/

iso-text: iso-source img/seq-read-times.ods
	mkdir -p $@
	cp -- $</README.text.txt $@/README.txt
	ln -f -- img/seq-read-times.ods $@/

iso-full: iso-full/Nazarewicz_Michal-CMA.pdf
iso-full: iso-full/Nazarewicz_Michal-CMA.tar.bz2
iso-full: iso-full/Nazarewicz_Michal-CMA.tar.gz
iso-full: iso-full/Nazarewicz_Michal-CMA.tar.xz
iso-full: iso-full/Nazarewicz_Michal-CMA.zip
iso-text: iso-text/Nazarewicz_Michal-CMA.pdf

iso-full/Nazarewicz_Michal-CMA.%: $(RELEASE_BASE).%
	@mkdir -p $(@D)
	ln -f -- $< $@

iso-text/Nazarewicz_Michal-CMA.%: $(RELEASE_BASE).%
	@mkdir -p $(@D)
	ln -f -- $< $@

iso-full: iso-full/linux-3.5.tar.xz iso-full/linux-3.5.tar.bz2 iso-full/linux-3.5.tar.gz

iso-full/linux-3.5.tar.xz:
	@mkdir -p $(@D)
	wget -O $@ http://kernel.org/pub/linux/kernel/v3.0/linux-3.5.tar.xz

iso-full/linux-3.5.tar.bz2: iso-full/linux-3.5.tar.xz
	bzip2 -9 <$< >$@

iso-full/linux-3.5.tar.gz: iso-full/linux-3.5.tar.xz
	gzip -9 <$< >$@

isos: full.iso text.iso

%.iso: iso-%
	mkisofs -o $@ -J -l -r $<


clean:
	exec rm -fr -- build iso-full iso-text

clean-tex:
	exec rm -r -- build/main.*

distclean: clean
	exec rm -f -- cma-bsc.pdf $(RELEASE_BASE)* iso-full.iso iso-text.iso


.PHONY: clean clean-tex distclean
