# C985 Ergodis campaign-control spike

**Date:** 2026-08-30. **Lane:** complete-ports. **Status:** experimental v0
implemented and exercised; no solver-authoritative rule promoted.

## Outcome

The optional theorem-campaign vertical slice is now real. Ordinary Ergodis
library and CLI solves do not link or enter it. Enabling `control-plane` adds
separate `ergodis-campaign` and `ergodisctl` binaries, a presized feature-batch
representation, a bounded typed postfix VM, per-run Unix-socket isolation,
epoch-atomic diagnostic-plan activation, a file-backed attack ledger, compact
agent briefs, localized file traces, batched/evolutionary proposal evaluation,
exceptional-state ranking, exact feature-sufficiency ceilings, and a bounded
decision-tree proposer. Author plans now have an SMT-LIB-inspired typed prefix
tree that lowers to the same validated postfix VM; the explicit postfix form
remains the stable replay/debug IR. Executable hashes exclude display names, so
renaming an attack cannot manufacture a distinct replay identity.

The first live-adapter boundary is also present. Each solver registers a
private Unix datagram endpoint and the campaign pushes one eight-byte epoch
only after semantic plan activation or deactivation. The auxiliary watcher
blocks in `recv`; on notification it fetches, validates, and compiles the
latest plan set into a recycled preallocated arena. The solver safe point only
swaps arenas through a rarely touched mutex and returns the old one for reuse.
There is no timer, socket/file I/O, serialization, compilation, allocation, or
deallocation in the search path. A preliminary C880 socket exercise observed unchanged
epoch 0, activated the exact 11/11 marginal-saving predicate at epoch 1,
fetched its lowered plan against epoch 1, rejected a misspelled plan identity,
deactivated it at epoch 2, and returned an empty changed snapshot.

The C880 DFS now also consumes that boundary. Its ordinary entry point uses a
const-disabled generic path. `alignment-controlled` folds a 4096-state flag
check into its existing precomputed heartbeat deadline, publishes six bounded
progress counters through relaxed atomics, and applies score plans only to
branch ordering. No branch can be removed. Optional one-second progress JSONL
is serialized by the watcher through a line writer; the feature is absent
unless an explicit create-only output path is supplied.

Two solved n=8 UNSAT controls exercised the live path. Budget 12 accepted the
residual-packing ordering theorem after 245,760 states and closed exactly after
308,499 states in 17.30 seconds; the unchanged core baseline closed after
308,653 states in 7.95 seconds. Budget 13 reported 786,432 states at an
intermediate query and closed without the theorem after 2,002,426 states in
43.10 seconds. A separate run injected the theorem at epoch 1, later removed
it at epoch 2, and closed after 2,001,680 states in 168.85 seconds. Peak RSS was
about 69 MiB and 134 MiB for budgets 12 and 13 respectively. These are
diagnostic single runs, not performance estimates.

The negative exposed and then removed classic repeated work: exact scores were
recomputed for every remaining candidate on every selection. Fixed, pre-sized
per-depth buffers now score and sort each frame only once, with no allocation;
the storage exists only under `control-plane`. Repeating the same mid-run
budget-13 injection fell from 168.85 to 78.07 seconds, a 2.16x repair, while
retaining the exact UNSAT answer and near-identical 2,001,421-state tree. The
budget-12 injection similarly fell from 17.30 to 10.13 seconds. The policy is
still rejected for production: 78.07 seconds is 1.81x the 43.10-second
no-theorem diagnostic, and 10.13 is 1.27x the 7.95-second unchanged core path.
The exact child bound is costly and did not materially shrink either tree.
Safe-point users control only the relaxed heartbeat publication interval; all
socket and serialization work now belongs to the watcher. Ordinary feature-off
solves retain neither control branches nor ordering storage.

The event-driven idle gate passed a rotated multiround control on the current
budget-12 tree (309,777 states in every run). Across nine rounds per arm,
baseline, idle event control, and one `noop` request per second averaged
7.9789, 7.9667, and 7.9578 seconds. Paired idle-minus-baseline was -0.0122
seconds (`t=-0.860`, ratio 0.9985x); noop-minus-idle was -0.0089 seconds
(`t=-0.640`, ratio 0.9989x). Every controlled result reported zero semantic
notifications. The claim is therefore “no measurable overhead in this
protocol,” not a speedup. The replay driver is `scripts/control-event-ab.sh`.

