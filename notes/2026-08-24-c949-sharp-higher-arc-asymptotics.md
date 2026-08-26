# C949 — sharp asymptotics for complete higher arcs

**Lane**: `relconic`

**Status:** active on the user-requested sharpness continuation; the proposed
`4/3` linear coefficient is excluded and the structural lower coefficient is
now `5/3`; the exact `5/3` endpoint is also absent, while a matching
`5/3+o(1)` construction remains open; the sharpest `+1` triangular target is
reduced to the almost-duplex/near-Rédei/moment conditions
`(SR18)--(SR24z)`, `(SR24-Witt)--(SR24-WittK)`, and
the absolute-defect global design `(SR24a-global)--(SR24a-local')` together
with `(SR24a-secant-form)--(SR24a-quartic-gap)`,
the exact dual `(0,q/3,2q/3)` set and minimal blocking `4`-arc
`(SR24a-highincidence)--(SR24a-arrangement-torus)`,
`(SR24-Redei)--(SR24-Redei-Witt)`, and
`(SR24-grid-energy)--(SR24-grid-gcd'')`; no
manuscript work

## First-gate findings — 24 August 2026

The construction audit currently names seven sources: three were read at **full
text** in C945's recorded audit and four at **partial** depth.  No novelty or
priority claim is made.  The exact read depths, versions, access paths, and
hashes are recorded below.

### Known-construction audit

1. **Hermitian multiple blocking sets give only the noisy base case.**
   Bishnoi--Mattheus--Schillewaert's Section 6 construction gives, for square
   `q` and `t<=sqrt(q)+1`, a minimal `t`-fold blocking set

   ```text
   |B|=q sqrt(q)+1+(t-1)(q-sqrt(q)+1).
   ```

   At `(q,t)=(9,3)` this yields `|B|=42`, hence a complete `(49,7)`-arc.
   At the target `t=q/3`, however, its hypothesis becomes
   `q/3<=sqrt(q)+1`, which fails from `q=81` onward on the square
   characteristic-three tower and already fails at `q=27`.  It is therefore
   a base-case witness, not an asymptotic construction.

2. **The inherited algebraic-curve families have the wrong density.**
   Korchmaros--Nagy--Szonyi construct complete higher arcs of order the
   ambient field size, whereas C949 needs order `q^2/3`.  Bastioni--Micheli's
   general fixed-degree theorem has the same density mismatch and assumes
   characteristic `p>m`; at `p=3`, `m=2q/3+1`, that hypothesis fails outright.
   Complements, trace-level unions, or growing-degree families remain logically
   possible, but the known fixed-degree constructions do not specialize to
   `(UB3)`.

3. **Exact two-character point cores are absent at `q=27` near the predicted
   secant-family size.**  The two standard incidence moments were exhaustively
   solved for point-set sizes `45<=T<=70` and all two line-intersection numbers.
   There is exactly one integral parameter candidate:

   ```text
   T=57, line intersections {0,3}, with 225 zero-secants and 532 trisecants.
   ```

   This is a nontrivial maximal `3`-arc parameter set.  Ball--Blokhuis--
   Mazzocca exclude such an arc in `PG(2,27)`.  Thus no exact two-character
   *point set* occurs in this whole window.  This does not exclude modular
   multisets, bounded repairs, or non-two-character selected-secant cores.

4. **The smallest-Singer-orbit construction cannot specialize to the target
   tower.**  Innamorati's 2026 construction requires `q congruent 1 (mod 3)`
   so that `3 | q^2+q+1`; its `PG(2,13)` example partitions the plane into
   three triple blocking `61`-sets of type `(3,4,7)`.  For every `q=3^h`, the
   congruence is instead `q congruent 0 (mod 3)`.  At `q=27`, moreover,
   `q^2+q+1=757` is prime, so a Singer group has no proper nontrivial subgroup
   and supplies no nontrivial orbit-union search at all.  Other cyclic
   subgroups of `PGL(3,27)` are a separate computational case.

   The orbit audit gives the remaining bounded models explicitly:

   ```text
   trace-x translations:     81 orbits of size 9,  28 fixed points
   trace-x/y translations:    9 orbits of size 81, 28 fixed points
   scalar subgroup C_13:     56 orbits of size 13, 29 fixed points
   Frobenius C_3:           248 orbits of size 3,  13 fixed points.
   ```

   The trace-`x/y` family can already be excluded arithmetically.  A `9`-fold
   blocking set must take at least nine of the 28 points at infinity.  Taking
   six affine orbits would then give size at least `6*81+9=495`, above the
   Bishnoi--Mattheus--Schillewaert upper bound `486`; taking at most five gives
   size at most `5*81+28=433`, hence a complementary arc of size at least
   `324`, far above the target `279` at `q=27`.

### Weak inverse realization is a binary feasibility problem

Let `L` be any nonempty family of lines in a projective plane of order `q`,
let `s<=q+1`, and let `U` be the points covered by no line of `L`.  A point set
`A` realizes `L` as a covering subfamily of its maximal secants if and only if
its `0/1` incidence vector satisfies

```text
U subset A,
|A intersect ell|=s       for ell in L,
|A intersect r|<=s        for every line r.
```

Indeed, the displayed constraints make `A` an `(s)`-arc and every member of
`L` an `s`-secant; every point outside `A` is outside `U`, hence is covered by
one of those secants, so `A` is complete.  The converse is immediate for any
chosen covering subfamily of maximal secants.  Minimizing `|A|` under these
constraints is therefore the promised weak inverse problem, without the
unnecessary demand that `L` contain *all* maximal secants.

### Five-character dual-core mechanism

The corrected `q=9` structure suggests a field-uniform sufficient condition
that is substantially sharper than the generic weak inverse problem.  Put

```text
q=3^h>=9,   s=2q/3+1,   k=q^2/3+4q/3.
```

Suppose the dual plane contains a blocking set `D` of size `2q+1` whose line
intersection spectrum is

```text
n1=(2q^2-3q+6)/3,   n2=2q/3-1,   n3=3q-3,
n4=(q^2-6q+15)/3,   n5=q/3-2.                       (FC5)
```

Let `S` be precisely the dual lines meeting `D` in at least three points, and
assume the single global concurrency cap that every dual point lies on at
most `s` members of `S`.  Then

```text
A={x : the dual line ell_x belongs to S}
```

is a complete `(k,s)`-arc.  Direct substitution gives

```text
|S|=n3+n4+n5=k,
3n3+4n4+5n5=(2q+1)s.
```

The second identity and the cap imply that every point of `D` lies on exactly
`s` members of `S`: their average degree is already `s`.  Hence every member
of `D` is dual to an `s`-secant of `A`, while the global cap makes `A` an
`s`-arc.  Every dual line meets the blocking set `D`; therefore the dual line
of every primal point outside `A` contains a member of `D`, so that point lies
on an `s`-secant.  Thus `A` is complete.

The spectrum `(FC5)` is forced once one asks for a `2q+1` blocking core with
no line longer than five, `|S|=k`, and total selected incidence `(2q+1)s`:
solve the three projective-plane incidence moments together with the last two
displayed identities.  At `q=9` it gives the actual core

```text
1^47 2^5 3^24 4^14 5^1,
```

and the fixed-core lift reproduces the structural 39-point arc exactly.  At
`q=27` the target is

```text
|D|=55,  spectrum 1^461 2^17 3^78 4^194 5^7,
|S|=78+194+7=279.
```

The paired degree envelope independently forces the number `T` of maximal
19-secants of any target-size complete arc to be either 54 or 55.  If
`m(v,e,a)` denotes the minimum of `sum binom(d_i,2)` over `v` integers of sum
`e` and lower bound `a`, balancing degrees gives the necessary inequality

```text
m(279,19T,0)+m(478,9T,1) <= binom(T,2).
```

Together with `9T>=478` and the two elementary pair bounds, integer
substitution leaves exactly `T in {54,55}`.  Thus `(FC5)` occupies one of only
two possible envelope branches.

The earlier four-character extrapolation was rejected by the fixed-core
replay: it had misidentified a diagnostic spectrum.  Its `q=27` symmetry
searches therefore carry no mathematical conclusion and are not retained as
evidence.  For the corrected five-character spectrum, trace-`x/y` invariance
is arithmetically impossible because 55 cannot be assembled from its nine
81-orbits and 28 fixed points.  The trace-`x` and scalar `C_13` core models are
exactly infeasible after collapsing the lines to 109 and 85 orbit-incidence
signatures, respectively.

Frobenius invariance has a further exact reduction.  Its 13 fixed points and
13 fixed lines form `PG(2,3)`.  If `f` fixed points belong to `D`, then
`f congruent 55 congruent 1 (mod 3)`.  If a fixed line contains `r` of them,
its full intersection size `d` satisfies `d congruent r (mod 3)`.  Blocking
and `1<=d<=5` therefore permit only

```text
r=0 -> d=3;  r=1 -> d in {1,4};  r=2 -> d in {2,5};
r=3 -> d=3;  r=4 -> d=4.
```

Moreover, the numbers of fixed lines of types `1,...,5` must be congruent
modulo three to `(461,17,78,194,7)`, hence to `(2,2,0,2,1)`.  Exhausting all
`2^13` fixed-point subsets and quotienting by the generated order-5616 group
`PGL(3,3)` leaves exactly ten normalized branches: four with `f=4` and six
with `f=7` before imposing the concurrency cap.  Their fixed-subline count
vectors and admissible fixed-line type vectors are

```text
(2,7,3,1,0): (2,2,3,5,1), (5,2,3,2,1)
(3,4,6,0,0): (2,2,3,2,4), (2,5,3,2,1)
(0,3,6,3,1): (2,2,3,2,4), (2,5,3,2,1)
(0,4,3,6,0): (2,2,6,2,1)
(0,2,9,0,2): (2,2,0,2,7), (2,5,0,2,4), (2,8,0,2,1).
```

The concurrency cap makes this much sharper.  Every point of `D` has selected
degree exactly `s=19` by the averaging argument above.  At a Frobenius-fixed
core point, the nonfixed incident lines occur in triples, so the number of
selected fixed lines through it is congruent to `19` modulo three.  Since
there are four fixed lines through it, that number is exactly one or four.
Exhausting the compatible assignments of types `1/4` on the `r=1` lines and
types `2/5` on the `r=2` lines eliminates eight of the ten branches, including
every `f=7` branch.  Exactly two canonical branches survive:

```text
fixed core type            fixed-subline counts  fixed-line type counts
3 collinear + 1 off-line  (2,7,3,1,0)  (5,2,3,2,1)
general 4                  (3,4,6,0,0)  (2,5,3,2,1).
```

For each branch the compatible fixed-line assignments form one orbit under
the stabilizer of the fixed core.  Removing the fixed data gives the exact
orbit inventories

```text
branch type      core point C3-orbits: fixed-line/off-line  line C3-orbits by type 1,...,5
3-on-line+1-off  5 / 12                                  (152,5,25,64,2)
general 4        6 / 11                                  (153,4,25,64,2).
```

Thus the Frobenius question is no longer one undifferentiated 261-signature
model, but two fully normalized finite branches, each with only two nonfixed
5-secant orbits.  The exact search now exposes, rather than merely relying on,
the projective pair moment, every point-incidence sum, the sparse type-2 and
type-5 counts, and the degree-19 equality at core points.  It also encodes the
resulting local identity

```text
sum_{high lines ell through P} |D intersect ell| + a_2(P)
    = 8q/3+1 = 73                         for P in D.
```

Five-minute runs with this additional channel remain `UNKNOWN`; that status
supplies no evidence either way.  The exact `T=55` condition does not require
a separate search constraint.  Indeed, if a point `P` is outside the blocking
core and lies on `e(P)` selected lines, then

```text
2q+1 = sum_{lines ell through P} |D intersect ell|
     >= 3e(P) + (q+1-e(P)),
```

so `e(P)<=floor(q/2)`.  At `q=27`, every external degree is at most 13,
strictly below 19; hence `D` is automatically the full set of maximal
secants.  A direct split by the unordered pair of
nonfixed 5-secant orbits is also too coarse: the fixed-structure stabilizer has
order four and leaves 7,768 pair orbits in either branch.  That split is not
promoted as a useful proof route.  All exclusions here are symmetry-restricted
statements, not an unrestricted nonexistence theorem.

### Second-moment shell and centered incidence codeword

The higher-value `tt` reformulation starts from the primal arc rather than
from the two exceptional five-secant orbits.  Let `M` be the line-by-point
incidence matrix, let `a` be the characteristic vector of a target arc `A`,
and let `e=M a` be its line-degree vector.  The projective-plane identity
`M^T M=qI+J` gives

```text
M^T e=q a+k 1.
```

Write `q=3r`, so `k=3r^2+4r`.  Since `k-r(q+1)=q`, centering at the two
expected external degrees gives the exact integer identity

```text
M^T(e-r 1)=q(1+a).                                  (CI)
```

Thus `(e-r 1) mod 3` is a dual incidence-codeword, not merely a numerical
degree profile.  This is the spatial constraint that the raw orbit searches
were missing.

On the `T=2q+1=6r+1` branch, the core points have degree `2r+1`.  Removing
them from the two standard incidence moments yields

```text
sum_{P outside D}(e_P-r)=6r^2-4r-1,
sum_{P outside D}(e_P-r)(e_P-r-1)=2r(r-2).           (DS)
```

Every summand in the second line is a nonnegative integer, vanishing exactly
at `e_P in {r,r+1}`.  Hence all but at most `r(r-2)` external points have one
of those two degrees.  At `q=27`, `(DS)` becomes

```text
702 external points,  sum e_P=6767,  sum binom(e_P,2)=29376,
sum(e_P-9)=449,       sum(e_P-9)(e_P-10)=126.
```

Consequently at most 63 external lines have degree outside `{9,10}`.  The
Frobenius fixed-subplane data force six of the nine fixed external points to
have degree congruent to two modulo three, so at least six fixed points are
exceptional and consume at least 12 units of the defect.  The blocking-core
inequality above also removes degrees 14 through 18 completely.

The deterministic degree audit also identifies the limitation of scalar
moment data.  Even after the exact Frobenius residues and the local
blocking-core bound `e(P)<=13`, each canonical branch still admits 50,261
external degree histograms.  The two branches have different fixed high-line
counts,

```text
3-on-line+1-off:  1^2 2^6 3^1,
general 4:        1^1 2^6 3^1 4^1,
```

but the same residue spectrum `0^1 1^2 2^6`, minimum fixed defect 12, and set
of compatible global histograms.  The audit nevertheless forces `N_0=0`,
`N_1<=1`, `N_18<=1`, `N_9>=127`, and `N_10>=323` in either branch.  Therefore
the next classification must use the spatial code equation `(CI)`, not
another degree-distribution or raw five-secant-pair split.

Pure reduction modulo three is still too loose.  On Frobenius-invariant
vectors the ternary incidence matrix has 261 coordinates, rank 77, and kernel
dimension 184.  Pinning all 13 fixed coordinates is consistent in both
branches but leaves affine dimension 178.

The full modulus in `(CI)` is 27, however, and its `3`-adic Smith profile is

```text
v_3=0^77 1^54 2^54 3^76.
```

Consequently the reductions modulo three of vectors that actually lift
through `M^T u=0 (mod 27)` form only a 76-dimensional subspace of the
184-dimensional kernel.  Its restriction to the 13 fixed coordinates has
rank six.  Both canonical residue patterns lie in that image, and pinning
either one leaves affine dimension 70.  The projection of the full
modulo-27 kernel onto the fixed coordinates has Smith profile `0^6 1^7`, so
it imposes exactly those seven residue relations and no additional higher
`3`-adic obstruction on the fixed degrees.

The useful object is therefore the small-norm integral lift `u=e-9 1`, not an
arbitrary ternary codeword.  Its remaining exact data are

```text
sum u=999,   ||u||^2=6075,
u_P=10 for the 55 core points,
sum_{P outside D} u_P^2=575,
M^T u in {27,54}, with value 54 exactly on A.
```

This recasts the `T=55` branch as a constrained closest-vector problem in an
affine incidence-code lattice.  That is the concrete next attack licensed by
the audit.

There is a sharper descent which exposes the small object inside that lattice.
Everything in this descent is conditional on the prescribed five-intersection
inverse-construction branch `(FC5)`: it is not known to hold for every
hypothetical target-size extremizer.  In particular, the sparse signed word
below neither proves the asymptotic upper bound nor classifies all extremizers.
Use the polarity coordinates of the audit, in which the incidence matrix `M`
is symmetric.  Let `c` be the characteristic vector of `D`, put `d=M c`, and
retain `a=1_{d>=3}` and `e=M a`.  Define

```text
x=e-r(1+c),                 z=1+3a-d.
```

Thus `x=1` on the core and equals the previous centered coordinate `e-r`
outside it.  The five line types make `z` a signed sparse vector:

```text
d=1,4 -> z=0;    d=2,5 -> z=-1;    d=3 -> z=1.
```

The design identity and `|D|=2q+1` now give the mutually exact transforms

```text
M z=3x,                       M x=r(z+2 1).          (SD)
```

The signed spectrum is field-uniform, not a `q=27` coincidence:

```text
z: (-1)^(q-3) 0^(q^2-3q+7) 1^(3q-3),
|supp(z)|=4q-6,       sum z=2q,
sum x=2r(3r+1),       ||x||^2=2r(4r-1).
```

Moreover `Mz=0 (mod 3)`.  Hence the `4q-6` point support of `z` has no
tangent: a line cannot contain exactly one nonzero coordinate.  Every
2-secant of the support contains one positive and one negative coordinate.
This converts the higher-arc mechanism into a signed untouchable-set problem
with prescribed color classes, as well as a dual-code problem.

At `q=27` this means

```text
z:  (-1)^24 0^655 1^78,      sum z=54,  ||z||^2=102,
x:  sum x=504,  ||x||^2=630, sum x(x-1)=126,
M x: 9^24 18^655 27^78.
```

So the norm-6075 lift contains a weight-102 ternary dual incidence-codeword,
with only 24 negative and 78 positive coordinates.  In the two Frobenius
branches its nonfixed support occupies respectively 32 and 31 of the 248
three-cycles: `(+,-,0)=(25,7,216)` for 3-on-line+1-off and
`(25,6,217)` for general four.  This signed-word classification is strictly
smaller and more geometric than the 70-dimensional closest-vector statement.
No external classification theorem is invoked here: `(SD)` is the next proof
gate, not completion.

The `q=9` witness makes the codeword mechanism concrete.  Its external
spectrum is `1^1 3^28 4^43`, and the unique degree-one line contributes the
entire defect

```text
(1-3)(1-4)=6=2*3*(3-2).
```

More strongly, the support of `(e-3 1) mod 3` is exactly the 63-point
complement of the 28-point Hermitian unital.  Thus the unital is visible after
the `C_4` switch as an intrinsic ternary incidence-code invariant.  This is
the cleanest structural bridge presently known from the exact base case to a
field-uniform attack.

For the same witness the signed descent is exact:

```text
z: (-1)^6 0^61 1^24,         x: (-2)^1 0^28 1^62,
sum x=60,  ||x||^2=66,       sum x(x-1)=6.
```

Here `x mod 3` is literally the characteristic vector of the 63-point unital
complement.  The lone value `-2` is the unique degree-one line and consumes
the full defect.  This explains simultaneously why the unital survives the
switch and what should replace it at `q=27`: a sparse signed secant-defect
word satisfying `(SD)`.

The 30-point support of the `q=9` signed word has line spectrum

```text
0^4 2^24 3^32 5^30 6^1.
```

Its 24 support 2-secants all join opposite signs.  This exact small case is a
concrete model for the signed untouchable-set classification, not merely a
weight calculation.

#### Collinear-negative reduction and the four-direction coset

The signed word has a further exact feature which is stronger than
untouchability.  Write `P={z=1}` and `N={z=-1}`.  In the `q=9` witness all six
points of `N` lie on one line `L`, `P` avoids `L`, and the joint line spectrum
is

```text
(|ell intersect P|,|ell intersect N|):
  (0,0)^4 (0,6)^1 (1,1)^24 (3,0)^32 (4,1)^30.       (CL9)
```

The four holes complete `P` to a second classical Hermitian unital `U'`.
In the integer encoding `GF(9)=GF(3)[w]/(w^2+1)`, it is the zero locus of the
nonsingular Hermitian matrix

```text
H' = [[2,6,2],[3,0,5],[2,8,1]],
```

and has line spectrum `1^28 4^63`.  The signed word has the exact geometric
factorization

```text
z = 1_{U'}-1_L.                                      (HU)
```

Indeed `U' intersect L` is the four-hole set, so `(HU)` gives `+1` on the 24
off-line unital points and `-1` on the other six carrier points.  For every
line other than `L`, subtracting its unique intersection with `L` turns the
unital intersections `1/4` into signed sums `0/3`; on `L` itself the signed
sum is `4-10=-6`.  Hence `(SD)` becomes

```text
x=-2 on L,  x=0 on the 28 tangents to U',
x=1 on the other 62 secants to U'.
```

Under the symmetric polarity used throughout the audit, those 28 tangent
lines are exactly the *original* Hermitian unital from the `C_4` construction.
At matrix level the relation is

```text
H_original = 2 (H'^{-1})^(3),
```

where the exponent is entrywise Frobenius.  This independently gives the
tangent-dual Hermitian form, rather than recognizing it only from its point
set.
The 19-point blocking core `D` is disjoint from that tangent dual and avoids
`L`, hence lies entirely among the 62 other secant coordinates.  The complete
degree stratification is therefore

```text
e=1 on L;  e=3 on the 28 tangents;  e=4 on 43 noncore secants;
e=7 on the 19 core secants.
```

Thus the unital which survived the switch as `supp(x mod 3)^c` is the tangent
dual of `U'`; the switch secretly relates two Hermitian unitals meeting in
four points.  This settles the previously unexplained intrinsic object behind
the signed base witness.

It also proves that `(HU)` is intrinsically a base-field resonance, not an
asymptotic construction.  In a plane of square order `Q=sqrt(Q)^2`, replacing
`U'` by a Hermitian unital and subtracting one secant produces sign classes of
sizes

```text
positive: (Q-1)sqrt(Q),       negative: Q-sqrt(Q).
```

Matching the required `(3Q-3,Q-3)` forces `sqrt(Q)=3`, hence `Q=9`.  For
larger squares the signed support has the exact size

```text
Q sqrt(Q)+Q-2sqrt(Q),
```

rather than `4Q-6`.  In characteristic three the same incidence calculation
still gives a genuine ternary dual word.  Writing `s=sqrt(Q)`, its integral
transform `Mz/3` is zero on all tangent lines, equals `s/3` on every
noncarrier secant, and equals `-s(s-1)/3` on the carrier.  Thus the construction
is an infinite signed-code family, but both its support and transform leave
the C949 small-defect scale as soon as `s>3`.  Nonsquare fields do not carry
this Hermitian construction.  The exact factorization explains the base
equality while simultaneously ruling out its literal lift toward `(UB3)`.

The factorization has a field-uniform converse which does not assume a
unital.  If the negative class of any target signed word is carried by a line
`L`, put

```text
u=z+1_L.
```

Off `L` this is a `0/1` vector.  On `L` the `q-3` negatives cancel, while the
four holes have multiplicity one or two.  Since the number of positive holes
is zero or three, `u` is a nonnegative `{0,1,2}` multiset with

```text
sum u=3q+1,       every line sum is 1 (mod 3),
sum_{P in L} u_P=4 or 7.                              (M31)
```

Conversely, subtracting `1_L` from a multiset of this form with the prescribed
carrier pattern recovers the collinear signed word.  In the zero-positive
case `u` is an honest `3q+1`-point `1 mod 3` blocking set with a 4-secant; the
`q=9` instance is exactly `U'`.  In the three-positive case the carrier has
three double points and one simple point.  Thus asymmetric collinear lifts are
not an amorphous signed-code problem: they are a sharply parameterized exact
modular-multiset classification problem `(M31)`.

This modular object has a sharp moment defect of its own.  Write every line
sum as `1+3y_ell`, and let `R=sum_P binom(u_P,2)`, so `R=0` in the set case and
`R=3` in the three-double-point case.  The two projective-plane incidence
moments give exactly

```text
sum y_ell   =2q^2/3+q,
sum y_ell^2 =7q^2/9+2qR/9,
sum y_ell(y_ell-1)=q(q-9+2R)/9.                       (M32)
```

For `R=0`, the final quantity is zero exactly at `q=9`; this is why the second
unital can have only `1/4` intersections there.  Every larger field forces a
line of multiplicity at least seven and total excess `q(q-9)/9`.  At `q=27`
that excess is 54.  For `R=3` the total is 72, of which the carrier's value
`y_L=2` consumes two, leaving the earlier noncarrier defect 70.  Thus `(M32)`
recovers `(CL0)`/`(CL3)` from the exact modular multiset and identifies the
base resonance without reference to the arc coordinates.

Thus the four holes `H=L minus N` are the only exceptional directions after
declaring `L` to be the line at infinity.  Every affine line in a direction
from `N` meets `P` in `1 mod 3` points, while every affine line in a direction
from `H` meets `P` in `0 mod 3` points.  This is not just terminology: choose
arbitrarily one affine line in each of the four hole directions.  The sum of
their four characteristic vectors has exactly the same line sums modulo three
as `1_P`.  Consequently

```text
1_P = 1_{L_1}+1_{L_2}+1_{L_3}+1_{L_4}+w  (mod 3),
```

where `w`, extended by zero on `L`, lies in the ternary dual projective-plane
code.  This turns the base mechanism into a four-direction affine Radon coset,
the setting of the projection-function/special-direction method, rather than
an unstructured weight-30 word.  Exhausting the `9^4=6561` four-line choices
in the exact witness gives correction weights

```text
30^160 33^1176 36^1512 39^2552 42^984 45^144 48^32 57^1.
```

In particular the correction never collapses to a minimum or two-line dual
word; its minimum weight is 30, with fifteen `+1` and fifteen `-1`
coordinates.  This finite enumeration is an invariant diagnostic, not an
asymptotic existence claim.

There is also a field-uniform conditional defect theorem.  Suppose at
`q=3r` that the `q-3` negative coordinates are collinear.  Their carrier has
four holes, and divisibility of its signed sum by three forces it to contain
either zero or three positive coordinates.  In the zero-positive case its
`x`-coordinate is `-(r-1)`, so it is an external point of selected degree one
and consumes defect `r(r-1)`.  The exact defect left off the carrier is

```text
2r(r-2)-r(r-1)=r(r-3).                              (CL0)
```

In the three-positive case the carrier has `x=-(r-2)`, selected degree two,
and leaves

```text
2r(r-2)-(r-2)(r-1)=(r-2)(r+1).                     (CL3)
```

Since every other exceptional coordinate costs at least two, the respective
noncarrier exception bounds are `r(r-3)/2` and `(r-2)(r+1)/2`.  For `q=27`
these are 27 and 35, improving the unrestricted bound 63.  The external cap
also gives `0<=x<=4` away from the carrier in this collinear setting, so one
coordinate costs at most 12; hence the exact `q=27` ranges are in fact
`5<=number of noncarrier exceptions<=27` and `6<=...<=35`.  The `q=9`
witness is the zero-positive resonance `r=3`, where `(CL0)` vanishes and all
other `x`-coordinates are exactly zero or one.  For every larger field the
same clean pattern is arithmetically impossible: a collinear-negative lift
must develop positive residual defect.

The same positivity collapses the `q=27` scalar search from 50,261 spectra to
two tiny exact lists.  With no positive carrier holes, the carrier has degree
one and the other 701 external degrees lie in `9,...,13`; there are exactly 30
moment spectra, with count ranges

```text
N_9:258..271  N_10:403..438  N_11:0..27  N_12:0..9  N_13:0..4.
```

With three positive holes, the carrier has degree two and there are exactly
42 spectra, with

```text
N_9:264..280  N_10:386..429  N_11:2..35  N_12:0..11  N_13:0..5.
```

These are conditional asymmetric-core data: the Frobenius branches are
excluded from the collinear case below.

The Frobenius fixed data make this reduction decisive at the branch level.
The three fixed negatives of the `3 collinear + 1 off-line` branch have the
unique fixed carrier indexed by point 27 under the symmetric polarity.  That
point belongs to the fixed blocking core, so `(SD)` requires the signed sum on
its carrier to be `3x_27=3`.  Collinearity would instead put all 24 negatives
there, with only four remaining positions; even filling all four positively
gives signed sum `-20` (and divisibility actually permits only zero or three
positives, giving `-24` or `-21`).  This is an exact contradiction.  The six
fixed negatives of the `general 4` branch cannot lie on one fixed line, which
has only four fixed points: the unique carrier of a Frobenius-invariant set of
at least two collinear points must itself be Frobenius-fixed.  Therefore
neither normalized Frobenius branch
can realize a collinear negative class.  The eight apparent hole-orbit cases
in the first branch disappear before search once the core equation is used.

There is a further exact fixed-pencil reduction for the genuinely
noncollinear case.  Of the 248 nonfixed Frobenius line orbits, 104 split into
eight orbits through each of the 13 fixed points; the remaining 144 meet no
fixed point.  No nonfixed orbit belongs to two fixed pencils.  If `p_Q,n_Q`
are the positive and negative orbit counts in the eight-orbit pencil at a
fixed point `Q`, then `(SD)` gives the local integer equation

```text
x_Q = (sum of z on the four fixed lines through Q)/3 + p_Q-n_Q.       (FP)
```

Enumerating the possible external degrees in their required residue classes,
the eight slots in each pencil, and the global nonfixed sign budgets
is therefore a small exact dynamic program.  In the
`3 collinear + 1 off-line` branch it leaves 5,915 signed allocation states,
2,573 fixed centered vectors, and 130 centered histograms; their fixed defect
is one of

```text
12,18,24,30,36,42,48,54,60,66,72,78,84,96,
```

and their fixed centered sum lies in `0..24`.  In the `general 4` branch it
leaves 3,940 allocations, 1,975 vectors, and 101 histograms, but now the fixed
defect is only one of `12,18,...,66` and the fixed centered sum lies in
`0..21`.  More sharply, if `p,n` now denote the total positive and negative
orbits in all fixed pencils, the enumeration proves `p+2n>=21` and
`p+2n>=22` in the two branches.  Since globally `n<=7` and `n<=6`, the two
branches must place at least 14 and 16 of their respectively 32 and 31
supported nonfixed orbits in fixed-point pencils; in particular at least 7
and 10 positive orbits are pencil-anchored.  Thus the pencil
projection sharpens the second branch's local norm budget and spatially
anchors at least half the sparse support, but does not yet contradict either
branch.  Indeed every one of the 2,573 and 1,975 fixed vectors extends at the
level of the global degree sum and defect moments.  The next obstruction must
use spatial incidence or recoverability, not those scalar moments alone.

Characteristic three also suggests a natural hull mechanism which can now be
excluded at low complexity.  For a nonfixed Frobenius orbit `O` of three
lines, let `g_O` be the sum modulo three of their incidence vectors.  Then
`g_O` is a dual word and vanishes on the fixed subplane.  For each branch there
are exactly 729 fixed-line coefficient lifts `b` which match the prescribed
fixed signs and whose coefficients sum to zero.  The exact hull audit tests
all 496 scalar multiples of the 248 words `g_O` and all 123,009 distinct
unordered two-generator sums.  Neither branch has even the target sign counts
`(+,-)=(78,24)` in a representation

```text
z = b + lambda_1 g_{O_1} + lambda_2 g_{O_2},       lambda_i in F_3,
```

with at most two nonzero orbit terms.  This rules out the simplest
conjugate-line explanation of the noncollinear word.  There are respectively
10 and 7 fixed lifts whose coefficient support uses at most four fixed lines
(including the unique sparsest lifts, of weights two and three).  Every one of
those 17 low-complexity lifts also misses the target after three nonfixed
orbit terms.  The result for three terms applies only to this coefficient-
weight-at-most-four subfamily.  This is a bounded hull mechanism exclusion,
not a classification of arbitrary hull words and still less of all ternary
dual words.

This is also the point where the next exhaustive widening needs a compiled
kernel.  The correct Rust state space is the 261-coordinate Frobenius quotient,
not the 757-point plane: 13 fixed trits have weight one and 248 moving trits
have weight three.  Store the two nonzero symbols as bit masks, precompute the
123,009 two-generator sums, and shard those sums deterministically.  The 729
fixed lifts form an affine `F_3^6` fiber, so a ternary Gray walk can update
their masks incrementally.  The Python implementation above remains the
reference checker for the bounded certificates.  Widening the three-orbit
test to all 1,458 branch lifts by repeating the present Python loops would be
raw throughput, not additional mathematics.

There is, however, a structural argument which supersedes that widening and
does not use Frobenius symmetry.  Reduce `(SD)` modulo three.  Since

```text
z = 1-Mc  (mod 3),       Mz=0  (mod 3),
```

the signed word lies in the hull `C_1(2,q) intersect C_1(2,q)^perp` of the
ternary line code.  Here `1` belongs to the line code: the sum of the lines in
any point-pencil is `1+q 1_P=1` modulo three.  Thus hull membership is forced
by the five-character core; it is not an additional model assumption.

Szőnyi--Weiner, Theorem 4.2, says that a line-code word of weight `w` in
`PG(2,q)`, `q>17`, has support covered by `ceil(w/(q+1))` lines whenever

```text
w < sqrt(q/2)(q+1).                                      (SW)
```

For `w=4q-6`, condition `(SW)` holds for every `q>=27`: after squaring, the
difference is

```text
q(q+1)^2-2(4q-6)^2 = q^3-30q^2+97q-72,
```

which is `360` at `q=27` and strictly increasing thereafter.  Also
`ceil((4q-6)/(q+1))=4`.  Hence the signed support would lie on four lines.

The following elementary signed-transversal lemma rules this out.

> **Four-line hull obstruction.**  Let `q>=27`, and let `z` take values
> `-1,0,1` in `PG(2,q)`.  Suppose `z` is a line-code word, every line sum is
> zero modulo three, `|supp(z)|=4q-6`, `sum z=2q`, and exactly `q-3`
> coordinates are negative.  Then no such `z` exists.

