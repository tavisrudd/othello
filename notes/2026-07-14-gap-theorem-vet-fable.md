# Vet of the gap-theorem sweep and its relay (Fable)

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Scope**: audit of two texts — the gap-theorem sweep's report
(`2026-07-14-gem-lit-gap-theorem.md`) and Opus's relay of it to the user — against sources I
opened myself. Rulings on the large-k defence (the user-flagged question), the positioning
advice, and the Faina et al. hazard.

## 1. Verdict summary

- **The sweep's sourcing is solid.** Every quote I checked against a fresh extraction of the
  same source is verbatim-correct: Problem (III), Theorem 2.5, Tables 2.3/2.4/2.5, the
  Sadeh-thesis reference [189], the q=11 citation line, the absence of Hirschfeld–Sadeh 1984
  from the bibliography, Faina et al. [77], Ball–Blokhuis, Blokhuis–Bruen (via De Boeck
  Thm 6.1.5), De Boeck's tangent-envelope section, and the Thas-notes extension bounds and
  open problems. Line counts of my fresh extractions match the sweep's exactly
  (2,982 / 15,226 / 1,108), so the sweep read what it said it read.
- **One real mathematical error, in both texts: a parity slippage in the tangent-envelope
  threshold.** "k > q/2 + 1 (= 6.5 at q=11)" is the **q-even** theorem's hypothesis applied at
  an odd q. The correct odd-q threshold (Segre, via Ball–Lavrauw Thm 40, verified below) is
  `|A| ≥ 2q/3 + 2 ≈ 9.34`, i.e. `k ≥ 10` at q=11. The conclusion — k=6 is excluded —
  **survives and widens** (fails by four points, not half a point), but the printed number is
  wrong for our parity, and the sweep's "fails by half a point — strikingly close, worth
  remarking" must not enter the manuscript.
- **Opus's flag 1 dissolves — no caveat was actually dropped.** The `≈ 11.73` constant Opus
  relayed (`q − √q/4 + 25/16`) is **VERIFIED**, quoted verbatim in the Thas notes the sweep
  opened (and re-verified by me, plus independently in the survey's Table 2.3). The sweep's
  INFERRED flag attaches to a *different* constant — the `m′` bound `q − √q/4 + 7/4` — which
  Text 2 never used. The two constants were conflated in the worry, not in the claim.
- **Flag 2 ruling (short form): the defence is real as a non-collision certificate and
  unavailable as a significance certificate.** Use it to show no classical theorem subsumes
  the statement; do not use it to argue the result is deep. Full ruling in §5.
- **Positioning ruling (short form): adopt the genre sentence, with guards** — anchor on the
  minimum-side precedents (Blokhuis–Bruen; the Kakeya "gap in the spectrum" title), cite
  Problem (III) as the frame with an explicit non-claim on Thas's open problem (j), keep the
  "in PG(2,11)" scoping. Full ruling in §6.
- **New find that changes the risk table:** Ball–Lavrauw's open-access survey (arXiv:1908.10772,
  Thms 39–41) states the entire envelope/extension machinery for **both parities** with exact
  hypotheses, attributes the planar case to Segre, and its proof contains verbatim the
  "extension points are linear factors of the dual form" identification. It is a better
  citation than PGOFF Cor. 10.3 and it **downgrades the PGOFF §10.1 risk** from
  "defence collapses if..." to a confirmatory check (§8.2).

## 2. Provenance of this vet

Fresh downloads, extracted with pdftotext, all quotes checked against my own extraction:

| Source | URL | My extraction |
|---|---|---|
| Hirschfeld–Storme survey (update 2001) | cage.ugent.be/~ls/max2000finalprocfilejames.pdf | 2,982 lines — matches sweep |
| De Boeck, Ghent thesis | cage.ugent.be/geometry/Theses/61/PhDDeBoeck.pdf | 15,226 lines — matches sweep |
| Thas, *Arcs, caps and codes* lecture notes | ftmakroglu05.github.io/Finite-Geometry-School/Joseph_Thas.pdf | 1,108 lines — matches sweep |
| Ball–Lavrauw, *Planar arcs* | arXiv:1705.10940 | 1,521 lines |
| Ball–Lavrauw, *Arcs in finite projective spaces* | arXiv:1908.10772 | opened §§ on Thms 39–41 |

