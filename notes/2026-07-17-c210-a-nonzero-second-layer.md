# C210: both second-layer Artin--Schreier components are classified

**Lane**: `relconic` (task report; C210 remains active)

Date: 2026-07-17. This closes Packet 3 of the C210 umbrella handoff for all
three known `a!=0,b!=0` exact-split branches. Both quadratic components are
classified over every odd-tower field, including `q=8`. Every known branch has
rational `tau`-roots; this report does not yet promote those roots to genuine
projective collisions.

## Statement

Let `k=GF(8^m)` with `m` odd and retain the generic scope
`a*delta*N*b*p!=0`, where

    theta = w^2+w+1,                 N = a^2+a+1,
    Q = u^2+u*delta+delta^2,         G1 = u^2+u*p+p^2*theta,
    G2a = u^3+u^2*delta+u*p^2*theta+delta*p^2*theta
          +delta^2*p+delta*a*G1.

The exact-split packet gives the two components

    tau^2+b*Q*tau+A = 0,             tau^2+b*Q*tau+A+sigma = 0,
    sigma = a*delta*N*G1*G2a.

Since `Q` has no `k`-rational zero, `x=tau/(bQ)` is valid at every rational
affine point. Define

    chi0 = A/(bQ)^2,                 chi1 = (A+sigma)/(bQ)^2,
    C = a*delta*N/b^2,               r = C*G1*G2a/Q^2.

Then `x^2+x=chi_i`. The complete classification is as follows.

### Branches 1 and 2

On branch 1 put `c1=a*h1/b^2`. On branch 2 put

    L2 = a*p^2*theta+delta*a*p+delta^2+delta*b+delta*p+h1,
    c2 = a*L2/b^2.

For `i=1,2`, the two classes are

    chi0 = ci,                       chi1 = ci+r.

The constant component has exactly `2q` affine points when
`Tr_k(ci)=0`, and none when `Tr_k(ci)=1`. Geometrically it is always two
lines: split over `k` in the first case and conjugate over its quadratic
constant extension in the second.

The nonconstant component is always absolutely irreducible over its actual
constant field `k`. Its reduced pole divisor and genus are:

| exact stratum | reduced poles | genus |
|---|---|---:|
| `Q` divides `poleW` | infinity only, order one | 0 |
| `Q` does not divide `poleW` | infinity and both geometric roots of `Q`, all order one | 2 |

Here the denominator-cleared symbolic test is

    P = G1*G2a,
    poleW = a*delta*N*(dP/du)^2 + b^2*delta^2*P.

Thus both finite poles cancel exactly when the remainder of `poleW` modulo
`Q` is zero. This is a complete branch-local pole stratification, not a generic
claim: the exact `GF(8)` census contains `1,022` cancellation geometries among
the `19,208` allowed geometries.

The polynomial part is exact:

    P/Q^2 = u+delta*a+delta+p + (proper part).

Consequently the nonconstant components have reduced infinity constants

    kappa1 = a*h1/b^2 + C*(delta*a+delta+p),
    kappa2 = a*L2/b^2 + C*(delta*a+delta+p),

recorded as classes `[kappa_i]` in `k/{z^2+z}`. These constants do not affect
absolute irreducibility because the coefficient `C` of the simple infinity
pole is nonzero.

### Branch 3

On `delta=p` and `theta=1` (both `w=0,1` fibers are checked directly),

    G1 = Q,                          G2a = (u+a*p)*Q.

Both apparent finite poles cancel before Artin--Schreier reduction. Put

    c30 = a*(h1+e*b+e*N*(p+(a+1)*e))/b^2,
    c31 = c30+a^2*p^2*N/b^2.

Then

    chi0 = (a*e*N/b^2)*u + c30,
    chi1 = (a*N*(e+p)/b^2)*u + c31.

Every class with nonzero linear coefficient defines a genus-zero curve
isomorphic to the affine `x`-line: solve uniquely
`u=(x^2+x+c)/lambda`. It therefore has exactly `q` affine points. The first
class is constant only at `e=0`; there the second coefficient is nonzero. The
second is constant only at `e=p`; there the first coefficient is nonzero.
The constant component at either intersection obeys the same trace rule as
above. Hence branch 3 always has rational roots over every field in the odd
tower.

## Artin--Schreier reduction and constant field

The pole calculation does not assume symbolic square roots in the imperfect
parameter function field. Fix an allowed specialization over the perfect
finite field `k`. In the quadratic field `k[u]/(Q)`, choose the unique
degree-less-than-two polynomial `S` satisfying

    S^2 = C*P  (mod Q).

