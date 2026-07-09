# Parallelism choke-point analysis (Amdahl) — iso-window n=16

**Date**: 2026-06-18
**Solver**: `iso-window` (`IsoFlat::new_window`, `src/queens/solver/iso_flat.rs`), root-parallel over rayon.
**Anchor**: n=16 SECOND-player win, **2m44s (164 s) / 5.12 B nodes / ~31 M/s**, **20.9 of 24 perf-cores utilized (~87%)**.
PROPOSAL ONLY — no code changed.

> **Headline correction up front.** The old "n=16 ≈ 42 min, #20 wash" numbers are the **D4 `parallel`
> solver**, superseded. The live default is **iso-window at 2m44s**. The recoverable wall in this
> document is measured against **164 s**, and the absolute idle budget is therefore *small* — ~13% of
> 164 s × 24 cores ≈ a **~21 s-of-core-time** pool, which maps to **at most ~9 s of wall** if perfectly
> recovered (see the Fermi ceiling, §0). Everything below is ranked inside that ceiling.

---

## 0. The Amdahl frame (Channel-Fermi ceiling)

Wall = 164 s on 24 cores at ~87% utilization ⇒ **idle core-time ≈ 0.13 × 24 × 164 ≈ 511 core-seconds**.
That idle pool is the *entire* prize for any parallel-structure work. Converting idle core-seconds to
wall depends on whether the idle is **serial** (one core busy, 23 idle ⇒ recovering it can move wall a
lot) or **load-imbalance scatter** (many cores each idle a little near a join ⇒ recovering it moves wall
little, because the critical path is one straggler).

**Hard ceiling.** If a fraction `S` of the 164 s wall is a genuinely *serial* region (one core, 23
idle), then perfect parallelism of *everything else* caps the achievable wall at `S + (164−S)/24`. So:

| serial region S (wall) | best-case wall if rest is perfect | wall saved |
|------------------------|-----------------------------------|------------|
| 2 s                    | 2 + 162/24 ≈ 8.75 s               | (unreal — rest isn't perfect) |
| realistic: ~13% idle, mostly imbalance | floor ≈ 164 − 9 ≈ **155 s** | **≤ ~9 s (~5.5%)** |

**The 87% is not one fat serial tail — it is scatter.** The biggest single serial object (the elder
brother's *odd-ply* spine, §1) and the join scatter (§2) each cost a few wall-seconds, not tens.
**So the realistic prize is ~5–9 s of wall (~3–5.5%).** This is the same order as the segmented-TT and
branchless micro-opts already in flight (+3% / +12.5% M/s) — worth doing only if *cheap*, and the
thermal caveat (§7) can erase it. **Rank everything below against ~9 s, not against minutes.** The big
wall levers remain memory/representation and node-count (W8/W9, grouped-frontier), not core-feeding.

---

## 1. Choke point A — the elder-brother serial *prefix* + its odd-ply spine

**Where.** `iso_flat.rs:1311-1313`:
```rust
let (first, rest) = pending.split_first().unwrap();
let won = resolve(&first.0, first.1) || rest.par_iter().any(|(co, ckey)| resolve(co, *ckey));
```
`resolve` calls `par_wins_inc(...depth=1, min_avail)`. So **root move 0's whole subtree runs to
completion before the `par_iter` over the other 35 roots even starts.** Inside that subtree,
`par_wins_inc` (`iso_flat.rs:1103-1197`) fans *even* plies (`kids.par_iter().any`, line 1191) and keeps
*odd* plies sequential (`kids.iter().any`, line 1194) to preserve the α-β cutoff.

**Why it's serial / imbalanced (two distinct effects):**

1. **The `||` short-circuit serialises root-0 against the rest.** Because n=16 is a second-player win,
   `resolve(first)` returns `false`, and only *then* does `rest.par_iter()` spin up. During root-0's
   solve, the search *is* internally parallel (even-ply fan), so cores aren't fully idle — but the
   *first few plies of root-0* are a warmup where the even-fan hasn't widened yet and rayon has few
   tasks. This is a **ramp**, not a full stall: a handful of wall-seconds at the front.

2. **The odd-ply spine is the genuine serial thread.** At every *odd* (prove-a-win / OR) ply, the search
   is sequential by construction (line 1194) — it must try moves in α-β order and cut on the first win,
   and parallelising it speculatively re-introduces the ~97M-vs-53M-node blow-up that killed naive YBWC
   (roadmap fact #5). The critical path of root-0 (and of *every* root) therefore contains a chain of
   sequential OR nodes. The deepest such chain is the Amdahl-limiting path.

**Wall cost.** This is the largest *single* contributor to the idle 13%, but it is bounded: root-0 is
one of 36 roots and the `par_iter` over the other 35 overlaps with nothing only during root-0's solve.
Estimate the front-ramp + sequential-spine at **~3–6 s of the ~9 s recoverable**. (The roadmap's
"root-0 dominates / is the whole runtime" was the *single-core* failure mode pre-session-7; with
even-ply fan it no longer dominates wall — verify with a per-root timing histogram before over-crediting
it.)

**Fixes, in order of value/cost:**

- **A1 (cheapest, recommended first): start the `rest` fan concurrently with root-0, don't gate it
  behind `||`.** Replace the short-circuit with a single `par_iter` over **all 36** roots that returns
  `true` on the first first-player win:
  `pending.par_iter().any(|(co, ckey)| resolve(co, *ckey))`. This is exactly what removing the
  hand-rolled elder-brother prefix does. **Correctness:** `any` still short-circuits on a first-player
  win, so no α-β cutoff is lost at the root; for a second-player win *all* roots are refuted either way,
  so the node set is byte-identical. The only loss is the warm-TT ordering benefit (root-0 warms shared
  entries the others reuse) — but at n=16 the roots are nearly TT-disjoint at the top, so that benefit
  is small. **Risk:** on a *first-player-win* board (odd n is O(1); even-n first-player wins are the
  small boards) this speculatively searches losing root subtrees the `||` would skip — the same hazard
  `parallel.rs` guards against with its sequential elder lead (`parallel.rs:178-183`, the "~40× on
  13×13" warning). **So gate A1 to the prove-a-loss expectation:** only fan all roots when we expect a
  second-player win (n even and large); keep the elder-first guard for boards that might be
  first-player wins. Since n=16 *is* a second-player win, A1 is pure upside there.
  **Channel-Fermi:** recovers the front-ramp only (~1–3 s); the odd-ply spine is untouched.
  **Experiment:** n=14 interleaved A/B of the `||`-prefix vs all-roots-`par_iter` (node count must stay
  53.3M; wall delta is the prize). One-line change, ~30 min.

- **A2 (the real lever, higher cost): Young-Brothers-Wait *at the odd plies* — speculate the OR node's
  younger brothers only after the eldest is launched, and abort on cutoff.** The odd ply currently runs
  fully sequential. YBWC would search the *eldest* child first (the well-ordered move that usually
  cuts), and *only if it does not cut* fan the remaining siblings, cancelling them the instant one
  returns a win. **Correctness:** the eldest-first lead preserves the common-case cutoff (most OR nodes
  cut on move 0 in this well-ordered blocking game), so the speculation fires only on mis-ordered OR
  nodes — bounded waste, never a *wrong* verdict (the TT values are deterministic). This is the
  textbook YBWC that fact #5 says is *correct* when parity-gated; the current code simply doesn't apply
  it at odd plies because the even-ply fan was deemed enough. **Risk:** rayon has no built-in
  cancellation; `any` short-circuits the *iterator* but in-flight spawned tasks keep running until they
  check. Wasted-work bound = the cost of the siblings launched before the eldest's cutoff lands. On a
  power-limited box (§7) this speculation *also* costs energy that slows the useful cores. **Verdict:**
  promising but **must be measured against the ~9 s ceiling** — if it recovers 2–3 s of spine but burns
  thermal headroom, it can be net-neutral. **Experiment:** prototype YBWC-at-odd behind
  `QUEENS_YBWC_ODD=1`, n=14 interleaved A/B (watch node count for speculation blow-up *and* M/s for
  thermal drag). ~half a day.

---

## 2. Choke point B — the `par_iter().any()` join barrier (load imbalance at the tail)

**Where.** Every `kids.par_iter().any(recurse)` (`iso_flat.rs:1191`) and the root `rest.par_iter().any`
(`iso_flat.rs:1313`). `any` is a **join**: it does not return until either some child wins or *all*
children finish. For a prove-a-loss node (the n=16 common case) **no child wins**, so the join waits for
the **slowest child** — the straggler.

**Why it's imbalanced.** Children of an even node have wildly different subtree sizes (a queen placement
can leave a fragmented small graph or a dense large one). Below `par_depth` (=3) each child becomes an
*atomic sequential task* (drops into `wins_inc`), unless `par_min_avail` (=96 for n≥15) keeps it
splitting. So near the end of each parallel region the cores drain to the few holding big stragglers,
then to one. This is **the classic source of the 13% idle** — it is *scatter* (many small idle gaps at
many joins), not one fat serial region, which is why it is hard to convert to wall.

**Wall cost.** This is most of the *remaining* idle after §1 — but because it is scatter across the
whole tree, recovering it moves wall only by the **reduction in the worst-straggler critical path at
each join**, not by the total idle. Estimate **~3–5 s** of the ~9 s, and only if straggler-splitting
gets *finer* than `par_min_avail=96` currently allows.

**This is exactly what `#20` (the size-split) targets, and it measured a WASH at n=16** — but **that
measurement was on the D4 `parallel` solver at 42 min, not iso-window at 2m44s.** The iso-window tree is
~250× shorter in wall and has a *different* node-size distribution (W8 collapses pc==8 subtrees, so the
straggler shape changed). **The #20 wash is NOT settled for iso-window.** Re-measuring it is the single
cheapest high-information experiment in this document.

**Fixes:**

- **B1 (cheapest, recommended — re-validate, don't re-propose): sweep `QUEENS_PAR_MIN_AVAIL` and
  `QUEENS_PAR_DEPTH` on iso-window at n=16.** The auto default is `min_avail=96`, `par_depth=3`. Lower
  `min_avail` (e.g. 64, 48) makes big deep prove-a-loss nodes keep splitting longer ⇒ finer steal
  granularity ⇒ the tail drains slower to one core. Higher `par_depth` (4, 5) exposes more top-level
  fan. Both are **pure env knobs already wired** (`mod.rs:199-228`), **zero code**, **zero correctness
  risk** (parity-gated even-only ⇒ no speculation, node count invariant). **Channel-Fermi:** caps at the
  scatter pool (~3–5 s). **Experiment:** one interleaved A/B matrix `{par_depth∈3,4,5} ×
  {min_avail∈48,64,96,128}` at n=16 (or a partial-throughput proxy at n=16 if a full 2m44s × 12 cells is
  too long — use warm M/s + tail-core-occupancy from `perf stat -I`). **Do this first.**

- **B2 (structural): convert the worst stragglers from atomic tasks into recursively-split tasks by
  *measured* subtree size, not the `avail`-popcount proxy.** `par_min_avail` uses available-popcount as
  a cheap size proxy (`mod.rs:209-215`), but popcount is a *weak* predictor of subtree cost once W8/iso
  collapse kicks in (a pc=40 node whose children are all ≤8 is cheap; a pc=40 node with a big dense
  component is huge). A better proxy: **number of large (`> iso_max_avail`) connected components** — the
  part that *won't* collapse into W8/tiny. **Correctness:** still even-ply-only ⇒ zero speculation,
  node set invariant. **Cost:** a component-count is already computable (`graph.rs:1350 component`), but
  calling it per split node adds work to the *shallow* split path (few nodes, acceptable). **Risk:** if
  the proxy is no better than popcount, this is the #20 wash again. **Experiment:** first just *measure*
  the straggler distribution — instrument the split path to log per-task wall and `avail`-popcount on an
  n=16 run; if the longest tasks correlate poorly with popcount, B2 has headroom; if well, drop it.

---

## 3. Choke point C — the shared atomic TT (contention model — already solved, verify only)

**Where.** `tt.rs:53-73` — one flat `Box<[AtomicU64]>`, lockless, `Relaxed` load/store. Per-node tally
is **thread-local** (`tt.rs:22-31 Acc`, `bump_local` at `tt.rs:562`, flushed every `FLUSH_NODES = 2^18`
nodes, `tt.rs:16`). HLL/oracle/hist accumulators are likewise thread-local with broadcast drains
(`iso_flat.rs:631,660`; `tt.rs:598`).

**Why it is NOT a choke point (and the evidence).** The lockless atomic TT was specifically built to
remove the mutex cache-line bounce (`tt.rs:44-52`), and the cross-CCX `nodes` counter was specifically
batched out (memory note `queens-bench-from-tmpfs-not-zfs`: thread-local `Acc` + ~1/s flush landed in
`49bba47`). **So per-node there is zero shared atomic.** The only shared writes per node are the TT
`put` (`Relaxed` store) and `get` (`Relaxed` load) — and a TT slot write for a key is deterministic
(same key ⇒ same value), so concurrent same-slot writes are correctness-safe and the *traffic* is just
DRAM bandwidth, not coherence ping-pong (different keys ⇒ different slots, no false-sharing beyond the
random 8-byte slot landing in a shared 64-byte line ~8-way).

**Residual risk to verify, not assume.** The 8-byte slot means **8 slots share a 64-byte cache line.**
Under the segmented-TT variant (`index_seg`, `tt.rs:433`) the whole DFS working set at a depth shares a
*band*, so concurrent workers at the same depth may now contend on the *same band's* lines more than the
flat table did. **This is a NEW false-sharing surface the segmented variant introduces** and is worth a
`perf c2c` check during the seg A/B. **No fix proposed** — flagging that the seg change has a contention
dimension the flat control doesn't, so the seg A/B should watch HITM, not just M/s.

**Channel-Fermi.** TT contention contributes ~0 to the idle 13% on the flat control (already removed).
**Do not spend effort here on the flat path.** The one actionable item is *measurement hygiene* on the
seg variant.

---

## 4. Choke point D — `distinct_first_moves` + `pending` build (serial prologue)

**Where.** `iso_flat.rs:1279-1289`. `q.distinct_first_moves()` (`geom.rs:199-208`) runs a **sequential**
`HashSet` dedup over all board squares (calling `pos_key` per square), then the `for &sq in &moves` loop
builds the 36 `(orient, key)` pending pairs single-threaded.

**Why it's serial.** It's a prologue before any `par_iter`. It does `O(n²)` `pos_key` (full
canonicalisation) calls plus 36 `node_key` builds.

**Wall cost.** Negligible — `O(n²)=256` canon calls + 36 child-orient/key builds is **microseconds to
low-milliseconds** against 164 s. **Not worth parallelising.** Listed for completeness so it is not
mistaken for a lever. (At n=18+ revisit only if the root fan-out grows; still tiny.)

**Channel-Fermi.** S ≈ 0.001 s ⇒ irrelevant. **No fix.**

---

## 5. Choke point E — the W8/tiny band: pure-L1 serial *within* a task, but that's the point

**Where.** `enter_graph`/`solve_local` (`iso_flat.rs:984-1031`) and `w8_get` (`iso_flat.rs:300`). When a
node drops to pc≤8 the whole subtree is solved **sequentially in a thread-private 128-byte stack memo**
(`solve_local`, no TT, no DRAM, pure L1) or **one W8 indexed bit load** (`w8_get`).

**Why it's serial — and why that's correct, not a bug.** These are *leaf* computations inside a single
worker's task. They are deliberately off the parallel/memory path (the comment at `iso_flat.rs:979-983`
is explicit: "thread-private … pure L1, no cross-CCX coherence"). Parallelising a ≤256-node L1 DP would
be pure overhead (task-spawn cost ≫ the work). **This is the right design** — flagged only so it is not
mis-read as a serial choke point. The W8 *collapse* is also why the iso-window straggler distribution
differs from the D4 `parallel` solver (§2), which is the reason #20 must be re-measured.

**Channel-Fermi.** S ≈ 0 (these are the cheapest nodes). **No fix.**

---

## 6. Choke point F — rayon pool sizing under affinity (24 vs 23 usable)

**Where.** `affinity.rs:49-74`. Under `auto` at n≥16 on this heterogeneous box, the search pool is pinned
**1:1 across all 24 logicals (8 perf {0-3,12-15} + 16 efficiency {4-11,16-23})**, perf-first. Note the
comment at `affinity.rs:39-43`: the 1:1 pin **regressed n=14 ~5%** (the spiky search wants scheduler
freedom), so it's gated to n≥16.

**Why it can hurt parallelism.** Two effects:
1. **The efficiency cores (Zen5c ~3.29 GHz) are ~36% slower than perf (Zen5 ~5.16 GHz).** A task pinned
   1:1 to an efficiency core is a *slower* worker ⇒ it produces the stragglers §2 worries about. The
   even-ply fan hands children round-robin without regard to which core is fast, so a big child can land
   on a slow core and become the join's critical path.
2. **Drain broadcasts** (`tt.rs:598 drain_all`, `iso_flat.rs:631,660`) use `rayon::broadcast` — a global
   barrier across all 24 workers at search end. One-time, negligible.

**Wall cost.** Effect 1 is real but folded into the §2 straggler cost — it's *why* some stragglers are
slow. Bounded by the ~3–5 s scatter pool.

**Fixes:**

- **F1: bias big stragglers onto perf cores.** Rayon's work-stealing already migrates toward idle cores,
  but with 1:1 pinning a task can't migrate off its pinned core. **Consider NOT pinning 1:1 at n=16** —
  test `QUEENS_AFFINITY=off` (scheduler-free, the n=14-winning config) vs the current 1:1 pin on a
  **clean** n=16 box. The affinity note says the 1:1 win at n=16 is **UNMEASURED** (memory
  `queens-affinity-reuse-sessions`: "n=16 benefit UNMEASURED"). So this is an **open, untested**
  question, not a settled win. **Experiment:** n=16 A/B `QUEENS_AFFINITY=off` vs `auto` — one env flip,
  the cheapest core-feeding experiment after B1. **Risk:** scheduler migration on this
  migration-sensitive box could regress; that's why it must be measured, not assumed.
- **F2 (do not pursue lightly): size-aware task placement** — route the largest split children to the
  perf cores explicitly. High complexity, fights rayon's stealer, and the thermal caveat (§7) says
  loading perf cores harder may just throttle them. Low priority.

**Channel-Fermi.** F1 caps at the slow-core contribution to the scatter pool (~1–3 s) but is a **single
env flip** — high value/cost *if* it wins. **Measure it.**

---

## 7. The thermal / power caveat (weigh against every speculation lever)

The box is **power/thermal-limited**: all-core ~3.7 GHz vs single-core 5.16 GHz boost, benches run at
the ~90 °C 24-core throttle (memory `queens-benches-thermal-wall`). **Consequence for parallelism:** a
serial single-core region runs *faster per node* (5.16 GHz) but starves 23 cores; conversely, adding
*speculative* parallel work (A2 YBWC-at-odd, F2) loads more cores ⇒ pushes deeper into the throttle ⇒
**every useful core slows down**. So a speculation lever that recovers 2 s of idle by burning 24 cores
hotter can be **net-neutral or net-negative** on wall. This is why:
- **Non-speculative levers (A1, B1, F1) are strictly preferred** — they re-feed idle cores without
  adding work, so no extra heat.
- **Speculative levers (A2) must be measured on M/s AND temperature/throttle, not just node count.** A
  node-count-neutral speculation can still lose if it throttles.
- Rank levers by **energy/useful-work**, not raw parallelism (the memory note's standing guidance).

---

## Ranked summary (wall recoverable ÷ cost), all inside the ~9 s ceiling

| # | Lever | Where | Recoverable (wall) | Cost | Risk | Correctness |
|---|-------|-------|--------------------|------|------|-------------|
| 1 | **B1: sweep `PAR_MIN_AVAIL` / `PAR_DEPTH` on iso-window n=16** (the #20 wash is NOT settled for iso-window — it was the D4 solver) | `mod.rs:199-228` (env only) | ~3–5 s | **trivial** (env matrix) | none | parity-gated, node-invariant ✓ |
| 2 | **F1: A/B `QUEENS_AFFINITY=off` vs `auto` at n=16** (1:1-pin win is UNMEASURED) | `affinity.rs:49` (env flip) | ~1–3 s | **trivial** (one flag) | migration regression on this box | no node change ✓ |
| 3 | **A1: fan all 36 roots concurrently** (drop the `\|\|` elder prefix), gated to expected-second-player-win boards | `iso_flat.rs:1311-1313` | ~1–3 s | low (small diff) | speculation on first-player-win boards ⇒ keep elder guard there | `any` keeps root cutoff; second-player node set identical ✓ |
| 4 | **A2: YBWC at the odd (OR) plies** — eldest-first, fan siblings, abort on cutoff | `iso_flat.rs:1194` | ~2–3 s (spine) | **high** (cancellation, prototype) | thermal drag + speculation blow-up | eldest-first preserves α-β cutoff; bounded waste, never wrong ✓ |
| 5 | **B2: size-split stragglers by large-component count, not popcount** | `iso_flat.rs:1121`, `graph.rs:1350` | ~2–4 s (if proxy beats popcount) | med (per-split component count) | may reduce to the #20 wash | even-only, node-invariant ✓ |
| — | **C: TT contention** | `tt.rs:53` | ~0 (already removed) | — | — | only *measure* seg's new band false-sharing (`perf c2c`) |
| — | **D: serial root prologue** | `iso_flat.rs:1279` | ~0 (µs) | — | — | not worth touching |
| — | **E: W8/tiny L1 leaf solve** | `iso_flat.rs:984` | ~0 (by design) | — | — | correctly serial |

**Already measured-negative — DO NOT re-propose** (roadmap fact #5, sessions 3/7/8):
- **Naive deep YBWC** (parallelise *every* level, elder-first, no parity gate): defeats α-β, ~97M vs
  ~53M nodes at n=14, ~40× regression on 13×13 first-player wins. The parity gate is the *only* sound
  form. (A2 above is the *parity-respecting* YBWC restricted to OR plies with eldest-first cutoff — a
  different, sound lever; not the naive form.)
- **df-pn / proof-number search** (`pn` solver): transposition/GHI pathology, loses past n=8. Needs
  DAG-aware proof numbers to compete; documented negative.
- **Naive-prefetch-windowing**: documented negative (handoffs).
- **#20 size-split AS MEASURED on the D4 `parallel` solver**: wash at 42 min. **But that solver/regime
  is superseded** — B1 above re-opens it *specifically because* iso-window's W8-collapsed straggler
  shape is different and the prior wash does not transfer.
- **History/killer move ordering** (roadmap #6/#6b): node-count negative, reverses under parallel.

---

## Recommended sequence (cheapest, highest-information first)

1. **B1 + F1 together** — one interleaved-A/B session at n=16: the `{par_depth × min_avail}` matrix
   *crossed with* `QUEENS_AFFINITY={auto,off}`. Pure env, zero code, zero correctness risk, and it
   answers "is the #20/affinity wash real for iso-window?" — the load-bearing unknown. Use warm M/s +
   tail-core-occupancy (`perf stat -I 1000`) as the metric, not just wall (the ±18% node-count noise
   hides small wall deltas; M/s is the discriminator, per the handoff's methodology finding).
2. **A1** — if B1/F1 leave a measurable front-ramp, the all-roots fan is a tiny diff. Gate to even-n.
3. **A2** — only if 1–2 leave spine idle *and* the thermal headroom exists (check throttle during the
   A/B). Prototype behind an env flag; kill it if node count inflates or temperature climbs without a
   wall win.

**Bottom line.** The parallel structure is already good (parity-aware fan, lockless TT, thread-local
tallies, #20 + affinity in place). The 13% idle is **mostly load-imbalance scatter**, whose Amdahl prize
is **~5–9 s of a 164 s wall (~3–5.5%)** — the same order as the segmented/branchless micro-opts. The
*cheapest* real action is to **re-validate the #20 and affinity washes on iso-window** (they were
measured on the superseded D4 solver), because if either is no longer a wash it is free wall. The big
wall still lives in memory/representation and node-count (W8/W9, grouped-frontier), not in core-feeding —
and the power-limited box means any *speculative* parallelism must clear a thermal bar before it counts.
