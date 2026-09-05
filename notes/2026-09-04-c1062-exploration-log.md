# C1062 exploration log: structural causal models in Ergodis

**Lane**: `complete-ports`
**Brief**: `2026-09-04-c1062-ergodis-causal-brief.md`
**Plan review**: `2026-09-04-c1062-plan-review.md` (adversarial; this plan is its revision)
**Code**: `~/src/ergodis-private` (core changes, if any, in `~/src/ergodis`)
**Status**: probes 0, 1a, 1, 3 and 2 done; probe 7's novelty argument is written
(`2026-09-04-c1062-probe7-novelty-argument.md`) and probe 7 is unblocked.

This is the routing document for C1062. The task asks whether a finite structural causal model
(SCM) is another context language for the Ergodis contextual quotient, and what that buys: exact
causal abstraction with separating interventions as counterexamples, an exact Halpern–Pearl
actual-causality and responsibility engine, exact best-intervention search over the compiled
quotient, an experiment-design layer over a bounded hypothesis family, and an Evolve loop that
names the quotient classes. Each probe gets its own dated report; this file carries only the probe
index, standing results, process rules, and the next step. Reports are the authority for numbers.

**This plan is revision two.** The first version rested on a lowering that is ill-typed, and the
adversarial review killed it. What changed is recorded in the next section, because the correction
is the most important content in the file.

## The lowering, corrected

The first plan said: state is the exogenous assignment `u`, generators are atomic interventions
`do(V := a)`, so forty generators replace `3^20` interventions. That is wrong. A generator in
`observational.rs` is a total map from states to states, and `do(V := a)` applied to `u` is a
solution of a *different model*; it is not an element of `U`. The generator has nowhere to land.
The exception is interventions on root variables only, where pinning a root is re-assigning its
exogenous value and `U` is closed — but the plan's own fixtures intervene on non-roots.

The forced repair: **state is the pair `(u, I)`**, where `I` is the current partial assignment of
pinned variables, later overriding earlier. Generators are total on that carrier. The consequences
are all bad for the original claim and must be carried openly:

- **The exponential moves from the vocabulary into the compile.** Materialized states number
  `|U| · ∏_V (|D_V| + 1)`. The forty-generator observation is true of the *vocabulary* and false of
  the *compile*. Probe 2 reports the materialized `(u, I)` count as raw states, never `|U|`.
- **The escape is an arity bound.** Restrict to interventions of arity at most `k`, expressed as
  the sort structure (states `|U| · Σ_{j ≤ k} C(n, j) d^j`) or as a `FiniteContextLanguage` over
  generator words. `continuation.rs` then gives the refinement tower `~_{≤1} ⊇ ~_{≤2} ⊇ …` for
  free. The tower need not stabilize — a threshold-`t` outcome keeps refining until arity near `t`
  — so stabilization is a reported object, not a stopping rule.
- **Word closure is vacuous for hard interventions.** Override composition is idempotent and
  commutative on distinct variables, so every word reduces to its final partial assignment and the
  reachable set from `u` is exactly `{(u, I)}`. Therefore `u ~ u'` iff `O(M_I(u)) = O(M_I(u'))` for
  every admissible `I` — a one-pass signature partition, which refinement recomputes at the same
  asymptotic cost. **The compiler's contribution is not the quotient on `U`.** It is (a) the uniform
  separator certificate and (b) the congruence on the intervened states `(u, I)`, which is the
  monoid action on `Q` and the thing that prunes the contingency search in probe 3.
- **The thesis has content only where the context alphabet is genuinely sequential**: unrolled
  time-indexed models, observe-then-act sequences in the epistemic layer, and non-idempotent
  operations such as soft or shift interventions. Probe 8 tests the first of those, deliberately.
- **"Generator" widens to "declared atomic mechanism edit"**, not just value assignment, so that
  disable-block, force-signal, and policy interventions `do(V := g(pa(V)))` are expressible. Each
  is still a total typed map from a declared finite set. The linear-vocabulary statement then reads
  "linear in the declared edit set", which is what it should always have said.
- **The observation is a declared query-relevant variable set, not just the outcome.** Level-3
  abduction needs the evidence set to be a union of classes, which holds iff `O ⊇ E`; actual-cause
  verdicts need the actual values of the cause and candidate contingency variables. With `O` equal
  to every endogenous variable on a root-exogenous model the quotient is the identity. So `O` is a
  dial from coarse to trivial, and `|Q|` must be reported as a function of `|O|`.

