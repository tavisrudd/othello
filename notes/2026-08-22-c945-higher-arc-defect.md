# C945 — prescribed-hole defects for higher arcs

**Lane:** `relconic`

**Date:** 2026-08-22

**Status:** manuscript-entry gate green; final priority audit remains open and
both manuscripts are untouched.

**Literature-audit summary:** twenty-two individually discussed sources; fifteen
read at full text and seven partially.  The bounded full-text audit settles the main
classicality question but does not close a global novelty or priority verdict.
The degree-two moment/variance identity, its spectral form, the
arc--blocking-set dictionary, and the projective-code extension dictionary are
classical.  No direct predecessor for the *simultaneous exact integer degree
envelopes*, the unbounded families `(OF)`, `(UF)`, and `(CF)`, or the
maximal-secant modular-lift surcharge `(MLS)`/`(PF)` were located in the
recorded search,
but Semantic Scholar and MathSciNet coverage remain open; zbMATH coverage is a
recorded targeted search rather than an exhaustive subject classification.
Accordingly, no manuscript-bound “to our knowledge” sentence is licensed by
this report.

**Manuscript-entry verdict (2026-08-24): GO.**  The theorem/evidence packet is
solid enough to begin a separate C945 paper.  This licenses drafting, not a
final priority sentence or submission: the remaining database gaps and the six
partial reads stay visible in the claim--proof--novelty ledger.  The existing
conic manuscript remains untouched and on its independent C900 path.

## Objective

Determine the natural theorem level of the prescribed-hole defect method for
complete `(k,s)`-arcs.  Promote the extension only if it yields structural rigidity
or a sharper general bound, rather than merely a formally broader identity.

## Current strength and recommended theorem architecture

The raw higher-arc identity is now assessed at roughly the **50th--65th
percentile** as a standalone result: it is an elementary specialization of
classical incidence moments.  The higher-binomial generating identity is also
classical machinery and is not itself a headline theorem.  The present package
with the paired integer envelopes, exact recovery of spectral mixing as its
continuous relaxation, the modular correction, and the infinite strict-gain
families reached the **97th--98th percentile** among specialized finite-
geometry papers.  The new characteristic-three ordinary-completeness theorem
`(OF3)` raises the strongest latent paper provisionally to the **99th
percentile, with 99+ potential**: it feeds a
classical modular-repair theorem back through the maximal-secant cap to obtain
a further linear gain `2q/15` which neither ingredient gives separately.  That
grade is supported by a claim-specific modular-repair precedence audit through
24 August 2026, but remains conditional on polishing the report proof into
manuscript lemma form and on avoiding global priority language until the open
database coverage is closed.
The completed ordered-
factor-pair theorem now proves that every rational multiplicity resonance has
a positive linear gain and identifies a double-tight near-tactical sublocus;
this removes the main risk that `(OF)`, `(UF)`, and `(CF)` were isolated
arithmetic accidents.  The arbitrary-
dimensional code corollary raises audience and conceptual reach, but not the
percentile by itself.

The strongest honest architecture is therefore:

1. a general integer moment-envelope theorem for selected blocks in symmetric
   designs, with prescribed lower degrees, holes, and certified upper caps;
2. classical BIBD variance/expander mixing as the real-relaxation corollary,
   explicitly credited to Haemers and the later elementary formulation of
   Murphy--Petridis;
3. projective point--hyperplane systems and robust nonextendibility of
   projective codes as the general geometric application;
4. complete `(k,s)`-arcs and multiple blocking sets as the sharp planar
   specialization, where matching/pencil caps add information unavailable in
   an arbitrary design;
5. `(OF3)` as the primary separation theorem—ordinary completeness in
   characteristic three—and `(UF)`/`(PF)` as its multiple-coverage companions;
6. the complete ordered-factor-pair resonance theorem `(FP)`--`(LC)`, with
   classical spectral mixing as its strict continuous relaxation at every
   rational branch;
7. the integral-`h0` double-tight sublocus as the entry point for an inverse
   theorem or structural nonexistence result;
8. `(RMLS)` as the general modular-lift crown, with `(OF3)` and `(PF)` as the
   first unconditional zero-core exclusions.

This makes the classical result a corollary without pretending the elementary
moment expansion is new.  A higher (`j>=3`) moment should enter the headline
only after a concrete rank-distribution application is proved; at present it
is the correct umbrella and future direction, not yet the source of the main
numerical gain.  Likewise, the symmetric-design theorem is the organizing
theorem, not the safest priority claim: exact quotient equations and arithmetic
restrictions for tactical decompositions are classical.  The priority-bearing
unit is the non-tactical selected-family envelope together with `(OF)`, `(UF)`, `(CF)`, and the
prescribed-hole / robust-nonextendibility applications.

### Manuscript-entry theorem packet

The paper should package the present calculations in the following order.

1. **Exact integer-envelope theorem.**  For a selected block family in a
   symmetric design, prescribe the degree sums on the two point classes, lower
   degrees on the required class, and upper caps where geometry supplies them.
   The sum of the two balanced integer minima cannot exceed the fixed block-pair
   intersection count.  Its real relaxation is exactly the classical
   BIBD/expander-mixing inequality.
2. **Factor-pair resonance theorem.**  For fixed `lambda=uv`, `d=u+v+1`,
   `q=dn`, `s=(u+1)n+1`, every `lambda`-fold complete `(k,s)`-arc satisfies

   ```text
   k >= ud n^2+c_lat n-O_{u,v}(1),
   c_lat=min_{h in Z} max(C(h),L(h)),
   ```

   with `C,L` as in `(LC)`, and `c_lat>c_sp`.  Every rational resonance arises
   from one ordered factorization `lambda=uv`.
3. **Modular-lift dichotomy.**  Suppose additionally that `d` is a power of
   the characteristic and take the Desarguesian tower `q=p^H`, so eventually
   `n=q/d` is divisible by `p`.  Along any bounded-coefficient counterexample
   sequence, pass to a subsequence with fixed selected-line offset `h`.  Either
   the dual maximal-secant set is already an exact `lambda mod p` multiset, or

   ```text
   c >= C(h),
   c >= L(h)+r_min(h)/u,
   r_min(h)=2 if h congruent lambda (mod p), else 1.    (MD)
   ```

   This is the precise general statement: `(RMLS)` is a repair-or-exact-core
   dichotomy, not an unconditional bound until the zero-support core is
   excluded on the branch in question.  The correction is measured by its
   number of distinct support points; its nonzero modular multiplicities do not
   affect the generator-line count.
4. **Unconditional crowns.**  The `1 mod 3` degree envelope excludes the exact
   core on `(u,v)=(1,1)`, giving `(OF3)`.  The even-degree envelope excludes the
   exact core below coefficient `8` in the factor-pair normalization on
   `(u,v)=(2,1)`; parity of the nonempty repair support then gives `(PF)`.

This packet separates the universal theorem, its classical relaxation, the
conditional modular dichotomy, and the two unconditional geometric
applications.  It is the drafting spine; the higher-binomial hierarchy and
the C949 construction programme are not part of the first paper.

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
`floor(k/2)` replaced by `nu`, but that transfer is not part of the
manuscript-entry packet.  Version 1 should claim only the exact equality
indices and the integer smoothing defects proved below; a general deletion-
stability theorem requires its own proof before inclusion.

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
coupled threshold, so the spectral constraint adds no further row.  The
symmetric-design calculation below shows that this redundancy is exact: the
full-family spectral inequality is the real Cauchy relaxation of the paired
identity.  The new gain comes from its integer convex envelope and geometric
caps, not from mechanically intersecting two old scalar bounds.

Against the earlier pointwise maximum of the defect and
Bishnoi--Mattheus--Schillewaert thresholds, the paired condition is strictly
stronger in 27, 23, and 26 of the 146 rows for `lambda=1,2,3`, respectively.
The maximum gains are two points for `lambda=1` and one point for
`lambda=2,3`.  These are necessary parameter bounds only; no existence claim
is inferred.

## Higher binomial-moment master identity

Let `Omega=A union B` be any finite set and let `F` be any family of `T`
subsets of `Omega`.  Write `z_x` for the number of members of `F` containing
`x`.  Expanding pointwise gives the universal intersection enumerator

```
sum_{x in Omega} (1+u)^(z_x)
  = sum_{J subseteq F} |intersection J| u^|J|,
```

where the empty intersection is `Omega`.  Equating the coefficient of `u^j`
gives, for every `j>=1`,

```
sum_{x in A} C(z_x,j) + sum_{x in B} C(z_x,j)
  = sum_{J in C(F,j)} |intersection J|.                 (M_j)
```

Thus the pair identity is only the `j=2` member of a complete binomial-moment
hierarchy.  No geometry or design hypothesis is needed for `(M_j)`.

For each `j>=2`, the integer function `C(z,j)` is discretely convex.  Fixed
degree sums and lower/upper boxes therefore give computable minimum and
maximum values on each side of the partition: balancing minimizes, and
successive filling at the largest marginal increment maximizes.  Whenever the
right side of `(M_j)` is known or bounded, the two feasible moment intervals
must overlap after reflection about it.  Intersecting these conditions over
several `j` gives a hierarchy of integer nonexistence tests.

More generally, choose any polynomial `p(z)` that is nonnegative on the
allowed integer degrees and expand it in the binomial basis

```
p(z)=sum_j c_j C(z,j).
```

Summing `p(z_x)` and using `(M_j)` gives an exact defect or linear-programming
certificate.  The present two-root quadratic is the degree-two choice whose
zeros are `lambda` and `M`.  Higher-degree choices can force several permitted
concurrence indices, detect distance from a prescribed degree spectrum, or
combine information about triple and higher block intersections.  This is the
natural route beyond the paired second moment.

The generating identity itself is elementary inclusion expansion and should
be treated as classical machinery.  Any prospective contribution must lie in
the choice of incidence family, the sharp integer envelopes, or a new
geometric/code consequence—not in claiming the identity.

### Symmetric designs: the degree-two corollary

The paired squeeze is not intrinsically planar.  Let `D` be a symmetric
`2-(v,K,Lambda)` design, let its point set be partitioned as `A union B`, and
let `F` be a family of `T` blocks satisfying `|F intersect A|=s` for every
`F in F`.  If `d(a)` and `r(b)` are the numbers of selected blocks through
points of `A` and `B`, then

```
sum_A d=sT,                 sum_B r=(K-s)T,
sum_A C(d,2)+sum_B C(r,2)=Lambda C(T,2).
```

The last identity holds because every two blocks of a symmetric design meet
in exactly `Lambda` points.  Give the degrees on either side arbitrary integer
lower and upper bounds.  Let `[P_A^-,P_A^+]` and `[P_B^-,P_B^+]` be the
separable-convex extrema of their pair sums at the displayed degree totals.
Every realization necessarily satisfies

```
[P_B^-,P_B^+] intersects
[Lambda C(T,2)-P_A^+, Lambda C(T,2)-P_A^-].
```

The two-root defect itself also transfers verbatim.  Partition `B=R union H`,
assume `lambda<=r(x)<=M` on `R` and `0<=r(h)<=M` on `H`, and put
`I_H=sum_H r(h)`.  With

```
S1=(K-s)T,
S2=Lambda C(T,2)-sum_A C(d(a),2),
```

one has

