# C1061 probe 30: the margin certificate — charging the crossing context its own weight

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 30, building the successor named at the end of
`notes/2026-09-03-c1061-probe29-local-commit-predecoder.md`.

Contract documents read in full before this line of probes:
`/home/tavis/src/ergodis/CLAUDE.md`, `/home/tavis/src/ergodis-contrib/PERFORMANCE.md`,
`/home/tavis/src/ergodis-contrib/performance-playbook.md`,
`/home/tavis/src/ergodis-private/CLAUDE.md`.

## Headline

Pricing the crossing context removes probe 29's full-spatial-cut requirement completely. At radius 1
on the rotated surface code the margin certificate commits **97.4% of windows at distance 5, 7 and 9
alike**, through one 1,024-byte table that is literally the same table at every distance, where probe
29's per-context intersection committed 0.0000 at distance 7 and 9. The shot-level defer rate falls
from 1.0000 to 0.611 at distance 9 and to 0.212 at distance 5 with a two-tier radius cascade, and the
predecoder now commits real corrections rather than only certifying absence.

What it does not deliver is a speedup. At 415.50 instructions per commit position and 79 positions per
round, a committed round at distance 9 costs 32,825 instructions against PyMatching's 2,296 per shot,
and the Fermi estimate says even a well-implemented version lands at parity, because the per-round work
is `O(d^2)` positions either way. And the margin that is *audited* sound at radius 1 is 3, not 2; at 3
the certificate certifies only absence and defers every shot. So: **accuracy-identical certified
predecoding still does not reach distance 9 on the surface code, but the obstruction has moved from
the certificate to the margin's audit range and to the per-round instruction budget.**

## 1. The margin certificate

### The escaped-ball problem

Keep probe 29's decomposition into **interior** mechanisms (every detector inside the ball `B`),
**crossing** mechanisms (at least one detector inside and one outside), and the rest. A *local
explanation with escape* is a set `X` of interior and crossing mechanisms with `∂X|_B = s|_B`, with
nothing required of `X` outside the ball. Its cost is `|X|`, so a crossing mechanism is an escape that
is **paid for** at its own weight rather than being free — which is exactly the defect probe 29
identified. For each commit action `a`,

```text
W_a(s) = min { |X| : X ⊆ interior ∪ crossing, ∂X|_B = s|_B, X|_R = a }
```

`W_a` is compiled once by breadth-first search over `F_2^B × F_2^R` with the crossing mechanisms added
as generators that toggle their ball detectors and no action bit. Unit weights make breadth-first
search exact. The table is finite everywhere, unlike probe 29's interior-only metric, because every
syndrome can always escape.

### The condition and its proof

Write a global solution as `E = X ∪ O` with `X = E ∩ (interior ∪ crossing)` and `O` the mechanisms
never touching `B`, and let `Out(c) = min { |O| : ∂O|_out = s|_out ^ ∂c|_out }`. Let `G_a` be the
least weight of a global solution with commit restriction `a`. Two bounds are immediate:
`G_a ≤ W_a + Out(c_a)` for the crossing set `c_a` of a `W_a`-witness, and `G_a' ≥ W_a'` for every
action, since `X` is one competitor in the minimization. Writing `Δ` for any upper bound on the
**outside advantage** `Out(c_a) − Out(c*)`:

```text
a is safe   ⟸   W_a + Δ  ≤  min over a' ≠ a of W_a'          (the margin condition)
```

**Splicing argument.** Let `E*` be any global optimum, with restriction `a*` and crossing set `c*`. If
`a* = a` there is nothing to prove. Otherwise the margin condition gives `W_a + Δ ≤ W_a*`. Take a
`W_a`-witness `X_a` with crossing set `c_a`, and an outside completion `O_a` of `c_a` of weight
`Out(c_a)`. Then `E' = X_a ∪ O_a` has boundary `s` everywhere — inside `B` by construction of `X_a`,
outside by construction of `O_a` — and restriction `a`. Its weight is

```text
|E'| = W_a + Out(c_a) ≤ (W_a* − Δ) + (Out(c*) + Δ) = W_a* + Out(c*) ≤ |X*| + |O*| = |E*|
```

