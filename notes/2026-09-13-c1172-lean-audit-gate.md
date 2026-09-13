# C1172 — Lean audit gate, library root, and the round convention pinned

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: COMPLETE. Closes review items R1–R4 of
`2026-09-12-c1171-rule-programme-review.md` and lands the boundary properties
P1, P2, P5 and P6 of that review.

## Verdict

1. **The axiom audit is now a build gate.** Every `#print axioms` in the six
   audit modules and the inline block of `FiniteLoweringChecks` is wrapped in
   `#guard_msgs` with its exact expected message. A negative control with one
   wrong expected line fails elaboration. No terminal depends on `sorryAx` or
   any native-evaluation axiom; the observed axiom sets are `propext`,
   `Quot.sound` and `Classical.choice` only.
2. **One target builds the library.** `lean/WeightedRules.lean` imports every
   audit module and the round-convention family. It is not in the Lake
   `defaultTargets`, by Tavis's instruction during the task: the library is to
   stay separate from the rest of the Lean tree and eventually move to the
   core or private Ergodis repository, and a default target would also make a
   bare `lake build` depend on the external producer library.
3. **The chain witnesses are audited and the dead definition is live.**
   `chainDistanceBaseline`, its values theorem, and the new warm replay
   `chainDistanceImproved` (two synchronous steps from the baseline) with its
   values theorem are printed in `OutputConvergenceAxiomAudit`. The previously
   unreferenced `chainDistanceImprovedProgram` is now the target of that
   replay, which is what the module docstring already described. The four
   unprinted constructions named by the review (`boundedMinPlusCertificate`,
   `iteratedCheckedSolution`, `ruleOutputCertificate`,
   `EventLowering.CheckedLowering.square`) are printed as well.
4. **The Lean/Rust round convention is stated and pinned.** The core
   `docs/rule-contract.md` now states that the producer's sweep count, which
   includes the final unchanged sweep, equals the least index at which the
   formal synchronous iterate from the all-infinity valuation is fixed, and
   that the incremental sweep count equals the least warm replay count. Forty
   seeded sources check both identities by kernel reduction (below).

## What the round-convention family checks

Generator, in the core repository: `crates/rules/examples/lean_boundary_fixtures.rs`
(core `801e732`). For each domain in {3, 4, 5, 6} it emits ten seeded sources
with one binary input relation `edge` (each pair present with probability 0.7,
cost 0..20), one derived unary relation `dist`, the rule
`dist(y) :- dist(x), edge(x, y)` and the fact `dist(0) = 0`. For each case it
records the producer's grounding (input vector and flat product triples), the
from-zero certificate, a pointwise improvement (a random nonempty set of edges
lowered or newly asserted) with the sweep count of `update_into`, and three
mutated value lists: one finite coordinate moved by one, two distinct values
swapped, and the last entry dropped. Seeds are `(domain << 32) | index` through
splitmix64; there is no ambient randomness.

Renderer, in this repository: `lean/WeightedRules/generate_round_convention.py`.
It writes `lean/WeightedRules/RoundConvention/Domain{Three,Four,Five,Six}.lean`.
Every table is read by the elaborator through `nat_table_from_json`; the
script transcribes nothing but the round counts named in the statements.
`lean/WeightedRules/TableProgram.lean` turns the tables into a
`Program Cost n` (saturating costs, out-of-range coordinates to zero, so an
import defect changes the program and the checks then fail).

Per case, by `decide +kernel`:

| Property | Statement |
|---|---|
| P1 from-zero convention | `checkCertificate P r v = true` and `checkCertificate P (r-1) v = false`, `r` = producer rounds |
| P5 incremental convention | `checkImprovementCertificate P Q v k w = true`, `… (k-1) … = false`, and `k ≤ ruleOutputBound Q`, `k` = producer sweeps |
| P6 rejection | `checkCertificate P r m = false` for each of the three mutations `m` |

`RoundConvention/Retained.lean` (P2) imports the producer's grounding of the
two hand-written sources and proves, by decidable equality on inputs and
rule lists, that they equal `distanceProgram` and `chainDistanceProgram`.
This turns the coordinate layout stated in those docstrings from a convention
confirmed incidentally into a checked correspondence, including product order.

Observed counts across the forty cases: from-zero rounds 1–5, incremental
sweeps 1–5, never exceeding the rule-output bound; every sharp half held, so
the two conventions coincide on every case, not by coincidence but for the
reason now stated in the contract document.

## Reproducibility bundle

