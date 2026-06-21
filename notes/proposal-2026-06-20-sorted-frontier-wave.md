# Proposal: sorted-frontier wave (A'') — turn the giant-root tail's random TT scatter into a sorted stream

## Status

**CLOSED with evidence (2026-06-20--12): Approach B (sorted-frontier wave + dedup) is measured-NEGATIVE both
halves; Approach A (`M_WAVE`) remains the shipped default.** 2a sized the offload as a GO on paper (wide / 27–38%
dedup / 62–73% sorted locality), but 2b's cheap de-risk killed it: **slot-order (the sorted wave) = +94% nodes at
n=16** (move ordering is worth ~2× node reduction — no throughput gain survives it; the SPSC pipeline depended on
sorted consumer access ⇒ dead), and the order-independent **L0 probe-cache dedup = +6% cyc/node / +5% total cyc**
(the TT already serves repeats warm ⇒ the tax-free dedup prize is ~0%, the 27% needs the +94%-tax sort). The +94%
finding **also closes grouped-frontier DDD** (any frontier reorder forfeits move ordering). The giant-root tail's
WORK is not cuttable by frontier-reorder/dedup; surviving levers preserve move order (getK/W_K, decomposition,
per-node frontend micro-opts). Phases 0/1/2a retain value (the M_WAVE default, the gated `QUEENS_SIZE`/`WAVE_B`/
`L0` measurement substrate, the banked negatives). Historical GO scoping kept below for the record.

**Phase 0, Phase 1 (Approach A), and Phase 2a (offload sizing) are DONE; 2a was GO-on-paper but 2b measured B closed (2026-06-20--12).**
- **Phase 2a (offload sizing, `QUEENS_SIZE`/`M_SIZE`) — DONE, verdict GO.** A gated cold tap of the
  recurse-arm probe stream (per-pc width + HLL global-distinct + slot-sorted-locality sample; production
  byte-identical, control DCEs the tap). **n=16, 12 GB TT @ 70.9% load (WAVE-off stream, the upper bound on
  offloadable work): 3.0 B recurse-arm probes, pc 13–21 = 88.4% (cross-validates the 87% PROF figure),
  dedup ceiling 38.1%** (over a third of probes hit an already-probed key ⇒ removable by sort+dedup),
  **and after a slot-sort 73.0% of consecutive probes land in the same DRAM-row window / 28.5% the same
  cache line** (vs ~0% for today's random scatter — and this is a *floor*: the 4 M sample spreads slots
  375 apart; a real producer sorts a far larger chunk → packs denser → trends to fully sequential). n=14
  proxy agrees (dedup 31.7%, 100% same-row). **All three gate conditions pass — wide frontier, large dedup,
  strong manufactured locality ⇒ a θ exists where the off-core sort+dedup pays.** (Detail in the
  [handoff](handoffs/2026-06-19-explicit-stack-frontier.md) session --12 note.)
- **Phase 0a (microbench) — GREEN.** `tt.rs::mlp_bench::mlp_probe_threads_sweep`: the sorted-stream win
  survives contention; memory saturates at **~780 M/s with ~4–8 streaming cores**; leverage is highest with
  **few** consumers (5× @4 cores, eroding to ~2.8× @8). **~4 sorted-consumer cores out-probe the whole
  current ~14-core random tail** — the design constraint for B (few hot consumers, many idle producers).
- **Phase 1 (Approach A = `M_WAVE`/`QUEENS_WAVE`) — LANDED + PROMOTED TO DEFAULT.** The fused in-DFS ETC +
  batch-probe is a measured net win at n=16 (**−16% nodes / −4% total cycles / −2.7% wall**) and is now the
  **iso-dense default** (`8400134`; `QUEENS_WAVE=0` disables). **But A captured only −4% wall of its −16%
  node cut** — the gather/probe prep costs **+22% cyc/node on the critical path**, eating most of the cut.
  **That gap (−4% → toward −16%) is exactly Approach B's prize.**