Also read: the manuscript §4 (`papers/clebsch-hexagon-code/clebsch_hexagon_code.tex`,
Thm `thm:rigidity` and Thm `thm:gap` with their proofs and the census-framing paragraph), the
sweep's full report, the companion rigidity sweep, the clebsch handoff §"The gap theorem — its
own pass", the consolidated sweep report, and the novelty status tables.

Arithmetic re-checked: `q/2 + 1 = 6.5` at q=11; `q − √q/4 + 25/16 = 11.7333` at q=11;
`2q/3 + 2 = 9.33` at q=11; Voloch's prime bound `44q/45 + 8/9 = 11.64` at q=11; perturbation
spectrum `{18:30, 19:60, 20:90, 22:42, 24:30}` sums to 252; histogram
`{12:6, 16:30, 18:150, 19:300, 20:630, 21:360, 22:72}` sums to 1548. All consistent with the
manuscript.

## 3. Audit of Text 1 (the sweep's report)

### 3.1 Confirmed, with quotes located in my own extraction

- **Problem (III)** — survey line 84: "(III) Find the size m″(r, s; N, q) of the second largest
  complete (n; r, s; N, q)-set." Verbatim as the sweep quoted.
- **Theorem 2.5** — the q = 2^{2e} disjunction and the q=16 list "9, 10, 11, 12, 13, 18".
  Verbatim.
- **Table 2.4**: `m″(2,11) = 10`. **Table 2.5**: `t(2,11) = 7`. Both as claimed.
- **The q=11 citation line** — "for q = 11, see [189], [129, §14.8]" — verbatim, with one
  precision the sweep did not state: the sentence's context is specifically the table of
  `m″(2,q)` values (second largest complete arc), not q=11 arc data generally. The conclusion
  (Hirschfeld points at the thesis + §14.8 for q=11 arc classification) stands with that nuance.
- **[189] is Sadeh's thesis** — verbatim. **HS84 is absent**: the Hirschfeld bibliography block
  runs [124]–[136] with no Hirschfeld–Sadeh entry; the only Giessen item in the whole
  bibliography is Innamorati, Mitt. Math. Sem. Giessen 235 (1998). G3 is fully verified.
- **Faina–Marcugini–Milani–Pambianco [77]**, Ars Combin. 47 (1997) 3–11, q ≤ 23 — verbatim.
- **Ball–Blokhuis** (survey Thm 6.2(iii)) and **Blokhuis–Metsch/Innamorati** (6.2(ii)) —
  verbatim. The "three instances of the genre sentence" claim is confirmed: I located all three.
