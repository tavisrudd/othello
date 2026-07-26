LATEXMK ?= nix shell nixpkgs\#texlive.combined.scheme-full -c latexmk
LATEXMK_FLAGS ?= -xelatex -interaction=nonstopmode -halt-on-error

SOURCES := \
	arcs_complete_outside_conic/arcs_complete_outside_conic.tex \
	clebsch-hexagon-code/clebsch_hexagon_code.tex \
	clebsch-rigidity/clebsch_rigidity.tex \
	clebsch-rigidity/clebsch_rigidity_computational_companion.tex \
	clebsch-factorization/clebsch_factorization.tex \
	clebsch-passages/clebsch_passages.tex \
	coding-repair-hypergraphs/complete_repair_hypergraphs.tex \
	dihedral-schreier-node-kayles/dihedral_schreier_node_kayles.tex \
	equivariant-robust-completion/frobenius_pair_extension.tex

PDFS := $(SOURCES:.tex=.pdf)
LOGS := $(SOURCES:.tex=.log)

.PHONY: all check warnings clean distclean list \
	arcs clebsch clebsch-rigidity clebsch-rigidity-companion clebsch-factorization clebsch-passages \
	dihedral repair-hypergraphs equivariant-completion

all: $(PDFS)

check:
	$(MAKE) -B all
	$(MAKE) warnings

arcs: arcs_complete_outside_conic/arcs_complete_outside_conic.pdf

clebsch: clebsch-hexagon-code/clebsch_hexagon_code.pdf

clebsch-rigidity: clebsch-rigidity/clebsch_rigidity.pdf

clebsch-rigidity-companion: clebsch-rigidity/clebsch_rigidity_computational_companion.pdf

clebsch-factorization: clebsch-factorization/clebsch_factorization.pdf

clebsch-passages: clebsch-passages/clebsch_passages.pdf

dihedral: dihedral-schreier-node-kayles/dihedral_schreier_node_kayles.pdf

repair-hypergraphs: coding-repair-hypergraphs/complete_repair_hypergraphs.pdf

equivariant-completion: equivariant-robust-completion/frobenius_pair_extension.pdf

%.pdf: %.tex
	$(LATEXMK) $(LATEXMK_FLAGS) -cd "$<"

warnings: $(PDFS)
	@status=0; \
	for log in $(LOGS); do \
		if test ! -f "$$log"; then \
			printf 'missing build log: %s\n' "$$log"; \
			status=1; \
		elif grep -En 'Overfull|Underfull|LaTeX Warning|Package .* Warning|undefined references|Citation .* undefined' "$$log"; then \
			status=1; \
		fi; \
	done; \
	exit $$status

list:
	@printf '%s\n' $(PDFS)

clean:
	@for source in $(SOURCES); do \
		$(LATEXMK) -cd -c "$$source"; \
	done

distclean:
	@for source in $(SOURCES); do \
		$(LATEXMK) -cd -C "$$source"; \
	done
