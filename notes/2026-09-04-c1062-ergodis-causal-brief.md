# C1062 brief: structural causal models in Ergodis

**Lane**: `complete-ports`
**Task**: C1062 — open-ended spike on integrating structural causal models (SCMs) into Ergodis,
with Evolve as the abstraction proposer.
**Code**: `~/src/ergodis-private` (core changes, if any, in `~/src/ergodis`)
**Status of this file**: reference. It records the source brainstorm, my assessment of it, and the
mapping onto machinery that already exists. It is not a result document; probe reports are.

## 1. Provenance and epistemic status of the source

The material in section 3 is a condensed write-up of a ChatGPT brainstorm supplied by Tavis on
2026-09-04. Two things must stay separate:

- **Structural claims** (what the mathematical object is, how it relates to Halpern–Pearl actual
  causality and Beckers–Halpern causal abstraction). These are checkable against standard
  references and I treat them as probably right, subject to the audit in probe 0.
- **Landscape claims** (named 2026 papers, version numbers, release dates, benchmark figures,
  "no mature engine exists"). These were unverified generated text and are now **resolved** by
  probe 0, `2026-09-04-c1062-probe0-prior-art-and-landscape-audit.md`: `pyAgrum 3.0`'s C++ causal
  module, `FLOP` at ICLR 2026 with a Rust implementation, `I-FLOP`, and `C-ADL` are **confirmed**
  and none competes with this work; the May 2026 dynamic-logic-of-propositional-assignments
  translation and `SMILE 2.4.7` are **not found** and must not be repeated. The lesson stands for
  the next brainstorm: roughly two thirds survived, which is neither "all fabricated" nor safe to
  assume.

The one landscape claim that most affected EV — *there is no mature fast engine for Halpern actual
causality* — is **false**, as probe 0 confirmed. HP2SAT (2019), the Ibrahim–Pretschner ATVA 2020
MaxSAT/ILP encodings, and the Özcan–Alrajeh–Craven KR 2025 answer-set-programming engine all exist,
all implement the modified definition over acyclic binary models, and the field is at roughly 8,000
binary variables in seconds. The pre-written consequence branch absorbs this: probe 3's claim
narrows from "the first exact engine" to "a compiled, certificate-carrying engine against a
per-query encoding", and its surviving differentiators, in descending strength, are non-binary
finite domains, degree of responsibility, an exported exhaustion certificate, and cross-query
amortization. Any framing that rests on being first or on raw speed is dropped.

## 2. The central object, stated once

For a state space `X`, a family of admissible contexts `C`, and an observable `O`:

```
x ~_C y   iff   for all c in C,   O(c[x]) = O(c[y])
```

Compile `X -> X/~_C`. The brainstorm's thesis is that this single primitive covers everything
Ergodis already does if you vary what `C` is:

| Instantiation of `C`               | What the quotient is                    |
|------------------------------------|-----------------------------------------|
| algebraic outer continuations      | the complete-ports contextual quotient  |
| future input words                 | Myhill–Nerode / automaton minimization  |
| future parameter updates           | the C1061 dynamic-decision quotient     |
| **future interventions**           | **causal abstraction**                  |
| future observations and actions    | decision-relevant epistemic state       |

The causal row is the new one. It says: two low-level states are causally indistinguishable when no
admissible intervention, followed by any further admissible interventions, produces a different
observation. That is Beckers–Halpern exact causal abstraction read as a quotient rather than as a
validity check on a proposed abstraction map, and it inverts the usual research question. The
literature mostly asks *is this proposed abstraction causally valid?*; the Ergodis question is
*compute the coarsest valid abstraction, and hand back a separating intervention whenever a
proposed one is too coarse*.

## 3. The brainstorm's ten proposals, condensed

1. **Causal quotient compiler.** Define `x ~_I y` when no admissible intervention distinguishes
   them at the observables; compile `M -> M/~_I`. The commuting square (intervene-then-abstract =
   abstract-then-intervene) is the exactness condition.
2. **Actual causality is exact combinatorial optimization.** Halpern–Pearl asks whether `X=x`
   actually caused `phi` in a given context, and the hard part is finding a contingency `W` under
   which changing `X` changes the outcome. The brainstorm gives degree of responsibility as
   `1/(k+1)` for a minimum contingency of size `k`. **That formula is a trap and probe 0 caught it.**
   In Chockler–Halpern 2004, Definition 3.2, `k` counts only the contingency variables whose value
   *differs* from the actual context; under the **modified** Halpern–Pearl definition the contingency
   is always held at actual values, so that count is identically zero and the formula returns
   responsibility 1 for every cause. The correct modified-definition formula is
   `1/(|X'| + |W|)`, minimised jointly over the (cause, witness) pairs in which the queried variable
   appears as a conjunct — Ibrahim's 2021 dissertation, Definition 2.5, corroborated by
   Ibrahim–Pretschner ATVA 2020 Definition 3 and Triantafyllou et al. AIES 2022 Definition 4.1.
   Halpern's book chapter 6 is the canonical reference and was not reachable, so cite the
   dissertation with Chockler–Halpern 2004 until someone has the book open. So the native problem is `min |W|` subject to a counterfactual
   condition — exact finite combinatorial optimization over a structure that is traversed
   combinatorially many times.
