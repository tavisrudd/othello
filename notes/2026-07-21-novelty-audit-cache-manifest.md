# Novelty-audit lit-cache manifest mirror (metadata only)

**Date:** 2026-07-21
**Purpose:** Mirror of every lit-cache key added or attempted while populating
`/tmp/persistent/tavis/lit-search` with the works cited across the nine 2026-07-21 novelty-audit
reports. Metadata only — no blobs (copyright/size); blobs live under the ZFS cache. Query with
`python3 /tmp/persistent/tavis/lit-search/bin/litcache.py get <key>`.

Reports mirrored: `cocycle-gateway-novelty-check`, `novelty-galois-exceptional-primes`,
`novelty-arnold-trinities`, `novelty-onefactorization-designs`, `novelty-polarity-chirality`,
`novelty-conic-twotower`, `sibling-novelty-rigidity-lowdegree`, `sibling-novelty-decoding-chirality`,
`sibling-novelty-c399-complement-code` (all dated 2026-07-21, under `notes/`).

## Newly cached (status ok)

| Key | sha256 (first 12) | Title | Source URL |
|---|---|---|---|
| arXiv:1807.11692     | 4491ae490a86 | Regular self-dual and self-Petrie-dual maps of arbitrary valency | https://arxiv.org/abs/1807.11692 |
| arXiv:1812.11049     | 5b98e7fbc13d | The role of PSL(2,7) in M-theory: M2-branes, Englert equation and the septuples | https://arxiv.org/abs/1812.11049 |
| arXiv:1610.02672     | d55a241f0dde | Cunningham & Pellicer, Internal and external duality in abstract polytopes | https://arxiv.org/abs/1610.02672 |
| arXiv:2406.13848     | 025071114634 | Medial layer graphs of self-dual regular and chiral polytopes | https://arxiv.org/abs/2406.13848 |
| arXiv:1602.04661     | 23eee325f23e | The weight distribution of the self-dual [128,64] polarity design code | https://arxiv.org/abs/1602.04661 |
| arXiv:2603.26793     | 1fecbdfdbffd | Chiral moments make chiral measures | https://arxiv.org/abs/2603.26793 |
| arXiv:1711.05866     | e3bb38bb5275 | Fast and Efficient Calculations of Structural Invariants of Chirality | https://arxiv.org/abs/1711.05866 |
| arXiv:1003.2348      | 99ef948b4e13 | Oriented matroids (chirotopes) | https://arxiv.org/abs/1003.2348 |
| arXiv:1111.4496      | 667a23b9a8fd | Cunningham, Constructing self-dual chiral polytopes | https://arxiv.org/abs/1111.4496 |
| arXiv:1510.08375     | 6e0055365596 | Completeness of cubic curves in PG(2,q), q<=81 | https://arxiv.org/abs/1510.08375 |
| arXiv:2101.12722     | 7d0257990787 | On the weight distribution of the cosets of MDS codes | https://arxiv.org/abs/2101.12722 |
| arXiv:0906.2208      | 2ec60b99c64d | Drton & Klivans, characteristic polynomial of reflection arrangements | https://arxiv.org/abs/0906.2208 |
| arXiv:1104.0324      | f3edf20a2b63 | On Binary Codes from Conics in PG(2,q) | https://arxiv.org/abs/1104.0324 |
| arXiv:1812.02804     | 7fd0208e93b4 | Dechant, From the Trinity (A3,B3,H3) to an ADE correspondence (= Proc R Soc A 474:20180034, DOI 10.1098/rspa.2018.0034) | https://arxiv.org/abs/1812.02804 |
| 10.1098/rsif.2010.0297 | 1ee19961e6b9 | Hattne & Lamzin, A moment invariant for evaluating the chirality of 3D objects (PMC3024826) | https://europepmc.org/articles/PMC3024826 |
| eljc:v27i1p37        | db45d7e0d3a8 | Pace & Sonnino, One-factorisations of complete graphs in Desarguesian planes of odd square orders (EJC 27(1) 2020 #P1.37) | https://www.combinatorics.org/ojs/index.php/eljc/article/download/v27i1p37/pdf/ |

## Attempted, recorded not-a-pdf (paywall/HTML — durable "don't re-fetch blind" markers)

No open arXiv/OA copy was found; the publisher landing page (HTML) was recorded so the DOI is not
re-fetched blind.

| Key | Status | Title | Source URL |
|---|---|---|---|
| 10.1112/blms/25.1.1        | not-a-pdf | Cameron & Korchmaros, One-factorizations of complete graphs with doubly transitive automorphism group, BLMS 25 (1993) | https://doi.org/10.1112/blms/25.1.1 |
| 10.1016/j.ejc.2012.03.005  | not-a-pdf | Martin & Singerman, The geometry behind Galois' final theorem, Eur J Combin (pii S0195669812000613) | https://doi.org/10.1016/j.ejc.2012.03.005 |
| 10.1023/A:1005204612043    | not-a-pdf | Geometries of the Group PSL(2,11), Geometriae Dedicata | https://doi.org/10.1023/A:1005204612043 |
| 10.1016/j.jcta.2018.06.008 | not-a-pdf | Korchmaros, Nagy, Pace, One-factorisations of complete graphs arising from ovals in finite planes, JCTA 160 (2018) | https://doi.org/10.1016/j.jcta.2018.06.008 |
| 10.1007/BF02942548         | not-a-pdf | R.H. Dye, The Plane Sextic Curve Fixed by A6, Abh. Math. Sem. Univ. Hamburg | https://doi.org/10.1007/BF02942548 |
| 10.1007/s10623-012-9619-0  | not-a-pdf | Transitive A6-invariant k-arcs in PG(2,q) | https://doi.org/10.1007/s10623-012-9619-0 |
| 10.1007/s00022-019-0470-6  | not-a-pdf | One-factorisations of complete graphs arising from hyperbolae in the Desarguesian affine plane, J. Geom. (2019) | https://doi.org/10.1007/s00022-019-0470-6 |
| 10.1109/TIT.1986.1057188   | not-a-pdf | Roth & Seroussi, On MDS extensions of GRS codes, IEEE T-IT (1986) | https://doi.org/10.1109/TIT.1986.1057188 |

## Pre-existing keys that satisfy report citations (already cached, not re-fetched)

| Key | Title | Report(s) |
|---|---|---|
| 10.1007/s10623-011-9570-5     | Spectral characterization of a graph on flags of the eleven-point biplane (Blokhuis-Brouwer) | onefactorization-designs |
| 10.1007/s10801-017-0760-8     | Symmetric factorizations of the complete uniform hypergraph (Chen-Lu) | cocycle-gateway, conic-twotower |
| 10.1016/0097-3165(95)90051-9  | Primitive arcs in PG(2,q) (Storme-Van Maldeghem) | rigidity-lowdegree |
| 10.1090/conm/632/12631        | The coset leader and list weight enumerator (Jurrius-Pellikaan) | decoding-chirality, c399 |
| 10.1142/9789814335768_0006    | Codes, arrangements and matroids (Jurrius-Pellikaan) | c399-complement-code |
| 10.1515/dmvm-1995-0405        | Kostant, Graph of truncated icosahedron / last letter of Galois (DMV printing) | galois-exceptional, arnold-trinities, conic-twotower |
| 10.37236/1076                 | 3-Designs from PGL(2,q) (Cameron-Omidi-Tayfeh-Rezaie) | cocycle-gateway, conic-twotower |
| 10.4153/CJM-1956-041-6        | Edge, Conics and orthogonal projectivities in a finite plane | rigidity-lowdegree |
| DOI:10.4171/DM/447            | Plesken-Bachler, Counting polynomials for linear codes/arrangements/matroids | c399-complement-code |
| 10.1090/S0002-9947-98-02025-X | Character sums associated to finite Coxeter groups (= arXiv:math/9803033) | c399-complement-code |
| arXiv:0710.5916               | Howard-Millson-Snowden-Vakil, outer automorphism of S6 / invariants of six points | cocycle-gateway, decoding-chirality |
| arXiv:1501.05991              | Coxeter arrangements in three dimensions (Ehrenborg-Klivans-Reading) | c399-complement-code |
| arXiv:1807.00481              | The perfect matching association scheme (Rands) | onefactorization-designs |
| arXiv:1909.08568              | From Farey fractions to the Klein quartic (Singerman et al.) | galois-exceptional |
| arXiv:2103.16904              | Extended coset leader weight enumerator of a twisted cubic code (Blokhuis-Pellikaan-Szonyi) | decoding-chirality |
| arXiv:2209.01499              | The icosahedral line configuration and Waldschmidt constants (Calvo) | c399-complement-code |
| arXiv:2507.00813              | On the association scheme of perfect matchings and their designs (Bamberg-Klawuhn) | onefactorization-designs, conic-twotower |
| arXiv:math/0606660            | Groups of type L2(q) acting on polytopes (Leemans-Schulte) | most reports |

## Scans-only (do NOT re-add)

| Key | Title | Location |
|---|---|---|
| 10.1112/jlms/s2-44.2.270 | R.H. Dye, Hexagons, Conics, A5 and PSL2(K), JLMS 44 (1991) | /tmp/persistent/tavis/lit-search/dye-1991/ (page images + OCR, outside git) |

## Cited but no stable DOI/arXiv id (not fetched into cache)

These are cited in the reports as open web pages, lecture notes, personal preprints, or books with
no DOI/arXiv key, so they are out of scope for keyed caching (some are open PDFs that could be
snapshotted later under a custom key if a manuscript-bound sentence needs one):

- V.I. Arnold, *Symplectization, Complexification and Mathematical Trinities* / *Mysterious
  mathematical trinities* — webhomes.maths.ed.ac.uk (open PDF, no id).
- M. DeVos, *Galois' Exceptional Actions* — sfu.ca lecture notes (open PDF, no id).
- Brouwer, Cameron, Haemers, Preece, *Self-dual, not self-polar* (2003) — qmul designtheory.org
  preprint (open PDF, no id).
- M. Conder, *Constructions for chiral polytopes* — math.auckland.ac.nz preprint (open PDF, no id).
- Singerman & Martin, *From Biplanes to the Klein quartic and the Buckyball* —
  neverendingbooks.org (host intermittently down; no id).
- J. Baez, *This Week's Finds* week79/week234; L. le Bruyn, neverendingbooks trinity pages — blog
  pages, no id.
- Fels & Olver, *On relative invariants* (`ri.pdf`) — no stable id.
- Ezra Brown, *The Fabulous (11,5,2) Biplane*, Math. Magazine 77 (2004); P.J. Cameron,
  *Parallelisms of Complete Designs* (1976); Boros-Jungnickel-Vanstone, *Combinatorica* 11 (1991) —
  print-only / JSTOR, not fetched.
