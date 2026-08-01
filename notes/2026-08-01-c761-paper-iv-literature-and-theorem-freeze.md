# C761 — Paper IV literature and theorem freeze

**Lane:** `clebsch`

**Date:** 2026-08-01

## Verdict

No predecessor was located for the exact q=13 result: minimum distance 12,
the 364-word minimum layer, its four projective orbits, reconstruction of the
elliptic scheme and passant incidence rows, or the exact automorphism group
from the minimum-support hypergraph. The closest earlier work is closer than
the infrastructure draft made visible. Droms--Mellinger--Meyer introduced the
same passant-line/internal-point parity-check code and bounded its minimum
distance; the later code survey table of Ma--Liu--Tian records, for this code,

\[
  \frac{q+3}{2}\le d\le q-1.
\]

At q=13 this is the interval `8 <= d <= 12`. Paper IV closes the interval at
its upper endpoint and then proves substantially more: classification,
spanning, reconstruction, and symmetry. Madison--Wu prove the general
dimension formula, and Hollmann--Xiang construct the elliptic association
scheme used to explain the minimum layer.

This pass individually discussed five sources: zero were read at full-text
depth in this pass, four at `partial` depth, and one at
`abstract/metadata only` depth. The negative verdict also uses two completely
screened forward-citation sets and four targeted exact-phrase searches.

## Frozen theorem boundary

Let `K` be the binary kernel of the 78-by-78 passant-line/internal-point
incidence matrix, and let `H` be the unlabeled hypergraph of supports of its
weight-12 words. The principal theorem may state all of the following:

1. `K` has parameters `[78,36,12]_2`.
2. `H` has 364 edges in four `PGL(2,13)`-orbits of size 91; one stabilizer is
   `S4` and three are dihedral of order 24.
3. Each of the four orbits spans `K`.
4. Pair and triple concurrence in `H` uniquely recover the six-class elliptic
   relation scheme on the 78 coordinates.
5. The 78 passant incidence rows are exactly the passant seven-cliques with
   zero triple concurrence, so `H` recovers the parity-check matrix up to
   independent coordinate and row permutation.
6. The coordinate-permutation automorphism groups of `K` and `H` coincide and
   are the symmetric-square action of `PGL(2,13)`.

“Reconstruction” does not mean recovery of a preferred conic equation,
projective coordinate system, or row labeling. The theorem is a permutation-
representation statement. It does not claim a uniform minimum-distance
theorem or the all-k conic-filling classification.

## Source ledger

### Droms--Mellinger--Meyer (2006)

- **Identifier:** DOI `10.1007/s10623-006-0022-6`.
- **Read depth:** `abstract/metadata only`. The publisher body and the former
  author PDF at `people.umw.edu/~kmelling/papers/ConicLDPC.pdf` were not
  reachable. The accessible abstract says that the paper studies dimensions
  and minimum distances for the conic point-line LDPC codes. The exact bound
  used above was verified only through the partial full-text reading of
  Ma--Liu--Tian's Table 1, not against the published Droms body.
- **Use:** priority for the code construction and prior distance interval.

### Madison--Wu (2012)

- **Identifier:** DOI `10.1016/j.ejc.2011.08.001`; arXiv `1104.0324`.
- **Read depth:** `partial`, arXiv v1, introduction, Section 2 setup, and
  Corollary 6.3.
- **Access:** cache key `arXiv:1104.0324`, SHA-256
  `f3edf20a2b63286164b3aced06a04a9039d7bbba2eb955a6461b7f7e793f6343`.
- **Finding:** the paper studies the same null space and proves
  `dim K=(q-1)^2/4`; it does not state the q=13 minimum layer or a
  reconstruction theorem in the portions read.

### Hollmann--Xiang (2006)

- **Identifier:** DOI `10.1007/s10801-006-0005-8`; arXiv `math/0503573`.
- **Read depth:** `partial`, arXiv v1, abstract and Sections 1--4.
- **Access:** cache key `arXiv:math/0503573`, SHA-256
  `c7da1c736b1d229228f74cbcc22a77dd848a512e206c1cb88462fc3fd513ab4b`.
