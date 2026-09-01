# C1030 round 2 — reduction, quotient, and modular-descent math audit

**Task**: C1030 round 2 · **Lane**: `complete-ports` · **Scope**: reduction/quotient/modular-descent math

## Verdict

I found **no SEV1**. Three SEV2 findings are reported below. The core mathematics of this family
holds up under checking: I re-derived the quotient-PAF double count, the Gauss-period character
arithmetic behind the order-29 three-square reduction, the `B = e + 7k` residue algebra at every
modulus in the descent (7, 14, 28, 49, 343), and the signed-energy/defect-weight bookkeeping, and
each matched the code. In particular I looked specifically for the round-1 defect shape — an
additivity or independence property that holds on part of the domain and is applied on all of it —
and did not find a second instance in this family. The three block-joins that carry the
paper-facing negatives (mod-28, mod-49, and the sparse q0–q4 join) all add *exact integer*
per-block quantities before reducing, so their cross-block additivity is unconditional rather than
support-dependent.

Audited deeply, line by line, with the mathematical claim re-derived independently:
`quotient_paf_proof.rs`, `reduction_proof.rs`, `g53_mod7_reduction.rs`, `g53_mod14_reduction.rs`,
`g53_mod28_reduction.rs`, `g53_mod49_reduction.rs`, `g53_mod343_scout.rs`,
`g53_defect_profile_proof.rs`, `g53_sparse_defect.rs`, `g53_sparse_prefix.rs`,
`g53_sparse_q4_oracle.rs`, `g53_mod49_high_scout.rs`.

Audited at the level of "what does this proof object assert, and does the thing it calls compute
that": `g53_reduction_proof.rs`, `g53_sparse_q4_proof.rs`, `g41_quotient_filter_proof.rs`.

Read only far enough to settle a specific question raised by an in-scope module (not audited):
`g41_defect_scout.rs` (the shift list and intersection in `census_g41_quotient_filter`),
`g41_joint_quotient_search.rs` (does the 768-root filter get used as a sufficient condition — it
does not), `papers/complete-repair-ports/ergodis/src/root_execution.rs` (the contract
`reduce_roots` imposes on its reducer).

Not opened: `hadamard_2092.rs`, `proof_synthesis.rs`, `g53_search.rs` (round-1 territory).

## SEV2 — the sparse-q4 witness merge always discards the witness

**Location**: `ergodis-private/src/g53_sparse_defect.rs:465-481`, with the identity element at
`:494-505` and the consumer at `ergodis-private/src/bin/g53_sparse_q4_join.rs:22-33`.

**Verified quote** (re-read immediately before writing this):

```rust
fn merge_reports(
    left: Result<G53SparseQ4Report, G53SparseDefectError>,
    right: Result<G53SparseQ4Report, G53SparseDefectError>,
) -> Result<G53SparseQ4Report, G53SparseDefectError> {
    let mut left = left?;
    let right = right?;
    left.roots_examined += right.roots_examined;
    left.constructive_hits += right.constructive_hits;
    left.exhaustive_misses += right.exhaustive_misses;
    left.right_pair_states += right.right_pair_states;
    left.left_pair_probes += right.left_pair_probes;
    if right.first_witness_root < left.first_witness_root {
        left.first_witness_root = right.first_witness_root;
        left.first_witness = right.first_witness;
    }
    Ok(left)
}
```

**The claim**: `merge_reports` is passed to `reduce_roots` as the reduction operator, whose contract
is stated in `papers/complete-repair-ports/ergodis/src/root_execution.rs:45-46`: "Parallel reduction
may regroup outputs. Callers must supply an associative reducer with `identity()` as its identity
element." The intended semantics of the two witness fields is "the constructive q4 witness found at
the smallest root ordinal", which is what `bin/g53_sparse_q4_join.rs:29` advertises as
`positives direct replay`.

