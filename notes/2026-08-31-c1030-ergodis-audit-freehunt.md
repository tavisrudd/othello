# C1030 free-hunt audit: ergodis-private shared kernels, git-visibility, and harness drift

**Task**: C1030 · **Lane**: `complete-ports` · **Scope**: free-choice — shared trust kernels (`proof_synthesis`, `bitset_sumset`, `hall_core`, `g53_sparse_dual`), the untracked-source/git-visibility state of the private crate, and the duplicated allocation-measurement harness. Chosen because the three sibling audits own the core crate arithmetic, the big search engines, and the certificate/CLI/checker surface, while every sealed proof in this crate flows through these small shared kernels — and the crate's git state undercuts every replay claim at once.

Verdict: no committed paper-facing number was found to be wrong, but the evidence chain has a structural hole — the committed crate does not compile at HEAD because roughly half its declared modules exist only as untracked working-tree files, so every replay command in committed reports is dead against any commit. Below that, two shared kernels have silent-wrong failure modes that are latent today (empty-operand sumset saturation; unchecked square-sum overflow in a proof endpoint), the modular-projection kernels have an unenforced 64-state cap one call-site guard away from wrapping, and the zero-allocation gate rests on four diverged copies of a thread-local counting harness.

## SEV2 — Committed tree does not build: declared modules exist only as untracked files

**Location**: `/home/tavis/src/othello/ergodis-private/src/lib.rs` (committed blob at HEAD, same declarations as working-tree lines 2–42); `/home/tavis/src/othello/ergodis-private/Cargo.toml` (uncommitted +26 lines).

**Code** (from `git show HEAD:ergodis-private/src/lib.rs`; working-tree line numbers):

```rust
pub mod g53_search;        // lib.rs:18 — file absent from HEAD
pub mod hadamard_2092;     // lib.rs:25 — file absent from HEAD
pub mod proof_synthesis;   // lib.rs:29 — file absent from HEAD
pub mod reduction_proof;   // lib.rs:34 — file absent from HEAD
```

**Mechanism**: 9 of the 20 modules declared in the HEAD `lib.rs` have no blob in HEAD (`g53_defect_profile_proof`, `g53_mod7_reduction`, `g53_reduction_proof`, `g53_search`, `hadamard_2092`, `proof_synthesis`, `quotient_paf_proof`, `reduction_proof`, `subgroup_energy_proof` — verified with `git cat-file -e HEAD:ergodis-private/src/<m>.rs`). They exist only as untracked working-tree files, alongside 31 untracked `src/*.rs` modules total, 75 untracked `src/bin/*.rs` binaries, uncommitted `Cargo.toml`/`Cargo.lock` bin registrations, and untracked evidence/checker pairs (`evidence/c1016-hadamard-quotient-pilot.json`, `python/check_hadamard_quotient_pilot.py`, `examples/data/campaign-c1016-g91-q29-seeds.jsonl`).

**Trigger**: `git clone` (or any clean checkout/worktree of HEAD or any recent commit) followed by `cargo check` fails at the first missing `pub mod`. Every replay command in committed reports that names these binaries is unrunnable from the commit that cites it — committed notes at HEAD cite the missing sources directly (`notes/2026-08-30-c80-hall-rematching-attack.md`, `notes/2026-08-31-certified-distance-prototype.md`, `notes/2026-08-31-infeasibility-certificate-prototype.md`, `notes/2026-08-31-c1029-parametric-certificate-instrument-test.md`).

**Impact**: The repository's own reproducibility conventions (`notes/research-reproducibility-conventions.md`) make untracked source absent from every reproducibility claim. Commits like `docs: cite durable ergodis evidence` currently cite evidence whose generators cannot be built from git; a disk loss or an over-eager clean deletes months of proof modules with no history. This is the single highest-leverage fix in the crate.

**Fix (described, not applied)**: One coherent commit series adding the 31 `src/*.rs` modules, the 75 bins, `Cargo.toml`, `Cargo.lock`, and the evidence/checker/seed files, validated by `cargo check` in a clean worktree of the resulting commit. Until then, no committed report should describe its evidence as durable.

## SEV2 — `xor_sumset_256_into` claims a saturated sumset when one operand is empty

**Location**: `/home/tavis/src/othello/ergodis-private/src/bitset_sumset.rs:10-13`.

**Code**:

```rust
if left.iter().all(|&word| word == u64::MAX) || right.iter().all(|&word| word == u64::MAX) {
    output.fill(u64::MAX);
    return;
}
```

**Mechanism**: The shortcut treats "either operand is the full 256-element set" as "the sumset is full". That is only valid when the *other* operand is nonempty (XOR against a fixed element is a bijection). For `left` full and `right == [0; 4]` (empty set) the true sumset `{l ^ r ^ offset}` is empty, but the kernel writes all 256 bits into `output`. The unit test at `bitset_sumset.rs:43` never exercises a full or empty operand.

