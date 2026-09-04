# C1061 probe 23: the context-certified predecoder

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 23, route 1 of `notes/2026-09-03-c1061-qec-redirect-brief.md`.
**Predecessors**: probes 13 and 17 closed the dense space-cut decoder as a per-shot competitor to
sparse blossom. This probe pursues the reframing rather than fighting that negative.

Contract documents read in full before this line of probes:
`/home/tavis/src/ergodis/CLAUDE.md`, `/home/tavis/src/ergodis-contrib/PERFORMANCE.md`,
`/home/tavis/src/ergodis-contrib/performance-playbook.md`,
`/home/tavis/src/ergodis-private/CLAUDE.md`.

Status: in progress; sections are filled as each measurement lands.

## The certificate, stated precisely

Take a window of the first `T` rounds of a history on a distance-`d` repetition code under the
phenomenological model. The future interacts with the window **only** through the seam
measurement-error vector `b = f_{T-1} in F_2^{d-1}`, which the future determines, not the window.
Probes 10 and 13 pinned that seam to zero and measured the accuracy cost of doing so; this route
refuses to choose it at all.

Let the **commit region** be the first `c` rounds and let the committed action `a` be the logical
parity that region contributes. For each seam state `b`,

```text
K(s, b) = { a : some minimum-weight explanation of s conditional on b has commit parity a }
Safe(s) <=> the intersection of K(s, b) over every reachable b is nonempty
```

If `a` lies in that intersection, commit it; otherwise defer to the strong decoder.

### Why committing a safe action is exact — an argument, not a sample

Let `b*` be the seam state of any global minimum-weight solution. Its restriction to the window must
itself be a minimum-weight window explanation conditional on `b*`: if a cheaper one existed,
splicing it in would lower the global weight, because the future's cost depends on the window only
through `b*`. So the global optimum's commit parity lies in `K(s, b*)`. If `a` is in the
intersection then `a in K(s, b*)`, so there is a minimum-weight window explanation conditional on
`b*` whose commit parity is `a`; splice it in and the total weight is unchanged. **Committing `a`
preserves at least one global minimum-weight solution.**

For the logical outcome the conclusion is sharp when the two class costs differ. If `C_0 < C_1` then
every global optimum has class 0; the preserved optimum has class 0; so the residual decode still
returns 0. Under an exact tie `C_0 == C_1` the preserved optimum may lie in either class, so the
committed action can select either — on a shot where the full decoder is already guessing. **That
tie case is the one gap in the exactness claim, and it is measured rather than assumed.**

### Provenance tiers

| Tier | Condition | Authority |
|---|---|---|
| `ProvedSafe` | intersection over *every* reachable seam state is nonempty | commit, no assumption about the future |
| `BoundedSafe` | intersection is nonempty over seam states within a declared slack of the cheapest | commit only under a declared fault bound on the future |
| `Ambiguous` | neither | defer to the strong decoder |

Overall accuracy is identical to the strong decoder by construction, because deferred shots go to it
and committed shots provably preserve an optimum.

## Files and commands

All work is in `ergodis-private`; `/home/tavis/src/ergodis` was not modified. The TigerBlossom
kernel is another agent's and was not touched.

- `/home/tavis/src/ergodis-private/src/certified_predecoder.rs` — the certificate, the window
  analysis, the tier cascade, the brute-force oracle, and the policy compiler.
- `/home/tavis/src/ergodis-private/tasks/tools/src/certified_predecoder_bench.rs` — the
  `certified-predecoder-bench` subcommand.

```
cd /home/tavis/src/ergodis-private
cargo test --release -p ergodis-private --lib -- certified_predecoder
cargo clippy -p ergodis-private -p ergodis-tools --all-targets -- -D warnings
cargo build --release -p ergodis-tools
ergodis-tools certified-predecoder-bench --mode coverage-census --shots 2000
ergodis-tools certified-predecoder-bench --mode tier-census --shots 20000
ergodis-tools certified-predecoder-bench --mode compile-census
ergodis-tools certified-predecoder-bench --mode lut-decode --distance 9 --rate 0.01
```

