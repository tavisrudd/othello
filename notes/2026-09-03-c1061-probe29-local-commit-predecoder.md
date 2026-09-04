# C1061 probe 29: change what is committed — a local correction, not a global parity

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 29, continuing `notes/2026-09-03-c1061-probe27-locality-and-surface-code-predecoder.md`.

Contract documents read in full before this probe:
`/home/tavis/src/ergodis/CLAUDE.md`, `/home/tavis/src/ergodis-contrib/PERFORMANCE.md`,
`/home/tavis/src/ergodis-contrib/performance-playbook.md`,
`/home/tavis/src/ergodis-private/CLAUDE.md`.

## Headline

Redefining the committed action as a local correction fixes three real defects of probe 23's
predecoder — the certificate becomes sound at *every* radius, the handoff becomes a genuine residual
decoding problem, and the compiled table's width becomes independent of code distance. It does not
make the compiled certified predecoder reach distance 9 on the rotated surface code, and the reason
is now measured sharply rather than inferred: **the proved tier survives exactly when the ball spans
a full spatial cut of the code and collapses one step inside it.** At distance 9 on the repetition
code only the single centre commit position certifies (95.0% of windows); its two neighbours certify
2.6% and 2.8%. The required radius therefore grows like `d/2`, the ball like the cut it must span,
and the surface code's cut is two-dimensional, which is probe 27's wall in different clothing.

## 1. The certificate for local commits

### The object

A code plus a noise model compiles to a **decoding graph**: unit-weight *mechanisms*, each flipping a
set of detectors. This is exactly the matching graph a sparse blossom decoder consumes. A mechanism
flipping one detector is a boundary edge. Decoding is: given the observed detector set `s`, find a
minimum-size mechanism set whose boundary is `s`. Both families are built this way, so the
certificate is written once. Detector index is `round * checks + check`.

### The commit region and its ball

Fix a commit region `R` — a small set of mechanisms, here one data-error location in the oldest
round — and a radius `r`. Let `B` be the detectors within graph distance `r` of the detectors `R`
touches. Mechanisms split three ways: **interior** (every detector it flips lies in `B`), **crossing**
(it flips at least one detector inside and one outside), and the rest, which never touch `B`. Write
`s_B` for the observed syndrome restricted to `B`.

The outside interacts with the ball only through which crossing mechanisms fire. Let `v` range over
`∂c|_B` for every subset `c` of the crossing mechanisms; because each crossing mechanism contributes a
fixed vector, the set of such `v` is a **linear subspace** of `F_2^B`, which is why the quantifier is
cheap to evaluate — `2^rank` elements, with rank between 2 and 21 in every configuration measured
here. For each `v`,

```text
K(s_B, v) = { E|_R : E interior, ∂E|_B = s_B ^ v, |E| minimal among such }
Safe(s_B) = intersection of K(s_B, v) over every v whose target is explainable
```

### The splicing argument

Let `E*` be any global minimum-weight solution, let `c*` be the crossing mechanisms it uses and
`v* = ∂c*|_B`, and let `I*` be `E*` restricted to the interior mechanisms. Then `∂I*|_B = s_B ^ v*`,
and `I*` is minimal among interior sets with that boundary: if a cheaper `F` existed, then
`E' = (E* \ interior) ∪ F` would have the same boundary everywhere — interior mechanisms flip no
detector outside `B`, so nothing outside changes — and lower weight, contradicting the optimality of
`E*`. So `E*|_R ∈ K(s_B, v*)`.

If `a ∈ Safe(s_B)` then `a ∈ K(s_B, v*)`, so a minimal interior `F` with `F|_R = a` exists. Splice it
in: `E' = (E* \ interior) ∪ F` has the same boundary and the same weight, so it is a global optimum
with `E'|_R = a`. **Committing `a` preserves a global minimum-weight solution.**

