# C1030 audit — core ergodis library crate

**Task**: C1030 · **Lane**: `complete-ports` · **Scope**: core ergodis library crate

Scope covered: `papers/complete-repair-ports/ergodis/src/` — `field.rs`, `projective.rs`, `lib.rs`,
`matrix.rs`, `linear_code.rs`, `modular_power.rs`, `prime_polynomial.rs`, `character_sum.rs`,
`packed_ternary.rs`, `multiset.rs`, `bitset.rs`, `incidence.rs`, `quadratic_window.rs`, `span.rs`,
`arena.rs`, `witness.rs`, plus the arithmetic and parallel-dispatch entry points of `contextual.rs`
and `scheduler.rs`, and the `parallel` / `control-plane` feature wiring in `Cargo.toml`.

## Verdict

The arithmetic core is in better shape than its size suggests. The extension-field construction in
`field.rs` (irreducibility test, polynomial division, modular reduction, table build) is correct on
every path I traced, is exhaustively tested for all campaign orders up to `GF(2^8)`, and its
integer widths are chosen so no intermediate overflows. `quadratic_window.rs`,
`prime_polynomial.rs`, `packed_ternary.rs`, and `multiset.rs` are each carefully bounded, and the
Rayon paths I checked collect by index rather than reducing nondeterministically, so parallel
results are bit-for-bit reproducible.

The defects cluster in the *shape and precondition* layer rather than in the field arithmetic
itself: one public matrix predicate that confuses a row count with a rank and therefore returns the
wrong answer in the unsafe direction, one overflow guard that uses `checked_shl` where it needed
`checked_mul` and so returns `Ok` on garbage, one uncapped exponential enumeration that aborts the
process instead of returning an error, and two API surfaces where the type system does not carry
the field identity that the arithmetic depends on. Nothing I found corrupts a *currently* committed
paper-facing number, but finding 1 is reachable from ordinary inputs and would do so silently.

## SEV1 — `Matrix::row_space_contains_field` uses the row count as the rank

**Location**: `papers/complete-repair-ports/ergodis/src/matrix.rs:209-222`

```rust
    pub fn row_space_contains_field<F: FiniteField>(
        &self,
        candidate: &Matrix,
    ) -> Result<bool, MatrixError> {
        if self.cols() != candidate.cols() {
            return Err(MatrixError::Shape);
        }
        let rank = self.rows();
        let mut joined = self.clone();
        for row in 0..candidate.rows() {
            joined = joined.append_row_field::<F>(candidate.row(row))?;
        }
        Ok(joined.canonical_row_basis_field::<F>()?.rows() == rank)
    }
```

**Mechanism.** The containment test is "adjoining the candidate rows does not increase the rank",
which requires comparing `rank(joined)` against `rank(self)`. The code compares it against
`self.rows()`, the stored row count. These agree only when `self` already has full row rank. When
`self` is rank-deficient the predicate is wrong in *both* directions, and the false-positive
direction is the dangerous one: if `self` has exactly one redundant row, then adjoining a candidate
that lies **outside** the row space produces `rank(self) + 1 == self.rows()`, and the function
reports containment.

**Concrete trigger.** Over GF(2), let `self = Matrix::new::<2>(3, 3, vec![1,0,0, 0,1,0, 1,1,0])`
(three rows, rank two, spanning the `z = 0` plane) and
`candidate = Matrix::new::<2>(1, 3, vec![0,0,1])`. The candidate is not in the row space. `rank` is
set to `3`; `joined` is four rows of rank three; `canonical_row_basis_field` returns three rows;
`3 == 3`, so the call returns `Ok(true)`. The mirror case
`self = Matrix::new::<2>(2, 2, vec![1,0, 1,0])` with `candidate = [1,0]` returns `Ok(false)` for a
vector that *is* a row of `self`.

