# C1091 — Core semantics after the September 4–5 brainstorms

**Date:** 2026-09-07. **Lane:** ergodis. **Disposition:** architecture review and implementation plan; no Rust/API migration in this task.

## Decision

Prioritize semantic contracts before freezing durable run payloads or adding more frontends. Preserve the working browser/native control foundation. Next, make three small, independently checked examples—QEC decoding, causal counterfactuals and privacy leakage—express their source, question, objective and evidence explicitly. Extract common mechanisms only where those examples demonstrate the same obligation.

Evolve is an autonomous system for discovering useful structure, representations, theorems and parameters. It may discover quotients, but quotient minimization is one strategy, not its definition. Its optimization target includes compilation, queries, updates, verification and memory. It may reasonably select direct solving, partial compilation or an unminimized representation.

The strongest architectural consequence of the brainstorm is **plural preservation contracts**. Different representations preserve different questions, under different contexts and quantifiers. A representation must carry the contract that licenses its use; a UI label or a successful sample evaluation cannot supply that authority.

## Historical sources and how to read them

- [Friday, September 4: commercial and Evolve brainstorm](2026-09-04-ergodis-commercial-evolve-brainstorm.md): verbatim user-supplied text, 44,278 characters.
- [Saturday, September 5: recovery, catalogs and semantic sensitivity](2026-09-05-ergodis-semantic-sensitivity-brainstorm.md): verbatim user-supplied text, 143,633 characters.

Both include original citations and are hashed against the supplied messages. They are historical source records, not current literature reviews. This task did not retrieve the referenced prototype ZIP, rerun its reported tests, recheck the manuscript proofs, establish novelty, validate market estimates or reproduce historical performance figures.

Friday reacted to an earlier implementation. Saturday progressively revises its own ambitious claims. The final red-team response is essential context, not an optional footnote. Current user instructions supersede the older commercialization suggestions: reusable Evolve mechanisms belong in core; selected domain heuristics, theorems and kernels may remain private, including separately packaged QEC IP.

### Reading map

| Source thread | Retain for architecture | Qualification |
|---|---|---|
| Equation confinement → operational recovery | Target semantics and support/resource observations must be explicit | Minimal support, minimum cardinality and coefficient confinement differ |
| Quotient-labelled sparse lifting | Preserve numerator/null spaces, quotient labels and lift maps | A useful common mathematical family, not a universal model for causal or scheduling inputs |
| Weighted pricing / support alternatives | Separate feasibility structure from valuation | Unit-cost minima do not admit arbitrary repricing |
| Reliability / logical decoding | Define physical sample space, equivalence and aggregation order | Counting derivations is not counting successful events; minimum weight is not logical maximum likelihood |
| Representative catalogs | Collective replacement can preserve an optimum without merging individual witnesses | Classical representative-family machinery; claimed new theorem package remains unaudited |
| Marked catalogs / semantic sensitivity | Exact signatures can admit arbitrary edits within a declared family | Signature construction and source-edit factorization must be established, not assumed |
| Decision covers / partial observation | Information structure and quantifier order belong in the query | Pointwise optimal response does not imply a common safe action or implementable policy |
| Symbolic / compositional compilation | Avoid materializing the global carrier | Width, frontier size, arithmetic and construction costs remain explicit |
| Commercial wedges | Embed into an existing workflow; keep source semantics and independent evidence | Product rankings conflict; no demand evidence in these exchanges resolves them |

## What I would keep, correct and defer

**Keep now:** source-level structure, explicit admitted query families, independently checkable evidence, query-directed compilation, bounded probes and exact fallback. These fit both current code and autonomous discovery.

**Correct now:** “coarsest quotient” is not a universal representation objective. Decision covers need not form an equivalence relation; representative catalogs preserve a lower envelope collectively. Approximate closeness also need not be transitive, so calling it an approximate equivalence does not establish a valid quotient or error bound.

“Runtime” is overloaded in Friday's text. The existing `ergodis-runtime` is the campaign/session orchestration layer. A small compiled-plan **executor** is a mathematical execution component below it. Do not rename the existing crate to fit a historical proposal or put all execution semantics into the control service. A standalone executor may omit search; an interactive Evolve service can retain an off-path solver fallback. These are separate deployment profiles.

