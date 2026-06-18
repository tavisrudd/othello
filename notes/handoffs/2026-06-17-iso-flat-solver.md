# iso-flat solver — sustained-throughput graph-iso over a flat TT

**Date**: 2026-06-17
**Mode**: intent-based (user away; authorized arch decisions on the new solver)
**Goal (user)**: a new solver with **burr-memtable out-of-gate throughput, *sustained*
on all cores**, plus **iso-burr's fewer-nodes merge** — pushing toward the
[theoretical floor](../2026-06-16-queens-theoretical-floor.md). Leave existing solvers as-is.

---

## ✅ Session 2026-06-18--6 (this commit) — serial prove-a-win hot-loop cuts, oracle reviewed

User asked to review recent commits, test the parked oracle, profile short n=16 runs with perf
counters, monomorphize the oracle toggle, fix review findings, then keep squeezing the serial
prove-a-win path. Done.

### Correctness / review fixes
- **Oracle toggle monomorphized**: `wins_inc`, `wins_tiny`, and `par_wins_inc` now take
  `const ORACLE: bool`; the env toggle dispatches once at the solver boundary, not per node.
- **Oracle `K=8` footgun fixed**: `QUEENS_NIMBER_K` clamps to 7 until there is a real complete
  k≥8 component key, avoiding the old `iso_key_tiny_table` panic path.
- **Oracle component TT probes no longer pollute `--distinct`**: component nimbers use
  `QueensTt::get_hashed/put_hashed` under a disjoint nimber namespace instead of the counting
  `get/put`.
- **Oracle stats added**: thread-local attempt/hit/component-cache counters, flushed to atomics and
  printed only when `QUEENS_NIMBER_ORACLE=1`.

### Oracle result (short-run negative)
- `QUEENS_NIMBER_ORACLE=1 target/release/queens solve 14 iso-flat --distinct`: SECOND,
  29,271,586 nodes in 2.22s, distinct ≈29,111,313, oracle `501739/29458732 (1.7%)`,
  comp-cache `1100052/1228`.
- Short n=16 perf stat with oracle enabled: ~323.7M nodes / 20.01s = **16.18 M/s**, vs default
  ~402.4M / 20.08s = **20.04 M/s** in the adjacent run. Oracle remains **parked/off**.

### k=8 direct-canon experiment (negative, parked behind `QUEENS_TINY8=1`)
- Added an opt-in exact whole-graph 8-vertex key (`iso_key8_direct`) and a per-thread direct-mapped
  labelled edge-code cache to test whether a dense k=8 table could pay.
- Short n=16 runs:
  - default `KEY_MAX=7`: ~19.7-20.0 M/s.
  - `QUEENS_KEY_MAX=8` existing WL path: ~7.39 M/s.
  - `QUEENS_KEY_MAX=8 QUEENS_TINY8=1` direct no cache: ~3.55 M/s.
  - same with k8 cache: ~4.72 M/s.
- Conclusion: do **not** build the k=8 direct path in this shape; labelled k=8 repetition is not
  enough to amortise exact canon. The hook remains opt-in measurement code.

### Serial prove-a-win profiling and landed micro-wins
Perf record on short n=16 showed the serial path dominated by:
`wins_inc` ~53%, `iso_key_tiny_table` ~25%, `QueensTt::get_h` ~14-15%, plus
`core::array::try_from_fn` from `child_orient`.

Landed changes:
- **`child_orient` hand-written 8-lane update**: removed the generic array-constructor samples.
- **Hot move filtering uses narrow unchecked helpers** (`avail_has`, `att_for`, `att0`) with debug
  assertions and safety comments. This removed the old `sq < 256` and `nc < MAXV` panic checks from
  the annotated `filter_moves` loop; LLVM now unrolls the scan.
- **Tiny edge-code builder const-specialized for k=2..7** and uses direct word tests. The hot path
  no longer pays iterator state and repeated checked attack-row indexing for the labelled edges.