**Impact.** `Matrix` is re-exported at `lib.rs:166`, and both `row_space_contains` and
`row_space_contains_field` are public with no documented precondition and, as far as I can find, no
test at all — `rg` finds only the two definitions and the single internal call site. That internal
call site, `contextual.rs:1526` inside `validate_context`, happens to be safe because
`contextual.rs:1522` reduces the basis to canonical form on the line immediately before, so the
crate's own use is unaffected today. Any external or future caller that passes a raw generator
matrix gets a containment verdict that is silently wrong, and a wrong `true` is an assertion that a
target lies in a span when it does not — exactly the shape of claim a repair-port or confinement
argument would rest on.

**Described fix (not applied).** Compute `let rank = self.canonical_row_basis_field::<F>()?.rows();`
instead of `self.rows()`, and add a doc line stating that the comparison is between ranks. If the
intent was to make the caller supply an already-reduced basis, then state that precondition in the
doc comment and return `MatrixError::Shape` when `self.canonical_row_basis_field::<F>()?.rows() !=
self.rows()`, so the misuse is loud rather than silent. Either way the function needs direct tests,
including a rank-deficient `self` in both the contained and not-contained cases.

## SEV2 — `BinaryProjectiveIndex::new` overflow guard uses `checked_shl`, which cannot detect lost bits

**Location**: `papers/complete-repair-ports/ergodis/src/projective.rs:152-158`

```rust
        let mut blocks = Vec::with_capacity(usize::from(vector_dimension));
        for _ in 0..vector_dimension {
            blocks.push(block);
            block = block
                .checked_shl(u32::from(H))
                .ok_or(ProjectiveError::DimensionOverflow)?;
        }
```

Compare the generic sibling it is documented as an "exact representation specialization" of
(`projective.rs:127`), at `projective.rs:45-50`:

```rust
        for _ in 0..vector_dimension {
            blocks.push(block);
            block = block
                .checked_mul(u64::from(field.order()))
                .ok_or(ProjectiveError::DimensionOverflow)?;
        }
```

**Mechanism.** `u64::checked_shl` returns `None` only when the *shift amount* is at least 64; it
does not report bits shifted off the top. `(1u64 << 56).checked_shl(8)` is `Some(0)`, not `None`.
The generic path's `checked_mul` does detect the overflow. So the two constructors, which are meant
to agree, disagree at the boundary — and the binary one fails open.

**Concrete trigger.** `BinaryProjectiveIndex::<8>::new(&SmallField::new(2, 8)?, 8)`, i.e.
`PG(8, 256)`. The block loop runs nine times and pushes `[1, 2^8, ..., 2^56, 0]`: the ninth push is
the wrapped zero. Accumulating in reverse then yields `offsets = [0, 0, 2^56, 2^56 + 2^48, ...]`,
so `offsets[0]` and `offsets[1]` collide at zero, and `point_count` is a meaningless partial sum.
The constructor returns `Ok`. Immediately, `point(0, &mut out)` runs
`partition_point(|&end| end <= 0)` over `offsets[1..]`, finds the leading zero, and selects pivot 1,
writing `[0,1,0,0,0,0,0,0,0]` — while `index(&[1,0,0,0,0,0,0,0,0])` returns 0. Rank and unrank are
no longer inverse. `ProjectiveIndex::new(&field, 8)` on the same field returns
`Err(DimensionOverflow)`. The general condition for corruption is `H * projective_dimension >= 64`.

**Impact.** I could not construct a case where this corrupts a *valid* computation: whenever
`H * d >= 64`, the true point count `(q^(d+1) - 1)/(q - 1)` already exceeds `u64::MAX`, so the
correct behaviour is the error the generic path gives. The bug therefore converts a clean
`DimensionOverflow` into a silently broken indexer, rather than corrupting an answer that should
have been computable — hence SEV2 rather than SEV1. It is still a live hazard because a caller who
checks the `Result` is entitled to trust the `Ok`.

A second, opposite divergence sits in the same pair of loops: both compute one block beyond the
last one they need, so the generic constructor rejects `PG(7, 256)` (its discarded ninth block is
`256^8 = 2^64`) even though the point count `(256^8 - 1)/255 ≈ 7.2e16` fits comfortably in `u64`.
There, the binary constructor is the correct one and the generic constructor is spuriously strict.
The crate's own agreement test (`projective.rs:469-482`) only exercises projective dimension 4, so
neither divergence is covered.

