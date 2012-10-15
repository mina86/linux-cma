LATEX := latex -halt-on-error -file-line-error -output-directory=build

all: mnazarew_bsc.pdf

mnazarew_bsc.pdf: build/mnazarew_bsc.dvi
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

build/%.eps: src/%.svg
	@exec mkdir -p build
	exec inkscape -z -D --file=$^ --export-eps=$@

build/%.eps: src/%.eps
	@exec mkdir -p build
	exec cp $< $@

clean:
	exec rm -fr -- build

distclean: clean
	exec rm -f -- mnazarew_bsc.pdf