Two things this argument does not need, and both matter. It needs no reachability assumption on `v`:
quantifying over the whole subspace is sound because the subspace is a superset of the reachable
crossing patterns. And it says nothing about the logical observable, so there is no exact-tie gap of
the kind probe 23 had to carry. **Soundness holds at every radius**; the radius controls coverage,
not correctness. That is the structural difference from probe 23, where truncating the context was
unsound and the seam had to be quantified in full.

### The handoff contract, stated exactly

After committing `a`, the residual problem is: minimum weight over the mechanisms **outside `R`**
explaining the residual syndrome `s ^ ∂a`. Its optimum has weight `globalmin − |a|`. The witness
`E' \ R` gives `≤`, and a cheaper residual would splice back with `a` to beat `globalmin`, giving `≥`.
So the residual syndrome with `R` retired is exactly a smaller instance of the same problem, and
committing a sequence of regions preserves an optimum by induction. This is a genuine handoff:
unlike a parity commit, nothing has to be carried to the end of the shot and recombined.

### Gates

All seven tests pass, in `src/local_commit_predecoder.rs`.

| Gate | What it establishes |
|---|---|
| `the_repetition_graph_has_the_right_shape` | mechanism counts and the two weight-one boundary edges |
| `the_surface_graph_matches_the_code` | the graph agrees with the compiled rotated-surface-code checks |
| `a_certified_local_commit_preserves_the_minimum_weight_exhaustively` | **exhaustive**: over every repetition-code syndrome of weight at most 4 at `(d,T,r) = (3,3,2), (5,3,2), (5,4,3)`, a proved commit satisfies `globalmin = |a| + residualmin` against a full metric-closure oracle |
| `a_certified_local_commit_is_exact_on_the_surface_code` | the same claim on the rotated surface code at `d = 3`, `T = 3`, `r = 2`, over every syndrome of weight at most 3 |
| `the_compiled_local_policy_reproduces_the_certifier` | the compiled table equals the certifier on **all** `2^12` ball syndromes at `d = 7`, `r = 2` |
| `the_proved_tier_needs_a_spatially_complete_ball` | the measured wall as a regression: the centre position keeps coverage above 0.8 and its neighbour falls below 0.3 |
| `a_larger_radius_only_ever_commits_more` | a radius-2 certificate never contradicts a radius-1 one over 4,000 planted histories |

The exhaustive gates are the load-bearing ones and they check the *handoff identity*, not just a
weight bound, so the residual contract is verified rather than assumed.

## 2. Locality: what actually holds

### The ball width does saturate, and that was the hoped-for result

`ergodis-tools local-commit-bench --mode shape --rounds 6`, commit region one central data mechanism.
`rank` is the dimension of the crossing subspace, so `2^rank` is the number of quantified contexts;
`entries` is the compiled interior metric's size.

| family | `d` | `r` | ball bits | interior | crossing | rank | contexts | metric entries |
|---|---|---|---|---|---|---|---|---|
| repetition | 5 | 1 | 6 | 8 | 6 | 4 | 16 | 128 |
| repetition | 7 | 1 | 6 | 6 | 8 | 4 | 16 | 128 |
| repetition | 9 | 1 | 6 | 6 | 8 | 4 | 16 | 128 |
| repetition | 15 | 1 | 6 | 6 | 8 | 4 | 16 | 128 |
| repetition | 7 | 2 | 12 | 17 | 10 | 6 | 64 | 8,192 |
| repetition | 9 | 2 | 12 | 15 | 12 | 6 | 64 | 8,192 |
| repetition | 15 | 2 | 12 | 15 | 12 | 6 | 64 | 8,192 |
| repetition | 9 | 3 | 20 | 30 | 14 | 8 | 256 | 2,097,152 |
| surface | 5 | 1 | 10 | 18 | 22 | 8 | 256 | 2,048 |
| surface | 7 | 1 | 10 | 12 | 28 | 8 | 256 | 2,048 |
| surface | 9 | 1 | 10 | 12 | 28 | 8 | 256 | 2,048 |
| surface | 5 | 2 | 22 | 49 | 26 | 12 | 4,096 | 8,388,608 |
| surface | 7 | 2 | 28 | 55 | 50 | 18 | 262,144 | 5.4e8 |
| surface | 9 | 2 | 31 | 45 | 69 | 21 | 2.1e6 | 4.3e9 |

