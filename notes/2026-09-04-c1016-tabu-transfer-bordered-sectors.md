# C1016 — transferring the tabu delta algebra to the bordered sectors

**Lane**: `complete-ports` · **Task**: C1016 · 2026-09-04.

The predecessor (`2026-09-04-c1016-full-neighbourhood-tabu-spin-shard.md`) built
a full-neighbourhood tabu step with exact incremental per-swap deltas for the
plain spin shard on `Z/523`, and named its own successor: the same delta algebra
applied to the bordered sectors, whose stochastic campaigns are the ones
actually holding up the order-2092 programme. This is that transfer, to both of
them, and it splits sharply.

On the bordered order-six `q29` margin shell it does not merely improve the
residual: it closes the shell. The stopped 288-billion-mutation campaign held a
floor of 96 for four hours and never went below it; at equal wall clock the tabu
step reaches 32 — the smallest nonzero value the arithmetic permits — in every
round, and with a longer epoch it reaches 0, an exact `q29` shell hit, twelve
times over about two and a half hours of worker time. The open question that campaign left,
whether the floor of 96 is an obstruction or a trap, is answered: it was a trap
in the move geometry.

On the `g=41` fine-orbit `q29` sector the same algebra is a wash. At matched
wall clock both engines reach the same residual of 8 and neither goes below it,
even though the tabu step scores about two orders of magnitude more exchanges
exactly. Whatever holds that sector at 8 is not neighbourhood coverage.

## The two deltas

Both sectors are instances of one statement: the objective is a function of
block autocorrelations read at compiled shifts, and a move replaces a block `y`
by `y + u` for a sparse `u`, so

    Delta A(s) = <cross of u against the current y at s>
               + <static self-correlation of u at s>.

Nothing else about either sector enters.

### The bordered `q29` margin shell

The state is four integer rows of length twenty-nine; the move is a within-row
transposition of the positions `p` and `q`, which preserves the row inventory,
the row sum and the zero shift. Writing `d = y_q - y_p`, `u = d(e_p - e_q)`, and
`W_x(s) = y_{x+s} + y_{x-s}` for the toggle effect of a position,

    Delta A(s) = d (W_p(s) - W_q(s)) - d^2 [s = c],

with `c` the shift class of `p - q`. At `s = 0` this is
`2d(y_p - y_q) + 2d^2 = 0`, which is exactly the zero-shell invariance of the
move, so the whole objective lives on the fourteen off-zero classes. With
`r_s = A(s) + 72` and `h = W_p - W_q` the score changes by

    Delta = 2 d <r, h> - 2 d^2 r_c + d^2 |h|^2 - 2 d^3 h_c + d^4.

Maintaining `rho_x = <r, W_x>`, the norms `N_x = |W_x|^2` and the Gram matrix
`G_{xy} = <W_x, W_y>` makes every term a scalar lookup, since
`<r,h> = rho_p - rho_q` and `|h|^2 = N_p - 2 G_{pq} + N_q`. One candidate is
therefore `O(1)`. That is the Gram-matrix maintenance the plain shard's report
left as its named cheap upgrade; here the row length of twenty-nine makes it
cheap outright, and the whole `4 * 406` neighbourhood is scored exactly on every
step. `W` itself is maintained incrementally: changing `y_z` by `delta` changes
`W_x(s)` by `delta` for exactly `x = z - s` and `x = z + s`.

### The `g=41` fine-orbit sector

Beneath an exact joint quotient witness the state is a selection of fine
multiplier orbits per block and slot, and the move exchanges one selected orbit
for one unselected one inside a slot, preserving the witness's digit counts.
Each orbit contributes its residue histogram `h_g` to its block's coefficient
vector, so removing `A` and adding `B` gives

    Delta A(t) = E_B(t) - E_A(t) - K_{A,B}(t),

with the toggle effect `E_g = T_g - S_g` for a selected orbit and
`E_g = T_g + S_g` for an unselected one, where
`T_g(t) = sum_k h_g(k)(y_{k-t} + y_{k+t})`, `S_g` is the orbit's static
self-correlation, and `K_{A,B} = X_{A,B} + X_{B,A}`. This is the plain shard's
formula verbatim with a `0/1` indicator replaced by an integer histogram.

