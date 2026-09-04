# C1062 exploration log: structural causal models in Ergodis

**Lane**: `complete-ports`
**Brief**: `2026-09-04-c1062-ergodis-causal-brief.md`
**Code**: `~/src/ergodis-private` (core changes, if any, in `~/src/ergodis`)
**Status**: planned; no probe run yet.

This is the routing document for C1062. The task asks whether a finite structural causal model
(SCM) is just another context language for the Ergodis contextual quotient, and if so what that
buys: exact causal abstraction with separating interventions as counterexamples, an exact
Halpern–Pearl actual-causality and responsibility engine, an exact epistemic/experiment-design
layer over a bounded hypothesis family, and an Evolve loop that names the quotient classes. Each
probe below gets its own dated report; this file carries only the probe index, standing results,
process rules, and the next step. Reports are the authority for numbers and method.

## Probe index

| Probe | Name                                              | Size | Verdict | Report |
|-------|---------------------------------------------------|------|---------|--------|
| 0     | Prior-art and landscape audit                     | S    | planned | —      |
| 1     | SCM lowering onto the observational compiler      | M    | planned | —      |
| 2     | Quotient economics and the negative control       | M    | planned | —      |
| 3     | Exact actual causality and responsibility         | L    | planned | —      |
| 4     | Version space, evidence meet, next experiment     | M    | planned | —      |
| 5     | Evolve proposes the abstraction, separator refutes| M    | planned | —      |
| 6     | Intervention-vocabulary quotient                  | M    | gated on 1–2 | — |
| 7     | Blame under model uncertainty                     | S    | gated on 3–4 | — |
| 8     | One end-to-end system: incident to minimal repair | L    | gated on 3 | — |

Sizes are relative within one fast session: S is under an hour, M is one to three, L is a session.
Probes 1 through 5 are the spike proper and are ordered so the cheapest fatal answer comes first.
Probes 6 through 8 are conditional and exist so the plan does not silently expand.

## Probe 0 — prior-art and landscape audit

**Question.** Is "compute the coarsest exact causal abstraction by partition refinement over the
intervention monoid, with a separating intervention as the refutation witness" already published?
And separately, is the claim "no mature fast engine exists for Halpern actual causality" true?

**Why first.** Probe 3 is the largest probe and its entire value rests on that second claim. The
first question decides whether any of this can ever carry a paper claim, and a novelty failure here
triggers the lane's bounded adjacent-crown extraction rather than more code.

**Method.** Bounded audit under `notes/literature-audit-conventions.md`, checking the shared
literature cache first. Targets: Beckers–Halpern exact and approximate causal abstraction;
Rubenstein et al. exact transformations of causal models; Rischel–Weichwald compositional/categorical
causal abstraction; Geiger et al. causal abstraction for interpretability; Halpern's actual
causality and degree of responsibility, and its complexity classification; the SAT-based actual
causality checkers; ChiRho's causal explanation module. Every unverified landscape claim listed in
brief section 1 is checked or discarded, not repeated.

**Deliverable.** A dated audit note recording, per source, what it does and does not cover, with
the exact searched domain and stop condition for every negative.

**Kill criterion.** If coarsest-abstraction-by-refinement over an intervention monoid is already a
published algorithm with a certificate, the mathematical crown is gone; the engineering probes may
still proceed as an engine claim, but the framing changes and the paper option closes.

## Probe 1 — SCM lowering onto the observational compiler

**Hypothesis.** An acyclic finite SCM plus a declared intervention vocabulary lowers into an
existing `FinitePresentation` with no semantic change to `observational.rs`, and the compiled
quotient is exactly `~_I` — indistinguishability under every word of interventions.

**Lowering** (stated in brief section 5, restated here because the probe stands or falls on it):
state is the exogenous assignment; generators are the atomic single-variable interventions
`do(V := a)`, each acting by mechanism override and re-solve; contexts are words in those
generators, which is the whole intervention monoid because later assignments override earlier ones
on shared variables; the observation is the declared outcome tuple of the solved assignment. The
generator count is linear in variables times domain size, so the intervention algebra is quotiented
against without ever enumerating it.

**Method.** A tier-1 `causal` module in `ergodis-private` holding a typed `CausalPresentation`
(variables, domains, mechanism tables, declared outcome variables, declared intervention
vocabulary) and a total lowering into `FinitePresentation`. No new binary; a `c1062` subcommand on
the existing lane crate. An independent Python oracle brute-forces `~_I` on small models by direct
enumeration of intervention words up to the diameter, and the two partitions must agree exactly.
Fixtures: a chain, a fork, a collider, a diamond with a threshold outcome, and one deliberately
adversarial model whose quotient is the identity.

