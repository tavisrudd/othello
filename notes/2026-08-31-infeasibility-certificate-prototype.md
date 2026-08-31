# Explainable infeasibility for assignment and scheduling — prototype

**Date**: 2026-08-31
**Scope**: commercial prototype, not a math task. All work confined to
`ergodis-private/src/bin/certiis.rs` and `ergodis-private/python/certiis_benchmark.py`.
No edit to the Ergodis core, to `ergodis-private/src/lib.rs`, `Cargo.toml`, or
`src/hall_core.rs`.

## Product thesis

Every commercial optimizer answers an over-constrained roster with `INFEASIBLE` and leaves
a human to bisect by hand. The Hall matching machinery already in this repository can
return the *reason*: a minimal set of tasks whose eligible resources are too few, together
with those resources. The differentiator is not the matching — it is that the tool knows
which problems it may legitimately answer and declines the rest by name.

## Design

### Instance model

One JSON schema, `certiis-instance/v1`:

```json
{
  "schema": "certiis-instance/v1",
  "name": "roster-...",
  "tasks":     [{"id": "shift_mon_am", "demand": 1}],
  "resources": [{"id": "nurse_alice",  "capacity": 3}],
  "eligible":  [["shift_mon_am", "nurse_alice"]],
  "couplings": []
}
```

`demand` is how many resource-units the task consumes; `capacity` is how many task-units a
resource can serve. `couplings` carries the extra structure that takes an instance out of
the matching regime (row sums, column sums, pairwise inner products, task conflicts).

### Classifier — the regimes

| Regime | Trigger | Verdict |
|---|---|---|
| `bipartite_matching`             | all demands 1, all capacities 1, no couplings | certify |
| `capacitated_matching`           | demands or capacities > 1, no couplings       | certify |
| `degree_constrained_completion`  | any exact resource-side load (`resource_exact_load`) or prescribed column sums | decline |
| `quadratically_coupled`          | any pairwise inner-product or task-conflict coupling | decline |

The boundary is stated exactly, because it is where the honesty of the product lives:

- Task-side *exact demands* plus resource-side *upper bounds* only. Feasibility is a
  max-flow on `source -> task (d_t) -> eligible resource (inf) -> sink (c_r)`. Min-cut
  equals `min_{S subset T} [ demand(T) - demand(S) + capacity(N(S)) ]`, so the instance is
  feasible **iff** `demand(S) <= capacity(N(S))` for every task set `S`. A violating `S`
  with its neighbourhood is therefore a complete and sufficient explanation. This is the
  defect form of Hall's theorem and it is what the tool certifies.
- Add resource-side *lower* bounds (every nurse must work exactly `c` shifts, prescribed
  column sums) and feasibility becomes a degree-constrained subgraph / transportation
  problem. Hall's condition stays necessary but stops being sufficient, and the minimal
  explanation can be a cut on the resource side that no task set names. The tool declines
  and names Gale-Ryser and the Gale supply-demand (flow feasibility) theorem as what is
  needed instead.
- Add pairwise coupling between tasks — inner products, conflict pairs, "these two shifts
  may not share a nurse" written as a quadratic rather than as an eligibility restriction —
  and the problem is a degree-constrained matrix completion. This is precisely the failure
  mode C1018 recorded (`notes/2026-08-30-c1018-hunt-plane12.md`, "Ergodis interface
  notes"): forcing Hall onto it yields a decorative rather than a load-bearing certificate.
  The tool declines outright.

### Minimal-certificate extraction

`hall_core::HallWorkspace::solve` returns the alternating-reachable deficient left set —
the *maximum-deficiency* set, which is generally far from minimal. Irreducibility is
obtained by an explicit single-removal sweep over that set: for each task `t` in the
current certificate, test whether `S \ {t}` still violates; if so, drop `t` permanently.
The result is irreducible by construction, and the JSON records, for every surviving task,
the post-removal `(demand, capacity)` pair witnessing that the violation is destroyed. That
is a proof by explicit removal test, not an assertion.

### Capacities via `hall_core` unchanged

`hall_core` has no capacity concept, so the capacitated instance is expanded to unit
copies: `d_t` copies of each task, `c_r` copies of each resource, copies inheriting the
eligibility relation. Two closure facts make the projection back to the task level exact.
Copies of one task have identical neighbourhoods, so the alternating-reachable left set is
a union of whole task-copy classes; the reached right set is `N` of that, hence a union of
whole resource-copy classes. Therefore `demand(S) = |L*| > |R*| = capacity(N(S))`. The
price is an expansion of size `sum(d) x sum(c)`, which is the first item on the `hall_core`
request list below.

### Generators

Two domains, each with a knob that plants a violation of known size and known membership:

- `roster` — shifts with a required qualification, nurses holding qualification sets and a
  maximum shift count. The knob plants `k` shifts requiring a rare qualification held by
  nurses with total capacity `k - 1`.
- `placement` — jobs requiring an accelerator class and a memory footprint, hosts with a
  class and a slot capacity. The knob over-subscribes one host class.

Ground truth (the planted task set) is emitted with the instance so certificate quality is
measured against it rather than against itself.

## Results

*(filled in as they land)*

## Benchmark

*(filled in as they land)*

## What would make this a real product

*(filled in as they land)*

## Requests against `hall_core` (not implemented, read-only constraint)

*(filled in as they land)*
