# C1130 — live promotion design refinement

PRIVATE — NOT TO SHIP. 2026-09-08. Proposal, not implemented capability.
User asked for deeper design after clarifying independent Evolve and immediate
promotion into running solves, as on native. This refines the initial plan in
`2026-09-08-c1130-live-solve-promotion.md`.

## Recommendation

Implement one portable running-solve/promotion contract, with family-specific
consumption proofs and host-specific delivery. Start with the existing private
capacity-fit branch-and-bound kernel. Do not begin by changing all adaptive DP
backends or by making shared WASM memory mandatory.

The essential pipeline is:
proposal → mathematical check → backend-use admission → prepared immutable plan
→ published epoch → worker safe-point adoption → actual pruning/termination.
No generation barrier or all-worker acknowledgement barrier blocks adoption.
“Ready” and “applied” are distinct observable events; apply at the first eligible
safe point, with measured bounded latency. A discovered rule is not an active rule.

## New findings from source review

- Core `src/alignment.rs` has a 4096-state steering check under a controlled
  instantiation. Private `src/alignment_control.rs` swaps prepared/recycled arenas
  and reports applied epoch; its inspected plan consumer is Ordering/Score.
  This is a valuable native lifecycle reference, not evidence that all native
  solvers accept arbitrary exclusion predicates.
- Core `src/scheduler.rs::solve_counted_types_with_workspace` drops family
  multiplicity limits, scans an unbounded type relaxation, and accepts only if
  its reconstructed witness respects every original multiplicity. Otherwise it
  falls back. A valid theorem about bounded job sets is not automatically valid
  for every relaxed DP state or compatible with this acceptance argument.
- Private `src/resource_capacity_fit.rs::FitPlan::solve` already uses explicit
  next-choice/choice/load arrays, local depth/served counters, an incumbent and
  a node limit. Those are concrete continuation state. Current calls reset them;
  resuming the same search requires preserving them rather than calling solve
  again. This is a smaller and more interpretable first consumer than all three
  resource-scheduler backends.
- `wasm/www/module-host.js` currently rejects manifest imports and all actual
  WASM imports. An optional host callback is therefore a future explicit loader
  capability, not something the current ABI already supports.

## Separate theorem validity from applicability

A mathematical receipt binds a theorem to source semantics. A backend-use receipt
also binds the objective/readout, backend representation, residual-state schema,
permitted role, relevant constraints and compiled payload. Four roles should be
kept separate:

1. Ordering changes which open branch is explored next; it grants no exclusion.
2. A residual bound can prune a branch under a proved incumbent/target condition.
3. A witness can improve an incumbent only after feasibility/objective checking.
4. A representation change can require frontier/cache migration; defer it from
   the first live-promotion contract rather than treating it as a pointer swap.

Restrict the first spike to validated bounds over an unchanged model, objective
and state representation. For maximization, k + U(remaining) ≤ incumbent permits
pruning if the readout asks for one optimum witness; all-optima enumeration needs
its own strictness rule. For minimization, an admitted completion lower bound
must respect the complete objective. Capacity Fit currently breaks ties by
additional capacity, so equality on its primary cost alone cannot justify dropping
an otherwise improving secondary-objective branch. Threshold feasibility is a
different readout from exact optimum; a failed threshold is not a fabricated
maximum result.

Safe use of a root theorem may be limited to global termination: an independently
validated feasible incumbent matching a proved global bound establishes optimum.
That is distinct from residual-state pruning. A source cover can be lifted only
with an explicit mapping from the running prefix to remaining jobs and capacities.
DP transfer/reuse invariants and the counted relaxation require separate mappings.

## Portable execution object

Proposed cold interface shape (names provisional; reuse existing run/plan identities):

- begin(admitted model/query, prepared workspace, limits) → running solve;
- advance(work budget) → yielded / complete / budget exhausted / cancelled;
- install(prepared epoch, backend-use receipt) → accepted or rejected;
- status → incumbent, bounds, exact work counters, installed/applied epoch;
- finish → the requested result and retained evidence dependencies.

The same run ID, stack/frontier, incumbent, node counters and witness storage
survive every advance. Yield is not incomplete proof, budget exhaustion, cancel,
restart, or a new query. Persist phase/program-counter state where necessary to
avoid revisiting a transition or reapplying a load on resume.

Safe points must be representation-aware: no half-applied transition, torn arena,
or inconsistent incumbent. Prefer counted work strides and existing loop bounds;
never read wall clocks, parse JSON, allocate, compile, or poll a global queue in
per-state loops. Choose slice size from measured overhead and promotion latency;
4096 is the native alignment precedent, not a universal tuning constant.

