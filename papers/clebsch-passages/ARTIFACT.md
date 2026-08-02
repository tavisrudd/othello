# Artifact description

This directory is the source and verification artifact for *Golden descent
and operator realizations of the Clebsch cubic*.

The release surface is enumerated in `release_files.json`. It contains the
manuscript source and PDF, the six-statement identity, the seven-row trust
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
mechanisms used by the operator theorem; outer-family coherence,
cross-golden determinants, and the classical six-point quotient remain human
proof boundaries.

An immutable public identifier and the author's affiliation/contact line
are external submission metadata and are not represented by placeholders
in the manuscript.
