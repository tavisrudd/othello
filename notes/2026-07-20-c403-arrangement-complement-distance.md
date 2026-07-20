# C403 — arrangement-complement distance and the weighted 2-adjoint repair

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** `ACTIVE`

**Current verdict:** `ORIGINAL-LATTICE OBSTRUCTION PROVED; WEIGHTED 2-ADJOINT COBBOUNDARY THEOREM FOUND`

## Decision

The first attack proves that the characteristic polynomial determines the length of a rank-three
projective arrangement-complement code, but neither it, freeness, the full intersection lattice,
nor any Tutte/coboundary/lattice-flag invariant **of the original arrangement** determines minimum
distance.  Two exact pairs over `F_11` separate these levels:

| pair | common data | first distance | second distance |
|:---|:---|---:|---:|
| `A3` / irreducible supersolvable dual pencil | `chi(t)=(t-1)(t-2)(t-3)`, free exponents `(1,2,3)` | `64` | `63` |
| two simple six-line arrangements | the complete lattice `U_(3,6)` | `68` | `67` |

The first exact replacement was the ambient one-point extension/contraction profile.  A stronger
second attack packages that profile canonically: form the **weighted 2-adjoint** of the arrangement,
giving each adjoint hyperplane indexed by a singular flat `X` the weight `m(X)-1`.  Its projective
finite-field depth enumerator, after deleting the original `N` mirrors, gives the complete Hamming
weight enumerator and distance.  Thus the broad theorem fails at level zero but becomes true after
one adjoint transform:

```text
characteristic polynomial of A        -> length
weighted coboundary specialization of A^(2) -> all weights and distance.
```

This is an active proof tranche, not a task close.  The coding specialization, structural equality
classes, and Coxeter consequences remain under attack in C403.

## Exact ambient formula

Let `A` be an essential arrangement of `N` projective lines in `PG(2,q)`, let `B` be its projective
complement, and assume that `B` spans the plane.  Let `D(A)` be the dimension-three code whose
projective generator columns are the points of `B`, with length `n`.  Dualize the arrangement lines
to a point set `S` of size `N` in the dual plane.  For `e` outside `S`, define

```text
nu_A(e) = number of distinct lines through e meeting S.
```

Equivalently, `nu_A(e)` is the number of parallel classes of the contraction
`M(S union {e}) / e`.  If `L_e` is the primal line dual to `e`, duality gives

```text
|B cap L_e| = q+1-nu_A(e).
```

An arrangement line is disjoint from `B`.  Since each projective kernel line represents exactly
`q-1` nonzero scalar codewords, the one-variable Hamming weight enumerator is

```text
W_D(z) = 1 + (q-1)N z^n
           + (q-1) sum_(e notin S) z^(n-q-1+nu_A(e)),

d(D(A)) = n-q-1 + min_(e notin S) nu_A(e).
```

In the primal collision notation

```text
delta_A(L) = sum_(P singular on L) (m(P)-1),
```

one has `nu_A(e)=N-delta_A(L_e)` and
`|B cap L_e|=q+1-N+delta_A(L_e)`.  Thus the ambient contraction profile and the external
singular-line spectrum are the same exact information.  The formulation identifies what the
arrangement lattice omits: dependencies created only after adjoining an ambient point.

The classical finite-field method still supplies

```text
n = chi_A(q)/(q-1)
```

for the central arrangement.  Length is an arrangement-matroid invariant; distance is an ambient
embedding invariant.

## Weighted 2-adjoint theorem

There is a canonical arrangement-theoretic home for the missing ambient incidences.  Write the
central arrangement also as `A` in `F_q^3`.  Its rank-two flats are the one-dimensional vector
spaces corresponding to projective singular points.  Following Liang--Wang--Zhao, the 2-adjoint
`A^(2)` has one hyperplane `H(X)` in Pluecker space for each rank-two flat `X`.  In rank three,

```text
Gr(2,3)(F_q) = PG(2,q),

Delta(U) in H(X)  iff  X is contained in U.
```

Here `U` is a vector plane, hence a projective test line.  Give `H(X)` multiplicity

```text
w_X = m(X)-1.
```

The depth of the Pluecker point of `U` in this adjoint multiarrangement is then

```text
depth_A(U) = sum_(X contained in U) w_X = delta_A(U).
```

Define the projective weighted-adjoint depth polynomial and its puncture by

