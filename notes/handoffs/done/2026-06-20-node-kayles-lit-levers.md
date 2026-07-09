# Node-Kayles / queen-graph solver levers — lit-search backlog to review against current WIP

**Date**: 2026-06-20
**Created by**: 2026-06-20--2 (`550eb472-ae37-4850-bd88-9c0b7e155b10`)
**Purpose**: Capture a ChatGPT literature-search backlog of structural levers for the Queens n=16
solver (the game is **Node Kayles on the queen graph**), each annotated against our current WIP and
lever stack, so a future session can triage and pick the next big bet without re-deriving the map.

---

## ★ PROBE #1 RESULT — item A (modular/twin reduction) is a measured NEGATIVE (2026-06-20--11)

**Built + ran the decisive cheap probe** (`Queens::module_profile` in `graph.rs` + `module_report` in
`bin/queens.rs`, wired into `count --comps`; cold, monomorphised, zero production cost). For every distinct
working-set position it partitions the available-graph into **twin classes** (clique = closed-twin / true-twin
class; independent = open-twin / false-twin class), applies the nimber-preserving kernel (clique ≥3→1 rep,
indep ≥3→2 reps), and reports per-pc the fraction whose **`reduced_pc ≤ 12`** (lands in the paying W12 frontier).

**VERDICT: item A is dead in the tail.** Across **pc 13–20** (n=12 *and* n=14 working sets): **`reduces%` =
0.0% and `->≤12%` = 0.0%** — the modular kernel shrinks essentially **nothing**. Size-≥3 modules (the kind that
contract) are absent; even size-2 twin pairs (`has-mod%`) fall from ~15% (pc 9) to **2.3% (pc 13, n=12) / 3.8%
(pc 13, n=14)** to ~0% by pc 18. The queen subgraphs in the searched tail are **too sparse/irregular** to carry
the modules the kernel needs. The corrected `has-mod%` matches the validated `struct_profile` twin-pair% to the
decimal (cross-check), and the true-universal-vertex rate is ~0.2% at pc 9 / 0% by pc 11 — the universal-move
shortcut is dead too.

**Bug found + fixed mid-probe (rigor):** `attack[v]` **includes self** (`geom.rs`), so the first cut computed
`open[]` = *closed* neighbourhood and silently dropped every **independent** module (~11% undercount vs the
validated twin%). Fixed by stripping self (`and_not(single(v))`); re-ran — **`reduces%` stayed 0%** even with
independent modules correctly counted, so the verdict is robust, not an artifact of the bug.

**Implications for the rest of the backlog:**
- **A — dead** (this probe). Do not build the reduce-then-W12 evaluator.
- **B (full modular decomposition), D/E (partition-search / setrograde keyed on module patterns)** — **weakened**:
  if twin modules are this rare, general non-trivial modules / shared module-skeleton patterns are unlikely to be
  prevalent enough to key generalized-TT entries on. Not *directly* tested (the probe is twin-based), but the gate
  argues against the whole **structural-reduction cluster**.
- **Surviving levers all shrink/dedup the WORK without needing module structure:** the active **A'' sorted-frontier
  wave** (dedup by *exact* sorted signature — `QUEENS_WAVE`/M_WAVE already a measured win, 1m32s record), **getK
  throughput**, **MLP-batched probes**, and **grouped-frontier DDD by exact graph key**. These are orthogonal to
  this negative — point the next lever there, not at structural reduction.

The probe code stays in (cold `count --comps` path, gate-green: clippy `-D warnings` + fmt clean) as the documented
measurement. **Triage outcome: the lit-search "structural reduction" thesis does not survive contact with the
data; the work-shrink/dedup levers (A'' thread) are the bet.**

## Context

n=16 is SOLVED (second player). The fastest solver is **iso-dense (W12)**: ~90s wall, ~2.0 B nodes;
every pc≤12 node resolved from the dense W0..W8 tables, pc 13–21 searched via a flat lockless TT (DFS +
α-β, parity-aware root parallelism). The compute floor for this strategy class is ~45–60s (~2× over).
Established facts the levers below must respect:
- **The tail is ONE giant root = ~94% of wall**; cost is **co-dominant memory (~30% TT-probe latency) +
  frontend (~31% getK compute)**, retiring only ~14%.
