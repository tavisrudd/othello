# Queens inner-loop rewrite — drive n=16 toward its theoretical floor

**Date**: 2026-06-16
**Session**: 2026-06-16--3 (`d7f7d3d6-4aac-45ce-b684-6984e5ed6275`)
**References**:
- **The why:** [theoretical floor doc](../2026-06-16-queens-theoretical-floor.md) — n=16 floor
  ~30 s central (band ~15–40 s), today 2502 s ⇒ **~75–150× headroom**; the gap is **per-node
  compute density** (~250–400×), not memory. §8 has the n=18 node count (~3×10¹²) + feasibility.
- **The umbrella:** [n=16 memory roadmap](2026-06-15-queens-memory-roadmap.md) — n=16 SOLVED
  (second); this work stream is the *speed* follow-on (the roadmap was the *memory/fitting* story).
- Code: `rust/src/queens.rs` (geometry, canon, solver lineage, TT), `rust/src/bin/queens.rs` (CLI).

## Context

n=16 is solved (~42 min). The floor analysis says the optimal solver is **compute-bound, not
DRAM-bound** — the binding term is **canonicalisation-per-edge**, and today's node is ~250–400×
too fat (~20–33 k cyc/distinct node vs ~80–140 at the floor). Memory micro-opts have repeatedly
washed *because they nibbled a node assumed latency-bound*; the floor says the node itself needs a
structural rewrite (incremental state, register-resident, branchless), not more nibbling.

This is **frontier 1 of a 3-frontier program** (decided 2026-06-16, user):
1. **n=16 → its floor** (this handoff) — inner-loop rewrite.
2. **n=18** — external-memory ply-windowed DDD + BuRR-on-disk (~3×10¹² nodes, ~130–450 GB on the
   1.3 TB zpool; needs *this* rewrite as a prerequisite). See floor-doc §8.
