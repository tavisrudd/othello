# C1062 closeout: what a structural causal model is worth as a context language for Ergodis

**Lane**: `complete-ports`
**Task**: C1062, task-level closeout across probes 0, 1a, 1, 2, 3, 4, 5, 6, 7 and 8
**Plan**: `2026-09-04-c1062-exploration-log.md` (probe index, thresholds, process rules)
**Brief**: `2026-09-04-c1062-ergodis-causal-brief.md`; adversarial review `2026-09-04-c1062-plan-review.md`
**Code**: `~/src/ergodis-private` (`causal*.rs`, `best_intervention.rs`, `actual_cause.rs`,
`causal_design.rs`); core changes: none
**Status of the plan**: every probe except 9, the gated demonstration, is done. No probe was killed
by its kill criterion; two were refuted on their central claim and both refutations are the value.
**Scope**: private research. No manuscript, mirror, public-surface, or Ergodis-core change was made.

## 1. The question, and the answer

C1062 asked whether a finite structural causal model is another context language for the Ergodis
contextual quotient — lower the model plus a declared intervention vocabulary onto the observational
compiler, and get exact causal abstraction, with a separating intervention as the refutation witness.

The answer, after nine probes: **the lowering is real, exact, and mostly not worth compiling.** A
finite acyclic model with a declared edit vocabulary does lower onto the observational compiler,
class for class against external truth, and every layer built on it is exact against an independent
oracle. But for hard interventions the compiler's quotient is reachable by a one-pass signature
partition at the same asymptotic cost, and every timing threshold the plan set was missed at exactly
`1.00x`. The thesis has genuine content in one place only — a sequential, non-idempotent
vocabulary — and that is where probe 8 found it, sharply. What C1062 produced that is worth keeping
is not compression: it is a stack of exact, replayable certificates and decidable preconditions that
tell a caller when an answer is expressible at all.

## 2. The repair that shaped everything

The original plan's lowering was ill-typed and the adversarial review killed it before any code:
`do(V := a)` applied to an exogenous assignment `u` is a solution of a *different* model, so a
generator has nowhere to land. The forced repair makes the state the pair `(u, I)` of a context and
the current pinned assignment, and its consequences run through every later probe:

- **The exponential moved from the vocabulary into the compile.** Forty generators is true of the
  declared vocabulary and false of the materialized carrier, which is `|U| · Σ_{j≤k} C(n,j) d^j`.
  Probe 1a's cost model puts the practical envelope at `|U| ≲ 10^4` at arity two or three, with
  transition tables — about `4(nd+1)` bytes per state — the binding wall.
- **Word closure is vacuous for hard pins.** Override composition is idempotent and commutative on
  distinct variables, so every word collapses to its final partial assignment. The compiler's
  contribution is therefore *not* the quotient on `U`; it is the uniform separator certificate and
  the congruence on intervened states.
- **The observation set is a dial, not a constant.** Observe everything on a root-exogenous model
  and the quotient is the identity, so `|Q|` is only meaningful as a function of `|O|`.

Everything C1062 measured afterwards is a measurement of that carrier, and the honest reading of the
task is that the review's repair, not the spike's original claim, is what the task tested.

## 3. What each probe settled

| probe | claim under test | verdict |
|-------|------------------|---------|
| 0 | no mature actual-causality engine exists; the compiled object is unpublished | **half false**: three engine lineages exist (HP2SAT 2019, the ATVA 2020 MaxSAT/ILP successor, the KR 2025 answer-set engine); the full-observation quotient *is* Balke–Pearl's 1994 response-function partition; the refinement algorithm with a separating witness was not located |
| 1a | the flat carrier is practical | **viable but narrow**, `\|U\| ≲ 10^4` at arity two or three; promoted probe 7 from gated to expected |
| 1 | the lowering is correct against external truth | **passes**: 60 exogenous contexts to exactly 32 classes on the response-function gate, class for class; the compiler adds nothing at the root on three of seven fixtures, as predicted |
| 2 | compiling pays for the decision query | **exact, and the economics fail structurally**: compression passes at `4.97x` and `2.00x` above a verified symmetry fold and beats concrete-state search by `220x`, but against memoized re-solve the ratio is `1.00x`, because the lowering solves the model once per materialized state — exactly the table a memoized solver fills |
| 3 | an exact, certificate-carrying Halpern–Pearl engine | **correct**: all eight published verdicts reproduced, including the two that catch a weaker implementation; the exhaustion certificate missed its 10% threshold at a 55-candidate scale where a class-based negative cannot compress |
| 4 | the twin network becomes a path | **precondition corrected**: two arms exact, two numerically wrong (`0/1` and `2/3` against a true `1/3`); `O ⊇ E` is sufficient and not necessary, and the exact condition — evidence set is a union of classes, action is declared — is decidable on the classes |
| 5 | separating interventions are unusually good counterexamples | **refuted**: the loop seals up to reparameterization with all 2,849 separators replayed, but the separator arm is `0.770x` on the largest sealing family and `0.967x` once the one-sidedness is removed |
| 6 | decision equivalence is a cheaper identification target | **met, and the equivalence does not exist**: gaps from `1.00x` on the predeclared loss to zero experiments, and to a decision reached where identification is impossible; sharing an optimal action is not transitive, so no quotient expresses the stopping rule |
| 7 | a compositional route reaches scale | **exact and it scales**: `4.096 × 10^15` contexts to 4,096 in 25.6 microseconds, exact for every observation set, intervenable set and arity; the composed quotient is a product partition and equals the flat one on 9 of 13 families, the four losses being exactly the non-product shapes |
| 8 | the "another context language" thesis has content | **met sharply, and only here**: under a cyclic-cursor vocabulary no generator is idempotent, no pair commutes, and all 34 separators of length two or more are order-essential, against a hard-pin control with none; economics predeclared as a loss and lost at `1.00x` |

