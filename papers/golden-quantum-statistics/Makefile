LATEXMK ?= nix shell nixpkgs\#texlive.combined.scheme-full -c latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
UV ?= uv
SOURCE := golden_quantum_statistics.tex

.PHONY: all check lint verify verify-sources warnings clean distclean

all: lint golden_quantum_statistics.pdf

check: lint verify golden_quantum_statistics.pdf warnings

lint:
	python3 ../scripts/lint_tex_spacing.py $(SOURCE)

verify:
	python3 verification/check_imports.py --check

verify-sources:
	$(UV) run python ../../notes/2026-07-31-c715-golden-anomaly-inverse.py --check
	$(UV) run python ../../notes/2026-07-31-c715-golden-anomaly-inverse-replay.py
	$(UV) run python ../../notes/2026-08-01-c718-golden-boson-fermion-complement.py --check
	$(UV) run python ../../notes/2026-08-01-c718-golden-boson-fermion-complement-replay.py
	$(UV) run python ../../notes/2026-08-01-c719-golden-six-mode-demonstrator.py --check
	$(UV) run python ../../notes/2026-08-01-c719-golden-six-mode-demonstrator-replay.py

golden_quantum_statistics.pdf: $(SOURCE)
	python3 ../scripts/lint_tex_spacing.py $(SOURCE)
	$(LATEXMK) $(LATEXMK_FLAGS) $(SOURCE)

warnings: golden_quantum_statistics.pdf
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' golden_quantum_statistics.log; then \
		exit 1; \
	fi

clean:
	$(LATEXMK) -c $(SOURCE)

distclean:
	$(LATEXMK) -C $(SOURCE)
