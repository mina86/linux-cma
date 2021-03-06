LATEX	:= latex -halt-on-error -file-line-error -output-directory=build
FAST	?= false

all: cma-lce.pdf


build/deps: find-deps.sh $(wildcard src/*.tex)
	@exec mkdir -p build
	@DEPS_TARGET=build/cma-lce.dvi exec sh $^ >$@

build/cma-lce.dvi: src/main.tex
build/cma-lce.dvi: $(wildcard src/*.tex)

include build/deps


%.pdf: build/%.dvi
	exec dvipdf $< $@

build/cma-lce.dvi:
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


clean:
	exec rm -fr -- build

clean-tex:
	exec rm -r -- build/main.*

distclean: clean
	exec rm -f -- cma-lce.pdf


.PHONY: clean clean-tex distclean
