# C1062 probe 6: k-ary experiment design, and what a decision needs that identification does not

**Lane**: `complete-ports`
**Task**: C1062, probe 6
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Inputs**: probe 2 for the decision objective (`best_intervention`: the cheapest declared edit
reaching a target observation); probe 3 for the responsibility engine behind blame; probe 5 for the
counterexample-arm baseline.
**Code**: `ergodis-private` `ec5a294` (`src/causal_design.rs`, families in `src/causal_fixtures.rs`,
`tasks/tools/src/causal_design_report.rs`, oracle `python/c1062_design_oracle.py`)
**Replay**: `cargo run --release --package ergodis-tools -- causal-design-report`, then
`python3 python/c1062_design_oracle.py evidence/c1062-design-tables.json`
**Predeclared threshold**: a measured gap between full and decision-sufficient identification, plus a
near-zero gap on a family predeclared to need full identification.
**Verdict**: **met on both halves, and the equivalence in the probe's title turns out not to exist.**
The gap is real and ranges from nothing to unbounded; the predeclared loss loses exactly as
predicted at `1.00x`; and decision-sufficiency is **not** an equivalence relation on hypotheses, so
the "decision equivalence" the plan asked for cannot be a quotient at all. Two side measurements
came out against expectation in useful ways: binarizing a `d`-ary experiment is free when the answer
was binary anyway and costs the full branching factor when it is not, and the exact dynamic program
bought nothing over greedy on any family here.

## 1. What was built

An experiment and an action are the same object — an admissible intervention on a shared model
signature — so one table serves both layers. Its columns are the interventions within the declared
vocabulary and arity bound; its rows are the candidate mechanism tables; its entries are packed
observations, which are `d`-ary values rather than yes/no bits. That is the whole reason this is a
new module rather than an adapter over the core's `query_design.rs`, which encodes a test as a
hypothesis bitmask and can therefore only ask binary questions.

Two stopping rules run over one exact dynamic program:

1. **full identification** stops when one candidate survives; and
2. **decision-sufficient identification** stops as soon as the survivors share an optimal action,
   which is the point at which a caller can act optimally without knowing which candidate is true.

The dynamic program is minimax over hypothesis subsets, iterating masks in increasing numeric order.
That order is valid because every block of a useful experiment is a strict subset of the mask it
splits, so there is no recursion and no memoization structure beyond one flat array. It emits an
adaptive design as a certificate, which a separate verifier replays: it recomputes every node's
branches from the outcome table, checks every leaf against the stopping predicate, and walks each
candidate from the root, so the reported depth and cost are measured during replay rather than
copied from the plan. A corrupted certificate — one relabelled experiment, one deleted branch — is
rejected, and that is a test rather than a claim.

## 2. The six families and their numbers

Every number below was predeclared before the run and every one held. Counts are worst case;
`priced` is the worst-case cost under declared probe prices rather than an experiment count.

| family                  | \|H\| | columns | full | priced | decision | gap    | action classes | all share |
|-------------------------|-------|---------|------|--------|----------|--------|----------------|-----------|
| dominant-repair         | 8     | 33      | 3    | 3      | 0        | ∞      | 8              | yes       |
| split-repair            | 7     | 19      | 3    | 3      | 2        | 1.50x  | 7              | no        |
| faulty-component        | 6     | 73      | 3    | 3      | 3        | 1.00x  | 6              | no        |
| quaternary-probe        | 8     | 9       | 2    | 2      | 1        | 2.00x  | 2              | no        |
| indistinguishable-twins | 4     | 9       | none | none   | 1        | —      | 3              | no        |
| priced-probes           | 4     | 19      | 1    | 2      | —        | —      | —              | —         |

`faulty-component` is the predeclared loss and it lost: exactly one component is faulty and only its
own repair fires the outcome, so the optimal actions are pairwise disjoint singletons and knowing
enough to act is precisely knowing everything. The gap is exactly one, as entered.

The two ends of the range matter more than the middle. In `dominant-repair` the decision is free —
one repair is optimal under every candidate, so no experiment is worth running — while identifying
the truth still takes three. In `indistinguishable-twins` two candidates differ only in a variable
nobody observes, so **identification is impossible and the decision still takes one probe**. The
decision layer is therefore not merely a discount on identification; it answers questions
identification cannot answer at all.

