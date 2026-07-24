# C80 — gadget-Node-Kayles route (cold-start execution guide)

**Lane:** `cap`. **Owner spine:** C80. **Successor task:** **C528** (reserved 2026-07-23, `[cap]`).
Planning doc, not a state map — the live map is the [cap handoff](handoffs/2026-07-06-projective-cap-game-handoff.md).

## Closure (C528, 2026-07-23)

This route is closed. Exact continuation of all frozen q17/q19 `capOVER` cores
shows remaining game height at most five, so the general SG-height theorem
already explains the observed `SG≤5`; no Dawson/gadget calculus is evidenced
or needed for that finite signal. The q17 near-height/parity refinement fails
at q19, and the cheapest local defect signature is value-impure. Return to
C80's direct uniform depth-2 routing theorem into `Y_NK`. Final report:
[`2026-07-23-c528-mex-skeleton-probe.md`](2026-07-23-c528-mex-skeleton-probe.md).

## For the cold agent — read first

Read, in order: the cap handoff bullets "Companion guard BUILT (C523)" and "q17 descent CLOSED
(C524)"; the `Y_NK` proof [`2026-07-23-c523-ynk-guard-proof.md`]; the Fable review
[`2026-07-23-c80-descent-fable-review.md`]; then the C523/C524 reports. This guide productionizes the
Fable review's §3–§4 into steps.

## State (settled — do not re-derive)

- **`Y_NK` guard PROVEN and reviewed correct.** `capOK(S)` (every capacity-two line — a line missing
  `{a,b}∪S` — carries ≤2 legal points) ⟹ the residual game from `S` is *static* Node-Kayles on the
  full legal-point conflict graph `G_S`, so `value=P ⟺ Grundy(G_S)=0`. Proof:
  [`2026-07-23-c523-ynk-guard-proof.md`] (three lemmas: move = vertex deletion; `capOK` ⟹ no new
  edges; `capOK` persists). Fable verified the lemmas and the engine conventions in code. Uses no
  `q`-oddness (holds for even `q` too). Lean formalization is pending but the proof is elementary.
- **Depth-2 routing is a CONJECTURE**, verified at q=13/17/19 only (0 uncertified; C524). The residual
  `capOVER` fraction **grows** (0% → 0.7% → 4.2%), so depth-2 may be small-`q` luck — do not assume it
  is uniform.
- **The Φ-potential plan (original Route 1) is DEAD.** Φ = total capacity-two overload is monotone
  non-increasing under *every* move by either player (free from the persistence lemma), so "responder
  drives Φ→0" is vacuous. Do not revive a Lyapunov framing.

## Reshaped route (2026-07-23, after Step 1 + pairing probe)

Step 1 killed the bounded-gadget induction (g,k both unbounded in q). The pairing probe
(`c528_pairing_probe.py`, report § Pairing) showed the depth-2 responder win **is a literal copycat
involution** on the even-`|O|` q17 core (132/132) — but the **q19 scale-test broke the clean law**
(1,104 even-`|O|` witnesses with no single-level first-witness perfect matching). So the pairing
route is *not* the cheap two-line win it looked like at q17; it survives only with a
**witness-selection or multi-level (persistent) copycat** argument, plus odd-`|O|`
pairing-plus-one-free-move. It still makes the gadget count irrelevant and is cleaner than the
gadget Grundy calculus (retained as fallback), but both routes now need real work.

**Witness-selection RESOLVED — NO (2026-07-23, `c528_alt_witness_probe.py`).** The de-risking probe
ran: searching *every* legal responder move for each of the 1,104 q19 failures under the correct
**legal-reply** pairing graph, only **380/1,104 (34%)** are restored by an alternative depth-2
witness; **724 (66%) have no matchable witness**. Single-level copycat is genuinely insufficient at
q19 even with free witness choice, so the **witness-selection lemma is dead** — the pairing route
now needs a **multi-level (persistent) copycat** (track the copycat across the ≥2 plies) plus
odd-`|O|` handling, and is no longer demonstrably cleaner than the multi-gadget Grundy calculus.
Correctness note: `is_ynk = capOK∧Grundy0` accepts non-cap masks, so the pairing probe's
`is_ynk`-only `H` over-counts via illegal-reply edges (reads a spurious "1,104 restored"); use the
legal-reply `H`. Report+cert: [`2026-07-23-c528-alt-witness-probe.md`].

