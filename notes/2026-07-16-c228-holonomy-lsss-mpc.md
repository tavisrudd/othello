# C228 holonomy and multiplicative ideal secret sharing

**Lane:** `rp-next`
**Status:** COMPLETE — decisive negative for the certified C217 pair; bounded search stopped.

## Result at a glance

C217's two support-identical, monomially inequivalent `GF(9)` representations do **not** differ in
ordinary or strong multiplicativity under the standard ideal linear secret-sharing construction.
For every choice of dealer in either four-point representation:

```text
access structure:          2-of-3
ordinary multiplicative:   yes
strongly multiplicative:   no
```

This agreement has a general structural explanation.  A rank-two representation consists of
projective points `[pi_i] in P(E*)`.  Ordinary multiplicativity of the associated ideal LSSS asks
whether

```text
pi_dealer tensor pi_dealer
    in span {pi_i tensor pi_i : i is a participant}.      (1)
```

Thus it is controlled by the quadratic Veronese image.  Any four distinct points of `P^1` map to
four points on a nondegenerate conic in `P^2`; every three are independent.  Both C217
representations therefore induce the same square matroid `U(3,4)`, regardless of their different
cross-ratio holonomies.  Its dealer port is `3-of-3`, so the full three-player set satisfies (1),
but no two-player set does.

Holonomy changes the numerical recombination vector after coordinates are normalized, but those
numbers are gauge-dependent.  It does not change the existence of a recombination vector in this
family.  This is the exact negative boundary required by the C228 stop rule; no representation
census is warranted.

## Dealer and primal/dual convention

Use the linear-form convention of Cramer--Damgard--Maurer.  Let `E` be a two-dimensional vector
space over `GF(9)` and let the four represented matroid points be nonzero forms

```text
pi_i : E -> GF(9).
```

Choose `x` as dealer.  To share `s`, choose `w in E` uniformly subject to `pi_x(w)=s`, and give
participant `i` the ideal one-symbol share `pi_i(w)`.  After an information-basis change sending
`pi_x` to `(1,0)`, this is the usual MSP convention: choose `(s,rho)` and take row inner products.
A coalition `A` reconstructs exactly when `pi_x` lies in the span of `{pi_i:i in A}`.  Hence its
minimal qualified coalitions are the circuits through `x`, with `x` removed, matching the complete
repair port without reversing the access structure.

For the C217 restrictions the matroid is `U(2,4)`.  It is identically self-dual, so switching to the
dual matroid convention produces the same `2-of-3` port.  The conclusion is therefore not an
artifact of the primal/dual choice.

In the affine axis coordinates used by C217,

```text
pi_t(a,b)=a+t b.                                          (2)
```

Any two distinct participant forms span `E*`, while one form does not span the dealer form.  Thus
every dealer choice gives exactly the threshold access structure with all participant pairs
minimal qualified.

## Ordinary multiplicativity

For two sharings `w=(a,b)` and `w'=(a',b')`, participant `t` can locally multiply its shares to
obtain

```text
q(t)=(a+t b)(a'+t b'),                                   (3)
```

where `q(T)` has degree at most two.  If the dealer parameter is `d` and the three participant
parameters are `t_1,t_2,t_3`, Lagrange interpolation gives

```text
q(d)=sum_i lambda_i q(t_i),

lambda_i = product_(j != i) (d-t_j)/(t_i-t_j).            (4)
```

Equation (4) is exactly the ideal-LSSS tensor criterion (1).  The denominators are nonzero because
the four projective points are distinct.  Therefore ordinary multiplicativity holds for every
four-point `U(2,4)` representation, over any field where the four points exist; the cross-ratio is
irrelevant to existence.

Equivalently, the symmetric tensor square sends

```text
[1:t] |-> [1:t:t^2].                                     (5)
```

Three distinct images on this conic form a basis of `Sym^2(E*)`.  The square access structure
`Gamma^mu` from the standard ideal criterion is consequently `3-of-3`.  Since it is nonempty, the
scheme is multiplicative.

## Strong multiplicativity and the support obstruction

Strong multiplicativity requires (1) after deleting every unqualified adversary set.  In the
`2-of-3` port, every singleton is unqualified.  Delete one participant and let the two remaining
parameters be `u,v`.  The product of linear polynomials

```text
(T-u)(T-v)                                                (6)
```

vanishes at both remaining participants but is nonzero at the distinct dealer parameter `d`.
Thus no linear combination of those two local products can recover the dealer product.  In
Veronese language, no three distinct points of a nondegenerate conic are collinear, so the dealer
square is outside the span of any two participant squares.

There is also an access-structure-only obstruction.  The `2-of-3` structure is `Q^2`: two
unqualified sets cannot cover all three participants.  It is not `Q^3`, since the three unqualified
singletons do cover them.  The general existence theorem says that strongly multiplicative LSSSs
exist exactly for `Q^3` access structures.  Hence no alternative realization or nonideal expansion
can make this access structure strongly multiplicative; failure is not special to the two C217
matrices.

