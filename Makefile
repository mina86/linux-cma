LATEX := latex -halt-on-error -file-line-error -output-directory=build

all: mnazarew_bsc.pdf

mnazarew_bsc.pdf: build/mnazarew_bsc.dvi
	exec dvipdf $< $@

build/mnazarew_bsc.dvi: src/main.tex $(wildcard src/*.tex)
	@exec mkdir -p build
	exec $(LATEX) $<
	exec $(LATEX) $<
	exec mv -- build/main.dvi $@

clean:
	exec rm -fr -- build

distclean: clean
	exec rm -f -- mnazarew_bsc.pdf
