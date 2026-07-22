# C451 / T4 — Roquette matching Lagrangians and the theta judgment gate

**Lane:** `crowns`

**Date:** 2026-07-21

**Status:** complete; Lagrangian and Cartier--Manin statements GREEN, theta sheet discriminator DEAD

**Source depth:** one source read at `partial` depth: Mumford's Proposition 6.1 and its complete
proof on scanned PDF pages 107--109 (printed labels 3.95--3.97).

## Exact pre-gate result

For the smooth hyperelliptic curve

```text
C_q : y^2 = x^q - x,                 q in {5,7,11},
```

the branch set is `B=P^1(F_q)`, of size `q+1=2g+2`, where `g=(q-1)/2`.  The certificate uses the
standard model

```text
J(C_q)[2] = {even subsets of B} / (S ~ B-S),
<S,T> = |S intersect T| mod 2.
```

For every frozen perfect matching `M`, the classes of its edges span a `g`-dimensional isotropic
subspace `L_M`, hence a Lagrangian.  The only relation among the `g+1` edge classes is their sum,
the class of all of `B`.  Every frozen `PSL_2(q)` sheet is therefore a packing of `q`
matching-Lagrangians whose distinguished Weierstrass pair classes partition all
`binom(q+1,2)` pairs exactly once.

The complete packing-incidence calculation is:

| type | `q` | genus | sheets | unordered pairs within each sheet by `dim(L_M intersect L_N)` |
|:---|---:|---:|:---:|:---|
| A3 | 5 | 2 | one of size 5 | `0^10` |
| B3 | 7 | 3 | two of size 7 | `1^21` on each sheet |
| H3 | 11 | 5 | two of size 11 | `1^55` on each sheet |

Thus the A3 factorization gives five pairwise-transverse Lagrangians.  In B3 and H3, every two
same-sheet matchings have a two-component alternating union, and their Lagrangians meet in the
line represented by either component.  Linear algebra in the even-subset quotient and the
independent alternating-cycle formula agree on every pair.

For the Cartier--Manin computation, write `m=(q-1)/2`.  The support of

```text
(x^q-x)^m = sum_(k=0)^m binom(m,k)(-1)^(m-k) x^(m+(q-1)k)
```

contains no exponent `qi-j` with `1 <= i,j <= m`: modulo `q-1`, such an equality would require
`i-j` to equal `m`, but `|i-j| <= m-1`.  In the convention

```text
H[i,j] = coefficient of x^(q(i+1)-(j+1)),
```

the Cartier--Manin matrices are therefore the zero matrices of sizes `2`, `3`, and `5` at
`q=5,7,11`.  Each Jacobian has `p`-rank zero and `a`-number `g`; equivalently it is superspecial,
and in particular supersingular.

## Approved theta model and finite Riemann--Mumford check

The marked gate approved Mumford's hyperelliptic subset model.  In present notation its theta
characteristics are

```text
kappa_T = sum_(b in T) W_b + ((g-1-|T|)/2) L,
|T| = g+1 mod 2,                       T ~ B-T,
```

and, after replacing `T` by its complement so that `|T| <= g+1`,

```text
h^0(kappa_T) = (g+1-|T|)/2.
```

For odd `g`, take the full-branch-symmetry-invariant origin `kappa_empty`.  The approved quadratic
refinement is

```text
Q([S]) = h^0(kappa_S) + h^0(kappa_empty) = |S|/2 mod 2.
```

Its well-definedness under `S ~ B-S` holds **exactly because `g` is odd**:

```text
Q([B-S]) - Q([S]) = (g+1) mod 2 = 0.
```

At q=5, `g=2` is even, so this difference is one.  The checker tests all 16 even-subset classes;
all 16 representatives disagree with their complements.  Thus A3's exclusion is forced, not a
missing convention, and its single packing supplies no two-sheet comparison.

The certificate does not consume the Riemann--Mumford quadratic relation as prose.  It enumerates
all even-subset classes and every ordered pair, verifying

```text
Q(S symmetric_difference T) = Q(S) + Q(T) + |S intersection T| mod 2
```

