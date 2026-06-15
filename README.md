# Othello

An 8×8 Othello (Reversi) engine: a small, typed Python core with interchangeable
minimax/alpha-beta AI engines, plus optional Cython extensions that move the hot
path into native code. The same search is available as a readable pure-Python
reference and as a compiled engine that is hundreds of times faster.

```console
$ python -m othello --engine cython-ordered --depth 8
```

It plays itself, printing each position, the per-move scores, and the chosen
move. The point of the project is as much the **journey** — a documented series
of optimisation experiments, including the ones that didn't work — as the engine
itself.

## Quick start

```console
$ python -m othello --help                 # options
$ python -m othello                         # default: ordered engine, opening
$ python -m othello --engine cython-strong --depth 9
$ python -m othello --start either --depth full      # exact endgame solve
$ python -m othello --board-file pos.txt --to-move white

$ ./build_ext.sh        # optional: build the native extensions (gcc + uvx cython)
$ uvx pytest            # tests
$ uvx ty check          # type-check
```

The native extensions are optional: without them everything runs on the
pure-Python fallback (same results, slower). Build artifacts are gitignored —
run `./build_ext.sh` after cloning to get the fast path.

## Design

### Bitboards

A position is two 64-bit integers (`black`, `white`) plus the side to move,
wrapped in a frozen, slotted dataclass (`core.Board`). Square *i* is bit *i*,
file A..H = bits 0..7 within a rank, rank 1..8 = the eight bytes.

Legal-move generation and disc-flipping are pure bit arithmetic. Move generation
is a **Kogge-Stone parallel-prefix occluded fill** per ray (three shift-doubling
steps); flipping walks the captured run per ray with an early exit. Both inline
the eight direction shifts (with edge masks to stop file wrap) rather than
calling helper functions.

### Game core vs. AI

The split is deliberate:

- **`core`** knows only the *rules*: board state, legal moves, make-move,
  terminal detection, and who wins. No scoring.
- **`ai.evaluation`** owns the *evaluation* — scoring is a search concern, not a
  rule. `utility` is the exact terminal disc differential; `heuristic` is the
  estimate used at depth-limited horizon nodes.
- **`game`** is the thin interface the engines search over: the `GameState`
  protocol (bitboard data + rule mechanics), move iteration, the black-centred
  move-choice rule, and the `Engine` base class.

### Evaluation

