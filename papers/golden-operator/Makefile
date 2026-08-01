LATEXMK ?= nix shell nixpkgs\#texlive.combined.scheme-full -c latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
SOURCE := golden_operator.tex

.PHONY: all check lint warnings clean distclean

all: lint golden_operator.pdf

check: lint golden_operator.pdf warnings

lint:
	python3 ../scripts/lint_tex_spacing.py $(SOURCE)

golden_operator.pdf: $(SOURCE)
	python3 ../scripts/lint_tex_spacing.py $(SOURCE)
	$(LATEXMK) $(LATEXMK_FLAGS) $(SOURCE)

warnings: golden_operator.pdf
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' golden_operator.log; then \
		exit 1; \
	fi

clean:
	$(LATEXMK) -c $(SOURCE)

distclean:
	$(LATEXMK) -C $(SOURCE)