**What the compiled relation actually is.** With `O` = declared outcome, it coarsens the *exogenous*
space with endogenous variables and vocabulary unchanged — Beckers–Halpern's `τ` is the identity on
endogenous settings and the commuting square is trivial. It is closest to targeted reduction of
causal models. With `O` = all endogenous variables and the full `do(pa(V) := p)` vocabulary on a
canonical exogenous space, it is **exactly Balke and Pearl's 1994 response-function partition**.
That is a known object, a mandatory correctness fixture, and a novelty risk. Beckers–Halpern
variable-merging abstraction ("these 27 states are one causal variable") lives on a different
carrier — endogenous settings — and there `(u, I)` is strictly *finer*, since it remembers whether
`V = 1` is natural or pinned. The full atomic vocabulary is also exactly what makes nontrivial
merges impossible, which is why Beckers–Halpern restrict the allowed intervention set. **The
linear-vocabulary claim and the interesting-abstraction claim pull in opposite directions**, and no
probe may quietly claim both.

## Probe index

| Probe | Name                                                | Size | Predeclared threshold | Verdict | Report |
|-------|-----------------------------------------------------|------|-----------------------|---------|--------|
| 0     | Prior-art and landscape audit                       | S    | every landscape claim in the brief resolved or discarded | **done**: engines exist, no probe cut; responsibility formula corrected; probe 7 gains a near neighbour | `2026-09-04-c1062-probe0-prior-art-and-landscape-audit.md` |
| 1a    | Pencil: carrier, cost model, signature collapse     | S    | closed-form state count; collapse stated and proved | **done**: viable but narrow; envelope `\|U\| ≲ 10^4` at arity 2–3; probe 7 promoted | `2026-09-04-c1062-probe1a-carrier-and-cost-model.md` |
| 1     | Lowering, oracle, Balke–Pearl fixture, towers       | M    | class-for-class agreement on the response-function fixture | **done**: 60 contexts to 32 classes, all three gates pass; contract one-quarter delivered | `2026-09-04-c1062-probe1-lowering-and-towers.md` |
| 2     | **Best intervention, and the economics that follow** | L    | compiled beats memoized re-solve on the enumeration query, residual compression above the orbit baseline | **done**: compression passes (4.97x, 2.00x), timing fails structurally; quotient worth 220x over concrete-state search | `2026-09-04-c1062-probe2-best-intervention-and-economics.md` |
| 3     | Exact actual causality and responsibility           | L    | verifier work under 10% of search; published verdicts matched | **done**: all eight published verdicts reproduced; certificate missed 10% at a 55-candidate scale; not closed | `2026-09-04-c1062-probe3-actual-cause-and-responsibility.md` |
| 4     | Level-3 counterfactual and the observation precondition | M | exact under `O ⊇ E ∪ {Y}`; demonstrably wrong without it | planned | — |
| 5     | Evolve proposes, separator refutes                  | M    | seals to the exact kernel, and beats the random-counterexample arm on generations | planned | — |
| 6     | k-ary experiment design and decision equivalence    | M    | measured gap between full and decision-sufficient identification, plus a near-zero gap on the negative family | planned | — |
| 7     | Compositional lowering along the DAG                | L    | composed quotient equals the flat one on small models | **unblocked**: novelty argument written; variable merging declined, factored exogenous carrier kept | `2026-09-04-c1062-probe7-novelty-argument.md` |
| 8     | Unrolled sequential window                          | S    | word closure non-vacuous, measured | planned | — |
| 9     | End-to-end: incident to minimal repair              | L    | demo only, never counted as evidence | gated on 2 and 3 | — |

Sizes are relative within one fast session: S is under an hour, M is one to three, L is a session.
Gating: `0 ∥ 1a → 1 → {2, 3, 4, 5, 8} → {6, 7} → 9`. Probe 3 depends on probe 2 only for the
class-pruning machinery, which probe 3 owns.

