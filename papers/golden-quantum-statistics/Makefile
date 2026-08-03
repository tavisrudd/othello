LATEXMK ?= nix shell nixpkgs\#texlive.combined.scheme-full -c latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
UV ?= uv
SOURCE := golden_quantum_statistics.tex

.PHONY: all check lint verify verify-sources warnings clean distclean

all: lint golden_quantum_statistics.pdf

check: lint verify verify-sources golden_quantum_statistics.pdf warnings

lint:
	python3 verification/lint_tex_spacing.py $(SOURCE)

verify:
	python3 verification/verify.py --check

verify-sources:
	$(UV) run --frozen python verification/evidence/anomaly_inverse.py --check
	$(UV) run --frozen python verification/evidence/anomaly_inverse_replay.py
	$(UV) run --frozen python verification/evidence/boson_fermion_complement.py --check
	$(UV) run --frozen python verification/evidence/boson_fermion_complement_replay.py
	$(UV) run --frozen python verification/evidence/six_mode_demonstrator.py --check
	$(UV) run --frozen python verification/evidence/six_mode_demonstrator_replay.py

golden_quantum_statistics.pdf: $(SOURCE)
	python3 verification/lint_tex_spacing.py $(SOURCE)
	$(LATEXMK) $(LATEXMK_FLAGS) $(SOURCE)

warnings: golden_quantum_statistics.pdf
	@if [ ! -f golden_quantum_statistics.log ]; then \
		$(LATEXMK) -g $(LATEXMK_FLAGS) $(SOURCE); \
	fi
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' golden_quantum_statistics.log; then \
		exit 1; \
	fi

clean:
	$(LATEXMK) -c $(SOURCE)

distclean:
	$(LATEXMK) -C $(SOURCE)