### The window analysis is `O(T W^2)`, not `O(T W^3)`

The conditional costs `cost(a, b)` for every `(commit parity, seam state)` pair come from **two
forward vector sweeps**, not a matrix product: propagate a vector from the fixed start state through
the commit region, split it by the parity the commit region contributed, then carry each branch
independently to the seam. That is the difference between `O(T W^2)` and `O(T W^3)` and it is what
makes distance 9 (`W = 512`) tractable at all.

## Exactness gates

All eight tests pass.

| Gate | What it establishes |
|---|---|
| `the_window_analysis_agrees_with_brute_force_conditional_costs` | the min-plus `cost(a, b)` table equals exhaustive enumeration over every error pattern, for every syndrome at `d = 3, T = 3` |
| `a_proved_safe_action_preserves_the_minimum_weight_exhaustively` | over **all** 64 syndromes, a certified commit never raises the achievable minimum weight |
| `a_proved_safe_action_preserves_the_logical_outcome_unless_the_classes_tie` | the logical claim, for every syndrome and both commit sizes |
| `the_safety_claim_survives_exhaustive_adversarial_enumeration` | the same, **adversarially**: every syndrome of `(d, T) = (3,3), (3,4), (5,2)` at both commit sizes, including high-weight syndromes a physical rate would essentially never produce |
| `the_bounded_tier_is_measured_not_assumed` | records how often the bounded tier commits where the proved tier does not, and whether it is then unsound |
| `bounded_safety_is_at_least_as_permissive_as_proved_safety` | the bounded intersection always contains the proved one |
| `the_compiled_policy_reproduces_the_analyzer_on_every_syndrome` | the minimized automaton agrees with the analyzer on all `4^3` syndromes |
| `minimization_strictly_shrinks_the_prefix_trie` | minimization does real work |

**The adversarial enumeration is the load-bearing one.** Coverage is measured on sampled syndromes
at a physical error rate, but safety is verified on *every* syndrome the instance admits, so the
safety claim does not rest on the sampling distribution.

At `d = 3, T = 3` the bounded tier never fires: every window is either proved or ambiguous
(`bounded-only windows 0`). The bounded tier only becomes load-bearing at larger distance, where the
census below shows it firing.

*(measurement sections to follow)*

## Certified fast-path coverage

Single-window coverage, 2,000 windows per point, commit region one round, bounded slack 2. The
window is the first `T` rounds of a `T + 1` round history so the seam measurement error is genuinely
free rather than pinned to zero by the generator's terminal perfect round. `forced` counts windows
where exactly one parity is safe, so the commit carries information; `either` counts windows where
both are safe.

| rate | `T` | `d` | clean syndrome | proved | bounded | ambiguous | forced | reachable seams |
|---|---|---|---|---|---|---|---|---|
| 0.001 | 2 | 3 | 0.9885 | 0.9970 | 0.0000 | 0.0030 | — | 4 |
| 0.001 | 2 | 9 | 0.9585 | 0.9915 | 0.0020 | 0.0065 | — | 256 |
| 0.001 | 4 | 9 | 0.9215 | 1.0000 | 0.0000 | 0.0000 | — | 256 |
| 0.01 | 2 | 3 | 0.9045 | 0.9800 | 0.0000 | 0.0200 | 0.9800 | 4 |
| 0.01 | 2 | 5 | 0.8440 | 0.9625 | 0.0000 | 0.0375 | 0.9625 | 16 |
| 0.01 | 2 | 7 | 0.7700 | 0.9425 | 0.0240 | 0.0335 | 0.9425 | 64 |
| 0.01 | 2 | 9 | 0.7045 | 0.9205 | 0.0375 | 0.0420 | 0.9205 | 256 |
| 0.01 | 4 | 9 | 0.4935 | 0.9980 | 0.0015 | 0.0005 | 0.9980 | 256 |
| 0.01 | 6 | 9 | 0.3385 | 0.9985 | 0.0010 | 0.0005 | 0.9975 | 256 |
| 0.05 | 2 | 9 | 0.1880 | 0.6770 | 0.1220 | 0.2010 | 0.6770 | 256 |
| 0.05 | 4 | 9 | 0.0275 | 0.9450 | 0.0255 | 0.0295 | 0.9450 | 256 |
| 0.05 | 6 | 9 | 0.0035 | 0.9885 | 0.0065 | 0.0050 | 0.9830 | 256 |

