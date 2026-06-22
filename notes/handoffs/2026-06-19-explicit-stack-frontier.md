# Explicit-stack `wins_inc` → ABDADA / frontier work-stealing

**Date**: 2026-06-19
**Session**: 2026-06-19--6 (`2bbbb8da-5981-4a0c-a5eb-3ad05ddafe19`)
**Mode**: intent-based (`mi`)
**References**:
- Umbrella: [iso-window](2026-06-18-iso-window.md) — n=16 **SOLVED (second)**; this thread continues its
  **parallelism-deficit** lever (session --5: the giant-root tail is 51% core util / ~half the wall,
  transposition-bound + OR-spine-width-limited; **only ABDADA in-flight markers or grouped-frontier DDD
  can crack it** — both need a materialized frontier a recursive DFS can't provide).
- Commits (main): `f124bc5` (canonical A/B harness + CLAUDE.md lessons), `3f10919` (the explicit-stack
  code), `8fb23dd` (micro-opt → parity).

## ⇒ --19 (2026-06-21, goal: "n=16 2os" / sub-20s search) — PREFETCH lever CONFIRMED DEAD; fresh W17 profile; bounds-check elision −1.2% cyc/node.

> **Mode: intent-based + a "be relentless, don't stop for answers" Stop-goal hook. Work on main (user
> prefers it); fresh tmux windows per run (never reuse).** Net: the --18-chosen PREFETCH lever is
> measured DEAD (two forms), the cost map is re-profiled fresh on the W17 default, and a small clean
> win banked (bounds-check elision). Big levers remain exhausted; the wall is now mapped as
> **frontend(I-cache) 22.6% + branch-mispredict 11% + getK-ALU 44% (near floor) + cold-TT-probe DRAM**.
>
> **★ PREFETCH (the --18 user-chosen "SMT-sibling helper") = DEAD, two forms built + n=16-A/B'd, both
> removed from main (negative; recorded here per CLAUDE.md):**
> - **Off-core prefetch HELPER** (`QUEENS_PFHELPER`, a new `M_PFHELPER` mode): a separate thread that
>   reconstructs each tail worker's node from a published `avail` (4 atomics/node; exact via the
>   `child_orient(parent,att[sq],child0) == orient_of(q,child0)` identity — so the helper recomputes
>   future recurse-spine routes with pure bounds-safe Bits math, no fault on a racy read), chases the
>   spine `pf_depth` plies ahead, and `_mm_prefetch`-warms the cold pc≥18 probe slots. CCX/SMT-aware
>   pinning (the box has **2 L3 domains**: CCX0/perf = cpus 0-3,12-15 [16 MB L3], CCX1/eff = 4-11,16-23;
>   siblings `(k,k+12)`; `pf_target_cpu`+`sched_setaffinity` follow the worker's published cpu). n=16
>   4-round A/B: **unpinned +1.7% cyc/node / +2.0% wall; pinned-continuous-chase +7.2% wall** (warming
>   the worker's own L3 floods it with cold use-once TT lines that evict the hot getK arena). The
>   chase-on-change refinement (prefetch each frontier once, not continuously) was built but the run
>   that would A/B it got box-contaminated (ran `cargo check` mid-bench — DON'T) and it was superseded.
> - **Inline gather-time T2/L3 prefetch** (`QUEENS_PFL3`): the untried angle `pf_deep` missed — it only
>   tried T0/L1 and T1/L2 (both evicted by the 32 MB getK-arena scan); warm the recurse children to
>   **T2/L3** (16 MB, survives the scan) at gather time. **n=16 5-round A/B = +1.0% cyc/node** (clean,
>   every on-round above every off-round). The extra prefetch instructions cost ~1% and hide nothing.
> - **WHY dead (the real reason, beyond --18's "wash"):** the DFS entry probe is **inherently serial**
>   (one path-dependent probe per node; you can't issue the next until you know which child you recurse
>   into, which is cutoff-dependent), so there is no MLP to exploit — the existing one-ahead
>   `prefetch_h` already captures the only easy overlap. Adding prefetch just adds instruction +
>   MSHR/LFB + L3-pollution overhead and **perturbs the parallel TT-fill timing** (the "on" runs
>   systematically drew more nodes). The queuing-theory ρ≈8% spare *bandwidth* is real but irrelevant —
>   the wall is *latency* and it's serial. **⇒ the whole memory-latency-hiding family (helper, pf_deep,
>   pf_l3, MLP-probes) is CLOSED with n=16 evidence.** (Helper/pf_l3 code reverted; design recorded here.)
>
> **★ FRESH W17 PROFILE (the cost map was W12/W16-era; this is the current default).** perf record
> `--sort=symbol` + `perf stat` (n=16, 12 GB TT, ~29s):
> | bucket | cycles% | notes |
> |---|---|---|
> | **getK evaluators** (`DenseW8::get9..16` + `get_dyn_wide`) | **~44%** | the dominant cost (grew from 35% — W17 added layers). ALU/L1-latency-bound: the per-child chain mask-load→pext→popcount→cpc-branch→**arena `bt` load-use** (`get10` annotate: `bt %rdx,%rax` 13.7%, `cmp $0x9,%edi` cpc-branch 12%). NEAR FLOOR. |
> | `wK_get` builders (`wN_get`) | ~24% | code-build (`adj_row_pext`) + `verts_of` |
> | `sort_moves_by_degree` | 7.5% | the counting sort |
> | `wins_inc` | 18% | descent cascade + cutoffs + recurse |
> | `mtt_get` | 2.4% | the TT probe |
>
> - **IPC 1.40. Frontend-stalled 22.6% + branch-mispredict ~11% = ~33% of cycles lost** to the I-cache
>   (the big getK code footprint: get9..get16+wide are ~9 hot functions ≳ 32 KB L1i) + mispredicts.
> - **Branch-misses by symbol: `wK_get` builders ~45%** (the source is `verts_of`'s `while x!=0`
>   bit-iteration data-dependent exit), **`wins_inc` 23%** (cascade dispatch + data-dependent cutoffs),
>   getK ~15%.
> - **Cache: L1-dcache miss = 2.7%, LLC miss = 12.9% (7.1 B DRAM misses/run = the cold TT probes).**
>   The **W8 hot-set is L1/L2-resident** despite the 32 MB table (the tail's recurring subgraphs are a
>   small set). ⇒ getK is NOT arena-DRAM-bound — it's the ALU/L1-latency chain.
> - **★ USER Qs answered with data — W8 is the right table level + repr (don't build higher/lower):**
>   complete labeled tables are `2^(K(K-1)/2)`: **W8 = 2^28 = 32 MB, W9 = 2^36 = 8 GB, W10 = 4 TB.**
>   Higher (W9) = a cold 8 GB DRAM table competing with the TT (worse); lower (W7 = 256 KB, fits L2)
>   gains nothing on the loads (already L1-resident per the 2.7% miss) and adds a ply of compute. The
>   1-bit bitset + `bt` test is cache-optimal. The `cpc==K-1` branch (12% of get10) dispatches isolated-
>   vertex children to a nested getK — REAL (ISO_STRIP=false; the boolean getK can't shortcut an
>   isolated vertex — needs nimbers, dead) and not removable.
>
> **★ BANKED WIN — hot-path bounds-check elimination = ~−0.6% cyc/node, byte-identical (n=14
> 2,714,701, n=12 distinct 1,060,823, lineage green).** `sort_moves_by_degree` had `cmp $0x100`/`cmp
> $0xff`/`cmp %rax,%rbx` bounds checks in the counting-sort scatter (each also a branch the
> 22.6%-frontend must fetch); elided via `n = len.min(MAXV)` (proves the fixed-array indexes),
> `d & (MAXV-1)` mask (the getK `& 0x3ff` trick), and `get_unchecked` on the stable scatter (the
> counting-sort invariant `p ∈ [0,n)`). + the descent `degs[i & (MAXV-1)]` mask (2 sites). Two
> interleaved A/Bs: the sort-alone (with a `pf_l3` branch confound) read −1.2%; the final clean
> baseline-vs-reverted-prefetch 5-round read **−0.55% cyc/node excluding a round-1 cold-start outlier
> (every round 2-5 has B<A; raw incl. outlier −2.2%).** So ~−0.6% honest, small but real + zero-risk.
> ON MAIN (commit pending).
>
> **⇒ NEXT (the live levers, biggest-bucket first):**
> 1. **FRONTEND (22.6%) + BRANCH (11%) = the biggest under-attacked bucket.** Two contained, byte-
>    identical candidates: **(a) jump-table the `wins_inc` descent pc-cascade** (the `if pc==17 else if
>    pc==16 …` walks ~2-5 branches + fetched comparison code per child × ~10 children/node; a `match pc`
>    → one indirect jump — the handoff's untried #2; wins_inc is 23% of mispredicts). **(b) de-branch
>    `verts_of`** (the #1 mispredict source at ~45%): const-generic `verts_of::<K>` fixed-count loop
>    unrolls away the `while x!=0` exit. *Caveat:* my napkin says (b) saves only ~1 mispredict/call
>    (matches --15's "may wash") — measure but temper expectations; (a) is the better bet.
> 2. **NODE-COUNT / move ordering** — still the only *−2× ceiling* lever (the report's "worth ~2×";
>    at DK=17 a pc-18 node's children are ALL getK leaves, so the move order directly controls how many
>    of the **44% getK evals** happen before a cutoff). But every tried form washed (countermove,
>    killer, history, effective-degree); the untried 1-ply lookahead ADDS code/compute (bad when
>    frontend-bound). Hard. No cheap idea found this session.
> 3. **getK / W8 = NEAR FLOOR, do not re-grind** (ALU-chain, cache-optimal, level/repr confirmed).
>
> **Method notes banked:** (i) the `| tee … ; echo MARKER` footgun bit again — a `capture-pane | grep
> MARKER` poll false-matches the *typed command line*; poll the **output FILE** for the script's own
> `AGGREGATE`/`DONE` line, never the pane. (ii) `cargo check`/build DURING an A/B contaminates it
> (build pool on the eff cores) — keep the box idle. (iii) cyc/node is the trustworthy metric for
> byte-identical changes (wall swings ±node-noise; the parallel node count diverges run-to-run).

## ⇒ --18 (2026-06-21, goal: "n=16 2os" / sub-20s search) — W17 dense layer + getK degree-ordering = −13% wall.

> **Branch `queens-sub20-wk`** (off `queens-sub20-wk`←`queens-compact-assoc-tt`; NOT on main yet — decide promote with user).
> Best clean A/B (quiet box, 12 GB): **FAST = ~25s mean / 24.5s best vs ~29.8s baseline (−13% wall)**, verdict SECOND
> every round, all gates green (lineage, n=12 distinct 1,060,823, n=14 ≈29.2M).
>
> **★ LANDED (gated; `QUEENS_FAST=1` = the umbrella toggle = W17 + getK-ordering):**
> - **W17 dense layer** (`QUEENS_W17=1`; generalized to **W17..W20**, `QUEENS_WK=9..20`, `QUEENS_HIK=0/1`=K17/K20).
>   3-word (192-bit) labelled code above the u128 K=16 ceiling; `get17..get20` + `get_dyn_wide`; 2^K induced masks
>   built at runtime. Resolves pc==K nodes as getK leaves (no cold entry probe). Correctness: `direct_w17..20_matches_scalar`.
> - **getK degree-ordering** (`QUEENS_GETK_ORD=1`): get12..get20 sweep children highest-degree-first (smallest child =
>   most-forcing = earliest cutoff), branchless counting sort. **get9/10/11 stay label-order** (their W≤8-lookup children
>   are too cheap — the sort overhead dominated: ordering get9 was ~7% of its cycles, 11.65%→4.78% reverting it).
> - **getK child-code int right-sizing** (get13..16): `pext128` (u64) for the ≤11-vertex child majority, `pext128_wide`
>   (u128, 128-bit shift) only for cpc≥12 (rare isolated-removal). ~−0.6% cyc/node. (User's "oversized ints" ask.)
> - **TT unchecked slot access** (`TT::slot()` get_unchecked; fastrange `(route·len)>>64 < len` ⇒ bounds check provably
>   dead). cyc/node-NEUTRAL (the predicted branch was free; its perf % was skid from the adjacent mulx/prefetch) — kept
>   as a correct dead-code removal.
> - **cpc off the getK critical path** (Opus sub): `cpc = (K-1) − popcount(adj[i])` instead of `popcount(child)` in
>   get9..get20 (exact since `full` is all-K-ones, iso_strip off) ⇒ the popcount issues parallel to forming `child`, so
>   the W[cpc] index/dispatch resolve a hop earlier. ~cyc/node-NEUTRAL (OoO already hid it) but correct + cleaner; kept.
> - **★ PROMOTED TO DEFAULT (`818a449`).** dense_k default 16→17 + getK-ordering on by default. n=16 A/B old-vs-new:
>   −21% nodes / +16.5% cyc/node / **−8.6%..−13% wall**, SECOND every round, gate green. `QUEENS_FAST=0` reverts the
>   whole stack (old K16 + no-ord = the A/B control). **Still on branch `queens-sub20-wk` — MERGE TO MAIN** (user said promote).
>
> **★ KEY RESULT — the WALL is capped at K=17 by WORK-CONSERVATION.** The W_K node cut is enormous and barely diminishing
> (n=16 WK 16→20: **399.9M → 191.0M nodes, −52%**; n=14 2.71M→0.84M, −69%) but **wall is flat** — deeper getK does the
> same combinatorial work, so cyc/node grows ~proportionally (HIK A/B K17 vs K20: nodes −35%, **cyc/node +60%, total cyc
> +4%** ⇒ K20 SLOWER). K=17 is the wall sweet spot; W18-20 cut nodes (good for memory/TT, future cyc/node wins) not wall.
> ETC re-confirmed at K=17 (M_ORD vs M_ORD_W A/B: ETC −13.7% nodes / +3.6% cyc/node / **−10.7% total cyc** — still pays,
> far below the K=12-era +14.6%). FAST's win is the −20% node cut at +16% cyc/node net −13% wall.
>
> **MEASURED-NEGATIVE / instructive (the cyc/node floor is real — "math cheaper than mem"):**
> - **getK memo DEAD (+13.4% cyc/node).** Thread-local exact-fp memo over get12..16 to collapse the recursion's factorial
>   path-redundancy. α-β cutoffs already prune most of it, and the memo's random L2/L3 probe is slower than recomputing
>   the pext/popcnt — the same reason W_K is memo-less by design. Reverted.
> - **prefetch DEAD (wash).** pf_deep gather-time T0 prefetch +0.0%; the L2-distance (T1) twist for the nw<2 lone recurse
>   child also −0.3% (gated, kept). The recurse children sort last; the cheap-getK arena scan evicts the line, and the
>   descent often cuts before the recurse arm ⇒ wasted prefetch. The prefetch memory lever is dead even with cache-level tuning.
> - **getK micro-opt EXHAUSTED (profile-confirmed).** perf annotate: get9 cost is inherent (`popcnt` for cpc, W8-arena
>   load latency via `ret`/`mov`/`bt`, `pext`); evaluators near floor; no removable instructions. The handoff's
>   "load-latency-bound, near floor" holds, now from a fresh angle.
>
> **⇒ ★ NEXT SESSION (user-chosen) = the SMT-sibling PREFETCH HELPER.** sub-20s is still open and the cyc/node is the
> wall (FAST is +16.5% cyc/node; node-cutting work-conserves; the evaluators + ints + layout are all confirmed near-floor
> this session — getK-memo DEAD, prefetch wash, hot path clean, ints right-sized). The remaining real lever is the
> **memory side**: a same-physical-core **SMT-sibling helper thread** that runs the search PATH a few plies ahead and
> issues `_mm_prefetch` for the cold pc≥18 entry-probe slots (99.9% cold DRAM, ~165 cyc), taping the spare budget
> (ρ≈8%, the active core's ~70% DRAM-stall execution shadow, warm shared L1/L2). `SCHED_IDLE`/nice is the right throttle
> (same core). Gate: prefetch DISTANCE / path-prediction (the path is cutoff-dependent). See the queuing-theory +
> speculative-tt-prewarm proposals. Heavy/multi-session — the original PREFETCH task's real prize.
> **Lower-priority parked:** (a) carry-adjacency-down in getK (avoid re-`extract_adj` per level — uncertain, relabel ≈
> extract cost); (b) the **8 GiB TT default** (`MAX_TT_BITS=30`, on `queens-compact-assoc-tt`) + **inline/survivable PV**
> (search tolerates a 2 GB TT at +8.5% nodes; PV is the blocker, currently 5-10s at small TT); (c) cache `wide_induced`'s
> per-call `OnceLock` pointer in `DenseW8` (negligible ~0.017%, only the K≥17 path). Also banked: `M_HITKEY` capture +
> `scripts/hitkey_study.py`/`hitkey_compare.py` (pc≥17 hits predictable by pc — the pc 35-78 "shoulder" 3-12% vs cold-bulk
> 0.1%; recurrence shallow+broad; PV cold/off the transposition path).

## ⇒ NEXT SESSION = PREFETCH (user-chosen, --17 end) — hide the mandatory-but-cold pc≥17 probe latency.

> **★ START HERE NEXT SESSION (user, --17 end): the PREFETCH lever.** Everything else on the deep root is killed with
> n=16 evidence (getK micro-opt → Opt1 was the only win; node-count → decomposition DEAD + killer-ordering DEAD;
> probe-skip → regresses +26% [the probe earns its keep]). The M_COLD + queuing results converge on ONE live path:
> the pc≥17 entry probe is **mandatory** (catches 0.2% high-value transpositions; the PV scan needs the TT intact) +
> **99.8% COLD** + **high-latency**, and the solo tail runs the memory controller at **ρ≈8%** (12× spare bandwidth) —
> so the win is **latency-hiding the necessary probe**, not skipping/warming it.
> - **CHEAP FIRST EXPERIMENT (do this first):** **deeper/speculative descent prefetch** — today the descent prefetches
>   only the one recurse child; issue `_mm_prefetch` for the next 2–3 degree-sorted children's TT slots too (some
>   wasted on cut-before-probed, but prefetches are nearly free). Contained, byte-identical node set, low-risk A/B
>   (metric = wall + total cyc). This is the lowest-risk shot at the exposed-probe latency (~half is still exposed past
>   today's one-ahead `prefetch_h`).
> - **HEAVIER (the real prize):** an **SMT-sibling helper thread** running the search PATH a few plies ahead to predict
>   + prefetch future probe slots — taps the spare-budget synthesis: ρ=8% bandwidth + the active core's ~70% DRAM-stall
>   *execution shadow* (the SMT sibling runs in it) + warm L1/L2 (same physical core). **`SCHED_IDLE`/nice IS the right
>   throttle here** (unlike cross-core, which needs MBA/CAT) — the sibling yields the shared core when the main worker
>   can use it. The gate is **prefetch DISTANCE / path-prediction** (the path is cutoff-dependent — you don't know which
>   child cuts until you evaluate it); start with a short, speculative (branch-fanned) lookahead.
> - Context: [queuing-theory](../proposal-2026-06-21-queuing-theory.md) (ρ=8%, B_free 500–650 M/s, prefetch-only beats
>   speculative-solve), [speculative-tt-prewarm](../proposal-2026-06-21-speculative-tt-prewarm.md) (exact-key prefetch
>   strictly dominates pre-warm), the M_COLD/M_RANK taps (committed, gated). **PV-scan constraint: the TT must stay intact.**
>
> **PARKED — 1 GB hugepage TT (the cheaper-probe / TLB lever):** would remove the ~82% TT TLB-miss page-walk (17 GB in
> 2 MB pages = ~8700 pages ≫ ~1500 L2-TLB coverage) for a clean **byte-identical** ~2.5–7% tail win. **Runtime reservation
> is IMPOSSIBLE here** — `echo 14 > .../hugepages-1048576kB/nr_hugepages` → **0** (the buddy allocator's max block is
> ~4 MB; 1 GB-contiguous physical can't be assembled at runtime even post-`compact_memory`; `pdpe1gb` IS supported).
> Needs a **boot reservation** (`default_hugepagesz=1G hugepagesz=1G hugepages=14` cmdline + reboot). Build path: a gated
> `QUEENS_TT_1G` doing `mmap(MAP_HUGETLB|MAP_HUGE_1GB=30<<26)` (kernel-zeroed, leak/munmap-wrapper not `Box`) with a 2 MB
> `MADV_COLLAPSE` fallback on `MAP_FAILED`. Decide the reboot with the user; modest win, clean experiment.

> **Session --17 (2026-06-21).** Targeted the getK **35%** evaluator bucket + the deep single-root tail (~94% of n=16 wall).
>
> **LANDED ON MAIN (cherry-picked/forward-ported off branch `queens-compact-assoc-tt`):**
> - **`df827fc` ★ flat W0..W8 dense arena (Opt1) = −2.0% cyc/node** (5-round n=16 A/B, every B round below every A).
>   `DenseW8` held the complete tables as `&[Box<[u64]>]` (the `Vec<Box<T>>` pointer-chase the tiger rules forbid);
>   the get9 annotate showed its hottest load (8.6%) was the **bounds-check `len` load on `tables[cpc]`** ahead of a
>   separate box-ptr load, before the data word — two serial loads per leaf. Concatenated into one `&'static [u64]`
>   (`TABLE_OFF` cumulative offsets, `get_unchecked` leaf). Byte-identical (dense `direct_w9..16`/`graph_wins8` bit-match).
> - **`f285535` ETC win-child re-probe elimination** (forward-port of just the 3 ETC-reuse hunks from `97779e3`; the
>   gated assoc-TT / sidecar-sim experimental code stays OFF main). Gate green on main (dense, lineage, n=14 SECOND,
>   n=12 distinct 1,060,823).
>
> **MEASURED-NEGATIVE / instructive (the getK micro-opt space is the lesson):**
> - **batch-puts (write side) DEAD.** perf-stat n=16: `store_queue_rsrc_stall` = **0.084% of cycles** (puts are plain
>   `Relaxed` stores → retire async to the store buffer; not store-bound, not bandwidth-bound). No stall to recover.
> - **Opt2 — AVX-512 child-mask/popcount pre-pass (`vpopcntw`) MEASURED-NEGATIVE +2.4% cyc/node, REVERTED.** The getK
>   evaluators are **load-latency-bound, and OoO already hides the per-child ALU** by speculating past the early-return
>   branch — so SIMD-batching just adds a 64-byte stack spill + eager 16-lane waste on early cutoffs. **Opt1 won ONLY
>   because it removed a SERIAL LOAD the OoO engine couldn't hide; ALU batching has nothing to remove.** By the same
>   logic **C1b (skip `extract_adj`'s redundant K-pexts) would wash** — it's a no-branch prologue that overlaps the
>   early loop iterations (child[0] needs only adj[0]).
> - **Deep-tail micro-opt round EXHAUSTED.** Tail-filtered profile == aggregate (same node mix). Every hot path is
>   load-latency-bound or already AVX-512: getK (ALU OoO-hidden), `sort_moves_by_degree` (vectorized degree compute
>   `vpandnq zmm` + branchless counting sort), `child_orient` (zmm `vmovups`/`vandnps`), builders (`att08` clean L2
>   loads), `wins_inc` (the hash128→DRAM entry-probe = the memory floor + 256-bit reloads of parent state **live across
>   the recurse call** = inherent spill). **No removable serial load remains** → cyc/node is near its floor for this rep.
>
> **⇒ THE LEVER IS NODE-COUNT (only thing left for the deep tail). Three design subs ran (proposals written):**
> - **[targeted-nimber-decomp](../proposal-2026-06-21-targeted-nimber-decomp.md)** (connected-component Grundy): design =
>   dense u8 Grundy table for components ≤8 (one lookup, no recursion; k=8 ≈ 256 MiB/~1s all-core build) + **idle-core
>   prep** during the parallel phase + **tail-only gating** (new `M_ORD_W_DECOMP` MODE, selected when ≤2 roots remain).
>   **Verdict: conditional, premise in serious doubt** — the pc 13–16 tail graphs may be overwhelmingly ONE connected
>   component (the `iso_strip` wash + `module_profile` sparsity both point this way).
> - **[module-nimber-decomp](../proposal-2026-06-21-module-nimber-decomp.md)** (modular/twin): **DEAD** — Node-Kayles is
>   vertex-deletion, a move on a module vertex deletes `N[v]` reaching OUTSIDE the module via shared external neighbours,
>   so there is **no clean `g(G)=f(g(quotient),g(module))` factorization** (game-invariance fails); the only exact
>   identities (odd-K1 XOR1, twin-pair dedup) are already measured wash/negative. Plus queen-geometry sparsity.
> - **[deep-root-ordering](../proposal-2026-06-21-deep-root-ordering.md)** (move-ordering enhancements) — RUNNING at handoff.
>
> **★ BOTH TAPS BUILT + MEASURED AT n=16 (committed gated/byte-identical: `M_DECPROBE`/`QUEENS_DECPROBE`,
> `M_RANK`/`QUEENS_RANK`). The verdicts redirect the whole next phase:**
> - **NIMBER DECOMPOSITION = DEAD (n=16 confirmed).** The pc 9–16 getK conflict graphs are overwhelmingly ONE connected
>   component: mean #components 1.12 @pc9 → **1.003 @pc16**; **`%all-components-≤8` = 0.00% across pc 13–16** (~690M of
>   the 1.5B getK nodes — all the deep weight); even `%all-≤(k−1)` is ≤1.7% @pc13 → 0.29% @pc16. The only decomposability
>   (pc9: 11.8%) is the cheapest band where getK already bottoms out. Sprague-Grundy XOR has nothing to bite on. Both
>   decomposition subs predicted it; n=16 *strengthens* the kill (more decomposable at low pc than n=14, still 0% deep).
>   **⇒ the targeted-nimber + module-nimber + grouped-frontier-DDD decomposition cluster is CLOSED with n=16 evidence.**
> - **★ MOVE ORDERING = LIVE (has real HEADROOM) — THIS IS THE NEXT LEVER.** The descent OR-nodes are all pc≥17 (the
>   recurse spine; getK resolves ≤16). Deep node-weight bands **pc 17–22 (255M nodes): ETC ~0% · rank0 26% · rank1 19% ·
>   rank≥2 ~50% · no-cut ~5%** (`ETC+r0+r1 ≈ 45%`). **Half the deep nodes scan PAST rank 1 before the first cutoff**, and
>   ETC contributes ≈0% there (deep nodes have too few recurse children for the ≥2-child ETC batch) — so the cut is
>   essentially all move-order-driven and a better ordering that pulls the rank≥2 winners forward cuts measurably more
>   nodes (handoff: "move ordering worth ~2×"). **⇒ NEXT: build a deep-tail ordering enhancement and interleaved-A/B it.**
>   Candidates ([deep-root-ordering proposal](../proposal-2026-06-21-deep-root-ordering.md), priority): banded per-worker
>   **countermove** (avoids the prior global-history +130% cross-ply conflation), tail-only **1-ply reply-degree lookahead**
>   (gated when ≤2 roots remain via the existing `deep_busy`), secondary tiebreak keys (likely wash). **DEAD forms (don't
>   rebuild): global per-square history (+130% n=14), effective-degree (decays to ~0 / reverses +9–12% parallel — though
>   the current `M_ORD` IS effective-degree and won because the W_K substrate moved the lever; "levers compound").**
>   Use the committed `M_RANK` tap to A/B the rank-shift of any candidate. **Mandatory: an interleaved n=16 A/B that cuts
>   NODES (not just wall) — the +94%/+130% danger zone; n=14/single runs lie.**
>
> **Branch state:** keepers (Opt1 + ETC-reuse) are on **main**; branch `queens-compact-assoc-tt` carries them too + the
> dead assoc-TT/sidecar experiments (gated off) + the leaderboard/handoff doc updates. New work can fork fresh off main.
>
> **★ MEMORY-SIDE REFRAMED BY QUEUING THEORY ([queuing-theory proposal](../proposal-2026-06-21-queuing-theory.md)) —
> the contention "killer" is DEFUSED.** Pivotal number: the **solo tail runs the memory controller at ρ ≈ 8%**
> (λ_solo ≈ 60 M probes/s vs the measured **μ ≈ 780 M/s** ceiling) — ~12× spare capacity, an order of magnitude below the
> knee. The tail is **latency-bound, NOT bandwidth-bound**, so the lever is never "more bandwidth" — it's "use the idle
> server to pre-warm the tail's OWN future misses." The M/G/1 non-preemptive priority conservation law gives **B_free ≈
> 500–650 M/s** of speculative traffic before the tail's wait degrades. **⇒ the real memory lever is PREFETCH-ONLY
> future-key warming** (the parked "predict exact keys" lever — no recompute / no write-traffic / no eviction; strictly
> dominates the speculative-SOLVE pre-warm, which both the pre-warm sub and queuing sub independently concluded). The box
> is an **AMD Ryzen AI 9 HX 370** with **full RDT: cat_l3 + mba + cdp_l3 + cqm_mbm** (verified) ⇒ the speculative pool can
> be **L3-isolated (CAT) + bandwidth-capped (MBA ~60%) via `resctrl`** (the right layer for the user's "low-niceness"
> instinct — niceness is CPU-time, the contention is L3+MC). Other queuing results: **MLP-batched probes ceiling only
> 1.85× vs sorted-wave 5.7× at the SAME ~2× ordering tax** ⇒ if you ever pay the tax, pay it for the sorted wave, never
> plain MLP; **work-span: tail speedup ≤ 1.06×** ⇒ cleanly closes the 5 dead parallelization approaches (span ≈ total
> work); **Erlang-B: assoc-TT only pays at offered-load a≳1** (small-TT/n=18). **Two unknowns gate the memory lever, one
> cheap tap each:** (1) `M_COLD`/`QUEENS_COLD` = the solo tail's **TT cold-probe (miss) % by pc** — kill the whole memory
> family if <~25–30% (the transposition-saturation that killed parallelization may mean the tail is already-warm); (2)
> `ρ_solo` confirm via `perf stat -a -e amd_df/cas_count.*/` over the solo-tail window (QUEENS_ROOT_TIMING prints its
> start). **Build `M_COLD` next** (same `M_RANK`/`M_DECPROBE` pattern); it decides pre-warm + exact-key-prefetch in one run.
>
> **⇒ FULL LEVER MAP (end of --17, 6 design proposals + 3 n=16 taps):**
> | lever | verdict | gate/next |
> |---|---|---|
> | getK micro-opt (ALU/SIMD), batch-puts | **DEAD** (Opt1 was the win; rest OoO-hidden/load-bound; store-stall 0.08%) | — |
> | nimber / module / component decomposition | **DEAD (n=16 evidence)** | closed |
> | move ordering — banded-countermove/killer | **MEASURED-NEGATIVE (n=16 A/B), discarded** | always-promote +13.3% nodes (conflation); degree-gated −0.7% nodes but +3.6% wall (overhead) |
> | move ordering — tail-only 1-ply lookahead | untried (the residual ordering angle) | headroom real but NOT recency-capturable ⇒ needs actual lookahead, costly |
> | **prefetch — latency-hide the cold probes** | **★ the live memory lever** (M_COLD-confirmed: 400M cold loads to hide; ρ=8% budget) | gated by prefetch-DISTANCE / path-prediction |
> | speculative-SOLVE pre-warm | **reframed → effectively DEAD** | positions ~unique ⇒ "warm" = solve-ahead = parallelization (span-limited) |
>
> **★★ PIVOTAL M_COLD RESULT (n=16, committed `a9e9d0e`) — overturns the "transposition-saturated tail" premise.**
> The giant-root tail's pc≥17 entry probes are **99.6–100% MISS (cold)** — only **~0.2% hit**. Positions are
> **~unique** (re-exp ≈ 1.0× / distinct ≈ node count); the tail cold-computes, it does NOT re-probe warm. Consequences:
> 1. **The kill-criterion "tail warm ⇒ nothing to pre-warm" INVERTS:** the tail isn't warm — but that means **pre-warm
>    (speculative SOLVE) is dead for a *new* reason** — there's nothing to warm *from* (each position computed once), so
>    "warming X ahead" = computing X's subtree on a helper = **parallelization**, which alpha-β cutoff-serialization caps
>    (move ordering makes siblings serial ⇒ span≈work ⇒ ≤1.06×; the work-span verdict holds, just not via redundancy).
> 2. **The LIVE lever is PREFETCH, not pre-warm:** a cold MISS still pays the **DRAM load latency** (load the empty slot
>    to confirm miss). Prefetching the slot ahead makes that load warm (~40 vs ~165 cyc) **even on a miss** — pure
>    latency-hiding. The search is memory-latency-bound and ~half the ~165-cyc probe is still exposed past today's
>    one-ahead `prefetch_h` ⇒ hiding the rest is a large potential (rough napkin: exposed-probe ≈ a third of the tail).
>    **The gate is prefetch DISTANCE**: going 2–3 probes ahead needs predicting the search PATH, which is cutoff-dependent
>    (you don't know which child cuts until you evaluate it). Cheap first experiment: **deeper/speculative prefetch in the
>    descent** (prefetch the next 2–3 degree-sorted children's slots, not just the recurse child) — contained, just extra
>    `_mm_prefetch`; A/B it. Heavier: an SMT-sibling helper running the path ahead (the spare-budget synthesis).
> 3. **The flat-TT probe at pc≥17 EARNS ITS KEEP (probe-skip experiment, MEASURED-NEGATIVE, discarded).** Skipping the
>    `wins_inc` entry probe+put when ≤2 roots remain = **+19.3% nodes / +21.9% total cyc / +26.0% wall** (3-round n=16
>    A/B, all agreed). Despite 99.8% miss, the 0.2% hits are HIGH-VALUE: each caught transposition skips a subtree, and
>    skipping the *put* **cascades** (re-expanded subtrees aren't memoized for siblings). **pc structure of the cascade:**
>    a pc-17 node's children are pc≤16 getK *leaves* (no `wins_inc` recursion) ⇒ skipping pc-17 probes causes NO cascade,
>    but the probe (~80 cyc exposed) is a tiny slice of the node's ~17-getK-eval cost ⇒ pc-17-only skip is a predicted
>    WASH. Skipping HIGHER pc (near root) cascades worse AND those bands have MORE hits (0.4% @pc27-29 vs 0.1% @pc17). So
>    no probe-skip band wins. **Hard constraint (user): the end-of-solve PV scan walks the TT for the optimal line ⇒ the
>    TT must stay intact ⇒ put-skipping is ruled out regardless of cycles.** ⇒ **The pc≥17 probe is MANDATORY + COLD +
>    high-latency ⇒ the only memory win is PREFETCHING it** (latency-hide), confirming lever #2. No "skip/cheaper-probe"
>    escape; the saved-subtree-value tap is moot (the probe-skip A/B answered it directly: the value is large).
> | MLP-batched probes / sorted-wave | quantified (1.85× vs 5.7×), order-tax-bound | only if ordering tax paid anyway |
> | assoc-TT | wash at K=16 (Erlang-B a≪1) | revive n=18/small-TT |

## ⇒ NEXT SESSION (as of --16 — 30s e2e is MET (~27–28s); sidecar is the sub-25s stretch.)

> **--16 OUTCOME (2026-06-21).** Full detail: [proposal-2026-06-21-compact-assoc-tt](../proposal-2026-06-21-compact-assoc-tt.md).
> **Context correction:** the **30s process-wall is already met** (production e2e ~27–28s; earlier "30s" was the
> *search* wall under a slow tap). So the sidecar/DRAM-cut work is a **sub-25s stretch**, not the 30s lever.
>
> **LANDED — commit `97779e3` on branch `queens-compact-assoc-tt`** (off main; **cherry-pick the ETC-reuse hunks
> to main next session** — the branch also carries gated-off experimental code):
> - **★ ETC win-child re-probe elimination, now DEFAULT (no toggle).** Thread the M_ORD_W ETC `Some(1)` into the
>   fused descent (a known-win child is not recursed + entry-probed again). **6-round n=16 A/B @ 12 GB = WASH
>   (−1.4% wall, in noise)** — the win-child re-probe was already *warm*, not DRAM. Kept (user call): logically
>   correct, node-count ≤ baseline, cut grows at smaller TT / n=18. Gate-green (verdict + lineage + iso-flat distinct).
>
> **CLOSED / measured-negative (gated off, instructive):**
> - **Set-associative TT** (the chosen --16 lever): **wash-to-marginal at K=16.** The W_K K=16 collapse made the
>   393M working set FIT in ≤4 GB ⇒ no oversubscription for associativity to relieve; cyc/node is FLAT across TT
>   size (4→12 GB) ⇒ shrinking the table gives no residency win, only the assoc scan cost. `QUEENS_TT_ASSOC`
>   (seg + a band-free flat-assoc). The 4-byte-slot fp-floor problem is moot — the lever itself doesn't pay here.
> - **Sidecar-as-probe-cache** (`QUEENS_SIDECAR`, raw-pointer once-per-node L0 — the handoff's untried M_L0 angle):
>   **NEGATIVE — n=16 A/B = +9% cyc/node / +13% wall** (cyc/node ON ~5810 vs OFF ~5320, noise-independent).
>   Reuse ceiling is only **26.9%**; recency hit saturates **~17%** (mostly long-range), L2-resident ~15%, slow
>   roots NOT more cacheable, temporally flat. The `.with` overhead was NOT M_L0's killer — even raw-pointer is
>   negative (per-node probe overhead + put write-traffic + the repeats are TT-warm so a hit saves no DRAM).
>   **NOT declared closed — the +9% may be removable, not inherent. NEXT SESSION: micro-profile + optimize this
>   code DOWN TO THE ASM LEVEL** (perf-annotate `QUEENS_SIDECAR=1`): localize the +9% across (a) the per-node
>   `raw_l0_ptr` `.with` TLS lookup, (b) the `raw_l0_get` load+compare, (c) the per-put `raw_l0_put` write-traffic
>   (the chat's "avoid write traffic" — a read-only/pre-seeded cache removes it), (d) the restructured `got` branch.
>   If the overhead is mostly (a)+(c), the read-only/ETC-only redesign (below) could flip it.
>
> **⇒ THE ONE UNTRIED SIDECAR SHAPE (next session, from the chat critique) — if pursued, do exactly this:**
> **ETC-child-probes-only, READ-ONLY / pre-seeded** from the prior best run's trace, **small (128–512 KiB/worker)**,
> targeted at the **two monster roots**, keys **ranked by VALUE** (`ETC_cutoffs_caused × est_subtree_cost_avoided`,
> not frequency), **per-purpose chunks** (root_A/root_B/shared_bridge/ETC_cutoff/warmup), with **explicit harm
> tracking** (cycles_added_on_miss, cutoffs_from_sidecar, wall_saved). The naive "probe every lookup, write every
> put" is the M_L0/QUEENS_SIDECAR failure mode (proved twice). Estimate: mild 25–26s, strong 22–24s. Sub-20s
> likely needs graph-family/module reduction or a new proof-shape — NOT a cache.
>
> **⇒ FRESH LEVER (user, --16) — BATCH PUTS (untried, write-side, no move-ordering tax):** the read sorted-wave
> was killed by the consumer-access move-ordering tax (+94% nodes); **puts have no such tax** (writes don't change
> search order), so batching/sorting puts for DRAM row-buffer locality is a distinct, cleaner idea. Key analysis:
> a node's exit put writes its OWN slot, which the entry probe already warmed — so for *shallow* nodes the put is
> already a warm write (no win). The opportunity is *deep* nodes where the entry-warmed line evicted during the
> subtree expansion ⇒ the put is a cold **write-allocate** (a hidden ~165-cyc DRAM read). Batch+prefetch those, or
> non-temporal stores to skip write-allocate. **Constraint:** deferring puts hurts transposition VISIBILITY (a
> concurrent probe misses the not-yet-flushed key ⇒ re-expansion ⇒ more nodes) — same failure as the sorted wave;
> so either flush tiny, make the put-buffer probe-visible (= the sidecar, closed), or only prefetch (don't defer).
> Worth a measured try. Measure first: are deep-node puts cold (write-allocate DRAM) or warm? (extend M_PROF to
> time puts by pc, like it times gets).
>
> **Parked research (position-space, since the TT hash destroys structure):** predict **EXACT keys** (not hashed
> slots) to prefetch deeper future probes (the parked MLP-batched-probes lever — DFS state generates the future
> subtree); dim-reduction/PCA + reuse-admission predictor (capped at 26.9% for caching; the prefetch use is
> uncapped but gated by look-ahead key-compute cost). Worktree `/home/tavis/src/othello-assoc` (queens-tt-assoc-buckets)
> left from this session — remove with `git worktree remove`.

## ⇒ NEXT SESSION (as of --15 — GOAL CHANGED to 30s **END-TO-END** incl prep. BE RELENTLESS.)

> **NEW GOAL (user, --15):** n=16 in **30s END-TO-END** — *including the TT alloc + dense W8 prebuild*
> (the old 33.9s counted search only; the real process wall was ~39s). No cheating (no opening book /
> pre-solved roots). Autonomous, branch freely, don't wimp out.
>
> **⇒ NEXT SESSION CHOSEN (--16, user picked "b"):** build the **4-byte-slot SET-ASSOCIATIVE TT** — the one
> representation that cuts per-probe DRAM (a cache-line bucket of compact slots, SIMD-probe all of them; at the
> current ~30% load one line-fetch resolves the probe). Combine with the parked `queens-tt-assoc-buckets` branch.
> **Design constraint:** the fingerprint-correctness floor is **~46 bits for 393M keys** (a naïve 4-byte slot
> leaves only ~30 fp bits → ~0.03 wrong-hits/run = unsafe), so it needs a *shared/wider-fp* bucket scheme (one
> wider fp per bucket, or fp split across the line). The --15 wins (counting sort, warm-off, pext build) are
> **MERGED TO MAIN** (`c7a9409`).

**Branch `queens-30s-e2e`** (off `main`, NOT merged — decide merge with the user). Two committed wins
(gate-green: lineage + direct_w9..16 + graph_wins8 + iso-flat n=12 distinct 1,060,823 + n=14 iso-dense
byte-identical 3,955,635 + clippy):
- **`2b7687e` pext k=8 dense-table build → prep 3.3s→1.3s (−2.0s).** The real prep cost is the k=8 table
  build (2^28 codes via scalar `graph_wins`), NOT the TT alloc (~0.2s at 8.6 GB; alloc already overlaps the
  build via the spawned thread in `new_dense`). New `graph_wins8` uses `extract_adj` + pext induced-mask
  projection (the runtime `get9..` machinery) + new `W8_MASKS`. Bit-identical (`graph_wins8_matches_scalar`).
- **`dec6f28` branchless counting sort for dynamic move ordering → −9.9% cyc/node / −12.5% wall** (4-round
  n=16 A/B, 36.56→31.98s). `sort_moves_by_degree` was the **#1 branch-mispredict site (27.9% of all n=16
  branch-misses;** the search is frontend-bound 30%, IPC 1.23, ~16% of cycles lost to mispredicts). Replaced
  the insertion sort's data-dependent `while deg[j-1]>dk` with a stable counting sort (count/prefix/stable
  scatter — no comparison branch). Byte-identical node set.
- **`9b371ff` warm-restart OFF by default → −3.2% wall** (4-round n=16 A/B, 31.06→30.76s). The
  `warm_secs=2` warm pass + staggered restart trims nodes a touch but its ramp now costs more wall than
  it saves — the counting sort sped the kernel, so the fixed warm-phase overhead got relatively bigger
  ("levers compound"; it was wall-neutral in the M_WAVE era). Roots hit all cores immediately.
  `QUEENS_WARM_RESTART=1` re-enables.
- **WASH (kept only for its timing print):** `verts_of` closure-free vert extraction — the `call_mut` 6.85%
  was inherent loop body, +0.9% cyc/node (noise). The commit also adds the **e2e timing breakdown** that
  `solve` now prints: `(end-to-end: prep X + search Y + PV Z = T)`. PV (optimal line) is ~0.01s (warm TT).
- **WASH — isolated-vertex pair-strip** (`iso_strip`/`get_dyn` in dense.rs, the "two-for-one deal"): a
  zero-degree vertex is a `K1` clique (nimber 1), so removing an even number is win/loss-preserving
  (g(G⊔2·isolated)=g(G)). Built across get9..16 + a sparse `iso_strip_matches_scalar` gate; byte-identical
  (n=14 3,955,635). **4-round A/B (warm off both): −0.3% wall / −1.0% total cyc = WASH** (even the
  overhead-fused variant). **Why:** getK peels isolated verts *one ply at a time*, so each level usually
  has ≤1 isolated vert — the pair-strip rarely has 2 to cancel, and the *odd* (1-isolated) case needs the
  core's nimber (= the parked branch). So the boolean-getK isolated lever is fundamentally weak; the
  general two-for-one (any equal-nimber components cancel; nimber-1 = cliques K1/K2/K3) needs nimbers.
  **⇒ weakens the nimber-decomposition lever's premise too.**

**SCOREBOARD (branch, clean) — after W8-pext + counting sort + warm-off:** search mean **~30.8s** (12 GB
A/B B-mean 30.76s; good rounds ~29s), prep ~1.4s, PV ~0 ⇒ **end-to-end ~32s mean, good rounds ~30.4s**
(knocking on 30s; was ~39s at session start). TT-size for e2e: working set ~2.8 GB, so bits 30 (8.6 GB, 30%
full, prep ~1.6s) ≈ optimal; bits 29 (4.3 GB) saves prep but loses more to eviction; bits 31 (17 GB) costs
prep for no search gain. **NOTE: single n=16 runs are ±18% noisy — trust only interleaved A/B (the cyc/node
metric is unreliable for byte-identical changes when the parallel node count diverges; use wall + total cyc).**

**COST MAP (counting-sort binary, cycles):** `wins_inc` 27% — **dominated by the TT-probe DRAM stall** (66%
skid on the post-load `mov`; the ~165 cyc entry probe, only ~30 cyc hidden by one-ahead prefetch) + a 256-bit
stack spill (33% of wins_inc). getK evaluators (get9..16) **~35%** (the deep nested sweep). wK_get builders
~17%. sort 7.8%. **Branch-misses:** wins_inc 24%, wK_get builders ~38% (`verts_of`'s `while x!=0` per-word
loop-exits), getK ~25%.

**⇒ ATTACK-VECTOR MENU (--15) — by the *pattern* of this session's wins:**
- **(worked) #1 work-reduction** (W8 pext). Remaining: C1b pass the pext-built `adj` into getK to skip its
  top `extract_adj` (small); ILP the per-child pexts.
- **(worked) #2 branch-mispredict elimination** (counting sort, −9.9%). Remaining: the **descent cascade**
  (`if pc==16 else if 15…`, a data-dependent multi-way branch) → a jump-table/computed dispatch; the
  `verts_of` `while x!=0` loops (the #1 remaining mispredict source, ~38% — but bit-iteration is hard to
  de-branch).
- **(worked) #3 re-test gated levers after a win** (warm-restart-off, −3.2% — the balance flipped). **DO MORE:**
  re-A/B K-ceiling (16 vs 15), the M_ORD_W ETC (`QUEENS_ORD_ETC` 1 vs 0), warm timings — the counting-sort +
  warm-off shifted the cost balance, so other tuned-for-the-old-balance defaults may have flipped. **HIGH-EV,
  LOW-EFFORT — start here.**
- **(parked) memory:** TT set-associative buckets (`queens-tt-assoc-buckets`, fewer DRAM line-fetches/probe);
  BuRR compress. Re-test in this regime.
- **(parked, the real node-count lever) nimber decomposition:** handles the common 1-isolated case
  (`g(core ⊔ {v}) = g(core) XOR 1`) the boolean pair-strip can't; heavy (cutoff-free nimber recursion = 6.6×).

**⇒ THE WALL + NEXT LEVERS (--15):**
1. **The probe stall is NOT cheaply hideable — MLP-batched probes is likely CLOSED too.** Batching the entry
   probes needs a breadth/frontier visit order, which forfeits depth-first move ordering — and the +94%
   sorted-wave finding proved ordering is worth ~2×. Same root cause that killed Approach B. (Not 100% proven
   for MLP specifically, but the analysis is strong; don't sink a session into it without a cheap proxy first.)
2. **getK node-count via NIMBER DECOMPOSITION (the real lever; the parked `queens-component-nimber` revival).**
   The getK leaves (35%) "peel isolated vertices one ply at a time" — isolated verts are size-1 components
   (*1). A **Grundy-valued component table** (≤8 verts: W8-shaped but nimber, ~2^28×4 bits) + connected-
   component decomposition inside getK would collapse decomposable pc≤16 graphs (XOR component nimbers, G is a
   LOSS iff total==0) instead of the deep boolean recursion. Heavy (nimber table build cost — mex not OR — +
   component detection), but it attacks the biggest compute bucket AND is move-order-preserving. **FIRST: measure
   the decomposability of the pc 13–16 tail** (what fraction of getK graphs have ≥2 components / an isolated
   vertex) with a gated `count`-style tap — if most are decomposable, this is the win.
3. **Small stackable wins (each ~1%, may wash like verts_of):** `verts_of` fixed-count loop (outer `for 0..K`,
   inner `while x==0` word-advance — fewer loop-exit mispredicts); degree-compute SIMD (VPOPCNTQ 2 moves/zmm —
   *check auto-vec first*); C1b pass the pext-built `adj[]` into getK to skip its top-level `extract_adj`.
4. **PGO** (build-process, `make pgo-queens` → `target/pgo-release/release/queens`) — A/B measured this session
   (result in the --15 note). Use for record runs.

---

## ⇒ NEXT SESSION (as of --14 — 52→33.9s DONE, 30s is CLOSE. BE RELENTLESS.)

> **MISSION (unchanged, user drill-sergeant):** drive n=16 to **30s**. We're at **33.9s clean** (was ~52s) —
> ~12% to go. Do NOT declare a floor. Reason *through* walls.

**Where we stand (clean 17 GB, `main` @ the `--14` commits):** n=16 **33.9s / 396 M nodes / SECOND** (TT only
**16.5% full** — the W_K layers collapsed the working set to ~2.8 GB; a small TT may now suffice, big change from
the 17 GB-tight regime). **−35% vs the prior ~52s K=12 M_ORD_W default.** Two stacked --14 wins, both committed,
gate-green:
- **pext-per-row getK code-build** (`adj_row_pext` in iso_flat.rs): replace the scalar K(K-1)/2 `Bits::get`
  bit-tests with one 4-word BMI2 `pext` per vertex → the labelled adjacency row, packed into the code (straddle-
  split for K≥12). **−3.8% cyc/node n=16.** Byte-identical. The proposal §5 negative only ever measured a
  *scalar rectangular reshape* — pext at K=12+ scale was never tried, and the Fermi flips there (znver5 pext is
  3-cyc/1-per-cyc). **This obsoletes the whole "compiler-vectorize-K≤9 / getK-throughput-is-stuck" framing.**
- **W13/14/15/16 dense layers + default K=12→16** (the u128 labelled-code ceiling, 16·15/2 = 120 bits). With
  cheap pext builders, **raising K pays the whole way up**: each layer keeps cutting ~14–22% nodes (n=14 det
  K=12 7.9M → K=16 4.0M = −50%, NOT diminishing — K=15→16 was −22%). The cut is **inherent / TT-independent**
  (16 GB nodes == 12 GB nodes), so it holds at production TT. n=16: 12 GB 3-round A/B K=16 −26.4% wall; 16 GB
  single-run 49.5→34.4s; clean 17 GB 33.9s. cyc/node +66% at K=16 (the getK evaluator sweep) but −57% nodes wins.
  `wk_masks128` rebuilt incremental (O(2^k·popcount)) to keep const-eval under the deny-limit at k=16.

**⇒ NEXT LEVERS for 30s (priority order):**
1. **W_K crossover ENDS at K=16 — K=17-as-built is MEASURED-NEGATIVE (the W_K node-cut lever is exhausted).**
   Built+tested+reverted this session: a **table-free, adj-based `get17`** (the 136-bit K=17 code exceeds `u128`,
   so it works from `adj[17]` directly — `adj_row_pext` builds the 17-bit rows, children are all ≤16 verts ⇒
   existing `u128` getK, child code repacked from `adj` via `pack_from_adj17`; no 256-bit code, no `2^17` induced
   table needed — much simpler than the "256-bit codes" plan I'd first sketched). Validated (lineage n≤9 vs naive
   under `QUEENS_DENSE_K=17`; n=12/14 SECOND; n=14 nodes 3.955M→**2.714M = −31.4%**). **But n=16 4-round A/B
   (12 GB): nodes −19.4%, cyc/node +30.7%, WALL +5.7% — a LOSS.** Why: pc==17's subtree is *shallow* (one ply to
   the getK leaves), and the pc 17+ tail is transposition-saturated, so a flat-TT-**memoized** recurse node (probe
   → hit on the many transpositions) beats `get17`'s **memo-less** full recompute of every pc==17 occurrence. This
   is the OPPOSITE of pc≤16 (where getK saves a deep *subtree*, worth more than the probe). The lever is exhausted
   for the memo-less getK. **Reverted** (main carries only winning layers); the adj-based design is recorded here.
   - **Untried angle (could flip it, the real 30s bet):** a **MEMOIZED get17** — keep the pc==17 entry TT probe
     (transpositions hit cheaply) but on a miss resolve via `get17_from_adj` + put, **skipping the degree-sort**
     the K=16 recurse node pays (the sort is ~21% of cycles; for pc==17 it only orders 17 getK children for an
     earlier cutoff). I.e. a cheaper *expand* for the layer just above the ceiling, not a probe-free getK. Net is
     uncertain (the sort also earns cutoffs); build `get17_from_adj` again (it's ~40 lines, fully specified above)
     + a pc==17 arm that probes-then-get17-on-miss, and A/B vs K=16. K=18+ generalizes (project each child's adj
     via `pext`, recurse to `getK-1_from_adj` for the cpc==K-1 isolated child) but inherits the same memo problem.
2. **getK evaluator cost (~35% of cycles now; the get9/get10 *leaves* of the nested sweep dominate, NOT the high
   layers).** The nested recursion peels isolated vertices one ply at a time (the sparse pc 14–16 tail is full of
   them). Hard (a win/loss table can't decompose isolated verts — that needs nimbers, the parked 6.6× branch).
   Cheaper-per-call angles: C1b pass the pext-built `adj[]` into getK to skip its `extract_adj` (top call only);
   ILP the per-child pexts. Perf-record the K=16 binary first (the profile is in `/tmp/k16.data`).
3. **Memory stall / MLP** (was the --13 lead) — K-raising already shrank it (fewer pc≤K probes; TT 16.5% full).
   Re-profile before investing; the `wins_inc` entry probe is ~24% but partly the recurse spine now.
4. **Smaller TT** — the working set collapsed to ~2.8 GB (16.5% of 17 GB). A 4–8 GB TT may match the wall with
   better TLB/cache and far less memory (also unblocks safe interleaved A/B at production-equivalent fill). Quick
   A/B: `abenv.sh 16 <bin> QUEENS_TT_SLOTS 2147483648 500000000`.

**Measured WASH this session (reverted, do not redo as-is):** degree-sort restructure (closure-free `popcount` +
fused per-word `(avail&!att).count_ones()`) — the `sort_moves_by_degree` 14.7% + `call_mut` 6.7% in the profile
looked removable, but the degree compute is **inherent arithmetic** (4 AND + 4 popcount/move); n=16 A/B = −0.1%
cyc/node. The only untried angle is **hand-SIMD across moves** (VPOPCNTQ, 2 moves/zmm) — risky (small-data
scorecard), and the compiler may already vectorize it; annotate `sort_moves_by_degree` body first.

---

## ⇒ NEXT SESSION (as of --13 — THE 50→40→30s GRIND. BE RELENTLESS.)

> **MISSION (user, drill-sergeant — channel this energy every turn):** drive n=16 to **30s**. **Do NOT give
> up. Do NOT wimp out. Do NOT get stuck. Do NOT declare a floor or a "hard limit" — that judgment is the
> user's alone (CLAUDE.md).** The user is asleep and wants to *wake up to progress, not excuses.* When you hit
> a wall, reason *through* it or *around* it. **Optimize at EVERY level — do NOT skip micro-opts; go all the
> way down to `perf annotate` ASM-instruction tweaks.** Big structural levers AND 1% shaves; they stack. Hobby
> project, no users — **work on a branch / spin a new solver variant if you're worried about main.** Keep
> going until 30s or you've genuinely exhausted every lever — then find another. Goalposts escalate: 50→40→30.

**Where we stand (clean 17 GB, current `main` @ `8f00881`):** n=16 **cyc/node is the metric now** (TT-size- and
node-noise-independent; wall is ±parallel-node-noisy). Search wall **~52s clean / ~49s best round** (was
57.58s), **0.94 B nodes**. **Cumulative cyc/node −12.5% vs the M_ORD_W baseline this session.** Close to 50s;
the grind to 40→30 continues.

**THE METHOD THAT'S WORKING — keep doing exactly this:** perf-record the *real* n=16 run (`perf record -F 999
-o x.data -- ./target/release/queens solve 16 iso-dense --to-file x.json`) → **`perf report --sort=symbol`
(aggregate across all 24 workers, NOT the per-thread default)** → biggest bucket → **`perf annotate -s <fn>`
to the hot instructions** → kill it → A/B. Harnesses (committed): two-binary `scripts/ab2.sh <n> <binA> <binB>
[rounds]`, env-value `scripts/abenv.sh <n> <bin> <ENV> <vA> <vB> [rounds]` — both 12 GB TT, cyc/node from
`perf stat -o`, --to-file JSON, fresh tmux window (`queens:absort`), poll the JSON file (NOT the pane —
completion markers false-match the command echo). Save each winning binary aside (`/tmp/queens-*`) as the next
A/B baseline. **n=14 single-thread = build-polluted (26s serial dense build) — useless for cyc/node; use it
only for the deterministic byte-identical node-count gate (7,886,898).**

**BANKED THIS SESSION (committed, gate-green, n=14 byte-identical 7,886,898):**
- `fde7baf` **M_ORD_W → iso-dense DEFAULT** (the −38% SUB-60 win is now production; `QUEENS_ORD=0`→M_WAVE,
  `=1`→M_ORD). Leaderboard "default" tag updated in project CLAUDE.md.
- `4ff7bd9` **inlined stable insertion sort** for the degree order → killed std driftsort machinery
  (`insertion_sort_shift_left`+`quicksort`+`sort8_stable`+`drift`+`memmove`+ the FnMut comparator `call_mut`),
  which the profile showed was **~30% of total search cycles** — the single biggest find. **−10.9% wall /
  −8.5% cyc/node.** (Stable insertion sort ⇒ byte-identical node count; small move lists at the deep tail.)
- `8f00881` four stacked cyc/node wins: **inline-each** (`Bits::each` was outlined → `call_mut`, −1.4%),
  **sort-fuse** (`sort_moves_by_degree` now emits the sorted `degree[]`; the M_ORD_W gather + fused descent
  read it instead of recomputing `child0.popcount()`, and the gather skips the `and_not` for cheap children;
  const-folds per MODE), **prefetch-reorder** (issue `prefetch_h` for the recurse child BEFORE `child_orient`
  — the slot route is already in the gather SoA, buys ~30 cyc latency-hiding distance) [sort-fuse+prefetch =
  **−3.1% cyc/node** together], **startup-overlap** (build dense ‖ TT alloc — **MEASURED WASH**: both
  memory-bandwidth-bound, TT-zeroing competes with the W8 build; harmless, the commit msg overstated it).

**THE PROFILE (post-insertion-sort, n=16, aggregated — YOUR TARGET MAP):**
- `wins_inc` **57.6%** = recursion + the inlined sort-compute (~13%) + the ETC gather + the descent + a
  **15.6%-on-ONE-instruction `test $0x1,%al` TT-probe-result STALL** (the DRAM/memory floor; the entry probe).
- **getK builders (w8..w12_get) 20.7% + evaluators (get9..12) 8.7% = ~29%** — the scalar K²/2 `row.get(vj)`
  bit-test code-build. Compiler vectorizes K≤9, falls to scalar K≥10. **Hand-SIMD AND uniform-reshape both
  measured-DEAD** ([getk-throughput proposal](../proposal-2026-06-19-getk-throughput.md) §4/§5). OPEN: a
  *fundamentally different* code-build, attacked at the asm level (user explicitly wants this).
- `band_entry` 4.9%, `child_orient` 2.5% (the 7 `and_not`s — verify it vectorizes to AVX-512 `zmm`).

**NEXT LEVERS — STACK THEM ALL (priority order; channel-Fermi each before coding):**
1. **K=13 default decision (do FIRST — nearly free).** Under M_ORD_W, K=13 **FLIPPED to a net win** (was +4%
   under M_WAVE): n=16 12 GB A/B = −14.8% nodes / +11.5% cyc/node / **−2.9% wall** (n=14 deterministic −13.9%
   nodes). **BUT TT-size-sensitive** (12 GB has more eviction → bigger node cut; 17 GB memoizes more → smaller
   cut). **A/B K=12 vs K=13 at ~15–17 GB before defaulting** (`abenv.sh 16 <bin> QUEENS_DENSE_K 12 13 3`,
   tt≈1850000000). If it holds → default (clamp `12`→`13` in `new_dense`).
2. **K=14/K=15 (implement, mechanical).** Follow `get13`/`w13_get`/`W13_MASKS` exactly (K≤16 fits `u128`:
   K(K−1)/2 ≤ 120 bits). If K=13 holds, K=14 likely continues (~−13% nodes/layer, diminishing but stackable).
   Add the `direct_w14_matches_scalar_recurrence` test + the `DK==14` dispatch/instantiation arms.
3. **★ MLP on the explicit-stack frontier (`wins_inc_iter`, gated `QUEENS_ITER` — already built,
   throughput-neutral infra). THE BIG ONE for 30s.** The 15.6% TT-probe stall is the memory floor; a DFS
   can't hide it. The materialized frontier can: hold K frames *probed-not-expanded* → K DRAM gets in flight →
   overlap the ~165 cyc latency. Handoff's named "not-yet-tried" lever, est −10%+. Heavy but the user wants 30s
   — this is the path *through* the memory wall, not around it.
4. **getK code-build at the ASM level (29%!).** `perf annotate w12_get`/`w11_get`/`w10_get` instruction by
   instruction — the `bt`/`row.get(vj)` per-pair scatter, the verts-scatter. Reshapes are dead, but the user
   wants asm-level tweaks; find a *different* attack (e.g. is the `dense8.get12` child sweep's per-child
   `pext128` + table load reducible? the `extract_adj128`?).
5. **Warmup re-sweep (free, env).** `QUEENS_WARM_SECS`(2)/`WARM_STAGGER_MS`(500)/`WARM_RESTART` — the optimum
   predates dynamic ordering; `abenv.sh 16 <bin> QUEENS_WARM_SECS 2 3 3`, etc.
6. **Micro-opts the user explicitly wants (don't skip ANY level):** M_ORD plain-descent sort-fuse (only
   M_ORD_W got fused — M_ORD's plain descent at the `for &sq in moves` ~line 1936 still recomputes), the
   `band_entry` tiny-code build, `child_orient` AVX-512, the M_WAVE_C/gated arms. Each ~1% — they stack.
7. **Better dynamic ordering (node-count, speculative — A/B hard, history/effective-degree are documented-NEG).**
8. **★ ETC-economics diagnostics (ChatGPT, --13) — measure WHERE to TARGET the ETC/ordering work.** The ETC
   gather (eager key-build + batch probe of *all* recurse children) is a big chunk of `wins_inc`'s 57.6%. Add a
   gated `count`-style instrumentation pass (monomorphised `const HIST`, zero prod cost — the established
   pattern) to map where the cut value concentrates, then aim the optimization (lazy probe / band-specific
   probe / better ordering) at that region:
   - **first-losing-child RANK, before vs after ordering** (THE key one): histogram the descent position of the
     first child-loss (the cutoff). Tells you where to target — e.g. if cuts cluster at rank 1 post-ordering,
     a *top-k* / lazy ETC concentrated on the front captures them cheaper; if spread, the full batch earns its
     keep. (#4 top-k was measured-dead under M_WAVE — RE-MEASURE under M_ORD_W, the rank distribution shifted.)
   - **ETC cutoffs by popcount band** (which pc the ETC saves work at → target the probe there), **by root** /
     **by producer root** (concentrated in the giant root or spread → where to focus), **by warmup-generated
     entries** (does the 2s warm pass create the entries the ETC later cuts on? — ties to the warmup re-sweep).
   - **ETC failed-probe cost** (probes that found neither loss nor empty): count them + their key-build cycles
     by band — shows where the probe budget goes, so you can target the gather cost reduction at the right pc.

**Negative this session (note the untried angle):** startup-overlap = WASH (both memory-bw-bound; untried:
overlap the build with the *search warm phase* instead, or skip MADV_COLLAPSE and let THP do it lazily).

**Measured-negative AS BUILT (gated off; NOT closed forever — record the exact build tried + the untried angle
that could flip it; several of our best wins were net-negative until tuned, e.g. unfused M_WAVE +4.9% → fused
−4%, the bogus "36 M/s floor", and *this session's −38% ordering win came straight out of the Approach-B
negatives).* Don't blindly rebuild the same thing — attack the named untried angle:**
- **Sorted-frontier wave (`M_WAVE_B`, +94% nodes).** The tax is slot-order *consumer access* forfeiting move
  ordering — fundamental (ordering ≈ 2×). *Untried angle:* none obvious for the access-order half; treat the
  sorted-*locality* prize as the hard-dead one. (The dedup half is separate, below.)
- **L0 probe-cache dedup (`M_L0`, +6% cyc/node).** Net-negative as a per-worker RefCell+`.with` direct-mapped
  cache — but the killer was the **per-probe TLS/borrow overhead**, not the idea (node-cut was ~0, hit-rate low
  vs the already-warm TT). *Untried:* a raw-pointer / `UnsafeCell` L0 (no `.with`/borrow), different size/index,
  or targeting it ONLY to the ETC's speculative child probes (ChatGPT #7). Upside is bounded (node-cut ~0.7%),
  but it was never tuned.
- **Grouped-frontier DDD.** Closed *only* for the variant that reorders consumer access (= the +94% tax) or
  goes cutoff-free (the parked nimber 6.6×). *Untried:* a **move-order-preserving** dedup (dedup within
  move-order batches, no reorder) — never built.
- **Cascade-reorder (`M_WAVE_C`, +2.1% cyc/node).** Net-negative because the **duplicated recurse body** bloated
  the frontend-bound loop. *Untried:* the no-duplication form via `unreachable_unchecked` in the cheap-arm
  fallback (shrinks the loop back) — could flip to neutral/positive.
- **ETC top-k probe budget (#4, distributed cuts).** Probe-count cap can't shed the overhead because the
  overhead is the **gather** (key-build + the triple-`child0` recompute), not the probes. *Untried (the real
  lever):* the triple-`child0` redundancy kill (item 2 above) attacks the actual cost.
- **ChatGPT #1 (slow-root-only) / #3 (polarity, N/A — all OR nodes) — weak by analysis, not measured.**

The standing rule is the *shape*, not a closed door: **the giant-root tail's work resists frontier-reorder/dedup
because move ordering is worth ~2×; levers that preserve move order win** (dynamic ordering proved it). A
reorder/dedup lever can still pay IF it doesn't disturb the consumer's move order — that's the open crack.

**Tooling:** `scripts/queens-ab.sh` now parses `--to-file` JSON + auto-prints the off/on Δ (nodes/cyc/node/total
cyc/wall). Runs go in a **fresh dedicated tmux window** (never the user's panes); poll JSON/`$STATE`, not the pane.

## Context

The deep search was a recursion. This session converted it to an **explicit-stack loop** ("unwind the
recursion into loops") to (a) test whether the per-node control-flow/unwind cost is real, and (b) build
the **materialized-frontier shape** that the parallelism-deficit levers require. The user's framing was
exact: *"the recursion→loop conversion isn't the win — it's the key that unlocks the win."*

**Throughput verdict (measured): recursion→loop is a wash, not a win** — confirming the iso-window
finding that RAS/return-mispredict is measured-dead (0.003%), so removing call frames buys ~nothing:

| variant | flag | n=16 cyc/node vs recursive control | verdict |
|---------|------|------------------------------------|---------|
| `solve_local` → iterative (≤7 band) | `QUEENS_UNROLL` | wash (~3428 both) | reach too small (band-entry misses) |
| `wins_inc` peel-the-get (probe child inline) | `QUEENS_PEEL` | wash / +0.2% | call frame around a hit is RAS-free |
| `wins_inc` → **full explicit stack** | `QUEENS_ITER` | **+4.3%** raw → **parity after micro-opt** | the shape we keep |

All three are **gated OFF by default; production byte-identical** (n=14 deterministic 12,896,443 both
ways; iso-flat n=12 `--distinct` 1,060,823 / 1.25×; lineage + clippy green). The raw explicit-stack
+4.3% was the materialized-frame memory traffic (`orient[8]` push/pop) exceeding the removed call
overhead; an Opus micro-opt sub-agent **closed it to parity** by hoisting the top frame's hot fields
(`avail`/`mi`/`nmoves`/`moves_start`) into registers across the inner child loop + `get_unchecked` arena
indexing (perf showed a 26.8% `child0` stack spill/reload that vanished). So the shape is now
**throughput-neutral infrastructure** — no regression to justify carrying it.

## What the shape unlocks (the reason it exists)

A recursive DFS hides the search frontier in the opaque native call stack. The explicit `IncFrame` stack
**materializes the frontier as inspectable/reorderable/splittable data**, which enables (in priority order):

1. **ABDADA in-flight markers** — mark a node "being expanded" in the TT (busy bit); a worker about to
   push a frame for a node already in-flight elsewhere **defers** it (jumps to another pending frame)
   instead of re-expanding. Hits the *exact* measured re-expansion band (pc 13–21). Recursion can't
   defer-and-resume an arbitrary node; the frame stack can reorder/skip the pending set.
2. **Frontier work-stealing** — the frame stack is splittable at *any* frame, so an idle worker steals a
   frame-range from the busy giant-root worker → parallelises the serial OR-spine tail (the "2-root
   plateau"). Recursion only splits at root moves.
3. **Grouped-frontier DDD** — materialise the pc 13–21 frontier, bucket by graph signature, solve each
   unique boundary graph once (dedup by sort, bandwidth-bound). The n=18 enabler / path below ~1m40s.
4. **MLP-batched probes** — hold K frames "probed-not-expanded" → K TT gets in flight → overlap the
   ~165-cyc exposed DRAM latency (only half-hidden today by one-ahead prefetch).
5. **Checkpoint/resume + best-first move reordering** — the frame stack is serializable (n=16-to-
   completion / n=18 needs checkpointing); per-frame pending-move reordering cuts nodes.

## NEXT SESSION — build ABDADA / frontier work-stealing on `wins_inc_iter`

> **SUPERSEDED (historical, from --6).** ABDADA + work-stealing were built and measured-negative (--7/8);
> the whole parallelization + frontier-reorder/dedup route is **closed** (see the top "⇒ NEXT SESSION" block).
> Kept for the record only.

The target is the giant-root tail (51% util, ~half the n=16 wall). Two levers, both on the explicit stack:

- **ABDADA in-flight markers (start here — most surgical, hits the measured re-expansion set).** Add a
  per-slot "in-flight" state to the TT (a reserved value or a sidecar bit). On `wins_inc_iter` push: if
  the child's slot is already marked in-flight by another worker, **defer** it (move it to the back of the
  node's pending moves and try a sibling first; only block/re-probe if all siblings are exhausted). On
  pop/put: clear the marker. Measure re-expansion (`--distinct` re-exp at n=14, node count at n=16) and the
  tail core-util (`/proc/stat` sampler aligned to `QUEENS_ROOT_TIMING`, see iso-window session --5 method).
  Gate: must keep the n=14 verdict and not *increase* re-expansion (the whole point is to cut it).
- **Frontier work-stealing (bigger).** Let an idle rayon worker steal a contiguous frame-range (a sub-
  frontier) from a busy worker's `INC_STACK`. Needs the arena to be shareable/splittable (today it's
  thread-local) — design decision: per-worker deque with steal, or a shared frontier pool. This is the
  structural fix for the OR-spine width limit.

**Channel-Fermi first** (per CLAUDE.md): the tail idle pool is ~501 core-s → naive ceiling ~21s (~20% of
wall). ABDADA's prize is bounded by the re-expansion it removes (measure the re-exp at pc 13–21 first with
the existing `--distinct`/`count --comps` tooling before building).

## Codebase Reference

| What | Where |
|------|-------|
| `wins_inc_iter` (explicit-stack deep solve), `IncFrame`, `INC_STACK` arena | `src/queens/solver/iso_flat.rs` |
| recursive control `wins_inc` (the A/B baseline; production default) | `src/queens/solver/iso_flat.rs` |
| dispatch: `_ if !ORACLE && self.iter_inc => wins_inc_iter` | `par_wins_inc` (M_NORMAL arm) |
| flags `iter_inc`/`unroll` (read once in `from_tt_with_window`) | `IsoFlat` struct + ctor |
| iterative ≤7 band `solve_local_iter` (the `QUEENS_UNROLL` twin) | `src/queens/solver/iso_flat.rs` |
| TT (where an in-flight marker would live) | `src/queens/tt.rs` |
| root-timing / tail-util method (`QUEENS_ROOT_TIMING` + `/proc/stat` sampler) | iso-window session --5 note |

## Build / test / validate

Per CLAUDE.md. Gate: `solver_lineage_agrees` + iso-flat n=12 `--distinct` = **1,060,823 / 1.25×** + n=14
≈29.16M/1.02×; clippy `-D warnings`. **A/B = `scripts/queens-ab.sh 16 QUEENS_ITER ./target/release/queens`**
(the committed harness — 12 GB TT memory-safe, cyc/node, `BEGIN/END` markers, `QUEENS_AB_DONE` completion).
Fast proxy = single-thread n=14 interleaved (deterministic). **Never `tmux send-keys C-c` into a busy pane**
(SIGINTs the solve); **never run 17 GB-TT solves back-to-back** (OOM-kills the 2nd run).

## Progress

- [x] **--15 (branch `queens-30s-e2e`, NOT merged): goal → 30s END-TO-END (incl prep). Search ~−16% + prep
      −2s.** See the top "⇒ NEXT SESSION (--15)" block. Commits on the branch: `953e7e3` (verts_of wash +
      e2e timing print), `2b7687e` (pext k=8 build, prep 3.3→1.3s), `dec6f28` (branchless counting sort,
      −9.9% cyc/node / −12.5% wall — the headline), `9b371ff` (warm-restart OFF default, −3.2% wall),
      `d0b8844` (isolated-vertex pair-strip — MEASURED-NEGATIVE, gated `const ISO_STRIP=false`/DCE). All
      gate-green (lineage + direct_w9..16 + graph_wins8 + iso_strip sparse + n=14 iso-dense 3,955,635 +
      n=12 distinct 1,060,823 + clippy). PGO = NEGATIVE now (+2.6% cyc/node, mis-profiled vs the new path).
      Clean e2e (warm box) ~33.7s; A/B-extrapolated good rounds ~30.4s. **DECIDE: merge branch to main.**
      NEXT = re-sweep defaults (K-ceiling/ETC), descent-cascade jump table, then the parked nimber lever.
- [x] **--14: ★★ pext getK code-build + W_K K=12→16 default = −35% wall (52→33.9s clean).** See the top "⇒ NEXT
      SESSION (--14)" block. Commits: `adbfb10` (pext w10-13, −3.8% cyc/node), `41dcf70` (W14 opt-in), `2dd5ef2`
      (W15/W16 + incremental `wk_masks128`), `16d8842` (default K=16). Gate-green throughout (byte-identical K=12,
      direct_w9..16, lineage, iso-flat distinct). Degree-sort restructure = WASH, reverted. **K=17 (adj-based,
      table-free `get17`) BUILT+TESTED+REVERTED = MEASURED-NEGATIVE** (n=16 −19.4% nodes but +30.7% cyc/node /
      +5.7% wall — the W_K crossover ENDS at K=16; pc==17's shallow subtree ⇒ TT-memoized recurse beats memo-less
      getK recompute; untried = a *memoized* get17 that skips the degree-sort). Smaller TT (4 GB) = +9.5% wall
      (eviction outweighs the −2.5% TLB win); 17 GB stays. **PGO now PAYS on the K=16 path: `make pgo-queens` →
      `target/pgo-release/release/queens` = −1.3% cyc/node / −2.4% total cyc (4-round n=16 A/B)** — small but real
      (was "no move" at M_WAVE; the new getK-branch-heavy path lays out better). Build-process only (no source
      change); use the PGO binary for record runs (33.9s → ~33.4s). NEXT = memoized-get17, getK-evaluator cost,
      memory/MLP.
- [x] `solve_local_iter` (`QUEENS_UNROLL`) — wash at n=16, gated, committed (`3f10919`)
- [x] `wins_inc` peel-the-get (`QUEENS_PEEL`) — wash, then superseded/removed in favour of the full stack
- [x] `wins_inc_iter` full explicit stack (`QUEENS_ITER`) — +4.3% raw, gated off, committed (`3f10919`)
- [x] Opus micro-opt of `wins_inc_iter` — **closed +4.3% → parity** (register-hoist + `get_unchecked`)
- [x] Canonical A/B harness committed (`f124bc5`, `rust/scripts/queens-ab.sh`) + CLAUDE.md lessons
- [x] Micro-opt committed (`8fb23dd`) — n=16 A/B parity (off 2994.8 / on 2994.0), gate green
- [x] **ABDADA in-flight markers on `wins_inc_iter` — BUILT, gated off, correctness-validated
      (`773ba8d`); n=16 A/B = wash-at-default / LOSS-paired-with-finer-split (structural negative,
      see session --7 note).** The deferral can't crack the giant-root tail (the re-expansion is in
      *large* pc 13-21 nodes; a deferrer can't profitably wait for one).
- [x] **Frontier work-stealing on `wins_inc_iter` — BUILT + exhaustively tuned, measured a structural
      NEGATIVE** (`fb6b972`, `be4dc57`, `ce46f41`). rayon-scope publish of even-frame children to idle
      cores (ABDADA markers coordinate; deferral resolves to a stealer's hit). Best tuned config
      (`QUEENS_STEAL_DELAY=50` / `WIDTH=2` / `MIN_PC=35` / `MAX=24`) is **+8.7% nodes / +13.3% wall** in a
      4-round interleaved n=16 A/B (default 17 GB TT). 5th parallelization approach to fail; the tail is
      transposition-saturated. Gated off (zero prod cost). See the 2026-06-19--7/8 note.
- [~] **PIVOT (in progress, 2026-06-20--9): characterize the tail, then attack the WORK (not the schedule)** —
      DDD / getK / **MLP**, not parallelization. Macro re-anchor done (see the 2026-06-20--9 note): under W12
      the tail is **ONE giant root = 94% of wall**; TMA is co-dominant **memory 30% + frontend 31%**; the
      DRAM-probe bucket has a **not-yet-tried** lever (MLP-batched probes on `wins_inc_iter`). Lever choice =
      user steer.
- [x] **A'' Phase-0a — threaded sorted-stream microbench (`tt.rs::mlp_bench::mlp_probe_threads_sweep`),
      GREEN (2026-06-20--10).** The single-thread 5.7× sorted-stream ceiling **survives contention**: sorted
      aggregate scales 1→4 cores (275→764 M/s), the over-today multiplier holds ~5× through 4 cores, and the
      memory subsystem **saturates at ~780 M/s with ~4–8 streaming cores** (the new measured probe-throughput
      cap). Leverage is highest with FEW consumer cores (5× @4, eroding to ~2.8× @8 oversubscribed) — exactly
      Approach B's shape. ~4 sorted-consumer cores out-probe the whole current ~14-core random tail. Gated
      `#[ignore]` test, no production change; clippy/fmt green. See the 2026-06-20--10 note.
- [x] **A'' Phase-1 — Approach A (ETC + sorted-batch, `QUEENS_WAVE`/`M_WAVE` in `wins_inc`), BUILT +
      measured: real −17.4% node cut, but per-node critical-path overhead makes it a WALL LOSS (2026-06-20--10).**
      Enhanced transposition cutoff: each OR node ETC-probes its recurse-arm children (sorted by slot, all
      prefetches up front = MLP batch) *before* expanding any; a TT-proven-loss / empty child wins the node →
      cut, skipping the miss-siblings' expansion. Gated off, control byte-identical, verdict-correct (lineage
      n≤9==naive under `QUEENS_WAVE=1`; n=8/10/12 verdicts; clippy/fmt). **n=16 A/B (12 GB TT, 3 interleaved):
      nodes −17.4% (robust −13…−20%) but cycles +4.9% / wall +9.2% / cyc/node +27%.** The cut is real and large;
      the gather/key-rebuild/double-cold-probe on the hot path costs more than it saves. **⇒ realize the cut OFF
      the critical path (Approach B idle-core prep), not per-node.** See the 2026-06-20--10 Phase-1 note.
- [x] **A'' Phase-1b — FUSED M_WAVE (Opus micro-opt sub-agent): the cut is now a total-cycle WIN at n=16
      (2026-06-20--10).** Fused the ETC pre-pass with the descent — each recurse child's key built ONCE (gather
      stores the descriptor; the descent reuses it, no `lex_min8`/`d4_bits`/`hash128` rebuild) and the sort
      dropped (Fermi-below-bar at ~3–12-child batches). Killed the double key-build (perf: the unfused version
      was +69% L1-dcache-miss). **n=16 A/B (6 interleaved rounds): nodes −16%, total cycles −4.1% (ON wins 5/6),
      wall negative** — flips the unfused +4.9% cyc/+9.2% wall to a win. Gates green + parent-re-verified
      (control byte-identical; lineage/verdicts/clippy/fmt). TT-sweep verdict-correct + graceful to a 2 GB TT.
      Gated off; now a **defaults-on candidate**. See the 2026-06-20--10 Phase-1b note.
- [x] **Clean-box n=16 record (user, 2026-06-20): `QUEENS_WAVE=1 solve 16 iso-dense` = 1m32s / 1,700,139,134
      nodes** (default ~17 GB TT, perf-pinned 24-core) — beats the W12 default (1m39s / 2.0 B); new top of the
      CLAUDE.md leaderboard. **PGO build** (`target/pgo-release/release/queens`, same flags) matched at **1m32s
      / 1,684,858,741 nodes** — node delta within ±18% noise, single pair (NOT an interleaved A/B), so PGO shows
      no measurable wall move here. M_WAVE stays gated-off / opt-in.
- [x] **Core-affinity A/B — user idea "expensive roots on the fast cores" (2026-06-20):** n=16 iso-dense,
      WAVE on, 12 GB TT, 2 interleaved rounds; **24-core perf-first vs `taskset -c 0-3,12-15` (8 fast only)**.
      Whole-search-on-8-fast = **−17% nodes / +69% wall** (the 16 Zen5c eff cores add ~20% re-expansion but
      pay for themselves in parallelism). **Giant-root runtime is a WASH** (8-fast mean 92.2s vs 24-mixed
      90.5s; 26% run-to-run noise — B8 81.6s/102.8s). Hypothesis (fast cores speed the expensive root)
      **not supported by the proxy** — the giant root is memory-latency/transposition-bound, not clock-bound.
      A clean two-pool test (giant-on-fast + cheap-on-all) needs a real build; the proxy shows no signal worth
      it. **Park the pinning lever; the data points back to attacking the WORK** (probe #1 → item A). See note.
- [x] **M_WAVE promoted to iso-dense default (`8400134`) + Approach B SCOPED (2026-06-20--11).** Probe #1 killed
      item A (modular reduction — see [node-kayles handoff](2026-06-20-node-kayles-lit-levers.md)); getK
      code-build vectorization measured-negative (reverted, see `proposal-2026-06-19-getk-throughput.md` §5).
      **NEXT lever = Approach B** (idle-core producer/consumer pipeline — move M_WAVE's +22% cyc/node gather/
      probe off the critical path; prize = closing the −4%→−16% wall gap). Full scope in
      [sorted-frontier-wave proposal](../proposal-2026-06-20-sorted-frontier-wave.md) "Approach B — DETAILED
      SCOPE": Phase 2a (size the offload, cold) → 2b (gated `QUEENS_WAVE_B` SPSC pipeline) → 2c (A/B + scale).
- [x] **Approach B Phase 2a (offload sizing) — BUILT (gated cold `M_SIZE`/`QUEENS_SIZE`) + measured GO
      (2026-06-20--12).** Production byte-identical (tap DCEs on every other MODE; gates green). n=16 WAVE-off
      probe stream: **3.0 B recurse-arm probes, pc 13–21 = 88%, dedup ceiling 38.1%, 73% same-DRAM-row after
      slot-sort** (vs ~0% random). All three gate conditions pass ⇒ **build 2b** (the SPSC producer/consumer
      pipeline). See the session --12 note + the [proposal](../proposal-2026-06-20-sorted-frontier-wave.md)
      Status/Phase-2 (DONE/GO).
- [x] **Phase 2b-0 de-risk (gated `M_WAVE_B`/`QUEENS_WAVE_B`) — slot-order tax = +94% nodes at n=16 ⇒ sorted
      wave CLOSED (2026-06-20--12).** The slot-order descent (the move-ordering-tax half of the sorted wave) =
      n=14 deterministic +13.3% but **n=16 interleaved A/B (3-round) = 4.069 B vs 2.097 B = +94% nodes** (the
      n=14 proxy lied 7×). Move ordering is worth ~2× node reduction at scale; no throughput gain survives +94%
      ⇒ **the in-DFS sorted wave AND the SPSC pipeline (option b) are dead.** Verdict SECOND, control byte-
      identical. **Only the order-independent DEDUP (option a) survives** — built + being measured as the L0
      probe cache (next item). `M_WAVE_B` gated-off.
- [x] **Phase 2b dedup — L0 probe cache (gated `M_L0`/`QUEENS_L0`) — MEASURED-NEGATIVE ⇒ Approach B CLOSED
      (2026-06-20--12).** n=16 A/B: **+6.0% cyc/node, −0.7% nodes (noise), +5.2% total cyc** — the TT already
      serves recent repeats warm, so the per-probe L0 access is pure overhead (warm-hit ~0); the tax-free
      eviction node-cut is ~0.7%. The 27% dedup only materializes inside a sorted/batched frontier (= the +94%
      tax). **Both halves of Approach B negative ⇒ the sorted-frontier-wave + dedup family is CLOSED**; the +94%
      finding also closes grouped-frontier DDD (any frontier reorder forfeits move ordering). Production byte-
      identical; `M_L0` gated-off (instructive negative). Surviving levers preserve move order (getK/W_K,
      decomposition, the cascade-reorder frontend micro-opt). See the 2b-dedup note.
- [x] **Cascade-reorder micro-opt (gated `M_WAVE_C`/`QUEENS_WAVE_C`) — MEASURED-NEGATIVE +2.1% cyc/node
      (2026-06-20--12).** Hoist the recurse arm to the front of the fused-descent pc-cascade (deep-tail recurse
      child skips ~8 cheap-arm `pc==k` tests). **Node-count byte-identical** (single-thread 11,747,330 = M_WAVE;
      verdicts n=8/10/12 correct) — a pure branch reorder. n=16 A/B: **+2.1% cyc/node** (LOSS). The ~8 branches
      were already predicted-not-taken (cheap), and the **duplicated recurse body bloated the hot loop** ⇒ worse
      I-cache in a frontend/L1i-bound loop. The per-node micro-opt route is exhausted (consistent with "micro-opts
      wash out"); the frontend bottleneck wants *less* hot-loop code (getK throughput), not branch reshuffling.
      `M_WAVE_C` gated-off (instructive negative).
- [x] **★ DYNAMIC MOVE ORDERING (gated `M_ORD`/`QUEENS_ORD`) — MEASURED BIG WIN: −30% wall at n=16
      (2026-06-20--12).** The constructive payoff of the +94% finding (move ordering worth ~2×): replace the
      **static** `q.order` (descending *empty-board* attack degree, fixed at build) with **dynamic** ordering —
      at each node re-sort available moves by *current* available-block degree (`child0.popcount()` ascending =
      most-forcing first; a `child0==0` instant-win sorts first ⇒ earliest cutoff). Verdict-preserving (matches
      the validated default n=4..10 + n=12/14/16 SECOND); production byte-identical off (the re-sort DCEs).
      **n=14 deterministic: 8,856,727 nodes vs 12,896,443 static (−31.3%), −24.6% vs the M_WAVE default.**
      **n=16 interleaved A/B (3-round, 12 GB TT) vs M_WAVE default: −34.3% nodes, +8.5% cyc/node (the cheap
      degree-sort), −28.7% total cycles, −30.2% WALL (98.1s→68.5s).** **Clean-box 17 GB single run: 1m02s /
      1,136,583,273 nodes** (vs the M_WAVE record 1m32s/1.70 B = **−33% wall**; new leaderboard #1, knocking on
      the ~45–60s compute floor). Biggest single lever since W12. The sort is far cheaper than the M_WAVE_B
      slot-sort (just `child0.popcount()`, no key-build). NEXT: combine with ETC (`M_ORD`+ETC) + promote-to-
      default decision — M_ORD alone already beats M_WAVE by −25% nodes.
- [x] **★ ETC ON TOP of dynamic ordering (gated `M_ORD_W`/`QUEENS_ORD=2`) — SUB-60: the combine pays
      (2026-06-20--12).** ETC still cuts on top of the better ordering. n=14 deterministic: 7,886,898 vs M_ORD
      8,856,727 = **−11% more nodes**. n=16 A/B M_ORD vs M_ORD_W (`QUEENS_ORD=1` fixed, toggle `QUEENS_ORD_ETC`):
      **−18.4% nodes, +14.6% cyc/node (the ETC gather/probe), −6.5% total cyc.** **Clean-box 17 GB: ~57s (59.2s
      measured) / 919 M nodes — SUB-60, new leaderboard #1, −38% vs the M_WAVE record.** Verdict-correct
      (n=4..10 match default). The ETC's +14.6% cyc/node is now the limiter (it eats −18% nodes down to −6.5%) —
      ChatGPT's refinement menu targets it. **Probed #4 (top-k ETC probe budget) — MEASURED-DEAD:** n=14 ETC-k
      sweep (M_ORD_W) shows the cuts are **distributed**, not top-concentrated (k=2 → 8.79M = +11.5% vs full
      7.89M; k=8 → +5.8%; k=16 → +1.9%) — you need k≈full to keep the cut. And the +14.6% overhead is the
      **gather** (key-build for all recurse children, reused by the descent) + a **triple `child0` recompute**
      (sort + gather + descent each compute `child0` per move), NOT the probes — so capping probes can't shed it
      (reverted, clean). Re-eval of the rest: #1 slow-root-only / #3 polarity (all nodes are OR here) / #7
      sidecar (overhead is gather not probes) all look weak; #5 warmup-sweep is cheap+orthogonal. **The real ETC
      overhead lever = kill the triple-`child0` redundancy** (compute `child0`/its popcount once in the sort,
      reuse in gather+descent). **NEXT (bigger): promote-to-default decision** — M_ORD_W (`QUEENS_ORD=2`) as the
      new iso-dense default (set `ord`+`ord_etc` default-on in `new_dense`, like `wave`/`warm_restart`); needs the
      gate to re-validate under the new default (lineage + verdicts; A/B already confirms the −38% win).

## Handoff Notes

### Session --14 (2026-06-21, `mi`, autonomous overnight): ★★ pext getK + W_K K=16 default = −35% (52→33.9s)

**Session** UUID `da03db1c-3787-4c88-8cf9-a0449477ad26`. Resumed `go mi`. The biggest single-session win of the
thread. Four commits, all gate-green (byte-identical K=12 default 7,885,007; direct_w9..16; lineage; iso-flat
n=12 distinct 1,060,823 / n=14 1.02× re-exp; clippy/fmt).

**The chain of reasoning (banked — this is the method that worked):**
1. Read the --13 profile target map: getK builders ~20.7% + evaluators ~8.7% = ~29%, the largest compute bucket;
   the proposal said the K≥10 scalar code-build "needs a fundamentally different attack (not identified)" and that
   pext was the −19% C4 negative.
2. **Re-read what was actually MEASURED:** proposal §5 only ran a *scalar rectangular reshape* (2× the bit-tests);
   the C4 pext verdict was reasoned from **k≤4 tiny data**. At K=12 (66-bit code) the Fermi flips: ~12 pext-rows
   (≈120 ops) vs 66 scalar `Bits::get` (≈330 ops), and znver5 pext is 3-cyc/1-per-cyc. **Never actually tried.**
3. Built `adj_row_pext` (one 4-word `pext` compacts an attack row against `avail` into the K-bit labelled
   adjacency row), rewrote w10-w13 to pack it into the code. Byte-identical. **n=16 4-round A/B: −3.8% cyc/node.**
   (`adbfb10`.)
4. **Key insight — the levers COMPOUND:** the K=13 cyc/node penalty (the expensive scalar w13_get) shrank +10%→
   +6.6% on the pext build. So raising K, which had been "net-negative past 12," might now pay. Implemented W14
   (`41dcf70`), then W15/W16 (`2dd5ef2`, the u128 ceiling at 120 bits; incremental `wk_masks128` to clear the
   const-eval deny-lint; fixed a `1u16<<16` overflow in the *test reference* `wins_rec`, get16 was correct).
5. **Swept K=12..16 at n=16.** Node cut HOLDS per layer (n=14 det −50% at K=16, K=15→16 was −22%, not diminishing)
   and — critically — is **inherent / TT-independent**: the 16 GB node counts == the 12 GB ones (the W_K layer
   avoids subtree *expansion*, not just eviction). So 12 GB doesn't overstate. 12 GB 3-round A/B: K=14 −19.6%,
   K=15 −22.0%, K=16 −26.4% wall. 16 GB single-run: 49.5→34.4s. **Defaulted K=16** (`16d8842`); clean 17 GB
   **33.9s / 396 M / SECOND** (−35% vs the prior K=12 default; TT 16.5% full — the working set collapsed).

**cyc/node grows +66% at K=16** (the getK evaluator sweep — the get9/get10 *leaves* of the nested recursion, the
sparse pc 14-16 tail peels isolated vertices one ply at a time) but the −57% node cut dominates. **That evaluator
cost is the next per-node lever; the bigger node-cut lever is extending W_K past 16 (256-bit codes).** See the top
"⇒ NEXT SESSION (--14)" block.

**Method re-banked:** (a) *re-read what was measured vs reasoned* — the getK-throughput proposal "closed" pext
from k≤4 data + a scalar reshape; the actual pext at K=12 scale was a clean win and unlocked the whole K-raising
cascade. A "measured-negative" can be a mis-scoped measurement. (b) *Levers compound* — pext alone was −3.8%, but
it flipped K-raising from net-negative to −35%. (c) The node-cut TT-independence (16 GB == 12 GB nodes) let the
12 GB A/B harness decide a production default safely (no risky 17 GB interleaving). (d) Degree-sort restructure
(closure-free popcount + fused degree) = **WASH** (−0.1% cyc/node) — the compute is inherent arithmetic, the
profile's `call_mut`/sort attribution was inherent work; reverted to keep the baseline pure.

### Session --13 (2026-06-20, `mi`, autonomous overnight): the 50→40→30s grind — M_ORD_W default + a cyc/node stack

**Session** UUID `1bc5298d-9422-4881-8735-23487241f43e`. User mission (relentless, escalating 50→40→30s; optimize
every level incl. asm; branch/variant freely; *wake up to progress not excuses*). Resumed `go mi`. Three commits,
all gate-green (n=14 byte-identical 7,886,898; n=12 SECOND; clippy/fmt/test).

**Landed:** `fde7baf` M_ORD_W→iso-dense DEFAULT (the prior-session −38% SUB-60 win is now production; leaderboard
+ CLAUDE.md updated). `4ff7bd9` **inlined stable insertion sort** — the headline find: perf-record + aggregate
`perf report --sort=symbol` showed the dynamic-order sort family (`sort_moves_by_degree` + std driftsort
`insertion_sort_shift_left`/`quicksort`/`sort8_stable`/`drift`/`memmove` + the FnMut comparator `call_mut`) was
**~30% of total search cycles**; replacing std `sort_by` with an inlined closure-free stable insertion sort
(small move lists at the deep tail) = **−10.9% wall / −8.5% cyc/node**, byte-identical order. `8f00881` four more:
inline-each (−1.4%), sort-fuse + prefetch-reorder (−3.1% together), startup-overlap (WASH — memory-bw-bound).

**Measured (clean 17 GB, current main):** n=16 search **~52s clean / ~49s best round** (was 57.58s), 0.94 B nodes,
SECOND. **Cumulative cyc/node −12.5%** vs the M_ORD_W baseline. (cyc/node is the trustworthy metric — wall is
±parallel-node-noisy; n=14 single-thread is build-polluted, gate-only.) **K=13 found to FLIP to net-positive
under M_ORD_W** (12 GB A/B −14.8% nodes/−2.9% wall; was +4% under M_WAVE) — TT-size-sensitive, A/B at 17 GB before
defaulting.

**Tooling added (committed):** `scripts/ab2.sh` (two-BINARY interleaved A/B, for code-vs-code), `scripts/abenv.sh`
(env-VALUE A/B, e.g. `QUEENS_DENSE_K 12 13`). Both: 12 GB TT, cyc/node from `perf stat -o`, --to-file JSON.

**NEXT:** see the rewritten **⇒ NEXT SESSION (--13)** block at the top — K=13 default decision, K=14/15, **MLP on
the explicit-stack frontier** (the 15.6% TT-probe stall = the big 30s lever), getK asm-tweaks, the **ChatGPT
ETC-economics diagnostics** (first-losing-child rank before/after ordering — decides whether to trim the ETC
gather), warmup re-sweep, the M_ORD plain-descent sort-fuse. **BE RELENTLESS.**

### Session --12 (2026-06-20, `mi`): Approach B Phase 2a — offload sizing built + measured GO

**Session** UUID `a3343459-98b6-4c8c-8e57-0c6dc4be46b8` (harness env num `2026-06-20--4`; `--12` in this thread's
counter). Resumed from `go mi`. Built **Phase 2a** of the [sorted-frontier-wave proposal](../proposal-2026-06-20-sorted-frontier-wave.md)
— the cold sizing of the Approach-B idle-core offload — and measured it **GO**.

**Design reframe (banked):** the proposal's 2a spec was per-θ prove-loss-subtree (frontier widths + dedup by θ).
The flat `count --comps` working set can't carry subtree structure, and a per-subtree on-stack collector that
also tracks `was_loss` needs the hot `wins_inc` return-control restructured (byte-identity risk). **Reframed to a
global probe-stream tap** — decisive for the gate's two failure modes (frontier-too-narrow / dedup-too-low),
cheaper, and SAFE (one tap line in an `if MODE == M_SIZE` branch that DCEs ⇒ production byte-identical, no
control-flow change). The per-θ breakdown (to pick θ in 2b) is informed by Phase-0a (≈4-consumer regime) + the
work-stealing split-diag (pc-band subtree sizes) — folded into 2b.

**Built (`M_SIZE` = mode 5, `QUEENS_SIZE=1`; wins over the `wave` default in the mode chain so it measures the
WAVE-off stream):** at every `wins_inc` entry (= one flat-TT recurse-arm probe) tap `(node_pc, key, route)` into a
per-worker `SizeAcc` — per-pc width counter, `key`→HLL (global distinct, the dedup ceiling), and a capped route
sample. Cold drain (`drain_size_all`, rayon-broadcast, mirrors `drain_prof`) + a post-solve report
(`print_size_report`): per-pc frontier-width table, total/distinct/dedup, and slot-sorted-locality (sort the
sample by TT slot, count consecutive same-cache-line / same-DRAM-row). All in `iso_flat.rs`.

**Gates (green):** `make test` (34/34 lib incl. `solver_lineage_agrees`); iso-flat n=12 `--distinct` =
1,060,823 / 1.25×; iso-dense n=14 single-thread = **11,747,330** byte-identical with/without the code (control
unaffected — `M_SIZE` only instantiates under `QUEENS_SIZE`); `QUEENS_SIZE=1` verdict SECOND at n=14 and n=16;
`make clippy` (-D warnings) + fmt clean.

**MEASURED — GATE PASS (GO):**

| metric (recurse-arm probe stream, WAVE-off = upper bound on offloadable work) | n=14 (1-thread, 1.07 GB TT) | n=16 (24-thread, 12 GB TT @ 70.9% fill) |
|---|---|---|
| total recurse-arm probes | 12.83 M | **2,997 M** |
| pc 13–21 share | 88.5% | **88.4%** (cross-validates the 87% PROF figure) |
| distinct (HLL p=16) | 8.77 M | 1,854 M |
| **dedup ceiling** (1 − distinct/probes) | 31.7% | **38.1%** |
| after slot-sort: same-DRAM-row (<512) | 100% | **73.0%** (sample floor) |
| after slot-sort: same-cache-line (<8) | 38.2% | 28.5% (sample floor) |

The three gate conditions all pass: **(F1) frontier wide** (3.0 B probes, pc 13–21 = 88%, per-band in the
hundreds of M); **(F2) dedup material** (38.1% of probes hit an already-probed key — removable by sort+dedup,
and *rises* n=14→n=16 with transposition saturation); **(locality) manufactured** (a slot-sort turns the random
scatter into 73% same-DRAM-row hits — the `mlp_bench` 3–5.7× row-buffer regime, on the *real* probe stream).
The same-line/same-row figures are a **floor**: the 4 M sample spreads slots 375 apart (n=16); a real producer
sorts a much larger frontier chunk → packs denser → trends to fully sequential. **⇒ a θ exists where off-core
sort+dedup pays ⇒ GO to Phase 2b.**

**WAVE-on residual (the post-ETC-cut stream B actually offloads) — measured, still GO.** Added `M_SIZE_WAVE`
(mode 6, `QUEENS_SIZE=2`): the same tap, but it runs the M_WAVE ETC body so the tapped stream is the post-cut
residual on top of the default (vs `=1`/`M_SIZE` = the pre-cut upper bound). Production still byte-identical
(the M_WAVE guard `MODE == M_WAVE || MODE == M_SIZE_WAVE` folds to the unchanged `== M_WAVE` for production;
control n=14 = 11,747,330). (The ETC batch probes are NOT tapped — conservative: those are *added* volume.)

| residual stream (post-ETC-cut) | n=14 (1-thread, 1.07 GB TT) | n=16 (24-thread, 17 GB TT @ 54.8% fill) |
|---|---|---|
| total probes (vs the WAVE-off run) | 10.11 M (−21%) | **2,342 M** (−22% vs 2,997 M) |
| pc 13–21 share | — | 87.5% |
| **dedup ceiling** | 23.2% | **27.1%** |
| same-DRAM-row after sort | 100% | **62.4%** (floor) |
| same-cache-line after sort | 33.6% | 18.8% (floor) |

The ETC cut shrinks the offloadable stream **−22%** and trims the dedup ceiling, but the residual is **still wide
(2.34 B probes) + 27% dedup-able + sorts to 62% row-buffer hits** ⇒ B's prize survives on top of the default.
**Caveat (load-confounded):** the WAVE-off run was 12 GB/70.9% fill, the WAVE-on 17 GB/54.8% — the sparser TT
*alone* lowers dedup + locality, so the raw 38%→27% / 73%→62% deltas overstate the pure cut effect. The **clean**
wave effect is the n=14 same-TT pair: dedup **31.7%→23.2% (−8.5 pts)**, locality ≈ unchanged. (To load-match at
n=16, re-run WAVE-off at 17 GB — deferred; the GO is clear from the residual magnitude.)

**NEXT = Phase 2b** — but the Fermi on the mechanic surfaced the **load-bearing design point** (now resolved +
documented in the [proposal](../proposal-2026-06-20-sorted-frontier-wave.md) "Phase 2b — the order-vs-cutoff
tension"): the sorted-stream 5.7× **requires the consumer to access probes in slot order**, which conflicts with
α-β's DFS move-order. The two 2a sub-prizes split along this axis — **dedup (27%) is order-independent** (safe,
realizable in any order) but **sorted-locality (62%) entangles with cutoffs**: slot-order at an OR node loses
**move ordering** (not cutoffs — it still cuts on the first found loss ⇒ *bounded* re-expansion, NOT the
cutoff-free 6.6× wall the parked component-nimber DDD hit). **⇒ de-risk-first build order: 2b-0 = a
single-thread sorted-frontier wave that measures the move-ordering node-count cost** (the benefit half — 62%
locality / mlp_bench 5.7× — is already measured) **BEFORE any SPSC threading.** Kill 2b-0 if move-ordering
re-expansion > locality+dedup gain (retreat to a dedup-only variant); if net-positive, 2b-1's producer/consumer
SPSC is mechanical. This is the "characterize before you build the scheduler" lesson applied up front — do NOT
sink the pipeline before 2b-0. Multi-session; **decide with the user** (the architecture locks in future work).
Tooling banked: `QUEENS_SIZE=1` (pre-cut) / `QUEENS_SIZE=2` (post-cut residual), both gated/off in prod.

**2b-0 BUILT + measured (gated `M_WAVE_B`/`QUEENS_WAVE_B`):** a slot-order descent — reorder each node's
children into TT-slot order before the standard descent (empty/cheap children keep move order first via a stable
sort; recurse children follow by slot). Verdict-preserving; production byte-identical (the sort DCEs; control
n=14 = 11,747,330). This isolates the **move-ordering tax** of slot access (the benefit half — 62% row-hits /
mlp_bench 5.7× — is already measured; a DFS reorder doesn't realize it, only its cost).

| slot-order tax | nodes (vs move-order) | Δ |
|---|---|---|
| **n=14 single-thread, deterministic** | 14,612,123 vs 12,896,443 | **+13.3%** |
| **n=16 interleaved A/B (3-round, 12 GB TT)** | 4.069 B vs 2.097 B | **+94%** (rounds +86/+93/+103%) |

**Finding — the sorted-LOCALITY half is CLOSED (the n=14 proxy lied 7×).** The n=14 deterministic +13.3% looked
survivable; the trustworthy **n=16 interleaved A/B is +94% nodes** — slot-order ≈ random w.r.t. the move-ordering
heuristic, and move ordering is worth ~2× node reduction at scale (far more than the napkin assumed; work-stealing
died at a mere +8.7%). **No sorted-stream throughput gain survives +94% nodes** ⇒ **the in-DFS sorted wave is dead,
and so is the producer/consumer SPSC pipeline that depends on sorted consumer access (option b).** Banked method,
re-vindicated: **n=14 / single runs lie — only the interleaved n=16 A/B is trustworthy** (here it flipped a "−6%
marginal" verdict into a hard kill). `M_WAVE_B` stays gated-off (substrate + the measured tax).

**The DEDUP half (option a, the L0 probe cache `M_L0`/`QUEENS_L0`) — also MEASURED-NEGATIVE.** n=16 interleaved
A/B (3-round, 12 GB TT), `QUEENS_L0` toggle (off=M_WAVE / on=M_L0):

| | M_WAVE (off) | M_L0 (on) | Δ |
|---|---|---|---|
| cyc/node | 3336 | 3535 | **+6.0%** |
| nodes | 1.721 B | 1.708 B | −0.7% (noise) |
| total cyc | 5740 G | 6039 G | **+5.2% (loss)** |

cyc/node went **up**: the per-probe L0 access (TLS `.with` + `RefCell` borrow + the 1 MB-cache write on every
put) is paid on all ~1.7 B nodes, but the warm-hit benefit is ~0 — **the flat TT already serves recent repeats
warm from CPU cache**, so the L0 adds pure overhead and almost never beats the TT. The eviction-resistance
node-cut is negligible (−0.7%, the only tax-free prize). **⇒ the tax-free dedup prize is ~0%, not 27% — the 27%
only materializes inside a sorted/batched frontier, which costs the +94% move-ordering tax.** So **BOTH halves of
Approach B are measured-negative ⇒ Approach B (sorted-frontier wave + dedup) is CLOSED.** `M_L0` stays gated-off
(instructive negative, like ABDADA/STEAL/M_WAVE_B). (A faster raw-pointer L0 would trim the +6% but can't beat
the M_WAVE default — the node-cut prize is ~0.7%, below any realistic per-probe overhead.)

**Broader implication (banked):** the +94% move-ordering finding **also closes the grouped-frontier DDD family**
— any lever that materializes/sorts/dedups the giant-root frontier (DDD, retrograde wave, sorted wave) forfeits
move ordering ≈ +94% nodes (or, cutoff-free via nimbers, the parked DDD's 6.6× wall). **The giant-root tail's
WORK is not cuttable by frontier-reordering/dedup.** The surviving levers all **preserve move order**: node-count
cuts (getK/W_K deeper, better move *ordering*, decomposition that keeps α-β) or per-node frontend cost
(e.g. the **cascade-reorder** micro-opt — hoist the recurse arm to the front of the pc-cascade, byte-identical
node count, ~8→1 branches on the 88%-majority deep-tail child; not part of the dead dedup family).

**Method note:** the global-tap reframe is the "fail-cheap" move — it answered the gate at low build cost / zero
solver risk (like probe #1), without the heavier per-subtree-HLL instrumentation. If 2a had failed (narrow /
low-dedup), that would have closed the sorted-stream family cheaply. And 2b-0 (the +94% n=16 tax) is the same
move applied to the pipeline: a one-flag gated reorder + an interleaved n=16 A/B killed the sorted wave **before**
the heavy SPSC build — exactly the "characterize before you build the scheduler" lesson. (Sharpened: the n=14
proxy said +13.3% "marginal"; only the n=16 interleaved A/B revealed the +94% kill — never trust the small-n /
single-run number for a node-count lever.)

### Session --11 (2026-06-20, `mi`): M_WAVE→default, probe #1 kills item A, getK-reshape negative, Approach B scoped

**Session** UUID `0d7ac74a-e00a-4578-a28c-85816b2f287a` (harness env num `2026-06-20--3`; `--11` in this thread's
continuous counter, prior was `--10`). Resumed from `go triage`; `mi` mid-session. Five commits, all gated/validated.

**Landed:**
- `12c5762` **probe #1 module-prevalence → item A (modular reduction) MEASURED-DEAD.** `module_profile`
  (`graph.rs`) + `module_report` (`count --comps`): pc 13–20 `reduces%`/`->≤12%` = **0%** (n=12 + n=14 49.8M-set);
  tail too sparse for size-≥3 modules. Cross-validated `struct_profile` twin% to the decimal; **bug found+fixed**
  (`attack` includes self ⇒ first cut dropped independent modules; re-ran, verdict unchanged). Detail:
  [node-kayles handoff](2026-06-20-node-kayles-lit-levers.md).
- `2d7f6b2` **getK code-build vectorization reshape → MEASURED-NEGATIVE, reverted.** Uniform K×K gather + triangular
  pack (result-identical; n=14 nodes 12,896,443 byte-identical) → +0.53% instr / +0.39% cyc deterministic (the
  compiler won't gather 10/11 lanes; uniform rewrite = 2× work, no vectorization). `proposal-2026-06-19-getk-throughput.md` §5.
- `8400134` **M_WAVE promoted to iso-dense DEFAULT** (the 1m32s record). `new_dense` sets `wave` default-on
  (mirrors `warm_restart`); `QUEENS_WAVE=0` disables; iso-flat/iso-window stay off (control + `--distinct` gate
  intact). Verified: iso-dense n=14 = 11,747,330 / SECOND; disable→12,896,443; iso-window 27,539,495; iso-flat
  n=12 `--distinct` 1,060,823 / 1.25×; clippy+test green.
- `ecb1328` **Approach B SCOPED** ([sorted-frontier-wave proposal](../proposal-2026-06-20-sorted-frontier-wave.md)).
- (the probe-#1 commit also banked the **WAVE clean-box record** 1m32s/1.70B + PGO, and the **core-affinity A/B**.)

**NEXT SESSION = Approach B Phase 2a** — cold sizing of the prove-loss offload (how many prove-loss subtrees of
avail-pc ≥ θ in the giant-root tail, their pc-band frontier widths, the dedup fraction after sort; **gate:** a θ
exists where sort+SPSC < the sorted-stream saving — fail cheap if not, like the work-stealing split-diagnostic).
Then 2b (gated `QUEENS_WAVE_B` SPSC producer/consumer pipeline) → 2c (A/B + scale). Substrate = the M_WAVE gather
(lifted off-core) + `wins_inc_iter`. Full scope + kill criteria in the proposal's "Approach B — DETAILED SCOPE".

**Method re-banked:** single n=16 runs lie (B8's 81.6s outlier "confirmed" the pinning hypothesis solo; round 2
killed it). Cheap probe-first kills expensive builds (item A + getK-reshape closed for ~0 build cost this session).

### Core-affinity A/B — fast-cores-for-expensive-roots is a wash on the proxy (2026-06-20--11)

**Session**: 2026-06-20 (`mi`). User reported the WAVE clean-box record (1m32s / 1.70 B; PGO 1.685 B same wall)
and asked: pin 2 rayon workers to the fastest cores + run the expensive root(s) only there; prioritise the next
longest roots onto the next fast cores. `affinity.rs` already pins the search pool 1:1 **perf-first** (worker
0→fastest), and per-task core confinement is **not a rayon primitive** (global work-stealing; would need a
pool partition / dedicated pinned thread). The cheap proxy that needs no code — `affinity.rs` honours an
inherited `taskset` mask — was an A/B of **24-core (default) vs 8-fast-only** at n=16.

| run | config | total wall | nodes | giant-root own runtime |
|-----|--------|-----------|-------|------------------------|
| A24 r1 | 24 mixed (perf-first) | 98.8s | 1,785,901,317 | 93.2s (idx 2 / sq 103) |
| B8 r1  | 8 fast (`taskset 0-3,12-15`) | 166.4s | 1,492,484,367 | **81.6s** (idx 29 / sq 1) |
| A24 r2 | 24 mixed | 94.8s | 1,760,903,105 | 87.8s (idx 29 / sq 1) |
| B8 r2  | 8 fast | 164.1s | 1,462,294,058 | **102.8s** (idx 29 / sq 1) |

**Findings:**
1. **Whole-search-on-8-fast: −17% nodes, +69% wall.** Fewer workers ⇒ ~20% less transposition re-expansion
   (1.46–1.49 B vs 1.76–1.79 B nodes) — a fresh quantification of the closed-parallelization tax — but the
   lost parallelism dominates wall. The 16 eff cores earn their keep.
2. **Giant-root runtime is a WASH.** 8-fast mean **92.2s** vs 24-mixed **90.5s**, inside the 26% run-to-run
   spread (B8 r1 81.6s was a low-noise outlier; r2's 102.8s cancels it). B8 also runs the giant in a *colder*
   TT (slower early phase ⇒ less warm) — a handicap — and still only ties. **No clear clock/slow-core penalty
   on the giant root** ⇒ it's memory-latency + transposition-bound (consistent with the post-W12 tail study),
   not clock-bound. The fast-core-for-the-root premise isn't supported.
3. **Which root is "giant" is not fixed** — r1's straggler was idx 2 (sq 103), the others idx 29 (sq 1). So a
   hardcoded "pin root 29" wouldn't reliably target the actual straggler; you'd need warm-restart's slow-root
   signal to pick it at runtime.

**Verdict: park the pinning lever.** The clean two-pool design (expensive roots on the 8 perf cores, cheap
roots on all 24) is the only faithful build of the idea, but the proxy shows the giant root isn't clock-bound,
so the expected payoff is ~0 and not worth the architectural build over probe #1 / item A. **Method re-banked:
single n=16 runs lie** — B8 r1's 81.6s would have "confirmed" the hypothesis solo; the 2nd round killed it.
Method note: the proxy can't separate per-root pinning from whole-search confinement (rayon limitation) — a
true negative needs the two-pool build, so this is "no-signal-on-proxy," not a hard refutation.

### A'' Phase-1b — FUSED M_WAVE flips the cut to a total-cycle WIN (Opus micro-opt) (2026-06-20--10)

**Session**: 2026-06-20 (`mi`). User: "opus sub-agent to profile + micro-optimize the hell out of it." An Opus
sub-agent profiled and rebuilt the M_WAVE body; the parent independently re-validated every gate + reviewed the
working-tree diff. (Mid-run **collision**: the parent launched its own confirming n=16 A/B + a broad
`pkill -f "queens solve"` while the agent's bench was live — killed the agent's solve. Both stopped, agent
re-ran clean, box recovered. **Lesson re-banked: one driver on the `queens` box at a time; never
`pkill -f "queens solve"` while a sub-agent may be benching.**)

**Profile (the +27% cyc/node diagnosed):** the unfused M_WAVE ran a *separate* ETC pre-pass and then **fell
through to the unchanged descent**, so every no-cut node processed each recurse child **twice** — child0
recompute + full key rebuild (`child_orient`→`lex_min8`→`d4_bits`→`hash128`) AND a double cold TT probe. `perf
stat` n=14 signature: cycles ~flat but **L1-dcache-load-misses +69%** (211M→357M) — the duplicate key-build
memory traffic taxing all ~1.73 B nodes to save the 366 M cut. (`perf record` was one inlined blob; diagnosed
from code structure + the cache-miss delta.)

**Fix (`src/queens/solver/iso_flat.rs`, M_WAVE body only; control DCEs to byte-identical):** "proper Approach A"
— a **fused** ETC+descent. One gather builds each recurse child's descriptor (`ckey`/`cr`/`cf`) into a
`WAVE_CAP`-bounded stack SoA (no alloc); the ETC probes that batch (cut on proven-loss/empty); on no cut the
**descent reuses the stored descriptors** (only the cheap `child_orient` recomputed; the recursion's own warm
entry-probe kept for freshness ⇒ no extra re-expansion). **Sort dropped** (doesn't pay at the ~3–12-child tail
batch widths; the fused ETC is now the only batch probe). Isolated n=14: fuse +4.9%→+0.8% total cyc; drop-sort
→ break-even.

**MEASURED — total-cycle WIN at n=16** (iso-dense, 12 GB TT; **total cycles** is the right metric for a
node-count lever — cyc/node rises +22% *by design* and is misleading):

| A/B (3-round mean) | nodes off→on | total cycles off→on | wall off→on |
|--------------------|--------------|---------------------|-------------|
| #1 | 2086.3M → 1745.5M (−16.3%) | 6093.3G → **5833.8G (−4.3%)** | 106.8s → 105.0s (−1.7%) |
| #2 | 2046.7M → 1718.8M (−16.0%) | 5994.2G → **5762.0G (−3.9%)** | 106.3s → 102.4s (−3.7%) |
| **6-round** | **−16.1%** | **≈ −4.1%** (ON wins 5/6, 1 tie) | **≈ −2.7%** |

vs unfused Phase-1a +4.9% cyc / +9.2% wall — a ~9-pt cycle swing. **TT-size sweep** (WAVE on, single runs):
verdict SECOND + graceful (no cliff) from 12 GB (67% fill) to **2 GB (99.9% fill)** — the cut is robust under
heavy eviction.

**Gates (parent-re-verified on the final tree):** `make test` (control) pass; `QUEENS_WAVE=1` lineage n≤9 ==
naive pass; verdicts n=8 first / 10,12,14,16 second; n=14 cut 12.96M→11.76M (−9.2%); clippy `-D warnings` + fmt
clean; control byte-identical (whole body behind `if MODE == M_WAVE`). Code-review notes: gather/descent
`wi`-lockstep is sound (same `pc > recurse_min` predicate, rebuild past `WAVE_CAP`); every early return is a
proven win (gate-safe); `wk` is a dead store on the production `!COUNT` path (harmless nit).

**Status (UPDATED 2026-06-20--11): M_WAVE is now the iso-dense DEFAULT.** Promoted in `new_dense` (mirrors
`warm_restart`: `s.wave = !matches!(env "QUEENS_WAVE", Ok("0"))` — default-on, `QUEENS_WAVE=0` disables);
iso-flat/iso-window keep it **off** so the byte-identical A/B control + the `--distinct` gate are intact.
Verified: iso-dense n=14 = 11,747,330 (−8.9% vs WAVE-off 12,896,443), verdict SECOND; `QUEENS_WAVE=0` restores
12,896,443; iso-window unchanged (27,539,495); iso-flat n=12 `--distinct` = 1,060,823 / 1.25×; clippy/test green.
The 1m32s record is now the production default. (Previously: measured net win, defaults-on candidate.) Residual slack = the warm entry re-probe of ETC-miss children (~60 cyc); removing it
needs an entry-probe/body split of `wins_inc` (risks byte-identity + doubles hot L1i — agent judged not worth
it). **NEXT:** decide promote-to-default vs keep-opt-in; the fused per-node ETC is now a clean substrate for
**Approach B** (idle-core prep moves the gather/probe off the critical path — where the remaining ~16% cut
should beat the −4% the critical-path version captures). **Also queued for triage:**
[Node-Kayles lit-search lever backlog](../handoffs/2026-06-20-node-kayles-lit-levers.md) — modular/twin
reduction (top bet, attacks the same pc 13–18 region), TDS scheduling, K-set DP, setrograde/generalized-TT,
per-root PN subsolver; gate on the cheap module-prevalence probe.

### A'' Phase-1 (Approach A / ETC) — real −17.4% node cut, but critical-path overhead = wall LOSS ⇒ go to B (2026-06-20--10)

**Session**: 2026-06-20 (`mi`, resumed from `go`). User: (a)/(b) fork → "yc". Built Phase-1 = the proposal's
**Approach A** in its minimum-viable form: an **ETC (enhanced transposition cutoff) + sorted-batch** pre-pass,
gated `QUEENS_WAVE=1` → `const MODE = M_WAVE` in `wins_inc` (resolved once per subtree handoff; off = byte-
identical `M_NORMAL`). Every node here is an OR node (a *losing* child = a winning move ⇒ node wins); the
pre-pass gathers the node's recurse-arm children (`pc > DK.max(block_k).max(iso_max_avail)` — the ones the
`else` arm would flat-TT-probe and expand), **sorts them by target slot** (monotone in the route hash), issues
**all prefetches up front then probes the batch** (full MLP overlap = the per-node sorted wave), and on a
TT-proven-loss / empty child **cuts** (puts win, returns) — skipping every miss-sibling expansion the move-
ordered descent would have done first. Read-only + verdict-preserving (the cut is only ever an *earlier* return
of the same verdict); changes only which children expand ⇒ gate-safe on iso-dense (no `--distinct`). `WAVE_CAP=32`
bounds the per-node batch (deep-tail fan-out is a handful; stack-safe in the recursive `wins_inc`). Segmentation
is default-off, so the A/B is apples-to-apples on the flat path.

**Correctness (gates green):** `make test` (control); lineage n≤9 == `naive` under `QUEENS_WAVE=1` (exercises
`iso-dense`/`iso-window`, both WINDOW=true → M_WAVE); n=8 first / n=10,12 second under wave; clippy `-D warnings`
+ fmt clean. (M_WAVE *changes* node count by design, so it is **not** gated on the exact `--distinct` — verdict
is the invariant.)

**MEASURED — the ETC cut is real and large, but Approach A is a WALL LOSS on the critical path:**

| metric (n=16, iso-dense, 12 GB TT) | control (off) | M_WAVE (on) | Δ |
|------------------------------------|---------------|-------------|-----|
| nodes (3-round mean)               | 2,099.9 M     | 1,733.6 M   | **−17.4%** (rounds −19.9/−13.0/−19.3) |
| total cycles (perf)                | 6,176.5 G     | 6,480.5 G   | **+4.9%** (rounds +0.9/+10.3/+3.8) |
| wall                               | 120.1 s       | 131.1 s     | **+9.2%** (rounds +8.5/+14.7/+4.6) |
| cyc/node                           | 2,941         | 3,738       | **+27.1%** |

(n=14 warm proxy: −9.5% nodes / +13% wall — same shape, smaller cut, confirming the cut isn't purely eviction-
driven.) The −17.4% node cut is **robust and bigger at n=16 than n=14** (more transpositions/eviction ⇒ more
TT-loss children to cut ahead of). But the pre-pass adds **+27% cyc/node** — the gather loop recomputes `child0`
for every move + rebuilds keys (`child_orient`/`lex_min8`/`hash128`) for every recurse child, and on a no-cut
node those children are then **re-probed (cold) by the normal recursion** = a double cold probe. The cut saves
366 M nodes; the overhead taxes all 1.73 B ⇒ net +4.9% cycles / +9.2% wall.

**VERDICT — Approach A (per-node ETC, prep on the critical path) is a measured wall LOSS, BUT it proves the
removable-work thesis: −17.4% of n=16 nodes are ETC-cuttable** (TT-proven-loss children reachable before
expanding the miss-siblings). The cut value is real; the **critical-path overhead is what kills A** — exactly
the proposal's prediction ("A's weakness: sort + gather on the critical path eats the win"). **⇒ the cut must be
realized OFF the critical path = Approach B** (idle-core producer/consumer: idle tail cores gather/sort/dedup/
build-keys, the hot consumer streams the sorted batch + cuts — the +27% cyc/node prep moves to the spare cores
Phase-0a showed have bandwidth). This is the GO signal for B: the dedup/cut is proven worth ~17% of nodes.
(A "proper A" — custom gather-once child loop that stores child descriptors so the expansion reuses them, killing
the double-work — would shrink the overhead, but that build is ≈ the B substrate anyway; go straight to B.)

**Status of M_WAVE:** keep gated-off on main (control byte-identical, validated) as the **ETC substrate +
documented measurement** (the −17.4%-cuttable finding), same disposition as gated ABDADA/STEAL. Do NOT default
it on (measured loss). Do NOT revert.

**NEXT = Approach B scope decision with the user** (multi-session): idle-core gather/sort/dedup producers feeding
a streaming consumer that probes the sorted batch + cuts. Phase-0a sized the consumer (~4 cores → ~780 M/s,
out-probes the tail); Phase-1 proved the cut (~17% nodes). The remaining design = the producer/consumer SPSC +
frontier ownership + boundary-publish race (proposal Approach B / open questions).

### A'' Phase-0a — sorted-stream survives contention (GREEN); ~780 M/s cap; few-consumer design (2026-06-20--10)

**Session**: 2026-06-20 (`mi`, resumed from `go`). Built the threaded half of the
[sorted-frontier-wave proposal](../proposal-2026-06-20-sorted-frontier-wave.md)'s Phase 0:
`tt.rs::mlp_bench::mlp_probe_threads_sweep` (`#[cfg(test)]`/`#[ignore]`, not a gate). Strong-scaling test —
a fixed 20M-probe set is partitioned across `nt` threads, each owning an independently-sorted slice (matching
A'' where each producer sorts its own frontier piece), all streaming the shared 8 GiB huge-page TT; aggregate
`M/s = total probes ÷ wall`. Run: `MLP_THREADS`/`MLP_DEPTHS`/`MLP_BITS`/`MLP_N` env. (Baseline this session:
iso-dense defaults = 1,926,031,300 nodes / 1m33s.)

| threads | random d1 | random d32 | sorted d16 | sorted d32 | sorted/random (d32) |
|---------|-----------|------------|------------|------------|---------------------|
| 1       | 48.6      | 80.0       | 191.2      | 274.7      | 3.43× |
| 2       | 89.0      | 155.5      | 330.2      | 442.6      | 2.85× |
| 4       | 152.8     | 225.4      | 573.2      | **763.8**  | 3.39× |
| 8       | 266.1     | 397.9      | **786.2**  | 756.4      | 1.90× |

**VERDICT — GREEN, with a measured ceiling + a design constraint:**
1. **The sorted win survives contention.** Sorted aggregate scales cleanly 1→4 cores (275→764 M/s); the
   headline "over today's regime" multiplier (sorted-deep vs random-d1) holds **5.65× @1, ~5.0× @2–4**. The
   single-thread 5.7× was not a single-core artifact.
2. **Memory saturates at ~780 M/s with ~4–8 streaming cores** (sorted d32 plateaus 764→756 over 4→8; sorted
   d16 reaches 786 @8). New measured **hard cap on probe throughput, any scheme.**
3. **Leverage is highest with FEW consumer cores** — 5× @4, eroding to ~2.8× @8. Not sorted degrading: sorted
   is bandwidth-capped while random keeps adding latency-chains with cores. ⇒ **don't oversubscribe consumers.**

**Why it green-lights Approach B specifically:** ~4 sorted-consumer cores hit ~764 M/s, which **exceeds** what
the current ~14-core random tail produces (8-core random d16 = 381 → ~14-core ≈ 550–600 extrapolated). So a
handful of sorted-consumer cores out-probe the whole tail, freeing the rest for non-redundant prep (the thing
work-stealing couldn't do because it re-searched). **Prize bound:** pc 13–21 ≈ 2.75 B probes ÷ 780 M/s ≈ 3.5 s
if fully streamable → ~10–15% of the 93 s wall at realistic realization (matches the napkin).

**NEXT = A'' Phase-0b: size the giant root's pc-band frontier width** (extend `count`/`comps_report` —
distinct keys per pc-band slice) to confirm a window exists where sort-cost < sorted-stream saving, then
Phase-1 Approach A (`QUEENS_SORTED_WAVE`, in-DFS sorted-wave probe on `wins_inc_iter`, gated/byte-identical).

### Tail re-anchored post-W12: ONE giant root = 94% of wall; cost = memory 30% + frontend 31% (2026-06-20--9)

**Session**: 2026-06-20 (`mi`, resumed from `go`). Measure-first per the pivot — re-anchored the tail on the
**current default solver (iso-dense W12)** before picking a lever (the prior tail studies predate W12). Two
zero-code measurements (`QUEENS_ROOT_TIMING`, `perf stat -M PipelineL1,PipelineL2`), clean box (20 GB free,
swap/zram off, ARC 2 GB), full 17 GB TT, n=16.

**(1) Macro reframe — `QUEENS_ROOT_TIMING=1 solve 16 iso-dense`:** wall **97.9s**, SECOND, **2.003 B nodes**
(confirms the ~1m39s record). Root schedule:
- **tail root idx 29 (sq 1): ran 91.7s, ended 97.9s — SOLO for last 17.5s (18% of wall).**
- **longest 3 root durations [91.7s, 74.2s, 52.3s] — longest = 94% of total wall.**

So under W12 the prior **"2 dominant roots / 51% util"** sharpens to **ONE giant root = 94% of the wall**, with
a 17.5s single-root SOLO tail (core util ~14/24 late). W12 cut nodes −60% but did **not** change this macro
shape. **The scheduling prize is small + closed:** the 17.5s SOLO tail at ~14 cores ≈ 7–8% of wall if perfectly
re-parallelised — and the work-stealing A/B already proved capturing it is net-negative. **⇒ the wall lever is
the giant root's WORK, not its schedule** (confirms the pivot from a fresh angle).

**(2) Cost re-attribution post-W12 — `perf stat -M PipelineL1,PipelineL2` (perf inflated wall to 113.7s; %slots
are rate-valid):** retiring **13.6%** · bad-spec 6.7% · **backend 32.8%** (memory **29.8%** / cpu 3.0%) ·
**frontend 31.4%** (latency **22.9%** / bandwidth 8.5%) · **SMT-contention 15.3%**. **Co-dominant memory +
frontend** — consistent with pre-W12 measurement #0 (~35%/~35%); W12's win was the −60% node cut, not a
per-node rebalance. The memory bucket is **latency-bound** (iso-window TT-size sweep was wall-flat — not
capacity) and the handoff notes it is **only half-hidden by one-ahead prefetch**.

**Lever implication (the menu, all "attack the work"):**
- **A. MLP-batched probes on the explicit-stack frontier (`wins_inc_iter`) — NOT YET TRIED; recommended to
  scope first.** Attacks the **largest single bucket (30% backend-by-memory = exposed pc≥13 DRAM-probe
  latency)** by holding K frames probed-not-expanded ⇒ K TT gets in flight ⇒ overlap the ~120 ns latency that
  prefetch only half-hides. This is unlock-list **#4** — the explicit stack was built **for** exactly this,
  and it is **immune to the transposition-saturation** that killed ABDADA/work-stealing (it is *single-worker
  latency-hiding*, not parallelization). Napkin ceiling ~10–15% wall (the exposed half of the 30%).
- **B. getK throughput recovery** (compiler-vectorize the K=10/11 code-build) — cuts the frontend (31%) getK
  compute. Ready/scoped (the getK-throughput proposal, `rust/notes/proposal-2026-06-19-getk-throughput.md`);
  smaller (~3–10% M/s), lower risk, codegen-shaping.
- **C. Grouped-frontier DDD** — dedups the pc 13–21 frontier ⇒ fewer distinct pc≥13 probes **and** fewer getK
  invocations (hits **both** buckets). The standing big lever; heavy/multi-session; the win/loss (not nimber)
  variant is the one that doesn't re-expand.

**Doc nit found:** `iso_flat.rs:379-380` `dense_k` doc says "default 9, clamped 9..=11" — stale; the code is
`env_u32("QUEENS_DENSE_K", 12).clamp(9, 13)` (default **12**, clamp 9..=13). Fix in a doc pass.

**NEXT = user steer on the lever (A MLP / B getK / C DDD).** A is the highest-ceiling not-yet-tried lever and
reuses built substrate; B is the safe ready bet; C is the big bet. (Tooling left on screen: tmux `queens`
windows `char-rt`, `char-prof`.)

### Per-pc probe economics (`QUEENS_PROF`) — probe-skip REFUTED; MLP/prefetch-warming is the lever (2026-06-20--9)

User asked three design angles (streaming/dense, idle-core prep, "any TT check not worth doing"). Ran
`QUEENS_PROF=1 solve 16 iso-dense` (per-pc TT get/put cycle profile) to ground all three. n=16, 2.007 B nodes,
3.11 B gets / 557,949 Mcyc get / 56,196 Mcyc put.

| pc band | gets | cyc/get | hit-rate (gets−nodes)/gets | share of probe cost |
|---------|------|---------|----------------------------|---------------------|
| 13      | 600 M | 176 | 39% | 19.0% |
| 14      | 431 M | 176 | 38% | 13.6% |
| 15–17   | 1.03 B | 176–177 | 36–38% | 32.7% |
| 18–21   | 687 M | ~180 | 34–35% | 22% (cum **87%**) |
| ≥40 (near-root) | ~tens of K | **50–60** (warm/cache-resident) | — | 0.4% |

**Findings:**
1. **Probe-skip ("TT check not worth doing") is REFUTED — the probes pay ~22×.** A pc==13 probe costs 176 cyc;
   its 38% hit-rate saves a ~13-`getK`-call re-expansion ≈ ~10,000 cyc (getK is real `u128` dense compute) ⇒
   expected saving 0.39×10,000 ≈ 3,900 cyc per probe vs 176 cyc. Skipping = a 22× loss. **Independently
   confirmed:** skip-and-resolve-densely *is* W13, which is measured net-negative. No band is skippable (low-pc
   memoizes expensive getK; high-pc saves huge subtrees and is warm/cheap). The put side (10% of probe cyc,
   relaxed-store writes) enables the 38% hits — also worth it.
2. **The flat 176 cyc/get at pc 13–21 IS the 30% backend-memory bucket** — cold DRAM latency that one-ahead
   prefetch is **not** hiding (the warm near-root probes run at 50–60 cyc = the achievable floor). Cross-check:
   ~8% of total cycles sit in these stalled get-windows; ×4-wide ≈ the TMA's 29.8%-of-slots backend-memory.
3. **⇒ The three angles converge: can't-skip → must-hide → MLP / idle-core prefetch-warming is THE lever** for
   the biggest bucket. Prize = drag pc 13–21 from 176 → ~60 cyc (warm floor) ⇒ upper end of the ~10–15% napkin.
   pc 13–21 = 87% of probe cost, so the batch target is well-defined.

**Decision:** build **A (MLP)**. Step 0 (discipline, before the 52%-of-cycles hot loop) = a **standalone
microbench** of probe throughput vs batch depth (1/2/4/8/16) over the real 17 GB TT with random keys — measures
the latency-overlap ceiling for both single-core MLP and the multi-core prefetch-prep pipeline, zero solver
risk. Then A1 (batched even-frame probe in `wins_inc_iter`, gated, byte-identical off). The idle-core
dense-chunk-streaming pipeline is the multi-core lift of A1 (DDD with offloaded prep) — gated on A1's measured
ceiling.

### MLP microbench — ~1.85× latency-overlap headroom; latency-hiding GREEN-LIT (2026-06-20--9)

Step-0 microbench landed (`tt.rs::mlp_bench::mlp_probe_depth_sweep`, `#[cfg(test)]` + `#[ignore]`, not a gate;
run with `cargo test --release --lib mlp_probe_depth_sweep -- --ignored --nocapture`). Single-thread random
probes into the real huge-page flat TT (8 GiB, prefaulted), software-pipelined `prefetch_hashed`-ahead by
`depth`, then `get_hashed`:

| depth (probes in flight) | ns/probe | M/s | vs depth-0 |
|--------------------------|----------|-----|-----------|
| 0 (≈today's one-ahead)   | 16.6 | 60.4 | — |
| 4                        | 12.8 | 78.0 | +29% |
| 8                        | 10.9 | 91.6 | +52% |
| 16                       | 9.3  | 107.3 | +78% |
| 32                       | 9.0  | 111.1 | +84% (plateau) |

**Verdict: the memory system is NOT saturated by one-ahead — ~1.85× single-thread probe-throughput headroom,
plateauing at ~8–16 in flight.** Latency-hiding (MLP / idle-core prefetch-warming) is a live lever, not dead.
Caveats for the in-solver translation: (a) single-thread @ boost clock here (16.6 ns ≈ 50–83 cyc) vs the
solver's 176 cyc/get (24-thread contention + all-core clock + rdtsc) — real per-probe latency is
contention-inflated, so overlap matters *more*; (b) the microbench is pure-memory (no compute between probes);
the real loop is co-dominant frontend, so realized gain < 1.85×; (c) **the overlap headroom is largest in the
tail** — the SOLO phase runs ~14 cores, leaving spare memory bandwidth exactly where the lever is needed.

**Characterization COMPLETE + self-consistent:** can't-skip (PROF 22× ROI) → must-hide (microbench 1.85×) →
no-free-locality-beyond-pc (canonicalization destroyed it; seg TT already banks the pc axis at +5%) →
manufacture locality by sorting (DDD), ideally on idle cores.

### A1 Fermi'd BELOW BAR; sorted-stream microbench = ~5.7× ceiling ⇒ A'' (sorted frontier) is the lever (2026-06-20--9)

**User: "A1 go" → "yc".** Building A1, Fermi hit a structural wall, so I measured the alternative instead of
sinking the per-node build.

**Why per-node A1 is below the bar (Fermi):** the microbench's 1.85× needs ~16 *independent* probes
back-to-back. One prove-loss node has only a handful of recurse children (~3–12), and two DFS facts cap it
further: (a) a recurse-child MISS descends its whole subtree before the next sibling is touched (can't keep
siblings in flight); (b) the TT *mutates during descent*, so you can't probe a sibling batch, cache results,
and reuse them (stale → re-expansion) — you must re-probe at use-time. The one clean per-node win that survives
is **probe-before-expand** (probe all children; a known TT-loss child wins the prove-loss node → skip the
miss-siblings' expansion = a free node cut, gate-safe on iso-dense) — but the *overlap* part is bounded to the
hit fraction at one small node (~few %), and realizing it needs cache + miss-batch state across the
suspend/resume in the 52%-of-cycles hot loop: **high risk, ~few-% reward — below the per-node-micro-opt bar.**

**The 1.85× (and more) is a FRONTIER-WAVE number — measured the sorted ceiling** (`tt.rs::mlp_bench`, extended
with a sort-by-slot pass; same 8 GiB huge-page TT, single thread):

| depth (in flight) | random M/s | **sorted M/s** | sorted/random |
|-------------------|-----------|----------------|---------------|
| 0 (≈today)        | 52.4      | 88.5           | 1.7× |
| 8                 | 83.1      | 153.1          | 1.8× |
| 16                | 92.0      | 208.5          | 2.3× |
| 32                | 99.9      | **301.3**      | **3.0×** |

**Sorting the probes by target slot before streaming them = up to 3× over random *at the same depth*, ~5.7×
over today's effective regime (random depth-0/1 ≈ 52–58 → sorted depth-32 = 301 M/s) — and it COMPOUNDS with
depth** (sequential access saturates bandwidth; random plateaus latency-bound at ~7 GB/s). Sorted ~50-slot
spacing at this density mostly hits the same open DRAM row → row-buffer hits. (Sort cost excluded — in A'' the
idle cores pay it off the critical path.)

**DECISION (data-backed): skip per-node A1; the lever is A'' = the sorted-frontier wave** — materialize a
pc-band frontier slice, **sort by slot, stream the wave** (probe back-to-back, deep pipeline → 3–5.7× probe
throughput) **+ dedup** (sorted ⇒ adjacent duplicates removed ⇒ fewer probes). This is grouped-frontier DDD
(win/loss variant), with the sort offloaded to idle cores = the user's idle-core-prep / dense-chunk-streaming
vision; **BuRR re-enters here** as the value-only ~1.1-bit/key dense backing for *frozen* (solved) plies
(sound under windowing's known membership → cache-resident, sequentially streamable). Ceilings now measured:
per-node MLP ~1.8×, **sorted frontier ~4–5.7×, ~3× better and node-count-adjacent.** Caveats for translation:
single-thread @ boost here; under 24-thread contention bandwidth is shared (but the ~14-core tail has spare);
realized < ceiling after sort + frontier-management + DFS-residence loss. **A'' is the multi-session build —
scope with the user** (the [grouped-frontier DDD proposal](../proposal-2026-06-18-grouped-frontier-ddd.md)
already covers Phase 0/1; the win/loss + sorted-stream + idle-core-sort framing is the new synthesis).

**Committed (`eabb0e6`):** doc fix (`iso_flat.rs` dense_k default 12 / clamp 9..=13) + the random+sorted
microbench (`tt.rs::mlp_bench`, `#[cfg(test)]`/`#[ignore]`); production binary byte-identical.

**A'' SCOPED:** [sorted-frontier-wave proposal](../proposal-2026-06-20-sorted-frontier-wave.md) — 3 approaches
(A: in-DFS sorted wave, single-core prep / B: idle-core producer-consumer pipeline = the user's vision / C:
ply-windowed retrograde DDD, the n=18 endgame + BuRR-frozen plies). **Recommendation: build toward B,
Phase-1-validate with A** (cheapest in-solver proof the sorted-stream win realizes before the pipeline build).
Phase 0 = size the pc-band frontier width + a 2–4-thread sorted-stream microbench (does 5.7× survive
contention?). Distinct from the parked component-nimber DDD (that dedup'd by cutoff-free nimber → 6.6× wall;
this dedups by **sort**, keeps α-β).

### Frontier work-stealing BUILT + tuned + measured NEGATIVE — parallelization route CLOSED (2026-06-19--7/8)

**Session**: `37195ab0-cc8d-4c5a-89fa-3f07ff95997a` — `mi`; user steered the whole tuning arc live.
**Commits (main)**: `773ba8d` (ABDADA, gated) · `7e3be6b` (ABDADA negative docs) · `fb6b972` (work-stealing
core, gated) · `be4dc57` (60s tail-gate + harness monitor) · `ce46f41` (steal tuning knobs + split
diagnostics + `--to-file` JSON + serde).

**What was built (all gated off; control byte-identical; `steal_agrees` test green; n=16 verdict SECOND):**
- **ABDADA in-flight markers** (`QUEENS_ABDADA`): `Slot::IN_FLIGHT=0xFF` sentinel + tri-state `Probe3`
  `get_inflight_hashed` + `mark_inflight_hashed` in `tt.rs`; `wins_inc_iter` gained `const ABDADA` + a
  two-pass deferral (`IncFrame.pass` PASS0/PASS0_DEF/PASS1).
- **Frontier work-stealing** (`QUEENS_STEAL`, implies ABDADA): `wins_inc_iter` gained `'scope`/`&rayon::Scope`
  + `const STEAL`; at an even-depth (prove-loss) frame, idle-gated, it publishes children as scope tasks
  (`scope.spawn`) so an idle worker searches them and writes the verdict to the shared TT; the busy worker
  defers them (ABDADA) and PASS1 resolves them as hits, not re-expansions. Handoff wrapped in
  `rayon::in_place_scope` (joins all stealers before returning). Gating knobs: `QUEENS_STEAL_DELAY` (50s
  watchdog arms a flag, sampled every `STEAL_CHECK_EVERY=4096` nodes via a local counter — no per-node
  atomic; the early all-roots phase pays ~nothing), `QUEENS_STEAL_WIDTH` (per-frame publish cap, def 2),
  `QUEENS_STEAL_MIN_PC` (only split a child whose avail-pc ≥ this, def 18→use 35), `QUEENS_STEAL_MAX`
  (concurrent in-flight cap, def n_threads).
- **Tooling kept:** split diagnostics (`steal_published` + per-pc histogram + `steal_fallback`), printed
  post-solve; `StealReport` (serde) + `Solver::steal_report()`; **`solve --to-file PATH`** writes the run
  as JSON (verdict/nodes/wall/TT + steal) while the TTY keeps the human text; `queens-ab.sh` now tees the
  solver summary to the pane + writes a `$STATE` monitor file + has a memory-guard so default-17 GB A/Bs
  don't OOM back-to-back.

**The measurement arc (each step the user steered; the trustworthy metric is the INTERLEAVED A/B):**
1. ABDADA at default split: **wash → small loss** (+0.76% cyc/node robust over 4 rounds; node trim flat —
   the early "−6%" was a cold-cache outlier). Nothing to defer: baseline re-exp ≈ 1.0.
2. ABDADA + finer-split (`MIN_AVAIL=48`): **LOSS** — does not remove B1's pc 13-21 re-expansion (the
   re-expansion is in *large* nodes; a deferrer can't profitably wait for one — its other work finishes
   ~when the owner does ⇒ PASS1 expands it anyway).
3. Ungated work-stealing: **2.4× slower / +55% nodes** — over-published in the early parallel phase
   (`deep_busy` reads idle before workers hand off).
4. 60s tail-gate + width-21: **+25% wall / +15% nodes** — gate fixed the catastrophe but a 21-wide publish
   burst per frame re-expands.
5. Split diagnostic (min_pc 18): **12.3M subtrees split, mean avail-pc 19.6, 9.7% fallback** — far too
   many tiny splits; the tail is overwhelmingly pc 18-21 nodes.
6. min_pc sweep (single runs, noisy): 18→12.3M, 25→541K, 35→313K, **50→1.9K, 65→1.8K** splits. **A cliff at
   pc 50** — only ~1,900 frames with pc≥50 exist after 50s (the roots have already descended past the big
   shallow frames). So "split high + early" is *not reachable* at the time idle cores appear.
7. **Definitive 4-round interleaved A/B, steal@min_pc=35 vs control, default 17 GB TT:**
   | round | control nodes/wall | steal nodes/wall |
   |-------|--------------------|------------------|
   | 1 | 2.09B / 119s | 2.34B / 132s |
   | 2 | 2.01B / 106s | 2.22B / 129s |
   | 3 | 1.95B / 103s | 2.19B / 120s |
   | 4 | 2.10B / 115s | 2.11B / 121s |
   | **mean** | **2.04B / 111s** | **2.22B / 125s** |
   **+8.7% nodes (re-expansion), +13.3% wall — a loss in every round.** The single-run "1.91B/99s" at
   min_pc=35 was a low-node fluke; interleaving cancels the ±18% common-mode node-count noise.

**VERDICT — the DFS-parallelization route to the giant-root tail is CLOSED, with evidence.** Five
independent approaches (B1 finer-split, ABDADA, ungated steal, width-21 steal, tuned steal) all add
re-expansion, because the tail is **transposition-saturated**: the work that would fill the ~51%-idle cores
is shared transpositions, so any scheme that does it concurrently re-does it (the in-flight markers can't
win every race; the few clean-disjoint big subtrees, pc≥50, are gone by 50s). We've now *built* both levers
session --5 named (ABDADA + frontier work-stealing) and measured both negative — so this is settled, not
assumed. **Not a "floor"** — the lever is *not parallelization*. The work itself must shrink (getK/W_K
node-count, per-node cost) or **de-duplicate** (grouped-frontier DDD — the only "parallelism-adjacent"
lever that doesn't re-expand, *because* it dedups). All steal/ABDADA code stays gated-off on main (zero
prod cost, substrate + instructive negative; do NOT revert).

### NEXT SESSION — characterize the tail FIRST, then attack the work (ChatGPT idea backlog)

The user wants next session to **characterize what the 2 dominant roots are doing late** before picking a
lever (we kept tuning a scheduler before fully understanding the work — measure-first). ChatGPT's ideas,
grouped; the **tail-characterization** cluster is the priority:

**A. Characterize the tail work (do these first — cheap, decisive, mostly cold tooling):**
- **Measure span, not just work** — reconstruct the actual critical path (the longest cumulative-cost
  dependent chain) of the giant root; optimize the top-N nodes *on that path*, not global averages. (Our
  steal failures are consistent with a span/critical-path limit, never directly measured.)
- **TT-hit profile by popcount AND graph shape** — the dominant cost center late may be a small set of
  graph families, not a pc layer. Extend the `QUEENS_PROF` per-pc latency profile with a graph-signature
  bucket.
- **Cross-root transposition reuse, explicitly** — count TT entries first inserted by root A and later
  consumed by root B (and vice-versa); `count --roots` (session-10) measured ~2× union reuse but not the
  directional A→B flow. Asymmetry would inform warmup ordering.
- **Reuse heat-map over iso classes / "state ROI"** — for each solved state, `(future hits avoided × avg
  probe cost) / solve cost`; find which canonical graph families dominate future lookups → the optimization
  target. Build a centrality predictor for high-reuse "hub" states.
- **Early graph-shape overlap of the two roots** — log the first N canonical fingerprints each dominant
  root visits; measure overlap *rank*, not just count.
- **Memory-traffic re-attribution after W12** — re-run the latency study; the dominant DRAM source may have
  shifted from pc layers to specific graph structures (the `--3`/`--5` hit-cost study predates this).

**B. Attack the work (the levers the characterization should point at):**
- **Grouped-frontier DDD** (the standing big lever, [proposal](../proposal-2026-06-18-grouped-frontier-ddd.md)):
  materialize the pc 13-21 frontier, bucket by graph signature, solve each unique boundary graph **once**
  (dedup by sort, bandwidth-bound). The one approach that fills cores *without* re-expansion because it
  de-duplicates instead of re-doing — directly counters the saturation we kept hitting. "Information
  propagation on a DAG: solve the most-reusable states earliest."
- **getK-C1 throughput / W_K node-count** (the queued throughput leads) — cheaper/fewer nodes on the path
  the tail grinds; the `notes/proposal-2026-06-19-getk-throughput.md` lead.
- **Synthetic frontier above W12** — not W13 as a dense layer, but a specialized exact evaluator for the
  *specific graph families* frequent enough late to justify it (ties to the TT-hit-by-graph-shape profile).
- **Warmup as a first-class phase** — optimize "useful TT entries generated/sec" not proof progress; A→B vs
  B→A seeding (asymmetric overlap); plot marginal runtime gain per warmup second to find saturation. Smarter
  than the current time-based warm-restart (targets high-*centrality* states, not just elapsed time).

**C. Parked / lower-value (measured-dead or speculative):**
- Speculative sibling expansion for dominant roots *with cancellation* (widen the OR-spine) — fact #5 says
  speculation defeats the cutoff; cancellation is the only new ingredient, but rayon has no clean cancel.
  Low EV; only if A says the spine truly is the critical path AND nothing else works.
- Per-position scheduling for the 2 dominant roots (dedicated workers / lower split thresh) — a scheduler
  lever; deprioritize until the work is characterized (we just learned scheduler-tuning is the wrong axis).

**Method banked this session:** the n=16 node count is ±18% common-mode noise — **single runs lie**
(min_pc=35 read 1.91B/99s solo but 2.22B/125s interleaved). Only the *interleaved* A/B (or node-independent
cyc/node) is trustworthy. And: **characterize the work before tuning the scheduler** — we built and tuned a
whole work-stealing harness before the split diagnostic revealed the tail is millions of pc-18-21 nodes that
fundamentally re-expand when parallelized.

### ABDADA in-flight markers BUILT + measured — structural NEGATIVE; work-stealing is the lever (2026-06-20--7)

**Session**: 2026-06-20 (`mi`). Resumed from `go`; the user steered "no gating on fermi. push forward and
expect initial small regressions. push past them." So I built the real ABDADA in-flight-deferral on
`wins_inc_iter` (skipped the side-set probe) and measured it at n=16. **Commit `773ba8d`** (gated off).

**What was built (gated `QUEENS_ABDADA=1`, off by default, control byte-identical):**
- `tt.rs`: `Slot::IN_FLIGHT` sentinel (`val=0xFF`), tri-state `Probe3` `get_inflight_hashed`,
  `mark_inflight_hashed` (relaxed-store claim). Markers only hide latency; every fallback degrades to a
  plain re-expansion and only the completing put records a (deterministic) value ⇒ verdict is
  timing-independent. **Limitation:** don't checkpoint-resume an ABDADA run — a mid-flight dump would
  capture a `0xFF` marker that the plain `get_h` reads as a win (markers are `!COUNT`-only and the
  distinct-counter path is disabled under ABDADA for the same reason).
- `iso_flat.rs`: `const ABDADA` monomorphisation of `wins_inc_iter` (resolved once per subtree handoff,
  never per node — hot-path-toggle rule); `IncFrame.pass` two-pass deferral state (PASS0 skip in-flight
  children → keep working others → PASS1 revisit: now-finished are hits, stragglers expanded by us).
- Correctness: new `abdada_agrees_on_small_even_boards` test (n=8/10/12 verdict == naive **under the real
  parallel solver**, where deferral actually fires — a single worker never re-probes its own on-stack
  markers, since available-popcount strictly shrinks down a DFS path). **All n=16 A/B runs returned SECOND**
  (correct verdict at full scale). Gate green: n=12 iso-flat `--distinct` 1,060,823/1.25× (control) and the
  `QUEENS_ITER` non-abdada path matches; n=14 second/1.02×; clippy/fmt clean.

**MEASURED — the core bet fails (structural, not a tuning regression).**

| config (n=16, iso-dense, 12 GB TT) | cyc/node | nodes | wall | verdict |
|------------------------------------|----------|-------|------|---------|
| default split, CTRL (4-round mean) | 2956.9   | 2.05 B | ~105 s | small-loss baseline |
| default split, **ABDADA** (4-round mean) | **2979.3 (+0.76%)** | 2.07 B (+0.8%) | ~107 s | **wash → +1.5% (LOSS)** |
| finer split `MIN_AVAIL=48`, FINE (B1) | ~3361 (+14%) | ~2.75 B (+34%) | 133–143 s | LOSS (re-exp, as session --5) |
| finer split, **FINE+ABDADA** | ~3412 | 2.83–3.17 B | 143–163 s | **LOSS — ABDADA does NOT remove B1's re-exp** |

- **Default split: ABDADA is a wash-to-small-loss.** cyc/node +0.76% is *robust* (every one of 4 rounds
  AB > CTRL — it's the marker-store + tri-state-probe cost); the node count is flat (+0.8%, noise). The
  one early run that showed "−12% / −6% nodes" was a **cold-cache outlier** (a CTRL `off_1` at 114.6 s vs
  the cluster's ~104 s); 4 clean rounds erased it. **There is essentially nothing to defer at default
  split** — baseline re-exp is already ~1.0 (warm-restart + the split-node `par_tt` memo prevent the
  concurrent duplicates), so the marker overhead buys nothing.
- **Finer split + ABDADA: a clear LOSS.** Finer split (B1, `MIN_AVAIL=48`) reproduces session --5: +34%
  nodes, +14% cyc/node, ~135–163 s wall. **ABDADA does not remove that re-expansion** (FINE+AB node count
  ties or *exceeds* FINE; the worst run of all was FINE+AB at 162.8 s / 3.17 B).

**WHY (the structural reason — confirms session --5 from a new angle, by building the actual mechanism):**
the giant-root-tail re-expansion is in **large pc 13-21 nodes (the bulk of the work, not a thin frontier)**.
ABDADA's deferral only saves a re-expansion if the in-flight node's *owner finishes it during the
deferrer's other-work window*. For a large balanced subtree, the deferrer's "other children" are *also*
large and finish ~when the owner does — so PASS1 still finds the node in-flight and **expands it itself
(the fallback) = the re-expansion is NOT avoided**. Deferral is a latency-hider; the deficit is a
bulk-work transposition race. Wrong tool. (It *would* help if the duplicates were small/quick — but those
aren't where the re-expansion mass is.)

**THE LEVER THIS POINTS TO — frontier work-stealing (the handoff's other named lever).** The fix for
ABDADA's fallback is exactly: instead of *re-expanding* the in-flight node independently, **steal a
sub-frontier from its in-flight owner** — split the SAME work across the two workers (no duplicate at all).
The ABDADA marker infra is the **substrate**: it already flags which nodes are in-flight ⇒ stealable, and
which owner to steal from. That converts "defer-or-re-expand" (the dead end) into "defer-or-help" (the
real parallelization of the OR-spine tail). **Heavy:** needs the per-worker `INC_STACK` arena to become
shareable/splittable (today thread-local) — a per-worker work-stealing deque or a shared frontier pool.
This is the architectural multi-session build; **decide scope with the user.**

**Status of the ABDADA code:** keep it gated-off on main (zero production cost — the `ABDADA=false`
instantiation is byte-identical, validated) as the **work-stealing substrate** + the documented negative.
Do NOT ship `QUEENS_ABDADA` as a default (it's a measured loss). Do NOT revert (substrate + instructive
negative; and the global revert-ask rule applies).

### Explicit-stack shape built + micro-opted to parity (2026-06-19--6)

**Session**: 2026-06-19--6 (`2bbbb8da-5981-4a0c-a5eb-3ad05ddafe19`) — `mi`. Resumed from `go`; the user
steered the whole session: "focus on hit costs and unrolling" → "make all tt hits / iso short-circuits
cheaper" → "unwind recursion into loops where we can" → after the peel washed, "bail and do the full
unpeel" → "keep the code, off by default on main" → "opus sub to micro-opt your unpeel."

**Completed:** the recursion→loop conversion (3 variants, all gated/byte-identical), the throughput verdict
(wash/parity — RAS-dead), the unlock analysis, the committed harness + CLAUDE.md lessons, and the Opus
micro-opt closing the explicit-stack to parity. **Commits:** `f124bc5` (harness+docs), `3f10919` (iter code).

**Instructions for next agent:** the micro-opt was landed by a sub-agent in the working tree — **validate
the gate + the n=16 A/B parity, then commit it** (Progress item) before starting ABDADA. The shape is
throughput-neutral now, so ABDADA doesn't have to "pay back" a regression — any re-expansion it removes is
net win. Start with **ABDADA in-flight markers** (most surgical), Channel-Fermi the re-expansion prize
first. `/tmp` has ~40 stale A/B scripts + ~20 binaries from prior sessions — the committed harness replaces
them; don't delete the handoff-referenced `/tmp/queens_*` binaries.
