# C945 — prescribed-hole defects for higher arcs

**Lane:** `relconic`

**Date:** 2026-08-22

**Status:** active theorem-development and literature-audit phase; the manuscript is
untouched pending a go/no-go gate.

**Literature-audit summary:** seven individually discussed sources; two read at
full text and five partially.  No novelty or priority verdict is closed.  The
Semantic Scholar forward-citation count, zbMATH search, MathSciNet coverage,
and full-text reads of the five partial sources remain open.  Accordingly, no
manuscript-bound “to our knowledge” sentence is licensed by this report.

## Objective

Determine the natural theorem level of the prescribed-hole defect method for
complete `(k,s)`-arcs.  Promote the extension only if it yields structural rigidity
or a sharper general bound, rather than merely a formally broader identity.

## Candidate intrinsic theorem

Let `A` be a `(k,s)`-arc in a projective plane of order `q`.  Let `E_s(A)` be
the linear `s`-uniform hypergraph on `A` whose edges are the intersections of
the `s`-secants with `A`, and let `nu` be its matching number.  Write `t` for
the number of `s`-secants, `d(a)` for the number through `a`, and `r(x)` for
the number through an external point `x`.  Then

```
S1 = t(q+1-s),
S2 = C(t,2) - sum_a C(d(a),2).
```

For prescribed holes `H`, covered required locus `X`, and
`I_H = sum_{h in H} r(h)`, the proposed defect is

```
Delta_H = S1 - 2 S2/nu - I_H/nu - |X|,

nu Delta_H
  = sum_{x in X} (r(x)-1)(nu-r(x))
    + sum_{h in H} r(h)(nu-r(h)).
```

The cap `r(x) <= nu` is sharper than the elementary
`r(x) <= floor(k/s)`: the concurrent `s`-secants give a matching in
`E_s(A)`.

Every disjoint pair of hyperedges meets at a unique external point.  Hence the
concurrence classes canonically decompose the disjointness graph of `E_s(A)`
into cliques.  At zero defect every nontrivial clique has order `nu`; covered
required points have index `1` or `nu`, and holes have index `0` or `nu`.
The existing edge- and vertex-deletion stability proofs appear to transfer with
`floor(k/2)` replaced by `nu`.

## Multiplicity extension

The natural two-moment statement allows a uniform required multiplicity
`lambda`, not only ordinary coverage.  Let every non-hole required point lie on
between `lambda` and `M` members of a line family, where `M` is a global index
cap.  With `R` the required locus, the exact identity is

```
(M+lambda-1)S1 - 2S2 - lambda I_H - lambda M |R|
  = sum_{x in R} (r(x)-lambda)(M-r(x))
    + sum_{h in H} r(h)(M-r(h)).
```

Indeed, the required-point summand expands to
`(M+lambda-1)r-2C(r,2)-lambda M`, and the hole summand results after
subtracting `lambda r`.  Both are nonnegative.  Equality permits required
indices only in `{lambda,M}` and hole indices only in `{0,M}`.  For
`lambda=1` this is the original prescribed-hole defect.

Applied to the `s`-secants of a `(k,s)`-arc with `M=floor(k/s)`, this
defines a `lambda`-fold maximal-secant covering problem.  The candidate
fixed-`s,lambda` asymptotic bound is

```
k >= sqrt(lambda s(s-1)q) + (s+1)/2 - O_{s,lambda}(q^(-1/2)).
```

The cancellation leaving the additive term independent of `lambda` is a
feature to verify carefully: the `(lambda-1)S1/M` gain and the second-moment
loss cancel at order `q^(3/2)` except for the same `s`-dependent residue as
at `lambda=1`.

### Coding interpretation

Represent the points of `A` by columns of a generator matrix.  This gives a
projective `[k,3,k-s]_q` code: a line meeting `A` in `s` points corresponds
to a minimum-weight codeword, with those `s` coordinates zero.  If a new
column representing `x` is appended, every `s`-secant through `x` supplies a
projectively distinct minimum-weight word that remains of weight `k-s` in the
extended code.  It therefore obstructs the prospective minimum-distance
increase from `k-s` to `k+1-s`.