- **The DFS-parallelization route is CLOSED with evidence** — ABDADA + frontier work-stealing both
  measured a structural negative; the tail is **transposition-saturated** (concurrent *search* re-does
  shared work). The lever is **not parallelization** — it's shrinking/de-duplicating the WORK.
- **Generic W13 is a wash at n=16** (still −15% nodes but the u128 `get13` per-node cost cancels it) —
  the W_K dense-table ladder **stopped paying at the W12→W13 step**. So "the next frontier layer" is dead;
  the open question is how else to attack pc 13–18.
- **iso-dense merges *equivalent* states** (graph-iso canonical key). It does **not** shrink a state
  before evaluating it — that distinction is the crux of the top idea below.

This backlog's thesis: the next real jump is **Node-Kayles-specific structural reduction of the
graph shape** (modular/twin reduction), not another dense layer and not parallelism.

## Scope

- **In scope:** triage these 8 ideas, run the measure-first probes, pick the next big lever.
- **Out of scope (already settled — do NOT re-open without new evidence):** generic W14/W15 dense layers
  (W13 wash); DFS work-stealing / ABDADA for the tail (measured negative, transposition-saturated);
  global df-pn (documented GHI pathology); naive "clear-TT-per-root" staging (loses cross-root reuse).
- **Validation gate (unchanged):** `solver_lineage_agrees` (n≤9 vs naive) + n=14 iso-flat `--distinct`
  ≈29.16M/1.02× + a fresh n=16 SECOND. Any nimber-preserving reduction must hold the verdict; measure
  node-count + **total cycles** (interleaved A/B — the box is ±18% node-noisy; single runs lie).

## Work Items (the 8 levers, ranked, each cross-referenced to current WIP)

### A. ★ Dynamic module / twin reduction (TOP candidate — exact, nimber-preserving)
- **Idea (Kobayashi, Node Kayles parameterized by neighborhood diversity / modular-width):** a *module*
  is a vertex set with identical outside-neighborhoods. **Clique module of size ≥3 → contract to 1
  representative; independent module of size ≥3 → reduce to 2 representatives**, both **preserving the
  nimber** (stronger than win/loss). Apply to each hot pc 13–20 state **before** handing it to iso-dense:
  a shape that reduces to ≤12 vertices then resolves in the **paying W12 frontier** instead of a flat-TT
  recurse.
- **Why it's the strongest lever:** it directly attacks the pc 13–18 region where W_K stopped paying, it
  is *exact* and *nimber-preserving* (gate-safe), and it is **orthogonal to iso-dense** — iso-dense merges
  *equal* shapes; this *shrinks* a shape pre-eval. If hot pc 13–16 shapes routinely carry size-≥3 modules,
  many fall into W12.
- **Cross-ref:** distinct from the parked **`queens-component-nimber` branch** (abf38ee, off main — dedup'd
  by cutoff-free component *nimber recursion* → −74% nodes but **6.6× wall**, the recursion was the cost
  killer). Module reduction is a **kernel (shrink), not a recursion** — it should not carry that cost.
  Also relates to roadmap **lever #8** (decomposition + small-component nimber DB). The cheap twin test =
  partition vertices by identical open/closed neighborhood signature (can reuse the WL/`comp_canon`
  machinery in `graph.rs`).
- **Done looks like:** a gated reduce-then-W12 path; measured node-count + total-cycle A/B at n=16.

### B. Modular decomposition on hot shapes ONLY (not global)
- Node Kayles is FPT by modular-width; full modular decomposition is linear-time. Don't run it everywhere
  — run it on the **2 dominant roots' high-reuse graph-shape families** as a specialized exact evaluator.
- **Cross-ref:** pairs with the **"characterize the tail by graph shape"** backlog (the TT-hit-by-graph-
  shape / state-ROI heat-map in the explicit-stack handoff). B is the *evaluator*; that profiling finds
  *which* families justify it.

### C. K-set DP as a targeted alternative enumeration basis (hot pc 13–18 only)
- Bodlaender–Kratsch–Timmer exact Node Kayles via **K-sets** (O(1.6031^n) general bound); Kobayashi
  summarizes the recursive nimber form. Not competitive globally, but for **repeated hot shapes** it
  changes the enumeration basis and may beat DFS+TT.
