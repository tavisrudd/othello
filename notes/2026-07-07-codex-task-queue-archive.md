# Codex task-queue archive

Companion log to the live registry
[`2026-07-07-codex-task-queue.md`](2026-07-07-codex-task-queue.md). Everything below was moved
here **verbatim** on 2026-07-11 during the live-map / companion-log cleanup pass (the live doc keeps
only the current-state map; completed write-ups, dated logs, and the amendment trail live here).

Archived blocks keep their **original relative link depth** — this archive sits in the same `notes/`
directory as the live doc, so every relative link (`<file>.md`, `handoffs/…`, `data/…`, `../…`)
resolves identically to how it did in the live doc. No links were rewritten.

**Lane pegs.** Every *task entry* carries its lane alias after the ID — `## C12. `[cap]` …` for the
C1–C74 write-ups, `- **C99 `[baer]` …` for the row-form entries — using the aliases in CLAUDE.md
§ Lane routing. The dated `## <date> C77 continuation — …` **session-log** sections are deliberately
*not* pegged: they are progress logs for a task whose row is pegged already, so a peg here would be a
second copy of that fact, free to drift from the first. The task entry is where a lane is recorded.

## Archived 2026-07-11 from the live queue

Block groups moved (all verbatim, in original file order, contiguous below):

- **Priority-ordering snapshot — "CURRENT TOP OF QUEUE" (ninth–twelfth pass) + Cluster/lane bullets.**
  Why archived: the verbose per-task REPORTED write-ups that had accreted into the priority view; the
  live doc now carries a compact CURRENT TOP OF QUEUE plus one-line pointers instead.
- **"Original ranking + amendment trail (history/context)" — the Fable Nth-pass reorderings.**
  Why archived: dated priority-reordering / queued-reported-gated bookkeeping, i.e. history, not
  current state.
- **Full task write-ups C1–C74** — every REPORTED / NEGATIVE / NO-GO / DONE / closed task body, plus
  the untagged bodies subsumed by later work (C14, C15, C22) and the `## Standing` note.
  Why archived: completed or superseded work; the live doc keeps a one-line pointer only where a body
  still anchors a live frontier (A5, Cluster 2, C74 residue, C30, C13, C16, C56, opportunistic lanes).

Everything from the `---` below is the verbatim moved content.

---

## Priority ordering (Fable, 2026-07-09)

### CURRENT TOP OF QUEUE (2026-07-09, ninth pass — consolidated; START HERE)

The amendment trail below is history/context; THIS list is the operative ordering for open
tasks.  Two proof-lane clusters lead, then the independent lanes.

**Completed route-deciding measurement:**

- **C65 [REPORTED 2026-07-09]** — exact witness `Z=40`, full-C31 interval `40..136`;
  immediate repair cost 40 descends to child Z=7.  Route verdict: amortized potential primary,
  small-Z retained as the post-repair terminal layer.

**Cluster 1 — the arc-depleted-orders dichotomy (the (ON) route's load-bearing unknown).
All three static mechanism candidates (C55 group / C64 extremal / C69 algebraic) are now REPORTED
NEGATIVE (2026-07-10, Claude) — no static config→value dictionary *found*, so the mechanism search
is DE-PRIORITIZED in favor of A5 (see the Cluster-1 status note below for scope limits and the
re-entry condition; this is "not found," not "impossible"):**

2. **C55 [REPORTED 2026-07-10 — NEGATIVE]** — d-lattice side-switch (group-side mechanism
   candidate).  No differential between the 119 flipping configs and matched controls on either
   instrument (abstract C18 involution-product dictionary; actual legal-intruder secant skeleton);
   the within-order test reverses the prediction (q=11 N children carry MORE secants than P).
3. **C64 [REPORTED 2026-07-10 — NEGATIVE]** — completion poset (extremal-side mechanism candidate;
   run beside C55).  No completion-spectrum property is constant-within-{11,17}/{13,19} and
   differs-across while separating flip from control; `has_odd=has_even=True` for every config at
   every order, so the value lives in the full tree, not the terminal maximal-arc layer.
4. **C56** — group-indexed type alignment.  GATED on a C55 positive → **C55 NEGATIVE, so C56 stays
   closed-gated; do not start.**
5. **C69 (promoted S1) [REPORTED 2026-07-10 — NEGATIVE]** — envelope invariants
   (algebraic-geometry-side mechanism).  Tangent envelope provably non-discriminating; the genus-2
   hyperelliptic arithmetic (trace `a2`), residual tangent/secant partition, and χ of Igusa-flavored
   resultants all fail the flip/control discipline.  The near-hit (`a2=0` for all N-flip configs at
   q=11) is a q=11 small-field artifact that dissolves at q=17.  **All three configuration-level
   dichotomy mechanism candidates (C55 group / C64 extremal / C69 algebraic) returned NEGATIVE on
   the tested families.**

**Cluster-1 status (2026-07-10): mechanism search DE-PRIORITIZED in favor of A5, not closed as
impossible.** No *static* config→value dictionary was **found** among the tested group-side,
extremal-side, or algebraic-side families; the search is de-prioritized, not proven empty.  Two
scope limits are on record and keep this a "not found," not a "does not exist": (i) every
discriminator was tested only at q ∈ {11, 17} (the two arc-depleted orders) against {13, 19}, so an
invariant that only separates at a *larger* arc-depleted order would have been invisible; (ii) both
near-hits (C64 count-parity, C69 `a2=0`) were q=11 small-field artifacts that dissolved at q=17 —
which validates the flip/control discipline but also shows how thin the two-order corpus is.  All
three candidates tested *static* invariants of the 6-point configuration; the one remaining angle
was a *dynamic* discriminator (Cluster 2's Ψ — the C63 amortized potential postdated all three
candidates, per the "levers compound" rule), now **tested NEGATIVE** (Correction 3, see the
re-entry condition below).  **Pivot, not dead end:** the (ON) uniform route
now engages the q-dependent **A5 arc-depletion arithmetic** directly (which orders deplete, by how
much).  Note A5 *is* still the dictionary question — just answered q-dependently rather than by a
config-side invariant; if A5 surfaces a specific quantity, re-open the mechanism search to test it
as a config invariant.  **Re-entry condition:** reopen Cluster-1 mechanism hunting only if (a) A5
arithmetic names a concrete quantity to test as a config invariant, or (b) a larger arc-depleted
order (q ≥ 23) becomes available to widen the two-order corpus.  ~~(c) a *dynamic* discriminator (Ψ
trajectory) separates flip from control~~ — **TESTED 2026-07-10, NEGATIVE** (Fable steering
Correction 3, [`2026-07-10-psi-dynamic-flip-probe.md`](2026-07-10-psi-dynamic-flip-probe.md)):
coupled Ψ features (defect/intruders/xor) are identical flip vs control at every order; the only
separation is the within-order reservoir/zone-size term C55 already saw, not a cross-q mechanism.
**The mechanism sweep is now complete on both fronts — static (C55/C64/C69) and dynamic
(Correction 3) all negative.**  No fourth static candidate is queued; the live (ON) levers are the
open-core / amortized-potential lane (Cluster 2) and A5 itself.

**Cluster 2 — the open core (Good-closure / maintenance / termination).  Post-C65 emphasis
(tenth pass): the amortized-potential lane is PRIMARY per C65's route verdict:**

5. **C63 [REPORTED 2026-07-10; ROUTE AUDITED 2026-07-10]** — potential LP-fit + infeasibility
   dual.  Post-repair descent depth was already included in v1 and returned the exact but
   proof-circular solution `Phi=descent_depth`; the proof-admissible output is still `Psi`.
   Post-C61 audit rules out amortizing an immediately N-valued geometric reply over a later pair.
   Do not refit until a value-blind selector maintains the candidate Good class or a genuinely new
   proof-admissible coordinate is supplied.
6. **C62 [REPORTED 2026-07-10]** — selector-library scoring (hours, no new solves — run alongside C63; a scoring hit
   doubles as a C63 feature).
7. **C61 [REPORTED 2026-07-10 — NEGATIVE for tested quotient]** — finite-state reply automaton.
   The coarse defect/interface/zone table has many conflicts; six q=17/q=19 conflicts survive the
   full C36-style normalized-coordinate refinement in the genuinely forced-reply corpus (each node
   has exactly one P child).  The tested q-blind lookup table therefore fails before adversarial
   replay.  The six pairs localize the needed order-sensitive interface refinement; `Psi` remains
   the charge target.  **q=19 hard-surface follow-up (2026-07-10):** the 12 fixed-C31 `Psi`
   failures at the single ply-4 parent all admit the same internal repair signature
   (`live=6`, three defect components, nonzero xor, `Delta Psi=-42..-41`). Seven simple families
   cover all 12 existentially, but none of the original families is tie-safe on all 12 (`psi_min`
   safe on 8, `zero_xor_live_min` on the complementary 4).  **Tie-coordinate resolution:** the
   sorted local zone-conflict-ray profile closes all 12 with `zero_live_ray_lex_max`, but full replay
   at q=13/17/19 is uniform-negative: deterministic purity rises sharply while existential P-hit
   coverage falls, with a minimal failure already at a q=13 ply-4 root.  Close as local positive /
   uniform negative; do not broaden the selector search from this result. Report:
   `2026-07-10-codex-q19-psi-selector-hard-surface.md`.
   **Successor framing (Fable eleventh pass, 2026-07-10):** retire deterministic-selector variants —
   do not queue another argmin rule.  The successor target is **existential and q-varying**:
   characterize the algebraic set of admissible `Psi`-decreasing replies and prove it nonempty —
   i.e. the proof-shape census's S11 geometric-selector lemma (failure of the top-k candidates
   forces ≥ c independent incidence coincidences), which C61's six forced conflicts *support*
   rather than refute (they kill q-blind lookup, not a q-varying realization of one finite-field
   formula).  C62's existence pass already holds on all 2,622,214 q=19 obligations including the
   12 hard rows.  Operational first step = the census's cheap kill-test: a fixed top-k rule
   (k ≤ 4, e.g. zero-xor candidates in `live_on`-sorted order) over the existing q=19/q=23
   maintenance artifacts, recording the incidence description of every candidate failure — the
   failure-rigidity data the compression ledger needs.  See C70 (the exact collision charge) for
   the coordinate this selector should descend.
   **Kill-test outcome (Codex round 2, 2026-07-10):** the predeclared kill-set-sorted top-k rule
   (k ≤ 4) is exact at the q=19 root (k=4: 148/148) but **REFUTED at q=23** — 11 exact
   all-N-top-four failures among 1,091 maintenance obligations (first P replies at ranks
   6/10/13/27; the decisive class has three isolated live conic vertices where the only known P
   reply deletes all three).  Neither D-empty-first nor min-|K| is a uniform bounded selector.
   The residual is rigid (7 incidence classes; 8/11 under one follower) → the route is
   **generic discharge + explicit exception classes**, NOT another bounded argmin.  See the
   round-2 umbrella bullet below; script `rust/scripts/r2_killset_topk.py`.
8. **C70 [REPORTED 2026-07-10 — items 1–2 POSITIVE (exact formulas), items 3–5 NEGATIVE]** —
   exact reservoir-slack collision charge.  The exact per-cell collision multiplicity
   `M = E + delta0col` is derived and machine-verified (935,702 states, 0 exceptions), with
   `R_code = max(0, M − g(q,k))` and `g(q,k) = max(0,(q−k)(C(k,2)+1+k−q))` **deterministic in
   (q, ply)** — the truncation was masking a forced collision *drift*, not a q-sensitive reply
   discriminator.  Move-pair form `ΔM = −|K_u ∪ K_v| − [F(k+2)−F(k)]`: the only move-dependent
   part is the kill-set union `|K_u ∪ K_v| = −Δzone_v`.  Consequences: `M` is `zone_v` + a ply
   potential (C63 already excluded that as trivially monotone); it provably cannot vary across
   replies at a fixed obligation, so the q=19 hard surface only relocates under refit (12 → 10,
   four new parents) and the C61 successor is NOT advanced.  Do not promote `Psi_exact`; keep
   truncated `Psi`.  **Convergence with C71:** the only reply-varying quantities left in either
   half of `dPsi` are kill-set incidences (`|K_u ∪ K_v|` here; the `D(z)` gate for `dC` in C71)
   — the existential selector lemma (item 7 successor framing) should be stated over kill-set
   incidence data.  Report:
   [`2026-07-10-codex-c70-collision-charge.md`](2026-07-10-codex-c70-collision-charge.md);
   script `rust/scripts/c70_collision_charge.py`.
9. **C71 [REPORTED 2026-07-10]** — three-involution transition theorem.  Verdict: the third
   intruder's after-skeleton is NOT a function of center-triangle geometry (labelled-embedding
   coordinate missing); coefficient check positive (`dPsi = dReservoir + 6·dC − 4 − 2·dXor0`
   exactly).  See §C71 below and `2026-07-10-codex-c71-third-intruder.md`.

**A5 lane — arc-depletion arithmetic (now the sole live (ON) mechanism route).**  With the
config-mechanism sweep complete (static C55/C64/C69 + dynamic Correction 3, all negative), A5 is the
only surviving (ON) mechanism angle — and until now it carried no task ID.  Complementary to the
open core, not competing: even a resolved 12-state hard surface still needs A5's anchor, so do NOT
elevate A5 above Cluster 2; C68 is cheap enough to just run alongside.  Note A5 is stated at the
oval/complete-arc incidence level, which C58's all-P order-9 result *strengthens* rather than
disturbs (the depleted orders {11,17} are primes, where the non-Desarguesian planes do not even
exist, so the dichotomy data is untouched).

- **C68 [REPORTED 2026-07-10 (Claude); q=25 UPDATE 2026-07-10]** — the depletion-fraction extremal
  sequence `D(q)` (sweep E2).  Exact result: `D(q) = 0` at every non-arc-depleted order
  (5,7,9,13,19,23,**25**; min-witness = q−4) and `D(q) > 0` **exactly** at `{11,17}` (`5/7`, `12/13`).
  The knife edge **sharpens** along the depleted subsequence (min-witness `2 → 1`, margin `2 → 1`);
  it recovers only at non-depleted orders.  So "`D(q)` bounded away from 1" is **not** supported — but
  the (ON) route only needs **min-witness ≥ 1**, i.e. the A5 target `maxonN(q) ≤ q−5` (no size-3
  class has all q−4 on-conic children N).  **Decisive missing datum resolved (2026-07-10, C44's
  q=25 census): `D(25)=0`, `min-witness(25)=q−4=21` (full) — the `2 → 1 → ?` slide does NOT continue
  at the first square order; it rebounds fully.**  Report:
  [`2026-07-09-codex-depletion-fraction.md`](2026-07-09-codex-depletion-fraction.md); script
  `rust/scripts/c68_depletion_fraction.py`.  **A5 lane: the min-witness bound holds at every tested
  order through q=25; the open task is now the A5 arithmetic proof of `maxonN(q) ≤ q−5` for all
  depleted q, and finding a genuinely depleted order beyond {11,17} to extend L's stress test
  (C74 §6 — q=25 was non-depleted so "non-depleted ∧ L-fails" was vacuously impossible there).**
- **C68 follow-on — N-bucket density `ν(q)` [2026-07-10 (Claude); q=25 UPDATE 2026-07-10]** —
  bucket-level image of `D(q)`. Exact on-conic bucket census (`s4arena --all`): **`ν(q)`**
  (state-weighted N-fraction) `= 0` off {11,17,**25**}, `0.357` (q=11), `0.791` (q=17) — positive &
  ~doubling across the two depleted orders; #N-buckets `1 → 5`. Null model
  `E[fully-N classes] = ncls·ν^(q−4)`: `0.006` (q=11) but **`1.000` (q=17)** vs 0 observed, so
  **min-witness ≥ 1 is a MARGINAL suppression at q=17**, at the random-failure threshold. **The trend
  DOES NOT continue past q=17: `ν(25)=0` (28/28 on-conic buckets P, 2026-07-10) — the doubling breaks
  at the first square order rather than pushing min-witness to 0.** A5 should still bound the extremal
  class-type where it matters ({11,17}), not lean on q=25 as further evidence of an adverse trend —
  q=25's contribution is a clean non-depleted point, same shape as {13,19,23}. onP is bimodal (few PGL
  class-types; min-witness = extremal-type count); value separates cleanly by bucket fiber size (P =
  rare/special, N = generic) at the depleted orders → **A5 lead: every 5-point frame admits a special
  (P) completion.** Report:
  [`2026-07-10-codex-a5-nbucket-density.md`](2026-07-10-codex-a5-nbucket-density.md); script
  `rust/scripts/c68b_nbucket_density.py`.
  **q=25 resolution (2026-07-10, census COMPLETE):** the full `s4arena --all` census closed all
  28 on-conic buckets **28/28 P** ⇒ **`ν(25)=0`, `min-witness(25)=q−4=21` (full)** — the R7-decider
  `f_10=P` (min-witness ≥ 4) is subsumed by the full-P result; the min-witness slide `2 → 1`
  REBOUNDS fully at the first square order (not merely arrested), and q=25 joins the non-depleted
  set `{5,7,9,13,19,23,25}`.  The A5 anchor `maxonN(q) ≤ q−5` holds at q=25 with margin; the
  A4/Baer square watch is retired short of q=49; the open A5 arithmetic question shifts to **which
  orders beyond {11,17} deplete at all** (next candidates among q = 29, 31, …).
- **C72 [REPORTED 2026-07-10 — NEGATIVE (read b), with a partial-identity gift]** — PGL
  permutation-module / Johnson-scheme decomposition of the on-conic value function `f_q`.  A
  **concentration instrument** for the link-sum near-point-mass (`onP(A) = Σ_{x∉A} f_q(A∪{x})`,
  dispersion ≤ 0.4 — the §6 class-stability target), NOT a fourth config→value dictionary; Cluster 1
  stays closed.  Result: **no harmonic identity forces near-constant link sums.** At the depleted
  orders `f_q`'s spectral mass sits in the *top* Johnson components (j ≥ 4) and migrates UP with q —
  top component `V_6` share `0.079` (q=11) → `0.726` (q=17); `V_0` share `= 1 − ν(q)` collapses
  `0.64 → 0.21`.  Flip/control fails for any low-component reading (q=11 signature dissolves at q=17,
  the C64/C69 lesson).  The concentration of `onP` is an artifact of the link operator `W_{5,6}`
  discarding the dominant (link-invisible) `V_6` mass, not of `f_q` being low-degree — spectral
  corroboration of C42.  **Partial gift for A5:** PGL 3-transitivity gives the exact q-uniform
  identity `f_q ⊥ V_1 ⊕ V_2 ⊕ V_3` (kills the three highest-leverage `onP`-variance terms), reducing
  the class-stability lemma to bounding the `V_4 ⊕ V_5` mass — but that mass is arithmetic
  (arc-depletion), so A5 still owns the anchor `maxonN(q) ≤ q−5`.  q=13/19 controls (all-P, trivially
  100% `V_0`).  Report:
  [`2026-07-10-codex-c72-fq-decomposition.md`](2026-07-10-codex-c72-fq-decomposition.md); script
  `rust/scripts/c72_fq_decomposition.py`.  Spec §C72 below.
- **Codex round-1 theorem frontier (2026-07-10; reviewed + independently verified by Fable):**
  [`2026-07-10-codex-odd-plane-round1-report.md`](2026-07-10-codex-odd-plane-round1-report.md) —
  PROVED: the involutive-completion lemma (≥2 of 3 pairings per distinguished point; 15
  constructions per five-frame); the fiber–stabilizer identity `fiber(B) = 30(q−1)/|Stab(B)|`
  (small fiber = large stabilizer, exact and uniform — reproduces the committed q=25 histogram
  6/120/180/360/720; the size-6 bucket is the Baer subline `P¹(F₅)`, stab `PGL(2,5)`); and a
  **capacity proof of the q=17 (ON) statement from bucket stabilizers** (15 > q−4 = 13; N buckets
  ≤ C2) — the first structural explanation of the knife edge.  No traction at q=11 (the V4
  N-bucket absorbs exactly 3×5 = 15 — the XHIST saturates it) and none at q ≥ 19 (q−4 ≥ 15), so
  it is explanation, not leverage, until the family grows.  REFUTED: stabilizer-specialness ⇒ P
  (the q=11 N bucket `{∞,0,1,2,3,4}` has V4; the value-blind involutive selector misses every P
  child on the q=11 extremal row) — this **breaks the C68b "P = rare/special" lead as an
  implication**; special may not be defined via stabilizers.  FOUND (post-hoc, labeled as such):
  the q=17 **secant packet** — exactly the three knife-edge classes have all five P escapes on
  ONE line, the secant through the unique on-conic witness (no other q=17 class, none at q=11),
  which explains the C44 rider's co-depletion finding: the off-conic pivot layer at q=17 is
  parasitic on the on-conic witness.  Its two recommended routes are queued as **C73/C74**
  (twelfth pass):
- **C73 [REPORTED 2026-07-10 — POSITIVE]** — value-blind secant-packet theorem.  `L(A)` =
  max-legal-incidence frame-point/on-conic candidate secant is a value-blind selector that uniquely
  reproduces the q=17 packet (3/3 extremal) and whose line carries a P escape in all 68 classes at
  q∈{11,13,17,19} (0 failures; q=17 base rate 49% → 100%, so meaningful).  On-conic form 21/21 at
  q=17 but 6/8 at q=11 (misses the 2 knife-edge classes).  **Failure gate 2 refuted** — incidence
  recovers the P witness (pivot NOT witness-anchored at q=17).  Recursion lemma tested (existence),
  not proved (game-value reduction needs the tree).  **q=25 out-of-sample test CLOSED BY CENSUS
  (2026-07-10):** the on-conic census is all-P (28/28), so there is no extremal N class at q=25 —
  the ON form is vacuously safe (its predicted fragility had no class to fail on) and the ESC-form
  concurrence solve is decision-moot (per C74 §6, "non-depleted ∧ L-fails" is logically
  impossible).  Sole un-scored residual: the round-2 `(1:15:9)` off-conic concurrence point (not
  covered by the on-conic census) — optional selector-existence datum, no longer decision-bearing.
  Report: [`2026-07-10-codex-c73-secant-packet.md`](2026-07-10-codex-c73-secant-packet.md).
- **C74 [REPORTED 2026-07-10 (Codex round 2; verified by Fable) — structure PROVED, stabilizer
  gate CLOSED with proof, recursion target sharpened]** —
  [`2026-07-10-codex-c74-capacity-family.md`](2026-07-10-codex-c74-capacity-family.md).
  **Line-pencil theorem [PROVED]:** normalize `L(A)`'s endpoints `(F,w) → (0,∞)`; the off-conic
  cells of the secant are the involution pencil `τ_a(t) = a/t`, the illegal ones exactly
  `a ∈ P2(U)` (pair products of the other four frame points), so `nlegal = q − d(F,w)` with
  `d = |P2(U)| ∈ {4,5,6}` — `L(A)` is exactly the minimizer of pair-product collisions.
  **Supply ledger [PROVED]:** the round-1 fifteen involutions distribute `h(4)=3, h(5)=1,
  h(6)=0` per line — `L(A)` maximizes the local share of the 15-unit supply.  **Tie theorem
  [PROVED]:** `d=4` lines biject with the involutions of `Stab(A)` (count 0,1,3,5; zero ⇒
  exactly fifteen tied `d=5` lines) — retro-explains every C73 tie count incl. the q=11
  knife-edge (D10 ⇒ five tied lines) and q=17's 21/21 uniqueness.  Verified by Fable:
  `c74_line_pencil.py` gives supply=15 on all 68 classes, min/tie hists match the report
  verbatim, and the fan matrices regress to round-1's `M_11`/`M_17` exactly.  **Stabilizer
  barrier [PROVED]:** every legal pencil center is NON-stabilizing (stabilizing centers are
  exactly the illegal `P2(U)` cells), and ANY family counting automorphisms of one-point
  completions has total supply ≤ 838, O(1) in q — the Ω(q)-via-stabilizers gate is unreachable.
  **C74's residue = a game-value N-absorption bound for the explicit one-intruder pencil**
  (report §5: prove `IsP(A∪{w})` or `∃ a ∈ F_q^* \ P2(U): IsP(A∪{z_a})` — one-intruder states
  with explicit `τ_a`, i.e. the Lemma-V/VI classified matching layer coupled to the zone; the
  q=11 knife-edge's mixed 4P/2N pencil pattern is the mandatory base obstruction).
  **Label-blind q=25 matrix [COMPUTED-EXACT, verified]:** 8 five-set orbits; with the census's
  disclosed `f_0..f_6 = P`, rows 0–6 already have ≥ 4 witnesses and the sole open row is
  `R7 = {10:6, 14:3, 16:6, 17:6}` ⇒ **min-witness(25) = 0 or ≥ 3 — the `2 → 1` slide cannot
  continue gently.**  Pivot = bucket 14: `f_14=P` ⇒ ON passes at R7; `f_14=N` with one of
  10/16/17 P ⇒ ON survives but `L`'s ON form fails and its ESC form is the decisive independent
  test; all four N ⇒ ON refuted at q=25.  The "non-depleted ∧ L-fails" cell is logically
  impossible.  Original spec §C74 below (its stabilizer-family gate is superseded as above).
  **Dichotomy RESOLVED — CENSUS COMPLETE (2026-07-10): `f_10=f_14=f_16=f_17=P` ⇒ `R7=21`, so
  `min-witness(25)=q−4=21` (full), NOT merely ≥4 — the full rebound branch.  (ON) survives q=25;
  every R7 bucket is P, so `L`'s ON form has no extremal class to fail on (vacuously safe).  The
  off-conic `(1:15:9)` concurrence point remains an optional, decision-moot scoring datum.**
- **Codex round-2 umbrella report (2026-07-10; verified by Fable):**
  [`2026-07-10-codex-odd-plane-round2-report.md`](2026-07-10-codex-odd-plane-round2-report.md) —
  beyond the C74 results above: (i) the **R2-2 kill-set top-k refutation** (recorded at the item-7
  successor framing above); (ii) **tied-line concurrence** [post-hoc value correlation, NOT
  promoted]: the tied `d=4` max-incidence lines of a class concur at ONE value-blind legal
  off-conic point, and that common point is exact **P in 10/10** labeled tie families — including
  both q=11 knife-edge classes (common points `(4,5)`, `(9,3)`), which closes C73's ON-form gap
  at the *selector-existence* layer without resurrecting symmetry ⇒ P; frozen out-of-sample
  prediction: q=25 R7's three max lines concur at the Veronese point `(1:15:9)`, **predicted P**
  before its label exists (verified concurrent + legal, label-blind); (iii) **(L_forall)** named:
  "every maximum-incidence candidate secant carries a P child" — the strong C73-tested form
  (68/68), implies the conjecture, logically independent of (ON), and the more robust localized
  anchor given the q=25 0-or-≥3 dichotomy — now resolved to the rebound branch (census all-P).
  **Census update (2026-07-10):** buckets 10/14/16/17 are all P (R7=21 all-P), so the on-conic
  half of the q=25 targeted unblind is closed; the only un-scored piece is the off-conic
  concurrence point `(1:15:9)` (predicted P, verified concurrent+legal label-blind — its game
  value is not settled by the on-conic census).  **Recommended round 3:** the legal
  involution-pencil lemma (high proof effort — value-blind Good class over `a ∈ F_q^* \ P2(U)`
  with labelled second-intruder kill maps); the optional `(1:15:9)` off-conic scoring (selector-
  existence datum only, decision-moot); the 7-class q=23 exception analysis (discharge + exceptions
  form).  Scripts `rust/scripts/c74_concurrence.py`, `r2_killset_topk.py`.

**Independent lanes (parallel; pull when unblocked):**

- **C30** — generated-checker refactor → q17/q19 Lean assembly (engineering, long-running).
  The v5 full q17 canonical build now projects above 21.5 h sequential, tripping the task's
  explicit ~10 h user-launch gate; do not launch it implicitly.
- **C43 [REPORTED 2026-07-09 — `PG(4,3) = P`]** / **C44 [REPORTED 2026-07-10 — q=25 census
  COMPLETE, 28/28 P, not depleted]** — the former even-dimensional evidence vacuum is closed by
  the first direct P datum; the q=25 on-conic census is **DONE** (`s4arena --all --log2 29`, all
  28 full-`PGL(2,25)` buckets P, 0 N, 0 aborted, ~6.67 h / 8 GB).  **`D(25)=0`,
  `min-witness(25)=q−4=21` (full), `ν(25)=0`** — the C74 dichotomy landed on the REBOUND branch:
  the `2 → 1` knife-edge slide across `{11,17}` rebounds fully at the first square order and
  **(ON) survives q=25**; q=25 joins the non-depleted set `{5,7,9,13,19,23,25}`.  No open census
  payload remains (`ν(25)`, buckets 14/16/17 all resolved P; the off-conic `(1:15:9)` concurrence
  point is an optional post-census scoring datum, decision-moot per C74 §6).  C43's optional
  follow-up is strategy extraction, not another sizing run.  **Next A5/compute lane: the
  next-depleted-order hunt (q=29, 31) — SIZED 2026-07-10 (Claude): q=29 = 42 buckets, largest
  ~460–540M positions ⇒ ~16 GB / ~15–25 h single-core, over the 8 GB & 8 h q=25 budget; no residue
  predicts depletion, so the census is the only direct test.  Requires an explicit user gate — see
  the handoff's q=29 sizing entry.**
- **C58 [REPORTED 2026-07-10 — all-P (Claude)]** — cap game on all four order-9 planes
  (`PG(2,9)`, Hall, dual Hall, Hughes).  All four are **P** (first-player loss); the four planes are
  pairwise non-isomorphic (distinct complete-arc spectra), so the odd-plane P-property is invariant
  across the order-9 family — Desarguesian and non-Desarguesian alike.  No N geometry (no
  falsification, no "conjecture is about Desarguesian structure" verdict); the payoff is the reverse
  constraint: the P-property is Desargues-independent at order 9, so conic localization is
  Desargues-specific *scaffolding* rather than the load-bearing mechanism.  Value does not separate
  Hall from its (non-isomorphic) dual.  Standalone incidence-input solver built (the coordinatized
  grid solver cannot represent non-Desarguesian planes); PG(2,9) calibration reproduces the known P.
  Report: [`2026-07-09-codex-order9-planes.md`](2026-07-09-codex-order9-planes.md).
- **C59 [REPORTED 2026-07-10 — POSITIVE import]** — exact arc-to-conic terminal bounds.  Every
  terminal is the full conic (`q+1`) or is at most the strongest applicable integer
  Ball–Lavrauw/Voloch bound `B(q)`; the exact formula is retained by arithmetic type.  Existing
  solved S4 DAGs pass the required terminal-profile gate at q=11,13,17,19, and sourced spectra pass
  at q=23,27,29.  Kestenband gives a non-conic arc at odd-square q; completing it gives a non-conic
  complete arc in a bounded interval, not a sourced exact terminal size.  Extends C46/C47; not a
  `Good`-closure or a value theorem. Report:
  [`2026-07-10-codex-arc-stability-import.md`](2026-07-10-codex-arc-stability-import.md).
- **C50 [REPORTED 2026-07-10 — tiny PASS / literal-scale NO-GO]** — reflected Grundy-book
  semantics and 3×3 queens prototype landed in Lean (`grundy=2`, standard axiom gate). n=4
  passes; n=5 hits the default 200k-heartbeat limit at only 308 nodes. Replace linear literal
  lookup with an indexed/chunked checker before building a C35 adapter. Report:
  `2026-07-09-codex-grundy-cert-format.md`.

**Opportunistic / diagnostics:** C57 (zone quasi-randomness), C60 (Singer-model probe), C49
(piece nimber tables), C23/C40 (viz lanes), **C66** (grid-terminal spectrum), **C67**
(coupling-defect spectroscopy).

**C66/C67/C68 triage gate DISCHARGED 2026-07-10** (all of C61–C65 REPORTED): C68 promoted to the A5
lane and now **REPORTED 2026-07-10**; C66/C67 stay un-gated but opportunistic (pull as diagnostics,
no priority).

---

### Original ranking + amendment trail (history/context)

C-numbers are IDs, not priority — use this ranking. It reflects the line-capacity review and the
S4-query exploratory pass. Three tracks run in **parallel** (exploratory math+query / engineering /
writing); items within a track are ordered, and across tracks pull whatever is unblocked. Key
dependencies: C37 is cheap insurance that de-risks every result that trusts computed values (run it
early); C33 reframes the steering lane, so do it before more steering effort; C35 (nimber oracle)
is the biggest build and sharpens C38 — start it in parallel because it is long.

- **Tier A — do first (cheap, de-risking / corrective):**
  1. **C37** — shared-key agreement. Half-day; a scaled soundness check on `canon()` and hardens
     the D4 verification story. Insurance before trusting anything downstream.
  2. **C33** — act on the line-capacity review. Cheap; corrects framing that currently misdirects
     the zone hunt and reframes the steering lane.
- **Tier B — high-value, start next / in parallel:**
  3. **C36** — cross-q combinatorial-type value alignment. Free (existing P/N oracle); localizes
     the entire uniform-theorem obstruction to a finite list. The single most proof-relevant query.
  4. **C35** — nimber (Grundy) oracle. Biggest build, highest leverage; the instrument that turns
     the conic⊕zone coupling from *assumed* into *measured*. Start the build in parallel.
- **Tier C — ongoing independent tracks (unblocked, parallel):**
  5. **C30** — route-C cert books q=17/19 (engineering; D4 ladder → unconditional PG(2,17/19)).
  6. **C34** — D1 outcome-classes manuscript skeleton (writing; flag-planting paper).
- **Tier D — after Tier B reshapes the picture:**
  7. **C38** — tablebase strategy distillation (forced-move skeleton; richer once C35 lands).
     **Reported 2026-07-09.**
  8. **Steering follow-up** — repair-intruder existence lemma + small-`Z`/empty-conic base law
     (the proof lane; reframed by C33, informed by C36/C38).
- **Tier E — opportunistic bonus:**
  9. **C39** — remoteness/suspense dynamic monovariant. **Reported 2026-07-09.**
  10. **C40** — oracle-driven winline generation (feeds C23 viz).

**Amendment (Fable, 2026-07-09 second pass — counterexample-readiness additions.)** The frontier
re-review found the plans pressure the conjecture-true direction hard (steering, maintenance,
certificates) but are thin on being *ready for a counterexample* — certifying one, and probing where
the most plausible one lives. Four additions:

- **C41** — trap ⇒ N converse in Lean. Joined **Tier B, before C34** and is now **REPORTED
  2026-07-09**: D1 may use the certified "conjecture false ⟺ trapped size-3" framing modulo the
  usual Lean/spec-match caveat.
- **C42** — fixed-q census propagation. Joins **Tier B, immediately after C36**. Rescoped
  2026-07-09 after the on-conic child type-alignment report: within-q type-determinism CONFIRMED,
  q-independent type→value dictionary REFUTED (flips exactly at the arc-depleted q ∈ {11,17}) —
  the surviving task is the fixed-q census/class-stability measurement; the anchor half merges
  into arc-depletion arithmetic (A5). **Reported NEGATIVE same day:** the census is non-uniform
  even at the all-P orders (12/12 and 27/27 distinct vectors at q=13/q=19); no propagation
  mechanism exists, and the (ON) uniform route rests entirely on A5.
- **C43 [REPORTED 2026-07-09 — `PG(4,3) = P`]** — joined **Tier C** as the independent compute
  lane and supplied D1's first direct even-dimensional odd-`q` outcome.
- **C44** — GF(25) prime-power path + q=25 Baer bucket census. Joins **Tier C after C43**: the
  falsification map's top A4 watch, previously orphaned with no task ID.

**Amendment (Fable, 2026-07-09 third pass — publishable-constraint additions):**

- **C45** — game-valued defect-skeleton refinement and **C46** — t-ply depletion inequality
  ladder: both join **Tier C** (proof/writing track, independent of the compute lanes). 2026-07-09
  literature correction: the raw two-involution/conic-arc spectrum overlaps Coolsaet-Sticker, so
  C45 is publishable only as a Grundy/dynamic-reply refinement; C46 should use those finite-geometry
  excess bounds as a possible finite endgame component.
- **C47** — minimal-counterexample constraint package: **Tier D**, gated on C42's report (its
  dichotomy row consumes the census lemma).

**Amendment (Fable, 2026-07-09 fourth pass — adjacent-publishable additions + C35 consequences):**
C35 has REPORTED: the conic⊕zone disjunctive-sum hypothesis is empirically false at S5/S6 (even
where the zone Grundy is fully computable at q=13, `g = g_conic XOR g_zone` fails on most rows;
q=17's computable subset agrees). Consequences: the zone lane is definitively the maintenance
argument; any termination invariant must be a *coupled* quantity, never a naive component xor;
and **C38 is now unblocked** with true-nimber data (its "richer once C35 lands" condition is
met) — C38/C39 are the instruments most likely to surface the coupled invariant. New tasks, in
priority order:

- **C48** — mirror-theorem harvest on classical varieties: **Tier C, top** — the cheapest
  theorem-per-effort in the program right now (the generic fpf-involution lemma is already
  Lean-proven; the work is classical-groups bookkeeping plus small-board machine gates).
- **C50** — kernel-checked Grundy certificate format (machine-verified game-value sequences):
  **Tier D** — newly enabled by C35's oracle; pairs with the C30 engineering lane.
- **C49** — Node-Kayles nimber tables for other chess pieces: **Tier E** — opportunistic, queens
  box idle time only.

**Amendment (2026-07-09 fifth pass — full-PGL bridge correction):** the later downgrade from
full `PGL(2,q)` buckets to burned-pair-stabilizer buckets was unnecessary.  Lemma I of
[`2026-07-07-onconic-intrusion-calculus.md`](2026-07-07-onconic-intrusion-calculus.md) already gives
the right game-theoretic object: an on-conic S4 state is the unordered six-point cap on the conic,
including the two pre-played/burned points, and the original burned pair has no residual role.
Therefore a conic-stabilizing projectivity induced by full `PGL(2,q)` transports the whole follower
game.  Consequences:

- **C53** — formalize the full-PGL orbit bridge and update the q=23 computed status.  This is
  proof/coordination work and should run before any duplicate stabilizer-representative solve.
- **C54** (**reported PASS 2026-07-09**) — certify the q=23 bucket labels themselves with a
  rules-only dump/book checker.  This
  is the computed-value trust work; it should reuse the 22 C29/C37 bucket roots, not compute
  duplicate representatives.
- The C44 optional "direct B3 discharge at q=23" is dropped; do not spend compute on second
  stabilizer-inequivalent representatives merely to test the bridge.
- C29's 22 all-P full-`PGL(2,23)` buckets establish the computed q=23 on-conic/escape result
  without an orbit caveat.  The remaining q=23 caveats are the normal computed-result trust chain
  (solver/canon/certificate/Lean formalization), not B3; C54 is the queue item for that trust
  chain.

**Amendment (Fable, 2026-07-09 sixth pass — dual/isomorphism assessment additions):** a
dual-plane / tractable-category assessment over the open-kernel lanes concluded: blanket
dualization is a no-op (self-dual board; a correlation can never be a reply map), but the
intrusion calculus is the conic model of `PGL(2,q)` half-translated, and finishing that
translation yields cheap, sharp diagnostics. New tasks, in priority order:

- **C55** — d-lattice side-switch diagnostic on the cross-q flipping configurations: joins
  **Tier B, top** (cheapest proof-relevant query in the queue; a candidate *mechanism* for the
  arc-depleted-orders dichotomy, which is now the load-bearing unknown of the (ON) route).
- **C56** — group-indexed cross-q type alignment (the C36 retry): **Tier B, gated on a C55
  positive**.
- **C57** — zone conflict-graph quasi-randomness probe: **Tier D** (diagnostic; either verdict
  converts the string of zone-mining negatives into one structural statement).
- **C58** — order-9 non-Desarguesian plane solves: **Tier C** (independent compute lane beside
  C43/C44; the one item from the spinoff-bridges note with a direct claim on the main program —
  it tests whether the odd-plane conjecture is about order or about Desarguesian structure).
- Method note for the steering lane (no task ID): every object in the conic residual is
  genus 0, so quadratic-character counts of candidate selector cells are **exact** — no
  Weil-type loss, no `q ≥ q₀` gap. Once mining pins down a *geometric* selector rule for the
  zero-xor maintenance reply, its existence step is exact counting at all q simultaneously.
  Record this in the steering follow-up when it activates; the blocker remains that the mined
  repair witnesses are value-defined, not yet geometrically definable.  Second method note
  (seventh pass): treat the missing termination monovariant as an **amortized potential** in
  the online-algorithms sense — a charged mix of conic xor, reservoir slack, and zone size —
  not a single conserved quantity; every snapshot-conserved candidate has died, which is
  consistent with the invariant being amortized rather than exact.

**Amendment (Fable, 2026-07-09 seventh pass — broader-sweep additions for the main problem):**
a second category sweep (list + spinoff-value table in
[`handoffs/2026-07-09-spinoff-bridges-duals-isomorphisms.md`](handoffs/2026-07-09-spinoff-bridges-duals-isomorphisms.md)
§New Candidate Mappings) assessed further mappings on both axes.  Main-problem items queued per
Fable's call:

- **C59** — arc-stability constraint import: **Tier C** (proven extremal input — Voloch/Ball
  second-largest-complete-arc bounds make large terminals conic-contained by theorem; extends
  the reported C46/C47 packages with new rows; the sweep's strongest main-lane item).
- **C60** — Singer-model circulant probe: **Tier E** (cheap bounded diagnostic; the plane as a
  cyclic difference-set board, transfer test for the program's circulant Node-Kayles
  machinery).
- Igusa invariants are folded into **C56** as candidate canonical type coordinates (see the
  amended entry).  Spinoff-only sweep items (no-three-in-line, Sidon games, quantum caps,
  misère, placement complexes, etc.) stay in the spinoff-bridges note pending lit checks.

**Amendment (Fable, 2026-07-09 eighth pass — mathematician-lens shortlist):** the six-lens
ideation sweep ([`2026-07-09-mathematician-lens-sweep.md`](2026-07-09-mathematician-lens-sweep.md))
produced a top-5 shortlist, queued per Fable's call.  Read the sweep note's full attack spec
before starting any of these — the queue entries below are operational pointers plus gates.
Placement:

- **C65** — `Z(23)` measurement + extremal steering states (sweep E1): **Tier A** — the
  cheapest route-deciding measurement in the program; it arbitrates the small-`Z` base-law
  route vs the amortized-potential route and should run before more steering proof effort.
- **C61** — finite-state reply automaton (sweep Co3): **Tier B** — the falsifiable form of the
  open Good-closure core.
- **C62** — inverted selector search via exact character sums (sweep T1): **Tier B** — attacks
  the maintenance lane's named blocker from the algebraic side.
- **C63** — LP-fit the amortized potential, read the dual (sweep L1): **Tier B** — either
  output advances the open core (candidate invariant, or a machine-readable impossibility
  lemma).
- **C64** — completion-poset correlate of the arc-depleted dichotomy (sweep E3): **Tier B,
  beside C55** — the extremal-side mechanism candidate, complementary to C55's group-side one
  (and S1's envelope invariants remain the third, unqueued, candidate if both miss).
- Near-misses now queued for later (ninth pass): **C66** grid-terminal spectrum, **C67**
  coupling-defect spectroscopy, **C68** `D(q)` extremal sequence — do not start before the
  post-C61–C65 triage.

## C1. `[kayles]` Machine-check the Lemma-4 correction (sum-free Z_n mirror lemma) — PRIORITY [REPORTED 2026-07-07]

Context: `2026-07-04-sumfree-game-theorem.md` Lemma 4 (negation mirror with fixed extras) is
**false as stated**. Counterexample found by hand 2026-07-07: `n=12`, `t=n/3=4`, `E={t}`,
`C={4}` (S=∅), move `z=10`: `C∪{z}={4,10}` is sum-free and `z ∉ {0, n/2, t, 2t} = {0,6,4,8}`,
but the mirror reply `w=−z=2` gives `{2,4,10}` with `2+2=4` — not sum-free. The breaker family
is `z = t + n/2` (needs `n` even AND `n/2 ∉ E`; never reachable in the theorem's strategy, which
is why the reachable-position check missed it). Corrected hypothesis: add `z ≠ t + n/2`.

Task:
1. Exhaustive breaker search for the lemma AS STATED, over all `n ≡ 0 (mod 6)`, `n ≤ 120` (plus
   `n ≡ 3 (mod 6)` as control): all sum-free `C = E ∪ S`, `E ⊆ {n/2, t}`, `S = −S` (bound |S|
   by feasibility, document the bound), all legal `z ∉ {0, n/2, t, 2t}`; check `C ∪ {z, −z}`
   sum-free. Confirm: every breaker has `z = t + n/2` (and `E ∌ n/2`).
2. Re-run with the corrected hypothesis (`z ≠ t + n/2`): confirm 0 breakers.
3. Audit `2026-07-05-sumfree-abelian-theorem.md` for the analogous gap in its lifted lemma
   (the `r₃ ≤ 1` case reuses Lemmas 1–4 "verbatim" — does its statement inherit the same missing
   hypothesis? Does any abelian case use `E = {t}` with an order-2 element present?). Report
   what the note claims and whether it needs the same fix; do NOT rewrite the note.

Report file: `notes/2026-07-07-codex-lemma4-check.md`.

## C2. `[cap]` Lean statement scaffold — conic localization lemma (optional, after WP-1/WP-2) [REPORTED 2026-07-07]

Per the day plan's Codex section: statement-level scaffold only (no proof obligation) for the
conic localization lemma of `2026-07-07-conic-localization-onconic-escape.md` §1 — the unique
conic through the 5-arc, hyperbola normal form `(r−ρ)(c−A)=B`, the `q−4` on-conic legal
extensions, and the `ψ_u` involution. Vocabulary exists in `lean/ProjectiveCap/GridCounting.lean`;
the Möbius/hyperbola normal form is new content. A paper-ready prose version is being written in
parallel as `notes/2026-07-07-kernel-conic-localization.md` — match its statement decomposition
if it exists when you start.

Report file: `notes/2026-07-07-codex-conic-scaffold-report.md` (list of Lean names + file, what
is stated vs sorry-free vs deferred).

## C3. `[cap]` Discharge the esc-mode validation gate (q=17 + q=19) [REPORTED 2026-07-07]

O2 implemented the `esc` mode in `notes/2026-07-06-grid-cap-solver.rs` (uncommitted working
tree) and validated q=11/q=13 byte-identical to `escape` mode, but the mandated q=17/q=19
exact-match gate was interrupted at 6/21 q=17 classes (all matching so far). Everything needed —
build line, run commands, required-empty diffs against `2026-07-06-escape-q17.log` /
`-q19.log`, caveats — is in [O2's handoff](2026-07-07-esc23-o2-handoff.md). Run the gate to
completion (single-core, ~23 s/class at q=17, RSS ~80 MB — safe under the box constraint).
PASS = empty diffs on both q. Do NOT start any q=23 campaign.

Report file: `notes/2026-07-07-codex-esc-gate-report.md`.

## C4. `[cap]` Fill the arc-census paywalled gaps (q=23, q=25; q=31 full classification) [REPORTED 2026-07-07]

O1's census ([2026-07-07-arc-census-o1.md](2026-07-07-arc-census-o1.md)) fully sourced q=27/29
and all six minimum sizes, but the complete size spectra/counts for q=23 and q=25 live in
paywalled papers (Coolsaet–Sticker JCD 17 (2009); Marcugini et al. Discrete Math 307 (2007);
Faina et al. Ars Comb 47 (1997)), plus Coolsaet JCD 23 (2015) for the full q=31 classification
and Kéri JCD 14 (2006) for large-size counts. The note's GAPS section lists the exact (q, cell)
→ paper+table map. If you have library/alternate access, extract those tables into the census
note's format (append a `## C4 fill` section; tabulation only, per-claim citations, no
interpretation). If access also fails, record that and stop.

Report file: `notes/2026-07-07-codex-arc-census-fill.md`.

## C5. `[cap]` Test the PGL(2)-orbit value-invariance prediction (q=17 feat data) [REPORTED 2026-07-07]

Lemma I of [onconic intrusion calculus](2026-07-07-onconic-intrusion-calculus.md) predicts: two
on-conic size-4 positions whose 6-point parameter sets `{∞, 0, t₁, t₂, t₃, t₄} ⊂ P¹(F_17)` are
equivalent under the FULL `PGL(2,17)` must have equal game values. Test it against the q=17
`feat` data: regenerate the per-class per-extension `pos=on` value lines
(`2026-07-06-grid-cap-solver.rs` feat mode, q=17, ~minutes, small memory), reconstruct each
on-conic S₄'s parameter 6-subset (the conic reconstruction recipe is in
`2026-07-07-conic-localization-onconic-escape.md` §4), bucket the 6-subsets by
`PGL(2,17)`-canonical form (orbit of the 6-set under all Möbius maps; brute-force canonicalize —
|PGL(2,17)| = 4896, ≤ 273 subsets, trivial compute), and check value-constancy per bucket. Any
violation REFUTES Lemma I (report it verbatim — it would mean an error in the uniformization
argument); constancy + the bucket count is the payoff either way (how much the moduli collapse).

Report file: `notes/2026-07-07-codex-pgl2-orbit-check.md`.

## C6. `[cap]` Fix the latent GF(49) reducible-polynomial bug + field self-check (AFTER C3 completes) [REPORTED 2026-07-07]

F3 audit finding B1 (`2026-07-07-f3-soundness-audit.md`): `irred(49)` in
`2026-07-06-grid-cap-solver.rs` returns `x²+3` over F₇, which is REDUCIBLE (−3 ≡ 4 = 2² mod 7;
the comment tested `c` nonsquare instead of `−c`). Latent only — MAXW caps q ≤ 32 and a q=49
run panics on mask width first; no existing result touched. **Wait until your C3 gate is done
before editing the file** (don't rebuild under your own running gate). Then:
1. Replace the entry with `x²+1` over F₇ (irreducible: −1 nonsquare, 7 ≡ 3 mod 4); fix the
   comment.
2. Add a startup self-check in `GF::new`: assert no zero divisors / every nonzero element got
   an inverse (cheap O(q²) table scan), so any future bad `irred` entry fails loudly instead of
   silently computing over a ring.
3. Add an explicit `assert!(q * q <= 64 * MAXW, ...)` at `Board::new` entry with a clear
   message (today's failure mode is an index panic deep in `set_bit`).
4. Verify: rebuild, re-run one small validation (`escape 7` or the q=11 esc class 0) and
   confirm byte-identical output to before the edit.

Report file: `notes/2026-07-07-codex-gf49-fix.md`.

## C7. `[cap]` Machine-check + write up the automorphism-exhaustiveness lemma [REPORTED 2026-07-07]

F3 audit finding D1: the resym NO verdicts (q=11,13,17) rest on "the semilinear monomial
affine maps (both coordinate orders) are ALL automorphisms of the grid game hypergraph" —
true, but the proof is nowhere in the notes. Two deliverables:
1. **Prose lemma note** with the two-step argument (sketch in the audit note §2(b)): a
   legality-preserving cell bijection (i) preserves illegal pairs ⇒ rook's-graph automorphism
   ⇒ (row perm × col perm) ⋊ swap for q ≠ 4 (cite Aut(K_q□K_q)); (ii) preserves collinear
   triples with distinct rows/cols ⇒ collineation of AG(2,q) ⇒ monomial semilinear with a
   SINGLE field automorphism σ on both coordinates (show the σ ≠ τ twisted form breaks
   collinearity explicitly). Conclude: the `all_autos` enumeration is the full group.
2. **Brute-force check at q=5 (and q=7 if it fits the box budget):** enumerate all
   (row perm × col perm) ⋊ swap maps (2·(q!)² — 28,800 at q=5), filter those preserving the
   set of non-axis collinear triples, and confirm the survivors are EXACTLY the 2(q−1)²q²·e
   maps `all_autos` builds (compare as permutation sets, not counts). Single-core, tiny RAM.

Report file: `notes/2026-07-07-codex-autgroup-check.md`.

## C8. `[cap]` Exact-canon cross-validation of the fingerprint canon (q=11, q=13 + q=17 witnesses) [REPORTED 2026-07-07]

F3 audit finding D2: `canon()` is a 128-bit additive fingerprint (min over anchor images of a
sum-of-cell-hashes), not an exact canonical form — a collision would silently merge classes.
Collision odds are negligible and small-q class counts were validated, but the paper-grade
claims should rest on an explicit check:
1. Implement (or port from the Python `2026-07-06-grid-canon2.py` canon if it is exact) an
   EXACT canonical form: min over the same anchor images of the *sorted cell list itself*
   (lexicographic), no hashing.
2. For q=11 and q=13: recount all canonical classes per size (full expansion) under both keys;
   confirm identical counts per size. For q=17: re-canonicalize just the size-3 classes and
   each min-escape class's size-4 children under the exact key; confirm the escape histogram
   (5:3 10:12 11:6) is reproduced.
3. Report the counts verbatim; any mismatch is a MAJOR finding (report and stop — do not
   "fix").
Memory note: full q=13 expansion fits the ≤1 GB budget; q=17 full expansion does NOT — use the
esc-mode private-memo machinery for the q=17 step (class-by-class), or skip to size-3/size-4
re-canonicalization only.

Report file: `notes/2026-07-07-codex-exact-canon-check.md`.

## C9. `[queens]` Lean statement scaffold — tau-mirror + exception-table certificate format (n=20 lucky plan) [REPORTED 2026-07-07]

Statement-level only (no proof obligation), after WP-1/WP-2 and C1–C8 work. Target: the Phase-3
artifact format of [`2026-07-04-n20-lucky-first-win-plan.md`](2026-07-04-n20-lucky-first-win-plan.md)
— extend the reply-book kernel in `lean/NodeKayles/Certificate.lean` toward
`Queens.N20J10LuckyTarget`: a certificate datatype of (automatic tau rule on the paired core +
border/scar exception table + terminal claims: closed pairing / tau-symmetric leaf / solved
leaf) and a checker-statement `certificate valid → position is P`. Fable is writing the
extractor design spec in window 2 (day plan W2-3) — match its decomposition if it exists when
you start; otherwise state the pieces against the n20 plan's §Soundness-boundaries list.

Report file: `notes/2026-07-07-codex-cert-format-scaffold.md`.

## C10. `[queens]` P0a border-signature census/valtest probe (n=20 lucky plan, Phase 0a) [REPORTED 2026-07-07]

Implement + run the probe EXACTLY per **Appendix P0a of `2026-07-07-fable-day-plan.md`**
(spec is self-contained there: modes `census`/`valtest`, signature v0/v1 definitions, gates,
guardrails). Reassigned from Opus to Codex per the standing delegation rule. Single-core,
≤1 GB, no n=20 runs. Deliverable = the report file with the census tables (n=12,14,16,18) and
valtest violations verbatim. This gates C11.

Report file: `notes/2026-07-07-p0a-border-signature-report.md`.

## C11. `[queens]` Central-child certificate extractor build (GATED on C10) [NO-GO 2026-07-07]

Build per **`2026-07-07-central-child-certificate-spec.md`** (the soundness contract — do not
weaken any obligation; signatures organize, never certify; separate checker pass + mutation
gate). START ONLY IF C10's census shows #v1-signatures growing clearly slower than #border
subsets at n=18 (depth ≥ 3) AND valtest violations are zero or obviously structured; if the
result is ambiguous, STOP and wait for Fable's window-3 calibration call. Work the gates in
order (G1 n=6..12, G2 mutation, G3 n=18 I9 Phase 0); report compression stats per G3. The n=18
Phase-0 run may continue past your session — checkpoint the exception book.

NO-GO note: C10 found mixed-value valtest buckets at n=8/n=10, n=12 valtest exceeds the
original 1 GB cap, and n=18 has only a 10 GB diagnostic depth-2 row (no depth ≥3 evidence).
Do not start C11 from the current P0a data.

Report file: `notes/2026-07-07-codex-cert-extractor-report.md`.

## C12. `[cap]` Per-q escape certificate emitter — Rust `cert` mode (route C, phase 1) [REPORTED 2026-07-07 (opus delegate)]

Context: the odd-side Lean compositions are done and conditional only on
`OddEscapeGameStatement`/`OnConicEscapeStatement` (see `lean/ProjectiveCap/PlaneOutcome.lean`;
the parity/pairing hypotheses are marked FALSE-universally in-file — do not proof-search them).
Route C of `2026-07-07-projcap-open-math-plan.md` turns the computed ladder into formal per-q
theorems via certificates. Your C3 gate PASSED (esc mode validated q=17/q=19 per-class), so the
class-private subtree machinery is the trusted substrate; C8 validated the canon at the needed
scale; C5's PGL(2,17) collapse (273 on-conic children → 10 orbit buckets, value-constant) says
orbit-level books compress well.

Task — add a `cert` mode to `notes/2026-07-06-grid-cap-solver.rs` (single-core, ≤1 GB, q ≤ 13
first; q=17/19 only if the private-memo peak allows — C3 measured q=19 peak ~32.3M entries):
1. Per canonical size-3 class of GF(q): emit the class representative `S₃`, one witness escape
   cell `p` (prefer an ON-conic witness when one exists — record on/off), and a **P-certificate
   of `insert p S₃`**: a reply book mapping every legal move `x` from the size-4 position to a
   reply `y` such that the book is closed and terminals are even (the shape
   `FiniteBuildGame.PairReplyBook` / `PCert` expects — see `lean/CapGame/BuildGame.lean`; depth
   is bounded by max cap size, so a DAG book with explicit terminal parity rows is fine).
2. Output format: line-oriented plain text, one file per q (`notes/certs/gridcap-q<q>.cert`),
   self-describing header (q, class count, field poly for q=9), cells as `r,c` integers. Keep it
   trivially parseable — a Lean elaborator will consume it (WP-3); no serde, no JSON nesting.
3. Validate: an independent `certcheck` mode that re-verifies every book row against the game
   rules ONLY (no game values): legality of moves/replies, closure, terminal parity. Then
   cross-check per-class witness escape counts against the `esc`/`escape` histograms.
4. Report: format spec, per-q class/book/row counts, certcheck output verbatim, wall/RSS.

Do NOT start the Lean checker side (WP-3) — Fable is scoping it; the deliverable here is the
emitter + self-check + format spec for the checker to target.

Report file: `notes/2026-07-07-codex-cert-emitter-report.md`.

## C13. `[cap]` q=9 intrusion-structure probe (the next odd-plane Lean target)

Context: PG(2,5) and PG(2,7) are now Lean theorems via the intrusion calculus
(`lean/ProjectiveCap/IntrusionCalculus.lean`, commits `96746ab`/`ae1a346`): at q ≤ 7 no
off-conic intruder is ever legal above an on-conic S₄. At q = 9 intruders EXIST but the
intrusion note (§3 of `2026-07-07-onconic-intrusion-calculus.md`) predicts they are confined:
Lemma III(4) with c=6 gives `τ_x ≤ 2·τ_played − 2`, so only external points with BOTH
tangencies at played points can intrude, they lie on pairwise intersections of played tangent
lines, and after any such intrusion `M = 0` (the conic is dead) — the residual is a tiny
intruder-only game. Machine-check this structure exhaustively at q = 9 to pin the Lean proof
design (feat data already says every on-conic S₄ is P at q=9).

Task (Python or a private solver build; GF(9) tables exist in `2026-07-06-grid-cap-solver.rs`;
small compute):
1. For every conic (or one per symmetry class, state which) and every legal on-conic size-4
   position: enumerate ALL legal off-conic intruders x; record `(τ_x, τ_played)`; confirm the
   census matches the bound (no `(0,·)` or `(2,0/1)` types), and that each intruder kills the
   whole surviving conic (verify the exact kill-set σ_x(played) as in the note's verifier
   `2026-07-07-onconic-intrusion-check.py` — reuse/extend it if convenient).
2. For each intruded child, solve the residual game EXACTLY (it should be intruder-only and
   shallow): report max residual depth, max branching, and the outcome pattern; confirm every
   on-conic S₄ is P and identify WHY (does P2 always have a mirror/second intrusion reply, or
   does the intruder zone die immediately?).
3. Tabulate: #on-conic S₄ classes, #legal intruders per class, residual game sizes. The
   deliverable is the structure table a Lean `noIntrusionAboveFour`-style q=9 statement (or its
   replacement — the kernel is NOT no-intrusion at q=9) would need.

Report file: `notes/2026-07-07-codex-q9-intrusion-probe.md`.

## C14. `[cap]` WP-3 Lean certificate checker scaffold (GATED on C12's report existing)

Do NOT start until `notes/2026-07-07-codex-cert-emitter-report.md` exists (an Opus delegate is
building the emitter). Then: statement-level Lean scaffold for the route-C checker consuming
the C12 cert format — target `FiniteBuildGame.PairReplyBook`/`PCert` in
`lean/CapGame/BuildGame.lean`. Concretely: (1) a Lean datatype mirroring the C12 file format
(class rep, witness cell, reply-book rows); (2) a checker statement
`bookValid → GridGame.IsP (insert p S₃)` and the per-class assembly toward
`Almost.OddEscapeGameStatement (K := ZMod p)` for prime q (skip GF(9) in the scaffold; note
what it needs); (3) if cheap, an end-to-end q=5 instantiation attempt (the q=5 book is tiny) —
but statement-level for the rest is fine. Match the C2/C9 report style: names, proved vs
stated vs deferred, build transcript.

Report file: `notes/2026-07-07-codex-wp3-checker-scaffold.md`.

## C15. `[cap]` PGL(2,q) orbit-collapse census at q = 11, 13, 19 (extends C5)

Rerun your C5 methodology at q = 11, 13, 19: regenerate feat data, reconstruct each on-conic
S₄'s 6-point parameter set, bucket by PGL(2,q)-canonical form, check value-constancy per
bucket, and report raw-children → orbit-bucket collapse ratios per q. Purpose: (i) more
falsification pressure on Lemma I (any mixed-value bucket REFUTES it — report verbatim and
stop); (ii) the collapse ratio decides whether route-C certificate books (C12/C14) should be
emitted per-orbit instead of per-class (C5 saw 273 → 10 at q=17). Same guardrails as C5.

Report file: `notes/2026-07-07-codex-pgl2-orbit-census-q11-19.md`.

## C16. `[kayles]` Sum-free Tactic 2 — induction on `r` (activated by the z5 kill)

The `Z3³×Z5` brute run was killed 2026-07-07 with no verdict (flat 1.07× redundancy at 106M
nodes — same compute-infeasible bucket as p=11; datapoint + rationale in
`handoffs/2026-07-05-sumfree-compute-parallel-codex.md`). The `r = 3` outcome now rests
entirely on your Tactic 2 lane: the monotone-resource law **"`Z3^r × Z_p` is N iff r = 1"**
(the proven r=1→r=2 mechanism: each extra `F₃` factor hands Bob one more `O₃` pair). Work the
induction step r → r+1 directly (the handoff's `--6` block has the structural facts: the win
is adaptive, backbone-less, obstruction on the `⟨socle-line⟩` fibers). Do NOT relaunch any
brute-force solve. Partial results welcome: even a clean statement of the induction invariant
that survives the known q=5-exception structure is progress — report what breaks if it breaks.

Report file: `notes/2026-07-07-codex-sumfree-induction-r.md`.

## C17. `[cap]` Anchored certificate family — the constructive `represents` bridge (route C, phase 2) [REPORTED 2026-07-08]

C14's scaffold is sound and its one open gap is the `GridOddEscapeBookCertificate.represents`
selector (canonical-class → every position). Fable's design decision: **replace full-canon
orbits by ANCHOR NORMALIZATION, which makes coverage true by construction** — no orbit
enumeration proof ever needed. Every size-3 grid cap `{p₁,p₂,p₃}` has `p₁,p₂` in distinct
rows AND columns (partial permutation), so the affine map
`φ(r,c) = ((r−r₁)·(r₂−r₁)⁻¹, (c−c₁)·(c₂−c₁)⁻¹)` — a translation composed with two axis
scalings, each a `GridSymmetry` in the proven `psi_gridSymmetry` sense — sends `p₁ ↦ (0,0)`,
`p₂ ↦ (1,1)`. So a book family indexed by the THIRD cell of anchored positions
`{(0,0),(1,1),(r,c)}` (~(q−2)(q−3) minus collinear/attacking, ≈ 70 at q=11) covers all
positions via `gridSymmetry_isP_image` transport. Task:
1. **Emitter**: add `cert --anchored <q>` to `notes/2026-07-06-grid-cap-solver.rs` — same
   book format, one CLASS per legal anchored S₃ (third-cell-indexed), certcheck must pass.
   Also print the anchored-class count per q (5,7,11,13 — skip 9/GF(9) for now).
2. **Lean data generator**: a script (any language) translating an anchored `.cert` into
   `lean/ProjectiveCap/CertData/Q<q>.lean` — `GridClassCert (ZMod q)` terms + `Valid` proofs.
   Validity obligations are small decidable props over `ZMod q`; try `by decide` per
   obligation first (NO `native_decide` — project trust policy). PROTOTYPE ON q=5 THEN q=7
   ONLY and measure elaboration wall time; report the per-class cost so Fable can go/no-go
   q=11. If kernel `decide` is too slow, report where it chokes (Move quantifier? AffineCap?)
   and STOP — do not brute-force.
3. (Statement-level, optional) The anchor-transport lemmas in Lean:
   `gridSymmetry` for translations/axis-scalings + the legality/IsP transport that turns an
   anchored family into `GridOddEscapeBookCertificate.represents`. Follow the
   `psi_gridSymmetry` proof shape in `ConicLocalization.lean`; statement-level is fine,
   proofs welcome.

Report file: `notes/2026-07-07-codex-anchored-cert-report.md`.

## C18. `[cap]` ML feature attribution on the on-conic value moduli (GATED on C15's report) [REPORTED 2026-07-08]

Do NOT start until `notes/2026-07-07-codex-pgl2-orbit-census-q11-19.md` exists — its per-q
orbit-bucket tables ARE the training data. Purpose: a disciplined, interpretable-models pass
over the (ON) value function to generate a falsifiable cross-q law candidate for the
two-plus-intruder residual (session-9 §6). This is the knot-theory template: train → attribute
→ extract candidate invariant → hand it to the proof lane. **Total compute budget: hard 8h
wall; phase 1 should be well under 1h.**

Phase 1 (the deliverable):
1. Build one table: every PGL-orbit bucket of on-conic S₄ 6-subsets `{∞,0,t₁..t₄}` for
   q ∈ {11,13,17,19} (from C15 + the C5 q=17 data), label = game value.
2. Feature dictionary — MUST include arithmetic-of-q features, not just configuration
   features (the character-law falsification in `2026-07-07-conic-localization-onconic-escape.md`
   §3.3 says configuration-only formulas are dead): cross-ratio invariants of the 6-subset;
   quadratic-character vector; tangency data; and the §6 order-theoretic features —
   `ord(σ σ')` in PGL(2,q) for canonical involution pairs fixing 2-subsets of the 6 points,
   gcd/divisibility of those orders against q−1 and q+1, internal/external type counts.
3. Models: decision trees (depth ≤ 3), sparse logistic/L1, small symbolic regression over the
   dictionary. **Protocol: fit on q ∈ {11,13}, test on {17,19} — NEVER fit on all four.**
   Also report the reverse split. Any candidate must correctly place the q=17 min-escape
   classes (onP=1) and the q ∈ {13,19} all-P columns.
4. Report: the table (verbatim), feature rankings, every candidate law with its held-out
   accuracy, and explicit falsifications. A null result ("no small law separates") is a
   valid deliverable — report it plainly.

Phase 2 (OPTIONAL, only inside the remaining budget): witness/reply priority heuristic from
the phase-1 features, then ONE q=23 size-3 class per-class escape probe with a 1h wall cap;
extrapolate total q=23 cost from that single class and STOP — report the projection, do not
run the campaign. If the single-class probe exceeds its 1h cap, kill it and report where it
was (this is itself the sizing datum).

Report file: `notes/2026-07-07-codex-ml-moduli-attribution.md`.

## C19. `[cap]` Verified boolean book-checker + reflection (route C, phase 3 — the C17 fix) [REPORTED 2026-07-08]

C17's STOP diagnosis is confirmed and the fix direction it proposed is approved: do NOT raise
`maxRecDepth`, do NOT use `native_decide`. Build the reflection route — a computable `Bool`
checker over concrete list data + a soundness theorem into C14's semantic layer, so per-class
validity proofs become `by decide` on `checker data = true` (ONE `Decidable Eq Bool` instance;
the kernel evaluates the checker — no typeclass search, no new axioms).

1. **Lean checker** (new file, e.g. `lean/ProjectiveCap/CertCheck.lean`): concrete cert data
   as `List`-based structures over `ZMod p` cells; `checkCap : List (GridPoint K) → Bool`
   (pairwise distinct rows/cols + no collinear triple), `checkMove`, and per-node closure by
   enumerating all q² cells (a `List.all` over the cell grid: if legal from the node, a row
   must match). Reflection theorems: `checkCap l = true → GridCap l.toFinset`, up to
   `checkBook c = true → GridClassCert.Valid c` (route through C17's
   `validFor_of_finiteRows` bridge). Soundness direction only (`= true → Prop`) is enough —
   no completeness needed.
2. **Generator v2**: update `notes/2026-07-07-anchored-cert-to-lean.py` to emit the list
   data + one-line `by decide` proofs per class into `lean/ProjectiveCap/CertData/Q<q>.lean`.
3. **Elaboration ladder with measurement**: q=5, then 7, then 11. Report per-q kernel-eval
   wall time. STOP if q=11 projects past ~30 min single file (split per-class files is an
   acceptable mitigation — report either way). q=13 only if q=11 is comfortable.
4. **Transport lemmas** (C17 part 3, still open): the anchor-normalization grid symmetries
   (translation + axis scalings, `psi_gridSymmetry` proof shape) and the
   legality/IsP transport assembling an anchored family into
   `GridOddEscapeBookCertificate.represents`. Statement-level minimum; proofs welcome.
   With 1–4 done, `OddEscapeGameStatement (ZMod 11)` — hence unconditional PG(2,11) via
   `initialPStatement_of_oddEscapeStatement_finrank` — is the assembly payoff.

Report file: `notes/2026-07-07-codex-certcheck-reflection.md`.

## C20. `[cap]` Winning-intrusion census on the on-conic buckets (intrusion calculus, attack option (i)) [REPORTED 2026-07-08; REVIEWED 2026-07-08 — SOUND]

C18's null (reviewed, sound) killed shallow laws over STATIC features of the 6-subset. The
surviving hypothesis (session-9 §6 of `2026-07-07-onconic-intrusion-calculus.md`) is that the
law lives in the game-labeled intruder census, which C18 never computed. Build it.

1. **Data:** for q ∈ {11, 13, 17} (q=19 optional if cheap), for one representative on-conic S₄
   per full-PGL orbit bucket (the C15 32-bucket table): enumerate ALL legal off-conic intruders
   `x`, and label each with the exact value of `S₄ + x` (P/N) by a private-memo subtree solve
   (pattern: the C13 q=9 probe / esc-mode `esc_g`; size-5 starts are small — the q=17 full
   size-3-class solves ran ~30s/class).
2. **Features per intruder:** `(τ_x, τ_played)` type, internal/external, `M = (q−11+τ_x)/2`
   parity, kill-set size. For each N-valued intruded child (mover-after-x wins), classify the
   winning replies: conic cell vs second intruder `x'`; for second-intruder winning replies
   record `ord(σ_x σ_{x'})` and its divisor class vs q−1 / q+1.
   **AMENDED 2026-07-08 (session 11, `2026-07-08-nk-involution-residual.md`): also compute,
   per reply state, the Node-Kayles DEFECT SPECTRUM** — the component path-length multiset of
   the union-matching graph on live conic params (free even cycles are Grundy-0, droppable),
   and the restricted-Grundy XOR (Dawson A002187 path values over the spectrum). Reference
   implementation: `spectrum`/`dawson_tables` in `2026-07-08-nk-involution-check.py`
   (machine-validated NK1–NK3). The upgraded question (a): does (defect-XOR, intruder-zone
   size/parity) decide the full-game value of the reply state? This is the leading
   hypothesis — test it FIRST.
   **SECOND AMENDMENT (session-11 addendum, q=11 spot-test done by Fable — do not redo
   q=11; extend to q=13, 17):** the necessity law `P ⇒ defXOR = 0 ∧ zone even` held
   381/381 at q=11, and the residual mixed bucket was fully explained by the zone conflict
   graph (empty-conic zone-2 endgame, 328/328). Your primary deliverables become:
   (a′) test the necessity law at q = 13 and 17 (any violation verbatim — it kills the
   joint-snapshot hypothesis); (b′) in the (defXOR=0, zone-even) bucket at q = 13/17 —
   where the conic will NOT be empty — hunt the discriminator among: zone conflict-graph
   NK value, zone size, conic path spectrum × zone coupling. Features to emit per state:
   defect spectrum, defXOR, zone size, zone conflict-edge count, zone conflict-graph NK
   Grundy (zones are small; exact NK on the snapshot is affordable).
3. **The discriminating questions (report tables + verdicts, null is a valid deliverable):**
   (a) does `(τ_x, τ_played, M parity)` alone decide P/N of `S₄+x` within a bucket? across
   buckets? across q? (b) if not, does the `ord(σ_x σ_{x'})` census decide it? (c) do the
   N-buckets of q = 11/17 differ from the P-buckets in their winning-intrusion profile in any
   way visible to these features? Per Lemma III(3), M-parity is position-independent given
   type — so (a) failing WITHIN a type is itself a sharp negative worth reporting verbatim.
4. **Gates before any q ≥ 11 report:** (i) reproduce the C13 q=9 census exactly (only
   `(τ_x, τ_played) = (2,2)` intruders; every intruded child has exactly one legal reply,
   terminal); (ii) per-bucket onP counts derived from your labels must match the C15/C5 feat
   data byte-for-byte where they overlap.
5. Budget: hard 8h wall; single-core, ≤ 8 GB.

Report file: `notes/2026-07-08-codex-intrusion-census.md`.

**Review (Fable, 2026-07-08): SOUND — the joint-snapshot necessity law is dead beyond q=11.**
All reported numbers reproduce from the raw states jsonl (violations 468 @ q13 / 3455 @ q17,
every table, the first counterexample verbatim). The review added the gate the amendment
removed: re-running the census script at q=11 against `/tmp/codex-feat11-c15.out` reproduces
Fable's session-11 ground truth exactly (0 necessity violations; slice zoneG=0 ⟺ P), so the
new defect/zone feature code is cross-validated and the q=13 counterexample stands. Findings
beyond the report + program consequences: projcap handoff session-block item 16. The
ord(σ_xσ_x') census (question 3b, deprioritized by the second amendment) was never analyzed,
but the per-state `order` field IS in the states jsonl — durable copy
`notes/data/c20-q13-q17-states.jsonl.gz` (feat-log inputs also in `notes/data/`;
regenerable in ~67s via the report's Main-run command).

## C21. `[cap]` q=23 esc single-class sizing probe (route D; C18 phase-2 leftover) [REPORTED 2026-07-08]

The esc-mode q=17/q=19 validation gate is DISCHARGED (C3) and the box is free (queens G(17)
done; sum-free z5 terminated). Size the q=23 campaign — do NOT run it.

1. Build the committed solver (`rustc -O -C target-cpu=native 2026-07-06-grid-cap-solver.rs`),
   report the q=23 canonical size-3 class count (enumeration is cheap).
2. Run `esc 23 --cap 200000000 0` (class 0 only) under a **1h wall cap**. If it completes,
   run further classes within the same hour. Report per-class escape/bad/peak-memo/wall
   verbatim, or where it died (cap vs timeout) — either outcome is the sizing datum.
3. Extrapolate the full q=23 per-class campaign cost (classes × per-class wall, peak memory)
   and STOP. The campaign itself is a user launch decision. Note in the report whether the
   extrapolated peak-memo fits the box without the global arena.
4. Motivation to carry in the report: a q=23 column adds a potentially MIXED-value training
   column for the moduli law hunt (mixed exists only at q = 11, 17 so far), and min-escape at
   q=23 is the live falsification watch (any class at 0 falsifies the conjecture).

Report file: `notes/2026-07-08-codex-esc23-sizing.md`.

## C22. `[cap]` Transport lemmas + represents assembly (route C, phase 4 — the C19 open half)

C19 is reviewed and sound (commit `cac2875`; axiom profile verified clean in review). What
remains for unconditional PG(2,11) is exactly C19's deferred item 4:

1. **Anchor-normalization grid symmetries:** every legal size-3 grid cap maps to its
   anchored form (first two cells ↦ `{(0,0),(1,1)}`) by an explicit translation + axis
   scalings composite; formalize these as grid-game symmetries (the `psi_gridSymmetry`
   proof shape; `gridSymmetry_isP_image` is already proven) with the partial-permutation
   argument that the scalings are nonzero.
2. **`represents` assembly:** the anchored family (the Q11 `CertData` classes) covers every
   size-3 position via 1's transport — discharge
   `GridOddEscapeBookCertificate.represents`, then assemble
   `OddEscapeGameStatement (ZMod 11)` and the payoff theorem via
   `initialPStatement_of_oddEscapeStatement_finrank` (unconditional PG(2,11)).
3. **Axiom gate:** `#print axioms` on the final PG(2,11) theorem must show only
   `[propext, Classical.choice, Quot.sound]` — include it verbatim in the report.
4. DONE 2026-07-08: the q=13 generator split + staged build landed.  Per-class files built
   far under the 30-min gate and the final theorem is
   `ProjectiveCap.Certificate.CertData.Q13.initialPStatement_finrank`.

Report file: `notes/2026-07-08-codex-transport-assembly.md`.

## C23. `[cap]` TEXT visualizations of winning cap-game lines, odd q (study artifact for the strategy hunt)

No cap-game line visualizations exist anywhere in the repo (queens has them; projcap has
none). Post-C20 the odd-q proof hunt is STRATEGY-level (response schemes, not snapshot
invariants) — so we want to *look at* optimal play. Text only: markdown with fenced
unicode/ASCII board diagrams (greppable, diffable, terminal-renderable). No HTML/SVG.

1. **Line extraction.** Reuse the exhaustive solver (`2026-07-05-proj-cap-fast.py`) and the
   C20 census machinery (`2026-07-08-intrusion-census.py`: legality, σ_x, spectrum, zone).
   Extract optimal (win-preserving) lines to terminal:
   (a) **The second-player defense from the empty board**, q ∈ {3, 5, 7, 9, 11}: for each
   first move up to symmetry (frame reduction makes this a short list), one optimal P-side
   reply line to the terminal maximal cap. This is the "defense book" we have never seen.
   (b) **q=11 N-bucket S4 winning-intrusion lines** (win only by intruding, session 11):
   the full line from the intrusion to terminal.
   (c) **q=17 winning intrusions**: one line per N bucket from the C20 representatives
   (feat logs + labeled data in `notes/data/`; the 28 winning first moves are in the jsonl).
2. **Rendering spec (per ply).** The anchored affine grid (q×q + the infinity row), one
   diagram per ply or per move-pair: conic cells `·`, first player's stones odd move
   numbers, second player's even, cells dead (kill-scars / cap-blocked) `x`, current
   intruder-zone cells marked. Alongside each diagram print the NK snapshot: defect
   spectrum, defXOR, zone size/parity, zone NK Grundy — so the picture and the C20 feature
   vocabulary can be read against each other.
3. **The analytical questions to eyeball (state observations, no proof burden):**
   (a) does the P-side defense visibly PAIR cells (mirror/involution structure — the thing
   every landed proof in this project used)? Same pairing across q or per-q ad hoc?
   (b) in the multi-intruder defense (q=11/17), what does the defense do to the zone —
   does it steer zone size back to the O(1) endgame regime where the session-11 laws hold?
   (c) do winning intrusion lines share a recognizable shape across buckets/q (tangency
   structure, σ-scar geometry)?
4. **Gates:** every printed line re-checked move-by-move by an independent legality checker
   (determinant-based, not the solver's own); terminal position verified maximal (no legal
   extension); line values must match the known verdicts (initial P for all q here; the
   S4-rooted lines must match the C20/C15 bucket labels).
5. Deliverables: the markdown study document + the committed generator script
   (deterministic, seeded choices documented). Budget: 4h wall, single-core, ≤ 8 GB.

Report file: `notes/2026-07-08-codex-winline-viz.md`.

## Standing

~~WP-1 (frame⇄grid bridge) then WP-2 (q-even theorem)~~ — **both DONE** (the q-even plane
theorem is unconditional: `PlaneOutcome.initialPStatement_of_even_card_finrank`). Current
proof-side context loads per [named-expert personas](2026-07-07-named-expert-personas-context.md);
projective status lives in `handoffs/2026-07-06-projective-cap-game-handoff.md` (session-10
block: order-5 and order-7 planes proven, dead-hypothesis routes guarded).

## C24. `[cap]` Binary projective nofil theorem in Lean: `PG(n,2)=P` for every `n ≥ 1` [REPORTED 2026-07-08]

Goal: close the whole q=2 projective column by proof, not computation.

Target theorem:

```lean
Projective.InitialPStatement (K := ZMod 2) (V := V)
```

from `[AddCommGroup V] [Module (ZMod 2) V] [Fintype V] [DecidableEq V]` and
`2 ≤ Module.finrank (ZMod 2) V`.  This is `PG(n,2)` for projective dimension
`n ≥ 1`; rank 1 / `PG(0,2)` is correctly excluded.

Proof route:

1. Prove the binary projective bridge: `Projectivization (ZMod 2) V` is equivalent to
   `{v : V // v ≠ 0}` via `p ↦ p.rep`; each projective point has a unique nonzero vector
   representative because `(ZMod 2)ˣ` is trivial.
2. Prove the validity bridge: projective caps over `ZMod 2` correspond to sum-free subsets
   of the nonzero vector model, since binary projective lines are exactly
   `{x, y, x + y}`.
3. Transport the game through the bridge. Reuse the already-proved sum-free theorem:
   `Sumfree.Game.initial_isP_of_at_least_two_nonzero_orderTwo` (or the rank wrapper
   `initial_isP_of_rank_count_P_cases`) supplies the strategy. Informal strategy: after
   P1 plays `a`, P2 chooses `b ≠ a`; `a+b` is blocked, and translation by `a+b` pairs the
   remaining live nonzero vectors. This is a non-linear board pairing, not a linear
   projective collineation.
4. Add a small nofil-facing corollary/note: the impartial shared nofil game on the projective
   binary STS family `STS(2^{n+1}-1)` is P for all `n ≥ 1`.

Prior-art guard: Clark--Mancini--Van Hook study a different game according to the accessible
abstract: partizan colored misere tic-tac-toe / avoidance, first player to complete a
monochromatic block loses. Verify the full paper before writing novelty language, but do not
cite it as covering impartial nofil.

Report: [`2026-07-08-codex-binary-projective-lean.md`](2026-07-08-codex-binary-projective-lean.md).
Lean status: **DONE** in `ProjectiveCap/Binary.lean`. Main theorem names:
`Projective.initialPStatement_binary_of_finrank_ge_two` and
`Projective.initialPStatement_binary_of_projectiveDim_ge_one`; support bridge:
`binaryPointEquivNonzero`, `binary_nonzeroValid_iff_cap`, and
`Sumfree.Game.nonzero_initial_isP_zmod2_of_finrank_ge_two`.

## C25. `[cap]` Elliptic-involution theorem in Lean: `PG(2m−1,q)=P` for odd `q` [REPORTED 2026-07-08]

Goal: formalize the new closed projective family.

Semi-formal proof kernel: [`2026-07-08-projective-mirror-proof-kernels.md`](2026-07-08-projective-mirror-proof-kernels.md)
§2-§3.

Target theorem shape:

```lean
Projective.InitialPStatement (K := K) (V := V)
```

from `[Field K] [Fintype K] [DecidableEq K]`, `Odd (Fintype.card K)`, and
`Even (Module.finrank K V)` with positive even rank (`2 ≤ Module.finrank K V`), equivalently
`PG(2m−1,q)` for odd `q`.

Proof route:

1. **DONE 2026-07-08.** Add a reusable finite-building-game mirror theorem: if an involutive board equivalence `σ`
   preserves validity, has no fixed points, and the hypergraph legality condition is collineation-like
   as in projective caps, then the empty position is P. For projective caps the direct lemma should
   say: for any `σ`-invariant cap `S`, if `x` is legal then `σ x` is legal after `x`.
2. **DONE 2026-07-08.** Prove the projective cap mirror lemma for any fixed-point-free involutive collineation:
   lines through old-old pairs pull back under `σ`; the only extra case `x, σx, z` is killed by
   `σ`-invariance because `z, σz` are an old pair on the same invariant line.
3. **COORDINATE MODEL DONE 2026-07-08.** Construct the nonsplit involution. Pick a nonsquare `d ∈ K`; on `Fin 2 × Fin m → K` use block
   matrix `A(e_i)=f_i`, `A(f_i)=d e_i`, so `A²=dI`. The induced projective map has order 2 and no
   fixed points because a fixed point would give an eigenvalue `λ` with `λ²=d`.
4. **DONE 2026-07-08.** Transport from the coordinate even-rank model to an arbitrary `V` by `LinearEquiv.ofFinrankEq`.

Lean status: `lean/CapGame/Mirror.lean`, `lean/ProjectiveCap/Mirror.lean`, and
`lean/ProjectiveCap/EllipticMirror.lean` now check.  Important theorem names:
`Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution`,
`Projective.initialPStatement_of_linearEquiv_sq_scalar_nonsquare`,
`Projective.initialPStatement_ellipticBlock_of_nonsquare`, and
`Projective.initialPStatement_of_odd_card_finrank_eq_two_mul`.  Verification details are in
[`2026-07-08-codex-residual-mirror-lemma.md`](2026-07-08-codex-residual-mirror-lemma.md).

This supersedes the old false handoff claim that projective spaces never have fpf involutions.

## C26. `[cap]` Bibliography-grade novelty audit for projective Nofil/cap theorem [REPORTED 2026-07-08]

Goal: validate public wording for the claim that the odd-dimensional projective cap theorem is new
in the Nofil / impartial hypergraph-avoidance context.

Current conservative position, recorded in
[`2026-07-07-nofil-connection.md`](2026-07-07-nofil-connection.md): Nofil as a hypergraph game,
pairing strategies, and elliptic projective involutions are all prior art. What appears new is the
application to the 3-uniform collinearity-triple hypergraph of `PG(d,q)` for `q > 2`, especially
the theorem `PG(2m−1,q)=P` for odd `q` by a fixed-point-free projective collineation and
whole-board mirror.

Task:

1. Search MathSciNet/Zentralblatt/Google Scholar/arXiv for exact and variant phrases:
   `Nofil projective space`, `Nofil PG`, `projective cap game`, `cap avoidance game`,
   `impartial misere tic-tac-toe finite geometry`, `Notakto finite geometry`,
   `fixed-point-free involution projective game`, and `Steiner triple system Nofil projective`.
2. Retrieve/verify Clark--Mancini--Van Hook if accessible. Classify precisely whether it is
   partizan colored avoidance, impartial shared avoidance, or both; record whether it contains
   any theorem implying `PG(n,2)` nofil/cap is P.
3. Check HHS 2022 and the 2025 HHS follow-up for any projective-space family theorem beyond
   STS(7)/STS(9), vertex-transitivity `G ∈ {0,1}`, and graph-embedding/hardness.
4. Produce a citable wording recommendation with three tiers:
   "proved here", "standard ingredient", and "adjacent colored/positional-game prior art."

Report file: `notes/2026-07-08-codex-projective-nofil-novelty-audit.md`.

Status: report written. Recommended public wording is conservative: HHS owns the Nofil ruleset
and STS prior art; colored finite-geometry tic-tac-toe is adjacent but different; the apparently
new content is the projective-family outcome theorem in this impartial shared cap/Nofil game,
using standard projective involutions/pairing ingredients.

## C27. `[cap]` Correct residual mirror lemma for cap games [REPORTED 2026-07-08]

Goal: formalize the reusable mirror principle in the form that is actually sound for cap/Nofil
positions.

Semi-formal proof kernel: [`2026-07-08-projective-mirror-proof-kernels.md`](2026-07-08-projective-mirror-proof-kernels.md)
§1 and §6.

Adopted statement shape:

- `σ` is an involutive board equivalence preserving validity/collinearity.
- `S` is a valid position and `σ`-invariant.
- For every legal move `x` from `S`, `σ x ≠ x`, `σ x ∉ S`, and the **two-move extension**
  `S ∪ {x, σ x}` is valid.
- Then `S` is a P-position by replying to `x` with `σ x`.

Important non-statement: do **not** prove or use the weaker claim "legal moves are σ-invariant and
σ has no fixed legal point." That misses the mirror-chord obstruction: a selected point can lie on
the line `xσx`, making the reply illegal after `x` even though `σx` was legal before `x`.

Use cases:

1. Whole-board fixed-point-free collineation lemma for C25, where the chord obstruction is killed
   by `σ`-invariance: if `z ∈ S` lies on `xσx`, then `σz ∈ S` lies on the same line, so `x` was
   already illegal.
2. Characteristic-2 residual translation mirrors, where the chosen translation direction avoids
   the two burned directions and therefore `x,τx` never form a burned pair.
3. Any future fixed-locus-complement residual, but only after separately proving the pair-extension
   condition. "Fixed locus dead" alone is not a certificate.

Report file: `notes/2026-07-08-codex-residual-mirror-lemma.md`.

## C28. `[cap]` MirrorStep/MirrorClosed census and certificate-compression probe [REPORTED 2026-07-08]

Goal: measure whether the corrected residual mirror lemma is useful in the computed odd-plane
ladder, and prepare a terminal certificate rule for future Lean books.

Definitions:

- `MirrorStepGood(S,τ)`: `τ` is an involutive automorphism of the residual game, `S` is
  `τ`-invariant, and every legal move `x` satisfies `τx ≠ x`, `τx ∉ S`, and
  `S ∪ {x,τx}` is valid.
- `MirrorClosed(S,τ)`: every mirror-pair follower above `S` satisfies `MirrorStepGood`; this is the
  terminal P-certificate condition.
- `Obs_τ(S)`: legal moves `x` for which the mirror reply fails the pair-extension test. Geometric
  meaning: the mirror chord `xτx` hits selected/problem structure.

Task:

1. Add a diagnostic mode to the grid solver or a small standalone script that, for a residual
   position `S`, enumerates all residual-game involutions already supported by `all_autos` and
   reports whether any are one-step `MirrorStepGood`; if not, report the minimum `|Obs_τ(S)|` and
   the obstruction type histogram (burned row/col chord, ordinary collinear chord through selected
   point, fixed legal point). If `MirrorStepGood` holds, continue through mirror-pair followers to
   test `MirrorClosed`.
2. Run it on:
   - all canonical size-4 P escape witnesses for q=11 and q=13;
   - all P leaves/subtrees visited by the q=11 certificate book if cheap;
   - a sample of q=17 min-escape classes.
3. Report how many P followers can be closed immediately by a `MirrorClosed` certificate and how
   deep into the reply tree mirror leaves begin to appear.
4. If the hit rate is nontrivial, sketch the certificate format extension: a `PCert` leaf carrying
   `(τ, proof/check of MirrorClosed(S,τ))` instead of an explicit reply subtree.

Non-goal: do not restart the fixed-involution proof route for odd planes. This is certificate
compression and obstruction measurement only.

Report file: `notes/2026-07-08-codex-mirrorgood-census.md`.

Status: diagnostic mode `mir` added to `2026-07-06-grid-cap-solver.rs`.  Size-4 escape-layer
probe was negative: q=11 all P escape children, q=13 all P escape children, and q=17 min-escape
sample all had zero `MirrorStepGood` hits.  Keep `MirrorClosed` as a formal/deep-leaf tool, not as
an immediate size-4 certificate compressor.

## C29. `[cap]` Mixed-column mod-3 law + inverted bucket census at q = 23, 25, 29, 31 [REPORTED 2026-07-08]

Context: C18's null killed bucket-level laws over static features, but it never isolated the
COLUMN-level existence question "does q admit any N-valued on-conic bucket at all". On that
coarser question the data is clean: among unconfined-intruder columns (q ≥ 11), the mixed
columns are exactly `q ≡ 2 (mod 3)` — q = 11, 17 mixed; q = 13, 19 all-P (C15/C20 tables).
Arithmetic meaning: `3 | q+1` ⟺ order-3 elements of PGL(2,q) are elliptic (fixed-point-free
on P¹) ⟺ order-3 products `σ_x σ_x'` sit in free C₆ cycles of the Lemma-VI spectrum
(Grundy-dead by Cor. VII); for `3 | q−1` they are split (two fixed points on P¹) and surface
as tangency-ended path defects carrying nonzero Dawson values. Four data points = a
conjecture generator, nothing more; the predictions are the content: q=23 mixed, q=25 all-P,
q=29 mixed, q=31 all-P. char-3 columns (q=9, 27) are their own regime (q=9 is all-P by
intruder confinement, C13). Any miss REFUTES the law — report verbatim either way; a
refutation is a full-value deliverable.

1. **Mechanism check on EXISTING data first (no game compute):** the per-state `ord(σ_xσ_x')`
   field in `notes/data/c20-q13-q17-states.jsonl.gz` is unanalyzed (C20 review, handoff item
   16). q=17 has elliptic order-3 products (3 | 18), q=13 split (3 | 12). Tabulate ord=3
   occurrences × spectrum component type (free C₆ cycle vs tangency-ended path) ×
   reply-state P/N, per q. Report the table regardless of what the census finds.
2. **Invert the census pipeline so new q are cheap:** bucket FIRST (enumerate on-conic S₄
   parameter 6-subsets up to PGL(2,q) — pure group theory, no solves; C15 recipe), then solve
   ONE representative per bucket (S₄-rooted private-memo solve — orders of magnitude smaller
   than C21's size-3-rooted esc solves; do NOT rerun those). Solve 2–3 extra members of any
   N bucket found, so Lemma I keeps taking falsification pressure instead of being assumed.
3. **Gate before any new q:** rerun the inverted pipeline at q=17 and confirm bucket count
   (10) and labels (5 P / 5 N) byte-identical to the C15/C20 tables.
4. **Sizing gate at q=23:** one S₄-rooted solve under a 30-min wall cap; if exceeded, kill it
   and report where it was — that IS the sizing datum; stop the census.
5. Then q = 25, 29, 31 in that order within budget (GF(25) uses the C6-fixed irred entries;
   the `GF::new` self-check must pass); q=27 optional, flagged as char-3 regime.
6. Report: per-q bucket tables verbatim, the column-law verdict per q, the ord=3 mechanism
   table, and — if any column refutes — the counterexample bucket + representative verbatim.

Budget: hard 8h wall, single-core, ≤ 8 GB.

Report file: `notes/2026-07-08-codex-mod3-column-law.md`.

Status: the mod-3 column law was refuted at q=23.  The bucket-first pipeline validated q=17
against C15/C20 (10 buckets, 5 P / 5 N), then solved all 22 full-PGL on-conic q=23 buckets; every
bucket was P.  q=23 is therefore not a mixed-column case despite `23 == 2 mod 3`.  The report stops
there rather than spending time on q=25/29/31; the next proof-direction task is C31 zone steering,
not further residue-class speculation.

## C30. `[cap]` Route C phase 5 — certificate books for q = 17 and q = 19 [REPORTED 2026-07-10 — certcheck PASS; q17/Class0 split Lean PASS]

Context: the status-table gap "cert book unbuilt" for q=17/19 is pure engineering now — every
feasibility gate is measured: the emitter's private-memo peak fits (C3: q=19 ≈ 32.3M entries),
every q=17 class has escapes (min-escape histogram 5:3 10:12 11:6), C19's reflected checker +
obligation splitting beat the elaboration wall, and C22's transport assembly generalizes over
prime q. Mixed buckets are irrelevant here — books certify size-3 escapes, not the uniform
mechanism. Payoff: the whole computed prime ladder ≤ 19 becomes unconditional in Lean.
Expected anchored class counts: (q−2)(q−3) = 210 at q=17, 272 at q=19 (matches 72/110 at
q=11/13).

1. **Prerequisite — the q=13 staged build: DONE 2026-07-08.**  The split Q13 cert data +
   assembly (`2026-07-08-q13-split-to-lean.py`) built with `nix_lake_build_each` (class leaves
   first, aggregate last), and the final axiom gate is `[propext, Classical.choice,
   Quot.sound]`.  Its per-class-file layout is the template for q=17/19 scale.  Keep the
   CLAUDE.md OOM note: the naive aggregate build OOM'd the box.
2. Emit anchored books for q=17 and q=19 (`cert --anchored`); certcheck PASS mandatory;
   cross-check per-class witness escape counts against the esc histograms.
3. Generate per-class Lean files from the start (generalize the q=13 splitter). Measure
   per-class elaboration on the first ~5 classes and extrapolate; STOP and report if any
   single file projects past the 30-min gate or a per-q total projects past ~10 h — the full
   build at that scale is a user launch decision.
4. Assembly per q: `OddEscapeGameStatement (ZMod 17)` / `(ZMod 19)` →
   `initialPStatement_finrank`; `#print axioms` verbatim, must be
   `[propext, Classical.choice, Quot.sound]` only.
5. Optional if trivial: q=3 (closes the last small prime row). q=9 stays OUT OF SCOPE here
   (GF(9) ≠ `ZMod`; the intruder terminal-reply kernel `218b1ac` is the better lane for it).

Report file: `notes/2026-07-08-codex-route-c-phase5.md`.

Status: anchored certificate emission and independent `certcheck` both PASS for q=17 and q=19.
q=17 has 210 anchored classes, all on-conic witnesses, no capped books, escape histogram
`5:30 10:120 11:60`; q=19 has 272 anchored classes, all on-conic witnesses, no capped books,
escape histogram `211:272`.  The original q17 monolithic generated `Class0.lean` failed at
`class0_nodeChunks_check`.  The first split checker validated q17/Class0, but the full anchored
route remained too slow.  The current route is canonical transport: q17 canonical has 21 classes
and `certcheck` PASS (`100,526` nodes, `232,221` rows); generated canonical assembly compiles
against a stub in 21.8s, using explicit axis-affine / coord-swap transport.  The v5 split moves
node-cap checks out of `ClassNBase` into `ClassNNodeGroup*` leaves; real q17/Class0 timings:
`Class0Base` PASS 0:53.89 (down from an aborted 18:16), `Class0NodeGroup0` PASS 0:43.63,
`Class0StepGroup14` PASS 2:57.48.  No q17/q19 generated Lean data was committed. Fresh
representative timings plus the complete 326-node-leaf/326-step-leaf census project the sequential
q17 build above 21.5 h, so the explicit ~10 h stop gate is now tripped. Next work requires a user
launch decision for that roughly day-long build (or another checker/build-shape reduction); q19
sizing remains after q17 is clean.

## C31. `[cap]` Zone-steering ceiling census (the C20 review's surviving proof shape, made precise) [REPORTED 2026-07-08]

Context: the C20 review's structural reading is that the session-11 snapshot laws hold exactly
while the intruder zone is an O(1) endgame (max zone 2 at q=11 vs 10 at q=13 / 38 at q=17), and
C23 §3(b) asks "does the defense steer the zone back to the small regime?" as an eyeball
question only. Make it a machine-checked quantity. If P2 can *hold* the zone below a small
uniform bound, the proof shape becomes "steering lemma + the small-zone endgame law as
terminal certificate" — the only role the dead snapshot laws validly play. If no bound
exists, that kills the steering picture before proof effort goes in. Either verdict is the
deliverable.

1. **The right object is recursive, not one-ply:** define the steering ceiling
   `Z(S)` for a P-state `S` = 0 if the mover is stuck, else
   `max over opponent moves m of min over winning (P) replies r of max(zone(S+m+r), Z(S+m+r))`
   — the zone size P2 can guarantee never exceeding from `S` under optimal steering. A
   one-ply census can mislead (small now, forced large later); subtrees above size-6 states
   are shallow, so the full recursion is affordable.
2. **Data:** the C20 reply states (`notes/data/c20-q13-q17-states.jsonl.gz`, regenerable
   ~67s), q=13 first, then q=17. Compute `Z(S)` for every P reply-state; solves are
   private-memo, size ≥ 6-rooted (much smaller than the C20 size-5 solves).
3. **Gates:** child P/N labels must reproduce the C20 parent labels where they overlap;
   spot-check ≥ 10 `Z` values by an independent hand-rolled minimax on the smallest states.
4. **Report:** the distribution of `Z` over P reply-states per q (verbatim table); the law
   candidate `Z ≤ B` with the smallest B that holds, or the counterexample state where every
   winning reply blows the zone (verbatim, with its defect spectrum + zone features); zone
   trajectories along one optimal line per bucket, cross-referenced against the C23 diagrams.
5. Budget: hard 8h wall, single-core, ≤ 8 GB.

Report file: `notes/2026-07-08-codex-zone-steering-census.md`.

Status: positive for the steering route through q=17.  Reconstructed C20 P reply-states gave
recursive ceilings `max Z = 2` at q=13 and `max Z = 9` at q=17, despite initial off-conic zones up
to 10 and 38 respectively.  Independent outcome+Z recursion spot-checked 10 states at q=13 and
10 states at q=17.  This keeps the dynamic "steering lemma + bounded-zone terminal law" proof shape
alive; the next math target is to state/prove the bounded-zone family rather than hunt another
static feature law.

Follow-up 2026-07-08: `notes/2026-07-08-codex-zone-descent-target.md` sharpens this.  For every
tested C20 P reply-state at q=13/q=17 and every legal opponent move, a score-optimal winning reply
lands in a grandchild with `Z <= 2`.  At q=17 the `max Z = 9` ceiling is an immediate-zone cost, not
persistent recursion.  The proof target should be a one-pair descent/repair lemma plus a small-zone
`Z <= 2` base law.

Repair-mining follow-up 2026-07-08: `notes/2026-07-08-codex-zone-descent-repair-mining.md` and
`notes/2026-07-08-zone-descent-miner.py` show that q=17's score-9 repairs are all intruder ->
intruder replies that empty the conic residual and leave `defxor = 0`, zone Grundy 0.  The next
math target should be a repair-intruder existence lemma plus the empty-conic/small-Z base law.

Geometry follow-up 2026-07-08: `notes/2026-07-08-codex-zone-repair-geometry.md` and
`notes/2026-07-08-zone-repair-geometry.py` sharpen the worst case: every q=17 score-9 repair has
one live conic parameter before the reply, and the selected reply is the unique legal internal
intruder that kills that last live parameter and leaves a clean P-valued empty-conic state.  The
same guard intruder answers both score-9 opponent moves from a state and is already legal/internal
before those moves.  No single line-type/product-order rule explains the repair.

Follow-up checks: replacing the argmin by "legal internal conic-emptying P reply" works for all
28 score-9 transitions but fails outside that stratum.  The polarity guesses are false
(guard-on-live-polar, guard-as-chord-pole, and live-as-opponent-tangency are all 0/28).  The 14
score-9 states form only two conic-preserving `PGL(2,17)` orbits, even after adding the guard and
the two worst opponent moves, so this layer is a finite-certificate target.

q=19 extension 2026-07-08: `notes/2026-07-08-codex-q19-q25-mining.md` extends the C20/C31
pipeline.  The C20 miner now supports bucket-level `--jobs`; q=19 has 13/13 P buckets, all 1747
legal first intrusions are N-valued, and recursive steering over 63,479 unique P reply states gives
`max Z = 16` with raw zones up to 57.  Durable data: `notes/data/c20-q19.json`,
`notes/data/c20-q19-states.jsonl.gz`, and `notes/data/c31-q19.json`.  The same report adds a Rust
`s4` sizing mode plus S4 dump/query tooling (manual:
[`2026-07-08-s4-memo-dump-query-manual.md`](2026-07-08-s4-memo-dump-query-manual.md)).  The ad hoc
q=25 probe `[1,2,3,4]` is P at about 26.3M private memo entries, while the first full-PGL
canonical bucket representative `[1,2,3,5]` exceeds the 100M memo cap.  GF(25) broad mining needs
a dedicated prime-power path.

## C32. `[cap]` Composite-mirror stuck-free probe — plane variant first, then PG(4,3) (v2) [REPORTED 2026-07-09]

**READ FIRST: [`2026-07-08-evendim-composite-mirror-design.md`](2026-07-08-evendim-composite-mirror-design.md)**
— the v2 design analysis. It corrects the v1 spec (translations are NOT involutions for odd
q — order p; the affine component is FORCED to be point-reflection/tower shape since no fpf
affine involution exists on the odd-count affine part), derives the poison structure (a
selected `h ∈ H` poisons the pencil line through the center `c` in direction `h`; ρ-invariance
of `S ∩ H` makes poisoned pencils come in ρ-pairs), and specifies the **double-pencil-burn
exception rule** (first entry into the `h`-pencil is answered in the `ρh`-pencil; both lines
die whole — even, σ-invariant removal). H-internal soundness is C25 restricted to H. What
remains open is a finite list of LOCAL escape-like obligations (design note §4), chiefly
exception-cell existence — the probe measures exactly those.

Context: with `PG(2m−1,q)` closed (C25) and even q closed, the open boards are the odd-q even
dimensions: planes AND `PG(2m,q)`, m ≥ 2 (the latter in no plan before this). Both have odd
point count and no fpf collineation involution (R0), so the composite (elliptic `ρ` on a
hyperplane `H` + adaptive point reflection `σ_c` on the affine complement + double-burn
exceptions) is the natural — and per the design note, essentially forced — mirror shape. The
**plane variant is genuinely untried**: the 2026-07-05 σ_c failure was post-frame-reduction
(burned opening pair, partial-permutation row/col constraints); this composite never burns an
opening pair (P2 seeds `c` with its own reply, midpoint trick) and `|S ∩ ℓ| ≤ 2` caps the
poison at two pencils. If ANY candidate verifies stuck-free at PG(4,3), that is a theorem
candidate for ALL even dimensions at odd q; if the plane variant verifies at q = 11/13, it is
a candidate uniform odd-plane mechanism. A failure's obstruction histogram is the C28 `Obs`
methodology in the sharper pencil vocabulary. Cheap compute either way.

1. **Plane first (q = 9, 11, 13):** implement the composite as a P2 POLICY (bulk mirror +
   seed rule + ℓ-reply rule + double-burn exceptions + adaptive `ℓ`/`c`/`h'` choices — design
   note §7), verify stuck-freeness against ALL P1 play. Ground truth is known (all P), so a
   failure is an exact counterexample trace. **Mandatory reporting: the diff against
   `2026-07-05-qodd-central-symmetry-findings.md`** — what the grid σ_c patch lacked that
   this has, and whether the failure (if any) is the same mechanism.
2. **Then PG(4,3)** (121 points, max cap 20): same policy with `ρ` = C25's elliptic involution
   on `H ≅ PG(3,3)`, verified fpf + involutive by enumeration. Memoize on reachable
   positions; **sizing gate:** abort + report if reachable distinct positions exceed ~10⁸ or
   wall exceeds 2h per candidate — partial verification is NOT a proof, say so plainly.
3. **Candidate family (document each precisely):** (i) point-reflection composite +
   double-burn (primary); (ii) reflection towers (design note §1 — per-level confined chord
   directions, per-level self-blocking); (iii) variations of the adaptive choices and
   exception-cell selection heuristics. Add better candidates if the failures suggest them —
   record all.
4. **Report per candidate:** stuck-free verdict; obligation failures (design note §4) as
   first-class outcomes with the obstruction histogram by type (poisoned-pencil entry with no
   legal exception cell, ℓ/H-reply nonexistence, seed failure, in-H chord, invariance break)
   + the minimal failing line verbatim; if ANY candidate is stuck-free, the full strategy
   spec + the proof-kernel sketch in the C27 pair-extension vocabulary (do NOT start Lean —
   that would be its own task).
5. Cross-checks: point/line counts against closed forms; the cap checker against an
   independent rank-based collinearity test; plane runs cross-checked against the solved
   ladder values.
6. Budget: hard 8h wall, single-core, ≤ 8 GB.

Report file: `notes/2026-07-08-codex-evendim-composite-mirror.md`.

Status: primary point-reflection composite closed negative.  The plane policy was tested at
q=9/11/13 over all affine seed replies, with P2 existential choice of adaptive infinity reply
and double-pencil exception cells; no seed is stuck-free.  q=9 fails after an infinity pair and
double-pencil exception because a later bulk reflection is illegal; q=11/q=13 fail by
infinity-reply exhaustion after three reflected affine pairs.  The small cases q=3/5/7 still
pass.  The PG(4,3) fixed-elliptic-rho primary variant fails the seed obligation immediately for
all 80 affine seeds: P1 plays `rho^{-1}` of the seed direction, forcing P2's dead seed direction
as the rho reply.  Reflection towers / non-fixed-H variants remain untested new designs, not
continuations of the primary candidate.

## C33. `[cap]` Act on Fable's line-capacity review — correct the framing, redirect the zone hunt [REPORTED 2026-07-09]

**READ FIRST: [`2026-07-09-fable-line-capacity-review.md`](2026-07-09-fable-line-capacity-review.md)**
— Fable's critique of the line-capacity framing (`3863eca`), the six-cell reservoir lemma
(`6699059`), and the q=23 zero-xor/zone steering mining. Read the whole note before touching
anything; the six items are load-bearing and some contradict the current stated next targets.

This task is **planning + corrective action, not a pre-baked recipe.** The review names the
gaps; you decide the concrete steps, sequence, and any machine checks, and record that plan in
the report file before executing. Do not re-litigate the review's math (the matching threshold
`q ≥ 38`, the AG(2,q) blocking-set bound `2q−1`, and the conic/zone coupling are checked); build
on it.

Non-negotiable framing corrections (apply to the handoff + notes, in a commit that cites this
review):

1. **Kill the "reservoir → Hall/matching certificate in the zone" target** as currently stated
   (review §1): counting gives min-degree `q−22`, and a matching via the min-degree≥n/2 lever
   needs `q ≥ 38`, so it is dead at q=23/25/29/31/37 — the entire frontier. Remove or downgrade
   the matching phrasing in
   [`2026-07-09-live-conic-bestreply-mining.md`](2026-07-09-live-conic-bestreply-mining.md)
   (Next-Check #1/#3, §Off-Conic Zone Probe) and the handoff's Near-Term Queue reservoir bullet.
2. **Restate the zone plan as a single `Good`-closure strategy, not a disjunctive sum** (review
   §2/§3 plus the later steering-proof correction): document explicitly that an off-conic zone
   move is itself a conic intruder, so `conic_xor ⊕ zone_value` is not the game value and
   "conic-xor 0" is not preserved by zone play. Reframe the reservoir as the
   **move-availability lemma** inside the `FiniteBuildGame.isP_of_replyStrategy` obligation:
   exhibit `Good` such that every legal move from `S ∈ Good` has some legal reply returning to
   `Good`. Termination is already supplied by that finite placement-game theorem. Flag that a raw
   "pairing-in-the-zone" target is the object C28 already refuted, so keep the two distinct.
3. **Scope the "collapse to capacity-1" claim** (review §5): add the AG(2,q) blocking-set
   obstruction (`min blocking set = 2q−1` > cap size `≤ q+1`, so a whole-board collapse is
   impossible and capacity-2 lines always survive) next to the residual-capacity decomposition
   in the handoff framing. State it positively — it is why the cap game stays strictly harder
   than its Node-Kayles shadow.
4. **Restate the reservoir lemma generally and correctly** (review §4/§6): the general
   `k`-cell bound `q − k − C(k,2) − 1` (note it is vacuous by `k=7` at q=23 — a base-layer fact,
   not a recursion); the incidence-matrix line-load form so column/diagonal/conic reservoirs
   fall out uniformly; the Möbius/hyperbola normal form (≤1 conic point per row) as an explicit
   hypothesis; and drop the "sharp boundary" phrasing (it is the loose bound's vacuity threshold,
   not a real support failure).
5. **Test association-scheme response counts before generic reservoir bounds:** Hollmann--Xiang's
   `PGL(2,q)` conic-stabilizer association schemes give cross-ratio orbitals and intersection
   numbers.  Use the failed q=23 closure obligations as the first test: if candidate reply
   relations have positive exact intersection counts, this is a plausible proof-directed
   alternative to coarse `q − O(1)` row/column availability.

Then plan and (where cheap and reversible) take the corrective mining/proof actions the redirect
implies — e.g. whatever machine check most directly pressures the all-move `Good` closure
obligation (from every candidate-good q=23 zero-xor state, does each legal opponent move have a
legal reply returning to the candidate `Good`, across the full bucket sweep, not just the sampled
roots?), an association-scheme classifier for the failed q=23 obligations, or a clean paper/Lean
statement of that closure invariant. Size any q=25/q≥23 solve first; no new campaigns without a
gate. If a correction turns out to be wrong on closer reading, say so verbatim in the report — a
refutation of one of Fable's six items is a full-value deliverable.

Report file: `notes/2026-07-09-codex-line-capacity-followup.md`.

## C34. `[cap]` Assemble the D1 outcome-classes manuscript skeleton (the flag-planting paper) [REPORTED 2026-07-09]

**READ FIRST:** [`2026-07-09-stepping-stone-deliverables-proposal.md`](2026-07-09-stepping-stone-deliverables-proposal.md)
(D1 + the umbrella framing and novelty guards), the C26 novelty audit
[`2026-07-08-codex-projective-nofil-novelty-audit.md`](2026-07-08-codex-projective-nofil-novelty-audit.md),
[`2026-07-07-nofil-connection.md`](2026-07-07-nofil-connection.md), the program map
[`handoffs/2026-07-06-projective-cap-game-handoff.md`](handoffs/2026-07-06-projective-cap-game-handoff.md),
and the falsification-mode / proof-by-elimination map
[`2026-07-09-odd-plane-falsification-map.md`](2026-07-09-odd-plane-falsification-map.md) (source for
the §why-a-conjecture / what-would-falsify bridge and the "conjecture false ⟺ trapped size-3"
framing in item 3's spine).

Goal: a **manuscript skeleton** for D1 — "Outcome classes of the Nofil/cap achievement game on
finite geometries" — assembled from what is already proven. This is a writing/assembly task, no
game compute and no new proofs. The output is a scaffold a human (or a later Lean/writing task)
fills in, not a finished paper. Deliverable is a self-describing markdown draft with every claim
tagged by evidence status.

1. **Inventory the proven results, verbatim.** For each of the four closed families
   (`AG(n,q)` P; `PG(n,2)` P; `PG(2m−1,q)` P for odd `q`; `PG(2,q)` P for even `q`), pull the
   **exact Lean theorem statement and name** from the source files (handoff §Closed Higher-
   Dimensional Families lists the names: `initialPStatement_binary_of_finrank_ge_two`,
   `initialPStatement_of_odd_card_finrank_eq_two_mul`,
   `initialPStatement_of_even_card_finrank`, the affine theorem, etc.). Do not paraphrase the
   statements — quote them and cite file + theorem name. Where a family is proven on paper but not
   Lean, say so.
2. **Build the evidence table for the odd-plane conjecture.** Reproduce the handoff's Status
   Table — PG(2,q) (value, proof state, remaining gap per `q` through 23/25), as the paper's
   "computational evidence" figure. Tag each row [LEAN] / [COMPUTED] / [CONDITIONAL] exactly as
   the handoff has it; do not upgrade any status.
3. **Write the section skeleton** (headers + one-paragraph intent + claim stubs, NOT full proofs).
   Suggested spine, adjust as the material dictates:
   - Abstract + intro carrying the two umbrella hooks (cap-set cousin; exact outcome classes for
     infinite families are the unusual thing) and the Segre's-theorem engine framing.
   - Preliminaries: the impartial Nofil/cap game, normal play, the line-capacity umbrella
     (capacity-1 queens vs capacity-2 cap), Sprague–Grundy setup.
   - Four theorem sections, each: statement (quoted), proof-mechanism sketch (mirror/involution/
     translation), pointer to the Lean theorem.
   - The odd-plane conjecture + evidence table + the conic-localization reduction as the "why this
     is tractable, not mysterious" bridge (forward-reference D3).
   - Related work + the tiered novelty positioning (proved here / standard ingredient / adjacent
     colored-avoidance prior art), lifted from C26.
   - The normal-play-vs-misère caveat.
4. **Bibliography stub.** One entry per external anchor the framing leans on, each with a
   one-line "used for" note: Segre 1955 (ovals are conics, odd `q`); Croot–Lev–Pach /
   Ellenberg–Gijswijt 2016 (cap-set max size — cousin problem); Schaefer 1978 (Node-Kayles
   PSPACE-complete); HHS (Nofil ruleset + STS prior art); Guy / A002187 (Dawson's chess, octal
   games — for the D3 forward-reference); the pairing-strategy / Beck / Harary achievement-game
   line; Clark–Mancini–Van Hook (adjacent partizan colored avoidance). **Do not invent citation
   details you cannot verify** — mark any unverified reference `[VERIFY]` rather than fabricating
   page/volume data; the C26 audit and nofil-connection note have the checked ones.
5. **Readiness audit (the report's core).** Per section, a one-line status: ready-to-expand /
   needs-a-proof-written / needs-a-decision-from-user (e.g. how much odd-plane evidence to
   include, whether D4's verified ladder ships inside D1 or as a companion). End with a short
   "gaps before submission" list. A section that is *not* ready is a first-class finding — say so
   plainly, do not paper over it.

Guardrails: assembly + quotation only — write no new proofs and prove nothing; never upgrade a
[COMPUTED]/[CONDITIONAL] result to [PROVEN]; no fabricated citations; keep the umbrella/novelty
wording conservative per C26 (structured finite-incidence subfamily, not a new game class).

**Amendment (Fable, 2026-07-09 second pass; updated after C41):** (i) C41 has now landed, so state
the falsification equivalence bidirectionally using
`GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank`; keep the usual
Lean/spec-match caveat. (ii) The open set is larger than the
odd-plane row: the uniform family `PG(2m,q)`, `m ≥ 2`, odd `q` remains open, while C43 now gives
the first direct datum, **`PG(4,3) = P`** (C32 was a policy probe, not a solve) — the
status/evidence table and section skeleton must state both facts plainly, not silently scope to
planes.

Deliverable: the skeleton draft at `notes/2026-07-09-d1-outcome-classes-manuscript.md`.
Report file: `notes/2026-07-09-codex-d1-manuscript-skeleton.md` (the readiness audit + gaps list +
what was quoted vs stubbed vs flagged `[VERIFY]`).

## C35. `[cap]` Nimber (Grundy) oracle — make the S4 dump measure the conic⊕zone coupling [REPORTED 2026-07-09]

**READ FIRST:** the S4 manual [`2026-07-08-s4-memo-dump-query-manual.md`](2026-07-08-s4-memo-dump-query-manual.md)
and Fable's review §2 [`2026-07-09-fable-line-capacity-review.md`](2026-07-09-fable-line-capacity-review.md).

Context: the whole conic program reasons in **Grundy values** — `conic_nk_xor`, Dawson path
values, "even cycles are Grundy-0, the bulk cancels." But the solver and every dump store only
P/N (nimber `== 0` vs `≠ 0`). So the graph-derived `conic_nk_xor` has **never been checked against
the position's true Grundy value**, and the conic⊕zone disjunctive-sum decomposition the steering
plan leans on (challenged by the review: off-conic zone moves *are* conic intruders) has never been
measured. Make the dump a nimber oracle and measure the gap. This is the instrument for the
coupling question — the one thing the current tool cannot answer.

1. **Extend the S4-local solver to compute exact Grundy values** (`mex` over children's Grundy)
   instead of the mover-wins boolean. This loses the boolean short-circuit (all children must be
   evaluated), so it is slower and the memo is larger — **size it first**: an exact q=17 root, wall
   + record count vs the P/N dump, extrapolate, gate by cap/wall. Bound nimbers (store `u8`, assert
   `< 64` or report the true max observed).
2. **New dump format version** (bump magic/version; value encoding = nimber byte; P/N derivable as
   `nimber == 0`; keep every header guard). **Validation gate:** on shared canonical keys, `nimber
   == 0 ⟺ P` in the existing P/N dump — must be 100% before any measurement.
3. **Measurement pass (the deliverable):** over a corpus of S5/S6 states, tabulate the true Grundy
   value against the predicted `conic_nk_xor`; report the distribution of
   `true_g XOR predicted_conic_xor` — the *coupling residual*. Where the zone Grundy is also
   computable, test `g(pos) == g_conic XOR g_zone` and report the agreement rate and, on mismatch,
   the structure of the discrepancy.
4. **Report:** solver-extension cost, max nimber observed, the coupling-residual distribution, and
   a verdict on whether the game decomposes as a conic⊕zone sum at the S5/S6 layer. A "does not
   decompose" verdict with the residual structure is a full-value deliverable — it is exactly what
   the review predicts and what redirects the zone proof to a maintenance argument.

Guardrails: shallow layer only (S5/S6); validate `nimber==0` against P/N dumps before measuring;
nimber dumps are bigger — do not launch a large-`q` Grundy dump without the sizing gate.
Budget: hard 8h wall, single-core, ≤ 8 GB. Report file: `notes/2026-07-09-codex-nimber-oracle.md`.

## C36. `[cap]` Cross-q combinatorial-type value alignment — localize the uniform-theorem obstruction [REPORTED 2026-07-09]

Context: S4 roots are conic-normalized (`r·c = 1`) and canonically keyed, so a reachable state has
a **q-independent combinatorial type**. Running the same query across the q=17/19/23 exact dumps and
finding the types whose value is *not q-constant* isolates the entire difficulty of the uniform
odd-plane theorem to a finite list; the complementary outcome (q-constant on every shared type) is
strong evidence a uniform type→value law exists. Free — uses the existing P/N oracle; regenerate the
q=17/19/23 exact S4 dumps as needed (per-root, shallow, cheap).

1. **Define the type precisely, in the report:** a q-independent signature of an S5/S6 state — the
   conic-graph iso-type (path/cycle/isolate size multiset + intruder-incidence pattern), a coarse
   q-independent zone signature (row/col support, bucketed degree profile), ply, and geometry
   counts. State it explicitly and reproducibly; it is a hash of geometric *shape*, NOT the
   field-specific canon key.
2. **Self-consistency gate FIRST (mandatory):** within a single q, every state of a given type must
   share a value. If not, the type is too coarse — report the collision verbatim and refine, or
   report that refinement fails. Cross-q claims are void until this passes.
3. **Alignment:** for types with a KNOWN value (skip unknowns) in ≥ 2 of {q=17,19,23}, tabulate
   `value(type, q)`. Deliverable: the list of **types with non-constant value across q** (the
   obstruction set) with representatives; or, if none, the count of shared types that are q-constant.
4. **Report the verdict either way.** A non-constant type is the most proof-relevant object this
   program can currently produce; a fully q-constant shared table is strong uniform-proof evidence
   and directly feeds D3.

Guardrails: known values only; the self-consistency gate is non-negotiable; the type definition
must be stated so a reader can reproduce it. Budget: hard 8h wall, single-core, ≤ 8 GB.
Report file: `notes/2026-07-09-codex-cross-q-type-alignment.md`.

Status: reported 2026-07-09.  The q-blind coarse shape failed self-consistency with one q=19
mixed-value collision.  A strict normalized-coordinate type passed self-consistency and found 1,364
shared S5/S6 types across at least two of q=17/19/23, with 281 nonconstant value rows.  Full table:
`rust/s4-dumps/2026-07-09/c36-analysis/nonconstant-strict-types.tsv`.

## C37. `[cap]` Cross-root shared-key agreement — scaled soundness check + state-complexity number [REPORTED 2026-07-09]

Context: distinct S4 roots' exact dumps **overlap** — positions reachable from both canonicalize to
the same key. Agreement on shared keys is a test of `canon()` soundness (the C8 concern that the
128-bit fingerprint could silently merge distinct positions) across *millions* of positions, not
just small-`q` class counts; the overlap size is the symmetry-quotiented shared-core state count.
Cheap, uses existing raw dumps, and hardens the D4 verification story.

1. **Add a raw-dump intersection check** — a small Rust mode (e.g. `s4isect`) reading two or more
   raw files, or a script consuming the documented raw format. **RAW dumps only** — compact
   archives have membership false positives by design (manual §Raw Versus Compact). For every
   shared canonical key across a pair, assert equal value; collect all disagreements.
2. **Run it** across the q=23 bucket dumps (the 22 roots) and the q=19 buckets. Sanity guard: dumps
   for different q / GF encodings must share **zero** keys (root-mismatch + GF-hash headers should
   already prevent cross-q mixing). **Any P-vs-N disagreement on a shared key is a MAJOR finding**
   (solver bug or canon collision) — report it verbatim and STOP for triage; do NOT "fix."
3. **Report** pairwise + union overlap sizes → the shared-core state count modulo symmetry, and the
   agreement result. Clean agreement across the full shared corpus is the concrete verification
   statement D1/D4 can cite ("N million position values cross-validated via the shared canonical
   key, zero disagreements").

Guardrails: RAW only; document the exact key/value byte layout read; treat any disagreement as
stop-and-report, never as something to patch. Budget: 4h wall, single-core, ≤ 8 GB.
Report file: `notes/2026-07-09-codex-shared-key-agreement.md`.

## C38. `[cap]` Tablebase strategy distillation — the forced-move skeleton corpus-wide [REPORTED 2026-07-09]

Context: the `replies`/query DAG exposes the full winning-strategy graph. Corpus-wide, the mover
nodes with a **unique** winning move are *forced* — the skeleton any strategy-level proof, and the
maintenance strategy from the C33 reframe, must reproduce. C31's repair-geometry did this by hand on
the q=17 score-9 slice; do it over the whole exact dump. Uses the P/N oracle (free); richer once C35
nimbers exist.

1. **Enumerate winning moves per node.** State the parity convention explicitly: at a mover-wins
   (`N`) node the winning moves are the children with value `P`. Over an exact dump, for every
   reached `N` node count `|winning moves|` — the *strategy freedom*.
2. **Forced set:** nodes with exactly one winning move. Characterize them — ply, geometry, conic
   graph type, zone signature, and whether the forced move is on-conic / intruder / conic-emptying
   (reuse the C31 repair-geometry vocabulary). These pin the invariant.
3. **Freedom distribution** across the corpus: where it is 1 (forced) vs large (free). A simple
   selection rule can exist only where the freedom is structured.
4. **Report** the forced-node characterization + the freedom distribution, and cross-reference the
   C31 score-9 guard intruders — are they a subset of the corpus-wide forced set? A clean
   characterization of the forced skeleton is the target.

Guardrails: exact dumps only (partial dumps mislabel `unknown` children as non-winning — restrict to
fully-known subtrees, or treat any `unknown` child as disqualifying the node from the forced count
and report how many nodes that excludes). Budget: hard 8h wall, single-core, ≤ 8 GB.
Report file: `notes/2026-07-09-codex-tablebase-distillation.md`.

## C39. `[cap]` Remoteness/suspense — a dynamic monovariant (C18's null was static-only) [REPORTED 2026-07-09]

Context: C18 killed shallow laws over **static** features of the position. Remoteness (Conway) is a
**dynamic** quantity — how fast the winner can force / the loser delay — and has never been computed
here. Compute it over the S4 subtree from the value oracle and hunt for a monovariant P2 controls.

1. **Compute remoteness** via the tree walk + values: remoteness 0 at a terminal; at an `N` node
   `1 + min` over `P`-children remoteness (winner hastens); at a `P` node `1 + max` over `N`-children
   remoteness (loser delays). A small walk/solver addition.
2. **Probe** on the q=13/17 exact dumps: tabulate remoteness by ply/geometry; check whether P2's
   optimal replies control remoteness parity or keep it bounded, and whether remoteness correlates
   with the C31 zone-size / defXOR features that the static pass missed.
3. **Report** the remoteness distribution and a verdict on a dynamic monovariant. A null is a valid
   deliverable — it rules out the dynamic-potential hypothesis cleanly.

Guardrails: exact dumps; exploratory — cap depth. Budget: 4h wall, single-core, ≤ 8 GB.
Report file: `notes/2026-07-09-codex-remoteness-probe.md`.

Status: implemented native `s4gremote` and reported.  q=13 root, q=17 full-PGL bucket corpus, the
two q=17 score-9 representatives, and optional q=19 root all traversed exactly
(`seen == records`, no missing states/children).  q=17 full corpus has max remoteness 10, but only
105 / 1,537,648 states attain it; parity is the expected normal-play tautology (`P` even, `N`
odd).  `defxor` and zone size stratify average suspense but do not decide value or remoteness.
Verdict: useful diagnostic, not a standalone dynamic monovariant.

## C40. `[cap]` Oracle-driven winline generation (feeds C23)

Context: C23 (winline viz) needs optimal lines to terminal and planned a separate solve. The
`s4query` `play`/`pop` stack + value oracle already walks optimal lines by lookup — use it to drive
the S4-rooted lines instead of a separate solver. This is an enabler/amendment to C23, not a new
research direction.

1. A small mode/script that, given a dump and root, emits one optimal (win-preserving) line to
   terminal by querying values along `play`/`pop` — a winning child at each mover node, a
   value-preserving reply at each defender node — with the per-ply NK snapshot fields (defect
   spectrum, defXOR, zone size/parity) alongside.
2. Feed C23's rendering spec; this replaces C23 §1's separate-solve step **for S4-rooted lines
   only** — the empty-board defense lines (C23 §1(a)) still need their own solve, out of scope here.

Guardrails: exact dumps; the independent legality + terminal-maximality checks from C23 §4 still
apply to every emitted line. Budget: 3h wall, single-core, ≤ 8 GB.
Report file: append a `## C40 oracle-driven lines` section to
`notes/2026-07-08-codex-winline-viz.md`.

Status: corrections applied to the handoff, `2026-07-09-live-conic-bestreply-mining.md`, and
`2026-07-09-live-conic-steering-plan.md`.  The reservoir/Hall/pairing target is killed as a proof
route below q=38; zero-xor steering is now framed as a candidate component of a single
`FiniteBuildGame.isP_of_replyStrategy` `Good`-closure invariant; the reservoir is a base-layer
move-availability lemma; and whole-board capacity-1 collapse is scoped out by the AG(2,q)
blocking-set obstruction.  Existing
q=23 all-bucket `s4xormine` logs were re-parsed only as a cheap first-ply closure-availability check
(5734/5734 hits, selected `zone_rows = zone_cols = 17`, no new solves).

## C41. `[cap]` Lean-certify the trapped ⇒ N converse (close the falsification equivalence) [REPORTED 2026-07-09]

**READ FIRST:** [`2026-07-09-odd-plane-falsification-map.md`](2026-07-09-odd-plane-falsification-map.md)
§1 — it names this gap precisely. Only the elimination direction was Lean-proven before C41
(`OddEscapeGameStatement` → `initialPStatement_of_oddEscapeStatement_finrank`). C41 now supplies
the converse: a trapped size-3 residual position (all `q²−9q+21` size-4 children N) implies
`PG(2,q)` is N. The task record below is kept as the original proof request plus the result status.

Expected proof route (verify, don't trust — this is a sketch, not a checked argument):

1. A trapped position has all children N, hence is a P-position (`q²−9q+21 > 0` ensures it is
   nonterminal, so the trap is a value failure, not a stalled position).
2. The trapped residual size-3 corresponds to a projective 5-cap (opening pair + 3 cells; the
   row/column constraints are exactly caps through the two opening points). Any 4 of its 5 points
   form a frame; PGL is transitive on frames, so a collineation carries the trap to a child of THE
   standard frame position.
3. Game values are collineation-invariant (transport machinery exists), so the standard frame has
   a P-valued child ⇒ the frame position is N ⇒ root is N via the proven chain
   `initialPStatement_iff_isP_frame_of_finrank`.

Task:

1. Write the informal proof kernel first (one note section): the exact quantifier/parity
   structure, where frame-transitivity, extendability, and value transport are each used, and any
   gap in the sketch above — if the route needs a hypothesis the sketch missed, that is a
   full-value finding (it changes D1's phrasing) — report it verbatim and stop before Lean work.
2. Lean: state and prove the converse, targeting the iff
   `InitialPStatement ↔ OddEscapeGameStatement` (or the missing direction as a standalone
   theorem). Reuse `PlaneTransitivity.lean` (frame reduction, transitivity),
   `ExtensionCount.lean`, and the existing value-transport lemmas. Statement-level minimum if the
   proof stalls; report exactly which obligation blocks.
3. Axiom gate on anything proved: `#print axioms` verbatim, must be
   `[propext, Classical.choice, Quot.sound]` only.
4. Update obligation: on success, the falsification map §1 and the D1 skeleton may state the
   equivalence bidirectionally — note this in the report; do not edit those docs beyond a pointer
   unless trivial.

Budget: proof task; machine work is nil. Report file: `notes/2026-07-09-codex-trap-converse.md`.

Status: **PROVED in Lean** (2026-07-09). Added `ProjectiveCap.TrapConverse` and proved
`GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank`, closing the missing
converse. Axiom gate is exactly `[propext, Classical.choice, Quot.sound]`. D1/falsification
phrasing may now use the bidirectional equivalence, modulo the existing Lean spec-match caveat.

## C42. `[cap]` Fixed-q census propagation — the rescoped surviving half of the concentration factorization [REPORTED 2026-07-09]

**READ FIRST:** [`2026-07-09-onconic-child-type-alignment.md`](2026-07-09-onconic-child-type-alignment.md)
— it adjudicated this task's original premise, half each way, before the task ran — then
[`2026-07-09-witness-count-heuristic.md`](2026-07-09-witness-count-heuristic.md) §6 and the
falsification map §5–§6.

**Rescope (2026-07-09, post-alignment-report).** The original hypothesis was
`value = f(q-independent type)` × `class-uniform type census` ⇒ the observed P-count point mass.
The alignment test settled the first factor:

- **Within-q type-determinism: CONFIRMED.** Exact-orbit self-consistency passes with zero
  violations for BOTH the burned-pair stabilizer and full PGL at q = 5..19 (report §4).
- **q-independence: REFUTED.** 119 shared integral configurations flip value across q, perfectly
  systematically — N exactly at the arc-depleted orders q ∈ {11,17}, P elsewhere. No finite
  q-uniform type→value table exists; the falsification map §5/§6 records that route as closed
  negative, and the *anchor* half of the uniform (ON) bound merges into the arc-depletion
  arithmetic (A5). Character signatures also fail within-q (report §4) — work with exact orbits
  only, not character invariants.

What survives — and is this task — is the **propagation half, a fixed-q statement the report
explicitly left untouched** (its §6: class stability "may still hold at fixed q"): how does each
size-3 class distribute its q−4 on-conic children over the exact stabilizer orbits, and how much
can that census vary class-to-class? The onP histograms already bound the answer away from perfect
uniformity at the depleted orders (q=11 has classes at 2 and 5; q=17 at 1 and 3), so the target is
the **bounded-variation** form — the heuristic §6's class-stability constant `C` — as a value-free
geometry quantity. Division of labor for the uniform (ON) bound after the alignment verdict:
depletion arithmetic (A5) must supply the *anchor* (enough P-orbits exist at every q); census
propagation must supply the *stability* (every class reaches them, up to `C`). This task measures
the second.

1. **Census table:** from the on-disk feat censuses (`notes/data/codex-feat{5,7,11,13,17,19}.out`,
   no new solves), for each q and each size-3 class: the census vector = count of on-conic
   children per exact stabilizer orbit (alignment-script machinery — reuse it; commit it if still
   untracked). Report per q the census variation across classes: the full vector (measurable
   value-blind at the all-P orders q=13,19 — the clean pure-geometry test) and its projection onto
   that q's P-orbits (the class-stability constant `C` at the depleted orders q=11,17).
2. **Localize the variation:** at q=11/17, which orbits absorb the class-to-class difference
   (2 vs 5; 1 vs 3)? Is the differing sub-census geometrically characterizable? A clean
   characterization is the lemma candidate; scattered variation is a reportable negative.
3. **Verdict logic:** (i) full-vector census uniform at q=13/19 and bounded-variation at q=11/17 ⇒
   state the census identity/bound as a precise value-free conjecture and attempt a counting proof
   at one small q, noting whether the proof structure is q-generic. (ii) census wildly non-uniform
   even at the all-P orders ⇒ the propagation half is dead too — report verbatim; the (ON) route
   then rests entirely on A5 arithmetic.
4. **Gates:** your census's P-orbit projections must reproduce the alignment report's onP
   histograms byte-for-byte (`q=11 {2:2, 5:6}`, `q=17 {1:3, 3:18}`, etc.); orbit machinery must
   match the report's §2 method.

Budget: 4h wall, single-core, ≤ 8 GB (no new solves).
Report file: `notes/2026-07-09-codex-type-census-uniformity.md`.

Status: **NEGATIVE** (2026-07-09). The value-blind stabilizer census is non-uniform even at the
all-P orders: every size-3 class has a distinct full census vector (12/12 at q=13, 27/27 at
q=19), so the uniform onP counts there come from every observed orbit being P-valued, not from
uniform geometry. At the depleted orders the onP variation (q=11: 2..5, q=17: 1..3) is scattered
across all P-valued stabilizer orbits (10/10 at q=11, 21/21 at q=17) with no clean sub-census
characterization. Per verdict logic (ii): the propagation half of the factorization is dead, and
the uniform (ON) route now rests entirely on A5 depletion arithmetic. The class-stability
constant remains an empirical fact with no census mechanism behind it. C47's dichotomy row takes
its negative branch.

## C43. `[cap]` PG(4,3) exact-solve sizing — the former even-dimensional evidence vacuum [REPORTED 2026-07-09 — Claude/Opus — **PG(4,3) = P**]

**Result: PG(4,3) = P (second-player win).** The sizing showed the raw state space is
~10¹³ (infeasible) but the PGL(5,3)-orbit space is only low-tens-of-thousands, so an exact
orbit-canon solve is feasible. Built a compiled Rust orbit-canon solver
(`notes/2026-07-09-pg43-solver.rs`); it solves PG(4,3) in 3.7 s / 25,258 states. First
even-dimensional odd-q outcome (was a total evidence vacuum) — it is **P**, consistent with
the all-P conjecture, not the seismic N. Cross-checked: calibration ladder (PG(2,3/5/7)=P,
PG(3,3)=P, matching the raw Python solver), forward+reverse move orderings both P,
independent IR canon. Report: [`2026-07-09-codex-pg43-sizing.md`](2026-07-09-codex-pg43-sizing.md).
Next: extract the PG(4,3) winning 2nd-player strategy for the pairing-hunt; PG(4,5)/PG(6,3)
need a wider-than-128-bit board word first (781/1093 points).

Historical task context: at task creation, D1's outcome-classification table had an entire family
with **zero direct outcome evidence**: `PG(2m,q)`, `m ≥ 2`, odd `q`. PG(3,3) is odd projective
dimension (closed by C25); PG(4,2) is q=2 (closed by C24); and C32 was a *policy* probe, not a
solve.  The completed C43 solve above replaced that vacuum with the first direct datum,
`PG(4,3) = P`; the uniform family remains open.

Board: PG(4,3) = 121 points, max cap 20 (known), |PGL(5,3)| ≈ 2.4e11 — symmetry is enormous, the
question is whether canonicalization makes the reachable class space tractable.

1. **Sizing first, verdict second.** Extend the exhaustive projective solver
   (`2026-07-05-proj-cap-fast.py` solved PG(3,3)/PG(4,2); port to Rust only if the probe says the
   space is borderline) with: memoization on a canonical form under a practical symmetry subgroup
   (document which — full PGL(5,3) canonicalization per node may be too slow; a cheap invariant +
   fingerprint layer per the grid solver's `canon()` pattern is acceptable for sizing, flagged as
   unsound-for-proof), a hard memo cap, and depth/width telemetry.
2. **Probe:** capped run (2h wall, ≤ 8 GB). Report the growth curve (distinct classes per ply),
   where it dies or completes, and an extrapolated full-solve cost. An HLL-style distinct-state
   estimate (the queens `count` pattern) is a valid substitute for an exact memo count.
3. **Reduction option:** if raw sizing is hopeless, report what a rank-5 frame-reduction analog
   buys (transitivity up to frames = 6 points in general position prunes the first plies only) and
   whether an opening-structure residual (the rank-3 trick that created the grid game) has a
   rank-5 analog worth designing. Analysis only — no new solver build beyond the probe.
4. **If (and only if) the extrapolation says the full solve fits comfortably** (≤ 8h, ≤ 8 GB):
   run it. Verdict + node/class counts + wall verbatim. A completed verdict must be cross-checked:
   re-run with a different move ordering or symmetry subgroup and confirm the same value. If N:
   stop-and-report, do not chase follow-ups.
5. Launching anything past 8h is a user decision — report the sizing and stop.

Budget: hard 8h wall, single-core, ≤ 8 GB. Report file: `notes/2026-07-09-codex-pg43-sizing.md`.

## C44. `[cap]` GF(25) prime-power path + q=25 on-conic bucket census (the Baer falsification watch)

**[REPORTED 2026-07-10 (Claude) — COMPLETE: all 28 buckets P, q=25 is NOT depleted.]**
Report: [`2026-07-09-codex-q25-baer-census.md`](2026-07-09-codex-q25-baer-census.md).
GF(25) path in place (`irred(25)=x²+3` over F₅, nonsquare; self-check ok; MAXW ok); **28
full-PGL(2,25) on-conic buckets** enumerated. RAM wall (FnvMap 33 B/slot, rehashes, blows 8 GB on
generic buckets) fixed by building **`s4arena`** (commit `60c87fb`) — S4 labeling on the 16-byte
`Shard` arena (fixed pre-alloc, no rehash), validated byte-identical to FnvMap (labels + distinct-class
counts match C54). Full census ran `s4arena 25 --all --log2 29` (8 GB): **28/28 P, 0 N, 0 aborted**,
~6.67 h summed bucket wall time (largest bucket 257.2M positions). **`D(25)=0`, `min-witness(25)=q−4=21`
(full), `ν(25)=0`** — q=25 joins the non-depleted set `{5,7,9,13,19,23,25}`; the C68 `2 → 1 → ?` slide
across `{11,17}` does **not** continue at the first square order, it rebounds fully. Cross-validated by
C74's independent value-blind row-7 analysis (the sole previously-uncovered orbit: `f_10=f_14=f_16=f_17
=P`, `R7=21` all-P). Concurrence-point ESC test (C73 §7 step 0) left un-run — moot per C74 §6 once the
on-conic census is complete and all-P ("non-depleted ∧ L-fails" is logically impossible); L's stress
test now waits for the next genuinely depleted order. Full census results + original spec remaining
below.

Context: the falsification map names square `q` (Baer subplanes — extra dense collinearity) the
**top falsification watch** (A4), the (ON) layer sits at a knife edge (§6), and q=25 is also where
the field-arithmetic bugs have lived (C6) — yet q=25 work exists only as ad hoc probes
(`[1,2,3,4]` P at ~26.3M memo entries; `[1,2,3,5]` blew the 100M cap) and a prose aside ("needs a
dedicated prime-power path"). Make it a task. q=49 is explicitly out of scope; q=27 is char-3, a
different regime, also out of scope. The on-conic child type-alignment verdict
([`2026-07-09-onconic-child-type-alignment.md`](2026-07-09-onconic-child-type-alignment.md))
raises the stakes: on-conic values flip N exactly at the **arc-depleted** orders (11, 17), so
q=25's depletion status — depleted like 11/17 or full like 13/19 — is now the single most
informative new number for the (ON) route, independent of the Baer watch.

1. **The prime-power path:** whatever the S4 dump/query/mining stack needs to treat GF(25)
   first-class — canonical keying over the GF(25) encoding, the GF-hash header guards, and the
   `GF::new` zero-divisor/inverse self-check passing (C6). Document the field representation
   verbatim in the report. No broad runs until the path's small-q regression passes: rerun one
   q=9 or q=13 known case through the same code path, byte-identical to the prime-path output.
2. **Bucket enumeration (group theory, no solves):** on-conic S4 parameter 6-subsets up to the
   canonical group at q=25. **Default to PGL(2,25)**: by the full-PGL bridge, these buckets are
   game-value sound once C53's formal statement/proof is in place.  If using PΓL(2,25) to shrink
   the bucket count, document the extra semilinear/Frobenius transport obligation separately; do
   not conflate it with the now-closed full-PGL bridge.  Emit the stabilizer-refined signature only
   as a diagnostic/refinement, not as the soundness boundary.
3. **Representative solves:** S4-rooted private-memo solves per bucket, 30-min wall gate per
   representative, chunked `s4xormine` machinery where applicable. Any representative exceeding
   the gate: kill, record as the sizing datum, move on — partial coverage honestly labeled beats
   a stalled census. Solve 2–3 extra members of any N bucket found (Lemma-I falsification
   pressure, per the C29 protocol).
4. **The falsification read:** any N bucket at q=25 — the first square order past the confined
   regime — is a MAJOR finding: report verbatim, stop, do not "fix". All-P is also a full
   deliverable: it retires the sharpest A4 instance short of q=49 and adds the first square-order
   column to the cross-q alignment (C36) corpora.
5. Optional, gated: if the feat-layer (per-size-3-class on-conic witness counts) is affordable at
   q=25 under an hour-scale gate, add the q=25 rows to the witness-count heuristic layers (the §6
   knife-edge extrapolation currently ends at q=19). If not affordable, say so — do not force it.
6. Former optional rider dropped: do **not** run duplicate stabilizer-representative q=23 solves
   as a B3 discharge.  The bridge is geometric/proof-side; C53 is the right work item.
7. **(ON)-bifurcation pre-registration (Fable eleventh pass, 2026-07-10) — read the outcome
   against the (ON)-vs-conjecture split, fixed BEFORE the census completes:**
   - (i) N *buckets* at q=25 are expected if q=25 is arc-depleted (q=11/17 both have them) and are
     not by themselves a falsification of anything — they answer the depletion-status question.
   - (ii) a size-3 class with ZERO on-conic P completions (min-witness 0, `maxonN(25) = 21`)
     kills the **(ON) route only**, not the conjecture — the plane can still be P via off-conic
     escapes (at q=17's knife-edge class the root keeps 5 total escapes, 4 off-conic).  The
     pre-registered response is a pivot to off-conic escape structure, not a program failure.
   - (iii) a genuinely trapped size-3 (ALL `q²−9q+21` children N, on- and off-conic) is the
     conjecture counterexample — item 4's verbatim-report-and-stop rule applies.
   - **Fallback-quantification rider [REPORTED 2026-07-10 (Claude/Opus)]:** per-class OFF-conic
     escape counts computed at q=5..19
     ([`2026-07-10-offconic-escape-margin.md`](2026-07-10-offconic-escape-margin.md); script
     `rust/scripts/c44_offconic_escape_margin.py`).  Worst-class off-conic margin `8 → 4` across
     the depleted orders {11,17} — nonzero (the (ii)-pivot layer exists) but **modest and trending
     adverse**, and at q=17 the two layers **co-deplete**: the three knife-edge on-conic classes
     (onP=1) are exactly the three worst off-conic classes (off=4; the spec's 5-total/4-off-conic
     knife-edge datum verified).  At q=11 they anti-align (knife-edge class has off=16).  If the
     q=17 alignment persists, the first min-witness-0 class at a larger depleted order is also the
     most off-conic-thin — the adverse case for the pivot.  q=25 extends both trends.

Budget: hard 8h wall, single-core, ≤ 8 GB. Report file: `notes/2026-07-09-codex-q25-baer-census.md`.

## C45. `[cap]` Game-valued defect-skeleton refinement — beyond classical conic-arc spectra [REPORTED 2026-07-09]

**READ FIRST:** [`2026-07-08-nk-involution-residual.md`](2026-07-08-nk-involution-residual.md)
(the Lemma-VI spectrum machinery, NK1–NK3), the C29 order dichotomy
([`2026-07-08-codex-mod3-column-law.md`](2026-07-08-codex-mod3-column-law.md) §mechanism), and the
E1 preamble [`2026-07-09-E1-capacity-degradation-preamble.md`](2026-07-09-E1-capacity-degradation-preamble.md).
Also read Coolsaet-Sticker, *Arcs with Large Conical Subsets*
([EJC 17 (2010), #R112](https://www.combinatorics.org/ojs/index.php/eljc/article/download/v17i1r112/pdf/)),
especially the orbital-index graph `Γ(C,U)`, excess-two classifications, and type-I excess bound;
for `k ≥ 3`, read Tranchida, *Triples of involutions in PGL(2,q) and their incidence geometries*
([arXiv:2411.10299](https://arxiv.org/abs/2411.10299)).

Context: D3 states the *reduction* — conic-restricted play after intrusions is Node-Kayles on a
union of Möbius involution matchings. Only the two-intruder layer is forced to be a
path/cycle/isolate graph; with `k` intruders the maximum degree is `k`, so Dawson/path-cycle XOR is
not the recursive invariant. The raw finite-geometry classification of those matching unions is
**not new enough to carry C45 as originally written**: Coolsaet-Sticker already identify off-conic
points with trace-zero involutions in `PGL(2,q)`, introduce the same conic graph on orbital indices,
analyze unions of two supplementary-point/involution matchings through cyclic normal forms, and
classify several large-conical-subset small-excess arcs. A publishable C45 must therefore be the
game layer that is absent from that literature: Grundy consequences of the two-intruder spectra,
dynamic legality/reply closure for higher-degree matching-union graphs, and compatibility
constraints between successive involution graphs produced by an actual play history.

1. **Literature extraction first:** write the precise overlap table: Coolsaet-Sticker result /
   notation / what our `nk-involution-residual` note had rediscovered / what remains game-specific.
   Do not claim the two-involution spectrum classification as new unless the report isolates a
   genuinely different game-valued statement.
2. **k=2 game theorem:** use the classical cyclic normal form as input, then prove the Node-Kayles
   layer: even-cycle Grundy-0 cancellation, Dawson-path defect values, split/elliptic order effects
   on the *nimber*, and which spectra can be dropped from a live game state without changing the
   residual Grundy value. This is the main novelty target.
3. **Dynamic reply closure:** characterize when a legal reply intruder preserves, refines, or
   destroys the previous involution-graph decomposition. The object is an ordered game history, not
   an arbitrary supplementary set `U`: record the compatibility conditions between successive
   `Γ(C,U_t)` graphs and the live conic subset after each move.
4. **k ≥ 3 partial with prior art:** use Tranchida's triples-of-involutions geometry as the
   required reference point for three-intruder skeletons (strongly non-self-polar triangles,
   tangent-triangle cases, generated subgroup constraints). Counting inequalities are fine, but
   label them as game-history constraints and explicitly separate them from known incidence-geometry
   classification.
5. **Machine gate:** every defect spectrum observed in the C20/C31 data
   (`notes/data/c20-*-states.jsonl.gz`) must satisfy the k=2 constraints where applicable; any
   violation means an error in the theorem, the prior-art translation, or the miner — report
   verbatim and stop. Add a second gate for dynamic closure: sampled winning replies must satisfy
   the stated transition constraints.
6. **Publishability verdict:** the report must end with "prior-art overlap / new game-valued
   content / remaining risk." If the only completed result is the classical spectrum classification,
   mark C45 as not independently publishable.
7. Optional: Lean statement scaffold for the game-valued k=2 consequences (not the classical
   dihedral classification alone).

Budget: proof/writing task; machine part is validation against existing data only, 2h.
Report file: `notes/2026-07-09-codex-defect-spectrum-theorem.md`.

## C46. `[cap]` t-ply conic-depletion inequality ladder — where a trap can live [REPORTED 2026-07-09]

**READ FIRST:** [`2026-07-08-s4-two-ply-conic-depletion.md`](2026-07-08-s4-two-ply-conic-depletion.md)
(the two-ply bounds `off/off ≥ max(0,q−19)`, `off/on ≥ max(0,q−13)`, `on/on = q−7` and their
incidence-counting proofs) and the falsification map §3 (the `q ≥ 23` regime row is the two-ply
instance of this ladder).

Context: the alignment verdict made arc depletion THE load-bearing quantity for the (ON) route,
and the two-ply bound is currently the only proven depletion constraint. Generalize the same
row/column + secant incidence counting to depth `t`: an explicit `c(t)` with
`live_on ≥ q − c(t)` after any `t` further plies. Each `t` is an inequality delimiting where a
counterexample can live; the inverse function `T(q)` — the minimum number of plies any trap needs
to empty the conic — is a publishable constraint on the conjecture independent of its resolution.
New literature input: Coolsaet-Sticker's cyclic normal form and large-conical-subset excess bounds
may supply the finite endgame component of Good. Once the played/on-conic occupancy is in their
large-conical-subset range, the off-conic skeleton is no longer arbitrary; in type-I large arcs,
for example, excess is bounded by 4 and the excess-4 case has a sharp congruence/form.

1. **The ladder, with proof:** define the play window precisely (root layer, whose moves count as
   plies, on- vs off-conic move effects on live cells), derive the recurrence for `c(t)` (each new
   cell kills at most a bounded number of live conic cells via its secants/tangents through played
   structure — count it exactly), and give the closed form or sharp recurrence. Semi-formal proof
   note at Lean-statement granularity; flag any step that is play-order-dependent.
2. **Finite-endgame branch from conical-arc theory:** translate Coolsaet-Sticker's thresholds
   (`(q+1)/2`, `(q+3)/2` conic points, internal/external/mixed supplementary points, excess) into
   the cap-game state variables. State exactly when their excess bounds apply to a played-position
   arc, and enumerate the bounded off-conic skeletons left in that regime. If the game state falls
   outside their hypotheses, say where and keep the ladder as the fallback.
3. **Sharpness:** mine the exact q=17/19/23 dumps for positions at or near the bound per `t`
   (existing data; no new campaigns). Report the gap between the bound and the observed worst
   case — a large gap means the counting is loose and says where.
4. **The corollary table:** per q ∈ {11..31}, the minimal `t` at which conic-emptying is not
   excluded (`T(q)`), presented as the constraint "a counterexample at q must sustain a live conic
   for ≥ T(q) plies." Feed the falsification map §3 regime table (two-ply row becomes the `t=2`
   instance).
5. **Consistency gates:** `c(2)` must reproduce the two-ply lemma's constants exactly; the q=17
   empty-conic witnesses (score-9 repairs) must sit consistently with the ladder (they empty the
   conic at a ply depth the ladder permits). The finite-endgame branch must also match every
   sampled high-conic-occupancy state in the q=17/19/23 data: any unbounded-looking off-conic
   skeleton in the claimed range is a translation error or a counterexample to the branch.

Budget: proof task + 2h mining validation, single-core, ≤ 8 GB.
Report file: `notes/2026-07-09-codex-depletion-ladder.md`.

## C47. `[cap]` Minimal-counterexample constraint package (gate DISCHARGED 2026-07-09 — C42 reported) [REPORTED 2026-07-09]

The C42 gate is satisfied: `notes/2026-07-09-codex-type-census-uniformity.md` exists and is
**negative**, so row 3 below takes its negative branch — state "no propagation constraint
available" and ship the package on rows 1–2 and 4–6. **READ FIRST:** the falsification map
(the taxonomy this packages into theorems), C42's report, and the C45/C46 reports if available
(their results are two of the package's rows).

Context: the odd-perfect-number / Fermat move — publish "any counterexample to the odd-plane
conjecture must satisfy ..." as a theorem package, with each row proven and its evidence tier
stated. This is the publishable face of counterexample-readiness; it feeds D1's conjecture
section (or stands alone) and is valuable *whichever way* the conjecture resolves.

1. **Row: q lower bound.** "Any counterexample has q ≥ <frontier>" — assembled from the
   Lean-unconditional rows (q=5,7,11,13 + C30's q=17/19 when landed) and the computed rows with
   their solver-trust caveats stated exactly (C37/C8 as the verification citations).  For q=23,
   cite C29 plus the full-PGL bridge/C53 rather than a B3 conditionality rider. Never upgrade a
   tier.
2. **Row: total on-conic depletion.** A trapped class has ALL children N, in particular its q−4
   on-conic children — so at a counterexample q, that class's on-conic P-count is 0. Two-line
   proof; write it.
3. **Row: the all-or-nothing dichotomy (conditional — cite C42's lemma).** If the census
   propagation lemma holds with class-stability constant C, one totally-depleted class forces
   `mu_on(q) ≤ C` globally: counterexamples are all-or-nothing at the conic layer. State
   conditionally with the exact dependency; if C42 reported negative, this row becomes "no
   propagation constraint available" — say so plainly.
4. **Row: ply-depth constraint.** C46's `T(q)`: the trap must sustain a live conic for ≥ T(q)
   plies (cite the ladder; restate the t=2 instance unconditionally if C46 has not landed).
5. **Row: game-length.** Optimal play lasts ≥ m(2,q) moves (smallest complete arc); cite the
   known m(2,q) lower bounds (verify the exact constant — `[VERIFY]` tag if unsourced, never
   fabricate) for the Ω(√q) corollary. One paragraph.
6. **Appendix: the sequences.** Tabulate dep(q), Z(q), mu_on(q), N_canon(q) over the computed
   range as OEIS-candidate data. Preparing the tables is in scope; any actual OEIS submission is
   a user decision — do not submit.
7. Deliverable: a self-contained theorem-package note (`notes/2026-07-09-minimal-counterexample-constraints.md`)
   with every row tagged [LEAN]/[PROVEN-PROSE]/[COMPUTED]/[CONDITIONAL], D1-ready.

Budget: writing/proof assembly, 6h; no new solves.
Report file: `notes/2026-07-09-codex-counterexample-package.md`.

## C48. `[cap]` Mirror-theorem harvest on classical varieties — new P families at lemma-application cost [REPORTED 2026-07-09 (Claude/Opus) — Lean landed]

**Reported by Claude/Opus 2026-07-09.** Report: `notes/2026-07-09-codex-mirror-harvest.md`;
generator `rust/scripts/projcap_mirror_harvest.py`; **Lean `lean/ProjectiveCap/HyperbolicQuadricMirror.lean`
(builds clean, axioms `[propext, Classical.choice, Quot.sound]`).** All steps done: board
classification, machine gates, C27 obligation, negatives, and the Lean instantiation. The general
proposition `initialSubCapP_of_fpf_collinearity_preserving` (fpf collinearity-preserving involution
preserving a sub-board ⇒ P) + the harvested family `initialSubCapP_blockQuadric_of_odd_card`
(`Q⁺(2m−1,q)=P`, odd q). Headline: **new family `Q⁺(2m−1,q) = P` for
every odd q and every m ≥ 2** via the C25 elliptic block mirror `(a,b)↦(d·b,a)` (a factor-`d`
similarity of `Σaᵢbᵢ`, so it preserves the quadric; already Lean-proven fpf + collinearity-
preserving), machine-verified at Q⁺(3,3/5/7), Q⁺(5,3). Boundary dichotomy: **odd ambient
dimension is necessary but not sufficient** — the isometry group must also carry an fpf
involution. Negatives (mirror fails; outcome may still be P): elliptic quadrics `Q⁻(2m−1,q)`
(anisotropic block), parabolic `Q(2m,q)` and Hermitian curves `H(2,q²)` (even ambient dim ⇒
rational fixed point; unital blocking), Hermitian surfaces `H(3,q²)` (unitary involutions all
have isotropic eigenspaces). Trivial rows flagged: ovoids `Q⁻(3,q)` = free-placement parity;
`H(2,4) = AG(2,3)`. Codex: do not double-work; the open Lean step is
`ProjectiveCap/HyperbolicQuadricMirror.lean`.

Context: the Lean theorem
`Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution` is **generic**:
point set + ambient-collinearity legality + a fixed-point-free collineation involution preserving
the point set ⇒ empty position P. C25 instantiated it once (`PG(2m−1,q)`). Nothing restricts it to
full projective space: any classical variety whose cap game runs on ambient lines is a candidate
board, and the C27 chord-kill argument carries verbatim there (chords are ambient lines). Each
success is a new infinite-family outcome theorem at roughly lemma-application cost; each principled
failure maps the mirror method's boundary. Feeds D1 directly.

0. **Classify the boards first (the load-bearing subtlety).** The cap game on a variety is
   nontrivial only if some ambient lines carry ≥ 3 variety points. Elliptic quadrics and ovoids
   have every line meeting in ≤ 2 points ⇒ the game is FREE placement and the outcome is bare
   point-count parity (`q²+1` even for odd q ⇒ P trivially) — record these as trivial parity rows,
   flagged as such, no novelty claimed. The nontrivial boards are the ones carrying **generators
   or long secants**: hyperbolic quadrics `Q⁺(3,q)` (two rulings of generators — note the board is
   then a `(q+1)×(q+1)` grid whose ≥3-point lines are exactly rows/columns, i.e. a capacity-2
   rook-lines game, directly in the E1 line-capacity vocabulary), parabolic `Q(4,q)`, the
   `Q±(5,q)` family, Hermitian curves `H(2,q²)` (secants carry q+1 points), Hermitian surfaces
   `H(3,q²)` (generators). Verify each intersection pattern from the standard references before
   trusting it.
1. **Candidate involutions per nontrivial board.** Primary concrete candidate to verify first:
   on `Q⁺(3,q)` with q odd, the ruling-preserving shift by `((q+1)/2, (q+1)/2)` in the natural
   `Z_{q+1} × Z_{q+1}` coordinates looks fpf with mirror pairs never sharing a row/column (so the
   C27 pair-extension obligation may hold outright) — verify the sketch, do not trust it. For
   Hermitian boards: involutions in the unitary group, fpf on the variety's points (eigenvalue
   argument à la C25). Document every candidate precisely.
2. **Machine gates before believing any mirror:** exhaustively solve the smallest instances
   (`Q⁺(3,3)`: 16 points; `H(2,4)`: 9 points; `H(2,9)`: 28 points — all tiny) and confirm the
   claimed P outcomes; a stuck-free policy check against all P1 play for one small q per family
   (the C32 methodology). Any mismatch kills the candidate — report verbatim.
3. **The C27 obligation is not optional:** for each candidate, prove the pair-extension condition
   (`S ∪ {x, σx}` valid), not the weak fixed-point-free-only form — the mirror-chord obstruction
   is exactly what C27 corrected. Where σ-invariance kills the chord case, say so explicitly.
4. **Lean:** instantiate the generic lemma per successful family (the C25 pattern: coordinate
   model + transport). Statement-level minimum; proofs expected cheap where the informal argument
   is clean.
5. **Negatives are deliverables:** a family where every candidate involution has fixed points on
   the variety (or an odd point count blocks parity) is a boundary datum for D1 — record it with
   the obstruction.

Budget: math + small compute; 8h wall, single-core, ≤ 8 GB (solves are tiny).
Report file: `notes/2026-07-09-codex-mirror-harvest.md`.

## C50. `[cap]` Kernel-checked Grundy certificates — machine-verified game-value sequences (post-C35) [REPORTED 2026-07-10 — tiny PASS / literal-scale NO-GO]

Context: C35's oracle now produces exact nimbers (`s4gdump`/`s4gcheck`/`s4gmeasure`), and the C19
reflection route kernel-checks P/N reply books. Bridging them — a **nimber certificate** format
with a reflected Lean checker — would let computed Grundy values ship as kernel-checked theorems.
Applied to sequence data (the D6 queens nimbers / A344227 extension rows, the cap-game ladder),
this is a methods contribution with an unusual hook: OEIS game-value entries are essentially never
formally verified, and we have both the oracle and the checker infrastructure.

1. **Format design.** A Grundy book row for claimed value `g` needs: (i) a witness move to a
   child of each value `0..g−1`, (ii) the *no-child-has-value-g* obligation — the expensive
   direction, discharged recursively via the children's books (depth is bounded by the game
   length). Design the list-based format in the C12/C19 lineage (self-describing header,
   line-oriented, trivially parseable); an emitter mode from the C35 Grundy dumps; and an
   independent `certcheck`-style rules-only validator.
2. **Lean checker, soundness direction only:** `checkGrundyBook data = true → grundy pos = g`,
   reflected to `by decide` per the C19 discipline (no `native_decide`; axiom gate
   `[propext, Classical.choice, Quot.sound]` verbatim in the report).
3. **End-to-end prototype on ONE tiny instance** (grid-cap q=5, or queens n ≤ 6): emit, check,
   elaborate; measure kernel-eval wall time and extrapolate before any scale-up. STOP and report
   if the recursive no-child obligation blows up the book size — a measured infeasibility verdict
   with the growth curve is a full-value deliverable.
4. **Scope guard:** the methods note / OEIS-facing write-up is a follow-on, not this task; no
   OEIS submission (user decision). This task is format + checker + prototype + cost measurement.

Budget: hard 8h wall, single-core, ≤ 8 GB.
Report file: `notes/2026-07-09-codex-grundy-cert-format.md`.

## C49. `[queens]` Node-Kayles nimber tables for other chess pieces (D6 siblings, queens box idle time)

Context: D6 extends the queens nimber sequence (OEIS A344227, known to n=13). The same solver
discipline applied to other pieces yields cheap OEIS-able siblings and more capacity-1 anchors for
the line-capacity umbrella. Note the built-in triviality trap: **rooks are forced-length** (every
maximal non-attacking rook placement on n×n has exactly n rooks, so the game is bare parity) —
that is the sanity base case, not a contribution. Kings, knights, and bishops have
variable-length maximal placements and are the real targets.

1. **Literature/OEIS check per piece FIRST** (a solved piece is a skip): search Node-Kayles /
   placement-game / nim-value results for kings, knights, bishops; check OEIS for existing
   game-value sequences (counting sequences exist for all pieces — those are not ours). Report
   what exists with citations; no fabricated references.
2. **Solver adaptation:** per-piece attack masks in the queens machinery (kings/knights are
   local — a different pruning regime; document what changes). **Validation gate per piece:** the
   `solver_lineage_agrees` pattern — exact match against an independent naive solver on all
   n ≤ 6 (or ≤ 8 where cheap) before any table is reported.
3. **Compute outcomes + nimbers** per piece as far as an 8h/8 GB budget reaches; tables verbatim,
   with the per-n wall/memo telemetry so the next session can extend.
4. **OEIS preparation only** — b-file-ready tables and sequence descriptions; any actual
   submission is a user decision. Do not preempt cap-program compute; follow the queens tmux
   discipline if the big box is used.

Budget: hard 8h wall, single-core, ≤ 8 GB per piece; opportunistic scheduling.
Report file: `notes/2026-07-09-codex-piece-nimber-tables.md`.

## C51. `[cap]` Polar-space Nofil — symplectic W(2n−1,q) and beyond (mirror harvest #3) [handed off by Claude/Opus 2026-07-09] [REPORTED 2026-07-09 (Claude/Opus) — Lean engine landed]

**Reported by Claude/Opus 2026-07-09.** Report: `notes/2026-07-09-codex-polar-space-nofil.md`;
generator `rust/scripts/polar_space_nofil.py`; **Lean `lean/ProjectiveCap/PolarSegreMirror.lean`
(builds clean, axioms `[propext, Classical.choice, Quot.sound]`).** Headline: **new family
`W(2n−1,q) = P` for every odd `q` and `n ≥ 2`** — the elliptic block map `(a,b)↦(δb,a)` is a
symplectic *similitude* (scales the alternating form by `−δ`), hence fpf + isotropic-line-preserving.
Machine gates: `W(3,3)` (=GQ(3,3), C27 pair-extension over ALL 22572 σ-invariant caps PASS ⇒ P),
`W(3,5)` (=GQ(5,5)), `W(5,3)`. Lean deliverable = the reusable capacity-2 **near-linear mirror
engine** `FiniteBuildGame.initialCapC2P_of_nearLinear_mirror` (the "conflict-hypergraph mirror
lemma" §#3 asked for, at c=2) + the fully-proven `GridRook.gridRook_isP` instantiation (shared with
C52). The concrete symplectic-form instantiation is the remaining geometric obligation (near-linearity
from projective line uniqueness; isotropic-line-preservation is the machine-verified similitude).

Continuation of the C48 mirror harvest. **Full scope + math is in
`notes/2026-07-09-mirror-method-boundary.md` §"#3 — Scope: polar-space Nofil"** — read it first;
this entry is just the queue pointer.

Idea: invert figure/ground. Instead of a variety being the board with ambient lines as
constraints, take the *whole* `PG(2n−1,q)` as the board and let the constraint lines be the
totally-isotropic lines of a polar space (a position is legal iff no 3 selected points lie on a
common isotropic line). Cleanest first target is **symplectic `W(2n−1,q)`**: every point is
isotropic, so the board is all of `PG(2n−1,q)` (odd projective dimension), and the C25 elliptic
fpf involution already lives there — it applies iff it is a *symplectic similitude* of the chosen
alternating form (same similarity trick as C48; verify).

Deliverables: (1) machine gate — build `W(3,q)` for `q=3,5` (isotropic-line hypergraph),
exhaustively solve the cap game, test the elliptic involution's fpf + isotropic-line-preservation +
C27 pair-extension; then `W(5,3)` mirror-only. (2) Lean: a `FiniteBuildGame` over `Point K V` with
`Valid := no 3 on a common isotropic line`, or reuse the new conflict-hypergraph mirror lemma
`CapGame/GraphMirror.lean` / the C48 proposition `initialSubCapP_of_fpf_collinearity_preserving`.
Watch: the #5 boundary (`notes/2026-07-09-mirror-method-boundary.md`) likely recurs at the group
level for unitary/orthogonal polar spaces (anisotropic-core obstructions). Machine gates tiny;
single-core, ≤ 8 GB. Report file: `notes/2026-07-09-codex-polar-space-nofil.md`.

## C52. `[cap]` Segre / product-variety Nofil (mirror harvest #4) [handed off by Claude/Opus 2026-07-09] [REPORTED 2026-07-09 (Claude/Opus) — Lean base family landed]

**Reported by Claude/Opus 2026-07-09.** Report: `notes/2026-07-09-codex-segre-product-nofil.md`;
generator `rust/scripts/segre_product_nofil.py`; **Lean `lean/ProjectiveCap/PolarSegreMirror.lean`
(builds clean, axioms `[propext, Classical.choice, Quot.sound]`).** Headline: **`PG(a,q)×PG(2m−1,q) = P`
for odd `q`** via `σ = id × (elliptic fpf involution on the odd factor)` — fpf + ruling-preserving.
Machine gates: `PG(1,3)²` (=`Q⁺(3,3)`, full BFS + exhaustive solve = P), `PG(2,3)×PG(1,3)` (C27 over
ALL 117963 caps PASS), `PG(1,3)×PG(3,3)` (sampled PASS). Boundary (#5): a product of two even-dim
factors admits no `id×(fpf)` mirror (needs one odd factor). Lean: the base family `Q⁺(3,q)=PG(1,q)²`
is **unconditionally proven** as `GridRook.gridRook_isP` (capacity-2 rook-lines game on `A × ZMod 2t`,
column-shift mirror), reusing the shared `initialCapC2P_of_nearLinear_mirror` engine; the general
higher-factor product reduces to the same engine (remaining obligation, statement-level).

Continuation of the C48 mirror harvest. **Full scope + math is in
`notes/2026-07-09-mirror-method-boundary.md` §"#4 — Scope: Segre / product varieties"** — read it
first; this entry is just the queue pointer.

Idea: `Q⁺(3,q)` *is* the Segre `PG(1,q)×PG(1,q) ↪ PG(3,q)` (the `(q+1)×(q+1)` grid). Generalize the
board to `PG(a,q)×PG(2m−1,q)` (Segre embedding); its ≥3-point ambient lines are the two rulings (a
grid of subspaces), and the mirror is `σ = id × (elliptic fpf involution on the odd factor)` —
fpf overall (fpf in one coordinate), ruling-preserving, with the C27 pair-extension reducing to the
single-factor argument. Grassmannians via Plücker are the next step (`Gr(2,4)` = Klein quadric =
`Q⁺(5,q)` already covered; higher `Gr(k,n)` needs the fpf-on-`k`-subspaces check).

Deliverables: (1) machine gate — build `PG(1,3)×PG(1,3)` (= `Q⁺(3,3)` sanity), then
`PG(1,3)×PG(3,3)` and `PG(2,3)×PG(1,3)`; confirm the ruling hypergraph, solve small, test
`id × elliptic`. (2) Lean: a `SubCap`-style product board reusing the C48 proposition once the
product involution's collinearity + ruling preservation is shown. Watch: need one odd-dim factor;
products of two even-dim factors likely fail per the #5 boundary. Single-core, ≤ 8 GB. Report file:
`notes/2026-07-09-codex-segre-product-nofil.md`.

## C53. `[cap]` Full-PGL on-conic orbit bridge + q=23 computed-status cleanup [DONE 2026-07-09 — Claude; parts 1–4]

**Claim note (Claude, 2026-07-09):** **all four parts done.** Parts 1–2 (the Lean bridge)
verified and landed in `lean/ProjectiveCap/Sym2ConicBridge.lean` — Sym²/Veronese construction,
conic preservation + Möbius realization, and the composition capstone `onconic_value_bridge`
proving PGL-orbit ⟹ equal on-conic value (`lake build` green, axiom-clean, imported into
`ProjectiveCap.lean`, kept general over characteristic; `veronesePoint` injectivity also
proved). An adversarial persona review caught and I fixed a design-gap (first-draft deliverable
was generic collineation-invariance). Parts 3–4 (q=23 status write-up + B3-open doc cleanup)
landed in the handoff, falsification map, and alignment report — negative cross-q conclusion
preserved. Downstream is C54 (bucket-label certification), not C53. Full write-up + verification
log: `notes/2026-07-09-codex-full-pgl-bridge.md`. (C53 code + docs landed in commits
`7f7c6c9` / `6475a5b`; this queue entry is committed alongside an unrelated C30 status edit
that was already in the working tree.)

Context: a review caught that the full-PGL orbit bridge was already proved in prose, not merely
empirically supported.  In an on-conic S4 state, the actual played projective position is the
unordered six-point cap on the conic: the four grid cells plus the two pre-played/burned points.
The burned pair has no further game-theoretic role.  Thus any conic-stabilizing projectivity
carrying one six-set to another carries the whole follower game.  The later restriction to the
burned-pair stabilizer in
[`2026-07-09-onconic-child-type-alignment.md`](2026-07-09-onconic-child-type-alignment.md) was a
sound-but-unnecessary downgrade.

Proof target:

1. **Formal symmetric-square bridge.**  In Lean, construct the standard `Sym²` extension of a
   projective line transformation to a projective plane transformation preserving the Veronese
   conic.  In coordinates, a `PGL(2,K)` matrix acting on `[u:v]` induces the linear map on
   quadratic coordinates `[u²:uv:v²]`; show it sends the conic to itself and realizes the original
   Möbius action on conic parameters.  Scope can be odd finite fields first if characteristic-2
   bookkeeping gets in the way.
2. **Game transport.**  Package the induced projectivity as a validity-preserving equivalence of
   projective cap follower games and apply the existing transport theorem
   `FiniteBuildGame.isP_map` / `win_equiv` (`lean/CapGame/BuildGame.lean`).  Deliver theorem
   statement: if two on-conic S4 states have full-`PGL(2,q)`-equivalent six-point parameter sets,
   then their residual game values agree.
3. **q=23 status handoff.**  Combine the theorem with C29's all-22 full-`PGL(2,23)` bucket
   labels to state the computed q=23 on-conic escape result without the orbit caveat.  This does
   not make q=23 Lean-unconditional unless the 22 computed P roots are themselves converted to
   kernel-checked/rules-checked certificates; state that trust tier exactly and hand off the value
   certification to C54.
4. **Doc cleanup.**  Remove/patch B3-open language in the handoff, falsification map, alignment
   report, and any queue item that asks for duplicate stabilizer-representative solves.  Keep the
   negative cross-q type-alignment conclusion: full-PGL transport is a fixed-q compression only and
   gives no q-to-q prediction.

Non-goals: no new q=23 solves; no second representatives solely for bridge testing; no q=25 census
unless C44 is separately launched.

Report file: `notes/2026-07-09-codex-full-pgl-bridge.md`.

## C54. `[cap]` Certify the q=23 full-PGL bucket labels [REPORTED 2026-07-09]

Context: after C53, the 22 full-`PGL(2,23)` on-conic bucket representatives cover every q=23
on-conic S4 child.  C29 solved all 22 representatives as P, and C37 generated exact raw q=23 bucket
dumps with large shared-key agreement and zero disagreements.  The remaining issue is not another
orbit test; it is certifying the computed P labels themselves at the strongest feasible machine
trust tier.

Task:

1. **Inventory existing artifacts.**  List the 22 q=23 bucket roots, their C29 labels, and the
   corresponding raw dumps from `rust/s4-dumps/2026-07-08/` and
   `rust/s4-dumps/2026-07-09/c37-q23-raw/`.  Confirm every dump header is root-matched,
   `status=OK`, `value=P`, and that C37's q=23 shared-key agreement is zero-disagreement.
2. **Choose the certificate substrate by sizing, not guesswork.**  Options:
   - P/N dump consistency checker: verify minimax equations for every recorded state by enumerating
     legal children and checking their canonical keys/values in the raw dump.  Missing nonterminal
     children are certificate failures.
   - Grundy dump route: run `s4gdump` on one representative first; if the all-children Grundy table
     fits, `g = mex(children)` gives a stronger certificate and can be checked by the same rules-only
     traversal.
   - Explicit P reply books only if smaller than the raw/minimax certificate.
3. **Implement or reuse a rules-only checker.**  It may trust the canonical key as the state
   identifier, but not the solver recursion.  It must independently enumerate legal moves from each
   decoded/reconstructable state or from a dump-supported state traversal; for P/N, check
   `P ↔ all children N` and `N ↔ some child P`; for Grundy, check exact mex.  Any missing child,
   illegal child, header mismatch, or value inconsistency is a hard FAIL.
4. **Run the q=23 bucket suite if the first-bucket sizing fits.**  Report per-bucket records,
   wall/RSS, checker result, and aggregate coverage.  If full checking does not fit, report the
   blocker and the extrapolated certificate cost; do not silently downgrade.
5. **Compose the result statement.**  With C53 + successful C54, the q=23 row is
   "computed and rules-certified at the S4 bucket layer"; it is still not a Lean theorem for
   `Projective.InitialPStatement` unless/until a Lean checker consumes the certificates.

Non-goals: no duplicate stabilizer representatives; no q=25 work; no new q=23 size-3-rooted `esc`
campaign.

Report file: `notes/2026-07-09-codex-q23-bucket-certification.md`.

Status: **PASS, all 22 buckets rules-certified at the S4 layer.**  Added native `s4pncheck`, which
rebuilds every legal move without calling minimax and checks the early-break reply-book equations
(P: all children present N; N: a present P witness), terminal values, root/header guards, and exact
reachability of every raw record.  Full suite: `241,627,613 / 241,627,613` records seen,
`988,106,416` legal edges enumerated, zero failures, `4,077.68s` aggregate wall, `371,836 KB` max
RSS.  With C53, q=23 is now "computed and rules-certified at the S4 bucket layer"; it remains short
of a Lean `Projective.InitialPStatement` until a Lean checker/assembly consumes the certificates.

## C55. `[cap]` d-lattice side-switch diagnostic — a mechanism candidate for the arc-depleted-order dichotomy [REPORTED 2026-07-10 — NEGATIVE]

**Report: [`2026-07-09-codex-d-lattice-side-switch.md`](2026-07-09-codex-d-lattice-side-switch.md).**
NEGATIVE on both instruments the task names.  Abstract C18 involution-product dictionary: no net
directional side-switch (flip net ≈ 0, ≤ control); shared-lattice `d` values switch side at the
same rate for flip and control.  Actual legal-intruder secant skeleton (Lemma VI): the split-share
rise depleted→full is a generic q-effect, identical for flip and control (17/19: +0.044 vs +0.041,
100 vs 30 configs), and the within-order test reverses the prediction (q=11 N children secant share
0.029 > P's 0.015).  Minimal-witness solve: secant share is smooth/monotone in q with no discrete
signature at the N,P,N,P flips.  No q=23/25 flip prediction emitted (mechanism dead).  C56 stays
closed-gated; S1 (→ C69) promoted with the C64 negative.

**READ FIRST:** [`2026-07-09-onconic-child-type-alignment.md`](2026-07-09-onconic-child-type-alignment.md)
(the 119 shared integral configurations that flip value across q — N exactly at q ∈ {11,17}, P at
{13,19}), Lemma VI of [`2026-07-08-nk-involution-residual.md`](2026-07-08-nk-involution-residual.md)
(two-intruder spectrum: the `xx'`-secant `K₂` is PRESENT iff `d = ord(σ_x σ_{x'})` divides `q−1`
(split) and ABSENT iff `d | q+1` (elliptic)), and the C18 feature dictionary
([`2026-07-07-codex-ml-moduli-attribution.md`](2026-07-07-codex-ml-moduli-attribution.md)) whose
order-theoretic feature code is reusable.

Context: the alignment verdict made the arc-depleted-orders dichotomy the load-bearing unknown of
the (ON) route, with no mechanism. Observation (Fable, 2026-07-09): the flip pairs share a divisor
lattice across opposite sides — `11+1 = 13−1 = 12` and `17+1 = 19−1 = 18`. So the SAME product
order `d` in the shared lattice is realizable at both orders of a pair but on opposite
split/elliptic sides, and by Lemma VI the defect skeleton of the "same" configuration then
genuinely differs (secant `K₂` and tangency-path structure swap). **Hypothesis (H-side-switch):**
the 119 cross-q value flips are mediated by shared-lattice `d` values realized split at 13/19 and
elliptic at 11/17. Note C18's null does NOT cover this: C18 fit static laws on bucket values
pooled across q; this is a *paired contrast* on matched configurations, which C18 never tested.

1. **Feature extraction on the matched pairs.** For each of the 119 flipping configurations (and
   a matched control sample of non-flipping shared configurations), at both orders of its pair:
   compute the order-theoretic profile — `ord(σ σ')` for the canonical involution pairs of the
   6-subset (C18's dictionary) and, where the alignment data exposes them, the `d` values of
   actual legal intruder pairs in the S4 follower — with each `d` tagged by divisor class
   (`d | q−1` / `d | q+1` / `d = p`).
2. **The paired test.** Do flipping configurations carry shared-lattice `d` values (divisors of 12
   for the 11/13 pair, of 18 for 17/19) whose side switches across the pair, significantly more
   than controls? Report the full contingency tables verbatim; no significance theater — the
   counts speak.
3. **Skeleton-level verification on a sample.** For a sample of flipping configurations, compute
   the actual NK defect spectra of the relevant follower states at both orders (spectrum code in
   `2026-07-08-nk-involution-check.py`) and confirm the skeleton differs exactly by the predicted
   `K₂`/path swap. Any spectrum NOT differing where the value flips is a counterexample to the
   mechanism — report verbatim.
4. **Prediction if positive:** q=23/q=25 share 24 the same way (`23+1 = 25−1`). Emit the list of
   configurations H-side-switch predicts to flip between q=23 and q=25 — a falsifiable prediction
   the C44 census can test directly. If negative: state plainly that the mechanism is dead and the
   A5 arc-depletion arithmetic remains without a candidate — a valid deliverable.
5. **Gates:** feature code must reproduce the known C15/C5 bucket labels where it overlaps them;
   the 119-configuration list must match the alignment report's exactly.

Budget: existing data + small compute, single-core, ≤ 4h.
Report file: `notes/2026-07-09-codex-d-lattice-side-switch.md`.

## C56. `[cap]` Group-indexed cross-q type alignment (the C36 retry) [GATED on a C55 positive]

Do NOT start until C55 reports positive. Context: C36's strict normalized-coordinate types pass
within-q self-consistency but have 281 nonconstant cross-q value rows — unsurprising, since
coordinate types carry no cross-q transport. The conic model says the residual actually depends on
group-theoretic data: which `d` values occur, on which side (`d | q−1` split / `d | q+1` elliptic /
`d = p` parabolic), the tangency/fixed-point data, and where kill-scars land on the dihedral
orbits.

1. **Type definition:** re-index the C36 corpus (exact q=17/q=19/q=23 depth-2 bucket dumps,
   `rust/s4-dumps/2026-07-09/c36-logs/`) by the group-model type: the multiset of
   (d, side, tangency count, scar placement class) over the state's involution structure. Document
   the type function precisely enough to be re-implemented.  Candidate canonical coordinates for
   the underlying 6-subset (seventh-pass addition): **Igusa invariants** of the associated binary
   sextic — unordered 6-subsets of `P¹(F_q)` mod `PGL(2,q)` are genus-2 moduli points, and Igusa
   invariants are the standard q-comparable labels for exactly these configurations; use them if
   the hand-rolled type function gets unwieldy (document small-characteristic handling — clean
   for char ∤ 30).
2. **Self-consistency within q** (any within-q collision kills the type — report verbatim, stop).
3. **Cross-q constancy:** the H-side-switch prediction is that value flips concentrate exactly on
   types whose side tag differs across q while the rest of the type matches — i.e. the correct
   cross-q key is (d, side, ...), not (d, ...). Compare against C36's 281 nonconstant strict rows:
   how many become constant under the group index, and how many are explained as side-switches?
4. **Deliverable:** the same shared-type/nonconstant-row tables as C36 so the two reports are
   directly comparable, plus a verdict on whether a q-independent (group-type → value) dictionary
   survives where the coordinate dictionary failed.

Budget: existing dumps only, single-core, ≤ 4h.
Report file: `notes/2026-07-09-codex-group-indexed-alignment.md`.

## C57. `[cap]` Zone conflict-graph quasi-randomness probe — one structural statement for the zone negatives

Context: the off-conic zone resists everything — one dense component at q=23
(`zone_v = 100..120`, `zone_nk_known = 0`), no clean sub-census (C42 negative), no decomposition
(C35: `g ≠ g_conic XOR g_zone`), remoteness/defxor stratify but do not decide (C39). Hypothesis:
the zone conflict graph is **quasi-random** (Paley-like — conflict edges are collinearity
conditions with quadratic-character flavor), which would *explain* the negatives structurally: no
exact zone-Grundy law is mineable from a pseudo-random graph, so steering/maintenance is the only
lane. Either verdict is a deliverable: quasi-random converts the negatives into one statement;
NOT quasi-random means the deviations from pseudo-randomness are exactly the mineable features.

1. **Sample zone conflict graphs** from existing q=13/17/19/23 state data (C20 states jsonl,
   `s4mine`/`s4xormine` rows — no new campaigns): extract vertex/edge sets at a range of zone
   sizes, from the small q=13 zones up to the dense q=23 components.
2. **Quasi-randomness battery** per graph: edge density p; degree spread vs np; codegree
   concentration; 4-cycle count vs the p⁴·n⁴/8 pseudo-random benchmark; second adjacency
   eigenvalue |λ₂| vs the O(√(pn)) pseudo-random scale. Compare each statistic against (i) a
   Paley graph of matched order, (ii) G(n,p) samples of matched density.
3. **Structured-deviation hunt:** wherever a statistic deviates, localize it (are the deviating
   vertex pairs geometrically special — same row/column, tangency-related, polar pairs?). Deviating
   substructure = the feature list for the next zone-mining pass.
4. **Verdict:** quasi-random / structured, with the evidence table, and the program consequence
   stated plainly (retire exact-zone-law mining, or here is the feature list).

Budget: existing data only, single-core, ≤ 4h.
Report file: `notes/2026-07-09-codex-zone-quasirandomness.md`.

## C58. `[cap]` Cap game on the four projective planes of order 9 — order vs Desarguesian structure

**[REPORTED 2026-07-10 — all-P (Claude)].** All four order-9 planes (PG(2,9), Hall, dual Hall,
Hughes) are P; pairwise non-isomorphic (distinct complete-arc spectra).  All-P branch: no N
geometry; the P-property is Desargues-independent at order 9 (conic localization is
Desargues-specific scaffolding).  Report:
[`2026-07-09-codex-order9-planes.md`](2026-07-09-codex-order9-planes.md).

**Full spec:** item F of
[`handoffs/2026-07-09-spinoff-bridges-duals-isomorphisms.md`](handoffs/2026-07-09-spinoff-bridges-duals-isomorphisms.md)
— read it first; this entry is the queue pointer plus the gates.

Context: non-Desarguesian planes are not self-dual in general (Hall vs dual Hall), so there the
cap game and its dual genuinely differ and the outcome becomes a candidate invariant of the
*plane*, not the order. Order 9 is the smallest non-Desarguesian order and is solver-feasible
(91 points; PG(2,9) already exhaustively solved P). Inward payoff either way: any N verdict proves
the odd-plane conjecture is about Desarguesian structure rather than order (a falsification-map
constraint — stop-and-report, per the C43 protocol for a first N geometry); all-P pressures the
eventual uniform proof to use less algebraic structure than conic localization currently does.

1. Incidence-structure input mode (solver or standalone; the boards are tiny — 91 points,
   91 lines).
2. Construct all four order-9 planes (PG(2,9), Hall, dual Hall, Hughes); verify the plane axioms
   and parameters machine-side before any solve (the C48 honest-construction discipline).
3. Calibration gate: the PG(2,9) incidence-input solve must reproduce the known P verdict before
   the other three run.
4. Exact-solve all four; note Hall vs dual Hall is the duality comparison, Hughes is self-dual.
5. Report: outcome table + per-plane node/class counts; cross-link the verdict into the
   falsification map and the main handoff.

Budget: hard 8h wall, single-core, ≤ 8 GB.
Report file: `notes/2026-07-09-codex-order9-planes.md`.

## C59. `[cap]` Arc-stability constraint import — second-largest complete arc bounds into the trap/endgame package [REPORTED 2026-07-10]

Context: sweep item (seventh-pass amendment).  Segre-type stability for odd q says every complete
arc not contained in a conic has size at most `q − c√q` (Voloch for odd q; Ball for prime q —
the exact statements and constants MUST be verified from the literature, `[VERIFY]` until cited;
Hirschfeld–Storme surveys are the index).  Terminal positions of the projective game are complete
caps, so every sufficiently large terminal is conic-contained **by theorem**, independent of our
conic-localization construction.  This adds proven extremal rows to the reported C46/C47
packages.

1. **Literature verification first:** exact statements of the second-largest complete arc bound
   `m′(2,q)` for odd q, with per-claim citations.  No fabricated constants; anything unverifiable
   stays `[VERIFY]` and is excluded from the theorem rows.
2. **Game translation:** (a) any terminal position of size above the bound lies on a conic
   (projective board); (b) the residual-grid version — state exactly how the burned pair and
   row/column capacities modify the statement, and what does NOT carry; (c) combine with C46's
   depletion ladder / `T(q)` and the C47 game-length row (`m(2,q)` lower bound) into the sharpest
   clean corollary about where a trap's terminal positions can live.
3. **Machine sanity:** against solved data only (q = 11..19 dumps; no new campaigns): confirm
   every observed complete cap above the bound is conic-contained; any violation is a
   translation error or a major finding — report verbatim and stop.
4. **Deliverable:** an amendment note to the C47 constraint package with the new rows tagged
   `[PROVEN-PROSE + citation]`, plus falsification-map cross-links.

Budget: literature + ≤ 2h mining validation, single-core, ≤ 8 GB.
Report file: `notes/2026-07-09-codex-arc-stability-import.md`.

## C60. `[cap]` Singer-model circulant probe — the plane as a cyclic difference-set board

Context: sweep item (seventh-pass amendment).  Under the Singer cycle, PG(2,q) points are
`Z_{q²+q+1}` and lines are the translates of a perfect planar difference set `D`; the cap game
becomes a cyclic avoidance game ("no 3 selected residues in any translate of D").  The program
owns circulant Node-Kayles machinery (the queens/NK interval-octal thread); nobody has looked at
the cap game in this model.  Note the Singer group has odd order — no involutions, so mirror
methods do NOT transfer; the interest is the cyclic/arithmetic structure itself.

1. **Build the model** for q = 5..13: construct the planar difference set from the field model,
   and verify the incidence structure is isomorphic to the coordinatized plane machine-side
   before trusting anything.
2. **Bounded diagnostics (fixed feature list, declared up front):** orbit structure of caps under
   the cyclic group; difference-spectrum features of P vs N positions (which residue differences
   appear); whether any interval/octal-pattern feature from the circulant Node-Kayles laws
   correlates with value at the capacity-2 level.
3. **Report positives AND the null plainly** — this is a probe, not an open-ended mining lane; a
   clean null closes the sweep item.
4. **Spinoff-facing rider (small):** define the Sidon-set building game on `Z_n` precisely
   (capacity-1 on difference lines), exhaustively solve tiny n as an existence proof for the
   spinoff note, and stop — no campaign.

Budget: ≤ 4h wall, single-core, ≤ 8 GB.
Report file: `notes/2026-07-09-codex-singer-model-probe.md`.

## C61. `[cap]` Finite-state reply automaton over defect/interface/zone states (sweep Co3)

**READ FIRST:** the Co3 spec in
[`2026-07-09-mathematician-lens-sweep.md`](2026-07-09-mathematician-lens-sweep.md) §3, the NK
involution note (state vocabulary), and the C36 strict-type machinery (coordinate vocabulary).

The open Good-closure lemma recast as a falsifiable finite object: quotient the mined
winning-reply data by (defect-skeleton spectrum type, interface type, zone summary type) and test
whether one finite automaton over those states generates a winning reply at q = 13, 17, 19, and
(chunked) 23 — the SAME automaton at every q.  Guard: `resym` killed play-closed *symmetric*
families only; general finite-state reply families are unmined territory.

1. **State quotient:** build it from the C38 forced-skeleton rows + steering witness rows
   (existing artifacts).  Document the state map precisely; report state counts per q.
2. **Conflict census:** same state, contradictory required replies — within q and across q.
   Zero conflicts ⇒ the automaton exists on the sampled data; report it as an explicit table.
   Conflicts ⇒ report the minimal conflicting state pairs verbatim — that is the theorem-grade
   localization of where any finite-state uniform strategy must fail, equally a deliverable.
3. **Adversarial replay gate:** a conflict-free automaton must then be replayed against the
   exact solver as adversary at q = 13 and 17 (full), q = 19 (sampled) — the automaton's reply
   must be winning at every visited state, verified by the solver's values, not by the mining
   labels.
4. Budget: days-scale, but all from existing artifacts + replay runs; single-core, ≤ 8 GB.

Report file: `notes/2026-07-09-codex-reply-automaton.md`.

**[REPORTED 2026-07-10 — NEGATIVE for the tested quotient; see the top-of-queue item 7 for the
successor framing (eleventh pass): existential/q-varying selector lemma (S11), no further
deterministic argmin variants.]**

## C62. `[cap]` Inverted selector search scored by exact character sums (sweep T1) [REPORTED 2026-07-10]

**READ FIRST:** the T1 spec in
[`2026-07-09-mathematician-lens-sweep.md`](2026-07-09-mathematician-lens-sweep.md) §1, and the
sixth-pass method note (genus-0 exactness lever).

Invert the maintenance-witness search: enumerate a library of algebraically natural selector
families up front (the sweep names four starters: polar-line internal intruders — kept as a
control, the polarity identities already failed; tangent-parameter bracketing of the surviving
defect path; live_on-minimizing cells under a quadratic-character sign condition on the
cross-ratio with the burned directions; the generalized q=17 score-9 conic-killer pattern) and
score EACH family against the mined witness corpora: the q=23 zero-xor rows across all 22
buckets, the q=19 steering rows, the q=17 score-9 guards.

1. Scoring script over existing `s4xormine`/steering TSVs: per family, the fraction of
   obligations where its selected cell is one of the verified maintainable zero-xor P replies.
   Report the full per-family per-q table; partial hits (a family that covers a clean sub-regime)
   are findings, not failures.
   **Fifth family (added 2026-07-10 from the random-turn frame,
   [`2026-07-10-frame-random-turn-values.md`](2026-07-10-frame-random-turn-values.md)):
   rho-greedy** — argmin child rho, where rho is the random-play annealed win probability.
   It found a winning move at 100% of all 11.8M N-positions on every solved board (q ≤ 11
   plane/grid) while failing on random-board controls, so the law is structural.  Prerequisite:
   an `s4rho` full-expansion traversal (same visit set/cost as C35 `s4gdump`) to score it on the
   q=17/19 obligations.  Caveat carried verbatim: rho is tree-defined, not incidence-defined —
   a *mining* selector whose hits still need a geometric characterization before the
   exact-character-sum lane can consume them.
2. Any family scoring near-perfect on a definable regime: state its selector as a precise
   geometric predicate and hand the existence step to the exact-character-sum lane (no solve
   needed — the count is exact at genus 0).
3. Null result (no family beats chance) is a valid deliverable: it sharpens the "value-defined
   witnesses" blocker into "not explicable by this library," and the library + scores become the
   baseline for the next round.
4. Budget: hours; no new solves.  Single-core, ≤ 8 GB.

Report file: `notes/2026-07-09-codex-selector-library-scoring.md`.

Status: no geometric selector theorem, but a sharp positive/negative split. Exact rho-greedy is
perfect on all 3,144 q=13 obligations, then misses 651/1,052,204 at q=17 and 11,345/2,622,214
in the q=19 `[1,2,3,4]` root; the failures are concentrated at early reply plies. Every exact
obligation nevertheless has some P reply with `Delta Psi < 0`, extending C63 through that q=19
root. Existing q=23 zero-xor/live witnesses decrease Psi on 5,487/5,734 rows. Route the rho
failure corpus and Psi charge to C61; no exact-character-sum handoff is justified.

## C63. `[cap]` LP-fit the amortized potential; read the infeasibility dual (sweep L1) [REPORTED 2026-07-10]

**READ FIRST:** the L1 spec in
[`2026-07-09-mathematician-lens-sweep.md`](2026-07-09-mathematician-lens-sweep.md) §6, and the
seventh-pass amortized-potential method note.

Operationalize the amortized-potential hunt: over exact transition data (C35 Grundy dumps +
steering rows), pose LP feasibility — find feature weights such that P2's verified replies never
increase the potential, every P1 option from a Good state fails to break it, and terminal Good
states are winning.  On infeasibility, READ THE DUAL: the dual certificate names the exact
transition combinations defeating every potential in the feature span — the next feature to add,
or (with small dual support) a machine-readable impossibility lemma for the whole invariant
class.

1. Feature span v1 (declare before solving): conic xor, live_on, zone size/parity, reservoir
   slack, defect path-length multiset summaries, interface counts (σ-images of played cells on
   surviving paths).  Document the transition-extraction exactly.
2. q=13 full data first (small LP); q=17 second.  Report: feasible weights verbatim, or the dual
   support verbatim + its game-theoretic reading.
3. Iterate LP-fit / dual-read / feature-extend at most twice within budget; report each round.
4. Feasible-potential gate: any found potential must be validated by replay against exact values
   on held-out states (not the fitting set) before being called a candidate invariant.
5. Budget: a day; single-core, ≤ 8 GB (LP solver via any standard library; document which).

Report file: `notes/2026-07-09-codex-potential-lp-dual.md`.

Status: positive candidate, no infeasibility dual.  Exact selected-strategy extraction over all
five q=13 and ten q=17 buckets found the integer ledger
`Psi = reservoir_slack + 6*defect_components - 4*selected_intruders - 2*[conic_xor=0]`.
It strictly decreases on all 3,144 q=13 and 1,052,204 q=17 verified P-to-P reply transitions
(ranges `-70..-9` and `-92..-4`) and on C65's q=23 extremal line (`110 -> 30 -> -19 -> -34`).
Held-out replay passes, but the replies are still exact-value/Z-selected: promote Psi as C62's
selector scoring target and C61's charge, not yet as a uniform proved invariant.

## C64. `[cap]` Completion-poset correlate of the arc-depleted dichotomy (sweep E3) — run beside C55 [REPORTED 2026-07-10 — NEGATIVE]

**Report: [`2026-07-09-codex-completion-poset.md`](2026-07-09-codex-completion-poset.md).**
NEGATIVE.  Full/exact completion enumeration (q=11/13 all configs, q=17/19 seeded 40+30 sample, no
truncation; cross-validated by independent brute-force `is_arc`/`is_maximal`).  No completion-spectrum
property (min size, count parity, move parity, size-parity availability) is constant-within-{11,17}
and within-{13,19} and differs-across while separating flip from control.  The 11/13 count-parity
near-miss is a small-field artifact (all 11 flips share one spectrum at q=11) that collapses at
17/19.  Structural reason: `has_odd=has_even=True` for every config at every order, so the value
lives in the full game tree, not any coarse terminal (maximal-arc) summary.  With C55 negative →
promote S1 (added as C69 below).

**READ FIRST:** the E3 spec in
[`2026-07-09-mathematician-lens-sweep.md`](2026-07-09-mathematician-lens-sweep.md) §2, and the
C55 entry (the group-side mechanism this complements; same 119-configuration corpus, same
control-sample discipline).

For each of the 119 flipping configurations (plus matched non-flipping controls), enumerate the
poset of complete arcs CONTAINING it at each order of its pair, and test whether the flip tracks
a completion-spectrum property: existence of a short completion, parity of the number of maximal
completions, or minimum completion size crossing a threshold.  This is the extremal-side
mechanism candidate; C55 is the group side; Segre-style envelope invariants (sweep S1) stay in
reserve as the third.

1. Exhaustive completion enumeration at q = 11 and 13 for all 119 configurations + controls
   (small search: feat machinery + a branch over remaining cells); sampled at q = 17/19.
2. A mechanism must be constant within {11,17} and within {13,19} and differ across — same
   verdict discipline as C55; report contingency tables verbatim either way.
3. If BOTH C55 and C64 report negative, promote sweep S1 (envelope invariants) to the queue as
   the remaining candidate.
4. Budget: a day; single-core, ≤ 8 GB.

Report file: `notes/2026-07-09-codex-completion-poset.md`.

## C65. `[cap]` Pin down Z(23): steering-ceiling growth + extremal configurations (sweep E1) [REPORTED 2026-07-09]

**READ FIRST:** the E1 spec in
[`2026-07-09-mathematician-lens-sweep.md`](2026-07-09-mathematician-lens-sweep.md) §2, and the
C31/C33 steering data trail in the handoff.

The recursive steering ceiling is the program's most route-deciding unnamed function:
`Z(13) = 2`, `Z(17) = 9`, `Z(19) = 16`, `Z(23) = ?`.  Three data points fit anything; the next
value + the extremal witnesses arbitrate between the small-`Z` base-law route and the
amortized-potential route BEFORE either consumes more proof effort.

1. Extract the steering ceiling over the existing q=23 chunked `s4xormine`/maintenance corpora
   (bucket `1,3,4,9` is fully censused; the other 21 have first-ply data); targeted chunk runs
   where coverage is thin, within existing caps — no new campaigns beyond that.
2. Report `Z(23)` (or an interval with the coverage caveat stated exactly), the fitted growth
   shapes (bounded / `O(√q)` / linear) with the caveat that four points still underdetermine,
   and — the Erdős half — the extremal steering states attaining the ceiling, with their
   geometric anatomy (zone volume, live_on, defect spectrum): do the extremal witnesses look
   forced by geometry (`Θ(q)` zone volume) or like small-q accidents?
3. Route verdict paragraph: what the number says for base-law vs amortized-potential, stated
   plainly.
4. Budget: hours to a day of solver time within existing caps; single-core, ≤ 8 GB.

Report file: `notes/2026-07-09-codex-z23-measurement.md`.

Status: native `s4zcensus` gives the honest full-C31 interval `40 <= Z(23) <= 136`.  The
`[1,2,3,8]` selected bucket is complete (225 canonical states, exact max 40); the fully
maintenance-approved `[1,3,4,9]` bucket is complete (124 canonical states, exact max 36); the
other 20 buckets have exact 25-seed screens with maxima 36..39.  The Z=40 extremum starts with
zone 119, `live_on=6`, defect spectrum `4,1,1`, and its worst line descends `40/7 -> 7/0 -> 0/0`.
Independent Python C31 recursion reproduces Z=40.  The small-uniform-Z route is deprioritized in
favor of C63's amortized-potential form, with small-Z as the terminal layer.

## C66. `[cap]` Grid-terminal spectrum — complete caps under row/column capacities (sweep S2) [GATE DISCHARGED 2026-07-10 — opportunistic diagnostic, no priority]

**READ FIRST:** the S2 spec in
[`2026-07-09-mathematician-lens-sweep.md`](2026-07-09-mathematician-lens-sweep.md) §5.

The game's terminal positions in the residual model are complete caps of the grid game — maximal
legal positions under caps + row/column capacities.  Not the classical complete-arc spectrum
(the capacities are new); nobody has computed it; it is the terminal stratification any
termination invariant for the maintenance lane has to land in.

1. Exhaustive maximal-position enumeration for q ≤ 13; sampled q = 17.  Sizes, structure (how
   much is conic-contained — the C59 import says large ones are; what do SMALL grid-complete
   caps look like), stabilizers.
2. Consistency gate: the first stratum must reproduce the NK note §5a endgame law (empty conic
   + 2-cell zone) where applicable.
3. Budget: a day; single-core, ≤ 8 GB.

Report file: `notes/2026-07-09-codex-grid-terminal-spectrum.md`.

## C67. `[cap]` Coupling-defect spectroscopy: δ = g ⊕ g_conic ⊕ g_zone (sweep Co1) [GATE DISCHARGED 2026-07-10 — opportunistic diagnostic, no priority]

**READ FIRST:** the Co1 spec in
[`2026-07-09-mathematician-lens-sweep.md`](2026-07-09-mathematician-lens-sweep.md) §3.

C35 measured the death of the disjunctive sum; this studies the failure.  Define
`δ(S) = g ⊕ g_conic ⊕ g_zone` on every S5/S6 state in the C35 Grundy dumps and test whether δ
is a function of the conic–zone INTERFACE alone (which σ-images of played cells land on which
surviving defect paths), by exact collision counting.  If δ factors through a small interface,
the coupled invariant the queue calls for has a candidate form `g_conic ⊕ g_zone ⊕ δ(interface)`;
if δ needs the whole state, that is a real lower bound on invariant complexity — either way a
deliverable.  Budget: hours (existing `c35/` dumps + Lemma-V σ data); single-core, ≤ 8 GB.

Report file: `notes/2026-07-09-codex-coupling-defect.md`.

## C68. `[cap]` The depletion-fraction extremal sequence D(q) (sweep E2) [REPORTED 2026-07-10 (Claude)]

**Report: [`2026-07-09-codex-depletion-fraction.md`](2026-07-09-codex-depletion-fraction.md).**
Exact `D(q)` (q=5..19 feat dumps, q=23 bucket labels): `D(q) = 0` at every non-arc-depleted order
(5,7,9,13,19,23; min-witness = q−4, full) and `D(q) > 0` **exactly** at the arc-depleted `{11,17}`
(`D(11)=5/7≈0.714`, `D(17)=12/13≈0.923` — corrects the E2 `≈0.79` guess). The knife edge **sharpens**
along the depleted subsequence, it does not relax: min-witness `2 → 1`, safety margin `(q−4)−maxonN`
`2 → 1`; "recovery" happens only at non-depleted orders (trivially, `maxonN=0`). So the strong E2
form "`D(q)≤1−c` bounded away from 1" is **not supported** (two depleted points climb toward 1). The
proof-usable anchor is min-witness, not D: the A5 target is **`maxonN(q) ≤ q−5` (min-witness ≥ 1) at
every arc-depleted order** — no size-3 class has all q−4 on-conic children N. Named quantity for A5:
`maxonN(q)` (a class-level extremal count, not a per-config invariant, so it does not re-open the
C55/C64/C69 config-invariant search). Decisive missing datum: `D` at the next depleted order (>23),
i.e. the C44 GF(25)/q=25 census. Script `rust/scripts/c68_depletion_fraction.py`.

---
Original spec below.

**READ FIRST:** the E2 spec in
[`2026-07-09-mathematician-lens-sweep.md`](2026-07-09-mathematician-lens-sweep.md) §2.

**Now active (gate discharged; see the A5 lane at top of queue):** with all config-mechanism
candidates dead (static C55/C64/C69 + dynamic Correction 3), A5 arc-depletion arithmetic is the
sole live (ON) mechanism route, and `D(q)` is its first concrete quantity.  If C68 names a specific
quantity, that also re-opens the Cluster-1 mechanism search under re-entry condition (a) — test it
as a config invariant.

Name and compute the function: `D(q)` = max over size-3 classes of the N-fraction among
on-conic children, plus the min-witness count per q.  Exact for q = 5..19 from feat dumps, q=23
from bucket labels; report the worst-class trajectory and histogram tails, not the mean (the §6
heuristic did the mean).  Guard: distinct from the dead `bad = o(q²)` area bound — this is a
bounded-away-from-1 class-level fraction, which the q=17 data does not refute.  If min-witness
count recovers after the q=17 dip, the knife edge is a small-q accident and the (ON) anchor
target becomes "D(q) bounded," a statement the A5 arithmetic could plausibly deliver.  Budget:
hours; single-core, ≤ 8 GB.

Report file: `notes/2026-07-09-codex-depletion-fraction.md`.

## C69. `[cap]` Envelope invariants for the flipping configurations (sweep S1 — PROMOTED 2026-07-10) [REPORTED 2026-07-10 — NEGATIVE]

**Report: [`2026-07-10-codex-envelope-invariants.md`](2026-07-10-codex-envelope-invariants.md).**
NEGATIVE.  Part A confirms the tangent envelope is non-discriminating (`0/1716` concurrent tangent
triples; dual conic always q+1 points; all chords secant → all poles external).  The arithmetic
candidates — genus-2 hyperelliptic trace `a2 = Σχ(f(x))` of the 6 branch points, the residual
tangent/secant partition, χ of Igusa-flavored resultants — all fail the flip/control verdict
discipline.  Near-hit: `a2=0` for all 11 N-flip configs at q=11 and `(0,−4,0,−4)` for the two
(distinct) NPNP double-flips — but it is a q=11 small-field artifact (`|a2|≤4√11`; observed
`{−4,0,4}`) that does NOT hold at q=17 (N-flips spread over `a2∈{−4,0,4}`) and is not sufficient (9
P-controls also have `a2=0` at q=11).  Same failure shape as C64's count-parity near-hit.  **All
three dichotomy mechanisms dead; S1 spent; (ON) rests on A5 arithmetic.**  No q=23/25 prediction.

**PROMOTED** because C55 (group-side) and C64 (extremal-side) are both REPORTED NEGATIVE — S1 is
the remaining, algebraic-geometry-side mechanism candidate for the arc-depleted-orders dichotomy,
and the only Cluster-1 lever still standing.

**READ FIRST:** the S1 spec in
[`2026-07-09-mathematician-lens-sweep.md`](2026-07-09-mathematician-lens-sweep.md) §5 (Segre), and
the two negative reports it must not re-tread —
[`2026-07-09-codex-d-lattice-side-switch.md`](2026-07-09-codex-d-lattice-side-switch.md) (C55) and
[`2026-07-09-codex-completion-poset.md`](2026-07-09-codex-completion-poset.md) (C64).  Reuse the
119-config corpus + gate machinery in `rust/scripts/c55_side_switch.py` (`load_corpus`,
`value_table`, `gate`, `cohorts`) and the conic model in `rust/scripts/c55_intruder_skeleton.py`
(`Conic`) — the corpus, cohorts, and the exact 119 flip / matched-control split are already built
and gate-verified there.

Segre's lemma of tangents: for `q` odd the tangents of a conic-arc envelope a conic.  Each flipping
configuration is six points ON a conic, so the derived object is the residual tangent/secant
partition it induces on the off-conic points, and the envelope of the six tangents (does it envelope
a second conic; with/without rational points; its point count / the quadratic character of a
resultant).  Unlike C18's dead static 6-subset dictionary (cross-ratios/characters/orders of the
six points), the envelope is a *derived curve whose `F_q`-arithmetic varies with q for fixed
integral data* — exactly the degree of freedom the cross-q flips demand.

1. Compute candidate envelope invariants for all 119 flipping configs (and the matched controls,
   for the same paired discipline C55/C64 used) at q = 11, 13, 17, 19.
2. **Verdict discipline (same as C55/C64):** a mechanism must be constant within {11,17}, constant
   within {13,19}, differ across, AND separate flip from control.  Report contingency tables
   verbatim; null is a valid deliverable.
3. **If NEGATIVE:** all three dichotomy mechanism candidates (group/extremal/algebraic) are dead;
   the (ON) uniform route then rests entirely on the q-dependent A5 arc-depletion arithmetic with
   no configuration-level mechanism — state that plainly, it is a sharp program result.
4. **If positive:** emit the q=23/q=25 flip prediction (`23+1 = 25−1 = 24`) for the C44 census to
   test, the falsifiable payoff C55 would have produced.

Budget: hours–day, existing data + small compute, single-core, ≤ 8 GB.
Report file: `notes/2026-07-10-codex-envelope-invariants.md`.

## C70. `[cap]` Exact reservoir-slack collision charge — untruncate Psi's incidence term (eleventh pass) [REPORTED 2026-07-10]

**READ FIRST:** [`2026-07-09-codex-potential-lp-dual.md`](2026-07-09-codex-potential-lp-dual.md)
(the `Psi` definition, the q=19 Correction-2 replay, the Correction-3 route audit) and
`2026-07-10-codex-q19-psi-selector-hard-surface.md` (the 12-row hard surface).

Origin: Codex 5.6 Max program assessment (2026-07-10), adopted by Fable after cross-check.  The
current reservoir term is `R(S) = zone_v(S) − (q−k)·max(0, q−k−C(k,2)−1)` — an ML-flavored
truncated surplus.  Rowwise, before the truncation, it is a genuine **incidence quantity**: the
collision surplus among used-column blockers, the `C(k,2)` secant traces, and the conic point —
i.e. the multiplicity excess where several nominal blockers land in the same cell.  The `max(0,·)`
may be hiding exactly the q-sensitive incidence identity responsible for the q=17/q=19 selector
conflicts.  This is the one proposal that upgrades the program's strongest positive (`Psi`'s
full-corpus strict descent) from empirical toward provable, on the lane C65 declared primary.

1. **Exact charge:** derive the untruncated per-row/per-cell collision-multiplicity formula
   (blockers × secant traces × conic point), and prove its relation to the current `R(S)`
   (`R = max(0, exact)` rowwise, or document where they diverge).
2. **Move-pair Δ formula:** an exact algebraic expression for the change in collision energy
   under one (opponent, reply) pair, as a function of the incidence geometry of the two cells —
   no game values, no `Z`, no truncation.
3. **Replay:** substitute the exact charge for the truncated slack in `Psi` (refit the four
   weights if needed — this satisfies C63's reopen condition: a genuinely new proof-admissible
   coordinate) and replay the full C63 corpora: q=13 (3,144), q=17 (1,052,204), q=19 fixed-selector
   (2,622,214).  Report failures verbatim.
4. **The split-case test:** check whether the 12 q=19 fixed-C31 `Psi` failures and the six C61
   forced q=17/q=19 conflicts become explicable (or vanish) under the exact charge — i.e. whether
   the truncation was the missing order-sensitive interface coordinate C61 asked for.
5. **Averaging question (the proof shape):** whether averaging `ΔPsi_exact` over an algebraically
   defined reply family forces some `ΔPsi_exact < 0` — the existential bridge to C61's successor
   framing (top-of-queue item 7) and S11's failure-rigidity ledger.

Budget: hours–day, existing dumps + scripts (`s4potential`/`s4potentialprobe`,
`c63-potential-lp.py`), single-core, ≤ 8 GB.
Report file: `notes/2026-07-10-codex-c70-collision-charge.md`.

## C71. `[cap]` Three-involution transition theorem — the first unclassified intruder layer (eleventh pass) [REPORTED 2026-07-10]

**Reported:** [`2026-07-10-codex-c71-third-intruder.md`](2026-07-10-codex-c71-third-intruder.md).
Verdict (3b, exact residual dependence): the after-skeleton is **NOT a function** of the
center-triangle geometry (collinear, pairwise PGL orders, line/polar types) — up to 12–13
distinct after-shapes share one geometric key, 94% of q=19 2→3 transitions live in a violating
key class, and the miss grows with q.  Missing coordinate = the **labelled embedding** of the
live conic cells vs `sigma_z` and its kill-lines (per-cell incidence, not a PGL invariant),
confirming the C45 §4 warning.  Coefficient check positive: `dPsi = dReservoir + 6·dC − 4 −
2·dXor0` exactly, so the transition reproduces `Psi`'s 6/−4 weighting by construction; single-move
`Psi`-nonincrease holds to 99.998% (26 q=19 exceptions = one orbit `P[5]→P[1,1,1]`, equilateral
external `d=5` triangle).  `Psi`-descent reduces to a `dC` rule (needs the labelled coordinate)
plus the C70 reservoir charge; proved gate `D(z)=∅ ⇒ dC ≤ 0`.  New tool: `s4triple` mode in the
solver + `rust/scripts/c71_transition_analysis.py`.

**READ FIRST:** [`2026-07-08-nk-involution-residual.md`](2026-07-08-nk-involution-residual.md)
(Lemma VI, the one/two-intruder classification), the C45 report (defect-skeleton realizability),
and the C63 `Psi` definition.

Origin: Codex 5.6 Max assessment (2026-07-10).  The program understands one intruder (a single
involution matching on the conic) and two (paths + even cycles; even cycles have Grundy 0, so only
Dawson-path defects matter).  **Three or more intruders** — a dynamically growing union of
matchings coupled to the off-conic zone — is the first structurally unclassified layer, and it is
where the maintenance obligations live.  A history-aware transition theorem beats another global
classifier: it would *explain* `Psi`'s `6·defect_components − 4·selected_intruders` terms instead
of refitting them.

1. **Statement target:** given two involution matchings with known defect skeleton (paths/cycles)
   and a third involution with center/axis in known position relative to the first two centers,
   determine exactly how the defect-component count, path spectrum, and conic/zone coupling
   transform.  Use the geometry of the three centers (collinear vs triangle; the center-triangle's
   polar relation to the conic) as the case split.
2. **Mine first:** extract every 2→3-intruder transition from the existing exact q=13/17/19 S4
   Grundy dumps with the C63 feature extractor; tabulate observed (before-skeleton, center
   geometry) → (after-skeleton) and check the map is a function of the geometric data.
3. **Prove the observed table** as a finite-case lemma (Lemma-VI style), or report the exact
   residual dependence if it is not a function of the tested coordinates (that failure names the
   missing history coordinate — equally a deliverable).
4. **Coefficient check:** verify whether the proven transition rule reproduces `Psi`'s 6/−4
   weighting (each new component worth ~6 slack units, each intruder costing ~4) — if yes, `Psi`'s
   descent on 3+-intruder states reduces to the transition theorem plus the C70 charge.

Budget: day-scale; mining from existing dumps, proof by finite case analysis; single-core, ≤ 8 GB.
Report file: `notes/2026-07-10-codex-c71-third-intruder.md`.

## C72. `[cap]` PGL permutation-module / Johnson-scheme decomposition of f_q (A5 lane, eleventh pass) [REPORTED 2026-07-10 — NEGATIVE (read b)]

**READ FIRST:** the §6 witness-count heuristic in
[`2026-07-09-odd-plane-falsification-map.md`](2026-07-09-odd-plane-falsification-map.md) (the
near-point-mass + class-stability framing), the C42 negative
([`2026-07-09-onconic-child-type-alignment.md`](2026-07-09-onconic-child-type-alignment.md)), and
the Cluster-1 closure note at the top of this queue.

Origin: Codex 5.6 Max assessment (2026-07-10).  **Scope guard: this is a concentration
instrument, NOT a fourth config→value dictionary — Cluster 1 stays closed.**  In the full-PGL
conic model let `f_q(B) = 1` iff the six-point on-conic S4 state `B` is P.  For a five-set `A`,
`onP(A) = Σ_{x∉A} f_q(A∪{x})`, and (ON) says the inclusion operator `W₅,₆ f_q` is entrywise
positive.  The §6 data says `onP` is a near-point-mass (dispersion ≤ 0.4) — C42 showed geometric
*census vectors* vary maximally, but nobody has tested whether the *value function itself* has a
harmonic/design identity forcing the link sums to be nearly constant.  That targets the §6
class-stability lemma directly without predicting individual P/N labels (which is what C55/C64/C69
failed at and what this task must NOT attempt).

1. **Build `f_q`** on 6-subsets of the conic from the existing exact bucket labels at
   q = 11, 13, 17, 19 (all computed; the C53 bridge makes bucket labels total on 6-subsets).
2. **Decompose:** project `f_q` onto the eigenspaces of the Johnson scheme `J(q+1, 6)` (the
   `S_{q+1}` module structure) and onto the PGL(2,q) permutation-module components; report the
   spectral mass per component, per q.
3. **Verdict discipline:** flip/control comparison across the depleted {11,17} vs full {13,19}
   orders is mandatory — a spectral signature present only at q=11 is presumed a small-field
   artifact until it survives q=17 (the C64/C69 lesson).
4. **Reads:** mass concentrated in low components ⇒ a design-like identity forces near-constant
   link sums — name the identity and hand it to the A5 lane as the anchor mechanism for
   `maxonN(q) ≤ q−5`.  Substantial high-component mass ⇒ no harmonic identity exists and the
   concentration must come from the arc-depletion arithmetic alone — a full negative deliverable
   that closes this angle cleanly.

Budget: hours–day; existing labels + linear algebra (the 6-subset space at q=19 is C(20,6) =
38,760 — tiny); single-core, ≤ 8 GB.
Report file: `notes/2026-07-10-codex-c72-fq-decomposition.md`.

## C73. `[cap]` Value-blind secant-packet theorem — the off-conic escape structure at the knife edge (twelfth pass) [REPORTED 2026-07-10 — POSITIVE (value-blind L(A) survives; recursion-existence 68/68; failure-gate-2 refuted)]

**Verdict:** the value-blind selector `L(A)` = the maximum-legal-incidence frame-point/on-conic
candidate secant SURVIVES: it uniquely reproduces the packet at all 3 q=17 extremal classes and
its selected line carries a P escape in every one of the 68 classes at q∈{11,13,17,19} (0
failures; meaningful — q=17 base rate is 49%).  The stronger on-conic form ("L(A)'s conic point is
P") is q=17-clean (21/21) but misses at the 2 q=11 knife-edge classes (cls 4,7).  **Failure gate 2
does NOT fire** — incidence recovers the P witness, so the pivot layer is NOT irreducibly
witness-anchored at q=17 (this REDUCES the C44 branch-(ii) risk).  Open: the propagation is tested
(existence), not proved (the game-value reduction needs the tree, not in feat dumps).  Report:
[`2026-07-10-codex-c73-secant-packet.md`](2026-07-10-codex-c73-secant-packet.md); scripts
`rust/scripts/c73_*.py`.

**READ FIRST:**
[`2026-07-10-codex-odd-plane-round1-report.md`](2026-07-10-codex-odd-plane-round1-report.md) §4
(the secant packet + the adversarial controls) and §6 Route 1 (your spec's origin);
[`2026-07-10-offconic-escape-margin.md`](2026-07-10-offconic-escape-margin.md) (the C44 rider —
co-depletion at q=17); the C44 entry item 7 (the (ON)-bifurcation pre-registration this task
serves).  Rescued scripts: `rust/scripts/escape_lines.py` (the packet finder),
`rust/scripts/a5_incidence.py`, `rust/scripts/a5_stab.py`.

The computed fact (verified twice, independently): at q=17, exactly the three knife-edge classes
(onP=1, escape=5) have ALL five P children collinear — the line is the secant joining the unique
on-conic P extension to one of the five conic-frame points, and its four other legal points are
exactly the four off-conic P escapes.  No other q=17 class and no q=11 class has all-P-collinear.
This was recognized post-hoc from P labels; the task is to make it a theorem-grade, value-blind
statement.

1. **Candidate-secant algebra:** derive, for a normalized five-frame `A`, the full family of
   frame-point/on-conic-candidate secants as explicit algebraic objects (no P/N data).  Build the
   complete candidate-secant incidence table at q=11 and q=17 with q=13/19 controls.
2. **Value-blind selector:** seek a projective formula `L(A)` — defined from the frame's
   incidence/arithmetic data only — that selects the observed packet line at the three q=17
   extremal classes.  Test every candidate on all 21 q=17 classes + all 8 q=11 classes before
   reading values (predeclare, then unblind — the round-1 report's own falsification protocol).
3. **Local recursion lemma:** for the selected line, state and test the propagation claim that
   some legal point of `L(A)` is P (chord-value propagation; the packet's 4 off-conic P cells are
   one move deeper into the zone — what does the game value of a secant cell reduce to?).
4. **Success gate:** a value-blind `L(A)` + a local recursion lemma implying a P child on `L(A)`.
   **Failure gates:** an exact q=11/q=17 fan where every candidate formula selects no P child; or
   a proof that selecting the observed secant requires knowing the unique P on-conic child (that
   outcome would confirm the pivot layer is irreducibly witness-anchored — report it plainly, it
   sharpens the C44 branch-(ii) risk).
5. **q=25 hook [CLOSED BY CENSUS 2026-07-10]:** the census landed all-P (28/28), so there is no
   depleted q=25 fan to test the formula against — the pre-registered out-of-sample test is moot
   (ON form vacuously safe; no extremal N class).  The only un-scored piece is the off-conic
   `(1:15:9)` concurrence point (optional, decision-moot).

Budget: hours; existing data + small algebra, single-core, ≤ 2 GB.  This task stays meaningful
whichever way q=25 lands: it is the structure question for the C44 item-7 branch-(ii) pivot.
Report file: `notes/2026-07-10-codex-c73-secant-packet.md`.

## C74. `[cap]` Growing fan-incidence capacity family — the Ω(q) upgrade of the 15-involution lemma (twelfth pass) [REPORTED 2026-07-10 — round 2: line-pencil/tie theorems PROVED, stabilizer gate CLOSED (≤838 bound), residue = one-intruder pencil N-absorption; see top-of-queue bullet + report]

**READ FIRST:**
[`2026-07-10-codex-odd-plane-round1-report.md`](2026-07-10-codex-odd-plane-round1-report.md) §1
(Lemmas A–C — the involutive-completion construction, the fiber–stabilizer identity, the q=17
capacity proof) and §6 Route 2 (your spec's origin); the C68/C68b reports (what the anchor
`maxonN(q) ≤ q−5` needs).  Rescued scripts as in C73.

The proven base: 15 pointed-pairing involutions per five-frame, `Σ_x r_A(x) = 15`,
`r_A(x) ≤ #involutions in Stab(A∪{x})`; at q=17 this PROVES the (ON) statement (N stabilizers
≤ C2 ⇒ capacity 13 < 15).  The proven limits: at q=11 the V4 N-bucket absorbs exactly 15 (XHIST
saturation), and for q ≥ 19 the constant 15 ≤ q−4 gives nothing.  The next depleted order has
q−4 ≥ 21, so **growth in the construction family is mandatory for uniformity**.

1. **Family search:** replace the 15 pairing involutions by a q-growing algebraic incidence
   family (candidates: all involutions with center in a definable locus; higher-order cyclic
   stabilizer elements per the C5-bucket evidence at q=11; conic-polarity-derived pairings).  For
   each candidate define the weight `W_q(A)` = total incidence supply and derive its exact count
   (genus-0 exactness — quadratic-character sums, no Weil loss).
2. **Tactical-decomposition identity:** derive the incidence identity of the family against the
   six-set stabilizer strata (the fiber–stabilizer identity is the proven prototype), giving an
   upper bound on the weight an N fan can absorb per stabilizer type.
3. **Success gate:** `W_q(A) = Ω(q)` uniform lower bound + an independently stated N-absorption
   upper bound that is `o(W_q)` at the depleted orders.  **Failure gates:** the q=11 V4 or q=17
   C2 N-buckets saturate every proposed weight; or every definable family stays `O(1)` — then
   terminate this as fixed-small-q structure and say so (the capacity lemma remains a q ≤ 17
   explanation).
4. **Adversarial half:** use the genus-two automorphism classification (Gutierrez–Shaska, the
   round-1 §3 import) + the exact q=11/q=17 orbit matrices (`M_11`, `M_17`) to adversarially test
   every proposed "special" class — the q=11 forced C5 bucket and q=17 forced order-24 bucket
   must BOTH be covered by any candidate family (the round-1 registry's kill-test), and
   stabilizer-specialness ⇒ P is already refuted, so the family must earn its P-values through
   the capacity count, never by assumption.

Budget: hours–day; algebra + existing data, single-core, ≤ 2 GB.
Report file: `notes/2026-07-10-codex-c74-capacity-family.md`.

## 2026-07-11 C77 Codex increment — peak lemma closed, certificate residue retained

The reservoir-free DROP ledger satisfies the exact all-depth bound
`DROP(S) ≤ 6(q−5)−2 = DROP(root)` for every descendant of an on-conic S4 root in odd order: component
count is at most live-conic vertex count; an intruder pays `−4`; without intruders, any proper
descendant has removed another conic vertex; the root's even number `q−5` of isolates has xor zero.
The proposed A5 identification is negative because `maxonN` uses P/N game labels while
`defect_components` is value-blind and fixed at `q−5` at every such root.  C77 now leaves only the
game-semantic P-certificate/reply-closure problem, not a bank-capacity or peak-bound problem.

## 2026-07-11 C77 continuation — pencil absorption target and q=11 reply graphs

The generic game-semantic reply quotient remains blocked by C61's exact q17/q19 forced conflicts.
C77 therefore merges with C74's explicit one-intruder pencil. Exact maximum-pencil data at
q=11/13/17/19 satisfies `#N off-conic centers ≤ q−8`, tight at q=17. Since C74 proves `d≤5`, this
would leave at least `7−d≥2` P centers and prove odd escape directly if uniform. Static character
and order signatures of the pencil parameter fail across depleted orders, so they do not supply the
proof. At the q=11 knife edge, all 32 distinct P centers have exact winning-reply graphs with perfect
matchings; the graphs collapse to four isomorphism types with multiplicities 10/2/10/10. Report:
[`2026-07-11-c77-game-semantic-reply-graphs.md`](2026-07-11-c77-game-semantic-reply-graphs.md).

## 2026-07-11 C77 continuation — maximum-pencil Low4 packet

Refined the empirical `Ncenters≤q−8` bound to a value-blind two-stage construction. Choose a C74
maximum pencil (`d` minimal), then retain every center whose remaining legal off-conic support is at
most the fourth order statistic (ties included). Every such `Low4` packet at q=11/13/17/19 contains
at least three P centers. The control is sharp: at q=17, 1332/1344 non-maximum lines fail the same
test; at q=11 every non-maximum line fails. A point selector is still impossible—the unique
minimum-zone center is N on six q13 and six q17 maximum pencils—so the theorem must remain
set-valued. Added `fanmoves` to emit exact one-ply values over a whole S3 fan in one solve; tight q17
N centers have 4–16 P children, ruling out a unique forced-escape explanation. Full tables and
scope audit are appended to the C77 game-semantic report.

## 2026-07-11 C77 continuation — exact five-spoke formula

Proved the geometric half of `Low4`. The legal off-conic S4 extensions before choosing a center are
`(q−5)^2`. If `s_e(z)` is the legal off-conic load (including z) on the spoke from z to frame point
e, the five spokes are disjoint away from z, giving
`zone_v=(q−5)^2+4−Σs_e`. A secant spoke has `s_e=q−1−d_e` by C74; a tangent spoke has
`s_e=q−δ_e`, where `δ_e` is the number of distinct intersections with the six opposite-frame chords.
Thus `zone_v=q²−15q+34+Σδ_e−t`, with every `δ_e∈{4,5,6}` and at most two tangent spokes. Checked
exactly on 2,876 maximum-pencil centers through q19. The six tight q17 packets have layers
`K=24:1P`, `K=26:2P+2N`, `K=28:7N`. Since identical `(K,t)` types elsewhere can be both P and N,
the remaining Low4 lemma is game-semantic, not another scalar classification.

## 2026-07-11 C77 continuation — balanced vector and the subfield branch

Refining the scalar score to the sorted five-spoke vector finds a P-pure empirical subtype:
`(d,5,5,6,6)` accounts for 760/760 P occurrences in exact q11/13/17/19 maximum-pencil data. Pure
geometry establishes its existence on every tested prime-field maximum pencil for q=11 through 31,
but not uniformly over prime powers. In GF(25), the five pencils completing `A={0,1,2,3,4}` to the
embedded
`P¹(F5)` have only `(4,6,6,6,6)` centers; the six-set stabilizer is 120. The next proof must therefore
separate generic balanced-center existence/P-purity from a Baer-subline endpoint lemma, with Low4 as
the still-uniform alternative.

## 2026-07-11 C77 correction — the Baer branch is not unique

Testing extension fields corrected the preceding interpretation. Every d=4 pencil has normal form
`A={0,±1,±x}` and an exact four-rational-function balanced selector. Its singleton criterion matches
the geometric defect computation for every x in all tested fields. Besides characteristic-5
`x=±2` (the embedded `P¹(F5)`), characteristic-7 `x∈{±2,±3}` also has no balanced center and persists
in GF(49)/GF(343). The generic route now needs a finite equality-case proof with these two explicit
exceptions, plus the still-open d=5 geometry and game-semantic P-purity.

## 2026-07-11 C77 continuation — d=5 reduces to four ledger bounds

In normal form `A={0,1,r,s,rs}`, the twelve opposite-edge pairing certificates give explicit
rational center parameters. Their legal parameter degree exactly counts nonprimary defect-5 spokes,
so balanced centers are degree two. Across every tested maximum form through GF(49), the exact
ledger satisfies `T≥10`, forbidden weight `≤3`, `n1≤4`, and legal degree `≤2`; therefore
`T-F=n1+2n2` forces `n2≥2`. The d=5 geometry is no longer an unstructured existence question: its
remaining proof is precisely these four bounded field-algebra inequalities.

## 2026-07-11 C77 continuation — paired labels prove `n1≤4`

The twelve directed d=5 certificates satisfy four exact identities forced by `1·rs=r·s`:
`C(1,r)=C(s,rs)`, `C(1,s)=C(r,rs)`, plus the two reversed identities. Hence eight labels are paired
and only four directed cross edges can be singletons, proving `n1≤4`. The remaining uniform ledger
proof has three inequalities (`T≥10`, forbidden weight `≤3`, legal degree `≤2`); every nonmaximum
primary-d5 control with a hidden d4 line violates at least one of exactly these three.

## 2026-07-11 C77 continuation — explicit `T≥10` pole packet

The four paired and four singleton certificate poles are now explicit low-degree polynomials in
`r,s`. A pole is a product collision on `(f,∞)`; two at one source make that line d4. After the four
label-pairing identities, only fourteen distinct-source patterns could give three or more poles:
eight pair+singleton, two disjoint pairs, and four singleton triples. No such pattern survives in
the controls; `A=F=0 => B=0` is proved directly and symmetry supplies its mate, leaving twelve raw
finite implications for the uniform `T≥10` proof.

## 2026-07-11 C77 continuation — pole packet closed

The fourteen possible distinct-source pole patterns form three rectangle-symmetry orbits. Their
representatives close directly: `A=F=0 => B=0`; `A=C=0` forces the primary d4 form
`{±1,±s}`; and `E=F=G=0` forces `rs=1` then `s=1`. Hence `T≥10` is proved uniformly. The d=5
certificate ledger retains only forbidden weight `≤3` and legal degree `≤2`.

## 2026-07-11 C77 continuation — forbidden-weight controls form one template

Every computed primary-d5 `F>3` control consists of one forbidden paired label plus two forbidden
singletons, with the pair coincident with one singleton at a degree-three forbidden parameter. No
other weight-four pattern occurs through GF49, and every instance exposes a hidden d4 line. This
reduces `F≤3` to one rectangle-symmetry rational-equality orbit.

## 2026-07-11 C77 continuation — forbidden template itself is d4

The unique template resolves to `C(1,r)=r²s=C(1,rs)`, plus one second forbidden singleton. The two
displayed certificates are distinct product collisions on the same line `(1,r²s)`, so the template
directly contradicts dmin5. What remains is the finite assignment-classification lemma showing every
weight-four forbidden pattern has this form up to rectangle symmetry.

## 2026-07-11 C77 continuation — legal-degree frontier is three equality orbits

All legal degree-3/5 controls already contain two collision certificates sharing a source, hence a
d4 line. The only patterns not closed by that immediate incidence argument are pair+disjoint
singleton, opposite paired labels, and three singleton labels. None occurs through GF49; proving
these three rectangle-symmetry orbits impossible gives the uniform legal-degree bound.

## 2026-07-11 C77 continuation — degree orbits become three identities

The pair+disjoint-singleton representative `C(1,r)=C(rs,1)` forces `C(1,s)` to the same value and
therefore a d4 line at source 1. Opposite-pair and triple-singleton representatives never occur in a
primary-d5 form. The remaining degree proof is precisely the three corresponding rational
cross-multiplications.

## 2026-07-11 C77 continuation — legal degree bound proved

Factoring the three representative cross-multiplications closes every nonincident merge: the first
forces a second collision at the same source, the second forces the primary `{±1,±s}` d4 form, and
the singleton equality forces `r=1` or `s=1`. Hence legal certificate degree is uniformly at most
two. The d5 ledger now retains only forbidden certificate weight `F≤3`.

## 2026-07-11 C77 continuation — rigid forbidden target table

The forbidden monomial for each of the four paired and four singleton labels is now restricted by an
explicit eight-entry table, with zero violations through GF49. The final `F≤3` classification splits
into three bounded statements: at most one paired target; pair plus two singletons is the incident
d4 template; and no-pair configurations have at most three singleton targets.

## 2026-07-11 C77 continuation — paired forbidden targets bounded

Factoring adjacent and opposite simultaneous paired-target equations proves that at most one paired
label can be forbidden in a maximum d5 pencil: the adjacent case violates distinctness and the
opposite case forces the primary `{±1,±s}` d4 form. The target-table proof now has two subclaims left.

## 2026-07-11 C77 continuation — singleton-pair orbit closed

The unique compatible singleton-pair representative factors to two linear relations whose
elimination forces the corresponding paired forbidden target. It therefore lands in the already
proved incident d4 template. Only the finite exhaustiveness of the forbidden target/pair table
remains for `F≤3`.

## 2026-07-11 C77 correction/closure — forbidden audit complete

The earlier singleton-pair statement had one characteristic-3 exception. The complete seven-orbit
label/target audit and five-orbit singleton-pair audit prove the target table and isolate that genuine
weight-two family; it has no paired target and cannot accept a third singleton. All other pair orbits
are d4/impossible or enter the incident template. Hence `F≤3`, and the d5 ledger proves at least two
balanced centers on every maximum d5 pencil. The d5 geometry is closed.

## 2026-07-11 C77 continuation — d4 equality split closed

Factoring the six candidate-badness equations and auditing their intersections proves that the only
d4 pencils without a balanced center are characteristic-5 `x=±2` and characteristic-7
`x∈{±2,±3}`. Cross/common collisions otherwise leave two singleton candidates. With d5 already
closed, generic balanced-center existence geometry is complete; the open content is P-purity plus
the two small-prime-subfield game branches.

## 2026-07-11 C77 continuation — simple affine mirror refuted

At q11, none of the 32 balanced roots admits a root-safe involution from the full affine grid
automorphism group (including coordinate swap). Fixed-point-free alone gives N-root false positives
whose response pairs are illegal. Balanced P-purity therefore cannot be a fixed affine mirror
strategy; continue with adaptive/non-affine replies or a decomposition theorem.

## 2026-07-11 C78 — `PG(4,5)` complete-cap quick deliverable

Formalized the universal finite pair-cover counting kernel and its 781-point/four-per-secant
consequence `t₂(4,5) ≥ 21`; mathlib's projectivization cardinality theorem checks that `PG(4,5)` has
781 points. Added a 13-word exact `PGL(5,5)` orbit probe. It reproduces the independent Python
counts through size 5 and closes size 6, giving `[1,1,1,1,2,4,10]`; no complete-cap orbit occurs in
the expanded layers. A wall-safe size-7 run stops at 120.023 s, locating the immediate bottleneck in
exact frame canonicalization rather than board representation or early orbit count. Full report:
`notes/2026-07-11-c78-pg45-complete-cap-quick-deliverable.md`.

## 2026-07-12 C100 — relative-conic sealing bridge and review lane

Allocated C100 after observing concurrently reserved C99. The Lean bridge is landed on the isolated
`RelativeConicArcs` side: every cap continuation of a `CompleteOutside A H` seed stays in `A∪H`, so
all later legal moves lie in `H`. The active review covers the q9 terminal witness, q11 icosahedral
P residual, exact-corpus descent/reachability, and defect-to-C80 potential transfer. Report:
`notes/2026-07-12-c100-relative-conic-game-bridge.md`.

## 2026-07-12 C100/C101 — q=11 residual landed; q=16 exact gap allocated

- C100 now contains a strict-trust q=11 theorem package: all twelve conic parameters are live, the
  determinant conflict graph is the icosahedral graph, and the antipodal mirror proves the residual
  independent-set game P.
- Allocated C101 for the manuscript's remaining exact finite gap `rho_C(16) in {8,9}`. Its accepted
  endpoint is either a checked eight-point construction or a checked exhaustive nonexistence
  certificate, followed by synchronized Lean and paper updates.

## 2026-07-13 C106–C110 — relative-conic structural strengthening allocated

Allocated a new downstream lane after the completed arcs formalization exposed three connected
theorem packages: an exact finite-field evaluation-avoidance dichotomy, the projective
arc–MDS/deep-hole bridge, and a preliminary `q=11` icosahedral `A5`/MDS-extension structure. C106
is the cheap independent refutation and certificate-freeze gate; C107 and C108 are the reusable
universal formalizations; C109 is the gated q11 finite structure; C110 owns rigorous novelty
collision searches, adversarial review, discovery classification, and synchronized publication and
consumer updates. Live plan:
`notes/handoffs/2026-07-13-relative-conic-arcs-strengthening.md`.

## 2026-07-13 C106 — independent q11 and evaluation gates reported

Two standalone implementations (Python and C++) independently rebuild `PG(2,11)`, `PGL(2,11)`,
the symmetric-square conic action, the six-point witness, all affine syndromes, and every extension
column. They agree on stabilizer order 60, element orders, seven point orbits, secant-index and coset
leader distributions, 12 conic extensions, and the icosahedral conflict graph. Projective coordinate
conjugation/relabeling passes. Replacing one witness point changes the extension count 12→20 and
stabilizer 60→2; a mutated generator is rejected. The chord color classes are five-edge
near-perfect matchings, correcting the allocated wording. A separate exhaustive small-field gate
shows at most `q` proper hyperplanes cannot cover, while the `q+1` lines cover `F_q²`; C107 is
strengthened accordingly. The exact-object literature gate identifies the six-set/orbit structure
and general arc/coset dictionary as prior art, leaving only the relative-conic coding/extension
synthesis as a bounded-search novelty candidate. Full commands and hashes are in the strengthening
companion archive.

## 2026-07-13 C107–C109 — latent-potential review narrows and strengthens the plan

The approved formalization plan now targets the paper's central prescribed-hole defect identity as
an exact weight-two-leader collision theorem for codimension-three projective MDS codes, rather than
stopping at the standard arc/code dictionary. C107 adds the sharp dimension-sensitive count of
avoiding vectors. C109 is narrowed to a single checked q11 code/extension module with exact
independence polynomial `1+12t+36t²+20t³`; a new abstract `A5` isomorphism is no longer a gate.
The seed is the classical Clebsch hexagon and its `N3=10` orbit is the known Brianchon-point ten-arc,
so those names and sources are prior-art interpretation, not novelty claims. Full rationale and
discovery ledger: `notes/handoffs/done/2026-07-13-relative-conic-arcs-strengthening-archive.md`.

Adversarial refinement: the general multi-column extension object has both pair and triple conflict
hyperedges; graph independence is valid here because the relative-completeness theorem confines all
extensions to the prescribed conic, itself an arc. C108 now states both levels and the resulting
maximal-independent-set classification of ordinary complete superarcs.

## Archived 2026-07-14 from the live queue

Second live-map / companion-log pass, same rules as the 2026-07-11 block above: bodies moved
**verbatim**, in original file order, with their original relative link depth (this archive sits
in the same `notes/` directory as the live doc, so every relative link resolves identically; no
links were rewritten).

Moved: every remaining **REPORTED / CLOSED** task body. The live doc keeps only genuinely open
work — active, queued, gated, or carrying an explicit open tail — plus the compact CURRENT TOP OF
QUEUE, whose per-lane prose already carries the one-line pointer for each closed lane.

By lane:

- **`clebsch`** — C121–C127, C129, C130, C132. The lane's live map is its handoff
  ([`handoffs/2026-07-13-clebsch-paper.md`](handoffs/2026-07-13-clebsch-paper.md)); C128 and C131
  stay live as the only open items.
- **`relconic`** — C89–C96 (arcs formalization), C100, C101, C106, C108, C109. C107 (shared
  aggregate pending) and C110 (in progress) stay live.
- **`repaircodes`** — C97, C98, C102–C105, C111–C114. Nothing open remains in this lane.
- **`baer`** — C99, C133. C134 (queued) stays live.
- **`cap`** — C75, C76, C78, C79, C85–C88. The open frontier (C13, C30, C74, C77, C80–C84) and
  the C56 do-not-start guard stay live.

The former **"Reported this pass"** grouping is retired with this pass: it was a dated session log
inside a live doc, and its three entries (C75, C76, C78) are all REPORTED, so they are archived
here as ordinary entries rather than kept under a pass-scoped heading.

Everything from the `---` below is the verbatim moved content.

---

- **C133 `[baer]` [REPORTED 2026-07-14]** — residual C99.6 is valid generically and kernel-checked:
  cross-pair endpoint orbits exclude two mate lines, giving occupied-center capacity
  `f+(e-2)` and at least `s+3-f-e` empty carriers →
  `notes/2026-07-13-c99-baer-collision-strengthening.md`
- **C121 `[clebsch]`** — Aut(code)=A₅ + 2-transitive CONFIRMED; deep-hole leaders = **two** size-10 orbits (not
  one). `[REPORTED 2026-07-13]` → `notes/2026-07-13-c121-icosahedral-mds-checks.md`
- **C122 `[clebsch]`** — novelty audit: headline = "deep holes = F_q-points of a named variety + dual-variety
  conjecture"; drop "first non-GRS"; blocking O'Keefe–Storme arc check. `[REPORTED 2026-07-13]` →
  `notes/2026-07-13-c122-deep-hole-novelty-audit.md`
- **C123 `[clebsch]`** — k=4 dual-variety test: **CLOSED NO-GO** (2 independent adversarial passes). Conjecture
  ill-posed + tautological at k=3 + FALSE at k=3 (q=19 hexagon: ≥105 deep holes vs 20) + impossible
  at k=4 (plane∩ruled-surface; bisecant capacity Ω(q³)) + ZWK 2020 subsumes/refutes GRS shadow. Do
  not compute; record impossibility lemmas + q=19 counterexample instead.
- **C124 `[clebsch]`** — L2: Petersen (adjacency "share 2 of 3") + chirality Z/2 (orbit-swap = odd perms)
  CONFIRMED; five-tetrahedra pairing REFUTED (A₅-on-10 primitive). `[REPORTED 2026-07-13]` →
  `notes/2026-07-13-c124-petersen-chirality.md`
- **C125 `[clebsch]`** — L1: REAL — genuine reduction mod 11 of Klein's forms/group (f→12 conic pts, six
  diagonals→chords, poles→arc); 11 uniquely optimal (p+1=12). `[REPORTED 2026-07-13]` →
  `notes/2026-07-13-c125-klein-resolvent.md`
- **C126 `[clebsch]`** — Family A: chirality-iff-reflection-free CONFIRMED as theorem (Hom(A₄/A₅,ℤ/2)=0);
  but complete-outside-conic + clean Z/2 are **UNIQUE to icosa/p=11** (octa/cube/dodeca degenerate)
  → q=11 singular, family is a foil. `[REPORTED 2026-07-13]` → `notes/2026-07-13-c126-platonic-family.md`
- **C127 `[clebsch]`** — novelty: arc = **Clebsch hexagon** (KNOWN; SVM 1995 + Dye 1991); Klein reduction
  PARTIAL (hedge Elkies §3.3, Dickson invariant); coding bridge NOVEL; "Adler icosahedron/PSL₂(11)"
  paper does NOT exist. Must-read: Dye 1991. `[REPORTED 2026-07-13]` →
  `notes/2026-07-13-c127-klein-reduction-novelty.md`
- **C130 `[clebsch]`** — parent-program feed: **CLOSED NEGATIVE** — both levers shared-machinery-but-no-new-
  content (Lever 1 wrong quantifier dir + dim-1, only reproduces classical √(2q) sealing bound; Lever
  2 = corollary of parent Thm 2.1/Cor 2.2). Spin-off does not feed C84; don't route C84 through it.
  `[REPORTED 2026-07-13]` → `notes/2026-07-13-c130-parent-feed.md`
- **C129 `[clebsch]`** — must-read sources: **Dye-1991 gate CLEARED** (verdict NO via Dye's own zbMATH review +
  SVM Remark 2 + Dye 1997 recap — safe to draft w/ footnote, ILL open); citations locked (ZWK I.4–I.7,
  DMP 1909.00207, O'Keefe–Storme, Hirschfeld–Sadeh 1984). `[REPORTED 2026-07-13]` →
  `notes/2026-07-13-c129-mustread-sources.md`
- **C132 `[clebsch]` [CLOSED NEGATIVE 2026-07-14; ADVERSARIALLY CORRECTED]** — none of the four tested
  second-instance targets realizes the arc/deep-hole template. The 27-line model is correctly
  `Q⁻(5,2) ⊂ PG(5,2)` (not `PG(5,4)`), hence has 36 external points but is non-cap because it
  contains 45 lines. Valentiner and Hesse finite checks now have a durable independent verifier;
  57-cell fails the group-order gate. This closes the spike, not the global `P¹` search. Report:
  `notes/2026-07-14-c132-second-instance-spike.md`.
- **C106 `[relconic]` [REPORTED 2026-07-13] — relative-conic strengthening refutation/certificate gate.** Independent Python/C++ replays agree on the q11 group, orbit, secant, syndrome, leader, chord, and extension data; coordinate and mutation controls pass. The evaluation range strengthens sharply to `|A|≤q`; the chord colors are five-edge near-perfect, not perfect, matchings. Track in the [strengthening handoff](handoffs/2026-07-13-relative-conic-arcs-strengthening.md).
- **C108 `[relconic]` [REPORTED 2026-07-13] — projective arc–MDS/syndrome-defect bridge.** `SyndromeGeometry.lean` and `CodingBridge.lean` kernel-prove transparent MDS parameters, syndrome distance, the actual-affine-leader/support cardinality bijection through weight three, exact affine leader counts, relative-completeness confinement, the leader-collision defect form, the general pair/triple extension hypergraph, and its arc-confined graph/maximal-completion specialization. Focused builds and axiom audit pass. Same handoff.
- **C109 `[relconic]` [REPORTED 2026-07-13] — q11 certified code and MDS-extension spectrum.** `Q11Coding.lean` proves the non-GRS `[6,3,4]₁₁` code, covering radius three, exact conic projective deep-hole locus, syndrome/leader distributions, tangent-antipode chord partition, and extension polynomial `1+12t+36t²+20t³`, including zero maximal 0/1-extensions, six maximal 2-extensions, and twenty maximal 3-extensions. The classical Clebsch-hexagon/`A5` interpretation is cited, not rebuilt. Same handoff.
- **C111 `[repaircodes]` [REPORTED 2026-07-13] — projectively completed cubic–axis seed.** Strict-trust Lean proves `[2q+2,4,q]_q`, nonzero/projectively-distinct columns, and exact global dual distance three. Independent `q=3,9,27` replay, conjugation/deletion/mutation controls, aggregate build, scans, and XH1 passed. Track in the [projective-completion handoff](handoffs/done/2026-07-13-projective-completion-repaircodes.md).
- **C112 `[repaircodes]` [REPORTED 2026-07-13] — exact completed-seed repair ports.** Strict-trust Lean proves the exact radius-three clutters and rows, the generic rank-`k` minimal-repair cutoff and full-port separator theorem, radius-four equality with the full minimal inner port, and exact uniform full rows: cubic `((q-1)/2,q-1)`, axis `((5q-3)/6,2q-3)`. The radius-four matching proof quantifies over every minimal edge and does not assume an explicit five-circuit catalogue. Exhaustive q=3,9 replay, focused/aggregate builds, scans, standard-axiom audit, and XH3/XH4 pass. Same handoff.
- **C113 `[repaircodes]` [REPORTED 2026-07-13] — completed-seed lift and asymptotic family.** Strict-trust Lean proves q9 `[20N,4K,>=9D]_9`, exact `10N/10N` coordinate multiplicities, exact mixed locality, equality of every lifted repair hypergraph through radius four with one embedded inner block under outer dual distance six, and exact radius-four rows `(4,8)` and `(7,15)`. The Stichtenoth specialization gives unbounded length, exact rate `1/10`, and every eventual `c<351/1600` distance bound. The theorem explicitly does not claim the lift's unbounded full port. Focused/aggregate builds, scans, axiom audit, and XH5 pass. Same handoff.
- **C114 `[repaircodes]` [REPORTED 2026-07-13] — projective-completion novelty and publication closure.** Primary-source and targeted exact-claim searches classify the projective geometry, ordinary code parameters, rank cutoff, concatenation, and rate/distance arithmetic as classical or derived; only the exact completed repair rows and bounded radius-four transfer retain cautious none-found candidate wording. The manuscript/PDF, proof ledger, novelty audit, TRUST manifest, paper registries, queue, and handoffs are synchronized. A final adversarial paper--Lean pass exposed and closed one packaging-only gap by exporting the already-uniform cubic/axis exact-locality proofs under generic theorem names. XH6, focused/aggregate builds, forbidden scan, axiom audit, TeX build, and release checklist pass. External specialist citation-chain review remains submission preflight, not a mathematical or formalization blocker. Same handoff.
- **C101 `[relconic]` [REPORTED 2026-07-12] — exact `rho_C(16)`.** The complete projective augmentation books
  give 2633 eight-arc classes. Quadratic evaluation rank rejects 2630; the remaining three have a
  forced arc hit. Lean proves no relative-complete eight-arc and `rhoC(16)=9`. Final map:
  [rho_C(16) handoff](handoffs/done/2026-07-12-rhoc16-exact-value.md).
- **C102 `[repaircodes]` [REPORTED 2026-07-13] — extension-field trace bridge for RepairCodes.** Kernel-proved in
  `RepairCodes/TraceDual.lean`, including exact support preservation. Track in the
  [Lean formalization handoff](handoffs/2026-07-11-lean-formalization-plan.md).
- **C103 `[repaircodes]` [REPORTED 2026-07-13] — asymptotically good RepairCodes outer family.** The concrete
  family theorem is Lean-checked from exactly one cited import, Stichtenoth Theorem 1.6(ii).
  Track in the [Lean formalization handoff](handoffs/2026-07-11-lean-formalization-plan.md).
- **C104 `[repaircodes]` [REPORTED 2026-07-13] — exact general cubic matching.** The exact row `((q−1)/2,q−2)` is kernel-checked for every finite characteristic-three field. The q3/infinity branches, package build, paper, novelty posture, and registries are synchronized; track in the [RepairCodes strengthening handoff](handoffs/done/2026-07-13-repaircodes-strengthening-plan.md).
- **C105 `[repaircodes]` [REPORTED 2026-07-13] — transfer-gate boundary examples.** Both exact numerical boundaries have nondegenerate kernel-checked counterexamples at the level of literal complete repair hypergraphs. Manuscript, novelty posture, trust manifest, and registries are synchronized; track in the [RepairCodes strengthening handoff](handoffs/done/2026-07-13-repaircodes-strengthening-plan.md).
- **C99 `[baer]` [REPORTED/CLOSED 2026-07-14] — post-formalization second-order application
  revisit.** The subtraction-free linewise and aggregate collision identities are Lean-proved.
  The exact accounting and the full `f=2` pair-extension theorem are Lean-proved. The exact
  invisible-orbit↔center-on-carrier characterization, aggregate center double count, and local
  `GF(5)` center-capacity lemma are also Lean-proved. The profile-specific cross-pair occupied-line
  bound are now specialized to the `(4,2)` profile in `Q25ProfileFour`, yielding a kernel-checked
  lower bound of four legal pairs and a semantic pair-extension theorem. `Q25ProfileZero` proves
  the `(0,4)` moment argument and a lower bound of five legal pairs without certificates;
  `Q25AllProfiles.pair_extension` proves the uniform eight-arc extension theorem. The two external
  `f=2` enumerations support only the unproved census/minimum claims. Track in the
  [paper appendix](2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md#appendix-a--second-order-corollaries-extensions-and-application-queue)
  [proof ledger](2026-07-13-c99-baer-collision-strengthening.md), and
  [novelty audit](2026-07-13-baer-completion-adversarial-novelty-review.md).
- **C100 `[relconic]` [REPORTED 2026-07-12] — relative-conic game localization.** The exact recursive
  parametrized-hole bridge, q=9 terminal P theorem, and actual q=11 seeded P theorem are
  strict-trust Lean-proved. The tested two-ply descent closures are absent and the exact uncovered
  translation does not sharpen C80's minimax potential; this is not an (ON) theorem. Report:
  [C100 relative-conic game bridge](2026-07-12-c100-relative-conic-game-bridge.md).
- **C89 `[relconic]` [REPORTED 2026-07-12] — relative-conic-arcs foundation.** The isolated
  `RelativeConicArcs` target now reuses Mathlib's `Configuration.ProjectivePlane`; arc/secant/hole
  vocabulary, maximal relative completion, attained `rho`, coordinate order `q`, and the exact
  `Arc ↔ ProjectiveCap.Projective.Cap` bridge are Lean-proved. Build is warning-free; headline
  axioms are `[propext, Classical.choice, Quot.sound]`. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).
- **C90 `[relconic]` [REPORTED 2026-07-12] — classical secant moments.** Literal unordered endpoint pairs,
  canonical pair lines, and pairwise-disjoint endpoint fibers prove `r_A(x)≤⌊|A|/2⌋`; finite
  double counts prove `Σr=C(k,2)(q−1)` and `ΣC(r,2)=3C(k,4)`. The warning-free target builds and
  headline axioms are `[propext, Classical.choice, Quot.sound]`. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).
- **C91 `[relconic]` [REPORTED 2026-07-12] — prescribed-hole defect identity.** The split moments give the exact
  integer-normalized defect identity. Maximum-index bounds prove nonnegativity, coverage/uncovered
  inequalities, the equality criterion, and quantitative stability. The warning-free target builds;
  headline axioms are `[propext, Classical.choice, Quot.sound]`. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).
- **C92 `[relconic]` [REPORTED 2026-07-12] — conic specialization and finite lower bounds.** The Veronese conic
  is exactly `XZ=Y²` with `q+1` points; nonsingular conics are explicit projective images and have
  invariant `rhoC`. Abstract `q+1`-hole specialization, parity capacities, and
  `L1(q) ≤ L2(q) ≤ rhoC(q)` are Lean-proved. The warning-free target builds; headline axioms are
  `[propext, Classical.choice, Quot.sound]`. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).
- **C93 `[relconic]` [REPORTED 2026-07-12] — additive `3/2` asymptotic.** The parity-free cubic inequality gives
  the explicit bound `rhoC(q)≥sqrt(2q)+3/2−8/sqrt(2q)`. The shortfall is
  `O(1/sqrt(2q))`; operational and literal liminf statements are formalized over indexed families
  of actual finite fields. The warning-free target builds; headline axioms are
  `[propext, Classical.choice, Quot.sound]`. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).
- **C94 `[relconic]` [REPORTED 2026-07-12] — projective averaging transfer.** Finite transitive-action averaging
  gives a disjoint projective image for every ordinary complete arc of size at most `q`, proving
  `rhoC(q)≤t2(2,q)` when `t2(2,q)≤q`. The Kim–Vu input is an explicit named hypothesis, not an
  axiom; the warning-free target and axiom audit pass. Track in
  the [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).
- **C95 `[relconic]` [REPORTED 2026-07-12] — even-characteristic nucleus constraints.** The standard conic plus
  `[0:1:0]` is a hyperoval in characteristic two, giving the exact tangent classification and both
  nucleus-in/nucleus-out count, parity, incidence, and corrected-bound packages. The warning-free
  build and strict axiom audit pass. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).
- **C96 `[relconic]` [REPORTED 2026-07-12] — certified small examples and trust audit.** A generic rules-only
  checker reduces coverage to `q²+q+1` canonical representatives and proves accepted raw data
  semantically complete outside the conic. Frozen kernel checks prove `rhoC=6` at `q=8,9,11` and
  the preliminary bound `8≤rhoC≤9` at `q=16`; C101 subsequently closes it to `rhoC=9`. The
  warning-free build, provenance, isolation, forbidden-token, and axiom audits pass. Track in the
  [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).
- **C97 `[repaircodes]` [REPORTED 2026-07-13] — full coding/LRC paper assembled and internally audited.**
  the package now at `papers/complete-repair-ports/` contains the 12-page manuscript/PDF, proof ledger, and
  adversarial novelty report. The Lean aggregate, strict token/axiom scan, bibliography, and PDF
  build pass. The audit explicitly returns repair tolerance to prior art and narrows the surviving
  candidate novelty to exact all-symbol `(ν,τ)` separation and complete-hypergraph transfer.
  External specialist citation-chain review remains a submission preflight gate, not a
  formalization or manuscript blocker. Track in the
  [Lean formalization handoff](handoffs/2026-07-11-lean-formalization-plan.md).
- **C98 `[repaircodes]` [REPORTED 2026-07-12] — theorem-mining and novelty review.** The completed proof graph
  yielded the sufficient `r+1<2d(I⊥)` transfer gate, a coordinate-free symbol-module extension, exact
  row-distribution transfer, and a square-root-of-minus-one rainbow certificate beyond q9.
  The internal literature audit is complete; an external specialist citation-chain review remains
  a submission preflight gate. See the classified results in the
  [Lean formalization handoff](handoffs/2026-07-11-lean-formalization-plan.md).
- **C85 `[cap]` [REPORTED 2026-07-12] — quadratic split-route obstruction.** Chevalley–Warning now proves
  every finite odd-field quadratic form of dimension at least three isotropic; the `±1`
  eigenspace decomposition and scalar-square normalization close the split linear parabolic
  branch. `ProjectiveCap` builds; strict axiom profile is
  `[propext, Classical.choice, Quot.sound]`. Track in the
  [mirror-boundary handoff](handoffs/done/2026-07-12-mirror-boundary-formalization.md).
- **C86 `[cap]` [REPORTED 2026-07-12] — Hermitian linear obstruction.** Relative Frobenius, quadratic norm
  surjectivity/square reflection, and two-vector orthogonalization prove finite Hermitian isotropy;
  scalar-square eigenspaces exclude the split route, while `Norm(c)=μ²` excludes a nonsquare
  similitude scalar. `ProjectiveCap` builds; strict axiom profile is
  `[propext, Classical.choice, Quot.sound]`. Track in the
  [mirror-boundary handoff](handoffs/done/2026-07-12-mirror-boundary-formalization.md).
- **C87 `[cap]` [REPORTED 2026-07-12] — Baer-semilinear obstruction.** Constructive projective conjugacy,
  scalar Hilbert 90, fixed-value quadratic descent, semilinear pullback untwisting, and a
  coordinate-free null-cone rigidity theorem close the modeled square-scalar Baer branches for
  both Hermitian and parabolic boards. The parabolic theorem accepts projective board preservation
  directly. The imported stabilizer axiom was deleted; focused and aggregate builds pass, and every
  load-bearing theorem has axiom profile `[propext, Classical.choice, Quot.sound]`. Track in the
  [mirror-boundary handoff](handoffs/done/2026-07-12-mirror-boundary-formalization.md).
- **C88 `[cap]` [REPORTED 2026-07-12] — elliptic `Q⁻` boundary classification.** The proposed exclusion is
  false. Chevalley–Warning supplies a nonsquare-discriminant anisotropic tail compatible with the
  nonsplit block map, giving a fixed-point-free mirror and P theorem for the standard elliptic
  coordinate form in every even vector dimension. P/N transport through a supplied projective
  linear equivalence is formal. Focused and aggregate builds pass; strict axiom profile is
  `[propext, Classical.choice, Quot.sound]`. Track in the
  [mirror-boundary handoff](handoffs/done/2026-07-12-mirror-boundary-formalization.md).
- **C79 `[cap]` [REPORTED 2026-07-12 — arithmetic coordinates + bulk-gap spec delivered; continuation →
  C80/C81/C82]** — number-theoretic forcing architecture for the full odd-q
  ProjectiveCap proof: test common-torus/dihedral reduction of conic involutions, character-sum or
  polynomial-count existence of repair packets, and Frobenius/subfield descent for the
  characteristic-5/7 exceptions. **First gates:** common-torus recursion is closed (all applicable
  q11/q17 hard triples noncommuting); a five-ray quadratic-character core is locally exact but has
  no extremal selector; maximum-pencil moment/character quotients either collide or become a fully
  marked fingerprint. The positive structural model is the q17 score-9 packet: four primitive
  split/nonsplit candidates, with the unique maximum-zone-edge candidate clean/P in all 28
  transitions. Its zone is one 9-vertex graph; `ProjectiveCap.PrimitiveZoneBase` now Lean-checks its
  Grundy-zero value. Full conic-stabilizer orbital vectors expose a generic score-9 fiber: 24/28
  clean repairs are the unique `(q+1,q+1,q+1)` primitive triple intersections, with four explicit
  exceptional fibers. Hollmann--Xiang intersection numbers are therefore the next reply-counting
  algebra (with odd-q formulas still to derive). Fused quadratic-character relations give an
  abundant two-variable packet only against boundedly many guards. Literal retirement of old
  intruders is impossible while more than half the conic is live: distinct involutions share at
  most one full-conic edge, any such shared edge is dead once both centers are selected, and each
  retains at least `(q-1)/2-d` live edges after `d` deleted vertices. The decisive
  prerequisite is a bulk quotient absorbing many genuinely active matchings. The exact relation polynomial
  `D_x(y)=(2-rv-cu)^2-4(rc-1)(uv-1)` simultaneously gives line-conic and split/nonsplit type and is
  exhaustively convention-checked through q19. For the bulk operator `B=sum P_sigma`, the full
  orbital pair distribution is exactly `tr(B^2)` — a permanent redundancy audit for any proposed
  classifier. On the 24 generic score-9 rows minimum `tr(B^2)` only ties the clean repair with one
  decoy (74 vs 74, others 78); `tr(B^3)` breaks that tie (60 vs 84), and no coordinatewise moment
  rule through `tr(B^4)` covers the four exceptional rows. **Moment lane capped:** moments are
  bulk-audit/bounding language; further moment-selector search re-enters the closed
  static-signature lane. The rule fails below score 9, so continue with packet existence plus a new
  generic descent, not arithmetic P/N classification. Report:
  [`2026-07-11-c79-number-theoretic-forcing.md`](2026-07-11-c79-number-theoretic-forcing.md).
- **C76 `[cap]` [REPORTED 2026-07-11 — invariant prong answered]** —
  frame-relative characters (polar-at-frame, frame-chord, frame×tangent cross-ratio profiles) — the
  frame-awareness the (x,z)-local selector space omitted — cut the C75 collisions **48→1**: they split
  47/48 enumerated twins (polar+chord) and separate the winner/loser classes almost everywhere. **But
  the augmented space is NOT orbit-injective** (1 residual hard twin, q=17 axis points P `11,0`/N
  `16,0`), **no scalar reduction is monotone** (39/48 and 38/48 separators are direction-MIXED), and
  **no uniform linear selector exists** (C77-selector-test LP infeasible over d=37). So it buys
  separation, not selection — routing the escape proof to a **game-semantic reply closure**. Report:
  [`2026-07-11-c76-frame-aware-invariant-orbit-injectivity.md`](2026-07-11-c76-frame-aware-invariant-orbit-injectivity.md);
  scripts `rust/scripts/c76_invariant_hunt.py`, `rust/scripts/c76_directional_search.py`,
  `rust/scripts/c77_augmented_selector.py`.
- **C78 `[cap]` [REPORTED 2026-07-11]** — Lean-checked the universal pair/secant-cover bound and the
  `PG(4,5)` numerical consequence `t₂(4,5) ≥ 21`; the exact wide-bitset `PGL(5,5)` census has orbit
  curve `[1,1,1,1,2,4,10]` through size 6, while a wall-safe size-7 run cuts off at 120.023 s.
  Representation is solved for the probe; exact canonicalization is the measured next lever.
  Report: [`2026-07-11-c78-pg45-complete-cap-quick-deliverable.md`](2026-07-11-c78-pg45-complete-cap-quick-deliverable.md).
- **C75 `[cap]` [REPORTED 2026-07-11]** — value-blind reply-selector impossibility. 19 of 108 hard obligations
  hold a P and an N reply that are byte-identical on all 17 program features → the wall is
  feature-completeness, not coordinate choice, and the deficit grows with q (6% → 7% → 39%). Names the
  C76 invariant hunt and re-weights (ON) toward the amortized/ledger potential. Report:
  [`2026-07-11-c75-value-blind-selector-impossibility.md`](2026-07-11-c75-value-blind-selector-impossibility.md);
  script `rust/scripts/c75_linear_selector_lp.py`; solver `gridcap-c75`.

## Reported 2026-07-14

- **C134 `[baer]` [REPORTED 2026-07-14]** — a bounded zbMATH Open, Crossref, OpenAlex, and
  source-level search found no exact precursor for the uniform `PG(2,25)` Frobenius-invariant
  eight-arc conjugate-pair extension theorem. Ordinary complete-arc classifications imply only a
  one-point extension; Hughes-plane, invariant-arc, small-arc-counting, and MDS-lengthening sources
  do not supply the required fresh conjugate pair. The permitted wording is “no exact precursor
  located in a bounded search,” not a historical-first claim. Report:
  [`2026-07-13-baer-completion-adversarial-novelty-review.md`](2026-07-13-baer-completion-adversarial-novelty-review.md#c134-bounded-priority-search--uniform-pg225-theorem).


## Live-file snapshot before pruning — 2026-07-15

# Codex task queue — delegated by Fable (2026-07-07)

**What this is:** the live task registry for the projective-cap / odd-plane program. It holds only
the current-state map — the priority view plus the genuinely-open tasks as one-line entries. Full
write-ups of completed tasks, the original ranking, and the Fable Nth-pass amendment trail live in
the companion log
[`2026-07-07-codex-task-queue-archive.md`](2026-07-07-codex-task-queue-archive.md).
**A REPORTED or CLOSED task does not stay here**: its body goes to the archive, and the
live doc keeps a pointer only where it still anchors an open frontier — in the CURRENT TOP OF QUEUE
prose or under *Settled lanes*. What remains below is open work only: active, queued, gated, or
carrying an explicit open tail.

**No lane is PRIMARY.** This doc describes what each lane's state and next step are; it does not rank
lanes against each other. The user picks the lane explicitly (see CLAUDE.md → Lane routing), so a
"primary/pursue-first" label here only competes with that choice — and, having been written at
different times by different passes, competes with itself: the doc previously called both C84 and C74
PRIMARY, in different sections, with nothing reconciling them. Record priority *within* a lane freely
(a ranked next-step list is useful); do not declare one across lanes.

**Task-ID protocol:** one global monotonic `CNN` sequence (see CLAUDE.md). Each task names a report
file; Codex does the work, writes findings there (verbatim commands/outputs for machine checks), and
marks the entry `[REPORTED <date>]`. Never renumber or reuse an allocated ID. **Max allocated: C208.**

**Lane pegs:** every row carries its lane alias immediately after the ID —
`- **C<id> `[clebsch]` [QUEUED …]** — …` — from the routing table in CLAUDE.md. The canonical aliases
are `alt-orbit-repair`, `baer`, `build-sys`, `cap`, `clebsch`, `cubic`, `gem-mining`, `kayles`, `queens`,
`relconic`, `repaircodes` (`hexagon` is a spoken synonym for `clebsch` and is never written as a peg). Exactly one lane per
item; peg in the same edit that allocates the ID; an unpegged row is a bug. The section groupings
below are presentation only — **the tag is the fact, and wins when they disagree**. Re-pegging is a
lane switch and needs explicit approval. All rows were pegged 2026-07-14.
(Never write a concrete unallocated ID in an example — always `C<id>`. `max(CNN)+1` is how the next
ID is computed, so an invented ID in prose silently burns that number.)

**Lean build-system lane (`build-sys`, 2026-07-14):** see
[handoff](handoffs/2026-07-14-lean-build-system.md). This lane owns trace-aware restart tooling,
large-tree import blast-radius analysis, stable checker interfaces, and build-artifact isolation;
it does not own mathematical proofs or any running lane's build process.
- **C162 `[build-sys]` [QUEUED 2026-07-14 — AFTER THE C143 BUILD WINDOW]** — harden and exercise the
  trace-sentinel restart guard, map high-fan-out Lean imports, design stable/versioned generated
  checker boundaries, and validate a disk-backed per-lane artifact-isolation and recovery protocol
  → `notes/2026-07-14-c162-lean-build-system.md`.
- **C205 `[build-sys]` [REPORTED 2026-07-15]** — generalized the proven
  `/tmp/c151-run-remaining.sh` pattern into a repository runner for explicit Lean target queues:
  configurable targets/cores/`LEAN_NUM_THREADS`/`choom`, one log per target, atomic machine-readable
  run manifest and terminal status, fail-fast diagnostic tails, a shared participating-runner
  ownership lock, restart-safe `lake build --no-build` skipping, and a final trace-only aggregate
  gate; hostile-review fixes cover refusal state, duplicate leaf names, and unsafe numeric controls →
  `notes/2026-07-15-c205-unattended-lean-build-queue.md`.
- **C225 `[build-sys]` [REPORTED 2026-07-18]** — rolled out the adjacent systemd-managed Lean queue
  path: systemd owns process lifecycle (transient user service, cgroup ownership, event-driven
  `--wait`, exit accounting) while the Python queue keeps Lean locking, phases, and target outcomes,
  with immutable submission/InvocationID binding, strict adoption of the adapter-owned run directory,
  canonical-versus-effective state separation so abnormal death is reader-derived evidence rather
  than a forged terminal record, durable completion capture before exact failed-unit cleanup, D-Bus
  reattachment via `await`, a provenance-aware bounded listing, and stable event-ID deduplication in
  place of a false exactly-once promise; exercised end-to-end against real Lean work on the C151
  target, where it caught a devshell-`PATH` defect invisible to the legacy path and returned a
  correct canonical `failed`/1 naming C151 proof errors rather than a supervision fault; the legacy
  `--detach` contract was left unchanged beneath its active users →
  `notes/handoffs/done/2026-07-16-c225-lean-queue-completion-notification.md`.

**Alternate-orbit repair lane (`alt-orbit-repair`, 2026-07-14):** see
[handoff](handoffs/2026-07-14-alternate-orbit-repair.md). The certificate-free `s ≥ 7` theorem is
reported; the uniform Q25 two-witness certificate and arbitrary-deletion repair theorem passed
their full kernel build, trace replay, source trust audit, backup, and manuscript/PDF gates. C148's
exact profile envelope and uniform 318-repair theorem are reported. C149's exact parameter phase
and semantic `(k+2)→k` repair theorem are reported. C150's structural scout is reported: aggregate
moments do not force 32, but the 1,600 minimizers collapse to five residual classes. C151 now has
kernel-checked lower bounds for all 1,189 residual classes and exact cardinality `32` for all five
proposed minimizer representatives; residual-orbit completeness remains active, and C152 remains
gated.
- **C142 `[alt-orbit-repair]` [REPORTED 2026-07-14]** — kernel-checked alternate-orbit repair for
  invariant ten-arcs over every prime-power base order `s ≥ 7`, with at least eight alternatives,
  and package the existing Q25 nonexceptional-profile repair bounds →
  `notes/2026-07-14-c142-alternate-orbit-repair.md`.
- **C143 `[alt-orbit-repair]` [REPORTED 2026-07-15]** — the two-witness `f=2` certificate and
  uniform Q25 alternate-orbit repair theorem passed their full 10,604-job kernel build, trace-only
  replay, source trust audit, verified recovery backup, and manuscript/PDF gates →
  `notes/2026-07-14-c143-q25-alternate-orbit-repair.md`.
- **C148 `[alt-orbit-repair]` [REPORTED 2026-07-15]** — kernel-checked the exact general-`s`
  five-profile lower-bound envelope, its crossover profiles, the semantic 319-pair theorem, and the
  uniform 318-alternative corollary; trust and manuscript/PDF gates passed →
  `notes/2026-07-14-c148-general-s-profile-envelope.md`.
- **C149 `[alt-orbit-repair]` [REPORTED 2026-07-15]** — kernel-checked the exact obstruction phase
  `floor((k-1)^2/4)+r+1≤s(s-1)/2`, the parameterized semantic `(k+2)→k` robust exchange theorem,
  and the sharp `s≥4`, `k≤s+1` rectangle; trust and manuscript/PDF gates passed →
  `notes/2026-07-14-c149-parameterized-robust-exchange.md`.
- **C150 `[alt-orbit-repair]` [REPORTED 2026-07-15]** — aggregate moments and separate extrema do
  not force 32; computed the exact `B/R` frontier and found that the 1,600 minimizers form five
  residual `PGL(3,5)` classes, clearing C151's few-class gate →
  `notes/2026-07-14-c150-q25-multiplicity-structure.md`.
- **C151 `[alt-orbit-repair]` [ACTIVE 2026-07-15 — LOWER BOUND + ATTAINMENT CHECKED]** — all 1,189
  residual classes have kernel-checked lower bounds and all five proposed minimizer representatives
  have exact cardinality `32`; connect the residual cover and prove orbit completeness to classify
  extremizers →
  `notes/2026-07-14-c151-q25-minimum-classification.md`.
- **C152 `[alt-orbit-repair]` [QUEUED 2026-07-14 — COMPONENT-CENSUS FIRST]** — formalize the
  quadratic-Frobenius deletion/insertion graph and degree identity, explicitly distinct from Dye's
  shared-triangle graph, then test fixed-subset fibers for connectivity, diameter, or a finer component invariant →
  `notes/2026-07-14-c152-orbit-replacement-graph.md`.

**Baer-equivariant robust-completion lane (2026-07-14):** see
[handoff](handoffs/2026-07-14-baer-equivariant-robust-completion.md). C134–C141 are reported. The
focused manuscript, global semantic count, removal of the classical-radius table,
structural-criterion positioning, bounded general-priority search, and cleanly compiled submission
artifact are settled. The lane is finished pending the user-directed archive/routing decisions.
- **C135 `[baer]` [REPORTED 2026-07-14]** — classify equality and near-equality in
  `L + E M = E N + B + R`: prove that zero correction is exactly universal orbit visibility plus
  collision-free local charging, then translate the criterion to quadratic Baer geometry →
  `notes/2026-07-14-c135-baer-inverse-equality.md`.
- **C136 `[baer]` [REPORTED 2026-07-14]** — define the global legal conjugate-pair finset and
  kernel-check its cardinality equality with the carrierwise `PairExtensionData.legalCount` →
  `notes/2026-07-14-c136-baer-global-pair-count.md`.
- **C137 `[baer]` [REPORTED 2026-07-14 — FOCUSED SCOPE]** — restructure the manuscript as
  a focused Baer/Q25 paper, retaining only completion language needed by the headline theorem →
  `notes/2026-07-14-c137-baer-paper-scope.md`.
- **C138 `[baer]` [REPORTED 2026-07-14 — TABLE REMOVED]** — audit every classical-radius row against primary sources
  and exact hereditary hypotheses, retaining only publication-ready statements →
  `notes/2026-07-14-c138-baer-classical-radii.md`.
- **C139 `[baer]` [REPORTED 2026-07-14]** — run the specialist/database priority search for the
  general quadratic-Frobenius criterion, distinct from C134's uniform-Q25 search →
  `notes/2026-07-14-c139-baer-general-priority.md`.
- **C140 `[baer]` [REPORTED 2026-07-14 — STRUCTURAL POSITIONING]** — resolve the sharpness gate by a near-sharp or
  pair-saturated family, or adopt and justify the structural-criterion claim boundary →
  `notes/2026-07-14-c140-baer-sharpness-positioning.md`.
- **C141 `[baer]` [REPORTED 2026-07-14]** — produce the submission artifact and run the final
  manuscript/Lean/citation/trust/referee closeout, including routing and archive disposition →
  `notes/2026-07-14-c141-baer-submission-closeout.md`.

**Clebsch hexagon paper lane (`clebsch`, 2026-07-13):** see
[handoff](handoffs/2026-07-13-clebsch-paper.md) — the lane's single live doc. (Formerly the
*icosahedral MDS / deep-holes* lane; same lane, renamed 2026-07-14.)
- **C128 `[clebsch]` [REPORTED 2026-07-14]** — kernel-checked the exact integer and mod-11
  icosahedral syzygies, certified the three canonical reduced forms and trust boundary, audited the
  scratchpad-only group/diagonal provenance, and removed the non-load-bearing Klein section under
  C167 → `notes/2026-07-14-c128-icosahedral-syzygy.md`.
- **C161 `[clebsch]` [QUEUED 2026-07-14 — FOLLOW-UP TO THE RIGIDITY SWEEP]** — settle who owns
  (iv)⟺(v) of the rigidity TFAE ("PGL(3,11)-equivalent to the Clebsch hexagon ⟺ stabilizer contains
  A₅") → `notes/2026-07-14-c161-tfae-iv-v-priority.md`. Acted on already: §4 Remark
  `rem:what-is-new` now states the implication is **not ours** and attributes it to SVM Prop 12,
  which the paper already cites in §2 — so the paper is safe either way and this check only fixes
  *whose* it is.
  **Lit steps:** the rigidity sweep found Karaoglu's 2018 Sussex thesis Table 5.1 credits the q=11
  "Diagonal" surface with |G|=120 to **Sadeh**, which would predate SVM 1995 — so the SVM attribution
  may itself be mis-aimed. Determine the earliest source for "the A₅-stabilized 6-arc of PG(2,11) is
  unique up to PGL(3,11)". Candidates in likely order: Sadeh's thesis (~1984) / Hirschfeld–Sadeh 1984
  (ILL, same batch as C131/C153), Edge 1956 §§29–32 (already read — he has the order-60 stabilizer and
  22 = 1320/60, which may already entail uniqueness), Dye 1991, SVM 1995 Prop 12, O'Keefe–Storme 1996.
  Note Edge is the live possibility: if §§29–32 entail uniqueness, the attribution moves to 1956.
- **C131 `[clebsch]`** — Sadeh-thesis on-receipt verification (**upgraded 2026-07-14 from
  confirmatory to a real question**: the rigidity/gap sweep found that the concession may be
  *mis-aimed in our favour* — per its zbMATH review, Hirschfeld–Sadeh 1984 is a
  Singer-cycle/7-arc/(n;3)-arc paper and **not a 6-arc paper**, so the manuscript may be conceding
  priority on the |U| spectrum to a paper that does not contain it. That rests on a ~90-word
  third-party review, so the ILL decides it. Also confirm whether Sadeh states (iv)⟺(v), which
  Karaoglu's Table 5.1 credits to Sadeh). When the
  Sussex thesis (~1984) / Hirschfeld–Sadeh Giessen 164 (1984) arrives: (a) confirm no over-concession
  beyond the extension-count spectrum — in particular that it does NOT state the deep-hole/covering
  reading or U-on-a-conic (those stay ours); (b) fix the exact citation form for the spectrum; (c)
  mine the 27-lines/cubic-surfaces-over-F₁₁ half for R-A/E₆. `[QUEUED 2026-07-14]` → handoff §round-3
  audit + handoff §Open-lit.
- **C146 `[clebsch]` [REPORTED 2026-07-14]** — re-based the manuscript onto the
  Clebsch→Edge→Dye/BSW→SVM lineage; added exterior-point/line/set vocabulary, the prior LDPC
  stopping-set connection, and Edge's five-triangle/two-system antecedents; separated the classical
  exterior-set condition from the stronger covering/deep-hole statement. Its then-conditional
  priority boundary is now settled against BSW 1992 by C153 →
  `notes/2026-07-14-c146-edge-bsw-prior-art.md`.
- **C153 `[clebsch]` [IN PROGRESS 2026-07-15 — BSW 1992 READ; BSW 1991 ILL]** — BSW 1992 is now
  read from the primary text. It defines and computationally classifies the q=11 complete exterior
  six-arc, hence owns `C subset U`, but does not state the reverse inclusion or exact equality
  `U=C`. Dye plus the chord-defect count makes equality an apparently unrecorded short synthesis.
  The separate 1991 sets-without-tangents paper remains unread →
  `notes/2026-07-15-dye-bsw-primary-source-audit.md`.
  **Remaining lit step:** ILL Blokhuis–Seress–Wilbrink, *Mitt. Math. Sem. Giessen* **201** (1991)
  39–44 (same series as the open Hirschfeld–Sadeh request — one batch). The 1992 *Combinatorica*
  paper and reconstructed text are archived under `/tmp/persistent/tavis/lit-search/bsw-1992/`.
  For the 1991 paper the one question remains: **does it state
  that the exterior set's joins miss exactly the conic** — i.e. that the uncovered locus is the
  conic's full F_q-point set? Search its text for: uncovered, missed, covered, "not on any", the
  complement, 0-secant, skew. Also extract the exact conjecture statement and its scope (which q,
  which sizes, external-only or mixed-type — the mixed-type gap is ours only if they never consider
  internal points), and whether it cites Edge 1956. If it states the covering fact, say so
  immediately and loudly — it forces a rewrite of both manuscripts, and `arcs` ships first.
- **C163 `[clebsch]` [REPORTED 2026-07-14]** — repaired the manuscript's
  coding semantics end to end: distinguish received-word deep holes, affine syndromes/deep-hole
  cosets, projective syndrome directions, minimum-weight leaders, and support triples; correct the
  counts `12 / 120 / 159720 / 2400`; fix the definition of a deep hole, the parity-check ambient
  projective dimension, and every title/abstract/corollary “deep holes = conic” claim; and state the
  precise monomial/projective automorphism group rather than silently identifying it with the pure
  permutation group → `notes/2026-07-14-c163-clebsch-coding-semantics.md`.
- **C164 `[clebsch]` [REPORTED 2026-07-14]** — rebuilt the chirality proposition on the
  correct objects: prove the `10+10` split of support patterns in every deep-hole coset and the
  induced invariant on all `2400` minimum-weight leaders, verify coefficient equivariance under the
  code's monomial automorphisms, ship a durable checker for the `A₅` orbits and exotic-`S₅` swap, and
  remove the current support/leader conflation and non sequitur through `Hom(A₅,ℤ/2)` →
  `notes/2026-07-14-c164-clebsch-chirality.md`.
- **C165 `[clebsch]` [REPORTED 2026-07-14]** — preserved the independently
  confirmed local theorem and ship its missing checker: there are exactly `252` legal one-point
  replacements (`42` for each deleted vertex), with spectrum
  `{18:30,19:60,20:90,22:42,24:30}` and at most seven conic points surviving. Define the
  one-point-replacement graph and symmetric-difference metric, and delete or explicitly localize the
  global “nearest other six-arc” sentence: it is false literally, since a conic-preserving
  projectivity produces a distinct Clebsch six-arc with the same deep-hole conic and distance zero →
  `notes/2026-07-14-c165-clebsch-gap-theorem.md`.
- **C166 `[clebsch]` [REPORTED 2026-07-14]** — audited “Why q=11” and removed its unsupported q=9
  subgroup-conjugacy step; the stronger C170 exhaustive theorem supersedes the conditional `A₅`
  route → `notes/2026-07-14-c166-clebsch-why11.md`.
- **C167 `[clebsch]` [REPORTED 2026-07-14 — SINGLE-SPINE REWRITE]** — refocused the manuscript on
  projective-syndrome rigidity; removed the standalone Klein and Further remarks sections, scoped
  novelty/priority claims, retained only the same-recipe q=19 foil, and imported C174's q=11
  `t(H)+|U(H)|=82` identity without the separate hexad theorem →
  `notes/2026-07-14-c167-clebsch-manuscript-scope.md`.
- **C168 `[clebsch]` [QUEUED 2026-07-14 — FINAL GATE]** — run the submission closeout only after the
  correctness, prior-art, and reproducibility tasks settle: inventory every computation cited or
  relied on by the manuscript; require its script/Lean source to pass `git ls-files --error-unmatch`
  (no scratchpad-, session-, or untracked-only evidence); record path, blob/SHA-256, exact command,
  and expected output in a checker manifest; replay the manifest; then run the manuscript/PDF build,
  citation and cross-paper-number audit, theorem/proof/trust ledger, adversarial reread, and cleanup
  of the live handoff by moving its retained exploration history to the companion archive →
  `notes/2026-07-14-c168-clebsch-submission-closeout.md`.
- **C170 `[clebsch]` [REPORTED 2026-07-14]** — shipped the Git-tracked exact four-frame census over
  every prime power `q≤14`; only six normalized q=11 representatives have a full nonsingular-conic
  extension locus, yielding unconditional uniqueness and closing the non-`A₅` residue →
  `notes/2026-07-14-c170-unconditional-q11-uniqueness.md`.
- **C171 `[clebsch]` [REPORTED 2026-07-14]** — replaced the false global gloss by the PGL-invariant
  nearest-conic discrepancy: the Clebsch class is its unique zero and every non-Clebsch class has
  sharp gap `δ≥12`, with exact 15-class histogram; the 252 local moves split into eight certified
  `A₅` orbits recovering both fixed-conic histograms →
  `notes/2026-07-14-c171-global-conic-gap.md`.
- **C172 `[clebsch]` [REPORTED 2026-07-14]** — translated rigidity into uniqueness up to monomial
  code equivalence; proved the 120 cosets are one monomial orbit and all 159720 received-word deep
  holes one orbit after code translations; certified that the 2400 leaders form four free
  600-orbits, two per chirality, rather than two 1200-orbits →
  `notes/2026-07-14-c172-clebsch-monomial-orbits.md`.
- **C173 `[clebsch]` [REPORTED 2026-07-14 — CONCEPTUAL CHIRALITY UPGRADE]** — constructed the
  explicit `A₅`-equivariant bijection: two of the five self-polar triangles form an alternating
  six-cycle, whose bipartition is one complementary support pair; certified the actual displayed
  self-polarities, full-normalizer equivariance, and Petersen=`KG(5,2)` adjacency without orienting
  chirality → `notes/2026-07-14-c173-dye-triangles-petersen.md`.
- **C176 `[clebsch]` [REPORTED 2026-07-15 — BRIANCHON/PETERSEN UPGRADE]** — completed C173's missing
  classical dictionary: each pair of self-polar triangles maps through its alternating-cycle
  antipodes to one of the ten distinct Brianchon points; the full `10×` multiplicity-three plus
  `15×` multiplicity-one cross-intersection ledger, equivariance, and the resulting triangle-pair
  ↔ Brianchon-point ↔ complementary-support proposition are tracked →
  `notes/2026-07-15-c176-brianchon-petersen-dictionary.md`.
- **C179 `[clebsch]` [REPORTED 2026-07-15 — CONIC-LDPC LITERATURE REBASE]** — read and positioned the
  Droms--Mellinger--Meyer, Madison--Wu, Wu internal-conic, and external-conic binary-code lineage;
  added a bounded related-work paragraph distinguishing their length-`q(q-1)/2` binary incidence
  nullspaces (at q=11, dimensions 25 and 31 for the two relevant codes) from the present length-six
  `F_11` MDS code. The report records direct-source versus abstract-only coverage and limits the
  no-collision verdict to the checked claims rather than outrunning unread bodies →
  `notes/2026-07-15-c179-conic-ldpc-literature.md`.
- **C180 `[clebsch]` [REPORTED 2026-07-15]** — the conceptual rigidity proof is integrated: the
  odd-characteristic line bound closes the degenerate-conic branch, while `|U(A)|=22-c` and Dye's
  sharp `c<=10` equality classification close the nonsingular branch. The 1548-representative
  census now supplies only the independent size-gap clause and regression check →
  `notes/2026-07-15-c180-conceptual-clebsch-rigidity.md`.
- **C181 `[clebsch]` [REPORTED 2026-07-15 — CLASSIFICATION-FREE WHY 11]** — from a
  conic-filling uncovered locus derive `c=(q-6)(q-9)`, combine the universal matching bound `c<=15` with
  the prime-power restriction, and give geometric exclusions at `q=4,5,9`. The first two are now
  closed; `q=9` reduces to `eq_2(Sylvester)=5`, now pinned to Abiad--Jabal Ameli--Reijnders (2025),
  and the q=9 conjugacy graph is now identified with the Sylvester graph, whose published
  exact-distance-two clique number is five. A tracked from-scratch q=9 checker verifies the full
  array, distance relation and clique bound. The elementary `c<=15` bound rules out every `q>=12`
  in all characteristics, so C181 no longer depends on Dye or C180. The manuscript now uses the
  conceptual proof and retains its checker/table as independent verification →
  `notes/2026-07-15-c181-classification-free-why11.md`.
- **C182 `[clebsch]` [QUEUED 2026-07-15 — IMMUTABLE ARTIFACT/DOI GATE]** — answer the PDF-only
  referee's reproducibility objection by releasing the exact eight-source computation manifest,
  cited Lean root/closure, environment, expected outputs and final manuscript at an immutable
  versioned archive, preferably a GitHub release mirrored to Zenodo; independently replay the
  downloaded archive and cite its DOI in a data/code-availability paragraph. Minting the DOI is an
  external action and follows C168's clean-HEAD closeout →
  `notes/2026-07-15-c182-clebsch-artifact-archive.md`.
- **C183 `[clebsch]` [REPORTED 2026-07-15]** — the strict-kernel development now covers the chord
  defect, Brianchon/Petersen core, q=4/5/9 leaves, complete decoding synthesis, small-k moment
  bridge, concrete `A5` point action, and full odd-characteristic line-bound obstruction. The
  manuscript cleanly separates these certified finite/geometric claims from the two imported Dye
  statements; full Dye and coefficient-bearing chirality remain separate optional projects →
  `notes/2026-07-15-c183-clebsch-lean-new-claims.md`.
- **C184 `[clebsch]` [REPORTED 2026-07-15]** — integrated low-degree algebraic rigidity: Clebsch is
  the unique six-arc class whose uncovered locus lies on a degree-at-most-three curve, and degree
  four is sharp via the exact smooth quartic companion. The nodal quintic and bounded sextic result
  are retained only in the sharpness remark, with the no-degree-six-classification boundary;
  Python and Singular replays pass →
  `notes/2026-07-15-c184-low-degree-uncovered-loci.md`.
- **C185 `[clebsch]` [REPORTED 2026-07-15]** — integrated the complete four-way syndrome oracle,
  ambiguity enumerator, decoder reconstruction of the Brianchon matchings, and the exact
  distinction between the size-five equivariant floor and the two support-determined size-ten
  chirality choices; exhaustive checker, narrow Lean synthesis, and PDF gates pass →
  `notes/2026-07-15-c185-clebsch-decoding.md`.
- **C186 `[clebsch]` [REPORTED 2026-07-15]** — printed the full `A5` fixed-point/subgroup ledger,
  deriving the point-orbit profile `[6,10,12,15,30,30,30]` and the unique conic twelve-orbit; the
  deep-hole proof now forces its invariant twelve-set conceptually. Dye supplies the abstract
  representation/orbit identifications, while `Q11A5PointOrbits.lean` independently certifies the
  displayed concrete sixty-element action →
  `notes/2026-07-15-c186-a5-orbit-conic-proof.md`.
- **C187 `[clebsch]` [REPORTED 2026-07-15]** — integrated the conic-filling classification for
  `4<=k<=7`: only the q=5 four-frame and q=11 Clebsch hexagon occur. Universal chord moments are
  Lean-certified; the fail-closed checker closes both seven-arc leaves at `q=11,13` and certifies
  the q=5 frame's exact conic. The elementary q=5 instance is stated without a separate priority
  claim and distinguished from Dye's adjacent six-point degeneration →
  `notes/2026-07-15-c187-general-k-arc-conic-filling.md`.
- **C194 `[clebsch]` [REPORTED 2026-07-15]** — Dye's ten Brianchon concurrences plus the six-arc
  chord-defect identity give `|U(H)|=q^2-14q+45` for every finite-field Clebsch hexagon; for
  `q=3 mod 4`, Dye's non-secant-edge criterion gives `C(F_q) subset U(H)` with exact excess
  `(q-4)(q-11)`, so exact filling is isolated at q=11. The algebraic synthesis passes narrow Lean
  elaboration, and q=19 enumeration is retained as independent verification →
  `notes/2026-07-15-c194-clebsch-family-uncovered-formula.md`.
- **C197 `[clebsch]` [REPORTED 2026-07-15]** — added BSW's second q=11 complete exterior
  configuration, the Pasch configuration, as the explicit non-arc/non-MDS foil: complete
  exteriority alone gives only `C subset U`, while the arc/MDS hypothesis selects the Clebsch
  branch. The addition is one related-work paragraph with no new computation or second spine →
  `notes/2026-07-15-c197-bsw-pasch-mds-foil.md`.
- **C206 `[clebsch]` [QUEUED 2026-07-15 — CONCEPTUAL GAP/STABILITY]** — seek an invariant,
  character, incidence inequality, or coherent-configuration explanation of the sharp
  non-Clebsch nearest-conic bound `delta>=12`; determine whether it extends to a genuine stability
  theorem for extension loci rather than merely repackaging the fifteen-class census →
  `notes/2026-07-15-c206-clebsch-gap-stability.md`.
- **C207 `[clebsch]` [QUEUED 2026-07-15 — INTRINSIC CHIRALITY]** — reconstruct the unordered
  chirality torsor functorially from the code/coset-leader incidence structure, without a chosen
  Clebsch coordinate model, and identify the algebraic obstruction represented by the outside
  `S5`-normalizer coset that swaps the halves but does not lift to a monomial code automorphism →
  `notes/2026-07-15-c207-intrinsic-clebsch-chirality.md`.
- **C208 `[clebsch]` [QUEUED 2026-07-15 — ALL-FIELD ORBIT LOCUS]** — determine the exact
  `A5`-orbit decomposition of the Clebsch-family uncovered locus over admissible finite fields,
  starting with the `q=19` split `20+120`; seek formulas by congruence class and a conceptual
  explanation of how the associated conic sits inside the larger locus →
  `notes/2026-07-15-c208-clebsch-all-field-orbits.md`.

**Gem-mining lane (`gem-mining`, 2026-07-14):** see
[handoff](handoffs/2026-07-14-gem-mining.md). Owns the census-sweep machinery and the second-gem
hunt; the Clebsch paper's own findings stay pegged `clebsch`.
- **C147 `[gem-mining]` [REPORTED 2026-07-14]** — polarity-defect characterization of Mathieu hexads
  (*a 6-subset of the conic in PG(2,11) is a hexad of S(5,6,12) iff no three of its chords are
  concurrent off it*): literature verdict ABSENT at full-text level, and the E_q healthy-census and
  hexad scripts are promoted, hash-matched, and re-run →
  `notes/2026-07-14-c147-hexad-polarity-characterization.md`. The claim is fully machine-checked
  (both systems Steiner-verified, swapped by every outer map, t=60 stratum = their union exactly,
  gap at 61). Proof structure found: t(H) = 60 + #{involutions stabilising H with no fixed point in
  it} (verified for all 924), PGL(2,11) has four orbits on 6-subsets, and the hexads are the orbit
  whose stabiliser has odd order -- which also explains the gap at 61. The four-orbit classification
  is published (Cameron-Omidi-Tayfeh-Rezaie, EJC 13 (2006) #R50, Thm 4; substitution reproduces our
  table), so the converse closes by citation plus a short involution-content argument. The q=23 octad analogue is
  DEAD (min t=295 vs null 280) and the reduction says why -- it needs |H|=2x3 so that a concurrent
  triple is a perfect matching. Singular and note-sized, not a Mathieu tower.
- **C169 `[gem-mining]` [QUEUED 2026-07-14 — SUBMISSION GATE FOR C155]** — close the remaining
  extension-count priority exposure after the open-access sweep found the Bartoli–Davydov–Marcugini–
  Pambianco near miss: obtain Hirschfeld PGOFF §§8/14, Korchmáros–Storme–Szőnyi 1997, and the relevant
  Sadeh material (coordinated with C131); determine whether any source prints the q=11 on-conic
  six-subset extension spectrum or its maximal class; and pin the exact claim boundary and required
  BDMP positioning for the hexad note → `notes/2026-07-14-gem-lit-extension-count.md`.
- **C174 `[gem-mining]` [REPORTED 2026-07-14 — STRONGER SIX-ARC FORM; FOLDS INTO C155]** — proved
  `t(H)+|U(H)|=q²-14q+115` for every six-arc in every finite projective plane, without a conic or
  characteristic hypothesis; shipped a tracked q=5,7,11,13 checker and presented the q=11 value 82
  and maximal-extension hexad specialization →
  `notes/2026-07-14-c174-general-six-subset-identity.md`.
- **C175 `[gem-mining]` [QUEUED 2026-07-14 — SEPARATE FOLLOW-UP; NOT A C155 GATE]** — determine for
  which small prime powers a conic has a six-subset with no accidental concurrent perfect matching;
  explain the diagnostic nonmonotonicity (264 at q=11, none at q=13) by an orbit/existence theorem
  if possible, and keep it outside C155 unless a concise result lands →
  `notes/2026-07-14-c175-concurrency-free-sixsets.md`.
- **C177 `[gem-mining]` [QUEUED 2026-07-15 — GENERALIZED-HEXAGON FOLLOW-UP; NOT A C155 GATE]** — test
  whether the two local Mathieu hexad systems on each point-regulus conic in De Wispelaere's
  `D_Hex(11)` glue equivariantly: first prove independence from the three point-regulus
  representatives of a repeated `B₂` block, then determine whether `PSU₃(11)` preserves or swaps
  the two systems. A positive unoriented result gives a simple `2-(1332,6,240)` design; an
  equivariant choice of one system gives `2-(1332,6,120)` →
  `notes/2026-07-15-c177-regulus-hexad-gluing.md`.
- **C178 `[gem-mining]` [REPORTED 2026-07-15 — WU INTERNAL-CONIC FIRST CELL; NOT A C155 GATE]** —
  reconstructed Wu's `q=11` twelve-point conics arising as length-12 orbits of an internal-point
  stabilizer in `PSL₂(11)`, verified their all-internal and passant-line `0/2` properties, and
  computed the maximum subset whose pairwise joins are all passant to the fixed conic. The two
  conic orbits have passant-join clique numbers 4 and 3, so no six-set exists →
  `notes/2026-07-15-c178-wu-internal-conic-cliques.md`.
- **C155 `[gem-mining]` [DRAFTED 2026-07-14 — SUBMISSION GATED ON C156/C157/C169]** —
  **C174 closed the identity gate:** the hexad result has a second, equivalent form —
  `t + |U| = 82` identically
  on 6-subsets of the conic, so *the hexads are exactly the on-conic 6-arcs with maximal extension
  count `|U| = 22`*. The sweep cleared the **concurrency** framing; the **extension-count** framing was
  never searched and is the likelier of the two to be classical (extension counts are the
  arc-classification school's standard invariant, and six points on a conic is the hexagrammum
  mysticum). The open-access check in `notes/2026-07-14-gem-lit-extension-count.md` found no collision
  and a mandatory BDMP near miss; C169 owns the remaining inaccessible sources. Write the hexad note:
  the `t(H) = 60 + #fpf involutions` identity (synthetic, computer-free), the four-orbit table by
  citation to CO-TR, the short involution-content argument, and the q=23 impossibility →
  draft and exact computation manifest → `notes/2026-07-14-c155-hexad-note.md`. Consumes C156/C157.
  Venue: *Discrete Math.* / *J. Comb.
  Designs* / *DCC*, or Monthly-style. The rigidity/gap check is complete and does not block drafting.
  **Do not claim** the stabilizer-parity form as a new phenomenon — it is a repackaging of CO-TR's
  table; the bridge to chord concurrency is what is ours. Cite Halbeisen–Hungerbühler (J. Geometry
  2024) for the char-0 floor (no-accidental-concurrency is *generic* over ℝ, so this is a
  finiteness phenomenon), and Havlicek/Coxeter/Pellegrino (arXiv:1210.2055) as the nearest rival
  characterization.
  Before C155 can report, its computation manifest must likewise prove with
  `git ls-files --error-unmatch` that every cited script is Git-tracked and record each path, hash,
  command, and expected output; ephemeral session artifacts are not evidence.
- **C156 `[gem-mining]` [QUEUED 2026-07-14 — FOLDS INTO C155]** — find a citable source for the
  132+132 PSL/PGL split of the S(5,6,12) hexads on P¹(F₁₁) →
  `notes/2026-07-14-c156-two-systems-split.md`. **CO-TR §8 cannot be used — it requires p > 23.** The
  "one of the *two* systems" form of our theorem depends on this, so it is load-bearing, not a
  detail.
  **Lit steps:** vary vocabulary across schools. Design theory: "two Steiner systems S(5,6,12)",
  "the two S(5,6,12) on the projective line", PSL(2,11)-invariant hexad systems, Curtis's kitten,
  Conway–Sloane SPLAG ch. 10–11, Beth–Jungnickel–Lenz. Group theory: PSL(2,11) has two orbits on
  hexads / PGL(2,11) fuses them, M₁₂ and its two classes, "the outer automorphism of M₁₂". Coding:
  the two ternary Golay-related hexad systems. Also Edge §§29/32, which has the same
  two-systems-swapped-by-non-PSL motif for the *external-point* hexagons — if he states the on-conic
  version too, that is the citation.
- **C157 `[gem-mining]` [QUEUED 2026-07-14 — ONLY IF C155 PROCEEDS]** — verify or replace the
  unverified textbook citations → `notes/2026-07-14-c157-textbook-citations.md`. The
  point↔involution correspondence on a conic and the pencil↔involution correspondence were attributed
  to **Hirschfeld, *Projective Geometries over Finite Fields* 2nd ed. Ch. 8** and **Semple–Kneebone**
  on inference only — **neither book was accessible and no theorem number is verified**.
  **Lit steps:** obtain a copy of each (ILL/library) and pin exact theorem numbers, or drop them for
  sources already verified: CO-TR Thm 1 + Thm 2(i) gives the 66-external/55-internal counts, and
  Nguyen arXiv:1912.12200 §3–4 gives pencil↔involution over any field of char ≠ 2. Also acceptable:
  Coxeter, *Projective Geometry*, or Hirschfeld–Thas for the Desargues involution theorem. **Do not
  ship an unverified theorem number.**
- **C159 `[gem-mining]` [QUEUED 2026-07-14 — FIRST CELL ONLY]** — the U-atlas, first cell: all n-arcs
  of PG(2,q) up to PGL₃(q) for q ≤ 11, invariant = curve-fit of the deep-hole locus `U(A)`, with
  **C132's genus-0 restriction dropped** (it was a fiat, not a finding) so elliptic targets are
  admitted → `notes/2026-07-14-c159-u-atlas-first-cell.md`. Null: generic `U` fits no curve of degree
  ≤ 3 once `|U| > 9`; exact fills should essentially never happen by chance. The deep-hole sweep found
  **no variety-equality instance of any kind** in the literature, so any exact fill found is new.
  Enumeration technique already exists in `papers/clebsch-hexagon-code/check_rigidity_degenerate_conic.py`.
  **Lit steps** (before claiming any hit): for an elliptic target, search "deep holes" + "elliptic
  curve", "covering radius" + "elliptic curve codes", and check the Hasse window `|U| = q+1-a`,
  `|a| ≤ 2√q` as a sanity null; re-read `notes/2026-07-14-gem-lit-deep-holes.md` first — its Q1
  verdict is the baseline any new fill must be checked against, and its **Reed–Muller residual is
  still open** (C154).
- **C160 `[gem-mining]` [QUEUED 2026-07-14 — CHEAP]** — settle the q=5 frame sibling: is the fact
  that the deep holes of the projective frame in PG(2,5) form a conic real structure or a degeneracy?
  → `notes/2026-07-14-c160-q5-frame-sibling.md`. It currently sits in the healthy census as a
  positive (all-internal, stabilizer S₄, a k=1 sibling of the k=3 Clebsch case) and is **unaudited**.
  All 4-arcs of PG(2,q) are projectively equivalent, so this is a statement about PG(2,5) itself and
  is probably folklore.
  **Lit steps:** search "complete quadrangle" + PG(2,5), "the frame" / "projective frame" + conic,
  "diagonal triangle" + conic, and Edge's own §19 (q=5, on-conic Brianchon — the vet found Edge's
  only on-conic statement is exactly there, so he may already have this). Also check `[4,1,4]₅`
  covering radius in the coding tables. If folklore, it is a one-sentence remark in C155, not a
  finding; say so plainly rather than dressing it up.
- **C190 `[gem-mining]` [REPORTED 2026-07-15 — ROUTING COMPLETE]** — C159 now consumes C184's
  complete q=11 rank/locus table as seed data, while C160's finite calculation is superseded by
  C187 and retains only its q=5 literature/priority tail; C155 and the BSW conjecture are unchanged →
  `notes/2026-07-15-c190-gem-clebsch-routing.md`.
- **C191 `[gem-mining]` [REPORTED 2026-07-15]** — gap-mining method backfill →
  `notes/2026-07-15-c191-gap-mining-backfill.md`.
- **C192 `[gem-mining]` [CLOSED 2026-07-15 — NOT A FIND]** — Clebsch hexagon systems and the Paley
  biplane; the result is Edge 1956 §32's own (6,6)/(5,5) correspondence →
  `notes/2026-07-15-c192-hexagon-biplane.md`.
- **C193 `[gem-mining]` [REPORTED 2026-07-15 — ILL GATE OPEN]** — BSW 1992 read; the exceptional
  census and what it opens → `notes/2026-07-15-c193-bsw-exceptional-census.md`.

**Relative-conic arcs lane (`relconic`) — sweep fallout (2026-07-14):** see
[handoff](handoffs/2026-07-13-relative-conic-arcs-strengthening.md). The `arcs` manuscript was edited
from outside the lane (commit `cfd8537`, Edge 1956 + DMP Thm 7.7 re-pin) and ships first.
- **C154 `[relconic]` [QUEUED 2026-07-14 — LAST HOLE IN A LOAD-BEARING CLAIM]** — close the
  Reed–Muller residual on "first identification of a complete deep-hole set with the full
  F_q-point set of a named variety" → `notes/2026-07-14-c154-reed-muller-deep-holes.md`. The
  2026-07-14 deep-holes sweep (`notes/2026-07-14-gem-lit-deep-holes.md`) audited that claim and it
  **survives**, but its Q5 is marked **NOT SEARCHED, not cleared** — Reed–Muller codes have a
  deep-hole literature of their own and rich geometric structure, so it is the one place a
  counterexample could still sit. `arcs` owns the claim and submits first.
  **Lit steps:** (1) "deep holes of Reed–Muller codes" — Kaufman, Lovett, Porat; Dumer;
  Abbe–Shpilka–Wigderson; search both "deep holes" and "covering radius of RM(r,m)", which is the
  older and larger literature. (2) The specific question: **does any RM deep-hole description
  identify the set with the rational points of a variety** — as opposed to a coset/weight
  description? RM codes are evaluation codes on AG(m,2)/PG, so a variety-shaped answer is more
  plausible here than anywhere else. (3) Distinguish the *complexity* strand (deciding deep-hole-ness)
  from the *explicit description* strand, as in the main sweep. (4) Also sweep generalized RM
  (GRM) over F_q and projective RM. (5) If a variety-equality exists anywhere in RM, the "first"
  must be narrowed to MDS codes or dropped — report it loudly.
- **C188 `[relconic]` [QUEUED 2026-07-15 — Q5 EXACT VALUE]** — import Clebsch C187's projective-frame
  witness into the relative-conic paper, prove and strict-kernel formalize
  `rho_C(5)=L2(5)=4`, add it to `RelativeConicArcs.Results` and the small-value/result tables, and
  cite (rather than migrate) the full `4<=k<=7` conic-filling classification →
  `notes/2026-07-15-c188-rhoc5-frame.md`.
- **C195 `[relconic]` [QUEUED 2026-07-15 — CHEAP DEFINITIONAL UPGRADE]** — add the exact implication
  diagram separating BSW complete exteriority (`C subset U(A)`) from completeness outside a
  prescribed conic (`U(A) subset C`), with exact conic filling as their conjunction; synchronize
  the manuscript, README, proof audit, and result ownership wording →
  `notes/2026-07-15-c195-exterior-vs-relative-completeness.md`.
- **C196 `[relconic]` [QUEUED 2026-07-15 — Q7 STRICT-CONTAINMENT FOIL]** — use BSW's classical
  q=7 exterior four-arc and the four-arc identity `|U(A)|=(q-2)(q-3)` to record the strict example
  `C(F_7) subsetneq U(A)`, with `8<20`; use it as the smallest concrete warning that complete
  exteriority is weaker than relative completeness, without claiming the BSW configuration anew →
  `notes/2026-07-15-c196-q7-exterior-strict-containment.md`.
- **C201 `[relconic]` [QUEUED 2026-07-15 — EVEN-FIELD STRUCTURAL UPGRADE]** — test whether the q=16
  quadratic evaluation-rank obstruction extends to an infinite even-field family: derive the
  symbolic rank criterion, run a bounded q=64 gate, and classify equality/first-excess orbits in
  the tested cells; report either a theorem route or the precise failing obstruction →
  `notes/2026-07-15-expert-questions-upgrade-portfolio.md`.

**Twisted-cubic lane (`cubic`) — the k-tower probe (2026-07-14):** see
[handoff](handoffs/2026-07-13-twisted-cubic-transversal-spectrum.md).
- **C158 `[cubic]` [QUEUED 2026-07-14 — HIGHEST UPSIDE, MOST SPECULATIVE]** — the k=4 healthy search:
  is there an arc in PG(3,q) (no 4 coplanar) whose `[n,n−4]` MDS code has deep-hole locus = the q+1
  rational points of a **twisted cubic**? → `notes/2026-07-14-c158-k4-twisted-cubic.md`. A hit is a
  new *kind* of object (the first deep-holes-fill-a-curve instance beyond the plane, rung 2 of the
  k-tower) rather than a sibling; a miss is exhaustive-per-cell and closes the `clebsch` paper's one
  open forward question with a census instead of a shrug. This is the lane's own "the family runs
  through k, not p" thesis.
  **Do first — the dictionary, not the search.** Re-derive DMP's R=4 coset correspondence from
  arXiv:**1909.00207** (Bartoli–Davydov–Marcugini–Pambianco; fetched and read during the deep-holes
  sweep) before writing any code: deep holes should be the points on **no trisecant plane** of the
  arc. The strategy note flags this as unverified, and the red team already killed the
  deep-holes-on-the-*developable* and chord-locus versions — only "= the curve itself" survives as an
  open question.
  **Lit steps:** the deep-holes sweep's Q4 was the lightest of five and found no prior statement of
  this question — treat that as weak, not settled. Search "points on no trisecant plane", "trisecant
  planes of an arc in PG(3,q)", the k=4 arc↔coset dictionary, DMP arXiv:1909.00207 Thm 3.1 +
  Tables 1–2 and Def 7.1(M2)/Thms 7.2–7.3; twisted cubics in PG(3,q) — Hirschfeld, *Finite
  Projective Spaces of Three Dimensions* Ch. 21, and the recent Bartoli–Marcugini–Pambianco
  twisted-cubic series. Also re-read ZWK arXiv:1901.05445 Thms I.4–I.7 (the tangent-developable /
  quadratic-extension stratification) — it is the precursor to any dual-variety talk and it already
  subsumes and refutes the GRS shadow.
  **Then:** DFS with plane-masks up to Stab(twisted cubic) = PGL₂(q), q = 11 and 13. Capacity null
  `C(n,3)(q²+q+1) ≥ q³+q²+q − n` gives n ≥ 5 at q=11; compute the plane-pencil ceiling before
  searching. ~1300 off-cubic points at q=11, symmetry order 1320 — **Rust from the start**, not a
  Python prototype.
- **C204 `[cubic]` [QUEUED 2026-07-15 — N1 GRAPH-RECOGNITION GATE]** — for the continuation N1
  graph, compute exact automorphism groups, spectra, orbitals, and coherent-configuration data over
  a bounded small-q range; compare with cross-ratio and known finite-geometry graph families, then
  formulate the general automorphism theorem or list the exact exceptional cells →
  `notes/2026-07-15-expert-questions-upgrade-portfolio.md`.

**Box:** compute up to ~8 GB / multi-core is fine; q ≥ 23 grid-cap campaigns and n=20 queens runs
still require an explicit user gate.

## CURRENT TOP OF QUEUE (updated 2026-07-13)

**Conic-involution Schreier graphs → abundance-first — C84.** The conic
bulk is the induced Schreier graph of `H_S = ⟨σ_x : x∈S⟩ ≤ PGL(2,q)`, so its Node-Kayles value is
set by the subgroup type of `H_S`. Exact values: two centres fully soluble (paths + uniform
`2r`-cycles); self-polar `V₄` → `K₄`-unions; `D₈` → `M₈ ⊔ K₂`; `S₄` classes — all
congruence-periodic via the orbit-template theorem; `A₄` cannot occur. Independently verified from
field geometry at q=11–19. **Gating measurement done:** the escape crux (size-3 → size-4) leaves
the small-subgroup regime immediately (children generic, full PSL/PGL) — the catalogue is a
**boundary evaluator, not a forcing engine**. **Reprioritized to abundance-first:** S₄-rooted
escaping 4th centres are conic-only-P at density `≈0.13` (min over classes, q=11–23; verified two
ways); target `#{y : 𝒢=0} ≥ c·q²`. Pairing/mirror mechanism ruled out (minority coverage) ⇒ the
bound must be Grundy-arithmetic. Notes:
[Schreier graphs](2026-07-12-conic-involution-schreier-graphs.md),
[program integration](2026-07-12-conic-involution-residual-graphs.md). Ranking: (1) prove
positive-density P (S₄ then all triple types); (2) transfer to (ON) — needs a separate exchange
lemma (abundance is off-conic); (3) sealing = complete-arc/saturating-set, not blocking-set/Baer;
(4) drain minimax fallback. Correction: order 24 ≠ S₄ (D₂₄ at `12|q²−1`, separate by profile).

The odd-plane escape kernel — "every legal size-3 residual position has a P-valued size-4 child" —
is the active mathematics; (ON), requiring that child on the conic, is the stronger A5 route. The
config→value **mechanism sweep is closed-negative** (Cluster 1). The remaining lanes: the Schreier
catalogue (C84, above); **A5 arc-depletion arithmetic**; the **C74/C77 one-intruder N-absorption
theorem**. C75/C76 close the pointwise selector/invariant spaces; C77 closes the pure geometric
bank. C79's arithmetic pass specified the bulk gap; the game-side follow-ups **C80** (drain
resource proven — `|live conic|` drops by `1+deg`; abundance/descent open), **C81** (char-5/7
subfield gate), **C82** (orbital counting, gated) remain. **C83** raw-quotient measurement is done
(coarsest bisimulation 29 at q=11 → 65 at q=13, growing; q=17 deferred, canon-bound): a bounded
raw-state automaton is unsupported on two points, not excluded. This is deprioritized (not
superseded) behind the structural Schreier lane — tractability is a question of `G∪` structural
width, not raw-quotient size.

**INDEPENDENT PAPER-STRENGTHENING LANE (2026-07-13): relative-conic evaluation/coding/q11
structure — C106–C110.** C106–C109 are reported: the sharp evaluation dichotomy, transparent
arc–MDS/syndrome-defect bridge, and certified q11 non-GRS code/deep-hole/extension spectrum are
Lean-built and promoted into the manuscript. C110's independent Python/C++ replay, mutations,
axiom audit, primary citation chase, PDF, proof-audit, TRUST, results-index, and projective-cap
consumer updates pass; the post-audit actual-leader/support bridge and final source consistency
also pass focused rebuild and axiom audit. Only a shared aggregate rerun after the concurrent Q25
leaf builder remains. This lane is independent of the C84 odd-plane lane. Start with the
[strengthening handoff](handoffs/2026-07-13-relative-conic-arcs-strengthening.md).

**INDEPENDENT REPAIRCODES PROJECTIVE-COMPLETION LANE (2026-07-13): C111–C114.** Test and
formalize the full projective twisted cubic together with its characteristic-three common axis.
C111 owns independent refutation gates and the proposed `[2q+2,4,q]_q` seed theorem; C112 owns
the exact radius-three and radius-four/complete-inner repair profiles; C113 owns bounded-support
transfer and the second asymptotic rate–distance point; C114 owns exact-claim literature review,
adversarial review, and synchronized publication. No proposed formula or novelty claim enters the
paper before its Lean, axiom, computation, and citation gates pass. Start with the
[projective-completion handoff](handoffs/done/2026-07-13-projective-completion-repaircodes.md).

- **C202 `[repaircodes]` [QUEUED 2026-07-15 — BOUNDED EXTREMIZER CLASSIFICATION]** — for the q=9
  completed cubic-axis seed, classify minimum blockers and maximum disjoint repair families up to
  monomial automorphism, with an independent ILP/orbit certificate; then test which optimizer
  types admit a symbolic q=3^h proof → `notes/2026-07-15-expert-questions-upgrade-portfolio.md`.
- **C203 `[repaircodes]` [QUEUED 2026-07-15 — OPERATIONAL COEFFICIENT SCOUT]** — retain the actual
  coefficients in every local repair equation and determine whether complete support hypergraphs
  imply a new exact helper-access, bandwidth, or availability guarantee; a scoped negative boundary
  is an acceptable result, but a support-only restatement is not →
  `notes/2026-07-15-expert-questions-upgrade-portfolio.md`.

**TWISTED-CUBIC CROSS-LANE / DISCOVERY-TRACK FOLLOW-UP (2026-07-13): C115–C120.** Grew out of the
Discovery-Track triage. One object — the twisted cubic in `PG(3,q)` under `PGL(2,q)` — ties coding
(D-PC9 weight distribution), completion §6.5 (external-point transversal spectrum `ρ(x)=τ`), and
arcs (`d=2`). Verified this session: the equivariance backbone `⟨T_a,inv,scaling⟩=PGL(2,q)` (order
`q³−q`, preserves cubic+axis) → τ is orbit-constant; D-PC9 reproduced exactly (bank as a certified
five-weight family, modest/absorbable novelty — fix its `q²−1` min-weight mislabel to `q+1`); the
external τ-spectrum opening confirmed at q=9,27 (τ orbit-constant and strictly finer than the
published incidence counts). **C115 REPORTED 2026-07-13:** projection→plane-cubic reduction proved
(`τ(x)=(q+1)−max-no-3-collinear` of `π_x(C)`); orbit→type dictionary (axis=cuspidal, IC=nodal,
TO/RC=smooth elliptic); **axis closed form `τ_axis = q − r₃(h)`** (cap-set law, verified q=9/27/81 =
5/18/61), reducing §6.5's axis orbit to the cap-set problem and reusing `zeroSumCapNumber`.
Lean-certified strict-trust (`RepairCodes.ProjectiveTwistedCubicTransversalSpectrum`, standard
axioms). **Open piece:** TO/RC/IC exact τ (caps in `E(𝔽_q)`/`𝔽_q^×`) → **C116 next**. Start with the
[twisted-cubic transversal-spectrum handoff](handoffs/2026-07-13-twisted-cubic-transversal-spectrum.md).
Tasks: C115 opt-b [REPORTED] · C116 opt-a [STARTED/DEFERRED — axis τ(81)=61,τ(243)=198 confirmed via
known cap numbers; TO/RC/IC ILP is CBC-hard, next session use HiGHS] · C117 (prove
D-PC9 weights by orbit counting + Lean + mislabel fix) · C118 (definitive D-PC9 prior-art sweep) ·
C119 (determinant-hypergraph program identity into papers-planning) · C120 (separate nofil thread:
fixed-locus / quadric-Witt dichotomy leap).

1. **Cluster 2 / C74 — the open core** (one-intruder pencil N-absorption + recursive reply closure).
   C65's route verdict selected this route. Every constituent probe is REPORTED (archived C61–C63, C70, C71);
   the lane itself is open. C75 explains the selector wall; C76 answered the invariant prong
   (frame-relative characters cut collisions 48→1 but leave a residual hard twin, no monotone scalar,
   and no uniform linear selector ⇒ separation not selection). C77 now proves the reservoir-free
   DROP ledger is uniformly peak-bounded, but also shows that this geometric bound has no game-value
   content by itself. Its continuation finds the exact computed target **`Ncenters≤q−8`** on every
   maximum C74 pencil through q=19 (tight q=17); since `d≤5`, this leaves at least two P off-conic
   centers and would prove odd escape directly. The mechanism candidate is the value-blind two-stage
   packet `L=min d`, then `Low4(L)=` centers through the fourth-lowest off-conic support (ties kept):
   every packet has ≥3 P centers, while 1,332/1,344 non-maximum q17 lines fail. The q=11 knife-edge
   base compresses to four exact perfect-matching reply-graph types. `Low4` is algebraic via the
   proved five-spoke formula `zone_v=q²−15q+34+Σδ_e−t`, with `δ_e∈{4,5,6}` and tangent count `t≤2`.
   A sharper balanced subtype `(d,5,5,6,6)` is P in all 760 exact occurrences and exists
   geometrically on every tested prime-field pencil for q=11 through 31. The exact `d=4` normal-form
   selector reduces existence to five rational functions of x. Extension tests correct the earlier
   unique-Baer guess: failures persist both at characteristic-5 `x=±2` and characteristic-7
   `x∈{±2,±3}`; the latter reappears in GF(49)/GF(343) from the separately closed q=7 geometry.
2. **A5 lane — arc-depletion arithmetic.** Sole surviving (ON) mechanism route. Open: prove
   `maxonN(q) ≤ q−5` for all depleted q. Min-witness bound holds through q=25; depleted set still
   `{11,17}`. Gated compute: the next-depleted-order census (q=29, ~16 GB / ~15–25 h — user gate).
3. **Independent lanes** — C30 (q17/q19 Lean cert assembly, long-running, gated) pulls in parallel.
4. **Mirror-boundary formalization — C85–C88 [REPORTED 2026-07-12].** Strict-trust lane closed:
   parabolic and Hermitian modeled branches are method-negative; the proposed elliptic `Q⁻`
   exclusion was false and its standard coordinate family is P by an fpf mirror. Final map:
   [mirror-boundary handoff](handoffs/done/2026-07-12-mirror-boundary-formalization.md).
5. **Arcs complete outside a conic formalization — C89–C96 [REPORTED 2026-07-12].** Independent
   spinoff lane closed: the defect, conic, asymptotic, averaging, nucleus, and certified-example
   packages are Lean-proved under the strict trust gate. Final map:
   [relative-conic-arcs handoff](handoffs/done/2026-07-12-arcs-complete-outside-conic-formalization.md).
6. **Applications second-order revisit — C99 [REPORTED/CLOSED 2026-07-14].** The
   paper-wide adversarial audit demoted the generic blocker, weighted, symmetry, reliability,
   defining-set, and algorithmic constructions to established infrastructure. Exact collision
   accounting is Lean-proved. `Q25PairResult.f2_pair_extension` now proves the full exceptional
   `(f,e)=(2,3)` existence statement, explicitly including freshness of both conjugate points; its
   scoped build, finite-row coverage, semantic transport, and axiom profile have passed a second
   adversarial review. The certificate-free `Q25ProfileFour.profile_four_pair_extension` now
   proves the `(f,e)=(4,2)` profile from center incidence and exact balance. The certificate-free
   `Q25ProfileZero.profile_zero_pair_extension` proves `(0,4)` with at least five legal pairs, and
   `Q25AllProfiles.pair_extension` exhausts `f=0,2,4,6,8`. The external census size and minimum
   remain data only.
   [paper appendix](2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md#appendix-a--second-order-corollaries-extensions-and-application-queue),
   [proof ledger](2026-07-13-c99-baer-collision-strengthening.md),
   [novelty audit](2026-07-13-baer-completion-adversarial-novelty-review.md).
7. **Relative-conic game localization review — C100 [REPORTED 2026-07-12].** Exact parametrized
   game localization, the q=9 terminal P witness, and the actual q=11 icosahedral seeded P position
   are Lean-proved. Corpus descent and defect-to-C80 reviews were negative for the tested levers. Report:
   [C100 relative-conic game bridge](2026-07-12-c100-relative-conic-game-bridge.md).
8. **Exact relative-conic value at q=16 — C101 [REPORTED 2026-07-12].** A checked exhaustive
   projective classification excludes cardinality eight and the existing nine-point witness gives
   `rhoC(16)=9`. The strict-trust Lean theorem, paper, PDF, proof audit, verifier provenance, trust
   manifest, and paper index are synchronized. Final map:
   [rho_C(16) handoff](handoffs/done/2026-07-12-rhoc16-exact-value.md).
9. **RepairCodes outer trace bridge — C102 [REPORTED 2026-07-13].** The finite-separable trace
   pairing now proves ordinary extension-field dual distance implies the restricted functional-dual
   gate with exact support. Review:
   [asymptotic adversarial review](2026-07-13-repaircodes-asymptotic-adversarial-review.md).
10. **RepairCodes asymptotic outer family — C103 [REPORTED 2026-07-13].** Stichtenoth's self-dual
    TVZ theorem is the sole quarantined import; Lean derives the concrete unbounded q9 family with
    rate `2/19`, every fixed eventual distance bound `c<39/190`, and a bundled exact coordinate
    partition/locality/row/threshold profile. Same review and handoff.
11. **RepairCodes exact cubic matching — C104 [REPORTED 2026-07-13].** Lean proves `ν_x=(q−1)/2` for every cubic coordinate over `q=3^h` via a shifted-inverse consecutive-power rainbow matching. The manuscript, proof/novelty ledgers, TRUST manifest, paper registry, and PDF are synchronized; the pairing pattern is prior/adjacent and only the code-derived application remains candidate novelty. Track in the [strengthening handoff](handoffs/done/2026-07-13-repaircodes-strengthening-plan.md).
12. **RepairCodes transfer-boundary theorem — C105 [REPORTED 2026-07-13].** Nondegenerate `GF(3)` repetition/SPC examples kernel-prove literal complete-hypergraph failure at both numerical boundaries. The paper states only uniform non-weakenability; Kurz--Yaakobi supplies prior art for the elementary two-recovery-set dual-distance mechanism. Track in the [strengthening handoff](handoffs/done/2026-07-13-repaircodes-strengthening-plan.md).

## Open tasks

**Proof lanes (open; constituent probes archived as REPORTED):**

- **C107 `[relconic]` [REPORTED 2026-07-13; SHARED AGGREGATE PENDING] — exact finite-field evaluation-avoidance dichotomy.** The warning-free focused build proves the sharp at-most-`q` equivalence, dimension-sensitive/factored counts, equality model, `q+1` sharp cover, kernel/span form, and arbitrary-feature/Veronese closure with the standard axiom profile. The shared aggregate rerun awaits completion of the unrelated Q25 generated-leaf builder. Same handoff.

- **C110 `[relconic]` [IN PROGRESS 2026-07-13; SHARED AGGREGATE ONLY] — relative-conic novelty, adversarial, and publication closure.** Primary citation chasing marks the `binom(k,3)` farthest-coset leader count, hyperplane threshold, arc/MDS/deep-hole dictionary, and Clebsch interpretation as known. Independent Python/C++ replay, coordinate invariance, perturbed-witness and mutated-generator controls pass. Paper/PDF, proof audit, TRUST, results table, queue, and projective-cap consumer note are synchronized; the final source/claim checklist and post-audit actual-leader bridge pass focused rebuild and standard-axiom audit. Only the shared aggregate rerun remains. Same handoff.

- **C144 `[relconic]` [QUEUED 2026-07-14 — NEEDS A QUIESCENT BOX]** — replace the unachievable
  shared-`RelativeConicArcs` aggregate gate with per-lane gate targets, demote the umbrella build to
  a quiescence repo-health check, and add a build-window protocol plus atomic regeneration-commit
  rule. The aggregate passed green 2026-07-14 17:15 and was stale by 17:35 under another lane's
  regeneration, so it cannot be any lane's exit gate; Q16 and Q25 are import-disjoint, so the
  relconic closure excludes the churn entirely. Unblocks C107/C110 without weakening validation.
  Do not start while another lane is building or regenerating. Design, options, and migration path:
  [`2026-07-14-c144-shared-library-gate-architecture.md`](2026-07-14-c144-shared-library-gate-architecture.md).

- **C189 `[cap]` [QUEUED 2026-07-15 — Q5 OCTAHEDRAL BRIDGE]** — consume Clebsch C187's q=5
  projective-frame sibling on the game side: certify that its six conic continuations have conflict
  graph `K6` minus a perfect matching (the octahedral graph), derive the antipodal-copycat P-position,
  and cross-reference it with the existing q=11 icosahedral seeded P-position. Record explicitly
  that, for `4<=k<=7` and `q>=13`, C187 excludes only equality `U(A)=C(F_q)`; it does not exclude
  proper-subset containment `U(A)⊂C(F_q)` or another localization, and does not advance or
  reformulate `(ON)` →
  `notes/2026-07-15-c189-q5-octahedral-frame.md`.
- **C198 `[cap]` [QUEUED 2026-07-15 — BOUNDED Q7 EXTERIOR SCOUT]** — reconstruct or obtain BSW's
  q=7 complete-exterior four-arc, compute its 20-point uncovered locus and residual continuation
  graph with the existing projective-cap machinery, and test for a recognizable symmetry,
  involution, or P-position. Strict stop: this is a cheap scout, not manuscript scope unless it
  yields a clean certified game statement; distinguish it from C189's exact q=5 conic-filling seed →
  `notes/2026-07-15-c198-q7-exterior-residual-scout.md`.
- **C199 `[cap]` [QUEUED 2026-07-15 — SCHREIER STRATEGY EXTRACTION]** — for every value used in the
  dihedral/S4/A5 submission catalogue, turn zero nimbers into direct pairing/symmetry strategies
  where possible and nonzero nimbers into canonical winning-move rules; explicitly mark any row
  whose only proof remains Grundy decomposition →
  `notes/2026-07-15-expert-questions-upgrade-portfolio.md`.
- **C200 `[cap]` [QUEUED 2026-07-15 — SCHREIER GRAPH RECOGNITION]** — compute automorphism groups,
  spectra, and orbital/coherent-configuration data for the bounded tame template catalogue and
  compare it with known Möbius-ladder, dihedral-Cayley, cross-ratio, and Schreier families; promote
  only a structural identification or a genuinely new family →
  `notes/2026-07-15-expert-questions-upgrade-portfolio.md`.

- **C84 `[cap]` [CONCEPTUALLY GATED 2026-07-17] — conic-involution Schreier abundance program.**
  Bulk = induced Schreier graph of `H_S ≤ PGL(2,q)`; value set by subgroup type. Proven+verified:
  two-centre full decomposition; `V₄`→`K₄`s (Cor 3.2 mod-8); `D₈`→`M₈⊔K₂` (Thm 4.2 mod-8); `S₄`
  classes; orbit-template theorem; `A₄` excluded. Independent field-geometry verification at
  q=11–19. **Gating measurement done:** escape crux (size-3 → size-4) leaves the small-subgroup
  regime immediately — children generic (full PSL/PGL), so the catalogue is a boundary evaluator,
  not a forcing engine. **Open (reprioritized):** (1) **prove positive-density P** — S₄-rooted
  escaping 4th centres are conic-only-P at density `≈0.13` (min over classes, q=11–23, verified two
  ways; q=7 lone dip; no dip at depleted {11,17}); target `#{y : 𝒢=0} ≥ c·q²`; pairing/mirror
  mechanism ruled out (fpf-involution residual auto covers only a minority) ⇒ the bound must be
  Grundy-arithmetic (decomposition + Weil/character-sum equidistribution the live candidate); then
  uniform over all triple types; (2) **transfer to (ON)** — abundance is off-conic conic-only-P, so
  an exchange/transfer lemma is required to get an on-conic P child; (3) **sealing** =
  complete-arc/saturating-set, **not** blocking-set/Baer ({11,17} nonsquare); (4) minimax potential
  tracking live vertices + live coloured edges (§5 drain bound → C80(b)). Correction: order 24 ≠ S₄
  (D₂₄ occurs at `12|q²−1`, separate by element-order profile). **Frontier sharpened (Fable,
  2026-07-12):** density ≡ `{𝒢=0}` is a dim-2 CvdDM-definable set (equal strength); the open lemma
  is one-sided — **one dim-2 constructible value-0 certificate** — as every known certificate is a
  homography fixed locus = dim 1 = Θ(q); the Fricke coordinate determines value only vacuously
  (near-injective). Near-term lever = existence not density. **Novelty:** conic↔Schreier
  correspondence + value catalogue = the defensible new theorem; orbit-template periodicity =
  known+known bookkeeping. The revised submission includes the `V₄≅D₄` boundary and the full tame
  `D₄ₙ` classification; exact `S₄/A₅` computation now completes the free-orbit `t₁` row across
  all realizable tame small-subgroup types. Its reduction layer builds as the standalone Lean
  `DihedralSchreier` library — [submission](2026-07-12-dihedral-schreier-node-kayles-submission.md),
  [polyhedral regular-template nimbers](2026-07-12-polyhedral-nk-templates.md),
  [novelty audit](2026-07-08-codex-projective-nofil-novelty-audit.md).
  Notes: [Schreier graphs](2026-07-12-conic-involution-schreier-graphs.md),
  [program integration](2026-07-12-conic-involution-residual-graphs.md); scripts
  `c80_schreier_verify.py` (field), `s4_escape_probe.py`, `s4_abundance_check.py`,
  `pairing_witness.py`, `exact_fricke.py`, `refined_signature.py`, `three_centre_probe.py`,
  `schreier_templates.py`. **Final gate:** no permitted certificate schema passed the deterministic,
  controlled-complexity, full-dimension, and exact-counting tests; the unrestricted two-ply
  adaptive-pairing super-event certifies 13/131 q=13 class-D roots but 0/753 at q=29. C84 is
  deprioritized without claiming an impossibility theorem →
  `notes/2026-07-17-c84-certificate-event-dossier.md`.

- **C80 `[cap]` [ACTIVE 2026-07-12 — (c) drain proven+verified; (a) abundance / (b) descent open]** —
  game-side bulk-mechanism probe: exhaustion, abundance, descent measure. Report:
  [`2026-07-12-c80-bulk-exhaustion-probe.md`](2026-07-12-c80-bulk-exhaustion-probe.md). Attack C79's spec ("compress many genuinely active, edge-disjoint matchings behind a
  bounded interface") from the game side, where the program is asset-poor — not with more
  arithmetic. Closed mechanism families (do not re-enter): static signatures, global torus/mirror
  pairing (the torus-gate closure also closes classical mirror strategies for the bulk), literal
  retirement, moment selectors. **Design rule:** tune the generic mechanism on **nondepleted**
  orders (q=13/19, plus q=23/25 corpora where usable) and treat depleted q=11/17 as certificate
  territory — leaf obligations and unique-clean-candidate packets track exactly the depleted A5
  census (at q13 every full-cyclic candidate is clean and P; q19 minimum winning degrees are
  43–55), so selection difficulty is plausibly a depleted-order artifact. Three sub-probes on the
  exact balanced-root corpus:
  **(a) Abundance profile.** Per (root R, opponent move x) at nondepleted q, compute the full
  winning-reply fraction and test whether the winning set contains an entire bounded-condition
  packet (e.g. all D-generic on-conic replies minus an explicit bad-fiber list). Target theorem
  shape: at nondepleted q **every** packet member wins — existence by counting, no selector needed.
  **(b) Descent / class preservation.** Test which lexicographic residual measures some winning
  reply always strictly decreases — candidates from (conic defect type, |live conic|, live-edge
  budget `k((q-1)/2-d)`, zone complexity) — and whether some winning reply re-enters the
  balanced/normal-form class or a bounded defect list. Record the conic-killing shape: |live conic|
  along optimal lines (all four score-9 base candidates kill the conic — is "drive the conic dead,
  then play the zone base" the generic strategy?).
  **(c) Drain-rate lemma (provable now).** For a live conic point t, the nonfixed partner points
  `sigma_i(t)` over the k active intruders are pairwise distinct (a shared value is a shared edge,
  whose endpoints die once both centers are selected — the C79 overlap lemma). So each conic
  exchange deletes the full live partner fiber; derive the exact exchange inequality for the
  live-edge budget and compare with corpus play lengths. This is the well-founded resource for the
  two-ply lemma that never evaluates the bulk.
  **Discipline:** any bulk compression proposed from (a)–(c) must pass the outcome-compatible
  quotient gate (P/N collision check on q13/q17/q19) before theorem work. Also record per-state
  winning-degree distributions as input to the Ψ/ledger lane — the fallback mechanism family if no
  measure in (b) validates. **Gate out:** an empirically valid (packet, measure, class) triple
  through q19 becomes C82's counting target. Report target:
  `notes/2026-07-12-c80-bulk-exhaustion-probe.md`.

- **C81 `[cap]` [OPEN — run early, independent of C80]** — characteristic-5/7 subfield gate (C79 note
  probe #4, untested; step-6 de-risk). For the char-5 `x=±2` and char-7 `x∈{±2,±3}` configurations
  over GF(25/49/125/343): classify legal moves as Frobenius-fixed vs nonfixed; test whether every
  nonfixed move has a reply exiting the prime-subfield obstruction class; test even-degree
  involution pairing as one branch and identify the odd-degree mechanism (odd-degree extensions
  supply no Frobenius involution, so orbit pairing alone cannot close it). Bounded and load-bearing
  for the final generic+certificates assembly: if subfield descent fails structurally the
  architecture loses its exception handler — an odds-moving result either way. Report target:
  `notes/2026-07-12-c81-subfield-descent-gate.md`.

- **C82 `[cap]` [GATED on C80 — do not start first]** — orbital / Hollmann–Xiang counting for the C80
  packet. Derive the odd-q two-relation intersection counts for the conic-stabilizer orbital
  algebra (or directly as `chi(D)` character sums) only in service of the specific packet C80
  outputs: main term, square-product degeneracy audit, explicit bad-fiber list, and a concrete
  threshold `q0` with the below-threshold orders enumerated for the certificate layer. Deriving
  H–X odd-q parameters with no consumer is a week-scale detour — hence the gate. Report target:
  `notes/2026-07-12-c82-orbital-counting.md`.

- **C83 `[cap]` [MEASURED 2026-07-12 — deprioritized behind C84, not superseded]** — coarsest
  bisimulation of the residual game grows across both measured points (29 at q=11 → 65 at q=13;
  q=17 deferred, canon-bound), leaving a bounded raw-state automaton unsupported but not excluded.
  Tractability is a `G∪` structural-width question (→ C84), not
  raw-quotient size. Report:
  [`2026-07-12-c83-bisimulation-quotient.md`](2026-07-12-c83-bisimulation-quotient.md). Original
  bulk-quotient spec: union-graph compression + coarsest value-respecting congruence. Two corollaries of the C79 edge-disjointness
  lemma sharpen the bulk spec. **(1) Union-graph reframing.** On the live conic the k matchings
  union to a **simple** graph `G∪`, and (since no three conic points are collinear) any conic-only
  continuation is exactly Node-Kayles on `G∪` — per-intruder identity (edge colors) provably drops
  out of that layer; k re-enters only through intruder-move interleaving (off-conic supply,
  fixed-point kills, the ≤2-per-line cap). The bulk problem restates as **Node-Kayles under
  algebraic matching-augmentation** on one evolving graph. First candidate for the
  outcome-compatible quotient gate: state ↦ (uncolored `G∪` up to iso, off-conic supply parity,
  bounded bookkeeping) — P/N collision check on q13 first; collisions localize exactly which
  geometric residue a true quotient must retain. **(2) Watched-set re-basing of packet
  conditions.** Per-prior orbital relations impose k conditions (density `2^-k` — the C79
  obstruction); a condition prescribing `σ_y` on a bounded watched subset `W` of `G∪` is
  bounded-codimension in y's two coordinates **independent of k**. If the strategy needs only a
  bounded watched region (exactly C80(a)'s abundance hypothesis), packet density survives every k.
  Caveat recorded: the score-9 relations-to-all-priors shape arose with one live conic point left —
  a low-live-conic artifact, not the generic template. **(3) Decisive measurement.** The canonical
  object behind C79-note goal 2 ("quotient into component types preserving P/N") is computable
  exactly on small q: run partition refinement (Grundy-labelled bisimulation) on the exact residual
  DAG at q11/q13 (q17 descendant-only if it fits); report minimal-quotient class counts vs q and
  reverse-engineered class invariants. Small/stable ⇒ the bulk quotient exists and the theorem
  takes the octal-periodicity shape (automaton with arithmetic transition guards; C82 counts its
  reply guards). Blow-up ⇒ close the quotient lane and concentrate C80 on abundance/descent. An
  odds-moving dichotomy either way. Report target:
  `notes/2026-07-12-c83-bisimulation-quotient.md`.

- **C77 `[cap]` [REPORTED 2026-07-11 — DROP peak theorem proved; game-semantic certificate residue OPEN]** —
  C63's growing Ψ debt is entirely the loose `reservoir_slack` term. After deleting it, the pure
  conic ledger `DROP = 6·defect − 4·intruders − 2·[xor=0]` satisfies the **all-depth theorem**
  `DROP(S) ≤ DROP(root)=6(q−5)−2` for every odd q: an intruder pays `−4`; without intruders a proper
  descendant has at most `q−6` live conic vertices; the root's `q−5` isolates have xor zero. The q23
  solve is no longer needed for bank capacity or full-depth DROP debt. The `q−5` cross-lane check is
  **negative**: A5's `maxonN` is a class-extremal P/N count, while `defect_components` is a
  value-blind graph count fixed at `q−5` at the root; identifying them assumes the desired P witness.
  **Continuation:** the game-semantic residue is exactly C74's maximum-pencil absorption problem.
  Exact data gives `Ncenters≤q−8` at q=11/13/17/19 (tight q=17), while simple character/order
  selectors fail across q. The two-stage value-blind `Low4` packet contains ≥3 P centers on every
  maximum pencil; maximum-line selection is load-bearing by the non-maximum controls. All 32 distinct
  P centers in the q=11 knife-edge pencils have perfect winning-reply matchings in only four graph
  isomorphism types. The exact five-spoke formula makes `Low4` the fourth-order packet of
  `K=Σδ_e−t`; identical `(K,t)` types can be both P and N, so the missing lemma must compare packet
  games rather than classify one center. The balanced subtype `(d,5,5,6,6)` is P in all 760 exact
  q=11/13/17/19 occurrences and exists geometrically for tested prime q=11 through 31. Unconditional
  existence is false. The exact `d=4` normal form `A={0,±1,±x}` gives four rational candidate
  parameters whose singleton values are exactly the balanced centers. Tests through prime q=101 and
  GF(9/25/27/49/121/125/343) isolate two inherited small-subfield failures: characteristic 5 at
  `x=±2` and characteristic 7 at `x∈{±2,±3}`. The rational equality split is now proved: these are
  exactly the empty-selector cases over every odd field. **Open:** prove the weaker sufficient
  balanced-packet theorem (some balanced center is P), and handle the two subfield configurations
  separately. Universal P-purity is deprioritized: individual forced states do not compress, while
  q17 maximum-pencil packets have only four forms. The
  `d=5` branch is reduced to a twelve-certificate ledger: balanced centers are exactly legal
  degree-two parameters. Four exact paired-label identities prove `n1≤4`, and a three-orbit pole
  argument proves `T≥10`, and three factored representative identities prove legal degree `≤2`.
  The forbidden-target audit is now complete: five excluded label/target orbits factor to primary
  contradictions; five singleton-pair orbits give four contradictions/templates and one genuine
  characteristic-3 weight-two family with no paired target. Thus `F≤3` and the full d5 geometric
  theorem are proved: every maximum d5 pencil has at least two balanced centers. Hence the generic
  balanced-center existence geometry is closed for both d4 and d5.
  **P-purity probe:** simple affine mirroring is closed-negative—none of the 32 distinct balanced
  q11 roots has even a root-safe affine involution. Full-grid canonicalization gives 8/12/24/85
  balanced orbits and 2/3/6/18 coarse residual types at q11/13/17/19; every capacity-1 graph is
  connected and retains capacity-2 lines, closing finite-template and component-decomposition
  routes. The q11 base itself compresses exactly: two winning-reply graphs, while all 32 roots share
  one 33-edge losing-pair graph `3·(K2 join 2K2)`. Continue with adaptive algebraic reply closure,
  not a fixed pairing. Exact solve-once q17 profiles show five of six coarse types have degree-one
  opponent moves (48 forced directions spanning 24 S6 grid-orbits), so the missing lemma must
  explain forced replies; density/Hall and small response-template routes are not viable. Their 39
  S5 orbits have no cross-root collisions—the nine repeats are exactly order-two root-stabilizer
  pairs—so there is no common forced-state orbit family either. Exact marked conic-involution
  coordinates now separate every degree-one reply on all balanced q11/q17 root orbits and are
  globally P-pure over the full controls (`24/24` over 888 q11 pairs; `192/192` over 145,560 q17
  pairs), once the on-conic boundary records the balanced-center action. This is separation, not
  selection: the q-independent equality-pattern quotient falls to `160/192` at q17 and no natural
  overlap scalar uniquely selects more than `28/192`. Use these as coordinates for an algebraic
  reply proof; do not continue static-signature mining. The two remaining exact relational
  candidates are also closed-negative at q17: canonical aligned `K5` component incidence reaches
  only `172/192` global purity, and projective order/commutator-Fricke type only `24/192`.
  **Reopened mixed-feature hit:** full Rédei directions plus residual `(live, conflict-edge count)`
  is `192/192` with 90 forced types. In proof-relative form only the five new reply directions
  `D_y` and `ΔE` are needed; `(D_y,ΔE mod 3)` is locally exact `192/192` once S5 context is fixed.
  No linear mod-3 formula in simple collision counts fits. The decomposition `ΔE=-R_y+A_y`
  yields a field-label-free replacement: reply-pencil load residues plus labelled old-secant
  incidence select `191/192`, and the Boolean `Q3(y)` that some direction quotient occurs three
  times closes the sole twin. With the implicit S5 parallel/quotient spectrum prepended, this is locally unique and
  globally P-pure `192/192` (q11 `24/24`). It remains a contextual separation certificate with 182
  forced types, so the proof target is an algebraic incidence case split, not a static dictionary.
  The exact leaf scope is now closed through q19: every q13 balanced-root orbit has minimum winning
  degree 2, while all 85 q19 orbits have minimum 43–55; only depleted q11/q17 contain degree-one
  obligations. A P root always gives minimum degree at least 1, so forced obligations are precisely
  equality cases (leaves) in this automatic reply-existence bound. All minimum-degree q11/q13/q17
  S5 states have trivial grid stabilizer, and q13 degrees can be odd, excluding symmetry and parity
  as explanations for the nondepleted degree-two upgrade.
  Alternatively prove
  the uniform `Low4`
  packet theorem/N-absorption bound; do not spend more compute on the DROP envelope. Reports:
  [`2026-07-11-c77-ledger-bank-probe.md`](2026-07-11-c77-ledger-bank-probe.md),
  [`2026-07-11-c77-ledger-spike-structure.md`](2026-07-11-c77-ledger-spike-structure.md) (§6–9); modes
  `s4ledger`/`s4spike` in `notes/2026-07-06-grid-cap-solver.rs`;
  [`2026-07-11-c77-game-semantic-reply-graphs.md`](2026-07-11-c77-game-semantic-reply-graphs.md),
  scripts `rust/scripts/c77_pencil_value_probe.py`, `c77_intruder_reply_graph.py`,
  `c77_balanced_center_geometry.py`.
- **A5 arithmetic proof** (open lane, no single ID) — `maxonN(q) ≤ q−5` for all arc-depleted q, plus
  the q=29 next-depleted-order census (gated compute). Anchor context:
  [`2026-07-09-codex-depletion-fraction.md`](2026-07-09-codex-depletion-fraction.md),
  [`2026-07-10-codex-a5-nbucket-density.md`](2026-07-10-codex-a5-nbucket-density.md),
  [`2026-07-10-a5-symmetric-completion-anchor.md`](2026-07-10-a5-symmetric-completion-anchor.md).
- **C74 `[cap]` residue (now the C77 game-semantic continuation)** — prove the two-stage packet theorem:
  on a maximum (`min d`) one-intruder pencil, the fourth-order-statistic low-`zone_v` packet contains
  a P center (observed ≥3), implying `Ncenters≤q−8`. Geometrically this is the fourth-order packet
  of the five-spoke collision score `K=Σδ_e−t`. Sharper route: prove P-purity/existence of balanced
  `(d,5,5,6,6)` centers in the generic branch and handle the characteristic-5/7 subfield
  configurations separately. The d5 geometric branch is closed: the certificate ledger proves at
  least two balanced parameters on every maximum d5 pencil. Remaining geometry is the d4 generic
  equality split and its characteristic-5/7 exceptional configurations.

**Independent / engineering:**

- **C30 `[cap]` [REPORTED 2026-07-10 — certcheck PASS; open engineering tail]** — generated-checker refactor →
  q17/q19 Lean assembly. The v5 full q17 canonical build projects above 21.5 h sequential, tripping the
  task's ~10 h user-launch gate; do not launch implicitly. Next = an explicit launch decision or a
  build-shape reduction, then q19 sizing.
- **C13 `[cap]` [OPEN]** — q=9 intrusion-structure probe (the next odd-plane Lean target; the q=9 Lean
  kernel/certificate is still open per the handoff Status Table). Report target
  `notes/2026-07-07-codex-q9-intrusion-probe.md`.
- **C16 `[kayles]` [OPEN — dormant]** — sum-free Tactic 2, induction on `r` (`Z3^r × Z_p` is N iff r=1); a
  separate work stream, dormant unless resumed. Report target
  `notes/2026-07-07-codex-sumfree-induction-r.md`.
- **C56 `[cap]` [CLOSED-GATED — do not start]** — group-indexed cross-q type alignment; gated on a C55
  positive, and C55 is NEGATIVE, so it stays closed.

**Opportunistic / diagnostics (no priority; pull as diagnostics — full specs in the archive):**
C23 / C40 (winline viz lanes), C49 (piece nimber tables), C57 (zone quasi-randomness), C60
(Singer-model probe), C66 (grid-terminal spectrum), C67 (coupling-defect spectroscopy).

## Settled lanes (one-line pointers; full task bodies in the archive)

- **Cluster 1 — config→value mechanism sweep: CLOSED, no static dictionary found (de-prioritized in
  favor of A5, not proven impossible).** C55 group-side
  [`2026-07-09-codex-d-lattice-side-switch.md`](2026-07-09-codex-d-lattice-side-switch.md), C64
  extremal poset [`2026-07-09-codex-completion-poset.md`](2026-07-09-codex-completion-poset.md), C69
  algebraic envelope [`2026-07-10-codex-envelope-invariants.md`](2026-07-10-codex-envelope-invariants.md),
  and the Ψ dynamic probe [`2026-07-10-psi-dynamic-flip-probe.md`](2026-07-10-psi-dynamic-flip-probe.md)
  all NEGATIVE. Re-entry conditions in the archived Cluster-1 status note.
- **A5 depletion evidence — all REPORTED; q=25 non-depleted (28/28 P), depleted set still {11,17}.**
  C68 `D(q)` + C68b ν(q) (links above), C72 f_q decomposition
  [`2026-07-10-codex-c72-fq-decomposition.md`](2026-07-10-codex-c72-fq-decomposition.md), C73 secant
  packet [`2026-07-10-codex-c73-secant-packet.md`](2026-07-10-codex-c73-secant-packet.md), q=25 census
  C43/C44 [`2026-07-09-codex-q25-baer-census.md`](2026-07-09-codex-q25-baer-census.md), order-9 planes
  C58 [`2026-07-09-codex-order9-planes.md`](2026-07-09-codex-order9-planes.md), arc-stability C59
  [`2026-07-10-codex-arc-stability-import.md`](2026-07-10-codex-arc-stability-import.md), round-1/round-2
  theorem frontier
  [`2026-07-10-codex-odd-plane-round1-report.md`](2026-07-10-codex-odd-plane-round1-report.md),
  [`2026-07-10-codex-odd-plane-round2-report.md`](2026-07-10-codex-odd-plane-round2-report.md).
- **Selector / potential probes — all REPORTED; the wall is explained by C75.** C61 reply automaton,
  C62 selector scoring, C63 potential LP/dual, C70 collision charge
  [`2026-07-10-codex-c70-collision-charge.md`](2026-07-10-codex-c70-collision-charge.md), C71
  third-intruder transition
  [`2026-07-10-codex-c71-third-intruder.md`](2026-07-10-codex-c71-third-intruder.md).
- **C50 `[cap]` [REPORTED 2026-07-10 — tiny PASS / literal-scale NO-GO]** — reflected Grundy-book cert format
  in Lean; replace linear literal lookup before a C35 adapter.
  [`2026-07-09-codex-grundy-cert-format.md`](2026-07-09-codex-grundy-cert-format.md).

---

The remaining history — the verbose priority-ordering snapshots, the original ranking + Fable
Nth-pass amendment trail, and every REPORTED / NEGATIVE / NO-GO / DONE task body (C1–C74, plus the
untagged bodies C14/C15/C22 subsumed by later work) — was moved verbatim on 2026-07-11 to
[`2026-07-07-codex-task-queue-archive.md`](2026-07-07-codex-task-queue-archive.md).

## 2026-07-15 Clebsch priority closeout

- **C153 `[clebsch]` [REPORTED]** — BSW 1992 owns complete exteriority and the `q=11` exterior-set
  census, hence the inclusion of the conic in the uncovered locus; it does not state exact
  covering. The manuscript now proves equality from the classical inclusion and Dye's exact
  concurrence count without making a separate priority claim →
  [`2026-07-15-dye-bsw-primary-source-audit.md`](2026-07-15-dye-bsw-primary-source-audit.md).
- **C161 `[clebsch]` [REPORTED]** — Dye Theorems 1 and 3 supply projective uniqueness of the
  Clebsch equality class and its `A5` stabilizer; Storme--Van Maldeghem Proposition 12 supplies the
  converse classification of the primitive `A5`-fixed six-arc →
  [`2026-07-14-c161-tfae-iv-v-priority.md`](2026-07-14-c161-tfae-iv-v-priority.md).

## 2026-07-15 Clebsch reproducibility closeout

- **C168 `[clebsch]` [REPORTED]** — all thirteen executable sources are indexed and hashed; all
  twelve fail-closed commands and five guarded Lean roots passed from clean source commit
  `857c09c5`; the Nix-backed 21-page PDF passed warning, citation-key, and internal-reference audits
  → [`2026-07-14-c168-clebsch-computation-source-preflight.md`](2026-07-14-c168-clebsch-computation-source-preflight.md).

## 2026-07-15 relative-conic framing closeout

- **C195–C196 `[relconic]` [REPORTED]** — the manuscript now displays the reverse uncovered-locus
  containments for complete exteriority and prescribed-conic completeness, and BSW's q=7 exterior
  four-arc gives the strict count `20>8`; the two originally separate report paths above were
  consolidated into
  [`2026-07-15-c195-c196-exterior-relative-framing.md`](2026-07-15-c195-c196-exterior-relative-framing.md).

## 2026-07-16 relative-conic aggregate closeout

- **C107 and C110 `[relconic]` [REPORTED]** — the guarded top-level `RelativeConicArcs`
  aggregate and its trace-only aggregate gate passed after the shared Q25 builder cleared. This
  closes the only remaining validation tail on the evaluation dichotomy and the adversarial,
  publication, and trust audit package.

## 2026-07-16 repaircodes aggregate closeout

- **C202 `[repaircodes]` [REPORTED 2026-07-15]** — q=9 radius-three extremizers and all minimum
  blockers were classified under monomial `PGL(2,9)`; the exact full-port Burnside census records
  the matching-orbit explosion →
  [`2026-07-15-c202-repair-extremizer-classification.md`](2026-07-15-c202-repair-extremizer-classification.md).
- **C214 `[repaircodes]` [REPORTED 2026-07-16; PAPER-PROMOTED]** — the exact weighted-functional
  thresholds, strict Singer/SPC beyond-gate example, classical fiber-enumerator boundary, and
  optimized outer-family disposition were promoted →
  [`2026-07-16-c214-weighted-functional-transfer.md`](2026-07-16-c214-weighted-functional-transfer.md).
- **C203, C221, and C224 `[repaircodes]` [REPORTED]** — the serialized lane-wide `RepairCodes`
  aggregate and its final trace-only gate passed, closing the coefficient-gauge, exact
  weighted-transfer, and post-cold-read reviewer-hole validation tails. The implementation,
  standard-axiom, manuscript/ledger/trust, and PDF gates had already passed; the successful run is
  recorded in [`2026-07-16-c224-reviewer-hole-closure.md`](2026-07-16-c224-reviewer-hole-closure.md).

## 2026-07-16 repairports lane closeout

- **C215 `[repairports]` [REPORTED 2026-07-16]** — exact canonical and pointed fiber costs, full obstruction formula, reference and cached evaluators, prior-art boundary, and strict Singer/SPC example → [`2026-07-16-c215-functional-cost-api.md`](2026-07-16-c215-functional-cost-api.md).
- **C216 `[repairports]` [REPORTED 2026-07-16]** — exact pointed replication criterion plus scaled random-GV and AG/TVZ fixed-alphabet regions → [`2026-07-16-c216-prescribed-port-realization.md`](2026-07-16-c216-prescribed-port-realization.md).
- **C217 `[repairports]` [REPORTED 2026-07-16]** — complete circuit-incidence holonomy fingerprint, axis cross-ratios, strict support-identical monomial inequivalence, and concatenation covariance → [`2026-07-16-c217-gauge-invariants.md`](2026-07-16-c217-gauge-invariants.md).
- **C218 `[repairports]` [REPORTED 2026-07-16]** — quartic normal-rational-curve nucleus gives a harmonic `S(3,4,q+1)` radius-four repair family, `[q+2,5,q-3]_q` parameters, and positive-density replication → [`2026-07-16-c218-quartic-nucleus-repair.md`](2026-07-16-c218-quartic-nucleus-repair.md).
- **C219 `[repairports]` [REPORTED 2026-07-16]** — exact complete-port reliability recurrence and influences, C202 failure asymptotics, and C218 Steiner Poisson windows with a common-nucleus bottleneck → [`2026-07-16-c219-repair-reliability.md`](2026-07-16-c219-repair-reliability.md).
- **C220 `[repairports]` [REPORTED 2026-07-16]** — uniform restricted-sumset inverse theorem classifies every minimum and one-above-minimum cubic blocker over `F_3^h` → [`2026-07-16-c220-cubic-blocker-stability.md`](2026-07-16-c220-cubic-blocker-stability.md).
- **Lane disposition:** archived at
  [`handoffs/done/2026-07-16-repairports.md`](handoffs/done/2026-07-16-repairports.md); structured
  follow-up continues in `rp-next`.

## 2026-07-16/17 rp-next reported work

- **C226 `[rp-next]` [REPORTED 2026-07-16]** — exact cubic/axis failure transforms, radius-truncated EXIT calculus, cheapest-radius distribution, and target-specific stopping-certificate boundary → `notes/2026-07-16-c226-repair-port-exit-transforms.md`.
- **C227 `[rp-next]` [REPORTED 2026-07-16]** — identified full repair with the one-element pointed/Las Vergnas perspective polynomial, imported repair--failure duality and a deletion/contraction rank-enumerator identity, and proved the bounded-radius refinement boundary → `notes/2026-07-16-c227-pointed-tutte-repair-polynomial.md`.
- **C228 `[rp-next]` [REPORTED 2026-07-16; NEGATIVE BOUNDARY]** — proved that both C217 `U(2,4)` holonomy classes are ordinary multiplicative and not strongly multiplicative for every dealer; the quadratic Veronese criterion is support-only (`U(3,4)`) on this family → `notes/2026-07-16-c228-holonomy-lsss-mpc.md`.
- **C229 `[rp-next]` [REPORTED 2026-07-16]** — proved that full cooperative ports are clutter conjunctions of restricted singleton ports, identified sequential locality with small-circuit Horn closure and its stopping core, and gave a smallest six-column strict parallel/sequential/full-span separation → `notes/2026-07-16-c229-cooperative-horn-closure.md`.
- **C230 `[rp-next]` [REPORTED 2026-07-16]** — derived the causal min--max arrival-time valuation, exact direct-sum depth/core profile factorization, and lift-filtered element-conditioning law, with binary deletion/contraction counterexamples to the naive same-radius minor recurrence → `notes/2026-07-16-c230-horn-depth-composition.md`.
- **C231 `[rp-next]` [REPORTED 2026-07-16]** — proved exact 2-sum composition through scalar per-round locality-budget messages and a budget-indexed min--max arrival convolution, with a strict three-round binary interface relay and 98,000-state verifier → `notes/2026-07-16-c231-two-sum-repair-convolution.md`.
- **C232 `[rp-next]` [REPORTED 2026-07-16]** — lifted C231 to an exact multi-interface directed-message calculus and contextual tree congruence, then disproved a radius/width-only finite behavioral alphabet with an unbounded binary triangle relay at radius two and width two → `notes/2026-07-16-c232-multi-interface-transfer-obstruction.md`.
- **C233 `[rp-next]` [REPORTED 2026-07-16]** — proved that terminal saturation yields a finite radius/width-bounded boundary-control algebra on 2-sum trees, with exact active/core counts as additive infinite-carrier weights; triangle relays collapse to one control with unbounded weights → `notes/2026-07-16-c233-terminal-closure-transfer.md`.
- **C234 `[rp-next]` [REPORTED 2026-07-16]** — proved an exact associative finite recursive presentation for synchronous depth over an infinite budgeted bottleneck-delay carrier, with represented branching law `min(max(n,m),ell)` and explicit evaluation growth → `notes/2026-07-16-c234-tropical-delay-transfer.md`.
- **C235 `[rp-next]` [REPORTED 2026-07-16]** — defined the capacitated multi-target repair region and proved an exact harmonic-port availability-versus-throughput separation with a symmetry-reduced primal/dual certificate → `notes/2026-07-16-c235-capacitated-batch-repair.md`.
- **C236 `[rp-next]` [REPORTED 2026-07-16]** — proved all-field cubic radius-three sequential-equals-span and certified an explicit q=9 harmonic sequential-versus-span witness → `notes/2026-07-16-c236-flagship-closure-comparison.md`.
- **C237 `[rp-next]` [REPORTED 2026-07-16]** — explicit support-identical `U(3,8)` GRS/generic representations have square matroids `U(5,8)`/`U(6,8)` and separate strong multiplicativity for every dealer → `notes/2026-07-16-c237-u38-holonomy-mpc.md`.
- **C238 `[rp-next]` [REPORTED 2026-07-17]** — synthesized repaircodes/repairports/rp-next and the paper portfolio into commercially useful algorithms, data structures, explicit substantial-SOTA-improvement bets, protocol applications, and broader-CS paper packages → `notes/2026-07-17-c238-repairports-commercial-algorithms.md`.
- **C239 `[rp-next]` [REPORTED 2026-07-17]** — reinterpreted C238 through knowledge compilation, provenance, metabolic modes, e-graphs, contracts, weighted automata, sheaves, planning, and reconfiguration; derived a six-layer capability semantics, structural predictions, and ranked missed papers/products → `notes/2026-07-17-c239-domain-translation-audit.md`.
- **C240 `[rp-next]` [REPORTED 2026-07-17]** — killed the ULC and excluded-minor routes, proved the cubic Möbius cascade law and harmonic affine-core boundary, quantified the C216+C218 plain-LRC gap, and established exact width-two separator-vector cost convolution → `notes/2026-07-17-c240-rp-next-gap-probe-battery.md`.
- **C241 `[rp-next]` [REPORTED 2026-07-17]** — proved contextual sufficiency and exact finite least-feedback composition of truncated separator-vector response maps, then derived explicit bounded-branchwidth terminal Horn-closure and stopping-core algorithms → `notes/2026-07-17-c241-bounded-branchwidth-horn-closure.md`.
- **C242 `[rp-next]` [REPORTED 2026-07-17]** — deduplicated the session/Fable direction inventory against C226--C241, closed superseded routes, and reopened the lane with an expected-value-ranked agenda and explicit gates → `notes/2026-07-17-c242-rp-next-session-ideas-ev-review.md`.
- **C243 `[rp-next]` [REPORTED 2026-07-17]** — proved the exact q=9 nucleus switch and all-`q=3^h>=9` inert-spanning separation, delimited the propagation/spreading boundary, and retained only a two-parameter scoped threshold problem → `notes/2026-07-17-c243-nucleus-gated-separation-vet.md`.
- **C244 `[rp-next]` [REPORTED 2026-07-17]** — proved the pointed-distance table and exact joint law, corrected the EXIT ledger, quantified Poisson rates, and downgraded the split enumerator to a standard cited specialization → `notes/2026-07-17-c244-exact-consequence-pack.md`.
- **C245 `[rp-next]` [REPORTED 2026-07-17]** — ordinary LC survives 30,638 exhaustive pointed represented types across complete binary/ternary ranges; the morphism theorems enumerate independent-and-spanning bases rather than the all-subset rank-drop-one slice, leaving a precise representable-matroid conjecture → `notes/2026-07-17-c245-pointed-profile-log-concavity.md`.
- **C246 `[rp-next]` [REPORTED 2026-07-17]** — characterized realizable profiles as positive projectively invariant truncated subadditive metrics and proved that incoming-convolved response on realizable inputs is the fully abstract minimal structural semantics; raw C241 tables are sound but strictly redundant → `notes/2026-07-17-c246-contextual-minimality.md`.
- **C247 `[rp-next]` [REPORTED 2026-07-17]** — proved the exact support/coefficient/valuation dictionary and automatic repair-shadow preservation, identified C217 holonomies as restrictions of foundation points with an exact `U(2,4)` match, and closed the route as positioning-only because neither flagship gains a new repair capability → `notes/2026-07-17-c247-tract-foundation-audit.md`.
- **C248 `[rp-next]` [REPORTED 2026-07-17]** — corrected the port-to-MSP size dictionary, proved a connected-port one-row barrier giving native `n` versus excluded-field `n+1` rows for both flagships, and killed the proposed strong lifting route because the AG/anharmonic gadgets supply neither a growing rank-cover nor a Nullstellensatz-degree gap → `notes/2026-07-17-c248-field-sensitive-msp-scout.md`.
- **C249 `[rp-next]` [REPORTED 2026-07-17]** — exact transversals strictly beat action/TF--IDF diversity on four equal-cost remediation witnesses and pairwise risk diversity on a higher-order witness, but established shared-risk/d-failure-resilient routing already owns the frontier, so retain an application/checker rather than a new planning problem → `notes/2026-07-17-c249-transversal-plan-portfolios.md`.
- **C250 `[rp-next]` [REPORTED 2026-07-17]** — built and independently checked typed lineage, cheap-attack, and resolution lower-bound certificates, but proof-carrying plans, fault-tree cut sets, PB planning certificates, and LDFI already own every theorem-bearing component; retain the evidence boundary as product engineering, not a new formal object → `notes/2026-07-17-c250-proof-carrying-remediation-portfolios.md`.
- **C251 `[rp-next]` [REPORTED 2026-07-17]** — built a deterministic blinded common-mode fixture in which exact causal selection strictly beats every best surface/generation-axis tie at equal marginal risk, while retaining the result only as a synthetic benchmark hypothesis because annotations and execution share one authored causal model → `notes/2026-07-17-c251-agent-remediation-common-mode-benchmark.md`.
- **C252 `[rp-next]` [REPORTED 2026-07-17]** — decision-focused active fault discovery learns only dependency uncertainty capable of changing the selected remediation portfolio; the exact 16-model fixture strictly beats LDFI-style hazard enumeration, full-graph causal discovery, coverage, and random order, but targeted active learning already owns the acquisition objective, so retain the application translation only → `notes/2026-07-17-c252-decision-focused-fault-discovery.md`.

## Archived 2026-07-17 from the live queue

Moved verbatim from the live queue after completion reporting; relative links retain their original
depth because this archive is in the same `notes/` directory.

- **C144 `[relconic]` [REPORTED 2026-07-16]** — per-lane validation gate sets and atomic regeneration protocol → `notes/2026-07-14-c144-shared-library-gate-architecture.md`.
- **C154 `[relconic]` [REPORTED 2026-07-16]** — Reed--Muller deep-hole residual closed with no variety-equality counterexample; the precise bounded-audit novelty posture survives → `notes/2026-07-16-c154-reed-muller-deep-holes.md`.
- **C188 `[relconic]` [REPORTED 2026-07-16]** — q=5 exact relative-conic value; registry gate passed.
- **C201 `[relconic]` [REPORTED 2026-07-16]** — q=16 quadratic anatomy classified; the bounded q=64 Baer, torus, and split-Z3 mechanisms fail at coverage before nontrivial rank anatomy, so no infinite theorem is promoted → `notes/2026-07-16-c201-bounded-mechanism-closure.md`.
- **C223 `[relconic]` [REPORTED 2026-07-16]** — closed the manuscript-original Lean seams without new searches: q=5 coordinate transport, q=16 `2630+3` profile and exceptional arithmetic, arbitrary-eight-arc classification plus quadratic pullback, and q=11 non-GRS implication → `notes/2026-07-16-c223-arcs-formal-closure.md`.
- **C253 `[rp-next]` [REPORTED 2026-07-17]** — certified a feature-minimal seven-state irreversible-prefix witness with a residual continuation score drop from two to one, separated residual from total-history cost and structural from policy exposure, and killed the new-invariant claim because expanded-state strong/strong-cyclic winning already computes the score → `notes/2026-07-17-c253-continuation-resilience.md`.
- **C254 `[rp-next]` [REPORTED 2026-07-17]** — found an infinite regular-graphic counterexample family to ordinary pointed-profile log-concavity; the smallest TTSP member has 14 helper edges, profile prefix `(0,0,1,12,147)`, and exact failure `12^2<147`, refuting C245's representable conjecture → `notes/2026-07-17-c254-two-terminal-reliability-log-concavity.md`.
- **C255 `[rp-next]` [REPORTED 2026-07-17]** — defined exact gauge-invariant prime-field coefficient and directed-multiplier costs, and found support-identical `GF(9)` `U(2,4)` libraries with optima `0` versus `4` and `0` versus `14`; a cross-ratio/foundation obstruction explains the separation while gain-graph switching owns the generic optimization → `notes/2026-07-17-c255-gauge-invariant-coefficient-cost.md`.
- **C256 `[rp-next]` [REPORTED 2026-07-17]** — proved that `rank(M) <= r` makes the radius-truncated port full and reconstructive, and certified a seven-point Fano/non-Fano transition whose common field-neutral radius-two port splits at radius three into reciprocal characteristic-sensitive MSP gaps of six native rows versus at least seven wrong-characteristic rows → `notes/2026-07-17-c256-radius-truncated-port-rigidity.md`.
- **C257 `[rp-next]` [REPORTED 2026-07-17]** — identified active-column and auxiliary-dimension realization as coordinate projections of the established Pareto Hamming-embedding frontier, with truncation handled by a lower envelope over full metric completions; C246's full-profile private gadget is the published standard feasible point, so the isolated-atlas route is closed → `notes/2026-07-17-c257-separator-profile-realization-complexity.md`.
- **C258 `[rp-next]` [REPORTED 2026-07-17]** — harvested C215--C257 into three primary rewards—a focused complete-port manuscript, a separate compositional-semantics manuscript, and a matrix-to-Capsule recovery digital twin—plus five banked assets and a closed-route ledger → `notes/2026-07-17-c258-rp-next-reward-harvest-map.md`.
- **C259 `[rp-next]` [REPORTED 2026-07-17]** — converted the three primary rewards into execution-ready packets for the focused manuscript, Capsule CLI/digital twin, and compositional-semantics manuscript, with two gated mini-packets and explicit non-packets; the `rp-next` lane is complete → `notes/2026-07-17-c259-rp-next-execution-packets.md`.
- **C261 `[dihedral]` [REPORTED 2026-07-17]** — dedicated novelty audit complete: Brown et al. attribution verified exact in full text (ladder, prism, opposite-end-pendant families), Tranchida delineation confirmed accurate, no colliding prior art found for the fixed-point-deleted Schreier residual or the tame-dihedral catalogue; five wording recommendations (R1–R5, incl. the Schaefer root citation) deferred to the C264 manuscript pass → `notes/2026-07-17-c261-dihedral-novelty-audit.md`.
- **C274 `[complete-ports]` [REPORTED 2026-07-17]** — froze the complete-ports paper's six-part theorem spine, exact evidence crosswalk, exclusions, and keep/replace/move/delete rewrite bill; the user selected separate clean-history paper repositories and a shared Lean repository, so publication proceeds only through deny-by-default manifests rather than exposing monorepo content or history → `notes/2026-07-17-c274-complete-ports-manuscript-crosswalk.md`.
- **C275 `[complete-ports]` [REPORTED 2026-07-17]** — froze the deny-by-default complete-ports clean-room publication allowlist and fail-closed export procedure; direct publication/history transplant of the private monorepo and raw Lean build copying are forbidden, while the all-papers shared Lean monorepo requires a separate closure manifest and guarded pack/restore validation → `notes/2026-07-17-c275-complete-ports-publication-boundary.md`.
- **C276 `[complete-ports]` [REPORTED 2026-07-17]** — inventoried the paper-only migration from M1/`coding-repair-hypergraphs` to the complete-ports identity and from M2 to restoration-semantics, with exact physical/reference counts and an explicit prohibition on renaming the `repaircodes` lane, handoff, task pegs, owner references, or Lean namespaces → `notes/2026-07-17-c276-complete-ports-rename-census.md`.
- **C277 `[complete-ports]` [REPORTED 2026-07-17]** — created the dedicated complete-ports paper-preparation lane, re-pegged exactly C274--C276, archived the completed RepairCodes handoff, and preserved every pre-C274 `[repaircodes]` peg plus all `RepairCodes`/`RepairPorts` Lean namespaces → `notes/2026-07-17-c277-complete-ports-lane-split.md`.
- **C260 `[dihedral]` [REPORTED 2026-07-17]** — all five A₅ regular-template Node-Kayles nimbers independently reproduced (fresh Rust solver, left-mult-only canonicalization; values 1,1,0,0,0), with a group-free BLISS graph-isomorphism solver validating the method on V₄/S₄ and confirming the reference canonicalization group equals the full graph automorphism group in every A₅ class; single-solver risk retired, claim edits landed in the staging README, computation note, and manuscript Appendix A → `notes/2026-07-17-c260-a5-template-nimber-crosscheck.md`.
- **C262 `[dihedral]` [REPORTED 2026-07-17]** — Φ_T (Prop 11.1 + Cor 11.2) fully Lean-formalized in `DihedralSchreier/Burnside.lean` (universal-property homomorphism into ℕ-under-XOR, mod-two factorization, bulk cancellation, grounded in the certified `NodeKayles.grundy_sum`); Thm 12.1 finite-algebra core formalized in `Density.lean` (coprimality, period 8n, exact 2-of-4 P/N classification, Dirichlet infinitude of both P and N primes); full target green, headline axiom profiles `[propext, Classical.choice, Quot.sound]`, no `sorry`/`native_decide`. Open user gate: the numerical density value 1/2 needs prime equidistribution in AP, absent from mathlib → `notes/2026-07-17-c262-dihedral-burnside-density-formalization.md`.
- **C263 `[dihedral]` [REPORTED 2026-07-17]** — generalized-D₂ₘ additions landed per ruling D6: the missing two-reflection pair family classified for every `m≥3` of either parity (new manuscript §14, Thms 14.1–14.6) — free orbits are `C_{2m}` cycles contributing nothing, reflection orbits are Dawson paths, odd-order dihedral is always P, even case collapses to `(1−δ)·𝒢(Pₘ)`, densities 1 or ½; verified end-to-end over all 241,344 tame legal pairs for `q∈{5..23}` with 0 mismatches (tracked script/JSON/manifest bundle); paper retitled "Dihedral Subgroups of PGL₂(q)", Discussion renumbered §15; escape hatch not needed → `notes/2026-07-17-c263-dihedral-d2m-additions.md`.
- **C279 `[complete-ports]` [REPORTED 2026-07-17]** — migrated the private paper package, TeX/PDF stem, preparation artifacts, expert profile, registries, contextual shorthand, links, and clean-export allowlist to the canonical complete-ports identity; established the six-part section skeleton, rebuilt the PDF, and preserved all historical `repaircodes` pegs and Lean namespaces → `notes/2026-07-17-c279-complete-ports-identity-migration.md`.
- **C280 `[complete-ports]` [REPORTED 2026-07-17]** — replaced the seed-first draft by an 11-page six-part theorem-led manuscript integrating exact transfer, prescribed realization, reliability/bounded EXIT, standard pointed-Tutte structure, and cubic versus quartic-nucleus/harmonic flagships; synchronized bibliography/ledgers/registries, rebuilt cleanly, and reproduced all six cited deterministic certificates byte-for-byte → `notes/2026-07-17-c280-complete-ports-six-part-assembly.md`.
- **C285 `[complete-ports]` [REPORTED 2026-07-17]** — completed the submission-preflight citation-chain and claim audit: the six-part theorem spine survives, but eleven required source/claim corrections and seven citation-chain corrections are frozen before submission; recommended omitting C220 while leaving its user gate open → `notes/2026-07-17-c285-complete-ports-citation-preflight.md`.
- **C286 `[complete-ports]` [REPORTED 2026-07-17]** — applied the C285 correction list and an independently discovered exact-transfer repair, reconciled three context-light paragraph-by-paragraph cold reads plus same-reader resolution passes, synchronized the manuscript package, and rebuilt/visually inspected the warning-free 11-page private PDF; C220 and public provenance remain user/release gates → `notes/2026-07-17-c286-complete-ports-correction-and-cold-read.md`.
- **C278 `[dihedral]` [REPORTED 2026-07-17]** — Thm 12.1 density-½ closed conditionally: one quarantined axiom `primes_equidistribute` (PNT in arithmetic progressions, natural-density form, Davenport Chs. 20–22) in `DihedralSchreier/DensityAxioms.lean`, and `DensityConditional.lean` kernel-derives relative density ½ for all three triple types and both torus signs from it plus the committed 2-of-4 classification (`φ(8n)` cancels); all three headline audits show exactly `[propext, Classical.choice, Quot.sound, primes_equidistribute]`; full target green; axiom to be replaced when mathlib ships PNT-in-AP → `notes/2026-07-17-c278-dihedral-conditional-density.md`.
- **C283 `[dihedral]` [REPORTED 2026-07-17]** — wild-case scoping spike: over `q = p ∈ {3,5,7,11,13}` (all 22,968 involution pairs, 1,992 wild, zero mismatches) `p | 2m` forces `D_{2p}` with a unipotent rotation, Borel-reducible action, a single deleted fixed point, residual a single path `P_p`, and `𝒢 = A002187(p)` (Dawson) — breaking the tame odd-order P-position law (wild `D₁₀` is an N-position at `𝒢 = 3`); legal triples cannot be wild; §15 remark applied to the manuscript; a full wild pair classification is judged a short lemma while the wild `PSL/PGL`/polyhedral residuals remain untouched → `notes/2026-07-17-c283-dihedral-wild-case-spike.md`.
- **C282 `[dihedral]` [REPORTED 2026-07-17]** — OEIS byproduct drafts: one recommended new submission (Node-Kayles Grundy value on the cycle `C_n`, offset 3, terms n=3..60 from the C263 certificate; `a(n)=1` iff `A002187(n-3)=0`; full field-format draft with C270 `%H`/`%o` placeholders; live collision check clean), one crossref-only (path = A002187, Dawson), five candidates declined with reasons (even-cycle all-zero, `D_{4n}` constants/parity, S₄/A₅ finite table, q-sample histograms, AP indicators); nothing submitted → `notes/2026-07-17-c282-dihedral-oeis-byproducts.md`.
- **C284 `[dihedral]` [REPORTED 2026-07-17]** — polyhedral nonregular coset templates complete: `A₄` cannot be involution-generated; all four `S₄` and six refined `A₅` generating-triple classes tabulated with every cyclic-stabilizer nonregular template nimber; the `(σ,ρ)` pair proved a complete `Aut(G)`-orbit invariant, splitting the old `A₅ (3,5,5)` signature into `ρ=3/5` classes with differing nonregular values; field-dependent orbit/Grundy formulas stated; dual-solver agreement on all 38 templates plus a 2,160-triple matrix replay over ten embeddings with zero mismatches (independently re-replayed at review); bundle committed atomically; manuscript integration owed by C264 §6 under the adopted spine → `notes/2026-07-17-c284-dihedral-polyhedral-coset-templates.md`.
- **C289 `[dihedral]` [REPORTED 2026-07-17]** — conceptual `A₅ (3,5,5)` split complete: the common-order lemma proved for involution triples in any group (the six products form two conjugacy triples exchanged by inversion); the split proved a class discriminator via the trace-zero Fricke identity `tr(ABC)² = 4−x²−y²−z²−xyz` (ρ=5 iff the two order-5 pair products are `A₅`-conjugate, with `abc` in the opposite class); icosahedral identification proved (ρ=5 = isoceles edge-axis triples, two inner orbits of 30 fused by the outer/Galois twist; ρ=3 = scalene, one inner orbit, outer stabilizer); a mirror lemma (free non-adjacent involution ⇒ regular value 0) upgrades six polyhedral `t₁=0` entries from computed to proved, the `ρ=3` regular zero staying computational (no mirror exists in the order-120 color group); the coset templates re-expose the rotation-subgroup conjugacy geometry that the free orbit quotients away; all claims verified by an adjacent stdlib-Python certificate with independent C284 residual replay (six template values, zero mismatches) → `notes/2026-07-17-c289-a5-triple-split.md`.
- **C288 `[dihedral]` [REPORTED 2026-07-17]** — exhaustive tame polyhedral embedding census complete for odd prime powers `q ≤ 101`: 26 `S₄` fields (all `p ≠ 3`, incl. `q = 25, 49`) and 12 `A₅` fields (`q ≡ ±1 (mod 5)`, `p ∉ {3,5}`), one `PGL₂(q)`-class each (exhaustive union-find verification at `q = 7, 13` `S₄` and `q = 11` `A₅`; `N(G)=G` at every field), 5,912 generating triples classified; C284 reproduced exactly (38/38 template rows byte-identical, 10/10 conic rows, 2,160 triples, 50 value comparisons, 0 mismatches) on independently found subgroups; 8,540 per-orbit residual replays and 3,596 whole-board direct replays, 0 mismatches; new beyond C284: full-board Grundy value 2 occurs (`(2,3,3);ρ=4` value `2(ε₂ₐ⊕ε₄)`, nonzero iff `q ≡ 3, 5 (mod 8)`, first at `q = 5`), C284's split law refined (`ε₂ₐ = 1 ⇔ q ≡ 1, 3 (mod 8)` with `ε₄ = 1 ⇔ q ≡ 1 (mod 4)`, so `S₄` board values depend only on `q mod 8`), closed-form value laws verified for all 10 classes on the whole domain, first free-orbit `A₅` fields (`q = 59, 71, 79, 89, 101`); wild `q = 3, 9, 27, 81` (both) and `5, 25` (`A₅`) excluded per C283; draft C264 appendix included → `notes/2026-07-17-c288-polyhedral-embedding-census.md`.
- **C281 `[dihedral]` [REPORTED 2026-07-17]** — exhaustive tame legal dihedral census complete over odd prime fields `q ∈ {3,…,23}` (`q=9` excluded to match prime-field convention): 255,288 tame legal pairs and 246,000 legal tame dihedral triples classified by paper family with per-q value histograms, all triple values in {0,1}; every direct value matches the orbit-template engine and a corrected closed form (0 mismatches); C263 overlap exact (241,344 pairs, identical histograms), C284 overlap exact (14 S₄ copies at q=7, 22 A₅ copies at q=11 incl. the ρ-split), C283 no-legal-wild-triple re-verified, gate validated by gate-free full-closure re-enumeration at `q ≤ 11`; **finding: value-affecting §9 gap** — when `h=(q∓1)/2n` is even a second `D_{4n}` conjugacy class with all-nonsplit reflections (`t=0`) exists (e.g. `q=7` `D₈` acting freely, board `M₈`, value 1 vs boxed 0); 27,528 triples deviate from §9's orbit multiplicities, 20,196 (odd-`d`) from its boxed values, exactly one of the two classes an N-position; §14/C263 pair value formula survives (`t ≡ 1+δ (mod 2)`); corrected closed form `𝒢 = (f mod 2) ⊕ 1_{2|n}(t mod 2)` (odd d) / `t mod 2` (even d) verified on every configuration; §9/Cor 9.1 t-case split owed by C264; draft appendix + Remark Y included → `notes/2026-07-17-c281-dihedral-census-appendix.md`.
- **C210 `[relconic]` [REPORTED 2026-07-18]** — closed the selected trace-one two-repair-coset route: exact ideal memberships prove the three `a!=0,b!=0` factorization branches arithmetically complete over every odd-degree field; the universal identity `H=delta*N*G1` removes the global reconstruction boundary; every nonconstant-height specialization is collision-forcing for odd-tower `q>=32768` (all degenerate/factorization strata already for `q>=512`), while the constant-height fixed-coefficient scalar-extension gate has no survivor; this is a bounded mechanism obstruction, not a global C210 nonexistence theorem → `notes/2026-07-17-c210-bounded-two-repair-coset-obstruction.md`.
- **C290 `[dihedral]` [REPORTED 2026-07-18]** — closed polyhedral congruence laws proved: fixed-point criteria in `PGL₂(q)` (semisimple `d ≥ 3` split iff `d | q−1`; involution split iff `PSL₂`-membership agrees with `q ≡ 1 (mod 4)`) and all seven split-indicator laws now theorems (`S₄`: `ε₂ₐ = [χ(−2)=1]`, `ε₄ = ε₂ᵦ = [χ(−1)=1]`, `ε₃ = [χ(−3)=1]`, with `S₄ ≤ PSL₂ ⇔ q ≡ ±1 (mod 8)`; `A₅ ≤ PSL₂` by perfectness with the three congruence indicators); orbit-equation divisibility and the free-orbit parity `m₁ ≡ [χ(6)=−1] + [q ≡ 1 (mod 5)] (mod 2)` proved; all ten closed board-value laws now hold for every admissible tame `q` (proved modulo the finite `q`-independent C284 template table), including `v(2,3,3) = 2[χ(2)=−1]` (exact period 8) and the cancellation `v(2,5,5) = [χ(6)=−1]` (modulus 24); minimal moduli 120/24/15/4 established; every nonconstant class an N-position with relative prime density exactly 1/2 (PNT for APs); checker verified 0 mismatches against the full C288 census (140 indicators, 176 law-vs-census values, 114 direct values), character identities on all primes `< 10⁴`, parity sweep `q < 6000`; four print-ready corollaries P1–P4 and draft manuscript section for C264 included → `notes/2026-07-17-c290-polyhedral-congruence-laws.md`.
- **C298 `[relconic]` [REPORTED 2026-07-18]** — audited all `t`, `r`, and `r+u` collision projections: outside two exact `a=0`, `delta=b=p`, `w∈{0,1}` terminal star overlaps, every certified genuine component has fiber degree at most nine and therefore `nu>=ceil(M/25)`, `tau>=ceil(M/9)` from its `M` rational collisions; on the two overlaps the sole genuine oriented component has `q-1` edges but matching/transversal number one, isolating the precise projection collapse that blocks a uniform deletion theorem → `notes/2026-07-18-c298-c210-robust-collision-matching.md`.
- **C297 `[relconic]` [REPORTED 2026-07-18]** — proved that the C210 common-curvature/common-linear-direction family is not a universal quadratic two-repair-coset normal form: the natural constant-p trace-compatible family has three omitted `F`-degrees of freedom, including projectively invariant unequal repair curvatures; computed the exact conic-stabilizer and semilinear quotient actions, separated geometric scaling from equation gauge and relabeling, and recorded the additional linear-p trace stratum → `notes/2026-07-18-c297-c210-normal-form-moduli.md`.
- **C304 `[relconic]` [REPORTED 2026-07-18]** — delimited the alternative-tower boundary: even scalar extensions of the fixed C210 quadratic model collapse its repair cosets, while a fresh Artin--Schreier quadratic extension over every characteristic-two base supports C297's full constant-p internal/cross-repair theorem; the theorem-led odd-characteristic planar pilot recovers exactly the existing two-parabola seed and proves that planarity alone supplies neither a third legal layer nor relative coverage → `notes/2026-07-18-c304-c210-alternative-towers-functions.md`.
- **C301 `[relconic]` [REPORTED 2026-07-18]** — proved the bounded-degree full-layer exceptional-incidence dichotomy: a Frobenius-fixed genuine noncollapsed component of bidegree at most `(m,n)` supplies Hasse--Weil collision, matching, and transversal bounds, while the only fixed-point-free component types at C210 bidegree `(6,4)` are `(2)`, `(3)`, `(4)`, and `(2,2)` (only the even types can persist through every odd scalar degree); standard exceptional-cover classifications do not apply without a finite-cover presentation, and no exceptional-incidence case remains inside the certified C210 slice → `notes/2026-07-18-c301-c210-exceptional-incidence-dichotomy.md`.
- **C302 `[relconic]` [REPORTED 2026-07-18]** — proved the exact carrierwise secant-defect and deletion-stability identities: repeated-hit energy has the necessary higher-multiplicity correction, the prescribed-hole defect decomposes over arbitrary carriers, C174 and Baer-fiber invisibility are exact specializations, and collision-free relative completeness after deletion is equivalent to one set hitting the collision-triple hypergraph without vertex-covering any old required-point support graph while also covering the deleted vertices themselves; specialized the gate to C298's two terminal star centres and cleared C303 → `notes/2026-07-18-c302-c210-carrierwise-secant-stability.md`.
- **C303 `[relconic]` [REPORTED 2026-07-18]** — closed the `GF(8)` terminal partial-domain pilot with a deterministic four-case certificate: 32 layer vertices quotient to 30 geometric points with two seed/repair coincidences and one selected conic point; deleting that conic point is mandatory and already uncovers exactly one required affine point, so monotonicity excludes every collision-free `C`-complete restriction; the exact geometric collision hypergraph has 32 triples and maximum admissible arc size 19, while the nonterminal larger-field partial-domain question remains outside this bounded negative → `notes/2026-07-18-c303-c210-partial-domain-hypergraph.md`.
- **C300 `[relconic]` [REPORTED 2026-07-18]** — classified the twelve nonlinear `PG(2,64)` repairs as three full `PGL(3,64)`/monomial-code classes with stabilizer order four but one Frobenius-semilinear class; excluded the conic-pencil, translation, hyperfocused, and affinely regular lineages; found the intrinsic `10+10+4` maximal-conic signature and resolved `56→14→0` as an order-four/order-two translation-coset decomposition; bounded the Kloosterman elliptic connection to a lookup → `notes/2026-07-18-c300-c210-q64-arithmetic-classification.md`.
- **C305 `[relconic]` [REPORTED 2026-07-18]** — proved the weighted `p=1` chart lossless for the target generic collision and genuineness problem, audited the exact enumeration, layer-reversal, translation, and Frobenius quotients, and replayed a deterministic 512-configuration shard with direct reconstruction/incidence checks; the corrected off-divisor scope still has at least `994,939,695,325,867` representatives, rejecting a full exact sweep under the feasibility gate and reducing the finite gap to an exact height-plane image problem → `notes/2026-07-18-c305-c210-q512-generic-closure.md`.
- **C312 `[relconic]` [REPORTED 2026-07-18]** — proved a basis-independent conjugation-coordinate determinant lemma for both seed--repair orientations, reduced distinct splitting exactly to `p!=0` and `Tr(q/p^2)=0`, classified the constant, affine, squarefree-pole, and inseparable-pole trace strata, and exported C297's full constant-`p` family as eight exact finite-field packet equations with every repeated-root, conic, coincidence, and quotient boundary separated; the global moduli solve remains C315-owned → `notes/2026-07-18-c312-c297-seed-repair-legality.md`.
- **C313 `[relconic]` [REPORTED 2026-07-18]** — proved C297's linear-`p` stratum empty over every odd scalar degree: the two required trace-one classes sum to `Tr(z^2+z+1)=Tr(1)=1`, contradicting `1+1=0`; reconstructed the hypothetical repair coefficients, audited every zero/pole open and the exact projective/relabeling/semilinear boundary, and showed that C312's seed gate is vacuous and C316 receives no linear-`p` incidence base → `notes/2026-07-18-c313-c297-linear-p-stratum.md`.
- **C314 `[relconic]` [REPORTED 2026-07-18]** — converted C297's thirteen-dimensional constant-`p` quotient into a lossless six-stratum marked atlas: unequal curvature has one residual involution, equal curvature splits by the exact `E/F` direction determinant into five reconstructible charts, and all trivial/order-two/additive stabilizers, repair/seed relabelings, semilinear boundaries, conic coincidences, conic-avoidance deletions, and C312 packet divisors are explicit; the C210 slice is codimension three and C315/C316 can reconstruct coefficients without C297's raw action → `notes/2026-07-18-c314-c297-invariant-moduli-stratification.md`.
- **C315 `[relconic]` [REPORTED 2026-07-18]** — solved C312's eight seed-legality packets on C314's atlas for the odd-degree tail: nonconstant Artin--Schreier classes and the exact two-orientation linear-pole contradiction force `c=K=1,B=0`, leaving one nonempty nine-dimensional constant-height `E4` survivor with an explicit `Q(Q+1)/4` two-trace seed fiber, all quotient/stabilizer dimensions, prescribed-conic deletions, and allowed coincidence boundaries exported to C316; the isolated `Q=8` packet system remains outside the tail theorem → `notes/2026-07-18-c315-c297-constant-p-seed-legality.md`.
- **C306 `[dihedral]` [REPORTED 2026-07-18]** — migrated the dihedral markdown submission into the canonical LaTeX manuscript `papers/dihedral-schreier-node-kayles/dihedral_schreier_node_kayles.tex` on Fable's adopted eight-section spine: two-point `D₂ₘ` family before the triple `D₄ₙ` family, ladder structural proofs and the double-cover lemma intact, Burnside as corollary plus remark, density kept as a named theorem, wild `D_{2p}` case as the boundary marker, polyhedral free-orbit table promoted to the body; registered in `papers/Makefile` and building warning-clean; every source theorem, proof, equation, table, and remark has a named destination in the report's non-loss ledger, with the §7.1 `t`-case-split correction and three uncited references carried forward to C307/C308 → `notes/2026-07-18-c306-dihedral-structural-rebuild.md`
- **C316 `[relconic]` [REPORTED 2026-07-18]** — proved that C315's constant-height survivor does not inherit C305's two-height map: the common `E`-height cancels identically from every collision determinant, while the four exhaustive mixed-layer supports admit lossless relative-offset maps of generic degrees `6,6,5,5` with a degree-two repair-conic-coincidence specialization; exported exact eliminants, Jacobian/branch ideals, translation-line fibers, dimensions, common-height deletions, packet and conic degeneracies, and the finite quotient interface to C317 → `notes/2026-07-18-c316-c297-incidence-height-map.md`.
- **C317 `[relconic]` [REPORTED 2026-07-18]** — corrected C316's prescribed-target fibers to zero-dimensional schemes whose unreduced components are genus-zero translation lines with residue-field constant fields and one projective-infinity deletion; proved each seed--seed--repair fiber is an exact degree-five algebra, so every fixed seed-legal constant-`p` configuration acquires a genuine collision after odd relative degree `1`, `3`, or `5`; classified the fresh-per-field boundary as four simultaneous finite no-root gates followed by relative coverage, retained every branch/coincidence divisor and the `Q=512` gap, and recommended only a bounded mechanism-paper scope for C299 → `notes/2026-07-18-c317-c297-asymptotic-dichotomy.md`.
- **C327 `[relconic]` [REPORTED 2026-07-18]** — proved the two seed--seed--repair pentics have individual geometric monodromy `S5`, generically disjoint splitting fields with joint group `S5 times S5`, and no legality-cover resolvent collapse; on the common seed-translation line classified the exact seven slope-dependence divisors, proved the independent degree-sixteen legality cover rational with exactly `Q/16` legal parameters, bounded the pulled-back joint-cover genus by `455,701`, and combined effective Chebotarev with a nonzero degree-`732` skeleton open to prove simultaneous no-linear-factor survivors over every odd-tower field `Q>=2^41`; exported the surviving base to the two degree-six gates and relative coverage, neither of which is claimed → `notes/2026-07-18-c327-correlated-degree-five-factorization.md`.
- **C329 `[relconic]` [REPORTED 2026-07-18]** — proved fresh-field four-layer arc existence on the allowed repair-conic coincidence locus for every odd-tower `Q>=2^45`: the two repair--repair--seed quadratics add two compatible trace-one classes to C327's four legality classes, the exact sixfold Artin--Schreier cover is rational of degree `64`, the specialized pentic branch-divisor sums differ by `d^3/(x+x')`, and effective Chebotarev on the resulting joint `S5 times S5` cover supplies simultaneous avoidance of all four C316 collision fibers; relative coverage remains the sole construction-facing gate → `notes/2026-07-18-c329-fresh-field-four-layer-arc-existence.md`.
- **C330 `[relconic]` [REPORTED 2026-07-18]** — proved that C329's collision-free `Delta_R=0` four-layer arcs are not `C`-complete and closed the generic `Delta_R!=0` fallback as well: the constant-height `E4` carrier structure gives an exact union of seven finite secant-direction images of size at most `7Q-2`, leaving at least `Q^2-7Q+2` required nonconic points uncovered on the line at infinity for every `Q>=8`; the obstruction holds before the six trace and pentic-derangement gates and is specific to this architecture, not a global square-root nonexistence theorem → `notes/2026-07-18-c330-relative-coverage-of-fresh-four-layer-arcs.md`.
- **C299 `[relconic]` [REPORTED 2026-07-18]** — supplied the bounded Paper II drafting package: separated genuine conic-stabilizer projectivities from equation gauge, relabeling, and semilinear equivalence; reduced the generic characteristic-two collision quartic to one Artin--Schreier class; gave the exact three-branch odd-tower residue-completeness argument and the second-layer rational-point/genuineness proof order; and made explicit that C329's fresh-field four-layer arcs fail `C`-completeness by C330's infinity-direction obstruction → `notes/2026-07-18-c299-c210-artin-schreier-conic-bundle.md`.
- **C151 `[alt-orbit-repair]` [REPORTED 2026-07-19]** — closed the exact Q25 exceptional minimum at the normalized-row level: reused each committed class certificate's threshold-free `sound` field through `card_legalOrbitSet_ge_of_sound` to prove `33 <= (maskOrbitSet allowed).card` for the `1,184` non-minimizer classes, generated per-row exhaustion disjunctions over all `46,056` normalized rows, and concluded that every row attaining `32` lies in the `1600`-element union of the five certified minimizer orbits; two probe-established definitional facts removed the projected `1,036`-module per-row class-link layer entirely, and the `24` minimizer rows split `3,6,6,3,6` in independent agreement with the certified orbit sizes `200,400,400,200,400`; first build `1:57:09` serial, axiom profile clean, semantic lift of exhaustion left to C331 → `notes/2026-07-14-c151-q25-minimum-classification.md`.
- **C209 `[relconic]` [REPORTED 2026-07-18 — CLOSED NEGATIVE]** — closed without activation because C201 supplied neither a stable cross-cell geometric feature nor a minimal rank failure with a demonstrably simpler dual interpretation; this is an unmet entry gate, not a nonexistence claim for polarity-dual or structural rank/defect stability theorems → `notes/2026-07-16-c209-conic-rank-stability.md`.
- **C331 `[alt-orbit-repair]` [REPORTED 2026-07-19]** — lifted equality-orbit exhaustion from normalized rows to semantic arcs, closing the exact Q25 exceptional minimum: factored the two projective normalizations out of the C151 lower-bound proof as threshold-free steps (`exists_base_normalizedConfig`, `exists_residual_rowConfig`) and reused them in the opposite direction through the cardinality equalities `card_legalOrbitSet_liftMapIdx` and `card_legalOrbitSet_residual`, pinned the semantic count to the indexed one by a sandwich against the already-lifted `>= 32` bound rather than a new surjectivity bridge, and absorbed the residual step by proving `minimumOrbitUnion` invariant under the order-`400` action so only the base collineation survives into the statement; `f2_normalizes_into_minimumOrbitUnion` now places every invariant eight-arc in `PG(2,25)` with exactly two fixed points attaining `32` into the `1600`-element union of the five certified minimizer orbits, so `32` is the exact semantic minimum with a complete extremal classification up to normalization; no new generated bulk, all C151 generators and trees untouched, the three reported C151 terminals re-proved with statements unchanged, twelve declarations audited at `[propext, Classical.choice, Quot.sound]` → `notes/2026-07-14-c151-q25-minimum-classification.md`.
