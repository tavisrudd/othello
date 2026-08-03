# C646 — PRS stable-component Lean geometry and novelty delta

Date: 2026-08-02 America/Los_Angeles

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

C820 sharpens the geometric side of this boundary.  Its carrier theorem is
fibrewise and reduced: in each geometric fibre, the dense retained-marker
image closes to an irreducible catalecticant row space, and that row space is
selected into one component of the exact reduced ledger.  The Lean structures
formalize precisely this implication.  They do not assert a flat reduced
integral carrier whose residual component would have incompatible degrees in
characteristic zero and characteristic two, nor do they prove C820's concrete
primary decompositions or consecutive-row exclusions.

## Literature and novelty delta

The baseline is paper commit `b77f4683`.  The original seven new labelled
mathematical items were the old-marker fixed-factor lemma,
exact-linear-gcd transport, identically-colliding stages, exact bottom carrier
ledger, recursive bottom transport, uniform iterated lower packages, and the
higher-Lucas endpoint test.  The post-baseline inventory now also includes
C819's finite-depth escape theorem, C820's reduced-fibre carrier and maximal
Lucas-union theorem, C620's empty first higher-Lucas carrier and exact
final-pair trace criterion, and C660's finite R7 reproducibility upgrade.

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

The post-baseline source inventory contains two sources read at **full text**,
one at **partial** depth, and one at **abstract/metadata only**:

- Wang--Wu--Hu, arXiv `2604.21183v4` — **full text**, all sections; cache
  SHA-256
  `ad1e19b1a1bf7b1bbc016cc4617a59a718cf1a3f9396f6386f4b1b151149a811`.
- Wang, *Splitting of Polynomial Families via Galois Theory*, arXiv
  `2606.12810v1` — **full text**, all sections; cache SHA-256
  `5dd4e19544335ebc2c75a184074e94adb91b78331930b5e8a643ae606021a107`.
- Gmainer--Havlicek, *Nuclei of Normal Rational Curves*, arXiv
  `1304.0088v1` — **partial**, abstract and Theorem 1; cache SHA-256
  `da688c01e3953319ef93f17e1676fedf0470c590a0a348a853dabb11209526d0`.
- Dau--Xinh--Kiah--Luong--Milenkovic, *Repairing Reed--Solomon Codes via
  Subspace Polynomials*, arXiv `2007.15253v1` — **abstract/metadata only**,
  official arXiv record accessed 2026-08-02; screened for the shared
  subspace-polynomial tool and not used as a theorem input.

C819 makes no new all-level carrier or higher-Lucas priority claim.  C820's
dated theorem-level delta attributes normal-rational-curve nuclei and the
projective-subline endpoint exactly, and locates no predecessor for the exact
reduced-fibre/Pascal-nesting/recursive-transport conjunction within its four
recorded arXiv queries.  C620 reuses that source boundary and makes no priority
claim for its final-pair trace system or empty-carrier theorem.  C660 changes
no mathematical theorem and therefore adds a reproducibility boundary, not a
novelty claim.  MathSciNet, Google Scholar, zbMATH, and forward-citation graphs
were not jointly covered; no unqualified absence or priority claim is licensed.
The exact query strings, result counts, access depths, cache keys, and
claim-by-claim comparisons are recorded in
`papers/beyond4_prs/literature-audit.md`, the C820 report, and the C620 report.

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
- exact stable-component and beyond-four gate queue, both axiom audits, and
  final aggregate trace gate: pass.  The four targets built successfully and
  the aggregate trace gate passed; the printed trust set is exactly
  `propext`, `Classical.choice`, and `Quot.sound`.

## Extra-juice and Tao closeout

The post-gate extra-juice pass checked whether the abstract component API
could cheaply absorb more of C820's geometry.  It should not: adding a global
scheme structure would obscure the proved fibrewise reduced boundary, while
adding concrete carrier equations would merely move the external geometric
input into a structure field under another name.  The strongest free upgrade
was instead the exact reconciliation above: polynomial density is over the
algebraic closure, topological closure selects one reduced component, and the
recursive theorem consumes that selection without asserting a flat integral
carrier.

The Tao-style stress test targeted the two plausible hidden assumptions.  The
elementary-symmetric pullback is injective independently of density; density
uses infinitude only to extend vanishing from injective tuples.  Component
selection uses irreducibility and a finite closed cover, not injectivity of the
marker parametrization or a rational-point density claim.  The gate and axiom
audit confirm that these are theorem dependencies rather than new axioms.
No further task-owned strengthening is both free and honest.

## Mystery ledger

- **Settled:** the density theorem is an infinite-field polynomial-density
  statement after passage to an algebraic closure; it makes no density claim
  for the finite set of rational marker tuples.
- **Settled:** closure transport and irreducibility select one member of a
  finite closed component ledger, and the recursive polar theorem consumes
  that selection without a preselected component axiom.
- **Settled:** C820's exact compatibility point is fibrewise reduced geometry.
  The impossible flat reduced integral model is neither needed nor implied by
  the formal API.
- **Explicit external geometry:** the retained-marker row-space
  identification, reduced primary decompositions, saturation, and concrete
  component classifications remain manuscript/certificate inputs owned by
  C820 and its cited C525/C597 calculations.
- **Version 2 adoption:** C821 owns manuscript synthesis after this interface
  is frozen; it is not a mathematical or formal gap in C646.

No genuine C646 mystery remains.
