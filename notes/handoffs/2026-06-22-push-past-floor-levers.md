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

**ETC pc-gate (signal-free). ★ KILLED 2026-06-23--3 — net-negative (nodes +2.0% / wall +3.6%; the
"node-identical" premise overlooked win-child reuse / eviction protection). See Progress + the session
note below.** Two ETC sub-agents (signal-guided + "train a better ETC") converged on
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
- [x] ★★ **Cross-root killer replies (`QUEENS_KILLER`) → LANDED (gated, default off): n=16 record
  23.44s → 14.60s (−38% wall / −41% nodes), cyc/node flat.** The dynamic ordering-family lever the
  static-predictor kills never tried. Promote-to-default = open. See session 2026-07-01--13.
- [x] `QUEENS_DENSE_HUGE` dense-arena MADV_COLLAPSE → LANDED default-on (~−0.5% cyc/node). BOLT /
  K18+skip{19} / no-SMT / 20-thread-asymmetric all measured DEAD (same session).
- [x] Tier-A: ETC probes-per-cut tap → pc-gate → n=16 A/B → **★ KILLED (net-negative).** Tap (`M_RANK`
  `etc_pr`/`pr/cut` columns) confirmed the shape exactly — ETC cuts ~0–5% of nodes in pc≤28 (`pr/cut`
  300–5000 = near-pure waste; ~208M of 1.32B probes), flips to 12–35% cuts at pc≥29. But the gate A/B
  (`QUEENS_ETC_GATE=1`, pc<29, 4-round) = **cyc/node −1.3% (probe saving real) BUT nodes +2.0% / total
  cyc +0.7% / wall +3.6%.** The "node-identical" premise was WRONG: the cold-mass probes' value is the
  **win-child reuse** (`wv==1` eviction-protection skip), the SAME probe as the cut-probe ⇒ ungateable.
  Kept gated-off as substrate; one untried angle = larger TT (less eviction). `etc_probes` tap kept.
- [x] Tier-B1: eviction-recovery pre-fill → **CLOSED by regime change (2026-07-01--15, no build).** The
  killer cut collapsed the TT working set to ~8–9% full and the --13 TT-size sweep measured 2 GB ≈ 12 GB
  wall (nodes flat) ⇒ eviction costs ~nothing ⇒ there is no evicted-value pool worth re-filling. The
  pre-killer C≈0.39 measurement no longer describes the production regime.