An isolated 1,048,576-state Criterion gate explains the choice of cadence: an
every-state relaxed load took 208.8 microseconds, whereas a 4096-state mask
gate took 106.5 microseconds (1.96x cheaper). Folding the gate into the existing
deadline was better still: the combined deadline microkernel took 431.6
microseconds versus 508.5 microseconds for the old heartbeat-only loop. The
production loop consequently adds no second steady-state comparison.

A longer budget-13 rescue exercise began under the deliberately adverse
`-child_packing` ordering, then deactivated it and activated `child_packing` at
15 seconds. The watcher observed two semantic notifications; progress JSONL
first showed applied epoch 3 at 15.986 seconds and 487,424 states. The exact
UNSAT run closed after 2,011,955 states in 101.76 seconds. This is a control and
trajectory test, not evidence that residual packing is a winning heuristic:
the already measured always-good-policy run remained 78.07 seconds and the
plain no-theorem run 43.10 seconds.

Implementation commits are `07cc0ebe2`, `b1c4dd052`, and `3a30a24e6` plus the
current follow-up. Operator documentation is in
`papers/complete-repair-ports/ergodis/docs/CAMPAIGNS.md`.

## Architecture after real use

The first monolithic control module became unwieldy during the same session,
confirming the anticipated refactor pressure. It is now a subtree:

```text
src/control/mod.rs          controller, ledger, bounded query model
src/control/client.rs       double-buffered safe-point plan arena
src/control/alignment.rs    C880 heartbeat and ordering adapter
src/control/vm.rs           feature batch, typed bytecode, evaluator
src/control/synthesis.rs    iterative bounded decision-tree proposer
src/bin/ergodis_campaign.rs isolated campaign process
src/bin/ergodisctl.rs       human/agent CLI and unattended batch/evolve loop
src/bin/alignment_controlled.rs opt-in live C880 runner
```

Transport and ledger extraction are the next structural refactors if their
surfaces continue to grow. The core solver modules remain independent.

## C80 results

The existing q11/q13 K_Omega admission scout gained an opt-in streamed feature
sidecar. Re-running the full retained protocols produced 37,292 q11 and 33,596
q13 reply rows (70,888 total, about 5.7 MB JSONL) while both original aggregate
certificates remained byte-identical at their retained SHA-256 hashes.

The first two hand predicates were not perfect on the mixed labels. A bounded
three-generation run tested 192 mutations but found only 24 distinct truth
vectors. Its best rule was

```text
next_defect_rank == 0 && omega_drop > 0
```

with 70,728/70,888 correct, zero false positives, and 160 false negatives. The
first exact miss was q13 with next defect rank 6, support surplus 20, and Omega
drop 102. The obvious support-surplus disjunction repaired all misses but added
21,782 false positives.

The exact feature-ceiling query found 993 distinct feature vectors, no
opposite-label collisions, and therefore zero unavoidable errors from this
feature vocabulary. A direct obstruction-led proposal then found the sampled
identity

```text
survivor reply
iff
Omega descends and next defect rank is 0 or 6.
```

It agrees with all 70,888 retained rows: separately 37,292/37,292 at q11 and
33,596/33,596 at q13, with 23,000 and 10,428 positive replies. This is a new
diagnostic hypothesis, not a uniform theorem. A first q17 hostile extension was
inconclusive rather than confirmatory: 30 sampled states and 3,001 complete
exchanges produced no new-defect rows and no sampled state in `K_Omega`, so the
feature sidecar contained only its header. The `{0,6}` shape therefore remains
supported exactly on q11/q13 and wholly untested at q17; the next q17 probe must
target the rare survivor stratum instead of increasing an unguided sample.

The bounded tree proposer gave 27 nodes/66 VM operations and 70,746 correct on
the combined corpus. Holdout made its status clearer: training only on q11
learns the 3-node rank-zero rule, which is exact on all q11 rows and misses the
same 160 q13 positives. A q13-trained 41-node tree remains perfect on q11 but
has 140 q13 false negatives. The direct obstruction-led `{0,6}` rule is both
smaller and exact on the retained corpus, illustrating why the agent remains a
useful proposer above automated search.

## C880 and small controls