```text
P_A(x) = sum_(U in Gr(2,3)(F_q)) x^depth_A(U),
Z_A(x) = P_A(x) - N x^(N-1) = sum_delta a_delta x^delta.
```

The subtraction is intrinsic: every original mirror `H_i`, viewed as a point of the Grassmannian,
has depth `N-1`, because the sum of `m(X)-1` over its singular points counts every other mirror
once.  Therefore `Z_A` is exactly the depth enumerator over nonmirrors.  If
`n=chi_A(q)/(q-1)` and the complement spans, then

```text
W_D(z) = 1 + (q-1)N z^n
           + (q-1) sum_delta a_delta z^(n-q-1+N-delta),

d(D(A)) = n-q-1+N-deg Z_A.
```

Equivalently, replace each adjoint hyperplane `H(X)` by `w_X` labelled parallel copies, producing an
indexed central multiarrangement `B_A` of rank `r_B`.  Put `M=sum_X w_X`.  Ardila's finite-field
coboundary identity, applied to this actual finite-field arrangement, gives the exact normalization

```text
q^(3-r_B) chibar_(B_A)(q,x) = sum_(v in F_q^3) x^h(v),

P_A(x) = (q^(3-r_B) chibar_(B_A)(q,x) - x^M)/(q-1).
```

The `x^M` term is the zero vector; every nonzero projective point has `q-1` representatives.  The
displayed `N x^(N-1)` puncture then removes the mirrors.  This gives a precise positive repair of
the failed original-arrangement theorem.  It is not determined by `L(A)` alone: the lattice of the
adjoint detects when several distinct singular flats of `A` become collinear on a missing line.

For the certified uniform pair, all weights are one.  The high-collision realization creates a
triple concurrence in the 2-adjoint that is absent in the other realization.  For the Coxeter
fixtures, the external singular-line ledgers below are exactly compressed weighted-adjoint depth
censuses.  The ambient one-point contraction profile, external collision spectrum, and punctured
weighted 2-adjoint depth polynomial are therefore three equivalent interfaces to the same data;
the adjoint interface is the canonical arrangement construction among them.

This rank-three finite-field statement is proved directly by incidence and is replayed for every
fixture in the certificate.  It also sits on an established classification theorem.  Cai--Fu--Wang
prove that the induced adjoint arrangement classifies one-element extensions and restrictions,
including their intersection semilattices and characteristic polynomials.  For a nonmirror plane
`U` here, the rank-two restriction has `nu_A(U)` distinct lines and

```text
chi_(A|U)(t) = (t-1)(t-nu_A(U)+1).
```

Thus the ambient contraction number is exactly the first restriction coefficient classified by
their adjoint strata.  The weighted depth `N-nu_A(U)` is the minimal scalar compression needed for
the code.  Liang--Wang--Zhao subsequently supply the general `k`-adjoint construction and show over
the reals that its Grassmannian strata classify restriction matroids.  Those classification
theorems own the adjoint interface; C403's bounded addition is the finite-field weighting, mirror
puncture, and code-enumerator specialization, with no priority claim.

The construction is equivariant.  Any projective automorphism group `G` preserving `A` permutes its
rank-two flats, preserves the weights `m(X)-1`, and acts on the Grassmannian.  Weighted depth is
constant on every `G`-orbit, so

```text
Z_A(x) = sum_(G-orbits O on nonmirrors) |O| x^depth(O).
```

This is the useful computational attack for reflection arrangements: classify finite-field
orbits of test lines and evaluate one representative per orbit.  The C399 ledgers are already a
coarser hand-compressed version of this orbit sum.  The certificate performs the orbit replay for
all three types over `F_11`.  For `A3/B3`, the projective reflection group has order `24` (`B3`'s
central inversion acts trivially) and compresses all `133` projective lines to `11` orbits.
Grouping their sizes by nonmirror depth gives

```text
A3: depth 0: 4+12+12+12+24 = 64
    depth 1: 12+12          = 24
    depth 2: 3+12+24        = 39
    mirrors: 6

B3: depth 0: 24             = 24
    depth 1: 12+12+12       = 36
    depth 2: 24             = 24
    depth 3: 4+12+12+12     = 40
    mirrors: 3+6            = 9.
```

For `H3`, take the split golden root `tau=4` in `F_11`.  The projective `A5` has order `60` and
compresses the same `133` lines to only `7` orbits:

```text
H3: depth 3: 10+30          = 40
    depth 4: 12             = 12
    depth 5: 6+30+30        = 66
    mirrors: 15.
```

These sums exactly recover all three symbolic spectra.  Burnside gives a uniform orbit-count law,
not merely a q=11 census.  Let `epsilon_m(q)=1` when `m` divides `q-1`, and `0` otherwise.  In good
characteristic, for the common projective `S4` representation underlying `A3/B3`,

```text
|PG(2,q)/S4| = (q^2+10q+33+16 epsilon_3+12 epsilon_4)/24.
```

Indeed, the identity fixes `q^2+q+1` points; the nine involutions each fix `q+2`; the eight
order-three elements each fix `1+2 epsilon_3`; and the six order-four elements each fix
`1+2 epsilon_4`.  For the good-residue-field icosahedral representation,

```text
|PG(2,q)/A5| = (q^2+16q+75+40 epsilon_3+48 epsilon_5)/60,
```

from the class sizes `1,15,20,24` of the identity and elements of orders `2,3,5`.  An involution
again fixes `q+2` projective points, while an element of odd order `m` fixes one eigenline plus two
more exactly when its nontrivial eigenvalues lie in `F_q`.  Independent direct replays exercise the
other splitting branches: `A3` has `15` line orbits at `q=13`, and `H3` with `tau=5` has `13` at
`q=19`.  The remaining orbit problem is finer: derive the depth-labelled orbit sizes uniformly,
not the total number of orbits.

## C399 recovered from external flag ledgers

The complete C399 spectra follow without coordinate enumeration from a short external ledger.  For
each singular stratum record `(number of points, multiplicity, number of special nonmirror lines
through each point)`, then record the special nonmirror lines by `delta`.  Every remaining line
through a singular point contains only that singular point, and the `delta=0` count is the residual
from `q^2+q+1` total lines.

| type | singular external-degree ledger | special nonmirror lines |
|:---|:---|:---|
| `A3` | `(3,2,2), (4,3,0)` | `3` with `delta=2` |
| `B3` | `(6,2,4), (4,3,3), (3,4,0)` | `16` with `delta=3` |
| `H3` | `(15,2,10), (10,3,9), (6,5,5)` | `40` with `delta=3`, `66` with `delta=5` |

This yields the full nonmirror-line counts:

| type | exact `delta` spectrum |
|:---|:---|
| `A3` | `f_0=(q-3)^2`, `f_1=3(q-3)`, `f_2=4q-5` |
| `B3` | `f_0=(q-5)(q-7)`, `f_1=6(q-5)`, `f_2=4(q-5)`, `f_3=3q+7` |
| `H3` | `f_0=(q-11)(q-19)`, `f_1=15(q-11)`, `f_2=10(q-11)`, `f_3=40`, `f_4=6(q-9)`, `f_5=66` |

The maximum `delta` is respectively `2,3,5=h/2`.  Since the mirror count is `N=3h/2`, the
minimum ambient contraction count is `N-h/2=h`; hence

```text
max_L |B cap L| = q+1-h,
d = n-q-1+h,
```

which is C399's uniform distance law.  This is a useful common proof interface, but its special-line
ledger is extra realization data rather than characteristic, Tutte, coboundary, or lattice-flag
data.

## Infinite two-pencil supersolvable class

The first counterexample belongs to an exact structural family.  Take `r+1` lines through `P` and
`s+1` lines through `Q`, with the single shared line `PQ`; equivalently, there are `r` `P`-only
lines, `s` `Q`-only lines, and `N=r+s+1`.  Assume `r,s>=2` and `q>max(r,s)`.  The shared line belongs
to a circuit in each pencil, so the rank-three matroid is connected.  The point `P` is modular,
hence the arrangement is irreducible supersolvable and free.  Its exact data are

```text
chi_A(t) = (t-1)(t-r)(t-s),       exponents = (1,r,s),
n = (q-r)(q-s).
```

For a nonmirror line through `P` or `Q`, the collision weight is respectively `r` or `s`.  A line
through neither point contains at most one point on each `P`-only and each `Q`-only line, so it
contains at most `min(r,s)` grid intersections.  Consequently

```text
max delta_A = max(r,s),
max_L |B cap L| = q-min(r,s),
d = (q-r)(q-s)-q+min(r,s).
```