**At fixed radius the ball width is independent of distance** once the ball is in the bulk: 6 bits at
repetition `r = 1` for every `d` from 7 to 15, 10 bits at surface `r = 1` for every `d` from 5 to 9.
That is exactly the `d`-independence probe 27 could not get, and it is the direct consequence of
committing a local object.

### And it does not buy what it was supposed to buy

`--mode locality`, 4,000 planted histories at 1% physical error, six rounds, `slack = 1` for the
bounded tier. `proved` is the fraction of windows the proved tier commits.

| family | `d` | `r` | ball | proved | bounded | ambiguous |
|---|---|---|---|---|---|---|
| repetition | 3 | 1 | 4 | **1.0000** | 0.0000 | 0.0000 |
| repetition | 5 | 1 | 6 | **0.9515** | 0.0375 | 0.0110 |
| repetition | 7 | 1 | 6 | **0.0000** | 0.9543 | 0.0457 |
| repetition | 7 | 2 | 12 | **0.9503** | 0.0325 | 0.0173 |
| repetition | 9 | 1 | 6 | **0.0000** | 0.9640 | 0.0360 |
| repetition | 9 | 2 | 12 | **0.0112** | 0.9543 | 0.0345 |
| repetition | 9 | 3 | 20 | **0.9520** | 0.0362 | 0.0118 |
| repetition | 15 | 2 | 12 | **0.0105** | 0.9563 | 0.0333 |
| repetition | 15 | 3 | 20 | **0.0323** | 0.9295 | 0.0382 |
| surface | 3 | 2 | 10 | **0.9970** | 0.0015 | 0.0015 |
| surface | 5 | 1 | 10 | **0.9105** | 0.0765 | 0.0130 |
| surface | 7 | 1 | 10 | **0.0000** | 0.9340 | 0.0660 |

The transition is not gradual. Coverage is either near one or near zero, and the switch is at exactly
the radius where the ball first spans every check in a round: distance 5 needs `r = 1`, distance 7
needs `r = 2`, distance 9 needs `r = 3`, and distance 15 has not reached it by `r = 3`. Surface
distance 5 needs `r = 1` (its 12 checks fit in a 10-detector ball once time is counted), distance 7
does not reach it at `r = 1` and its `r = 2` ball is 28 bits.

The per-position census makes it unambiguous. `--mode positions`, repetition `d = 9`, `r = 3`, 3,000
histories at 1%:

| commit qubit | ball | rank | proved | bounded | ambiguous |
|---|---|---|---|---|---|
| 0 | 10 | 4 | 0.0427 | 0.0547 | 0.9027 |
| 1 | 14 | 5 | 0.0693 | 0.0720 | 0.8587 |
| 2 | 17 | 6 | 0.0850 | 0.1010 | 0.8140 |
| 3 | 19 | 7 | 0.0263 | 0.1177 | 0.8560 |
| **4** | **20** | **8** | **0.9497** | 0.0383 | 0.0120 |
| 5 | 19 | 7 | 0.0283 | 0.1200 | 0.8517 |
| 6 | 17 | 6 | 0.0927 | 0.0943 | 0.8130 |
| 7 | 14 | 5 | 0.0760 | 0.0700 | 0.8540 |
| 8 | 10 | 4 | 0.0497 | 0.0520 | 0.8983 |

Qubit 4 touches checks 3 and 4, so radius 3 reaches checks 0 through 7 — every check. Qubit 3 touches
checks 2 and 3, so radius 3 misses check 7, and coverage falls by a factor of 36. One missing column
destroys the certificate.

### Why, and it is a theorem not an artifact

