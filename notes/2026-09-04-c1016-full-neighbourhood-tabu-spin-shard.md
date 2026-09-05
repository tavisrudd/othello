# C1016 — a full-neighbourhood tabu step for the plain spin shard

**Lane**: `complete-ports` · **Task**: C1016 · 2026-09-04.

The predecessor (`2026-09-04-c1016-plain-523-cyclotomy-and-spin-shard.md`) ended
with a measured claim and a named successor: the order-three spin shard on
`Z/523` is heuristically dense with solutions, the random threshold-accepting
walk stalls at carrier 73 and is immune to two orders of magnitude of extra
compute, and the standard instrument for that situation is a full-neighbourhood
tabu step with incremental per-swap deltas. This is that step, its exactness
gates, its cost, and what it buys.

It buys a uniform win: at equal wall clock the tabu step is at or below the
walk's residual on every rung of the carrier ladder, it closes carrier 97 —
which the walk never closes — and it reaches 188 at carrier 523 against the
walk's 236. Nothing here excludes or establishes a plain solution at 523.

## The exact per-swap delta

Write `x` for the indicator of the block one side selects and
`C(s) = sum_j x_j x_{j+s}`. Removing a chosen group `A` and adding an unchosen
group `B` replaces `x` by `x - 1_A + 1_B`, so for every shift

    Delta C(s) = W_B(s) + S_B(s) - (W_A(s) - S_A(s)) - X_{A,B}(s) - X_{B,A}(s),

where `W_G(s) = sum_{j in G} (x_{j-s} + x_{j+s})` is read against the *current*
block, `S_G(s) = #{(j, j') in G^2 : j' - j = s}` is the static self-correlation
of the group, and `X_{U,V}(s) = #{(u, v) in U x V : v - u = s}`.

Summing over the shifts one residual class reads gives, per class `c`,

    d_c = E_B(c) - E_A(c) - K_{A,B}(c),

with the *toggle effect* `E_g = W_g - S_g` for a chosen group and
`E_g = W_g + S_g` for an unchosen one, and with `K_{A,B}(c)` counting the member
pairs of `A x B` whose difference lands in class `c`. Since the score is
`sum_c r_c^2`, the exact score change of a candidate swap is

    Delta = |u_A|^2 - |r|^2 + |E_B|^2 + 2 <u_A, E_B>
            + |K|^2 - 2 <u_A + E_B, K>,     u_A = r - E_A.

One candidate therefore costs one inner product of length `(v-1)/6` plus a
handful of sparse corrections — no autocorrelation array is rebuilt, and no
candidate is ever applied to find out what it does. The toggle effects
themselves are maintained incrementally: `W_g(c)` changes only for the groups
holding `p + s` or `p - s` for a moved position `p` and a read shift `s`, which
is `O(classes * arity)` work per moved position and independent of the block
size. Both `S_G` and the class of every difference are compiled once.

At carrier 523 in the configuration the predecessor selected — free block 240,
zero in the repeated block, plain mode — the neighbourhood is 7,520 free-side
swaps and 68,096 repeated-side swaps, so every step scores 75,616 candidate
swaps exactly and takes the best admissible one.

## Search control

The step is best-improvement over that whole neighbourhood with a classical
tabu list: the two groups a swap moves are frozen for a jittered tenure, and a
frozen candidate is admitted only when it would beat the best score ever seen.
Stagnation is handled by an optional kick — random swaps plus a tabu release —
and by restarts. Both blocks are scanned in the same step and the better side
is taken, so the free and the repeated block compete rather than alternate.

Driver: `hadamard plain spin-tabu`, beside the existing
`hadamard plain spin-search`. Both drivers now also take `--seconds`, a
wall-clock budget checked at their existing bounded safe point, which is what
makes an equal-budget comparison between the two engines possible at all. The
walk's search results are unchanged by that addition (identical best score from
the retained pre-change executable at the same seed and step budget).

## Correctness gates

- Every predicted candidate delta is checked against the exact score change it
  produces, on both sides, at carriers 43 and 523, against a rebuild from the
  four blocks by direct correlation counting that shares nothing with either
  search (`every_predicted_swap_delta_is_the_exact_score_change`).
- The incrementally maintained score is checked against that same independent
  rebuild after every step
  (`the_tabu_score_agrees_with_a_direct_rebuild_on_every_step`).
- A hit at carrier 43 is certified by `verify_plain_sds`, the full replay of all
  `v - 1` supplementary-difference-set equations
  (`the_tabu_step_closes_a_small_shard_and_the_replay_certifies_it`).
