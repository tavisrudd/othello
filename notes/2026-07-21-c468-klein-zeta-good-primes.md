# C468 — Klein cubic zeta at good primes 31, 41, and 61

Date: 2026-07-21

## Verdict

Let

`X: x0^2*x1 + x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^2*x0 = 0`.

All three reductions are smooth.  Writing `P_p(X)=det(X-Frob_p | H^3)`, the exact answers are

```
P_31(X) = X^10 + 222591649025 X^5 + 31^15,
P_41(X) = X^10                         + 41^15,
P_61(X) = X^10                         + 61^15.
```

The headline is positive, but not for the quintic-character reason suggested by the task card.
At 31 the splitting field is exactly `Q(zeta_5,sqrt(-11))`, and an exact order-11 Gauss-product
calculation gives the live fifth trace.  Thus the golden `C4` and the Gauss quadratic field really
do occur in one good-prime zeta function.  The Delsarte exponent lattice has determinant 33, not a
factor of 5: its nontrivial projective character tuples have order 11.  `zeta_5` enters through the
cyclic five-coordinate symmetry and the resulting fivefold eigenvalue orbits, not through quintic
Jacobi sums.

The zeta data are blind to C453's fusion bit.  The fused primes 31 and 41 already have different
split/inert spectra, whereas fused 41 and visible 61 have the same inert structural shape.
This is structural rather than accidental: C453 fusion is a residue condition modulo 40, while
activation of the Delsarte tuples is controlled by the order of `p` modulo 11.  The two signals are
independent under the Chinese remainder theorem.

## Smoothness

If one coordinate of a singular point vanishes, the five gradient equations propagate that zero
around the cycle, contradicting projectivity.  In the open torus put `y_i=x_i^2*x_(i+1)`.
Multiplying the `i`th gradient equation by `x_i` gives

`2*y_i + y_(i-1) = 0`.

Going around the cycle gives `33*y_i=0`.  Since none of 31, 41, and 61 divides 33, there is no
geometric singular point.  As a finite check independent of that argument, exhaustive normalized
projective scans over each base field found zero singular points.

## Counts and traces

For `q=p^k`,

`#X(F_q) = 1 + q + q^2 + q^3 - tr(Frob_p^k | H^3)`.

| p | k | q | trace on H3 | #X(F_q) |
|---:|---:|---:|---:|---:|
| 31 | 1 | 31 | 0 | 30784 |
| 31 | 2 | 961 | 0 | 888428164 |
| 31 | 3 | 29791 | 0 | 26440509694144 |
| 31 | 4 | 923521 | 0 | 787663636680510724 |
| 31 | 5 | 28629151 | -1112958245125 | 23465262812585959785029 |
| 41 | 1 | 41 | 0 | 70644 |
| 41 | 2 | 1681 | 0 | 4752931684 |
| 41 | 3 | 68921 | 0 | 327386684567124 |
| 41 | 4 | 2825761 | 0 | 22563498285294240964 |
| 41 | 5 | 115856201 | 0 | 1555098328414197336897204 |
| 61 | 1 | 61 | 0 | 230764 |
| 61 | 2 | 3721 | 0 | 51534223924 |
| 61 | 3 | 226981 | 0 | 11694197613435484 |
| 61 | 4 | 13845841 | 0 | 2654349166004913001444 |
| 61 | 5 | 844596301 | 0 | 602486785248383316309337804 |

Newton identities give the first five coefficients from these traces.  The weight-three
functional equation gives the remaining five.  Here the first four traces vanish, so only the
middle coefficient can be nonzero, and it is `-tr(F^5)/5`.  Every displayed root has absolute
value `p^(3/2)`, and substitution verifies all counts and the functional equation.

## Exact Delsarte/Gauss-sum route

On the full torus, the exponent constraints are

`m_(i-1) = -2*m_i` and `sum(m_i)=0 (mod q-1)`.

The cycle condition gives `33*m_i=0`, while the projective condition kills the order-3 solutions.
Only order-11 tuples remain.  Their exponent pattern is

