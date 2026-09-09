# Ergodis private terminology review

**PRIVATE — contributor context only. Do not ship, export or publish.**
**Lane**: `ergodis`. Date: 2026-09-08. Reconciled after the recovery/QEC/scheduling module integrations.

The shipping glossary remains the compatibility vocabulary. These are private
clarifications and proposed additions for architecture work, not new public API
or support claims. User explicitly requested private not-to-ship documentation.

## Missing distinctions in the existing glossary

The existing glossary covers campaign/host separation and query admission, but
lacks explicit Model, Query, Target, Representation, Compiled plan, Executor,
Update contract and Witness lifting entries. Physical plan currently illustrates
only scalar CompiledPlan; Source describes only plan expressions. Capability
currently conflates platform support and permission without naming mathematical
implementation/admission. The Execution context emphasizes physical attempts,
leaving mathematical execution below orchestration implicit.

Some implementation-status labels lag the bounded runtime/repository work:
Control service, repository publication and host bundle UI have implemented
slices. Do not turn a partial implementation into a blanket completed claim or
interpret a stale planned label as proof that no code exists.

**Source:** authoritative input to a model or compilation, including domain data
and expressions. Qualify model source versus plan source; origin is not authority.

**Capability:** qualify host capability (platform support), implementation
capability (available operation), admitted capability (justified for particular
inputs/assumptions), and permission (authorization). None implies the others.

## Models, queries and mathematical execution

These definitions describe shared semantic roles. Existing families implement
parts of this lifecycle. The experimental module ABI implements prepare, owned
workspace, execute and release for recovery, QEC and resource scheduling. A general
CampaignSession execution interface remains **planned**. They do not require one universal model schema, matrix representation,
trait, crate or mandatory sequence of operations.

| Term | Meaning and naming rule |
|---|---|
| Model | Validated mathematical structure with a declared source interpretation. It may support several questions and objectives. Family-specific invariants remain in family-specific types. |
| Query | A typed question about a model, naming its target, assumptions and requested answer semantics. An execution budget accompanies the query but is not automatically part of its mathematical identity. |
| Target | What is reconstructed, satisfied, decided or observed; distinct from the objective used to prefer answers. |
| Objective | The ordering or valuation of admissible alternatives, with explicit units and combination rules. Minimum cost, Pareto alternatives and probability aggregation are different semantics. |
| Representation | Mathematical information retained for an admitted family of questions: for example a quotient, catalog, frontier, circuit or direct model. Not every representation is a quotient or matrix. |
| Compiled plan | A representation with executable operations, validity/admission conditions and supported readout, lifting and checking routes. One model may admit multiple query-specific plans. This is broader than the existing scalar `CompiledPlan` type. |
| Compiled problem | An existing family-specific object holding validated or compiled mathematical context. In retained composition, `OpenProblem` implementations interpret their summaries through this context. The name does not assert a universal host API. |
| Executor | Applies a compiled mathematical plan through its supported operations and kernels. Distinct from campaign/session orchestration and from the execution host that owns physical workers. |
| Readout | An operation extracting an admitted observable from a representation. A value-only readout need not construct a witness; witness and certificate support must be explicit. |
| Lowering | Translation from source/model/query to a representation or executable plan. Structural validation, semantic preservation and evidence for that preservation are distinct obligations. |
| Update contract | Declares which model or query changes a plan admits, affected dependencies and revalidation/reconstruction obligations. An update may reuse the plan, require structural growth or require recompilation; names alone do not establish safety. |
| Witness lifting | Reconstruction of a source-level witness from retained execution information. A summary may support an optimum readout without retaining enough information to lift a witness. |

A **problem** identifies the mathematical task being solved: model, query and
objective as appropriate to its family. Do not force all three into one immutable
source object or treat a changed question as merely a faster implementation.
An unsupported query differs from a negative answer, and missing admission differs
from malformed input or exhausted execution resources.

Core compilers and executors own mathematical semantics; the runtime coordinates
their operations and records outcomes. Native and WASM hosts consume the same
logical contracts. A missing binding is an implementation gap, not a narrower
mathematical definition for browser execution. Select specialized implementations
at cold boundaries; host/protocol metadata does not enter kernel records or loops.

## Related decisions and implementation

C1091 is the direct semantic proposal; C1084 owns orchestration/host boundaries.
C1061 private ADR 0001 and open_problem.rs already implement the retained-composition
core plus optional capability traits. C1093–C1095 provide bounded admission slices.
Use `notes/ergodis-architecture-context.md` for the routing map and current caveats.

## Reconciliation against delivered modules

This pass follows the three **application modules**, not completion of the original
three-family contract gate. Field-valued labelled composition remains unbound;
resource scheduling does not substitute for its field/space/transport obligations.
The shipping glossary is unchanged. Existing names below remain compatible.

