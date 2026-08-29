# ergodis performance review (Lemire-lens), 2026-08-28

**Lane**: `complete-ports`

Read-only review of `papers/complete-repair-ports/ergodis` by three Opus sub-agents, each
adopting the perspective of Daniel Lemire and similar low-level performance experts. Nothing
was built, run, or modified. Findings are unverified by the main agent; treat each as a
hypothesis to confirm with a measurement before acting.

## Summary, ranked

Methodology (changes what the benchmarks section can claim):

1. Asymmetric protocol behind the headline multipliers: ergodis timed as a warm in-process
   mean over 100k repetitions (`python/run_benchmarks.py:380-393`), controls run once, cold,
   median of 11 processes. Undisclosed. The Azure LRC `173,996x` row is a ~28 ns closed-form
   kernel against Python-side model assembly. Fix: same protocol both sides; report ns/element
   or instructions/element.
2. Build config not reproducible: `BENCHMARKS.md:668` cites a local `target-cpu=x86-64-v3`
   pin that is not in the tree; `[profile.bench]` lacks `panic=abort`. Fix: commit
   `.cargo/config.toml`, align profiles.
3. Reporting: bare medians, ratios to 6–9 significant figures, no CPU model/governor/boost/SMT
   in `evidence/benchmarks.json`, some figures from a loaded host. Fix: min + IQR, 2–3 sig
   figs, record `lscpu` and governor, pin cores.
4. Perf-counter evidence is good but single-run and absent for the observational compiler
   and the headline application rows.

Code hot paths:

5. `matrix.rs:180-204` elimination: per-byte bounds checks and aliasing barrier block
   vectorization; use `split_at_mut` + `chunks_exact_mut` + `zip`. High.
6. `matrix.rs:146-159` clones/revalidates per candidate row; `span.rs:182` runs full RREF
   where rank suffices. High.
7. `balanced.rs:1359,2265` GF(27) quadratics by trying all 27 y (sqrt table, ~7x);
   `balanced.rs:2021` enumerates 512 subsets to emit at most 46 (iterate set bits);
   `split_parameter_mask` (:2131) 1404 Horner evals where 52 suffice. High.
8. `scheduler.rs:1919` sort key clones per comparison; `best_capacity_cut` (:1987) two
   Vecs per mask over up to 2^22 masks. Med.
9. Hash-of-hash memo tables in `orbit.rs`; `sat.rs:65` hash map where a dense array fits;
   DIMACS parsed twice. Med.
10. `defect.rs:485` re-ANDs all nine threshold masks per node when at most two changed. Med.
11. Per-state allocation: `observational.rs:3198`, `applications.rs:1487`,
    `composition.rs:435,1020` (leading suspect for the 16→24-thread regression),
    `contextual.rs:720`, `span.rs:75`. Med.
12. `packed_ternary` lacks `sub_mod3`; orbit DFS undoes with two adds. Low.

Already good: const-generic `P`, branchless mod-3 SWAR, flat arena with u32 ids, hand-rolled
ZDD tables, XOR undo-log frontier, release profile, target-cpu rejected on evidence.

The three full sub-agent reports follow verbatim.

---


<!-- sub-agent report: kernels -->

# Low-level performance review: ergodis kernels

Scope: `src/bitset.rs`, `src/packed_ternary.rs`, `src/field.rs`, `src/matrix.rs`,
`src/arena.rs`, `src/span.rs`, `src/incidence.rs`, read in full; `src/bin/bench_kernels.rs`
skimmed for exercise patterns. Crate root
`/home/tavis/src/othello/papers/complete-repair-ports/ergodis`. Nothing built or run; no
files modified.

Call-graph facts that drive the ranking (grepped, not assumed):

- `matrix::canonicalize_rows_in_place` is the innermost kernel of `span::GeneratedSpanTable::build`
  (`span.rs:99`) and of `span::query_canonical_target_image` (`span.rs:182`). It is the hot loop
  of this crate.
- `packed_ternary::TritBlock::add_mod3` is called from the meet-in-the-middle DFS in
  `src/orbit.rs` (`orbit.rs:371,415,450,484`), i.e. an innermost recursion.
- `bitset::BitSet` and `incidence::signed_profile` have **no callers anywhere in `src/`**
  outside their own `#[cfg(test)]` modules; they are exported from `lib.rs:10,18` but unused
  internally and not touched by `bench_kernels`. Their findings are therefore ranked as
  latent, not as measurable wins today.

Profile is already `opt-level=3`, `lto="thin"`, `codegen-units=1` (Cargo.toml:77-90), so
cross-module inlining is mostly available and missing `#[inline]` is a minor issue here.

---

## Findings, ranked by expected impact

### 1. `matrix.rs:180-204` — elimination inner loops use indexed access: bounds checks plus an aliasing barrier that blocks all vectorization. HIGH

Now:

```rust
for j in col..cols {
    let product = F::mul(factor, data[pivot_row * cols + j]);
    data[row * cols + j] = F::sub(data[row * cols + j], product);
}
```

Two separate problems, both on the crate's hottest loop:

- *Bounds checks.* `data: &mut [u8]` is indexed by `row * cols + j`. The only length fact
  LLVM has is the guard at `matrix.rs:175`, `data.len() != rows.saturating_mul(cols)`.
  `saturating_mul` is not an affine relation, so the compiler cannot recover
  `row*cols + j < data.len()` from it and must keep a check (and its panic path) per element.
- *Aliasing.* The read `data[pivot_row*cols + j]` and the write `data[row*cols + j]` come from
  the same `&mut [u8]`. LLVM cannot prove the pivot row and the target row are disjoint, so
  every store must be assumed to clobber the next load. This alone forbids vectorizing the
  loop even if the bounds checks were gone.

Change: take the two rows as provably disjoint slices once, outside `j`.

```rust
let (before, after) = data.split_at_mut(pivot_row.max(row) * cols);
// pick pivot/target from `before` / `after` by which index is larger, then:
for (dst, &src) in target[col..cols].iter_mut().zip(&pivot[col..cols]) {
    *dst = F::sub(*dst, F::mul(factor, src));
}
```

or restructure the whole function over `data.chunks_exact_mut(cols)` so `cols` is a proven
slice length. Same treatment for the normalization loop at `matrix.rs:189-191`
(`data[pivot_row*cols + j] = F::mul(..., inverse)` → `iter_mut()` over one row slice).

Expected impact: high. It removes a per-byte branch and, more importantly, unlocks
autovectorization of a `mul`+`sub` over `cols` bytes; with `P` a compile-time constant the
`% P` becomes a widening `vpmulhuw` sequence LLVM does emit for u16 lanes once the aliasing
and panic edges are gone.

### 2. `matrix.rs:146-159` — `row_space_contains_field` is quadratic in copies and re-validation. HIGH

Now:

```rust
let mut joined = self.clone();                          // full data clone
for row in 0..candidate.rows() {
    joined = joined.append_row_field::<F>(candidate.row(row))?;   // per row
}
Ok(joined.canonical_row_basis_field::<F>()?.rows() == rank)
```

`append_row_field` (`matrix.rs:132-140`) allocates a fresh `Vec` and copies the entire
accumulated matrix, then calls `new_field`, which re-scans *every* byte for reducedness
(`matrix.rs:52`). For `k` candidate rows over an `n`-byte base this is `O(k·(n + k·cols))`
bytes copied and re-validated, plus `k+1` allocations, to build a buffer that is then thrown
away. The initial `self.clone()` is a pure redundant allocation — its buffer is overwritten
by the very first `append_row_field`.

Change: build the joined buffer once —
`Vec::with_capacity(self.data.len() + candidate.data.len())`, one `extend_from_slice` each —
and call `canonicalize_rows_in_place_field::<F>` on it directly, comparing the returned pivot
count to `rank`. No `Matrix` construction, no re-validation, one allocation.

Expected impact: high on any caller that tests membership repeatedly; turns a quadratic
copy/validate loop into a single linear fill.

### 3. `span.rs:182` + `matrix.rs:170` — the query path pays for full RREF where a rank suffices. HIGH

`query_canonical_target_image` uses only `joined_rank` (`span.rs:187`), but
`canonicalize_rows_in_place_field` eliminates against *all* rows including those above the
pivot (`matrix.rs:192-204`) to produce a canonical reduced form. Row-echelon form (eliminate
only rows below the pivot) gives the same rank for roughly half the arithmetic.

Change: add a `rank_in_place_field` that skips `row < pivot_row`, and call it from
`span.rs:182`. The build path (`span.rs:99`) genuinely needs the canonical form — it is the
hash key at `span.rs:104` — so leave that call on the full-RREF routine.

Expected impact: high on the query path; close to a 2x on the dominant inner work, and the
query is a linear scan over every state (`span.rs:177`), so the saving multiplies by state
count.

### 4. `matrix.rs:52` — every `Matrix` construction re-scans all data for reducedness. HIGH-MED

`data.iter().any(|&entry| entry >= F::ORDER)` runs on each `new_field`, and `new_field` is on
the path of `append_row_field`, `transpose_field`, `canonical_row_basis_field`, and
`zeros_field`. `zeros_field` (`matrix.rs:69`) is the clearest waste: it scans a buffer it just
filled with zeros.

Change: keep the scan on the public constructors, but give the internal paths a
`new_field_unchecked` (or a `debug_assert!`-only variant) for buffers this module just
produced from already-validated data — transposes, truncated RREF output, appended rows whose
source matrix was validated. Combined with finding 2 this removes the whole quadratic
validation term.

Expected impact: high-medium; removes an O(rows·cols) pass from every intermediate matrix.

### 5. `span.rs:75,104,110` — the canonical-basis index allocates a duplicate boxed key per state and hashes twice per transition. MED-HIGH

Now:

```rust
let mut index: FxHashMap<Box<[u8]>, MatrixId> = FxHashMap::default();
...
if index.contains_key(scratch.as_slice()) { continue; }        // hash + probe #1
let basis_id = bases.push(candidate_rank, ambient, &scratch);
index.insert(scratch.clone().into_boxed_slice(), basis_id);    // hash + probe #2 + alloc
```