- **Blokhuis–Bruen via De Boeck Thm 6.1.5** — verbatim (fractions garbled by pdftotext in the
  predictable way; the surrounding prose "It classifies the second largest Kakeya set in
  AG(2, q), q even" is exact). De Boeck refs [15] and [16] verbatim as quoted.
- **De Boeck's tangent-envelope section** — the definition (class `q+2−k` even, `2(q+2−k)` odd)
  and Thm 6.2.1 ([80, Cor. 10.3(ii)], q even) are as quoted. The `k > q/2 + 1` reading of the
  garbled fraction is correct: the proof of the adjacent Lemma 6.2.2 concludes with the bound
  `q/2`, fixing the fraction convention.
- **Thas notes**: the three problems of Segre, the extension bounds attributed
  "(Segre (1967), JAT (1987))" — q even `k > q − √q + 1` → hyperoval; q odd
  `k > q − √q/4 + 25/16` → conic — and open problems (g) and (j), all verbatim.
- **The `≈ 11.73` arithmetic** is right, and the constant `25/16` gets a second independent
  verification from the survey's own Table 2.3, row (1): `m″(2,q) ≤ q − √q/4 + 25/16` for
  `q = p^{2e}`, p > 2 — attributed there to **Thas [220]**, not Segre.

### 3.2 Errors and overstatements in Text 1

1. **The parity slippage (the one real error).** The verdict summary and recommendation 2 both
   print "the tangent envelope needs `k > q/2 + 1` (= 6.5 at q=11)". That threshold is the
   hypothesis of a **q-even** theorem (De Boeck Thm 6.2.1 = PGOFF Cor. 10.3(ii); Ball–Lavrauw
   Thm 40 with m=1). At q odd the machinery is gated at `|A| ≥ 2q/3 + 2` (m=2 in Ball–Lavrauw
   Thm 40; planar case due to Segre) — at q=11 that is ≈ 9.34, i.e. arcs of ten or more points.
   The full report's G5 body does state the q-even hypothesis and correctly says our case
   "fails the size hypothesis even in the odd-q analogue", but the headline number is the wrong
   parity's, and the packaged defence sentence (end of G6) ships it.
2. **G6's aside "fails it by half a point — strikingly close, worth remarking" is false at our
   parity.** The margin at q=11 odd is four points (6 vs 10), not half a point. If the
   manuscript remarked on the near-miss it would be remarking on a number that does not apply.
3. **"G5 falsifies the companion sweep" is overdrawn.** The companion's claim had two readings:
   (a) the tradition had no *handle on the object* `U(A)`; (b) the cubic-surface program had no
   *motive* to compute it. G5 falsifies (a) — the tangent-envelope theory is a classical handle.
   It does not touch (b): Karaoglu's tables (the direct modern continuation of the Sadeh line)
   still have no extension column, and the Clebsch-map pipeline still consumes only "the arc is
   not on a conic". The two arguments are complementary, and the manuscript can use both (§5.3).
4. **The INFERRED `m′` constant (`q − √q/4 + 7/4`, "Segre's own") is contradicted by the
   survey the sweep itself opened.** Table 2.3 row (1) gives `25/16`, for q an odd *square*,
   attributed to Thas; for q *prime* the applicable bound is Voloch's `44q/45 + 8/9` (row (3),
   ≈ 11.64 at q=11). The sweep's own instruction — do not cite the constant before opening
   Segre/Thas — was right; the resolution is simpler: cite the survey's Table 2.3 and skip the
   attribution question entirely.

Everything else in Text 1 that I checked is accurate, and its tiering discipline
(VERIFIED/INFERRED flags, the provenance ledger) held up under audit.

## 4. Audit of Text 2 (Opus's relay)

1. **Inherited and amplified the parity slippage.** Text 2 states "The tangent envelope needs
   `k > q/2 + 1` (= 6.5 at q=11)" with the q-even hypothesis dropped entirely, and builds the
   "checkable instead of an absence" pitch partly on that number. The checkable statement is
   real, but the number a referee would check is the odd-q one, and it is different (and more
   favourable).
2. **Flag 1 (the self-flag) is misaimed.** The caveat Opus feared dropping — "Segre's `m′`
   constant is INFERRED" — belongs to the `7/4` bound, which Text 2 never quoted. The constant
   Text 2 did quote, `q − √q/4 + 25/16 ≈ 11.73`, is quoted verbatim in the Thas notes (G6,
   tier VERIFIED) and now doubly verified by me. So no tier was dropped in the relay; the
   near-miss was real but happened not to land. The correct discipline point stands: Text 2
   did not distinguish the two constants, which is exactly how the worry arose.
3. **"It falsified the rigidity sweep's structural argument" — same overstatement as Text 1's
   summary** (see §3.2 item 3). The motive half of the structural argument survives.
4. **"That half of C131 is settled without the ILL" — acceptable, but scope it.** G3 settles
   *where the concession should aim* (the thesis + §14.8, not HS84). It does not establish
   HS84's contents; that still rests on the zbMATH review. The tex's current posture (decline
   priority without asserting who holds it) is correct either way and does not depend on the
   gate.
5. Text 2's remaining claims — the genre finding, the sentence template, the Faina hazard, the
   ILL retarget — are faithful relays of verified findings. The "worse than the first"
   ranking of the two conflation hazards is editorial judgment, not error; if anything the
   arc-on-conic/U-on-conic conflation (one word apart, same sentence position) is the more
   dangerous of the two.

## 5. Ruling on flag 2 — the large-k defence

### 5.1 The strongest version of the opposing case

