# Artifact description

This directory is the source and verification artifact for *Arithmetic and
harmonic realizations of the Clebsch cubic*.

The release surface is enumerated in `release_files.json`. It contains the
manuscript source and PDF, the four-statement identity, the four-row trust
map, two paper-local exact certificate bundles, and the aggregate runner.
No program in the release surface reads a parent directory or another
repository subtree.

Run the complete gate from this directory:

```text
python3 verification/verify_release.py
```

The gate checks statement and trust-row identity, evidence checksums, two
independent replays for each exact bundle, the release allowlist, and a
warning-free manuscript build. Python 3.11 or later, GNU `sha256sum`, and
the TeX Live environment selected by the local `Makefile` are required.

The arithmetic programs audit only the displayed golden configurations,
their exchanger, and the mod-\(11\) spinor representative. The incidence
degree, branch divisor, local normalization comparison, and Clebsch-chart
identity remain human arguments using the cited primary sources. No Lean
coverage is claimed.

An immutable public identifier and the author's affiliation/contact line
are external submission metadata and are not represented by placeholders
in the manuscript.