```
(M+lambda-1)S1 - 2S2 - lambda I_H - lambda M|R|
 = sum_R (r-lambda)(M-r) + sum_H r(M-r).
```

Thus prescribed holes, equality roots, and integer stability are already
features of the symmetric-design theorem; planarity enters only when sharper
caps or geometric interpretations are required.

This degree-two corollary contains heterogeneous holes, multiple
coverage requirements, and nonuniform certified caps without changing the
proof.  The projective-plane theorem is the specialization
`(v,K,Lambda)=(q^2+q+1,q+1,1)`, where the geometry supplies the much sharper
matching and pencil caps.

The incidence graph gives a compatible general spectral constraint.  For the
point set `B` and block family `F`, substitute `i(B,F)=(K-s)T` into

```
|i(B,F)-K|B|T/v|
 <= sqrt(K-Lambda)
    sqrt(|B|T(1-|B|/v)(1-T/v)).
```

Thus the general feasibility certificate is an integer `T` satisfying the
degree totals, the paired interval overlap, any geometric packing bounds, and
this design-spectral inequality.

In fact the spectral inequality is already encoded in the real relaxation of
the pair identity.  Cauchy--Schwarz on both degree sequences gives

```
T [s^2/|A| + (K-s)^2/|B| - Lambda] <= K-Lambda.       (*)
```

Equality requires constant degrees on each side.  Conversely, expanding the
design mixing inequality above and using
`K(K-1)=Lambda(v-1)` gives exactly `(*)`.  Hence the paired-moment theorem is
an integer refinement of the full-family expander-mixing bound: replacing its
balanced integer minima by the real quantities `(sT)^2/|A|` and
`((K-s)T)^2/|B|` loses precisely the rounding information.

If every point of `B` has degree at least `lambda`, then
`T>=lambda|B|/(K-s)`.  Since the bracket in `(*)` is positive, eliminating
`T` yields the explicit design bound

```
lambda |B|/(K-s)
  [s^2/|A| + (K-s)^2/|B| - Lambda]
 <= K-Lambda.                                             (**)
```

For the projective plane, substitute `|A|=k`,
`|B|=q^2+q+1-k`, `K=q+1`, `Lambda=1`, and `K-s=q+1-s`.
After clearing denominators, `(**)` is exactly the quadratic in
Bishnoi--Mattheus--Schillewaert Theorem 8.1.  Their spectral predecessor is
therefore the continuous scalar shadow of the paired identity.  Retaining
integer degree extrema explains both why the new threshold never needs the
full-family spectral constraint and why it can be strictly stronger.

### Explicit modular sharpening

The integrality loss has a closed form.  If `R=an+v` with `0<=v<n`, then

```
Phi_min(n,R)
 = (R^2/n-R)/2 + v(n-v)/(2n).
```

For a plane, put `b=q^2+q+1-k`, `tau=q+1-s`,
`v_A=(sT mod k)`, and `v_B=(tau T mod b)`.  The lower-end paired condition is
equivalently the strengthened mixing inequality

```
T [s^2/k + tau^2/b - 1]
 + v_A(k-v_A)/(kT) + v_B(b-v_B)/(bT)
 <= q.                                                    (IM)
```

Dropping the two nonnegative modular terms gives classical expander mixing.
Both vanish exactly when the selected maximal secants have constant degrees
on `A` and on its complement.

There is a dual cap-filling correction.  For `n` degrees in `[L,U]` with sum
`R=nL+E`, put `C=U-L` and `w=(E mod C)` when `C>0`.  Then

```
Phi_max(n,L,U,R)
 = ((U+L-1)R-ULn)/2 - w(C-w)/2.
```

Thus the continuous two-root defect bound discards an explicit nonnegative
integer term `w(C-w)`.  Applying both remainder formulas on both sides gives
the exact paired interval test.  This identifies the sharpening mechanism:
spectral variance is the real relaxation, while modular imbalance supplies
the extra obstruction.

### An ordinary-completeness resonance family

The strongest current separation already occurs for ordinary completeness.
Let `q=3n`, `n>=3`, and set

```
s=2n+1=2q/3+1,             lambda=1.
```

The Bishnoi--Mattheus--Schillewaert spectral quadratic has integer threshold

```
k >= k0=3n^2+3n+1=q^2/3+q+1.
```

The paired integer moments give

```
k >= k0+ceil((3n-6)/5)
  = q^2/3+q+1+ceil((q-6)/5).                            (OF)
```

Thus even the usual one-secant completeness condition has an unbounded linear
integer-envelope gain, asymptotic to `q/5`, over the classical spectral
threshold.

Here is a floor-complete proof.  Write `k=k0+c`.  The cleared spectral
polynomial is

```
E(c)=c^2-(9n^2+n)c-2n^2.
```

Hence `E(-1)>0` and `E(0)<0`, proving the stated spectral integer threshold.
For `0<=c<ceil((3n-6)/5)<n`, the complementary size is
`b=6n^2-c`, and coverage forces `T>=ceil(b/n)=6n`.  Put

```
F(T)=Phi_min(k,(2n+1)T)+Phi_min(b,nT)-C(T,2).
```

Its forward difference is

```
sum_{i=0}^{2n} floor(((2n+1)T+i)/k)
 + sum_{i=0}^{n-1} floor((nT+i)/b) - T.                (D)
```

For `T=6n+u`, the first floors in `(D)` are at least `3` and the second
floors at least `1`, so `(D)>=n+3-u`; this handles `0<=u<=n+3`.
For `T>=7n+3`, use `floor(x)>=x-1`.  Since
`c<(3n-6)/5`, direct multiplication gives

```
7(2n+1)^2 > 9k,
```

while `b<=6n^2`.  Therefore

```
delta=(2n+1)^2/k+n^2/b-1 > 9/7+1/6-1=19/42,
```

and `(D)>=T delta-(3n+1)>0`.  Hence `F` is minimized at `T=6n`.
At that point the internal degrees are `3/4`, the external degrees are `1/2`,
and

```
F(6n)=3n-6-5c.
```

Feasibility requires `F(6n)<=0`, proving `(OF)`.  The Desarguesian planes of
orders `q=3^m`, `m>=2`, give an infinite ambient sequence.  As before, this is
a necessary bound and does not assert attainment.

### The characteristic-three ordinary-completeness crown

On the same Desarguesian tower, modular repair feeds back through the arc cap
and strengthens `(OF)` again.  The precise sequential statement is

```
liminf_{n=3^j -> infinity} (k-3n^2)/n >= 4,
k >= 3n^2+4n-o(n)
  = q^2/3+4q/3-o(q).                                  (OF3)
```

Here `k` is the size of any complete `(k,2n+1)`-arc in `PG(2,3n)`.  To see
the mechanism, write along a putative bounded-coefficient sequence

```
k=3n^2+C n+o(n),             T=6n+H+o(1).
```

The paired envelope and external coverage give

```
5C-H>=18,                    C+H>=3.                  (O1)
```

The dual selected-secant set has only `O(q)` lines whose intersection is not
`1 mod 3`, so Szőnyi--Weiner repairs it at `O(1)` support points to an exact
`1 mod 3` multiset.  Zero support is impossible in the relevant range.  If
all degrees were already `1 mod 3`, let `D` be the internal deficit below
degree four and `E` the external excess above degree one.  Then

```
D=(4C-2H-6)n+o(n),
E=(C+H-3)n+o(n),
unrestricted pair slack=(5C-H-18)n+o(n).
```

Restricting the internal degrees from adjacent `{3,4}` values to `{1,4}`
adds `D` to the pair minimum; restricting external `{1,2}` values to `{1,4}`
adds `E`.  Feasibility would therefore require

```
5C-H-18 >= D/n+E/n =5C-H-9+o(1),
```

an asymptotic contradiction.  Thus the modular correction is nonzero.

For this branch `u=v=1`,

```
L(H)=3-H,                 C_mom(H)=18/5+H/5.
```

The support-one surcharge `(MLS)` adds `1` to `L`.  Moreover an exact
`1 mod 3` multiset has total multiplicity `1 mod 3`, while `T congruent H
(mod 3)`.  Hence when `H congruent 1 (mod 3)` the correction cannot have
support one and the surcharge is at least `2`.  Consequently

```
C >= min_{H in Z} max(C_mom(H),L(H)+r_min(H))=4,
r_min(H)=2 if H congruent 1 (mod 3), else 1.           (O2)
```

The minimum is realized numerically at `H=0,1,2`; this is an envelope
statement, not an existence assertion.  Relative to `(OF)`, whose linear
coefficient is `18n/5`, `(OF3)` gains a further `2n/5=2q/15`.  Relative to
the classical spectral coefficient `q`, the total linear separation is
`q/3`.  Because this concerns ordinary completeness rather than prescribed
multiple coverage, `(OF3)` is the primary 99-plus application; `(PF)` below
is its characteristic-two, double-coverage companion.

The sequential quantifiers close directly.  If the liminf in `(OF3)` were
below `4`, choose `epsilon>0` and a subsequence with
`k<=3n^2+(4-epsilon)n`.  The leading paired quadratic has its unique feasible
contact at `T/n=6`, so `T=6n+o(n)`.  The first-order pair inequality then
forces `T-6n=O(1)` (an unbounded sublinear offset contributes the wrong-sign
term `-(T-6n)n`), and an integer subsequence has fixed offset `H`.  Its convex
defect is `O(n)`, so the number of non-`1 mod 3` lines is `O(n)` and the
Szőnyi--Weiner repair has fixed support.  The zero-support calculation and
`(O2)` then force `C>=4`, contradicting the chosen subsequence.  Thus `(OF3)`
is an epsilon-quantified theorem, not merely a formal coefficient comparison.

### A double-coverage unbounded family

Let `q=2n` with `n` divisible by `4` and `n>=8`; equivalently,
`q≡0 (mod 8)` and `q>=16`.  Set

```
s=n+1=q/2+1,             lambda=2.
```

For double maximal-secant coverage, the
Bishnoi--Mattheus--Schillewaert quadratic has the exact lower root

```
k >= s^2.
```

The integer paired moments give the strictly stronger necessary bound

```
k >= s^2+n/4-1 = (q/2+1)^2+q/8-1.                       (UF)
```

Here is the elementary calculation.  Write `k=s^2+c`.  The spectral bound
already excludes `c<0`.  For `0<=c<n/4`, the complementary size is
`b=3n^2-c`, and double coverage forces `T>=ceil(2b/n)=6n`.  A direct
discrete-slope comparison of

```
Phi_min(k,sT)+Phi_min(b,nT)-C(T,2)
```

shows that it is minimized over the feasible `T` at `T=6n`.  Explicitly, its
forward difference at an integer `T` is

```
sum_{i=0}^{n} floor(((n+1)T+i)/k)
 + sum_{i=0}^{n-1} floor((nT+i)/b) - T,
```

because `Phi_min(N,R+1)-Phi_min(N,R)=floor(R/N)`.  The monotonicity
claim has a short explicit proof.  Put `T=6n+u`.  Since

```
(n+1)T >= 5((n+1)^2+c),       nT >= 2(3n^2-c)
```

for `n>=8` and `0<=c<n/4`, the displayed forward difference is at least
`n+5-u`; hence it is nonnegative for `0<=u<=n+5`.  For
`T>=7n+5`, use `floor(x)>=x-1` to bound it below by