**Mechanism**: `first_witness_root` is `Option<u32>`, and Rust's derived `Ord` for `Option` places
`None` before `Some`, so `None < Some(k)` for every `k`. The identity element supplied at
`g53_sparse_defect.rs:502-503` is `first_witness_root: None, first_witness: None`. Work through the
four cases:

- `left = Some(a)`, `right = None`: the guard reads `None < Some(a)` → true, so the accumulator is
  overwritten with `None`. A witness already held is thrown away.
- `left = None`, `right = Some(b)`: the guard reads `Some(b) < None` → false, so the accumulator
  stays `None`. A witness just found is never taken up.

So `merge_reports(identity, x) != x` whenever `x` carries a witness: `identity()` is not an identity
element for this reducer, which is precisely the contract `reduce_roots` documents. In the
single-thread path (`root_execution.rs:53-64`) the fold is
`aggregate = reduce(aggregate, output)` seeded from `identity()`, so the accumulator starts at
`None` and, by the second case above, can never leave `None`. The aggregated
`first_witness_root`/`first_witness` are therefore unconditionally `None`, regardless of what the
per-root kernel found. The counters `constructive_hits` and `exhaustive_misses` are summed
correctly and are unaffected.

**Concrete trigger**: `census_g53_sparse_q4_roots(max_roots, threads)` — that is,
`cargo run --bin g53_sparse_q4_join -- --max-roots N --threads T` — for any parameters where some
root yields a witness. The emitted JSON would then carry `constructive_hits: 1` together with
`first_witness: null` and `first_witness_root: null`. With the current g53 parameters the q4
exclusion holds and every root is a miss, so the always-`None` answer coincides with the correct
answer and the defect is masked; this is why it has not shown up.

**Impact**: the only replay evidence a positive q4 hit would produce is silently dropped, and the
JSON the binary emits would contradict itself (a hit with no witness). This is latent rather than
live: it cannot manufacture a false positive or a false negative in the counts, and the sealed q4
exclusion proof (`g53_sparse_q4_proof.rs`) does not call this function at all — it goes through
`census_g53_q4_fibres` and `verify_g53_sparse_q4_census`, neither of which has the defect. So no
published negative depends on it.

**Described fix (not applied)**: replace the guard with an explicit match that treats `None` as the
absorbing-identity rather than the minimum — take `right`'s witness when `left` has none, keep
`left`'s when `right` has none, and compare ordinals only when both are `Some`. Alternatively store
the ordinal as a bare `u32` with `u32::MAX` as the identity sentinel (which is how `best_residual`
is already handled correctly at `g41_joint_quotient_search.rs:932` with `u64::MAX`), and derive the
`Option` only when serializing.

## SEV2 — the sealed g41 quotient filter names six shifts and intersects four

**Location**: `ergodis-private/src/g41_quotient_filter_proof.rs:25-30` and `:186-192`; the
computation it seals is `ergodis-private/src/g41_defect_scout.rs:1447-1473`.

**Verified quotes** (re-read immediately before writing this). From
`g41_quotient_filter_proof.rs:25-30`:

```rust
const SOURCE_SEMANTICS: &[u8] = b"bordered GS order 2092; carrier 522; multiplier 41; canonical Z18 six-slot projection; quotient PAF representatives q0,q1,q2,q3,q6,q9; independently exact per-shift necessary root intersection; survivors have no joint-witness authority";
const REPRESENTATIVE_SHIFTS: [u8; 6] = [0, 1, 2, 3, 6, 9];
const INDIVIDUAL_HITS: [u64; 4] = [1_536, 2_304, 2_304, 4_608];
const SURVIVORS: u64 = 768;
```

From `g41_defect_scout.rs:1450-1464`:

```rust
    let shifts = [2_usize, 3, 6, 9];
    let mut individual_shift_hits = [0_u64; 4];
    let mut intersection = Vec::<u32>::new();
    for (index, shift) in shifts.into_iter().enumerate() {
        let report = census_g41_exact_shift(shift)?;
        if report.mod2_roots != 262_144 {
            return Err(G41DefectScoutError::SemanticMismatch);
        }
        individual_shift_hits[index] = report.exact_shift_hits;
        if index == 0 {
            intersection = report.surviving_root_ids.into_vec();
        } else {
            intersection = intersect_sorted(&intersection, &report.surviving_root_ids);
        }
    }
```

