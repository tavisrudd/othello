export SOURCE_DATE_EPOCH = 1767225600
export FORCE_SOURCE_DATE = 1

TEXSHELL ?= nix develop ..\#manuscript --command
LATEXMK ?= $(TEXSHELL) latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
PYTHON ?= nix shell nixpkgs\#python3 -c python3
SOURCE := cubic_stabilization_m1.tex
JOBNAME := irrationality_after_one_stabilization

.PHONY: all check lint formal-static formal-audit manuscript warnings clean distclean

all: lint manuscript

check: lint formal-static manuscript warnings

lint:
	$(PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE) sections/*.tex

formal-static:
	$(PYTHON) lean/verification/check_formal_artifact.py --source-only

formal-audit:
	@test -n "$(AXIOM_LOG)" || { echo "AXIOM_LOG must name captured AxiomAudit stdout" >&2; exit 2; }
	$(PYTHON) lean/verification/check_formal_artifact.py --axiom-log "$(AXIOM_LOG)"

manuscript: $(SOURCE) sections/*.tex
	$(PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE) sections/*.tex
	$(LATEXMK) $(LATEXMK_FLAGS) -jobname=$(JOBNAME) $(SOURCE)

warnings: manuscript
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' $(JOBNAME).log; then \
		exit 1; \
	fi

clean:
	$(LATEXMK) -c -jobname=$(JOBNAME) $(SOURCE)

distclean:
	$(LATEXMK) -C -jobname=$(JOBNAME) $(SOURCE)
