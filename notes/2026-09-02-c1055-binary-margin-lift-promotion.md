# C1055 — binary_margin_lift core promotion (2026-09-02)
**Lane**: `complete-ports`.

Work is in the git worktree `/home/tavis/.cache/ergodis/wt/c1055-margin-lift`, branch
`c1055-margin-lift` of `~/src/ergodis`. Builds used
`CARGO_TARGET_DIR=/home/tavis/.cache/ergodis/target/c1055`.

## Status

Complete. All acceptance gates pass; nothing outside the core worktree was modified except this
report.

## Source reviewed

- `~/src/ergodis-private/src/binary_margin_lift.rs` (the private kernel to promote), hardcoded to
  18 rows and 29 columns, with signed compressed coefficients centred on those two widths.
- Bounded search of `~/src/ergodis-private/python/` for a Gale–Ryser / margin-liftability oracle
  found none: the only margin-adjacent Python is `semantic_rank_core.py`, which is domain-bound
  and does not decide liftability. A standalone dependency-free oracle is therefore written into
  the core's `python/`.

## What was promoted, and what changed

The private kernel decided Gale–Ryser liftability for a fixed 18×29 shape, parsed margins only in
the private signed-coefficient encoding, and returned an error when the two totals disagreed.
The core module keeps the mathematics and generalizes everything else.

1. **Widths are compile-time parameters.** `MarginPair<ROWS, COLUMNS>` and
   `MarginLiftWorkspace<ROWS, COLUMNS>` replace the two fixed-width structs. Every buffer is still
   an inline fixed array and both entry points are still allocation-free; the dimensions are now
   monomorphized per call site rather than baked into the module. Any shape up to
   `MAX_MARGIN_DIMENSION = 255` on each side is accepted, enforced by a `const` layout assertion
   that also pins `align_of == 64` and `size_of % 64 == 0` for both structs.
2. **The signed encoding became a domain-neutral codec.** `decode_centered_margins` documents the
   transmission as "a count `k` out of `n` positions sent as `2k - n`", checks range and parity on
   both axes, and returns ordinary degrees. The 18/29 constants, the odd/even asymmetry, and the
   private naming are gone; the parity condition now follows from the transverse dimension.
3. **Unequal totals are a verdict, not an error.** Margins whose totals differ have no lift, so
   the kernel returns `Ok(false)`. Errors are reserved for out-of-range degrees, malformed centred
   coefficients, and a wrongly sized output buffer. This makes the kernel's answer agree with a
   brute-force enumeration on every input rather than on a filtered subset.
4. **The output is width-independent.** The private constructor returned `[u32; 18]`, silently
   capping the design at 32 columns. The core constructor writes a row-major bit matrix into a
   caller-supplied `&mut [u64]` of `margin_lift_matrix_words(ROWS, COLUMNS)` words, so it handles
   100- and 200-column shapes with no allocation and no representation change.
5. **The prefix test uses the conjugate partition.** The private decision recomputed
   `sum_b min(k, c_b)` from scratch for each of the 18 prefixes, an `O(ROWS · COLUMNS)` inner loop.
   The core builds the conjugate counts once and accumulates them, so the decision is
   `O(ROWS² + COLUMNS)` with the row insertion sort dominating.
6. **Column ordering is canonical and linear.** The private constructor re-sorted a *persistent*
   column permutation on every row, so ties were resolved by the order the previous row left
   behind — the constructed matrix depended on history. The core orders columns by decreasing
   remaining capacity with ties broken by column index, via a counting sort over the `ROWS + 1`
   possible remaining degrees. This is both canonical (the Python oracle reproduces the matrix
   bit for bit) and asymptotically cheaper; see the counter section for the measured trade.

No task identifier, private module name, campaign name, or Hadamard/order-2092 vocabulary appears
in the module, the example, the oracle, or the parity test; a scan for all of those terms over the
four new files returns nothing. `tests/publication-guards.sh` passes (44 checks, 0 failures).

## Files