and, twelve lines further on at `:1466`, the report it returns carries
`representative_shifts: [0, 1, 2, 3, 6, 9]`.

**The claim**: the sealed proof asserts that 768 is the intersection of independently exact
necessary root filters, one per quotient-shift orbit representative, over the six representatives
`q0, q1, q2, q3, q6, q9`. The six values are the correct orbit representatives — `verify_shift_orbits`
at `g41_defect_scout.rs:1392-1424` confirms the multiplier-41 shift orbits are
`{1,5,7,11,13,17}, {2,4,8,10,14,16}, {3,15}, {6,12}, {9}`, so `0` plus those five representatives
is exactly the independent shift set.

**Mechanism**: the loop intersects only `[2, 3, 6, 9]`. Shifts 0 and 1 never enter the
intersection at all; `oracle_g41_domains` supplies `constructive_q0_hits` and `constructive_q1_hits`
(checked at `g41_quotient_filter_proof.rs:171-177`), but those are counts of roots for which a q0 or
q1 solution was constructed, not per-root filters, and they are never intersected with anything. The
tell is visible on the face of the proof object: `individual_shift_hits` is `[u64; 4]` sitting next
to a `representative_shifts` of `[u8; 6]`.

The direction matters and it is the safe one. Dropping two necessary conditions makes the surviving
set a *superset* of the true one, so every root the proof excludes genuinely fails one of q2, q3,
q6, q9 exactly and the authorized exclusion is valid. What is false is the statement of how strong
the filter is and which equations produced it.

**Concrete trigger**: `synthesize_g41_quotient_filter_proof(G41QuotientFilterBinding::registered(),
observation())` with the canonical observation. The proof it returns carries
`representative_shifts: [0, 1, 2, 3, 6, 9]`, `necessary_filter_survivors: 768`, and a source
commitment hashing the "six representatives / per-shift necessary root intersection" sentence, while
768 is the four-shift intersection.

**Impact**: any prose that reads the proof object and says "768 roots survive the exact necessary
filter at all six independent quotient shifts" is wrong; the correct statement is "at q2, q3, q6 and
q9". Because the sealed source-semantics string is exactly the artifact that is supposed to make the
proof's meaning auditable, a wrong sentence there is worse than a wrong comment. I checked the one
downstream consumer, `g41_joint_quotient_search::compile_campaign`
(`g41_joint_quotient_search.rs:943-972`), and it uses the 768 roots only as a search seed set under
a `discovery-only positive replay; misses have no authority` provenance, so nothing currently treats
the filter as already having discharged q0 and q1. That is what keeps this at SEV2 rather than SEV1.

**Described fix (not applied)**: either extend the loop in `census_g41_quotient_filter` to intersect
q0 and q1 as well (they have exact per-shift censuses available), or narrow both
`REPRESENTATIVE_SHIFTS` and the `SOURCE_SEMANTICS` sentence to the four shifts actually intersected
and say separately that q0/q1 evidence is constructive-hit counts rather than filters. Either way
the descriptor's source commitment changes, so the version should be bumped.

## SEV2 — exact-q0 is tested against one arbitrary preimage per mod-49 signature

**Location**: `ergodis-private/src/g53_mod49_high_scout.rs:222-227` (the index that keeps one
witness per signature) and `:547-556` (the exact-q0 test performed against that witness), reached
through `compile_g53_mod49_exact_q0_q7_lifts` at `:680-682`.

**Verified quotes** (re-read immediately before writing this). From `:222-227`:

```rust
            if witnesses[signature] == u32::MAX {
                witnesses[signature] =
                    interior_code * 5 + u32::from(first) + u32::from(ninth) * POWERS[9];
                q0_energy[signature] = autocorrelation(&word, 0);
                cardinality += 1;
            }
```

