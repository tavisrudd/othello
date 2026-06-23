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
- **Oracle-sidecar upper-bound experiment RUNNING** (sub-agent, box-heavy n=16): an `M_CANONPROF` cost
  tap on the production M_ORD_W path + inject an offline-built "never-recur" oracle and measure the wall
  saving + the re-exp tax. Result pending.
- **Soundness risk:** 8 exact positions canonicalize to 1 TT entry ⇒ a position recurring via a
  *different* orientation is a false-negative → re-expansion tax. Must measure the cross-orientation
  recurrence rate (the experiment does).

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
| `count --roots` directional ext (the C measurement, uncommitted) | `rust/src/bin/queens.rs` (`roots_report`) |
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
- [ ] Tier-B2: canon-skip oracle-sidecar upper-bound (RUNNING) → verdict.
- [ ] Tier-C1: ★ getK distinct-`comp_canon` @ K=9–12 offline count → (if GO) build the value layer.
- [ ] Tier-C2: treewidth min-fill bound on a dump → (if median ≤10) prototype the separator DP.
- [ ] Tier-C3: ranklab AND-node proof-cost skew → (if ≥20%) prototype the scheduler.

## Handoff Notes

### Exploration handoff (2026-06-22)
**Session**: 2026-06-22--6 (`a20b03dc-e462-4801-ab1b-88b683f9980b`)
**Completed**: Multi-agent lever hunt past the n=16 floor. Retired move-ordering with a live A/B
(committed, see --20). Surfaced + triaged the lever menu above; measured the pre-warm GO (`C≈0.39`
n=14); confirmed probe-skip DOA and reframed it to the canon-skip (B2, measuring) per the user's
pre-canon idea; converged the ETC question on the signal-free pc-gate (Tier A).
**Files created/modified**: this handoff (new); `--21` pointer in the explicit-stack-frontier handoff.
Code this session already committed: QUEENS_RANK r2/E/ordering_loss report + ranklab (incl. recurse-
weighted scorer) — commits `2ff41c8`, `def4ff6`, `d007f93`, `32c9e19`, `316e8c3`, `ba6b717`.
**Uncommitted at session end (DO NOT lose; do NOT commit while the canon-skip agent is mid-edit):**
the `count --roots` directional extension in `queens.rs` (the C measurement); gated `M_CANONPROF`/
`M_SKIP` in `iso_flat.rs` (canon-skip agent, mid-build — may not compile yet).
**Instructions for next agent**: Start with the cheap offline go/no-go tests, cheapest first
(C2 treewidth on a dump needs only Python + a dump; C1 distinct-canon + A probes-per-cut are small
`count`/`M_RANK` extensions). Fire the n=16 HLL pre-warm confirm once the box is free. Fold the
canon-skip experiment's verdict into Tier-B2 when it lands. Keep one n=16-heavy job on the box at a
time. The standout bet is **C1 (canonical getK layer)** — attacks the 44% with the W8 precedent.