```
T delta-(2n+1),
delta=(n+1)^2/((n+1)^2+c)+n^2/(3n^2-c)-1
     >= 1/3-n/(4(n+1)^2).
```

Direct multiplication gives
`(7n+5)(1/3-n/(4(n+1)^2)) >= 2n+1` for `n>=8`: after
multiplication by `12(n+1)^2`, the difference is
`4n^3-5n^2+5n+8>0`.
Thus the forward difference is nonnegative for every feasible `T>=6n`, with
no unrecorded quotient case split.  At `T=6n` the internal
degrees are balanced between `5` and `6`, the external degrees between `2`
and `3`, and the difference is

```
Phi_min(k,6ns)+Phi_min(b,6n^2)-C(6n,2)
 = 3n-15-12c.
```

Feasibility requires this to be nonpositive, so

```
c >= ceil((n-5)/4)=n/4-1.
```

This proves `(UF)`.  The improvement over the classical spectral theorem is
linear in `q`, rather than a sporadic one-point rounding gain.  Desarguesian
planes of orders `q=2^m`, `m>=4`, supply an infinite sequence of ambient
planes to which the necessary bound applies; existence of arcs attaining the
new threshold is not asserted.

### The conjugate `3/4` resonance

The second root belonging to the same `lambda=2`, `a=6` resonance also gives
a uniform theorem.  Let `q=8m`, `m>=2`, and set

```
s=6m+1=3q/4+1,              lambda=2.
```

The classical spectral threshold is exactly

```
k >= 32m^2+ceil((52m+5)/5).                           (CS)
```

Indeed, on writing `k=32m^2+ell`, one half of the cleared spectral polynomial
is

```
P(ell)=ell^2-(40m^2+20m+2)ell
       +416m^3+132m^2+20m+1.
```

Substitution in the five classes `m mod 5` gives
`P(ceil((52m+5)/5)-1)>0>=P(ceil((52m+5)/5))`.

The paired integer envelope gives the following constant-sharp necessary
bound (sharp here means for this numerical envelope, not existence of an arc):

```
k >= 32m^2+12m-1,        2<=m<=6,
k >= 32m^2+12m,          7<=m<=12,                    (CF)
k >= 32m^2+12m+1,        m>=13.
```

To prove it, write `k=32m^2+ell` and assume the spectral bound but
`ell<=12m-2`.  Put `b=q^2+q+1-k`.  Double coverage gives
`T>=ceil(b/m)`.  There are two ranges at the minimum:

- if `ell<=11m`, then `T>=32m-2` and the balanced-pair excess at
  `T=32m-2` is at least
  `148m-16-12ell >=16m-16>0`;
- if `11m+1<=ell<=12m-2`, then `T>=32m-3` and the excess at
  `T=32m-3` is
  `146m-24-12ell >=2m>0`.

It remains to see that increasing `T` cannot remove the obstruction.  The
forward difference is

```
sum_{i=0}^{6m} floor(((6m+1)T+i)/k)
 + sum_{i=0}^{2m-1} floor((2mT+i)/b) - T.              (CD)
```

The two floor families are at least `5` and `2`, respectively, so `(CD)` is
nonnegative through `T=34m+5`.  Beyond that point, `floor(x)>=x-1` gives

```
(CD) >= T delta-(8m+1),
delta=(6m+1)^2/k+4m^2/b-1
     > 1/4-3/(64m).
```

The last expression is positive for `T>=34m+5` and `m>=3`; `m=2` is a direct
substitution.  This proves the first line of `(CF)`.  The two boundary cases
give a further exact sharpening.  At `ell=12m-1`, `T=32m-3` and the balanced-
pair excess is `2m-12`, so this value is excluded for `m>=7`.  At
`ell=12m`, the same `T` has excess `2m-24`, so it is excluded for `m>=13`.
The same forward-difference argument `(CD)` excludes every larger `T` in both
cases.  Direct evaluation of the next value gives a nonempty numerical
interval, proving that the three displayed thresholds are exact for the
paired envelope.  Comparing `(CF)` and `(CS)` gives a gain

```
12m+O(1)-ceil((52m+5)/5) = q/5+O(1).
```

Thus both conjugate `lambda=2` resonances have linear modular penalties, and
the `3/4` branch has the same asymptotic `q/5` gain as the ordinary-completeness
`2/3` branch.

### Why these slopes occur: the resonance equation

The two infinite families are instances of a finite arithmetic resonance
calculation.  Suppose, with `lambda` fixed,

```
s/q -> alpha,       k/q^2 -> beta,
```

coverage is asymptotically tight, and the limiting balanced internal degree is
an integer `a>lambda`.  Then

```
a = lambda alpha(1-beta)/((1-alpha)beta),
lambda(alpha-beta)^2 = beta(1-alpha),
```

where the second equation is equality in the continuous spectral bound.
Eliminating `beta`, and writing `d=a-lambda`, gives

```
d^2 alpha^2-d(d+1)alpha+a=0,
alpha=[d+1 +/- sqrt((d+1)^2-4a)]/(2d),
(d+1)^2-4a=(a-lambda-1)^2-4lambda.                    (R)
```

Thus rational resonant slopes occur exactly when the last discriminant is a
square.  Equivalently, they are controlled by factor pairs of `4lambda`, so
there are only finitely many primitive resonances at each multiplicity.  For
`lambda=1`, `a=4`, equation `(R)` has the double root `alpha=2/3`, producing
`(OF)`.  For `lambda=2`, `a=6`, it has roots `alpha=1/2` and `3/4`; `(UF)` is
the first branch, while the observed high-degree gains near `s/q=3/4` are the
second branch.

This explains the numerical phase diagram conceptually: away from a resonance,
the real spectral slack usually absorbs rounding, while at a resonance the
continuous bound is tangent to an integral degree pattern and the first finite-
size mismatch produces a linear modular obstruction.  The next high-EV theorem
is a classification of all factor-pair resonances and their first-order gains,
not another undirected parameter sweep.

### Complete factor-pair resonance theorem

The classification and its first-order gain can in fact be completed for every
fixed multiplicity.  Write an ordered factorization

```
lambda=uv,                 u,v>=1,
d=u+v+1,
```

and take the resonant parameters

```
q=dn,                      s=(u+1)n+1,
k=ud n^2+c n+O(1).                                      (FP)
```

Then

```
alpha=(u+1)/d,             beta=u/d,
a=(u+1)(v+1)
```

solve `(R)`, and every rational solution of `(R)` arises from exactly such an
ordered factorization.  Indeed the earlier same-parity factor pair `UV=4lambda`
must have `U=2u`, `V=2v`; conversely these substitutions give the displayed
`alpha`, `beta`, and integral balanced internal degree `a`.  Thus the resonant
phase diagram at multiplicity `lambda` has one ordered branch for each divisor
of `lambda`, with conjugation interchanging `u` and `v`.

Define the classical spectral first-order coefficient

```
c_sp = u(uv+3u+2v+3)/(2u+1),
```

and the continuous paired-envelope coefficient

```
c_env = u(uv^2+4uv+2u+2v^2+4v+1)/(2uv+u+v).
```

Their difference factors as

```
c_env-c_sp
 = u(v+1)(u^2+u+1)/((2u+1)(2uv+u+v)) > 0.             (G)
```

Consequently, for every ordered factorization `lambda=uv`, the paired integer
moments improve the classical spectral theorem by a positive linear amount:

```
k >= ud n^2+c_env n-O_{u,v}(1),                         (FG)
```

whereas the spectral quadratic alone has first-order threshold

```
k >= ud n^2+c_sp n-O_{u,v}(1).
```

The lattice correction admits an exact finite minimization.  Put

```
h0 = -u(v+1)(u^2v+u^2-v)/(2uv+u+v),
mu = 2v/((u+v)(2uv+u+v+1)),
L(h)=d-h/u,
C(h)=c_env+mu(h-h0).
```

Then the sharp coefficient supplied by this first-order paired-envelope
argument is

```
c_lat = min_{h in Z} max(L(h),C(h))
      = min_{h in {floor(h0),ceil(h0)}} max(L(h),C(h)).  (LC)
```

In particular `c_lat>=c_env`, so `(G)` is a uniform certified gain; the
integer position of `h0` can only strengthen it.  The three earlier theorems
are precisely

```
(u,v)=(1,1): c_lat=18/5,     (OF),
(u,v)=(1,2): c_lat=9/2,      (UF),
(u,v)=(2,1): c_lat=6,        (CF).
```

Here is the proof of the new assertion.  Let `T` be the number of maximal
secants, `b=q^2+q+1-k`, and

```
F(T)=Phi_min(k,sT)+Phi_min(b,(q+1-s)T)-C(T,2).
```

Pair feasibility requires `F(T)<=0`, while coverage gives

```
T >= ceil(lambda b/(q+1-s))
  = ud(v+1)n+ceil(u(d-c)+O(1/n)).                       (P)
```

For bounded `c` at or above the spectral threshold, the balanced internal
degree is approached from below.  The exact forward difference of `F` is

```
sum_{i=0}^{s-1} floor((sT+i)/k)
 +sum_{i=0}^{vn-1} floor((vnT+i)/b)-T.
```

From the minimum in `(P)` through an interval of length `vn+O(1)`, the two
floor families are at least `a-1` and `lambda`, so the difference is at least
`vn-(T-T_min)+O(1)`.  Beyond that interval use `floor(x)>=x-1` and

```
s^2/k+(vn)^2/b-1 = 1/(u(v+1))+O(1/n).
```

At `T=T_min+vn+O(1)` this gives a positive linear margin
`v n/(u(v+1))+O(1)`.  Hence `F` is minimized at `T_min`, up to a bounded
endpoint ambiguity which does not affect the first-order coefficient.

Pass to a subsequence on which

```
T_min=ud(v+1)n+h
```

with fixed integer `h`.  Coverage gives `c>=L(h)+o(1)`.  Since the internal
degrees balance between `a-1` and `a`, while the external degrees balance
between `lambda` and `lambda+1`, direct expansion gives

```
F(T_min)/n
 = ((u+v)(2uv+u+v+1)/2)(C(h)-c)+o(1).
```

Thus feasibility also gives `c>=C(h)+o(1)`.  Minimizing the maximum of these
two affine functions proves `(LC)`; they are respectively decreasing and
increasing in `h`, so only the two integers adjacent to their crossing `h0`
can minimize.  Expanding the Bishnoi--Mattheus--Schillewaert quadratic gives
`c_sp`, and subtraction yields the positive factorization `(G)`.

This theorem changes the status of `(OF)`, `(UF)`, and `(CF)`: they are not
three favorable congruence accidents but the first exact members of a divisor-
indexed family in which *every rational resonance has an unbounded linear
integer-envelope penalty*.  It also makes the classical spectral theorem a
literal corollary/relaxation at every branch, rather than merely at the three
initial examples.

There is a rigidity sublocus inside the resonance classification.  If `h0` is
integral, then `L(h0)=C(h0)=c_env`: coverage and the pair envelope become tight
simultaneously.  Any hypothetical sequence with
`k=udn^2+c_env n+o(n)` must have `T=ud(v+1)n+h0+o(n)`; all but `O(n)` internal
points have maximal-secant degree `a`, all but `o(n)` external points have
degree `lambda`, and the total smoothing defect from the two balanced degree
sequences is `o(n)`.  Thus exact double tightness forces an asymptotically
tactical incidence structure outside a codimension-one exceptional locus.
The branch `(u,v)=(2,1)` underlying `(CF)` has `h0=-4` and is the first such
case.  Classifying or excluding these near-tactical structures is now the
highest-value route from the general bound to a genuine extremal-geometry
crown.

