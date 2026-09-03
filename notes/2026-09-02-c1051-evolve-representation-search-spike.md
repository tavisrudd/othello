# C1051 Evolve representation search spike

**Lane:** `complete-ports`

**Date:** 2026-09-02 · **Status:** spike complete; go/no-go below. No paper claim, no public-core edit, uncommitted.
Changed paths: `ergodis-private/src/repr_grammar.rs`, one `pub mod` line in
`ergodis-private/src/lib.rs`, `ergodis-private/tasks/tools/src/repr_search/`, the `ReprSearch`
arm in `tasks/tools/src/main.rs`, and `ergodis-private/evidence/c1051-*`. Replay from
`ergodis-private`:
`cargo run --release -p ergodis-tools -- repr-search --report evidence/c1051-repr-search.json`,
adding `--deterministic` for the timing-free run.

## Question and answer

Can an evolve-style search over a typed grammar of lossless encoders rediscover a known good
representation, scored by exact space plus the measured compute every operation implies, and
admitted only on round-trip identity? **Yes for the control family, with one correction to the
control and one caveat about the scalar objective.** The control is R4 from
`notes/2026-09-02-ergodis-core-perf-quick-wins.md`: the bounded subset-sum reachability row as
`window-clip . bitpack`.

## Grammar

Three observation families: a strictly increasing id list over a large universe, a membership
set over a contiguous range, and an order-bearing vector of small integers. Four value
transforms — window-clip (subtract the elementwise minimum into the header base), delta,
zigzag, canonical permutation — compose up to two deep, then one of seven serializers: identity
(eight fixed bytes), narrow (bit-width narrowing), varint (LEB128), Elias–Fano with a rank
directory, run-length, bitpack (window-relative dense bitmap), and dictionary (hash-consing of
four-element blocks). Composition depth is capped at three grammar nodes.

A third axis says **where the shape information lives**, a first-class searched dimension:

| Descriptor | Space per structure | What it removes |
|---|---|---|
| `runtime-header` | 64 B `#[repr(C, align(64))] EncodedHeader` | nothing; the baseline |
| `packed-word` | 8 B `#[repr(transparent)] PackedDescriptor(u64)`, typed bit-field accessors | 56 B and a cache line per structure; four field loads become one word load plus shifts |
| `type-carried` | 0 B | the descriptor entirely: width, base, and element count are const-generic parameters of the compiled consumer, so the shift, mask, and extent bound are compile-time constants |

`type-carried` is admissible only for `narrow` and `bitpack`, whose layout is fixed by a
plan-time constant; varint, run-length, and dictionary streams have data-dependent layouts no
const generic can carry. Its probe is a real monomorphization: `narrow_contains_dispatch` picks
one of 64 instantiations of `contains_const::<WIDTH>` **once, outside the probe loop**, as the
contract requires; `probe_batch` is the measured entry point for every candidate, so the
comparison is fair.

The precedent is the public core's `ergodis::field::Prime<P>`: the modulus is a const-generic
parameter of the `FiniteField` implementation, statically dispatched, never loaded in a kernel.
Three further type-level items are implemented and tested here as reusable pieces.
`Slot(NonZeroU32)` gives `size_of::<Option<Slot>>() == 4` against `size_of::<Option<u32>>() == 8`
— the core contains no `NonZero` type at all, so every optional index in a hot record pays a
byte it need not. `Residue<const Q: u8>` puts the modulus in the type: size 1, no stored
modulus, no runtime bound check. `FixedSlots<T, CanonicalOrder, N>` puts the length in the type
and carries the canonical-order proof in `PhantomData`, removing the length field and the
runtime sortedness check. All are `#[repr(C)]`/`#[repr(transparent)]` with
`const _: () = assert!(size_of…)` guards, so a layout regression fails the build.

## Scorer

