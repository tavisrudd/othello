# Queens n=18 — umbrella

**Date**: 2026-06-23  ·  **Branch**: `queens-n18` (worktree `/home/tavis/src/othello-n18`, off main @ `18579e9`)

The single entry point for all n=18 work. n=16 is **SOLVED** (second player, ~23.4s, the iso-dense
default on main). n=18 is the next open even board — this umbrella tracks getting there.

**`go` / `@notes/handoffs/2026-06-23-queens-n18-umbrella.md go`** = read this, then resume from
*Next-session priorities*.

> **★ Branch state (2026-06-24, session --7) — disk-DDD landed, the RAM-cap wall is removed.**
> `queens-n18` (worktree `/home/tavis/src/othello-n18`) now carries **DFS + the eviction-free BuRR
> store + disk-segment DDD + snapshot/resume**: `3d4d8f6` (BuRR-backed iso-dense) → `f99d56d` (freeze
> parallelization) → **`84a0fd8` (disk-DDD core)** → **`0b91f2f` (snapshot/resume)**. The in-RAM store capped
> at ~2.2–2.5 B of n=18's ~10–18 B distinct; disk-DDD puts ribbons on the 1.4 TB ZFS pool
> (`QUEENS_BURR_DISK_DIR`), keeps only Blooms resident, and makes the segments a resumable snapshot
> (`QUEENS_BURR_RESUME=1`). Validated byte-identical to the in-RAM control + the eviction-relief win
> (see the top Handoff Note). **The C2-retrograde-BFS plan stays dead** (the banner below is about that
> different driver); **DFS + disk-DDD is the live path**, refuting the "needs a cluster / bigger box"
> conclusion. C6 certify pipeline + `certify --after` remain parked on `queens-n18-certify`
> (`81e63ca`, `928a478`); `scripts/check_cert.py` is the independent checker to reuse. **n≥18
> auto-defaults landed** (disk dir + `fp=54` + `cap=16`, no env vars needed). **Prefilter-on-resume + the adversarial-review resume-hardening landed `be40fe9`** (session
> --8); **cert strategy REVISED** — full n=18 certify-from-dump dropped (infeasible ≈ the solve itself),
> CPython certify n≤12 only, n=18 confidence = items 1–4 after the run. **Phase B telemetry + the tuned ZFS
> datasets + n≥18 auto-routing also landed** (`d600f65`, `42a1f94`): live `(gets,hits)` hit-rate /
> `rif` / `WIN_PROVED/LOSS_PROVED/SKIPPED` labels / live in-flight root display; segments auto-route to
> `queens-n18/burr`, TS to `queens-n18/dumps`. **LAUNCHED (session --9):** ran 1h → 5.77 B nodes, confirmed
> **NVMe-bound** (working set ≫ RAM). Landed **A+B+C throughput fixes** (`3b36b2e` — pread ribbon reads /
> wired store prefetch / MLP Bloom walk; major-faults 108K→0, ARC miss 88→24%) + **io_uring Step A** (`6e89f9a`
> — the batch-read primitive). The run is still NVMe-bound with the disk **under-driven** (33K/56K IOPS); next
> = wire io_uring into the search (Steps B/C) to fill the queue, vs the capacity path (more RAM). **Run STOPPED
> + resumable.**
>
> **★ LATEST (session --12): a skip[18,25] + 17 GB flat-TT n=18 run is LAUNCHED and HEALTHY (~8.5 M/s, RAM-resident,
> tmux `queens:skip-flat-n18`).** Built the combinadic rank primitive + measured REAL bits/node: **ranking is marginal
> for a certified run** (keyless combinadic DEAD at coarse shards = 3140 b/node; MPHF tier ~17 b/node but the certified
> union-bound fp pulls it to ~25–45 ≈ 1.2–2× the flat slot — NOT the dreamed 5–13). **⇒ SKIP is the lever; a flat TT on
> the skipped set is the pragmatic store.** skip[18,25] validated verdict-preserving (n≤14), stores only pc≥26. **Morning:
> check roots-done (0/45→any = I9 converged = skip+flat-TT WORKS) + rate (~8.5 M/s steady = healthy; collapse = thrash →
> relaunch with deeper skip [18,26/27]). NOT resumable.** Sessions --10/--11: store-layout study (skip ⇒ deep set ≈2.8–5 B;
> density densifies but ranking's certified payoff is the §--12 erosion). **★ See the session --12 note + `go`.**

## TL;DR state

- **Representation migration: DONE + validated on n≤16** (WORDS 4→6, MAX_N→18, u16 squares,
  d4_bits 6-word bijection, MAXV_POW2). Compiles znver5; 74 tests green; n=12 distinct = 1,060,823
  exact. **BUT the n=18-only code paths are not oracle-tested.**
- **Verdict bug: FIXED (2026-06-24, `cddfc64`).** Root cause = `graph.rs`'s tiny/canon path stored
  board squares in `u8` (the migration's S1 widening missed graph.rs); at n≥17 squares >255 truncate
  → wrong attack rows → loss↔win flip. n≤16 couldn't catch it (max square 255 fits u8). Widened
  square indices `u8`→`u16`; found by a new n=18 subposition differential vs the `memo`/`naive` oracle
  (caught it at pc=3); added a runtime PV-parity guard. Gates green (n=12 exact 1,060,823, n=14 1.03×).
  **The kernel is now correct — but n=18's true verdict still needs the (memory-bound) Phase-C run.**
- **Memory-bind: CONFIRMED.** 261 B nodes / 8h15m / **TT 100% full / 99.7% cold** → heavy
  re-expansion. The flat TT cannot hold n=18 on this box ⇒ **BuRR is the path.**
- **BuRR Phase-3b: ⛔ the central plan (C2) is MEASURED-INFEASIBLE (2026-06-24).** The value-only
  ply-windowed *driver* must run **retrograde/breadth-first** (no values to prune with forward), so it
  enumerates the **full reachable set**, not the α-β proof DAG — measured **42×** bigger at n=12
  (44.9 M vs 1.06 M) and exploding with n (`count --reachable`). So value-only's density win is swamped;
  **both BuRR modes are now ruled out for a single 26 GB box** (Path A membership ~300 GB; Path B needs
  the 42×+ enumeration). The store layer (C1) is sound and kept; **n=18 now needs the cluster (Phase D),
  a bigger-RAM box, or a working-set-shrinking breakthrough** — a strategy decision (see the design doc
  banner). NOT a declared floor — the open levers are real.

## Document map

| doc | what |
|-----|------|
| `proposal-2026-06-23-n18-feasibility.md` (on main, `18579e9`) | the original go/no-go: runtime, limiting factors, flat-TT-vs-BuRR, the de-risk probe |
| `handoffs/2026-06-23-n18-migration-verdict-bug.md` | **the migration details + the verdict bug** (suspects, fix plan) + the run data/M_COLD |
| `n18-migration-changemap.md` | the code-level change map (every WORDS/u16/MAXV_POW2 site) + the TS-file telemetry TODOs |
| `2026-06-23-burr-backed-iso-dense-design.md` | the BuRR Phase-3b architecture (ply-windowed value-only) + the cluster/TDS + 2.5 GbE analysis |
| `2026-06-23-n18-work-plan.md` | **the sequenced forward plan**: bug fix → telemetry/tooling → BuRR build → cluster |

## The shape of the problem (what we learned)

- n=16 (second player) needed the **full 45-root sweep** (all roots proven losing). n=18, IF first
  player, needs **one winning root** (existential) — which is why the buggy run searched only I9 and
  stopped at 1/45. **If n=18 is really second player** (likely), the real proof is the all-roots-
  losing sweep — *far* bigger than the 261 B nodes the buggy run did.
- The wall is **one giant root** with deep internal parallelism (no broad root parallelism), and the
  bottleneck is **cold near-frontier DRAM** (pc 18–23 ≈ 79% of all probes, ~all cold). Same geometry
  as n=16, ~3 orders of magnitude larger.
- The growth came in **much** higher than estimated: R(18) ≈ 849× nodes (vs central 150×) — though a
  chunk of that 849× is re-expansion from the saturated TT, not true tree growth.

## Next-session priorities — end-to-end goal: a launched, instrumented, resumable n=18 run

Full detail + acceptance in `2026-06-23-n18-work-plan.md` (the user's explicit directive is its
"★ Next-session directive" block). In order:

1. ~~**Fix the verdict bug**~~ ✅ DONE (`cddfc64`): graph.rs square-index `u8`→`u16`; differential
   test + runtime PV-parity guard; gates green. (Was: a graph.rs truncation the migration missed.)
2. **Wire up BuRR _with snapshotting + certification_** — `ply_store.rs` + the ply-windowed driver;
   persist the value-only per-ply segments to disk (resumable — the flat-TT iso-dense couldn't),
   **dump the RAW PV-trace** (captured during search, not the final report), and **dump a CERTIFICATE**
   — enough data for a *separate, independent* checker (game rules only) to validate the verdict
   (the value-DAG/strategy subtree; the PV alone is NOT a proof — the bug proved that). Validate n≤16.
   - ✅ **C1 DONE** (`8d8bca6`): store wired + value-only soundness de-risked (single-layer cliff
     ≈0.92 → `DEFAULT_LOAD=0.90`; hybrid exact/ribbon since small ribbons can't single-layer;
     step-down guarantees single-layer). See the BuRR design doc's "C1 DONE" block.
   - **→ NEXT (C2, the big lift): the ply-windowed BFS driver** (DFS→ply-batched + explicit DDD),
     new solver `iso-dense-ply`, validated vs the exact gates (n=12 = 1,060,823, lineage, n=14).
     Then C4 snapshot/resume, C5 raw-PV-in-snapshot, C6 certificate + independent checker.
3. **Add ALL telemetry incl. live root display** — TS `(gets,hits)` hit-rate + `rif`; **live
   in-flight roots in the TTY bar**; root-timing reporting fix; `count --by-ply` (sizes the C2
   frontier buffer — per **queen-count/ply**, the sound window; pc is the cheap proxy).
4. **Launch the run in a tmux pane** capturing telemetry like the first run + snapshotting + certificate
   dump, then **run the independent checker** — *a verdict we can't certify, we don't claim* (Phase E).
   **User-gated big gate** (hours-to-days of compute; a second-player sweep is ≫ the buggy run's 8 h).
5. **(future) cluster** — TDS over 2.5 GbE for n≥20.

## Handoff Note — 2026-06-24 (session --12) — combinadic built + REAL bits/node measured (ranking marginal) ⇒ LAUNCHED skip[18,25] + 17 GB flat-TT n=18 run

**Autonomous session (user → bed: "build it and measure, then get ready for an n=18 run w skip[18,25]…
and if throughput is still too low, just kick off a skip+TT run w the largest TT we can fit. fingers
crossed!"). Delivered: the ranking primitive + the REAL bits/node measurement (verdict: ranking is
marginal for a certified run) → the pragmatic path is SKIP, so a skip[18,25] + 17 GB flat-TT n=18 run is
LAUNCHED and healthy (~8.5 M/s, RAM-resident).**

### 1. Built the combinadic + measured REAL bits/node (commit `queens-n18` `db949d7`)
- **`combinadic.rs`** — rank/unrank over k-subsets (u128 Pascal to C(324,18)), bijectivity test green
  (`rank∘unrank=id`, surjective) = the proposal §7.2.4 gate + the reusable in-slice-rank primitive.
- **Extended the density measurer** (`reachable_deep_from` now returns per-Δ levels; the BREAKDOWN reports
  bits/node per store tier). **[measured, coarse pc=58 shard, deep band pc≥24]:**

  | store tier | bits/node | note |
  |------------|-----------|------|
  | flat hash slot (today) | ~56 | fp 54 + value 2 |
  | ideal rank→reachable | 40.9 | NOT keyless (needs MPHF/enum); 2·reachable/present |
  | **keyless in-slice combinadic** | **3140** | **DEAD** — §3.2 superset sparsity: C(58,Δ) domain=456,837 ≫ present 291 |
  | MPHF(3)+value(2)+per-slice-fp | ~17 | optimistic (ε=2⁻⁸ per slice) |

- **★ The verdict (corrects the proposal's optimistic 5–13):** the **keyless combinadic** is dead except at
  Δ≤1 ultra-fine slicing (where the routing index then explodes); the **MPHF tier's ~17** assumes a tiny
  per-slice fp, but a *certified* run's union bound over ~10¹¹ absent probes forces the fp back toward ~40
  bits ⇒ the realistic certified store is **~25–45 bits/node ≈ 1.2–2× the flat slot, NOT the dreamed 5–13.**
  **⇒ Ranking is marginal/uncertain for certified n=18; the load-bearing lever is SKIP (cut the working
  set), and a flat TT on the skipped set is the pragmatic store.** This is exactly the user's instinct.

### 2. Validated skip[18,25] is verdict-preserving (the launch gate)
skip is **memo-only** (skip a pc band's TT entry/probe/put; the value is still computed) ⇒ verdict-preserving
by construction; confirmed: **n=12 second + iso-flat distinct 1,060,823 exact; n=14 second**, and skip
engages (n=14 iso-dense TT fill **1.2%→0.6%**, nodes +8.7% recompute). `iso-dense` has `skip18` default-on
for **all roots** (empty `skip18_squares`), so `QUEENS_SKIP18_PCS=18..25` engages for the one-giant-root
n=18 solve. (gates run on the znver5 `make release` binary.)

### 3. ★ LAUNCHED: n=18 skip[18,25] + 17 GB flat-TT run (tmux `queens:skip-flat-n18`)
Command (bare on the TTY, from `/home/tavis/src/othello-n18/rust`):
```
QUEENS_SKIP18_PCS=18,19,20,21,22,23,24,25 QUEENS_TT_SLOTS=2125000000 \
QUEENS_ROOT_TIMING=1 QUEENS_COLD=1 ./target/release/queens solve 18 iso-dense
```
- **`QUEENS_TT_SLOTS=2125000000` = 17 GB** (the prep banner says "9 GB" — **cosmetic bug**, `gb` is computed
  from the default `bits` not the slot override; RSS confirms **16.7 GB** actual). 17 GB = the proven-safe
  size on this 26 GB box; chose safety over max coverage for an unattended run (OOM = worst outcome).
- **[status @ ~5 min] 2.55 B nodes · 8.5 M/s (5s/15s) / 9.4 M/s cumm · rif 1 [I9] · 0/45 roots · RSS ~16 GB,
  6–7 GB free, zram flat 1.2 GB (NOT spilling).** Throughput is **~8.5 M/s, RAM-resident** — far above
  session --9's disk-BuRR (0.2 M/s) and the buggy flat run (1.8–6.9 M/s). skip[18,25] stores only pc≥26
  (~1.87–3.37 B) so the 17 GB TT (~1.5 B usable) covers far more than the buggy run's 12% ⇒ should thrash
  far less. **The open question only time answers: does the giant root I9 CONVERGE (0/45 → 1/45) or grind
  all night** (the buggy run never left I9 — but that was eviction at 12% coverage + the verdict bug).

### ★ MORNING BRIEFING / next steps
1. **Check the run:** `tmux capture-pane -t queens:skip-flat-n18 -p | tail -5` (widen first:
   `tmux resize-window -t queens:skip-flat-n18 -x 200`). Watch **roots-done** (0/45 → any progress = I9
   converged = skip+flat-TT WORKS at n=18, the headline) and the **rate** (steady ~8.5 M/s = healthy; a
   collapse = thrash). `free -g` for memory (stable ~16 GB RSS = fine). The `QUEENS_COLD` cold-band report
   prints at root completion (the thrash/reuse signal). It is **NOT resumable** (flat TT) — if killed, relaunch.
2. **If I9 converged / progressing:** skip+flat-TT is the n=18 path on commodity RAM. Consider a bigger TT
   (a 32–64 GB box → no eviction → faster) or skip deeper ([18,26]/[18,27]) to fit the dev box with zero
   eviction (survivors ~1.6–3 B; see the --10 TT-fit table).
3. **If I9 thrashing (rate collapsed / 0/45 after hours / RSS pinned + nodes ballooning):** stop
   (`tmux send-keys -t queens:skip-flat-n18 C-c`) and relaunch with a **deeper skip** (`QUEENS_SKIP18_PCS=18..26`
   or `..27`) so the survivor set fits the 17 GB TT without eviction (the eviction-free regime), or move to a
   bigger-RAM box.
4. **The (b) ranked store is NOT worth building** for a certified run per §1 (ranking ≈ 1.2–2× the slot,
   uncertain); skip + a flat TT on enough RAM is the pragmatic n=18 solver. The combinadic primitive is
   banked for if that conclusion is ever revisited.

Commits: `queens-n18` `db949d7` (combinadic + measurement); docs on `main` (this note).

## Handoff Note — 2026-06-24 (session --11) — the GATING per-shard DENSITY measurement: (b) sub-RAM store VIABLE at fine sharding

**The one remaining store-layout measurement (session --10's headline next-step) is DONE. Verdict: subtree-local deep
domains DENSIFY strongly — the (b) sub-RAM store fits the 26 GB dev box.** Built the clean instrument, sidestepping the
confounded in-search shard tap (the `par_wins_inc` path-threading-across-rayon mess) with a direct, rigorous test.

**The instrument (committed `queens-n18` `209a96e`, gated/test-only, production byte-identical; gates green — `make test`,
n=12 distinct 1,060,823, clippy/fmt):**
- **`Queens::reachable_deep_from(blocked, pc_min, cap)`** — forward BFS from a prefix P that **stops descending the
  instant a child drops below `pc_min`**, so it enumerates ONLY the narrow deep band (pc 24→pc(P)), not the 42× full
  subtree that killed C2. Deduped by `pos_key` (D4 canon = the deep store's `d4_bits∘lex_min8` granularity), so the count
  is directly comparable to `present`. The trick that makes "reachable" (the thing too big to enumerate, by definition)
  tractable: cut at the deep-band floor.
- **`model::deep_present_count` / `deep_present_per_pc`** + `wins_model`'s `QUEENS_MODEL_QUIET=1`.
- **`model_n18_density_sweep`** test: treats an `--after`-style prefix as ONE shard; `density = present / reachable`
  (present = pc≥24 store nodes in P's α-β proof DAG; reachable = pc≥24 forward-reachable from P = the rank *domain*).
  Greedy diversified legal prefixes; sweeps shard depth; `QUEENS_REACH_BREAKDOWN=1` = the per-pc view.
  Run: `QUEENS_PAR_DEPTH=1 QUEENS_MODEL=1 QUEENS_MODEL_QUIET=1 QUEENS_SKIP18=0 QUEENS_REACH_TARGETS="44,56,70,90" cargo
  test --release model_n18_density_sweep -- --ignored --nocapture`. (`QUEENS_PAR_DEPTH=1` is **required** — else
  `par_wins_inc` eats the top plies of the deep band before `wins_inc`/`record_edge` see them ⇒ `present` undercounts.)

**[measured n=18] density rises sharply as shards get finer (the structural prior CONFIRMED):**

| shard depth pc(P) | queens | density (present/reachable) | 1/density | regime                          |
|-------------------|--------|-----------------------------|-----------|---------------------------------|
| 58–63             | ~7     | 0.023–0.059                 | 17–43×    | ≈ the global 1/42 — sparse       |
| 50–51             | ~8     | **0.085–0.12**              | 8–12×     | past the 1/8 win line            |
| 41–48             | ~8     | 0.06–0.92 (high variance)   | 1–16×     | mostly dense                     |
| 31–36             | ~9     | **0.82–1.00**               | 1.0–1.2×  | nearly fully dense               |

(Global deep ratio = 42× ≈ density 0.024. n=12 control: 0.64–1.0 — dense, but tiny board.)

**[measured] per-pc BREAKDOWN (one pc(P)=58 prefix, the granularity-free view):** the deep-store MASS is **bottom-heavy**
— pc 24–30 = ~88% of `present` (the mass is at low pc, near the skip boundary, as hoped). But within ONE shallow subtree
the density is **U-shaped**: the very bottom pc 24–27 is *sparse* (0.014–0.056 — `reachable` fans out hugely there:
1813 at pc24 vs present 53), pc 28–30 is *dense* (0.18–0.34). **Resolution:** density is fundamentally about **shard
granularity**, not pc — a *fine* shard (pc(P)≈30 prefix) covering those same pc 24–27 nodes has a small local fan ⇒ dense
(~0.9, per the sweep); the shallow subtree's per-pc view conflates the fan from all intermediate branches. So fine
sharding *captures* the density; the conclusion is granularity-dependent.

**★ THE DECISION — (b) is VIABLE; it gets n=18 onto the 26 GB dev box, ~2–3× under (a)'s box.**
- A keyless per-shard rank stores ~2 bits per *domain* slot ⇒ **`2/density` bits/node**. At the practical fine-shard
  granularity (pc(P)≈40–50, density ~0.10) that's **~20 bits/node ideal** vs the **58–64-bit flat slot** ⇒ **~2.9×
  shrink**. With realistic erosion (combinadic/MPHF overhead + the measured 1.1–1.6× cross-shard duplication) call it
  ~20–30 bits/node ⇒ the **~2.8–5 B deep set → ~9–19 GB → FITS the 26 GB dev box** (vs (a)'s 32–64 GB flat-TT box).
- **NOT the dreamed 10× / ~2–8 GB** — that needs either *very*-fine sharding (pc(P)≲35, density 0.5–0.9 → ~2–4 bits/node
  keyless, but a huge shard count + paging + duplication pressure) OR the theorem-impossible global fp-free rank. The
  density confirms the dense-slice keyless tier *pays only at very-fine granularity*; at moderate-fine it's ~par with an
  MPHF+miss-guard (~7–16 bits/node).
- **(a) stays bankable:** skip[18,~25] + a flat 55-bit-fp TT on a 32–64 GB box — no ranking, fast, trustworthy.

**Caveat (the honest gap):** the measured density is `present/reachable` = the **IDEAL-rank ceiling**. The achievable
combinadic-rank density is `present/(combinadic-domain)` ≤ this, and the per-shard combinadic gap is **unmeasured** (the
ranking proposal's job). So this confirms the *prerequisite* (the domains are dense enough that ranking *can* pay) and
sizes the *upper bound*; it does not yet pin the real bits/node.

**⇒ NEXT (implementation, not more density research): the ranking proposal's per-shard rank.** Build the per-shard
combinadic/MPHF rank ([proposal-2026-06-24-deep-tt-ranking.md]), measure the **REAL** bits/node (combinadic gap +
duplication) and the **shard-count ↔ paging block-size ↔ duplication** tradeoff (very-fine = cheaper bits but more
shards). Fastest route to a real n=18 run remains **(a): skip[18,~25] + flat TT on a 32–64 GB box** — the ranking is the
bet to land it on the 26 GB dev box. Raw sweeps saved in `scratchpad/n18-density-{deep,map,focused,breakdown}.txt`.

## Handoff Note — 2026-06-24 (session --10) — store-layout MODEL (contiguity vs transposition): parent-contiguity wins, two-tier dead

**The RocksDB fork is the live work. Before building, the user steered it to the right design and asked to MODEL the
core tension first** (the project's measure-before-build discipline). Sequence of user steers, all confirmed by the model:
(1) shard/bulk-fetch children, (2) "cut out the random child-by-child IO," (3) "think about key size vs block size,"
(4) "we are going to have to pay for speed with some re-exp." The unifying realization (the "key size vs block size"
lesson): a value is **1–2 bits** but a RocksDB point-get faults a whole **4 KB block** ⇒ ~250× read-amp on the record,
and the disk caps at ~56K random 4 KB reads/s. **Batched `multi_get` of *random* keys does NOT help** (still N block
reads, just pipelined, to the 56K-IOPS wall). The only structural lever is **contiguity** — lay a parent's gathered
children out adjacent so one block/range read returns the whole batch (~250× headroom). That fights canonical
transposition-merging (a hashed canonical key scatters siblings; a parent-relative key co-locates them but forfeits the
cross-parent merge = the +94% "move-ordering-is-2×" trap). So: **model the re-exp cost of parent-keying, by pc band.**

**Built `M_MODEL` (`QUEENS_MODEL=1`) — a gated measurement twin of M_ORD_W** (like M_RANK/M_COLD; const-MODE gated ⇒
production byte-identical, DCE off). It taps the **real store-node proof DAG** in `iso_flat.rs` `wins_inc` gather: each
canonical store node (pc > getK ceiling) is expanded once and emits one edge per recurse child it probes, so **edge-count
per child = its in-degree = distinct parents that store-probe it = its re-exp factor if children were keyed by parent**.
Also tallies `nw` (store-children-per-parent = the bulk-fetch batch). Global `Mutex<HashMap>` accumulator + per-pc report
(`src/queens/model.rs`); single-thread small-n runs. **UNCOMMITTED** on `queens-n18` (instrument is throwaway/diagnostic;
commit if we keep it). Gates not re-run (measurement-only, DCE off — but should `make test` before any commit).

**[measured] parent-key blowup E/N (= re-exp if EVERY store node keyed by parent, zero canonical merge):**

| n      | scope            | store nodes | E/N blowup | two-tier knee: RAM nodes for 90% of merges |
|--------|------------------|-------------|------------|--------------------------------------------|
| 12     | full board       | 77,488      | **1.445×** | 32% of N                                   |
| 14     | full board       | 5,150,461   | **1.551×** | 39% of N                                   |
| 16     | one root\*       | 33,929,643  | **1.664×** | 46% of N                                   |
| **18** | continuation\*\* | 620,262     | **1.651×** | 42% of N                                   |

\* `QUEENS_ONLY_ROOT=119` — a **lower bound** (a single-root run misses the cross-root transpositions the shared TT
merges on the full board). \*\* **REAL n=18** via `wins_model` on the completable continuation `--after A1 C2 E3 G4 I5`
(squares 0,20,40,60,80; 114 avail; mover **loses**, matches the certify-validated verdict for that line) — genuine n=18
high-square geometry that sweeps the full near-frontier. **The blowup PLATEAUS at ~1.65× (measured at n=18), it does NOT
explode** — the earlier "1.8–2.5×" extrapolation fear is retired. (A continuation is a slice; the full board adds some
cross-opening-line merges ⇒ full-board n=18 is ≳1.65× but the 4-point consistency 1.45–1.66 bounds it well under the
"~10× IO win" — the trade is robust at the target.) **Opening-stable:** a structurally different line (knight-spaced
`--after 0,21,43,66,88`, 123 avail, mover **wins**, 1.8 M store nodes) gives **1.575×** / knee 41.5% — both n=18 openings
land ~1.58–1.65× across *opposite* verdicts, so the blowup is a property of the near-frontier transposition density, not
the opening.

**Three conclusions (the verdict):**
1. **Two-tier (RAM canonical TT for the hot merges + disk contiguity for the rest) is DEAD at n=18.** The merge value is
   *distributed*, not concentrated — the knee is shallow and **worsens with n** (32→39→46% of N for 90% of merges).
   At n=18 that's tens of GB resident on a 26 GB box. No cheap "keep the hot merges" — the rest *is* most of it.
2. **Parent-contiguity wins, and the re-exp is cheaper than 1.5× looks.** The re-expanded nodes are the **near-frontier**
   (pc 18–22, the IO mass) which have **nw≈0** — their children are all getK leaves ⇒ re-expanding one is a **bounded
   getK sweep, never a deep subtree** (exactly the `skip18` property). You trade ~1.5–2× cheap RAM-served re-sweeps for a
   ~10× cut in cold block-reads (off the 56K-IOPS wall). Lopsided win in the disk-bound regime.
3. **The batch grain is the GATHER, not the node.** Near-frontier parents have nw≈0 (nothing to batch at *them*), but the
   near-frontier nodes are **fetched in bulk by mid/early-game parents** (pc 24–30+, nw=6–32) — the majority of store-gets
   come from those big-batch gathers. "Cut random child-by-child IO" = key each parent's gathered children contiguously
   (`parent_id ++ child_idx`) and range-read them — exactly what a sorted RocksDB key gives and the random-hashed BuRR
   key never could. (n=14 near-frontier mass pc19–21 = ~53% of nodes at indeg 1.21–1.37× = cheap to lose merges on;
   re-exp cost concentrates in the mid-shoulder pc24–29 at indeg ~2.1×.)

**★ PER-PC COST/BENEFIT (user directive) — SKIP the near-frontier, don't store it.** The big reframe: storing a band
costs `(E-N)` NVMe reads on its reuse-hits (~100µs each at n=18) + `N` resident values; *skipping* it (no TT entry,
recompute on every reach) costs a **bounded getK sweep** (~ns) **iff the band's children are getK leaves** (nw≈0). At
n=18 disk-read ≫ getK-sweep (~1000×, vs ~10× when n=16 was RAM-resident), so storing a low-nw band is net-NEGATIVE.
Baked a skip-ceiling sweep into `M_MODEL`. **[measured n=18, `--after A1 C2 E3 G4 I5`]** cumulative SKIP of `[18, pc*]`:

| skip ceiling | nodes eliminated | reuse NVMe-reads elim | cascade (mean nw over skipped) |
|--------------|------------------|------------------------|--------------------------------|
| skip 18      | 13.9%            | 17.4%                  | 0.00 (skip18 — already a default lever) |
| skip 18–21   | **51.0%**        | **51.4%**              | 0.04 (children still ~100% getK ⇒ FREE) |
| skip 18–22   | 62.8%            | 58.8%                  | 0.15                            |
| skip 18–26   | 83.1%            | 69.8%                  | 0.98 (edge: ~1 store child each) |
| skip 18–30   | 87.3%            | 79.2%                  | 2.07 (cascades — recompute recurses) |

**Verdict:** the near-frontier is the bulk of the nodes AND the entire disk-bound problem AND the cheapest to recompute
— so **skip `[18, ~22]` for a clean ~60% working-set + disk-read cut at zero cascade** (extend toward pc 26 for ~83%/70%
as the cascade approaches 1). This **generalizes the existing `skip18={18}` lever** to a tuned `[18, pc*]` skip band, and
inverts the earlier "store everything, lay it out well" framing → **store almost nothing near the frontier.** The
*stored* set then collapses to the deep bands (pc ≳23–27): far fewer nodes, high reuse + deep (expensive) recompute = the
bands where a TT entry actually pays, AND where the gather batches are large (nw 16–32) so the **locality-preserving key**
(below) earns its keep. The two levers compose: **skip the near-frontier, locality-key the deep remainder.**

**★ SKIP [18,23] → 17 GB TT FIT PROJECTION (user directive).** The existing skip lever is already a configurable pc-band
SET — `QUEENS_SKIP18_PCS` (`skip18_pcs: u64` bitmask, default `{18}`), per-root via `QUEENS_SKIP18_ROOTS`, + a fractional
`QUEENS_SKIP18_FRAC` — so "skip [18,23]" is just `QUEENS_SKIP18_PCS=18,19,20,21,22,23` (no new code; the one change is
flipping `new_dense_burr`'s `skip18=false` line, set under the old "keep pc==18 for the eviction-free store" directive,
which this reverses). [measured n=18 continuation] projecting the survivor set (pc>pc*) onto the full-board total (≈10–18 B
distinct; the 17 GB TT = 2.125 B 8-byte slots, ~1.5 B usable at 0.7 load):

| skip ceiling | survivor %N | proj survivors @ 10/14/18 B | TT GB @100% (14 B) | fits 17 GB? |
|--------------|-------------|------------------------------|--------------------|-------------|
| skip [18,23] | 28.2%       | 2.82 / 3.95 / 5.08 B         | 31.6 GB (1.9×)     | no (~25–46 GB needed) |
| skip [18,25] | 18.7%       | 1.87 / 2.62 / 3.37 B         | 21.0 GB (1.2×)     | borderline (low total) |
| skip [18,26] | 16.9%       | 1.69 / 2.37 / 3.04 B         | 18.9 GB (1.1×)     | at low total |
| skip [18,27] | 16.0%       | 1.60 / 2.24 / 2.88 B         | 17.9 GB (1.1×)     | at low total |

**Reading:** skip [18,23] alone does **not** fit a 17 GB TT — survivors ≈ 2.8–5 B (needs ~25–46 GB) — but it **shrinks the
resident requirement ~3–4× (from 8× over → ~2× over)**. To actually fit a 17 GB TT you skip to **~pc 26–27** (survivors
~1.6–3 B, fits at the lower total estimates) OR keep skip [18,23] and use a **24–32 GB TT**. (Caveats: the survivor
*fraction* is the continuation's band shape — the buggy-run probe shape put pc≥24 nearer ~21% than 28%, so survivors may
be a touch lower; the 10–18 B total is itself an estimate. The recompute/re-exp *cost* of skipping rises with depth — the
cascade column hits ~1 at pc 26 — so the cheap-getK-sweep regime is roughly skip ≤ 25.)

**★★ THE CAPACITY REFRAME.** Session --9 concluded "capacity is the wall → needs a 192–256 GB box or a cluster." The skip
lever **knocks that down by an order of magnitude**: skip [18,~25] holds the deep set in **~21–32 GB**, i.e. a **plain flat
TT on a 32–64 GB box — no disk spill, no BuRR, no RocksDB at all** (the flat TT is fast AND trustworthy: 55-bit fp ⇒
eviction = recompute-not-wrong). Only the *high-total* case (≈18 B ⇒ ~5 B survivors at skip [18,23]) still spills, and only
then does the disk store + the locality key below come into play. So skip is the **primary** capacity lever; the disk-store
fork is now the *fallback* for the pessimistic total. This is the strongest single result of the layout modeling.

**★ LOCALITY-PRESERVING KEY — design doc DONE (Opus sub-agent):**
[proposal-2026-06-24-locality-preserving-tt-key.md](../proposal-2026-06-24-locality-preserving-tt-key.md) (on main,
uncommitted). It **proved a key negative that corrects the earlier hope here:** "siblings share the parent's placed-queen
prefix ⇒ cluster" is **DEAD** — each sibling independently re-canonicalises under D4 into a possibly *different* orbit
(~7/8 of sibling pairs flip orientation), so any placed-queen-prefix / occupancy-lex key **scatters** siblings. The
scatter is at the symmetry-selection step, not the hash. **The locality that survives canon is NOT descent-path adjacency
— it is band/shape adjacency** (reuse here is transposition-driven; transpositions cluster by `(popcount, coarse occupancy
region)`, not by parent). **Resolution:** don't make canon order-preserving (impossible) or canon-relative-to-parent
(breaks sharing) — derive a routing ordinal *from* the canonical representative: **`routing_key = pc_band(high) ++
hilbert_d4canon(occupancy descriptor) ++ fp_low`.** `pc_band` is the **provable floor** (D4-invariant, reuse is intra-band,
the store only holds pc≳24 anyway); `hilbert(canon-occupancy)` is measurable *upside*; `fp_low` packs blocks uniformly.
**Sidecar:** sort by routing_key, fixed 256 KB–1 MB blocks, Syzygy-style two-level sparse index (kills the O(S) Bloom walk
— the RocksDB-eval premise — by routing to one block by key-range), per-gather async prefetch, BuRR ribbon as the in-block
value payload. **Metric = locality factor L** = useful entries per block-load (target ≳16–32). **§6A bit-shaving:**
structural key = collision-free at ~½ the 54-bit fp; front-codes to ~5–11 bits/key; **dense deep slices drop keys entirely
→ direct-indexed bitmap ~1–2 keyless bits/position — below BuRR's ~2–3 + its ~15 GB Bloom ⇒ a sorted structural store with
per-slice tiering (dense→bitmap / medium→front-code / sparse→MPHF/BuRR) SUBSUMES BuRR** (beats it on routing, range-read,
RAM, density; BuRR survives only as the sparse fallback). **Biggest risk:** if reuse is dominated by *long-range*
transpositions (a position reached from two distant openings), no occupancy ordering clusters them and only the pc-band
floor pays — **THE thing the instrument must measure first.** §6B: generalized/set-based entries (Kobayashi FPT / Partition
Search / setrograde) = a structural-merge crack, flagged for a cheap read-only probe (prior lit-triage measured module
*reduction* absent, but never twin-multiset *keying* at the skip/store boundary).

**→ NEXT (the gate, doc §7): build the reuse-locality + density instrument, measure, THEN decide.** Extend `M_MODEL` to
tag each node with candidate keys and report, per key/block-size: (1) bucket population, (2) **★ L = intra-block reuse-hit
fraction** for `hash128`(L=1 control) / `pc_band+fp` / `pc_band+morton` / `pc_band+hilbert`, (3) per-gather block-span,
(4) LRU warm-hit curve, (5) **long-range transposition fraction** (Risk #1), (6) **★ slice density** (present/domain per
slice key — `(pc_band, k-queen prefix)` k∈{6,8,10}, 4×4 histogram, centroid — the **bitmap-tier gate**), (7) twin-multiset
generalization factor (cheap add-on). **Decision rule:** ship `pc_band+hilbert` iff its L ≥ ~2× the `pc_band+fp` floor AND
gather-span median ≤2; else ship the bankable pc-band floor. **Do NOT build the sidecar before the instrument confirms
L > floor** — pc-band floor is bankable, Hilbert is the bet under test (measure-before-build, the discipline that killed C2).

**★★ COST-MODEL INVERSION (doc §1.0/§1.0.1, the load-bearing strategic shift).** At n=16 a lookup ≈ compute (RAM), so the
project banked "node-reduction levers that cost compute are net-negative" (iso graph-key ~2.2× slower despite 3.4× fewer
nodes; component-nimber −74% nodes at 6.6× compute — both MEASURED-NEGATIVE on **wall-time**). **At n=18 the binding
constraint is CAPACITY-to-fit, not speed**, and in the disk-spill regime a lookup costs ~1000× a getK recompute. So the
governing rule flips to **"trade compute for I/O / for a smaller stored set, up to ~1000:1"** — which **inverts those banked
negatives**: a costlier canonical key (stronger D4/iso/twin-class merge) or a component-nimber decomposition that *shrinks
the deep distinct set* is now worth it, because (a) fewer distinct nodes = fewer 1000×-cost lookups, and (b) a smaller set
is more likely to FIT (the actual open problem). The doc **reprioritizes**: re-test the **stronger-canon store-shrinkers
FIRST** (metric = deep-distinct-count reduction on pc≳24; gate ≥1.5× cut → adopt regardless of per-node compute), because
that changes the size of the set every later lever operates on — *then* the locality/density instrument, *then* the sidecar.
**Caveat (the regime gate):** the inversion's strength is conditional on STILL spilling. If skip `[18,~25]` makes n=18
RAM-fit (≈21–32 GB, see the TT-fit projection), lookups are RAM (~10×, n=16-like) and the inversion weakens — though a
store-shrink still helps by lowering the box/TT size needed. **So the gating unknown is the n=18 deep distinct TOTAL
(RAM-fit vs disk-spill); estimate it (HLL) before committing to the disk-store track.**

**[measured 2026-06-24 — the two gating measurements (user: "yes, measure")]:**
- **Regime (deep fraction is STABLE; the total is the swing).** Two n=18 continuations (A1C2E3G4I5 = loses, 620 K store
  nodes; A1C2E3G4 = wins, 414 K) give the **same deep-survivor fraction ~28% at skip [18,23]** and the **same TT-fit
  projection (~1.8× a 17 GB TT @ 14 B total)**. (Continuation *size* tracks win/loss — the mover-loses line is bigger, must
  prove all moves — not opening depth, so absolute counts don't extrapolate; the *fraction* does.) **Verdict:** deep distinct
  ≈ 28% × (10–18 B total) ≈ **2.8–5 B → ~36–66 GB at 0.7 LF**. So n=18-after-skip is **NOT a 17 GB-TT fit, but IS plausibly
  RAM-resident on a 32–64 GB box** (skip [18,25] → ~19% → 1.9–3.4 B → ~24–43 GB; skip [18,26] → ~17% → fits 32 GB at the
  low-mid total). **The capacity wall drops from "192–256 GB box / cluster" (session --9) to "32–64 GB box, flat TT, no disk"
  — modulo the distinct TOTAL (10 vs 18 B), the one swing variable that decides RAM-fit vs the high-total spill.**
- **Skip re-exp cost = off the store ledger.** The skipped near-frontier resolves as **getK-leaf sweeps, not bumped store
  nodes**, so store-node expansions are UNCHANGED by skipping — the cost is getK work (≈ the skipped bands' in-degree ~1.58×,
  cheap). (The direct `wins_model`+skip run hit a wrinkle — `IN_SKIP18_ROOT` is thread-local and the deep search runs on
  rayon workers where it wasn't set, so the skip didn't engage; the analytic cost from the clean-DAG cost/benefit table
  stands. Propagating the flag to workers is a small deferred fix if a direct number is wanted.)
- **★ STRONGER-CANON STORE-SHRINK TEST — DONE, MEASURED-NEGATIVE (commit pending).** Extended `M_MODEL`
  (`QUEENS_MODEL_STRONG=1`) to re-key every store node under `iso_key_fast` (the production-candidate graph-iso canon =
  exact iso-class merge) and count the distinct collapse vs the current D4 key, per band. **[measured n=18 A1C2E3G4I5]:
  DEEP (pc≥24) shrink = 175,085 → 167,598 = 1.045×** (overall 1.041×; per-band 1.01–1.09× everywhere) — **far below the
  1.5× gate.** So a stronger canonical key does NOT shrink the deep store, and the cost-inversion's "adopt a costlier key"
  is net-negative for the deep bands (≈2× compute for ~4.5% fewer nodes). **Mechanism (why, and why it generalizes):**
  graph-iso merging beyond D4 lives in *sparse* positions — isolated vertices / small scattered conflict graphs (low pc) —
  which at n=18 are exactly the **near-frontier we SKIP**, not the **dense, connected deep bands we store**. The same logic
  kills component-nimber decomposition as a deep-store shrinker (independent components ⇒ disconnected ⇒ sparse ⇒ low-pc,
  also skipped). **⇒ The deep store size is IRREDUCIBLE by canonicalization/decomposition.** The only levers on it are
  **skip-depth** (recompute), **representation** (bitmap/structural encoding), and **capacity** (RAM/zram/disk). So the path
  is unchanged: skip the near-frontier + fit the (irreducible ~2.8–5 B) deep set on a 32–64 GB box, with the
  reuse-locality/density instrument + sidecar as the high-total fallback. The cost-inversion remains true in spirit (trade
  compute for I/O) but its specific node-reduction hopes are pruned by this measurement.
- **★ DENSITY/BITMAP TEST — DONE, bits/node ALSO ~irreducible without a ranking (commit pending).** Extended `M_MODEL`
  (`QUEENS_MODEL_DENSITY=1`) to record the DEEP (pc≥24) canonical occupancy masks (`lex_min8`) + measure structural
  compressibility. **[measured n=18 A1C2E3G4I5, 175 k deep masks]:** raw mask 384 bits/node; current hash slot 64; naive
  sorted delta-coding ~350 (fails — masks are *sparse* in 384-bit integer space); **zstd-19 = 70.8, xz-9 = 57.7 bits/node**
  — i.e. general compression lands at **≈ the 64-bit hash slot** (deep store ~20–36 GB either way). **No bitmap floor on
  this sample.** Caveat: it's a sparse 175 k slice of the ~5 B set; the full board is ~1000× denser ⇒ likely pessimistic.
- **The fingerprint/correctness FLOOR is the real wall.** A *certified* TT needs ~54-bit collision-safety per key (a false
  key-match = a wrong value = a wrong verdict). So any hash-based store — flat TT, MPHF+fp, xz-of-masks — floors at fp(54)
  + value(2) ≈ **56–64 bits/node ⇒ ~35 GB**. The only escape to the **~7-bit floor** (log2(reachable/present), reachable ≈
  42× present ⇒ ~4–6 GB, laptop-class) is **a bijective RANK into the reachable domain** — because then every offset is a
  real position, so there are NO false matches to guard against and the 54-bit fp *vanishes* (value's "unknown" state IS
  the miss). This is exactly how chess/checkers endgame tablebases (Nalimov/Syzygy) index positions into dense WDL tables.
- **Background-encoder architecture (user) — sound but its two legs are weak as-is:** (1) the orbit-expansion leg (one
  completed iso-key → many positions via the inverse map) buys ~nothing on deep bands (iso-merge 1.045× = singleton
  classes), so it reduces to a *forward* encoder; (2) the compact-archive leg only pays if the encoding actually compresses,
  which (per above) it doesn't without a ranking. The architecture becomes worthwhile IFF the combinatorial rank exists.
- **★ DECISION (user): pursue (b) — CHASE THE RANKING.** The combinatorial-rank path is the one lever that breaks BOTH the
  bits/node floor AND the fp floor (→ ~4–6 GB, fits the dev box). Launched a deep scoping sub-agent
  ([proposal-2026-06-24-deep-tt-ranking.md](../proposal-2026-06-24-deep-tt-ranking.md), pending): combinatorial rank/unrank
  of canonical non-attacking game states, the tablebase-indexing prior art (the closest precedent — they solve exactly this),
  whether a bijective rank removes the fp floor, MPHF + background-rebuild as the fallback, and the first measurable step.
  Deep keys dumped at `/tmp/queens-deep-masks.bin` for prototyping. **The (a) fallback stays bankable: skip + a flat TT on a
  32–64 GB box solves n=18 regardless** — the ranking is the bet to get it onto the 26 GB dev box (or a laptop).

## Handoff Note — 2026-06-24 (session --10 cont.) — the CONVERGENCE: subtree-sharded + duplication + paged + per-shard rank

Three measurements + a ranking-scoping agent converged on one architecture. **Instruments committed on `queens-n18`** (all
gated, byte-identical off): `M_MODEL` key sweep (`QUEENS_MODEL_DENSITY`) + cross-root duplication (`QUEENS_MODEL_DUP`).

- **Key/representation SWEEP — general compression floors at ~58 bits/node, nothing beats it.** Crossed {raw 384-bit mask,
  u16 square-list, delta-coded squares} × {by-mask, by-pc, by-shape, by-centroid} and xz/zstd'd each: raw-mask+xz **57.7**,
  sqlist 64.5, delta 72+ (delta-coding STRIPS the bitmask structure xz exploits). The shape shard key (pc+3×3 histogram)
  **fragments** (148 k shards / 175 k masks ≈ singletons) and *hurts* (71 bits). ⇒ **No representation/ordering beats ~58
  bits via general compression.** Sub-58 needs a domain RANK, not a better compressor.
- **★ CROSS-ROOT DUPLICATION — the user's "duplication OK" bet is VALIDATED.** [measured n=14 full board, 2.05 M deep
  positions] **mean distinct roots/position = 1.109×; 89.3% reached from a SINGLE root** (10.4% from 2). So sharding by root
  (coarsest subtree) + duplicating costs only ~11%. Bracketed: root-level 1.11× → parent-level 1.6× (the measured blowup),
  so **subtree-sharding duplication ∈ [1.1×, 1.6×] at ANY granularity** — cheap throughout, far below the re-exp we already
  pay with skip. (Caveat: n≤16 only — the root bitmask caps at 64; n=18 has ~81 roots. Signal is strong.)
- **★ RANKING scoping ([proposal-2026-06-24-deep-tt-ranking.md](../proposal-2026-06-24-deep-tt-ranking.md)) — the fp-free
  global rank is THEOREM-impossible, but per-shard ranking still gets to ~5–13 bits/node.** Two hard walls: (1) **no
  closed-form rank** for the feasible/reachable non-attacking set (n-queens counting is beyond #P; the only closed bijection
  — the combinadic over all k-subsets — addresses a set 10²–10²¹× too sparse); (2) **a TT probes MISSES by design** (unlike
  tablebases, which only probe legal solved positions), so even an MPHF *relocates* the fingerprint, not removes it. **So the
  ~54-bit fp is SHRUNK, not removed** — to a **3–11-bit per-slice miss-guard** via density+slicing+sorting ⇒ realistic deep
  store **~5–13 bits/node → ~2–8 GB → fits a 32–64 GB box outright** (the dense-slice tier — a keyless packed value-array
  indexed by an in-slice rank — recovers most of the ~7-bit prize *locally* where density holds). Prior art (Nalimov/Syzygy/
  Chinook/Awari) confirms the mechanism: slice by a monotone invariant (our **pc band = their stone-count layer**) + combinadic
  rank within slice + Syzygy two-level sparse index + Nalimov's D4 fold (= our exact D4) — borrow the slicing, not the
  fp-free property.

**★★ THE CONVERGED ARCHITECTURE (both the user's paged-shard idea and the ranking path are the SAME density lever through
two cache layers):**
1. **Shard by access-locality** (DFS subtree-prefix), NOT a canonical key — dissolves the canonical-vs-locality deadlock
   (no single key need be both shared and local). Maps onto Korf SDD/HBDDD (shard = duplicate-detection scope).
2. **Duplicate across shards** instead of sharing — measured cheap (1.1–1.6×) on the 1.4 TB pool; wins the binding
   **resident-RAM** axis (only the active DFS path's shards resident).
3. **Page shards in/out** on subtree entry/exit (the locality that fixes session --9's random-read thrash → sequential-ish).
4. **Rank within each shard** for density — `rank-within-shard` IS the per-shard density mechanism (the ranking path and the
   paging path are the same lever). ~5–13 bits/node where the shard is dense.

**⇒ DECISION TURNS ON ONE MEASUREMENT (next): per-shard DENSITY for subtree-prefix keys k∈{6,8,10,12}** — is a subtree-local
domain dense enough that per-shard ranking pays (≥⅛ crossover), or still ~1/42 sparse? (The structural prior favors dense:
deep = near-terminal = few completions; the prefix prunes infeasible directions.) Plus the paging reuse pattern (intra- vs
cross-shard) + a combinadic rank/unrank bijectivity check on n≤12. This is the harder instrument (threads the k-prefix
through the search); the access-local subtree key is the one to model (shape-key is dead). **(a) fallback stays bankable:
skip + flat TT on a 32–64 GB box. The bet now: subtree-shard + per-shard rank → ~2–8 GB → the 26 GB dev box.**

**★ SUBTREE-PREFIX SHARD INSTRUMENT — BUILT + first signal (leaning-negative, CONFOUNDED).** `M_MODEL`
(`QUEENS_MODEL_SHARD=1`, `QUEENS_SHARD_K`) threads the `wins_inc` ancestor path (a Drop-guarded thread-local stack) and
shards deep positions by their k-th ancestor. **[measured n=18 continuation, k=3]:** 75,902 deep positions · **duplication
1.31×** · 15,541 shards · **mean 6 deep positions/shard** (deep nodes spread thin, do NOT cluster densely) · **within-shard
xz 58.8 ≈ the global 58** (subtree-sorting does not densify) · +13.9 bits shard-id ⇒ total *worse* than global. **Leaning
NEGATIVE for the (b) per-shard-density bet** — but three CONFOUNDS make it inconclusive, and fixing them is the next-session
job: (1) **`par_wins_inc` levels are off the path** — the parallel split eats the shallow queens, so the `wins_inc`-only
path is shallow (k=8 captured only 231 edges); push in `par_wins_inc` too for the full prefix. (2) **shards are tiny** (~6
positions) so xz can't show within-shard density (and its window spans shards anyway — it's measuring global, not
within-shard). (3) **the true density (present/DOMAIN) is still unmeasured** — needs the *reachable* count per subtree-shard
(`reachable_profile` restricted to the prefix), the actual ⅛-crossover test. **⇒ NEXT SESSION:** fix the `par_wins_inc`
path, run a k-sweep on a BIGGER subtree (fewer opening moves ⇒ shards large enough to compress), and measure present/reachable
per shard — the clean density signal. If shards stay sparse (~1/42, like the global), the (b) sub-RAM bet is dead and **(a)
the 32–64 GB box is the answer** (still an order of magnitude under session --9). If subtree-local domains are dense, (b)
lives. The instrument is in place; only the clean run remains.

## Handoff Note — 2026-06-24 (session --10, end) — store-layout modeling COMPLETE; the architecture is converged, one density measurement remains

**A long modeling session that took the n=18 store from "needs a cluster / 256 GB box" (session --9) to a concrete,
mostly-settled design.** No production code changed — all work is the `M_MODEL` instrument family (gated, byte-identical
off) + four design docs + the handoff. The arc, in order, each step measured:

1. **Layout model** (`M_MODEL`): in-degree/nw/cost-benefit/TT-fit. ⇒ **skip the near-frontier** (storing a cheap-recompute
   band is net-negative at n=18's ~1000× disk:recompute ratio) — `QUEENS_SKIP18_PCS=18..23` cuts ~60% of the resident set;
   deep survivors (pc≥24) ≈ 2.8–5 B ⇒ **32–64 GB box, flat TT, no disk** (the bankable answer (a)).
2. **Stronger-canon shrink:** iso_key_fast merges the deep set only **1.045×** — node count irreducible by canon.
3. **Compressibility sweep:** {raw mask, sqlist, delta} × {orderings} all ≥ raw-mask+xz **~58 bits/node** — bits/node
   irreducible by general compression.
4. **Cross-root duplication: 1.11×** (n=14) — the user's duplication-tolerant subtree-shard bet is cheap (≤1.6× at any k).
5. **Ranking scoping** (proposal): the fp-free GLOBAL rank is **theorem-impossible** (no closed-form rank; a TT probes
   misses); but per-shard slicing+ranking → **~5–13 bits/node → ~2–8 GB** (fits a 32–64 GB box, maybe the dev box) — the (b) bet.
6. **Subtree-prefix shard instrument** (this session's last build): first signal leans negative but is confounded (above).

**THE CONVERGED ARCHITECTURE** (both the user's paged-shard idea and the ranking path are the same density lever): **skip
near-frontier → shard deep by access-locality (DFS subtree) → duplicate across shards (cheap, 1.1–1.6×) → page in/out →
rank within each shard for density.** Resolves the canonical-vs-locality deadlock (duplicate instead of share) AND session
--9's random-read thrash (page local subtrees). Maps onto Korf SDD / Syzygy slicing.

**Commits (`queens-n18`):** `511dd60` (M_MODEL) · `ddeb961` (strong-shrink) · `b9a0dae` (density) · `d3152d1` (key sweep +
cross-root dup) · + the subtree-prefix shard instrument (this note's commit). **Docs (`main`):** `88d7cb7` · `bf78f8b` ·
`2841194` · `34a25dd` + this note. Design docs: `proposal-2026-06-24-locality-preserving-tt-key.md`,
`proposal-2026-06-24-deep-tt-ranking.md`.

**★ NEXT SESSION = the ONE remaining measurement (then it's implementation, not research):** clean per-shard DENSITY —
(1) push the path in `par_wins_inc` too (full prefix), (2) k-sweep {6,8,10,12} on a big subtree (large shards), (3) measure
**present/reachable** per shard (`reachable_profile` restricted to the prefix) = the ⅛-crossover test. **Dense ⇒ (b) the
~2–8 GB sub-RAM store (dev box); sparse ⇒ (a) the 32–64 GB box** — either way n=18 is solvable on commodity hardware, the
session's headline. Then: implement the chosen path (skip + flat-TT-on-a-bigger-box is the fastest route to a real n=18 run).
- **zram as a compute-for-capacity tier (user Q).** The box's swap is `/dev/zram0` (compressed RAM ~3.4× on compressible
  data) — a tier between RAM (~100 ns) and NVMe (~50–100 µs): a page-fault + decompress ~1–3 µs, i.e. ~10–50× slower than
  RAM but ~10–50× faster than NVMe (in the spirit of the 1000:1 inversion). **But the benefit is gated by compressibility,
  which is representation-dependent:** a hash-keyed flat TT slot (~54-bit *random* fp) is **incompressible** (~1×) ⇒ zram
  gives zero capacity, only decompress cost — it can't rescue the naive TT. The **structural/sorted/front-coded/bitmap** rep
  IS compressible — but it's also already small enough (~0.7–7 GB for the 2.8–5 B deep set) to fit RAM *outright*, so zram is
  largely moot if the structural rep works. zram's real niche is the **middle case** (a collision-free ~32-bit structural-slot
  store, ~12–20 GB, moderately compressible → zram ~2× turns a near-miss into a fit), and as a **faster-than-NVMe backing for
  the sidecar** (zram-backed compressed-RAM sidecar ≈ 100× faster spill than NVMe, within the box's ~88 GB effective). Add a
  **compression-ratio tap** (zstd/lz4 ratio of each tier's bytes) to the density instrument. (NB: the n=16 "zram OFF before
  benches" rule was *speed-bench hygiene* — don't let a silent spill fake a wall — a different goal from n=18 capacity.)

**A cold-data correction worth banking:** the first n=18 run's `QUEENS_COLD` showed pc 18–24 at ~99.7–100% cold — but that
was the **eviction-thrashing flat TT** (couldn't hold the set; re-reaches came back cold). Eviction-free, the in-degree
1.4–1.8× implies the near-frontier is ~**55–63% cold-miss / 37–45% reuse-hit**, not 99.9% cold. That split matters: the
cold-miss path is a *routing* problem (O(1) bloom reject — RocksDB/sized-prefilter), the reuse-hit path is the only thing
contiguity/the locality key can batch — and the skip analysis above removes most of *both* for the near-frontier.

**Open risk + next step.** The call rests on the blowup staying < ~2.5× at n=18 (the 3-point trend supports it, but n=16
full-board is unmeasured — the in-RAM map OOMs; sampling/HLL-per-node would extend it). The structural model proves the
DAG side; the remaining fidelity gap is the **actual IO** — it *assumes* near-frontier gathers are cold (handoff says
~all cold). **NEXT (proposed): a block-cache LRU replay** of the M_MODEL get-stream under each layout (canonical-hash vs
parent-contiguous) at a realistic RAM budget — turns "~10× fewer block reads" into a hard number and isolates the layout
effect — *then* prototype the parent-contiguous RocksDB layout (`iso-dense-rocks`, the spec in
[2026-06-24-rocksdb-store-evaluation.md](2026-06-24-rocksdb-store-evaluation.md)) with confidence. Decision (replay-first
vs build-now) pending the user. `M_MODEL` reports saved in `scratchpad/model-n{12,14,16-root119}.txt`.

## Handoff Note — 2026-06-24 (session --9) — LAUNCHED; diagnosed disk-bound; A+B+C throughput fixes + io_uring Step A

**The n=18 run was launched, ran ~1h, and exposed the real wall: it is NVMe-bound, not compute- or
memory-bound.** The disk-DDD fits n=18 on disk but pays NVMe random-read latency, and the box can't cache
the working set. Three throughput fixes landed + validated; the run was resumed, re-confirmed disk-bound,
then stopped to build the async-I/O lever (io_uring). **Run is STOPPED + resumable** (116 segments + manifest
+ 3.2 GB prefilter on the pool; resume = `QUEENS_BURR_RESUME=1 ./target/release/queens solve 18 iso-dense-burr`).

**The run (commits on `queens-n18`):**
- Launched bare on tmux `queens:iso-dense-burr` per the procedure. Ran **1h04m → 5.77 B nodes / 4.04 B keys /
  113 segments, never left root I9 (0/45), `full=0`**. Cumulative throughput decayed 6.9 → 1.8 M/s.
- **Diagnosed disk-bound.** ARC was capped 3 GB (the launch plan); raising `zfs_arc_max` 3→12 GB cut ARC
  demand-miss 88%→31% and iowait 70%→2% — which **exposed a 93%-CPU-idle parallelism deficit** in the
  giant-root serial-spine valleys (`rif 1`), plus recurring multi-second **drop-to-0 stalls**.

**Three Opus sub-agents (read-only, run untouched) — findings, all verified in code:**
1. **Bloom math:** the **shared prefilter is undersized** — `bloom_bytes_env = 0.2 × cap` (`store.rs:536`)
   was calibrated for the in-RAM era (cap bounded ribbons ≈ 10 bits/key); in disk mode cap bounds **Blooms**
   (`store.rs:511`), so it's **~1.6 bits/key at the 16 GB cap → ~95% FP → the O(S) segment-Bloom walk
   dominates** (the profiled 30% `Bloom::maybe_contains`). Compounds: FP-rate × S both grow with keys.
2. **Segment speedups:** the **live `IsoFlat` kernel's `mtt_prefetch` was a NO-OP** for the store
   (`iso_flat.rs:2099`; the `store.prefetch` calls were in the *unused* `Burr`/`IsoBurr`). mmap→pread is
   resume-compatible (format is access-method-independent). The **resident-Bloom cap binds at ~11.4 B keys**
   (50.3 MB/seg × 318 segs), *below* the 10–18 B distinct estimate → eviction would return.
3. **Stalls:** the drop-to-0s are **mmap demand-paging / refault**, NOT freezes (only 4% coincide; the freeze
   runs on a separate efficiency-core pool). `/proc/pressure/io full=67%`, ~77K/s major-faults ≈ 77K/s
   workingset-refaults, `MADV_RANDOM`. Stall fraction grew 0%→42% with on-disk size.

**A+B+C landed + validated + committed `3b36b2e` (segment-preserving, byte-identical search):**
- **A — `MappedArchive::get` reads each layer's band window via `pread`** (one contiguous read/layer) instead
  of mmap faults: kills the ~108K major-faults/s + the ZFS page-cache double-buffer; **ARC becomes the single
  ribbon cache**. `read_packed_window` mirrors `read_packed`; `mapped_archive_matches_in_ram` stays green.
- **B — wired the live `mtt_prefetch` into the store** (`prefetch_hashed(route, fp)` — was a no-op): warms the
  memtable slot + prefilter line one-ahead from the child's `(route, fp)`, no key re-hash.
- **C — MLP the per-segment Bloom walk** (`PF=12` prefetch-ahead) to overlap the O(S) resident-Bloom DRAM
  round-trips.
- **Gates:** lineage; n=12 iso-flat `--distinct` = **1,060,823** exact; **n=14 iso-dense-burr disk-off ==
  disk-on == 2,823,498 nodes** (pread e2e byte-identical), second; full `make test` green.
- **D (seg_bloom_bits 8→4) DEFERRED, not applied:** raising the cap to ~19 B keys would 6× the per-segment FP
  (13% vs 2.1%) → 6× more FP-walk **preads**, fighting A. Resumed with **seg_bloom_bits=8**; revisit only if we
  approach the 11.4 B-key cap. (E — `mem_bits` 26→28 to cut S 4× — parked; **can't apply on resume**, the
  manifest locks `mem_bits=26` to the snapshot, so E needs a fresh run.)

**Resume + post-fix measurement [measured]:** reloaded 113 segs + 3.2 GB prefilter cleanly. **A confirmed at the
mechanism level: major-faults 108K/s → 0, swap 1.3 GB → 0, ARC demand-miss 88% → 24%.** BUT throughput stayed
~0.26 M/s and **iowait 95%** — the run is now cleanly **NVMe-bound on cold ribbon reads** (working set 36 GB,
→ ~135 GB at full distinct, ≫ 26 GB box). Decisively: the NVMe is **UNDER-DRIVEN — 33K of ~56K IOPS** — because
the deep serial spine (parallelism deficit) issues **serial blocking preads**, keeping the device queue shallow.
This is past re-warm (it froze 2 new segments / +70 M keys), so ~0.26 M/s is steady-state new-work, not a transient.

**Strategy Q&A (user) — settled:**
- **Bigger flat TT (iso-dense)? NO** — the divergent-thrash trap BuRR escaped (the buggy n=18 flat-TT run:
  17 GB TT, 99.7% cold, 261 B nodes, didn't finish; eviction → unbounded re-expansion that may never converge).
- **Routing index in front of BuRR? Secondary** — aimed at the now-minor O(S) walk (~12% on-CPU), only ~2×
  (eliminates FP-triggered ribbon reads), RAM-blocked (~17 GB) + un-buildable from keyless ribbons.
- **Alternative disk index (RocksDB/redb)? Real** — gives compaction-routing (no O(S) walk) + async I/O +
  block cache out of the box, but a large rewrite, stores keys (~135 GB, fine), still disk-bound.
- **The wall is RAM capacity.** Every structure pays NVMe latency for the cold tail. The clean fix is
  **more RAM (~192–256 GB holds the working set in ARC → back to multi-M/s)** or the cluster; the cheap
  software lever is **fill the under-driven NVMe via async I/O**. **User chose io_uring.**

**★ io_uring async ribbon reads — Step A DONE, committed `6e89f9a`:** per-worker thread-local ring +
`batch_pread(BandRead[])` in `burr.rs` (submit many band-window reads, wait together). `batch_pread_matches_pread`
proves byte-identical to pread + ring reuse; skips where io_uring is unavailable. dep `io-uring = "0.7"`.
- **Step B — LANDED + MEASURED (`c05866c`):** batch the segment walk's Bloom-hit candidate ribbon reads through
  the ring (`MappedArchive::prefetch_window` / `SegArchive::prefetch_window` / a per-worker `WalkScratch`),
  warming ARC, then read in walk order. Byte-identical (n=14 disk-off==on==2,823,498). **[measured n=18, re-warm]
  iowait 95%→78%, ARC miss 24%→18%, but throughput FLAT ~0.2 M/s and pool IOPS FLAT ~30K — it does NOT fill the
  queue:** the within-walk batch overlaps only ~2–3 candidate reads and the thread **still blocks per-walk**
  (`submit_and_wait`). Net: a wash for speed. Kept as the foundation, not a win.
- **Step C — BUILT + MEASURED NEGATIVE, gated off (`7b55b6e`).** Frontier/children prefetch: an async
  fire-and-forget io_uring ring (`PrefetchRing`) + `BurrStore::prefetch_batch`, fired at descent *gather* time
  on the recurse children's `(route, fp)` (piggybacking the existing gather-time prefetch hook, routed to the
  store instead of the placeholder TT) to keep many NVMe reads in flight. Byte-identical (n=14 disk-off==on).
  **[measured n=18, re-warm] pool IOPS FLAT ~29K (no queue-fill), ARC miss 24%→13% (it does warm ARC), but
  throughput REGRESSED ~20–40% (158K vs Step B's 200K nodes/s).** Cause: the per-child O(S) prefetch Bloom walk
  doubles the dominant on-CPU cost, the speculative FP reads contend with the real gets on the NVMe, and the
  serial giant-root spine gives too little prefetch-ahead distance to hide latency. Gated OFF (`QUEENS_PF_URING=1`
  opts in) as substrate (a cheaper early-exit-walk variant is untried, not closed; useful on the cluster).

**★ CONCLUSION — single-box io_uring is measured-dead for this workload; the wall is capacity.** Primitive works;
**Step B = wash, Step C = regression.** The two things defeating async I/O are exactly the workload's shape: the
**serial giant-root spine** (can't issue enough independent reads ahead) and **working set ≫ RAM** (the cold tail
is genuinely on the NVMe). No amount of I/O scheduling changes either. **NEXT = capacity, not single-box code:**
a ~192–256 GB box holds the n=18 working set in ARC → the disk problem vanishes → back to the multi-M/s the run
showed before it spilled, and the **flat TT** (trustworthy: `Slot` 55-bit fp ⇒ eviction = recompute-not-wrong,
~2⁻⁵⁵ false-match = BuRR fp=54 class) is fast *and* correct there with no eviction — likely no BuRR needed at all.
Or the cluster (Phase D, TDS). The single-box software levers (pread ✓, prefetch-wire ✓, MLP walk ✓, async
io_uring ✗) are now **exhausted + measured**. Watch script: `scratchpad/n18-watch.sh`. Run STOPPED + resumable
(116 segments). Branch `queens-n18`: `3b36b2e` (A+B+C) → `6e89f9a` (uring A) → `c05866c` (uring B) → `7b55b6e` (uring C, neg).

**★ QUEUED (user, next session) — try RocksDB instead of the custom BuRR store.** The user's read is that the
**O(S) segment-Bloom walk is the dominating factor**; a mature LSM (RocksDB) routes a probe to one SSTable by
key-range (no O(S) walk) + brings async I/O + a block cache. Full self-contained spec:
[2026-06-24-rocksdb-store-evaluation.md](2026-06-24-rocksdb-store-evaluation.md). It's the "make disk-spill fast
on a small box" **fork** — an alternative to the capacity (big-RAM box) path, which makes the whole disk-spill
question moot. **Decide the fork with the user before investing.**

## Handoff Note — 2026-06-24 (session --8) — prefilter-on-resume + resume-hardening; cert strategy revised

**Landed on `queens-n18` @ `be40fe9`: prefilter-on-resume + the adversarial-review resume-hardening.**
Gates green (n=12 distinct 1,060,823, iso-dense-burr second n=12/14, lineage, clippy/fmt); the disk
fresh+resume round-trip is validated (verdict second, prefilter reloaded, `mem_slots` mismatch aborts).

- **Prefilter-on-resume** — the shared prefilter is snapshotted to `{dir}/prefilter.bloom` on a throttle
  (`QUEENS_BURR_PREFILTER_SECS`, default 180 s) + on a clean `drain_all`, and reloaded on resume. A
  resumed run now rejects a miss in one cache-line read instead of the **O(segments) per-segment-Bloom
  walk**. Staleness is correctness-safe (keys frozen since the last snapshot re-expand once, self-
  healing). A single-writer latch keeps the throttled freeze write from racing the forced `drain_all`
  write on the shared tmp path (a real race — caught + fixed during validation).
- **Adversarial review of the disk-DDD + snapshot/resume foundation → VERDICT: safe to base a multi-day
  run on, no CRITICAL wrong-value defect** (`MappedArchive::get` proven bit-for-bit identical to the
  in-RAM path; the freeze publish protocol is a correct Release/Acquire; the "a miss only re-expands,
  never wrong" invariant holds everywhere). Fixed its findings:
  - **HIGH-1** — the manifest now records + enforces the resolved memtable **slot count** (`mem_slots`),
    not just `mem_bits`. `QUEENS_TT_SLOTS` *also* drives the archive key, so a resume with a different
    value silently discarded the whole snapshot (correct verdict, zero progress). Now aborts loudly.
  - **MED-2** — fsync the parent dir after every segment/manifest/prefilter rename (durable rename;
    best-effort, FS-portable, largely moot on the ZFS target).
  - **MED-3** — unit-test the disk segment file framing end-to-end (`write_segment` →
    `MappedArchive::open` → `Bloom::load_le` over `bloom_tail`); was zero-coverage.
  - **LOW-4** — `MappedArchive::open` rejects a heterogeneous-shard file rather than mis-decode it.

**★ Certification strategy REVISED (user) — full n=18 certify-from-dump is DROPPED** (infeasible: the
dump *is* the α-β proof DAG ≈ the solve itself — n=12 is 1.06 M rows, not the 44.9 M reachable; n=18 is
tens of B rows, re-deriving them is the same order of work as the solve). See the work-plan's new
"Certification strategy — REVISED" block. CPython `check_cert.py` certify-from-dump is **n≤12 only**;
n=18 confidence comes from (AFTER the run) **items 1–4**: (1) primitive property tests = the A2 set
(`d4_bits` bijection / `verts_of`/`att08` squares 256–323 / `MAXV_POW2` mask — the u8-bug class), (2)
subposition differentials vs the pure-D4 memo/`naive` oracle, (3) `--after` position certs, (4) a
sampled probabilistic recurrence check (O(K); catches a systematic flip with high probability). The
earlier "certify n=14/16 full board + a Rust checker" idea is dropped (CPython can't scale to 49.4 M @
n=14; n=16 full board is 9.2 B rows, doesn't fit). C5 raw-PV-in-snapshot stays for inspection/best-line,
but a PV alone is not a proof.

**Also landed this session (`d600f65`, `42a1f94`):**
- **Tuned ZFS datasets + auto-routing.** The user created `zpool_grover/queens-n18/{burr,dumps}`
  (zstd-fast; burr = 16K recordsize for the random mmap segment reads, dumps = 1M for the sequential
  TS/cert writes). The n≥18 auto path moved `<base>/queens-n<N>-burr` → the run-tree
  `<base>/queens-n<N>/{burr,dumps}`, so a fresh n=18 solve routes segments onto `burr/` with **no env
  var**, and `QUEENS_TS_FILE` auto-defaults (unset, n≥18) to `dumps/n<N>-search-<unixsecs>.ts`. Cert
  dumps go in `dumps/` by convention. Verified end-to-end (segments→burr, TS→dumps).
- **★ Phase B launch telemetry — DONE** (`42a1f94`): **B1** live transposition hit-rate (per-worker
  `(gets,hits)` on the store probe → TS `"gets"/"hits"`, `Δhits/Δgets` = cold-entry/re-expansion read;
  gated `track_hits`, auto-on n≥18 / off n≤16 byte-identical / `QUEENS_BURR_HITRATE` override); **B2**
  `rif` (roots-in-flight) in the TS; **B3** root-timing `WIN_PROVED`/`LOSS_PROVED`/`SKIPPED` labels +
  ran/skipped count; **B5** live in-flight root set in the TTY bar (`rif 3 [I9 A1 K6]`). **B4** needed
  no code — `count --reachable` already reports the per-ply (queen-count) distinct distribution +
  widest ply, `--by-pc` the proof-DAG per-pc. Validated: TS carries rif/gets/hits, root labels print,
  n≤16 TS omits gets/hits (backward-compat), gates green.

**★ NEXT = Task 8, the launch (user-gated big gate).** All pre-flight work is DONE: prefilter-on-resume
✓, adversarial review ✓, tuned datasets + auto-routing ✓, Phase B telemetry ✓. The launch command runs
`iso-dense-burr` at n=18 bare on a tmux TTY (the `queens` session) — disk dir + TS file are now auto
(routed to the datasets), add `QUEENS_ROOT_TIMING=1`/`QUEENS_COLD=1`/`QUEENS_TELEM=1` like the first run.
Box hygiene + GPU-quiet first. Post-run verification = the cert-strategy items 1–4 (property tests /
subposition differentials / `--after` certs / sampled recurrence check). A second-player sweep is days,
resumable (`QUEENS_BURR_RESUME=1`); size with a short partial run / HLL before committing to the full run.

### ★ NEXT-SESSION LAUNCH PROCEDURE (user directive 2026-06-24) — `go` = execute this

**The next session DRIVES the launch in tmux `queens:iso-dense-burr`** (actual window name
`iso-dense-burr run1`, window 4 — prefix-matches). Steps:

1. **Pre-flight check (don't C-c a busy pane).** `tmux list-windows -t queens`; confirm the window is
   **idle at a prompt**. ARC is already capped (`zfs_arc_max=3G`, `c_max`=3.0 GiB confirmed). Build if
   stale: `make release` in `/home/tavis/src/othello-n18/rust` (HEAD `42a1f94`).
2. **Launch — bare on the TTY** (no pipe / no redirect, so the live bar + B5 in-flight root display
   render), from the worktree (pre-launch cache-drop / any privileged step is **user-handled** — no
   `sudo` in this procedure):
   ```
   tmux send-keys -t queens:iso-dense-burr \
     "cd /home/tavis/src/othello-n18/rust && QUEENS_ROOT_TIMING=1 QUEENS_COLD=1 QUEENS_TELEM=1 ./target/release/queens solve 18 iso-dense-burr" Enter
   ```
   Fresh run — **NO `QUEENS_BURR_RESUME`** (resume only on a *restart*). Disk dir + TS auto-route to
   `queens-n18/{burr,dumps}` (no env needed). `QUEENS_BURR_HITRATE` auto-on at n≥18.
3. **Check on it at 2 min, 5 min, 10 min** (user directive), via `tmux capture-pane -t
   queens:iso-dense-burr -p | tail -30` for the live bar (nodes/s, `rif`, hit-rate, root display) **plus**
   `free -h` + `awk '/^size /{...}' /proc/spl/kstat/zfs/arcstats` + the process RSS. Each check, confirm:
   **RSS safe** (anonymous < ~22 GB, ARC ≤ 3 GB, not spilling to zram), **progressing** (nodes climbing),
   **segments freezing** (`keys`/`frz` climbing in the TS, the `burr/` dir filling), **rif/hit-rate sane**.
   **Flag immediately** if RSS balloons toward OOM or ARC misbehaves (resumable, but avoid thrash).
4. **After 10 min: updates ONLY on an explicit user prompt** (user directive — don't volunteer status).

**Box hygiene — ARC (decided 2026-06-24):** for the disk-DDD run, **cap `zfs_arc_max`** (`echo
$((3*1024*1024*1024)) > /sys/module/zfs/parameters/zfs_arc_max`, ~3 GB). Unlike the old all-anonymous-TT
benches (where the `arc-not-a-risk` rule held — zero ZFS reads ⇒ ARC stayed small), this run reads
segments off the pool (mmap'd) + writes dumps, so ARC grows toward its ceiling (measured `c_max`≈25.9 GB,
~all of 26 GB RAM) and competes with the run's **non-evictable** ~20 GB anonymous footprint (≤16 GB
Blooms + 3.2 GB prefilter + 1 GB memtables) ⇒ OOM. Keep ARC small: the Blooms must stay resident, and
mmap'd ZFS data is double-buffered (ARC + page cache) so a small ARC + the page cache serve hot segments,
cold ones demand-page from the pool. Validate with a sizing run (watch RSS + `arcstats size`); raise if
the Blooms stay well under 16 GB. Also `drop_caches` pre-launch; zram swap may stay as an OOM cushion
(the run is resumable).

**Queued (deferred — not started): `QUEENS_RUN_TAG` for per-run isolation.** Today the burr segments /
`manifest.json` / `prefilter.bloom` live flat in the fixed auto dir `queens-n18/burr/` with no run prefix
— a fresh run into a non-empty dir is *refused* (no silent clobber), but distinct runs (sizing → full,
or repeats) collide on the one auto path and need manual dir management. The TS file already carries a
per-run suffix (`n<N>-search-<unixsecs>.ts`); the **burr dir can't be timestamped** (a resume must find
the *same* dir), so it needs a **stable run label**. Add `QUEENS_RUN_TAG`: when set, namespace **inside**
the tuned datasets (so they keep their recordsize) — segments → `queens-n18/burr/<tag>/`, TS →
`queens-n18/dumps/<tag>/n<N>-search-<stamp>.ts`, cert dumps under `dumps/<tag>/` by convention. Same tag
on resume → finds the snapshot; different tag → isolated; unset → today's behavior. Touches
`disk_dir_env` + `auto_dumps_dir` + `ts_file_path` (append the tag) + the `store.rs` knob docs. Small,
reversible. (`QUEENS_BURR_DISK_DIR` / `QUEENS_TS_FILE` already allow manual per-run isolation meanwhile.)

## Handoff Note — 2026-06-24 (disk-segment DDD + snapshot/resume — Task 7 LANDED)

**Task 7 (disk-DDD) + snapshot/resume built, validated, and committed on `queens-n18`.** The
in-RAM store capped at ~2.2–2.5 B of n=18's ~10–18 B distinct; disk-DDD removes that wall — the
cap now bounds **resident Blooms (~1 B/key)**, not ribbons (~6–8 B/key), so a 26 GB box holds a
working set whose ribbons (~100+ GB at n=18) live on the 1.4 TB ZFS pool, demand-paged on a Bloom
admit (the OS page cache is the hot-segment cache).

Commits: **`84a0fd8`** (disk-DDD core) + **`0b91f2f`** (snapshot/resume). Knobs:
`QUEENS_BURR_DISK_DIR=<zfs path>` (unset ⇒ in-RAM control), `QUEENS_BURR_RESUME=1`.

- **`MappedArchive` (`burr.rs`)** — `mmap`s a serialized `ShardedArchive`, parses per-shard/
  per-layer offsets once, `get()` reads ribbon words out of the map (unaligned, `MADV_RANDOM`).
  Unit test `mapped_archive_matches_in_ram` proves it answers **bit-for-bit identically** to the
  in-RAM `ShardedArchive` on members AND a disjoint probe set (the soundness gate).
- **`BurrStore` disk segments (`store.rs`)** — a freeze writes `seg-NNNNN.burr` (atomic
  tmp+rename+fsync) = `[ribbon archive][membership Bloom]`, `mmap`s it (`SegArchive::Disk`), drops
  the in-RAM ribbon; cap counts Blooms only. `summary()` reports on-disk + resident bytes;
  surfaced in the iso-dense-burr footer (was the placeholder "TT 0.00 GB").
- **Snapshot/resume** — segment files double as the snapshot (immutable, atomically renamed); a
  `manifest.json` records `mem_bits`. `QUEENS_BURR_RESUME=1` globs `seg-*.burr`, mmaps each +
  loads its Bloom from the file tail, republishes, restores counters, advances `seg_seq`. A
  non-empty dir without RESUME is refused; a `mem_bits` mismatch aborts loudly.

**[measured] (n=14, single-thread, deterministic):**
- **Disk == RAM, byte-identical:** disk-on vs disk-off (8 GB cap, no eviction) = **2,772,519
  nodes both**, 43 disk segments read back on hits (a wrong disk value would re-expand ⇒ change
  the count). Verdict **second**.
- **The win:** at a **5 MB cap** where disk-off must evict, disk-off = **3,053,716 nodes
  (+10.1% re-expansion)** while disk-on = **2,772,519 (1.0×)** — disk-on held the *entire* set on
  disk (Blooms under the cap) where disk-off thrashed.
- **Resume:** fresh run wrote 1 segment + manifest; `RESUME=1` logged `reloaded 1 segments ·
  195200 keys`, verdict **second**, node count −16% (the reloaded segment served cached hits);
  mismatched `mem_bits` aborted; non-empty dir without RESUME refused.

**Why `mem_bits` is THE resume constraint:** `archive_key = archive_key_of(index(route), fp)`
and `index(route)` depends on the memtable slot count `2^mem_bits` — so a resume with a different
`mem_bits` computes keys the frozen segments can't answer (every probe misses ⇒ silent full
re-expansion, correct verdict, zero benefit). `fp_bits`/`load`/`shards` are self-describing inside
each segment file (read from the header), so they're recorded for sanity but need not match.

**Gates green:** `make test` (release, all lib tests, 0 failed, lineage incl.); n=12 iso-flat
`--distinct` = **1,060,823** exact; iso-dense-burr verdict **second** n=12/14; clippy + fmt clean.

**Pending tuning / follow-ups (non-blocking, before the n=18 launch):**
- **Shared prefilter on resume** — dropped on resume (can't rebuild without the keys), so a resumed
  run routes via per-segment Blooms = **O(segments)-per-miss** walk. Fresh runs keep it. Fix:
  serialize the prefilter periodically (stale is *correctness-safe* — a missing key only costs a
  re-expansion), or MLP-prefetch all segment-Bloom lines per miss (overlaps the DRAM latency).
- **`mem_bits` stays 26 for n=18 — do NOT raise it** (this *corrects* an earlier note that said to
  bump it for fewer segments). The per-segment Blooms (~1 B/key × ~10–18 B keys ≈ **15 GB**) are the
  binding **resident** cost; the memtables compete with them for RAM, so `mem_bits=26` (1 GB for both
  buffers) is right. `mem_bits=30` would be **16 GB of memtables alone** ⇒ OOM. The ~200–300 segments
  this implies are fine: the shared prefilter routes fresh-run gets (walk only on hit/FP), and reload
  is hundreds of cheap mmaps. (Segment count *would* matter on resume, where the prefilter is dropped
  — see the prefilter-on-resume follow-up above.)
- **C5/C6 still TODO:** raw-PV-in-snapshot + the certificate dump (cert keys on the full 384-bit
  canonical key, `QUEENS_BURR_FP=54` — now the n≥18 default); reuse `scripts/check_cert.py` from branch
  `queens-n18-certify`. The frontier/which-roots-done **cursor** is also TODO — resume currently
  re-runs the search (frozen subtrees are cheap hits) but doesn't skip already-proven roots.

**✅ n≥18 auto-defaults landed (commit `ece31ca`):** a fresh `iso-dense-burr` solve at n≥18 now
auto-selects the disk-DDD regime with **no env vars** — auto disk dir (`<base>/queens-n18-burr`,
`base` = `QUEENS_BURR_DISK_BASE` default `/tmp/persistent/tavis`, or the full `QUEENS_BURR_DISK_DIR`),
**`fp=54`** (certified-safe, on disk = free RAM), **`cap=16 GB`**, `mem_bits=26`. Logged at startup +
written to the manifest; n≤16 stays in-RAM (control). Each value still individually overridable. Also
fixed the debug-only `co >>= 64` overflow in `Ribbon::insert` (on **both** branches: main `d8a1727`,
worktree in the auto-defaults commit) — `cargo test` in debug works again.

**★ NEXT for the launch:** (1) the prefilter-on-resume fix (so resumed runs don't pay the O(segments)
walk); (2) C5/C6 PV + certificate dump; (3) Task 10 adversarial review; (4) Task 8 — launch the
instrumented, snapshotting n=18 run (user-gated big gate). Then run `check_cert.py` — *a verdict we
can't certify, we don't claim.*

## Handoff Note — 2026-06-24 (BuRR-backed iso-dense build)

**Refuted the prior "single-box n=18 infeasible / needs a cluster" conclusion by building +
measuring the design those sessions wrote off without running it** — DFS + an eviction-free
BuRR store *under the fast iso-dense kernel*. Post-mortem on how that estimate ossified:
`notes/2026-06-24-reflections.md`. Landed on `queens-n18` @ `3d4d8f6`:

- **`iso-dense-burr`** — the fast iso-dense kernel (all M_ORD_W levers: getK/W_K collapse,
  dynamic ordering + counting-sort, ETC) with its flat `QueensTt` swapped for the eviction-free
  `BurrStore`. The store is a resolved-once runtime `Option` field on `IsoFlat`, orthogonal to
  MODE (like `assoc`/`segment`); every TT touch-point routed to it; `skip18`/`warm_restart` off;
  the flat-TT `iso-dense` stays the byte-identical control. **[measured]** gates green (lineage
  n≤9, n=12 distinct **1,060,823** exact, verdict **second** on n=10/12/14).
- **Huge-paged BuRR ribbon segments** (`huge_boxed_u64`, `MADV_COLLAPSE`, like the TT; the
  memtable was already a huge-paged `QueensTt`).
- **BuRR key telemetry in the TS dump** (`keys`/`segb`/`frz`/`full` per tick = the live
  re-expansion trajectory). **[verified]** backward-compatible (omitted for flat-TT solvers).

**Findings (provenance-tagged):**
- **[measured]** Profile: getK collapse works — store probes **31%→6.6%** vs old iso-burr;
  getK-evaluator-bound (the iso-dense profile shape), store no longer the bottleneck; IPC
  1.0→1.2. The win is *fewer re-explored nodes* (eviction-free), at slightly lower nodes/sec —
  not an M/s gain. Yesterday's 261 B-node flat-TT run was eviction-bound (99.7% cold = repeat
  visits), not distinct work.
- **[measured]** fp audit (`notes/`-worthy, in task #9 output): **`fp=44` is NOT collision-safe
  for a *certified* run** — E[silent wrong-value] ≈ 0.02–0.17 over the run ⇒ **raise
  `QUEENS_BURR_FP` to 54**. The certificate must key on the full 384-bit canonical key (the u64
  `archive_key` has a birthday floor fp can't fix; the independent `check_cert.py` is the safety
  net). Int-widths otherwise safe — the u8 square-index class is gone.
- **[measured → FIXED `f99d56d`]** Freeze pipeline stalled at n=18: the ~40M-key ribbon segment
  build took ~23 s and the `freezing` flag blocked further freezes ⇒ ~1 freeze / 35 s ⇒ the store
  degenerated into a single evicting 67M-slot memtable. Cause: the partition phase was
  single-threaded and did two random Bloom inserts/key (incl. into the multi-GB shared prefilter).
  **Fix:** hoist the Bloom inserts into the parallel per-shard build (`AtomicU64` words ⇒ `fetch_or`
  is race-safe; no false negatives ⇒ sound). **~4× throughput** — first freeze t≈28s→t≈11s, 4
  freezes/35 s vs 1; pipeline now ~keeps pace. (Ruled out core-starvation + the Task-1 `MADV_COLLAPSE`.)
  Residual headroom: the serial scan + smaller/more-frequent freezes if more margin is needed.
- **[measured]** The in-RAM store retains only ~2.2–2.5 B of ~10–18 B distinct at a 16–18 GB cap
  on this 26 GB box (live RSS climbed to the ~20.5 GB cap on root 0 alone) ⇒ **doesn't fit RAM ⇒
  the disk-DDD rung (Task 7) is the path**, not in-RAM.

**✅ Task 7 (disk-segment DDD) + snapshot/resume + n≥18 auto-defaults DONE** (2026-06-24, commits
`84a0fd8` + `0b91f2f` + the auto-defaults commit) — see the **top Handoff Note** for the build,
measurements, and remaining follow-ups. The in-RAM cap wall is removed: ribbons live on the 1.4 TB ZFS
pool (`QUEENS_BURR_DISK_DIR`, **auto for n≥18**), only Blooms resident; segments double as a resumable
snapshot (`QUEENS_BURR_RESUME=1`). Was: "persist the frozen immutable segments to
`/tmp/persistent/tavis`, keep per-segment Blooms resident, read a segment from disk only on a
Bloom-admit." That's exactly what landed; the freeze pipeline that *writes* them keeps up (Task 11).
**Remaining toward launch:** prefilter-on-resume → Task 5/6 PV + cert dumps (cert keys on the full
384-bit canonical key, `QUEENS_BURR_FP=54`) → Task 10 three adversarial review rounds → Task 8 launch.
Parked certify pipeline on branch `queens-n18-certify`; `scripts/check_cert.py` is the independent checker.

**Code state (`queens-n18` @ disk-DDD commits):** iso-dense-burr + disk-DDD + snapshot/resume built
+ validated (gates green). **Banked earlier:** `3d4d8f6` (BuRR-backed iso-dense + huge-page store +
key telemetry), `f99d56d` (freeze parallelization); **this session:** `84a0fd8` (disk-DDD core) +
`0b91f2f` (snapshot/resume) + the auto-defaults commit. **Launch knobs are now AUTO for n≥18** (no env
needed): `fp=54`, `cap=16 GB`, disk dir `<base>/queens-n18-burr` (`base`=`QUEENS_BURR_DISK_BASE`,
default the ZFS pool), `mem_bits=26` (kept low on purpose — Blooms are the binding RAM cost). Override
any via its `QUEENS_BURR_*` var. **Pending tuning (non-blocking):** the `keys` telemetry overcounts in
the evicting regime (`fill` = inserts, not occupancy) — report occupancy; ~~the burr footer prints the
placeholder "TT 0.00 GB"~~ FIXED (footer now shows `store.summary()` incl. disk bytes); `pw[]`
per-worker is zeros for burr (reads the placeholder TT).

## Handoff Note — session 2026-06-24--5 (id f8bdada0-eac0-4a5f-a117-d9b8dc59584f)
**Phase A (verdict bug) DONE + Phase C1 (store) DONE — two clean commits on `queens-n18`.**
- **`cddfc64` — fixed the verdict bug.** Root cause: `graph.rs`'s tiny/canon path stored board-square
  indices in `u8` (the migration's S1 widening swept iso_flat.rs but **missed graph.rs**); at n≥17
  squares >255 truncate → wrong attack rows → **loss↔win flip**. n≤16 (max square 255) couldn't catch
  it. Widened square indices `u8`→`u16`. Found by a new **n=18 subposition differential** vs the
  `memo`/`naive` oracle (`n18_subposition_values_match_oracle`, caught it at pc=3); added a **runtime
  PV-parity guard** on the solve path. Gates green: full suite, n=12 exact 1,060,823, n=14 1.03×.
  **The kernel is now correct** — n=18's true verdict still needs the (memory-bound) Phase-C run.
- **`8d8bca6`/`c96dfd4` — Phase C1.** Wired + de-risked `ply_store.rs` (see the BuRR design doc's
  "C1 DONE" block): `fp=0` multi-layer is unsound, the single-layer cliff is ≈0.92 (→ `DEFAULT_LOAD
  =0.90`), small ribbons can't single-layer → **hybrid exact/ribbon store** with a step-down
  single-layer guarantee. Tests + clippy green.
- **`a9de5dc` — `count --by-pc` / `--reachable` sizing tools, which KILLED C2.** Built the design's
  "size before you build" taps. `--reachable` (forward BFS, `Queens::reachable_profile`) vs the α-β
  working set: **n=10 5.87×, n=12 42.31×** — the retrograde ply-windowed BFS stores the full reachable
  set, not the proof DAG, and the ratio explodes. **C2 is infeasible; both BuRR modes are dead for a
  single 26 GB box.** (Caught before the multi-session driver build — the discipline paid off.)
- **`81e63ca` — ★ C6: the independent verdict-certification pipeline, BUILT + PROVEN.** `queens
  certify <n> <out>` dumps the exact D4-canonical value table; **`scripts/check_cert.py`** re-derives
  the verdict using ONLY game rules + its own from-scratch D4 canon (zero solver code — so a
  search/canon bug can't fool it), checking the Node-Kayles recurrence + loser-node completeness at
  every position. **Demonstrated: n=8 first, n=10 second, n=12 second (1,060,749 positions, beyond
  naive) all CERTIFIED; fault injection (flipped verdict / corrupted value) both REJECTED.**
- **★★ COMPLETE + INDEPENDENTLY-VERIFIED n=18 RUNS (of real positions).** `certify <n> <out> --after
  <opening moves>` solves + certifies any n=18 *position* (a real game continuation), which fits and
  completes where the empty board cannot. The full pipeline — **execute a complete n=18 search →
  generate a certificate → independently verify with `check_cert.py`** — now runs end-to-end on
  genuine n=18 geometry (high squares / words 4–5, the bug's home). Verified n=18 results:
  - after `A1 C2 E3 G4 I5 K6 M7 O8 Q9` (41 avail) → **player-to-move WINS**, 3,996 positions, CERTIFIED;
    fault-injected verdict REJECTED.
  - after `A1 C2 E3 G4 I5 K6` (87 avail) → player-to-move WINS, 280,283 positions, CERTIFIED.
  - after `A1 C2 E3 G4 I5` (114 avail) → **player-to-move LOSES** (opponent wins), 9,303,023 positions
    (solver result; too large for the CPython checker in a sitting — a Rust checker port is the n≥14
    full-board scaling step).
  The **empty-board n=18 verdict** is the only piece still gated — it needs the working set in RAM
  (~80–145 GB; box has 26 GB), confirmed by a real 1.6 B-node run (0/45 roots). The solver and the
  verifier are proven correct on n=18; the full-board *search* awaits adequate RAM or a cluster.
- **Docs (this session, on main, uncommitted→commit at close):** verdict-bug RESOLVED block; changemap
  graph.rs correction; this note; BuRR design C1 block **+ the ⛔ C2-infeasibility banner**.
- **★ NEXT = a STRATEGY decision (user):** n=18's ~50 B working set doesn't fit this box at any
  correctness-preserving rep, and the value-only escape needs the 42×+ retrograde enumeration. Options:
  **(1) cluster (Phase D — TDS, needs the hardware + build); (2) a bigger-RAM box (~512 GB holds the
  ~300–400 GB membership store); (3) a working-set-shrinking idea** (iso-key merge / component-nimber —
  lit-triaged weak); **(4) accept multi-week single-box re-expansion thrash** (risky). The autonomous
  build levers (C2/driver) are exhausted — this is a hardware/research call, not more single-box code.

## Handoff Note — session 2026-06-23--4 (id a0d2a411-5ca9-4d70-b1d8-e3d3c7bd89a0)
Created the umbrella + the three threads (migration/verdict-bug, BuRR design, work-plan) + the
changemap + the `ply_store.rs` scaffold, all on `queens-n18`. Migration validated n≤16; first n=18
run completed but the verdict is a documented bug. Memory-bind confirmed ⇒ BuRR vindicated. Next:
fix the bug, then the gated BuRR build.