**Trigger**: Any call where a saturated residue class meets a class with no attained residues. Call sites are the pair-image compilers in `g133_sparse_defect.rs:1258,1400,2163` and `g41_q29_evolve.rs:1331`; profiles there appear nonempty by construction today, so the bug is latent, and inside the sealed g133 q2 proof the second, independent pairwise kernel would turn the disagreement into a loud `SemanticMismatch`. A standalone or future caller has no such net.

**Impact**: Silent over-coverage — residues reported attainable that are not, which in exclusion logic flips "root impossible" analysis in the unsound direction for anyone using this kernel alone.

**Fix (described)**: Make the shortcut conditional on the other operand being nonzero: only fill when one side is full *and* the other has at least one bit; add empty×full and full×nonempty cases to the oracle test.

## SEV2 — `solve_sorted_square_sum`: unchecked u32 sum can forge solutions; isqrt hangs at `u32::MAX`

**Location**: `/home/tavis/src/othello/ergodis-private/src/proof_synthesis.rs:487-491` and `516-522`.

**Code**:

```rust
let sum = candidate
    .iter()
    .map(|&value| u32::from(value).pow(2))
    .sum::<u32>();
if sum == target {
```

```rust
fn integer_square_root(value: u32) -> u16 {
    let mut root = 0_u32;
    while (root + 1).saturating_mul(root + 1) <= value {
        root += 1;
    }
```

**Mechanism**: Up to `MAX_SQUARE_VARIABLES = 8` squares, each as large as `target`, are summed in bare `u32`. For `target > u32::MAX / 8` the sum can wrap in a release build (research binaries run `--release`; debug would panic), and a wrapped sum equal to `target` records a candidate as a solution whose true square-sum is `target + k·2^32` — a forged solution in a proof endpoint, with no error. Separately, `integer_square_root(u32::MAX)`: once `root + 1 == 65_536` the saturating product equals `u32::MAX <= value`, so the loop never terminates — `solve_sorted_square_sum(v, u32::MAX, budget)` hangs before enumerating anything. The sibling endpoint in the same file, `solve_bounded_linear_combination` (`proof_synthesis.rs:571-578`), does the same accumulation with `checked_add(...).ok_or(ArithmeticOverflow)` — the two endpoints have diverged conventions.

**Trigger**: Any adapter calling with a large target. The sole current caller, `reduction_proof.rs:588` (`generic_three_square_solutions`), passes a `u8`-bounded target (18 in practice), so this is unreached today.

**Impact**: `proof_synthesis` is the shared trust kernel for every sealed `*_proof` adapter; a future adapter with a large square-sum target gets silently wrong solutions with `ExactComputational` provenance downstream.

**Fix (described)**: Accumulate in `u64` (8 × u32 squares cannot wrap) or use `checked_add` like the linear sibling; replace the isqrt loop with a monotone binary search or `u32::isqrt`; add a large-target regression test.

## SEV4 — Projection/rotation sumset kernels have a silent 64-state cap enforced only at one call site

**Location**: `/home/tavis/src/othello/ergodis-private/src/g53_sparse_dual.rs:345-351` (also `encode_projection` at 333-343, `cyclic_sumset` at 308-313); the only guard is in one caller at 394.

**Code**:

```rust
fn projected_sumset(mut left: u64, right: u64, coordinate_count: u8, modulus: u8) -> u64 {
    let states = u32::from(modulus).pow(u32::from(coordinate_count)) as u8;
    let full = if states == 64 {
        u64::MAX
    } else {
        (1_u64 << states) - 1
    };
```

with the guard living only in `synthesize_g53_coordinate_projections`:

```rust
if u32::from(modulus).pow(u32::from(coordinate_count)) > 64 {   // g53_sparse_dual.rs:394
    continue;
}
```

**Mechanism**: The kernels assume the residue-state count fits one `u64` but validate nothing themselves. For `modulus^coordinate_count > 64` — the very next parameter step, e.g. 3 coordinates at modulus 5 (125 states) or modulus 9 at 2 coordinates (81) — `states` is a truncated `as u8` cast (216 states at modulus 6 becomes 216, at modulus 7×3 becomes 87), and `1_u64 << states` with `states > 63` panics in debug but silently wraps in release, producing a garbage `full` mask and garbage membership bits; `encode_projection`'s `u8` `code`/`place` arithmetic (line 338-339) and `cyclic_sumset`'s `modulus <= 64` rotation assumption fail the same way. The current `MODULI` table (line 23) tops out at exactly 64.

