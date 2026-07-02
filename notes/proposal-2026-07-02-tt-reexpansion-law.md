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

## Risks

- "Fits one domain" reviews — mitigated by the Othello/Connect-4 replay.
- Confounds (thermal, cross-CCX, zram) — the existing bench discipline (interleaved A/B,
  box hygiene protocol) is the mitigation and is itself part of the paper's methodology
  section.
- The branching model may be too coarse near the transition (correlated evictions) — a
  finding either way; the phase-transition characterization stands on the data.
