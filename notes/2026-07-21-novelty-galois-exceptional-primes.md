# Novelty check — Galois exceptional-primes angle on the cocycle/gateway cross-sheet spikes

**Lane:** `crowns` (literature audit of `notes/2026-07-20-cocycle-gateway-explorations.md`)

**Date:** 2026-07-21

**Angle audited.** The "Galois exceptional primes" / exceptional small `PSL_2(p)` actions
literature — Galois' last letter (`PSL_2(p)` transitive on `p` points iff `p = 5, 7, 11`),
Kostant/Elkies buckyball work, the Klein-quartic / `PSL_2(7)` web, the `PSL_2(11)` web
(biplane, `S(4,5,11)`, ternary Golay, 11-cell), and the expository "Galois' final theorem" /
"Biplanes to Klein quartic and Buckyball" thread. This complements the finite-geometry /
one-factorization audit already in `notes/2026-07-21-cocycle-gateway-novelty-check.md`; it does
not re-verify the note's exact `F_q` computations.

**Three questions carried into the search.**
1. Does anyone in this literature construct these objects from **pairs / orbits** of
   one-factorizations, or identify the `PGL/PSL` outer coset with a design **polarity / chirality**?
2. Is the trio `q = 5, 7, 11` anywhere described as producing **doily / Fano / 11-cell uniformly**?
3. Is there a **chirality / handedness one-bit invariant** attached to these exceptional actions?

**Search boundary.** Disk cache `/tmp/persistent/tavis/lit-search` (queried first), plus WebSearch
and WebFetch on `ams.org`, `sfu.ca`, `sciencedirect.com`, `springer.com`, `arxiv.org`,
`wikipedia.org`, `neverendingbooks.org`, `researchgate.net`, `academia.edu`, and
`math.auckland.ac.nz`, on 2026-07-21. Every "no predecessor" line below is backed by two independent
angles: a keyword search **and** a neighbourhood/content check of a named classical source. No
MathSciNet/zbMATH access; several publisher full texts returned HTTP 403 and were reached via
cached/alternate copies or abstracts.

---

## Verdict

**The core mechanism is NOT pre-empted in the Galois-exceptional-primes literature.** Across every
canonical source in this field that I could reach, the exceptional `q = 5, 7, 11` story is told
through the **standard point actions and their Platonic/incidence realizations** — icosahedron (`A5`)
at `q=5`, Fano plane at `q=7`, `2-(11,5,2)` biplane / 11-cell at `q=11` — and never through:

- pairs / orbits of one-factorizations of `K_{q+1}` and their **cross-sheet shared-edge incidence**;
- an identification of the `PGL_2(q) \ PSL_2(q)` outer coset (sheet-swap) with a **design polarity /
  self-duality**, packaged as a **one-bit chirality** invariant;
- a **uniform doily / Fano / 11-cell** framing of the trio.

On the three questions: (1) **No** — no source builds from one-factorization pairs/orbits, and none
equates the outer coset with a design polarity/chirality. (2) **No, and the note's `q=5` object is
non-standard for this field:** the canonical Galois-exceptional trio pairs `q=5` with the
**icosahedron** (`PSL_2(5) ≅ A5` on 5 points), not the **doily `GQ(2,2)` / Sylvester synthematic
total** the note uses (which comes from the `A3`/`K_6`/`S_6`-outer world, a *different* classical
strand). The note's uniform "doily / Fano / 11-cell" tower is therefore an unusual re-framing, not
the textbook trio. (3) **No** — "chirality" does appear in the adjacent *chiral-polytope / chiral-map*
literature, but it is a **different notion** (orientation-preserving vs reflexible automorphism
group), not a `PGL\PSL` = self-duality bit; see the boundary note below.

This matches and extends the finite-geometry audit's conclusion: every named object is classical, and
the **plausibly novel core is the construction mechanism** — designs as cross-sheet incidence between
the two `PSL_2(q)` orbits, with the sheet-swap = polarity = one-bit chirality. State it with bounded
wording, never as unrestricted novelty.