Indeed, let `L_1,...,L_4` cover the support and let `V` be their set of
distinct pairwise intersection points, `r=|V|<=6`.  Three lines contain fewer
than `4q-6` points, so all four are needed.  Their union has at most `4q+1`
points and therefore contains at most seven holes of the support.  Let `G` be
the lines avoiding `V`.  Every line of `G` meets the four covering lines in
four distinct nonvertex points.  If it meets respectively zero, one, two,
three, or four holes, its integer signed sum is respectively `0`, `+/-3`,
`0`, impossible, or `0`; this is just divisibility by three for four, three,
two, one, or zero signs.  Each nonvertex hole lies on at most `q` lines of
`G`, so

```text
| sum_{ell in G} sum_{P in ell} z_P | <= 3q*7 = 21q.       (U)
```

On the other hand, a nonvertex point of the four-line union lies on between
`q-r` and `q` lines of `G`.  Removing the at most `r` signed vertices leaves
signed imbalance at least `2q-r`, and there are at most `q-3` negative
nonvertices.  Consequently the same double sum is at least

```text
(q-r)(2q-r)-r(q-3)
  >= (q-6)(2q-6)-6(q-3) = 2q^2-24q+54.                    (L)
```

For `q>=27`, `(L)` exceeds `(U)` because
`2q^2-45q+54>0`.  This contradiction proves the lemma.

Applying it to `(SD)` eliminates the prescribed five-character
`T=2q+1` inverse-construction branch for every ternary `q>=27`, including all
asymmetric cores.  The earlier Frobenius and low-complexity hull enumerations
remain exact checks, but they are no longer the reason the branch fails.
This is still conditional on the five-character inverse branch: it does not
classify arbitrary target-size extremizers or eliminate the separate
`T=2q` envelope.

There is a second structural step which removes that scope restriction once
`q>=81`.  It starts with an arbitrary complete target-size arc, not an inverse
core.

> **Exact-target obstruction.**  Let `q=3^h>=81`.  There is no complete
> `(q^2/3+4q/3, 2q/3+1)`-arc in `PG(2,q)`.

Write `q=3r`, let `A` be such an arc, and let `D` be the dual point set of
all its maximal secants.  If `T=|D|` and `d=M 1_D`, completeness gives
`d_P>=1` outside `A`.  The two degree sums and the pair partition are

```text
sum_A d=(2r+1)T,      sum_out d=rT,
sum_P binom(d_P,2)=binom(T,2).                         (E1)
```

They first force the exact envelope

```text
T in {6r,6r+1}={2q,2q+1}.                             (E2)
```

Here is a short arithmetic verification, included to keep `(E2)` independent
of a finite search.  There are `K=3r^2+4r` points of `A` and
`N=6r^2-r+1` outside.  Coverage gives `T>=6r`.  Cauchy applied separately to
the two degree classes says that feasibility requires

```text
F(T)=(2r+1)^2 T^2/K-(2r+1)T+r^2 T^2/N-rT-T(T-1) <= 0.
```

The quadratic has positive leading coefficient.  At `T=6r+5`, both it and
its derivative are positive; explicitly their numerators over the positive
denominator `r(3r+4)(6r^2-r+1)` are

```text
(6r+5)(60r^3+17r^2+r+5),
54r^5+63r^4+117r^3+46r^2+2r+10.
```

Thus `T<=6r+4`.  For `T=6r+j`, `j=2,3,4`, the balanced integral degrees are
still `3/4` on `A` and `1/2` outside.  The pair budget minus their exact
minimum is respectively `-4,-r-5,-2r-5`, excluding all three values and
proving `(E2)`.

Now put

```text
u=1+3 1_A-d,                    c=u mod 3,
R=supp(c),                      w=|R|.
```

The design identity gives `c=1-M1_D` in the ternary line code and

```text
M u=(q+1-T)1+3M1_A-q1_D.                              (E3)
```

Directly expanding the three moments in `(E1)` gives the following complete
branch table:

```text
T             sum u       ||u||^2       shell defect E
2q            3q+1        5q+1          2r+1
2q+1          2q          4q-6          r-2.
```

The last column means exactly

```text
E=sum_{P in A} u_P(u_P-1)/2
   +sum_{P outside A} u_P(u_P+1)/2.                    (E4)
```

All summands are nonnegative: on `A`, `u=4-d`; outside, `u=1-d<=0`.
If `P in A` and `u_P=0 mod 3`, then
`u_P<=u_P(u_P-1)/2`; otherwise
`u_P<=1+u_P(u_P-1)/2`.  Consequently

```text
|A intersect R| >= sum_A u-E.                         (E5)
```

Because `w<=||u||^2<=5q+1`, Szőnyi--Weiner Theorem 4.3 applies.  Indeed
`h>2`, `q>27`, and

```text
5q+1 < (floor(sqrt(q))+1)(q+1-floor(sqrt(q)))
```

for `q>=81`.  Hence `c` is a linear combination of exactly
`t=ceil(w/(q+1))` distinct lines, with every coefficient `epsilon_i` equal
to `+1` or `-1`.  Set `z_P` to the balanced representative in
`{-1,0,1}` of `c_P`.  The pointwise inequality

```text
|u_P-z_P| <= u_P^2-z_P^2                              (E6)
```

shows that `|sum u-sum z|<=Delta:=||u||^2-w`.

Consider first `T=2q+1`.  Formula `(E3)` says that `c` is also in the dual
code.  From `(E5)`, `|A intersect R|>=7r+1`; three covering lines contain at
most `3(2r+1)=6r+3` arc points, so `t=4`.  The four coefficients sum to zero
modulo three, hence two are positive and two negative.  Their formal integer
incidence sum has total zero.  Away from the at most six covering-line
vertices it equals `z`; at each vertex the discrepancy has absolute value at
most three.  Since `w>3(q+1)`, `Delta<=q-10`, and therefore

```text
2q=|sum u| <= Delta+18 <= q+8,
```

a contradiction.

Finally let `T=2q`.  Now `(E5)` gives `|A intersect R|>=8r-1`, so `t>=4`,
while the norm bound gives `t<=5`.  By `(E3)` the coefficient sum is one
modulo three.  If `t=4`, that integer sum is `-2` or `4`.  The first case is
impossible because the formal total is `-2(q+1)`, its vertex correction is at
most 18, and `Delta<=2q-3`, whereas its distance from `sum u=3q+1` is
`5q+3`.  In the second case all four coefficients are positive.  The four
lines have at least `4q-8` nonvertex positions with `z=1`.  Every such point
outside `A` has `u<=-2` and consumes at least three units of `Delta`; hence

```text
|A intersect R| >= 4q-8-Delta/3
                >= 4q-8-(2q-3)/3 > 4(2q/3+1),
```

contradicting the arc cap on the four covering lines.  If `t=5`, the five
coefficients have integer sum `1` or `-5`.  The formal total is therefore
`q+1` or `-5(q+1)`.  There are at most ten vertices, each changing the
balanced sum by at most six, and now `Delta<=q-4`.  Even the closer first
total would require a change `2q`, but `(E6)` permits at most `q+56<2q` for
`q>=81`.  This is the final contradiction.

Thus both branches in `(E2)` are impossible.  Unlike the preceding
five-character lemma, this theorem applies to every complete arc of the exact
target size.  It does **not** imply a one-sided bound on `t_s(2,q)`: complete
arc sizes are not monotone, and a smaller size has not been excluded.  What it
does prove is that literal equality at the conjectural center is impossible;
any matching asymptotic construction must carry a nonzero repair in its size
or parameters.

In fact the same compression excludes every bounded additive size repair.

> **Bounded-repair obstruction.**  For each fixed integer `delta`, and all
> sufficiently large `q=3^h`, there is no complete
> `(q^2/3+4q/3+delta, 2q/3+1)`-arc in `PG(2,q)`.  Uniformly, for every fixed
> `H`, no such arc exists with `|delta|<=H` once `q>=q_0(H)`.

Only the bookkeeping changes.  Keep `q=3r` and write `T=6r+j`.  Coverage and
the two-class Cauchy bound localize `j` to a bounded interval depending only
on `H`; the latter bound has its upper root at `6r+O_H(1)`.  The nonnegative
shell defect is now

```text
E=(2-j)r+1+5 delta+j(j-7)/2.                           (BR1)
```

For bounded `j,delta` and large `r`, `(BR1)` leaves only
`j in {-1,0,1,2}`; coverage removes `j=-1` when `delta<=0`.  The other exact
moments are

```text
sum u   =(9-3j)r+3 delta-j+1,
||u||^2 =(15-3j)r+15 delta+j^2-8j+1,
sum_A u =(10-2j)r+4 delta-j.                           (BR2)
```

Theorem 4.3 again writes `c=u mod 3` as a sum of `t` distinct lines.  From
`(E5)`, the arc cap, and the norm bound, the only asymptotic ranges are

```text
j=-1: t in {5,6,7};   j=0: t in {4,5,6};
j= 1: t in {4,5};     j=2: t in {3,4}.                 (BR3)
```

Let `sigma=sum epsilon_i`.  Equation `(E3)` gives
`sigma congruent 1-j (mod 3)`, while parity gives
`sigma congruent t (mod 2)`.  Away from `O(t^2)` vertices, the balanced
residue sum is the formal total `sigma(q+1)`.  Also

```text
Delta=||u||^2-w <= (6-j-t)q+O_H(1).                   (BR4)
```

Comparing `(BR2)`, `(BR4)`, and `(E6)` eliminates every coefficient pattern
in `(BR3)` except

```text
(j,t,sigma)=(-1,5,5) or (0,4,4).                      (BR5)
```

For transparency, these are not hidden optimization cases: they are the only
parity/congruence possibilities whose leading discrepancy
`|3-j-sigma|q` is at most `(6-j-t)q`.  In both cases every coefficient is
positive.  The `t` lines then have at least `t(q+2-t)` nonvertex coordinates
with balanced residue `+1`.  Each such coordinate outside `A` has `u<=-2`
and costs at least three units of `Delta`.  For `(j,t)=(-1,5)` this forces
at least `(13/3)q-O_H(1)` arc points onto five lines, whose arc-capacity is
only `(10/3)q+5`; for `(j,t)=(0,4)` it forces at least
`(10/3)q-O_H(1)` arc points onto four lines, whose capacity is
`(8/3)q+4`.  Both are impossible for large `q`, proving the theorem.

At this stage alone, any putative matching `(UB3)` witness would need an
unbounded `o(q)` repair.  The next quantitative pass shows that even this is
impossible and determines the sign of the deviation using C945's lower side.

The inequalities actually have enough uniform slack to rule out a linear
band, which changes the asymptotic conclusion.

> **Linear-gap theorem.**  Fix `c<1/18`.  For all sufficiently large
> `q=3^h`, there is no complete `(k,2q/3+1)`-arc with
>
> ```text
> |k-(q^2/3+4q/3)| <= cq.                              (LG1)
> ```

To see the uniformity, write `delta=alpha q` with `|alpha|<=c`.  Coverage
still gives `j>=-1`.  The two-class Cauchy polynomial at `T=6r+7` has leading
term `(6-45alpha)r`, and its derivative there has positive leading term;
hence `j<=6` for large `q`.  Dividing `(BR1)` by `r` gives

```text
E/r=2-j+15alpha+o(1).
```

Since `c<1/18<1/15`, nonnegativity excludes `j=3,4,5,6`, leaving the same
four offsets and the same line-count ranges `(BR3)`.  The exact small-codeword
threshold remains applicable because all norms are still `O(q)`.

After division by `q`, the necessary coefficient comparison becomes

```text
|3-j+3alpha-sigma| <= 6-j-t+15alpha+o(1).             (LG2)
```

The ten parity/congruence rows in the tracked arithmetic audit show that,
apart from the two all-positive cases `(BR5)`, the smallest unused margin in
`(LG2)` is `1-18c>0`.  The all-positive cases also remain impossible
uniformly: their excesses over the five- and four-line arc capacities are
respectively

```text
(1-5alpha)q-O(1),       (2/3-5alpha)q-O(1),
```

both positive for `c<1/18`.  This proves `(LG1)`.

Now combine `(LG1)` with C945's unconditional lower side `(LB3)`.  For each
fixed `c<1/18`, `(LB3)` eventually rules out the component below the forbidden
band, so the minimum must lie above its upper edge.  Letting `c` increase to
`1/18` gives the sharpened asymptotic lower bound

```text
T_3(q) >= q^2/3+25q/18-o(q).                           (LB3+)
```

In particular `(UB3)` and `(ASY3)` with linear coefficient `4/3` are false.
The endpoint `1/18` here is the limiting margin of this four-offset
coefficient argument; no construction matching `25/18`, and no claim that
this new coefficient is optimal, is made.

#### Sharp compression of the linear obstruction

The preceding coefficient table leaves substantial artificial slack.  Two
pointwise identities remove it and locate the actual first phase boundary.

> **Three-line linear-gap theorem.**  Fix `C>0` and `epsilon>0`.  For all
> sufficiently large `q=3^h`, there is no complete
> `(k,2q/3+1)`-arc with
>
> ```text
> k=q^2/3+4q/3+delta,
> -Cq <= delta <= (1/3-epsilon)q.                    (TL1)
> ```

As before, write `T=2q+j` for the number of maximal secants.  Coverage and
the two-class Cauchy inequality make `j=O_{C,epsilon}(1)`; at
`delta=alpha q`, the leading Cauchy term at `T=2q+j` is
`(3j-15-45alpha)q/3`.  Hence the exact moment formulas `(BR1)`--`(BR2)` give
`E, ||u||^2=O(q)`, and Szőnyi--Weiner writes `c=u mod 3` as an exact sum of a
bounded number `t` of distinct lines with coefficients `+1` and `-1`.

Let `z in {-1,0,1}` be the balanced residue of `u`, let `w=|supp(z)|`, and
write `e_P` for the summand of `(E4)` at `P`.  The first new pointwise
inequality is

```text
2 1_A(P) u_P-e_P-u_P <= 1_{z_P != 0}.                (TL2)
```

It is just the integer shell: on `A` its left side is
`u-u(u-1)/2`, and outside it is `-u(u+3)/2`; checking the three residue
classes gives `(TL2)`.  After summation, the exact moments collapse to

```text
3q-(j-1)(j-4)/2 = 2 sum_A u-E-sum u <= w.            (TL3)
```

The support of a sum of `t` fixed distinct lines has size `tq+O(t^2)`:
every nonvertex point of every generator line is nonzero.  Thus `(TL3)`
forces

```text
t>=3.                                                  (TL4)
```

For the opposite inequality, let `sigma` be the sum of the line
coefficients and let `a=(t+sigma)/2` be the number of positive generator
lines.  Pointwise,

```text
(u_P^2-z_P^2)-(u_P-z_P) >=0,                          (TL5)
```

and it is at least six whenever `z_P=1` and `P` is outside `A`.  Away from
`O(t^2)` vertices, the positive residue occurs at `aq+O(1)` points.  The
`a` positive lines carry at most `a(2q/3+1)` arc points, so at least
`aq/3-O(1)` of those positive residues are outside `A`.  Consequently

```text
(||u||^2-w)-(sum u-sum z) >= 2aq-O(1).                (TL6)
```

Now `w=tq+O(1)` and `sum z=sigma q+O(1)`.  Substitution of `(BR2)` into
`(TL6)` cancels `j` and `sigma` completely:

```text
(2+12alpha-t+sigma)q+O(1)
    >= (t+sigma)q+O(1),
t <= 1+6alpha+o(1).                                  (TL7)
```

Together `(TL4)` and `(TL7)` give `alpha>=1/3-o(1)`, contradicting `(TL1)`.
This is the structural reason the earlier `1/18` margin was loose: the shell
itself needs three generator lines, while positive-line capacity cannot pay
for three lines before displacement `q/3`.

Combining this theorem with C945's lower side gives

```text
T_3(q) >= q^2/3+5q/3-o(q).                            (LB3++)
```

The equality scale is rigid as well.

> **Exact `5/3` endpoint obstruction.**  For all sufficiently large
> `q=3^h`, there is no complete
> `(q^2/3+5q/3,2q/3+1)`-arc in `PG(2,q)`.

At `delta=q/3`, `(TL3)`--`(TL7)` force `t=3`.  Coverage, the arc cap,
coefficient congruence, and the exact sum/norm budget leave, after two scalar
rows are removed, only

```text
(j,sigma)=(1,-3),(2,-1),(3,1),(4,-3),(4,3),(5,-1).   (TL8)
```

The discarded `(7,-3)` row has `||u||^2=3q-6<w`, while `(1,3)` has no
negative support at leading order and the inequality
`sum_A u <= E-|R_+|+2|A intersect R_+|+O(1)` bounds its left side by
`3q+O(1)` instead of the required `4q+O(1)`.

The three generator lines cannot be concurrent.  For the all-equal signs in
`(TL8)`, the exact inequalities `|sum u-sum z|<=||u||^2-w` exclude
`(1,-3)`, `(4,-3)`, and `(4,3)`.  For the mixed rows, `(TL6)` is short by
exactly six: the positive generators are maximal secants, but their positive
nonvertices leave at least `q/3-1` external positive residues for
`j=2,5`, and at least `2q/3-1` for `j=3`.

Thus the generators form a triangle.  Dualize them to noncollinear points
`Q_i`.  A positive `Q_i` belongs to `D`, every ordinary line through it has
degree three, and the sum of its two connector degrees is `j+3`.  A negative
`Q_i` is outside `D`, every ordinary line through it has degree two, and its
connector sum is `j+2`.  Solving these three pencil equations eliminates the
first four rows of `(TL8)` and leaves only

```text
(j,sigma)=(4,-3), (5,-1).                             (TL9)
```

For `(4,-3)`, the positive residue consists only of the three triangle
vertices.  On `A`, the sharper pointwise inequality

```text
u_P <= 2e_P+1_{z_P=1}
```

would give

```text
2q-4=sum_A u <=2E+3=2q-7,
```

which is impossible.

Finally consider `(5,-1)`.  Equality in `(TL3)` forces every line degree to
be one of `1,2,3,4`; the exact spectrum has `2q-2` degree-two lines, `q`
degree-three lines, and

```text
N_4=q(q+2)/3+2
```

degree-four lines.  Let `A_i` count selected primal points whose dual line
has degree `i`, put `a=A_1`, and put `h=N_4-A_4`.  The equations
`sum A_i=k` and `sum i A_i=(2q/3+1)(2q+5)` reduce exactly to

```text
A_3=2q/3+1+a+2h.                                     (TL10)
```

Only one of the degree-three points lies off the positive generator line, so
its arc cap gives `a+2h<=1`.  Hence `h=0`: both degree-four connector
vertices are selected.  Equation `(TL10)` then puts at least `2q/3` selected
degree-three points on that same generator, and the two connector vertices
raise its intersection to at least `2q/3+2`, one above the allowed maximum.
This excludes the last row.

The tracked arithmetic replay for `(TL3)`, `(TL8)`, and the two final exact
contradictions is
`notes/2026-08-25-c949-sharp-linear-coefficient-audit.json`.  This endpoint
nonexistence is not a matching upper bound: sharpness of the coefficient
`5/3` would require constructions with a nonzero `o(q)` positive repair
(possibly the constant repair `+1`), and no such construction is presently
known.

There is nevertheless a sharp stability reduction for that construction
problem.

> **Sublinear-repair rigidity.**  Suppose a sequence of complete arcs has
>
> ```text
> k=q^2/3+5q/3+eta(q),      eta(q)=o(q).
> ```
>
> Then, for all sufficiently large fields in the sequence, the residue word
> `c=u mod 3` is an exact signed combination of exactly three distinct lines.

Indeed, coverage and Cauchy again keep `j=T-2q` bounded, while `(TL3)` gives
`t>=3` and `(TL7)` gives `t<=3+6eta(q)/q+o(1)`.  Integrality forces `t=3`.
After passage to a subsequence, `j`, the coefficient signs, and whether the
three lines are concurrent or triangular are fixed.  Here one must not reuse
the endpoint's constant-slack exclusions: an `o(q)` repair can absorb them.
The raw enumeration is short enough to expose.  Coverage and nonnegative
shell defect give `-2<=j<=7`; coefficient congruence gives
`sigma congruent 1-j (mod 3)`; and the leading sum/norm correction gives
`2j+sigma<=11`.  The exact support of three concurrent lines is `3q` for
`sigma=+-3` and `3q+1` for `sigma=+-1`, while for a triangle it is `3q` and
`3q-2`, respectively.  In the concurrent case the infinity line contains
`j` core points, including exactly `a=(3+sigma)/2` distinguished points, so
`j>=a`.  In the triangular case, if `p_i` records whether generator vertex
`Q_i` is positive, its connector to `Q_j` has degree

```text
x_ij=(j+2+p_i+p_j-p_k)/2.
```

Requiring these three degrees to be positive integers completes the pencil
audit.  Together these conditions give the following complete *raw* core
list:

```text
concurrent: (j,sigma)=(1,-3),(2,-1),(3,1),(4,-3),
                      (4,3),(5,-1),(7,-3),
triangle:   (j,sigma)=(0,1),(1,3),(4,-3),(5,-1).     (SR1)
```

For the triangle rows the connector degrees are, respectively,
`(2,1,1)`, `(2,2,2)`, `(3,3,3)`, and `(4,4,3)`.  The first two are exactly
the Bruen--Fisher adjacent cores treated below; the endpoint proof excludes
them only when `eta=0`, so their sublinear exclusion needs a separate
argument.

The concurrent branch has an especially compact affine form.  Dualize the
three generator lines to collinear points `Q_1,Q_2,Q_3` on a connector
`ell_infinity`.  The connector contains exactly `j` points of `D`, so

```text
X=D\ell_infinity,             |X|=2q.
```

Every affine line in each of the three distinguished directions contains
exactly two points of `X`: a positive `Q_i` belongs to `D` and its projective
lines have degree three, whereas a negative `Q_i` is outside `D` and its
lines have degree two.  In every other direction the affine line sums are
constant modulo three.  Thus concurrence is exactly the problem of
classifying `2q`-point binary affine Radon ghosts with three genuinely
two-uniform directions.

This affine statement has an exact two-permutation normal form.  Send the
three distinguished directions to `infinity,0,1`.  The first two
two-uniform parallel classes make the incidence graph of `X` on the two
coordinate copies of `F_q` a two-regular bipartite graph.  Its two perfect
matchings give disjoint permutations `f,g:F_q -> F_q` with

```text
X={(x,f(x)):x in F_q} disjoint union {(x,g(x)):x in F_q},
{f(x)-x,g(x)-x:x in F_q}=2 F_q                         (SR1a)
```

as multisets.  For a finite slope `m` put

```text
R_m(T)=product_x (T-f(x)+mx)(T-g(x)+mx).              (SR1b)
```

Let `a=(3+sigma)/2` be the number of positive generators and
`m_0=j-a` the number of nondistinguished infinity points that lie in `D`.
The constant-residue condition on every parallel class is equivalent,
without any degree-size assumption, to the exact factorization ledger

```text
three distinguished directions: R_m=(T^q-T)^2;
m_0 other directions:             R_m=H_m(T)^3,
                                   deg H_m=2q/3;
q-2-m_0 other directions:         R_m=(T^q-T)H_m(T)^3,
                                   deg H_m=q/3.         (SR1c)
```

Here the first line includes the vertical direction in the natural
homogeneous interpretation.  Conversely, `(SR1a)--(SR1c)` recover all the
parallel-class residues, hence the concurrent Radon core.  The seven rows of
`(SR1)` have `m_0=1,1,1,4,1,4,7`, respectively.  This is the sharp algebraic
interface for the remaining construction problem: one needs two disjoint
permutations whose combined projections are exact double covers in three
directions, cubes in `m_0` directions, and a field polynomial times a cube
in every remaining direction.  It also shows why a numerical search is not
yet a proof mechanism: the unknown object is now a field-uniform family of
Rédei factorizations, not merely a finite configuration.

The factorization ledger has a projective coefficient compression that is
uniform across all seven concurrent rows.  Homogenize direction and
intercept variables by

```text
mathcal R(M,N,T)=product_x
 (T-Nf(x)+Mx)(T-Ng(x)+Mx).
```

Expand

```text
mathcal R=sum_(i=0)^(2q)(-1)^i E_i(M,N)T^(2q-i),
deg E_i=i.
```

In every rational direction, `(SR1c)` expresses the specialized product as
a cube, a field polynomial times a cube, or the square of a field
polynomial.  None has a `T`-exponent congruent to two modulo three except the
final `T^2` term of a double cover.  Hence, for

```text
i=1,4,...,2q-5,
```

the form `E_i` vanishes at every point of `PG(1,q)`.  The homogeneous
vanishing ideal of those points is generated by

```text
Phi_dir(M,N)=M^qN-MN^q.
```

Consequently the whole forbidden-coefficient ladder is

```text
E_i=0,                         1<=i<=q-2, i=1 mod 3,
E_i=Phi_dir Q_i,  deg Q_i=i-q-1,
                              q+1<=i<=2q-5, i=1 mod 3. (SR1e)
```

Thus an entire third of the coefficients above `T^(q+2)` vanish identically;
the coefficient of `T^(q+2)` vanishes as well, and the coefficient of
`T^(q-1)` is a scalar multiple of `Phi_dir`.  Reindexing
`i=q-2+3s` shows that at every fixed depth `s>=1` below that middle boundary,
the residual quotient has bounded degree `3s-3`.  This is the concurrent
analogue of the bounded Witt blind spot.  It is not yet a classification:
the quotients `Q_i` must still be
coupled through the fact that one pair of disjoint permutations produces all
coefficients of `mathcal R`.

The first nominal quotient in `(SR1e)` vanishes too.  Put

```text
S=sum_x x(f(x)+g(x))
```

and let `p_k(M)` be the `k`-th power sum of the `2q` projected roots in a
finite direction.  Permutation power sums and characteristic three give

```text
p_1=0,        p_2=MS,
p_4=-MA-M^3B
```

for two mixed moments `A,B`.  Newton's identity at level four is
`p_4+E_2p_2+E_4=0`, with `E_2=p_2`.  The forbidden-exponent argument already
gives `E_4=0` identically, so comparison of the `M^2` coefficient yields
`S^2=0`, hence `S=0`.  On the other hand, the coefficient of `M^qN` in
`E_(q+1)` is, up to a nonzero sign, exactly `S`: deleting one occurrence of
`x` from the doubled coordinate multiset gives elementary coefficient
`e_q=x`.  Therefore

```text
E_(q+1)=0.                                          (SR1e')
```

Thus the `T^(q-1)` coefficient vanishes rather than merely being a scalar
multiple of `Phi_dir`; the first possible Dickson-supported forbidden term
is the `T^(q-4)` coefficient, with a cubic quotient.  This is a genuine
bounded-symbolic compression, but no contradiction follows until those
cubic data are coupled to disjointness and the three double-cover
projections.

The top cube coefficient explains why the seven signatures reduce to only
three affine ghost types.  Let `b(M)` be the coefficient of `T^q` in
`partial_T R_M`.  It has degree at most `q-1`.  At the two finite
distinguished double-cover slopes it equals `1`; at each of the `m_0` cube
slopes it is zero; and at every remaining finite slope it is `-1`.  With
`delta_a(M)=1-(M-a)^(q-1)`, uniqueness of the reduced function polynomial
therefore gives

```text
b=-1+sum_(a in S)delta_a+2delta_0+2delta_1,
|S|=m_0.
```

But `b` is also the `T^(q+1)` coefficient of `R_M`, whose leading
`M^(q-1)` coefficient is `e_(q-1)({x,x:x in F_q})=1`.  Comparing leading
coefficients gives

```text
2-m_0=1 in F_3,        m_0=1 mod 3.                 (SR1f)
```

Thus the concurrent affine geometry has only the three cases
`m_0 in {1,4,7}`; the seven rows merely add different sign/core decorations
at infinity.  This recovers the arithmetic congruence by a polynomial
mechanism and identifies the three cases a classification theorem must
actually treat.

There is also an exact low--high reciprocity on the one-residue slopes.  On
such a slope

```text
R_M+(T^q-T) partial_T R_M=0.
```

The coefficient of `T^(2q-j)` is
`(-1)^j((j+1)E_j+(1-j)E_(q-1+j))`.  Hence for
`j=0 mod 3`, `3<=j<=q-3`, the sum
`P_j=E_j+E_(q-1+j)` vanishes on every one-residue slope.  Let `U` be their
set, so `|U|=q-2-m_0`.  Homogenizing also captures the two finite
double-cover directions and the vertical direction:

```text
N^(q-1) E_j+E_(q-1+j)
 =N M(M-N) prod_(u in U)(M-uN) B_j(M,N),
deg B_j<=j+m_0-2.                                (SR1g)
```

In particular `B_3` has degree at most `2,5,8` in the three ghost types
`m_0=1,4,7`.  This is a second bounded field-symbolic object: it couples a
low coefficient to one across the middle of the Rédei product and is
supported only at the cube slopes.

The coupling is not yet the desired cubic obstruction.  The indicator
polynomial `b` in `(SR1f)` recovers the support `U`, but not `B_3`; the top
coefficient of `E_3+E_(q+2)` is the unrestricted correlation
`-sum_x x^2(f(x)+g(x))`.  Nor does `E_7=0` kill the cubic `Q_(q+4)` in
`(SR1e')`: after `E_4=0`, Newton reduces `E_7=0` to `p_7=0`, whereas the top
coefficient of that `Q_(q+4)` is `-sum_x x^4(f(x)+g(x))` and occurs in
`p_5`.  A global split/permutation theorem, not formal coefficient
reciprocity, must provide any further identification.

The normal form immediately excludes the obvious Bruen--Fisher-style affine
repair.  Consider two shifted two-term linearized cubics

```text
f(x)=alpha x^3+a x+c,       g(x)=beta x^3+b x+d,      (SR1d)
```

with `alpha beta !=0`.  The projection `f(x)-mx` has three-element kernel
exactly when `(m-a)/alpha` is a nonzero square, and similarly for `g`.
For an ordinary direction to have residue one, exactly one of these two
kernels must have size three.  If `a!=b`, the correlation identity

```text
sum_m chi((m-a)(m-b))=-1
```

shows that, among the `q-2` slopes away from `a,b`, the two character signs
agree `(q-3)/2` times and disagree `(q-1)/2` times.  Whichever square classes
`alpha,beta` occupy, at least `(q-3)/2` slopes therefore have the wrong
kernel pattern, whereas `(SR1c)` permits only two further double-cover slopes
and `m_0<=7` cube slopes.  If `a=b`, the pattern is constant away from `a`
only when `alpha beta` is a nonsquare; then `m=a` is the sole finite
double-cover direction.  Worse, `alpha!=beta` and
`f-g=(alpha-beta)x^3+(c-d)` has exactly one zero, so the two graphs are not
disjoint.  Thus no pair `(SR1d)` realizes a concurrent row for large `q`.
The obstruction is family-specific; it does not classify the arbitrary
permutations in `(SR1a)`.

For any surviving triangular row the remaining task is to construct such a
binary blocking core and choose the primal lines through it so that every
core point has degree `2q/3+1` and no other point exceeds that degree.  This
is a finite geometric classification plus a regular incidence selection,
not an expanding line-code search.  The exact endpoint proof says only that
repair zero fails; repair `+1` is the first honest construction target.

The closest field-uniform object is classical, but a short switch from it is
impossible.  Bruen--Fisher Theorem 12 constructs, for a nonsquare `tau` in
`F_q` and `q=3^h`, `h>=2`, the blocking set

```text
D_BF={(x,x^3):x in F_q} union {(x,tau x^3):x in F_q}
     union {vertical point at infinity}.             (SR2)
```

The affine cubics meet at the origin, so `|D_BF|=2q`.  Their discriminant
argument gives the exact line spectrum

```text
1^[2(q^2-q+3)/3]  2^q  3^[2q-2]
4^[(q-1)(q-3)/3].                                   (SR3)
```

More revealingly, let `C` be the vertical point at infinity, `H` the
horizontal point at infinity, and `O` the origin.  In the dual line-index
plane,

```text
1-M1_{D_BF}=1_{L_C}+1_{L_O}-1_{L_H}  (mod 3).        (SR4)
```

Indeed, the supported lines are the vertical pencil, the nonzero horizontal
lines, and the non-axis lines through `O`; their three vertex values give
exactly the signed triangle in `(SR4)`.  Thus Bruen--Fisher realizes the
adjacent core `(j,sigma)=(0,1)`.  Adding `H` flips the negative coefficient
and realizes `(1,3)`, precisely the scalar row already excluded from inverse
arc realization.

There is no four- or five-point switch from `(SR2)` to either admissible core.
For any three-line core write its dual coefficient vector as `epsilon`, so

```text
M(1_D+epsilon)=1  (mod 3).                            (SR5)
```

If `D,D'` are two such cores, then
`v=(1_{D'}-1_D)+(epsilon'-epsilon)` lies in the ternary dual incidence code.
Any nonzero dual word has weight at least `q+2`: choose a nonzero coordinate;
each of the `q+1` lines through it needs a second support point, and those
lines are disjoint away from the chosen point.  Hence
`|D triangle D'|<q-4` forces `v=0`.  Applied to `(SR4)`, coordinatewise
binary feasibility then forces the same three dual points.  Flipping a
positive sign removes that point from `D`, while flipping the negative sign
adds it.  The all-negative and one-positive/two-negative outcomes therefore
have sizes only `2q-2` and `2q-1`, not `2q+4` and `2q+5`.

There is a second, independent reason the adjacent core itself cannot be
repaired.  It rules out even a sublinear change in the selected-line family.
The origin `O` and vertical point `C` in `(SR2)` each lie on one tangent, one
bisecant, and `q-1` trisecants; their trisecant pencils are disjoint because
their common line is the bisecant `OC`.  Every other point of `D_BF` lies on

```text
q/3 tangents, 1 bisecant, 2 trisecants, 2q/3-2 four-secants. (SR6)
```

