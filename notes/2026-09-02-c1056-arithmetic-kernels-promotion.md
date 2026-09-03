# C1056 — arithmetic kernels core promotion (2026-09-02)
**Lane**: `complete-ports`.

Worktree `/home/tavis/.cache/ergodis/wt/c1056-arithmetic-kernels`, branch
`c1056-arithmetic-kernels`, build directory `~/.cache/ergodis/target/c1056`.
Nothing outside that worktree was modified except this report.

## What was promoted

Three allocation-free kernels moved from the private library into one core
module, `src/arithmetic/`, with four files:

| File | Contents |
|--------------------------------|--------------------------------------------------------------------------|
| `src/arithmetic/mod.rs`        | module docs and re-exports                                                |
| `src/arithmetic/two_adic.rs`   | 2-adic autocorrelation lift and the binary orbit quadratic form           |
| `src/arithmetic/subgroup.rs`   | subgroup membership over `Z / 2^k` by minimum-valuation pivoting          |
| `src/arithmetic/xor_sumset.rs` | fixed-width `XOR` sumsets on membership bitmaps                           |
| `src/arithmetic/bitmap.rs`     | the one word-packed membership bitmap the module and subset sums share    |

The module is declared and documented in `src/lib.rs`, and its entry points are
re-exported at the crate root alongside the other kernels.

### The bitset merge

The task required not landing a second bitset structure. `bitmap.rs` holds one
representation: free functions `set_bit` / `get_bit` over a `&[u64]` row, plus
`FixedBitmap<const WORDS: usize>`, a `#[repr(transparent)]` wrapper over
`[u64; WORDS]` for the compile-time-width callers. `bounded_subset_sum.rs` had
private `set_bit` / `get_bit` helpers of exactly this shape; those are deleted
and its reachability rows now call the shared ones, so the subset-sum
reachability bitmap and the sumset kernel are the same representation. The
sumset kernel takes and returns `FixedBitmap`, so no raw `[u64; 4]` type leaks
into the public surface.

`src/bitset.rs` is untouched: it is a heap-allocating, run-time-width
`BitSet` for cold set algebra, a different object from the fixed-width hot
bitmap, and merging them would have pulled an owned container into the kernels.

## API

```rust
// two-adic lifting
lift_autocorrelation<const N: usize>(&[u16; N], &[u8; N], shift, exponent) -> Result<u16, TwoAdicError>
lift_autocorrelation_slices(&[u16], &[u8], shift, exponent)               -> Result<u16, TwoAdicError>
autocorrelation_total_from_row_sum(row_sum, exponent)                     -> Result<u16, TwoAdicError>
synthesize_binary_orbit_autocorrelation_form<N, CLASSES, SHIFTS>(..)      -> Result<BinaryOrbitQuadraticForm, _>
prove_binary_orbit_autocorrelation_invariant<N, CLASSES, SHIFTS>(..)      -> Result<bool, TwoAdicError>

// subgroup membership over Z / 2^k
subgroup_membership_z2k<const DIM: usize>(&[[u16; DIM]], [u16; DIM], exponent)
    -> Result<SubgroupMembership<DIM>, SubgroupError>
SubgroupMembership::<DIM>::quotient_residue() -> [u16; DIM]

// fixed-width XOR sumsets
xor_sumset_into<const WORDS: usize>(&mut FixedBitmap<WORDS>, &FixedBitmap<WORDS>, &FixedBitmap<WORDS>, u32)
xor_sumset_256_into(&mut FixedBitmap<4>, &FixedBitmap<4>, &FixedBitmap<4>, u8)

// shared bitmap
FixedBitmap::<WORDS>::{empty, full, from_words, words, words_mut, clear, contains, insert,
                       is_full, is_empty, len}
set_bit(&mut [u64], usize) / get_bit(&[u64], usize)
```

Constants: `MAX_ORBIT_CLASSES = 64`, `MAX_SUBGROUP_GENERATORS = 64`,
`MAX_SUBGROUP_DIMENSION = 64`. Errors are `TwoAdicError` and `SubgroupError`.

## Generalizations

1. **Carrier length.** Nothing in the module ties a length or modulus to a
   particular family. The autocorrelation lift keeps the const-generic length
   `N` as its hot entry point and gains `lift_autocorrelation_slices` for a
   length known only at run time, with a `LengthMismatch` error for mismatched
   base and lift vectors; a test sweeps every carrier length from one to nine
   against the direct double sum.
