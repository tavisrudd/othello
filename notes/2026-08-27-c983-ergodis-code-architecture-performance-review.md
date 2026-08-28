# C983 Ergodis code, architecture, and scaling review

**Lane**: `complete-ports`

**Date**: 2026-08-27
**Scope**: the observational compiler, replay/provenance sidecar, four adapter
controls, and their connection to the production composition tower.

## Verdict

The observational compiler is now a scale-ready exact deterministic core. It
has adaptive dense/sparse inverse construction, an edge-bounded typed
small-half worklist, an independently replayable linear-size transcript,
allocation-free refinement loops, iterative replay, and direct stability fast
paths. Exhaustive concrete-pair certificates remain available only as a
bounded audit policy. The remaining scaling risks sit above or beside the
kernel: explicit context-family presentation, semantic witness schemas, and
versioned provenance artifacts.

### General theorem/algorithm statement

For a finite many-sorted deterministic Moore presentation with `N` states,
`G` generators, `M = sum_g |source_sort(g)|` supplied transition edges, and
initial observation partition `P0`, the implemented compiler returns the
coarsest typed congruence refining `P0`. Its transcript contains exactly
`|P|-|P0|` 16-byte split records. Adaptive inverse, candidate, and pending
storage is `O(N+M+G)` even when `D = sum_g |target_sort(g)|` is arbitrarily
larger than `M`. Deterministic smaller-child orientation gives `O(M log N)`
inverse/candidate incidence work. Pending membership is either a dense bitmap
selected only when its exact footprint is no larger than the sparse backend,
or a flat binary Patricia trie with at most 64 branch decisions per operation.
Thus the fixed-width word-RAM scheduler has deterministic `O(M log N)` work,
not an expected-hash qualification.

If `P0` is already stable, one direct congruence pass bypasses inverse and
worklist construction. If every generator targets a one-class sort, totality
makes congruence immediate and the minimizer need not inspect transition edges
at all after presentation validation. A classical complete DFA is the
one-sort, Boolean-observation specialization with `M=D=|alphabet| |Q|`, so the
ordinary Hopcroft setting is a corollary rather than the framework boundary.

## Initial ranked findings and their resolution

The findings below record the starting audit. Later sections document which
were repaired in C983 and which remain upstream/artifact work.

### 1. Exhaustive pair certificates are the first hard wall

`build_separators` emits one 24-byte record for every same-sort pair placed in
different classes.  Each record is found by a fresh product-state breadth-first
search, and that search clones the full generator word along new frontier
edges.  If one sort of size `N` is fully separated, records alone require about
1.2 GB at `N=10,000`, 120 GB at `N=100,000`, and 12 TB at `N=1,000,000`, before
path words or working memory.  Verification then enumerates all pairs again,
and every sidecar verification reruns the full compilation verifier.

The bounded controls already expose the trend.  The resource quotient is
1,224 bytes while its separator certificate is 57,180 bytes, a 46.7x ratio.
The exhaustive representation is valuable as a small-model audit oracle but
cannot be the normal artifact policy.

### 2. Explicit unary-context expansion can be quadratic upstream

The compiler accepts typed total unary generators.  Multi-input algebras must
therefore enumerate each admissible one-hole context, including every
coargument, as a generator.  A binary operation over `N` possible
coarguments can induce `O(N)` generators with `O(N)` transition entries each.
This presentation blowup can dominate before quotient minimization starts.

The scalable adapter boundary must permit reachable, lazy, symbolic, or
algebraically factored context families while preserving the exact finite
semantics of the frozen presentation used for certification.

### 3. Generic sidecar verification is structural, not semantic

`ReplaySidecar::verify` proves presentation identity, concrete/quotient trace
commutation, terminal observation agreement, arena well-formedness, and root
existence.  It does not prove that an opaque payload is a valid recovery
equation, resource assignment, WTA run, or hierarchical local-label witness.
Those semantic replayers currently live in the integration test and run after
generic verification.

Before persistent or externally consumed artifacts, adapters need a versioned
`WitnessSchema` contract whose verifier replays each root and checks the
claimed terminal object and observation.  An ad-hoc numeric adapter ID is not
a sufficient semantic binding.

### 4. Refinement performs avoidable global work and allocation

