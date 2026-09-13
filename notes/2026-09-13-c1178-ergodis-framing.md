# C1178 — Ergodis framing for the optimization paper and documentation

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: COMPLETE as a framing deliverable; first-paper recommendation and draft prose below.
**Visibility**: PRIVATE contributor/editorial context. This document is not an export source.

## Purpose and scope

Develop a coherent account of Ergodis for the C985 optimization paper, its documentation
and its README. Recover the framings developed since C985, including the complete-ports
paper's recovery motivation, and place the September 13 discussion of Evolve and
meta-optimization alongside them. Do not choose the newest framing simply because it is newest.

This task owns the framing synthesis and proposed audience-specific prose. C985 continues
to own the optimization manuscript. The complete-ports manuscript remains in its own lane
and is a read-only source here. Public documentation is a downstream destination: its
wording requires a separate check against the actual exported capabilities and evidence.
No manuscript, public README, export or publication is changed by this task.

## Recommendation

Lead with **a spectrum from evolving structure to specialized exact computation**.
The September 13 user refinement makes optional reification central: Evolve searches for
the structure suited to the required queries and workload; Ergodis can continue adapting,
retain and reuse the structure, or materialize it as a static specialized kernel when that
is useful. Query-preservation contracts support this account. Evolve is core to the system
even when a resulting deployment no longer runs discovery.

Working title:

> **Ergodis: From Evolving Structure to Specialized Exact Computation**

Alternative retained: **Ergodis: Discovering and Compiling Structure for Exact Optimization**.

Working thesis:

> Ergodis evolves the structure used to solve a problem, then lets that structure remain
> adaptive or become a specialized executable computation. Discovery, retained plans and
> static kernels are points on one spectrum, connected by the required queries, preservation
> contracts and evidence. Specialization is an option whose value depends on the workload.

The unifying object is an **admitted change to a computation**: what question it serves,
what it preserves, what must be checked, how the answer is recovered, and where the change
can be reused. An exact quotient, a one-sided bound, a witness-generating parameterization,
a source update and a cheaper execution plan have different obligations. The paper should
make their relationship legible without pretending they are the same mathematical object.

The September 13 user additions make **performance engineering** and **interactive Evolve
campaigns** explicit parts of this account. The system must turn discovered structure into
efficient machine execution and support agents and people exploring, inspecting and steering that
discovery over time. Both belong in the first paper's integrated explanation and evaluation.

This frame contains the earlier recovery, contextual-state, invariant-synthesis and
dynamic-query accounts. It also gives the newer recursive contracts a clear role. It does
not require every problem to be recursive, every representation to be a quotient, or every
Evolve action to have the same proof format.

**Judgment and scope.** This is a recommendation about the strongest story supported by
the project's mechanisms and direction, not a claim of priority. No external research paper
was newly read at full text in this pass. The external comparison uses official documentation,
abstracts and earlier internal studies at the read depths recorded in
`2026-09-13-c1178-ergodis-framing-sources.md`. The contribution's novelty remains for a
claim-specific audit under C985. The framing task can close while that paper evidence is open.

**Strongest objection.** A referee can reasonably say: this combines algorithm selection,
constraint reformulation, abstraction refinement and compiler optimization behind a common
interface. A good answer must show a shared admission mechanism doing substantive work
across different transformations, plus a measured benefit from coupling discovery to
execution and from retaining or materializing its results. A catalogue of examples and a
generic loop diagram will not answer the objection.

## One tool across the discovery-to-specialization spectrum

This is the user's revised leading frame, not a claim that every transition is implemented.

| Operating point | What is retained or fixed | Role of Evolve |
|---|---|---|
| Direct execution | Source and query; little additional compilation | Can decide further discovery is not worth its cost |
| Adaptive discovery and execution | Candidates, checked structure and current execution state | Continues searching and selecting useful changes using solve feedback |
| Retained specialization | An admitted representation/plan and reusable knowledge | Can pause; subsequent queries reuse the result, with fresh execution state as needed |
| Static specialized kernel | Selected structure and run-constant choices materialized into executable operations | May have run offline; discovery need not be present in the deployed hot path |
| Reopened discovery | Existing artifacts plus changed requirements or measured workload | Reassesses applicability and searches for another useful specialization |

These are choices, not mandatory sequential stages. A workload can remain adaptive, stop
at a retained plan, or use a static kernel from the outset. Reopening discovery requires
retained source/contracts and appropriate tooling; it is not automatic reverse compilation.

“Static” concerns what is specialized, not whether the kernel still performs search.
A specialized exact kernel can process varying inputs and queries inside its admitted
family. It is not a stored answer or a fixture-specific solution. Likewise, selecting an
existing specialized kernel, preparing a data-dependent plan, and generating a new static
kernel are different capabilities. Current selection and learned-only rerun evidence must
not be presented as general kernel-generation evidence.

“Optimal structure” is the search objective. It needs an admitted design space, query family,
workload and cost model, including discovery, verification, compilation, memory, update
cost and expected reuse. Report “best found” unless structural optimality is established
over that space. Exact answers from a specialized solver do not establish that its chosen
structure is globally optimal. Multiple cost objectives can yield several useful choices.

The concrete first-paper demonstration should follow the **same problem family and
contract** through adaptive discovery, retained reuse and optional static specialization,
showing where each pays. Count one-time construction and checking costs and the crossover
in repeated use. If general reification is not yet delivered, identify a bounded existing
path or the exact implementation/evidence gap rather than dropping it from the system's
framing or pretending it already exists. C985 owns that demonstration decision.

