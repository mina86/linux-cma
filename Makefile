LATEX	:= latex -halt-on-error -file-line-error -output-directory=build
FAST	?= false

all: cma-lce.pdf


build/deps: find-deps.sh $(wildcard src/*.tex)
	@exec mkdir -p build
	@exec sh $^ >$@

include build/deps


%.pdf: build/%.dvi
	exec dvipdf $< $@

build/cma-lce.dvi: src/main.tex
build/cma-lce.dvi: $(wildcard src/*.tex)
build/cma-lce.dvi: images
build/cma-lce.dvi:
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
	exec cp $< $@


clean:
	exec rm -fr -- build

distclean: clean
	exec rm -f -- cma-lce.pdf


.PHONY: images clean distclean
