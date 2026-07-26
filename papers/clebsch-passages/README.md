# Arithmetic and harmonic realizations of the Clebsch cubic

This directory contains the `clebsch-passages` manuscript and artifact.  Its
main theorem has two legs:

1. the rational square class of Hitchin's incidence cover, its exact local
   golden fibre, and the specialization of the fibre exchanger modulo `11`;
2. the degree-six icosahedral Gaunt/Steinhardt cubic on the Petersen
   four-space.

The fixed-icosahedron Clebsch charts in the first theorem are conjugate
charts over `Q(sqrt(5))`; they are not presented as rational subspaces of
the standard rational harmonic space.

## Source

- `clebsch_passages.tex`: manuscript driver.
- `sections/`: one file for each mathematical stage.
- `ARTIFACT.md`: stable artifact description and trust boundary.
- `release_files.json`: public packaging allowlist.
- `verification/trust_manifest.json`: claim/evidence/status ledger.
- `verification/statement_identity.json`: frozen theorem surface.
- `verification/verify_release.py`: aggregate release gate.

Build from this directory:

```text
make -B
```

Check the manuscript and complete trust surface:

```text
python3 verification/verify_release.py
```

The mod-\(11\) assertion concerns the displayed golden fibre and its
integral exchanger.  It does not assert that the full geometric incidence
comparison has good reduction at \(11\).
