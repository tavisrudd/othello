# C1062 core defects: the multiway refiner miscompiled, and what the exhaustive pair audit costs

**Lane**: `complete-ports`
**Task**: C1062 follow-up feeding C1017 (core performance-contract audit); reproduction, diagnosis
and repair of the two core defects the spike recorded and did not own.
**Plan**: `2026-09-04-c1062-closeout-synthesis.md` section 7, and the policy table in
`2026-09-04-c1062-probe2-best-intervention-and-economics.md`.
**Inputs**: the six-row policy table from probe 2; `ergodis/src/observational.rs`
(`CertificatePolicy`, `compile_observational_internal`, `multiway_admission`,
`minimize_partition_multiway_prepared`, `verify_compilation`, `build_separators`); the caller
`ergodis-private/src/causal.rs` (`CausalModel::lower`, `CausalLowering::compile`) and the family
definitions in `ergodis-private/tasks/tools/src/best_intervention_report.rs`.
**Code commit**: `ergodis` `6cc9668` (refiner repair, cross-policy gate, linear-space audit
verifier), on top of `9a02921`; `ergodis-private` one commit after `04adbc8` (report tool names the
error). Measurements before the repair were taken at `ergodis` `9a02921`.
**Replay**: `cd ~/src/ergodis && cargo test --all-features --lib -- observational::tests::multiway_refiner_requeues observational::tests::every_certificate_policy observational::tests::pair_audit_verifier`
for the regression and the gate; `cd ~/src/ergodis-private && cargo run --release --package ergodis-tools -- best-intervention-report --rounds 1 --workloads 256`
for the six-row policy table; `cargo run --release --package ergodis-tools -- causal-lowering-report`
for the spike's oracle table. Defect-two A/B: section 5. `rustc 1.93.1`, release profile,
`choom -n 1000`, single thread.
**Verdict**: **Defect one was a core bug, and it is repaired.** The multiway refiner marked the
predecessors of a freshly split block dirty while reading that block's members from the array the
marking reorders; whenever a new block contained its own predecessors — which every generator from
a sort into itself produces, and every causal re-pin generator is one — some members were visited
twice and others never, the never-visited members' predecessors kept stale signatures, and the
refiner stopped on a partition that was not a congruence. Three of the five policies route into
that refiner (`MultiwayTranscript` directly; `QuotientOnly` and `AdaptiveTranscript` once the
admission gate of at least 4,096 states and at most two observations per sort admits it), which is
exactly the failing set and the threshold that tracked "neither sorts nor states". The immediate
verifier caught it (`GeneratorMismatch`), so the "fails closed" wording holds for
`compile_observational_with_policy`; it did **not** hold for
`compile_observational_with_deferred_verification`, which handed back the wrong partition. All
five policies now agree on every probe-2 family, on 200,000 random presentations, and on a core
gate that will catch a future divergence. **Defect two is inherent in the retained form and was
also partly implementation:** the pair audit is quadratic in the sort sizes by definition
(7,880,704 records on the 33,024-state timing family), which is where the memory goes and what the
core's existing streaming entry points are for; but its verifier retained a hash set of every pair
and its builder grew the record pool by doubling. Both are removed: verification is 4.2x faster and
the audited compile's peak memory halves, with the accepted certificates unchanged. The audit
remains an audit mode, now documented as such on the policy itself.

## 1. Reproduction of defect one

Harness: a scratch crate (not committed) depending on `ergodis` and `ergodis-private` by path,
rebuilding the seven probe-2 families from `families()` in
`ergodis-private/tasks/tools/src/best_intervention_report.rs`, lowering each with
`CausalModel::lower(1 << 22)`, and compiling the presentation under all five policies with
`compile_observational_with_policy`. On error the same presentation is recompiled with
`compile_observational_with_deferred_verification` to see the partition the refiner actually
produced; that partition is compared with the `SplitTranscript` partition (block relabelling
allowed) and re-verified with `verify_compilation`.

Core `9a02921`, private `04adbc8`.

