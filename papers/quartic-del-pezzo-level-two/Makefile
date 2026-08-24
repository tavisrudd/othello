export SOURCE_DATE_EPOCH = 1787875200
export FORCE_SOURCE_DATE = 1

TEXSHELL ?= nix develop ..\#manuscript --command
LATEXMK ?= $(TEXSHELL) latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
PYTHON ?= uv run --with sympy==1.14.0 python3
LINT_PYTHON ?= nix shell nixpkgs\#python3 -c python3
SOURCE := quartic_del_pezzo_level_two.tex

.PHONY: all check lint verify manuscript warnings clean distclean

all: lint verify manuscript

check: lint verify manuscript warnings

lint:
	$(LINT_PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE)

verify:
	$(PYTHON) verification/check_slice_cover.py \
		--check-certificate verification/slice-cover-certificate.json
	$(LINT_PYTHON) verification/check_metadata.py

manuscript: $(SOURCE) formal-annotations.tex
	$(LINT_PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE)
	$(LATEXMK) $(LATEXMK_FLAGS) $(SOURCE)

warnings: manuscript
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' quartic_del_pezzo_level_two.log; then \
		exit 1; \
	fi

clean:
	$(LATEXMK) -c $(SOURCE)

distclean:
	$(LATEXMK) -C $(SOURCE)
