# iso-flat solver — sustained-throughput graph-iso over a flat TT

**Date**: 2026-06-17
**Mode**: intent-based (user away; authorized arch decisions on the new solver)
**Goal (user)**: a new solver with **burr-memtable out-of-gate throughput, *sustained*
on all cores**, plus **iso-burr's fewer-nodes merge** — pushing toward the
[theoretical floor](../2026-06-16-queens-theoretical-floor.md). Leave existing solvers as-is.

---

## What landed (commit `241000f`)

**`iso-flat`** = single **pure** graph-iso key per node over a **flat lockless `QueensTt`**
(no LSM/segments). New module `rust/src/queens/solver/iso_flat.rs`; registered in
`SOLVER_NAMES` / `make_solver` / the counting factory / `list_engines` / the lineage test.
All existing solvers untouched.

**The idea.** burr is eviction-free by *freezing* into segments, but a miss then walks the
whole segment cascade → throughput decays ~30→10 M/s. A flat table never decays (O(1) probe),
but at n=16 the ~7.2B D4-distinct set overflows RAM → eviction (1.36× re-exp). The **iso key
removes that**: it merges every isomorphic available-graph (sound — impartial Node Kayles,
history-free, exact values → no GHI), shrinking n=16 to ~2.1B, which **fits** a flat ~2³¹-slot
table at load ≈1.0. So iso-flat is eviction-free by **fitting**, not freezing → no segments,
no decay, complete set resident.

**Design calls** (made under authorization):
- **Pure single iso key** (every node `graph_bits(iso_key)`), not selective like `fused`
  (iso≤7 / D4 above). Pure gives the *full* 3.4× merge (the thing that makes it fit) and uses
  one namespace → **sidesteps the n=16 sentinel-bit-255 mixing hazard** entirely.
- **Carries only the `available` mask** (`avail.and_not(attack[sq])` per move) — drops the
  8-orientation `child_orient`/`lex_min8` machinery (that exists only for the D4 key it never
  uses). Simpler than `fused`/`iso-burr`.
- **No checkpoint v1** (`tt()` = None): a flat table *could* dump, but `TT_CANON_ID` doesn't yet
  distinguish iso- from D4-keyed images → a cross-mode `--resume` would mis-key. Follow-up: a
  key-mode header tag.

## Validation (all green)

- `solver_lineage_agrees` (iso-flat == naive verdict, n≤9); `make test`/`clippy`/`fmt`.
- n=12: **SECOND ✓**, 310,655 nodes (= D4 1,060,823 / 3.42× — full merge realized).
- n=14: **SECOND ✓**, 14,769,230 nodes (= 53.2M / 3.60×), distinct ≈14.67M (= known iso count),
  **1.01× re-expansion** — *the fits-flat / eviction-free thesis is confirmed at n=14.*
- Existing solvers unchanged (incremental n=12 still exactly 1,060,823).

## The verdict: NET LOSS at n=14 — the WL key is the entire wall

Clean interleaved A/B, n=14, **24 cores, tmpfs** (bench hygiene):

| solver       | nodes  | wall  | M/s   |
|--------------|--------|-------|-------|
| incremental  | 53.2M  | 5.50s | 9.65  |
| iso-flat     | 14.83M | 8.96s | 1.66  |

iso-flat walks **3.59× fewer nodes** but is **~1.63× slower wall** → **~5.8× per-node cost**.
It does **not** reach the 30 M/s goal — the per-node graph-key cost dominates. This matches the
floor doc ("iso is a live loss until the key is driven down") and `iso_key_bench`'s own header
("~19% net-slower even for *selective* iso at n=14"; pure-iso is heavier).

**Why (isolated, `iso_key_bench` n=14 corpus, mean popcount ~9):**

| key            | ns/key | rel |
|----------------|--------|-----|
| fast (cache on)| 586    | 1.0×|
| **fast_nc (cache off — live regime)** | **1236** | 2.1× |
| ir             | 2139   | 3.7×|
| canon          | 3320   | 5.7×|

