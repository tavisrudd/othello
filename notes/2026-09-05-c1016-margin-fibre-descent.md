# C1016 — the margin-fibre descent, and what holding 45 characters exact costs

**Lane**: `ergodis` · **Task**: C1016 · 2026-09-05.

The predecessor (`2026-09-05-c1016-exact-q18-and-the-margin-lift.md`) solved the
seventeen low-order characters exactly, bridged that solution against a banked
exact `q29` shell through the proved Gale--Ryser margin construction, and left
one question: can a descent restricted to the margin fibre — where all 45 of
those characters stay exact — reach the depth the unrestricted search reaches at
equal wall clock? This pass builds that descent and measures it.

The answer is no. But the controls that follow the headline measurement say the
shortfall is not the constraint's doing, and that is the result worth carrying
forward: the same descent is equally shallow inside the margin fibre of a state
the unrestricted arm reached at 14,800 — a fibre that therefore *contains* a
state at 14,800 by construction — and when seeded on that state directly it
cannot improve it in 558,800 steps. **The 2-by-2 alternating swap is an
inadequate descent operator for this objective, in any fibre.** Whether holding
the 45 low-order characters exact costs depth is left open, because the
instrument built to decide it fails a control where the answer is known.

## The move, and why the whole neighbourhood is affordable

By the Chinese remainder theorem `Z/522 = Z/18 x Z/29`, so one block of the
carrier is an 18-by-29 binary matrix whose row sums are its `q18` coefficients
and whose column sums are its `q29` coefficients. The **2-by-2 alternating
swap** takes two rows and two columns whose four entries alternate in sign and
negates all four. Every row sum and every column sum survives it, so it moves
inside one margin fibre and holds the seventeen characters of order dividing 18
and the twenty-eight of order dividing 29 exact for a whole descent.

The swap is four sign changes `d_k = 2 s_k` with `s = (-1, 1, 1, -1)`. The exact
change of the class-`j` carrier correlation is

    D_j = 2 m_j + Q_j,      m_j = sum_k s_k W_{p_k}(j),

with `W_p(j) = y_{p+j} + y_{p-j}` the toggle effect the carrier state already
maintains, and `Q` the sparse self-interaction — `16` at the zero class and
`4 s_k s_l` at the class of each pair difference, doubled at the self-inverse
shift 261. Summing `2 r_j D_j + D_j^2` over the 262 canonical classes gives

    4 sum_k s_k phi_{p_k} + 4 sum_{k,l} s_k s_l G(p_k, p_l) + (sparse Q terms)

with `phi_p = <r, W_p>` and `G(p, q) = <W_p, W_q>`. Written that way a candidate
still costs a pass over all 262 classes, and the neighbourhood cannot afford it.
It does not have to. **The Gram entry has a closed form**:

    G(p, q) = A(p - q) + C(p + q) + 2 y_p y_q + 2 y_{p+261} y_{q+261},

where `A` is the block's own autocorrelation, already maintained by the carrier
state, and `C(t) = sum_u y_u y_{t-u}` is its conjugate correlation, which is
maintained incrementally at 522 operations per changed position. The derivation
is the involution `s -> -s`: summed over all of `Z/522` the product
`W_p(s) W_q(s)` is `2A(p-q) + 2C(p+q)`, and the canonical half-sum adds back the
two fixed points `s = 0` and `s = 261`.

So one candidate costs four potential lookups, ten Gram reads and at most seven
sparse corrections. A swap is admissible exactly when its four entries
alternate, so bucketing the 29 columns once per block and row pair turns the 812
ordered column pairs into the product of the `(+, -)` and `(-, +)` buckets with
no rejected candidate. The bridged base point admits **35,560** swaps — the same
order as the column arm's entire move set — and the full-neighbourhood swap step
runs at about six tenths of the column step's rate rather than the fiftieth it
would cost without the closed form.

## The measurement

