# C408 — pointed-profile and syndrome-multiplicity forgetting gate

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; GLOBAL C403/C407 PACKAGE FORGETS POINTED REPAIR IN EVERY q>=7; q=7 ALSO SEPARATES SYNDROME MULTIPLICITY, WHILE THE WEIGHTED ADJOINT RECOVERS THE SCALAR-TOWER DISTINCTION`

## Result in one line

The cheap direct arrangement census is negative, but a dual external-line-closure
construction passes the gate: two six-point complements have the same complete global
line-section histogram and therefore the same entire base-field C403/C407 code package,
yet their coordinate repair profiles differ.  At q=7 their excluded-syndrome secant
multiplicities also differ.  Their original arrangements have the same characteristic
polynomial, while their weighted-adjoint polynomials separate them over `F_49`.

No novelty or priority claim is made without a dedicated literature audit.

## The invariant boundary

For a spanning projective complement `B`, put

```text
f_s=#{L in PG(2,q)^dual: |B cap L|=s}.
```

C403/C407 prove that `f_s` determines the ordinary Hamming enumerator, complete primal
and dual generalized-weight hierarchies, size-three/four circuit and minimal-dual-support
counts, full complement-column Tutte polynomial, aggregate coset-leader distribution,
and total minimal-primal-codeword count.

For `P in B`, however, exact locality-two data are pointed:

```text
R(P) =sum_(L through P) binom(s_L-1,2),
Av(P)=sum_(L through P) floor((s_L-1)/2).
```

For an excluded syndrome direction `Q notin B`, the weight-two representation count is

```text
mu(Q)=sum_(L through Q) binom(s_L,2).
```

C408 proves that the global histogram does not determine these pointed distributions.

## External-line closure lemma

Let `B subset PG(2,q)` have six points and `q>=7`.  Let `A_B` be the arrangement of
all projective lines disjoint from `B`.  Then `B` is exactly the projective complement
of `A_B`.

Indeed, fix `Q notin B`.  The `q+1` lines through `Q` are blocked by at most the six
points of `B`, one line per point.  Since `6<=q`, at least one line through `Q` misses
`B`, so every outside point lies on an arrangement line.  No arrangement line meets
`B` by definition.

The arrangements used below are essential.  For any projective point `Q`, there are
`q^2` lines not through `Q`.  Each point of `B` lies on at most `q` of them, and
`6q<q^2` for `q>=7`; hence some external line avoids both `B` and `Q`.  Thus no point
lies on every line of `A_B`.

This lemma reverses the failed first attack: instead of choosing a few arrangement
lines and accepting a large rigid complement, choose a small flexible complement and
close it by all external lines.

## Uniform six-point trade

For every prime power `q>=7`, construct two spanning six-point sets.

- `B_dis` consists of three points on each of two distinct lines, excluding their
  intersection.  Its two three-secants are disjoint on `B_dis`.
- `B_sh` starts with two lines meeting at a selected point of `B_sh`, adds two further
  points on each line, and then adds a sixth point off every line determined by a pair
  of the first five points.  There are at most six forbidden lines, whose union has at
  most `6q+1<q^2+q+1` points, so such a sixth point exists.

Both configurations have exactly two three-secants and no line containing four points.
Pair and incidence counting gives the identical line-section histogram

```text
f_3=2,
f_2=binom(6,2)-2binom(3,2)=9,
f_1=6(q+1)-2f_2-3f_3=6q-18,
f_0=q^2+q+1-f_1-f_2-f_3=q^2-5q+8.
```

On a section of size two, neither `R` nor `Av` receives a contribution.  A three-section
contributes one to both values at each of its points.  Therefore

```text
B_dis: (R(P),Av(P)) = (1,1)^6,

B_sh:  (R(P),Av(P)) = (0,0),(1,1)^4,(2,2).
```

The two essential arrangements `A_(B_dis)` and `A_(B_sh)` consequently have the same
global `f_s` and every base-field invariant in the C403/C407 chain, but different exact
coordinate repair and availability profiles.  This proves the all-field bronze
second-forgetting theorem.

## Exact q=7 witness

Using affine triples `(1,x,y)`, the certificate fixes

```text
B_dis={(1,0,0),(1,1,0),(1,2,0),(1,3,1),(1,4,1),(1,5,1)},

