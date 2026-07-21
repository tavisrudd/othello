# Sibling / general-predecessor novelty audit — Clebsch decoding headlines D1 & D2

**Date:** 2026-07-21
**Lane context:** `clebsch` (read-only inputs). This is a novelty/priority audit, not a task
allocation or manuscript edit.

## Scope

The Clebsch hexagon code is the `[6,3,4]` MDS code whose `3×6` parity-check columns are the six
points of the Clebsch `6`-arc in `PG(2,11)`. Syndromes live in `F_11^3`, i.e. as points of the
plane `PG(2,11)` that contains the arc. Two decoding headlines are audited for a sibling or general
predecessor:

- **D1 — syndrome-conic distance oracle:** the syndrome point's position relative to a fixed conic
  gives a constant-time (closed-form) coset-weight / minimum-distance oracle, replacing search.
- **D2 — support chirality:** the complete weight-3 coset-leader census reconstructs a
  Brianchon/Petersen support geometry and an intrinsic unordered `10+10` bipartition of the
  coset-leader supports.

Confirmation discipline: each verdict is checked on two independent angles — keyword search AND a
citation / classical-structure neighborhood. All sources carry a re-findable id.

---

## D1 — syndrome-conic distance oracle

**Verdict: KNOWN INSTANCE of an established general framework — not new as a decoding mechanism.**
The Clebsch-specific residue that survives is the *rigidity* statement (that this particular arc's
maximum-weight syndrome locus is itself a conic), not the "conic gives closed-form coset weight"
oracle.

### Closest prior work

1. **Jurrius & Pellikaan, "The coset leader and list weight enumerator," Contemp. Math. 632 (2015),
   DOI `10.1090/conm/632/12631`** (litcache key `10.1090/conm/632/12631`, sha256
   `99a2c5d1625af85d4c5560276b45728acaba347dd13f88d789d49b792f714b95`).
   - **Example 5.10** is exactly the sibling: "Let `C` be an MDS code with parameters `[n, n−3, 4]`
     with parity check matrix `H` over `F_q`. Then the projective system `P` of `H` consists of `n`
     points in the projective plane `P^2(F_q)` such that no three points of `P` are on a line. This
     means that `P` is an arc." The Clebsch code is this with `n = 6`.
   - The coset-leader weight of a syndrome is read off *geometrically* from the syndrome point's
     incidence with the arc: a point of `P` (weight 1), a point on a secant/derived-arrangement line
     (weight 2), else weight 3. For the complete-arc case (`P` a conic, `n = q+1`) the paper gives
     the classical point/line trichotomy of a conic in `PG(2,q)` — external `((q+1)/2` per point:
     two tangents, `(q−1)/2` secants, `(q−1)/2` exterior lines), on-conic, and internal points — and
     turns it directly into the closed-form `α_i(T)`. This *is* a closed-form conic distance oracle.
   - The general engine (coset weight = position of the syndrome point in the derived hyperplane
     arrangement / Möbius lattice of the dual projective system) is the same "arrangement–decoder
     mechanism" the `clebsch` handoff already credits to Jurrius–Pellikaan.

2. **Blokhuis, Pellikaan, Szőnyi, "The extended coset leader weight enumerator of a twisted cubic
   code," arXiv:`2103.16904` (Des. Codes Cryptogr. 2022, DOI `10.1007/s10623-022-01060-0`)**
   (litcache key `arXiv:2103.16904`).
   - Intro, verbatim: the coset leader weight enumerator "depends on the geometry of the associated
     projective system of the dual code," and "In case of the `[q+1, q−2, 4]_q` code where the
     associated projective system consists of the `q+1` points of an irreducible plane conic, the
     answer **[16]** depends on whether the characteristic is odd or even." Reference **[16] is the
     Jurrius–Pellikaan paper above** — the citation neighborhood (angle 2) confirms the conic case
     is the acknowledged prior result, and the twisted-cubic paper is the `PG(3,q)` sibling one
     dimension up (a genus-1 curve replaces the conic; the same "syndrome point vs. curve" oracle).
   - The syndrome framework is spelled out: "The syndrome `s` ... gives a one-to-one correspondence
     between cosets and syndromes. An element of minimal weight in its coset corresponds one-to-one
     to a minimal way to write its syndrome as a linear combination of the columns of a given parity
     check matrix," with columns viewed as a projective system.

3. **"On the weight distribution of the cosets of MDS codes," arXiv:`2101.12722`.** Section 6,
   "Arcs in the projective plane `PG(2,q)` and the weight distribution of the cosets of MDS codes of
   distance `d=4`," treats exactly the `[n, n−3, 4]` arc code family (including a 6-arc `[6,3,4]`
   instance) and, verbatim from the fetched text, "use[s] their connections with the conics and
   hyperovals in the plane `PG(2,q)`." Independent, more recent confirmation that the conic-geometry
   coset-weight route for arc/`d=4` MDS codes is standard.

### Two-angle confirmation

- **Keyword:** searches for "coset leader weight enumerator MDS arc conic syndrome" and "conic
  quadric closed-form syndrome distance oracle" return the Jurrius–Pellikaan / Blokhuis–Pellikaan–
  Szőnyi line and 2101.12722 as the canonical hits; the classical conic point-classification is the
  oracle.
- **Citation / classical:** 2103.16904 cites Jurrius–Pellikaan `[16]` precisely for the conic
  `[q+1,q−2,4]` case; the internal/external-point trichotomy of a conic in `PG(2,q)` is textbook
  (Hirschfeld). Both angles agree.

