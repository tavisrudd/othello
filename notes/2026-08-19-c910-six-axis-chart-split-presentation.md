# C910 — the six-axis local chart as a split graph presentation

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-m1/`.
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

Adapted models do exist modulo two: an exhaustive enumeration of the
two-power-sixteen four-by-four matrices over the two-element field finds twelve
that satisfy both `T²+T+1=0` and self-adjointness for `I₄+J₄`, for instance the
matrix with rows `(0,0,1,1)`, `(1,1,0,1)`, `(1,1,0,0)`, `(0,1,1,1)`.  That
enumeration is a scratch check, not tracked evidence: nothing in the paper or in
Lean rests on it, and promoting it would need the usual committed bundle.

**Correction, same day.**  The successor step this suggested is not cheap, and
the follow-up pass below settles why.  No adapted slope exists over the
integers, or over any ordered coefficient ring at all: the depth-one block and
its dual form are both positive semidefinite, and a self-adjoint operator for a
semidefinite form cannot satisfy the relation of a primitive cube root of unity.
The twelve residue solutions do lift two-adically — a Hensel-style linear
solve lifts each of them through `2⁸` without obstruction — so the slope exists
over the two-adic integers, but with no closed form.  Exhibiting it in Lean
therefore needs genuine two-adic coefficients or an abstract complete local ring
with idempotent lifting, not a matrix one can write down.  At three the
corresponding step is genuinely easy, because the slope is scalar and the
depth-one summand stays one block; that half is now done.

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
`papers/cubic-stabilization-m1/` in the same worktree: the Eckardt-locus
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

From `papers/cubic-stabilization-m1/`:

```text
make lint formal-static
lean/scripts/lean-build-queue.py build CubicStabilizationM1 \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Verification.AxiomAudit \
  --lean-root <repository>/papers/cubic-stabilization-m1/lean --cores 20-23
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

## Export status

Exported at `da1d8641b`, carrying four passes at once: the chart split
presentation, the separated-variable clause of the separation theorem, the
depth-one slope results, and the trust-boundary corrections, together with the
concurrent Eckardt work that landed between them.  The export plan and audit
report no findings over 189 scanned files, `sync` wrote twenty-two paths with no
deletions and one ordinary forward commit in the standalone repository, and
`verify` agrees at 192 tracked files against the export manifest.

Agreement was checked on every surface that carries a number rather than by the
standalone gate passing alone.  Its source-only correspondence check reports the
authority's numbers exactly — 141 sources, 290 reviewer terminals, 62 claims, 47
machinery rows, 26 imported sources, 3 evidence bundles — its manuscript rebuild
through its own pinned flake reproduces the tracked PDF byte for byte and leaves
its tree clean, the two Lean trees are byte identical outside the build
directory, and the axiom-log gate passes there on the transcript captured from
the authority's guarded build, which is the same elaboration because the sources
are identical.  Lean was not rebuilt inside the standalone repository, and this
record does not claim that it was.

The portfolio summary was stale in one sentence: it quoted the epilogue's
abstract from before the exact Fermat-point sharpening.  The quote is refreshed
in the authority under `papers/summary/` and copied to its own repository, which
is not carried by the paper exporter.


## Follow-up passes, same day

**The separated-variable clause of the separation theorem, authority
`140930f1f`.**  The manuscript's separation theorem ended with a clause that was
in no Lean terminal, and the Eckardt work of the concurrent task had sharpened
its content from a finiteness statement to an exact one.  The clause is now
formalized in `Applications/SeparatedVariableModuliExclusion.lean`: a member
projectively equivalent to a cubic of separated-variable type carries an Eckardt
point, hence lies over the family's single Eckardt moduli point, and that point
is attained, so the separated-variable locus of the family in coarse moduli is
exactly that point.  The Eckardt criterion for separated-variable cubics, its
invariance under projective equivalence, the Eckardt locus of the pencil, and
the witness at the distinguished point are the four typed premises; coarse
moduli is an opaque type whose points are compared only by equality.  The
conclusion structure of the separation theorem carries the two new clauses, so
the manuscript theorem, its introduction paragraph, and the synthesis discussion
now name the Fermat point instead of saying all but finitely many, and
`prop:A5-nonseparated` moves from absent to a conditional deduction.

**The depth-one slope at three and its bound at two, authority `c78c66558`.**
A slope whose reduction modulo the uniformizer is scalar is proved to equal that
scalar plus the uniformizer times an integral error term, assembled from the
divisibility witnesses of the entries with nothing divided, and for a slope in
that form the split-slope commutator of the graph-coordinate descent conditions
is the commutator of the coefficient block with the actual slope.  At three the
depth-one summand is a single block, so this determines the split presentation
data from the slope itself, which is the one algebraic premise the earlier pass
had to supply.  At two the same pass records the obstruction: the depth-one
block pairs a vector to the sum of the squares of its coordinates and of their
pairwise differences, its dual form to the inverse of five times the sum of the
squares and the square of the coordinate sum, both positive semidefinite over a
linearly ordered commutative ring and positive on the first coordinate vector,
and no matrix satisfying the relation of a primitive cube root of unity is
self-adjoint for either.  That statement supports no manuscript claim and is
registered as machinery, with its reason recorded: it says why the exotic slope
cannot be exhibited as an integral matrix.

Coverage after both passes is 62 claims over 290 reviewer terminals, 5 absent,
27 fragmentary, 29 conditional, 1 complete, with 47 machinery rows.  All gates
green, including the deterministic manuscript rebuild, which the first pass had
deliberately skipped while the concurrent session held the same sections.

## External review of the released repository, and what it found

A review of the released repository raised fifteen findings against a snapshot
three passes old.  Six were already resolved: the claim map's omission of the
separated-variable clause, closed by the follow-up above; a backwards dependency
edge from the coprime-degree proposition to the separation theorem, removed when
that proof was rewritten; the exact Eckardt locus as a trusted elimination,
which is no longer a premise of anything since the reflection-group proof
replaced it; the evidence registry's overstatement of the thirty-point count,
already rewritten as a control; and two consequent requests to qualify the
abstract, moot for the same reason.

Five were live and are now fixed, all in the documentation of the trust
boundary.  The paper README said that exact computations are not part of the
proof surface, which is false while `lem:hirzebruch-euler-spectrum` invokes a
symbolic program as a premise, and said that `make check` lints the TeX sources,
which is false in the released repository, whose Makefile drops that step by an
export rewrite recorded in its own manifest.  The verification README and the
annotation header both still said that no statement carries an evidence
annotation — the verification README contradicting its own opening paragraph —
and both described the annotation scope as the Section 4 atomic route alone,
while five of the six sections carry edges or imported sources.  The annotation
header counted five macros and documented six.

One finding was under-called rather than wrong.  The review noticed an incorrect
dependency edge into the separation theorem; the larger problem was that the
separation section carried no edges at all.  Its four detached proofs now record
what they prove and what they use, and the non-isotriviality input is registered
with its pinpoint and its three conventions, so the separation theorem has
provenance instead of being a graph orphan.

The remaining accepted finding was expository: the residue calculation for the
cubic atom identified the abstract loop coordinate with the one of the small
even system without saying why the normalized block is the germ of the separated
spectral factor.  Section 4 now says it, and cites the gluing lemma that makes
the factor unique up to regular block-diagonal gauge, so the residue
discriminant is visibly an invariant of the atom.

Authority `8b200b9ac`; the manuscript rebuilds warning-free and all gates pass.