- The step loop, its reseeds, and its kicks allocate nothing
  (`tests/plain_prime_sds_allocations.rs`).
- The workspace clippy gate passes and the serial library suite passes.

## What it buys: the carrier ladder at equal wall clock

Both engines, 8 workers, one wall-clock budget each, best over every
spin-shaped admissible parameter set and every legal zero-membership
combination of the carrier, three rounds at 10 s for carriers 61--97 and two
rounds at 8 s for 103--523, engines alternating within each round. Raw rows are
in `ergodis-private/evidence/plain-spin-tabu-ladder.tsv`, produced by
`ergodis-private/scripts/plain_spin_ab_ladder.sh`.

| carrier | equations | walk best | tabu best |
|---------|-----------|-----------|-----------|
| 61      | 10        | 0 — hit   | 0 — hit   |
| 73      | 12        | 0 — hit   | 0 — hit   |
| 79      | 13        | 0 — hit   | 0 — hit   |
| 97      | 16        | 2         | 0 — hit   |
| 103     | 17        | 4         | 2         |
| 109     | 18        | 4         | 2         |
| 127     | 21        | 4         | 2         |
| 163     | 27        | 10        | 8         |
| 199     | 33        | 22        | 16        |
| 241     | 40        | 40        | 26        |
| 307     | 51        | 62        | 52        |
| 421     | 70        | 144       | 122       |
| 523     | 87        | 236       | 188       |

The tabu step is at or below the walk on every rung and strictly below on ten
of thirteen. The reach boundary moves: the walk closes 61, 73 and 79 and never
97, while the tabu step closes 97 in three of its six runs there — a Hadamard
matrix of order 388 built from scratch by this kernel and certified by the
independent full replay of all 96 supplementary-difference-set equations. One
such hit is banked with its two free blocks as
`ergodis-private/evidence/plain-spin-tabu-hit-v97.json` (SHA-256
`73ebdb79...`), parameter set `(39; 47, 47, 47)` with `lambda = 83`, found in
2.8 seconds on 8 workers. The
predecessor's boundary was 73 against 79 at its own budget; this comparison
gives the walk a larger budget than that, and it still stops one rung below the
tabu step.

At 523 the walk reproduces the predecessor's 236 exactly, and the tabu step
reaches 188 in eight seconds — better than the walk reached with a 180-fold
budget increase in the predecessor's calibration.

A longer interleaved control at 523 says the same thing with more compute per
run: two rounds of 120 seconds on 12 workers each, alternating engines, give
the tabu step 196 and 184 against the walk's 208 and 232
(`ergodis-private/evidence/plain-spin-523-long-ab.tsv`). The tabu step runs
9,400--9,700 full-neighbourhood steps per second there, so each of those runs
scores about 85 billion candidate swaps exactly.

## Cost

Single-thread, carrier 523 in the configuration above, 400 steps, seed 21,
portable release build, interleaved rounds against retained executables.

| build | instructions | cycles | branches | wall |
|-------|--------------|--------|----------|------|
| `hadamard-2a2658c`, first working step | 16.239 G | 3.006 G | 1.520 G | 0.662 s |
| `hadamard-eacd442`, dense tables and specialized cross term | 10.527 G | 1.812 G | 1.069 G | 0.386 s |
| `hadamard-e8b9113`, eight-lane inner product | 9.749 G | 1.641 G | 1.069 G | 0.345 s |

Branch misses stay at about 2.9--3.0 million and cache misses at 30--42
thousand throughout, so neither is the lever; the whole gain is removed work.
Cumulatively that is 1.67x fewer instructions and 1.83x fewer cycles, with
exact score parity in every interleaved 8-worker control (best 226 in all six
runs at seed 33, 9,600 steps), and throughput rising from 3,482 to 6,549 steps
per second on 8 workers. Retained executables and their SHA-256 hashes:
`hadamard-2a2658c` `2f313358...`, `hadamard-eacd442` `299dc4d4...`,
`hadamard-e8b9113` `bc63406e...`.

Per candidate at 523 that is 322 instructions and 54 cycles for one exact
score change over 87 equations.

### Accepted and rejected variants

- **Accepted.** Dense per-side member tables with one stride, replacing the
  compressed sparse row lookup inside the candidate loop; the group size is a
  run constant, so the singleton case — which is the whole repeated side in
  plain mode, and 90% of the neighbourhood — is a separate monomorphization
  with one class lookup and no counting.