The arithmetic classification of that sublocus is elementary and complete.
Set

```
m=2uv+u+v.
```

Polynomial division in `v`, followed by multiplication by `(2u+1)^2`, gives

```
(2u+1)^2 u(v+1)(u^2v+u^2-v)
  = m Q(u,v)+u^2(u+1)(u^2+u+1)
```

for an integer polynomial `Q`.  Since
`gcd(m,2u+1)=gcd(u,2u+1)=1`, one obtains

```
h0 is integral
 iff m divides u^2(u+1)(u^2+u+1).                       (DT)
```

Equivalently, for each fixed `u`, the double-tight branches are parametrized
exactly by divisors `m` of the integer on the right satisfying

```
m>u,                       m congruent to u mod (2u+1),
v=(m-u)/(2u+1).
```

This both makes the sublocus effectively enumerable and exposes an infinite
self-conjugate family.  Taking `v=u` gives

```
h0=-u(u^2+u-1)/2,
```

which is integral for every even `u`.  Hence every square multiplicity
`lambda=u^2` with even `u` has a self-conjugate, double-tight resonant branch

```
alpha=(u+1)/(2u+1),        beta=u/(2u+1),
a=(u+1)^2.
```

The remaining problem is geometric rather than Diophantine: decide whether
the forced near-tactical incidence structures on this infinite family can
exist in projective planes, and, if so, construct them.  This is substantially
narrower than the earlier undirected equality-classification gate.

There is a sharper dual formulation of that inverse problem.  Regard the `T`
selected maximal secants as a point set `L` in the dual plane.  The number of
points of `L` on the dual line corresponding to `x` is exactly the old degree
`z_x`.  Therefore a double-tight threshold sequence produces a set of only
`O(q)` points for which all but `O(q)` of the `q^2+q+1` lines have one of the
two intersection numbers

```
lambda=uv,                 a=(u+1)(v+1),
a-lambda=d=u+v+1.                                      (NTC)
```

Equivalently, the dimension-three projective code generated by `L` has all
but `O(q)` projective codewords in two nonzero weights.  Exact zero exception
would be a classical two-character set / projective two-weight code in the
sense of Calderbank--Kantor; C945 produces an *asymptotically two-character*
object with a codimension-one exceptional weight locus.

The resonance arithmetic is perfectly aligned with the classical divisibility
obstruction.  Calderbank--Kantor Corollary 5.5 says that the difference of the
two weights of an exact projective two-weight code is a power of the field
characteristic.  Here that difference is exactly `a-lambda=d`.  Moreover, an
infinite Desarguesian sequence with `q=dn` can exist only when `d` itself is a
power of the characteristic.  Thus the factor-pair resonance does not merely
survive the two-weight divisibility condition: it predicts it automatically.

The first stability step is classical too, and it gives a stronger priority-
judo corollary than the proposed generic inverse statement.  Let `q=p^h`,
`h>1`, and assume `d=p^r`.  Reduce the line-intersection numbers of `L` modulo
`p`.  The two regular values in `(NTC)` coincide, so only the `O(q)` exceptional
lines fail to meet `L` in `lambda mod p` points.  Szőnyi--Weiner Theorem 1.2
says that, for all sufficiently large `q`, a multiset with only `delta=O(q)`
non-`lambda mod p` lines can be changed at exactly

```
ceil(delta/(q+1))=O_{u,v}(1)
```

points to become an exact `lambda mod p` multiset.  Their hypotheses allow
`delta` up to order `q^(3/2)` both for `h=2` and `h>2`, so the present linear
exception count lies well inside the stability range.

At exact first-order double tightness, the balanced internal deficit gives the
more precise exceptional-line scale

```
delta <= [u(v+1)^2(u^2+u+1)/(2uv+u+v)] q+o(q),          (EX)
```

before any additional exceptional degrees are charged to the smoothing
defect.  Thus every threshold sequence has a dual selected-secant set which is
a bounded-point edit of an exact modular set.  Equivalently, its exceptional-
weight word in the projective-plane incidence code has weight `O(q)` and, by
Szőnyi--Weiner Theorem 4.3, is a linear combination of only `O_{u,v}(1)` line
words.

The maximal-secant lift feeds back into the numerical bound before any full
core classification.  On a characteristic-compatible factor-pair branch,
suppose the repaired exact modular multiset differs from the selected-secant
dual set at `r>=1` distinct support points (arbitrary nonzero modular
multiplicities are allowed).  Dualizing those support points gives `r` primal
generator lines.  Away from their `O(r)` mutual intersections, every point on
each generator line has a nonzero modular degree error.  At most `s` of those
points lie in the arc, so one generator already forces

```
external degree excess >= (q+1-s)-O(r)=v n-O(r).
```

For `r` fixed generator lines, taking their union and losing only their
pairwise intersections strengthens this to `rvn-O(r^2)`.  But the exact
external excess at `T=ud(v+1)n+h+o(1)` is

```
(q+1-s)T-lambda b
  =uv(c-L(h))n+o(n),            L(h)=d-h/u.
```

Hence a repaired core with support size at least `r` obeys the
**modular-lift surcharge**

```
c >= L(h)+r/u,
c >= c_lat^(r):=min_{h in Z} max(C(h),L(h)+r/u).       (MLS)
```

The shifted real crossing and exact lattice value are

```
h_r=h0+r/(1+u mu),
c_lat^(r)=min over h in {floor(h_r),ceil(h_r)}
             max(C(h),L(h)+r/u).
```

Because the unshifted functions meet at `h0`, every `r>=1` gives a strict
gain; continuously the gain is `r mu/(1+u mu)`, and lattice rounding can only
increase it.  There is a further residue constraint.  An exact `lambda mod p`
multiset has total multiplicity `lambda mod p` (sum its line intersections
over a pencil).  Since the leading term of `T` is divisible by `p` on an
infinite characteristic-compatible tower, the correction has total
multiplicity `h-lambda mod p`.  Therefore support one is impossible when
`h congruent lambda (mod p)`.  Once the zero-support case has been excluded,
the residue-aware envelope is

```
r_min(h)=2 if h congruent lambda (mod p), and 1 otherwise,
c >= min_{h in Z} max(C(h),L(h)+r_min(h)/u).           (RMLS)
```

This is the general 99-level mechanism: classical modular
repair is a corollary input, while the new arc cap converts each edit location
into a quantitative external-coverage tax.  A branchwise zero-support
modular core must be handled by the corresponding `p`-spaced degree envelope;
the CF branch below is the first case where that alternative is also excluded.

The priority-judo pipeline is now:

```
extremal higher arc
  => bounded edit of an exact lambda mod p multiset
  => nonzero edit support pays the explicit surcharge (MLS)
  => only zero-support or residual equality cores require classification.
```

The stability arrow is classical and must be credited.  The new load-bearing
unit is the factor-pair theorem, the reduction `(EX)`, and the maximal-secant
feedback `(MLS)`.  A full classification/construction theorem for the residual
cores would be a beyond-99 crown, not a prerequisite for the CF parity theorem.

### The first characteristic-two core and an elementary obstruction

The smallest characteristic-compatible double-tight branch is `(u,v)=(2,1)`,
the branch behind `(CF)`.  Here

```
d=4,       lambda=2,       a=6,       q=8m,       s=6m+1.
```

At the stable exact paired-envelope threshold `k=32m^2+12m+1` for `m>=13`,
the complement has size `b=32m^2-4m`, so the selected-secant count forced by
coverage is not merely asymptotic but

```
T=ceil(2b/(2m))=32m-4=4q-4.                         (CF-T)
```

If an arc attains this numerical threshold, the equality bookkeeping is much
more rigid than the asymptotic statement `(EX)`.  Every external point has
selected-secant degree exactly `2`, because the external degree sum is exactly
`2b`.  On the `k` internal points, writing `z_x=6+y_x`, the two degree moments
give

```
sum_{x in A} y_x=-8q-10,
sum_{x in A} y_x^2=8q+100,
sum_{x in A} y_x(y_x+1)=90.                          (CF-R)
```

The last identity says that at most 45 internal points can have degree outside
`{5,6}`; the entire nonlinear deviation from the balanced sequence is the
absolute constant 90.  Consequently the odd-secants of the dual set `L` are
all internal dual lines, their number is at most `8q+100`, and every other
line is a 2- or 6-secant.  For `q=8m>=104`, Szőnyi--Weiner's exact
characteristic-two repair theorem changes at most nine points to obtain an
even-type set.  Both `L` and every even-type set have even cardinality, so the
symmetric-difference distance is even; it is therefore at most eight.  Thus
threshold attainment implies the completely explicit reduction

```
|L|=4q-4,
L is within 8 points of an even-type set,
all external dual lines are exact 2-secants,
and only 45 internal degrees lie outside {5,6}.        (CF-8)
```

In fact `(CF-8)` already contradicts threshold attainment.  The identities
`(CF-R)` force an odd line: if every degree were even, then `y_x=2z_x`, so
`sum z_x=-4q-5` and `sum z_x^2=2q+25`, contradicting
`sum z_x^2>=-sum z_x` for `q>10`.  Thus the repair set is nonempty; its even
size makes it at least two.  Since every external line has degree two, the full odd-line
locus lies inside `A`.  But on a generator line of the repair symmetric
difference at most seven points can cancel, leaving at least `q-6` points of
`A`, whereas `s=3q/4+1<q-6` for the present orders.  Therefore, in
`PG(2,q)`, `q=2^h>=128`, the stable paired-envelope boundary is impossible
and the exact geometric bound improves once more to

```
k >= 32m^2+12m+2.                                    (CF+)
```

This uses only the classical repair theorem and the new maximal-secant lift;
no classification of even-type sets near `4q` is needed.

There is, however, a further payoff which does not require classifying the
repaired core.  It already raises the asymptotic CF bound.  Write

```
k=32m^2+C m+o(m),             T=32m+H+o(1).
```

The unrestricted paired envelope has first-order feasibility condition

```
6C-H >= 76.                                             (P1)
```

Let `e` be the total external degree excess over the required degree two.
Then

```
e=2(C+H-8)m+o(m).                                      (P2)
```

Near this resonance only `O(q)` dual lines have odd intersection with `L`,
so even-type stability writes `L=E triangle R`, where `E` is even type and
`r=|R|=O(1)`.  If `R` is empty, restricting both balanced degree sequences to
even degrees adds `(D+e)/2` to the pair minimum, where `D` is the internal
deficit below degree six.  Explicitly,

```
D=(6C-6H-32)m+o(m),
pair slack=(12C-2H-152)m+o(m),
(D+e)/2=(4C-2H-24)m+o(m).
```

Comparing the last two expressions simplifies to `C>=16`.  Hence `R` is nonempty throughout the range
relevant to improving `(CF)`.  Since every even-type set has even size,
`r congruent T congruent H (mod 2)`.

Dualize the points of `R` back to `r` primal lines.  Their symmetric
difference is precisely the odd-line locus of `L`.  On each generator line,
at most `r-1` intersection points can cancel, so at least `q-r+2` points have
odd `L`-degree.  Since an `s`-secant arc contains at most
`s=3q/4+1` points of that line, at least `q/4-r+1` of them are external.
If `r` is odd it can be one, giving