For every state and every round, the current implementation scans the global
generator table to recover the typed outgoing generators, linearly scans sorts
to recover the state sort, allocates continuation/signature vectors, reserves
capacity from the global generator count, and stores owned vector keys in a
`BTreeMap`.  Synchronous refinement can require linearly many rounds on a long
chain.

The target architecture should precompute sort-to-generator ranges and inverse
transition CSR.  Acyclic sort graphs should be minimized in one
reverse-topological canonicalization pass; cyclic strongly connected
components should use small-half partition refinement.  The current compiler
should remain the deterministic differential oracle.

### 5. Witness evidence duplicates paths and trees

The provenance arena always appends; it does not hash-cons identical nodes.
Each replay record copies its complete generator word.  The hierarchy control
materializes a fresh recursive binary witness tree per query.  Its quotient is
464 bytes, while arena and replay evidence total 38,196 bytes, about 82x.

Production evidence should hash-cons `(kind, payload, children)`, factor words
through a trace trie or DAG, stream native `CompositionTower` witnesses, and
offer explicit cost-only and witness-retaining modes with a witness budget.

### 6. The independent verifier needs artifact-boundary hardening

The verifier does not first establish that compiled class ranges are bounded,
disjoint, contiguous, and cover exactly the class ID space.  A crafted future
artifact can share a class between sorts, contrary to the advertised typed
partition contract, or cause an out-of-bounds panic.  Current compiler-created
values are safe because fields are private.

Other pre-serialization hardening includes checked pool-end arithmetic,
fallible range views or a verified typestate, recomputed evidence metrics, a
canonical pool layout, and a versioned cryptographic presentation digest.  The
current noncryptographic fingerprint remains appropriate as a fast in-process
tag.

### 7. The cross-domain adapter layer is still a test harness

All carrier discovery, observation coding, transition construction, witness
export, and semantic replay for the WTA, resource, recovery, and hierarchy
examples live in one integration test.  The production API begins only after
an adapter has fully enumerated scalar-`u32` observations and boxed transition
arrays.  Resource subsets also use a fixture-only `u64` ceiling.

Add a cold `Adapter`/`PresentationBuilder` layer for reachable closure, stable
IDs, typed observation interning, deterministic successor filling, witness
schema selection, and scalable bitset/sparse carrier representations.  Keep
the minimizer's hot dense records monomorphic.

### 8. Measured scaling evidence is absent for the new path

The existing contextual benchmark exercises confinement and cache machinery,
not the observational compiler or replay sidecar.  Artifact byte counts are
useful exact controls but exclude transient maps, queues, path clones, spare
capacity, and peak resident memory.

## Target pipeline

1. A cold domain adapter discovers a reachable finite carrier and interns
   typed observations.
2. A presentation builder freezes dense sorts, generators, transitions, and
   adapter/schema identity.
3. An acyclic or cyclic minimizer emits a canonical quotient.
4. Certificate policy selects quotient-only recomputation, a compact split
   transcript, or bounded exhaustive pair audit.
5. Verification returns a `VerifiedCompilation` token reused by all sidecars.
6. Query evaluation uses only dense quotient pools.
7. Optional witness reconstruction follows hash-consed provenance and trace
   DAGs under an explicit resource budget.

## Implementation order and gates

1. Make certificate policy explicit.  Preserve exhaustive pair audit for the
   bounded corpus and add a quotient-only path that proves minimality by
   deterministic recomputation without materializing pair witnesses.
2. Add a compiler benchmark with stage counts, wall time, logical artifact
   bytes, and adversarial families.  Peak RSS/allocation instrumentation is a
   following measured slice.
3. Repair class-range validation and introduce verified compilation typestate.
4. Add typed adjacency and the acyclic reverse pass; then add the cyclic
   Paige--Tarjan fallback.
5. Add adapter and witness-schema contracts.
6. Hash-cons provenance, factor trace prefixes, and share immutable
   composition-table backing.
7. Explore symbolic context families only after the explicit dense baseline
   exposes where presentation construction dominates.

Every backend must preserve exact class, transition, observation, and witness
parity with the current Rust reference and independent Python bounded corpus.
Performance evidence must use deterministic release inputs and interleaved A/B
runs, and must separate carrier construction, refinement, certificate
generation, verification, sidecar construction, and replay.

