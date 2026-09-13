# C1178 — framing sources and comparison boundary

**Lane**: `ergodis`
**Date**: 2026-09-13
**Visibility**: PRIVATE editorial provenance; do not export.

## Read scope

This is a bounded framing/provenance review, not a novelty audit. **Zero external research
papers were newly read at full text.** No claim that a predecessor does not exist is made.
Existing task reports supply implementation and mathematical evidence at their stated
scope; their cited literature is not promoted to primary evidence by this review.
No external PDF was downloaded or re-fetched. Official web pages and abstracts were read
through the browser; no PDF-cache key or hash is claimed for those accesses.

The author selected headings and passages on framing, contracts, stated results and later
corrections. The two brainstorm documents were not read end to end. Their proposals were
checked against C1091 and later task reports before becoming part of the recommendation.
The selection is sufficient for an editorial synthesis, not exhaustive historical coverage.

## Categorical realization / folding supplement

September 13 follow-up recovered the September 12 discussion through these internal sources:

- `2026-09-12-c1150-category-theory-for-ergodis.md`: named-source verdict and synthesis,
  especially semantic versus algorithmic layers. This supplement relies on that report's
  attribution and read-depth record; the external paper was not newly read.
- `2026-09-12-c1151-category-theory-capability-pass.md`: report, organizing principle,
  recommendation changes, merged ranking and allocated-slice table. Its explicit warning
  that the original mappings were documentation-based remains applicable.
- `2026-09-12-c1150-part-b-compilers-solvers-normalization.md`: Little–He–Kayas source entry
  and shortcut-fusion/tupling summary, not the underlying paper or the full dossier.
- `ergodis-discovery-track.md`: September 12 categorical leads and Macready correspondence
  entry only; correspondence is private and not evidence of implemented capabilities.
- `2026-09-12-relationalai-datalog-reading.md`: motivation, compilation-target requirements
  and adjacent comparison passage. This supplement does not adopt its absence claims.
- `2026-09-12-alvaro-datalog-reading.md`: questions for Macready about rewrite conditions
  and commuting squares; no claim that the questions have been answered.
- `2026-09-12-ergodis-rule-contract-programme.md`: motivation and compiler/oracle interface
  questions. Historical implementation ordering is not a current status source.

Read depth here is selected internal passages, not a fresh primary-literature audit, proof
check or implementation test. The realization-search framing and proposed two-transformation
experiment are editorial synthesis. No external source was newly fetched for this supplement.

## Representation-combination supplement

September 13 follow-up discussion added the representation-combination option. Internal
read scope: core `docs/language-semantics.md` typing/operation/role passages;
`docs/rule-contract.md` Boolean lift and independent-checker passage;
`docs/allocation-specializations.md`, `docs/recursive-queries.md` and
`docs/finite-lowering.md` opening contracts; C1092 implemented-example section;
the current lane handoff and architecture map. These were targeted contract reads, not a
new implementation audit or execution of tests. The current handoff supersedes the
architecture map's stale queued labels for C1176/C1177.

Positive external comparisons were consulted in the preceding discussion through official
web documentation/search excerpts, not full papers or implementation audits:

- Z3 arithmetic and Datalog/Horn facilities: https://microsoft.github.io/z3guide/docs/theories/Arithmetic/
  and https://microsoft.github.io/z3guide/docs/fixedpoints/syntax/ — documentation excerpts.
- MiniZinc modeling types and graph constraints: https://docs.minizinc.org/en/stable/spec.html
  and https://docs.minizinc.dev/en/latest/lib-globals-graph.html — documentation excerpts.
- egglog equality saturation plus Datalog: https://github.com/egraphs-good/egglog and
  https://egraphs-good.github.io/egglog-tutorial/01-basics.html — README/tutorial excerpts.

These establish overlapping positive capabilities only. No absence, priority, comparative
performance or complete feature-parity claim follows. No private material was sent in
external searches, and no public-facing document was changed.

## Internal source register

Paths are relative to the Othello repository unless marked core/private. The selected
sections identify the read boundary rather than implying full-text review. Earlier reads
in this conversation are included where they inform C1178.

