# Novelty audit — Arnold "mathematical trinities" / mysterious-coincidences literature

**Date:** 2026-07-21
**Angle:** the mathematical-trinities / sporadic-coincidence literature, versus the audited claim
(`notes/2026-07-20-cocycle-gateway-explorations.md`, Spikes 1–6 + Synthesis) that the irreducible
rank-3 finite Coxeter groups A3/B3/H3, evaluated at the conic phase `q = h_cox+1 = 5,7,11`, produce a
three-term pattern: doily GQ(2,2) / Fano plane / 11-cell (self-dual geometries), —/[7,4,3] Hamming/
[11,6,5] ternary Golay (perfect codes), with a chirality bit present exactly when the Coxeter parent
leaves `PSL_2(q)`, plus a forecast "two-tower divergence" (codes stop at q=11, self-dual polytopes
continue to q=19 / 57-cell).

**Method.** Keyword search (WebSearch) on each of Arnold's trinities, the A3/B3/H3 trinity, the
L2(5/7/11) Galois primes, the biplane/Fano/11-cell self-dual geometries, the perfect-code
classification, and the L2(q) polytope classification; then neighborhood/citation checks of the named
carrier sources (Dechant's Royal Society trinity paper, Kostant's Galois-letter paper, Baez's This
Week's Finds, le Bruyn's neverendingbooks trinity catalogue, Leemans–Schulte). Each "not found"
statement below rests on at least one keyword angle AND a content check of a named source. Lit-cache
(`/tmp/persistent/tavis/lit-search`) already holds Kostant's paper (`10.1515/dmvm-1995-0405`); no
trinity-specific PDFs otherwise.

---

## Verdict: NOT pre-empted on the composite; the two constituent spines are classical folklore

The audited three-term pattern is a *bridge* between two independently famous trinities. Both spines
are thoroughly established; the specific gluing, the perfect-code layer, the two-tower divergence, and
the chirality=PSL-membership refinement are not found stated together (or, for the code/tower/chirality
items, at all) in the surveyed trinities literature. The work is not pre-empted, but it sits squarely
inside a well-populated "mysterious coincidences" tradition and must credit both parent trinities up
front.

### Spine 1 — the Arnold Coxeter trinity (A3, B3, H3): fully classical

- V. I. Arnold, *Symplectization, Complexification and Mathematical Trinities* (Toronto 1997 lecture;
  webhomes.maths.ed.ac.uk/~v1ranick/papers/arnold4.pdf) and *Mysterious mathematical trinities*
  (1997) — originates the "trinity" program (R/C/H; tetra/octa/icosa; E6/E7/E8; A3/B3/H3 ↔ D4/F4/H4).
- P.-P. Dechant, *From the Trinity (A3, B3, H3) to an ADE correspondence*, Proc. R. Soc. A **474**
  (2018) 20180034, DOI 10.1098/rspa.2018.0034 (found via keyword search; abstract/neighborhood via
  ResearchGate 329567557). Names (A3, B3, H3) as an Arnold trinity and maps it to (D4, F4, H4) and the
  ADE / (E6, E7, E8) trinity via 3D-spinor induction. **Direction is orthogonal to the audited work:**
  Dechant goes A3/B3/H3 → 4D root systems → ADE; he does **not** evaluate at `q = h+1`, and does not
  touch finite geometries, perfect codes, or `PSL_2(q)`. (Note the numeral collision to avoid
  confusing: 5,7,11 appear in Dechant as F4 *exponents* (1,5,7,11), an unrelated occurrence.)

### Spine 2 — the Galois/Kostant L2(5,7,11) trinity: fully classical, and it is the audited geometry spine

- É. Galois' last letter (1832): `PSL_2(p)` acts on p points only for p = 5, 7, 11. This is exactly the
  audited `q = 5,7,11`.
- B. Kostant, *The graph of the truncated icosahedron and the last letter of Galois*, Notices AMS 42
  (1995) 959–968 (cache key `10.1515/dmvm-1995-0405`, the DMV-Mitteilungen printing). Establishes the
  L2(5)/L2(7)/L2(11) coincidence and the point-stabilizer "game" giving the Platonic groups.
- J. Baez, *This Week's Finds* week79 (math.ucr.edu/home/baez/twf_ascii/week79) and week234, and
  twf_dynkin.pdf — popularizes p = 5,7,11 as "the only cases", L2(7)=Fano-plane aut, L2(11)=biplane aut.
  Content check: week79 explicitly ties L2(5/7/11) to the Platonic groups but does **not** mention
  perfect codes, chirality, A3/B3/H3, or the 11-cell.