## Acceptance boundary

The current implementation establishes that one exact observational kernel can
serve four genuinely different adapters and retain concrete witnesses.  It
does not yet establish large-instance economics, compact independently
checkable minimality evidence, or a production cross-domain adapter API.  C983
should remain open until those three claims have direct evidence.

## Accepted continuation slice

The first scaling slice is implemented with no change to the legacy default:

- `compile_observational` remains the exhaustive-pair audit path;
- `compile_observational_with_policy` adds `QuotientOnly`, which emits the
  identical canonical quotient with zero pair records or path words;
- quotient-only constructs and replays the compact split proof internally,
  then discards it; later verification deterministically recomputes the same
  proof-producing quotient rather than trusting an uncertified artifact;
- class ranges are now checked for bounded contiguous exact coverage before
  any class-indexed access, closing the cross-sort artifact hole; and
- presentations pre-index generator IDs by source sort, and refinement now
  builds signatures in place with source-sort-sized capacity, removing global
  generator scans, state-to-sort searches, and the second continuation vector
  from the per-state/per-round path;
- exhaustive evidence can be generated directly into a generic sink or a
  framed `ERGSEP01` `Write` stream, normally `BufWriter<File>`, without being
  retained in the quotient; the same stream is verified canonically from a
  `Read` source one record and one generator word at a time, with no evidence
  or path buffer; interrupted or trailing-data streams are rejected; and
- a release-buildable Criterion harness covers fully separated carriers and
  adversarial long refinement chains, with separate quotient-only and bounded
  exhaustive cases.

Validation passes `cargo fmt --check`, strict all-target/all-feature Clippy,
the full all-feature Rust suite, the independent Python observational fixture
oracle, and release compilation of the benchmark. Interleaved timing, cold
RSS, and hardware-counter evidence is retained and replayable as described
below and in the SOTA report.

Streaming changes peak evidence residency from the complete record/path pool
to the current distinguishing search plus fixed reader/writer state.  It does
not change the quadratic record count or repeated product-search work, so it
is an audit/export mode and stepping stone, not a substitute for compact split
transcripts.

A hostile follow-up found and closed the main API footgun: the legacy
`compile_observational` entry point intentionally defaults to exhaustive
buffering, so a naïve compile-then-stream sequence would already have paid the
quadratic residency.  The public no-buffer route is therefore the integrated
`compile_observational_to_separator_stream`, which constructs a quotient-only
artifact and writes evidence directly.  The lower-level writer and reader
reject exhaustive compiled artifacts.

## Mystery ledger

- **Settled**: streaming completeness does not require an in-memory coverage
  set.  Canonical sort/left/right order lets the reader check exact coverage
  online.
- **Settled**: the default exhaustive API could silently defeat streaming.
  The integrated quotient-only compile-to-writer route and policy rejection
  close that ambiguity.
- **Settled**: streamed exhaustive evidence still has one product-state BFS per
  pair, but compact split mode eliminates that dependency entirely.  The
  accepted builder/replayer uses flat arrays and fixed-capacity reusable
  scratch pools, with no per-split allocation.
- **Settled**: the transcript policy now uses typed inverse CSR and a classical
  pending-aware small-half worklist as its quotient engine.  It does not run
  the synchronous reference minimizer first.  Flat fixed-capacity pools cover
  work items, pending keys, memberships, marks, touched blocks, and records;
  guarded pushes cannot allocate in the refinement loop.
- **Settled**: transcript replay now uses an independently checked inverse
  index, flat member positions, and in-place source-block partitions.  The
  verifier first proves that every inverse bucket is typed, duplicate-free,
  complete, and agrees with the forward table, closing the common-mode risk.
- **Settled -- sparse scheduling**: each generator chooses dense offsets or a
  sorted nonempty-target directory. A global target-state CSR contains only
  generators with nonempty predecessors, and pending membership uses an
  exact-footprint-selected dense bitmap or fixed-pool binary Patricia trie.
  Queue and pending capacity are
  bounded by the forward edge count `M`, not the target-dense envelope `D`.
  The `D=262,144, M=64` adversarial typed control, the former SplitMix
  collision family, and the allocation-growth gate pass.
