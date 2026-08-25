# C949 — sharp asymptotics for complete higher arcs

**Lane**: `relconic`

**Status:** active on the user-requested sharpness continuation; the proposed
`4/3` linear coefficient is excluded and the structural lower coefficient is
now `5/3`; the exact `5/3` endpoint is also absent, while a matching
`5/3+o(1)` construction remains open; the sharpest `+1` triangular target is
reduced to the almost-duplex/near-Rédei conditions `(SR18)--(SR24)`; no
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

The distinction is real already over `F_81`.  For an element `zeta` of order
eight, take singleton sets with exponent sets

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

For comparison, the other triangular survivor `(j,sigma)=(5,-1)` has

```text
(N_1,N_2,N_3,N_4)
 =((2q^2-8q+3)/3, 2q-2, q, q(q+2)/3+2),
A_1=q/3-1+2eta-h-2H,
A_2=-q/3-1-eta+2h+3H.                               (SR25)
```

It therefore requires a linear trade among its high secants even when
`eta=1`; `(SR12)--(SR17)` is the sharper construction target.

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
  profile.  The other triangular row requires a linear high-secant trade and
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
  weight codewords in Desarguesian planes*, arXiv:2411.19201v3: **full text**,
  inherited C945 read of Sections 1--7 and revisited here at Definitions
  1.4--1.5 and Theorems 1.7--1.9 for the projection-function/mod-special-
  direction dictionary; cache key `arXiv:2411.19201`, SHA-256
  `0fc810af52d3d70424f72c82878b69d55fa4abb285c344934dfac65587c86c19`.
- Szőnyi--Weiner, *Stability of `k mod p` multisets and small weight codewords
  of the code generated by the lines of `PG(2,q)`*: **partial**, introduction,
  Theorems 1.1, 4.2, 4.3, and their proofs read; Theorem 4.2 is the
  support-cover input to the four-line obstruction, while Theorem 4.3 gives
  the exact bounded-line representation in the arbitrary-extremizer theorem.
  Cache key
  `arXiv:1901.09649`, SHA-256
  `4161216751349d453fc8e8fbf40df6132de24f8e83581e85eeeb33ec936c046f`.
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