using the margin condition, the definition of `Δ`, and `W_a* ≤ |X*|`. So `E'` is a global solution of
weight at most the optimum, hence itself optimal, with restriction `a`. **A global optimum whose ball
restriction is not `a` re-splices to one that is, at no extra weight.** The handoff contract is
probe 29's unchanged: the residual is `s ^ ∂a` with `R` retired, and its optimum is `globalmin − |a|`.

### The bound on outside advantage, stated exactly

Boundaries add, so appending a repair set to an outside solution gives, for any crossing patterns
`c, c'`,

```text
Out(c) ≤ Out(c') + R(c ^ c'),   R(D) = min { |P| : P outside-only, ∂P|_out = ∂D|_out }
```

and therefore `Δ ≤ R_max := max over D in the crossing subspace with R(D) finite of R(D)`. `R_max`
depends only on the graph and the ball, not on the syndrome, and it is computed here exactly by
breadth-first search in the outside-only graph while that graph is small enough. Measured:

| family | `d` | rounds | `r` | ball | crossing | rank | outside detectors | `R_max` |
|---|---|---|---|---|---|---|---|---|
| repetition | 5 | 4 | 1 | 6 | 6 | 4 | 10 | 3 |
| repetition | 5 | 4 | 2 | 10 | 6 | 4 | 6 | 3 |
| repetition | 5 | 4 | 3 | 14 | 4 | 4 | 2 | 2 |
| surface | 3 | 4 | 1 | 6 | 8 | 4 | 10 | 5 |
| surface | 3 | 4 | 2 | 10 | 8 | 4 | 6 | 5 |

`R_max` is a worst case over the entire crossing subspace and is correspondingly loose — 5 on the
surface code where the audit below shows 2 suffices. So the operational question is not what `Δ` is in
the abstract but **what the smallest sound `Δ` actually is**, and that is measured, not estimated.

## 2. The smallest sound margin, determined exhaustively

`--mode audit`: over every syndrome of weight at most 4, the certificate's commit is checked against a
full metric-closure oracle for the handoff identity `globalmin = |a| + residualmin`. A violation is a
commit that raises the global minimum weight. `worst_excess` is the largest amount by which one did.

| family | `d` | rounds | `r` | `Δ` | examined | committed | **violations** | worst excess |
|---|---|---|---|---|---|---|---|---|
| repetition | 3 | 3 | 1 | 0 | 57 | 57 | 2 | 1 |
| repetition | 3 | 3 | 1 | **1** | 57 | 42 | **0** | 0 |
| repetition | 5 | 3 | 1 | 1 | 794 | 731 | 10 | 2 |
| repetition | 5 | 3 | 1 | **2** | 794 | 431 | **0** | 0 |
| repetition | 7 | 3 | 1 | 2 | 4,048 | 2,676 | 4 | 1 |
| repetition | 7 | 3 | 1 | **3** | 4,048 | 2,148 | **0** | 0 |
| surface | 3 | 3 | 1 | 1 | 794 | 659 | 20 | 1 |
| surface | 3 | 3 | 1 | **2** | 794 | 409 | **0** | 0 |
| surface | 3 | 4 | 1 | **2** | 2,517 | 1,528 | **0** | 0 |
| repetition | 3 | 3 | 2 | **0** | 57 | 57 | **0** | 0 |
| repetition | 5 | 3 | 2 | 0 | 794 | 794 | 10 | 1 |
| repetition | 5 | 3 | 2 | **1** | 794 | 651 | **0** | 0 |
| repetition | 5 | 4 | 3 | **1** | 2,517 | 2,176 | **0** | 0 |
| repetition | 7 | 3 | 2 | 1 | 4,048 | 3,624 | 56 | 2 |
| repetition | 7 | 3 | 2 | **2** | 4,048 | 2,661 | **0** | 0 |
| surface | 3 | 3 | 2 | **2** | 794 | 349 | **0** | 0 |
| surface | 3 | 4 | 2 | **2** | 2,517 | 1,236 | **0** | 0 |

Three readings.

