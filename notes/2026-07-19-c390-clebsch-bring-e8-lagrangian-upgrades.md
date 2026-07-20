# C390 — Clebsch--Bring induced bridge and `E8`/Lagrangian upgrades

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** research complete; two positive promotion gates, with explicit geometric and novelty
boundaries

## Executive result

C390 closes positively in two places.

1. The two trigonal equations in the HC model of Bring's curve have the same discriminant

   ```text
   4 t^3 (t^2-t-1)
     (t^4-2t^3+4t^2-3t+1)
     (t^4+3t^3+4t^2+2t+1).
   ```

   Modulo 11 this is `4 t^3(t^10-1)`.  Its finite support is every element of `F_11`, and the
   projective branch support includes infinity.  The golden factor has roots `4,8`, exactly the
   two values in C376.  This is an exact arithmetic explanation of the two golden sheets.  It is
   not, by itself, a proof of good reduction of a global family or a coordinatewise
   identification of the entire reduced Bring curve with C379.

2. The actual mod-two homology representation of the genus-four `S5` action is isomorphic to
   `W direct_sum W`, where `W` is the four-dimensional deleted permutation module over `F_2`.
   With

   ```text
   q(x,y) = x dot y,
   ```

   its orthogonal centralizer has order six and element-order spectrum `1, 2^3, 3^2`; hence it is
   `GL_2(2) = S3`.  It faithfully and simultaneously permutes each of the four triples in the
   published theta-orbit table, while fixing the unique invariant even theta and the size-60 odd
   orbit.  Since `Aut(S5)=S5` and `Z(S5)=1`, the full orthogonal normalizer has order `720` and
   quotient `S3`.  This supplies the finite orthogonal explanation for the previously unexplained
   threeness.  A geometric realization of this `S3` on tritangents or trigonal maps remains open.

The free upgrades also close exactly: C381's fourteen roots form a pointed `K8` star above a
norm-four lift; the C379 matchings give recoverable Lagrangian five-spaces; and the matching-cycle
formula turns C385's Hamiltonicity gate into a partial-spread test.  Both C379 one-factorizations
fail that gate: every one of their 55 factor pairs has two alternating components.

## 1. Norm-four `E8` normal form

For a norm-four vector `w` in positive-definite `E8`, set

```text
D_w = {x in E8 : (x,w) is even},
C_w = {r : r^2=2 and (r,w)=2}.
```

The exact enumeration gives:

```text
240 roots; 2160 norm-four vectors;
135 nonzero singular classes in E8/2E8;
16 norm-four lifts, or 8 lift-lines, above each class;
root pairing spectrum with w: -2:14, -1:64, 0:84, 1:64, 2:14;
112 roots in D_w (the D8 root count);
14 roots in C_w and 7 decompositions w=r+(w-r).
```

For the canonical lift, the seven differences `r-(w-r)` produce the other seven lift-lines above
the same singular class.  Thus the decompositions are exactly the star of the chosen lift-line in
the classical `K8` model of its Steiner complex.

In C381's negative-definite Picard convention, with seven conic points `S` and remaining point
`r`, the effective roots

```text
c_i = 2H - sum_(j in S, j != i) E_j,
d_i = 3H - 2E_i - sum_(j != i) E_j
```

have common sum

```text
w = 5H - 2 sum_(j in S) E_j - E_r,   w^2=-4.
```

After reversing sign, these are precisely the fourteen roots of `C_w`.  The new local content is
the compatibility with C381's effective choice; the `E8` shell, `D8`, and Steiner-complex counts
are classical.

## 2. Matching Lagrangians

For a set `Omega` of size `4k`, put

```text
V_(4k) = {x in F_2^Omega : wt(x) even} / <1_Omega>,
q([x]) = wt(x)/2 mod 2.
```

If `M={e_1,...,e_(2k)}` is a perfect matching, define

```text
L_M = span(e_1,...,e_(2k)),
U_M = ker(q|L_M).
```

The unique relation among the edge vectors is their all-one sum.  Consequently `L_M` is a
Lagrangian of dimension `2k-1`, and `U_M` has dimension `2k-2`.  For two matchings, if `c(M,N)`
counts the alternating components of `M union N`, including a common edge as a doubled 2-cycle,
then

```text
dim(L_M intersect L_N) = c(M,N)-1.
```

This follows before quotienting because a vector in both edge spans is constant on every
alternating component; quotienting by the all-one vector removes one dimension.  Hence for twelve
points