Consequently, completeness says that every one-column projective extension
has such an obstruction, while `lambda`-fold maximal-secant coverage says
that every extension outside the prescribed holes has at least `lambda`
distinct minimum-weight witnesses.  The multiplicity theorem can thus be
stated as a robust nonextendibility defect identity for projective dimension-
three codes.  This is an interpretation of the same incidence count, not a
standalone novelty claim.  In particular, Bishnoi--Mattheus--Schillewaert
Theorem 8.1 already gives a spectral cardinality bound for a set having at
least `lambda` minimal secants through each point; the candidate contribution
here is the exact concurrency second moment, its equality defect, and the
parameter ranges where it improves their bound.

## Equality archetypes

The multiplicity theorem organizes several standard embedded designs by the
two roots of the same quadratic.

- A maximal arc of degree `s` has `k=(s-1)q+s`, line characters `0,s`,
  and every external point lies on `k/s=M` `s`-secants.  It is an upper-root
  equality family.
- A unital in a plane of order `q^2` has `k=q^3+1`, `s=q+1`, and line
  characters `1,s`.  Counting its points over the `q^2+1` lines through an
  external point gives exactly `q^2-q` `s`-secants.  Since
  `floor(k/s)=q^2-q+1`, it is a lower-root equality family for
  `lambda=q^2-q`.
- A Baer subplane of order `q` in a plane of order `q^2` has
  `k=q^2+q+1`, `s=q+1`, and line characters `1,s`.  The same pencil count
  gives exactly one `s`-secant through every external point, the lower-root
  equality family for `lambda=1`.

Thus the proposed theorem does more than repackage completeness: it places
ordinary complete arcs, maximal arcs, unitals, and subplanes in one
maximal-secant concurrency framework.  This is the current positive answer to
the structural/notability gate, subject to precedence checking.

## `tt` pressure test: the blocking-set dual

Let `B=Pi-A` and `t=q+1-s`.  Then `A` is a `(k,s)`-arc exactly when `B`
is a `t`-fold blocking set: an `s`-secant of `A` is a `t`-secant of `B`.
For `x in B`, lying on an `s`-secant of `A` is equivalent to lying on a
`t`-secant of `B`, which is equivalent to `x` being essential in `B`.
Consequently:

```
A is complete outside H
  iff every point of B-H is essential in the t-fold blocking set B
  iff the inessential locus of B is contained in H.
```

Uniform `lambda`-fold maximal-secant coverage says that every point outside
the prescribed hole lies on at least `lambda` tangent (`t`-secant) lines of
the multiple blocking set.  Thus the master identity is simultaneously a
defect theorem for higher arcs and for multiple blocking sets with a
prescribed inessential locus.  In particular, the conic-hole application has
a direct dual formulation that was absent from the initial higher-arc proposal.

Bishnoi--Mattheus--Schillewaert give the general upper bound

```
|B| <= q sqrt(4tq-(3t+1)(t-1))/2 + (t-1)q/2 + t
```

for a minimal `t`-fold blocking set.  With `t=q+1-s`, its complementary
lower bound is

```
k >= q(q+s-sqrt((q+s)^2-4s(s-1)))/2 + s.
```

For fixed `s` this is only `s^2+O_s(1/q)`, whereas the proposed
maximal-secant second moment gives
`sqrt(s(s-1)q)+(s+1)/2-O_s(q^(-1/2))`.  More generally, while `s=o(q)`,
the two scales are respectively `s^2` and `s sqrt(q)`, crossing at
`s` of order `sqrt(q)`.  The methods are complementary: the new moment bound
controls the low-degree side, and the spectral minimal-blocking-set bound
controls the high-degree side.  A combined all-degree phase diagram is a
candidate paper-level consequence.

