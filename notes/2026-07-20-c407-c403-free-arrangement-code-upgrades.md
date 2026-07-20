# C407 — six free arrangement-code upgrades

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** `COMPLETE; SIX CONVENTIONAL COROLLARIES PROVED AND CHECKED`

**Parent:** `notes/2026-07-20-c403-arrangement-complement-distance.md`

## Scope and notation

Let `A` be an essential arrangement of `N>0` projective lines in `PG(2,q)`.  Its
projective complement `B` is assumed to span the plane, `n=|B|`, and `D=D(A)` is the
projective `[n,3]_q` code whose columns are the points of `B`.  For a projective line
`L`, write

```text
s_L=|B cap L|,   f_s=#{L:s_L=s}.
```

If `A_w(D)` is the ordinary Hamming distribution, then

```text
f_s=A_(n-s)(D)/(q-1).
```

The statements below concern the complement-column matroid `M(B)`, except for the
scalar-extension theorem, which also uses C403's weighted 2-adjoint parallel-copy
matroid `M(B_A)`.  They do not make any invariant of the original arrangement matroid
`M(A)` determine the complement code.

## 1. Uniform scalar-extension enumerator

Let the arrangement equations and the indexed weighted-adjoint hyperplane list be
extended from `F_q` to `F_Q`, where `Q=q^e` and `e>=1`.  Denote the resulting
projective complement code by `D_Q`, put

```text
M=sum_X(m(X)-1),
```

and let `r_B` and `chibar_(B_A)(t,x)` be respectively the rank and coboundary
polynomial of the fixed indexed parallel-copy list.  Then, with `chi_A(t)` the fixed
characteristic polynomial,

```text
n_Q=chi_A(Q)/(Q-1),

P_(A,Q)(x)
  =(Q^(3-r_B) chibar_(B_A)(Q,x)-x^M)/(Q-1),

Z_(A,Q)(x)=P_(A,Q)(x)-N x^(N-1),

W_(D_Q)(z)
  =1+(Q-1)N z^n_Q
     +(Q-1) sum_delta [x^delta]Z_(A,Q)(x)
        z^(n_Q-Q-1+N-delta).
```

Consequently one characteristic polynomial and one weighted-adjoint coboundary
polynomial determine the complete Hamming enumerator over every finite scalar
extension of the fixed characteristic.

### Proof

Choose defining matrices over `F_q`.  The rank of every submatrix is the largest size
of a nonzero minor.  A minor belonging to `F_q` is nonzero over `F_q` exactly when it
is nonzero in `F_Q`; hence every subset rank, and therefore both represented
intersection lattices and `r_B`, are unchanged by scalar extension.  The finite-field
method applied over `F_Q` therefore gives the first displayed formula.

Because `B(F_q)` spans, it contains three projectively independent points.  Their
representatives remain independent and avoid every extended arrangement hyperplane,
so `B(F_Q)` still spans and `D_Q` still has dimension three.

For `v in F_Q^3`, let `h(v)` be the number of indexed weighted-adjoint hyperplanes
containing `v`, counted with their parallel-copy multiplicities.  Ardila's
finite-field coboundary identity for that same indexed list gives

```text
Q^(3-r_B) chibar_(B_A)(Q,x)=sum_(v in F_Q^3) x^h(v).
```

The zero vector has depth `M`.  Each nonzero projective point has exactly `Q-1`
representatives of the same depth.  Removing the zero term and projectivizing proves
the formula for `P_(A,Q)`.  Every one of the `N` original mirrors has weighted depth
`N-1`: on that mirror, `sum_X(m(X)-1)` counts each of the other mirrors exactly once.
Subtracting those indexed mirror points therefore gives `Z_(A,Q)`; this subtraction
does not assume that no other point has depth `N-1`.

For a nonmirror test line of depth `delta`, C403's incidence identity over `F_Q`
gives section size `Q+1-N+delta` and hence codeword weight
`n_Q-Q-1+N-delta`.  Every projective kernel line represents `Q-1` nonzero scalar
codewords.  The `N` mirror kernels have empty complement section and give the
full-weight term.  Summing the remaining depth classes proves the enumerator formula.