Sadeh's census has existed since 1984 and has fifteen classes; computing `|U(A)|` per class,
given the census, is an afternoon with any computer of that era. So "the classical tools do not
reach k=6" cannot explain why the gap statement was never made — nothing about stating it
required those tools. What the hypotheses-exclude-us argument actually establishes is only that
no classical *theorem* subsumes the statement. The reason nobody stated it is that, absent the
coding/deep-hole reading, the fine structure of `|U|` over the six-arcs of one small plane is
beneath the tradition's notice: the Segre school reserves "theorem" for statements with
mechanisms that hold across q, and an enumerated fact at a single q where the phenomenon
provably dies at the next prime (q=19) is, from that vantage, a table entry. On this reading,
"their tools don't apply" is an explanation of why the result is small, and dressing it as the
paper's "best defence" invites a referee to complete the syllogism.

### 5.2 The ruling

**The defence is real, but only as a non-collision certificate — and that is the only job the
paper needs it to do.** Two distinct claims must not be blended:

- *Novelty*: no prior statement exists, and no classical theorem subsumes or could subsume it.
  The hypotheses argument proves the second half checkably (thresholds at `k ≥ 10` and
  `k ≥ 12` against our `k = 6`), and it is the strongest available form of that half. Keep it.
- *Significance*: why the statement is worth making. The hypotheses argument contributes
  nothing here — "out of reach" and "beneath notice" are both consistent with it, and the
  opposing case shows "beneath notice" is at least partly true. The significance case lives
  where the manuscript already puts it: the DMP dictionary makes `|U(A)|` the
  covering-radius-3 coset count of an MDS code, deep-hole structure is an independently
  studied coding invariant, and the gap is the quantitative support for a rigidity theorem
  that recovers A₅ from a covering condition. The gap matters because of what it protects,
  not because it was hard.

The two structural explanations are complementary, not rivals, and the calibrated form uses
both: *the arc-classification line had the census but no motive to interrogate `U(A)`'s
geometry (its tables are indexed by cubic-surface invariants), and the arc-extension line,
which does study extension points, works under size hypotheses that provably exclude k=6.*
That sentence claims no depth and no blind-spot heroics; it answers "why was this available"
without pretending the answer is "because it was inaccessible".

Also to be clear about what the field's own norms say: the genre publishes exactly this kind
of small-q census fact — Theorem 2.5's second sentence is the complete-arc size list of the
single plane PG(2,16), and Tables 2.4/2.5 are per-q values. "It is an enumerated fact at one
q" is not disqualifying in this literature. What would be disqualifying is pricing it as
progress on the genre's open problems, which is the positioning question.

### 5.3 The corrected defence sentence

The manuscript's one-sentence version should read, correctly gated (citations: Ball–Lavrauw
arXiv:1908.10772 Thms 39–41 with the planar case credited to Segre; the Segre/Thas bound from
the Thas notes or HS survey Table 2.3):

> Both classical routes to the extension points of an arc are large-arc tools: the unique
> tangent envelope through which Segre's theory identifies extension points requires
> `|A| ≥ 2q/3 + 2` for q odd (ten points at q=11), and the Segre–Thas embedding bound
> requires `|A| > q − √q/4 + 25/16` (twelve points at q=11); a six-arc lies below both, in
> the regime where the envelope of class `2(q+2−k) = 14` is not even unique.

Optionally, the vacuity witness of §8.1 makes the last clause concrete.

## 6. Ruling on the positioning advice

**Adopt the sentence — the advice is right, and I verified its evidentiary base** (all three
instances of the template are genuine, and the four-part Blokhuis–Bruen shape does match claim
(a) exactly). Same content, and only one of the two phrasings tells a referee which shelf the
result sits on. Three guards:

1. **Anchor on the minimum side, not on Problem (III) itself.** Problem (III) is a
   *maximum-side* question (second largest complete arc). Claim (a) is a *minimum-side* gap
   (smallest value, uniqueness, forbidden interval above it). The orientation-exact precedents
   are Blokhuis–Bruen (second largest Kakeya set = the dual minimum-side statement De Boeck
   quotes) and the Blokhuis–De Boeck–Mazzocca–Storme title "a gap in the spectrum and
   classification of the smallest examples". Lead with those; cite Hirschfeld–Storme
   Problem (III) as the organizing frame. This is a refinement of the sweep's advice, not a
   reversal — and it is also the cheapest defusal of the Thas-(j) hazard, because problem (j)
   is the maximum end of a different invariant.
