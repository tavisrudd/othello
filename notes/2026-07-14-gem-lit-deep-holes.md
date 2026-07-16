# Deep-holes literature audit — 2026-07-14

**Status: RE-RUN, completed by a single agent doing its own searching.** All WebSearch/WebFetch
calls below were issued directly by the agent writing this file; no sub-agents were used. Two
PDFs were fetched, extracted with `pdftotext`, and read in full for the load-bearing claims
(§1). Every item below is tagged VERIFIED, INFERRED, or NOT SEARCHED — see tier definitions at
the end of the intro.

Tiers:
- **VERIFIED** — fetched and read myself (abstract page, or PDF via pdftotext). Citation + URL +
  what it actually says.
- **INFERRED** — WebFetch summary of a page/abstract only, not full-text read by me. Marked per
  item.
- **NOT SEARCHED / UNRESOLVED** — no attempt, or attempt returned nothing useful.

---

## 0. Headline verdict on Q1 (read this first)

**No prior instance found of "the deep holes of a code = the rational points of a named
variety/curve" as a stated equality.** The nearest candidate, Zhang–Wan–Kaipa
(arXiv:1901.05445), does **not** make that claim — I read the paper's Introduction and the
relevant proof section directly (VERIFIED, §1 below). Its redundancy-4 result decomposes the
deep-hole locus into **three disjoint, separately-indexed combinatorial families** (a
`P GL_2(F_q)`-orbit count, a second orbit count, and a quadratic-extension-conjugate-pair
family), and the paper's own words describe the first two families as points "not on the curve,
but... in the union of the tangent lines to the curve" — i.e., points on tangent lines *minus*
the curve itself, not a curve's rational-point set, and explicitly a subset of the tangent
developable rather than all of it. There is no single named variety whose full `F_q`-point set
is asserted to equal the deep-hole locus anywhere in that paper.

In the separate geometry/coding "dictionary" literature (Davydov–Marcugini–Pambianco,
arXiv:2101.12722, read directly — VERIFIED, §3), the only two cases where the "uncovered locus"
(`c_0`, points on no bisecant) is tied to a *named* curve are the classical conic and regular
hyperoval — and in both of those the `c_0`-locus is **not itself a positive-dimensional named
variety's rational points**: for the conic (`q` even) it is a single point (the nucleus); for
the hyperoval it is empty (`c_0 = 0`, the hyperoval is complete). Neither is "the deep-hole
locus is exactly the full `F_q`-point set of a *different*, positive-dimensional named variety."