**Defer as theorem targets:** general policy compilation, robust/chance-constrained synthesis, arbitrary QLDPC family edits, generic proof transformers, unrestricted parametric compilation and automatic separator discovery. Each needs a concrete admitted class and a measured construction algorithm. Finite-state timing claims require bounded time or explicit registers. None follows from a small quotient alone.

**Defer as product decisions:** choosing explanation SDK versus code-analysis workbench versus infrastructure recovery as the company wedge. Keep an offline analysis/demo workflow as the near-term engineering vehicle because it can expose explicit evidence and private modules. Seek customer workload evidence separately. Do not encode a market ranking into core crate dependencies.

## Current code: reusable foundations and semantic gaps

This review builds on the preceding read-only domain audits and current core inspection. Core reference revision: `ea1f563` (browser demo); no implementation changes here.

| Existing component | What it actually supplies | Gap relevant to this plan |
|---|---|---|
| `src/reduction_language.rs` | GF(2) labels, blocks, target and minimum sum of local costs; cold validation and compilation | Generic names hide a specialized problem family; objective is implicit |
| `src/matrix.rs` | Field-aware, dimensioned matrices and validated constructors | Dimensions do not identify mathematical spaces, coordinate roles or basis transports |
| `src/observational.rs` | Typed finite deterministic presentations, declared contexts, exact contextual minimization and certificates | Do not require implicit domains to enumerate the concrete carrier merely to fit this API |
| `src/ordered_resource.rs` | Finite ordered monoids, validated laws, Pareto fronts and frozen query plans | Resource accumulation is not automatically probability/event aggregation or policy semantics |
| `src/query_design.rs` | Finite binary-query design with certificate replay | A kernel for an admitted problem class, not all multi-outcome or sequential decision design |
| `crates/verify` | Independent bounded GF(2) verification and opaque checked admission | New claim families require independent checking obligations, not a universal `verified` flag |
| `crates/runtime` | Campaign lifecycle and portable synchronous session service | Owns jobs/history/control, not mathematical query truth or solver state equivalence |

Concrete private evidence prevents an overly narrow matrix-shaped abstraction:

- QEC: `src/tiger_blossom.rs` takes a compiled graph/profile and packed syndrome, returns weight, logical observables and overflow. `predecoder_pipeline.rs` and `margin_certificate.rs` distinguish compile-time admission/audit from a per-shot result. C1069 establishes that the predecoder has no per-shot certificate and that its margin evidence has a declared scope. `window_exactness.rs` distinguishes full-history optimization from a window/seam-restricted objective. See [C1069](2026-09-05-c1069-predecoder-certificate-read.md).
- Causal: `causal_counterfactual.rs` separates natural-world evidence, intervention and outcome. A quotient can fail to express the question; this is not a false counterfactual. `causal_design.rs` distinguishes full identification from decision-sufficient stopping, with multi-outcome experiments. These are supplied finite SCMs, not discovery from observational data. See [C1062](2026-09-05-c1062-closeout-synthesis.md).
- Privacy: `leakage.rs`, `leakage_design.rs`, `vector_leakage.rs` and `transcript_leakage.rs` include nested spaces, target subspaces, acquisitions, vector objectives and temporal masks. Target rows and selected coordinates may combine into one subspace; do not replace that with an exclusive target enum. Coordinate costs can count repeated acquisitions rather than set union. Shared masks invalidate an assumed fresh-mask interpretation. See [C1070](2026-09-06-c1070-closeout-synthesis.md).

Terra's bounded follow-up confirmed `observational::CompiledObservation` and `verify_compilation`, the ordered-resource response dictionary and frozen objective/query separation, and the 64-hypothesis binary identification limit in `query_design`. A response dictionary deduplicating equal Pareto fronts is **not** a failure-complete representative family. Likewise, binary identification machinery is reusable for parts of experiment design but does not already implement the overlapping optimal-action decision covers proposed on Saturday. Do not conflate those existing names with the new mathematical contracts.

The repeated gap is not absence of all abstractions. Good abstractions exist locally, but their semantic assumptions do not consistently cross family, compiler, verifier and client boundaries.

## Proposed ubiquitous language

These are proposed additions/refinements to core `docs/glossary.md`, not a competing permanent glossary. Promote after the first contract examples settle naming.