The objective here is not a squared error but the exact defect residual
`sum_c 4 |D_c - 523|` over the seven multiplier cosets, with
`D_c = A(0) - A(s_c)`. Folding the two shifts of a coset into one coordinate
gives `Delta D_c = Ehat_B(c) - Ehat_A(c) - Khat_{A,B}(c)` where
`Ehat_g(c) = E_g(0) - E_g(s_c)`, so a candidate costs seven differences and
seven absolute values. Both orbits are fixed point sets, so `Khat` is entirely
static: it is compiled once per slot and read, never counted, in the loop.

## Correctness gates

For the margin shell:

- every predicted candidate delta is checked, over the whole neighbourhood after
  the search has already moved, against both the `O(shifts)` toggle-effect form
  and a from-scratch score rebuild that shares nothing with the engine
  (`every_predicted_swap_delta_is_the_exact_score_change`);
- the incremental score, the residual and the zero shift are checked against
  that rebuild after every one of two thousand steps
  (`the_tabu_score_agrees_with_a_direct_rebuild_on_every_step`);
- the maintained toggle effects, norms, Gram matrix and `rho` are checked
  against a full recompilation
  (`the_maintained_aggregates_agree_with_a_full_rebuild`);
- the step loop, its reseeds and its kicks allocate nothing
  (`tests/order6_margin_tabu_allocations.rs`); and
- the driver rebuilds every state it reports or banks from that state's own
  rows and refuses to print a disagreement, so nothing downstream rests on the
  incremental score.

For the fine-orbit sector:

- every predicted exchange delta is checked over the whole neighbourhood against
  a direct recompilation of the block's coefficients and defects
  (`every_predicted_exchange_delta_is_the_exact_residual_change`);
- the maintained coefficients, defects and residual are checked against a
  rebuild on every step, together with the admissibility of the selection
  (`the_tabu_residual_agrees_with_a_direct_rebuild_on_every_step`);
- the static cross table is checked against a direct weighted pair count over
  every ordered orbit pair of every slot
  (`the_static_cross_table_matches_a_direct_pair_count`); and
- a zero residual is replayed against every original carrier-522 equation
  before it is reported as a hit.

The workspace clippy gate and the serial library suite pass.

## The margin shell: what the transfer buys

Both engines take a wall-clock budget checked at the cold epoch boundary, and
both draw their starting states from the same stratified outer-profile sampler,
so an equal-budget comparison is a comparison of search quality alone. With no
budget set the walk campaign reproduces its recorded control exactly, seed for
seed.

Five interleaved rounds, thirty seconds and twelve workers each
(`ergodis-private/evidence/q29-margin-tabu-ab.tsv`):

| round | walk best | tabu best |
|-------|-----------|-----------|
| 1     | 160       | 32        |
| 2     | 192       | 32        |
| 3     | 192       | 32        |
| 4     | 192       | 32        |
| 5     | 160       | 32        |

The comparison to make is not with the walk in thirty seconds but with the
campaign: sixteen chunks, eighteen workers, 288,000,000,000 mutations and four
hours produced a best of 96 and nothing below it, and the residual-floor
analysis showed that 96 means `sum e^2 = 6` while the linear constraints admit
`sum e^2 = 2` and `4`. Both of those are now reached in seconds, and they are
reached by every worker: across 168 independent worker runs — seventy-two of
forty-five seconds and ninety-six of sixty — 154 end at 32, two at 64 and twelve
at 0. Since `sum e = 0` forces `sum e^2` to be even, 32 is the smallest nonzero
score the identity permits — the whole distribution has collapsed onto the last
rung above the shell.

## The exact `q29` shell hits