Three things this says.

**Coverage rises steeply with lookahead.** At distance 9 and 1% physical error the proved tier
covers 92.05% at `T = 2`, 99.80% at `T = 4` and 99.85% at `T = 6`. That is the shape the tier
hierarchy needs: most windows are settled by the shallowest, cheapest policy.

**Certification is not just "the syndrome was clean".** At distance 9, `T = 6`, 5% error only 0.35%
of windows have an all-zero syndrome, yet 98.85% are certified — so the certificate is doing real
work on syndromes with defects in them, not merely recognizing quiet windows. The `forced` column
confirms the commits carry information: essentially every proved window has a *unique* safe parity
rather than both being safe.

**The seam quantification is over all 256 reachable states at distance 9.** Every seam state has a
finite explanation, so the proved tier quantifies over the entire seam alphabet. That is what makes
it a certificate rather than a heuristic.

## The tier cascade

The proper cascade on the same shot: try `T = 2`, and only on `Ambiguous` extend to `T = 4`, then
`T = 6`, then hand to the strong decoder. 20,000 shots per point.

| rate | `d` | settled at `T=2` | at `T=4` | at `T=6` | deferred to the strong decoder | bounded commits (of 20,000) |
|---|---|---|---|---|---|---|
| 0.001 | 3 | 0.99790 | 0.00210 | 0.00000 | **0.00000** | 0 |
| 0.001 | 9 | 0.99635 | 0.00365 | 0.00000 | **0.00000** | 84 |
| 0.01 | 3 | 0.98120 | 0.01880 | 0.00000 | **0.00000** | 0 |
| 0.01 | 5 | 0.96200 | 0.03715 | 0.00080 | **0.00005** | 4 |
| 0.01 | 7 | 0.96060 | 0.03860 | 0.00080 | **0.00000** | 398 |
| 0.01 | 9 | 0.95955 | 0.03950 | 0.00085 | **0.00010** | 781 |
| 0.05 | 3 | 0.91465 | 0.08535 | 0.00000 | **0.00000** | 0 |
| 0.05 | 5 | 0.82805 | 0.15805 | 0.01315 | **0.00075** | 78 |
| 0.05 | 7 | 0.80265 | 0.17060 | 0.02240 | **0.00435** | 1,390 |
| 0.05 | 9 | 0.79465 | 0.17585 | 0.02390 | **0.00560** | 2,944 |

**The strong decoder sees between 0.00% and 0.56% of shots.** At the operating point that matters —
distance 9, 1% physical error — it sees one shot in ten thousand. Everything else is committed by a
compiled policy with a proof attached.

The bounded tier is a small correction, not the story: at distance 9 and 1% it accounts for 781 of
20,000 shots (3.9%), and it can be switched off entirely at the cost of moving those shots to the
next tier or to the strong decoder.

## The compiled policy

Every syndrome of the window is enumerated, decided, and the resulting Moore machine is minimized
with the **probe-13 worklist refinement** seeded by the output value. Two variants: the full policy
(proved plus bounded tiers) and the proved-only policy, which carries no assumption about the future
and therefore keeps overall accuracy identical to the strong decoder by construction.

