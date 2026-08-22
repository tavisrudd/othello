# C910 unconditional QDM referee repair

**Date:** 2026-08-21

## Result

The unconditional (m=1) QDM proof in
`papers/cubic-stabilization-m1/` now closes the interfaces exposed by a
three-referee red-team pass and the subsequent Fable checks.  No file in the
all-(m) manuscript was changed.

The atomic fold now marks a rank-two nonzero square-zero block only when its
two formal exponent classes are distinct modulo \(\mathbb Z\).  The old
condition \(\delta^\sharp\ne0\) was too weak because it also marked resonant
blocks.  For the cubic threefold the two exponents are \(-1/6\) and
\(-5/6\), so their difference \(2/3\) is nonintegral;
\(\delta^\sharp=4/9\) remains only the checked squared separation.  This
removes the cubic-fourfold false-positive mechanism without changing the
one-stabilization theorem.

The provider layer now also states and implements the missing repairs:

- the comparison is restricted to the even carrier, not only the even bulk
  base;
- a normalized Sylvester gauge splits the full flat connection over a fixed
  algebraic closure, and flatness forces the base operators to preserve the
  splitting;
- independent unit coordinates make the spectra of distinct comparison
  summands generically disjoint;
- the atomic type forgets absolute grading, while graded refinements use
  suspension-compatible folds, absorbing the nonzero homogeneous degrees of
  the cited comparison maps;
- the coefficient bridge uses Iritani's injective graded completed maps and
  the reduced divisor-equation image ring, not a finite algebraic coefficient
  algebra or a literal function-level \(\sigma_j^*\);
- weak factorization now cites AKMW Theorem 0.3.1.

Lean adds explicit modules for even restriction, spectral connection
splitting, and suspension-compatible ledgers, and changes the effective
rank-two fold to the nonintegral exponent-difference predicate.  The reviewer
surface is now 54 claims and 316 terminals.

## Validation

- authority exact build:
  `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Verification.AxiomAudit`
  passed through the guarded queue;
- authority `make check`: passed, producing a warning-free 52-page PDF;
- authority axiom-log gate: passed with 316 terminals and no unexpected
  axioms;
- changed pages 1, 15, 18, 22, 26, 27, 31, and 50 were inspected visually;
- export plan and audit: zero private-reference findings;
- standalone exact Lean build, `make check`, axiom-log gate, and export
  manifest verification: passed.

Authority commits: `741ac4ce6`, `779668a35`, `5ee9d2ec1`.
Standalone commits: `a35c0d3`, `ed007e0`, `0387c21`.

## Cold-read follow-up

An isolated cold reader found no review or process debris and judged the
abstract concise, theorem-first, and accurate apart from one stale name.  The
paper now calls the atomic construction the rank-two formal-exponent marker
throughout, distinguishes the marker from the auxiliary discriminant, and
states precisely which framed conclusions are conditional.  The same pass
repaired one missing antecedent, two awkward sentences, one indentation error,
and the pre-existing hard-coded equation tags in Sections 2--3.  The abstract
gained no words: “residue” was replaced by “formal-exponent.”

## EJ + TT closeout

The cheap conceptual gain is that the marker now says exactly what the
introduction wanted: nonresonance modulo integral lattice changes.  Integral
suspension invariance is therefore part of the mathematics rather than an
adapter added only to repair typing.  A Bittner-style additive relation is a
useful analogy for the blowup telescope, but it is not presently a
Grothendieck-ring measure: multiplicativity and group-valued extension were
not proved, and the natural-valued fold cannot itself be a group
homomorphism.  No such claim was added.

## Mystery ledger

- **Settled:** resonant rank-two blocks were a real false-positive class.
  Replacing \(\delta^\sharp\ne0\) by distinct exponent classes modulo
  \(\mathbb Z\) removes it.
- **Settled:** the full-cohomology rank-twelve cubic block was outside the
  intended atomic carrier.  The paper and Lean interface now restrict the
  fibre to even cohomology explicitly.
- **Settled:** spectrum fusion and grading shifts were missing provider
  hypotheses.  Independent unit-coordinate resultants and suspension-aware
  ledgers now supply them.
- **Open, not a gate:** compute one actual blowup QDM as an independent
  end-to-end falsification test of the comparison consumption.  The current
  proof uses the cited comparison theorems rather than a separate worked
  blowup.
- **Open, outside (m=1):** determine how the large resonant small-point
  block of a cubic fourfold refines at generic bulk.  The repaired marker
  deliberately makes no assertion there.
- **Open successor:** an arbitrary-dimensional statement for blocks with
  nonintegral exponent difference, and its possible Serre-functor
  interpretation, require new geometry/categorical comparison and were not
  inferred from the present proof.
