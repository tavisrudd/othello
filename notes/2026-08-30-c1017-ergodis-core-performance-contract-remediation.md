# C1017 Ergodis core performance-contract remediation

**Lane:** `complete-ports`

**Status:** ACTIVE

## 2026-08-30 progress

The original source audit is a historical baseline. Since it was written, a
thread-local counting-allocator harness has landed and the rejected GS/proof
overlay has been removed from public core. The remaining recursive,
contention, workspace-ownership, layout, and registry findings are still live
unless closed below.

The first production repair replaces the recursive QC trapping/stopping-set
DFS with a presized iterative depth machine. Selection and frame capacity are
fixed before enumeration; accepted witnesses no longer clone a vector in the
terminal loop. Small QC codes are differentially checked against exhaustive
subset enumeration, including stopping semantics and the exact zero-budget
boundary. A crate-wide test-only counting allocator now brackets the actual
iterative region through a thread-local guard; a nontrivial QC search records
zero allocation, reallocation, and deallocation. This instrumentation is not
compiled into production. The same harness retains the existing cross-thread
zero-event proof for the compact and wide CSS Rayon partition loops.

Retained-binary A/B on `application:qc:rust:13:6:1`, 1,000 solves per round,
six interleaved order-reversed pairs, preserved the exact 106,260 candidates
per solve and negative verdict. Mean time fell from 1.656122 s to 1.515367 s
(`1.0929x`, paired `t=12.991`, 5 df). One diagnostic counter pair measured
7.893B to 7.284B cycles, 37.042B to 37.412B instructions, 5.974B to 7.481B
branches, 20.013M to 19.844M branch misses, and 2,640 to 2,368 KiB peak RSS.
The iterative traversal trades more predictable branches for less recursive
control overhead and stack traffic; it does not reduce theorem work.

The coordinate/correlated ternary-orbit solver now uses only its iterative
production traversal at every depth. Its current frame stays in a local
register record and the presized array stores parents only. The dead-state memo
is sized before traversal from the exact prefix-tree upper bound subject to an
8 MiB structural budget; once full it stops admitting records rather than
growing. Results expose memo occupancy and saturation because saturation can
add work but cannot alter exactness. Tests cover a 50,000-family product and a
forced-capacity memo with stable backing pointers.

On `orbit-grid:rust:14:3:12:12345`, four interleaved order-reversed pairs of
500 solves preserved 206,356 states and the witness per solve. Mean time fell
from 3.251467 s to 3.155416 s (`1.0304x`, paired `t=8.710`, 3 df). A diagnostic
counter pair measured 15.210B to 14.056B cycles, 66.472B to 68.344B
instructions, 7.752B to 7.683B branches, 74.065M to 50.682M branch misses,
and 9,116 to 8,156 KiB peak RSS. The explicit traversal executes 2.8% more
instructions but removes enough call-stack and unpredictable-return cost to
win overall.

The test-only allocator boundary now encloses `Search::run` itself. A fully
exhausted correlated-residue instance exercises choice push/pop, iterative
frames, and dead-memo insertion with exactly zero allocation, reallocation,
or deallocation. The complete records read or written in that loop
(`PackedOptionRecord`, `FamilyRecord`, `ResidueRecord`, `DeadRecord`, and
`SearchFrame`) have explicit C representation plus exact compile-time size and
alignment assertions.

The meet-in-the-middle right enumeration and left lookup are now iterative
odometers as well. The public reserved backend computes the exact right-product
bound before enumeration, reserves every table/choice/key buffer once, and
rejects requests whose conservative table estimate exceeds 256 MiB rather
than growing toward OOM. The deliberately unreserved hidden benchmark remains
as a negative control. On `orbit-meet`, six interleaved pairs of 100,000 solves
preserved 486 assignments and 243 unique right states per solve while reducing
mean time from 1.010449 s to 952.919 ms (`1.0604x`, paired `t=4.198`, 5 df).
One counter pair moved from 4.750B to 4.526B cycles and 26.932B to 25.454B
instructions. All production orbit search/enumeration paths are now iterative;
bounded correlated-suffix compilation remains a cold allocating compiler.

## Goal

Bring every reusable public Ergodis solve kernel into compliance with the
private performance contract, and move all domain-specific, task-specific,
experimental, or otherwise non-reusable work to `ergodis-private/`.

The source audit is
`notes/2026-08-30-c985-ergodis-core-performance-contract-audit.md`. It covers
all 56 Rust files and identifies definite allocation, recursion, contention,
layout, evidence, and publication-boundary failures.

## Acceptance gates

1. A test-only thread-local allocator guard proves zero allocation,
   reallocation, and deallocation after every public solve kernel enters its
   hot loop.