```
e >= q/4-O(1),             C+H>=9.                    (P3o)
```

If `r` is even then `r>=2`; two distinct generator lines share at most one
point, so

```
e >= q/2-O(1),             C+H>=10.                   (P3e)
```

The integer offset `H` is odd in `(P3o)` and even in `(P3e)`.  Minimizing
`max((76+H)/6,9-H)` over odd `H` gives `73/6` at `H=-3`; minimizing
`max((76+H)/6,10-H)` over even `H` gives `37/3` at `H=-2`.  The odd case is
the universal minimum.  Hence the new characteristic-two parity bound is

```
C >= 73/6,
k >= 32m^2+(73/6)m-o(m)
  = q^2/2+(73/48)q-o(q).                              (PF)
```

The earlier constant-sharp `(CF)` has coefficient `12m`, so `(PF)` gains
`m/6=q/48` beyond it, and still gains linearly over the classical spectral
bound.  The proof is a genuine interaction of the new paired envelope, the
classical even-type repair theorem, and the maximal-secant cap: neither the
moment bound nor modular stability alone contains `(P3)`.  This is now the
best 99th-percentile headline in the dossier.  Before paper insertion it needs
conversion from the displayed sequential asymptotic argument into a single
epsilon-quantified lemma and a claim-specific precedence search for parity-
repaired multiple-cover arcs; no manuscript claim is yet licensed.

Szőnyi--Weiner's characteristic-two stability theorem repairs the dual set
`L` to an even-type set by a bounded point edit.  The most obvious classical
even-type candidates nevertheless cannot lift.  For example, let `E` be the
symmetric difference of four lines, exactly three of which are concurrent.
Then `|E|=4q-4` and its complete line spectrum, with geometric line classes
kept separate when characters coincide, is

```
character       2             4             q-2       q
number          4q-5          q^2-3q+2       1         3.       (4L)
```

Indeed, a non-generator line through the triple point or one of the three
double points is a 2-secant; a generic line meets the four generators in four
distinct retained points.  Thus `q^2-O(q)` lines are 4-secants.  Changing a
bounded number of points changes only `O(q)` line intersections, whereas a CF
threshold core must have all but `O(q)` line characters in `{2,6}` and both
regular classes have quadratic size.  Hence neither this set nor any bounded
edit of it can be a CF core.  The same generic-line argument excludes all
three concurrency types of a four-line symmetric difference.  More generally,
it excludes any proposed core obtained as the symmetric difference of a fixed
number of generator lines whenever its single generic character is not one of
the two required regular characters.  This disposes of the simplest
line-generated explanation but does not classify arbitrary even-type sets of
size about `4q`.

There is also a useful exact benchmark.  If an exact two-character `{2,6}` set
of size `T` existed, the first two intersection equations would give

```
T^2-(7q+8)T+12(q^2+q+1)=0,
Disc=q^2+64q+16=(q+32)^2-1008.                       (26)
```

Consequently its order belongs to the finite list

```
q in {1,5,11,16,35,55,96,221};
```

among powers of two only `q=16` survives.  Thus an infinite CF extremal family
cannot collapse all the way to an exact `{2,6}` two-character set.  Its
`O(q)` exceptional lines are arithmetically necessary, not merely an artifact
of the stability proof.  The 99-plus problem is therefore sharper than exact
two-weight classification: classify the even-type sets of size `4q+O(1)`
with only `O(q)` non-`{2,6}` lines and then impose the maximal-secant lift.

### Projective codes in arbitrary dimension

Take the point--hyperplane design of `PG(r-1,q)`, where

```
v      = (q^r-1)/(q-1),
K      = (q^(r-1)-1)/(q-1),
Lambda = (q^(r-2)-1)/(q-1).
```

A point set `A` of size `k` with maximum hyperplane intersection `s`
generates a projective `[k,r,k-s]_q` code.  Its `s`-hyperplanes correspond to
minimum-weight codewords.  For a candidate new column `x`, every such
hyperplane through `x` is a distinct witness preventing the extended code's
minimum distance from increasing to `k+1-s`.  Requiring at least `lambda`
witnesses at every admissible `x` is therefore robust projective
nonextendibility in every dimension.

The symmetric-design identity gives an exact paired-moment obstruction for
these codes:

```
sum_{a in A} C(d(a),2)
 + sum_{x notin A} C(r(x),2)
 = ((q^(r-2)-1)/(q-1)) C(T,2).
```

For `r=3` this is exactly the higher-arc identity.  Higher dimensions lose the
plane's matching cap, but retain arbitrary certified degree caps, the convex
interval obstruction, the spectral constraint, and the equality theory.
This supplies a direct application class well beyond complete `(k,s)`-arcs.

The higher moments also have a code-theoretic meaning.  A `j`-set of selected
hyperplanes in `PG(r-1,q)` has intersection size determined by the rank of its
`j` defining linear forms.  Hence the right side of `(M_j)` is a weighted rank
enumerator of families of minimum-weight codewords.  Bounds on the rank
distribution of those words feed directly into the integer moment hierarchy.
When the selected hyperplanes are in general position through order `j`, the
right side is constant and the `j`th interval obstruction is explicit.

This connects robust nonextendibility to matroid data that the ordinary
minimum distance and the degree-two spectral bound do not see.  A concrete
third- or higher-moment family with a computable rank enumerator would be the
strongest route to an application exceeding the current scalar bounds.

### Rigidity and arithmetic corollaries

- If the two feasible pair intervals are disjoint, the proposed design, arc,
  blocking set, or projective code does not exist.
- If they meet at a single endpoint, equality in convexity forces one side's
  degrees to be as balanced as possible and the other side's to be filled to
  its caps.  Hence the incidence partition is two-level up to one remainder
  class, producing divisibility conditions and a candidate tactical or
  quasi-symmetric design.
- The distance between the actual pair sum and either endpoint is a sum of
  elementary smoothing or anti-smoothing moves.  It gives an integer stability
  parameter before any geometry-specific argument is invoked.
- In the planar complement, the result simultaneously bounds higher arcs,
  minimal multiple blocking sets with several tangents per point, and robust
  dimension-three code extensions.  These are three readings of one theorem,
  not separate analogies.

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

The v5 rows also evaluate the complementary quadratic from
Bishnoi--Mattheus--Schillewaert Theorem 8.1 and record the pointwise hybrid
threshold.  Against that spectral threshold, the new second moment wins in
97/86/73 rows, loses in 34/52/59, and ties in 15/8/14 for
`lambda=1/2/3`.  This comparison is exact integer arithmetic; no floating-point
root evaluation is used.

They additionally record the paired-moment and paired-plus-full-spectral
thresholds.  The paired threshold improves the earlier hybrid in 27/23/26
rows for `lambda=1/2/3`, with maximum gains 2/1/1.  The full-family spectral
constraint changes none of those paired thresholds on this grid.

A second, wider-degree sweep covers all `2<=s<=q` for the 13 orders
`q=7,8,9,11,13,16,17,19,23,25,27,31,32`, giving 225 rows per multiplicity.
The paired threshold improves the old hybrid in 155, 140, and 116 rows for
`lambda=1,2,3`, with maximum gains six, five, and three.  The phase separation
is pronounced: among the 33 rows with `s^2<q`, it improves 0, 1, and 0;
among the 65 intermediate rows it improves 42, 37, and 36; and among the 127
rows with `2s>=q` it improves 113, 102, and 80.  This supports a high-degree
paired-moment regime beginning near `s` of order `sqrt(q)`, complementary to
the fixed-degree additive bound.  It is evidence for, not yet a proof of, an
infinite-family phase theorem.

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
specializations against `3 C(k,4)` for `4 <= k <= 40`.  It also verifies in
25,494 integer substitutions that the eliminated Cauchy inequality and the
Bishnoi--Mattheus--Schillewaert quadratic are the same polynomial, and checks
the exact `(UF)` threshold in the 11 orders `q=16,24,...,96`.  It also checks
the ordinary-completeness formula `(OF)` for all 30 integers `3<=n<=32` and
the spectral sign change plus boundary obstruction for the conjugate `3/4`
resonance in all 63 integers `2<=m<=64`, and verifies the two constant
sharpenings of `(CF)` at the excluded and admitted boundary values in the same
63 cases.  Schema v13 additionally records all
119 ordered divisor-pair resonances with `lambda<=32`.  Exact rational
arithmetic independently checks `(G)`, checks that the lattice coefficient is
strictly above the spectral coefficient, and verifies by a bounded convex
search around `h0` that the two adjacent integers give the global lattice
minimum.  Six of these 119 branches have integral `h0`; this is a bounded
observation, not a count of the unrestricted double-tight sublocus.  The
divisor criterion `(DT)` and the self-conjugate assertion are independently
checked for the 32 even integers `2<=u<=64`; their proofs are uniform.  The
same rational records independently verify the exceptional-line coefficient
in `(EX)` on all 119 bounded branches.  It also checks `(CF-T)` in the 52
stable cases `13<=m<=64`, the complete four-line spectrum `(4L)` in 121
orders, and the finite discriminant list `(26)` by exact integer arithmetic.
It independently minimizes the odd- and even-offset parity envelopes in
`(P3o)` and `(P3e)`, recovering `(73/6,-3)` and `(37/3,-2)` respectively.
For every one of the 119 factor-pair rows it also records and independently
checks the support-one and support-two modular-lift envelopes `(MLS)`, their
shifted crossings, minimizing integer offsets, and strict gains over the
unshifted lattice coefficient.  On every branch for which `d` is a prime
power it also records the characteristic and residue-aware conditional
envelope `(RMLS)`.  The `(1,1)` and `(2,1)` rows recover coefficients `4` and
`73/12`; a separate exact grid checks that the zero-support `1 mod 3` surcharge
exceeds the available ordinary-branch pair slack by the invariant amount `9`.
The v13 additions independently brute-check the congruence-class degree
minimum in 600 instances, recompute 246 factor-pair first-order expansions
from the raw exact balanced pair count, and reject 144 admissible `(OF3)` and
4,736 admissible `(PF)` zero-core instances in their declared bounded grids.

Replay from the repository root:

```
nix shell nixpkgs#python3 --command python3 notes/2026-08-22-c945-higher-arc-defect.py check
```

