LATEX := latex -halt-on-error -file-line-error -output-directory=build

all: cma-inz.pdf

%.pdf: build/%.dvi
	exec dvipdf $<

build/%.dvi: src/%.tex
	@exec mkdir -p build
	exec $(LATEX) $<
	exec $(LATEX) $<

clean:
	exec rm -fr -- build

distclean: clean
	exec rm -f -- cma-inz.pdf
