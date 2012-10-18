LATEX := latex -halt-on-error -file-line-error -output-directory=build

all: cma-lce.pdf


%.pdf: build/%.dvi
	exec dvipdf $< $@


build/cma-lce.dvi: src/main.tex
build/cma-lce.dvi: $(wildcard src/*.tex)
build/cma-lce.dvi:
	@exec mkdir -p build
	exec $(LATEX) $<
	exec $(LATEX) $<
	exec mv -- build/main.dvi $@


clean:
	exec rm -fr -- build

distclean: clean
	exec rm -f -- cma-lce.pdf