## Performance engineering and interactive campaigns

The spectrum has two independent dimensions: **how much computation is specialized** and
**how the investigation is steered**. The expected primary steering actor is an agent;
human steering and mixed agent/human interaction are also part of the framing. An interactive campaign can compare already
specialized kernels; an unattended campaign can continue adapting. A campaign is a durable
investigation involving questions, candidates, runs, evidence and choices, with particular
persistence/control capabilities determined by the implementation. It is not merely a
visualization of a single solve or a compulsory preliminary step before static deployment.

### Engineering as part of the contribution

The research question includes whether discovered mathematical structure survives the
costs of its implementation. A representation can remove states yet lose through memory
traffic, compilation, repeated checking or orchestration. Engineering therefore belongs
inside the explanatory argument and the measurements, rather than appearing only as a
list of optimizations after the mathematics.

The contributor contracts provide concrete internal requirements:

- Resolve run-constant choices before entering specialized execution; preallocate workspace
  and keep the solve loop iterative and allocation-free.
- Use compact contiguous state and explicit layout bounds, with worker-owned mutable data
  and measured communication at safe boundaries.
- Keep discovery, checking, telemetry, serialization and host effects at explicit boundaries
  so the ordinary execution path has a measurable cost and scope.
- Measure mathematical state/work reduction separately from kernel cost, cold construction,
  warm reuse, memory and parallel scaling. Keep rejected variants and clean misses visible.
- Use retained interleaved comparisons, exact result/work accounting, independent checks
  where applicable, and hardware counters to explain a performance conclusion.

These are requirements, not a claim that every current path satisfies them or that the
methods themselves are new. Evidence for a paper must name the implemented path and
measured outcome. The private contributor guides are not public prose sources to copy:
write any publishable engineering account from the approved implementation and retained
evidence, without exporting the process documents or private operational details.

### Campaigns as a way to use the system

A steering agent or human can formulate a question, inspect proposed structures and their evidence,
compare runs, redirect exploration, retain useful discoveries and decide whether a
specialization merits further use. Depending on the supported workflow, stop/resume,
forks, source changes and learned-only reruns make this an ongoing investigation. The
campaign interface must distinguish an observed result, a checked claim and an unresolved
search; steering does not grant a candidate mathematical authority. An agent-facing control
surface and a human-facing UI should expose the same operation semantics and evidence
boundaries. This is an interface requirement, not a claim that every current workflow has
complete agent-facing support. The steering agent chooses goals, probes and campaign actions;
Evolve remains the core system that discovers and adapts computational structure. They are
distinct roles even when an agent automates the whole investigation.

Existing evidence includes the real-workload campaign console and candidate inspector
(C1124/C1126), learned-only execution and explicit verification (C1130), and repairs to
stop responsiveness when hidden history rendering consumed main-thread time. These support
specific interactive workflows, not a universal campaign host or an established improvement
in agent or human productivity. C1084's broader session/repository direction remains a separate
source of design requirements.

For the first paper, show a **campaign-to-kernel narrative** on one admitted family:
the steering agent or human poses a goal, Evolve explores structure, results and counterexamples guide
the next step, retained knowledge supports another solve, and specialization is selected
when worthwhile. Include an unattended version where supported. The narrative connects
interactive use to the same contracts and kernels rather than introducing a separate demo
engine. Static reification remains optional and its implementation gap must be explicit.

Evaluation should ask whether control, telemetry and discovery interfere with useful solve
work. Compare the same computation with supported headless/interactive and telemetry
configurations, state the responsiveness and cancellation boundaries, and retain intervention
sequences for repeatable comparisons. For agents, measure action/observation latency,
tool-call and inference cost, and useful campaign outcomes alongside solve cost. Claims
about steering effectiveness require separate evidence; UI responsiveness alone does not
establish them. A systems-focused follow-on
may study these questions more deeply, but the first paper should already explain and
demonstrate both engineering discipline and interactive campaigns.

## Ranked first-paper frames

Ranking is editorial, against this project's goals; it is not a numerical novelty score.
Every candidate includes Evolve as core. Ranks below one are useful supporting accounts
and possible deeper papers, not proposals to remove Evolve from Ergodis.

| Rank | Frame | Strength and breadth | Main risk / disposition |
|---|---|---|---|
| 1 | Evolve structure, optionally reify it: one discovery-to-specialization spectrum | Unifies adaptive discovery, exact answers, retained representations and static kernels. Evolve remains core across development and deployment. | Requires a same-family demonstration across operating points and an honest distinction between plan selection and kernel generation; leading first-paper candidate. |
| 2 | Evolve query-sufficient structure across algebraic, combinatorial and recursive representations | Connects recovery labels and observables to integer resource envelopes, graph/rule execution and checked representation bridges. Gives rank 1 a concrete account of what structure is discovered and retained. | Breadth of supported types is not novelty; demonstrate connected bridges and acquisition cost, not a universal translation system. Includes the earlier “discover the distinctions sufficient for future questions” frame. |
| 3 | Compile dynamic decision problems and retain reusable knowledge | Makes repeated queries, updates, certificates and cross-run reuse central. Natural systems emphasis. | Universal dynamic-policy and source-edit support exceed delivered families; possible systems-focused follow-on. |
| 4 | Discover and admit theorem-guided search improvements | Closely fits predicate synthesis, symmetry/bound admission and learned-only reruns. Concrete and evaluable. | Can understate query and representation choices; a strong empirical strand of the first paper and possible follow-on. |
| 5 | Exact compositional optimization over finite interfaces | Most direct connection to the existing recovery theory and original C985 theorem spine. | Too narrow as the whole system identity; retain as a mathematical foundation and one family demonstration. |
| 6 | Recursive optimization as a checked computational oracle | A coherent contract, convergence/proof results and executable certificate boundary. | Focuses on one backend and proof consumer; substantial candidate for a separate technical paper, subject to its own literature work. |