**The smallest sound margin is small and it does not grow with distance the way the radius did.** No
instance audited needs more than 3, and the value that suffices is a function of the radius and the
family, not of `d`: at radius 2 it is 1 to 2 everywhere, at radius 1 it is 2 on the surface code and 3
on the repetition code at distance 7. That is the qualitative difference from probe 29, whose
requirement was a full spatial cut and therefore grew linearly in `d`.

**`Δ = 0` — the unpriced escaped-ball policy, which is what a clustering or union-find predecoder
effectively assumes — is genuinely wrong, and by a measurable amount.** It violates on 2 of 57
syndromes at the smallest instance and on 107 of 4,048 commits at repetition distance 7, radius 1, with
excess up to 2. It is not a certificate; the margin is what makes it one.

**A larger radius buys a smaller margin.** Radius 2 needs `Δ = 1` where radius 1 needs 2 or 3, which is
the expected trade: a bigger ball leaves the outside less room to help.

The audit's reach is the real limit here. The oracle is a metric closure over `2^detectors`, so it
covers repetition codes to distance 7 and surface codes only to distance 3. **The surface-code margin
at radius 1 is therefore verified exhaustively at distance 3 and assumed at distance 5, 7 and 9.** That
assumption is the one gap in this probe's exactness claim and it is stated rather than buried.

## 3. The compiled predecoder

### Coverage

`--mode coverage`, 4,000 planted histories per point, six rounds, commit region one central data
mechanism, radius 1. `committed` is the fraction of windows the certificate commits; `corrections` is
the fraction where the committed action is a nonzero correction rather than "no error here".

**Correction (probe 28h, 2026-09-04).** The distance-9 rows below were computed on the graph whose
32-bit check-support masks aliased distance 9's checks 32 to 39 onto 0 to 7 (probe 28c). Re-derived
on the repaired graph they are 0.6752 / 0.9711 / 0.0059 at `Δ = 2` and 0.6752 / 0.8768 / 0.0000 at
`Δ = 3`, both at 1% error: unchanged within the sampling of 20,000 shots, because a radius-1
surface ball is ten detectors and never reaches an aliased check. The deterministic compile row
further down is identical. Probe 28c has separately withdrawn the `Δ = 2` coverage figures as
coverage by unsound commits. See
`2026-09-04-c1061-probe28h-margin-radius-and-the-surface-d9-rederivation.md`.

| `d` | `Δ` | ball | rate | clean | **committed** | corrections |
|---|---|---|---|---|---|---|
| 5 | 2 | 10 | 0.001 | 0.9600 | **0.9998** | 0.0010 |
| 5 | 2 | 10 | 0.01 | 0.6827 | **0.9758** | 0.0063 |
| 7 | 2 | 10 | 0.001 | 0.9643 | **0.9992** | 0.0003 |
| 7 | 2 | 10 | 0.01 | 0.6703 | **0.9740** | 0.0077 |
| 9 | 2 | 10 | 0.001 | 0.9595 | **1.0000** | 0.0010 |
| 9 | 2 | 10 | 0.01 | 0.6763 | **0.9692** | 0.0043 |
| 5 | 3 | 10 | 0.01 | 0.6827 | 0.8822 | 0.0000 |
| 7 | 3 | 10 | 0.01 | 0.6703 | 0.8738 | 0.0000 |
| 9 | 3 | 10 | 0.01 | 0.6763 | 0.8752 | 0.0000 |

At `Δ = 2` coverage is 97% at 1% error and **identical at distance 5, 7 and 9** — the ball is 10 bits
at every distance from 5 up, so the policy is one and the same table. Only 67.6% of windows are clean,
so the certificate is deciding syndromes containing defects, and 0.4% to 0.8% of commits are actual
corrections. At `Δ = 3` coverage drops to 87.5% and every commit is a clean verdict; the margin of 3
is never cleared by a syndrome that wants a correction.

Radius 2 at distance 5 is a 22-bit ball and covers 99.1% at `Δ = 2`; radius 2 at distance 7 and 9 is 28
and 31 bits and does not compile inside the cap.

### The three certificates side by side, distance 9, radius 1, 1% error