This proves the distance formula for an infinite nonreflection supersolvable class, rather than
only for one fixture.  The certificate independently enumerates five parameter pairs over `F_11`.
For `(r,s)=(3,2)`, the characteristic and exponents coincide with `A3`, but

```text
d_A3  = (q-3)^2,
d_sup = (q-2)(q-4).
```

At `q=11` these are the certified `[72,3,64]_11` and `[72,3,63]_11` codes.  Their flag data differ:
the `A3` singular ledger is `3` double and `4` triple points, while the dual pencil has `6` double,
`1` triple, and `1` quadruple point.  Thus characteristic polynomial and freeness already fail;
adding ordinary lattice flags distinguishes this pair but does not solve the general problem.

Distance rigidity does not extend to the full enumerator even inside this class.  Two balanced
`(r,s)=(3,3)` realizations over `F_11` have the same seven-line lattice (two quadruple points and
nine double points), free exponents `(1,3,3)`, length `64`, and distance `56`, but their punctured
weighted-adjoint polynomials are

```text
Z_collinear(x) = 36 + 60x + 12x^2 + 18x^3,
Z_generic(x)   = 38 + 54x + 18x^2 + 16x^3.
```

The first pencil grid has two weighted collinear triples on external lines; the second has none.
Thus the structural theorem determines the extremal depth while external grid geometry still
controls how all other weights are distributed.

## Intrinsic multiplicity bounds

The ambient formula also gives bounds using only `N`, `n`, and the maximum singular multiplicity
`m`.  In the dual plane, the lines through an external point partition the `N` arrangement points,
and no block has more than `m` points.  Hence

```text
nu_A(e) >= ceil(N/m),
d >= n-q-1+ceil(N/m).
```

Conversely, if `q+1>m`, choose a nonmirror through a multiplicity-`m` singular point.  It has
`delta>=m-1`, giving

```text
d <= n-q+N-m.
```

The two-pencil family attains this upper bound identically: its largest singular multiplicity is
`m=max(r,s)+1`, so `n-q+N-m=n-q+min(r,s)`.  This supplies a clean equality class and a quick
lattice-level interval even when the weighted adjoint spectrum is not yet known.

The lower-bound equality condition is also geometric.  It requires an external dual point whose
`N` arrangement points lie in exactly `ceil(N/m)` direction classes, each of size at most `m`.  For
a simple arrangement (`m=2`), this says that a missing primal line contains the intersections of
`floor(N/2)` disjoint line-pairs (plus one unpaired line when `N` is odd).  The high-collision
`U_(3,6)` fixture was designed to realize exactly this equality; its mate avoids it and lies one
above the lower bound.  Thus the crude bound already predicts the correct extremal construction.

## Counterexample 2: the full intersection lattice

Both pinned arrangements in the second pair consist of six lines with no triple concurrence, so
their complete intersection lattice is the uniform rank-three matroid `U_(3,6)`: fifteen double
points and no other proper flats.  Consequently every invariant factoring through that lattice is
identical, including the characteristic, Tutte and coboundary polynomials, flag Whitney data, and
flag Hilbert--Poincare series.

In the first realization, no external line contains three singular points, so `max delta=2`.  In
the second, the intersections of three disjoint line pairs are collinear on one external line, so
`max delta=3`.  At `q=11` both complements have

```text
n = q^2-5q+10 = 76,
```

but their maximum line sections are `8` and `9`, giving `[76,3,68]_11` and `[76,3,67]_11`.
The certificate contains the normalized coordinates, all fifteen lattice blocks, both direct line
censuses, and the ambient contraction profiles.  This is stronger than a pair with only the same
ordinary characteristic polynomial: even the full arrangement matroid fails to determine distance.

## Moment barrier: failure begins cubically

The weighted adjoint identifies the first realization-sensitive moment.  Put

```text
w_X=m(X)-1,       a_j=sum_X w_X^j,
T_3=sum_(collinear distinct X,Y,Z) w_X w_Y w_Z,
D(L)=sum_(X on L) w_X.
```

Counting projective lines through one point, two points, and three collinear points gives

```text
sum_L D(L)   = (q+1)a_1,
sum_L D(L)^2 = q a_2+a_1^2,
sum_L D(L)^3 = (q-2)a_3+3a_1 a_2+6T_3.
```

