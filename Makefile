LATEX := latex -halt-on-error -file-line-error -output-directory=build

TEXINPUTS := .:./llncs:
BIBINPUTS := .:./llncs:
export TEXINPUTS
export BIBINPUTS


all: cma-sdi-paper.pdf


build/deps: find-deps.sh $(wildcard src/*.tex)
	@exec mkdir -p build
	@DEPS_TARGET=build/cma-sdi-paper.dvi exec sh $^ >$@

build/cma-sdi-paper.dvi: src/main.tex
build/cma-sdi-paper.dvi: $(wildcard src/*.*)

include build/deps


%.pdf: build/%.dvi
	exec dvipdf $< $@


build/cma-sdi-paper.dvi:
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

clean:
	exec rm -fr -- build

clean-tex:
	exec rm -r -- build/main.*

distclean: clean
	exec rm -f -- cma-sdi-paper.pdf


.PHONY: clean clean-tex distclean