| certificate | authority | per-window coverage | shot-level defer |
|---|---|---|---|
| probe 29 per-context intersection | proved, no assumption | **0.0000** | 1.0000 |
| probe 29 bounded tier, one crossing fault | declared fault bound | 0.9340 | not measured |
| **probe 30 margin, `Δ = 2`** | proved given `Δ ≥ 2` | **0.9692** | **0.6110** |
| probe 30 margin, `Δ = 3` | proved given `Δ ≥ 3` | 0.8752 | 1.0000 |

The margin certificate beats the bounded tier's 93% to 96% band and does it with a *stated bound on a
graph quantity* rather than a declared assumption about how many faults the outside is allowed to have.
That is the substantive improvement of this probe.

### Compiled artifact

`--mode compile`, radius 1, `Δ = 2`:

| `d` | ball bits | table bytes | distinct decisions | commit fraction of all syndromes |
|---|---|---|---|---|
| 3 | 6 | 64 | 2 | 0.281 |
| 5 | 10 | **1,024** | 3 | 0.188 |
| 7 | 10 | **1,024** | 3 | 0.188 |
| 9 | 10 | **1,024** | 3 | 0.188 |

Three distinct decisions — commit nothing, commit the correction, defer — in a flat 1,024-byte table
that fits in L1 and is the same table at distance 5, 7 and 9. No automaton minimization is applied and
none is useful: at 10 ball bits the direct table is already smaller than a minimized Moore machine over
the same alphabet would be, which is the same conclusion probe 29 reached and the reason the
probe-13 worklist minimizer is not in this pipeline.

### The radius cascade

`--mode cascade`, radius as the tier: try radius 1 at a position, then radius 2, then defer that
position. Surface distance 5, `Δ = 2`, 1% error, 4,000 shots, 23 commit positions:

| settled at `r = 1` | at `r = 2` | position defer | **shot-level defer** |
|---|---|---|---|
| 0.95152 | 0.02700 | 0.02148 | **0.2125** |

The second tier halves the shot-level defer rate, from 0.396 at radius 1 alone to 0.2125. At distance 7
and 9 the radius-2 tier does not compile, so those distances get the single tier and its 0.549 and
0.611 shot-level defer rates.

### Instructions per committed round, and the composed figure

Fixed-window harness, two-size differencing on `--operations` (20,000 against 120,000), seven
interleaved rounds, `perf stat -e instructions,cycles`, binary pinned at
`~/.cache/ergodis/bin/ergodis-tools-p30`, SHA-256
`db47f0503cca688ed80cb24b6f44b6b28e9ea6a82f5171ca5b558f7f7eab3807`. The timed loop allocates nothing;
every buffer is presized. Surface code, radius 1, `Δ = 2`, 1% error, six rounds.

| `d` | positions per round | instructions per position | cycles per position | instructions per committed round | shot-level defer |
|---|---|---|---|---|---|
| 5 | 23 | **391.34**, sd 0.00%, CI [391.34, 391.34], `n = 7` | 72.51, CI [71.94, 73.08] | 9,001 | 0.3960 |
| 9 | 79 | **415.50**, sd 0.00%, CI [415.50, 415.50], `n = 7` | 80.08, CI [79.47, 80.69] | 32,825 | 0.6110 |

PyMatching at distance 9 and 1% error costs 2,296 instructions per decode on this box (probe 13, frozen
inputs). The composed figure `LUT + defer_rate × PyMatching` is therefore
`32,825 + 0.611 × 2,296 = 34,228` instructions per committed round against 2,296 — a **14.9x loss**,
not a win. At distance 5 it is `9,001 + 0.396 × 1,245 = 9,494` against 1,245, a 7.6x loss.

The implementation is part of that. Each position re-gathers its ball out of a `Vec<bool>` syndrome,
which is ten dependent byte loads before the table lookup, and the syndrome is rewritten after every
commit. A bitset syndrome with precomputed ball masks would plausibly cut 415 to something near 30.
But the Fermi estimate says that does not rescue the comparison: the predecoder does `O(d^2)` position
evaluations per committed round — 79 at distance 9 — while PyMatching decodes a whole six-round shot
for 2,296 instructions, about 380 per round. At 30 instructions per position the predecoder would be at
2,370 per round, parity, and it would still hand 61% of shots to PyMatching. **The per-round work is
`O(d^2)` for both, so there is no asymptotic room, and the constant is not where a 10x lives.**