An unrestricted “optimizer of all questions, designs and algorithms” is not a competing
first-paper frame: it lacks a bounded evaluation contract. The broader design space belongs
in the system explanation, with implemented subsets and open work identified precisely.

## Representation combination — a supporting unified frame

Candidate thesis, subordinate to the discovery-to-specialization spectrum rather than a
replacement for it:

> Ergodis evolves query-sufficient computational structure across algebraic, combinatorial
> and recursive representations, checks the conditions under which it preserves answers,
> and exploits it through specialized exact execution.

This is an integrated framing hypothesis, not a claim that autonomous cross-representation
optimization is complete. Evolve remains core; agent-steered campaigns can guide which
structures and questions to explore, and actual solves determine whether an admitted
structure pays. Retention or static kernel reification remains optional.

“Boolean, integer, graphs, Datalog” mixes expression types, structures and source languages.
The useful account separates their roles and shows the bridges:

| Layer | Current internal capability | Contribution to the combination |
|---|---|---|
| Boolean/integer expressions | Typed scalar predicates, scores and feature expressions | Express candidate structure and ordering; expressions alone confer no pruning or proof authority. |
| Finite-field/linear structure | Spans, labelled composition, quotients and represented transfers | Preserve algebraic information for composition and witness recovery, not only scalar costs. |
| Integer resources | Load vectors, capacity surfaces and count/resource envelopes | Admitted shapes use specialized exact dynamic programs; this is not unrestricted integer-programming support. |
| Graphs and recursive rules | Finite weighted rule programs with Boolean and bounded min-plus carriers | Cover recursive consequences and least solutions as well as acyclic composition. Datalog parsing, admission and execution remain separate capabilities. |
| Query-dependent summaries | Admitted observables/quotients and checked finite transition lowerings | Make sufficiency relative to the question, permitted transitions/compositions and required evidence. |

Three connections carry the argument. First, Boolean rule production already uses the
min-plus kernel through the exact lift `true → 0`, `false → infinity`, while independent
verification retains Boolean semantics. The incremental recursive runtime currently admits
min-plus only. Second, a summary sufficient for minimum cost or leakage dimension can be
insufficient for class-specific costs or a target-functional query; rejecting the stronger
query is part of correctness. Third, discovered structure must earn its cost in actual
execution: fewer states need not offset discovery, checking, memory, readout or restart cost.

Evidence anchors: core `docs/language-semantics.md`, `docs/rule-contract.md`,
`docs/allocation-specializations.md`, `docs/recursive-queries.md` and
`docs/finite-lowering.md`; C1092's implemented query-specialization examples; the existing
C1130 representation-admission reports indexed above. These are internal capability
references, not claims about the filtered public snapshot.

Positive comparison examples already show why a type checklist is weak positioning:
Z3 has arithmetic and Datalog/Horn facilities, MiniZinc has Boolean/integer modeling and
graph constraints, and egglog combines equality saturation with Datalog. The source
register records the limited documentation read depth; this is not a priority audit.
The proposed distinction is the connected, preservation-aware, solve-cost-driven system,
not an assertion that competitors lack these ideas.

**Paper evidence gate:** demonstrate the bridges, not just inventory the endpoints.
For each selected bridge, identify the source and target representation, preserved query,
admission/checking obligation, witness/readout behavior, Evolve's actual role and measured
end-to-end cost. Separate implemented family-specific bridges from proposed generalization.
Do not imply arbitrary automatic translation, complete Rel execution, universal Evolve
integration or general static-kernel generation.

## Computational realizations and structure folding

Technical explanation beneath the leading discovery-to-specialization frame:

> Evolve searches for cheaper computational realizations of a question—not merely better
> answers within a fixed realization.

An alternative explanatory phrase is **discovering how much structure a computation actually
needs—and how best to realize that structure**. Neither replaces the broad leading title.
Category theory is a candidate organizing language for the transformations and their laws,
not by itself a novelty claim or the proposed first-paper headline.

The C1150 synthesis of Abbott–Zardini separates a semantic layer from an algorithmic layer:
different realizations can have the same meaning and different costs. The Ergodis framing
adds a search role for Evolve, a preservation obligation for admission, and operational cost
feedback from actual solves. This connection is our editorial synthesis; it does not imply
that the cited categorical framework supplies Evolve's search policy or that Ergodis has
implemented a universal categorical IR.

“Structure folding” must distinguish the transformations:

| Mechanism | What changes | Preservation question |
|---|---|---|
| Behavioral quotient | Merge states indistinguishable under admitted observations and future behavior | Which queries and transitions remain well defined? |
| Algebraic fusion | Eliminate intermediate structures or traversals | Does the fused computation preserve the required value and readout? |
| Equivalent-plan rewriting | Replace one computational realization with another | Under which identities and side conditions are the plans equivalent? |
| Symmetry reduction | Avoid redundant equivalent candidates | Are witnesses recoverable and the required search coverage preserved? |