- **Open -- separator extraction owner**: a split transcript proves
  inequivalence through nested context-definable blocks.  Deriving a compact
  explicit distinguishing word or Boolean context formula for a requested
  class pair from that proof DAG is cheap latent functionality, but is not yet
  implemented.
- **Open -- artifact/schema owner**: `ERGSEP01` is a low-level semantic stream,
  not an authenticated publication container.  A path may be replaced by a
  different valid separator; the identity tag is noncryptographic; atomic
  temp-file publication, digesting, hostile-input limits, and richer error
  diagnostics remain part of the versioned artifact task.
- **Settled -- direct evidence runner**: deterministic interleaved MATA and Boa
  runners, raw TSVs, hashes, and retained checkers now cover the production
  split-transcript product. Streaming/buffered exhaustive evidence remains a
  distinct audit-mode scaling experiment, not a prerequisite for the kernel
  comparison.
- **Open -- random-family crossover**: Boa's narrower partition-ID engine is
  still 2.48x faster on the four-generator random family, although ergodis
  wins the chain and native-output controls while returning quotient edges and
  verified evidence. The exact gap between dirty-signature refinement and the
  inverse small-half kernel is the highest-EV algorithm successor.
- **Open -- validated-input boundary**: the one-class fast path is 1,100x
  faster than MATA inside the compiler but only about 67x faster around the
  whole process because construction validates all 8.39 million input edges.
  Reusable validated/mapped presentations may expose more of the algorithmic
  win in streaming services; this has not yet been implemented or measured.
- **Open -- sparse crossover**: Patricia removes the hash worst case, but no
  large asymmetric application corpus yet measures its locality cost against
  the dense bitmap selector. The `D >> M` controls prove shape and allocation
  bounds, not throughput superiority.

## Compact split-transcript continuation

The next 30-minute continuation implements the compact proof mode.  Starting
from the typed observation partition, a transcript record

`(source_block, generator, splitter_block, new_block)`

certifies one nontrivial binary split by the inverse image of an already
defined target block.  The verifier independently rebuilds the observation
partition, replays every split, checks typing and nontriviality, and then checks
that the resulting partition agrees with the compiled quotient up to block
renaming.  Observation constancy and generator congruence remain separate
verification gates.  By induction, every current block is context-definable;
therefore every recorded split separates contextually distinguishable states.
Stable quotient soundness plus this refinement derivation proves exact
minimality.

Each `SplitRecord` is a fixed 16-byte `repr(C)` value with compile-time size and
alignment assertions.  The number of records is exactly final blocks minus
typed observation blocks, hence at most `classes - 1`, rather than the number
of separated concrete pairs.  All four cross-domain controls agree exactly:

| Control | exhaustive bytes | split records | transcript bytes | reduction |
|---|---:|---:|---:|---:|
| tropical WTA | 1,456 | 2 | 32 | 45.5x |
| resource batches | 57,180 | 26 | 416 | 137.5x |
| triangle recovery | 2,412 | 2 | 32 | 75.4x |
| hierarchical composition | 2,952 | 4 | 64 | 46.1x |

The accepted construction engine precomputes adaptive typed inverse CSR and a
target-state candidate CSR, then refines with fixed 8-byte work items and the
classical small-half rule. One pre-refinement footprint comparison selects a
dense pending bitmap for compact endomorphic universes or a fixed-pool binary
Patricia trie for `D >> M`; generic dispatch monomorphizes the hot loop. The
Patricia representation has 8-byte leaf keys, 16-byte `repr(C)` branch/free
records, iterative updates, and at most 64 branch decisions per operation. If
a split block already has pending work, both relevant children are scheduled;
otherwise only the smaller child is scheduled. For a fixed generator, live
blocks have disjoint nonempty inverse images, so queue and pending capacity is
at most `M = sum_g |source_sort(g)|`. Membership
ranges, marks, touched flags, transcript records, and block arrays are likewise
preallocated, and every hot push is capacity-guarded.
There are no owned dynamic containers in hot records and no allocation in the
refinement loop.  Inverse construction sorts sources once per generator and
chooses the smaller representation from dense offsets or a binary-searched
directory containing only nonempty target buckets.  The compact choice is
resolved once in each fixed 16-byte `InverseRecord`; 16-byte
`InverseTargetRecord` entries and all hot records are `repr(C)` with compile-time
size/alignment assertions. Candidate offsets cost `O(N)`, candidate IDs at
most `O(M)`, and generator metadata `O(G)`, giving `O(N+M+G)` scheduler and
inverse auxiliary storage even when `D = sum_g |target_sort(g)|` is
arbitrarily larger.