**Probe 1a is complete and changes the shape of what follows.** The flat lowering is viable but the
envelope is narrow: memory is dominated by the generator transition tables at about `4(nd + 1)`
bytes per state, which caps the carrier near `1.2 × 10^7` states for twenty binary variables, so
`|U| · Σ_{j≤k} C(n,j) d^j` must fit that — roughly `|U| ≲ 10^4` at arity two or three. The exogenous
alphabet is the wall: a declared failure vector over fourteen components fits, a canonical
response-function exogenous space does not, by orders of magnitude. Four consequences are folded
into the probes below: probe 7 is promoted from gated to expected, the Balke–Pearl fixture is fixed
at `n ≤ 4` as a correctness gate rather than a scaling result, relevance pruning moves into the
lowering itself, and probe 1 must report the materialized state count and transition-table bytes
rather than `|U|`.

## Probe 0 — prior-art and landscape audit

**Questions.** (a) Is coarsest-exact-causal-abstraction-by-partition-refinement, with a separating
intervention as the refutation witness, already published? (b) Does a mature engine for
Halpern–Pearl actual causality exist? (c) What is the exact responsibility formula for the variant
implemented in probe 3?

**Why first.** Probe 3 is session-sized and its framing rests entirely on (b). I now expect the
answer to (b) to be **yes** — Ibrahim and Pretschner's HP2SAT (2019) and their ATVA 2020 MaxSAT/ILP
formulation, which includes responsibility. The brief's "no mature fast engine" line came from
unverified generated text and should be treated as probably false until checked. Write the
consequence branch before running: if an engine exists, probe 3's claim narrows from "the first
exact engine" to "a compiled, certificate-carrying engine versus a per-query SAT or ILP encoding",
which is a different and much more defensible claim, and probe 3 keeps its value.

**Method.** Bounded audit under `notes/literature-audit-conventions.md`, cache first. Targets:
Balke–Pearl 1994 response functions; Rubenstein et al. 2017; Beckers–Halpern 2019;
Beckers–Eberhardt–Halpern 2019; Rischel–Weichwald 2021; Geiger et al. 2021 and 2023; Zennaro et al.
2023; Massidda et al. 2023; Kekić et al. on targeted reduction; Halpern's *Actual Causality* chapter
6 for the responsibility denominator under the modified definition; Chockler–Halpern 2004;
HP2SAT and Ibrahim–Pretschner; ChiRho's causal-explanation module; and — because the compiled
object is bisimulation of the interventional labelled transition system — Kanellakis–Smolka and
Paige–Tarjan. Every unverified landscape claim in brief section 1 is resolved or discarded.

**Deliverable.** A dated audit note, per source, with the exact searched domain and stop condition
for every negative, plus the written consequence branch for (b).

## Probe 1a — pencil probe

**No code.** One page establishing: the closed carrier and why `state = u` fails; the materialized
state count as a function of `(|U|, n, d, k)`; the signature-collapse statement for hard
interventions and its proof; the arity-bounded sort structure and the alternative
`FiniteContextLanguage` encoding; and the explicit list of what the compiler adds beyond a one-pass
signature partition.

**Why it exists.** The review's central finding is that probe 1 as originally written could not
fail. This probe decides, before any lowering code, whether probe 1 is an adapter worth building or
an infrastructure step whose value is entirely downstream. Under an hour.

**Kill criterion.** If the arity-bounded state count is impractical at every `k` that produces a
non-trivial quotient, the flat lowering is dead and the spike jumps straight to probe 7's
compositional route.

## Probe 1 — lowering, oracle, and the response-function fixture

**Deliverable, not a verdict.** A tier-1 `causal` module in `ergodis-private`: a typed
`CausalPresentation` (variables, domains, mechanism tables, declared query-relevant observation set,
declared atomic edit set, arity bound) and a total lowering onto `FinitePresentation` over the
`(u, I)` carrier. A `c1062` subcommand on the lane crate; no new `src/bin`.

**Correctness gates, in order of strength.**

1. **The Balke–Pearl fixture, which is external truth rather than a self-written oracle.** Compile
   a canonical-exogenous model with `O` = all endogenous variables and the full `do(pa(V) := p)`
   vocabulary; the resulting classes must agree class-for-class with the product of per-variable
   response-function partitions. **Fixed at `n ≤ 4`**: probe 1a's cost model puts `n = 4` with at
   most two parents per variable at about `5.3 × 10^6` states and `n = 5` at `2.5 × 10^8`, out of
   reach. The report must say this is a correctness gate, so that nobody later reads the small
   fixture as a scaling failure. Probe 0 confirmed the construction is real and in the 1994 paper in
   the form assumed here, with credit running back to Pearl 1993a, and added one clause: the
   published construction partitions **per exogenous variable** and forms the canonical space as a
   product, so if the fixture has an exogenous variable feeding more than one endogenous variable,
   the expected object is the joint partition induced by the tuple of response functions rather than
   the product. State which case the fixture is in.
