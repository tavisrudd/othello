# Othello — pure Rust

A parallel pure-Rust implementation of the Python `othello` package: the same
8×8 bitboard rules, black-centred search, and engine ladder, plus a root-parallel
exact-scores path (rayon) and a documented optimisation journey.

```console
$ make release                       # znver5 + mold (host-tuned)
$ ./target/release/othello --engine strong --depth 9
$ make bench                         # depth-8 search / best_move / full game
$ make test                          # equivalence + reference tests
```

It is a faithful sibling of the Python engine — identical rules, identical
black-centred values — and the `strong` engine is the Rust equivalent of
`cython-strong`: principal-variation search (PVS) + iterative deepening + an
open-addressing transposition table with hash-move ordering.

## Layout

```
rust/
  src/
    core.rs      Board, Kogge-Stone move-gen + flips, coordinates, parsing, winner
    eval.rs      utility (terminal) + heuristic (horizon)  — shared by every engine
    game.rs      Engine trait, move iteration, black-centred move choice
    tt.rs        open-addressing transposition table (flat arena)
    search.rs    native PVS / alpha-beta over packed bitboards (the `strong` core)
    engines.rs   Minimax, AlphaBeta(+ordering), Strong (+ rayon scores), registry
    display.rs   ANSI board / score rendering
    fixtures.rs  starting positions
    play.rs      self-play driver
    cli.rs       clap CLI for the self-play driver (the `othello` binary)
    bin/queens.rs  clap CLI for the Non-Attacking Queens solver (`queens` binary)
    simd.rs      AVX2 / AVX-512 experiments (see "What didn't help")
  examples/      bench, bench_parallel, bench_simd, profile_game
  Makefile       fmt / clippy / test / release / bench / profile / pgo-release
```

## Engines

| `--engine`  | what it adds                                                        |
|-------------|--------------------------------------------------------------------|
| `minimax`   | plain minimax + depth-keyed cache (ground truth)                   |
| `alphabeta` | fail-soft alpha-beta + bound-tracking transposition table         |
| `ordered`   | + mobility move ordering                                           |
| `strong`    | native PVS + iterative deepening + hash-move ordering + aspiration; native exact endgame solver for `--depth full` (≈ cython-strong) |
| `strong+`   | `strong` with a stronger horizon eval (X/C-square + frontier penalties) — **changes the value** (stronger play) |
| `strong++`  | `strong+` plus **Multi-ProbCut** forward pruning (calibrated) — strength-neutral *per depth*, ~1.3–2.7× faster, so it searches deeper in the same time |

The first four compute **identical** black-centred values — pruning, ordering,
and parallelism change only the node count, never the value. This is asserted in
the test suite (cross-engine agreement, an independent grid-arithmetic reference
for move-gen/flips, and the exact endgame-solve values 6 / −40 / 4). `strong+`
and `strong++` deliberately change the value: `strong+` scores **77.5 %** against
`strong` over 60 colour-balanced games (`make match-plus`); `strong++` adds forward
pruning that is strength-neutral at equal depth (**48 %** vs `strong+` @ depth 8,
*n*=200) but ~1.3–2.7× faster, so at one ply deeper it scores **66 %**
(strong++ @ 9 vs strong+ @ 8). Both keep the eval-independent exact endgame solve
identical to `strong` (Multi-ProbCut only touches the finite-depth `pvs`).

## Parallelism (rayon)

`Strong::scores` is **root-parallel**: every legal move's child is an independent
full-window search (`NEG..POS`), so the per-move values are exact and
order-independent. They fan out across up to `--threads`/`OTHELLO_THREADS` workers
(default 8), each owning a *private* preallocated transposition table — there is
no shared mutable state and no lock. The exact-scores path scales roughly:

| threads | full self-play game (exact scores) |
|--------:|-----------------------------------:|
| 1       | ~275 ms                            |
| 8       | ~112 ms                            |
| 16      | ~90 ms (3.1×)                       |

