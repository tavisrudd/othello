# C907 sharp carrier threshold for the `m=2` telescope

**Lane:** `clebsch`

**Status:** theorem-grade correction to the Silver target.  A universal
threefold bound by length one is sufficient but not necessary.  The positive
Krull--Schmidt telescope only requires that no center carry the endpoint's
length-three indecomposable.  Thus a bound by length two suffices, and the
landed self-dual length-two formal model does not obstruct `m=2`.

## Abstract cancellation lemma

Let `C` be an idempotent-complete Krull--Schmidt category, let `T` be an
autoequivalence, and let `lambda` be an isomorphism-invariant nonnegative
integer on indecomposables which is unchanged by `T`.  Suppose an
indecomposable object `E` has

\[
 \lambda(E)=3.
 \tag{1}
\]

If

\[
 E\oplus\bigoplus_a T^{r_a}A_a
 \simeq
 \bigoplus_b T^{s_b}B_b
 \tag{2}
\]

and every indecomposable summand of every `A_a` and `B_b` has `lambda<=2`,
then (2) is impossible.

Indeed Krull--Schmidt uniqueness forces the indecomposable `E` to be
isomorphic to an indecomposable summand on the right.  Tate invariance of
`lambda` would then give `3<=2`.  No additive formula for `lambda` and no
subtraction in `K_0` is used.

## Application to weak factorization

Assume strict enriched blow-up biproducts.  A weak factorization between
`Y_0=X x P^2` and `Y_N=P^5` gives the positive identity

\[
 \mathscr A(Y_0)\oplus
 \bigoplus_{i,j}T^j\mathscr A(Z_i^-)
 \simeq
 \mathscr A(Y_N)\oplus
 \bigoplus_{i,j}T^j\mathscr A(Z_i^+).
 \tag{3}
\]

The cubic packet of `P^5` is empty, while `A(Y_0)` contains the endpoint
length-three indecomposable.  Every nonzero center packet comes from a smooth
threefold; point, curve, and surface packets are empty.  Applying the abstract
lemma shows that the carrier input needed for `m=2` is only

\[
 \boxed{\text{every smooth projective threefold has enriched length at most
 two}.}
 \tag{4}

The exact weakest statement is to rule out a threefold realization of the
same length-three indecomposable signature as the endpoint.  The numerical
bound (4) is a clean sufficient condition, not an equivalent one: a different
length-three indecomposable could be harmless.  The stronger bound
`ell<=1` remains useful for the proposed all-dimensional formula and would
give extra structure, but it is not a Silver acceptance condition.

## Consequences for the landed regressions

The exact self-dual formal model with a nonzero one-step Rees extension has
length two.  It disproves a formal derivation of the stronger `ell<=1` bound,
but it does not challenge (4).  Likewise a smooth-discriminant Clifford
special fibre with square-zero radical is compatible with the sharp `m=2`
threshold.

The first genuine local threats are precisely the constructions with a
nonzero second composite: the nodal Clifford socle and the stationary
Picard--Lefschetz square.  They can support a three-step string.  The carrier
programme should therefore test whether those **second composites** survive
the strict value-localized Stokes/Gamma realization.  It need not kill every
first extension.

This correction does not itself prove (4).  It removes the wrong target and
changes the universal gate from

\[
 \text{all first extensions vanish}
 \quad\text{to}\quad
 \text{all twofold composites vanish (or no length-three block occurs).}
 \tag{5}

The conic-node and stationary-`A_5` audits already isolate exactly those
twofold composites.

## EJ/TT and mystery ledger

- **EJ:** apply Krull--Schmidt before trying to annihilate every extension.
  The endpoint only needs to be absent from the center signature.
- **TT:** ask for the weakest carrier statement the positive telescope
  consumes.  Length-two center blocks cannot combine into a length-three
  indecomposable under a strict biproduct.
- **Settled:** the sharp numerical sufficient carrier threshold is `<=2`, not `<=1`;
  the self-dual length-two formal countermodel is harmless for Silver.
- **Open:** exclude an actual length-three threefold carrier, equivalently the
  surviving second composites at nodal conic and del Pezzo degenerations;
  and prove the strict enriched blow-up biproduct used in (3).