**Grundy-by-conic-type census RUN — bounded full value, conic-type shortcut NO (2026-07-23).**
The full hypergraph residual, not isolated gadgets, has exact SG≤5 on every frozen q17/q19
capOVER-core child: q17 values 1–5; q19 values `{1,2,4,5}` despite `g=3..47`, `k≤7`, and 14–37
legal points (the two `g=47` states have SG 2). This is the strongest evidence yet that unbounded
static gadget complexity hides a bounded defect value. But external gadgets do not cancel
contextually: deleting all external constraints changes q19 SG in 31,871/48,074 states containing
them and flips N→P in 8,771; secant/tangent counts also grow (max 22/7 per q19 state). So the live
route is Piece 3's whole-residual Dawson/path-cycle decomposition, not a conic-type sum law.
Report+certificate: [`2026-07-23-c528-grundy-conic-census.md`].

## Target (Piece 2): the gadget-Node-Kayles value law

Model `capOVER` states as `NK⁺(G, gadgets)` = Node-Kayles on `G_S` plus one **gadget** per overloaded
capacity-two line. A gadget is a `k`-set (`k≥3`) of legal points on one line that are **pairwise
non-adjacent** in `G_S` and **collapse to a clique on the survivors the instant any one is played**
(the played point becomes a selected point on the line, so any later pair on that line is a forbidden
triple). Prove a value law for `NK⁺` by induction on the lexicographic measure `(Φ, |L|)`, well-founded
because Φ never increases and `|L|` strictly decreases each move.

- **Base case Φ=0:** `NK⁺ = NK` = the proven `Y_NK` theorem.
- **~~First real case: `g=1, k∈{3,4}`~~ — REFUTED by Step 1 (2026-07-23).** `g=1` never occurs at
  q19 (100% `g≥3`, mean 19.2, max 47), and `k` reaches 7. There is **no finite bounded-gadget base
  family** to induct into — both `g` and `k` grow with `q`. The `(Φ,|L|)` measure is still
  well-founded, but any induction step must handle **arbitrary `g` with interacting gadgets** (32% of
  gadget pairs share a vertex), not a single small gadget. Depth-2 is therefore **not** explained by a
  small gadget count (it closes 100% at q13/17/19 despite ~19 gadgets/state) — reframing the real
  question as: *why does a bounded-depth responder strategy beat unbounded static gadget complexity?*
  A pairing/response (copycat/mirror) attack that makes the gadget count irrelevant may be a cleaner
  route than a multi-gadget Grundy calculus — see the C528 report Mystery ledger.

## Steps, cheap-first

1. **[DECISIVE — RUN 2026-07-23, BRANCH (b)] q13/q17/q19 overload-profile tabulation.** Done:
   `rust/scripts/c528_overload_profile.py` + `notes/2026-07-23-c528-overload-profile.json` (`--check`
   PASS); report `notes/2026-07-23-c528-overload-profile.md`. **Result: branch (b), sharpened —
   gadget complexity is unbounded in `q` on both axes.** q17: 349 residual, `g∈1..7` (258/349 have
   `g≥2`), `max k=4`. q19: 48,084 residual, **100% `g≥3`** (mean 19.2, **max g=47**), **max k=7**
   (8,189 states with `k≥5`). Both `g` and `k` grow with `q`. The `g=1, k≤4` special-case premise
   below is **dead** — see the correction. Gadget pairs at q19: 68% disjoint, 32% share exactly one
   legal vertex (forced — two projective lines meet in one point). Overloaded-line conic type: mostly
   external, some secant, few tangent — no single-type law (§4.5 handle fails).
   **Correction to the premise:** the "`g=1` covers ~93%" claim conflated two measures. C523's
   "323/349 at minimal overload 3" is about the overload **magnitude** `k` (small), not the **number**
   of gadgets `g` (not 1). Only 26% of q17 (0% of q19) residual children are single-gadget.