More importantly, their Theorem 8.1 already treats the multiplicity parameter
that is dual to ours.  If a point set `B` in a plane of order `q` has at least
`lambda` lines through each of its points meeting `B` in exactly `t` points,
then `b=|B|` satisfies

```
lambda b^2
 - (2 lambda t(q+1) - (lambda+t)q)b
 - t(q-lambda t)(q^2+q+1) <= 0.
```

Taking `B=Pi-A` and `t=q+1-s` gives a second necessary lower bound on `k` for
`lambda`-fold maximal-secant coverage.  It is not dominated by the new moment
bound, nor does it dominate it.  On the reproducible 146-row grid for each
`lambda`, the moment threshold is stronger in 97, 86, and 73 rows for
`lambda=1,2,3`; the spectral threshold is stronger in 34, 52, and 59 rows;
and they tie in 15, 8, and 14 rows.  Thus the proposed hybrid is a genuine
pointwise maximum of two complementary bounds, not a repackaging of one
method.  The largest hybrid gains over the matching first-moment threshold on
this grid are respectively 11, 17, and 22.

This full-text correction narrows the claim sharply.  Robust tangent
multiplicity and a spectral quadratic are prior art.  The viable novelty
package is now: an exact two-moment defect with prescribed holes, hypergraph
concurrency rigidity, an additive low-degree improvement, and its explicit
hybridization with the existing spectral high-degree theorem.

## Paired-moment squeeze

There is a stronger scalar consequence than the one-sided defect envelope.
It uses the fact that the same pair count has degree-sequence descriptions on
both `A` and its complement `B=Pi-A`.

For feasible integers `n,L,U,R`, define

```
Phi_min(n,R) = (n-v)C(a,2) + v C(a+1,2),
  where R=an+v and 0<=v<n,

Phi_max(n,L,U,R)
  = n C(L,2) + L E + u C(U-L,2) + C(w,2),
  where E=R-nL=u(U-L)+w and 0<=w<U-L.
```

The evident constant-bound case `U=L` is interpreted separately.  Convexity
shows that these are respectively the minimum and maximum of
`sum_i C(z_i,2)` over integer degrees with sum `R` and bounds
`L<=z_i<=U`: balance minimizes, while filling to the upper bound maximizes.

Let `T` be the number of `s`-secants, put `b=q^2+q+1-k`,
`tau=q+1-s`, `D=floor((k-1)/(s-1))`, and take
`M=floor(k/s)` or any other certified external cap.  The internal degrees
satisfy

```
0 <= d(a) <= D,             sum_A d(a)=sT,
```

whereas `lambda`-fold coverage gives

```
lambda <= r(x) <= M,        sum_B r(x)=tau T.
```

Writing `I=sum_A C(d(a),2)` and `J=sum_B C(r(x),2)`, every pair of
`s`-secants meets either in `A` or in `B`, so `I+J=C(T,2)`.  Therefore a
necessary condition is the exact interval overlap

```
[Phi_min(b,tau T), Phi_max(b,lambda,M,tau T)]
  intersects
[C(T,2)-Phi_max(k,0,D,sT), C(T,2)-Phi_min(k,sT)].
```

This simultaneously retains both upper and lower pair-count constraints on
both sides of the complement.  The previous defect capacity uses only a
relaxation of one side of this overlap.  The new condition is still a
one-variable integer test in `T`, but it is arithmetically sharper and its
failure is a direct nonexistence certificate.

The intrinsic statement allows heterogeneous prescribed holes.  Give each
external point an integer interval `L_x<=r(x)<=U_x`, taking
`L_x=lambda` on required points and `L_x=0` on holes (and normally
`U_x=M`).  Replace the two external `Phi` terms by the minimum and maximum of
`sum_x C(r(x),2)` over these intervals with fixed sum `tau T`.  Separable
convexity computes both extrema by integer water filling.  The same interval-
overlap proof is unchanged.  The uniform no-hole formulas above are the closed
form used by the current numerical bundle; adding prescribed incidence
`I_H` gives a further affine sum constraint rather than a new argument.

