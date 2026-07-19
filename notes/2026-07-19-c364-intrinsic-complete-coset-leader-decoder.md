# C364: intrinsic complete coset-leader decoder for the C329 family

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `THEOREM; INTRINSIC COMPLETE DECODER BY TEN BOUNDED FIBERS`

## Signed decision

After C337 recovers the four layers and the gauge-free invariant `[rho;{a,b}]`, every syndrome of
the C329 `[4Q,4Q-3,4]_{Q^2}` code has a minimum-weight leader computable through a constant number
of absolute-trace tests and polynomial root problems of degrees at most `2`, `5`, and `8`.  Every
root reconstructs two actual columns and their two nonzero coefficients; failure of all ten secant
gates is an exact deep-hole certificate, after which any fixed three columns give a weight-three
leader.  The algorithm covers zero, columns, affine and infinity syndromes, the seed vertical
component, and all exceptional divisors.  It contains no scan over `F` or over column pairs.

This passes C364's complete-decoder gate.  It is stronger than unique decoding: it returns a nearest
codeword representative for every coset, including covering-radius-three cosets.  It does not give
C361's missing closed count of those cosets.

## Theorem

Let `F=GF(Q)`, `Q=2^m>=2^45` with `m` odd, let `E=GF(Q^2)`, and let `A` be a C329 arc in C337 normal form

```text
A = L(0,a) union L(0,b) union L(1,0) union L(rho,0),
L(c,k)={P(c omega+t,k):t in F},   P(x,k)=[1:x:x^2+k].
```

Given C337's recovered presentation and a syndrome `s in E^3`, the algorithm below returns a sparse
vector `e in E^(4Q)` such that `He^T=s` and `wt(e)` is minimum.  Per syndrome it performs a constant
number of `E` operations, four absolute traces, and deterministic root finding for a constant number
of polynomials of degree at most eight over `F`.  With the deterministic root routine below, this is
`O(m^2)` `F`-operations after the one-time expected-`O(Q)` C337 recovery.  In a polynomial-basis
implementation with multiplication cost `M(m)`, the stated routine costs `O(m^2 M(m))` bit
operations, apart from lower-order fixed-degree polynomial arithmetic and sparse output.

The returned leader is independent of C337's seed and repair names: enumerate every reconstructed
secant, translate its endpoints back to the input columns, and choose the lexicographically least
input-coordinate support and coefficients.  The recovered names only order the enumeration, not its
candidate set.

## Reconstruction from an affine fiber root

Normalize a syndrome with nonzero first coordinate to `S=[1:u:v]`, write

```text
u=u_0+xi omega,                 eta=v+u^2,
```

and consider the ordered layer pair `(c,k),(c',k')`.  C361's variables are

```text
d=c+c', K=k+k', p=r+d omega, tau=xi+c, z=x+tau omega.
```

For every accepted root `r` and reconstructed `x`, put

```text
X=u+z=c omega+(u_0+x),         Y=X+p=c' omega+(u_0+x+r).
```

Then the two columns are exactly `P(X,k),P(Y,k')`.  C361's equation is precisely

```text
eta=z^2+(p+K/p)z+k,
```

so `S` lies on their line.  Its unique two-column coefficients in the normalization `S_0=1` are

```text
mu=z/p,                        lambda=1+mu,
S=lambda P(X,k)+mu P(Y,k').
```

The preliminary column lookup removes `z=0` and `z=p`; hence both coefficients are nonzero.  For an
unscaled syndrome multiply both coefficients by its first coordinate.  Conversely, translating any
covering secant by `u_0` recovers exactly one C361 source point, so the formulas lose no leaders.

The cross-layer reconstruction is explicit.  Off `M_1=0`, C361's notation gives `x=X/M_1`.  On
`M_1=0`, accept `r` only when the omega-coordinate equation `X=0` holds, and solve the remaining
quadratic

```text
x^2+(M_0/n)x+D=0.
```

Thus clearing denominators creates no spurious leader.  In the seed--seed quintic `K_1!=0` and
`x=X/K_1`; in the repair--repair case the omega coordinate makes `x` affine-linear in `r`, leaving
the advertised quadratic.

## Closed and exceptional cases

- **Zero and weight one:** return the empty leader for `s=0`; a hash lookup of projectivized columns
  returns the unique weight-one leader and its original scalar.
