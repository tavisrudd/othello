# Codex task queue — delegated by Fable (2026-07-07)

Protocol: each task lists a **report file**. Codex does the work, writes findings to the report
file (create it; plain markdown; include verbatim commands/outputs for any machine check), and
leaves the queue entry below marked `[REPORTED <date>]`. Fable reads the report files at day-end
wrap. Do not edit other WIP notes; do not touch the queens tmux panes.

**Box update 2026-07-07 evening:** the z5 run was killed and G(17) is done — the RAM/core
constraint is LIFTED. Compute up to ~8 GB / multi-core is fine; still no q ≥ 23 grid-cap
campaigns and no n=20 queens runs without an explicit gate.

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

**A5 lane — arc-depletion arithmetic (now the sole live (ON) mechanism route).**  With the
config-mechanism sweep complete (static C55/C64/C69 + dynamic Correction 3, all negative), A5 is the
only surviving (ON) mechanism angle — and until now it carried no task ID.  Complementary to the
open core, not competing: even a resolved 12-state hard surface still needs A5's anchor, so do NOT
elevate A5 above Cluster 2; C68 is cheap enough to just run alongside.  Note A5 is stated at the
oval/complete-arc incidence level, which C58's all-P order-9 result *strengthens* rather than
disturbs (the depleted orders {11,17} are primes, where the non-Desarguesian planes do not even
exist, so the dichotomy data is untouched).

- **C68 [REPORTED 2026-07-10 (Claude)]** — the depletion-fraction extremal sequence `D(q)`
  (sweep E2).  Exact result: `D(q) = 0` at every non-arc-depleted order (5,7,9,13,19,23;
  min-witness = q−4) and `D(q) > 0` **exactly** at `{11,17}` (`5/7`, `12/13`).  The knife edge
  **sharpens** along the depleted subsequence (min-witness `2 → 1`, margin `2 → 1`); it recovers only
  at non-depleted orders.  So "`D(q)` bounded away from 1" is **not** supported — but the (ON) route
  only needs **min-witness ≥ 1**, i.e. the A5 target `maxonN(q) ≤ q−5` (no size-3 class has all q−4
  on-conic children N).  Decisive missing datum: `D` at the next depleted order (>23) → routes into
  C44 (GF(25)/q=25 census).  Report:
  [`2026-07-09-codex-depletion-fraction.md`](2026-07-09-codex-depletion-fraction.md); script
  `rust/scripts/c68_depletion_fraction.py`.  **A5 lane now has one reported measurement; the live
  (ON) levers are Cluster 2 (open core) + the A5 arithmetic proof of `maxonN(q) ≤ q−5`.**
- **C68 follow-on — N-bucket density `ν(q)` [2026-07-10 (Claude)]** — bucket-level image of `D(q)`.
  Exact on-conic bucket census (`s4arena --all`): **`ν(q)`** (state-weighted N-fraction) `= 0` off
  {11,17}, `0.357` (q=11), `0.791` (q=17) — positive & ~doubling; #N-buckets `1 → 5`. Null model
  `E[fully-N classes] = ncls·ν^(q−4)`: `0.006` (q=11) but **`1.000` (q=17)** vs 0 observed, so
  **min-witness ≥ 1 is a MARGINAL suppression at q=17**, at the random-failure threshold, trend
  adverse — A5 must actually bound the extremal class-type, not lean on "no fully-N class through
  q=19." onP is bimodal (few PGL class-types; min-witness = extremal-type count); value separates
  cleanly by bucket fiber size (P = rare/special, N = generic) → **A5 lead: every 5-point frame
  admits a special (P) completion.** Report:
  [`2026-07-10-codex-a5-nbucket-density.md`](2026-07-10-codex-a5-nbucket-density.md); script
  `rust/scripts/c68b_nbucket_density.py`.

**Independent lanes (parallel; pull when unblocked):**

