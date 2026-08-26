# C971: ERGO-Comp publication preparation and manuscript-update draft

**Lane**: `complete-ports`

**Status**: QUEUED AFTER C962

## Objective

Turn the paper-owned recovery-optimization prototypes into a clean, reviewable
companion package under the public working name **ERGO-Comp** (*Exact Recovery
and Generalized-weight Optimization Compiler*), and draft the corresponding
manuscript update.  Work from the monorepo authority, preserve exact witnesses
and independently checked claims, and stop before any push, deposit, submission,
or other public release.

The package must present a coherent tool rather than a research-session export.
Its public surface must contain no task identifiers, lane terminology, private
repository paths, dated internal reports, status markers, agent instructions,
or narration of the process that produced it.

## Product statement

ERGO-Comp compiles structured linear-recovery problems into exact optimization
engines.  It computes minimum helper costs and confinement thresholds, composes
costs through concatenated-code hierarchies, and retains recovery witnesses and
infeasibility certificates rather than returning scalar optima alone.  Its
specialized kernels exploit affine, lattice, incidence, and finite-field
structure before invoking a generic optimizer.

The public claims must distinguish three levels:

1. general exact algorithms and proved complexity or correctness bounds;
2. structured instances on which the specialized compiler improves the model
   presented to a generic solver or replaces it entirely; and
3. application-specific experimental front ends whose conclusions remain
   bounded finite computations rather than general theorems.

## Deliverables

### 1. Publication-quality Rust package

- Adopt `ERGO-Comp` in user-facing prose and `ergo-comp` for the Rust package
  and command where registry and package checks permit it.
- Separate the reusable library, command-line interface, examples, benchmark
  targets, test fixtures, and evidence generators with narrow module APIs.
- Define stable input, output, witness, and certificate types.  Make exactness,
  field conventions, overflow behavior, determinism, and failure modes explicit.
- Preserve the Python implementation as the exact differential oracle without
  making it a runtime dependency of the Rust library.
- Eliminate accidental allocations, architecture assumptions, and benchmark-only
  shortcuts from general APIs.  Keep architecture-specific kernels behind safe
  runtime or build-time dispatch with a portable reference path.
- Supply deterministic serialization for durable witnesses and certificates
  only where a genuine external consumer requires it.

### 2. Public-surface hygiene gate

Audit every exported source, comment, doc comment, example, test name, fixture,
benchmark label, manifest, and generated artifact.  The export must contain none
of the following:

- `C` task numbers, lane names, queue states, handoff language, or agent/process
  instructions;
- `notes/` references, private monorepo paths, home-directory paths, temporary
  paths, local commit choreography, or internal report filenames;
- comments explaining when, why, or by whom code was developed;
- manuscript-planning residue, unpublished theorem-discovery claims, or
  application labels that disclose unrelated private work; or
- logs, profiler dumps, raw Criterion state, editor files, caches, or build
  products.

Public comments should explain mathematical meaning, invariants, representation
choices, complexity, safety, and architecture-sensitive behavior.  Historical
and process provenance belongs only in the private task report.  Add a repeatable
scanner for these hygiene conditions and require the repository export audit to
pass from an immutable committed source tree.

### 3. README that sells the tool accurately

The README is an external technical landing page, not an audit ledger.  Its
opening screen should answer what ERGO-Comp does, why a user would choose it,
and how to run one meaningful example.  Use this order:

Use the established elevator pitch as the source for the opening, edited only
for public terminology and verified claim strength:

> ERGO-Comp is a theorem-aware compiler for repeated structured exact
> optimization.  When mathematics exposes a quotient, conserved grading,
> generated-span state, bounded moment alphabet, or reconstructible coefficient
> block, ERGO-Comp compiles that structure into a smaller exact solver and sends
> only the surviving core to a specialized enumerator or CP-SAT.  It supports an
> exact code-and-repair co-design loop: construct a code under algebraic or
> geometric constraints, compute its recovery costs and witnesses, optimize
> concurrent repair under capacities, and return a checkable construction with
> its repair plan.

The final README may tighten this paragraph, but it must preserve its concrete
mechanism, the exact code-and-repair co-design capability, and the honest
relationship to CP-SAT.

1. one-sentence value proposition and a compact capability list;
2. a sixty-second exact-recovery example showing input, optimum, and retained
   witness;
3. headline capabilities: prescribed-coset support optimization, hierarchical
   min-plus composition, confinement thresholds, exact certificates, structured
   finite-field kernels, and hybrid generic-solver integration;
4. a fair comparison explaining when ERGO-Comp replaces a generic solver and
   when it compiles a smaller exact model for CP-SAT or another backend;
5. reproducible benchmark tables on declared instance families, including
   end-to-end latency, peak memory, preprocessing, witness verification, and
   competitor configuration;
6. the applications most likely to benefit: hierarchical storage repair,
   exact helper selection, recovery-aware code design, constrained
   reconfiguration, and bounded finite theorem discovery;
7. concise installation, API, CLI, architecture, reproducibility, citation,
   license, and support information.

