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
  "no mature engine exists"). These are unverified generated text. Several are the kind of detail
  a language model fabricates confidently: `pyAgrum 3.0` moving causal machinery to C++ in July
  2026, `FLOP` at ICLR 2026 with a Rust implementation, `I-FLOP` "six days ago", `C-ADL` embedding
  SCMs in architecture description languages, a May 2026 translation of binary Halpern SCM
  reasoning into dynamic logic of propositional assignments, `SMILE 2.4.7` from June 2026.
  **None of these may be cited, relied on for a novelty verdict, or used to size a market until
  audited** under `notes/literature-audit-conventions.md`. They are leads, not facts.

The one landscape claim that most affects EV — *there is no mature fast engine for Halpern actual
causality* — is also the one most worth checking first, because the whole of probe 3's value rests
on it.

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
   which changing `X` changes the outcome. Degree of responsibility is `1/(k+1)` for a minimum
   contingency of size `k`. So the native problem is `min |W|` subject to a counterfactual
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
| version space over hypotheses, adaptive tests     | `ergodis/src/query_design.rs`                              |
| exact minimal hitting / covering search           | `ergodis/src/residual_hitting.rs`, `predicate_cover.rs`     |
| native SAT when a search wants clauses            | `ergodis/src/sat.rs`                                       |
| composition and delta updates on a retained tree  | `ergodis/src/composition.rs`, C1061's delta machinery      |
| typed feature terms for Evolve                    | `ergodis/src/feature_dag.rs`, `ergodis-private/src/feature_synthesis.rs`, `repr_grammar.rs` |
| admission that rejects unsound corpus-perfect predicates with a replayable counterexample | `ergodis-private/src/planted_gap_corpus.rs` (C1039) |
| predeclared win/lose shape prediction              | `ergodis/docs/ergodis-shape-classifier.md` (C1038)         |
| provenance and certificate discipline              | `ergodis/src/provenance.rs`, `witness.rs`, generic certificate chain (C1061 probe 18) |

There is currently **no** causal, intervention, counterfactual, or do-calculus code anywhere in
either repository; a bounded search over both `src` trees finds nothing. This is greenfield on top
of finished machinery.

## 5. My assessment, and the one technical insight that makes probe 1 cheap

The encoding question is the whole spike, so state it precisely.

`observational.rs` wants finite state sorts, an observation per state, and **total typed unary
generators**; it computes exactly the states no well-typed generator path can distinguish, and it
emits a separator for every separated pair. An acyclic finite SCM lowers into that as follows.

- **State** = the exogenous assignment `u` (equivalently, the solved endogenous assignment it
  determines). This is the right choice because it is what a counterfactual holds fixed while the
  mechanisms change; Pearl's twin-network construction becomes a path in the generator system
  rather than a separate algorithm.
- **Generator** = one atomic intervention `do(V := a)` for a single variable `V` and value `a`,
  acting by overriding `V`'s mechanism and re-solving. Total, deterministic, well-typed.
- **Context** = a word in those generators, which is exactly the full intervention algebra, because
  single-variable assignments generate the whole intervention monoid under later-overrides-earlier
  composition.
- **Observation** = the value of the declared outcome variables in the solved assignment.

The consequence matters: the intervention *vocabulary* the compiler needs is linear in
`variables x domain size`, not exponential in subsets, while the *context language* it quotients
against is still the whole intervention algebra. A model with twenty binary variables needs forty
generators, not `3^20` interventions. If that lowering is faithful, section 3's first proposal is an
adapter, not an engine, and the real risk moves entirely to actual causality, the version-space
layer, and the Evolve loop.

Three things I expect to be genuinely hard, and which the probes must not paper over:

1. **Probabilistic SCMs.** The quotient is exact for the deterministic mechanism layer; a
   distribution over exogenous contexts pushes forward to class weights, and `P(y | do(i))` is then
   exact on the quotient. That is sound, but it only *wins* when the quotient is much smaller than
   the state space, which requires mechanistic structure — deterministic mechanisms, few outcome
   values, threshold or monotone behaviour, wide fan-in collapsing to narrow observables. On a
   generic noisy Bayesian network it will lose to a junction tree, and the spike must say so with a
   measured negative control rather than discover it later.
2. **Cyclic and dynamic models.** Acyclic is assumed above. Cyclic SCMs need a solution concept
   before "re-solve" is even a function.
3. **Minimality of the contingency search.** Actual causality is not just a search for some `W`; it
   needs an exhaustion argument that no smaller `W` works. The certificate has to carry that
   negative, and a compact form for it is the interesting engineering problem.

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