3. **Causal uncertainty gives a meet-semilattice.** With a finite hypothesis set `H` of candidate
   SCMs, evidence `e` acts by `H |-> H ∩ C_e`: associative, commutative, idempotent. Quotient `H`
   further by decision equivalence (`M_i ~ M_j` iff every action of interest has the same
   consequence or the same optimal decision) and the epistemic state shrinks again.
4. **Active causal discovery.** An intervention partitions `H` by its possible outcomes. Choose the
   next experiment to minimize worst-case remaining hypotheses, or cost, or — the interesting
   objective — expected downstream *decision regret*. Do not identify structure the decision does
   not need.
5. **Electronic design automation and debug as a target.** RTL/netlist already is a finite
   structural model; interventions are force-signal, disable-block, change-config-bit. Ask which
   signal transition actually caused an assertion failure, what the minimal corrective change is,
   and which causes carry the most responsibility.
6. **Optimization becomes optimization over interventions**, `max_a E[U | do(a)]`, then robust or
   minimax-regret over an uncertain model set, compiled into a reusable policy.
7. **Blame is expected responsibility** over the epistemic state, so the same engine gives actual
   cause, responsibility, blame, and explanation.
8. **Mechanistic interpretability** is already being formalized as causal abstraction; for
   quantized or small circuits, Evolve could propose "these 27 internal states are one causal
   variable" and the exact engine either seals it or returns the separating intervention.
9. **Decision-relevant training loss.** Do not train a learner to recover a DAG exactly; train it
   only to preserve distinctions that change the optimal intervention.
10. **A general Ergodis causal object**: input variables, mechanisms, allowed interventions,
    uncertainty model, observables, objective; compile to a causal quotient, an intervention
    algebra, an epistemic quotient, and an actual-causality engine; query with `cause(...)`,
    `responsibility(...)`, `counterfactual(...)`, `best_intervention(...)`,
    `best_experiment(...)`.

The brainstorm's own ranking: formal causal debugging and EDA, cloud/AI incident root-cause
analysis, security-breach accountability, and active fault injection at 5/5; robust causal policy
compilation and quantum-error-correction noise characterization at 4.5/5; mechanistic
interpretability at 3.5/5 today; general observational causal discovery at 2/5 and explicitly not a
target.

The Evolve half adds: separating interventions are unusually good counterexamples (they are
*meaningful* — an explicit experiment that distinguishes two states the proposal merged), so the
propose/refute loop is counterexample-guided abstraction refinement with an informative oracle; the
intervention vocabulary itself can be quotiented (`i_1 ~ i_2` when they induce the same map on the
quotient), giving a small monoid action `J acting on Q`; and the deepest role for Evolve is naming
the classes — exact minimization says "there are 37 classes", Evolve says "the class is
`(failed_rack_count, min_cut_bucket, checkpoint_parity)`".

## 4. What Ergodis already has

This is the reason the spike is cheap. Almost every piece the brainstorm asks for exists as a
domain-neutral module; the missing part is a lowering from SCMs into it.

| Needed for the causal engine                      | Existing module                                            |
|---------------------------------------------------|------------------------------------------------------------|
| the quotient `X/~_C` with replayable separators   | `ergodis/src/observational.rs` (`FinitePresentation`, `SeparatorRecord`, `CertificatePolicy`) |
| richer context alphabets, refinement towers       | `ergodis/src/continuation.rs`                              |
| rank-bounded outer tests, scalar contextual layer | `ergodis/src/contextual.rs`                                |
| context languages and their products              | `FiniteContextLanguage`, `ContextLanguageProduct`          |
| version space over hypotheses, adaptive tests     | `ergodis/src/query_design.rs` — **binary queries only**, so a `d`-ary intervention outcome needs a new module reusing its verification pattern |
| exact minimal hitting / covering search           | `ergodis/src/residual_hitting.rs`, `predicate_cover.rs` — applicable only where feasibility is monotone, which the modified Halpern–Pearl definition is not |
| general SAT                                       | **absent.** `ergodis/src/sat.rs` is a structured-CNF recognizer for graph-colouring instances emitting clique and pigeonhole UNSAT certificates; there is no CDCL in tree |
| composition and delta updates on a retained tree  | `ergodis/src/composition.rs`, C1061's delta machinery      |
| typed feature terms for Evolve                    | `ergodis/src/feature_dag.rs`, `ergodis-private/src/feature_synthesis.rs`, `repr_grammar.rs` |
| admission that rejects unsound corpus-perfect predicates with a replayable counterexample | `ergodis-private/src/planted_gap_corpus.rs` (C1039) |
| predeclared win/lose shape prediction              | `ergodis/docs/ergodis-shape-classifier.md` (C1038)         |
| provenance and certificate discipline              | `ergodis/src/provenance.rs`, `witness.rs`, generic certificate chain (C1061 probe 18) |

There is currently **no** causal, intervention, counterfactual, or do-calculus code anywhere in
either repository; a bounded search over both `src` trees finds nothing. This is greenfield on top
of finished machinery.