The full maximal-secant family also satisfies an exact incidence-expansion
constraint.  Applying the projective-plane mixing inequality to the `b`
points of `B` and its `T` `tau`-secants gives

```
T [N tau-(q+1)b]^2 <= q b k (N-T),       N=q^2+q+1.
```

Thus a genuinely coupled spectral--moment theorem requires an integer `T`
satisfying the packing bounds, the paired interval overlap, and this spectral
inequality.  On the current grid the paired overlap alone already gives the
coupled threshold, so the spectral constraint adds no further row.  This is a
useful negative result: the new gain comes from restoring the discarded half
of the pair-moment data, not from mechanically intersecting two old scalar
bounds.

Against the earlier pointwise maximum of the defect and
Bishnoi--Mattheus--Schillewaert thresholds, the paired condition is strictly
stronger in 27, 23, and 26 of the 146 rows for `lambda=1,2,3`, respectively.
The maximum gains are two points for `lambda=1` and one point for
`lambda=2,3`.  These are necessary parameter bounds only; no existence claim
is inferred.

The other structural object exposed by the pressure test is the dual clique
partition on the `s`-secants.  On its `t_s` vertices, the internal star cliques
of sizes `d(a)` and the external concurrence cliques of sizes `r(x)` partition
all pairs.  At zero defect the external block sizes lie in `{lambda,M}`.
Divisibility, eigenvalue, and pairwise-balanced-design constraints on this
partition are the highest-EV route to arithmetic nonexistence and positive
defect gaps beyond the scalar bound.

Two formulation corrections follow.  First, the master theorem should allow
an arbitrary certified cap `M` on the external index.  The hypergraph matching
number is the sharpest intrinsic choice, while `floor(k/s)` gives a
parameter-only bound and may expose a more informative pair of equality roots.
Second, for `lambda>1` equality is not pure maximum-matching rigidity: required
concurrence cliques may have either size `lambda` or `M`.  The correct general
object is a two-size clique decomposition (with maximum-matching rigidity as
the `lambda=1` specialization).

## Proof packet

### Arrangement moments

Let `L` be `t` distinct lines of a projective plane of order `q`, let `B` be
a base point set, put `d(b)=#{ell in L:b in ell}`, and let `r(x)` count the
members of `L` through `x` outside `B`.  Then

```
sum_{x notin B} r(x) = t(q+1)-sum_{b in B}d(b),
sum_{x notin B} C(r(x),2) = C(t,2)-sum_{b in B}C(d(b),2).
```

The first equation counts line--point incidences.  For the second, each pair
of distinct lines has one intersection; it contributes on the right precisely
when that intersection is not in `B`.  This proves the two moments without an
arc hypothesis.  The `(k,s)`-arc specialization has
`sum_B d=st`, giving `S1=t(q+1-s)`.

### Two-root defect

Assume the outside points with positive index are partitioned into required
points `R`, with `lambda <= r <= M`, and holes `H`, with `0 <= r <= M`.
Expanding

```
(r-lambda)(M-r)
  = (M+lambda-1)r - 2C(r,2) - lambda M,
r(M-r) = (M+lambda-1)r - 2C(r,2) - lambda r
```

and summing proves the multiplicity identity.  Hence the identity and its
equality indices are closed at the elementary level.  For maximal secants of
a `(k,s)`-arc, concurrent secants have disjoint `s`-subsets of `A`, so any
cap `M >= nu(E_s(A))` is valid; choosing the matching number is intrinsic and
choosing `floor(k/s)` is parameter-only.

### Concurrency decomposition

Two maximal secants have disjoint hyperedges exactly when their unique
intersection lies outside `A`.  Therefore their disjointness-graph edge lies
in exactly one concurrence clique.  At zero defect these cliques have sizes
in `{lambda,M}` at required points and size `M` at holes (singletons and empty
classes omitted).  For `lambda=1` this recovers a decomposition entirely into
maximum-matching cliques.