- L. le Bruyn, neverendingbooks: *Arnold's trinities*, *Galois' last letter*, *the buckyball curve* —
  the standing public catalogue of these coincidences, including the L2(5/7/11) biplane trinity.
- P. Martin & D. Singerman, *The geometry behind Galois' final theorem* (Eur. J. Combinatorics;
  ScienceDirect S0195669812000613) / *From Biplanes to the Klein quartic and the Buckyball* — gives the
  **biplane self-duality** at q=11 explicitly (the 55 point-pairs ↔ 55 line-pairs bijection). So the
  q=11 self-duality that the audited Spike 2/3 leans on is already in this literature.
- Leemans & Schulte, *Groups of type L2(q) acting on polytopes*, arXiv:math/0606660 — the only rank-4
  regular polytopes with an L2(q) group are the 11-cell (L2(11)) and the 57-cell (L2(19)). This is the
  audited "polytope tower".
- Perfect-code classification (van Lint / Tietäväinen): the only nontrivial perfect linear codes are
  Hamming and the binary/ternary Golay codes; ternary Golay is [11,6,5] with L2(11) < M11 < M12. This
  is the audited "code tower".

### What is NOT found in the trinities literature (the audited novelty surface)

1. **A3/B3/H3-at-q=h+1 → doily/Fano/11-cell stated as a trinity.** Not found. The two trinities are
   each famous but are not glued by the `h_cox(A3,B3,H3) = 4,6,10 ⇒ h+1 = 5,7,11` arithmetic anywhere I
   located. Searches pairing "Coxeter number A3 B3 H3 … 5 7 11 PSL(2,q)" surfaced only Dechant's
   spinor/ADE direction. Also a substantive term-mismatch that supports novelty: the classical q=5 term
   in the Galois/Kostant trinity is the **icosahedron** (PSL(2,5)=A5), whereas the audited q=5 term is
   the **doily GQ(2,2)**; the A3→doily (Sylvester synthematic-total / S6-outer) identification as "the
   q=5 slot of the Coxeter trinity" is the audited work's own, though the doily=GQ(2,2)=Sp(4,2)≅S6 facts
   are classical (Sylvester).

2. **Code-tower(7,11) vs polytope-tower(7,11,19) divergence, stated as paired towers.** Not found. Both
   underlying classifications are classical and independently well-known, but no source juxtaposes them
   as two "operational endpoints" that split at q=19. The observation is a *new juxtaposition of
   classical facts*, not a new theorem; its falsifier value ("no spurious q=19 perfect code") is the
   fresh content.

3. **Chirality bit ⇔ PSL-vs-PGL membership, tied across the family.** Not found as such. The self-duality
   of the q=11 biplane and the 11-cell, and the `Aut = PSL_2(q) ≠ PGL_2(q)` duality-coset structure, are
   classical (Martin–Singerman; Leemans). Reifying that outer coset as a one-bit *chirality cocycle*
   uniform across A3/B3/H3 (present iff the parent leaves PSL) is the audited refinement (its own C413/
   C417 machinery), not something the trinities literature states.

### Bounded negatives (searched domain / stop condition)

- Surveyed: Arnold trinities corpus, Dechant Coxeter-trinity paper, Kostant/Galois-letter thread, Baez
  TWF (week79 read; dynkin PDF indexed), le Bruyn neverendingbooks trinity pages, Martin–Singerman
  biplane papers, Leemans–Schulte L2(q) polytopes, perfect-code classification. Two neverendingbooks
  direct fetches failed (ECONNREFUSED / server down) — content recovered via search snippets and the
  Martin–Singerman PDF hosted there; a later re-fetch is advisable if a manuscript-bound "to our
  knowledge" sentence will lean on the neverendingbooks catalogue specifically.
- Not exhaustively searched: physics appearances of PSL(2,7)/PSL(2,11) (M-theory septuples,
  arXiv:1812.11049) — out of scope for a math-priority verdict; the E8/spinor Dechant line beyond the
  trinity paper. Neither bears on the audited code/chirality/tower claims.
- No unrestricted-nonexistence claim is made. The finding is: within the trinities/coincidences
  literature surveyed above, the composite pattern (h+1 bridge + perfect-code layer + two-tower
  divergence + chirality=PSL bit) is unstated, while both constituent trinities and the q=11
  self-duality are prior art that must be credited.
