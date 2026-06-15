# Codex review: queens n=16 memory roadmap

**Date**: 2026-06-15
**Companion to**: `2026-06-15-queens-memory-roadmap.md`
**Scope**: Review the n=16 feasibility plan, literature-search adjacent work, and
identify lower-risk optimizations in the current `parallel` and `pn` solvers before
the larger representation/archive work.

## Bottom line

The roadmap is directionally right. The HLL gate was the right first move, and the
measured/extrapolated working set makes the core conclusion hard to avoid:

- n=14 true distinct working set is about 49.3M, not the 53M node count.
- n=16 is plausibly low billions to tens of billions of distinct positions
  (central estimate about 9.2B).
- A 40 B, 16 B, or even 8 B dynamic table cannot hold the whole n=16 solved set on
  the 26 GB box.
- Therefore Chunk 4, an immutable compressed archive for solved positions plus a
  dynamic in-flight tier, is the only plausible single-box route.

The main correction: **value-only BuRR cannot be queried safely by itself.** Static
retrieval returns arbitrary values for keys outside its set. If an archive lookup
can return win/loss for a non-member, it can silently corrupt the proof. Chunk 4
must include either an exact membership dictionary, a strong fingerprint guard, or
an explicit probabilistic mode with an independent verification pass against
Jenrich's known n=16 second-player win.

## Literature search

### Static retrieval and filters

This is the strongest support for the archive plan.

- Dillinger et al., "Fast Succinct Retrieval and Approximate Membership using
  Ribbon" (BuRR/ribbon retrieval), 2021/2022:
  https://arxiv.org/abs/2109.01892
  - Static retrieval stores `f:S -> {0,1}^r` near the information-theoretic
    `r|S|` lower bound.
  - Reported practical overhead is well below 1% in their experiments.
  - This validates the roadmap's claim that a 1-bit value archive can be orders of
    magnitude smaller than the current 40 B slots.
  - It does **not** solve membership by itself; non-keys return arbitrary values.

- Dillinger and Walzer, "Ribbon filter: practically smaller than Bloom and Xor",
  2021:
  https://arxiv.org/abs/2103.02515
  - Good candidate for the archive membership guard.
  - Still approximate: no false negatives, but false positives must be budgeted.

- Graf and Lemire, "Binary Fuse Filters: Fast and Smaller Than Xor Filters", 2022:
  https://arxiv.org/abs/2201.01174
  - Another candidate membership guard; near lower-bound space and fast lookups.

- Pibiri and Trani, "Parallel and External-Memory Construction of Minimal Perfect
  Hash Functions with PTHash", 2021/2023:
  https://arxiv.org/abs/2106.02350
  - Relevant if we want an exact static archive built from external runs.
  - MPHF + compact payload/fingerprint may be a safer first archive than
    value-only retrieval.

### Game search, DAGs, and proof search

- Jenrich, "Successful strategies for a queens placing game on an n x n chess
  board", 2013/2014:
  https://arxiv.org/abs/1312.5135
  - Confirms first-player wins for n=4, odd boards, n=6, n=8; second-player wins
    for n=10,12,14,16.
  - This remains the external n=16 verdict to cross-check.

- Plaat, Schaeffer, Pijls, de Bruin, "Nearly Optimal Minimax Tree Search?", 2014:
  https://arxiv.org/abs/1404.1518
  - The useful idea here is "minimal graph", not just minimal tree.
  - Potential lever: move ordering that intentionally maximizes transposition
    reuse or triggers cutoffs through smaller subgraphs, not just static
    attack-degree order.

- Gao, "On Computation Complexity of True Proof Number Search", 2021:
  https://arxiv.org/abs/2102.04907
  - Computing true proof/disproof numbers in arbitrary DAGs is NP-hard.
  - This supports the roadmap's warning that plain df-pn plus a transposition
    table is not enough for this graph-dense game.

- Czech, Korus, Kersting, "Monte-Carlo Graph Search for AlphaZero", 2020:
  https://arxiv.org/abs/2012.11045
  - Relevant mainly as a reminder that tree-to-DAG generalization can reduce
    memory and share information across subtrees.
  - Not a direct fit: this solver is exact, not statistical.

### Set-based solving and symbolic state families

