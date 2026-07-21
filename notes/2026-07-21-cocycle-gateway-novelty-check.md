# Novelty check — cocycle/gateway cross-sheet one-factorization spikes

**Lane:** `crowns` (literature audit of `notes/2026-07-20-cocycle-gateway-explorations.md`)

**Date:** 2026-07-21

**Scope.** Audits the finite-geometry claims in
`notes/2026-07-20-cocycle-gateway-explorations.md` (Spikes 1–6), with context from
`notes/2026-07-20-c417-affine-cocycle-line-bundle.md`. The setting: a `PGL_2(q)`-orbit of
one-factorizations of `K_{q+1}` splits into two `PSL_2(q)` "sheets" of size `q`; cross-sheet
shared-edge counts define incidence structures. This report is a pre-emption / priority check
only; it does not re-verify the note's exact `F_q` computations (those are the note's own
CHECKED certificate).

**Search boundary.** Disk cache `/tmp/persistent/tavis/lit-search` (queried first), plus
WebSearch/WebFetch on `sciencedirect.com`, `springer.com`, `arxiv.org`, `wikipedia.org`,
`groupprops.subwiki.org`, `combinatorics.org`, `neverendingbooks.org`, and Wiley/LMS, on
2026-07-21. Two independent angles were required for every "no predecessor" statement (keyword
search + citation/neighbourhood of a named classical source). No MathSciNet/zbMATH access.

---

## (a) Verdict per claim

| # | Claim | Verdict |
|---|---|---|
| 1 | q=7: cross-sheet disjoint → Fano `2-(7,3,1)`; share-one-edge → complement biplane `2-(7,4,2)` | Ingredients **classical**; the cross-sheet realization is a **plausibly novel composition** |
| 2 | q=11: cross-sheet → `2-(11,6,3)` (11-cell vertex/facet) and `2-(11,5,2)` biplane; outer `PGL\PSL` coset = polarities → "chirality = self-duality" | Objects & self-duality **classical (known)**; **the identification of the sheet-swap with the polarity coset is the plausibly novel core** |
| 3 | `F_2` code of Fano = `[7,4,3]` Hamming; `F_3` code of `2-(11,5,2)` = `[11,6,5]` ternary Golay | **Classical** (note already credits these; novelty claimed only for the route) — confirmed classical |
| 4 | q=5: 5 synthemes of `K_6`, pairwise disjoint = Sylvester synthematic total = one-factorization of `K_6` = spread of `GQ(2,2)` | **Classical**, firmly (Sylvester 1844; S_6 outer automorphism; `GQ(2,2)` = duads/synthemes) |
| 5 | Uniform `2-(q,(q-1)/2,(q-3)/4)` disjoint design = Paley design/biplane | **Classical** identification of the parameter family; realization *from the sheets* rides on claim 1/2 |
| — | `PGL_2(11) ⊄ M_11` (via `PSL_2(11)` maximal in `M_11`) | **Correct**, standard group theory (confirmed) |

**Overall:** every individual geometric/coding object the note names is classical and is already
credited as such in the note. The one part that no located source states is the **construction
mechanism**: obtaining these designs as the *cross-sheet shared-edge incidence between the two
`PSL_2(q)` orbits of conic-secant one-factorizations*, and — the note's central claim —
**identifying the `PGL_2(q)\PSL_2(q)` sheet-swap (the C417 chirality bit) with the polarity /
self-duality of the resulting self-dual design.** That composition is *plausibly novel within
the searched coverage*; state it with bounded wording, never as unrestricted novelty.

---

## (b) Closest prior work (with provenance)

