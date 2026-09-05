# C1062 probe 4: the level-three counterfactual on the quotient, and the precondition corrected

**Lane**: `complete-ports`
**Task**: C1062, probe 4
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Inputs**: the brief's section 5 claim that "the twin network becomes a path"; probe 1 for the
lowering and its direct-enumeration oracle.
**Code**: `ergodis-private` `f0f3bbf` (`src/causal_counterfactual.rs`, fixtures in
`src/causal_fixtures.rs`, `tasks/tools/src/causal_counterfactual_report.rs`)
**Replay**: `cargo run --release --package ergodis-tools -- causal-counterfactual-report`
**Predeclared threshold**: exact under `O ⊇ E ∪ {Y}`; demonstrably wrong without it.
**Verdict**: **met, and the precondition is corrected in the process.** Two arms are exact and two
give numerically wrong answers, all four as predeclared. The plan's stated precondition `O ⊇ E` is
**sufficient and not necessary**: an arm whose evidence variable is never observed is still exact,
because a declared probe exposes it. The exact condition is two checks, both decidable on the
compiled classes without re-solving the model.

## 1. The question and the model

One query, answered four ways: `P(V3 = 1 under do(V1 := 0) | V0 = 1)`.

One exogenous variable of twelve values, read through `m = u mod 6` so that every class has weight
two and no arm's quotient is the identity by accident. `V0` carries the evidence, `V1` is the
intervention target, `V2` is hidden, `V3` is the observed outcome. Weights are uniform integers and
answers are exact reduced fractions, so a disagreement is a disagreement rather than a rounding
difference. The reference answer is `1/3` in every arm, which the tests gate separately — a fixture
that quietly changed the question would otherwise be indistinguishable from a fixture that found
something.

Only the *declarations* move between the first three arms. The fourth adds one edge, so that the
outcome reads `V0` whenever `V1` is one and a declared probe therefore exposes the evidence variable.

## 2. The result

| arm                     | classes | evidence is a class union | action declared | outcome observed | expressible | direct | quotient | agree |
|-------------------------|---------|---------------------------|-----------------|------------------|-------------|--------|----------|-------|
| observed-evidence       | 6       | yes                       | yes             | yes              | yes         | 1/3    | 1/3      | yes   |
| hidden-evidence         | 3       | **no**                    | yes             | yes              | no          | 1/3    | **0/1**  | no    |
| undeclared-action       | 4       | yes                       | **no**          | yes              | no          | 1/3    | **2/3**  | no    |
| probe-reveals-evidence  | 5       | yes                       | yes             | yes              | yes         | 1/3    | 1/3      | yes   |

Every predeclared verdict holds. The quotient answers come from the compiler's own classes, checked
against the independent direct-enumeration oracle before use.

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

The exact condition has two parts:

1. the evidence set `{u : E(u) = e}` is a union of classes; and
2. the action lies in the declared intervention vocabulary and within the arity bound.

Both are decidable on the compiled classes without re-solving the model, which means a caller can be
*told* whether a counterfactual query is expressible rather than discovering it from a wrong number.
`O ⊇ E ∪ {Y}` remains a useful syntactic sufficient condition and is the right thing to declare when
one is designing the observation set rather than checking a given one.

## 5. Mystery ledger

- **Why does `hidden-evidence` return exactly zero rather than a merely wrong fraction?** Settled: all
  three of its class representatives sit at residues where the hidden variable is zero, so the
  numerator collects nothing. It is an artifact of the representative rule — first context in
  enumeration order — and not a structural fact. A different representative rule would give a
  different wrong answer. **This is worth stating plainly**: the size of the error carries no
  information, only its existence does, and no error bound is available from the quotient.
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