- **Tiny-canon table hoisted into `IsoFlat`**: hot iso-flat key calls use
  `iso_key_tiny_table_pc(mask, pc, table)`, avoiding the per-node `OnceLock` check and a duplicate
  popcount.
- **Tiny k≤3 direct keys**: k=1 constant; k=2 labelled edge code is canonical; k=3 canonical code is
  determined by edge count.
- **Stack-local node accounting for sequential iso-flat recursion**: `QueensTt::bump_local` /
  `flush_local_nodes` avoid per-node TLS/`RefCell` `tt.bump()` in the inner recursion while keeping
  the existing flush cadence for progress.
- **Prove-loss mode monomorphized**: `wins_inc<const ORACLE, const PROVE_LOSS>` and
  `wins_tiny<const ORACLE, const PROVE_LOSS>`. Prove-loss nodes keep eager compaction because they
  search all children; prove-win nodes lazily scan `pmoves` and skip full compaction when an early
  child cuts off. The proof-mode branch is compile-time at the sequential recursion boundary.

Short n=16 perf-counter checkpoints (phase-sensitive, use instructions/node more than wall):
- Original default reference in this investigation: ~402.4M nodes / 20.08s, 1.099T instructions
  ⇒ ~2.7k instr/node.
- After bounds-check/tiny-key/child-orient cleanup: best short runs in the 436-501M nodes / 20s band,
  ~1.8k instr/node.
- After local node accounting + monomorphized prove mode: 453.8M nodes / 18.86s = **24.07 M/s**,
  788.6B instructions ⇒ **~1.74k instr/node**; repeat 500.0M / 18.96s = **26.37 M/s**,
  864.6B instructions ⇒ **~1.73k instr/node**.

Validation green:
- `cargo test solver_lineage_agrees -- --nocapture`
- `QUEENS_NIMBER_ORACLE=1 QUEENS_NIMBER_K=8 cargo test solver_lineage_agrees -- --nocapture`
- `make clippy`
- `make test`

### Next levers
1. **Reprofile after this commit** on a non-lossy perf capture and annotate `wins_inc` /
   `iso_key_tiny_table_pc`; current remaining top symbols are still those two plus TT random loads.
2. **Measure lazy prove-win compaction on a full n=14/n=16 A/B**. It is instruction-positive in
   short n=16, but it passes longer parent move lists into the following prove-loss node; keep it
   only if full-run node count and wall stay favorable.
3. **Consider a local-counter API for counting/HLL mode separately** only if `--distinct` profiling
   matters. Production now avoids the TLS node counter in iso-flat sequential recursion, but counting
   `get_h` still has the HLL hook by design.
4. **Oracle remains off** until a non-redundant complete-key regime exists; current ≤7 oracle hits
   too little and overlaps the selective iso merge.

---

## ✅ Session 2026-06-17--5 (`21ce0a6`, `97ef7bd`) — per-node energy cuts: **n=14 −24.7% wall**, node set identical

User goal shifted to **pushing iso-flat further**. Path: started on "better parallelism on the
elder root" → measured it into the ground → pivoted to per-node work-reduction, which is the
**right lever at this box's thermal wall** (see the new finding below). Five of Codex's six
inner-loop suggestions landed; node set byte-identical throughout (n=12 distinct 1,060,823 exact,
n=14 single-thread 29,695,141 unchanged; `solver_lineage_agrees`/OEIS/integration + clippy `-D`/fmt
green).