on `64^2=4,096` pairs at q=7 and `1,024^2=1,048,576` pairs at q=11.  It separately checks the
Mumford `h^0` formula against `|S|/2` on every class, counts both quadratic fibres, derives the Arf
invariant from the count, and verifies that it equals the parity of the origin.

| type | origin `h^0` | origin parity / Arf | `Q` on every nonzero same-sheet intersection | `Q|L_M` on each Lagrangian |
|:---|---:|:---:|:---:|:---:|
| B3, q=7 | 2 | `0 / 0` | `0` on all `21+21` lines (weight 4) | `4` zeros, `4` ones |
| H3, q=11 | 3 | `1 / 1` | `1` on all `55+55` lines (weight 6) | `16` zeros, `16` ones |

The q=11 Arf-one result is the required behavior of the approved model, not an anomaly: its origin
has odd `h^0`.  The two primes have opposite origin parity, but within either prime the two packing
signatures are identical.  Therefore theta parity **does not separate the sheets**.

## Load-bearing source pin and odd-characteristic boundary

**Mumford, David, *Tata Lectures on Theta II: Jacobian Theta Functions and Differential
Equations*, Progress in Mathematics 43 (1984), DOI
[`10.1007/978-0-8176-4578-6`](https://doi.org/10.1007/978-0-8176-4578-6).** Read depth: `partial`.
The exact 1984 scan formerly hosted by the author was recovered from the 2016-05-09 Internet
Archive capture and cached under key `10.1007/978-0-8176-4578-6`; PDF SHA-256
`95f212aa1d3ca09f963c7bf4bdd9710aaa9add2df41050ed396a343501e9b864`, 3,920,575 bytes, 285
pages.  Proposition 6.1 and its complete proof were checked against the actual page images on PDF
pages 107--109, printed labels 3.95--3.97, not merely against OCR.  Those pages state the subset
classification modulo complement, formula for `f_T`, the `h^0` formula, and the divisor proof.

The book works over the complex numbers, so the positive-characteristic transfer is part of this
task's trusted boundary rather than attributed silently to Mumford.  The displayed proof uses:
the separable hyperelliptic double cover; `2W_b ~ L`; the divisor of `dt/y`; the even-subset model
for `J[2]`; and a pole/zero count for polynomials in `x`.  For `y^2=x^q-x` with q odd, the branch
polynomial is separable because its derivative is `-1`, two is invertible, and the cover has the
same `2g+2` distinct Weierstrass points.  These divisor, 2-torsion, and polynomial-space arguments
therefore carry over verbatim over the algebraic closure of `F_q`; no analytic theta-function step
is used in the accepted subset or `h^0` computation.

## Verdict

**`ROW DIES AS A SHEET DISCRIMINATOR.`**  The matching-to-Lagrangian, packing-incidence,
Cartier--Manin, superspeciality, theta-origin, and Arf computations all survive exactly.  What dies
is the proposed separation: the two B3 sheets have the same even intersection signature, and the
two H3 sheets have the same odd intersection signature.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c451-roquette-theta.py --check
sha256sum -c notes/2026-07-21-c451-roquette-theta.sha256
```

Intentional regeneration is the same checker with `--write`.  The checker independently rebuilds
`PSL_2(q)` and `PGL_2(q)` from prime-field matrices, reconstructs the frozen matching orbits, and
checks the packing incidences both by quotient-space rank and by alternating-union components.  It
computes the Cartier--Manin coefficients directly and also checks their vanishing.  Post-gate, it
exhausts the complement, `h^0`, Riemann--Mumford, Arf, Lagrangian-restriction, and
packing-intersection parity checks.  Its
load-bearing frozen input is C406's canonical matching-orbit certificate, pinned by SHA-256 in the
output; the load-bearing Mumford scan is likewise hash-checked before generation.

The trusted boundary is exact prime-field and binary linear algebra, the frozen C406 endpoint/base
matching conventions, the standard even-subset description of hyperelliptic `J[2]`, and the
Cartier--Manin coefficient formula, and the stated odd-characteristic validity of Mumford's
divisor-theoretic proof.  The bundle proves the exact finite row verdict; it does not claim a
characteristic-two model, a theta-sheet discriminator under a different noncanonical origin, or
literature novelty.