## Gauge invariance and the holonomy boundary

The criterion is invariant under every representation gauge relevant to C217.

- A global information-basis change `pi_i -> pi_i G` applies the invertible map `G tensor G` to
  both sides of (1).
- A coordinate rescaling `pi_i -> c_i pi_i` rescales its tensor square by `c_i^2`.  If
  `(lambda_i)` recombines the original shares, then

  ```text
  lambda_i' = c_x^2 c_i^(-2) lambda_i                    (7)
  ```

  recombines the gauged shares.
- Independent circuit scalars only renormalize dependency equations; they do not alter the
  projective forms used by the LSSS.

Therefore multiplicativity is a well-defined property of the C217 gauge class.  More generally,
coefficient geometry can affect the represented matroid of the tensor squares and hence can affect
multiplicativity.  What C228 proves is the bounded statement needed here: on four points of a
projective line, the Veronese support is always `U(3,4)`, so the two cross-ratio holonomy classes
cannot separate.

The recombination vectors themselves do differ in the fixed affine gauge.  With dealer `0`, the
certificate finds

```text
parameters (0,1,3,4), holonomy 2:  (lambda_1,lambda_3,lambda_4)=(6,3,1),
parameters (0,1,2,8), holonomy 3:  (lambda_1,lambda_2,lambda_8)=(3,5,5).
```

These raw values are not operational invariants: equation (7) can change each one independently by
a nonzero square ratio.  The gauge-invariant yes/no property is identical.

## Verification

[`2026-07-16-c228-holonomy-lsss-mpc.py`](2026-07-16-c228-holonomy-lsss-mpc.py)
imports C217's exact `GF(9)` arithmetic and cross-ratio conventions.  For both certified parameter
sets and all four dealer choices, it:

- reconstructs the distinct holonomies `2` and `3` and their disjoint anharmonic orbits;
- checks the Lagrange tensor-square recombination identity;
- confirms rank three for all three participant squares;
- proves failure after every singleton deletion both by rank and by the vanishing product (6);
- replays nonconstant coordinate gauges using (7); and
- replays an invertible global information-basis change.

All checks pass.  The deterministic certificate is
[`2026-07-16-c228-holonomy-lsss-mpc.json`](2026-07-16-c228-holonomy-lsss-mpc.json).

## Prior-art boundary

- Cramer, Damgard, and Maurer define MSP sharing with target `(1,0,...,0)`, multiplicativity by a
  local-product recombination vector, strong multiplicativity after every rejected-set deletion,
  and the `Q^2`/`Q^3` existence boundary in
  [*General Secure Multi-party Computation from any Linear Secret-Sharing Scheme*](https://doi.org/10.1007/3-540-45539-6_22).
- Cramer et al. state the ideal criterion (1), package the tensor squares as a new vector-space
  access structure `Gamma^mu`, and connect ideal LSSSs with represented matroid ports in
  [*On Codes, Matroids, and Secure Multiparty Computation From Linear Secret-Sharing Schemes*](https://doi.org/10.1109/TIT.2008.921692),
  with an open full-text version at [IACR ePrint 2004/245](https://eprint.iacr.org/2004/245.pdf).
- Farras reviews the exact circuit-through-the-dealer definition of a matroid port and the
  representable/ideal direction in
  [*Secret Sharing Schemes for Ports of Matroids of Rank 3*](https://eprint.iacr.org/2020/008.pdf).

The interpolation calculation is the three-player Shamir threshold argument, and no novelty is
claimed for it, the Veronese reformulation, or the `Q^3` obstruction.  The C228 contribution is a
decisive application boundary for the already certified C217 holonomy pair: its distinct
coefficient moduli do not change multiplicative-LSSS capability at this smallest support.

The load-bearing cached EUROCRYPT source was checked at

```text
10.1007/3-540-45539-6_22
sha256 f89720b98a76ca6394a416ff7c16a5b37e7458131a05507595678d7d9b2218f7
```

The shared literature cache verification reported 18 entries and zero hash problems.  The two
IACR ePrint full texts were source-checked through the authoritative browser endpoint; their raw
download endpoint returned HTTP 403 to the cache client, so no cache hash is claimed for them.

## Disposition

C228 satisfies the negative-boundary gate and stops.  Both support-identical representations are
ordinary multiplicative and not strongly multiplicative for every dealer choice.  The symbolic
criterion factors through the quadratic Veronese matroid, which is `U(3,4)` throughout this family,
and therefore exposes no dependence on C217 holonomy.

This does not say holonomy is universally invisible to MPC: larger or higher-rank representations
can have tensor-square matroids that vary within one support matroid.  It says the allocated q=9
pair cannot witness that phenomenon.  Per the handoff, no open-ended representation census follows.
C226--C228 are now complete, so the `rp-next` lane has reached its planned endpoint.