Three costs: the same bytes are hashed and probed twice on every insert; each accepted state
gets its own small heap allocation for the key; and those bytes are already stored
contiguously in `bases` (`arena.rs`), so the map doubles the memory for the basis data and
scatters it.

Change: use `hashbrown`'s `raw_entry_mut` (or `HashTable`) to hash once and insert into the
vacant slot found by the lookup. Better still, key the table on `MatrixId` with a hash
computed from `bases.get(id).data` and equality resolved through the arena — the key becomes
4 bytes, the duplicate allocation and the duplicate byte storage both disappear, and the
probe compares arena-resident bytes that the loop is about to touch anyway. `contains_key` is
followed by an unconditional `insert` in every non-`continue` path, so no third probe is
needed.

Expected impact: medium-high on large builds — one allocation and one hash pass saved per
accepted state, plus roughly half the peak memory of the index.

### 6. `packed_ternary.rs:40-45` — no `sub_mod3`/`neg_mod3`, so the orbit DFS undoes a move with two SWAR additions. MED

`orbit.rs:450` and `orbit.rs:484` write `left.add_mod3(right).add_mod3(right)` to compute
`left - right` (mod 3), i.e. two full reduce sequences (roughly 12 ops) where one would do.
Negation mod 3 is a per-lane swap of the two low bits, which is branchless and mask-only:

```rust
#[inline(always)]
pub(crate) fn neg_mod3(self) -> Self {
    Self(((self.0 & ONE_MASK) << 1) | ((self.0 & TWO_MASK) >> 1))
}
#[inline(always)]
pub(crate) fn sub_mod3(self, right: Self) -> Self { self.add_mod3(right.neg_mod3()) }
```

Better still for `orbit.rs`: the residues array is fixed for the whole search, so precompute a
negated copy once at setup and make the undo a plain `add_mod3` against it — zero extra ops
in the recursion.

Expected impact: medium. It halves the undo cost in the innermost frame of the
meet-in-the-middle DFS, which runs once per enumerated assignment.

### 7. `field.rs:53-61` — `add`/`sub` use a general modulo where operands are already reduced. MED

`add` computes `(l + r) % P` and `sub` computes `(l + P - r) % P`. Because `P` is a const
generic these compile to the constant-modulo multiply-shift sequence (~5 ops, with multiply
latency), but the inputs are guaranteed `< P`, so a single conditional subtract is correct and
cheaper:

```rust
#[inline(always)]
pub fn add(left: u8, right: u8) -> u8 {
    let sum = left as u16 + right as u16;
    let reduced = sum.wrapping_sub(P as u16);
    (if (reduced as i16) < 0 { sum } else { reduced }) as u8
}
#[inline(always)]
pub fn sub(left: u8, right: u8) -> u8 {
    let diff = left as i16 - right as i16;
    (diff + ((diff >> 15) & P as i16)) as u8
}
```

The scalar saving is modest; the real argument is vectorization. The masked conditional
subtract maps onto plain byte SIMD (compare/mask/subtract, 32 or 64 lanes per vector), whereas
`% P` forces a widen to u16 lanes plus `vpmulhuw`. Paired with finding 1 this is what makes
the elimination row operation vectorize well rather than merely vectorize.

Expected impact: medium — `F::sub` is called once per byte in the hottest loop in the crate.

### 8. `field.rs:68-73` — `inverse` uses Fermat exponentiation where a compile-time table fits in ≤251 bytes. MED

`Self::pow(value, P - 2)` costs about `2·log2(P)` ≈ 16 field multiplications per call, and
`inverse` is called once per pivot column in `canonicalize_rows_in_place_field`
(`matrix.rs:188`) and once per generator column in `projective_columns` (`span.rs:206`).

Change: build the table in a const block, since `P` is a const generic:

```rust
const INVERSES: [u8; 256] = { /* const fn loop using pow, evaluated at compile time */ };
#[inline(always)]
pub fn inverse(value: u8) -> Result<u8, FieldError> {
    if value == 0 { return Err(FieldError::ZeroInverse); }
    Ok(Self::INVERSES[value as usize])
}
```

One L1 load replaces ~16 multiply-modulo pairs, and the table is at most 256 bytes per
instantiated `P`.

Expected impact: medium — per pivot, not per entry, but it is a strict improvement with no
downside.

### 9. `matrix.rs:183-187` — row swap is done byte-by-byte through `slice::swap`. MED

```rust
for j in 0..cols {
    data.swap(found * cols + j, pivot_row * cols + j);
}
```

Each `swap` re-checks two indices and moves one byte. Use `split_at_mut` at the boundary
between the two rows and call `swap_with_slice`, which lowers to a vectorized memory swap with
no per-byte checks.

Expected impact: medium — pivoting happens once per pivot column, but the loop is currently
the worst possible formulation of a memory swap.

### 10. `span.rs:120` — sorting states after the build destroys arena locality for every query. MED

`states.sort_unstable_by_key(|state| (state.rank, state.basis.0))` reorders the state array so
the query scan (`span.rs:177-193`) visits `self.bases.get(state.basis)` in an order that no
longer matches the byte arena's layout. Each iteration then chases a random offset into
`bases.bytes`, and the query is a full linear scan over all states.

Change: after sorting, rebuild the arena in the new state order (a single sequential pass
copying each basis into a fresh `FlatMatrixArena` and rewriting `state.basis`). The scan then
streams the arena front to back and prefetches perfectly.

Expected impact: medium — a one-off build cost that converts every subsequent query from
random access to sequential streaming over the arena.

### 11. `matrix.rs:122-125` — `canonical_row_basis_field` reallocates the result buffer via `truncate` + `Into<Box<[u8]>>`. MED-LOW

```rust
let mut data = self.data.to_vec();               // alloc, capacity = rows*cols
let pivot_row = canonicalize_rows_in_place_field::<F>(&mut data, rows, cols)?;
data.truncate(pivot_row * cols);                 // len shrinks, capacity does not
Self::new_field::<F>(pivot_row, cols, data)      // Vec -> Box<[u8]> reallocates + memcpy
```

`Vec<u8>: Into<Box<[u8]>>` calls `into_boxed_slice`, which reallocates whenever
`capacity != len` — which is exactly the case after `truncate`. So every canonicalization
pays a second allocation and a full copy of the surviving rows. The same trap applies to any
other caller that hands `new_field` a `Vec` with slack capacity.

Change: have `new_field` accept the `Vec` and only shrink when the caller asks, or copy the
`pivot_row * cols` prefix into an exactly sized `Box<[u8]>` directly.

Expected impact: medium-low — one extra allocation plus copy per canonicalization, on a path
called once per query state and once per build transition.

### 12. `span.rs:199,212` — `projective_columns` uses a map as a set and clones every candidate key. MED-LOW

```rust
let mut representatives: FxHashMap<Box<[u8]>, ()> = FxHashMap::default();
...
if representatives.insert(normalized.clone(), ()).is_none() {
```

`normalized.clone()` allocates and copies for *every* generator column, including the
duplicates that are immediately discarded. `FxHashMap<_, ()>` should be `FxHashSet<_>`, and
the clone should be avoided: insert the owned `normalized` into the set and store the column's
data as an index into a flat byte arena (or clone only on the accepted branch).

Expected impact: medium-low — setup path only, but it is one wasted heap allocation per
generator column.

### 13. `incidence.rs:30-31` — two passes over each row where one fused pass suffices. MED (latent: no callers)

```rust
let pos = row.intersection_count(positive)?;
let neg = row.intersection_count(negative)?;
```

Each call re-walks the row's words and re-checks the width. Fusing gives one load of each row
word feeding two `and`+`popcnt` pairs:

```rust
let (mut pos, mut neg) = (0u32, 0u32);
for ((&r, &p), &n) in row.words().iter().zip(pw).zip(nw) {
    pos += (r & p).count_ones();
    neg += (r & n).count_ones();
}
```

Also: `tangents` and `same_sign` (`incidence.rs:27-28`) are unreserved `Vec`s that grow by
doubling, unlike `degrees`/`sums` which use `with_capacity`. And `degrees: Box<[u32]>` /
`signed_sums: Box<[i32]>` could be `u16`/`i16` for realistic incidence widths, halving the
profile's footprint.

Separately, a correctness/API nit rather than a perf one: `incidence.rs:18-20` returns
`BitSetError::WidthMismatch` when the positive and negative sets are *not disjoint*, which is
a different condition entirely and will mislead any caller that matches on the error.

Expected impact: medium *if this kernel is ever put on a hot path*; today it has no callers.

### 14. `arena.rs:8-19` — `MatrixRecord` is 16 bytes to store 8 bytes of information. LOW-MED

`offset: u32, len: u32, rows: u16, cols: u16, _reserved: u32`. But `len == rows * cols` by the
`assert_eq!` at `arena.rs:36`, so `len` is fully derivable, and `_reserved` exists only to hit
the 16-byte size assert. Dropping both gives `{ offset: u32, rows: u16, cols: u16 }` = 8 bytes,
doubling records per cache line for the random-access lookups in `span.rs`.

Also in this file: `get` (`arena.rs:52-60`) pays two bounds checks per call (`records[..]` and
`bytes[start..end]`) on a hot lookup where the id is internally generated and monotone;
`push` (`arena.rs:35`) is a cross-module hot-loop function with no `#[inline]`; and there is no
`with_capacity` constructor, so `bytes` and `records` grow by repeated doubling and memcpy
during a large `GeneratedSpanTable::build`.

Expected impact: low-medium; the record shrink is the useful half.

### 15. `packed_ternary.rs:60-72,89-94` — pack/unpack do div/mod plus a bounds-checked indexed store per digit. LOW

`blocks[index / LANES].0 |= (digit as u64) << (3 * (index % LANES))` reloads the block, does a
constant-divisor `/21` and `%21` (multiply-shift, cheap but not free), and bounds-checks each
store. `digits()` has the mirror problem, recomputing `blocks[index / LANES]` per digit.

Change: iterate `digits.chunks(LANES)` and fold each chunk into one `u64` in a register, then
push; for `digits()`, loop over blocks and shift out 21 lanes each. Removes all division,
indexing, and repeated loads. Also `from_digits` walks `digits` twice — once for the
`any(|d| d > 2)` validation, once to pack; the validation can be folded into the pack loop.

