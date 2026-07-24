LATEXMK ?= nix shell nixpkgs\#texlive.combined.scheme-full -c latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error

.PHONY: all check warnings clean

all: main.pdf

main.pdf: main.tex refs.bib
	$(LATEXMK) $(LATEXMK_FLAGS) main.tex

check: main.pdf warnings

warnings: main.log
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' main.log; then exit 1; fi

clean:
	$(LATEXMK) -c main.tex
