# Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682217-blue.svg)](https://doi.org/10.5281/zenodo.21682217)

**Clebsch portfolio:** part of the five-paper *Clebsch: Rigidity from Sparse
Shadows* series. Related companions include *Diagonal Isoduality and
Transversal Clifford Groups of MDS--CSS Codes* and *Balanced Cuts of
Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy*. The shared
progression is expository: this paper is logically independent of the other
portfolio papers.

The five numbered papers are: I, *Reconstructing the Clebsch Code from Its
Deep-Hole Syndrome Locus*; II, this paper; III, *Hitchin's Icosahedral
Incidence Double Cover and Operator Realizations of the Clebsch Cubic*; IV,
*Reconstructing \(\operatorname{PG}(2,13)\), its conic, and polarity from the
minimum words of a binary conic code*; and V, *Chordal and Conference Cubics:
Reconstruction and a Residual \(C_2\)-Torsor*.

This directory contains the manuscript
*Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients*.

[Read the paper (PDF).](clebsch_factorization.pdf)

Restriction to a conic forgets how its marked points were paired into
secants.  The paper classifies the full projective matching orbits whose
conic-quotient evaluation space has a two-valued strength-two trade: exactly
the balanced `B_3/F_7` and `H_3/F_11` orbits survive.  The trade reconstructs
their two unordered sheets, and the first signed tensor moment is the cubic
that orients them and generates the Gorenstein duality of the associated
Artinian reduction.

The matching hypothesis is sharp.  On the ambient fixed line, the matching
point is the only completely reducible Chow point, while `q-2` nonmatching
orbits retain the same trade.  Complete reducibility therefore restores the
faithfulness lost off the matching carrier.  A uniform modular argument
excludes every other matching orbit without a field census.

## Files

- `clebsch_factorization.tex`: manuscript source.
- `clebsch_factorization.pdf`: paper PDF.
- `verification/statement_identity.json`: exact identity of every
  theorem-like statement.
- `verification/trust_manifest.json`: proof-mode and evidence mapping.
- `verification/evidence_fingerprint.json`: normalized review-source and
  environment fingerprint.
- `verification/verify_release.py`: aggregate local verification entry point.
- `verification/check_release_boundary.py`: adversarial checks for the pinned
  source, terminal, and displayed-digest boundary.

## Verification

From the repository root, run:

```text
python3 verification/verify_release.py
```

The aggregate checks statement identity, exact trust-ledger coverage,
checksum manifests, primary certificates and independent replays, the
generic first-wall and shared-radial bundles, the arithmetic-gluing and
hyperplane-square, Hilbert-symmetry, and Paper-II-structural Lean gates, the
PDF build, and a manuscript-warning scan.
The formal and computational trust boundaries are described in the manuscript
and in `verification/README.md`.

The separately distributed formal companion has the version-independent
Zenodo concept DOI
[`10.5281/zenodo.21650878`](https://doi.org/10.5281/zenodo.21650878).
