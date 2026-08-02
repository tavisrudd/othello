# Quadratic trade rigidity and cubic orientation in conic matching quotients

**Series:** *The Clebsch cubic: recovering, orienting, and realizing --- II*

The shared series progression is expository; this manuscript is logically
independent of the other papers.

This directory contains the manuscript
*Quadratic trade rigidity and cubic orientation in conic matching quotients*.

The paper classifies full projective matching orbits from an intrinsic
two-valued quadratic trade.  Exactly the `B_3/F_7` and `H_3/F_11`
orbits survive.  Quadratic products recover their two unordered sheets,
and the first signed tensor moment is a cubic that orients them.  The
matching hypothesis is sharp: off the secant-product Chow locus, `q-2`
nonmatching orbits retain the same trade.  The paper also proves quotient
ranks `3,6,10` and the self-associated Gorenstein consequences.  The
appendices record six-profile reconstruction, modular depth, arithmetic
splitting, and further `H_3` cubic structure.

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
