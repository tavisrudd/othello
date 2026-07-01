# SMT complementary-phase scheduling — research/measurement plan (lever 3)

**Date**: 2026-07-01
**Session**: 2026-07-01--13 (`a5719b8d-3848-4dc8-b043-7663fbbabd11`) — authored; work starts NEXT session
**References**:
- Evidence + killer-regime baseline: [push-past-floor](2026-06-22-push-past-floor-levers.md) sessions 2026-07-01--13 (+cont/cont.2)
- Banked lesson that constrains every design here: **move-order-preserving only** (Approach B/SPSC pipeline died +94% nodes on order forfeiture; frontier handoff --12)
- Box topology: 12 physical cores (4 Zen5 @ ~5 GHz boost + 8 Zen5c @ ~3.3 GHz), SMT ⇒ 24 logicals; siblings = (N, N+12)

## Context

The n=16 iso-dense default (killers + deep-killers + ETC-gate) runs ~13.8–15s / ~175–190 M nodes.
Every node-count, ordering, layout, and TT-representation lever is measured-closed (see the
push-past-floor DEAD lists). The one measured, still-unconverted reserve is **SMT contention**:

- 24 threads (SMT): cyc/node ≈ 5850–5950, node rate ~11.6 M/s (pre-killer measurement era)
- 12 threads (`taskset -c 0-11`, one per physical core): **cyc/node −21.2%, nodes −7.7%, total
  cyc −27.3% — but wall +24.3%** (thread capacity halves; SMT nets +38% node throughput)

Two identical search threads per core waste ~21% of ticks on each other (ports/frontend/L1 —
the workload is mostly L1-resident getK compute, IPC 1.34/thread). "Complementary-phase"
scheduling = make sibling pairs run *dissimilar* work so they contend less, keeping 24-thread
capacity at closer-to-12-thread efficiency.

**Honest ceiling (napkin, n=16):** if contention vanished entirely at 24 threads, wall ≈
nodes × 12t-cyc/node ÷ 24t-capacity ≈ 174 M × 4600 / 66 G ≈ **12.1s vs 13.8 ⇒ ~−12% max**;
a realistic partial win is a few %. The lever matters more at n=18 scale (hours ⇒ tens of
minutes). This is research-grade and may terminate at "contention is inherent to the code mix"
— that verdict, with numbers, is itself a valid deliverable.

## Constraint (non-negotiable)

Any scheme must **preserve per-node move order and the sequential α-β structure**. No frontier
reorder, no cross-thread handoff of a node's children, no speculative sibling execution. The
only degree of freedom is **which OS thread (= which SMT sibling) runs which already-legal
task** (rayon tasks are already order-legal units: root resolves, even-depth par children,
deep-kernel subtree calls).

## Probes, cheapest first (each has a kill condition)

### P1 — Re-baseline the reserve in the killer regime (env-only, ~20 min)
The −21%/−27% numbers predate the killer defaults; the node mix changed (more shallow par
region relative to deep tail). Rerun `scripts/queens-ab.sh 16 QUEENS_W12 <wrapper> 4` with the
existing `queens-w12-wrap.sh` pattern (`taskset -c 0-11`, `QUEENS_AFFINITY` inherited-mask path
engages automatically). **Kill condition: if the 12t cyc/node delta shrank to ≲10%, the whole
lever's ceiling is ≲5% — stop here and close it.**

### P2 — Is the contention intra-process-structural or pure code-mix? (~30 min, no code)
Run **two concurrent 12-thread solver processes**, one pinned to `taskset -c 0-11`, the other
to `taskset -c 12-23` (sibling sets), each solving n=16 with its own TT (memory: 2×2 GB TTs is
fine now — TT size is a free parameter down to ~2 GB in the killer regime). Compare each
process's cyc/node to (a) the solo-12t 4600 and (b) the 24t ~5900.
- ≈5900 ⇒ contention is pure instruction-mix vs instruction-mix ⇒ **no intra-process
  scheduling fix exists** (both siblings run the same hot loop no matter how tasks are routed)
  ⇒ close the lever with this as the verdict.