From `:547-556`:

```rust
                if domains[fourth].digits[fourth_code] != u32::MAX {
                    if require_exact_q0 {
                        let energy = u32::from(domains[first].q0_energy[first_code])
                            + u32::from(domains[second].q0_energy[second_code])
                            + u32::from(domains[third].q0_energy[third_code])
                            + u32::from(domains[fourth].q0_energy[fourth_code]);
                        if energy != TARGETS[0] as u32 {
                            continue;
                        }
                    }
```

**The claim**: `compile_g53_mod49_exact_q0_q7_lifts` is documented at `:678-679` as compiling
"discovery seeds satisfying exact q0 and q1--q6 modulo 49", one per mod-7 root, and is exposed
through a process-lifetime cache `cached_g53_mod49_exact_q0_q7_lifts` at `:692-699`.

**Mechanism**: `compile_q7_witness_domain` builds an index keyed by the seven-digit base-7 mod-49
signature, and stores exactly one preimage per key — the first one the `interior_code` scan reaches.
Exact q0 is not a function of that key. The shift-0 digit of the signature is
`((C(word,0) - C(e,0)) / 7) mod 7`, so the signature pins `C(word,0)` only modulo 49; two preimages
of the same signature can have `C(word,0)` differing by any multiple of 49, and `q0_energy` records
whichever one the scan happened to see first. `find_q7_codes` then rejects a signature quadruple
whose *stored* representatives' q0 energies do not sum to 15,603 and moves on, never revisiting that
quadruple with a different preimage. The search therefore runs over a strict subset of the true
candidate set: this is the "arbitrary fibre representative treated as characterizing the fibre"
shape, the same one round 1 recorded as finding 7 in `g41_q29_evolve.rs`, recurring here in a module
round 1 did not cover.

The error is one-directional. No false positive can escape: any quadruple that does pass is turned
into a lift and then re-derived from scratch by `verify_q7_lift` and re-checked for
`residuals[0] == 0` at `:665-668`, both of which recompute the words directly. The failure mode is a
missed lift, and a miss is loud — `find_q7_codes` returns `Err(G53Mod49HighError::SemanticMismatch)`
at `:567`, which `compile_g53_mod49_q7_lifts_inner` propagates, aborting the whole compilation.

**Concrete trigger**: I could not construct a specific root that exhibits the miss without executing
the compiler, and I say so rather than assert one. The mechanism above establishes that the filter
tests a property the index key does not determine; whether some root's only exact-q0-realizing
preimage is shadowed by a different first-seen preimage is an empirical question. The falsification
test is cheap and direct: change `compile_q7_witness_domain` to retain, per signature, the set of
distinct `C(word,0)` values (or all preimages), rerun `compile_g53_mod49_exact_q0_q7_lifts`, and
compare. If the multi-preimage variant produces lifts for roots where the current one returns
`SemanticMismatch`, the defect is confirmed; if the two agree on all 2,496 roots, the current
single-witness index happens to be adequate for these parameters and the finding drops to a
latent-risk note.

**Impact**: bounded. Because misses are loud and the docstring already disclaims coverage authority
on failure, this cannot put a wrong number into a claim. What it can do is make the exact-q0 seed
compiler abort with an error variant that reads as "an invariant was violated" when the real
condition is "this bounded search did not find one" — which is the same diagnosis-cost problem
round 1 recorded for the overloaded `Hadamard2092Error::FixedField`, and which would send someone
hunting for a nonexistent arithmetic bug.

**Described fix (not applied)**: either store the achievable q0 energies per signature (they are
bounded — the per-block q0 range is small) and test membership rather than equality of a single
stored value, or drop the `require_exact_q0` filter from the signature-indexed search entirely and
apply exact q0 only in the post-hoc verification, accepting a larger candidate stream. Also give the
exhausted-search outcome its own error variant, distinct from `SemanticMismatch`.

## Below threshold

