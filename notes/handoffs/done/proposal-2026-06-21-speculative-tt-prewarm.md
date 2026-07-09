# Proposal — Speculative TT pre-warm (side-effect-only future-subtree solvers on idle cores)

**Date**: 2026-06-21
**Status**: DESIGN ONLY (not implemented). Decide with the user before any build.
**Thread**: [explicit-stack frontier](handoffs/2026-06-19-explicit-stack-frontier.md) parallelism-deficit lever.
**Premise (user):** the n=16 wall is ~94% **one giant root running single-threaded as a tail**, ~23 cores idle
(`QUEENS_ROOT_TIMING`: tail root idx 29 ran 91.7 s / ended 97.9 s, SOLO for the last 17.5 s; longest root = 94%
of wall). Launch 3–4 **speculative pre-warm workers** on the idle cores that compute regions of that root's
search tree the main worker will reach later, and **populate the shared TT as a pure side effect** — results
ignored, no value returned, no effect on the main worker's control flow or move order. When the main DFS later
descends those subtrees, its probes hit warm (already-solved) entries instead of cold-computing them.

---

## TL;DR verdict (read this first)

**Likely WASHES or goes mildly NEGATIVE as the obvious build; one narrow variant *might* pay and is worth a
single cheap measurement before any code.** The mechanism genuinely escapes the +94% re-expansion trap that
killed every prior parallelization lever — it does not divide the search, so the main worker's node SET and
order are unchanged. But it does not escape the **memory wall**, which is the actual binding constraint:

1. **Memory-throughput Fermi (the killer).** The memory subsystem saturates at **~780 M/s probes with 4–8
   streaming cores** (Phase-0a microbench, `tt.rs::mlp_probe_threads_sweep`). The solo-tail main worker probes
   at **~7–15 M/s** (one latency-bound random DRAM chain, ~165 cyc/probe ≈ 60 ns exposed; `wins_inc` 27% of
   cycles, two-thirds of that the post-load stall). 3–4 speculative cores each doing random-DRAM probes/writes
   add **hundreds of M/s** of memory traffic. That is far from the 780 M/s bandwidth ceiling, so we will not
   *bandwidth-saturate* — but **latency-under-load rises before bandwidth saturates**, and the main worker is
   pure exposed latency. Even a modest per-probe latency penalty on the main worker cancels the warm-hit
   savings, because the win is bounded by **how many of its probes are cold *and* arrive before the speculative
   thread warms them** — a small fraction (see Fermi §3).

2. **The headroom may not exist.** The win requires the main worker's tail probes to be substantially **cold**
   (currently recomputed). But the tail is **transposition-saturated** (the finding that killed ABDADA /
   work-stealing). The whole reason the work resists parallelization is that the idle-core-fillable work is
   *shared transpositions* — which means a large fraction of the main worker's tail probes **already hit warm**
   (its own earlier visits + sibling roots populated the TT). If most tail probes are already warm, there is
   nothing to pre-warm. **This is the single thing to measure first** (§7): the main worker's **cold-probe
   fraction by pc in the tail**. If it is low, the lever is dead on arrival, for ~0 build cost.

3. **Target prediction is hard and the timing rarely lines up.** A subtree big enough that warming it saves
   real DRAM is big enough that the speculative thread takes ~as long as the main worker would — so it warms
   nothing *in time*. The lever can only pay for **medium** subtrees (big enough to matter, small enough to
   finish ahead), and only if those subtrees are reliably **on the main worker's actual path** (mispredicted
   targets are pure pollution + wasted traffic). The deterministic-future framing is real (DFS state generates
   the frontier), but "far enough ahead to complete, near enough to be reached" is a thin window.

**Recommendation:** run the **one cheap de-risk measurement** (§7) — extend the existing `M_PROF`/`M_SIZE` tap
to report the giant-root tail worker's **cold-probe (miss) fraction by pc**, plus a re-probe-latency-under-load
spot check. **Kill the lever if the tail cold-probe fraction is below ~25–30%** (no headroom) — the most likely
outcome. Only if it is high does the targeting/timing design (§4–5) become worth building.