## 4. Verdict

**No. Accuracy-identical certified predecoding still does not reach distance 9 on the rotated surface
code.** But the reason has changed, and that is the result.

Probe 29's obstruction was the certificate: the proved tier needed the ball to span a full spatial cut,
so the required radius grew like `d/2` and the enumeration like `2^cut`. **That obstruction is gone.**
Pricing the crossing context gives 97% coverage at distance 5, 7 and 9 through one 1,024-byte
distance-independent table, with a soundness condition that is a bound on a graph quantity rather than
an assumption about the future, proved by a splicing argument and verified exhaustively wherever an
oracle fits.

Two things stand in its place. First, the audit reaches surface distance 3 and repetition distance 7,
so `Δ = 2` at radius 1 on a distance-9 surface code is *extrapolated*, not verified; the value that is
audited sound at radius 1 on the hardest instance available is 3, and at 3 the certificate defers every
shot. Second, and independent of that, the per-round instruction budget is `O(d^2)` position
evaluations, which is the same order as the decoder it is trying to replace, so there is no composed
win at any implementation quality.

### Where the margin is too conservative

Characterizing the deferred syndromes, from the coverage and compile tables together. The certificate
defers exactly when two actions are within `Δ` of each other in escaped-ball cost, and at radius 1 that
happens in one recognizable family: **a syndrome whose defect can be explained either by the commit
mechanism or by escaping through the ball's shell at the same or nearly the same cost.** Because the
ball is small the escape is always cheap — a defect adjacent to the shell is one crossing mechanism
away — so the two costs are almost always within 1 or 2 of each other whenever the commit mechanism is
implicated at all. That is why `Δ = 3` kills every correction and leaves only clean verdicts: three is
more than the entire dynamic range of `W_a` over sparse syndromes at radius 1.

The consequence is a design statement, not a tuning knob. The margin must be smaller than the local
cost differences the ball can express, and at radius 1 the ball can only express differences of 0, 1
and 2. **A margin certificate needs a ball big enough that the local costs spread out further than the
outside advantage.** Radius 2 is that ball — it needs only `Δ = 1` and covers 99.1% at distance 5 — and
it is 22 bits at distance 5 and 28 to 31 bits at distance 7 and 9. The next lever is therefore not a
better certificate but a representation of the radius-2 ball that avoids enumerating `2^28`.

## `ej` + `tt` closeout

Taken during this pass: the exhaustive margin audit itself, which converted "state a bound" into
"measure the smallest sound bound" and is what showed `R_max` is loose by more than a factor of two;
the radius cascade, which halved the distance-5 shot defer rate for free; and the `Δ = 0` row, which
quantifies how wrong the unpriced escaped-ball policy — the shape a clustering predecoder assumes — is,
at 2.6% of commits on repetition distance 7.

What Tao would ask, and it is the sharpest remaining question: the outside advantage `Δ` is being
treated as a single scalar over the whole crossing subspace, but the splicing argument only ever needs
it for the *particular* pair `(c_a, c*)`, and `c_a` is known — it is the witness's own crossing set. A
per-witness bound `Δ(c_a) = R(c_a) + R_max` is already tighter, and a bound that uses the observed
syndrome just outside the ball to rule out expensive `c*` would be tighter still and would be
locally computable. That is the version worth building before enlarging the ball.

Not pursued, deliberately: the bitset-syndrome optimization of the sweep loop (the Fermi estimate above
says it changes a 14.9x loss to roughly parity, which does not change any conclusion), and the
circuit-level detector error model (probe 13's DEM was not wired into the graph builder, so every number
here is phenomenological — stated, not glossed).

## Mystery ledger

- **Why does radius 1 need `Δ = 3` on the repetition code but only `Δ = 2` on the surface code?**
  Measured, unexplained. The surface ball at radius 1 has more crossing mechanisms (8 against 6) yet
  tolerates a smaller margin, which is the opposite of the naive expectation. Not characterized.