**Described fix (not applied).** Replace the shift with `block.checked_mul(1u64 << H)`, or keep the
shift and add an explicit `block.leading_zeros() >= u32::from(H)` precondition. Then hoist the block
computation so the extra, unused block is never computed at all — compute `blocks` for exactly
`vector_dimension` entries by checking before multiplying rather than after. Finally, extend
`binary_index_agrees` to a projective dimension where the two constructors are near the `u64`
boundary, so any future divergence is caught.

## SEV3 — `GeneratedSpanTable::build` enumerates subspaces with no cap, and fails by aborting

**Location**: `papers/complete-repair-ports/ergodis/src/span.rs:69-119`, with the failure mode in
`papers/complete-repair-ports/ergodis/src/arena.rs:37-39`

```rust
        for column in columns {
            let old_len = states.len();
            for state_index in 0..old_len {
                transitions += 1;
                ...
                let basis_id = bases.push(candidate_rank, ambient, &scratch);
                let witness =
                    witnesses.push(state.witness, column.coordinate, column.inverse_scale);
                index.insert(scratch.clone().into_boxed_slice(), basis_id);
```

```rust
        let offset = u32::try_from(self.bytes.len()).expect("matrix byte arena exceeds u32");
        let len = u32::try_from(data.len()).expect("one arena matrix exceeds u32 bytes");
        let id = MatrixId(u32::try_from(self.records.len()).expect("matrix arena exceeds u32"));
```

**Mechanism.** The build is a subset-DP over the projectively distinct generator columns, keeping
one state per distinct canonical basis. The number of states is the number of distinct subspaces of
`F_P^ambient` spanned by subsets of those columns, which grows super-exponentially in `ambient` —
for a generator carrying all nonzero columns over GF(2) it is the Galois number of `F_2^ambient`,
roughly `2^(ambient^2/4)`. Every accepted state is stored **twice**: once in the `FlatMatrixArena`
(`bases`) and once again as the owned `Box<[u8]>` hash key at `span.rs:110`, each of size
`rank * ambient` bytes. There is no `max_states` argument, no bound struct, and `SpanError` has no
`TooLarge` variant, so nothing can report the wall. When it is hit, the crate either exhausts memory
or trips one of the `.expect(...)` calls in `arena.rs` / `witness.rs:36` — and because the release
profile sets `panic = "abort"` (`Cargo.toml`), that is an immediate process abort with no unwinding
and no `Result` for the campaign driver to record.

**Concrete trigger.** `GeneratedSpanTable::build::<2>` on a generator over GF(2) whose columns
include a spanning set of `F_2^k`. The `bases` arena stores `rank * ambient` bytes per state and
panics once its byte vector passes `u32::MAX`, i.e. around 4 GiB of bases; at `ambient = 16` and
average rank 8 that is roughly 33 million states, well inside the state count for a generic
generator at that ambient dimension. The query side compounds it: `query_canonical_target_image`
(`span.rs:176-194`) linearly scans every state and runs a fresh Gaussian elimination per state, with
no index, so query cost is also linear in this unbounded population.

**Impact.** Works today at the small ambient dimensions in the tests, and dies without a diagnosable
error at the next size up. This is an outlier within the crate: `scheduler.rs` caps its dense
lattice at `MAX_DENSE_LATTICE_STATES = 1 << 24` and returns `SchedulerError::TooLarge`,
`linear_code.rs` caps systematic bases at `MAX_SYSTEMATIC_WORDS = 1 << 20`, and `multiset.rs` takes
an explicit `MultisetBounds`. `span.rs` has no equivalent.

**Described fix (not applied).** Add a `max_states` (or a `SpanBounds` struct matching
`MultisetBounds`) parameter to `build`, add a `SpanError::TooLarge` variant, and check the state
count before each `bases.push`. Convert the `arena.rs` and `witness.rs` `.expect(...)` calls to
fallible `push` returning `Option`/`Result` so the arena limits surface as errors rather than
aborts. Separately, the duplicate storage can go: key the `FxHashMap` on `MatrixId` with a hash
computed from the arena bytes, or store a `u64` fingerprint plus the id, which halves peak memory.