These can share a preservation-and-cost framework without becoming one operation. A smallest
behavioral quotient is not necessarily the cheapest executable realization. The recovery
connection supplies an important constraint: labels dispensable for today's scalar answer
may still be essential for later composition, stronger observables or witness recovery.
Conversely, preserving every source distinction can prevent useful specialization.

The September 12 studies identify quotient construction, semiring shortcut fusion and
equivalent-plan search as relevant directions. They are not evidence that Evolve currently
composes all these transformations autonomously. Their initial mappings rested on documents;
later implementation reports own delivered capability and supersede their historical rankings.

**Candidate discriminating experiment:** follow one problem through two distinct admissible
transformations, for example quotienting and fusion. Compare their alternatives and any valid
composition; show Evolve selecting using total measured cost, including discovery, checking,
compilation and reuse. Identify exactly what is retained, whether a static kernel is reified,
and what remains adaptive. Investigation and a gated pilot are now allocated as C1180/C1181
in `2026-09-13-c1180-c1181-categorical-structure-folding.md`; this is not a reported result.
The queue review also incorporates C1155's correction: certified coarsest observational
quotient construction already exists; the missing investigation concerns generalization and
the complete lift/fold/lower/continue loop, not building another quotient engine.

**Private collaboration context:** Tavis clarified that the categorical lens is partially
inspired by Macready's September 12 email describing a foundation spanning symmetries,
generalized tensors, predicate logic and quantum tensor networks, broader than neural
circuits. The framing question is whether a principled family of semantic structures and
translations can support this breadth, not merely whether tensor-logic syntax can be parsed.
This is private correspondence supplied by Tavis, not an independently inspected system.
The Macready correspondence also motivates a possible interface
to an external categorical compiler: Ergodis as a checked computational oracle for bounded
questions, candidate realizations and certificates. This complements the internal Evolve loop;
it neither makes Ergodis dependent on that stack nor reduces its identity to a backend. The
correspondence is not implementation evidence, an agreed integration, or material for public
attribution without separate approval. Keep the conceptual framing independent of private
correspondence when preparing public prose.

## Editorial direction — September 13 clarification

Repository documentation may present multiple complementary framings for different readers
and uses. There may also be enough material for several academic papers with distinct foci.
Neither the documentation nor the potential paper programme needs one exclusive framing.

The first Ergodis paper should lead with the most distinctive, broadest defensible and
strongest unified frame. Selecting that frame is C1178's primary editorial task. The initial
C985 outline is evidence and a starting point, not a predetermined limit on the first paper's
conceptual scope. **Evolve is a core part of Ergodis.** This is binding user direction,
not a candidate framing to rank against treating it as an optional extension. The first
paper must explain the integrated system: discovery, query/observable and representation
choices, checked admission, exact execution, and feedback from actual solves. Compare ways
to express that unity, not whether Evolve belongs in it. Follow-on papers may develop
particular mechanisms in depth without relegating Evolve itself to a later paper.

Evaluate candidate first-paper frames by:

- **Distinctiveness:** the precise contribution relative to the strongest relevant prior
  work, established by the appropriate literature audit before claiming novelty.
- **Breadth:** one mechanism explains materially different admitted problems; merely naming
  many applications or wrapping different solvers does not establish this.
- **Strength:** a substantial theorem, algorithm or system result with appropriate evidence.
- **Unity:** the mathematical contracts, implemented mechanism and experiments answer the
  same central question. A catalogue of features is not a unified contribution.
- **Supportability:** separate what can be claimed now from the exact additional evidence
  needed for a stronger framing. Do not prefer a weaker story solely because it is ready,
  or present the stronger story as established before its evidence exists.

Return a ranked comparison and a recommended first-paper thesis, including its strongest
objection and missing evidence. Also sketch distinct potential follow-on papers, stating
their independent contributions and overlap. These are planning candidates, not new task
allocations, manuscript splits or commitments to publication. Keep the documentation's
multiple entry points connected to the same definitions and evidence boundaries.

## Working account

Ergodis compiles mathematical structure into exact computation. Its central question is
which information a local state must retain so that the requested answers remain correct
under the admitted compositions, contexts and updates. Retained witnesses connect the
compiled answer back to the original problem.

The recovery application makes this concrete: a minimum helper count discards the functional
that an outer code needs. Retaining labelled costs allows exact composition; retaining
support alternatives enables additional operational questions, and coefficient lifts turn
a selected repair into something executable. The right state depends on the question.

Evolve is Ergodis's core discovery and adaptation system for finding useful structure and
choosing how to exploit it. It can search for predicates, bounds, representations and execution strategies; the
broader semantic direction includes questions, observation protocols and source designs
under explicit evaluation contracts. Discovery, mathematical admission and measured utility
are separate obligations. Actual solves can supply witnesses, counterexamples and performance
observations that guide later discovery.

Candidate short framing from the September 13 discussion:

> Ergodis turns knowledge about which distinctions matter into reusable exact computation;
> Evolve searches for knowledge that makes that computation cheaper.

This is an editorial hypothesis, not a theorem, a novelty verdict or a claim that the whole
autonomous loop is implemented. The paper needs a precise mathematical contribution and
measured evidence beneath this sentence.

## Framing inventory and provenance