**Trigger**: A new caller, or widening the existing loops past modulus 8 / 64 states — a natural "next size up" for exactly this scout family (the crate already has mod-49 and mod-343 siblings).

**Impact**: These sumsets decide which modular roots the dual-inequality certificates exclude; wrapped masks silently corrupt the attainable-set computation, i.e., wrong exclusions from a certificate synthesizer rather than a crash.

**Fix (described)**: Make each kernel return an error (or assert) when `modulus^coordinate_count > 64` / `modulus > 64`, computing the state count in `u32` and never casting to `u8`; keep the call-site skip as policy, not as the only defense.

## SEV4 — Zero-allocation gate: four diverged copies of a thread-local counting harness

**Location**: `/home/tavis/src/othello/ergodis-private/src/lib.rs:92-98` (crate-internal copy, no panic guard); `tests/proof_synthesis_allocations.rs:69` (no panic guard); `tests/hadamard_2092_allocations.rs:44-59` and `tests/g41_pair_workspace_allocations.rs` (guarded copies).

**Code** (the guarded copy, `tests/hadamard_2092_allocations.rs:44-50`, absent from the other two):

```rust
struct TrackingGuard;

impl Drop for TrackingGuard {
    fn drop(&mut self) {
        TRACKING.with(|tracking| tracking.set(false));
    }
}
```

and the shared blind spot (`src/lib.rs:51-54`):

```rust
thread_local! {
    static TRACKING: Cell<bool> = const { Cell::new(false) };
    static ALLOCATIONS: Cell<usize> = const { Cell::new(0) };
}
```

**Mechanism**: The counting allocator behind every `*_allocate_nothing` assertion is duplicated four times and has drifted: two copies gained a `Drop` guard so a panicking measured closure cannot leave `TRACKING` armed for later tests on the same thread; `src/lib.rs` (used by all in-module allocation tests, e.g. `bitset_sumset.rs:65`, `g133_exact_q2_proof.rs:235`) and `tests/proof_synthesis_allocations.rs` did not. More important, all four count via `thread_local!` state: an allocation made on any thread other than the measuring one is invisible. The crate compiles the core with the `parallel` feature (`Cargo.toml:11`), so the moment a measured kernel adopts a rayon path, its allocations happen on worker threads and the zero-allocation gate passes vacuously.

**Trigger**: (a) a panic inside a measured closure in the unguarded copies poisons subsequent same-thread measurements; (b) parallelizing any measured hot path — an explicitly anticipated evolution under the crate's own performance discipline — makes the assertion meaningless without any test failure.

**Impact**: The "allocation-free" claims in module docs and test names are enforced by a harness that a routine future change silently defeats; the drift itself shows the copies are already not maintained together.

**Fix (described)**: One shared harness (a small `#[cfg(test)]`-gated internal module or a dev-dependency crate) with the panic guard, a process-global (atomic) counter variant for parallel kernels, and the thread-locality caveat documented at the single definition site.

## Not found / checked clean

- `hall_core.rs` (BFS Kuhn matching + Hall-deficit extraction): epoch handling, augmenting-path flip, and deficiency extraction all check out; the exhaustive 4×4 test (`hall_core.rs:311-374`) validates both saturation and exact deficiency counts against brute force.
- `two_adic_autocorrelation.rs`: the 2-adic lift lemma in the module doc is correct (`2^{2k}` term divisible by `2^{k+1}` for `k ≥ 1`); the quadratic-form basis+pairs vanishing criterion is sound for degree-≤2 forms with zero constant term; input validation fails closed; exhaustive small-carrier tests cross-check against direct computation.
- `proof_synthesis` Horn closure and replay: registry validation rejects duplicate rule identities and self-premising rules; replay checks slot, identity, premises, conclusion, and reserved byte; the 64-fact bound makes the fixed workspace sufficient. Bareiss elimination in `solve_unique_integer` fails loudly (never silently) on the non-exact-division edge cases.
- `g53_sparse_dual` residue arithmetic uses `rem_euclid` consistently (lines 338, 533, 539) — no signed-`%` drift found there or in the `g53_mod49_high_scout`/`g53_mod343_scout` signature builders.
- The thin `src/bin` wrappers of the `g133_sparse_*`/`g41_*`/`g53_*` families delegate cleanly to library modules; no copy-diverged logic found in the wrappers themselves.
- Hygiene note (below finding threshold): a 42MB Cargo build tree sits untracked at `ergodis-private/controls/query-design-c1011/target/`, contra the workspace rule that scratch crates in doc trees redirect their target dir; the new `.gitignore` entry covers only `ergodis-private/target/`. Also, `reduction_proof.rs:515`'s `u16` energy arithmetic is safe only because the three-square target is pinned to 18 by the equality check at line 525 — worth a comment, not a finding.