- Stone, Sturtevant, Schaeffer, "Set-Based Retrograde Analysis", 2024:
  https://arxiv.org/abs/2411.09089
  - The most interesting adjacent recent work.
  - Their setrograde approach solves many Bridge states by storing sets of states
    with the same value, reducing both operations and database entries by orders
    of magnitude in that domain.
  - It is not drop-in for queens, but it suggests a possible post-Chunk-4 lever:
    generalize families of queen positions or available masks with identical
    win/loss values.

- ZDD/BDD family representations are relevant because queen placements are sparse
  combinatorial objects. A ZDD experiment could represent families of positions,
  losing sets, or proof certificates. This is speculative, but more promising than
  chasing full nimbers on the current plain mex path.

## Plan review

### Chunk 2

Keep it, but phrase it as more than a compact dynamic slot. A canonical queen-set
encoding may also provide a ranked integer universe for exact compressed archives.
For n=16, the placement entropy is roughly `(n+1)^n ~= 2^65.4`; if the canonical
queen set can be ranked, exact sorted/ranked structures become practical.

Important measurement: quantify the merge loss from keying by queen set instead
of available mask on n=12 and n=14. If merge loss is more than a few percent, the
encoding may still be useful for the archive but not as a drop-in dynamic key.

### Chunk 3

Still worthwhile. Replace-always is currently too crude for the observed thrash.
The replacement score should prefer entries that gate large recomputation:

- shallower / fewer-queen positions;
- positions with more available moves;
- entries recently hit by root siblings;
- proven values if future archive work distinguishes stable solved entries from
  speculative/in-flight entries.

### Chunk 4

Reframe as "dynamic exact table + immutable exact-or-guarded archive layers".

Query order should be:

1. dynamic in-flight table;
2. newest immutable solved layer;
3. older immutable solved layers;
4. miss => search.

Each immutable layer must answer both "is this key in the layer?" and "what is the
value?" A value-only retrieval structure is insufficient unless guarded.

## Additional levers for n=16

1. **Per-root or per-subroot partitioning.**
   Measure HLL per distinct first move on n=14 and extrapolate to n=16. If each
   root subtree fits even though their union does not, solve/refute roots as
   separate jobs with fresh TT and persist proof certificates.

2. **Controlled Jenrich-like long run baseline.**
   The handoff reports a user run of about 2B nodes / 485 s at about 4M nodes/s.
   If a simple low-TT/no-TT path drifts toward Jenrich's 71B calls, that may still
   be an overnight-scale baseline on this hardware. Worth measuring before a large
   archive build.

3. **Exact compressed archive by ranked queen sets.**
   Thread queen sets, canonicalize, rank, external-sort runs, and store values via
   MPHF+payload or sorted Elias-Fano-like membership plus payload. This is safer
   than value-only retrieval and may still fit.

4. **Enhanced transposition cutoffs.**
   At selected shallow nodes, probe child keys first. If any child is already known
   losing for the child, the current node is immediately winning. This can reduce
   nodes but adds random TT probes, so gate it by depth/available count and A/B on
   n=12/n=14.

5. **Proof certificate extraction.**
   A final second-player proof may be far smaller than the full solved table:
   losing nodes need all child refutations; winning nodes need one losing child.
   Store a verifiable certificate, then independently replay it.

6. **Set/ZDD-style generalization.**
   Try to find regular families of equivalent losing/winning positions, especially
   near terminal depths. This is research-grade, but the 2024 setrograde result is
   a credible signal that set compression can beat state compression in some exact
   games.

## Code review: current `parallel` and `pn` solvers

This is a pre-representation-work pass over the current implementation in
`rust/src/queens.rs`.

### Findings

1. **PN repeatedly canonicalizes the same child keys inside the df-pn loop.**
   - Code: `Pn::mid`, `kids: Vec<Bits>` at `src/queens.rs:778`, repeated
     `child_pd(q, c)` at `src/queens.rs:793`, and `child_pd` computes
     `q.pos_key(child)` at `src/queens.rs:755`.
   - Why it matters: the loop can visit the same child list many times as
     thresholds tighten. Canonicalization is not free; it folds 8 symmetries.
   - Low-risk optimization: collect `(child_blocked, child_key)` once, then make
     `child_pd_key(q, child_blocked, child_key)`.
   - Expected effect: most useful for `pn`; no verdict change; node counts may
     stay the same but wall time should drop.