The quotient defining `P_(A,Q)` has integer coefficients for every actual
`Q=q^e`, because its coefficients count projective points after removal of the zero
vector.  No symbolic divisibility assertion by `t-1` is needed or claimed.

At `e=1` these four displays are exactly C403's base-field formulas.  For the three
C399 arrangements they give, uniformly in the fixed good characteristic,

| type | `N` | scalar-extension length `n_Q` | conic-phase base case |
|:---|---:|:---|:---|
| `A3` | 6 | `(Q-2)(Q-3)` | `q=5`, `n_q=6` |
| `B3` | 9 | `(Q-3)(Q-5)` | `q=7`, `n_q=8` |
| `H3` | 15 | `(Q-5)(Q-9)` | `q=11`, `n_q=12` |

The corresponding fixed weighted-adjoint coboundary polynomial supplies every
coefficient of each extension enumerator through the displayed specialization.  This
is scalar extension in one characteristic, not variation of an integral model across
good characteristics.  It also neither refines points by exact Frobenius degree nor
asserts the curve/zeta and exact-degree layer theorem of C389.

## 2. Complete generalized Hamming-weight hierarchy

Write `d=d_1(D)`.  Then

```text
d_1(D)=d,   d_2(D)=n-1,   d_3(D)=n.
```

Indeed, for a code represented by a spanning projective system, the projective-system
formula is

```text
d_r(D)=n-max_Pi |B cap Pi|,
```

where `Pi` ranges over projective subspaces of codimension `r`.  For `r=1` this
recovers the ordinary minimum distance.  For `r=2`, `Pi` is a point; the columns are
distinct projective points, so the maximum intersection is one.  For `r=3`, `Pi` is
empty.  This proves the three values.

Assume `n>3`, so `D^perp` has dimension `n-3`.  Wei duality says that

```text
{d_i(D):1<=i<=3}
```

and

```text
{n+1-d_j(D^perp):1<=j<=n-3}
```

partition `{1,...,n}`.  Removing `{d,n-1,n}` and reading the remaining integers in
decreasing order gives

```text
d_j(D^perp)=j+2,  1<=j<=n-d-2,
d_j(D^perp)=j+3,  n-d-1<=j<=n-3.
```

Either range may be empty.  The jump skips `n-d+1` in the dual hierarchy because its
Wei reflection is `d`; equivalently, the two integers absent from the descending
complement at the upper end reflect `n-1,n`.  At a conic/GRS phase `d=n-2`, the first
range is empty and `d_j(D^perp)=j+3` throughout.

This conclusion uses simple projective rank three.  A one-variable enumerator does not
in general recover higher generalized weights in larger rank, where higher-codimension
section data are required.

## 3. Circuits and minimal dual supports

The complement-column matroid `M(B)` is simple and has rank three.  Hence its circuits
have sizes three or four.  Their numbers are

```text
C_3=sum_s f_s binom(s,3),

C_4=binom(n,4)
    -sum_s f_s (binom(s,4)+binom(s,3)(n-s)).
```

Every collinear triple lies on a unique projective line, proving the first formula.  A
four-set is not a circuit precisely when it contains a dependent proper subset.  In a
simple rank-three projective system this means either all four points are collinear or
exactly three are collinear.  The first kind is counted by `sum_s f_s binom(s,4)`.
For the second kind, the unique line containing the dependent triple, the triple on
that line, and the fourth point off it give the count
`sum_s f_s binom(s,3)(n-s)`.  The two kinds are disjoint, and every remaining four-set
is a rank-three circuit, proving the second formula.

A circuit dependency is one-dimensional and has no zero coefficient; conversely a
minimal dual support is a circuit.  Thus each circuit supports one projective dual
word, and the numbers of nonzero minimal dual words of weights three and four are

```text
(q-1)C_3,   (q-1)C_4.
```

