# Quadratic recovery and cubic orientation in conic matching quotients

This directory contains the manuscript
*Quadratic recovery and cubic orientation in conic matching quotients*.

The paper studies matching products modulo a conic ideal, their quotient
ranks `3,6,10`, completeness of quadratic recovery under the
one-factorization hypothesis, cubic orientation, and self-associated
arithmetically Gorenstein evaluation sets. Appendices
record six-profile reconstruction, modular depth, arithmetic splitting,
and further `H_3` cubic structure.

## Files

- `clebsch_factorization.tex`: manuscript source.
- `clebsch_factorization.pdf`: rebuilt review PDF.
- `verification/statement_identity.json`: exact identity of all twenty-four
  theorem-like statements.
- `verification/trust_manifest.json`: proof-mode and evidence mapping.
- `verification/evidence_fingerprint.json`: normalized review-source and
  environment fingerprint.
- `verification/verify_release.py`: aggregate local verification entry point.

## Verification

From the repository root, run:

```text
python3 papers/clebsch-factorization/verification/verify_release.py
```

The aggregate checks statement identity, exact trust-ledger coverage,
checksum manifests, primary certificates and independent replays, the
arithmetic-gluing, Hilbert-symmetry, and hyperplane-square Lean gates, the
PDF build, and a manuscript-warning scan.
The formal and computational trust boundaries are described in the manuscript
and in `verification/README.md`.

An immutable public source-and-evidence archive locator remains required
before publication.
