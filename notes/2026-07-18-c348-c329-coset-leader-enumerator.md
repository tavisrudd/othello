# C348: C329 coset leaders, deep holes, and MDS extensions

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `NARROW-EXACT-REDUCTION; INFINITY EXTENSION FAMILY`

## Signed decision

The proposed parameter-free all-field deep-hole count does not follow from C329--C330 and the
Blokhuis--Pellikaan--Szonyi double-point theorem does not apply to the reducible four-layer carrier.
The exact extended coset-leader enumerator nevertheless reduces to one intrinsic integer, the
base-field projective deep-hole count `h(A)`, and the known `F^+` symmetry reduces its unknown affine
part to an exact orbit count.  C330 completely determines the infinity part and yields a new uniform
extension theorem: every one- or two-element subset of the uncovered infinity directions extends
the C329 non-GRS MDS code, while no three-element subset does.

**Novelty correction (2026-07-19):** the reduction of the scalar-extension enumerator to the
base-field complement count is a rank-three specialization of Jurrius--Pellikaan's general
derived-arrangement formula, not new enumerator theory.  The family-specific content begins with
the `F^+` decomposition, exact seven-map infinity locus, moduli behavior, and simultaneous
non-GRS extension complex.

A complete `Q=8` normalized-parameter scan finds no arc.  A deterministic `Q=32` search finds three
genuine four-layer arcs and exhaustively classifies all `1,049,601` projective syndromes of each.
Their deep-hole counts are respectively `936`, `965`, and `900`, with affine contributions `128`,
`160`, and `96`.  Thus the seven direction maps are not the full deep-hole locus, and even within
the same collision-free normal-form architecture the enumerator is not determined by `Q` alone.
These fixtures are below C329's sufficient existence threshold and certify the normalized
architecture, not that C329's proof-only Chebotarev selection realizes each fixture on its large-field
tail.  Accordingly, this is a bounded stop for a uniform C329 count, not a theorem that the
large-field output locus has three distinct enumerators.

## Exact extended-enumerator reduction

Put `q=|E|=Q^2`, `n=4Q`, and let `A` be any C329 arc in `PG(2,E)`.  Use its columns as a parity-check
matrix for the `[n,n-3,4]_E` code `C_A`.  Let

```text
h(A) = |{P in PG(2,E) : P lies on no A-secant}|,
B    = binom(n,2).
```

For the scalar extension to a field of size `T=q^m`, let `alpha_i(T)` count cosets of minimum weight
`i`, and put `a_i(T)=alpha_i(T)/(T-1)` for `i>0`.  Then the complete extended coset-leader weight
enumerator is

```text
alpha_0(T) = 1,
a_1(T)     = n,
a_2(T)     = B(T-q) + q^2+q+1-n-h(A),
a_3(T)     = T^2+T+1-a_1(T)-a_2(T)
           = T^2+(1-B)T+Bq-q^2-q+h(A),
alpha_i(T) = (T-1)a_i(T),                 i=1,2,3.
```

Indeed, projective syndromes of weights one, two, and three are respectively the columns, points on
an `A`-secant but not in `A`, and the remaining projective points.  Any three columns are a basis,
so there is no larger leader weight.  Over a proper scalar extension, a non-`E`-rational point lies
on at most one `E`-rational line: two such lines meet in an `E`-rational point.  Each of the `B`
secants therefore contributes exactly `T-q` new weight-two points, while the base-field weight-two
count is `q^2+q+1-n-h(A)`.  The formulas sum to `T^3`, as required for all syndromes.

At the base field this specializes to

```text
alpha_1(q)=(q-1)n,
alpha_2(q)=(q-1)(q^2+q+1-n-h(A)),
alpha_3(q)=(q-1)h(A).
```

Thus an exact extended enumerator is equivalent to the single exact base-field count `h(A)`; moment
identities do not determine it.

## Exact deep-hole decomposition under the additive action

In C337's recovered normal form,

```text
A={P(t,a):t in F} union {P(t,b):t in F}
  union {P(omega+t,0):t in F} union {P(rho*omega+t,0):t in F},
P(x,k)=[1:x:x^2+k].
```

The projectivities

```text
T_mu[X:Y:Z]=[X:Y+mu X:Z+mu^2 X],       mu in F,
```

preserve `A`.  They fix the line at infinity pointwise and act freely on the affine plane.  Hence
the deep-hole locus has the exact invariant decomposition

```text
h(A)=Q M(A)+u(A),
```

where `M(A)` is the number of affine deep-hole `F^+`-orbits and `u(A)` is the number of infinity
holes.  One explicit affine-orbit coordinate system is

```text
(xi,eta)=(u^Q+u, v+u^2) in F x E
```

for `[1:u:v]`; both entries are invariant under `T_mu`, and together they separate the orbits.
This reduces the unknown affine classification from `Q^4` points to `Q^3` orbit representatives,
but does not make its count parameter-free.

On C329's `Delta_R=0` slice, C330 gives the exact infinity-direction set