- **`utility(state, player)`** — disc differential (own discs − opponent's),
  used at game-over nodes. Its sign already encodes win/loss/draw, so it's a
  strict refinement of win/draw/loss scoring: optimal play maximises the winning
  *margin* without ever trading away the outcome, and equal-outcome moves are no
  longer broken arbitrarily.
- **`heuristic(state, player)`** — used at the search horizon, where disc count
  alone is a poor guide (more discs mid-game is often *bad*). It weights corners
  (permanently stable), mobility (how many legal moves each side has), and discs:
  `25·corners + 5·mobility + 1·discs`. Switching the horizon from raw disc count
  to this removed the disc-count blowouts in shallow self-play.

### Search

All engines use **black-centred** minimax: values are absolute (from Black's
point of view), not relative to the side to move. Black maximises, White
minimises. Because the value is a pure function of the position, it is
path-independent, which makes the transposition table sound across the whole game
DAG (the key need not encode how the position was reached).

Layered up:

- **Minimax** — plain, full search. A depth-keyed cache memoises positions.
- **Alpha-beta** — fail-soft, with a **bound-tracking** transposition table.
  Pruning makes a node's value a *bound*, not the exact value, so each cache
  entry carries a flag (`EXACT` / `LOWER` / `UPPER`); the lookup uses the bound
  to tighten the window and only returns early on `EXACT` or a window collapse.
  Roughly 47× fewer nodes than plain minimax at depth 6.
- **Depth-aware cache** — the key is `(position, depth)`. A heuristic-cutoff
  value at one horizon must never be reused as a deeper/exact one. For full
  searches (`depth=None`) the component is constant, so transpositions still
  share entries.
- **Move ordering** — mobility (search the move leaving the opponent the fewest
  replies first), gated by remaining depth.
- **Heuristic horizon** — terminal nodes use exact `utility`; depth-limited
  horizon nodes use the positional `heuristic`.

### The engines

All engines implement the same `Engine` interface (`scores`, `best_move`) and
are interchangeable via `--engine`. Each owns its own transposition table.

| `--engine`       | class                    | what it adds                                |
|------------------|--------------------------|---------------------------------------------|
| `minimax`        | `Minimax`                | plain minimax (baseline / ground truth)     |
| `alphabeta`      | `AlphaBeta`              | alpha-beta + bound-tracking TT              |
| `ordered`        | `AlphaBetaOrdered`       | + mobility move ordering                    |
| `cython`         | `CythonAlphaBeta`        | the whole search in native code             |
| `cython-ordered` | `CythonAlphaBetaOrdered` | native search + mobility ordering           |
| `cython-strong`  | `CythonStrong`           | + PVS, iterative deepening, hash-move hints |

The cython engines produce **identical values** to the Python engines (asserted
in the test suite); they fall back to the equivalent Python engine when the
extension isn't built or for `depth=None` (the native search is finite-depth).
Each engine declares its own `default_depth`; the CLI uses it when `--depth` is
omitted.

## Native extensions (Cython)

Two optional compiled modules, pure C (no C++), built by `./build_ext.sh`:

- **`_bitboard.pyx`** — `uint64` `legal_moves` / `flips_for_move`. `core.Board`
  swaps these onto itself when present, else uses the bit-identical pure-Python
  methods.
- **`_search.pyx`** — the whole alpha-beta inner loop in C over packed bitboards:
  no `Board` objects, native recursion, inlined make-move. Exposed via the
  cython engines.

The transposition table (`_search.TranspositionTable`) is a native
open-addressing hash table — a flat C array, full-key compare so a hash collision
just misses and recomputes (never a wrong entry), always-replace on collision.
It is deliberately **small** (default ≈ 1.5 MB) so it lives in L2/L3 cache.

Correctness is guarded by reuse of the pure-Python reference: the test suite
verifies whichever kernels are active (compiled or fallback) against an
independent grid-based move/flip implementation over thousands of positions
including random bitboards (to stress edge wrap), and asserts the native search
matches the Python `AlphaBeta` value-for-value.

## Performance experiments

The headline benchmark is a full **self-play game from the opening at depth 6**.
Numbers are illustrative (one machine), but the *relative* steps and the lessons
are the point.

### What worked

| step                            | effect                      | idea                                                          |
|---------------------------------|-----------------------------|---------------------------------------------------------------|
| disc-differential utility       | —                           | margin-aware, strict refinement of W/D/L                      |
| `_make_move_unchecked`          | —                           | search skips the legality re-check per child                  |
| alpha-beta + bound TT           | ~47x fewer nodes (d6)       | the TT needs bound flags to stay sound                        |
| mobility move ordering          | up to ~1.6x                 | search the move restricting the opponent most, first          |
| `value()` hot-path rewrite      | ~3.4x (-> 4.25s)            | one legal-move sweep/node not three; hoist; branch vs max/min |
| inline direction shifts         | ~1.23x                      | drop the per-shift function-call overhead                     |
| Kogge-Stone fill                | ~1.5x on move-gen           | 3 shift-doubling steps instead of 6 linear                    |
| `slots=True` on `Board`         | small                       | many boards allocated per game                                |
| native bitboard kernels         | ~58x / ~22x on kernels      | uint64 in C; full game ~2.5x (Amdahl-capped)                  |
| native search (whole loop in C) | depth-8 game ~16s -> ~3.7s  | no Board objects, native recursion                            |
| native open-addressing TT       | depth-8 game 3.65s -> 0.46s | drop Python-dict boxing; small table stays in cache           |

Cumulatively, a depth-6 game went from **~14.6 s (original Python) to ~0.06 s
(~240×)**; a depth-8 game is ~0.46 s.

### What didn't (the instructive failures)

- **Positional square-weight ordering** — a corner/edge weight table as a
  *move-ordering* heuristic *increased* node count: edge moves are weak in the
  opening, so it tried the genuinely-best central moves last. Mobility ordering
  is the robust choice.
- **`cProfile` lied.** It inflates the cost of tiny, very-hot functions via
  per-call overhead, which made the first shift-inlining look like a *regression*.
  In-process A/B benchmarking (min of repeats) was the reliable method.
- **Fill-based flips** — recasting `flips_for_move` into the same parallel fill
  as `legal_moves` was elegant but ~2.6× *slower*: the `while`-loop early-exits
  when an opponent run ends (usually 1–2 steps), while a fixed fill always does
  the worst case. Reverted to the early-exit walk.
- **Loop unrolling** the fill was only ~1.08× (the int-object allocation per op
  dominates, not loop control) — not worth the verbosity.
- **Bigger transposition table is slower.** Counter-intuitively, a ~1.5 MB table
  beat a ~96 MB one by ~3× at depth 8: cache-local probes beat the extra
  recompute from eviction. Smaller (cache-resident) wins.
- **Zobrist hashing buys nothing here.** Its appeal is *incremental* hashing for
  square-array state; with the position already in two integers we hash it in
  O(1), and a Zobrist-only key would trade exact-match correctness for collision
  risk. The cache-density win was captured instead by making the *table* small.
- **Root-level iterative deepening** made `cython-strong` ~1.1–1.45× *slower*.
  The per-child path finishes each move's full deep search before the next, so
  later moves transpose into complete deep TT entries; searching every move
  shallow-first per iteration loses that, and the deep cross-move TT reuse is
  worth more than the ID ordering benefit.
- **C++ was never needed** — everything is plain C via Cython.

### The even–odd effect

With good move ordering the search approaches the *minimal* alpha-beta tree,
whose size alternates by parity: going from an even depth to the next odd one
multiplies by ≈`(b+1)/2`, but odd→even only by ≈`2b/(b+1)`. So depth 8→9 jumps
much more than 9→10. It's most visible on `cython-strong` (best ordering →
closest to the minimal tree) — a *sign the ordering is working*, not a bug.

