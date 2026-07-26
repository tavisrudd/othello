# Section map

`complete_repair_ports.tex` remains the active monolithic driver until C678.
The modular rewrite will use this mathematical dependency order:

1. `01-complete-ports.tex` — support, coefficient, and probability layers;
   reconstruction radius; intrinsic pointed-port isomorphisms; page-2 MDS
   reconstruction.
2. `02-confinement-transfer.tex` — exact pointed obstruction and weighted
   functional transfer.
3. `03-positive-density.tex` — prescribed realization and compact
   MDS/Clebsch/arc/PRS/AME consequences.
4. `04-reliability-exit.tex` — reliability calculus and bounded EXIT.
5. `05-pointed-tutte.tex` — pointed perspective structure and the
   radius-filtration boundary.
6. `06-geometric-flagships.tex` — cubic--axis and
   quartic--nucleus/harmonic applications.
7. `07-verification-provenance.tex` — compact trust map.
8. `08-conclusion.tex` — mathematical synthesis and precise open boundary.

The appendices contain all surviving finite computations, tables,
certificates, and replay descriptions.  They are not dependencies of Sections
1--6.  C678 creates the section files only after C672--C677 have passed their
human-proof and Lean gates.

