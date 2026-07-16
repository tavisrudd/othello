# Baer-equivariant arc extension: orbit completions, mixed covers, and Galois rank

**Date:** 2026-07-10

## Executive conclusion

The Baer-equivariant extension result has a stronger upgrade than merely
improving its fixed-point union bound. The correct equivariant unit of
extension is a Galois orbit: over a quadratic extension, one may add either a
fixed point or a conjugate pair.

This viewpoint gives the following package.

1. An exact description of the fixed blocked set as a constrained mixed cover
   of the Baer subplane by invariant secant lines and isolated conjugate-secant
   intersections.
2. A corrected arbitrary-`(k,f)` upper bound for that cover, asymptotically
   sharp in its leading term.
3. A companion theorem giving an explicit lower bound on legal conjugate-pair
   extensions. In particular, every Frobenius-invariant eight-arc in
   `PG(2,s^2)`, for every prime power `s>=7`, admits such a two-point extension,
   and every arc of size below `s^2+1` with no free-orbit extension has size at least
   `1+ceil(sqrt(2s(s-1)))`.
4. A prime-degree theorem showing that quadratic extensions are exceptional:
   for prime Galois degree at least three, nonfixed selected orbits cannot
   produce invariant secant lines.
5. Higher-dimensional and MDS-code formulations. The “Galois rank” is
   exactly classical rank weight; the prospective new coding invariant is
   the rank-weight enumerator of all forbidden normals and the resulting
   subfield-rational lengthening count.
6. A bridge to completion-core rigidity: a bounded number of conjugate pairs
   cannot seal all the holes in a sufficiently punctured subfield conic.

The best prospective paper is therefore not “another bound for eight-arcs.”
It is a short theory of orbit saturation and equivariant extension of
Galois-invariant arcs. The most important remaining gate is now concrete:
decide whether the `sqrt(2)` constant is sharp, or prove a collision/stability
theorem improving it. A specialist prior-art audit and one exact equality
family remain necessary before a standalone novelty claim.

Everything below concerns geometric legality. A legal extension need not be
P-valued in the cap game, so none of these statements by itself proves the odd
projective-plane game conjecture.

## 1. Quadratic setup and the exact mixed cover

Let

```text
L = F_(s^2),       F = F_s,
```

and let `tau:x |-> x^s` act on `PG(2,L)`. Its fixed locus is the Baer
subplane

```text
B = PG(2,F).
```

Let `K` be a `tau`-invariant `k`-arc. Write

```text
f = |K intersect B|,             e = (k-f)/2.
```

Thus the nonfixed selected points form `e` conjugate pairs. For `k>=2`, let
`Blk_B(K)` be the set of points of `B` lying on a secant of `K`. A point of
`B` is a legal one-point extension of `K` exactly when it does not belong to
`Blk_B(K)`.

### Proposition 1.1 — invariant and noninvariant secants [PROVED]

The invariant secants of `K` are exactly:

- the `C(f,2)` lines joining two fixed selected points; and
- the `e` mate lines joining the members of a conjugate selected pair.

Hence their number is

```text
I = C(f,2)+e.
```

Every other secant belongs to a two-element orbit `{ell,tau(ell)}`. Such an
orbit meets `B` in at most the single point

```text
p_ell = ell intersect tau(ell).
```

More precisely:

- the `fe` fixed-to-nonfixed secant orbits have intersection equal to the
  corresponding selected fixed point and contribute no new blocked point;
- the secants between two different conjugate selected pairs form
  `e(e-1)` line orbits and hence contribute at most `e(e-1)` new fixed
  blocked points.

Consequently,

```text
Blk_B(K)
  = union { ell(B) : ell is an invariant secant }
    union
    { ell intersect tau(ell) : ell is a noninvariant secant }.
```

In particular, `K` has no legal fixed extension if and only if this
constrained mixed line-and-point cover fills `B`.

#### Proof

A line joining two fixed points is invariant, as is the line joining a point
to its conjugate. Conversely, suppose an invariant secant contains a
nonfixed selected point `P`. It also contains `tau(P)`. Since `K` is an arc,
its two selected points on the line must therefore be `P,tau(P)`.