```text
D(A)=F^*
 union {p:p in (1+rho)omega+F}
 union {p+a/p:p in omega+F}
 union {p+b/p:p in omega+F}
 union {p+a/p:p in rho omega+F}
 union {p+b/p:p in rho omega+F}
 union {p+(a+b)/p:p in F^*}.
```

Therefore

```text
U(A)={[0:1:m]:m in E\D(A)},
u(A)=Q^2-|D(A)| >= Q^2-7Q+2,
```

and these are exactly, not merely a subset of, the infinity deep holes.  The full deep-hole locus is
the disjoint union of `U(A)` and the `M(A)` free affine orbits.

## One- and simultaneous-column extensions

For every `s in U(A)`, the point set `A union {s}` is an arc.  For distinct `s,t in U(A)`, their
joining line is the line at infinity and contains no point of the affine set `A`, so
`A union {s,t}` is also an arc.  Any three members of `U(A)` are collinear.  Consequently the
extension complex induced on `U(A)` is exactly

```text
{S subset U(A): |S|<=2}.
```

It supplies exactly `u(A)` one-column and `binom(u(A),2)` two-column extensions, and no extension by
three infinity columns.  The resulting codes have parameters

```text
[4Q+1,4Q-2,4]_E,       [4Q+2,4Q-1,4]_E.
```

Both families are non-GRS: if an extension were GRS or extended GRS, shortening at the new
coordinate or coordinates would make the original C329 code GRS or extended GRS, contradicting
C337.  This is precisely the deep-hole/MDS-extension mechanism of Wu--Ding--Chen and the
non-GRS-preserving shortening argument used by Li--Lu--Ling--Lam; the new content is the explicit
uniform infinity family and its exact rank-two simultaneous-extension complex.

The full extension complex also contains affine deep holes.  It is not determined by C330's seven
maps.  For any fixed `A`, the adjacent checker does compute every one- and two-column face: a pair
of holes is rejected exactly when its joining line contains a point of `A`.  No uniform all-field
classification of the affine faces is claimed.

## Why the double-point import stops

Blokhuis--Pellikaan--Szonyi study a codimension-four GRS code whose projective system is the full
rational twisted cubic in `PG(3,q)`.  A line determines a single separable simple rational morphism
from the irreducible parameter curve; its double-point scheme controls containment in a three-secant
plane, and Hasse--Weil handles the remaining line orbit for `q>=23`.

C329 instead uses four selected `F`-cosets on three conics over `E`, with two cosets on one carrier.
Projection produces same-component and cross-component collision correspondences, not one simple
morphism from an irreducible rational curve.  The source theorem's irreducible-domain and simple-
morphism hypotheses therefore fail before any genus estimate.  The method remains a useful analogy,
but importing its absolute-irreducibility conclusion would be invalid.  The `Q=32` affine-hole
census independently shows why an infinity-only surrogate cannot replace the missing analysis.

## Deterministic certificate

The adjacent pure-Python checker uses `GF(32)=GF(2)[x]/(x^5+x^2+1)` and
`GF(1024)=GF(32)(omega)`, `omega^2+omega+1=0`.  It first exhausts all 10,416 normalized `Q=8`
parameter triples satisfying `a+b notin F` and finds no arc.  At `Q=32` it draws 4,096 triples in a
fixed ANSI-C-LCG order, tests all 3,980 draws meeting the normalized conditions, and retains up to
the first four distinct arcs (three exist in that prefix).  For every
fixture it:

1. requires all `binom(128,2)=8,128` secant lines to be distinct;
2. enumerates every point of `PG(2,1024)` and its secant multiplicity;
3. checks the first two incidence moments against the closed combinatorial formulas;
4. independently compares its infinity holes with the seven reciprocal images; and
5. counts all one- and two-hole extension faces by pencils through the 128 arc points.

The three exact syndrome summaries are:

| `rho`; `a`; `b` as basis pairs | affine holes | infinity holes | all holes | valid two-hole extensions | base projective weight two |
|---|---:|---:|---:|---:|---:|
| `9`; `(27,13)`; `(8,24)` | 128 | 808 | 936 | 421,772 | 1,048,537 |
| `28`; `(0,24)`; `(31,25)` | 160 | 805 | 965 | 445,930 | 1,048,508 |
| `3`; `(18,5)`; `(15,31)` | 96 | 804 | 900 | 392,838 | 1,048,573 |

Regenerate from `/home/tavis/src/othello` with

```text
python3 notes/2026-07-18-c348-c329-coset-leader-enumerator.py \
  --output notes/2026-07-18-c348-c329-coset-leader-enumerator.json
```

and replay the canonical output with

```text
python3 notes/2026-07-18-c348-c329-coset-leader-enumerator.py --check
```

The script is 12,374 bytes with SHA-256
`ac4a01a6e3b68682fc917771ee3f773c3634d2112dea211ae7f358b4f31d7863`; the canonical JSON is
4,749 bytes with SHA-256 `ecc8881e02de212ed89479f8b0fa564f6db652d74a10ff65a3bf206f6a5d3eee`.
The adjacent checksum manifest pins both.
The trusted boundary is the pure-Python field arithmetic, projective normalization, and integer/
JSON/SHA-256 support in Python 3.  The incidence-moment identities and the independently generated
C330 image sets cross-check the line-union census.  The finite fixtures falsify uniformity in the
normalized architecture; they do not prove a large-field distribution theorem.