| `d` | `T` | alphabet | syndromes enumerated | trie states | minimal states (proved+bounded) | minimal states (**proved only**) | table bytes (proved only) | compression |
|---|---|---|---|---|---|---|---|---|
| 3 | 2 | 4 | 16 | 22 | 6 | **6** | 102 | 3.7x |
| 3 | 4 | 4 | 256 | 342 | 11 | **11** | 187 | 31.1x |
| 3 | 6 | 4 | 4,096 | 5,462 | 18 | **18** | 306 | 303.4x |
| 5 | 2 | 16 | 256 | 274 | 9 | **6** | 390 | 45.7x |
| 5 | 4 | 16 | 65,536 | 69,906 | 31 | **29** | 1,885 | 2,410.6x |
| 7 | 2 | 64 | 4,096 | 4,162 | 20 | **6** | 1,542 | 693.7x |
| 9 | 2 | 256 | 65,536 | 65,794 | 90 | **6** | 6,150 | 10,965.7x |

**The certified predecoder for a distance-9 repetition code with two rounds of lookahead is a
six-state automaton occupying 6,150 bytes.** That is the strongest result in this probe: 65,536
distinct syndromes collapse to six behavioural classes, an 11,000-fold compression, and the whole
policy fits in L1 cache. The proved-only variant is *smaller* than the full one at every distance
above 3, because the bounded tier introduces distinctions the proved tier does not need.

The limit is enumeration, not minimization: the syndrome space is `2^((d-1)T)`, so `d = 9, T = 4`
would need `2^32` windows. Extending the compiled cascade past `T = 2` at large distance needs a
spatial locality argument — that a defect far from the commit region cannot change the commit
decision — which is not established here and is the main open item.

*(timed comparison to follow)*

## Instructions per committed round, against PyMatching

### What is being compared, precisely

The predecoder commits **one round's** logical contribution per step, so the honest unit is *one
committed round in a streaming decoder*, not one shot. A sliding-window decoder built on PyMatching
pays one window decode per committed round, which is exactly the quantity measured in the
PyMatching column. Both arms therefore answer "what does it cost to commit the next round".

The strong decoder's arm decodes a **six-round window**, matching the deepest tier, on shots emitted
by the same generator; PyMatching 2.4.0 through a pinned local virtual environment, batch
`decode_batch`, so no Python per-call overhead is charged to it. Eight interleaved rounds, two-size
differencing on both arms, fixed event window, binary
`ergodis-tools` pinned at `bf3b1f55…`.

**The compiled policy is proved-only**: no bounded-tier commits, so a committed round provably
preserves a global minimum-weight solution and deferred rounds go to the strong decoder. Accuracy is
therefore identical to the strong decoder by construction, not by measurement.

### Measured

| `d` | rate | PyMatching per decode | sd | compiled LUT per round | sd | raw ratio | 95% CI | `n` |
|---|---|---|---|---|---|---|---|---|
| 3 | 0.001 | 300 | 10.51% | 86.1 | 0.03% | 3.5x | [3.2, 3.8] | 8 |
| 3 | 0.01 | 672 | 4.56% | 87.7 | 0.02% | 7.7x | [7.4, 8.0] | 8 |
| 3 | 0.05 | 2,273 | 23.61% | 92.8 | 0.03% | 23.5x | [17.7, 31.2] | 8 |
| 5 | 0.001 | 436 | 13.18% | 81.5 | 17.06% | 5.4x | [4.5, 6.5] | 8 |
| 5 | 0.01 | 1,245 | 3.07% | 89.5 | 0.04% | 13.9x | [13.6, 14.3] | 8 |
| 5 | 0.05 | 5,705 | 1.10% | 99.7 | 0.06% | 57.2x | [56.7, 57.8] | 8 |
| 7 | 0.001 | 538 | 3.82% | 64.0 | 0.05% | 8.4x | [8.1, 8.7] | 8 |
| 7 | 0.01 | 1,774 | 3.18% | 62.3 | 3.04% | 28.4x | [27.3, 29.6] | 8 |
| 7 | 0.05 | 8,861 | 0.58% | 63.0 | 3.13% | 140.7x | [136.8, 144.6] | 8 |