| Term | Meaning and distinction |
|---|---|
| Model | Immutable mathematical structure and its declared interpretation; a family-specific validated object |
| Space | Named carrier with scalar domain, dimension/basis or finite vocabulary and coordinate interpretation |
| Resource | Physical entity or accounting unit; identity and sharing semantics are explicit |
| Query | A question about a model, with target, admissible context and requested answer contract |
| Target | What is to be reconstructed, satisfied, decided or observed; not the preferred cost |
| Objective | How admissible candidates are ordered, including units, direction and composition rules |
| Observation contract | Questions and contexts a representation promises to preserve |
| Update contract | Admitted changes and the obligations for transporting or revalidating a representation |
| Representation | Retained mathematical information: quotient, catalog, circuit, frontier, relaxation or other form |
| Compiled plan | Representation plus executable operations, admission/validity conditions and lifting/checking routes |
| Executor | Applies a compiled plan; distinct from the campaign/session runtime |
| Witness | Concrete object supporting a stated claim, such as a reconstruction or counterexample |
| Certificate | Evidence consumed by a checker to establish a specified claim under explicit assumptions |
| Claim | Proposition with model/query/scope identity; feasible, optimal, bounded, complete, etc. are distinct |
| Coverage | Portion of the admitted domain actually explored or certified; never inferred from provenance |
| Decision | Chosen action under a stated query and information state |
| Policy | Mapping from admissible observation histories to actions; respects when information becomes available |
| Run record | Durable account of an execution; not the process, model, plan or certificate itself |

Use **provenance** for origin and derivation. Keep source-model provenance, theorem provenance, parameter provenance, search mode, verification, coverage and disclosure as separate dimensions. A privately discovered theorem may be proved; an openly published heuristic remains heuristic. Heuristic search may find a fully checkable feasible witness. Proof-generating mode does not make an exhausted budget a completeness proof.

## Core types before UI shapes

### 1. Validated mathematical signatures

Introduce only the small shared cold vocabulary demonstrated by examples: scalar domain, named space, basis/coordinate map, resource identity and units. A matrix from space A to B differs from an equally sized matrix from C to D. Equal dimensions or matching serialized byte counts cannot authorize composition or cache reuse.

Domain constructors validate relations: nested spaces, valid quotient maps, symplectic pairing, causal acyclicity, intervention permissions and privacy mask binding. Family-specific invariants remain in family-specific types; do not build one enormous `Model` trait or optional-field JSON object.

Source identities must bind semantics and transports, not just matrices. Coordinate reordering may admit a checked transport; it must not silently reuse an old claim. Cryptographic content identity detects change but does not prove equivalence.

### 2. Typed questions, not a universal target tensor

Keep native family query types, sharing explicit descriptions of their roles and obligations:

| Family | Model input | Target / question | Objective and result |
|---|---|---|---|
| Recovery | Encoding/interface maps and physical resources | Reconstruct a functional or subspace with prescribed normalization | Minimum support, weighted load, bandwidth or full frontier; coefficient lift |
| QEC shot | Validated decoding model/profile | Explain syndrome and return a logical decision | Minimum weight in declared model; logical likelihood is a different query |
| QEC design | Code/nested spaces and construction metadata | Meet a distance threshold or expose a weak logical direction | Bound/witness/complete threshold verdict; not shot decoding |
| Causal counterfactual | Supplied SCM and exogenous measure | Outcome under action, conditional on natural evidence | Exact fraction, bound or unsupported query; zero evidence mass must be explicit |
| Privacy | Encoding/transcript and mask semantics | Exposed subspace or minimum coalition attaining target | Leakage rank/profile, minimum acquisition cost or vector design frontier |
| Design synthesis | Candidate design space and admissible scenarios | Find a design whose responses meet requirements | Outer design objective plus inner quantified obligations |

Query budgets and stopping policies belong to execution requests alongside the mathematical query. Changing a time budget need not invalidate the mathematical identity; changing radius, admitted contexts or the meaning of a threshold does. Record both identities rather than hashing an undifferentiated request blob as the model.

### 3. Objective algebra and answer semantics

Reuse `ordered_resource` for admitted accumulation/order/Pareto mechanisms. Keep separate:

1. accumulation along a realization;
2. aggregation over alternative realizations;
3. the underlying objects or physical events counted;
4. quantification over uncertainty and information histories.