2. Search-tree and decision-diagram traversal is iterative with a presized,
   bounded workspace; no recursive production solve path remains.
3. Every hot state, frame, transition, mailbox, and worker result has an
   explicit Tiger representation and compile-time size/alignment assertions.
4. Search workers share immutable state only. There are no worker-to-worker
   writes, contended atomics, shared queues, allocator traffic, or false-shared
   mutable fields during solve.
5. Every affected kernel passes exact old/new verdict, witness, certificate,
   and work-count checks in one-thread and parallel modes.
6. Every hot-loop change has an interleaved retained-binary A/B with
   instructions, cycles, branches, branch misses, relevant cache events, wall
   time, and peak RSS in both one-thread and parallel modes.
7. `alignment`, fixed-field research front ends, private theorem schemas, C-ID
   fixtures, and other non-reusable adapters live only in `ergodis-private/`.
8. One guarded registry command checks allocation, layout, correctness,
   single/parallel parity, counter evidence, and contention coverage for every
   registered solve kernel.

## Ordered work packages

1. Add the allocation guard and machine-readable kernel/evidence registry.
2. Move private adapters and fixtures before changing their implementation.
3. Replace recursive/growing ZDD, application, orbit, sparse-scheduler, and
   ordered-resource solve paths.
4. Replace CSS worker broadcast with contention-free publication, make
   workspaces worker-owned, and split pulse/no-pulse kernels outside the loop.
5. Close the remaining Tiger layout and recursive cold-replay findings.
6. Run the full correctness, allocation, counter, memory, and parallel gates;
   retain negative controls and close the task only with independently checked
   evidence.

## Concrete source-audit findings

The remediation must close these observed failures rather than treating the
acceptance gates as prospective guidance:

- No allocator instrumentation currently proves that any public solve loop is
  allocation-free. Recursive or growing production paths remain in the
  application, balanced, orbit, ZDD, sparse-scheduler, and ordered-resource
  solvers.
- CSS workers publish bounds with worker-to-worker `fetch_min` traffic, allocate
  per-task workspaces, and retain a run-constant pulse branch inside the search
  loop. These require worker-owned storage and a no-pulse kernel selected before
  entry, followed by single-thread and parallel counter A/Bs.
- Hot layout holes include `alignment::SearchFrame`, the CSS wide-branch frame,
  `SeparatorSearchNode`, `SparseTerm`, and root-branch records. Some padded CSS
  records assert alignment without asserting the complete size contract.
- `alignment`, fixed-GF(27), defect-q27, Hadamard/GS, control/proof GS schemas,
  and C-ID fixtures are domain- or campaign-specific and currently cross the
  public-core boundary.
- There is no systematic retained-binary registry covering allocator events,
  perf counters, false sharing/contention, and one-thread/parallel semantic
  parity for all public solve kernels.

## CSS controller fan-out pattern

The reusable decision and its acceptance/rollback gate are recorded in
`2026-08-31-ergodis-controller-bound-fanout-adr.md`.

The prior CSS bound broadcast violates worker ownership: an improving worker
executes `fetch_min` on every worker mailbox. The replacement uses separate
cache-line-isolated publication and inbox lines:

1. worker `i` is the sole writer of publication `i`;
2. a blocking controller reduces publications and is the sole inbox writer;
3. per-worker eventfds wake it without a shared worker-write line;
4. a ready handshake prevents search from outrunning controller startup;
5. the candidate stride checks one relaxed local Boolean;
6. an unchanged Boolean returns without loading the payload; and
7. stale or coalesced fan-out only adds work.

The controller restores the process leader's allowed CPU mask because a helper
spawned inside `ThreadPool::install` otherwise inherits one pinned worker's
affinity. It blocks in the kernel between publications and never spins.

The generic root executor now brackets only the client hot callback—not pool
creation, worker construction, or reduction—with the shared test allocator
guard. Serial and three-worker Rayon execution both record zero events across
all callback threads. The executor's only owned hot value, `RootOrdinal`, is a
transparent four-byte scalar with exact alignment assertions; concrete worker
and output layouts remain the responsibility of their kernel registry rows.

Do not probe at root boundaries or scan all slots from workers. The all-slot
control added 5.37% instructions without reducing cycles. Flag-gated rings at
256--4,096 candidates lost or tied because multi-hop latency admitted
speculative work. A no-fanout control was 5.6x slower on BB288, so abandoning
mid-search propagation is not competitive.

The retained controller now has separate multiversioned pulse/no-pulse entry
points. A failed event setup or one-thread solve selects the no-pulse
monomorphization before enumeration; it contains no pulse flag, atomic load,
or observed epoch. The pulsed kernel tags the last-seen Boolean in the high bit
of its existing worker-local pulse counter and strips that bit before merge,
avoiding a live hot-loop variable or third mailbox line. `BoundMailbox` remains
256 bytes at alignment 128: one 128-byte worker publication line and one
128-byte controller-owned inbox line. Strict improvements and pulse checks are
the only cold paths; the candidate loop remains iterative.

