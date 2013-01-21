LATEX := latex -halt-on-error -file-line-error -output-directory=build

TEXINPUTS := .:$(HOME)/bsc/:
export TEXINPUTS

all: mnazarew_bsc.pdf


build/deps: find-deps.sh $(wildcard src/*.tex)
	@exec mkdir -p build
	@DEPS_TARGET=build/mnazarew_bsc.dvi exec sh $^ >$@

build/mnazarew_bsc.dvi: src/main.tex
build/mnazarew_bsc.dvi: $(wildcard src/*.*)

-include build/deps


%.pdf: build/%.dvi
	exec dvipdf $< $@


build/mnazarew_bsc.dvi:
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


clean:
	exec rm -fr -- build

clean-tex:
	exec rm -r -- build/main.*

distclean: clean
	exec rm -f -- mnazarew_bsc.pdf


.PHONY: clean clean-tex distclean