| family | sorts | states | quotient | split | multiway | adaptive | audit |
|---|---|---|---|---|---|---|---|
| `reliability-3of8`      | 37 | 33,024 | `GeneratorMismatch{g144,c1731}` | 1,468 | same error | same error | 1,468 |
| `weighted-threshold-8`  | 37 | 33,024 | `GeneratorMismatch{g106,c350}`  |   392 | same error | same error |   392 |
| `distractor`            |  7 |    608 |  56 |  56 |  56 |  56 |  56 |
| `identity`              |  7 |    540 | 126 | 126 | 126 | 126 | 126 |
| `wide-conjunction`      | 16 |  1,632 | 122 | 122 | `GeneratorMismatch{g60,c99}` | 122 | 122 |
| `restricted-vocabulary` |  7 |  4,864 | `GeneratorMismatch{g6,c36}` | 120 | same error | same error | 120 |
| `deep-pipeline`         | 37 | 33,024 |  74 |  74 |  74 |  74 |  74 |

This matches probe 2 row for row; `deep-pipeline` (the timing family) was not in probe 2's table
and passes every policy.

What "fails" means, exactly:

- The error is always `ObservationalError::GeneratorMismatch { generator, class }`, raised by
  `verify_compilation_with_inverse` when one generator sends two states of one compiled class to
  different compiled classes. Not a panic, not a hang; raised in about the time of a successful
  compile (1.5 to 3 ms on 33,024 states).
- The partition behind the error is **wrong, not merely unproven**. Under deferred verification
  `MultiwayTranscript` returns 2,914 classes on `reliability-3of8` where the quotient has 1,468;
  879 against 392 on `weighted-threshold-8`; 154 against 122 on `wide-conjunction`; 235 against
  120 on `restricted-vocabulary`. None agrees with the split-transcript partition and each fails
  `verify_compilation` with the same `GeneratorMismatch`.
- "Fails closed" is therefore true for `compile_observational_with_policy` and false for
  `compile_observational_with_deferred_verification`, whose contract is that the caller verifies at
  a trust boundary. A caller that skipped that step would have used a wrong quotient. The recorded
  wording was right about the public entry point and silent about the deferred one.
- `QuotientOnly` and `AdaptiveTranscript` were not independently broken: both call
  `multiway_admission`, which selects the multiway refiner when the presentation has at least
  4,096 states and at most two distinct observations per sort, and the split transcript otherwise.
  Every quotient/adaptive failure is a row where multiway is admitted (`restricted-vocabulary` at
  4,864 states is admitted; `wide-conjunction` at 1,632 is not, so only the explicit multiway
  policy fails there; `distractor` and `identity` sit below the gate). That is the threshold probe
  3 saw and probe 2 could not place: the admission gate's state count, combined with a refiner bug
  that only some shapes trigger.

## 2. Mechanism, reduced to six states

Differential fuzzing (random presentations, 1 to 3 sorts, up to 6 states per sort, up to 9
generators, observations in {0,1}; multiway partition against the synchronous reference refiner
behind `ExhaustivePairAudit`) found 27 to 30 disagreements per 40,000 draws and reduced to one
sort of six states with one generator:

```text
observations  [1, 1, 1, 0, 0, 1]
generator f   0->4  1->3  2->2  3->5  4->0  5->2
correct       {0} {1} {2,5} {3} {4}          (5 classes)
multiway      {0,1} {2,5} {3,4}              (3 classes, not a congruence: f(3), f(4) differ)
```

Trace. Blocks start as `{0,1,2,5}` (observation 1) and `{3,4}` (observation 0). `{3,4}` is
refined first and found uniform. `{0,1,2,5}` splits by target block into `{0,1}` (kept id) and a
new block `{2,5}`. The refiner then marks predecessors of the new block's members dirty:

```rust
for position in new_range.start..new_range.end() {
    let target_state = members[position as usize];
    for &source_state in inverse.predecessors(target_state) {
        // ... members.swap(source_position, new_mid) moves source_state to the
        // dirty end of *its own* block, which here is the new block being read
```

`f⁻¹(2) = {2, 5}`: marking 2 and 5 dirty swaps them inside `{2,5}`'s own range, so position 3
now holds state 2 again. State 2 is visited twice and state 5 never; `f⁻¹(5) = {3}` is never
marked; `{3,4}` is never re-queued; the loop ends on an unstable partition. Only one
`MultiwayRecord` is emitted where three are needed.