The final retained-binary counter gate uses original direct-broadcast binary
SHA-256 `3431259a7654c531ad56b899225010be98d02c057352c8ab8db8da4c4ffb54fb`
and controller binary SHA-256
`47b2821b9db0b466c81095d5d1ca6ef97a2719bd804d7f04328419df13f6b156`.
On the 12-thread BB360 radius-20 clean miss, three interleaved pairs preserve
exactly 2,828,836,878 candidates. Control/candidate geometric-mean ratios are
0.991816 wall (`t=-4.017`), 0.995037 cycles/candidate (`t=-1.746`), 1.022480
instructions/candidate, 1.029464 branches/candidate, 1.013885 branch
misses/candidate, and 0.997673 cache misses/candidate. Thus the ownership-safe
controller costs 0.50% cycles/candidate and 0.82% wall while removing 2.20% of
instructions, 2.86% of branches, and 1.37% of branch misses. Separate peak RSS
is 11,504 versus 11,572 KiB (+68 KiB).

On the 12-thread BB288 radius-18 incumbent hit, five interleaved pairs of 20
solves give control/candidate ratios 0.992417 wall (`t=-0.926`), 0.983443
candidates (`t=-3.113`), 0.999489 cycles/candidate, 1.011560
instructions/candidate, and 1.032460 branches/candidate. Controller wake
latency admits 1.68% more speculative candidates, but per-candidate cycles are
flat and wall is statistically unresolved. A ready-gated trace measures about
47 microseconds from eventfd write to controller read. Rotated 512--16,384
stride screens retain 4,096 as the optimum. The user accepted this measured
sub-1% clean-miss trade for sole ownership and contention freedom. Per-task
workspace allocation and its zero-allocation regression remain open under work
package 4; this controller result does not close C1017.

The first workspace-ownership slice now constructs every wide-lane and compact
worker workspace plus every padded result slot before the controller releases
enumeration. Rayon tasks receive exclusive mutable slots and return by writing
those slots; no workspace or result vector is allocated inside the parallel
enumerator. Retaining the existing 16-lane-per-thread schedule is essential:
the seemingly cleaner one-lane-per-thread control preserved exact work and
reduced total cycles, but static imbalance made BB288 wall time 25.2% worse
(`t=-25.312`). With 16 preallocated lanes, five BB288 counter pairs improve
wall 1.014492x and cycles/candidate 1.011486x, but three deterministic BB360
clean-miss pairs regress wall 2.20% and cycles/candidate 2.15%; flattening the
borrowed workspaces to direct slices worsens cycles by another 4.2% and is
rejected. The preallocation boundary is retained as correctness-contract
progress, but its cross-thread allocation-count harness and the clean-miss
codegen repair remain open; this is a checkpoint, not completion of work
package 4.

The cross-thread gate is now closed. A test-only global allocator uses a
thread-local enable bit entered immediately around each compact and wide Rayon
partition kernel, so setup, result assembly, and unrelated concurrent tests do
not contaminate the measurement. The dedicated three-worker regression counts
allocation, reallocation, and deallocation across all participating workers
and observes `(0, 0, 0)`. The guard and allocator are absent from production
builds. The remaining package-4 blocker is the retained-controller clean-miss
codegen regression and its single-/parallel-mode counter evidence.

That codegen blocker is now closed by changing the pre-sized wide frame stack
from `Vec<WideBranchFrame>` to `Box<[WideBranchFrame]>`. The stack cannot grow,
so the vector capacity word was both semantically misleading and unnecessary;
the boxed slice retains contiguous bounds-checked indexing and the cross-thread
allocation gate still observes `(0, 0, 0)`. Against retained Rust 1.91.1
binaries `e1981022...` (control) and `c30cd001...` (candidate), three rotated
counter pairs give:

- BB360 12T clean miss, exactly 2,828,836,878 candidates in every run:
  control/candidate 1.031389 instructions (`t=77996.4`), 1.018017 cycles
  (`t=10.149`), and 1.012854 branch misses (`t=6.425`). Branches increase
  0.336%; cache misses are noisy and unresolved.
- BB288 1T theorem hit, exact candidate parity: 1.090023 instructions,
  1.023990 cycles (`t=15.269`), with identical distance-18 witness.
- BB288 12T theorem hit, asynchronous bound arrival changes aggregate work by
  0.039%; after candidate normalization, instructions/candidate improve 2.88%
  and cycles/candidate improve 3.88%, with identical distance-18 witness.

