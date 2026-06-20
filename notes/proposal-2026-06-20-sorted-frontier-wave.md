# Proposal: sorted-frontier wave (A'') — turn the giant-root tail's random TT scatter into a sorted stream

## Status

Draft — scoping artifact. Synthesis of session **2026-06-20--9**'s measurements
([handoff](handoffs/2026-06-19-explicit-stack-frontier.md)). Builds on, does not duplicate, the
[grouped-frontier DDD proposal](proposal-2026-06-18-grouped-frontier-ddd.md) (component-nimber framing,
Phase-1 wall-bound) and the `ddd_bandwidth_bench` bandwidth primitives.

## Problem

n=16 iso-dense (W12) solves in ~1m39s; the compute floor for this strategy class is ~45–60s (~2× over).
Session --9 characterized exactly where the gap lives:

- **The tail is ONE giant root** (sq 1) = **94% of the wall** (91.7s of 97.9s), with a 17.5s SOLO phase at
  ~14/24 cores. The scheduling prize is ≤~8% and is **closed** (work-stealing measured negative — the tail
  is transposition-saturated). **The lever is the giant root's WORK, not its schedule.**
- The cost is **co-dominant: backend-memory ~30%** (pc 13–21 random TT probes, flat **176 cyc/get** cold
  DRAM, **38% hit**) **+ frontend ~31%** (getK compute), retiring only 14%.
- **Probe-skip is refuted** (`QUEENS_PROF`): the probes pay ~22× (38% hit × ~10,000-cyc avoided getK
  re-expansion). So we cannot *remove* the probes — only *cheapen* them.
- **The only lossless chunk axis is popcount** (already +5% via the segmented TT). Canonicalization folds
  away all finer spatial/graph structure (merge-friendliness ⊥ chunk-locality), so locality beyond pc must
  be **manufactured by sorting**.

The decisive number (`tt.rs::mlp_bench`, single thread, real 8 GiB huge-page TT):

| pipeline depth (probes in flight) | random M/s | **sorted-by-slot M/s** | sorted/random |
|-----------------------------------|-----------|------------------------|---------------|
| 0 (≈ today's effective regime)    | 52        | 88                     | 1.7× |
| 8                                 | 83        | 153                    | 1.8× |
| 16                                | 92        | 208                    | 2.3× |
| 32                                | 100       | **301**                | **3.0×** |

**Sorting the probes by target slot before streaming them = up to 3× over random at the same depth, ~5.7×
over today's regime (301 vs 52 M/s), and it compounds with depth** (sequential access hits open DRAM rows →
saturates bandwidth; random stays latency-bound at ~7 GB/s). Per-node MLP was Fermi'd below-bar: a prove-loss
node has only ~3–12 recurse children, and DFS descent + TT-mutation-during-descent prevent cross-node overlap,
so the wide batch needed for both depth and sorting only exists **across** the frontier, not within one node.

**The lever: process the giant root's pc 13–21 frontier as a *sorted wave* — probe back-to-back, deep
pipelined, with adjacent duplicates removed — instead of a per-node random scatter.**

## Context

What already exists and is load-bearing:

- **Materialized frontier:** `wins_inc_iter` (`QUEENS_ITER`, throughput-parity, gated) makes the search
  frontier explicit, inspectable data (the `IncFrame` stack) — the substrate a DFS can't provide.
- **Dense floor:** W0..W12 (`dense.rs`) resolve every pc≤12 node with no TT probe; the wave's "leaves" are
  the dense floor, so a frontier wave only needs pc 13–21.
- **Segmented TT:** `QUEENS_TT_SEGMENT` already routes by pc-band (`index_seg`) — the wave's natural slices.
- **Parity discipline:** even/prove-loss (AND) plies search **all** children (no cutoff to lose) — the
  speculation-free place to batch. Odd/prove-win (OR) plies keep the cutoff.
- **`ddd_bandwidth_bench`** already measured the streaming regimes on this box (seq_read, seq_copy,
  rand_gather, chase, **radix** = the sort/join primitive, w9_direct). The sorted-stream claim is
  hardware-grounded there; the new `mlp_bench` adds the **real-TT sorted-probe** point (5.7×).