| Path | Role |
|-------------------------------------------------|--------------------------------------------------|
| `src/binary_margin_lift.rs`                      | The promoted kernel and its unit tests           |
| `src/lib.rs`                                     | `pub mod binary_margin_lift` plus the re-exports  |
| `python/binary_margin_lift_oracle.py`            | Standalone dependency-free oracle and generator   |
| `tests/fixtures/binary_margin_lift_cases.json`   | Generated oracle fixture (54 KB)                  |
| `tests/binary_margin_lift_python_parity.rs`      | Differential replay of the fixture               |
| `examples/binary_margin_lift_counters.rs`        | Single-thread hardware-counter workload           |
| `python/README.md`                               | How to regenerate and check the oracle fixture    |

## Public API

```rust
pub const MAX_MARGIN_DIMENSION: usize = 255;

pub struct MarginPair<const ROWS: usize, const COLUMNS: usize>;      // repr(C, align(64))
impl MarginPair {
    pub const fn new(row_degrees: [u8; ROWS], column_degrees: [u8; COLUMNS]) -> Self;
    pub const fn row_degrees(&self) -> &[u8; ROWS];
    pub const fn column_degrees(&self) -> &[u8; COLUMNS];
}

pub struct MarginLiftWorkspace<const ROWS: usize, const COLUMNS: usize>;  // repr(C, align(64))
impl MarginLiftWorkspace { pub const ZERO: Self; pub const fn new() -> Self; }

pub fn decode_centered_margins<const ROWS: usize, const COLUMNS: usize>(
    centered_rows: &[i16; ROWS],
    centered_columns: &[i16; COLUMNS],
) -> Result<MarginPair<ROWS, COLUMNS>, BinaryMarginLiftError>;

pub const fn margin_lift_matrix_words(rows: usize, columns: usize) -> usize;

pub fn binary_margin_lift_exists<const ROWS: usize, const COLUMNS: usize>(
    margins: &MarginPair<ROWS, COLUMNS>,
    workspace: &mut MarginLiftWorkspace<ROWS, COLUMNS>,
) -> Result<bool, BinaryMarginLiftError>;

pub fn construct_binary_margin_lift<const ROWS: usize, const COLUMNS: usize>(
    margins: &MarginPair<ROWS, COLUMNS>,
    workspace: &mut MarginLiftWorkspace<ROWS, COLUMNS>,
    matrix: &mut [u64],
) -> Result<bool, BinaryMarginLiftError>;

pub enum BinaryMarginLiftError {
    RowDegreeOutOfRange, ColumnDegreeOutOfRange,
    CenteredRowCoefficient, CenteredColumnCoefficient,
    MatrixBufferLength,
}
```

All of these are re-exported at the crate root from `src/lib.rs`.

## Gates

### Exhaustive small-case parity against brute force

`binary_margin_lift::tests::exhaustive_small_margins_match_brute_force_enumeration` enumerates all
`2^(ROWS · COLUMNS)` binary matrices for each of the sixteen shapes with `ROWS, COLUMNS ∈ {1,2,3,4}`,
collects the set of realisable margin pairs, and compares that set against the kernel's verdict on
*every* degree vector pair of those dimensions — including the unbalanced ones. Every pair the
kernel accepts is then constructed and its realised margins are checked back against the input.

```text
running 8 tests
test binary_margin_lift::tests::a_short_matrix_buffer_is_rejected ... ok
test binary_margin_lift::tests::dominating_rows_without_column_capacity_are_rejected ... ok
test binary_margin_lift::tests::centered_margins_round_trip_and_fail_closed ... ok
test binary_margin_lift::tests::out_of_range_degrees_fail_closed ... ok
test binary_margin_lift::tests::unequal_totals_are_unliftable_rather_than_malformed ... ok
test binary_margin_lift::tests::wide_margins_span_multiple_matrix_words ... ok
test binary_margin_lift::tests::repeated_decisions_and_constructions_allocate_nothing ... ok
test binary_margin_lift::tests::exhaustive_small_margins_match_brute_force_enumeration ... ok

test result: ok. 8 passed; 0 failed; 0 ignored; 0 measured; 465 filtered out; finished in 0.70s
```

### Differential agreement with the Python oracle

`python/binary_margin_lift_oracle.py` is standard-library only. It decides liftability twice — by
enumerating every binary matrix (small shapes) and by the Gale–Ryser prefix criterion (all shapes)
— asserts the two agree, and emits `tests/fixtures/binary_margin_lift_cases.json`: a compact
verdict string over every margin pair on each shape with `ROWS, COLUMNS ∈ {1,2,3}`, plus
structured and obstruction cases at 18×29, 12×100, 7×7, 5×64, 5×65 and 33×4 carrying the centred
transmission and the constructed matrix as hex row masks.

