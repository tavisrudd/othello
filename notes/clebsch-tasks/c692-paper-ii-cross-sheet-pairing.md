# C692 — Paper II cross-sheet pairing test

**Lane:** `clebsch`

**Opened:** 2026-07-29

**Status:** complete; negative by one radial dimension.

## Objective

Determine whether C689's perfect cross-sheet incidence pairing
\[
A^{-1}=4A^{\mathsf T}(I-J)
\]
gives a shorter intrinsic proof of Paper II's existing
self-association/Gorenstein perfect-pairing statement.

## Acceptance

A positive result must exhibit the exact quotient, grading, and pairing map
and replace a longer existing argument rather than merely restating
nondegeneracy.  It should also state whether the Paley/Hadamard carrier or
the defining-characteristic middle-layer differential contributes
essentially.

A negative result must locate the mismatch between matching-sheet
incidence and the paper's apolar/Gorenstein pairing and retain C689 only as
the radial-nonvanishing mechanism.

## Boundaries

- This is a bounded comparison, not a classification of arbitrary
  one-factorizations.
- Do not infer the cubic orientation from matching dimensions.
- Any comparison between the Paley differential and the cubic must produce
  the exact filtration map and quadratic-twist sign; otherwise record it as
  an unproved analogy and stop.
- Do not change or delay Paper II v1.

## Inputs

- `notes/2026-07-29-c689-shared-radial.md`
- Paper II's current self-association, Schur, and Gorenstein sections

## Result

The completed comparison is recorded in
`notes/2026-07-30-c692-cross-sheet-gorenstein.md`.

The cross-incidence matrix identifies the two simple top sheet quotients
by \(\bar\rho_-=2A^{\mathsf T}\bar\rho_+\), but its pairing has rank
\(q-2\).  The Artinian Gorenstein pairing has rank \(q-1\); its additional
line pairs the radial degree-one class with the common-sheet-sum
degree-two class.  Thus neither the Paley--Hadamard carrier nor its
middle-layer differential replaces the graded Gorenstein pairing.

The comparison also gives C694 a shorter replacement proof: from
\(L^{\circ2}=\langle\mathbf1\rangle^\perp\), the evaluation space \(L\)
is maximal isotropic, and quotient duality directly makes
\((L/\langle\mathbf1\rangle)\times(L^{\circ2}/L)\) perfect.  This
simplification is independent of the cross-incidence matrix.