2. **Coordinate count.** The subgroup kernel was fixed at eight coordinates.
   It is now const-generic in `DIM` (validated in `1..=64`, new
   `InvalidDimension` error), with `SubgroupMembership<DIM>` carrying
   `[u8; DIM]`, `[u16; DIM]`, and `[[u16; DIM]; DIM]`. Tests run brute-force
   parity at two, five, and eight coordinates and check that padding an
   eight-coordinate system out to twelve does not change the decision.
3. **Sumset width.** The sumset was hardcoded at 256 elements. It is now
   const-generic in `WORDS`, with a compile-time assertion that `WORDS` is a
   power of two, since the universe must be closed under `XOR`. `WORDS = 4`
   reproduces the old width and is kept as the named `xor_sumset_256_into`;
   parity is asserted at 256 between the general kernel, the fixed one, and an
   independent pair loop, and separately at 1024 elements.

### One deliberate behavior change

The retained sumset saturated its output whenever either operand was full,
including when the other operand was empty, where the true sumset is empty. The
promoted kernel returns the empty set there. Every nonempty fixture agrees with
the retained outputs; `tests/arithmetic_reference_parity.rs` asserts both sides
of this divergence explicitly so it cannot be mistaken for drift.

The lift's error precedence also changed as a side effect of the hot-loop
change described below: both vectors are now validated in full before
accumulation, so an input with both an out-of-range base coordinate and a
nonbinary lift coordinate reports the base fault. The accept/reject decision is
unchanged, and a fail-closed test pins the precedence.

## Acceptance gates

### Parity per kernel

`tests/arithmetic_reference_parity.rs` embeds verbatim transcriptions of all
three retained implementations at their original fixed widths and drives them
against the promoted entry points on generated fixtures: the lift over six
exponents times 512 seeds times 24 shifts, the eight-coordinate reduction over
three exponents times 384 seeds with all five reported fields compared
(`contains`, `pivot_count`, `pivot_valuations`, `transformed_target`,
`row_transform`), and the sumset over 256 pseudorandom operand pairs. Every
in-module test from the private sources is ported, including the exhaustive
oracles, the fail-closed tests, and the row-transform replay test.

### Zero allocation

All three private zero-allocation tests are carried over unchanged in substance
onto the core harness: `crate::test_alloc::measure_current_thread_allocations`,
asserting `AllocationEvents::default()` (zero allocations, reallocations and
deallocations) rather than only an allocation count. A fourth such test covers
the lift itself, which the private module did not have.

### Validation, verbatim

```
$ cargo fmt --check
fmt exit=0
$ cargo clippy --all-targets --all-features -- -D warnings
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.28s
clippy exit=0
$ cargo test --all-features
     Running unittests src/lib.rs
test result: ok. 611 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 45.11s
     Running tests/arithmetic_reference_parity.rs
test result: ok. 4 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.04s
     Running tests/bp_osd.rs
test result: ok. 7 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s
     Running tests/cli.rs
test result: ok. 8 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.01s
     Running tests/contextual_allocations.rs
test result: ok. 26 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.16s
     Running tests/feature_theorem_evolution.rs
test result: ok. 3 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.03s
     Running tests/observational_compiler.rs
test result: ok. 10 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.02s
     Running tests/parametric_certificate_python_parity.rs
test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s
     Running tests/python_parity.rs
test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.02s
     Running tests/rpc_jsonl.rs
test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s
   Doc-tests ergodis
test result: ok. 4 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.14s
```

Every binary target's unit tests also pass (`bench_kernels` 3, `ergodis` 5,
`ergodisctl` 8, `css_distance_shard_ledger` 9, and the rest zero or two, all
`ok`); 22 test binaries report `ok` in total and none reports a failure.

## Hardware-counter A/B on the lift

The autocorrelation lift is the only one of the three kernels that sits inside
a hot loop, so it is the one with a counter A/B. `examples/arithmetic_lift_ab.rs`
runs one of two variants on identical deterministic inputs: `retained`, a
verbatim copy of the retained fixed-array kernel, and `core`, the promoted
entry point. Both print the same checksum (`51200000` at 200,000 rounds over a
64-element carrier), so the comparison is over identical work.

Design: single thread pinned with `taskset -c 3`, release profile, six
interleaved rounds alternating `retained` and `core`,
`perf stat -e instructions,cycles,branches,branch-misses`. Parallel and
contention dimensions do not apply; the kernel touches only caller-owned stack
data.

