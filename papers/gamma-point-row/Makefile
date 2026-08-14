export SOURCE_DATE_EPOCH = 1785888000
export FORCE_SOURCE_DATE = 1

TEXSHELL ?= nix develop ..\#manuscript --command
LATEXMK ?= $(TEXSHELL) latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
PYTHON ?= nix shell nixpkgs\#python3 -c python3
SOURCE := gamma_point_row.tex

.PHONY: all check evidence lint manuscript warnings clean distclean

all: lint manuscript

check: evidence lint manuscript warnings

evidence:
	$(PYTHON) verification/check_release_surface.py
	$(PYTHON) verification/check_cubic_endpoint.py --check

lint:
	$(PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE) sections/*.tex

manuscript: $(SOURCE) sections/*.tex refs.bib
	$(PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE) sections/*.tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(SOURCE)

warnings: manuscript
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' gamma_point_row.log; then \
		exit 1; \
	fi

clean:
	$(LATEXMK) -c $(SOURCE)

distclean:
	$(LATEXMK) -C $(SOURCE)
