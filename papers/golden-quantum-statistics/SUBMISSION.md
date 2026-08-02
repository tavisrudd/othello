# Submission record

## Decision

The target venue is **Physical Review A**.  The general orientation theorem is
useful but elementary; the paper's publication case is the theorem together
with the exact Golden benchmark and the experimentally explicit design limit.
That combination fits PRA better than a `Quantum` submission centered on a
standalone general theorem.

The immutable local artifact label is
`golden-quantum-statistics-c772-final`.  It identifies the Git commit containing
this record, the manuscript, the locked verification environment, and the
paper-local certificate.  It is a stable repository artifact locator, not a
public preprint URL.

The user owns live posting, assignment of the public locator, and the Clebsch
forward reference.  This package adds no separate gate for those actions.

## Submission contents

- `golden_quantum_statistics.tex` and the built
  `golden_quantum_statistics.pdf`;
- `Makefile`, with `make check` as the complete local acceptance gate;
- `verification/check_imports.py`,
  `verification/c767-import-certificate.json`, and
  `verification/SHA256SUMS`;
- `pyproject.toml` and `uv.lock`, which pin the symbolic replay environment;
- `verification/README.md` and the paper-level `README.md`.

The revised PDF is twelve pages.  Its C772 build has no TeX spacing error,
undefined reference or citation, overfull or underfull box, or package
warning.  The source and PDF hashes at closure are:

| file | bytes | SHA-256 |
|---|---:|---|
| `golden_quantum_statistics.tex` | 38,581 | `8ee5873b69cb817dab2c8d051e512bddb08257a0c866efde596ad21e5644e832` |
| `golden_quantum_statistics.pdf` | 116,416 | `6337d5526aa5ab7bd5b2c10f9d83880885ea626cb97c27ce28a56e6761021919` |

Rebuild and verify from this directory with:

```sh
make check
make verify-sources
```

## Proof and trust ledger

| Claim layer | Trust class | Submission boundary |
|---|---|---|
| Left--right orbit theorem, determinant-line interpretation, permanent obstruction, and minimal orientation carrier | human proof | proved in the manuscript |
| Universal balanced-control rank obstruction and the 20+44 split | human proof | proved in the manuscript; the checker independently confirms the finite count |
| Golden common spectrum and exchange-sector values | live Clebsch source theorem, local exact derivation, and paper-local certificate | explicit matrix, marking convention, trace identities, and characteristic polynomial are in the manuscript; the checker and frozen independent replays cross-check them |
| Permanent census, chiral filter and costs, simplex words, and 15-cell compilation | certificate-checked exact computation | compact certificate and source hashes are local; `make verify-sources` runs the independent source replays |
| Optical component capabilities and antisymmetric-source availability | literature and empirical boundary | not certified by the checker; the source remains an explicit external dependency |
| Shot and fidelity thresholds | analytic calculation under stated models | conditional design budgets, not experimental performance claims |

## Referee-round closure

C771's frozen PRA-style referee report recommended major revision.  C772
implements every substantive request:

- the opening now states that the paper builds on the live Clebsch source
  papers, while the manuscript gives an explicit conference matrix,
  synthematic-total indexing, transported orientation convention, and local
  balanced-spectrum derivation;
- the abstract, theorem transition, apparatus discussion, and conclusion
  distinguish the orientation-covariant determinant amplitude from the
  sign-blind fermionic probability and the sign inferred by coherent
  one-particle tomography;
- the three- and five-cut schedules are printed, the apparatus gauge is
  explained, and the anomaly instance is demoted from the opening;
- the determinant perturbation, simultaneous shot-count, mixture-bias, and
  trace-distance fidelity formulas are derived in the text;
- Figure 1 identifies selected and postselected ports, and the manuscript
  includes the APS Data Availability Statement.

The revised response check finds all five major and ten minor comments
resolved at the paper or submission-metadata level.  The paper remains a PRA
Regular Article; it does not claim a direct many-fermion phase measurement.

## Submission-day literature rerun

On 2026-08-01 the pinned DOI counts remained OpenAlex/Crossref `53/49` for
Goyal et al. and `5/5` for Piccolini et al.  OpenAlex's citing endpoints
returned `55` and `6` records, respectively; screening the same title,
identifier, year, and abstract fields with C768's discriminator promoted four
and two records, none a preparation-and-characterization experiment for a
three-photon qutrit singlet.  The four pinned OpenAlex phrase searches again
returned `1`, `13`, `0`, and `15` records and exposed no matching experiment.
General web searches likewise returned the two proposals and unrelated qutrit
or lower-particle experiments, not the required source.

Semantic Scholar's public API returned HTTP 429 on both pinned seeds during
this rerun.  Its C768 counts and screened set therefore remain the last
successful Semantic Scholar record and are not represented as freshly
verified.  MathSciNet, Google Scholar, and a subject-expert check remain **NOT
COVERED**.  These gaps license only the manuscript's qualified wording.
