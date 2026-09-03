# C1057 — proof scaffolding core promotion (2026-09-02)
**Lane**: `complete-ports`.

Promotion of the authority-free proof scaffolding from the private tier into the Ergodis
core crate, as the type-level precondition for a later `proof_synthesis` promotion.

Worktree: `/home/tavis/.cache/ergodis/wt/c1057-proof-scaffolding`, branch
`c1057-proof-scaffolding`. Build target: `~/.cache/ergodis/target/c1057`.

## 1. Status

Complete. The full core validation gate passes and the work is committed on the branch.

## 2. What was promoted

Three modules moved from the private library into `src/` of the core crate and are wired
into `src/lib.rs` as public modules with re-exports:

- `semantic_theorems` — the `ClaimStatus` / `CompositionGate` proof-safety contract for
  composing discovered fragments.
- `predicate_cover` — deterministic greedy cover synthesis that ranks already-typed
  predicates against observations and explicitly creates no authority.
- `mask_cycle_proof` — compact, independently recheckable structural proofs for
  complements of sufficient feature masks.

Nothing under `~/src/ergodis-private` was modified. The private modules remain in place;
the private consumers of `ComplementCycleProof` and `synthesize_predicate_cover` are two
domain-specific task modules, and repointing them at the core is not part of this task.

## 3. API and contracts

### 3.1 The claim contract