**Deliverable.** Agreeing partitions on every fixture; a separating intervention word printed for
each separated pair and replayed by the Python oracle; the exact statement of which SCM class is
covered (acyclic, finite domains, deterministic mechanisms, declared vocabulary).

**Kill criterion.** The lowering needs a semantic change to the observational compiler; or
separating words are not recoverable in intervention terms; or the quotient is the identity on
every natural fixture, meaning there is nothing to compile.

**What it settles.** If this lands, the brainstorm's first proposal is an adapter and the risk moves
entirely downstream. This is the highest-information probe per hour in the plan.

## Probe 2 — quotient economics and the negative control

**Hypothesis.** The causal quotient compresses hard on mechanistic structure — deterministic
mechanisms, wide fan-in collapsing to narrow observables, threshold or monotone outcomes,
interchangeable components — and does not compress on generic randomly generated models. Predicting
which is which in advance is the point.

**Method.** Predeclare per family, using `ergodis/docs/ergodis-shape-classifier.md`, whether it
should compress and why, *before* measuring. Families: a failure-domain reliability model
(replicated components behind a threshold outcome), a capacity/cut model, a small combinational
circuit with an assertion observable, a random sparse acyclic model with random mechanism tables
(predicted loss), and a random model with a fine-grained observable exposing every variable
(predicted identity quotient). Report raw states, classes, quotient/raw ratio, compile time and
peak RSS, and warm query time against direct re-solve, with the lane's usual interleaved rounds.

**Deliverable.** A table of predicted versus measured shape verdicts, and an explicit statement of
the regime boundary — the structural condition under which the compile pays for itself, expressed
as a break-even query count as in C1061 probe 1.

**Kill criterion.** Compression is absent or marginal on the families predicted to win. A predicted
loss that loses is a pass, not a failure.

**Note.** Do not compare against junction-tree engines here. The honest comparison target for a
deterministic mechanistic model is direct re-solve and enumeration, which is native. A probabilistic
comparison is a separate, later question and would need probe 0's landscape audit first.

## Probe 3 — exact actual causality and responsibility

**Hypothesis.** Halpern–Pearl actual causality over a finite SCM is exact bounded combinatorial
optimization with heavy repeated structure, and Ergodis can answer many such queries against one
compiled model with a replayable certificate that includes the negative — no smaller contingency
works.

**The native problem.** Given a model, an actual context, a candidate cause `X = x`, and an outcome
`phi`, find the minimum contingency `W` (a set of variables held at their actual values) under which
changing `X` changes `phi`; responsibility is `1/(|W| + 1)`. The engine must produce the witness
assignment, the counterfactual outcome, and an exhaustion argument over all smaller `W`.

**Method.** Which Halpern–Pearl variant is implemented must be declared explicitly and tested
against it — the modified definition first, because its complexity is lower and its semantics are
less contested; the original definition only if the modified one lands. Native iterative search with
no allocation in the candidate loop, layered by `|W|` so the first success is minimal by
construction. Reuse `residual_hitting.rs` and `predicate_cover.rs` where the structure is a hitting
or covering problem; use the native `sat.rs` as an in-tree alternative encoding for a fair internal
A/B, not as an external dependency. The compiled quotient from probe 1 is the substrate, so repeated
queries share one compile.

**Deliverable.** Exact actual-cause verdicts, minimal contingencies, and responsibility values on a
fixture set including the standard textbook cases (rock throwing, forest fire in both conjunctive
and disjunctive form, voting, the late-preemption cases), replayed by an independent Python
Halpern–Pearl checker. A compact certificate whose exhaustion half is verifiable without redoing
the search.

**Kill criterion.** The exhaustion certificate is no smaller than re-running the search — that is,
there is no compact negative — and the per-query cost does not amortize across queries against one
compiled model. Either would mean the engine is a re-implementation rather than a compiler.

**Baseline discipline.** Published SAT-solver figures from probe 0's audit are context for sizing,
never a measured comparison. A measured comparison needs the same machine and the same model
encoding, and is out of scope unless probe 0 finds a runnable artifact.

## Probe 4 — version space, evidence meet, next experiment

**Hypothesis.** `query_design.rs` already is the causal experiment-design engine once hypotheses are
candidate SCMs and queries are interventions, and the decision-equivalence quotient makes the
hypothesis set dramatically smaller before any experiment is chosen.

