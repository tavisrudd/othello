# C1030 audit — ergodis-private large search and enumeration engines

**Task**: C1030 · **Lane**: `complete-ports` · **Scope**: ergodis-private search/enumeration engines

## Verdict

The exhaustiveness machinery in the two defect scouts (`g133_sparse_defect.rs`,
`g41_defect_scout.rs`) held up under close reading: the depth-first row/energy pruning is
conservative in the safe direction, the hash-keyed class quotients fail closed on a hash
collision rather than merging inequivalent domains, and the `(energy, q1)` pair joins are exact
rather than over-approximate. The serious defect is elsewhere: the g53 multi-move quotient repair
searches (`g53_search.rs`) index candidate moves by a *first-order* residual delta and then join
those deltas additively, but the quantity being repaired is a quadratic autocorrelation whose
delta is not additive across two moves acting on the same block. The module's own incremental
kernel `flip_quotient_orbit` computes exactly the cross term that the join throws away. The result
is a search that is complete only over cross-block combinations, and that in the q4 variant
*aborts with an error* the first time the additive prediction disagrees with the replay.

Audited deeply: `g53_search.rs` (quotient PAF kernel, all three repair/switch searches, the
workspace move application path), `g133_sparse_defect.rs` (domain compiler, all class quotients
and pair joins, mod-8 and mod-16 scouts, the q0/q1 census), `bitset_sumset.rs`,
`two_adic_autocorrelation.rs` (both in full).

Audited at moderate depth: `g41_q29_evolve.rs` (2-adic fibre evolution, mod-2^k state arithmetic,
meet-in-the-middle seed scouts), `g41_defect_scout.rs` (domain compiler, q1 class quotient, q0/q1
census), `hadamard_2092.rs` (subset-sum invariant compilers, order-nine profile join).

Skimmed only: `q25_pair_repair.rs` (row index arithmetic, generate/verify kernels and the parallel
reduction verified; the certificate reader/writer and stabilizer-pattern synthesis not audited).

Not opened: `g41_joint_quotient_search.rs` (function inventory only, no line-level audit).

## SEV1 — Additive delta join in the g53 multi-move repairs is wrong for same-block moves

**Location**: `/home/tavis/src/othello/ergodis-private/src/g53_search.rs:1694-1841` (q7 four-move),
`/home/tavis/src/othello/ergodis-private/src/g53_search.rs:2305-2380` (q4 three-move),
predicate at `/home/tavis/src/othello/ergodis-private/src/g53_search.rs:2081-2102`,
ground truth kernel at `/home/tavis/src/othello/ergodis-private/src/g53_search.rs:815-848`.

Each candidate move's `delta` is measured in isolation against the base state
(`g53_search.rs:1502-1511`):

```rust
    workspace.apply_search_move(movement, 0, 0, target_prefix, 0, 1, objective);
    let after = workspace.active_quotient_residuals(target_prefix);
    workspace.apply_search_move(movement, 0, 0, target_prefix, 0, 1, objective);
    ...
    candidates.push(Q7RepairCandidate {
        movement,
        delta: std::array::from_fn(|shift| after[shift] - residual[shift]),
    });
```

Combinations are then found by requiring the *sum* of isolated deltas to equal the target
(`g53_search.rs:1749-1754`, and the analogous lookups at 1721-1723, 1775-1777, 1809-1811):

```rust
            let mut delta = [0_i16; 7];
            for shift in 0..7 {
                delta[shift] =
                    i16::try_from(candidates[first].delta[shift] + candidates[second].delta[shift])
                        .map_err(|_| Hadamard2092Error::FixedField)?;
            }
```

**Mechanism.** The repaired quantity is the quotient periodic autocorrelation
`q_s = sum_b sum_r c[b][r] * c[b][(r+s) mod 18]` (`g53_search.rs:726-743`), which is quadratic in
the per-block residue count vector. For two count perturbations `e` and `f` applied to the *same*
block,

