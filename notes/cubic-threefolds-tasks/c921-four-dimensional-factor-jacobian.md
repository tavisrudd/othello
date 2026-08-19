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

- [ ] `A_b` is the Jacobian of an irreducible genus-four curve. The `D_5`
  stabilizer of the chosen axis acts on `A_b`, and genus-four curves with a
  faithful `D_5`-action form a one-dimensional family, so the dimensions match;
  the Jacobian locus is a divisor in `A_4`, cut out by the Schottky form.
- [ ] `J(X_b)` is odd-degree isogenous to the Jacobian of an irreducible
  genus-five curve, with no product decomposition involved.

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

## Suggested attacks

- Roulleau's `D_5`-fibration of the Fano surface: identify `A_b` as a Prym or
  as the Jacobian of the quotient curve, which would settle the first bullet
  geometrically rather than numerically.
- Evaluate the Schottky form on a numerically computed period matrix of `A_b`
  for one non-CM member, as a decisive negative if it does not vanish.
- The Klein cubic threefold is a member of this pencil with CM factor; its
  `A_b` may be recognizable in the literature and is a cheap test case, though
  a single CM member decides nothing about the generic one.