Do not advertise component microbenchmarks as end-to-end solver speedups.  Do
not compare only against an intentionally unstructured CP-SAT formulation when
a fair competitor is ERGO-Comp preprocessing plus CP-SAT.  State the winning
domain, losing domain, hardware, compiler flags, stopping conditions, and
whether each result includes witness construction and verification.

### 4. Reproducible evaluation bundle

- Freeze representative instance families before comparative tuning and state
  their selection rule.
- Compare against the nearest specialized algorithm where one exists, direct
  enumeration for tiny cases, direct CP-SAT, and ERGO-Comp plus CP-SAT when that
  is the fair hybrid.
- Separate compile/preprocessing time, solve time, witness recovery, and witness
  verification.  Report distributions rather than a single favorable run.
- Record toolchain, dependency, target architecture, CPU topology, frequency
  policy, memory limits, seeds, warm-up, sample count, and timeout semantics.
- Check portable, native, and explicitly dispatched SIMD builds.  Never let
  `target-cpu=native` become an undeclared portability requirement.
- Commit the exact generator, compact canonical inputs or generation manifest,
  machine-readable results, checksum manifest, and independent replay together.
- Give every paper-facing result an exact claim boundary and evidence route.

### 5. Manuscript-update draft

Draft the update in the monorepo authority after the package and evidence shape
are stable.  The likely addition is a compact algorithms-and-companion section,
with detailed tables or pseudocode placed only where they improve the theorem
story.  It should:

- introduce ERGO-Comp as an implementation of the paper's exact optimization
  objects, not as a separate source of mathematical truth;
- state correctness and complexity results at their proved strength;
- explain the hierarchical recovery compiler, witness retention, and the
  structured-versus-generic solver boundary;
- give one model application that exposes the mechanism;
- report only frozen, reproducible comparisons with honest competitor models;
- separate general algorithms from bounded application-specific computations;
- avoid implying that a finite-field decision engine proves a field-uniform
  theorem; and
- preserve the paper's theorem-led architecture and main-proof admission rule.

Target a four-page net addition before tightening.  Reassess title, abstract,
introduction, conclusion, artifact statement, citation metadata, and page count
as one editorial unit rather than appending an isolated software advertisement.

### 6. Clean export preparation

- Extend the paper's authoritative export allowlist and manifest deliberately;
  do not copy the private algorithm directory wholesale.
- Ensure all public metadata, license notices, dependency licenses, citation
  files, and archival metadata are authority-owned.
- Run exporter `plan` and `audit` against the committed authority and resolve
  findings in source rather than through exclusions or rewrites that conceal
  private coupling.
- Materialize or synchronize only through the guarded paper exporter after the
  authority package, manuscript, tracked PDF, evidence bundle, and release gate
  pass.
- Replay the full release gate in the clean standalone repository and require
  release-surface hash agreement.
- Stop with a verified local export.  Push, deposit, DOI versioning, and
  submission require separate authorization.

## Acceptance gates

1. Public naming and registry/trademark screen recorded; `ERGO-Comp` used
   consistently and the existing unrelated ERGO/ERGOCOMP uses disclosed in the
   private release decision.
2. Rust formatting, strict all-target/all-feature linting, unit, integration,
   property, differential, documentation, fixture, and release-profile tests
   pass from clean source.
3. Portable and tuned implementations agree on costs, witnesses, loads, and
   rejection certificates.
4. Every advertised benchmark is reproducible from committed inputs and has a
   fair nearest-competitor configuration.
5. Package contents and dependency/license audit pass; no generated debris or
   private artifact crosses the allowlist.
6. The explicit public-surface scan finds no internal task/process artifact or
   identifier in code, comments, docs, examples, tests, fixtures, or benchmark
   labels.
7. The README passes two cold reads: one coding/storage user can identify the
   benefit and run the example, and one optimization expert can identify the
   comparison boundary and reproduce a headline result.
8. The manuscript draft states every computational and mathematical claim at
   the correct trust level, builds reproducibly, and remains readable after the
   net page addition.
9. Exporter plan/audit, authority release gate, standalone synchronization, and
   standalone release replay all pass before the package is called export-ready.

## Planned order

1. Freeze C962's accepted algorithms, theorem statements, and benchmark claims.
2. Inventory the proposed public tree and classify every path as library,
   example, evidence, private-only research front end, or excluded debris.
3. Stabilize the ERGO-Comp library/CLI API and portable correctness baseline.
4. Build the public hygiene scanner and clean all exported source surfaces.
5. Freeze competitor models and produce the reproducible evaluation bundle.
6. Write and cold-read the product-facing README.
7. Draft and independently review the manuscript update.
8. Run the complete authority and exporter gates; prepare a verified local
   standalone update without push or deposit.

## Non-goals

- No public release, push, deposit, submission, or announcement.
- No claim that ERGO-Comp generally dominates CP-SAT.
- No promotion of private application experiments into unrestricted theorems.
- No export of internal reports, task records, lane metadata, or development
  history.
- No manuscript theorem whose proof depends logically on a benchmark or trusted
  execution.
