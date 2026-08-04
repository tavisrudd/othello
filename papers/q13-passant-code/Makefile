# The tracked PDF is byte-reproducible: the pinned epoch fixes the timestamps TeX
# and the PDF writer would otherwise embed, so two builds of one source agree even
# at different filesystem paths.  verification/check_manuscript_build.py compares a
# fresh build against the tracked PDF and is the supported way to refresh it.
export SOURCE_DATE_EPOCH = 1767225600
export FORCE_SOURCE_DATE = 1

# The pinned toolchain: same nixpkgs revision as every other paper, so the tracked
# PDF is reproducible here, in a standalone mirror, and on another machine.
TEXSHELL ?= nix develop .\#manuscript --command
LATEXMK ?= $(TEXSHELL) latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
SOURCE := passant_code_q13.tex

.PHONY: all check evidence lean lint manuscript warnings clean distclean

all: lint passant_code_q13.pdf

check: evidence lean lint manuscript

evidence:
	python3 verification/verify_evidence.py

lean:
	cd lean-certificates && nix develop --command lake build \
		PassantCodeQ13.Gates.Main PassantCodeQ13.Gates.AxiomAudit

lint:
	python3 ../scripts/lint_tex_spacing.py $(SOURCE)

passant_code_q13.pdf: $(SOURCE)
	python3 ../scripts/lint_tex_spacing.py $(SOURCE)
	$(LATEXMK) $(LATEXMK_FLAGS) $(SOURCE)

manuscript:
	$(TEXSHELL) python3 verification/check_manuscript_build.py

warnings: passant_code_q13.pdf
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' passant_code_q13.log; then \
		exit 1; \
	fi

clean:
	$(LATEXMK) -c $(SOURCE)

distclean:
	$(LATEXMK) -C $(SOURCE)