The C880 adapter compiles eleven retained marginal attachment instances into a
mixed strict-saving task. The exact rule `marginal_cost < naive_cost` classifies
all eleven; grouped output shows equality for new-point counts one/two and
strict savings for the sampled counts three through five. The feature ceiling
is exact, and a three-node tree recovers the same split. An exceptional hardness
score identifies the 224,947,066-node `(m,k,j)=(7,2,5)` instance first, followed
by the 16,204,232-node `(8,4,4)` instance. These are workflow controls, not new
C880 mathematics.

Small tests cover malformed and ill-sorted bytecode, source-expression
lowering, simultaneous isolated campaigns and cross-run rejection, the
disjunctive C80 shape, and zero allocation across 10,000 compiled-VM row
evaluations. The full pre-existing C80 certificates are the independent domain
replay gates. The prefix source spelling of the `{0,6}` shape lowers client-side
and reproduces the same exact 70,888/70,888 grouped result.

## Token and evidence economics

The live C80 session required short summaries rather than raw rows:

- 111 syntactic candidates collapsed to 8 output classes in the aggregate
  experiment;
- 192 mixed-label candidates collapsed to 24 classes;
- each decisive obstruction was one bounded row;
- one rigid equality profile was selected with multiplicity 234 and traced in
  five VM records / 456 bytes;
- the complete 70,888-row corpus stayed file-backed.

This is already substantially more token-efficient than repeated ad hoc script
edits and transcript inspection. The controller can run batch/evolve/synthesis
unattended and an agent reconnects at a feature collision, first obstruction,
new best class, or exhausted gate.

## Debt-ledger boundary

Debt coordinates fit as typed domain features, not controller prose. A live
adapter should update compact thread-local debt state and expose only bounded
safe-point summaries. `exceptional` ranks top-K debt/rigidity states; `trace`
opens one exact row. The C80 overload/Tutte bank is retained as a hostile
lesson: filtered deficiency two was recursive certificate debt, not game debt.
All v0 plan roles are diagnostic or ordering, preventing such a coordinate
from silently becoming a proof-authoritative prune.

## Root-aware steering and online probation

The alignment adapter now publishes persistent current-root identity,
canonical stabilizer orbit, ordinal/total progress, per-root state and failure
counts, three initial structural sizing proxies, and active/completed root
masks. These are copied from already-computed summaries; the search does not
repeat a theorem merely to report it. The shared heartbeat is cacheline aligned,
while serialization remains in the watcher.

Plans may carry a categorical `scope` bitmask over `root_candidate` or
`root_orbit`. Scope rejection occurs before both VM evaluation and optional
child-summary construction. On the deterministic budget-12 diagnostic:

- baseline was 7.99 seconds / 308,653 states;
- controlled with no plan was 8.07 seconds / the same tree;
- an excluded scope was 8.00--8.04 seconds and 91.7 billion instructions;
- the unscoped residual score was 18.69--18.76 seconds, 308,280 states, and
  220.9 billion instructions;
- a genuinely visited orbit-11 scope was 10.40 seconds / 308,499 states.

Thus scoping removed 58.5% of the unscoped instruction count when excluded and
made a live narrow policy 1.80x faster than evaluating it globally. The
remaining cost is theorem-feature work within the selected root, not the VM or
control gate.

Publishing changed progress to the controller once per second remains off the
search path: its counter run used 91,664,705,534 instructions and 39,994,337,048
cycles versus 91,665,154,806 instructions and 39,923,857,118 cycles without
periodic publication. The instruction delta is -0.00049% and the cycle delta
+0.176%, well below a one-run scheduling claim; the exact tree is identical.

`ergodisctl probation` now makes a reversible active/inactive comparison. The
budget-13 adverse ordering plan ran at 31,000 states/s active and 67,000
states/s inactive; the controller rolled it back automatically (2.161x). State
rates are accepted only across the same root candidate and initial structural
tuple. Cross-root windows use completed-root throughput only when both have a
nonzero rate; otherwise the plan is restored as inconclusive.

## Scope-aware candidate generation

Scope is a separate part of the current predicate evolutionary genome. The controller returns a
bounded 64-bin profile for categorical fields; `evolve` proposes singleton
masks, the positive-majority frozen union, and one-bit mask mutations before
ordinary expression mutations. Scope participates in structural deduplication.
Instrumented watcher snapshots also accumulate live-only root values in the
controller. In the integration replay, the frozen fixture exposed orbit values
0 and 6, while the solve exposed 1 and 11; the second evolution run emitted all
four without a solver rebuild (34 tested candidates versus 30 from the frozen
batch alone).