B_sh ={(1,0,0),(1,1,0),(1,2,0),(1,0,1),(1,0,2),(1,1,2)}.
```

Both have

```text
(f_0,f_1,f_2,f_3)=(22,24,9,2)
```

and hence the same projective `[6,3,3]_7` weight enumerator

```text
1+12z^3+54z^4+144z^5+132z^6.
```

Their excluded-syndrome multiplicity distributions differ:

```text
B_dis: mu=0^4,1^24,2^12,3^10,6^1,
B_sh:  mu=0^5,1^22,2^14,3^6,4^4.
```

Thus Door 2 also passes exactly at q=7.  In particular, the global coset-leader
enumerator agrees while the number of weight-two representations of individual
syndromes does not.

## Original characteristic agrees; weighted adjoint separates the tower

Both external-line arrangements have `N=f_0=22` and characteristic polynomial

```text
chi_A(t)=t^3-22t^2+125t-104.
```

More generally the uniform construction has

```text
N=q^2-5q+8,
sum_X(m(X)-1)=q^3-5q^2+2q+13,
```

and the rank-three characteristic-polynomial formula gives the same polynomial for the
two arrangements.  The second identity follows equivalently by inserting
`chi_A(q)=6(q-1)` into the finite-field complement count.

The stronger scalar-extension gate does not pass.  The checker computes the universal
projective weighted-adjoint depth counts as polynomials in an extension-field size `Q`.
At q=7 the first differing coefficients are

| depth | disjoint-three-secants | shared-point-three-secants |
|---:|:---|:---|
| 1 | `4Q-28` | `5Q-35` |
| 2 | `24Q-168` | `22Q-154` |
| 4 | `2Q-14` | `4Q-28` |
| 5 | `Q-7` | `0` |

They all vanish at `Q=7`, explaining the common base-field histogram, but differ at
`Q=49`.  An independent `F_49=F_7[u]/(u^2-3)` replay directly enumerates all 2,451
projective points and obtains depth-one counts `168/210` and depth-two counts
`1008/924`.  Since `N`, `chi_A`, adjoint rank, and indexed-copy conventions are fixed,
the unequal depth polynomials are exactly unequal parallel-copy coboundary polynomials;
therefore the scalar-extension Hamming enumerator towers diverge at degree two.

This is the clean positive boundary:

```text
base-field global code package
  forgets pointed repair and syndrome multiplicity,

weighted-adjoint scalar-extension package
  detects the difference.
