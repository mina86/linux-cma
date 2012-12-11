LATEX := latex -halt-on-error -file-line-error -output-directory=build

all: mnazarew_bsc.pdf

%.pdf: build/%.dvi
	exec dvipdf $< $@

build/mnazarew_bsc.dvi: src/main.tex
build/mnazarew_bsc.dvi: $(wildcard src/*.tex)
build/mnazarew_bsc.dvi: build/alloc-free-cycle.eps
build/mnazarew_bsc.dvi: build/pages.eps
build/mnazarew_bsc.dvi:
	@exec mkdir -p build
	exec $(LATEX) $<
	exec $(LATEX) $<
	exec mv -- build/main.dvi $@

build/%.eps: img/%.svg
	@exec mkdir -p build
	exec inkscape -z -D --file=$^ --export-eps=$@

build/%.eps: img/%.eps
	@exec mkdir -p build
	exec cp $< $@

clean:
	exec rm -fr -- build

distclean: clean
	exec rm -f -- mnazarew_bsc.pdf
