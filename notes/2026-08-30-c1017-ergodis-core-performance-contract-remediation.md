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
boundary.

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
