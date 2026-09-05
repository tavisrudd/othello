# C1062 probe 6: k-ary experiment design, and what a decision needs that identification does not

**Lane**: `complete-ports`
**Task**: C1062, probe 6
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Inputs**: probe 2 for the decision objective (`best_intervention`: the cheapest declared edit
reaching a target observation); probe 3 for the responsibility engine behind blame; probe 5 for the
counterexample-arm baseline.
**Code**: `ergodis-private` `ec5a294` (`src/causal_design.rs`, families in `src/causal_fixtures.rs`,
`tasks/tools/src/causal_design_report.rs`, oracle `python/c1062_design_oracle.py`)
**Replay**: `cd ~/src/ergodis-private && cargo run --release --package ergodis-tools --
causal-design-report`, then `python3 python/c1062_design_oracle.py evidence/c1062-design-tables.json`
**Evidence**: `ergodis-private` `evidence/2026-09-05-causal-design-repaired.txt`, the output of both
commands after the review repairs, and `evidence/c1062-design-tables.json`, the exported tables the
oracle reads. Only the tables were retained when this report was written; the arm table, which is the
only measured content in the probe, existed solely as prose.
**Reviewed**: `2026-09-05-c1062-probe6-review.md`. Corrections from that review are marked
**[corrected]** below and the original text is kept wherever it explains how a number was reached.
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

**[corrected]** "knowing enough to act is precisely knowing everything" is a property of the stopping
criterion this probe implements, not of the family. `ActionSets` keeps, per candidate, the experiments
reaching the target *at that candidate's own minimum edit cost*, and `share_an_action` stops when
those sets intersect — so "decision-sufficient" here means a single action that is simultaneously
**cost-optimal** for every survivor, which is the strongest of the criteria a caller might use. Under
the natural weaker reading the objective's own wording suggests — one action guaranteed to reach the
target under every survivor, priced at what it costs — the same dynamic program over the exported
tables gives:

| family                  | decision experiments, as reported | under "one action that works for every survivor" |
|-------------------------|-----------------------------------|--------------------------------------------------|
| dominant-repair         | 0                                 | 0                                                |
| split-repair            | 2                                 | 1                                                |
| faulty-component        | 3                                 | **2**                                            |
| quaternary-probe        | 1                                 | 0                                                |
| indistinguishable-twins | 1                                 | 0                                                |

So the predeclared loss loses at `1.00x` only under simultaneous optimality; under the hedged reading
it is `3/2 = 1.50x`. With two survivors `{i, j}` the arity-two intervention repairing both components
reaches the target under both at cost `2` where the informed repair costs `1`, and at the declared
probe price (`probe_base = 1`) that trade is an exact tie — two probes plus a cost-two hedged repair,
or three probes plus a cost-one informed repair, both totalling four. The criterion cuts the other way
on two families: on `quaternary-probe` and `indistinguishable-twins` a single cost-two action already
works for every candidate, so a worst-case-cost caller needs zero experiments where this table says
one, and those gaps are understated rather than overstated. The structural gap behind all of this is
that the probe carries two price scales — `probe_costs` for experiments and `edit_costs` for actions —
and never puts them in one objective. Every number in this table is correct for the criterion
implemented, and the criterion should be named wherever the gap is quoted.

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

**[corrected]**, two scope claims in this section.

- "Every number below was predeclared" covers `|H|`, `columns`, `full`, `priced` and `decision`; the
  `gap`, `action classes` and `all share` columns are not predeclared anywhere. Of the § 4
  binarization table only `quaternary-probe` is. And the fixtures carrying the predeclarations, the
  code that measures them and the evidence all landed in a single commit (`4bdc713`), so nothing on
  disk distinguishes entry from result.
- The oracle's independence is real for the dynamic program and does not extend to the model layer:
  it reads the `outcomes` rows out of the JSON rather than re-deriving them, so `solve_into`,
  `observation_of` and `admissible_experiments` are imported wholesale and an error there would be
  invisible to it. It also compares only `full`, `priced` and `decision` per family — the `binary`
  column is printed and never entered into the agreement test, and nothing in § 4, § 5 or § 6 is
  exported at all. "Reproduces every entry" should read "reproduces three entries per family, by a
  different algorithm, on an outcome table it imports". A tautology in the oracle has also been
  removed: for `priced-probes` it used to copy the expected decision value into the measured one and
  call the result an agreement; it now prints `n/a` for the cell it never computed.

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

**[corrected]**, and this is the one place in the probe where a second seed inverts the sentence.
Every ratio above is a single seed, `0x5eed1062`, with no variance and no paired statistic. The report
tool now recomputes the same ratio on forty independent seeds:

| family           | seeds | mean     | min      | max      | w/t/l   |
|------------------|-------|----------|----------|----------|---------|
| dominant-repair  | 40    | `1.0074` | `0.9968` | `1.0180` | 38/0/2  |
| split-repair     | 40    | `1.0214` | `1.0089` | `1.0340` | 40/0/0  |
| faulty-component | 40    | `1.0218` | `0.9955` | `1.0525` | 37/0/3  |
| quaternary-probe | 40    | `1.0000` | `1.0000` | `1.0000` | 0/40/0  |
| priced-probes    | 40    | `1.0814` | `1.0421` | `1.1180` | 40/0/0  |