- **Repeated layer:** for `tau!=0`, C361 fixes `r` and the trace gate is exactly the solvability of
  `x^2+rx+D=0`; its roots give the endpoints.  For `tau=0`, `eta_1=k_1`.  Outside the already removed
  column case `D!=0`; choose any fixed `x` distinct from `0,sqrt(D)` and put `r=x+D/x`.
- **Seed vertical component:** when `xi=0`, use the two columns `P(u,a),P(u,b)` and
  `mu=(eta+a)/(a+b)`, `lambda=1+mu`.  Endpoint cases were already removed.
- **Affine exceptional divisor:** include the at most two roots of `M_1`, test the uncleared omega
  equation, and solve the displayed residual quadratic.  All degree drops are handled automatically
  by trimming the actual polynomial before root finding.  If every eliminated coefficient vanishes,
  use three fixed `F`-values for `r`; at least one avoids the quadratic `M_1=0` divisor.  The
  seed--seed and repair--repair zero-polynomial branches need only one fixed admissible `r` because
  their reconstruction denominators are respectively the nonzero constant `K_1` and `d`.
- **Ordinary infinity point `[0:1:s]`:** for each layer pair solve
  `s=p+K/p` in its restricted affine `F`-coset, take arbitrary simultaneous parameter `t=0`, and use
  equal coefficients `1/p` (rescaled by the original middle coordinate).
- **Vertical infinity point `[0:0:1]`:** the seed vertical pair at `t=0` has equal coefficients
  `1/(a+b)`.
- **Weight three:** if no column or secant gate succeeds, the projective syndrome is a deep hole.
  Any three columns of the arc form a basis, and none of their three coefficients can vanish (that
  would put the syndrome on a secant), so a fixed `3 x 3` solve returns a weight-three leader.

These cases are disjoint after the weight-zero/one lookup and exhaustive because weights at most
three follow from the MDS parity-check rank.

## Deterministic bounded-degree root finding

For `f in F[X]`, `deg(f)<=8`, compute

```text
g=gcd(f,X^Q-X).
```

This square-free polynomial is the product of the distinct `F`-linear factors of `f`.  For each
element `beta` of a fixed `F_2`-basis of `F`, split every current factor by

```text
gcd(h, Tr_F/F2(beta X)).
```

The trace pairing is nondegenerate: for distinct roots `alpha,gamma`, some basis element `beta`
has `Tr(beta(alpha+gamma))=1`.  Hence after the `m` basis tests every factor is linear.  Modular
Frobenius powers compute `X^Q mod f` in `m` squarings and the direct trace implementation uses at
most `m^2` fixed-degree modular squarings.  This proves determinism and the stated complexity without
assuming a random factorizer or enumerating `F`.  The adjacent checker implements this exact routine.

Compared with alternatives, direct secant enumeration costs `Theta((4Q)^2)` line constructions per
decoded presentation.  A full syndrome table has `Q^6` scalar syndromes (`Q^4+Q^2+1` projective
ones), while even a quotient membership table costs `Q^3` entries.  C364 instead uses polylogarithmic
per-syndrome work after C337 and returns a leader rather than only a table membership bit.

## Independent exhaustive replay

The adjacent pure-Python checker independently builds the direct union of all `8,128` secant lines,
then compares the intrinsic decoder's returned weight and reconstructed syndrome on every point of
`PG(2,1024)` for each of C348's three fixtures.  The quotient decoder solves every one of the
`98,304` aggregate affine quotient fibers using the trace/gcd root routine; orbit lifting then checks
all affine projective syndromes, and the infinity routine checks every infinity point.  Its quotient
cache is populated lazily by requested syndromes; initialization does not precompute a table.  The
exhaustive test fills that cache only because it deliberately requests every projective syndrome.

The exact replay ledger is:

| `(rho;a;b)` | weight 1 | weight 2 | weight 3 | projective syndromes |
|---|---:|---:|---:|---:|
| `9;(27,13);(8,24)` | 128 | 1,048,537 | 936 | 1,049,601 |
| `28;(0,24);(31,25)` | 128 | 1,048,508 | 965 | 1,049,601 |
| `3;(18,5);(15,31)` | 128 | 1,048,573 | 900 | 1,049,601 |

Regenerate from `/home/tavis/src/othello` with

```text
python3 notes/2026-07-19-c364-intrinsic-complete-coset-leader-decoder.py \
  --output notes/2026-07-19-c364-intrinsic-complete-coset-leader-decoder.json
```

and replay canonically with

```text
python3 notes/2026-07-19-c364-intrinsic-complete-coset-leader-decoder.py --check
sha256sum -c notes/2026-07-19-c364-intrinsic-complete-coset-leader-decoder.sha256
```