The working directory is the repository root.  The generator is deterministic
and uses only Python's standard library; there are no random seeds or external
data inputs.
`generate` rewrites the canonical sorted JSON and checksum manifest; `check`
recomputes both in memory and fails on drift.  The script is 36,606 bytes with
SHA-256 `ead11d27a9f195d21059381abf9614272a5872b5426d4375869cab4456ef3097`;
the JSON is 511,185 bytes with SHA-256
`a266a64e0fe45cffa76edf4b4320cdd17ab97e750cb9dcb4388009e6c054c75f`.
The checksum manifest is the authoritative replay record.

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
- Van de Voorde--Zullo, *Weak arcs and applications to the DNA-based storage
  access problem*, arXiv:2608.19550v1 (submitted 20 August 2026): **partial**,
  abstract, the opening of Section 1, Section 2.1.1 around Theorem 1 and its
  extremal example, and a targeted full-text search for `complete arc`,
  `maximal secant`, `blocking set`, `second moment`, `defect identity`, and
  `(k,n)`-arc read from the cached 31-page PDF; cache key
  `arXiv:2608.19550`, SHA-256
  `74cba859eff90472e9e424c6356fb81c44c0c1359c0e0d814f1f19550ab91727`.
  Their weak arcs constrain intersections only with the *general* hyperplanes
  avoiding the fundamental points, and their planar extremizers have size
  `2q+3`.  This is a current finite-geometric arc neighbor, but not the
  complete higher-arc/maximal-secant problem or C945's integer-envelope and
  modular-repair mechanism.  No broader absence claim rests on this partial
  read.
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
- Schillewaert, *Solution to Bishnoi's conjecture on minimal `t`-fold blocking
  sets of maximal size*, arXiv:1705.03775v1: **full text**, both pages of the
  cached arXiv version read, relying on the Main Theorem and its four-case
  arithmetic proof; cache key `arXiv:1705.03775`, SHA-256
  `196f70d63ff3a8af0d7c61f6586c4f436fa555d37447fe82476bcc1e0b41ac2f`.
  This closes the equality classification for the Bishnoi--Mattheus--
  Schillewaert spectral bound over prime-power planes: equality gives only a
  unital, the complement of a Baer subplane, or the plane minus one point.
  It strengthens the classical equality layer and should be cited there.  It
  does not pre-empt C945's strict integer-envelope gain away from spectral
  equality or its modular-lift surcharge.
- Ramani, *Blocking Amalgamations, Maximal Arcs, and Generalized Crowns*,
  arXiv:2608.16035v1 (submitted 17 August 2026): **full text**, all 17 pages
  read from the cached arXiv version; cache key `arXiv:2608.16035`, SHA-256
  `bb2fc5ce5f4d1627a2b9608cf94b7064bb1ce595315f14a9395b0c1bdffbc4a8`.
  Ramani gives an exact first-incidence slack identity for an `h`-fold
  transversal of a finite linear intersecting uniform hypergraph, dualizes
  equality to a pairwise balanced design with a distinguished regular
  subfamily, and uses maximal arcs to attain a generalized-crown extremum.
  This is the nearest paper found in the recent-weeks screen and makes the
  elementary degree-cap defect/classical-design layer especially important to
  credit.  It does not formulate C945's paired internal/external second-moment
  envelopes, completeness surcharge, or modular repair.  Priority language
  should therefore attach to that combined mechanism, not to a generic defect
  identity.
- Ball--Fancsali, *Multiple blocking sets in finite projective spaces and
  improvements to the Griesmer bound for linear codes*, DOI
  `10.1007/s10623-009-9298-7`: **full text**, all sections 1--9 of the
  23-page author-hosted prepublication manuscript dated 27 February 2009 read,
  relying especially on Sections 1 and 5--8; this was not the Springer version
  of record.  Cache key `10.1007/s10623-009-9298-7`, SHA-256
  `a452ff04053a8082d50953acf53f9cf64495b0c870a0cb6a3753283e86fdbba2`.
  The paper makes the higher-dimensional projective-code / multiple-blocking-
  set / minihyper dictionary classical and develops recursive polynomial and
  Griesmer bounds.  It does not use the paired exact degree-envelope test.
- Kohnert, *`(l,s)`-Extension of Linear Codes*, arXiv:cs/0701112 / DOI
  `10.1016/j.disc.2007.12.028`: **full text**, all eight pages of arXiv v1 read,
  relying especially on Theorem 1, Corollary 2, and Lemma 5; cache key
  `arXiv:cs/0701112`, SHA-256
  `8135a111fd72f29a478733b23fc884563f472293ad4724c5ef080b7b6093aace`.
  Kohnert characterizes one- and multi-column extension by an incidence matrix
  between projective candidate columns and projective classes of minimum-
  weight generators.  This establishes the robust-witness dictionary in the
  dual orientation: Kohnert counts nonvanishing coordinates needed for an
  extension, whereas `r(x)` counts minimum hyperplanes vanishing at a candidate
  and hence obstructing a distance increase.  No paired integer envelope is
  formulated there.
- Calderbank--Kantor, *The Geometry of Two-Weight Codes*, DOI
  `10.1112/blms/18.2.97`: **full text**, all Sections 1--13 of the 26-page
  published article read from the cached author-hosted PDF, relying especially
  on Theorems 3.1--3.2, Corollary 5.5, and the dimension-three examples and
  characterization results in Sections 8 and 12; cache key
  `10.1112/blms/18.2.97`, SHA-256
  `986eeff4e7b4d259876242ee3659a627c28057abe5a087dcdd9e9bdb7181b05d`.
  The paper makes the equivalence among exact two-character projective sets,
  projective two-weight codes, and associated strongly regular graphs
  classical, and proves that the two nonzero weights differ by a power of the
  characteristic.  This is the correct classical target for the new integral-
  `h0` inverse problem.  The C945 conclusion is only *near* two-character:
  first-order double tightness leaves an `O(n)` exceptional degree locus, so
  the exact correspondence neither pre-empts the factor-pair bound nor by
  itself classifies its equality sequences.
- Szőnyi--Weiner, *Stability of `k mod p` multisets and small weight codewords
  of the code generated by the lines of `PG(2,q)`*, arXiv:1901.09649v1 / DOI
  `10.1016/j.jcta.2018.02.005`: **full text**, all Sections 1--4 of the
  17-page arXiv version read, relying especially on Theorems 1.1--1.2,
  4.2--4.3, and the proof of the repair theorem in Section 3; cache key
  `arXiv:1901.09649`, SHA-256
  `4161216751349d453fc8e8fbf40df6132de24f8e83581e85eeeb33ec936c046f`.
  Their theorem pre-empts a generic modular version of the proposed
  few-exception inverse theorem: `O(q)` exceptional line sums can be repaired
  to exact `k mod p` type by changing `O(1)` points, and the dual low-weight
  codeword is a combination of `O(1)` lines.  C945 therefore uses this as a
  credited corollary and concentrates the new target on the maximal-secant
  lift and classification of the repaired modular core.
- Szőnyi--Weiner, *On the stability of sets of even type*, Advances in
  Mathematics 267 (2014), DOI `10.1016/j.aim.2014.09.007`: **full text**, all
  sections of the cached 18-page published article read, relying especially
  on Theorem 1.1 and the spectrum discussion; cache key
  `10.1016/j.aim.2014.09.007`, SHA-256
  `84a1c7a75e344fa9fa9479daa10de11e3f0509c79aac99f41d516ca6a9c7a9e9`.
  For even `q`, their theorem is the sharper direct predecessor of the modular
  repair step: a set with sufficiently few odd-secants is uniquely repaired
  to an even-type set using exactly `ceil(delta/(q+1))` point changes.  The
  paper does not classify even-type sets at the present weight near `4q`; its
  recorded spectrum results become sparse well before that scale.  C945 uses
  the theorem as a credited corollary and adds the maximal-secant lift and the
  elementary exclusion `(4L)` of the first line-generated core candidates.
- Csajbók--Weiner, *Generalizing Korchmáros--Mazzocca Arcs*, Combinatorica 41
  (2021), DOI `10.1007/s00493-020-4419-z`: **full text**, all Sections 1--7 of
  the cached 17-page author manuscript read, relying especially on Definition
  2.1, Theorems 2.6, 6.9--6.10, and the modular stability reduction in Section
  6; cache key `10.1007/s00493-020-4419-z`, SHA-256
  `f087fb4b39df1a08a86f268f1ed5bee88085c5f17b74f0c6e404b7e20464c1ab`.
  This is the closest classical structural neighbor found for the CF core.
  Exact generalized KM-arcs of type `(0,2,6)` have size `q+6`, not `4q-4`,
  and their classification/stability hypotheses require the local unique-
  exceptional-secant condition absent here.  The paper therefore supplies
  useful priority judo and proof technology, but does not classify an even-type
  set with a linear exceptional-line locus and the C945 maximal-secant lift.
- Csajbók, *On bisecants of Rédei type blocking sets and applications*,
  arXiv:1504.06748v2: **full text**, all Sections 1--6 of the cached 26-page
  arXiv version read, relying especially on Theorem 5.1, Corollary 5.3, and
  Lemma 6.9 through Theorem 6.11; cache key `arXiv:1504.06748`, SHA-256
  `aa276cb2184cfa2dd279a362de55b5d9e48a9ca1541c5523fd07db94e5d099b5`.
  This paper makes the broad proof pattern “repair a few odd secants to even
  type, then use local secant geometry” classical, including applications to
  semiovals and KM-arcs.  It does not study the dual family of all maximal
  secants of a complete higher arc, the paired-envelope resonance, or the
  parity surcharge `(P3o)`--`(P3e)`.  The present novelty claim must therefore
  be the quantitative maximal-secant feedback `(PF)`, not modular repair as a
  method.
- Adriaensen--Szőnyi--Weiner, *Multisets with few special directions and small
  weight codewords in Desarguesian planes*, arXiv:2411.19201v3: **full text**,
  all Sections 1--7 of the cached 25-page arXiv v3 PDF read, relying especially
  on Theorems 1.7--1.9, Corollary 3.8, the small-weight baseline in Result
  1.14, and the code/multiset correspondence in Section 1.3; cache key
  `arXiv:2411.19201`, SHA-256
  `0fc810af52d3d70424f72c82878b69d55fa4abb285c344934dfac65587c86c19`.
  The paper extends the modular polynomial method to special directions and
  gives new small-weight codeword classifications.  It confirms that the
  relevant stability/code machinery remains active and classical, but its
  exceptional object is a set of directions or a codeword supported on few
  concurrent lines, not the factor-pair maximal-secant envelope.
- Lund--Saraf, *Incidence Bounds for Block Designs*, arXiv:1407.7513v2:
  **full text**, all sections and the appendix of the 2016 arXiv source read,
  relying especially on Theorem 1, the prior-work note, the expander-mixing
  lemma, and the calculation `NN^T=(r-lambda)I+lambda J`; cache key
  `arXiv:1407.7513v2`, PDF SHA-256
  `9a9e657663d1b310d9272c9e8e0dcae12a966ac44c8524f1e9b0929cb614efc9`.
  Their BIBD incidence theorem is precisely the relevant spectral baseline.
  The authors explicitly record that Haemers had proved this incidence result
  earlier.  The paper uses real spectral/Cauchy bounds, not balanced integer
  degree minima on both sides of a selected block family.
- Murphy--Petridis, *A Point-Line Incidence Identity in Finite Fields, and
  Applications*, arXiv:1601.03981: **full text**, all sections of the arXiv
  source read, relying especially on Lemma 1, the higher-dimensional section,
  the block-design variance lemma, and the comparison with graph-theoretic
  proofs; cache key `arXiv:1601.03981`, PDF SHA-256
  `0e40611ca753f297025e8d6f8997d2a4f002f45d8ec3c15c3b2ca68cbd466c14`.
  They explicitly present the second moment as standard, generalize it to
  block designs, and show by direct computation that the expander-mixing
  operator inequality is an equality on balanced functions.  This closes the
  classicality of the degree-two moment/spectral mechanism.  Their envelopes
  remain real-valued; the simultaneous modular rounding correction used here
  is not formulated.
