# Submission record

## Decision

The target venue is **Physical Review A**.  The general orientation theorem is
useful but elementary; the paper's publication case is its combination with
balanced-exchange rigidity, the exact Golden benchmark, and the experimentally
explicit design limit.  That combination fits PRA better than a `Quantum`
submission centered on a standalone general theorem.

The frozen submission bundle contains this record, the manuscript, the locked
verification environment, and the paper-local evidence package. Live posting,
assignment of the public locator, and the Clebsch forward reference remain
publication actions outside this bundle.

## Submission contents

- `golden_quantum_statistics.tex` and the built
  `golden_quantum_statistics.pdf`;
- `Makefile`, with `make check` as the complete local acceptance gate;
- `verification/verify.py`, `verification/evidence_certificate.json`, and
  `verification/evidence_manifest.json`;
- the three paper-local generator/certificate/replay bundles under
  `verification/evidence/`;
- `pyproject.toml` and `uv.lock`, which pin the symbolic replay environment;
- `verification/README.md` and the paper-level `README.md`.

The revised PDF is fourteen pages.  The release build has no TeX spacing error,
undefined reference or citation, overfull or underfull box, or package
warning.  The source and PDF hashes at closure are:

| file | bytes | SHA-256 |
|---|---:|---|
| `golden_quantum_statistics.tex` | 46,967 | `3e865420865860f8a73e050d929ce5e60bd478ae755dcae2b507dcbf73778e97` |
| `golden_quantum_statistics.pdf` | 127,436 | `877e9e6b0c418c23a30852c18129ef1587cc3160effd49984377fc0903e72a6b` |

Rebuild and verify from this directory with:

```sh
make check
make verify-sources
```

## Proof and trust ledger

| Claim layer | Trust class | Submission boundary |
|---|---|---|
| Left--right orbit theorem, determinant-line interpretation, permanent obstruction, and minimal orientation carrier | human proof | proved in the manuscript |
| Balanced-exchange cross-Gram formula and rigidity classification | human proof plus matching Paper-III source theorem | proved self-contained in the manuscript; Paper III carries the source-operator version |
| Higher-order purity mean and variance | classical design theorem and Johnson inclusion calculus | credited to Greaves--Suda and classical inclusion machinery; the exchange interpretation is local |
| Labelled-landscape reconstruction | Paper-III human theorem | retained only as a subordinate collective inverse-boundary remark, not a local optical observable |
| Universal balanced-control rank obstruction and the 20+44 split | human proof | proved in the manuscript; the checker independently confirms the finite count |
| Golden common spectrum and exchange-sector values | live Clebsch source theorem, local exact derivation, and paper-local certificate | explicit matrix, marking convention, trace identities, and characteristic polynomial are in the manuscript; the checker and frozen independent replays cross-check them |
| Permanent census, simplex words, and 15-cell frame compilation | certificate-checked exact computation | compact certificate and source hashes are local; balanced direct compilation additionally requires the stated fixed sign flip; `make verify-sources` runs the independent source replays |
| Retained arithmetic specialization | supplementary exact computation | its generator and replay remain in the package but no manuscript claim depends on it |
| Optical component capabilities and antisymmetric-source availability | literature and empirical boundary | not certified by the checker; the source remains an explicit external dependency |
| Shot and fidelity thresholds | analytic calculation under stated models | conditional design budgets, not experimental performance claims |

## Submission-day literature rerun

On 2026-08-01 the pinned DOI counts remained OpenAlex/Crossref `53/49` for
Goyal et al. and `5/5` for Piccolini et al.  OpenAlex's citing endpoints
returned `55` and `6` records, respectively; screening the same title,
identifier, year, and abstract fields with the archived audit discriminator promoted four
and two records, none a preparation-and-characterization experiment for a
three-photon qutrit singlet.  The four pinned OpenAlex phrase searches again
returned `1`, `13`, `0`, and `15` records and exposed no matching experiment.
General web searches likewise returned the two proposals and unrelated qutrit
or lower-particle experiments, not the required source.

Semantic Scholar's public API returned HTTP 429 on both pinned seeds during
this rerun.  The audit's counts and screened set therefore remain the last
successful Semantic Scholar record and are not represented as freshly
verified.  MathSciNet, Google Scholar, and a subject-expert check remain **NOT
COVERED**.  These gaps license only the manuscript's qualified wording.