There is also an independent coefficient-level consistency identity:

```text
A_4(D^perp)/(q-1)
  =C_4+(q-3)sum_s f_s binom(s,4).
```

To prove it, classify a four-coordinate support.  A four-circuit contributes its
unique projective full-support dependency.  Four collinear columns have a
two-dimensional dependency code, the `[4,2,3]_q` MDS code, whose weight-four count is
`(q-1)(q-3)` and hence whose projective full-support count is `q-3`.  A four-set with
exactly one collinear triple has a unique dependency supported on that triple and no
full-support dependency.  All other four-sets are independent.  Summing these cases
proves the identity, which must agree with the weight-four MacWilliams coefficient.

At a conic phase no line contains three columns.  Therefore

```text
C_3=0,   C_4=binom(q+1,4),
```

as for the uniform matroid underlying an extended GRS code.  These are support counts;
the one-variable polynomial does not canonically identify or orbit-classify the
supports.

## 4. Full Tutte polynomial of the complement-column matroid

Put

```text
R_k=sum_s f_s binom(s,k).
```

Then the Hamming enumerator determines the entire Tutte polynomial of `M(B)`:

```text
T_(M(B))(x,y)
  =(x-1)^3+n(x-1)^2
   +sum_(k=2)^n R_k (x-1)(y-1)^(k-2)
   +sum_(k=3)^n (binom(n,k)-R_k)(y-1)^(k-3).
```

For the subset expansion of the Tutte polynomial, the empty set has rank zero and the
`n` singletons have rank one.  For `k>=2`, a rank-two `k`-subset is contained in a
unique projective line, and therefore there are exactly `R_k` such subsets.  Every
remaining subset of size at least three has rank three.  Their respective contributions
are

```text
(x-1)^(3-2)(y-1)^(k-2)
```

and

```text
(x-1)^(3-3)(y-1)^(k-3),
```

which proves the formula after adding the empty-set and singleton terms.

The two standard evaluations give direct checks:

```text
T(1,1)=binom(n,3)-C_3,

T(2,1)=1+n+binom(n,2)+binom(n,3)-C_3.
```

They count respectively the bases and all independent subsets.  Conversely, Greene's
theorem recovers the Hamming enumerator from the Tutte polynomial at the usual
code-dependent specialization.  Together with `f_s=A_(n-s)/(q-1)` and the displayed
rank-three formula, this proves an equivalence among the Hamming enumerator, the
line-section distribution, and `T_(M(B))` inside the category of spanning simple
rank-three projective systems.

This is the Tutte polynomial of the complement columns, not of the original
arrangement.  No analogous recovery claim is made for arbitrary rank or nonprojective
codes.

## 5. Covering radius, quasi-perfect duals, and coset leaders

Assume first that `PG(2,q)\B` is nonempty and `n>q+1`.  Fix an excluded point `P`.
The `q+1` projective lines through `P` partition the `n` points of `B`: every point of
`B` lies on exactly one such line.  By the pigeonhole principle one of those lines
contains at least two complement points.  Thus every excluded point lies on a secant
of `B`.

Regard the columns of `D` as a parity-check matrix for `D^perp`.  A nonzero syndrome
whose projective direction belongs to `B` has a weight-one leader.  A direction
outside `B` has no weight-one representative, but the secant property expresses it as
a linear combination of two distinct complement columns, with both coefficients
nonzero, and hence gives a weight-two leader.  Since an excluded direction exists,

```text
rho(D^perp)=2.
```

The boundary `n=q+1` for a nonsingular conic over odd `q` requires a separate
argument.  Through a point `P` outside the conic, let `a` and `b` be the numbers of
secants and tangents.  Counting incidences of the `q+1` conic points with the pencil
through `P` gives

```text
2a+b=q+1.
```

The tangent contact points whose tangents contain `P` lie on the polar line of `P`;
that line meets a nonsingular conic in at most two points, so `b<=2`.  Since odd
`q>=3` gives `q+1>=4`, it follows that `a>=1`.  Every point off the conic therefore
lies on a secant, and the same syndrome argument proves radius two at the conic phase.

