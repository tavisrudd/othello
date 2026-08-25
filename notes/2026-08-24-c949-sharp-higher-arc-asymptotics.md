# C949 — sharp asymptotics for complete higher arcs

**Lane**: `relconic`

**Status:** active by explicit user override of the C945 sequencing gate; bounded
first-gate work only, with no manuscript work

## First-gate findings — 24 August 2026

The construction audit currently names six sources: two were read at **full
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
generalization.

#### What the mechanism says about a paper upgrade

This is now suitable as a self-contained finite proposition or appendix: it
has a coordinate-free outer mechanism (Hermitian unital, exterior point,
tangent deletion, cyclic secant switch), an explicit five-seed construction,
and a short incidence proof.  It is not yet the construction theorem needed
for `(UB3)`.  In a plane of square order `Q=s^2`, the analogue of `T` has only
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
  the switch?**  For the final arc degree vector `e`, the support of
  `(e-3 1) mod 3` is exactly the complement of the unital.  This is checked
  directly from all 91 incidences, not inferred from the construction labels.
- **Open — what intrinsic object is the `C_4` switch?**  The current evidence
  identifies its cyclic symmetry and incidence parameters but does not
  classify such switches or prove uniqueness under the stabilizer of `(U,P)`.
  This is owned by C949's structural-classification branch.
- **Settled — what is the field-uniform lift arithmetic suggested by `q=9`?**
  The corrected five-character template `(FC5)` gives an exact sufficient
  condition for `(UB3)`: take as primal points exactly the dual lines meeting
  the core at least three times.  No ad hoc secant trade is needed, and the
  local equality on core points follows automatically from the single global
  concurrency cap by averaging.
- **Open — does the `2q+1` five-character blocking core generalize?**  The
  correct `q=27` target is `1^461 2^17 3^78 4^194 5^7`.  Trace-`x/y`,
  trace-`x`, and scalar `C_13` invariance are excluded.  Frobenius invariance
  first reduces to ten aggregate fixed-subplane branches; the local degree-19
  congruence then leaves exactly two canonical four-fixed-point branches.
  Those two branches and asymmetric cores remain open.  The naive split by
  their two nonfixed 5-secant orbits still has 7,768 cases per branch and is
  not a useful terminal classification.  The alternative 54-maximal-secant
  envelope branch is also unclassified.
- **Open after `tt` — classify the centered incidence codeword at `q=27`.**
  The exact shell has defect 126, at most 63 exceptional external points, and
  satisfies `M^T(e-9 1)=27(1+a)`.  Frobenius residues together with the local
  blocking-core cap `e<=13` still leave 50,261 degree histograms.  Thus the
  evidence gap is a spatial classification of the small-defect integer lift
  or a contradiction from its line sums.  The
  ternary affine space has dimension 184, drops to the 76-dimensional
  full-modulus-liftable subspace, and has dimension 70 after fixed-coordinate
  pinning.  Both branches survive all these congruences; the additional gate
  is the norm-6075 lattice condition.  This supersedes the 7,768-way
  five-secant-pair split as the primary C949 route.
- **Open after the signed descent — classify the weight-102 word.**  The
  secant-type vector `z=1+3a-d` lies in the ternary dual incidence code, has
  signs `(-1)^24 1^78`, and satisfies `Mz=3x` with `||x||^2=630`.  The two
  fixed branches leave only 32 and 31 supported nonfixed Frobenius orbits.
  Recovering `d in {1,...,5}` from such a word, or excluding both sign cosets,
  is now the most compressed structural gate.
- **Open — can `t_7(2,9)>=39` be proved without exhaustive search?**  The
  positive construction is structural, but exclusion of a 38-point complete
  arc still trusts one normalized CP-SAT infeasibility certificate.  A second
  checker or a combinatorial contradiction for the forced 18-secant envelope
  remains absent.

### Reproducibility

All commands below run from the repository root.  The construction and the
four `q=27` audits use only Python's standard library and deterministic
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

The two normalized five-character Frobenius branches and the unrestricted
`q=27` core search are not completed; no unrestricted existence or
nonexistence conclusion is licensed.

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

## Purpose and boundary

C949 is the construction/extremal sequel to C945, not an enlargement of the
current arcs manuscript.  C945 owns the integer-envelope and modular-lift lower
bound.  C949 asks whether that obstruction is sharp for a canonical extremal
function.  Its two acceptable mathematical exits are a matching asymptotic
construction or a classification theorem that identifies the actual
extremal cores, proves their realizability or nonrealizability, and thereby
determines the correct asymptotic target.  A necessary bounded-repair
reduction alone is an input, not a successful exit.

Nothing below is a novelty or attainability claim.  Literature statements and
any eventual priority verdict remain subject to
`literature-audit-conventions.md`; C945's recorded source depths and uncovered
databases are inherited as open gates, not converted into negative evidence.

## Canonical first target

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

The first conjectural construction target is

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

## First computational gate

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

Proceed toward `(ASY3)` only if a structured family has
`k=q^2/3+O(q)` and the correct maximum line intersection.  If computation
instead exposes a larger linear term, return the pattern to C945 as a candidate
new obstruction.  If neither occurs, retain C949 as a bounded negative
construction audit rather than an open-ended search.

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

C945 has a settled theorem package and manuscript disposition.  C949 remains a
separate construction programme and must not delay the existing arcs paper's
review/release path.
