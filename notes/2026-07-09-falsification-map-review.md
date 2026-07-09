# Adversarial review — falsification map, witness-count heuristic, R1/R2 claim sets

Date: 2026-07-09. Reviewer: Fable (adversarial vet; read-only pass).

Scope: [`2026-07-09-odd-plane-falsification-map.md`](2026-07-09-odd-plane-falsification-map.md)
(the map), [`2026-07-09-witness-count-heuristic.md`](2026-07-09-witness-count-heuristic.md) (the
report), and two chat-only claim sets R1 (proof-by-elimination enumeration) and R2 ("what would
Tao do"). Verified against: the handoff §Odd-Plane Kernel, the Lean tree under `lean/ProjectiveCap/`
(read directly), the depletion note
[`2026-07-08-s4-two-ply-conic-depletion.md`](2026-07-08-s4-two-ply-conic-depletion.md), the
erratic-margin note, the raw feat data in `notes/data/`, and a fresh run of
`rust/scripts/witness_count_heuristic.py`. Note per the user: the line-capacity review
([`2026-07-09-fable-line-capacity-review.md`](2026-07-09-fable-line-capacity-review.md)) was
authored by Opus, and this pass treats it as one more artifact under scrutiny — relevant, because
the map inherits one of its soft spots (correction M4).

## 0. What was verified and holds (one line each)

- Parser rerun reproduces the report's §4/§5/§6 tables verbatim; cross-check `PASS` (21/21, 27/27).
- `m_total = 1,7,13,13,46,5,211` matches the erratic-margin note's min-escape column exactly.
- Raw feat files contain the claimed class counts (8/21/27 `CLS` lines at q=11/17/19) and
  `pos=int/ext` lines — the "full census" claim is true; q=17 `cls=2` has `escape=5 onP=1`
  (the knife edge), confirmed in the raw data, not just the summary.
- Hand-recomputed spot arithmetic: `mu_on(17)=57/21=2.714`, `E0_on=21·e^{−2.714}=1.391`,
  ON dispersion 0.180 (q=17) and 0.397 (q=11), `E0_tot(7)=3e^{−7}=2.74e−3`. All correct.
- `q²−9q+21` values and the negative-discriminant "no terminal size-3" argument: correct.
- Lean: no `sorry` anywhere under `lean/` outside mathlib test files;
  `initialPStatement_iff_isP_frame_of_finrank`, `SizeThreeExtensionCountStatement`,
  `oddEscapeStatement_of_onConicEscapeStatement`, `uniqueConicThroughFiveArcStatement`,
  `exists_hyperbolaNormalForm`, and `initialPStatement_of_oddEscapeStatement_finrank` all exist
  as stated; Q11/Q13 assemblies close those planes with `#print axioms` lines present.
- The solver's size-3 `canon()` group (diagonal-affine `(r,c)↦(ar+b, cc+d)` plus transpose) is a
  subgroup of the true game-preserving stabilizer — a sound quotient (can split true classes,
  can never merge inequivalent ones), so no B3-style unsoundness at the size-3 census layer.
  Fingerprint collision (B1) remains the correctly-named residual risk.
- Depletion-note bounds re-derived: `q−5−6−8 = q−19` (off/off), `q−13` (mixed), `q−7` (on/on) —
  arithmetic sound as lower bounds.

## 1. Per-artifact verdicts

### 1.1 The falsification map — NEEDS-CORRECTION (framing sound, four real corrections)

The taxonomy, the §2 category-error argument, the A/B split, and the §5 verdict structure are
sound. Specific corrections:

- **M1 (§1, the headline equivalence — the sharpest finding of this review).** "By the proven
  reduction … ⟺" overclaims the Lean status. What is Lean-proven is **escape ⇒ root P**
  (`GridMirror.initialPStatement_of_oddEscapeStatement_finrank`, no sorries). Its contrapositive —
  **conjecture false at q ⇒ a trapped size-3 exists** — is therefore also proven, and that is the
  direction the elimination scaffold actually stands on, so the map's *program* is safe. But the
  converse, **trapped size-3 ⇒ conjecture false** (equivalently root P ⇒ every size-3 escapes),
  is **not in Lean** (no `oddEscapeStatement_of_initialPStatement` or equivalent exists; searched).
  It is morally true — root P gives that every size-3 *containing the standard seed* escapes, and
  sharp frame-transitivity should transport any legal size-3 onto a seed-containing one — but that
  transport is exactly the kind of step this project formalizes before trusting. Consequence: a
  *found* trap would not, today, be a certified counterexample. State the equivalence as
  "proven ⇒, expected ⇐ (unformalized transitivity transport)".
- **M2 (§4B, B2's watch items are both stale — and one points the wrong way).** "Watch the
  escape ⇒ root-P direction" names the direction that IS Lean-proven; the direction genuinely
  missing is the converse (M1). And "5-arc non-degeneracy for every size-3" is already
  discharged: `uniqueConicThroughFiveArcStatement` is an unconditional theorem and
  `exists_hyperbolaNormalForm` is proven for every card-3 `GridCap` — it is used without side
  conditions inside `ConicLocalization`. B2 should be rewritten as: "watched: the trapped ⇒
  root-N converse (unformalized); everything else in the chain is kernel-checked."
- **M3 (§3, q ≥ 23 row justification overstates the depletion note).** "Empty-conic base laws
  that closed q ≤ 19 **provably cannot exist** for q ≥ 23" is wrong on two counts. (a) The
  `live_on ≥ q−19` bound is a **two-ply / S4-reply-layer** statement; deeper in the subtree the
  conic *can* still empty at q ≥ 23 (later off-conic moves keep killing live cells and the game
  is long enough), so empty-conic base states — and laws over them — remain possible below the
  reply layer. (b) Nothing at q ≤ 19 was actually "closed by an empty-conic base law": q=11/13
  are closed by Lean certificate trees, q=17/19 are computed; the empty-conic law is the
  *proposed* target mined from the q=17 score-9 stratum. The correct statement: the q=17-mined
  proof shape (reply-layer conic-emptying repair + empty-conic base) provably cannot fire at the
  reply layer for q ≥ 23, which is why the frontier argument must maintain a positive live conic
  through at least the early plies. The strategic conclusion survives; the "provably cannot
  exist" wording does not.
- **M4 (§3, obligation 1 half-underwritten).** "A re-zeroing off-conic intruder always exists.
  Underwritten as a base-layer fact by the reservoir bound" — the reservoir bound underwrites
  only the **availability of a legal off-conic cell**, and only at the base layer (`k=6` is its
  last useful `k` at q=23). The **re-zeroing property** of some available cell is
  mining-supported ("witness within the first four zero-xor candidates"), not underwritten by
  any counting fact. This phrasing is inherited from the Opus line-capacity review §2; that
  review's own §4 carries the bounded-depth caveat, and the map's compression drops the
  legal-vs-re-zeroing distinction entirely. Obligation 1 is really two obligations:
  availability (reservoir, base layer only) + re-zeroing existence (open).
- **M5 (§6, numeric error, trivially checkable by a referee).** "`mu_total − ln N_canon ≥ +6.5`,
  min at `q=17`" is false: the q=7 margin is **+5.901** (and q=5 is +1.000). True statement: min
  over `q ≥ 9` is +6.53 at q=17. Same error in the report (§5 reading "worst at q=17") and in
  the drafted insert.
- **M6 (§4A, A4 wording).** q=27 is not `p^{2k}` and PG(2,27) has **no Baer subplane** (Baer
  requires square order). The Baer rationale covers 25 and 49; q=27 is under-tested for the
  different reason of being a proper prime cube (subfield plane PG(2,3), order 3 ≠ √27).
- **M7 (§5, minor).** q=3 is listed "eliminated modulo solver," but at q=3 no legal size-3
  exists at all (every one-per-row/column triple in AG(2,3) is a line — the 6 transversals are
  exactly the 6 slope-1/slope-2 lines), so escape is vacuous and q=3 follows from the proven
  escape ⇒ P theorem with no solver trust. It belongs in the Lean-unconditional bucket.
- **M8 (§6, object conflation, also report §7).** "The same `live_on ≥ q−19` object": `live_on`
  bounds **legal** on-conic cells; `mu_on` counts **P-valued** ones. At q=17 all 13 on-conic
  extensions are legal (`legal_on` asserted in the census) yet `mu_on = 2.71` — the dips are
  **value**-depletion (`onN > 0`), which no legality/counting bound touches. The identification
  is thematic ("same layer, same conic"), and as written it invites reading the incidence bound
  as progress on the value bound. Keep the analogy, add the distinction.

Regime table (§3) otherwise checks out against the handoff and depletion note, with one small
flag: "conic **can** be emptied" for `11 ≤ q ≤ 19` is *witnessed* only at q=17 (the score-9
repair stratum); at q=11/13/19 it is merely *permitted* by the vacuous bound. The "eliminated"
labels in §5 are otherwise justified (A1 Lean rows have real files + `#print axioms`; computed
rows correctly carry the "mod solver" qualifier; B1's hardening chain C8/C37/certcheck plus the
independent raw-bitmask spotcheck all exist as claimed).

### 1.2 The witness-count heuristic report — SOUND with corrections (best artifact of the batch)

Everything numerical was verified (see §0). Corrections and cautions:

- **H1 = M5**: the "+6.5 min at q=17" claim is false as stated (q=7 is +5.901).
- **H2**: "wide, never-threatened margin" (TOTAL verdict) leans optimistic against the report's
  own logic. `mu − ln N` measures safety **under the null**, and the report's central finding is
  that the null's distributional shape is wrong (under-dispersed). The model-free numbers are
  `m_total = 5` of 157 at q=17 with `bad/total = 0.97` — the erratic-margin note's "delicate
  near-cancellation of two Θ(q²) quantities." Nothing in the data excludes a deeper dip at an
  arithmetically unlucky q. "Clears the line at every computed q, margin erratic" is the
  defensible claim; "never-threatened" is not.
- **H3 = M8** (live_on vs on-conic-P conflation in §7's closing sentence).
- **H4 (unmodeled shared randomness)**: the N_canon "trials" at fixed q share their randomness
  source — children of distinct size-3 classes land in a heavily shared set of size-4 classes,
  so class counts are functions of one common size-4 value table, not independent draws. E0 is
  a dashboard number, not a probability. The report uses it heuristically (good) but should say
  this in one sentence.
- The R² ≈ 0.48 disclaimers are adequate and no extrapolation is smuggled: §6 explicitly
  declines a TOTAL crossing and calls the ON crossing unpredictable. ("No downward trend in
  mu_total" is itself a mild trend claim from seven erratic points, but it is hedged.)
- The under-dispersion finding and its q=17 reading are correct and are the real contribution —
  see §2–§3 below for the one place its *interpretation* overshoots.

### 1.3 Claim-set R1 — SOUND as a taxonomy; three adjudications

- **Is the A/B split coherent?** Yes, with one blur the map carries into §5: "A3 ≡ B4b/B4c"
  equates a truth-mode with route-modes. They are not equivalent — they share the missing
  uniform instrument. Say "A3 is attacked by the same uniform argument that would discharge
  B4b/B4c," not "≡".
- **B3 (orbit-invariance bridge): CORRECT, and it can be sharpened.** The residual game's
  symmetry on the conic parameter line is the stabilizer of the burned pair {0, ∞} — the maps
  `t ↦ at` and `t ↦ a/t`, order `2(q−1)` — versus `|PGL(2,q)| = q(q²−1)`. Value-constancy on
  orbits is a theorem **for the stabilizer** (those are game automorphisms); it is **not** a
  theorem for full PGL(2,q), so a full-PGL bucket merges ~`(q²+q)/2`-fold more positions than
  invariance licenses. Empirics cut both ways: at q=17 the full-PGL buckets were value-constant
  where the full solve exists (C5: 273 → 10 buckets), but at q=23 exactly one representative per
  bucket was solved — constancy is untested precisely where it is load-bearing. C36's
  self-consistency gate is a related but indirect test; the direct discharge is solving a
  second, stabilizer-inequivalent representative per q=23 bucket. B3 correctly stays open.
- **Category-error claim (§2): correct** as stated; the map properly allows computation to close
  finite sub-ranges while only a q-uniform shape argument closes the conjecture.
- **Regime table / eliminated labels**: accurate modulo M3/M7 and the "witnessed only at q=17"
  flag above. A5's Segre citation (odd-q ovals are conics) is a true fact used only as
  background; the map's A5 row makes the weaker, correct claim.

### 1.4 Claim-set R2 — MIXED: R2.1/R2.2/R2.5 sound; R2.3 needs the adjudication below; R2.4
mostly refuted; R2.6 unsound as stated

- **R2.1 (which trial count): classes, and the report's refinement is right — but the two
  versions agree asymptotically.** Trapped-ness is a class event (value is constant on orbits of
  the game-preserving group, and the census group is a subgroup of it — conservative direction:
  more classes, higher threshold). Raw-position counting would multiply identical copies of the
  same event. Numerically `N_canon ≈ q²/12` (21 vs 289/12 ≈ 24 at q=17; 27 vs 30 at q=19), so
  `ln N_canon = 2 ln q − ln 12 + o(1)`: the chat's `2 ln q` was the right shape, off by an
  additive ~2.5. Materially: no verdict flips (ON at q=17 is negative under both thresholds;
  TOTAL positive under both).
- **R2.2**: correct by definition; `m_on(17) = 1` verified in the raw feat line.
- **R2.3**: see §3 — consistent with the under-dispersion finding, but both framings need the
  same repair.
- **R2.4**: the elliptic-vs-split character condition is genuine (fixed points of the induced
  Möbius involution are governed by the quadratic character of a discriminant), so a
  character-sum handle on the *matching structure* is not hand-waving. But the quantitative
  program — witness count = `q − O(√q)` via Weil — is **refuted by the data it was proposed
  to explain**: `mu_on(17) = 2.71 = 0.21·(q−4)` and `mu_on(11) = 4.25 = 0.61·(q−4)`. The
  depletion is macroscopic, not a √q defect around a full main term. Any character-sum engine
  must instead control *which q deplete* (the arithmetically irregular odd-complete-arc
  abundance) or bound `onN ≤ q−5` (at least one on-conic P survives) — a structural bound, not
  a defect bound. See §3 for the moment-tension adjudication.
- **R2.5**: Schaefer PSPACE-completeness is correctly cited and the "expect existence/involution
  proof, not a value formula" inference is reasonable prior-setting — though note the report's
  own point-mass finding *counters it locally*: for this structured subfamily the on-conic
  witness count behaves like a computable invariant of q, which is evidence that this corner is
  special. Understanding q=11 by hand remains a good, cheap idea.
- **R2.6 (ultraproduct)**: unsound as stated. Root value and escape are decided by strategies
  over plays of length Θ(q) — quantifier depth grows with q — so they are not a fixed
  first-order family and Łoś/pseudofinite transfer does not apply. Only fixed-depth facts (e.g.
  the two-ply depletion counting) transfer to a limiting object. Decorative unless someone
  exhibits a depth-uniform reformulation.

## 2. Statistical-validity audit (deliverable 2)

- **Is the Poisson null legitimate given non-independence?** As a calibration yardstick, yes —
  that is the standard use, and the report treats it that way. Two layers of dependence are
  unmodeled: within-class sibling correlation (children share geometry) and cross-class sharing
  (H4: one size-4 value table drives all classes at a q). Neither invalidates the *diagnostic*
  use; both forbid reading E0 as a probability. The report never quite crosses that line, but
  one explicit sentence (H4) would close the referee surface.
- **Is N_canon the right trial count?** Yes (R2.1 above), and the census group being a subgroup
  of the game-preserving group makes the choice conservative.
- **Is the under-dispersion interpretation correct, and does it rescue q=17?** As an *empirical
  calibration statement*, yes: the null predicts ≈1.4 trapped on-conic classes at q=17 and the
  observed distribution {1:3, 3:18} has none — the null demonstrably over-predicts zeros, and
  concentration is demonstrably what the margin-negative point survived on. What is **not**
  licensed is the forward-looking law "concentration is protective": a point mass protects only
  while it sits above 0 (variance 0 with mean 0 is *total* failure — all classes trapped
  simultaneously; under-dispersion makes the min track the mean, in both directions). The
  correct reading: concentration converts the survival condition from `mu > ln N` to
  `mu ≳ 1 + (class-to-class spread)` — a far weaker demand on the mean, but still a demand on
  the mean. See §3.
- **Are the erratic fits disclaimed strongly enough?** Yes; no extrapolation is smuggled (§6
  explicitly refuses both crossings).
- **Is the two-layer verdict the right call?** Yes — "(b) safe-but-tight, B4a warning not A3" is
  correct: `m_total = 5` at q=17 means off-conic witnesses carry the escape when the conic
  nearly empties, which is by definition a route warning, not a counterexample signal. One
  understatement (H2): the TOTAL layer's own q=17 collapse (escape 5 of 157) deserves to sit
  next to "wide margin" every time that phrase appears.

## 3. Mean vs variance — the adjudication (deliverable 3)

The sharpest way to say it: **there is no randomness here, so neither moment is a proof
target.** Every class count is a deterministic integer; "mean" and "variance" are features of a
heuristic ensemble. The proof target is per-class: `min over classes ≥ 1` — the escape statement
itself. Within the heuristic vocabulary, both sides hold half the truth:

- The report is right that the first-moment threshold (`mu > ln N`) is not what protects the
  data — q=17 ON violates it and survives — and right that concentration is the observed
  protector. It is wrong to conclude "bound the variance, **not** the mean": a variance bound
  alone is compatible with total failure (all counts 0 is perfectly concentrated). Protection =
  concentration **and** location.
- R2.4 is right that a strong-enough mean bound would suffice on its own (`mu_on = q − O(√q)`
  would clear any threshold without concentration) — but that mean bound is empirically false
  at the size-3 layer (fill fraction 0.21 at q=17). Attacking the mean with a Weil defect bound
  is attacking the right moment with the wrong main term.
- **What a concentration-based uniform argument would actually need**, shaped by the data
  (point mass at q=5,7,9,13,19; two adjacent values at q=11,17): (i) a **class-stability
  lemma** — an exchange/surgery argument transforming any size-3 class into any other at fixed
  q while changing the on-conic P-count by at most C (observed C = 2); plus (ii) an **anchor
  bound** — some computable class has on-conic P-count ≥ C+1, surviving worst-case
  arc-depletion. Note the q=17 data sits exactly at the edge (max 3 = C+1): the arithmetic is
  knife-edge everywhere, consistently. Equivalently and more ambitiously: the point masses say
  the count is essentially a *function of q* — hunt the invariant that computes it, and
  lower-bound that invariant by 1. That reframing — from moments to a class-invariance
  mechanism — is the real content the under-dispersion finding adds, and neither the chat's
  conspiracy framing nor the report's variance slogan states it.
- **R2.3 vs under-dispersion**: consistent, not contradictory — they are the same fact (strong
  structural correlation; nothing here is a random ensemble) read at opposite signs of location.
  Under-dispersion = the structural driver currently pins counts at positive values; the
  "conspiracy" = the same driver pinning them at 0 at some unlucky q. Hunting the correlation
  source (odd-complete-arc abundance, Baer/subfield structure at square/cube q) and measuring
  sibling-value correlation are the right instruments and remain cheap.

## 4. Missed / misfiled failure modes (deliverable 4)

- **Missing — B7, specification mismatch.** The taxonomy has no row for "the Lean endpoint
  definitions formalize a subtly different game than intended" (`Projective.Cap`,
  `InitialPStatement`, `GridCap` legality). B1 covers solver bugs, B2 covers links *inside* the
  chain — neither covers the endpoints. It matters because two eliminations (B5, and A1's "Lean
  rows immune") use Lean as the oracle; if the spec is off, those eliminations are circular.
  Mitigations already exist (q=5,7 Lean agrees with the computed rows; the independent
  raw-bitmask spotcheck agrees with the census), so the residual is small — but the map should
  name it, precisely because it is the one mode Lean cannot self-certify.
- **Stale-open (should be closed):** B2's "5-arc non-degeneracy for every size-3" — already a
  Lean theorem (M2).
- **Mislabeled:** q=3 as "computed (mod solver)" — it is vacuously Lean-eliminable (M7); q=27
  under the Baer rationale (M6).
- **Wrongly-closed:** none found. A3 and B3 correctly stay open; B4d's death (C27/C28) and the
  non-decomposition B4c are correctly recorded.

## 5. Bottom line (deliverable 5)

The batch **improves** the D1/D3 framing: the trapped-size-3 statement of the conjecture, the
elimination-over-shapes-not-over-q section, and the two-layer heuristic with the
under-dispersion observation are exactly the kind of scaffolding a referee wants to see, and the
novelty guards are respected throughout (Tao-style heuristic labeled as such; structured
finite-incidence subfamily, no new-game-class claim; Nofil/pairing/involution prior art already
mapped in the framing docs). What a referee would attack, in order: the "proven ⟺" (M1 — fix the
wording, or better, formalize the converse: it is one transitivity-transport lemma away and
would make a future found-trap self-certifying); the checkable numeric slip (M5); "provably
cannot exist" (M3); "underwritten by the reservoir" (M4); and any residual reading of E0 as a
probability (H4). All are wording-level fixes except the optional converse formalization — none
threatens the program's direction, and the proven direction (falsity ⇒ trapped size-3) is the
one the elimination scaffold actually stands on.

**Single highest-value next action implied by this work:** exploit the point-mass finding — run
a C36-style type-alignment at the size-3 → size-4 **on-conic child** layer over the existing
feat data (free; the per-child `X … val= pos=` lines are already on disk for q=5..19). Concretely:
key each on-conic child by the stabilizer-orbit type of its 6-point parameter configuration
(S3 ∪ {child} ∪ {0,∞} on the conic parameter line) and test whether P/N is a function of that
type within and across q. If it is, the under-dispersion is *explained*, the on-conic witness
count becomes a computable invariant, and the uniform (ON) lower bound turns into a finite-type
problem — the same shape as the C36 gate, one layer down, at zero compute cost. (Runner-up: the
B3 discharge — solve one stabilizer-inequivalent second representative per q=23 bucket — which
must land before q=23 is cited as more than conditional evidence.)

— Fable
