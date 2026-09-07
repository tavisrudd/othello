# C1079 — ergodis-evolve review and synthesis plan

**Lane**: `ergodis`
**Status**: IN PROGRESS; Terra evidence collection complete; synthesis plan remains open.
Evidence map: `notes/2026-09-06-c1079-ergodis-evolve-review.md`.

## Authoritative product intent

Build a powerful autonomous system that discovers structure in a large search/solve space,
identifies applicable theorems and their parameters, and selects effective quotients/reductions
of that space. A Unix-socket control interface permits steering; autonomy is the ultimate goal.
AlphaEvolve, CEGAR, and related systems are inspirations, not a prescription to copy one design.
This explicit user direction takes precedence over conflicting inherited descriptions of evolve.
The socket is a control surface for the autonomous system, not its defining limitation.

## Review scope

Bring together the version in the Ergodis core (`~/src/ergodis`), the private implementation and
experiments (`~/src/ergodis-private`, largely C1016), and spikes extending either. Locate the
relevant spikes through the owning checkout guides and narrow source/document references;
read each checkout’s `AGENTS.md` before reviewing it. Preserve ongoing task ownership.
Recover existing repo-local notes and previous research reports, especially C985, before
proposing new mechanisms or terminology. Tavis explicitly requested Terra sub-agents for this
evidence collection.

Inventory implemented capabilities, experimental capabilities, stated intentions, and measured
results separately, with exact source/revision provenance. Trace conflicting descriptions to
their evidence and judge them against the authoritative intent above; do not infer correctness
from which model authored a document. Identify stale or contradictory guidance and propose
specific corrections. Review correctness, exactness/certificate boundaries, integration risks,
and meaningful test/evidence gaps as inputs to synthesis.

## Required deliverables

1. A map of core, private/C1016, and spike capabilities: what each contributes, overlaps,
   contradictions, missing pieces, and what can be retained or combined.
2. A coherent proposed architecture for autonomous structure discovery, theorem/parameter
   selection, quotient construction, validation/refutation, evaluation, and continued search.
   Explain how feedback and reusable discoveries improve subsequent attempts. Assess the
   relevance of AlphaEvolve, CEGAR, and related designs using primary sources when researched.
3. A clear relationship between autonomous operation and Unix-socket steering: inspect the
   existing protocol, then specify necessary control, observation, and persistence behavior.
4. Explicit evidence boundaries: distinguish conjectured/evolved candidates from established
   exact reductions; explain how candidates earn admission and how counterexamples refine
   them. Preserve C1016’s rule that heuristic predicates do not grant negative coverage.
5. Define what “best” and “optimally quotient” mean operationally: objective, compilation and
   discovery cost, solve/search savings, resource budgets, and any tradeoffs. Separate empirical
   selection from any mathematically proved optimality guarantee; do not silently promise the
   latter or impose an unapproved single metric.
6. A recommended staged convergence plan with concrete retain/adapt/retire decisions,
   dependencies, acceptance gates, representative workloads and controls, and the highest-value
   first implementation step. Include severity-ranked review findings with file/line evidence
   and targeted reproduction checks where applicable.

## Search mode, provenance, and validation are distinct

Explicit user clarification: distinguish the search’s mode (proof-generating or heuristic) from
where its theorems and parameters came from as evolve generates and evolves them. The synthesis
must define these dimensions separately in its proposed data model, runtime policy, artifacts,
and Unix-socket observations/control:

- **Search mode** specifies the run’s obligations and permissible conclusions. Proof-generating
  search must discharge the obligations needed for its claimed reductions and coverage. Heuristic
  search may explore with unvalidated candidates but cannot turn their pruning into proved
  negative coverage. State what mode changes mean for accumulated results and coverage.
- **Provenance** records origin and derivation for theorem candidates and parameter candidates
  individually: imported or human-supplied, generated, evolved, or composed; exact parent
  versions, generation/mutation steps, and relevant run/input/configuration identifiers. Preserve
  lineage through validation and reuse rather than replacing origin with a trust label.
- **Validation status and scope** record what has actually been established, with supporting
  evidence, assumptions, applicability domain, and parameter side conditions. Distinguish an
  established theorem from an unproved generated conjecture, and a theorem’s proof from the
  validity of a particular parameter instantiation. Mutations require explicit revalidation or
  justified evidence reuse; descendants do not automatically inherit their parents’ guarantees.

These dimensions must not be conflated: an evolved candidate can become validated and usable in
proof-generating search; a hand-written or imported candidate is not automatically established.
Heuristic search can use proved theorems, and heuristic candidate selection can support a
proof-generating run when all soundness obligations for the resulting claims are discharged.
Assess concrete examples of these combinations in the existing implementations and identify
where current terminology, admission rules, or artifacts collapse the distinctions.

## Core machinery and private knowledge boundary