## 5. The encoding question

The encoding is the whole spike, so state it precisely. **My first attempt at it was wrong**, and
the correction is worth more than the original claim, so both are recorded here. The adversarial
review in `2026-09-04-c1062-plan-review.md` found the defect; the corrected lowering and its
consequences are developed in the exploration log's opening section, which is the authority.

**What I first claimed.** State is the exogenous assignment `u`; generators are the atomic
interventions `do(V := a)`, each acting by mechanism override and re-solve; contexts are words in
those generators, which generate the whole intervention monoid because later assignments override
earlier ones; so twenty binary variables need forty generators rather than `3^20` interventions,
making the first proposal an adapter rather than an engine.

**Why it is wrong.** A generator in `observational.rs` is a total map from states to states, and
`do(V := a)` applied to `u` is a solution of a *different model* — it is not an element of `U`. The
generator has nowhere to land. The lowering is ill-typed except when interventions are confined to
root variables, where pinning a root is just re-assigning its exogenous value.

**The forced repair, and what it costs.** The state must be the pair `(u, I)` with `I` the current
partial assignment of pinned variables. That is well-typed, but it moves the exponential from the
vocabulary into the compile: materialized states number `|U| · ∏_V (|D_V| + 1)`. The escape is an
arity bound carried in the sort structure or a `FiniteContextLanguage`. Worse for the original
claim, on that carrier hard-intervention words are idempotent and commutative, so every word reduces
to its final partial assignment and the quotient on `U` is a one-pass signature partition that
refinement recomputes at the same cost. **What the compiler actually adds is the uniform separator
certificate and the congruence on the intervened states `(u, I)`** — and that congruence, not the
quotient on `U`, is what prunes the actual-cause contingency search.

**What the compiled relation is.** With the outcome as observation it coarsens the exogenous space
with endogenous variables unchanged, so it is a targeted reduction rather than Beckers–Halpern
variable merging. With every endogenous variable observed and the full `do(pa(V) := p)` vocabulary
on a canonical exogenous space, it is exactly Balke and Pearl's 1994 response-function partition —
a known object, a mandatory correctness fixture, and a novelty risk. Variable-merging abstraction
needs endogenous settings as the carrier, and there `(u, I)` is strictly finer; the full atomic
vocabulary is precisely what makes nontrivial merges impossible, which is why Beckers–Halpern
restrict the intervention set. **The linear-vocabulary claim and the interesting-abstraction claim
pull in opposite directions.**

Four things that remain genuinely hard, which the probes must not paper over:

1. **Probabilistic SCMs.** The quotient is exact for the deterministic mechanism layer; a
   distribution over exogenous contexts pushes forward to class weights, and `P(y | do(i))` is then
   exact on the quotient. That is sound, but it only *wins* when the quotient is much smaller than
   the state space, which requires mechanistic structure — deterministic mechanisms, few outcome
   values, threshold or monotone behaviour, wide fan-in collapsing to narrow observables. On a
   generic noisy Bayesian network it will lose to a junction tree. The eventual native negative
   control is a variable-elimination enumerator, not an external package.
2. **Cyclic and dynamic models.** Acyclic is assumed above; cyclic SCMs need a solution concept
   before "re-solve" is even a function. This matters more than it first appears, because every
   application the brainstorm ranks 5/5 is time-indexed, so bounded unrolling is load-bearing
   rather than optional.
3. **Minimality of the contingency search.** Actual causality is not a search for some `W`; it needs
   an exhaustion argument that no smaller one works, and feasibility is not monotone under the
   modified definition, so it is not a hitting-set problem in general. A compact form for that
   negative is the interesting engineering problem.
4. **The observation set is a dial, not a given.** Level-3 abduction needs the evidence set to be a
   union of classes, so `O ⊇ E`; actual-cause verdicts need the cause and contingency values in `O`.
   Observe everything and the quotient is the identity. Nothing is exact "on the quotient" until the
   query-relevant variable set is declared.

Positioning, which I agree with and which should be held to: Ergodis is not competing with
statistical causal discovery and cannot make identifiability problems disappear. Its role begins
where a finite mechanistic model, a bounded candidate family, or an explicit intervention
vocabulary already exists, and the job is exact reasoning over it — a mechanism compiler, not
"causal AI".

## 6. Standing constraints for this task

- No paper, manuscript, mirror, or public-surface change. C1062 is private research.
- Native, well-typed Ergodis implementations. External engines (pyAgrum, HUGIN, SMILE, DoWhy,
  ChiRho) are semantics references and, at most, published-number context — not build dependencies
  and not a reason to write a wrapper. Independent replay uses an in-tree Python oracle, as the
  lane already does.
- The `ergodis-private` tier rules apply: library code in tier 1, one subcommand per task in a
  tier-2 crate, no new `src/bin`, builds into `~/.cache/ergodis/target/ergodis-private`.
- Every performance claim needs the lane's usual interleaved A/B, counter evidence, and an
  independent replay. Every negative claim needs its exact searched domain and stop condition.
</content>
</invoke>
