# Preview build for the Clebsch-series figure set.  The pinned epoch and the
# shared flake keep the build reproducible for the same reasons as the
# manuscripts: TeX would otherwise embed a wall clock and a floating engine
# version.  Prefer `nix develop .#manuscript --command make`, which takes TeX
# from the pinned flake rather than the mutable registry.
export SOURCE_DATE_EPOCH = 1767225600
export FORCE_SOURCE_DATE = 1

# `path:.` rather than `.` so the directory builds before its files are
# tracked by Git; once they are tracked either form works.
LATEXMK ?= nix develop path:.\#manuscript --command latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error

FIGURES = $(wildcard fig-d*.tex)

.PHONY: all lint clean

all: lint series-figures.pdf

lint:
	python3 ../scripts/lint_tex_spacing.py series-figures.tex $(FIGURES) \
	  series-figures-preamble.tex

series-figures.pdf: series-figures.tex series-figures-preamble.tex $(FIGURES)
	$(LATEXMK) $(LATEXMK_FLAGS) series-figures.tex

clean:
	$(LATEXMK) -C series-figures.tex