## SEV4 — `Matrix` carries no field tag, so the same bytes silently reinterpret under a different `F`

**Location**: `papers/complete-repair-ports/ergodis/src/matrix.rs:18-62`

```rust
#[repr(C)]
#[derive(Clone, Debug, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct Matrix {
    data: Box<[u8]>,
    rows: u16,
    cols: u16,
    _pad: u32,
    _reserved: u64,
}
```

```rust
    pub fn new_field<F: FiniteField>(
        rows: usize,
        cols: usize,
        data: impl Into<Box<[u8]>>,
    ) -> Result<Self, MatrixError> {
        F::validate()?;
        ...
        if data.iter().any(|&entry| entry >= F::ORDER) {
            return Err(MatrixError::UnreducedEntry);
        }
```

**Mechanism.** The field is a generic parameter of every constructor and every operation, but it is
not recorded in the value. The only residual check is the reduced-entry test, which passes whenever
the entries happen to be below the *new* field's order. So a matrix built over one field can be
eliminated over another, with no error, whenever the second field is at least as large.

**Concrete trigger.** `Matrix::new_field::<Gf4>(2, 2, vec![2, 1, 3, 1])` builds a GF(4) matrix; all
entries are below 4. Calling `.canonical_row_basis_field::<Prime<5>>()` on it passes
`Prime::<5>::validate()` and passes the `entry >= 5` check, then runs Gaussian elimination with
GF(5) arithmetic on GF(4) polynomial-basis bytes. The returned "canonical row basis" is a
well-formed matrix and a meaningless one — for instance `Gf4::mul(2, 2) == 3` whereas
`Prime::<5>::mul(2, 2) == 4`, so the pivot normalization diverges immediately. The same applies to
`Matrix::new::<3>` data reused under `Prime<5>`, and to any `Matrix` recovered through its
`Deserialize` impl, which reconstructs the bytes with no field context whatsoever.

**Impact.** This is the exact hazard the crate documents and defends against elsewhere:
`SmallField`'s doc comment (`field.rs:181-185`) warns that "callers importing externally encoded
algebra data must establish that field identity before using it with this type",
`ProjectiveIndex`'s (`projective.rs:21-23`) repeats the warning for chain-ring coordinates, and
`span.rs` actually implements the guard — `CanonicalTargetImage` stores `field_order: u8`
(`span.rs:44-49`) and `query_canonical_target_image` rejects a mismatch with
`SpanError::ImageField` (`span.rs:167-172`). `Matrix`, which is the type every one of those paths
hands around and which is re-exported at `lib.rs:166`, has no such tag. Nothing in the crate is
currently wrong because of it; the risk is entirely in the next caller, and it is heightened by the
`Serialize`/`Deserialize` impl that lets untagged matrices cross a process boundary.

**Described fix (not applied).** Give `Matrix` the `field_order: u8` tag that `CanonicalTargetImage`
already carries — it fits in the existing `_pad: u32` without changing the asserted 32-byte layout —
set it in `new_field` and `new_with_field`, and have every `*_field::<F>` and `*_with` operation
reject a mismatch with a new `MatrixError::FieldMismatch`. For extension fields the tag should be
the pair `(characteristic, degree)` rather than the order alone, so `GF(4)` and `Z/4Z`-shaped data
cannot alias even if a chain-ring type is added later.

## SEV4 — `Prime<P>` arithmetic is public and unvalidated, and returns `Ok` for a nonexistent inverse

**Location**: `papers/complete-repair-ports/ergodis/src/field.rs:50-93`

```rust
impl<const P: u8> Prime<P> {
    pub fn validate() -> Result<(), FieldError> {
        if P < 2 || !is_prime(P) {
            return Err(FieldError::InvalidModulus);
        }
        Ok(())
    }

    #[inline(always)]
    pub fn add(left: u8, right: u8) -> u8 {
        let sum = left as u16 + right as u16;
        (sum % P as u16) as u8
    }
    ...
    pub fn inverse(value: u8) -> Result<u8, FieldError> {
        if value == 0 {
            return Err(FieldError::ZeroInverse);
        }
        Ok(Self::pow(value, P as u16 - 2))
    }
```