The separator arm beats uniform sampling among splitting experiments on 40, 40, 38 and 37 of 40 seeds
on the four non-degenerate families. By an exact two-sided sign test that is `p ~ 2e-12` on two
families and `p ~ 2e-7` and `2e-8` on the others: **measurable, and small**. Measured against the
headroom that exists at all — the fraction of the gap between the random-splitting baseline and the
exact optimal arm that the separator recovers — it is a sixth to a half.

Two things follow. The predeclared verdict is unchanged and in fact cleaner: every family lands inside
the `1.10x` band on the seed mean, so the arm misses the informativeness bar everywhere. But "no
measurable teaching signal" is the wrong sentence for it; the correct one is that the separator rule
is **consistently but only marginally better** than uniform sampling among splitting experiments,
recovering a minority of the available headroom and missing the predeclared bar on every family. And
the transfer claim does not hold: after its own review's repairs, probe 5's separator-*pair* arm was a
null with a *negative* lean (`p = 0.180`, per-seed ratios spanning `0.519` to `1.800`), while this arm
is a small positive effect with a near-perfect sign record. Those are different results, not one
result measured twice, so "the second independent measurement of it" is withdrawn.

Two further caveats on the table's five rows. `quaternary-probe` is degenerate: every arm there —
optimal, greedy, uniform-splitting, separator — returns exactly `2.000` on every seed with zero
variance, because every splitting experiment resolves the family in two steps, so the band is tested
on four families rather than five. And the stated range against the straw `uniform` arm, "`2.12x` to
`4.00x`", drops the `priced-probes` row: the five ratios are `3.997`, `3.033`, `2.120`, `3.392` and
`1.949`, so the range is `1.95x` to `4.00x`.

The same table carries a result about the exact machinery that cuts the other way, reported here
because it is the kind of thing this probe exists to catch: **greedy maximum-split matched the exact
optimum on every family, in mean and in worst case.** Optimal decision-tree construction is
NP-hard in general and greedy is only logarithmically approximate, so these six families are simply
too small to separate them. The exact dynamic program's value is demonstrated in its certificate and
in the unresolvable and zero-experiment cases, not in a shorter plan.

**[corrected]** "in mean" is not a comparison against a mean optimum. `DesignPlan::compile` is a
minimax — `worst = worst.max(value)` over blocks, ties broken towards fewer experiments — so the
`optimal` arm walks the *worst-case*-optimal tree and its `mean` column is that tree's mean, not the
minimum achievable mean. A tree with a worse worst case can have a better mean, so greedy tied a tree
that was not trying to win that comparison. The claim stands in worst case, where it is exhaustive
rather than sampled: both arms are deterministic and every candidate is walked as the truth. The same
assumption was baked into `the_optimal_arm_is_never_beaten`, which asserted `mean() >= optimal.mean()`
for every other arm and would have failed for a correct reason on some future family; it now asserts
on the worst case.

**[corrected]** one number outside the published tables moved. `ArmMetrics::mean` divided the sum of
completed runs' steps by *every* run, including runs that hit the step limit and contributed no
steps, which biased the mean down for exactly the arms that fail to finish. It now divides by the
completed runs. The only arm that ever stalls here is the straw `uniform` arm, once in 2,048 runs on
`dominant-repair`, whose mean moves from `12.199` to `12.205`; its `vs splitting` ratio still prints
`0.251x` and no cell of the table in this section changes.

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
  lower bound. **[corrected]** "a balanced-split experiment always available" contradicts the
  arity-bound entry four items down, which says that on `faulty-component` no experiment can split
  three against three. The statement that covers both: on every family the optimum equals the
  information lower bound attainable from the branching factors the declared vocabulary actually
  offers — three for six or eight candidates under binary splits, two for eight candidates under one
  four-way plus one binary split, one for four candidates under a four-way split — and max-split
  greedy attains that bound. The conclusion is unaffected. The families were built to expose stopping-rule behaviour, not to stress tree
  construction, and a family that separates greedy from optimal would need dozens of candidates with
  deliberately unbalanced tests. **Open as a limit of the evidence**: nothing here shows the exact
  dynamic program is worth its cost as a planner.
- **The `priced-probes` separator ratio at `1.103x` against a `1.10x` threshold.** Recorded as a
  miss by three thousandths rather than rounded into a pass. The family has only four candidates and
  two useful experiments, so the arm has almost no room to choose badly; the conclusion does not rest
  on this row and would be unchanged if it had landed at `1.09x`. **Closed as noise, with the number
  stated.** **[corrected]** — closed the right way for the wrong reason. `1.103x` is a high
  single-seed draw: the forty-seed mean is `1.0814` with a range of `1.0421` to `1.1180`, so the
  family passes the band rather than missing it by three thousandths, and the framing invites a reader
  to treat the threshold as knife-edge there when it is not. The explanation given is also backwards —
  `priced-probes` has the **largest** separator effect of any family, not the smallest, and its 40/0/0
  sign record is the most consistent in the table. Reporting the number rather than rounding it was
  the right call and the direction of the error was the safe one.
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