| Framing | Central idea and use | Source and boundary |
|---|---|---|
| Exact recovery information that composes | Scalar minima discard needed labels. Preserve functionals, costs, supports and lifts at the appropriate level. Best concrete motivation. | `papers/complete-repair-ports/compositional_recovery.tex`, abstract and introduction; `sections/03a-exact-recovery-optimization.tex`; paper README. Distinguish equation confinement from confinement of minimal supports; retain the hypotheses of each. |
| Contextual quotient compiler | Derive the interface state, identify equivalent decisions, compose or search the resulting finite problem, reconstruct a witness. Mathematical foundation within the unified frame. | `notes/2026-08-27-c985-ergodis-optimization-paper.md`, Objective and Proposed theorem and algorithm spine; core `OPTIMIZATION.md` opening. Quotient construction, algorithmic improvement and engineering require separate ablations. |
| Algebraic dynamic programming and exact resource fronts | Finite ordered-monoid and fixed-dimensional Pareto states support witness-preserving composition. Express what the common kernel actually shares across domains. | C985 task specification, theorem/algorithm spine and evidence gate. Fixed-dimensional additive resources must not be conflated with per-helper packing/capacity states. Recheck theorem hypotheses before manuscript use. |
| Compile structure before search | Source algebra, conserved gradings, spans, symmetries and reconstructible blocks expose cheaper exact problems. Accessible README/optimization-doc entry. | Core `README.md` and `OPTIMIZATION.md`; `notes/2026-08-30-c985-residual-hitting-positioning-and-extension-plan.md`. A classical residual solver can sit below an interesting compiler; identify where the contribution lies. |
| Discover useful necessary conditions and invariants | Finite labelled corpora support exact candidate discrimination, semantic niches and counterexample-guided refinement. A concrete early Evolve framing. | `notes/2026-09-01-c985-evolve-sota-synthesis-lineages.md`, Ergodis shorthand and research lineages. Exactness on the corpus is not a proof over a larger deployment domain. This is a historical implementation description. |
| Cost-aware theorem selection | Separate reusable semantic facts from workload-specific performance priors; use probes and feedback to select useful exact transformations. | `notes/2026-08-30-c985-ergodis-adaptive-search-learning-adr.md`, Decision summary; `notes/2026-09-01-c985-evolve-proposal-admission-architecture.md`. An ADR states a decision/target; implementation claims need the subsequent evidence. |
| Query-directed specialization | One model supports different representations and evidence for different questions. Query reuse has an admission boundary. | `notes/2026-09-07-c1091-core-semantic-contracts.md`, especially final query/design discussion; `notes/2026-09-07-c1092-query-specialization-corpus.md`. Initial private examples establish scoped reuse/rejection, not a universal exploration API. |
| Recursive exact backend and checked oracle | Finite weighted rules, least fixpoints and independently checked certificates connect compilation to recursive queries and proof consumers. | `notes/2026-09-12-c1163-rule-contract.md`, C1164 oracle report, C1173 support-certificate report and C1174 generic-carrier report. Distinguish the supported carriers/programs, proof statements, ABI exposure and broader frontend ambitions. |
| Operational system with retained knowledge | Compilation, solve, verification, updates and history become reusable workflows with explicit identities and scopes. | C1084 portable-control architecture and the architecture map's records/repository routes. Opening a record does not establish execution or proof authority. This supports the product story rather than replacing the mathematical result. |
| Joint meta-optimization under preservation contracts | Optimize queries, observables, representation, execution and evidence cost together, using actual solves as feedback. | September 13 discussion plus C1091/C1092. This is a synthesis of established ideas and project direction; distinguish delivered family mechanisms from autonomous end-to-end integration. |
| Semantic sensitivity | Retain sufficient signatures so admitted future cost/feasibility edits can reuse a compiled family. Connects query contracts to reuse. | September 5 brainstorm, Semantic sensitivity and final red-team verdict; reconciled by C1091. Fixed-family coverage and edit factorization are hypotheses; arbitrary code mutation is not admitted. |
| Decision-sufficient observation and design synthesis | Select what to observe, or which source system to build, according to operational utility and information order. | September 4 design-synthesis/event-vocabulary passages; September 5 query-budget discussion; C1091/C1092. Broad research direction, not universal autonomous query/design discovery. |

Paths beginning `notes/` and `papers/` refer to the Othello monorepo. Core paths refer to
`~/src/ergodis`. Older C985 reports still carry historical `complete-ports` pegs and
pre-split software paths; the live queue pegs C985 to `ergodis`. Follow current repository
ownership rather than treating those historical paths as editing instructions.

## Recovery as the opening example

A useful explanation proceeds through four questions:

1. How many helpers are needed? A scalar optimum answers one local question.
2. Which intermediate functional do they supply? Labels make the local result composable.
3. Which repairs remain available under failures, prices or capacity limits? Appropriate
   support alternatives retain information that one optimum discarded.
4. How is the chosen repair executed? Coefficient witnesses lift the answer to the code.

This sequence explains why semantic state matters before introducing quotient terminology.
It also prevents overgeneralization: information sufficient for minimum cost need not
preserve availability probabilities, all minimal supports or an implementable policy.
Complete-ports supplies precise recovery theorems; their extension to another family needs
its own correspondence and preservation argument.

## What the historical sources change

The September 4 proposal emphasizes an optimization congruence and finite-state dynamic
execution. Its architecture is useful provenance, but its broad theorem package and informal
ratings are proposals, not evidence. The September 5 text supplies the decisive correction:
budget compilation around the query, refine a proved relaxation when needed, and include
construction, updates and verification in total cost. C1091 explicitly broadens representation
contracts to catalogs, envelopes, event circuits, policies and bounds. It also separates
executor, runtime and host; historical crate sketches must not overwrite that distinction.

