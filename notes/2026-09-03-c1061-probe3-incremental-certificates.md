# C1061 probe 3: incremental certificates (event-sourced proof chain)

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 (Ergodis as a compiled dynamic decision engine), probe 3.
**Brief**: `notes/2026-09-03-c1061-ergodis-compiled-dynamic-solver-brief.md` (item 4)
**Predecessor**: `notes/2026-09-03-c1061-probe1-composition-survey-and-delta-prototype.md`

Contract documents read in full before any work: `/home/tavis/src/ergodis/CLAUDE.md`,
`/home/tavis/src/ergodis-contrib/PERFORMANCE.md`, `/home/tavis/src/ergodis-contrib/performance-playbook.md`,
`/home/tavis/src/ergodis-private/CLAUDE.md`, and the prior-art note
`notes/2026-08-29-ergodis-certificate-prior-art-veripb.md`.

Nothing in this note is a novelty claim. Part F lists what to search before any such claim is made.

## Part A — the existing Ergodis certificate machinery, and what it does not cover

| Artifact | Location | What it certifies | Incremental? |
|---|---|---|---|
| Separating-path audit (`SeparatorRecord`, `CertificatePolicy::ExhaustivePairAudit`) | `/home/tavis/src/ergodis/src/observational.rs:709,2440` | minimality of a compiled quotient: an explicit generator word per separated same-sort pair | no |
| Refinement transcripts (`SplitTranscript`, `MultiwayTranscript`, `AdaptiveTranscript`) | same file | the minimizer's own splitting decisions, replayable in one forward pass | no |
| Streaming audit formats `ERGSEP01`, `ERGLAY01/02/03`, frozen observation `ERGFRZ02` | `observational.rs:2388-2392` | framed append-only streams with a terminal count footer, verified at bounded residency | no |
| Presentation fingerprint (`PresentationFingerprint`, `FinitePresentation::fingerprint`) | `observational.rs:310,616` | 128-bit non-cryptographic identity of sorts, observations, generators, transitions | n/a |
| Provenance DAG and replay sidecar (`ProvenanceArena`, `ReplaySidecar::verify`) | `/home/tavis/src/ergodis/src/provenance.rs:122` | a witness lift from the compiled model back to the source, checked in one forward scan | no |
| Parametric certificate verifier (`ParametricCertificate`, `PayloadDigest`, limits struct) | `/home/tavis/src/ergodis/src/parametric_certificate.rs:14,165,193` | an exact one-parameter family over `Z[t]`, with SHA-256/BLAKE3 payload digests and explicit resource bounds | no |

Every one of these certifies a **static compilation**. Not one has a notion of a certificate that
*extends* a previous certificate: there is no root commitment, no sequence number, no `apply`
transition on a certificate, and nothing in the tree hashes a *composition result*. The digests that
do exist (`PayloadDigest`) bind an external blob to a claim; they do not bind the claim's internal
structure to a recomputable value.

The conventions probe 3 follows from that machinery: an eight-byte magic plus a version word, 32-byte
digests, `thiserror` error enums with one variant per failure mode, and a verifier that shares no
code with the producer and fails closed on every malformed path.

## Part B — the snapshot certificate `C_0` and its independent verifier

New tier-1 module, no task ID in the name, built entirely in `ergodis-private`:

- `/home/tavis/src/ergodis-private/src/incremental_certificate.rs` — commitment scheme, prover, both verifiers.
- `/home/tavis/src/ergodis-private/tests/incremental_certificate_allocations.rs` — zero-allocation regression.
- `/home/tavis/src/ergodis-private/tasks/tools/src/incremental_certificate_bench.rs` — the measured sequence benchmark, wired as the `incremental-certificate-bench` subcommand of the existing `ergodis-tools` binary.
- `/home/tavis/src/ergodis-private/src/lib.rs` and `tasks/tools/src/main.rs` — one module line and one command arm each.

No change was made in `/home/tavis/src/ergodis`, and none was made to `delta_composition.rs`, which
another agent owns. The new module reuses that module's `Summary`, `LeafParameters`, `Delta`,
`DeltaRun`, and `SyntheticInstance` and maintains its own node array, because the node summaries a
hash tree has to commit to are private there. The hook that would remove the duplication is described
in Part F; it was not applied.

### The commitment

```text
leaf     D(l) = H(0x00 || l || base(l) || parameters(l))
internal D(v) = H(0x01 || summary(v) || D(left(v)) || D(right(v)))
root     R_t  = H(0x02 || artifact || t || D(1))
artifact      = H(0x03 || schema version || compiler version || W || real leaves || leaves || every base matrix)
```