If `ell` is noninvariant, a fixed point on `ell` also lies on `tau(ell)`.
The two lines are distinct, so this point is their unique intersection.
Conversely, their intersection is fixed by `tau`. A secant from a fixed
selected point `A` to `P` is conjugate to `A tau(P)`, and the two lines meet
at `A`. Between two distinct conjugate point-pairs, the four cross-secants
form two conjugate line-pairs. There are therefore
`2 C(e,2)=e(e-1)` such orbits. `square`

This exact dictionary is the main portal to finite-plane covering theory.
The cover is far from arbitrary: its lines are chords of an arc, its isolated
points are intersections of conjugate secants, and both pieces arise from the
same selected configuration.

## 2. A corrected arbitrary-`(k,f)` fixed-point bound

Assume first that `f>=2`, and put

```text
d_f     = floor(f/2),
sigma_f = ceil(6 C(f,4)/d_f),
j_f     = ceil(C(f,2)/d_f)
        = f-1  if f is even,
          f    if f is odd.
```

### Theorem 2.1 — fixed blocked-point bound [PROVED]

For `f>=2`,

```text
|Blk_B(K)| <= B_(k,f)(s),
```

where

```text
B_(k,f)(s)
  = C(f,2)(s+1) - f(f-2) - sigma_f
    + e(s+1-j_f) + e(e-1).                       (2.1)
```

For the two small fixed-point profiles, with `e>0`, one has

```text
B_(2e,0)(s)   = es+1+e(e-1),
B_(2e+1,1)(s) = es+2+e(e-1).                     (2.2)
```

For the singleton configuration `f=1,e=0`, the blocked set consists only of
the selected point.

Hence

```text
B_(k,f)(s) < s^2+s+1
```

is a sufficient criterion for a legal Baer-fixed extension.

#### Proof

Start with the `C(f,2)` chord lines of the fixed selected `f`-arc. At each
selected point, `f-1` chord lines concur, saving `f-2` points from the naive
line sum. This accounts for the term `f(f-2)`.

At any other point, `m` fixed chords through that point use disjoint pairs of
the `f` selected endpoints. Therefore `m<=d_f`. The pairs of fixed chord
lines with disjoint endpoint sets are counted by the three pairings of every
four-set, so

```text
sum_x C(m_x,2) = 3 C(f,4),
```

where the sum ranges over off-arc concurrence points. Since

```text
m-1 >= (2/d_f) C(m,2),
```

their total additional overlap saving is at least `sigma_f`.

Now add one mate line. It contains no fixed selected point, since otherwise
it would contain three points of `K`. It meets all `C(f,2)` fixed chord
lines, and at most `d_f` of those chords can meet it at the same point.
Thus it has at least `j_f` points already in the fixed-chord union and adds
at most `s+1-j_f` new points. Summing this upper bound over the `e` mate
lines is safe even when they meet each other.

Finally, Proposition 1.1 shows that only the `e(e-1)` cross-pair secant
orbits can contribute new isolated fixed points. This proves (2.1).

If `f=0`, the `e` distinct mate lines cover at most `es+1` points: after the
first line, each further line meets the preceding union. If `f=1`, add the
single selected fixed point, which lies on no mate line. Adding the
`e(e-1)` possible cross-pair points gives (2.2). `square`

### Corollary 2.2 — the eight-arc profiles [PROVED]

For a Frobenius-invariant eight-arc, the bound becomes:

| `f` | `e` | `B_(8,f)(s)` | fixed extension guaranteed for odd `s` |
|---:|---:|---:|---:|
| 0 | 4 | `4s+13` | `s>=7` |
| 2 | 3 | `4s+7` | `s>=5` |
| 4 | 2 | `8s-7` | `s>=7` |
| 6 | 1 | `16s-43` | `s>=13` |
| 8 | 0 | `28s-125` | `s>=23` |

Thus `s>=23` is the uniform fixed-extension threshold supplied by this
method. The six-point `C(F_5)` seed in the explicit `s=5,f=6` example from
Round 7 is the classical characteristic-five Clebsch hexagon (Dye 1991,
§1.4, p. 271). The project-specific construction adjoins a conjugate pair and
uses the resulting Frobenius geometry to block all 31 fixed points, so no
uniform theorem covering all smaller odd `s` can be obtained merely by
deleting slack from this inequality.