## 4. Three independent measurements of the same negative

The economics were tested three times, on different objects, and gave the same answer each time.
Probe 2's decision query ties memoized re-solve at `1.00x`. Probe 8's richer vocabularies tie the
direct route at `1.00x` in all three. Probe 6's exact minimax planner is matched by greedy
maximum-split on every family, in mean and worst case. Compiling this carrier does not make the
answer cheaper.

The reason is structural rather than an implementation gap, and probe 2 states it exactly: the flat
lowering solves the model once per materialized state, and that count *is* the work a memoized
solver does to fill its table. No faster refinement changes it. Probe 7's reduction is the only
route that changes the arithmetic, because it never materializes `|U| · π_k` at all.

What compiling does buy, in every probe that looked: a replayable certificate, a decidable
expressibility test, and an answer for words the direct route never enumerated. Probe 8 puts that
precisely — the direct route is complete only up to the word length it enumerated, while the
compiled machine answers every word.

## 5. What died, and should not be revived without new evidence

- **The separating intervention as a teaching signal.** Measured twice, in the seal loop (probe 5)
  and in experiment selection (probe 6), against fair baselines both times: `0.770x`/`0.967x` and
  `1.00x`–`1.10x`. It is a sound witness and a good certificate; it is not an unusually informative
  counterexample, and the brief rested weight on the claim that it is.
- **Variable merging, and the "hundred thousand variables become a fifty-state machine" line.**
  Retired in probe 7. The `(u, I)` quotient cannot express "these 27 states are one causal
  variable" — that is a partition of the variable set, which is the carrier of Madaleno, Misra and
  Markham's coarsening work, and probe 7 deliberately declines it and keeps the exogenous carrier.
- **First-engine and raw-speed framing for actual causality.** Probe 0 closed both. The surviving
  differentiators are non-binary finite domains, degree of responsibility, and an exported
  independently replayable exhaustion certificate.
- **Decision equivalence as a quotient.** Probe 6: the stopping rule is a covering condition on the
  optimal-action sets, not a partition of the hypotheses.

## 6. What is ours, after the audit

Probe 0's audit leaves a narrow and defensible strip. The full-observation quotient is Balke and
Pearl's response-function partition, credited back to Pearl 1993, so it is a correctness fixture
rather than a result. "Bisimulation under intervention" is Chakraborty, Caulfield and Pym's term and
is used as theirs. Factored partition refinement descends from the Givan–Dean–Greig model-
minimization line and no algorithmic novelty is claimed for it. What was not located in any index is
the specific combination: the coarsest quotient of a finite model's exogenous space under
indistinguishability by every admissible intervention, computed by refinement, emitting a separating
intervention as the refutation witness for each separated pair, with the arity tower as a reported
object. With the observation set equal to the declared outcome, the compiled relation is the exact
combinatorial counterpart of Kekić, Schölkopf and Besserve's targeted causal reduction — exact
against learned is the distinction, and it is a good one.

## 7. Two obstructions outside this lane, both now repaired

Neither was fixed by the probes, because the spike did not own the core. Both were repaired in a
follow-up pass recorded in `2026-09-04-c1062-core-certificate-policy-repair.md` (core `6cc9668`,
private `3167a94`).

1. **The core miscompiled the causal lowerings under four of its five certificate policies**, and it
   was a real core bug rather than a caller error. The multiway refiner marked a freshly split
   block's predecessors dirty while enumerating that block's members *from the very array the
   marking reorders*, so whenever a new block contained its own predecessors — every generator from
   a sort into itself, which is every re-pin generator a causal lowering emits — some members were
   visited twice and others never, and the refiner stopped on a partition that was not a congruence.
   The reduced trigger is one sort of six states with one generator. `MultiwayTranscript` hits it
   directly; `QuotientOnly` and `AdaptiveTranscript` hit it only when the multiway refiner is
   admitted at all, which needs at least 4,096 states and at most two observations per sort — and
   that admission rule, not a sort or state count, is why the threshold "tracked neither sorts nor
   states".
   **The "fails closed" claim the probes recorded is half wrong, and the correction matters.**
   `compile_observational_with_policy` does fail closed, raising `GeneratorMismatch` from its
   immediate verifier, but `compile_observational_with_deferred_verification` returned the wrong
   partition silently — 2,914 classes where the truth is 1,468. The repair enumerates from a
   snapshot of the split block, gated by a six-state regression confirmed to fail on the old code
   and by a cross-policy agreement test over domain-neutral presentations, including a 4,352-state
   shape admitted to the multiway path. Every probe-2 family now agrees under all five policies, and
   200,000 fuzzed presentations show no disagreement.