- `g53_mod49_reduction.rs:147-150`: `sumset` returns the saturated set when *either* operand has full
  cardinality, which is wrong when the other operand is empty; unreachable from
  `count_g53_mod49_joined_roots` (the trivially-saturated branch at `:196-203` already skips any root
  with a full block set, and no used mask has an empty set since every `k_weight` in {35, 36, 37} is
  realizable within `[0,4]^10`), and the wrong direction is the conservative one. Same family as
  round-1 finding 13, different file.
- `g41_joint_quotient_search.rs:936-939` carries the identical `Option`-ordering witness-merge defect
  described in the first finding above; out of scope for this pass, worth fixing in the same patch.
  Its `best_residual` merge at `:932` uses a `u64::MAX` sentinel and is correct, which is the pattern
  the `Option` fields should copy.
- `g53_mod14_reduction.rs:136-140`: `compile_g53_mod14_prefix_counts` wraps `.expect("fixed valid
  prefixes")` inside an `Ok(...)`, so a `SemanticMismatch` from `count_g53_mod14_prefix` panics
  instead of returning through the `Result` the signature promises.
- `g53_mod7_reduction.rs:571-585`: both `cached_g53_mod7_q0_lifts` and
  `cached_g53_mod7_q0_lift_bank` have no consumer anywhere under `ergodis-private/src`.
- `g53_mod343_scout.rs:320-323` writes into a fixed `[(u16, u16); 10]` indexed by `BTreeMap`
  enumeration position; it is correct today only because exactly ten distinct special masks occur
  (independently pinned by `g53_sparse_q4_proof.rs:127`), and would panic rather than error if that
  ever changed.
- `reduction_proof.rs:505` and `g41_quotient_filter_proof.rs:217` each carry a second scalar check
  that is arithmetically implied by the first (`remaining_constant != 2088` already forces
  `2088 % 116 == 0`; `signed_energy != 1_976` already forces `(1976 - 136) / 8 == 230`).
- `reduction_proof.rs:511` still pins the three-square target after building the map it protects —
  the ordering point already recorded in round 1's mystery ledger. Unchanged, still harmless.

## Not found / checked clean

These are the reductions and invariants I re-derived independently and found the code to implement
correctly. Each one is a place a defect of the kind I was hunting could have lived.

**The quotient-PAF double count** (`quotient_paf_proof.rs:295-345`). For residue counts
`c_r = |D ∩ (r + qZ)|`, the identity `Σ_r c_r c_{r+s} = #{(x,y) ∈ D×D : y − x ≡ s (mod q)} =
Σ_{t ≡ s (mod q)} C(t)` is a clean double count, and `quotient_paf_into` computes exactly the left
side while the test at `:396-440` checks it against the right side exhaustively for every carrier up
to 8. The targets follow: with fibre 522/18 = 29, uniform nonzero intersection 520 and row weight
1043, a nonzero quotient shift collects 29 nonzero source shifts giving 29 · 520 = 15,080, and the
zero quotient shift collects 28 nonzero ones plus `C(0)` giving 28 · 520 + 1043 = 15,603. Both match
`required_targets` and the test's asserted values.

**The character-coverage completeness argument** (`quotient_paf_proof.rs:235-272`). Requiring the
observed orders to be strictly increasing divisors of q greater than 1 whose φ-values sum to q − 1
does force them to be *all* nontrivial divisors, because `Σ_{d | q} φ(d) = q` and every φ(d) is
positive. I hand-checked `euler_phi` on 2, 3, 6, 9 and 18 (giving 1, 2, 2, 6, 6, summing to 17 = 18 − 1)
including the shrinking-`value` trial-division bound, which is correct.

