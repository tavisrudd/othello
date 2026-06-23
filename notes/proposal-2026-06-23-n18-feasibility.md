# Proposal: Solving Non-Attacking Queens n=18 with iso-dense

## Status

Draft

## Problem

n=16 is solved (second player, ~23.4s search, iso-dense W17+skip18 default). The
standing goal is the next open board. **n=18 has never been run** — the current
binary cannot even represent it. We need: (1) a defensible runtime estimate for a
customized n=18 build on this box, (2) the limiting factor, and (3) the concrete
changes. This proposal records the analysis and the architecture decision (flat-TT
extension vs. a BuRR-backed archive), gated on a cheap de-risk probe.

## Context

**iso-dense in one paragraph.** DFS-resident alpha-beta over a flat lockless TT, with
a **dense W_K layer**: every node whose available-square count `pc ≤ K` (default
**K=17**) is resolved directly from the complete W0..W8 tables by a BMI2-`pext` child
sweep (`W_K(G)=∃v·¬W_{K-1}(G∖N[v])`) — no TT probe, no subtree expansion. The labelled
code is `K·(K-1)/2` bits (K=16→120 = u128; K=17→136 = 3 words; clamp 9..=20). Base
W0..W8 is **32 MiB and n-independent**. On top: degree-ordered getK, dynamic move
ordering+ETC, and **skip18** (pc==18 skips all TT work — ~100% cold, children all getK
leaves).

**Why memory stopped being the n=16 wall.** With the W17 collapse the deep tail is
**99.8% cold** — the TT barely earns hits and the search wall is **flat from 4–12 GB**,
so `MAX_TT_BITS` was dropped 31→30 (8 GiB; `bin/queens.rs:64`). n=16's searched set is
0.31 B nodes × 8 B = 2.5 GB, fits in RAM, eviction nearly free (re-exp ~1.0×). The
bottleneck is now the getK compute and the serial giant-root tail (51% core util), not
DRAM.

**Hard ceilings in the code.** `WORDS = 4` (256-bit mask) and `MAX_N = 16`
(`mod.rs:37,39`). `adj_row_pext` is hardcoded `&[u64;4]` (`iso_flat.rs:574`). The CLI
clamps `1..=MAX_N`. The dense code path tops out at 3 words / K=20.

**This box.** 26 GB RAM (16 GB free), 13 GB zram. A flat TT realistically tops ~16–20 GB.

**BuRR (prior work).** `iso-burr` solved n=16 in 29m23s / 4.32 B nodes / 14 GB
append-only archive, re-exp 1.15×, no OOM — but it searched **14× more nodes than
iso-dense** because it lacks the W_K collapse. BuRR bits/key: **~46–57 bits/key**
membership-carrying (fp≈44–55 needed for correctness on billions of out-of-set probes),
or **~1.1 bit/key value-only** *iff membership is known a priori* — which **ply-windowing**
provides (transpositions are strictly intra-ply, so freeze each solved ply value-only
with zero false positives). Eviction-free / append-only.

### The math (fresh anchors, production config)

Deterministic iso-dense node counts measured this session on the current binary:

| n  | iso-dense nodes | wall   | ratio n→n+2 | log₁₀ step |
|----|-----------------|--------|-------------|------------|
| 10 | 6,328           | 0.01s  | —           | —          |
| 12 | 43,445          | 0.03s  | ×6.87       | 0.837      |
| 14 | 2,781,227       | 0.35s  | ×64.0       | 1.806      |
| 16 | 307,608,950     | 23.44s | ×110.6      | 2.044      |

Log-step rises but **decelerates** (Δ +0.97 then +0.25) ⇒ n=16→18 step ~2.05–2.20 ⇒
**R(18) ≈ 110–200×, central ~150×**. Cross-check: embedded D4 distinct model gives
×46.6 (n14) and ×186 (n16 extrap.) — same regime, also rising.

**n=18 node count ≈ 34–77 B, central ~46 B** — *only if dense-K is raised to preserve
the collapse factor* (n=18's mid-game pc band sits higher than n=16's).

