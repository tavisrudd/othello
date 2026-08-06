# The tracked PDF is byte-reproducible: the pinned epoch fixes the timestamps TeX
# and the PDF writer would otherwise embed, so two builds of one source agree even
# at different filesystem paths.  verification/check_manuscript_build.py compares a
# fresh build against the tracked PDF and is the supported way to refresh it.
export SOURCE_DATE_EPOCH = 1767225600
export FORCE_SOURCE_DATE = 1

# The pinned toolchain: same nixpkgs revision as every other paper, so the tracked
# PDF is reproducible here, in a standalone copy, and on another machine.
TEXSHELL ?= nix develop .\#manuscript --command
LATEXMK ?= $(TEXSHELL) latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
UV ?= uv
SOURCE := golden_quantum_statistics.tex

.PHONY: all check lint manuscript verify verify-sources clean distclean

all: lint golden_quantum_statistics.pdf

check: lint verify verify-sources manuscript

lint:
	python3 verification/lint_tex_spacing.py $(SOURCE)

manuscript:
	$(TEXSHELL) python3 verification/check_manuscript_build.py

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

clean:
	$(LATEXMK) -c $(SOURCE)

distclean:
	$(LATEXMK) -C $(SOURCE)