## Layout

```
othello/
  core.py        types, Board, rules (Kogge-Stone move-gen, flips), parsing, winner
  display.py     ANSI board / score rendering
  fixtures.py    starting positions
  game.py        GameState protocol, move iteration, Engine base class
  ai/
    evaluation.py        utility (terminal) + heuristic (horizon)
    minimax.py           Minimax
    alphabeta.py         AlphaBeta (bound-tracking TT)
    alphabeta_move_ordering.py   AlphaBetaOrdered (mobility ordering)
    cython_alphabeta.py  Cython engines (+ pure-Python fallback)
  play.py        play_game(board, engine, depth)
  cli.py         argparse CLI
  __main__.py    python -m othello
  _bitboard.pyx  native uint64 legal_moves / flips
  _search.pyx    native alpha-beta search + TranspositionTable
build_ext.sh     build the native extensions
test_othello.py  test suite
```

## Development

```console
$ ./build_ext.sh     # build _bitboard + _search (needs gcc and `uvx cython`)
$ uvx pytest         # run the tests (skip the native-only ones if unbuilt)
$ uvx ty check       # type-check (the codebase leans on modern typing)
```

The test suite is parametrised over every engine, checks move-gen and flips
against an independent reference (including random bitboards), asserts the cython
engines match the Python ones value-for-value, and validates the CLI and board
parsing. The pure-Python kernels stay as the reference and fallback for the
compiled ones, so a fresh checkout is correct (just slower) before building.
