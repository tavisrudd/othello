LATEXMK ?= nix shell nixpkgs\#texlive.combined.scheme-full -c latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
TEX_SOURCES := main.tex $(wildcard sections/*.tex) $(wildcard appendices/*.tex)
PDF_BASENAME := prs-beyond-redundancy-four
PDF := $(PDF_BASENAME).pdf

.PHONY: all check clean

all: $(PDF)

$(PDF): $(TEX_SOURCES) refs.bib
	$(LATEXMK) $(LATEXMK_FLAGS) -jobname=$(PDF_BASENAME) main.tex

check:
	$(LATEXMK) $(LATEXMK_FLAGS) -jobname=$(PDF_BASENAME) main.tex
	@test -f $(PDF_BASENAME).log
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' $(PDF_BASENAME).log; then exit 1; fi

clean:
	$(LATEXMK) -c -jobname=$(PDF_BASENAME) main.tex