`ClaimStatus` is a three-valued ordered lattice: `Candidate` (discovered, unverified),
`FiniteCertified` (exhaustively checked over an explicitly bounded finite domain),
`Proved` (backed by an independent check that is not this module's own bookkeeping).

`CompositionGate::result_status` is the single place the promotion rule lives. It is total
and pure: if any of `domains_compatible`, `quantifiers_compatible`, `rule_verified` fails,
the result is `Candidate`; otherwise the result is the premise status. The result is
therefore always clamped to the premise status, which is asserted exhaustively over all
twenty-four gate configurations in `gate_never_exceeds_its_weakest_premise`.

Three types are new in core relative to the private version, and they are what turns the
contract from a convention into an enforced boundary:

- `IndependentCheck` — an opaque witness with private fields, no `Default`, and a
  fallible constructor that rejects the reserved zero checker id. It carries a
  `checker_id` naming the checker and a `digest` binding the check to the exact object
  checked, so a witness cannot be replayed against a different claim. A discovery
  pipeline cannot conjure one.
- `ClaimLedger` — an append-only ledger where claim `i` is provenance node `i` in a core
  `provenance.rs` `ProvenanceArena`. Every emitted claim carries a `ClaimStatus` and a
  `ProvenanceId`. `record_candidate` takes no check; `record_finite_certified` and
  `record_proved` require an `IndependentCheck`, so there is no code path to a leaf above
  `Candidate` without one.
- `ClaimHandle` / `ClaimRecord` — handle and record types tying the two together.

`ClaimLedger::compose` recomputes the premise status as the weakest recorded premise; the
caller cannot declare it, and `rule_verified` is true exactly when an `IndependentCheck`
was supplied. `compose_with_gate` accepts a caller-built `CompositionGate` but rejects it
with `ClaimError::PremiseMismatch` unless `gate.premises` equals the recomputed weakest
premise and `gate.rule_verified` equals `check.is_some()`. There is no way to smuggle a
stronger premise status past the ledger.

`ClaimLedger::verify` rechecks the whole derivation in one forward scan, which the arena's
child-precedes-parent invariant makes sound. It recomputes every status from the arena
payload and the recomputed statuses of the children, never from the in-memory
`ClaimRecord`, and rejects: an arena/ledger length disagreement, a record pointing at the
wrong node, a subject that no longer matches its payload, an unknown node kind, an
out-of-range status or composition-kind code, a leaf above `Candidate` that names no
checker, a `Candidate` leaf that names one, a childless composition, and any composition
whose recorded status exceeds what its own reconstructed gate allows.

Provenance node kinds `CLAIM_KIND_LEAF` and `CLAIM_KIND_COMPOSITION` are public so a third
party can walk the sidecar without this crate.

### 3.2 Cover synthesis

`synthesize_predicate_cover` is unchanged in behaviour: it takes a candidate count, an
observation count, an explicit `PredicateCoverBudget`, and a caller-supplied rejection
oracle, and greedily orders candidates by exact marginal rejection with ties broken
deterministically by original candidate index. It fails before resource exhaustion rather
than degrading.

The new `record_predicate_cover` binds each selection into a `ClaimLedger`. It can only
produce `Candidate` leaves — the function has no parameter through which an
`IndependentCheck` could be supplied — so there is no path from a cover report to a
stronger status. The module documents that promotion requires a check performed outside
it, and the negative test below demonstrates that no amount of composing changes this.

### 3.3 Mask complement proofs

`synthesize_complement_cycle_proof(width, positive_masks)` recognizes the case where a
family of arity-`(w - 2)` masks over a width-`w` feature alphabet is exactly the
complement family of a single Hamiltonian cycle, and returns a `ComplementCycleProof`
carrying the canonical cycle. `verify_complement_cycle_proof` rechecks a proof object by
reconstructing the mask family from the canonical cycle alone, so it never trusts the
recorded masks or the synthesizer's traversal. `complement_cycle_digest` gives a
content-sensitive digest, and `record_complement_cycle_proof` rechecks the proof, builds
an `IndependentCheck` bound to that digest under the `COMPLEMENT_CYCLE_CHECKER` identity,
and binds a `Proved` leaf.

The scope of that `Proved` is deliberately narrow and is documented at the module head:
the claim is the structural statement only. Whether the masks are *sufficient* for the
caller's predicate is never decided here and is not part of the claim.

## 4. Generality of the masks

The masks are not specific to any one order or feature alphabet. The private code was
already parameterized by `width`, but it was only ever exercised at width seven, and the
sweep exposed one genuine width bug plus one missing check:

1. `(1_u16 << width) - 1` overflows the `u16` shift at `width == 16`, which the private
   `MAX_WIDTH = 16` admits. Replaced by `full_word`, which computes the mask word in
   `u32`. Every width from `MIN_WIDTH = 3` through `MAX_WIDTH = 16` now runs the same code
   path, and `every_supported_width_is_handled_by_the_same_path` asserts it for all of
   them.
2. `verify_complement_cycle_proof` did not check that `canonical_cycle` is a permutation
   of all `width` features; it checked pairwise distinctness of adjacent entries and the
   mask-family equality only. Added an explicit permutation check.

The canonical form is rotation- and reflection-independent: the sweep synthesizes each
width from a scrambled cycle, then from a rotation of it and from its reversal, and
asserts the three proof objects are equal.

## 5. The provenance and semantic gate

The gate was adversarial provenance and semantic tests, not counters. Twenty-four tests
were added or promoted across the three modules.

Provenance binding, every emitted claim:

- `every_emitted_claim_binds_a_status_and_a_provenance_node` — every claim resolves to a
  status and to arena node `i`, arena length equals ledger length, and `verify` passes.
- `every_selection_binds_a_candidate_status_and_a_sidecar_node` — each cover selection
  binds a `Candidate` leaf whose payload records the candidate index and names no checker.
- `recording_binds_the_proof_to_a_status_and_a_sidecar` — the mask proof binds a `Proved`
  leaf whose payload carries `COMPLEMENT_CYCLE_CHECKER` and the proof digest, and distinct
  proofs get distinct digests, so a witness cannot be replayed against another object.

Independent reconstruction of each mask-complement proof:

- `independent_reconstruction_matches_the_recorded_masks` — for every supported width,
  rebuilds the mask family from the canonical cycle alone and compares with the recorded
  family, then checks each mask has arity `w - 2` and each feature is omitted by exactly
  two masks.
- `disconnected_two_cycles_are_rejected` — two disjoint triangles on six features give
  every vertex degree two but are not one cycle; rejected.
- `out_of_range_widths_and_arities_are_rejected`, `synthesizes_and_rejects_forged_seven_cycle`.

A discovered predicate cannot reach `Proved` without an independent check — tested twice,
once against the ledger directly and once against real cover output:

- With no independent check, composing a discovered candidate with a genuinely proved
  fragment yields `Candidate`.
- With an independent check on the *rule* but a candidate premise, the result is still
  `Candidate`: checking the inference step does not certify the discovered input.
- Composing candidates repeatedly stays `Candidate`, and the only `Proved` record in the
  ledger is the one that was recorded with a check.

Forged or mismatched provenance failing closed:

- `forged_status_in_the_record_fails_closed` — raising the in-memory `ClaimRecord` status
  is caught by the sidecar recheck.
- `forged_status_in_the_sidecar_fails_closed` — four separate tampers: raising a leaf's
  payload status without naming a checker; raising a composition's payload status above
  what its premise allows; an out-of-range status code; and a `Candidate` leaf that names
  a phantom checker.
- `a_mismatched_sidecar_fails_closed` — sidecar shorter than the ledger, records swapped
  so a record points at the wrong node, and a record whose subject no longer matches its
  payload.
- `declared_gate_cannot_overstate_its_premises` — a caller-declared gate claiming `Proved`
  premises over a candidate, and one claiming `rule_verified` with no check supplied, are
  both rejected with `PremiseMismatch`; an empty premise list is rejected with
  `NoPremises`.
- `a_handle_from_another_ledger_is_rejected` — an out-of-range foreign handle is rejected
  as `ForeignClaim`, and an in-range foreign handle resolves against the *local* record,
  so cross-ledger reuse can never inherit foreign authority.
- `independent_check_rejects_the_reserved_zero_checker`.

The tamper tests need write access to the arena payload and the claim records; both are
`#[cfg(test)] pub(crate)` accessors (`ProvenanceArena::payload_mut`,
`ClaimLedger::claims_mut`) and are absent from release builds.

### 5.1 Verbatim results

Per-module, `cargo test --all-features --lib <module>::`:

```
running 12 tests
test semantic_theorems::tests::forged_status_in_the_sidecar_fails_closed ... ok
test semantic_theorems::tests::declared_gate_cannot_overstate_its_premises ... ok
test semantic_theorems::tests::every_emitted_claim_binds_a_status_and_a_provenance_node ... ok
test semantic_theorems::tests::a_mismatched_sidecar_fails_closed ... ok
test semantic_theorems::tests::finite_evidence_does_not_promote_to_proof ... ok
test semantic_theorems::tests::a_handle_from_another_ledger_is_rejected ... ok
test semantic_theorems::tests::independent_check_rejects_the_reserved_zero_checker ... ok
test semantic_theorems::tests::a_discovered_predicate_cannot_reach_proved_without_an_independent_check ... ok
test semantic_theorems::tests::proved_compatible_fragments_compose ... ok
test semantic_theorems::tests::forged_status_in_the_record_fails_closed ... ok
test semantic_theorems::tests::gate_never_exceeds_its_weakest_premise ... ok
test semantic_theorems::tests::quantifier_mismatch_blocks_composition ... ok

test result: ok. 12 passed; 0 failed; 0 ignored; 0 measured; 601 filtered out; finished in 0.01s
```

```
running 6 tests
test predicate_cover::tests::every_selection_binds_a_candidate_status_and_a_sidecar_node ... ok
test predicate_cover::tests::blind_cover_learns_later_features_from_remaining_observations ... ok
test predicate_cover::tests::ties_are_stable_and_do_not_encode_domain_knowledge ... ok
test predicate_cover::tests::a_forged_cover_claim_fails_the_sidecar_recheck ... ok
test predicate_cover::tests::a_discovered_predicate_cannot_reach_proved_without_an_independent_check ... ok
test predicate_cover::tests::cover_fails_before_resource_exhaustion ... ok

test result: ok. 6 passed; 0 failed; 0 ignored; 0 measured; 607 filtered out; finished in 0.02s
```

```
running 6 tests
test mask_cycle_proof::tests::disconnected_two_cycles_are_rejected ... ok
test mask_cycle_proof::tests::every_supported_width_is_handled_by_the_same_path ... ok
test mask_cycle_proof::tests::independent_reconstruction_matches_the_recorded_masks ... ok
test mask_cycle_proof::tests::out_of_range_widths_and_arities_are_rejected ... ok
test mask_cycle_proof::tests::recording_binds_the_proof_to_a_status_and_a_sidecar ... ok
test mask_cycle_proof::tests::synthesizes_and_rejects_forged_seven_cycle ... ok

test result: ok. 6 passed; 0 failed; 0 ignored; 0 measured; 607 filtered out; finished in 0.00s
```

Full gate, run in the worktree with `CARGO_TARGET_DIR=/home/tavis/.cache/ergodis/target/c1057`:

`cargo fmt --check` — clean, no output, exit 0 (`FMT OK`).

`cargo clippy --all-targets --all-features -- -D warnings`:

```
    Checking ergodis v0.1.0 (/home/tavis/.cache/ergodis/wt/c1057-proof-scaffolding)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 22.55s
```

`cargo test --all-features` — exit code 0, every target `ok`, no failures. The library
suite:

```
test result: ok. 613 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 71.51s
```

The remaining integration, doc, and binary targets all reported `test result: ok.` with
zero failures.

The differential-oracle and benchmark clauses of the core gate do not apply: this
promotion adds no solve kernel, touches no hot loop or hot struct, and makes no
performance claim. The two mask-proof semantic corrections in section 4 change behaviour
only at inputs the private version could not process at all (width sixteen) or would have
accepted wrongly (a non-permutation cycle in a hand-built proof object).

## 6. What remains before `proof_synthesis` can follow

1. The private `proof_synthesis` module has not been read or assessed in this task; that
   assessment is the first step of its own promotion.
2. `proof_synthesis` must be rewritten against `ClaimLedger` rather than against bare
   `ClaimStatus` values, so that every fragment it emits is bound to a sidecar node at the
   point of emission rather than being labelled afterwards.
3. It needs checker identities of its own, in the `COMPLEMENT_CYCLE_CHECKER` style, one
   per independent checker it can call, so its `IndependentCheck` witnesses are
   attributable and digest-bound.
4. The two private task modules that consume `ComplementCycleProof` and
   `synthesize_predicate_cover` should be repointed at the core modules and the private
   copies deleted, so the promoted code has exactly one definition before a fourth module
   builds on it.
5. Serialization of a `ClaimLedger` is not addressed here. The arena has a flat
   representation and `ClaimLedger::verify` is a pure forward scan, so a cold schema is
   straightforward, but `proof_synthesis` will want one and it does not exist yet.

## 7. Commits

Branch `c1057-proof-scaffolding` in `~/src/ergodis`, worktree
`/home/tavis/.cache/ergodis/wt/c1057-proof-scaffolding`:

| Hash                                       | Subject                                                     |
|--------------------------------------------|-------------------------------------------------------------|
| `5fcf8fc8ecf391280341f15999e83c18a1496f73`  | Promote authority-free proof scaffolding into the core crate |

Branch tip: `5fcf8fc8ecf391280341f15999e83c18a1496f73`.
