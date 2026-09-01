# C1030 pass 2 — vetting the three sibling audits, shape sweep, root-cause generators

**Task**: C1030 · **Lane**: `complete-ports` · **Scope**: second pass — verify all sibling findings against the code, sweep both crates for repeat instances of the confirmed defect shapes, and name the common generators for the root-cause pass.

Verdict: 13 of the 15 sibling findings are confirmed against the code, most with their quoted lines verified byte-for-byte. One finding is refuted outright — the core-library SEV2 (`BinaryProjectiveIndex` `checked_shl` "fails open") quotes code that does not exist at HEAD or in any prior revision of `projective.rs`; the actual constructor shifts the literal 1 and errors correctly on the claimed trigger. Its buried secondary observation (the generic constructor is spuriously strict at the boundary) is real and re-filed below as a properly grounded finding. Two findings carry a one-notch severity correction under the task's scale (the core rank-vs-rows SEV1 and the search-engine additive-join SEV1 are both SEV2 by the letter of the scale: every present caller is provably safe or loudly hedged), and my own pass-1 `xor_sumset` SEV2 is corrected down to SEV4 on the strength of the search sibling's call-site audit. The shape sweep found no second live instance of the unchecked-arithmetic shape, but found the guard-in-caller shape at seven sites and established that the entire sealed-proof family shares one verification-by-re-execution trust model whose independence lives inside the shared computation, not between prover and verifier.

## Vetting of sibling findings

### Core library — SEV1, `Matrix::row_space_contains_field` uses row count as rank: CONFIRMED (severity one notch high)

Verified at `papers/complete-repair-ports/ergodis/src/matrix.rs:216` — `let rank = self.rows();` — and the comparison at `:221`. Both public variants are affected (`row_space_contains::<P>` at `:205-206` delegates to the same body). The wrong-in-both-directions analysis is correct: rank-deficient `self` plus an outside candidate yields a false `true`; a redundant-row `self` plus a contained candidate yields a false `false`. The internal call site `contextual.rs:1526` is safe because `:1523` canonicalizes first, as the report says.

The report missed a second live caller outside its crate scope: `ergodis-private/src/bin/c1028_chain_ring.rs:889-892` calls `basis.row_space_contains_field::<Gf4>(&candidate)` in a membership oracle — also safe, because `basis` is produced by `canonical_row_basis_with(&gf4)` at `:868-870` (full row rank guaranteed), and that binary is itself an instrument test measuring disagreements on purpose. So every reachable caller today canonicalizes first. Under the scale — SEV1 requires a silently wrong result that could feed a paper-facing claim — this is SEV2: silent, unsafe-direction, on a public untested predicate, but unreached from every existing call site. Keep it top-ranked among the core findings regardless; the fix is one line and the exposure is any future caller.

### Core library — SEV2, `BinaryProjectiveIndex::new` `checked_shl` fails open: OVERCLAIMED — refuted

The quoted code — an ascending loop doing `block.checked_shl(u32::from(H))` per iteration at "`projective.rs:152-158`" — does not exist. The actual code at `papers/complete-repair-ports/ergodis/src/projective.rs:153-164` (identical at HEAD, and no `checked_shl` existed in the file before the commit that introduced the binary constructor) is:

```rust
let highest_shift = u32::from(H) * u32::from(vector_dimension - 1);
let mut block = 1_u64
    .checked_shl(highest_shift)
    .ok_or(ProjectiveError::DimensionOverflow)?;
...
for _ in 0..vector_dimension {
    point_count = point_count
        .checked_add(block)
        .ok_or(ProjectiveError::DimensionOverflow)?;
    offsets.push(point_count);
    block >>= H;
```

Shifting the literal 1 is the one case where `checked_shl` is exact (the core report itself makes this point about `field.rs:220`): `1 << s` loses no bits for `s <= 63` and returns `None` for `s >= 64`, which is precisely the `H * (vector_dimension - 1) >= 64` overflow condition. The claimed trigger `BinaryProjectiveIndex::<8>::new(_, 8)` (PG(8,256)) gives `highest_shift = 64`, so the constructor returns `Err(DimensionOverflow)` — the correct behavior, not a silently broken indexer. The offsets/`partition_point` corruption scenario is unreachable. The descending `block >>= H` accumulation also never computes an extra block, so the binary constructor is exact at the boundary.

