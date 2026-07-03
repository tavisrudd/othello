# Proposal: Re-expansion vs TT load factor — an empirical law + analytic model (T1)

**Date**: 2026-07-02
**Status**: PROPOSED (plan only)
**Parent**: [solver-theory targets](2026-07-02-solver-theory-targets.md) §1 T1 — survey rank #2;
the fast "data paper" companion to the certificate program
([stage-1 plan](proposal-2026-07-02-certified-nimbers-stage1.md)).

## The claim to establish

A predictive model `R(ρ, policy)` — re-expansion factor as a function of oversubscription
ratio (distinct working set ÷ TT slots) and replacement policy — for DFS-with-memoization on
game DAGs, including the observed **thrash→converge phase transition** and **band-skipping**
as the model's predicted control knob. No such model exists (survey anchor fact 2); nearest
neighbors are Denning working sets and Young's loose competitiveness, neither applied to
search. Template for acceptance: the Gomes et al. heavy-tails line (abstract model + measured
curves).

## The model candidate (to be fit, then stress-tested)

Re-expansion as a **branching process**: a TT miss on a previously-solved position triggers a
recompute whose own probes may miss again. Effective reproduction number
`κ = P(entry evicted before reuse) × E[child re-probes per recompute]`.
- `κ < 1`: re-expansion converges to a finite factor `R = 1/(1−κ)`-style correction — the
  regime of every n ≤ 16 run (R ≈ 1.0–1.25 measured).
- `κ ≥ 1`: divergence = the observed n=18 un-skipped THRASH.
- **Band-skipping** removes the highest-churn band from the store: it lowers eviction
  pressure on the retained bands (drops `P(evicted before reuse)`) at the cost of a bounded
  deterministic recompute — the model must reproduce the measured skip[18,25] flip from
  thrash to convergence, and skip18's small-n net-positive.
- `P(evicted before reuse)` under always-replace hashing is computable from the **reuse-
  distance distribution** of the DFS probe stream — measurable with a gated tap, and the one
  quantity that carries the DAG's structure into the model.

## Why this team, uniquely

- The only known dataset spanning ρ ≈ 0.1 (n=16 @ 12 GB, ~8 % fill) to ρ ≈ 100–200×
  (n=18), including the thrash→converge intervention, with re-expansion ratios tracked as a
  correctness gate for weeks and a byte-identical A/B discipline.
- Ready-made policy comparisons: always-replace (production), depth-preferred (the parked
  `chunk3-depth-preferred-tt` branch — measured 3× worse: a datapoint contradicting
  chess-folklore defaults, which the model should explain), set-associative buckets (the
  parked `queens-tt-assoc-buckets` branch — built precisely for the oversubscribed regime
  this study sweeps).

## Experimental design

1. **Gated taps** (production byte-identical off, per the M_* pattern): reuse-distance
   histogram of TT probes (per pc band); eviction-before-reuse counters; per-band re-hit
   rates. One session of engineering.
2. **The sweep**: fixed n, TT size swept over powers of two (`QUEENS_TT_BITS` ≈ 18..30) —
   n=12/13/14 primary (minutes per point; wall-capped for diverging points), partial-n=16
   spot checks. Each point: R, wall, κ-components. Policies: always-replace + the two parked
   branches (revived read-only for measurement). Band-skip on/off at each ρ.
3. **Fit + validate**: fit the branching model's κ from reuse distances alone, PREDICT R(ρ),
   compare against the measured curve (held-out points); predict the skip flip.
4. **Generality replay** (the reviewer-proofing): the Othello solver in this repo (same TT
   machinery, different game), plus one public domain (Connect-4-class) if needed.

## Deliverables & venue

Model + fitted law + intervention validation → SoCS or ICGA Journal; JAIR if the model
generalizes cleanly. Optional theory corollary (competitive analysis of replacement with
recomputation costs, T2) only if the stochastic model suggests a clean statement — T2's
adversarial version likely vacuous (one eviction can cost exponential re-search).

## Effort & sequencing

Instrumentation ≈ 1 session; sweeps are hours of box time (schedulable around/after the
G(18) rounds — small-n points fit in spare RAM next to nothing else); modeling + writing
1–2 sessions. **No new large solves required.** Natural slot: while G(18) k-rounds run
days-scale, the n ≤ 14 sweep points interleave in idle windows only if memory headroom
allows; otherwise straight after.

## First data (2026-07-03, no-compile sweep while the G(17) run owned the box)