**The compiled lookup costs 62 to 100 instructions per round and is essentially flat in both
distance and error rate**, because it is a handful of table transitions through a six-to-29-state
automaton regardless of how big the code is. PyMatching's cost grows with both, from 300 to 8,861
instructions per decode across the same range. That is the shape a compiled policy should have and
the shape a search-based decoder cannot have.

### The composed figure, which is the honest one

The raw ratio above credits the LUT with shots it defers. The deferred fraction still costs a full
strong decode, so the figure to quote is `LUT + defer_rate x PyMatching`, using the measured
proved-only defer rate of the compiled cascade:

| `d` | compiled tiers | table bytes | rate | defer rate | composed cost per round | **composed speedup** |
|---|---|---|---|---|---|---|
| 3 | `T = 2, 4, 6` | 595 | 0.001 | **0.00000** | 86.1 | **3.5x** |
| 3 | `T = 2, 4, 6` | 595 | 0.01 | **0.00000** | 87.7 | **7.7x** |
| 3 | `T = 2, 4, 6` | 595 | 0.05 | **0.00000** | 92.8 | **24.5x** |
| 5 | `T = 2, 4` | 2,275 | 0.001 | 0.00025 | 81.6 | **5.3x** |
| 5 | `T = 2, 4` | 2,275 | 0.01 | 0.00050 | 90.1 | **13.8x** |
| 5 | `T = 2, 4` | 2,275 | 0.05 | 0.01585 | 190.1 | **30.0x** |
| 7 | `T = 2` only | 1,542 | 0.001 | 0.00605 | 67.3 | **8.0x** |
| 7 | `T = 2` only | 1,542 | 0.01 | 0.06315 | 174.3 | **10.2x** |
| 7 | `T = 2` only | 1,542 | 0.05 | 0.24660 | 2,248 | **3.9x** |

**At distance 3 the compiled cascade defers nothing at any error rate**: a 595-byte automaton
replaces the decoder entirely for every shot drawn, at identical accuracy, for 3.5x to 24.5x fewer
instructions. At distance 5 it defers between 1 in 4,000 and 1 in 63 shots. At distance 7 only the
`T = 2` tier could be enumerated, so the defer rate is 6.3% at 1% error and the composed win falls to
10.2x — and at 5% error, where a quarter of shots defer, the win collapses to 3.9x.

**The binding constraint is enumeration depth, not the certificate.** The tier census shows the
`T = 4` and `T = 6` policies would push the defer rate at distance 7 from 6.3% down to 0.08%, which
would take the composed win from 10.2x to roughly 28x; they simply cannot be enumerated, because the
syndrome space is `2^((d-1)T)`. Extending the cascade needs a spatial locality argument — that a
defect far from the commit region cannot change the commit decision — and that is the single highest
value follow-on from this probe.

### Distance 9

The box was heavily contended by concurrent agents during this measurement and only one paired round
completed for distance 9, so it is reported without a confidence interval and marked `n = 1`.

| quantity | value |
|---|---|
| compiled tiers | `T = 2` only |
| minimal states | **6** |
| table bytes | 6,150 |
| defer rate at 1% error | 0.0743 |
| PyMatching per decode | 2,397 (`n = 1`) |
| compiled LUT per round | **63.3** (`n = 1`) |
| raw ratio | 37.9x |
| composed cost per round | 63.3 + 0.0743 x 2,397 = 241.4 |
| **composed speedup** | **9.9x** |

The distance-9 lookup costs 63.3 instructions per round, squarely inside the flat 62 to 100 band the
other distances show, which is what a six-state automaton should cost regardless of code size.

That measurement also illustrates where the work went: the *total* instruction count for the
distance-9 arm is 1.85 trillion, essentially all of it the offline compile that enumerates 65,536
windows at boundary width 512. The two-size differencing removes it exactly, which is the point —
**the expensive part of this route is offline and pays once, and the online part is six states.**

## Provenance tiers, recorded explicitly

