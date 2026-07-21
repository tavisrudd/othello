# C414 — uniform B3/H3 oriented factorization-depth theorem

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** `COMPLETE`

**Verdict:** `THEOREM; BOTH B3 SEAMS REPRODUCE THE H3 FOUR-COORDINATE, RANK-TWO, CUBIC-FIRST DEPTH LAW; MOVING ODD FACTORIZATION SECTIONS HAVE RANK FOUR; A3 IS THE NONSPLITTING CONTROL`

**Literature depth:** this claim-specific extension records **one source at full-text depth**:
Edge's published paper, already read completely for C399/C406, with the load-bearing q=7 passages
reread here.  One further published paper was read partially from a cached full PDF, one from a
rendered author copy, and two sources remain at partial or abstract/metadata depth.  The source
ledger and access boundaries are below.  The verdict is likely-new only within that bounded
coverage; it is not an unrestricted priority claim.

## Result

Let

```text
G = PGL_2(q),             G+ = PSL_2(q),
X = G/H,
```

where `H` is the exceptional conic parent: `S4` for B3 at `q=7` and `A5` for H3 at
`q=11`.  In both cases `H < G+`, so `X` splits into two determinant sheets `X+` and `X-`
of size `q`.  Fix a parent in `X+`, an opposite parent in `X-`, an involution `J` exchanging
them, and their common seam `K`.

There are two intrinsic B3 seam classes.  All four `S3` seams share one matching edge, while all
three `D8` seams share none.  Both classes satisfy the same structural theorem as the H3 `A4`
seam:

| type | q | seam `K` | opposite seams | `K`-orbit sizes on each sheet | odd depth coordinates | depth rank | first signed moment |
|:---:|---:|:---:|---:|:---:|---:|---:|:---:|
| B3 | 7 | `S3` | 4 | `1,3,3` | 4 | 2 | cubic |
| B3 | 7 | `D8` | 3 | `1,2,4` | 4 | 2 | cubic |
| H3 | 11 | `A4` | — | `1,4,6` | 4 | 2 | cubic |

More precisely, write the conic as `Q=XZ-Y^2=0`, let `M` be a perfect matching of its
`q+1` rational points, and define the product of its secants

```text
P_M = product_(e in M) ell_e.
```

For B3, `deg(P_M)=4`, and matching products have a common restriction to the conic.  Hence

```text
P_M - P_N = Q Phi_(M,N),             deg(Phi_(M,N))=2.
```

For every B3 seam and every one of its four involutive pair exchanges, the moving-family spans

```text
span{P_M-P_(JM) : M in X+},
span{Phi_(M,JM) : M in X+}
```

both have dimension four over `F_7`.  Thus the genuine degree-`2/4` factorization sections have
the same four-dimensional size as the already certified twisted-Fourier odd core.  This statement
does **not** identify the two spaces linearly or prove the section-level Fourier functional
equation; that remains C416's sharper gate.

Now let `R_1,J R_1,...,R_4,J R_4` be the four nonfixed pairs of projective-line orbits under
the common seam.  Define the oriented zero-depth profile

```text
D_i(M) = # (Z(P_M) intersect R_i) - # (Z(P_M) intersect J R_i).
```

Changing the order of an orbit pair changes the sign of one coordinate, and changing the seam
representative permutes the coordinates.  Consequently `D` is intrinsic as a signed-coordinate
class.  It is constant on `K\G/H`, satisfies `D(JM)=-D(M)`, assumes six distinct values, and
therefore separates all six double cosets and the two oriented sheets.  Its image spans a plane,
not the full four-space: zero-divisor depth is an exact nonlinear rank-two compression of the
rank-four factorization sections.

One representative per positive-sheet double coset gives the following coordinates.  The vectors
are canonical only up to signed coordinate permutation; the weights are the intrinsic orbit sizes.

| seam | weight | positive profile |
|:---:|---:|:---|
| B3 `S3` | 1 | `(0,3,-3,-6)` |
|  | 3 | `(1,-2,-1,0)` |
|  | 3 | `(-1,1,2,2)` |
| B3 `D8` | 1 | `(-2,4,-4,0)` |
|  | 2 | `(-1,0,4,-2)` |
|  | 4 | `(1,-1,-1,1)` |
| H3 `A4` | 1 | `(-6,0,12,-12)` |
|  | 4 | `(-3,3,0,3)` |
|  | 6 | `(3,-2,-2,0)` |

