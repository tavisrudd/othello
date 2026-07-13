# Proof-carrying backtests and assumption distance

Status: exploratory paper agenda  
Primary source: `RIFF_208`–`RIFF_210`, `RIFF_213`, `RIFF_224`  
Scope boundary: reproducibility and falsification, not a claim of future profitability

## Mathematical spine

- [`MATH_18`](math.md#math_18--specification-family-transversal-and-assumption-reversal-distance) —
  specification-family transversals and minimum-cost assumption reversal witnesses.

## Thesis

Backtest robustness has two separable layers: exact reproducibility of the declared computation and
stability of the conclusion under plausible research assumptions. A proof-carrying backtest can
certify the first; assumption distance and strategy-family transversals can expose fragility in the
second.

## Minimum publishable contribution

1. Specify a compact replay artifact covering data vintage, universe construction, features,
   corporate actions, trades, costs, and result hashes.
2. Define assumption distance: the least-cost declared-assumption change reversing a target
   conclusion.
3. Define the transversal of a strategy family: the smallest shared explanation or exposure
   intersecting every apparently successful variant.
4. Validate the framework on deliberately constructed and public historical examples without
   presenting a new trading recommendation.

## Research agenda

### Phase 1 — Trust boundary

- Enumerate what can be certified: provenance, transformations, replay, arithmetic, and rule
  conformance.
- State what cannot be certified: the return-generating model, future profitability, or the truth of
  economic assumptions.
- Choose an exact point-in-time data format with explicit correction policy.

### Phase 2 — Assumption language

- Universe and survivorship policy.
- Filing-availability timestamp.
- Corporate-action and delisting treatment.
- Rebalance timing and execution price.
- Spread, impact, borrow, and capacity model.
- Missing-value and stale-feature policy.

Attach weights or partial orderings to assumption changes rather than pretending every edit is
equally plausible.

### Phase 3 — Exact benchmark

- Construct small strategies with known single-assumption failure modes.
- Reproduce one or more public canonical factor-style backtests at modest scale.
- Generate specification families and calculate their common transversals.
- Compare parameter-count robustness with shared-explanation robustness.

### Phase 4 — Independent verification

- Separate the high-performance runner from a small deterministic checker.
- Hash every input partition and intermediate semantic table.
- Differential-test at least two implementations on the small benchmark.

## Paper spine

1. **Introduction:** reproducible is not assumption-robust, and vice versa.
2. **Backtest semantic model:** data vintages, transformations, trades, and costs.
3. **Replay certificates:** artifact format and independent checker.
4. **Assumption distance:** definition, algorithms, and witnesses.
5. **Strategy-family transversals:** detecting one shared explanation behind many variants.
6. **Benchmark:** synthetic controls and small historical case studies.
7. **Failure analysis:** what common robustness plots miss.
8. **Limits:** no formal guarantee of external validity or future returns.

## Shallow literature and novelty check

Closest precedents found:

- Steegen et al. introduced multiverse analysis over alternative defensible data-processing choices:
  [Increasing Transparency Through a Multiverse Analysis](https://doi.org/10.1177/1745691616658637).
- Simonsohn, Simmons, and Nelson introduced specification-curve analysis over reasonable analytic
  specifications: [Specification curve analysis](https://doi.org/10.1038/s41562-020-0912-z).
- Bailey et al. study selection-induced backtest overfitting:
  [The Probability of Backtest Overfitting](https://doi.org/10.21314/JCF.2016.322).

Preliminary verdict: **crowded, with a narrow possible synthesis contribution**. Reproducibility,
backtest overfitting, and multiverse robustness are established. Remaining novelty would have to be
the combination of a machine-checkable semantic replay artifact with (i) a minimum-cost witness of
conclusion reversal and (ii) a transversal exposing assumptions shared by every successful
specification. “Proof-carrying” must mean more than containers, hashes, and deterministic reruns.

Required deeper audit:

- executable-paper and data-provenance systems in empirical finance;
- specification robustness metrics that already optimize a minimum change;
- formal semantics or verified implementations of financial backtests.

## Kill criteria

- Existing reproducible-finance systems already provide the complete claimed artifact and
  assumption analysis.
- Results depend on inaccessible proprietary data or cannot be legally redistributed.
- Assumption distance collapses to an arbitrary analyst-selected metric with no useful invariance.
- The evaluation cannot demonstrate value beyond exact rerun plus a conventional specification
  curve.