```
q_s(c + e + f) - q_s(c) = [delta_e]_s + [delta_f]_s + sum_r (e_r f_{r+s} + f_r e_{r+s}),
```

and the trailing cross term is exactly what the module's own incremental kernel computes as
`cross` (`g53_search.rs:822-834`):

```rust
                cross += value
                    * i32::from(
                        self.quotient_counts[block][forward]
                            + self.quotient_counts[block][backward],
                    );
```

`cross` reads the *current* counts, so it changes once the first move has been committed. The
additive join therefore models the composition correctly only when the cross term vanishes.
`repair_moves_compatible` admits precisely the wrong set: it returns `true` unconditionally for
moves on different blocks — the case where the cross term genuinely is zero, since `q_s` is a sum
of independent per-block forms — and *also* returns `true` for same-block moves whose orbit sets
are disjoint (`g53_search.rs:2088-2101`), which does not make the cross term zero. Disjoint
residue support kills only the `s = 0` term; for `s >= 1` the shifted overlap is generically
nonzero on an 18-residue quotient whose orbits each occupy several residues.

**Concrete trigger.** `cargo run --bin g53_q7_repair -- --seed <hex> --exact-input-prefix 4
--target-prefix 7` on any shell whose true minimal repair is two same-block single-orbit swaps
`m1 = (remove a, add b)`, `m2 = (remove c, add d)` with `{a,b}` disjoint from `{c,d}` and with the
quotient-residue difference vectors `e = chi_b - chi_a`, `f = chi_d - chi_c` not shift-orthogonal.
Such a pair satisfies `residual + delta(m1 then m2) = 0` but has
`delta(m1) + delta(m2) != -residual`, so the `partition_point` window at
`g53_search.rs:1721-1722` never contains it and the pair is never even handed to
`finish_q7_repair`.

**Impact.** Two different failure modes, and the q4 one is the worse of the two.

In the q7 search, `finish_q7_repair` re-verifies by full recompute and returns `Ok(None)` on
disagreement (`g53_search.rs:1471-1479`), so spurious additive matches are filtered and the search
continues. The consequence is one-sided: `repair_g53_quotient_prefix_with_four_moves` returning
`Ok(None)` means "no combination whose isolated deltas sum to the target", not "no four-move
repair". The doc comment says "Exact four-move q7 repair scout" and the emitted report for a miss
says `"bounded four-move miss; no negative coverage authority"`
(`/home/tavis/src/othello/ergodis-private/src/bin/g53_q7_repair.rs:53`), so nothing paper-facing
currently rests on the negative — but the gap between the name and the actual predicate is
invisible at the call site, and the disclaimer is the only thing preventing this from becoming a
false exhaustiveness claim.

In the q4 search the same additive matches are returned directly rather than skipped
(`g53_search.rs:2313-2320` and `2376-2380` both `return finish_q4_repair(...).map(Some)`), and
`finish_q4_repair` treats a verification failure as a hard error without restoring the workspace
(`g53_search.rs:2149-2153`):

```rust
    workspace.recompute_quotient_paf();
    let full_quotient_residuals = workspace.active_quotient_residuals(QUOTIENT_SHIFTS);
    if full_quotient_residuals[..4] != [0; 4] {
        return Err(Hadamard2092Error::FixedField);
    }
```

So the *first* same-block additive coincidence that is not a real repair aborts
`repair_g53_q4_selection` with `Hadamard2092Error::FixedField`, discarding any genuine repair
later in the enumeration and reporting a fixed-field error that has nothing to do with fixed
fields.