Both arms minimize the same objective, the full carrier correlation against
`(2088, -4)` over the 262 canonical classes, and both are seeded above the same
banked exact `q29` shell, so they differ in exactly the constraint under test.
One process alternates equal wall-clock slices between them, twelve workers, so
no thermal drift can favour an arm. Each restart of the margin arm is a random
point of the fibre, reached by a walk of 200,000 accepted swaps from the bridged
canonical point, because that canonical point is a pathological corner of an
otherwise ordinary set.

Long-descent configuration, one restart per 30-second slice, 84 restarts per
arm, 2,522 against 2,518 aggregate worker-seconds:

| arm                                | best   | median | worst  | steps/s | `q18` deviation |
|------------------------------------|-------:|-------:|-------:|--------:|----------------:|
| margin fibre (both margins exact)  | 21,840 | 22,800 | 23,392 |   393.8 |               0 |
| unrestricted column control        | 14,800 | 15,376 | 15,632 |   669.9 |          19,616 |

The `q18` column is the deviation of the seventeen low-order characters in their
own quotient units, which are not the carrier's; it says only that the margin
arm holds them exactly and the unrestricted arm does not.

The control lands on the campaign's banked plateau — 14,800 against the banked
15,136 — so the instrument is calibrated against the arm this is measured
against. The margin arm's reported states carry both margins unchanged, `q18`
and `q29` deviations exactly zero, checked on every reported state.

**The descent curves settle the attribution.** The best score reached by each
step milestone, over all workers:

| steps   | margin fibre | column control |
|---------|-------------:|---------------:|
| 100     |       23,424 |         17,136 |
| 300     |       22,928 |         15,712 |
| 1,000   |       21,840 |         15,376 |
| 3,000   |       21,840 |         15,216 |
| 10,000  |       21,840 |         14,800 |

The margin arm's best is flat from a thousand steps onward: it is saturated, not
truncated. At equal step count it is already worse than the control by the same
margin as at equal wall clock, so the step-rate difference explains none of the
gap. The gap is the move set and the fibre it moves in, not the clock.

Restart width changes nothing. The same wall clock spent on short restarts —
252 restarts of the margin arm and 366 of the control instead of 84 each — gives
21,712 and 14,496, within a per cent of the long-descent numbers on both sides.

## Two controls, and what they take away from the headline

The headline number has two readings: the exact `q18` fibre is a bad region, or
the swap move set is a bad descent operator. Two controls separate them, and
they both land on the second.

**The move set fails where the answer is known.** Take the control arm's own
best state, at carrier 14,800, and search *its* margin fibre — the same swap
descent, same instrument, restarts drawn as random points of that fibre. It
reaches 22,656 in 5,040 worker-seconds over 168 restarts. That fibre contains a
state at 14,800: the base point it was built from. The descent misses a depth
known to exist inside the very fibre it is searching, by 53 per cent, and its
trace is as flat as it is in the exact `q18` fibre. So the shortfall follows the
move set from fibre to fibre; it is not a property of the exact `q18` one.

**And it cannot improve a deep state either.** Seeded directly on that
14,800 state with no randomizing walk, twelve workers spent 558,800
full-neighbourhood swap steps and the best, median and worst all stayed exactly
14,800, unmoved at every milestone from 100 steps to 30,000. Every one of the
roughly 31,000 admissible swaps at that state, re-scored exactly at every step
along whatever path the tabu search took, failed to improve it.

## Verdict

Answering the card's question as asked: **no**, a descent restricted to the
margin fibre does not reach the unrestricted plateau at equal wall clock —
21,840 against 14,800 in the canonical units the campaign banks, 43,104 against
29,536 in full-group units, with the restricted arm saturated from a thousand
steps.

But the question the answer was meant to settle is not settled. The intended
reading — that pinning the 45 low-order characters costs depth — requires an
instrument that can descend inside a fibre, and this one demonstrably cannot: it
falls 53 per cent short in a fibre whose floor is known to be at least as deep
as 14,800. What the measurement closes is the instrument, not the route.