3. **n=14 nimber** — later; component decomposition + small-component nimber DB (#8).

## Key Architecture Decisions

### DFS-resident first, kept mode-agnostic for streaming (n=18)
Build the node primitive **depth-first, register-resident** (n=16's tighter feedback loop), but
keep the kernel decoupled enough that a later **streaming/ply-batched** mode (for n=18's
external-memory DDD) can reuse it. The two architectures may not fully compose (floor-doc §6
caveat: DFS-stack-resident orientations vs ply-batched streaming) — accept that n=18 may fork the
*driver*, but the *node kernel* should be shared.

### The optimal node kernel (the thing to prototype + measure)
Target ~20–140 cyc/node. The design:
- **Hold all 8 dihedral orientations of `available` live** (8 of 32 zmm), carried down the DFS
  stack; per move = 8× `vpandnq` against the orientation's attack mask; **canon = a ~7-op
  `vpminuq` reduction**, never re-folded. (Today's `canon` at `queens.rs:646` re-folds bit-by-bit
  via `mask.each(|s| img.set(perm[s]))` — the per-bit scatter is the fat.)
- Caveat (floor-doc §3): the 8-orientation update needs the attack mask in 8 frames — either 8
  pre-permuted tables (8×16 KB = 128 KB → spills L1d into the 1 MB L2) or on-the-fly GFNI
  re-permutation. Measure which wins in Step 1.
- `Bits` is `[u64;4]` = 256 bits = one zmm with room (`queens.rs:65`). GFNI `GF2P8AFFINEQB` does
  the 16×16 transpose/reflect; znver5 has GFNI + AVX-512 + native 512-bit datapath.

## Plan (3 steps)

### Step 1 — isolated canon/movegen kernel benchmark (the Fermi check; do FIRST)
Standalone harness (no search, no TT, no recursion): the optimal node kernel fed a stream of
realistic deep-position masks, measuring **cycles/node** (rdtsc or `perf stat`). **Gate the whole
rewrite on this:** if it lands ~20–140 cyc/node → commit to Step 3. If it's stuck in the
thousands → the floor model is wrong; re-read the trace at a wider angle before writing search
code (CLAUDE.md: "if the bench disagrees with the napkin by an order of magnitude, the *model* is
wrong"). Prototype both attack-mask strategies (8 pre-permuted tables vs on-the-fly GFNI).

### Step 2 — measurements (parallel with Step 1; cheap; set the target)
Two `count`-style instrumentation passes (copy the `iso_key_fast_in::<const HIST>`
monomorphisation template — `queens.rs:803`, zero production cost):
- **b̄ (edge-weighted branching)** — `expanded_edges ÷ distinct_nodes`, by ply. Pins the floor at
  ~30 s vs ~60–90 s (the floor is ~linear in b̄, floor-doc §3). Tally at the child-iteration loop
  in `wins_keyed` (`queens.rs:1361`).
- **proof-DAG gap** — at prove-a-win (odd) nodes, count children explored past the first cutoff
  (move-ordering inefficiency) + fraction of visited nodes on the verified proof vs discarded.
  Decides whether a DAG-aware proof search (df-pn done right) could beat the floor by a factor no
  inner-loop work recovers. Instrument `par_wins` (`queens.rs:1495`) / `wins_keyed`.

### Step 3 — full DFS-resident inner-loop rewrite (only if Step 1 validates)
Rewrite the node hot path to the Step-1 kernel, behind the validation gates every step. Likely a
new `Solver` impl (keep `Tt`/`Parallel` for the lineage cross-check) so A/B is interleaved and
the old path stays as ground truth until the new one passes all gates.

## Validation gates (every step must hold — CLAUDE.md)
- `solver_lineage_agrees` — new path matches memo-less `naive` verdict on n≤9.
- `queens solve 12 --distinct` → second, exact distinct **1,060,823**, re-exp ≈ 1.0×.
- `queens solve 14 --distinct` → second, ≈49.3M, re-exp ≈ 1.0×.
- A distinct-count change = lost merges (key bug); a re-exp jump = under-sized table. A canon
  rewrite touches the key → both must hold byte-for-byte on the merge count.
- `make test` + `make clippy` green. Bench **interleaved A/B** (thermal throttle ~1 s on a ~12 s
  n=14 solve), anchor on n=14 or partial n=16, never n=12 for perf.

## Codebase Reference

| What | Where |
|------|-------|
| `Bits` (`[u64;4]`, 256-bit, the board/available rep) | `queens.rs:65` |
| `place` (queen placement: `blocked.or(attack[sq])`) | `queens.rs:583` |
| `attack` table (`Vec<Bits>`, precomputed per square) | `queens.rs:520-537` |
| **`canon` (D4 8-fold; the bit-by-bit re-fold to replace)** | `queens.rs:646` |
| `pos_key` (canon of `available`) | `queens.rs:668` |
| `sym[t][s]` precomputed permutation table | `queens.rs:492-506` |
| **`wins_keyed` (sequential cutoff search; child loop + canon call site)** | `queens.rs:1355-1386` |
| `node_key` (D4 vs graph-iso selector + `QUEENS_KEY_MAX`) | `queens.rs:1329` |
| **`par_wins` (parity-YBWC; even=fan-all, odd=cutoff)** | `queens.rs:1495` |
| `Solver` trait (impl a new solver here) | `queens.rs:1105-1159` |
| `make_solver` factory (register the new solver) | `queens.rs:1944` |
| **`iso_key_fast_in::<const HIST>` (monomorphisation template)** | `queens.rs:803` |
| `tally_components` / `comps_report` (instrumentation example) | `queens.rs:790` / `bin:1473` |
| `QueensTt::get`/`put`/`prefetch`/`bump` (TT + counters) | `queens.rs:2391`/`2407`/`2421`/`2366` |
| `Counter` (HLL + exact-set hooks) | `queens.rs:1977` |
| `Cmd` enum + `count_mode` + main dispatch | `bin/queens.rs:110` / `1188` / `253` |

## Build/Test Commands
Per CLAUDE.md / `rust/Makefile`: `make release` / `make test` / `make clippy` (znver5+mold
RUSTFLAGS — never bare `cargo build` for benches). Bench: `./target/release/queens solve 14
parallel`. Wrap noisy builds in `~/.claude/bin/run-quiet "make …"`.

## Delegation Strategy
- **Step 1 (kernel bench)** — **Opus**: the load-bearing de-risk; AVX-512/GFNI intrinsics +
  cycle measurement + the attack-mask strategy decision. Architectural; main context drives it.
- **Step 2 (b̄ + proof-DAG instrumentation)** — **Sonnet-delegable**: isolated, clear template
  (`iso_key_fast_in::<const HIST>`), `count`-mode plumbing. Main reviews the numbers + decides.
- **Step 3 (rewrite)** — **Opus**: touches the recursion key + canon + correctness; behind gates.
- Always re-run `solver_lineage_agrees` + the distinct gates after any key/canon touch.

## Workflow Instructions
- Read this file + the floor doc first; check Progress.
- **Step 1 gates Step 3** — do not start the rewrite until the kernel bench validates the model.
- After each step: update Progress, add a dated Handoff Note (session id), keep `make
  test`/`clippy` green, commit (simple message, no co-author). Ask before any revert/git-state
  change.

## Progress
- [ ] Step 1: isolated canon/movegen kernel benchmark; measure cyc/node (both attack-mask
      strategies); **decision gate** — proceed to Step 3 iff ~20–140 cyc/node.
- [x] Step 2: b̄ + proof-DAG-gap instrumentation (`count --branching`, `queens.rs`/`bin`).
      **b̄ ≈ 3.35 (n=12) → 3.92 (n=14) → ~4–4.5 (n=16)** — the floor's b̄≈3 was slightly low (×~1.3),
      no 5–8 tail. **mean win-node cutoff 2.57 → 2.82** (43% first-move) — real ordering waste, so
      the proof-DAG gap is non-trivial but the known ordering levers already failed (df-pn stays a
      research bet, not a sure win). Gates green. See Handoff Note.
- [ ] Step 3: full DFS-resident rewrite behind the gates (only after Step 1).
- [ ] Final: `make test` + `make clippy` green; n=14 interleaved A/B vs the old path; gates hold.

## Handoff Notes

### Kickoff (2026-06-16, session 2026-06-16--3)
**Completed**: work stream created; codebase hot-path mapped (Explore agent — see Codebase
Reference for exact file:line). Floor doc (the why) + n=18 §8 written. No code yet.
**Next**: Step 1 kernel bench + Step 2 measurements, dispatched in parallel.

### Step 2 — b̄ + proof-DAG measurement DONE (2026-06-16, session 2026-06-16--3)
**Completed**: `count --branching` — a const-generic `wins_keyed_in::<COUNT>` (production is
`::<false>`, byte-identical, zero added branch; the runtime decision is made once at the root in
`Tt::wins`). Tallies total `node_key`/canon calls (b̄ numerator) + the win-node cutoff histogram.
Two delegated Sonnet agents died on transient API 500s (one did nothing, one left only stray
`cargo fmt` noise → restored with user OK); implemented in the main context instead.

**Measured (sequential `Tt`):**

| n  | b̄ (÷distinct) | b̄ (÷expanded) | mean win-node cutoff | cut@1 |
|----|---------------|---------------|----------------------|-------|
| 12 | 3.353         | 3.337         | 2.573                | 45.5% |
| 14 | 3.922         | 3.681         | 2.817                | 43.0% |

**Reads:**
- **b̄ ≈ 4 at n=16** (gentle up-trend, no 5–8 tail) — the floor's b̄≈3 undercounts ~1.3×, so the
  per-node cost (and the central floor) scales up ~1.3× (≈30 s → ≈40 s). **Step 1 green-lit** — the
  model's branching assumption holds within ~1.3×.
- **Proof-DAG gap is real but the recoverable fraction is uncertain.** mean cutoff ~2.8 (not ≈1) ⇒
  ordering is imperfect (57% of win nodes try ≥2 moves), so the searched set sits above the minimal
  proof DAG. *Caveat:* this metric counts moves-before-cutoff, not the *node-count* of the wasted
  pre-cutoff subtrees (which may be cheap), and the known ordering levers already failed (fact #6:
  history 2× worse, effective-degree decays). So df-pn / DAG-aware proof search remains a *research
  bet* with measured justification — defer behind Step 1/3 (a faster node helps regardless).

**Files**: `queens.rs` (`Tally`/`BranchingStats`, `wins_keyed_in::<COUNT>` + wrapper, `Tt::wins`
root dispatch, `with_branching`, `branching_stats`); `bin/queens.rs` (`--branching` flag,
`count_mode` param, `branching_report`). **Gates**: `solve 12 --distinct` 1,060,823/1.00×; `solve
14` ≈49.3M/1.08×; `make test` 23 ok incl. `solver_lineage_agrees`; `make clippy` clean.
**Next**: Step 1 kernel bench (implement now the build is free) — validate ~20–140 cyc/node, then Step 3.