In each block the weighted sum of the three vectors is zero over the integers.  The two B3 profile
planes have equations

```text
S3:  3a+b+c=0,    4a+2b+d=0                 over F_7,
D8:  4a+3b+c=0,   5a+6b+d=0                 over F_7.
```

H3 has the already certified equations `2a+2b+c=0` and `9a+8b+d=0` over `F_11`.

Let `v_1,v_2,v_3` be the positive profiles and `w_1,w_2,w_3` their orbit sizes.  The pushed
signed measure is

```text
sum_i w_i (delta_(v_i) - delta_(-v_i)).
```

Its linear moment is twice the zero weighted barycentre.  Every even signed moment vanishes
termwise.  Its cubic moment is nonzero in all three rows of the table.  Therefore the oriented
depth profile has exactly the same cubic-first law for `S3`, `D8`, and `A4` seams.

At q=5 the A3 parent `S4` is not contained in `PSL_2(5)`.  Its five-parent `PGL_2(5)` orbit is
already one `PSL_2(5)` orbit, so there is no determinant-sheet orientation, no opposite-sheet
seam, and no signed depth trade.  This is the conceptual nonsplitting control, not a failed finite
table.

## Proof design

The proof has five short layers.

1. **Sheet and seam structure.**  Restriction of `G/H` to the index-two subgroup `G+` splits
   exactly when `H<G+`.  Edge's q=7 octahedral geometry gives the two seven-parent strata and the
   three opposite parents sharing a vertex with common dihedral stabilizer.  Exact subgroup
   intersection completes the complementary four `S3` seams and identifies matching overlap as
   the intrinsic discriminator.
2. **Factorization sections.**  A secant product restricts to the same binary form on the conic
   for every matching.  Thus every difference is divisible by `Q`.  Direct coefficient reduction
   gives rank four for both B3 odd product and quotient spans.  No zero-locus statistic is used in
   this step.
3. **Four oriented coordinates.**  The common seam acts on the 57 projective ternary lines.  An
   exchanging involution pairs exactly four seam orbits and fixes the others.  Signed zero counts
   on those four pairs give `D(JM)=-D(M)` formally.
4. **Six representatives.**  The matching double-coset sizes are
   `1,1,3,3,3,3` for `S3` and `1,1,2,2,4,4` for `D8`.  Evaluating one matching per double coset
   gives the displayed profiles.  Common-seam equivariance propagates each value to its orbit;
   parent conjugacy propagates the result to all four or all three seams.  The full 14-matching
   evaluation is retained only as a replay/falsifier.
5. **Cubic-first law.**  The displayed weighted barycentre proves the linear cancellation;
   `J`-antipodality proves all even cancellations; one exact cubic coordinate is nonzero.  C411's
   H3 theorem has the identical `three orbits / four coordinates / rank two / cubic first`
   pattern.  The A3 subgroup criterion explains why no signed analogue exists there.

The four involutive pair exchanges on a fixed B3 seam produce exactly one profile class, not four
coordinate-dependent answers.  Parent conjugacy then gives exactly one signed-coordinate class
for all `S3` seams and one for all `D8` seams.  Their canonical signature hashes are stored in the
certificate.

## What changed

The preflight had already proved that the degree-`2/4` twisted-Fourier odd blocks exist and are
four-dimensional on both B3 seam types.  It did not construct factorization sections or depth
profiles.  C414 now supplies both, proves that neither seam is spurious, and gives the portable
cubic-trade law requested by the queue item.

The outcome is stronger than selecting one preferred seam: the geometry supports two compatible
specializations.  The exact weights differ, but the structural theorem is uniform.  There is no
canonical choice between `S3` and `D8` from the current factorization data.

## Literature boundary

### Disposition

The raw combinatorics are classical.

- Edge owns the q=7 two-stratum octahedral geometry.  In particular, he gives fourteen canonical
  triangles in two seven-element `Omega^+(3,7)` systems, shows the outer orthogonal coset exchanges
  the systems, and identifies the three opposite triangles sharing a vertex with common order-eight
  dihedral stabilizer.  The complementary four seams and their `S3` intersections are immediate
  subgroup consequences, not novelty.
- Hua Han's symmetric-factorization classification places `K_8` in the affine homogeneous family;
  the classical B3 one-factorization itself is not new.
- Chen--Lu give the parallel `PSL_2(7)/S4` symmetric factorization on triples, and the broader
  one-factorization literature already owns many conic/oval constructions.
