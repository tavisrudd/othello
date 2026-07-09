# Queuing theory as a lever for the n=16 Queens tail — theory exploration

**Date**: 2026-06-21
**Type**: THEORY exploration (no source modified)
**Scope**: Does queuing theory yield (a) an actionable performance lever, (b) a quantitative
bound that sharpens a lever already on the table, or (c) nothing that applies — for the
memory-latency-bound, transposition-bound n=16 search whose ~94% of wall is one giant root
running single-threaded as a tail.

> **Bottom line up front.** Queuing theory does **not** produce a brand-new mechanism, but it
> produces the single most important *number* for the whole memory-lever cluster: the lone
> tail worker runs the memory controller at **ρ ≈ 0.08 (8% utilization), an order of magnitude
> below the knee.** That converts "is there spare memory bandwidth for speculative pre-warm /
> idle-core probe-prep?" from a hope into a quantified **~12× of headroom** result, and it
> re-frames the MLP and speculative-prewarm levers as *the same lever* — exploiting an idle
> server — with a hard ceiling (the ~780 M/s saturation point) and a hard tax (move ordering ≈
> 2×). It also kills one tempting framing (the TT as an M/M/1/K loss queue gives no sizing law
> the existing fill/distinct measurements don't already give). Verdicts per item below.

---

## 0. The measured inputs the models are built on (all from the notes/microbench)

| quantity | value | source |
|----------|-------|--------|
| Memory probe-throughput hard cap (any scheme, ~4–8 streaming cores) | **~780 M/s** | Phase-0a threads-sweep (`mlp_probe_threads_sweep`) |
| Single-thread random, depth-0 (≈ today's one-ahead prefetch) | **60.4 M/s** (16.6 ns/probe) | `mlp_probe_depth_sweep` |
| Single-thread random, depth-32 plateau | **111 M/s** (9.0 ns/probe) | same; ~1.85× headroom @ 8–16 in flight |
| Single-thread **sorted** depth-32 | **301 M/s** (~3× over random-d32, ~5.7× over today) | sorted sweep |
| In-solver per-probe latency, pc 13–21, 24-thread contention | **176 cyc** (~34 ns @ 5.16 GHz) | `QUEENS_PROF` per-pc economics |
| Warm/near-root probe (cache-resident floor) | **50–60 cyc** | same |
| Exposed DRAM latency per cold probe | **~165 cyc** (~120 ns), ~half hidden by one-ahead | handoff cost map |
| Tail shape | ONE root = 94% of wall; SOLO for last ~17.5s @ ~14 cores | `QUEENS_ROOT_TIMING` |
| Current default n=16 | ~0.39 B nodes / ~30 s search (1 entry probe/node) | leaderboard |
| Box | Zen5 12c/24t; 2 CCX, one shared L3 each (16 MB + 8 MB); RDT MBA+CAT | NOTES.md |
| Reuse ceiling / recency-cache hit | 26.9% / ~17% | sidecar study (--16) |

**Solo-tail probe rate (the pivotal estimate).** The SOLO tail is *one* worker issuing ~1 entry
probe per node with one-ahead prefetch — i.e. the microbench's single-thread depth-0/1 regime:
**λ_solo ≈ 60 M probes/s** (16.6 ns/probe). Cross-check from the node count: the parallel phase
averages 0.39 B / 30 s ≈ 13 M nodes/s *aggregate*, but the tail is a single core whose isolated
rate is the microbench's ~60 M/s (it is not contention-slowed once SOLO). Both routes land at
**λ_solo ≈ 50–70 M/s**; take **60 M/s**.

---

## 1. Memory controller as a server — where is the tail on the latency-vs-load curve?

**Model.** Treat the shared memory subsystem as a single server with a measured service-rate
ceiling μ_max ≈ 780 M probes/s (the empirical saturation, not an M/M/c idealization — the
threads-sweep *is* the saturation curve, so we use it directly rather than fitting M/M/c, which
would need an arrival-process assumption the DFS violates).

**Utilization of the SOLO tail.**

```
ρ_solo = λ_solo / μ_max = 60 / 780 ≈ 0.077   →  ~8%
```

**Where on the curve.** The threads-sweep shows throughput still scaling *linearly* 1→4 cores
(random d1: 48.6 → 152.8 M/s ≈ 3.1× for 4×; sorted d32: 275 → 764) and only bending at 8 cores.
So the knee is at ~4–8 *streaming* cores ≈ 500–780 M/s. The lone tail worker at 60 M/s sits at
**~8% of capacity, roughly an order of magnitude below the knee.** The memory controller is
almost completely idle during the 17.5 s SOLO phase.

**Number that matters: spare service.** μ_max − λ_solo ≈ **720 M probes/s of unused memory
service** during the SOLO tail. That is the budget any spare-capacity lever (speculative
pre-warm, idle-core probe-prep, MLP) draws on.

> **VERDICT: ACTIONABLE — this is THE pivotal output.** The tail is *far* below the knee, so
> spare-capacity levers have enormous room *in principle*. This does not by itself make any
> lever pay (the catches are in §2–§3), but it removes the "no spare bandwidth" objection
> entirely and quantifies the ceiling: **anything that converts idle MC cycles into useful
> prefetch can draw up to ~12× the tail's current traffic before the server even reaches its
> knee.** Note carefully what it does NOT say: ρ≈8% means *bandwidth* is idle, but the tail is
> **latency-bound, not bandwidth-bound** — the worker stalls waiting on its own serial
> dependency chain, not on a busy server. So the lever is never "throttle others to give the
> tail bandwidth" (it has bandwidth); it is "use the idle server to do the tail's *future* work
> ahead of time" (pre-warm) or "issue more of the tail's *own* probes concurrently" (MLP).

---

## 2. Little's Law for MLP — how many probes in flight to hide the latency?

**Model.** Little's Law on the in-flight-probe "queue": `L = λ · W`, where W is the per-probe
latency and λ is the issue rate the core *could* sustain if not latency-bound. To hide latency
W with a per-probe service interval of `1/λ_peak`, you need

```
L* = W / (service interval at saturation)
```

**Number.** Using the microbench's own saturation point: single-thread throughput plateaus at
**111 M/s (9.0 ns/probe) with ~8–16 probes in flight**, up from 60 M/s (16.6 ns) at depth-0.
So:

```
L*  ≈ 8–16 in flight    (measured plateau)
W   ≈ 120 ns exposed DRAM latency (~165 cyc, half-hidden today ⇒ ~83 cyc exposed)
λ_peak ≈ 1 / 9.0 ns ≈ 111 M/s
Little check:  L = λ·W = 111e6 × 120e-9 ≈ 13.3   ✓ (consistent with the 8–16 plateau)
```

Today's DFS runs at **L ≈ 1–2** (one-ahead prefetch), i.e. ρ on the *latency-hiding* dimension
is ~1.85× below its own single-core ceiling. **Max throughput gain from MLP alone ≈ 1.85×**
(60 → 111 M/s), needing **K ≈ 8–16 frames** held probed-not-expanded.

**The catch the handoff already found, made quantitative.** To get 8–16 *independent* probes in
flight you must visit 8–16 frames breadth-first before expanding any. A prove-loss node has only
~3–12 recurse children, and (a) a child miss descends its whole subtree before the next sibling,
(b) the TT mutates during descent so a sibling batch goes stale. So per-node MLP caps at the
node's branching factor and the hit-fraction (~few %) — *below* the 1.85×. To actually reach
L≈16 you need a **frontier** batch spanning multiple nodes — which forfeits depth-first move
ordering, and the sorted-wave A/B measured that tax at **+94% nodes ≈ 2× work**.

**Net queuing balance (the sharpening this provides).** Let g = realized MLP throughput
multiplier ≤ 1.85, and t = node-count tax from the breadth needed to reach it. The lever pays
iff

```
g  >  t
```

- Per-node MLP: g ≈ 1.0–1.1 (branching-limited), t ≈ 1.0 (no reorder) → **wash to marginal**,
  matches the "below the per-node-micro-opt bar" finding.
- Frontier MLP (depth ~16): g → 1.85 but t ≈ 1.94 → **g < t, net loss**, matches the +94% kill.
- Frontier MLP **on the SOLO tail only**, where there is no move-ordering alternative being
  forfeited within a *single* descent path... still needs breadth across independent subtrees,
  which is exactly where ordering lives. No free lunch.

> **VERDICT: QUANTIFIES-EXISTING (and confirms a near-closed lever).** Little's Law gives the
> exact L* ≈ 8–16 and the exact ceiling g ≤ 1.85×, and the `g > t` inequality is a clean,
> reusable decision rule. But it does not find a way to reach L* without paying the ordering
> tax. The one genuinely new framing it suggests: **MLP and DDD-sorted-streaming are the same
> queuing lever** (raise L to hide W) differing only in whether you also sort (sorted raises the
> *service rate* μ via row-buffer hits: 111 → 301 M/s, g ≤ 5.7×, so the `g > t` budget is far
> larger — t ≈ 1.94 < 5.7). **That is the strongest implication: if you are going to pay the
> ~2× ordering tax at all, pay it for the SORTED wave (g ≤ 5.7), never plain MLP (g ≤ 1.85)** —
> the ordering tax is identical, the prize is 3× bigger. This is consistent with the existing
> "A'' sorted frontier is the lever, not per-node A1" decision, now derived from queuing first
> principles rather than measured ad hoc.

---

## 3. Priority / work-conservation — how much speculative bandwidth is genuinely free?

This is the one place queuing theory offers a *new mechanism design*, so it gets the most care.

**The idea (mechanism designed elsewhere; theory here).** During the SOLO tail, ~10–14 cores are
idle. Run the high-priority tail worker plus 3–4 low-priority **speculative pre-warm** threads
that walk likely-future positions and issue TT prefetches (or probe-and-cache), throttled by RDT
**MBA** (memory-bandwidth allocation) so they only consume otherwise-idle MC cycles. Question:
how much speculative bandwidth is free before the tail worker's wait W_h rises?

**Model: M/G/1 non-preemptive priority, conservation law.** For non-preemptive priority queues
the **work-conservation law** holds:

```
Σ_i ρ_i · W_i  =  constant  (independent of the priority discipline)
```

where ρ_i is class-i load and W_i its mean waiting time. The high-priority class-h waiting time
under non-preemptive priority (Cobham) is

```
W_h  =  W_0 / (1 − ρ_h)
```

where W_0 = Σ_i ρ_i·(residual service) is the mean residual busy time *the high class can be
blocked by* — and crucially, for **non-preemptive** service a low-priority job already in service
can block the high one for at most one residual service time S_residual.

**Numbers.**
- ρ_h = ρ_solo ≈ 0.077 (the tail's own load).
- A pure-**prefetch** speculative class issues `_mm_prefetch` (T0) — these are *non-blocking*
  hints that do **not** occupy the demand-load critical path; they fill MSHRs/queue slots, not
  the dependency chain. In M/G/1 terms their service is overlappable, so their contribution to
  W_h is bounded by *queue-slot* contention (MSHR/line-fill-buffer occupancy), not by service
  time. The MC server has μ_max − λ_solo ≈ 720 M/s of spare service, so adding up to
  ~720 M/s of speculative prefetch keeps the *server* below its knee.
- The binding constraint is therefore **not** MC throughput but **W_h via shared-resource
  occupancy**: line-fill buffers (~per-core, small), the shared L3 (one CCX = 16 MB or 8 MB),
  and DRAM **row-buffer** state. A speculative thread that touches *random* rows evicts the
  tail's open rows → raises the tail's W_h from ~120 ns toward the random-miss penalty. The
  conservation law says you cannot make the tail faster than its own service demand; you can
  only avoid making it *slower*.

**The free-bandwidth bound (the formula + number).** Let B_free be the speculative prefetch rate
that keeps W_h within a tolerance ε of its idle value. From W_h = W_0/(1−ρ_h) and ρ_h fixed, W_h
rises only through W_0 (the residual the tail waits behind). For non-blocking prefetch the
residual added per speculative probe is ~0 *if it lands in a different DRAM bank/row group from
the tail's working set*, and ~S (one full DRAM service) *if it conflicts*. So:

```
B_free  ≈  (1 − p_conflict) · (μ_max − λ_solo)
        ≈  (1 − p_conflict) · 720 M/s
```

with p_conflict the fraction of speculative probes that evict a line/row the tail still needs.
Because the tail's working set is the ~26.9%-reusable recency window (recency hit ~17%, mostly
**long-range** — the notes say recurring keys are temporally *flat*, not clustered), the tail's
hot rows are a *small* set; a well-targeted speculative thread (pre-warming the tail's *own*
near-future keys, which the DFS state generates deterministically) has p_conflict → low **and is
useful** (it warms exactly what the tail will demand). A *random* speculative thread has
p_conflict ≈ working-set-fraction and is pure harm. So:

```
Targeted pre-warm of the tail's future keys:  B_free ≈ 0.7–0.9 × 720 ≈ 500–650 M/s free,
   and the conflict it does cause is a HIT not an eviction.
Untargeted/random speculation:               B_free ≈ small; harm dominates.
```

**MBA cap that implements this operating point.** RDT MBA throttles a class's memory bandwidth in
~10% steps (delay-injection). To hold speculative traffic at, say, ≤500 M/s while the package
peak is ~780 M/s (≈ DRAM ~50–60 GB/s ÷ 64 B/line), set the speculative class's MBA to **≈ 60%**
of a core's max bandwidth and pin it to the **Zen5c CCX** (cpu 4–11), keeping the tail on a Zen5
perf core (cpu 0–3) so the speculative class shares neither the tail's L2 nor its half of L3.
Combined with CAT to fence the speculative class out of the tail's L3 ways, p_conflict drops
further. (These are mechanism knobs; the theory's job is the **operating point**: throttle to
keep speculative ≤ ~500 M/s and CCX/L3-isolated.)

> **VERDICT: ACTIONABLE — and this is the one place the theory adds a real design constraint, not
> just a number.** The conservation law + Cobham W_h say plainly: **the tail is latency-bound at
> ρ_h≈0.08, so you can never speed it up by reallocating bandwidth (it has spare); the *only*
> win from idle cores is to PRE-WARM the tail's own future demand misses, and the only risk is
> p_conflict eviction.** Therefore the correct speculative mechanism is **prefetch-only, targeted
> at the tail's deterministically-generated future keys, CCX/L3-isolated via CAT, MBA-capped at
> ~60% so it never reaches the server knee.** Quantified free budget: **~500–650 M/s of useful
> pre-warm** before W_h degrades. THE HARD CAVEAT (kills the naive version): a probe-and-*cache*
> speculative thread is the already-measured sidecar/L0 lever — **net-negative** (+9% cyc/node),
> because (i) the recency reuse is only 26.9% and temporally flat, so most pre-warmed lines are
> never demanded, and (ii) caching adds write traffic. The queuing analysis says the *prefetch*
> variant (no cache, no write, warm-then-discard) sidesteps (ii) and that the spare service
> exists for (i) — but it is still gated by **whether the tail's future keys are computable far
> enough ahead to prefetch them in time** (the parked "predict EXACT keys" problem). The theory
> green-lights the *bandwidth*; the open question it cannot answer is the *lookahead distance*.

---

## 4. Critical path / span of the tail (Amdahl / work-span)

**Model.** Work-span (Brent/Graham): `T_p ≥ max(T_1/p, T_∞)`, where T_∞ is the span (critical
path). The giant root is a serial OR-spine: its span T_∞ is essentially its own length because
α-β move ordering makes the spine *inherently sequential* (you must resolve the first child to
prune the rest). List-scheduling/Graham's bound `T_p ≤ T_1/p + T_∞` then says the achievable
speedup is capped at `T_1/T_∞`.

**Number.** The SOLO tail is 17.5 s at ~1 effective core out of 24; the 3 longest roots are
[91.7, 74.2, 52.3] s with the longest = 94% of wall. The parallel slack `T_1/p − T_∞` is tiny:
the work-stealing A/B already showed capturing the 17.5 s SOLO tail is **+8.7% nodes / +13.3%
wall** — i.e. T_∞ is not reducible by scheduling because the "extra work" that would fill idle
cores is **shared transpositions** (re-expansion), so splitting the span *adds* T_1 faster than
it cuts T_∞. Graham's bound is *satisfied with the span dominating*: `T_∞ ≈ 0.94·T_1`, so
`speedup ≤ T_1/T_∞ ≈ 1.06`. There is ~6% of theoretically-parallelizable work and it costs >6%
to extract.

> **VERDICT: QUANTIFIES-EXISTING (confirms parallelization is closed).** Work-span gives the
> clean bound `speedup ≤ T_1/T_∞ ≈ 1.06` and explains *why* all 5 parallelization approaches
> failed: T_∞ ≈ T_1 because the OR-spine is move-ordering-serial and the fillable work is
> transposition-redundant. No new lever. It does, however, sharpen the lever **direction**: since
> T_∞ (the span) is fixed by the *sequential dependency*, the only way to shorten the tail is to
> reduce **work on the span itself** — i.e. cut the giant root's node count (node-count levers) or
> hide the per-span-node latency (MLP/pre-warm, §2–§3). This is exactly the handoff's current
> "attack the work, not the schedule" conclusion, now with a number for the schedule ceiling.

---

## 5. The TT as a finite-buffer loss queue (M/M/1/K) — and other models

**Model attempted.** The replace-always direct-mapped TT is a finite buffer: each slot holds one
key; a colliding put "drops" the resident (eviction = loss). Tempting to model as M/M/1/K (or
M/M/c/c Erlang-B) and read off a **blocking probability** P_block(K) that would give a TT-sizing
law: choose K (slots) so eviction loss < target.

**Why it does not yield a new law.** Erlang-B / M/M/1/K loss assumes Poisson arrivals into a
*shared* buffer with FIFO/random service. The TT is **direct-mapped by hash**: a key's slot is
fixed, so "blocking" is *conflict* (two live keys hash to one slot), not buffer-full. The right
model is the **occupancy/balls-in-bins** (load factor) one, which the code **already measures
directly**: `fill()` / load-factor and the `--distinct` re-expansion ratio. At the current K=16
default the working set collapsed to ~2.8 GB and the 17 GB TT is **16.5% full** → P_conflict is
already ~load-factor-small, and the measured re-expansion is ≈1.0× at n=14. An M/M/1/K formula
would re-derive the birthday/load-factor curve the fill measurement gives empirically, with worse
assumptions.

The associative-bucket variant (`QUEENS_TT_ASSOC`, 8-way) *is* exactly an **M/M/c/c (Erlang-B
loss) per bucket** — c=8 servers, loss = bucket-full eviction. Erlang-B predicts the conflict-miss
reduction from direct-mapped (c=1) to 8-way (c=8): for offered load `a` per bucket, B(8,a)/B(1,a)
≪ 1. **But the --16 A/B already measured this lever as wash-at-K=16** precisely because the
working set fits (offered load per bucket `a` ≪ 1, so B(1,a) is already ~0 — no conflicts to
relieve). Erlang-B *explains* the wash (low load → associativity buys nothing) but offers no new
action; it would re-light only in the **oversubscribed regime** (small TT / n=18), exactly where
the parked `queens-tt-assoc-buckets` branch is already aimed. Useful as a **gating rule**:
compute offered load `a = working_set / n_buckets`; enable assoc only when `a ≳ 1` (B(1,a)
material). That is a concrete, cheap gate the theory hands the assoc lever.

**Batch-service (M^[X]/G/1).** The sorted-frontier wave is a batch-service queue: accumulate a
frontier batch, serve it as one streamed run. Batch-service models confirm the throughput gain
(amortized service per item drops as batch grows) but the **batch-formation delay** is the cost —
and here that delay is the move-ordering tax (the batch must be ordered by slot, not by search
priority). Same `g > t` inequality as §2; no new number.

> **VERDICT: N/A for sizing (the loss-queue framing) / QUANTIFIES-EXISTING (Erlang-B for assoc).**
> The M/M/1/K loss model does not apply (direct-mapped conflict ≠ buffer-full loss); the existing
> `fill`/`--distinct` measurements are the right and already-used instrument. Erlang-B *does*
> correctly model the 8-way assoc bucket and **explains** its measured wash (load < 1) — and
> yields one small reusable gate: **enable assoc only when offered load per bucket `a ≳ 1`.**

---

## 6. Synthesis — the verdicts in one place

| # | model | key formula | number | verdict |
|---|-------|-------------|--------|---------|
| 1 | MC as server | ρ = λ_solo/μ_max | **ρ_solo ≈ 0.077 (8%); ~720 M/s spare** | **ACTIONABLE — pivotal: tail is FAR below the knee** |
| 2 | Little's Law (MLP) | L*=λ·W; pay iff g>t | L*≈8–16; g≤1.85 (MLP) vs g≤5.7 (sorted); t≈1.94 | QUANTIFIES — *if paying the 2× tax, pay it for SORTED (g 5.7), not plain MLP (g 1.85)* |
| 3 | M/G/1 priority + conservation | W_h=W_0/(1−ρ_h); B_free=(1−p_conf)·spare | **~500–650 M/s free pre-warm; MBA ≈60%, CCX/L3-isolated** | **ACTIONABLE — prefetch-only, targeted, the right mechanism design** |
| 4 | work-span / Graham | speedup ≤ T_1/T_∞ | **≤ 1.06×** | QUANTIFIES — parallelization closed; attack span-work |
| 5 | M/M/1/K loss / Erlang-B | B(c,a) | assoc wash because a≪1; gate at a≳1 | N/A (loss) / QUANTIFIES (assoc gate) |

**Is there a single new actionable lever?** Yes, one, and it is the union of items 1+3: a
**targeted, prefetch-only, MBA-throttled idle-core pre-warm** of the SOLO tail's
deterministically-generated future keys. Queuing theory is what makes it *quantitatively
defensible*: ρ≈8% proves the bandwidth exists, the conservation law proves the tail can't be hurt
if speculation is prefetch-only and L3/CCX-isolated, and B_free≈500–650 M/s sizes the budget.
**Its single unresolved risk is not bandwidth (theory clears that) but lookahead distance** —
whether the tail's future keys are computable far enough ahead to prefetch in time (the parked
"predict EXACT keys" problem). And note it overlaps the already-measured-negative sidecar: the
difference the theory isolates is **prefetch (warm-and-discard) vs cache (probe-store)** — the
sidecar paid the cache write-traffic and the 73% never-reused waste; pure prefetch pays neither,
only the MC cycles that §1 proved are idle.

**Everything else is a framework that quantifies levers already on the table** (it sharpens the
MLP `g>t` rule, the sorted-vs-MLP choice, the parallelization-closed bound, and the assoc-load
gate) — valuable as decision rules, but not new mechanisms.

---

## 7. The single cheapest measurement to PIN the model's key parameter

The whole analysis hinges on **ρ_solo** — the SOLO tail's actual fraction of memory-controller
capacity. It is currently *estimated* (λ_solo≈60 M/s from the microbench, μ_max≈780 M/s from the
threads-sweep). Pin it with **one** measurement, no source change:

> **During the SOLO-tail phase of a real n=16 run, sample realized DRAM bandwidth and IPC for ~5 s
> and convert to ρ_solo = realized_BW / saturation_BW.**

Concretely, the cheapest form:

```
# 1. start a real solve (the existing run; tail begins ~75–90 s in)
#    QUEENS_ROOT_TIMING already prints when the SOLO tail starts.
# 2. once SOLO, attach perf to the package uncore DRAM counters for 5 s:
perf stat -a -e amd_df/...cas_count.read.../,amd_df/...cas_count.write.../  sleep 5
#    (AMD Data-Fabric CAS counters → bytes/s = (reads+writes)*64; ÷ saturation BW = ρ_solo)
```

If the DF CAS events are not exposed on this kernel, the **even cheaper proxy already wired in**:
extend nothing — just read the existing **`QUEENS_PROF` per-pc cyc/get** at the SOLO phase. λ_solo
= 1 / (cyc_per_get / clock); ρ_solo = λ_solo / 780e6. The PROF tap already times every get by pc;
filtering its sample to the SOLO window (or running a short SOLO-only profile) gives λ_solo with
**zero new code**. Equivalently, point `mlp_probe_threads_sweep` at the *production 17 GB* TT with
`MLP_THREADS=1` to confirm the single-core λ on the real table size.

**What the number decides.** If ρ_solo confirms ≲ 0.15, the pre-warm lever (§3) has its full
~500+ M/s budget and is worth a prototype. If ρ_solo turns out ≳ 0.5 (tail already near the knee —
unlikely given a single core but the contention-inflated 176 cyc/get is a warning that the *whole-
run* MC is busier than the microbench's solo number), the spare-capacity levers shrink and the
only remaining direction is node-count (§4). **This one bandwidth measurement is the gate on the
entire spare-capacity lever cluster.**