- **Prior DDD framing (parked):** the [grouped-frontier proposal](proposal-2026-06-18-grouped-frontier-ddd.md)
  dedup'd by **component nimber** (cutoff-free Sprague-Grundy) — Phase-1 measured **−74% nodes but 6.6× wall**
  (the nimber recursion is the cost). **This proposal's new framing is win/loss + sorted-stream + idle-core
  sort** — it keeps α-β (no nimbers), and the dedup is by *sort*, not by nimber recursion.
- **Negative we must not repeat:** frontier **work-stealing** (idle cores re-search DFS subtrees) was
  measured **+8.7% nodes / +13.3% wall** — the tail is transposition-saturated, so concurrent *search*
  re-does shared work. The distinction that makes A'' sound: idle cores **dedup/sort/pack** (complementary,
  non-redundant), they do **not** re-search.

## Approach A — in-DFS sorted-wave probe (single-core prep, lightest)

### Architecture
Keep the DFS. At a pc-band boundary, the hot worker gathers a bounded window of pending prove-loss children
(a frontier slice it would expand anyway), **sorts the slice by slot index** (`fastrange(route,len)`),
**streams the probes** deep-pipelined (prefetch-ahead K≈16–32 over the sorted slice), resolves hits, then
expands the misses (re-probing for freshness, since the TT mutates). Dedup within the slice is free (sorted →
adjacent equal keys collapse). Prep (sort) is on the critical path; window sized so the sort cost < the
sorted-stream saving.

### Trade-offs
**Strengths:** smallest change; reuses `wins_inc_iter`; gated, byte-identical off; validates the in-solver
sorted-stream win before any pipeline. **Weaknesses:** sort on the critical path eats into the win; the
window is bounded by one worker's reachable frontier (narrower than a full ply → less than the full ~5.7×);
the freshness re-probe partially re-randomizes; node count shifts slightly (probe-before-expand cut) — gate-
safe on iso-dense (no `--distinct` counter) but not a clean cyc/node A/B.

## Approach B — idle-core producer/consumer pipeline (the user's A'', target)

### Architecture
Split the cores: **producer (idle tail) cores** materialize the giant root's pc-band frontier, **sort + dedup
+ pack** it into cache-line-aligned dense chunks (SoA: `route[]`, `fp[]`, `child_orient[]`, sized to the 1 MB
L2), off the critical path. The **consumer (hot) core** streams each chunk — probes back-to-back at full
depth (→ the ~5.7× ceiling), resolves hits, publishes boundary values, and feeds the next ply's frontier back
to the producers. A bounded SPSC ring per producer→consumer link; the frontier is owned by the producers, the
TT is shared lock-free as today.

```
producers (idle cores):  gather frontier → sort by slot → dedup → pack aligned chunk ─┐
                                                                                      ▼ SPSC ring
consumer (hot core):     stream chunk: prefetch-ahead → probe → resolve hits → expand → publish values
```

This is the literal realization of "idle cores prep so the hot worker streams a dense kernel through aligned
chunks." It **differs from work-stealing**: producers never *search* (no re-expansion); they *sort/dedup*
(remove duplicates the hot core would otherwise re-probe) — complementary work that fills the idle bandwidth
the tail leaves (the ~14-core SOLO phase has spare memory channels).

### Trade-offs
**Strengths:** captures the full sorted-stream ceiling (sort is free, off critical path) **+** the dedup
(fewer distinct probes) **+** uses the idle tail cores productively (the thing work-stealing couldn't).
**Weaknesses:** real concurrency design (SPSC, frontier ownership, back-pressure); breaks DFS-residence
within a ply (checkpoint/resume changes); the producer/consumer boundary adds latency; correctness care
(boundary-value publication must be race-free — but the TT already tolerates this via deterministic puts).

## Approach C — full ply-windowed retrograde DDD (break DFS, n=18 endgame)

### Architecture
Abandon DFS entirely for the tail. Process the giant root's pc-bands **bottom-up** (retrograde wave): expand a
ply's frontier, external-sort by key (Korf delayed-duplicate-detection), dedup, solve densely (each unique
boundary graph once), **BuRR-freeze** the solved ply (value-only ~1.1 bit/key — sound because windowing gives
known membership → cache-resident, sequentially streamable), then the next ply queries the frozen one. The
`ddd_bandwidth_bench` already grounds this regime's bandwidth.