The same September 5 source retracts overly broad pricing, reliability and arbitrary-code-edit
claims. Semantic sensitivity survives as a conditional research direction. C1062's reviewed
causal results make the cost warning concrete: carrier construction can lose to memoized
direct solving, and raw state ratios were not valid performance evidence. This is a useful
negative for a paper about choosing computation, not a reason to conceal the causal work.

The current complete-ports manuscript keeps labelled composition in the main exposition and
minimal numerical state in a secondary appendix. That editorial choice fits its recovery
question; it does not set the first Ergodis paper's scope. C1070 supplies another reading of
the recovery interface: legitimate reconstruction and adversarial disclosure ask related
questions of the same linear model. Its linear-uniform and randomness assumptions remain
part of the example, and its literature assertions are not re-certified here.

## First-paper structure and evidence obligations

1. **Problem and concrete opening.** Explain that a fast exact optimizer must choose which
   distinctions to retain and which structure to discover. Use recovery labels as the
   first miniature: a local cost alone cannot tell an outer composition which functional
   was supplied. Immediately show how discovery, a counterexample and admission enter the
   system, rather than postponing Evolve to an applications section.
2. **Semantic contracts.** Specify source, query, observation/context family, objective,
   representation, answer lift, updates and evidence. Distinguish full answer preservation,
   a sound bound and feasible-witness construction. State existing family results and the
   precise shared proposition needed for composition of admitted transformations. Do not
   invent a universal theorem from the diagram.
3. **Evolve and exact execution.** Explain candidate generation, challenge/checking,
   cost-aware selection, admission at safe boundaries, execution and retained knowledge.
   Keep semantic facts and performance priors distinct. Explain what happens after a failed
   check or a poor performance prediction, including direct solving and explicit restart.
   Show the same mechanisms in an interactive campaign and explain how the performance
   architecture preserves efficient execution while agents or humans inspect and steer discovery.
4. **Concrete instantiations.** Recovery anchors composition and witness reconstruction;
   privacy supplies an independently checked distinguishing-context example; allocation
   and another genuinely noncoding family must expose the same substantive mechanisms.
   Recursive rules show how the contracts support a different mathematical execution path.
   Choose a few examples that demonstrate the mechanism rather than listing every adapter.
5. **Evaluation.** Measure correctness, discovery utility, total cost and reuse on declared
   families. Preserve C985's two-noncoding-model gate and its separate quotient, algorithm
   and engineering ablations. Add discovery-off, supplied-structure, learned-only and
   miss/rejection controls; comparable arms receive the same initial information. Include
   compilation, checker and restart costs, held-out instances, work counts and negative cases.
   Account for telemetry/control overhead and the interactive responsiveness boundary;
   distinguish semantic gains from machine-level engineering and agent/human intervention.
6. **Limits and related work.** Explain which inputs supply structure, what is discovered,
   what is proved and when no gain is expected. Locate the specific contribution relative
   to automated modelling, abstraction refinement, synthesis, adaptive execution and
   metareasoning. Discuss broader query/design search as an extension of the core system.

**Recommended second miniature.** In the admitted binary privacy fixture, observing a mask
and observing nothing currently disclose the same secret information. Appending the masked
secret separates them. The five-state leakage-only summary fails transition admission;
the full joint-span representation admits it, and a fifteen-state readout quotient has a
kernel-checked minimality result for its declared append/readout semantics. C1162 and C1166
provide the exact definitions and evidence. C1162 synthesizes the summary transition for a
supplied lowering; it does not establish autonomous discovery of the optimal lowering.
This example explains why the question includes future contexts and why checks matter.
It is a private evidence candidate, not content authorized for automatic public export.

## Evidence supporting the integrated account

These are dispositions of existing reports, not newly reproduced computations. Exact inputs,
hashes and validation records remain in their owning reports; do not copy their results into
a manuscript without checking the full evidence and release scope.

| Mechanism | Current evidence | What must not be inferred |
|---|---|---|
| Query-specific reuse and rejection | C1092 privacy/causal/QEC examples; C1093 concrete LRC model/plan/query adapter | A universal public query schema, autonomous selection of queries, or independent optimality certification for that adapter |
| Counterexample-guided summary synthesis | C1162 finite lowering checker and supplied privacy family | Synthesis of arbitrary models or lowerings; hot-loop performance gains |
| Meaning and minimality of an observation state | C1166 physical-world readout/trace proof and finite fifteen-state result | A universal minimal-representation algorithm or a timing claim |
| Discovery admitted into execution and reused | C1130 overnight source-only proposals, checked root reductions and learned-only reruns | An independently certified minimum distance from a symmetry certificate |
| Checked execution-representation change | C1130 allocation plan/performance reports: setup selection and active admission through the same applicability check | Conversion of the old dynamic-programming state; a restart is explicit and has cost |
| Parameterization discovery | C1130 parameterization checkpoint: checked substitutions and original-equation witness replay | Coverage of the original search space from a witness-preserving embedding |
| Recursive exact certificates | C1163/C1164/C1173/C1174; C1176 settles rounds, invariance and algebra gates | All semirings, arbitrary recursion, or a complete public Rel frontend |
| Cost of choosing a representation | C1062 causal compilation negative; C1130 recognition/miss overhead; C1176 dense-frontier negative control | A universal winning policy; the selector still needs a matched end-to-end study |

