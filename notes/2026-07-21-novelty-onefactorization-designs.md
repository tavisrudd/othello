# Novelty audit — symmetric designs from shared-edge counts between two orbits of one-factorizations

**Date:** 2026-07-21
**Angle:** design theory / algebraic combinatorics of one-factorizations, metric &
association-scheme structure on the set of one-factorizations (perfect matchings).
**Construction under audit** (from `notes/2026-07-20-cocycle-gateway-explorations.md`, Spikes 1–6):
take the two `PSL_2(q)`-orbits ("sheets", `q` matchings each) of one-factorizations of
`K_{q+1}`; define bipartite cross-sheet incidence by the number of SHARED EDGES (0 or 1); the
disjoint relation gives a symmetric `2-(q,(q-1)/2,(q-3)/4)` design (Fano at `q=7`,
`2-(11,5,2)` Paley biplane at `q=11`), the share-one relation its complement, and the outer
coset `PGL_2\PSL_2` acts as the polarity/self-duality.

## Verdict

- **The scheme-theoretic framing is fully pre-empted and actively researched.** An association
  scheme on perfect matchings whose relations are governed by the number of shared edges (the
  coset-type of a pair of matchings) is classical, and "1-factorizations / hyperfactorizations
  as designs in that scheme" including `PSL_2(q)`-orbit examples is exactly the subject of a
  current paper. Anyone claiming "share-0 / share-1 edge is a new metric/relation on
  one-factorizations" would be pre-empted.
- **The specific mechanism under audit is NOT pre-empted by anything found.** No source builds a
  *symmetric 2-design from shared-edge counts between two orbits* (a cross-sheet / cross-orbit
  bipartite incidence), and none exhibits the Fano plane or the `2-(11,5,2)` biplane *as the
  cross-orbit shared-edge incidence of the two `PSL_2(q)` sheets* with the uniform parameters
  `2-(q,(q-1)/2,(q-3)/4)`. The closest work uses the same actors (matching association scheme,
  `PSL_2(q)` orbits, Cameron's parallelisms) but a different design notion (Delsarte
  `λ`-factorisations *inside* the scheme, not a cross-orbit incidence structure).

So: mechanism = novel as a construction; the ambient objects it is assembled from = all classical.
The gateway note's own credit line ("each classical ingredient is cited") is the right posture.

## Closest prior work, with provenance

1. **Bamberg & Klawuhn, "On the association scheme of perfect matchings and their designs,"
   arXiv:2507.00813v2, 18 Mar 2026** (found: WebSearch "Cameron hyperfactorization ... common
   edges"; full text fetched, saved PDF sha in tool-results). This is the single closest source.
   - It builds the association scheme of perfect matchings of `K_{2n}` from the Gelfand pair
     `(S_2n, S_2 ≀ S_n)` (relations = coset-type / shared-edge structure of a pair of matchings),
     following **Rands** and studies `λ`-factorisations as Delsarte designs via `C[S_2n]`
     representation theory. Main result Thm 4.4 (dual-degree characterisation); Cor. 4.10/4.17
     non-existence results generalising Cameron.
   - It DOES use a `PSL_2(q)` orbit of matchings (Example 5.1, `q=11`): the two `AGL(1,11)`-orbits
     (sizes 11 and 22) of specific matchings on `PG(1,11)` form a `(4,2)`-factorisation of index 1
     related to the Witt design `S(5,6,12)`. This is a design *of matchings inside the scheme*, not
     a symmetric 2-design read off shared-edge counts between two sheets. **No Fano plane, no
     biplane, no symmetric `2-(v,k,λ)`, no self-dual/cross-orbit incidence appears in the text**
     (verified by grep of the extracted PDF: terms `fano`, `biplane`, `symmetric design`,
     `self-dual`, `11-cell` are absent; the only `PSL/PGL` occurrences are Example 5.1).
   - CAUTION recorded: the fast-model WebFetch summary of this paper *claimed* it constructs
     "Fano plane, `2-(11,6,3)` biplane from `PSL(2,q)`-orbits via shared-edge counts." That is a
     summary hallucination — it is not in the paper. Do not cite it as pre-emption.

2. **B.M.I. Rands, "The perfect matching association scheme"** (cited as [20] in Bamberg–Klawuhn;
   also surfaced via WebSearch on ALCO / researchgate). Establishes the scheme, eigenvalues for
   small `n`, and the observation that hyperovals and 1-factorizations are cliques in it. This is
   the origin of the "shared-edge relations on matchings" structure — Question (2)'s answer is
   "yes, known," and this is the primary reference for it. (Also: Godsil–Meagher EKR-for-perfect-
   matchings line of work uses the same scheme.)

3. **Blokhuis & Brouwer, "Spectral characterization of a graph on the flags of the eleven point
   biplane," Des. Codes Cryptogr. 65 (2012) 65–69, DOI 10.1007/s10623-011-9570-5** (lit-cache key
   `10.1007/s10623-011-9570-5`, sha256 `1c5b5406…`). Adjacent but distinct: a 55-vertex graph on
   the flags `(x,B)` of the `2-(11,5,2)` biplane with `(x,B)∼(y,C)` iff `B∩C={x,y}`. Same biplane,
   an incidence-based graph, but on flags — not a cross-orbit one-factorization construction.

