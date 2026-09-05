# C1062 probe 4: the level-three counterfactual on the quotient, and the precondition corrected

**Lane**: `complete-ports`
**Task**: C1062, probe 4
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Inputs**: the brief's section 5 claim that "the twin network becomes a path"; probe 1 for the
lowering and its direct-enumeration oracle.
**Code**: `ergodis-private` `f0f3bbf` (`src/causal_counterfactual.rs`, fixtures in
`src/causal_fixtures.rs`, `tasks/tools/src/causal_counterfactual_report.rs`)
**Replay**: `cd ~/src/ergodis-private && cargo run --release --package ergodis-tools --
causal-counterfactual-report`
**Evidence**: `ergodis-private` `evidence/2026-09-05-causal-counterfactual-repaired.txt`, the output
of that command after the review repairs. No evidence was retained when this report was written.
**Reviewed**: `2026-09-05-c1062-probe4-review.md`. Corrections are marked **[corrected]** below and
the original reasoning is kept wherever it explains how a number was reached.
**Predeclared threshold**: exact under `O ⊇ E ∪ {Y}`; demonstrably wrong without it.
**Verdict**: **met, and the precondition is corrected in the process.** Two arms are exact and three
give numerically wrong answers, all as predeclared. The plan's stated precondition `O ⊇ E` is
**sufficient and not necessary**: an arm whose evidence variable is never observed is still exact,
because a declared probe exposes it.

**[corrected]** this verdict originally read "two arms … all four as predeclared" and "the exact
condition is two checks". Three things were wrong and § 4 carries the repair: the condition has
**three** parts, the third is not redundant, and a fifth arm has been added that satisfies the other
two and answers `0` against a true `1/3`; the three checks are **sufficient and not necessary**, so
"exact condition" overstated them; and `O ⊇ E ∪ {Y}` is not a sufficient condition on its own, as
this report's own `undeclared-action` row shows.

## 1. The question and the model

One query, answered four ways: `P(V3 = 1 under do(V1 := 0) | V0 = 1)`.

One exogenous variable of twelve values, read through `m = u mod 6` so that every class has weight
two and no arm's quotient is the identity by accident. `V0` carries the evidence, `V1` is the
intervention target, `V2` is hidden, `V3` is the observed outcome. Weights are uniform integers and
answers are exact reduced fractions, so a disagreement is a disagreement rather than a rounding
difference. The reference answer is `1/3` in every arm, which the tests gate separately — a fixture
that quietly changed the question would otherwise be indistinguishable from a fixture that found
something.

Only the *declarations* move between the first three arms and the fifth. The fourth adds one edge, so
that the outcome reads `V0` whenever `V1` is one and a declared probe therefore exposes the evidence
variable.

**[corrected]** the `1/3` guard does not cover that edge. Arm D's outcome differs from arms A–C's
`V1 ∨ V2` in the natural run — `[1,0,0,1,1,1]` against `[1,0,0,1,1,0]` over the six residues — and
under `do(V1 := 1)`, and agrees only under `do(V1 := 0)`, which is the query's action. So the guard
detects a model change visible under this query and arm D makes one deliberately chosen to be
invisible here. The guard still does real work on the other arms; the test comment claiming "the
model is the same in every arm" has been corrected in place.

## 2. The result

| arm                     | classes | evidence is a class union | action declared | outcome observed | expressible | direct | quotient | agree |
|-------------------------|---------|---------------------------|-----------------|------------------|-------------|--------|----------|-------|
| observed-evidence       | 6       | yes                       | yes             | yes              | yes         | 1/3    | 1/3      | yes   |
| hidden-evidence         | 3       | **no**                    | yes             | yes              | no          | 1/3    | **0/1**  | no    |
| undeclared-action       | 4       | yes                       | **no**          | yes              | no          | 1/3    | **2/3**  | no    |
| probe-reveals-evidence  | 5       | yes                       | yes             | yes              | yes         | 1/3    | 1/3      | yes   |
| unobserved-outcome      | 2       | yes                       | yes             | **no**           | no          | 1/3    | **0/1**  | no    |