The most valuable missing experiment is a **coupling ablation**: do discovery, admission
and reuse together beat a strong system with those pieces available but chosen statically?
A second, stronger target varies the query/observable requirement while preserving a
declared operational goal, then measures whether a different admitted representation pays.
Existing results establish ingredients; this report does not claim that either complete
experiment has already passed. C985 owns deciding and allocating the extra evidence work.

## Audience-specific draft prose

The following are editorial drafts stored privately. They contain no internal task IDs or
private paths, but they are not approved publication text. Product identity and delivery
scope must be stated together when a draft is promoted.

### Paper abstract opening

> Exact optimization depends on how a problem is represented and on which properties of
> its solutions a query requires. Ergodis organizes discovery and exact execution along
> a spectrum: useful structure can remain subject to adaptation, be retained for repeated
> queries, or be materialized as a specialized kernel. Evolve searches for that structure;
> preservation contracts specify its admissible questions, contexts and answer-reconstruction
> obligations. Witnesses, counterexamples and execution measurements guide further discovery
> and the choice of how much computation to specialize. Interactive campaigns let agents and people
> inspect and steer this process, while the execution architecture separates discovery and
> control from specialized solve kernels whose costs can be measured independently.

This is an opening, not a fabricated finished results abstract. The final abstract must
add the precise principal result, admitted families and measured outcome once C985's
paper evidence is fixed. Do not fill those slots with “broadly faster” or “fully verified.”

### Paper introduction opening

> An optimizer may spend most of its time distinguishing states that the requested answer
> cannot distinguish. It may also discard a distinction that a later query needs. Linear
> recovery exhibits both problems: a local minimum cost omits the functional supplied by
> the chosen repair, while retaining every coefficient choice can preserve much more than
> an outer composition requires. Efficient exact computation therefore depends on finding
> a useful representation together with the conditions under which it remains sufficient.
>
> Ergodis brings that choice into optimization itself. Evolve searches for useful
> structure, and the system checks what the resulting transformation permits before
> using it. The retained contract connects a source problem and query to an executable
> representation and a way to recover or check the answer. Actual executions provide
> counterexamples, witnesses and cost information for the next search for structure.
> Discovery and execution thus participate in one adaptive computation.

Follow with the theorem/system contribution at its actual scope, the concrete discovery
example, and the evaluation question. The broad identity does not imply that every current
provider implements every step of this loop.

### System documentation / README identity

> Ergodis brings adaptive discovery and specialized exact computation into one system.
> Evolve searches for useful problem structure. That structure can guide an ongoing solve,
> be retained for repeated queries, or be materialized into a specialized kernel where
> supported. The system tracks the conditions under which each specialization preserves
> the required answer. Interactive campaigns support inspecting and steering discovery;
> specialized execution and explicit control boundaries make performance part of the design.

For a **core-library README**, immediately add:

> This repository provides the reusable compilation, solving and verification components.
> Available workflows depend on the components and domain packages included in the release.

That sentence explains packaging without redefining Evolve as peripheral. Concrete public
commands must come from the checked release, not a private demo or a development report.
The inspected local `public` snapshot is `3291659` / `v0.1.0-preview1`, based on private
revision `23e1afe6`. Its tree lacks `crates/rules`, `docs/rule-contract.md`,
`docs/finite-lowering.md` and `rust-toolchain.toml`; do not advertise newer main-branch
capabilities as present in that snapshot. This was a local Git inspection, not a GitHub
publication check. No export, push or public-document edit was performed.

### Conceptual documentation example

> A model describes the problem. A query specifies the answer required; an observable
> specifies information that can be read from the model. The objective orders acceptable
> solutions. A representation retains enough information for admitted questions and
> contexts, and a compiled plan implements computations over that representation.
>
> Evolve can propose a cheaper representation or execution strategy. The proposed change
> must establish the preservation or bound required by its role before it can affect an
> exact answer. A finer query can invalidate an earlier representation even when the source
> model is unchanged. Performance measurements help choose among admitted plans; they do
> not establish mathematical equivalence.
>
> Evolve's broader search space includes which questions to ask and which observations
> to obtain. Those choices require an operational objective and explicit allowed changes.
> Rewriting a fixed question, choosing a different question and designing a different
> source system are separate operations.

The concept pages can offer recovery, contextual equivalence, recursive rules, discovery,
certificates and saved-workflow routes. Each route should point back to this common
vocabulary while giving its own example. Multiple explanations are useful; contradictory
definitions or unsupported delivery claims are not.

## Potential paper programme

These are candidate contributions, not allocated tasks or promised papers. The first paper
contains the integrated Ergodis/Evolve identity. Later papers need independently substantial
results and should not merely repackage its architecture or reuse its experiments as new.

| Candidate focus | Independent contribution to develop | Relation to first paper |
|---|---|---|
| First: discovery and compilation for exact optimization | Shared preservation/admission account plus a substantive integrated implementation and coupling evidence | Establishes the system and its central research question |
| Contextual sufficiency and semantic sensitivity | Constructive sufficient states, query/update families, width/size bounds, and limits on reuse | Deepens one mathematical foundation; novelty and construction complexity require separate work |
| Recursive optimization and proof-producing oracles | Admitted algebraic classes, convergence, certificate completeness/checking cost, and incremental proof transport | Develops the recursive/proof path already introduced in the first paper |
| Learning useful exact structure from solves | Cost-aware discovery, semantic versus performance knowledge, cross-instance transfer and regret/miss evidence | Deepens Evolve's methods and evaluation; Evolve remains central in paper one |
| Dynamic query and representation adaptation | Amortized compilation, update admission, representation changes and measured lifecycle cost | Develops the repeated-workload systems contribution |
| Domain papers, where warranted | Recovery, leakage or a design/search family with its own theorem or externally significant result | Complete-ports already owns the recovery manuscript; other domain claims need their own novelty/evidence gates |

