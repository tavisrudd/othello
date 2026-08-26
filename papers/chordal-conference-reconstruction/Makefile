export SOURCE_DATE_EPOCH = 1767225600
export FORCE_SOURCE_DATE = 1

TEXSHELL ?= nix develop ..\#manuscript --command
LATEXMK ?= $(TEXSHELL) latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
PYTHON ?= nix shell nixpkgs\#python3 -c python3
SOURCE := chordal_conference_reconstruction.tex

.PHONY: all check evidence lint manuscript warnings clean distclean

all: lint manuscript

check: evidence lint manuscript warnings

evidence:
	$(PYTHON) verification/evidence/paper_ii_chordal_axis.py --check
	$(PYTHON) verification/evidence/conference_node_completeness.py --check
	$(PYTHON) verification/evidence/determinantal_presentation.py --check
	$(PYTHON) verification/generate_sparse_shadow_export.py --check verification/evidence/sparse_shadow_export.json

lint:
	$(PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE)

manuscript: $(SOURCE)
	$(PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE)
	$(LATEXMK) $(LATEXMK_FLAGS) $(SOURCE)

warnings: manuscript
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' chordal_conference_reconstruction.log; then \
		exit 1; \
	fi

clean:
	$(LATEXMK) -c $(SOURCE)

distclean:
	$(LATEXMK) -C $(SOURCE)
