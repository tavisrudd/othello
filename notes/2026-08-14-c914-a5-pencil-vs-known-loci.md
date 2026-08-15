# C914 — The `A_5`-pencil against the known universally `CH_0`-trivial loci

**Lane:** `clebsch` · **Date:** 2026-08-14 · **Task:** C914

## Verdict

The nonstandard `A_5`-invariant cubic pencil contains the Fermat cubic
threefold. The pencil therefore is not disjoint from the cubics that
Yang--Yu--Zhu parametrize in coprime degrees, and it is not disjoint from the
universally `CH_0`-trivial examples that were already explicit in 2017.

**Priority correction, 2026-08-14.** This membership is not new here. Hartlieb
states it in Lemma 5.5, the lemma the epilogue already cites one line earlier
for the identification of the component: the two `A_5`-components of the locus
meet exactly in the Fermat cubic threefold and one further member. Section 1
below is a re-derivation, useful as an independent check and as a one-line
reason, and it is written into the manuscript as a remark crediting Hartlieb.

**Second correction.** Saying that the separation family is pre-empted
overstates it. What the earlier work supplies is the universally
`CH_0`-trivial locus. No earlier source knew that `X x P^1` is irrational, so
the separation after one stabilization is still this paper's, and the
manuscript now states it as three corollaries of the one-step theorem drawn
against Voisin's loci, the Fermat equation, and the Yang--Yu--Zhu family. The
accurate statement is that the `A_5`-pencil is no longer needed to exhibit a
positive-dimensional separation family.

A second finding, from the manuscript's own principal citation: Voisin
established positive-dimensional loci of universally `CH_0`-trivial smooth
cubic threefolds in 2017, of codimension at most three in a ten-dimensional
moduli space. The existence of a positive-dimensional separation family is
therefore older than the Yang--Yu--Zhu pre-emption recorded on the same day.

## 1. Fermat lies in the pencil

Let `W_5` be the five-dimensional irreducible `A_5`-module and `A_4` a point
stabilizer of the natural degree-five action, with `omega` a nontrivial cubic
character of `A_4`. Frobenius reciprocity gives

    <Ind_{A_4}^{A_5}(omega), W_5> = <omega, Res_{A_4} W_5>
                                  = (1/12)[5 + 3 - 4*omega^2 - 4*omega] = 1,

and both representations have dimension five, so `Ind_{A_4}^{A_5}(omega)` is
`W_5`. Induction from a one-dimensional character realizes `W_5` by monomial
matrices whose nonzero entries are cube roots of unity. Such a matrix sends
`y_i` to `omega^k y_{g(i)}`, hence fixes the Fermat form

    y_1^3 + y_2^3 + y_3^3 + y_4^3 + y_5^3,

because `omega^{3k} = 1`. The Fermat form is therefore an `A_5`-invariant
cubic for the `W_5`-action, so the Fermat cubic threefold is a member of
`P((Sym^3 W_5^*)^{A_5})` — the pencil the epilogue calls the nonstandard
`A_5`-pencil, Hartlieb's `M_{H_1}`. It is smooth, so it lies in `B^circ`.

There is no conflict with the manuscript's remark that the pencil is not the
component associated with `1 + W_4`: the Fermat cubic is invariant under both
actions, so it lies on both components.

### Replay

    python3 notes/2026-08-14-c914-a5-pencil-fermat-membership.py

Script SHA-256:
`eba634c90d8aa5df59ea20aff83bf3deb699192a3f5e7dd888f7592c09bffea9`.
Output, all three lines independent of the argument above:

- character values `(5, 1, -1, 0, 0)` at the identity, a double
  transposition, a three-cycle, and a five-cycle, which is `W_5` and not
  `1 + W_4` (whose three-cycle value is `2`);
- the space of `A_5`-invariant cubics has dimension two, matching the
  character computation printed in the manuscript introduction;
- the five Fermat monomials form a single orbit whose invariance forces equal
  coefficients, so the Fermat form spans one direction of the pencil.

## 2. What is already known about that member

- Voisin, *On the universal `CH_0` group of cubic hypersurfaces*, JEMS 19
  (2017), Corollary 4.4 and Theorem 4.5 with Lemma 4.6: each choice of the
  two sublattices produces a subvariety of codimension at most three in the
  moduli space of smooth cubic threefolds along which `theta^4/4!` is
  algebraic. Colliot-Thélène summarizes that theorem as giving explicit
  universally `CH_0`-trivial cubic threefolds in `P^4`, the Fermat
  hypersurface among them (arXiv:1607.05673, page 1).
- Colliot-Thélène, *`CH_0`-trivialité universelle d'hypersurfaces cubiques
  presque diagonales*, Algebraic Geometry 4 (2017), 597--602: a smooth cubic
  hypersurface in `P^n`, `n >= 4`, whose equation is a sum of forms in
  separated groups of at most three variables is universally
  `CH_0`-trivial. The Fermat cubic threefold satisfies that hypothesis.
- Yang--Yu--Zhu, arXiv:2508.03623, Remark 3.6: an explicit dominant rational
  map of degree three from `P^3` to the Fermat cubic threefold. With the
  classical degree-two parametrization this gives coprime degrees, hence a
  decomposition of the diagonal, for that same member.

So for the Fermat member of the pencil, universal `CH_0`-triviality has three
independent proofs predating the manuscript, and the manuscript's own
conclusion on that fibre is a reproof.

## 3. Consequences for the epilogue

1. The separation statement on the pencil should not be presented as the
   first positive-dimensional family. Voisin's Theorem 4.5 already gives
   families of dimension at least seven; Yang--Yu--Zhu give a two-dimensional
   family with a different mechanism; the pencil is a curve in coarse moduli.
2. What survives as the pencil's contribution is the mechanism: algebraicity
   of the primitive minimal class proved from the six-axis lattice by the
   all-degree finite-etale graph saturation theorem, uniformly in the
   parameter, rather than from an isogeny to a curve Jacobian or from a
   unirational parametrization.
3. The Fermat membership is a usable consistency check on the cycle-side
   theorem: the theorem's conclusion on that fibre agrees with three earlier
   proofs.

## 4. Open, and what was abandoned

- Whether the generic member of the pencil lies inside the Yang--Yu--Zhu
  locus, inside one of Voisin's codimension-at-most-three components, or
  outside every currently known locus. This is the question that would
  restore a sharp novelty claim for the family, and it remains open.
- The Eckardt-point separator hypothesis recorded when C914 was allocated is
  refuted. Every Yang--Yu--Zhu member has an Eckardt point at `[1:0:0:0:0]`
  (the tangent hyperplane there is `x_3 = 0` and the section is independent
  of `x_1`, hence a cone), but so does the Fermat member of the pencil, which
  has thirty. Eckardt points do not separate the two loci.
- A Groebner elimination for the Eckardt locus of the whole pencil, over the
  rational function field in the pencil parameter, was set up in Singular and
  killed after fifteen minutes without terminating. No conclusion is drawn
  from it. The script is not committed; the question it targeted is
  superseded by the direct argument in Section 1.

## Mystery ledger

| Item | Status |
|---|---|
| The pencil contains both the Segre cubic, which is singular, and the Fermat cubic, which is smooth | settled as consistent: the `p_3` member of the six-coordinate model is the Segre cubic and the Fermat member is a different point of the same pencil |
| Whether the pencil meets the Yang--Yu--Zhu surface in more than the Fermat point | open; needs the explicit comparison of the two normal forms |
| Whether the pencil lies in a Voisin codimension-three component | open; would follow from an odd-degree isogeny of `J(X_b)` to a curve Jacobian, uniformly in `b` |
