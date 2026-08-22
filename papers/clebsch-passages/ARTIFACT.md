# Artifact description

This directory is the source and verification artifact for *Hitchin's
Icosahedral Incidence Double Cover and Operator Realizations of the Clebsch
Cubic*.

The release surface is enumerated in `release_files.json`. It contains the
manuscript source and PDF, the eight-statement identity, the nine-row trust
map, three paper-local exact certificate bundles, and the aggregate runner.
No program in the release surface reads a parent directory or another
repository subtree.

Run the complete gate from this directory:

```text
python3 verification/verify_release.py
```

The gate checks statement and trust-row identity, evidence checksums, an
independent replay for each exact bundle, the release allowlist, and a
warning-free manuscript build. Python 3.11 or later, GNU `sha256sum`, and
the TeX Live environment selected by the local `Makefile` are required.

The arithmetic programs audit the canonical-degree bookkeeping, displayed
icosahedral configurations, their exchanger, and the mod-\(11\) spinor
representative. The incidence degree, geometric identification of the
reduced branch cycle, local normalization comparison, and Clebsch-chart
identity remain human arguments; the branch multiplicity is supplied by the
paper-local ramification calculation rather than attributed to the primary
source. The
orientation-source bundle checks, for the displayed marking, the cover's
scalar factorization, configuration exchanger, conference signs, all six outer
coefficient words, and Petersen
comparison; it does not prove
normalization of the incidence scheme. The separately released Lean artifact
supplies partial structural coverage only: its pinned source map and axiom
report are included in `verification/passages_formal.json` and
`verification/passages_axioms.txt`, while no complete manuscript claim uses
Lean as a proof premise.  The supplemental `ClebschGoldenReturn` map and axiom report
also cover the fixed-conference middle-exterior and commutator-Pfaffian
mechanisms and the three-vertex signed-matrix square used by the operator
theorems.  The current-paper map additionally covers the normalized
aligned-design cut classifier, third-point disambiguation, overlap consistency,
switching transport, determinant identity, and query polynomial.  The
higher-order inclusion/Ramsey classification, classical Ramsey and finite-set
inputs to aligned-design faithfulness, outer-family coherence, oriented
spectral-block determinants, and the classical six-point quotient remain human proof
boundaries.

The author is an independent researcher with no institutional affiliation; this
status, the correspondence address, the ORCID, and the version-independent
finitegeom DOI are recorded in `.zenodo.json`.  The formal companion is named in `FORMAL_COMPANION.json`, which records the
repository, the immutable commit, the gate, the axiom audit and the source
manifest.  That pin is the only place this paper states a companion commit.
The pinned export matches the complete base formal map but not the supplemental
`ClebschGoldenReturn` source map, so submission still requires an immutable release
containing those supplemental sources; no metadata placeholder remains in the
manuscript.