`a*(1,5,3,4,9) (mod 11)`, for `a=1,...,10`.

Now `ord_11(31)=5`, while `ord_11(41)=ord_11(61)=10`.  Consequently no nontrivial tuple occurs
for `k<=5` except at `(p,k)=(31,5)`.  All proper-support strata have only their trivial-character
terms.

For the exceptional case, the checker constructs `F_(31^5)=F_31[t]/(t^5+t+11)`, with primitive
element `g=t+1`.  It computes the ten Gauss products exactly in
`Z[zeta_31,zeta_11]`, reduces in the `30*10` power basis, and obtains the rational integer

`sum Gauss-products = 31863049656378638875`.

Hence

`tr(F^5 | H^3) = -(sum Gauss-products)/31^5 = -1112958245125`.

The independently optimized curve reduction gives `T(31^5)=38874` and the same value from
`tr=-q*(1+T)`.  Before using the Delsarte formulas, direct torus enumeration at 31 verified every
stratum type (affine counts per support):

| support type | count |
|---|---:|
| all 5 | 783870 |
| each 4-set | 26100 |
| each consecutive 3-set | 900 |
| each split 3-set | 0 |
| each adjacent 2-set | 0 |
| each nonadjacent 2-set | 900 |
| each 1-set | 30 |

## Factorization and fields

Over `Q`,

```
P_31 = (X^2 + 155 X + 29791)
       (X^8 - 155 X^7 - 5766 X^6 + 5511335 X^5 - 682482019 X^4
        + 164188180985 X^3 - 5117346224646 X^2
        - 4098141434904005 X + 787662783788549761),

P_41 = (X^2 + 41^3)(X^8 - 41^3 X^6 + 41^6 X^4 - 41^9 X^2 + 41^12),
P_61 = (X^2 + 61^3)(X^8 - 61^3 X^6 + 61^6 X^4 - 61^9 X^2 + 61^12).
```

These are the irreducible factorizations.  If `pi_p` is a root of

`U^2 - a_p U + p`, with `(a_31,a_41,a_61)=(-5,0,0)`,

then the ten eigenvalues are exactly

`p*pi_p*zeta_5^j` and `p*conj(pi_p)*zeta_5^j`, for `j=0,...,4`.

At 31 the middle coefficient is `31^5*7775`, and the discriminant of the quadratic in `X^5` is
`-11*(2217*31^5)^2`.  Thus the exact Gauss quadratic field `Q(sqrt(-11))` is already visible in
the polynomial itself, independently of numerical root recognition.

## All extensions and Frobenius-power upgrade

The sparse polynomials give every extension count for free.  Put `c_31=222591649025` and
`c_41=c_61=0`.  For each prime let

`u_0=2`, `u_1=-c_p`, and `u_m=-c_p*u_(m-1)-p^15*u_(m-2)`.

Then, for every `k>=1`,

```
tr(F^k | H^3) = 0       if 5 does not divide k,
tr(F^(5m) | H^3) = 5u_m.
```

Together with the trace formula, this is a closed exact formula for `#X(F_(p^k))` at all
extensions, not just the five used to recover the polynomial.

Cayley--Hamilton also gives the operator identity

`F^10 + c_p F^5 + p^15 I = 0`.

Thus at the inert controls 41 and 61 one gets the especially sharp quasi-scalarity
`F^10=-p^15 I`.  At 31, `F^5` instead has exactly two `Q(sqrt(-11))`-conjugate eigenvalues, each
with multiplicity five.  This is the good-prime version of the quasi-scalarity question that was
vacuous at the singular prime 11.

There is also an extremal tower consequence at 41 and 61.  For every `r>=1`,

`tr(F^(10r) | H^3) = 10*(-p^15)^r`.

Its absolute value is the full Weil bound `10*(p^(10r))^(3/2)`.  Consequently the point count is
above the `P^3` baseline by that amount for odd `r` and below it for even `r`: these reductions
alternate between the two `H^3`-extremal signs throughout the degree-10 tower.

## Newton-polygon upgrade

