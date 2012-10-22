LATEX	:= latex -halt-on-error -file-line-error -output-directory=build
FAST	?= false

all: cma-lce.pdf


%.pdf: build/%.dvi
	exec dvipdf $< $@


build/cma-lce.dvi: src/main.tex
build/cma-lce.dvi: $(wildcard src/*.tex)
build/cma-lce.dvi: build/iommu-vs-mmu.eps
build/cma-lce.dvi: build/pages.eps
build/cma-lce.dvi: build/alloc-free-cycle.eps
build/cma-lce.dvi: build/question.eps
build/cma-lce.dvi:
	@exec mkdir -p build
	exec $(LATEX) $<
	$FAST || exec $(LATEX) $<
	exec mv -- build/main.dvi $@


build/%.eps: src/%.svg
	@exec mkdir -p build
	exec inkscape -z -C --file=$^ --export-eps=$@

build/%.eps: src/%.eps
	@exec mkdir -p build
	exec cp $< $@


clean:
	exec rm -fr -- build

distclean: clean
	exec rm -f -- cma-lce.pdf