**Throughput.** n=16 = 13.1 M nodes/s (24 workers). n=18 per-node is slower from (a)
Bits 4→6 words (~+30–45% on the Bits-touching ops) and (b) a deeper getK sweep at the
higher sweet-spot K (~+15–40% on getK-heavy nodes). Net **~6–9 M/s, central ~7 M/s**.

| scenario     | nodes | M/s | **wall**   |
|--------------|-------|-----|------------|
| optimistic   | 34 B  | 9   | ~63 min    |
| **central**  | 46 B  | 7   | **~1.8 h** |
| pessimistic  | 62 B  | 6   | ~2.9 h     |
| tail-risk    | 77 B  | 5   | ~4.3 h     |

**~2 hours, range 1–4 h — *conditional on memory not binding*.**

### The conditional memory wall (the crux)

46 B distinct keys as a flat TT = **~368 GB ≫ 26 GB**. n=16 only fit because its
searched set is 2.5 GB and the cold tail makes eviction free. Two readings of the n=18
tail coexist in the handoffs and they disagree:

- **Cold/tree-like** (the `tt_bits` "99.8% cold, flat 4–12 GB" observation): a modest
  8–16 GiB flat TT suffices, cold-never-requeried entries evict for free, re-exp ~1.0×.
  ⇒ ~2 h, no BuRR.