In either case the exact coset-leader enumerator is

```text
1+(q-1)n z+(q-1)(q^2+q+1-n)z^2.
```

There is one zero syndrome.  Each of the `n` complement directions has `q-1`
nonzero scalar representatives and leader weight one; each of the remaining
`q^2+q+1-n` directions has `q-1` representatives and leader weight two.  As a check,
the sum of the coefficients is

```text
1+(q-1)(q^2+q+1)=q^3,
```

the number of syndromes.

The projective parity-check columns imply `d(D^perp)>=3`, while any four columns are
dependent in rank three, so (in these nontrivial cases) `d(D^perp)` is three or four.
At the nonsingular-conic boundary no three columns are collinear, so it is four.  In
either case the packing radius is one and the covering radius is two: these dual codes
are quasi-perfect.

For the C399 formulas, the large-complement inequality reduces to

```text
A3: (q-2)(q-3)>q+1  iff q>5,
B3: (q-3)(q-5)>q+1  iff q>7,
H3: (q-5)(q-9)>q+1  iff q>11
```

in the relevant positive ranges.  Thus every stable field above the respective conic
phase satisfies the criterion, and arrangement-mirror points provide excluded
directions.  The conic phases themselves use the separate polarity argument.  The
inequality is only sufficient: no classification of smaller saturating sets is
claimed, and the result supplies a two-column syndrome-search interface rather than a
new decoder.

## 6. Exact minimal primal codewords

Let `c_L` be a nonzero projective codeword whose kernel is the projective line `L`.
Then

```text
c_L is minimal if and only if s_L>=2.
```

Indeed,

```text
supp(c_M) properly contained in supp(c_L)
```

holds exactly when

```text
B cap M properly contains B cap L.
```

If `s_L>=2`, two points of `B cap L` determine `L`, so no distinct projective line
can contain that zero set and enlarge it.  Hence `c_L` is minimal.  If `s_L=1`, let
`P` be the unique zero column.  Since `B` spans, choose `Q in B` off `L`; the line
`PQ` strictly enlarges the zero set.  If `s_L=0`, any line through two complement
points (indeed, any line meeting `B`) has a nonempty zero set and again gives strict
support containment.  These cases prove the equivalence.

Each projective kernel line represents `q-1` nonzero scalar codewords.  Therefore

```text
# minimal nonzero codewords=(q-1)sum_(s>=2) f_s.
```

At a nonsingular-conic phase, the lines with at least two conic points are exactly the
secants.  Each pair determines one and no three conic points are collinear, so the
number of minimal nonzero primal words is

```text
(q-1)binom(q+1,2).
```

More generally, if every nonmirror has section size at least two, precisely the
nonmirror-kernel words are minimal and the mirror-kernel full-weight words are not.
This is only the standard minimal-codeword interface to secret sharing; no minimal
access structure is asserted without a distinguished coordinate and normalization.

## Attribution and claim boundary

The proof uses the conventional finite-field method and Ardila's indexed
parallel-copy coboundary identity already source-closed in C403.  No novelty or
priority claim is made for this scalar-extension packaging, generalized weights,
matroid formulas, covering terminology, or minimal-codeword consequences.

## Exact specialization checks

The checks below are written out algebraically rather than delegated to a new
generator.  The conic control is the q=11 nonsingular conic, with

```text
n=12, d=10, (f_0,f_1,f_2)=(55,12,66).
```

The nonconic control is C403's `A3_q11` fixture, with

```text
n=72, d=64, (f_0,f_6,f_7,f_8)=(6,64,24,39).
```

### q=11 conic

- The primal hierarchy is `(10,11,12)`.  The first Wei range is empty and the dual
  hierarchy is `4,5,...,12`.
- `C_3=0` and `C_4=binom(12,4)=495`.  Since no section has size four,
  `A_4(D^perp)/10=495`, hence `A_4(D^perp)=4,950`.
