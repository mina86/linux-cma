LATEX	:= latex -halt-on-error -file-line-error -output-directory=build
FAST	?= false

all: cma-sdi.pdf


build/deps: find-deps.sh $(wildcard src/*.tex)
	@exec mkdir -p build
	@exec sh $^ >$@

include build/deps


%.pdf: build/%.dvi
	exec dvipdf $< $@

build/cma-sdi.dvi: src/main.tex
build/cma-sdi.dvi: $(wildcard src/*.tex)
build/cma-sdi.dvi: images
build/cma-sdi.dvi:
	@exec mkdir -p build
	exec $(LATEX) $<
	$FAST || exec $(LATEX) $<
	exec mv -- build/main.dvi $@


images:

build/%.eps: img/%.svg
	@exec mkdir -p build
	exec inkscape -z -C --file=$^ --export-eps=$@

build/%.eps: img/%.dia
	@exec mkdir -p build
	exec dia -l -t eps -e $@ $<

build/%.eps: img/%.eps
	@exec mkdir -p build
	exec ln -sf -- ../$< $@


clean:
	exec rm -fr -- build

distclean: clean
	exec rm -f -- cma-sdi.pdf


.PHONY: images clean distclean
