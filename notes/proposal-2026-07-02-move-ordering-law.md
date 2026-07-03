# Proposal: Move-ordering → node-count law for alpha-beta on DAGs with TTs (M1)

**Date**: 2026-07-02
**Status**: PROPOSED (plan only)
**Parent**: [solver-theory targets](2026-07-02-solver-theory-targets.md) §4 M1 — survey rank #3.
Companion to [T1 re-expansion law](proposal-2026-07-02-tt-reexpansion-law.md) (shared gated-tap
infrastructure and sweep harness; the two studies interleave).

## The gap

Between Knuth–Moore (perfect ordering, trees) and Baudet/Pearl i.i.d.-leaf asymptotics there
is no published model expressing **expected node count as a function of a measured
cutoff-rank distribution** — and nothing at all in the **DAG + TT** setting, where ordering
additionally determines *which* positions get memoized (Plaat's thesis names the TT omission
"a serious omission"). Killer/history heuristics have essentially no transfer theory
(Akl & Newborn 1977 is the last word). Marsland–Campbell's "strongly ordered" is a label,
not a function.

## The law to fit

`E[expansions] = F(rank distribution, DAG sharing, TT)` built as a per-band branching model:

- Node types = pc bands (the natural strata in this domain). Per band, measure
  `P(cutoff at ordered move k | WIN node)` — the cutoff-rank distribution — and the child
  count distribution. LOSS nodes explore all children (no rank freedom): the model must
  treat the two node classes separately, which the exact-solving setting makes clean
  (no evaluation noise, no windows — pure win/loss alpha-beta is the minimal theory case).
- Tree layer: with measured rank distributions, expected subtree size has a closed
  recurrence per band — derive it (small, real theory kernel; likely provable).
- DAG + TT layer (the new part): ordering changes the probe stream, hence which variant of
  a shared position is expanded first and memoized. Model the TT as a visit-once operator
  over the shared DAG and fit the correction; characterize the deviation from the tree
  formula as a function of the sharing rate (measurable per band).

## The validation set we already own (the moat)

The model must reproduce, from rank distributions alone, the banked ablation measurements:

| ablation                                   | measured effect            |
|--------------------------------------------|----------------------------|
| static → dynamic ordering                  | −34 % nodes (n=16)         |
| + ETC (probe children before recursing)    | −18 % nodes further        |
| forfeiting move order (M_WAVE_B slot-order) | **+94 % nodes**            |
| cross-root killers, depth 1                | −37.6 % nodes (that loop)  |
| deep-history tiebreak (M_DHIST)            | −2.7 % nodes / +16.6 % wall|

An exact-solving DAG with byte-identical A/B discipline and no eval noise is a dataset no
chess-engine study can produce (their orderings interact with windows, extensions, and eval).

## New measurements (cheap, gated)

1. Per-band cutoff-rank histograms under EACH ordering variant (the `M_RANK` rank-report tap
   already exists — extend per-band + per-variant capture).
2. Sharing rate per band (distinct-vs-expansion, from existing distinct instrumentation).
3. Killer-transfer decay: hit-rate of a killer square as a function of root distance /
   ply band (the `KILLER_HITS` tables + root-timing logs already record the raw events).
4. The mirror-reply check (ρ(m)-as-refutation frequency from existing root-timing logs) —
   doubles as the theory thread's offline validation and as a "theory-informed ordering
   prior" datapoint for this paper.
5. Small-n sweeps for model fitting (n=12/13/14, minutes each), reusing the T1 harness.

## First data (2026-07-03, no-compile runs while the G(17) run owned the box)

- **The per-band layer already exists**: `QUEENS_RANK=1` (`M_RANK`) emits the full per-pc
  cutoff-rank histogram (ETC / r0 / r1 / r2 / r≥3 / no-cut with degrees, E/node, loss
  decomposition) — measurement 1's "per-band" half was already built.
- **Per-variant capture needed code**: `M_RANK` hardwires the M_ORD_W base (QUEENS_ORD is
  ignored under the tap — verified empirically: identical node sets across QUEENS_ORD=0/1/2
  under QUEENS_RANK=1). Extension WRITTEN (uncompiled, box owned by G(17)): the `mode_rank`
  family — `M_RANK_O` (M_ORD twin), `M_RANK_WV` (M_WAVE twin), `M_RANK_N` (M_NORMAL twin) —
  selected by the production `ord`/`ord_etc`/`wave` flags, with the plain-descent loop gaining
  the same DCE'd-off tally sites the fused block already had. Compile + byte-identical-off
  gate + n=12 variant captures queued for when the box frees.
- **n=14 rank shape under M_ORD_W** (single-thread, killers off): ETC 1.7 %, r0 23.4 %,
  r1 17.4 %, r2 12.5 %, **r≥3 38.7 %**, no-cut 6.3 %; E/node 5.46, loss/node 3.02. The fat
  r≥3 tail says the ordering is far from exhausted — consistent with the banked ablations.
- **Killer-transfer warning (a finding in itself)**: single-threaded n=14, killers ON costs
  **+6.9 % nodes** (2,806,261 → 2,999,842) — yet production measured −37.6 %. The killer win
  is a **cross-root parallel** phenomenon (replies published by concurrent workers on other
  roots); sequentially the stale-reply pollution outweighs the transfer at n=14. The model's
  killer section must be built in the parallel setting (or the sequential/parallel contrast
  becomes its own result). Also: odd n short-circuits (center-steal) — even boards only.

## Deliverables & venue

Fitted parametric law + tree-layer theorem + DAG/TT correction + killer-transfer section →
ICGA Journal or IEEE Transactions on Games; AAAI/IJCAI search track if the model is strong.
Cite-and-distinguish: Newborn 1977, arXiv 1804.06601, Marsland–Campbell.

## Effort & sequencing

Lowest effort of the starred survey items: mostly existing instrumentation + analysis.
Tap extensions ≈ 1 session; sweeps hours (shared with T1's schedule); modeling + writing
1–2 sessions. Sequencing: after the G(18) rounds (or interleaved in idle windows), sharing
box time with T1 — one combined sweep campaign serves both papers.

## Risks

- A theory group could derive the tree case independently — the defensible core is the
  DAG/TT coupling plus the exact-solving dataset; move the measurement sections early.
- Rank distributions may be strongly band-dependent (they are — that IS the model's shape;
  a failure of a single global law is itself a finding the strata expose).
- Killer-transfer section overlaps CGT-thread interests (mirror-reply) — coordinate so the
  same measurement is written up once, cited twice.