Scaling tapers past 8 workers (shared-L3 pressure, bounded by keeping each
worker's table small — `2^13` entries). `best_move`, by contrast, stays a
**single rooted PVS search**: sibling pruning + one cache-resident table beats
fan-out for these sub-millisecond per-move searches, and the LSB-order root with
strict `>` keeps the exact same move (and tie-break) as `best_by_side` over the
exact scores.

## Multi-ProbCut (`strong++`)

The dominant Othello *search* win (Buro/Logistello). At an interior node, before
the full-width search, a cheap shallow search predicts the deep value via a
calibrated linear model `v_deep ≈ a·v_shallow + b` with residual std `σ`. If a
shallow null-window search proves the value clears the `(α, β)` window by `t·σ`
(`t = 1.5`), the deep search is pruned. It is **forward** pruning — not
value-preserving — so it pairs with a strength match, not the equivalence tests.

Coefficients come from `examples/calibrate_mpc.rs`: it plays ε-random
`strong+`-guided games, takes the exact (MPC-off) PVS value at every shallow and
deep depth, and regresses `v_deep` on `v_shallow` per `(depth-pair, disc-count)`.
Everything is in **side-to-move (negamax) units**, which are colour-swap
invariant, so both sides pool into one fit. The table (`src/mpc.rs`) is
re-generatable and reviewable. `σ` is the key signal: ~4 in the open game (a
shallow search predicts the deep one tightly) rising to ~35 near the endgame
(shallow searches mispredict tactical swings), so MPC **self-disables** exactly
where it would blunder. Probes use a shallow depth below `MPC_MIN_DEPTH`, so they
never re-trigger MPC (no nesting), and the exact endgame solver never calls
`pvs`, so `--depth full` stays exact.

| measurement (`make match` / `make bench`, depth 8–9) | result |
|------------------------------------------------------|--------|
| iso-depth strength: `strong++` vs `strong+` @ 8      | **48.0 %** (95–103–2, *n*=200) — strength-neutral |
| equal-depth speed @ 8                                | 178 → **133 ms** (1.34×) |
| equal-depth speed @ 9                                | 972 → **357 ms** (2.7×) — the win grows with depth |
| one ply deeper: `strong++` @ 9 vs `strong+` @ 8      | **66.0 %** (128–64–8, *n*=200) |

The speedup compounds with depth (more levels above `MPC_MIN_DEPTH` to prune), so
the deeper you search the more MPC buys — and the extra depth it funds is what
turns "same strength, less time" into "more strength, same ballpark of time."

## Performance

Headline figures on the dev box (AMD Ryzen AI 9 HX 370, Zen 5; `make bench`,
single machine — relative steps are the point):

| metric                                    | time     |
|-------------------------------------------|----------|
| single depth-8 search (`search_strong`)   | ~0.27 ms |
| depth-8 `best_move` from the opening      | ~0.5 ms  |
| full depth-8 self-play game (62 plies)    | ~76 ms   |

The full **game** is 62 separate depth-8 analyses; a single depth-8 *move* — the
natural unit — is well under a millisecond.

### What worked

| step                          | effect                | idea                                                   |
|-------------------------------|-----------------------|--------------------------------------------------------|
| native bitboards + PVS        | baseline              | u64 wraps natively; no FFI boundary in the inner loop  |
| single rooted `best_move`     | game 488 → ~120 ms    | sibling pruning instead of N full-window child searches |
| lazy flips at shallow nodes   | game ~185 → ~120 ms   | compute flips only for moves actually searched (same order → same nodes) |
| open-addressing arena TT      | —                     | flat `Vec`, full-key compare (collision = miss, never wrong) |
| `target-cpu=znver5` + mold    | game ~120 → ~100 ms   | POPCNT / BMI / AVX; **see the config footgun below**   |
| root-parallel exact scores    | scores 333 → 90 ms    | independent full-window children, private TT per worker |
| preallocated TT arena         | no mid-search allocs  | one allocation up front, reused warm across moves       |
| aspiration windows (ID)       | game ~100 → ~76 ms    | narrow window around the previous iteration; widen on a miss (value-preserving; tie-break kept) |

### What didn't (the instructive failures)

- **The `target-cpu` was silently dropped.** The global `~/.cargo/config.toml`
  sets `[target.x86_64-unknown-linux-gnu].rustflags` (the mold linker), which
  *shadows* a project `[build].rustflags`. The fix is to put `target-cpu` under
  the **same** `[target.*]` key so cargo merges the arrays. Worth ~1.2× — and
  every earlier number had been measured on a generic baseline.
- **Root-parallel `best_move` is slower than sequential rooted.** Depth-8
  per-move searches are sub-millisecond; fan-out loses sibling pruning and
  cross-child TT reuse, and the overhead dominates. Parallelism only pays on the
  exact-scores path (which *needs* every sibling searched) and on deeper single
  searches.
- **SIMD across the eight ray directions is slower** (~0.96×). Broadcasting the
  board and the per-call horizontal OR-reduce cost more than the scalar
  Kogge-Stone fill (already ~1.4 ns).
- **Batched SIMD *does* amortise the setup** — `legal_moves_x8` scores eight
  boards per AVX-512 call at ~1.35× the scalar throughput (lanes = positions,
  immediate shifts, no horizontal reduce). But wiring it into the move-ordering
  was **neutral end-to-end**: the orderable mobility is too small a slice of the
  total, and the hot path is leaf-dominated. Kept as a benched primitive
  (`make bench-simd`); reverted from the search to keep it simple.
- **PGO was a wash.** The inner loop is already tight with predictable branches.
  The `pgo-release` target exists for completeness.
- **Killer-move ordering *regressed* the game** (~75 → ~86 ms) while keeping
  values correct. Hash-move + mobility ordering is already near the minimal tree;
  depth-indexed killers from other positions displace good moves and add per-node
  overhead — net negative, like the rejected positional-weight ordering. Reverted.
- **"Outflank" (PEXT-style) flips were a microbench mirage.** A branchless
  nearest-blocker flip (precomputed ray masks + `blsi`/MSB isolate) is **~5×** the
  walk on a *random-board* microbench, but **~4 % slower in real self-play**: actual
  flip runs are short, so the walk early-exits in 1–2 predictable steps with no
  table load, while the outflank pays fixed work + a `RAY[sq]` load every call.
  Reverted; kept as `flips_outflank` (`make bench-flips`) — the in-process A/B
  game benchmark is the one to trust, not the kernel microbench.

## Build

```console
$ make release          # cargo build --release, znver5 on Zen 5 (else native) + mold
$ make test             # cargo test --release
$ make clippy           # cargo clippy --all-targets -- -D warnings
$ make bench            # headline benchmark
$ make bench-parallel   # parallel scaling (1..16 workers)
$ make profile          # perf record + report of the full depth-8 game
$ make pgo-release      # profile-guided build (needs llvm-tools-preview)
```

`OTHELLO_THREADS=N` overrides the root-parallel fan-out width at runtime.

## Bonus: Non-Attacking Queens (`queens`)

A second binary in the crate: the adversarial **Non-Attacking Queens** game
(Noon & Van Brummelen, 2006). Two players alternately place a queen so no two
attack each other (no shared row, column, or diagonal); whoever cannot move
loses (normal play). It is an *impartial* combinatorial game — a queen is
colourless, so the legal moves depend only on the position, captured entirely by
the **blocked mask** (occupied ∪ attacked). Placing a queen always adds the same
attack set, so the whole game is a negamax over that mask, with transpositions
merged by memoising on it. The board is a fixed multi-word bitset, so sizes up to
16×16 fit (tractability runs out first).

```console
$ cargo run --release --bin queens -- solve 8            # who wins the empty board
$ cargo run --release --bin queens -- solve 10 symmetry  # pick a solver (A/B)
$ cargo run --release --bin queens -- self  6            # watch an optimal line
$ cargo run --release --bin queens -- play  8 1          # play the engine as player 1
$ cargo run --release --bin queens -- count 14 --parallel  # distinct positions (HLL)
```

Squares are named file+rank (`d1`). It reproduces the paper's headline — on 8×8
the **first player wins** — and extends past it:

| board   | 1–9   | 10        | 11    | 12        | 13    | 14        | 15    |
|---------|-------|-----------|-------|-----------|-------|-----------|-------|
| winner  | first | **second**| first | **second**| first | **second**| first |

**Every odd board is a first-player win**; small even boards (≤ 8) are too, then
10/12/14 flip to the second player.

### Odd boards are a theorem, not a search

The odd-`n` result needs **no search** — it is a classic strategy-stealing
(pairing) argument. The first player takes the **centre**; the centre attacks all
four lines through it, so any legal reply `s` is off those lines, which is exactly
the condition for `s` not to attack its 180° rotation `s'`. By symmetry `s'` is
free, so the first player always has the mirror response and the second player
runs out of moves first. That makes every odd board **O(1)**: 15×15 went from a
~460 s search to instant. (The game being impartial under normal play, this is a
Sprague–Grundy N-position witnessed by the pairing.) Only **even** boards search.

### The solver lineage (mirrors the Othello engine ladder)

Like the Othello engines, the search is a ladder — each step adds one idea, all
compute the **same** win/loss, and the simpler ones are kept as ground truth
(`solver_lineage_agrees` cross-checks them against the memo-less `naive`):

| `solver`   | adds                                                       | n=8 nodes |
|------------|------------------------------------------------------------|-----------|
| `naive`    | plain win/loss + α-β cutoff, no memo (ground truth)        | 23,099    |
| `memo`     | + fixed-size transposition table (raw-mask key)            | 1,278     |
| `symmetry` | + dihedral (8-fold) canonical keys                         | 626       |
| `parallel` | + rayon root parallelism (YBWC) + odd-board O(1)           | 625       |
| `nimber`   | the full Sprague-Grundy value (`mex`, **no cutoff**)       | 9,040     |
| `pn`       | df-pn proof-number search (experimental — see below)       | 5,411     |

The `nimber` solver computes the exact game value, not just win/loss
(`queens nimber N`), and is cross-checked against **OEIS A344227** (the nimber
sequence for this game). Because `mex` needs every child there is no cutoff, so
it is far heavier — n=12 is ~265× the win/loss node count (283M vs 1.07M); it is
root-parallel (over the dihedral-distinct first moves, two levels deep) but the
blowup is algorithmic, so exact nimbers past n≈13 are out of reach this way.

`pn` (df-pn proof-number search) is the textbook state of the art for boolean
games, but it is **an instructive negative here**: the verdicts are correct, yet
this game is so transposition-dense that plain df-pn hits the known df-pn +
transposition (graph-history-interaction) pathology — positions solved via one
path are re-expanded via another — and it explodes past tiny boards (n=8 fine,
n≥9 impractical). `parallel` dominates it. Making df-pn competitive needs
*careful* DAG-aware proof-number search (Čížek–Balko–Schmid 2026); the solver is
kept as a correct, documented experiment, not the recommended path.

**Canonicalising the *available* squares, not `blocked`.** The transposition key
is the canonical image of `board & !blocked`, not of `blocked` itself. Available
is a pure function of `blocked`, so this merges the **identical** equivalence
classes (no transposition lost) — but for the deep majority of nodes nearly every
square is blocked, so `available` has far fewer set bits and the 8-image `canon`
does proportionally less work. It is pure speedup: n=8 node counts are unchanged
(`memo` 1,278 → `symmetry` 626), 14×14 dropped from ~78 s to **~33 s** (2.4×, same
53M nodes), and it *flipped* the old node-vs-wall-clock lesson — at n=10
`symmetry` (94k nodes) used to be slower than `memo` (603k) because `canon` cost
more than it saved; now `symmetry` is **faster** in wall-clock too (0.055 s vs
0.188 s), and `parallel` is faster still (0.038 s). `parallel` is the default.

### Scaling the even boards (the Othello playbook)

- **A fixed-size transposition table** (`QueensTt`) instead of an unbounded map:
  a flat, **lockless** open-addressing array — one `Box<[AtomicU64]>` with relaxed
  load/store, no mutex and no sharding (a 64-bit slot can't tear). Each slot is a
  compact **8 bytes** — a used bit, the value, and a **55-bit fingerprint** of the
  canonical key rather than the full 256-bit key (Chunk 2). The slot index already
  pins most of the routing hash, so an *independent* fingerprint makes a wrong
  "hit" a ~`2⁻⁵⁵` event per colliding probe — negligible across even a `10¹¹`-node
  search, with the verdict cross-checked against the known result — while a
  fingerprint *mismatch* is still just a miss that recomputes. The arena is backed
  by **transparent huge pages** (`MADV_HUGEPAGE`) to cut TLB misses on the random
  probes. **Memory is a hard cap** (`2^bits` slots; `QUEENS_TT_BITS` to tune), not
  something that grows with the search — 14×14 solves in a fixed ~1.1 GB (5× less
  than the old full-key slot) instead of an unbounded `HashMap`.
- **Root parallelism with a Young-Brothers-Wait guard.** The symmetry-distinct
  first moves fan out across rayon workers sharing the table. But a naïve
  `par_iter().any()` *regresses* first-player wins badly (~40× on 13×13): workers
  speculatively search whole losing subtrees the sequential cutoff would skip. So
  the best-ordered move is searched **sequentially first** — if it wins, we are
  done with no speculation — and only its siblings parallelise (the
  must-refute-everything case of a second-player win). This recovers the
  sequential node count on first-player wins *and* parallelises the hard boards.

### The n=16 frontier is a memory problem

n=16 is a known second-player win (Jenrich, 2014; 71B calls, no table) but is out
of reach of a single-box transposition table here: the search must retain its whole
*distinct* working set, and that set is large. `queens count N` measures it directly
— a HyperLogLog (lock-free, ~0.4% error) folds in every canonical key the search
visits, with an exact hash set to validate it on the small boards. The distinct
count climbs **94k → 1.07M → 49.3M** at n=10/12/14, *accelerating* (11× then 46× per
two-step), which extrapolates to **billions** at n=16 — far past what even a
compact 8 B/slot fingerprint table can hold in tens of GB. (The familiar "53M at
n=14" is the *node*
count; eviction re-expansion inflates it ~8 % above the 49.3M distinct truth.) So
n=16 needs a fundamentally denser encoding of the solved set — the open frontier.

The win/loss value is exact, so the search is α-β with a hard cutoff (the first
move handing the opponent a loss proves a win); the board's 8-fold dihedral
symmetry canonicalises every position, merging ~8× of the states. 12×12 drops
from ~6.3 s to ~0.6 s; 14×14 (53M nodes) lands in ~33 s on 24 threads (with the
available-canon key above; ~78 s before it).

### How it compares to the published baselines

The game has been solved before, but only one prior program reports search counts:
**Thomas Jenrich's QPGAME3** (2014, Turbo/Free Pascal on a 1 GHz Pentium III). It uses
*partial* symmetry — the full group on the first move, half-turn rotation when player 2
re-establishes it — but **no transposition table**. Its verdicts match ours on every
board; the per-node dihedral canon **plus** the TT make `parallel` far more node-
efficient, and the advantage *grows* with `n`:

| n  | Jenrich "sum of calls" | `parallel` nodes | distinct positions | node-efficiency |
|----|------------------------|------------------|--------------------|-----------------|
|  8 |                  2,266 |              629 |                625 |            3.6× |
| 10 |                653,007 |           94,870 |             94,205 |            6.9× |
| 12 |             11,334,613 |        1,069,880 |          1,060,823 |           10.6× |
| 14 |          1,161,385,667 |       53,300,665 |         49,141,396 |           21.8× |
| 16 |         71,461,975,237 |        *unsolved* |  ~9.2B (HLL est.) |             —   |

Jenrich's n=14 took ~19 min on his hardware vs ~11 s here on 24 threads, but the
hardware-independent figure is the **~22× fewer search calls**. His n=16 leaned on a
hand-built opening book for player 2's first two replies and still ran ~23 h — so he
*reached* a board our table can't yet hold (above), while we hold the efficiency crown
on n ≤ 14.

Other solvers of this exact game: **Max Fan's general-graph Node-Kayles calculator**
(Rust) computed the full nimbers OEIS A344227 lists through n=13 — deeper than our
`nimber` mode, which stalls there — and **Matthew Bardoe's** Python implementation covers
the torus variant. None reports win/loss faster than `parallel`. This is a *different
problem* from the famous **n-queens counting** records (e.g. the Q27 project's n=27):
those enumerate placements (a #P task) rather than solve a two-player game (PSPACE-
complete here), so the node counts are not comparable — only the bitmask move generation
is shared.

### Future directions (a performance literature search)

The search is **TT/DRAM-latency-bound** (above), so the cheapest wins target per-node
memory traffic rather than the algorithm:

- **Lockless, unsharded TT + prefetch + huge pages — done (Session 5).** Each slot is a
  single `u64`, so the whole `Vec<Mutex<Box<[Slot]>>>` became one flat
  `Box<[AtomicU64]>` with relaxed load/store — no lock, no sharding, and (because a
  64-bit slot can't tear) no Hyatt XOR-key trick; the 55-bit fingerprint already turns a
  foreign entry into a miss. The search software-**prefetches** each child's slot before
  recursing (the Stockfish trick), and the arena is `MADV_HUGEPAGE`-backed. Together a
  modest, real win (~3–5 % wall on 14×14 parallel, growing under thermal load; prefetch
  alone ~2 %), and the prerequisite contiguous arena the bucketing lever below wants.
- **Cache-line bucketing** — several slots per 64-byte line, probed together.
- **Better move ordering** (history / killer heuristics) on top of the static
  most-blocking-first order, to shrink the α-β tree.
- **Graph-canonical hashing** of the residual *available*-graph (nauty / bliss) instead
  of the static board D4 — it captures the extra automorphisms deep lines acquire (likely
  how Max Fan reached the n=13 nimber), merging more transpositions.
- **Dynamic decomposition.** The full board is biconnected, but residual graphs fragment
  in the endgame; a connected-components check plus a nim-sum over a cached small-component
  nimber table prunes — and compresses — exactly where `mex` is cheap.

For the **n=16 memory wall**, the structural lever is that **transpositions are strictly
intra-ply**: every move places one queen, so two positions that transpose share a queen
count. That partitions the table by ply and licenses *windowing* it — a ply-layered,
**external-memory delayed-duplicate-detection** solve (Korf; Zhou–Hansen) streams all but
a band of plies to disk (the billions of distinct positions fit there at a few bytes
each), and each fully-solved ply freezes into a **BuRR / ribbon** value-only archive
(~1.1 bits/position) so resident memory collapses as the search matures.