- **C30** — generated-checker refactor → q17/q19 Lean assembly (engineering, long-running).
  The v5 full q17 canonical build now projects above 21.5 h sequential, tripping the task's
  explicit ~10 h user-launch gate; do not launch it implicitly.
- **C43 [REPORTED 2026-07-09 — `PG(4,3) = P`]** / **C44** — the former
  even-dimensional evidence vacuum is closed by the first direct P datum; q=25 census remains an
  active compute lane.  C43's optional follow-up is strategy extraction, not another sizing run.
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

## C1. Machine-check the Lemma-4 correction (sum-free Z_n mirror lemma) — PRIORITY [REPORTED 2026-07-07]

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

## C2. Lean statement scaffold — conic localization lemma (optional, after WP-1/WP-2) [REPORTED 2026-07-07]

Per the day plan's Codex section: statement-level scaffold only (no proof obligation) for the
conic localization lemma of `2026-07-07-conic-localization-onconic-escape.md` §1 — the unique
conic through the 5-arc, hyperbola normal form `(r−ρ)(c−A)=B`, the `q−4` on-conic legal
extensions, and the `ψ_u` involution. Vocabulary exists in `lean/ProjectiveCap/GridCounting.lean`;
the Möbius/hyperbola normal form is new content. A paper-ready prose version is being written in
parallel as `notes/2026-07-07-kernel-conic-localization.md` — match its statement decomposition
if it exists when you start.

Report file: `notes/2026-07-07-codex-conic-scaffold-report.md` (list of Lean names + file, what
is stated vs sorry-free vs deferred).

## C3. Discharge the esc-mode validation gate (q=17 + q=19) [REPORTED 2026-07-07]

O2 implemented the `esc` mode in `notes/2026-07-06-grid-cap-solver.rs` (uncommitted working
tree) and validated q=11/q=13 byte-identical to `escape` mode, but the mandated q=17/q=19
exact-match gate was interrupted at 6/21 q=17 classes (all matching so far). Everything needed —
build line, run commands, required-empty diffs against `2026-07-06-escape-q17.log` /
`-q19.log`, caveats — is in [O2's handoff](2026-07-07-esc23-o2-handoff.md). Run the gate to
completion (single-core, ~23 s/class at q=17, RSS ~80 MB — safe under the box constraint).
PASS = empty diffs on both q. Do NOT start any q=23 campaign.

Report file: `notes/2026-07-07-codex-esc-gate-report.md`.

## C4. Fill the arc-census paywalled gaps (q=23, q=25; q=31 full classification) [REPORTED 2026-07-07]

O1's census ([2026-07-07-arc-census-o1.md](2026-07-07-arc-census-o1.md)) fully sourced q=27/29
and all six minimum sizes, but the complete size spectra/counts for q=23 and q=25 live in
paywalled papers (Coolsaet–Sticker JCD 17 (2009); Marcugini et al. Discrete Math 307 (2007);
Faina et al. Ars Comb 47 (1997)), plus Coolsaet JCD 23 (2015) for the full q=31 classification
and Kéri JCD 14 (2006) for large-size counts. The note's GAPS section lists the exact (q, cell)
→ paper+table map. If you have library/alternate access, extract those tables into the census
note's format (append a `## C4 fill` section; tabulation only, per-claim citations, no
interpretation). If access also fails, record that and stop.

Report file: `notes/2026-07-07-codex-arc-census-fill.md`.

## C5. Test the PGL(2)-orbit value-invariance prediction (q=17 feat data) [REPORTED 2026-07-07]

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

## C6. Fix the latent GF(49) reducible-polynomial bug + field self-check (AFTER C3 completes) [REPORTED 2026-07-07]

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

## C7. Machine-check + write up the automorphism-exhaustiveness lemma [REPORTED 2026-07-07]

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

## C8. Exact-canon cross-validation of the fingerprint canon (q=11, q=13 + q=17 witnesses) [REPORTED 2026-07-07]

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