### Degree envelope

Distinct maximal secants through `a in A` use disjoint `(s-1)`-subsets of
`A-{a}`, so `d(a)<=D=floor((k-1)/(s-1))`.  Also `sum_a d(a)=st`, and
linearity gives `t C(s,2)<=C(k,2)`.  Convexity of `C(d,2)` under the box and
sum constraints gives the stated integer envelope by filling degrees to `D`
one at a time.  This closes the exact one-variable coverage bound.

### Fixed-degree asymptotics

Fix `s`, `lambda`, and a hole family of size `O(q)`, and put `Q=sqrt(q)` and
`alpha=sqrt(lambda s(s-1))`.  The first-moment part reduces the only
nontrivial case to `k=alpha Q+beta` with bounded `beta`; if
`k-alpha Q` is unbounded above, the claimed additive lower bound is automatic.

Use the coarse bounds

```
P = k(k-1)/(s(s-1)),
M = floor(k/s),
C = 1+s(floor((k-1)/(s-1))-1).
```

For large `q`, the concave capacity function

```
f(t) = (M+lambda-1)t(q+1-s)/(lambda M)
       - t(t-C)/(lambda M)
```

is increasing on `C <= t <= P`: its first term has derivative of order `q`,
whereas `(2P-C)/(lambda M)` is only of order `sqrt(q)`.  Below `C` the
second-moment subtraction is zero and the capacity is increasing.  Hence the
universal capacity is at most `f(P)`.

With floors absorbed in bounded terms,

```
P = lambda Q^2 + lambda(2beta-1)Q/alpha + O(1),
M = alpha Q/s + O(1),
C = s alpha Q/(s-1) + O(1).
```

Substitution gives

```
f(P) = Q^4 + (2beta-s-1)Q^3/alpha + O_{s,lambda}(Q^2).
```

The required locus has `Q^4+O(Q^2)` points when the holes have size `O(q)`.
Therefore coverage forces

```
beta >= (s+1)/2 - O_{s,lambda}(1/Q),
```

which closes

```
k >= sqrt(lambda s(s-1)q) + (s+1)/2
     - O_{s,lambda}(q^(-1/2)).
```

## Exact parameter evidence

The deterministic bundle
`2026-08-22-c945-higher-arc-defect.{py,json,sha256}` evaluates the matching
first-moment threshold and the exact one-variable second-moment envelope for
`lambda=1,2,3`, no holes, the 22 listed values of `q`, and
`2 <= s <= min(8,q)`.  These are parameter inequalities; the output does not
assert existence of a projective plane or an arc for any row.

For each value of `lambda` there are 146 `(q,s)` rows.  The second-moment
threshold is strictly stronger in 126 rows at `lambda=1`, 89 rows at
`lambda=2`, and 77 rows at `lambda=3`; the respective maximum improvements
are five, four, and four.  At `(q,s,lambda)=(5,2,3)`, the exact envelope
excludes every `k` through the universal arc maximum, so the second-moment
threshold is recorded as absent rather than extrapolated past its geometric
range.  This isolated exclusion and the decreasing frequency of strict
improvement as `lambda` rises are numerical observations, not yet structural
theorems.

The v4 rows also evaluate the complementary quadratic from
Bishnoi--Mattheus--Schillewaert Theorem 8.1 and record the pointwise hybrid
threshold.  Against that spectral threshold, the new second moment wins in
97/86/73 rows, loses in 34/52/59, and ties in 15/8/14 for
`lambda=1/2/3`.  This comparison is exact integer arithmetic; no floating-point
root evaluation is used.

They additionally record the paired-moment and paired-plus-full-spectral
thresholds.  The paired threshold improves the earlier hybrid in 27/23/26
rows for `lambda=1/2/3`, with maximum gains 2/1/1.  The full-family spectral
constraint changes none of those paired thresholds on this grid.