User direction on 2026-09-06: evolve’s reusable machinery, core abstractions, and workflows
belong in Ergodis core. Selected heuristics and theorems may remain private trade secrets.
The synthesis must classify components by that boundary, not permanently assign a generic
workflow to private merely because C1016 or a spike first implemented it.

Map core-owned proposer/evaluator/admission interfaces, lifecycle/control/persistence workflows,
and generic composition/quotient machinery separately from optional private heuristic policies,
theorem implementations, parameter recipes, and task-specific adapters or fixtures. These are
classification targets for the review, not a decision that every example must stay private.
Private implementations should consume core contracts through the existing one-way dependency;
core must not require, name, or leak private knowledge. Confidentiality is independent of search
mode, origin, and validation: private does not imply heuristic and public does not imply proved.

Recommend concrete promotion and extension seams while preserving existing history and validation
gates. This user direction sets the intended ownership boundary; it does not authorize public
export/push or choose which specific heuristics/theorems to disclose. Core checkout ownership and
public release remain separate decisions.

## Industry IP and potential carve-outs

Further user direction: held-back private knowledge may later become licensed IP or patent
material for specific industries. Ergodis may establish industry subsidiaries/branches as
acquisition targets, transferable with their associated IP. QEC is the prime candidate to keep
separate. These are strategic possibilities to preserve, not decisions that an entity, patent,
license, or transaction already exists.

The synthesis must therefore address separability beyond a single public/private flag:

- Map shared core machinery versus industry-specific assets, beginning with QEC, including
  algorithms, theorem implementations, heuristics, parameter recipes, adapters, datasets,
  fixtures, benchmarks, evidence, documentation, and generated/evolved artifacts. Identify
  current locations, contributors/source provenance where recorded, dependency edges, and
  unresolved ownership or reuse assumptions. Repository location alone is not legal ownership.
- Assess a QEC carve-out explicitly: which assets could transfer together, which core services
  they require, what core access/licensing assumptions would need a decision, and whether build,
  test, deployment, and ongoing development could function after separation. Keep generic core
  independent of industry implementations; identify current coupling rather than presuming the
  boundary is already clean.
- Trace knowledge flow through evolve: mixed private/public or cross-industry parents, training
  corpora, candidate archives, learned policies, theorem compositions, parameter tuning, proof
  artifacts, socket responses, and exported diagnostics. Recommend how to retain source and
  derivation lineage plus explicit use/disclosure decisions, so evolution or validation cannot
  silently erase an input’s private or industry association. Do not infer legal derivative-work
  status or automatic ownership merely from computational ancestry.
- Distinguish technical validation, confidentiality/disclosure, permitted reuse, and proposed
  ownership/industry allocation. Certification does not itself authorize publication, licensing,
  or movement between industry packages. Record uncertain or mixed cases for a concrete decision.
- Recommend a reviewable asset/dependency map and staged technical boundaries that preserve
  future licensing, patent, and acquisition options. Flag questions requiring IP/legal advice
  without deciding patentability, inventorship, assignment, or transaction structure in this
  technical review. Any later legal conclusions require appropriate research and review.

This adds analysis to C1079, not authorization to move QEC work, change other lanes, disclose
private material, file patents, create entities, or allocate IP rights. The core/private ownership
direction above still stands; the plan must explain how shared machinery and separable industry
knowledge fit together.

## Hybrid runtime industry extensions

User direction: one core binary loads industry extensions at runtime. The latest preferred
shape is a hybrid: shared libraries (`.so` and platform equivalents) for specialized kernels,
and source code compiled on the fly into Ergodis IR for other extensible/evolved logic.
An industry package may supply both. This refines the earlier shared-library-only framing;
the plan must assess the division of responsibilities rather than force all private knowledge
into native modules. Source language, IR entry points, and exact native/IR split remain to be
recommended from existing machinery. Runtime source compilation does not by itself imply
arbitrary Rust/native compilation, a new JIT, or hot replacement of active solver code.

The plan must inspect existing extension/registration mechanisms and specify a concrete runtime
module contract covering:

- Which capabilities a module can register: industry adapters, proposers, heuristics, theorem
  validators, parameter generators, and quotient/compiler specializations as applicable; identify
  which lifecycle and workflow services stay in the host core.
- Recover existing source languages, typed term/feature DAGs, VM lowering, and compiler paths;
  identify which can support industry-supplied and evolve-generated source without inventing a
  parallel IR. Define source-to-IR validation, resource bounds, compilation diagnostics, and
  compatibility with downstream quotient/compiler consumers.
- Define how IR programs call registered native kernels: typed semantics, required capabilities,
  parameter/shape constraints, evaluation costs, and proof/replay obligations. A native kernel’s
  availability or a source program’s successful compilation is not evidence of theorem validity.
