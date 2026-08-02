LATEXMK ?= nix shell nixpkgs\#texlive.combined.scheme-full -c latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
SOURCE := golden_quantum_statistics.tex

.PHONY: all check lint warnings clean distclean

all: lint golden_quantum_statistics.pdf

check: lint golden_quantum_statistics.pdf warnings

lint:
	python3 ../scripts/lint_tex_spacing.py $(SOURCE)

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