- Beker--Mitchell--Piper, *Tactical decompositions of designs*, Aequationes
  Mathematicae 25 (1982), DOI `10.1007/BF02189612`: **full text**, all eleven
  sections of the 30-page survey article read from a forced-OCR extraction of
  the Goettingen digitization, relying especially on Sections 2--5 and
  Theorem 4.4; cache key `10.1007/BF02189612`, source PDF SHA-256
  `70fbeb318aa1281da9b14e93c8875d9963f754c671106d9e33050aa97f84d6ea`.
  The survey traces tactical decompositions to Dembowski, develops exact row-
  and column-class incidence equations, and derives rank, divisibility, and
  arithmetic nonexistence restrictions.  Thus exact quotient equations for
  *tactical* partitions are classical and must be part of the credited
  infrastructure.  Its hypotheses require constant incidences within point
  and block classes; it does not formulate balanced integer extrema for the
  non-tactical degree sequence of an arbitrary selected block family or the
  maximal-secant consequences `(OF)` and `(UF)`.
- Li--Pott, *Intersection distribution, non-hitting index and Kakeya sets in
  affine planes*, arXiv:2003.06678v2 / FFA 2020: **partial**, abstract,
  Section 2's definitions and Proposition 2.4, the extremal-bound discussion,
  and the related-work/open-problem section read from the arXiv source.  Cache
  key `arXiv:2003.06678v2`; source-bundle SHA-256
  `78ed05e1df8be325518cd75e8213f29221bf04008249b0cab93e3b774ee085e8`.
  Their intersection distribution records the numbers of lines meeting one
  point set in each cardinality and uses the classical first three line-
  intersection equations.  This is close terminology but a different degree
  sequence from the present one, which counts selected maximal secants through
  points on both sides of a partition.  No absence claim rests on this partial
  read.

The audit currently has thirteen full-text and six partial sources.  It supports a
firm *classical* verdict for the moment/spectral and code/blocking dictionaries.
It supports only the narrower bounded statement that no direct predecessor for
the paired integer-envelope sharpening, `(OF)`/`(UF)`/`(CF)`, or the
maximal-secant feedback `(MLS)`/`(PF)` was found; a global novelty or
priority verdict remains open.

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

### Recorded locator searches for the classicality boundary

These are locator searches, not an exhaustive title/abstract screen and not a
bibliographic negative.  Exact query strings issued on 2026-08-22 were:

```
site:arxiv.org symmetric design minimal blocking set degree sequence convexity pair count
site:arxiv.org projective linear code nonextendible multiple minimum weight codewords extension
site:doi.org finite geometry multiple saturating sets projective codes multiplicity
site:arxiv.org "extendability" "projective codes" finite geometry
"Multiple blocking sets in finite projective spaces" PDF Ball Fancsali
"(l,s)-Extension of Linear Codes" PDF Kohnert
"nonextendible projective codes" finite geometry
"complete projective system" linear code extendible minimum distance
site:web.mat.upc.edu/simeon.michael.ball Fancsali multiple blocking pdf
site:arxiv.org integer degree sequence symmetric design blocking set convex
site:combinatorics.org symmetric design degree sequence blocking set variance
"sum" "binom{d" symmetric design blocking set
symmetric design tactical decomposition integer feasibility degree sequences paper
finite projective plane variance method secant distribution integer bound blocking sets
integer refinement expander mixing lemma incidence graph design
block design prescribed block intersection degree sequence nonexistence
Murphy Petridis "point-line incidence identity" PDF finite fields applications
Haemers incidence bound designs interlacing full text theorem 5.1
"integer" "incidence bound" symmetric designs degree sequence
"variance trick" blocking sets secants
two-intersection sets projective spaces tactical decomposition finite geometry survey PDF
two-character sets projective planes two-weight codes incidence degrees selected lines
intriguing sets projective plane two intersection set code arXiv
projective two-weight codes two-intersection sets Delsarte Calderbank Kantor PDF
"almost two-weight" code projective finite geometry
"few exceptional weights" linear code two-weight stability
"two-character set" stability projective plane
projective code almost all codewords two weights
Szőnyi Weiner Stability of k mod p multisets and small weight codewords JCTA 157 2018 PDF
"k mod p" multiset projective plane classification small size
weighted multiple blocking sets k mod p small size PG(2,q) Szonyi Weiner
"0 mod p" point set projective plane small size
sets of even type projective plane stability classification
site:arxiv.org finite projective plane "sets of even type" 4q
site:arxiv.org PG(2,q) even type "2-secants" "6-secants"
"generalized KM-arc" projective plane even type
"set of even type" "4q" PG(2,q)
finite projective plane even type double blocking set 4q
PG(2,q) "even type" "double blocking"
"sets of even type" "4q" finite geometry
"even type" PG(2,q) "4q-4"
finite projective plane complete (k,n)-arc even type stability parity lower bound maximal secants
"even-type" "complete arc" projective plane secants
"sets of even type" maximal secants arc PG(2,q)
"stability of sets of even type" arc completeness
Balister Bollobas Furedi Thompson Minimal Symmetric Differences of Lines in Projective Planes DOI PDF
complete (k,n)-arc PG(2,3^h) lower bound k q^2/3 4q/3
complete higher arcs characteristic 3 maximal secants modular stability lower bound
"complete (k,n)-arc" "mod 3" projective plane
"maximal secants" "1 mod 3" arc PG(2,q)
```

The final four strings are the claim-specific locator pass for `(OF3)`.  They
returned the known Alabdullah--Hirschfeld first-moment lower bound, curve-based
completeness constructions, and unrelated small-degree/ordinary-arc work, but
no result combining `1 mod 3` repair with the family of all maximal secants to
obtain a lower bound at density `k/q^2 ->1/3`.  This is a bounded locator
negative only; the open Semantic Scholar/MathSciNet/MSC gaps still prevent a
global priority claim.

A second claim-specific web locator pass on 2026-08-24 used the exact strings

```text
"2q/3+1" complete arc PG(2,q)
"q^2/3" "complete (k,n)-arc"
"t_n(2,q)" "2q/3"
"q/3-fold blocking set" minimal projective plane
"minimal multiple blocking sets" integer bound secants
"complete (k,n)-arc" "lower bound" secants
"t_n(2,q)" lower bound
"maximal secants" "minimal t-fold blocking"
```

The pass recovered the already audited Alabdullah--Hirschfeld bound,
Bishnoi--Mattheus--Schillewaert, and the Korchmáros--Nagy--Szőnyi construction
paper.  It also exposed Schillewaert's two-page solution of the equality
conjecture, which was promoted to full-text reading above.  No hit stated the
`2q/3+1` characteristic-three lower bound or a modular-repair surcharge.  This
remains a locator result rather than an exhaustive bibliographic negative.

OpenAlex was then queried with `per-page=10` and the exact `search` values

```
block design integer degree sequence incidence bound
finite projective plane secant distribution integer programming blocking set
symmetric design tactical decomposition integer feasibility
```

The discriminator was a title advertising an exact integral degree-sequence,
secant-distribution, or tactical-decomposition obstruction relevant to a
selected block family.  The first and third result sets were dominated by
false positives; the second promoted Li--Pott for partial reading.  The exact-
title arXiv API request

```
all:"Intersection distribution, non-hitting index and Kakeya sets in affine planes"
```

resolved `arXiv:2003.06678v2`.  A separate metadata hit, Host's *Tactical
decompositions in uniform normal designs* (1986), DOI
`10.1016/0024-3795(86)90183-7`, was not promoted because neither an abstract
nor accessible full text was obtained; it remains an explicit tactical-
decomposition follow-up rather than evidence for an absence claim.

The zbMATH Open API was queried with `page_size=20` and the exact
`search_string` values

```
"tactical decompositions" design
"incidence bounds" "block designs"
"secant distribution" projective plane
"degree sequence" "symmetric design"
```

The first returned 20 records and promoted Beker--Mitchell--Piper to full-text
reading through its EuDML/Goettingen link; the second returned Lund--Saraf; the
third returned one modern unital paper that did not match the selected-family
degree discriminator; the fourth returned an explicit no-results response.
This is meaningful targeted zbMATH coverage, but not an exhaustive MSC
`05B05/51E15` screen.  A separate exact Semantic Scholar query

```
integer refinement incidence bound symmetric design degree sequence
```

again returned HTTP 429.  The error is recorded as a coverage gap, not an empty
result.

### Recent-weeks screen through 24 August 2026

The recency check was extended beyond ordinary web ranking.  The arXiv
`math.CO` Atom API endpoint `https://export.arxiv.org/api/query` was queried on
24 August 2026 with

```text
search_query=cat:math.CO AND submittedDate:[202607010000 TO 202608242359]
start=0
max_results=2000
sortBy=submittedDate
sortOrder=descending
```

It returned 1,792 records.  Titles were mechanically screened for `arc`,
`blocking`, `projective`, `secant`, `finite geometr`, and `design`; all 30
title hits then received a title-and-abstract relevance screen.  The
discriminator was a finite-projective arc/blocking/secant result or an exact
selected-design incidence obstruction capable of subsuming C945's claimed
mechanism.  The current page
`https://arxiv.org/list/math.CO/recent?skip=0&show=2000` was also screened
separately (267 entries when accessed).  Its title, subject, and comment fields
were screened with the same six literal strings so that indexing delay at the
upper endpoint would be less likely to hide a new submission.

Two records were promoted.  Ramani's 17 August paper was read in full and is
the nearest recent mechanism-level neighbor; it materially narrows the safe
claim from a generic defect identity to the *paired second-moment integer
envelope plus modular-lift surcharge*.  Van de Voorde--Zullo's 20 August weak-
arc paper received the partial/targeted read recorded above and concerns a
different general-hyperplane intersection condition.  The remaining 28 title
hits were rejected at title/abstract depth as unrelated design constructions,
Euclidean or spherical incidence problems, graph/digraph arc terminology, or
different finite-projective questions.  This is an exact eight-week
title/abstract screen, not an exhaustive all-subject arXiv or database
negative.

As an independent indexed check, the OpenAlex works endpoint
`https://api.openalex.org/works` was queried with the filter
`from_publication_date:2026-06-15` and exact search values

```text
"complete arc" finite projective plane
"multiple blocking set" projective
"(k,n)-arc" completeness finite field
"minimal t-fold blocking" projective plane
```

The searches returned respectively 3, 1, 0, and 0 records; every returned
title was a false positive under the same discriminator.  Together these
screens cover the recent weeks requested, while the already recorded
Semantic Scholar rate limit and absent exhaustive MathSciNet/MSC pass remain
the reason no global priority sentence is licensed.

## Manuscript-entry red team — 2026-08-24

The hostile review attacked the load-bearing chain in the order a referee is
most likely to attack it.

1. **Repair theorem hypotheses.**  Szőnyi--Weiner Theorem 1.2 was reread in
   the cached full text.  It applies to multisets in `PG(2,p^H)` with `H>1`,
   `q>27`, under an explicit exceptional-line threshold of order `q^(3/2)`
   when `H>2`; C945 has only `O(q)` exceptional lines.  Along the fixed-
   characteristic asymptotic towers, the hypotheses therefore hold
   eventually.  Its conclusion changes exactly `ceil(delta/(q+1))` distinct
   support points, with arbitrary modular multiplicities, matching the use in
   `(MLS)`.  Theorem 4.3 supplies the dual line-code formulation but is not
   needed as an additional mathematical hypothesis.