**Described fix (not applied).** Two independent changes. First, restrict the additive index to
the case where it is exact: have `repair_moves_compatible` return `true` only for moves on
distinct blocks, and enumerate same-block combinations by actually applying the first move and
re-measuring the second move's delta against the updated state (a one-level rebuild of the
candidate deltas per committed first move). Second, in `repair_g53_q4_selection`, make
`finish_q4_repair` behave like `finish_q7_repair`: restore the shell and return `Ok(None)` on a
replay mismatch so the search continues, reserving `Err` for genuine invariant violations. Until
the first change lands, the doc comments and both binaries' miss provenance should say
"no cross-block-additive combination found" rather than "four-move miss".

## SEV2 — `scout_g41_q29_seed_power` rescores one arbitrary preimage per modular state

**Location**: `/home/tavis/src/othello/ergodis-private/src/g41_q29_evolve.rs:2302-2334`, with the
retention policy at `/home/tavis/src/othello/ergodis-private/src/g41_q29_evolve.rs:370-388`.

```rust
    for (first_index, first) in profiles[0].iter().enumerate() {
        for (second_index, second) in profiles[1].iter().enumerate() {
            let state = add_states_power(first.state, second.state, bits);
            let packed = first_index as u64 | ((second_index as u64) << 32);
            workspace
                .insert_with_value(state, packed)
```

and

```rust
    'right: for (third_index, third) in profiles[2].iter().enumerate() {
        for (fourth_index, fourth) in profiles[3].iter().enumerate() {
            let state = add_states_power(third.state, fourth.state, bits);
            if let Some(packed) = workspace.get(complement_state_power(state, bits)) {
                matched = Some((...));
                break 'right;
            }
```

**Mechanism.** `insert_with_value` keeps the first `(first_index, second_index)` inserted for a
given mod-`2^bits` state and returns `Ok(false)` for every later collision
(`g41_q29_evolve.rs:373-375`), and the right-hand scan stops at the first match. Many distinct
block-pair selections share a modular state — that is the entire point of the compression — so the
recovered `selection` is one arbitrary member of a potentially large fibre. Everything downstream
is computed from that single member: `exact_residual = q29_residual(&correlation)` and
`full_paf_hit` (`g41_q29_evolve.rs:2353-2356`).

**Concrete trigger.** Any root for which `scout_g41_q29_seed_mod8` (`bits = 3`, so states live in
`8^8` but the four block profile lists are much larger) reports `mod8_feasible: true`. The
reported `exact_residual` is then the residual of whichever `(first, second)` happened to be
inserted first under the open-addressed probe order, not a minimum over the fibre.