Expected impact: low — setup path, not the DFS.

### 16. `packed_ternary.rs:3` — 3-bit lanes waste 1 bit in 64 and cap density at 21 trits/word. LOW (architectural)

`LANES = 21` uses 63 of 64 bits. The standard alternative is a bit-sliced pair of planes
(`lo`, `hi`), which stores 64 trits per two words — 32 trits per word, a 1.5x density gain —
with a known branchless mod-3 add of roughly 8 operations on the pair. Per-op throughput
improves in proportion, and it removes the `HIGH_MASK` carry-catching step entirely.

This is a representation change with real churn across `orbit.rs`, so it is listed as a
direction rather than an edit. Expected impact: potentially medium-high on the orbit DFS,
but only worth it if that DFS is measured to be the bottleneck.

### 17. `bitset.rs:52-57` — `intersects` early-exits per word, blocking vectorization. LOW (latent: no callers)

`.any(|(x, y)| x & y != 0)` branches once per word. For the small widths this type is built
for (the tests use width 4, i.e. one word), the branch misprediction costs more than the work.
A branchless OR-accumulate — `words.iter().zip(..).fold(0u64, |acc, (x, y)| acc | (x & y)) != 0`
— is both shorter and vectorizable. Also `intersects` and `disjoint` lack `#[inline]` while
`intersection_count` has it, and `disjoint` is a one-line cross-module wrapper.

The deeper layout issue: `BitSet` is `Box<[u64]> + u32`, so `rows: &[BitSet]` in
`incidence::signed_profile` is an array of fat structs each pointing at a separate heap
allocation — a pointer chase and likely a cache miss per row. A packed row-major bit matrix
(one `Vec<u64>` with a `stride` in words, rows addressed as `&words[r*stride..][..stride]`)
would stream sequentially and let a whole profile pass run over one contiguous buffer. Worth
doing *if* these types are ever put on a hot path; today they are unused outside tests.

### 18. `field.rs:45-50,172-184` — `validate()` runs trial division at runtime. LOW

`Prime::<P>::validate` calls `is_prime(P)`, a loop doing `value % divisor` with a *runtime*
divisor, and it is invoked from `Matrix::new_field` (`matrix.rs:45`) — that is, on every matrix
construction, and from `span.rs:70,148,166` on every build and query entry. With `P` a
compile-time constant LLVM will very probably unroll and constant-fold the whole thing away,
so this is likely already free — but "likely" is doing work there. Make it guaranteed:

```rust
impl<const P: u8> Prime<P> {
    const IS_VALID: bool = P >= 2 && is_prime(P);
    pub fn validate() -> Result<(), FieldError> {
        if Self::IS_VALID { Ok(()) } else { Err(FieldError::InvalidModulus) }
    }
}
```

A `const` item is evaluated by miri at compile time, not by LLVM's optimizer, so the runtime
cost is provably zero regardless of optimization level (this also makes debug builds sane).

### 19. `matrix.rs:104-112` — naive transpose with a strided store. LOW

`data[col * self.rows() + row] = self.data[row * self.cols() + col]` writes with stride
`rows`, touching a new cache line per iteration for anything past a few dozen rows. A tiled
transpose (32x32 blocks) is the standard fix. Only called from
`span::canonical_target_image` (`span.rs:152`), which is explicitly designed to be compiled
once and reused, so this is low priority — flagged only in case target matrices grow.

### 20. `span.rs:176,86` — query and build scratch buffers start empty. LOW

`let mut scratch = Vec::new();` is correctly hoisted out of the state loop in both places
(good), but the first several iterations still realloc as it grows. `Vec::with_capacity` sized
from `(max_rank + target_rows) * ambient` removes the warm-up reallocations. Trivial change,
trivial win.

---

## Already done well

1. **The mod-3 SWAR addition is genuinely good** (`packed_ternary.rs:40-45`). Three-bit lanes
   are exactly wide enough that `2 + 2 = 4` cannot carry into the neighbouring lane, so the
   whole reduction is five branchless word ops: detect the `011` lanes with
   `(raw & ONE_MASK) & ((raw & TWO_MASK) >> 1)`, detect the `100` lanes with
   `(raw & HIGH_MASK) >> 2`, and subtract `3` from the union. The two detectors are provably
   disjoint, so the `|` is exact. `#[inline(always)]`, `#[repr(transparent)]`, `const fn`
   accessors, and static size/align asserts on the block are all right.

2. **The field abstraction costs nothing at runtime** (`field.rs:39-117`). Because `P` is a
   const generic and dispatch happens at the CLI boundary, every `% P` in the monomorphized
   code has a literal divisor and LLVM strength-reduces it to a multiply-shift. There is no
   runtime field tag, no branch on modulus in any client loop, and no need for hand-written
   Barrett or Montgomery reduction — the usual GF(p) division trap is already avoided by
   construction. The sealed trait plus `#[inline(always)]` forwarders means the abstraction is
   fully erased. `Gf4::mul` (`field.rs:149-158`) is likewise a correct branchless
   carry-less-multiply-and-reduce in seven bit operations rather than a table.

3. **The hot data layout is deliberate and correct.** `FlatMatrixArena` replaces what would
   otherwise be `Vec<Vec<u8>>` with one contiguous byte pool plus fixed-size records
   (`arena.rs`); `SpanState` and `MatrixRecord` are exactly 16 bytes with explicit `_pad` /
   `_reserved` fields and `const _: () = assert!(size_of::<..>() == ..)` guards; hot records
   hold 32-bit ids instead of pointers; `Matrix` is documented as the cold owning type with
   the hot path going through the arena. `SignedIncidenceProfile` is structure-of-arrays. The
   hash maps use `FxHashMap` rather than the default SipHash. Scratch buffers are hoisted out
   of the state loops in both `span::build` and `span::query_canonical_target_image`. Most
   crates get these wrong; this one did not.

<!-- sub-agent report: search -->

# ergodis performance review

Crate: `/home/tavis/src/othello/papers/complete-repair-ports/ergodis`
Scope: `scheduler.rs`, `balanced.rs`, `orbit.rs`, `group_action.rs`, `zdd.rs`, `defect.rs`,
`selector.rs`, `sat.rs`. Read-only review; nothing built or run.

Build config is already right: `opt-level=3`, `lto="thin"`, `codegen-units=1`, `panic="abort"`,
`rustc-hash` present, `rayon` behind an optional `parallel` feature. Findings below are about
algorithm shape and inner-loop mechanics, not flags.

---

## High impact

### 1. `balanced.rs:1359-1373` and `balanced.rs:2265-2282` — quadratic roots found by 27-way trial

Both `check_balanced_terminal` and `carrier_matches_prefix` solve `y^2 - t*y + p = 0` over
GF(27) by looping `for y in 0..Q` and testing all 27 candidates with three table lookups each.
That is 26 rows x 27 candidates = 702 inner iterations per call, and `carrier_matches_prefix`
is called once per terminal carrier per affine parameter (up to 27 parameters per terminal
family), on top of `check_balanced_terminal` for every surviving carrier.

Change: build a 27-entry square-root table at catalog construction time. The catalog already
computes `nonzero_square: [bool; 27]` (`balanced.rs:662-665`) by squaring every element — store
the root instead of a bool and you get `sqrt` for free in the same loop. In characteristic 3 the
discriminant is `d = t*t - p` and the roots are `2*(t +/- sqrt(d))`; `nonzero_square[d]` already
decides splitting. Replaces 27 iterations with roughly four table lookups.

Impact: **high**. ~7x on the two functions that dominate every DFS terminal in the balanced
q=27 search.

### 2. `balanced.rs:2021-2032` — 512-subset enumeration to produce at most 46 candidates

`row_choices` runs `for subset in 0u16..(1 << 9)` and immediately discards anything with
`subset & !allowed != 0`, `subset & required != required`, or `count_ones() > 2`. Only the
empty set, 9 singletons and 36 pairs can survive — the output buffer is even declared as
`[IncidenceRowChoice; 46]`. `search_node` calls `row_choices` once per unprocessed row
(up to 26) plus once more for the chosen row, so this is ~13,800 loop iterations per DFS node
to yield at most 46 candidates.

Change: iterate the set bits of `allowed` directly — emit the empty choice, then each singleton,
then each pair, filtering on `required` as you go. Straight `while bits != 0 { let b =
bits.trailing_zeros(); bits &= bits - 1; ... }` nesting.

Impact: **high**. ~11x fewer iterations in the per-node candidate generator; the surrounding
work per surviving candidate is unchanged, so the win is close to the raw ratio.

### 3. `balanced.rs:2131-2153` — `split_parameter_mask` recomputes the same carrier 26 times

The loops are nested row-outer / parameter-inner, so `carrier_affine_member` (18 multiply-adds)
runs 26 x 27 = 702 times to build only 27 distinct carriers, and `evaluate_polynomial` runs
2 x 702 = 1,404 times (each 9 multiplies + 9 adds through `field_multiply` / `field_add`).

Change, two levels:
- Swap the loops so each of the 27 carriers is built once (702 -> 27 constructions).
- Better: exploit the affine structure. `A_p(x) = A_0(x) + p * D_A(x)` and likewise for the
  product, so evaluate origin and direction once per row (52 Horner evaluations total) and
  obtain all 27 parameters with one multiply-add each. 1,404 Horner evaluations collapse to 52
  plus 702 madds.

Impact: **high**. This runs at every rank-17/18 terminal family; the second form is exact, not
an approximation, because the family is affine by construction.

### 4. `scheduler.rs:1919` — heap allocation inside a sort comparator

```rust
supports.sort_unstable_by_key(|support| (support.len(), support.clone()));
```

`sort_unstable_by_key` invokes the key function O(n log n) times and each call clones the
support `Vec` onto the heap, then drops it.

Change: `supports.sort_unstable_by(|a, b| a.len().cmp(&b.len()).then_with(|| a.cmp(b)))`.
Identical ordering, zero allocation.

Impact: **high** for `maximum_parallel_repairs` on wide inputs, and it is a one-line fix with no
behavioural risk.

### 5. `sat.rs:63-136` — `FxHashMap<u64, u64>` where a dense array is guaranteed to fit