- `T(1,1)=binom(12,3)=220`; also
  `T(2,1)=1+12+binom(12,2)+binom(12,3)=299`.
- The coset-leader enumerator is `1+120z+1,210z^2`, whose coefficients sum to
  `1,331=11^3`.
- The `66` secants are exactly the lines with section size at least two, giving
  `10*66=660` minimal nonzero primal words.

### q=11 nonconic `A3`

- The primal hierarchy is `(64,71,72)`.  The dual hierarchy is `j+2` for
  `1<=j<=6` and `j+3` for `7<=j<=69`, namely `3,...,8,10,...,72`.
- The circuit counts are

  ```text
  C_3=64 binom(6,3)+24 binom(7,3)+39 binom(8,3)
     =1,280+840+2,184=4,304,

  C_4=binom(72,4)
      -64(binom(6,4)+binom(6,3)66)
      -24(binom(7,4)+binom(7,3)65)
      -39(binom(8,4)+binom(8,3)64)
     =1,028,790-283,386=745,404.
  ```

  Thus `(q-1)C_3=43,040`, exactly the committed direct dual-weight-three count.
  Moreover

  ```text
  sum_s f_s binom(s,4)=64(15)+24(35)+39(70)=4,530,

  C_4+8(4,530)=781,644=A_4(D^perp)/10,
  ```

  matching the committed MacWilliams value `A_4(D^perp)=7,816,440`.
- `T(1,1)=binom(72,3)-4,304=55,336`; also
  `T(2,1)=1+72+binom(72,2)+55,336=57,965`.
- The coset-leader enumerator is `1+720z+610z^2`, again summing to `1,331`.
- Exactly `64+24+39=127` lines have section size at least two, giving `1,270`
  minimal nonzero primal words.  The six zero-section lines are precisely the
  arrangement mirrors in this fixture.

These controls exercise both the conic/GRS empty-range boundary and a nonconic code
with collinear triples, four-circuits, and nontrivial four-collinear corrections.

## Evidence and trusted boundary

Run from `/home/tavis/src/othello`:

```bash
python3 -B notes/2026-07-20-c403-arrangement-complement-distance.py --check
sha256sum -c notes/2026-07-20-c403-arrangement-complement-distance.sha256
```

On completion both commands were green.  The inherited checker is `76,339` bytes with
SHA-256
`136b1c0782c38542ad90832aeb9acd3859174526949e086ff0f5be1f5fa4a1e1`; the inherited
JSON certificate is `234,075` bytes with SHA-256
`1bc47da2bf0f2f07b5e48d7b1242c8bd104b8a98a65174e1023b7119953f6f90`.

The trusted boundary for C407 is conventional finite projective geometry, the
finite-field coboundary identity already source-closed by C403, Wei duality, Greene's
theorem, elementary matroid subset counting, conic polarity, and exact integer
arithmetic in the displayed controls.  The C403 checker independently supplies the
q=11 line-section distributions and MacWilliams coefficients; C407 adds no generated
artifact and does not modify that evidence bundle.

## Hand-back

One fixed weighted-adjoint coboundary polynomial now yields every scalar-extension
Hamming enumerator.  In simple projective rank three, that same line-section profile
then yields the complete primal and dual generalized-weight hierarchies, every circuit
and minimal-dual-support count, the full complement-column Tutte polynomial, exact
radius-two coset-leader data under the stated saturating criteria, and every minimal
primal-codeword count.  None of these conclusions makes the original arrangement
Tutte polynomial determine the complement code, classifies arbitrary-rank higher
weights, supplies a new decoder or secret-sharing access structure, or enters C406's
matching-module gate.

C408 subsequently proves the exact boundary: this complete global package does not determine
coordinate repair/availability or excluded-syndrome representation multiplicities.  Its q=7
external-line-closure pair also shows that the weighted adjoint can distinguish the scalar-
extension towers even when the base package and original characteristic polynomial agree; see
`notes/2026-07-20-c408-pointed-profile-forgetting-gate.md`.