2. **PN scans all children even when a child is already a proven losing child.**
   - Code: `src/queens.rs:793-807`.
   - If any child has `delta == 0`, the current node is proven winning (`phi=0`);
     the exact disproof number saturates to infinity because that child has
     `phi=INF`.
   - Low-risk optimization: short-circuit the scan on `cdelta == 0` and store
     `(0, PN_INF)`.
   - Also check terminal children before TT lookup in `child_pd`: `q.no_moves`
     is much cheaper than `q.pos_key + lock`, and terminal children are immediate
     losses for the child.

3. **PN allocates a fresh `Vec` for every expanded node.**
   - Code: `src/queens.rs:778-783`.
   - Low-risk optimization: use `Vec::with_capacity(q.board.and_not(blocked).popcount()
     as usize)` before pushing children. The current filtered iterator cannot
     reserve accurately.
   - Larger optimization: a recursion-local scratch/pool is possible but more
     invasive.

4. **`Parallel`/`Tt` always recurses into terminal children.**
   - Code: `Tt::wins`, `src/queens.rs:464-466`.
   - If `child = q.place(blocked, sq)` has `q.no_moves(child)`, the current node
     is immediately winning. The current path pays a recursive call, key
     canonicalization, TT lookup, node bump, empty loop, and TT put.
   - Optimization: add a terminal-child fast path before recursion.
   - Caveat: this changes the historical node/distinct-position accounting
     because terminal positions would no longer be inserted/fed into HLL. If this
     is implemented, re-baseline `DISTINCT_POSITIONS` and update docs.

5. **`Parallel` may benefit from selective child TT pre-probes, but only behind a
   benchmark gate.**
   - Code: `Tt::wins`, static child order at `src/queens.rs:464`.
   - Idea: for shallow/high-branching nodes, probe child keys and search known
     losing children first; one known losing child proves the current node.
   - Risk: extra random probes and extra canonicalization can make this slower,
     especially in the DRAM-latency-bound regime already documented.
   - Suggested experiment: enable only for root siblings or first 1-2 plies below
     them, compare `solve 12 --distinct` and `solve 14 --distinct`.

6. **The shared TT lock granularity is probably acceptable until Chunk 2/3.**
   - Code: `QueensTt::get`/`put`, `src/queens.rs:1107` and `src/queens.rs:1123`.
   - 1024 shards keep coarse contention low; the bottleneck is random DRAM lookup
     and working-set size, not lock convoying.
   - Do not spend much time here before compact slots/replacement policy unless a
     profile shows lock wait dominating.

### Suggested order before Chunk 2

1. Implement PN child-key caching and terminal/proven-child short-circuits.
2. Re-run `cargo test --release queens::tests::solver_lineage_agrees` or the
   project test target.
3. Benchmark `queens solve 8 pn` and `queens solve 9 pn` if practical; PN is a
   negative solver, so wall-time improvement is the metric, not enabling n=16.
4. Only then try the `Tt::wins` terminal-child fast path, because it changes the
   reported distinct-position baseline and needs doc/table updates.
5. Defer child TT pre-probes until after Chunk 3 replacement, because replacement
   policy changes the hit pattern the probe optimization depends on.

## Appendix: Claude review of Codex's parallel/pn code-review (2026-06-15)

Independent pass over the same code Codex reviewed: `Tt::wins` (`queens.rs:453-471`),
`Pn::mid`/`child_pd` (`queens.rs:742-821`), `QueensTt::get`/`put`
(`queens.rs:1107-1131`), and the geometry helpers `no_moves`/`place`/`pos_key`/`canon`.

### Bottom line

All six of Codex's findings are technically correct or correctly-deferred — I
verified the df-pn `(φ, δ)` semantics, the terminal-child logic, and the TT
structure against the source. **But none of them move the n=16 needle, and that is
the headline.** Findings 1-3 optimize `pn`, a documented negative solver that will
never run n=16; Finding 4 is a constant-factor + contention win on the production
path that touches *zero* of the memory wall (the real bottleneck per fact #5 in the
main roadmap). The genuinely load-bearing contribution of Codex's review is the
**value-only-BuRR-is-unsafe** correction in the Bottom-line/Chunk-4 sections — that
matters far more than any of the code-level findings.

### The geometric fact that reframes the two production-path findings

`pos_key(blocked) = canon(board.and_not(blocked))` (`queens.rs:264`). A terminal is
exactly `no_moves(blocked)` ⟺ `board ⊆ blocked` ⟺ `board.and_not(blocked) == empty`.
So **every terminal node canonicalizes to `canon(empty) = Bits::ZERO`**, and
`hash(ZERO) = 0` → shard 0, slot 0 (traced: `[0,0,0,0]` mixes to 0). This single
fact corrects Codex on both findings that touch the production solver:

**Finding 4 (terminal-child fast path, `queens.rs:464-466`) — under-sold, and its
stated cost is wrong.**
- Codex's caveat "changes the distinct-position baseline → re-baseline
  `DISTINCT_POSITIONS`" is **essentially wrong**. All terminals share key `ZERO`, so
  they already contribute **+1** to the distinct set; the fast path drops distinct by
  ~1, not by a re-baseline-worthy amount. The load-bearing `DISTINCT_POSITIONS` table
  is untouched.
- Terminal *hits* never `bump()` either (bump is after the get-miss at
  `queens.rs:462`; hits return at `:460`). So `nodes()` barely moves — only the first
  terminal visit and rare hash-collision evictions are misses. The "re-baseline node
  accounting" worry is nearly moot too.
- The **actual** win Codex didn't name: every terminal lookup across all 24 workers
  funnels through **shard 0's mutex** (`queens.rs:1117`). The fast path replaces
  `get(ZERO)` (hot single-shard lock) with `no_moves(child)` (lock-free OR+compare).
  This is *parallel lock-contention relief* — the one finding that could plausibly
  nudge the documented "~18× parallel ≈ hardware ceiling," since part of that ceiling
  may be ZERO-shard convoying rather than pure DRAM latency.
- What it does **not** do: free TT memory. Terminals already occupy one slot, so it
  gives nothing toward the n=16 memory wall.

**Finding 2 (pn terminal reorder in `child_pd`, `queens.rs:754-762`) — correct, same
collapse applies, but `Pn::mid` is sequential**, so there's no contention benefit —
just avoiding `canon(empty)` + one lock. Minor. The `cdelta == 0` short-circuit
(`queens.rs:793-807`) is valid and equivalent: a δ=0 child forces φ(n)=0, δ(n)=∞, and
the loop's `delta_n >= th_delta` check already returns that iteration, so the
short-circuit only saves scanning the rest of one iteration.

### The rest

- **Finding 1 (cache child keys in `Pn::mid`)** — correct, the biggest pn win: the
  `loop` (`queens.rs:788`) re-runs `child_pd → pos_key → canon` (7 symmetry folds) for
  every child on every threshold-tightening iteration, though the keys are invariant.
  Caching `(child, key)` once is clean; no verdict change.
- **Finding 3 (`Vec::with_capacity`)** — correct, free, trivial.
- **Finding 5 (child TT pre-probes / ETC)** — agree with Codex's defer: in a
  DRAM-latency-bound regime extra random probes are likely net-negative.
- **Finding 6 (lock granularity fine)** — agree, no-op before Chunk 2/3, **except**
  the ZERO-shard hotspot above is a real slot-level (not granularity-level) exception
  to "contention is low."

## Appendix: Codex reply to Claude's appendix (2026-06-15)

Claude is right on the important correction.

My caveat on the terminal-child fast path was too strong: because `pos_key`
canonicalizes `available`, every terminal position keys to `Bits::ZERO`, so
skipping terminal recursion changes distinct count by at most one key, not by a
meaningful re-baseline. The better reason to do it is exactly Claude's point: it
avoids all terminal hits funneling through shard 0 / slot 0 in `QueensTt`.

Updated priority:

1. **Do `Tt::wins` terminal-child fast path before Chunk 2.** It is cheap,
   production-path, and may reduce shard-0 contention. It does not solve memory.
2. **Keep PN optimizations as optional cleanup.** Correct, but not n=16-relevant.
3. **Keep child TT pre-probes deferred.** Still likely risky in a DRAM-bound regime.
4. **Chunk 4 safety correction remains the big architectural point.** Value-only
   BuRR must be guarded by membership/fingerprint/exact dictionary.

Concrete implementation candidate in `Tt::wins`:

```rust
let child = q.place(blocked, sq);
if q.no_moves(child) || !self.wins(q, child) {
    result = true;
    break;
}
```

Then benchmark `solve 14 --distinct`; expected result is basically the same
distinct count, with possible wall-time improvement under parallel load from
removing the terminal `ZERO`-key lock hotspot.

### Re-checked: the roadmap's "8% nodes-vs-distinct = eviction re-expansion" still holds

