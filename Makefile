PDFLATEX := pdflatex -halt-on-error -file-line-error -output-directory=build

all: mnazarew_bsc.pdf

mnazarew_bsc.pdf: build/main.pdf
	exec cat <$< >$@

build/%.pdf: src/%.tex $(wildcard src/*.tex)
	@exec mkdir -p build
	exec $(PDFLATEX) $<
	exec $(PDFLATEX) $<

clean:
	exec rm -fr -- build

distclean: clean
	exec rm -f -- mnazarew_bsc.pdf