Large dense mutable membership sets are packed `u64` bitmaps rather than
byte-per-ID flags: dense pending work, predecessor marks, and touched-block
membership use one bit per logical slot; sparse pending membership uses the
Patricia pool. Monotone ownership remains range/CSR encoded. The
allocation gate compares 64-state and 1,024-state distinguishing chains and
forbids allocation-count growth proportional to the 960 additional splits; it
also exposed and repaired a geometrically growing quotient-transition vector.
All refinement and replay traversals are iterative over explicit bounded flat
queues/ranges, with no recursion or input-dependent process-stack depth.

Hardware specialization remains downstream of representation and state-count
work.  Dense bitmap scans and finite-field kernels are credible SIMD/GFNI
targets, but dispatch must occur once outside hot loops and every specialized
path must retain the scalar exact differential baseline.  The present inverse
worklist is dominated by indexed memory traffic and short irregular slices, so
no speculative AVX branch was added without a channel model and measurement.

This distinction sharpens the classical automata comparison.  Write

```text
G = number of generators,
M = sum_g |source_sort(g)|,    D = sum_g |target_sort(g)|.
```

`M` is the number of supplied deterministic transition edges, while `D` is the
current dense inverse/work envelope.  For an ordinary deterministic automaton
every letter is an endomap of the same carrier, so `M = D = |alphabet| |Q|`.
The classical edge-linear inverse representation is therefore a special case
in which the two parameters coincide.  Typed compositional systems need not
have that symmetry: a generator may map a tiny source sort into a huge target
sort, and then `D/M` can be arbitrarily large.  This is a genuine extra degree
of freedom exposed by the cross-domain generalization.

Inverse representation is selected once from presentation shape: dense offsets
win when their bytes do not exceed the nonempty-bucket directory; otherwise
sorted sparse buckets win. Candidate discovery is constructed in linear time
from those nonempty buckets into target-state offsets plus generator IDs.
Scheduling scans only candidate incidences in selected children. Thus ordinary
endomorphic automata recover the classical `M=D` specialization, while typed
systems retain the stronger `O(N+M+G)` storage statement when `D/M` is
unbounded. The explicit `G` term covers zero-source generators, which need not
be bounded by `M`.

Every binary split deterministically assigns the new block ID to the smaller
child (ties assign the marked child). Transcript replay derives the same
orientation from inverse-image cardinalities, so the 16-byte record needs no
flag. Candidate discovery therefore scans only a child at most half the size
of its parent. Charging a `(target state, generator)` incidence whenever its
containing block becomes that smaller child gives `O(M log N)` candidate work;
inverse-edge traversal has the same standard small-half charge. Dense pending
membership is exact constant time. Sparse membership uses the compressed
binary Patricia directory and therefore takes at most 64 branch decisions per
operation; the former fixed-hash collision family is a retained regression.

The worklist directly returns the quotient and transcript; `SplitTranscript`
no longer computes a synchronous reference quotient and then reconstructs its
proof.  A final linear canonicalization preserves the established class-ID
order. Quotient-only now proves through this path and discards the transcript;
the explicitly bounded exhaustive-pair audit retains the old synchronous
algorithm and its legacy round metric as a differential control. A hostile
review found a genuine stale-queue
bug in the first small-half implementation: a pending retained child could be
enqueued twice while the moved child was lost.  The independent congruence
verifier prevented an unsound artifact but compilation failed on a valid
10-state, four-generator system.  Pending-bit tracking repairs the classical
semantics, that exact system is now a permanent regression, and a second
hostile pass accepts the repair.

Transcript verification now builds its own inverse index, proves that index
against the complete forward table, and replays splits through flat member and
position arrays.  Each inverse bucket is source-typed, forward-correct,
duplicate-free, and collectively exhaustive before it is trusted.  This
removes the former all-state scan per split without making inverse-index
construction an unchecked common premise.  The replay loop is allocation-free
and handles source/splitter aliasing by collecting the full preimage before any
membership mutation.