Per candidate and instance the harness records the full cost vector, not a scalar:
`encoded_bytes` (descriptor + payload + every precondition table, exact), `encode_cycles`,
`decode_cycles` (full materialization), `probe_cycles` (per random-access probe, 16.16 fixed
point), `precondition_cycles` (rank/select directory, dictionary construction — measured
separately and subtracted out of the encode figure so it is never double-counted),
`peak_working_bytes` (caller-owned staging touched during encode and decode), and
`syntax_cost`. Cycles come from the invariant time-stamp counter; neither crate has a reusable
performance-counter harness, so these are labelled reference cycles throughout, taken as the
median over 7 rounds of 4 iterations after 2 warm-up rounds.

The declared scalar objective charges one weighted unit per byte and one per reference cycle,
with per-operation weights set by how often each operation runs in real usage of that family: a
reachability row is encoded once per item and probed once per element during the backward
witness replay, never fully decoded (`encodes 1, decodes 0, probes n`); a certificate id array
is encoded once and decoded once at replay, never probed (`encodes 1, decodes 1, probes 0`); a
witness vector is built once and read by index many times (`encodes 1, decodes 0, probes n`). A
second weight-free ranking (bytes, then probe cycles) is reported beside it.

## Admission

All of these must hold, checked before any score is recorded: round-trip identity on the
training observation and on two held-out observations generated from a **different seed**;
exact agreement with the reference observation on every query of a fixed probe schedule, on
training and held-out alike; and **zero allocator events** in the decode and probe paths,
measured by a counting global allocator in the tools binary. A candidate that allocates is
rejected, not scored. Encode, decode, probe, and every precondition table run over a
caller-owned presized `ReprWorkspace`; the scorer's probe-answer buffer is presized too.

## Instances

| Instance | Kind | n | universe | reference B | entropy bound B |
|---|---|---:|---:|---:|---:|
| subset-sum-24 | dense bitmap | 62 | 129 | 496 | 16 |
| subset-sum-40 | dense bitmap | 436 | 958 | 3488 | 118 |
| subset-sum-56 | dense bitmap | 1273 | 2750 | 10184 | 342 |
| sparse-sorted-ids | sorted ids | 512 | 1048576 | 4096 | 796 |
| clustered-runs | dense bitmap | 2515 | 8192 | 20120 | 910 |
| witness-vector | small ints | 1024 | 64 | 8192 | 768 |

Every fingerprint (SHA-256 over kind, universe, length, and values), training and held-out, is
in `evidence/c1051-repr-search.json`. The three subset-sum instances are reachability rows of real `BoundedSubsetSumPlan` solves at
target 0, item counts 24/40/56 (at or below 56 so the exact subset count cannot overflow `u64`)
and weight magnitudes 9/40/90. `BoundedSubsetSumPlan::reachability` is private, so the rows are
recomputed from the plan's public inputs by the same continuation-window recurrence, and **the
recomputation is cross-checked exactly against the plan's public `transition_bound()`** — that
check fails if the windows differ from the ones the solve uses. Each plan is also solved through
`certificate()` before its rows are used.

## Results

Weighted objective (W) and bytes-first (B) rankings; probe is reference cycles per probe, and
full vectors per candidate are in the evidence file.

| Instance | W1 | bytes | probe | B1 | bytes |
|---|---|---:|---:|---|---:|
| subset-sum-24 | `bitpack . type-carried` | 9 | 15.8 | `window-clip . bitpack . type-carried` | 8 |
| subset-sum-40 | `bitpack . type-carried` | 55 | 15.7 | `delta . run-length . packed-word` | 32 |
| subset-sum-56 | `canonical-permutation . bitpack . packed-word` | 171 | 14.9 | `canonical-permutation . bitpack . type-carried` | 163 |
| sparse-sorted-ids | `delta . varint . packed-word` | 1004 | 1529.8 | `canonical-permutation . delta . narrow . type-carried` | 960 |
| clustered-runs | `bitpack . type-carried` | 1002 | 11.5 | `zigzag . delta . run-length . packed-word` | 344 |
| witness-vector | `identity . packed-word` | 8200 | 11.8 | `narrow . type-carried` | 768 |