Minimum, Pareto, existential availability, counting witnesses, counting distinct physical states and summing logical-class probability are different semantics. A `Probability` value constrained to [0,1] is useful validation but cannot repair an incorrect event model. A union bound capped at one remains a bound, not exact reliability. A readout needs an admitted preservation argument, not just the right output type or a purported homomorphism.

Preserve physical ownership at composition: set support uses union; additive acquisitions can double-charge shared coordinates; shared transmissions require subspace alignment. Do not infer any of these from array shape.

### 4. Representation contracts

| Representation | Preservation obligation | Required boundary |
|---|---|---|
| Observational quotient | Same declared observations under admitted contexts; compositional/transition compatibility | Exact carrier/context grammar and witness interpretation |
| Representative catalog | Same optimum over retained family for admitted queries | Source family coverage, signatures, baseline valuation, radius/adversity and actual witness lifts |
| Pareto/resource envelope | All relevant nondominated alternatives for admitted contexts | Resource correlations, order and future valuations |
| Event circuit | Correct existential event or measure aggregation | Physical atoms, overlap/decomposition and distribution assumptions |
| Decision cover/policy | Admissible action under unresolved information | Common-action or sequential nonanticipation obligations, not pointwise optimum alone |
| Relaxation / approximation | One-sided bounds or quantified error on requested claims | Direction, domain, feasibility lifting and error composition |

This is a design vocabulary, not a closed public enum of all future algorithms. Admission operations should produce opaque validated handles for the particular representation/query pair. Unchecked module manifests advertise capabilities; they do not mint those handles.

Witness equality deserves care: preserving one canonical witness, preserving the feasible witness set and preserving the ability to lift some valid optimum are different contracts. Requiring exact witness bytes everywhere would unnecessarily prevent useful reductions and tie semantics to solver tie-breaking.

### 5. Updates and semantic sensitivity

The Saturday signature theorem is a strong pilot candidate precisely because its obligations are concrete. A fixed source family, fixed baseline valuation and declared signature partition admit certain later cost/feasibility changes. The pilot must establish that an edit factors through that signature and that source coverage remains valid.

Changing a parity check can create or remove candidates and alter logical triviality. It is not justified by calling the edit a marked port. Require a common candidate universe plus a proved edit interpretation, or a checked transport/coverage argument for the new family. Distinguish update admission from empirical edit-locality prediction.

Cache validity should identify assumptions, source/query family, measure, resource identities, checker/schema versions and dependency sets. A sufficient admission test failing means “no guarantee from this contract”; it does not mean the optimum changed or the representation is definitely wrong.

### 6. Quantifiers and information order

The query must distinguish pointwise recourse `for every context, choose an action`, a common safe action `choose an action valid for every consistent context`, and a sequential policy that can use only observations already obtained. Design synthesis adds an outer existential design choice before the scenario quantifier.

Do not attempt a universal quantified-query interpreter in the first slice. Use explicit family constructors and a small semantic test corpus. The singleton-helper counterexample and the three-world overlapping-optima example from Saturday are particularly useful rejection fixtures.

## Evolve discovery and evidence

The autonomous loop should propose a representation and its claimed preservation/update contract, search for useful parameters or structure, challenge the contract, and admit it only at the appropriate evidence level. Candidates include decompositions, symmetry actions, signatures, catalogs, relaxations, rewrite rules and execution strategies.

A counterexample is structured output: distinguishing context, failed lift, violated assumption, uncovered source case or incompatible information state. Those differ from malformed input and implementation faults. Retain them as Evolve learning material and durable run artifacts.

Parameter evolution must distinguish performance-only tuning from semantic parameters such as radius, adversity budget, admitted observations and approximation tolerance. Changing the latter creates a new contract even if the executable kernel is unchanged.

Use an explicit objective over end-to-end work. Compilation estimates are predictions with calibration evidence; they are not correctness evidence. Budgeted probing must account for its own cost and support abandoning a losing compilation. Exact fallback remains bounded and can return unsupported or budget exhausted; it is not a promise that every admitted problem can be solved quickly.

Certificates compose only through checked rules. A proof transformer must establish the new claim's hypotheses and dependency validity, not merely mutate an old certificate. Independent checking should cover source-to-representation preservation and omitted-space coverage when claiming optimality, in addition to checking the final witness.

## Compilation units and deployment boundaries

Keep the implementation modular without a crate per noun:

- Core semantic modules: cold validated family contracts, reusable algebra/context machinery, compilers and specialized executors. Start with modules and narrow interfaces; split crates only when dependency or incremental-build evidence justifies it.
- Independent verifier crate: proof-format readers and small checking kernels. It must not depend on the optimizer's decisions or runtime. Shared primitive arithmetic can be evaluated separately without sharing the search algorithm as its own checker.
- Runtime crate: campaigns, scheduling, budgets, session/control operations and orchestration. Durable storage adapters and frontends remain outside kernels.
- Native/WASM adapters: serialization, browser Worker messaging, Unix or portable transports and host resources. A browser's feature limits do not redefine mathematical semantics.
- Domain modules: public mechanisms plus private admission logic, candidate generators, kernels or theorem implementations as appropriate. QEC can remain a separately releasable package with its own fixtures and provenance.

Shared-library boundaries should operate on compiled buffers/batches through a versioned ABI, not on per-state trait-object calls or Rust ABI layouts. Dynamic loading and source-to-IR compilation are alternative packaging routes with the same semantic contract and evidence obligations. Native and WASM need distinct load adapters. A browser cannot directly load a native `.so`.

A shipped opaque module can keep implementation details private while emitting public checkable claims, where the certificate language permits that separation. If checking requires a private theorem or hidden assumptions, declare the narrower trust boundary. Do not promise black-box secrecy from obfuscation or confuse a signed package with a correctness certificate. Hosted execution is another delivery option, not the only privacy boundary.

The Friday suggestion to withhold generic incremental execution conflicts with the user's current decision: the reusable mechanism belongs in core. Industry knowledge and implementations can be held back. This is an engineering dependency plan, not a legal or patent assessment.

## Native64 performance and build discipline

Semantic richness belongs at cold validation/compilation boundaries. Lower to compact IDs, flat pools and statically specialized kernels. No new semantic strings, dynamic containers, serialization, host calls or per-state virtual dispatch in solve records. Presize workspaces and retain zero-allocation tests. Domain plugins are selected outside hot loops.

Native64 must retain its current specialization and exact size/alignment assertions; wasm32 receives its own explicit assertions. Serialization and module ABI schemas must not be dumps of native Rust records. Validate range narrowing at input boundaries. Avoid exporting large generic implementation surfaces that multiply monomorphization and compilation cost across clients.

For a cold contract slice: test semantic admission/rejection, existing differential cases and feature-isolated dependencies. For any affected hot path: retain before/after binaries and interleaved single-/parallel A/B counters, work counts, allocation checks and layout assertions. Compiler and checker costs count in end-to-end measurements. A descriptor feature is not an excuse to broaden every build's dependency closure.

## Ordered implementation plan

### A. Contract examples before framework — next highest EV

Create a small private conformance corpus using the existing QEC, causal and privacy implementations. Express validated model signature, typed query, target, objective/answer semantics and evidence scope. Initially add adapters around current kernels; do not rewrite them. Add one bounded recovery example to bridge the existing admission pilot.

Acceptance: same results as independent reference paths, explicit rejection of incompatible spaces/queries, no stronger evidence claim than the source supports, and no kernel layout or hot-loop change. Include QEC overflow, causal unsupported quotient query and zero conditioning mass, and privacy shared-mask/target-subspace/cost-unit distinctions. Draft executable denotational semantics for this small contract surface.

### B. Extract the smallest shared core boundary

Promote only common validated identities, transports, claim/admission patterns and reusable algebra from A. Keep family constructors explicit. Update the single public glossary and documentation with source→query→plan→answer examples. Dependency tests keep solver, verifier, runtime and private modules one-way. Measure build impact before creating another foundational crate.

Acceptance: at least two meaningfully different families use each extracted abstraction without erasing their semantics. UI introspection reads the validated cold contract; it cannot alter or authorize it.

### C. One representative-catalog pilot

Implement an admitted finite recovery family with fixed baseline weights, explicit supports and source coverage. Start with bounded failure completeness and the singleton/discount negative controls. A separate checker validates the omission argument relative to the admitted family. Add marked signatures only after that gate.

Measure construction, retained size, verification, query/update and memory against a warm direct baseline. Do not start with exterior algebra if the bounded family can first test the contract through a simpler exhaustive reference. The production algorithm follows measured crossover, not theorem aesthetics.

