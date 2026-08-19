# C910 — the six-axis local chart as a split graph presentation

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-epilogue/`.
**Date:** 2026-08-19.  **Authority commit:** `d4193b00f`.
**Predecessor:** the local-chart lift and unit-summand pass
`2026-08-18-c910-local-chart-lift-and-unit-summand.md`, which closed the two
uncovered clauses of `lem:six-axis-local-chart` but left the passage from those
data to the presentation consumed by `thm:all-degree-graph-saturation`
unformalized.  That passage is the priority-one backlog item, and this pass
takes it.

## What the bridge had to close

The all-degree saturation theorem is stated for a *marked finite-étale graph
presentation*: split coordinates carrying one unimodular block and the
eigenblocks of the depth-one slope, a depth function, slope scalars, integral
slope errors, and an invertible change of basis over the splitting ring.  Until
now every one of those was an opaque premise of the Lean terminal, and the
six-axis chart supplied none of them: the chart congruence, the depth-one lift,
and the discriminant statements all lived on the other side of the gap.

`GraphLattices/SixAxisMarkedPresentation.lean` builds the data.

## What is now proved

**The chart decomposition as depth data.**  The four-dimensional block
`5I₄-J₄` is defined over any commutative ring and given the two-sided inverse
`(1/5)(I₄+J₄)`, which needs only a supplied inverse of five; the determinant
`125` of the block is the reason.  Whenever `6/5` is a uniformizer times an
invertible scalar — at `p = 2` with unit multiple `3/5`, at `p = 3` with `2/5`
— the chart Gram matrix has value five on the first coordinate line, vanishes
between that line and the other four coordinates, and equals the uniformizer
times the unit multiple of `5I₄-J₄` on those four.  That is
`(Z_p⁵,G) ≃ U₀ ⊥ pU₁` as an identity of coefficient matrices, with `U₁`
unimodular after division by the uniformizer.

**The lift at the exhibited block.**  The depth-one self-adjoint lifting
construction is instantiated at that block.  The general terminal supplies a
symmetric Gram matrix with a two-sided inverse; here the one the manuscript uses
is exhibited, so the hypothesis is discharged rather than assumed.  Over a
domain in which the uniformizer and two are nonzero and five and the unit
multiple are invertible, every endomorphism of the reduction modulo the
uniformizer that is self-adjoint for the reduced dual form of the depth-one
summand is the reduction of a self-adjoint one.

**The split coordinates.**  The block index type adjoins the unimodular line to
a supplied index of depth-one blocks; the coordinate type is the disjoint union
of their bases, identified with the five chart coordinates through a supplied
identification of the depth-one blocks with the last four.  The change of basis
is the chart matrix followed by a supplied change of basis of the depth-one
summand, and it is proved invertible with its explicit inverse, giving the
coordinate equivalence the saturation theorem asks for.  Depth is zero on the
unimodular line and one on every depth-one block; scalars and slope errors are
those of the split slope, with the unimodular line carrying the zero error.

**Orthogonality of the eigenblocks.**  In the split coordinates the six-axis
form is again the unit line of value five orthogonal to the depth-one part,
whose block is `6/5` times the transported block.  Two depth-one coordinates
that are eigenvectors of a slope self-adjoint for `5I₄-J₄`, with eigenvalue
difference cancellable, pair to zero.  This is the manuscript's step that the
idempotents of the split étale algebra have mutually orthogonal images; it is
proved here for eigenvectors rather than through idempotent lifting, which is
what the split basis actually presents.

**The saturation theorem instantiated.**  Divided-power saturation now runs on
chart data: for the coefficient lattice `6I₅-J₅` in the chart coordinates, with
the depth, scalar, and slope-error families above, every divided power of a
class satisfying the three graph-coordinate descent conditions is an ordinary
integral divisor product, and its factorial multiple is the corresponding power
of the class.  What is left supplied splits in two.  Geometric: the
cohomological realization of coefficient matrices, the injective pullback to the
elliptic-power source, the divisor submodule, and the compatibility of the class
and its divided power with that realization.  Algebraic: the eigenblock
decomposition itself, through the change of basis of the depth-one summand and
the scalars and error terms of the split slope.

## The adapted slope is missing, and that is now sharp

The eigenblock decomposition is the one algebraic premise the bridge could not
discharge, and the pass identified why.  The package's concrete two-primary
slope model, the two companion blocks of `t²+t+1` in
`GraphLattices/SixAxisSlopeModels.lean`, is **not** self-adjoint for the reduced
dual form of the six-axis depth-one block.  Modulo two the block and its inverse
are both `I₄+J₄`, and the companion model does not commute with it, so that
model is a model of the slope *type* only and cannot be the slope of a kernel in
these chart coordinates.

Adapted models do exist: an exhaustive enumeration of the two-power-sixteen
four-by-four matrices over the two-element field finds twelve that satisfy both
`T²+T+1=0` and self-adjointness for `I₄+J₄`, for instance the matrix with rows
`(0,0,1,1)`, `(1,1,0,1)`, `(1,1,0,0)`, `(0,1,1,1)`.  That enumeration is a
scratch check, not tracked evidence: nothing in the paper or in Lean rests on
it, and promoting it would need the usual committed bundle.  Its use here is to
say that the successor step is available and cheap — exhibit an adapted slope,
diagonalize it over the unramified quadratic extension where its two eigenvalues
differ by a unit, and the change of basis, the scalars, and the error terms stop
being supplied.  At three the corresponding step is easier still, because the
slope is scalar and the depth-one summand stays one block.

## Coverage

`lem:six-axis-local-chart` gains three reviewer terminals and remains a
fragment; `thm:six-axis-divided-powers` gains one and remains a fragment.  The
snapshot moves from 283 to 287 reviewer terminals with the coverage partition
unchanged.  New module:
`GraphLattices/SixAxisMarkedPresentation.lean`.

## Gates

Green at `d4193b00f`.  The new module was elaborated singly, both library
targets were built through the guarded queue, and the source-only and axiom-log
checks pass over 140 sources and 287 terminals.  Each new terminal reports
`propext, Classical.choice, Quot.sound`.  The manuscript was not rebuilt: the
only manuscript change is the two `\lean` lists, whose macros are
typographically empty, and a concurrent session was editing the same sections
(see below), so rebuilding the tracked PDF would have baked its prose in.

## Concurrent work in the same paper

While this pass ran, another session was editing
`papers/cubic-stabilization-epilogue/` in the same worktree: the Eckardt-locus
prose in `sections/03-minimal-class.tex`, the main manuscript file,
`verification/imported-sources.json`, `verification/dependency-graph.dot`, three
new claim rows, and the coverage-snapshot lines of both `README.md` files.  The
commit above therefore stages exact content rather than whole files for the four
shared files: the claim map carries only the two rows this pass changed, the
manuscript carries only the two annotation lists, and each snapshot line carries
only the terminal count raised by four.  The other session's edits remain in the
working tree, untouched and uncommitted, and its claim rows are still absent
from the committed snapshot count, which is why the committed line reads 59
claims rather than the 62 the working tree now computes.

## Replay

From `papers/cubic-stabilization-epilogue/`:

```text
make lint formal-static
lean/scripts/lean-build-queue.py build CubicStabilizationEpilogue \
  TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Verification.AxiomAudit \
  --lean-root <repository>/papers/cubic-stabilization-epilogue/lean --cores 20-23