What survives is the report's own secondary observation: the **generic** constructor (`projective.rs:44-50`) computes one block beyond the last one it pushes, so it spuriously rejects the largest representable geometry. That is real and re-filed as a grounded finding under New findings below.

### Core library — SEV3, `GeneratedSpanTable::build` uncapped with abort-on-failure: CONFIRMED

Verified: no cap anywhere in the build loop (`span.rs:88-119`), each state stored twice (arena push at `:107` plus the `Box<[u8]>` hash key at `:110`), `.expect(...)` calls in `arena.rs:37-39`, and `panic = "abort"` at `papers/complete-repair-ports/ergodis/Cargo.toml:116`. The contrast with `scheduler.rs`/`multiset.rs`/`linear_code.rs` caps is accurate. Severity right.

### Core library — SEV4, `Matrix` carries no field tag: CONFIRMED

Struct and `new_field` behavior match the quotes; the reduced-entry check is indeed the only residual guard, and `Matrix` derives `Serialize`/`Deserialize` with no field context. Severity right.

### Core library — SEV4, `Prime<P>` public and unvalidated: CONFIRMED

Verified against `field.rs:50-93`: `validate()` is advisory, all arithmetic is `pub` inherent, `Prime::<9>::inverse(3)` computes `3^7 mod 9 = 0` and returns `Ok(0)`, `Prime::<0>::add` divides by zero. In-crate consumers validate first as claimed. Severity right.

### Search engines — SEV1, additive delta join wrong for same-block moves: CONFIRMED (severity one notch high)

The strongest sibling finding, and it checks out completely. Verified: the quotient PAF is quadratic in per-block counts (`g53_search.rs:726-748`); the incremental kernel's `cross` term reads the current counts (`:822-834`), so isolated deltas compose additively only across blocks; `repair_moves_compatible` (`:2081-2101`) returns `true` unconditionally for distinct blocks (correct — per-block forms are independent) and also for same-block moves with disjoint orbit sets (incorrect — disjoint support kills only the shift-0 cross term); `finish_q7_repair` restores the shell and returns `Ok(None)` on replay mismatch (`:1473-1479`); `finish_q4_repair` returns `Err(Hadamard2092Error::FixedField)` without restoring (`:2149-2153`) and both q4 match points return it directly (`:2299-2304`, `:2360-2368`), so the first same-block additive coincidence that fails replay aborts the whole q4 selection repair and discards any genuine repair later in the enumeration.

Severity: SEV2 by the letter of the scale, not SEV1. The q7 miss is hedged in the emitted artifact itself ("bounded four-move miss; no negative coverage authority", `g53_q7_repair.rs:53`), and the q4 failure is loud (`Err`), so no silently wrong result reaches a claim today. The report concedes this in its own impact paragraph. The gap between the "exact four-move repair" name and the actual "cross-block-additive combinations only" predicate is the live hazard, and the described fix is right.

### Search engines — SEV2, `scout_g41_q29_seed_power` rescores one preimage per state: CONFIRMED

Verified: `insert_with_value` keeps the first value per state and returns `Ok(false)` on collision (`g41_q29_evolve.rs:370-387`), the right-hand scan does `break 'right` on the first match (`:2321-2335`), and `exact_residual`/`full_paf_hit` are computed from that single arbitrary fibre member (`:2353-2356`). Severity right.

### Search engines — SEV3, mod-16 dense pair keys memory/wall: CONFIRMED

Verified: the 8,200-byte `Mod16DenseKey` const assert (`g133_sparse_defect.rs:224-226`), the 255-signature `u8` wall (`:1499-1501`, minor line drift from the cited `:1477-1480`), and the per-class retention of dense vectors. Severity right.

### Search engines — SEV4, `xor_sumset_256_into` empty-operand saturation: CONFIRMED — and it corrects my pass-1 severity

Cross-confirmed three ways now. The search sibling's call-site audit (all four callers pass nonempty operands by construction) is more thorough than my pass-1 reachability estimate; my pass-1 SEV2 is hereby corrected to their SEV4. The agreement signal was acted on: I swept for the same saturation-shortcut idiom elsewhere (`cyclic_sumset`, `projected_sumset` in `g53_sparse_dual.rs:308-331`, `:345-376` use `output == full` early exits only — the exit tests the output, not an operand, so they do not share the bug).