**Mechanism.** `validate()` exists but nothing forces a caller to run it: `Prime<P>` is a
zero-sized type with no constructor, and `add`, `sub`, `mul`, `pow`, and `inverse` are all `pub`
inherent methods usable on any `P`. `inverse` implements Fermat's little theorem, which is only an
inverse when `P` is prime; for composite `P` it returns a plausible byte wrapped in `Ok`, with no
error and no way for the caller to notice.

**Concrete trigger.** `Prime::<9>::inverse(3)` computes `3^7 mod 9 = 2187 mod 9 = 0` and returns
`Ok(0)` — a "multiplicative inverse" of zero. `Prime::<8>::inverse(2)` returns `Ok(0)` likewise.
`Prime::<1>::mul(a, b)` returns `0` for every input, so every matrix is rank zero.
`Prime::<0>::add(0, 0)` evaluates `0u16 % 0` and panics with a divide-by-zero — a panic, not an
error, from a `pub` function, and under the release profile's `panic = "abort"` that is a process
abort. `Prime` is re-exported at `lib.rs:133`.

**Impact.** Every in-crate consumer I checked does validate first — `Matrix::new_field`
(`matrix.rs:45`), `Matrix::canonical_row_basis_field` (`matrix.rs:144`), and all three entry points
in `span.rs` (lines 70, 148, 166) call `F::validate()` before touching arithmetic — so the crate is
currently safe. The exposure is the public surface: nothing in the type signature distinguishes a
validated `Prime<P>` from an unvalidated one, and the failure is silent rather than loud.

**Related asymmetry in the same file.** The two runtime-field views disagree on how they handle an
out-of-domain operand. `SmallField::table_index` (`field.rs:402-412`) uses a real `assert!` and
panics in release; `BinarySmallField::mul` (`field.rs:250-254`) uses `debug_assert!` and then
indexes, so in a release build the same misuse is either a bounds panic or, at `H = 8` where every
`u8` is a legal index, no diagnostic at all. `BinarySmallField::inverse_nonzero`
(`field.rs:268-272`) likewise returns the table's zero slot — `0` — if handed a zero, which is only
safe because its one caller, `projective.rs:203`, establishes non-zeroness first.

**Described fix (not applied).** Make validation unavoidable rather than advisory: either move the
prime check into a `const` assertion evaluated at monomorphization
(`const _: () = assert!(is_prime(P));` inside the impl, which `is_prime` already supports since it
is a `const fn`), which turns `Prime::<9>` into a compile error; or, if runtime-selected moduli must
stay possible, replace the free functions with methods on a `ValidatedPrime<P>` witness returned by
`validate()`. Separately, either promote `BinarySmallField`'s `debug_assert!`s to the same `assert!`
`SmallField` uses, or demote `SmallField`'s to `debug_assert!` and document a shared unchecked
contract — the current split means the two paths documented as equivalent are not.

## Not found / checked clean

- **`field.rs` extension-field construction.** `polynomial_is_irreducible` correctly restricts to
  monic divisors up to half the degree (every factorization over a field scales to monic factors),
  `polynomial_divides` zeroes each leading slot exactly because the divisor is monic, and both use
  `[u8; 9]` buffers that are safe because `extension_order` bounds the degree at 8 before they run.
  `extension_multiply`'s `[u16; 15]` product buffer and its reverse reduction loop are correctly
  sized, and its `(degree..=(2*degree-2)).rev()` range is empty at degree 1 as it should be. No
  intermediate overflows: `Prime::mul` peaks at `255 * 255 < u16::MAX`, and `extension_add`'s
  place-value accumulator is bounded by the order.
- **`Gf4`.** Exhaustively verified against the field axioms by the crate's own test, and the
  bit-twiddled `mul` agrees with the `SmallField::new(2, 2)` tables.