- **Cross-ref:** the W_K dense tables ARE specialized exact evaluators for pc≤12 (complete-table lookup).
  K-set DP is the analogous specialized evaluator for the pc 13–18 shapes W_K can't reach. Test offline
  (item J) before any integration.

### D. Setrograde / set-based analysis (possible "new era", high risk/reward)
- Setrograde generalizes retrograde analysis from *states* to **sets of states sharing a value** (in
  Bridge, orders-of-magnitude fewer ops). The analog here: prove a value for a whole **graph-shape
  family** at once, not each canonical graph.
- **Cross-ref:** our **graph-shape warmup** result (count --roots: ~2× cross-root reuse; centrality of
  hub shapes) "smells like a smaller version of the same phenomenon." This is the only thread that looks
  like a *new era* rather than a constant factor. Speculative; gate behind a prevalence measurement.

### E. Partition Search — generalized TT entries (Ginsberg)
- A TT entry that asserts **"every graph matching this module/twin/line pattern = LOSS/WIN"**, not just
  "this canonical graph = X". Predecessor of setrograde (item D).
- **Cross-ref:** our TT keys a *canonical* graph; this keys a *pattern*. Composes with the **BuRR
  value-only archive** (~1.1 bit/key under known membership) and with item A's module signatures (the
  pattern = a reduced module skeleton). Risky but potentially huge for high-centrality shapes.

### F. TDS — transposition-driven scheduling (Romein–Bal–Schaeffer–Plaat) — NEW angle on the closed route
- Put the TT at the **center of scheduling**: push a state to the worker that *owns its TT home / graph-
  family region / expected-reuse bucket*, not to whichever worker is idle. Reported large gains over
  classic work-stealing in graph-like search.