`edge_colors` is keyed by `((low as u64) << 32) | high` with `low, high < vertices <= 64`
(enforced at `sat.rs:59-61`). Every binary clause in the file does one hash + probe, and the
drain at `sat.rs:128` walks a hash table.

Change: `vec![0u64; vertices * vertices]` (32 KB worst case) indexed `low * vertices + high`, or
2,016 entries with a triangular index. Removes hashing entirely from the per-clause path and
makes the adjacency build a linear scan.

Impact: **high** for large CNFs — this is the only per-clause data structure in the recognizer.

### 6. `orbit.rs:114-344` — three tables hash an already-computed 64-bit hash

`MeetTable`, `ExactResidueSet` and `DeadMemo` each compute an FxHash over the payload
(`orbit.rs:142-149`, `229-235`, `287-295`) and then store it in an `FxHashMap<u64, u32> heads`,
so every lookup hashes the payload, hashes the resulting u64 again, and probes a SwissTable —
before walking the `next_same_hash` chain that the code already maintains itself.

Change: replace `heads` with a plain `Vec<u32>` bucket array of power-of-two length, indexed by
`(hash * 0x9e37_79b9_7f4a_7c15) >> shift`, grown by rehashing the record list. `zdd.rs`
`UniqueTable` (`zdd.rs:31-95`) is exactly this pattern and is the right model to copy.

Impact: **high**. `DeadMemo::contains` is called at every single search node
(`orbit.rs:642`, `orbit.rs:746`); removing one hash and one hashbrown probe per node is a
direct cut in the dominant per-node cost.

### 7. `defect.rs:485-515` — `refine` re-intersects all nine lower masks at every node

`Gf27TargetFrontier::refine` recomputes `summary.tails()` and ANDs 9 x 16 = 144 u64 lower masks
into the two-cache-line frontier at every DFS node. But `refine` mutates the frontier *in place*
from the parent state, one `push` changes at most two histogram slots, and ANDing the same mask
twice is idempotent — so thresholds whose tail is unchanged from the parent can be skipped
without affecting the result.

The upper masks are different: they key on `current[threshold - remaining]` under
`threshold > remaining`, and with `threshold <= 9` that condition only fires once
`selected_count > 45`. For the bulk of the tree only the lower masks run, and ~7 of the 9 are
redundant.

Change: pass the parent's `tails` (or the delta from `push`) into `refine` and intersect only
the thresholds whose bound moved.

Impact: **high**. Roughly 4x less mask traffic in the per-node filter for most of the search
tree, with a mechanically checkable correctness argument (mask intersection is monotone and
idempotent).

### 8. `scheduler.rs:1987-2016` — two heap allocations per mask across up to 2^22 masks

`best_capacity_cut` iterates `0..(1 << capacities.len())` with the guard at `scheduler.rs:1973`
allowing up to 22 resources, i.e. 4.19M iterations. Each one `collect()`s a `resources` Vec and
a `forced_demands` Vec, and recomputes the capacity sum, even though `best` is updated only when
`upper < best.repair_upper_bound`.

Change: compute `capacity` incrementally (a subset-sum table over the 2^n masks, or by iterating
set bits), keep `forced_demands` as a running count rather than a Vec, and materialize the two
Vecs only inside the improvement branch. Precomputing one resource bitmask per (demand, support)
also turns the `all/any` predicate into `masks.iter().all(|m| m & mask != 0)`.

Impact: **high** at the top of the supported width; ~8M avoidable allocations.

---

## Medium impact

### 9. `selector.rs:431-434` — three integer divisions per term in the sparse inner loop

```rust
let tail = source[cursor].index() / width;
while cursor < source.len() && source[cursor].index() / width == tail {
    let exponent = (source[cursor].index() % width) as usize;
```

`width` is `u64::from(degree) + 1`, a runtime value, so these are genuine 64-bit divisions
(~20-40 cycles each) executed per term per candidate field value — the hot loop of the sparse
specializer.

Change: (a) drop the `%` entirely, since `exponent = index - tail * width`; (b) precompute a
multiply-shift reciprocal for `width` once per variable (it is loop-invariant) and replace the
two divisions; (c) hoist `source[cursor].index()` into a local instead of re-loading it in the
`while` condition.

Impact: **medium-high** for the sparse backend; the surrounding work is two table-free field
operations, so division dominates.

### 10. `zdd.rs:768-788` — the reliability memo deep-clones BigUint vectors twice per node

`cached.to_vec()` on a memo hit clones an entire `Box<[BigUint]>` (each element a heap
allocation), and the store path does `counts.clone().into_boxed_slice()` — a second full deep
clone of the same data.

Change: store the counts once and return a borrowed slice (or `Rc<[BigUint]>`), letting
`convolve_binomial` read from the reference. Also cache `binomial_row(gap)` — it is rebuilt from
scratch at `zdd.rs:730` for every call with the same small `gap` values.

Impact: **medium**. Arbitrary-precision clones on a memoized path defeat the point of the memo.

### 11. `zdd.rs:806-810` with `zdd.rs:876-882` — two divisions per coordinate inside an O(k^2) scan

`dominates` does `left / stride % radix <= right / stride % radix` with runtime `stride` and
`radix`, and it is called from `scratch.iter().any(...)` for every merged code against every
code already accepted.

Change: the codes are mixed-radix packed into a u64 already — lay them out on power-of-two bit
lanes (the packing `scheduler.rs:1129-1142` builds for `bias`/`guard` is the model) so dominance
becomes a shift, mask and compare, or a single SWAR subtract-and-test. Failing that, precompute
per-coordinate multiply-shift reciprocals once at the top of `aggregate_frontier`.

Impact: **medium-high** for `aggregate_frontier`; divisions in the innermost of three nested
loops.

### 12. `scheduler.rs:604-609` — `solve_impl` reallocates its whole working set every family

Per family it does `Vec::with_capacity(states.len())` for `updated`, `packed_states.clone()`
(a full copy of the u128 packed frontier), a fresh `FxHashMap` for `heads`, and later a fresh
`compact_loads` Vec (`scheduler.rs:797`).

Change: `solve_graded_dense_narrow` already demonstrates the fix — take a
`WeightedRepairWorkspace`, double-buffer `states`/`updated` with `std::mem::swap`, and
`clear()` + `extend_from_slice` instead of `clone()`. Give `solve_impl` the same treatment, and
replace `heads` with a reusable open-addressed `Vec<u32>` table (see finding 6 — it is keyed by
a hash the code already computed, so hashbrown is hashing a hash here too).

Impact: **medium**. One allocation cluster and one full frontier memcpy per demand family.

### 13. `scheduler.rs:1665` — `dense_pareto_keep` allocates and sweeps the whole lattice per family

`vec![0u32; state_space]` with `MAX_DENSE_LATTICE_STATES = 1 << 24` is up to 64 MB allocated and
then fully swept `width` times by the prefix-max loops (`scheduler.rs:1676-1701`), once per
family, regardless of how small the frontier is.

Change: hoist `prefix_best` and `keys` into the workspace and clear only the touched keys between
families (`solve_impl` already maintains a `dense_touched` list for exactly this purpose at
`scheduler.rs:598`).

Impact: **medium**. The `DENSE_DOMINANCE_WORK_MARGIN` guard already limits when this path is
chosen, so the remaining win is allocation and page-fault traffic rather than asymptotics.

### 14. `scheduler.rs:662` and `scheduler.rs:713` — enum dispatch inside the innermost loop

`option_load_coordinate` (`scheduler.rs:525-528`) recomputes `option * width` and matches on the
three-way `OptionLoads` enum for every single coordinate read, inside the feasibility loop of the
default `solve()` path (`solve_impl::<false, false, false>`).

Change: match on `&self.option_loads` once outside the loop and iterate the concrete slice, or
add a fourth const-generic parameter alongside `DENSE`/`PACKED`/`WIDE` — the file already uses
that idiom well.

Impact: **medium**. A predictable branch, but it sits in the tightest loop of the default
backend and blocks vectorization of the sum-and-compare.

### 15. `group_action.rs:777` and `group_action.rs:845` — generators validated twice

`compile_permutation_orbits_internal` calls `validate_generators` (a full
points x generators pass with a bitmap injectivity check) and then, when
`verify_immediately` is set, calls `verify_permutation_orbits`, which calls `validate_generators`
again as its first statement.

Change: have the internal compile path call a `verify_partition_only` helper, or pass a flag.

Impact: **medium**. Removes an entire O(points x generators) sweep from the default entry point.

### 16. `balanced.rs:2290-2295` — linear scan of all selected cells per row

Inside `carrier_matches_prefix`, for each of 26 rows the code scans the entire
`selected_cells` slice (up to 52 entries) looking for `cell_x == x`, i.e. ~1,350 comparisons per
call, and the call itself is per terminal carrier per parameter.

Change: cells are appended grouped by row, so keep a `[[u8; 2]; 27]` per-row table (plus counts)
alongside `selected_cells` and index it directly.

Impact: **medium**.

### 17. `balanced.rs:1588-1602` and `balanced.rs:1845-1880` — per-high-set construction and sort

`search_balanced_work_item` calls `search_high_incidence_spec` 3,124,550 times per work item
(asserted at `balanced.rs:1694`). Each call builds a fresh `BalancedDfsEngine` with a new
`Vec` for cores and a new `FxHashSet` for `seen_carriers` (which allocates on its first terminal
insert, then grows), a 384-byte `CarrierEquationBasis::default()`, and a `[(u8, u8); 52]`.
Afterwards `merge_rejection_cores` clones cores and unconditionally re-sorts the target vector.

Change: hoist the engine into a reusable workspace owned by `search_balanced_work_item` and
`clear()` its collections per spec; guard the `sort_by_key` at `balanced.rs:1879` behind an
actual mutation. Also precompute a `[bool; 27]` column-membership table once per work item so the
`cubic_mask` fold at `balanced.rs:1651-1656` stops doing 27 `contains` comparisons per high set.

Impact: **medium**, multiplied by 3.1M calls per task and 714 tasks.

### 18. `orbit.rs:642` then `orbit.rs:799` / `orbit.rs:834` — hash recomputed on insert

`DeadMemo::contains` hashes family + packed residue + totals; when the node later fails, the very
next thing that happens is `DeadMemo::insert` recomputing the identical hash over the identical
(unchanged) state.