## C9. Lean statement scaffold — tau-mirror + exception-table certificate format (n=20 lucky plan) [REPORTED 2026-07-07]

Statement-level only (no proof obligation), after WP-1/WP-2 and C1–C8 work. Target: the Phase-3
artifact format of [`2026-07-04-n20-lucky-first-win-plan.md`](2026-07-04-n20-lucky-first-win-plan.md)
— extend the reply-book kernel in `lean/NodeKayles/Certificate.lean` toward
`Queens.N20J10LuckyTarget`: a certificate datatype of (automatic tau rule on the paired core +
border/scar exception table + terminal claims: closed pairing / tau-symmetric leaf / solved
leaf) and a checker-statement `certificate valid → position is P`. Fable is writing the
extractor design spec in window 2 (day plan W2-3) — match its decomposition if it exists when
you start; otherwise state the pieces against the n20 plan's §Soundness-boundaries list.

Report file: `notes/2026-07-07-codex-cert-format-scaffold.md`.

## C10. P0a border-signature census/valtest probe (n=20 lucky plan, Phase 0a) [REPORTED 2026-07-07]

Implement + run the probe EXACTLY per **Appendix P0a of `2026-07-07-fable-day-plan.md`**
(spec is self-contained there: modes `census`/`valtest`, signature v0/v1 definitions, gates,
guardrails). Reassigned from Opus to Codex per the standing delegation rule. Single-core,
≤1 GB, no n=20 runs. Deliverable = the report file with the census tables (n=12,14,16,18) and
valtest violations verbatim. This gates C11.

Report file: `notes/2026-07-07-p0a-border-signature-report.md`.

## C11. Central-child certificate extractor build (GATED on C10) [NO-GO 2026-07-07]

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

## C12. Per-q escape certificate emitter — Rust `cert` mode (route C, phase 1) [REPORTED 2026-07-07 (opus delegate)]

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

## C13. q=9 intrusion-structure probe (the next odd-plane Lean target)

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

## C14. WP-3 Lean certificate checker scaffold (GATED on C12's report existing)

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

## C15. PGL(2,q) orbit-collapse census at q = 11, 13, 19 (extends C5)

Rerun your C5 methodology at q = 11, 13, 19: regenerate feat data, reconstruct each on-conic
S₄'s 6-point parameter set, bucket by PGL(2,q)-canonical form, check value-constancy per
bucket, and report raw-children → orbit-bucket collapse ratios per q. Purpose: (i) more
falsification pressure on Lemma I (any mixed-value bucket REFUTES it — report verbatim and
stop); (ii) the collapse ratio decides whether route-C certificate books (C12/C14) should be
emitted per-orbit instead of per-class (C5 saw 273 → 10 at q=17). Same guardrails as C5.

Report file: `notes/2026-07-07-codex-pgl2-orbit-census-q11-19.md`.

## C16. Sum-free Tactic 2 — induction on `r` (activated by the z5 kill)

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

## C17. Anchored certificate family — the constructive `represents` bridge (route C, phase 2) [REPORTED 2026-07-08]

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

## C18. ML feature attribution on the on-conic value moduli (GATED on C15's report) [REPORTED 2026-07-08]

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

## C19. Verified boolean book-checker + reflection (route C, phase 3 — the C17 fix) [REPORTED 2026-07-08]

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

## C20. Winning-intrusion census on the on-conic buckets (intrusion calculus, attack option (i)) [REPORTED 2026-07-08; REVIEWED 2026-07-08 — SOUND]

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

## C21. q=23 esc single-class sizing probe (route D; C18 phase-2 leftover) [REPORTED 2026-07-08]

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

## C22. Transport lemmas + represents assembly (route C, phase 4 — the C19 open half)

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

## C23. TEXT visualizations of winning cap-game lines, odd q (study artifact for the strategy hunt)

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