- **Cross-ref (important):** our **work-stealing route is CLOSED** — but it failed *because it pushed
  arbitrary subtrees to idle cores and re-did shared transpositions*. TDS is a **different axis**: route
  by TT-home so the worker that will reuse a transposition computes it → fewer duplicate expansions, the
  exact failure mode that killed work-stealing. The restart-sweep finding ("populate useful TT regions
  early beats balancing work units") already points this way. **This is the one parallelism idea not
  refuted by the work-stealing negative.** Worth a Fermi before building.

### G. PN/DFPN as a critical-root subsolver ONLY (span, not throughput)
- The 2 monster roots are an **unbalanced-proof** problem. The 2026 "Massively Parallel Proof-Number
  Search for Impartial Games" combines parallel PN with **Grundy-number reductions** and scales on
  unbalanced trees. A PN-style subsolver for *only* those roots might cut **span** even if it raises total
  work.
- **Cross-ref:** global df-pn is a **documented NEGATIVE** here (GHI / transposition pathology, roadmap
  fact #2) — so this is *strictly* a per-root subsolver, never the main solver. Pairs with the
  **"measure span, not work"** backlog item (reconstruct the giant root's critical path first).

### H. ZDD/ZSDD for hot subgraph families — OFFLINE discovery tool, not hot-path
- ZDDs compactly represent sparse set-families (Graphillion / frontier-based search). Too slow as a
  hot-path rep, but useful **offline** to discover high-value graph families / module patterns /
  candidate generalized-TT entries (feeds items A/D/E).

## Measure-first probe sequence (do BEFORE building any evaluator)

1. **Module prevalence (the decisive cheap probe).** On hot pc 13–20 states inside the 2 dominant roots,
   log: `pc`, #twin-classes, largest clique module, largest independent module, **`reduced_pc_after_kernel`**,
   future TT hits. **If many pc 13–16 hot states reduce to ≤12, item A is probably the next big win.**
   (Build as a cold `count`-style monomorphised pass, like `count --comps` — zero production cost.)
2. **Hot-shape module kernel** (item A) gated; reduce-then-W12; node + total-cycle A/B.
3. **Critical-root generalized warmup:** collect the first few M graph-shape fingerprints of each dominant
   root, reduce by module signature, rank by cross-root reuse; warm those families explicitly (vs the
   current time-based warm-restart).
4. **TT-driven work pushing** (item F): push by canonical graph-shape hash → high-reuse TT region.
5. **Offline evaluator microbench** on the top ~1000 hot canonical pc 13–18 shapes: current DFS/iso-dense
   vs module-kernel+W12 vs K-set DP vs PN/DFPN subsolver. Specialize only a family that wins.

## ChatGPT's effort estimate (their framing, for triage — verify, don't trust)

| lever | projected n=16 wall |
|-------|---------------------|
| scheduling / warmup alone (F + warmup) | ~90s → 60–70s |
| module reduction routinely into W12 (A) | ~90s → 45–60s |
| generalized-TT / set-based (D/E) works | ~90s → 30–45s |
| sub-30s | needs a true setrograde-style breakthrough |

**Strongest actionable bet per the search: item A (Node-Kayles modular reduction)** — exact, nimber-
preserving, graph-shape-based, and it attacks the W13/W14 region precisely where the W_K ladder stopped
paying.

## Codebase Reference

| What | Where |
|------|-------|
| iso-dense solver, W_K ladder, `wins_inc`, `block_k`, `iso_max_avail` | `rust/src/queens/solver/iso_flat.rs` |
| graph-iso canon / WL / `comp_canon` / tiny-component keys (twin-test substrate) | `rust/src/queens/graph.rs` |
| `count --comps` monomorphised cold probe (template for the prevalence probe) | `graph.rs` `iso_key_fast_in::<HIST,CACHE>`, bin `count` |
| dense W0..W12 tables (the reduce-target frontier) | `rust/src/queens/dense.rs` |
| BuRR value-only archive (for generalized-TT, item E) | `rust/src/burr.rs` |
| parked component-nimber DDD (item A's cautionary cousin) | branch `queens-component-nimber` (abf38ee, off main) |
| grouped-frontier DDD proposal (component-nimber framing) | `notes/proposal-2026-06-18-grouped-frontier-ddd.md` |
| current A'' wave thread (fused-M_WAVE ETC win; tail characterization backlog) | `notes/handoffs/2026-06-19-explicit-stack-frontier.md` |
| umbrella roadmap + lever backlog (#8 decomposition, etc.) | `notes/handoffs/2026-06-15-queens-memory-roadmap.md` |
| CGT references (OEIS A344227, Node Kayles) | auto-memory `queens-game-cgt-references` |

## Principles / Constraints

- **Measure-first, every time** (this thread's repeated lesson: work-stealing + nimber-cap were built
  before the decisive prevalence/cost probe). Run probe #1 before building item A.
- **Exact + nimber/verdict-preserving only** on any reduction; hold the validation gate.
- **Total cycles, interleaved A/B** is the metric (not cyc/node, not single runs).
- **One driver on the `queens` box at a time** (a sub-agent collision this session killed a live bench).
- Record findings in this file / the handoffs, never auto-memory.

## Delegation

- **Can delegate to sub-agent?** Probe #1 (prevalence measurement) and item J (offline evaluator
  microbench): yes. Item A integration + items D/E/F (architecture): keep on the main thread / decide
  scope with the user.
- **Model**: Opus for A/D/E/F design + the kernel; Sonnet fine for the cold prevalence probe + microbench
  harness.
- **Notes**: get the user's pick before building — these are multi-session bets, and several (D/E/F)
  reopen areas with prior negatives that only a *specific new angle* (not the old approach) is allowed to
  revisit.

## References (for the next session to pull)
- Kobayashi — Node Kayles parameterized by neighborhood diversity / modular-width (the module-reduction kernel).
- Bodlaender, Kratsch, Timmer — exact Node Kayles via K-sets (O(1.6031^n)).
- Ginsberg — Partition Search (Bridge; generalized/set TT entries).
- Setrograde analysis (Bridge; sets-of-states retrograde) — the set-based generalization.
- Romein, Bal, Schaeffer, Plaat — Transposition-Driven Scheduling (TDS).
- 2026 — "Massively Parallel Proof-Number Search for Impartial Games" (+ Grundy reductions).
- Graphillion / frontier-based search / ZDD (offline family discovery).