For the eight small `(k,3)` comparison orders
`q=4,5,7,8,9,11,13,16` at `lambda=1`, the first/second thresholds are
respectively

```
7/7, 8/9, 9/9, 9/9, 9/11, 10/11, 11/12, 12/13.
```

The generator independently checks the original convex degree envelope by
dynamic programming in 5,386 bounded instances (`3 <= k <= 20`,
`2 <= s < min(6,k)`, all feasible degree sums), checks the lower/upper bounded
degree envelopes in another 1,368 instances, and checks 37 ordinary-arc
specializations against `3 C(k,4)` for `4 <= k <= 40`.

Replay from the repository root:

```
nix shell nixpkgs#python3 --command python3 notes/2026-08-22-c945-higher-arc-defect.py check
```

The generator is deterministic and uses only Python's standard library.
`generate` rewrites the canonical sorted JSON and checksum manifest; `check`
recomputes both in memory and fails on drift.  The script is 11,915 bytes with
SHA-256 `f54d7f2e7ba2accab01415ea83bb36d77760251ccb8790f11f000a6fb87627b4`;
the JSON is 148,720 bytes with SHA-256
`6cdbdb8637df1494a9e75bdb1e79d60ec5fae1c8e5326c2204b08124ce70ec9d`.

## Candidate new numerical consequence

Put

```
M = floor(k/s),
D = floor((k-1)/(s-1)),
T = floor(k(k-1)/(s(s-1))),
C = 1 + s(D-1),
L = q+1-s.
```

The `s`-secant hypergraph is linear, so `t <= T`; moreover
`d(a) <= D` and `sum_a d(a)=st`.  Consequently

```
2 S2 = t(t-1) - sum_a d(a)(d(a)-1)
     >= t max(0,t-C).
```

For a complete `(k,s)`-arc, or with `h` prescribed holes outside which all
points are covered, this would give

```
q^2+q+1-k-h
  <= max_{0 <= t <= T} [tL - t max(0,t-C)/M].
```

There is a sharper one-dimensional integer envelope.  For fixed `t`, maximize
`sum_a C(d(a),2)` subject to `0 <= d(a) <= D` and
`sum_a d(a)=st`: if `u=floor(st/D)` and `v=st-uD`, the convex maximum is
`u C(D,2)+C(v,2)`.  Thus one may replace the coarse lower bound on `S2` by

```
G(t) = C(t,2) - u C(D,2) - C(v,2),
```

and maximize `tL-2 max(0,G(t))/M` over the feasible integer range
`t <= min(floor(k(k-1)/(s(s-1))), floor(kD/s))`.  The coarse display is
retained because it exposes the asymptotics.

When the coarse objective is increasing through its feasible range, replacing
floors by safe real relaxations gives the clean necessary inequality

```
q^2+q+1-k-h
 <= k(k-1)(q+1-s)/(s(s-1))
    - (k-1)(k-s)(k-s^2+s-1)/(s(s-1)^2),
```

for `k >= s^2-s+1`.  The factorization follows from
`P-Cbar=(k-s)(k-s^2+s-1)/(s(s-1))`, where
`P=k(k-1)/(s(s-1))` and `Cbar=1+s(k-s)/(s-1)`.

For fixed `s` and `q -> infinity`, the candidate asymptotic consequence is

```
k >= sqrt(s(s-1)q) + (s+1)/2 - O_s(q^(-1/2)).
```

The classical first-moment argument has the same leading term but only the
additive threshold `1/2`; thus the second moment appears to improve the
additive term by `s/2`.  At `s=2`, the degree and pair-packing bounds are
equalities and this specializes to the paper's existing `3/2` term.

## Literature status