2. **The Thas-(j) comparison arrives whether or not we invite it.** PG(2,11) sits in the
   published Problem (III) tables (`m″(2,11) = 10`, Table 2.4), and "spectrum" + "gap" + "q=11"
   will pattern-match for any referee from this school. Adopting the genre's language does not
   create that risk; it creates the *opportunity* to pre-empt it in the same paragraph: one
   sentence stating that our invariant is `|U(A)|` over arcs of fixed size six, all incomplete
   since `t(2,11) = 7`, that it meets the complete-arc size spectrum only at the empty boundary
   case `c₀ = 0`, and that we claim no progress on problem (j).
3. **Keep the single-plane scoping visible.** The genre's sentences are mostly family-level
   theorems with mechanisms; ours is an enumerated fact in one plane. "There is no six-arc A of
   PG(2,11) with `12 < |U(A)| < 16`..." already carries the scope; keep the enumeration proof
   adjacent so the form does not imply a general-q claim. The precedent that licenses this is
   Theorem 2.5's own q=16 list.

## 7. Ruling on the G8 hazard (Faina–Marcugini–Milani–Pambianco)

**Cite-and-distinguish is enough; the paper's existence does not damage claim (a).** Their
invariant is the set of sizes k admitting a *complete* k-arc; ours is the deep-hole count of
*fixed-size, uniformly incomplete* six-arcs. The two meet only at `|U| = 0` (completeness),
which is empty at k=6 since `t(2,11) = 7`. The overlap is one word, not any content. Left
uncited it is a referee flag; cited it becomes support — the survey's Table 2.5 sources its
`t(2,q)` values partly to [77], so the same citation both distinguishes the invariants and
backs the no-zero-bin remark. The residual threat to claim (a) is not Faina et al.; it remains
Sadeh's thesis (could conceivably state, not merely entail, the gap), which the sweep's risk
table already carries.

## 8. What both texts missed

### 8.1 A one-line vacuity witness for the defence

At `k = 6`, `q = 11`, the tangent envelope has class `2(q+2−k) = 14`, which exceeds
`q + 1 = 12`, the total number of lines through a point of PG(2,11). The basic constraint
"lines through a point of an envelope ≤ its class" (De Boeck, directly above the envelope
definition) is therefore vacuous at our parameters: membership of a pencil in a class-14
envelope constrains nothing, and uniqueness is hopeless. This is a concrete, checkable way to
say "the machinery degenerates here", stronger than quoting thresholds alone.

### 8.2 Ball–Lavrauw Thms 39–41 supersede PGOFF Cor. 10.3 as the citation — and downgrade the ILL risk

arXiv:1908.10772 (open access) states the full machinery for both parities: Thm 39 constructs
the dual form φ of degree `mt` (m=1 q even, m=2 q odd) under `|A| ≥ mt + k − 1`; Thm 40
(planar case credited to Segre) derives unique completion for `|A| ≥ mq/(m+1) + k − 1`, and its
proof states verbatim that "φ contains linear factors of multiplicity m for each point x which
extends A to a larger arc — the extension of A to a complete arc... can be found by finding the
linear factors of φ(Z)"; Thm 41 identifies the tangent set with a unique hypersurface of degree
`mt` under the same gate. (The printed hypothesis of Thm 40 reads `mq/(m−1)+k−1`, a typo —
division by zero at m=1; substituting `t = q+k−1−|A|` into Thm 39's gate gives `mq/(m+1)+k−1`,
which is `q/2+2` planar even — matching PGOFF Cor. 10.3(ii)'s `k > q/2+1` exactly — and
`2q/3+2` planar odd.)

Consequences:

- **The Segre/tangent-envelope identification the sweep imported from De Boeck is verified**,
  from a second, independent, open source, for both parities, with its exact hypotheses. The
  identification is real; it is hypothesis-gated; the gate excludes k=6 at every parity.