The differential corpus now adds 256 typed random presentations with one to
four sorts, empty sorts, zero to four states per sort, and up to eight typed
generators.  It agrees class-for-class and sort-range-for-sort-range with the
synchronous reference, in addition to the earlier 128 cyclic systems and four
cross-domain fixtures.  The checked-in independent Python oracle also passes.
No wall/RSS claim is made before the interleaved measurement gate; transcript
replay, rather than worklist construction, is now the most obvious remaining
asymptotic suspect.

## Inverse-worklist performance control

The accepted benchmark harness alternates policy order on every round and has
a separate process-level `/usr/bin/time` runner for peak RSS.  Five release
rounds, ten Criterion samples per round, 0.5-second warmup, and 0.2-second
measurement windows give these medians of the five per-round point estimates:

| deterministic family | states / generators / classes | synchronous quotient-only | inverse worklist + transcript | ratio |
|---|---:|---:|---:|---:|
| long distinguishing chain | 256 / 1 / 256 | 3.526 ms | 34.129 us | 103.3x |
| already separated | 16,384 / 0 / 16,384 | 3.839 ms | 257.06 us | 14.9x |

These are whole-compilation measurements: quotient construction, compact
artifact emission, generic congruence verification, and independent transcript
replay are all included.  The chain result therefore confirms that the old
synchronous refinement wall has actually been removed, rather than merely
hidden behind certificate generation.  The already-separated control shows
that allocation-free initial observation sorting/canonicalization matters even
without generators: it replaces one tree node per distinct observation and
eliminates per-state signature vectors.

Median process peak RSS is 11,912 versus 11,416 KiB on the 256-state chain and
11,616 versus 11,868 KiB on the 16,384-state separated case.  The differences
range from -4.2% to +2.2% and are not treated as a stable memory delta; the
important bounded fact is that the typed inverse,
pending, and work pools do not create a scaling-sized RSS regression on these
controls.  Larger state/edge sweeps remain necessary before fitting an
empirical exponent or claiming parity with a mature automata implementation.

Replay:

```text
CARGO_TARGET_DIR=target-codex-193 scripts/observational-ab.sh 5 10 0.2
scripts/observational-memory-ab.sh \
  target-codex-193/release/deps/observational_compiler-<hash> 5
```

## EJ + TT closeout

The hostile worklist counterexample was the highest-value cheap extraction: it
turned an implicit scheduling assumption into an exact invariant, a flat
pending representation, and a permanent regression.  The verifier rewrite was
the next free gain; checking inverse CSR once against the forward presentation
allows near-worklist replay without sharing an unchecked proof premise.

The main Tao-style question is which quantity the generalized theorem should
actually measure.  The answer is not one undifferentiated “number of edges”:
typed systems expose both `M`, the forward edge count, and `D`, the target-dense
envelope.  Their equality is a hidden hypothesis of the classical endomorphic
automata setting.  Making that hypothesis explicit both explains why the
current backend is already optimal-shaped for classical DFA-like inputs and
identifies why the sparse backend is necessary for genuinely asymmetric
cross-domain applications. That backend is now implemented. The remaining
open work is a theorem-facing amortized proof, on-demand explicit separator
extraction, and versioned semantic/provenance artifact schemas.

A deterministic 128-instance bounded cyclic corpus additionally varies one-sort
carrier size through eight states, one to three endogenerators, observations,
cycles, and transition maps.  Exhaustive-pair, split-transcript, and
quotient-only policies produce identical canonical partitions throughout.
Malformed new-block IDs, unknown generators, omitted splits, empty sorts, and
an explicit cyclic self-split are rejected or replayed as appropriate.

## SOTA comparison and large-block repair

The direct comparison is documented in
`notes/2026-08-27-c983-observational-minimization-sota-comparison.md`.
The relevant implementation frontiers are MATA's maintained deterministic
Hopcroft/Valmari-style kernel, mCRL2 202607's default Groote--Jansen 2025
`O(m log n)` LTS kernel, and Boa's generic coalgebraic minimizer.