## C24. Binary projective nofil theorem in Lean: `PG(n,2)=P` for every `n ≥ 1` [REPORTED 2026-07-08]

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

## C25. Elliptic-involution theorem in Lean: `PG(2m−1,q)=P` for odd `q` [REPORTED 2026-07-08]

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

## C26. Bibliography-grade novelty audit for projective Nofil/cap theorem [REPORTED 2026-07-08]

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

## C27. Correct residual mirror lemma for cap games [REPORTED 2026-07-08]

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

## C28. MirrorStep/MirrorClosed census and certificate-compression probe [REPORTED 2026-07-08]

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

## C29. Mixed-column mod-3 law + inverted bucket census at q = 23, 25, 29, 31 [REPORTED 2026-07-08]

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

## C30. Route C phase 5 — certificate books for q = 17 and q = 19 [REPORTED 2026-07-10 — certcheck PASS; q17/Class0 split Lean PASS]

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

## C31. Zone-steering ceiling census (the C20 review's surviving proof shape, made precise) [REPORTED 2026-07-08]

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

## C32. Composite-mirror stuck-free probe — plane variant first, then PG(4,3) (v2) [REPORTED 2026-07-09]

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

## C33. Act on Fable's line-capacity review — correct the framing, redirect the zone hunt [REPORTED 2026-07-09]

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

## C34. Assemble the D1 outcome-classes manuscript skeleton (the flag-planting paper) [REPORTED 2026-07-09]

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

## C35. Nimber (Grundy) oracle — make the S4 dump measure the conic⊕zone coupling [REPORTED 2026-07-09]

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

## C36. Cross-q combinatorial-type value alignment — localize the uniform-theorem obstruction [REPORTED 2026-07-09]

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

## C37. Cross-root shared-key agreement — scaled soundness check + state-complexity number [REPORTED 2026-07-09]

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

## C38. Tablebase strategy distillation — the forced-move skeleton corpus-wide [REPORTED 2026-07-09]

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

## C39. Remoteness/suspense — a dynamic monovariant (C18's null was static-only) [REPORTED 2026-07-09]

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

## C40. Oracle-driven winline generation (feeds C23)

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

## C41. Lean-certify the trapped ⇒ N converse (close the falsification equivalence) [REPORTED 2026-07-09]

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

## C42. Fixed-q census propagation — the rescoped surviving half of the concentration factorization [REPORTED 2026-07-09]

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

## C43. PG(4,3) exact-solve sizing — the former even-dimensional evidence vacuum [REPORTED 2026-07-09 — Claude/Opus — **PG(4,3) = P**]

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

## C44. GF(25) prime-power path + q=25 on-conic bucket census (the Baer falsification watch)

**[SIZED + ARENA TOOL BUILT 2026-07-10 (Claude); 2/28 buckets P; full census pending a
low-contention window.]** Report: [`2026-07-09-codex-q25-baer-census.md`](2026-07-09-codex-q25-baer-census.md).
GF(25) path in place (`irred(25)=x²+3` over F₅, nonsquare; self-check ok; MAXW ok) and **28
full-PGL(2,25) on-conic buckets** enumerated (~4 s). The wall was RAM: FnvMap labeling (33 B/slot,
rehashes) blows 8 GB on the generic buckets. **Fixed by building `s4arena`** (commit `60c87fb`) — S4
labeling on the 16-byte `Shard` arena (fixed pre-alloc, no rehash), validated byte-identical to FnvMap
(labels + distinct-class counts match C54). Results so far, both **P**: bucket 1 `[1,2,3,4]` (26.3M),
bucket 0 `[1,2,3,5]` (**213.5M positions**, 18 min, 4 GB — the bucket FnvMap couldn't finish). Census
is now a **~6 h / 8 GB `--log2 29` run** (`s4arena 25 --all`); gate-compliant on RAM but multi-hour +
box is contended, so it's a size-then-gate decision — run in a low-contention window (streams per
bucket, resumable via `--start`, any N shows immediately = falsification). **Import:** q=25 is the
third depleted-point test of C68's margin `2 → 1 → 0?` (min-witness → 0 would refute conic
localization as the mechanism, not the conjecture). Full census + original spec remaining below.

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