- **Accepted, and the surprising one.** The fastest inner product emits no
  vector instruction at all. Eight independent scalar accumulator lanes beat
  the autovectorized loop by 1.10x in cycles, because widening `i16` to `i32`
  on this baseline target consumes a whole vector load per four elements
  through `punpcklwd`, while the blocked scalar form issues eight independent
  multiply-adds per iteration. The autovectorized form is retained in the
  source comment as the negative control.
- **Rejected.** `-C target-cpu=native` on the whole workspace. Measured on the
  same workload it removes 27% of instructions but only 7% of cycles and 12% of
  wall time, which does not justify a workspace-wide build-flag change for one
  kernel; the AVX-512 path the compiler then picks is not where the remaining
  time is.

## Replay

Everything lives in the private campaign branch `c1016-full-2092-campaign` of
`ergodis-private`, checked out at
`~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`. Commits: `2a2658c`
the step and its gates, `eacd442` the dense tables, the specialized cross term
and the wall-clock budget, `e8b9113` the inner product, `70dbfeb` the evidence
and its harness.

    cargo build --release -p hadamard-2092
    cargo test --release -p ergodis-private --lib plain_prime_sds
    cargo test --release -p ergodis-private --test plain_prime_sds_allocations

    hadamard plain spin-tabu --carrier 523 --free-weight 240 --zero-in-repeated \
        --workers 12 --steps 40000 --restarts 0 --seconds 120 \
        --tenure 20 --tenure-jitter 20 --stall 400 --kick 12 --seed 1

    bash scripts/plain_spin_ab_ladder.sh evidence/plain-spin-tabu-ladder.tsv \
        8 8 2 103 109 127 163 199 241 307 421 523

`evidence/plain-spin-tabu-ladder.tsv` is SHA-256
`73a9615237314575280e5f2f1fccba3509f22e80e478a457270ce5f392afd834` and
`evidence/plain-spin-523-long-ab.tsv` is
`1641b18a26058c4bdb9c6a4795dbe6cdc6ed3b1c637153f84c010b76ec0a4407`, both
recorded in that repository's `evidence/SHA256SUMS`. The ladder rows for
carriers 61--97 were produced by the same script at 10 s and three rounds.

## Provenance

The spin reduction, the parameter identities, and the multiplier-invariance
census are exact and unchanged from the predecessor. The tabu step is a
heuristic search: only the full replay of every supplementary-difference-set
equation certifies a positive, and a miss proves nothing about the shard. Every
ladder cell above that is not a hit is a heuristic miss with no negative
authority.

## Mystery ledger

- **The plateau values are small and even, and stay that way.** Above the reach
  boundary the tabu step lands on 2 at carriers 97 through 127 and then grows
  smoothly. Scores 1 and 3 are impossible because `sum_c r_c = 0` — one or
  three classes at `+-1` cannot sum to zero — so 2 is the smallest nonzero
  score the identity permits, and the search is reaching exactly it. Whether
  anything beyond that identity constrains the residual is still unexamined,
  and it is the same open question the predecessor left.
- **A 1.28x residual gain against a `2^-381` density is not the shape of a
  solution.** The predecessor's heuristic puts about `2^306` solutions among the
  `2^687` states at 523, one in `2^381`. Replacing the weakest available search
  with the standard strong one moves the residual from 236 to 184. That is a
  real and uniform gain, and it is nowhere near the gap: the instrument change
  was necessary, but the remaining distance is not a search-quality distance.
- **Compute is now a lever again, but a weak one.** The predecessor established
  that 180x more compute moved the walk's residual by at most a quarter. The
  tabu step gains about 20% of residual over the walk at every large carrier
  and one full rung of reach, but its own residual at 523 still moves slowly
  with budget. The next structural lever is not more of this search either.
- **The inner product is the whole cost, and it is not yet incremental.** Each
  step recomputes `<u_A, E_B>` for every one of the 75,616 candidates, which is
  the only term in the delta that is not maintained. Maintaining the Gram
  matrix of the toggle effects would make a candidate `O(1)` at the price of a
  rank-one update per accepted move; that is the obvious next order-of-magnitude
  and it is not attempted here.
- **Untouched transfer.** The same delta algebra applies verbatim to the
  bordered `q29` and `g41` sectors, whose campaigns also plateaued under random
  search. Nothing in the derivation uses the plain shard's specifics beyond
  "the residual is a sum of block autocorrelations read at compiled shifts".

## Next

The highest-value successor is the transfer, not more tuning: run the same
full-neighbourhood step against the bordered sectors whose stochastic campaigns
are the ones actually holding up the order-2092 program. The cheapest local
upgrade is the Gram-matrix maintenance above.