The last row is **[added by the review]**: observing only the evidence variable makes the evidence
set a union of classes and leaves the action declared, so the two conditions § 4 originally stated
both hold, and the answer is still wrong. No other cell moved.

Every predeclared verdict holds. The quotient answers come from the compiler's own classes, checked
against the direct-enumeration oracle before use — the binary compiles under `SplitTranscript` and
hard-fails if `root_classes` differs from `signature_classes`.

**[corrected]** that cross-check is real and it covers the **classes**; it says nothing about the
**answers**. `direct_answer` and `quotient_answer` differ only in which contexts they visit and how
they aggregate weights: both call `satisfies_evidence` and `outcome_holds`, and both of those call
`model.solve_into`. The reference `1/3` is therefore not independent of the model layer. That
independence was supplied after the fact by a from-scratch Python re-derivation that reproduces
every arm's class vector, all three checks and both answers; see
`2026-09-05-c1062-probe4-review.md` § 2.5.

**The negative half is the deliverable.** `hidden-evidence` returns zero where the truth is one third,
and `undeclared-action` returns two thirds where the truth is one third — one an underestimate to the
point of vanishing, one an overestimate by a factor of two. Neither is a near miss, and neither
announces itself: both are well-formed fractions that a caller would have no reason to distrust. That
is what converts the brief's assertion into a statement with a precondition attached.

## 3. Two failure modes, and they are genuinely different

**Abduction fails when the evidence set splits a class.** In `hidden-evidence` the observation set is
the outcome alone, so the three classes are `{m in 0,3}`, `{m in 1,2}`, `{m in 4,5}`, and the evidence
`V0 = 1` holds at `m in {1,3,4}` — which cuts across all three. The class-representative procedure
therefore takes whole class weights on the strength of one representative's evidence value, and the
representatives happen to answer the outcome question the wrong way, giving zero.

**Prediction fails when the action is outside the declared vocabulary.** In `undeclared-action` the
evidence variable *is* observed, so abduction is fine, but the only intervenable variable is `V0`, so
nothing in the declared vocabulary distinguishes `m = 3` from `m = 4`. Those two sit in one class with
opposite outcomes under `do(V1 := 0)`, the representative votes for one of them, and the class's whole
weight follows it.

These are separate conditions on separate halves of the abduction–action–prediction pipeline, and a
single check would have hidden one of them. Both are cheap: `evidence_is_class_union` is one pass over
the contexts against the class labels, and `action_is_declared` is a lookup in the declared
intervenable set and arity bound.

## 4. The precondition, corrected

The plan wrote the precondition as `O ⊇ E`. That is **sufficient and not necessary**, and the
`probe-reveals-evidence` arm is the counterexample: `V0` is not in the observation set at all, and the
query is still exact. The reason is that `do(V1 := 1)` makes the outcome read `V0`, so the class data
already determines the evidence, and the evidence set is a union of classes even though the evidence
variable is invisible in the natural run.

**[corrected]** this section originally opened "The plan wrote the precondition as `O ⊇ E`" — the
plan and this report's own header say `O ⊇ E ∪ {Y}` — and then derived a two-part condition from the
two-part restatement. The `{Y}` dropped in the first sentence is the check dropped in the third.

Three checks are jointly **sufficient**:

1. the evidence set `{u : E(u) = e}` is a union of classes;
2. the action lies in the declared intervention vocabulary and within the arity bound; and
3. the outcome variable is observed.

Check 3 is not redundant. Check 2 buys "the class determines `O(u, action)`", because a declared
action's support is one of the supports the signature enumerates; it takes `Y ∈ O` to turn that into
"the class determines `V_Y` under the action". Drop it and the `unobserved-outcome` arm returns `0`
against a true `1/3`.

All three are decidable on the compiled classes, which means a caller can be *told* whether a
counterfactual query is expressible rather than discovering it from a wrong number. **[corrected]**
"without re-solving the model" is true in principle and false of the code: `evidence_is_class_union`
calls `solve_into` once per context.