**The order-29 Gauss-period reduction** (`reduction_proof.rs`). Multiplication by 91 on Z/522 acts
trivially on the Z/18 factor and as multiplication by 4 on Z/29; 4 generates the quadratic residues,
of index 2, so the orbits are 18 fixed points plus 36 orbits of size 14 splitting evenly by Legendre
class — matching `FIXED_POINTS = 18`, `ORBIT_SIZE = 14`, and the residue/nonresidue split. Under the
order-29 character the two Gauss periods are `(−1 ± √29)/2`, so
`χ(D) = (2f − r − n)/2 + (r − n)√29/2`, which is exactly `field_coordinates`, and `energy_coordinates`
returns `4χ(D)²` split into rational and radical parts. `row_sum_orbit_solutions` correctly yields
the unique `(8, 18)` for 260 and `(9, 18)` for 261 (260 ≡ 8 and 261 ≡ 9 mod 14, with 252/14 = 18 in
both cases), giving rational coordinates −2 and 0. Q-linear independence of 1 and √29 forces the
radical part to vanish, `−4·B_special = 0` gives `B_special = 0`, and 2092 − 4 = 2088 = 116 · 18
with `B = 2b` even because `r + n = 18`. The two sorted three-square representations of 18 are
[0,3,3] and [1,1,4], and the emitted energy profiles [4,0,1044,1044] and [4,116,116,1856] follow
from 29·(2v)².

**The mod-7 census** (`g53_mod7_reduction.rs`). `B = e + 7k` gives `C(s) ≡ Σ_p e_p e_{p+s} (mod 7)`
directly. The shift-9 redundancy check at `:730-752` is the correct use of `Σ_{s=0}^{17} C(s) =
Σ_b w_b²` together with the reflection symmetry `C(s) = C(18 − s)`, and reproduces the recorded
residue 2. I independently counted the symmetric masks by weight class — 144 with weight ≡ 1 (mod 7)
and 158 with weight ≡ 2 — and `144 · 158³ = 567,980,928`, matching `raw_modular_assignments` in the
test at `:848`. The meet-in-the-middle join in `count_g53_mod7_prefix` complements the packed base-7
signature correctly, and the module's own frequency-oracle test at `:902-930` is a genuine second
implementation of the same count.

**The mod-7 lift-class permutation** (`g53_mod7_reduction.rs:505-569`). `mask_class` keys on
(endpoint popcount, interior popcount), and slots 0 and 9 carry multiplicity 1 while slots 1–8 carry
multiplicity 2, so relabelling slots within each group and each bit value is a bijection on lifts
preserving both row weight and energy — `permute_digits` implements exactly that bijection. The DP's
per-layer deduplication on `(row_weight, energy)` at `:638-643` does not change the set of reachable
final states, because every future transition depends only on that pair; the `seen` array is sized
`(Q0_TARGET + 1) · 262` and the key `row_weight · 15604 + energy` fits it exactly.

**The mod-14 parity descent** (`g53_mod14_reduction.rs`). Since 49 ≡ 7 (mod 14), the mod-14 residue
of `C(s)` depends on `k` only through `k mod 2`, and the endpoint-parity constraint
`k̄_0 ⊕ k̄_9 = (k-weight mod 2)` is the correct consequence of the symmetric row equation. Combining
blocks by XOR is right because the per-block offsets are `7·t_b` and only `Σ_b t_b mod 2` matters.
The enumeration over all 1,024 parity masks with the right endpoint parity is a *superset* of the
achievable parity vectors (interior digit sums impose an extra parity relation the enumeration
ignores), which makes `surviving_roots` an overcount — the conservative direction for a necessary
filter, and the module does not claim otherwise.

**The mod-28 and mod-49 exact-lift descents** (`g53_mod28_reduction.rs`, `g53_mod49_reduction.rs`).
49 ≡ 21 (mod 28) makes the mod-28 residue depend on `k mod 4`, and both modules sidestep the
question entirely by enumerating *exact* `k ∈ [0,4]^10` lifts satisfying the exact row equation and
reading off `t_b = (C(B) − C(e))/7` as an exact integer. The cross-block combination is then plain
integer addition of the `t_b`, reduced mod 4 (mod 28) or mod 7 (mod 49) digit-wise, which is
unconditionally additive — there is no support-dependent cross term of the kind round 1 found in
`g53_search.rs`. The endpoint split `first ∈ [max(0, e−4), min(e, 4)]` with `e ≤ 8` enumerates every
`(k_0, k_9)` pair exactly once. `full_set()` at `g53_mod49_reduction.rs:129-133` masks the last word
correctly: 2401 = 37·64 + 33.

