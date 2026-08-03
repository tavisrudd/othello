LATEXMK ?= nix shell nixpkgs\#texlive.combined.scheme-full -c latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
SOURCE_DATE_EPOCH ?= 1784851200
export SOURCE_DATE_EPOCH
export FORCE_SOURCE_DATE = 1
export TZ = UTC
TEX_SOURCES := main.tex $(wildcard sections/*.tex) $(wildcard figures/*.tex) $(wildcard appendices/*.tex)
PDF_BASENAME := mds-css-transversal-groups
PDF := $(PDF_BASENAME).pdf
LINT_TEX := python3 scripts/lint_tex_spacing.py

.PHONY: all check lint evidence release-check clean

all: lint $(PDF)

lint:
	$(LINT_TEX) $(TEX_SOURCES)

$(PDF): $(TEX_SOURCES) refs.bib
	$(LINT_TEX) $(TEX_SOURCES)
	$(LATEXMK) $(LATEXMK_FLAGS) -jobname=$(PDF_BASENAME) main.tex

evidence:
	python3 supplement/verify.py

check: evidence lint
	$(LINT_TEX) $(TEX_SOURCES)
	$(LATEXMK) $(LATEXMK_FLAGS) -jobname=$(PDF_BASENAME) main.tex
	@test -f $(PDF_BASENAME).log
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' $(PDF_BASENAME).log; then exit 1; fi

release-check: check
	python3 supplement/verify.py --replay
	python3 release/verify_release.py --require-formal

clean:
	$(LATEXMK) -c -jobname=$(PDF_BASENAME) main.tex