- **`SmallField` order-256 boundary.** `order: u16` with `u8` elements is consistent at exactly 256;
  the inverse table length and `BinarySmallField`'s `(left << H) | right` index are both correct at
  `H = 8`, and `BinarySmallField::new`'s `checked_shl` guard does reject `H >= 16` and, via the
  `order <= 256` filter, `H` in 9..15. This is the one place the `checked_shl` idiom is safe,
  because the shifted value is the literal `1`.
- **`projective.rs` rank/unrank.** The pivot-block offset scheme, the `partition_point` inverse, and
  the scalar-quotient normalization are correct and round-trip in the tests. The ternary plane's
  hardcoded moduli are genuinely irreducible over GF(3): `x^2 + 1` has no root because 2 is a
  non-residue mod 3, and `x^3 + 2x + 1` evaluates to 1 at all three points.
- **`quadratic_window.rs`.** The `u128` binary search for the least `q` with `q(a - q) >= b` is
  exact, symmetric, and correct at `a = u64::MAX` and at `b = 0`.
- **`prime_polynomial.rs`.** The `x^p = x` exponent fold `1 + (e - 1) % (p - 1)` is right for both
  zero and nonzero arguments, the `min(len, p)` width can never be indexed out of range, and the
  Newton forward-difference recurrence is set up and stepped correctly (the top difference is
  constant and correctly left un-updated).
- **`packed_ternary.rs`.** Twenty-one 3-bit lanes occupy 63 bits, so `self.0 + right.0` cannot carry
  between lanes or out of the `u64`; the `threes | fours` correction maps 3 to 0 and 4 to 1 exactly.
- **`modular_power.rs`.** All modular products are computed in `u64` from `u32` operands, so no
  overflow; `pow_mod(x, p - 2, p)` degenerates correctly to 1 at `p = 2`; the verifier's duplicate
  pivot-column case is caught by the rank check rather than needing a distinctness test.
- **`linear_code.rs` Brouwer–Zimmermann.** The early-exit bound is the correct one: with `m`
  pairwise-disjoint systematic information sets, an un-enumerated codeword has message weight at
  least `w + 1` in every set, so `m * (w + 1)` is a valid lower bound, and both the post-level-1 test
  and the in-loop test use exactly that. `compile_disjoint_systematic_bases` really does keep the
  sets disjoint via the `used` mask. `binomial_saturating`'s incremental division is exact and its
  `u128` accumulator cannot overflow at rank ≤ 63.
- **Rayon and feature gating.** Every `use rayon::prelude::*` outside a function body is
  `#[cfg(feature = "parallel")]`-gated, and the two in `css_distance.rs` are function-local inside
  already-gated methods, so the default build is clean. The parallel paths I checked are
  order-preserving rather than reductive: `balanced.rs:1767` collects by ordinal (and says so),
  `scheduler.rs:2077` and `scheduler.rs:2122` map over indexed `par_iter` into a `Vec<bool>`, and
  `scheduler.rs:2051`'s `par_chunks_mut(block)` is exactly equivalent to the serial
  `step_by(block)` loop it replaces because `state_space` is a multiple of every mixed-radix
  `block`. I found no non-associative parallel accumulation and no ordering-dependent output.
- **`scheduler.rs` and `multiset.rs` bounding.** Both cap their state spaces explicitly
  (`MAX_DENSE_LATTICE_STATES`, `MultisetBounds`) and return `TooLarge` rather than growing without
  limit — the pattern `span.rs` is missing.
- **Minor issues noted but not promoted.** `incidence.rs:22` returns `BitSetError::WidthMismatch`
  when `positive` and `negative` overlap, which misreports the caller's actual mistake.
  `Matrix::column` (`matrix.rs:118`) silently reads across row boundaries for an out-of-range
  column index before eventually panicking on the last row. `WitnessArena::push`
  (`witness.rs:30-45`) would mint an id equal to its own `ROOT` sentinel at `u32::MAX` nodes,
  truncating every witness support that passes through it — unreachable at 64 GB of nodes.
  `character_sum.rs`'s `PrimeMultiplicativeCharacter::new` allocates a class table linear in the
  modulus (one to four bytes per field element), so it walls at roughly `p ~ 10^9`; that is a real
  ceiling but an explicit and documented design choice rather than a defect.
