# C1180–C1181 — categorical structure folding and Evolve continuation

**Lane**: `ergodis`
**Date**: 2026-09-13
**Visibility**: PRIVATE research/work planning; do not export.
**Status**: C1180 QUEUED; C1181 GATED on C1180 and Tavis's architecture choice.

## User objective

Investigate lifting domain-specific problems into a categorical representation, folding
and optimizing structure there, then lowering back to an executable solver or a representation
in which Evolve can continue. Evolve is core. Static specialization is optional, not the end
of every campaign. “Optimal” must name a realization search space, workload, cost objective
and evidence; otherwise report best found or a Pareto frontier.

## Private inspiration and scope clarification

Tavis names **Vincent Abbott's work** and **Cats4AI** as related inspirations alongside
Macready's broader categorical lens. Preserve all three in the investigation's provenance;
do not frame the programme as arising from the correspondence alone. C1180 should identify
the relevant Cats4AI material and its authors/constructions before attributing specific
technical results. The name here records user direction, not a reviewed source or a claim
that Cats4AI denotes one particular implementation. Reuse C1150/C1151's recorded Abbott–Zardini
reading as a starting point, with source-level verification for any adopted mechanism.

Tavis supplied William Macready's September 12, 2026, 1:06 PM email in this conversation.
The category-theory lens is partially inspired by its description of a foundation broader
than neural circuits, including symmetries, generalized tensors, predicate logic and tensor
networks for quantum-system modeling. This is not merely an interest in tensor-logic syntax
or operation fusion. The study should ask whether, and under which distinct laws, that breadth
can support Ergodis's lift/fold/lower search across domain presentations.

Treat this as user-supplied private correspondence and a research motivation, not inspected
implementation, independently verified capability or permission to disclose the email.
No full email, address or third-party private design is needed in public-facing material.
The quoted tweet about composing fused operations and mapping to machine instructions is
motivation for the realization/lowering axis; this card does not independently verify it.
The new study must distinguish established published constructions from the author's private
description and from our own proposed generalization.

## Queue coverage audit

Checked against exact live/archive rows on September 13, not historical study rankings:

| Work | State and contribution | What remains outside its scope |
|---|---|---|
| C1155 | Complete bounded private weighted normalization/lumping prototype; reuses and audits existing certified coarsest observational compilation | General cross-domain categorical lift/fold/lower and Evolve continuation |
| C1162 | Complete finite lowering-square check and counterexample-guided H synthesis for supplied F and G | Discovering arbitrary source representations or proving source-language semantics from a finite table |
| C1157 | Queued equality-saturation spike over plan terms, cost extraction and preservation analysis; C1152/C1154 predecessors closed | General semantic lifting, domain readout and continuing Evolve after lowering |
| C1156 | Queued learned proposal ordering, operator selection and sampling/screen discipline | A generalized representation search space and its transformation laws |
| C1113 | Gated reusable discovery/refinement transfer to one existing domain workload | A multi-domain categorical mechanism; its existing discovery gate remains unchanged |
| C1046 | Queued composition of sealed features on planted benchmarks | Composition of distinct representation-changing transformations |
| C1130 | In-progress checked family-specific representation admission and native/WASM integration | Universal state conversion or complete lift/fold/lower lifecycle |

Gap: no queued item owned the complete semantic lift, structural optimization, checked
lowering and resumed-discovery loop. C1180 owns its investigation; C1181 owns a gated pilot.
Do not duplicate the existing quotient compiler. C1155 corrected C1151's documentation-based
claim that quotient construction was missing. C1152 likewise corrected several study
assumptions; consult implementation reports before adopting a proposed abstraction.

## C1180 — capability-first categorical generalization investigation

Deliver a bounded literature-and-implementation study and decision memo, not a new universal
IR or backend by default. Reuse the C1150/C1151 source registers and literature cache; follow
literature-audit conventions for read-depth/provenance and any novelty-dependent claim.
Inspect current Ergodis code under its repository guides before stating capability gaps.
No new proof, Lean execution or Rust design without the applicable routed instructions.

Investigate these candidate tools as hypotheses, not a shopping list to implement:

1. Presented monoidal/Cartesian categories, string diagrams and algebraic/Lawvere theories
   for typed composition, sharing and equations; separate semantic denotation from physical
   realization. Determine which operations actually require copying, discarding or feedback.
   Explicitly compare symmetry actions, generalized tensor structures, predicate logic and
   quantum tensor-network presentations. Do not silently give quantum/linear objects the
   unrestricted copying or deletion available in Cartesian logic, or conflate Boolean
   existence, min-plus cost and amplitude contraction. These are candidate semantic regimes
   to investigate, not claims that Ergodis executes them all today.
2. Functorial interpretations and semantics-preserving translations; test whether one common
   representation is useful or a family of related representations with checked translations
   is the smaller sufficient design. Do not assume lifting is invertible or fully faithful.
3. Coalgebraic behavioral quotients and partition refinement for observation/transition
   sufficiency; algebraic folds, recursion schemes and fusion for eliminating intermediates.
   Establish which laws permit their composition and where recursion changes obligations.
4. Equational/e-graph or diagram rewriting with preservation analyses and cost extraction,
   coordinated with C1157. Separate equality, query-relative equivalence, directed refinement
   and sound relaxation: they cannot all be merged as equal terms.
5. Adjunction/Galois-connection or related abstraction machinery for safe bounds and refinement;
   symmetry/orbit reduction for exact coverage. Identify witnesses/counterexamples and the
   independent check required for each direction, rather than relying on categorical names.
6. Cost-aware/enriched interpretations and composable evidence/negative information, only
   where they yield implementable laws. Test nonadditive effects such as sharing, memory,
   locality, parallelism, admission and repeated-query amortization against actual solves.

For each shortlisted approach specify source/target objects, maps, laws, admissible queries,
observables, objectives, composition/update vocabulary, witness recovery, exclusion coverage,
and what is lost. Require both a positive finite example and a rejection/counterexample.
Separate a proof of exact answers from a proof of optimal realization selection.

The return path is a first-class deliverable: can a transformed object become a native typed
plan, a WASM plan, a static specialized kernel, or a new Evolve search representation? Define
how source identity, candidate lineage, learned artifacts and proof scope survive or are
invalidated. Distinguish readout/witness lifting from an inverse representation map; distinguish
restart from continuation with converted live state. No silent reuse of incompatible state.

Acceptance: ranked shortlist with explicit reasons to reject alternatives; capability/status
matrix against current code; two candidate domains sharing an actual transformation law;
worked lift/fold/lower contract with a counterexample; proposed pilot and cost/coverage gates;
recommendation for C985/C1178 framing. “A universal layer is not justified” is an acceptable
finding. Architecture selection remains Tavis's decision. No dependency/backend adoption,
public claims or disclosure of Macready correspondence is authorized by this investigation.

## Equivalent-representation recognition — explicit C1180 workstream

User direction: investigate recognition more generally, not only transformations constructed
by Ergodis itself. Given independently presented models or plans, can Ergodis discover and
check a correspondence that permits deduplication, transfer or reuse? This extends C1180;
it does not allocate another generic engine or claim general equivalence is decidable.

Separate representation isomorphism, behavioral/query-relative equivalence, equivalent
realizations with different cost, and directed refinement/relaxation. Matching one answer,
dimensions or a digest is not semantic equivalence. Specify the admitted finite domain,
observable/action vocabulary, input promises and stop condition. Return checked equivalence,
a checked distinguishing obstruction where available, or unknown/unsupported/budget-exhausted;
a failed heuristic recognition attempt is not a proof of inequivalence.

Inventory existing recognizers before proposing new ones. Compare canonicalization with
pairwise witness search; exact normalization with fingerprints used only as candidate screens;
and family-specific coordinate maps, graph/rule correspondences and behavioral quotients.
Investigate what categorical structure makes each correspondence composable and which laws
are actually checked. Include independently presented equivalent inputs, near-equivalent
inputs that change a query or cost, and unsupported cases.