- The inherited C406 audit already pre-empts generic matching-design, harmonic-matching, and
  exceptional one-factorization language.

No located source applies the conic-ideal secant-product quotient to both q=7 seam classes, forms
the four signed zero-depth coordinates, proves their six-class rank-two image, or obtains the
uniform B3/H3 cubic-first trade with A3 as the nonsplitting control.  The safe priority statement is:

> No predecessor for this B3/H3 conic-section/depth/cubic composition was located in the recorded
> coverage.

### Source ledger

| Source | Read depth, access, and version | Load-bearing boundary |
|:---|:---|:---|
| W. L. Edge, *Conics and orthogonal projectivities in a finite plane*, DOI `10.4153/CJM-1956-041-6` | **full text**; published 21-page PDF previously read completely for C399/C406; Sections 7--9 and 22--25 reread from cache key `10.4153/CJM-1956-041-6`, SHA-256 `07149c0f963d2b31016a0ad992ff6f0af6a77775a574a6c76aa3621b68e189ef`. | Positively pre-empts the q=7 parent strata, outer exchange, three dihedral seams, and classical factorization identities.  It does not define the secant-product quotient or oriented zero-depth/cubic profile. |
| Hu Ye Chen and Zai Ping Lu, *Symmetric factorizations of the complete uniform hypergraph*, DOI `10.1007/s10801-017-0760-8` | **partial**; published 20-page PDF, abstract/Introduction, Example 5.8, Lemma 5.9, and classification statement read.  Cache key `10.1007/s10801-017-0760-8`, SHA-256 `89ca87186c87dbbf745ece30a063e742ea7bbd1b69b1750523ebc4b9f4372b49`. | Gives an explicit `PSL_2(7)/S4` symmetric triple-factorization and group generators.  This is adjacent raw subgroup/factorization data, not matching secant depth. |
| Hua Han, *Symmetric factorisations of complete graphs*, DOI `10.3934/mfc.2023046` | **partial**; official AIMS abstract/table plus the Introduction, Theorem 1.1, and Corollary 1.2 in the rendered author-copy preview.  Official full HTML reported access restriction; no PDF bytes were cached. | Classifies symmetric graph factorizations and places power-of-two complete graphs in the homogeneous family.  It pre-empts raw `K_8` factorization novelty but exposes no conic quotient or depth statistic. |
| G. Korchmaros, N. Pace, and A. Sonnino, *One-factorisations of complete graphs arising from ovals in finite planes*, DOI `10.1016/j.jcta.2018.06.006` | **abstract/metadata only**; official ScienceDirect abstract and bibliographic page.  Full text was not obtained or cached. | Establishes the broad finite-oval/one-factorization interface.  No negative claim about its internal details is made. |
| H. D. L. Hollmann and Q. Xiang, *Association schemes from the action of PGL(2,q) fixing a nonsingular conic in PG(2,q)*, arXiv:math/0503573v1 | **partial**, inherited from C406: cached abstract, Introduction, and construction/scope statements.  Cache key `arXiv:math/0503573`, SHA-256 `c7da1c736b1d229228f74cbcc22a77dd848a512e206c1cb88462fc3fd513ab4b`. | Owns broad conic-stabilizer scheme machinery, not the `S4/S3/D8` factorization-depth restriction. |

The shared cache was verified after adding Chen--Lu: 174 manifest entries, zero hash problems.

### Search and forward-citation record

The final exact-fingerprint batch used these queries verbatim:

```text
"secant product" conic one-factorization
"product of secants" finite conic factorization
"cubic moment" one-factorization
"S3" "D8" "PSL(2,7)" conic
```

The configured search service returned 37 result cards after its own cross-query deduplication.
All were screened over returned titles and snippets/abstracts.  The promoted finite-geometry hits
were read at the depths above; the remaining hits were unrelated secant varieties, analytic cubic
moments, elementary circle geometry, or generic one-factorization papers.  None matched the exact
conic-product/depth profile.

Pinned forward counts are in OpenAlex/Crossref/Semantic Scholar order:

- Edge, DOI `10.4153/CJM-1956-041-6`: `7/6/10`.  Semantic Scholar's largest ten-work set was
  screened over title and available abstract with discriminator
  `secant|depth|moment|cubic|fourier|S3|D8|PSL(2,7)|conic quotient|factorization`; none matched.