The same defect explains the *finer* wrong partitions on the large families (2,914 against 1,468),
which a missed dirty mark alone could not produce. The refiner's invariant is that the clean
members of a block all share the signature of one clean representative, so it re-groups only the
dirty members plus that representative and folds the clean prefix into the representative's
group. Once a member's signature has changed without it being marked dirty, that fold puts it in
the representative's group while a dirty member with its true signature lands elsewhere: two
states the coarsest congruence keeps together are separated by bookkeeping, not by signature.
Fuzzing with the fix reverted and larger sorts (up to 40 or 80 states) shows exactly these
"finer and not coarser" cases; with the fix they vanish.

The split-transcript worklist collects marked sources into a list first and moves them afterwards,
which is why it never had the bug. `deep-pipeline` is admitted to multiway and passes because its
quotient is the observation partition itself (two classes in each of 37 sorts, 74 total), so no
split ever produces a self-referencing new block.

## 3. Repair and regression, in the core

`ergodis` `6cc9668`, `src/observational.rs`:

- `minimize_partition_multiway_prepared`: after the placement pass, copy the split block's
  members into `refiner_scratch` and enumerate each new block's range from that snapshot. Marking
  only permutes members inside their own block, so a new block's range names the same states in
  the snapshot; the swaps no longer perturb the enumeration. One `u32` copy per refined block,
  bounded by the placement pass that precedes it.
- `multiway_refiner_requeues_predecessors_of_self_referencing_new_blocks`: the six-state trigger
  above and a second reduced case; asserts the exact classes, three multiway records, and
  agreement of all five policies. Confirmed to fail on the unrepaired refiner.
- `every_certificate_policy_computes_the_same_quotient` — the cross-policy gate. A deterministic
  family of presentations (48 pseudo-random multi-sort shapes with self-referencing and cross-sort
  generators, eight of them with alphabets wide enough to engage the refinement-generator
  directory; a "pinned coordinate" presentation of bit vectors with one overridden coordinate,
  4,352 states, which is the causal re-pin shape in domain-neutral terms and is admitted to
  multiway, so `QuotientOnly` and `AdaptiveTranscript` route through the repaired refiner; and a
  large pseudo-random shape) is compiled under all five policies and under the deferred entry
  point, requiring identical `state_classes`, `class_ranges`, `class_outputs` and class
  transitions against the pair-audited quotient, and a clean `verify_compilation` on every
  deferred artifact. Exact equality, not agreement up to relabelling, because every refiner ends in
  the same canonicalisation.
- `pair_audit_verifier_accepts_permuted_records_and_rejects_gaps`: the two verifier paths of
  section 5 accept the same certificates (permuted order still verifies; a dropped record fails
  with `MissingSeparator` naming the pair; a duplicate fails).

The three tests take about 14 s; the core `cargo test --all-features` passes in full (650 library
tests plus the integration suites), `cargo fmt --check` and
`cargo clippy --all-targets --all-features -- -D warnings` are clean.

Fuzz confirmation with the repair: 0 disagreements in 40,000 draws at each of three small shapes,
40,000 at sorts up to 40 states with three observation values, 20,000 at sorts up to 80 states.

The fix is in the core, not the caller: the lowering's presentation satisfies every documented
precondition (its own range check passes, and two independent policies plus the signature oracle
agreed all along). No precondition needed stating.

After the repair, all five policies agree on every family:

| family | sorts | states | quotient | split | multiway | adaptive | audit |
|---|---|---|---|---|---|---|---|
| `reliability-3of8`      | 37 | 33,024 | 1,468 | 1,468 | 1,468 | 1,468 | 1,468 |
| `weighted-threshold-8`  | 37 | 33,024 |   392 |   392 |   392 |   392 |   392 |
| `distractor`            |  7 |    608 |    56 |    56 |    56 |    56 |    56 |
| `identity`              |  7 |    540 |   126 |   126 |   126 |   126 |   126 |
| `wide-conjunction`      | 16 |  1,632 |   122 |   122 |   122 |   122 |   122 |
| `restricted-vocabulary` |  7 |  4,864 |   120 |   120 |   120 |   120 |   120 |

(`best-intervention-report --rounds 1 --workloads 256` on the repaired core; the tool now prints
the error variant instead of the word `error` so a future regression is legible.)

## 4. Defect two: where the 846x goes

Measured on the repaired core before the audit changes, `deep-pipeline` (33,024 states, 37
sorts, 74 classes) in isolation:

| step | ms | notes |
|---|---|---|
| split transcript, compile + verify | 1.23 | the quotient |
| audit build without verification | 238 | 7,880,704 separator records, 0 path steps, 189 MB of records |
| audit verification alone | 865 | replays each record, then a hash set of every certified pair against every separated pair |
| audit compile + verify | 1,045 | |
| quotient-only compile + `stream_exhaustive_separators` to a counting sink | 144 | same 7,880,704 records, nothing retained |
| peak RSS delta for the audited compile | 590 MB | |

`reliability-3of8` (33,024 states, 1,468 classes): build 866 ms for 8,933,162 records with
6,347,812 path steps (240 MB), verify 997 ms, total 1,868 ms, peak delta 690 MB.

So the cost splits three ways. (1) The record count: one record per separated same-sort pair,
which is `Σ_sorts C(n_s, 2)` minus same-class pairs — 239 records per state here, 24 bytes each.
This is the definition of the exhaustive pair certificate and is what the memory is: at 205,056
states with the same sort structure the count scales by `(205,056 / 33,024)² ≈ 38.6` to about
3.0 × 10⁸ records, or 7.3 GB of records alone, which is the recorded 6.9 GB. Nothing short of not
retaining the records changes that, and the core already has the non-retaining form
(`compile_observational_to_separator_stream`, `stream_exhaustive_separators`,
`verify_exhaustive_separator_stream`), which produces the identical records at 144 ms here. (2)
The verifier retained an `FxHashSet` of every pair and then re-scanned every separated pair
against it: 865 ms and roughly 150 MB on top of the records, for a certificate the compiler
emits in canonical order. (3) The builder grew the record `Vec` by doubling, transiently holding
two copies of a 189 MB pool.

(2) and (3) are implementation, and both are removed in `6cc9668`:

- `verify_compilation_with_inverse`, `ExhaustivePairAudit` branch: if the records enumerate
  exactly the separated pairs in sort-major `(left, right)` order (`separators_are_canonical`,
  one merge scan, no allocation), uniqueness and coverage follow and each record is checked by
  `verify_separator_record` alone. Any other order takes the previous set-based path unchanged, so
  the set of accepted certificates is identical; the new test in section 3 pins that.
- `build_separators` sizes the record pool exactly from the class multiplicities (an `O(states)`
  count) before visiting pairs.

## 5. Defect-two A/B

Control: the harness built against the core with only the refiner repair (retained as
`~/.cache/ergodis/bin/c1062-repro-control-multiway-fixed`, SHA-256
`1bbe53b9343cfaeac3a4c019f3852cb24ae9d87ff90bf75a2b7d3e9ba852fe0d`). Treatment: the same harness
against `6cc9668` (`~/.cache/ergodis/bin/c1062-repro-treatment-audit-canonical`, SHA-256
`a3f27730c648dbc45e360ac73019c98930e9b67577f9df66bb69bf8b2d1f4a71`). Seven interleaved rounds,
order alternated each round, each round one deferred build, one separate verification and one
full audited compile per family, `choom -n 1000`, single thread. Both arms produce the same record
counts. Medians; ratio is the geometric mean of per-round treatment/control; `t` is the paired
log-ratio t-score over 7 rounds.

| family | step | control ms | treatment ms | ratio | t |
|---|---|---|---|---|---|
| `deep-pipeline`        | build    |   233.7 |   228.4 | 1.11 |   1.7 |
| `deep-pipeline`        | verify   |   951.7 |   197.2 | 0.24 | −16.1 |
| `deep-pipeline`        | full     | 1,228.2 |   426.1 | 0.39 | −17.6 |
| `reliability-3of8`     | build    |   794.4 |   809.9 | 1.10 |   0.7 |
| `reliability-3of8`     | verify   | 1,139.2 |   233.9 | 0.23 |  −8.8 |
| `reliability-3of8`     | full     | 2,036.1 | 1,025.6 | 0.56 |  −6.9 |
| `restricted-vocabulary`| build    |   101.0 |    95.6 | 1.08 |   0.9 |
| `restricted-vocabulary`| verify   |    73.4 |    15.8 | 0.25 | −13.8 |
| `restricted-vocabulary`| full     |   167.2 |   111.0 | 0.76 |  −3.3 |