This is the **compute-based cousin** of the parked **"predict EXACT keys to prefetch deeper future probes"**
note (--16 handoff): both exploit that the DFS state deterministically generates the future. Prefetch warms the
*cache line*; this warms the *computed value*. The prefetch variant is strictly cheaper (no recompute, no
eviction, no extra core) and should be preferred if the future-key prediction proves tractable — see §8.

---

## 1. Why this is genuinely different from the 5 CLOSED parallelization levers

The handoff documents five failed DFS-parallelization approaches — **ABDADA in-flight markers**, **frontier
work-stealing** (rayon-scope publish of even-frame children), **finer root-split (B1)**, **adaptive-tail**,
**warm-restart** — all measured NEGATIVE. The diagnosed root cause is identical across all of them:

> The giant-root tail is **transposition-saturated**. The work that would fill the idle cores is *shared
> transpositions*, so splitting/stealing it **duplicates** (re-expansion). Tuned work-stealing = **+8.7% nodes
> / +13.3% wall**; the slot-order sorted wave = **+94% nodes** (move ordering is worth ~2×; any frontier
> reorder forfeiting it costs ~2× nodes).

**The user's framing escapes this trap on the node-count axis, and that part is correct:**

- Every prior lever **divides the search** (steals/splits/reorders the frontier the main worker owns) →
  forces re-expansion or forfeits move ordering.
- This lever **does not divide the search.** The main worker runs its *exact* DFS, in its *exact* move order,
  expanding its *exact* node set. The speculative threads run a **disjoint, throwaway** computation whose
  *only* effect is TT writes for keys the main worker will independently look up.
- So **the main worker's node SET and order are provably unchanged** (the TT is replace-always and
  fingerprint-validated; a warm hit returns the *same deterministic verdict* the cold expansion would have
  computed — see §6). It cannot increase the main worker's nodes the way stealing does. The +94% / +8.7% taxes
  **cannot occur**.

**But it does NOT escape the memory wall**, which is the *actual* binding constraint on the tail
(memory-latency-bound + transposition-bound, per the post-W12 re-anchor: backend-memory 30% + frontend 31%).
The prior levers died on the node-count axis *and* would have hit the memory axis; this one clears the
node-count axis but the **memory axis is now the whole game**. That is the honest reframe: this lever moves the
cost from "re-expansion" (where it was fatal) to "memory-controller occupancy + eviction" (where it is *also*
likely fatal, but for a different, measurable reason). The rest of this proposal quantifies that.

---

## 2. The four hard questions, answered

### Q1 — Target selection: how do speculative threads pick subtrees the main worker WILL reach?

**The deterministic future is real but lives in the main worker's live recursion frames.** The production deep
solve is the *recursive* `wins_inc` (`iso_flat.rs`); its frontier is hidden in the native call stack — not
inspectable. The pending (not-yet-recursed) moves at its **shallow stack frames** are exactly the subtrees it
*will* visit, in a known order (its dynamic move ordering, `sort_moves_by_degree`, fixes the order at each
node). A move still pending at shallow depth d is far ahead in wall-time (the main worker must finish all
earlier-ordered siblings' subtrees first) but **certain to be reached** (α-β only skips a sibling on a cutoff;
at an OR node a cutoff means the node already won and the main worker *leaves the subtree entirely* — so a
pending shallow move is only skipped if an earlier sibling wins the node, in which case warming it was wasted).

**This is the crux of the targeting difficulty:** the *best* targets (high reach-probability) are the moves at
the **deepest** still-live frame (next to be expanded) — but those are *seconds* away, not minutes, so warming
them barely beats the main worker there. The *highest-value* targets (warming saves the most DRAM) are at
**shallow** frames (huge subtrees, far ahead) — but a shallow pending move has the **highest miss-probability**
(an earlier sibling may cut the node first, and the subtree is so big the speculative thread can't finish it in
time anyway). **Reach-probability and value are anticorrelated** — the thin window §0 named.

