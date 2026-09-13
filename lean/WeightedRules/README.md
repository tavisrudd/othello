# Checked external min-plus witnesses

`WeightedRules.Oracle` turns a certificate returned by the Ergodis module ABI into
a Lean `CheckedSolution P`, where `P` is the caller's formal scalar program.
Its `.least` theorem proves fixedness and leastness in information order.

```lean
import WeightedRules.Oracle
open WeightedRules

set_option maxRecDepth 16384 in
def result : CheckedSolution distanceProgram :=
  ergodis_solution distanceProgram from "WeightedRules/fixtures/distance.json"

theorem result_least : IsLeastFixed distanceProgram (listState result.values) :=
  result.least
```

The example calls the external producer during elaboration. The resulting
declaration contains only a cost list, round count and kernel-checkable proof;
importing its compiled module does not call the producer again. The external
certificate is never interpreted as Lean source.

## Incremental proofs

`ergodis_improvement old to Q from "source.json" replay k` checks returned
values by `k` synchronous steps from an existing checked solution. It admits
only identical rule lists and pointwise improvements of base facts. Fixedness
then proves the new least solution, even when `k` is smaller than the from-zero
round count. A retraction requires the ordinary from-zero proof route.

```lean
import WeightedRules.IncrementalExample
open WeightedRules

set_option maxRecDepth 16384 in
def improved : CheckedImprovement oracleDistance improvedDistanceProgram :=
  ergodis_improvement oracleDistance to improvedDistanceProgram
    from "WeightedRules/fixtures/distance-improved.json" replay 3

def reusable : CheckedSolution improvedDistanceProgram := improved.toCheckedSolution
```

The converted certificate uses the scalar-count from-zero bound; `improved.rounds`
records incremental proof work. The replay count follows the formal synchronous
step definition and is not an unchecked runtime counter. The provider still
returns an ordinary witness for its source. The incremental route changes how
Lean proves that witness correct.

`WeightedRules.IncrementalAxiomAudit` checks the generic proofs, real chained
distance witnesses and incremental rejection controls. `CheckedImprovement`
requires a typed old `CheckedSolution`; calling the raw local replay predicate
on an unauthenticated seed does not establish leastness.

Import `WeightedRules.OutputConvergenceReflection` to use
`improved.toRuleOutputSolution`. This optional conversion keeps the values and
uses the from-zero bound `min N (M + 1)`, where M is the number of distinct rule
outputs. The same bound suffices for replay from any seed proved below the new
least solution. It is a uniform bound; a particular witness can stop earlier.
For the four-vertex example the bounds are 21 and 5, while the incremental
witness actually needs three replay steps.

## Execution

Build the `ergodis-rules` native shared library using the core repository's
documented Rust toolchain and `cargo build -p ergodis-rules --release`. Set
`ERGODIS_RULE_LIBRARY` to that library's absolute filename. Linux uses
`libergodis_rules.so`; the Python adapter loads it with `ctypes` and the existing
`ergodis_module_v1` API. It prepares the source, creates a workspace, obtains the
certificate, verifies it through the provider, and releases the objects.

The default executable is `WeightedRules/oracle`, relative to the Lean package
root. It supplies Python through Nix. An explicit `via "executable"` suffix or
`ERGODIS_RULE_ORACLE` selects another local executable accepting one source
filename and emitting the same JSON certificate to stdout. This executes that
program with the user's privileges. It must terminate; the elaborator does not
provide process isolation or a timeout. The byte limit is checked after process
output is captured, so it is an admission check, not an OS memory bound.

Use the repository's supported guarded Lean entry points. From the sibling
`rust` directory, with `ERGODIS_RULE_LIBRARY` exported, build in this order:

```sh
../lean/scripts/lean-build-queue.py build WeightedRules.Reflection --cores 20-23
../lean/scripts/lean-build-queue.py build WeightedRules.Oracle --cores 20-23
../lean/scripts/lean-build-queue.py build WeightedRules.ReflectionChecks --cores 20-23
../lean/scripts/lean-build-queue.py build WeightedRules.OracleRejections --cores 20-23
../lean/scripts/lean-build-queue.py build WeightedRules.OracleExample --cores 20-23
../lean/scripts/lean-build-queue.py build WeightedRules.OracleAxiomAudit --cores 20-23
```

Direct ABI replay, from the Lean package root:

```sh
WeightedRules/oracle WeightedRules/fixtures/distance.json
```

The expected bytes, including the trailing newline, are retained in
`fixtures/distance.certificate.json`. `OracleExample` checks the live response
against `distanceProgram`; it does not use that retained response as an oracle.

## Audit gate and library root

`WeightedRules.lean` imports every audit module and the round-convention
family, so the single target `WeightedRules` builds the whole library. It is
deliberately not a default Lake target: the library is kept separate from the
rest of this Lean tree, and its oracle examples need the external producer
library at build time. Each `#print axioms` in
the audit modules is wrapped in `#guard_msgs` with its expected message, so the
audit is a build-failing assertion: a terminal that acquires `sorryAx`, a
native-evaluation axiom or any other new dependency fails the build. When a
proof legitimately changes its axiom set, update the expected message next to
its print command.

