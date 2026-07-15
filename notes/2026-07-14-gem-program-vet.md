# Gem-program vet — adversarial audit against the 2026-07-14 literature sweep

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing. (Audit deliverable. §2 bears directly on
`clebsch` (C146); §2.2 concerns the `relconic` manuscript, read-only — findings there are handed to
that lane, not acted on here.)
**Date**: 2026-07-14

This note vets the gem-mining/Clebsch program's claims against the four literature-sweep reports
(`2026-07-14-gem-lit-{hexad,exterior-sets,omega-arc,deep-holes}.md`), with every load-bearing claim
re-checked against a source opened in this audit, not taken from any prior summary. Sources opened
first-hand here: Edge 1956 (full pdftotext, §§1, 4, 18–32 read, whole file grepped), Edge 1965a
(fetched + extracted this audit), Lord 1988 (fetched + extracted this audit — previously
paywalled-at-403, now obtained from the IAS repository), Van de Voorde arXiv:1201.0484 (extraction,
§§1.1–1.2 and §3 read), Zhang–Wan–Kaipa arXiv:1901.05445 (extraction, Thm I.7 + tangent-line remark),
Davydov–Marcugini–Pambianco arXiv:2101.12722 v2 (extraction, Thms 4.6, 6.3, 7.7, table (6.1)), Dover
arXiv:2505.08551 (extraction), Innamorati–Zannetti (extraction), Meagher–Spiga arXiv:0910.3193
(extraction), Halbeisen–Hungerbühler (extraction + Springer record), Havlicek arXiv:1210.2055
(abstract), Tranchida arXiv:2411.10299 (abstract), Yip arXiv:2407.21362 (targeted fetch), OpenAlex
(live citation query for BSW 1992), OEIS (live query), and both manuscripts in full. **Not opened by
anyone in this program**: BSW Giessen 1991, BSW Combinatorica 1992 (both ILL-only; everything about
them below is via Van de Voorde), the Sadeh thesis, Dye 1991, the published AMC version of DMP, and
one 2024 BSW-citer ("Selected results in combinatorics and graph theory"). Claims resting on those
are tagged accordingly.

Tags: **VERIFIED** (source opened in this audit; quote + location), **INFERRED** (abstract/summary
or secondary source only, said per item), **UNRESOLVED**, **REFUTED**.

---

## 1. Verification pass

### 1.1 Edge 1956 §§29–32 — the 22-vs-11 question: SETTLED, no conflict