**Reading the live frame stack — two options:**

- **(a) The recursive `wins_inc` cannot expose its frame stack** (it's the native call stack). To make the
  frontier inspectable you must run the **explicit-stack `wins_inc_iter`** (gated `QUEENS_ITER`, throughput-
  neutral; `IncFrame` / `INC_STACK` arena). **This is the enabler the user asked about** — it *materializes*
  the frontier as `Vec<IncFrame>`, each frame carrying `(orient, key, route, fp, moves_start, nmoves, mi,
  depth)`. A speculative thread could read a snapshot of the main worker's arena's shallow frames, take a
  pending move (`moves[moves_start + mi ..]`), reconstruct the child position via `child_orient` + `d4_bits ∘
  lex_min8`, and solve it. **But:** the arena is `thread_local!` (`RefCell<IncArena>`) — not shareable as-is;
  exposing it needs an `UnsafeCell` / raw-pointer snapshot the speculative threads read torn (acceptable —
  a torn frame read just produces a wrong target = wasted work, not a correctness bug; §6). And `wins_inc_iter`
  is currently a measured wash carried only as substrate; making it the production path is its own gate.

- **(b) Side-step the live stack entirely — re-derive the future from the root.** The targets do not *have* to
  come from a live snapshot. The giant root is identified at runtime (`QUEENS_ROOT_TIMING`'s slow-root signal,
  or the warm-restart `warm_done` flags). A speculative thread can **independently re-run the root's move
  ordering one or two plies deep** (cheap — `distinct_first_moves` then `sort_moves_by_degree` per node, no
  subtree expansion) to enumerate the same shallow frontier the main worker will walk, and pick targets from
  *band 2–4 plies down* by a fixed policy (e.g. "the k-th pending move at depth 2"). This is **decoupled** from
  the main worker (no shared-stack hazard, no `wins_inc_iter` dependency) and deterministic (same ordering ⇒
  same frontier). It trades precision (it doesn't know the main worker's *current* `mi`, so it may target
  already-done or about-to-be-cut subtrees) for simplicity and safety. **Recommended starting point** if the
  lever survives the §7 measurement.

### Q2 — The memory-bandwidth killer (the main risk). Fermi against the 780 M/s ceiling.

**The numbers:**

| quantity | value | source |
|---|---|---|
| memory-subsystem probe-throughput ceiling | **~780 M/s** (4–8 streaming cores) | Phase-0a `mlp_probe_threads_sweep` |
| single random-stream throughput, depth-1 | ~48–89 M/s | same (random d1, 1–2 threads) |
| exposed per-probe DRAM latency (tail) | ~165 cyc ≈ **~60 ns** | `wins_inc` cost map; `mlp` ~120 ns full chain |
| main solo-tail worker probe rate | **~7–15 M/s** | one latency-bound chain, half-hidden by 1-ahead prefetch |
| 3–4 speculative cores, random probes+writes | ~150–350 M/s aggregate | scaling from the microbench |

**Fermi:** 3–4 speculative cores add ~150–350 M/s to the ~7–15 M/s the main worker contributes — total
~200–400 M/s, **well under the 780 M/s bandwidth ceiling.** So we will **not bandwidth-saturate.** Good news?
No — because **the main worker is pure exposed latency, and latency-under-load degrades before bandwidth
saturates.** On this 2-CCX box, concurrent random-DRAM streams from other cores raise the memory-controller
queue occupancy, and a latency-bound consumer's per-access time rises roughly with queue depth well below peak
bandwidth. The microbench shows random aggregate *throughput* climbing 48→266 M/s over 1→8 cores — but that is
because each *added core* adds its own latency chain; the *per-probe latency of any one chain* gets **worse**
under that contention (the 8-core random number is throughput-up but per-stream latency-down). The main worker
is exactly one such chain, and it cannot add MLP to hide the degradation (a DFS is one-probe-ahead).

**The break-even:** let the main worker's solo probe cost be `L` ns and let speculative contention raise it to
`L·(1+δ)`. Let `f` = fraction of the main worker's tail probes that are **(cold AND warmed-in-time)** by
speculation. The main worker's tail time scales as `(1 - f)·L·(1+δ) + f·L_warm·(1+δ)`, where `L_warm` is a warm
hit (L1/L2-resident, ~5–15 ns vs ~60 ns DRAM). The lever **pays iff** the warm-hit savings on the `f` fraction
beat the `δ` latency tax on the `(1-f)` cold fraction:

```
f · (L - L_warm)   >   δ · L · (1 - f) + δ · L_warm · f
≈  f · (60 - 10)   >   δ · 60 · (1 - f)        [ns, dropping the small warm term]
```

For a plausible `δ ≈ 0.10–0.20` (10–20% latency-under-load penalty from 3–4 contending streams, conservative
given the box's measured Infinity-Fabric sensitivity — the per-node node-counter atomic alone measured a ~2×
drag), the lever needs **`f ≳ 0.10–0.20`** just to break even, and meaningfully more to be worth the
complexity. **`f` is the product of three fractions all < 1:** (cold-probe fraction in the tail) × (fraction of
those the speculation targeted correctly) × (fraction warmed *before* the main worker arrived). Even
optimistic factors (0.4 × 0.5 × 0.5) give `f ≈ 0.10` — **right at break-even, with a real downside if any
factor is worse.** This is why the verdict is "likely washes."

### Q3 — TT eviction / pollution budget.

The TT is **flat lockless replace-always** (`put_hashed` = blind `store`; no depth/age preference). Every
speculative write is a **write-allocate** (cold DRAM read to bring the line) **and** unconditionally evicts
whatever shared that slot. Pollution math:

- **Reuse ceiling = 26.9%** (--16 sidecar finding); at n=16 the working set collapsed to ~2.8 GB and the
  production 17 GB TT is only **16.5% full** under W16 (TT 16.5% full, handoff). **At 16.5% load, blind
  eviction of a *random* slot rarely hits a live entry** — the table is mostly empty, so a speculative write
  to a key the main worker never reaches mostly lands in cold space. **This is the one piece of genuine good
  news:** the collapsed working set means eviction pollution is *cheap right now* (it was the dominant risk at
  the old 17 GB-tight / 70% fill regime; W16 defused it). A mispredicted speculative write costs its own
  write-allocate DRAM traffic (feeds Q2's `δ`) but rarely evicts a *needed* entry.
- **BUT** every speculative write — predicted or mispredicted — is **write traffic that competes for memory-
  controller occupancy** (Q2). The eviction-of-critical risk is low; the **occupancy-cost risk is the same δ
  tax** whether or not the write evicts anything live. So pollution-as-eviction is *not* the binding budget
  here (W16 fixed it); **pollution-as-occupancy is**, and it is already counted in Q2.
- **Admission control (if built):** write only for **pc-band 13–18** (where the tail recomputes live, per
  `M_SIZE`: pc 13–21 = 88% of the recurse-arm stream) and **only for confirmed-future targets** (option (b)'s
  re-derived frontier, not speculative deepening past the predicted band). Never write pc < 9 (getK resolves
  those table-free; no TT entry needed) — a speculative write there is pure pollution with zero possible hit.

### Q4 — Timing: can a speculative thread finish a subtree before the main worker reaches it?

**Only for medium subtrees.** The tail subtrees are huge *because* they are slow — a speculative thread solving
the same subtree takes ~the same wall time as the main worker would, so it warms nothing in time (it finishes
*as* the main worker arrives, or later). The lever pays only in the band where:

- the subtree is **big enough** that the main worker would spend ≥ (speculation lead time) cold-computing it
  (so the warm hit saves real DRAM), **and**
- **small enough** that a single speculative core finishes it within the lead window (the main worker is busy
  with earlier-ordered siblings).

For a shallow target T plies ahead, the lead time is "main worker finishes all subtrees ordered before T at
this frame" — which for a slow root is *large* (minutes), but T's own subtree is then *also* large (it's a
shallow sibling of the giant tail), so the speculative core can't finish it. For a deep target (1–2 plies
ahead), the lead is *seconds* and the subtree is *seconds* — a closer match, but the saved DRAM is small (a few
seconds of probes) and the main worker is about to compute it warm anyway (its own recent siblings populated
nearby TT). **The productive band is narrow and its per-target payoff is small**, which is why several
speculative cores would be needed to aggregate a meaningful win — multiplying the Q2 contention tax.