- **Transposition-saturated** (the parallelism handoffs: "the work that would fill idle
  cores is shared transpositions"): n=16's re-exp ~1.0× holds *only because the TT holds
  the whole searched set*; at n=18 it can't, so evicted transpositions re-expand ⇒ re-exp
  2–5× + zram thrash ⇒ wall balloons toward days.

Both can be locally true (cold frontier band at pc 17–18, transposing OR-spine at pc≥19).
**This is the single biggest uncertainty in the estimate**, and it is exactly what the
de-risk probe resolves.

---

## Approach A: Flat-TT iso-dense extension

Widen the representation, raise the dense ceiling, run on a modest flat TT. Bets that
the cold-tail property holds at n=18.

### Architecture

1. **Representation.** `WORDS 4→6` (384 bits ⊇ 324 squares), `MAX_N 16→18` (`mod.rs`).
   Thread `[u64;6]` through `adj_row_pext` (`&[u64;4]`→`&[u64;6]`), att/order tables,
   `hash128`, canon (`lex_min8`/`d4_bits`). Mechanical but pervasive; this is the
   ~1.5× per-node tax. The const-asserts and `Bits` ops already loop over `WORDS`.
2. **Dense ceiling.** Raise `dense_k` clamp past 20 and widen the labelled code beyond
   3 words: **K=23 needs 4 words (253 bits), K≤25 needs 5 words**. Extend
   `get_dyn_wide`/`warm_wide`. Base W0..W8 unchanged. Sweep K for the n=18 wall minimum
   (sweet spot likely ~21–23; too-high K work-conserves into a flat/worse wall).
3. **TT sizing.** Add `DISTINCT_POSITIONS[18]` or set `QUEENS_TT_BITS`; keep an 8–16 GiB
   flat TT. Watch re-exp with `--distinct` on n=14/partial-n=16 proxies.

### Trade-offs

**Strengths:**
- Smallest delta from the shipping default; no new TT architecture.
- Keeps the full iso-dense node-collapse (the 14× edge over iso-burr).
- If the cold tail holds: **~2 h, done.**

**Weaknesses:**
- **Fails hard if the tail transposes** (Scenario B): re-exp blowup + zram thrash, no
  graceful degradation — the run just gets pathologically slow.
- No checkpoint/resume; a 2–4 h (or worse) run is all-or-nothing on a box that
  thermally throttles and is shared with the user's interactive work.

---

## Approach B: iso-dense + BuRR ply-windowed archive

Keep the W_K collapse, but back the transposition store with an **eviction-free,
value-only, ply-windowed BuRR archive** instead of the flat TT. Robust against any
n=18 transposition density.

### Architecture

1. All of Approach A's representation + dense-ceiling changes (those are unconditional).
2. **Restructure the DFS into ply-ordered passes.** Solve ply-by-ply so membership is
   known a priori; freeze each solved ply value-only (fps=0, ~1.1 bit/key). Query only
   in-set keys ⇒ zero false positives, no fingerprint needed.
   - 46 B keys × 1.1 bit ≈ **~6 GB — fits comfortably**, eviction-free (re-exp ~1.0–1.15×).
   - (Membership-carrying BuRR is **not viable**: 46 B × ~50 bits ≈ **~290 GB**.)
3. Reuse the existing append-only segment + cap + per-segment Bloom machinery (`burr.rs`,
   `store.rs`) — already shipped and validated at n=16 scale.

### Trade-offs

**Strengths:**
- **Eviction-free** ⇒ re-exp stays ~1.0–1.15× regardless of node count; the memory wall
  is gone by construction.
- Fits the full distinct set in single-digit GB; natural checkpoint/resume boundary
  (freeze = durable progress).
- Combines the two best assets — iso-dense's collapse + BuRR's footprint — a pairing
  that **doesn't exist yet**.

**Weaknesses:**
- **Per-node throughput drops** (iso-burr ran ~2.5 M/s vs iso-dense 13 M/s; even after
  the dense collapse, the archive probe + Bloom is heavier than a flat-TT load). The
  node-count win must outrun the per-node loss.
- **Significant restructure**: the DFS-resident kernel must become ply-ordered, which
  fights the dynamic move ordering and the giant-root parallelism. Non-trivial, likely
  multi-session.
- Only pays off if the tail actually transposes; over-engineering if Scenario A is true.

---

## Approach comparison

| Criterion                  | A: Flat-TT extension        | B: BuRR ply-windowed archive    |
|----------------------------|-----------------------------|---------------------------------|
| Representation work        | Required (shared)           | Required (shared)               |
| Dense-ceiling work         | Required (shared)           | Required (shared)               |
| New TT architecture        | None                        | Ply-ordered DFS + value archive |
| Memory footprint           | 8–16 GiB flat (may evict)   | ~6 GB archive (eviction-free)   |
| Re-exp risk                | **Unbounded if tail DAGs**  | ~1.0–1.15× by construction      |
| Per-node throughput        | ~7 M/s                      | lower (archive + Bloom probe)   |
| Checkpoint/resume          | No                          | Yes (freeze boundary)           |
| Effort                     | Days                        | Multi-session                   |
| Best case wall             | **~2 h**                    | slower per node, but safe       |
| Worst case wall            | **days (thrash)**           | bounded                         |

The two share **all** the representation and dense-ceiling work. They diverge **only**
on the transposition store — and the right choice there is an empirical question, not a
judgment call.

---

## De-risk probe (decides A vs B)

**Question:** does the iso-dense deep tail (pc≥19) transpose enough that, once the
searched set exceeds RAM, re-expansion blows up?

**Method — re-expansion vs TT size on n=16 (already runnable today):**
1. Run n=16 iso-dense at a sweep of `QUEENS_TT_BITS` from where it comfortably holds the
   searched set down toward starvation (e.g. 2^31 → 2^30 → 2^29 → 2^28 → 2^27).
2. At each size record **node count** (re-exp = nodes / nodes-at-largest-TT) and **wall**.
3. **Tap the pc≥19 band specifically**: extend the existing per-pc put/hit histograms
   (`pc_hist`, the `M_HITKEY`/`rank` taps already present) to emit **hit-rate by
   popcount** so we see whether pc≥19 probes start missing (eviction) as the TT shrinks,
   vs the pc 17–18 frontier staying cold regardless.

**Interpretation:**
- **Re-exp curve stays ~flat** as TT shrinks (the "flat 4–12 GB" already seen, extended
  lower) ⇒ tail is tree-like ⇒ **Approach A**: n=18 runs on a modest flat TT, ~2 h.
- **Re-exp climbs steeply** below some size, and pc≥19 hit-rate collapses with it ⇒ the
  tail transposes ⇒ at n=18 (searched set ≫ RAM) this is unavoidable ⇒ **Approach B**.

The probe is **node-count instrumentation on the existing n=16 solver** — no n=18 code,
no new architecture. It costs a handful of n=16 runs (minutes each at small TT, the PV
scan aside) and directly predicts the n=18 memory regime.

---

## Open questions

- **n=18 sweet-spot K** and its getK cyc/node cost — only measurable after the Bits/code
  widening; the node-count estimate assumes K rises enough to preserve the collapse.
- **R(18) tail risk** — the log-step could re-accelerate; 77 B (R=250) is the planning
  ceiling. Worth re-deriving once a partial n=18 (single deep root) is runnable.
- **Wider-Bits per-node tax** — assumed ~1.5×; measure on n=14/n=16 with `WORDS=6`
  compiled in (the n≤16 results must stay byte-identical, only slower).
- **Parallel tail at n=18** — the single giant root grows; effective throughput could be
  worse than the 7 M/s central. The DFS-parallelization route is already CLOSED
  (handoffs); the only lever left there is the node-count one (raise K).
- **Checkpoint/resume** — a 2–4 h+ run on a shared, thermally-throttling box wants it;
  Approach B gets it free at freeze boundaries, Approach A would need bolt-on.

## Recommendation

**Do the shared work, run the probe, then pick the store.** Concretely:

1. **Approach A's unconditional changes first** (Bits 4→6, MAX_N→18, dense-code 4–5
   words, K sweep) — these are needed by *both* approaches and unlock partial-n=18
   measurement.