- Alabdullah--Hirschfeld, *A new lower bound for the smallest complete
  `(k,n)`-arc in `PG(2,q)`*, Designs, Codes and Cryptography (2019), DOI
  `10.1007/s10623-018-00592-8`: **full text**, published-version PDF obtained
  from the German National Library mirror and read from the shared cache,
  relying particularly on Theorem 2.1 and its proof; cache key
  `10.1007/s10623-018-00592-8`, SHA-256
  `b70116f426fb6ca1e733fafc4d2f6434993c55006ba900344b7bfa4abbd32961`.
  Their Theorem 2.1 combines completeness with the pair-packing upper bound
  on the number of `n`-secants.  It uses only the first external coverage
  moment; no second external concurrency moment or additive refinement appears.
- Bastioni--Micheli, *On complete m-arcs*, arXiv:2303.13670v1:
  **partial**, cached arXiv v1 PDF, abstract, introduction, and arc definitions
  read; cache key `arXiv:2303.13670`, SHA-256
  `f5eb03dab26f3cc701d9917db70d85409629174fc5ac279c59bbca1505517c40`.
  This establishes direct topical adjacency through constructions from curves,
  but has not yet been used for a novelty verdict.
- Korchmaros--Nagy--Szonyi, *Algebraic approach to the completeness problem
  for `(k,n)`-arcs in planes over finite fields*, arXiv:2302.10162v1 / later
  JCTA 204 (2024): **partial**, cached arXiv v1 PDF, abstract and introduction
  read; the version of record was not read for this audit; cache key
  `arXiv:2302.10162`, SHA-256
  `32cfd5b1cb4f28c171418f61d467fc0accee8adc269ae9cf36a517158917b6b7`.
  This confirms the maximal-secant coverage formulation and the relevance of
  prescribed uncovered loci.  No absence claim rests on this partial read.
- Bartoli--Davydov--Giulietti--Marcugini--Pambianco, *On upper bounds on the
  smallest size of a saturating set in a projective plane*, arXiv:1505.01426:
  **partial**, cached arXiv PDF, introduction and Definitions 1.1/1.5 through
  Theorem 1.6 read; cache key `arXiv:1505.01426`, SHA-256
  `e9040360a11f31d852dab3207a6db34fd31185ff244a72161cd36af3c039f55a`.
  Their `(1,mu)`-saturating multiplicity counts a secant line with weight
  `C(|S intersect ell|,2)`.  The proposed `lambda` extension instead counts
  distinct maximal `s`-secants of an arc.  The notions coincide for ordinary
  arcs (`s=2`) but not for higher arcs.
- Bartoli--Timpanella, *Complete `(k,q+1)`-arcs in
  `PG(2,F_{q^6})` from the Hermitian curve*, arXiv:2306.01134v1 / later
  Journal of Algebraic Combinatorics (2025): **partial**, cached arXiv v1 PDF,
  abstract, introduction, main theorem, and preliminaries through Theorem 2.1
  read; the version of record was not read for this audit; cache key
  `arXiv:2306.01134`, SHA-256
  `753783a0178b7cbb0012ae4488e51f08e49d780cd865a1c5ed760fc33560385e`.
  The paper proves completeness of a curve-derived higher arc by an algebraic
  variety point-count argument.  It confirms current topical adjacency but the
  sections read do not address universal lower bounds or external-index
  moments; no absence claim rests on this partial read.
- Ball, *Multiple blocking sets and arcs in finite planes*, Journal of the
  London Mathematical Society 54 (1996): **partial**, abstract, introduction,
  Theorems 1.1--1.4, and the complement formulation read from the cached
  author-hosted PDF; cache key
  `10.1112/jlms/54.3.581`, SHA-256
  `b0e5ee5e3bb2831fadc045ed1ecf9531730aa52084310542076a840fcbc14784`.
  This verifies the standard complement duality and concerns lower bounds for
  multiple blocking sets / upper bounds for arcs, not minimality or the small
  complete-arc regime.
