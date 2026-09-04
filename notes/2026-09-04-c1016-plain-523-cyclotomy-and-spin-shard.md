# C1016 — the plain `Z/523` route: cyclotomy is empty, the spin shard is the real target

**Lane**: `complete-ports` · **Task**: C1016 · 2026-09-04.

Acting on move B of the Fable reduction review
(`2026-09-03-c1016-fable-reduction-review.md`): the plain (unbordered)
four-block supplementary difference set on `Z/523`, whose hit is a Hadamard
matrix of order 2092 outright through a Goethals--Seidel array with no border.

The review ranked this move as "minutes per `(e, parameter set)`" for cyclotomic
index `e = 6, 9, 18, 29`. That estimate does not survive contact: every one of
those shards is empty for every admissible parameter set, and the emptiness is a
two-line congruence. What is left is a different and much better conditioned
object — the order-three spin shard, which collapses the 261 independent
correlation equations to 87.

## The object and its exact parameter identities

A Goethals--Seidel array of order `4v` needs four `+-1` sequences `a_i` of
length `v` with `sum_i PAF_i(s) = 0` for every nonzero shift. Writing
`a_i = 1 - 2 x_i` for the indicator of a block `X_i` of size `k_i` and
`C_i(s) = sum_j x_i(j) x_i(j+s)` gives `PAF_i(s) = v - 4 k_i + 4 C_i(s)`, so the
array condition is exactly the supplementary-difference-set condition
`sum_i C_i(s) = lambda` for all `s != 0`, with `lambda = (sum_i k_i) - v`.

Two identities pin the admissible parameters. Summing that condition over every
nonzero shift gives `sum_i k_i^2 = v (K - v + 1)` with `K = sum_i k_i`. Summing
the `+-1` form over every shift including zero gives the row-sum identity

    sum_i (v - 2 k_i)^2 = 4 v.

Since `v` is odd each `d_i = v - 2 k_i` is odd, and complementing a block
negates its sequence without changing any autocorrelation, so `d_i > 0` may be
assumed. **The admissible parameter sets are exactly the representations of `4v`
as a sum of four positive odd squares.** At `v = 523` there are 33 of them,
confirming the review's count from a different derivation, and both Djokovic
"special" sets `(240; 257,257,257)` with `lambda = 488` and
`(244; 253,253,253)` with `lambda = 480` appear.

## The cheap cyclotomic tier is empty, and the reason is a size congruence

Let `H <= Z_523^*` have order `t`. Its orbits on `Z_523` are `{0}` together with
`522/t` free orbits of size `t`, so any `H`-invariant block has
`|X| = 0` or `1 (mod t)`. A cyclotomic shard at order `t` is therefore empty for
a parameter set unless all four block sizes meet that congruence. Sweeping every
divisor of 522:

| subgroup order `t` | classes `e = 522/t` | admissible parameter sets surviving |
|--------------------|---------------------|-------------------------------------|
| 2                  | 261                 | 33                                  |
| 3                  | 174                 | 22                                  |
| 6                  | 87                  | 2 — `[241,252,259,259]`, `[247,247,252,258]` |
| 9                  | 58                  | 2 — `[243,252,252,261]`, `[244,253,253,253]` |
| 18                 | 29                  | 0                                   |
| 29                 | 18                  | 0                                   |
| 58                 | 9                   | 0                                   |
| 87                 | 6                   | 0                                   |
| 174                | 3                   | 0                                   |
| 261                | 2                   | 0                                   |
| 522                | 1                   | 0                                   |

So **no plain four-block supplementary difference set on `Z/523` with any
parameter set is invariant under a multiplier subgroup of order 18 or more.**
This is an exact exclusion, not a filter, and it costs milliseconds.

The review's ranking read the index and the subgroup order in opposite
directions. Its cheap tier — cyclotomic index `e = 6, 9, 18, 29`, meaning
subgroup order `t = 87, 58, 29, 18` — is exactly the excluded region. The tiers
that survive are `t = 2, 3, 6, 9`, whose class counts are `261, 174, 87, 58`, so
the free bits per block are `2^58` at best rather than `2^7`. Order 9 survives
only for the two parameter sets above, and `C(58,27)` is about `2.6 * 10^16`
blocks, so an exhaustive cyclotomic sweep is out of reach at every surviving
order. The one-Paley-block composite inherits the same obstruction: the eight
parameter sets containing a block of size 261 were confirmed, but none of their
other three block sizes is `0` or `1` modulo 29 or 87, so the free blocks cannot
be made invariant under the subgroups that fix the quadratic-residue difference
set.

## The spin shard: the same 261 equations become 87