`tests/binary_margin_lift_python_parity.rs` replays the fixture against the Rust kernel: it
re-enumerates the odometer in the oracle's order and checks each verdict, decodes the centred
margins back to the same degrees, and compares the constructed matrix bit for bit.

```text
$ nix shell nixpkgs#python3 --command python3 python/binary_margin_lift_oracle.py --check
fixture /home/tavis/.cache/ergodis/wt/c1055-margin-lift/tests/fixtures/binary_margin_lift_cases.json matches the oracle

running 2 tests
test structured_and_obstruction_cases_match_the_python_oracle ... ok
test exhaustive_small_margin_pairs_match_the_python_oracle ... ok

test result: ok. 2 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.01s
```

### Zero allocation

`repeated_decisions_and_constructions_allocate_nothing` uses the core's own
`test_alloc::measure_current_thread_allocations` harness, entering the decision and the
construction 4,096 times each after setup, and asserts zero allocations, zero reallocations and
zero deallocations. It passes (listed above).

### Full validation gate

```text
$ cargo fmt --check
fmt exit 0

$ cargo clippy --all-targets --all-features -- -D warnings
    Checking ergodis v0.1.0 (/home/tavis/.cache/ergodis/wt/c1055-margin-lift)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 15.65s

$ cargo test --all-features
running 597 tests
test result: ok. 597 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 54.74s
(22 test targets in total, every one `test result: ok`, 0 failures across all of them)

$ bash tests/publication-guards.sh
passed: 44  failed: 0
```

## Hardware counters

Single thread, pinned to CPU 2 with `taskset -c 2`, `perf stat -e
instructions,cycles,branches,branch-misses`, release profile (`opt-level=3`, thin LTO,
`codegen-units=1`). Workload: `examples/binary_margin_lift_counters.rs`, a deterministic
sixteen-member family of margin pairs cycled through one caller-owned workspace. Contention and
parallel dimensions do not apply — the kernel is a single-threaded per-call decision.

Final binary retained at `~/.cache/ergodis/bin/margin-lift-counters-final`,
SHA-256 `77b2543ebb7c5310a9d635d70a3e0272d4a9ca99b0c8a430fda87d4416d7e833`.

Three interleaved rounds; per-lift figures use the round median.

| Mode                    | Iterations | Instructions/lift | Cycles/lift | Branch misses/lift |
|-------------------------|------------|-------------------|-------------|--------------------|
| `decide` (18×29)        | 200,000    | 1,081             | 436         | 0.00026            |
| `construct` (18×29)     | 200,000    | 11,035            | 9,893       | 0.0014             |
| `construct-wide` (24×200) | 40,000   | 86,894            | 38,749      | 0.11               |

The decision is the cheap half: about 1,081 instructions and 436 cycles for an 18×29 shape, at
2.5 instructions per cycle with essentially no branch misses, which is what a straight-line
insertion sort of 18 bytes plus two linear passes should cost.

### Accepted trade: counting sort for column order

The column-ordering change was measured as an interleaved four-round A/B against a retained
control built from the identical tree with only the ordering routine reverted to the
comparison-sort form (`~/.cache/ergodis/bin/margin-lift-counters-insertion-v2`, SHA-256
`feabfb9f8bdcac9e33b0375f6ca4c6b6359e21ea6c33511572e5e210b29f27cc`; candidate
`margin-lift-counters-counting-v2`, SHA-256
`4533ef27ad91bb109d529e837b763222a492b14eef5b1dfafb167f049e724269`). Both binaries report the
same accepted count and the same total population on every mode, so the work is identical.

| Mode                      | Control instructions | Candidate instructions | Control cycles | Candidate cycles |
|---------------------------|----------------------|------------------------|----------------|------------------|
| `construct` (18×29)       | 5.927e9              | 2.207e9                | 1.834e9        | 1.976e9          |
| `construct-wide` (24×200) | 41.05e9              | 3.476e9                | 14.36e9        | 1.549e9          |

