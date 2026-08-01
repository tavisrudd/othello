LATEXMK ?= nix shell nixpkgs\#texlive.combined.scheme-full -c latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error

.PHONY: all lint clean

all: lint clebsch_passages.pdf

lint:
	python3 ../scripts/lint_tex_spacing.py clebsch_passages.tex sections

clebsch_passages.pdf: clebsch_passages.tex sections/*.tex
	python3 ../scripts/lint_tex_spacing.py clebsch_passages.tex sections
	$(LATEXMK) $(LATEXMK_FLAGS) clebsch_passages.tex

clean:
	$(LATEXMK) -C clebsch_passages.tex