Measured with the EXISTING binary (`iso-flat --distinct`, `QUEENS_TT_BITS` swept), single-
threaded (deterministic node counts), niced + pinned to efficiency cores next to the running
17 GB G(17) round — valid because R = nodes ÷ distinct is a node-count ratio, immune to the
contention/thermal confounds that make wall times on a busy box garbage.

**n=12 curve** (distinct 1,060,823 exact; ρ = distinct ÷ 2^bits):

| bits | ρ      | R     | recomputed | fill   |
|------|--------|-------|------------|--------|
| 24   | 0.06   | 1.25  | 20.2 %     | 2.9 %  |
| 20   | 1.0    | 1.28  | 21.9 %     | 37.3 % |
| 18   | 4.0    | 1.37  | 26.8 %     | 84.9 % |
| 16   | 16     | 1.54  | 35.2 %     | 99.9 % |
| 14   | 65     | 1.70  | 41.2 %     | 100 %  |
| 12   | 259    | 1.85  | 46.0 %     | 100 %  |
| 8    | 4143   | 2.05  | —          | 100 %  |
| 4    | 66k    | 2.33  | —          | 100 %  |
| 2    | 265k   | 2.39  | —          | 100 %  |

**Two load-bearing findings:**

1. **No knee, no divergence — graceful degradation all the way to a 4-slot table.** The
   always-replace TT at n=12 has no thrash transition; R grows smoothly ≈ logarithmically
   in ρ across seven orders of magnitude.
2. **The ceiling is finite and small: R∞(12) ≈ 2.4–2.5.** With effectively no TT the search
   only unfolds the DAG ~2.4×, because recompute chains bottom out at the complete ≤7 DP
   leaves within a few plies. The TT's whole value at n=12 is ≈ 2×.

**n=14 curve** (iso-flat distinct ≈29.2M; same method):

| bits | ρ     | R     | recomputed |
|------|-------|-------|------------|
| 26   | 0.43  | 1.04  | 3.4 %      |
| 24   | 1.7   | 1.13  | 11.8 %     |
| 22   | 7.0   | 1.38  | 27.7 %     |
| 20   | 28    | 1.65  | 39.5 %     |
| 18   | 111   | 2.13  | 53.2 %     |
| 16   | 446   | 2.54  | 60.7 %     |
| 15   | 891   | 2.73  | 63.4 %     |
| 12   | 7.1k  | 3.93  | 74.6 %     |
| 10   | 28k   | 5.79  | 82.7 %     |

Same graceful no-knee shape — but the ceiling has NOT flattened by bits=10 (tiny-bits probe
in flight): **R∞(12) ≈ 2.45 while R∞(14) ≥ 5.8 and climbing**. The unfold ceiling grows
super-linearly in n — the quantitative mechanism that turns "graceful degradation at n ≤ 14"
into the n=18 budget wall. Method note: odd n short-circuits to the center-steal mirror
strategy (0 search nodes) — the sweep set is even boards only.

**Model reframing forced by the data:** R(ρ) interpolates between R₀(n) (the fully-memoized
re-expansion floor, the labelled-≤7-key trade ≈ 1.25 at n=12) and a **finite** ceiling
R∞(n) = the leaf-table-bounded tree/DAG unfold ratio. There is no κ ≥ 1 divergence in the
mathematical sense — what explodes with n is **R∞ itself** (transposition saturation at
pc 13–21 makes the n=18 unfold astronomical). The observed n=18 "thrash" is a **budget wall**:
the operating point slid toward an R∞ measured in weeks. Band-skipping's mechanism is then
per-band: skip[18,25] zeroed the eviction churn generated by the highest-volume band (whose
own recompute cost is bounded — children are getK leaves) to keep the deep-recompute bands'
operating point near R₀. The model to fit becomes per-band:
`R_b = f(eviction pressure on band b, recompute cost C_b)`, with C_b the quantity that
diverges in n and reuse distance the quantity that carries ρ. The reuse-distance tap
(experiment 1) remains the missing measurement; the sweep harness + n=13/14 curves are in
flight, same method.

## Risks

- "Fits one domain" reviews — mitigated by the Othello/Connect-4 replay.
- Confounds (thermal, cross-CCX, zram) — the existing bench discipline (interleaved A/B,
  box hygiene protocol) is the mitigation and is itself part of the paper's methodology
  section.
- The branching model may be too coarse near the transition (correlated evictions) — a
  finding either way; the phase-transition characterization stands on the data.
