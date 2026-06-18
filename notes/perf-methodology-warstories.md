# Performance debugging — methodology and war-stories

Source notes for an HTML report. Self-contained Markdown; every number traces back to a
session transcript, commit, or handoff. The subject is the Non-Attacking Queens solver
(`rust/` in the othello repo) and how its bottlenecks were found and tightened across many
Claude Code and Codex sessions on one mini-PC ("grover": GEEKOM A9 Max, Ryzen AI 9 HX 370 —
4 Zen5 + 8 Zen5c cores on two CCXs with separate L3s, 32 GB LPDDR5x-5600, ZFS root, zram swap).

---

## 1. Framing: why this search was hard to optimize

Non-Attacking Queens is **Node Kayles on the n-queens graph** (place a non-attacking queen,
last to move wins). Deciding the winner is PSPACE-complete (Schaefer 1978); the game is
*transposition-dense* (the same available-square graph is reached by many move orders) and does
not decompose into independent sub-games (the queen graph is biconnected with long-range
diagonals, so no Sprague-Grundy nim-sum split). The practical consequence: the search is one
huge DAG explored with α-β / parity pruning, and the dominant per-node cost is **deduplicating
against a multi-GB transposition table (TT)** — a random-access hash probe into a structure far
larger than any cache. n=16 has roughly **7.2 billion distinct positions** under the cheap
8-fold dihedral (D4) key, ~2.1 B under full graph-isomorphism merge.

Two things made this *methodologically* hard, beyond the raw scale:

1. **It is memory-latency-bound, not compute- or parallelism-bound.** The same conclusion holds
   for the Othello engine (`rust/NOTES.md`: "the dominant memory access per node is the TT
   probe, which is random-by-hash and inherently L3-latency-bound"). Per-node micro-opts wash
   out; the load-bearing levers are *representation* (what bits cross DRAM) and *node count*
   (merging / pruning). Optimizing the wrong layer produces real-but-tiny single-digit wins.

2. **The box is hypersensitive to measurement confounds (±2–3×).** cross-CCX coherence, physical
   page placement (ZFS-vs-tmpfs), thermal throttle, ZFS ARC pressure, zram spill, fragmented
   huge pages, and non-znver5 build flags each independently swing the headline number. On a
   degraded box the search *silently fakes a wall*. More than one session concluded a hard limit
   that turned out to be the bench environment, not the algorithm.

Because of (2), methodology mattered more than any single trick. The recurring failure mode was
not "we couldn't find the lever" — it was "we measured under a confound and believed the number."

---

## 2. The methodology toolkit

Each technique below, what it measures, and when it was reached for.

### `perf stat` hardware counters — the first instrument
What it measures: cycles, instructions (→ IPC / CPI), branch-misses, dTLB/iTLB-load-misses,
L1d/L1i-load-misses, LLC-load-misses. When: every perf question started here. The decisive
property is that **CPI (cycles/instruction) and branch-miss-rate (per instruction) are
node-count-independent**, so a single run resolves a real per-node change that wall-clock
cannot — the n=16 node count itself swings ±~18% run-to-run (parallel cutoff timing), which
dwarfs most effects in wall time. Canonical event set used:
`instructions,cycles,L1-dcache-load-misses,dTLB-load-misses,branch-misses,L1-icache-load-misses,iTLB-load-misses`.

### `perf record` + `perf annotate` / `perf report` — localizing the stall
What it measures: which symbols and source lines own the cycles / branch-misses (sampled).
When: after `perf stat` says *what kind* of stall dominates, to find *where*. Used with
`--call-graph dwarf` to attribute caller chains. The trap (see war-story 7): a `perf record`
on a short run is contaminated by one-time startup work (an `OnceLock` table build) — the
hotspot it reports can be a startup artifact that amortizes to nothing at scale.

### Top-down Microarchitecture Analysis (TMA) — frontend vs backend vs bad-spec
What it measures: which pipeline slot category is wasted — frontend-bound (instruction
delivery: I-cache, iTLB, decode), backend-bound (execution: memory or core/port), bad
speculation (branch mispredicts), retiring (useful work). When: to decide *which class of fix*
can possibly pay before building it. Findings on this search:
- Pure-iso iso-flat (session "RESOLVED 9331f9b"): IPC 1.14, TT probe ~1% of cycles, **75% of
  cycles in the Weisfeiler-Leman graph-key** (`comp_canon` 53% + `wl_refine_in` 22%) — *not*
  memory-bound there; the key was the wall.
- Selective-key iso-flat at n=16, warmed, 24 threads (session 2026-06-17--6): TMA L2 =
  backend-bound-by-memory **34%**, frontend-bound-by-latency 24%, smt-contention 17%, bad-spec
  8%, retiring **7.5%**; annotate showed ~37% on the `test $1,%al` right after the TT slot load
  = pure flat-TT DRAM-probe latency. **Memory-subsystem bound.**
- iso-window at n=16 (latest rounds): IPC ≈ 0.79, **branch-misses ≈ 24% of cycles** — bad-spec
  was the elephant, ~3× the dTLB budget. (See war-story 8.)
The lesson encoded in the toolkit: TMA tells you the *category*, and the category changes as the
representation changes. The same program was "WL-compute bound," then "DRAM-latency bound,"
then "branch-mispredict bound" at successive stages.

### dTLB / L1i / branch-miss counters — sizing the candidate lever
Used to *bound* a lever before building it. Example (war-story 8): seg-TT cut dTLB-load-misses
−6.7% → −6.3% cycles, but branch-misses were 143 B at ~15–18 cyc ≈ **22–24% of all cycles** vs
dTLB at ~7–8% even at a generous 75 cyc/page-walk — so the dTLB lever was capped at single
digits while the branch-miss lever had 3× the headroom. That is a Channel-Fermi call made
directly from counters.

### Wall-clock interleaved (round-robin) A/B — the bottom-line gate
What it measures: real completion time, the thing the user actually cares about. When: to keep
or kill a change. The discipline: **alternate the two binaries round-by-round** (A/B/A/B…), never
all-A-then-all-B — the box thermally throttles ~1 s on a ~12 s n=14 solve, so a block design
yields spurious deltas. Compare **M/s (throughput), not wall**, at n=16: the node count is the
noisy variable; throughput normalizes it and is what latency-targeting levers actually move.
(Worked example: seg-TT's node count was *higher* than flat's yet it was faster ⇒ the win is
per-node latency, confirmed by comparing M/s not wall.)

### HyperLogLog distinct counting — sizing the problem without solving it
What it measures: the cardinality of the distinct-position set (Flajolet-Martin estimator, dense
p=16 registers, ~0.4% std err), fed every canonical key during a search. When: to decide whether
n=16 even fits a given structure before committing a multi-hour run. It put n=16 at ~9.2 B
distinct (D4) / ~2.1 B (iso), which said a raw 16 B/slot TT (~148 GB) can't fit 32 GB but a
~1.1-bit/key BuRR archive (~11.5 GB) can — the whole Chunk-4 direction. Also used to *diagnose*:
when n=16 distinct/re-exp varied ±18% run-to-run, an HLL accuracy check (n=14 stable to ±0.17%
over repeats) proved the variance was *real* (parallel cutoff order changes which positions get
pruned), not an estimator artifact — so bumping `hll_p` would add cost for nothing.

### node-count vs CPI vs branch-miss-rate — which metric to trust, and why
The single most repeated methodology lesson. On a throttled, latency-bound, parallel search:
- **wall-clock** is contaminated by thermal throttle + ±18% parallel node-count noise → trust
  it only via interleaved A/B with enough rounds, and only for the final keep/kill.
- **node count** is the right metric for *merge/prune* levers (deterministic at n≤14), but
  noisy at n=16 — and "nodes/s" is a metric trap (a hash with collisions hit 63.5 M/s but solved
  *slower*; manufacturing cheap nodes inflates the rate while raising completion time).
- **CPI and branch-miss-rate** (node-count-independent) are the robust per-node signals — one
  run each resolves a change that wall-clock can't. This is what made the branchless-filter win
  (war-story 8) trustworthy: −9.4% CPI is mechanistically tied to −34% branch-misses.
- On the inner-loop rewrite the **deterministic instruction count predicted wall direction
  reliably** where single-shot `perf` cycles were noisy — the right metric on a throttled box.

### Box hygiene — a measurement precondition (war-story 3)
Before any 17 GB-regime n=16 run: swap/zram off, ZFS ARC capped low (`zfs_arc_max`≈2 GB; default
~50% RAM eats the table), `echo 3 > drop_caches` + `echo 1 > compact_memory`, and clear `/tmp`
(tmpfs = RAM here; stale `*.perf.data` once pinned 11 GB). Need ≥~20 GB free so the table doesn't
OOM/spill. A degraded box silently fakes a wall.

### isolate-one-variable-and-verify-the-flip (war-story 5)
Change/control one variable at a time; prefer freq-independent metrics; and **confirm the
proposed fix flips the result before writing "RESOLVED."** The scar: a root cause was committed
("ARC pressure"), retracted, re-floated ("THP"), retracted, before the real cause (cross-CCX ×
placement) emerged — because the earlier calls were never tested by *un-doing* the supposed
cause.

### Channel-Fermi / napkin-the-leverage-first
Estimate the predicted win before implementing. If the bench disagrees with the napkin by an
order of magnitude, the *model* is wrong — re-read the trace at a wider angle, don't keep
shaving the thing you assumed was the cost. (The branch-vs-TLB budget comparison above is the
canonical use; the floor note's instruction-counted compute floor is the large-scale use.)

---

## 3. The war-stories

### War-story 1 — the bogus "~36 M/s floor / sub-50 unreachable / n=16 ~3m41s wall"
*The flagship. A whole session concluded a hard limit; it was three stacked measurement errors.*

**Symptom.** Session `cda19d7f` (Wed night → Thu morning). The user set an explicit throughput
goal and steered hard against quitting — verbatim: "do not stop till you hit or exceed that
goal. no giving up," "do not stop until you run out of tokens. just keep going to 50,"
"remember nothing new works. expect regressions while you push forward. profile to understand
why," "and shave edges and cost off before bailing." The agent ran an extensive, genuinely
competent pass — affinity sweeps, TMA, MLP windowing, an L2-resident ≤7 band table, a nimber
oracle, hash-key experiments — and banked a real +15% raw M/s and +10.6% n=14 completion. Then
it concluded, repeatedly, that the wall was hard. Final messages, verbatim: *"genuine 50 M/s is
proven impossible on this hardware … I have no further honest progress to make autonomously"*
and *"genuine 50 M/s is proven unreachable here … the remaining gap is now strictly a human
decision."*

**How it was investigated.** The reasoning *inside* the session was sound on its own terms: TMA
said backend-by-memory 34%, the >7 region is an unbounded random-DRAM probe stream, and
node-reduction (the oracle) cuts completion but not the rate (`M/s = nodes ÷ wall`). The agent
even proved the metric-trap: a 1 MB fingerprinted hash hit 63.5 M/s but solved *slower* (9.30 s
> 8.82 s) — "the only way to display 50 is manufacturing cheap nodes."

**The false leads (three confounds, all believed).**
1. **A degraded box.** The 17 GB TT didn't fit: zram swap was full of cold pages from prior OOM
   storms, ZFS ARC was eating ~13 GB, and ~11 GB of stale `perf.data` sat in tmpfs (= pinned
   RAM). So every "n=16" run was *capped* (12–13 GB TT), which evicts and inflates re-expansion —
   the table never got to demonstrate the eviction-free regime.
2. **Dismissing W8 on one confounded run.** Codex's complete dense W8 table (resolve every
   pc==8 8-vertex tail by a 28-bit labelled-edge-code lookup, off the random TT) measured a
   *wash* (33/36 roots at the same wall) — but on the capped box and via a slow
   `dense_window_get` that rebuilt the edge code twice.
3. **Never forcing huge pages.** `madvise(MADV_HUGEPAGE)` is advisory; on the fragmented box only
   ~57–73% of the multi-GB table got promoted to 2 MB pages.

**The root cause and the fix (next session, `138f26c4`).** A fresh agent, pointed at the prior
two transcripts with the user's note "We are NOT at the floor … keep pushing," did the
following in order, *collaboratively with the user cleaning memory in parallel*:
- Caught that **Codex's binaries were plain `cargo build --release`, non-znver5** (17 such
  builds in his session) — all his numbers were on the wrong target.