### Search engines — SEV4, `lift_bits` width not recorded in `EnergyDomain`: CONFIRMED

Verified: `EnergyDomain` (`g133_sparse_defect.rs:255-265`) stores `lift_hash` but no `lift_bits`; width-divergent unpackers at `:1213` (`as u8`) and `:1358` (`as u16`), plus two more `state as u8` unpackers at `:3779` and `:3808` the report did not list. Severity right.

### Certificates — SEV1, `certdist verify` passes with witnesses unchecked: CONFIRMED

Verified all three layers: `--input` optional (`certdist.rs:1470-1478`), the `None` arm prints `[--]` and pushes nothing into `failures` (`:2028-2032`), the verdict is the identical "certificate verified" string (`:2260-2262`); the verify side recomputes the bracket by calling the same `build_bracket` the prover used (`:1299` vs `:2144`); `build_bracket`'s exact promotion (`:1170-1178`) sets `exact_from_search` from `minimum_witness_weight` with no `weight <= searched_maximum_weight` check; the toolchain mismatch is a `println!` inside `if let (Some, Some)` (`:2176-2180`). One addition: the whole audited verify path is committed at HEAD — the +111/−35 uncommitted working-tree diff on `certdist.rs` is OSD-trial and command-parsing work, unrelated — so this finding attaches to the committed tool. Severity right: this is the archetype of "a forged certificate passes the advertised verifier".

### Certificates — SEV1, `certiis` defaults + shared deserializer: CONFIRMED

Verified: `#[serde(default = "one")]` on `Task::demand` and `Resource::capacity` (`certiis.rs:39`, `:53`), `#[serde(default)]` on `Instance::couplings` (`:107-108`) so a misspelled container key silently yields no couplings and a regime misclassification, no `deny_unknown_fields` anywhere in the file (vs `hall_certify.rs:19`), and verify re-reading through the same deserializer with the digest taken over the raw bytes. Severity right.

### Certificates — SEV2, `certiis` timings in certificate + overwrite-in-place: CONFIRMED

Verified: `matching_micros`/`minimization_micros`/`total_micros` in `Report` (`certiis.rs:508-510`, populated at `:718-736`), and `write_json`'s unconditional `fs::write` with swallowed `create_dir_all` error (`:1699-1706`). Severity right.

### Certificates — SEV2, `solve_sorted_square_sum` unchecked u32: CONFIRMED (triple-confirmed)

Same finding as my pass-1 SEV2 and verified again; the certificate sibling adds the correct observation that prover and verifier share the defective kernel (`reduction_proof.rs:342` and `:511` both bottom out in `generic_three_square_solutions` → `solve_sorted_square_sum`), which files it under the shared-path shape as well. Their SEV2 and my SEV2 agree; their trigger arithmetic (`target > 2^32/8`) matches mine.

### Certificates — SEV3, q23 Hall evidence unhashed/unbound: CONFIRMED

Verified: `evidence/SHA256SUMS` has 13 rows, none matching `q23`; 7 q23 files exist among 44 files in `evidence/`. The graph-to-certificate binding gap follows from the verifier's independent-path CLI design. Severity right.

## Shape sweep

### Shape: unchecked narrow arithmetic in release where a checked sibling exists — no second live instance

Swept both crates for non-test `sum::<u32>`/`sum::<i32>`/narrow `.pow(2)` accumulations. Every candidate is structurally bounded today: `g41_defect_scout.rs:815-821` (popcount sum, ≤ a few hundred), `hadamard_2092.rs:1758-1764` (i32 autocorrelation over 29 bounded counts), `g53_mod343_scout.rs:194`, `g53_q0_diverse.rs:263`, `g53_search.rs:736-740` (u16×u16 multiplied *before* `i32::from`, safe only because per-residue counts are capped at 29 by the carrier layout), and `reduction_proof.rs:515` (u16 energy map, bounded because the three-square target is pinned to 18 — but the pinning equality check at `:525` runs *after* the map, a guard-after-use ordering that works only by accident of the current constants). Core-crate sums are all `usize`/`u64`. Conclusion: `solve_sorted_square_sum` remains the only live instance, but the idiom "widen after multiply, bound by structure, assert nothing" appears in at least three hot kernels and is one constant-tweak away from a repeat.

