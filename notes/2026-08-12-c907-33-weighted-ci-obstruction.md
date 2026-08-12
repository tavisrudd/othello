# C907 weighted `(3,3)` complete-intersection obstruction

**Lane:** `clebsch`

**Status:** theorem-grade for the well-formed family
`X_(3,3) subset P(1^(6-l),3^l)`.

The first apparent weighted complete-intersection source of two independent
primitive-sixth pairs is the natural family

\[
 X_{3,3}\subset\mathbf P(1^{6-l},3^l).
\]

It supplies no new carrier.  This note makes no claim about arbitrary weight
vectors; it closes this specific two-cubic candidate family.

The weight-three stratum is `P^(l-1)`.  The restrictions of the two cubics to
it are two linear forms.  If `l>=3`, they have a common zero.  For the
well-formed cases `l=3,4`, the remaining weight-one normal directions have
nontrivial `mu_3` action of dimension `3` or `2`, respectively, so the coarse
intersection is singular there.  (`l>=5` is not well formed.)  The case
`l=0` is the ordinary Calabi--Yau `(3,3)` intersection, not Fano.  Hence the
only smooth Fano cases are the following.

1. `l=1`: each cubic is linear in the single weight-three coordinate.  One
   equation eliminates it and the other becomes a cubic in `P^4`.  Thus
   `X` is a cubic threefold.  Its hypergeometric period is
   
   \[
   \sum_{n\ge0}\frac{(3n)!}{(n!)^5}s^n,
   \qquad
   \theta^4-27s(\theta+1/3)(\theta+2/3),
   \]
   
   and its small-even framed multiplicity is `nu_6=2`.
2. `l=2`: the two cubics are generically an invertible linear system in the
   two weight-three coordinates, which eliminates both.  Thus `X` is
   `P^3`.  The two degree-three numerator factors cancel both weight-three
   denominator factors, leaving period `sum s^n/(n!)^4` and operator
   `theta^4-s`; it has `nu_6=0`.

So in this candidate family the two formal degree-three factors never produce
four primitive-sixth residues: the only smooth Fano realizations are the
already-known cubic and projective-space models.

## Source boundary

- Coates--Corti--Iritani--Tseng, arXiv:1310.4163, Theorem 31: the weighted
  projective `I`-function.
- Coates--Givental, arXiv:math/0110142, Theorem 2: quantum Lefschetz.
- Cai, arXiv:2608.01577, Sections 2--3: framed threefold residue convention.

## Mystery ledger

- **Settled:** the most economical two-cubic weighted-CI construction is
  geometrically forced to cancel its second prospective primitive pair.
- **Open:** degrees `(3,6)` or other non-linear weighted complete
  intersections, where smoothness does not automatically make every
  degree-three factor eliminable.