## Meta-optimization and no free lunch

The September 13 discussion contributes an organizing hypothesis: jointly choose the
information to retain and the computation that consumes it, then feed solve results back
into discovery. Observables, objectives and observation protocols have different roles;
changing a question or guarantee needs an outer operational utility contract.

The total-cost comparison includes discovery, compilation, admission, solve, verification,
updates and expected reuse. A smaller quotient can cost more overall. Direct solving is a
legitimate selection. Checked knowledge can be retained across runs only where its
applicability contract permits; performance priors require evidence of workload relevance.

No-free-lunch results motivate explicit problem-distribution and structural assumptions.
They neither establish a speedup nor make a meta-optimizer exempt from those assumptions.
The conversation's literature survey identified substantial precedents: algorithm
configuration, adaptive query processing, automated constraint modelling, equality
saturation, CEGAR, rational metareasoning and self-improving algorithms. Treat that survey
as orientation, not a completed novelty audit. Before a manuscript-bound absence or
priority claim, follow `notes/literature-audit-conventions.md` and the shared cache rules.

Useful starting references from that discussion:

- Wolpert and Macready: https://research.ibm.com/publications/no-free-lunch-theorems-for-optimization
- Self-improving algorithms: https://arxiv.org/abs/0907.0884
- Progressive optimization: https://research.ibm.com/publications/robust-query-processing-through-progressive-optimization
- Automated model refinement: https://conjure.readthedocs.io/en/latest/
- Equality saturation: https://arxiv.org/abs/2004.03082
- Rational metareasoning: https://aima.eecs.berkeley.edu/~russell/research-bo.html

## Acceptance and handoff

- **Source comparison delivered:** bounded original-brainstorm passages, C985 specification,
  current recovery manuscript passages, semantic-contract reports and delivered Evolve
  mechanisms were compared. The companion source register states every read boundary.
- **Recommendation delivered:** a ranked comparison, proposed title/thesis, strongest
  objection, first-paper structure and distinct possible follow-on contributions.
- **Drafts delivered:** paper abstract/introduction openings, integrated system identity,
  core-package scope wording and conceptual documentation. These are private review drafts.
- **Evidence requirements delivered:** existing support and explicit gaps, including the
  coupling ablation and the stronger operationally equivalent query-design experiment.
- **Publication boundary checked locally:** the filtered snapshot is older than current
  rule-contract work; no current-private capability was silently advertised as exported.
- **Manuscript source gap recorded:** C985's outline and complete-ports sources were found;
  a separate optimization manuscript was not located in the bounded routed search. Its
  location was requested from Tavis. No missing manuscript is claimed as read.

C1178 completes the framing deliverable. **Recommended next work: C985**, beginning with
the proposed integrated thesis, precise contribution/evidence obligations and any supplied
manuscript path. This is a paper-planning route, not permission to launch unrelated code
searches, alter acceptance gates or publish private material. C985 should resolve the exact
contribution before commissioning a claim-specific novelty audit and any new experiments.
The remaining scientific questions belong to the paper's evidence work, not to an indefinite
extension of this editorial task.

## Mystery ledger — explicit ej + tt closeout

The main editorial acceptance gate passed: the recommendation, ranked alternatives,
source depths, drafts and evidence gaps are reviewable. The closeout asked what the same
mechanism explains across families and what an adversarial comparison would remove.

| Question | Closeout disposition | Remaining gate / owner |
|---|---|---|
| Why can a smaller representation fail to make solving cheaper? | Conceptually settled: construction, admission, readout, updates and reuse determine total cost; C1062 and C1130 provide concrete warnings. This corrects the early compulsory-minimization framing. | C985 must measure the actual selector against strong direct and static alternatives. No universally best selection policy is established. |
| What makes several mechanisms one contribution? | Sharpened: their interaction must change admitted computation and improve a common workload. Added a coupling ablation, not merely more domain demonstrations. | C985: precise common result/contract and measured coupling evidence; cross-domain integration is not established by a shared interface alone. |
| What does “learn from solves” retain? | Settled at the framing level: distinguish reusable checked semantic facts from revisable performance priors and ordinary answer records. | C985/Evolve evidence: show nontrivial reuse on declared held-out queries/instances and account for acquisition/checking costs. |
| Can query selection preserve the real task while changing observables? | Meaning clarified: evaluate the outer operational decision under declared permitted changes; distinguish it from rewriting a fixed question. | C985: one concrete operationally equivalent comparison. Broad autonomous question/design selection remains a target. |
| Is the proposed combination a new research contribution? | Not settled by this framing pass; established precedents are recorded without weakening them. | C985: identify the exact contribution, perform the proportionate primary-source novelty audit, then write any priority claim in its owning ledger. |

No additional mathematical mystery was manufactured and no new proof or benchmark is claimed.
The lane discovery companion was reviewed at handoff; all observations here answer C1178's
planned framing questions, so no incidental discovery entry was added.

Validation: scoped whitespace/diff checks, exact source-location checks for the consulted
reports, an exact local public-tree check, and a prose review for Evolve's core status,
claim strength and private/public boundaries. No solver, Lean build or benchmark was run.
