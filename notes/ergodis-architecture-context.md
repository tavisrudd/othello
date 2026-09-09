# Ergodis architecture context

**PRIVATE — contributor context only. Do not ship, export or publish.**
**Lane**: `ergodis`. Reviewed: 2026-09-08.

This is the short architecture map, not a second glossary or a transcript. Read
it after the lane handoff for architecture, shared API/schema, execution, model/
query or portability work. Narrow UI edits and administrative work need only the
relevant handoff/task context. Follow links selectively; do not preload all reports.

## Binding user direction

- One Ergodis engine and logical contracts for native and WASM. WASM is a full
  execution target; missing bindings/portability are gaps, not product boundaries.
  Consolidate on one canonical WASM build. Private domain implementations remain
  private behind the one-way dependency boundary; do not introduce a demo engine.
  Public core hosts must consume separately compiled/obfuscated private packages
  without private source or rebuilding core privately. Reuse the C1084 extension
  boundary: canonical engine plus native/WASM/IR packages, not a mandatory private
  monolithic assembly. Multiple extension payloads are not multiple core engines.
- Preserve native performance and specialized layouts/kernels. Read the complete
  sibling `ergodis-contrib/PERFORMANCE.md` and `performance-playbook.md` before
  Rust design/implementation/profiling, as required by core/private AGENTS.md.
  Zero-allocation iterative hot loops, cold dispatch, worker isolation and retained
  single/parallel A/B counter gates remain mandatory. No native slowdown accepted
  as the price of portability or abstraction.
- Reuse existing architecture and implementations before adding frameworks.
  Domain-specific adapters are expected; duplicated host/front-end machinery is
  not. Do not force every problem through a matrix or coordinate restriction.
- Browser inputs are loaded real problems, with general views and domain
  specializations. Snapshot inspection and runnable execution must be explicit.
  Opening a saved record must not execute it. Important details go below the fold,
  not behind collapse panels. Normal workflows avoid implementation vocabulary.

## Semantic and ownership model

```text
Frontends / native and WASM hosts
                 |
Campaign/session runtime — goals, lineage, budgets, operations, history
                 |
Family-specific model + query admission / compilation / mathematical execution
                 |
Specialized solvers and kernels over prepared data and owned workspace
```

Independent verification checks named claims; repository/host adapters provide
history and effects. Neither is inside kernels. Dependency arrows point inward;
core must not depend on runtime or private packages.

Model, query, objective, representation and compiled plan are distinct. One model
can support several plans for different questions, readouts and evidence needs.
The **executor** applies a mathematical plan; **runtime** coordinates operations;
**execution host** owns physical workers. Query admission is not a solver answer.
Witness readout, optimum readout and independently certified optimality differ.
Updates need preservation/affected-dependency contracts, not merely new input bytes.

This is the established semantic direction. C1130 now has an experimental generic
module host, tested with independently compiled LRC/QEC native and WASM providers.
It runs alongside CampaignSession; runtime integration and a universal execution
contract are not complete. Its exclusive provider ownership duplicates compiled
plans across workers. Refine shareable immutable plans and owned executor workspaces
before ABI adoption; retain specialized direct native APIs. Evidence and limits:
`2026-09-08-c1130-module-loading-results.md`.
Private browser Application subclasses now bind QEC/LRC to that module host,
with query reuse and loaded-source gates; resource scheduling and capacity
Fit/Optimize now use the same loading boundary. They are cold frontend adapters,
not a generalized CampaignSession. Current integration boundary and acceptance
sequence: `2026-09-08-c1130-campaign-integration-review.md`. The private terminology
review has been reconciled against these three application modules; labelled
composition remains a separate unclosed extraction gate.

## Existing abstractions: reuse, with their limits