2. **The exhaustive pair audit's cost is inherent in its retained form, and was also partly
   implementation.** The memory is the quadratic record set — 7,880,704 records of 24 bytes at
   33,024 states — which only the core's existing streaming entry points avoid. On top of that the
   verifier retained a hash set of every pair and the builder grew its pool by doubling; removing
   both, with the accepted-certificate set unchanged, makes verification 4.2x faster (`|t| ≥ 8.8`
   over seven interleaved rounds) and halves the audited compile's peak memory. Of the recorded
   numbers, the 846x, the 1.516 s, the 1.792 ms and the 33,024 states are confirmed to order of
   magnitude; the 6.9 GB at 205,056 states is what the record count predicts but was not reproduced
   directly.

One item remains for C1017 and is recorded in that note: the deferred-verification artifact carries
no "unverified" marker, and this episode is the demonstration that its failure mode is a silently
wrong quotient rather than an error.

## 8. Extra juice and the Tao pass

- **The cheapest real upgrade in reach is the compositional counterfactual.** Probe 4 measured
  correctness and explicitly did not measure cost, and probe 2 makes a cost win unlikely on the flat
  carrier. A counterfactual over probe 7's reduced exogenous alphabet is a strictly smaller
  abduction, and probe 7's reduction is already built and exact. This is the one crossover where the
  existing pieces compose into a measurement nobody has taken.
- **The hypothesis index is the unexplored axis.** Probe 6's outcome table is probe 1's signature
  construction transposed: probe 1 groups exogenous *contexts* by their row of observations under
  every admissible intervention, probe 6 groups candidate *models* by exactly that kind of row.
  Identification over models is the mirror of the quotient over contexts, on the other index of one
  matrix. Every economics measurement so far is on the context index.
- **What Tao would ask first, and it is uncomfortable**: if the compiled quotient ties a memoized
  table on every query measured, what is the smallest object that carries the *only* things
  compiling did buy — the certificate and the completeness over unenumerated words? That question
  points away from compiling the whole carrier and towards emitting the certificate from the direct
  computation, which no probe tried and which would make the `1.00x` results a design input rather
  than a disappointment.
- **The arity tower is computed at full price per rung.** `plan_layered_greedy_schedule` exists and
  is not used; the incremental tower is cheap and unbuilt.

## 9. Mystery ledger, task level

- **Why is every economics ratio exactly `1.00x`, three times, on three different objects?** Settled
  for probe 2 by the structural argument above — state count equals memoization work — and the same
  argument covers probe 8, whose vocabularies change reach rather than cost. Probe 6's tie has a
  different cause (families too small to separate greedy from optimal). **Two mechanisms, one
  number, and the coincidence is not evidence of a third thing.**
- **Probe 3's amortization arm was never measured.** The claim that repeated queries share one
  compile is the last untested half of probe 3's kill criterion. **Open, and the only unmeasured
  path to a positive economic result on the flat carrier.**
- **Probe 5's induced global partition arm won at `1.667x` on the smallest family and collapsed to
  `1/12` sealed on the next.** Whether that is intrinsic or an artifact of equal fitness weighting
  is a carried re-test that nobody ran. **Open.**
- **The intervention-vocabulary quotient is empty for hard edits** (16 declared edits, 16 distinct
  actions) and was never re-measured under the non-idempotent vocabulary probe 8 built, where it is
  the natural place for a nonzero answer. **Open, and cheap.**
- **The `u64` context index, not memory, now caps probe 7's scale claim.** Stated in probe 7 and
  unchanged. **Closed by statement, not by work.**
- **No genuine mystery remains about the central thesis.** It was tested where it has content and it
  held there; it was tested where it does not and it tied. That is a complete answer to the question
  C1062 asked, and the open items above are successors rather than gaps in the verdict.

## 10. Recommendation

Probe 9 is a demonstration that the plan itself says must never be counted as evidence, and every
component it would chain — lowering, actual cause, best intervention, design, certificate — is built
and independently replayed. Building it adds a session of work and no evidence. **Recommendation:
close C1062 without probe 9**, and if a demonstration is wanted later, build it against whatever
application actually motivates it rather than against a synthetic incident.

The two items worth an allocated successor, in order: the compositional counterfactual crossover
(probe 7's reduction under probe 4's query), and the certificate-without-compilation question from
section 8. The two core defects in section 7 should be raised against C1017 rather than carried
here.