### Proposition 2.3 — leading-term sharpness [PROVED]

For fixed `(f,e)`, the coefficient

```text
C(f,2)+e
```

of `s` in Theorem 2.1 is asymptotically sharp.

#### Proof

Choose `f` rational points and `e` conjugate pairs on a nonsingular conic
defined over `F_s`. They form a Frobenius-invariant arc. The
`C(f,2)+e` invariant secants are distinct `F_s`-lines. For a fixed number
of distinct lines, their union has

```text
(C(f,2)+e)s + O_(f,e)(1)
```

points. The noninvariant secant intersections alter only the bounded error
term. `square`

The exact constant term and the equality configurations remain open and are
the natural place for a genuinely new stability theorem.

## 3. Conjugate-pair extension

A `tau`-invariant extension need not add a fixed point. It may add a full
orbit `{x,tau(x)}`. This is the stronger and more natural continuation
problem.

Let

```text
M = (C(k,2)-I)/2
  = fe+e(e-1),
```

the number of conjugate pairs of noninvariant old secants.

### Theorem 3.1 — quantitative pair-extension theorem [PROVED]

The number of `F_s`-lines whose extensions contain no point of `K` is
exactly

```text
E = s^2+s+1 - (f(s+1)-C(f,2)+e).                 (3.1)
```

The number of legal conjugate point-pairs extending `K` is at least

```text
N_pair(K)
  >= E ((s^2-s)/2-M)_+.                          (3.2)
```

In particular, `K` has a legal conjugate-pair extension whenever

```text
E>0                 and                 s(s-1)/2>M.  (3.3)
```

#### Proof

The `F_s`-lines through at least one fixed selected point number

```text
f(s+1)-C(f,2),
```

because no such line contains three fixed selected points. Each conjugate
selected pair lies on one further `F_s`-line. These `e` mate lines are
distinct and contain no fixed selected point. This proves (3.1).

An empty `F_s`-line contains `s^2+1` points over `F_(s^2)`, of which `s+1`
are fixed. Its remaining `s^2-s` points form `(s^2-s)/2` conjugate pairs.

An invariant old secant meets this empty line in a fixed point and therefore
destroys none of these candidates. A conjugate pair `{m,tau(m)}` of
noninvariant old secants destroys at most one candidate: its two
intersections with the empty line are conjugate. There are `M` such secant
orbits. This leaves at least `(s^2-s)/2-M` candidates on every empty line.

A surviving pair is a legal extension. Neither new point lies on an old
secant, and their mate line contains no old selected point. Every nonfixed
pair belongs to a unique `F_s`-line, so summing over the `E` lines introduces
no double counting. `square`

### Corollary 3.2 — every invariant eight-arc pair-extends for every prime power `s>=7` [PROVED]

For `k=8`, one has `M<=12`. If `s>=7`, then

```text
s(s-1)/2 >= 21 > 12.
```

Moreover, the number of occupied `F_s`-lines is largest at `f=8`, where

```text
E = s^2-7s+21 > 0.
```

Therefore every Frobenius-invariant eight-arc in `PG(2,s^2)`, for every
prime power `s>=7`, has a legal Frobenius-invariant two-point extension.
No parity assumption enters Theorem 3.1 or the two displayed inequalities.

For the `s=5,k=8,f=6` profile,

```text
E=9,        (s^2-s)/2=10,        M=6,
```

so the theorem guarantees at least

```text
9(10-6)=36
```

legal conjugate-pair extensions, even though a Round-7 example has no legal
fixed extension.

### Corollary 3.3 — obstruction to equivariant completeness [PROVED]

If a Frobenius-invariant arc has no legal conjugate-pair extension, then
either

```text
f(s+1)-C(f,2)+e = s^2+s+1
```

or

```text
M >= s(s-1)/2.
```

The first alternative says every `F_s`-line is occupied by a selected
point; the second requires quadratically many noninvariant secant orbits.
This already forces the size of an equivariantly complete arc to be linear
in `s`.

### Corollary 3.4 — explicit linear lower bound in every characteristic [PROVED]