`H` is SHA-256, matching the digest already used by `parametric_certificate.rs`. The internal digest
commits to the node's *composed summary* alongside its children's digests, so recomputing a digest
chain is the same act as checking the min-plus composition law along that chain — the commitment is
not a bystander over an independently trusted value. Padding leaves up to the next power of two carry
the identity matrix and an inert parameter record, so `evaluate_leaf` returns the composition unit for
them and no special case appears anywhere.

The snapshot certificate is the framed artifact header (`ERGDSN01`, schema version, compiler version,
boundary width, real leaf count, padded leaf count, event offset, artifact digest, claimed root)
followed by each leaf's base matrix and parameters. `verify_snapshot` recomputes the artifact digest
from the compiled data it was handed, recomposes every summary and every digest bottom-up, and accepts
only if the reconstructed root equals the claimed one. Tests
`snapshot_certificate_verifies_and_binds_the_root` and `tampered_snapshot_fails_closed` gate it: a
flipped parameter byte gives `SnapshotRoot`, a flipped base-matrix byte gives `Artifact`, a flipped
claimed root gives `SnapshotRoot`, and truncation gives `Length`.

At 1,024 leaves the snapshot is 73,828 bytes and verifying it takes 707,983 ns; at 16,384 leaves it is
1,179,748 bytes and 10,691,203 ns. Both are within a few percent of the compile time itself
(716,067 ns and 10,273,183 ns), which is expected: verification *is* a compile plus one hash per node.

## Part C — the delta certificate `d_t`

The wire record is fixed-size for a given depth: magic, schema version, artifact digest, previous root,
new root, previous sequence number, leaf index, depth, a 12-byte event payload, the changed leaf's base
matrix, that leaf's *previous* parameters — 208 bytes — followed by one 96-byte record per level
holding the sibling's summary and the sibling's digest.

The verifier's entire retained state is `VerifierState { artifact, root, sequence }` — 72 bytes,
asserted at compile time. It holds no tree, no parameter vector, and no base matrices. Verification is
two passes over the same sibling records:

1. Evaluate the leaf from the certificate's base matrix and *previous* parameters, hash it, and walk to
   the root using the supplied siblings. If the result is not the held root `R_t`, reject. **This pass
   is what binds every supplied sibling value**: a forged sibling summary, a forged sibling digest, a
   forged leaf index, a forged base matrix, forged previous parameters, or a short path all change the
   reconstructed previous root.
2. Apply the event to those previous parameters, re-evaluate the leaf, and walk the same siblings again.
   If the result is not the certificate's claimed new root, reject; otherwise adopt it and increment the
   sequence.

Work is `2 * (depth + 1)` hashes and `2 * depth` min-plus products, independent of leaf count.

### Fails closed

`forgeries_and_stale_deltas_fail_closed` asserts the exact error for each attack: forged ancestor
summary and forged ancestor digest give `PreviousRoot`; a forged event gives `NewRoot` (pass 1 still
reconstructs, pass 2 does not); a forged leaf index, forged previous parameters, and a forged base
matrix give `PreviousRoot`; a forged claimed new root gives `NewRoot`; a certificate carrying a
different artifact gives `Artifact`; one carrying a different previous root gives `StaleRoot`; one
carrying a different sequence gives `StaleSequence`; truncation gives `Length` and a wrong magic gives
`Magic`. Replay of an honest certificate against the advanced verifier gives `StaleRoot`. The sequence
number is inside the root preimage, so a replayed certificate cannot succeed even when the event was a
no-op that left every parameter unchanged.

### Measured

Host: the development box (AMD Ryzen AI 9 HX 370, NixOS), release profile, shared target directory
`~/.cache/ergodis/target/ergodis-private`, `choom -n 1000`, seed 2026 throughout. The retained control
binary for the counter work is `~/.cache/ergodis/bin/ergodis-tools-525a82b`, SHA-256
`52010c2cd483abccfad52f5c8af4a45bee12de8dd6694a65626af53047cf8258`.

```
ergodis-tools incremental-certificate-bench --leaves 1024  --events 100000
ergodis-tools incremental-certificate-bench --leaves 16384 --events 100000
```

| Quantity | 1,024 leaves | 16,384 leaves |
|---|---|---|
| depth | 10 | 14 |
| maintained state (summaries + digests + compiled leaves) | 270,336 B | 4,325,376 B |
| snapshot certificate | 73,828 B | 1,179,748 B |
| full re-verification (snapshot verify, mean of 8) | 592,919 ns | 10,564,913 ns |
| delta certificate per event | 1,168 B | 1,552 B |
| emit (update + certificate) mean | 2,561.9 ns | 3,801.0 ns |
| emit p50 / p99 / p99.99 | 2,525 / 3,186 / 7,494 ns | 3,757 / 5,080 / 31,860 ns |
| verify mean | 4,607.1 ns | 6,043.9 ns |
| verify p50 / p99 / p99.99 / max | 4,588 / 5,430 / 10,289 / 128,009 ns | 5,952 / 7,374 / 15,008 / 496,758 ns |
| full re-verification ÷ delta verification | 128.7x | 1,748.0x |

