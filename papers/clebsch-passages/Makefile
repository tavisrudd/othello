LATEXMK ?= nix shell nixpkgs\#texlive.combined.scheme-full -c latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error

.PHONY: all clean

all: clebsch_passages.pdf

clebsch_passages.pdf: clebsch_passages.tex sections/*.tex
	$(LATEXMK) $(LATEXMK_FLAGS) clebsch_passages.tex

clean:
	$(LATEXMK) -C clebsch_passages.tex