The trusted boundary is the checker's polynomial-basis arithmetic, deterministic polynomial gcd
and trace splitting, sparse linear algebra, and direct affine-line incidence reference, plus C348's
pinned canonical fixture input at SHA-256
`ecc8881e02de212ed89479f8b0fa564f6db652d74a10ff65a3bf206f6a5d3eee`.  The finite replay validates
all conventions and exceptional cases; it does not replace the all-field algebraic proof.
The script is 21,773 bytes with SHA-256
`240fc18cc46a3897d48d0c93f580ac08a4bae1d20df125be7fdf839c3eb32b4a`; the canonical JSON is
1,577 bytes with SHA-256
`71bff4c2999ed5ff4ccca795d4541d500aa8968a0ebc94cfa62246283dd49906`.  The adjacent manifest pins
both files.

## Source-level novelty matrix

**Audit status:** positioning pass complete; citation-graph and subscription-database closure open.
The C364 pass read zero sources at full text, six cached primary sources partially, and two source
characterizations secondarily through C337/C348.  The theorem is proved independently of this
audit, but any manuscript novelty sentence must retain “to our knowledge” until the open coverage
items below are discharged.

| source | read record | exact overlap and boundary | verdict |
|---|---|---|---|
| Kaipa, [*Deep holes and MDS extensions of Reed--Solomon codes*](https://arxiv.org/abs/1612.05447) | `partial`: arXiv v1 abstract and introduction; cache key `arXiv:1612.05447`, SHA-256 `1fe8de83c0b8cd3938e1a450fd49f376de795d7a317f099a730c63ab968178a4` | Classifies redundancy-three RS deep holes and their MDS extensions. C329 is non-GRS and C364 reconstructs leaders rather than importing the RS classification. | `SURVIVES`; credit the redundancy-three/deep-hole dictionary. |
| Zhang--Lin--Chen, [*Decoding Algorithms for Twisted GRS Codes*](https://arxiv.org/abs/2508.03552) | `partial`: arXiv v1 abstract and introduction; cache key `arXiv:2508.03552`, SHA-256 `77c9d311bb2a77de72b404f46494bc34d37bff012920058b24457b2953c8a782` | Gives `O(n^3)` Gaussian-elimination decoders for TGRS MDS/NMDS codes through their guaranteed correction radii. At redundancy three that is ordinary one-error decoding, not every coset through radius three. | `SURVIVES`; `STOP` for novelty of non-GRS unique decoding. |
| Li--Ezerman--Lao--Ling, [*Properties and Decoding of Twisted GRS Codes and Their Extensions*](https://arxiv.org/abs/2508.02382) | `partial`: arXiv v1 abstract and introduction; cache key `arXiv:2508.02382`, SHA-256 `e916bf5d61ce6cf21391ab81e65fd22ad149cec513a6922c6bca2d58f2268b06` | Constructs error-correcting pairs and an explicit bounded-distance ETGRS decoder; it also gives a covering radius and a class of deep holes for another non-GRS family. It neither recognizes C329 nor returns leaders for every syndrome. | `SURVIVES`, narrowly; credit ECP decoding and non-GRS deep-hole prior art. |
| Wang--Liu--Luo, [*Improved Decoding Algorithms for MDS and Almost-MDS Codes from Twisted GRS Codes*](https://arxiv.org/abs/2511.00766) | `partial`: arXiv v1 abstract, introduction, and key-equation setup; cache key `arXiv:2511.00766`, SHA-256 `265d657569f0842d6e265fdab75631d0e65bd7894b69983951bd2bf0c8cc6a0f` | Refines key-equation bounded-distance decoding for general TGRS and twisted Goppa codes. Its error locator has degree equal to the prescribed error count; it is not a covering-radius-three nearest-leader algorithm. | `SURVIVES`; credit the improved TGRS key-equation decoder. |
| Zhu--Jin, [*Efficient Decoding of Twisted GRS Codes and Roth--Lempel Codes*](https://arxiv.org/abs/2512.24217) | `partial`: arXiv v2 abstract, introduction, contribution statement, and Table I; cache key `arXiv:2512.24217`, SHA-256 `9a3be4cbc9831555a83ea03c25ce01952eefcede42cbb1f49236450a792e8896` | Gives near-linear unique and list decoders by embedding TGRS/Roth--Lempel codes in GRS codes and applying Guruswami--Sudan under parameter-dependent radii. Even its beyond-half-distance output is a bounded list, not a minimum leader for every syndrome. | `SURVIVES`; `STOP` for novelty of fast non-GRS unique/list decoding. |
| Couvreur--Panaccione, [*Power Error Locating Pairs*](https://arxiv.org/abs/1907.11658) | `partial`: arXiv v3 abstract and introduction; cache key `arXiv:1907.11658`, SHA-256 `711d769cd2580ed59465e9796776b07d21176aa25208a9760aec7ffc024c19dd` | Abstracts power/list decoding beyond half distance for codes with suitable locating pairs, with a bounded decoding radius and possible failure. It is not a covering-radius coset-leader algorithm. | `SURVIVES`; `STOP` for broad claims about structured decoding beyond half distance. |
| Blokhuis--Pellikaan--Szonyi, [*The extended coset leader weight enumerator of a twisted cubic code*](https://doi.org/10.1007/s10623-022-01060-0) | `secondary only`: C348's source matrix and hypothesis audit; primary bytes cached as `arXiv:2103.16904`, SHA-256 `b406b2170b883eaa427649f93b92965dcac1cfbbaa537bef201bcd7a7bca8297`, but C364 did not re-read them | C348 records that the paper defines the enumerator geometrically for the irreducible twisted cubic; it supplies neither this reducible-carrier decoder nor endpoint reconstruction from C361's fibers. | `SURVIVES`; credit coset-leader and syndrome-geometry language. |
| Wang--Liu--Luo, [*New Constructions of Non-GRS MDS Codes, Recovery and Determination Algorithms for GRS Codes*](https://arxiv.org/abs/2512.02325) | `secondary only`: C337's source matrix, which records a full-text read; primary cache key `arXiv:2512.02325`, SHA-256 `3cba91d9300c510c6b52a76a90dc1fd48a915c51238cd002d505f34d36d40720` | C337 records a GRS recovery algorithm. Neither that source nor C337 decodes all C329 syndromes; C337 instead supplies the recovered geometry consumed here. | The recover-then-completely-decode synthesis remains the candidate new statement. |

### Search record and open closure

The 2026-07-19 positioning pass used the exact queries `"complete coset leader decoding" MDS
code`, `"coset leader decoder" non-GRS MDS`, and exact-title searches for the two 2025 TGRS
decoder papers already known to the task.  A follow-up exact-title/topic search located
`arXiv:2511.00766` and `arXiv:2512.24217`; both were cached and promoted to individual partial
reads above.  These were ordinary public-web/arXiv discovery searches.  Result-set sizes, screened
fields, and a mechanical discriminator were not recorded, so they license positioning leads but no
exhaustive negative.

No forward-citation set was enumerated.  OpenAlex, Crossref, and Semantic Scholar counts therefore
remain **NOT RUN**, and no largest-set screen exists.  zbMATH Open is **NOT RUN**.  MathSciNet is
**NOT COVERED** because institutional authentication was unavailable.  Google Scholar is **NOT
RUN** because automated access is unreliable.  The closure pass must resolve each seed by DOI or
arXiv identifier, record the three graph counts separately, screen the largest returned set over
title and abstract/metadata with the verbatim discriminator, and distinguish empty results from
service errors.  It must also upgrade or retain every partial read explicitly rather than inferring
read depth from cached bytes.

Subject to that open closure, the defensible candidate claim is precise: **to our knowledge, an
unmarked member of this recoverable four-orbit non-GRS MDS family admits intrinsic complete
coset-leader decoding through a constant number of trace and bounded-degree root problems.**  No
generic non-GRS decoder, generic complete MDS decoder, or novelty for finite-field root finding is
claimed.

## Paper integration

Insert the theorem after C337's intrinsic-recognition theorem and before C362's enumerator/extension
section.  It upgrades the paper independently of C361's failed count: C362 still leaves `M(A)`
unevaluated, while C364 decides membership constructively for an individual syndrome and returns a
leader.  A suitable abstract sentence is:

> From an unmarked parity-check matrix we recover the four-orbit geometry and completely decode every
> coset by four trace gates and six bounded-degree root problems, including explicit deep-hole
> certificates and leaders.

## Vibe check

Strong salvage.  C361's joint Frobenius distribution remains too hard to count, but the same ten
correspondences are exactly enough algorithmically: C364 converts a disappointing enumerator stop
into a genuine all-syndrome decoder with constant algebraic shape and exhaustive independent replay.
