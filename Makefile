LATEX	:= latex -halt-on-error -file-line-error -output-directory=build
FAST	?= false

all: cma-sdi.pdf


build/deps: find-deps.sh $(wildcard src/*.tex)
	@exec mkdir -p build
	@DEPS_TARGET=build/cma-sdi.dvi exec sh $^ >$@

build/cma-sdi.dvi: src/main.tex
build/cma-sdi.dvi: $(wildcard src/*.tex)

-include build/deps


%.pdf: build/%.dvi
	exec dvipdf $< $@

build/cma-sdi.dvi:
	@exec mkdir -p build
	exec $(LATEX) $<
	$FAST || exec $(LATEX) $<
	exec mv -- build/main.dvi $@


build/%.eps: img/%.svg
	@exec mkdir -p build
	exec inkscape -z -C --file=$^ --export-eps=$@

build/%.eps: img/%.dia
	@exec mkdir -p build
	exec dia -l -t eps -e $@ $<

build/%.eps: img/%.eps
	@exec mkdir -p build
	exec ln -sf -- ../$< $@


RELEASE_TYPE	:= prezentacja
RELEASE_BASE	:= Nazarewicz_Michal-CMA-$(RELEASE_TYPE)
release: $(RELEASE_BASE).pdf $(RELEASE_BASE).zip $(RELEASE_BASE).tar.bz2
release: $(RELEASE_BASE).tar.gz $(RELEASE_BASE).tar.xz

$(RELEASE_BASE).pdf: cma-sdi.pdf
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


clean:
	exec rm -fr -- build

clean-tex:
	exec rm -r -- build/main.*

distclean: clean
	exec rm -f -- cma-sdi.pdf


.PHONY: clean clean-tex distclean
