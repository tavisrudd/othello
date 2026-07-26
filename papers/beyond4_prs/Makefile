LATEXMK ?= nix shell nixpkgs\#texlive.combined.scheme-full -c latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
TIT_LATEXMK_FLAGS ?= -pdf -interaction=nonstopmode -halt-on-error
PDFINFO ?= nix shell nixpkgs\#poppler-utils -c pdfinfo
SOURCE_DATE_EPOCH ?= 1784886946
export SOURCE_DATE_EPOCH
export FORCE_SOURCE_DATE = 1
TEX_SOURCES := main.tex main-tit.tex $(wildcard frontmatter/*.tex) \
	sections/01-introduction.tex sections/02-overview.tex \
	sections/03-dictionary.tex sections/04-redundancy-five.tex \
	sections/05-polar-induction.tex sections/06-redundancies-six-seven.tex \
	sections/10-verification.tex sections/11-provenance-boundary.tex
PDF_BASENAME := prs-beyond-redundancy-four
PDF := $(PDF_BASENAME).pdf
TIT_PDF_BASENAME := prs-beyond-redundancy-four-tit-submission
TIT_PDF := $(TIT_PDF_BASENAME).pdf

.PHONY: all check tit-check clean

all: $(PDF)

$(PDF): $(TEX_SOURCES) refs.bib
	$(LATEXMK) $(LATEXMK_FLAGS) -jobname=$(PDF_BASENAME) main.tex

check:
	$(LATEXMK) $(LATEXMK_FLAGS) -jobname=$(PDF_BASENAME) main.tex
	@test -f $(PDF_BASENAME).log
	@if grep -En 'Overfull|Underfull|LaTeX (Font )?Warning|Package .* Warning|undefined references|Citation .* undefined' $(PDF_BASENAME).log; then exit 1; fi

tit-check:
	$(LATEXMK) $(TIT_LATEXMK_FLAGS) -jobname=$(TIT_PDF_BASENAME) main-tit.tex
	@test -f $(TIT_PDF_BASENAME).log
	@if grep -En 'Overfull|Underfull|LaTeX (Font )?Warning|Package .* Warning|undefined references|Citation .* undefined' $(TIT_PDF_BASENAME).log; then exit 1; fi
	@pages=$$($(PDFINFO) $(TIT_PDF) | awk '/^Pages:/ {print $$2}'); test "$$pages" -le 50; echo "TIT single-column pages: $$pages / 50"

clean:
	$(LATEXMK) -c -jobname=$(PDF_BASENAME) main.tex
	$(LATEXMK) -c -jobname=$(TIT_PDF_BASENAME) main-tit.tex