A 16x increase in leaf count costs the incremental verifier 1.31x (the `log` term plus cache) and the
full verifier 17.8x (linear), so the advantage grows exactly as the depth argument predicts. Chain
integrity was asserted continuously: the benchmark rejects any event where the verifier's optimum
disagrees with the prover, and it fails at the end unless the verifier's root and sequence equal the
prover's. Over the 100,000-event stream plus 12,500 collapsed runs, 112,500 certificates verified with
zero disagreements at both sizes.

### Where the time goes

Playbook counter method, two run sizes differenced so process startup and instance generation cancel.
With `--collapse-run 1` each `--events N` run performs `2N` emit-plus-verify pairs.

```
perf stat -e instructions,cycles -x, ergodis-tools incremental-certificate-bench --leaves 1024 --events 100000 --collapse-run 1
perf stat -e instructions,cycles -x, ergodis-tools incremental-certificate-bench --leaves 1024 --events 600000 --collapse-run 1
```

| | 100k | 600k | difference | per emit+verify pair (1,000,000 pairs) |
|---|---|---|---|---|
| instructions:u | 6,906,979,679 | 41,237,866,778 | 34,330,887,099 | ~34,331 |
| cycles:u | 4,273,684,592 | 25,553,567,553 | 21,279,882,961 | ~21,280 |

