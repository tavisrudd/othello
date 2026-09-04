# C1061 probe 25: soft output, the complementary gap

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 25, route 4 of `notes/2026-09-03-c1061-qec-redirect-brief.md`.
**Verdict**: the gap is **exact and free at the margin** — one composition yields both logical-class
costs, agreeing with PyMatching on 20,000 of 20,000 shots at every distance — but the framework's
composition is so much dearer than a matching decode that **PyMatching's two-decode gap is still 6x
to 12x cheaper**. The soft-output advantage is real and structural, and latent rather than
competitive.

## What was asked

The framework already computes the minimum cost in both logical classes, so the complementary gap
`Delta(s) = C_1(s) - C_0(s)` is free. Emit it, benchmark against PyMatching's gap on instructions
per shot and agreement of the gap, and sketch the `k` logical qubit case.

## PyMatching has no `decode_gap`, so the baseline had to be built

PyMatching 2.4.0 exposes `decode_batch(..., return_weights=True)`, which returns the weight of the
solution it chose, and `decode(..., return_weight=True)`. **There is no `decode_gap` method** in this
version — checked directly against the installed package, not assumed. The complementary gap
therefore needs the standard construction: augment the check matrix with **one extra row carrying the
logical observable**, then decode twice, forcing that row to 0 and to 1. Each decode returns the
minimum weight in one logical class, and their difference is the gap.

That is what the baseline does, and it is the fair comparison: it is the cheapest exact way to get
the same quantity out of a matching decoder.

## Agreement: exact on every shot

Four-round windows, 20,000 shots per point, 1% physical error, comparing our both-class costs against
the augmented two-decode.

| `d` | detectors | shots | class 0 exact | class 1 exact | **gap exact** | hard decision agrees | mean absolute gap |
|---|---|---|---|---|---|---|---|
| 3 | 8 | 20,000 | 20,000 | 20,000 | **20,000** | 20,000 | 2.72 |
| 5 | 16 | 20,000 | 20,000 | 20,000 | **20,000** | 20,000 | 4.51 |
| 7 | 24 | 20,000 | 20,000 | 20,000 | **20,000** | 20,000 | 6.33 |

**Every shot, every distance: identical.** Not merely the hard decision and not merely the gap, but
both class costs individually. The framework's soft output is the same object a matching decoder
produces, computed a different way.

`the_soft_output_matches_brute_force_on_both_classes` independently checks both class costs against
exhaustive enumeration over every error pattern at `d = 3`, and
`a_zero_gap_is_exactly_the_tie_the_predecoder_flags` confirms that a zero gap is exactly the
`C_0 == C_1` tie that probe 23 identified as the one gap in its safety claim — the two probes agree
on what an ambiguous shot is.

## Timing: the framework loses

Eight interleaved rounds, two-size differencing, fixed shot window, four-round windows.

| `d` | rate | Ergodis gap (one composition) | sd | PyMatching gap (two decodes) | PyMatching hard (one decode) | **PyMatching gap / Ergodis** | 95% CI | gap / hard |
|---|---|---|---|---|---|---|---|---|
| 3 | 0.001 | 48,558 | 0.01% | 7,731 | 396 | **0.16x** | [0.15, 0.17] | 19.8x |
| 3 | 0.01 | 48,558 | 0.01% | 7,819 | 898 | **0.16x** | [0.16, 0.16] | 8.8x |
| 3 | 0.05 | 48,554 | 0.01% | 9,258 | 2,482 | **0.19x** | [0.19, 0.20] | 3.7x |
| 5 | 0.001 | 114,772 | 0.01% | 12,977 | 641 | **0.11x** | [0.11, 0.11] | 20.4x |
| 5 | 0.01 | 114,767 | 0.01% | 14,012 | 1,569 | **0.12x** | [0.12, 0.12] | 9.1x |
| 5 | 0.05 | 114,762 | 0.01% | 19,507 | 5,584 | **0.17x** | [0.17, 0.17] | 3.5x |
| 7 | 0.001 | 235,789 | 0.01% | 18,124 | 951 | **0.08x** | [0.08, 0.08] | 19.1x |
| 7 | 0.01 | 235,774 | 0.02% | 20,201 | 2,229 | **0.09x** | [0.08, 0.09] | 9.1x |
| 7 | 0.05 | 235,769 | 0.01% | 30,578 | 8,668 | **0.13x** | [0.13, 0.13] | 3.5x |

A ratio below 1 means the framework is slower. **It is slower by 6x to 12x**, and the gap widens with
distance because its cost grows with the boundary width while PyMatching's grows with the defect
count.

Two things are nonetheless worth extracting.

**The gap costs the framework exactly nothing at the margin.** `class_scores` returns both entries of
the composed root; the hard decision is their argmin. There is no separate path to time, because
there is no separate computation. Its marginal cost is zero by construction, not by measurement.