### Shape: the guard lives in one caller, not in the kernel — 7 instances

1. `projected_sumset`/`encode_projection`/`cyclic_sumset` 64-state cap guarded only at `g53_sparse_dual.rs:394` (pass-1 finding).
2. `xor_sumset_256_into` nonempty precondition guarded independently at each of four call sites (confirmed sibling finding).
3. `add_states_power` word-width requirement `bits <= 4` guarded at `g41_q29_evolve.rs:2285` in one entry point; other call sites pass literals.
4. `0_u16..1_u16 << len` shift-masking hazard at `g41_q29_evolve.rs:1290`/`:1437`, pinned by an assertion in a different function (`:498`).
5. `BinarySmallField::inverse_nonzero` returns the zero slot for zero input; non-zeroness established by its caller `projective.rs:203`.
6. Lift-signature decode width tied to `lift_bits` by caller convention only (confirmed sibling finding).
7. `Matrix` field identity maintained by caller discipline; the type carries no tag (confirmed sibling finding).

A good counterexample worth copying: the 13-bit `q1`/`q2` packing in `g133_sparse_defect.rs` is guarded *adjacent to the packing itself* (`:763-766`, `:785-787` reject `>= Q1_LIMIT` before the shift-or) — the one packing site in the family where the boundary check travels with the representation.

### Shape: prover and verifier share the computation — systemic across the sealed-proof family