They are **sufficient and not necessary**, so they are conservative rather than exact. An
inexpressible query can be exact by accident: on the `undeclared-action` model,
`P(V3 = 1 under do(V2 := 1) | V0 = 1)` has the evidence a class union and the outcome observed, fails
only the declared-action check, and both sides answer `1`. Sweeping every single-variable evidence,
action and outcome triple over the arm models turns up 768 such combinations. A caller told
"inexpressible" learns that the quotient carries no guarantee, not that the answer is wrong — which
is the claim this probe earned and the more useful one for the API it proposes.

**[corrected]** `O ⊇ E ∪ {Y}` is **not** a sufficient syntactic condition, and this report's own
third row refutes it: the `undeclared-action` arm observes exactly `E ∪ {Y}` and returns `2/3`
against `1/3`. It covers checks 1 and 3 and says nothing about check 2. The correct syntactic
condition is `O ⊇ E ∪ {Y}` **together with** the action lying in the declared vocabulary within the
arity bound. As originally written this sentence told a reader designing an observation set that a
declaration this probe measured to be wrong was safe.

## 5. Mystery ledger

- **Why does `hidden-evidence` return exactly zero rather than a merely wrong fraction?**
  **[corrected] the original answer was wrong on its facts and its conclusion inverts under
  measurement.** It read: "all three of its class representatives sit at residues where the hidden
  variable is zero … A different representative rule would give a different wrong answer." The
  representatives are contexts 0, 1 and 4, at residues 0, 1 and 4; `V2` is **one** at residue 0 and
  zero at the other two. Two of three have `V2 = 0`; the third is excluded earlier, at abduction,
  because `V0 = 0` at residue 0. And enumerating every choice of one representative per class:

  | arm | attainable answers | contains the truth `1/3`? |
  |---|---|---|
  | observed-evidence | `{1/3}` | yes, and it is the only value |
  | hidden-evidence | `{0, 1/3, 1/2, 1, undefined}` | **yes** |
  | undeclared-action | `{0, 2/3}` | **no** |
  | probe-reveals-evidence | `{1/3}` | yes, and it is the only value |
  | unobserved-outcome | `{0, 1}` | **no** |

  Three consequences the original missed. The two expressible arms are exact under *every*
  representative rule, which is the empirical shadow of the sufficiency argument and better evidence
  for it than the single shipped run. The two failure modes are not symmetric: the abduction failure
  is representative-shaped — some rules give the right answer, some give undefined — while the
  prediction failure is structural, since no rule reaches `1/3`. And "the size of the error carries no
  information, only its existence does" is right and can now be said sharply: the attainable set is
  computable from the classes, its diameter is the error bound, and for `undeclared-action` it
  excludes the truth entirely. The report tool prints this table. See
  `2026-09-05-c1062-probe4-review.md` § 2.7.
- **The representative rule is a choice, and the probe measures one choice.** A caller might instead
  weight each class by the fraction of its contexts satisfying the evidence — but that fraction is
  exactly the information the quotient discarded, so the alternative is not available without going
  back to the contexts. **Closed by argument, not by measurement**: no class-level procedure can
  recover it, because two contexts in one class are indistinguishable by construction.
- **Nothing here measures the brief's actual sales pitch.** "The twin network becomes a path" is a
  statement about the *cost* of the counterfactual, and this probe measured correctness, not cost.
  Probe 2's structural result makes a cost win unlikely on the flat carrier, and the open successor is
  whether the compositional reduction of probe 7 changes that, since a counterfactual over a reduced
  exogenous alphabet is a strictly smaller abduction. **Open, and it is the natural crossover.**
- **The four arms share one model and one query by design.** That is what makes the comparison clean,
  and it is also the limit of the evidence: these are four declarations over one twelve-context model,
  not a family. The preconditions are proved by the argument in section 3 and *illustrated* here.

## 6. Next

Probes 5 (Evolve proposes, separator refutes), 6 (k-ary experiment design and decision equivalence)
and 9 (the gated end-to-end demonstration) remain. Probe 6 depends on probe 2 for its decision key
and on this probe for nothing; probe 5 is the one that would exercise the separating-intervention
witness as a counterexample oracle, which is the claim the brief rests most weight on and which
nothing has yet tested.