**Cameron & Korchmáros, "One-factorizations of complete graphs with a doubly transitive
automorphism group," Bull. London Math. Soc. 25 (1993) 1–6.**
DOI `10.1112/blms/25.1.1` (Wiley). Found via WebSearch "Cameron Korchmaros doubly transitive
one-factorizations". *This is the closest structural predecessor.* It classifies
one-factorizations of `K_n` whose automorphism group is 2-transitive on vertices: the affine
`AG(d,2)` family plus three sporadics at `n = 6, 12, 28` with full groups **`PGL(2,5)`,
`PSL(2,11)`, `PΓL(2,8)`**. This directly touches the note's `q=5` (`K_6`, `PGL(2,5)≅S_5`) and
`q=11` (`K_12`, `PSL(2,11)`) cases and confirms the automorphism groups the note reports
(`Aut = PSL_2(11)`, outer coset separate). It concerns *single* highly-symmetric
one-factorizations, **not** pairs/orbits of one-factorizations nor a shared-edge cross-incidence
design — so it does not pre-empt the note's construction; it is the natural home literature for it.

**Chen & Lu, "Symmetric factorizations of the complete uniform hypergraph," J. Algebraic Combin.
(2017/18).** DOI `10.1007/s10801-017-0760-8` (cache key same, sha256
`89ca87186c87dbbf745ece30a063e742ea7bbd1b69b1750523ebc4b9f4372b49`). Classifies symmetric
(k,s)-factorizations; the `k=2` case reproduces/extends the Cameron–Korchmáros one-factorization
picture with fractional-linear (`PSL/PGL(2,q)`) groups and Mathieu/Steiner links. Same boundary:
symmetry of factorizations, not a cross-sheet incidence design.

**"The geometry behind Galois' final theorem," European J. Combin. (pii `S0195669812000613`,
ScienceDirect).** Plus the expository **D. Singerman & P. Martin, "From Biplanes to the Klein
quartic and the Buckyball"** (`neverendingbooks.org/DATA/biplanesingerman.pdf`; host was
unreachable at fetch time, corroborated via the ScienceDirect/Elkies/Kostant neighbourhood).
These assemble the *classical* `PSL(2,11)` web: the unique `2-(11,5,2)` biplane, `Aut =
PSL(2,11)`, `S(4,5,11)`/`S(5,6,12)`, ternary Golay, buckyball curve. They give the objects and
their self-duality but **not** the one-factorization-sheet construction.

**11-cell / `2-(11,6,3)`:** B. Grünbaum (1976, hemi-icosahedra) and H.S.M. Coxeter (1984),
self-dual abstract regular 4-polytope `{3,5,3}` with `Aut = PSL(2,11)`; classified as one of only
two such (`q=11`, and `q=19` = 57-cell) by **Leemans & Schulte, "Groups of type `L_2(q)` acting
on polytopes," arXiv:`math/0606660`** (Aequationes Math.). The 11-cell's vertex–facet incidence
*is* the `2-(11,6,3)` design and its self-duality is standard (11-cell Wikipedia;
Leemans–Schulte). This pre-empts the *self-dual design + self-duality* facts (claim 2), but not
their derivation from the sheets nor the sheet-swap = polarity identification.

**`PGL(2,q)` on `q+1` points → designs:** Cameron, Omidi & Tayfeh-Rezaie, "3-Designs from
PGL(2,q)," Electron. J. Combin. 13 (2006) R50, DOI `10.37236/1076` (cache sha256
`dbb91f…4cbce`). Establishes the `PGL_2(q)`/`PSL_2(q)`-orbit-on-blocks machinery on the
projective line; adjacent method, different output.

**Codes (claim 3), classical:** Fano `2-(7,3,1)` `F_2`-code = `[7,4,3]` Hamming, and `2-(11,5,2)`
Paley biplane `F_3`-code = `[11,6,5]` ternary Golay, are textbook (Assmus–Mattson;
MacWilliams–Sloane; errorcorrectionzoo.org "ternary_golay"; Ternary Golay code Wikipedia). The
note credits these as classical and claims novelty only for the sheet route — consistent.

