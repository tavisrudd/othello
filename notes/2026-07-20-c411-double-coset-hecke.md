# C411 — double-coset/Hecke derivation of the compressed cubic trade

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; CONCEPTUAL SIX-REPRESENTATIVE DERIVATION; MIXED BI-HECKE INTERPRETATION; CUBIC-FIRST PUSHFORWARD`

## Executive conclusion

The C406 depth map is not an arbitrary embedding of a classical orbit table.  Its four coordinates
are canonical signed incidence counts between a secant factorization and the four oriented pairs
of scalar-`A4` relations in C378.  Equivariance makes this map constant on

```text
K \ G / H,       G=PGL_2(11),  H=A5,  K=A4.
```

Subgroup marks give three `K`-orbits of sizes `1,4,6` on each `PSL_2(11)` sheet.  It is therefore
enough to evaluate one secant product on one representative of each of the six double cosets, not
all 22 matchings.  Those six incidence calculations derive exactly C406's profiles

```text
 v1=(-6, 0,12,-12),   v2=(-3, 3, 0, 3),   v3=( 3,-2,-2, 0)
-v1,                  -v2,                -v3
```

with multiplicities `1,4,6 / 1,4,6`.  The three positive profiles span the plane

```text
2a+2b+c=0,             9a+8b+d=0                  over F_11
```

and satisfy the integral relation `v1+4v2+6v3=0`.

This gives a conceptual explanation of cubic-first survival.  The signed pushforward has first
moment twice that weighted barycentre, hence zero.  Every even signed moment cancels between
opposite profiles, hence the second moment is zero.  In degree three the first coordinate is

```text
2((-6)^3 + 4(-3)^3 + 6(3)^3) = 6 != 0              in F_11.
```

The Hecke terminology has a sharp boundary.  The depth coordinates are elements of the
six-dimensional mixed bi-Hecke space `e_K Q[G] e_H ~= Q[K\G/H]`, equivalently mixed matrix
coefficients with a `K`-fixed covector and the `H`-fixed coset vector.  They are **not** zonal
spherical functions for `(G,H)`: they are not `H`-invariant.  Nor is the induced linear map a
faithful quotient of the bi-Hecke space: its rank is two and its kernel has dimension four.  It is
faithful only as a set map on the six double-coset labels, which it separates exactly.

The claim-specific audit adds no newly full-read source.  It consumes the six full-text sources in
the C406 baseline audit, adds one cached source at partial depth, and adds two sources at
abstract/metadata depth.  The double-coset, Hecke, spherical-function, Hadamard-design, and
`A4/A5` subgroup layers are classical.  No predecessor was located for the exact composition with
the four oriented secant-depth incidence coordinates and their compressed cubic trade, within the
bounded coverage below.  This remains a qualified absence claim because one full text and the
three-service forward closures were not all accessible.

## The double-coset theorem

Let `X=G/H` be the 22 matching-decorated parents from C379/C406.  The subgroup
`G^+=PSL_2(11)` has two orbits `X_+` and `X_-`, each of size 11.  The scalar group

```text
K = A5_+ intersection A5_- ~= A4
```

lies in `G^+`, and the golden involution `J` normalizes `K` and exchanges the two sheets.

On `X_+`, the permutation character of `K`, indexed by element orders `1,2,3`, is

```text
(11,3,2).
```

The relevant transitive `A4` marks are

| transitive `K`-set | size | marks on orders `1,2,3` |
|:---|---:|:---|
| `K/K` | 1 | `(1,1,1)` |
| `K/V4` | 3 | `(3,3,0)` |
| `K/C3` | 4 | `(4,0,1)` |
| `K/C2` | 6 | `(6,2,0)` |
| `K/1` | 12 | `(12,0,0)` |

The mark equations have the unique nonnegative solution of total degree 11

```text
X_+ restricted to K  ~=  K/K disjoint_union K/C3 disjoint_union K/C2.
```

Thus the orbit sizes are `1,4,6`.  Conjugation by `J` gives the same decomposition on `X_-`, so
`|K\G/H|=6` with sizes `1,4,6 / 1,4,6`.  The certificate also checks the stabilizer intersections
directly: their orders are `12,3,2` on each sheet.

## Incidence derivation of the six vectors

Let `(R_1,R_10)`, `(R_3,R_13)`, `(R_6,R_14)`, and `(R_9,R_11)` be C378's four oriented
`J`-pairs.  For a matching `M`, let `Z_M(R)` count the projective points of relation `R` lying on
one of the six secants of `M`.  Since the secant product vanishes exactly on that union,

```text
D(M) = (Z_M(R_1)-Z_M(R_10), ..., Z_M(R_9)-Z_M(R_11)).
```

For `k in K`, the relation cells and the secant union move together, so `D(kM)=D(M)`.  Also
`J` exchanges each oriented relation pair and sends the secant union of `M` to that of `JM`, so
`D(JM)=-D(M)`.  Hence one representative per double coset suffices.

The six representative calculations are:

| sheet | orbit size | stabilizer | eight zero counts, in oriented-pair order | profile |
|:---:|---:|:---:|:---|:---|
| `+` | 1 | `A4` | `0,6; 0,0; 12,0; 0,12` | `(-6,0,12,-12)` |
| `+` | 4 | `C3` | `3,6; 3,0; 3,3; 6,3` | `(-3,3,0,3)` |
| `+` | 6 | `C2` | `3,0; 1,3; 2,4; 6,6` | `(3,-2,-2,0)` |
| `-` | 1 | `A4` | the `J`-reversal of the first row | `(6,0,-12,12)` |
| `-` | 4 | `C3` | the `J`-reversal of the second row | `(3,-3,0,-3)` |
| `-` | 6 | `C2` | the `J`-reversal of the third row | `(-3,2,2,0)` |

The primary checker derives these rows from six representative secant unions.  It then evaluates
all 22 matchings only as a falsifier, verifying constancy on every `K`-orbit and `J`-negation.  The
independent replay rebuilds the conic parameterization, the two `A5` groups, their `A4`
intersection, the rank-16 relations, and the same six representative incidence rows through the
independent C378/C406 implementation.

Row reduction over `F_11` gives rank two and the two displayed plane equations.  Integer weighted
double counting gives `v1+4v2+6v3=0`; no reduction modulo 11 is needed for that identity.

## Exact Hecke interpretation and its limit

Pull a depth coordinate back from `G/H` to `G`.  Its invariance is

```text
f(kgh)=f(g),             k in K, h in H.
```

Thus the four coordinates lie canonically in `e_K Q[G] e_H`, the mixed Hecke bimodule between the
ordinary `K`- and `H`-Hecke algebras.  Mackey's double-coset formula gives its dimension six.
Equivalently, in the permutation representation `Q[G/H]`, each coordinate is a matrix coefficient
between the `H`-fixed base vector and a `K`-fixed covector.

This answers C411's three proposed interpretations:

- **spherical functions:** no, not for `(G,H)`.  The `H`-orbits on `G/H` have sizes `1,10,5,6`,
  and the depth map takes two distinct profiles on each of two nontrivial `H`-orbits;
- **matrix coefficients:** yes, in the mixed `K`--`H` sense above, but not as a single asserted
  irreducible spherical coefficient;
- **faithful quotient:** no as a linear module map.  The six-dimensional double-coset space maps
  with rank two and kernel dimension four.  The six resulting vectors are nevertheless pairwise
  distinct, so the map separates the six orbit labels set-theoretically.

The distinction matters in characteristic 11: semisimplicity of the full group algebra is not
available over `F_11`.  The double-coset and incidence statements are integral and can be extended
to characteristic zero, while the rank-two plane and cubic witness are the stated `F_11` claims.

## Cubic-first pushforward

Write the pushforward of the sheet-signed measure as

```text
nu = delta_(v1)+4 delta_(v2)+6 delta_(v3)
     -delta_(-v1)-4 delta_(-v2)-6 delta_(-v3).