Let `mu in Z_523^*` have order three — the smallest is 60 — and impose
`X_2 = mu X_1`, `X_3 = mu^2 X_1` with `X_0` invariant under `<mu>`. Then
`PAF_2(s) = PAF_1(mu^{-1} s)`, so the residual

    R(s) = PAF_0(s) + PAF_1(s) + PAF_1(mu s) + PAF_1(mu^2 s)

is constant on the orbits of `<mu, -1>`. That group acts freely on `Z_523^*`, so
there are exactly `522/6 = 87` orbits, all of size six, and the whole system is
87 equations. Note that `X_1` needs no symmetry for this: every autocorrelation
is already `+-`-symmetric, so the `<mu>`-invariance of `X_0` alone suffices.
Only the parameter sets with three equal blocks admit the shard, which is again
exactly the two Djokovic special sets.

Adding symmetry — `X_1 = -X_1` and `X_0` invariant under `<mu, -1>` — halves the
free bits without changing the equation count. Only `(240; 257,257,257)` admits
it, since `244` is neither `0` nor `1` modulo six. Measured below, that extra
restriction hurts the search substantially rather than helping it.

Both restrictions were verified numerically before any Rust was written: on
random `<mu>`-invariant `X_0` and random `X_1`, `R` is constant on all 87 orbits,
`R(0) = 4v`, and the total over all shifts equals `sum_i (v - 2 k_i)^2`.

## What was built

Tier-1 kernel `ergodis-private/src/plain_prime_sds.rs`:

- admissible parameter sets for any prime carrier from the row-sum identity;
- the multiplier-invariance census above;
- the compiled spin shard — orbit tables for `<mu>` and `<mu, -1>`, the group
  tables the search swaps over, and the class table the residual is read
  through;
- an allocation-free swap search that maintains only the autocorrelation entries
  the residual actually reads, under threshold acceptance with an exact undo;
  and
- `verify_plain_sds`, an independent full replay that rebuilds all four blocks
  from the two free ones and checks every one of the `v - 1` equations plus all
  four block sizes, sharing no code with the incremental search.

Tier-2 driver `tasks/hadamard-2092/src/plain/`, as subcommands
`hadamard plain census` and `hadamard plain spin-search`. Independent Python
oracle `ergodis-private/python/plain_prime_sds_oracle.py`, written from the
identities rather than from the Rust, agrees with the census at 523 and verifies
a Rust-produced hit.

Replay:

    cargo build --release -p hadamard-2092
    hadamard plain census --carrier 523
    hadamard plain spin-search --free-weight 240 --zero-in-repeated \
        --workers 8 --steps 500000 --restarts 4 --tolerance 24 --seed 17
    python3 python/plain_prime_sds_oracle.py census 523

## The kernel finds real solutions, so the pipeline is validated end to end

At the small carriers the search closes the shard outright and the independent
replay certifies the hit. `v = 43`, parameter set `(15; 21,21,21)`,
`lambda = 35`, plain mode: a hit in well under a second, and the Python oracle
independently confirms that all 42 supplementary-difference-set equations hold.
That is a Hadamard matrix of order 172 constructed from scratch by this kernel.
The same happens at `v = 31` (order 124) and `v = 37` (order 148), in several
mode and zero-membership combinations.

This matters because it separates two failure modes that a miss alone cannot:
the machinery is right, so a miss at 523 is a statement about budget or about
the shard, not about the code.

## Difficulty ladder

Fixed budget of eight workers, 500,000 mutations, four restarts, best over both
spin-shaped parameter sets and all four mode and zero-membership combinations:

| carrier `v` | classes | best residual score |
|-------------|---------|---------------------|
| 127         | 21      | 8                   |
| 163         | 27      | 16                  |
| 199         | 33      | 30                  |
| 241         | 40      | 46                  |
| 307         | 51      | 74                  |
| 367         | 61      | 120                 |
| 421         | 70      | 162                 |
| 463         | 77      | 194                 |
| 523         | 87      | 236                 |

The score is `sum over the 87 classes of (sum_i C_i(s) - lambda)^2`, so zero is a
solution. The best configuration at 523 is the free block of size 240 with zero
in the repeated block, in plain (non-symmetric) mode; the symmetric shard is
markedly worse at the same budget, reaching only 1,180.

## Where the search actually reaches, and what more compute buys

Two measurements settle whether the 236 at 523 is a budget problem.

**Reach.** Same fixed budget as the ladder (eight workers, one million
mutations, four restarts), best over both spin-shaped parameter sets and all
four mode and zero-membership combinations:

| carrier `v` | best residual score |
|-------------|---------------------|
| 61          | 0                   |
| 67          | 0                   |
| 73          | 0                   |
| 79          | 2                   |
| 97          | 4                   |
| 103         | 4                   |
| 109         | 4                   |
| 127         | 8                   |

