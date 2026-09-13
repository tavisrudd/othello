# C1178 — Ergodis framing for the optimization paper and documentation

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: QUEUED; initial source-grounded framing document started.
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
No manuscript, public README, export or publication is changed by this initial document.

## Editorial direction — September 13 clarification

Repository documentation may present multiple complementary framings for different readers
and uses. There may also be enough material for several academic papers with distinct foci.
Neither the documentation nor the potential paper programme needs one exclusive framing.

The first Ergodis paper should lead with the most distinctive, broadest defensible and
strongest unified frame. Selecting that frame is C1178's primary editorial task. The initial
C985 outline is evidence and a starting point, not a predetermined limit on the first paper's
conceptual scope. Do not automatically assign Evolve to a later paper or subordinate it to
the quotient story before comparing the alternatives.

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

Evolve extends the design space to discovering useful structure and choosing how to exploit
it. It can search for predicates, bounds, representations and execution strategies; the
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
| Contextual quotient compiler | Derive the interface state, identify equivalent decisions, compose or search the resulting finite problem, reconstruct a witness. Natural mathematical center for the optimization paper. | `notes/2026-08-27-c985-ergodis-optimization-paper.md`, Objective and Proposed theorem and algorithm spine; core `OPTIMIZATION.md` opening. Quotient construction, algorithmic improvement and engineering require separate ablations. |
| Algebraic dynamic programming and exact resource fronts | Finite ordered-monoid and fixed-dimensional Pareto states support witness-preserving composition. Express what the common kernel actually shares across domains. | C985 task specification, theorem/algorithm spine and evidence gate. Fixed-dimensional additive resources must not be conflated with per-helper packing/capacity states. Recheck theorem hypotheses before manuscript use. |
| Compile structure before search | Source algebra, conserved gradings, spans, symmetries and reconstructible blocks expose cheaper exact problems. Accessible README/optimization-doc entry. | Core `README.md` and `OPTIMIZATION.md`; `notes/2026-08-30-c985-residual-hitting-positioning-and-extension-plan.md`. A classical residual solver can sit below an interesting compiler; identify where the contribution lies. |
| Discover useful necessary conditions and invariants | Finite labelled corpora support exact candidate discrimination, semantic niches and counterexample-guided refinement. A concrete early Evolve framing. | `notes/2026-09-01-c985-evolve-sota-synthesis-lineages.md`, Ergodis shorthand and research lineages. Exactness on the corpus is not a proof over a larger deployment domain. This is a historical implementation description. |
| Cost-aware theorem selection | Separate reusable semantic facts from workload-specific performance priors; use probes and feedback to select useful exact transformations. | `notes/2026-08-30-c985-ergodis-adaptive-search-learning-adr.md`, Decision summary; `notes/2026-09-01-c985-evolve-proposal-admission-architecture.md`. An ADR states a decision/target; implementation claims need the subsequent evidence. |
| Query-directed specialization | One model supports different representations and evidence for different questions. Query reuse has an admission boundary. | `notes/2026-09-07-c1091-core-semantic-contracts.md`, especially final query/design discussion; `notes/2026-09-07-c1092-query-specialization-corpus.md`. Initial private examples establish scoped reuse/rejection, not a universal exploration API. |
| Recursive exact backend and checked oracle | Finite weighted rules, least fixpoints and independently checked certificates connect compilation to recursive queries and proof consumers. | `notes/2026-09-12-c1163-rule-contract.md`, C1164 oracle report, C1173 support-certificate report and C1174 generic-carrier report. Distinguish the supported carriers/programs, proof statements, ABI exposure and broader frontend ambitions. |
| Operational system with retained knowledge | Compilation, solve, verification, updates and history become reusable workflows with explicit identities and scopes. | C1084 portable-control architecture and the architecture map's records/repository routes. Opening a record does not establish execution or proof authority. This supports the product story rather than replacing the mathematical result. |
| Joint meta-optimization under preservation contracts | Optimize queries, observables, representation, execution and evidence cost together, using actual solves as feedback. | September 13 discussion plus C1091/C1092. This is a synthesis of established ideas and project direction; distinguish delivered family mechanisms from autonomous end-to-end integration. |

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

## Different openings for different readers

**First optimization paper.** Select the strongest unified thesis using the criteria above.
One candidate opening is a concrete failure of an insufficient state and the mathematical
state that repairs it; another makes checked discovery and query-directed specialization
central. Compare them before deciding how quotient compilation, Evolve and recursive
contracts contribute to the argument. C985's original gate requires material reduction
from the shared kernel on two noncoding models; a shared wrapper is insufficient. A broader
thesis must identify its additional evidence obligations rather than quietly weakening
this existing gate.

**README.** Start with problems a reader can solve, required structure, the returned answer,
and one runnable example. Candidate wording for later validation: “Ergodis compiles
structured finite optimization problems into reusable exact computations, retaining the
information needed to reconstruct answers in the original problem.” Then state the
supported families and where Evolve is available. Do not use an unrestricted “every answer
is independently certified” claim.

**Conceptual documentation.** Explain model, query, observable, objective, representation,
compiled plan and evidence using one model with two questions and one rejected reuse.
Use the public glossary as terminology authority. Explain Evolve through a concrete
proposal → check → admit → execute → measure → reuse workflow with explicit scope.

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

## Remaining work and acceptance

1. Complete a bounded provenance pass through the C985 onward framing/architecture reports,
   including the two September 4–5 brainstorm sources routed by C1091. Those long historical
   sources were not reread for this seed; C1091's synthesis was used. Recover other genuinely
   distinct framings and reconcile corrections rather than accumulating slogans.
2. Locate and inspect the current optimization manuscript's opening/results and compare them
   with the original C985 specification. This seed inspected the C985 task card and current
   complete-ports abstract/recovery section, not the optimization manuscript itself.
3. Attach an exact source and evidence scope to each proposed public claim. Separate theorem,
   implementation, tested family, historical proposal and research target. Preserve the
   distinction between witness feasibility, optimality, exclusion and source equivalence.
4. Rank candidate unified frames and recommend the most distinctive, broad and strong
   defensible thesis for the first Ergodis paper, with a concrete opening example and
   explicit evidence gaps. Sketch independently substantial follow-on paper candidates.
   Prepare README and conceptual-documentation drafts that can retain multiple framings.
5. Test the strongest integration story: does changing the admitted observation requirement
   enable a checked representation change that improves subsequent solves after all costs?
   Record this as an evidence requirement, not a request to run new benchmarks under this task.
6. Review proposed public prose against the actual export: no internal IDs, private paths,
   correspondence, unpublished domain knowledge or private performance results. Cite public
   artifacts only after their publication state is checked. Do not copy this document into
   a public tree or automatically export it.

The task is complete when the source-grounded framing choices, audience-specific drafts and
remaining claim/evidence gaps are reviewable here. Publishing or editing the downstream
manuscript/README requires the relevant owner and validation workflow; this task does not
silently expand a mathematical claim or choose a new paper scope.