This deliberately separates two fitness functions. Frozen labels rank theorem
predicates. Root-scoped ordering candidates are proposals for same-stratum
online probation; an offline classification loss must not suppress a runtime
speedup. The next controller abstraction is therefore a precompiled
root-to-plan dispatch table with held-out probation evidence, not a single
global ordering plan.

## Classical algorithmic imports

The staged decision, shadow-probe design, persistence boundary, import order,
and source-by-source read depths are owned by
[the adaptive-search learning ADR](2026-08-30-c985-ergodis-adaptive-search-learning-adr.md).
This spike report relies on that audited record rather than duplicating its
source characterisations.

## Next gates

1. Construct or import q17 `K_Omega` survivor states, then replay the `{0,6}`
   rule and extract its first mismatch if any; unguided random states do not
   reach the relevant stratum at useful density.
2. Compile accepted scoped policies into an O(1) root-to-plan dispatch table,
   then run held-out same-stratum probation before promotion. In parallel,
   derive a cheaper equivalent child accumulator and require an actual state
   reduction in interleaved multiround A/B.
3. Persist controller checkpoints so restart preserves the last validated
   epoch and active plan hashes.
4. Split transport and ledger modules after the next surface change, not before
   it earns the boundary.
5. Add proof handles and hostile-corpus gates before any necessary/sufficient
   role exists.

## Mystery ledger (`ej` + `tt` closeout)

- **Settled:** the injected residual-packing theorem's initial 3.9x slowdown
  was mostly repeated work, not socket contention. Compute-once frame ordering
  repairs that slice by 2.16x without allocation or feature-off storage.
- **Settled:** global theorem-feature evaluation was the next repeated-work
  pathology. Root scope rejects before feature construction, cutting the
  excluded case from 220.9 to 91.7 billion instructions and making cost track
  the selected observational region.
- **Settled:** root-specific candidate generation need not know every stratum
  at compile time. Optional watcher observations extend the frozen categorical
  profile, and mask mutations enter the same bounded evolve ledger.
- **Settled:** canonical root labels are not an accidental numbering artifact.
  A regression checks all 720 compiled point-stabilizer actions and every one
  of the 56 candidates, requiring the representative label to remain constant
  on each orbit.
- **Open:** multiple simultaneously active policies still require a compiled
  root-to-plan dispatch table and parallel worker-slot aggregation. The present
  single-thread adapter publishes one active root in a `u64`; the successor
  must preserve cacheline isolation and avoid policy scans.
- **Open:** current `evolve` ranks predicate programs against frozen labels;
  ordering-policy generation can emit scoped shapes but still needs the paired
  operational race from the adaptive-search ADR before it may promote them.
- **Open:** semantic/performance persistence is specified but not yet landed.
  The ADR's first implementation gate is a checksummed reliability/probation
  WAL with build/hardware-conditioned reload; it owns this gap.
- **Open:** exact child packing barely changes the C880 state count. The next
  discriminator is whether quotient-refinement gain or cheap cut-coverage is a
  better ordering observable than lower-bound strength; this belongs to the
  measured C880 successor, not more syntax.
- **Open:** the exact sampled C80 rank-sector law `{0,6}` has no q17 evidence.
  Unguided sampling missed the survivor stratum entirely; a targeted q17
  constructor/import is the evidence gate.
- **Settled:** exponential polling backoff missed late theorem submissions, so
  it was replaced rather than tuned. Semantic epoch changes now push one Unix
  datagram to a blocking watcher; ordinary/noop requests emit none. A
  cacheline-isolated flag is checked at the shared 4096-state control deadline.
  The watcher prepares the next arena and the search only swaps preallocated
  storage. This settles simultaneous responsiveness, zero idle wakeups, and
  zero search-path serialization/allocation for the current adapter.
- **Opportunity:** because source plans stay in a quantifier-free SMT-LIB-like
  fragment, the same candidate can later be emitted to an SMT backend for
  bounded symbolic counterexample search. This is a successor capability, not
  evidence for any current theorem.

## Vibe

The spike crossed the line from dashboard design to a useful theorem-search
instrument. Its strongest output is not the socket; it is the fast loop from a
160-row obstruction class to a perfect 11-operation sampled law, with exact
mixed-field replay and essentially no conversational data exhaust.