Let `s` be any prime power. If a Frobenius-invariant arc `K` in `PG(2,s^2)` has
`k<s^2+1` and no legal conjugate-pair extension, then

\[
k\ge 1+\left\lceil\sqrt{2s(s-1)}\right\rceil.       \tag{3.4}
\]

In particular, every equivariantly complete invariant arc in the stated
range `k<s^2+1` has size asymptotically at least `sqrt(2)s`.  In even
characteristic, “nonmaximum” alone is weaker than this range condition.

Here “equivariantly complete” means maximal under addition of an entire
Frobenius orbit. The numerical bound actually uses only the weaker failure
of every free two-point orbit; fixed-point maximality is not assumed.

#### Proof

The number of occupied `F_s`-lines in (3.1) is

\[
O=f(s+1)-\binom f2+e.
\]

Using `k-f=2e` and completing the square gives the exact identity

\[
2O=(s+1)^2+k-(f-s-1)^2.                           \tag{3.5}
\]

There is no half-integrality issue because `f` and `k` have the same parity.
This identity is characteristic-free and does not require a maximum-arc
bound on `f`.

If `O=s^2+s+1`, then (3.5) gives the stronger exact equation

\[
k=s^2+1+(f-s-1)^2.
\]

Thus the hypothesis `k<s^2+1` forces `E>0`, and Corollary 3.3 gives

\[
M=e(k-e-1)\ge\frac{s(s-1)}2.
\]

For fixed `k`,

\[
M\le\left\lfloor\frac{(k-1)^2}{4}\right\rfloor.
\]

Combining the inequalities gives (3.4). `square`

The constant `sqrt(2)` is now an explicit extremal target. To make this a
headline theorem one should either construct invariant arcs with no orbit
extension at size `(sqrt(2)+o(1))s`, or improve the bound by exploiting the
fact that the `M` forbidden candidates arise from one arc rather than from
arbitrary conjugate line pairs.

### 3.5 Orbit-saturation interpretation [EXACT DICTIONARY]

Let the collinearity triples of `PG(2,s^2)` be the edges of a
three-uniform hypergraph, with Frobenius acting as an involution. An
invariant arc is an invariant independent set. It is equivariantly complete
exactly when it dominates every unused Frobenius orbit in the sense that
adjoining that whole orbit creates a hyperedge, either internally through
the orbit's mate line or together with old vertices.

Thus Corollary 3.4 is a geometric **orbit-saturation bound** for invariant
independent sets. It is not an instance of ordinary independent domination:
a free orbit contains two vertices and can fail internally, a feature lost
in the quotient graph or hypergraph. This framing connects the theorem to
symmetric saturation problems while preserving the specific geometric datum
responsible for the `sqrt(2)` constant.

## 4. Saturation spectra and mixed-cover stability

For admissible `f`, define the fixed saturation spectrum

```text
beta_f(s)
  = min { |K| : K is a tau-invariant arc,
                  |K intersect B|=f,
                  Blk_B(K)=B }.
```

One may also define `beta_f^eq(s)` by requiring that `K` admit neither a
fixed-point extension nor a conjugate-pair extension.

The most useful concrete questions are:

1. Determine `beta_f(s)` for `f=0,1,2` and obtain asymptotics for fixed `f`.
2. Classify equality in Theorem 2.1 for at least one infinite profile.
3. Prove stability: if the mixed cover leaves only `O(1)` holes, show that
   the invariant secants are close to a pencil, conic-chord arrangement, or
   another explicit family.
4. Determine whether the isolated `e(e-1)` cross-pair points can fill the
   structured holes forced by a near-minimal partial line cover.
5. Determine the minimum size of an equivariantly complete arc, where the
   pair-extension obstruction from Corollary 3.3 supplies a second,
   independent lower-bound mechanism.