The proved tier quantifies over every crossing pattern, and a crossing pattern can inject a pair of
defects on the ball's outer shell. Those two defects must be paired using interior mechanisms only —
the crossing mechanisms are fixed by the context, so they are not available as an escape. If the ball
contains a real code boundary, each injected defect matches to that boundary cheaply and never
approaches the commit region. If the ball is pure bulk, an antipodally placed injected pair has its
unique geodesic straight through the middle of the ball, which is where `R` sits, so that context
forces a nonzero action while the observed-syndrome context forces zero, the intersection is empty,
and the window defers. The transition is sharp because the geodesic argument is sharp: with a
boundary in the ball there is always an escape at cost at most `r`, and without one there is not.

Answering the question as posed: **a defect farther than radius `r` from the commit region can still
change the safe local action, for every `r` short of a full spatial cut.** The neighbourhood that
suffices is a full cut of the code, so it does depend on `d` — linearly for the repetition code and
quadratically for the rotated surface code.

The bounded tier is where locality does hold. Restricting the crossing pattern to
weight at most one covers 93% to 96% of windows at every distance and radius tested, uniformly and
with no distance dependence at all. That is a genuine `d`-independent local policy, but its authority
is `BoundedSafe`: it commits only under a declared bound of at most one fault crossing the ball
boundary, which at 1% physical error and 8 to 28 crossing mechanisms is an assumption that fails on a
few percent of shots. It is not accuracy-identical to the strong decoder, so it is excluded from
every headline number here, exactly as probe 23 excluded its bounded tier.

## 3. The compiled local predecoder

`--mode compile`, proved tier only, six rounds. `commit fraction` is over *all* ball syndromes, not
the sampled ones, so it is much lower than the coverage tables above, which sample at a physical rate.

| family | `d` | `r` | ball bits | table bytes | distinct decisions | commit fraction of all syndromes |
|---|---|---|---|---|---|---|
| repetition | 3 | 3 | 8 | 256 | 2 | 1.000 |
| repetition | 5 | 3 | 14 | 16,384 | 3 | 0.940 |
| repetition | 7 | 3 | 18 | 262,144 | 3 | 0.712 |
| repetition | 9 | 3 | 20 | 1,048,576 | 3 | 0.379 |
| surface | 5 | 1 | 10 | 1,024 | 2 | 0.250 |
| surface | 7 | 1 | 10 | 1,024 | 1 | 0.000 |
| surface | 9 | 1 | 10 | 1,024 | 1 | 0.000 |

The compiled artifact is small — a **1,024-byte direct lookup on the surface code at any distance**,
because the ball width saturates — and it is a flat table indexed by the ball syndrome, so no
automaton minimization is needed to make it fit: at 10 bits the trie the probe-13 worklist minimizer
consumes is already smaller than the table it would produce. The two rows that matter are the last
two: at distance 7 and 9 the surface policy has **one** distinct decision, `defer`, so the table is
1 KB of nothing.

Compiling `r = 2` at surface distance 5 requires `2^22` ball syndromes times 4,096 contexts and did
not finish inside a two-minute bound; distance 7 and 9 at `r = 2` need `2^28` and `2^31` syndromes
times up to 2.1 million contexts, which is out of reach and would in any case not span a cut.

### Instructions per committed round

Fixed-window harness, two-size differencing on `--operations` (20,000 against 120,000), seven
interleaved rounds, `perf stat -e instructions,cycles`, binary pinned at
`~/.cache/ergodis/bin/ergodis-tools-p29`, SHA-256
`0276cdc8ca452cffc36e2fefa1293e615564e4b0e11b27ff06de36841482fcba`. The timed loop allocates nothing;
every buffer is presized before it. Setup — compiling nine policies of `2^20` entries — does not scale
with `--operations` and is removed exactly by the differencing, which is visible in the raw counts:
38.85 billion instructions at the small size against 39.39 billion at the large one.

