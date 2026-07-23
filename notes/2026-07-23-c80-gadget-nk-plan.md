# C80 — gadget-Node-Kayles route (cold-start execution guide)

**Lane:** `cap`. **Owner spine:** C80. **Successor task:** **C528** (reserved 2026-07-23, `[cap]`).
Planning doc, not a state map — the live map is the [cap handoff](handoffs/2026-07-06-projective-cap-game-handoff.md).

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

## Target (Piece 2): the gadget-Node-Kayles value law

Model `capOVER` states as `NK⁺(G, gadgets)` = Node-Kayles on `G_S` plus one **gadget** per overloaded
capacity-two line. A gadget is a `k`-set (`k≥3`) of legal points on one line that are **pairwise
non-adjacent** in `G_S` and **collapse to a clique on the survivors the instant any one is played**
(the played point becomes a selected point on the line, so any later pair on that line is a forbidden
triple). Prove a value law for `NK⁺` by induction on the lexicographic measure `(Φ, |L|)`, well-founded
because Φ never increases and `|L|` strictly decreases each move.

- **Base case Φ=0:** `NK⁺ = NK` = the proven `Y_NK` theorem.
- **First real case:** `g=1, k∈{3,4}` (covers ~93% + rest of the observed q17 residual). Compute
  `Grundy⁺` of a one-gadget position in terms of the Grundy values of its `k+1` resolutions (play one
  of the `k` gadget points → capOK-ish resolved state; play off-gadget → gadget survives on the
  remaining points, dissolving to a non-edge pair once `≤2` remain — note a 2-survivor gadget is NOT an
  edge). **Depth-2 then falls out as a corollary** (resolving a single size-3 gadget takes ≤2 plies),
  rather than being the theorem — strictly cleaner and `q`-robust.

## Steps, cheap-first

1. **[DECISIVE, DO FIRST] q19 overload-profile tabulation.** One pass over the **already-frozen** q19
   census (`notes/data/c20-q19-states.jsonl.gz`) over the 48,084 residual children and their depth-2
   witness states: number of overloaded capacity-two lines (`g`), multiset of overloads (`k`), and
   pairwise line intersections. Reuse `CENSUS.maximum_capacity_two_line` / `projective_lines` from
   `rust/scripts/c80_response_fibre_census.py`, generalized to return the full profile per state; find
   residual children exactly as `c524_capover_core_depth2.py` does. **Branch:** (a) all `g=1, k≤4` →
   prove exactly the `g=1` gadget law; (b) any `g≥2` or `k≥5` → depth-2 was small-`q` luck, the general
   gadget induction is mandatory. Reserve/report under C528.
2. **[2-min] (ON) alignment check.** (ON) as written (alt-attack plan, cap handoff § Conic
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