### Trade-offs
**Strengths:** the cleanest streaming (pure sequential), the dedup is global per ply, BuRR makes solved plies
tiny, and it is the **n=18 enabler** (the set won't fit RAM there). **Weaknesses:** the biggest structural
change (no DFS, no α-β cutoff across plies → must materialize whole plies); the win/loss-vs-nimber question
returns (a retrograde wave over win/loss needs the AND/OR structure, not just reachability); heaviest build;
overlaps the existing grouped-frontier proposal's territory.

## Approach comparison

| Criterion | A: in-DFS sorted wave | B: idle-core pipeline | C: ply-windowed retrograde |
|---|---|---|---|
| sorted-stream win captured | partial (sort on path) | **full** (sort off path) | full |
| dedup | within window | within frontier | **global per ply** |
| uses idle tail cores | no | **yes** | yes (all cores) |
| DFS-residence | kept | kept (per ply) | **broken** |
| build size / risk | small | medium | large |
| n=18 enabler | no | partial | **yes** |
| vs work-stealing negative | n/a | dedup not re-search ✓ | dedup not re-search ✓ |

## Open questions

- **Window/ply size for A/B:** how wide a frontier slice before the sort amortizes? `mlp_bench` says depth
  ~16–32 saturates; a slice of a few thousand keys should suffice — but the giant root's reachable frontier
  at a pc boundary needs measuring (extend `count`/`comps_report` to size the pc-band frontier).
- **24-thread contention:** the 5.7× is single-thread @ boost. Under load the bandwidth is shared — but the
  tail runs ~14 cores with spare. Does the producer/consumer split (fewer hot cores, idle cores on sort)
  actually sit in the spare-bandwidth regime? Needs a 2–4-thread sorted-stream microbench.
- **Freshness vs dedup:** the TT mutates during a wave; a producer's dedup'd "miss" may become a hit before
  the consumer reaches it. Re-probe at consume (cheap, sorted/warm) or accept the rare re-expansion?
- **Boundary-value publication race** (B): producers and consumer both touch the shared TT — the existing
  deterministic-put discipline should cover it, but verify.

## Recommendation

**Build toward Approach B (idle-core pipeline), but Phase-1-validate with Approach A first.** Justification:

1. **A is the cheapest in-solver proof of the sorted-stream win.** `mlp_bench` proves the *memory system*
   gives ~5.7× for sorted streams; A proves the *solver* can realize a meaningful fraction before we invest
   in the pipeline. If A is a wash (sort cost ≮ saving at solver window sizes), B won't pay either — fail
   cheap.
2. **B is where the ceiling actually lives** (sort off the critical path) **and it productively uses the
   idle tail cores** — the one thing work-stealing structurally couldn't, now sound because it dedups
   instead of re-searches. It directly attacks the 30% memory bucket *and* carries a node-count dedup.
3. **C is the n=18 endgame**, not the n=16 lever — defer it to its own track (it overlaps the existing
   grouped-frontier proposal and reopens the win/loss-vs-nimber retrograde question). BuRR re-enters in C as
   the frozen-ply backing.

### Implementation phases

- **Phase 0 (size it, no solver change):** extend `count`/`comps_report` to measure the giant root's pc-band
  frontier width (how many distinct keys per pc-band slice) + a 2–4-thread sorted-stream microbench (does the
  5.7× survive contention?). Gate: numbers support a window where sort < saving.
- **Phase 1 (Approach A, gated):** in-DFS sorted-wave probe on `wins_inc_iter` (`QUEENS_SORTED_WAVE`),
  byte-identical off. A/B on n=16 iso-dense: cyc/node + wall. Gate: `solver_lineage_agrees` (n≤9) + n=16
  SECOND; pull-its-weight or revert/record-negative.
- **Phase 2 (Approach B, if Phase 1 pays):** producer/consumer pipeline — idle-core sort/dedup/pack + SPSC +
  streaming consumer. A/B vs Phase 1 and vs the iso-dense baseline. Gate as Phase 1, plus race-freedom of
  boundary publication.
- **Phase 3 (Approach C / n=18):** separate track; fold into the grouped-frontier proposal with BuRR-frozen
  plies.

**Validation gate (every phase):** `solver_lineage_agrees` (n≤9 vs naive) + a fresh n=16 **SECOND** verdict.
iso-dense has no `--distinct` counter, so node-count changes (the dedup/probe-before-expand cut) are gate-safe
— the A/B metric is **cyc/node + wall** (interleaved, per the perf discipline; n=16 node count is ±18% noisy).