| lever | what | 24-core wall (n=14) | 1-thread instr |
|-------|------|---------------------|----------------|
| #1 iso-only `wins_tiny` tail | available-popcount is monotone-decreasing ⇒ once in the iso band the subtree is; drop the dead 8-orientation `child_orient`/`lex_min8` there | — | — |
| #4 hash-carry | hash each TT key **once** at creation; thread `(route, fp)` through `wins_inc`/`wins_tiny`, reuse for prefetch+get+put (was ≤3× `hash128`/key). New `QueensTt::get_h/put_h/prefetch_h` | #1+#4: **−2.1%** | −2.0% |
| **#5 tighter `iso_key_tiny_table`** | build the triangular edge code directly (one attack test per `i<j`), no full `k×k` adj + separate `edge_code` rescan (~3× work). **The surprise** — it's per *child-key* across the whole deep region, not a small band | **−20.5%** | −14.7% |
| #2 incremental move-list | replace the scan-all-`n²` `for sq in q.order { if !avail.get }` with a per-node list filtered from the parent's (in `q.order`) — `wins_tiny` was scanning 196 to find ≤7. `MaybeUninit` buf to skip the `n²` zero-init | **−24.7%** | **−36.3%** |
| #3 popcount-carry | folded into #1 | — | — |
| #6 const-specialize ≤7 path | **skipped** — Fermi'd to ~0 (predicted-true branch, not a hot function like #5) | — | — |

