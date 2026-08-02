# Artifact description

This directory is the source and verification artifact for *Golden descent
and operator realizations of the Clebsch cubic*.

The release surface is enumerated in `release_files.json`. It contains the
manuscript source and PDF, the seven-statement identity, the eight-row trust
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

The arithmetic programs audit only the displayed golden configurations,
their exchanger, and the mod-\(11\) spinor representative. The incidence
degree, branch divisor, local normalization comparison, and Clebsch-chart
identity remain human arguments using the cited primary sources. The
orientation-source bundle checks, for the displayed marking, the cover's
scalar factorization, golden involution, conference signs, and Petersen
comparison; it does not prove
normalization of the incidence scheme. The separately released Lean artifact
supplies partial structural coverage only: its pinned source map and axiom
report are included in `verification/passages_formal.json` and
`verification/passages_axioms.txt`, while no complete manuscript claim uses
Lean as a proof premise.  The supplemental golden-return map and axiom report
also cover the fixed-conference middle-exterior and commutator-Pfaffian
mechanisms and the three-vertex signed-matrix square used by the operator
theorems; the higher-order inclusion/Ramsey classification, outer-family coherence,
cross-golden determinants, and the classical six-point quotient remain human
proof boundaries.

The author is an independent researcher with no institutional affiliation; this
status, the correspondence address, the ORCID, and the version-independent
finitegeom DOI are recorded in `.zenodo.json`.  Public finitegeom commit
`f1d81641827fd037fcbd8363a6f9cd5abf3767cf` matches the complete base formal
map, but not the supplemental golden-return source map.  Submission therefore
still requires an immutable finitegeom release containing those supplemental
sources; no metadata placeholder remains in the manuscript.