```text
d_S(L_M,L_N) = 12 - 2c(M,N),
M union N Hamiltonian  iff  L_M intersect L_N = 0.
```

The frozen C379 census verifies:

```text
22 distinct L_M of dimension 5;
22 kernels U_M of dimension 4;
132 matching-edge flags and 264 pointed flags;
q=1 minimum-weight spectrum in every L_M: weight 2:6, weight 6:10;
all 231 pair intersections: dim 1/cycles 2:176, dim 2/cycles 3:55;
subspace-distance spectrum: 8:176, 6:55.
```

The six weight-two points recover `M`, so `M -> L_M` is injective in the marked coordinate model.
For each of C379's two eleven-factor one-factorizations, all 55 pairs have `c=2`.  Neither is a
perfect one-factorization.  This is a negative answer to C385's cheap gate, not an administrative
completion of C385.

No priority claim is made for the general formula.  Perfect-matching association schemes and the
perfect-one-factorization/`B`-code correspondence make the surrounding structure classical; the
certificate records a particularly useful binary symplectic realization.

## 3. Induced Bring/Clebsch group sets

The exact stabilizer chain recovered from C379 is

```text
C5 < D10 < A5 < PGL_2(11),
orders 5, 10, 60, 1320,
```

with `PSL_2(11)` of order `660` and C379's golden involution outside it.  Therefore

```text
PGL_2(11)/C5   has size 264,
PGL_2(11)/D10  has size 132,
PGL_2(11)/A5   has size 22.
```

For a fixed `A5`, Dye's twelve-point orbit has stabilizer `C5`.  His Theorem 8 pairs those twelve
points as the double-contact points of the six conics through five vertices; the pair stabilizer
is `D10`.  This is the same stabilizer and five-vertex-conic rule as C379's obstruction pairing.
Thus the point and pair sets agree abstractly and equivariantly, with the pair identification
canonical and the point identification unique up to the antipodal involution.

Induction gives the category-correct full family

```text
G x_A5 (A5/C5)  = G/C5,
G x_A5 (A5/D10) = G/D10,
G/A5             = 22 parents.
```

This does not assert a `PGL_2(11)` action on one Bring curve, one Clebsch cubic, or one `E8`
lattice.

## 4. Exact golden discriminant reduction

Braden--Disney-Hogg give the two trigonal maps in HC coordinates as

```text
f1 = [y^3-x : y-x^2],
f2 = [y-x^2 : xy^2-1].
```

Eliminating `x` on the affine parameter chart gives the cubic fibre equations

```text
y^3+t^3 y^2+t y-t^4,
t^3 y^3-t^4 y^2+y+t.
```

The ordinary cubic discriminant formula produces the common degree-13 polynomial displayed in
the executive result.  Modulo 11,

```text
Delta(t) = 4 t^3(t^10-1),
```

so every finite `F_11` parameter is in its support and the homogenized discriminant also has
support at infinity.  The factor `t^2-t-1` reduces with roots `4,8`, exactly C376's values.  This
establishes the exact discriminant and golden-parameter bridge.

Boundary: the characteristic-11 polynomial has collided roots and altered multiplicities.  C390
does not promote this to good reduction, a separable twelve-point cover, or an explicit coordinate
isomorphism with the C379 child conic.  Those would require a stable integral model and local
analysis beyond this calculation.

## 5. The actual Bring `J[2]` module and the `S3`

The independent Sage certificate begins with exact integral homology matrices for an `S5`
generating vector of orders `(2,4,5)` and quotient signature `(0;2,4,5)`.  They were regenerated
by the polygon-homology method in `polyB.sage` at pinned commit
`e9d1c8d311a2463fc0a06fd510cb2c78adadbd86`; the matrices are embedded in the certificate, so its
replay has no external-code dependency.

Reduction modulo two gives a group of order 120 with element-order spectrum

```text
1:1, 2:25, 3:20, 4:30, 5:24, 6:20.
```

An exact 64-variable intertwiner calculation identifies it with `W direct_sum W`.  The intertwiner
space has dimension four and contains an invertible map.  Pulling back `q(x,y)=x dot y` verifies
the quadratic isometry on all 256 vectors.  Among all 256 refinements of the same polar form,
exactly one is invariant; it is even, with 136 zeros.

The linear commutant again has dimension four.  Exhausting its sixteen elements leaves six
invertible quadratic isometries, with order spectrum

```text
1:1, 2:3, 3:2.
```