- **`R_max` is 5 on the surface code where 2 suffices.** Expected — it is a worst case over the whole
  crossing subspace including patterns no optimum would use — but the factor is large enough that the
  provable bound and the true bound are different objects, and only the true one is useful. The
  per-witness refinement above is the way to close the gap.
- **At `Δ = 3` the correction rate is exactly 0.0000 at every distance and rate.** Cleanly explained by
  the dynamic-range argument in section 4, but it means the audited-sound configuration is a pure
  absence-certifier, which is the same limitation probe 29 hit and is now understood as a consequence
  of ball size rather than of the certificate.
- **Cycles per position are stable at 72 to 80 while instructions are 391 to 415**, an IPC above 5.
  That is the table lookup being served from L1 with the ball gather fully pipelined, and it says the
  loop is frontend-bound on instruction count, which is exactly what the bitset rewrite would fix.
- **The surface-code audit stops at distance 3** because the oracle is a `2^detectors` metric closure.
  Extending it needs a matching-based oracle rather than a closure, which is a real piece of work and
  is the gate on calling the distance-9 configuration verified.

## Files and commands

All work is in `ergodis-private`, committed as `c4ba919`. `/home/tavis/src/ergodis` was not modified;
the concurrent agent's `tiger_blossom*` modules were not touched. One transient `E0004` from that
agent's mid-edit was observed during a `retain-bin.sh` rebuild and cleared on its own; it is not in my
files.

- `/home/tavis/src/ergodis-private/src/margin_certificate.rs` — the escaped-ball metric, the margin
  condition and its proof, the outside-advantage bound, the exhaustive audit, and the compiled policy.
- `/home/tavis/src/ergodis-private/tasks/tools/src/margin_certificate_bench.rs` — the
  `margin-certificate-bench` subcommand with the `audit`, `bound`, `coverage`, `compile`, `cascade`
  and `sweep` modes.

Gates, five in this module plus probe 29's seven, all passing:
`paying_for_escapes_never_costs_more_than_forbidding_them`,
`a_margin_safe_action_preserves_the_global_minimum_weight`,
`the_margin_certificate_is_exact_on_the_surface_code`,
`the_compiled_margin_policy_reproduces_the_certifier`,
`a_larger_margin_only_ever_commits_less`.

```
cd /home/tavis/src/ergodis-private
cargo fmt -p ergodis-private -p ergodis-tools
cargo test --release -p ergodis-private --lib -- margin_certificate local_commit   # 12 passed
cargo clippy -p ergodis-private --lib -- -D warnings                               # clean
cargo build --release -p ergodis-tools
ergodis-tools margin-certificate-bench --mode audit --max-weight 4
ergodis-tools margin-certificate-bench --mode bound --family surface --distance 3 --rounds 4 --radius 2
ergodis-tools margin-certificate-bench --mode coverage --family surface --rounds 6 --radius 1 \
    --delta 2 --operations 4000 --cap 22
ergodis-tools margin-certificate-bench --mode compile --family surface --rounds 6 --radius 1 --delta 2
ergodis-tools margin-certificate-bench --mode cascade --family surface --distance 5 --rounds 6 \
    --radius 2 --delta 2 --rate 0.01 --operations 4000 --cap 22
ergodis-tools margin-certificate-bench --mode sweep --family surface --distance 9 --rounds 6 \
    --radius 1 --delta 2 --rate 0.01 --operations 120000 --cap 22
```

## Vibe check

The best certificate in the series and still not a decoder. Pricing the context is clearly the right
move — it deletes probe 29's full-cut requirement outright, gives 97% coverage at distance 5, 7 and 9
through a single 1,024-byte table, and replaces a declared fault bound with a proved bound on a graph
quantity. Three probes in a row have now improved the certificate and left the compilation or the
budget standing, and this one finally says where the wall really is: not in the mathematics but in the
fact that a per-position local predecoder does `O(d^2)` work per round, the same order as the decoder
it wants to replace. If route 1 is to produce a speedup rather than a proof, the next thing to change
is not the certificate again but the unit of work.