Synthesis of sessions **2026-06-20--9/10/11**'s measurements
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

### Approach B — DETAILED SCOPE (2026-06-20--11, grounded in the landed M_WAVE)

**What A already does (the substrate B inherits).** `M_WAVE` in `wins_inc` (`iso_flat.rs`, behind
`if MODE == M_WAVE`) at each OR node: (1) **gather** — for each move, `child0 = avail & ~attack[sq]`; for
recurse-arm children (`pc > recurse_min`) build the descriptor `(ckey = d4_bits(lex_min8(child)), cr, cf =
hash128)` into a `WAVE_CAP` stack SoA; (2) **ETC probe** — prefetch all `cr`, then `tt_get_h` each; a child
proven-LOSS (or an empty child) wins the OR node → **cut**; (3) **fused descent** — on no cut, expand,
reusing the stored descriptors. Steps (1)+(2) are the **+22% cyc/node** that runs on the hot core and eats
the −16% node cut down to −4% wall. **B's job: move (1)+(2) to idle cores.**

**The prize, quantified.** The −16% node cut is *already proven* (it's the ETC cut, preserved by B). A pays
+22% cyc/node for it on the hot path ⇒ −4% wall. If B off-loads (1)+(2) so the consumer's per-node cost falls
back toward the WAVE-off baseline, the −16% node cut translates toward **−16% wall** — a **~−12% incremental**
gain (n=16 ~1m32s → ~1m20s). **Plus** two stacking wins A leaves on the table: **(a)** the misses the consumer
must still expand-probe become a **sorted, prefetch-warmed stream** (Phase-0a's 5.7× / ~780 M/s vs today's
176-cyc cold random gets — directly draining the **30% backend-memory** bucket), and **(b)** **dedup** removes
duplicate probes across the frontier (the giant root is transposition-saturated — adjacent equal keys after
sort collapse). Ceiling is therefore *above* −16%; realistic target **−10…−18% wall** after SPSC/management
overhead. Compute floor is ~45–60s, so the headroom is real.

**The sound batching boundary — producers PROBE, never EXPAND (this is what makes B ≠ work-stealing).**
The expensive, speculative work is **expansion** (re-searching a subtree). Work-stealing failed because idle
cores *expanded* shared transpositions → re-search. B's producers only do **read-only** work — gather
descriptors, sort by `cr`, dedup adjacent keys, prefetch-warm, and (optionally) probe. None of that re-searches
anything; it *manufactures locality* and *removes duplicate probes* the consumer would otherwise do cold.
Expansion stays on the consumer under the normal α-β cutoff. So the producers fill the ~10 idle tail cores
with strictly complementary work — the structural property the work-stealing negative lacked.

**The three wins B captures (vs A's one):**
1. **ETC node cut (−16%)** — inherited from A, preserved (the consumer still cuts on a producer-found LOSS).
2. **Prep off the critical path** — the +22% cyc/node gather/probe runs on idle producers ⇒ the node cut is
   no longer self-eaten.
3. **Sorted-stream + dedup on the residual probes** — the misses the consumer expands are streamed sorted +
   warm (5.7× regime) and deduped — a *new* win A never had (A probes in gather order, no sort, no dedup).

### Concurrency design (the real build)

- **Substrate:** `wins_inc_iter` (`QUEENS_ITER`, throughput-parity, gated) — the explicit `IncFrame` stack
  materializes the frontier as data a producer can read ahead of the consumer. (A used recursive `wins_inc`;
  B needs the iterative stack so producers can see pending frames.)
- **Offload unit = a large prove-loss subtree.** Hand a producer the root of a subtree the consumer is about
  to search exhaustively (a node being *proven LOSS* searches **all** children — no cutoff to waste). Gate on
  `avail-pc ≥ θ` and subtree-size estimate so the SPSC latency amortizes (Phase-0a: few-consumer regime; the
  split-diagnostic from the work-stealing arc already measured pc-band subtree sizes — reuse it to pick θ).
- **Producer (idle core):** walk the offloaded subtree's pc-band frontier → gather `(ckey, cr, cf)` (the
  M_WAVE gather, lifted out) → **radix-sort by `cr`** (`ddd_bandwidth_bench` grounded the radix primitive) →
  **dedup adjacent** → pack into 1 MB-L2 cache-line-aligned SoA chunks (`route[]`/`fp[]`/`ckey[]`).
- **Consumer (hot core):** pull a chunk from the SPSC ring → prefetch-ahead depth 16–32 → probe back-to-back
  (the ~780 M/s sorted regime) → cut on a found LOSS → expand the misses (re-probe at use for freshness —
  cheap: the slot is sorted/warm) → publish boundary values to the shared TT → feed the next pc-band frontier
  back to the producers.
- **SPSC ring per producer→consumer link**, bounded (back-pressure when the consumer lags). Frontier owned by
  producers; TT shared lock-free exactly as today (deterministic puts ⇒ boundary publication is race-tolerant).
- **Core split:** few hot consumers + many idle producers, per Phase-0a (don't oversubscribe consumers). The
  ~14-core SOLO tail has ~10 cores of spare memory bandwidth — that's the producer pool.

### Open questions → proposed resolutions

- **Freshness vs dedup** (TT mutates mid-wave; a producer's dedup'd miss may become a hit): **re-probe at
  consume** — Phase-0a showed sorted/warm probes are cheap, and the producer's value was the sort+dedup+warm,
  not the probe verdict. Accept the rare stale re-expansion (measure it; the M_WAVE descent already re-probes
  at entry for this exact reason, with no measured re-expansion bump).
- **Offload threshold θ:** size it from the existing split-diagnostic (pc-band subtree sizes in the tail) +
  a Phase-2a measurement of prove-loss subtree frontier widths. Need a window where (SPSC + sort) < the
  sorted-stream saving on that subtree's probes.
- **Boundary-value publication race:** the TT's deterministic-put discipline already tolerates concurrent
  writers (proven by the ABDADA/steal builds). Verify under the producer/consumer pattern; no new mechanism.
- **DFS-residence break:** producers work one prove-loss subtree's plies at a time (not whole global plies —
  that's Approach C). Checkpoint/resume changes are scoped to the offloaded subtree, not the whole search.

### Phase 2 plan (sub-steps, each gated + revertible)

- **2a — size the offload (no solver change, cold). ✅ DONE (2026-06-20--12) — GO.** Built as a gated cold
  `M_SIZE` monomorphisation (`QUEENS_SIZE=1`, production byte-identical — the tap DCEs on every other MODE):
  it taps every `wins_inc` entry-probe and reports per-pc frontier width, a global HLL distinct (dedup
  ceiling), and a slot-sorted-locality sample. **Reframed from per-θ-subtree to a global probe-stream tap**
  — cheaper, safe (one tap line, no control-flow change), and decisive for the gate's two failure modes
  (frontier-too-narrow / dedup-too-low). The per-θ subtree breakdown (to pick θ for 2b) folds into 2b's
  design, informed by Phase-0a (≈4-consumer regime) + the work-stealing split-diag (pc-band subtree sizes).
  **Result (n=16): WAVE-off upper bound = 3.0 B probes · pc 13–21 = 88% · dedup 38.1% · 73% same-DRAM-row;
  WAVE-on residual (`QUEENS_SIZE=2`/`M_SIZE_WAVE`, what B offloads on top of the default) = 2.34 B probes ·
  dedup 27.1% · 62% same-row.** Gate **PASS** — even after the ETC cut the residual is wide + 27%-dedup-able +
  sorts to row-buffer locality. (Clean wave effect = the n=14 same-TT pair, dedup 31.7%→23.2%; the n=16 raw
  deltas are load-confounded, 12 GB vs 17 GB.)
- **2b-0 — slot-order descent (gated `M_WAVE_B`/`QUEENS_WAVE_B`) — ✅ DONE (2026-06-20--12): the move-ordering
  tax is +94% at n=16 ⇒ the sorted wave is CLOSED.** Reorder each node's children into TT-slot order before the
  standard descent (the cheapest in-solver isolation of the move-ordering tax). n=14 deterministic was a
  survivable-looking +13.3%, but the **trustworthy n=16 interleaved A/B (3-round) = 4.069 B vs 2.097 B nodes =
  +94%** (the n=14 proxy lied 7×). Move ordering is worth ~2× node reduction at scale; **no sorted-stream
  throughput gain survives +94% nodes ⇒ the in-DFS sorted wave AND the producer/consumer SPSC pipeline (which
  needs sorted *consumer* access) are dead.** Verdict SECOND, production byte-identical. `M_WAVE_B` gated-off.
  **Only the order-independent DEDUP half survives** → the L0 probe cache (2b-dedup below).
- **2b-dedup — L0 probe cache (gated `M_L0`/`QUEENS_L0`) — BUILT, measuring (2026-06-20--12).** The
  order-independent dedup that needs no reordering (no slot-order tax): a per-worker direct-mapped cache of
  solved `(route,fp)→val` in front of the flat TT (layered into `mtt_get`/`mtt_put` ⇒ identity for M_WAVE,
  production byte-identical). Serves recurring keys (transpositions + the M_WAVE ETC-then-descent re-probe)
  from L2/L3 AND survives TT eviction (L0 ⊆ TT). **n=16 A/B (`QUEENS_L0` toggle) — MEASURED-NEGATIVE: +6.0%
  cyc/node, −0.7% nodes (noise), +5.2% total cyc.** The TT already serves recent repeats warm from CPU cache,
  so the per-probe L0 access is pure overhead (warm-hit ~0); the eviction node-cut is ~0.7% (the only tax-free
  prize). **⇒ the tax-free dedup prize is ~0%; the 27% only materializes inside a sorted/batched frontier =
  the +94% tax. Both halves of Approach B are negative ⇒ Approach B is CLOSED** (the lever moves off the
  giant-root probe stream). `M_L0` gated-off (instructive negative).
- **2b-1 — producer/consumer SPSC split — ✗ CLOSED (not built).** It depends on sorted *consumer* access, which
  2b-0 measured at **+94% nodes** at n=16. Dead; not worth the SPSC build. (Kept here as the documented reason
  the heavy pipeline was never sunk — the de-risk did its job.)
- **2c — A/B + scale** — moot for the sorted wave (closed at 2b-0). The remaining A/B is the **L0 dedup**
  (2b-dedup): `QUEENS_L0` toggle, metric cyc/node + nodes; gate `solver_lineage_agrees` (n≤9) + n=16 SECOND;
  pull-its-weight (beat the M_WAVE default) or revert + record-negative.

### Phase 2b — the order-vs-cutoff tension (the load-bearing design point, resolved 2026-06-20--12)

The sorted-stream 5.7× **requires the consumer to access probes in slot order** (the wave); α-β wants **DFS
move-order**. They conflict. The two sub-prizes 2a measured separate cleanly along this axis:
- **Dedup (27% residual) is order-INDEPENDENT** — collapsing duplicate probes helps in any order. Cleanly
  realizable; the safe half of the prize.
- **Sorted-locality (62% row-hits) entangles with cutoffs.** At a prove-loss (AND) node every child is
  searched — **no cutoff to lose**, so the AND-ply children sort for free. At its prove-win (OR) descendants,
  taking children in **slot order instead of move order loses *move ordering*** (the node still returns the
  same verdict and still **cuts on the first found loss** — it is *not* cutoff-free) ⇒ the cost is **bounded
  extra expansion** (the move-ordering value), **NOT** the cutoff-free nimber recursion that 6.6×'d the parked
  [component-nimber DDD](proposal-2026-06-18-grouped-frontier-ddd.md). Whether the locality+dedup gain beats
  that move-ordering loss is the **empirical** question 2b-0 answers in one thread before any pipeline.

Design implication: **batch the wave at the prove-loss (AND) plies** (free to sort) and keep OR-descendant
expansion under the consumer's normal cutoff; the more the wave leans on AND-ply width, the smaller the
move-ordering tax. (This is also why B ≠ the parked DDD: DDD went cutoff-free globally; B keeps the boolean
cutoff and only reorders within it.)

**Kill criteria (fail fast):** 2a showed an amortizing θ (PASS). **2b-0** is the next gate — if a single-thread
sorted-frontier wave's move-ordering re-expansion exceeds its locality+dedup gain, the sorted-**locality** half
is closed and B retreats to a **dedup-only** variant (order-independent, no wave) — or the whole sorted-stream
family is banked negative. If 2b-0 is net-positive, 2b-1's SPSC is mechanical; its own gate is beat-the-default.

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

- **Phase 0a (microbench) — ✅ DONE (2026-06-20--10).** Threaded sorted-stream microbench; GREEN, ~780 M/s
  cap, few-consumer regime. (Phase-0b "size the pc-band frontier width" folds into Phase 2a below.)
- **Phase 1 (Approach A = `M_WAVE`) — ✅ DONE + PROMOTED TO DEFAULT (2026-06-20--10/11).** Fused in-DFS ETC;
  −16% nodes / −2.7% wall; iso-dense default (`QUEENS_WAVE=0` disables). Captured −4% of the −16% (prep on
  the critical path) — the gap is Phase 2's prize.
- **Phase 2a (offload sizing) — ✅ DONE (2026-06-20--12) — GO.** Gated cold `M_SIZE` (`QUEENS_SIZE=1`,
  pre-cut upper bound) + `M_SIZE_WAVE` (`QUEENS_SIZE=2`, post-cut residual B actually offloads) probe-stream
  tap. n=16 pre-cut: 3.0 B probes / pc 13–21 = 88% / dedup 38.1% / 73% same-row. n=16 **post-cut residual:
  2.34 B probes / dedup 27.1% / 62% same-row** — the ETC cut shrinks the offloadable stream −22% and trims
  dedup, but the residual is still wide + 27%-dedup-able + sorts to row-buffer locality ⇒ **B's prize
  survives on top of the default.** (Clean wave effect = the n=14 same-TT pair, dedup 31.7%→23.2%; the n=16
  38%→27% / 73%→62% deltas are load-confounded, 12 GB vs 17 GB.) Gate PASS. Production byte-identical; banked.
- **Phase 2b (build the pipeline) — NEXT (multi-session — decide scope with the user).** The gated
  `QUEENS_WAVE_B` producer (gather/radix-sort/dedup/pack) + bounded SPSC + streaming consumer (prefetch-ahead/
  probe/cut/expand) on `wins_inc_iter`, reusing the M_WAVE gather + the `mlp_bench` sorted-stream loop. Start
  ONE producer + ONE consumer.
- **Phase 2c (A/B + scale).** Interleaved n=16 A/B vs the M_WAVE default; metric cyc/node + wall + nodes.
  Gate as Phase 1, plus race-freedom of boundary publication; kill criteria in the detailed scope.
- **Phase 3 (Approach C / n=18):** separate track; fold into the grouped-frontier proposal with BuRR-frozen
  plies.

**Validation gate (every phase):** `solver_lineage_agrees` (n≤9 vs naive) + a fresh n=16 **SECOND** verdict.
iso-dense has no `--distinct` counter, so node-count changes (the dedup/probe-before-expand cut) are gate-safe
— the A/B metric is **cyc/node + wall** (interleaved, per the perf discipline; n=16 node count is ±18% noisy).
