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
