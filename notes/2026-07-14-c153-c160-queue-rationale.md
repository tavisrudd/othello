# C153–C160 — queue rationale and search directions (2026-07-14)

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing. (Cross-lane; rows are pegged individually to
`clebsch`, `relconic`, `gem-mining`, `cubic`. Pegged here because `gem-mining` owns the review.)

Rationale for the eight items queued out of the 2026-07-14 literature sweeps and the C147 work. The
queue rows themselves are the registry; this note records **why each exists, what its search must
answer, and what I deliberately left out**. Companion to the
[novelty status tables](2026-07-14-novelty-status-review-summary-tables.md).

Sources this rests on: [gem-program vet](2026-07-14-gem-program-vet.md); the sweeps
`2026-07-14-gem-lit-{hexad,exterior-sets,omega-arc,deep-holes,orbit-classification}.md`; the C147
report `2026-07-14-c147-hexad-polarity-characterization.md`.

## The list

| ID | Lane | Work | Why now | Call |
|----|------|------|---------|------|
| C153 | `clebsch` | **BSW originals via ILL** (Giessen 201 (1991) 39–44; Combinatorica 12 (1992) 143–147) | The covering fact — the basis of Prop 3.1 and the `arcs` identification — is "ours" *conditioned on two unread papers*. The 1992 title is literally *Characterization of complete exterior sets of conics* | **Do it.** Same ILL batch as the open Hirschfeld–Sadeh request |
| C154 | `relconic` | **Reed–Muller deep-hole search** | The only NOT SEARCHED residual on the "first deep-hole set = variety" claim. `arcs` owns it and ships first | **Do it.** Cheap; last hole in a load-bearing sentence |
| C155 | `gem-mining` | **Write up the hexad note** | Everything verified; the proof needs no enumeration. Decays if left | **Do it** — but gated on the rigidity/gap check |
| C156 | `gem-mining` | **A source for the 132+132 PSL/PGL split** | CO-TR §8 needs p > 23, so it cannot support it. The "two systems" form of the theorem depends on this | **Do it** — small, folds into C155 |
| C157 | `gem-mining` | **Verify Hirschfeld / Semple–Kneebone theorem numbers** | Inferred, never verified; neither book was accessible | **Only if C155 proceeds** |
| C158 | `cubic` | **k=4 / twisted-cubic healthy search** at q=11, 13 | The one direction where a hit is a new *kind*, not a sibling | **User's call.** Highest upside left; most speculative |
| C159 | `gem-mining` | **U-atlas, first cell**, elliptic targets admitted | C184 has completed the q11 six-arc low-degree cell; the atlas now imports that table and computes the missing q<=11 cells | **Do it without rerunning q11 six-arcs.** Most generative, least targeted |
| C160 | `gem-mining` | **q=5 frame sibling priority** | C187 proves the frame's uncovered locus is its nonsingular invariant conic; only folklore/priority remains | **Literature only.** Do not recompute |

## Why every research row carries search directions

The session's two lessons, both paid for:

1. **Vocabulary across specialties is where the value is.** The same object is named differently by
   finite geometers, design theorists, group theorists, and coding theorists. Edge's "e-points" and
   BSW's "complete exterior sets" are one object 35 years apart; the `D_n` order-n vs order-2n clash
   hid a table match; arXiv's own journal-ref field for 1201.0484 is wrong. A search without the
   right words returns a confident negative.
2. **A search without a declared question returns plausible prose.** Every row below names the
   specific thing to answer, so a "not found" has weight and a hit is recognizable.

### C153 — BSW originals

One question: **does either paper state that the exterior set's joins miss exactly the conic** — that
the uncovered locus is the conic's full F_q-point set? Grep the text for: uncovered, missed, covered,
"not on any", the complement, 0-secant, skew. Also extract the exact conjecture statement and scope
(which q, which sizes, **external-only or mixed-type** — the mixed-type gap is ours only if they never
consider internal points), and whether they cite Edge 1956. Obtaining: ILL the Giessen paper (same
series as Hirschfeld–Sadeh — one batch); for Combinatorica try institutional access, the authors'
homepages, and Seress's memorial/collected pages. **If either states the covering fact, report it
immediately — it forces a rewrite of both manuscripts, and `arcs` ships first.**

### C154 — Reed–Muller deep holes

Search **both** "deep holes of Reed–Muller codes" and "covering radius of RM(r,m)" — the second is the
older and larger literature. Kaufman–Lovett–Porat, Dumer, Abbe–Shpilka–Wigderson. The specific
question: **does any RM deep-hole description identify the set with the rational points of a
variety**, as opposed to a coset/weight description? RM codes are evaluation codes on AG(m,2)/PG, so
a variety-shaped answer is more plausible here than anywhere else — which is exactly why this
residual matters. Distinguish the *complexity* strand from the *explicit description* strand, as the
main sweep did. Sweep GRM over F_q and projective RM too. If a variety-equality exists anywhere in
RM, the "first" must narrow to MDS codes or be dropped.

### C156 — the 132+132 split

Four vocabularies. **Design theory**: "two Steiner systems S(5,6,12)", PSL(2,11)-invariant hexad
systems, Curtis's kitten, Conway–Sloane SPLAG ch. 10–11, Beth–Jungnickel–Lenz. **Group theory**:
PSL(2,11) has two orbits on hexads / PGL(2,11) fuses them, M₁₂ and its two classes, the outer
automorphism of M₁₂. **Coding**: the two ternary-Golay-related hexad systems. **Edge §§29/32**, which
has the same two-systems-swapped-by-the-non-PSL-operations motif for the *external-point* hexagons —
if he states the on-conic version too, that is the citation.

