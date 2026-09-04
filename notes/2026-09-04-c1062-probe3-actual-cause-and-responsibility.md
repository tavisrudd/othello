# C1062 probe 3: exact actual cause, responsibility, and the certificate that did not compact

**Lane**: `complete-ports`
**Task**: C1062, probe 3
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Inputs**: probe 0 for the responsibility formula and the pre-entered published verdicts; probe 1
for the lowering that supplies the class oracle.
**Code**: `ergodis-private` `3fcaa0c`, `925f19c`, `163d799`
**Replay**: `cargo test --release --package ergodis-private --lib actual_cause:: -- --nocapture`
**Verdict**: the engine is correct and reproduces every published verdict exactly. The exhaustion
certificate **does not** meet its predeclared 10% compactness threshold on these fixtures. Tavis
directed that this not close the probe; the finding is recorded and work continues, with the
emphasis moving to the decision layer.

## The engine

`ergodis-private/src/actual_cause.rs` implements the **modified** Halpern–Pearl definition: the
witness set `W` is held at its actual values and only the candidate cause is set away from its own.
The search ranges over `(X', W, x')` with the queried literal a conjunct of `X'`, layered by
`|X'| + |W|` so the first success is minimal by construction, with AC3 checked explicitly by a
bounded sub-search over every strict nonempty subset of the cause.

Degree of responsibility is `1 / (|X'| + |W|)`, per probe 0. The trap that motivated probe 0's
question is real and is now guarded by tests: transplanting Chockler–Halpern's `1/(k+1)` would
return responsibility 1 for every cause, because their `k` counts the witness variables whose value
*differs* from the actual context and under the modified definition none do.

## Published verdicts, all reproduced

Every value below was entered from probe 0's audit **before** the engine was run.

| Fixture | Published | Computed | Shape found | Source |
|---|---|---|---|---|
| Forest fire, conjunctive, `L = 1` | `dr = 1` | `1/1` | `\|X\|=1, \|W\|=0` | Halpern IJCAI 2015 Ex. 3.1 |
| Forest fire, conjunctive, `MD = 1` | `dr = 1` | `1/1` | `\|X\|=1, \|W\|=0` | same |
| Forest fire, disjunctive, `L = 1` | `dr = 1/2` | `1/2` | `\|X\|=2, \|W\|=0` | same |
| Forest fire, disjunctive, `MD = 1` | `dr = 1/2` | `1/2` | `\|X\|=2, \|W\|=0` | same |
| Rock throwing, `ST = 1` (Suzy) | `dr = 1/2` | `1/2` | `\|X\|=1, \|W\|=1`, witness `{BH}` | Ibrahim diss. § 2.4 |
| Rock throwing, `BT = 1` (Billy) | `dr = 0` | `0/1` | not a cause | same |
| Voting 11–0 | `dr = 1/6` | `1/6` | `\|X\|=6, \|W\|=0` | same |
| Voting 5–4 | `dr = 1` | `1/1` | `\|X\|=1, \|W\|=0` | Chockler–Halpern 2004 § 1 |

Two results are worth calling out because they are the ones a weaker implementation gets wrong.
The **disjunctive forest fire** returns the conjunctive cause `L = 1 ∧ MD = 1` with each conjunct at
one half; a singleton-only search would report "not a cause, responsibility 0" and look clean. The
**rock throwing** fixture recovers the witness set `{BH}` held at its actual value zero, which is
exactly the published witness, and correctly finds Billy not to be a cause under any definition.

## The measurement that failed its threshold

| fixture | degree | candidates | pruned | classes | verifier fraction |
|---|---|---|---|---|---|
| forest-fire-conjunctive | 1/1 | 1 | 0 | 0 | 0.00% |
| forest-fire-disjunctive | 1/2 | 3 | 0 | 2 | 66.67% |
| rock-throwing-suzy | 1/2 | 4 | 0 | 3 | 75.00% |
| rock-throwing-billy | 0/1 | 40 | 15 | 32 | 58.18% |
| voting-5-4 | 1/1 | 1 | 0 | 0 | 0.00% |

The predeclared threshold was a verifier fraction below 10%. It is missed by a wide margin on every
row that has a non-trivial negative.

**Read the numbers before reading the verdict.** The rows with 0% have a certificate of size zero
because the cause is found on the first or only candidate — there is no negative to certify, so
those are not passes. The one row with a real exhaustion obligation, `rock-throwing-billy`, searched
55 candidates in total, pruned 15 of them by class (27%), and recorded 32 classes. A search space of
55 is far too small for a class-based negative to compress: the class count is bounded by the
quotient size, which is a fixed property of the model, while the candidate count grows
combinatorially in the pool size and the size bound. **The prediction that follows is that the
fraction improves sharply with model size, and it is currently untested** — probe 1a's envelope
(`|U| ≲ 10^4` at arity two or three) is what limits how far it can be pushed on the flat carrier,
which is a second reason probe 7's compositional route matters.

