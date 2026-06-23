# Push past the n=16 floor — spare-resource + structural lever backlog

**Date**: 2026-06-22
**Session**: 2026-06-22--6 (`a20b03dc-e462-4801-ab1b-88b683f9980b`)
**Mode**: intent-based
**References**:
- Move-ordering retired + the QUEENS_RANK/ranklab tooling: [explicit-stack-frontier --20/--21](2026-06-19-explicit-stack-frontier.md)
- Umbrella + lever backlog: [queens-memory-roadmap](2026-06-15-queens-memory-roadmap.md)

## Context

The serial live-loop levers are exhausted (`--20`: move-ordering proven DEAD by a live n=16 A/B;
prefetch DEAD; DFS-parallelism CLOSED). The clean-box n=16 floor is ~24–27s search. This thread is the
deliberate hunt to push past it using **(a)** the CPU/memory/bandwidth the giant-root tail leaves idle
(~51% core util, ~96% of wall in one serial root) and **(b)** structural reshapes of the search.

Driven by a multi-agent exploration this session (several Opus sub-agents, each confronting the prior
"closed" verdicts for cracks). Output = the ranked lever menu below. Every live lever has a **cheap,
mostly-offline go/no-go test** defined before any build, so a future session can resume any one cold.
Project rule in force: **never declare a floor — present evidence, the user decides.**

## The lever menu

### TIER A — bankable now, low risk

