# C391: intrinsic four-frame service spectrum

**Lane:** `crowns`

**Verdict:** `THEOREM; EXACT THREE-LEVEL SERVICE SPECTRUM, WHILE DISJOINT MAJORITY RADIUS IS IDENTICALLY ZERO`

## Result

Let `K` be a projective frame in `PG(2,q)`, `q>=13`, and let `G_K` be its abstract uncoloured
continuation graph.  C369's three target strata have the following complete operational spectrum
for the recovered projective `[4,3,2]_q` code:

| secant-pair count `r` | fractional service | disjoint PIR availability | disjoint-majority radius | multiplicity |
|---:|---:|---:|---:|---:|
| 0 | `4/3` | `1` | `0` | `(q-2)(q-3)` |
| 1 | `3/2` | `1` | `0` | `6(q-2)` |
| 2 | `2` | `2` | `0` | `3` |

Every quantity and stratum in the table is intrinsic to `G_K`.  Thus the uncoloured graph recovers
the full one-target service spectrum and its exact multiplicities.  It also gives the smallest
possible sharp form of C357's majority-logic obstruction: disjoint service and PIR detect the
three diagonal extremizers, and fractional service distinguishes all three strata, but the
disjoint one-step majority decoder distinguishes none of them.

## Proof

C295 reconstructs `q`, the ambient plane, and `K` from `G_K`.  C369 then reconstructs the secant
count `r_K(P)` for every target `P` outside `K` and proves the exact service values
`4/3,3/2,2`.  C357 gives

\[
 \kappa=r+\left\lfloor\frac{4-2r}{3}\right\rfloor,
 \qquad
 \tau=\left\lfloor\frac{\kappa-1}{2}\right\rfloor,
\]

so `kappa=(1,1,2)` and `tau=(0,0,0)` for `r=(0,1,2)`.

It remains only to count targets.  The `r=0` targets are exactly the vertices of `G_K`, and C295
gives their number `(q-2)(q-3)`.  Each of the six frame secants contains `q-1` points outside `K`,
giving `6(q-1)` secant--target incidences.  The three diagonal points have `r=2` and account for
six of those incidences.  Every remaining secant target has `r=1`, hence there are
`6(q-1)-6=6(q-2)` of them.  Finally there are three partitions of a four-set into two pairs, hence
three diagonal targets.  The sum

\[
 (q-2)(q-3)+6(q-2)+3=q^2+q-3
\]

is exactly the number of projective points outside the four stored columns.

## Boundary

This is a free extraction from C295, C357, and C369; no computation or new literature claim is
load-bearing.  Classical complete-quadrangle counts and elementary fractional packing are not
claimed as new.  The result strengthens the operational composition only.  Because every legal
continuation lies in the single `r=0`, service-`4/3` stratum, the spectrum supplies no game-value
distinction inside `G_K` and does not clear C296.
