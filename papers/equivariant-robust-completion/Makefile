export SOURCE_DATE_EPOCH = 1767225600
export FORCE_SOURCE_DATE = 1

TECTONIC ?= nix develop .\#manuscript --command tectonic
SOURCE := equivariant-robust-completion.tex
SOURCE_DEPS := refs.bib sections/*.tex figures/*.tex
LOG := equivariant-robust-completion.log

.PHONY: all check manuscript warnings

all: manuscript

check: manuscript warnings

manuscript: $(SOURCE) $(SOURCE_DEPS)
	$(TECTONIC) $(SOURCE) --keep-logs

warnings: manuscript
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' $(LOG); then \
		exit 1; \
	fi