2. An independent Python oracle that enumerates *partial assignments directly* — not "words up to
   the diameter", which would import the compiler's own view and turn a shared misreading into an
   agreement.
3. Separating interventions printed for every separated pair and replayed by that oracle.

**Measurements that ship with it** (these were missing and are cheap): `|Q|` as the observation set
`O` grows from outcome to every variable, and the arity tower `~_{≤1} ⊇ ~_{≤2} ⊇ …` from
`continuation.rs`. These are the only numbers that tell a user which declaration to make.

**One positioning sentence for the report, from probe 0.** With `O` = declared outcome, the compiled
relation is the exact combinatorial counterpart of Kekić, Schölkopf and Besserve's Targeted Causal
Reduction (UAI 2024), which learns an approximate target-specific reduction from interventional
simulation data. Exact versus learned is the honest distinction and it is a good one.

**Two requirements from probe 1a.** Relevance pruning belongs in the lowering itself, not in the
measurement: exogenous variables that are not ancestors of the observation set factor out of
`Val(U)` and must be dropped before the carrier is built. And the report states the materialized
state count `|U| · Σ_{j≤k} C(n,j) d^j`, the transition-table bytes, and the per-state constant
`4(nd + 1)` — never `|U|` as "raw states", which understates the compile by orders of magnitude.

**Kill criterion, restated so it can fire.** The report must deliver probe 1a's four-item contract
for what the compiler adds beyond the signature partition — the congruence on intervened states,
replayable separators, the arity tower from layered scheduling, and non-vacuity under a
non-idempotent edit vocabulary — and the response-function fixture must agree class-for-class.
"Partitions agree with my own oracle" is not a result.

## Probe 2 — best intervention, and the economics that follow

**This is now the spine of the task.** Tavis's direction after probe 3: the decision layer is what
to lean into. That agrees with the adversarial plan review, which called the missing optimization
probe the largest faithfulness gap in the original plan. Actual causality becomes an *input* to this
layer rather than the headline — a minimal contingency is what turns "this failed" into "this is the
smallest change that would have prevented it", which is a decision rather than an attribution.

**This probe was missing.** The brainstorm's proposal 6 is optimization over interventions, Ergodis
is an exact optimization compiler, and the first plan contained no optimization probe — while
probes 6 and 9 silently depended on one. It is also the query where compilation plausibly pays: a
warm-query race between one class lookup and one re-solve of a twenty-variable model is a race the
re-solve wins in nanoseconds.

**The query.** `best_intervention`: the minimum-cost declared edit (or minimum-arity intervention)
reaching a declared outcome, and "does any intervention of arity at most `k` reach `o`?". Computed
first by direct enumeration, then as a search over the monoid action on `Q`. Second half: minimax
regret over a small set of candidate models.

**Economics, with the three baselines the review demands.** Report classes against `|U|`, against
`|U|` after pruning non-ancestors of the outcome, and against the orbits of the declared
automorphism group; count only the residue as intervention-driven compression. Relevance pruning
and component interchangeability compress for free, and in the reliability family the classes are
just the failed-count orbits — reporting that as a win would be self-deception. The baseline for
timing is a **memoized** re-solve, not a naive one. Predeclare each family's verdict under
`ergodis/docs/ergodis-shape-classifier.md` before building it, including at least one predicted
loss; a predicted loss that loses is a pass.

**Also folded in here:** the intervention-vocabulary quotient, `i_1 ~ i_2` when they induce the same
map on `Q`, reported as `|J|` against the declared edit set. It is a one-line measurement, not the
grand claim it was in revision one.

**Kill criterion.** The compiled form does not beat memoized enumeration on the enumeration query,
or the residual compression above the orbit baseline is negligible.

## Probe 3 — exact actual causality and responsibility

**The native problem, restated correctly.** Revision one stated the search as minimum `W` for a
fixed singleton cause. That is wrong for the modified Halpern–Pearl definition it also said to
implement first: a variable can be part of a **conjunctive** cause, and the disjunctive forest fire
— in the fixture list — is exactly that case, where neither lightning nor match is a cause alone
while the conjunction is. The search ranges over `(X', W, x')` with `X ⊆ X'`.