An independent Python oracle reproduces every entry. It memoizes top down over frozen hypothesis
sets where the Rust program iterates flat over subset indices, and it rebuilds the optimal-action
sets and both stopping predicates from the exported table rather than importing them, so the
agreement is between two algorithms and not two spellings of one.

## 3. Decision equivalence does not exist, and the intersection does

The plan asked for a quotient by decision equivalence. The natural candidate — candidates with the
identical set of optimal actions — is an equivalence relation, gives a tidy quotient, and is the
wrong object. `dominant-repair` is the counterexample and it is not a corner case: all eight
candidates have distinct optimal-action sets, so the quotient is the identity and predicts that
identification cannot be shortened, while in fact they all share one action and the decision needs
**zero** experiments.

The correct stopping predicate is that the survivors' optimal-action sets have a common element.
That predicate is not transitive: with sets `{a}`, `{a, b}`, `{b}`, the first two stop together and
the last two stop together while the outer pair must be separated — and `split-repair` contains
exactly that configuration, verified in the tests. **So no equivalence relation on hypotheses can
express when a decision may stop.** What the predicate does have is downward closure — a subset of a
decidable set is decidable — which is checked exhaustively over one family and is exactly the
property the dynamic program needs. The carried plan item that the decision key "cannot be the class
key" is therefore settled in a stronger form than it was raised: the obstruction is not that the
class key is a poor invariant, it is that the object is not a partition.

## 4. Binarizing a `d`-ary experiment: conditional, and the condition is visible

| family                  | k-ary | binary | ratio |
|-------------------------|-------|--------|-------|
| dominant-repair         | 3     | 3      | 1.00x |
| split-repair            | 3     | 3      | 1.00x |
| faulty-component        | 3     | 3      | 1.00x |
| quaternary-probe        | 2     | 4      | 2.00x |
| indistinguishable-twins | none  | none   | —     |
| priced-probes           | 1     | 2      | 2.00x |

The plan asserted that binarizing overcounts. The measurement makes that conditional and names the
condition: binarizing costs nothing when the observation is already binary, and costs the full
branching factor when it is not. The mechanism is that the binary encoding available from a `d`-ary
experiment is the family of per-value indicators "did the answer equal `v`", and those peel one
block at a time, so a `b`-way split becomes `b - 1` questions in the worst branch rather than
`log2 b`. A design allowed arbitrary binary tests over unions of blocks would not pay this; a
bitmask query design handed a `d`-ary experiment does. Both families with a four-valued answer land
at exactly `2.00x`, which is that mechanism and not a coincidence.

`priced-probes` separates price from length in the same spirit: the shortest design asks one
expensive question and pays ten, the cheapest design asks two cheap ones and pays two, and the two
plans differ in their first experiment. Cost is not a rescaling of the count.

## 5. The separating experiment is not the informative choice — the same verdict as probe 5

Probe 5 found separating interventions no better than a uniformly sampled violated pair as a
counterexample oracle. The design analogue is an experiment chosen to separate a uniformly sampled
still-confused pair, and the question is whether that choice teaches anything.

The baseline has to be chosen carefully. Sampling uniformly over *every* admissible intervention is
a straw man: it pays for questions that cannot make progress at all, and the separator arm never
picks one of those, so a win against it would measure "avoids useless questions" rather than
"chooses well among useful ones". Against that weak baseline the separator arm looks excellent, at
`2.12x` to `4.00x`. Against uniform sampling among the experiments that actually split the
survivors — the fair baseline, predeclared with a `1.10x` threshold — it collapses:

| family           | optimal | greedy | uniform-splitting | separator | separator vs splitting |
|------------------|---------|--------|-------------------|-----------|------------------------|
| dominant-repair  | 3.000   | 3.000  | 3.059             | 3.052     | 1.002x                 |
| split-repair     | 2.857   | 2.857  | 2.999             | 2.933     | 1.023x                 |
| faulty-component | 2.667   | 2.667  | 3.097             | 2.990     | 1.036x                 |
| quaternary-probe | 2.000   | 2.000  | 2.000             | 2.000     | 1.000x                 |
| priced-probes    | 1.000   | 1.000  | 1.610             | 1.460     | 1.103x                 |

