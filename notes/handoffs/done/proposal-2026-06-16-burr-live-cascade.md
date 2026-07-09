# Proposal: `cascade` — BuRR as a live TT tier for n=16

## Status

Draft

## Problem

n=16 is solved, but the binding wall is now **TT capacity**, not per-node compute. The
PGO `incremental` run:

| metric | value |
|--------|------:|
| nodes searched | 10.756 B |
| distinct | 7.911 B (HLL ±0.4%) |
| re-expansion | 1.36× (26.4% of expansions recomputed) |
| TT | 2³¹ slots = 17.18 GB, 97.6% full |
| throughput | peaks ~14 M/s, decays to ~6.12 M/s (avg) as the table saturates |
| search wall | 29m17s |

The 2³¹-slot TT physically holds **2.147 B** keys = **27%** of the 7.911 B distinct set,
so 26.4% of expansions are pure capacity thrash, and a saturated table also drags the
probe rate from ~14 M/s down to ~6 M/s. On a **26 GB box** the table can't grow: 2³²
slots ≈ 34 GB spills into the 13 GB `/dev/zram0` (compressed RAM), where random probes
pay a per-access decompress and the search crawls. **More capacity has to come from a
denser store, not more slots.**

`burr.rs` is that denser store: a BuRR archive holds a solved set at **~6.8 bits/key**
versus the TT's fat **64-bit** self-describing slot — ~3.7× more keys in ~2.5× less RAM.
But today `Archive` is **static** (build-once from a slice, no insert) and is only wired
as a *freeze-at-end* artifact (`freeze` / `verify-archive`), usable for resume-as-query.

**The ask: make BuRR serve queries _live_ during the search**, as a transposition-table
tier, so the eviction-free working set becomes `{small mutable TT} ∪ {BuRR tiers} ≈ the
whole distinct set` and the 1.36× re-expansion collapses toward 1.0×.

## Context

What already exists (grounding the design — nothing here is greenfield):

- **`burr.rs`** — `Ribbon` (one GF(2) ribbon layer, ~1.0–1.1·r bits/key), `Archive` (a
  bumping cascade of ribbons storing `val_bits` value + `fp_bits` fingerprint per key,
  `get → Option<u64>`), `ShardedArchive` (key-partitioned, bounded-RAM build for billions
  of keys). Validated on real n=14 + iso-keyed n=14.
- **The fingerprint model is the correctness crux.** A bare ribbon returns *garbage* for
  a non-member; `Archive` stores `fp_bits` of fingerprint and accepts a layer's answer
  only on a fingerprint match, so a non-member is wrongly accepted (returns a *wrong
  value*) at `~layers · 2^-fp_bits` **per out-of-set probe** (`burr.rs:287-300`). A live
  win/loss search makes **billions** of out-of-set probes, so `fp_bits` must be sized so
  the *expected FP count over the whole run* ≪ 1.
- **`freeze` already defaults to `fp_bits = 44`** (`bin/queens.rs:234`) — i.e. the
  wide-fingerprint correctness answer is the intended default; at 44 fp + 1 val ≈ 45 r ×
  ~1.1 ≈ **~50 bits/key**.
- **`count --roots` is already wired** (`bin/queens.rs:189`, `roots_report`) and measures
  exactly the two numbers that pick the live-cascade shape, but is **unrun at n=14/16**:
  - **(A)** the largest *cold per-root* working set — does one root fit a single-box live
    TT eviction-free? (sizes the mutable tier);
  - **(B)** `Σ(per-root distinct) / |union|` — the cross-root reuse factor: ~1.0 ⇒ roots
    barely overlap (archive optional), ≫1.0 ⇒ heavy overlap (archive essential, and it
    must hold the *shared* core).
- **The live solver hook points** (`solver/incremental.rs`): per node `tt.get(key)` /
  `tt.put(key, val)` / `tt.prefetch`, where `key` is the cheap **D4 canon** from the
  incremental kernel (~ns). `QueensTt` slot is one `u64` with a **55-bit** fingerprint
  (`tt.rs`).
- **The implicit-keying lever (SoA findings Q1.3).** When a *ply window's* membership is
  known a priori, the freeze can drop `fp_bits → 0`: the key becomes **implicit in the
  ribbon row position**, value-only at **~1.1 bits/key**, and — decisively — **there are
  no false positives**, because you only ever query keys you already know are members.
  This is the SoA implicit-keying trick at the archive layer and it dissolves *both* the
  memory wall and the FP crux — but it needs a ply-batched (DDD-style) driver, not the
  DFS stack (floor-doc §6 caveat: DFS-stack-resident vs ply-batched streaming may not
  compose; the inner-loop handoff already flags a possible *driver* fork for n=18).

### The three-way constraint (why this is a real decision, not a wiring job)

Any live design trades off three coupled quantities:

1. **Correctness** — `fp_bits` must make expected FPs ≪ 1 over ~10¹⁰ out-of-set probes
   (so `fp_bits ≳ 40`, or `fp_bits = 0` if membership is a-priori-known).
2. **Memory** — every fp bit costs ~1.1 bits/key. The full D4 distinct set at `fp_bits=44`
   is **7.911 B × ~50 bits ≈ 54 GB** — does **not** fit the 26 GB box.
3. **Per-node key cost** — the live kernel emits the cheap **D4** canon. The **iso** key
   merges the set 3.4× (7.911 B → ~2.33 B, fits ~16 GB) but costs ~µs/node, **measured
   negative live**. The incremental kernel does *not* produce it.

You cannot satisfy all three with one knob. The three approaches below each relax a
different one.

---

## Approach A: DFS staged cascade, D4-keyed, selective shared-core archive

### Architecture

Keep the existing DFS `incremental` driver and its cheap D4 key. Add an
**eviction-free frozen tier** below the live TT and query them as a cascade:

```
per node:
  key = lex_min8(orient)            // incremental D4 canon, unchanged
  if let Some(v) = live_tt.get(key) { return v }     // hot mutable tier (2^k slots)
  if let Some(v) = frozen.get(key)  { return v }     // ShardedArchive, immutable
  v = search(...)                                     // genuine miss → expand
  live_tt.put(key, v)
```