Budget: hard 8h wall, single-core, ≤ 8 GB. Report file: `notes/2026-07-09-codex-q25-baer-census.md`.

## C45. Game-valued defect-skeleton refinement — beyond classical conic-arc spectra [REPORTED 2026-07-09]

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

## C46. t-ply conic-depletion inequality ladder — where a trap can live [REPORTED 2026-07-09]

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

## C47. Minimal-counterexample constraint package (gate DISCHARGED 2026-07-09 — C42 reported) [REPORTED 2026-07-09]

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

## C48. Mirror-theorem harvest on classical varieties — new P families at lemma-application cost [REPORTED 2026-07-09 (Claude/Opus) — Lean landed]

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

## C50. Kernel-checked Grundy certificates — machine-verified game-value sequences (post-C35) [REPORTED 2026-07-10 — tiny PASS / literal-scale NO-GO]

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

## C49. Node-Kayles nimber tables for other chess pieces (D6 siblings, queens box idle time)

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

## C51. Polar-space Nofil — symplectic W(2n−1,q) and beyond (mirror harvest #3) [handed off by Claude/Opus 2026-07-09] [REPORTED 2026-07-09 (Claude/Opus) — Lean engine landed]

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

## C52. Segre / product-variety Nofil (mirror harvest #4) [handed off by Claude/Opus 2026-07-09] [REPORTED 2026-07-09 (Claude/Opus) — Lean base family landed]

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

## C53. Full-PGL on-conic orbit bridge + q=23 computed-status cleanup [DONE 2026-07-09 — Claude; parts 1–4]

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

## C54. Certify the q=23 full-PGL bucket labels [REPORTED 2026-07-09]

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

## C55. d-lattice side-switch diagnostic — a mechanism candidate for the arc-depleted-order dichotomy [REPORTED 2026-07-10 — NEGATIVE]

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

## C56. Group-indexed cross-q type alignment (the C36 retry) [GATED on a C55 positive]

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

## C57. Zone conflict-graph quasi-randomness probe — one structural statement for the zone negatives

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

## C58. Cap game on the four projective planes of order 9 — order vs Desarguesian structure

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

## C59. Arc-stability constraint import — second-largest complete arc bounds into the trap/endgame package [REPORTED 2026-07-10]

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

## C60. Singer-model circulant probe — the plane as a cyclic difference-set board

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

## C61. Finite-state reply automaton over defect/interface/zone states (sweep Co3)

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

## C62. Inverted selector search scored by exact character sums (sweep T1) [REPORTED 2026-07-10]

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

## C63. LP-fit the amortized potential; read the infeasibility dual (sweep L1) [REPORTED 2026-07-10]

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

## C64. Completion-poset correlate of the arc-depleted dichotomy (sweep E3) — run beside C55 [REPORTED 2026-07-10 — NEGATIVE]

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

## C65. Pin down Z(23): steering-ceiling growth + extremal configurations (sweep E1) [REPORTED 2026-07-09]

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

## C66. Grid-terminal spectrum — complete caps under row/column capacities (sweep S2) [GATE DISCHARGED 2026-07-10 — opportunistic diagnostic, no priority]

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

## C67. Coupling-defect spectroscopy: δ = g ⊕ g_conic ⊕ g_zone (sweep Co1) [GATE DISCHARGED 2026-07-10 — opportunistic diagnostic, no priority]

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

## C68. The depletion-fraction extremal sequence D(q) (sweep E2) [REPORTED 2026-07-10 (Claude)]

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

## C69. Envelope invariants for the flipping configurations (sweep S1 — PROMOTED 2026-07-10) [REPORTED 2026-07-10 — NEGATIVE]

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