### Bounded negative / surviving Clebsch residue

The generic oracle "classify a syndrome point against the arc's conic in closed time" is prior art.
What is *not* subsumed is the Clebsch rigidity claim that the maximum-distance (covering-radius-3)
syndrome locus of *this specific* `6`-arc coincides with a distinguished conic (the `A5` 12-point
orbit conic). That is a statement about one arc's exceptional geometry, not the decoding mechanism,
and must be framed as such — the "conic distance oracle" phrasing should credit Jurrius–Pellikaan
for the mechanism and reserve novelty for the arc-specific conic-containment rigidity.

Coverage limits: the Golay/Paley `q=5,19` conic-code coset spectra were not exhaustively read;
2101.12722 §6.2 detail could not be extracted from the PDF (parse failure) beyond the section header
and the "conics and hyperovals" sentence. Neither gap can resurrect novelty for the mechanism, which
is already explicit in a 2015 paper.

---

## D2 — support chirality (unordered 10+10 coset-leader-support bipartition)

**Verdict: NO sibling or general predecessor found for the coding-theoretic framing.** The
underlying combinatorial split is classical, but its identification as a code's *coset-leader-support
bipartition* ("support chirality") has no located predecessor in any sibling code.

### What is classical (and must be credited)

The `20 = C(6,3)` triples of six points split canonically into two unordered sets of `10`, with a
Petersen structure, via the outer automorphism of `S_6` / the invariant theory of six points:

- **Howard, Millson, Snowden, Vakil, "A description of the outer automorphism of `S_6`, and the
  invariants of six points in projective space," arXiv:`0710.5916`** (also litcache key
  `arXiv:0710.5916`). The `20` triangles on six vertices divide into two sets of `10`; the outer
  automorphism organizes six points in projective space, conic-stabilized, with the associated
  Petersen/synthematic combinatorics. This is the classical source of the `10+10` and the
  Brianchon/Petersen geometry, and pre-empts any novelty claim for the *split itself*.

### What is not found for any sibling

- **Hamming `[7,4,3]` (q=7 sibling):** coset leaders are only the zero vector and the seven weight-1
  vectors (the code is perfect, covering radius 1). There is no nontrivial weight-3 support census
  and hence no `10+10` structure — Hamming cannot host a D2 analogue.
- **Ternary Golay `[11,6,5]`:** literature on its `35`/`243` cosets (Assmus–Mattson designs,
  orbit/coset analyses) was searched; **no "chirality," "`10+10`," "support bipartition," or
  "two-coloring" of its coset leaders** appears. Independent to this: the `crowns` exploration
  (`notes/2026-07-20-cocycle-gateway-explorations.md`, refinement of forecast 3) already proves the
  Clebsch chirality is the `PGL_2(11)/PSL_2(11)` polarity and is **not** an automorphism of the
  Golay code (`PGL_2(11) ⊄ M_11`) — so no Golay-inherited predecessor can exist by construction.
- **General GRS / self-dual codes:** searches for "self-dual code coset-leader support bipartition /
  two-coloring / chirality" return only unrelated self-dual-code / symmetric-design work; none
  bipartitions coset-leader supports into two canonical classes.

### Two-angle confirmation

- **Keyword:** "ternary Golay coset leaders Petersen 10 supports," "self-dual code coset leader
  support bipartition chirality," "coset leader Petersen/Brianchon chirality" — all return no
  matching prior result.
- **Citation / classical structure:** the `10+10` split of the `20` triples is traced to its
  classical source (outer automorphism of `S_6`, invariants of six points; arXiv:0710.5916), and
  the crowns group-theory result independently rules out the chirality being a Golay/`M_12`
  symmetry. Both angles agree: the combinatorics is old, the coset-leader-support-chirality *coding*
  statement is not attested for a sibling.

### Bounded negative

Negative established over: (i) keyword searches on Golay/Hamming/self-dual/GRS coset-leader
chirality and support bipartition; (ii) the classical `S_6`/six-points neighborhood. Not a
universal nonexistence claim — the ternary-Golay coset-leader literature was not read exhaustively,
and 2101.12722 §6.2's weight-3 coset detail for the 6-arc could not be extracted from the PDF, so a
buried "20 supports split 10+10" remark there cannot be fully excluded. Credit for the `10+10` split
and Petersen/Brianchon geometry belongs to the classical `S_6`/six-points literature; the surviving
candidate novelty is only the *composition* — naming that classical split the intrinsic
coset-leader-support chirality of the `[6,3,4]` Clebsch code.

---

## Provenance table

| id | how found | role |
|---|---|---|
| `10.1090/conm/632/12631` (Jurrius–Pellikaan 2015) | litcache (already cached), Ex. 5.10 | D1 general framework + conic case |
| `arXiv:2103.16904` (Blokhuis–Pellikaan–Szőnyi) | litcache + web | D1 citation neighborhood: cites [16] for conic `[q+1,q−2,4]` |
| `arXiv:2101.12722` (weight distribution of MDS cosets) | web search (multiple queries) | D1: §6 arcs/`d=4` MDS cosets via conics/hyperovals |
| `arXiv:0710.5916` (Howard–Millson–Snowden–Vakil) | web + litcache | D2: classical `10+10` split of 20 triples of six points |
| `notes/2026-07-20-cocycle-gateway-explorations.md` | repo (crowns) | D2: chirality = PGL/PSL polarity ≠ Golay/`M_12` symmetry |