**The gap costs a matching decoder a great deal.** The last column is PyMatching's own gap against its
own hard decode: **3.5x at 5% error, 9x at 1%, and 19x to 20x at 0.1%**. Soft output is not a cheap
add-on for blossom — the augmented graph is larger and forcing the observable row makes the matching
strictly harder, and the penalty is worst exactly in the low-error regime a real device operates in.
So the structural advantage the brief hoped for is real; it is simply swamped by a hard-decision cost
that probes 13 and 17 already measured as 15x to 82x adrift.

**Stated plainly**: if the framework's hard decision were competitive, free soft output would be a
decisive advantage, because the competitor pays up to 20x for the same information. It is not, so the
advantage stays latent.

## The `k` logical qubit case

The framework's boundary label already carries one logical bit — the width `2^d = 2^(d-1) * 2` is the
syndrome part times that bit — so `k = 1` is free and the question is what each additional logical
qubit costs. Widening the label to `l in F_2^k` multiplies the boundary width by `2^(k-1)` and
composition, being `O(W^3)`, by `8^(k-1)`. A matching decoder instead pays `2^k` constrained decodes
for all class costs, or `4^k` for all pairwise gaps.

| logicals | classes | matching decodes (all costs) | matching decodes (all pairwise gaps) | widened width at `d = 5` | composition factor |
|---|---|---|---|---|---|
| 1 | 2 | 2 | 4 | 32 | **1x** |
| 2 | 4 | 4 | 16 | 64 | 8x |
| 3 | 8 | 8 | 64 | 128 | 64x |
| 4 | 16 | 16 | 256 | 256 | 512x |
| 6 | 64 | 64 | 4,096 | 1,024 | 32,768x |

**The widening loses from `k = 2` onward**, and loses badly: at three logical qubits it costs 64x the
composition to avoid 8 decodes. This is a **negative for the brief's hope** that the quotient
machinery differentiates on multiple logical qubits — under the obvious widening it does not, because
composition is cubic in the boundary while re-decoding is linear in the class count. The only place
it wins is `k = 1`, where the logical bit is already in the label and costs nothing.

The one route that might survive is not widening but *factorizing*: if the `k` logicals are supported
on regions that the decomposition separates, each could carry its own one-bit label in its own
subtree, giving all `k` gaps at `k` times the base cost rather than `8^(k-1)`. Whether a real
multi-logical layout separates that way is unexamined and is the honest next question. It is a
sketch; nothing here measures it.

## Gates

Three tests in `/home/tavis/src/ergodis-private/src/soft_output.rs`, all passing:

| Gate | What it establishes |
|---|---|
| `the_soft_output_matches_brute_force_on_both_classes` | both class costs and the gap equal exhaustive enumeration over every error pattern at `d = 3` |
| `a_zero_gap_is_exactly_the_tie_the_predecoder_flags` | a zero gap holds exactly when the brute-force class costs tie, tying this probe to probe 23's one acknowledged exactness gap |
| `the_logical_scaling_sketch_is_arithmetically_consistent` | the `k`-logical model, including that `k = 1` is free |

## Files and commands

```
cd /home/tavis/src/ergodis-private
cargo test --release -p ergodis-private --lib -- soft_output          # 3 passed
ergodis-tools soft-output-bench --mode emit-gaps --distance 5 --rounds 4 --rate 0.01 --shots 20000
ergodis-tools soft-output-bench --mode gap-timed --distance 5 --rounds 4 --rate 0.01
ergodis-tools soft-output-bench --mode scaling --distance 5
.venv25/bin/python gap25.py accuracy g_d5_r0.01.txt
```

- `/home/tavis/src/ergodis-private/src/soft_output.rs`
- `/home/tavis/src/ergodis-private/tasks/tools/src/soft_output_bench.rs`
- `scratchpad/p25/gap25.py` — the augmented-graph two-decode baseline.

## Mystery ledger

- **PyMatching's gap penalty is worst at low error rates** (20x at 0.1%, 3.5x at 5%). The hard decode
  gets cheap when there are few defects, but forcing the observable row keeps a floor under the
  constrained decode, so the ratio blows up. That is the regime a real device runs in, and it is the
  strongest argument for soft output being worth architectural attention — from the *competitor's*
  cost curve, not ours.
- **The certified predecoder gives a hard decision in 63 instructions but no gap.** Probe 23's
  automaton emits `commit | defer`, discarding the cost information the analysis computed. A
  certified *gap* — a compiled policy that emits a confidence band rather than a bit — is the obvious
  synthesis of routes 1 and 4 and is not built.
- **The `k`-logical widening model assumes one monolithic boundary.** The factorized alternative
  sketched above could change the verdict and is unexamined.

## Vibe check

Honest and mostly negative, with one genuinely useful measurement about the competitor. The gap is
exact — 20,000 of 20,000 shots matching PyMatching on both class costs at three distances — and free
at the margin, which is exactly what route 4 claimed. But the framework's composition is 6x to 12x
dearer than two matching decodes, so the free-soft-output advantage never gets to pay off, and the
`k`-logical widening loses from two logical qubits onward. The result worth carrying forward is the
last column of the timing table: **soft output costs sparse blossom 3.5x to 20x its hard decode, worst
at low error rates.** Anything that produces a gap cheaply has a real advantage to sell; this
framework simply is not yet the thing that produces it cheaply.
