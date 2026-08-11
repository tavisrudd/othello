# C904 Poincare-cubic Fano factor-four obstruction

Date: 2026-08-10
Status: exact negative closure; research note only
Scope: the proposed `tau^[7]` / `P^3/3!` relative-cycle bypass

## Verdict

The proposed construction is not primitive.  With

`P=m^*Theta-p_1^*Theta-p_2^*Theta`

and the Fano normalization `[F]=Theta^3/3!`, exact exterior algebra gives

`int_(F x F) (a x a)^*(P^3/3!) (u tensor v) = 4 Omega(u,v)`.

Thus a cycle `S=tau^[7]` whose Abel--Jacobi class is `P^3/3!`, followed by
the standard line correspondences, acts by multiplier `+4` on the integral
symplectic lattice.  If the Poincare class is defined from the difference
map instead of the sum map, the sign is `-4`.  In neither convention is the
scalar `+/-1`.

This reproduces the existing two-primary ceiling and does not construct a
primitive relative cycle.

## Exact calculation

Take a Darboux basis

`(a_1,b_1,...,a_5,b_5)`

with `Theta=sum_i a_i b_i`.  On the product,

`P=sum_i (a_i^(1)b_i^(2)-b_i^(1)a_i^(2))`.

For example, insert `u=a_1^(1)` and `v=b_1^(2)`.  The top-degree coefficient
in

`Theta_1^3/3! * Theta_2^3/3! * P^3/3! * u * v`

is four.  One Poincare factor must supply
`-b_1^(1)a_1^(2)` to complete the first symplectic index.  The remaining
two Poincare factors must be the complementary pair at exactly one of the
four remaining indices.  The theta powers fill the other three indices.
All four choices have the same sign.  Equivariance then gives the full
matrix `4 Omega`.

The same count yields a small general theorem.  If a ppav of dimension `g`
contains a minimal surface with class `Theta^(g-2)/(g-2)!`, then

`int_(F x F) (P^3/3!) (u tensor v) = (g-1) Omega(u,v)`

up to the convention sign for `P`.  The multiplier is therefore forced by
dimension, not by the special `A5` gluing.

More generally, for a minimal `d`-fold
`[Y]=Theta^(g-d)/(g-d)!`, the normalized kernel
`P^(2d-1)/(2d-1)!` restricts on `Y x Y` with scalar of magnitude

`binomial(g-1,d-1)`.

Indeed the external one-forms and one Poincare factor occupy one symplectic
index; the other `2d-2` Poincare factors form complementary pairs on a
choice of `d-1` among the remaining `g-1` indices.  For `g=5` the signed
row is `(-1,4,-6,4,-1)` for `d=1,...,5` in the present convention.  Hence
every proper intermediate carrier dimension `d=2,3,4` has even multiplier.
Only the minimal curve (the class being sought) or the whole Jacobian gives
an odd scalar.  This is a dimension-five parity wall, not merely a failure
of the Fano surface.

Lucas's theorem gives the uniform mod-two form: the multiplier is odd if and
only if every binary `1`-digit of `d-1` is also a `1`-digit of `g-1`.  Since
`g-1=4=100_2` for the cubic intermediate Jacobian, only `d-1=0` and `4`
survive.  Multiplying the carrier's minimal Lefschetz class by any integer
cannot repair the even intermediate cases.  A successful proper carrier in
dimension five must therefore use a genuinely non-Lefschetz/primitive
cohomology component, not just another multiple of a minimal class.

## Replay

```sh
python3 notes/2026-08-10-c904-poincare-cubic-fano-replay.py
diff -u notes/2026-08-10-c904-poincare-cubic-fano-replay.out \
  <(python3 notes/2026-08-10-c904-poincare-cubic-fano-replay.py)
```

The script constructs the full 20-generator exterior algebra over
`fractions.Fraction`, prints all ten nonzero matrix entries, and verifies
that the kernel is exactly `4 Omega`.  The one-index combinatorial argument
above is an independent proof and fixes the normalization and sign.

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-10-c904-poincare-cubic-fano-replay.py` | 4,311 | `239c71459671bd40a2e81f4435883b5af920f173af6a59c6247eeaf1f96e3bcd` |
| `notes/2026-08-10-c904-poincare-cubic-fano-replay.out` | 761 | `79b45d8d31ccd93a4f417f1256aaa5975f194e79405881a17b2319d4e292beac` |

## Consequence

The `tau^[7]` idea remains useful only as an explicit relative
multiplier-four correspondence.  It cannot resolve any of the primitive
two-local gates without an additional algebraic division by two (in fact by
four at this stage).  The highest-value constructive route returns to the
explicit divisor-monomial cycle or a genuinely integral-at-two class on the
theta resolution.

## Mystery ledger

- **Settled:** scalar magnitude is exactly four, not one.
- **Settled:** changing sum/difference convention changes only the sign.
- **Settled:** the factor is the general dimension multiplier `g-1` for a
  minimal surface, not an unexplained feature of the exotic gluing.
- **Open:** whether the multiplier-four relative cycle combines with an
  independent odd correspondence to produce a primitive Bezout identity.