4. **Group-orbit side (the "two `PSL_2(q)` sheets" object itself):** Bonisoli, Korchmáros, Rinaldi,
   Cameron on 1-factorizations of complete graphs with `PSL_2(q)`/sharply-transitive automorphism
   groups (WebSearch hits: Cameron–Korchmáros doubly-transitive 1-factorizations; Bonisoli, *J.
   Combin. Des.* 2002; Korchmáros 1994; Rinaldi 2005). These characterise the orbits/one-factors
   but do not form a cross-orbit shared-edge design.

5. **Classical target objects:** Ezra Brown, "The Fabulous (11,5,2) Biplane," *Math. Magazine* 77
   (2004) 87 (Paley biplane = QR development mod 11, `Aut = PSL_2(11)`); Cameron, *Parallelisms of
   Complete Designs* (1976); Boros–Jungnickel–Vanstone, *Combinatorica* 11 (1991) 9–15
   (hyperfactorizations). The Fano/Paley biplane from `PSL_2(q)` is textbook; what is unclaimed is
   obtaining them from cross-orbit shared-edge incidence.

## Two-angle confirmation of the "no exact pre-emption" statement

- **Angle A — keyword search** (WebSearch, multiple phrasings): "symmetric design from shared edges
  between two orbits of one-factorizations … Fano"; "one-factorizations … number of common edges …
  association scheme metric"; "two families of one-factorizations of `K_{q+1}` cross incidence
  shared edge Fano/biplane self-dual"; "Fano `2-(7,3,1)` from one-factorizations of `K_8` shared
  edges"; "`2-(11,5,2)` biplane one-factorizations `K_12` `PSL(2,11)` orbits." None returns a
  cross-orbit shared-edge symmetric-design construction. The nearest recurring hits are the
  matching association scheme (Rands, Bamberg–Klawuhn) and the biplane-from-`PSL_2(11)` classics.
- **Angle B — citation/neighborhood of the named closest source** (Bamberg–Klawuhn 2507.00813):
  read its actual theorems, its `PSL_2(11)` example, and its lineage (Cameron 1976 [5], Rands [20],
  Jungnickel–Vanstone/Boros [3], Stinson [23]). The entire neighborhood is "designs *of* matchings
  *inside* the one scheme" and "hyperfactorizations"; none is a bipartite incidence *between two
  orbits* indexed by shared-edge count. The cross-orbit construction sits outside this cited web.

## Answers to the three key questions

1. **Is a symmetric design ever built from shared-edge counts between two orbits of
   one-factorizations?** Not found. This cross-orbit incidence mechanism appears novel.
2. **Is there a known association scheme / metric on one-factorizations with relations
   "share 0 / share 1 edge"?** Yes — the perfect-matching association scheme (Rands;
   Godsil–Meagher; Bamberg–Klawuhn 2026). The shared-edge relational structure is classical; the
   audited construction should cite it rather than claim it.
3. **Any prior "cross-orbit incidence design" from 1-factorizations?** None found. The Fano /
   Paley biplane realised as the two-sheet shared-edge incidence is, to the search's reach, unclaimed.

## Bounded negatives / boundary of this audit

- Searched July 2026 via WebSearch (English, US index) and the local lit-cache; no systematic
  MathSciNet/zbMATH pass. A "cross-orbit incidence design from one-factorizations" could exist in a
  pre-2000 design-theory monograph not surfaced by web search (e.g. a Wallis/Wanless
  one-factorization text); this audit did not read those cover-to-cover.
- The audit confirms non-pre-emption of the *construction mechanism*, not of every downstream
  identification. The individual identifications the note makes (Fano = `[7,4,3]` Hamming;
  `2-(11,5,2)` ↔ ternary Golay; `Aut(11-cell)=PSL_2(11)`; Paley biplane uniqueness for `q≡3 mod 4`)
  are each classical and separately citable; they are ingredients, not the novelty.
- The `2-(q,(q-1)/2,(q-3)/4)` parameter family = the Paley/Hadamard biplane series; its *existence*
  for `q≡3 mod 4` is classical. Novel content is only the *realisation map* (two `PSL_2(q)` sheets
  → this design via shared edges) and the polarity = outer-coset/chirality identification.