**The responsibility formula, settled by probe 0, and it was a correctness bug.** Implement

```
dr(X = x, φ)  =  1 / (|X'| + |W|)
```

minimised jointly over the (cause, witness) pairs in which the queried variable is a conjunct
(Ibrahim 2021 dissertation, Definition 2.5; corroborated by Ibrahim–Pretschner ATVA 2020
Definition 3 and Triantafyllou et al. AIES 2022 Definition 4.1). **Do not transplant `1/(k+1)`.** In
Chockler–Halpern 2004 that `k` counts only the contingency variables whose value *differs* from the
actual context, and under the modified definition the contingency is held at actual values, so `k`
is identically zero and the formula returns responsibility 1 for every cause — wrong numbers that
would have looked plausible. Note also the form is `1/k` with `k = |X'| + |W|`, not `1/(k+1)`: the
`+1` is absorbed because a cause is non-empty. Halpern's book chapter 6 is the canonical citation
and was not reachable; cite the dissertation with Chockler–Halpern 2004 until someone has it open.

**Framing, and what actually differentiates this.** Probe 0 confirmed that mature engines exist —
HP2SAT (2019), the ATVA 2020 MaxSAT/ILP encodings, and the Özcan–Alrajeh–Craven KR 2025 answer-set
engine, all modified-definition, all acyclic, at roughly 8,000 binary variables in seconds. **Drop
any claim of being first, and any framing that rests on raw speed.** The surviving differentiators,
in descending order of strength: non-binary finite domains, which no engine has; degree of
responsibility, which the strongest engine omits; an exported, independently replayable exhaustion
certificate, which nobody has; and cross-query amortization, which nobody has tested and which this
plan already says must be earned rather than assumed.

**The amortization mechanism, made explicit.** Revision one asserted "the compiled quotient is the
substrate, so repeated queries share one compile", which is unsupported: two contexts merged by `~`
can carry different actual values and different verdicts, because `O` = outcome does not contain
them. What is true: for a fixed actual context `u*`, the contingency states `(u*, W := w*)` are
states of the compiled system, and two contingency sets in the same class have identical futures
under every `do(X := x')`. **So the quotient prunes the contingency search by class**, and the
exhaustion half of the certificate becomes "these `m` classes cover every smaller `W`, and each
fails" — compact exactly when `m` is far below `Σ_{j < k} C(n, j)`. That is the measurable form of
the kill criterion.

**Method.** Native iterative search, no allocation in the candidate loop, layered by `|X'| + |W|` so
the first success is minimal by construction, with class-level pruning from the intervened-state
congruence. `residual_hitting.rs` is referenced only where the structure genuinely is a hitting
problem — under the modified definition feasibility is *not* monotone (pinning a mediator at its
actual value can un-flip the outcome), so minimal-`W` is not a hitting-set problem in general; the
hitting flavour appears only in the original definition's overdetermination cases.

**No `sat.rs` A/B, and probe 0 resolved the choice.** `ergodis/src/sat.rs` is a structured-CNF
*recognizer* for graph-colouring instances that emits clique and pigeonhole UNSAT certificates;
there is no CDCL and no general solver in tree. Revision two offered a choice between writing a
small DPLL and dropping the comparison: **drop it**. The external field has moved to answer-set
programming with preference optimization, so a hand-rolled DPLL would be a comparison against a
straw arm. The same hours go into making the exhaustion certificate exportable and independently
replayable, which is the differentiator no engine has.

**Comparator and external agreement fixture.** Not HP2SAT. Use the KR 2025 answer-set engine
(`github.com/DanHOzcan/HP_ASPBinary`), which reports beating the SAT, MaxSAT, and ILP strategies on
their own suite in both runtime and memory, and whose public benchmark — 500 checking/finding and
187 inferring queries over 37 binary models — is the natural external agreement fixture for our
binary cases. **Do not use the ATVA 2020 inference encoding as an oracle**: Özcan et al. report its
`G*` satisfiability claim is incorrect, so treat disagreement with ATVA 2020 as expected rather than
alarming.

**Fixtures with verdicts pre-entered.** Rock throwing, forest fire in both conjunctive and
disjunctive form, voting, and the late-preemption cases, each with its **published** verdict and
responsibility value entered before the run. Singleton-cause search under the modified definition
returns a clean-looking "not a cause, responsibility 0" on the disjunctive fire, which is wrong;
pre-entered verdicts are the only guard against that.

