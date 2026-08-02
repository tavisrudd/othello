# Submission record

## Decision

The target venue is **Physical Review A**.  The general orientation theorem is
useful but elementary; the paper's publication case is the theorem together
with the exact Golden benchmark and the experimentally explicit design limit.
That combination fits PRA better than a `Quantum` submission centered on a
standalone general theorem.

The immutable local artifact label is
`golden-quantum-statistics-c770-v1`.  It identifies the Git commit containing
this record, the manuscript, the locked verification environment, and the
paper-local certificate.  It is a stable repository artifact locator, not a
public preprint URL.

The public-preprint gate is **closed**.  No Paper-III forward citation is
authorized until an arXiv identifier, DOI, or equivalently stable public
locator has been recorded in a later routed task.

## Submission contents

- `golden_quantum_statistics.tex` and the built
  `golden_quantum_statistics.pdf`;
- `Makefile`, with `make check` as the complete local acceptance gate;
- `verification/check_imports.py`,
  `verification/c767-import-certificate.json`, and
  `verification/SHA256SUMS`;
- `pyproject.toml` and `uv.lock`, which pin the symbolic replay environment;
- `verification/README.md` and the paper-level `README.md`.

The submitted PDF is ten pages.  Its C770 build has no TeX spacing error,
undefined reference or citation, overfull or underfull box, or package
warning.  The source and PDF hashes at closure are:

| file | bytes | SHA-256 |
|---|---:|---|
| `golden_quantum_statistics.tex` | 31,995 | `167d73977be5103f557daf7304c4966fede69e4d255971b4ebfd5ad9f5dc3ddf` |
| `golden_quantum_statistics.pdf` | 105,207 | `51f32c34f379f4e6a08910f7b473a61b575748f17b8a130c2b345bb8860db62e` |

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
| Golden common spectrum and exchange-sector values | exact imported identity plus paper-local certificate | checked by `verification/check_imports.py`; the frozen source bundles have independent replays |
| Permanent census, chiral filter and costs, simplex words, and 15-cell compilation | certificate-checked exact computation | compact certificate and source hashes are local; `make verify-sources` runs the independent source replays |
| Optical component capabilities and antisymmetric-source availability | literature and empirical boundary | not certified by the checker; the source remains an explicit external dependency |
| Shot and fidelity thresholds | analytic calculation under stated models | conditional design budgets, not experimental performance claims |

## Cold-read closure

The quantum-optics read found the one-particle tomography, ordinary-boson
control, and direct three-fermion emulator cleanly separated.  Port numbering,
mesh resources, accepted-trial assumptions, copy matching, and source-fidelity
conditions are explicit.  The manuscript does not present the conditional
fermionic branch as a demonstrated experiment.

The mathematical-physics read found the determinant-line mechanism before the
Golden specialization, the `O/SO` and `U/SU` boundaries stated with their
singular cases, and the trust boundary recoverable without consulting the
development reports.  The arithmetic anomaly example is visibly bounded and
does not become a dynamical gauge-theory claim.

The theorem-opening, section-opening, paragraph-job, notation, and citation
passes found no submission-blocking defect.  The title and abstract identify a
theory/design-limit paper; the main theorem appears before the exact benchmark;
each later section has one primary role; `K`, `H`, `B_sym`, and `F_ext` retain
one meaning; and the sole literature-dependent experimental negative remains
qualified by “to our knowledge.”

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
