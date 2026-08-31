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
the *maximum-deficiency* set, which is generally far from minimal. Three things turn it
into a product-quality explanation.

**Decomposition into independent bottlenecks.** The set is first split into the connected
components of the bipartite subgraph it induces with its neighbourhood. Components
partition both the task set and its neighbourhood, so the total deficit is the sum of the
per-component deficits; a component with deficit zero is padding and is dropped, and each
remaining component is reported as its own certificate. This is not cosmetic. On a
three-shortage roster the maximum-deficiency set has 139 tasks and a single irreducible
set would report one padded blob; decomposition returns three certificates of 4, 6 and 9
tasks, each with its own disjoint resource set, and each one on its own proving the
instance infeasible. A roster manager can act on the three independently.

**Fixpoint deletion inside each component.** For each task `t` in the current set, test
whether `S \ {t}` still violates; if so, drop `t` permanently, and repeat until a pass
changes nothing. The fixpoint loop is not optional here, and this is a trap worth naming.
The one-pass deletion filter used for irreducible infeasible subsystems in linear
programming is justified by infeasibility being inherited by supersets. A Hall violation is
not monotone that way — a subset of a non-violating set can violate — so a task passed over
early can become removable after a later removal, and only a pass that changes nothing
proves irreducibility. The prototype produced reducible certificates until this was fixed.

**Explicit removal tests in the output.** For every task in every certificate the JSON
records the post-removal `(demand, capacity)` pair witnessing that dropping it destroys the
violation. Irreducibility is proved by exhibited test, not asserted; `--verify` recomputes
every one of them from the eligibility relation alone.

One caveat stated plainly: irreducible under single-task removal is a weaker property than
smallest. Finding a minimum-cardinality Hall violator is a different and harder problem, and
this tool does not claim to solve it. What decomposition buys is that the common source of
padding — several unrelated shortages fused into one set — is removed structurally rather
than left to a greedy sweep.

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

Five domains. The two realistic ones each carry a knob that plants a violation of known
size and known membership, plus a second knob that inflates the maximum-deficiency set
without changing the answer, so minimization has something real to do:

- `roster` — shifts with a required qualification, nurses holding qualification sets and a
  maximum shift count. The feasible core is built by drawing a valid assignment first and
  taking eligibility as a superset of it, so the base is feasible by construction.
- `placement` — jobs requiring an accelerator class and a memory footprint, hosts with a
  class and a slot capacity, capacities above one throughout.
- `multi-roster` — the same roster carrying three independent shortages of sizes `k`,
  `k + 2` and `k + 5`. This is the case that separates a single unsatisfiable core from a
  decomposed explanation.
- `coupled` — row sums, column sums and all pairwise inner products together. Must be
  declined.
- `distinct-roster` — every shift needs two *distinct* nurses. Must also be declined; see
  the boundary section below.

The planted block is `k` scarce tasks eligible only to scarce resources of total capacity
`k - 2` plus one bridge resource of capacity 1. The bridge is pinned by a chain
`chain_j ~ {bridge_j, bridge_{j+1}}` whose last link sees only the last bridge, so the
chain's matching is forced from the far end inwards and the bridge is never free. Two
consequences are checked on every generated instance rather than assumed: the unique
irreducible certificate is exactly the `k` scarce tasks, because dropping any one leaves
demand `k - 1` against capacity `k - 1`; and the alternating-reachable set has size
`k + cascade`, because reachability walks the whole chain. On the `k = 9`, cascade 40
roster that is a 49-task raw set reduced to the 9 planted tasks; on the three-shortage
roster with cascade 40 it is 139 raw tasks reduced to 4 + 6 + 9.

The ground truth emitted inside each instance file — planted tasks per block, planted
resources, expected certificate size, expected raw set size, bottleneck count — is what
certificate quality is measured against, rather than the tool's own output.

### Where the tool stops, stated exactly

The sharpest boundary found in this work is not the exotic one. `demand` counts
resource-*units*, and units of one task may come from the same resource more than once — a
job taking three slots on one host. The moment a task instead needs `demand` **distinct**
resources — "this shift needs three different nurses", the most common real roster shape
there is — Hall's condition stops being sufficient. One task of demand 2 against one
resource of capacity 5 passes every task-side Hall test and is infeasible. That is an
`x_tr <= 1` upper bound on top of the capacities, which makes the problem a
degree-constrained subgraph problem whose certificate is a cut naming both a task set and a
resource set. The tool classifies such instances as `degree_constrained_completion` and
declines. Any product in this space must either solve that case properly or say plainly
that it does not.

## Correctness evidence

`certiis selftest` is the acceptance gate for the extractor itself and runs in under a
second:

```bash
cd ~/src/othello/ergodis-private
cargo test  --release --bin certiis     # 6 unit tests
cargo build --release --bin certiis
./target/release/certiis selftest
```

It checks four things.

1. **Exhaustive cross-check on small random instances.** 4000 random capacitated instances
   with up to 6 tasks and 5 resources, demands 1-2 and capacities 1-3. Each one is decided
   by brute force over *every* task subset against the defect-Hall condition, and the tool's
   verdict must agree — 1392 feasible, 2608 infeasible in the fixed seeded run. Every
   certificate is then re-verified by the independent verifier. A wrong maximum matching, a
   wrong projection through the unit expansion, or a reducible certificate all fail here.
2. **Planted ground truth.** For every seed and every `(plant, cascade)` setting in
   `(4,0)`, `(4,40)`, `(9,40)`, `(17,120)`, across both realistic domains, the returned
   certificate must equal the planted task set exactly — not merely have the right size —
   and the pre-minimization maximum-deficiency set must have exactly the predicted size
   `plant + cascade`.
3. **Independent shortages stay separated.** Three-shortage rosters must return exactly
   three certificates, and the multiset of certificate task sets must equal the multiset of
   planted blocks.
4. **Declines.** The coupled instance (row sums, column sums, all pairwise inner products),
   the exact-resource-load instance, and the distinct-resources roster must each be
   declined, with a non-empty statement of what is needed instead.

The unit tests add a two-bottleneck instance with a hand-checked expected answer, a
capacitated feasible/infeasible pair, both decline paths, and a tampering test: a
certificate with an extra task appended is rejected by `--verify` as reducible.

Independent verification is genuinely independent. `certiis verify` reloads the instance,
recomputes the SHA-256 digest and refuses a certificate produced for different bytes,
re-runs the classifier, recomputes each neighbourhood from the eligibility pair list alone,
recomputes demand and capacity, redoes every removal test, and checks that the certificates
are pairwise disjoint in tasks and in resources. It shares no code path with the extractor
and never touches `hall_core`.

## Benchmark

*(filled in as they land)*

## What would make this a real product

*(filled in as they land)*

## Requests against `hall_core` (not implemented, read-only constraint)

*(filled in as they land)*