## Round convention against the producer

The producer counts rule sweeps, including the final sweep that changes
nothing; the formal iterate counts from the all-infinity valuation, with the
inputs loaded at iterate one. `WeightedRules.TableProgram` imports a producer's
grounding from natural-number tables, and `WeightedRules.RoundConvention.*`
check by kernel reduction, on forty seeded sources of domain three to six,
that the producer's from-zero round count and its incremental sweep count are
exactly the least fixed indices of the corresponding synchronous iterates,
that the incremental count lies within the rule-output bound, and that three
single mutations of each certificate are rejected. `RoundConvention.Retained`
compares the producer's grounding of the two hand-written sources with
`distanceProgram` and `chainDistanceProgram` coordinate by coordinate.

The fixtures under `fixtures/round-convention/` are written by the producer's
`lean_boundary_fixtures` example; `generate_round_convention.py` renders the
Lean modules, which read every table through `nat_table_from_json`. To
regenerate, from the core repository and then the Lean package root:

```sh
cargo run --release -p ergodis-rules --example lean_boundary_fixtures -- \
  <lean-root>/WeightedRules/fixtures/round-convention \
  <lean-root>/WeightedRules/fixtures/distance.json \
  <lean-root>/WeightedRules/fixtures/chain-distance.json
python3 WeightedRules/generate_round_convention.py
```

## Verification boundary

`WeightedRules.Convergence` proves that every bounded min-plus program on `n`
scalar coordinates is fixed after `n` synchronous rounds from infinity.
`boundedMinPlus_iterate_fixed` includes empty programs, cycles, repeated product
factors and saturation. `boundedMinPlus_iterate_least` establishes leastness.
The module `WeightedRules.ConvergenceSharpness` defines
`WeightedRules.zeroChainProgram`; its theorem
`WeightedRules.zeroChain_requires_scalar_rounds` proves the bound sharp for
every positive scalar count.

`WeightedRules.ConvergenceReflection` proves `checkCertificate_complete` for
the exact list of N-round values. `iteratedCheckedSolution` constructs that
accepted result internally, and `CheckedSolution.eq_iterate` proves that every
accepted certificate denotes the same valuation. Build
`WeightedRules.ConvergenceAxiomAudit` through the supported guarded entry point
to check these proofs, the sharpness family and the finite boundary controls.

`WeightedRules.OutputConvergence` proves the tighter structural bound
`ruleOutputBound P = min n ((ruleOutputs P).card + 1)`. The first round loads
facts; later improvements can occur only at rule outputs. Duplicate rules and
immutable input coordinates do not inflate the distinct-output count.
`ruleOutputCheckedSolution` constructs a certificate at this bound;
`CheckedSolution.withRuleOutputBound` changes an existing certificate's round
count by proof while preserving its values. Build
`WeightedRules.OutputConvergenceAxiomAudit` for the structural theorem,
safe-seed replay, conversions, sharpness and distance controls. The ordinary
checker still admits any valid certificate within the scalar-count bound.
`WeightedRules.outputChainProgram` in `OutputConvergenceSharpness` has M
outputs and needs M+1 rounds for every M, including zero.

`checkCertificate` checks exact coordinate coverage, a round count at most the
number of scalars, equality with iteration from infinity, and fixedness under
the supplied formal equations. `checkCertificate_sound` proves that acceptance
implies least fixedness. `CheckedSolution.least` exposes this proof to callers.
The elaborator uses ordinary `decide`, disables error recovery to `sorry`, and
rejects proof terms containing `sorry`. The axiom audit covers the checker
theorem and actual imported witness, rather than assuming that native execution
has the same trusted base as kernel reduction.

Costs belong to `Fin 4294967296`; addition saturates at the infinity sentinel
4294967295 and alternatives select minimum. Information order reverses numerical
cost order. In particular, a zero-valued self-loop can satisfy its equation
without any derivation from facts; the replay checker rejects that valuation.
The numerical cost of a least information fixed point need not be the smallest
among all unsupported algebraic fixed points. No unbounded-integer optimum or
path witness is asserted.

JSON schema, dimensions, cost ranges and source-identity encoding are checked
before elaborating proof literals. The source hash is not a Lean proof of source
correspondence. Rust parsing, grounding, hashing, the Python adapter and C ABI
remain outside the proof's trusted base because the theorem uses the caller's
`P`, not a program supplied by the oracle. A theorem about relational syntax
requires the explicit lowering obligations in `WeightedRules.Relations`.

`ReflectionChecks` checks finite replay rejection by kernel reduction.
`oracleDistance_agrees` also proves symbolic agreement with the independently
defined internal certificate. `OracleRejections` invokes deliberate adversarial responses through
`fixtures/rejection-oracle`, including a valid control and an unsupported cyclic
fixed point and a certificate for the wrong caller program. These fixtures are
test inputs, not asserted certificates.