2. **Run the de-risk probe on n=16** *before* committing to a store architecture. It is
   cheap, runnable today, and is the only thing that separates "~2 h on a flat TT" from
   "needs the BuRR restructure."
3. **Branch on the probe:** flat-TT (A) if re-exp stays flat; the BuRR ply-windowed
   archive (B) if it climbs.

Justification:
1. The representation + dense-ceiling work is **identical** for both stores, so it's
   never wasted — start there and keep the decision open.
2. The A-vs-B choice hinges on **one measurable property** (deep-tail transposition
   density) that we can read off n=16 today, not on taste — so measure it, don't guess.
3. Approach A's failure mode (thrash → days) is **silent and catastrophic**; the probe
   converts that into a known-before-you-run quantity for a few minutes of n=16 runs.
4. BuRR's value-only ply-windowed mode (~6 GB) is the **only** representation that fits
   n=18's distinct set in this box's 26 GB — so if the probe says "transposing," B isn't
   one option among many, it's the path. Knowing that early shapes the whole effort.

### Implementation phases

- **Phase 0 (now, no n=18 code): de-risk probe.** Add per-pc hit-rate to the existing
  histogram taps; sweep `QUEENS_TT_BITS` on n=16; plot re-exp + pc≥19 hit-rate vs TT
  size. Output: A-or-B decision.
- **Phase 1 (shared): representation.** `WORDS 4→6`, `MAX_N 18`, thread `[u64;6]`.
  Gate: n≤16 verdicts byte-identical (only slower); `solver_lineage_agrees`, n=12
  distinct exact 1,060,823, n=14 distinct ≈29.2M re-exp ~1.0×.
- **Phase 2 (shared): dense ceiling.** Widen labelled code to 4–5 words, raise `dense_k`
  clamp, sweep K on n=14 + partial n=16 for the wall minimum.
- **Phase 3a (if A): flat-TT n=18.** Size the TT, add `DISTINCT_POSITIONS[18]`, run a
  single deep root to validate throughput + re-exp, then HLL-size and launch with the
  harness monitor/mem-guard.
- **Phase 3b (if B): BuRR ply-windowed.** Restructure the kernel into ply-ordered passes
  over the value-only archive; validate eviction-free re-exp on n=14/16; then n=18 with
  freeze-boundary checkpoint/resume.
- **Throughout:** real n=18 is hours-to-days — size with HyperLogLog first, never a
  speculative full launch; verdict cross-checks against Jenrich (n=18 unknown — this
  *is* the contribution).