| Building block | Current evidence and limit |
|---|---|
| Portable scalar language | C1085 extracted parsing/lowering/evaluation and bounded codecs; compilation for WASM is not automatically a JS binding. |
| CampaignSession | C1087/C1088 shared service and browser Worker; its CampaignSpec remains the finite GF(2) restriction pilot on native too. It is not the universal mathematical model. |
| Experimental module host | C1130 core ergodis-modules and module Worker load independent private LRC/QEC providers; source-isolated native and actual browser transcripts pass. Coarse batching amortizes boundary cost; plan sharing, labelled composition, campaign integration, updates/checkpoints and production ABI adoption remain open. |
| OpenProblem / RetainedTree | Private `src/open_problem.rs`: context-bearing compiled problem, composition/identity/readout core with optional NormalizedProblem, TensorProblem and ReconstructProblem. Matrix, function, monoid-index and semiring-window adapters exist. This is retained composition, not every solver or a complete host lifecycle. |
| RepairModel → RepairPlan → BudgetQuery | C1093 private LRC adapter: compile once, admit budget changes, count/threshold/witness readouts. Fixed known repair family; no universal recovery schema. |
| CompositionShape | C1094 core structural geometry/budget admission; does not validate algebra, source lowering or query preservation. |
| ValidatedQuotient / admitted observables | C1095 core readout reuse with concrete distinguishing-pair rejection; finite declared context, not arbitrary implicit models or policies. |
| Domain/leaf/summary verification | C1096–C1100 separate source-event admission and independent summary transition checking. C1097 found a legacy sibling-forgery gap; C1098 confines old generic/specialized checkers to explicit legacy replay. Older ADR certificate claims are superseded by these reports. |
| Portable records/bundles/repositories | C1101/C1103/C1107/C1114/C1115: identity, publication and bounded browser/native persistence. Stored metadata and bundle parsing do not imply executable activation or proof authority. |

Native execution is broader than CampaignSession: typed CLI/library composition
(primes and GF(4)), represented transfer/towers, application resource/span kernels,
repair scheduling and separately launched controlled searches. GPU/MDS and LRC
optimize helper/resource models; the mockup's GF(256) matrix is not their request
contract. SmallField supports broader arithmetic, but not every solver/host binding
accepts it. See the current native-interface review below before proposing a port.

## Read next only for the work at hand

All monorepo report paths below are relative to `notes/`.

| Question | Authority / evidence to load |
|---|---|
| What does the missing mathematical execution layer mean? | `2026-09-07-c1091-core-semantic-contracts.md`: compiled-plan executor versus orchestration, plural preservation contracts, typed queries, query-directed plans and extraction gates. |
| What generic implementation already exists? | Private `docs/adr/0001-generic-dynamic-decision-layer.md` §§2,9 and `src/open_problem.rs`; `2026-09-07-c1093-dynamic-query-admission.md`. The empirical result is a small core plus optional capabilities, not a universal compose/tensor/quotient/reconstruct interface. |
| What about native abstraction cost? | Same private ADR §9.4–9.5 records historical leaf-fusion overhead and unequal-work comparisons. Preserve specialized fusion; rerun required retained gates for new changes. Historical claims are not current performance evidence. |
| How do sessions, hosts and packages fit? | `2026-09-07-c1084-portable-control-architecture.md`: shared service, repository, cold package boundaries, native/WASM hosts; distinguish target design from delivered stages. |
| What did C985 already decide? | `2026-09-01-c985-evolve-proposal-admission-architecture.md` §§Decision/Common protocol/Runtime and performance boundary; `2026-08-30-c985-ergodis-adaptive-search-learning-adr.md` §§Decision summary/Deployment ownership. Typed family admission → compiled consumer; proposal/evaluation/performance separate. |
| What concrete semantic corpus and admission can we reuse? | `2026-09-07-c1092-query-specialization-corpus.md`, C1093 dynamic-query report, C1094 core-composition report, C1095 observable-admission report. |
| What is actually missing from current native/WASM integration? | `2026-09-08-c1130-native-host-review.md` and `2026-09-08-c1130-wasm-feature-completeness.md`. The task card indexes Sunday/Monday implementation reports and canonical-build history. |
| Which terminology needs clarification? | Shipping core `docs/glossary.md` for compatibility names; private `2026-09-08-ergodis-private-terminology-review.md` for missing distinctions. Keep this review private unless the user separately requests public documentation. |

## Maintenance rule

Before claiming a missing abstraction, check the table and the relevant implementation.
Report separately: proposed, implemented privately, admitted for a family, exposed to
native, exposed to WASM, and actually tested. Neither a trait name nor a successful
build proves mathematical preservation or complete host support.

Update this map when an architectural decision or implementation frontier changes.
Put detailed findings in dated reports and leave one link here. Keep task state in
the lane handoff and exact task card; retain historical corrections in the archive.
Do not turn this file into a second queue or append a chronological session log.