Stage by root (the design already sketched in `roots_report`'s doc comment): search
symmetry-distinct first move 0 with the live TT; **freeze its solved set into a BuRR
shard**; *don't clear* — keep accumulating — search root 1 with `{live TT} ∪ {frozen}`;
repeat. The frozen archive grows monotonically to the union of solved positions.

The memory escape is **selectivity**: freeze only the positions with **cross-root reuse**
(the shared core that roots re-query) — root-private positions never need to survive into
the archive (the live TT handles them within their root). If measurement (B) shows the
shared core is a fraction of the 7.911 B union, the archive at `fp_bits=44` fits RAM
**with no iso key needed live**.

### Trade-offs

**Strengths:**
- Reuses the landed `incremental` kernel verbatim — the per-node key stays D4-cheap (no
  iso cost). Smallest delta to a validated solver.
- `ShardedArchive` already does the bounded-RAM build; `roots_report` already measures the
  go/no-go. Mostly *composition*, not new core.
- FP risk is bounded and tunable by the existing `fp_bits=44` default.

**Weaknesses:**
- **Fits only if the shared core is small** — unproven until `count --roots` runs. If
  cross-root reuse (B) is high *and* spread across most of the set, the D4 archive
  approaches 54 GB and does not fit. This is the load-bearing unknown.
- Freeze cost is paid mid-search and (like the zstd dump) can be CPU-starved by the 24
  workers — needs a background/sharded freeze that doesn't stall the search.
- A live cascade miss pays a second hashed structure's latency on top of the TT probe
  (the cascade *adds* a tier to the critical path — an expected intermediate regression).

---

## Approach B: DFS staged cascade, iso-merged at freeze

### Architecture

Same staged DFS cascade as A, but the **freeze applies the 3.4× graph-iso merge**: when
flushing the live TT's D4-keyed solved set into a BuRR shard, recompute the **iso key**
in the (batched, background) freeze pass and dedup to iso-classes. The archive then holds
~2.33 B keys at `fp_bits=44` ≈ **~16 GB — fits**, holding the *whole* set, not just a
shared core.

The cost lands on the **query**: to look a node up in an iso-keyed archive, the live
search needs that node's iso key. Structure the cascade so the iso key is computed
**only on a live-TT miss** (the cold tail), never on a hot hit:

```
per node:
  d4 = lex_min8(orient)
  if let Some(v) = live_tt.get(d4) { return v }     // hot path: D4 only, no iso cost
  iso = q.iso_key(orient)                            // cold tail only
  if let Some(v) = frozen_iso.get(iso) { return v }
  ...
```

### Trade-offs

**Strengths:**
- **Provably fits RAM** (16 GB) holding the *entire* distinct set eviction-free — no
  dependence on the shared-core fraction. The robust-memory option.
- The iso merge is the roadmap's documented 3.4× lever, applied at freeze where its per-
  node cost is amortized over a batch, not paid per search node.

**Weaknesses:**
- The iso key on every live-TT miss reintroduces the ~µs keying cost that was **measured
  negative** when applied live everywhere. The bet is that miss-rate × iso-cost <
  re-expansion saved — *unmeasured*, and the prior is unfavorable.
- The freeze must canonicalize-and-dedup billions of keys to iso-classes — heavier than
  A's value-only freeze; CPU-starvation risk is worse.
- Two key functions in the hot region (D4 always, iso on miss) — more I-cache pressure on
  an already frontend-bound search.

---

## Approach C: ply-windowed value-only freeze (DDD driver, implicit keying)

### Architecture

The SoA-findings Q1.3 lever taken to its conclusion. Drive the search **ply-batched**
(breadth-first / delayed-duplicate-detection over plies) instead of DFS. Within a ply
window, **membership is enumerated a priori**, so each frozen ply goes into a BuRR layer
with **`fp_bits = 0`** — value-only, key implicit in the row position, **~1.1 bits/key**.
The whole 7.911 B set is then **~1 GB** and there are **zero false positives** (you only
query keys known to be in the frozen ply).

```
for ply window W (deep → shallow):
  expand W's frontier from the live buffer
  dedup (DDD) → known membership of W
  freeze(W) with fp_bits = 0    // value-only ribbon, ~1.1 bits/key, no FP risk
  queries into already-frozen deeper plies are exact (membership known)
```

### Trade-offs

**Strengths:**
- **Dissolves both the memory wall and the FP crux at once**: ~1 GB resident, no
  false-positive risk. The asymptotically strongest answer.
- The **bridge to n=18** (frontier 2): the external-memory ply-windowed DDD driver is
  already the n=18 plan; building it here amortizes across both frontiers.
- Value-only ribbons are the cheapest possible archive — `Archive::build` already supports
  `fp_bits = 0` for the single-layer / known-membership case (`burr.rs:322-328`).

**Weaknesses:**
- **Largest architectural change** — forks the *driver* from DFS to ply-batched. The
  floor-doc §6 caveat (DFS-stack-resident orientations vs ply-batched streaming) warns the
  two may not share the node kernel cleanly; the `incremental` 8-orientation trick is
  DFS-stack-resident and may not survive the move to streaming.
- DDD needs large sequential frontier buffers (the deep frontier is huge); this is an
  external-memory design even at n=16, with its own I/O budget on the zpool.
- Highest risk, longest runway — not the fastest path to a faster n=16.

---

## Approach comparison

| Criterion | A: D4 shared-core | B: iso-merged | C: ply value-only |
|-----------|-------------------|---------------|-------------------|
| Relaxes which constraint | memory (selectivity) | per-node cost (batch iso) | both (implicit keying) |
| Fits 26 GB? | **iff shared core small** (unproven) | **yes** (~16 GB) | **yes** (~1 GB) |
| Per-node key | D4 only (cheap) | D4 + iso on miss | D4, ply-batched |
| FP correctness risk | yes, `fp=44` (~`2^-44`) | yes, `fp=44` | **none** (`fp=0`) |
| Driver change | small (stage by root) | small (+ freeze iso-merge) | **large** (DFS → DDD) |
| Reuses landed code | `incremental` + `ShardedArchive` | + `iso_key` | new driver |
| Bridges to n=18 | no | partial | **yes** |
| Freeze cost | value-only (light) | iso dedup (heavy) | value-only (light) |
| Time-to-first-measurement | **shortest** | short | longest |

---

## Open questions

1. **The `count --roots` numbers (gating).** Largest cold per-root set (A) and cross-root
   reuse (B) at n=14, plus a partial-n16 extrapolation. These decide whether Approach A
   fits at all. *This must run before any build.*
2. **FP soundness proof.** At `fp_bits=44`, expected FPs over a 10¹⁰-probe n=16 run =
   `layers · 2^-44 · (out-of-set probes)`. Need the out-of-set probe count (cascade-miss
   rate) to bound it ≪ 1, and a belt-and-braces story (verdict cross-check vs Jenrich is
   necessary but not sufficient — a single FP can flip an interior node). Does `fp_bits=44`
   actually suffice, or do we need ~48–50?
3. **Live-tier sizing & freeze cadence.** How small can the mutable TT shrink (it only
   needs one root's hot working set under staging)? Freeze per-root, per-ply, or
   capacity-triggered? Cadence trades freeze CPU cost against archive query share.
4. **Freeze without starving the search** — the n=16 zstd dump was CPU-starved by the 24
   workers (~55 MB/s contended). The freeze (esp. B's iso dedup) is heavier; does it need a
   reserved core, a pause, or a streaming/incremental build?
5. **Slot discipline (from SoA negatives — settled, not open, but binding).** Keep the live
   TT's one-`u64` self-describing slot — do **not** SoA-split it for the cascade (splitting
   doubles random DRAM round-trips on a latency-bound table; documented negative). Any
   cascade telemetry (miss-rate, FP counter) goes in a **cold side-car** per Tiger rule #6,
   never inline in `QueensTt`.

## Recommendation

**Phase 0 first (measure), then Approach A as the first build, with B as the in-place
fallback and C tracked as the n=18-bridging endgame.**

Justification:
1. **A is the shortest path to a live, measured cascade** and reuses the most landed,
   validated code (`incremental` kernel verbatim + `ShardedArchive` + the already-wired
   `roots_report`). It changes one constraint (memory, via selectivity) and leaves the hot
   per-node key D4-cheap.
2. **A's feasibility is one measurement away.** `count --roots` already exists; its (A)/(B)
   numbers tell us directly whether the shared core fits. If it doesn't, the cascade
   machinery built for A is **the same machinery B needs** — B is just "freeze with iso
   dedup" swapped into the freeze pass, an in-place fallback, not a restart.
3. **C is the strongest endgame but the wrong first step** — it forks the driver and is
   really the n=18 program; we shouldn't gate the n=16 win on it. We keep it on the map
   precisely because Phase-0's ply-distribution data also informs whether C's value-only
   ply freeze is worth building later.
4. **Expect intermediate regressions and push through** (per the session's standing
   guidance): adding a cascade tier *lengthens* the per-node critical path before
   selectivity/eviction-freedom pays it back. A staged cascade will likely measure slower
   at the first cut (freeze cost, extra tier latency, miss-handling) — that is an expected
   waypoint, not a bail signal. The final composed `cascade` solver must beat the
   `incremental` baseline on **short-n16 throughput** (below); **intermediate steps need
   not**, and we attribute each regression (freeze time / cascade-miss rate / cyc-node)
   rather than reverting.

### Measurement: short n=16 runs are the only valid perf signal

**The point is a faster n=16.** n=14's full distinct set (~53 M) fits the 2³¹-slot TT with
room (re-exp already ~1.0×), so a cascade tier shows **no capacity win at n=14 — only the
added-tier overhead.** The lever is *invisible* until the set overflows the table, which
only happens at n=16. Therefore:

- **n=14 = correctness + fast-feedback only** — `solver_lineage_agrees`, exact `solve 12`/
  `14` distinct, a quick smoke A/B to catch gross breakage. A n=14 regression during this
  build is **expected and not a bail signal** (the lever can't pay there).
- **The perf verdict is short n=16 runs** — throughput (M/s) and the re-exp drop, measured
  on a few-minute cold n=16 run or from a SIGUSR2 partial-fill fixture, **A/B interleaved**
  (round-by-round, thermal-controlled per CLAUDE.md). Watch: does re-exp fall from 1.36×
  toward 1.0×, does sustained M/s hold nearer the ~14 peak instead of decaying to ~6, and
  does the freeze stay off the search's critical path. perf-analyze (TMA / cyc-node) the
  short n=16 run, not n=14 — the bottleneck (capacity + frontend) only appears at scale.

### Implementation phases

- **Phase 0 — measure (gating, no new core).** Run `count --roots` at n=14; partial-n16
  via a SIGUSR2 fixture / extrapolation. Record (A) largest per-root cold set, (B)
  cross-root reuse. Decide A-fits vs B-needed. *Also* tally the per-ply distinct
  distribution (informs C). Validation: numbers only, no solver change.
- **Phase 1 — `cascade` solver skeleton, frozen tier read path.** New
  `solver/cascade.rs` wrapping the `incremental` node kernel + a two-tier query (live
  `QueensTt` → an immutable `ShardedArchive` loaded read-only). First milestone: load a
  *pre-frozen* n=14 archive and have `cascade` answer from it — proving the live cascade
  query path + FP behavior on a real search, **before** wiring mid-search freeze. Gates:
  `solver_lineage_agrees` (n≤9), `solve 12 --distinct` = 1,060,823 exact, `solve 14`
  ≈49.3M / second / re-exp ~1.0×, FP count measured = 0 over the run.
- **Phase 2 — staged freeze (per-root), monotonic archive.** Freeze each root's new
  solved set into a fresh BuRR shard mid-search; subsequent roots cascade-query the
  accumulated archive. Background/sharded freeze that doesn't starve the search. A/B
  **interleaved vs `incremental` on short n=16 runs** — the only scale that shows the
  capacity win (n=14 fits the TT); measure throughput (M/s), re-exp drop, freeze cost,
  cascade miss-rate. n=14 stays the correctness smoke test only. (Expect a first-cut
  regression — attribute via TMA/cyc-node on the n=16 run, push through.)
- **Phase 3 — iso-merge fallback (only if Phase-0 says A doesn't fit).** Swap the freeze
  pass to iso-dedup (Approach B); compute the iso key on live-TT miss only. Re-A/B.
- **Phase 4 — partial-n16 throughput probe, then the ask-first full n=16 run.** Project
  from partial throughput; the real n=16 run stays an explicit user-gated decision.

Validation gates apply to **every** phase (CLAUDE.md): `solver_lineage_agrees`, exact
`solve 12`/`14` distinct, re-exp ~1.0×, verdict cross-checks Jenrich (n=16 second player),
`make test`/`clippy` green, FP expected count provably ≪ 1.