**`K_6` / synthemes / `GQ(2,2)` (claim 4), classical:** Sylvester (1844) duads/synthemes/totals;
6 one-factorizations of `K_6`, the outer automorphism of `S_6` permuting the 6 totals
(arXiv:`0710.5916`, cached; Cameron "the Sylvester design"). `GQ(2,2)` = 15 duads / 15 synthemes
with `Aut = S_6`, and a synthematic total = a spread = a one-factorization of `K_6`
(aeb.win.tue.nl/graphs/GQ22.html). Fully classical; the note's `A3/q=5` reading is a correct
restatement.

**`PGL_2(11) ⊄ M_11`:** confirmed. `M_11` (order 7920) maximal subgroups are `M_10`,
`PSL(2,11)` (order 660, index 12), `M_9:2 = 3^2:Q8.2`, `S_5`, `2.S_4 = GL_2(3)`
(groupprops "Mathieu group:M11"; ATLAS). `PSL(2,11)` is maximal, and `PGL(2,11)` (order 1320)
properly contains it with `PGL(2,11) ≠ M_11`, so `PGL(2,11)` is not a subgroup of `M_11`. The
note's argument and its maximal-subgroup list are correct.

---

## (c) Bounded negatives (searches that came up empty)

- Searched WebSearch for "two PSL(2,q) orbits one-factorizations conic secants shared edge design
  cross incidence" and "pair of one-factorizations complete graph shared edges incidence
  symmetric design polarity self-dual chirality" (2026-07-21): **no hit** describing a symmetric
  design built from *shared-edge counts between two orbits* of one-factorizations, nor any source
  identifying an outer `PGL/PSL` sheet-swap with the *polarity* of such a design.
- Searched "one-factorization K_8 PGL(2,7) Fano plane" and "one-factorization K_12 PSL(2,11) two
  orbits Fano plane biplane" (2026-07-21): returned the Cameron–Korchmáros classification and the
  oval/hyperbola one-factorization literature, but **no** construction of the Fano plane, the
  `2-(11,5,2)` biplane, the `2-(11,6,3)`/11-cell, or the ternary Golay code *from a pair/orbit of
  one-factorizations via cross-sheet incidence*.
- Cache `litcache.py list` scanned for factorization/design/Golay/PSL keys: the relevant hits are
  Chen–Lu (`10.1007/s10801-017-0760-8`) and Cameron–Omidi–Tayfeh-Rezaie (`10.37236/1076`); **no**
  cached source states the cross-sheet construction or the sheet-swap = polarity identification.
- Searched the 11-cell / Leemans–Schulte polytope literature (arXiv:`math/0606660`) for a
  one-factorization origin of the `2-(11,6,3)` incidence or a sheet/chirality reading of its
  self-duality: **not found** at the abstract/metadata level accessible; the self-duality is
  stated intrinsically (polytope duality), not via `PGL_2(11)` cosets acting on matching sheets.

These are bounded negatives over the stated services and date, not claims of nonexistence; a
MathSciNet/zbMATH pass and the full Singerman–Martin text (host down at fetch time) remain
un-checked angles.

---

## Provenance index (re-findable)

- Cameron–Korchmáros 1993 — DOI `10.1112/blms/25.1.1` — via WebSearch, Wiley LMS.
- Chen–Lu 2017 — DOI `10.1007/s10801-017-0760-8` — cache, sha256 `89ca87…4372b49`.
- Cameron–Omidi–Tayfeh-Rezaie 2006 — DOI `10.37236/1076` — cache, sha256 `dbb91f…4cbce`.
- Leemans–Schulte — arXiv:`math/0606660` — WebFetch abstract.
- "Galois' final theorem" — Elsevier pii `S0195669812000613`; Singerman–Martin PDF
  `neverendingbooks.org/DATA/biplanesingerman.pdf` (host unreachable 2026-07-21).
- Out(S_6) — arXiv:`0710.5916` (cached). `GQ(2,2)` — `aeb.win.tue.nl/graphs/GQ22.html`.
- Ternary Golay — `errorcorrectionzoo.org/c/ternary_golay`; Wikipedia "Ternary Golay code".
- `M_11` subgroups — `groupprops.subwiki.org/wiki/Mathieu_group:M11`.