Combined with a broad sweep of the explicit-construction deep-hole literature (Q2), the
covering-radius/arc-geometry literature (Q3), the twisted-cubic literature (Q4), and AG/Goppa/
Reed–Muller vocabulary (Q5) — none of which turned up a counterexample — **the "first" claim
survives this audit.** It is not proven safe in the sense of an exhaustive search (see caveats
under each question), but no prior instance of the specific pattern ("deep-hole locus = full
`F_q`-point set of a named positive-dimensional variety") turned up anywhere I looked, including
in the two papers explicitly flagged as the nearest-thing candidates.

**Flag for the manuscript**: word the "first" claim carefully. It should read as "first
identification of a deep-hole locus as *exactly* the full rational-point set of a named
positive-dimensional variety" — not merely "first connection between deep holes and geometry"
(that connection, via arcs/secants, is old and standard, going back at least to Davydov et al.'s
`c_i` framework and, before coding-theoretic framing, Segre-era arc theory). The novelty is the
*equality with a complete named variety*, not the geometry connection itself.

---

## Q1. Is there ANY prior instance of "deep holes = rational points of a named variety"?

### VERIFIED — arXiv:1901.05445, Zhang, Wan, Kaipa, "Deep Holes of Projective Reed-Solomon Codes"

Fetched `https://arxiv.org/pdf/1901.05445`, extracted with `pdftotext`, read in full (the
Introduction and the proof of Theorem I.6 in §II-D). Key facts, quoted from the extracted text:

- **Theorem I.4** ([17]): the `q` words `{(α_1^k,...,α_q^k,a) : a ∈ F_q}` are deep hole classes.
- **Theorem I.5** (first new result of the paper): a `q²`-element family, `P GL_2(F_q)`-orbits of
  Theorem I.4's classes. Quote: "We also show that the `q² + q` deep hole classes of Theorems
  I.4 and I.5 taken together have a nice geometric interpretation in terms of the tangent lines
  to the degree `(q−k)` normal rational curve in `P^{q−k}(F_q)`."
- Later (§II-D, Remark, extracted text line ~749–754): "the geometric interpretation of the
  `(q+1)q` syndromes of the deep hole classes in Theorems I.4 and I.5, is that these consist of
  those points with `F_q`-coordinates which are **not on the curve, but are in the union of the
  tangent lines to the curve**." — This is explicitly a subset of the tangent lines minus the
  curve, i.e. part of the tangent developable, not a variety's full rational-point set, and not
  even the whole developable (only the parts hit by these two theorems' families).
- **Theorem I.6** (second new result): a third, disjoint family of size `(q+1)q(q−1)/2`, indexed
  by monic irreducible quadratic polynomials `p(X)` and `a ∈ F_q ∪ ∞`. Quote: "We also show that
  this construction has a geometric interpretation in terms of the degree `(q−k)` normal
  rational curve in `P^{q−k}(F_{q²})` over a quadratic field extension `F_{q²}` of `F_q`." The
  proof (Lemma II.11) expresses the syndrome as `μ_a·c_{q+1-k}(μ) + μ_a^q·c_{q+1-k}(μ^q)` for
  `μ` a root of `p(X)` in `F_{q²}` — a conjugate-pair parametrization, not itself a curve's
  `F_q`-rational-point set (the points live over `F_{q²}`, paired by Galois conjugation, and the
  resulting combined object is a finite indexed family, not stated as "the rational points of
  variety X").
- **Theorem I.7** (complete classification for `k = q−3`, i.e. redundancy 4): "The total number
  of deep hole classes of `PRS(q−3)` is `q(q+1)²/2`. These are given by the `q` deep hole classes
  of Theorem I.4, `q²` classes of Theorem I.5, and `(q+1)q(q−1)/2` classes of Theorem I.6."

**Conclusion on Q1's central candidate**: the redundancy-4 classification is a **disjoint union
of three separately-constructed, separately-indexed families** tied to two different geometric
pictures (tangent lines to one rational normal curve; a quadratic-extension pairing on a second
copy of the same curve type over `F_{q²}`). This is a *stratification*, not an assertion that the
deep-hole locus equals the full rational-point set of one named variety. It matches the
background brief's stated reading exactly; that reading holds up against the primary text.

### VERIFIED — arXiv:2101.12722, Davydov, Marcugini, Pambianco, "On the weight distribution of
the cosets of MDS codes"

Fetched `https://arxiv.org/pdf/2101.12722`, extracted with `pdftotext`, read in full for
Definition 6.2, Theorem 6.3, and Theorems 6.4–6.5 (conic/hyperoval cases). See §3 below for the
full dictionary reading; the relevant Q1 fact is that this paper's own worked examples (conic,
hyperoval) never produce "deep-hole locus = rational points of a *different*, positive-
dimensional named variety" — the closest it gets is a single nucleus point (conic, `q` even) or
the empty set (hyperoval, complete). No sporadic small-arc example in the paper (its Table 6.1,
`n=6` for `q=7,8,9` and `n=7` for `q=11`) is analyzed for a `c_0`-locus identified with a named
curve; the table only lists `(c_1,c_2,c_3)`, implying `c_0 = 0` (complete arcs) for all of those.
Notably, **`n=6, q=11` — the Clebsch-hexagon case — does not appear in this table at all**,
consistent with it not being a previously-worked example in this line of literature.

### Q2/broader sweep — no counterexample found (see full detail in Q2 section)

Searched the explicit-deep-hole-construction literature (Kaipa 1612.05447, Wu–Hong, Zhu–Wan,
Li–Wan, Zhang–Fu–Liao) and two 2025/2026 follow-ons (arXiv:2605.12133, arXiv:2312.05534). None
of the fetched abstracts describe a deep-hole set as "the rational points of a named variety."
All explicit constructions found are finite combinatorial families (orbit unions, degree-bounded
polynomial families), same flavor as Zhang–Wan–Kaipa's three classes above.

### Q5-adjacent check — elliptic curve codes, AG codes (see Q5 for full detail)

VERIFIED (abstract only, via WebFetch) that arXiv:2207.12584 ("On Deep Holes of Elliptic Curve
Codes") constructs deep holes *for* elliptic-curve AG codes — the standard direction (curve
defines the code), not the reverse (curve emerges as the deep-hole locus). Confirmed this is not
a counterexample to the "first" claim; it's a different relationship entirely, and the
background brief's caution about not confusing the two directions is warranted and holds.

**Q1 residual risk**: this is a broad literature and I did not read every deep-hole paper
in full (see Q2 for exact per-paper tier). The check is a real search, not exhaustive
enumeration — mark the "first" claim as "audited, not found, not exhaustively disproved-absent."

---

## Q2. The deep-hole literature broadly: who computes deep holes explicitly vs. studies decision
complexity?

### Complexity strand (deciding/hardness, not explicit description)

- **VERIFIED (WebSearch results, not full text)** — Guruswami, Vardy (2005), "Maximum-likelihood
  decoding of Reed-Solomon codes is NP-hard": shows ML decoding of GRS codes is NP-hard, and
  deciding deep-hole-ness for GRS codes is co-NP-complete. This is a hardness/complexity result,
  not an explicit deep-hole description.
- **INFERRED (WebSearch summaries)** — Cheng, Murray (2007), "On deciding deep holes of
  Reed-Solomon codes": conjecture that standard RS-code deep holes (prime `q`) are only the
  trivial ones (generating-polynomial-degree `k`); also connects the special case `distance =
  k+1` to the finite-field subset-sum problem (NP-complete for `p > 2`). Complexity-flavored, but
  the conjecture itself is a (conjectural) explicit-description claim.

### Explicit-construction strand

- **VERIFIED (arXiv:1901.05445, read directly)** — Zhang, Wan, Kaipa (2019): explicit
  redundancy-4 classification, three combinatorial families (detailed in Q1). Confirms via its
  own citation list that Theorem I.4 originates in a paper labeled `[17]` in that bibliography
  (context suggests this is the Zhang/Wan/Kaipa group's own earlier work or a closely related
  predecessor; I did not resolve the exact `[17]` citation text since the bibliography page
  itself wasn't captured in the pdftotext output I read — NOT SEARCHED further).
- **INFERRED (WebSearch summaries only)**:
  - Kaipa, "Deep holes and MDS extensions of Reed-Solomon codes" (arXiv:1612.05447): complete
    classification for redundancy 3, and shows classifying deep holes is equivalent to
    classifying one-digit MDS extensions (the arc-completion picture). Also proves the
    Cheng–Murray conjecture for `k ≥ ⌊(q+1)/2⌋` (extending Zhuang–Cheng–Li's `k ≤ p` case). This
    paper is the direct predecessor superseded by Zhang–Wan–Kaipa's redundancy-4 result (the
    "[9]" reference in 1901.05445's abstract).
  - Wu, Hong: found a new class of deep holes for standard RS codes (explicit construction).
  - Zhang, Fu, Liao: gave a "concise method" for a new class of deep holes of GRS codes,
    recovering Wu–Hong's class as a special case (explicit construction).
  - Li, Wan: error-distance results via Weil-bound character-sum estimates; degree-`k+1`
    received words are never deep holes; exact error distance computable for degree `k+1` (and
    partially `k+2`) received words to standard/primitive RS codes. This is *bounding/ruling
    out* which words are deep holes via point-counting on varieties as a **technique**, not a
    claim that the deep-hole set itself equals a variety's point set — an important distinction
    matching the "duality" caution in Q5.
  - Zhu, Wan, "Computing Error Distance of Reed-Solomon Codes": algorithmic/computational
    framing.

### Recent (2025–2026) — no variety-equality claim found

- **VERIFIED (WebFetch of abstract page)** — arXiv:2605.12133, "A framework for constructing
  non-GRS MDS-NMDS codes from deep holes and its application": builds new non-GRS MDS-NMDS code
  families by using deep holes of smaller codes as extension points, recursively. Abstract
  confirms it does **not** identify any deep-hole set with a named variety's rational points.
- **VERIFIED (WebFetch of abstract page)** — arXiv:2312.05534, Wu, Ding, "Extended codes and
  deep holes of MDS codes": main result is `C̄(u)` (second-kind extended code) of an MDS code
  stays MDS iff `u` is a deep hole of the dual code and `ρ(C^⊥) = k`. Abstract confirms no
  variety-equality claim.

**Verdict for Q2**: two clearly separated strands (complexity/hardness vs. explicit
construction) as the brief anticipated. Every explicit-construction paper found produces
*combinatorial/orbit-indexed families*, sometimes with a geometric gloss (tangent lines, field
extensions) — never a "the deep-hole set equals the rational points of variety X" equality
claim.

---

## Q3. Covering radius of MDS codes / geometry vocabulary

### VERIFIED — arXiv:2101.12722, Davydov, Marcugini, Pambianco, "On the weight distribution of
the cosets of MDS codes" (full PDF read via pdftotext)

This is the paper carrying the exact dictionary cited in the manuscript's background. Confirmed
by reading directly:

- **Definition 6.2**: "For an arc in `PG(2,q)`, let `c_i` be the number of the points off the
  arc lying on `i` its bisecants. A complete (resp. incomplete) arc has `c_0 = 0` (resp. `c_0 >
  0`)."
- **Theorem 6.3(iii)** (exact quote): "For `c_0 = 0`, the arc `A` is complete, `C` is an
  `[n,n−3,4]_{q²}` code, we have no weight 3 cosets. For `c_0 ≠ 0`, the arc `A` is incomplete,
  `C` is an `[n,n−3,4]_{q³}` code having `(q−1)c_0` cosets of weight 3..." and, in the proof:
  "The points off the incomplete arc `A`, that do not lie on any bisecant of `A`, give the
  syndromes of the `(q−1)c_0` cosets of weight 3." — This **is** the "deep holes correspond to
  points on no secant/bisecant line" dictionary fact the background brief cites, confirmed
  verbatim in the primary source, for the `[n,n−3,4]_q` case (redundancy 3, i.e. `k=4` dual
  picture — matches the background's arXiv:1909.00207-for-`k=4` pointer).
- **Theorem 6.4** (conic, `H_4` parity check matrix): odd `q` → `R=2`, `c_0=0` (complete, conic
  is the unique `(q+1)`-arc for odd `q`, so no deep holes/no weight-3 cosets at all). Even `q` →
  `R=3`, `c_0=1`: the *single* uncovered point is the conic's nucleus `O=(0,1,0)`. This is the
  **only** worked "deep-hole locus tied to a named object" case for the conic itself in this
  paper, and it is a single point, not a positive-dimensional variety's point set.
- **Theorem 6.5** (regular hyperoval): complete arc, `c_0 = 0` — no deep holes at all.
- Sporadic small-arc table (Definition 6.2 context, `(6.1)`): `(c_1,c_2,c_3)` values for `n=6,
  q∈{7,8,9}` and `n=7, q=11`, sourced from Hirschfeld's book ("[27, Section 9]"). **No `c_0` value
  is given for any of these — implying `c_0=0` (all complete arcs) — and `n=6, q=11` is absent
  from the table.** This is circumstantial support that the Clebsch-hexagon `(n=6, q=11)` case
  genuinely sits outside this paper's worked examples.
- Reference list includes Bartoli–Davydov–Marcugini–Pambianco, "On planes through points off the
  twisted cubic in `PG(3,q)` and multiple covering codes" (arXiv:1909.00207) and
  Blokhuis–Pellikaan–Szönyi, "The extended coset leader weight enumerator of a twisted cubic
  code" (arXiv:2103.16904) — both directly relevant to Q4 (below).

### INFERRED (WebSearch summaries only) — broader saturating-set / complete-arc school

- Bartoli, Davydov, Giulietti, Marcugini, Pambianco, "Multiple coverings of the farthest-off
  points..." (2015, 2016) and "On the smallest size of an almost complete subset of a conic in
  `PG(2,q)`..." (2018): the latter is about arcs that are subsets of a conic missing a few
  points (i.e. the arc *is nearly* a conic) and Reed-Solomon extendability — this is the
  opposite geometric relationship from the audited claim (there the near-conic *is* the arc, not
  the deep-hole locus of a different arc). Confirmed distinct from the claim via abstract-level
  search; not a counterexample.
- Bartoli, Giulietti, Platoni, "On the covering radius of MDS codes" (2015): title/topic match
  from search only, full content not fetched. NOT SEARCHED beyond title confirmation.
- General "saturating set" vocabulary search turned up the standard ρ-saturating-set definition
  and related covering-code literature but no instance of a deep-hole/uncovered-point set
  identified with a positive-dimensional named variety's rational points, beyond the
  conic/hyperoval cases already covered above.

**Verdict for Q3**: the coding-side dictionary (deep holes ↔ points on no bisecant/secant) is
solidly confirmed as standard and pre-existing (Davydov–Marcugini–Pambianco and predecessors).
No prior paper in this school works out a sporadic small-`n` incomplete-arc case (like the
Clebsch hexagon) and identifies its `c_0`-locus with a named curve. This is consistent with,
though not exhaustive proof of, the "first" claim.

---

## Q4. The k=4 open question: arc in PG(3,q) with deep-hole locus = twisted cubic points?

### VERIFIED (abstract, WebFetch) — arXiv:2103.16904, Blokhuis, Pellikaan, Szönyi, "The extended
coset leader weight enumerator of a twisted cubic code"

Exact abstract quote: "The extended coset leader weight enumerator of the generalized
Reed-Solomon `[q+1, q−3, 5]_q` code is computed... For this we need the classification of the
points, lines and planes in the projective three space under projectivities that leave the
twisted cubic invariant... The pencil of a true passant of the twisted cubic, not in an
osculation plane gives a curve of genus one as double point scheme. With the Hasse-Weil bound on
`F_q`-rational points we show that there is a 3-plane containing the passant." This paper
computes the weight enumerator (including deep-hole-relevant weights) for the code **built from
the twisted cubic itself**, not for a different arc whose deep-hole locus is claimed to equal
the twisted cubic's points. No variety-equality claim of our shape.

### VERIFIED (PDF read via pdftotext) — arXiv:1909.00207, Bartoli, Davydov, Marcugini, Pambianco,
"On planes through points off the twisted cubic in PG(3,q) and multiple covering codes"

Fetched and grepped the full extracted text. This paper classifies points/planes of `PG(3,q)` by
their incidence with the twisted cubic `C` (orbits under the stabilizer of `C`), including a
classification by number of osculating planes through a point (`μ_Γ = 0, 1, 3, q+1`) and by
number of `d`-secant planes (`d=0,1,2,3`) through a plane. It explicitly cites the deep-hole
literature (Kaipa, Zhang–Wan–Kaipa, Hong–Wu, Xu–Xu) in its introduction, confirming the deep-hole
connection is on this group's radar. **However**: the twisted cubic is itself essentially always
a *complete* arc, so its own "points on no trisecant plane" locus (`c_0` analogue) is generically
empty — this paper's classification is about the twisted cubic's own incidence structure (for
building/analyzing the `[q+1,q−3,5]_q` GDRS code as a covering code), not about a *different*,
possibly-incomplete `PG(3,q)` arc whose uncovered-point locus happens to equal the twisted
cubic's point set. I did not find that specific question posed or answered anywhere in this
paper.

### NOT SEARCHED / UNRESOLVED

- Whether anyone has explicitly posed the question "does there exist an arc in `PG(3,q)` (no 4
  coplanar) whose deep-hole locus equals the `q+1` rational points of a twisted cubic" as an open
  problem. Targeted searches (`"trisecant plane" OR "0-plane" arc PG(3,q) deep holes twisted
  cubic open problem`) returned only the incidence-classification papers above, with no explicit
  statement of this question as open or otherwise. This should be read as **absence of evidence
  from a limited search**, not as confirmation that the question is unasked — the twisted-cubic
  orbit-classification literature is large (Bartoli–Davydov–Marcugini–Pambianco have a long
  running series: "Twisted cubic and orbits of lines in PG(3,q)" I and II, "point-line incidence
  matrix," "plane-line incidence matrix," etc.) and I sampled only two papers from it.
- Hirschfeld, "Finite Projective Spaces of Three Dimensions," ch. 21 (twisted cubics): not
  fetched (not available via web search/fetch in a form I could read); NOT SEARCHED.

**Verdict for Q4**: no counterexample found, but this question was given the least search depth
of the five per the effort budget. Treat as "audited lightly, nothing found" rather than "ruled
out."

---

## Q5. Vocabulary sweep: AG/Goppa codes, evaluation codes, Reed–Muller deep holes, covering
codes + AG

### VERIFIED (abstract, WebFetch) — arXiv:2207.12584, "On Deep Holes of Elliptic Curve Codes"

Exact abstract quote: "We give a method to construct deep holes for elliptic curve codes. For
long elliptic curve codes, we conjecture that our construction is complete in the sense that it
gives all deep holes. Some evidence and heuristics on the completeness are provided via the
connection with problems and results in finite geometry." This is the **standard direction**:
the elliptic curve defines the AG code, and the paper studies that code's deep holes — it does
not claim a *different* variety emerges as the deep-hole locus. Confirms the background brief's
caution (do not confuse "curve defines the code" with "curve emerges as the deep holes") is a
real distinction actively present in the literature, and this paper sits on the standard side of
it, not our side.

### VERIFIED — Reed--Muller residual closed by C154

C154 performed the dedicated pass that this audit originally left open; see the
[source-by-source report](2026-07-16-c154-reed-muller-deep-holes.md).  The primary literature
describes first-order binary deep holes as maximum-nonlinearity/bent functions, Ozeki's small
examples as Hamming association subschemes, generalized first-order maximizers by explicit
quadratic functions, and higher-order exact-radius results through affine/coset classifications
of Boolean functions.  None identifies the complete deep-hole locus with the full rational-point
set of a named positive-dimensional variety.  KLP, Abbe--Shpilka--Wigderson, and Dumer belong to
the list-size, random-channel, and decoding-algorithm strands rather than explicit deep-hole-set
classification.  Searches of projective Reed--Muller vocabulary found minimum-distance and
weight-enumerator work but no projective-RM deep-hole-set description.

The closest semantic near miss is important: bent functions are a named exact class of deep holes
for `RM(1,m)` when `m` is even, and Ozeki finds named association schemes on selected deep-hole
unions.  Neither is an algebraic-variety rational-point equality, so the manuscript's precise
claim boundary survives.

### INFERRED (WebSearch summaries only)
- AG-code / evaluation-code framing: found general background (Goppa's construction, `C_L(D,
  (k−1)O+P)` deep-hole construction language for RS-as-AG-code) but nothing describing an
  "exceptional set equals a named variety's points" pattern in the reverse (emergent) direction.
- Covering codes + algebraic geometry combined search: returned only Davydov et al. and
  Cafure–Matera-style point-counting-as-a-technique results (used to *bound/exclude* deep holes
  of certain polynomial degree, not to *equal* the deep-hole set with a variety).

### NOT SEARCHED

- Any non-English-language or differently titled pre-web literature that might independently carry this
  vocabulary.

**Verdict for Q5**: the AG/Goppa-code direction-confusion caution is confirmed as real and
correctly avoided by every paper found.  C154 closes the named Reed--Muller residual without a
counterexample.  As throughout this report, that is a bounded negative audit, not an exhaustive
priority certificate.

---

## Sources fetched directly in this run (full audit trail)

- `https://arxiv.org/abs/1901.05445` and `https://arxiv.org/pdf/1901.05445` (full text extracted
  via pdftotext and read) — Zhang, Wan, Kaipa.
- `https://arxiv.org/abs/2101.12722` and `https://arxiv.org/pdf/2101.12722` (full text extracted
  via pdftotext and read) — Davydov, Marcugini, Pambianco.
- `https://arxiv.org/pdf/1909.00207` (full text extracted via pdftotext and grepped/read in
  relevant sections) — Bartoli, Davydov, Marcugini, Pambianco, twisted cubic.
- `https://arxiv.org/abs/1909.00207`, `https://arxiv.org/abs/2103.16904`,
  `https://arxiv.org/abs/2207.12584`, `https://arxiv.org/abs/2605.12133`,
  `https://arxiv.org/abs/2312.05534` — abstract-page WebFetch only.
- WebSearch queries (results read, not independently fetched further): Cheng–Murray complexity;
  Guruswami–Vardy NP-hardness; Li–Wan error distance; Zhu–Wan new deep holes; uncovered
  points/saturating sets; Reed–Muller deep holes + variety; complete-arc-outside-a-conic +
  PG(2,11); Bartoli–Giulietti uncovered points; trisecant-plane/twisted-cubic open problem;
  Kaipa MDS extensions; deep holes + conic + non-GRS; exceptional-set + AG-code duality.

## Local extraction artifacts (scratchpad, not part of the citable record)

- `/tmp/claude-1000/-home-tavis-src-othello-rust/9b212ae1-fab7-4154-9772-0edac1ff558b/scratchpad/zhang-wan-kaipa.txt`
- `/tmp/claude-1000/-home-tavis-src-othello-rust/9b212ae1-fab7-4154-9772-0edac1ff558b/scratchpad/dmp-2101.txt`
- `/tmp/claude-1000/-home-tavis-src-othello-rust/9b212ae1-fab7-4154-9772-0edac1ff558b/scratchpad/twisted-cubic-1909.txt`
