# C646 — PRS stable-component Lean geometry and novelty delta

Date: 2026-07-25 America/Los_Angeles

## Outcome

C646 closes the kernel-checkable density/component-selection gap in the
all-level PRS argument:

1. `PRSSquarefreeMarkerDensity.eq_zero_of_eval_eq_zero_on_injective`
   proves that an \(n\)-variable polynomial over an infinite field which
   vanishes on every injective \(n\)-tuple is zero.
2. `splitCoefficientPullback_injective` proves algebraic independence of the
   elementary-symmetric coefficient coordinates via mathlib's fundamental
   theorem of symmetric polynomials.
3. `eq_zero_of_splitCoefficientPullback_eval_eq_zero_on_injective` composes
   these facts: over an infinite field, monic split-squarefree coefficient
   tuples are polynomially dense in the full monic coefficient space. This is
   the algebraic-closure setting used by the manuscript, not a density claim
   for the finite set of \(\mathbb F_q\)-rational tuples.
4. `ContainedRowSpaceData.rowSpace_subset_badCarrier` transports containment
   of a dense attainable locus to its asserted closure.
5. `ContainedRowSpaceData.exists_component_containing_rowSpace` proves that an
   irreducible row space covered by a finite closed component ledger lies in
   one listed component.
6. `RecursiveContainedGeometryInput.bad_implies_persistent_or_modular`
   composes that selected component with the existing recursive polar
   induction theorem.

These are theorem declarations, not new axioms or opaque certificate imports.
The aggregate axiom-audit target set grows from 66 to 74 and the exact
project-owned closure from 16 to 17 files.

## Honest remaining boundary

The following concrete geometry remains manuscript or Certificate SC input:

- identification of the retained-marker coefficient map and its closure with
  the projectivized consecutive-catalecticant row space;
- the exact reduced primary-decomposition/component ledger for the bottom bad
  carrier;
- the geometric classification of every listed component, including the
  relevant saturation and exceptional-fibre statements.

The new Lean API makes those inputs explicit and derives component selection
from them. It does not relabel them as kernel-checked conclusions.

## Literature and novelty delta

The baseline is paper commit `b77f4683`. The seven new labelled mathematical
items are the old-marker fixed-factor lemma, exact-linear-gcd transport,
identically-colliding stages, exact bottom carrier ledger, recursive bottom
transport, uniform iterated lower packages, and the higher-Lucas endpoint
test.

The first six are specialized proof components built from sources and
standard tools already scoped by the prior audit; none receives a standalone
priority claim. Four exact arXiv API searches and a broader object search found
one material new source:

- Lewen Wang, Huawei Wu, and Sihuang Hu, *3-Designs from
  \(\mathrm{GL}_2(\mathbb F_q)\)-Invariant Subspaces of
  \(\mathbb F_q[X,Y]_k\)*, arXiv `2604.21183v4`.

The source was read in full from the cached v4 PDF, cache SHA-256
`ad1e19b1a1bf7b1bbc016cc4617a59a718cf1a3f9396f6386f4b1b151149a811`.
Its Proposition 11 proves the equivalent projective-subline form of the
canonical \(s\mid m\) higher-Lucas criterion. The manuscript now cites it in
the introduction and proposition proof and no longer positions the bare
criterion as new. The source does not identify the coherent Hankel endpoint
or prove shallowness of the larger full \(e_7\) kernel orbit for every
\(m\geq3\); those remain the paper-specific extension.

The complete query strings, result counts, read depth, cache key, graph-access
limitations, and claim-by-claim verdict are recorded in
`papers/beyond4_prs/literature-audit.md`.

## Trust-surface reconciliation

Updated:

- the stable-component and beyond-four Lean gates and both axiom audits;
- `formalization-ledger.md`, `theorem-map.md`,
  `claim-proof-novelty-ledger.md`, `verification-map.md`, and the manuscript's
  verification section;
- the supplement statement map, closure count, verifier target hash, export
  allowlist, reproduction/signoff prose, evidence bundle, and release
  manifest;
- both manuscript PDFs and the new Wang--Wu--Hu bibliography entry.

## Validation

- `guarded-lean RelativeConicArcs/PRSSquarefreeMarkerDensity.lean`: pass.
- no `sorry`, declared `axiom`, or `unsafe` declaration in the changed Lean
  surface: pass.
- `git diff --check` on the task-owned surface: pass.
- canonical manuscript `make check`: pass, 41 pages.
- IEEE review manuscript `make tit-check`: pass, 30/50 pages.
- `python3 supplement/verify.py`: pass.
- `python3 supplement/verify.py --replay`: pass, including the R5, R6,
  R6-normal-form, R7-calibration, and both stable-component certificate
  replays.
- exact four-target Lean queue plus aggregate:
  pending at report draft time because the unrelated
  `RelativeConicArcs.Gates.Relconic` run
  `20260726-051858-715bd3b0` owns the shared build lock.

## Mystery ledger

To be finalized after the guarded aggregate and the required `ej`+`tt`
closeout pass.