## Source-level literature matrix

Primary texts and exact-title/topic searches were checked on 2026-07-19.  Public search surfaces do
not provide exhaustive MathSciNet/zbMATH forward-citation closure, so no global priority claim is
made.

| source | exact overlap and boundary | C348 verdict |
|---|---|---|
| Jurrius--Pellikaan, [*The coset leader and list weight enumerator*](https://doi.org/10.1090/conm/632/12631), Theorem 5.3 and Examples 5.10--5.11 | Expresses extended coset-leader coefficients through characteristic polynomials of the derived hyperplane arrangement; for `[n,n-3,4]` arc codes, the derived arrangement is the secant arrangement and Example 5.11 uses the same unique non-base-field secant contribution.  The original uniform column matroid does not determine the coset-leader enumerator. | `STOP` for novelty of the scalar-extension reduction; `SURVIVES` for the explicit `F^+`/infinity decomposition, moduli behavior, and simultaneous extension complex. |
| Blokhuis--Pellikaan--Szonyi, [*The extended coset leader weight enumerator of a twisted cubic code*](https://doi.org/10.1007/s10623-022-01060-0), arXiv:2103.16904v2, cached SHA-256 `b406b217...a8297` | Defines the extended enumerator and computes it for the codimension-four twisted-cubic GRS code using line orbits and double-point schemes. Its irreducible simple-morphism argument does not apply to C329's reducible selected carrier. | `CONTEXT` as the closest explicit enumerator model; `STOP` for importing the double-point theorem. |
| Wu--Ding--Chen, [*Extended codes and deep holes of MDS codes*](https://arxiv.org/abs/2312.05534), arXiv v1, cached SHA-256 `9fe68786...f76000` | Theorem 6 proves the general second-kind extension is MDS exactly for a dual deep hole when the covering radius is maximal. | `STOP` for novelty of the dictionary; `SURVIVES` for the explicit infinity locus and simultaneous complex. |
| Li--Lu--Ling--Lam, [*A framework for constructing non-GRS MDS-NMDS codes from deep holes and its application*](https://arxiv.org/abs/2605.12133), arXiv v1, cached SHA-256 `8f854dcb...0fa7d` | Theorem 7 preserves MDS/NMDS and non-GRS status under a deep-hole extension by shortening. Its applications are extended subcodes of GRS codes, not the C329 orbit-union family, and it does not classify simultaneous projective extensions. | `SURVIVES`, narrowly, as an explicit input family to the framework. |
| Kaipa, [*Deep holes and MDS extensions of Reed--Solomon codes*](https://arxiv.org/abs/1612.05447), cached SHA-256 `1fe8de83...178a4` | Classifies redundancy-three RS deep holes in stated dimension ranges and records the even-characteristic nucleus exception. C329 is non-GRS, has length `4Q` over alphabet `Q^2`, and lies outside the large-dimension RS range. | `SURVIVES`; no RS classification is generalized. |
| Li--Heng, [*Non-GRS type MDS and AMDS codes from extended TGRS codes*](https://arxiv.org/abs/2604.05682), arXiv v1 | Gives covering radii and explicit deep-hole classes for a different extended-TGRS construction. | `NARROW`: non-GRS deep holes are active prior art; the carrier/infinity complex is distinct. |
| Gu--Wang--Zhang, [*Properties and Decoding of Twisted GRS Codes and Their Extensions*](https://arxiv.org/abs/2508.02382), arXiv v1 | Determines a deep-hole class for duals of specific non-GRS twisted-GRS codes. | `NARROW` for the same reason; no overlap with the four additive carrier orbits was found. |

The 2022 journal page reports forward citations, but the located 2023--2026 papers concern twisted-
cubic incidence, twisted/extended GRS codes, or the general deep-hole extension dictionary.  None
supplies the missing affine count for a selected reducible three-conic carrier.  Search absence is
not used as proof of novelty.  The conditional enumerator formula is a standard derived-arrangement
specialization; the defensible family-specific claims are its intrinsic additive/infinity
decomposition, bounded moduli dependence, and the explicit simultaneous infinity extension family.

## Exact boundary and next research implication

C348 closes with a theorem plus a sharp bounded negative.  The full all-field headline would require
an exact classification of the invariant affine quotient in `F x E`, including parameter dependence
on C337's gauge-free `[rho;{a,b}]`.  Neither C330 nor the cited double-point theorem supplies it, and
the small-field certificate shows that collapsing this dependence is false in the surrounding
architecture.  No larger census is warranted without a new quotient-curve or character-sum theorem.

## Vibe check

Mixed but worthwhile.  The ambitious uniform enumerator does not survive its first honest geometric
test, yet the failure is informative and leaves a clean theorem: the entire scalar-extension
enumerator reduces to one base count, while C330's holes generate a large exact non-GRS one-/two-
column MDS-extension family.