make formal-audit AXIOM_LOG=<run directory>/logs/<audit target>.quiet/<run>/<invocation>/stdout.log
```

## Mystery ledger

- **Settled: which hypothesis of the lifting construction the chart actually
  needs.**  Only invertibility of the depth-one Gram matrix, and that is now
  exhibited rather than supplied.  The unit multiple plays no role beyond being
  invertible, so the lift is insensitive to which prime dividing six is meant.
- **Settled, negatively: the existing residue slope model does not fit the
  chart.**  It has the right minimal polynomial and the wrong adjointness, as
  above.  The evidence gap is a tracked construction of an adapted slope; owner
  is the successor step named below.
- **Open: idempotent lifting over a complete ring is still absent.**  The
  manuscript splits the depth-one summand by lifting the primitive idempotents
  of the finite-étale quotient; Lean instead consumes an already split basis and
  proves that its eigenblocks are orthogonal.  The two agree once the lifted
  idempotents are polynomials in the slope, which is exactly the step not
  formalized.  Evidence gap: no Hensel or completeness statement in the package.
  Owner: a successor, gated behind the adapted slope.
- **Open, small: the unimodular line's value five.**  Carried over unchanged
  from the previous pass; the form's determinant `6⁴` does not force it, and
  nothing explains why both natural choices of unimodular summand land on it.

## Next

Exhibit an adapted two-primary slope, self-adjoint for the depth-one block and
of exotic type, and its eigenbasis over a ring containing a primitive cube root
of unity; that removes the change of basis, the scalars, and the slope errors
from the supplied data at `p = 2`, and the parallel scalar statement at `p = 3`
removes them there.  After that, the remaining premises of the six-axis
divided-power terminal are geometric only, which is the relative six-axis
geometry item of the backlog.
