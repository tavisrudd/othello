# Quadratic trade rigidity and cubic orientation in conic matching quotients

**Series:** *The Clebsch cubic: recovering, orienting, and realizing --- II*

The shared progression is expository; this manuscript is logically
independent of the other two.

This directory contains the manuscript
*Quadratic trade rigidity and cubic orientation in conic matching quotients*.

The paper studies matching products modulo a conic ideal, their quotient
ranks `3,6,10`, uniform classification from an intrinsic two-valued
quadratic trade, edge-selected alternating-cycle radial nonvanishing,
cubic orientation, and self-associated arithmetically Gorenstein
evaluation sets. Appendices
record six-profile reconstruction, modular depth, arithmetic splitting,
and further `H_3` cubic structure.

## Files

- `clebsch_factorization.tex`: manuscript source.
- `clebsch_factorization.pdf`: rebuilt review PDF.
- `verification/statement_identity.json`: exact identity of every
  theorem-like statement.
- `verification/trust_manifest.json`: proof-mode and evidence mapping.
- `verification/evidence_fingerprint.json`: normalized review-source and
  environment fingerprint.
- `verification/verify_release.py`: aggregate local verification entry point.

## Verification

From the repository root, run:

```text
python3 verification/verify_release.py
```

The aggregate checks statement identity, exact trust-ledger coverage,
checksum manifests, primary certificates and independent replays, the
generic first-wall and shared-radial bundles, the arithmetic-gluing and
hyperplane-square Lean gates, the PDF build, and a manuscript-warning scan.
The formal and computational trust boundaries are described in the manuscript
and in `verification/README.md`.

The separately distributed formal companion has the version-independent
Zenodo concept DOI
[`10.5281/zenodo.21650878`](https://doi.org/10.5281/zenodo.21650878).