- Bishnoi--Mattheus--Schillewaert, *Minimal multiple blocking sets*,
  arXiv:1703.07843v3 / Electronic Journal of Combinatorics 25(4) (2018):
  **full text**, all sections 1--9 of the cached 14-page arXiv v3 PDF read via
  its `pdftotext` extraction, relying particularly on Theorem 1.1, Sections
  3--5, and Theorem 8.1; cache key `arXiv:1703.07843`, SHA-256
  `4ca2ebf88bc90d94a88552092a9e69bcd0dcc9f234490994bfa4d5fa682694b9`.
  Their Theorem 1.1 bounds minimal `t`-fold blocking sets, and their Section 5
  supplies a variance proof.  Crucially, Theorem 8.1 already bounds sets with
  at least a prescribed number of `t`-secants through every point.  Its exact
  dual quadratic and the non-dominating numerical comparison are recorded in
  the `tt` section.  The paper does not formulate the external concurrence
  second moment, prescribed holes, or the hypergraph clique defect.

The audit currently has two full-text sources and five partial sources.  A
novelty or priority verdict remains open.

Forward-citation audit seed: pinned DOI
`10.1007/s10623-018-00592-8`.

- OpenAlex resolved the seed as `W2905644805` and reported 12 citing works.
  Recorded parameters: `filter=cites:W2905644805`, `per-page=20`.  The 12
  title/year/DOI metadata records were screened for work on a general
  higher-arc lower bound or maximal-secant concurrency moments.  Only
  Korchmaros--Nagy--Szonyi was promoted by that discriminator; its read depth
  is recorded above.  The other 11 titles concern particular planes/arcs,
  group actions, partitions, conics, or an unrelated typed point set and do
  not advertise a general bound.
- Crossref resolved the DOI and reported `is-referenced-by-count = 12`.
- Semantic Scholar's graph API returned HTTP 429 on 2026-08-22.  Its independent
  count and citing set are **not covered** yet; therefore the forward-citation
  negative is not closed.

The literal request strings used for the three API calls were not preserved in
the earlier trace.  Recording parameters after the fact is not a substitute
for the convention's verbatim-query requirement.  Therefore this
forward-citation pass is non-closing and must be rerun with the exact OpenAlex,
Crossref, and Semantic Scholar requests recorded before it can support a
negative.  An HTTP 429 is treated as an error, not as an empty Semantic Scholar
result.

## Coverage and verdict ownership

- **Not covered:** Semantic Scholar, because the graph API returned HTTP 429;
  zbMATH Open, because it has not yet been searched; and MathSciNet, because no
  authenticated access was available.  Google Scholar automated coverage was
  not attempted because it is normally blocked.  These gaps license no
  negative inference.
- The five sources marked `partial` require full-text promotion if a final
  novelty boundary depends on their silence.  Their present reads support only
  the positive topical and definitional attributions stated above.
- No higher-arc novelty sentence has been entered in the owning paper's
  claim--proof--novelty ledger.  The C945 formulations are therefore candidate
  positioning only and must not be copied into the manuscript, snapshot, or
  public summary as novelty claims.
- Surface check after the Theorem 8.1 precedence correction: the manuscript,
  existing proof/novelty audit, results snapshot, and public summary discuss
  the ordinary prescribed-hole theorem but do not repeat the new
  `lambda`-multiplicity claim.  They required no update.  This C945 report is
  the only changed surface; the manuscript remains untouched.

## Gates before manuscript work

1. Prove the intrinsic identity, clique decomposition, and stability statements
   with all edge cases (`nu=1`, holes, incomplete arcs, and uniform required
   multiplicity `lambda`) explicit.
2. Make the scalar optimization rigorous, including floors and the range in
   which its maximum occurs at `T`; prove an explicit asymptotic error term.
3. Compare the numerical bound with Alabdullah--Hirschfeld and other general
   complete `(k,s)`-arc bounds at full-text depth.
4. Audit whether the higher-secants second-moment inequality or its additive
   improvement is already known.  No novelty verdict is made yet.
5. Test structured curve-derived families where `t`, `d(a)`, or `nu` are known;
   this decides whether the intrinsic theorem has applications beyond the
   universal bound.