2. **[DONE 2026-07-23] (ON) alignment check.** Settled (C528 report § Step 2): the C80(b)/C524
   descent proves root-P via off-conic replies (C522: 63% intruder-only), so it certifies the escape
   condition, **not** the strict on-conic (ON). C82 counts "the exact packet C80 produces" =
   off-conic-inclusive, so it tolerates off-conic and there is **no alignment gap**. (ON) is a
   separate, stronger, possibly-false-as-written sharpening **off the descent's critical path** — do
   not claim it as proven or gate C82 on it. Original text follows for context:
   (ON) as written (alt-attack plan, cap handoff § Conic
   Localization) wants a P-valued **on-conic** size-4 child, but C522 found 63% of gap children win
   only via **off-conic** replies. The two-tier certificate proves the responder wins (C80(b) descent),
   but confirm the equivalence C82 will consume tolerates off-conic replies before C82 counts. If (ON)
   is strictly on-conic, state the descent as a distinct (weaker-in-form) responder-win theorem and
   re-derive the (ON) link.
3. **Prove the gadget law** for the branch step 1 selects. Consider a literature pass first
   (arc-Kayles, octal games, Huggan–Nowakowski changing-rule games, "Node-Kayles hypergraph") per
   `notes/literature-audit-conventions.md` if a novelty claim will be made — the gadget game may exist.
4. **[Piece 3] Uniform Grundy formula via octal/Dawson periodicity.** `Grundy(G_S)=0` must be decidable
   uniformly in `q`. The engine already carries `spectrum`/`dawson_xor`; empty-conic zone graphs
   decompose into paths/cycles (Dawson-type octal, eventually-periodic Grundy). Cheap check:
   component-type census (max degree, path/cycle/other fraction) of the `capOK` graphs `G_S` over q17/q19
   `capOK` reply states. If "other" is rare/bounded, the crown shape is: gadget law (Piece 2) + octal
   periodicity (Piece 3) + finitely many sporadic components.
5. **Symmetry reduction.** The 349 q17 (and 48,084 q19) residuals collapse to few `Stab(frame)≤PGL(3,q)`
   orbits — take the quotient before any base-case certificate or Lean finite check (Fable estimates
   10–50× cost cut). C523 has the on-conic full-PGL bridge machinery to reuse.
6. **[out-of-sample] q23 stress test.** Only after step 1/3 selects a law. Needs the C20 P-reply-state
   census at q=23, which is **not frozen** — generate it (grid solver / `s4arena`; q23 is the
   computed-but-not-fully-Lean-certified order, see the status table) before running the depth/gadget
   test. This is the first genuinely out-of-sample check.
7. **Lean:** formalize the `Y_NK` proof (elementary; target the mex/P-position fact, not S–G sums) when
   convenient — it does not block Piece 2.

## Geometric handle worth one look (Fable §4.5)

A capacity-two line is secant / tangent / external to the live conic in a `q`-odd-specific pattern. If
overloaded lines are always external (or always secant), that pins the gadget census and would explain
the residual-fraction growth (external-line count ~ `q²/2`). Test during step 1.

## What NOT to do

- Do not revive the Φ / amortized-potential Lyapunov plan (dead — see State).
- Do not treat depth-2 as proven or uniform; it is a three-prime conjecture.
- Do not over-invest in Lean before Piece 2; the crown blocks on the gadget law, not formal assurance.
- Do not restart the static-character routes (C496 closed both) or the empty-conic-only guard framing
  (`capOK` vs `capOVER` is the real boundary, not empty vs live).
