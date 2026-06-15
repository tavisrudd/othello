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
    cli.rs       argument parser (mirrors the Python argparse CLI)
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
$ cargo run --release --bin queens -- solve 8     # who wins the empty n×n board
$ cargo run --release --bin queens -- self  6     # watch an optimal line
$ cargo run --release --bin queens -- play  8 1   # play the engine as player 1
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

### Scaling the even boards (the Othello playbook)

- **A fixed-size transposition table** (`QueensTt`) instead of an unbounded map:
  a flat, sharded, open-addressing array (full-key compare, so a collision is a
  miss → recompute, never a wrong answer), exactly like `tt.rs`. **Memory is a
  hard cap** (`2^bits` slots; `QUEENS_TT_BITS` to tune), not something that grows
  with the search — 14×14 solves in a fixed 5.4 GB instead of an unbounded `HashMap`.
- **Root parallelism with a Young-Brothers-Wait guard.** The symmetry-distinct
  first moves fan out across rayon workers sharing the table. But a naïve
  `par_iter().any()` *regresses* first-player wins badly (~40× on 13×13): workers
  speculatively search whole losing subtrees the sequential cutoff would skip. So
  the best-ordered move is searched **sequentially first** — if it wins, we are
  done with no speculation — and only its siblings parallelise (the
  must-refute-everything case of a second-player win). This recovers the
  sequential node count on first-player wins *and* parallelises the hard boards.

The win/loss value is exact, so the search is α-β with a hard cutoff (the first
move handing the opponent a loss proves a win); the board's 8-fold dihedral
symmetry canonicalises every position, merging ~8× of the states. 12×12 drops
from ~6.3 s to ~1 s; 14×14 (53M nodes) lands in ~78 s on 24 threads.