Admitted: 166–186 of 224 on the membership families, 89 of 224 on the vector family. Rejections
are typed and structural, never silent — `NotASet` (bitpack on a non-strictly-increasing
stream), `NotMonotone` (Elias–Fano after delta), `NegativeValue` (varint or narrow on a delta
stream without zigzag), `OrderNotFree` (canonical permutation on the vector family, the node the
round-trip test exists to catch). No candidate was rejected for allocating, so every grammar
node's decode and probe path is allocation-free as implemented.

### Was the control rediscovered?

**Yes, in the strong form.** On `subset-sum-24` the byte-optimal answer over the whole grammar *is* the control, in its
type-carried descriptor: `window-clip . bitpack . type-carried` at 8 bytes, rank 1 by bytes.

On `subset-sum-40` and `subset-sum-56` the search returns a bitpack whose descriptor moved into
the type, and it **dominates the control on every coordinate**: on subset-sum-56,
`bitpack . type-carried` costs 163 B against 227 B, 15.4 against 16.4 probe cycles, 4245 against
7885 encode cycles, and 1875 against 2320 decode cycles.
The reason is exact and checkable: for a symmetric weight multiset at target 0 a middle row's
continuation window already starts at index 0, so the elementwise minimum is 0 and window-clip
is a no-op that still pays an extra pass over the row at encode time. R4's claim that clipping
the empty prefix pays is therefore **instance-dependent, not general**, and the search found the
counterexample unprompted.

The control's runtime-header form ranks 15–18 on the reachability rows by the weighted objective
and 12–63 by bytes, and the whole gap to rank 1 is the descriptor axis: on subset-sum-24 the row
payload is 8 bytes and the runtime header is 64, so the header is 89% of the stored structure. A reachability bitmap
has n+1 rows sharing one width and one base, so a per-row descriptor is pure overhead — this is
the single largest finding of the spike and it is not in R4.

### The two synthetic distributions against the entropy bound

Sparse sorted ids: `delta . varint . packed-word` at 1004 B under the weighted objective and a
delta-narrow composition at 960 B by bytes, against a `log2 C(2^20, 512)` bound of 796 B — 1.21×
the bound, the expected answer for near-uniform gaps, the residual being varint's byte
granularity and narrow's fixed width against a geometric gap distribution.

Clustered runs: `delta . run-length . packed-word` at 344 B, **below** the 910 B binomial
bound. That is correct and instructive — the binomial bound prices a uniformly random subset and
this source is not one — and it shows concretely that a combinatorial bound overstates the floor
for a structured source.

Witness vector: `narrow . type-carried` at 768 B, which is 1024 × 6 bits exactly, equal to the
`n log2(alphabet)` bound to the byte. The search hit the bound exactly.

### Search cost

The whole grammar is 224 pipelines. The bounded evolution engine — the public core's
`theorem_search::drive_ranked_evolution_streaming` with `RankedEvolutionDriver` and
`select_quality_diversity_parents` niched on the serializer, used unchanged — needed 112–128
distinct evaluations, 50–55% of exhaustive. It matched the exhaustive optimum on two of six
instances in the recorded run and three of six in an earlier one; every miss was a different
member of a set of candidates tied on bytes and separated only by probe-cycle noise (for
example `canonical-permutation . bitpack . type-carried` against `bitpack . type-carried`, both
163 bytes, on subset-sum-56). A factor of two over enumeration is not yet a reason to prefer
it.

## What a real task would need

1. **Objective calibration.** One byte weighted equal to one reference cycle is arbitrary, and
   it is why the weighted ranking picks `identity` at 8200 B over `narrow` at 768 B on the
   witness vector. Declare an exchange rate from a measured setting (bytes moved per cycle at
   the relevant cache level) or use a lexicographic order with an explicit space budget.
2. **Probe-cycle noise.** Differences below roughly 1 reference cycle per probe do not
   discriminate, and the objective multiplies them by n. Widen the schedule to thousands of
   queries, or use the paired interleaved A/B the core contract already mandates.