| Semantic role | Current implementation/wire mapping | Limit |
|---|---|---|
| Mathematical model | Private application `modelBytes`; provider PREPARE input | Each provider owns its schema. The source digest binds exact bytes, not mathematical equivalence. |
| Compiled plan | Provider PREPARE=1 returns an opaque plan handle | Host-local identity; not the scalar `CompiledPlan`, portable RunSpec or a persisted cache. |
| Executor workspace | WORKSPACE=2 creates mutable execution storage; EXECUTE=3 uses its handle | One owner during a call. Cross-worker immutable plan sharing is not established by this ABI. |
| Query and requested readout | LRC readout word; QEC syndrome; scheduling operation/target/budget words | Similar wire framing does not make the queries semantically interchangeable. |
| Implementation capability | Manifest capability/schema/revision plus target payload digest | Loaded package availability is not query admission, user permission or evidence authority. |
| Execution session | Private JS `ModuleSession` owns a Worker/provider/plan/workspace | Not `CampaignSessionClient`; no durable run history, portable continuation or campaign accounting is implied. |
| Application adapter | Private JS `Application` subclasses encode models/queries and interpret answers | Cold frontend composition; they do not define a universal mathematical executor. |
| Result | `Application.run()` envelope and family-specific `answer` | Current envelope is transient JSON, not portable `RunRecord`. Plan handle and host generation are diagnostics. |
| Operation completion | Worker call status plus provider-specific answer fields | A successful call may return an infeasible answer, overflow or budget-limited incumbent. Transport success alone cannot mean optimal. |
| Forward witness check | Recovery re-executes proposed capacities; scheduling returns chosen load vectors | Consistency/feasibility evidence, not an independent optimality certificate. |

### Capacity design and interaction

| Term | Precise meaning in the current applications |
|---|---|
| Capacity | Upper bound on aggregate use of a named resource in the admitted batch/model. It is not utilization, a solver-memory allowance or a machine speed. |
| Load | Resource use of the returned assignment/witness, in the same units as its capacity. |
| Target repairs / target demands | Requested minimum served count. This is a feasibility threshold, distinct from both total pending demand and the objective. |
| Evaluate capacities | Ask how many demands the current model/capacities can serve, with a target-met readout. |
| Fit target | Minimize additions needed to reach the target, with every existing capacity as a lower bound. It intentionally retains overprovisioning. |
| Optimize capacity | Minimize total capacity needed to reach the target; both increases and reductions are permitted. Scheduling breaks equal-total ties by fewer additions. |
| Capacity cost | Currently the sum of equally weighted capacity units. It is not monetary cost, and units from unlike resources need explicit weights before economic interpretation. |
| Search budget | Bound on execution work; scheduling design currently caps decisions and can return an incumbent without proving minimality. It does not relax the mathematical target. |
| Proposal | A suggested configuration, including changes relative to current inputs and its completion/optimality status. It is not applied until the explicit Apply action. |
| Apply configuration | Replace source capacities and prepare a replacement model before the forward run. Failed preparation retains the earlier accepted session. |
| Hover preview / pinned selection | Temporary/persistent inspection focus. Pinning does not constrain optimization or hold a resource capacity fixed. A future optimization lock must be separately named. |
| Capacity map | Exact evaluations at displayed grid points; a sampled axis is not an exact continuous frontier. The recovery map may redistribute global parity and is not the additive Fit operation. |

In these applications, **Run** is the UI command. **Execute** is the coarse module
ABI operation; it must not become a competing normal button. One Run can invoke
several executions for its primary answer, witness check and explanatory plot.
Those calls are not automatically independent persisted runs. A later recorded
run needs explicit primary-query binding and subordinate analysis provenance.

### Remaining semantic vocabulary

These retain C1091 meanings and are **proposed shared contracts**, not delivered
universal types. Reuse the existing glossary's Observable, Query admission,
Witness, Certificate and Composition shape names; do not introduce synonyms.

| Term | Boundary that must be explicit |
|---|---|
| Space | Carrier with scalar domain, coordinate interpretation and, where relevant, dimension or finite vocabulary. Equal matrix dimensions do not identify equal spaces. |
| Basis / coordinate convention | Chosen coordinates for a named space, including ordering and scalar presentation. Source identity must bind these conventions. |
| Transport | Declared map between spaces or representations, with direction and preservation obligations. A coordinate permutation is not permission to reuse a claim without checking its transport. |
| Resource identity | Which demands share a capacity, with unit and aggregation semantics. Equal numbers or display labels do not establish shared identity. |
| Valuation | Values assigned to alternatives and the operations used to combine/order them. Minimum cost, counting, probability mass and Pareto order need distinct laws. |
| Query family | Questions for which a representation's preservation claim applies; not simply every request accepted by the byte parser. |
| Preservation contract | Stated observations, contexts, quantifiers and witness obligations preserved by lowering/representation/update. C1091's observation contract is this contract specialized to observables. |
| Answer contract | Meaning of returned values, witnesses, negative answers, coverage, optimality and exceptional cases. It includes the distinction between unavailable readout and a negative answer. |
| Decision / policy | A chosen action / a mapping from available observation histories to actions. Finding one configuration is not learning a policy or proving its behavior under future failures. |

### Shipping glossary status corrections to carry privately

The following **planned** labels are stale in part; remove none blindly. Reconcile
per capability when a separately authorized shipping-doc pass occurs.

- Run ID, immutable RunSpec/RunRecord, bundles and typed predecessor/fork links:
  portable codecs are implemented. General campaign history across module runs is not.
- Repository publication, attempts, annotations and accounting: bounded reference,
  browser IndexedDB and native filesystem slices exist (C1107/C1114/C1115).
  This is not an unrestricted durable service or automatic execution recovery.
- Bundle host UI and chosen-spec forks: browser inspection/verification/fork slices
  exist (C1105/C1106). Module activation and opaque bundle-to-execution conversion
  remain separate and incomplete.
- Control service: CampaignSession's portable finite-reduction service exists
  (C1087/C1088). Universal domain execution and in-flight cancellation do not follow.
- Module/package runtime loading: experimental native/WASM loading exists (C1130).
  Stable ABI, immutable plan sharing, update/checkpoint contracts and full family
  availability are still open.

Refresh this review when composition, campaign history and further families land.
The current integration boundary and acceptance sequence are in
`2026-09-08-c1130-campaign-integration-review.md`.