---

## Closest prior work in this field (with provenance)

**B. Kostant, "The Graph of the Truncated Icosahedron and the Last Letter of Galois," Notices AMS
42 (1995) 959–968** (`ams.org/notices/199509/kostant.pdf`, HTTP 403 at fetch; corroborated via
WebSearch summary + `neverendingbooks.org` "the buckyball symmetries"). Also the DMV-Mitteilungen
version cached as key `10.1515/dmvm-1995-0405` (manifest `ok`; no text extraction). This is the
canonical "last letter of Galois" source. It realizes the buckyball from the **60 order-11 elements**
of `L_2(11)` (a conjugacy class → vertices; commutator condition → hexagon edges) and embeds the
Paley biplane in the genus-70 buckyball surface. It is the nearest work that ties `PSL_2(11)`,
`PSL_2(5) ↪ PSL_2(11)`, the biplane, and a distinguished small structure together — **but it uses a
conjugacy-class graph, not one-factorization sheets, and has no cross-sheet incidence, no polarity =
outer-coset identification, and no one-bit chirality.** Closest in spirit; disjoint in mechanism.

**"The geometry behind Galois' final theorem," European J. Combin. (ScienceDirect pii
`S0195669812000613`)** — fetched the PDF (53 KB); text extraction yielded **no** occurrence of
one-factorization, synthematic total, chirality, self-duality, polarity, doily, or Sylvester. It
assembles the classical `PSL_2(5/7/11)` incidence web (Platonic solids, Fano, biplane) without the
note's construction. (Already cited in the finite-geometry audit; here confirmed negative on all
mechanism keywords by direct content check.)

**M. DeVos, "Galois' Exceptional Actions" (lecture notes, `sfu.ca/~mdevos/notes/comb_struct/
galois-ex.pdf`)** — fetched and `pdftotext`-extracted in full. Gives the textbook trio: `PSL_2(5)` =
icosahedral rotations (`A5`), `PSL_2(7)` = Fano plane, `PSL_2(11)` = the `2-(11,5,2)` design via a
Petersen embedding; closes with the "point stabilizers are `A4, S4, A5` = Platonic rotation groups"
coincidence. **No one-factorizations, no doily at `q=5`, no chirality, no polarity/self-duality
reading.** This is the clean statement of what the standard trio *is* — and it is not the note's.

**D. Singerman & P. Martin, "From Biplanes to the Klein Quartic and the Buckyball," and D. Singerman
et al., "From Farey fractions to the Klein quartic and beyond" (arXiv:`1909.08568`, cached, sha in
manifest).** The Farey paper (read in full via cache) is about **side-pairings of hyperbolic
polygons** for the Klein quartic mod 7, i.e. edge pairings of a single fundamental polygon — not
one-factorization orbits of a complete graph, and no chirality/polarity bit. The Biplanes-to-Buckyball
expository piece (`neverendingbooks.org` host unreachable, ECONNREFUSED 2026-07-21; corroborated via
the neverendingbooks buckyball articles and the Kostant neighbourhood) assembles the `PSL_2(11)` web
and the biplane's self-duality but not via matching sheets.

**"Geometries of the Group `PSL(2,11)`," Geometriae Dedicata (DOI `10.1023/A:1005204612043`;
`springer.com` / `academia.edu`).** Catalogues the `PSL_2(11)` geometries (biplane, designs, the
outer `PGL_2(11)` extension as the order-2 outer automorphism). Confirms the outer-coset / self-dual
facts the note uses are classical, but presents them intrinsically, **not** as a one-factorization
sheet-swap.

