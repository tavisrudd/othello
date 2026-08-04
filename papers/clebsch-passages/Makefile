# The tracked PDF is byte-reproducible: the pinned epoch fixes the timestamps TeX
# and the PDF writer would otherwise embed, so two builds of one source agree even
# at different filesystem paths.  verification/check_manuscript_build.py compares a
# fresh build against the tracked PDF and is the supported way to refresh it.
# Prefer `nix develop .#manuscript --command make`, which takes TeX from the shared
# pinned flake rather than the mutable flake registry.
export SOURCE_DATE_EPOCH = 1767225600
export FORCE_SOURCE_DATE = 1

LATEXMK ?= nix develop .\#manuscript --command latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error

.PHONY: all lint clean

all: lint clebsch_passages.pdf

lint:
	python3 ../scripts/lint_tex_spacing.py clebsch_passages.tex sections

clebsch_passages.pdf: clebsch_passages.tex sections/*.tex
	python3 ../scripts/lint_tex_spacing.py clebsch_passages.tex sections
	$(LATEXMK) $(LATEXMK_FLAGS) clebsch_passages.tex

clean:
	$(LATEXMK) -C clebsch_passages.tex