---

## 3. Concrete mechanism (if built)

**Spawn model — reuse the existing rayon scope + slow-root signal; do NOT add a thread pool.**

1. **Detect the tail regime.** Reuse the warm-restart `warm_done[]` flags / `QUEENS_ROOT_TIMING` slow-root
   detection (already in `first_player_wins`). When `root_done` shows ≤ 2 roots remaining (`deep_busy <
   n_threads`, the existing idle-core proxy used by work-stealing), the box is in the solo/near-solo tail.
2. **Launch the speculative producers off the rayon scope** that already wraps the root fan (`rest.par_iter()
   .any(...)`), or a dedicated `rayon::spawn` set, gated `QUEENS_PREWARM=1` → a `const PREWARM: bool`
   monomorphisation (per the per-node-toggle rule: resolved once, never per node). 3–4 producers
   (`QUEENS_PREWARM_CORES`, default 3).
3. **Target enumeration (option (b), recommended):** each producer independently re-derives the giant root's
   shallow frontier — `distinct_first_moves` → `sort_moves_by_degree` to depth 2–3 (no expansion), enumerating
   the same ordered child positions the main worker will walk. Partition the depth-2/3 pending moves across the
   producers (producer i takes moves ≡ i mod cores). Skip the first ~k moves at each frame (the ones the main
   worker is likely already past / about to cut) — `QUEENS_PREWARM_SKIP`, default 2.