Repetition `d = 9`, `r = 3`, 1% physical error, six rounds, nine commit positions per round:

| quantity | value |
|---|---|
| instructions per position evaluation | **296.11**, sd 0.00%, 95% CI [296.11, 296.11], `n = 7` |
| cycles per position evaluation | 88.82, sd 142%, `n = 7` (the box is contended; instructions are primary) |
| positions per committed round | 9 |
| instructions per committed round | **2,665** |
| positions committed, of 180,000 | 28,669 (15.9%) |
| **shot-level defer rate** | **0.9998** |

Two facts settle the speed question without a fresh PyMatching arm. First, 2,665 instructions per
committed round is already above probe 13's measurement of PyMatching at distance 9 and 1% error
(2,296 instructions per decode, frozen inputs, same box). Second, and decisively, the shot-level
defer rate is 0.9998 — because a shot benefits only if every position on it commits, and eight of the
nine positions certify about 5% of the time. The composed figure `LUT + defer_rate × PyMatching`
is therefore worse than PyMatching alone. The same run on the rotated surface code at distance 5,
`r = 1` gives a shot-level defer rate of exactly 1.0000: 296,309 of 460,000 position evaluations
commit, but no shot has all 25 positions commit.

There is a further point worth recording plainly: the committed weight is **zero** in every run. The
proved local action is always "no error here". That is not a bug — certifying the absence of a
correction is what a min-weight local certificate can prove at 1% error, and it does retire
mechanisms and shrink the residual problem — but it means the predecoder is not committing
corrections, it is committing clean verdicts, and a strong decoder still runs on the residual.

## 4. Verdict

**No. The compiled certified predecoder does not reach distance 9 on the rotated surface code, and
what bounds it is the requirement that the ball span a full spatial cut.**

The three-line version. Committing a local correction rather than a global parity is the right
change and it fixes what probe 27 said was broken: the certificate is sound at every radius with no
reachability quantifier and no exact-tie gap, the handoff is a genuine residual decoding instance
verified exhaustively, and the compiled table's width stops growing with distance. But the proved
tier needs a boundary escape inside the ball, so the neighbourhood that suffices is a full cut — a
line of `d − 1` checks on the repetition code, an area of `(d^2 − 1)/2` checks on the surface code —
and enumerating `2^cut` is probe 27's wall reached by a different road. At surface distance 7 and 9
the radius-1 policy is 1 KB of `defer` and the radius-2 policy needs `2^28` to `2^31` ball syndromes.

What is *not* bounded by this is the bounded tier: a 1 KB, distance-independent, radius-1 table that
covers 93% of windows on any surface code under a declared bound of at most one fault crossing the
ball boundary. If the deployment contract can carry that bound, this is a deployable artifact and the
only probe-29 result that scales. It is not accuracy-identical to the strong decoder, which is why it
is not the headline.

## `ej` + `tt` closeout

