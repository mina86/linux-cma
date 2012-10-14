LATEX := latex -halt-on-error -file-line-error -output-directory=build

all: mnazarew_bsc.pdf

mnazarew_bsc.pdf: build/main.dvi
	exec dvipdf $< $@

build/%.dvi: src/%.tex $(wildcard src/*.tex)
	@exec mkdir -p build
	exec $(LATEX) $<
	exec $(LATEX) $<

clean:
	exec rm -fr -- build

distclean: clean
	exec rm -f -- mnazarew_bsc.pdf