Live iso key ≈ **1236 ns ≈ ~4200 cyc** vs the D4 incremental key's **~62 cyc** → **~68× on the
key alone**; **73% of components need full WL** (`comp_canon_full`), only 27% hit the cheap
tiny-table (k≤4). The key *is* the per-node cost.

## The lever (Phase 2 — the determinant): drive the WL iso key down

iso-flat's fate is **entirely** the WL key cost. Targets (all gated by `iso_key_bench`,
`perf:fast_nc` = the live-regime number to beat):
1. **`comp_canon_full` in `graph.rs`** — the k≥5 WL canon (1-WL colour refinement + cert hash +
   individualisation). Branchless refinement, SWAR/AVX over colour vectors, fewer WL rounds.
   #17 (branchless refine) already banked ~3.5%; the bulk remains.
2. **Incremental colour-carry down the DFS** (the D4-canon trick applied to WL): placing a queen
   *removes vertices* from the available graph — update the colouring, don't recompute. The
   high-reward, high-risk path (inner-loop handoff lever).
3. **Better per-thread component cache** — fast (586) vs fast_nc (1236) is 2.1×; the live search
   thrashes the cache. A larger/smarter per-thread cache could recover much of that 2.1× at low
   risk (#19). **Cheapest first probe.**

Napkin: drive the WL key from ~4200 cyc toward ~700 cyc (6×) and iso-flat's per-node penalty
falls from 5.8× to ~1× → 3.6× fewer nodes becomes a **~3× wall WIN** + eviction-free + sustained.
Even the cache win (2.1×) alone moves 5.8× → ~3.3× (still a loss, but halves the gap).

## n=16 caveat (why n=14 isn't the whole story)

n=14 *favors incremental*: 49M D4-distinct fits the flat table with no eviction, so incremental
runs at full speed. At **n=16** incremental **evicts** (1.36× re-exp) and the 7.2B D4 set strains
RAM, while iso-flat **fits** (2.1B, eviction-free). So the n=16 net is more favorable to iso-flat
than n=14 — but the 5.8× per-node penalty is large to overcome with only ~1.36× eviction savings.
A partial-n16 throughput probe (SIGUSR2 fixture) would size this; **don't fire a full n=16 run**
(ask-first) until the WL key is driven down.

## Other lever (user-named "better sustained all-core"): flat-TT contention fix

Task: mirror the burr-store thread-local-counter fix (`49bba47`) into `tt.rs` (per-node
`nodes.fetch_add` at `tt.rs:328` + HLL feed at `:389` → thread-local, flush ~1/s, drain at parallel
search end). Removes per-node cross-CCX atomics → helps `incremental`/`parallel` (cheap nodes, where
the atomic is a real fraction). **Note:** negligible for iso-flat itself (its 4200-cyc node dwarfs
one atomic). Self-contained; see `2026-06-17-flat-tt-contention-fix.md`. Not yet done.

## Run/bench notes

- Bench harness: `rust/bin/gen/ab_isoflat.sh` (interleaved iso-flat vs incremental, tmpfs, all cores).
- `iso_key_bench` already exists (`rust/src/bin/iso_key_bench.rs`, no Makefile target — build:
  `RUSTFLAGS="-C target-cpu=znver5 -C link-arg=-fuse-ld=mold" cargo build --release --bin iso_key_bench`,
  run `taskset -c 0,1,2,3 ./target/release/iso_key_bench 14`). It is the Phase-2 gate.
- Run queens in tmux session `queens`; trust timing only from tmpfs or Zen5-pin (`[[queens-bench-from-tmpfs-not-zfs]]`).

## Side-result this session: root-ordering = documented NEGATIVE (commit `0924e52`)

`count --roots` now reports per-root proxies + an offline capped-replay Δ. n=12: every proxy's
Spearman vs cross-root shared-volume is flat (|ρ|≤0.54); fragmentation-first is *worse* than the
current order; even the oracle reorder is only ~3.7% better at the n=16 cap regime (< the 3–5%
bar). **Do not reorder roots.** Matches the floor doc (no universal trunk; 58% root-private).
