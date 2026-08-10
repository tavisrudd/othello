# C904 — Paper V relative and tower prospectus

**Date:** 2026-08-09  
**Status:** exploration only; not licensed for the manuscript until reviewed  
**Lean:** deferred by user instruction

## Immediate extension-field theorem

Let `K/F_11` be any field extension.  Base-change the full marked Paper-II
package, its five-isotypic projection, the six-axis augmentation, the two
invariant cubic lines, and the outer-normalizer action from `F_11` to `K`.
Then:

1. the invariant cubic space remains two-dimensional;
2. the Paper-II generator remains chordal and its scheme-theoretic singular
   locus remains the base-changed rational normal quartic;
3. the distinguished reduced divisor whose geometric points have exact
   stabilizer `C_5` is the base change of `A_5/C_5`;
4. the intrinsic map
   `A_5/C_5 -> A_5/D_5`, `gC_5 |-> gN_G(C_5)`, still has fibres of degree two
   and recovers the marked six-axis carrier;
5. on the invariant pencil, `q(C)=-C`, `q(H)=8C+H`, so `q-1` restricts to an
   isomorphism from either selected chordal line to the conference line;
6. the exact tensor forward and reverse maps remain inverse after scalar
   extension.

This gives an infinite tower over `F_{11^m}` for every `m >= 1`.  The proof is
flat scalar extension of the printed identities and schemes, plus the
group-theoretic stabilizer map.  One must not say that the entire rational
singular locus has twelve points: over `F_{11^m}` the quartic has
`11^m+1` rational points.  The correct selector is the exact-`C_5` stabilizer
divisor.

This theorem is mathematically valid but formally close to base change.  It
should enter Paper V only if cold reviewers find that it materially clarifies
the intrinsic selector or the scope of the result.

Two adversarial reads approved the stabilizer-stratified version for import.
The manuscript now states it as a corollary and not as a separate novelty
claim.  A stronger geometric decomposition was also identified but remains
outside the manuscript: over an algebraic closure the nonfree locus on the
quartic has strata of degrees `12,20,30` for stabilizers `C_5,C_3,C_2`; over
`F_121` the rational points decompose as `12+20+30+60=122`.  This requires
its own complete stabilizer proof and exact audit before use.

## Stronger arithmetic theorem to investigate

The more substantial target is a relative theorem over a localization of
`Z[sqrt(5)]`:

> For the nonstandard six-axis `A_5` module over an explicit localized base,
> the invariant cubic module is locally free of rank two; the outer
> involution has a rank-one anti-invariant conference summand and exchanges
> two chordal summands; its difference restricts from either chordal summand
> to the conference summand as an isomorphism.  The singular rational normal
> quartic carries a finite étale `A_5/C_5` divisor whose normalizer quotient is
> the six-axis `A_5/D_5` cover.

This would specialize to infinitely many characteristics and would explain
the `F_11` theorem rather than merely repeat it.

### Proof obligations

- construct the six-axis module, invariant pencil, conference line, chordal
  lines, and outer involution over one explicit base ring;
- prove the invariant module is locally free of rank two and commutes with
  base change;
- identify every bad prime, rather than hiding it in an unspecified `N`;
- prove flatness and good reduction of the chordal singular scheme;
- construct the exact-`C_5` divisor and its degree-two map to `A_5/D_5`
  functorially, including Galois descent when the chordal lines are conjugate;
- prove the coefficient of `(q-1)H` on the conference generator is a unit on
  the declared base;
- lift the Paper-II tensor and its normalization if the theorem is to include
  the matching transport, rather than only the companion pencil.

At minimum the semisimple and tensor/polynomial steps require inversion of
`2,3,5`, suggesting `Z[1/30,sqrt(5)]`.  Current integer lifts of the finite
matrices have determinants with extra primes; those primes may be coordinate
artifacts and cannot be declared intrinsic without a new integral
calculation.

### Literature obligations

Before import, audit Pinardin--Zhang Section 8.2, HMSV, classical
chordal/Segre sources, Hunt/Dolgachev, Bussemaker--Mathon--Seidel, and
Goethals--Seidel at theorem level.  The invariant pencil, chordal members,
outer extension, conference conventions, and abstract six-axis set are
pre-empted background.  A defensible new relative claim would be the
functorial exact-`C_5` divisor, normalized difference isomorphism, and its
compatibility with the Paper-II tensor.

## Recommendation

Close the finite theorem and its literature boundary first.  The
extension-field tower is then a safe optional corollary.  Treat the arithmetic
spread-out theorem as a separate upgrade gate requiring its own exact
certificate, literature audit, and cold review.