- [x] Tier-B2: canon-skip oracle-sidecar upper-bound → **KILL** (skip-all +30.7% nodes/+15.1% wall; the unbounded re-exp cascade dwarfs the ~6–9% ceiling; exact-child0 can't separate the 0.2% recurring).
- [x] Tier-C1: ★ getK distinct-`comp_canon` count → **MEASURED at n=16 (`QUEENS_KPROBE=2`) → NO-GO,
  closed (2026-07-01--15).** Gate passes only at pc9 (170K canonical keys, 289× multiplicity) where the
  ~200-cyc get9 is cheaper than any canon; pc12+ (the cycle mass) = 50–81M keys at 1.2–1.9× = the
  dead-memo regime. The treewidth anti-correlation again. See the --15 session note.
- [x] Tier-C2 PREMISE TEST: treewidth min-fill → **GO**, confirmed n=14 (med 11) AND n=16 (med 10, mass bands 7–9, tree-like). (`scratchpad/treewidth.py`)
- [x] Tier-C2 CONSTANT-FACTOR TEST → **★★ KILLED.** Subtree the DP replaces (alpha-beta + exact-availset memo, median 80–768 nodes at pc18–28) ≪ DP cost `3^(w+1)` (6.5K–43M); 0/358 graphs have subtree ≥ DP cost (max ratio 0.1). Premise true, not sufficient — tail is BREADTH not DEPTH; per-instance FPT can't pay. Tool: `rust/scripts/treewidth_dp_probe.py`. **Do not build the separator DP.**
- [ ] Tier-C3: ranklab AND-node proof-cost skew → (if ≥20%) prototype the scheduler.
- [x] Perf telemetry + saturation deep-dive (--2 below) → solo-tail starvation is BRIEF; search saturates NOTHING (spare MLP) ⇒ near-floor confirmed from a fresh angle.
- [x] ★ 2nd-ply refutation lever explored → ORACLE ceiling sq-0 −72% / full-run −13%, but the predictor is CLOSED (degree/overlap/size/symmetry-defect all fail; split + par-ord DEAD). One untested idea left: residual-stabilizer 2nd-ply orbit-dedup on axis-roots.
- [x] **★ residual-stabilizer 2nd-ply orbit-dedup → DEAD (2026-06-23--3, code-read + re-exp evidence, no build).** The D4-canonical TT key already IS the orbit-dedup: 2nd-ply nodes are keyed by `node_key` = `lex_min8` over all 8 dihedral orientations (transpose ∈ D4), and `par_wins_inc` probes (iso_flat.rs:4599) AND puts (:4808) under that key ⇒ a transpose-mirror is a TT HIT, not a recompute. n=14 re-exp ≈ 1.02× confirms no mass mirror-recompute. Orbit-dedup would at most save the mirror's canon-key build + probe (~a few cyc) for the ~100 axis-root 2nd-ply pairs = negligible vs 307M nodes. **The last untested node-count idea is closed.**
- [x] 4-agent math/instruction/discipline sweep (--2 below) → near-floor; LANDED `w17_induced`→field −0.55% (clean balanced A/B).
- [x] **Brainstorm B: getK code-keyed memo → ★ NO-GO (2026-07-01--15, `QUEENS_KPROBE` probe, no build).**
  n=16: 780.7M getK entries / 605.1M distinct codes = repeat 1.29× (22.5% infinite-memo ceiling);
  512 MiB sim memo hits 18.5%, 8 MiB 13.6% ⇒ near-uniform code stream, no hot set; best-hit bands are
  the cheap sweeps. Closes the memo/dedup family (with L0, frontier-dedup, DECPROBE). Probe kept gated.

## Handoff Notes

### Session 2026-07-01--15 — brainstorm candidate B executed: getK code-keyed memo = NO-GO (probe evidence); the memo/dedup family is now fully closed

**Built `M_KPROBE` (`QUEENS_KPROBE=1`, gated substrate on main, production byte-identical off)** — an
M_ORD_W measurement twin (like DECPROBE): at every getK entry (the descent's pc 9..=DK cheap arms) it
rebuilds the labelled `(pc, code)` key exactly as the `wN_get` builders pack it (`kprobe_code`, the key a
code-keyed getK memo would use), folds it into a per-band HLL (p=14), and probes two shared simulated
direct-mapped memo tables (8 MiB / 512 MiB, `hash128` route+fp tags, always-replace). Report post-solve.

**Full n=16 probe run (12 GB TT, DK=17; searched 178.8M nodes ≈ the production count, SECOND):**

| pc  | entries | distinct | repeat× | hit% 8 MiB | hit% 512 MiB |
|-----|---------|----------|---------|------------|--------------|
| 9   | 47.5M   | 33.9M    | 1.40    | 9.4%       | 16.2%        |
| 10  | 88.4M   | 69.6M    | 1.27    | 12.1%      | 16.1%        |
| 11  | 98.0M   | 74.5M    | 1.32    | 16.1%      | 21.2%        |
| 12  | 93.2M   | 64.3M    | 1.45    | 20.3%      | 27.0%        |
| 13  | 100.6M  | 69.9M    | 1.44    | 19.4%      | 25.9%        |
| 14  | 107.2M  | 81.9M    | 1.31    | 15.1%      | 20.4%        |
| 15  | 101.7M  | 83.6M    | 1.22    | 10.8%      | 14.7%        |
| 16  | 84.1M   | 73.0M    | 1.15    | 7.6%       | 10.4%        |
| 17  | 59.9M   | 54.5M    | 1.10    | 5.7%       | 7.8%         |
| all | 780.7M  | 605.1M   | 1.29    | 13.6%      | 18.5%        |

**Reading — NO-GO, do not build the memo:**
1. **No small hot set.** 605M distinct codes under 780.7M entries; an 8 MiB table catches only 13.6%
   ⇒ the code stream is near-uniform, the exact "if ~uniform ⇒ close the lever, DRAM latency eats it"
   arm of the W9-table Fermi (the user's skip call, now measured and vindicated at every K).
2. **The ceiling is too low.** Infinite-memo dedup = 22.5% of entries; realizable (512 MiB, would
   contend with the TT for DRAM/L3) = 18.5%. getK ≈ 69% of cycles ⇒ gross ceiling ~13% of cycles at
   ZERO probe cost — and the real probe is a per-entry hash + an unprefetchable DRAM-scale load (no
   lead: the code is built immediately before the sweep needs it) + a store on the 81.5% misses =
   27M/s cross-core write traffic, the M_DHIST/L0 failure shape.
3. **No band gate rescues it.** The best-hit bands (pc 11–13, 21–27%) are the *cheap* sweeps; the
   expensive deep bands (K=16/17, where the getK cycle mass lives) hit only 7.8–10.4%.

Cross-check: entries pc 9..16 = 720.8M vs DECPROBE's 744M getK nodes — consistent within node noise.
**The whole memo/dedup family is now closed with converging evidence:** L0 probe-cache (+6% cyc/node),
frontier dedup (+94% nodes), component decomposition (0-3% ≥2-comp), and now code-keyed memo (ceiling
22.5%, uniform). Probe cost: the tapped run is 28.9s vs 13.4s clean (~2.1×, cold-tap only).

Gates green: `make test`, n=12 iso-flat distinct 1,060,823 exact, n=14 second / ≈29.2M / 1.02× re-exp.

**(cont.) Tier-C1 (canonical getK value layer) — the designed go/no-go MEASURED: NO-GO, closed.**
Extended the probe to `QUEENS_KPROBE=2`: per getK entry also fold the CANONICAL key
(`each_comp_canon`, the measurement-exact WL/IR certificate — the machinery graph.rs built for
exactly this gate; components combined order-independently) into a second per-band HLL. Full n=16
run (179.7M nodes ≈ production, SECOND, 2m43s — the canon tap costs ~4 µs/entry, measurement only):

| pc  | entries | canon-distinct | canon-mult× | (labelled distinct) |
|-----|---------|----------------|-------------|---------------------|
| 9   | 49.2M   | 170,045        | 289.3       | 34.8M               |
| 10  | 90.5M   | 2.66M          | 34.0        | 72.6M               |
| 11  | 98.6M   | 20.7M          | 4.8         | 74.9M               |
| 12  | 92.0M   | 49.7M          | 1.9         | 63.3M               |
| 13  | 98.7M   | 65.7M          | 1.5         | 68.7M               |
| 14  | 105.7M  | 77.6M          | 1.4         | 79.4M               |
| 15  | 100.9M  | 81.4M          | 1.2         | 82.5M               |
| 16  | 84.0M   | 72.0M          | 1.2         | 72.6M               |
| 17  | 60.3M   | 53.5M          | 1.1         | 53.5M               |
| all | 779.9M  | 423.4M         | 1.8         | 603.2M              |

**Reading — the C1 gate ("distinct fits L2/L3 AND multiplicity ≫10×") passes ONLY at pc9
(170K keys ≈ 1.4 MB, 289×; pc10 borderline: 2.7M ≈ 21 MB, 34×) — and there the constant factor
kills it:** a pc9 hit saves only the ~200-cyc get9 (code build + sweep), while the lookup must
CANONIZE the 9-vertex graph first — the measurement-exact canon ran ~4 µs here, and even a tuned
small-graph canon is ≫200 cyc (the iso-key cost lesson: canon ≈ 100× the D4 key). Where a hit
would save real work (pc12+, the thousand-cycle sweeps ≈ the getK cycle mass), the canonical set
is 50–81M per band (DRAM regime — the dead-memo footprint) at multiplicity 1.2–1.9. **The same
anti-correlation as the treewidth kill: the gate quantity passes exactly where the work is too
cheap to be worth replacing.** Bonus sizing: the iso merge on tail graphs is weak — 603M labelled
→ 423M canonical = 1.42× (the ~3.4× figure was whole-board, does not transfer), which also sizes
the "realizable-code compaction" idea from the DECPROBE close (item (a): now measured, dead).
**Do not build the canonical value layer. The Tier-C1 box is closed** — and with it every memo
flavor over the getK tail: labelled (kprobe L1), canonical (kprobe L2), component-Grundy
(DECPROBE), frontier (L0/wave), exact-key skip (canon-skip B2).

**(cont. 2) Brainstorm C (loss-tail locality reorder) — closed on the napkin, mechanisms absent:**
(1) same-band grouping of getK children (the W*_MASKS-table locality a reorder would create)
already exists — the dynamic sort key IS the child popcount (`sort_moves_by_degree`,
iso_flat.rs), ascending ⇒ same-pc children are already adjacent; (2) entry-probe DRAM latency is
already off the critical path (hash-carry prefetch; tt.rs = 0.13% of cache misses per the
2026-07-02 key-cost split); (3) recurse-probe MLP batching already happens where it pays (the ETC
batch, pc≥29). The 32% loss-node exam mass is getK compute + child subtree expansions — neither
is sibling-order-addressable. And the reorder is only node-count-free at TRUE losses, which need
the loss-predictor that already failed (--2). **E (mirror oracle) stays an unspecified label** —
its plausible form (2nd-ply orbit/mirror dedup) was already closed by the residual-stabilizer
code-read (--3: the D4 canon key IS the orbit-dedup).

### Session 2026-07-02 — micro-opt + profiling round: getK mask-prefetch + TABLE_OFF mask = cyc/node −2.1% (LANDED)

**Profiling (fresh miss attribution on the 13.77s default stack, n=16, 24t):**
- **Cycles** (from the SMT-close P3 record): getK/kernel ≈ 94% — `wins_inc` 18.6, `sort_moves_by_degree`
  6.9, `DenseW8::get9..16/get_dyn*` 45.4, `w9..w16/w_wide_get` 23.5; canon/TT/par ≈ 3.3.
- **Branch misses** (7.4 B/run): `wins_inc` 20%, the `wN_get` family ≈ 46% combined — the getK sweeps'
  data-dependent child-outcome early-outs (the known at-floor α-β territory; counting sort + skip18
  already took the orderable sites).
- **Cache misses** (L1d-level, 4.5 B/run): `wins_inc` 30.6% (the TT probes), then **`get13`–`get16` +
  `get_dyn_wide` ≈ 39%** — the deep layers' induced-masks tables (`W*_MASKS.1`, 2^K×16 B = 128 KB–1 MB;
  wide K=17 3 MB) miss L1d/L2, and that load heads each sweep iteration's serial chain
  (mask → pext → nested evaluator).
- **Annotate** (`get10` loop): heat on the arena-load→`bt` chain and the loop-back `jb`, plus a live
  `cmp/jae panic_bounds_check` pair per iteration — the `TABLE_OFF[cpc]` slice check.

**The patch (unconditional, no gate — functionally a no-op per node):**
1. **One-ahead mask prefetch** in the `get12`..`get16` sweeps + `get_wide` (K=17..20): while child j is
   evaluated, `_mm_prefetch` child j+1's `W*_MASKS.1[nchild]` entry (address computable from
   `order`/`adj` alone, ~5 ALU ops; an early cutoff wastes ≤1 line).
2. **`TABLE_OFF` padded to 16 entries + `k & 15` index** in `DenseW8::get` — provably in-bounds, drops
   the per-iteration bounds-check branch from every dense-loop bottom (the loops are frontend-bound).

**A/B (4-round interleaved, 12 GB TT, two-binary wrapper on `QUEENS_UOPT`): cyc/node −2.1%
(5894 → 5768, the on side lower in every round; spread −1.3..−3.4%), total cyc −3.9%, wall wash
(+0.7%, inside the ±1.5s killer-race band; nodes −1.8% = same noise).** In the historical "real but
small" micro-opt band (cf. the flat-arena −2.0%). Gates: `make test` all pass, n=12 iso-flat distinct
1,060,823 exact (1.25× re-exp), n=14 second / distinct ≈29.2M / re-exp 1.02×.

**Not pursued (measured/judged too small):** get9/10/11 arena-word pipelining (their masks are
L1-resident, W7 is an L2 hit, est ≤0.3% for real I-cache bloat risk in the frontend-bound loop);
2-ahead prefetch depth (nested-evaluator latency already covers one-ahead); first-child prefetch
before the degree sort (child unknown pre-sort). The branch-miss mass (46% in the sweeps' early-outs)
is data-dependent boolean structure — no orderable site left.

**(cont.) Rounds 2+3 — ★ vpcompressb `verts_of` (−4.3%) + root-adj carry (−2.5%): NEW RECORD 13.43s.**
- **Round 2 — `vpcompressb` `verts_of` (`a0e2979`): cyc/node −4.3% (every round), total cyc −4.0%,
  wall −6.2%.** The serial `tzcnt`/`x&=x-1` scatter (~9% of cycles, srcline) → AVX512-VBMI2
  `_mm512_maskz_compress_epi8` of a 64-aligned identity byte LUT per avail word + a masked byte
  store of exactly `popcount` bytes (order-preserving ⇒ byte-identical output; masked-out lanes
  can't fault). Box confirmed `avx512_vbmi2` (Strix Point Zen5; 256-bit double-pumped is fine here).
- **Round 3 — root-adj carry into getK (`2b7ebac`): cyc/node −2.5% (every round), total cyc −4.5%,
  wall −2.7%.** `w10..w16_get` already compute every labelled adjacency row (`adj_row_pext`) for
  the code pack; `getN` re-derived the same rows via `extract_adj(128)`. Split into extract wrapper +
  `getN_adj` core; the root passes `row = packed & !(1<<i)` (+ fused iso bits) — att masks are
  self-inclusive, the extract row is self-gapped, so one `andn`+store per vertex replaces a pext +
  gap-reinsert per row. Nested child calls keep the extract path. (Beat its ~1% napkin — roots are
  a bigger share of getK entries than guessed.)
- **Cumulative this session: cyc/node 5894 → 5428 ≈ −8% on top of the 13.77s stack. NEW RECORD:
  two clean default-stack runs 13.47s / 13.43s (178.8M / 178.6M nodes, second, 12 GB TT);
  interleaved singles as low as 12.7s.**
- **W9 full-table lever — SCOPED, DO NOT BUILD BLIND:** 2^36 bits = 8 GiB (memory now fits: TT
  valid down to 2 GB in the killer regime; ~2 min parallel one-time build, disk-cache like W8;
  W10 = 4 TB ⇒ K=9 is this road's end). BUT the corrected Fermi: an unprefetched DRAM load
  (~300–400 cyc) LOSES to `get9`'s ~150-cyc compute; mid-sweep `get9` calls (deg-1 children) have
  too little prefetch lead to hide it. The lever only pays if the LIVE get9-code working set is
  small enough to sit L2/L3-resident (plausible — the killer regime collapsed the TT working set
  to ~8%, transposition-saturated tail ⇒ the leaf-code set may be similarly skewed). **P0 before
  any build: a gated probe (HLL + top-k frequency skew of get9 codes over an n=16 run).** If the
  hot set ≲ tens of MB ⇒ build it; if ~uniform over 8 GiB ⇒ close the lever, DRAM latency eats it.
- ~~Remaining kernel candidates~~ **both measured WASH and reverted (4-round A/B, built together):
  w9 pext-build + get9 root-adj AND wide-layer (K=17..20) root-adj = cyc/node +0.3% with per-round
  signs flipping (−1.1/+1.0/+0.9/+0.6) — no consistent direction, unlike the three every-round wins.**
  Reading: w9's scalar 36-bit build ≈ the pext build + row capture (the extract saving cancels), and
  w_wide's ≈2.2% share is sub-noise. Instructive negative: the root-adj trick only pays where `packed`
  is a free byproduct AND the layer is fat (w10..w16); reverted by re-edit, tree byte-identical to
  `2b7ebac`, gates re-verified before the A/B (all suites, n12 exact, n12/n14 iso-dense second).
- **W9 full table: SKIPPED (user call)** — the conditional Fermi (DRAM ≥ compute unless the hot
  set is L3-resident) wasn't worth the probe + build risk.

**(cont. 2) Tail-structure question (user) → `QUEENS_DECPROBE` run: the getK tail has NO
decomposition structure — the nimber-decomposition lever is CLOSED for this architecture.**
Full n=16, 744 M getK nodes (pc 9..16): mean #components 1.003–1.13; **≥2-component rate falls
12.5% (pc 9) → 0.3% (pc 16), and "all comps ≤8" is 12.46% at pc 9 (where get9 is already the
cheap direct layer) then 1.15% → 0.00% for pc ≥ 13.** The tail's conflict graphs are 97–100%
single connected components — queens' 4-line cliques keep 13+ scattered squares coupled. So a
Grundy-valued W8 table + flood-fill XOR shortcut has essentially no nodes to fire on (and the
same connectivity explains the earlier module/twin deaths — the whole structural-reduction
cluster is now closed with three independent measurements: modules 0%, twins →0%, components
→1.0). Trend is monotone ⇒ pc 17 (untapped, w_wide) ≈ 0.2%, pc ≥18 recurse nodes rarer still.
The old Lever-B "−74% nodes at cap 12" predates the W_K layers (whole-board nodes, different
node population) — it does not transfer. **What structure remains in the tail:** (a) the
*realizable-code* set (queen-induced ⊂ all labelled graphs — a table-compaction/cache-residency
play, not a math shortcut; unsized); (b) code-frequency skew (memo angles = the measured-negative
L0 cousin); (c) nothing else — the boolean-decomposition cap on the sweep math stands.

**(cont. 3) `QUEENS_RANK` re-run in the 13.43s stack (algorithmic-brainstorm gate): the DEEP
ordering is NOT exhausted.** 185.2M expanded OR-nodes, E = 5.70 children examined/node,
1.056 B child-exams total: ETC 3.2% / r0 23.7% / r1 16.8% / r2 11.7% / **r≥3 = 37.1% of nodes
(mean rank ~8)** / nocut (true losses, unavoidable full scans) 7.6%. **ordering_loss = 555M
avoidable child-exams = 52.6% of all child-exams** (the perfect-order ceiling). The depth-1/3/5
killer family is spent, but the deep kernel below ply 5 orders by current-degree ONLY — no
learned signal. This is the measured headroom behind the deep-history-heuristic idea (next-session
candidate A). Loss-node share of exams ≈ 32% (0.076 × 23.91 / 5.70) — the move-order-SAFE
locality-reorder ceiling (candidate C). Explored/expansions ratio re-confirmed 5.60 (1.062 B / 189.7M).

**(cont. 4) Brainstorm candidates A + D executed — both NEGATIVE/CLOSED with evidence; B queued.**
- **A: deep cutoff-history tiebreak (`M_DHIST`, `QUEENS_DHIST=1`, gated substrate kept on main) —
  NEGATIVE AS BUILT (4-round A/B): nodes −2.7%, cyc/node +19.5%, wall +16.6%.** Build: per-square
  `DEEP_HIST[256]` relaxed tally at every fused-descent cutoff + a node-locally-normalized 2-bit
  bucket as the tiebreak within equal-degree groups (composite 4n-key counting sort; verdict
  SECOND every round; control byte-identical — off-side cyc/node ≈ baseline). TWO findings:
  (1) the COST is the sort's per-move reads of the hot cross-thread tally lines (writes ~10M/s ⇒
  every read hits M-state lines elsewhere) — fixable (per-subtree snapshot / ~1s-refresh rank
  table) but pointless because (2) the SIGNAL is weak: −2.7% nodes vs the 52.6% child-exam
  ceiling — within an equal-degree group the global square identity barely predicts the cutoff;
  degree already carries the deep ordering. The rank report's 52.6% headroom is real but needs a
  CONTEXT-keyed signal (parent pc-band × square, or parent-key-local replies à la killers) —
  untried, dampened expectations. Do not re-try the global form.
- **D: root scheduling — CLOSED, zero slack (root-timing audit):** the 5 slow roots (11.4–11.5s
  each) all START at 0.9s (right after the elder); longest root = 93% of total wall, solo tail
  0%. The wall IS the slowest root's span; no permutation can help — only cutting inside the
  slow roots (killers territory). Bonus: the audit run itself searched in **12.43s / 175.7M
  nodes** (cold timing tap, production-identical path) — fastest single seen on the new stack.
- **B (getK entry repeat-rate HLL probe → code-keyed getK memo) — still queued, the one open
  brainstorm item.** C (loss-tail locality reorder) and E (mirror oracle) remain unprobed ideas.

**TT-key cost split (user question; profiling build, srcline-bucketed cycles, full n=16 default run):**
the whole key pipeline ≈ **9% of cycles**, and it is CANON, not hashing:
- **canon ≈ 7.5%** — `child_orient` (incremental 8-orientation images, 7 four-word and_nots/node) +
  `lex_min8` (7 `Bits` compares; its `cmp.rs` share ≈ 2.0%);
- **`hash128` + TT get/put internals ≈ 0.7%**, `mtt_*` wrappers 0.6%, `d4_bits`/`graph_bits` 0.2%;
- **prefetch instructions 2.1% of cycles / 8.5% of cache misses** — the hash-carry prefetch already
  absorbs the probe's DRAM miss off the critical path (`tt.rs` shows only 0.13% of cache misses).
Design consequence, recorded: the flat TT has NO pointer-following (canon key → `hash128` mulx →
direct slot index → one 8 B load, fp in-slot); "index by a cheap fn of the exact key" would only
remove the ~0.7% hash arithmetic while still needing an in-slot discriminator (the map is lossy),
and removing CANON keys forfeits the D4 transposition merges (the orbit-dedup close proved
mirror-hits are real TT traffic; skip18 showed even the best no-TT band only bought −3.6% cyc and
every extension measured dead). A perfect/injective index needs the key set a priori — that is the
BuRR archive idea (read-only, capacity lever), not a live-table option. Ceiling on ANY key-cost
lever: ≤9%; the only real target inside it is canon (7.5%), and the cheap-canon alternative
(iso key) is banked at 100× the D4 key's cost.

### Session 2026-07-01--13 (cont.) — killer PROMOTED TO DEFAULT + deep-ply killers + ETC-gate default: RECORD → 13.77s; the 10s push status
**User directive**: promote `QUEENS_KILLER=4` to default; keep hunting toward 10s.

**★ DEFAULTS PROMOTED (iso-dense only — iso-flat/iso-window keep the base-0 control, so the exact
`--distinct` gate semantics are untouched; `QUEENS_FAST=0` reverts the whole stack):**
1. **`QUEENS_KILLER=4`** (the record lever, `=0` reverts).
2. **`QUEENS_KILLER_DEEP`** (NEW this session, default ON): killer jumps extended to the deeper odd
   (prove-win) plies of the parallel upper tree — depth 3 and 5, one shared 256-square table per ply
   band (below `min_avail` the deep kernel takes over, so deeper plies never reach it). **n=16 A/B
   on top of killer=4: nodes −7.5% / total cyc −7.2% / wall −4.5%, cyc/node flat.** `=0` reverts.
3. **ETC pc-gate (batch-probe off below pc 29) — the --3 kill REVERSED in the killer regime:** the
   killer cut leaves the TT ~7.5–9% full, so the eviction-protection value that made the gate
   net-negative (+2.0% nodes then) is gone. **A/B: cyc/node −1.2% (every pair), total cyc −1.8%,
   nodes −0.6%.** Now default-on for iso-dense (`QUEENS_ETC_GATE=0` or `QUEENS_ETC_PC` overrides).

**NEW RECORD (full default stack, clean box): 13.77s / 179.3M nodes at a 12 GB TT** (two runs
13.76/13.77; 17 GB runs land 14.9–16.0 — at ~8% fill the big table only adds page mass, so **12 GB
is now the better size**). vs yesterday's 23.44s = **−41% wall / −42% nodes**; vs the pre-killer
default ≈ −52%.

**10s push — measured DEAD/wash this round (all env-only unless noted):**
- killer_k=8 (more jump budget with deep on): 16.3s single — worse. k=1/2/4 remain within noise.
- `QUEENS_NO_ELDER` (fan all roots at once, small code change, gated): 15.8/16.6s vs 14.4 — the
  elder still pays; it is ALSO the first killer publisher now (double role).
- `QUEENS_WARM_RESTART` re-test (would seed killer tables in the warm phase): 17.8s — the 2s warm +
  restart overhead dwarfs the seeding value at a 14s wall.
- `QUEENS_PAR_MIN_AVAIL` 64 / 128: 16.0 / 14.9s — the 96 default stands. `QUEENS_PAR_DEPTH=4`: wash.
- skip bands {18,19} (the last untested set): 15.2s single — negative in the killer regime.

**Where the wall is NOW (root-timing under the new defaults):** 30/36 roots refute at rank 1
(depth-1 ordering is maxed out); the wall = **4–5 slow roots tied at ~12.4s, ending together** —
their cost is the refutation-*proof* mass (deep AND fans → the pc 13–21 transposition-coupled tail),
i.e. the territory the pre-killer sessions exhausted. The killer family is spent at ply 1; the
depth-3/5 tables banked their −7.5%. The late-refuting stragglers (rank 15/18, concurrent — their
refuters publish only when they themselves finish) end before the wall, so they don't bind.

**Open levers toward 10s (ranked):** (1) **1 GB hugetlbfs TT pages** — the measured ~8 dTLB
misses/node are the TT's; needs boot-time reservation + a `MAP_HUGETLB` path (~2–4%); (2) the
**parked heavy levers** (set-assoc/compact-slot TT — per-probe DRAM; BuRR) — note the regime change:
TT now ~8% full at 12 GB, so capacity arguments shrink but latency ones stand; (3) **per-thread IPC**
— the 12-core no-SMT run showed cyc/node −21% locked behind thread count (any lever that raises
per-thread IPC without dropping threads); (4) killers at n=18 (port to `queens-n18`).

**Gates (all green):** n12 iso-flat distinct 1,060,823 exact (killer scoped away from iso-flat ✓),
n14 second, `make test` 58 pass, clippy clean.

### Session 2026-07-01--13 (cont. 2) — user-directed: lever 3 (per-thread IPC) and lever 2 (assoc TT), both CLOSED with evidence
**Lever 3 (per-thread IPC) — the cheap probes are all null; the 21% SMT reserve needs a
restructure, not a knob:**
- **TT-size sweep** (the no-boot-change shot at the TT dTLB: 4 GB on 2 MB pages fits the L2 TLB):
  12 GB ≈ 13.8–14.4s, 6 GB 14.8, 4 GB 15.1, **2 GB 13.8** — all inside the ±1.5s killer-race noise
  band. No resolvable dTLB win, but **TT size is now a free parameter down to ~2 GB** (8→13% fill;
  the killer cut collapsed the working set) — load-bearing for n≥17 memory planning.
- **Fresh stall profile (new defaults, 14.1s run):** IPC 1.34; branch-misses 40.7/node ≈ ~12% of
  cycles (data-dependent α-β early-outs + cpc dispatch — the at-floor getK territory; counting
  sort + skip18 already took the orderable sites); L1i misses 5.2/node (modest); dTLB 8.9/node
  (unchanged, TT-resident). Raw AMD `de_dis_dispatch_token_stalls*` events not accepted by this
  kernel's perf.
- **`QUEENS_DENSE_K=16` re-sweep in the killer regime** (smaller hot evaluator footprint):
  17.0s / +45% nodes — W17 stays the ceiling; the killer regime did not move the crossover.
- Verdict: the reachable IPC probes are exhausted; converting the measured no-SMT −21% cyc/node
  reserve requires complementary-phase thread scheduling (research-grade, multi-session).

**Lever 2 (set-assoc TT) — DEAD in the killer regime (definitive 4-round A/B):** flat-assoc
(`QUEENS_TT_ASSOC=1`, the band-free bucket mode on main) = **cyc/node +4.9% (every round), nodes
+0.7%, total cyc +5.6%, wall +2.7%.** Both of its historical payoffs evaporated when the killer
cut collapsed the TT working set to ~8% full: there is no eviction pressure to protect against
(nodes flat) and no capacity squeeze — only the bucket probe's extra instructions remain. The
parked `queens-tt-assoc-buckets` branch stays parked (its n=18/oversubscribed rationale would need
re-checking post-killer too, since killers should shrink that working set as well).

**Record unchanged: 13.77s / 179.3M @ 12 GB** (six more default-stack runs this round: 13.8–16.0,
killer-race + thermal noise). Next real levers remain: 1 GB TT pages (boot), killers-at-n=18.
**(2026-07-02 update: complementary-phase SMT scheduling = CLOSED — P1 re-baseline showed the
reserve intact (cyc/node −20.6% at 12t) but P2 proved the contention pure instruction-mix (two
independent 12t processes on sibling sets contend identically to one 24t process) and P3 found
no counterweight phase (canon/TT ≈ 3.3% of cycles vs getK/kernel ≈ 94%) ⇒ no placement/routing
scheme can convert it; the reserve is only reachable by shrinking the getK instruction mix
itself. Full numbers: [SMT handoff](2026-07-01-smt-complementary-scheduling.md).)**; BOLT/K18+skip19/no-SMT all measured dead; dense-arena MADV_COLLAPSE banked; TT-dTLB + THP-disable diagnostics
**Session**: 2026-07-01--13. Catalyst: user asked to break the 23.44s floor, target sub-20, "get creative."

**★★ THE WIN — `QUEENS_KILLER` (cross-root killer replies at the 2nd ply), gated, default OFF
(promote-to-default = open, needs the user's call).** The one ordering-family lever every prior
predictor hunt skipped: not a *static* signal (degree/overlap/symmetry-defect — all dead) but the
*dynamic* killer heuristic — when any root's depth-1 sequential `.any()` finds its refuting reply,
publish that square to a global tally (`KILLER_HITS[256]`, relaxed atomics); every root's depth-1
loop re-reads the table **each iteration** (the slow roots run tens of seconds — killers published
mid-loop land) and jumps to the hottest not-yet-tried killer, capped at `QUEENS_KILLER=<k>`
speculative jumps, remaining moves in the existing order. Verdict-preserving by construction (any
permutation of an `.any()` over the same reply set). ~60 gated lines in `iso_flat.rs`
(`killer_loop`, mirrors `sched_loop`; production path byte-identical with the flag off).
- **n=16 interleaved A/B (4 rounds, 12 GB TT, k=4): nodes −37.6% · cyc/node +0.6% (the reorder is
  FREE) · total cyc −37.2% · wall −43.3% (29.0s → 16.5s mean).** SECOND every round; gates green
  (n12 iso-flat distinct 1,060,823 exact; n14 ≈29.2M re-exp 1.02×; `make test` 58 pass; clippy clean).
- **Record runs (clean box): 17 GB TT 14.60s / 182.7M nodes** (prior record 23.44s / 307.6M = −38%
  wall / −41% nodes); runs range 14.2–16.8s (killer propagation is a race between roots ⇒ its own
  noise term). 12 GB with root-timing on: 14.24s. **TT now only 7.5–9% full — the killer cut
  collapsed the working set**; TT size barely matters (8.6 GB ≈ 17 GB wall).
- **Why it works (measured, `[killer]` log under `QUEENS_ROOT_TIMING`):** refuting replies cluster
  HARD — the center squares (119/120 at n=16) refute ~23/36 roots at rank 1 (static degree-order
  already tries them first), but the slow roots — exactly those whose first queen attacks the
  center — used to burn 9–18 full non-refuting subtree proofs (ranks 17/18/15/14/9…) before finding
  their off-center refuter (sq 90 et al). Those same off-center squares refute *several* such
  roots ⇒ the first one to finish publishes, the rest jump. With killers on, nearly every root
  refutes at rank 1 after ≤1 jump. This is the constructive payoff of the fresh root-timing
  measurement: the wall was ONE root's sequential 2nd-ply loop (sq 71 ran 26.1s of a 27.5s wall =
  95%, solo only 1.6s — the "solo tail" framing was stale; the cost was the wasted refutation
  *prefix*, which the −72%/−13% sq-0 oracle had already sized).
- **`killer_k` sweep: k=1/2/4/8 all within noise** (k=2-vs-4 A/B: wash, −1.2% nodes / +0.9% wall).
  k=4 is the canonical config.
- **New tail shape (root-timing with killers on): THREE roots tie at ~12.9s (91% of wall)** — incl.
  the elder (sq 119), which runs first on an empty killer table and still pays rank 7/196. **Next
  levers here:** (a) seed the elder — start 1–2 cheap fast roots before it so the table is warm
  (fan-order change, cheap test); (b) the occasional unlucky root (one hit rank 18 with a failed
  jump); (c) killers at n=18 (branch `queens-n18`) — if the clustering holds there, the n=18 wall
  should drop similarly (BIG implication for the certificate/nimber work).

**★ Banked small win — `QUEENS_DENSE_HUGE` (default ON, `=0` reverts): MADV_HUGEPAGE +
MADV_COLLAPSE on the W8 flat arena (32 MB) + wide induced tables (3..24 MB)** (`collapse_huge` in
`dense.rs`, same aligned-interior dance as `zeroed_huge_atomics`). ~−0.5% cyc/node pairwise (the
A/B's −2.0% mean was one off-round outlier; pairs: −0.3/−6.9/+0.0/−0.6%). Kept: cheap, prep-time
only, byte-identical search.

**Measured DEAD this session (do not re-propose):**
- **K=18 dense + skip band moved to {19}** (the untested {18,19}-adjacent hole): nodes −16.4% but
  cyc/node +18.6% ⇒ wall +3.7%. W18's node cut stays work-conserving even with the cascade-free
  skip band moved up. ({18,19} at K=17 itself remains untested — expected ≤1–2%, low priority.)
- **BOLT post-link layout** (never tried; PGO's sibling): dyno-stats −44% taken branches, but
  cyc/node +0.3% = WASH. With PGO (+2.6% at --15) this **closes the code-layout family**: the
  frontend stall is data-dependent mispredicts + inherent fetch, not layout. (Relocs build:
  `target-bolt/`, `-Wl,--emit-relocs`; bolt 19.1.7 via nix; `perf record -b` works on Zen5 —
  `-j any,u` yields empty branch stacks, plain `-b` doesn't.)
- **12 physical cores (no SMT, `taskset -c 0-11`): total cyc −27.3% / cyc/node −21.2% / nodes
  −7.7% — but wall +24.3%.** SMT contention costs ~21% per-node throughput, yet the thread-level
  parallelism it buys wins the wall. A large cycle-efficiency reserve locked behind parallelism
  (future angle: anything that raises per-thread IPC without dropping threads).
- **20-thread asymmetric** (drop only the 4 Zen5-perf SMT siblings, `taskset -c 0-11,16-23`):
  +32% wall on round 1 — killed early. The 5 GHz uncontended-spine theory does not survive contact.

**Diagnostics banked:**
- **dTLB ≈ 8 misses/node (2.7 B/run) and they are the TT's, not the dense arenas'** (arena collapse
  moved nothing): 12–17 GB on 2 MB pages = 6–8K pages > Zen5 L2 TLB. Fix = **1 GB hugetlbfs pages**
  (boot-time reservation + a `MAP_HUGETLB|MAP_HUGE_1GB` path in `zeroed_huge_atomics`), ceiling
  ~2–4% — user decision (boot param).
- **The `claude` CLI sets `prctl(PR_SET_THP_DISABLE)`** — every process launched from its Bash tool
  inherits THP-off (`THP_enabled: 0` in `/proc/<pid>/status`), so inline-launched solves run the TT
  on 4 KB pages and MADV_COLLAPSE EINVALs. **All pane-launched runs (the A/B harness, records) are
  unaffected** (tmux server ancestry has THP on). Bench discipline: measurement runs go through the
  pane, always.
- n=16 default TT resolved by `tt_bits` is 8.59 GB (2^30 slots), not the 17 GB the harness header
  assumes — pass `QUEENS_TT_SLOTS=2147483648` explicitly for a 17 GB run.

**Code state:** killer lever + dense-huge on main (this commit); `target-bolt/` build dir untracked
(disposable). All gates green. **NEXT:** (1) user call on `QUEENS_KILLER=4` default promotion;
(2) elder-root killer seeding (the 3-way 12.9s tie is the new wall); (3) port killers to the n=18
branch and re-size the n=18 wall; (4) parked heavy levers unchanged (1 GB pages now has a measured
target: the TT dTLB).

### Session 2026-06-23--3 — child_orient8 NO-GO, Tier-A ETC pc-gate KILLED, residual-stabilizer DEAD (last node-count idea), hot-struct discipline LANDED, fresh getK profile (at-floor), ★ flattened getK evaluator (`get_flat`) BUILT+A/B'd → DEAD (+21.7% cyc/node); **user called the floor**
**Session**: 2026-06-23--3. Mode: intent-based (`yc mi`). Resumed `go` from this handoff. Cleared two
open levers, one cheaply and one with a definitive A/B.

**Lever #2 — `child_orient8` → VPTERNLOGQ = NO-GO (disassembly, no build).** The handoff's gate ("iff the
compiler isn't already auto-vectorizing it") is met: `objdump` of the hot `wins_inc` shows `child_orient`'s
8× `Bits` (`[u64;4]`) `and_not` is already emitted as single 256-bit `vpandn ymm`, plus `vpternlogq zmm`
for the fused `parent & !a` forms. `and_not` is one native instruction — a hand `VPTERNLOGQ child_orient8`
has nothing to add. (The 4 scalar `andn` in the body are the cpc/adj path, not child_orient.) Closed.

**★ Tier-A ETC pc-gate — KILLED (definitive n=16 A/B).** Built the `M_RANK` `etc_probes` tap (new
`etc_pr`/`pr/cut` columns in the rank report; gated, production byte-identical). **The tap (8 GB TT, n=16,
`.perf-analysis/rank16.txt`) confirmed the premise's SHAPE exactly:** the `nw>=2` ETC batch cuts ~0% of
nodes in pc 18–24, ≤5% through pc 28 (`pr/cut` 300–5000 — near-pure waste, ~208M of 1.32B total probes),
then flips to 12–35% cuts at pc≥29 (`pr/cut` <180). Clean crossover at ~pc 28–29.
**But the gate A/B is net-negative.** Wired `QUEENS_ETC_PC=<pc>` / `QUEENS_ETC_GATE=1` (gate the batch off
below pc, KEEP the gather+prefetch so the descent still gets warm entry probes). 4-round interleaved
(`QUEENS_ETC_GATE`, 8 GB TT): **cyc/node −1.3% (the per-node probe saving IS real) · nodes +2.0% · total
cyc +0.7% · wall +3.6%** (off 25.6s / on 26.5s mean; SECOND every round; gates green — n12 distinct
1,060,823, `make test`).
- **Root cause (corrects the handoff's & the ETC sub-agents' "node-set-identical" premise):** the ETC's
  value in the cold pc≤28 mass is NOT its ~0% cuts — it's the **win-child reuse** (`wv==1` skip, iso_flat.rs
  ~3524): a recurse child the ETC proved a WIN is skipped instead of re-recursed, and on the direct-mapped
  TT that child's slot is usually evicted before the descent reaches it ⇒ the skip avoids a full
  re-expansion. Gating the probe off forfeits that ⇒ +2.0% nodes. The reuse-probe and the "wasted"
  cut-probe are the SAME probe, so **no pc-gate can keep the eviction protection while dropping the waste.**
- **Code:** `etc_probes` tap kept (M_RANK substrate — the artifact that cheaply mapped this). `etc_pc_gate`
  field + `QUEENS_ETC_PC`/`QUEENS_ETC_GATE` kept gated-off as documented substrate (default 0 ⇒
  byte-identical). **One untried angle:** a much larger TT (≥17 GB, less eviction ⇒ smaller +nodes) might
  net the −1.3% cyc/node out — but the box is memory-tight for back-to-back 17 GB A/Bs and the ceiling is
  small regardless.
**★ residual-stabilizer 2nd-ply orbit-dedup — DEAD (code-read + re-exp evidence, no build).** Settled the
last untested node-count idea: the D4-canonical TT key already IS the orbit-dedup (transpose ∈ D4; 2nd-ply
nodes probed+put under `node_key`/`lex_min8` in `par_wins_inc` :4599/:4808 ⇒ transpose-mirrors are TT hits,
not recomputes; n=14 re-exp ≈ 1.02× confirms). Orbit-dedup's only residual is saving the mirror's canon
build+probe (~few cyc) for ~100 axis-root 2nd-ply pairs = negligible. See the Progress entry.

**★ LANDED: tiger hot-struct discipline (commit `5866ac2`, byte-identical).** Enforced CLAUDE.md rules
#4/#6/#7 on the four per-node structs the --2 audit flagged: `Bits`/`Slot` → `#[repr(transparent)]` +
`const _` size/align assert; `IncFrame` → `#[repr(C)]` + fields reordered largest-align-descending (`pass:u8`
to the end) so repr(C) adds no padding (stays 328 B, size-neutral) + assert; `TinyGraph` → `#[repr(C)]` +
assert (16 B). All gates green (n12 1,060,823, n14 ≈29.2M re-exp 1.02×, make test, clippy).

**★ FRESH skip18-era getK profile (n=16, 8 GB TT; `.perf-analysis/getk16.data`/`.stat`).** Confirms getK
at-floor, identical to --19, with skip18's only shift being `mtt_get` 2.4%→1.56% (pc==18 probes removed):
- Buckets: getK evaluators (`DenseW8::getN`+`get_dyn*`) **~45%**, code-build (`wN_get`=`adj_row_pext`+
  `verts_of`) **~24.5%**, `wins_inc` 17.7%, `sort_moves_by_degree` 7.2%, `mtt_get` 1.56%.
- Machine: **IPC 1.39**, branch-misses 12.7B (~13% of cyc), **L1-dcache miss 2.63%** (W8 hot-set
  L1-resident ⇒ getK is L1-latency not DRAM), LLC miss 11.8% (cold TT probes). Distributed-stall-limited.
- `get10` annotate (the inherent chain, unchanged): W8-arena `bt` load-use 14.6%, cpc-dispatch `cmp $0x9`/
  `cmp $0xa` ~25%, arena word load. `w14_get` builder = `blsr` bit-iter + `popcnt` + att loads (ALU-bound).
- **★ I-cache collapse — BUILT, micro-opt'd, A/B'd → DEAD (+21.7% cyc/node).** The profile's one fresh angle:
  collapse the ~9 monomorphized getK evaluators (`get9`..`get16` + `get_dyn`/`get_dyn_wide`, ≳32 KB) into ONE
  hot loop to cut the frontend/I-cache stall (~22–28%, the biggest stall). Note first: `get_dyn`/`get_dyn_wide`
  turned out to be **dispatchers** to the compile-time-K-monomorphized `getN`/`get_wide<K>`, not unified
  evaluators — so there was nothing to cheaply route to. Built a TRUE flattened evaluator instead
  (`DenseW8::get_flat`, gated `QUEENS_GETK_FLAT`): an **explicit-stack single-loop** runtime-k (9..16) sweep of
  the W_K hierarchy (the `wins_inc_iter` trick applied to the dense tree — user's idea), recursion-free, with
  per-k mask lookup, right-sized pext (u64 for cpc≤11), and an Opus sub-agent micro-opt pass (hoisted frame
  borrow, dropped the `full` field, leaf pext128). Verdict-identical (`flat_matches_dyn` 320K codes; n12 distinct
  1,060,823; n14 ≈29.1M). **n=16 4-round A/B (8 GB TT): cyc/node +21.7% (5710→6952), wall ~+15–18%, total cyc
  ~+17% — a clear LOSS.** First-principles: runtime-k forfeits `getN`'s compile-time-K loop-unroll + const
  cpc-dispatch (a big per-call win), and that structural cost **exceeds** the I-cache savings — i.e. the frontend
  stall is NOT dominated by getN L1i thrash (the hot getN subset — the tail's pc 11–14 — co-resides fine; the
  stall is the builders/`wins_inc`/inherent code). **⇒ getK throughput is at-floor confirmed from this new
  angle too.** The user called the throughput side **at the floor** here.
  - **CODE STATE: saved on branch `queens-getk-flat` (`486bb5a`), cleaned from main** (`dense.rs`: `get_flat`
    + `masks128`/`extract_adj_dyn`/`order_dyn` + `W9/10/11_MASKS128` + the `flat_matches_dyn` test;
    `iso_flat.rs`: the `getk_flat` field/env + the 8 `wN_get` gate branches). Off main — do not merge; revive
    only if a faster runtime-k form is ever found (unlikely; the compile-time-K advantage is structural). Main
    rebuilt + gate green (n12 distinct 1,060,823) = the clean 23.44s default.

- **⇒ The board is now: every node-count + structural + move-ordering + prefetch/parallelism lever is
  EXHAUSTED with evidence, AND getK throughput is at-floor from two fresh angles** (skip18-era profile +
  the flattened-evaluator A/B, +21.7% cyc/node). **The user called it: we hit the floor on the serial
  per-node + node-count search.** What remains is NOT incremental — the **parked heavy / multi-session
  levers**: set-assoc TT, BuRR archive, 1 GB hugepages (boot-reservation), nimber-decomposition node-count,
  and the open **n=18 thread** (branch `queens-n18`, the feasibility proposal). These are the only
  un-exhausted directions, each a deliberate multi-session commitment to decide with the user.

### Session 2026-06-23--2 — perf telemetry + saturation deep-dive, 2nd-ply refutation lever (oracle −13% but predictor CLOSED), 4-agent math/instruction/discipline sweep, ★ LANDED w17_induced→field −0.55%
**Session**: 2026-06-23--2 (`f41034c0-a440-47cf-a6d1-de7f231086ee`). Mode: collaborative. Catalyst: user
asked for "one more round of perf analysis" on the solo deep root, then a cascade of lever hunts.

**★ PERF TELEMETRY + SATURATION DEEP-DIVE (n=16 iso-dense, 12 GB TT; artifacts in `rust/.perf-analysis/`
— `REPORT.html` is a self-contained roll-up, scripts in `scratchpad/`).** Built a per-tick time-series
sampler (`QUEENS_TS_FILE`/`QUEENS_TS_MS` + tunable `QUEENS_FLUSH_NODES`) + mined `perf stat -I 2ms` and a
timestamped `perf record`. Findings — they REFINE the "work-starvation tail" framing **downward**:
- **The box stays ~94% utilized the whole run** (mean 23.1/24 cores producing nodes; tail 22.6). Deep
  starvation (<2 cores) is **brief: ~0.3 s in 4 events at the very end**. An earlier perf-sample-DENSITY
  read (which I initially reported) **over-counted idle** — its p25 threshold caught moderate dips and
  counted rayon `Stealer::steal` spin-wait as "activity collapse." The cycle-accurate per-worker
  node-production is the trustworthy view. **Method lesson banked: perf-record sample density ≠ useful
  work (spinning threads sample); use per-worker node-rate for utilization.**
- **The tail is slower per-node, not idle** (mean working-pc 11.7→12.9; higher-pc getK sweeps cost more
  ⇒ −23% node-rate with cores busy). Inherent W17 getK cost. FFT of the rate ≈ 0.55 Hz / ~2 s cycle.
- **★ SATURATION AUDIT (Zen5 dispatch-stall counters): the search saturates NO resource.** IPC 1.4 (peak
  ~6 ⇒ 4× headroom, not compute-bound); **load-queue-full ~0.5–0.7%, store-queue-full ~1%** (NOT memory-
  queue/MLP-bound — the load queue has huge headroom = unused MLP the **serial DFS probe can't fill**,
  which *mechanistically explains why prefetch died*). Low IPC = distributed stall: frontend(I-cache,
  getK code) ~28% + backend ~25%. The ONLY true saturation is **TT prefault pinning the store queue
  ~22% for ~0.5 s** (one-time prep). Tail collapse bursts push backend to ~47% (serial spine on cold
  memory + getK ALU). DRAM bandwidth ~18 GB/s « peak. (Caveats: ~80–90% counter multiplexing; W=8 slot
  assumption.) `paranoid=2` blocks `-a` so no DF/CAS counters; used per-process `de_*` stall events.

**★ 2nd-ply REFUTATION lever (the one sizeable node-count prize — explored, ceiling found, predictor
CLOSED).** Built `QUEENS_SCHED` (captures the slow root sq 0's depth-1 `.any()` 2nd-ply schedule),
`QUEENS_ONLY_ROOT` (isolate one root for clean per-move counters), `QUEENS_SCHED_FIRST` (front-load
chosen 2nd-ply squares). Findings:
- sq 0 (= board square 0, a par_iter sibling, NOT the elder brother) is a wall-determining root. Its
  ~210 2nd-ply moves are tried in **static `order8`** (the dynamic degree-order never reaches the
  `par_wins_inc` upper tree); the **refutation lands at rank 16** behind ~16 non-refuting moves.
- **ORACLE (front-load the known refutation sq 90): sq-0 isolated 73.6 M→20.3 M nodes (−72%), full-run
  313.7 M→273.5 M / 25.2→22.6 s (−13% / −10%).** The refutation is ~independent (cold 20.3 M ≈ warm
  16.2 M); the cut non-refuting moves are mostly-private work (clean cut, only ~25% reappears cross-root).
  (Earlier "high-overlap cold balloon" was a measurement artifact: per-move node deltas in the FULL run
  are contaminated by the ~2 concurrent roots — only isolated runs give clean per-move counts.)
- **BUT the predictor is CLOSED.** Refutations are rare; no cheap signal ranks one early: degree
  (pushes it *later*, `QUEENS_PAR_ORD` full A/B = +44% nodes/+53% wall DEAD), cross-root overlap
  (~uniform), subtree-size (similar), and **symmetry-defect** (Agent-2's best idea — front-load the move
  that most restores rot180 symmetry, `popcount(avail^rot180)`): **TESTED, it's an ANTI-signal** — the
  most-symmetric moves are expensive non-refutations (+68% nodes), the refutation sits mid-defect
  (rank 118/210); the mirror argument breaks for the corner (its rot180 image is self-attacked). Multiple
  refutations exist (sq 90, 127) but no cheap signal finds a *cheap* one early.
- **`QUEENS_SPLIT` (parallelize the 2nd-ply `.any()`) DEAD: +393% nodes/+254% wall** — "independent
  when warm-sequential" ≠ parallel-safe; concurrent cold runs race + re-expand. Confirms DFS-parallelism
  stays closed at the 2nd ply too.
- **One untested node-count idea remains: residual-stabilizer orbit-dedup of the 2nd-ply move set on
  axis-roots** (Agent 2 #2 — when the 1st move is on a symmetry axis the residual board has an order-2
  stabilizer ⇒ 2nd-ply moves come in symmetric pairs leading to identical subgames; orbit-reduce BEFORE
  recursing = sound *pre*-pruning, no re-expansion cascade, unlike a memo-skip).

**★ 4-AGENT MATH / INSTRUCTION / DISCIPLINE SWEEP → near-floor, with one landed micro-win.** Ran 4
read-only research sub-agents:
1. getK/W17 math: near-floor; only novel = fold precomputed popcount-shifts into the pext mask tables —
   but the popcount runs *parallel* to the pext (off the critical chain) ⇒ likely wash; NOT implemented.
2. other math (canon/refutation/symmetry): refutation predictor closed (above); cheaper canonical key
   DEAD (de-branch measured dead; an O(1) invariant forfeits the exact-merge the distinct gate locks);
   W8 table at its optimal level/repr; decomposition cluster dead.
3. banked-lessons audit: **★ `wide_induced(k)` did a per-call `OnceLock`+`Box` deref on every pc≥17 node
   — the `Vec<Box<…>>` pointer-chase the W8 flat-arena fixed (−2 %). LANDED the fix (below).** Also flagged
   (TODO, hygiene): no `#[repr(transparent/C)]` + no `const _: () = assert!(size_of/align_of)` on the
   per-node structs `Slot`/`Bits`/`IncFrame`/`TinyGraph` (silent-stride-regression traps); the new
   `flush_nodes` const→field on `bump_local` should be A/B-confirmed a wash before promotion.
4. znver5 instructions: **Zen5 full-width datapath does NOT revive the dead getK SIMD** (those died on the
   α-β early-out + a stack spill = width-independent; `pext` has no vector equivalent; getK is
   L1-resident/frontend-bound). GFNI D4-canon materialize + register-argmin is genuinely NOVEL + viable on
   Zen5 but skip18 shrank its target to the pc≥19 spine ⇒ marginal (microbench to close). `VPTERNLOGQ`-
   fused 256-bit `child_orient8` is a cheap GO **iff the compiler isn't already auto-vectorizing it** —
   check the disassembly first. Cross-leaf getK gather / VPCLMUL hash / VPCONFLICT graph-build = NO-GO.

**★ LANDED: `w17_induced` resolved into a `DenseW8 &'static` field** (`dense.rs`) — removes the per-pc≥17-
node `wide_induced(17)` `OnceLock`-load + `match` + `Box`-deref; `get17` is now a direct field read.
Byte-identical (gate green: n=12 iso-flat distinct **1,060,823**, n=14 second-player). **Balanced paired
A/B (6 ABBA pairs, 12 GB TT): −0.55 % cyc/node, all 6 pairs negative, sd 0.32 %.** NOTE: the first,
naive A/B (always-A-first) read −3.4 % — a **thermal artifact** (A consistently caught the ramp). **Method
lesson banked: ABBA-balanced + paired-adjacent ordering is mandatory; always-first lied by ~6×.**

**Instrumentation added (all gated OFF by default ⇒ production byte-identical; kept as measurement
substrate per the project pattern):** `QUEENS_SCHED` / `QUEENS_ONLY_ROOT` / `QUEENS_SCHED_FIRST`,
`QUEENS_PAR_ORD` (DEAD), `QUEENS_SPLIT` (DEAD), `QUEENS_TS_FILE`/`QUEENS_TS_MS`, `QUEENS_FLUSH_NODES`.

**⇒ NEXT (priority): (1) residual-stabilizer 2nd-ply orbit-dedup on axis-roots — the one untested
node-count idea; (2) check `child_orient8` disassembly → `VPTERNLOGQ` if scalar (cheap); (3) add the
`repr`+`const _` size/align asserts (zero-risk hygiene). The −13% refutation prize needs a predictor no
cheap signal provides — effectively closed. The throughput core (getK pext chain) is at the floor.**


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
n-agnostic, `QUEENS_SKIP18=0` reverts). **New clean-box n=16 record: 23.44s search / 307,608,950 nodes**
(SECOND), now leaderboard #1 — beats the W17 --18 default's 24.5s. Everything else explored is **dead/weak/marginal with committed
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