With a longer epoch — fifty thousand steps per outer profile instead of four
thousand — the step closes the shell outright, and does so repeatedly. Twelve
hits are banked (`ergodis-private/evidence/q29-margin-tabu-shell-hits.json`):
twelve distinct states with twelve distinct row-energy profiles, so this is a
margin corpus rather than one state found over and over. Each has combined
periodic autocorrelation exactly `2020` at shift zero and exactly `-72` at each
of the twenty-eight off-zero shifts, row sums `(2, 0, 0, 0)`, and every
coefficient even and at most eighteen in absolute value, which is exactly the
image of a column of eighteen plus-or-minus-one entries. An independent Python
oracle that shares no code with the engine
(`ergodis-private/scripts/q29_shell_replay.py`) replays all 168 banked states
and agrees on every one.

This is the phase-one gate the campaign was built to pass. It is a quotient
condition, not an order-2092 solution: the `q58`, `q87` and `q174` energy
conditions and finally the full carrier-522 equations all remain, and the
existing phase-two search is what consumes such a hit. What has changed is the
supply: phase two has been running from the random lift of whatever phase one
happened to reach, and it can now start from an exact shell.

## The fine-orbit sector: a clean negative

Measurement here has one trap worth recording. The joint quotient witness census
costs 36.5 seconds before either engine starts a single move, so a comparison at
a nominal budget of forty seconds is comparing four seconds of search with four
seconds of search and calling it forty. Both rows below are sized so the search
itself dominates.

Two interleaved rounds, twelve workers, two restarts per witness over all 768
witnesses (`ergodis-private/evidence/g41-q29-orbit-tabu-ab.tsv`):

| round | engine | budget per restart | exchanges scored | best residual | seconds |
|-------|--------|--------------------|------------------|---------------|---------|
| 1     | walk   | 2,500,000 mutations| 3,840,000,000    | 8             | 156.3   |
| 1     | tabu   | 75,000 steps       | 96,496,800,000   | 8             | 156.2   |
| 2     | tabu   | 75,000 steps       | 96,496,800,000   | 8             | 157.2   |
| 2     | walk   | 2,500,000 mutations| 3,840,000,000    | 8             | 161.3   |

The two engines land on the same residual at the same wall clock. That value is
also exactly the one the banked fine order-29 evolution reached after 491.52
million mutations, so neither engine improves on what this sector already had.
The tabu step scores 25.1 times as many exchanges exactly as the walk performs
mutations, and gets nothing for it: best-improvement over the exchange
neighbourhood is not what this sector is short of. Its rows repeat exactly
because the kernel seeds each witness from its root ordinal, so the step is
deterministic per root; the walk's two rows agree for the same reason.

## Provenance

The delta algebra and its gates are exact. Both searches are heuristic: only the
direct replay of the defining equations certifies a positive, and every miss —
including every cell of the fine-orbit table — is a heuristic miss with no
negative authority over its sector.

## Mystery ledger

- **The margin floor of 96 was a trap, and the campaign's own evidence pointed
  the other way.** The campaign report argued from a smooth tail — 52, 29, 10
  runs at 160, 128, 96 — that observing nothing at 64 among 144 runs had
  probability near two percent under a smooth continuation, and read that as
  evidence for a genuine floor of the move geometry. That reading was right
  about the cause and wrong about the consequence: the floor was real *for that
  move geometry*, and changing only the step, not the state, the objective or
  the budget, removed it entirely. The lesson to carry forward is that a sharp
  left edge in a walk's outcome distribution is evidence about the walk.
- **32 is now the plateau, and it is the same shape of plateau.** Seventy of
  seventy-two worker runs end at exactly 32, the smallest nonzero score the
  autocorrelation sum law permits, exactly as the plain shard's step lands on 2
  at its own smallest permitted value. In both sectors the full-neighbourhood
  step walks straight to the last rung and then needs luck for the last one.
  Whether anything beyond the sum law constrains that rung is still unexamined
  in both sectors.
- **The multiplier teleport cannot help this step, and that is provable rather
  than measured.** Relabelling every column by `j -> cj` maps the transposition
  `(p, q)` to `(cp, cq)` and the residual by `r(s) -> r(cs)`, so the multiset of
  candidate deltas over the whole neighbourhood is invariant. A best-improvement
  step is therefore equivariant under the action and the teleport moves it only
  through tie-breaks. It was a genuine re-randomization for the walk; for this
  step it is not a basin escape at all, and the campaign flag remains off.