At the narrow 18×29 shape the counting sort cuts instructions 2.7× and branch misses 14×, but
costs about 7.8% more *cycles*: the scatter's dependent store-to-load chain is longer than the
well-predicted comparison sort it replaces, exactly the failure mode `PERFORMANCE.md` warns about.
At 24×200 the same change is a 9.3× cycle win, because the comparison sort's `O(COLUMNS²)` per row
dominates everything else. Since the whole point of the promotion is that the widths are now free
parameters, the asymptotic behaviour decides it: the counting sort is kept, and the narrow-shape
cycle cost is recorded here as a deliberate, measured trade rather than an unnoticed regression.

The Fermi estimate before implementing was "roughly `COLUMNS / 4` fewer operations per row, so a
large win once `COLUMNS` exceeds a few dozen and a wash below that". The instruction counts match
that; the cycle counts do not, because the narrow case is latency-bound rather than
throughput-bound. The cost model was wrong about *which resource* binds, which is why the narrow
result is reported rather than smoothed over.

### Open lever, not taken

`construct` at 18×29 runs at about 1.1 instructions per cycle, so it is bound by the serialized
increments through the counting-sort bucket array and the read-modify-write into the output bit
matrix, not by instruction count. Breaking that dependency chain — for instance by maintaining the
column order incrementally across rows instead of rebuilding it, which is possible because each
row decrements a contiguous prefix of the ordered columns by exactly one — should remove most of
the remaining cost. It is deliberately out of scope here: this is a boundary constructor rather
than a search hot loop, and the incremental form needs its own canonicality argument before it can
claim bit-identical output.

## Proposed kernel registry row

The registry lives in `ergodis-private` and was not edited. The row to add:

| Field | Value |
|---------------------|--------------------------------------------------------------------------|
| Kernel              | `binary_margin_lift` |
| Module              | `ergodis::binary_margin_lift` (core) |
| Entry points        | `binary_margin_lift_exists`, `construct_binary_margin_lift`, `decode_centered_margins` |
| Decides             | Gale–Ryser liftability of a `{0,1}` matrix from two transverse margins, and one canonical realising matrix |
| Shape parameters    | `ROWS`, `COLUMNS` const generics, each 1..=255 |
| Workspace           | `MarginLiftWorkspace<ROWS, COLUMNS>`, caller-owned, `repr(C, align(64))` |
| Allocation          | None after setup (`test_alloc` regression in-module) |
| Complexity          | Decision `O(ROWS² + COLUMNS)`; construction `O(ROWS · (ROWS + COLUMNS))` |
| Oracle              | `python/binary_margin_lift_oracle.py`, fixture `tests/fixtures/binary_margin_lift_cases.json` |
| Parity test         | `tests/binary_margin_lift_python_parity.rs` |
| Counter workload    | `examples/binary_margin_lift_counters.rs` (`decide`, `construct`, `construct-wide`) |
| Counters (18×29)    | decide 1,081 instructions / 436 cycles; construct 11,035 / 9,893 per lift |
| Parallel            | Not applicable (single-threaded per-call kernel) |

The private `binary_margin_lift.rs` can now be deleted and its two call sites re-pointed at the
core module, supplying `ROWS = 18`, `COLUMNS = 29` and using `decode_centered_margins` for the
signed coefficients. That migration is a separate task; nothing under `ergodis-private` was
touched here.

## Commits on `c1055-margin-lift`

| Commit | Subject |
|------------------------------------------|--------------------------------------------------------------------|
| `469f82230e95bee5c533809c8826715b00d76aaf` | core: add domain-neutral binary margin lift kernel (Gale-Ryser) |
| `4b65cc8fe9c11277736430b25c4930a612c25746` | core: add the standalone margin-lift Python oracle and differential parity test |
| `ae502688ba658b6919be9e563e3f7c9ef3a535a7` | core: order margin-lift columns by counting sort and add the counter workload |

Branch tip: `ae502688ba658b6919be9e563e3f7c9ef3a535a7`.

## Note for the lane

`python/generate_evidence.py` keeps a curated list of files hashed into the evidence bundle and
`SHA256SUMS`. It names some modules and fixtures but not all, and the new files were not added to
it, since regenerating `SHA256SUMS` would rewrite an artifact this task does not own. If the lane
wants the margin-lift oracle and fixture inside the evidence bundle, that is a one-line addition
plus an evidence regeneration.