4. **Solve + side-effect-write.** Each producer calls the **same** `wins_inc` (or `wins_inc_iter`) on its
   target child, **ignoring the bool result**. The verdict lands in the shared TT via the normal completing
   `put_hashed` — *that is the entire mechanism.* No queue, no coordination, no return path. Admission-control
   the writes to pc 13–18 if §7 shows lower bands are already warm.
5. **Bounded, abortable.** A producer that out-runs the main worker (its target already warm when it probes)
   skips to the next target (cheap — it's a TT hit). Producers stop when the tail root completes (the search
   returns). Per-producer node tallies flushed via `flush_local_nodes` (they ARE real searched nodes — they
   count toward total work but not toward the verdict).

**What this reuses (low build cost):** the rayon scope, the slow-root/idle-core signals, `wins_inc` itself,
the `child_orient`/`d4_bits`/`lex_min8`/`hash128` child-key machinery, the const-generic MODE gating pattern.
**What is new:** the target enumerator (option (b) re-derivation, ~50 lines), the `PREWARM` gate, the
admission-control band filter. **Hazard to avoid:** if a producer uses `wins_inc_iter` with ABDADA markers it
must NOT write `IN_FLIGHT` for its targets (the main worker's `tt_get_h` would misread `0xFF` as a win in the
non-ABDADA production path — the one real correctness hazard, §6). Producers write only **completed verdicts**,
never partial/in-flight markers.

---

## 4. Correctness / safety — confirmed SAFE, with one named hazard