IPC 1.61. One pair performs 33 SHA-256 invocations (11 emitting, 22 verifying), i.e. about 645 cycles
each on inputs of roughly 100 bytes. Probe 1 measured the bare tree update at about 1,025 cycles, so
**the commitment costs about twenty times the algebra it commits to, and about 95% of the certified
path is hashing.** That is the lever for any future work here, and it is a representation lever, not an
instruction-shaving one: the two candidates are enabling a hardware-accelerated SHA-256 backend
(`sha2`'s assembly feature; this CPU reports `sha_ni`) or switching to BLAKE3, which the public core
already depends on. Recorded negative: `-C target-cpu=native` alone does not help, because `sha2` 0.10
does not select its SHA-NI backend from target features. Three interleaved rounds of the retained
control against a natively built binary at 1,024 leaves gave verify means of 3,927 / 3,927 / 4,347 ns
for the control and 4,176 / 4,175 / 3,301 ns for the native build — no consistent direction, and the
third round is thermal noise on both sides.

## Part D — event-monoid collapse of certificates

Yes, a run of `k` events on one leaf produces one delta certificate, and verification stays `O(depth)`.

The collapse is the probe-1 `DeltaRun` monoid — additive accumulation of the cost bump, last-writer-wins
for the two setters — lifted into the certificate: the wire event payload has a run variant, and the
`(previous parameters, event, new parameters)` triple in the certificate covers the whole run. The
verifier code path is identical, so the per-certificate cost does not change: measured 4,818 ns per run
at 1,024 leaves against 4,607 ns per single event, and 5,563 ns against 6,044 ns at 16,384 leaves. Both
differences are noise; the point is that neither grows with `k`.

Certificate volume therefore falls as `1/k`: at `k = 8`, 146 bytes per event at depth 10 and 194 bytes
per event at depth 14, against 1,168 and 1,552 bytes for one certificate per event.

`collapsed_run_certificate_matches_the_stepwise_chain` gates the semantics: after each run, the
collapsed tree's root *node* digest and optimum must equal the stepwise tree's. Only the sequence
numbers differ, because the sequence counts certificates rather than events. That is the audit-trail
trade-off to state plainly: a collapsed chain proves the same final state, but a verifier holding only
the collapsed chain can no longer see the individual events inside a run.

## Part E — crash recovery and replay

`crash_recovery_replays_to_an_identical_root` runs a 4,000-event history on a live tree, writes the
snapshot certificate at offset 2,000 to a file, reads it back, verifies it, restores a prover from it
(`CertifiedTree::from_snapshot`, which recompiles and re-derives every digest rather than trusting the
bytes), replays events 2,000 onward, and asserts that the recovered root commitment and optimum equal
the live ones. It then replays the entire history from event zero into a fresh tree and asserts the same
root. The persisted state is exactly the snapshot certificate — compiler version, artifact digest, event
offset, serialized leaves, root commitment — so there is no second persistence format to keep in step,
and a snapshot that fails verification is refused before it can become a prover.

## Part F — relation to the existing proof format and to VeriPB; what to search

Relation to the Ergodis formats: probe 3 reuses their conventions (framed magic, schema version, 32-byte
digests, fail-closed verifier, resource-bounded parse) and adds the one structure they lack — a root
commitment that a *transition* certificate can extend. It certifies a different property again: the
observational certificates prove *minimality* of a compiled model and the parametric verifier proves an
*exact family*, while this chain proves that a claimed optimum is the one the compiled artifact plus a
specific event history forces. Against VeriPB the earlier note's framing still holds — pseudo-Boolean
proof logging certifies soundness of transformations of a static database, and has no vocabulary for a
maintained state and its update — but that is a statement about what VeriPB covers, not evidence of
novelty here.

What is standard, and must be assumed anticipated until searched:

- **Authenticated data structures.** A hash tree over a computation whose internal nodes commit to their
  own value, with a logarithmic membership/update proof, is a Merkle tree with an aggregate at each node.
  Search: Merkle 1987; Naor–Nissim, *Certificate revocation and certificate update*, 1998/2000; Tamassia,
  *Authenticated Data Structures*, ESA 2003; Papamanthou–Tamassia–Triandopoulos on authenticated hash
  tables and range/aggregate queries; Miller–Hicks–Katz–Shi, *Authenticated Data Structures, Generically*,
  POPL 2014 (which compiles exactly this pattern from a functional program); Merkle segment trees and
  "Merkle Mountain Range" aggregates in the deployed-systems literature. Also Certificate Transparency
  (RFC 6962) and its consistency proofs, which are the deployed form of "prove that the new root extends
  the old one".
- **Incremental view maintenance with proofs.** The brief's own framing. Search: the DBToaster line
  (Koch et al.) for incremental view maintenance; verified/authenticated query answering
  (Devanbu–Gertz–Martel–Stubblebine; Pang–Tan); and, for the streaming setting, "streaming authenticated
  data structures" (Papamanthou–Shi–Tamassia–Yi, EUROCRYPT 2013).
- **Verifiable state machines and proof-carrying execution.** US 10,997,154 B2 (Setty et al.) is already
  cited in the earlier prior-art note; also the SNARK-based incrementally verifiable computation line
  (Valiant, TCC 2008) and Nova-style folding schemes, which are the cryptographic analogue of the
  event-monoid collapse in Part D.
- **Certified dynamic algorithms.** The certifying-algorithms survey (McConnell–Mehlhorn–Näher–Schweitzer,
  2011) is a recorded negative for automata, but a targeted search for certifying *dynamic* graph
  algorithms — dynamic connectivity, dynamic shortest paths — is missing from the prior-art note and
  should be run before any claim.
- **Min-plus/tropical segment trees.** Maintaining a matrix product over a segment tree under point
  updates is folklore in competitive programming and standard in the "dynamic DP" literature; the
  certificate is the new part, not the tree.

The one part of the construction that is *not* obviously covered by the list above, and therefore the
only thing worth taking to a serious search, is **historical decision provenance**: the chain records
which declared event moved the optimum, so an auditor can replay not just the current answer but the
causal history of the decision, at 72 bytes of held state. The honest position is that this is a
composition of Merkle-style authenticated updates with event sourcing, both mature; the search should be
aimed at whether anyone has published that composition for an *optimization* answer rather than for a
database view or a ledger.

Hook that would remove the one piece of duplicated logic, described rather than applied because
`delta_composition.rs` is owned by another agent: `CompositionTree` needs a read accessor for its node
array and its per-leaf base matrix and parameters (`fn node(&self, index: u32) -> &Summary`,
`fn base(&self, leaf: u32) -> &Summary`, and the existing `parameters`), plus `pub` on the leaf
evaluation. With those, `CertifiedTree` would wrap a `CompositionTree` instead of maintaining its own
node array, and `incremental_certificate::evaluate_leaf` — which restates the leaf-evaluation semantics
verbatim — would go away. Until then, the cross-check test
`certified_tree_agrees_with_the_delta_composition_tree` runs both trees over 5,000 events and asserts
equal optima at every step, which is what keeps the two copies honest.

## Validation

```
cd /home/tavis/src/ergodis-private
rustfmt --edition 2021 --check src/incremental_certificate.rs \
    tests/incremental_certificate_allocations.rs \
    tasks/tools/src/incremental_certificate_bench.rs        # clean
cargo test -p ergodis-private --lib incremental_certificate # 8 passed
cargo test --test incremental_certificate_allocations       # 1 passed
cargo clippy --workspace --all-targets -- -D warnings -A unused-imports   # clean
cargo build --release -p ergodis-tools
```

The bare `cargo clippy --workspace --all-targets -- -D warnings` currently fails on an unused import at
`/home/tavis/src/ergodis-private/src/congruence_search.rs:33` (`SUMMARY_ENTRIES`), which belongs to
another agent's in-progress module; it is the only diagnostic in the workspace, hence the scoped rerun.
`cargo fmt --all` reaches beyond this workspace into other checkouts through the shared tree and reports
many pre-existing foreign diffs, so formatting was checked per file instead. A full `cargo test
--workspace` was started but not carried to completion: two other agents were editing the same
workspace during this probe, so its verdict would not have been attributable to this change.

Committed in `ergodis-private` as `83773c6`, touching only the module, its test, the benchmark, one
`pub mod` line, and one command arm. The concurrent `snapshot_acceleration` module line and the
`lrc_delta_binding` edits present in the working tree were deliberately left unstaged.

Zero allocations: `certificate_emission_and_verification_allocate_nothing` runs 20,000 events at 1,024
leaves through `apply_delta_with_certificate` and `verify_delta` with a counting global allocator and a
presized certificate buffer, and asserts 0 allocations across both.

## Mystery ledger

- **Emit costs 2,562 ns but the bare update costs 318 ns (probe 1).** Settled by the counter run: 33
  SHA-256 invocations at about 645 cycles each dominate everything, and the composition is under 5% of
  the certified path. What is *not* settled is why one 100-byte SHA-256 costs 645 cycles when a software
  SHA-256 compression of one 64-byte block should be nearer 400; the per-call `Sha256::new` setup and the
  two-block inputs of the internal-node preimage (129 bytes) are the likely explanation, unmeasured.
  Cheap to settle with a targeted microbenchmark, and it matters because it decides whether the fix is a
  backend swap or a preimage-layout change.
- **Verification costs 1.8x emission** despite doing the same walk twice, which would predict 2x
  emission minus the tree writes. Consistent, but the split between the two passes was not measured
  separately. The second pass is unavoidable in the current design; a verifier that cached the previous
  path for the *same* leaf could skip pass 1 on a repeated leaf, which is exactly the burst pattern the
  collapse in Part D already exploits. Open, and a plausible free win for bursty streams.
- **The 1,051,675 ns emit maximum and the 496,758 ns verify maximum**, both single samples three orders
  above p99.99, are the same unexplained tail probe 1 recorded. Nothing here pins threads or pre-faults
  the state, so scheduler preemption and page faults remain unexcluded. Open; it matters for any
  tail-latency claim.
- **No algebraic mystery.** The commitment binds the composition law by construction, and every attack
  the design anticipated fails with the error the design predicted, on the first attempt.

## Vibe check

Good, and the shape is better than expected: the verifier holds 72 bytes and beats full re-verification
by 129x at 1,024 leaves and 1,748x at 16,384, with collapse cutting certificate volume by `k`. The
disappointment is cost density — the proof chain costs about twenty times the update it certifies, all
of it SHA-256, which turns "delta certificates are nearly free" into "delta certificates cost a few
microseconds" until the hash backend changes. The domain is still probe 1's synthetic chain, so nothing
here is a product claim, and Part F should be read as a search list rather than a novelty position.

---

## 2026-09-03 follow-up: commitment-backend A/B, measured in hardware counters

Scope: engineering only. The literature and novelty thread of Part F is closed and was not extended.

Every number in this section is a hardware-counter measurement. The wall-clock figures in Parts B to E
above are superseded wherever the two disagree; each verdict that changed is marked below.

### The candidates, and what the machine actually runs

1. **`sha256-digest`** — SHA-256 through the `sha2` `Digest` interface with a leading domain tag byte.
   The original probe-3 scheme, now the A/B baseline.
2. **A SHA-NI-enabled `sha2`** — *not a candidate, because it is already what runs.* `sha2` 0.10.9
   selects its x86 SHA-NI backend at runtime through `cpufeatures`
   (`~/.cargo/registry/src/*/sha2-0.10.9/src/sha256/x86.rs:100`), with no crate feature and no
   `RUSTFLAGS` involvement; this CPU (AMD Ryzen AI 9 HX 370) reports `sha_ni`. Building the same
   workload against `sha2/force-soft` is 4.0 to 4.4x slower, which is the confirmation that the
   hardware path is live. That also explains the recorded `-C target-cpu=native` negative in Part C:
   there was nothing left for it to enable.
3. **`sha256-packed`** — the same SHA-256 compression function, called directly on a zero-padded whole
   number of 64-byte blocks with the domain mixed into the initial state and **no Merkle–Damgård length
   block**. Sound here because every preimage within a domain has one fixed length, so there is no
   padding ambiguity to exploit, and collision resistance still rests on the same compression function.
   The internal-node preimage is packed to exactly 128 bytes — 64-byte summary, two 32-byte child
   digests, no room spent on a tag byte — so it costs two compressions instead of the three that
   length padding forced.
4. **`blake3`** — one-shot and through the `Hasher` interface; both measured, no material difference.
   The `hash_many`/tree API does not apply: the path's preimages are produced sequentially and each
   depends on the previous one, so there is no batch to hand it.
5. **`noncryptographic-lower-bound`** — a 256-bit multiply-xor mixer. **Not acceptable for the
   fail-closed guarantee**: it has no collision resistance, so a forger can construct an ancestor
   summary that reproduces a root. It exists to bound how much of the certified path is the hash, and
   its `Commitment::CRYPTOGRAPHIC` constant is `false` so a caller can refuse it. Note that it still
   passes the byte-flip forgery tests, which shows only that those tests model accidental corruption,
   not an adversary.

On the coordinator's item about hashing once per certificate rather than once per node: the design does
not re-hash anything. Emission performs `depth + 1` hashes and verification `2 * (depth + 1)`, and every
one of them commits to a distinct node. The second verification pass cannot be folded into the first —
it walks the same siblings but hashes different node summaries — so the reduction available was in
*blocks per hash*, which is what `sha256-packed` takes.

The backend is chosen once, outside every loop, by monomorphizing the prover and both verifiers on a
`Commitment` trait; nothing dispatches per node. A backend identifier goes into the artifact preimage,
so a certificate produced under one backend can never validate under another.

### Design of the measurement

`ergodis-tools incremental-certificate-bench` gained `--hash` and `--mode`. Each mode puts exactly one
operation in the measured region — `chain` emits and verifies one certificate per event, `emit` only
emits, `update` runs the same event stream through the plain uncertified `CompositionTree`, and `full`
performs one snapshot serialization plus full verification per event — so a differenced counter run is
attributable to that operation.

Per round, per backend, per mode, two runs differing only in event count (40,000 and 200,000; 200 and
1,000 for `full`) are differenced, which cancels process startup, instance generation, and the snapshot
stage. Rounds are interleaved — all backends within a round, seven rounds — so thermal drift is shared
across arms rather than aliased onto one. The driver and the analysis are
`/tmp/claude-1000/-home-tavis-src-othello-rust/b9c7b857-9104-4ac3-b222-9bc84903a341/scratchpad/hashab.sh`
and `analyse.py`; the raw per-round counter rows are `ab-1024.tsv` and `ab-16384.tsv` in the same
directory. Binary
`~/.cache/ergodis/target/ergodis-private/release/ergodis-tools`, SHA-256
`20dfc718031ccb4f431225269a54e2d8d0fec85e35da4ba45681b682c5838c53`, at commit `3971eb6`, run under
`choom -n 1000`, seed 2026. The machine was carrying other agents' builds throughout, which is visible
in the cycle standard deviations and is exactly why the design is paired.

Ratios are paired: the statistic is a one-sample t on the seven per-round log ratios against the
baseline arm of the same round, and the interval is that t interval exponentiated back to a ratio.

### Result, 1,024 leaves (depth 10), one emit-and-verify pair

| backend | n | instructions (sd) | cycles (sd) | cycles ratio vs baseline | 95% CI | t |
|---|---|---|---|---|---|---|
| `sha256-digest` (baseline) | 7 | 35,669 (1) | 21,169 (592) | — | — | — |
| `sha256-packed` | 7 | 24,889 (0) | 14,073 (387) | **0.665** | [0.661, 0.668] | −196.3 |
| `blake3` | 7 | 61,321 (1) | 42,200 (800) | 1.994 | [1.969, 2.019] | 134.4 |
| non-cryptographic lower bound | 7 | 10,274 (0) | 3,559 (832) | 0.164 | [0.135, 0.200] | −22.7 |

Emission alone: 7,515 / 5,092 / 14,847 / 1,374 cycles for the four arms, with `sha256-packed` at 0.678
of baseline, CI [0.665, 0.691].

### Result, 16,384 leaves (depth 14), one emit-and-verify pair

| backend | n | instructions (sd) | cycles (sd) | cycles ratio vs baseline | 95% CI | t |
|---|---|---|---|---|---|---|
| `sha256-digest` (baseline) | 7 | 47,784 (1) | 30,077 (1,255) | — | — | — |
| `sha256-packed` | 7 | 32,992 (2) | 20,254 (173) | **0.674** | [0.648, 0.701] | −24.7 |
| `blake3` | 7 | 82,159 (1) | 60,276 (1,013) | 2.005 | [1.918, 2.097] | 38.2 |
| non-cryptographic lower bound | 7 | 13,721 (1) | 6,471 (937) | 0.213 | [0.181, 0.251] | −23.0 |

Emission alone: 11,024 / 7,162 / 21,442 / 2,148 cycles, `sha256-packed` at 0.650 of baseline,
CI [0.621, 0.680].

No comparison here is underpowered: instruction counts are deterministic to within two instructions,
and every ratio interval excludes 1.0 at both sizes.

### Recommendation, and the switch

**Use `sha256-packed`.** It is 1.50x faster than the previous scheme in cycles per emit-and-verify pair
at 1,024 leaves and 1.48x at 16,384, with intervals well clear of 1.0 at both sizes, and it keeps a
256-bit digest, the same compression function, and the same certificate bytes. BLAKE3 is exactly the
wrong shape for this workload — it is built for long inputs, and at 76- and 128-byte preimages it costs
twice as much as SHA-NI SHA-256. The non-cryptographic bound says the whole family of commitments has a
floor of roughly 3,600 cycles per pair at this depth, which no acceptable backend can reach.

The module default is now `Sha256Packed` (`DefaultCommitment`), and the other three remain selectable
for measurement. All eight correctness gates — snapshot verification, snapshot tampering, the
cross-check against `delta_composition`, the 20,000-event chain, the whole forgery and stale-replay
suite, collapse equivalence, crash recovery, and certificate sizes — now run against all four backends:
32 tests, all passing. The 100,000-event benchmark chain plus 12,500 collapsed runs verifies with
identical certificate sizes (1,168 bytes per event, 146 with runs of eight) under every backend. The
zero-allocation regression passes with the new default.

### Restated verdicts, in cycles

| Claim | Wall-clock figure in Parts B–E | Counter measurement, `sha256-packed` | Changed? |
|---|---|---|---|
| Certified path ÷ uncertified update, 1,024 leaves | "~20x", from a differenced counter estimate | 22.00x, CI [17.56, 27.55], t 33.6 | no — and it was 33.09x, CI [26.41, 41.44], under the old backend |
| Certified path ÷ uncertified update, 16,384 leaves | not measured | 15.25x, CI [12.42, 18.72], t 32.5 | new |
| Full re-verification ÷ incremental verification, 1,024 leaves | 128.7x | 136x (full 1,221,487 cycles ÷ verification-only 8,981 cycles) | no |
| Full re-verification ÷ incremental verification, 16,384 leaves | 1,748.0x | 2,072x (27,122,547 ÷ 13,092) | no, and the advantage is larger than the wall clock suggested |
| Full re-verification ÷ whole emit-and-verify pair, 1,024 / 16,384 leaves | not measured | 87x, CI [84, 90] / 1,338x, CI [1,286, 1,392] | new |
| Share of the certified path that is hashing | "~95%" | 75% at 1,024 leaves and 68% at 16,384, from the non-cryptographic lower bound; the earlier figure came from comparing against probe 1's update cost measured in a different binary | **yes — the earlier 95% overstated it** |
| Verification ÷ emission | 1.8x | 1.76x at 1,024 leaves (8,981 ÷ 5,092), 1.83x at 16,384 | no |

The uncertified update itself costs 659 cycles at 1,024 leaves and 1,354 at 16,384 in this binary,
against probe 1's 1,025 cycles at 1,024 leaves — the same operation measured through a different
harness, which is the discrepancy that inflated the earlier hashing share.

### Validation of the follow-up

```
cd /home/tavis/src/ergodis-private
cargo test -p ergodis-private --lib incremental_certificate   # 32 passed (8 gates x 4 backends)
cargo test --test incremental_certificate_allocations         # 1 passed
rustfmt --edition 2021 --check <the three owned files>        # clean
cargo clippy --workspace --all-targets -- -D warnings -A unused-imports
cargo build --release -p ergodis-tools
```

Committed in `ergodis-private` as `3971eb6`, touching the module, its test, the benchmark, and the two
dependency lines (`sha2` gains the `compress` feature for the block API; `blake3`, already a public-core
dependency, is added). The workspace-wide clippy run now also reports two `manual_contains` findings in
`src/policy_automaton.rs`, another agent's in-progress module, alongside the earlier unused import in
`src/congruence_search.rs`; neither is in an owned path.

### Mystery ledger, follow-up

- **Packing wins 1.5x, but the predicted saving was 1.2x.** Dropping one of three compression blocks on
  the internal-node preimage should be worth about 20%; the measured 50% means the `Digest` wrapper's
  per-call setup costs materially more inside the real path than in an isolated microbenchmark, where it
  measured only 3%. The most likely cause is that the wrapper's buffering and `GenericArray` handling do
  not inline through the trait boundary here. Unsettled, and it matters only if someone tries to predict
  a further backend change instead of measuring it.
- **The non-cryptographic floor is 16% of the packed backend at depth 10 but 32% at depth 14.** The
  mixer is linear in preimage bytes with no fixed setup, so it should scale with depth exactly as the
  real backends do. It does not, which suggests the deeper path is increasingly bound by something other
  than hashing — most plausibly the cache behaviour of the 4.3 MB node-and-digest state. Open, and it
  bounds how much any further hash work can buy at large depth.
- Superseded from the earlier ledger: the "645 cycles per SHA-256 call" figure and the "95% of the path
  is hashing" figure were both artifacts of comparing across binaries. The per-pair counter table above
  replaces them.

---

## 2026-09-03 follow-up: one chain for every summary type, and a certificate from a table

Probe 18. The chain in this report was written for one domain: a min-plus matrix summary with a known
leaf evaluator. It has now been generalized over the `OpenProblem` core trait that probe 16 settled,
instantiated for four summary shapes, and extended with a certificate that comes from a compiled
transition table instead of a tree. Full results are in section 10 of
`/home/tavis/src/ergodis-private/docs/adr/0001-generic-dynamic-decision-layer.md`; this is the part
that bears on the original chain.

### What changed about the guarantee

The chain in this report proves both the leaf evaluation and the composition, because it carries the
leaf's base matrix, previous parameters, and the event, and the verifier re-evaluates the leaf. The
generic chain cannot do that — the leaf evaluator is domain code the trait does not name — so it
carries the leaf's previous and new summaries and proves only:

> the root moved from `R_t` to `R_{t+1}` because leaf `l` changed from `S_old` to `S_new`, and every
> ancestor recomposed correctly.

Leaf-evaluation correctness becomes a separate obligation. That is the cost of one chain for every
domain, and the specialized chain here remains the stronger artifact on its own domain.

### A correction to this report's fail-closed claim

This report says a forged ancestor summary or digest gives `PreviousRoot`. Building the generic suite
showed that is true at level 0 and not guaranteed above it, **and the same is true of the specialized
chain.** At level 0 the sibling is a leaf, so its digest is recomputable from the supplied summary and
the two are bound outright. Above level 0 a sibling's digest depends on children the verifier does not
hold; the binding is indirect, and a forged sibling is rejected through whichever reconstructed root it
moves. A forgery that moves neither root is one min-plus composition absorbs — it changes no value the
certificate asserts — so nothing unsound is accepted, but the error code is not always `PreviousRoot`.
The accurate statement of the guarantee is the disjunction, and the generic suite now asserts it that
way. The specialized suite's byte offsets happen to land on cases that always move a root, which is why
it never caught this.

### Cost of the generalization

Seven interleaved rounds, fixed 4,096-event window, 1,024 leaves, pinned binary
`b0138ac07ab2131be786e589...`, `sha256-packed`:

| chain | instructions per event | certificate bytes |
|---|---|---|
| specialized min-plus (this report) | 25,046 | 1,168 |
| generic, min-plus matrix | 49,457 | 1,216 |
| generic, policy transition function | 62,166 | 1,264 |
| generic, monoid element index | 25,598 | 496 |
| generic, semiring window at width 8 | 204,433 | 3,520 |
| table transition, no tree at all | 3,749 | 328 |

One chain for four shapes costs 1.97x a chain for one, on the domain where they compare directly, and
1.02x when the summary is a single word. Two defects were fixed while measuring — a `Vec` allocated per
digest, and a length prefix that pushed the 128-byte internal preimage to a third compression block —
worth 63,323 to 49,457 instructions between them. The residual is encode and decode at every level in
both passes.

### The table certificate

`TableCommitment`, `TableProver` and `TableVerifier` answer probe 12's question: a delta certificate can
be emitted from a table transition alone, as `(table root, previous sequence, previous state, symbol,
next state, offset delta, inclusion path)`. The verifier holds 64 bytes and does `O(log cells)` hashes,
independent of tree depth and problem size — 6.68x cheaper than this report's chain, CI [6.68, 6.68].
The table itself is certified once by recomputation at build time; after that every event is an
inclusion proof against the same root. It is demonstrated on the policy transducer, whose table is a
genuine transition function, and must not be applied to the LRC fleet's `ShapeTable` until probe 12's
enriched tie-multiplicity state closes that transition.

### Harness correction affecting this report

The benchmark behind this report pre-drew one event per measured event, so its two-point differencing
charged every arm one event draw per operation. Re-measured with a fixed 4,096-event window, the
certificate arms move by well under a percent — the draw is negligible against 25,000 instructions — so
every verdict in this report stands unchanged. The same audit moved probe 8's numbers materially; that
correction is recorded in section 10.5 of the ADR.