- **The two bordered sectors respond oppositely, and the objectives differ in
  kind.** The margin shell's objective is a squared error, where a
  best-improvement step over an exactly-scored neighbourhood is following a
  smooth quadratic; the fine-orbit sector's is an `L1` distance to seven
  separate targets, which is piecewise linear with a kink at each of them. That
  is the most visible structural difference between the sector where the
  transfer closed the problem and the sector where it changed nothing, and it is
  a hypothesis, not a measurement.
- **A third more budget bought eight times the hit rate, and that is not
  explained.** Six coordinator seeds at forty-five seconds gave one shell hit in
  seventy-two worker runs; eight seeds at sixty seconds gave eleven in
  ninety-six. Raising the budget by a factor of one and a third raised the
  per-run hit rate from 1.4% to 11.5%. An epoch is fifty thousand steps, so a
  run completes only a handful of them and the marginal epoch is a large share
  of the run, which would explain some of it; a heavy-tailed time-to-hit inside
  an epoch would explain the rest. Neither has been measured, and the practical
  consequence — that this configuration is on a steep part of its budget curve —
  matters for sizing the corpus run that phase two will want.
- **The exact bounded census the campaign proposed is now three rungs closer.**
  That report proposed an exact bounded-neighbourhood census around the banked
  residual-96 states, in the way an older residual-576 state was proved empty in
  its complete three-transfer neighbourhood. Those states were `sum e^2 = 6`.
  The corpus now holds 154 states at `sum e^2 = 2`, one rung from the shell, and
  twelve states on it. A census around a residual-32 state is a far smaller
  exact object than the one that was proposed, and it is the natural way to turn
  "the shell is reachable" into a statement about how it is reached.
- **Nothing was spent on the fine-orbit step's cost, and it has an obvious
  factor in it.** Its toggle-effect recompilation walks all twenty-nine residues
  per orbit per coset, while an orbit has at most twelve support points; a
  compiled support list with the residue and coset loops exchanged is a factor
  of two to three. It was not done because the A/B says the step's search
  quality, not its speed, is what fails to pay in that sector.

## Replay

Everything lives in the private campaign branch `c1016-full-2092-campaign` of
`ergodis-private`, checked out at
`~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`.

    cargo test --release -p ergodis-private --lib order6_margin_tabu
    cargo test --release -p ergodis-private --lib g41_q29_orbit_tabu
    cargo test --release -p ergodis-private --test order6_margin_tabu_allocations

    hadamard order6 margin-tabu --workers 12 --seconds 45 --epoch-steps 50000 \
        --stall 4000 --stratum --seed 777 --output evidence/q29-margin-tabu-corpus.jsonl
    hadamard order6 margin-evolve 12 1000000000 outer-epochs 1000000 1 \
        --seconds 30 --seed 777 --stratum
    hadamard g41 q29 tabu --threads 12 --restarts 2 --steps 75000
    hadamard g41 q29 evolve --threads 12 --restarts 2 --mutations 2500000

    bash scripts/q29_margin_ab.sh evidence/q29-margin-tabu-ab.tsv 30 12 5 --stratum
    python3 scripts/q29_shell_replay.py evidence/q29-margin-tabu-corpus.jsonl

Evidence hashes are recorded in that repository's `evidence/SHA256SUMS`.

## Next

The exact `q29` shell is no longer the bottleneck, so the successor is to
consume it: drive the existing `q58`/`q87`/`q174` phase-two search from the
banked corpus of twelve exact shell states rather than from the random lift of
whatever phase one reached, measure whether phase two is itself
neighbourhood-limited, and transfer the same delta algebra to the `q58` and
`q87` views if it is. The lift from a `q29` state to the 696-cell `q174` state
is a large neutral fibre, and choosing it well is now the open question rather
than reaching the shell at all.

The fine-orbit `g=41` sector needs a different lever than a stronger local step;
this measurement says explicitly that neighbourhood coverage is not what it is
short of.
