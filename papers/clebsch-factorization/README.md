# Conic-ideal quotients for rank-three secant configurations

This directory contains the manuscript
*Conic-ideal quotients for the A3, B3, and H3 secant configurations:
quadratic sheet recovery and cubic orientation in types B3 and H3*.

The paper studies matching products modulo a conic ideal, their quotient
ranks `3,6,10`, balanced-sheet recovery, cubic orientation, self-associated
arithmetically Gorenstein evaluation sets, six-profile reconstruction,
modular depth, and arithmetic splitting.

## Files

- `clebsch_factorization.tex`: manuscript source.
- `clebsch_factorization.pdf`: rebuilt review PDF.
- `verification/statement_identity.json`: exact identity of all twenty
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
arithmetic-gluing Lean gate, the PDF build, and a manuscript-warning scan.
The formal and computational trust boundaries are described in the manuscript
and in `verification/README.md`.

An immutable public source-and-evidence archive locator remains required
before publication.
