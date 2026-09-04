# C1062 probe 1: the causal lowering, its oracle gates, and the towers

**Lane**: `complete-ports`
**Task**: C1062, probe 1
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Inputs**: probe 1a (`2026-09-04-c1062-probe1a-carrier-and-cost-model.md`) for the carrier and cost
model; probe 0 (`2026-09-04-c1062-probe0-prior-art-and-landscape-audit.md`) for the Balke–Pearl gate
and the targeted-reduction positioning.
**Code**: `ergodis-private` `b49ebb3`, `8d6aed9`, `93f5d75` (module, towers, report tool)
**Replay**: `cargo run --release --package ergodis-tools -- causal-lowering-report`
**Verdict**: the lowering is correct and the gates pass. The compiler adds nothing at the root on
three of seven fixtures, which is the expected and previously predicted result, not a defect.

## What was built

`ergodis-private/src/causal.rs`, a tier-1 library module. `CausalModel` carries exogenous domains,
endogenous domains, one deterministic mechanism table per endogenous variable in topological order,
a declared observation set, a declared intervenable set, and an arity bound. Acyclicity is enforced
by construction: every endogenous parent must be strictly earlier in the order, so no cycle check is
needed and no cyclic model can be built.

The lowering is the `(u, I)` carrier from probe 1a: one sort per pinned support set of size at most
`k`, state layout context-major within a sort, and one `GeneratorSpec` per (sort, variable, value)
triple whose target sort is the source sort when the variable is already pinned and the extended
sort otherwise. At the arity bound the extending generators are simply omitted, which enforces the
bound without a sink state. `decode_word` maps a certificate path back to the intervention word it
represents, so a separator reads as an explicit experiment rather than as generator indices.

Relevance pruning is in the lowering, not the reporting, as probe 1a required: exogenous variables
that are not ancestors of the observation set are dropped and their mechanism table axes collapsed
before the carrier is built. `lower` takes a state budget and fails with the measured size rather
than exhausting memory.

## Gate 1: the response-function partition

The external-truth gate. A model with three binary endogenous variables, exogenous domains of sizes
2, 6 and 5 — deliberately larger than the number of distinct response functions each induces, so the
per-variable partitions are non-trivial — observing every endogenous variable, with the full
intervention vocabulary at arity two. The expected partition is computed directly from the mechanism
tables as the tuple of per-variable response functions, never through the lowering.

**60 exogenous contexts collapse to exactly 32 classes, class for class.** Two root values, four
distinct response functions at the second variable, four at the third: `2 x 4 x 4 = 32`. The
compiled quotient, the direct-enumeration oracle, and the table-derived expectation all agree.

Every exogenous variable in this fixture feeds exactly one endogenous variable, so the expected
object is the **product** of the per-variable partitions. Probe 0's clause applies: a fixture with a
shared exogenous parent would expect the joint partition of the response tuple instead, and that
case is not exercised here.

This is a correctness gate at `n = 3`, not a scaling result. Probe 1a's cost model puts `n = 4` near
five million states and `n = 5` out of reach.

## Gate 2: the direct-enumeration oracle

An independent oracle in the same module groups contexts by the signature `I -> O(u, I)`, enumerated
over partial assignments **directly** rather than as generator words, so that a misreading shared
between the model and the compiler cannot manufacture agreement. All seven fixtures agree.

## Gate 3: the arity boundary

The `n <= 4` response-function gate barely reaches `k < n`, so it cannot catch a lowering that is
right on small models and wrong where the arity bound bites. A separate fixture — an eight-variable
alternating chain at arity two — checks that every support of size two carries exactly the four
in-place overwrite generators for its own variables while interior sorts carry all sixteen, and that
the compiled quotient still matches the oracle. It does. This gate was added on the strength of the
concern raised when probe 1a was reported.

## Measurements

Carrier cost. The state column is the materialized `(u, I)` count, never `|U|`; the last column is
the per-state constant `4(nd + 1)`, which is where the memory actually goes.

| fixture                 | contexts | sorts | states | generators | transition B | B/state |
|-------------------------|----------|-------|--------|------------|--------------|---------|
| chain                   | 2        | 4     | 18     | 16         | 288          | 20      |
| fork                    | 3        | 4     | 48     | 24         | 1,152        | 28      |
| collider-disjunctive    | 4        | 7     | 76     | 36         | 1,440        | 28      |
| diamond-conjunctive     | 4        | 11    | 132    | 64         | 2,688        | 36      |
| wide-conjunction        | 16       | 16    | 1,296  | 128        | 41,472       | 36      |
| identity-predicted-loss | 6        | 4     | 72     | 20         | 1,440        | 24      |
| response-function       | 60       | 7     | 1,140  | 36         | 21,600       | 28      |

The arity tower, `~_{<=0} ⊇ ~_{<=1} ⊇ …`, as class counts.

| fixture                 | k=0 | k=1 | k=2 | k=3 | k=4 |
|-------------------------|-----|-----|-----|-----|-----|
| chain                   | 2   | 2   | 2   | —   | —   |
| fork                    | 3   | 3   | 3   | —   | —   |
| collider-disjunctive    | 2   | 4   | 4   | 4   | —   |
| diamond-conjunctive     | 2   | 3   | 3   | 3   | 3   |
| wide-conjunction        | 2   | 6   | 12  | 16  | 16  |
| identity-predicted-loss | 6   | 6   | 6   | —   | —   |
| response-function       | 7   | 28  | 32  | 32  | —   |

