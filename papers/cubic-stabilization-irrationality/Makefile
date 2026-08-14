export SOURCE_DATE_EPOCH = 1785888000
export FORCE_SOURCE_DATE = 1

# The tracked PDF is byte-reproducible.  The isolated-build check below makes
# source/PDF staleness an exact failure instead of trusting latexmk's local
# auxiliary-file state.  Use `make manuscript-update` to refresh the PDF from
# the same clean deterministic build used by the release gate.

TEXSHELL ?= nix develop ..\#manuscript --command
LATEXMK ?= $(TEXSHELL) latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
PYTHON ?= nix shell nixpkgs\#python3 -c python3
SOURCE := cubic_stabilization_irrationality.tex

.PHONY: all check evidence lint manuscript warnings manuscript-check manuscript-update clean distclean

all: evidence lint manuscript-check

check: evidence lint manuscript-check

evidence:
	$(PYTHON) verification/check_release_surface.py
	$(PYTHON) verification/check_cubic_endpoint.py --check

lint:
	$(PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE) sections/*.tex

manuscript: $(SOURCE) sections/*.tex refs.bib
	$(PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE) sections/*.tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(SOURCE)

warnings: manuscript
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' cubic_stabilization_irrationality.log; then \
		exit 1; \
	fi

manuscript-check:
	$(TEXSHELL) python3 verification/check_manuscript_build.py

manuscript-update:
	$(TEXSHELL) python3 verification/check_manuscript_build.py --update

clean:
	$(LATEXMK) -c $(SOURCE)

distclean:
	$(LATEXMK) -C $(SOURCE)
