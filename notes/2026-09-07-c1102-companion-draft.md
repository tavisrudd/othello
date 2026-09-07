# C1102 — First companion draft

Date: 2026-09-07. Lane: `clebsch`.
Status: **complete first draft; local source, finite and PDF checks passed**.
C1102 remains active for manuscript review and artifact/release preparation.

## Deliverable

`papers/clebsch-cubic-phase/companion.pdf`: 11 pages, provisional recommended
working title *Strength-two trades and transversal cubic gates: the Clebsch
cubic-phase codes and their magic*. Authorship/venue metadata are not invented.
The paper follows the approved four-part structure: signed trade and invariant
phase; Hessian spectra and product exclusion; bounded same-target factory;
chordal shadow. Finite source classifications, the fixed-space distance negative,
coordinate conventions and coverage boundaries are in an appendix.

The Crossref exception remains exactly the user's approved exception. No
three-source absence claim is issued for the Hessian preprint. The canonical
positioning authority remains audit ledger N1–N9, now pointing to the manuscript;
it has not been copied into a second novelty ledger. No numbered paper, Lean
source, mirror or public release was edited.

## Mathematical review and useful additions

* The elementary all-primes construction is stated as a theorem with proof,
  not extrapolated from the seven checked primes. A direct annihilator argument
  now proves its Schur-square rigidity: on the zero-sum hyperplane, a vanishing
  quadratic matrix has form `1 r^T + r 1^T`; comparing diagonal and off-diagonal
  entries leaves only the sheet-sign line. This settles the C1099 translation
  rigidity proof gap without a new search.
* The characteristic-p quotient and affine hyperplanes are explicit. The cubic
  is `-3 u(t) q(u)` and q has rank p−2; the CSS distance proof handles both X and Z.
* The Hessian proof explains the affine shift through `H(v)v=2 grad F(v)`, so its
  support condition is `w in Im H(v)` with the stated Pauli ordering.
* The product ceiling is proved without a SIC existence assumption. The F7
  Clebsch case is not promoted to an all-bipartition exclusion; the other two
  F7 trades and F11 retain their exact positive certificates.
* The factory comparison includes both raw supplies, the correct eight-input
  sign realization of the four-site module, independent storage/retry, convolution
  cancellations, and the restricted final-Clifford extension. No unrestricted
  operational advantage or circuit lower bound is claimed.
* The one-dimensional quotient case omitted by the large fixed-space subspace
  enumeration is explained directly: a nonzero one-variable cubic has no radical
  direction and cannot supply the needed coordinate separation.
* The shadow distinguishes the full rational normal quartic from its rational
  points, and retains the identity-on-complement/geometric scope of the failed
  lifts. Arbitrary full-gate lifts remain unclassified.

The exact-paper expert routing was checked; no dossier is prescribed for this
new companion. No agents or cross-lane work were launched. The paper style,
formal-annotation and research-reproducibility conventions were read.

## Verification and reproducibility

From the paper directory:

```
nix develop .#manuscript --command make check
nix develop .#manuscript --command make pdf
```

The pinned toolchain follows the existing paper flake/lock. Its PDF inspection
shell needed the current `poppler-utils` spelling; only the new paper's copy was
corrected. The toolchain emits a TeX scheme deprecation notice; this is distinct
from manuscript diagnostics. The final TeX log has no overfull boxes or unresolved
references, and one harmless underfull bibliography paragraph.

New atomic finite bundle: `verification/finite_check.py`,
`finite-certificate.json`, `local-hashes.json`, and this report. Standard-library
Python; integer arithmetic modulo p; deterministic enumeration; no random seed.
`finite_check.py --write` regenerates the certificate; `--check` compares it
without mutation. Fresh checks:

* both conic signed moments, affine ranks and Schur-square ranks;
* both coordinate normal-form polynomial identities, by coefficient expansion;
* all 19608 projective p=7 Hessians, reconstructing the tensor from E7, reproducing
  the full vector census `(1,48,2940,26502,88158)`;
* translation construction identities at p=5,7,11,13,17,19,23 as proof controls.

`verification/check.py` validates ten theorem identities, absent formal coverage,
proof identities, source and evidence links, references/citations, authored
statement/proof dependency edges, 104 inherited input hashes/byte counts, and
exact rational entropy/product/factory inequalities. Deliberate defects in isolated
temporary copies were rejected with the expected diagnostic: changed theorem
hypothesis, missing evidence identifier, and missing bibliography citation.
The original task sources were untouched during these refusal tests.

The existing factory replay also passed freshly:

```
python3 notes/2026-09-07-c1102-factory-benchmark/benchmark.py --check
```

This recomputes the independent primal/MacWilliams, synthesis/Fourier and
interval checks. The p=11 multi-billion-point census, matching classification
and fixed-space distance exhaustion were not rerun; their exact source versions,
commands, runtimes and trust limits are pinned in `verification/evidence.json`
and `input-hashes.json`. No claim of independent full replay was added for them.
No formal theorem or Lean coverage is claimed: every formal coverage row is absent.

Rendered pages 1, 7, 8 and 9 were inspected for the headline theorem, factory table,
shadow and finite appendix. This is a local draft review, not the independent
cold review or page-by-page blind comparison required before submission.

Additional source characterization: the MDS–CSS companion abstract was read
at **abstract/metadata only** depth; the factorization manuscript's
`cor:self-associated-gorenstein` was read at **partial** depth for the Macaulay
inverse-system line. Both versions are pinned by local source hashes in the
paper registry. The shadow manuscript remains **secondary only**, through the
named C1099 reconstruction report; no full primary manuscript reading is implied.
These supplement the frozen 33-paper technical audit rather than silently
changing its historical read counts.

## Post-gate ej + tt and Mystery ledger

**ej:** the translation-family rigidity proof is now conceptual, and the small
quotient dimension in the distance obstruction is closed without enumeration.
Both belong to the requested paper and are included, not separate discoveries.
**tt:** ask whether either the purity bound or the operational baseline hides an
assumption. The text supplies the unconditional purity proof, noise-label
uniformity, distinct-point condition, weighted-resource accounting and the exact
separate-architecture boundary. No gate was weakened beyond the prior approval.

* **Settled:** translation-family cubic-weight rigidity for every prime p≥5.
* **Settled:** the fixed-space distance search's one-dimensional quotient case.
* **Open:** explaining the finite conic-source stopping pattern; current evidence
  is exhaustive through p=19, not a theorem for all primes.
* **Open:** a balanced short trade realizing the trace cubic; no search authorized.
* **Open:** unrestricted factory optimization, exact weighted Waring ranks and
  arbitrary lifts of the shadow involution. The draft states their boundaries;
  none is needed for its current theorems.

No new incidental discovery or successor task was allocated. The existing open
questions remain in C1102's outlook; the next work is a critical manuscript review,
then packaging and author metadata decisions before any release.