So the campaign should not conclude that solving the low-order characters first
is the wrong order. The exact `q18` quadruple is still an exact solution of a
hard subproblem, the bridge to a `q29` shell is still unobstructed, and the
fibre is still statistically ordinary at its random point. What is now measured
is that the 2-by-2 alternating swap alone will not descend it. A fibre-restricted
search that could decide the question needs a wider move set — the swap is the
lowest-order element of the fibre's move group, and compositions of two or three
swaps sharing a row or a column are the natural next shell — or a different
mechanism altogether for moving inside a margin fibre.

## Correctness gates

- the exact swap delta is checked against a full rebuild of the carrier
  objective from the signs after the move, over random admissible swaps on
  several states;
- the Gram closed form is checked against the direct inner product of the two
  toggle-effect rows, over random position pairs;
- the conjugate correlation is checked against a full rebuild after every
  applied swap;
- a whole descent is checked to leave every block's row margins and column
  margins unchanged, and the `q29` margin objective is cross-checked against the
  banked phase-one objective, which is the same functional written
  independently;
- the maintained score never drifts from a rebuild of the objective;
- the step loop, its reseeds and its kicks allocate nothing after the workspace
  is built; and
- every reported state is rebuilt from its own signs by the driver, its carrier
  orthogonal identity is checked, and the margin arm's states are checked to
  still carry both margins of the base they were seeded on.

## Provenance

The margin-preservation property of the swap, the exact delta and the Gram
closed form are proved structural and are exactly replayed. The descent itself
is heuristic: it is observed and evolved, its misses carry no pruning authority
over the fibre they missed in, and the depth comparison is a statement about two
instruments at equal wall clock, not about the fibre's optimum.

## Replay

Branch `c1016-full-2092-campaign` of `ergodis-private`, at
`~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`.

    cargo build --release -p hadamard-2092
    cargo test --release --workspace --all-targets -- --test-threads=1

    bash scripts/margin_fibre_ab.sh evidence/margin-fibre 420 12 30000

The script writes the long-descent run, the short-restart run, the control run
inside the unrestricted arm's own best fibre, and the per-worker corpus. The
hold test is the same driver seeded on that best state with no walk:

    hadamard order6 margin-fibre --bridge evidence/q18-q29-bridge.json \
        --q18 evidence/q18-exact-quadruple.json \
        --q29 evidence/q18-bridge-q29-input.json \
        --base-signs evidence/margin-fibre-column-best-signs.json \
        --arm fibre --workers 12 --seconds 120 --slice-millis 120000 \
        --budget 200000 --walk 0 --seed 4242

Evidence hashes are in that repository's `evidence/SHA256SUMS`.

## Mystery ledger

- **Whether a fibre-restricted descent reaches the unrestricted depth.** Still
  open, and now open for a different reason than before: the restriction has not
  been measured, because the only instrument built for it cannot descend a fibre
  whose floor is known. The gate for a successor is the control run in this
  report — a fibre-restricted search is only worth believing once it reaches
  about 14,800 inside the control's own fibre.
- **Why the swap neighbourhood has no improving move at a deep state.** Measured
  over 558,800 exact full-neighbourhood steps and unexplained. A single swap is
  two compensating transfers, so it changes four positions at once and cannot
  express the single transfer the unrestricted arm uses; whether the obstruction
  is that coarseness or something about the deep state's structure is untested.
  This is the cheapest probe available, and it is the one that would say what a
  wider fibre move set has to contain.
- **The unrestricted plateau carries a large `q18` deviation.** Its best state
  scores 19,616 at the `q18` quotient while the fibre arm scores exactly zero
  there, and the unrestricted arm nevertheless wins the combined objective by
  a third. The trade is measured but not explained: nothing says why the
  low-order characters are cheap to abandon.
- **The margin arm's own plateau is remarkably tight.** Best 21,840, median
  22,800, worst 23,392 across twelve workers and 84 restarts, and 21,712 to
  23,184 under a completely different restart schedule. A spread that narrow
  across independent seeds usually means a structural floor rather than a search
  outcome, and nothing here identifies one.