For completeness, `(SR6)` follows without another character sum.  Scaling
is transitive on the nonzero points of each cubic.  A generic point has its
horizontal bisecant and its vertical and radial trisecants.  Subtracting the
two exceptional point profiles from the global spectrum `(SR3)` forces the
two generic-orbit profiles to have, in total, `2q/3,2,4,4q/3-4` lines of
degrees `1,2,3,4`; the three displayed known lines split the middle two
counts equally, and the point-pencil sum then gives `(SR6)` for each orbit.
In particular every point has a tangent, so `D_BF` is minimal as a blocking
set.

Now suppose `D_BF` itself were the exact saturated maximal-secant core of an
arc of size

```text
k=q^2/3+5q/3+eta.
```

Let `A_i` count selected dual lines meeting `D_BF` in `i` points, and write
`h=N_3-A_3`, `H=N_4-A_4`.  Saturation gives
`sum i A_i=2q(2q/3+1)`, while `sum A_i=k`.  Substitution of `(SR3)` yields
the exact identity

```text
A_2=q/3+1-eta+2h+3H.                                (SR7)
```

Since there are only `N_2=q` bisecants,

```text
2h+3H <= 2q/3-1+eta.                                (SR8)
```

At each of `O,C`, the arc cap forces omission of at least
`q-1-(2q/3+1)=q/3-2` of its trisecants.  The pencils are disjoint, so
`h>=2q/3-4`.  Combining this with `(SR8)` gives

```text
eta >= 2q/3-7.                                      (SR9)
```

The adjacent all-positive row is equally rigid.  Put
`D_BF^+=D_BF union {H}`.  Its exact spectrum is

```text
(N_1,N_2,N_3,N_4)
 =(2(q^2-q+3)/3-2, 3, 3q-3, (q-1)(q-3)/3).          (SR10)
```

The three points `O,C,H` each lie on `q-1` trisecants, and these three
pencils are pairwise disjoint because their connector triangle consists of
bisecants.  If `D_BF^+` were the exact saturated core, the same notation and
the two selected-line equations would give

```text
A_2=-q+4-eta+2h+3H <= N_2=3,
h>=3(q/3-2)=q-6.
```

Consequently `eta>=q-11`.  Thus neither of the two adjacent triangular rows
in the raw list `(SR1)` can occur with `eta=o(q)`.  The genuine sublinear
frontier is therefore exactly

```text
concurrent: (j,sigma)=(1,-3),(2,-1),(3,1),(4,-3),
                      (4,3),(5,-1),(7,-3),
triangle:   (j,sigma)=(4,-3),(5,-1).                (SR11)
```

Bruen--Fisher is not merely one bounded switch away from sharpness.  A
sharpness construction, if it exists, needs a genuinely global `Omega(q)`
Radon trade that also removes the overloaded trisecant pencils, followed by
the regular incidence selection.  A bounded local switch or a wider bounded
census cannot find the mechanism.

The first honest constant-repair target is now completely numerical.  In the
triangular `(j,sigma)=(4,-3)` row, equality in the shell gives the exact core
spectrum

```text
(N_1,N_2,N_3,N_4)
 =((2q^2-8q+3)/3, 3q-3, 3, q(q+2)/3).               (SR12)
```

For an arc of size `q^2/3+5q/3+eta`, let `h=N_3-A_3` and
`H=N_4-A_4` count omitted high secants.  The selected-line count and saturated
incidence count solve to

```text
A_1=-1+2eta-h-2H,          A_2=q-2-eta+2h+3H.       (SR13)
```

Thus `h+2H<=2eta-1`.  At the minimal possible repair `eta=1`, necessarily
`h=H=0`, and the selector spectrum is uniquely

```text
(A_1,A_2,A_3,A_4)=(1,q-3,3,q(q+2)/3).               (SR14)
```

Consequently a field-uniform `(SR12)` core, all of whose three trisecants and
four-secants together with `q-3` bisecants and one tangent form an
`s=2q/3+1` regular incidence selection on the core and have off-core degree at
most `s`, would prove the sharp upper bound with constant repair `+1`.
Conversely, every `+1` realization in this row has exactly that form.  This is
substantially smaller than searching all primal point sets: the only selector
freedom is one tangent and `q-3` bisecants after the core is known.

There is also an exact local normal form.  Let `V` be the three triangle
vertices, let `B` be the `q-3` selected side-nonvertices, let `U` be the other
`2q` side-nonvertices, and let `T` be the unique selected tangent point.  At
`eta=1` the integer shell is

```text
u=3 1_T+2 1_B-1 1_U+1 1_V.                          (SR15)
```

For every maximal-secant line `ell in D`, the exact design identity gives
`sum_{P in ell}u_P=0`.  Hence the `2q+4` lines of `D` split rigidly:

```text
9 vertex lines:    three through each vertex of V; each meets the
                   opposite side in U and avoids T;
1 tangent line:    the unique D-line through T; its three side
                   intersections all lie in U;
2q-6 generic lines: avoid V union {T} and meet the three sides in
                    exactly one point of B and two points of U.   (SR16)
```

Every side nonvertex has `D`-degree two.  It follows that the `q-3` points of
`B` pair the `2q-6` generic lines into a perfect matching.  The three triangle
sides themselves give three near-perfect matchings on `D`: the matching on a
side omits the six vertex lines through its endpoints, and the union of its
selected edges over the three sides is exactly that perfect matching.

Equivalently, if `r_L` is the number of selected low-degree points needed on
a line `L in D` and `c_L` records whether it passes through a triangle vertex,
the pencil equations are

```text
n_3(L)=c_L,
n_2(L)=3r_L+c_L,
n_4(L)=2q/3+1-r_L-c_L,
n_1(L)=q/3-2r_L-c_L.                                (SR17)
```

Thus the nine vertex lines have
`(n_1,n_2,n_3,n_4)=(q/3-1,1,1,2q/3)`, while the tangent line and all generic
lines have `(q/3-2,3,0,2q/3)`.  This converts the `+1` sharpness problem into
a geometric realization of three compatible near-perfect matchings plus the
off-core fourfold-intersection condition; no free degree sequence remains.

In coordinates this becomes an almost-duplex rather than an unstructured
point set.  Take the support triangle as the coordinate triangle and write a
generic line of `D` as

```text
a x+b y+z=0,             (a,b) in (F_q^*)^2.
```

The `2q-5` generic-or-tangent lines give a set
`H subset (F_q^*)^2`.  Pairing at the three triangle sides is equality of,
respectively, `a`, `b`, and `a/b`.  In each of these three projections the
fiber distribution on `H` is exactly

```text
1^3 2^(q-4): every value of F_q^* occurs, three once and q-4 twice. (SR18)
```

The three singleton fibers are paired on that side with the three appropriate
vertex lines.  If their value sets are `A_0,B_0,C_0` for the projections
`a,b,a/b`, multiplication over `H` gives the necessary product constraint

```text
product A_0=(product B_0)(product C_0).              (SR19)
```

To see the sign exactly, a projection with singleton product `P` has product
over all its values on `H` equal to `P^(-1)`: the product of every element of
`F_q^*` is `-1`, whose square is one, while the nonsingleton values occur
twice.  Applying this to `a`, `b`, and `a/b`, then using
`product(a/b)=product(a)/product(b)`, gives `(SR19)`.

There is an exact finite completion test behind this identity.  The set `H`
extends by three new torus cells to a full duplex if and only if there is a
bijection `pi:A_0 -> B_0` such that

```text
{a/pi(a):a in A_0}=C_0
```

as a multiset and none of the three cells `(a,pi(a))` is already in `H`.
Indeed the deficient fibers in each projection are exactly its three
singletons, so any completion must, and such a bijection does, fill all nine
deficits once.  Thus the product equation `(SR19)` is necessary but not by
itself a completion theorem: the nonextendable branch is a literal
three-by-three transversal obstruction.                         (SR19c)
In the extendable branch, the completed `a`--`b` incidence graph is
two-regular bipartite and therefore splits into two disjoint perfect
matchings.  So that branch is exactly a two-permutation full duplex followed
by deletion of a three-cell transversal; the complementary branch fails the
finite test before any geometric line-cap analysis.

The gate has an exact two-scalar form.  For a three-set `S`, write
`e_j(S)` for its elementary symmetric functions.  For each of the six
bijections `pi:A_0 -> B_0`, put `r_a=a/pi(a)`.  The product identity
`(SR19)` already gives `e_3({r_a})=e_3(C_0)`, so equality of the two
three-element multisets is equivalent to just

```text
sum_a a/pi(a) = e_1(C_0),
sum_a pi(a)/a = e_2(C_0)/e_3(C_0).                  (SR19d)
```

Indeed the second equation is the `e_2` equation divided by the common
nonzero product.  Thus nonextendability is not an amorphous Latin-square
failure: after deleting forbidden cells, it is the failure of six explicitly
defined points in `F_q^2` to hit one prescribed pair.  This compresses the
finite gate but does not make the product identity sufficient.

The distinction is real already at the singleton-data level over `F_81`.
For an element `zeta` of order eight, take singleton sets with exponent sets

```text
A_0=B_0={0,1,2},             C_0={0,3,5}.
```

Their exponent sums satisfy `(SR19)`.  The six bijections give ratio-exponent
multisets
`{0,0,0}`, `{0,1,7}` twice, `{2,7,7}`, `{1,1,6}`, and `{0,2,6}`;
none is `C_0`.  Hence no appeal to the scalar product identity may silently
replace the transversal gate.

The selected bisecants are `q-3` double fibers drawn from the three
projections; their edges form a perfect matching of `H\{t}`, where `t` is the
unique tangent-line element and lies in no selected fiber.  What remains
beyond this almost-duplex layer is precisely geometric: adjoining the nine
boundary elements must produce a blocking `2q+4`-set with no intersections
above four, and every noncoordinate line must have degree `1,2`, or `4`.
This is the appropriate reduced input for discovery computation; a duplex
alone is not the sought construction.

Equivalently, join two elements of `H` by an edge of color `a`, `b`, or
`a/b` when they form a double fiber in that projection.  The resulting
three-edge-colored graph has

```text
|V|=2q-5,       |E|=3(q-4),       9 missing color incidences. (SR19a)
```

The selector is a near-perfect matching of size `q-3` leaving exactly `t`
unmatched.  This graph, together with the singleton product identity and the
line-cap tests, is the appropriate Rust discovery state; the full
`q^2+q+1`-point plane is no longer the search state.

If `b_i` is the number of selected matching edges of the three colors, then

```text
b_1+b_2+b_3=q-3,             0<=b_i<=2q/3-2.         (SR19b)
```

The strict upper bound uses that `D` contains *all* maximal secants.  The
triangle vertex for color `i` lies outside `D` and is incident with its two
selected connector trisecants and the `b_i` selected ordinary bisecants.  Its
selected degree is therefore `b_i+2<=s-1`, not merely `<=s`; equality would
make it another point of `D`.

Indeed the canonical cyclic duplex fails for a sharp geometric reason.  If
`gamma` generates `F_q^*`, the two graphs

```text
b=a^(-1),             b=gamma a^(-1)                (SR20)
```

form a full duplex: the `a`- and `b`-fibers have size two, while in exponent
coordinates the `a/b` values are the even and odd residues, each twice.
Deleting three cells supplies the fiber counts `(SR18)`.  Geometrically,
however, `(SR20)` is the affine part of the two conics
`ab=z^2` and `ab=gamma z^2`.  For `c!=0`, an affine line `b=ma+c` misses both
conics whenever

```text
chi(c^2+m)=chi(c^2+gamma m)=-1.
```

The two linear factors in `m` have distinct roots.  Their quadratic-character
correlation sums to `-1`, so for each `c!=0` at least `(q-5)/4` slopes miss
both conics.  Thus at least

```text
(q-1)(q-5)/4                                             (SR21)
```

affine lines miss the duplex carrier.  The nine boundary points can cover at
most `9(q+1)` of them, and `(SR21)>9(q+1)` for every ternary `q>=81`.
Deleting cells only worsens coverage.  Hence the canonical cyclic duplex
cannot produce the blocking core.  A successful almost-duplex must be
geometrically nonlinear enough to collapse a quadratic number of common
external lines, while retaining the three projection profiles and the
four-secant cap.

There is a complementary affine-blocking formulation.  In the same dual
coordinates, the nine boundary elements consist of three points on each
coordinate side.  Six are affine and three lie at infinity.  Hence

```text
B_aff=H union {the six affine boundary points},      |B_aff|=2q+1, (SR22)
```

meets every affine line in all but the three directions represented by the
infinite boundary points.  In any one of those `q-2` directions, the six
added points lie on at most six parallel lines.  Consequently the projection
of `H` in that direction omits at most six values of `F_q`.  Thus the unknown
torus set simultaneously satisfies

```text
three projections: 1^3 2^(q-4) on F_q^*;
q-2 other directions: at least q-6 distinct intercepts;
every affine line: at most four points of H.          (SR23)
```

This near-surjective Rédei condition is much stronger than the almost-duplex
ledger alone.  It is the remaining structural gate: prove that a
`2q-5`-point torus set with `(SR23)` must fall into a low-degree carrier such
as the dead two-conic family, or construct a genuinely different carrier.

The parallel-class ledger of the full core is exact.  Keep the connector
`z=0` at infinity.  The two directions given by its triangle vertices each
contain one connector trisecant and `q-1` bisecants.  The three directions
given by `D intersect {z=0}` each contain one bisecant through the affine
triangle vertex and

```text
(N_1,N_2,N_4)=(q/3-1,1,2q/3).
```

Every remaining one of the `q-4` directions has

```text
(N_1,N_2,N_4)=(2q/3-1,1,q/3).                       (SR24)
```

Indeed, in any such direction the line through the affine triangle vertex is
the unique bisecant; all other lines have core degree one or four.  Summing
their degrees gives `2q+1` when the infinity point is outside `D`, and
`3q+1` when it belongs to `D`, forcing the displayed counts.  Together with
the third connector `z=0`, this direction ledger reconstructs all of
`(SR12)`.  It is also the strongest input form for a search: parallel classes
need not be rediscovered.

The ledger has a further characteristic-three consequence that is invisible
in the integer counts.  Put the affine triangle vertex at `(0,0)` and retain
the other two triangle vertices as the horizontal and vertical directions.
For the affine core

```text
B_aff=H union {the six affine boundary points},
```

the fiber multisets in the `q+1` directions are exactly

```text
2 vertex directions:       2^(q-1) 3^1;
3 infinity-boundary dirs:  0^(q/3-1) 1^1 3^(2q/3);
q-4 remaining directions:  1^(2q/3-1) 2^1 4^(q/3). (SR24a)
```

In each row the distinguished fiber is the line through `(0,0)`: it is the
unique triple fiber in a vertex direction, the unique singleton fiber in an
infinity-boundary direction, and the unique double fiber in every remaining
direction.  For every `1<=k<=q-2`, the sum of the `k`th powers of all elements
of `F_q` is zero.  Reducing the three profiles modulo the characteristic
therefore gives, for every nonzero homogeneous linear form `L`,

Before reducing modulo three, the same ledger gives a global stability object
that is much stronger than the four-direction collision count below.  Let
`ell_i` be the number of affine lines meeting `B_aff` in exactly `i` points.
Reading the three rows of `(SR24a)` gives

```text
ell_2=3q-6,       ell_3=2q+2,       ell_4=q(q-4)/3. (SR24a-global)
```

These numbers exhaust every unordered point-pair, since

```text
ell_2+3ell_3+6ell_4
 =3q-6+3(2q+2)+2q(q-4)
 =q(2q+1)=binom(2q+1,2).              (SR24a-global')
```

The line-degree residue has an exact six-line description in the dual plane.
Let `O^*` be the dual line parametrizing primal lines through the external
affine triangle vertex `(0,0)`.  For each projective direction `d`, let
`D_d^*` be the dual line parametrizing the pencil through the corresponding
point at infinity.  If `V_dir` is the two vertex directions and `R` the three
infinity-boundary directions, then the function on primal lines

```text
z(ell)=|ell intersect B_aff|-1 mod 3
```

satisfies exactly

```text
z=1_(O^*)+sum_(v in V_dir)1_(D_v^*)
          -sum_(m in R)1_(D_m^*).                  (SR24a-sixline)
```

Indeed, away from the five exceptional directions only the distinguished
line through `(0,0)` has residue one.  In a boundary direction the `0/3`
lines have residue `-1` and the singleton through `(0,0)` has residue zero.
In a vertex direction the nonzero-intercept bisecants have residue one and
the distinguished trisecant has residue `-1`.  At the dual point
representing the line at infinity, the five direction-line coefficients sum
to `2-3=-1`, which is its empty-line residue.  Thus

```text
z: (+1)^(3q-6) (-1)^(3q) 0^(q^2-5q+7),
wt(z)=6q-6.                                      (SR24a-sixline')
```

This is not an appeal to a small-codeword theorem: the six generators and
their signs are forced directly by `(SR24a)`.  It identifies the complete
zeroth ternary digit of the line ledger.  The Witt/Rédei tangent digit below
is exactly the next information needed to separate the degree-one and
degree-four lines that both disappear from `z`.

Keeping the displayed coefficients as the integers `+1,+1,+1,-1,-1,-1`,
let `s(ell)` be their actual signed sum at the dual point representing
`ell`.  The case-by-case proof of `(SR24a-sixline)` lifts without ambiguity:

```text
h(ell)=(|ell intersect B_aff|-1-s(ell))/3          (SR24a-highdigit)
```

is a `0/1` value.  It equals one exactly for

```text
all q(q-4)/3 four-secants, and
all 2q boundary-direction trisecants,
```

and is zero on the empty lines, tangents, bisecants, and the two vertex
trisecants.  Thus the global high-line set `K_lines={ell:h(ell)=1}` has

```text
|K_lines|=q(q+2)/3.                                (SR24a-highdigit')
```

It is exactly regular on the core.  An ordinary three-colour point lies on
three boundary trisecants and `2q/3-3` four-secants; a boundary-singleton
point lies on two and `2q/3-2`; a vertex-triple point lies on three and
`2q/3-3`.  Hence in every case

```text
#{ell in K_lines:P in ell}=2q/3,       P in B_aff. (SR24a-highregular)
```

This also fixes the entire external second-moment shell without a model.  If
`e(P)` is the number of high lines through an external projective point, the
projective-plane incidence identity `M M^T=qI+J` gives

```text
sum_(P outside B_aff)e(P)=q^2(q-1)/3,
sum_(P outside B_aff)e(P)^2=q^2(q^2-q+6)/9,
sum_(P outside B_aff)(e(P)-q/3)=0,
sum_(P outside B_aff)(e(P)-q/3)^2=2q^2/3.          (SR24a-highshell)
```

In fact the second-moment statement conceals a completely discrete spectrum.
Let `M` be the point-line incidence matrix, let `b` be the point indicator of
`B_aff`, and put

```text
a=1_O+sum_(v in V_dir)1_v-sum_(m in R)1_m.
```

Here the five direction symbols denote their points on the line at infinity,
so `sum a=0`.  The integer lift in `(SR24a-sixline)` is `s=M^T a`, while the
line-degree vector is `M^T b`.  Therefore `(SR24a-highdigit)`,
`M M^T=qI+J`, `M1=(q+1)1`, and `q=3r` give the exact integer identity

```text
M h = r(b+1-a).                                  (SR24a-highincidence)
```

Consequently, when the high lines are regarded as a point set `K` in the
dual plane, its complete line-intersection spectrum is

```text
|line intersect K|  number of lines
        0                 3
        r            q^2-q-6
       2r               2q+4.                    (SR24a-highspectrum)
```

The three zero-secants are the duals of `O` and the two vertex points at
infinity.  Those three primal points are noncollinear, so the zero-secants
form a triangle.  Thus `K` avoids a triangle and every other line meets it in
exactly `r` or `2r` points.  This proves `(SR24a-highshell)` pointwise rather
than merely in norm: the external high degree is zero at those three special
points, `2r` at the three boundary points at infinity, and `r` everywhere
else outside `B_aff`; it is `2r` on `B_aff`.

The size here is the small root of a known characteristic-divisible
few-intersection regime.  For any point set with exactly three zero-secants
and all other line intersections in `{r,2r}`, the first two incidence
moments give

```text
|K|(q^2-|K|)=2q^2(q-1)(q+2)/9,
```

so the only possible sizes are

```text
q(q+2)/3              and              2q(q-1)/3. (SR24a-two-roots)
```