**The mod-343 scout** (`g53_mod343_scout.rs`). The base-49 signature arithmetic is the right
necessary condition (`C ≡ target mod 343` iff `Σ_b t_b ≡ T mod 49`), the witness packing
`interior_code · 5 + first + ninth · 5^9` correctly places the base-5 digits at slots 0–9 and
round-trips through `decode_entry`, and every hit is replayed by `replay_mod343_hit`, which rebuilds
the four words from scratch and checks the row sums, the mod-7 consistency with the assignment, and
`(total − target) ≡ 0 (mod 343)` for all five shifts. Misses are explicitly labelled bounded and
carry no authority, which is the correct disclaimer for a randomized probe loop.

**The defect-weight bookkeeping** (`g53_defect_profile_proof.rs`). Signed quotient coordinates are
`29 − 2B`, so `Σ (29 − 2B)² = 4·18·29² − 4·29·1043 + 4·15603 = 1976`; the ten admissible values of
`B ∈ {0,1,7,8,14,15,21,22,28,29}` give `(29 − 2B)² − 1 ∈ 56 · {15, 13, 4, 3, 0, 0, 3, 4, 13, 15}`,
so 1976 − 72 = 1904 = 56 · 34 and the weight vector [15, 13, 4, 3] with per-coordinate bounds
[2, 2, 8, 11] is exactly right. The background bound at `:258-270` is also sound, and I checked the
part most likely to be wrong: `40` is 4 blocks × 10 reciprocal slots, `8` is the four blocks' two
singleton slots each, and `singletons + floor((D − singletons)/2)` is a valid *upper* bound on the
number of defective slots because a paired slot must contribute two defect coordinates. Since that
function is monotone in D, taking the maximum over profiles of D and then applying it is legitimate.
The maximum is 11 (from 4·1 + 3·10 = 34), giving 8 + 1 = 9 and a background floor of 31, matching
the test.

**The sparse q0–q3 defect compiler and its dedup key** (`g53_sparse_defect.rs:135-241`). This is the
one place where a deduplication could have destroyed completeness, and it does not. Profiles are
deduplicated on `(defect_energy, paf)` where `paf` is the full four-entry array for shifts 1–4 — and
that pair is *exactly* the data the four-block join consumes (total defect energy 34, which is
equivalent to `Ĉ(0) = 15,603` given fixed row sums, and total PAF 15,080 at each of the four shifts).
Two profiles sharing the key are therefore interchangeable for every downstream question, so
collapsing them cannot lose a solution. The displacement alphabet `[-2..2]` covers the whole range of
`k`, the row-reachability prune `|target − row| ≤ 2·remaining` is a valid bound, and the energy prune
is monotone. `g53_sparse_q4_oracle.rs` then cross-checks each block domain against a full 5^10
base-five scan with an independent key set, which is a real independent oracle rather than a
re-execution of the same kernel.

**The q4 fibre join** (`g53_sparse_prefix.rs:98-327`). The right-hand pair list is deliberately *not*
deduplicated, so distinct q4 values sharing an `(energy, prefix)` key all survive the
`partition_point` range scan and all reach the attainable-q4 bitset — the exact opposite mistake to
the one that would have been fatal here. Every bound (the 3,000,000-pair budget, the 65,536-bit q4
range, the eight-value class array) fails loudly rather than truncating.

**Block-0-is-special is without loss of generality.** The whole g53 chain fixes block 0 as the
row-260 block and blocks 1–3 as row-261. Every target the chain imposes (`Ĉ(s)` summed over the four
blocks) is invariant under permuting the blocks, so searching only the ordered arrangements with the
260-block first still covers every solution up to relabelling. The mod-7 assignment compiler
enumerates all such ordered quadruples, so the q4 exclusion is not weakened by this normalization.