For the nonmirror spectrum, subtract `N(N-1)^j` from the `j`-th displayed moment.  The first
two moments are therefore forced by the singular multiplicities; missing-line geometry first
appears in the cubic term through weighted collinear triples.  In a simple arrangement all weights
are one, so after removing triples on mirrors, the new datum is literally the number of collinear
triples of singular points on external lines.

The certificate verifies these identities for every fixture.  Both obstruction pairs agree through
the quadratic punctured moment and first separate cubically:

| pair member | first moment | second moment | third moment |
|:---|---:|---:|---:|
| `A3` | `102` | `180` | `336` |
| two-pencil `(3,2)` | `102` | `180` | `384` |
| uniform low-collision | `150` | `240` | `420` |
| uniform high-collision | `150` | `240` | `426` |

For the uniform pair, the difference `426-420=6` is exactly one additional external collinear
triple times `3!`.  This sharpens the obstruction: mean/variance or any quadratic depth summary is
provably blind to the first same-lattice failure.

## Free coding corollaries

The ambient formula yields several exact consequences without reopening the failed abstraction.

1. For every spanning projective complement code of dimension three,

   ```text
   d_2 = n-1,    d_3 = n.
   ```

   A codimension-two projective subspace is one point and the projective system has no repeated
   columns.

2. The ambient contraction profile gives the complete Hamming weight enumerator above; the standard
   MacWilliams transform then gives the entire dual enumerator.

3. Every weight-three dual support is a collinear triple of complement points, with a one-dimensional
   nonzero dependency space.  Hence

   ```text
   A_3(D(A)^perp) = (q-1) sum_L binom(|B cap L|,3).
   ```

   More sharply, for a coordinate `P in B`, put `s_L=|B cap L|`.  The number of locality-two repair
   pairs and the maximum number of pairwise disjoint such pairs are exactly

   ```text
   R(P)   = sum_(L through P) binom(s_L-1,2),
   Av_2(P)= sum_(L through P) floor((s_L-1)/2).
   ```

   The first identity chooses the other two points of a collinear triple.  For the second, repair
   pairs on different lines through `P` are automatically disjoint, while the optimum on one line
   is a matching.  Thus every certified fixture has locality two, with exact worst-coordinate data:

   | fixture over `F_11` | `min_P R(P)` | `min_P Av_2(P)` |
   |:---|---:|---:|
   | `A3` | `179` | `30` |
   | `B3` | `75` | `19` |
   | two-pencil `(3,2)` | `179` | `31` |
   | uniform low-collision | `198` | `33` |
   | uniform high-collision | `198` | `32` |

   The certificate records the complete distributions, not only these minima, and checks
   `sum_P R(P)=3 sum_L binom(s_L,3)` independently.

4. At the C399 conic phase, the full-weight projective codeword classes are all lines external to
   the conic, not only the Coxeter mirrors.  In weighted-adjoint language their number is

   ```text
   N + [x^(N-q-1)] Z_A(x),
   ```

   where a coefficient with negative index is zero.  Their counts are

   | type | field | all external lines | Coxeter mirrors |
   |:---|---:|---:|---:|
   | `A3` | `5` | `10` | `6` |
   | `B3` | `7` | `21` | `9` |
   | `H3` | `11` | `55` | `15` |

   This support-level symmetry jump explains why the bare GRS child forgets its parent.  In the
   stable phase `q>N-1`, the displayed index is negative, so the full-weight projective classes
   collapse back to exactly the mirrors.  This is C399 reconstruction viewed as a literal
   coefficient crossing in the weighted-adjoint spectrum.

The analogous higher-degree object would replace the Grassmannian of lines by the parameter space
of degree-`r` zero loci and stratify it by weighted incidence with the arrangement complement.  The
2-adjoint theorem identifies the degree-one base case; constructing a comparably canonical
higher-degree transform remains an active C403 attack rather than a claim in this tranche.