- **Finding:** the paper constructs the hyperbolic and elliptic association
  schemes from the `PGL(2,q)` action and cross-ratio orbitals. It does not
  discuss recovery from minimum codewords in the portions read.

### Ball--Lavrauw (2019)

- **Identifier:** arXiv `1908.10772`.
- **Read depth:** `partial`, Section 7 around Lemma 27.
- **Access:** cache key `arXiv:1908.10772`, SHA-256
  `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`.
- **Finding:** Lemma 27 is the coordinate-free lemma of tangents used in the
  weight-eight reduction. This is an imported mechanism, not a novelty claim.

### Ma--Liu--Tian (2024)

- **Identifier:** DOI `10.3934/math.20241421`.
- **Read depth:** `partial`, introduction, conclusion, Table 1, and the
  surrounding minimum-distance discussion.
- **Access:** cache key `10.3934/math.20241421`, SHA-256
  `47c0a52292517a1773a676e2422e7b5a4a7b4bae502b70c1015f8fe87c61c984`.
- **Finding:** its own point-by-quadric codes are different. Table 1 records
  the prior conic-code parameters and bounds, including the
  `(q+3)/2 <= d <= q-1` interval for the code of length `q(q-1)/2` and
  dimension `(q-1)^2/4`. This is secondary evidence for the exact content of
  Droms--Mellinger--Meyer.

## Forward-citation closure

The seed records were resolved by DOI before querying.

For Madison--Wu, DOI `10.1016/j.ejc.2011.08.001` resolved to OpenAlex
`W2963386663` and Semantic Scholar paper
`cbd2326b0dbbd175d0fc8499596718a80538b0b3`. Counts on 2026-08-01 were:

- OpenAlex: 9;
- Crossref `is-referenced-by-count`: 4;
- Semantic Scholar: 10.

The largest set, all 10 Semantic Scholar citing records, was screened over
title and every available abstract. The discriminator was: promote a record
if it treats the passant-line/internal-point null space and any of exact q=13
minimum distance, minimum-word classification, reconstruction, or exact
automorphism group. No record passed. The 2024 quadrics paper mentions minimum
distance, but for its different point-by-quadric row code; its conic table only
repeats the earlier interval.

For Hollmann--Xiang, DOI `10.1007/s10801-006-0005-8` resolved to OpenAlex
`W2120300310` and Semantic Scholar paper
`7feb504cf4725f0a41d9782b3a7f71c7e051efaa`. Counts were:

- OpenAlex: 8;
- Crossref `is-referenced-by-count`: 4;
- Semantic Scholar: 7.

The largest set, all 8 OpenAlex citing records, was screened over title and
every available abstract with the same discriminator. None concerns recovery
of the elliptic scheme from a code's minimum layer.

Load-bearing API queries were:

```text
https://api.openalex.org/works/https://doi.org/<doi>
https://api.openalex.org/works?filter=cites:<openalex-id>&per-page=200
https://api.crossref.org/works/<doi>
https://api.semanticscholar.org/graph/v1/paper/DOI:<doi>?fields=paperId,title,citationCount,externalIds
https://api.semanticscholar.org/graph/v1/paper/<paper-id>/citations?fields=paperId,title,year,externalIds,abstract&limit=100
```

Each service returned a resolved title and a finite count; no empty result was
treated as success. One initial Semantic Scholar request returned HTTP 429 and
was retried once successfully.

## Direct searches and coverage

The following searches were run verbatim over title/full-text web indexes:

```text
"[78,36,12]" binary code
"364" "minimum words" code conic
"passant" "q=13" binary code
"minimum distance" "passant lines" internal points code
```

They located the adjacent conic-code literature but no exact-parameter or
reconstruction predecessor. zbMATH Open DOI queries resolved the Droms and
Madison--Wu records but supplied no review text. MathSciNet was not covered
because institutional authentication is unavailable. Google Scholar was not
used because automated access is blocked. The Droms published body remains the
principal access gap. Therefore manuscript priority prose should either say
“to our knowledge” or, preferably, make the stronger source-positive contrast:
earlier work gave the general dimension and the interval `8 <= d <= 12`, while
this paper proves equality and reconstructs the defining geometry.