- Han, DOI `10.3934/mfc.2023046`: `0/0/0`.  Every service resolved the exact pinned title and
  returned an explicit zero, distinguishing an empty set from an API error.
- Chen--Lu, DOI `10.1007/s10801-017-0760-8`: `1/0/0`.  OpenAlex's sole citing work was
  *An Infinite Family of Connected 1-Factorisations of Complete 3-Uniform Hypergraphs*; its title
  and abstract did not match the C414 fingerprint.
- Korchmaros--Pace--Sonnino, DOI `10.1016/j.jcta.2018.06.006`: `5/3/6`.  Semantic Scholar's
  largest six-work set was screened over title and available abstract.  The works concern Lee,
  circular-linear, hyperbola, parabola, and odd-square-order one-factorizations; none mentions the
  C414 section/depth/cubic composition.

The exact service endpoints were the pinned DOI work records in OpenAlex, Crossref, and Semantic
Scholar, followed by

```text
https://api.openalex.org/works?filter=cites:W2610555094&per-page=200&select=id,title,abstract_inverted_index,doi
https://api.semanticscholar.org/graph/v1/paper/DOI:10.4153/CJM-1956-041-6/citations?limit=100&fields=title,abstract,year,externalIds
https://api.semanticscholar.org/graph/v1/paper/DOI:10.1016/j.jcta.2018.06.006/citations?limit=100&fields=title,abstract,year,externalIds
```

The OpenAlex work ID in the first URL was resolved from the pinned Chen--Lu DOI immediately before
the citing query.  Every service returned the expected seed title; no empty response was treated as
a zero after an error.

**Coverage gaps:** MathSciNet and Google Scholar were not accessible; zbMATH Open was not closed
claim-by-claim; Han's official full text and Korchmaros--Pace--Sonnino's full text were not obtained;
and the broad modular-trade/finite-Radon literature remains covered only by the inherited C406 audit
and the exact fingerprints above.  These are open gaps, so the report uses bounded likely-new
wording only.

## Evidence and reproducibility

The atomic evidence bundle is:

- `notes/2026-07-20-c414-b3-depth-profile.py` — primary exact generator/checker;
- `notes/2026-07-20-c414-b3-depth-profile.json` — canonical certificate;
- `notes/2026-07-20-c414-b3-depth-profile-replay.py` — independent Möbius/`Sym^2` replay;
- `notes/2026-07-20-c414-b3-depth-profile.sha256` — hashes and byte counts for this report and
  every load-bearing artifact.

Run from `/home/tavis/src/othello` with Python 3.13.12:

```bash
python3 notes/2026-07-20-c414-b3-depth-profile.py --check
python3 notes/2026-07-20-c414-b3-depth-profile-replay.py
sha256sum -c notes/2026-07-20-c414-b3-depth-profile.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-20-c414-b3-depth-profile.py --write
```

The primary checker tests all seven opposite B3 parents, all four involutive exchanges per seam,
all fourteen matchings, and all 57 projective ternary lines.  The theorem derivation needs one
matching per six double cosets; the full run performs 392 matching-profile evaluations as a
falsifier.  It also checks every conic divisibility identity and the exact ranks of the product,
quotient, and depth images.  The H3 row is pinned to C411's exact certificate.

The independent replay imports none of the primary checker.  It reconstructs all 336 elements of
`PGL_2(7)` from normalized Möbius matrices, derives `PSL_2(7)` by determinant square class, obtains
each parent and seam as a matching stabilizer/intersection, acts on ternary projective points by the
standard symmetric-square matrix, recomputes all profiles and section ranks, and independently
checks the q=5 nonsplitting orbit.

The trusted boundary is elementary arithmetic in `F_5,F_7,F_11`; normalized Möbius and projective
actions; the standard Veronese conic and its secants; finite orbit enumeration; Gaussian elimination;
and the pinned C411 H3 certificate.  The computation proves only the three frozen exceptional
configurations.  It does not prove an all-field theorem, a q=9 analogue, the section-level twisted
Fourier identity, a canonical choice between the B3 seams, or an unrestricted novelty claim.

## Hand-back

C414's geometric portability gate passes for **both** B3 seam classes.  C415 may now consume the
four oriented zero-depth coordinates as the exact geometric shadow to be compared with transformed
Fourier coordinates.  C416 still owns the stronger question of whether twisted Fourier carries the
actual quotient-section line to the product-section line inside the moving four-space.  C417 retains
the integral/Rees and modular `8/9` extension-class problem.