```

For its symmetric tensor moments:

```text
M_k(nu) = (1-(-1)^k) sum_i n_i v_i^(symmetric k),    (n_1,n_2,n_3)=(1,4,6).
```

Therefore every even signed moment vanishes formally.  The degree-one moment vanishes by the
weighted barycentre relation.  The displayed first-coordinate calculation proves the cubic is
nonzero.  This replaces C406's 22-term tensor evaluation by one double-coset mark calculation,
six representative incidence rows, and a three-term weighted identity.  It does not prove a
general first-memory theorem; C409 owns that broader filtration.

## Claim-specific novelty audit

### Sources and read depth

- **C406 baseline priority audit:** reused as the task's mandated baseline.  It records **six
  sources at full-text depth** and six at partial or metadata depth.  In particular, Edge and Dye
  own the exceptional conic-marker geometry; Pan--Wu--Yin own the 22-point
  `PGL_2(11)/A5` Hadamard orbital action, cross-sheet valencies `5,6`, and incident/nonincident
  stabilizers `A4,D10`; and the matching-design literature owns the one-factorization/design
  language.  Exact versions, access paths, hashes, and load-bearing passages remain in
  `notes/2026-07-20-c406-priority-audit.md`.
- **T. Ceccherini-Silberstein, F. Scarabotti, and F. Tolli, _Harmonic analysis and spherical
  functions for multiplicity-free induced representations of finite groups_, arXiv:1811.09526:**
  **partial**; arXiv preprint PDF, Introduction, Section 3.1 through Corollary 3.6, and Section 4.3
  through Proposition 4.15 read.  Cache key `arXiv:1811.09526`, SHA-256
  `7f52ad39459722380901bab9d381d3bb7ca0a57c0c7bb74701264262f80e3e8c`.  It supplies the
  classical Mackey/Hecke and spherical-matrix-coefficient boundary; it does not study the
  `A4<PGL_2(11)>A5` mixed space or secant-depth coordinates.
- **W. L. Edge, _PGL(2, 11) and PSL(2, 11)_, DOI
  `10.1016/0021-8693(85)90061-4`:** **abstract/metadata only**; official ScienceDirect title,
  abstract, date, pages, and DOI.  The full text returned HTTP 403.  Its abstract confirms that the
  two degree-11 permutation representations and their finite-line/orthogonal-plane geometry are
  explicit subjects.  No internal negative is inferred.
- **Ludovic Schwob, _On the enumeration of double cosets and self-inverse double cosets_, DOI
  `10.1016/j.aam.2025.102982`:** **abstract/metadata only**; official open-access ScienceDirect
  title, abstract, keywords, and DOI.  It confirms that character-theoretic double-coset enumeration
  is current standard machinery.  Its exact examples were not read and no negative rests on it.

### Exact searches and screened sets

The following web queries were issued verbatim and screened over returned titles and snippets:

```text
"A4" "PGL(2,11)" "A5" double coset Hecke
"PGL(2,11)" A5 A4 syntheme hexagon
finite group two subgroup double coset bimodule spherical functions K G H
signed design trades moment cubic finite field
site:arxiv.org finite Gelfand pair double coset spherical functions induced trivial representation
site:cambridge.org PGL(2,11) A5 cosets Hadamard design A4
"10.1016/0021-8693(85)90061-4" PDF
"A4\\PGL(2,11)/A5"
"K\\G/H" spherical functions finite group two subgroups
```

They promoted the Ceccherini--Silberstein--Scarabotti--Tolli source and the Edge/Schwob metadata
records, but no exact secant-depth profile or signed cubic composition.

Four reproducible OpenAlex `search` screens were also run over title/abstract/full metadata, taking
the first ten relevance-ranked records when available:

| exact query | total reported | records screened | result |
|:---|---:|---:|:---|
| `A4 PGL(2,11) A5 double coset` | 2 | 2 | two generic permutation/progenitor papers; no exact configuration |
| `PGL(2,11) A5 Hecke spherical function` | 1 | 1 | unrelated `GL_2` Gross--Zagier paper |
| `icosahedral matching signed design trade` | 157 | 10 | relevance failure; all ten unrelated applied-science records |
| `secant depth profile PGL(2,11)` | 0 | 0 | explicit empty result, not an API error |

The broad 157-result set was not exhaustively screened and licenses no global negative.  The
novelty verdict is bounded to the exact fingerprints and the inherited C406 coverage.

### Forward-citation and database boundary

- Edge 1985 was pinned by DOI.  OpenAlex and Crossref both resolved the exact title and reported
  `1` citing work; Semantic Scholar returned HTTP 429, so the required three-service closure is
  **NOT COMPLETE**.  OpenAlex's sole citing record, _Arbitrarily large Galois orbits of
  non-homeomorphic surfaces_ (2017), was screened over title/metadata and is unrelated to the
  depth/Hecke claim.
- The 2018 harmonic-analysis preprint was pinned as `10.48550/arXiv.1811.09526`.  OpenAlex resolved
  the exact title and reported `0`; Crossref returned 404 and Semantic Scholar returned HTTP 429.
  This is **NOT COVERED**, not a three-service zero.
- The C406 audit's recorded forward screens remain inherited for the classical matching/design
  layer.  No new absence claim is licensed by treating an API failure as zero.
- zbMATH Open exact-fingerprint web searches returned only generic spherical/double-coset records;
  they did not expose the named finite configuration.  MathSciNet was not institutionally
  accessible and automated Google Scholar remained unavailable: both are **NOT COVERED**.

The safe wording is therefore: **no predecessor for the secant-depth realization of the mixed
double-coset module and its compressed cubic trade was located in the recorded coverage.**  The
double-coset decomposition, marks, Hecke bimodule, and spherical-function distinctions themselves
are classical and carry no novelty claim.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-20-c411-double-coset-hecke.py --check
python3 notes/2026-07-20-c411-double-coset-hecke-replay.py
sha256sum -c notes/2026-07-20-c411-double-coset-hecke.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-20-c411-double-coset-hecke.py --write
```