So the compactness claim is not refuted, it is **unmeasured at any interesting scale**, and the
honest statement today is that the certificate has not been shown to compact. Per Tavis's direction
this does not close the probe.

## A defect in the core's quotient-only certificate policy

Found while measuring, and it is a core issue rather than a lane one. Compiling the same lowering
under three certificate policies:

| voters | arity | states | sorts | quotient-only | split transcript | exhaustive pair audit |
|---|---|---|---|---|---|---|
| 4 | 3 | 1,040 | 15 | ok, 15 classes | ok, 15 | ok, 15 |
| 5 | 2 | 1,632 | 16 | ok, 16 classes | ok, 16 | ok, 16 |
| 5 | 3 | 4,192 | 26 | **error** | ok, 26 | ok, 26 |
| 6 | 2 | 4,672 | 22 | **error** | ok, 22 | ok, 22 |
| 6 | 3 | 14,912 | 42 | **error** | ok, 42 | ok, 42 |

`CertificatePolicy::QuotientOnly` fails with `generator N is not compatible with class M` on
presentations with more than about sixteen sorts, while `SplitTranscript` and `ExhaustivePairAudit`
both succeed **and agree with each other on the class count**. The threshold tracks the sort count,
not the state count.

The lowering is not at fault. A range check added to `lower` verifies that every generator
transition lands inside its declared target sort, and it passes on all of these; two independent
policies agree on the answer. The most likely locus is the quotient-only path's internal transcript
construction, which the C983 record notes was recently reworked so that "quotient-only still entered
the quadratic synchronous refiner; it now constructs and verifies the compact transcript
internally".

**Raising, not fixing** — `~/src/ergodis` is C1017's active surface. C1062 works around it by using
`SplitTranscript`. The regression witness is the `locate_the_voting_compile_failure` test, which
runs in under a second and prints the table above.

## Two defects fixed in the lane's own code

1. **Support sets were generated as positions, used as variable ids.**
   `enumerate_supports` produced indices `0..intervenable.len()`, while sort sizing, the local index
   split, and the generator target lookup all index domains by variable id. Every fixture built so
   far declares `intervenable = 0..n`, where the two coincide, so nothing was observably wrong — and
   any model with a non-contiguous intervention vocabulary would have been silently miscompiled.
   Found by reading rather than by a failing test, which is worth noting: the existing fixtures
   could not have caught it.
2. **The lowering did not check its own transition ranges.** Added, with a typed error, so that a
   malformed presentation fails at the lowering with a variable-level message instead of surfacing
   much later as an opaque class id inside the compiler.

## Foreign-lane note

`tasks/tools/src/tiger_blossom_bench.rs` is uncommitted and currently does not compile
(`time_shots` not found), which blocks the whole `ergodis-tools` binary. That is C1061's file,
mid-edit by a concurrent session. The probe-3 measurement was therefore taken through the library
test target instead of the tools subcommand; the subcommand is committed and will work once that
lane's edit lands. This is the second foreign-lane obstruction recorded today, after the seven
clippy findings in probe 1's report.

## Where this leaves the probe

Against the plan's kill criterion — no compact negative, or no amortization — the compactness half
is missed and the amortization half was not reached, because the timing arm lives in the blocked
tools binary. Tavis directed that the probe not close on this, and the direction is right for a
reason worth stating: **the exhaustion certificate is a property of the negative, and the negative
is only expensive at a scale the flat carrier cannot yet reach.** Killing on a 55-candidate search
would be drawing a conclusion from the wrong regime.

## Next, and a change of emphasis

Tavis's steer is that the **decision layer** is what to lean into. That agrees with the adversarial
plan review, which called the missing optimization probe the plan's largest faithfulness gap: this
is a spike for an exact optimization compiler, the brainstorm's proposal 6 is optimization over
interventions, and no probe computed `best_intervention`. It is also where the compiled quotient
plausibly pays, since "find the cheapest intervention reaching this outcome" is a search over the
monoid action on the quotient rather than a single re-solve.

Actual causality now becomes an **input** to that layer rather than the headline: the minimal
contingency is what turns "this failed" into "this is the smallest change that would have prevented
it", which is a decision, not an attribution. Probe 2 is therefore promoted to the spine, and its
first deliverable is `best_intervention` with a cost model, followed by minimax regret over a
bounded model set.
</content>
