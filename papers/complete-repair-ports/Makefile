export SOURCE_DATE_EPOCH = 1767225600
export FORCE_SOURCE_DATE = 1

TEXSHELL ?= nix develop .\#manuscript --command
LATEXMK ?= $(TEXSHELL) latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error
SOURCE := complete_repair_ports.tex

.PHONY: all check release update-pdf manuscript warnings clean distclean

all: manuscript

check:
	$(TEXSHELL) python3 verification/verify_release.py

release:
	@test -n "$(COMPLETE_PORTS_LEAN_ROOT)" || { \
		echo "COMPLETE_PORTS_LEAN_ROOT must name the exported finitegeom checkout" >&2; \
		exit 1; \
	}
	$(TEXSHELL) python3 verification/verify_release.py \
		--require-public-formal --lean-root "$(COMPLETE_PORTS_LEAN_ROOT)"

update-pdf:
	$(TEXSHELL) python3 verification/verify_release.py --update-pdf

manuscript: $(SOURCE) refs.bib sections/*.tex figures/*.tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(SOURCE)

warnings: manuscript
	@if grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' complete_repair_ports.log; then \
		exit 1; \
	fi

clean:
	$(LATEXMK) -c $(SOURCE)

distclean:
	$(LATEXMK) -C $(SOURCE)
