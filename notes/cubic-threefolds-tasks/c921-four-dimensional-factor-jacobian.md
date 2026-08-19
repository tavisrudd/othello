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
four-dimensional abelian variety isogenous to `E_b^4`;
the sublattice has odd index `25`. **Corrected 2026-08-19:** `A_b` is not
principally polarized; its integral model has determinant `25` and symplectic
type `(1,1,1,5)`, and the six principal polarizations available to it
correspond to the six order-five subgroups of `E_b[5]`. C914's report calls it
principally polarized and records rank-eight elementary divisors
`(3,3,3,3,3,3,15,15)`; its script glues only the two-primary kernel, so those
divisors belong to a partially glued lattice. C914's conclusion is unaffected
and strengthened, since it needed the divisors to be odd. See
`../2026-08-19-c921-integral-glued-model.md`. No further orthogonal odd-index splitting
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

## The integral glued model and the Schottky count (2026-08-19)

Both are done. Report and evidence bundle:
`../2026-08-19-c921-integral-glued-model.md`.

The model is `L_4 = (A_4(6) tensor M) + K_2 + K_3`, rank eight, determinant `25`,
symplectic type `(1,1,1,5)`, where `A_4(6)` is the `A_4` root lattice with its
form multiplied by six, `M = H_1(E_b, Z)`, `K_2` is the exotic `F_4`-graph and
`K_3 = H_3 tensor C` for a line `C` in `E_b[3]`. Because `kappa(v,v) = 5` is a
unit at two and three, the whole `6^4` glue lies inside the four-dimensional
factor and the index-`25` separation from the elliptic factor is purely
five-adic.

The count is `32 deg lambda_E = 64` per choice of principal polarization, and
`384` on the six-sheeted five-torsion cover carrying all six. It never depended
on the glue exponent: `deg lambda_E = 2` is a Griffiths-residue computation on
the pencil, `H^{2,1} = W_5 tensor O_B(2)`. The earlier bounds of `384` under a
glue exponent of six and `46080` under a glue exponent of thirty were bounds on
the wrong invariant. `64` is an upper bound rather than a value: the Schottky
divisor also contains the decomposable locus, the count is with multiplicity,
and the Schottky form is a cusp form so it vanishes at the pencil's singular
members.

Two by-products. The pencil's elliptic factor must have square discriminant
(mod-two monodromy inside the order-three subgroup of `GL_2(F_2)`, forced by the
exotic kernel being a section) and a rational three-isogeny; neither has been
checked against an explicit Weierstrass model. And the standing literature
question — for which lattices `L` is `E tensor L` a Jacobian — should be asked
about the glued overlattice carrying one of the six principal polarizations,
not about the naive product `E_b tensor A_4`.

**Highest-value follow-up.** Compute the vanishing orders of the Schottky
pullback at the pencil's singular members. If they total `64`, no smooth member
has a four-dimensional factor in the closure of the Jacobian locus for any of
the six polarizations, which upgrades the genus-four verdict from "all but
finitely many" to "every".

## Level structure and Eckardt locus (2026-08-19)

Report: `../2026-08-19-c921-pencil-level-structure-and-eckardt.md`.

Both predictions above are confirmed against the explicit rational model of the
pencil, over 112 smooth members across five finite fields: the elliptic factor
has square discriminant and a rational three-isogeny. Point counts recover its
Frobenius trace through `#X_b(F_q) = q^3+q^2+q+1-5q a_b`, whose divisibility by
`5q` on every smooth member independently confirms the isotypic decomposition
`H^3 = W_5 tensor H^1(E_b)(-1)`.

The Eckardt locus of the pencil is **not** empty. By elimination over `Q`, the
smooth members carrying an Eckardt point are exactly the conjugate pair
`b = 3 omega, 3 omega-bar`, the roots of `b^2 + 3b + 9`, each carrying thirty
Eckardt points — the two Fermat members, which represent a single point of the
coarse-moduli image. The same elimination gives the pencil's singular locus
exactly: six members, `b = 0` (the Segre cubic), `b = -6`, the `Q(sqrt 5)` pair
`b^2 - 3b - 9`, and the `Q(sqrt -3)` pair `7b^2 + 3b + 9`. An independent point-
count sweep over five primes agrees with both loci.

So the epilogue's `prop:A5-not-coprime` and `prop:A5-nonseparated` cannot be
upgraded to "none", and `thm:separation-family` keeps a qualifier — necessarily,
since the Fermat member is of separated-variable type. What is available instead
is exact: both propositions can name the Fermat pair rather than say "only
finitely many", and `thm:separation-family` can say "every point of its
coarse-moduli image except the Fermat point". No manuscript edit follows
automatically; adopting it is the author's call.