Cheap upgrades taken during this pass: the per-position census (which is what converted "locality
fails" into the sharp full-cut criterion), the regression test that pins the sharp transition so a
future change cannot silently soften it, and the linear-subspace representation of the crossing
quantifier, which turned a `2^crossing` enumeration into `2^rank` and is what made distances up to 15
measurable at all.

What Tao would push on, and it is the strongest remaining lead: the certificate as posed lets the
adversary inject defects into the ball **for free**, while physically each injected defect costs one
fault. A certificate that charges the crossing pattern its own weight and compares across contexts —
rather than intersecting within each context separately — would rule out the antipodal-injection
pathology without any declared fault bound. That comparison needs a local lower bound on the outside's
cost, which the observed syndrome outside the ball supplies. That is a different certificate, not a
tuning of this one, and it is the natural successor.

Not pursued, and deliberately: enlarging the commit region beyond one mechanism (it enlarges the ball
faster than it enlarges the action, so it moves the wall the wrong way), and the automaton minimizer
(at 10 to 20 ball bits the flat table is already smaller than a minimized machine over the same
alphabet).

## Mystery ledger

- **Why is the transition so sharp?** Settled by this pass. The geodesic argument above predicts a
  step, not a slope: with a boundary in the ball there is always an escape of cost at most `r`,
  without one the through-`R` geodesic is strictly shortest. The per-position table at `d = 9`
  confirms it — a factor of 36 between adjacent commit positions.
- **The bounded tier is flat at 93% to 96% across every distance and radius tested.** Genuinely
  distance-independent and not explained beyond the observation that a single crossing fault has a
  local escape. Whether that flatness survives circuit-level noise is untested; the DEM from probe 13
  was not wired in, and that is the exact gap.
- **The committed action is always zero.** Expected at 1% error but it bounds what the artifact can
  be sold as. Whether a proved *nonzero* commit ever occurs at higher error rates was not measured;
  the `weight` column of `--mode sweep` is the instrument and it reads zero at 1%.
- **Surface `r = 2` at distance 5 did not compile inside two minutes.** `2^22` syndromes times 4,096
  contexts is roughly 1.7e10 metric lookups. Not a wall, just uncosted; it would take about an hour
  and would not change the verdict, since distance 5 already certifies at `r = 1`.
- **Repetition distance 15, `r = 3` certifies 3.2% rather than the ~1% the bulk rows show.** Slightly
  above its neighbours and unexplained; probably the ball is close enough to a cut that a minority of
  syndromes have no antipodal injection available. Not characterized.

## Files and commands

All work is in `ergodis-private`, committed as `a120c33`. `/home/tavis/src/ergodis` was not modified.
The concurrent agent's `tiger_blossom*` modules were not touched.

- `/home/tavis/src/ergodis-private/src/local_commit_predecoder.rs` — the decoding graph, both code
  families, the ball and crossing subspace, the compiled interior metric, the certificate, the
  compiled policy, the exhaustive oracle, and the gates.
- `/home/tavis/src/ergodis-private/tasks/tools/src/local_commit_bench.rs` — the
  `local-commit-bench` subcommand with the `shape`, `locality`, `positions`, `coverage`, `compile`
  and `sweep` modes.

```
cd /home/tavis/src/ergodis-private
cargo fmt -p ergodis-private -p ergodis-tools
cargo test --release -p ergodis-private --lib -- local_commit_predecoder   # 7 passed
cargo clippy -p ergodis-private --lib -- -D warnings                       # clean
cargo build --release -p ergodis-tools
ergodis-tools local-commit-bench --mode shape --rounds 6
ergodis-tools local-commit-bench --mode locality --family repetition --distance 9 \
    --rounds 6 --radius 4 --rate 0.01 --operations 4000 --cap 20
ergodis-tools local-commit-bench --mode positions --family repetition --distance 9 \
    --rounds 6 --radius 3 --rate 0.01 --operations 3000 --cap 20
ergodis-tools local-commit-bench --mode coverage --family repetition --rounds 6 --radius 3 \
    --operations 4000 --cap 20
ergodis-tools local-commit-bench --mode compile --family surface --rounds 6 --radius 1 --cap 22
ergodis-tools local-commit-bench --mode sweep --family repetition --distance 9 --radius 3 \
    --rate 0.01 --rounds 6 --operations 120000 --cap 20
```

## Vibe check

Conceptually a clear win, commercially a clear negative, and the two do not cancel. The local-commit
certificate is strictly better mathematics than probe 23's — sound at any radius, no tie gap, a real
residual handoff, exhaustively verified on both code families — and the ball width genuinely stops
growing with distance, which is what the redirect asked for. Then the measurement says the proved
tier needs a full spatial cut inside the ball, which is the same exponential probe 27 hit, and the
one distance-independent policy that does work carries a declared fault bound rather than exactness.
Route 1's certificate keeps getting better and route 1's compilation keeps hitting the same wall from
a new direction; the next move is a certificate that charges the context its own weight, not another
way to shrink the context.