**Side-effect-only is safe by the TT's existing construction.** The TT tolerates torn reads, foreign writes,
and races by design: a fingerprint mismatch → miss → recompute; a same-key write stores the *same* deterministic
value (a position's win/loss is fixed). A speculative producer computes the **identical** verdict the main
worker would (same `wins_inc`, same deterministic game value), so a completed speculative entry is **always
correct** — a warm hit on it returns the right answer. Torn/partial speculation is fine (a half-written slot
fails the fingerprint check or is simply re-derived). Mispredicted targets waste work but cannot corrupt.

**The one real hazard: the `IN_FLIGHT` / partial marker.** `Slot::IN_FLIGHT = 0xFF` is the ABDADA sentinel.
The **production path is non-ABDADA** — `tt_get_h` reads `val()` directly and would interpret `0xFF` as `val
!= 0` ⇒ **a spurious WIN** (a wrong verdict the main worker would propagate). **Mitigation:** speculative
producers must write only via the plain `put_hashed` (completed verdict ∈ {0,1}), **never** `mark_inflight_*`.
With option (b)'s re-derivation + plain `wins_inc` (which never writes `IN_FLIGHT`), this hazard does not arise
— it would only appear if a future variant reused the ABDADA-marking `wins_inc_iter` path. Gate test: a
`QUEENS_PREWARM=1` run must match the `naive` verdict on n≤9 (`solver_lineage_agrees`) and SECOND at n=12/14.

---

## 5. The single cheapest de-risk measurement (do this FIRST; ~0 solver risk)

Follow the established gated-tap pattern (`M_SIZE`/`M_PROF`/`M_RANK`/`M_DECPROBE`: a `const MODE`
monomorphisation selected once per subtree handoff, per-worker accumulators, cold drain + report, production
byte-identical because the tap DCEs on every other MODE). **Add `M_COLD` / `QUEENS_COLD=1`** (a measurement
twin of `M_ORD_W`, like `M_RANK` already is — same production search path, plus a cold tally):

**Measure the giant-root tail worker's COLD-PROBE FRACTION by pc.** At every `wins_inc` entry probe, tally
`(node_pc, hit?)` into a per-worker `[hits; misses]` array. The existing `M_SIZE` recency-cache report **already
isolates the slowest-root worker** (it sorts per-worker accumulators by probe count and prints "worker rank 0 ←
slowest root / giant-root tail"). Reuse that exact attribution: report, **for the rank-0 (giant-tail) worker
only**, the **miss% by pc band** over the late phase of the run (or gate the tally to fire only after
`root_done` shows ≤ 2 roots remaining — the solo tail).

- **The number that decides the lever:** in the tail (pc 13–18), what % of the giant-tail worker's entry probes
  **MISS** (= cold-compute, the warmable work)?
- **Kill-criterion:** if tail miss% < ~25–30%, **the lever is dead** — most tail probes already hit warm (the
  transposition-saturation that killed the other levers also means there's little cold work to pre-warm), so
  even perfect speculation (`f` capped by this fraction, then cut further by mis-targeting + timing) can't
  beat the Q2 `δ` tax. Stop here, record the negative, ~0 build cost.
- **Go-criterion:** if tail miss% is high (≳ 40%) **and** concentrated in a learnable band, the headroom exists
  — proceed to a second cheap probe (below) before building the producers.

**Second cheap probe (only if the first passes) — realized latency-under-load `δ`.** Before building the full
producer, measure `δ` directly: extend `mlp_probe_threads_sweep` (or a one-off) to run **one latency-bound
single-probe-ahead "main worker" chain** while **3 other cores stream random probes**, and report the
single-chain ns/probe **with vs without** the 3 contending cores. That is `δ` measured on the real box/TT. Plug
it into the §2-Q2 break-even with the measured tail miss%: if `f·(L−L_warm) ≤ δ·L·(1−f)` even at optimistic
targeting/timing factors, **kill**. This is the "channel-Fermi against the bench, not the napkin" discipline —
the whole lever is a race between `f` (measurable now) and `δ` (measurable now), so measure both before any
producer code.

**Both taps are cold, gated, production byte-identical (DCE), and reuse drain/report scaffolding already in
`iso_flat.rs`** — total build is ~1 accumulator struct + ~2 report functions, mirroring `M_RANK`.

---

## 6. Fermi verdict

| axis | verdict |
|---|---|
| **node-count (re-expansion)** | **CLEARED** — side-effect-only does not divide the search; main worker's node set + order provably unchanged. Escapes the +94%/+8.7% trap. |
| **eviction pollution** | **LOW RISK now** — W16 collapsed the working set to 16.5% TT fill; blind eviction rarely hits a live entry. (Was the dominant risk pre-W16; defused.) |
| **correctness** | **SAFE** — speculative entries are deterministically correct; one named hazard (`IN_FLIGHT` marker) avoided by writing only completed verdicts via `put_hashed`. |
| **memory occupancy / latency-under-load** | **THE KILLER (likely).** 3–4 random-DRAM speculative streams add ~200–400 M/s (under the 780 ceiling, so no bandwidth wall) but raise the solo main worker's exposed per-probe latency by `δ`. Break-even needs `f ≳ 0.10–0.20`; `f` is a product of three sub-unity factors and is likely ~0.10 = washy. |
| **headroom (cold fraction)** | **UNKNOWN — the deciding unmeasured number.** Transposition-saturation suggests the tail is largely warm already (low cold fraction ⇒ no work to pre-warm). §5 measures it for ~0 cost. |
| **targeting + timing** | **THIN window** — value (shallow, huge subtrees) and reach-probability/finish-in-time (deep, medium subtrees) are anticorrelated. |

**Overall: likely WASHES or mildly NEGATIVE as built.** The mechanism is *correct* and *cleverly sidesteps the
re-expansion trap*, but it relocates the cost onto the memory axis where the tail is already bound, and its
upside is gated by a cold-probe fraction that the very transposition-saturation finding suggests is small.
**The honest expected value is low** — but the **deciding number (tail cold-probe fraction) is unmeasured and
cheap to get**, and the user's instinct (don't divide → don't re-expand) is a genuinely new and correct angle,
so it earns the one measurement, not a build.

---

## 7. Relation to the parked prefetch / MLP levers (the cousin to prefer)

The --16 handoff parks two position-space ideas this lever is adjacent to:

- **"Predict EXACT keys (not hashed slots) to prefetch deeper future probes"** — the DFS state generates the
  future subtree, so a predictor can compute the *keys* the main worker will probe N steps ahead and issue
  `_mm_prefetch` for their slots. **This is strictly cheaper than speculative-solve:** it warms the *cache
  line* (no recompute, no extra core's worth of compute, no write, no eviction, no `δ`-from-writes), and it has
  **no `IN_FLIGHT` hazard** (read-only). If the future-key prediction is tractable (the hard part both levers
  share), **prefetch dominates speculative-solve** on every axis except one: prefetch only hides latency for
  probes that **hit** (warm a line that already holds the answer), whereas speculative-solve *creates* the
  answer for cold probes. So they are complementary: prefetch for the warm-but-cold-cache probes, speculative-
  solve for the genuinely-uncomputed ones. **But §5's measurement gates both** — if the tail is mostly warm,
  prefetch is the right (cheaper) tool and speculative-solve is redundant; if the tail is mostly cold,
  prefetch can't help (nothing to warm) and only speculative-solve can — at the `δ` cost.
- **"MLP-batched probes on the explicit-stack frontier"** — handoff judges this **likely closed** too (batching
  entry probes needs a breadth/frontier visit order, forfeiting depth-first move ordering = the +94% finding).
  Speculative pre-warm is the **single-worker-immune** alternative the handoff names for the same memory bucket:
  it doesn't reorder the main worker's probes (so no +94%), it computes ahead on *other* cores. That immunity
  is exactly its appeal and exactly why it's worth the one measurement despite the low EV.

**Sequencing recommendation:** run §5's cold-fraction tap. If cold% is low → both speculative-solve and
exact-prefetch are dead (no headroom); pursue node-count levers instead (the handoff's live lever is deep-tail
move ordering, `proposal-2026-06-21-deep-root-ordering.md`). If cold% is high → build the **exact-key
prefetch** first (cheaper, no `δ`-from-writes, no eviction, no hazard); only escalate to speculative-solve if
prefetch's warm-line hit rate proves capped and the cold-compute fraction is the residual.

---

## 8. Honest risk list

1. **No headroom (most likely).** Tail is transposition-saturated ⇒ likely already-warm ⇒ low cold fraction ⇒
   nothing to pre-warm. **Measured by §5 before any build.**
2. **`δ` latency-under-load cancels the win.** 3–4 random-DRAM speculative streams degrade the solo main
   worker's exposed per-probe latency; break-even needs `f ≳ 0.10–0.20` and `f` is likely ~0.10. **Measured by
   §5's second probe.**
3. **Targeting misprediction.** Re-derived/snapshot targets the main worker cuts-past or never reaches = wasted
   compute + write traffic (feeds `δ`) with zero hit. Anticorrelation of value vs reach-probability.
4. **Timing mismatch.** Huge subtrees can't be warmed in time; medium subtrees yield small per-target savings.
   The productive band is narrow.
5. **`wins_inc_iter` dependency (option (a) only).** Reading the live frame stack needs the explicit-stack
   path made shareable (`UnsafeCell`/raw-pointer snapshot) and promoted from substrate to production — its own
   gate + a wash-to-parity throughput baseline. **Option (b) (re-derive from root) avoids this** and is
   recommended.
6. **`IN_FLIGHT` correctness hazard.** A speculative `0xFF` marker read by the non-ABDADA production
   `tt_get_h` is a spurious WIN. **Avoided** by writing only completed verdicts via `put_hashed`. Gate test
   required (`QUEENS_PREWARM=1` matches `naive` n≤9, SECOND n=12/14).
7. **n=16 measurement noise.** Per the discipline: single n=16 runs lie (±18%). Any A/B must be **interleaved**
   (`scripts/queens-ab.sh 16 QUEENS_PREWARM ./target/release/queens`), 12 GB TT, cyc/node + total cyc + wall,
   and must show a **wall** win that survives interleaving — the standard gate.
8. **Box memory pressure.** Speculative writes commit more of the TT (more pages faulted); at 16.5% fill this
   is headroom, but it interacts with the COLLAPSE/huge-page commit. Bench on a clean box (swap/zram off, ARC
   capped, caches dropped), as always.

---

## 9. Decision

**Recommend: measure, don't build.** Implement only the §5 `M_COLD`/`QUEENS_COLD` cold-probe-fraction tap (a
`M_RANK`-shaped twin, ~0 solver risk, production byte-identical) and the one latency-under-load `δ` spot check.

- **If tail cold% < ~25–30% (likely):** record the instructive negative ("speculative TT pre-warm has no
  headroom — the transposition-saturated tail is already mostly warm; the lever the user proposed is correct
  in mechanism but the cold-compute work to pre-warm doesn't exist"), and route effort to the live node-count
  lever (deep-tail move ordering).
- **If tail cold% ≳ 40% and `δ` is small:** build the **exact-key prefetch** cousin first (§7 — cheaper, no
  write traffic, no eviction, no hazard); escalate to speculative-solve (§3, option (b)) only if prefetch's
  warm-line hits are capped and a residual cold-compute fraction remains.

The user's framing — *don't divide the search (which re-expands); prefetch-by-computing the deterministic
future* — is the first parallelization-adjacent idea in the thread that genuinely clears the node-count trap
that killed the other five. It deserves the one cheap measurement that decides whether the memory axis kills it.