Beyond the two certificate instances (certdist `build_bracket` at `:1299`/`:2144`; certiis's shared `Instance` deserializer) and the shared `solve_sorted_square_sum` bottom of `reduction_proof`, the entire private sealed-proof family has this trust model: `verify_g53_sparse_q4_proof` (`g53_sparse_q4_proof.rs:152`) re-runs the same `census_g53_q4_fibres()` + `verify_g53_sparse_q4_census()` the synthesizer ran (`:105`); `verify_g133_exact_q2_proof` re-runs the same `scout_g133_sparse_exact_q2()` (`g133_exact_q2_proof.rs:146` vs `:116`); `verify_quotient_paf_proof` recomputes `required_targets` — the same function the synthesizer called (`quotient_paf_proof.rs:149` vs `:175`); the same pattern holds across `g41_quotient_filter_proof`, `g53_reduction_proof`, `subgroup_energy_proof`, and `g53_defect_profile_proof`. The Horn transcript that gets independently replayed encodes only the *rule ordering*, not the computation; the claimed dual-kernel independence lives inside the shared function, so any defect upstream of the kernel split (domain compiler, class quotient, target derivation) passes prover and verifier identically. This is a deliberate design ("verification rebuilds…"), not a bug per se — but it means the family's "verified" is strictly weaker than the word suggests, and the genuinely independent layer is the python checkers (`verify_hall_certificate.py`, `c1029_check.py`, `check_hadamard_quotient_pilot.py` — all recompute from scratch, verified).

### Shape: deserialization defaulting to a passing value — 2 dangerous, several benign

Dangerous sub-shape (missing/misspelled key silently becomes a load-bearing value): `certiis` `demand`/`capacity` = 1 and `couplings` = `[]` (confirmed sibling SEV1), and `papers/complete-repair-ports/ergodis/src/control/mod.rs:662` — `args.get("count").and_then(Value::as_bool).unwrap_or(true)`, where an absent control-plane parameter selects the permissive branch. Benign sub-shape (default to *absent* semantics): core `rpc.rs:38`/`:41`/`:117` (`id: Option`, `params: Value::Null`, `linear_twist: Option`) and certdist's `incumbent_support`/`Toolchain` options (`certdist.rs:157-159`, `:321`, `:326`, `:795`, `:826`) — though the Toolchain one participates in the confirmed certdist SEV1 because its absence silently skips a check. The discriminator for the root-cause pass: a default is safe when it means "not present", unsafe when it means "a number the math then uses".

### Shape: implicit width/capacity limits with no assertion at the boundary — 4 live instances

1. 64-residue-state cap in `projected_sumset`/`cyclic_sumset` (pass-1; silent wrap in release beyond it).
2. `Mod16SparsePairKey::len: u8` under a structure that can hold 65,536 signatures (confirmed sibling SEV3; errs loudly).
3. `WitnessArena` id colliding with its own `ROOT` sentinel at `u32::MAX` nodes (core sibling's minor note; unreachable today).
4. `RuleApplication::registry_slot: u16` with no registry-size check — currently unreachable (registries are compile-time arrays of ≤ 5 rules).

### Shape: rank/dimension assumed rather than computed — 1 instance

The `Matrix::row_space_contains_field` rank-vs-rows confusion is the only live instance found. Everything adjacent computes rank properly: `null_space*` use the canonicalized basis's row count, `c1028_chain_ring` derives `4^rank` from a canonicalized basis, `span.rs` tracks rank through elimination.

### Shape: copy-and-diverge siblings where one copy carries the fix — 6 instances

1. Generic vs binary projective constructors: boundary semantics differ in both directions (generic spuriously strict — see New findings; binary exact).
2. `solve_sorted_square_sum` (unchecked) vs `solve_bounded_linear_combination` (checked) in the same file.
3. Counting-allocator harness ×4 copies, panic-safety guard present in 2 (`tests/hadamard_2092_allocations.rs`, `tests/g41_pair_workspace_allocations.rs`), absent in 2 (`src/lib.rs:92-98`, `tests/proof_synthesis_allocations.rs:69`) (pass-1 finding).
4. `certiis::write_json` unconditional overwrite vs `hall_certify`'s `create_new(true)` in the same directory.
5. `SmallField::table_index` real `assert!` vs `BinarySmallField::mul` `debug_assert!` for the same misuse.
6. Twelve hand-wired hyphenated `[[bin]]` names vs ~85 auto-discovered underscored ones (certificate sibling's note).

## New findings

### SEV4 — Generic `ProjectiveIndex::new` spuriously rejects the largest representable geometry

**Location**: `papers/complete-repair-ports/ergodis/src/projective.rs:44-50`.

```rust
let mut block = 1u64;
let mut blocks = Vec::with_capacity(usize::from(vector_dimension));
for _ in 0..vector_dimension {
    blocks.push(block);
    block = block
        .checked_mul(u64::from(field.order()))
        .ok_or(ProjectiveError::DimensionOverflow)?;
}
```

**Mechanism**: the loop multiplies once more after the final push, so the constructor demands that `order^vector_dimension` be representable even though only `order^(vector_dimension-1)` is ever used. Whenever the discarded product overflows but the true point count `(q^(d+1)-1)/(q-1)` fits in `u64`, the constructor errors on a computable geometry. This is the real content behind the core sibling's refuted SEV2, restated against code that actually exists.

**Trigger**: `ProjectiveIndex::new(&SmallField::new(2, 8)?, 7)` — PG(7,256). The eighth push is `256^7`; the loop then computes `256^8 = 2^64`, overflows, and returns `Err(DimensionOverflow)`, though the point count ≈ 7.2×10^16 fits comfortably. `BinaryProjectiveIndex::<8>::new(_, 7)` accepts the same geometry (its `highest_shift = 56`), so the two constructors documented as agreeing diverge at the boundary — the copy-and-diverge shape, with the binary copy carrying the fix.

**Impact**: loud, fails closed — a denial of service on the largest campaign sizes, not a wrong answer, and a divergence trap for any code that falls back from one constructor to the other. The crate's agreement test only exercises projective dimension 4, so nothing catches it.

**Described fix (not applied)**: restructure the loop to check before multiplying (multiply only when another block is needed), mirroring the binary constructor's descending computation; extend `binary_index_agrees` to a near-boundary dimension so the constructors' agreement is tested where it can break.

### SEV5 — `Hadamard2092Error::FixedField` is an overloaded catch-all that hides which invariant failed

**Location**: `ergodis-private/src/g53_search.rs` (54 occurrences), e.g. `:2111-2113` (candidate budget exhausted), `:1700` (i16 conversion failure), `:2149-2153` (replay mismatch in `finish_q4_repair`), `:2156-2159` (block-weight invariant).

```rust
if candidates.len() == Q4_REPAIR_MOVE_BUDGET {
    return Err(Hadamard2092Error::FixedField);
}
```

**Mechanism**: budget exhaustion, arithmetic-width failure, replay disagreement, and weight-invariant violation all surface as the same `FixedField` variant, whose name describes none of them; the q7 path even uses a different variant (`StateBudget`, `:1746`) for the same budget-exhaustion condition the q4 path reports as `FixedField`. The cost is concrete: the confirmed q4 search defect aborts with an error that reads as a fixed-field problem, which is part of why an additive-join completeness bug could sit unnoticed in a module this carefully built.

**Trigger**: any of the four conditions above; the caller cannot distinguish them without a debugger.

**Impact**: maintainability and diagnosis only — but it directly compounds the severity of real defects, as the q4 case shows.

**Described fix (not applied)**: add variants (or a payload) distinguishing budget exhaustion, conversion overflow, replay mismatch, and invariant violation; align the q4/q7 budget errors on one variant.

## Root-cause generators (for the cross-report analysis)

1. **Kernel-trusts-caller as a performance convention.** The zero-allocation/fixed-record discipline pushes validation out of hot kernels; the guard lands at whichever call site existed first and does not travel to new callers. Generates: the xor_sumset precondition, the 64-state sumset cap, `add_states_power`, the shift-masking hazard, `inverse_nonzero`, the lift-bits width, and the Matrix field tag. The `Q1_LIMIT` packing guard shows the cheap alternative: keep the boundary check adjacent to the representation.
2. **Verification-by-re-execution.** Across certdist, certiis, and all seven sealed-proof modules, "verify" means "re-run the prover's computation and compare, plus replay a transcript that encodes only rule ordering". Independence exists only where a deliberately separate kernel (the dual-kernel splits inside the scouts) or a from-scratch python checker exists. Generates: both certificate SEV1s and the shared-square-sum exposure; explains why prover-side bugs cannot be caught by the Rust verify layer.
3. **Copy-and-diverge without a shared home.** Small utilities are re-implemented per site (allocator harness ×4, JSON writers, constructor pairs, endpoint enumerators, assert conventions), and fixes land in one copy. Generates: six sweep instances including the one refuted-finding residue.
4. **Release/debug asymmetry unmanaged.** `panic = "abort"`, `debug_assert!`, `.expect` in arenas, and overflow-checks off mean every debug-build guarantee vanishes in exactly the builds the campaigns run; structural bounds (counts ≤ 29, targets ≤ 255) are load-bearing but asserted nowhere. Generates: the square-sum wrap, the span abort, the widen-after-multiply idiom's fragility.
5. **Untracked-source drift undermines auditability itself** (pass-1 finding 1). All five reports cite `path:line` into `ergodis-private` files whose blobs are not in git; none of those citations can be pinned to a commit. The refuted core finding shows the failure mode concretely — a report quoted code that no revision contains, and only a re-read against the working tree caught it. Committing the tree is what makes any of these audits durable evidence.

## Not found / checked clean

- The q7 pair index is sorted before its `partition_point` windows (`g53_search.rs:1707`), so the additive-join defect is one of modeling, not of search-structure bookkeeping.
- The saturation-shortcut idiom does not recur: `cyclic_sumset`/`projected_sumset` early-exit on the *output* being full, which is sound.
- Core `rpc.rs` serde defaults are absent-semantics (`Option`/`Null`), not load-bearing values.
- The unchecked-sum sweep found no second live instance in either crate (all other narrow accumulations are structurally bounded today; see the shape section for the watch-list).
- The audited `certdist` verify path is committed at HEAD; the uncommitted `certdist.rs` working-tree diff is OSD-trial work and does not touch the finding.
- `landed_rank_adapter`'s GF(9) arithmetic (base-3 digit pair, `x^2 = 2` reduction in `mul`) is internally consistent, and the module genuinely is an independent implementation — the good version of the verifier pattern.
- `check_hadamard_quotient_pilot.py` recomputes profiles and the profile digest from scratch rather than trusting the JSON's self-report.
- `Q7DeltaIndex`/`Q4` candidate delta measurement uses the apply-twice toggle with an equality check that the workspace returned to base (`g53_search.rs:2114-2119`), which is self-verifying.