**Chiral polytopes / self-dual maps (boundary, different "chirality").** Conder et al.,
"Constructions for chiral polytopes" (`math.auckland.ac.nz/~conder/preprints/chiralpolytopes.pdf`);
"Regular self-dual and self-Petrie-dual maps" (arXiv:`1807.11692`); Leemans–Schulte `L_2(q)`
polytopes (arXiv:`math/0606660`). Here **"chiral"** means the automorphism group is
orientation-preserving with no reflexion (no automorphism inverting both generators), and
**"self-dual"** means an automorphism swapping the two generator classes. These are the same *words*
the note uses but a **distinct construct**: the note's "chirality" is a one-bit `PGL\PSL` coset =
design-polarity label on a *self-dual symmetric design*, whereas this literature's chirality is a
property of a map/polytope's rotation group. Recording the collision so the manuscript does not import
"chirality" as if it were this field's term.

---

## Bounded negatives (searches that returned no predecessor)

- WebSearch "Galois exceptional primes 5 7 11 PSL_2 uniform construction Sylvester doily Fano plane
  11-cell" (2026-07-21): returned the geometry-behind-Galois'-final-theorem paper and the DeVos notes;
  **no** source presents the trio uniformly as doily/Fano/11-cell, and none couples `q=5` to the
  doily/`GQ(2,2)` rather than the icosahedron.
- WebSearch "Elkies Kostant truncated icosahedron last letter of Galois PSL_2(11) buckyball chirality"
  and "`PSL(2,11)` biplane 11-cell self-duality polarity outer automorphism PGL chirality bit"
  (2026-07-21): returned Kostant, the 11-cell/biplane self-duality, and the `PGL_2(11)` outer
  automorphism — but **no** identification of that outer coset with a one-bit chirality of a
  cross-sheet design, and no one-factorization origin.
- WebSearch "one-factorization complete graph two orbits PSL PGL outer coset polarity self-dual design
  chirality" and "conic secants one-factorization K_{q+1} PGL_2(q) two PSL orbits Fano plane biplane
  cross incidence" (2026-07-21): returned the ovals/one-factorization literature (single symmetric
  one-factorizations) and Cameron–Korchmáros-type classifications; **no** construction of a design
  from shared-edge counts between *two orbits* of one-factorizations, and no sheet-swap = polarity.
- Content checks (not just titles): DeVos notes (full `pdftotext`), geometry-behind-Galois'-final-
  theorem PDF (full extraction), Singerman Farey paper (cached full text) — **none** contains
  "one-factorization", "syntheme/synthematic total", "chirality", "doily", or an outer-coset =
  polarity statement.

These are bounded negatives over the stated services and date, not nonexistence claims. Un-checked
angles remain: MathSciNet/zbMATH; the full Kostant AMS text (403) and full Singerman–Martin biplane
PDF (host down); Elkies' Klein-quartic essays beyond their abstracts.

---

## Provenance index (re-findable)

- Kostant, Notices AMS 42 (1995) — `ams.org/notices/199509/kostant.pdf` (403; via WebSearch +
  neverendingbooks). DMV version cached key `10.1515/dmvm-1995-0405`.
- "Geometry behind Galois' final theorem" — ScienceDirect pii `S0195669812000613` (PDF fetched,
  53 KB, extracted, negative on all mechanism keywords).
- DeVos, "Galois' Exceptional Actions" — `sfu.ca/~mdevos/notes/comb_struct/galois-ex.pdf` (fetched,
  full text extracted).
- Singerman et al., Farey → Klein quartic — arXiv:`1909.08568` (cache, full text read).
- Singerman–Martin, Biplanes → Klein quartic → Buckyball — `neverendingbooks.org/DATA/
  biplanesingerman.pdf` (host unreachable 2026-07-21).
- "Geometries of the Group `PSL(2,11)`" — DOI `10.1023/A:1005204612043` (Springer / academia.edu).
- Chiral polytopes — Conder, `math.auckland.ac.nz/~conder/preprints/chiralpolytopes.pdf`; self-dual
  maps — arXiv:`1807.11692`; `L_2(q)` polytopes — arXiv:`math/0606660`.
- Ovals one-factorization — ScienceDirect pii `S0097316518300803` (403; title/abstract via WebSearch).