The relevant imported machinery concerns holes and stability in partial
covers, particularly Dodunekov, Storme, and Van de Voorde,
[Partial covers of `PG(n,q)`](https://doi.org/10.1016/j.ejc.2009.07.008).
Those results apply to the line part of the cover; a new argument must still
exploit or control the isolated conjugate-secant intersections. Merely
quoting a general line-cover bound does not resolve the mixed problem.

## 5. Prime Galois degree and the quadratic anomaly

Let `L=F_(s^m)`, `F=F_s`, where `m>=3` is prime, and let `tau` generate the
Galois group. Let `K` be a `tau`-invariant `k`-arc with `f` fixed selected
points.

### Theorem 5.1 — prime-degree fixed-extension bound [PROVED]

No invariant secant contains a nonfixed selected point. Consequently, the
only invariant secants are the `C(f,2)` fixed-fixed chords. Every remaining
secant orbit has length `m` and blocks at most one point of `PG(2,s)`. Hence,
apart from the trivial one-point configuration,

```text
|Blk_PG(2,s)(K)|
  <= C(f,2)(s+1)
     + (C(k,2)-C(f,2))/m.                        (5.1)
```

If the right side is less than `s^2+s+1`, a fixed extension exists.

#### Proof

If an invariant line contained a nonfixed selected point, it would contain
that point's entire `m`-element orbit. Since `m>=3`, this contradicts the
arc condition. Thus only fixed-fixed secants are invariant.

All other secants have line orbit of length `m`. If a fixed point lies on
one member of such an orbit, it lies on every conjugate member, so the orbit
contributes at most that one fixed point. Counting line orbits proves (5.1).
`square`

This isolates a useful quadratic distinction, but its prime-degree proof is
only an orbit--stabilizer observation and is not an independent headline
novelty. Only in degree two can a
nonfixed point orbit itself be a secant and thereby block an entire fixed
line. For composite `m`, the expected replacement is a divisor- or
subfield-lattice decomposition: point and line orbits of each proper size
are charged to the corresponding intermediate subgeometry.

The quadratic standard-coordinate statements also extend to an arbitrary
projective semilinear involution with nontrivial quadratic field part and a
Baer fixed locus, by the matrix-Hilbert-90 conjugacy used in Round 7. A
classical normal-form reference is
[Semilinear transformations over finite fields are Frobenius maps](https://doi.org/10.1017/S0017089500020164).

## 6. Higher-dimensional caps

Let `K` be a Frobenius-invariant cap in `PG(n,s^2)` and retain the quadratic
notation `f,e,I,M`.

### Theorem 6.1 — fixed-subgeometry extension [PROVED]

One has the universal bound

```text
|Blk_PG(n,s)(K)| <= I(s+1)+M.                    (6.1)
```

Therefore a fixed extension exists whenever

```text
(s^(n+1)-1)/(s-1) > I(s+1)+M.                   (6.2)
```

The simpler profile-free condition

```text
(s^(n+1)-1)/(s-1) > C(k,2)(s+1)                 (6.3)
```

is sufficient. In particular, for fixed `n>=3`, every such cap with

```text
k = o(s^((n-1)/2))
```

has a fixed extension.

#### Proof

Each invariant secant contributes an `F_s`-line of `s+1` fixed points. A
noninvariant secant and its conjugate either are skew or meet in at most one
fixed point. Summing these contributions gives (6.1). The fixed subgeometry
has `(s^(n+1)-1)/(s-1)` points, proving (6.2). Inequality (6.3) is a coarser
bound obtained by charging every selected pair an entire fixed line. The
asymptotic statement follows by comparing `O(k^2s)` with `Theta(s^n)`.
`square`

The plane-specific savings `sigma_f` and `j_f` from Theorem 2.1 must not be
transferred automatically to `n>=3`: relevant fixed lines may be skew.

## 7. MDS lengthening and Galois rank

The higher-rank coding analogue concerns projective arcs, not merely caps.
Let `L/F` be a finite Galois extension and let `A` be a Galois-invariant
`n`-arc in `PG(r-1,L)`, so every `r` points of `A` are independent. For an
`(r-1)`-subset `S` of `A`, let

```text
H_S = span_L(S)
```

and choose a normal vector

```text
h_S=(h_1,...,h_r).
```

Define

```text
rho(S) = dim_F span_F{h_1,...,h_r}.
```

### Theorem 7.1 — Galois-rank section formula [PROVED]

The fixed section of `H_S` is

```text
H_S intersect PG(r-1,F) isomorphic to PG(r-rho(S)-1,F),  (7.1)
```

with a negative projective dimension interpreted as the empty set. All
hyperplanes in the Galois orbit of `H_S` have the same fixed section.

Consequently, writing

```text
theta_j(s)=(s^(j+1)-1)/(s-1),       theta_(-1)(s)=0,
```

the number of legal fixed lengthening columns is at least

```text
theta_(r-1)(s)
  - f
  - sum_[S] theta_(r-rho(S)-1)(s),                  (7.2)
```

where the sum is over Galois orbits of forbidden `(r-1)`-subsets and `f` is
the number of already selected fixed columns.

#### Proof

For a fixed vector `x in F^r`, membership in `H_S` is the equation

```text
h_1 x_1 + ... + h_r x_r = 0.
```

As an `F`-linear map from `F^r` to `L`, its image is precisely the
`F`-span of the coefficients `h_i`, of dimension `rho(S)`. Its kernel has
dimension `r-rho(S)`, proving (7.1) after projectivization.

If a fixed point belongs to one conjugate of `H_S`, applying Galois
automorphisms shows that it belongs to all of them. Thus each hyperplane
orbit contributes its fixed section only once. The union bound gives (7.2).
`square`

For `r=3` and a quadratic extension, `rho=1` gives a fixed line and `rho=2`
gives a fixed point. Thus Proposition 1.1 is exactly the rank-three case of
this Galois-rank decomposition.

### 7.2 Exact rank-metric identification [PROVED DICTIONARY]

The statistic `rho(S)` is not a new kind of rank: it is exactly the
**rank weight** over `L/F` of the normal vector `h_S`. In the standard
rank-metric notation,

```text
wt_R(h_S)=dim_F span_F{h_1,...,h_r}=rho(S).
```

Accordingly, (7.1) is the projectivized rank-nullity identity for the
`F`-linear functional

```text
x in F^r |-> h_S dot x in L.
```

Rank weights over finite Galois extensions and their support spaces are
classical; see Jurrius and Pellikaan,
[On defining generalized rank weights](https://arxiv.org/abs/1506.02865).
Theorem 7.1 is therefore a translation lemma, not a standalone novelty
claim.

The candidate bookkeeping object is the **forbidden-normal rank enumerator**

\[
W_A(j)=\#\{[S]:\operatorname{wt}_R(h_S)=j\},        \tag{7.3}
\]

where `[S]` runs over Galois orbits of forbidden `(r-1)`-subsets. As stated,
this is only the rank-weight distribution of a distinguished structured
multiset, not yet a new invariant or a rank-metric code. Formula (7.2)
depends first on this enumerator and then on the overlap pattern of the
associated rank-support kernels; `W_A` alone does not determine the exact
legal-column count. Computing it together with the required intersection
data for a recognized MDS family, and extracting a new exact rational-
lengthening theorem, is the novelty gate.

For a normal rational curve with affine parameters `t_i`, a normal vector
to the hyperplane through `r-1` curve points is, up to scale, the coefficient
vector of

\[
\prod_{i=1}^{r-1}(T-t_i),                           \tag{7.4}
\]

with the usual homogeneous convention at infinity. Thus `W_A` becomes the
rank-weight distribution of vectors of elementary symmetric functions of
Galois-stable parameter subsets. This is a concrete bridge among GRS
lengthening, rank-metric codes, and finite-field symmetric-polynomial
problems.

In coding language, (7.2) counts `F_s`-rational projective columns that can
lengthen an MDS code over `F_(s^m)` while preserving its MDS property. This
connects the extension problem to subfield codes and Galois descent. Useful
background includes the Ball–Lavrauw
[survey on arcs](https://arxiv.org/abs/1908.10772) and the Lavrauw–Van de
Voorde [field-reduction survey](https://arxiv.org/abs/1310.8522). The
prospective new work is not the code/arc dictionary itself, but the use of
the complete `rho`-profile to control rational lengthenings.

### 7.3 Arithmetic secants and closed points [CONCEPTUAL IDENTIFICATION]

A Frobenius orbit of geometric points is a closed point over `F`, of degree
equal to the orbit length. In the quadratic plane case, the mate line of a
conjugate pair is the `F`-rational span of a degree-two closed point. Hence
the distinction in Proposition 1.1 is the arithmetic distinction between:

- split secants, with two `F`-rational endpoints;
- nonsplit secants, whose endpoints become rational only over `L`; and
- conjugate nonrational secants whose common intersection descends to `F`.

For Veronese and normal-rational-curve configurations this is also a
field-of-decomposition question for symmetric tensors or binary forms:
rational points may admit a secant decomposition only after extending the
base field. The quadratic anomaly is therefore a finite-geometric instance
of rational versus geometric tensor rank. A serious result in this lane
would count or classify the rational forbidden locus by decomposition field;
the identification alone is not a theorem about tensor rank.

## 8. Bridge to completion-core rigidity

Let `C` be a nonsingular conic defined over `F_s`, let

```text
A = C(F_s) minus D,          |D|=d,
```

and extend `A` by `e` conjugate selected pairs to obtain a
Frobenius-invariant arc `K` in `PG(2,s^2)`.

### Theorem 8.1 — holes surviving a nonfixed perturbation [PROVED]

The nonfixed selected pairs can block at most

```text
2e+e(e-1)=e(e+1)
```

points of `D`. Therefore

```text
d>e(e+1)
```

guarantees a legal fixed extension lying in `D`.

If additionally

```text
d < (s-1)/2,
```

then completion-core rigidity says that, before adding the nonfixed pairs,
every off-conic fixed point is already blocked by `A`. In this regime

```text
e(e+1)<d<(s-1)/2                             (8.1)
```

is an exact robustness statement of the intended kind: the legal fixed
reservoir is localized to the conic holes, and the `e` conjugate pairs
cannot seal it.

#### Proof

Each mate line meets the conic in at most two points and hence blocks at most
two holes. The `e(e-1)` cross-pair secant orbits contribute at most one fixed
point each.

A fixed-to-nonfixed secant cannot contain a hole `x in D`. If the line
through a selected fixed conic point and `x` contained a selected nonfixed
point `P`, it would be an `F_s`-line and would also contain `tau(P)`, giving
three selected collinear points. Finally, a chord through two points of `A`
cannot contain a third conic point. These exhaust the possible blockers of
`D`. `square`

The same question can be posed for normal rational curves, quadrics, and
other varieties whose rational-point deletions have a known completion
distance. The required new input is a bound on how many deleted rational
points one nonfixed Galois orbit can block.

## 9. Further settings, ranked by promise

### 9.1 Composite extension degree [HIGH PROMISE]

Replace the prime-degree dichotomy by an orbit decomposition over the lattice
of intermediate fields. A useful theorem would charge every invariant
forbidden flat to the smallest subfield over which it is defined and every
remaining orbit by its exact Galois length. The kill test is whether the
result improves the naive division by the smallest prime divisor of the
extension degree on an explicit tower such as `F_(s^6)/F_s`.

### 9.2 Partial ovoids and polar spaces [MEDIUM–HIGH PROMISE]

For a Galois-invariant partial ovoid, a candidate is forbidden by polar
hyperplane sections rather than ordinary secants. The coefficient-rank
argument of Theorem 7.1 should still determine the dimension of a fixed
linear section in the symplectic case. Quadratic and Hermitian spaces add
radical and discriminant types. A worthwhile result must give an explicit
extension threshold or equality family, not merely a union bound.

### 9.3 Field reduction and linear sets [MEDIUM PROMISE]

Under field reduction, a Galois orbit becomes a structured collection of
spread elements. Equivariant extension may translate into avoiding a family
of subspaces in the associated Desarguesian spread or linear set. The
Lavrauw–Van de Voorde survey cited above is the natural entry point. The
success gate is a statement stronger than the coordinate proof—for example,
an extension criterion depending only on rank or weight distribution of the
linear set.

### 9.4 Equivariant matroid completion [HIGH CONCEPTUAL, HIGH RISK]

One may define fixed- and orbit-extension spectra for a representable matroid
with a cyclic semilinear action. Theorem 7.1 suggests that representability
supplies more information than an abstract group action: the Galois rank of
each forbidden flat controls its fixed trace. This becomes worthwhile only
if it yields a theorem for a recognized matroid or code family rather than
an abstract reformulation.

## 10. Publication plan and risk audit

### Realistic external interest and citability

At its current stage, this is best assessed as a credible specialist
finite-geometry paper rather than a result with broad combinatorics reach.
The likely audience is researchers working on arcs and complete arcs,
semilinear group actions, finite-field descent, and MDS-code extension.

The components have different external value:

| component | likely role | likely citability |
|---|---|---|
| Exact mixed-cover dictionary | reusable setup | modest but durable if later authors study invariant saturation |
| Explicit `B_(k,f)(s)` bound | proof machinery | low–moderate; constants are useful but not memorable |
| Conjugate-pair extension theorem | principal theorem | highest within finite geometry because it gives a clean orbit-valued continuation criterion |
| `sqrt(2)s` orbit-saturation bound | strongest extremal corollary | potentially headline-level if sharpness or a strict improvement is proved |
| Prime-degree quadratic-anomaly theorem | conceptual extension | moderate if developed across subfield towers |
| Galois-rank section formula | classical rank-weight dictionary | infrastructure; value comes only from computing a forbidden-normal rank enumerator for a real MDS family |
| Near-conic robustness theorem | companion proposition | useful cross-reference, unlikely to carry a paper alone |

Without a sharpness or stability theorem, a referee could reasonably regard
the package as elegant but elementary counting. In that form it is still
plausible as a short note. Constructing orbit-saturated arcs at
`(sqrt(2)+o(1))s`, proving a strict collision improvement, determining one
nontrivial `beta_f(s)` family, or deriving a new rank-weight lengthening
result for a recognized MDS/GRS family would raise it to a substantially
stronger standalone paper.

The most likely long-term uses are:

1. lower bounds for fixed-saturated and fully equivariantly complete arcs;
2. pruning and validating classifications of semilinear-invariant arcs;
3. counting subfield-rational lengthening columns of MDS codes;
4. transferring extension arguments through field reduction to linear sets
   or spread configurations; and
5. distinguishing genuine equivariant completeness from the much weaker
   failure of fixed-point extension.

It is unlikely to be highly cited solely through the cap-game connection:
the result controls legality, not game value. Its citation prospects depend
on presenting it in the established language of Galois-invariant arcs,
complete arcs, rational lengthening, and saturation rather than as a lemma
extracted from a game proof.

### Recommended theorem package

1. Proposition 1.1: the exact mixed-cover dictionary.
2. Theorem 2.1: the corrected arbitrary-`(k,f)` fixed-point bound.
3. Theorem 3.1: the quantitative conjugate-pair extension theorem, as the
   headline.
4. Corollary 3.4: the explicit `sqrt(2)s` orbit-saturation bound.
5. Corollary 3.2 and the `s=5,f=6` contrast.
6. One sharp construction, equality theorem, or stability improvement for
   the orbit-saturation constant.
7. The prime-degree and rank-weight formulations as extensions or a second
   section, depending on length.

A plausible title is:

> **Equivariant extensions of Galois-invariant arcs over finite fields**

### Required gates before a novelty claim

1. Search MathSciNet, Zentralblatt, monographs, and the finite-geometry
   literature for Galois-invariant/Baer-invariant arc extension and
   saturation results. Public search found no theorem packaging fixed and
   orbit-valued extensions in the form above, but that is not a sufficient
   novelty audit.
2. Compare Theorem 2.1 against the sharp partial-cover literature, including
   all small-order exceptions.
3. Determine whether the `sqrt(2)` constant is attainable. The first kill
   test is a small-`s` census of pair-saturated arcs classified by
   `(f,e,M,E)`; the theoretical alternative is a collision theorem forcing
   `M` below its unconstrained maximum.
4. Recheck the semilinear normal-form statement against its published
   hypotheses; do not silently identify every semilinear element with a Baer
   involution.
5. Keep “arc” and “cap” distinct in dimensions above two. The MDS theorem is
   about projective arcs, whereas Theorem 6.1 is about caps and secants.
6. Keep the game boundary explicit: no theorem here supplies a P-valued
   child.

The lowest-risk next move is the orbit-saturation sharpness test while a
finite-geometer performs the specialist bibliography check. The completion-
core material should not be merged into this paper unless both are first
specialized to one Galois-stable NRC/GRS family; otherwise the mature
defining-set language dilutes the more specific orbit theorem.