```

## Failed direct census and why it mattered

Before the closure construction, the checker exhausted small arrangements directly:

| field/scope | subsets tested | retained `(N,B)` pairs | `f_s` buckets | pointed collisions |
|:---|---:|---:|---:|---:|
| all q=3 arrangements, `3<=N<=13` | 8,100 | 468 | 2 | 0 |
| all q=5 arrangements, `3<=N<=6` | 942,152 | 830,800 | 17 | 0 |

An independent implementation recognizes essentiality by empty common line intersection
and spanning by noncontainment in a line, then reproduces every count.  The negative was
not evidence against the door; it showed that small-`N` arrangements leave complements
too large and rigid.  External-line closure moves to large `N` and small flexible `B`.

## Other viable attacks

### Classical incidence and design trades

The successful construction is the smallest line-incidence trade: preserve the number
of three-secants but change how those secants meet the point set.  Larger Pasch-like or
block-design trades could preserve the full `f_s` vector while modifying coordinate
degrees, secant concurrency, or failure robustness.  Any priority claim would require a
focused trade/design literature audit.

### Moduli inside a fixed collinearity type

For six or more points, cross-ratio or projective-moduli changes can preserve every line
size while changing concurrence among ordinary secants.  This cannot further separate
`R/Av` when their values depend only on the named large sections, but it is a promising
attack on the finer `mu(Q)` distribution and on heterogeneous failure profiles.

### Balanced incidence switches for a silver collision

The q=7 trade changes the weighted-adjoint polynomial, so it does not preserve the
scalar-extension tower.  A genuine silver attack should perform a two-switch in the
point--test-line incidence bipartite graph that preserves both global depth counts and
the universal adjoint intersection ledger while changing which complement points see
which depths.  This is analogous to degree-preserving graph/design switching and is a
better target than a larger blind census.

### Code-first canonical search

One can enumerate projective `[n,3]_q` codes by canonical point sets, hash first by
weight enumerator, and only then apply the external-line-closure test.  This searches
the relevant small-complement regime directly and avoids enumerating the much larger
space of arrangements.  A positive witness remains exactly checkable even if the
search uses canonical augmentation or seeded heuristics.

### Higher-rank weighted adjoints

In higher dimension the same question becomes whether Grassmannian section histograms
forget pointed repair geometry.  Liang--Wang--Zhao already prove that `k`-adjoint
decompositions classify `k`-dimensional restriction matroids (arXiv:2412.06633v2;
cached full text SHA-256
`59050f6a6ca38f1d9fdf7c747612814cde26e2b7aa3ac777fe6687624c11eef7`).
Any new theorem must be the finite-field weighting, puncturing, and code-operational
specialization, not the restriction classification itself.

## Literature boundary

The general multiplicity notion is classical: Bartoli--Davydov--Giulietti--Marcugini--
Pambianco define `(1,mu)`-saturating sets by secants counted with multiplicity and
translate them to covering codes (arXiv:1505.01426, consulted at abstract level).
C408 claims neither that definition nor generic locality/availability terminology as
new.  No dedicated search for the exact external-line-closure trade or its
arrangement-code formulation was run, so the theorem carries no novelty or priority
wording.

## Evidence

Run from `/home/tavis/src/othello`:

```bash
python3 -B notes/2026-07-20-c408-pointed-profile-forgetting-gate.py --check
python3 -B notes/2026-07-20-c408-pointed-profile-forgetting-gate-replay.py
sha256sum -c notes/2026-07-20-c408-pointed-profile-forgetting-gate.sha256
```

Intentional regeneration is:

```bash
python3 -B notes/2026-07-20-c408-pointed-profile-forgetting-gate.py --write
```

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary checker `.py` | 16,271 | `357a271ecc194163f2a96c0e5c44b23b950c75313bdd660ea21d9fce39d1cce7` |
| independent replay `.py` | 9,530 | `89d07eea1079006fba9b447066bd924f36ff95b5de977e659675571c1372a632` |
| certificate `.json` | 10,089 | `2d29cc235b22944589d813f73660597c12b9745152055cadcee3e2ff0a746ebd` |

The primary path performs both exhaustive censuses, verifies the explicit q=7 closure,
computes both pointed distributions, constructs the original and weighted-adjoint
arrangements, derives their universal depth-count polynomials, and evaluates those
polynomials directly at q=7 as an invariant check.  The replay imports no primary code,
reconstructs the two finite planes by incidence, repeats the exhaustive negatives,
rebuilds the q=7 external arrangements, and directly enumerates the `F_49` adjoint
depths.

The trusted boundary is exact prime-field and quadratic-extension arithmetic,
projective incidence, complete finite enumeration on the stated domains, and the
elementary all-field counting proof above.  The bundle does not prove novelty, a
same-scalar-tower pointed collision, or a classification of every operational invariant
forgotten by `f_s`.

## Hand-back

C408 passes Doors 1 and 2 and closes the bounded gate.  It adds an all-`q>=7`
second-forgetting theorem for coordinate repair, an exact q=7 syndrome-multiplicity
separation, and a q=7 demonstration that the weighted adjoint is precisely the stronger
scalar-extension repair.  A silver same-tower collision remains unallocated and should
begin with balanced incidence switching, not a larger raw census.  C406 otherwise
returns to the front of the crowns queue.