| Tier | What was established | Authority granted |
|---|---|---|
| **Proved safe** | The splicing argument above, plus exhaustive verification over *every* syndrome of `(d, T) = (3,3), (3,4), (5,2)` at both commit sizes, that a certified commit never raises the achievable minimum weight and never changes the logical outcome when the class costs differ | commit, no assumption about the future |
| **Bounded safe** | Only that the intersection is nonempty over seam states within a declared slack. `the_bounded_tier_is_measured_not_assumed` found *no* window at `d = 3, T = 3` that needs it, so its soundness is untested there; at larger distance it fires on 0.4% to 15% of shots | commit **only** under a declared fault bound; excluded from every headline number in this report, which is proved-only |
| **Observed confident** | not used in this probe | — |
| **Ambiguous** | the intersection is empty | defer to the strong decoder; no authority |

The one acknowledged gap in the proved tier is the exact-tie case `C_0 == C_1`, where the preserved
optimum may lie in either logical class. That is a shot on which the full decoder is already
guessing, and the exhaustive tests count those cases separately rather than asserting them away.

## Mystery ledger

- **Coverage at `T = 4` and `T = 6` is essentially 1.0 at low error rates, which looked wrong.** It
  is not: the `forced` column shows essentially every certified window has a *unique* safe parity,
  and at distance 9, `T = 6`, 5% error only 0.35% of windows are clean while 98.85% are certified.
  So the certificate is deciding syndromes that contain defects, not merely recognizing quiet
  windows. Settled by adding the forced/either split.
- **The proved-only policy is smaller than the proved-plus-bounded policy** at every distance above
  3 — six states against 90 at distance 9. Adding a weaker tier *adds* behavioural distinctions the
  strong tier does not need. Explained, but the direction is counterintuitive enough to record.
- **Why six states?** The distance-9, `T = 2` policy collapses 65,536 syndromes to six classes, and I
  have not characterized what those six classes *are*. A description of them would likely be the
  spatial locality argument the cascade needs, and is the most promising unexplored lead here.
- **The `T = 2` defer rate at distance 7 and 5% error is 24.7%**, which is where the composed win
  collapses to 3.9x. The tier census says `T = 4` and `T = 6` would take it to 0.44%. Whether the
  deeper tiers can be compiled at all is the open question, not whether they would help.
- Distance 9 has `n = 1` for the timing because of box contention; the structural numbers (states,
  bytes, defer rate) are single-run measurements of deterministic quantities and are not affected.

## Vibe check

Strong, and the strongest result is a compilation number rather than a speed number. The certificate
works: a splicing argument proves that committing an action in the intersection of the per-seam
optimal-witness sets preserves a global minimum-weight solution, and exhaustive adversarial
enumeration over every syndrome of three small instances confirms it. Coverage is high and rises
steeply with lookahead — at distance 9 and 1% physical error the tier cascade sends one shot in ten
thousand to the strong decoder. And the compiled artifact is tiny: **the certified predecoder for a
distance-9 repetition code with two rounds of lookahead is a six-state automaton in 6,150 bytes**,
an 11,000-fold compression of the syndrome space, running in 63 instructions per committed round
against PyMatching's 2,397. The honest composed win, charging the LUT for every shot it defers, is
3.5x to 30x depending on distance and error rate, and it is limited entirely by how deep a cascade
can be *enumerated*, not by the certificate.

## Next steps

1. **Find the spatial locality argument.** Everything is gated on enumerating `2^((d-1)T)`
   syndromes. If a defect further than some distance from the commit region provably cannot change
   the commit decision, the policy factorizes and the deeper tiers compile at every distance. The
   six-state distance-9 automaton is direct evidence that such structure exists; characterizing its
   six classes is the way in.
2. Compile the `T = 4` and `T = 6` tiers at distance 7 and 9 by whatever route locality allows, and
   re-measure: the tier census predicts the composed win goes from 10.2x to roughly 28x at 1% error.
3. Widen the commit region beyond one round and measure whether coverage survives; a larger commit
   amortizes the lookup over more committed rounds.
4. Replace the repetition code with a surface or qLDPC code, where the brief expects automatic
   decoder synthesis to be worth more than it is against a matching-ideal instance.