Acceptance: exact admitted-query agreement and rejection/fallback outside the contract. No claim that an incomplete supplied family covers the source. Sparse-dual and reliability readouts are follow-ons with their own obligations, not automatic capabilities of the first catalog.

### D. Durable records and module manifests

Resume the C1084 persistence plan using references to validated semantic objects and versioned family payloads. Keep execution metadata/notes separate from mathematical identities. Record claims, evidence, coverage, dependencies, module identities and explicit fork/update transports. Store unsupported and budget-exhausted outcomes honestly.

The current browser checkpoint demo remains useful but is not the final universal artifact format. Define migrations after A/B, rather than solidifying the present GF(2)-only document shape as the general model schema.

### E. Query-directed autonomous compilation

Add bounded proposal/probe/challenge/admission selection across direct solving, quotients and catalogs. Preserve search-mode/provenance separation. Bring in separator discovery, symbolic events, sensitivity regions and profile specialization one admitted family at a time.

Measure time to useful bound, total amortized cost and bad-tail selection regret. Keep independent verification and native/WASM admission conformance in the loop. Broader policy synthesis and quantitative approximation remain separate research gates.

## Rejection fixtures that should outlive every implementation

1. Equal dimensions, different spaces/bases: reject untransported composition or reuse.
2. Same unit-cost optimum, different supports: reject arbitrary repricing or reliability readout without the richer contract.
3. Overlapping repairs `{1,2}` and `{2,3}` at independent survival 1/2: exact availability is 3/8, not 1/2.
4. A single-failure-complete catalog omits the only action safe under unresolved alternative failures: reject the policy guarantee.
5. Three optimal-action sets `{a,b}`, `{b,c}`, `{a,c}`: pairwise compatibility does not justify merging all worlds.
6. Same syndrome, different logical-class probability semantics: a minimum-weight witness cannot certify logical ML.
7. Reused privacy mask presented as fresh: reject the stronger secrecy interpretation.
8. Catalog update outside its signature/coverage contract: no inferred exactness; choose fallback or return no guarantee.
9. Feasible witness with unverified exclusion of cheaper candidates: report upper bound, not independently certified optimum.
10. Pairwise epsilon closeness: do not assume transitivity or a global regret bound after repeated merges.

These are proposed acceptance tests, not claims that they were implemented or run in C1091.

## Review outcome and open questions

The cheap extension exposed by this review is to make **failure to admit a query** a structured, reusable counterexample path for Evolve, clients and persistent records. That unifies several existing “unsupported” cases without putting control concerns into the mathematics.

The unresolved issues are concrete: the smallest common signature/claim vocabulary that survives the three domain examples; efficient signature construction without raw-state materialization; independent source-coverage certificates for implicit families; and total cost of retaining stronger update/readout contracts. None is settled by the historical binomial catalog bound.

No incidental discovery-track entry was required: all findings were sought as part of this review. This is not a theorem-development task; no novelty or new proof verdict is being issued.

Validation for this documentation slice: exact archived-message hash checks, local relative-link checks and scoped whitespace checks. No code, dependency, format, performance or mathematical capability is claimed to have changed.

## Accepted motivation — query and design specialization (September 7 follow-up)

A single validated model should admit multiple compiled plans specialized jointly for the query,
representation and evidence requested. Shared input does not imply identical compilation. A
threshold query may need only a bound and a counterexample; an exact optimum needs exclusion
coverage; weighted updates, reliability and partial-information decisions can require successively
different retained information. Reuse validated intermediate structure when its contract permits
it, and measure the additional cost of stronger contracts explicitly.

Evolve's search domain also includes **questions and designs**, not merely algorithms answering a
fixed question. It can propose targets, observations/experiments, guarantee levels, scenario classes,
physical designs and their compiled plans. Give that exploration its own evaluation contract:
allowed changes, utility or operational value, hard constraints, cost of information/implementation,
and required evidence. Compare candidates under declared comparable metrics; a cheaper answer to
a different question is not automatically an improvement.

Separate three activities: strategy search for an unchanged query; question design (what to ask or
observe); and source-design synthesis (what system should exist). Track a candidate as design +
query contract + compiled plan + evidence, with lineage and dependencies. This describes the
exploration semantics; it does not require a universal tuple-shaped public API. Include two queries
against one model in the first executable corpus, alongside a changed-design reuse rejection.
