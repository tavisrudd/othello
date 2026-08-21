# C935 — Elliptic two-division discriminant resolvent

**Date:** 2026-08-21

**Status:** complete; manuscript upgraded, modular companion separated

## Verdict

The supplied packet contains a correct theorem at its core, but its word
“canonically” and its transition to the cubic modular base both need repair.
The paper now states and proves the strongest unconditional form supported by
its existing relative geometry:

1. the action on the exotic two-point complement is the sign of the action on
   the rational three-point packet;
2. the two covers therefore have the same orientation/discriminant class;
3. any isomorphism between the two torsors is unique only up to their deck
   involution, so there is no distinguished sheetwise identification;
4. locally this class is `u^2 = disc(x^3+Ax+B)`, hence the square class of the
   elliptic discriminant; globally it is the square-root torsor of the
   discriminant section in the sixth power of the Hodge line; and
5. the actual relative kernel selects one exotic sheet, so the elliptic
   mod-two monodromy on the cubic base is contained in `A_3 ≅ C_3`.

The universal modular-resolvent diagram over `X_0(3)` is correct, including
the degree-three `X_0(6)` root cover, the degree-two sign subgroup, the
degree-six splitting cover, cusp widths `(2,6)`, genus zero, and the function
field obtained by adjoining a square root of a Hauptmodul.  It is not needed
for the theorem just added to the epilogue and should not be used there to
identify the full cubic intermediate-Jacobian period curve.

## Packet audit

### Finite local systems

For a two-dimensional `F_2`-local system `V`, scalar extension gives

```text
P^1(F_4) = P^1(F_2) ⊔ D(V).
```

The group `GL_2(F_2) ≅ S_3` acts on the rational triple by its standard
permutation action.  Its scalar extension lies in
`PGL_2(F_4) ≅ A_5`, hence acts evenly on all five points.  The induced
permutation of `D(V)` therefore has the same sign as the permutation of the
rational triple.  This proves equality of the associated classes in
`H^1(S,C_2)`.

It does not produce a preferred isomorphism of the two `C_2`-torsors.  There
are two equivariant bijections between two sign sets, exchanged by the deck
involution.  The packet's “canonical decomposition” is correct; its
“canonical identification” with the orientation torsor is not.

### Elliptic discriminant

On a short Weierstrass chart, the three nonzero two-torsion points are the
roots of `f_2(x)=x^3+Ax+B`.  The orientation cover is the Vandermonde sign
cover and has equation

```text
u^2 = disc(f_2) = -4A^3-27B^2.
```

Because `Delta_E = 16 disc(f_2)`, the two units have the same square class.
The invariant formulation uses the discriminant section of
`lambda^12`; its square roots lie in `lambda^6`.  This is the formulation
adopted in the paper.

### Actual cubic monodromy

The manuscript already constructs the relative two-primary kernel as a
section of the five-sheet packet and proves that the section lies in the
exotic complement on the connected smooth base.  A section of a two-sheet
torsor trivializes it.  Combining this with the sign calculation gives

```text
rho_2(pi_1(B^circ)) ⊆ ker(sign:S_3 -> C_2) = A_3.
```

This containment is free.  Equality with `A_3` requires an independent
monodromy calculation and is not claimed.

## Modular reconciliation

Reduction modulo two maps `Gamma_0(3)` onto `S_3`.  The point stabilizer gives
the degree-three subgroup `Gamma_0(6)`, the inverse image of `A_3` gives the
degree-two sign cover, and their intersection is
`Gamma_0(3) ∩ Gamma(2)`, the degree-six splitting cover.  The sign subgroup
has index eight in `PSL_2(Z)`, two cusps of widths two and six, two order-three
orbifold points, and genus zero.

The two Hauptmodul normalizations in the record agree.  If
`t_3=(eta(tau)/eta(3tau))^12`, while `T` is the earlier Tate coordinate, their
standard `j`-formulas are reconciled by `t_3=729/T`.  Since `729=27^2`, the
extensions `sqrt(T)` and `sqrt(t_3)` are the same quadratic function-field
extension.  Thus the packet's eta equation is compatible with the earlier
`r^2=T` calculation.

The stack distinction remains real.  `Gamma_1(3)` and `Gamma_0(3)` have the
same image in `PSL_2(Z)`, but a point of order three and a cyclic subgroup of
order three are different marked objects before passage to the coarse complex
orbifold.

## Paper change