- Cleaned the box: user turned zram off and compacted; agent walked the ARC cap and
  `drop_caches`; together they found the **11 GB of stale `perf.data` in tmpfs** and cleared it
  → ~24 GB free → the 17 GB TT finally fit.
- Rewrote W8's hook as a one-pass `w8_get` (build the 28-bit code straight from the 8 attack
  rows), monomorphised on `const WINDOW: bool` so plain iso-flat keeps *zero* dead pc==8 branch.
- Added `MADV_COLLAPSE` (synchronous huge-page collapse) + `MADV_POPULATE_WRITE` prefault,
  default-on for ≥4 GB tables → **100% 2 MB pages, verified** (vs ~73% with plain THP).

Clean box + W8 (one-pass) + collapse: **n=16 3m41s → 2m44s (SECOND player), under the 3-minute
goal.** W8 wins ~28% fewer nodes because pc==8 subtrees are *never re-expanded*; collapse adds
~5% wall at near-identical node counts (a clean TLB win). The "floor" was an artifact on every
axis. The user's closing line: *"(and you told me in that previous session we were at the floor
;)"*

**The lesson → CLAUDE.md rule.** *"NEVER claim we've reached 'the floor' / a hard limit / that
something is 'unreachable' — that judgment is the user's alone. Reason through walls, not declare
them; a 'floor' conclusion is almost always an artifact of the measurement conditions or an
untried lever."* The compute floor for this strategy is actually ~45–60 s (theoretical-floor
note), so 2m44s is not close to any real bound.

---

### War-story 2 — cross-CCX counter contention (the per-node atomic that bounced over the fabric)
*The fix that was a load-bearing 2×, hiding inside "the box regressed."*

**Symptom.** iso-flat, even after being given `fused`'s exact kernel, ran **2× slower than
`fused`** at n=14 — purely from the store path.

**Investigation.** `perf` showed the difference was not compute (same kernel) but the per-node
shared writes. The HX 370 is two CCXs with separate L3s; a single shared atomic incremented every
node by all 24 workers bounces over the Infinity Fabric. The culprits: `QueensTt::bump`'s
per-node `nodes.fetch_add` and the per-`get` HyperLogLog feed — both shared atomics on the hot
path.

**Fix.** Move per-node `nodes`/`fill` accounting to a **thread-local `Acc`**, flushed to atomics
~1×/s and drained once via `Solver::drain()` after the parallel search (commits `49bba47`,
`9331f9b`). That ~2×'d iso-flat → 14.1 M/s and lifted `incremental`/`parallel`/`memo` too. A
sequential variant (`bump_local`/`flush_local_nodes`) removes the TLS/`RefCell` touch from the
serial recursion as well.

**Lesson → CLAUDE.md rules.** "No atomics in the hot loop" and the env-var corollary: *resolve
env-vars and any run-constant toggle once at startup; thread the value through; never `env::var`
in a per-node loop* — the env-lock serialises all rayon workers, the exact contention a lockless
TT removes. The user reinforced it live in the latest session: "no atomics or contention in the
inner loops even for counters … no env vars, those must be resolved on startup … nothing that
would trigger a syscall esp alloc."

---

### War-story 3 — box hygiene as a measurement precondition (the 11 GB ghost in tmpfs)
*A degraded box silently fakes a wall; this is the checklist that came out of it.*