The primary checker consumes the frozen C406/C378 inputs whose SHA-256 hashes are embedded in the
canonical JSON.  It reconstructs `G,G^+,H,K`, the two sheets, the six `K`-orbits and stabilizers,
the rank-16 oriented relation pairs, and exactly six representative secant-incidence rows.  Its
separate 22-matching pass checks equivariance and fibre constancy.  The independent replay uses the
independent C406/C378 implementation, independently reconstructs the conic projectivity and group
intersection, and recomputes the six representative rows, plane, weighted relation, and cubic
witness.

The trusted boundary is exact Python integer/prime-field arithmetic; the frozen C406 matching orbit
and C378 relation ordering; standard orbit--stabilizer, Mackey double-coset, and matrix-coefficient
facts; and the fact that a product of secant equations vanishes exactly on their union.  The bundle
does not prove priority, an all-field theorem, irreducible spherical decomposition in characteristic
11, or faithfulness as a linear Hecke-module quotient.

| load-bearing artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary checker | 14,335 | `0029b1153bf5b6618ba38d57edb300c89dc2e46762a1be1ed8a3769b23762584` |
| independent replay | 7,555 | `f0cc401f7ed70ab2397ed349116f205cef7dae8647c23a72a7fdf5676e421df0` |
| canonical JSON | 10,552 | `23f0a100356f0a369f00d81011e8d8d6b9d867b9de45a7b0625fc2889323b014` |

## Disposition

C411 passes its conceptual gate.  The exact theorem is the group-mark reduction plus canonical
secant-incidence map and three-term cubic argument, not a new double-coset table.  The profiles are
mixed `K`--`H` matrix-coefficient data, not zonal spherical functions, and their rank-two linear
image is not a faithful bi-Hecke quotient.  The set-separating depth map and cubic pushforward remain
the source-surviving composition.