Change: return the hash from `contains` (or cache it on `Search`) and pass it to `insert`.

Impact: **medium**, and near-free to implement.

### 19. `orbit.rs:634-638` and `orbit.rs:735-742` — repeated block reload in the residue prune

```rust
let block = self.packed[coordinate / 21].raw();
let current = ((block >> (3 * (coordinate % 21))) & 7) as u8;
```

The same `TritBlock` is re-loaded for 21 consecutive coordinates, and the shift amount is
recomputed from a division/modulo each time.

Change: restructure as an outer loop over blocks and an inner loop over the 21 lanes with a
shifting register. The 3-bit-per-coordinate suffix mask also invites a SWAR formulation across a
whole block at once, though that is a larger change.

Impact: **medium** — this runs at every node with `width` up to hundreds.

### 20. `sat.rs:44` and `sat.rs:68` — the DIMACS file is read and parsed twice

The first `scan_dimacs` pass computes only `maximum_positive_clause`; the second re-opens the
file and re-parses every literal.

Change: buffer clauses (or just the positive-clause widths and the binary edges) during a single
pass. Separately, literal parsing goes through `read_line` (UTF-8 validation per line) plus
`split_whitespace` plus `str::parse::<i32>`; a byte scanner over `read_until(b'\n', &mut Vec<u8>)`
is typically several times faster and removes the validation.

Impact: **medium**. Halves I/O and parse cost immediately; the byte scanner compounds it.

---

## Low impact

### 21. `balanced.rs:1531-1538` — stride-27 field tables

`add`/`multiply` index `field_add[left * 27 + right]`, so every field operation pays a multiply
by 27. These two functions are the innermost primitives of the entire module.

Change: pad to stride 32 and index `(left << 5) | right`. Tables grow from 729 to 864 bytes
(still well inside L1) and the address becomes a shift-or.

Impact: **low** per operation, but it is free and applies to tens of millions of calls.

### 22. `balanced.rs:1920` and `balanced.rs:1942` — two zeroed 184-byte stack arrays per node

`[IncidenceRowChoice::default(); 46]` is constructed twice per `search_node` call while
`row_choices` writes only a prefix, so the zeroing is dead. Hoist both into the engine struct (or
use `MaybeUninit`) since only `output[..output_len]` is ever read.

### 23. `scheduler.rs:1298-1305` — linear family lookup per witness node

Reconstructing the assignment walks the witness chain and, for each node, runs
`self.families.iter().position(...)` to map an option index back to its demand. Bounded by
255 x families. Precompute an `option -> family` array once (option_count entries), or
binary-search on `option_start`.

### 24. `selector.rs:248-258` — manual index slicing in the dense kernel

`&source[tail * width..(tail + 1) * width]` plus `target[tail] = result` performs bounds checks
per group. `source.chunks_exact(width).zip(target.iter_mut())` removes both and gives the
optimizer a clean shape for the inner dot product.

### 25. `zdd.rs:569`, `zdd.rs:602`, `zdd.rs:642` — recursion where `union` was converted

`union` (`zdd.rs:517-567`) was deliberately turned into an explicit `UnionFrame` stack, but
`join`, `avoid_supersets` and `minimal` are still recursive. Depth is bounded by the 8-bit
variable index, so this is not a stack-overflow risk — only call overhead, and only worth doing
if these show up in a profile.

### 26. `defect.rs:374-385` — `flip_direction_cost` as a match returning `Option<(i8, u8)>`

Called per line per point inside `analyze_fixed_maximal_set`. A `const [(i8, u8); 10]` table plus
a validity mask removes the branch chain.

### 27. `field.rs:52-55` — `Prime::add` uses `%` where a conditional subtract suffices

`P` is a const generic, so LLVM already lowers `% P` to multiply-shift-multiply-subtract. Since
both operands are canonical, `let s = l + r; if s >= P { s - P } else { s }` compiles to a
compare and cmov — one or two ops cheaper, on the most frequent operation in the dense selector.

---

## Done well

1. **Packed-lane feasibility in the scheduler.** `dense_packed_feasibility`
   (`scheduler.rs:1622-1653`) and the narrow 64-bit variant (`scheduler.rs:1126-1157`) encode
   every capacity coordinate on its own bit lane with a precomputed `bias` and `guard`, so the
   whole multi-dimensional capacity test collapses to `(packed + bias) & guard == 0` — one add
   and one and, replacing a per-coordinate loop with a branch per coordinate. The
   `OptionLoads::U8/U16/U32` narrowing and the `DENSE`/`PACKED`/`WIDE` const generics keep the
   dispatch out of the loops rather than testing flags inside them.

2. **The ZDD storage layer.** `UniqueTable` (`zdd.rs:31-95`) and `DirectMemo`
   (`zdd.rs:300-350`) are hand-rolled open-addressed tables using a Fibonacci multiplier with
   `#[cold] #[inline(never)]` growth, intrusive `links` chains instead of per-bucket vectors, and
   12-byte `Node` / `DirectEntry` records with asserted size and alignment. No allocation happens
   per interned node, and `storage_grew` lets callers detect capacity misestimates. The
   `union` conversion to an explicit frame stack is exactly the right call for the one operation
   whose recursion depth is data-dependent.

3. **The defect-19 frontier representation.** `Gf27TargetFrontier` (`defect.rs:453-523`) holds
   all 1,013 surviving profiles in two cache lines, refines by intersecting precomputed threshold
   bitmasks rather than re-scanning the catalogue, and undoes with an XOR delta of the same two
   lines — so the depth-first search needs no per-node allocation and no rebuild. The comment and
   guard in `MaximalPointAugmentor::push` (`defect.rs:245-252`), where the degree-cap rejection
   scan is skipped entirely until some line actually reaches the cap, is precisely the right way
   to keep a provably-dead branch out of the hot path.

Honourable mentions: the const `size_of`/`align_of` assertions on essentially every record type;
the reusable `WeightedRepairWorkspace` / `DenseSelectorWorkspace` / `SparseSelectorWorkspace`
types with `shrink_to_fit`; and the rayon granularity in
`search_balanced_work_batch_parallel` (`balanced.rs:1761-1774`), where parallelism sits at the
714 independent semilinear tasks and each task keeps its allocation-conscious DFS thread-local,
with indexed collection preserving bit-for-bit determinism.

<!-- sub-agent report: bench -->

# ergodis benchmark + hot-path review (Lemire lens)

Scope: `papers/complete-repair-ports/ergodis`. Read in full: `BENCHMARKS.md`, `Cargo.toml`,
all of `benches/`, `src/bin/bench_kernels.rs` (timing scaffold), `python/run_benchmarks.py`
(harness core), `python/benchmark_python.py` (timing boundary), `scripts/*.sh` (skim).
Bounded skim of `src/observational.rs`, `src/contextual.rs`, `src/composition.rs`,
`src/applications.rs`. Nothing was built or run. No files under the crate were modified.

Overall: the measurement *infrastructure* is well above the field average — rotated
interleaved cross-process A/B, core pinning, checksum-equality gates between backends,
committed raw samples, work counters, and real `perf stat` top-down evidence for the
scheduler kernels. The weaknesses are concentrated in (a) an asymmetric warm-loop vs.
cold-single-shot protocol that inflates the headline multipliers, (b) an unreproducible
build configuration, and (c) reporting that gives medians and 5-significant-figure point
estimates but never dispersion.

---

## 1. Build configuration

### What is right

`Cargo.toml:77-90` has a real release profile:

```toml
[profile.release]  opt-level = 3, lto = "thin", codegen-units = 1, panic = "abort"
[profile.bench]    opt-level = 3, lto = "thin", codegen-units = 1
[profile.profiling] inherits = "release", debug = true
```

`lto`/`codegen-units` choices are *measured*, not cargo-culted (`BENCHMARKS.md:670-673`:
disabling them cost 1–2% in the cross-binary A/B). A dedicated `profiling` profile with
`debug = true` inheriting release is exactly right for `perf`.

### F1 — `target-cpu=x86-64-v3` is claimed but not committed (highest reproducibility impact)

`BENCHMARKS.md:668-670` states: "`x86-64-v3` improves all three profiles by `1.029x`–`1.055x`
over generic x86-64 ... so the local Cargo configuration pins that reproducible
non-AVX-512 target."

There is no such pin. `.cargo/` exists but is **empty** (no `config.toml`), and
`target-cpu` / `RUSTFLAGS` / `x86-64-v3` appear nowhere in the crate outside
`BENCHMARKS.md` prose (verified by a crate-scoped grep over `*.sh *.py *.toml *.md`).
`BENCHMARKS.md:486-487` then instructs the replayer to build "with the documented
architecture flags" — which are documented only as a narrative claim, never as a command.

Consequence: every documented replay command (`cargo build --release --bin bench_kernels`)
produces a *generic x86-64* binary, i.e. ~3–5% slower than the binary the reported numbers
came from, and every `cargo bench` number in the document is likewise unreachable. Fix is
one committed `.cargo/config.toml` with `rustflags = ["-C", "target-cpu=x86-64-v3"]`, plus a
recorded `rustc -vV` and the exact flag string in `evidence/benchmarks.json`.

### F2 — panic strategy differs between the two measurement paths