Peak-RSS delta of the audited compile on the first family measured in each process
(`reliability-3of8`): control 491,612 KiB, treatment 249,956 KiB, ratio 0.51 in every round. (The
later families in a process report a zero delta because the process high-water mark is already
set; the first-family figure is the meaningful one.)

Reading: verification is 4.2x faster on every family with `|t| ≥ 8.8`; the full audited compile
is 1.8x to 2.6x faster; the build step is unchanged within noise (`|t| < 2`), so the presize buys
memory, not time. The exactness gate is intact: both arms produce identical record counts, the
partitions agree with the split transcript, and the accepted-certificate set is unchanged by
construction and by test. Not a hot-loop change (no solve loop is touched), so no counter profile
was taken; the operation is the compiler's certificate path.

The remaining audit cost is the quadratic record set itself. The `ExhaustivePairAudit` doc comment
now says so and names the streaming entry points and the transcript policies as the route at
scale, which is the guidance the task asked for if the cost proved inherent.

## 6. Recorded numbers: confirmed, corrected, or not reproduced

| recorded | status |
|---|---|
| 846x, certificate against refinement | Confirmed in order of magnitude before the repair: 1,045 to 1,228 ms audited compile against 1.2 to 1.3 ms split compile on this host, 850x to 1,000x. After the repair the audited compile is 426 ms, about 350x; the residual is the 7.9 million records. |
| 1.516 s audited compile | Confirmed in order: 1.04 to 1.23 s here in isolation (probe 2 measured inside a larger report process). Now 0.43 s. |
| 1.792 ms refinement | Confirmed in order: 1.23 to 1.28 ms for the split transcript compile and verify. |
| 33,024 states | Confirmed (`deep-pipeline`, `reliability-3of8`, `weighted-threshold-8`). |
| 6.9 GB at 205,056 states | Not reproduced directly. Explained: the record count scales as the square of the sort sizes, predicting about 7.3 GB of 24-byte records for that state count, so the figure is the materialized certificate. The repair halves the *additional* peak (no pair set, no doubling) but cannot change the record set; streaming is the tool at that scale. |
| 205,056 states | Not reproduced; the family that produced it is not named in the probe-2 report and was not rebuilt here. |
| `SplitTranscript` agrees with the audit class for class | Confirmed on every family. |
| "the threshold tracks neither sorts nor states" | Confirmed, and placed: it is the 4,096-state multiway admission gate combined with a shape-dependent refiner bug. |
| "fails closed" | Corrected: true for the immediate entry point, false for deferred verification. |

## 7. Validation

- `ergodis`: `cargo fmt --check`, `cargo clippy --all-targets --all-features -- -D warnings`,
  `cargo test --all-features` — all clean at `6cc9668`.
- `ergodis-private`: `cargo test --release --package ergodis-private --lib` passes (895 tests; the
  task brief said 888, other work in the crate has added tests since). `cargo clippy --package
  ergodis-tools --all-targets -- -D warnings` still reports only the pre-existing findings in other
  tools modules; none in the file touched here.
- `causal-lowering-report`: every fixture's compiled classes agree with the direct-enumeration
  oracle (chain 2, fork 3, collider-disjunctive 4, diamond-conjunctive 3, wide-conjunction 16,
  identity-predicted-loss 6, response-function 32), and the arity towers are unchanged.

## 8. What this hands to C1017

- The cross-policy gate in the core is the durable artifact: a future divergence between policies
  fails `cargo test` in the core rather than a downstream spike's table.
- `compile_observational_with_deferred_verification` is a documented trust-boundary contract, not
  a bug, but this episode shows its failure mode is a silently wrong quotient. Whether the deferred
  artifact should carry a "not yet verified" marker that downstream consumers must clear is a
  design question for C1017, not changed here.
- The multiway admission gate (4,096 states, two observations per sort) now selects a correct
  refiner. Whether it selects the *faster* one on these shapes is untested here: on the probe-2
  families the split transcript compiled in 1.1 to 6.3 ms and the multiway in 1.8 to 4.6 ms, so
  the choice is not obviously in multiway's favour at 33,024 states.
- Scratch harness and retained A/B executables are not committed; the executables' hashes are
  above and `~/.cache/ergodis/bin/` can drop them at task close.
