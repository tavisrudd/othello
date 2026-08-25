export SOURCE_DATE_EPOCH = 1787875200
export FORCE_SOURCE_DATE = 1

TEXSHELL ?= nix develop ..\#manuscript --command
LATEXMK ?= $(TEXSHELL) latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
PYTHON ?= uv run --with sympy==1.14.0 python3
LINT_PYTHON ?= nix shell nixpkgs\#python3 -c python3
SOURCE := cubic_stabilization_irrationality.tex

.PHONY: all check lint verify manuscript warnings clean distclean

all: lint verify manuscript

check: lint verify manuscript warnings

lint:
	$(LINT_PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE)

verify:
	$(PYTHON) verification/derive_slice_cover.py \
		--check-certificate verification/slice-cover-certificate.json \
		--check-empty-certificates verification/groebner-empty-certificates.json \
		--check-tex-artifact verification/slice-cover-values.tex
	$(PYTHON) verification/check_slice_cover.py \
		--check-certificate verification/slice-cover-certificate.json \
		--check-empty-certificates verification/groebner-empty-certificates.json
	$(LINT_PYTHON) verification/check_metadata.py

manuscript: $(SOURCE) formal-annotations.tex verification/slice-cover-values.tex
	$(LINT_PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE)
	$(LATEXMK) $(LATEXMK_FLAGS) $(SOURCE)

warnings: manuscript
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' cubic_stabilization_irrationality.log; then \
		exit 1; \
	fi

clean:
	$(LATEXMK) -c $(SOURCE)

distclean:
	$(LATEXMK) -C $(SOURCE)