The same eigenvalue description fixes the `p`-adic slopes.  At 31, the two CM-conjugate elliptic
eigenvalues have valuations 0 and 1, so the `H^3` slopes are `1^5,2^5`; after the Tate untwist to
weight one they are `0^5,1^5`, the ordinary polygon.  At 41 and 61, `pi_p^2=-p`, so all ten `H^3`
slopes are `3/2`; the weight-one slopes are all `1/2`, the supersingular polygon.  Under the
standard cubic-threefold intermediate-Jacobian realization of `H^3(1)`, this says that the
good-prime intermediate Jacobian is ordinary at 31 and supersingular at 41 and 61.

Equivalently, its `p`-rank is 5 at 31 and 0 at 41 and 61.  The Newton polygon alone does not fix
the finer `a`-number, and this bundle makes no claim about it.

Thus fusion blindness persists at a substantially coarser arithmetic level: fused 31 is ordinary,
whereas fused 41 and visible 61 are both supersingular.  The Newton type follows the mod-11
Gauss/CM signal, independently of the mod-40 fusion signal.

This also gives an independent check from the CM curve
`y^2+y=x^3-x^2-7x+10`: direct base-field counts give traces `-5,0,0` at 31, 41, 61,
and the fifth-power recurrence reproduces the three middle coefficients.

There is a sharper carrier decomposition behind the rational `2+8` factorization.  With `a_p` as
above,

```
P_p(X) = product_(j=0)^4 (X^2 - p*a_p*zeta_5^j*X + p^3*zeta_5^(2j)).
```

The `j=0` term is the rational quadratic factor and carries the Gauss/CM quadratic field alone.
The product over `j=1,...,4` is the octic norm

`Norm_(Q(zeta_5)/Q)(X^2-p*a_p*zeta_5*X+p^3*zeta_5^2)`.

Thus the octic factor is the exact carrier where the golden `C4` and the quadratic field meet; the
quadratic factor is the trivial `C5` character, and the octic is the rational package of the four
nontrivial characters.  This explains both irreducible degrees and the splitting fields without
root recognition.

The field statement sharpens further.  In every case `Q(zeta_5)` and the listed Gauss quadratic
field intersect only in `Q`, so the full Galois group is `C4 x C2`.  Its orbit on the quadratic
roots has size 2, while its orbit on the octic roots is regular of size 8.  Thus “meeting” means
simultaneous, commuting action on one irreducible octic carrier, not a nontrivial intersection of
the two number fields.

| p | splitting field | contains zeta5 | contains sqrt(-p) | contains sqrt(p*) | other quadratic |
|---:|---|---|---|---|---|
| 31 | `Q(zeta5,sqrt(-11))` | yes | no | no | `sqrt(-11)` |
| 41 | `Q(zeta5,sqrt(-41))` | yes | yes | no | none |
| 61 | `Q(zeta5,sqrt(-61))` | yes | yes | no | none |

Here every prime is `1 mod 4`, so `p*=p`.  Every eigenvalue multiset is closed under multiplication
by fifth roots of unity.  There is no identification with quintic Jacobi sums: the exact character
calculation uses order 11, and this correction is part of the result rather than a missing check.

## Reproducibility and scope

The canonical certificate is `notes/2026-07-21-c468-klein-zeta-good-primes.json`.  Its generator
compiles and runs both Rust checkers in a temporary directory.  `low_checks.rs` independently
enumerates all base-field projective points, all `F_(p^2)` curve pairs, and the 31-strata controls.
`trace31k5.rs` contains both the determinant-11 `O(q)` curve solver and the exact cyclotomic
Gauss-product calculation.

Replay from the repository root:

```
python3 notes/2026-07-21-c468-klein-zeta-good-primes-scripts/generate.py --check
sha256sum -c notes/2026-07-21-c468-klein-zeta-good-primes.sha256
```

Trusted boundary: stable `rustc`, Python 3, exact integer and finite-field arithmetic, and the
standard cohomological trace formula/weight-three functional equation.  The computation makes no
novelty or priority claim and no conductor, Swan, Neron-model, H4, or continuation claim.