- Bind source digest, language/compiler/IR versions, compilation options, native module versions,
  and resulting IR identity into lineage and replay. Distinguish source mutation from compiler
  transformation and parameter instantiation; specify which changes require revalidation and
  how cached compilation/evidence is reused without losing scope or origin.
- Assess confidential source/IR/caches, generated artifacts, and diagnostics as part of each
  industry’s IP package, including deployment arrangements where private source is available
  to the runtime. Source-to-IR compilation is not an IP disclosure or ownership decision.
- ABI/API versioning and compatibility, module identity/version/digest, dependency negotiation,
  loading/initialization, ownership and lifetime of data/callbacks, error handling, and reproducible
  module resolution. Evaluate the implementation choices under the existing Rust/performance
  guides before recommending an ABI; this brief does not select one.
- Binding module and knowledge provenance into candidates, theorem/parameter lineage, validation
  evidence, and replay artifacts. Distinguish registering a validator from establishing trust in
  its checks; loading a module must not itself grant proof authority or disclosure rights.
- The trust and failure model of in-process modules, and whether any extension capability needs
  a separate execution boundary. Do not equate a shared-library boundary with confidentiality or
  fault isolation. Preserve the industry IP boundary in packaging and interfaces as well as code.
- Interaction with active campaigns, Unix-socket steering, and compiled consumers, including safe
  lifecycle transitions and hot-path costs. Determine whether loading is startup-only or also
  allowed during a run; live unloading/hot replacement is an unresolved choice, not a requirement.
- Independently buildable/versioned industry modules, a core-only usable binary, and concrete
  compatibility/replay/acceptance tests. Assess QEC as the leading private module/carve-out example.

Deliver a staged path to the single-host-binary hybrid native/IR model without moving source or
building a loader/compiler extension during this evidence-and-plan task. Public export and specific private IP
release decisions remain separate.

## Obfuscated black-box demonstrations

Explicit user requirement: provide demos using both native shared-library extensions and
source-to-IR extensions in an obfuscated black-box form, preserving private industry knowledge.
The synthesis must include a concrete demo packaging/execution strategy for each path.
Latest user priority: shippable black boxes that recipients run themselves. Hosted/walled
execution is secondary and must not substitute for the deliverable.

- Lead with a distributable core executable plus native/opaque-IR industry payloads, runnable
  on recipient-controlled infrastructure without depending on hosted execution. Specify supported
  targets, packaging, installation, dependencies, and local execution. Any network or activation
  dependency must be explicit and justified, not silently assumed.
- Evaluate the recipient-run package against a stated inspection model: what the recipient
  receives, controls, and can inspect. Recommend practical obfuscation and exposure-reduction
  measures and their costs without promising unrecoverability. Hosted execution may be a
  secondary comparison, not the recommended substitute for a shippable black box.
- For native extensions, assess the demo artifact and exposed symbols/interfaces, metadata,
  diagnostics, and runtime outputs. For source-to-IR extensions, assess private compilation
  before delivery and protected/opaque deployable IR or other executable artifacts loadable
  by the shipped runtime. State which routes require source or readable IR at the recipient and
  what tradeoffs that introduces. Production runtime compilation remains part of the target;
  demos may use a separately prepared artifact when justified.
- Map exposure through the whole demo, including Unix-socket introspection, candidate archives,
  generated/evolved source and parameters, proof/replay exports, debug traces, logs, caches,
  temporary files, and error messages. Define the intended public demo interface and useful
  observable results without inadvertently shipping private theorem/heuristic assets.
- Preserve full internal provenance and validation records while exposing a deliberately scoped
  demo view. Any withheld evidence must be explicit: do not describe an opaque result as
  independently replayable when the recipient lacks the required checker, inputs, or artifacts.
- Include a reviewable demo bundle/dependency manifest and acceptance checks for unintended
  disclosure, compatibility, and representative functionality, with QEC as the leading example.
  Identify the residual exposure and deployment tradeoffs that require a user decision.

This is a packaging and technical disclosure requirement for C1079’s plan. It does not choose
which industry assets to demonstrate, authorize delivery/publication, or settle licensing or
patent questions. Demo visibility is independent of search mode, origin, validation, and IP
ownership; obfuscation is not evidence of correctness or legal protection.

## Boundary and acceptance

This task produces a review and concrete, reviewable synthesis plan, not an implementation merge
or architecture migration. Present consequential architecture choices for Tavis’s decision after
completing the evidence and recommendation. Do not narrow the product into a manual controller,
a fixed theorem catalogue, or a single C1016 search heuristic without explicit justification and
approval. Do not expand into unrelated engine remediation or manuscript work.

Acceptance: one evidence-backed account reconciles the existing implementations and intentions,
recommends the best autonomous-system direction, identifies unresolved choices honestly, and
provides an executable sequence of scoped follow-up work. Allocate follow-ups only when warranted
through the normal task-ID process. Planned report:
`notes/2026-09-06-c1079-ergodis-evolve-review.md`.