| File | SHA-256 |
|---|---|
| `ergodis/crates/rules/examples/lean_boundary_fixtures.rs` | `99f8ba72699280b34eb5a1b562f93e70fb1cdd29e62e335d7e5c5b150c8d35e9` |
| `lean/WeightedRules/generate_round_convention.py` | `43c439baa76eb79db078ecc0748241eeddca1240f91c18c0ace9cff414ffbf9c` |
| `lean/WeightedRules/fixtures/round-convention/domain-3.json` | `ab588dad4b2ef7bda3168dc5407f1c4fb48c896bfb877a0364dcea9932094fdc` |
| `lean/WeightedRules/fixtures/round-convention/domain-4.json` | `f1a4541cd85cb27b7e568f0f4f3fe20093b3c598a26dc52191e7d11d06e495c7` |
| `lean/WeightedRules/fixtures/round-convention/domain-5.json` | `6073c434fea11317b32af6855a1c605b0539f9843af77562cd302430b9c3c8a5` |
| `lean/WeightedRules/fixtures/round-convention/domain-6.json` | `4aefb5e200617bdbab1fc668c3d9201c8aa3a175f28d5d0cd78bb9115e24755d` |
| `lean/WeightedRules/fixtures/round-convention/distance-grounding.json` | `aa279dc7415243b1d1c33475db425dab2bdef12283e3b8e3e3d11bed020e83cb` |
| `lean/WeightedRules/fixtures/round-convention/chain-distance-grounding.json` | `14ddac83070d07cf704ee03029306e0166d2553b5ba6195cb1738d9c87f532ad` |

Replay, from the core repository then the Lean package root then `rust/`:

```sh
cargo run --release -p ergodis-rules --example lean_boundary_fixtures -- \
  ../othello/lean/WeightedRules/fixtures/round-convention \
  ../othello/lean/WeightedRules/fixtures/distance.json \
  ../othello/lean/WeightedRules/fixtures/chain-distance.json
python3 WeightedRules/generate_round_convention.py
ERGODIS_RULE_LIBRARY=$HOME/.cache/ergodis/target/ergodis/release/libergodis_rules.so \
  ../lean/scripts/lean-build-queue.py build WeightedRules --cores 20-23
```

The independent replay is the Lean kernel itself: the producer's numbers are
re-derived from the formal iterate, not compared with a second Rust
implementation. The generator asserts internally that the incremental values
equal a fresh evaluation and that the producer's own verifier accepts each
certificate.

## Validation

| Gate | Result |
|---|---|
| Negative control: one wrong expected axiom line in `OracleAxiomAudit` | elaboration fails (exit 1) |
| Queue build `WeightedRules.ChainDistance`, `OutputConvergenceChecks`, three audits | pass |
| Queue build `WeightedRules.RoundConvention.DomainThree`, `Retained` | pass (7.1 s, 3.5 s) |
| Queue build of the root `WeightedRules` after the family was added | pass, 1:20 wall, 1.43 GB peak (run `20260913-153649-5d087374`) |
| `cargo clippy --release -p ergodis-rules --example lean_boundary_fixtures -- -D warnings` | clean |
| `cargo fmt --check -p ergodis-rules` | clean |
| `scripts/public-lint.sh crates/rules/examples`, `docs` | clean |

## Export boundary

None of this reaches the finitegeom export. The area export reads the
finitegeom repository's own `lakefile.toml` and inserts only the module closure
named by a `lean/trust/export/<area>.toml` config; `WeightedRules` has no such
config and the lakefile is unchanged.

Successor, unallocated: relocate `lean/WeightedRules/` (sources, fixtures,
oracle adapter, generator) to `~/src/ergodis` or `~/src/ergodis-private` as
its own Lake package, keeping the guarded build entry points.

## Not done, and why

- E4 of the review, tightening the Rust round budget to `min(n, M+1)`, is
  C1176's, not this task's.
- P6 is checked directly on `checkCertificate`, which is the predicate the
  `ergodis_solution` elaborator discharges by `decide`; the eight hand-picked
  elaborator-level rejections in `OracleRejections` remain the controls for
  the process and codec boundary. No subprocess-driven mutation family was
  added.
- The `#guard_msgs` lines exceed one hundred columns; the library has no line
  length lint and shortening them would hide the message being asserted.

## Mystery ledger

- **Lean and Rust round conventions coincide.** Settled: they coincide because
  loading the inputs is iterate one on the Lean side and the producer counts
  the final unchanged sweep; the contract document now says so and forty cases
  pin it in both the from-zero and the incremental direction. Nothing remains
  open.
- **Round counts are small.** On these sources the from-zero count never
  exceeded five and the incremental count never exceeded five on domains up to
  six, well under the scalar count (up to 43) and usually under the
  rule-output bound (up to 7). This is the expected behaviour of dense random
  edge sets, not a surprise; a chain is the extremal family and is already the
  sharpness witness.