- Meaningfully <5900 ⇒ something intra-process (shared-line traffic, rayon queue contention,
  TT line sharing) contributes ⇒ P3 has a target.

### P3 — Phase attribution: does a memory-ish phase big enough to pair even exist? (~1h)
The doubt to resolve: TT probes are ~1.5% of cycles and dTLB ~9/node — the memory-bound share
looks too small to donate a whole sibling to. Measure the cycle split between (a) the par
region / canon+TT+gather code (`par_wins_inc`, `node_key`, `mtt_*`, ETC gather) and (b) the
deep kernel + getK (`wins_inc`, `DenseW8::*`, `wN_get`) via `perf record` + report-by-symbol
on the current default. If (a) ≲10% of cycles, **complementary pairing has no counterweight —
close the lever** (the reserve is compute-vs-compute port sharing, unreachable by placement).

### P4 — The build (only if P2 and P3 both leave it alive): dual-pool sibling routing
Two rayon pools with pinned `start_handler`s: pool A on cpus 0–11 ("upper tree": root
resolves, par fans, canon/TT-heavy), pool B on 12–23 ("compute": the coarse sequential
deep-kernel subtree calls — each is ms-to-seconds, so cross-pool submission latency amortizes).
Routing point: the `par_wins_inc` → deep-kernel switch (`depth >= par_depth && avail <=
min_avail`, iso_flat.rs ~4650) becomes a pool-B `spawn`+wait when the caller is on pool A.
Gated `QUEENS_SMT_POOLS=1`. Risks to watch: pool-A starvation (upper tree is a small cycle
share), blocked-thread deadlock (use `in_place_scope`/channel wait, never block a rayon worker
on another pool without yielding), and the Zen5-vs-Zen5c asymmetry (consider putting compute
on the 4+8 split instead of sibling split — sweep).

## Codebase Reference

| What | Where |
|------|-------|
| par→deep-kernel switch (P4 routing point) | `rust/src/queens/solver/iso_flat.rs` (~4650, `depth >= self.par_depth && avail.popcount() <= min_avail`) |
| Affinity plan / pinned-pool precedent | `rust/src/affinity.rs` (`configure`, `pin_to_cpus`) |
| 12t wrapper pattern | scratchpad `queens-w12-wrap.sh` (recreate: `taskset -c 0-11` exec) |
| A/B harness | `rust/scripts/queens-ab.sh` (README in header; 12 GB TT default) |
| SMT sibling map | cpu N ↔ N+12 (verified via `thread_siblings_list`) |
| Killer-regime baseline | ~13.8–15s / ~175–190 M nodes @ 12 GB TT, cyc/node ~5900 |

## Delegation Strategy

- P1/P2 (env-only measurement): **can delegate** — Sonnet sub-agent or inline; pane-launched
  runs only (the `claude` process disables THP for inline children — banked gotcha).
- P3 (perf attribution): inline or Opus sub-agent (interpretation shapes the go/no-go).
- P4 (dual-pool build): **Opus, main context** — touches the solver's parallel spine.

## Workflow Instructions

Read this file + the push-past-floor handoff's 2026-07-01 sessions first. Run the probes in
order; each kill condition is a legitimate end state (close the lever in the Progress list and
push-past-floor, with numbers). Bench discipline: interleaved A/B only, pane-launched, box
hygiene per CLAUDE.md.

## Progress

- [ ] P1: 12t-vs-24t re-baseline in the killer regime (kill if delta ≲10%)
- [ ] P2: two 12t processes on sibling sets (kill if cyc/node ≈ 24t)
- [ ] P3: cycle share of the canon/TT phase (kill if ≲10%)
- [ ] P4: dual-pool sibling routing build + A/B (only if P1–P3 all pass)

## Handoff Notes

(none yet — work starts next session)