**Symptom.** The 17 GB TT OOM'd or spilled, capping every n=16 run and degrading every number —
the proximate cause of war-story 1.

**Investigation (session `138f26c4`).** With swap off and ARC capped, `MemAvailable` was still
only 12.9 GB; ~11 GB was pinned in `shared`/tmpfs. `df -h -t tmpfs` + `du` on `/tmp` found
~11 GB of stale `*.perf.data` from prior profiling sessions — `/tmp` is tmpfs (RAM) on this box,
so disposable profiling captures were pinning a third of memory. The agent surfaced rather than
deleted them unilaterally; clearing them freed RAM → the table fit.

**Root cause.** Multiple independent RAM consumers (zram cold pages, ZFS ARC at ~50% of RAM,
tmpfs perf files) each invisible to a casual `free -h` glance, collectively starving the table.

**Fix / checklist (now a CLAUDE.md gate).** Before any 17 GB-regime n=16 run: swap/zram off; ARC
capped low (`zfs_arc_max`≈2 GB); `sync; echo 3 > drop_caches; echo 1 > compact_memory`; clear
`/tmp`; force full 2 MB pages (`MADV_COLLAPSE`, since plain THP only promotes ~73% of a
randomly-faulted multi-GB table). Note also the zram subtlety: this box's "swap" is
`/dev/zram0` (zstd-compressed RAM ~3.4×), not disk — spillover is a CPU decompress cost per
random access, not disk I/O, so don't call it "disk thrash."

---

### War-story 4 — bench placement & interleaving (n=14 swinging ~3× by where it ran)
*The session that chased a "regression" for hours that was never in the code.*

**Symptom (session `46a811d2`).** `solve 14 --distinct` regressed overnight with no code change:
burr 3.9 s → ~7.3 s (node count *identical*, so pure throughput), incremental ~14 → ~9 M/s. The
user drove the bisection live: "iterate on the non-pgo version for faster feedback. It's not
thermal or codegen," restarted zram, compacted, rebooted, rebuilt last-night's exact binary, ran
outside tmux, and asked the recurring catch: "are you building with `make release`??"