The first 131,072-state comparison exposed a quadratic defect hidden by the
256-state chain: `split_marked_block` chose a small splitter but rescanned the
entire source block.  The accepted repair maintains flat member positions and
per-block marked counts, completes inverse-image enumeration before mutating a
self-splitter, and swaps each marked state to the block boundary exactly once.
It adds no refinement-loop allocation or recursion.  The cold 131,072-state
chain fell from 3.834 s to 14.126 ms (271x).

Final seven-round controls at 131,072 states give 14.643 versus 23.502 ms on
the unary chain and 61.321 versus 202.485 ms on the four-generator random
family: 1.61x and 3.30x faster than pinned MATA despite transcript emission and
independent replay. Cold peak RSS is 16.2x and 13.2x smaller. More importantly,
the theorem-generated early paths give 11.5x on a native 256-output stable
partition, 547x on 131,072 states with 64 cyclic generators, and 1,100x on
65,536 states with 128 generators; the latter uses 31.9x less cold RSS. These are
scoped algorithmic cases, not a universal fastest-implementation claim.

The native Boa comparison sharpens the limit: ergodis is 1.81x faster on the
chain and 1.76x faster on 256 native outputs, but Boa's dirty-signature engine
is 2.48x faster on the random family. Boa returns canonical partition IDs;
ergodis also builds quotient transitions, retains a transcript, and verifies
it independently. This is a real adaptive-backend opportunity, not a reason
to weaken the current exact product.

At one million states and four generators, the initial hardware profile showed
ergodis executing more instructions but sustaining about 1.3 IPC versus
MATA's 0.7, consistent with the flat compact representation winning through
locality.  That profile selected inverse-index sorting, about 15% of sampled
cycles, as the next target.  The accepted adaptive constructor now uses stable
counting scatter when the target carrier is at most four times the source
carrier and retains comparison sorting for more asymmetric typed generators.
One source-sized `u32` permutation and one target-sized `u32` count/cursor
array are allocated once and reused across generators; there is no allocation
in either construction inner loop or refinement.

Seven interleaved old/new rounds on the 1,048,576-state, four-generator random
case reduce median whole compile-plus-transcript time from 2.065 s to 1.760 s:
14.8% less time, or 1.17x throughput.  Five non-multiplexed counter runs reduce
retired instructions from 13.149 B to 6.101 B, branches from 2.542 B to
1.275 B, and cycles from 10.020 B to 8.826 B.  Median cold peak RSS remains
within measurement noise at about 178.4 MiB.  The unary chain is neutral in
time and pays only the reusable target scratch (about 4 MiB at one million
states).  The change therefore removes the intended sort work without
sacrificing the sparse directory for `target >> source`.

On the final binary, three interleaved million-state random runs give 1.762 s
for ergodis versus 2.554 s for MATA, a 1.45x compiler advantage. Three
non-multiplexed process-counter repetitions give 5.511 versus 10.215 billion
instructions, 8.122 versus 13.841 billion cycles, and 1.152 versus 1.878
billion branches. Ergodis pays 18.219 versus 12.103 million branch misses for
its irregular proof bookkeeping, but retires 46% fewer instructions and 41%
fewer cycles overall. The profile still assigns about 11% to independent
transcript replay; the dense random gap to Boa cannot be explained by proof
verification alone.

## Final EJ + TT closeout

The final cheap upgrades were not cosmetic. Red-team converted the sparse
hash caveat into an explicit collision family and then into a deterministic
Patricia backend; the quotient-only benchmark exposed a second quadratic route
that ordinary transcript benchmarks could not see. Both now have permanent
regressions. The strongest general statement is consequently about a
many-sorted Moore congruence with separate `N`, `M`, `G`, and target envelope
`D`; classical complete DFA minimization is the `M=D` one-sort corollary.

The Tao-style unresolved question is now algorithm selection rather than
whether the small-half kernel scales. Boa wins the dense random control with a
dirty-signature method, while ergodis wins the long-chain and native-output
controls and produces a strictly richer verified artifact. A serious next
backend should therefore be an adaptive, proof-producing signature/dirty-state
engine sharing the same canonical quotient and transcript verifier—not a
replacement of the current kernel. The other genuine mysteries and their
exact evidence gaps are recorded in the refreshed ledger above; no additional
unowned mystery was manufactured.