**VERIFIED** against the primary extraction (`edge1956a.txt`, from
https://webhomes.maths.ed.ac.uk/~icheltso/edge2016/pdf/1956a.pdf). The two sub reports emphasized
different sentences of the same consistent passage; both are correct, and the "22 = two systems of
11" reconciliation — asserted in the handoff without a primary read — happens to be exactly what
Edge says:

- §29: *"Given the conic χ there are 22 Clebsch hexagons ℋ all of whose vertices are e-points and
  diagonals s-lines; each of the 66 e-points is a vertex of 2 ℋ that belong one to each of 2
  imprimitive systems of 11 ℋ. Either system supplies a representation of Ω⁺(3,11) as a permutation
  group of degree 11. The operations of Ω(3,11) that are outside Ω⁺(3,11) transpose the 2 systems."*
- §31: *"ℋ … is one of 660 ÷ 60 = 11 Clebsch hexagons permuted transitively by Ω⁺(3,11). … The
  vertices of the 11 ℋ account for all 66 e-points."* (Also §31: the hexagon's stabilizer is "a
  maximal icosahedral subgroup of order 60.")
- §32: *"there is a second set of 11 Clebsch hexagons 𝒟 … Thus Ω(3,11) is transitive on 22 Clebsch
  hexagons ℋ and 𝒟 … Each e-point is a vertex of a single ℋ and a single 𝒟."*

So: 22 hexagons over a fixed conic; one full PGL₂(11)-orbit (22 = 1320/60); two PSL₂(11)-systems of
11; each system partitions the 66 external points; each external point lies on exactly one hexagon
of each system; the two systems are swapped exactly by the hyperbolic (non-PSL) operations. Edge's
§30.1 gives the explicit vertex set (3,1,0), (−3,1,0), (1,0,3), (1,0,−3), (0,3,1), (0,−3,1); §30.2
the five triangles Δ₀…Δ₄ forming a synthematic total; §30.3 the ten concurrence points, all
internal. Edge's §4 (line 163 of the extraction) fixes the vocabulary: "We may call external points
e-points, and internal points i-points."

Two collateral facts from the primary read, both new to the program's record:

- **Edge's count independently corroborates the census's stabilizer claim**: 22 hexagons per conic
  = |PGL₂(11)|/60, which is exactly the `gem_sweep.py` claim "one size-6 arc-clique class,
  stabilizer order 60" restated. A census bug in the stabilizer would have broken this match.
- **Edge, not Dye, is also the source of the five-triangle/synthematic-total structure at q=11**
  (§§30–31), and of the icosahedral-section reading (§19: the hexagons "are provided by sections of
  the 6 diagonals of a regular icosahedron … the Brianchon points being the sections of the 10
  joins of centroids of pairs of opposite faces"). The manuscript currently attributes the
  five-self-polar-triangle structure to Dye alone (see §2.1, item H).

### 1.2 The covering fact is absent from Edge and Van de Voorde — VERIFIED; BSW originals remain the condition

- **Edge**: VERIFIED. Full-file greps for covering-type language (`every point`, `all the points`,
  `cover`, `no point`, `miss`, `lies on a join`) return nothing relevant; §§29–32 read directly
  contain concurrency, syntheme/total structure, stabilizer, and partition bookkeeping ("account
  for all 66 e-points" is hexagon-vertex accounting, not secant coverage). Edge never states that
  the fifteen joins cover every off-conic point, nor that the points missed by all joins are the
  conic.
- **Van de Voorde**: VERIFIED for the exterior-set sections (§§1.1, 3 read directly); no
  covering/missed-points statement. The sub's full read agrees.
- **BSW Giessen 1991 and Combinatorica 1992**: UNRESOLVED — unread by every agent in this program;
  Springer paywall confirmed, no repository copy found (OpenAlex: closed). Every statement about
  their contents below is Van de Voorde's paraphrase. **The "covering fact is ours" claim is
  conditioned on these two papers and stays conditioned until the ILL lands.** The risk is real but
  bounded: BSW's object is defined by the joins' relation to the conic, not by what the joins
  cover, and Van de Voorde's summary of their results contains nothing covering-shaped.

### 1.3 BSW's object = Edge's hexagon renamed — VERIFIED, with a paper-attribution correction

VERIFIED via Van de Voorde (extraction, §1.1): *"An exterior set E of C is a set of points such
that every secant line of E is an external line of C"*, and her Theorem 1, quoted from [4] = BSW
Combinatorica 1992: for size (q+1)/2, if q ≡ 1 (mod 4) the only example is the exterior points of
an external line; if q ≡ 3 (mod 4) *"there exist other examples (at least for q = 7, 11, . . . ,
31)"*. At q=11 the size is 6 and at q=7 it is 4, matching Edge's hexagon and quadrangle and the
census's all-external ω values. This identification stands.

**Attribution correction (affects the strategy note, the omega-arc report, and the C146 wording):**
the exterior-set definition, Theorem 1, the conjecture, and both computer checks belong to the
**Combinatorica 1992** paper ([4] in Van de Voorde), not the Giessen 1991 paper ([3]). Per Van de
Voorde, the Giessen 1991 paper is the sets-without-tangents paper (the u_q values u₃=6, u₅=10,
u₇=12, the lower bound, the 2q trivial example). The strategy note §7.1 and the omega-arc report
§1 both hang the conjecture and the computer search on Giessen 1991 — INFERRED-turned-wrong;
strictly the conjecture is "open since 1992."

### 1.4 The range question — RESOLVED: no contradiction, and the census-vs-BSW pitch is dead

The two Van de Voorde statements are about **different claims**, and both are in her text exactly
as follows (extraction):

- §1.1, directly after Theorem 1: *"It is conjectured by the authors of the same paper (and checked
  by computer for q < 131), that only for q = 7, 11, . . . , 31, there exist other examples."*
- §3: *"they found by computer that for 11 < q ≤ 31, all exterior sets consisting of (q+1)/2
  exterior points contain a line with at least 3 points of this set."*

Read together: **existence** of non-linear (q+1)/2-exterior sets was machine-checked out to
q < 131 and holds only for q ≡ 3 (mod 4), 7 ≤ q ≤ 31; **within** 11 < q ≤ 31, where such sets do
exist, all of them contain three collinear points, so only q = 7 and q = 11 yield the arc-type
(no-3-collinear) object. There is no self-contradiction; the gem-mining handoff's "Van de Voorde's
paper contradicts itself" is REFUTED (the handoff needs that paragraph rewritten, and its gate is
now decided — see below). What remains UNRESOLVED is only *whose* computation the q < 131 check was
(BSW's own or a later extension VdV reports); the sentence attaches it to "the authors of the same
paper," i.e. BSW 1992, and the original is unread.

**Gating consequence, now settled**: a census exhaustive to q = 37 (or a Rust sweep to ~150)
contributes essentially nothing to the all-external existence question — the literature already
records a check to q < 131. The prior Fable note's removed claim ("verifies the BSW bound one prime
past their 31") was wrong twice over: wrong range, and wrong paper. What survives of the ω_arc
census as a contribution: (a) the **mixed internal/external** invariant, which no accessible source
studies (§1.7); (b) possibly the exact all-external *maxima* for q where (q+1)/2 is not attained —
BSW's reported check is existence-at-size-(q+1)/2, not a maximum computation — UNRESOLVED whether
the originals contain maxima; (c) the two extremal matches (q=7: 4, q=11: 6) as external validation
of the scripts.

### 1.5 Is the BSW conjecture genuinely open? — VERIFIED to the limit of secondary evidence

- OpenAlex live query (this audit): the Combinatorica 1992 paper has **9 citing works**: Van de
  Voorde (arXiv 2012 + the journal version), the Blokhuis memorial survey (Des. Codes Cryptogr.
  2022), "Maximal cliques in the Paley graph of square order" (1996), "Designs from Paley graphs
  and Peisert graphs" (2015), a Hermitian-ovoid paper (2006), a sharply-3-transitive-sets paper
  (1992), Yip's "A strengthening of McConnel's theorem on permutations over finite fields" (2024),
  and "Selected results in combinatorics and graph theory" (2024).
- Yip 2024 (arXiv:2407.21362, fetched): cites BSW 1992 in the bibliography without engaging the
  exterior-set conjecture — no verification range, no extension. VERIFIED (via targeted fetch of
  the HTML full text).
- The last 2024 citer is unopened — UNRESOLVED, low risk (title indicates a survey).
- The active adjacent thread (Héger–Nagy 2024/25 k-avoiding sets; Dover 2025 untouchable sets —
  extraction read this audit) cites only the Giessen 1991 paper; Dover's text contains no mention
  of Edge, of Combinatorica 1992, or of exterior sets (grep: zero hits).

Verdict: **open**, with computational support to q < 131, as far as any accessible source shows.
No claim of resolution found anywhere. (A resolution that cites neither BSW paper is conceivable
but was not found under any searched vocabulary.)

### 1.6 The hexad-absence verdict — all three named weak points now CLOSED

The candidate (C147): *a 6-subset of the 12 conic points of PG(2,11) is a hexad of S(5,6,12) iff no
three of its 15 chords are concurrent off it*; spectrum {60:264, 62:330, 63:220, 64:110}, 61 absent,
t=60 stratum = the two Steiner systems. The hexad report's ABSENT verdict had three named residuals;
this audit closed all three:

- **Lord 1988** — CLOSED (VERIFIED, full text obtained this audit from
  https://www.ias.ac.in/article/fulltext/pmsc/098/02-03/0153-0177 with a browser user-agent;
  extraction `lord1988.txt`). The paper works in PG(5,3) (Coxeter's configuration), PG(11,2)
  (Todd's), and the hemi-icosahedron/11-cell; grep counts: "conic" 0 hits, "concurren" 0 hits, the
  only PG(2,·) is the Fano plane PG(2,2). No PG(2,11), no chord-concurrency statement. The
  report's abstract-level inference was right.
- **Edge 1965a** ("Some implications of the geometry of the 21-point plane") — CLOSED (VERIFIED,
  fetched + extracted this audit). It is PG(2,4): hexads there are Segre's 168 ovals
  (hyperovals), S(3,6,22)/M₂₂ territory. His own text kills any overlap: *"No hexad h … has its
  points all on the same conic; a conic … consists"* of 5 points (line 69 of the extraction) — in
  PG(2,4) a hexad can never lie on a conic, so no on-conic subset question can arise there.
- **Edge 1955b** ("31-point geometry") — CLOSED by Edge 1956's own reference apparatus: §19 opens
  *"Some description has also been printed (5) of the figure for q = 5"*, and reference (5) is the
  1955 Math. Gazette 31-point-geometry paper. It is the q=5 figure in PG(2,5) — the degenerate
  case where the "hexagon" is the whole 6-point conic — and cannot contain a statement about
  6-subsets of a 12-point conic in PG(2,11). (INFERRED from Edge's citation of it, not a read of
  1955b itself; the inference is about subject matter, which Edge states.)

The rest of the hexad report re-verified where checkable: Edge's q=11 hexagons are external points
(§29, VERIFIED; and §19's *"their vertices are not then on a conic, neither will they be when we
encounter such hexagons again below with q = 11"* states the off-conic fact in Edge's own words);
the only on-conic Brianchon statement is §19 at q=5 (VERIFIED, quoted in §1.1); Edge never mentions
Mathieu/Steiner (grep: zero hits, VERIFIED). Halbeisen–Hungerbühler: VERIFIED — extraction
`twins.txt` contains the load-bearing sentence (the 15 lines *"yield, in general, 45 intersection
points different from the"* given points), and the venue is J. Geometry 115 (2024),
doi:10.1007/s00022-024-00731-8 (Springer record). Havlicek arXiv:1210.2055: VERIFIED at abstract
level (12-point model K in PG(5,3), blocks = hyperplane sections with six points of K,
Coxeter/Pellegrino lineage). The characterization-absence verdict therefore stands with **no
remaining named weak point**; what remains is the irreducible risk of any negative search, plus the
unpromoted scripts (§1.10).

### 1.7 ω_arc sweep claims

- **Meagher–Spiga is whole-group, independent-set machinery** — VERIFIED against the extraction:
  the derangement graph's vertices are "the elements of G", Theorem 1 bounds independent sets of
  the PGL(2,q) derangement graph. Not the involution class, not cliques.
- **Tranchida uses the involution↔off-conic-point correspondence for a different question** —
  VERIFIED at abstract level (bijection between involutions and off-conic points; rank-3 hypertope
  classification; nothing clique- or elliptic-extremal-shaped in the abstract). Details beyond the
  abstract: INFERRED from the report.
- **The sequence 3,4,4,6,6,6,6,8,10,10,10 is not in OEIS** — VERIFIED (re-run this audit:
  "No results").
- **Nothing beats the pencil bound (q+3)/2** — INFERRED (a negative over the report's search trail;
  cannot be verified, only falsified).
- **REFUTED/unsupported item in the omega-arc report**: its §1 states BSW 1991 defines an exterior
  set by joins meeting the conic "in at most one point (external or tangent — a weaker condition)."
  The only accessible definition (Van de Voorde §1.1, quoted in §1.3) requires strictly external
  joins. The report never read BSW 1991, so its "weaker condition" gloss is unsourced and
  contradicts the accessible secondary source. (Immaterial to the verdicts — in the
  sets-without-tangents context the tangent-covering count forces the strict version anyway — but
  it should not be repeated.)
- The omega-arc report also still carries the **"M. De Boeck" misattribution** of arXiv:1201.0484
  (its §1 bullet and its Sources list) and the **Giessen-vs-Combinatorica misattribution** (§1.3
  above). Both are wrong in that file on disk; the exterior-sets report has the correct author.

### 1.8 Deep-holes sweep claims

- **ZWK Thm I.7 is a three-family disjoint union, not a variety equality** — VERIFIED verbatim from
  the extraction: *"The total number of deep hole classes of PRS(q−3) is q(q+1)²/2. These are given
  by the q deep hole classes of Theorem I.4, q² classes of Theorem I.5, and (q+1)q(q−1)/2 classes
  of Theorem I.6"*; and the geometric gloss for the first two families is points *"not on the
  curve, but … in the union of the tangent lines to the curve."*
- **DMP Thm 6.3(iii) is the dictionary** — VERIFIED verbatim: *"For c₀ = 0, the arc A is complete
  … we have no weight 3 cosets. For c₀ ≠ 0 … (q−1)c₀ cosets of weight 3"*, with the proof line
  *"The points off the incomplete arc A, that do not lie on any bisecant of A, give the syndromes
  of the (q−1)c₀ cosets of weight 3."*
- **DMP's sporadic table has no n=6, q=11 row** — VERIFIED verbatim from (6.1): rows are n=6 at
  q=7, 8, 9 and n=7 at q=11, introduced as "sporadic complete n-arcs" (so c₀=0 throughout the
  table); the Clebsch case is outside it.
- **Q5 (Reed–Muller deep holes) is NOT SEARCHED** — confirmed as stated in the report; it remains
  the weakest edge of the "first"-flavored claim. **Q4 (twisted cubic, k=4) is lightly searched** —
  confirmed; no prior statement of the question found, marked as absence-of-evidence.
- Verdict as the report states it: the "first identification" pattern survives audit — *audited,
  not found, not exhaustively cleared* — conditioned on Q5, on the light Q4 pass, and on the BSW
  originals (§1.2).

### 1.9 The two manuscripts' shape — VERIFIED, with three new mechanical findings

- `clebsch_hexagon_code.tex` cites **neither Edge nor BSW**: VERIFIED by grep — the only
  occurrences are inside the planted TODO comment (lines 175–194). Moreover the paper **never uses
  the words "external"/"exterior" outside that comment at all** (grep: lines 178 and 184 only) —
  the classical vocabulary that connects the arc to the exterior-set literature is absent from the
  mathematics, not just the bibliography. C146 is a vocabulary job as well as a citation job.
- The §2 priority footnote (lines 201–213) argues the priority case against **Dye 1991** only.
  Its content (Dye does not state the zero-bisecant identification) is unrefuted and still worth
  keeping; its *positioning* as the paper's priority defense is against the wrong nearest prior
  art. Nearest prior art is Edge 1956, by 35 years.
- The TODO comment itself contains a now-refuted claim (lines 192–193): "…the open BSW conjecture,
  which it supports past their computational range." Dead per §1.4. Must not survive into prose.
- `arcs_complete_outside_conic.tex` cites BSW 1992 and draws the correct distinction: VERIFIED,
  lines 136–144 ("This is a different condition from prescribed-hole completeness…"), bibliography
  lines 1287–1291. It does not cite Edge (grep: zero hits) — same gap, smaller because the
  distinction is already drawn.
- **New finding — stale cross-references between the papers**: the clebsch manuscript cites the
  companion as `[Prop.~4.6]` (lines 145, 286) and `[Prop.~4.6(iv)]` (line 734), but in the arcs
  manuscript as it stands the q=11 proposition (`prop:q11-code`, lines 984–1052) numbers as
  **Proposition 8.7** (section 8, seventh theorem-environment). The arcs paper was evidently
  restructured after those citations were written.
- **New finding — a probable citation error in the arcs paper**: line 441 cites the farthest-coset
  leader formula to "Davydov–Marcugini–Pambianco [Theorem 4.6]". In DMP arXiv v2 (extraction read
  this audit), **Theorem 4.6 is the symmetry-of-weight-distributions theorem; the
  binom(n,d−1)-leaders farthest-coset formula is Theorem 7.7** (*"there are exactly [binom(n,d−1)]
  codewords at distance R from every farthest-off vector (deep hole)"*). The clebsch paper cites
  the same formula correctly as Thm 7.7 with an explicit arXiv-v2-numbering disclosure (lines
  251–259 and 851–857); the arcs paper cites the published AMC version (doi:10.3934/amc.2021042)
  with no numbering disclosure. Unless the published version renumbered 7.7 → 4.6 (UNRESOLVED,
  paywalled; the known chronology makes silent renumbering *possible* but this exact coincidence
  unlikely), arcs line 441 points at the wrong theorem. Foreign lane — flagged here, not fixed.

### 1.10 The computed census — corroboration map, and what would falsify it

The trust boundary in the handoff says the scripts "may no longer exist." **They exist**, in the
session scratchpad
(`/tmp/claude-1000/-home-tavis-src-othello-rust/9b212ae1-fab7-4154-9772-0edac1ff558b/scratchpad/`),
and their SHA-256 hashes match the strategy note's recorded prefixes exactly
(`gem_sweep.py` = `b9886e3ecd305108…`, `mathieu_poles.py` = `7a86488679420fa5…`; verified this
audit). **`/tmp` is tmpfs on this box** — they vanish on reboot. Promoting them to the repo (C147)
is the single most time-sensitive mechanical task in this program.

Census numbers remain unreplicated as a whole; the external corroboration points are now four, one
of them new:

| corroboration point                                   | status                                                       |
|-------------------------------------------------------|--------------------------------------------------------------|
| q=19 minimum-uncovered class, \|U\| = 140              | matches the repo's committed `check_q19_nonexample.py`       |
| all-external extremal sizes ω=4 (q=7), ω=6 (q=11)      | match BSW's published examples (via Van de Voorde, §1.3)     |
| q=11: one class, stabilizer order 60                   | **new**: implies 22 hexagons per conic = 1320/60, which is Edge §§29–31's count verbatim |
| q=11: unique 6-arc class with A₅                       | consistent with SVM 1995 Prop. 12 (already cited in the paper) |

The hexad spectrum's internal arithmetic also checks: 264+330+220+110 = 924 = C(12,6); 264 = 2×132;
the t ≥ 60 floor is forced (each of the 6 points contributes C(5,3) concurrent triples at itself,
and a chord carries no third conic point, so accidental concurrences are off-conic). The Steiner
side has a committed independent witness (`check_mathieu_hexads.py` verifies the 132-block system).

What would falsify the census, in decreasing order of likelihood: (i) a transcription error between
script output and the strategy note's table (guarded only by the surviving scripts — promote and
re-run); (ii) a bug in the arc-clique DFS's exhaustiveness (the two-representative-types argument:
Stab(C) transitive on internals and on externals — reasoned, not machine-checked); (iii) an
arc-clique above the pencil bound (q+3)/2 at any q (the bound is reasoned, not machine-checked; any
violation means a bug on one side or the other); (iv) a healthy arc at a prime 13–37 found by an
independent implementation. The BSW-reported existence of non-arc (q+1)/2-exterior sets at
q = 19–31 does **not** conflict with ω_arc(19)=6 etc. — those sets contain collinear triples, and
E_q's unrestricted clique number is ≥ q+1 regardless.

### 1.11 Errors found in the program's own documents (all still on disk unless noted)

| doc                                        | error                                                                                    | severity |
|--------------------------------------------|------------------------------------------------------------------------------------------|----------|
| `2026-07-14-gem-mining-next-steps-fable.md` §7.1 | attributes exterior-set definition, conjecture, and computer search to Giessen 1991; they are Combinatorica 1992 per the only accessible source (§1.3) | medium — feeds C146 wording |
| same, §7.2                                 | splices the §19 (q=5, on-conic) "with Clebsch … Brianchon" quote into the p=11 description; the p=11 quote is the intro's "distribution of the points external…" sentence | low — the hexad report untangles it |
| `handoffs/2026-07-14-gem-mining.md` (lines 96–99) | "Van de Voorde's paper contradicts itself on BSW's computational range" — REFUTED; two different claims, both coherent (§1.4); the gate it declares is now decided | medium — handoff needs its gate paragraph rewritten |
| same (lines 101–104)                       | "A first attempt at this search failed without producing findings" — stale; the clean re-run exists (`2026-07-14-gem-lit-deep-holes.md`) with a survives-verdict | low |
| `2026-07-14-gem-lit-omega-arc.md`          | "M. De Boeck" as author of arXiv:1201.0484 (twice); Giessen-1991 misattribution; unsourced "weaker condition" definition of BSW exterior sets (§1.7) | medium — do not cite from this file without cross-checking |
| `2026-07-14-gem-lit-exterior-sets.md`      | journal version given as "Electron. J. Combin. 17(1) (2010), #R174" — that EJC item is Van de Voorde's *other* paper ("On the linearity of higher-dimensional blocking sets"); the journal version of the sets-without-tangents paper is **Discrete Mathematics 311(20) (2011), 2253–2258**, doi:10.1016/j.disc.2011.07.010. The arXiv page's own journal-ref field carries the wrong value; the report propagated it | **high for C146** — this exact citation would have shipped wrong |
| same                                       | Edge §30.1 vertex list garbled ("(0,3,1),(1,0,−3)" duplicated/truncated; correct list in §1.1 above) | low |
| `papers/clebsch-hexagon-code/clebsch_hexagon_code.tex` TODO (192–193) | "supports [the BSW conjecture] past their computational range" — dead (§1.4) | high — blocks C146 as drafted |
| `handoffs/2026-07-13-clebsch-paper.md`     | calls the gap theorem "§4 Thm 4.2"; in the current tex it is Theorem 4.3 (4.1 rigidity, 4.2 corollary, 4.3 gap) | low |

---

## 2. Paper-impact map

Classification: INFRASTRUCTURE (fact used, never claimed) / METHOD (how something is computed or
proved) / FRAMING (positioning, priority, related work) / NOVELTY CLAIM (asserted as ours). Line
numbers are against the files as of this audit.

### 2.1 `papers/clebsch-hexagon-code/clebsch_hexagon_code.tex`

| # | location (§, lines)                              | what                                                                     | class          | action |
|---|--------------------------------------------------|--------------------------------------------------------------------------|----------------|--------|
| A | abstract, 38–61                                  | headline = rigidity + gap + chirality + why-11; no "first" language; Sadeh conceded | NOVELTY CLAIM  | no change — the abstract already has the post-demotion shape |
| B | §1, 66–95                                        | deep-hole history: DMP dictionary, Guruswami–Vardy, Cheng–Murray, ZWK    | INFRASTRUCTURE | no change — all four verified accurate against the sweep (§1.8) |
| C | §1, 97–106                                       | "The arc realizing this code is the Clebsch hexagon … [SVM 1995] and … Dye" | FRAMING        | rewrite — the finite-plane hexagon and its name are Edge 1956's (§§29–32); add Edge here and keep SVM/Dye |
| D | §1, 133–153 ("What is new and what is not")      | credit ledger: SVM/Dye/Hirschfeld–Sadeh/companion                        | FRAMING        | rewrite — add the Clebsch 1871 → Edge 1956 → BSW 1991/1992 lineage; the ledger is otherwise correct |
| E | §2, 175–194 (TODO comment)                       | planted C146 instructions; embeds the dead "supports past their computational range" clause at 192–193 | FRAMING        | execute C146 with the §1.4 resolution: cite Edge + BSW, **delete** the past-their-range claim; frame the census as recomputation inside a checked range plus a new mixed-type invariant |
| F | §2, 195–222, footnote 201–213                    | prior-art paragraph; priority footnote argued against Dye 1991 only     | FRAMING        | rewrite — re-base on Edge 1956 as nearest prior art (his §§29–32 have the object, the name, the 22/two-systems structure, the order-60 stabilizer); keep the Dye-gate footnote content as a secondary note (its evidence is unrefuted); add BSW with the "complete exterior set of size (q+1)/2" identification and the open conjecture (checked to q<131 per Van de Voorde), conditioned wording until the ILL |
| G | §2 generally (grep: zero hits outside the TODO)  | "external point / external line / exterior set" vocabulary absent from the entire paper | FRAMING        | add — one sentence in §2 stating the arc points are external points of 𝒞 and all fifteen secants are external lines, i.e. the arc is a complete exterior set in the BSW sense; without this the citations have nothing to attach to |
| H | §3.1, 337–344                                    | "Dye's synthetic theory … exhibits five triangles … self-polar"          | FRAMING        | amend attribution — Edge 1956 §§30.2–31 exhibits the five triangles, the synthematic total, and the order-60 stabilizer at q=11; Dye is the general-field theory. Cite both |
| I | §3, 246–262                                      | DMP Def 6.1/Thm 6.3/Thm 7.7 usage with v2-numbering disclosure           | METHOD         | no change — verified sound against the extraction (§1.8, §1.9); the AMC-numbering residual stands as recorded in the handoff |
| J | §3, 264–282 (Prop 3.1) and 284–292               | deep-holes-are-the-conic, self-contained proof + companion cite          | NOVELTY CLAIM (demoted to setup) | no change to content; **fix the stale companion reference** "[Prop. 4.6]" at lines 145 and 286 (and 734) once the arcs numbering stabilizes — currently Proposition 8.7 there |
| K | §3, 294–308 (Cor 3.2)                            | complete deep-hole set = full F₁₁-point set of the conic; no "first" wording | NOVELTY CLAIM (setup) | no change — survives the deep-holes audit as worded; keep it below "first" strength (Q5/RM unsearched, BSW originals unread) |
| L | §4, 356–372 (census framing)                     | Sadeh/Hirschfeld–Sadeh concession on census + \|U\| data                 | FRAMING        | no change — already correct; C131 (thesis arrival) still the confirming step |
| M | §4, 374–436 (Thm 4.1 rigidity) + 438–441 (Cor 4.2) | the TFAE rigidity; A₅ recovered from the coding condition               | NOVELTY CLAIM  | keep — see §3.1 below for conditions; no sweep source touches conic-containment of deep-hole loci |
| N | §4, 447–474 (Thm 4.3 gap)                        | 252-perturbation spectrum, min symmetric difference 18                   | NOVELTY CLAIM  | keep — sweep-untouched; the missing checker (handoff's known gap) is the open item, not the literature |
| O | §5, 476–516 (Prop 5.1 chirality)                 | two complementary A₅-orbits of leaders; no automorphism swaps them       | NOVELTY CLAIM  | keep, plus one added sentence: Edge §§29/32's two hexagon-systems swapped exactly by the non-PSL operations is the classical q=11 form of this chirality motif — cite it to pre-empt the referee rather than let them find it |
| P | §6, 518–656 (Lemma 6.1, Thm 6.2, q=19)           | counting bound q≤14; A₅-rationality; q=19 failure with \|U\|=140         | NOVELTY CLAIM  | no change — sweep-untouched and internally careful; optional: a remark connecting the all-external case to the BSW conjecture as context |
| Q | §7, 658–705 (Klein reduction)                    | non-causal discussion; syzygy asserted at 684–685                        | FRAMING        | no change from the sweep; C128 (kernel-check the syzygy) remains open |
| R | §8, 710–735 (Schreier witness)                   | icosahedron graph on the conic; companion cite at 734                    | INFRASTRUCTURE | fix stale "[Prop. 4.6(iv)]" reference (see J) |
| S | §8, 737–749 (higher-k open question)             | k=4 question posed open, no candidate                                    | FRAMING        | no change — deep-holes Q4 found no prior statement of it; the pose-not-conjecture stance is right |
| T | §8, 779–798 (S(5,6,12) transversality)           | the two icosahedral hexads are not Mathieu hexads                        | INFRASTRUCTURE | no change; if C147 becomes a claimable note, cross-cite later |
| U | bibliography, 822–922                            | no Edge, no BSW, no Clebsch 1871, no Van de Voorde                       | FRAMING        | add: Edge, Canad. J. Math. 8 (1956) 362–382; BSW, Mitt. Math. Sem. Giessen 201 (1991) 39–44; BSW, Combinatorica 12 (1992) 143–147; Clebsch, Math. Ann. 4 (1871) 284–345; Van de Voorde, **Discrete Math. 311(20) (2011) 2253–2258** (not the EJC reference — §1.11) |

### 2.2 `papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex` (read-only, `relconic` lane — suggested actions only)

| # | location (§, lines)              | what                                                                      | class          | suggested action for `relconic` |
|---|----------------------------------|----------------------------------------------------------------------------|----------------|---------------------------------|
| A | §1, 136–144                      | exterior-set paragraph, cites BSW 1992, draws the right distinction; notes the q=11 witness has all secants exterior | FRAMING        | add Edge 1956 alongside BSW (origin of the object and the name, 35 years earlier); otherwise sound |
| B | §4, 441                          | leader formula cited as "DMP Theorem 4.6"                                 | METHOD         | verify against the published AMC version or switch to the arXiv-v2 numbering with disclosure; in v2 the formula is **Thm 7.7**, and Thm 4.6 is the symmetry theorem (§1.9) — as it stands this is probably a wrong-number cite |
| C | §8, 984–1052 (Prop 8.7)          | the q=11 code: non-GRS, deep-hole locus = conic, coset spectra, extension complex | NOVELTY CLAIM (posture: checked synthesis) | no change — the posture sentence at 1057–1059 ("not located in the bounded search … not a priority claim") is exactly right and is now supported by the deep-holes sweep |
| D | §8, 1054–1059                    | prior-art sentence: "classical Clebsch hexagon … [Dye1991, StormeVanMaldeghem1995]" | FRAMING        | add Edge 1956 to the prior-art list |
| E | §8, 961–982 (q=11 row, IC(A)=0)  | "every secant of the witness is exterior to the conic"                     | INFRASTRUCTURE | this is the paper's one sentence of exterior-set vocabulary; a pointer from here to the §1 BSW paragraph would tighten it — optional |
| F | numbering drift                  | the clebsch paper cites this paper's q=11 result as Prop 4.6              | —              | when either paper is next touched, re-sync the cross-references (currently Prop 8.7 here) |

---

## 3. The abandon / downgrade list

**ABANDON (three items, all framing-level — no theorem dies):**

1. **"Our census supports the BSW conjecture past their computational range."** Dead. Van de
   Voorde reports a computer check to q < 131 (§1.4). Lives in the tex TODO (lines 192–193) and,
   in weakened forms, in the strategy note §10.2(a) and the queue row C147's neighborhood. Any
   restatement — including a future Rust sweep to q ≈ 150 pitched as conjecture support — is
   unpublishable without first obtaining BSW 1992 and refuting Van de Voorde's report of it.
2. **Dye 1991 as the manuscript's nearest prior art / priority anchor.** The priority footnote's
   *content* survives (the Dye-gate evidence is unrefuted), but the positioning is wrong: Edge 1956
   has the object, the name, the two-systems structure, and the stabilizer, 35 years earlier.
   Re-base (C146, items C–F of §2.1).
3. **The fill-signature detector** (already retired by C132; re-confirmed): wrong signature, no
   exhaustion, no null, no upgrade path. Nothing in this audit rehabilitates it.

**DOWNGRADE (two):**

4. **ω_arc-growth-as-BSW-data program** (strategy note §10.2): from "piggybacks on an open 1991
   conjecture; even negative rows are publishable data in that conversation" to: the all-external
   half is a recomputation strictly inside a range the literature reports as already checked; the
   publishable residue is (a) the mixed-type invariant (genuinely absent from the literature —
   exterior-sets (d), omega-arc verdicts, both consistent with my own reads), (b) exact all-external
   maxima *if* the BSW originals turn out not to contain them (UNRESOLVED), and (c) extremal-witness
   stabilizers at q = 23–37, which nobody has looked at. That is a modest data note, not a
   conjecture-adjacent contribution. Rank it below the hexad/octad and k=4 programs (§4).
5. **The chirality proposition's surroundings** (not the proposition): the ℤ/2 on deep-hole leaders
   stands as stated (Prop 5.1; sweep-untouched, exercise-grade group theory as already conceded in
   the handoff). But the *motif* — a two-system chirality at q=11 swapped exactly by the non-PSL
   half — is classical: Edge §§29/32 states it for the 22 hexagons. The paper must cite this as
   precedent for the motif while claiming only the coding-theoretic instance. One sentence; without
   it a referee who knows Edge reads the section as unaware of its own ancestry.

**SURVIVES (each with its condition, and what settles it):**

6. **Rigidity theorem (Thm 4.1 + Cor 4.2)** — SURVIVES. No sweep source states, or could state, a
   conic-containment condition on deep-hole loci; the exterior-set literature never looks at what
   the joins cover (§1.2), and the deep-hole literature never ties an uncovered locus to a
   positive-dimensional variety (§1.8). Conditions: (i) BSW 1991/1992 ILL — the Combinatorica
   paper's title is "Characterization…", and if it proves uniqueness of the q=11 exterior 6-set,
   that overlaps the (iv)⇔(v) fragment *restricted to exterior arcs* (the TFAE over all six-arcs,
   and the conic-containment hypothesis, remain untouched — but the wording of "recovers A₅" should
   then acknowledge the exterior-set uniqueness as prior); (ii) C131 (Sadeh thesis arrival) for the
   census concession, already worded correctly.
7. **All-arcs rigidity upgrade (census §4–5 of the strategy note: unique at any size, n ≥ 7 empty)**
   — SURVIVES as a claim, but it is the program's least-corroborated computed input: it rests on
   `gem_sweep.py` alone (ω_arc(E₁₁) = 6). Condition: promote and independently re-verify the script
   before the upgrade enters any manuscript. The pencil-bound kill of n ≥ 8 is reasoned and
   checkable by hand; n = 7 is the census-only step.
8. **Gap theorem (Thm 4.3)** — SURVIVES. Not covered by any of the four searches (checked: no
   sweep vocabulary touches perturbation of deep-hole loci), and nothing found adjacent to it. Its
   open item is reproducibility (no checker ships for the 252-perturbation spectrum), not
   literature.
9. **"Why q=11" (Lemma 6.1 + Thm 6.2)** — SURVIVES unchanged. The manuscript's own division of
   labor (counting caps the range, rationality discriminates, recovery-of-A₅ not used circularly)
   is careful and was not contradicted anywhere. The census's refutation of the ω/n_min crossing
   story does not touch the paper, which never claimed a structural cause.
10. **Cor 3.2 (deep holes = full point set of a named variety)** — SURVIVES in its current, already
    demoted wording (no "first" in the tex; verified by grep). The "first"-flavored strength, if
    ever re-asserted anywhere, is conditioned on: Q5/Reed–Muller NOT SEARCHED; Q4 lightly searched;
    BSW originals unread. Recommended posture: exactly what both papers now do (state the
    identification, decline priority language).
11. **Klein-reduction discussion (§7)** — SURVIVES as a discussion section; the sweep did not touch
    it and C127's verdict (form-level facts unfound; Elkies-genre hedge) stands. C128 (kernel-check
    the syzygy) remains open and the section asserts the syzygy as fact meanwhile.
12. **Deep-holes = conic identification (Prop 3.1 here; arcs Prop 8.7(i))** — SURVIVES. The arcs
    paper's posture sentence (lines 1057–1059) needs no strengthening or weakening; the sweep now
    supplies positive support (DMP's own table stops short of the case; ZWK's classification is
    family-shaped, not variety-shaped).
13. **The underlying six-arc census and raw |U| histogram** — already conceded to Hirschfeld–Sadeh
    outright (tex lines 356–372); nothing in the sweep disturbs the concession in either direction.

### 3.1 Residual risk register (what is still capable of forcing a retraction later)

| risk                                                                | blast radius                                     | settles it |
|---------------------------------------------------------------------|--------------------------------------------------|------------|
| BSW 1992 contains a covering/missed-points statement                | Prop 3.1/Cor 3.2 novelty posture; C146 wording   | ILL (both BSW papers) |
| BSW 1992 proves q=11 exterior-6-set uniqueness                      | "recovers A₅" wording in Thm 4.1's frame          | same ILL |
| Sadeh thesis states more than extension counts                      | already pre-conceded; low                        | C131 |
| Reed–Muller deep-hole literature holds a variety-equality instance  | Cor 3.2-adjacent rhetoric anywhere               | a dedicated Q5 search |
| `gem_sweep.py`/`mathieu_poles.py` bug or transcription error        | all-arcs upgrade; healthy census; hexad spectrum | promotion to repo + independent reimplementation (C147) |
| published-AMC DMP numbering differs from arXiv v2                   | clebsch is safe (disclosed); arcs line 441 is not | obtain AMC 17(5) |

---

## 4. The gem list

Status: DEAD / BLOCKED / OPEN / IN HAND. "Worth compute" is this audit's ranked judgment.

1. **Hexad chord-concurrency characterization (C147).** *6-subset of the PG(2,11) conic is an
   S(5,6,12) hexad iff no three chords concur off it.* Status: **IN HAND** — computed with a
   spectrum gap; literature verdict ABSENT, and the three named weak points of that verdict (Lord,
   Edge 1965a, Edge 1955b) are now closed at full-text level (§1.6). Needs: script promotion +
   independent recompute (the scratchpad is tmpfs), then write-up; Lean `decide` optional. This is
   one mechanical step from the program's second claimable result. **Worth compute: rank 1.**
2. **k=4 / twisted-cubic healthy search.** Status: **OPEN**. The one direction where a hit is a new
   kind of object; deep-holes Q4 found the machinery (BDMP 1909.00207) and no statement of the
   question. Needs first: re-derive DMP's R=4 coset dictionary (the strategy note's own flag), then
   a Rust DFS at q=11, 13. A miss is exhaustive-per-cell and closes the clebsch paper's one open
   forward question. Pegs `cubic` when opened. **Worth compute: rank 2.**
3. **Octad analogue at q=23.** Status: **OPEN**, untested. Same invariant on C(24,8) subsets of the
   conic vs the 759 octads; null t ≥ 8·C(7,3) = 280. The group situation genuinely differs
   (PSL₂(23) is maximal in M₂₄ — standard, not re-verified here), so hit and structured miss are
   both informative. Runs only after C147's scripts are durable. **Worth compute: rank 3.**
4. **Healthy-census hardening (prime powers q = 9, 25, 27, 49; then q ≤ 100).** Status: **OPEN**;
   the prime census q ≤ 37 is IN HAND but unreplicated. q=9 is the one that matters (the SVM
   complete-hexagon case; the paper's §6 already excludes it by other means). Referee-grade support
   for the paper, not a gem hunt. **Worth compute: rank 4.**
5. **The U-atlas, genus-0 restriction dropped (elliptic targets admitted).** Status: **OPEN**. The
   deep-holes sweep found no variety-equality instance of any kind in the literature, so *any*
   exact fill found by an atlas is new; dropping C132's genus-0 fiat is free and admits
   Hasse-window sanity nulls. The most generative proposal on the board and the least targeted.
   **Worth compute: rank 5, first cell (q ≤ 11, all n) only.**
6. **Mixed-type ω_arc census + extremal-witness stabilizers at q = 23–37.** Status: **OPEN**;
   downgraded (§3 item 4). The mixed-type invariant is real new territory — the literature is keyed
   to external points and structurally cannot see the all-internal witnesses (q = 3, 5, 19) — but
   it has no attached conjecture, no machinery, and no OEIS presence; it is a data note until a
   structural fact shows up. The witness stabilizers are an afternoon and could upgrade it.
   **Worth compute: rank 6 (the stabilizers first; the Rust sweep only if they show structure).**
7. **The q=5 frame sibling ([4,1,4]₅, deep holes = conic, S₄).** Status: **IN HAND** (unreplicated).
   Two uses: a free paragraph for the paper's family story, and the S₄ sign-character negative
   control for the chirality mechanism. No further compute beyond the promoted census. **Worth
   compute: nearly free, do with C147.**
8. **ω_arc / BSW all-external strengthening as a conjecture contribution.** Status: **DEAD in its
   pitched form** (§1.4, §3 item 1). Alive only as the exact-maxima question (UNRESOLVED whether
   BSW's originals computed maxima below (q+1)/2) — park until the ILL answers that for free.
9. **Schreier column over the Dickson census.** Status: **OPEN**, unstarted; machinery in-repo.
   Sound shape (census × cross-category invariant × declared null) but no external anchor and no
   candidate beyond the known icosahedron row. **Worth compute: rank 7.**
10. **E_q involution / EKR lens.** Status: **BLOCKED** as a compute item — it is a theory question.
    The sweep confirms the machinery exists (Meagher–Spiga spectra; the correspondence is
    independently current in Tranchida 2024) and that the involution-class elliptic-adjacency
    clique question is unasked. Right move: pose it to that community (or leave it in the paper's
    further-questions section), not solver time. **Worth compute: none directly.**
11. **Transverse-loci miner (C84, `cap` lane).** Status: **OPEN, foreign lane.** The strategy
    note's assessment (passes the census/invariant/null rules; POC must be rebuilt as a repo file)
    is consistent with everything found here; nothing in this sweep changes its standing. Noted for
    completeness only — no action from this lane.
12. **Fill-signature detector.** Status: **DEAD** (C132; reconfirmed §3 item 3). Keep the table as
    the record of a closed spike, as already decided.

Plainly, against the program's own rankings: the strategy note's #3 ("ω_arc growth + BSW
strengthening … even the negative rows are publishable") was overvalued — the q < 131 report
removes most of its market. Its #1 (hexads) and #2 (k=4) are confirmed as ranked, with the octads
slotting between them and the frame sibling riding along free.

---

## 5. Primary-source ledger for this audit

Scratchpad (tmpfs — copy anything needed before reboot):
`/tmp/claude-1000/-home-tavis-src-othello-rust/9b212ae1-fab7-4154-9772-0edac1ff558b/scratchpad/`
holds `edge1956a.{pdf,txt}`, `edge1965a.{pdf,txt}` (fetched this audit), `lord1988.{pdf,txt}`
(fetched this audit), `vandevoorde{1201.0484.pdf,.txt}`, `dmp-2101.txt`, `zwk1901.05445.txt`,
`untouchable2505.txt`, `innamorati.txt`, `meagher-spiga-0910.3193.txt`, `twins.txt`,
`openalex_bsw92.json`, and the census scripts `gem_sweep.py`, `mathieu_poles.py` (hashes verified,
§1.10).

External: Edge 1956 PDF (Edinburgh archive, §1.1); Lord 1988
(https://www.ias.ac.in/article/fulltext/pmsc/098/02-03/0153-0177); Van de Voorde
arXiv:1201.0484, journal version Discrete Math. 311(20) (2011) 2253–2258 (doi:10.1016/j.disc.2011.07.010;
the arXiv journal-ref field is wrong — §1.11); Halbeisen–Hungerbühler, J. Geometry 115 (2024),
doi:10.1007/s00022-024-00731-8; Havlicek arXiv:1210.2055; Tranchida arXiv:2411.10299; Yip
arXiv:2407.21362; OpenAlex work record + live citing-works query for doi:10.1007/BF01204717; OEIS
search API. Unobtained: BSW Giessen 201 (1991) 39–44 and Combinatorica 12 (1992) 143–147 (ILL),
Sadeh thesis (C131), Dye 1991 (optional ILL), DMP in AMC 17(5) (paywalled).