3. **Grammar gaps.** No bitplane or transposed SIMD layout, no Roaring-style per-block hybrid,
   no frame-of-reference coding, no partitioned Elias–Fano, and no cross-structure dictionary.
   The last is the one worth closing first: the dictionary node is per structure, so the
   descriptor shared across n+1 reachability rows is reachable only through the descriptor axis.
4. **Admission lifecycle.** Admission here is a local function. Under the C985
   proposal/admission architecture it belongs behind a typed `ProposalEnvelope`: role
   `exact reduction` (a representation change alters no verdict), obligations "round-trip
   identity on the declared corpus" and "probe agreement on the declared schedule",
   normalization to the canonical pipeline form, a source fingerprint binding the corpus, and an
   `AdmissionReport` carrying the cost vector as independently recomputed metrics. The
   cold-compiler step is the monomorphization choice for a type-carried candidate.
5. **Peak working memory does not discriminate here.** Every candidate shares the staging
   buffers; a real scorer should charge each serializer for the scratch it actually needs.

## Go/no-go

**Go, narrowly scoped.** The mechanism works end to end: a typed grammar, an exact-plus-measured
cost vector, admission by round-trip identity and probe agreement against held-out instances,
and a search that rediscovers the control or something that provably dominates it. The bankable
result is not the search but what it surfaced — the per-structure descriptor dominates the cost
of small structures, and moving it into the type is free at runtime. That is a concrete, gated
change to propose against the subset-sum bitmap.

Do **not** promote the evolution engine as the mechanism yet. At 224 candidates exhaustive
enumeration is cheaper to trust and only twice the cost; evolution earns its place once the
grammar outgrows enumeration, which needs the missing nodes above.

Nothing here is a discovery outside the grammar: every result is a pipeline the enumerator names,
measured against the exhaustive ranking as ground truth.

## Gates

Run in `ergodis-private` through `~/.claude/bin/run-quiet`:

- `cargo fmt --all --check` — exit 0
- `cargo check --workspace --all-targets` — exit 0
- `cargo clippy --workspace --all-targets -- -D warnings` — exit 0
- `cargo test --workspace` — exit 0; 7 new `repr_grammar` tests pass: round trip over every
  applicable pipeline on three families, probe agreement over the whole universe, vector `get`
  agreement, window-clip byte saving, canonical-permutation rejection on an order-bearing
  family, type-carried probe equality with zero descriptor bytes, packed-descriptor round trip
- Determinism: two `--deterministic` runs byte-identical, sha256
  `849d20f5a88ae4954a09f7554e0cddd04b11637182d3c6abfcd1e97576914f3e`

## Mystery ledger

- **Settled by this pass.** Why the control does not win outright: window-clip is a no-op
  whenever the continuation window already starts at index 0, the common case at target 0 with a
  symmetric weight multiset. Why the first run ranked every packed encoder last: bit extraction
  was a per-bit loop, so the scorer measured the harness; with one unaligned 16-byte
  read-modify-write the packed encoders win their families.
- **Open — clustered runs beat the binomial bound by 2.6×.** Expected in direction, unexplained
  in size. The exact gap between `log2 C(u, n)` and the true source entropy of the clustered
  generator is computable in closed form and was not computed. Owner: whoever calibrates the
  objective in item 1 above; the bound is what the space term is normalized against.
- **Open — the weighted winner is not stable across runs.** Repeated runs permute the
  equal-byte candidates at the top of every membership instance, so evolution's two-to-three
  matches out of six may measure the objective's resolution rather than the engine. Gate: rerun
  with a probe schedule wide enough to separate the top three by more than their spread.
- **Open — the dictionary node never wins anywhere,** not even on the witness vector, built
  with heavy run structure to reward it. Either the four-element block length is wrong for these
  sources or the hash-consing table's space charge swamps its payload saving; one experiment.
- No mystery is claimed about the type-carried result: its zero runtime cost follows from the
  monomorphization, confirmed by the probe-equality test and the layout assertions.