Thus the orthogonal centralizer is `S3`.  Its action on the 256 theta vectors reproduces

```text
even: 1 + 3*5 + 3*10 + 3*30,
odd:  3*20 + 60,
```

and acts as the full symmetric group on every displayed triple.  Since every automorphism of
`S5` is inner and its centre is trivial, correcting a normalizer element by an element of `S5`
makes it centralize `S5`; hence the orthogonal normalizer has order `120*6=720` and quotient `S3`.

This is a positive finite triality gate.  The word “triality” is used here for the resulting
threefold orthogonal symmetry, not as a claim that an outer automorphism of the ambient
`O_8^+(2)` has already been geometrically lifted.

## 6. Theta no-go and unresolved Bertini category

The fixed-parent matched source is the six-point transitive set `A5/D10`.  Restricting an `S5`
orbit to its normal subgroup `A5` either preserves the orbit or splits it into two equal orbits.
None of the published theta orbit sizes can contain an `A5` orbit of size six.  Therefore there is
no injective `A5`-equivariant map from the six matched configurations to individual theta
characteristics.  The viable targets are structured objects such as orbit triples or pointed
Steiner complexes.

The degree-one-del-Pezzo/Bertini category was not needed for either positive result and remains
unreconciled: the usual bi-anticanonical branch model lies on a quadric cone, whereas Bring's
canonical curve lies on a smooth quadric.  No degeneration, stable-limit, or Bertini-model claim
is made.

## 7. Reproduction

From the repository root:

```bash
python3 notes/2026-07-19-c390-clebsch-bring-e8-lagrangian-upgrades.py --check
python3 notes/2026-07-19-c390-clebsch-bring-e8-lagrangian-upgrades-replay.py
nix-shell -p sage --run \
  'sage notes/2026-07-20-c390-bring-homology-module.sage --check'
```

The first checker contains the `E8`, matching, group-chain, theta-orbit, centralizer, and golden
discriminant calculations.  The replay checks the frozen C379 inputs and canonical JSON.  The Sage
certificate independently closes the previously missing identification of the actual homology
module.

## 8. Literature and ownership audit

| Source | Read depth | Load-bearing use / boundary |
|---|---|---|
| Braden--Disney-Hogg, *Bring's curve: old and new*, arXiv:2208.13692 | substantive sections 2.1--2.3, 5.11--5.13, conclusion; not cover-to-cover | HC model, trigonal maps, ruling exchange, homology/theta data, and the stated unexplained threeness |
| Braden--Disney-Hogg, *Orbits of Theta Characteristics*, arXiv:2404.09890 | substantive method and Bring sections through the orbit computation; not cover-to-cover | affine theta action, parity, and published orbit table |
| Dye, *Hexagons, Conics, `A5` and `PSL2(K)`* (1991) | full reconstructed OCR, with authoritative scan check of p.274 / Theorem 8 | twelve-point orbit and the six double-contact pairs; OCR SHA-256 `6d48847949e2b37c3a87557df9fa4147c9b1305d8469c7c06965c62b99fcbf92`, scan SHA-256 `1e4eaacb78fbbbfa1396fa6f59c80b31b2edf0ab683a2154693d1787895e87d3` |
| Yang, *Modular curves, invariant theory and `E8`*, arXiv:1704.01735 | relevant sections from prior lane audit; no new Bertini claim | background only |
| Celik--Kulkarni--Ren--Namin, *Tritangents and Their Space Sextics*, arXiv:1805.11702 | cached; abstract/metadata only | no load-bearing reconstruction claim |
| Plaumann et al., *Bitangents to symmetric quartics*, arXiv:2410.09242 | abstract/introduction plus full-text mechanical screen for Bring/triality terms | only genuine forward citation found; genus-three quartic paper, no C390 theorem located |

The forward-citation audit for DOI `10.1080/10586458.2025.2481271` returned one citing work in
OpenAlex (the bitangents paper), zero in Crossref, and two Semantic Scholar records, one being the
self/preprint duplicate.  These are successful API results, not proof that all citation indexes are
empty.  MathSciNet and Google Scholar were not audited.  No broad novelty or priority claim is
made for classical `E8`, matching-scheme, or theta counts.  The promotion claims are limited to
the exact cross-lane golden discriminant bridge and the certified `S3` explanation of the Bring
orbit triples.

Discovery-track review found no incidental observation: the negative one-factorization result,
golden collision, and `S3` centralizer were all explicit C390 targets, so none belongs in the
append-only discovery log.