- **The PGOFF §10.1 risk-table row should drop from top severity.** The sweep ranked
  "Cor. 10.3 reaches small k or odd q" as the finding that would collapse recommendation 2.
  But Ball–Lavrauw 2019 is the definitive modern survey of precisely this machinery, written
  by the people who sharpened it; if PGOFF's odd-q part reached small k, Thm 40's stated gate
  and its Segre attribution would say so. The remaining reason to open §10.1 is confirmatory
  — and De Boeck's footnote 1 records that PGOFF's printed statements of these theorems
  contain misprints (`q + k − 2` for `q + 2 − k`), one more reason not to cite Cor. 10.3
  sight-unseen when an open-access alternative states the result cleanly. **The top ILL
  target reverts to §14.8 (the q=11 census) with Table 9.4**; §10.1 stays on the request but
  no longer gates the defence.

### 8.3 The landed verdict in the handoff carries the parity error

`notes/handoffs/2026-07-13-clebsch-paper.md` §"The gap theorem — its own pass" states: "The
tangent envelope needs `k > q/2 + 1` (= 6.5 at q=11) and Segre's extension bound needs
`k > q − √q/4 + 25/16` (≈ 11.73); our `k = 6` fails both." The second threshold is right; the
first is the q-even gate. When the lane next touches the handoff, replace with the odd-q gate
(`|A| ≥ 2q/3 + 2`, ten points at q=11, per Ball–Lavrauw Thm 40) — the correction strengthens
the sentence. Same fix applies wherever recommendation 2's wording is adopted into the tex.
(Not edited here; this vet's instructions were report-only.)

### 8.4 Small items

- The audit prompt's own gloss "`U(A)` = non-components of the tangent envelope" is garbled:
  the identification is that extension points are the points whose pencils **are** components
  (dually, extending lines are components of the tangent curve). Stated correctly in both the
  sweep's report and the relay; noting it here so the prompt's phrasing does not propagate.
- The survey cites [189]/§14.8 specifically in the `m″(2,q)`-table context (see §3.1), which
  also confirms Sadeh's thesis contains complete-arc data at q=11 — consistent with, and mildly
  reinforcing, the manuscript's decline-without-attributing posture on the census.
- The manuscript's Thm `thm:gap` prose "…≥ 18 from the conic (so at most seven of the twelve
  conic points survive…)": the "so" reads as a derivation, but the seven-survivors fact is a
  separate computed output of the same enumeration, not a consequence of the ≥ 18 bound alone.
  Cosmetic; worth one word ("and") when the section is next edited.

## 9. Disposition of the two texts' claims

| Claim | Where | Status after vet |
|---|---|---|
| Gap theorem survives, both halves, no collision | both | **Stands** (unchanged; conditioned on Sadeh thesis as before) |
| Genre = Problem (III); HS survey defines the form | both | **Verified** — with the minimum-side refinement of §6.1 |
| Genre sentence verified three times | both | **Verified** — all three located |
| G5: `U(A)` classical via tangent envelope | both | **Verified** (De Boeck + Ball–Lavrauw), hypothesis-gated as claimed |
| "Falsifies the companion's structural argument" | both | **Overdrawn** — kills the no-handle reading, not the no-motive reading |
| Tangent-envelope threshold "6.5 at q=11" | both | **Wrong parity** — odd-q gate is ten points; conclusion survives, wider |
| "Fails by half a point, strikingly close" | sweep G6 | **False at our parity** — do not use |
| Segre extension bound ≈ 11.73 | both | **Verified** (Thas notes verbatim; arithmetic checked) |
| Opus flag 1 ("I dropped the INFERRED caveat") | Opus | **Misaimed** — the caveat attaches to the unquoted `7/4` m′ constant |
| G3: HS84 absent, thesis + §14.8 cited for q=11 | both | **Verified exhaustively** — gate lift is sound, scoped per §4.4 |
| G8: Faina et al. covers q=11, must distinguish | both | **Verified**; cite-and-distinguish suffices (§7) |
| `t(2,11)=7`, `m″(2,11)=10` published | both | **Verified** (Tables 2.5/2.4) |
| "Rigid, not merely stable" correct vs stability genre | both | **Stands** (genre definition INFERRED-tier as the sweep flagged; content corroborated by the verified Blokhuis–Bruen statement) |
| ILL retarget: §10.1 is highest-value unread | both | **Superseded** — §8.2: §14.8 back on top; §10.1 confirmatory |