**ETC pc-gate (signal-free).** Two ETC sub-agents (signal-guided + "train a better ETC") converged on
the same conclusion:
- The reply-degree signal **cannot** help the ETC: the ETC cuts on TT-**residency** (is this child
  already solved-as-loss in the TT?), while the signal predicts **game-theoretic** loss. In the mass
  bands (node pc19–25) the recurse children are ~100% cold ⇒ no resident-loss cuts exist to reorder.
  Residency is **unlearnable from cheap node features** (predicted held-out AUC ≈ 0.5 — the deep tail is
  ~unique, re-exp ≈ 1.0×, 0.2% hit base rate); the true ETC-fire predictor **is pc itself** (children
  below ~pc26 are getK leaves or cold-unique → can't be resident regardless of node structure).
- **The one live ETC lever:** the `nw >= 2` ETC batch is currently **NOT pc-gated** — it pays its
  prefetch+probe cost in the cold pc19–25 mass and yields ~0 cuts. Gate it OFF below ~pc26–28 (keep the
  descriptor build — the descent reuses it). **Ceiling ~−1.5–2% wall, NODE-SET-IDENTICAL** (only
  relocates the cut site). Corrects a stale number: the *fused* ETC incremental cost is **~+3.6%
  cyc/node** (M_ORD vs M_ORD_W @ K=17), NOT the old +22% (that was the separate-pre-pass M_WAVE).
- **Go/no-go test:** a ~10-line `M_RANK` tap — `etc_probes[pc]` + a "probes-per-cut by pc" column.
  Recoverable = Σ probes below the crossover × cold-latency ÷ MLP-discount ÷ total cyc. **DOA only if
  those wasted probes are already MLP-hidden** (the tap shows this directly).

### TIER B — measured GO / in flight

**(B1) Cross-root eviction-recovery pre-warm.** Re-fill, on idle cores, positions the giant tail will
re-probe that an earlier root already solved but the direct-mapped TT evicted. Re-put a **known** value
(fingerprint-checked, order-invariant) — NOT speculative expansion, so it escapes the closed
DFS-parallelism trap.
- **Measured GO: `C ≈ 0.39` at n=14** (count --roots directional extension): ~40% of the dominant
  root's cold pc18–24 deep tail is also in another root's working set ⇒ recoverable. ~4× over the 0.10
  GO threshold; flat-to-rising n12→n14 (0.37→0.39). The "58% root-private / re-exp≈1.0×" prior is
  all-pc/within-solve — this is the never-measured *directional cross-root* quantity.
- **Caveats:** D4-key measurement = conservative floor (iso-key would raise C). n=16 exact count is
  infeasible (>100 GB) → **n=16 sampled-HLL directional confirm is QUEUED** (fire when box frees). The
  pool EXISTS; the net win still needs a live build + A/B (re-fill *timing* vs the tail + re-put
  bandwidth/pollution risk — re-puts touch random slots, may evict live entries).

**(B2) Canon-skip (pre-canon exact-key skip).** Skip the whole canon stack (`child_orient` →
`lex_min8` → `d4_bits` → `hash128`) + probe + put for never-recurring recurse children, decided on the
exact `child0` **before** canonicalization. re-exp ≈ 1.0× ⇒ that work is pure waste for the
put-once-never-read cold bulk.
- **Napkin ceiling ~8–14% of cycles** (`lex_min8` is the #1 branch-mispredict source). Probe-ONLY is
  just 2.4% (= DOA); the canon+put is the real prize this raises.
- **★ KILLED (n=16 oracle-sidecar experiment, this session).** Ceiling (canon+probe+put) measured at
  **~6–9% of cycles** (canon ~6.1% via a node-count-neutral cost-doubling A/B; probe+put ~1–1.5%,
  MLP-overlapped ⇒ little removable) — *below* the ~8–14% napkin. Perfect-oracle wall upper bound ~6–9%.
  **The killer:** the skip-all A/B (skip ALL in-band recurse children = the best any per-exact-`child0`
  decision can do) was **+30.7% nodes / +15.1% wall — a NET LOSS.** The put IS the memo; the ~0.2% of
  pc18–25 positions that recur (M_COLD: ~0.1–0.2% hit/node), once un-put, **re-expand their whole
  also-unmemoized subtree** → 0.2%/node cascades to +30.7% total nodes. A real exact-`child0` predictor
  *cannot* dodge it: recurrences arrive via *different* orientations (distinct exact `child0`s), so the
  predictor can't separate the 0.2% recurring from the 99.8% never-recur — skip-all IS its best case,
  and it's +15% wall worse. The cascade is unbounded; a ~6–9% upside can't cover a +30% node downside.
  Verdict stayed SECOND (verdict-preserving). **Do not build the predictor.** Lesson: skipping the
  memo-put for "never-recur" positions is unsafe — you can't tell which won't recur, and misses cascade.

### TIER C — newly surfaced, cheap offline go/no-go, high ceiling

**(C1) ★ Canonical getK W9–12 value layer — the standout.** getK's **44% of cycles** is the recursion
**above K=8**, which is **labelled and memo-less**: it re-derives the same 9–12-vertex Node-Kayles value
billions of times in different parent contexts (W≤8 is the only canonical layer). The dead "getK-memo"
failed because it was a **random-DRAM** open-addressed probe ("math cheaper than mem"). This is the
inverse: a small **L2/L3-resident table keyed by the validated `comp_canon`** (collision-free by
construction — same mechanism as the freeze key), so the probe is a cache hit and the canon collapses
the labelled keyspace by the iso merge (~3.4×) on top. **This is EXACTLY the lever the W8 table already
proved** (3m33s→2m44s at K=8); the open question is purely whether the K=9–12 *distinct-canonical* set
stays cache-resident where the *labelled* set did not.
- **Go/no-go (offline, no solve, no hot-path change):** extend `count --comps` to accumulate, at each
  getK-entry pc 9/10/11/12, the distinct count of `comp_canon` keys (HLL or exact set) + the total call
  count (= re-derivation multiplicity). **Build if distinct fits L2/L3 (~100K–1M) AND multiplicity ≫
  10×; stop if distinct is tens of millions (the dead-memo regime).** Reuses the
  `iso_key_fast_in::<HIST=true>` machinery already in `count --comps`.
- Effort 1–2 sessions if go. **Highest expected value — attacks the dominant cost, with a precedent.**

**(C2) Treewidth / separator DP for the pc18–28 tail — the exponent-changing shot.** Node-Kayles on a
graph of treewidth `w` is `2^w · poly`, not exp-in-n. The deep available-graph is ONE component (1.003
comps at pc16 → component/nimber decomposition is DEAD), **but its width is entirely unmeasured.** If the
pc18–28 tail graphs are tree-like (treewidth ≤ ~10), a separator/elimination-ordering DP could resolve
81% of the loss mass below the node-count wall — the only idea that could change the *exponent*.
- **Go/no-go (offline, pure Python on an existing `M_HITKEY` dump, no box):** min-degree / min-fill
  treewidth *upper bound* on the sampled pc18–28 graphs. **Median ≤ ~10 → feasible; ≥ ~18 → dead.**
- Research-grade build, but the test is cheap and decisive. Highest ceiling.
- **★ PREMISE CONFIRMED (n=14, min-fill upper bound, `scratchpad/treewidth.py` on a HITKEY dump):**
  median tw-bound = **11 overall**, and **8–10 at the high-mass bands pc18–22** (pc18 med 8/max 10;
  pc24 med 11; pc28 med 15/max 17). A clique would be tw≈pc−1 (17–27) — the deep graphs are
  **tree-like (tw ≈ pc/2–pc/2.5)**, and min-fill is an upper bound so true tw is lower. 2^8–2^11 =
  256–2K boundary states at the mass bands ≪ a pc-20+ subtree. **The exponent-shot premise HOLDS.**
  The lever's risk is now the DP build + its constant factor, NOT the premise.
- **★ CONFIRMED AT n=16 (production scale) — EVEN BETTER:** median tw-bound = **10** (n=14 was 11);
  high-mass bands pc18–22 = **7–9** (pc18 med 7/max 10; pc24 med 11; pc28 med 14/max 17). The bigger
  board did NOT raise treewidth — it slightly lowered it (the available set thins out more). 2^7–2^10 =
  128–1024 boundary states at the mass bands. Premise solid at both n=14 and n=16.
- **★★ KILLED (the constant-factor go/no-go, 2026-06-22--7) — the premise was true but not sufficient.**
  The handoff's stated remaining risk ("the DP's constant factor vs the subtree it replaces") was
  measured directly and **the DP loses by 2–4 orders of magnitude.** Tool: `rust/scripts/treewidth_dp_probe.py`
  (validated Node-Kayles solver — matches Dawson's-Chess path nimbers + win/loss⇔nimber≠0 on random
  graphs). For each sampled deep-tail graph it measures **(A)** the subtree the DP would replace = distinct
  positions a memoized **alpha-beta + exact-availset-transposition** search visits below the graph (= the
  search's own work; re-exp≈1.0× ⇒ ≈ the real solver's subtree), vs **(B)** the DP cost bound `3^(w+1)`
  (any correct treewidth DP is ≤ s^(w+1)·poly). **Result (n=14 dump, 358 unique graphs): NOT ONE graph
  has subtree ≥ 3^(w+1); max ratio = 0.1.** At the high-mass bands the **median subtree is 80–768 nodes**
  (pc18:80, pc20:109, pc24:131, pc28:446) while `3^(w+1)` is **6.5K–43M**. The killer is an **anti-
  correlation**: where the subtree is finally big (~100–200K nodes) the treewidth is *also* big (pc80–90,
  tw 57–68 ⇒ DP cost ~10³¹), and where treewidth is small the subtree is already tiny.
  **Why (first principles):** a treewidth DP wins when the naive search is exp-in-n but the graph is
  low-width (`s^w ≪ 2^n`). Here the *reachable Node-Kayles-position count* (a few hundred) is already far
  below BOTH `2^pc` AND `3^w` — the search isn't paying the exponential the DP would save; it pays the
  much-smaller actual reachable-position count, because exact-availset memoization (the TT) already
  collapses each tiny sparse tail graph. **The deep tail is expensive by BREADTH (hundreds of millions of
  distinct positions), not DEPTH (no expensive per-position subtree).** A per-position DP cannot reduce
  breadth (it doesn't merge across *different* root graphs) — only the cross-position transposition
  sharing the search already exploits does. **Do not build the separator DP.** Lesson: low treewidth is
  necessary but not sufficient; you must also confirm the per-instance subtree is *large* before a
  per-instance FPT replacement can pay. **Redirect:** the win must shrink the *count* of distinct deep
  positions ⇒ back to the breadth levers — Tier-2 "cheap incomplete structural canon as a 2nd-tier TT
  key" (more merging than D4-iso) and the **C1 getK canonical value layer** (the untested standout).
  (n=16 confirm not warranted: the kill is 4 orders at the mass bands and structural; n=16 tw is *lower*
  than n=14 ⇒ even smaller subtrees / DP cost — it cannot flip.)

**(C3) Proof-DAG-minimizing AND-node scheduling at the giant root.** Attacks the gap between the
searched node count and the **minimal proof DAG** — a lever class never tried (move-ordering was OR-node
only). At a prove-a-loss (AND) node (must show all children winning — the no-cutoff bottleneck of the
giant root), schedule children **smallest-proof-first** + reuse transposition values, instead of
left-to-right. Local AND-node scheduling on the value-exact win/loss DAG (no GHI hazard), the regime the
floor doc says df-pn could go *below* the searched count.
- **Go/no-go (offline):** extend `ranklab` to score AND-node child proof-cost skew on the tail dump
  (gate `elapsed > QUEENS_TAIL_SECS`). **≥20% skew = real multi-second lever; <10% = uniform, drop.**
- Multi-session build; medium confidence.

### TIER 2 — parked, lower confidence
- **GFNI cross-leaf batched getK** — MLP **across sibling leaves** (the dead AVX kill was *within*-leaf).
  Gate: a microbench of 16-wide gathered W8 loads vs the serial `bt` arena-load chain (`bt` is 13.7% of
  get10).
- **Cheap incomplete structural canon as a 2nd-tier TT key** — merge most of the 3.4× iso at ~D4 cost
  (sound-but-incomplete invariant: collisions just fail to merge, never corrupt). Offline merge-ratio
  test on a dump vs `count --iso`.
- **Even-n pairing theorem mined from the proof DAG** — the only thing that beats silicon (O(1)). The #9
  free-involution fired <0.001%, but that was one specific involution; the proof DAG may reveal a
  generalized second-player pairing. Research program, not a session.

## DEAD with evidence (do NOT re-propose)
- **Probe-skip-only** sidecar/bloom — probe is ~2.4% of cycles (getK-shadowed, IPC 1.40); prefetch
  already dead on the same ~165 cyc; an L2/L3 bloom over 50 M deep keys is ~100% FP.
- **Signal in move-ordering** — live n=16 A/B: nodes +0.2% / wall +115%; getK-leaf mass + recurse-
  weighted capture ≈ noise (`base_rr ≈ 0` at pc18–24).
- **Signal / learned ETC** — residency ⊥ game-theory; AUC ≈ 0.5; pc IS the predictor.
- **Parallel solve-ahead of the tail / DFS work-stealing / ABDADA / TDS** — serial OR-spine,
  transposition-saturated, adds re-expansion (tuned steal = +8.7% nodes / +13.3% wall).
- **Component / nimber decomposition** — single component at deep pc (1.003 comps).
- **Prefetch / MLP latency-hiding** — the entry probe is inherently serial.

## Cheap offline tests to run next (no n=16 solve; reuse existing tooling) — START HERE
1. **★ getK distinct-`comp_canon` @ K=9–12 + multiplicity** (extend `count --comps`) — Tier-C1 go/no-go.
2. **treewidth min-fill bound** on a `M_HITKEY` dump (pure Python) — Tier-C2 go/no-go.
3. **ETC probes-per-cut by pc** (extend `M_RANK`, ~10 lines) — Tier-A go/no-go.
4. **proof-DAG AND-node child proof-cost skew** (extend `ranklab`) — Tier-C3 go/no-go.

## Codebase Reference

| What | Where |
|------|-------|
| getK cascade (the 44%) | `rust/src/queens/solver/iso_flat.rs` (~lines 3680–3720) |
| getK leaves / labelled-vs-canonical seam | `rust/src/queens/dense.rs` (`get16` ~975, `get_wide` ~1023) |
| `comp_canon` / `comp_canon_full` (the C1 table key) | `rust/src/queens/graph.rs` (~1347 / ~1388) |
| single-component confirm | `rust/src/queens/graph.rs` (`component` ~1526) |
| `count --comps` machinery (`decompose_node`, HIST pass) | `rust/src/queens/graph.rs`, `rust/src/bin/queens.rs` |
| `count --roots` directional ext (the C measurement, committed `20354fd`) | `rust/src/bin/queens.rs` (`roots_report`) |
| ETC batch (no pc gate) | `rust/src/queens/solver/iso_flat.rs` (`nw >= 2`, ~3300–3335) |
| `M_RANK` tap + report | `rust/src/queens/solver/iso_flat.rs` (~3199–3495 / report ~2404) |
| `M_HITKEY` dump / `ranklab` scorer | `rust/src/queens/solver/iso_flat.rs` + `ranklab.rs` |
| canon stack (B2) | `lex_min8`/`child_orient` in `incremental.rs`, `d4_bits` in `solver/mod.rs`, `hash128` in `tt.rs` |

## Build/Test
Standard (see project CLAUDE.md): `make -C rust release` / `test` / `clippy` (wrap noisy in
`~/.claude/bin/run-quiet`). Validation gate: `solver_lineage_agrees` + n=12/n=14 iso-flat distinct. n=16
runs in the `queens` tmux session, 8 GB TT (`QUEENS_TT_SLOTS=1000000000`), interleaved A/B via
`scripts/queens-ab.sh`. **Never two concurrent 8 GB-TT n=16 jobs (OOM).**

## Delegation Strategy
- The cheap offline tests (C1 distinct-canon, C2 treewidth, A probes-per-cut, C3 AND-skew) are isolated,
  measurement-only, no-hot-path-risk → **Opus sub-agent each, or run inline**; gate the box (one n=16-
  heavy job at a time).
- Tier-B/C builds (pre-warm pre-fill, getK canonical layer, treewidth DP) are architectural → **Opus**,
  one chunk per session, gated A/B per the harness.

## Progress
- [ ] Tier-A: ETC probes-per-cut tap → pc-gate → n=16 A/B (keep only if wall drops, node-identical).
- [ ] Tier-B1: n=16 sampled-HLL C confirm → (if GO) design idle-core eviction-recovery pre-fill.
- [x] Tier-B2: canon-skip oracle-sidecar upper-bound → **KILL** (skip-all +30.7% nodes/+15.1% wall; the unbounded re-exp cascade dwarfs the ~6–9% ceiling; exact-child0 can't separate the 0.2% recurring).
- [ ] Tier-C1: ★ getK distinct-`comp_canon` @ K=9–12 offline count → (if GO) build the value layer.
- [x] Tier-C2 PREMISE TEST: treewidth min-fill → **GO**, confirmed n=14 (med 11) AND n=16 (med 10, mass bands 7–9, tree-like). (`scratchpad/treewidth.py`)
- [x] Tier-C2 CONSTANT-FACTOR TEST → **★★ KILLED.** Subtree the DP replaces (alpha-beta + exact-availset memo, median 80–768 nodes at pc18–28) ≪ DP cost `3^(w+1)` (6.5K–43M); 0/358 graphs have subtree ≥ DP cost (max ratio 0.1). Premise true, not sufficient — tail is BREADTH not DEPTH; per-instance FPT can't pay. Tool: `rust/scripts/treewidth_dp_probe.py`. **Do not build the separator DP.**
- [ ] Tier-C3: ranklab AND-node proof-cost skew → (if ≥20%) prototype the scheduler.

## Handoff Notes

### Session 2026-06-22--7 — Tier-C2 treewidth DP KILLED (constant-factor go/no-go)
**Mode**: intent-based. Resumed `go treewidth`. The premise was already GO (low tw n14+n16); this
session ran the *constant-factor* go/no-go — the handoff's own stated remaining risk. Built + validated
a Node-Kayles solver (`rust/scripts/treewidth_dp_probe.py`; matches Dawson's-Chess path nimbers, and
win/loss⇔nimber≠0 on 300 random graphs). Regenerated an n=14 `QUEENS_HITKEY` dump (`/tmp/qhk-n14.bin`,
43.7K records). Measured per deep-tail graph: subtree-the-DP-replaces (alpha-beta + exact-availset memo)
vs DP cost `3^(w+1)`. **KILL: 0/358 graphs have subtree ≥ DP cost (max ratio 0.1); median subtree
80–768 at pc18–28 vs `3^(w+1)`=6.5K–43M.** Tail is breadth not depth ⇒ per-instance FPT can't pay (see
the C2 menu entry for the full first-principles writeup + redirect to the breadth levers C1 / incomplete-
canon). **Committed**: this handoff + `rust/scripts/treewidth_dp_probe.py`. **Then pivoted** (user:
"micro opt and perf profile, mult rounds of that") → the perf-loop below.

### Session 2026-06-22--7 (cont.) — C1/decompose DEAD, ★ skip18 WIN, root-ordering WEAK, graph-theory menu
**Mode**: intent-based. After the treewidth kill, the user steered a rapid multi-lever perf loop.

**C1 / decompose-leaf (the canonical component value-table) — DEAD vs the iso-dense default.** Built the
go/no-go tooling into `count --comps` (committed `6ce9508`): `comps_canon_census` (distinct `comp_canon`
per size + multiplicity), `pc_breadth_report` (per-pc distinct count + `R_deep`), `decompose_slice_report`
(deep fire rate by ncomp / `n_iso` / pc). **Findings (n14):** the deep tail (pc≥18 = 81% of cost) is
**single-component (0.0% fragmented at every band pc18–30)** ⇒ decompose-leaf has **zero fire** there;
getK≤17 already leafs every pc≤17 node (single or multi-comp); the value-table footprint **explodes above
k=9** (distinct `comp_canon` k10=990K→k12=2.4M at n14, mult→1.0). The only high-fire slice is **`n_iso≥1`**
(1.2% of nodes, 100% multi-comp, 90% all-comps≤10) but it's **shallow (pc 9–12)** and maps to the parked-
negative **ISO_STRIP** lever. My pitch ("treewidth enables the component table") was an ERROR — low
treewidth = tree-like *connected*, NOT fragmented; the two are orthogonal. **Breadth headroom `R_deep` DOES
grow with n** (n12→n14 ~4× at the mass bands: C=24 R_deep 5→33) — so per-position resolvers aren't
*obviously* breadth-dead at n16, but the deep tail's single-componentness kills decomposition specifically.

**★ skip18 — the WIN (committed `652697e`, gated off).** `QUEENS_SKIP18`: skip ALL TT work (canon key
`lex_min8`→`d4_bits`→`hash128` ≈ the ~6%-cyc #1-branch-mispredict step, + probe + put) for **pc==18 nodes
in the slow roots**. Safe & cascade-free because **pc==18 is the only band whose children are ALL getK
leaves** (pc≤17) ⇒ a re-expanded pc==18 node re-runs one bounded getK sweep, never an unmemoised subtree.
pc==18 is **~100% cold** (0.3% entry-probe hit, QUEENS_COLD/HITKEY). **n=16 A/B (12GB TT, 4 rounds): {18}
on the 2 slow roots = −3.1% wall; {18} all-roots = −3.6% total cyc / −2.5% wall (n-agnostic).** Verdict-
preserving (n12 distinct 1,060,823 exact; n14 verdicts). Knobs: `QUEENS_SKIP18_ROOTS=<sq,..>` (per-root,
thread-local set at root entry), `QUEENS_SKIP18_PCS=<set>` (pc bitmask, default {18}). **pc==18 is UNIQUE
— exhaustively swept:** every pc≥19 single band loses (its re-exp re-probes memoized pc==18 children = cold-
DRAM tax; {19} slow +1.6% cyc); contiguous ranges [18..22] +17% nodes; sets {18,20,22,24} +16% nodes;
{19..22} all wash-to-loss. The cascade compounds through any multi-band skip. **Promote-to-default is open**
(all-roots {18} is the n-agnostic candidate; needs the user's call).

**Root-ordering / scheduling — WEAK lever (committed `c107cd8`, gated off).** Telemetry
(`QUEENS_ROOT_TIMING`): at n16 the wall (25.3s) is set by **sq 0** (idx 28), which starts LATE (9.9s) and
runs SOLO the last 4.7s; sq 1 (idx 29) is longest-duration (19.3s) but ends at 20.6 < wall. Gated
root-reorder (`QUEENS_REORDER=1` + `QUEENS_FIRST_ROOTS=<sq,..>` + `QUEENS_FIRST_AT=<offset>`) + a pairwise
warmer report `(F)` in `count --roots`. **slow-first {0,1} = +9.4% wall / +4.1% nodes (LOSS): running the
slow roots cold forfeits cross-root TT warming; {0,1}@pos5-6 = WASH (+0.4% wall).** `count --roots` n14
(F): the warming is **DIFFUSE** — no root warms >~4% of the dominant's deep tail; the C=0.39 pool is spread
over ~13 roots (~3% each) ⇒ **no small set of "ideal warmers"**, realizing it needs ~all roots first ≈ the
current order. The current order is already ~optimal for warming; an early start forfeits it. Fan-position
is also cliff-bound (the first ~#workers roots all start ~together). **Untried:** a TIME-delayed dispatch
(start the slow root on a dedicated thread that sleeps a few s then launches — precise start-time control,
which fan-position can't give); likely a wash too given the diffuse warming, but the one variant not run.

**W8 disk cache — committed `73045d3`, MARGINAL.** `QUEENS_W8_CACHE=<path>` load-or-build-and-save of the
W0..W8 arena (opt-in, magic+ver+len+FNV-checksum). **Only ~0.18s** (prep 1.38→1.20s n14): the pext W8 build
is already fast; the prep floor is the **TT alloc** (eager-commit + MADV_COLLAPSE of the multi-GB table,
~6s at n16/17GB, NOT cacheable — it's the live empty TT). Cache 34MB; gzips **4.3×** (94%-win bit skew) but
raw loads fast enough. W8-overlap-with-search is moot (the search hits getK in ~ms ⇒ would block on W8 at once).

**★ value-bucketing (graph-theory #1) — NO-GO (committed `rust/scripts/value_bucket_probe.py`).** Full
census of all 36,676 distinct deep-tail graphs (pc18–28, exact nimber each). **No cheap value-invariant φ
beats the 3.4× iso ceiling at ≥99.5% member-weighted win/loss purity** — the frontier never enters the GO
quadrant: (V,E) merges 104× at 4.5% purity; degseq 1.40× at 94%; **1-WL separates all but 130 of 36,676
graphs (merge 1.00×)** so the only value-pure φ is iso itself (no gain). The deep-tail value is **high
structural entropy** — not captured by any O(m)–O(m²) invariant short of isomorphism. The breadth-merge
crack (#6a) is closed for cheap structural keys.

**★ graph-theory #2 (leaf/simplicial/dominated reductions) — NO-GO (`rust/scripts/reduction_probe.py`).**
Validated every candidate rule against exact nimbers: **dominated-vertex deletion is UNSOUND** (54–57%
nimber misprediction — the central hypothesis killed; deleting a vertex isn't a Node-Kayles move, it shifts
the mex). The only sound *novel* rule is **true-twin deletion** (N[u]==N[v]) but it fires on **≤0.4%** of
deep graphs. Leaf/simplicial structure is rare and vanishes with depth (≤13% pc18 → ~0% pc25+). Collapse
ratio **1.000×**, 0.20% of graphs reduce. Re-confirms the modular-reduction kill via a fresh path.

**★ graph-theory #5 (generalized structural-involution pairing) — NO-GO (`rust/scripts/struct_involution_probe.py`).**
Sound P-certificate (fixed-point-free involutive automorphism with v≁τ(v) ⇒ nimber 0; cross-checked: every
fire is nimber-0, 0 N-position false-fires). **Fires on 0.00% of deep P-positions** (only 6.67% pass even the
necessary precondition; the global automorphism constraint kills the rest). The deep-tail queen graphs are
**structurally rigid** (trivial automorphism groups) — same fate as the #9 geometric involution.

**⇒ The whole graph-theory / structural-reduction cluster is EXHAUSTED** (value-bucketing, leaf/simplicial,
structural-pairing all NO-GO; treewidth DP, C1/decompose, modular all dead earlier). The deep tail is
single-component, high-entropy, structurally rigid — **no cheap structural lever survives**. The breadth
crack (#6a, cheaper-than-iso merge) and the pairing crack (#6b) are both closed with evidence. What's left
is per-node throughput (skip18 ✓, fractional-band, getK evaluator) and the parked heavy levers.

**Graph-theory exploration (Opus sub-agent) — the menu for after.** Ranked, all with cheap offline tests
on `/tmp/qhk-n14.bin` + the validated nimber solver: **#1 value-bucketing** (key the TT by a cheap *game-
value* invariant φ — degree-seq / WL-hash / (V,E,#leaves,#simplicial) — merging by value not isomorphism ⇒
no 3.4× iso ceiling; GO if a cheap φ beats 3.4× merge at ≥99.5% value-purity — the highest-EV new lever);
**#2 leaf/simplicial/dominated-vertex reductions** (the abundant structures the dead twin/module probe never
measured); **#5 generalized structural-involution pairing** (the #6b shot — #9 died as ONE geometric
involution; a graph-structural one is unmeasured). Correctly killed: Watts-Strogatz (cost is position
*count* not path length), random-graph game invariants, twin-width/clique-width (re-walks the C2 kill).

**★ fractional-band skip — DEAD (gated `QUEENS_SKIP18_FRAC`).** Skip a `1/M` fraction of a cascading band
(pc19–25) by a pre-key raw-`avail` hash, keeping the rest memoised as anchors. **n=16 A/B (M=4 on pc19–25,
on top of the {18} default): +13.0% wall / +8.5% nodes / cyc/node −0.1%** — a clear LOSS. The fractional
*saving* is ~0 (cyc/node flat: 1/4 of pc19–25 canon-skips is negligible) while the re-exp/cascade dominates;
the orientation-specific anchors (TT is canon-keyed; a node is kept iff a kept orientation reached it) don't
dampen enough. So **skip18 = {18} is the complete, final lever** — every extension measured dead: {19}
marginal (−0.5% global / +1.6% slow), sets/ranges +8–17%, fractional +13%. Only the getK-floor band (pc==18,
children all getK leaves) skips cleanly. Code kept gated-off as documented substrate.

**SESSION NET:** the one win is **skip18 = {18}, now the iso-dense DEFAULT** (~−2.5% wall / −3.6% cyc,
n-agnostic, `QUEENS_SKIP18=0` reverts). Everything else explored is **dead/weak/marginal with committed
evidence**: treewidth DP, C1/decompose, value-bucketing, gt#2 reductions, gt#5 pairing, root-ordering,
W8-overlap, fractional-band. The deep tail is single-component / high-entropy / structurally rigid /
transposition-near-unique — the breadth crack (#6a cheaper-than-iso merge) and pairing crack (#6b) are both
closed. **What's left (un-attacked):** per-node throughput (the getK evaluator, ~35–44% of cycles — the
dominant remaining cost), the parked heavy levers (set-associative TT, BuRR archive, 1 GB hugepages,
nimber-decomposition node-count), and the open multi-session research (even-n pairing theorem from the proof
DAG). **NEXT:** the getK evaluator is the standing #1 cost and the least-explored throughput lever.

### Exploration handoff (2026-06-22) — FINAL (session end)
**Session**: 2026-06-22--6 (`a20b03dc-e462-4801-ab1b-88b683f9980b`)
**Completed**: (1) Expanded the QUEENS_RANK report (r2 column + E/node + ordering_loss) and built
`ranklab` (offline move-ordering A/B). (2) **RETIRED move-ordering** with a live n=16 A/B (the
reply-degree signal is real but nodes +0.2% / wall +115% — the loss is getK-leaf examinations, not
nodes; recurse-weighted ranklab confirmed). (3) Ran a multi-agent (Opus) hunt past the n=16 floor →
the lever menu above. Verdicts this session: **C2 treewidth premise GO (confirmed n=14 AND n=16, med
tw 10)**, **B2 canon-skip KILLED** (parked on branch), **B1 pre-warm GO** (`C≈0.39` n=14), **A ETC
pc-gate** identified (signal-free, ~−1.5–2%, node-identical), **C1 getK canonical layer** = the untested
standout. probe-skip / signal-ordering / signal-ETC / parallel-solve-ahead / decomposition all DEAD.
**Files**: this handoff (new) + `--21` pointer in the explicit-stack-frontier handoff. **All code/docs
committed; working tree clean** (main builds + `make test`/`clippy` green). Commits (main): `2ff41c8`,
`def4ff6`, `d007f93`, `32c9e19`, `316e8c3`, `ba6b717` (QUEENS_RANK + ranklab + recurse-weighted);
`d4d2461`, `c99127b`, `e369d2f` (this backlog + C2 n14/n16); `b71d8cd` (B2 KILL doc); `20354fd`
(`count --roots` directional C tool). **Branch `queens-canon-skip-experiment` (`5e6ca6b`)** = the
parked canon-skip M_CANONPROF/M_SKIP code (KILLED lever, gated/DCE off; do not merge).
**Instructions for next session (cheap-first):** (1) **C1 getK distinct-`comp_canon` @ K=9–12 +
multiplicity** — extend `count --comps`; the standout's go/no-go (attacks the 44%, W8 precedent). (2)
**A ETC probes-per-cut tap** (~10-line `M_RANK` ext) → pc-gate → n=16 A/B (bankable, node-identical).
(3) **n=16 sampled-HLL pre-warm `C` confirm** (HLL-per-root directional variant of the committed
`count --roots`). Then **build a winner**: the treewidth/separator DP (premise proven n14+n16,
research-grade) or the getK canonical layer (if C1 go). Box rule: one 8 GB-TT n=16 job at a time.
`scratchpad/treewidth.py` is the C2 tool (regenerate an n=16 `QUEENS_HITKEY` dump to re-run).