| Source | Read depth / passages | Use in the framing |
|---|---|---|
| `notes/2026-08-27-c985-ergodis-optimization-paper.md` | partial: opening, Objective, Primary audience, Proposed theorem and algorithm spine, Evidence gate; targeted manuscript/path references | Original optimization audience and theorem/benchmark obligations; old lane peg is historical |
| `papers/complete-repair-ports/compositional_recovery.tex` | partial: abstract, introduction roadmap/input list | Recovery identity and separation of main composition story from secondary numerical minimization |
| `papers/complete-repair-ports/README.md` | partial: title and opening account | Current recovery-facing explanation |
| `papers/complete-repair-ports/sections/03a-exact-recovery-optimization.tex` | partial: opening and propositions `prop:exact-hierarchical-optimizer`, `prop:pricing-availability-equivalence` | Composable labels, coefficient witnesses, support/price/availability interpretation under fixed-family hypotheses |
| `papers/complete-repair-ports/sections/09-contextual-refinement.tex` | partial: opening scope statement | Numerical fixed-boundary observations do not replace operational support families |
| core `README.md`, `OPTIMIZATION.md`, `docs/glossary.md` | partial: README/optimization openings and selected discovery entries; glossary Languages and implementations | Current public-facing vocabulary and the difference between broad system identity and package contents |
| core `public:README.md`, `EXPORTS.md` and selected `public` tree paths | partial: README opening; full five-line export ledger; exact tree lookup | Local snapshot `329165987ecb2aef12fb1d04711dff906753d52d`, tag `v0.1.0-preview1`, from `23e1afe6decb0d14b3243411b6546858744dc292`; newer rule/lowering docs absent there |
| `notes/2026-08-30-c985-residual-hitting-positioning-and-extension-plan.md` | partial: Executive verdict | Distinguish a compiler contribution from the classical residual subproblem it emits |
| `notes/2026-08-30-c985-ergodis-adaptive-search-learning-adr.md` | partial: Decision summary | Contextual cost-aware control and separate semantic facts/performance priors |
| `notes/2026-09-01-c985-evolve-sota-synthesis-lineages.md` | partial: Ergodis shorthand and section-heading inventory | Historical finite-corpus predicate discovery; literature lineages are secondary pointers only |
| `notes/2026-09-04-ergodis-commercial-evolve-brainstorm.md` | partial: headings; semantic-compilation and design-synthesis openings; optimization-congruence setup/laws; refinement; event vocabularies; proposed mathematical-paper section (lines 241–260, 339–358, 457–496, 521–560, 1169–1188, 1326–1365 at review) | Recover the original congruence, event and design frames; broad theorem package and commercial ratings remain proposals |
| `notes/2026-09-05-ergodis-semantic-sensitivity-brainstorm.md` | partial: headings; query-directed budgeted compilation, total-cost warning, red-team corrections, semantic-sensitivity setup and final verdict (834–872, 2668–2687, 2738–2797, 3108–3127) | Core correction: sufficient/affordable representation rather than compulsory global minimization; conditional edit reuse |
| `notes/2026-09-07-c1091-core-semantic-contracts.md` | partial: decision, semantic distinctions, representation contracts, rejection fixtures and final query/design discussion | Reconciles brainstorms; explicit plural preservation contracts and query/source-design search |
| `notes/2026-09-07-c1092-query-specialization-corpus.md` | partial: motivation, observables/objectives/protocols and implemented examples | Scope of query-specific reuse and semantic examples |
| `notes/2026-09-07-c1093-dynamic-query-admission.md` | partial: opening result/scope | Concrete fixed-family LRC admission; no independent optimality certificate in this adapter |
| `notes/2026-09-05-c1062-closeout-synthesis.md` | partial: scope and review coverage, sections 5–6 opening passages | Counterexample to automatic compilation benefit; do not repeat uncorrected state-ratio performance claims |
| `notes/2026-09-06-c1070-closeout-synthesis.md` | partial: opening, product-claim section | Recovery/leakage dual use and observation assumptions; comparative novelty assertions not independently verified here |
| `notes/2026-09-09-c1130-overnight-evolve.md` | partial: Current implementation and Accepted code/evidence | Source-only proposals, checked root reductions, learned-only reruns; symmetry is not exclusion evidence |
| private `analysis/interface-review/2026-09-10-adaptive-representation-plan.md` and `2026-09-10-adaptive-representation-performance.md` | partial: scope/acceptance and accepted-boundary opening | Same applicability check at setup/active admission; explicit restart; nonzero cold cost and miss cost |
| `notes/2026-09-11-c1130-parameterization-checkpoint.md` | partial: Current capability | Witness-preserving maps need not preserve full search coverage; supplied source versus discovered parameters |
| `notes/2026-09-12-c1162-leaf-lowering-square.md` | partial: Result and Discharged private family | Finite checker, supplied-lowering transition synthesis and distinguishing append event |
| `notes/2026-09-12-c1166-privacy-lowering-reflection.md` | partial: scope and Delivered | Physical-world semantics, append-trace preservation and finite readout minimality |
| `notes/2026-09-12-c1163-rule-contract.md` | partial: Result and ownership | Finite recursive contract, source identity and bounded ABI example |
| `notes/2026-09-13-c1172-lean-audit-gate.md`, `2026-09-13-c1173-support-certificate.md`, `2026-09-13-c1174-generic-carrier.md` | partial: verdict passages previously inspected in this conversation | Guarded proof boundary, support versus replay checking, admitted generic/Boolean results; no Lean build rerun |
| `notes/2026-09-13-c1176-contract-semantics.md` | partial: section inventory and dense-negative-control construction; completed scope from current handoff | Current rounds/invariance/law remediation supersedes queued status in earlier sources; evaluator selection still has real tradeoffs |
| `notes/2026-09-12-ergodis-rule-contract-programme.md` | full text earlier in this conversation; subsequent status reconciled against current handoff | Sequence, placement and external-workload gate; private correspondence omitted from proposed public prose |
| `notes/ergodis-architecture-context.md`, current Ergodis handoff | full text in this conversation | Routing and implementation-versus-target distinction; older maps can lag current task reports |

