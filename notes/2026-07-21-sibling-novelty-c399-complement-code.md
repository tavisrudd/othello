# C399 sibling novelty re-check — reflection-arrangement complement code (A3/B3/H3)

**Date:** 2026-07-21
**Lane:** `clebsch` (read-only novelty support; no manuscript change)
**Scope:** Independent re-check of whether the *uniform* rank-3 complement-code law
`[(q-h/2)(q-h+1), 3, (q-h/2-1)(q-h+1)]` with nonmirror maximum `q-h+1`, and its
`q = h+1` collapse to the full-conic extended GRS code, is already in print for the
**siblings** A3 (q=5, h=4) and B3 (q=7, h=6), or as a general reflection-arrangement
code theorem covering all three. Requested by the clebsch lane owner to stress-test the
prior C399 audit's "no exact predecessor" verdict.

## Verdict (6 lines)

1. NOT pre-empted. No source states the three-case uniform Coxeter-number law
   `[(q-h/2)(q-h+1),3,(q-h/2-1)(q-h+1)]` or the nonmirror maximum `q-h+1`, for A3, B3, or as a general reflection-arrangement code theorem.
2. The `q=h+1 -> extended-GRS` step is, *in isolation*, the classical conic = normal-rational-curve = doubly-extended Reed-Solomon `[q+1,3,q-1]` fact; its identification as the uniform conic phase of the reflection-complement code is not found.
3. Every ingredient is separately classical: the arrangement-code mechanism (Jurrius-Pellikaan), the complement point count via the finite-field method (char. polynomial), the conic-GRS code, and the A3/B3/H3 icosahedral/conic geometry (Edge/Dye/Calvo).
4. The assembly of these into one `h`-parametrized `[length, 3, distance]` law across A3/B3/H3 is the genuinely new object; confirmed against the prior internal audit.
5. Closest prior work: Jurrius-Pellikaan (generic arrangement code), the reflection-arrangement finite-field method (complement counts only), and conic-GRS — none give per-case *code parameters* for the reflection complements.
6. Bounded negative: two independent angles each (keyword + citation/neighborhood); no reflection-arrangement paper anywhere gives a minimum distance or a dimension-3 code from the complement over F_q.

## Method — two independent angles per claim

**Claim A — uniform reflection-complement code law (dim 3, length, min distance), A3/B3/H3.**
- Angle A1 (keyword): "reflection arrangement code", "code from complement of reflection
  arrangement over finite field characteristic polynomial minimum distance", "'arrangement
  code' reflection arrangement Coxeter number linear code finite field dimension 3". Hits are
  either the *finite-field method* (Athanasiadis-style: cardinality of the complement =
  characteristic polynomial evaluated at q — a **point count**, not a code) or generic
  arrangement/matroid coding theory. No source attaches a dimension-3 generator matrix,
  a minimum distance, or a nonmirror-maximum law to a reflection-arrangement complement.
- Angle A2 (citation/neighborhood): read the two nearest neighbors in cache. Jurrius-Pellikaan
  "Codes, arrangements and matroids" (the general arrangement-decoder mechanism the lane
  already credits) contains no "reflection", "Coxeter", "conic", or "icosahedron" — it is the
  matroid/Tutte weight-enumerator machinery, instantiated on generic arrangements, never on a
  reflection arrangement. Ehrenborg-Klivans-Reading "Coxeter arrangements in three dimensions"
  (arXiv:1501.05991) — the one paper explicitly about rank-3 Coxeter arrangements A3/B3/H3 — is
  purely real spherical-triangle geometry (isometric-regions characterization); it has no finite
  field, no code, no parameters. Plesken-Bächler counting polynomials (DM/447) is generic
  matroid/code counting, no reflection/conic content.

**Claim B — `q=h+1` conic phase -> full-conic extended GRS, uniformly.**
- Angle B1 (keyword): "extended generalized Reed-Solomon code conic PG(2,q) all points [q+1,3]".
  The identity conic = normal rational curve of degree 2 = doubly-extended RS `[q+1,3,q-1]` MDS
  code is standard textbook (Hirschfeld; Roth-Seroussi/Roth-Lempel MDS extensions,
  IEEE T-IT 1057188; arXiv:1104.0324 "On Binary Codes from Conics in PG(2,q)"). It is a known
  fact about *the conic*, stated with no reference to reflection arrangements or a Coxeter number.