Binary: `~/.cache/ergodis/target/c1056/release/examples/arithmetic_lift_ab`,
SHA-256 `a68fca4ddb4e9a0219a5d165090d15bae7f99fc475d1e0bcfa1b68ae73f06345`.

| Round | retained instructions | core instructions | retained cycles | core cycles | retained branches | core branches | retained br-miss | core br-miss |
|-------|----------------------:|------------------:|----------------:|------------:|------------------:|--------------:|-----------------:|-------------:|
| 1     | 20,777,152,138        | 11,486,352,250    | 4,181,912,922   | 3,126,096,321 | 2,496,269,952   | 469,269,667   | 208,368          | 407,592      |
| 2     | 20,777,153,677        | 11,486,352,006    | 4,816,929,202   | 3,145,553,060 | 2,496,270,575   | 469,269,607   | 208,983          | 407,705      |
| 3     | 20,777,152,990        | 11,486,352,328    | 4,841,938,105   | 3,153,663,404 | 2,496,270,347   | 469,269,725   | 209,427          | 407,701      |
| 4     | 20,777,152,761        | 11,486,352,419    | 4,813,408,769   | 3,142,551,073 | 2,496,270,247   | 469,269,692   | 208,937          | 407,677      |
| 5     | 20,777,152,252        | 11,486,351,817    | 4,845,267,479   | 1,856,144,168 | 2,496,270,014   | 469,269,237   | 209,113          | 406,437      |
| 6     | 20,777,152,395        | 11,486,351,695    | 2,956,660,918   | 1,893,790,616 | 2,496,269,685   | 469,269,188   | 208,245          | 408,345      |

Instructions fall 44.7% (20.78G to 11.49G) and branches fall 81.2% (2.496G to
0.469G); the per-round cycle ratio is 0.75, 0.65, 0.65, 0.65, 0.38, 0.64, median
0.65. Rounds 5 and 6 sit in a lower absolute band for both variants — the
machine's frequency shifted partway through — which is exactly what the
interleaving is for: the paired ratio holds across the shift, and only round 5
straddles it. Branch misses roughly double in absolute terms, from 209 thousand
to 408 thousand, which is 0.09% of the core variant's branches and is dwarfed by
the two billion branches removed.

The mechanism: the retained kernel re-validated each base and lift coordinate on
both of the two reads the cyclic index pattern gives it, so validation was two
branches per element inside the accumulation loop. The promoted kernel validates
each vector once, in full, before accumulating. The accept/reject decision is
identical; only the reported error kind for simultaneously malformed base and
lift changes, as noted above and pinned by a test.

A first attempt routed the const-generic entry point through the run-time-length
one, which cost 40% more instructions and 47% more cycles than the retained
control (29.02G against 20.78G instructions; 7.15G against 4.83G cycles) because
the length and index bounds stopped being compile-time constants. That variant
was rejected and the two entry points now have separate bodies; the doc comment
records why, so a future refactor does not re-merge them. This is the negative
control the performance contract asks to be recorded.

## Proposed kernel-registry rows

Described only; nothing under `~/src/ergodis-private` was edited.

| Kernel | Core path | Status | Note |
|---------------------------|-----------------------------------|---------------|--------------------------------------------------------------------|
| two-adic autocorrelation  | `ergodis::arithmetic::two_adic`   | promoted      | private copy now redundant; length parameterized, validation hoisted |
| subgroup over `Z / 2^k`   | `ergodis::arithmetic::subgroup`   | promoted      | coordinate count const-generic in `DIM`, was fixed at eight          |
| fixed-width `XOR` sumset  | `ergodis::arithmetic::xor_sumset` | promoted      | width const-generic in `WORDS`; empty-operand result corrected       |
| membership bitmap         | `ergodis::arithmetic::bitmap`     | new, shared   | one representation for the sumset and subset-sum reachability rows   |

Each private module can be deleted in favor of a re-export of the core entry
point; the sumset call sites need the signature change to `FixedBitmap` and
should be checked for reliance on the old empty-operand saturation.

## Commits on `c1056-arithmetic-kernels`

- `f772762` Promote the allocation-free arithmetic kernels into one core module
- `4760457` Hoist the autocorrelation lift's input validation out of its inner loop

Branch tip: `4760457`. No public-facing file names a task, a private module, a
campaign, or an order.
