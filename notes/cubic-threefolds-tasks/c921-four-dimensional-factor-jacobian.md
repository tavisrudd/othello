# C921 — Is the four-dimensional factor of the `A_5`-pencil Jacobian a curve Jacobian?

**Lane:** `cubic-threefolds`

**Status:** active

**Objective:** decide whether the nonstandard `A_5`-cubic pencil lies in one of
Voisin's codimension-at-most-three components, which C914 reduced to a single
question about one explicit factor.

## What C914 established

For a geometric generic member `X_b`, the intermediate Jacobian admits an
odd-degree isogeny

    E' x A_b --> J(X_b),   pullback of theta = m (theta_{E'} + theta_{A_b}),
    m odd,

with `E'` an elliptic curve isogenous to Hartlieb's factor `E_b` and `A_b` a
four-dimensional principally polarized abelian variety isogenous to `E_b^4`;
the sublattice has odd index `25`. No further orthogonal odd-index splitting
exists: the two-primary gluing kernel is an `F_4`-graph, and every `F_4`-line
of the coefficient heart is its own perpendicular for the discriminant pairing,
so an elliptic-product route is impossible. Report:
`../2026-08-18-c914-a5-pencil-vs-voisin-and-yyz.md`.

## The question

Voisin's criterion (arXiv:1407.7261, proof of Theorem 4.5) holds for the pencil
exactly if one of these does:

- [x] **Closed negative, 2026-08-19.** `A_b` is the Jacobian of an irreducible
  genus-four curve for at most finitely many `b`. Torelli makes such a curve
  carry a faithful `D_5`-action; Riemann--Hurwitz leaves the single branch datum
  `(2,2,5,5)` over the line, so the curve is a cyclic quintic cover branched at
  four points with an involution inverting the deck group, and the Eichler trace
  formula forces its analytic representation to be `V_1 + V_2`, the same as
  `A_b`, so no character comparison can obstruct. Both the curve family and the
  pencil family are one-dimensional inside the two-dimensional moduli of
  `D_5`-fourfolds, and a Weil-polynomial computation shows a member of each of
  the two curve families whose Jacobian is not isogenous, over any extension, to
  a power of an elliptic curve — which every `A_b` is. Report and evidence
  bundle: `../2026-08-19-c921-genus-four-branch.md`.
- [ ] `J(X_b)` is odd-degree isogenous to the Jacobian of an irreducible
  genus-five curve, with no product decomposition involved. The isogeny must have
  degree greater than one, since Clemens--Griffiths already rule out an
  isomorphism for every smooth cubic threefold; that is what makes this the hard
  branch, and it is why Voisin's criterion is stated up to odd-degree isogeny in
  the first place.

A positive answer puts the pencil inside a Voisin component and demotes the
epilogue's separation corollary on the pencil to a reproof; a negative answer
leaves the family outside every currently effective route and is the stronger
statement for the manuscript.

## What the literature already gives (2026-08-18)

Hartlieb's Remark 5.8 records that the intermediate Jacobians of the whole
family are isogenous to the fifth power of an elliptic curve, and its footnote
credits van Geemen and Yamauchi with a sharper statement for any cubic
threefold carrying an automorphism of order five: `J(Y)` is isogenous to
`E x B^2` with `B` an abelian surface, described explicitly there for the
general such threefold. Every member of this pencil carries such an
automorphism, so the four-dimensional factor `A_b` is isogenous to `B^2`.

That is consistent with C914 rather than in tension with it: the splitting of
`A_b` into two abelian surfaces exists as an isogeny, and what C914 rules out
is its realization by an odd-degree isogeny under which the principal
polarization pulls back to an odd multiple of the product polarization. The
sharpened question for this task is therefore whether the polarized
four-dimensional factor, not merely the underlying abelian variety, is a curve
Jacobian.

## Suggested attacks on the remaining branch

- The lattice side, the instrument that decided the product routes in C914: which
  odd-degree isogenies from a genus-five Jacobian are compatible with the exotic
  two-primary gluing kernel of the packet proposition? Torelli is unavailable
  once the comparison is an isogeny of degree greater than one, so the gluing
  data is the natural replacement.
- Roulleau's `D_5`-fibration of the Fano surface, now aimed at exhibiting or
  excluding a genus-five curve whose Jacobian receives `J(X_b)`.
- The Klein cubic threefold is a member of this pencil with a complex-multiplication
  factor and a cheap test case, though a single such member decides nothing about
  the generic one.

The attacks that settled the genus-four branch are recorded in
`../2026-08-19-c921-genus-four-branch.md`; the Schottky-form route listed here
before was not needed.

## Structural handle found 2026-08-19

In the basis of the five axes other than the chosen one, the orthogonal
complement of the axis class is `{ x in Z^5 : sum x_i = 0 }` with the form
`6 <x,y>`: six times the `A_4` root lattice. So `A_b` is isogenous to
`E_b tensor_Z A_4`, uniformly in `b`. Two consequences to chase before more
computation: whether the literature on Jacobians isogenous to powers of an
elliptic curve settles `E tensor A_4` for every `b` rather than the generic one,
and whether the exceptional finite set is an intersection number of two cycles on
the Hilbert modular surface for `Q(sqrt 5)`.

## Counting the exceptional set (2026-08-19)

Igusa's Schottky form is a weight-eight cusp form on `Sp_8(Z)` cutting out the
closure of the genus-four Jacobian locus. Pulled back along the modular embedding
`E_b -> A_b`, whose Hodge bundle is four copies of `lambda_{E_b}`, it becomes a
section of `lambda_E^{32}`, nonzero because the generic member is not a Jacobian.
So the exceptional set has size `32 deg lambda_E = (8/3)[SL_2(Z):Gamma]` counted
with multiplicity, `Gamma` the stabilizer of the glue. The epilogue's `|ker f| =
6^4` and Smith type `(1,6,6,6,6)` give `Gamma` containing `Gamma(6)`, hence at
most `384` points; the odd multiplier of C914 may raise the glue exponent to `30`
and the crude bound to `46080`. Open input: the integral glued model of the
four-dimensional factor, recorded in the epilogue only two-adically and by
scalarity at three. Derivation in `../2026-08-19-c921-genus-four-branch.md`.
