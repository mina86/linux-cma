LATEX := latex -halt-on-error -file-line-error -output-directory=build

all: mnazarew_bsc.pdf


build/deps: find-deps.sh $(wildcard src/*.tex)
	@exec mkdir -p build
	@exec sh $^ >$@

include build/deps


%.pdf: build/%.dvi
	exec dvipdf $< $@


build/mnazarew_bsc.dvi: src/main.tex
build/mnazarew_bsc.dvi: $(wildcard src/*.tex)
build/mnazarew_bsc.dvi: images
build/mnazarew_bsc.dvi:
	@exec mkdir -p build
	exec $(LATEX) $<
	exec $(LATEX) $<
	exec mv -- build/main.dvi $@


images:

build/%.eps: img/%.svg
	@exec mkdir -p build
	exec inkscape -z -D --file=$^ --export-eps=$@

build/%.eps: img/%.dia
	@exec mkdir -p build
	exec dia -l -t eps -e $@ $<

clean:
	exec rm -fr -- build

distclean: clean
	exec rm -f -- mnazarew_bsc.pdf


.PHONY: images clean distclean