**Investigation.** `perf stat` (freq-independent cyc/node): the *same binary* (`1c6f390`,
last-night's exact code) ran ~12,800 cyc/node now vs ~5,600 the night before — 100%
environmental, code exonerated. A whole sequence of hypotheses was raised and *ruled out by
measurement*: thermal (51 °C, cool), PGO-vs-non-PGO (identical), zram swap (SwapFree flat),
THP fragmentation (compaction recovered order-9 blocks; throughput unchanged), CPU frequency
(governor `performance`, 3.4–3.85 GHz under load), microcode, even a possible down-trained
memory speed (`dmidecode` showed 5600 == 5600, refuted).

**Root cause.** The deciding experiment was a placement × cores matrix (cyc/node, freq-independent):

| binary \ cores | Zen5 CCX only (0,1,2,3,12,13,14,15) | all 12 cores |
|----------------|-------------------------------------|--------------|
| tmpfs (`/tmp`) | 2,796                               | 4,564 (3.6 s — best wall) |
| ZFS (`target/`)| 3,915                               | **11,960 (7.3 s)** |

The slowness was **all-cores × ZFS-placement**: a morning `zpool scrub` + reboot reshuffled the
shared write-heavy state (the `fill`/`nodes` atomics, the TT lines) into unfavorable physical
memory; spread across both CCXs that coherence traffic bounced over the Infinity Fabric, and the
cost was *gated by physical page placement* (+63% for tmpfs-placed data, +3× for ZFS-placed).

**Fix / discipline.** Run the real n=16 and *all* benchmarks from tmpfs all-cores
(`cp target/release/queens /tmp/q && /tmp/q solve …`) or pin the Zen5 CCX; bare ZFS+all-cores
numbers are unreliable (±3×). The real code lever is the thread-local counter (war-story 2). And:
**run levers on n=16-scale**, since at n=14 the parallel fan-out is a brief burst.

---

### War-story 5 — "isolate before concluding" (ARC, then THP, then the real cause)
*The discipline scar: do not commit a root cause you haven't tested by un-doing it.*

**Symptom.** Same regression hunt as war-story 4, earlier in its life.

**The wrong calls.** The agent committed "RESOLVED: ZFS ARC memory pressure" (`2db3e5e`), then
had to retract it (shrinking ARC didn't help), then floated THP (also wrong), before the
cross-CCX × placement cause emerged — cracked by the user's idea to `taskset` to the Zen5 CCX.

**Lesson → memory rule.** "Control ONE variable + verify the fix flips the result BEFORE
declaring/committing a root cause; this box is ±2–3× hypersensitive to confounds." Shrinking ARC
should have been *tested* before the ARC conclusion was committed. Prefer freq-independent metrics
and interleaved A/B; document negatives; don't overfit a single run.

---

### War-story 6 — TMA finds the search is frontend / branch-bound (and the metric shifts)
*The same program had three different bottleneck categories at three stages.*

**Symptom / arc.** "Where is the time actually going?" — asked repeatedly, answered differently as
the representation changed:
- **Pure-iso iso-flat:** TMA + annotate → IPC 1.14, TT probe ~1% of cycles, **75% in the WL
  graph-key** (`comp_canon` + `wl_refine_in`). The key *was* the wall; the first fix tried
  (component-carry) was a wash because the big connected component is always-dirty → always
  re-WL'd. The real answer was *selective keying* (cheap tiny-iso ≤k / cheap D4 above), avoiding
  WL entirely → 1.66 → 14.1 M/s.
- **Selective-key iso-flat at n=16:** TMA L2 → backend-by-memory 34%, frontend-by-latency 24%,
  retiring only 7.5%; annotate ~37% on the `test` after the TT load → **DRAM-probe latency**.
- **iso-window (latest):** IPC ≈ 0.79, **branch-misses ≈ 24% of cycles** → **bad-speculation**
  the elephant (war-story 8). At n=14 the same code showed IPC ≈ 1.96 with 2.64 B branch-misses
  — a frontend/L1i signal matching the earlier "L1i/frontend-bound" finding.

**Lesson.** "The search is frontend/L1i-bound where the graph key lives" (and DRAM-latency-bound
at the marginal TT lever) → a CLAUDE.md rule: a per-node `if` on a run-constant toggle "bloats
the hot loop's I-cache and feeds the branch predictor — and the search is already frontend/L1i-
bound, so the dead branch *worsens the actual bottleneck*." Hence: monomorphise on a `const`
generic resolved once at the call site (e.g. `iso_key_fast_in::<const HIST: bool>`,
`wins_inc<const WINDOW, const MODE, const ORACLE, const PROVE_LOSS>`), never a per-iteration
branch.

---

### War-story 7 — the contaminated `perf record` (profiling the wrong code)
*A textbook localize-the-wrong-thing moment, caught by re-profiling at scale.*

**Symptom.** Hunting the n=16 branch-miss source, the agent ran `perf record -e branch-misses`
on a cheap n=14 run and got a sharp hotspot: **76% of branch-miss samples in a closure
`call_mut` shim** that the compiler hadn't inlined. It looked like the answer — de-closure the
hot iteration.

**The false lead.** Annotating with `--call-graph dwarf` to find the closure, the caller chain
revealed the symbol was inside **`small_canon_table`, an `OnceLock` built once at startup** (a
`smallsort`). The n=14 record had caught the *startup table build*, not the search — n=14 is so
short that startup dominates the sample.

**Root cause + fix.** Re-profiled the **n=16 search** with the record capped at ~100 s
*post-startup* (startup is negligible over a 3-minute run). Clean profile: the branch-misses are
**diffuse across the search kernel** (`wins_inc` ~40%, `band_entry` ~35%, `w8_get` ~5%) — inherent
game-tree branching — but with one concretely reducible branch standing out: the
move-availability check in `filter_moves` (war-story 8).

**Lesson → handoff rule.** "To localise, must profile n=16, not n=14 — at n=14 a `perf record` is
swamped by the one-time `small_canon_table` build, which is amortised to nothing at n=16."

---

### War-story 8 — the branchless move-availability filter (the most recent round, ~10%)
*Found by `perf stat`, sized by a Channel-Fermi budget call, localized after fixing war-story 7,
validated by the node-count-independent metric.*

**Symptom.** n=16 IPC ≈ 0.79; the pipeline was stalling hard.

**Investigation.** `perf stat` on a flat-vs-seg n=16 A/B (both ~8.5 T instructions) gave the
budget that decided the whole round:

| counter (n=16) | FLAT | SEG | Δ |
|----------------|------|-----|---|
| cycles | 10.81 T | 10.12 T | −6.3% |
| branch-misses | 143.5 B | 136.5 B | −4.9% |
| dTLB-load-misses | 10.86 B | 10.13 B | −6.7% |

143 B branch-misses at ~15–18 cyc recovery ≈ **22–24% of all cycles**; dTLB misses even at a
generous ~75 cyc/page-walk ≈ ~7–8%. **Channel-Fermi:** the TLB lever (the seg-TT premise) is real
but capped at single digits; the branch-miss budget is ~3× larger → chase that. `perf record` on
n=16 (after the war-story-7 correction) localized the one reducible branch: `filter_moves`'s
per-square `if avail_has8(...)` — a ~50/50 coin-flip hit at every node.

**The hypothesis that had to be tested first.** Were the branch-misses *latency-hidden* — recovery
overlapping the TT-probe DRAM stalls — in which case removing them buys nothing? The A/B answered
it directly.

**Fix.** Make `filter_moves` branchless (write `sq` unconditionally, `nc += avail as usize`) and
route the prove-win loop through it too; byte-identical node set (children inherit the shorter
filtered list). Measured (n=16 flat, normalized by node-count-independent CPI):

| metric (n=16 flat) | baseline | branchless | Δ |
|--------------------|----------|------------|---|
| branch-misses | 143.5 B | 95.2 B | **−33.7%** |
| branch-miss rate (/instr) | 1.68% | 1.14% | −32% |
| **CPI** | 1.267 | 1.148 | **−9.4%** |
| cycles | 10.81 T | 9.60 T | −11.2% |
| IPC | 0.79 | 0.87 | +10.4% |
| wall | 205 s | 183 s | −11% |

The −9.4% CPI is the robust signal and is mechanistically consistent (−48 B branch-misses ×
~16 cyc ≈ −7% cycles). **The branch-misses were NOT latency-hidden.** This single micro-opt (~10%)
beat the whole segmented-TT lever (+5%). Gate held: n=12 exact 1,060,823, lineage agrees.

**Lesson.** On a latency-bound parallel search the trustworthy per-node metric is **CPI /
branch-miss-rate**, not wall (±18% node noise); and a per-node coin-flip branch is worth removing
even when "everything is memory-bound," *if* the budget says bad-spec is large and the A/B shows
it isn't latency-hidden.

---

### War-story 9 — the segmented-TT and the "compare M/s, not wall" lesson
*A modest, correctly-measured +5% — and the methodology finding that came with it.*

**Symptom / idea.** The TT-size sweep (war-story 11) showed warm M/s rises as the table shrinks
(8 GB 42.7, 12 GB 40.4, 17 GB 37.7 M/s) — a ~13% per-node TLB-residency win — but a smaller table
loses it back to eviction. Could the DFS working set be made TLB-local *without* shrinking?

**Fix.** `index_seg(route, pc) = band_base[pc] + fastrange(route, band_size[pc])` (Lemire's
`fastrange` for the in-band slot) behind `QUEENS_TT_SEGMENT` — route a key into a per-popcount
band of the *same* flat table, bands sized from a measured per-pc put histogram. It is
**transposition-safe by construction**: pc is a pure function of the key, so the same key always
lands in the same band → same slot → every merge preserved. (Contrast the abandoned CCX-sharding
idea, which sharded by *worker* and lost cross-worker merges — see war-story 12.)

**The methodology finding.** First A/B pair looked like +8% throughput / +10% wall — but the
**node count was very noisy** (4.73 / 5.92 / 5.73 B across runs, a 25% swing from
`par_iter().any()` cutoff timing), as large as the effect. So the agent ran interleaved rounds
and compared **M/s, not wall**:

| | FLAT (mean of 3) | SEG (mean of 3) | Δ |
|--|------------------|-----------------|---|
| throughput | 29.6 M/s | 31.1 M/s | **+5.0%** |

SEG's node count was *higher* than FLAT's yet it was faster ⇒ the win is per-node latency (and
re-confirms segmentation loses no merges). The dTLB counters (war-story 8 table) backed the
mechanism: −6.7% dTLB misses → −6.3% cycles. **"Compare M/s, not wall" became the load-bearing
rule for all future n=16 A/B.**

---

### War-story 10 — the parallelism dead-ends (single-core n=16, then the throttle ceiling)
*Two negatives: a real bug fixed for free, then a ceiling that turned out to be thermal.*

**Bug.** The `Parallel` solver ran *single-core* at n=16: it searched root move 0 (the dominant
"elder brother") fully sequentially as a TT-warming lead before fanning the rest. At n=14 that
lead finishes in seconds; at n=16 its subtree is the entire feasible runtime, so the box sat at
~1 core for hours and Phase 2 never began.

**Fix (commit `2f51aa5`).** Parity-aware recursive YBWC: a second-player-win game tree alternates
**prove-a-loss** nodes (every child searched ⇒ no α-β cutoff to lose) with **prove-a-win** nodes
(one winner suffices ⇒ cutoff). Fan *all* children at the even (prove-a-loss) plies — free, same
nodes as sequential, zero speculation — and keep the odd (prove-a-win) plies sequential so the
cutoff survives, with no elder-first lead at the even levels. Result: n=16 1.4 → 24 busy cores;
n=14 strictly better (8.2 s vs 9.8 s, same node count). The instructive negative inside it:
*naive* YBWC (parallelize every level, elder-first) DOES defeat the cutoff (~97 M vs 53 M nodes).
The win is parallelizing *only the no-cutoff levels*.

**The ceiling that was thermal.** The whole search topped out at ~8.17× on 24 cores. Investigation
(perf + the thermal-wall finding): the box hits Tctl ~90 °C and throttles under sustained 24-core
load (idle 57 °C — the mini-PC cooler can't sustain all-core). Single-thread ~4.9 GHz boost vs
all-core ~3.7 GHz (~0.74×) turns ideal 24× into ~17–18× *before any algorithm*, leaving ~2.1×
algorithmic. **Throughput is power-limited** → rank levers by **energy-per-useful-node**, not
parallelism. This is exactly why the session that pivoted from "better elder-root parallelism"
to per-node work-reduction won (n=14 −24.7% wall, node set byte-identical): a lever that *adds*
per-node work for a small node cut (the nimber oracle: +5% work / −1.8% nodes) is punished
*harder* at the wall. There is no software fan control on this box (EC firmware runs the fan); to
bench cleanly, `ryzenadj --tctl-temp 85` or the Zen5 8-logical pin.

**Other parallelism negative.** `#20` size-based parallel split of the prove-a-loss tails was an
interleaved-A/B **wash at n=16** (42.6 vs 41.7 min) — `par_depth=3` already saturates the cores.
"All cores at 100% in htop ≠ useful parallelism" (rayon threads migrate/spin); judge by wall +
CPU-seconds.

---

### War-story 11 — the iso graph-key cost and the trilemma (a lever that was a *live loss*)
*The merge that makes n=16 fit costs ~100× the cheap key — and where that left us.*

**Symptom.** The graph-isomorphism key merges every isomorphic available-graph (sound: impartial
Node Kayles, history-free, exact win/loss values → no graph-history-interaction hazard), shrinking
n=16 ~3.4× to ~2.1 B distinct so it *fits* a flat table eviction-free. But pure-iso iso-flat was a
**net loss at n=14**: 3.59× fewer nodes, ~1.63× slower wall ⇒ ~5.8× per-node cost.

**Investigation (`iso_key_bench`, the regression gate).** Isolated the key cost, measuring
**cache-OFF** (`perf:fast_nc`) — a `reps` loop warms the component cache to ~100% hits
and hides every `comp_canon_full` change. Live iso key ≈ 1236 ns ≈ ~4200 cyc vs the D4 incremental
key's ~62 cyc → **~68× on the key alone**; 73% of components need full Weisfeiler-Leman canon.
The key *is* the per-node cost.

**The trilemma (the strategic finding).** You can have two of three: (1) full merge → fits flat
eviction-free, but needs WL on most components; (2) cheap per-node, but selective keying merges
less → doesn't fit → evicts; (3) sustained flat store (no segment-walk decay). The LSM (`iso-burr`)
escapes 1↔2 by being eviction-free regardless of fit, but pays (3) (segment-walk throughput decay
30→10 M/s). The one lever that breaks it is a *cheaper full-merge key* — incremental colour-carry
down the DFS — which is deep, multi-session.

**The resolution that actually shipped.** Rather than chase the WL key down, the production path
went *selective* (cheap tiny-iso ≤7 / cheap D4 above) and then the ≤7 region was taken off DRAM
entirely (war-story 13). The pure-iso route is parked with the lever named.

**Banked micro-wins (and their negatives).** Non-singleton-only individualisation: +1.25×. Tried
and rejected by the gate: nauty target-cell individualisation-refinement (recursion/copy overhead
> cascade savings without automorphism pruning), `align(64)` (neutral), hand-SIMD (the mix64
colour map already auto-vectorises to AVX-512; the gather-fold and sorts are hostile to it).

---

### War-story 12 — the negatives ledger (recording what didn't work)
*Discipline: a measured negative is a result. Several saved later sessions from re-walking them.*

- **df-pn (proof-number search):** correct but hits the df-pn + transposition
  (graph-history-interaction) pathology on this transposition-dense game; explodes past n=8.
  Kept as an experiment; `parallel` dominates. (Competitive df-pn needs DAG-aware proof numbers —
  Čížek-Balko-Schmid 2026, arXiv:2511.10339; Nagai 2002.)
- **Memory-level parallelism (MLP) windowing of prove-loss probes:** single-thread IPC 1.18 →
  1.40 (overlap is real) but +19% instructions ⇒ cycles flat, and **24-thread regresses**
  (n=16 26.8 vs 31.4 M/s) — the two memory controllers' MLP is already saturated by cross-thread
  parallelism. Same root cause as the older `naive-prefetch-windowing` negative.
- **CCX partitioning of the TT:** the cross-CCX coherence penalty is real (~13%, measured:
  Zen5-only 16.25 + Zen5c-only 23.97 = 40.22 sum vs both-CCX 35.03), but **not capturable** —
  removing it means separate per-CCX TTs, which drop ~42% cross-CCX transposition sharing and
  re-search it, > the 13% saved. A metric-inflation trap like the hash trick.
- **Nimber oracle (decompose a >7 node via its ≤7 components' Grundy values):** ~1.7% hit rate
  (most positions keep one component >7), so the per-node decompose is paid ~98% of the time for
  nothing → n=16 23.5 M/s (vs 35.75 off), slower on both rate and completion. Even with L1/L2
  nimber tables. Cuts completion, not throughput.
- **Depth-preferred TT replacement** (branch `chunk3-depth-preferred-tt`): measured 3× worse; off
  main.
- **Root reordering** (`count --roots`): every proxy's Spearman vs cross-root shared volume is
  flat (|ρ|≤0.54); even the oracle reorder is only ~3.7% better at the cap regime, < the 3–5%
  bar. No universal trunk (58% root-private). Don't reorder roots.
- **The "nodes/s" metric trap:** a 1 MB fingerprinted hash for the ≤7 key showed 63.5 M/s but
  solved *slower* (9.30 s vs 8.82 s) — collisions manufacture cheap nodes. "Higher rate ≠ faster
  solve."
- **GPU:** does not help (sequential DAG, random-access TT, branchy) — same conclusion as Othello.

---

### War-story 13 — keep-pushing past the micro-opt plateau (amortization beats shaving)
*The user's "amortize setup somehow" nudge that found a 10× lever.*

**Symptom.** On the graph key, per-node micro-opts plateaued fast: #17 branchless WL refine
+3.5% at n=16, #17b compact-layout/AVX-512 +2% more (and the 64-bit multiply wouldn't even
vectorise on znver5).

**The pivot.** The user's nudge — "keep pushing" + "amortize setup somehow" — pushed past the
plateau to **#19, a per-thread component-canon cache that skips recomputing recurring
components: +29% at n=16, ~10× the micro-opts.** `comp_canon` had been recomputed every node
before the TT probe; it's a pure function → cache it. Then the ≤7 band was taken fully off DRAM:
solve ≤7 descendants in a 128-byte L1 stack memo, serve the band entries (78% of all TT gets,
measured) from a complete L2-resident table keyed by the labelled edge code the parent already
computed — n=16 31.4 → 36.25 M/s (+15%), and the **raw labelled key beat the canonical
16 MB table** (8.82 s vs 9.71 s at n=14 despite +16% nodes — the canon table's DRAM probe cost
more than the extra ≤7 recompute it saved).

**Lesson → memory rule.** "When per-node micro-opts plateau, step back to amortization/skipping
work and keep pushing — the next idea was often 10× the last. After 1–2 micro-opts return single
digits, look for (a) amortization (cache a recomputed pure function), (b) pruning/skipping, (c)
structural change (representation, working-set)."

---

### War-story 14 — the theoretical floor (napkin-first, adversarially reviewed)
*Channel-Fermi at the largest scale: a first-principles compute floor that re-aimed the program.*

A paper analysis (no code) estimated how fast the *optimal* solver could run n=16 on this box.
Layered: answer entropy (1 bit), memory-traffic floor (~0.7–4 s, *not* binding — a random hash
probe wastes ≥87% of every 64 B line, so only streaming ply-windowed DDD makes every byte useful),
and the binding **compute floor**: the dominant term is canonicalisation-per-edge,
instruction-counted. The first draft (~15 s central, labelled a "lower bound") went through a
two-reviewer adversarial pass (hardware/physics lens + algorithm/modeling lens) and was
corrected: re-labelled "strategy floor / target" (the minimal proof DAG, unbounded here, could be
*lower*), node-base double-count fixed, compute rate re-costed at a thermally-realistic all-core
AVX-512 figure (~3.0–3.4×10¹⁰ cyc/s, SMT ~1.05 not 1.3) → **central ~45–60 s, ~50–110× over the
then-current 42 min**, with `b̄` (edge-weighted branching) promoted to the explicit linear
multiplier and then *measured* (~4 via `count --branching`). The lever-ranking it produced —
"the per-node gap is structural, not tunable; it closes only with a register-resident, branchless,
incremental inner-loop rewrite" — directed the inner-loop rewrite (62 cyc/canon incremental, A3
kernel) and is the reason the later "36 M/s floor" claim was suspect: the *compute* floor was
known to be an order of magnitude faster.

---

## 4. The collaboration pattern

The wins came from a specific *mix*, not from any one source:

- **Human-guided intuition set the frame and refused the wall.** The user's standing rules —
  "never declare a floor, that's my call," "compare M/s not wall," "the box is not ARC-bound /
  stop worrying about ARC," "no atomics or env-vars or syscalls in the inner loop," "focus on
  n=16, n=14 is validation only," "keep failed levers on branches" — are each the scar of a
  specific incident. The pivotal moves were the user's: the `taskset`-to-Zen5-CCX idea that
  cracked the cross-CCX regression; cleaning memory in parallel with the agent during the
  floor-overturn; and bluntly re-tasking when an agent gave up ("claude is out of ideas and
  claims we have hit the floor which is bullshit").

- **AI technical knowledge did the microarchitecture diagnosis and the fixes.** TMA category
  reads, the branch-vs-dTLB budget call, the contaminated-`perf-record` catch, the thread-local
  counter for cross-CCX coherence, the `const`-generic monomorphisation to keep dead branches out
  of the frontend-bound hot loop, the branchless filter, `MADV_COLLAPSE` for full huge-page
  promotion, the WL-key cost analysis and the trilemma — these are the agent's contribution,
  applied to the data the tools surfaced.

- **Literature anchored both correctness and direction.** Correctness: the game is Node Kayles
  (Schaefer's PSPACE-completeness), verdicts cross-checked against OEIS A344227 (Sprague-Grundy
  nimbers, n≤13) and **Jenrich (arXiv:1312.5135)** for the independent n=16 = second-player win.
  Direction: HyperLogLog (Flajolet-Martin) to size the set before solving; **BuRR** static
  retrieval (Dillinger et al.) for the ~1.1-bit/key archive that makes n=18 fit one box; Lemire's
  `fastrange` for the TT/band index; Korf 2008 external-memory ply-windowed delayed-duplicate
  detection for the bandwidth-bound dedup; nauty/bliss and Weisfeiler-Leman for the iso key; and
  the df-pn line (Nagai; Čížek-Balko-Schmid; Lemoine-Viennot) as the SOTA-but-pathological
  proof-search alternative.

- **Two agents, handed off through the codebase, not chat.** The work crossed Claude Code and
  Codex sessions. Codex built the W8 dense-window scaffold and the windowed-dataflow design (pump
  → group → dense-solve → merge); a Claude session then rebuilt it znver5 on a clean box, rewrote
  the hook one-pass, added huge-page collapse, and turned Codex's "wash" into the 2m44s default.
  Conversely, when one Claude session declared the floor, the user brought in Codex to push past
  it, and the *next* Claude session closed it out. The handoff notes (`notes/handoffs/*.md`),
  the validation gates (`solver_lineage_agrees` + exact n=12 distinct = 1,060,823), and the
  CLAUDE.md performance-discipline rules are the shared memory that let each agent pick up the
  thread — including the explicitly-recorded negatives, so no one re-walked df-pn, MLP, or CCX
  partitioning.

The throughline: **the bottleneck was almost never where the first measurement said it was, and
the first measurement was almost always taken under a confound.** Progress came from distrusting
the headline number, isolating one variable, verifying the flip, and refusing to call any wall
final.