**Method.** A bounded hypothesis family (a small set of candidate mechanism tables over one variable
set). Evidence accumulation as the semilattice meet `H |-> H ∩ C_e`, with associativity,
commutativity, and idempotence as property tests rather than prose. Decision equivalence: quotient
`H` by the induced optimal action under a declared objective, then measure how many experiments the
decision-relevant target needs versus full identification of the model. Experiment selection by
worst-case remaining class count and by expected decision regret, verified exactly against
exhaustive optimal sequences on small instances.

**Deliverable.** Exact controls showing the experiment count under three objectives — full
identification, decision-sufficient identification, and cost-weighted — on the same family, and the
measured gap between them. The interesting number is how much cheaper decision-sufficient discovery
is; if it is not much cheaper, the whole "do not learn what the decision does not need" thesis is
weak in practice and should be said so.

**Kill criterion.** `query_design.rs` needs a rewrite rather than an adapter, or the
decision-equivalence quotient never merges anything on natural families.

## Probe 5 — Evolve proposes the abstraction, separator refutes

**Hypothesis.** The C1039 planted-gap admission machinery works unchanged with the separating
intervention as its counterexample oracle, and Evolve recovers human-legible coordinates for the
quotient classes rather than merely a correct classifier.

**Method.** Plant a system whose true causal coordinates are known — for the failure-domain family,
something like failed-domain count, a cut-capacity bucket, and a parity bit. Blind the presentation
the way C1016's private control does: opaque field identifiers, permuted features, no labelled hint
of the planted coordinates. Evolve proposes a typed feature term `phi` from `feature_dag`; the exact
engine checks whether `ker phi` equals the compiled quotient; on failure it returns a separating
intervention word plus the two merged states, which is added to the corpus as a counterexample.
Loop until sealed or the budget expires.

**Deliverable.** Whether the planted coordinates are recovered, at what generation, and — the
distinguishing test against a plain classifier — whether the admitted term is *exactly* the quotient
rather than corpus-perfect. C1039 already demonstrates that admission rejects unsound corpus-perfect
predicates with a replayable counterexample; this probe checks that the causal separator is a
sufficient counterexample oracle for that same gate.

**Kill criterion.** Evolve reaches corpus-perfect terms that admission rejects forever, with
separating interventions failing to guide it toward the planted coordinates. That would mean the
counterexamples are not informative in practice, which is the load-bearing claim of the whole Evolve
half of the brainstorm.

## Conditional probes

**Probe 6 — intervention-vocabulary quotient.** Collapse interventions inducing the same map on the
compiled quotient, giving a monoid action `J acting on Q`, and measure `|J|` against the declared
vocabulary. This is where a "hundred thousand variables become a fifty-state machine" claim would
have to come from. Gated on probes 1 and 2, because it is meaningless if `Q` does not compress.

**Probe 7 — blame under model uncertainty.** Expected responsibility over a weighted hypothesis set,
which is cheap once probes 3 and 4 both exist and is otherwise not a probe at all.

**Probe 8 — one end-to-end system.** A single realistic model taken from incident to actual cause to
minimal corrective intervention, with the full certificate chain. Candidates: a small circuit with an
assertion failure, or a service/failure-domain model. This is the demonstration artifact, not a
research result, and it should only be built after probe 3 lands.

## Explicitly out of scope

- General causal discovery from observational data. Ergodis cannot resolve identifiability, and
  competing with statistical discovery packages is not the niche.
- Any wrapper around, or build dependency on, pyAgrum, HUGIN, SMILE, DoWhy, ChiRho, or a junction-
  tree engine. Independent replay is an in-tree Python oracle.
- Cyclic and dynamic SCMs. Acyclic finite deterministic mechanisms only, stated as a scope
  condition rather than discovered as a limitation later.
- Mechanistic interpretability of neural networks. Interesting, but it needs a quantized or
  finite-state substrate that this spike does not produce.
- Any paper, manuscript, mirror, or public-surface change.

## Process rules

- Each probe writes its own dated report before the next probe starts; this log gets only a row and
  a one-line verdict.
- Predeclare shape predictions before measuring, per C1038.
- Every negative result states its exact searched domain and stop condition.
- Commit owned paths as each probe's validation passes; no accumulation.
- Tier rules from `ergodis-private/AGENTS.md`: tier-1 library code, one subcommand per task on the
  lane crate, no new `src/bin`, shared build cache.

## Next step

Probe 0 and probe 1 in parallel — the audit does not block the lowering, and probe 1 is the cheapest
fatal test in the plan.
</content>
</invoke>