The observation tower, class count as `O` grows along a declared order.

| fixture                 | \|O\|=1 | 2  | 3  | 4  | 5  |
|-------------------------|---------|----|----|----|----|
| chain                   | 2       | 2  | —  | —  | —  |
| fork                    | 3       | 3  | —  | —  | —  |
| collider-disjunctive    | 4       | 4  | 4  | —  | —  |
| diamond-conjunctive     | 3       | 3  | 3  | 4  | —  |
| wide-conjunction        | 16      | 16 | 16 | 16 | 16 |
| identity-predicted-loss | 2       | 6  | —  | —  | —  |
| response-function       | 17      | 30 | 32 | —  | —  |

## What the numbers say

**Interventions do most of the work on exactly the shapes predicted, and none on the others.** The
response-function fixture goes from 7 classes with no intervention to 28 at arity one and 32 at
arity two — a `4.6x` refinement from the intervention vocabulary alone. The wide conjunction goes
`2 -> 6 -> 12 -> 16`. Meanwhile the chain and fork towers are completely flat: their observation
already separates every context it can, and the intervention vocabulary adds nothing. Those are
honest negative rows and they belong in the table.

**The response-function tower stabilizes at exactly the maximum in-degree.** It reaches 32 at
`k = 2` and never moves again. That is the theoretically expected stabilization point — exposing
`f_V(p, u_V)` requires pinning all of `V`'s parents simultaneously, and no fixture variable has more
than two — so the tower is measuring the right thing.

**The observation set is a dial, and the response-function fixture shows its whole range**:
17 classes observing one variable, 30 at two, 32 at three. Declaring more observation is not free
precision; it is a monotone slide toward the identity.

**The predicted loss loses.** `identity-predicted-loss` observes every variable of a model whose
variables are copies of independent exogenous sources, so its quotient is the identity at every
arity — 6 classes from 6 contexts, flat. Predeclared to lose, and it lost.

**Three of seven fixtures have no non-empty separating word at all.** On chain, fork, and the
identity fixture, every separated pair already differs before any intervention. The compiler's
certificate is empty there. This is the signature collapse from probe 1a made visible.

## What the compiler adds: the four-item contract, honestly scored

Probe 1a set this as the kill criterion — the report must say what refinement buys beyond a one-pass
signature partition, or it has measured nothing.

1. **The congruence on intervened states.** Delivered structurally: the compiled quotient assigns a
   class to every `(u, I)`, not only to the roots. **Not yet exploited.** This is what probe 3 needs
   for contingency pruning, and probe 1 does no more than make it available.
2. **Replayable separators, decoded as interventions.** Delivered and demonstrated. The wide
   conjunction's certificate reads `do(V0:=1) do(V1:=1) do(V2:=1)` — an explicit three-variable
   experiment. **One caveat that must not be glossed:** by the signature collapse this word is
   equivalent to the single simultaneous arity-three pin, so it is a word-shaped presentation of a
   pin, not evidence that word structure matters. Non-vacuous word structure needs probe 8.
3. **The arity tower from layered scheduling.** Delivered as a measurement, but computed by the
   direct oracle per rung rather than incrementally through `plan_layered_greedy_schedule`. The
   incremental path is the actual saving and it is **not yet implemented**; the tower numbers above
   are correct but were bought at full price per rung.
4. **Non-vacuity under a non-idempotent vocabulary.** **Not tested.** Every generator here is a hard
   overwrite, so the collapse applies throughout. This is probe 8's job.

So the contract is one-quarter genuinely delivered, one-half made available, one-quarter untouched.
Probe 1 is infrastructure and a stated cost model, exactly as the plan said it should be, and it
should not be read as evidence that compilation pays.

## Two fixtures that failed before the one that worked

Worth recording, because the failures are informative about which causal shapes the quotient can
see. Building the tower fixture, a **count-valued** outcome and a **parity** outcome both collapse
to the identity at arity one: pinning a single variable and reading both of its values reveals that
variable's entire contribution, so the tower jumps straight to full resolution and measures nothing.
A **conjunction** resists, because a single pin leaves the outcome saturated at zero whenever two or
more inputs are already zero, and only simultaneous pins lift it. The general rule this suggests —
untested beyond these three cases — is that the arity tower has content exactly when the outcome is
not invertible in each input separately.

## Positioning

Per probe 0: with `O` equal to the declared outcome, this compiled relation is the exact
combinatorial counterpart of Kekić, Schölkopf and Besserve's Targeted Causal Reduction (UAI 2024),
which learns an approximate target-specific reduction from interventional simulation data. Exact
versus learned is the distinction, and it is a good one. With `O` equal to every endogenous variable
it is Balke and Pearl's 1994 response-function partition, which gate 1 now verifies rather than
assumes.

## Foreign-lane note

`cargo clippy --workspace --all-targets -- -D warnings` reports seven findings in
`tasks/tools/src/generic_certificate_bench.rs`, `local_commit_bench.rs`, and
`profile_vocabulary_bench.rs` — unused imports, an unequal-group hex literal, three dead assignments,
and a complex type. All three are C1061 files, most recently touched by that lane's own commits, and
none was edited here. Raising, not fixing. The C1062 files are clippy-clean and the ten new library
tests pass.

## Next

Probe 2 (best intervention and the economics) or probe 3 (actual causality) can both start; they are
independent of each other. Probe 3 now has its substrate: the congruence on intervened states is
compiled and reachable, and the responsibility formula was corrected before any of it was written.
</content>