2. **Generator-line feedback.**  At a repair support point with nonzero
   coefficient, every nonintersection point of the dual generator line has
   selected-secant degree noncongruent to `lambda`.  External completeness
   gives degree at least `lambda`, so each such external point contributes at
   least one unit of excess.  Removing at most `s` arc points and `O(r)` mutual
   intersections gives `q+1-s-O(r)` per generator, and inclusion--exclusion
   over fixed `r` gives the stated `rvn-O(r^2)` lower bound.  No sign choice for
   the modular correction changes this argument.
3. **Residue obstruction.**  Summing exact `lambda mod p` line intersections
   over a pencil gives total multiplicity `lambda mod p`.  Far enough up a
   characteristic-compatible tower the leading term of `T` is divisible by
   `p`; hence a one-point nonzero correction is impossible precisely when
   `h congruent lambda (mod p)`.  The manuscript statement should use only
   this support consequence, avoiding an unnecessary sign convention for the
   correction multiplicity.
4. **Zero-core exclusions.**  Schema v13 adds a separately implemented
   congruence-class convex envelope, brute-checked in 600 small instances.
   It also recomputes 246 first-order factor-pair expansions directly from the
   raw finite balanced pair count rather than from the affine formulas.
   It then checks 144 arithmetically admissible `1 mod 3` zero-core instances
   below the `(OF3)` coefficient, including bounded constant terms, and 4,736
   even-degree zero-core instances below the characteristic-two coefficient
   `16`.  Every instance violates the exact block-pair count.  These tests
   independently reproduce the displayed first-order `D+E` and `(D+e)/2`
   obstructions; they are evidence, not substitutes for the proofs.
5. **Parity branch.**  In characteristic two the repair is a symmetric
   difference, `|R| congruent T (mod 2)`, and the odd-degree locus is exactly
   the symmetric difference of the `r` dual generator lines.  Outside their
   mutual intersections each generator supplies at least `q-r+2-s` external
   points.  The odd/even minima are respectively `73/6` at `H=-3` and `37/3`
   at `H=-2`, exactly as replayed in the artifact.
6. **Sequential quantifiers.**  A hypothetical liminf counterexample first
   passes to a bounded-coefficient subsequence.  The unique leading contact
   forces the selected-line offset to be `o(n)`; the signed first-order term
   then bounds it, and integrality permits a fixed-offset subsequence.  The
   repair support is uniformly bounded because `delta=O(q)`.  Thus the uses of
   fixed `h` and fixed `r` do not assume attainment or an unproved uniform
   expansion.

**Red-team verdict:** no false theorem or central gap found.  The repairs made
in this pass are expository but load-bearing: `(RMLS)` is now labelled a
dichotomy until zero support is excluded, and the omitted integer argument
forcing an odd line in `(CF+)` is explicit.  The proof packet is ready for
lemma-form drafting.  A later referee pass should still check the transcription
from the report into LaTeX independently.

## Coverage and verdict ownership

- **Not covered:** Semantic Scholar, because the graph API returned HTTP 429,
  and MathSciNet, because no authenticated access was available.  Google
  Scholar automated coverage was not attempted because it is normally blocked.
  zbMATH has the four targeted searches recorded above, but not an exhaustive
  MSC screen.  These gaps license no global negative inference.
- The seven sources marked `partial` require full-text promotion if a final
  novelty boundary depends on their silence.  Their present reads support only
  the positive topical and definitional attributions stated above.
- No higher-arc novelty sentence has been entered in the owning paper's
  claim--proof--novelty ledger.  The C945 formulations are therefore candidate
  positioning only and must not be copied into the manuscript, snapshot, or
  public summary as novelty claims.
- Surface check after the Theorem 8.1 and recent-weeks corrections: this C945
  report owns the candidate positioning; the live queue and relconic handoff
  are updated to point to its qualified verdict.  No C945 paper ledger exists
  yet, so no novelty sentence can propagate.  The conic manuscript, its
  claim--proof--novelty ledger, the results snapshot, and the public summary do
  not state the C945 priority claim and require no update.  Both manuscripts
  remain untouched.

## Mystery ledger (`ej` + `tt` closeout)

- **Why the paired threshold made the full spectral test redundant — settled.**
  Cauchy--Schwarz applied to the two exact degree sequences is algebraically
  identical to design expander mixing, and in the plane its coverage
  elimination is exactly Bishnoi--Mattheus--Schillewaert Theorem 8.1.  The
  25,494 symbolic substitutions in the evidence bundle independently check the
  cleared polynomial identity.
- **Whether the high-degree numerical wins are sporadic rounding — settled.**
  `(OF)` proves an ordinary-completeness gain `ceil((q-6)/5)` for `q=3n`,
  `n>=3`, while `(UF)` proves a double-coverage gain `q/8-1` for `q=2n`,
  `4|n`, `n>=8`, and `(CF)` proves a conjugate double-coverage gain
  `q/5+O(1)` for `q=8n`.  All three floor arguments are uniform; their
  arithmetic ingredients are independently checked in 30, 11, and 63 initial
  instances, respectively.  The closeout further sharpens the CF numerical
  envelope by up to two points, excludes its stable boundary geometrically in
  `PG(2,2^h)` via `(CF+)`, and proves the additional asymptotic gain `q/48`
  in `(PF)`.
- **Why the slopes `2/3`, `1/2`, and `3/4` appear, and whether the phenomenon
  persists — settled at every multiplicity.**  The ordered factorizations
  `lambda=uv` classify all rational resonances.  Theorems `(FP)`--`(LC)` give
  the exact lattice first-order coefficient and the strictly positive gain
  `(G)` on every branch.  The 119 branches with `lambda<=32` are independently
  checked in exact rational arithmetic; the proof itself is uniform and does
  not depend on this bound.
- **Whether the broad moment/design mechanism is classical — settled.**
  Murphy--Petridis close the moment/variance equivalence, Lund--Saraf and
  Haemers supply the spectral lineage, and Beker--Mitchell--Piper supply the
  tactical quotient-equation lineage.  These belong in the corollary and
  infrastructure layer, not in a priority claim.
- **Whether the latest weeks contain a direct pre-emption — settled for the
  declared eight-week screen, globally open.**  Of 1,792 arXiv `math.CO`
  records, Ramani is the only new mechanism-level neighbor and reinforces the
  need to credit first-incidence defect/PBD equality as classical-adjacent;
  Van de Voorde--Zullo use a different weak-arc condition.  Neither contains
  the paired second-moment/modular-lift mechanism.  Semantic Scholar,
  MathSciNet, and an exhaustive MSC screen remain the exact evidence gap and
  are owned by the future paper ledger before any priority wording.
- **Whether modular repair can improve the numerical bound without a full core
  classification — settled.**  The support-`r` modular-lift surcharge `(MLS)`
  converts each nonzero repair location into an exact `r/u` shift of the
  coverage line.  All 119 bounded factor-pair branches record the support-one
  and support-two shifts, and `(RMLS)` adds the total-multiplicity residue
  constraint on every characteristic-compatible branch.  In the ordinary
  characteristic-three branch the zero-support alternative is impossible by
  an invariant nine-unit first-order gap, yielding `(OF3)` and its further
  `2q/15` gain.  In the first characteristic-two branch, the
  zero-support alternative is weaker only when `C>=16`, so `(PF)` follows
  unconditionally with coefficient `73/48` in `q`.
- **Why characteristic three is stronger than the first characteristic-two
  branch — settled.**  On `(OF3)`, the exact `1 mod 3` zero-support envelope
  exceeds the available pair slack by `9n+o(n)` for every offset, and total-
  multiplicity residue upgrades the apparent support-one minimizer to support
  two.  This makes ordinary completeness the primary corollary and gives the
  exact residue-aware coefficient `4`.
- **Attainment or near-attainment of `(OF)`, `(UF)`, or `(CF)` — open.**  The
  original stable CF envelope boundary is now excluded in Desarguesian even
  order, but attainment near the stronger `(PF)` boundary remains open.  The
  evidence gap is an explicit
  family of complete `(k,2q/3+1)`-arcs, double-complete `(k,q/2+1)`-arcs, or
  double-complete `(k,3q/4+1)`-arcs near the thresholds, or an independent
  structural obstruction showing the true minima are larger.  Owner: C945
  structured-family gate.  The separate construction/extremal sequel is queued
  as C949; see `2026-08-24-c949-sharp-higher-arc-asymptotics.md`.  C949 treats
  `(OF3)` attainment as conjectural and does not enlarge the present theorem or
  manuscript gate.
- **A genuinely stronger `j>=3` application — open.**  The binomial hierarchy
  is formal until a family of minimum hyperplanes has a controlled rank/
  intersection enumerator that yields a new obstruction.  Owner: C945 higher-
  moment application gate; do not headline the hierarchy before this closes.
- **Exact precedence for the non-tactical integer envelope — open.**  The
  targeted searches found classical tactical equations but no use of balanced
  and cap-filled extrema on both sides of an arbitrary selected block family.
  The remaining evidence gaps are Semantic Scholar, MathSciNet, and an
  exhaustive zbMATH MSC screen.  Four claim-specific `(OF3)` locator queries
  found no predecessor, but this does not close those database gaps.  Owner:
  C945 literature gate.
- **Rigidity at equality of the paired interval — partly settled.**  Singleton interval
  contact forces balanced/cap-filled degree multisets, but geometric
  classification of the resulting clique/tactical structures has not been
  done.  On integral-`h0` Desarguesian branches, Szőnyi--Weiner now reduce the
  dual structure to a bounded edit of an exact `lambda mod p` multiset.  For
  `(CF)`, exact bookkeeping gives `(CF-R)`, at most eight edits, and the
  generator-line cap excludes the stable boundary.  Other branches and the
  prospective `(PF)` equality locus remain open.  Owner: C945 modular-core
  lift/classification gate.
- **Which factor-pair resonances have integral `h0` — arithmetic settled,
  geometry open.**  Criterion `(DT)` is an exact divisor parametrization, and
  every self-conjugate branch `(u,u)` with even `u` gives an infinite family of
  multiplicities having double tightness.  What remains is whether the forced
  near-tactical secant structures exist, or whether two-character/two-weight
  rigidity yields a structural nonexistence theorem.  Calderbank--Kantor close
  the exact two-character dictionary and Szőnyi--Weiner close the modular
  stability step; neither classifies which repaired modular cores lift to a
  maximal-secant family.  Owner: C945 modular-core lift/classification gate.

## Remaining gates after manuscript entry

1. During drafting, promote the factor-pair forward-difference argument and
   the `(OF3)`/`(PF)` subsequence arguments from this proof packet into numbered
   lemmas with explicit epsilon quantifiers and bounded endpoint constants.
   This is transcription and exposition work; the mathematical gate is green.
2. Create the new paper's claim--proof--novelty ledger before writing any
   “first,” “new,” or “to our knowledge” sentence.  The exact non-tactical
   integer-envelope and modular-lift precedence questions remain qualified
   because Semantic Scholar, MathSciNet, and an exhaustive zbMATH MSC screen
   are not covered.
3. Promote a partial adjacent source to full text only if a final novelty
   sentence would depend on its silence.  Their present positive topical uses
   are already licensed at the recorded depths.
4. Keep general deletion stability, higher moments without an application,
   modular-core classification, and construction sharpness out of Version 1.
   They are upgrades, not prerequisites; C949 owns the construction programme.
5. After a complete draft exists, run a fresh proof-only hostile review and a
   separate literature/positioning review before allowing submission language.