Our `K` is the first.  The second is realized by Mason's three-zero-secant
construction in the generalized-KM literature; see Csajbók--Weiner,
[Generalizing Korchmáros--Mazzocca
arcs](https://arxiv.org/abs/2008.10347), Example 2.10.  Their general
classification explicitly leaves open the case in which both nonzero
intersection numbers are divisible by the characteristic.  Thus raw secant
values, the three zero lines, and ternary code membership cannot alone
exclude the C949 object: a successful argument must distinguish the small
root using the reciprocal local profiles or offset/conductor data.  The
Mason family is a concrete red-team neighbor, not a realization of this
small root.  Full text checked from cache key `arXiv:2008.10347`, SHA-256
`cc796106c9ee71fcd551b70e7b940a7f9e18e5f4b1ef151b58c648416826beb7`.

The relation is nevertheless constructive.  Let `S` be a Mason large-root
set and let `L_1,L_2,L_3` be its three zero-secants.  They are necessarily
nonconcurrent: if `z(X)` is the number through an external point and `a(X)`
the number of `r`-secants, pencil counting gives `a(X)=4-2z(X)`, excluding
`z=3`.  Choose `L_3` as the line at infinity and put

```text
K_0=PG(2,q) \ (S union L_3).
```

Then `|K_0|=q(q+2)/3`; `L_3` is a zero-secant, `L_1,L_2` are `q`-secants,
and every other line meets `K_0` in `r` or `2r` points.  Thus a Mason-seeded
C949 construction starts from the exact spectrum

```text
0^1, q^2, r^[q^2-q], (2r)^[2q-2].
```

Retaining the same zero triangle therefore requires a size-preserving global
trade which removes the
`2q-1` points of `K_0` on `L_1 union L_2` and inserts `2q-1` points so that
the two full secants become zero-secants without disturbing the two-level
ledger.  Even without retaining that triangle, reducing both `q`-secants to
the cap `2r` requires at least `2r-1=2q/3-1` removals.  This supplies a
concrete origin for the `Omega(q)` Radon-trade
frontier; success would construct the small root, while a uniform obstruction
would exclude this Mason-seeded route.  It does not show that every possible
small root arises by such a trade.

The dual comparison is equally sharp.  Let `D_M` be the `2q-2` dual points
corresponding to the `r`-secants of `S`.  Its line spectrum is

```text
0^3, 1^[2q(q-1)/3], 2^[3q-3], 3^0,
4^[(q-1)(q-3)/3].                               (SR24a-Mason-neighbor)
```

Relative to `D_M`, the desired `D` has six more points, but its spectrum
loses three zero-secants and `2q-1` tangents and gains three trisecants and
`2q-1` four-secants; the bisecant count is unchanged.  This is not a literal
six-point extension.  A new dual point avoiding a `5`-secant would correspond
to a primal line avoiding every external off-triangle point where four
`r`-secants concur.  A nonzero-side line contains at most `2r` points of `S`
and at most three triangle-boundary points, hence contains such an external
point when `q>6`.  Only the three zero sides are admissible.  Therefore any
Mason-to-C949 passage must remove and add simultaneously; the exact
`2q-1` incidence exchange, rather than net size six, is the true sharpness
mechanism.

There is also an all-signature complement comparison.  A near-sharp complete
arc of size

```text
q^2/3+5q/3+eta
```

has a minimal `r`-fold blocking complement `B` of size

```text
|B|=2r(q-1)+1-eta=|S|+1-eta,
```

where `S` denotes any Mason large-root set.  Put `P=B setminus S` and
`N=S setminus B`.  Since `S` avoids its three zero sides while `B` meets
each in at least `r` points, and only the three vertices can be counted on
two sides,

```text
|P|>=3r-3=q-3,
|N|=|P|+eta-1>=q+eta-4,
|B triangle S|>=2q+eta-7.                       (SR24a-Mason-distance)
```

Thus no bounded or local Mason perturbation can realize any of the concurrent
or triangular `(SR11)` branches.  This does not rule out the required global
`Theta(q)` trade.

Minimality gives a robust strengthening.  Write

```text
|P|=q-3+e,                  |N|=|P|+eta-1.
```

The `2q-2` Mason `r`-secants partition `S`.  If `x_T=|P intersect T|` and
`y_T=|N intersect T|` on such a block, blocking gives `x_T-y_T>=0`.  An
external point lies on `0,2,4` Mason `r`-secants according as it is a zero-
triangle vertex, an open-side point, or an off-triangle point.  Therefore the
total block deficit satisfies, if `v` and `f` count the vertex and
off-triangle additions,

```text
D=sum_T(x_T-y_T)=sum_(x in P) tau(x)-|N|
  =q-2+e+2f-2v-eta
 >=q+e-eta-8.                               (SR24a-Mason-deficit)
```

The zero sides give `f<=e+v-3`.  The Mason pencil formula
`tau(X)=4-2z(X)` shows that an `r`-secant avoids all three triangle vertices;
it therefore meets the zero sides in three distinct open-side points.

Let `U` be the deficient partition blocks `x_T-y_T>0`, let `u=|U|`, and let
`O` count their surviving Mason points.  Every block has
`x_T<=f+3`, while the total number of addition incidences on `U` is at most
`4f+3u`.  Hence

```text
u >= D/(f+3),
O=sum_(T in U)(r-y_T)
 >=u(r-3)+D-4f
 >=D(r-3)/(f+3)+D-4f.                         (SR24a-Mason-orphans)
```

None of these survivors has a tight Mason `r`-secant in `B`: those blocks
partition `S`, and its unique block is deficient.  It is not on a zero side.
Since `B` is minimal, every orphan must instead lie on a former Mason
`2r`-secant made tight by

```text
|N intersect H|-|P intersect H|=r.
```

If `E` is the set of these converted lines, pair counting on their at least
`r` deleted points first makes `|E|=O(1)`.  Since two distinct projective
lines share at most one deleted point, inclusion--exclusion then gives

```text
|E| binom(r,2)<=binom(|N|,2),
|N|>=r|E|-binom(|E|,2),             O<=r|E|.   (SR24a-Mason-converted)
```

This system has a sharp asymptotic consequence.  Suppose `eta=o(q)` and,
along a subsequence, `e/q -> c` and `f/q -> g`.  If `g=0`,
`(SR24a-Mason-orphans)` grows faster than the `O(q)` capacity in
`(SR24a-Mason-converted)`, a contradiction.  If `g>0`, those two displays give

```text
u >= ceil((1+c)/g+2),
u+3+3c-6g <= |E|+o(1).                        (SR24a-Mason-limit)
```

Since `g<=c`, the left side is at least
`ceil(1/c+3)+3-3c-o(1)`.  If `c<1`, the union bound in
`(SR24a-Mason-converted)` gives

```text
|N|/r -> 3(1+c)<6,             |E|<=5
```

for all sufficiently large `q`.  But the orphan lower bound is strictly
larger than `8-3c>5`, a contradiction.  Therefore

```text
eta=o(q)  implies
e >= q-o(q),
|B setminus S| >= 2q-o(q).                    (SR24a-Mason-essential-gap)
```

At the boundary the union bound permits at most six converted
`2r`-secants.  Classifying that bounded converted-line configuration together
with a `2q+o(q)` addition set is the next Mason-specific construction gate.

Thus even the smallest possible triangle fill is not the start of a
near-sharp construction: any Mason-based witness needs a further linear-size
global trade which creates new essential `r`-secants.  This is a stability
obstruction around Mason, not nonexistence of arbitrary near-sharp blocking
sets.

The first two line moments make the same boundary visible without choosing a
trade.  For `delta=1-eta`, write `|B|=2r(q-1)+delta` and
`c_ell=|B intersect ell|-r`.  Then

```text
sum_ell c_ell=(q+1)|B|-r(q^2+q+1),
sum_ell c_ell(r-c_ell)
 =-6r^2+r(4-q)delta-delta^2.                   (SR24a-Mason-excess)
```

At `eta=1` the right side is `-6r^2`.  Hence a hypothetical complement of
Mason's exact size cannot have only line sizes `r,2r`: its lines above `2r`
must contribute overload energy at least `6r^2`.  Since one line contributes
at most `(2r+1)(r+1)`, at least three overloaded lines are necessary for
large `q`.  This recovers the three-generator threshold from the complement
side, but does not classify the overloaded lines or prove the upper bound.

The minimal same-triangle trade is in fact impossible, and the obstruction
has a quantitative stability margin.  Write

```text
V=L_1 intersect L_2,   W=L_1 intersect L_3,   Z=L_2 intersect L_3,
A=K_0 intersect (L_1 union L_2).
```

Assume `q=3^h` with `h>=2`.  Thus `|A|=2q-1`.  Suppose a target small-root set `K`, with the same zero
triangle and line cap `2r`, is obtained by deleting `A` and a further set
`R`, `|R|=t`, and inserting a set `P`, `|P|=2q-1+t`.  Since all line sums
of `K` and `K_0` are divisible by `3`, the nonnegative weighted multiset

```text
C_t = 1_K-1_K0+1_L1+1_L2+1_L3+3 1_R
```

has the more transparent description

```text
C_t = 1_P+2 1_R+1_L3+1_V+1_W+1_Z,
|C_t|=3(q+1)+3t.                              (SR24a-Mason-trade)
```

Every line has positive weight divisible by `3`.  In the small-excess range
below, the support is not the whole plane; a pencil through a point outside
it has average line weight `3+3t/(q+1)<6`, so some line has weight exactly
`3`.  Hence `C_t` is a weighted `{3(q+1)+3t,3;2,q}` minihyper.  Lemma 3.3 of
De Beule--Metsch--Storme,
[Characterization results on weighted minihypers and on linear codes meeting
the Griesmer bound](https://doi.org/10.3934/amc.2008.2.261), applies whenever

```text
3+3t < sqrt(q)+1.
```

It decomposes `C_t` as three lines and `3t` points.  Since all `q+1` points
of `L_3` have positive weight and `q+1>3+3t`, one line summand must be
`L_3`.  After subtracting it, the support

```text
P union R union {V,W,Z}
```

has `2q+2+2t` distinct points and must be covered by two lines and `3t`
point summands.  The two lines cover at most `4r` points of `P`, at most all
`t` points of `R`, and the three vertices.  Consequently

```text
2q+2+2t <= 4r+t+3+3t,
so t >= r.
```

This contradicts `t<(sqrt(q)-2)/3`.  Therefore every such same-triangle
Mason-seeded trade satisfies

```text
t >= ceil((sqrt(q)-2)/3),
|K_0 setminus K|=|K setminus K_0|
  >= 2q-1+ceil((sqrt(q)-2)/3).                 (SR24a-Mason-trade-gap)
```

In particular the exact `2q-1` same-triangle trade is excluded.  The cited
lemma was checked from cache key
`10.3934/amc.2008.2.261`, SHA-256
`f17c3a1933f89c9c88f8b649e3d25abb4ab5e140c3452347e4f1cee8d346e298`.

The same minihyper argument also gives a weaker but triangle-independent
Mason-seeded obstruction.  Let `K` now be any set of the small-root size with
all line intersections in `{0,r,2r}`; its zero triangle need not equal the
Mason triangle.  Put

```text
N=K_0 setminus K,   P=K setminus K_0,   n=|N|=|P|,
R=N setminus (L_1 union L_2),   t=|R|.
```

The same shifted difference

```text
C=1_K-1_K0+1_L1+1_L2+1_L3+3 1_R
```

is nonnegative: the old sides cancel every negative point on them, while an
off-side negative point receives weight `-1+3=2`.  It again has total weight
`3(q+1)+3t`, positive line weights divisible by `3`, and, in the small-excess
range, minimum line weight `3`.  Lemma 3.3 again forces `L_3` as one of its
three line summands.  For the residual `D=C-1_L3`, a direct pointwise count
gives

```text
|supp D|=2q+1+2t+1_(V in N)-|P intersect {W,Z}|
          >=2q-1+2t.                            (SR24a-Mason-any-support)
```

Moreover `supp D` is contained in `K union R union {V,W,Z}`.  Since `D` is a
sum of two lines and `3t` points, the `2r` line cap on `K` gives

```text
2q-1+2t <= 4r+t+3+3t,
so t >= r-2.                                    (SR24a-Mason-any-count)
```

This is incompatible with `t<(sqrt(q)-2)/3` for `q=3^h>=9`.  Hence every
Mason-seeded conversion to any target small root satisfies

```text
t >= ceil((sqrt(q)-2)/3).
```

Each of the two old `q`-secants must lose at least `r` points in order to
reach the `2r` cap, so their union loses at least `2r-1` points.  Therefore

```text
|K_0 setminus K|=|K setminus K_0|
 >= 2q/3-1+ceil((sqrt(q)-2)/3).                 (SR24a-Mason-any-gap)
```

This removes the same-triangle hypothesis, but not the Mason-seeded one: it
is a stability theorem around the known large-root construction, not a
classification of all hypothetical small roots.

There is a useful reciprocal form.  For a point `X` of the dual plane, let
`z(X)` be the number of zero-secants through it, let `k(X)=1_K(X)`, and let
`A(X)` count the `2r`-secants through it.  Summing the intersections with `K`
over the pencil at `X` gives

```text
r(q+1-z(X)+A(X))=|K|+q k(X),
A(X)=1+z(X)+3k(X).                               (SR24a-highpencils)
```

Hence each point of `K` lies on four `2r`-secants; an external point off the
zero triangle lies on one; a nonvertex point of a triangle side lies on two;
and a triangle vertex lies on three.  The `2q+4` high secants therefore form
a line arrangement whose only multiple points have the exact spectrum

```text
t_2=3q-3,       t_3=3,       t_4=q(q+2)/3,       t_i=0 (i>=5),
                                                        (SR24a-higharrangement)
```

and

```text
t_2+3t_3+6t_4=binom(2q+4,2).
```

The intersection lattice has an unexpectedly sharp algebraic signature.  For
the central rank-three arrangement, put `d=2q+4`.  Its second characteristic
coefficient and combinatorial ordinary-point count are

```text
b_2=sum_P(m_P-1)=q^2+5q+3,
tau_comb=sum_P(m_P-1)^2=3q^2+9q+9.
```

Since a central arrangement has `chi(1)=0`, its characteristic polynomial is

```text
chi_F(T)=T^3-dT^2+b_2T-q(q+3)
        =(T-1)(T-q)(T-q-3).                       (SR24a-charpoly)
```

Moreover `tau_comb=(d-1)^2-q(q+3)`, the numerical free-arrangement identity
for candidate exponents `(1,q,q+3)`.  In characteristic three this must not be
silently identified with the scheme-theoretic Tjurina number: the triple
points are wild for Euler's relation.  Factorization alone would not prove
freeness.  Here, however, the arrangement covers every projective
`F_q`-point, so its central complement is empty and `chi_F(q)=0`.
[Yoshinaga's finite-field freeness theorem, Theorem 10(1)](https://arxiv.org/abs/math/0606005)
therefore applies directly (and is explicitly valid over `F_q`): the
arrangement is free with exponents

```text
(1,q,q+3).                                         (SR24a-free)
```

The degree-`q` basis element can be made completely explicit.  Every
arrangement line is `F_q`-rational, so the three-variable Frobenius derivation

```text
Theta_q=X^q partial_X+Y^q partial_Y+Z^q partial_Z
```

is logarithmic.  It is not a polynomial multiple of the Euler derivation.
The graded free-module decomposition in `(SR24a-free)` therefore lets us use
`Theta_q` itself as the degree-`q` basis element.  Saito's determinant
criterion supplies a homogeneous logarithmic derivation
`Eta=A partial_X+B partial_Y+C partial_Z` of degree `q+3` such that, after one
nonzero scalar normalization,

```text
F=det [ X    Y    Z
        X^q  Y^q  Z^q
        A    B    C ],       deg A=deg B=deg C=q+3. (SR24a-Saito)
```

The degrees add to `2q+4=deg F`, so there is no hidden factor.  Thus the
logarithmic structure is a theorem, not a characteristic-zero analogy, and
its only unknown global datum is one degree-`q+3` generator modulo the Euler
and Frobenius summands.  What `(SR24a-Saito)` does not yet supply is a quartic
through the *dual points* of the arrangement.  Extracting that adjoint from
`Eta`, the exponent gap three, and the zero-triangle normalization is now one
exact form of the carrier problem.

There is an important universality check on this formulation.  The vanishing
ideal of `PG(2,q)` is generated by the three Frobenius minors
`Phi_XY,Phi_XZ,Phi_YZ`.  Since the arrangement covers every rational point,
its product `F` lies in that ideal, and a degree count already writes it as a
linear combination of those minors with degree-`q+3` coefficients.  The
determinantal form `(SR24a-Saito)` is this universal representation, while
Yoshinaga's theorem makes every covering arrangement of `2q+4` rational
lines free with exponents `(1,q,q+3)`.  Hence neither freeness nor the
exponent gap three alone can force a quartic.  Any carrier extraction must
use the special multiplicity pattern and triangle boundary data, not just
the existence of `Eta`.

The candidate exponents are not numerology on a restriction.  Restrict the
arrangement to any one of its lines in the Ziegler sense.  There are `2r`
quadruple points, hence `2r` restricted points of multiplicity three; the
remaining restricted multiplicities are either `(1,1,1)` or `(2,1)`.  Their
total is always `2q+3=d-1`.  On binary coordinates `(x,y)` the Frobenius
derivation

```text
theta_q=x^q partial_x+y^q partial_y
```

is logarithmic for every `F_q`-rational restricted line, with any of these
multiplicities, and has degree `q`.  No nonzero logarithmic derivation can
have degree `e<q`: if `G` is the product of the `2r` multiplicity-three line
forms and `theta=a partial_x+b partial_y`, then each such form cubically
divides

```text
det(theta,theta_q)=a y^q-b x^q.
```

Thus `G^3` of degree `2q` divides a form of degree `e+q<2q`, forcing the
determinant to vanish.  Coprimality of `x^q,y^q` then makes `theta` a
polynomial multiple of `theta_q`, impossible in smaller degree.  Since the
two exponents of a rank-two multiarrangement sum to `2q+3`, every Ziegler
restriction therefore has exact exponents

```text
(q,q+3).                                           (SR24a-Ziegler)
```

This proof is internal and characteristic-three aware; it independently
confirms the nontrivial exponents supplied by `(SR24a-free)`.  The remaining
algebraic sublemma is no longer freeness or lifting: it is to show that the
degree-`q+3` generator `Eta` in `(SR24a-Saito)`, together with
`(SR24a-arrangement-order)`, has a degree-at-most-four Frobenius remainder
vanishing at the arrangement's `2q+4` dual points.  That implication is not a
general consequence of freeness and is not proved here.

Its double points fill the three open sides of the zero triangle, its three
triple points are the vertices, and its quadruple points are precisely `K`.
This is a field-uniform structural compression, not a sampled pattern: the
prescribed hypothetical extremizer forces a triangle-supported `(0,r,2r)`
set with this reciprocal fourfold line arrangement.  A sufficient closeout
theorem may therefore be stated solely for that arrangement.

Dualizing the `2r`-secants gives an equally useful point formulation.  The
resulting set is exactly

```text
D=B_aff union R,
```

where the three points of `R` are now restored on the line at infinity.  It
has `2q+4` points, meets every line, and has no line longer than four.  (It is
a one-fold blocking set, not a double blocking set: the off-triangle points
in `(SR24a-highpencils)` give tangents.)  Its complete secant spectrum is

```text
t_1=(2q^2-8q+3)/3,  t_2=3q-3,  t_3=3,
t_4=q(q+2)/3,       t_i=0 otherwise.              (SR24a-blocking4)
```

This recovers the earlier shell spectrum `(SR12)` from the global high-digit
incidence identity, rather than taking that spectrum as an endpoint input.
The three trisecants are nonconcurrent.  Nine points of `D` are dual to the
arrangement lines through a vertex of the zero triangle; the other `2q-5`
are not.  Restricting the arrangement to one of its own lines gives the exact
local profiles

```text
number of points     (d_1,d_2,d_3,d_4)
      2q-5              (r-2,3,0,2r)
         9              (r-1,1,1,2r).             (SR24a-blocking4-local)
```

Indeed every arrangement line contains `2r` quadruple points.  If it avoids
the triangle vertices, its remaining three intersections are the three open
side double points.  If it passes through a vertex, the remaining pair count
is one triple point and one open-side double point.  All unused points on the
line dualize to tangents.  In particular `D` is a *minimal* blocking
`(2q+4,4)`-arc for `q>=9`.  This is a substantially smaller inverse object
than the original four-chart polynomial data.

The cube-free part of every local joining-line product is also uniform.  Let
`V_X,V_Y,V_Z` be the three points of the dual plane corresponding to the
three zero-triangle sides; none belongs to `D`.  For `P=(a,b,c) in D`, put

```text
S^D_P=(bZ-cY)(cX-aZ)(aY-bX).
```

The three factors are the joins `PV_X,PV_Y,PV_Z`.  If the arrangement line
dual to `P` avoids the triangle vertices, these are exactly its three
open-side double points, hence the three bisecants of `D` through `P`.  If
that line passes through a triangle vertex, two factors coincide on the
corresponding trisecant and the third is the unique bisecant.  Consequently
the product `Delta^D_P` of all joining lines from `P` to `D\{P}` has the
exact form

```text
Delta^D_P=R_P^3 S^D_P,          deg R_P=2q/3.     (SR24a-blocking4-cube)
```

Here the individual joining-line factors may first leave a nonzero scalar;
it is absorbed uniquely into `R_P` because cubing is an automorphism of
`GF(3^h)^*`.  Indeed the pencil through each `V_i` partitions `D` into `q-1` bisecants
and two trisecants: `2(q-1)+2*3=2q+4`.  Thus the local cube-free residues
already glue to the fixed zero triangle; all remaining inverse information
is in the degree-`2q/3` cube roots `R_P`.  In particular a scalar Segre
product or its cube class cannot by itself force a quartic carrier.

There is a useful equivalent design compression.  Take the points of `D` as
vertices, its `4`-secants as four-element blocks, and join two vertices in a
leave graph `L` when their line is not a `4`-secant.  Every vertex belongs to
`2q/3` blocks and has leave degree three: the generic local residue is three
bisecants, while an exceptional one is one bisecant plus the other two points
of its unique trisecant.  If `N` is the vertex--block incidence matrix and
`A_L` the leave adjacency matrix, then over the integers

```text
N N^t=(2q/3-1)I+J-A_L.                         (SR24a-block-design)
```

Equivalently `R_P` is the product of the `4`-secants through `P`; a linear
factor occurs in exactly four of the `R_P`, and `gcd(R_P,R_Q)` is their join
exactly when `P,Q` lie in a common block.  This packages the unresolved
geometry as an embedded regular four-block design with cubic leave.  Its
immediate global products, however, are only the known incidence identities:
if `L_i` is the product of all `i`-secants, then
`prod_P R_P=L_4^4` and `prod_P S^D_P=L_2^2L_3^6`.  An offset-sensitive
Rédei, Hasse, or Witt condition is still needed.

The primal arrangement gives an exact place to look for that missing offset
condition.  Write `C={F=0}` and let `ell` be one of its components.  The
local spectrum is equivalent to

```text
(F/ell)|_ell=(XYZ)|_ell R_ell^3,       deg R_ell=2q/3,       (SR24a-root)
```

up to a nonzero component scalar.  The zero divisor of `R_ell` is precisely
the `2q/3` quadruple points on `ell`.  These component roots do *not*
automatically glue.  They glue after rescaling by constants `c_ell` exactly
when they define a section of `O_C(2q/3)`; since `2q/3<deg F` and
`H^1(P^2,O(n))=0`, this is equivalent to a unique plane form `R` of degree
`2q/3` containing `K`.

This equivalence turns the vague synchronization problem into a sparse
linear conductor test.  At a double point it matches one pair of values.  At
a triple point it imposes two value and one first-jet relation.  At
`P in K`, all four values are already zero, but three conditions remain.  If
the four tangent slopes are `s_i` and

```text
c_(ell_i)R_(ell_i)(t)=a_i t+b_i t^2+O(t^3),
```

then `(a_i)` must be the values of an affine-linear polynomial in `s_i` and
`(b_i)` the values of a quadratic polynomial in `s_i`: two plus one linear
conditions.  Thus scalar edge holonomy misses the main obstruction, which
lives in first and second conductor jets at the `q(q+2)/3` quadruple points.

If this gluing system has a nonzero solution, Bezout is saturated exactly:

```text
deg(F)deg(R)=(2q+4)(2q/3)=4|K|.
```

Hence `C meet R` is supported entirely at `K`, and because `C` covers the
rational plane one has `R(F_q)=K`.  This would be a strong high-degree
complete-intersection carrier.  It is highly nongeneric--the naive condition
count is
`binom(2q/3+2,2)-|K|=-q^2/9+q/3+1`--but neither the local cube identity nor
Bezout proves that it exists or forces it to have a bounded-degree factor.
The exact new mechanism is therefore the conductor-gluing matrix, not an
asserted descent to a quartic.

The arrangement also has an exact polynomial normal form.  Normalize its
zero triangle to `XYZ=0`, put

```text
Phi_XY=X^qY-XY^q
```

and define `Phi_XZ,Phi_YZ` cyclically.  If `F` is the product of the
`2q+4` arrangement-line equations, restriction to the triangle sides gives

```text
F(X,Y,0)=c_Z XY Phi_XY^2,
F(X,0,Z)=c_Y XZ Phi_XZ^2,
F(0,Y,Z)=c_X YZ Phi_YZ^2,                         (SR24a-arrangement-boundary)
```

with nonzero constants.  The powers are forced: every open-side point has
multiplicity two and each vertex multiplicity three.  Globally,

```text
ord_P(F)=1+z(P)+3 1_K(P),       P in PG(2,q),     (SR24a-arrangement-order)
```

where `z(P)` counts zero-triangle sides through `P`.  Subtracting the three
displayed boundary terms therefore yields

```text
F=c_Z XY Phi_XY^2+c_Y XZ Phi_XZ^2+c_X YZ Phi_YZ^2+XYZ E,
deg E=2q+1.                                         (SR24a-arrangement-form)
```

On the torus `Z=1`, `E` vanishes at every point of `(F_q^*)^2`; division by
the two grid polynomials gives

```text
E(x,y)=A(x,y)(x^(q-1)-1)+B(x,y)(y^(q-1)-1),
deg A,deg B <= q+2.                                (SR24a-arrangement-torus)
```

The order-four condition has an immediate scheme-level consequence that is
stronger than mere grid vanishing.  Put `U=x^(q-1)-1` and `V=y^(q-1)-1`.
At a torus point both vanish simply and `dU,dV` are independent.  The three
canonical boundary terms in `(SR24a-arrangement-form)` vanish to order at
least two there.  Hence at every quadruple point `P in K`, differentiating
`F` once gives

```text
0=dF(P)=xy dE(P)=xy(A(P)dU(P)+B(P)dV(P)),
A(P)=B(P)=0.                                      (SR24a-torus-base)
```

This statement is independent of the chosen grid-ideal decomposition.  The
only ambiguity in the displayed degree range is the Koszul change
`(A,B)->(A+HV,B-HU)` with `deg H<=3`, which does not alter `A(P),B(P)` on
the grid.  Thus the full fourfold locus `K` is contained in the common-zero
scheme of the two degree-at-most-`q+2` torus quotients.  Plain Bezout remains
too weak—`|K|~q^2/3` is below `(q+2)^2`—so this is not yet the quartic
carrier.  The remaining target must use global line-factor or offset
coherence; the next two pointwise jets alone have no further invariant.

The second jet itself has a compact closed form.  In the étale parameters
`U,V`, divide the torus equation by `xy`.  The quadratic contribution of the
three canonical boundary terms is

```text
Q_P=c_Z x^2y^2(U-V)^2+(c_Y x^2/y)U^2+(c_X y^2/x)V^2.
```

Since `F` has order four at `P in K`, the quadratic jet of `AU+BV` is
`-Q_P`.  In characteristic three its binary discriminant is

```text
disc(Q_P)
 =-xy(c_Zc_Y x^3+c_Zc_X y^3+c_Xc_Y).              (SR24a-torus-disc)
```

The nominal degree-six terms cancel exactly.  After the bijective Frobenius
change `(x,y)->(x^3,y^3)`, the parenthesized factor cuts out an affine line;
in particular its zero locus on the torus has only `O(q)` points.

This also closes a tempting but invalid Bezout shortcut.  Writing the linear
jets as `A_1=aU+bV`, `B_1=cU+dV`, the quadratic cancellation fixes `a,d,b+c`
but leaves `b-c` as the value of the Koszul gauge.  The Jacobian
`ad-bc` can therefore be nonzero, and when `(SR24a-torus-disc)` is a
nonsquare it is nonzero for every gauge choice.  Thus the common zeros in
`(SR24a-torus-base)` need not have enhanced intersection multiplicity.  A
successful third-jet argument must synchronize the Koszul values globally;
pointwise multiplicity counting cannot force a common component.

This local no-go is exact through order three.  If the cubic jet of the
canonical contribution is

```text
Q_3=pU^3+sU^2V+tUV^2+wV^3,
```

then all solutions to `Q_2+Q_3+AU+BV=0 mod (U,V)^4` have jets

```text
A_1=-alpha U+hV,       B_1=-(beta+h)U-gamma V,
A_2=-pU^2+lambda UV+mu V^2,
B_2=-(s+lambda)U^2-(t+mu)UV-wV^2,                 (SR24a-torus-jet3)
```

where `Q_2=alpha U^2+beta UV+gamma V^2`.  The three free scalars
`h,lambda,mu` are exactly the value and two first derivatives of the local
Koszul gauge in `(A,B)->(A+HV,B-HU)`.  Thus order four fixes seven of the ten
displayed jet coefficients and the other three are pure gauge.  A proof
cannot extract another pointwise equation from the second or third jets; it
must show that these local gauge jets arise from one globally constrained
object by using the arrangement factors, Hasse offset data, or an equivalent
global mechanism.

Equivalently, for regular parameters `U,V` the truncated Koszul map
`(A,B) -> UA+VB` is onto the required layers of the maximal ideal, with
kernel `(HV,-HU)`.  Thus no finite *pointwise* prolongation of the same jet
vanishing can create a gauge-invariant equation.  Only a global constraint on
the polynomial representatives can do so.

No computation enters these identities.  They expose the precise remaining
propagation problem: combine the order-four condition at every point of `K`
with `(SR24a-arrangement-form)--(SR24a-arrangement-torus)` to force `D` (or
`B_aff`) onto a curve of degree at most four.  Once that happens the
contradiction is immediate.  In fact the quartic exclusion is even cleaner
for `D`: an absolutely irreducible quartic has at most
`q+1+6sqrt(q)<2q+4` rational points for `q>=81`; a cubic plus a line has at
most `q+1+2sqrt(q)+4<2q+4`; two conics have at most `2q+2`; and the remaining
reducible patterns are smaller because every line contains at most four
points of `D`.  This also covers factors that are irreducible over `F_q` but
not absolutely irreducible.  If the quartic itself is `F_q`-irreducible and
geometrically reducible, its absolute components form one Galois orbit (two
conics or four lines); every rational point lies on all conjugates and hence
in the intersection of two distinct components, giving at most four rational
points.  Geometrically reducible `F_q`-irreducible factors inside an
`F_q`-reducible quartic only decrease the preceding component bounds.  Thus

```text
D lies on no plane curve of degree at most four, q>=81.
                                                        (SR24a-blocking4-gap)
```

Accordingly the minimal sufficient missing lemma along this carrier route is
now a single, field-uniform statement about a minimal blocking `4`-arc
(equivalently the displayed torus arrangement), rather than a compatibility
theorem involving four separately chosen Witt supports:

```text
Carrier lemma.  A set D with (SR24a-blocking4)--
(SR24a-blocking4-local) in PG(2,3^h), h>=4, is contained in a quartic.
                                                        (SR24a-carrier-lemma)
```

Proving this lemma contradicts `(SR24a-blocking4-gap)` and closes the
prescribed five-intersection inverse-construction branch.  It is not yet a
theorem here, and the reduction does not classify arbitrary target-size
extremizers; those scope limitations are essential.

The same object has core degree `2q/3`, external mean `q/3`, and constant
average external variance `2/3`.  This is the integral global counterpart of
the four special lifted spectra: in a boundary direction its selected
intercepts are the roots of `H_m`, while in an ordinary direction they are
the roots of the corresponding degree-`r` four-support polynomial.  In
particular `(SR24-WittK)` records four distinguished parallel-class slices
of the single high-line set `(SR24a-highdigit)`, not four unrelated supports.

Thus the intersections of size three and four form a pairwise-balanced
packing on `B_aff`; its leave graph consists exactly of the ordinary
bisecants.  That leave is not an arbitrary `O(q)`-edge graph.  Its edges are
the disjoint union of three matchings:

```text
two vertex-direction matchings: q-1 edges each, three missed vertices each;
the distinguished radial matching: q-4 edges, nine missed vertices.
                                                        (SR24a-leave)
```

The last assertion uses that `(0,0)` is the affine triangle vertex external
to `B_aff`: two distinct distinguished lines through it meet only there, so
their two-point intersections with `B_aff` are vertex-disjoint.  Consequently
the leave graph `Lambda` is properly three-edge-coloured, has maximum degree
three, and has the exact defect

```text
sum_(P in B_aff)(3-deg_Lambda(P))=3+3+9=15.        (SR24a-leave')
```

The overlap of the three missed sets is fixed, not arbitrary.  The two vertex
triple fibers contain six distinct points.  All six are missed both by their
corresponding vertex matching and by the radial matching.  The three boundary
singleton fibers supply the other three points missed by the radial matching.
The five distinguished lines are concurrent only at the external point
`(0,0)`, so these nine core points are distinct.  Hence the ordinary degrees
are exactly

```text
#{P:d_2(P)=3}=2q-8,   #{P:d_2(P)=2}=3,
#{P:d_2(P)=1}=6.                              (SR24a-leave'')
```

The first two colours alone have degree two except at the six vertex-triple
points, where they have degree one.  They therefore decompose the core into
alternating even cycles and exactly three alternating paths, with those six
points as endpoints.  The third matching is a perfect matching on the
remaining `2q-8` ordinary three-colour points and misses precisely the nine
exceptional positions.  This is the exact global form of the almost-duplex
constraint: a three-involution system with fifteen missing incidences
concentrated on nine known fiber positions, embedded so that every non-leave
pair is completed on a unique three- or four-secant.

There is also a constant-defect *local* regularity theorem.  For
`P in B_aff`, let `d_i(P)` be the number of affine lines through `P` that meet
`B_aff` in `i` points, and set `e(P)=3-d_2(P)`.  The three matching colours
give `e(P)>=0` and `(SR24a-leave')` gives `sum_P e(P)=15`.  Partitioning the
other `2q` points by the lines through `P` gives

```text
d_2(P)+2d_3(P)+3d_4(P)=2q.
```

Since `3 divides q`, this says that `d_3(P)+e(P)` is divisible by three.  In
each of the three infinity-boundary directions the line through `P` is either
a trisecant or the unique singleton.  If `s(P)` counts the latter events,
then `s(P)<=1`, `d_3(P)>=3-s(P)`, and `e(P)>=s(P)` because a singleton point is
missed by the radial matching.  Hence `k(P)=(d_3(P)+e(P))/3>=1`.  Moreover,
each of the six vertex-triple points lies on its vertex trisecant and on all
three boundary trisecants.  For those points `e(P)=2`, so `d_3(P)>=4` and
`k(P)>=2`.  Using `sum_P d_3(P)=3ell_3=6q+6` now yields the exact excess budget

```text
sum_(P in B_aff)(k(P)-1)
 =(6q+6+15)/3-(2q+1)=6.              (SR24a-local)
```

The six vertex-triple points already consume all six excess units.  Therefore
`k=2` on them and `k=1` everywhere else.  Substitution into the point-pair
identity and then into `d_1+d_2+d_3+d_4=q+1` determines every local profile:

```text
point type                 count    (d_1,d_2,d_3,d_4)
ordinary three-colour      2q-8     (q/3-2,3,3,2q/3-3)
boundary singleton        3        (q/3-1,2,2,2q/3-2)
vertex-triple              6        (q/3-1,1,4,2q/3-3). (SR24a-local')
```

Thus `2q-8` points are locally indistinguishable in the full secant ledger,
and the remaining nine split into two completely determined geometric types.
This is a field-uniform stability statement with an exact absolute exceptional
set.  It still does not classify the embedding: the next inverse step must
show that the three partial involutions and the unique `3/4`-secant completion
of almost every pair force the fixed spectral carrier.

The characteristic-three content of the full pair geometry has an exact
discriminant form.  For homogeneous direction coordinates `(S,T)`, put

```text
Delta_B(S,T)=product_({P,Q} subset B_aff)
 (S(u(P)-u(Q))+T(t(P)-t(Q))).
```

Let `V`, `P_R`, and `O` be the squarefree binary forms whose roots are the two
vertex directions, the three infinity-boundary directions, and the remaining
`q-4` directions.  Normalize them so that

```text
Phi(S,T)=S^qT-ST^q=V(S,T)P_R(S,T)O(S,T).
```

Each `i`-secant in a direction contributes `binom(i,2)` copies of its
direction factor to `Delta_B`.  The three rows of `(SR24a)` therefore give,
up to a nonzero scalar,

```text
Delta_B=V^(q+2) P_R^(2q) O^(2q+1).                (SR24a-disc)
```

Put `q=3r` and `Q=V^r P_R^(2r)O^(2r)`.  Because cubing is a bijection on
`F_q^*`, the harmless scalar can be absorbed into `Q`, and `(SR24a-disc)` is
equivalent to the exact polynomial identity

```text
Delta_B P_R=Q^3 V Phi,             deg Q=2q^2/3.  (SR24a-disc')
```

Thus the complete pair-difference form is a cube times the degree-`q`
cube-free skeleton `V^2O=V Phi/P_R`.  Combinatorially, the cube contains the
three copies contributed by every trisecant and the six copies contributed by
every four-secant; the skeleton is exactly the three-matching leave modulo
cubes.  Ordinary characteristic-three differentiation kills `Q^3` and sees
only this skeleton.  The binary form deliberately remembers only directions,
however, so its cube quotient is already fixed by the ledger and contains no
line-offset information.  It is a diagnostic for the first-digit failure, not
by itself an inverse theorem.

The offset-sensitive refinement is the full secant-line form.  For an affine
or projective line `ell`, use the same symbol for a normalized linear equation
of `ell`, and put

```text
L_i(X,Y,Z)=product_(ell: |ell intersect B_aff|=i) ell(X,Y,Z),
Lambda_B=product_({P,Q} subset B_aff) ell_(PQ)(X,Y,Z).
```

An `i`-secant occurs once for every pair of its `i` core points.  Hence in
characteristic three

```text
Lambda_B=L_2 L_3^3 L_4^6
        =L_2 R_B^3,
R_B=L_3L_4^2,
deg R_B=ell_3+2ell_4=(2q^2-2q+6)/3.       (SR24a-secant-form)
```

Unlike `(SR24a-disc')`, this identity retains every line intercept.  Its
cube-free part `L_2` is exactly the three coloured matchings.  Its cube root
`R_B` is the complete rich-line arrangement: boundary and vertex trisecants
occur once, while every four-secant occurs twice.  In particular

```text
grad Lambda_B=R_B^3 grad L_2.                     (SR24a-secant-form')
```

First derivatives therefore discard the entire rich-line arrangement.  For
any directional Hasse derivative `D_v^[j]`, the first nontrivial peeling is

```text
D_v^[3] Lambda_B
 =R_B^3 D_v^[3]L_2+L_2(D_v^[1]R_B)^3.             (SR24a-secant-Hasse)
```

There is also a pointwise cube-free compression of bounded degree.  For
`P in B_aff`, let

```text
Delta_P(X)=product_(Q in B_aff minus {P}) ell_(PQ)(X),
```

viewed as a binary form on the pencil through `P`.  A `j`-secant through
`P` occurs with exponent `j-1`.  Removing cubes therefore gives

```text
Delta_P=R_P^3 S_P,
S_P=product_(2-secants through P) ell
    *product_(3-secants through P) ell^2,
deg S_P=d_2(P)+2d_3(P) in {6,9}.                  (SR24a-local-cube)
```

The values follow from `(SR24a-local')`: the generic and vertex-triple types
give degree nine, while the three boundary-singleton points give degree six.
Moreover, multiplying over all core points makes every trisecant contribution
have exponent six and every bisecant contribution exponent two, so

```text
product_(P in B_aff) S_P = L_2^2 * (a cube),       (SR24a-local-cube')
```

up to a nonzero scalar.  Thus the entire rich-line geometry has a family of
bounded-degree local residues whose only global cube-free divisor is the
three-coloured matching leave.  This is the correct input shape for a
generalized Segre lemma of tangents.  It is not yet such a lemma: one must
still prove that the pairwise evaluation compatibilities of the `S_P` force
a common degree-at-most-four adjoint, rather than merely unrelated degree-nine
pencil forms.

The relevant classical identity already exists in a form that permits the
present oversized set.  In Ball--Csajbók's formulation of the generalized
Segre lemma of tangents, a set `S` has size `q+2-t`, with `t` allowed to be
negative, and the tangent polynomial `f_P` is corrected by the product `g_P`
of the higher secants through `P`, a `j`-secant occurring with multiplicity
`j-2`.  Here `|B_aff|=2q+1`, hence `t=1-q`, and the sign in their cyclic
three-point identity is `(-1)^(t+1)=-1`.  Therefore every triangle of the
bisecant leave carries an exact cyclic evaluation identity in which the
unbounded rich-line factors are precisely the `g_P` corrections.  The
bounded residues `(SR24a-local-cube)` are the characteristic-three reduction
of those corrections.

This does not yet close the inverse lemma.  The union of the three coloured
near-matchings need not contain a triangle, and on `GF(3^h)` every nonzero
scalar is a cube, so comparing scalar cube classes is vacuous.  What is still
needed is a normalized polynomial/Hasse version that propagates along paths
or cycles of the leave (or through an auxiliary reference point), rather than
an argument that presupposes a bisecant triangle.

In fact the scalar propagation can be carried out completely, and the result
is a no-go theorem for that route.  Let `U_P` be the product of all `q+1`
lines in the pencil through `P`, and write `f_P` and `g_P` for the tangent and
higher-secant products above.  Counting a `j`-secant through `P` with its
point-pair multiplicity gives the rational identity

```text
Delta_P=(U_P/f_P)g_P,       f_P/g_P=U_P/Delta_P.   (SR24a-Segre-pencil)
```

For a bisecant `PQ`, cancel its common linear factor on the right.  Fix a
volume form and coherent representatives of the core points.  The remaining
denominator at `Q` is, up to the one pencil scalar attached to `P`,

```text
product_(R != P,Q) det(P,R,Q).
```

Since `det(Q,R,P)=-det(P,R,Q)` and `|B_aff|-2=2q-1` is odd, the quotient for
the reversed edge has the opposite sign.  Rescaling once at each vertex
therefore gives, simultaneously on every bisecant edge,

```text
(f_P/g_P)(Q)=-(f_Q/g_Q)(P).                        (SR24a-Segre-edge)
```

This is exactly the `t=1-q` sign in the generalized Segre lemma, now without
a triangle or common-reference hypothesis.  The red-team conclusion is
decisive: cycle propagation yields only the expected product `(-1)^k` on a
`k`-cycle and no contradiction.  After substituting
`Delta_P=R_P^3S_P`, it says only that the corresponding pairwise residue is
a cube; that is vacuous because cubing is an automorphism of `GF(3^h)`.
Thus the scalar Segre identity cannot supply `(SR24a-carrier-lemma)`.
Any successful use of `(SR24a-local-cube)` must retain polynomial jets or
line-offset data before evaluation.

This is the precise characteristic-three mechanism behind the Witt strategy:
order one recovers only the leave, while order three is the first layer that
recovers derivatives of the offset-sensitive cube root.  The parallel-class
factors of `R_B` are exactly the triple-support polynomials `H_m` and the
four-support polynomials analogous to `G`; `(SR24-WittK)` packages the lifted
spectra of four distinguished such classes.  The remaining inverse lemma must
propagate those four offset slices, using `(SR24z')` coherence, to a
degree-at-most-four adjoint or carrier for the full arrangement.  Merely
factoring the direction-only quotient `Q` cannot do so.

The four-secants also rule out the naive cubic conclusion from real
few-ordinary-lines theory.  Let `C` be any nonzero plane curve of degree at
most three and put `s=|B_aff minus C|`.  A four-secant avoiding those `s`
points meets `C` in four distinct points and hence, by the line--curve degree
bound, is a component of `C`.  There are at most three such component lines.
By `(SR24a-local')`, the largest four-secant degree is `2q/3-2`, attained at
only the three boundary-singleton points; every other point has degree
`2q/3-3`.  If `s<=2`, then
`ell_4<=2(2q/3-2)+3`, already false for `q>=27`.  Thus `s>=3`, and the number
of four-secants meeting the exceptional set is at most

```text
3(2q/3-2)+(s-3)(2q/3-3)=s(2q/3-3)+3.
```

Consequently

```text
q(q-4)/3=ell_4 <=s(2q/3-3)+6.
```

For every ternary `q>=27`, this forces

```text
s >=ceil((q^2-4q-18)/(2q-9))=(q+1)/2. (SR24a-cubic-gap)
```

(The right fraction lies strictly between `(q-1)/2` and `(q+1)/2`.)  Hence a
degree-at-most-three curve contains at most `(3q+1)/2` core points.  The
global ledger therefore identifies degree four as the first possible
bounded-degree concentration threshold, in exact agreement with the shifted
quartics `Bhat_y` in `(SR24-grid-gcd)`.

At `q=27` the compressed object has 55 points, `(ell_2,ell_3,ell_4)` equal to
`(75,56,207)`, and leave-matchings of sizes `(26,26,23)`.  Its point types are
46 copies of `(7,3,3,15)`, three copies of `(8,2,2,16)`, and six copies of
`(8,1,4,15)`; every cubic misses at least 14 points.  These are consequences
of the direction ledger, not search observations.

The quartic threshold itself can be eliminated once a carrier has been
produced.  Suppose ternary `q>=81` and a degree-at-most-four plane curve `C`
contains `B_aff`.  The cubic gap makes `deg C=4` after passing to the reduced
support.  If `C` is absolutely irreducible, the Aubry--Perret Weil bound for
[singular curves](https://www.i2m.univ-amu.fr/perso/yves.aubry/ManuscriptaMathematica1995.pdf)
gives

```text
#C(F_q)<=q+1+6sqrt(q)<2q+1,
```

a contradiction.  If an `F_q`-irreducible component is not absolutely
irreducible, every rational point lies on two conjugate components, so Bezout
bounds its rational locus by four.  The remaining `F_q`-factorizations of a
quartic have degree patterns `1+3`, `1+1+2`, `1+1+1+1`, or `2+2`.  A line
component contains at most four core points; `(SR24a-cubic-gap)` and the
`q+1`-point bound for a nonsingular conic eliminate the first three patterns.
The only survivor is therefore

```text
C=C_1 union C_2
```

for two nonsingular `F_q`-conics.  Each has `q+1` rational points, so their
rational loci meet in at most one point and `B_aff` omits at most one point
from their union.  A singleton line of the full union must be tangent to one
of the conics, giving at most `2(q+1)` such lines.  Deleting one point creates
at most another `q+1` singleton lines.  Hence any such core would satisfy

```text
ell_1<=3q+3.
```

But `(SR24a)` gives

```text
ell_1=3+(q-4)(2q/3-1)>3q+3                 (q>=27).
```

This contradiction proves

```text
B_aff is on no plane curve of degree at most four, q>=81.
                                                        (SR24a-quartic-gap)
```

The proof uses the published Aubry--Perret bound only for the absolutely
irreducible quartic case; every reducible case is disposed of by the exact
secant ledger.  Consequently the precise closeout lemma is now one-way:
derive a degree-at-most-four carrier from `(SR24a-secant-Hasse)`, the coherent
shifted quartics `(SR24-grid-gcd)`, and `(SR24-WittK)`.  Once that carrier exists,
`(SR24a-quartic-gap)` supplies the contradiction.

This is the appropriate finite-field analogue of the *input* to the
[Green--Tao few-ordinary-lines theorem](https://arxiv.org/abs/1208.4714), but
that real-plane structure theorem may not be imported here.  The dominant
blocks have size four, and abstract unions of three near-perfect matchings
have no rigidity by themselves.  The remaining
field-uniform task is therefore precise: combine the geometrically embedded
leave `(SR24a-leave)` and its almost-complete `3/4`-block completion with the
fixed Witt spectra `(SR24-WittK)`, and prove that only an affine-linearized
three-involution model can occur.  That model is already excluded by
`(SR24r)`.

```text
sum_{P in B_aff} L(P)^k=0,             1<=k<=q-2.    (SR24b)
```

This is a structural identity, not a sampling test.  To extract its exact
content, write `L(x,y)=y-mx` and expand in `m`.  The resulting polynomial has
degree at most `k<q` and vanishes at every `m in F_q`, so each coefficient
vanishes.  Hence

```text
binom(i+j,i) sum_{P in B_aff} x(P)^i y(P)^j=0
                       whenever i,j>=0 and 1<=i+j<=q-2. (SR24c)
```

For `i,j>0` the six axis points contribute zero.  Lucas' theorem now yields
the torus moment obstruction

```text
sum_{(a,b) in H} a^i b^j=0                            (SR24d)
```

for every positive pair `(i,j)` with `i+j<=q-2` whose base-three addition is
carry-free.  If `q=3^h`, there are exactly

```text
6^h-3q+3
```

such ordered pairs: choose one of the six digit pairs with sum at most two at
each of the `h` positions, remove the two coordinate axes, and then remove
the `q-2` positive pairs whose sum is `q-1`.  Thus a candidate almost-duplex
must satisfy a superlinear family of exact mixed-moment cancellations in
addition to the fiber, matching, and line-cap constraints.  Coefficients with
a base-three carry are deliberately not claimed: their binomial coefficient
vanishes in the field.

The carry-free triangle can be resummed into a two-sheeted algebraic normal
form.  Put `r=q/3`.  For each `a in F_q^*`, include a formal second value
`b=0` when the `a`-fiber of `H` is a singleton, and apply the Frobenius
bijection `z=b^r` to its two values.  Define their sum and sum of squares by

```text
w(a)=sum z,                    v(a)=sum z^2.
```

Taking `j=r` in `(SR24d)` is legitimate for every consecutive
`1<=i<=2r-2`: the leading base-three digit of `r` is one and all its lower
digits are zero, so these additions are carry-free and have total at most
`q-2`.  Hence `sum_a w(a)a^i=0` on that interval.  If
`W(X)=sum_{d=0}^{q-2}c_dX^d` is the unique polynomial representing `w` on
`F_q^*`, multiplicative power-sum orthogonality gives

```text
sum_a w(a)a^i=-c_{q-1-i}.
```

It follows that `c_d=0` for `r+1<=d<=q-2`, and therefore

```text
deg W<=r.                                           (SR24e)
```

Likewise `j=2r` permits the consecutive interval `1<=i<=r-2`.  The
polynomial `V` representing `v` consequently has `deg V<=2r`.  In
characteristic three, if the two Frobenius values are `z_1,z_2`, then

```text
z_1 z_2=v-w^2.
```

Thus `P=V-W^2` has degree at most `2r`, and the zero-completed carrier is
exactly

```text
H union {(a,0):a in A_0}
  --under (a,b) |-> (a,z=b^r)-->
{(a,z):a!=0, z^2-W(a)z+P(a)=0},
deg W<=q/3,                deg P<=2q/3.              (SR24f)
```

The three singleton values `A_0` are precisely the nonzero roots of `P`.
Moreover `V+P=(z_1-z_2)^2` is nonzero at every `a in F_q^*`, since the two
completed fiber values are always distinct.  This is an exact inverse
normal form, not an existence assertion.  The Frobenius change is not a
projectivity: in these coordinates an original affine line becomes a cubic
relation `z^3=ma+c`, so the line-cap and blocking tests must still be imposed.

The argument is cyclic in the support triangle.  Choosing each connector in
turn as the line at infinity gives the same quadratic normal form in the
three torus charts

```text
(u,v)=(a,b),          (b/a,1/a),          (a/b,1/b). (SR24g)
```

In each chart, after adding zero to the three singleton `u`-fibers and
putting `z=v^(q/3)`, there are chart-dependent polynomials
`W_u,P_u` of degrees at most `q/3,2q/3` with
`z^2-W_u(u)z+P_u(u)=0`.  Thus the remaining object is not one arbitrary
almost-duplex: it must admit three compatible Frobenius-quadratic
descriptions related by the displayed birational coordinate changes.

This moment normal form excludes an entire completion branch.  Suppose a
full duplex `K` is the union of two monomial graphs

```text
b=alpha a^d,                    b=beta a^e,          (SR24h)
```

and `H=K\R` is obtained by deleting three cells.  The `a`-fiber profile
forces their coordinates `a_1,a_2,a_3` to be distinct.  For `r=q/3` and
every `1<=i<=2r-2`, `(SR24d)` gives

```text
sum_{t=1}^3 b_t^r a_t^i
 =sum_{(a,b) in K} a^i b^r
 =alpha^r sum_{a!=0} a^(i+dr)
  +beta^r sum_{a!=0} a^(i+er).                      (SR24i)
```

The right side is zero for all but at most two `i` in that interval, because
a nonzero-field power sum vanishes unless its exponent is divisible by
`q-1`.  Removing two indices from a consecutive interval of length `2r-2`
leaves a run of at least `ceil((2r-4)/3)>=3` consecutive zero values when
`q>=27`.  But three consecutive equations

```text
sum_t b_t^r a_t^(i_0+s)=0,             s=0,1,2,
```

have coefficient matrix `diag(a_t^i_0)` times the Vandermonde matrix of the
three distinct nonzero `a_t`.  It is invertible, contradicting
`b_t^r!=0`.  Therefore no two-monomial full duplex can be
completed into the target core for ternary `q>=27`.  This includes the
cyclic hyperbola duplex `(SR20)` as `d=-1`; `(SR21)` remains an independent
geometric exclusion.

The same proof gives a complexity lower bound for every extendable branch,
without assuming monomials.  For a full-duplex completion `K=H union R`, put

```text
mu_i(K)=sum_{(a,b) in K}a^i b^r,       1<=i<=2r-2.
```

The deletion identity says that `mu_i(K)=sum_t b_t^r a_t^i`.  Since the
right side cannot vanish at three consecutive indices, the support of
`i |-> mu_i(K)` must meet every length-three interval.  There is a sharper
characteristic-three consequence.  Write its recurrence polynomial as

```text
T^3-e_1T^2+e_2T-e_3=prod_t(T-a_t).
```

If five consecutive moments had only their middle term nonzero, the first
two recurrence steps would force `e_1=e_2=0`.  But then the polynomial would
be `T^3-e_3`, a cube over the perfect field `F_q`, contradicting the three
distinct `a_t`.  Thus the zero pattern `00100` is forbidden.  The longer
pattern `001010` is also impossible: after normalizing its nonzero middle
entry to `A`, the zero at the fourth position forces `e_1=0`, while the zero
at the sixth would read `0=e_3A`, contradicting `e_3!=0`.

These three forbidden patterns give a sharp elementary density count.  Split
the zeros in any finite moment interval into singleton and double runs;
`000` is forbidden.  There is at least one nonzero between consecutive zero
runs.  After every double run except possibly the last, there is one
additional nonzero: a single intervening nonzero before another double run
would give `00100`, while a single intervening nonzero, then a singleton zero
run, then another single nonzero would begin `001010`.  Hence the number of
zeros exceeds the number of nonzeros by at most two.  On the interval of
length `2r-2` this gives

```text
#{i in [1,2r-2]:mu_i(K)!=0} >= r-2=q/3-2.           (SR24j)
```

This improves the earlier no-three-zero bound `2q/9-O(1)` to the
half-density scale `q/3-O(1)` on the critical band.

The leading constant here is sharp for the recurrence information alone.
When the extension degree `h` is even, choose `omega in F_q` with
`omega^2=-1`.  The three distinct bases and nonzero weights

```text
(x_1,x_2,x_3)=(1,omega,-1),
(lambda_1,lambda_2,lambda_3)=(1+omega,1,1-omega)
```

give `mu_0=mu_1=0`, `mu_2=1`, `mu_3=omega`, and then repeat with period
four.  Since `2r-2` is divisible by four, the critical band has exactly
`r-1` nonzero terms.  Moreover the corresponding missing-cell coordinates
`b_t=lambda_t^3` and ratios `b_t/x_t` (hence also `x_t/b_t`) are three
distinct nonzero values.  Thus even the transversal distinctness conditions
do not improve the `q/3` leading spectral coefficient.  This is not a construction of
`H`: any stronger asymptotic exclusion must use the common-carrier or line
root gates, rather than the order-three recurrence by itself.

Equivalently, the interpolation polynomial for the completed fiber-sum
function must have at least that many nonzero coefficients in the high-degree
band `r+1,...,q-2`, with no run of three zeros.  By `(SR24g)` this linear
spectral-complexity requirement holds in all three triangle charts.  Hence a
successful extendable construction cannot come from a bounded-Fourier-support
duplex family; its nonlinearity must be `Omega(q)` in each chart.

This has a decomposition-independent permutation formulation.  The
two-regular `a`--`b` incidence graph of any full duplex splits into two
permutation graphs `b=f(a),g(a)`, but their trace

```text
tau(a)=f(a)+g(a)
```

is simply the sum of the two values in the `a`-fiber and hence does not
depend on the chosen splitting.  Its Frobenius fiber sum is
`w_K(a)=tau(a)^r`.  Since `gcd(r,q-1)=1`, raising the unique interpolation
polynomial on `F_q^*` to the `r`th power permutes its exponent frequencies
modulo `q-1` without collisions.  Therefore `(SR24j)` also forces

```text
Fourier-support(tau) >= r-2=q/3-2                    (SR24j')
```

in each of the three charts.  The obstruction is thus not an artifact of a
particular two-permutation decomposition: every successful full-duplex trace
must already have linear multiplicative-Fourier complexity.  The location of
those frequencies gives a sharper degree bound.  Since `3r=q=1 mod (q-1)`,
the inverse frequency map from `w_K=tau^r` back to `tau` is multiplication by
three modulo `q-1`.  In particular, the three consecutive moments with
indices `r,r+1,r+2` correspond to trace exponents

```text
q-2, q-5, q-8.
```

They cannot all vanish by the consecutive Vandermonde gate.  Hence the
unique interpolation polynomial obeys the near-maximal bound

```text
deg tau >= q-8.                                     (SR24j'')
```

Thus low-degree trace families are excluded even when their two permutation
graphs are individually complicated.

The Frobenius normal form also puts the original line test back into one
exact equation.  Since `z=b^r` and `3r=q`, cubing the carrier equation in
`(SR24f)` gives, pointwise on `F_q^*`, the following equivalent equation
(the Frobenius cube is injective):

```text
b^2-W(a)^3 b+P(a)^3=0.                              (SR24m)
```

Consequently a nonvertical affine line `b=ma+c` meets the zero-completed
carrier at precisely the nonzero roots of

```text
R_{m,c}(a)=(ma+c)^2-W(a)^3(ma+c)+P(a)^3.
```

More explicitly, its number of such roots is

```text
#(H intersection {b=ma+c})
  +#{a in A_0:ma+c=0}.
```

Thus `R_{m,c}` has at most five roots in `F_q^*` for every `(m,c)`, while
`R_{0,0}` has exactly the three roots `A_0`.  This is a functional root
condition, not a claim that the displayed formal polynomial has small
degree: `W^3` and `P^3` must be reduced as functions on `F_q^*`.  It is the
exact way the geometric four-secant cap survives the nonprojective
Frobenius change.

The possible fifth root is sparse and completely located.  Apart from the
zero line, it can occur only when `m!=0` and `-c/m in A_0`, because that is
exactly when the line contains one of the three adjoined zero cells.  There
are precisely `3(q-1)` such parameter pairs `(m,c)`; every other nonzero
`R_{m,c}` has at most four roots, and every vertical completed fiber has
exactly two points.  Thus any polynomial attack only needs to control a
linear-sized exceptional subfamily of the `q^2` nonvertical line tests.

There is also a canonical derivative compression of these section
polynomials.  Write

```text
W(X)=w_rX^r+A(X),
P(X)=C(X)+X^rB(X)+p_(2r)X^(2r),
deg A,deg B,deg C<=r-1,
s=w_r^3,                       rho=p_(2r)^3.
```

Using `X^q=X` and `X^(q+j)=X^(j+1)` on `F_q`, the original-coordinate
fiber trace and product in `(SR24m)` have the reduced representatives

```text
W(X)^3=sX+A(X)^3,
P(X)^3=C(X)^3+X B(X)^3+rho X^2.                    (SR24m')
```

For `t=mX+c`, differentiate the corresponding reduced section
`R_{m,c}=t^2-W^3t+P^3`.  Since the cube terms have zero derivative and
`m=(m^r)^3`, one obtains

```text
R'_(m,c)(X)
 =(B(X)-m^rA(X))^3+(-m^2+sm-rho)X-(m+s)c.          (SR24m'')
```

Thus only the at most two slopes satisfying `m^2-sm+rho=0` can make this
canonical section derivative a pure cube.  For every other slope its own
derivative is the nonzero constant `-m^2+sm-rho`; it is squarefree, and a
root of the reduced `R_{m,c}` cannot have multiplicity above two.  This is a
statement about the canonical reduced section polynomial, not a claim about
geometric tangency of the unreduced Frobenius curve: reduction modulo
`X^q-X` does not preserve derivatives.  The gain is that any multiplicity-
based polynomial attack has only two chart-global exceptional slopes.

The critical-point equation itself drops back to degree `r`.  If
`alpha=-m^2+sm-rho!=0`, taking the inverse Frobenius cube of `(SR24m'')`
on `F_q` gives

```text
B(X)-m^rA(X)+alpha^r X^r-((m+s)c)^r=0.             (SR24m''')
```

Its degree is exactly `r`, so the reduced section has at most `r=q/3`
critical field points.  At an exceptional slope `alpha=0`, the same operation
gives a polynomial of degree at most `r-1`, unless it vanishes identically;
that final escape is the explicit coefficient identity obtained from
`B-m^rA-((m+s)c)^r=0`.  Hence all anomalous multiplicity behavior is confined
to two slopes and an immediately testable low-degree identity.  This still
does not bound the number of distinct roots beyond the geometric cap in
`(SR24m)`; it sharpens the algebraic state rather than closing it.

Unless the all-intercept escape below occurs, there is at most one
identically-zero derivative section on each exceptional slope.  Indeed
`B-m^rA` must first be constant, and when `m+s!=0` the map
`c |-> ((m+s)c)^r` is bijective; when `m+s=0`, the derivative either never
vanishes identically or does so for every `c`.  Thus outside the balanced
shear branch, at most two of the `q^2` nonvertical section polynomials are
purely inseparable.

The worst escape, in which one exceptional slope has `R'_(m,c)=0` for
every intercept `c`, is completely rigid.  The coefficient of `c` forces
`m=-s`; the exceptional-slope equation and the cube term then force

```text
rho=s^2,                         B=-s^rA.
```

This has an intrinsic carrier interpretation.  Put `w=w_r`, so
`s=w^3`; injectivity of cubing turns the displayed conditions into
`p_(2r)=w^2` and `B=-wA`.  The Frobenius-coordinate shear

```text
y=z+wX^r
```

then transforms the carrier `z^2-Wz+P=0` exactly into

```text
y^2-A(X)y+C(X)=0.                                   (SR24m-shear)
```

Indeed the mixed and `X^(2r)` terms cancel in characteristic three.  On a
line of slope `m=-s`, its intercept is `c=b+sa`, and hence
`c^r=z+s^r a^r=z+w a^r=y`.  The exceptional derivative direction is
therefore precisely the direction in which the carrier admits this balanced
degree-`r-1` shear normal form.

The three zero completions become marked points in this form.  Original
`z=0` maps to `y=wX^r`, so

```text
{X in F_q^*: C(X)-wX^rA(X)+w^2X^(2r)=0}=A_0,       (SR24m-mark)
```

and the corresponding carrier points are exactly
`{(a,w a^r):a in A_0}`.  Thus the residual quadratic cover is not unmarked:
it contains precisely three prescribed points on the Frobenius monomial
graph `y=wX^r`.  These are also the zero-completion points responsible for
the sparse fifth-root allowances.

Direct substitution in `(SR24m)` gives the perfect-cube pencil

```text
R_(-s,c)(X)=(C(X)-c^rA(X)+c^(2r))^3.               (SR24m'''')
```

Thus even this fully inseparable direction is governed by a family of
degree-at-most-`r-1` polynomials, each with at most five nonzero roots by the
line cap.  The exceptional derivative branch has therefore become a
low-degree quadratic pencil in the parameter `c^r`, rather than an
unstructured high-degree section family.

Equivalently, put `y=c^r`; this is a bijective reparameterization of the
intercepts.  The fully inseparable branch is the quadratic cover

```text
y^2-A(X)y+C(X)=0,                  deg A,deg C<=r-1.
```

For every `X in F_q^*` its two roots are the two completed line intercepts,
so they are distinct field elements.  Therefore

```text
A(X)^2-C(X) is a nonzero square for every X in F_q^*.
```

Conversely, for every `y in F_q`, the level polynomial
`C(X)-yA(X)+y^2` has at most five nonzero roots by `(SR24m)`, with the
fifth-root exceptions already localized above.  This is the exact residual
fully inseparable gate: a degree-`r-1` square-value quadratic cover with a
uniform five-root Redei pencil.  Its degree grows linearly with `q`, so a
fixed-degree character-sum argument does not by itself close the branch.

This quantifies the present algebraic stopping boundary.  The two independent
carrier equations above have total degree at most `2r`, but their common
torus set has only `2q-5=6r-5` points, far below the `4r^2` Bezout threshold
that would force a common component.  In the fully inseparable branch the
square-value discriminant still has degree at most `2r-2`; an estimate on the
scale `degree*sqrt(q)` is larger than the entire field and cannot force it to
be a square polynomial.  Finally, a single degree-`r-1` level polynomial
having at most five roots is entirely compatible with its degree.  Therefore
none of component forcing, one-polynomial root counting, or an ordinary
square-value estimate closes the branch.  A successful next step must use
the five-root restriction simultaneously for all `q` members of the pencil,
or couple that pencil back to the other independent triangle carrier.

Even the uniform pencil conditions together with exactly three marked
intersections are consistent.  The `F_3`-linear map

```text
L(X)=X^r-X
```

has kernel `F_3` and image of size `q/3`.  Choose nonzero
`v in image(L)` and `u notin image(L)`.  Then the cover

```text
(y-X-u)(y-X-v)=0                                   (SR24q-example)
```

has coefficient degrees one and two, discriminant `(u-v)^2`, and two
distinct roots over every `X`.  Each `y`-level has at most two nonzero
`X`-roots because both factors are affine permutations.  On the marked graph
`y=X^r`, the first factor has no intersection, while the second has exactly
the three solutions of `L(X)=v`; all are nonzero because `v!=0`.  Removing
those three marked points even produces the required `1^3 2^(q-4)` profile
in the `X`-projection.  Thus the balanced pencil, square values, uniform
root cap, and exact singleton count still do not contradict one another.
The boundary blocking data or compatibility with the other carrier must
enter essentially; this affine duplex model marks the precise information
missing from a one-pencil proof.

Mapping the example back to the original coordinate makes its failure
quantitative.  Here `w=1`, so `b=(y-X^r)^3`.  If
`U=image(L)`, the two affine graphs give `b`-values in the disjoint additive
cosets `(u-U)^3` and `(v-U)^3`.  After deleting the three marked `b=0`
cells, the nonzero `b`-projection has exact profile

```text
2^2 3^(2q/3-3) on 2q/3-1 values,
with q/3 nonzero values missing.                    (SR24q-example-fail)
```

It is therefore linearly far from the required `1^3 2^(q-4)` second
projection.  The other carrier is not a cosmetic extra condition: it must
destroy precisely this additive-coset concentration while preserving the
three marked defects.

The same calculation excludes the much larger linearized-split balanced
family, not just the example.  Suppose

```text
y=F(X)+u,                     y=G(X)+v              (SR24r)
```

are the two roots of the balanced cover for every `X`, where `F,G` are
`F_3`-linearized polynomials.  On either graph the original coordinate is
the cube of an affine `F_3`-linear map, for example

```text
b^r=F(X)+u-wX^r.
```

The three marked deletions are exactly its nonzero zeros across the two
graphs.  One graph therefore contributes two or three.  A nonempty zero
fiber is a coset of the kernel of its linear part; it has `|ker|` nonzero
points, or `|ker|-1` when it contains `X=0`.  Since kernel sizes are powers
of three and the total marked count is three, this forces `|ker|=3`.
Every nonempty affine fiber then has size three.  After excluding `X=0` and
deleting the marked zero fiber,
at most one remaining fiber drops to size two; at least `r-2=q/3-2`
nonzero `b`-fibers are still triple.  This contradicts the target
`1^3 2^(q-4)` projection.  Constant linear parts give either zero or
`q-1` marks and do not evade the count.  Therefore no balanced carrier split
into two affine-linearized `y`-graphs can underlie the target core.  Any
surviving balanced cover is nonlinear in a stronger, nonadditive sense before
the second carrier is even imposed.

There is an exact coordinate-free way to retain that second projection inside
the sheared picture.  Put

```text
t=y-wX^r=b^r.
```

On the full balanced cover over `X in F_q^*`, the three marked cells are
exactly the `t=0` fiber.  After they are deleted, the target core has three
singleton and `q-4` doubleton nonzero `b`-fibers.  Frobenius is bijective, so
the complete `t`-fiber profile is forced to be

```text
t=0: 3;       three nonzero fibers: 1;
               the other q-4 nonzero fibers: 2.    (SR24s)
```

In particular every nonzero field value occurs, and if `E` is the set of the
three singleton `t`-values, then for `1<=k<=q-2`

```text
 sum_((X,y) on the cover) (y-wX^r)^k
      =-sum_(e in E) e^k.                           (SR24s')
```

Indeed the left side is twice the power sum over `F_q^*`, minus the three
singleton contributions, and the full nonzero power sum vanishes in this
range.  If the elementary symmetric functions of `E` are
`sigma_1,sigma_2,sigma_3`, the global moments `S_k` on the left therefore
satisfy

```text
S_(k+3)=sigma_1 S_(k+2)-sigma_2 S_(k+1)+sigma_3 S_k,
                                                   1<=k<=q-5. (SR24s'')
```

Equivalently, every consecutive `4 by 4` Hankel determinant of these moments
with start index `1<=k<=q-8` vanishes.  On the carrier side this is an explicit
polynomial condition.  With `h=wX^r`, the two shifted roots at `X` solve

```text
t^2-(A+h)t+(C-Ah+h^2)=0,
```

so their local power sums satisfy the quadratic Newton recurrence with trace
`A+h` and product `C-Ah+h^2`; summing those local expressions over
`F_q^*` gives `S_k`.  More explicitly, let `Q_0=2`, `Q_1=A+h`, and

```text
Q_k=(A+h)Q_(k-1)-(C-Ah+h^2)Q_(k-2).
```

Then `deg Q_k<=kr`, and the multiplicative-field power sum gives the exact
diagonal extraction formula

```text
S_k=-sum_(0<=j<=floor(kr/(q-1))) [X^(j(q-1))]Q_k(X).
                                                        (SR24s''')
```

Thus the residual balanced problem is not merely a square-value pencil: its
shifted-root multiset has a rank-three power-sum defect across the entire
nontrivial frequency range, now written directly in the coefficients `A,C`.
The prospective contradiction has been compressed to an explicit mismatch:
the diagonal-coefficient extraction of a local order-two Newton sequence must
itself obey the global order-three recurrence `(SR24s'')` for `q-5` steps.

The proof of `(SR24r)` is transparent from `(SR24s)`: a contributing
affine-linearized graph has a kernel of size three and hence leaves triple
`t`-fibers, forbidden by the exact cap two.  Any surviving balanced carrier
must satisfy the simultaneous five-root `y`-level cap and this almost-two-to-one
shifted projection, including the `q-8` Hankel window.  This packages both
projections sharply, but it still does not prove that no nonlinear cover has
both properties.

The geometry becomes cleaner if Frobenius is applied to both affine
coordinates, rather than only to the fiber coordinate.  Put

```text
u=a^r,                         t=b^r.
```

This is a semilinear collineation of the affine plane: an original line
`b=ma+c` becomes `t=m^r u+c^r`.  It preserves all incidences and sends the
three almost-duplex projections to `u,t,t/u`.  If
`U=A_0^r` and `E=B_0^r`, the zero-completed first carrier and the full affine
core become

```text
S=Frob(H) union (U times {0}),
B_aff^Frob=S union ({0} times E).                    (SR24t)
```

Thus `S` has two points above every `u!=0`, while its `t`-fibers have the
profile `(SR24s)`.  In the balanced branch the shear is now the ordinary
linear projection

```text
y=t+wu,
```

and the cover equation is

```text
y^2-A(u^3)y+C(u^3)=0.                               (SR24t')
```

The apparent high degree in `u` is purely Frobenius-lacunary.  More
importantly, `(SR24a)` applies directly to the `y`-direction.

The second almost-duplex projection decides which direction class this can
be.  Let `R` be the three singleton values of `t/u=(b/a)^r`.  Summing the
first powers of that projection over `S` and using
`W(X)=wX^r+A(X)` gives

```text
-sum_(rho in R)rho=sum_(X!=0)X^(-r)W(X)=-w.
```

For the second powers, the local root sum is `W^2+P`; in the balanced branch
its coefficient at `X^(2r)` is `-w^2`, and every lower term misses the
required multiplicative frequency.  Hence

```text
e_1(R)=w,                         e_2(R)=w^2.        (SR24u)
```

This has two immediate geometric consequences.  If `w=0`, the root
polynomial of the three distinct nonzero values in `R` would be
`T^3-e_3(R)`, a cube over the perfect field, impossible.  Thus `w!=0`.
Moreover substituting `T=-w` in

```text
T^3-wT^2+w^2T-e_3(R)
```

gives `-e_3(R)!=0`; hence `-w` is not one of the three infinity-boundary
directions `R`.  The balanced exceptional direction is therefore neither a
vertex direction nor an infinity-boundary direction.  It is forced to be one
of the `q-4` ordinary directions in `(SR24a)`.

This fixes its complete fiber ledger.  Write `g` for the number of values of
`E` lying on a four-point `B_aff^Frob` fiber in the `y`-direction.  Then
`0<=g<=3`, and the fibers of `S` under `y` are exactly

```text
y=0:                    2;
y in E:                 g values of size 3, 3-g values of size 0;
y in F_q^* minus E:     r-g values of size 4,
                        2r-4+g values of size 1.    (SR24v)
```

In particular the perfect-cube pencil `(SR24m'''')` never has five roots in
the balanced branch: its exact root counts are those in `(SR24v)`, and its
maximum is four.  Equivalently, with

```text
J(Y)=product_(e in E)(Y-e),          Q(Y)=Y^(q-1)-1,
```

there is a squarefree degree-`r` polynomial `G`, whose roots are precisely
the ordinary-direction four-fiber values, such that the norm of the balanced
cover is

```text
product_(X!=0)(Y^2-A(X)Y+C(X))
       =Y^2 Q(Y)G(Y)^3/J(Y).                         (SR24v')
```

Here `X=u^3`; the quotient is a polynomial because every root of `J` lies in
`F_q^*`, and roots of `G` may lie in `E`.  The unshifted `t`-norm is likewise

```text
product_(X!=0)(T^2-W(X)T+P(X))
       =T^3 Q(T)^2/J(T).                             (SR24v'')
```

Thus the nonlinear balanced survivor has been compressed to two explicit
split norm identities coupled by the fiberwise shear.  Its ratio singleton
set is also canonical after scaling: `R/w` is a three-element fiber of
`Z(Z+1)^2`, since its root polynomial is
`Z^3-Z^2+Z-e_3(R)/w^3`.  These identities sharply delimit the survivor, but
they do not yet prove that the two norm factorizations are incompatible for
arbitrary degree-`r-1` coefficients `A,C`.

The normalized singleton choice is counted exactly.  For
`f(Z)=Z(Z+1)^2`, division by `x-y` gives

```text
(f(x)-f(y))/(x-y)
 =x^2+xy+y^2-x-y+1.
```

Writing `d=x-y!=0`, the last equation has the unique solution
`y=-d^2+d-1`.  Hence there are `q-1` ordered collisions with distinct
arguments.  The critical value zero has the two distinct preimages `0,-1`
and contributes two; every nonzero three-fiber contributes six.  Therefore

```text
# normalized admissible fibers R/w=(q-3)/6,
# unnormalized admissible ratio singleton sets
                         =(q-1)(q-3)/6.              (SR24u')
```

At `q=27` these numbers are four and 104.  This is a classification of the
ratio singleton data, not of the carrier realizing them.

The factor `w` is not a projective modulus.  Since `w!=0`, the diagonal
linear change

```text
u'=u,              t'=t/w,              y'=y/w=t'+u'
```

preserves the three coordinate projections and replaces

```text
E by E/w,          R by R/w,          A by A/w,
C by C/w^2,        w by 1.                              (SR24u'')
```

Thus a classification search may normalize `w=1`; the 104 unscaled
`q=27` ratio sets collapse to the four fibers counted above.  Retaining `w`
in invariant formulas is only bookkeeping for undoing this normalization.
Frobenius sends the fiber over `kappa` to that over `kappa^3`.  In the audit's
fixed `F_27` encoding, the four values split as

```text
{2},                         {18,23,26}.             (SR24u''-q27)
```

Consequently only two semilinear ratio cases require exact search at
`q=27`; the three members of the second orbit are equivalent.

This makes the extendable singleton test especially small.  After the same
normalization, write `kappa=e_3(R)`, so `R` is a three-fiber of
`Z(Z+1)^2-kappa`.  A bijection `pi:U -> E` completes the duplex precisely
when its three cells are absent from `H` and, after the automatic product
identity, it satisfies

```text
sum_(u in U) pi(u)/u=1,
sum_(u in U) u/pi(u)=1/kappa.                       (SR24u''')
```

These are `(SR19d)` with `e_1(R)=e_2(R)=1`.  Hence at `q=27` the extendable
branch has four normalized ratio fibers and six scalar tests per pair
`(U,E)`, rather than a free second carrier or a free shear parameter.

There is one residual homothety after `w=1`: scaling `u,t,y` simultaneously
by `lambda` leaves `R` and the shear unchanged while scaling both `U,E` by
`lambda`.  Cubing is bijective on `F_q`, so there is a unique choice with

```text
e_3(U)=1,                         e_3(E)=kappa.      (SR24u'''')
```

The extendable singleton data now have a field-uniform parameterization and
count.  Fix an ordering `(r_1,r_2,r_3)` of a normalized ratio fiber `R`.
Choose an ordered triple of distinct nonzero rows with
`u_1u_2u_3=1`, and put `e_i=r_i u_i`.  This gives every transversal mapping
exactly once, provided the `e_i` are distinct.  There are
`(q-2)(q-3)` ordered row triples.  For each of the three possible equalities
`e_i=e_j`, there are `q-3` otherwise-distinct row triples; any intersection
of two such collision events forces all three `e_i` equal and has one
solution because cubing is bijective.  Inclusion-exclusion therefore gives

```text
# normalized transversal mappings for fixed R
  =(q-2)(q-3)-(3q-11)=q^2-8q+17.                  (SR24u''''')
```

Across all normalized `R`, the count is
`(q-3)(q^2-8q+17)/6`; at `q=27` it is `4*530=2120`.
This counts mappings, not distinct pairs `(U,E)`, since exceptional pairs may
support two mappings.

The requirement that a completion cell is not already in `H` also becomes
pointwise.  On the marked row `u_i`, with `X_i=u_i^3`, the existing nonzero
`t`-value is `W(X_i)=u_i+A(X_i)`.  Hence the proposed cell
`e_i=r_i u_i` is absent exactly when

```text
A(u_i^3)!=(r_i-1)u_i,                  i=1,2,3.     (SR24u'''''')
```

Thus even the cell-avoidance part of extendability is a three-evaluation
gate on the first carrier.

These reductions give two exact `q=27` decision models, now implemented as
separate audit commands.  The incidence layer uses one binary variable for
each possible cover cell `(u,y)`, hence only

```text
26*27=702                                             (SR24-search27)
```

cell variables.  It imposes two cells per nonzero row, the normalized
`t` and `t/u` ledgers, and every full-core affine parallel-class profile:
the three slopes in `R` have the exact `0/1/3` row of `(SR24a)`, while every
other nonzero slope has the exact `1/2/4` row.  The extendable option adds
only `26*3=78` matching variables, enforcing `(SR24u''')`, all three missing
cells, and the cell-avoidance inequalities `(SR24u'''''')`.

The carrier layer lifts each row to one of `binom(27,2)=351` unordered root
pairs.  For its rowwise trace and product vectors, degree at most eight is
equivalent to the 17 vanishing multiplicative moments with exponents
`1,...,17`; resolving `F_27` over `F_3` gives exactly

```text
2*17*3=102
```

ternary Reed--Solomon parity equations.  This yields 9,126 pair variables
before fixed-transversal pruning, or 7,550 after it.  The commands
`q27-balanced-incidence-cpsat` and `q27-balanced-carrier-cpsat` keep these two
logical layers separate.  A solver timeout has status `UNKNOWN` and is not
an exclusion certificate; only a returned witness or proved infeasibility
may be used mathematically.

The carrier command encodes each ternary parity as an exact bounded integer
identity `weighted_sum=3*quotient`.  This is logically identical to reduction
modulo three, but avoids CP-SAT's rejection of a single enormous modulo
expression over thousands of row-pair literals.  A final all-direction,
unfixed-carrier smoke test returns the legitimate status `UNKNOWN`, rather
than `MODEL_INVALID`; model validity is part of the reproducibility gate.

They also identify exactly why the moment/Hankel route stops.  Multiplicity
three is zero in the coefficient field, so the factor `G^3` contributes
nothing to any power sum.  If the two displayed norms are called `D_y,D_t`,
their split multiplicities give

```text
gcd(D_y,D_y')=Y G(Y)^3,
gcd(D_t,D_t')=T^3 Q(T)/J(T),                         (SR24v''')
Y Q(Y)D_y(Y)=G(Y)^3D_t(Y).
```

Thus `G` is precisely the information discarded by all of `(SR24s')`--
`(SR24s''')`; it can be recovered as the cube root of
`gcd(D_y,D_y')/Y`, but not from the moment sequence.  Extending the same
Hankel calculation cannot close the branch.  A proof must instead constrain
this degree-`r` four-fiber polynomial through the second carrier, the
three-cell transversal, or the integer line geometry.

The global ledger gives an offset-sensitive two-digit formulation of that
task.  For finite slope `M`, define the Rédei product

```text
mathcal R(C,M)=product_(P in B_aff)
 (C-(t(P)-M u(P))).
```

Reduce it to its unique representative `bar R` of bidegree less than `q`
modulo `(C^q-C,M^q-M)`.  Let

```text
B_R(M)=product_(m in R)(M-m),
P_good(M)=(M^q-M)/B_R(M).
```

For each of the `q-3` finite nonboundary slopes, every intercept occurs in
`B_aff`, so the corresponding column of `bar R` is identically zero.  Each
coefficient in `C` therefore has those `q-3` roots as a reduced polynomial in
`M`, and hence

```text
bar R(C,M)=P_good(M) T(C,M),
deg_C T<q,                  deg_M T<=2.             (SR24-Redei)
```

This is an exact function-ring factorization, not a degree heuristic.  At a
boundary root `m`, the singleton has intercept zero and the `2r` selected
triple fibers have support polynomial `H_m`, so

```text
T(C,m)=P_good(m)^(-1)
        rem_(C^q-C)(C H_m(C)^3).                   (SR24-Redei')
```

Thus the ordinary residue-field product sees only a rank-three boundary-hole
defect; its quadratic quotient is fixed by the three boundary columns.

The next Witt digit sees a different stratum.  For a finite good slope `m`
and `c in F_q`, evaluate the Teichmüller product

```text
widetilde R_m(c)=product_(P in B_aff)
 ([c]-[t(P)]+[m][u(P)]) in W_2(F_q).
```

Every such line is occupied, so this product is divisible by three.  Put
`rho_m(c)=(widetilde R_m(c)/3) mod 3`.  If the line contains at least two core
points, two factors are divisible by three and `rho_m(c)=0`.  If it is a
singleton with unique point `P=(u,t)` and `c=t-mu`, `(SR24-Witt''')` gives

```text
[t]-[m][u]-[c]=3[gamma_m(P)],
gamma_m(P)=(m u t c)^r.
```

Let `d_m` be the distinguished double intercept and `G_m` the monic support
polynomial of the `r` four-fiber intercepts in an ordinary direction.  Since

```text
mathcal R(C,m)=(C^q-C)(C-d_m)G_m(C)^3,
```

differentiation at a singleton root gives the exact tangent digit

```text
rho_m(c)=gamma_m(P)(c-d_m)G_m(c)^3.                (SR24-Redei-Witt)
```

The finite vertex direction has no singleton lines and hence zero first
digit.  Therefore the two digits have disjoint geometric jobs: `(SR24-Redei)`
records the three columns of empty lines, while `(SR24-Redei-Witt)` records
the tangent lines in every good direction and evaluates the otherwise hidden
four-fiber polynomial on them.  A field-uniform closeout can now be stated
without an analogy: prove that the slope dependence of these tangent digits,
together with the four fixed spectra in `(SR24-WittK)` and coherence
`(SR24z')`, forces a degree-at-most-four carrier.  The present work determines
both digits pointwise but does not yet prove that propagation theorem.

There is, however, an exact way to recover the information one
characteristic-three digit higher.  Let `[x]` denote the Teichmüller lift of
`x in F_q` to the length-two unramified Witt ring `W_2(F_q)`.  The nonzero
lifts are all `(q-1)`st roots of unity, so

```text
sum_(x in F_q^*)[x]^k=0,                    1<=k<=q-2.
```

For an ordinary affine direction `L`, let `G_L` be its `r` full-core
four-fiber values.  Its exact `1/2/4` ledger therefore gives, in `W_2(F_q)`,

```text
sum_(P in B_aff)[L(P)]^k
 =3 sum_(g in G_L)[g]^k.                            (SR24-Witt)
```

The vertex directions give zero, while an infinity-boundary direction gives
three times the power sum over its `2r` triple-fiber values.  Hence the
second ternary digit

```text
delta_k(L)=((1/3)sum_(P in B_aff)[L(P)]^k) mod 3
          =sum_(g in G_L)g^k                        (SR24-Witt')
```

recovers exactly what the ordinary characteristic-three moments discard.
For `h>=2`, `r=0` in the residue field, and multiplicative Fourier inversion
even recovers the set itself:

```text
1_(G_L)(a)=-sum_(k=1)^(q-2) delta_k(L)a^(-k),
                                                   a in F_q^*. (SR24-Witt'')
```

This lift remains algebraically coupled as the slope varies.  The first Witt
carry is explicit:

```text
[a]+[b]=[a+b]+3[(-(a^2b+ab^2))^r]           in W_2(F_q).
```

For `L=t-mu`, this becomes

```text
[L]=[t]-[m][u]-3[(mutL)^r].                         (SR24-Witt''')
```

Expanding its `k`th power modulo `3^2` expresses `delta_k(t-mu)` through
lifted mixed carrier moments plus the explicit correction
`-k(mutL)^rL^(k-1)`.  Thus a field-uniform closeout need not guess `G` or
repeat the blind Hankel argument: it can attack the slope-polynomial
compatibility of these second-digit Fourier spectra.  Establishing the
needed compatibility contradiction remains open, but `(SR24-Witt)` is the
first exact mechanism here that sees the whole four-fiber polynomial.

For the first lifted moment, the slope dependence collapses completely.
Write `L_(a,b)=at+bu` and put

```text
alpha=sum_(P in B_aff)t(P)^(2r)u(P)^r,
beta =sum_(P in B_aff)t(P)^r u(P)^(2r).
```

The two vertex ledgers give `sum[B_aff][t]=sum[B_aff][u]=0` already in the
Witt ring.  Applying the carry formula once therefore yields

```text
delta_1(L_(a,b))
 =alpha a^(2r)b^r+beta a^r b^(2r).                 (SR24-Witt1)
```

For the finite-slope form `L=t-mu`,

```text
delta_1(t-mu)=-alpha m^r+beta m^(2r).
```

Unless `alpha=beta=0`, this vanishes at at most one nonzero slope, since
Frobenius is bijective.  Thus the sum of the high-multiplicity intercept
values is globally controlled by a two-scalar semilinear form across all
directions, rather than by `q-1` unrelated sets.

In the normalized balanced branch, the exceptional ordinary slope is
`m=-1`, so its four-fiber set satisfies

```text
sum_(g in G_(-1))g=alpha+beta.
```

For the three boundary slopes `R`, `(SR24u)` gives
`sum_R m^r=1` and `sum_R m^(2r)=-1`.  If `T_m` denotes the `2r`
triple-fiber intercept values in boundary slope `m`, summing
`(SR24-Witt1)` over `R` therefore gives the exact cross-ledger identity

```text
sum_(g in G_(-1))g
 +sum_(m in R)sum_(c in T_m)c=0.                   (SR24-Witt1')
```

This is the first direct equation coupling the balanced four-fiber set to all
three boundary triple-fiber sets.  Higher Witt moments should similarly
couple their higher Fourier data, but their mixed carry terms have not yet
been compressed to a contradiction.

The three boundary supports have a common forced part.  For `m in R` and
`e in E`, the axis point `(0,e)` lies on the line `t-mu=e`.  A nonzero
boundary fiber has full-core size zero or three, so this line must contain
exactly two further points of `S`.  Therefore

```text
E subset T_m                         for every m in R, (SR24-Witt1'')
```

and the nine lines `t=mu+e`, `(m,e) in R times E`, are exact bisecants of
`S` (trisecants after the axis point is restored).  Since the common `E`
contribution occurs three times and hence vanishes in characteristic three,
`(SR24-Witt1')` sharpens to

```text
sum_(g in G_(-1))g
 +sum_(m in R)sum_(c in T_m minus E)c=0.            (SR24-Witt1''')
```

This isolates a `3 by 3` boundary-line grid and removes the already-known
axis contribution from the new Witt obstruction.

The same integer ledger gives a stronger incidence compression before any
further lifting.  Let

```text
Z={P in B_aff^Frob:t(P)+u(P) in G_(-1)},
N=B_aff^Frob minus Z.
```

Then `|Z|=4r` and `|N|=2r+1`.  For each `m in R`, let `p_m` be the unique
point on the zero-intercept singleton line `t=mu`.  The complete boundary
row of `(SR24a)` says exactly

```text
B_aff^Frob minus {p_m}
 = disjoint_union_(c in T_m)(B_aff^Frob intersect {t-mu=c}),
|B_aff^Frob intersect {t-mu=c}|=3.                 (SR24-grid)
```

Thus every point except `p_m` is on a selected boundary triple in direction
`m`.  In particular, at most one point of `Z` fails the selected-triple test
in each boundary direction, and hence

```text
#{P in Z: t(P)-m u(P) in T_m for every m in R}
 >=4r-3.                                           (SR24-grid')
```

Equivalently, adjoining the zero symbol to each `T_m` turns `Z` into a
linear four-partite incidence system with parts

```text
G_(-1),  T_(m_1) union {0}, T_(m_2) union {0},
          T_(m_3) union {0}.
```

Its `4r` edges are the points of `Z`; every `G_(-1)` vertex has degree four,
every nonzero boundary vertex has degree at most three, and the zero vertex
in boundary part `m` has degree at most one.  Any two boundary coordinates
determine their affine point, so the hypergraph is linear.  This is the
integral counterpart of the Witt coupling: the four special spectra do not
come from unrelated line sets, but from a near-regular common incidence
system with only three possible zero-coordinate defects.  At `q=27`, it has
36 edges, nine degree-four `G` vertices, and at least 33 edges avoiding all
three zero defects.

This last statement is strong saturation, but it is **not yet a stability
theorem**.  The exact boundary energy ledger identifies the missing estimate.
Fix `m in R`, let `b_j(m)` count the values `c in T_m` for which exactly `j`
of the three points on `t-mu=c` lie in `Z`, and put
`epsilon_m=1_(p_m in Z)`.  Then

```text
sum_(j=0)^3 b_j=2r,
sum_(j=0)^3 j b_j=4r-epsilon_m,
b_3=2b_0+b_1-epsilon_m.                            (SR24-grid-energy)
```

The number of unordered pairs of `Z`-points identified by this boundary
projection is therefore exactly

```text
E_m(Z)=sum_j binom(j,2)b_j
      =2r+3b_0+b_1-2epsilon_m.                     (SR24-grid-energy')
```

Its minimum is `2r-epsilon_m`, but the saturation bound gives no upper
control on the excess.  Indeed, when `epsilon_m=0`, every integer
`0<=s<=floor(2r/3)` is compatible with

```text
(b_0,b_1,b_2,b_3)=(s,0,2r-3s,2s).                 (SR24-grid-energy'')
```

Thus a linear number of empty boundary vertices and degree-three vertices is
arithmetically consistent with all present counts.  Across the four special
directions, the forced equal-projection pair count remains only `Theta(q)`:
the `G` part contributes exactly `6r`, and each boundary part contributes
the quantity in `(SR24-grid-energy')`.  This is the random-scale collision
regime, not the amplified additive-energy regime from which a
Balog--Szemeredi--Gowers/Freiman inverse conclusion could be drawn.

Consequently `(SR24-grid')` alone cannot justify “the carrier is close to a
linearized model.”  A valid stability proof first needs an independent bound
on

```text
Xi=sum_(m in R)(3b_0(m)+b_1(m)-epsilon_m),         (SR24-grid-defect)
```

or a stronger affine-cycle statistic.  The only available sources capable of
supplying it are the fixed spectral factorization `(SR24-WittK)`, the
reciprocal norm, or off-core maximality.  This rules out a tempting but
unsupported inverse-theorem shortcut and names the exact defect statistic
that the next argument must control.

The factorized high fibers do, however, encode this energy exactly.  For a
root `y of G`, augment the divisor in `(SR24z)` to

```text
Bhat_y(X)=X B_y(X) if y in E, and B_y(X) otherwise.
```

Every `Bhat_y` is a monic squarefree quartic, and its roots are precisely the
values `X=u^3` of the four points of `B_aff^Frob` on the high line
`t+u=y`; the extra root `X=0` records the axis point when `y in E`.
For distinct `y,z in G` and `m in R`, put

```text
d_(y,z,m)=(y-z)/(m+1).
```

The denominator is nonzero by `(SR24u)`.  Two high points `(u,t)` and `(v,s)`
on the `y,z` fibers have the same boundary intercept in slope `m` exactly
when

```text
y-(m+1)u=z-(m+1)v,
u-v=d_(y,z,m).
```

Since `(u-d)^3=u^3-d^3`, their number is the shifted common-root count

```text
deg gcd(Bhat_y(X),
        Bhat_z(X-d_(y,z,m)^3)).                    (SR24-grid-gcd)
```

No two distinct points on one `y`-fiber can collide in a boundary direction,
so summing over unordered pairs of high values gives the exact energy

```text
E_m(Z)=sum_({y,z} subset G)
 deg gcd(Bhat_y(X),Bhat_z(X-d_(y,z,m)^3)).          (SR24-grid-gcd')
```

Consequently

```text
sum_(m in R) sum_({y,z} subset G) deg gcd(...)
 =6r-sum_m epsilon_m+Xi >=6r-3.                    (SR24-grid-gcd'')
```

This is the rigorous incidence--factorization bridge missing from a generic
BSG heuristic.  At `q=27`, it replaces the energy calculation by only
`3*binom(9,2)=108` shifted gcds of quartics, whose total degree is at least
51.  A field-uniform closeout would now show that the coherence identities
`(SR24z)--(SR24z')` cannot support this many prescribed shifted common roots
unless the cover becomes affine-linearized; `(SR24r)` already excludes that
outcome.  That final shifted-gcd stability bound remains open, but its input
is now the exact cubic/quartic factor state rather than an undefined notion
of “near additivity.”

The second lifted moment reaches the carrier coefficients.  Define

```text
gamma=((1/3)sum_(P in B_aff)[t(P)u(P)]) mod 3
```

and abbreviate the four residue-field mixed moments

```text
a_*=sum t^(2r+1)u^r,       b_*=sum t^(2r)u^(r+1),
c_*=sum t^(r+1)u^(2r),     d_*=sum t^r u^(2r+1).
```

Squaring the first Witt carry modulo `3^2` gives the finite-slope law

```text
delta_2(t-mu)
 =gamma m+a_*m^r-b_*m^(r+1)-c_*m^(2r)+d_*m^(2r+1).
                                                        (SR24-Witt2)
```

For a normalized ratio fiber, Newton's recurrence gives

```text
sum_(m in R)m^(r+1)=kappa^r-1,
sum_(m in R)m^(2r+1)=1.
```

Consequently all other terms cancel between the balanced slope and the
three boundary slopes:

```text
sum_(g in G_(-1))g^2
 +sum_(m in R)sum_(c in T_m)c^2=-kappa^r b_*.       (SR24-Witt2')
```

The surviving mixed moment is itself just a top-coefficient extraction.
Write `A(X)=sum_(j=0)^(r-1)a_jX^j`.  On a row `X=u^3`, the two `t`-roots have
second power sum

```text
W^2+P=-u^2+uA(X)+A(X)^2+C(X).
```

After raising to `r`, put `A_bar(u)=sum a_j^r u^j` and similarly for `C`.
Multiplicative orthogonality in

```text
b_*=sum_(u!=0)u^(r+1)
       (-u^(2r)+u^r A_bar(u)+A_bar(u)^2+C_bar(u))
```

leaves only exponent `q-1`.  It occurs at degree `r-2` in `A_bar` and at
the top square of `A_bar`, so

```text
b_*=-a_(r-2)^r-a_(r-1)^(2r).                       (SR24-Witt2'')
```

Combining the last two displays gives the explicit top-coefficient gate

```text
sum_(g in G_(-1))g^2
 +sum_(m in R)sum_(c in T_m)c^2
 =kappa^r(a_(r-2)^r+a_(r-1)^(2r)).                 (SR24-Witt2''')
```

As before, the tripled common subset `E` may be deleted from the boundary
sums.  Thus the first two lifted moments recover the first two Fourier
coordinates of `G_(-1)` and constrain the top two coefficients of `A` using
the boundary ledger.  A full contradiction would require continuing this
coefficient extraction far enough to collide with the three norm identities.

There is a single exact formula for that continuation.  Put `L=t-mu` and
define the divided binomial lift

```text
Lambda_k(m)=((1/3)sum_(P in B_aff^Frob)
                    ([t(P)]-[m][u(P)])^k) mod 3.
```

It is defined because `(SR24b)` makes the residue of the numerator zero.
The carry identity `(SR24-Witt''')`, followed by a binomial expansion modulo
`3^2`, gives for every `1<=k<=q-2`

```text
delta_k(t-mu)
 =Lambda_k(m)
  -k m^r sum_P u(P)^r t(P)^r
                    (t(P)-m u(P))^(r+k-1).          (SR24-Wittk)
```

This packages every higher lifted slope constraint into divided mixed
carrier moments plus one explicit residue-field correction; it is not a new
family of independently chosen four-fiber sets.  The formula specializes to
`(SR24-Witt1)` and `(SR24-Witt2)`.  Frobenius also removes an entire third of
the nominal spectrum:

```text
delta_(3j)(L)=delta_j(L)^3.                         (SR24-Wittk')
```

Consequently the `q-2` Fourier coordinates in `(SR24-Witt'')` are generated
by the `2r-1` indices not divisible by three.  In particular `k=3` contains
no information beyond `k=1`; after the second-moment top-coefficient gate,
the next genuinely independent lifted constraint is `k=4`.  Formula
`(SR24-Wittk)` is now the smallest field-uniform route for extracting it and
testing it against `(SR24w')` and the reciprocal norm.

That `k=4` target has an explicit four-slope form.  In the normalized branch
put `D=R union {-1}`.  The four slopes are the roots of

```text
F_D(M)=M^4+(1-kappa)M-kappa.
```

For a point `(u,t)`, write `ell_m=t-mu`.  Newton's identities for `F_D`
give the pointwise identity

```text
sum_(m in D)ell_m^4=t^4+kappa u^4.                 (SR24-Witt4)
```

The carry of this equality is an ordinary residue-field polynomial.  For a
finite list `x=(x_i)`, define

```text
car(x)=-sum_(i!=j)x_i^2x_j+sum_(i<j<k)x_ix_jx_k;
sum_i[x_i]=[sum_i x_i]+3[car(x)^r].
```

Put

```text
s=t^4+kappa u^4,
e_3=t^3+(1-kappa)u^3,
e_4=t^4+(1-kappa)tu^3-kappa u^4,
p_i=sum_(m in D)ell_m^i.
```

Here `p_1=t,p_2=t^2,p_3=t^3,p_4=s`, and

```text
p_i=tp_(i-1)+e_3p_(i-3)-e_4p_(i-4),       5<=i<=8.
```

The third elementary function of the four values `ell_m^4` is
`e_3^4+t e_3e_4^2-e_4^3`.  Therefore the fourth-power carry difference in
`(SR24-Witt4)` is

```text
Theta_4(u,t;kappa)
 =-s p_8+s^3+e_3^4+t e_3e_4^2-e_4^3
   +kappa t^8u^4+kappa^2t^4u^8.                   (SR24-Witt4')
```

The two vertex sums on the right of `(SR24-Witt4)` vanish exactly in the
length-two Witt ring.  Summing the carries over the core consequently gives
the first genuinely new post-quadratic spectrum equation

```text
sum_(g in G_(-1))g^4
 +sum_(m in R)sum_(c in T_m)c^4
 =sum_(P in B_aff^Frob)Theta_4(u(P),t(P);kappa)^r. (SR24-Witt4'')
```

Again the common `E` terms may be deleted on the left.  Unlike a formal
Teichmuller expression, the right side is now a fixed homogeneous carrier
polynomial.  In fact the recurrence in `(SR24-Witt4')` collapses it to only
six monomials:

```text
Theta_4
 =(kappa^4-kappa+1)u^12
  +kappa^2(kappa-1)tu^11
  +kappa(kappa-1)^2t^2u^10
  +(1-kappa^3)t^3u^9
  +(1-kappa)t^9u^3+t^12.                          (SR24-Witt4''')
```

After raising to `r` and summing over `B_aff^Frob`, four of these six terms
vanish structurally.  The pure `u` term is a nontrivial vertex power sum.
The pure `t` term over the two-sheeted cover is `-sum_E e^4`, exactly
cancelled by the three axis points.  The `t^3u^9` and `t^9u^3` terms become
`tu^3` and `t^3u`, respectively, and vanish by `(SR24c)`.  Only the two
weighted mixed moments

```text
beta_1 =sum_P t(P)^r  u(P)^(2r+3),
alpha_1=sum_P t(P)^(2r)u(P)^(r+3)
```

remain, giving

```text
H_4:=sum_(g in G_(-1))g^4
     +sum_(m in R)sum_(c in T_m)c^4
 =kappa^(2r)(kappa-1)^r beta_1
  +kappa^r(kappa-1)^(2r) alpha_1.                 (SR24-Witt4'''')
```

For `q>=27`, multiplicative orthogonality extracts both moments from the top
four trace coefficients.  If `A(X)=sum a_jX^j`, then

```text
beta_1=-a_(r-4)^r,
alpha_1=-a_(r-4)^r+a_(r-3)^r a_(r-1)^r-a_(r-2)^(2r).
```

Consequently the complete fourth-spectrum gate is

```text
H_4
 =kappa^r(kappa-1)^r
   ((kappa^r+1)a_(r-4)^r+(kappa-1)^r Delta_A),

Delta_A=a_(r-3)^r a_(r-1)^r-a_(r-2)^(2r).
                                                     (SR24-Witt4''''')
```

This is the promised direct collision between the recovered four-fiber
spectrum, the boundary geometry, and the carrier: the first independent
lift after `k=2` sees exactly the top four coefficients of `A` and no
coefficient of `C`.  In the fixed `q=27` Frobenius class `kappa=-1` (audit
encoding `2`), the `a_(r-4)` term disappears and the gate is simply

```text
H_4=-Delta_A=a_(r-2)^(2r)-a_(r-3)^r a_(r-1)^r.    (SR24-Witt4-q27)
```

Thus one of the two semilinear `q=27` ratio representatives sees only a
Frobenius-twisted `2 by 2` Hankel determinant of the top three trace
coefficients.  For the other representative `kappa=18` in the audit basis,
the same gate is

```text
H_4=7a_5^9+26(a_6^9a_8^9-a_7^18).                 (SR24-Witt4-q27')
```

These are the two complete semilinear `q=27` fourth-spectrum carrier states;
the other two normalized `kappa` values are Frobenius conjugates of the
second.  The exact `q=27` audit checks
`(SR24-Witt4)--(SR24-Witt4''')` for all four normalized `kappa` fibers and
every `(t,u)`, namely 2,916 states, and checks the two coefficient extractions
on 27 deterministic arbitrary degree-eight pairs `(A,C)`.

The four support sets can now be compressed into one polynomial without
discarding these lifted constraints.  Let

```text
H_m(Z)=product_(c in T_m)(Z-c),
K_*(Z)=G_(-1)(Z) product_(m in R)(H_m(Z)/J(Z)).
```

The divisibility by `J` is `(SR24-Witt1'')`, and `K_*` is monic of degree
`7r-9`.  Its root multiset is precisely `G_(-1)` together with the three
boundary supports after deleting their common `E`; hence its first, second,
and fourth power sums are the left sides of `(SR24-Witt1''')`,
`(SR24-Witt2''')`, and `(SR24-Witt4''''')`.  Write `epsilon_i` for its
elementary symmetric functions.  Newton's identities in characteristic three
therefore give

```text
epsilon_1=0,
epsilon_2=H_2
 =kappa^r(a_(r-2)^r+a_(r-1)^(2r)),
epsilon_4=-H_4-H_2^2.                              (SR24-WittK)
```

The third coefficient remains free because the multiplier `3epsilon_3`
vanishes; this identifies the next precise blind spot rather than hiding it.
For the `q=27`, `kappa=-1` representative,

```text
epsilon_4=Delta_A-H_2^2,
H_2=-(a_7^9+a_8^18).                               (SR24-WittK-q27)
```

Thus the four formerly separate high-support polynomials have a combined
degree-`7r-9` spectral product whose first, second, and fourth leading data
are fixed by the top trace coefficients.  A closeout may now attack the
factorization `K_*=G product(H_m/J)` together with the linear four-partite
incidence system `(SR24-grid)`, instead of carrying four unrelated Fourier
spectra.

The ratio moments give a second, slanted extraction of the same local Newton
polynomials.  With `Q_k` as in `(SR24s''')`, one has simultaneously

```text
-sum_(e in E)e^k
 =-sum_j [X^(j(q-1))]Q_k(X),

-sum_(rho in R)rho^k
 =-sum_j [X^(rk-j(q-1))]Q_k(X),              1<=k<=q-2, (SR24w)
```

where in each line `j` ranges over the indices for which the displayed
exponent lies between zero and `kr`.  Thus the two singleton sets are the
characteristic roots of two rank-three diagonal extractions from one
order-two local sequence.

At `k=1,2` the ordinary diagonal has not yet reached a positive multiple of
`q-1`, so it first gives

```text
e_1(E)=A(0),                         e_2(E)=C(0).
```

The first genuinely product-sensitive instance is `k=4`.  Newton's
identities for a three-set then give

```text
[X^(q-1)]Q_4=e_1(E)e_3(E),
[X^(r+1)]Q_4=w e_3(R).                              (SR24w')
```

The second equality uses `(SR24u)`; the top coefficient of `Q_4` is `-w^4`,
and the two ratio diagonals at `4r` and `r+1` supply the displayed sign.
If the three-cell transversal exists, let `U=A_0^r` be its row set.  Its
product identity is `e_3(U)e_3(R)=e_3(E)`, so `(SR24w')` compresses the
first/second-carrier product compatibility to the single coefficient gate

```text
w [X^(q-1)]Q_4
 =A(0)e_3(U)[X^(r+1)]Q_4.                           (SR24w'')
```

This is necessary only in the extendable branch; it does not silently replace
the two-scalar transversal test `(SR19d)`.  Its value is that a search need
not carry two independent product ledgers: two coefficients of the first
carrier's fourth Newton polynomial already contain them.

The entire second projection also has an exact norm form.  Put
`J_R(D)=product_(rho in R)(D-rho)`.  Since `d=t/u` has three zero values on
the marked cells, singleton values `R`, and doubleton fibers at every other
nonzero value,

```text
product_(X!=0)
 (D^2-X^(-r)W(X)D+X^(-2r)P(X))
       =D^3(D^(q-1)-1)^2/J_R(D).                    (SR24x)
```

Equivalently, for `v=y/u=d+w`,

```text
product_(X!=0)
 (V^2-X^(-r)A(X)V+X^(-2r)C(X))
 =(V-w)^3((V-w)^(q-1)-1)^2/J_R(V-w).               (SR24x')
```

The negative exponents admit a cleaner removal than clearing denominators.
Put `Z=X^(-1)` and reverse the two low-degree coefficients,

```text
A^*(Z)=Z^(r-1)A(Z^(-1)),          C^*(Z)=Z^(r-1)C(Z^(-1)).
```

Because inversion permutes `F_q^*`, `(SR24x')` is the ordinary polynomial
resultant identity

```text
product_(Z!=0)
 (V^2-ZA^*(Z)V+Z^(r+1)C^*(Z))
 =(V-w)^3((V-w)^(q-1)-1)^2/J_R(V-w).              (SR24x'')
```

Thus the reciprocal chart acts by literal coefficient reversal: its trace
has degree at most `r` and its product has degree at most `2r`.  The remaining
balanced carrier is one quadratic family whose three projections have the
explicit norms `(SR24v')`, `(SR24v'')`, and `(SR24x'')`.  This avoids
introducing an independently chosen second-chart carrier: its entire spectral
content is already the reversal of the first family.  Proving that this
three-norm system has no degree-`r-1` solution, or constructing one, is the
exact nonlinear algebraic closeout.

The hidden factor `G` itself has a lower-degree algebraic avatar.  Split it as

```text
G_3=gcd(G,J),                    G_4=G/G_3,
```

where `deg G_3=g<=3`: roots of `G_3` are the values whose deleted axis point
leaves a three-fiber of `S`, while roots of `G_4` retain four points.  In the
split étale algebras `K_i=F_q[Y]/(G_i)`, whenever the corresponding factor is
nonconstant, write `y_bar` for the residue class of `Y`.  Componentwise monic
gcd and the Chinese remainder theorem give
unique monic polynomials `H_i in K_i[X]` satisfying

```text
deg H_i=i,
H_i divides C(X)-y_bar A(X)+y_bar^2,
H_i divides X^(q-1)-1,          gcd(H_i,dH_i/dX)=1,  i=3,4. (SR24y)
```

The respective cofactors have degrees at most `r-4` and `r-5`.  This replaces
the moving degree-`r` multiplicity-three norm factor by cubic/quartic divisors
of the fixed split polynomial `X^(q-1)-1`.  At least `r-3` components lie in
the quartic algebra.  For `q=27`, the two local factor types are cubic by
degree at most five and quartic by degree at most four.  The minimal
first-field search can enumerate these factorizations rather than arbitrary
degree-eight pairs `(A,C)`.

These separate factorizations obey a strong coherence law.  For each root
`y` of `G`, let

```text
B_y(X)=gcd(C(X)-yA(X)+y^2, X^(q-1)-1),
C(X)-yA(X)+y^2=B_y(X)L_y(X).
```

Then `deg B_y=3` on `G_3`, `deg B_y=4` on `G_4`, and
`gcd(L_y,X^(q-1)-1)=1`.  For any two distinct roots `y,z` of `G`,

```text
(B_yL_y-B_zL_z)/(y-z)=y+z-A(X),
A(X)=y+z-(B_yL_y-B_zL_z)/(y-z),
C(X)=B_yL_y+yA(X)-y^2.                              (SR24z)
```

Thus any two factorized high fibers determine the entire carrier.  Every
third root `s` must pass the polynomial divided-difference identity

```text
(B_yL_y-B_zL_z)/(y-z)
 -(B_zL_z-B_sL_s)/(z-s)=y-s.                       (SR24z')
```

Equivalently, for every positive `X`-degree, the corresponding coefficient
of `B_yL_y` is an affine function of `y`; after subtracting `y^2`, the same
is true in degree zero.  At `q=27`, two cubic/quartic factorizations generate
`A,C`, and the other seven roots of `G` are pure verification constraints.
This is the smallest exact coefficient search state obtained so far.

There is also a useful incidence invariant.  Let `n_j` count the nonzero
`X`-values belonging to exactly `j` of the `G`-root fibers.  Since the cover
is quadratic in `y`, `j` is at most two.  Counting the `3g+4(r-g)` incidences
both ways gives

```text
n_0+n_1+n_2=3r-1,          n_1+2n_2=4r-g,
n_2-n_0=r+1-g.                                     (SR24z'')
```

Hence at least `r+1-g>=r-2` rows have both cover roots among the high-fiber
values.  At `q=27` the excess is `10-g`, between seven and ten.  For such a
row shared by the `y,z` fibers, `(SR24z)` specializes to
`A(X)=y+z`, `C(X)=yz`; distinct unordered pairs give distinct target pairs.

The low-order end of the two complete norms exposes the marked rows directly.
Let `M={u^3:u in U}` be the three roots of `P` in `F_q^*`.  For `X notin M`,
define the reciprocal local Newton sequence

```text
R_0(X)=2,                 R_1(X)=W(X)/P(X),
R_k=(W/P)R_(k-1)-(1/P)R_(k-2).
```

At a marked row the zero `t`-root is omitted and the other root is `W(X)`.
The reciprocal power sums of the two almost-duplex projections are therefore

```text
L_k=sum_(X in M)W(X)^(-k)+sum_(X notin M)R_k(X)
   =-sum_(e in E)e^(-k),

K_k=sum_(X in M)X^(rk)W(X)^(-k)
    +sum_(X notin M)X^(rk)R_k(X)
   =-sum_(rho in R)rho^(-k),              1<=k<=q-2. (SR24z''')
```

These are the zero-end counterpart of the coefficient diagonals `(SR24w)`;
unlike the ordinary moments, they retain the marked set `M` explicitly.
At `k=1`, using `e_2(E)=C(0)`, `e_2(R)=w^2`, and the unconditional product
identity `e_3(U)e_3(R)=e_3(E)`, they collapse to

```text
C(0)K_1=w^2 e_3(U)L_1.                              (SR24z'''')
```

The coefficient of `T^3` in the two norms gives the same product identity
directly: the three marked linear factors contribute `-product_M W`, while
the unmarked factors contribute `product_(X notin M)P(X)`; reciprocal scaling
multiplies this coefficient by `e_3(U)`.  Thus `(SR24z'''')` is not a
transversal assumption.  It is a rational scalar gate on `A,C,w,U` that
holds in both the extendable and nonextendable branches.

The preceding calculation can be isolated as the following reusable
structural proposition.

> **Balanced three-norm proposition.**  Let `q=3r`, and suppose a `+1`
> triangular target carrier has reached the balanced branch of
> `(SR24m-shear)`.  Then, after the simultaneous semilinear Frobenius change,
> it is a two-sheeted cover
> `y^2-A(X)y+C(X)=0` of `F_q^*`, with `deg A,deg C<=r-1` and `X=u^3`.
> Its shear coefficient satisfies `w!=0`.  The three ratio singletons obey
> `e_1(R)=w`, `e_2(R)=w^2`, and `-w notin R`; hence the sheared direction is
> ordinary and has the exact ledger `(SR24v)`.  Consequently there are
> squarefree polynomials `J,J_R,G` of degrees `3,3,r` for which its three
> projection norms are exactly `(SR24v')`, `(SR24v'')`, and `(SR24x'')`.
> Splitting `G` by its overlap with `J`, the level polynomial has the unique
> cubic/quartic divisors `(SR24y)` of `X^(q-1)-1` over the corresponding
> étale algebras.
> Their products with the root-free cofactors obey the coherence identities
> `(SR24z)--(SR24z'')`.
> For fixed `w`, the possible `R` are precisely `w` times the nonzero
> three-fibers of `Z(Z+1)^2`, giving `(q-3)/6` choices and
> `(q-1)(q-3)/6` across all nonzero `w`.  If the carrier
> is extendable through the singleton transversal, it additionally satisfies
> the fourth-Newton coefficient gate `(SR24w'')`.

Indeed, `(SR24u)` follows by extracting the first two multiplicative
frequencies of the ratio projection.  It places the shear in the ordinary
row of `(SR24a)`, whose integer fiber ledger gives `(SR24v)` and hence the
first two norms by recording root multiplicities.  Applying the same ledger
to `t/u`, followed by `Z=X^(-1)`, gives the reversed third norm.  The collision
calculation for `Z(Z+1)^2` gives the stated finite list, while the two
diagonals of `Q_4` give the transversal gate.  No classification theorem is
being smuggled into the proposition: it is a necessary normal form.  Its
unresolved content is exactly whether these three resultants can coexist with
the remaining line caps and transversal constraints.

At `q=27` this normal form now has a complete executable search interface,
but not an exhaustive verdict.  The 2,120 normalized transversals reduce
jointly with their carriers to 714 weighted semilinear tasks.  For each task,
the exact Rust DFS streams the possible nine-value high sets, branches on the
most constrained unprocessed row, and inserts every selected equation

```text
C(x)-yA(x)=-y^2
```

transactionally into the 384-byte rollback basis.  Rank 18 determines one
carrier.  Rank 17 enumerates the full 27-point affine line; this is precisely
the fractional-linear singleton defect from the terminal-nullity theorem.
Each compatible carrier is then checked against the complete `y`-fiber
ledger, the three completion-cell exclusions, both remaining projection
norms, and the fourth-Witt coefficient identity.  A cutoff has the separate
status `Incomplete` and cannot be emitted as a rejection.

Failed terminals retain an inclusion-minimal high-cell core.  The mapping,
high set, and core are canonicalized together under Frobenius, so a completed
714-task run can quotient the rejection reasons and expose a bounded symbolic
Möbius core if one exists.  This is the intended bridge back to the uniform
problem: a core is relevant asymptotically only after its table values are
rewritten as a bounded-degree identity over `F_(3^h)`.  The present bounded
probes remain `Incomplete`; neither they nor the existence of the finite DFS
proves the `q=27` branch empty, and neither implies the field-uniform C949
upper bound.

The first core type does have a field-uniform interpretation.  Let `q>=5` be
odd and let a rank-one carrier family be

```text
(A_lambda,C_lambda)=(A_0,C_0)+lambda(P,Q).
```

At a fixed row `x`, all `lambda in F_q` fail to give two distinct roots if
and only if

```text
D_x(lambda)=(A_0(x)+lambda P(x))^2
             -(C_0(x)+lambda Q(x))
```

is never a nonzero square.  This forces

```text
P(x)=Q(x)=0,
D_x=A_0(x)^2-C_0(x) is zero or a nonsquare.        (SR24z-Mobius)
```

Indeed, a nonconstant linear polynomial has quadratic-character sum zero.
A quadratic with nonzero discriminant has character sum minus the character
of its leading coefficient, hence cannot be nonpositive at all `q` inputs
when `q>=5`.  If its discriminant is zero, its nonzero values have the
character of its leading coefficient; here that coefficient is `P(x)^2`, a
square.  Both quadratic cases are impossible, so `P(x)=0`; the remaining
linear case then forces `Q(x)=0`.  Thus an empty 27-bit row mask is not merely
finite table data: it certifies a common zero of the two kernel-direction
polynomials.  The remaining uniform task is to combine that extra common zero
with the seven-double-row factor and the singleton Möbius graph strongly
enough to kill the rank-one family.

For the exceptional `q=27` terminal, a *one-row* empty-mask core already does
kill it.  Here `n_2=7,n_1=19`.  The kernel pair `(P,Q)` vanishes on the seven
double-high rows.  The empty-mask row cannot be one of them, since at a
double-high row every member contains the same two distinct roots and its
mask is full.  By `(SR24z-Mobius)` it supplies an eighth common zero.  Since
`deg P,deg Q<=8`, write

```text
P=pH,             Q=qH,              deg H=8.
```

Since `n_0=0`, the new row is one of the 19 singleton rows.  At each of the
other 18 singleton rows, `H` is nonzero and the kernel equation is `Q=yP`.
If `p=0`, it forces `q=0`; otherwise all 18 remaining singleton values equal
`q/p`, contradicting the cubic/quartic fiber cap four.  Thus the
kernel direction is zero, contrary to rank 17:

```text
one empty row mask excludes the q=27 Mobius terminal. (SR24z-Mobius')
```

In fact the apparently harder multirow alternative disappears once the
completed incidence profile is retained.  In any rank-one family, a double
row fixes two distinct roots for every parameter, so its split mask is full.
At a singleton row with fixed root `y`, the kernel equation is `Q(x)=yP(x)`.
If `P(x)!=0`, the other root is affine and nonconstant in `lambda`, so it
collides with `y` for exactly one parameter.  If `P(x)=0`, then `Q(x)=0` and
the mask is either full or already empty by itself.  Consequently, if no
single row mask is empty, the intersection of all split masks has size at
least

```text
q-n_1.                                                   (SR24z-Mobius'')
```

For the exceptional balanced profile over `q=27`, `n_2=7,n_1=19,n_0=0`,
so at least eight parameters split on every row.  More generally the profile
`q=3r`, `n_2=r-2,n_1=2r+1,n_0=0` leaves at least `r-1` split parameters.
Thus a jointly empty multirow mask can occur only at an *unfinished* DFS
node; it is an exact extension prune, not a new completed terminal
obstruction.  At an unfinished rank-17 node, the nonempty split parameters
are still candidate completions, and adding their remaining high cells can
raise the rank to 18.

There is a stronger completed-profile conclusion.  Let `H` be the product of
the seven double-row factors.  Any kernel direction satisfies

```text
P=H L,             Q=H M,             deg L,deg M<=1.
```

At a singleton row outside a common zero of `L,M`, its fixed high value is
`y=M(x)/L(x)`.  There is at most one additional common zero.  Hence this
fractional-linear map is defined on at least 18 of the 19 singleton rows.  If
it is nonconstant it is injective, requiring at least 18 distinct high values
although the high set has size nine.  If it is constant, one high value occurs
at least 18 times, contradicting the fiber cap four.  The cases `P=0` or
`Q=0` reduce immediately to the zero direction.  Therefore

```text
the completed q=27 exceptional high-incidence matrix has rank 18.
                                                     (SR24z-Mobius''')
```

This closes terminal nullity field-uniformly, not only in the exceptional
case.  For `q=3r`, let `g<=3` be the number of high values having multiplicity
three; the other `r-g` high values have multiplicity four.  The two incidence
counts give

```text
2n_2+n_1=4r-g,       n_2+n_1+n_0=3r-1,
n_2-n_0=r+1-g.                                      (SR24z-rank)
```

Hence `n_2>=r-2`.  If `n_2>=r`, the degree-at-most-`r-1` kernel pair vanishes
identically.  If `n_2=r-1`, removing the double-row factor leaves two
constants; all singleton values would be equal, but
`n_1=2r+2-g>=2r-1>4`.  Finally `n_2=r-2` forces
`g=3,n_0=0,n_1=2r+1`, and the preceding fractional-linear argument applies
on at least `2r` singleton rows.  Thus for every `q=3^h>=9`,

```text
every completed balanced high-incidence carrier has full affine rank 2r.
                                                  (SR24z-rank')
```

Rank `2r-1` is only a useful partial-DFS candidate generator; every carrier
that passes the complete fiber gate is uniquely determined.  This removes
the exceptional Möbius degree of freedom field-uniformly, but it does not
yet prove that the unique carrier fails one of the remaining three-norm,
mapping, or Witt gates.

The resulting rank-18 branch has a finite structural compression, although not yet
a field-uniform contradiction.  Any 18 independent high-cell equations
reconstruct its unique `(A,C)`.  Every later rejection is then certified by
those equations, the fixed mapping/high-value data, and one deterministic
gate evaluation.  Greedy deletion therefore leaves at most 18 high cells; if
it reaches 17, the stronger statement is that every member of that affine
line fails the same gate:

```text
every q=27 terminal rejection has a carrier core of size at most 18.
                                                            (SR24z-rank18)
```

This removes the remaining row-incidence combinatorics from a rank-18
terminal.  It does **not** by itself give a bounded field-symbolic core as
`q` varies, since the carrier dimension is `2q/3`; the next lift must rewrite
the observed gate failure as a fixed-degree norm, Witt, or reciprocal
identity.

At `q=9` the proposition already gives a short structural exclusion.  The
ordinary ledger requires three values whose `S`-fibers have size three or
four, but every level `C-yA+y^2` has degree at most two.  Such a polynomial
cannot have three or four nonzero roots unless it vanishes identically, in
which case it has all eight.
Thus the balanced branch is empty at `q=9`.  As a reproducibility check, the
audit also exhausts this normal form.
Among all degree-at-most-two pairs `(A,C)`, exactly 3,312 give a split
two-sheeted cover over `F_9^*`; testing all eight nonzero shears gives 26,496
parameter cases.  None has the simultaneous `t`, `t/u`, and ordinary-`y`
fiber ledgers of the proposition, even before the transversal gate is
imposed.  The enumeration is not used as asymptotic evidence; for `q>=27`,
degree alone permits four-fibers and the field-uniform problem remains.

Summarizing, every Frobenius-quadratic carrier satisfies the following exact
section dichotomy:

```text
generic branch:
  at most two identically-zero section derivatives in total;
  every other nonexceptional-slope derivative is squarefree and has
  at most r critical field points;

balanced-shear branch:
  the unique all-intercept slope is m=-s;
  all q sections are cubes of the marked degree-(r-1) pencil
  C-yA+y^2, with y=c^r.                              (SR24q)
```

There is no third derivative branch.  In the generic case the remaining
difficulty is simultaneous distinct-root control for squarefree sections;
in the balanced case it is the marked square-value/Redei pencil plus the
second carrier.  This dichotomy is structural but not an upper-bound proof.

One of the three chart compatibilities is in fact completely explicit and
does not require extendability.  Between the last two charts in `(SR24g)`,
write `c=b/a`.  Their coordinates obey

```text
(u_2,v_2)=(c,1/a),          (u_3,v_3)=(c^(-1),c^(-1)v_2).
```

The singleton fibers correspond under `c |-> c^(-1)`, and their adjoined
zero values correspond as well.  Scaling the two Frobenius roots in each
fiber therefore gives the exact transition laws

```text
W_3(c^(-1))=c^(-r)W_2(c),
P_3(c^(-1))=c^(-2r)P_2(c).                          (SR24n)
```

Equivalently, if `W_2(X)=sum_{d=0}^r w_dX^d`, then
`W_3(Y)=sum_d w_dY^(r-d)`, and the same reversal holds across degrees
`0,...,2r` for `P`.  Thus the third quadratic normal form is determined by
the second; it is not a third independent constraint.  The genuinely
nonlinear compatibility gate is between the first carrier and the second:
on the torus their common set `H` is described equivalently by

```text
b^(2r)-W_1(a)b^r+P_1(a)=0,
1-W_2(b/a)a^r+P_2(b/a)a^(2r)=0.
```

Both cleared expressions have total degree at most `2r`, but the shared
set has only `2q-5` points, far below a Bezout factor-forcing threshold;
the transition law alone is therefore a compression, not a contradiction.

For an extendable almost-duplex there is a further coupled obstruction.
Write the three completing cells as
`R={(a_t,b_t):1<=t<=3}` and put, in each chart,

```text
mu_i^(nu)=sum_{(u,v) in K_nu} u^i v^r,
                                      1<=i<=2r-2.   (SR24o)
```

The carry-free moment vanishing on `H` says that these are exactly the
three-cell deletion sums.  In the three charts of `(SR24g)` they are

```text
mu_i^(0)=sum_t b_t^r a_t^i,
mu_i^(1)=sum_t a_t^(-r)(b_t/a_t)^i,
mu_i^(2)=sum_t b_t^(-r)(a_t/b_t)^i.
```

Set `c_t=b_t/a_t`.  Since `q-1=3r-1`, the last two formulas give the exact
critical-band reversal

```text
mu_i^(2)=mu_(2r-1-i)^(1),             1<=i<=2r-2.   (SR24p)
```

Moreover each displayed moment sequence has exact Prony rank three on this
band.  Indeed it has the form `mu_i=sum_t lambda_t x_t^i`, with three
distinct nonzero `x_t` and three nonzero `lambda_t`.  Therefore, whenever
the indicated entries stay in the band,

```text
det(mu_(k+i+j))_(0<=i,j<=2)
 = (prod_t lambda_t x_t^k) prod_(s<t)(x_t-x_s)^2 !=0,
det(mu_(k+i+j))_(0<=i,j<=3)=0.
```

Equivalently, every completion band obeys one third-order recurrence whose
characteristic roots are its three singleton coordinates.  The two
reciprocal charts must have reciprocal characteristic roots, paired weights
`lambda_t^(2)=lambda_t^(1)c_t^(-r)`, and the full reversal `(SR24p)`; the
third chart comes from the same three cells.  This is a coupled three-chart
compatibility certificate, substantially stronger than imposing the
no-three-consecutive-zeros condition separately.  Its scope is deliberately
conditional: it obstructs candidates that pass the singleton completion
gate, but it neither proves that every target core is extendable nor closes
the nonextendable branch.

In fact one completed chart band determines the missing transversal and both
other bands.  Order `A_0={a_1,a_2,a_3}` arbitrarily and let
`lambda_t=b_t^r`.  The first three equations in chart zero are

```text
(mu_1^(0),mu_2^(0),mu_3^(0))^T
  =(a_t^i)_(1<=i,t<=3) (lambda_1,lambda_2,lambda_3)^T. (SR24p')
```

The matrix is a Vandermonde matrix times `diag(a_t)` and is invertible.
Hence these three moments recover the `lambda_t`, cubing recovers
`b_t=lambda_t^3`, and the completion test is exactly that the recovered
`b_t` and `a_t/b_t` give `B_0` and `C_0` with new cells.  Once it passes,
the three explicit sums in `(SR24o)` determine both remaining critical
bands.  Thus a construction search must not choose three Prony sequences
independently: one three-moment seed plus the singleton sets fixes the entire
coupled certificate.

There is an equivalent exact dual-code certificate.  Let `V` be the three
triangle vertices and let `L_infty` be the connector chosen as the line at
infinity.  Over `F_3` put

```text
g=1_D-1_{L_infty}-1_V.                              (SR24k)
```

On the affine patch this is `1_{B_aff}-1_{(0,0)}`.  On `L_infty` it is zero
at the three points of `D`, `+1` at the two triangle vertices, and `-1` at
the other `q-4` points.  Thus

```text
g: (+1)^(2q+3) (-1)^(q-3) 0^(q^2-2q+1),
wt(g)=3q.                                           (SR24l)
```

For an affine line of direction `d`, the sum of
`1_{B_aff}-1_{(0,0)}` is the direction constant `c_d`: it is `2` in the two
vertex directions, zero in the three infinity-boundary directions, and one
otherwise.  The point of `L_infty` in that direction has coefficient
`-c_d`, so every affine projective line has `g`-sum zero.  The line at
infinity has sum `2-(q-4)=6-q=0` in `F_3`.  Hence

```text
M g=0 over F_3.
```

This places every `+1` triangular core behind a weight-`3q` ternary
dual-incidence word with a prescribed sign split.  Hull membership is not
asserted: the existing small-line-cover theorem applies to words also known
to lie in the line code, and `(SR24k)` by itself proves only dual membership.

The recent few-special-directions theorem does not bridge this gap.  On the
affine patch, subtracting the origin makes the line sum constant within every
parallel class: it is `2`, `0`, or `1` according to the direction class in
`(SR24a)`.  Hence the corresponding ternary multiset has *zero* mod-special
directions.  Adriaensen--Szőnyi--Weiner Theorem 1.8 explicitly permits this
zero branch, while their small-weight classification concerns words already
in the line code `C(2,q)`.  Our word is presently only in `C(2,q)^perp`.
Therefore neither their degree bound nor their small-weight theorem licenses
a few-line representation of `g`; a successful code-theoretic closeout would
need the genuinely new step `g in C(2,q)` (or a direct classification in the
dual at weight `3q`).

The signed support spectrum is also fixed.  Writing `(p,n)` for the numbers
of positive and negative coordinates on a line, its projective lines split as

```text
(0,0)^(q-3),
(1,1)^[3+(q-4)(2q/3-1)],
(2,2)^(q-4),
(3,0)^(4q-2),
(4,1)^[2+(q-4)q/3],
(2,q-4)^1.                                         (SR24l')
```

The last line is `L_infty`.  The other profiles follow direction by
direction from `(SR24a)`: subtract the negative origin on its line and add
the direction coefficient at infinity.  In particular the support has no
tangent, every support bisecant joins opposite signs, and all non-infinity
support lines have size at most five.

For comparison, the other triangular survivor `(j,sigma)=(5,-1)` has

```text
(N_1,N_2,N_3,N_4)
 =((2q^2-8q+3)/3, 2q-2, q, q(q+2)/3+2),
A_1=q/3-1+2eta-h-2H,
A_2=-q/3-1-eta+2h+3H.                               (SR25)
```

It therefore requires a linear trade among its high secants even when
`eta=1`: nonnegativity of `A_2` gives

```text
2h+3H>=q/3+1+eta.                                  (SR25')
```

Thus even an `eta=o(q)` realization of this row must omit `Omega(q)` high
secants.  It is categorically outside the fully selected high-arrangement
carrier mechanism.  The quartic carrier lemma can address only the
`eta=1`, `(4,-3)` triangular arm; the `(5,-1)` arm needs a separate global
trade theorem or construction, while `(SR1e)--(SR1f)` reduce the seven
concurrent arms to three affine ghost types.

#### Bound status after the structural upgrade

The unconditional asymptotic statement is now strengthened from C945's lower
side

```text
T_3(q)>=q^2/3+4q/3-o(q)
```

to `(LB3++)`, with linear coefficient `5/3`.  The exact coefficient endpoint
is absent as well, so any construction proving sharpness must approach it
from above by a nonzero sublinear repair.

No matching upper bound is proved here.  What is now proved is that the exact
`q=9` equality mechanism is Hermitian-unital-minus-secant, that its sign
counts match C949 only at `q=9`, and that its broader collinear-negative
replacement is exactly the modular-multiset problem `(M31)` with defect
`(M32)`.  More decisively, the hull/stability/transversal argument above
eliminates the entire `T=2q+1` five-character branch for every ternary
`q>=27`, without symmetry.  For `q>=81`, the exact-target theorem goes
further: it eliminates both envelope branches for arbitrary complete arcs.
This obstructs the literal `(FC5)` route to `(UB3)` and rules out an arc at
the exact central size.  The exact-target theorem alone gives no one-sided
bound; the uniformization below is what supplies one.
The bounded-repair theorem strengthens this first to every fixed additive
repair.  The three-line compression then excludes every displacement below
`q/3-o(q)`, proving the coefficient `5/3`, and the exact endpoint audit rules
out displacement exactly `q/3`.  Thus the proposed matching `(UB3)` is false.
A sharp construction, if the new coefficient is optimal, must approach it
from above with a nonzero sublinear repair; `+1` is not excluded.

The full closeout target is therefore a **robust three-line inverse theorem**,
not the carrier lemma alone.  For each of the three concurrent ghost types
`m_0 in {1,4,7}` and the two triangular signatures, one must prove that a
cap-compatible core with `eta<=epsilon q` either belongs to an explicit
realizable normal-form family or incurs `c q` omitted high secants/overloaded
pencils and hence `eta>=c q`.  A realizable family in any arm would provide
the missing upper side; uniform certificates in every arm would move the
lower linear coefficient again.  The exact `(4,-3)` carrier problem is the
zero-error boundary of only one arm.

Finally, for a core-line intersection `1<=d<=5`, the threshold itself has the
binomial-energy expansion

```text
1_{d>=3}=binom(d,3)-3binom(d,4)+6binom(d,5).
```

At a core point the corresponding formula is
`binom(d-1,2)-2binom(d-1,3)+3binom(d-1,4)`.  This converts the selected-secant
condition into exact collinearity energies and supplies a second route to a
stability or incidence-code classification.

### Exact `q=9` result

The complement formulation gives the exact base value

```text
t_7(2,9)=39=9^2/3+4*9/3.
```

The model maximizes a minimal triple blocking set `B` in `PG(2,9)`.  Binary
variables encode `B` and its essential `3`-secants; an essential secant and
its three points are normalized using the transitivity of `PGL(3,9)` on a
line with an ordered triple.  The paired integer envelope first gives
`|B|<=53`.  At `|B|=53` it forces exactly 18 essential secants, one external
point of secant-degree two, and only three possible selected-secant line
spectra; normalizing that repeated point and its second essential secant, the
exact CP-SAT decision model is infeasible.  A feasible `|B|=52` model has 19
essential secants and line spectrum

```text
B:                  3^19 6^43 7^28 9^1,
A=PG(2,9) minus B:  1^1  3^28 4^43 7^19.
```

Thus `A` is a complete `(39,7)`-arc, while `|B|<=52` proves no smaller one
exists.  The selected 19 secants form a dual blocking set with spectrum

```text
1^47 2^5 3^24 4^14 5^1.
```

The positive witness is independently checked by reconstructing `GF(9)`, all
91 points and lines, its line spectrum, and an essential `3`-secant through
every point of `B`.  Exact infeasibility is presently trusted to OR-Tools
CP-SAT's integer solver; no second exhaustive implementation is available.
This exact base equality is encouraging but remains explicitly noisy finite
evidence, not asymptotic evidence.

The witness also lands on the exact first-order lattice branch selected by
C945, not only on its final coefficient.  Here `q=3m` with `m=3`, and

```text
k=39=3m^2+4m,       T=19=6m+1,
```

so `(c,h)=(4,1)`.  This is the residue class in which C945's support-one
obstruction forces repair support at least two and the modular-lift minimum is
attained.  Consequently the first sharp `q=27` realization target is not the
whole previous window but

```text
m=9,       k=279,       T=55.
```

A non-two-character dual blocking core of size 55, followed by feasible weak
inverse realization with maximal intersection 19, would reproduce the full
first-order equality data at the next field order.  Failure at this single
parameter would not disprove `(ASY3)`, but it is the highest-information first
test before widening `T` or the linear coefficient.

#### Structural construction of the 39-point witness

The positive half no longer depends on the optimizer.  It has the following
unital-plus-switch construction in the dual plane.  Write

```text
GF(9)=GF(3)[w]/(w^2+1),       a+bw <-> a+3b in the data file.
```

For a primal point `x`, write `ell_x={y:x^T y=0}` for its corresponding dual
line.  Let `U` be the classical Hermitian unital

```text
U={y : (y^3)^T H y=0},
H = [1 4 7; 7 1 2; 4 2 2],
```

where the entries use the displayed integer encoding, and put `P=(0,1,5)`.
The following matrix fixes `P`, preserves `U`, and generates a cyclic group
`G` of order four on dual points:

```text
M = [1 6 5; 2 6 6; 4 7 2].
```

Let `T` consist of all tangent lines to `U` that do not pass through `P`.
There are 24 of them.  Let `F` be the union, under the contragredient line
action of `G`, of the five dual lines with coefficient vectors

```text
(1,0,4), (1,0,7), (1,1,3), (1,2,8), (1,4,3).
```

Their orbit sizes are respectively `4,4,2,4,1`; all 15 members of `F` are
secants of `U`.  Define the primal set

```text
A={x : ell_x is in T union F}.
```

This gives `|A|=24+15=39`.  Its mechanism is visible without inspecting 39
unrelated points.  The exterior point `P` lies on four tangents to `U`; let
`C` be their four contact points and let `K` be the other 32 exterior points
on those tangents.  Incidence with the 15-line switch `F` is

| dual-point class | size | number of members of `F` through a point |
|---|---:|---|
| `C` | 4 | `3^4` |
| `U minus C` | 24 | `2^24` |
| `P` | 1 | `1^1` |
| `K` | 32 | `1^28 4^4` |
| exterior points off the four tangents | 30 | `0^15 3^15` |

Here `d^m` means that `m` points have degree `d`.  The tangent family `T`
has degree zero on `C` and `P`, degree one on `U minus C`, degree three on
`K`, and degree four on the remaining exterior points.  Adding the two tables
therefore gives the dual point-degree spectrum

```text
1^1 3^28 4^43 7^19.
```

Under primal-dual incidence, this is exactly the line-intersection spectrum
of `A`; in particular no line contains more than seven points of `A`.  If `D`
is the set of the 19 dual points of degree seven, the same `C_4` orbit check
gives

```text
number of D-points on a selected dual line:    3^24 4^14 5^1,
number of D-points on an unselected dual line: 1^47 2^5.
```

Consequently every unselected dual line contains a member of `D`.  Equivalently,
every primal point outside `A` lies on a 7-secant of `A`, so `A` is complete.
This proves the constructive upper bound `t_7(2,9)<=39` structurally.  Only the
matching lower bound `t_7(2,9)>=39` still uses the exact infeasibility
calculation.

The 15-line switch is **not** a disguised union of unital spreads: it contains
no spread.  Its structural object is instead the five-orbit `C_4` line class
with the displayed equitable incidence table.  That distinction matters for
generalization.  The later signed descent identifies its algebraic shadow:
the sign word is a second Hermitian unital minus one secant, and the original
unital is the tangent dual of that second unital.  This does not make the
15-line family a spread construction; it explains why the final degree vector
retains an exact Hermitian invariant.

#### What the mechanism says about a paper upgrade

This is now suitable as a self-contained finite proposition or appendix: it
has a coordinate-free outer mechanism (Hermitian unital, exterior point,
tangent deletion, cyclic secant switch), an explicit five-seed construction,
and a short incidence proof.  The signed factorization `z=1_{U'}-1_L` supplies
an even cleaner structural after-proof: the switch creates a second Hermitian
unital whose tangent dual is the original one, and the entire line-degree
spectrum follows from its tangent/secant partition plus the 19-point core.
It is not yet the construction theorem needed for `(UB3)`.  In a plane of
square order `Q=s^2`, the analogue of `T` has only
`s^3-s=Q^(3/2)-sqrt(Q)` lines, whereas the target arc has order `Q^2/3`.
Thus the tangent part becomes lower order and the five-orbit switch would have
to be replaced by a genuinely `Theta(Q^2)` secant class.  Moreover `q=27` is
nonsquare, so this Hermitian-unital mechanism does not even specialize to the
next field in the full characteristic-three tower.  The construction explains
the exact `q=9` equality; it is evidence for the constant but not a candidate
proof of the asymptotic upper bound.

The `ej` audit plus `tt` structural pass changes the preferred generalization
target.  The 19 degree-seven points `D` are precisely the duals of the maximal
secants of `A`.
They form a blocking set of size

```text
|D|=19=2q+1,       line spectrum 1^47 2^5 3^24 4^14 5^1.
```

Thus the small object that certifies completeness is `O(q)` even though the
primal arc is `Theta(q^2)`.  It is also emphatically not two-character.  The
negative two-character audit at `q=27` therefore misses the mechanism already
present at `q=9`; the higher-value next computation is to search for small
non-two-character dual blocking cores and feed them to the weak inverse
realization model.  Searching for a literal large unital tangent-plus-switch
family is lower priority.

### Mystery ledger (`ej` audit + `tt` structural pass)

- **Settled — is the 28-point fingerprint genuinely Hermitian?**  Yes.  The
  displayed nonsingular Hermitian matrix has exactly those 28 isotropic
  points, and their line spectrum is `1^28 4^63`.
- **Settled — is the 15-secant family two spreads plus a block?**  No.  It
  contains no unital spread.  Its actual certificate is the five-orbit `C_4`
  switch and its equitable incidence table.
- **Settled — why is the 39-point arc complete?**  The 19 degree-seven dual
  points form a blocking set; every unselected dual line meets it once or
  twice.  Completeness is not being inferred merely from the maximum line
  intersection.
- **Settled by `tt` — why does the Hermitian unital remain intrinsic after
  the switch?**  The signed word is exactly `1_{U'}-1_L` for a second
  nonsingular Hermitian unital `U'` and one of its secants.  The original
  unital is precisely the tangent-line dual of `U'`, so
  `supp((e-3 1) mod 3)` is its complement for a geometric reason, not merely
  as a 91-incidence fingerprint.
- **Settled — what intrinsic object underlies the signed `C_4` switch?**  A
  pair of Hermitian unitals meeting in four points, together with a secant of
  the second: `z=1_{U'}-1_L`.  The unital-minus-secant sign counts equal the
  required `(3q-3,q-3)` only at `q=9`, so this identifies the exact base
  mechanism and proves it cannot literally yield `(UB3)`.  Uniqueness of the
  five-orbit switch under the original stabilizer remains a separate finite
  classification question, no longer the asymptotic gate.
- **Settled — what is the field-uniform lift arithmetic suggested by `q=9`?**
  The corrected five-character template `(FC5)` gives an exact sufficient
  condition for `(UB3)`: take as primal points exactly the dual lines meeting
  the core at least three times.  No ad hoc secant trade is needed, and the
  local equality on core points follows automatically from the single global
  concurrency cap by averaging.
- **Settled structurally — does the `2q+1` five-character blocking core
  generalize?**  No for every ternary `q>=27`.  Its signed transform is forced
  into the line-code hull with weight `4q-6`; Szőnyi--Weiner covers that
  support by four lines, and the signed-transversal double count gives the
  incompatible bounds `2q^2-24q+54` and `21q`.  This uses no symmetry and
  supersedes the trace, scalar, Frobenius, and low-complexity hull searches.
  The alternative `T=2q` maximal-secant envelope remains open at `q=27`, but
  the exact-target theorem below excludes it for every `q>=81`.
- **Settled as an obsolete gate — classify the centered incidence codeword at
  `q=27`.**
  The exact shell has defect 126, at most 63 exceptional external points, and
  satisfies `M^T(e-9 1)=27(1+a)`.  Frobenius residues together with the local
  blocking-core cap `e<=13` still leave 50,261 degree histograms.  Thus the
  evidence gap is a spatial classification of the small-defect integer lift
  or a contradiction from its line sums.  The
  ternary affine space has dimension 184, drops to the 76-dimensional
  full-modulus-liftable subspace, and has dimension 70 after fixed-coordinate
  pinning.  Those congruences did not decide the branch, but the later
  four-line hull obstruction does; no closest-vector classification is now
  needed for `T=55`.
- **Settled after the signed descent — classify the weight-102 word.**  The
  secant-type vector `z=1+3a-d` lies in the ternary dual incidence code, has
  signs `(-1)^24 1^78`, and satisfies `Mz=3x` with `||x||^2=630`.  The two
  fixed branches leave only 32 and 31 supported nonfixed Frobenius orbits.
  The exact fixed-pencil projection leaves 2,573 and 1,975 centered vectors;
  in the general-four branch it also cuts the fixed defect ceiling from the
  ambient 126 to 66.  Neither branch can be a fixed-line dual lift plus at
  most two conjugate-line orbit sums, across all 729 fixed lifts per branch;
  all 17 fixed lifts of coefficient weight at most four also fail with three
  orbit sums.  More importantly, hull membership is automatic and the
  four-line structural obstruction excludes every such word, without
  Frobenius invariance or a Rust widening.
- **Settled asymptotically for the exact target; open at `q=27` — classify the
  residual `T=2q` envelope.**  At `q=27`, writing `d`
  for the number of 54 maximal secants through a point, its exact excess over
  the balanced degree shell is
  `sum_A binom(d-3,2)+sum_{outside} binom(d-1,2)=19`.  This defect-19 branch,
  not the dead five-character core, is the remaining first-field gate.  For
  all ternary `q>=81`, however, its residue codeword has norm at most `5q+1`,
  is an exact combination of four or five lines, and each coefficient pattern
  contradicts the arc cap or the integral sum/norm budget.
- **Settled — can an arbitrary exact target-size arc evade the inverse-core
  model?**  No for `q=3^h>=81`.  Completeness and the paired degree moments
  force exactly `T in {2q,2q+1}` maximal secants.  The exact small-codeword
  theorem and the shell defect then exclude both branches without assuming a
  threshold reconstruction, five line-intersection characters, Frobenius
  symmetry, or any other inverse model.  This rules out the exact central
  size; the next item supplies the uniform fixed-repair strengthening.  It is
  not a matching asymptotic upper bound.
- **Settled structurally — can a fixed additive size repair evade the exact
  obstruction?**  No.  For every fixed `delta`, the four possible
  maximal-secant offsets reduce to at most seven line-code generators.  Their
  coefficient sum and integral moment eliminate all but two all-positive
  patterns, and the arc cap eliminates those.  The uniform version excludes
  every relative repair `|delta|<=cq` for fixed `c<1/18`.  The later
  three-line shell inequality supersedes that margin: `t>=3` and
  `t<=1+6alpha+o(1)` force `alpha>=1/3`, proving `(LB3++)` with coefficient
  `5/3`.  Exact equality is also impossible.  Whether a nonzero `o(q)`
  positive repair can construct the matching upper side remains open.
- **Settled by the sharpness pass — can a `5/3+o(1)` construction hide in
  larger line-code support?**  No.  Integrality between `t>=3` and
  `t<=3+o(1)` forces exactly three generators.  The raw connector ledger has
  seven concurrent and four triangular rows; the two adjacent triangular
  rows are then excluded by `(SR9)--(SR10)`, leaving exactly `(SR11)`: seven
  concurrent sign/offset cores and two triangular cores.  Concurrent cores
  are equivalently two disjoint permutations satisfying the exact Rédei
  factorization ledger `(SR1a)--(SR1c)`; the triangular survivors have
  connector degrees `(3,3,3)` or `(4,4,3)`.  What remains open is existence
  and regular inverse realization of those cores, beginning with the constant
  repair `+1`.  The natural pair of shifted two-term linearized cubics is
  already excluded: unequal linear coefficients create at least `(q-3)/2`
  wrong directions, while equal coefficients leave only one finite special
  direction and one unavoidable graph intersection.
- **Compressed sharpness target — what exactly must a `+1` triangular
  construction do?**  In row `(4,-3)`, `(SR12)--(SR14)` force the core
  spectrum and the selector uniquely by line degree: take every three- and
  four-secant, exactly `q-3` bisecants, and one tangent.  These lines must be
  regular of degree `2q/3+1` on the `2q+4` core points and respect the same
  cap off the core.  The local zero-sum identity further forces `(SR16)`: the
  selected bisecants form a perfect matching on `2q-6` generic maximal
  secants, while nine vertex lines and one tangent line have fixed roles and
  every local `1/2/3/4` profile is prescribed by `(SR17)`.  The other
  `2q-5` generic-or-tangent lines form the almost-duplex `(SR18)` in the
  multiplicative Latin square, with singleton product constraint `(SR19)`.
  Completion to a full duplex is governed exactly by the three-by-three
  singleton transversal `(SR19c)`, not by the product constraint alone.
  Its three double-fiber colors form a `3`-edge-colored graph on `2q-5`
  vertices with only nine missing color incidences; the selector is a
  near-perfect matching, and maximality imposes the strict color caps
  `(SR19b)`.
  The canonical cyclic duplex given by two hyperbolas is excluded by
  `(SR21)`: it has quadratically many common external lines, far beyond the
  nine boundary points' rescue capacity.  More generally `(SR22)--(SR23)`
  force `H` to occupy at least `q-6` intercepts in each of `q-2` directions,
  with no fiber above four, and `(SR24)` fixes every full-core parallel-class
  profile.  In characteristic three these profiles force the carry-free
  moment triangle `(SR24b)--(SR24d)`, the Frobenius-quadratic normal forms
  `(SR24e)--(SR24g)` (only two independent by `(SR24n)`), the original-line
  root gate, generic/balanced derivative dichotomy, affine-split exclusion,
  exact shifted-fiber/moment constraint, semilinear normalization, and
  balanced ordinary-direction/norm rigidity and coupled diagonal product gate
  `(SR24m)--(SR24z)`,
  the coupled Prony/reversal obstruction
  `(SR24n)--(SR24p)`, and the weight-`3q`
  dual word and signed spectrum `(SR24k)--(SR24l')`.  The Vandermonde obstruction
  `(SR24h)--(SR24j)` eliminates every two-monomial completion
  and, more generally, forces at least `q/3-2` completed-fiber frequencies
  and trace degree at least `q-8` in each triangle chart; the leading
  coefficient is recurrence-sharp before the geometric gates are imposed.
  In the balanced survivor, simultaneous Frobenius normalization now forces
  the exceptional shear into the ordinary direction class, improves its
  level cap from five to four, and packages all three projections as one
  coupled quadratic three-norm system.  The missing datum is exactly the
  degree-`q/3` full-core four-fiber polynomial `G`: it occurs only as `G^3` and is
  therefore invisible to every characteristic-three power sum.  Consequently
  extending the moment/Hankel window is not a closeout strategy; the minimal
  open step is to rule out (or realize) that three-norm system using the
  transversal or the integral line geometry.  The length-two Witt lift
  `(SR24-Witt)--(SR24-WittK)` now supplies a field-uniform mechanism that
  recovers the missing Fourier spectrum one ternary digit higher.  Its first
  digit is a two-scalar semilinear form across slopes, its second digit reaches
  the top two coefficients of `A`, and the all-`k` carry formula reduces the
  independent spectrum from `q-2` to `2q/3-1` coordinates.  The integral
  ledger simultaneously makes at least `4q/3-3` of the four-fiber points high
  in all four special directions, producing a linear four-partite incidence
  system with only three defect incidences.  The independent `k=4` lift now
  collapses from its universal carrier polynomial to the top-four-coefficient
  gate `(SR24-Witt4''''')`.  The combined support product `(SR24-WittK)`
  packages the first, second, and fourth spectra as leading coefficients of
  `G product(H_m/J)`, leaving its third coefficient as the exact next blind
  spot.  Coupling this factorization to the four-partite incidence system and
  reciprocal norm is the new structural closeout target.  The stability audit
  `(SR24-grid-energy)--(SR24-grid-gcd'')` shows that saturation alone supplies
  only random-scale collision energy, so a generic BSG/Freiman step would be
  invalid.  It replaces that heuristic by an exact shifted-quartic-gcd sum of
  at least `6r-3`; proving this many coherent shifted common roots force the
  excluded affine-linearized case is one corrected inverse-theorem target.
  The full direction ledger is stronger: `(SR24a-global)--(SR24a-local')`
  makes the ordinary-line leave the union of three near-perfect matchings with
  only fifteen missing incidences, and forces the exact three-type local
  profile `(SR24a-local')` on every point.  Classifying this absolutely
  defective embedded `3/4`-block design compatibly with
  `(SR24-WittK)` is now the sharp global stability target.  The same local
  ledger proves `(SR24a-cubic-gap)`: every cubic misses at least `(q+1)/2`
  core points.  The offset-sensitive secant form then factors as
  `Lambda_B=L_2(L_3L_4^2)^3`; first derivatives see only the three-matching
  leave, while the third Hasse derivative is the first layer that recovers
  the rich-line cube root.  The complementary Rédei formulation separates
  the two relevant digits exactly: `(SR24-Redei)` is supported on the three
  boundary-hole columns, and `(SR24-Redei-Witt)` is supported on good-slope
  tangents with weight `gamma_m(P)(c-d_m)G_m(c)^3`.  Finally
  `(SR24a-quartic-gap)` proves that a degree-at-most-four carrier cannot exist
  for `q>=81`: the only reducible quartic survivor would be two conics, whose
  `O(q)` singleton lines contradict the ledger's `Theta(q^2)` count.  Thus the
  integer high digit compresses the entire issue further.  Its dual is an
  exact `(0,q/3,2q/3)` set avoiding a triangle, and its high secants form the
  reciprocal arrangement `(SR24a-higharrangement)`.  Dualizing once more
  gives the minimal blocking `(2q+4,4)`-arc `D=B_aff union R`, with exact
  global and local spectra `(SR24a-blocking4)--(SR24a-blocking4-local)`.
  The arrangement product has the canonical triangle-boundary form
  `(SR24a-arrangement-form)` and torus remainder
  `(SR24a-arrangement-torus)`.  The minimal closeout implication is therefore
  precisely `(SR24a-carrier-lemma)`: show that those order-four torus
  conditions force a quartic.  The contradiction after that implication is
  complete by `(SR24a-blocking4-gap)`.  The later red-team audit draws a hard
  method boundary: exactness of the local Koszul complex makes every finite
  torus-jet equation gauge-formal, so second, third, or higher pointwise jets
  cannot supply the missing invariant.  Likewise, branchwise cubing erases
  the first- and second-order conductor conditions at the quadruple nodes.
  Thus the quartic implication remains a desired lemma, not a consequence of
  the advertised jet synchronization; any proof must inject genuinely global
  offset, Hasse--Redei, or conductor data.
  The finite `q=27` carrier compiler is now executable as a 714-task
  high-incidence DFS, but no task has been exhausted.  The `ej`+`tt` pass did
  settle the right exceptional-coordinate cut.  On a rank-17 terminal write
  `(A,C)=(A_0,C_0)+lambda(A_1,C_1)`.  Splitting at row `x` is exactly

  ```text
  A_lambda(x)^2-C_lambda(x) in (F_27^*)^2.
  ```

  Thus each row gives a 27-bit allowed-`lambda` mask.  Their intersection
  replaces 27 root scans, and an empty intersection has an inclusion-minimal
  row certificate.  In the bounded first task/high-set probe, this cut leaves
  only a negligible terminal residue and produces a `17` carrier-equation plus
  one discriminant-row core; the run is still explicitly `Incomplete`.
  **Settled symbolically:** `(SR24z-Mobius)` proves over every odd `q>=5`
  that an empty row mask forces the two kernel-direction polynomials to share
  that row as a zero; `(SR24z-Mobius')` then combines it with the seven
  double rows and 19 singleton cells to exclude the entire `q=27` rank-17
  family.  `(SR24z-Mobius'')` proves that a completed profile cannot have a
  genuinely multirow-empty mask, and `(SR24z-Mobius''')` is stronger still:
  the residual linear-over-linear kernel ratio contradicts either the
  nine-value support or the fiber cap four, so every completed carrier has
  rank 18.  This is no longer finite table arithmetic.
  **Open mystery:** classify how the unique rank-18 carriers fail the mapping,
  two norm, or fourth-Witt gates and lift their at-most-18-cell finite cores
  to a fixed-degree field-symbolic identity.  Their connection to
  `(SR24a-carrier-lemma)` remains unproved.
  **Settled by red team — do the branchwise cube roots automatically glue?**
  No.  They glue exactly when `K` lies on a degree-`2q/3` plane curve.  At a
  quadruple point the four component roots must satisfy two common first-jet
  and one common second-jet relations; cubing in characteristic three loses
  all three.  If such a carrier existed, Bezout would be saturated and its
  intersection with the arrangement would be exactly `4K`, but neither the
  local spectrum nor Hilbert counting forces it, much less a quartic factor.
  The next valid computational test is the full conductor linear system, not
  a scalar cocycle.
  **Settled by `ej`+`tt` — is Mason's large-root family a nearby construction
  of the small root?**  It is the correct characteristic-divisible neighbor,
  but not a cheap switch.  Complementing after one zero side produces a
  small-size seed with two full `q`-secants.  The weighted-minihyper shift
  `(SR24a-Mason-trade)--(SR24a-Mason-any-gap)` proves that any target small
  root is separated from this seed by at least
  `2q/3-1+ceil((sqrt(q)-2)/3)` exchanges; if it retains the Mason triangle,
  the bound improves to `2q-1+ceil((sqrt(q)-2)/3)`.  This closes the direct
  six-point and minimal-trade mechanisms.  On the complementary blocking-set
  side, essential-secants strengthen this across all `(SR11)` signatures:
  any `eta=o(q)` Mason trade needs at least `2q-o(q)` additions,
  since a smaller trade leaves quadratically many orphaned Mason points but
  only constantly many old `2q/3`-secants can be converted to tight lines.  These
  are stability/separation theorems; they do not classify arbitrary small
  roots or minimal blocking sets.
  **Rejected shortcut — does the three-weight code lie close enough to the
  Griesmer bound to be rigid?**  The small root is exactly a projective
  `q`-ary `[q(q+2)/3,3,q^2/3]` code with nonzero weights
  `q^2/3,q(q+1)/3,q(q+2)/3`, and it exceeds the Griesmer bound by `q/3-1`.
  Residualizing at either nonfull weight merely produces a dimension-two
  projective code supported on an arbitrary `r`- or `2r`-subset of
  `PG(1,q)`.  Thus the standard Griesmer/residual recursion recovers the
  secant ledger but supplies no cross-line synchronization; it does not
  replace the carrier or essential-secant problem.
  The other triangular row requires a linear
  high-secant trade and
  is therefore a less rigid first target.
- **Settled by `ej`+`tt` — is the nearest classical four-blocking-set core a
  cheap source of the admissible rows?**  Bruen--Fisher is exactly the
  adjacent signed triangle `(j,sigma)=(0,1)`, and adjoining its horizontal
  infinity point gives the dead `(1,3)` row.  No local repair works: the
  difference of two three-line cores is a dual incidence-code word, whose
  elementary support bound is `q+2`; below that bound coordinatewise binary
  feasibility only flips the three distinguished points and yields sizes
  `2q-2` or `2q-1`, not `2q+4` or `2q+5`.  More strongly, its two exceptional
  points force `eta>=2q/3-7` if Bruen--Fisher is the exact saturated core;
  after adjoining the infinity point, three exceptional pencils force
  `eta>=q-11`.  Thus neither adjacent row can support any sublinear repair.
  The unexplained object is a global `Omega(q)` Radon trade that lands on one
  of `(SR11)` and admits the regular inverse selection.
- **Settled by the signed descent — what geometry does its support have?**
  Field-uniformly it is a signed untouchable set of size `4q-6`: it has no
  tangents, and every support 2-secant joins opposite signs.  At `q=9` its
  full support spectrum is `0^4 2^24 3^32 5^30 6^1`.
- **Settled at `q=9` — where do the six negative signs live?**  They are
  collinear, the 24 positives avoid their carrier, and the joint spectrum is
  `(0,0)^4 (0,6)^1 (1,1)^24 (3,0)^32 (4,1)^30`.  After moving the carrier to
  infinity, the positive set is a four-exceptional-direction Radon coset; with
  the four holes it is a second Hermitian unital `U'`, and exactly
  `z=1_{U'}-1_L`.  The original unital is the tangent dual of `U'`.  Its
  exact four-line correction audit has minimum dual weight 30, attained 160
  times among the 6,561 choices.
- **Settled for the Frobenius branches — does negative collinearity persist?**
  No.  In the 3-collinear+1-off branch the unique carrier is point 27, which
  is a core point and must have signed line sum three, contradicting the 24
  negative signs on that carrier.  The general-four branch has six fixed
  negatives, more than a fixed line can contain.  Thus any Frobenius solution
  must use a genuinely noncollinear negative 24-set.  For asymmetric cores the
  conditional carrier formulas remain valid and leave defect 54 or 70 at
  `q=27`; equivalently `u=z+1_L` is an exact `1 mod 3` multiset of total
  multiplicity `3q+1`, carrier multiplicity four or seven, and quotient defect
  `(M32)`.  Classifying or excluding that asymmetric modular coset is still
  open.
- **Open — can `t_7(2,9)>=39` be proved without exhaustive search?**  The
  positive construction is structural, but exclusion of a 38-point complete
  arc still trusts one normalized CP-SAT infeasibility certificate.  A second
  checker or a combinatorial contradiction for the forced 18-secant envelope
  remains absent.

### Closeout audit (`ej` + `tt`)

The hostile `ej` pass rederived the maximal-secant envelope from coverage,
Cauchy, and exact balanced pair minima; expanded all four `u` moments from the
design identity; checked the `q>27`, `h>2`, and weight hypotheses of
Szőnyi--Weiner Theorem 4.3; and separated “no arc at this size” from a
one-sided extremal bound before invoking C945.  It also restored the sharp
seven-hole count in the four-line lemma.  The tracked arithmetic replay checks
the exact branch table, the ten coefficient rows, their obsolete `1/18`
limiting margin, the transversal inequality, and the new exact three-line
endpoint ledger.  No bounded solver status is used in `(LB3++)`.

The refreshed `tt` pass is the two-inequality compression: the shell identity
forces three generator lines, while the signed norm correction and the cap on
positive generators force `t<=1+6alpha+o(1)`.  At equality, concurrency,
three connector equations, and two one-line cap contradictions exhaust every
three-line core.  This applies to arbitrary complete arcs in the linear band,
so it discharges the earlier five-intersection scope warning.

Interim verdict: **GO** for the structural theorem `(LB3++)`, but C949 remains
active under the user's sharpness continuation.  The endpoint coefficient
patterns are settled.  The principal unresolved mystery is a construction
with displacement `q/3+eta(q)`, where `1<=eta(q)=o(q)` (constant repair is
not excluded), or a further structural obstruction proving that `5/3` is
still not sharp.  The
finite arbitrary `q=27,T=54` branch and a structural replacement for the
`q=9` lower-bound certificate remain separate finite mysteries.

### Reproducibility

All commands below run from the repository root.  The construction and the
`q=27` audits use only Python's standard library and deterministic
canonical enumeration.

```bash
python3 notes/2026-08-24-c949-sharp-higher-arc-asymptotics.py \
  construct-q9-unital-arc \
  --output /tmp/c949-q9-unital-c4-construction.json
cmp /tmp/c949-q9-unital-c4-construction.json \
  notes/2026-08-24-c949-q9-unital-c4-construction.json

python3 notes/2026-08-24-c949-sharp-higher-arc-asymptotics.py \
  two-character-audit --q 27 --size-min 45 --size-max 70 \
  --output /tmp/c949-q27-two-character-audit.json
cmp /tmp/c949-q27-two-character-audit.json \
  notes/2026-08-24-c949-q27-two-character-audit.json

python3 notes/2026-08-24-c949-sharp-higher-arc-asymptotics.py \
  symmetry-orbit-audit --q 27 \
  --output /tmp/c949-q27-symmetry-orbits.json
cmp /tmp/c949-q27-symmetry-orbits.json \
  notes/2026-08-24-c949-q27-symmetry-orbits.json

python3 notes/2026-08-24-c949-sharp-higher-arc-asymptotics.py \
  frobenius-fixed-subplane-audit \
  --output /tmp/c949-q27-frobenius-fixed-subplane-audit.json
cmp /tmp/c949-q27-frobenius-fixed-subplane-audit.json \
  notes/2026-08-24-c949-q27-frobenius-fixed-subplane-audit.json

python3 notes/2026-08-24-c949-sharp-higher-arc-asymptotics.py \
  degree-defect-audit \
  --q9-construction notes/2026-08-24-c949-q9-unital-c4-construction.json \
  --frobenius-audit notes/2026-08-24-c949-q27-frobenius-fixed-subplane-audit.json \
  --output /tmp/c949-degree-defect-audit.json
cmp /tmp/c949-degree-defect-audit.json \
  notes/2026-08-24-c949-degree-defect-audit.json

python3 notes/2026-08-24-c949-sharp-higher-arc-asymptotics.py \
  frobenius-hull-mechanism-audit \
  --frobenius-audit notes/2026-08-24-c949-q27-frobenius-fixed-subplane-audit.json \
  --output /tmp/c949-q27-frobenius-hull-mechanism-audit.json
cmp /tmp/c949-q27-frobenius-hull-mechanism-audit.json \
  notes/2026-08-25-c949-q27-frobenius-hull-mechanism-audit.json

python3 notes/2026-08-24-c949-sharp-higher-arc-asymptotics.py \
  exact-target-obstruction-audit \
  --output /tmp/c949-exact-target-structural-arithmetic-audit.json
cmp /tmp/c949-exact-target-structural-arithmetic-audit.json \
  notes/2026-08-25-c949-exact-target-structural-arithmetic-audit.json

python3 notes/2026-08-24-c949-sharp-higher-arc-asymptotics.py \
  sharp-linear-coefficient-audit \
  --output /tmp/c949-sharp-linear-coefficient-audit.json
cmp /tmp/c949-sharp-linear-coefficient-audit.json \
  notes/2026-08-25-c949-sharp-linear-coefficient-audit.json
```

The corrected fixed-core lift replays the five-character mechanism at `q=9`
with the pinned solver version:

```bash
uv run --with ortools==9.14.6206 python3 \
  notes/2026-08-24-c949-sharp-higher-arc-asymptotics.py \
  five-character-core-lift \
  --core notes/2026-08-24-c949-q9-unital-c4-construction.json \
  --seconds 60 --workers 8 \
  --output /tmp/c949-q9-five-character-lift.json
cmp /tmp/c949-q9-five-character-lift.json \
  notes/2026-08-24-c949-q9-five-character-lift.json

uv run --with ortools==9.14.6206 python3 \
  notes/2026-08-24-c949-sharp-higher-arc-asymptotics.py \
  five-character-core-search --q 27 --symmetry trace-x \
  --seconds 300 --workers 4 \
  --output /tmp/c949-q27-five-core-trace-x-infeasible.json
cmp /tmp/c949-q27-five-core-trace-x-infeasible.json \
  notes/2026-08-24-c949-q27-five-core-trace-x-infeasible.json

uv run --with ortools==9.14.6206 python3 \
  notes/2026-08-24-c949-sharp-higher-arc-asymptotics.py \
  five-character-core-search --q 27 --symmetry scalar-13 \
  --seconds 300 --workers 4 \
  --output /tmp/c949-q27-five-core-scalar13-infeasible.json
cmp /tmp/c949-q27-five-core-scalar13-infeasible.json \
  notes/2026-08-24-c949-q27-five-core-scalar13-infeasible.json
```

The normalized lower-bound replay uses `ortools==9.14.6206` and trusts CP-SAT's
exact `INFEASIBLE` status:

```bash
uv run --with ortools==9.14.6206 python3 \
  notes/2026-08-24-c949-sharp-higher-arc-asymptotics.py \
  solve-cpsat --q 9 --t 3 --size 53 --seconds 600 --workers 8 \
  --output /tmp/c949-q9-size53-infeasible.json
cmp /tmp/c949-q9-size53-infeasible.json \
  notes/2026-08-24-c949-q9-size53-infeasible.json
```

The tracked manifest `notes/2026-08-24-c949-SHA256SUMS` records SHA-256 hashes
and byte counts for the generator and compact outputs.  The structural constructor independently
rebuilds `GF(9)`, the Hermitian zero locus, all projective incidences, the
cyclic line orbits, the degree tables, and the completeness cover.  Its trust
boundary is the short Python finite-field implementation and its explicit
assertions; no computer-algebra or second implementation is used.  The
`q=27` artifacts certify only the stated finite parameter/orbit audits.
The exact-target arithmetic artifact checks moment expansions, the envelope
at three fields, the bounded-repair coefficient table, and the corrected
four-line inequality.  It is explicitly not a nonexistence certificate: the
Szőnyi--Weiner input and the geometric line-cover contradictions are the human
proof above.

The former normalized Frobenius searches and unrestricted `q=27` core search
are not used as nonexistence certificates.  The structural hull/stability/
transversal proof now excludes the full five-character branch without a
symmetry assumption.  The later exact-representation argument addresses both
maximal-secant envelopes for arbitrary arcs, and its uniform linear-gap form
is the source of `(LB3+)`; the finite searches play no role in that theorem.

### Source depths for this audit

- Bishnoi--Mattheus--Schillewaert, *Minimal multiple blocking sets*:
  **full text**, inherited C945 read of all Sections 1--9, with Section 6 used
  here; cache key `arXiv:1703.07843`, SHA-256
  `4ca2ebf88bc90d94a88552092a9e69bcd0dcc9f234490994bfa4d5fa682694b9`.
- Calderbank--Kantor, *The Geometry of Two-Weight Codes*: **full text**,
  inherited C945 read of Sections 1--13, with Theorems 3.1--3.2 and the
  dimension-three examples used for the exact two-character dictionary;
  cache key `10.1112/blms/18.2.97`, SHA-256
  `986eeff4e7b4d259876242ee3659a627c28057abe5a087dcdd9e9bdb7181b05d`.
- Korchmaros--Nagy--Szonyi, *Algebraic approach to the completeness problem
  for `(k,n)`-arcs in planes over finite fields*: **partial**, arXiv v1
  introduction and statement of the Hermitian/BKS results read; cache key
  `arXiv:2302.10162`, SHA-256
  `32cfd5b1cb4f28c171418f61d467fc0accee8adc269ae9cf36a517158917b6b7`.
- Bastioni--Micheli, *On complete m-arcs*: **partial**, arXiv v1 introduction
  and Theorem 4.1 read; cache key `arXiv:2303.13670`, SHA-256
  `f5eb03dab26fb6ca1d9917db70d85409629174fc5ac279c59bbca1505517c40`.
- Ball--Blokhuis--Mazzocca, *Maximal arcs in Desarguesian planes of odd order
  do not exist*: **partial**, author-hosted prepublication PDF, abstract,
  introduction, proof setup, and final contradiction read; cache key
  `10.1007/BF01196129`, SHA-256
  `3d83c361902d15fa1c9be2f20111d290cb15485732618c48437379fb152e8fc6`.
- Innamorati, *Minimal Blocking Sets Arising from Joining Some of the Smallest
  Singer Orbits*: **partial**, version-of-record PDF, Sections 1, 2.2, the
  `PG(2,13)` triple-blocking example, and Section 7 read; cache key
  `10.3390/math14071137`, SHA-256
  `417190b17f1fdd152cad6bc02cfb167b8a18952e6cbdf2a4da8ccbb59890e5c9`.
- Adriaensen--Szőnyi--Weiner, *Multisets with few special directions and small
  weight codewords in Desarguesian planes*, *Designs, Codes and Cryptography*
  94 (2026), Article 35, DOI `10.1007/s10623-025-01777-8`;
  arXiv:2411.19201v3: **full text**,
  inherited C945 read of Sections 1--7 and revisited here at Definitions
  1.4--1.5, Theorems 1.7--1.9, and the line-code correspondence for the
  projection-function/mod-special-direction dictionary and the explicit
  zero-special-direction boundary; cache key `arXiv:2411.19201`, SHA-256
  `0fc810af52d3d70424f72c82878b69d55fa4abb285c344934dfac65587c86c19`.
- Szőnyi--Weiner, *Stability of `k mod p` multisets and small weight codewords
  of the code generated by the lines of `PG(2,q)`*: **partial**, introduction,
  Theorems 1.1, 4.2, 4.3, and their proofs read; Theorem 4.2 is the
  support-cover input to the four-line obstruction, while Theorem 4.3 gives
  the exact bounded-line representation in the arbitrary-extremizer theorem.
  Cache key
  `arXiv:1901.09649`, SHA-256
  `4161216751349d453fc8e8fbf40df6132de24f8e83581e85eeeb33ec936c046f`.
- Yoshinaga, *Free Arrangements over Finite Field*: **full text**, Sections
  1--3, Theorem 10, and Corollary 14 read from the arXiv manuscript; Theorem
  10(1) is used in `(SR24a-free)` after the reciprocal arrangement is shown to
  cover every projective `F_q`-point.  Cache key `arXiv:math/0606005`; web
  source only, with no local artifact hashed for this audit.
- Bruen--Fisher, *Blocking sets and complete `k`-arcs*: **partial**, Lemmas
  7--11 and Theorem 12 with its full proof read from the version-of-record
  PDF; `(SR2)`--`(SR4)` rederive its line spectrum and ternary residue
  factorization.  Cache key `10.2140/pjm.1974.53.73`, SHA-256
  `59527c2e89a60a57f2a24c28862fa9b930373260179e33800c54b5c3a8fe2cd5`.

## Purpose and boundary

C949 is the construction/extremal sequel to C945, not an enlargement of the
current arcs manuscript.  C945 owns the integer-envelope and modular-lift lower
bound.  C949 asks whether that obstruction is sharp for a canonical extremal
function.  Its two acceptable mathematical exits are a matching asymptotic
construction or a classification theorem that identifies the actual
extremal cores, proves their realizability or nonrealizability, and thereby
determines the correct asymptotic target.  A necessary bounded-repair
reduction alone is an input, not a successful exit.

The completed structural pass takes the obstruction exit in stronger form:
it excludes a linear-width band around the proposed target for arbitrary
complete arcs, not only the prescribed modular cores, and combines this with
C945 to prove `(LB3+)`.  It therefore decides that the proposed target is not
sharp.  It does not claim that `25/18` is the final coefficient; matching or
improving that new lower side is a distinct successor problem.

Nothing below is a novelty or attainability claim.  Literature statements and
any eventual priority verdict remain subject to
`literature-audit-conventions.md`; C945's recorded source depths and uncovered
databases are inherited as open gates, not converted into negative evidence.

## Canonical first target (now structurally refuted)

Avoid the collision between the standard subscript in `t_s(2,q)` and the
normalization `q/3` by writing

```text
q=3^h,                 s_q=2q/3+1,
T_3(q)=t_{s_q}(2,q).
```

C945 proves the lower bound

```text
T_3(q) >= q^2/3+4q/3-o(q).                            (LB3)
```

The first conjectural construction target, retained here to state what C949
tested, was

```text
T_3(q) <= q^2/3+4q/3+o(q),                            (UB3)
```

which would give

```text
T_3(q) = q^2/3+4q/3+o(q),       q=3^h -> infinity.   (ASY3)
```

This is a characteristic-three target.  It is not a nonsquare-field statement
unless the tower is explicitly restricted to odd `h`.

Equivalently, if `B` is the complement of a complete `(k,s_q)`-arc, then `B`
is a minimal `q/3`-fold blocking set: every line meets `B` at least `q/3`
times, and every point of `B` lies on a line meeting it exactly `q/3` times.
Thus minimizing `k` is the complementary problem of maximizing the size of
such a minimal multiple blocking set.  This complement `B` must be kept
distinct from the dual point set representing a chosen family of maximal
secants.

## Construction problem

The main bottleneck is construction, not a further repackaging of the lower
bound.  Near equality in C945 predicts a bounded edit of a modular or
two-character dual object.  The useful converse problem is deliberately weaker
than reconstructing the entire maximal-secant family:

> Give sufficient conditions on a line family `L` for the existence of a point
> set `A` such that every line of `L` is an `s_q`-secant of `A`, no line meets
> `A` more than `s_q` times, and `L` covers every point outside `A`.

Equality between `L` and the set of all maximal secants is unnecessary for an
upper bound and should not be imposed unless classification requires it.

The classification branch asks for more than the bounded-edit conclusion
already available from C945.  It must classify the exact modular cores that
can occur, determine which bounded repairs admit primal realization, and
show that every extremal or asymptotically extremal arc arises from the
resulting list (up to projective equivalence and the explicitly allowed
bounded edits).  If none realizes the coefficient in `(LB3)`, the first
nonrealizable core must yield the next obstruction and a revised lower-bound
coefficient.

The bounded construction programmes are:

1. **Perturbed modular/two-character cores.**  Start from a line or point
   multiset with the predicted congruence spectrum, make `O(1)` or `o(q)`
   edits, and test the weaker realization criterion above.
2. **Trace, additive-level, and field-reduction constructions.**  A single
   fixed-rank linear set usually has only `O(q)` points, whereas the target arc
   has order `q^2`; use complements, large unions, or level sets rather than
   treating one sparse linear set as the arc.
3. **Curve-derived constructions.**  Fixed-degree curves have the same density
   mismatch.  The plausible objects are complements, trace-defined sets, or
   reducible/high-degree families with controlled maximal secants.
4. **Valid extension towers.**  Do not lift from `F_{3^{h-1}}` to `F_{3^h}`:
   that subfield generally does not exist.  Recursive constructions must use
   exponent towers with divisibility, for example `h_i | h_{i+1}`, or maps
   defined directly over each `F_{3^h}`.

## First computational gate (completed historical route)

1. Audit known constructions at `s=2q/3+1`, translating each into both the
   complementary blocking-set and selected-secant languages.
2. For `q=9`, determine the exact feasible range but treat it as a noisy base
   case rather than asymptotic evidence.
3. For `q=27`, search only symmetry-constrained families—Singer/cyclic orbits,
   trace-invariant sets, subgroup-orbit unions, and modular-core candidates.
4. Search for a covering family of candidate maximal secants before demanding
   realization as the complete maximal-secant set.
5. Record whether examples approach the linear coefficient `4/3`, exceed it
   systematically, or show no stable pattern.

The original routing rule was to proceed toward `(ASY3)` only if a structured family had
`k=q^2/3+O(q)` and the correct maximum line intersection.  If computation
instead exposes a larger linear term, return the pattern to C945 as a candidate
new obstruction.  If neither occurs, retain C949 as a bounded negative
construction audit rather than an open-ended search.

The structural pass superseded this computational fork: it proves `(LB3+)`
for arbitrary complete arcs.  No bounded search is being promoted as the
reason for the stronger coefficient.

## Later targets, conditional on the first gate

A density-interval theory would write `s=alpha q+O(1)` and seek

```text
t_s(2,q)=f(alpha)q^2+g(alpha; p, tower, residues)q+o(q).
```

The first-order term cannot in general be indexed by `alpha` alone: C945's
mechanism depends on characteristic, the field tower, and congruence data.  A
piecewise arithmetic phase-transition theorem is deferred until one branch
has matching constructions.

The projective-code translation—to minimum length for robustly nonextendible
projective `[k,3,k-s]_q` codes—may broaden the eventual audience, but the
finite-geometry extremal function remains primary.

## Scope and stopping rule

- `(LB3)` belongs to C945; C949 owns the construction problem.
- **Optimum exit:** a matching `(UB3)` determines the two displayed
  asymptotic terms; ideally its construction theorem also describes all
  equality or near-equality families.
- **Classification exit:** classify the realizable exact modular cores and
  bounded repairs, prove exhaustiveness, and use that classification either
  to recover `(UB3)` or to derive the stronger obstruction and replacement
  asymptotic target.
- Merely proving that near equality is a bounded edit of some exact modular
  multiset does not finish C949.
- A density-interval theorem would extend the calculation from one parameter
  family to a nontrivial interval of `alpha`.

C949 meets its classification/obstruction exit through the linear-gap theorem:
the proposed `(UB3)` is impossible and the replacement certified lower side is
`(LB3+)`.  Sharpness of `25/18`, a matching construction, and any
density-interval theorem are successor tasks and must receive new routing;
they are not smuggled into this closeout.  C945's settled manuscript remains
unchanged and must not be delayed by those successors.