The proposition `prop:principal-gluing-packet` now carries the sign-class,
discriminant, and `A_3`-monodromy consequences.  Its proof prints the parity
argument and the deck ambiguity.  The following paragraph gives both the
Weierstrass equation and the Hodge-line formulation.  The introduction's proof
map names the discriminant orientation.  The formal claim digest was refreshed
after re-examining the fragmentary coverage row; no Lean theorem was added.

The digest refresher had fallen behind the checker's reviewer-source API.  Its
call now passes the manifest-derived reviewer sources to the terminal-signature
reader.  This is a tooling repair, not new formal coverage.

`make check` passes: source spacing, source-to-claim correspondence,
deterministic manuscript build, and warning rejection are green.  The rendered
paper remains fifty pages.

## Literature record

This report names two external sources; zero were read at full text and two at
partial depth.  No absence-of-prior-work or priority verdict is made, so no
negative literature search is claimed.

- Looijenga–Zi, *Monodromy and period map of the Winger pencil*,
  arXiv:2109.01810v2.  **Read depth: partial**, cached under
  `arXiv:2109.01810`, SHA-256
  `d49c591df00b53d11cf9f763007fa800935503d732ee745e5509bbd909adf5f1`;
  abstract, introduction and Theorem 1.1, and Section 5 through Proposition
  5.1 and Theorem 5.2.  It proves full `Gamma_1(3)` monodromy and identifies
  the Winger-pencil elliptic period base.  It does not identify the
  nonstandard cubic axis family or its intermediate-Jacobian period curve.
- Hartlieb, *Special subvarieties in the locus of intermediate Jacobians of
  cubic threefolds*, arXiv:2304.03214.  **Read depth: partial**, cached under
  `arXiv:2304.03214`, SHA-256
  `3e6e55c0277b44fadbcbea8cd9f1d4501d307caaab6d6fd5314af36c0b49ab01`;
  Section 5, Lemma 5.5, Proposition 5.7, and Remark 5.8.  It proves the
  one-dimensional special-subvariety statement and the elliptic fifth-power
  isogeny description, not a modular-curve normalization.

Diamond–Shurman, Serre's *Trees*, and eta-quotient references named in the
supplied packet were not needed by the adopted manuscript statement and were
not read for this report.  MathSciNet, zbMATH, and citation-graph coverage were
not attempted because no novelty negative is asserted.

## Companion-note boundary

A short modular companion is preferable to expanding the fifty-page
stabilization paper.  It should consolidate the earlier C909 calculations with
the now-global relative isogeny and prove one precise curve-level theorem.  Its
acceptance gates are:

1. identify the signed cubic parameter with the pullback of the sign resolvent
   as a marked finite-etale graph family, not only as an abstract `E[2]`
   local system;
2. prove the normalization and generic degree of the resulting marked period
   map; and
3. match the stack-level marking and the compactified cusp boundaries.

The current relative six-axis theorem appears to close much of the first gate.
The formulas `T=81t^2` and `r=9t` make the second plausible for the minimal
marking.  The boundary comparison is still not present in the epilogue.

## EJ + TT closeout and mystery ledger

**EJ settled.**  The actual kernel section immediately cuts mod-two monodromy
from `S_3` to `A_3`; this consequence was absent from the supplied executive
theorem but costs only one line after the sign calculation.  Compressing the
new prose retained the manuscript's fifty-page boundary.

**TT correction settled.**  Equality of sign classes is canonical; a
sheetwise torsor isomorphism is not.  The Winger `Gamma_1(3)` theorem is an
analogue and a source for the level-three orbifold, not by itself a theorem
about the cubic axis family.  The universal modular resolvent and the cubic
period-curve identification must remain separate statements.

**Mysteries still open.**

- Does the actual mod-two image equal `A_3`, rather than a proper subgroup?
  Evidence gap: no monodromy generator calculation for the relative axis
  elliptic scheme is printed in the epilogue.  Owner: a modular companion.
- Does the marked cubic period curve compactify to the sign modular curve with
  the predicted two cusps?  Evidence gap: normalization, generic degree, and
  boundary marking are not jointly proved.  Owner: a modular companion.
- Which of the two deck-related identifications matches a preferred golden
  orientation?  This is a normalization choice unless extra marked geometry
  distinguishes it; the current paper needs only the unordered class.

No incidental discovery-track entry was added: every observation above was
part of the requested packet audit or its paper-strengthening closeout.