The search closes the shard outright up to `v = 73` and never again above it.
Each of those zeros is a Hadamard matrix built from scratch — orders 244, 268
and 292 — with the independent full replay certifying every equation. The
banked `hit-v73.json` is one of them, re-verified by the Python oracle.

**Budget.** Raising the budget about 180-fold, to twelve workers, twenty
million mutations and twelve restarts:

| carrier `v` | best at low budget | best at 180x budget |
|-------------|--------------------|---------------------|
| 127         | 8                  | 6                   |
| 163         | 16                 | 16                  |
| 199         | 30                 | 24                  |

Two orders of magnitude of extra compute move the residual by 25 percent, zero
percent and 20 percent. This is the same plateau shape the bordered `q29`
campaign measured, reached here in minutes rather than hours. **Compute is not
the lever for this shard**, and the gap from `v = 73` to `v = 523` is not one
that more of the same search closes.

## Hot-loop measurement

The first implementation repaired the full autocorrelation array on every
position flip. The residual only ever reads the free block's autocorrelation at
87 shifts and the repeated block's at 261, so the update loop was restricted to
exactly those. Interleaved A/B against the retained baseline
`hadamard-48b44ba` (SHA-256 `78480377...`), eight workers, 500,000 mutations,
two restarts, seed 11, on the 523 configuration above:

| binary   | wall time (five rounds)     | best score |
|----------|-----------------------------|------------|
| baseline | 4.8, 4.7, 4.7, 4.7, 4.8 s   | 284        |
| current  | 1.7, 1.8, 1.8, 1.7, 1.7 s   | 284        |

Exact score parity in all ten runs. Single-thread hardware counters on the same
configuration: instructions `93.16` to `34.22` billion, cycles `16.54` to `6.01`
billion, branches `13.81` to `5.47` billion, branch misses `10.29` to `8.47`
million, cache misses essentially unchanged. That is a wall-time ratio of 2.69x
explained entirely by removed work, not by a measurement artifact.

A second change stores each sequence twice end to end and keeps the compact
autocorrelation in read-shift order, so a flip needs no wrap test and walks its
autocorrelation slice sequentially. Five more interleaved rounds against the
build of commit `503369c` (SHA-256 `e74ce994...`) give 1.9, 1.9, 1.9, 1.9, 1.8
seconds against 1.4 in every round, again at identical scores, with instructions
`34.22` to `25.83` billion and cycles `5.99` to `4.38` billion. Branch counts are
unchanged, so the earlier wrap tests had already been compiled to conditional
moves and the win is the removed arithmetic and the sequential autocorrelation
access. Cumulatively the step loop is 3.36x faster than the first
implementation at exactly equal results.

The step loop has a zero-allocation regression that enters the real loop across
several reseeds (`tests/plain_prime_sds_allocations.rs`), and the workspace
clippy gate passes.

## Verdict on move B

The move as ranked is closed. Its cheap tier — cyclotomic sweeps at index 6, 9,
18 and 29 — is empty by an exact congruence, and the tiers that survive have at
best `2^58` blocks each, so no exhaustive cyclotomic sweep exists at 523. The
spin shard is the genuinely new and well-conditioned object the move points at,
it is now implemented, validated against real solutions, and measured, and its
search reach ends near `v = 73` with a plateau that compute does not move.

Nothing here excludes a plain solution at 523: every miss is a heuristic miss
with no negative authority, and the two Djokovic special parameter sets remain
untouched as mathematics. What is settled is that this route does not reach 2092
by search alone, so the next attempt on it needs a further exact structure that
shrinks the shard, not a larger campaign.

## Provenance

The parameter enumeration and the multiplier-invariance census are exact and
their exclusions are theorems. The spin reduction is a proved structural
identity, checked numerically before implementation. The search is heuristic:
only the full replay of every supplementary-difference-set equation certifies a
positive, and a miss proves nothing about the shard.

## Mystery ledger

- The residual scores in the ladder grow smoothly with the carrier and show no
  quantization of the kind the bordered q29 layer has. Whether the plain
  residual admits any congruence at all is unexamined; the `sum_c r(c) = 0`
  identity is the only one currently known, and it follows from the parameter
  admissibility.
- The symmetric spin shard is far harder for the search than the plain one at
  equal budget, even though it has fewer free bits and the same equations. Open
  whether that shard is simply empty at `(240; 257,257,257)` or whether the
  symmetric move set is badly conditioned.
- The reach boundary between `v = 73` and `v = 79` is sharp, and the residual
  above it sits at small even values — 2, 4, 4, 4, 8 — rather than drifting.
  Whether those are floors of the move geometry or of the shards themselves is
  unexamined, and the `sum_c r(c) = 0` identity is the only congruence currently
  known on the plain residual.