Wall timing is deliberately not used for this decision because the host was
shared during the run. Two alternatives are retained as negative evidence:
moving an owned workspace through the wrapper added about 2.1% instructions,
and storing run configuration in the workspace added about 0.6% instructions.
Neither survives in the source.

The concrete Tiger-layout holes from the original audit are now mechanically
closed. `SearchFrame`, `SparseTerm`, `SeparatorSearchNode`, compact and wide
root branches, every supported wide frame specialization, both padded result
families, and `ConnectedSearchStats` have explicit C/transparent layouts with
compile-time size and alignment assertions. The assertions cover all five
supported wide CSS widths, including the 1,008-byte colossal frame and the
128/256/384-byte padded result strides. Against the boxed-workspace binary,
three exact-work BB360 12T pairs are instruction- and branch-neutral to one
part per million (cycles unresolved at 1.003862, `t=1.704`); three BB288 1T
pairs are likewise instruction- and branch-neutral. Cache-event variation on
the shared host is inconsistent between the 1T and 12T controls and does not
coincide with a cycle regression.

The registry gate now has an executable private first tranche at
`ergodis-private/performance/kernel-registry-v1.json`. Eleven principal public
kernels carry all six required dimensions: allocation, layout, correctness,
single-thread counters, parallel counters, and contention. The companion
checker validates unique IDs, complete dimensions, source paths, evidence
paths, and reasons for every open/not-applicable gate. Its default invocation
fails while any required gate is open; `--allow-open` prints the bounded
remediation list. The initial census reports 30 passing, 22 open, and 14
not-applicable cells. This is infrastructure progress, not C1017 closure: the
census must expand and the 22 open cells must be repaired or justified.

## Review findings for the pending C1016 Rust overlay

The 2026-08-30 overlay in `ergodis/src` is **not approved as submitted**. Its
generic ideas may be retained only after the following blockers are resolved:

1. **Necessary-pruning authority is not semantically bound.**
   `CompiledPlan::compile_authorized` verifies a presentation-hash string,
   theorem metadata, a field name, and the predicate program shape. It does not
   prove that the named feature column was produced by the theorem's verified
   extractor. A miswired or adversarial producer can label arbitrary data
   `character_energy_q2` or `multiplier_profile_admissible` and obtain
   `PlanRole::Necessary` pruning. Consequently the advertised
   `"proof_authority": true` capability is unsound. Bind authority to a typed,
   sealed extractor/presentation implementation (or an equivalently verified
   semantic commitment), and retain negative tests that substitute a field
   with the right name and wrong values.
2. **The overlay violates the public/private boundary.**
   `control/proof.rs` publishes bordered-GS theorem schemas, and `hadamard.rs`
   publishes GS-specific compilers from the reusable crate. The GS schemas,
   adapters, fixtures, and campaign claims belong in `ergodis-private/`. A
   generic necessary-predicate mechanism belongs in core only if it exposes no
   private domain vocabulary and satisfies the semantic-authority gate above.
3. **The character compression contract is false as documented.**
   `BorderedGsCharacterSector::energy` says a coefficient vector may be an
   arbitrary compression provided its length retains the character order.
   Character energy is preserved only by a specified residue-class-preserving
   aggregation (or another proved intertwining map); length divisibility alone
   is insufficient. Require and verify the compression map/certificate, or
   restrict the API to uncompressed coefficients.
4. **Several supported input ranges are arithmetically unsound.**
   `multiplier_character_fixed_field_degree` accepts character order one but its
   multiplicative-order loop cannot terminate normally for that case;
   `count_bordered_order_two_profile_domain` reaches an unchecked `u16` cast for
   carriers above `u16::MAX`; order-three profile compilation truncates an
   `i64` target to `u32` and performs unchecked `u32` sums; and `euler_phi` uses
   `prime * prime` in its loop condition. Reject unsupported ranges explicitly
   or use checked/wider arithmetic throughout, with boundary tests.
5. **Tests are fixtures and self-consistency checks, not independent theorem
   oracles.** The current M522/H2060 assertions can preserve an implementation's
   shared mistake. Add small exhaustive direct-action/direct-character-sum
   oracles, malformed semantic-binding controls, arithmetic boundary cases, and
   randomized differential tests before accepting exact or proof-authority
   claims.

Approval requires splitting the reusable mechanism from the private GS
application, repairing the authority and arithmetic contracts, and passing the
acceptance gates above. Until then, do not commit the coupled Rust overlay as a
public Ergodis change.

## Boundaries

- Preserve exact semantics and replayable witnesses.
- No performance claim is accepted from source inspection or wall time alone.
- No private contributor document, adapter, fixture, task identifier, or
  research process enters a public export.
- Remediation changes remain private until the separate publication boundary
  is deliberately reopened.
