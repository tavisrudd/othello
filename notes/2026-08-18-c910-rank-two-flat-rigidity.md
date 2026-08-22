# C910 — rank-two atomic rigidity derived from flatness

**Date:** 2026-08-18 · **Lane:** `cubic-threefolds` · **Task:** C910

## What this pass changes

Before it, the rank-two step of the Section 4 atomic route was formalized as
isolated matrix algebra: the flatness coefficient equations, the pairing
equations, the shape of the residual base pole, and the Lax equation were all
*hypotheses* about matrices, and the elementary modification itself was not
constructed.  The manuscript proves each of those from flatness of the
connection and horizontality of the Poincaré pairing.  This pass formalizes that
derivation.

The connection is now a formal object.  Writing `A(u)` and `B_δ(u)` for the loop
and base connection matrices of a centered rank-two factor, both with a simple
pole, the module `Quantum/FormalLoopConnection.lean` represents them by the
power series `u·A(u)` and `u·B_δ(u)` with matrix coefficients, so that

* flatness `δA − u∂_u B_δ + [A, B_δ] = 0`, multiplied by `u²`, is the single
  series identity `IsFlatPair`, and
* horizontality `u∂_u P + A(u)ᵀP + P A(−u) = 0`, multiplied by `u`, is the single
  series identity `IsHorizontalPairing`.

Extracting coefficients from those two identities gives the four equations the
manuscript displays: commutation of the leading coefficients, the first-order
identity, self-adjointness of the residue for the leading pairing coefficient,
and the four-term relation.  The Leibniz rules for the Euler operator `u∂_u` and
for an entrywise derivation of the coefficient ring are proved there as well.

## The elementary modification without inverses

`Quantum/AtomicElementaryModification.lean` constructs the gauge `S = diag(1, u)`
as a power series with matrix coefficients and defines the transformed loop and
base matrices coefficientwise.  Their defining property is stated as the pair of
identities

```
S * (u · A♯) = A · S − u² · diag(0,1),        S * (u · B♯_δ) = B_δ · S,
```

which avoids `S⁻¹` and any Laurent series.  They hold exactly under the adapted
frame conditions — the leading coefficient is supported in its upper-right entry
— together with vanishing of the lower-left entry of the regular coefficient,
which is the manuscript's statement that the regular coefficient preserves the
nilpotent line.  Left multiplication by the gauge is injective, and flatness is
transported: if the original pair is flat then so is the transformed pair.  The
transport is proved by multiplying the transformed flatness expression by the
gauge, substituting the two identities, and cancelling.

The residue of the modified lattice is
`R = !![A₀(0,0), ν; A₁(1,0), A₀(1,1) − 1]`, which is the manuscript's formula
for the cubic residue with `ν = 2`, `A₀ = D₀`, `A₁ = E₀`.

## The rigidity chain

`Quantum/AtomicRankTwoFlatRigidity.lean` runs the manuscript's argument:

1. flatness forces the leading base coefficient to commute with the leading loop
   coefficient and to have vanishing trace;
2. in the adapted frame, and with `2` a unit, those two facts make it a multiple
   of the leading loop coefficient, so its diagonal and lower-left entries
   vanish — the commutant computation;
3. that is the hypothesis under which the modification transports the base
   direction, and the first order of flatness in the modified lattice reads
   `K + [R, K] = 0`, so the residual pole `K` vanishes because the upper-right
   entry of `R` is a unit;
4. with no pole left, the next order of flatness is the Lax equation
   `δR = [G, R]` for the regular coefficient `G` of the modified base direction;
5. trace and determinant are unchanged by an infinitesimal conjugation, so every
   derivation annihilates the residue discriminant.

Horizontality enters through a separate lemma.  In the adapted frame the leading
pairing coefficient has vanishing upper-left entry and equal off-diagonal
entries, so its determinant is the negative of the square of the off-diagonal
entry; nondegeneracy — invertibility of that determinant, which is the right
condition over a germ ring — therefore makes the off-diagonal entry invertible,
and the upper-left entry of the four-term relation reads `2·a·p = 0` for the
lower-left entry `a` of the regular coefficient.  Hence `a = 0`, which is
exactly the input the modification needs.  Only invertibility is used, so the
lemma holds over any commutative coefficient ring.  The chain from horizontality and
flatness to a derivation-annihilated residue discriminant is assembled in one
statement.

Over a formal germ — multivariate formal power series in the germ's coordinates
over a characteristic-zero field — flatness in every coordinate direction makes
the residue discriminant a constant series, using the existing result that a
series whose formal partial derivatives all vanish has no coefficient outside
its constant term.  Because the pairing lemma needs only invertibility, the germ
statement is self-supporting: from an adapted frame whose leading operator has an
invertible upper-right entry, a horizontal pairing with invertible leading
determinant, and flatness in every coordinate direction, the residue
discriminant is constant over the germ, with no nilpotent-line hypothesis
assumed.  Two is invertible there because it is the image of an invertible
scalar.

## What remains for this row

* The geometric inputs are unchanged and remain hypotheses: that an atomic
  factor of the `A`-model `F`-bundle supplies a connection of this shape in an
  adapted frame, that the Poincaré pairing is the horizontal pairing of that
  connection, and that the formal germ computes the rigid-analytic germ.
* Manuscript-side integration — claim-map rows, reviewer terminals in
  `PaperInterface`, expected axioms, and the coverage value of the rank-two
  rigidity row — is not part of this pass.  A second session was editing the same
  package's manuscript sources, claim map, and dependency graph while this work
  was done, so the integration is deferred rather than performed against
  in-flight foreign edits.

## Validation

Each of the three modules elaborates through the guarded single-file entry point
with no errors, and all three build through the guarded queue.  The package's
source-only correspondence check passed with the new modules present before the
concurrent session's manuscript edits made its dependency-graph comparison stale;
that staleness is in files owned by that session, not by this pass.

New modules, all under
`papers/cubic-stabilization-m1/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationM1/`:

* `Quantum/FormalLoopConnection.lean`
* `Quantum/AtomicElementaryModification.lean`
* `Quantum/AtomicRankTwoFlatRigidity.lean`