**Kill criterion, now a disjunction.** Either the exhaustion certificate costs as much to verify as
the search costs to run (predeclared threshold: verifier work above 10% of search work), or the
per-query cost does not amortize across queries against one compile. Revision one made this an
`and`, which would have let a probe with no compact certificate pass on amortization alone.

## Probe 4 — level-3 counterfactual and the observation precondition

**Why it exists.** Brief section 5 sells the state choice with "the twin network becomes a path",
and revision one never tested it. It is true only under a precondition: abduction needs the evidence
set `{u : E(u) = e}` to be a union of classes, which holds iff `O ⊇ E`.

**Method.** Fix a model, a prior over `U`, an evidence set `E`, and a counterfactual query
`P(Y_{x'} = y' | e)`. Compute it on the weighted quotient with `O ⊇ E ∪ {Y}` and against direct
enumeration; then repeat with `O` = outcome only and **show the quotient gives the wrong answer**.
The negative half is the point: it converts an assertion into a measured statement with its
precondition attached.

## Probe 5 — Evolve proposes the abstraction, separator refutes

**Method.** Plant a system whose true causal coordinates are known (failed-domain count, a
cut-capacity bucket, a parity bit), blinded as in C1016's private control: opaque field identifiers,
permuted features, no labelled hint. Evolve proposes a typed `feature_dag` term `phi`; the exact
engine checks whether `ker phi` equals the compiled quotient; on failure it returns a separating
intervention plus the two merged states, added to the corpus.

**Three corrections from the review.**

1. **Fitness must be kernel equality, a partition distance — not label regression.**
   `feature_synthesis.rs` fits integer targets and class labels are arbitrary integers, so a
   regression fitness makes Evolve chase a label permutation rather than the partition.
2. **Recovery is judged up to reparameterization.** A term whose kernel is the quotient but whose
   coordinates are a bijective re-encoding of the planted ones is a full success.
3. **The informativeness claim needs an A/B.** C1039's admission replays exhaustively and returns
   *some* counterexample on rejection, so any counterexample gives soundness. The brief's claim is
   that separating interventions are *unusually good* counterexamples, which is only measurable
   against a random or first-row counterexample arm, with generations-to-seal as the measure.
   Without that arm, a success is attributable to admission, not to separators.

## Probe 6 — k-ary experiment design and decision equivalence

**Reframed.** Revision one called this an adapter over `query_design.rs`. It is not:
`query_design.rs` handles *binary* queries as hypothesis bitmasks, while an intervention on a finite
SCM has a `d`-ary outcome partition, and binarizing overcounts experiments. Expected decision regret
also needs a prior and a utility the module does not carry. This is a new k-ary module that reuses
the module's exact-verification pattern, and it depends on probe 2 for its decision key.

**Deleted:** the semilattice property tests. Set intersection being associative, commutative, and
idempotent cannot fail and proves nothing about causal reasoning.

**Method.** A bounded family of candidate mechanism tables. Quotient by decision equivalence under
a declared objective, then measure experiments needed for full identification, for
decision-sufficient identification, and cost-weighted, with exhaustive optimal sequences as the
exact check on small instances. **Include a predeclared family where the decision needs full
identification and expect a gap near zero**; without it, "decision-sufficient is much cheaper" is
true by construction.