For every intended reuse state the extra obligations: source constraints and feasible sets,
objective values, queries/observables, transition/update behavior, witness coordinates,
optimality/exclusion scope and evidence identity. Distinguish transporting a plan, learned
artifact, answer or proof from transporting active execution state. Record the explicit map
and inverse or directed lift required; do not reuse an old source-bound certificate merely
because an isomorphism was found. Investigate reuse through a checked transport certificate
versus re-admission/reproof. Representation equivalence need not preserve physical runtime.

### AME frame recognition candidate, not an adopted domain

C1139 (`ame-lu`, complete) supplies a concrete bounded candidate: common two-dimensional
prime-field frames satisfying `A Q_j = Q'_j A` and `det(A)=1`. Its report
`2026-09-10-c1139-ame-lu-fast-recognition.md` records verified determinants/propagated frames,
deterministic decision and Las Vegas witness construction. The AME reduction requires its
promises; prime-field recognition is not an extension-field or arbitrary-dimensional solver.
The algorithm exists in AME-lane software, not as an integrated Ergodis module, and its report
does not establish an Ergodis end-to-end speedup.

Retain this in C1180's family inventory. **Integration gate:** first identify one real Ergodis
workload with repeated applicable frame-equivalence checks and an actual reuse opportunity.
Then specify all semantic transport obligations above and a matched comparison including
recognition, verification, transport/re-admission and subsequent solve cost, against no reuse
and the best existing recognition path. Include misses and break-even reuse counts. If no
workload qualifies, retain the candidate with an explicit negative disposition; no core
machinery or standalone AME module is required. Any AME implementation work retains its lane
ownership; an Ergodis adapter requires a separately scoped decision under C1181's gate.

Acceptance supplement for C1180: a recognition capability/status matrix, one fully worked
checked correspondence plus a semantic-reuse counterexample, and a ranked workload shortlist
with a reasoned AME inclusion or exclusion. The prior Terra status audit found C1111–C1113
related generic admission/transfer work but no specific AME reuse or repeated-frame timing
allocation. This workstream now owns investigating that gap, not a promised implementation.

## C1181 — gated cross-domain round-trip and resumed-Evolve pilot

Start only after C1180's decision memo and Tavis's approval of the minimal architecture and
domain pair. Reuse C1157 if its implementation satisfies the needed rewrite contract; do not
make completion of unrelated proposal-scoring work a prerequisite.

Include recognition of independently presented equivalent representations if C1180 finds
a useful workload, with checked semantic transport and reuse accounting as specified above.
The AME candidate is optional and remains behind its real-workload gate; do not force it into
the domain pair just because a recognizer already exists.

In a private bounded prototype, lift two materially different domain presentations into the
selected representation(s), apply a shared structural mechanism, and lower into existing typed
execution. On at least one family compare two distinct transformations (for example quotienting
and fusion), their alternatives and any lawfully composed sequence. Let Evolve propose/select
realizations and demonstrate a subsequent discovery step after lowering, with explicit retained
knowledge and source-bound checking. A no-gain or non-generalization result is valid evidence.

Gate on independent original-domain answers and witness checks, preserved-query rejection
tests, evidence/coverage scope, and matched direct/hand-specialized/no-discovery controls.
Measure cold and amortized total cost including lift, discovery, validation, lowering, solve,
readout, memory and failed proposals; report losses. Retain proof/realization optimality as
separate labels. Distinguish selected existing kernels, compiled data plans and generated code.
Apply the native performance contract and native/WASM conformance at exposed boundaries;
never accept native regression merely to obtain a generic representation. Static reification
is optional and requires its own evidence if attempted.

## Resume sources

- `2026-09-13-c1178-ergodis-framing.md`, representation and structure-folding sections.
- `2026-09-12-c1150-category-theory-for-ergodis.md` and C1151 capability pass/source dossiers.
- `2026-09-13-c1155-weighted-normalization.md`, C1152 certificate spike and C1154 intervals.
- `2026-09-12-c1162-leaf-lowering-square.md`, current rule-contract programme results.
- C1091/C1092 semantic/query contracts and C1130's current representation-admission reports.

This card records queue review and future gates, not completion of the investigation or pilot.