## Evidence and independent replay

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 -B notes/2026-07-20-c403-arrangement-complement-distance.py --check
sha256sum -c notes/2026-07-20-c403-arrangement-complement-distance.sha256
```

The primary path derives the three symbolic Coxeter spectra from the displayed weighted-adjoint
external ledgers.  The independent path enumerates every point and line of `PG(2,11)`, constructs
each complement directly, counts every line section, and reconstructs the weight enumerator from
both ambient contractions and the punctured weighted 2-adjoint.  It also verifies the adjoint moment
identities, intrinsic bounds, locality/availability distributions, five two-pencil parameter
samples, both same-lattice counterexamples, and the exact `A3/B3` projective reflection-group orbit
decompositions, the `H3` q=11 orbit decomposition, and the q=13/q=19 Burnside branch replays.  All
projective codeword totals equal `11^3` for the q=11 code fixtures.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | `41,958` | `7bdd2bfcf40f48489bbbd4c207e7b92d62824445e25a3bd3f6b7239aaea6f7ab` |
| certificate `.json` | `52,908` | `dd970f66b5e5135194673bca1e83677824f7f5f51bd8dc331a9b08b8e283d681` |

The trusted boundary is exact Python integer/modular arithmetic, elementary projective incidence,
the standard rank-three supersolvable-implies-free theorem, and C339's independently replayed
characteristic-zero `H3` special-line ledger.  The computation does not prove the general published
adjoint-stratification theorems, an arbitrary-field orbit classification, or any higher-degree
section-profile claim.

## Focused literature boundary

This report read **zero external sources in full**, **seven partially**, and **two at
abstract/metadata depth**.  The mathematical verdict does not depend on an absence-of-prior-work
claim, and no novelty or priority wording is made.  The audit instead checks the four mandatory
interfaces: arrangement evaluation codes, finite-field characteristic/coboundary methods,
lattice-flag invariants, matroid/code weight enumerators, and adjoint arrangements.

| source | read depth and access | boundary |
|:---|:---|:---|
| Federico Ardila, *Computing the Tutte polynomial of a hyperplane arrangement*, arXiv:math/0409211 | **partial**, arXiv preprint, Section 3 definitions and Theorem 3.3; cache SHA-256 `8d67ee9aa7b1f2948ead7fdfba545fe48c7da78a5fff3e79451545d1a96f5ea` | The coboundary polynomial is equivalent to the arrangement Tutte polynomial and its finite-field formula counts points by the number of containing arrangement hyperplanes.  It factors through the arrangement matroid and does not record collinearities among distinct singular flats on missing lines. |
| Weikang Liang, Suijie Wang, and Chengdong Zhao, *k-Adjoint of Hyperplane Arrangements*, arXiv:2412.06633 | **partial**, arXiv v2, Introduction, Definition 2.1, Lemma 2.1, adjoint-stratum definition, and Theorem 1.1 statement; cache PDF SHA-256 `59050f6a6ca38f1d9fdf7c747612814cde26e2b7aa3ac777fe6687624c11eef7` | Defines the `k`-adjoint from rank-`k` flats and proves that its Grassmannian decomposition classifies restriction matroids over the stated real setting.  Lemma 2.1 is the determinant identity behind C403's direct finite-field rank-three specialization.  The weighting, mirror puncture, and code-enumerator formula here are not attributed to that paper. |
| Hang Cai, Houshan Fu, and Suijie Wang, *One-element Extensions of Hyperplane Arrangements*, arXiv:2308.09885 | **partial**, arXiv preprint, Sections 2.2--2.3 and Section 6 through Corollary 6.2; cache SHA-256 `8894bce42157aba3655b60a43ac8a6385c68d02ab4df2c11b851230dc92e5f37` | The induced adjoint arrangement classifies one-element extensions and restrictions, and their Theorem 2.3 includes a finite-field characteristic convolution.  This pre-empts any claim that C403 introduced the extension/adjoint interface.  C403 instead extracts the weighted restriction-line count, projective mirror puncture, and coding enumerator. |
| Joshua Maglione and Christopher Voll, *Flag Hilbert--Poincare series of hyperplane arrangements and their Igusa zeta functions*, arXiv:2103.03640 | **partial**, arXiv preprint, Introduction through Definition 1.1; cache SHA-256 `61454bf1c532eacf416b9cb692bc080321a3eab4983c4048bfe2d3aa916685c6` | The flag series is explicitly built from flags and restrictions in the intersection poset.  Therefore the certified `U_(3,6)` pair has the same series. |
| Trygve Johnsen, Jan Roksvold, and Hugues Verdure, *A generalization of weight polynomials to matroids*, arXiv:1311.6291 | **partial**, arXiv preprint, Introduction and Section 4.2 opening; cache SHA-256 `c1a7b7204fdef0c10546081d5adc4a42a34fa232874bf795f174eb98f0767589` | The extended weight enumerator is equivalent to the Tutte polynomial of the **code's associated column matroid**.  For C403 that is the complement-point matroid, not the original arrangement matroid; supplying it already supplies the missing section dependencies. |
| Simona Settepanella, *Blocking Sets in the complement of hyperplane arrangements in projective space*, arXiv:0802.2045 | **partial**, arXiv preprint, definitions, Theorem 3, and braid-arrangement opening; cache SHA-256 `21ee5625ee080c874ef1223d5590817f9d701a5de24d72f38864e2abc05174f2` | Studies existence of blocking sets in arrangement complements and a braid example, not exact degree-one complement-code distance or its determination by the arrangement lattice. |
| James Berg and Max Wakefield, *Skeleton Simplicial Evaluation Codes*, arXiv:1112.0283 | **partial**, arXiv preprint, Introduction and Sections 1.1--1.2; cache SHA-256 `9122564a0d28721e295e501a22ca8bb6de801f86d195424a80b296db9259887c` | Defines codes evaluated on subspace-arrangement unions, gets length from the characteristic polynomial, and specializes distance to binary coordinate skeletons.  It is not the projective complement construction or the claimed general invariant. |
| Christos Athanasiadis, *Characteristic Polynomials of Subspace Arrangements and Finite Fields*, DOI `10.1006/aima.1996.0059` | **abstract/metadata only**, official ScienceDirect record | Owns the finite-field characteristic point-count method in the cited scope.  The full text was not fetched; Ardila's cached primary treatment supplies the formula actually used here. |
| Rameez Raja, *Numerical semigroups, hyperplane arrangements, and linear codes over finite fields*, DOI `10.3934/amc.2026042` | **abstract/metadata only**, official publisher page and comparison table; the advertised publisher PDF URL returned `404` on 2026-07-20 | Constructs 2026 semigroup-polytope codes on complements of difference arrangements; the accessible abstract claims characteristic-controlled length and lower bounds for distance, not the exact rank-three flag specialization.  Full-text comparison remains **NOT COVERED**. |

The exact discovery queries included

```text
"arrangement-complement" evaluation code minimum distance
"complement of the arrangement" "evaluation code" finite field
"flag" coboundary polynomial hyperplane arrangement
"flag Tutte polynomial" arrangement
critical problem matroid characteristic polynomial finite fields Crapo Rota pdf
site:arxiv.org hyperplane arrangement linear code finite field complement evaluation
"k-adjoint" hyperplane arrangement restrictions Grassmannian
"one-element extensions" "adjoint arrangement" hyperplane restrictions
```

The screen located the sources above and the standard Greene/code-matroid interface through
Johnsen--Roksvold--Verdure.  MathSciNet, zbMATH forward coverage, Google Scholar, and citation-graph
closure were not needed for the no-priority verdict and are **NOT COVERED**.

## Lean and manuscript boundary

C403 remains open.  The original-arrangement flag claim is excluded from the manuscript, but the
weighted 2-adjoint theorem is now a plausible replacement statement: it gives a canonical
arrangement construction, an exact coboundary specialization, and the complete Hamming enumerator.
It should not be promoted or assigned novelty wording until the adjoint/multiarrangement literature
boundary is tightened.  No Lean surface is added in this tranche; the Python bundle is both an
exact falsifier for level-zero invariants and a replay certificate for the positive adjoint formula.

## Hand-back

- C399's uniform distance law survives unchanged and is the maximum-depth statement for the
  weighted 2-adjoint.
- Characteristic, freeness, full intersection-lattice, Tutte, coboundary, and lattice-flag routes
  **of the original arrangement** are closed for arbitrary rank-three distance.
- The positive replacement is the punctured weighted 2-adjoint coboundary specialization; the
  ambient contraction profile and singular-line spectrum are equivalent concrete interfaces.
- The two-pencil theorem gives an infinite irreducible supersolvable equality class, while the
  multiplicity bounds explain the extremal uniform counterexample.
- The line sections also give exact locality-two repair and disjoint-availability profiles.
- C403 remains the active crowns task.  Next attacks are depth-labelled uniform orbit laws, full
  adjoint/multiarrangement source closure, and higher-degree section transforms; C404 is queued
  behind it rather than replacing it.