`profile.release` has `panic = "abort"`; `profile.bench` does not (and cannot, for a test
harness). So `bench_kernels`/examples are compiled with abort-on-panic and no landing pads,
while every Criterion figure is compiled with unwind tables and cleanup edges around every
fallible call — and this codebase is saturated with `Result` and `.unwrap()`. `BENCHMARKS.md`
:680-681 notices the symptom ("Criterion values are within-harness microbenchmark
baselines") and :672-673 notes the LTO A/B moved *in the opposite direction* inside Criterion,
without naming this as a candidate cause. It should be stated explicitly: Criterion numbers
and cross-binary numbers are not from the same code generation, so they must never be
compared or mixed in one table.

---

## 2. Criterion usage

### F3 — no `iter_batched` anywhere; setup and drop are inside the timed region

Zero occurrences of `iter_batched`, `iter_custom`, `iter_with_large_drop`, or `BatchSize`
across `benches/`. Several benchmarks construct and destroy a nontrivial data structure
inside `b.iter(...)`:

- `benches/contextual_state.rs:239, 270, 353, 384` — `RankOneProbeCache::new(...)` /
  `RankBoundedContextCache::new(...)` allocated per iteration.
- `benches/contextual_state.rs:454, 466, 534, 546` — the "compile envelope then query"
  arms build a fresh cache *and* a full envelope per iteration.
- `benches/gl_probe.rs:96, 104, 113` — `compile_permutation_orbits*` per iteration.

For the *cold-cache* arms this is arguably the intended measurement, but the timed window
also covers the **destructor**, which for these structures is a cascade of `free` calls that
has nothing to do with the compile cost being claimed. `iter_with_large_drop` exists for
exactly this and costs one line. Where the cache is genuinely setup (the warm arms),
`iter_batched(setup, routine, BatchSize::SmallInput)` is the correct construct.

Reported figures affected: the "projective line cache, first query 14.36 us" and
"rank-bounded context cache, first query 20.42 us" rows in `BENCHMARKS.md:206-209`, and the
`0.68x` regression reported for the rank-bounded cold row — part of that 0.68x is drop cost.

### F4 — loop-invariant benchmark bodies (LICM risk)

`black_box` on the *result* prevents dead-code elimination but does **not** prevent
loop-invariant code motion out of Criterion's `for _ in 0..iters` loop. Three bodies compute
a value that depends on nothing that changes between iterations and pass no input through
`black_box`:

- `benches/balanced_frontend.rs:179-186` (`gf27_balanced_mapping_scan`): folds a checksum over
  a fixed `mappings` slice. Reported as "174–187 ns to scan one 530-record mapping pool"
  (`BENCHMARKS.md:792-793`) ⇒ 0.33 ns/record. Plausible, but unverified against hoisting.
- `benches/balanced_frontend.rs:237-245` (`gf27_balanced_witt4_lookup`): 729 table lookups
  with constant indices. Reported as "199–202 ns to scan all 729 precomputed fourth-Witt
  weights" ⇒ 0.27 ns/lookup, i.e. under one cycle per lookup at any plausible clock. That is
  the signature of partial hoisting or of the compiler collapsing the fold.
- `benches/ordered_resource.rs:13-22`: `boolean.combine(black_box(0x5555), black_box(0x3333))`
  — inputs *are* black-boxed here, so LICM is blocked, but the measurand is a single ALU
  op timed by a harness whose per-iteration floor is ~1 ns. This measures the harness.

Fix: black_box the *input* slice/index inside the loop (`black_box(mappings)`), or better,
switch these to `iter_custom` with an explicit inner repetition count and report ns/element
computed from a known element count.

### F5 — benchmarks that mutate shared state across iterations

`benches/contextual_state.rs:425-435` (`A_cached_subspace_scan`) queries `rank_cache`, which
is a `&mut` cache shared across all iterations and *also* shared with the earlier
`rank_bounded_context_cache_warm` group. The first iteration populates; the rest hit. With
Criterion's default 100 samples the cold cost amortizes to noise, so the number is "warm"
by accident rather than by construction. Same pattern with `envelope_cache6` at :509. State
that persists across iterations should be built in an explicit warm-up call before
`bench_function`, not left to amortization.

### F6 — the A/B shell drivers use warm-up windows too short to be meaningful

`scripts/separator-stream-ab.sh:11-12` runs the timing A/B at
`--warm-up-time 0.1 --measurement-time 0.2 --sample-size 10`, and reports the median via
`--output-format bencher` with no interval. `scripts/contextual-rank-map-ab.sh` and the two
`*-memory-ab.sh` scripts use the same 0.1/0.2 settings (for the memory scripts that is
harmless, since RSS is the measurand). A 100 ms warm-up does not reach a stable
frequency/boost state on a modern desktop part. The script does pin (`taskset -c 2`) and
rotate over 7 rounds, which partly compensates, but 10 samples at 200 ms with no reported
spread is not enough to defend a percentage-level claim.

### F7 — the documented replay command does not reproduce the documented configuration

`BENCHMARKS.md:199-200` describes the contextual-state A/B as "two interleaved rounds with
the A/B order reversed, 15 Criterion samples per round, a one-second warmup, and a
half-second measurement window", and `:226-227` says to replay it with
`scripts/contextual-ab.sh` — with no arguments. The script's defaults
(`scripts/contextual-ab.sh:4-6`) are `rounds=2, sample_size=20, measurement_seconds=1`, i.e.
20 samples and a 1 s window, not 15 and 0.5 s. Either the document or the defaults is stale;
as committed, the replay command produces a different protocol from the one described.

---

## 3. Reproducibility of the reported numbers

### F8 — the machine record omits everything that matters (high impact)

`evidence/benchmarks.json → method` records, in full:

```json
{"cpu_affinity": 2,
 "machine": {"machine":"x86_64","node":"grover","processor":"","release":"7.0.9",
             "system":"Linux","version":"#1-NixOS SMP PREEMPT_DYNAMIC ..."},
 "memory":"process VmHWM/resource ru_maxrss", "ordering":"rotated interleaving",
 "ortools":"9.14.6206; CP-SAT; one worker; random seed zero; model reused across repetitions",
 "rounds":7, "rust_ab_rounds":11,
 "timing":"in-process monotonic elapsed time including input compilation"}
```

`platform.uname().processor` is empty on Linux, so **no CPU model is recorded anywhere**.
Also absent: `scaling_governor`, `no_turbo` / `boost`, SMT topology, whether CPU 2's
hyperthread sibling was idle or loaded, `rustc -vV`, the resolved nix store paths for the
competitor toolchains, and the `perf` event-multiplexing ratio. The document instead
identifies the host in prose as "this Zen 5 host" (`:667`) and "the 24-core benchmark host"
(`:686`). Pinning to a single logical CPU without also isolating its SMT sibling means an
unrelated process on the sibling can move any of these numbers by tens of percent.

Minimum fix, all cheap: capture `/proc/cpuinfo model name`, the governor and boost state for
the pinned CPU, `lscpu -e` topology, `rustc -vV`, and the exact `RUSTFLAGS` into `method`,
and refuse to write evidence if the governor is not `performance` or if boost is enabled.

### F9 — several reported figures are explicitly from a loaded host

`BENCHMARKS.md:305-306` ("On the current loaded host, two-fiber trace/product reconstruction
takes 33.212 ns"), `:784-785` ("A complete 26-row replay measures 320 ns under the
loaded-host Criterion run"), `:791-796` ("On a heavily loaded host, fixed-affinity Criterion
diagnostics gave 104.79 us ... These are provisional microbenchmarks ... not clean-host or
SOTA claims"). The disclosure is exemplary and I want to credit it. The practice is not:
a loaded-host number reported to five significant figures ("33.212 ns", "104.79 us") is
precision theater. Either re-run on a quiesced host or round to the precision the conditions
support (~30 ns, ~100 us).

### F10 — no dispersion is reported anywhere except one t-statistic

`python/run_benchmarks.py:88-101` computes `median_ns_per_solve` and `median_peak_rss_kib`
and stores the raw `samples` list — so the data exists — but every table in `BENCHMARKS.md`
prints a bare median or point estimate. The single exception is the official MATA comparison
(`:284-286`): "geometric-mean speedup is 2.699x with instance-level log `t=26.20`; the median
instance speedup is 2.809x", backed by `python/run_mata_official_ab.py:41-46`, which computes
a paired log-ratio mean and `mean/sqrt(var/n)`. That is the right shape for all of them.

What Lemire would demand for every row: **min, median, and either IQR or a bootstrap CI**,
with min reported because for a deterministic kernel on a quiesced machine the minimum is the
least-contaminated estimator; a median that sits far above the min is itself the evidence
that the machine was noisy.

### F11 — precision of reported ratios far exceeds the data

"ergodis 173,996x" (`:80`), "ergodis 319,347,596x" (`:155`), "ergodis 494,061x" (`:157`),
"344,300x" (`:469`). These are six-to-nine-significant-figure ratios derived from a median of
11 (or in several rows, **1**) samples. `ratio()` at `run_benchmarks.py:179-180` rounds to
three decimals and the document then prints all digits. One significant figure would be more
informative and less falsifiable: "~2×10⁵".

---

## 4. Are the comparisons apples-to-apples?

### F12 — the protocol is warm-loop mean for ergodis vs. cold single-shot median for the control (highest correctness-of-claim impact)

`python/run_benchmarks.py:380-393`:

```python
cases = {"azure_lrc_batch": ("azure", (100_000, 100_000), 100_000, 1), ...}
rust_result  = run_group((rust,),  rust_repetitions, args.ab_rounds)[rust]   # 100_000 reps
cpsat_result = run_group((cpsat,), 1,                cpsat_rounds)[cpsat]    # 1 rep
```

The ergodis side runs the kernel **100,000 times in one process** (1,000 for the repair DAG,
100 for QC-LDPC and GPU MDS) and reports total-elapsed ÷ repetitions — an arithmetic mean of
a fully warmed steady state: branch predictors trained on one input, L1/L2 hot, allocator
arenas hot, page tables faulted in. `src/bin/bench_kernels.rs:497` starts the clock once
before the loop and `:680` stops it after, so there is one timestamp pair for all 100,000
iterations and *no within-process distribution at all*.

The control side runs the model **once** (`repetitions=1`) and takes the median of 11 such
cold single-shot processes. The control therefore pays first-touch page faults, cold
allocator, cold branch predictors, and cold instruction cache on every measured sample.

This asymmetry is not disclosed in the Methodology section (`:96-109`), which says only that
"the headline controls use eleven rounds" and "all Rust rows" use seven. It should say
plainly: *ergodis is measured as a warm-loop amortized mean; controls are measured cold,
once per process.* A protocol that matches the claim measures both sides at the same
repetition count, or reports the ergodis first-iteration cost separately.

### F13 — the Azure LRC row compares a ~28 ns arithmetic kernel against Python-side model construction

`BENCHMARKS.md:80` reports "Azure LRC | 100,000 demands, domain cap 100k | HiGHS counted
integer model | <1 us | 4,877 us | ergodis 173,996x". Inverting the ratio, the ergodis time is
4877/173996 ≈ **28 ns** — roughly 90 cycles.

`src/bin/bench_kernels.rs:588-593` shows why: the "100,000 demands" instance is passed as a
*scalar count* (`azure_lrc_12_2_2_counted(&capacities, demands)`), never as 100,000 objects.
The document does disclose the mathematics ("only six distinct load types", `:29-30`) and
labels the control "counted", so this is not concealed. But a 28 ns closed-form evaluation
compared against a control whose 4,877 us is dominated by *Python-side model construction*
(scipy `milp` matrix assembly, not HiGHS solving) is a category comparison, not a solver
comparison. The reported 173,996x is a statement about input representation.

Note also that at 28 ns the measurement sits ~1 order of magnitude above the harness floor
only because of the 100,000-iteration loop; `black_box` is correctly applied to both inputs
(`:589-590`) and the result (`:593`), so constant folding is blocked. The number is real —
its interpretation is what is inflated.

### F14 — competitor compilation flags

Two different situations, and they should be reported differently:

- **Python-hosted controls** (CP-SAT, HiGHS/scipy, pycryptosat, graphillion, OR-Tools
  max-flow) come from `uv run --with ortools==9.14.6206` etc.
  (`python/run_benchmarks.py:24-55`) — i.e. **prebuilt manylinux wheels**, generic x86-64,
  no LTO, no `-march`. The ergodis side (per F1) is *intended* to be `x86-64-v3` + thin LTO +
  `codegen-units=1`. That is a real, unstated build-flag asymmetry. It is defensible (nobody
  rebuilds OR-Tools) but must be stated.
- **The MATA comparison is the well-constructed one.** `scripts/mata-official-ab.sh:24-33`
  pins three upstream git revisions by SHA, builds MATA with `-DCMAKE_BUILD_TYPE=Release`,
  and compiles the driver with `-O3 -DNDEBUG` against the static `libmata.a`. Remaining
  asymmetry: the Rust side gets thin LTO and one codegen unit; the C++ side gets neither
  `-flto` nor cross-TU inlining into libmata's hot code, and neither side gets `-march`. Add
  `-flto` to both the cmake build and the driver link, or state the asymmetry.

Credit where due: this A/B (`python/run_mata_official_ab.py:107-166`) auto-scales the
repetition count to a target duration per instance, alternates process rounds, verifies class
counts are stable across rounds, and reports paired log-ratio statistics. It is the model the
other comparisons should follow.

### F15 — the RSS tables compare a static Rust binary against an interpreter-plus-libraries floor

`BENCHMARKS.md:162-169` presents "ergodis RSS 2.2 MiB vs CP-SAT RSS 916.6 MiB" and similar.
`peak_rss_kib()` (`src/bin/bench_kernels.rs:472-484`) reads `VmHWM` for the process. For the
Python controls that high-water mark includes CPython plus the ortools/scipy/numpy shared
objects. The tables themselves reveal the floor: *every* small control row sits at 74–79 MiB
regardless of instance size (`:440-448`, `:473-477`). So roughly 75 MiB of each control's RSS
is runtime, not solver state. The Python-vs-Rust orbit/scheduling rows do say "including
process overhead" (`:343-344`); the headline and CP-SAT RSS tables do not. Subtract the
measured empty-interpreter floor, or report both numbers.

### F16 — cold vs. warm cache, and the one place it is handled well

The contextual-state cold/warm split (`:203-224`) is done properly: separate `_cold` and
`_warm` Criterion groups, an explicit statement that the cold pass performs the same 255
scalar probes as direct enumeration, an explicit crossover threshold ("its threshold is
two"), and a reported *regression* (`0.68x`) for the cold rank-bounded case rather than
quietly dropping it. That is the right way to present a cache. The Jin–Fu table (`:241-244`)
extends the same discipline with a one-query column and an eight-query warm column.

---

## 5. Hardware-counter evidence

There **is** real perf-counter evidence, which puts this ahead of most benchmark documents:

- `python/run_benchmarks.py:140-176` runs `perf stat -M PipelineL1` and a
  `backend_bound_group` and stores the raw CSV, giving the Zen 5 top-down table at
  `BENCHMARKS.md:560-565` (retiring / frontend / bad-speculation / backend / memory / core
  per kernel), with the multiplexing caveat stated.
- `:626-633`: ~661,000 cycles, 2.01 M instructions, 341,000 branches, 454 branch misses, 961
  cache misses per solve, plus **instructions per examined transition falling 357 → 61**.
- `:655-658`: instructions/transition 62.5 → 51.5 and L1D misses −11% for the 8-byte witness
  node change.
- `:785-789`: 9.09 ns, 37.2 cycles, 145.4 instructions, ~0.00005 L1D misses **per row** for
  the high-fiber ledger, with the correct conclusion drawn ("compute/front-end work, not
  cache-miss bound; packed-nibble or SIMD rewriting is not justified by this profile").
- `:659-664`: L1I was measured (~0.1% fetch misses) before rejecting an I-cache change, and
  glibc `memmove` was measured at ~1.2% of samples before rejecting hand-written copy code.
  Rejecting optimizations on measurement is the right instinct and is rare.

### F17 — the perf evidence has no repetition and does not cover the headline rows

`run_perf_group` (`:140-148`) invokes `command(variant, 1)` — **one repetition, one run, no
rounds, no median**. Counter values, especially multiplexed TMA groups, need at least 5–7
runs with a median and a reported multiplexing fraction. And the coverage is confined to the
scheduler / balanced / orbit kernels: there is no instructions-per-state or IPC evidence for
the observational compiler (the basis of the MATA 2.699x claim) and none for any of the six
headline application rows.

### F18 — what Lemire would add

1. **A normalized rate for every row**, not just the scheduler: ns/state and
   instructions/state for the observational compiler against MATA; ns/support for Ceph;
   ns/assignment for GPU MDS. The crate already emits `work` counters
   (`bench_kernels.rs:682`) for exactly this — they are recorded in the evidence file but
   almost never turned into a rate in the document.
2. **IPC and branch-miss rate alongside every wall-clock A/B**, so that a claimed win can be
   attributed (fewer instructions? better IPC? both?). The 357 → 61 instructions/transition
   line is the single most convincing sentence in the whole document precisely because it
   does this.
3. **min / median / IQR** for every table, replacing bare medians (F10).
4. **One `scripts/reproduce.sh`** that: asserts the governor is `performance` and boost is
   off, records CPU model + `rustc -vV` + resolved flags into `method`, sets `RUSTFLAGS` to
   the documented target, runs the full suite, and diffs the produced `benchmarks.json`
   against the committed one within a stated tolerance. Today the replay instructions are
   ~10 separate `nix shell ... python3 python/run_benchmarks.py --write --<phase>-only`
   invocations spread over `BENCHMARKS.md:184-192, 486-487, 866-888` with an undocumented
   ordering dependency (several phases `raise SystemExit("run the baseline benchmark
   before --<phase>-only")`, e.g. `run_benchmarks.py:377-379`).

---

## 6. Hot-path findings from the source skim, ranked by impact

Preface: the crate is already unusually disciplined. There are **no** `std::collections::HashMap`/
`HashSet` with the default SipHash hasher in any of the four files (only two `BTreeMap`/`BTreeSet`
uses, one of which is a test); `rustc-hash` is used throughout (`FxHashMap` appears 9× in
`composition.rs`, 9× in `applications.rs`, 4× in `observational.rs`); there are no `Vec<Vec<_>>`
field types; `contextual.rs` already implements a hand-rolled flat open-addressed cache with a
byte-pool and reused scratch (`contextual.rs:128-250`). The findings below are the residue.

### H1 (highest) — `assign_signatures`: one heap allocation + one `BTreeMap` probe per state per refinement round
`src/observational.rs:3198-3233`, called from `refine_partition` (`:3183-3196`), called from the
fixpoint loop `minimize_partition` (`:2938-2952`).

```rust
let mut signatures: BTreeMap<Vec<u32>, u32> = BTreeMap::new();   // :3208
for state in range.start..range.end() {
    let mut signature = Vec::with_capacity(2 + outgoing);        // :3211  malloc per state
    ...
    let class = match signatures.get(&signature) { ... };         // :3214  O(log k) memcmp, pointer-chasing
    signatures.insert(signature, class);                          // :3221  (miss) moves the Vec
}                                                                 //         (hit) frees the Vec
```

This is Moore's algorithm: the loop at `:2943-2950` re-runs `refine_partition` until the class
vector stops changing, so the per-state `malloc`/`free` and the `BTreeMap` probe are paid
`rounds × states` times, and `rounds` is worst-case `O(states)`. The `observational_compiler`
bench's `chain_presentation(256)` is precisely the worst case — a chain that splits off one
state per round — so it performs on the order of 65,000 allocations and BTreeMap probes.

Two independent fixes, both output-preserving:
- **Replace `BTreeMap` with `FxHashMap`.** Safe: class IDs are assigned by `next_class`
  incrementing during the *state* scan (`:3216-3222`), never from map iteration order, so the
  emitted partition is byte-identical regardless of the map's ordering. Removes the
  `O(log k)` chain of dependent loads per state.
- **Replace the per-state `Vec` with one flat arena.** All signatures in a sort have the
  identical width `2 + outgoing` (`:3209, 3211`). Write them into one `Vec<u32>` of stride
  `2+outgoing` reused across rounds and key the map by row index with a hash over the row.
  Removes the malloc/free pair entirely.

This is the hot path behind the entire MATA external-validity claim (`BENCHMARKS.md:274-298`,
2.699x geometric mean over MATA Hopcroft). It is also the place to note that Moore is
`O(n²)` where Hopcroft is `O(n log n)` — the win on the 169 official Presburger instances is
real, but the asymptotic exposure is worth stating in the document.

### H2 — `minimum_node_span_repair`: full deep clone of the state set *and* a full index rebuild per node
`src/applications.rs:1487-1533`. This is the "vector node span" headline row
(`BENCHMARKS.md:83`, 10 us, claimed 4,717x).

```rust
for (node, node_rows, node_data) in &node_bases {
    let old = states.clone();                                     // :1494  deep-clones every Box<[u8]> ×2
    let mut index: FxHashMap<Box<[u8]>, usize> = states.iter().enumerate()
        .map(|(position, state)| (state.data.clone(), position)).collect();  // :1495-1499  clones every key again
    for state in old {
        let mut data = state.data.to_vec();                       // :1502
        ...
        let mut nodes = state.nodes.to_vec();                     // :1513
        let key: Box<[u8]> = data.into_boxed_slice();             // :1515
        if let Some(&position) = index.get(&key) { ... }          // :1516
        index.insert(key.clone(), states.len());                  // :1527  third copy of the same bytes
```

Roughly **six heap allocations per (node, state) pair**, plus two whole-collection clones per
node. Fixes in increasing order of effort:
- The `states.clone()` at `:1494` exists only to dodge a borrow conflict with the `states.push`
  at `:1528`. Iterate `for i in 0..old_len` by index instead; new entries are appended past
  `old_len`, so indices stay valid and the mutation at `:1517-1519` becomes a plain indexed
  write. **Removes the largest allocation source with zero behavioural change.**
- `key.clone()` at `:1527` duplicates bytes that are moved into the state at `:1530` one line
  later. Insert the `Box` into the map and store the state index, or use the entry API.
- Carry `index` across nodes (it is rebuilt from scratch every iteration at `:1495`) and key it
  by state index over a flat byte arena, as `contextual.rs:128-250` already does.

### H3 — `CompositionTable::compose`: a `Box<[u8]>` allocated per distinct state, duplicating bytes already in the arena
`src/composition.rs:434-484` (sequential) and `:1017-1049` (parallel).

```rust
let mut next_index: FxHashMap<Box<[u8]>, usize> = FxHashMap::default();  // :435  no capacity reserve
...
let label = labels.push(output_rows, demand_cols, &target);              // :464  bytes copied into the arena
next_index.insert(target.clone().into_boxed_slice(), position);          // :468  same bytes copied AGAIN into a fresh Box
```

Every distinct state pays two copies of its byte vector and one `malloc`. `FlatMatrixArena`
already stores the canonical bytes; the map should be keyed by the arena label id with a hash
computed over `labels.get(id).data` — i.e. exactly the `FlatCostCache` design already present
at `contextual.rs:129-250`. The map is also created with no capacity hint, so it rehashes and
grows repeatedly within each block.

The parallel path repeats the same pattern **per worker** (`:1020` `FxHashMap<Box<[u8]>, _>`,
`:1040` `target.clone().into_boxed_slice()`), which makes the global allocator a shared
contention point across all rayon workers. That is a concrete, testable explanation for the
scaling plateau reported at `BENCHMARKS.md:686-690` — composition improves 4.925 ms → 1.562 ms
at 16 workers (3.15x on 24 cores) and then *regresses* to 1.831 ms at 24. Per-worker flat
arenas with no per-state malloc is the experiment to run before concluding the workload is
inherently unscalable.

Secondary: `:478-483` sorts `next` with a comparator that dereferences into the arena for both
operands on every comparison — `O(n log n)` dependent loads. Sorting `(u64 prefix, id)` pairs
and falling back to the full compare only on prefix ties would cut most of them.

### H4 — `cached_context_cost_if_complete`: five allocations per warm cache query, plus a full re-validation before the lookup
`src/contextual.rs:720-767`:

```rust
let mut ambient_key       = vec![0u8; self.target_rank * self.block_count];   // :728
let mut pivots            = Vec::with_capacity(max_rank);                     // :729
let mut coefficient_basis = vec![0u8; max_rank * basis.rows()];               // :730
let mut free              = Vec::with_capacity(max_rank * basis.rows());      // :731
let mut digits            = vec![0u8; max_rank * basis.rows()];               // :732
```

The identical five-allocation block is repeated in the cold path at `:801`. Worse, every
`context_cost_cached` call first runs `validate_context` (`:782-784` → `:1284-1300`), which
performs a **full canonical row reduction** of the input basis (`canonical_row_basis_field`,
allocating a new `Matrix`), builds a `vec![0u8; block_count]`, wraps it in another `Matrix`,
and runs `row_space_contains_field` — all before a single cache slot is probed.

So the "rank-bounded context cache, warm query 2.342 us / 5.82x" and "projective line cache,
warm query 7.226 us / 2.04x" rows (`BENCHMARKS.md:207, 210`) are dominated by re-validation
and setup allocation, not by the cache. The crate already has the right pattern for this: the
scheduler's `WeightedRepairWorkspace` (`BENCHMARKS.md:635-646`) bought 1.538x / 1.227x /
1.102x by retaining exactly these allocations across solves. A `ContextQueryWorkspace` owned
by the cache, plus a validated-basis fast path for repeat queries on the same basis, is the
same trick on a hotter loop.

### H5 — `multiply_bases_into`: the non-GF(2) branch skips the zero-skip and recomputes indices
`src/contextual.rs:1341-1374`. The `F::ORDER == 2` branch (`:1348-1361`) correctly `continue`s on
a zero coefficient and slices the ambient row once. The generic branch (`:1362-1373`) does
neither:

```rust
for row in 0..rank {
    for middle in 0..ambient.rows() {
        let scalar = coefficients[row * ambient.rows() + middle];   // no zero check
        for col in 0..ambient.cols() {
            let index = row * ambient.cols() + col;                  // recomputed per element
            output[index] = F::add(output[index],
                F::mul(scalar, ambient.as_slice()[middle*ambient.cols()+col]));  // recomputed per element
```

The coefficient matrices come from `enumerate_rref_subspaces`, so they are in reduced row
echelon form and therefore *mostly zero*. Adding the same `if scalar == 0 { continue; }` and
hoisting `&mut output[row*cols..(row+1)*cols]` and `ambient.row(middle)` out of the inner loop
is a few lines. This is the inner kernel of the GF(4) projective path behind the Jin–Fu
6.06x / 14.79x cold-cache claims (`BENCHMARKS.md:246-247`).

### H6 — `hash_key`: byte-at-a-time FNV-1a with a fully serial multiply chain
`src/contextual.rs:252-259`. One 64-bit multiply per input byte, each dependent on the last —
a ~3-cycle-per-byte serial chain on Zen. Called once per subspace probe in both the warm loop
(`:747`) and the cold loop (`:828`), so it is on the critical path of every cache query. Keys
are fixed-width (`key_len` is a struct field, `:130`) and length-prefixed by construction, so a
word-at-a-time hash (FxHash's `wrapping_mul` + rotate over `u64` chunks, or wyhash) is a drop-in
replacement with no key-collision risk beyond what the full-key comparison at `:201` already
guards. Lower impact than H1–H5 because the keys are short, but it is free.

### H7 — `ceph_xor_repair_supports`: loop-invariant `group`/`sources` rebuilt on every fixpoint round
`src/applications.rs:285-336`. The fixpoint `loop` at `:293` re-executes, for every round:

```rust
let mut group = Vec::with_capacity(layer.data.len() + 1);   // :297  alloc
group.push(...); group.extend(...);
group.sort_unstable(); group.dedup();                        // :300-301  sort per round
if group.len() != layer.data.len() + 1 { return Err(...) }   // :302  shape validation per round
for &destination in &group {
    let sources: Vec<_> = group.iter().copied()
        .filter(|&c| c != destination).collect();            // :306-310  alloc per destination per round
```

`group` and `sources` depend only on `layer` and `destination` — nothing the fixpoint mutates.
They should be computed once before `loop`, together with the shape validation at `:302`,
which currently re-validates unchanged input on every round. Additionally `products` is
reallocated once per source (`:319-320`, `mem::take` + fresh `Vec::with_capacity`) where a
double-buffer pair swapped between iterations would allocate twice total. Impact is capped
because `BENCHMARKS.md:124-128` states this explicit path has been superseded by the ZDD
kernel (it is the 728,737 us / 10.2 MiB row at `:136-137`), but the variant is still
exercised by `bench_kernels`.

### H8 (low, note only) — `search_trapping_sets` allocates its scratch per anchor group
`src/applications.rs:1145-1146`: `vec![anchor]` and `vec![0u16; check_count]` are allocated
inside the `for anchor_group in ...` loop at `:1143`. With `check_count = check_groups × lift`
and lift = 50,000 in the headline QC-LDPC row (`BENCHMARKS.md:82`), that is a 100 KB+ zeroed
allocation per anchor group. Hoist both out of the loop and `fill(0)` per group instead. Minor
relative to the search itself, but it is a large `calloc` in a loop.

---

## 7. Priority order

| # | Finding | Kind | Why first |
|--:|:--------|:-----|:----------|
| 1 | F12 warm-loop mean vs. cold single-shot control | methodology | Every headline multiplier inherits it; fixing the *description* is free, fixing the protocol is a harness edit |
| 2 | F1 `target-cpu=x86-64-v3` claimed but not committed | reproducibility | No documented replay command reproduces any reported number |
| 3 | H1 per-state alloc + `BTreeMap` in partition refinement | hot path | Backs the MATA claim; `BTreeMap`→`FxHashMap` is output-identical and near-free |
| 4 | F8 no CPU model, governor, boost, or SMT state recorded | reproducibility | Cheap to capture, currently unverifiable |
| 5 | H2 deep clone + index rebuild per node in node-span repair | hot path | ~6 allocations per transition; the `states.clone()` removal is behaviour-neutral |
| 6 | F10/F11 medians only, ratios to 6–9 significant figures | reporting | Raw samples already committed; only the presentation is wrong |
| 7 | H3 `Box<[u8]>` per state in composition | hot path | Also the leading hypothesis for the 16→24 worker regression |
| 8 | H4 five allocations + full re-validation per warm cache query | hot path | The warm-cache rows measure setup, not the cache |
| 9 | F13 Azure row: 28 ns kernel vs. Python model construction | claim framing | Mathematically disclosed, but 173,996x reads as a solver comparison |
| 10 | F3/F4 no `iter_batched`; loop-invariant bench bodies | criterion | Affects the sub-microsecond Criterion figures specifically |
| 11 | F15 RSS tables include a ~75 MiB interpreter floor | claim framing | Subtract the measured floor or report both |
| 12 | H5/H6/H7/H8, F2, F5, F6, F7, F9, F14, F17 | mixed | Individually small; F7 and F9 are documentation-only fixes |