### C157 — the unverified textbook citations

The point↔involution and pencil↔involution correspondences were attributed to Hirschfeld Ch. 8 and
Semple–Kneebone **on inference only**; neither book was accessible and no theorem number is verified.
Either pin exact numbers from a copy, or drop them for sources already verified: CO-TR Thm 1 +
Thm 2(i) for the 66-external/55-internal counts, Nguyen arXiv:1912.12200 §3–4 for pencil↔involution
over any field of char ≠ 2. Coxeter or Hirschfeld–Thas are acceptable for the Desargues involution
theorem. **Do not ship an unverified theorem number.**

### C158 — k=4 / twisted cubic

**Do the dictionary before the search.** Re-derive DMP's R=4 coset correspondence from
arXiv:1909.00207 before writing code: deep holes should be the points on **no trisecant plane** of the
arc. The strategy note flags this unverified, and the red team already killed the
deep-holes-on-the-*developable* and chord-locus versions — only "= the curve itself" survives as an
open question. **Treat the deep-holes sweep's Q4 negative as weak, not settled**: it was the lightest
of its five sections. Search "points on no trisecant plane", "trisecant planes of an arc in PG(3,q)",
the k=4 arc↔coset dictionary, DMP arXiv:1909.00207 Thm 3.1 + Tables 1–2 + Def 7.1(M2)/Thms 7.2–7.3;
twisted cubics in PG(3,q) — Hirschfeld, *Finite Projective Spaces of Three Dimensions* Ch. 21, and
the Bartoli–Marcugini–Pambianco twisted-cubic series. Re-read ZWK arXiv:1901.05445 Thms I.4–I.7,
which subsumes and refutes the GRS shadow. **Then** the search: DFS with plane-masks up to
Stab(twisted cubic) = PGL₂(q), q = 11 and 13; capacity null `C(n,3)(q²+q+1) ≥ q³+q²+q − n` gives
n ≥ 5 at q=11; compute the plane-pencil ceiling first. ~1300 off-cubic points at q=11, symmetry order
1320 — **Rust from the start**, not a Python prototype.

### C159 — the U-atlas

For elliptic targets: search "deep holes" + "elliptic curve", "covering radius" + "elliptic curve
codes"; use the Hasse window `|U| = q+1−a`, `|a| ≤ 2√q` as a sanity null. Re-read
`2026-07-14-gem-lit-deep-holes.md` first — its Q1 verdict is the baseline any new fill must be
checked against, and its Reed–Muller residual (C154) is still open.

**2026-07-15 import boundary:** [C184](2026-07-15-c184-low-degree-uncovered-loci.md) is the
authoritative q11 six-arc seed: all fifteen six-arc classes have exact degree-one through degree-six
rank/nullity rows; exact loci are exhausted through degree five and for C12's six-dimensional
minimum sextic kernel. Import those rows and class labels rather than regenerating them. Do not
convert C184's unexamined larger degree-six kernels into negative results. New C159 computation
begins with the other q<=11 cells and the cross-q comparison.

### C160 — the q=5 frame

[C187](2026-07-15-c187-general-k-arc-conic-filling.md) now settles the finite claim: the standard
frame in `PG(2,5)` has uncovered locus exactly the nonsingular conic
`X²+Y²+Z²+XY+XZ+YZ=0`, and it is the `(k,q)=(4,5)` member of the classification through `k=7`.
Do not rerun that calculation under C160.

The residual is attribution. Search "complete quadrangle" + PG(2,5), "projective frame" + conic,
"diagonal triangle" + conic, and **Edge's own §19** (q=5, on-conic Brianchon — the vet found this is
Edge's only on-conic statement, so he may already have it). Check `[4,1,4]₅` covering radius in the
coding tables. All 4-arcs of PG(2,q) are projectively equivalent, so this is a statement about
PG(2,5) itself and is probably folklore. If it is, it is a one-sentence remark in C155, not a finding
— say so plainly rather than dressing it up. Until this search lands, the equality is verified and
its novelty is unclaimed.

## Deliberately not queued

- **Fixing `gem-lit-omega-arc.md`'s errors** — a warning banner is enough. It is an append-only
  search log, not a live doc; rewriting history there violates the doc discipline.
- **Mixed-type ω_arc / extremal-witness stabilizers** — real new territory (the literature is keyed to
  external points and structurally cannot see it), but the sweep found nobody who cares and there is
  no argument that it is worth compute. Stays an open frontier in the handoff without an ID.
- **The "counting permits, geometry decides" pattern** — three instances now (the healthy census past
  q=11; why-11; octads at q=23). An observation looking for a theorem. Queuing it would dignify it
  beyond what it has earned; it is recorded in the C147 report if a mechanism ever suggests itself.

## Two flags on the ordering

**Only C153 and the running rigidity/gap check can cost us anything.** Everything else on this list is
upside. Every "this is ours" verdict from the 2026-07-14 sweeps — the covering fact, and by extension
the `arcs` identification and `clebsch` Prop 3.1 — is conditioned on two BSW papers nobody has read,
one of which is titled *Characterization of complete exterior sets of conics*. That is the single most
likely place for our result to already exist.

**C155 is gated, not started.** The rigidity/gap check (`2026-07-14-gem-lit-rigidity-gap.md`) is the
first search ever aimed at the `clebsch` paper's headline, and it may change what the hexad note
should be — or what the Clebsch paper is.
