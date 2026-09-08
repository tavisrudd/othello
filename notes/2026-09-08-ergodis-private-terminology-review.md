# Ergodis private terminology review

**PRIVATE — contributor context only. Do not ship, export or publish.**
**Lane**: `ergodis`. Date: 2026-09-08.

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
parts of this lifecycle; a general cross-family execution interface remains
**planned**. They do not require one universal model schema, matrix representation,
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

Review hygiene: an initial combined C1091/runtime-IR read emitted 11,006 tokens and
was truncated. This violated the command-output cap; subsequent reads used bounded
sections. No conclusion relies on omitted output.