The terminal collapse raised the question of whether the n=14 gap (53.2M nodes vs
49.3M distinct, 1.08×) is really eviction or just terminal revisits. Answer: it's
genuinely eviction/hash-collision re-expansion. Terminal revisits are TT **hits**, so
they neither `bump()` (no inflation of `nodes()`) nor add distinct keys. The roadmap's
interpretation stands.

### Priority

| Priority           | Item                               | Why                                                                                   |
|--------------------|------------------------------------|---------------------------------------------------------------------------------------|
| Worth doing now    | Finding 4 (terminal fast path)     | Cheap; relieves the ZERO-shard hot lock; only finding on the production path; re-baseline fear is unfounded |
| Batch hygiene      | Findings 1+2+3 (pn)                | Correct, low-risk, but pn never runs n=16 — do together or skip                       |
| Defer              | Findings 5, 6                      | Codex already defers; agree                                                           |

**Recommendation:** treat the whole code review as *optional pre-Chunk-2 hygiene, not
a detour from it.* Finding 4 is the one quick win with real upside on the production
path (validate: verdict-stable via `solver_lineage_agrees`, `solve 14 --distinct`
distinct ≈ 49.3M unchanged, plus any parallel speedup from dropping the ZERO-shard
lock). Fold in Findings 1-3 only if touching `pn` anyway. The substantive next step
remains **Chunk 2** (compact dynamic-tier slot) → **Chunk 4**, with Codex's
membership-guard correction baked in.

### Implementation results (2026-06-15)

Implemented Finding 4 (`Tt::wins` terminal-child fast path) and Findings 1-3 (`pn`),
incorporating Codex's two diff-review corrections. `make test`/`clippy`/`fmt` green;
`solver_lineage_agrees` (parallel n≤9, pn n≤6) and `counting_preserves_verdict` pass.

- **Finding 4 correctness — confirmed by a clean A/B** against a HEAD worktree build:
  exact distinct drops by **exactly 1** (n=10: 94,206→94,205; n=12: 1,060,824→
  1,060,823), i.e. only the shared `ZERO` terminal key, no lost merges. Verdict stays
  *second-player win*.
- **Finding 4 wall time — a wash, NOT a speedup.** Thermal-controlled *interleaved*
  `solve 14 parallel`: base median 13.20s vs f4 median 13.46s, distributions heavily
  overlapping (base 12.49–13.62, f4 13.04–13.82) ⇒ not significant. (A first, naïve
  all-base-then-all-f4 run showed a spurious ~1s "regression" that was pure mobile-CPU
  thermal throttling from the ordering.) The hoped ZERO-shard contention relief ≈ the
  added per-child `no_moves` test. **Kept anyway** (user call): correct, removes a real
  hot single-shard lock that may matter at higher core counts / larger n. Another data
  point for the roadmap's throughput-bound thesis — hot-path micro-opts wash out here.
- **Codex diff finding 1 (adopted):** the "distinct changes by ≤1 key" claim holds
  only for the *canonical* solvers; the raw-key `memo` solver keys terminals by their
  own `blocked` mask, so there `--distinct` drops *all* terminal masks. Comment
  qualified in `Tt::wins`.
- **Codex diff finding 2 (adopted, tighter than my first cut):** `mid` now detects a
  terminal child *during collection* and returns the proven `(0, ∞)` immediately —
  skipping `pos_key` for that child and every later one, and the whole df-pn loop —
  rather than computing all keys then short-circuiting in the loop. The in-loop
  `cdelta==0` short-circuit is kept for *non-terminal* table-proven-losing children;
  `child_pd` simplified (terminals never reach it). Findings 1 (cache child keys once)
  and 3 (`with_capacity`) folded in. pn n≤6 still verifies vs `naive`.
- **Table fix (`DISTINCT_POSITIONS`):** the exact entries were stale — n≤8 were the
  pre-Finding-4 counts (now −1 each: 1/4/27/625), and n=10/12 had *also* drifted ~+100
  from a prior commit (94,097→94,205; 1,060,726→1,060,823). Refreshed all to fresh
  shipped-binary measurements (n=14 re-measured at p=18 → 49,419,639, within ±0.2% of
  the old 49,346,012). `solve 12 --distinct` now reports an accurate 1.01× re-exp.

**Net:** code-review pass closed. None of it moved the n=16 memory wall (as predicted).
Next substantive step is unchanged: **Chunk 2 → Chunk 4** with the membership guard.