The direct native entry point keeps its specialized fast path. Extraction changes
code generation even when intended as refactoring, so native performance must be
measured, not asserted unchanged from source appearance. Control and no-control
instantiations need separate checks. An unchanged active plan should have only
the admitted coarse check cost; existing non-controlled calls should have none.

## Delivery mechanisms

Portable path: at a bounded safe point the WASM call returns a continuation status;
the Worker processes already-arrived promotions, installs a ready plan, then posts
the next advance task. Use a real event-loop turn, not a microtask loop that starves
message delivery. Evolve runs in another Worker and never gates continuation.
This works without shared memory, including the LAN HTTP/iPhone setup.

Optional optimized path: a small SharedArrayBuffer control mailbox can be polled
from an imported JS host function at guarded WASM safe points, while each solver's
WASM linear memory stays private. JS Atomics can observe another Worker's published
epoch while the solver's exported WASM function is still running. This avoids a
mandatory shared solver heap or separate threaded engine build, but still requires
HTTPS/cross-origin isolation and a narrowly admitted host import. This is a design
inference from the documented JS/WASM APIs, not a tested Ergodis implementation.

References:
- https://developer.mozilla.org/en-US/docs/WebAssembly/Guides/Using_the_JavaScript_API
- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics/load
- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer

Use immutable bounded payload slots and per-worker inbox/acknowledgement records.
The controller is the sole inbox writer; workers own their workspaces. Publish the
payload before its ready epoch; never overwrite a slot still referenced by a
worker. Dropping intermediate publications is safe only when the new snapshot
contains the still-required rule set/dependencies. An epoch is not a proof. Keep
proof artifacts used for earlier pruning even after retiring a rule from the
active evaluator. Native acknowledgement/reclamation must avoid contention.

## First spike and acceptance

Use one actual capacity Fit/Optimize search with a fixed total work budget.
Extract its continuation and compare uninterrupted with arbitrarily chunked runs
before enabling promotion. Then inject a prechecked completion bound after actual
positive solve progress to isolate transport/adoption correctness from discovery.
Finally attach real Evolve. Do not add artificial delay to manufacture the final
story; forced late delivery is a test control only.

Required evidence:
- same run/frontier and monotone work counters before and after promotion;
- the actual applied epoch and proof reference, not just “published”;
- exact optimum including tie-break and witness agreement across native/WASM,
  uninterrupted/chunked and several promotion points, plus an independent oracle;
- wrong-source, wrong-role, stale, malformed and invalid-plan rejection that
  preserves the accepted solve; interrupted/failed discovery leaves solve useful;
- zero-allocation controlled hot scan, retained native A/B counters and relevant
  single/parallel performance checks; no-input/no-benefit controls;
- proof scope sufficient for each actual pruned branch and result readout.

Keep multi-solver-worker sharding as a follow-on. First prove one solve Worker and
one independent discovery Worker. Then distribute disjoint coarse search regions
with private workspaces and per-worker applied epochs; do not share a mutable
frontier or wait for every worker to acknowledge an epoch.

## Performance and display

There are two honest comparisons: fixed solver resources (discovery gets extra
CPU) and fixed total CPU resources (discovery competes with potential solve
workers). Record which is being shown. A separate Worker prevents execution
barriers, not cache/bandwidth/thermal contention; zero total slowdown cannot be
promised merely from thread separation.

Admission proves safety, not benefit. Compile cheap bounded evaluators; retire
valid rules whose application cost outweighs pruning while retaining past evidence.
Record time to useful incumbent and time to proof/target, states/transitions,
discovery CPU, publication-to-application latency and no-benefit overhead. Count
pruned branches or states honestly: a pruned subtree does not have a known exact
original-state cardinality unless there is a counting certificate. Do not infer
an exact space-reduction percentage from a cheaper search ordering.

Orange markers should denote application by a running solve and show the theorem,
backend-use receipt, source scope, applied epoch, affected worker(s), actual pruning
and measured latency. Published-but-unapplied rules belong in discovery status.

## Closeout / open questions

The key settled design distinction is theorem validity versus backend-use validity.
The clearest first kernel is capacity Fit, with its objective tie-break preserved.
Open engineering gates are continuation extraction cost, useful bound families,
measured slice size, and the optional mailbox-import contract. Representation
migration and arbitrary new executable kernel loading are deliberately separate
future capabilities. This proposal changes no code or native performance contract.