Four families land inside the predeclared `1.10x` band and the fifth misses it by `0.003`. The
verdict is the predeclared one: **choosing an experiment because it separates a sampled confused
pair carries no measurable teaching signal once the baseline is restricted to experiments that make
progress.** Probe 5's finding transfers to the design layer, which is the second independent
measurement of it and the reason to stop treating the separating witness as the valuable part of
the machinery. What is valuable is the certificate, which is one-sided in neither direction and
replays.

The same table carries a result about the exact machinery that cuts the other way, reported here
because it is the kind of thing this probe exists to catch: **greedy maximum-split matched the exact
optimum on every family, in mean and in worst case.** Optimal decision-tree construction is
NP-hard in general and greedy is only logarithmically approximate, so these six families are simply
too small to separate them. The exact dynamic program's value is demonstrated in its certificate and
in the unresolvable and zero-experiment cases, not in a shorter plan.

## 6. Blame

Blame is the prior-weighted expectation of the degree of responsibility over an epistemic state, and
a hypothesis family with an integer prior *is* an epistemic state, so the formula applies rather than
an analogue of it. On the uncertain forest fire — one context in which both lightning and the
dropped match occur, and two candidate mechanisms — lightning has degree `1/1` when the fire needs
both causes and `1/2` when either suffices. A uniform prior gives blame `3/4` and a `1:3` prior gives
`5/8`, both exact rationals and both predeclared. Neither candidate produces the blame value, which
is the point: blame is a property of the family, not of any model in it.

## 7. Mystery ledger

- **Why did greedy never lose?** Settled by argument rather than by measurement: with at most eight
  candidates and a balanced-split experiment always available, the greedy tree hits the information
  lower bound. The families were built to expose stopping-rule behaviour, not to stress tree
  construction, and a family that separates greedy from optimal would need dozens of candidates with
  deliberately unbalanced tests. **Open as a limit of the evidence**: nothing here shows the exact
  dynamic program is worth its cost as a planner.
- **The `priced-probes` separator ratio at `1.103x` against a `1.10x` threshold.** Recorded as a
  miss by three thousandths rather than rounded into a pass. The family has only four candidates and
  two useful experiments, so the arm has almost no room to choose badly; the conclusion does not rest
  on this row and would be unchanged if it had landed at `1.09x`. **Closed as noise, with the number
  stated.**
- **Nothing in this probe uses the Ergodis compiler.** The design layer runs on the outcome table
  directly, built by solving each candidate under each intervention. That is worth stating plainly
  because the task is about the contextual quotient: the table here is probe 1's signature
  construction transposed — probe 1 groups *contexts* by their row of observations under every
  admissible intervention, and this probe groups *hypotheses* by exactly the same kind of row.
  Identification over candidate models is the mirror image of the quotient over exogenous contexts,
  on the other index of the same matrix. **Open, and it is the natural crossover**: whether the
  compiled machinery buys anything on the hypothesis index, given that probe 2 measured it buying
  nothing on the context index for the flat carrier.
- **Adaptivity buys at most one experiment here.** The exhaustive nonadaptive optimum equals the
  adaptive one on every family except `faulty-component`, where it is four against three. Small
  families again; the gap is known to grow, and nothing here measures where. **Open, unmeasured.**
- **The arity bound is doing quiet work in `faulty-component`.** With six components and arity two,
  no experiment can split three against three, which is why the count is three rather than the
  information-theoretic 2.58. The number reported is a property of the declared vocabulary, not of
  the family, and every count in section 2 should be read that way. **Closed by statement.**

## 8. Next

Probe 9, the gated end-to-end demonstration from incident to minimal repair, is the only probe left
in the plan. It is gated on probes 2 and 3, both done, and it must never be counted as evidence. The
decision layer it needs now exists in the form probe 6 built: a stopping rule that is a covering
condition rather than a quotient, an exact plan with a replayable certificate, and blame over a
family for the attribution half.