**Cumulative: 2.57s → 1.93s (−24.7% wall), 149.06B → 95.00B instr (−36.3%).** Wall gains were
*super-linear* vs instructions where the cut was large (#5), because less energy/node → less
throttle. **The deterministic instruction count predicted wall direction reliably — the right
metric on a throttled box** (single-shot `perf` cycles were noisy/misleading; the interleaved
24-core wall A/B is the bottom line).

**✅ VALIDATED AT n=16 (user run, default 17 GB TT, `--distinct`): SECOND in 4m11s** — 5.56B nodes,
**1.17× re-exp, 22.15 M/s avg** (early 25 M/s, eased as the TT filled to 89.2%). **1.68× faster wall
/ 1.76× throughput than the prior 7m02s / 12.6 M/s best — and on the *smaller, safe* default table**
(the prior best needed TT 2.6e9 ≈ 20.8 GB, near the zram cliff). The n=16 win exceeds n=14's
(1.68× vs 1.33×) because the deep `wins_tiny` region #5/#2 target is a larger fraction at n=16, plus
thermal amplification. **n=16 is now a ~4-min bench.** Verdict cross-checks Jenrich; node-set-
preserving, so the verdict is safe.

### Elder-root investigation (the entry point — a documented dead end, kept for the record)
- **n=14 elder is ~hard-serial**: 47% of wall for 6% of nodes, scales only 1.87× over 1→24 threads
  (the prove-a-win/cutoff levels are sequential by design). Whole search tops out at **8.17× on 24
  cores**. **Fan-all-roots is a wash** (identical wall + node count) — you can't fan a cutoff node
  without speculation, so ordering doesn't add exploitable parallelism.
- **n=16 elder is NOT idle**: the size-split (`min-avail=96`) fills it → ~12 M/s, **23.8/24 cores
  busy**. So the slack is the ~10× *busy-but-unproductive* ceiling, not idle cores.
- **Lever B (background nimber DB) prototype built + tested → documented NEGATIVE at n=14.** G1
  (`count --comps` now reports the per-node largest-component dist; max-comp is monotone ⇒ the
  fraction ≈ the prunable set): ≤7 = 42% of *D4-distinct*. But iso-flat's selective iso key
  **already merges that region**, so the oracle's incremental gain is only +5% work / −1.8% nodes
  → net loss. Parked behind `QUEENS_NIMBER_ORACLE` (off) for a K≥8 complete-key (Lever-A) follow-up,
  where the merge would no longer be redundant.

### Contention/false-sharing audit (user asked)
Hot path is clean: no Mutex; only per-node shared write is the TT slot store (node counter is
thread-local since `49bba47`); no per-node `env::var`. TT false-sharing (8 slots/64B) is small
(huge table vs store rate → capacity- not conflict-bound, roadmap #4 ~0–5%). True-sharing on the
shallow popular slots (cross-CCX Infinity-Fabric bounce) is the inherent one. The **99.x% (not
100%)** the user saw = work-starvation in the serial prove-a-win sections (Amdahl tail) + thermal
throttle, **not** contention (which shows as 100%-busy-low-IPC).

### ⚠️ THERMAL WALL — recontextualizes every bench (new, see [[queens-benches-thermal-wall]])
**All queens benches run at the ~90°C 24-core throttle** (idle 57°C — the A9 Max mini-PC cooler
can't sustain all-core; heat-soaks in <1 s). So a chunk of the "8.17× ceiling" is *clock derate*
(single-thread ~4.9 GHz boost vs all-core ~3.7 GHz, ≈0.74×), not pure Amdahl: 24× ideal → ~17–18×
before any algorithm, leaving ~2.1× algorithmic. **No SW fan control on this box** (no pwm hwmon /
platform_profile / vendor tool — EC firmware runs the fan; the amdgpu kernel params are GPU-stability
workarounds that also spend shared-SoC budget). **To bench cleanly: `ryzenadj` (cap TDP +
`--tctl-temp 85`, no amdgpu changes) or Zen5 8-logical pin.** Throughput is power-limited ⇒ rank
levers by **energy/work**, not parallelism — exactly why this session's per-node cuts paid.

**Next (decide with user):** (1) **Lever-A edge-code k≤8 table** — a cheaper *complete* iso key
(33–134 MB, n-independent) that both speeds the key AND makes the oracle's merge non-redundant
(the real path to fold Lever B back in); (2) an n=16 throughput probe to confirm the −25% translates
(OOM/thermal-fraught — do after ryzenadj); (3) strip-or-keep the parked oracle.

---

## ✅ RESOLVED (session 2026-06-17--4, `9331f9b`) — iso-flat recovers throughput to >12 M/s

User directive escalated to: *"remove any contention, measure hot loop costs, TMA, optimize…
till it is faster than 12 M/s."* **Done — n=14 14.1 M/s (default), n=16 ~17 M/s warm.** Two
levers, both measurement-driven:

1. **TMA exposed the real bottleneck.** `perf` on pure-iso iso-flat: IPC 1.14 (NOT memory-bound —
   TT probe is ~1% of cycles), **~39 K instructions/node**, **8.4% branch-miss (~⅓ of cycles)**;
   hot functions `comp_canon` 53% + `wl_refine_in` 22% = **75% in the WL graph-key.** Pure-iso pays
   WL on every big connected component. The component-carry I tried first was a **wash** (it reuses
   the cheap tiny components; the big component is always-dirty → always re-WL'd) — removed.
2. **Selective keying (the throughput answer).** Measured `fused`'s selective key (cheap tiny iso
   ≤k / cheap D4 above, avoiding WL) already hit 11–17 M/s. So iso-flat was reworked to **fused's
   kernel — carry the 8 orientations (`child_orient`) + one selective key — over the flat
   `QueensTt`.** Default threshold `QUEENS_KEY_MAX=6`.
3. **The contention fix was the load-bearing 2×.** Even matching fused's kernel, iso-flat was 2×
   slower than fused *purely from the store*: `QueensTt::bump`'s per-node `nodes.fetch_add` (+ the
   per-`get` HLL feed) bounced across the 2 CCXs. Moved to a **thread-local `Acc`** flushed ~1/s +
   drained via a new `Solver::drain()` the CLI calls post-search (mirror of the BurrStore fix
   `49bba47`). That ~2×'d iso-flat → **14.1 M/s** and **benefits `incremental`/`parallel`/`memo`** too.

**Measured (24-core, tmpfs):**

| board | solver | M/s | note |
|-------|--------|-----|------|
| n=14  | incremental (D4)      | 9.7  | baseline |
| n=14  | **iso-flat KEY_MAX=6** | **14.1** | default; KEY_MAX=5 → 16.9 |
| n=16  | iso-flat KEY_MAX=6 | 15.7 | SECOND, 8.66B nodes, 1.27× re-exp, 9m11s (default TT 17 GB) |
| n=16  | iso-flat KEY_MAX=7 | 13.2 | SECOND, 6.58B nodes, 1.15× re-exp, 8m20s (`QUEENS_TT_SLOTS=2.4e9`, 19.2 GB) — KEY_MAX=7 is the default |
| n=16  | **iso-flat KEY_MAX=7, TT 2.6e9** ⭐ | **12.6** | **SECOND, 5.32B nodes, 7m02s** (20.8 GB, 83% full) — current best / practical sweet spot |
| n=16  | iso-flat KEY_MAX=7, TT 2.7e9 | 12.6 | SECOND, 5.66B nodes, 7m28s (21.6 GB) — *slower* than 2.6e9 despite a bigger TT: the run-to-run variance now exceeds the TT-tuning effect |

**TT-size sweep (KEY_MAX=7): 2.4e9 → 8m20s (6.58B), 2.6e9 → 7m02s (5.32B), 2.7e9 → 7m28s (5.66B).**
2.4→2.6 was a real eviction win; 2.6→2.7 went *backwards* — **the TT-tuning axis has hit the run-to-run
noise floor** (~7–7.5 min band; distinct bounced 5.71/4.65/4.98B). More RAM past ~2.6B (≈20.8 GB) doesn't
reliably help and nears the zram cliff. Sweet spot: **KEY_MAX=7 + TT ~2.6e9 → ~7 min.**
| n=16  | incremental (D4) | 18.3 | SECOND, 10.12B nodes, 1.31× re-exp, 9m14s (same KEY_MAX ignored, TT 2.4e9) — **contention-fixed; ~34 min → 9m14s (~3.7×)** |

**n=16 head-to-head (both contention-fixed, TT 2.4 B/19.2 GB): iso-flat 8m20s vs incremental 9m14s
— iso-flat wins by ~10%.** Higher *rate* ≠ faster: incremental runs 18.3 M/s but walks 10.12B nodes;
iso-flat runs 13.2 M/s but only 6.58B nodes (1.35× fewer distinct from the k≤7 iso merge × 1.15
vs 1.31 re-exp from the smaller set fitting the table). So the popcount-7 merge band *does* pay net,
edging contention-fixed D4. **Two-part win:** the contention fix is the big shared ~3.7× (lifts
incremental too); iso-flat KEY_MAX=7 then adds ~10% on top. The 3.4× full merge (KEY_MAX≥8, WL) is
still the untested high-end — gated on a cheaper WL key (the inner-loop lever).

**Known characteristic — n=16 distinct/re-exp vary run-to-run (~18%), and it is NOT an HLL artifact.**
Two KEY_MAX=7 runs reported 5.71B (TT 2.4e9) vs 4.65B (TT 2.6e9) distinct. Diagnosed: the **HLL is
accurate** (n=14 `--distinct`, p=16, is stable to ±0.17% over repeat runs), so bumping `hll_p` does
**not** help — it would add `--distinct` cache cost for nothing. The variance is **real**: at n=16 the
table **evicts**, and under parallel α-β the **cutoff order changes which positions get pruned**, so
the distinct *set reached* genuinely differs run-to-run (n=14 doesn't evict → stable). The **verdict
and wall are the stable numbers**; treat n=16 distinct/re-exp as ±run-dependent. A trustworthy n=16
distinct would need a *deterministic* count (single-thread / fixed cutoff order), not a bigger HLL.

Gates green (solve 12/14 --distinct = 1,060,823 / ~49.1M, re-exp 1.01–1.08×; `make test`/clippy/fmt).

**Key finding from the n=16 distinct count: at KEY_MAX=6 the selective merge is ~nil** — 6.84B distinct
vs D4's ~7.2B (≈5% merge). The win is NOT the node merge; it is the **cheap key (tiny-table ≤6 / D4
above, no live WL) × the thread-local-counter contention fix × the flat sustained store.** The 3.4× iso
merge lives in the *bigger* graphs (k≥7), which only a *high* KEY_MAX keys — and that pays WL (slow).
So the trilemma sharpens: cheap-key (low KEY_MAX) → ~no merge → 6.8B set → evicts (1.27×) but fast
(15.7 M/s); merge (high KEY_MAX) → smaller set → fits eviction-free → but WL-bound. **Eviction-free n=16
(re-exp→1.0) needs the merge, i.e. a higher KEY_MAX (slower/node) + a TT sized to the merged set — the
open sweep.** As-is, 1.27× re-exp at 15.7 M/s is the fastest n=16 to date; chasing eviction-free trades
throughput.

**The trilemma is now a tunable knob, not a wall** (`QUEENS_KEY_MAX`): low → fast (this win),
high → pure-iso full-merge (fits-but-WL-bound). **Open at n=16:** the selective set (~5.5B at
KEY_MAX=6) exceeds the 17 GB flat table → it *will* evict late-run (re-exp climbs, though the flat
probe keeps the *rate* ~17). Next: size the TT with `QUEENS_TT_SLOTS` to fit, or sweep KEY_MAX, to
keep n=16 eviction-free; then a full (ask-first) n=16 run. Everything below this line is the
earlier pure-iso exploration (superseded but kept for the record).

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

## The trilemma (the key strategic finding from this session's measurements)

The flat-table route hits a real squeeze. Three properties are wanted; you get **two**:

1. **Full merge → fits flat eviction-free** — needs iso on *all* graphs, incl. large ones
   → **WL on 73% of components** (the ~4200-cyc key). iso-flat is here: fits (1.01× re-exp),
   pays the WL wall.
2. **Cheap per-node** — needs *selective* keying (tiny-table k≤4 only, D4 above, like
   `fused`) → but that merges only ~73% of the merge → ~3.5B at n16 → **doesn't fit flat**
   (28 GB > budget) → evicts → loses the sustained/no-eviction property.
3. **Sustained (flat, no segment walk)** — what iso-flat and the flat D4 solvers have.

The LSM (`iso-burr`) escapes 1↔2 by being eviction-free *regardless of fit* (segments hold
everything) — full merge **and** cheap selective key — but pays property 3 (the segment-walk
decay). **No free lunch:** the merge that lets you fit costs WL; the cheap key doesn't fit;
the structure that fits cheaply (LSM) decays.

**The one lever that breaks the trilemma is a cheap full-merge key** — i.e. driving the WL
iso key down so pure-iso-flat gets all three. That is Phase 2, and the easy knobs are spent
(#17/#18/#19, canon5/6, twin-collapse all landed); the remaining lever is **incremental
colour-carry** (deep, do it with the user). Until then, the honest ranking at n=16 is an open
question between iso-flat (fits+sustained, WL-taxed) and iso-burr (full-merge+cheap-key, decays)
— resolved only by a partial-n16 wall+re-exp A/B.

## n=16 caveat (why n=14 isn't the whole story)

n=14 *favors incremental*: 49M D4-distinct fits the flat table with no eviction, so incremental
runs at full speed. At **n=16** incremental **evicts** (1.36× re-exp) and the 7.2B D4 set strains
RAM, while iso-flat **fits** (2.1B, eviction-free). So the n=16 net is more favorable to iso-flat
than n=14 — but the 5.8× per-node penalty is large to overcome with only ~1.36× eviction savings.
A partial-n16 throughput probe (SIGUSR2 fixture) would size this; **don't fire a full n=16 run**
(ask-first) until the WL key is driven down.

**Partial-n16 probe (measured, 2026-06-17, ~62 s, all cores, tmpfs):** iso-flat n=16 runs at
**~1.0 M/s** (cumulative; instantaneous bounced 0.47–1.53, **not decaying** — confirms the
no-segment-walk sustained design), TT 2.9% full, **re-exp ~1.0× (eviction-free)**. **Memory holds:**
the 17.18 GB table sat in physical RAM with only ~690 MB zram spill on the 26 GB box (23/26 used) —
the "fits flat" thesis holds at n16, but **tight** (a box with more RAM, or a smaller iso set, is
comfortable; near-full it could pressure zram late). ~1.0 M/s is **~4× slower than incremental's
early rate** (the WL tax, slightly worse than n14's 1.6× because n16's near-root graphs are bigger).
**The eviction-free advantage only materializes deep into the run** (once incremental fills+evicts,
≫1 hr), which the probe doesn't reach — so the n16 verdict still needs the full A/B (ask-first), and
it's gated on the WL key either way.

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
