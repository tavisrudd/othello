LATEXMK ?= nix shell nixpkgs\#texlive.combined.scheme-full -c latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
TIT_LATEXMK_FLAGS ?= -pdf -interaction=nonstopmode -halt-on-error
PDFINFO ?= nix shell nixpkgs\#poppler-utils -c pdfinfo
CARGO ?= cargo
SOFTWARE_MANIFEST := software/projective-reed-solomon/Cargo.toml
SOURCE_DATE_EPOCH ?= 1784886946
export SOURCE_DATE_EPOCH
export FORCE_SOURCE_DATE = 1
TEX_SOURCES := high-weight-grs-cosets.tex high-weight-grs-cosets-tit.tex formal-annotations.tex $(wildcard frontmatter/*.tex) \
	sections/01-introduction.tex sections/02-results-map.tex sections/02-overview.tex \
	sections/03-dictionary.tex sections/04-redundancy-five.tex \
	sections/05-simultaneous-contraction.tex sections/05-polar-induction.tex \
	sections/05-polar-tit-interface.tex \
	sections/06-high-weight-cosets.tex sections/06-redundancies-six-seven.tex \
	sections/07-recursive-carriers.tex \
	sections/08-fixed-level-roadmap.tex \
	supplement/companion-source/07-fixed-level-eight-nine.tex \
	supplement/companion-source/09-lucas-carriers.tex \
	sections/10-verification.tex sections/11-provenance-boundary.tex \
	supplement/companion-source/r9-slice-data.tex
PDF_BASENAME := high-weight-grs-cosets
PDF := $(PDF_BASENAME).pdf
TIT_PDF_BASENAME := high-weight-grs-cosets-tit
TIT_PDF := $(TIT_PDF_BASENAME).pdf

.PHONY: all check lint tit-check software-check software-slow-check \
	software-gf16-check \
	supplement-check release-check clean

all: lint $(PDF)

lint:
	python3 supplement/lint_tex_spacing.py $(TEX_SOURCES)
	python3 verification/check_abstract.py
	python3 verification/check_annotations.py

$(PDF): $(TEX_SOURCES) refs.bib
	python3 supplement/lint_tex_spacing.py $(TEX_SOURCES)
	$(LATEXMK) $(LATEXMK_FLAGS) -jobname=$(PDF_BASENAME) high-weight-grs-cosets.tex

check: lint
	python3 supplement/lint_tex_spacing.py $(TEX_SOURCES)
	$(LATEXMK) $(LATEXMK_FLAGS) -jobname=$(PDF_BASENAME) high-weight-grs-cosets.tex
	@test -f $(PDF_BASENAME).log
	@if grep -En 'Overfull|Underfull|LaTeX (Font )?Warning|Package .* Warning|undefined references|Citation .* undefined' $(PDF_BASENAME).log; then exit 1; fi

tit-check: lint
	python3 supplement/lint_tex_spacing.py $(TEX_SOURCES)
	$(LATEXMK) $(TIT_LATEXMK_FLAGS) -jobname=$(TIT_PDF_BASENAME) high-weight-grs-cosets-tit.tex
	@test -f $(TIT_PDF_BASENAME).log
	@if grep -En 'Overfull|Underfull|LaTeX (Font )?Warning|Package .* Warning|undefined references|Citation .* undefined' $(TIT_PDF_BASENAME).log; then exit 1; fi
	@pages=$$($(PDFINFO) $(TIT_PDF) | awk '/^Pages:/ {print $$2}'); echo "TIT single-column pages: $$pages / target < 50"; test "$$pages" -lt 50

software-check:
	$(CARGO) fmt --manifest-path $(SOFTWARE_MANIFEST) --all -- --check
	$(CARGO) clippy --locked --manifest-path $(SOFTWARE_MANIFEST) --all-targets -- -D warnings
	$(CARGO) test --locked --manifest-path $(SOFTWARE_MANIFEST)

software-slow-check:
	$(CARGO) test --locked --release --manifest-path $(SOFTWARE_MANIFEST) -- --ignored --skip structural_canonicalization_extends_to_gf16_r11

software-gf16-check:
	$(CARGO) test --locked --release --manifest-path $(SOFTWARE_MANIFEST) tests::structural_canonicalization_extends_to_gf16_r11 -- --ignored --exact

supplement-check:
	python3 supplement/verify.py

release-check: check tit-check software-check software-slow-check software-gf16-check supplement-check

clean:
	$(LATEXMK) -c -jobname=$(PDF_BASENAME) high-weight-grs-cosets.tex
	$(LATEXMK) -c -jobname=$(TIT_PDF_BASENAME) high-weight-grs-cosets-tit.tex