Exact division gives `P=Q^2*(u+delta*a+delta+p)+R`, `deg(R)<4`. Adding the
Artin--Schreier coboundary `(S/Q)^2+S/Q` reduces the class to

    C*u + kappa_i + V/Q,             deg(V)<2.

A local expansion at a root of `Q` shows `V=0` exactly when
`Q | poleW`: for a double-pole numerator `C*P`, the squared simple-residue
condition is

    C*(dP/du)^2 + delta^2*P = 0  (mod Q),

which becomes the displayed `poleW` after multiplying by `b^2`. Because
`Q/delta^2=(u/delta)^2+(u/delta)+1` is irreducible over `k`, a nonzero
`V` cannot vanish at either geometric root. The reduced poles are therefore
exactly those in the table.

The simple infinity pole is present on both strata because `C!=0`. An odd
reduced pole excludes an Artin--Schreier coboundary even after algebraic
constant extension, proving absolute irreducibility. The totally ramified
rational infinity place also pins the full constant field to `k`. Applying
the standard Artin--Schreier different/genus formula gives genus zero or two,
as stated.

Finally, `Q` has no rational zero throughout the odd tower: a zero would solve
`v^2+v=1`, while `Tr_k(1)=3m mod 2=1`. The same trace calculation excludes
`N=0`. Thus normalization, `x`-conversion, and the stated constant field are
uniform on the claimed scope.

## Rational-point quantifier and the q=8 exception check

For the genus-at-most-two nonconstant component, Hasse--Weil gives

    #X(k) >= q+1-4*sqrt(q).

The only rational point removed when returning to finite `u` is the unique
point over infinity; the degree-two `Q`-place has no `k`-rational point.
Hence there are at least `q-4*sqrt(q)>0` affine points for every odd-tower
`q>=512`.

The remaining field `q=8` is closed by exact exhaustive enumeration. For all

    7^4 * 8 = 19,208

allowed `(delta,a,b,p,w)` geometries, the eight values
`Tr(r(u))`, `u in GF(8)`, contain both `0` and `1`. Since `h1` makes `c1` and
`c2` range bijectively over all eight constants, `chi1=ci+r` has a rational
root for every one of the

    19,208 * 8 = 153,664

geometry/constant-class pairs. The minimum is one admissible `u`, hence two
affine `(x,u)` points. The checker separately exhausts the field law
`x^2+x=z` (two roots exactly at trace zero) and evaluates `poleW mod Q` in the
quadratic quotient ring as an independent invariant.

**Conclusion.** Both components on every known branch are explicitly
classified. Branches 1 and 2 are rational-root-bearing because their
nonconstant component has points for `q=8` and for every `q>=512`; branch 3
has a rational affine-linear component for every `q`. There is no
second-layer rootless candidate among the three known factorization branches.

## Artifact, replay, and trusted boundary

- Checker:
  `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_second_layer.py`.
- Canonical output:
  `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_second_layer_output.txt`.
- Replay from `papers/arcs_complete_outside_conic/`:

  ```bash
  python3 analyze_c210_a_nonzero_second_layer.py | diff - analyze_c210_a_nonzero_second_layer_output.txt
  sha256sum -c analyze_c210_SHA256SUMS
  ```

The Singular half checks thirteen exact polynomial gates: the polynomial part,
the reduced-pole remainder and its two coefficients, a factored cancellation
projection in the `delta=1` chart, both direct branch-3 fibers, both affine
normal forms, and both infinity constants. The finite-field half checks every
`GF(8)` geometry and constant class with deterministic bit arithmetic.

Trusted boundary: the exact splits from Packet 1; Singular polynomial
arithmetic over `GF(2)`; the checker's direct `GF(8)` implementation; and the
classical Artin--Schreier different/genus formula and Hasse--Weil theorem cited
with exact proposition/theorem numbers in the preceding `b=0` report. The
point census is finite-field evidence only for `q=8`; the infinite-tail claim
is the symbolic reduction plus Hasse--Weil argument above.

## What this does not prove

- Projective distinctness or genuineness of any rational cover point.
- Arithmetic completeness of the three known residue branches.
- The bounded `q=8` exception on the separate `b=0,a!=0` stratum.
- Arc legality, affine coverage, or `C`-completeness.

## SHA-256 / byte counts

    analyze_c210_a_nonzero_second_layer.py          12378  a80f2a80cde89f401f168c05bfa0ec14ee0c12e5bcdf569c37e23be216a72b9d
    analyze_c210_a_nonzero_second_layer_output.txt   2383  237e8d6fd9902e6f464556794cd65fe3a4b14356f02166f023c01ad84102b9e2