The synthesis also retains on-demand routes to C1084 and the C985 proposal/admission ADR.
Those routes are contextual references from C1091/the architecture map, not new full-text
reads or fresh validation of the capabilities they describe.

## External comparison register

September 13 engineering/campaign supplement: contributor `PERFORMANCE.md` (302 lines)
and `performance-playbook.md` (147 lines) were read in full. They establish internal
requirements, not implementation compliance or publishable performance results. Their
private-only status forbids copying them into public documentation. Campaign reports
`notes/2026-09-07-c1124-real-campaign-console.md` and
`notes/2026-09-07-c1126-campaign-information-architecture.md` were read partially (opening
result/user-direction sections); `notes/2026-09-10-c1130-stop-responsiveness.md` was read
partially (opening cause and implemented lifecycle repair). These support the framing of
interactive investigation and its overhead; no user-productivity study or performance
benchmark was run for this supplement.

Comparisons below identify established mechanisms. They do not claim that those systems
lack some Ergodis feature. The relation to the proposed Ergodis frame is the author's
inference, not the external authors' characterization of Ergodis.

| Source / access | Read depth and version | Established connection |
|---|---|---|
| Conjure, https://conjure.readthedocs.io/en/latest/introduction.html | partial: official Introduction, served as 2.6.0; bibliography entries not followed; accessed September 13 | Refine abstract problem classes into alternative concrete models and reuse them across instances. Representation search is established. |
| Russell, https://aima.eecs.berkeley.edu/~russell/research-bo.html | partial: official research overview, rational metareasoning/bounded-optimality narrative; linked papers not read | Choosing computations by decision value and learning metalevel control. The metalevel can itself be harder than the underlying decision. |
| Willsey et al., https://arxiv.org/abs/2004.03082 and POPL 2021 official paper page | abstract/metadata only: arXiv v3 metadata and abstract-level account consulted in this conversation; no PDF read | Equality saturation and domain-specific analyses provide a strong representation-search precedent. |
| Markl et al., https://research.ibm.com/publications/robust-query-processing-through-progressive-optimization | abstract/metadata only: official publication page consulted earlier in this conversation | Execution feedback can trigger plan reoptimization. |
| AutoML algorithm-design/configuration pages, https://www.automl.org/automated-algorithm-design/ and its algorithm-configuration page | partial: official programme/tool descriptions previously consulted; no underlying paper read | Algorithm selection, parameter configuration and dynamic configuration are established implementation lines. |
| Ball, https://www.microsoft.com/en-us/research/publication/formalizing-counterexample-driven-refinement-with-weakest-preconditions/ | abstract/metadata only: official report abstract previously consulted | SLAM implements counterexample-driven abstraction refinement; solve feedback can identify missing distinctions. |
| Ailon et al., https://arxiv.org/abs/0907.0884 | abstract/metadata only: arXiv abstract returned by earlier search; full text not read | Self-improvement with respect to an unknown input distribution is a direct theoretical connection. |
| Wolpert and Macready, https://research.ibm.com/publications/no-free-lunch-theorems-for-optimization | abstract/metadata only: official publication abstract previously consulted | Performance depends on alignment with the problem class under the NFL comparison framework. |
| Wolpert, https://arxiv.org/abs/2007.10928 | abstract/metadata only: abstract and submission/version metadata previously consulted | Nonuniform distributions and assumptions behind selection/generalization matter; this is not a speedup theorem for Evolve. |

These source pages were available. Full-text, forward-citation and implementation-level
priority searches were not attempted; no absence conclusion is licensed. C985 should first
state the exact prospective contribution, then audit its closest predecessors. This avoids
treating a broad survey of “meta-optimization” as evidence of novelty for a narrower claim.

## Manuscript-location and publication checks

The bounded search inspected C985's exact live row, its authoritative original outline,
targeted manuscript/path references, routed complete-ports sources, filenames matching
Ergodis/optimization under `papers/`, paper README matches, and TeX filename listings in
the core/private sibling repositories. No separate current optimization manuscript was
located in those searches. The core optimization introduction names the complete-ports
paper. The historical 37-page description must not be treated as evidence of a separate
current first-Ergodis manuscript.

A nonblocking location question was sent to Tavis. Pending a specific path, the framing
uses C985's outline as the starting point; applying it to an additional manuscript remains
an explicit source-location gap for C985. This does not prevent delivery of the framing,
drafts or proposed paper programme. No unavailable source is characterized as reviewed.

The publication check was local only: `git show-ref --heads public`, the latest public
commit, `EXPORTS.md`, the public README opening, and an exact tree lookup for the newer
rules/lowering paths. No remote was contacted or changed. The public snapshot does not
establish the availability of all private-main or private-package capabilities. The
proposed public prose discloses no private paths, task IDs, correspondence or benchmark
figures; promotion still requires an explicit artifact/visibility check.