- Angle B2 (neighborhood of the exceptional geometry): Edge/Dye/Calvo own the A3/B3/H3
  icosahedral and conic-exterior geometry (Calvo, "The icosahedral line configuration and
  Waldschmidt constants", arXiv:2209.01499; Dye "Hexagons, conics, A5 and PSL2(K)", cached
  scans; the "Trinity (A3,B3,H3)" line, Royal Soc. Proc. A 474:20180034). These give the
  configurations, marker fibres, and relation geometry — not the statement that the reflection
  complement code specializes to the extended-GRS conic code at `q=h+1`.

## Sources (re-findable ids)

- Jurrius, Pellikaan, "Codes, arrangements and matroids", DOI:10.1142/9789814335768_0006
  (cache key `10.1142/9789814335768_0006`, sha256 a5cbdf99...b676). Generic arrangement-code
  mechanism; no reflection/Coxeter/conic instance. Found via: keyword + cache.
- Ehrenborg, Klivans, Reading, "Coxeter arrangements in three dimensions", arXiv:1501.05991
  (cache key `arXiv:1501.05991`, sha256 8ebb11af...2bb1). Rank-3 A3/B3/H3, real geometry only;
  no code. Found via: keyword "reflection arrangement ... A3 B3 H3" + cache.
- Plesken, Bächler, "Counting polynomials for linear codes, hyperplane arrangements, and
  matroids", DOI:10.4171/DM/447 (cache key `DOI:10.4171/DM/447`). Generic counting; no
  reflection/conic. Found via: keyword + cache.
- Reflection-arrangement finite-field method (complement cardinality = characteristic
  polynomial at q): cayley.academic.csusb.edu/content/papers/rfn-hdt.pdf; and
  arXiv:math/9803033 "Character sums associated to finite Coxeter groups" (cache key present).
  Gives complement *counts* (the code length), not a code. Found via: keyword search.
- Drton, Klivans, "A geometric interpretation of the characteristic polynomial of reflection
  arrangements", arXiv:0906.2208. Char. polynomial geometry, no code. Found via: keyword.
- Conic-GRS classical: Roth-Seroussi "On MDS extensions of GRS codes", IEEE T-IT (1986)
  doi 10.1109/TIT.1986.1057188; arXiv:1104.0324. Found via: keyword.
- Calvo, "The icosahedral line configuration and Waldschmidt constants", arXiv:2209.01499;
  Dye 1991 (cache `dye-1991/`); "From the Trinity (A3,B3,H3) to an ADE correspondence",
  Royal Soc. Proc. A 474 (2018) 20180034. Configuration geometry, no complement-code law.
  Found via: keyword search + cache.

## Bounded negative (what the search does and does not establish)

- Searched angles: reflection-arrangement code (finite field), complement finite-field code,
  Coxeter-number arrangement code, JP arrangement-code neighborhood, Edge/Dye/Calvo icosahedral
  geometry, conic/extended-GRS. Engines: WebSearch (US index, July 2026) + the local lit cache.
- Not searched exhaustively: paywalled per-case coding papers that might, in principle, record
  the A3 (q=5) or B3 (q=7) complement code numerically without naming the Coxeter number. The
  q=5 frame code and q=11 Clebsch code themselves are the lane's own prior objects; this check
  found no *third-party* statement of either as an instance of a uniform `h`-law.
- This is a novelty (absence-of-prior-work) result for the *uniform law + conic specialization*,
  not a claim that any single per-case number is unprecedented. The individual configurations,
  the `5/14/22` marker fibres, and the conic-GRS fact remain credited to Edge/Dye/Calvo,
  Jurrius-Pellikaan, and the classical conic-RS literature, exactly as the handoff already states.

## Bottom line

The prior C399 internal audit stands and is reinforced from the sibling side: the uniform
`[(q-h/2)(q-h+1),3,(q-h/2-1)(q-h+1)]` law with nonmirror maximum `q-h+1`, and its `q=h+1`
collapse to the full-conic extended GRS code, are **not** published for A3 (q=5) or B3 (q=7),
nor as a general reflection-arrangement code theorem. The uniform-across-A3/B3/H3 statement is
an assembly of separately-known classical facts, and that assembly is the new contribution.
