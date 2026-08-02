# Submission record

## Decision

The target venue remains **Physical Review A**.  The publication case is now
the integrated theorem-first exchange landscape: the orientation boundary,
continuous Golden control, Hermitian Pareto and squared-spectrum rigidity, and
quantitative stability, with the interferometric design limit as a concise
operational consequence.

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

The revised PDF is sixteen pages.  The release build has no TeX spacing error,
undefined reference or citation, overfull or underfull box, or package
warning.  The source and PDF hashes at closure are:

| file | bytes | SHA-256 |
|---|---:|---|
| `golden_quantum_statistics.tex` | 53,203 | `6341feccfd5c20d1a0610beda09c2b6914cb80c30b111d8e796a089744e8c7f8` |
| `golden_quantum_statistics.pdf` | 143,783 | `812bbc5dbf8e254c76a6369ccefd59142aa21346ad7716f82de39aa11109b7c2` |

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
| Continuous-control joint optimum | human convexity, rank-one-minor, and spectral-lemma proof plus exact endpoint replay | the manuscript proves the cube reduction and equality cases; the paper-local certificate checks all 64 Boolean profiles |
| Hermitian exchange Pareto segment | human triangle-holonomy and convexity proof plus exact formula replay | the prior conference family is credited only for attainability; no classification theorem is imported |
| Squared-spectrum rigidity and quantitative stability | human pentagon parity, Pfaffian-square endpoint, triangle-product Lipschitz, and parity-rounding proofs | ordinary three-uniform ETF theory is explicitly distinguished; the reverse estimate is local and no constants are claimed sharp |
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