**Impact.** `full_paf_hit: false` in the `ergodis-private` mod-8 and mod-16 seed reports does not
mean "this root has no exact hit among the modularly feasible selections"; it means "one sampled
member of one fibre missed". The same applies to `exact_residual`, which reads like a per-root
quantity. The emitted provenance strings hedge the *infeasible* direction only
(`g41_q29_evolve.rs:2378`, `2391`: "modular infeasibility is root-local only, while hits are
directly rescored") — the clause "hits are directly rescored" is the misleading part, since
exactly one hit per root is rescored. The retention is deterministic (open addressing, no
`HashMap`), so runs are reproducible; the defect is coverage, not nondeterminism.

**Described fix (not applied).** Store a bucket of preimages per modular state rather than one,
or make the right-hand scan continue past the first match and rescore every collision, reporting
the minimum `exact_residual` and an `any_full_paf_hit` flag plus the number of preimages examined.
Failing that, rename the fields to `sampled_exact_residual` / `sampled_full_paf_hit` and say in
the provenance that exactly one preimage per feasible modular state is rescored.

## SEV3 — Mod-16 dense pair keys are 8,200 bytes each, held per class, with a 255-signature wall

**Location**: `/home/tavis/src/othello/ergodis-private/src/g133_sparse_defect.rs:226`,
`:1313-1342`, `:1344-1416`, `:1477-1480`, `:2811-2818`.

```rust
    std::mem::size_of::<Mod16DenseKey>() == 8_200 && std::mem::align_of::<Mod16DenseKey>() == 8
```

```rust
fn mod16_dense_block_keys(domain: &EnergyDomain) -> Result<Vec<Mod16DenseKey>, G133SparseError> {
    ...
    let mut output = Vec::<Mod16DenseKey>::with_capacity(MAX_Q1_PROFILES_PER_DOMAIN);
```

```rust
    let mut special_dense = Vec::with_capacity(special_classes);
    for domain in &special_representatives {
        special_dense.push(mod16_dense_block_keys(domain)?);
    }
    let mut zero_dense = Vec::with_capacity(zero_classes);
    for domain in &zero_representatives {
        zero_dense.push(mod16_dense_block_keys(domain)?);
    }
```

**Mechanism.** `Mod16DenseKey` carries `fibres: [[u64; 4]; 256]`, a fully materialised 256x256 bit
matrix, one per distinct `(energy, q1)` key. `MAX_Q1_PROFILES_PER_DOMAIN` and `MAX_PAIR_PROFILES`
are both 4,096, so a single fully populated dense block or pair vector is
`4096 * 8200 = 33.6 MB`, and every pushed key writes its 8,200 zero bytes whether or not the
matrix is sparse. `special_dense` and `zero_dense` hold one such vector per lift class *for the
whole remainder of the scout*, so resident memory is
`(special_classes + zero_classes) * keys_per_class * 8.2 KB`. With ten classes per side and a few
hundred keys each that is already several gigabytes; the only guard,
`total_pair_keys > 4_000_000 || total_pair_signatures > 100_000_000`
(`g133_sparse_defect.rs:2880-2882`), is evaluated *after* every pair domain has been compiled and
compressed, so it cannot prevent the peak it is meant to bound.

Separately, `compress_mod16_dense_pairs` hard-fails on any single pair key carrying more than 255
distinct mod-16 signatures (`g133_sparse_defect.rs:1477-1480`):

```rust
        let len = signatures.len() - offset as usize;
        if len > usize::from(u8::MAX) {
            return Err(G133SparseError::StateBudget);
        }
```

A dense key can hold up to `256 * 256 = 65,536` signatures, so the `u8` width of
`Mod16SparsePairKey::len` is a factor-256 wall well inside the representable range of the
structure that feeds it.

**Concrete trigger.** `scout_g133_sparse_joint_mod16` at the current parameters (`CARRIER = 522`,
`SLOTS = 10`, `DEFECT_TARGET = 83`, `q1` target 15,080). The failure is not hypothetical for the
next size up: raising `SLOTS` or relaxing `DEFECT_TARGET` increases both the number of `(energy,
q1)` keys per class and the number of signatures per key, and the second hits the 255 wall first,
aborting the entire census with `StateBudget` rather than degrading.

**Impact.** No incorrect result — this is a resource and headroom finding. It caps
`scout_g133_sparse_joint_mod16` at roughly today's parameters and makes the failure mode an
all-or-nothing abort with no partial output and no checkpoint, after having already done all the
dense pair work.

**Described fix (not applied).** Build the pair fibres sparsely — accumulate `(low, high)`
signature pairs into a per-key `Vec<u16>` and sort/dedup at the end — instead of materialising a
`[[u64; 4]; 256]` per key; the compression step at `:1447-1493` already produces exactly that
representation, so the dense intermediate is pure overhead. Widen
`Mod16SparsePairKey::len` to `u16` (or make the key store `offset..next_offset` and drop `len`).
Move the `total_pair_keys` / `total_pair_signatures` budget check inside the two class loops so it
trips before the peak rather than after.

## SEV4 — `xor_sumset_256_into` returns a full set when one operand is full and the other empty

**Location**: `/home/tavis/src/othello/ergodis-private/src/bitset_sumset.rs:6-13`.

```rust
pub fn xor_sumset_256_into(output: &mut [u64; 4], left: &[u64; 4], right: &[u64; 4], offset: u8) {
    if output.iter().all(|&word| word == u64::MAX) {
        return;
    }
    if left.iter().all(|&word| word == u64::MAX) || right.iter().all(|&word| word == u64::MAX) {
        output.fill(u64::MAX);
        return;
    }
```

**Mechanism.** The saturation shortcut is justified by "if one side is all 256 values then the
XOR sumset is all 256 values", which holds only when the other side is nonempty. `A xor B` with
`B` empty is empty, but the shortcut writes `u64::MAX` into `output`, claiming every signature is
reachable. Since `output` is an OR-accumulator feeding reachability tests
(`bitset_256_contains` at `g133_sparse_defect.rs:2213`,
`mod16_pair_domains_compatible`), a spurious full set turns an exclusion into a survivor —
it fails in the unsafe direction for any negative claim.

**Concrete trigger.** None today; this is why it is SEV4 and not SEV1. All four call sites pass
operands that are nonempty by construction. `compile_mod16_dense_pair_keys` explicitly skips empty
fibres before calling (`g133_sparse_defect.rs:1390-1397`); `compile_lift_pair_profiles`
(`:1258`) and `compile_block_two_adic_fibres` (`g41_q29_evolve.rs:1331`) pass profiles that
always received at least one bit at construction (`g133_sparse_defect.rs:1207`,
`LiftFibre::singleton`); the 4-block join at `g133_sparse_defect.rs:2163` passes stored profile
signature sets, likewise nonempty. The precondition is undocumented, so the next caller that
accumulates into a set that may legitimately be empty gets a silent wrong answer in the
exclusion-unsafe direction.

**Described fix (not applied).** Add an early `if left.iter().all(|&w| w == 0) || right.iter().all(|&w| w == 0) { return; }`
before the saturation branch (which is also a free fast path), or document the nonempty
precondition and add a `debug_assert!` for it. Extend the existing test
`xor_sumset_matches_independent_pair_loop` with an empty-right, full-left case.

## SEV4 — `LiftProfile.state` signature width is implicit in `lift_bits`, which the domain does not record

**Location**: `/home/tavis/src/othello/ergodis-private/src/g133_sparse_defect.rs:772-786`,
`:1191`, `:1336`, struct at `:255-265`.

Packing (`:776-785`):

```rust
                    let signature = if lift_bits == 1 {
                        u16::from(theorem_mod8_lift_signature(&base, packed)?)
                    } else {
                        theorem_mod16_lift_signature(&base, packed)?
                    };
                    lift_profiles.push(LiftProfile {
                        state: ((energy as u64) << 29) | ((q1 as u64) << 16) | u64::from(signature),
```

Two unpackers with different, unchecked widths — `lift_key_profiles` (`:1191`):

```rust
        let signature = profile.state as u8;
```

and `mod16_dense_block_keys` (`:1336`):

```rust
        let signature = profile.state as u16;
```

**Mechanism.** `EnergyDomain` stores `lift_profiles` and `lift_hash` but not the `lift_bits` the
domain was compiled with, so nothing ties an unpacker to its matching compiler setting. The
pairing is currently correct by convention only: `scout_g133_sparse_joint_mod8` compiles with
`lift_bits = 1` (`:2061`) and calls `lift_key_profiles`; `census_g133_sparse_mod16_classes` and
`scout_g133_sparse_joint_mod16` compile with `lift_bits = 2` (`:2266`) and call
`mod16_dense_block_keys`.

**Concrete trigger.** Cross-wiring the two — passing a `lift_bits = 2` domain to
`lift_key_profiles` — is a one-line mistake that compiles, runs, and produces plausible output:
`state as u8` extracts the low bit of each of the eight mod-4 digits, which is exactly
`split_mod16_lift_signature`'s `low` component. The resulting analysis would then combine those
low bits with `xor_sumset_256_into` (XOR, correct for mod-8 one-bit lifts) instead of the
carry-propagating `add`/`carry` path that `compile_mod16_dense_pair_keys` uses for mod-16
(`:1398-1405`). The reachable set would be computed under the wrong group law, silently, with no
error and no assertion. Because the errors go in both directions the resulting exclusions would
not be trustworthy.

**Described fix (not applied).** Store `lift_bits: u8` in `EnergyDomain` alongside `lift_hash`,
and have `lift_key_profiles` and `mod16_dense_block_keys` each return
`Err(G133SparseError::SemanticMismatch)` when it does not match the width they decode. Cheap,
local, and turns a silent miswiring into a fail-closed error consistent with the rest of the
module.

## Not found / checked clean

Pruning rules and invariants specifically verified as sound:

- **`compile_energy_domain` row bound** (`g133_sparse_defect.rs:821-823`). The prune
  `next_row + remaining * 29 < row_target` uses the loosest possible per-residue maximum
  (`bit + 4*7 <= 29`), so it over-estimates the reachable remainder and can only keep branches a
  tight bound would cut. The `g41_defect_scout.rs:463-468` analogue computes the exact
  mask-dependent maximum and is likewise a valid upper bound. Both energy prunes are sound because
  `defect_cost` is non-negative on every reachable input.
- **`defect_cost` never returns `None` on a reachable input** (`g133_sparse_defect.rs:570-578`).
  With `base` in `{0,1}` and `digit` in `0..=7`, the coefficient is congruent to 0 or 1 mod 4, so
  `(2c-29)^2 - 9` is always non-negative and divisible by 16. The `SemanticMismatch` path is dead
  rather than a hidden branch cut.
- **Hash-keyed class quotients** (`q1_class_representatives`, `q2_class_representatives`,
  `lift_class_representatives`, `g133_sparse_defect.rs:958-1180`, and
  `g41_defect_scout.rs:614-652`). Every FNV hash match is followed by a full element-wise
  comparison that returns `SemanticMismatch` on disagreement, so a 64-bit collision cannot merge
  two inequivalent domains. The class-quotient reduction itself is legitimate: the reachable
  signature set is a function of the lift-profile multiset alone, so it is constant on a class,
  while each root's *target* signature is recomputed from the actual masks.
- **The `(energy, q1)` pair joins are exact, not over-approximate**
  (`compile_lift_pair_profiles`, `compile_q1_pair_profiles`, `compile_q2_pair_residues`). Merging
  by `(energy, q1)` key unions the signature sets over exactly the splits that realise that key,
  so the merged set is the true achievable set for the key and the four-block join is exact in
  both directions.
- **`binary_search_by_key` preconditions.** Every pair-profile slice searched by
  `(energy, q1)` is both sorted (`sort_unstable_by_key` at `:1270`, `:1414`, `:1017`, `:693`) and
  key-unique (deduped through the `positions` / `seen` tables), so the searches at `:2158`,
  `:3322`, `:901`, and `:1521` are well-defined.
- **Two-adic lift identity** (`two_adic_autocorrelation.rs:153-187`). The claim
  `A_s(a + 2^k x) = A_s(a) + 2^k * parity(sum a_i x_{i+s} + x_i a_{i+s}) (mod 2^{k+1})` is correct,
  the omitted `2^{2k} A_s(x)` term does vanish for `k >= 1`, and the parity accumulation
  `(left as u8 & right_lift) ^ (left_lift & right as u8)` correctly extracts the low bit. The
  row-sum identity `sum_s A_s(c) = (sum_i c_i)^2` at `:192-201` is also correct.
- **Quadratic-form polarisation** (`two_adic_autocorrelation.rs:86-126`). The weighted
  autocorrelation is genuinely a quadratic form over `F_2` with no constant term, so testing basis
  vectors and pairwise sums is a complete criterion; `mixed_upper` is strictly upper-triangular and
  `evaluate` reconstructs the same pairing.
- **Mod-4 signature complement** (`complement_signature_mod4` / `join_signature_mod4`,
  `g133_sparse_defect.rs:1426-1445`). Each block contributes `4 * d` to a mod-16 difference, so
  combining four blocks depends only on `sum d_i mod 4`, which is what the per-coordinate 2-bit
  addition and complement implement.
- **Mod-4 digit carry in the dense pair sumset** (`g133_sparse_defect.rs:1398-1405`).
  `low = l_low ^ r_low`, `carry = l_low & r_low` is the correct per-coordinate half-adder for
  `digit = low + 2*high`, and passing `carry` as the XOR offset applies it to all eight
  coordinates simultaneously.
- **`flip_quotient_orbit` incremental PAF update** (`g53_search.rs:804-849`) agrees with the full
  recompute: `cross` is the linear term, `self_correlation` is the `d^2` term (correct with a
  `+` sign for both flip directions since `d^2 = 1`), and the counts are updated after the PAF, so
  the delta is measured against the pre-flip state.
- **`find_g53_q4_two_block_switch` additivity** (`g53_search.rs:1928-1999`) is the one place the
  additive delta model is exact, because `left_block < right_block` guarantees the two changes
  live in different blocks and `q_s` is a sum of independent per-block forms. The hard assertion
  `if residuals[..4] != [0; 4] { return Err(...) }` at `:1978` is a correct invariant there.
- **`q25_pair_repair.rs` row indexing and parallel reduction.** `row_index`
  (`q25_pair_repair.rs:1000-1003`) computes `303p - p(p-1)/2 + (third - second - 1)` correctly for
  the triangular enumeration and totals the asserted 46,056 rows; `saturating_sub` covers `p = 0`.
  The `reduce_roots` combiner appends in arbitrary completion order but the result is immediately
  sorted by the unique key `(second_orbit, third_orbit)`, so the census is order-independent
  despite the non-commutative reduction.
- **`compile_generator_41_order_nine_profiles` inner break**
  (`hadamard_2092.rs:683-696`). `zero` is sorted ascending, so `break` on `a+b+c+d > TARGET` in the
  innermost `d` loop is sound, and the `skip(b_index)` / `skip(c_index)` nesting enumerates
  `b <= c <= d` over the true indices (the `enumerate` precedes the `skip`), which is a valid
  multiset reduction for a symmetric sum.
- **Subset-sum DP** (`hadamard_2092.rs:576-586`, and the set-based variants at `:615-629` and
  `:707-714`). The descending inner loop gives correct 0/1 semantics, and the set variants build
  `additions` from a snapshot of `states` before extending, so no orbit is used twice.

Two smaller items noted but not written up as findings, both currently guarded:

- `for selection in 0_u16..1_u16 << len` (`g41_q29_evolve.rs:1290`, `:1437`) would silently
  enumerate a single value in release if `inventory.large_len[slot]` ever reached 16, since Rust
  masks the shift amount. It is pinned to `[7, 7, 14, 14, 14, 14]` by the assertion at `:498` and
  by the test at `:2401`.
- `add_states_power` and friends (`g41_q29_evolve.rs:931-1063`) pack eight coordinates into a
  `u32`, so any `bits > 4` shifts past the word width; `scout_g41_q29_seed_power` rejects
  `bits > 4` at `:2285` and every other call site passes a literal 3 or 4.

Finally, none of these engines use `rayon`, though the class-pair loops in
`scout_g133_sparse_joint_mod8` (`g133_sparse_defect.rs:2136-2175`),
`scout_g133_sparse_joint_mod16` (`:2828-2879`), and the candidate-pair enumeration in
`repair_g53_quotient_prefix_with_four_moves` are read-only over shared inputs and embarrassingly
parallel. That is a deliberate-looking choice given the module's zero-allocation discipline, not a
defect, but it is the obvious headroom if the mod-16 scout is to survive the next parameter size.
