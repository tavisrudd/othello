LATEXMK ?= nix shell nixpkgs\#texlive.combined.scheme-full -c latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
TEX_SOURCES := main.tex $(wildcard sections/*.tex) $(wildcard appendices/*.tex)

.PHONY: all check clean

all: main.pdf

main.pdf: $(TEX_SOURCES) refs.bib
	$(LATEXMK) $(LATEXMK_FLAGS) main.tex

check:
	$(LATEXMK) $(LATEXMK_FLAGS) main.tex
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' main.log; then exit 1; fi

clean:
	$(LATEXMK) -c main.tex
