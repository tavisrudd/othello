export SOURCE_DATE_EPOCH = 1767225600
export FORCE_SOURCE_DATE = 1

TEXSHELL ?= nix develop ..\#manuscript --command
LATEXMK ?= $(TEXSHELL) latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
PYTHON ?= nix shell nixpkgs\#python3 -c python3
SOURCE := cubic_gluing_resolvent.tex
JOBNAME := cubic_gluing_resolvent

.PHONY: all check lint evidence manuscript warnings clean distclean

all: check

check: lint evidence manuscript warnings

lint:
	$(PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE)

evidence:
	nix-shell -p 'python3.withPackages (ps: [ ps.sympy ])' --run \
		'python3 verification/resolvent_identities.py --check verification/resolvent-identities.txt'
	$(PYTHON) verification/subgroup_check.py --check verification/subgroup-check.txt
	cd verification && sha256sum --check SHA256SUMS

manuscript: $(SOURCE)
	$(PYTHON) ../scripts/lint_tex_spacing.py $(SOURCE)
	$(LATEXMK) $(LATEXMK_FLAGS) -jobname=$(JOBNAME) $(SOURCE)

warnings: manuscript
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' $(JOBNAME).log; then \
		exit 1; \
	fi

clean:
	$(LATEXMK) -c -jobname=$(JOBNAME) $(SOURCE)

distclean:
	$(LATEXMK) -C -jobname=$(JOBNAME) $(SOURCE)