**Blame** (the brainstorm's proposal 7) is a formula over this probe's weighted hypothesis set once
probe 3 exists, and is a deliverable here rather than a probe of its own.

## Probe 7 — compositional lowering along the DAG (expected necessary)

The "hundred thousand variables become a fifty-state machine" claim is unreachable by materializing
`(u, I)`. The only scalable route is compositional: quotient each mechanism locally by its response
classes and compose along the DAG using `composition.rs` and the C1061 retained-tree machinery,
checking the composed quotient against the flat one on small models. This is the Rischel–Weichwald
direction, and it replaces revision one's probe 6 grand claim.

**Probe 1a promoted this from gated to expected.** The flat carrier's envelope — `|U| ≲ 10^4` at
arity two or three — covers applied fixtures with a modest declared exogenous alphabet and nothing
else. Any canonical exogenous space, and any model with more than roughly fourteen independent
binary exogenous sources, is out of reach flat. So the flat lowering is the correctness substrate
and the small-model oracle, and this probe is the only route to a scaling claim.

**Probe 0 then found the near neighbour, and it blocks the start.** Madaleno, Misra and Markham,
"Coarsening Causal DAG Models" (arXiv:2601.10531, April 2026), runs a recursive partition-refinement
algorithm over the **partition-refinement lattice of the variable set**, with a completeness theorem
relative to refinement oracles, and defines *interventional coarsening* as merging nodes
indistinguishable with respect to the available interventions. The vocabulary overlap is near total.
Three differences keep it from pre-empting us and every one must be stated in probe 7's report
rather than left for a reader to find: it partitions variables where we partition the exogenous
space; it learns consistently in the sample limit from interventional data with unknown targets
where we compute an exact quotient of a known finite model; and its refinement is oracle-driven
where ours returns a replayable separating intervention.

**The warning that changed the sequencing, now resolved.** Its carrier is a partition of the variable
set — exactly the carrier this log says the `(u, I)` quotient cannot express — so the block was that
pivoting to the compositional route in order to make "these 27 states are one causal variable"
expressible would pivot onto that paper's carrier. The argument is now written
(`2026-09-04-c1062-probe7-novelty-argument.md`) and it dissolves the block rather than arguing past
it: the two promotions of probe 7 were both about never materializing `|U| · π_k`, not about
variable merging, so **probe 7 declines variable merging and keeps the exogenous carrier, held
factored over exogenous variables**. `RePaRe` is then a vocabulary neighbour and not a carrier
neighbour. Three consequences bind this probe. The factored partition-refinement technique is
imported from the model-minimization line descending from Givan, Dean and Greig (2003) and no
algorithmic novelty is claimed for it. Variable merging is out of scope on purpose. And the
"hundred thousand variables become a fifty-state machine" line is **retired**, replaced by a
statement about exogenous contexts and the cost of one class lookup.

## Probe 8 — unrolled sequential window

**One toy, one afternoon.** A two-state machine over a bounded window, lowered by unrolling into an
acyclic model. This is the only probe where word closure is **not** vacuous, so it is the only one
that tests the "SCM is just another context language" thesis where it has content. It also decides
whether the brainstorm's highest-ranked targets — electronic design automation and debug, incident
root-cause analysis, breach accountability, fault injection, all of them time-indexed — are one
sentence away from scope or genuinely out. Revision one excluded them by a scope condition without
noticing that the exclusion removed every 5/5 target.

## Probe 9 — end-to-end demo (gated)

One model from incident to actual cause to minimal corrective intervention with the full certificate
chain. It is the demonstration artifact and must **never** be counted as evidence. Gated on probes 2
and 3, not on 3 alone, because "minimal repair" is a best-intervention query.

**It must not claim application novelty.** Probe 0 found the territory occupied: Rafieioskouei and
Bonakdarpour (IEEE TCAD 2024, with 2025 and 2026 follow-ups) already run abstraction-refinement
Halpern–Pearl root-cause analysis over transition systems for cyber-physical safety violations, and
Tanhaei's C-ADL (*Journal of Systems and Software*, 2026) embeds SCMs in an architecture description
language for design-time root-cause and counterfactual reasoning. Cite both.

## Scope, and the decisions behind it

- **Acyclic finite deterministic mechanisms only.** Cyclic SCMs need a solution concept first.
  Sequential targets are reachable by bounded unrolling, which probe 8 tests rather than assumes.
- **The probabilistic layer is deferred, and this is a decision with a reason, not an omission.**
  Brief section 5 demanded a measured negative control against a junction-tree-class baseline;
  revision one silently dropped both that and `P(y | do(i))`. The deferral stands because the
  deterministic layer must work first, but the eventual native negative control is named here: a
  variable-elimination enumerator over the same finite model, roughly a hundred lines of Rust. No
  external package, per the lane's native preference.
- **Out of scope:** general causal discovery from observational data; any wrapper on or dependency
  on pyAgrum, HUGIN, SMILE, DoWhy, or ChiRho; mechanistic interpretability of neural networks —
  and note the real reason is not "no finite substrate" but the carrier problem, since this
  quotient cannot express "these states are one variable" at all; any paper, manuscript, mirror, or
  public-surface change.

## Terminology

"Bisimulation under intervention" is a published term (Chakraborty, Caulfield and Pym 2025, with
van Benthem–Bergstra and Hennessy–Milner correspondence theorems). Per the standing rule against
coining, use their term and cite them whenever this quotient is described as a bisimulation. What is
ours on that axis is the minimization algorithm and the separating witness, not the equivalence
notion.

## Process rules

- Each probe writes its own dated report before the next starts; this log gets a row and a one-line
  verdict.
- Every row carries a predeclared numeric threshold, in the C1061 style ("break-even 1.13 updates",
  "15 of 18 cells"), entered before the run.
- Predeclare shape verdicts before measuring, per C1038, with at least one predicted loss per
  measurement probe.
- Every negative states its exact searched domain and stop condition.
- Commit owned paths as each probe's validation passes; no accumulation.
- Tier rules from `ergodis-private/AGENTS.md`: tier-1 library code, one subcommand on the lane
  crate, no new `src/bin`, shared build cache.

## Next step

Probes 0, 1a and 1 are done and none killed anything. Probe 0 reframed probe 3 and corrected a
responsibility formula that would have produced wrong numbers; probe 1a fixed the carrier and
promoted probe 7; probe 1 built the lowering and passed all three gates, with the response-function
fixture collapsing 60 contexts to exactly 32 classes.

Probe 3 is done: all eight published Halpern–Pearl verdicts reproduce exactly, including the two
that catch a weaker implementation — the disjunctive forest fire's conjunctive cause and rock
throwing's `{BH}` witness. Its exhaustion certificate missed the predeclared 10% threshold, but at a
55-candidate search scale where a class-based negative cannot compress; Tavis directed that this not
close the probe, and the finding is recorded as unmeasured-at-scale rather than refuted.

Probe 2 is done and it both passes and fails, which is why its verdict is worth reading rather than
summarizing. `best_intervention` is built as a shortest path over the monoid action on the quotient,
it is exact against the enumeration oracle on every context in six families, and every witness
replays. Compression passes its threshold — 4.97x on distinct weights and 2.00x on a restricted
repair vocabulary, above a symmetry baseline that is verified rather than declared. Timing fails, and
structurally: the flat lowering solves the model once per materialized state, and that state count is
exactly the work a memoized re-solve does to fill a table over every context, measured at 1.00x. No
faster refinement changes that. Two corrections came out of it. Symmetry orbits do not coarsen the
compiled quotient, because a labelled edit vocabulary makes the class partition equivariant rather
than invariant, so the credit ratio is taken against the join of the two partitions. And probe 3's
"the policy failure tracks the sort count" hypothesis is withdrawn: `MultiwayTranscript` and
`AdaptiveTranscript` fail as well, and the threshold tracks neither sorts nor states.

**Probe 7 is next and is now doubly motivated.** Probe 1a promoted it on carrier grounds; probe 2
promotes it independently on decision-layer grounds, because the compiled query wins exactly where
the context space cannot be memoized and the carrier is never materialized. It stays blocked until
its novelty argument against the variable-partition coarsening line is written down, and that
argument is now the highest-value unblocked piece of writing in the task. Probe 8 is the second
surviving direction and now has a measured reason to exist: with hard interventions the intervention
set is the state set, so one-shot enumeration sees everything a search could, and only a
non-idempotent vocabulary makes the shortest path earn its keep.

Carried forward, none blocking. The arity tower is computed at full price per rung rather than
incrementally through `plan_layered_greedy_schedule`. The intervention-vocabulary quotient is empty
for hard edits (16 declared edits, 16 distinct actions) and should be re-measured under a
non-idempotent vocabulary rather than dropped. Probe 6's decision-equivalence key cannot be the class
key, because an intervention's class tuple across candidate models is already almost a complete
invariant. Probe 3's amortization arm was never measured.

**Two obstructions outside this lane**, both raised and neither fixed here. The ergodis core
miscompiles the causal lowerings under four of its five certificate policies — `QuotientOnly`,
`MultiwayTranscript` and `AdaptiveTranscript` all fail where `SplitTranscript` and
`ExhaustivePairAudit` succeed and agree; the probe 2 report carries the six-row table that withdraws
probe 3's sort-count hypothesis. It fails closed, so no wrong answer escapes. Separately, the
exhaustive pair audit costs 846x the refinement it certifies (1.516 s against 1.792 ms on 33,024
states) and reached 6.9 GB at 205,056 states, which is what caps the flat carrier in practice.
</content>
