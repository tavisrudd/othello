# C1176 — rule-contract semantics follow-ups

**Lane**: `ergodis`
**Date**: 2026-09-13
**Repository**: core `~/src/ergodis` (branch `main`, base `b63c6dc`)

## Scope

Decisions D2–D7 of the C1176 brief, plus the property tests allocated to C1176 by the
C1171 rule-programme review (`notes/2026-09-12-c1171-rule-programme-review.md`):
PROP-TEST 2, 3, 4, 5, 6, 9, 10 (adapted to D2), 16 and 17. D1 (wire schemas unchanged)
is a constraint, not a work item: no certificate, support-certificate or snapshot field
was added, removed or renamed.

Status: complete. Core commits, oldest first:

| Commit    | Item  | Subject                                                             |
| --------- | ----- | ------------------------------------------------------------------- |
| `7cc7abe` | D2    | Pin certificate.rounds to the min(N, M+1) convergence bound         |
| `421aa78` | D3    | Check declared symmetries against the certified values              |
| `22160e1` | D4    | State and gate the algebra laws the checkers rely on                |
| `88cd0f9` | D5    | Rebind the grounding instead of rebuilding it for a fact update     |
| `1d7d135` | D5    | Measure where the per-update cost of a recursive query goes         |
| `63573c7` | tests | Generate replacement sequences against a recursive query            |
| `759a899` | D6    | Add the dense negative control the frontier measurement was missing |
| `0b17cf4` | D7    | Name the sharpness development without restating it                 |

## D2 — the meaning of `Certificate.rounds`

Commit `7cc7abe` "Pin certificate.rounds to the min(N, M+1) convergence bound".

`Certificate.rounds` is now the producer's claimed from-zero convergence bound, admitted
only up to the grounding's own bound and discharged by replay.

- `Grounded::round_bound()` (new field, computed once in `ground`) is `min(N, M + 1)`:
  N scalar slots including the unit, M distinct grounded product outputs.
  `Prepared::round_bound()` forwards it. Files: `crates/verify/src/rule_contract.rs`,
  `crates/rules/src/lib.rs`.
- `rule_contract::verify` admits `rounds <= round_bound` instead of
  `rounds <= scalar_count` (review item E4). For the four-vertex distance fixture the
  admitted maximum drops from 21 to 5.
- Writers: the cold `evaluate_into`/`certificate` path still writes the sharp measured
  sweep count; `Prepared::update_into` and both `RecursiveQuery` writers
  (`RecursiveQuery::new`, `RecursiveQuery::replace`) write `round_bound` where they
  previously wrote `scalar_count`.
- `Prepared::propagate` iterates `1..=round_bound` instead of `1..=N`. The defensive
  `Err(Error::Budget)` after the loop is retained and documented as unreachable for an
  admitted source, citing `WeightedRules.Convergence` and
  `WeightedRules.OrderedConvergence.fixed_after_outputs`.
- The measurement is observable with no wire change: `composition_graph::propagate`
  returns the number of rule scans it performed, `VerifiedGraph::rounds()` records it
  (also refreshed by `replace_input`), and `Verified::rounds()` exposes it through the
  rule-contract layer. That count is the least `max_rounds` the same replay would have
  accepted.
- The `RecursiveQuery` reason stays valid and is now stated in the doc: `round_bound`
  depends only on the grounded equations, `with_fact` changes only the input vector, so
  the `max_rounds` retained in `VerifiedGraph` from the initial verification is a valid
  from-zero budget for every later `replace_input`. The warm-start side cites
  `WeightedRules.Incremental` (`iterate_le_iterateFrom`, `improved_iterateFrom_bound`,
  `improved_iterateFrom_fixed`).
- The `composition_graph::verify` monomorphization gate required by D4 landed in this
  commit rather than the D4 one, because it documents the same `propagate` contract
  (the rule-skip and the round cap).

Hand tests updated: `crates/rules/tests/contracts.rs` now pins `round_bound == 5`,
`certificate.rounds == 4`, the measured replay count `== 4` at both 4 and 5, and refusal
at `round_bound + 1`; `crates/runtime/tests/recursive_queries.rs` pins the runtime's
emitted `rounds == 5` against `scalar_count == 21`.

Gates run at this commit, all passing:

```text
cargo fmt --check
cargo clippy -p ergodis-rules -p ergodis-verify -p ergodis-runtime --all-targets -- -D warnings
cargo test -p ergodis-rules -p ergodis-verify -p ergodis-runtime   # 98 passed, 0 failed
```

## D3 — symmetry invariance in verification

Commit `421aa78` "Check declared symmetries against the certified values".

`rule_contract::verify` and `rule_contract::verify_support` now check
`values[i] == values[pi[i]]` for every declared permutation, after the binding and budget
checks and before any replay or support pass. A failure is the new `Error::Invariance`
("certified values are not invariant under a declared symmetry"). `Error::Symmetry` keeps
its meaning: the admission failure raised by `ground` when a declared permutation is not an
automorphism of the grounded system. `verify_support` also gained the missing
`values.len() == scalar_count` binding check, without which the new check could not index
safely.

This converts a declaration that previously did nothing beyond entering the source
identity into an independent consistency check on the claim, and is the executable
counterpart of the symmetry-invariance statement in the Lean module
`WeightedRules.Contract` (review item EXT-2, RISK-3).

Tests:

- `crates/rules/tests/contract_properties.rs::declared_symmetry_permutes_the_certified_values`
  (PROP-TEST 6). The generator builds programs with a built-in automorphism rather than
  rejection-sampling one: rules use variables only, so the grounded product multiset is
  closed under any domain relabelling; every generated fact is replaced by its whole orbit
  at one cost, so the input vector is invariant; the declared permutation is the coordinate
  permutation induced by a rotation of the domain, which is fixed-point free. The property
  asserts admission succeeds, both certificate kinds verify, the certified values are
  constant on every orbit, and perturbing one moved coordinate gives `Invariance` for both
  the ordinary and the support certificate.
- `crates/rules/tests/contracts.rs::declared_nontrivial_symmetry_is_checked_against_equations`
  extends the retained distance fixture with its existing vertex-swap symmetry: perturbing
  a swapped `dist` coordinate gives `Invariance`, perturbing the fixed `dist(2)` coordinate
  gives a replay error instead, and the support certificate behaves the same way.

Gates run at this commit, all passing:

```text
cargo fmt --check
cargo clippy -p ergodis-rules -p ergodis-verify -p ergodis-runtime --all-targets -- -D warnings
cargo test -p ergodis-rules -p ergodis-verify -p ergodis-runtime   # 99 passed, 0 failed
```

## D4 — stability and annihilation

Commit `22160e1` "State and gate the algebra laws the checkers rely on" (plus the
`composition_graph::verify` gate, which landed in `7cc7abe`).

`TransitionWeight` now documents the complete list of laws the checkers depend on:
associativity, commutativity and idempotence of the alternative with unit zero;
associativity, both-sided distributivity and unit one for composition; annihilation
`zero * x = x * zero = zero`; the two `minus` laws; the canonical codec; and the
`Stability::Uniform(0)` plus idempotence declaration the round caps assume.

The annihilation entry states exactly why the rule skip in
`composition_graph::propagate` is valid: when both factors of a rule have zero delta the
semi-naive contribution `dl * r + (l + dl) * dr` reduces to `zero`, which the running
alternative absorbs, so skipping the rule computes the same round. Without annihilation the
skip would drop a contribution and the replay could accept a valuation below the least
solution. The same reason is repeated as an inline comment at the skip itself.

Monomorphization gates (`const { assert!(...) }` requiring
`W::PROPERTIES.stability == Stability::Uniform(0)` and `W::PROPERTIES.idempotent`, each
with a comment naming the bound that depends on it):

- `composition_graph::verify` — the round cap and the rule skip.
- `support::check` — absorption as the information order, and leastness from well-founded
  support.
- `crates/rules/src/lib.rs`: a `kernel_laws::<W>()` const function invoked from
  `Prepared::new` for both admitted carriers and from `derive_support::<W>`.

Law tests: `crates/verify/tests/weight_properties.rs` (PROP-TEST 17), 512 cases each over
random triples of both carriers, with zero, one and the near-saturation band oversampled.
It checks the full conjunction above plus both semi-naive round identities, the
zero-delta contribution, and `decode` returning `None` for every wrong length and for the
noncanonical Boolean byte. The saturation property (PROP-TEST 16 / review P4 at the
carrier level) compares `BoundedMinPlus::times` against an exact `u128` sum clamped at
`u32::MAX` and checks that the sentinel is absorbing; `proptest` was added as a
dev-dependency of `ergodis-verify`, which did not have one.

Gates run at this commit, all passing:

```text
cargo fmt --check
cargo clippy -p ergodis-rules -p ergodis-verify -p ergodis-runtime --all-targets -- -D warnings
cargo test -p ergodis-rules -p ergodis-verify -p ergodis-runtime   # 102 passed, 0 failed
```

## D5 — incremental source identity

Commits `88cd0f9` "Rebind the grounding instead of rebuilding it for a fact update" and
`1d7d135` "Measure where the per-update cost of a recursive query goes".

The SHA-256 identity definition is unchanged: it is still the hash of the schema name
followed by the compact serde serialization of the typed `Program`, exactly as `ground`
computes it. The verifier re-hashes the caller's source, so the producer could not change
the definition even if it wanted to. What changed is how the producer arrives at the same
bytes.

`Grounded` now carries a private `FactStream`: the SHA-256 midstate after the schema name
and every byte up to the start of the `facts` array, plus the bytes that follow it. The
split is validated at construction against the full serialization — the marker `,"facts":`
is located in the encoded program, the facts array is required to sit immediately after it
byte for byte, and if the serializer ever produced a different layout the stream is simply
absent and the caller re-hashes in full. `Grounded::rebind` uses it: it copies the input
vector with one slot replaced, rechecks every declared symmetry against the input vector
alone (the products are unchanged, so the multiset half of the admission check cannot have
changed), and streams the identity. `Grounded::products` became an `Arc<[ProductRule]>`, so
a rebound grounding shares the product array rather than copying it, and
`Grounded::shares_products` turns the ordered-equations check in `Prepared::update_into`
into a pointer comparison.

`Prepared::with_fact` now calls `rebind` and patches one slot of the lifted kernel vector
instead of re-lifting, while continuing to share the compiled user index. The midstate
approach was clean, so no full-hashing fallback is used on the normal path.

`crates/rules/tests/contract_properties.rs::streamed_identity_matches_full_grounding`
(new) generates a program and one to six random updates, each either a new cost or a
removal, and after every step asserts that the streamed `source_id` equals the one a full
`ground` of the live source computes, that the round bound matches, that every input slot
matches, and that the certificate verifies against the naive oracle.

### Measurement

`crates/runtime/tests/update_cost.rs`, run as

```text
cargo test -p ergodis-runtime --release --test update_cost -- --ignored --nocapture
```

200 updates to one edge of a unit-cost ring with all chords at cost 1,000, mean nanoseconds
per update, one host, release profile, no pinning:

| Stage                                        | domain 16 | domain 24 | domain 32 |
| -------------------------------------------- | --------: | --------: | --------: |
| `RecursiveQuery::replace`, end to end        |    36,274 |    76,559 |   138,641 |
| `with_fact`: source clone, rebind, identity  |    26,409 |    54,808 |    93,421 |
| control: full `ground` of the updated source |    43,625 |    95,611 |   169,740 |
| control: `Program` clone alone               |     7,617 |    16,550 |    29,001 |
| control: facts-array serialization alone     |     8,172 |    17,925 |    31,492 |
| `Workspace::clone`                           |       275 |       357 |       448 |
| producer `update_into`                       |     1,281 |     2,767 |     4,750 |
| `current_certificate`                        |        82 |        95 |       118 |
| `checked.clone` + `replace_input`            |     5,234 |    15,288 |    34,038 |
| certificate serialization                    |     1,464 |     2,606 |     4,373 |

Read straight off the table, and stated as measured rather than as a claimed speedup:

- The rebind roughly halves the stage it replaced — at domain 32, 93.4 microseconds against
  a 169.7-microsecond full re-grounding control — because it no longer regrounds the rules
  into products, re-serializes the whole program, or re-hashes it.
- It does not change which stage dominates. At domain 32 the identity path is still 67
  percent of the end-to-end update, and roughly two thirds of that is irreducible under the
  current identity definition and API: 29.0 microseconds to clone the typed `Program`
  (`Prepared` owns its source) plus 31.5 microseconds to serialize the 1,025-fact array,
  which the identity is defined over.
- So the answer to the question the brief poses is no: the API cost floor is **not** the
  independent checker. The checker's dense per-round rule scans are the second largest
  stage (34.0 microseconds at domain 32, 25 percent), and the producer kernel the C1161
  work sped up 15x is 4.75 microseconds, 3.4 percent of the update. Review item R13's
  conclusion — that the kernel speedup does not survive to the API — still holds after this
  change, with the identity path rather than the checker as the reason.
- Getting further would need the identity definition or the `Prepared`-owns-its-source
  API to change, not more incremental grounding. Both are out of C1176's scope (D1 fixes
  the wire schemas, and the identity definition is deliberately the verifier's).

Gates run at commit `88cd0f9` and again at `1d7d135`, all passing:

```text
cargo fmt --check
cargo clippy -p ergodis-rules -p ergodis-verify -p ergodis-runtime --all-targets -- -D warnings
cargo test -p ergodis-rules -p ergodis-verify -p ergodis-runtime   # 107 passed, 0 failed
```

## D6 — dense negative control

Commit `759a899` "Add the dense negative control the frontier measurement was missing".

The fixture builders moved from `crates/rules/examples/replay_profile.rs` into
`crates/rules/tests/support/density.rs`, which both the example and a new test include by
path, and a third density mode `competitive` was added: the forward half of the complete
graph on `domain` vertices, edge `(x, y)` for `x < y` at cost `3^min(y - x, 20)`. The cost
is strictly convex in hop length, so for every `y` the best `k+1`-hop path beats the best
`k`-hop path for every `k < y` and coordinate `y` improves in each of the first `y` rounds.
Backward edges are omitted rather than given cost `u32::MAX - 1`: at this cost scale they
can never improve anything, so keeping them would inflate the frontier's work without
changing a result. The least distances are `3y`.

The example gained the in-example contiguous full-scan evaluator — plain synchronous Kleene
over every grounded product each round, two buffers, no frontier and no dependency index —
selected by an optional fifth argument that defaults to `frontier`, so the existing
four-argument invocation in `python/benchmark_rule_replay.py` is unaffected.

`crates/rules/tests/density_control.rs` holds three tests:

- at least half of the `dist` coordinates change in each of the first `domain / 2` rounds
  of the competitive fixture at domains 8, 16 and 32, measured by an independent naive
  Kleene iteration rather than by the producer;
- the ring fixtures by contrast have exactly one changing coordinate per round after the
  first wave, which is why neither was ever a negative control;
- the full-scan control and the frontier producer agree on the least solution and on the
  round count for all three fixtures at three domains, so an A/B between them measures the
  frontier and nothing else.

### The A/B

Generator `python/benchmark_rule_frontier_control.py`, domain 32, one worker, 2,000 warm
evaluations per run, seven paired rounds with arms alternating and fixture order rotating,
CPUs pinned to 20–23. Each evaluation takes 32 rounds under both arms against an admitted
round bound of 33.

| Fixture                  |    Frontier vs full scan | Frontier median, ms | Full scan median, ms | Frontier visits | Full scan visits | Paired log-ratio t |
| ------------------------ | -----------------------: | ------------------: | -------------------: | --------------: | ---------------: | -----------------: |
| Sparse ring              |             8.29x faster |                6.42 |                55.77 |           1,055 |           32,768 |               81.5 |
| Dense weighted ring      |             2.66x faster |               18.46 |                49.16 |           2,976 |           32,768 |               97.4 |
| Competitive complete DAG | 0.62x, i.e. 1.62x slower |               77.48 |                47.94 |          16,369 |           32,768 |             -112.8 |

The negative control lands: on the competitive fixture the frontier visits half as many
products as the full scan and is still 1.62 times slower, so on a persistently dense
frontier the per-visit cost of the dependency index, the round marks and the scattered
writes exceeds the cost of a contiguous scan by more than the visits it saves. The frontier
is a policy choice, not a free win, and the review's RISK-6 ("no measurement supporting the
frontier as a default") is now answered with a measurement rather than an argument.

Evidence bundle `evidence/2026-09-13-rule-frontier-negative-control.{md,json}`, following
the layout of the existing `2026-09-12-rule-frontier*` files: the JSON carries the schema
string, the run parameters, the generator and executable SHA-256 hashes, all 42 raw samples
and the three summaries. The executable is recorded by a portable label, never an absolute
path. `SHA256SUMS` regenerated with `python/generate_evidence.py --write`.

Gates run at this commit, all passing:

```text
cargo fmt --check
cargo clippy -p ergodis-rules -p ergodis-verify -p ergodis-runtime --all-targets -- -D warnings
cargo test -p ergodis-rules -p ergodis-verify -p ergodis-runtime   # 113 passed, 0 failed
cargo test --test evidence_manifest                                # 2 passed, 0 failed
scripts/public-lint.sh evidence                                    # clean
```

## D7 — documentation agreement

Doc edits landed inside each item's own commit, plus commit `0b17cf4` "Name the sharpness
development without restating it". Every statement in `docs/rule-contract.md` that D2–D6
touched was rewritten so the document, the code and the tests agree:

- The grounding section now records `round_bound = min(N, M + 1)` alongside the scalar
  bound N, and names the four-vertex example's drop from 21 to 5.
- The carriers section states the full law list, the annihilation reason for the rule skip,
  and the `const` gates.
- The symmetry paragraph says that accepted permutations are now spent: `verify` and
  `verify_support` check invariance and refuse with `Error::Invariance`.
- The evaluation section caps the producer's scans at `min(N, M + 1)` and calls the
  post-loop refusal unreachable for an admitted source.
- The certificate section says what `rounds` means and which writer writes which value.
- The verification section states the admission check, why `Budget` from replay is
  reachable only for a false claim (with the Lean theorems named), how the measured scan
  count is exposed without a wire field, and why one `round_bound` stays valid for every
  later input of a `RecursiveQuery`.
- The incremental paragraph says `min(N, M + 1)` rather than "the scalar bound N".
- The test paragraph lists the new generated coverage, and a new paragraph points at the
  negative-control evidence bundle.

No counts that go stale (test counts, line counts) were put in the documentation.

One statement outside `docs/rule-contract.md` also had to change.
`docs/summary-transitions.md` claimed "The producer counts that final scan, so its reported
round count is one more than the checker needs." That is wrong, and D2 made it wrong in a
newly visible way by exposing `VerifiedGraph::rounds`. The producer's count and the least
budget the checker accepts are equal for the same instance — the producer's last sweep is
the one that changes nothing and the checker's last scan is the one that empties the delta
— and `round_bound_is_sharp_and_the_two_evaluators_agree` now pins it. The sentence was
replaced with the correct one. This is the review's RISK-1 statement, whose repair was
pegged to C1172 as item R4; flagging it here because the correction is one sentence and
leaving a contradiction next to a newly documented accessor would have been worse.

## Property tests

Nine properties from the review's PROP-TEST catalogue, in three files.

`crates/rules/tests/contract_properties.rs` (256 cases each unless noted; generators are
deliberately self-contained rather than shared with `properties.rs`, which installs a
counting global allocator that would otherwise measure these programs too):

| Property                                            | Review item  | What it pins                                                                                                                                                                                                                                       |
| --------------------------------------------------- | ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `round_bound_is_sharp_and_the_two_evaluators_agree` | PROP-TEST 5  | On a path of `length` unit edges the producer converges in `length + 1` sweeps, the replay accepts exactly that budget and refuses `length` with `Budget`, the replay's own scan count equals it, and `round_bound` is `min(d^2 + d + 1, d + 1)`.  |
| `the_rounds_field_is_an_admitted_budget`            | PROP-TEST 10 | Verification succeeds for exactly the claims between the true convergence round and `round_bound`; above `round_bound` the answer is `Budget`, below the true round it is a replay error, and every accepted claim yields the same measured count. |
| `certificates_do_not_transplant_between_sources`    | PROP-TEST 9  | Two programs differing in one fact cost have equal scalar counts and different identities, neither accepts the other's certificate, and a JSON round trip still verifies.                                                                          |
| `declared_symmetry_permutes_the_certified_values`   | PROP-TEST 6  | See D3 above.                                                                                                                                                                                                                                      |
| `the_saturating_carrier_boundary_is_consistent`     | PROP-TEST 16 | With costs drawn from `u32::MAX/2 ..= u32::MAX` the sparse producer, an exact `u128` oracle with an explicit clamp, and the verifier agree; improving one fact only lowers coordinates.                                                            |
| `streamed_identity_matches_full_grounding`          | D5           | See D5 above.                                                                                                                                                                                                                                      |

`crates/runtime/tests/update_properties.rs` (128 cases each):

| Property                                           | Review item | What it pins                                                                                                                                                                                                                                                                                                                                                                                    |
| -------------------------------------------------- | ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `replacement_sequence_equals_fresh_verification`   | PROP-TEST 2 | One to eight replacements drawn to hit improvement, retraction, removal and no-op leave the query in the state a single fresh from-zero verification of the final source produces; the sequence counter counts exactly the accepted replacements; each snapshot's emitted bound verifies and its measured replay never exceeds it; each reported `UpdateKind` matches the comparison it claims. |
| `retract_then_reassert_is_the_identity`            | PROP-TEST 3 | Worsening a fact and restoring it returns a bit-identical valuation, with a verifying certificate at both steps. This is the deterministic driver for both branches of `update_into` and `replace_input`.                                                                                                                                                                                       |
| `rejected_update_preserves_every_held_observation` | PROP-TEST 4 | A request corrupted in exactly one of its six fields is refused and leaves source identity, sequence, values and the whole snapshot unchanged, and the query is still live afterwards.                                                                                                                                                                                                          |

`crates/verify/tests/weight_properties.rs` (512 cases each; `proptest` added as a
dev-dependency of `ergodis-verify`, which had none):

| Property                                             | Review item              | What it pins                                                                                         |
| ---------------------------------------------------- | ------------------------ | ---------------------------------------------------------------------------------------------------- |
| `bounded_min_plus_satisfies_the_admitted_laws`       | PROP-TEST 17             | Every law listed in D4, over random triples with zero, one and the near-saturation band oversampled. |
| `boolean_satisfies_the_admitted_laws`                | PROP-TEST 17             | The same conjunction over the Boolean carrier, plus rejection of the noncanonical byte.              |
| `saturating_composition_matches_a_clamped_exact_sum` | PROP-TEST 16 / review P4 | `times` against an exact `u128` sum clamped at `u32::MAX`, and the sentinel as absorbing.            |

One regression seed was retained,
`crates/rules/tests/contract_properties.proptest-regressions`: removing a fact and then
re-adding it, which is the case that first exercised `with_fact` on an emptied fact list.

## Measurements

Both measurement tables are above: the per-update cost split under D5 and the
frontier-versus-full-scan A/B under D6. Neither claims a speedup that was not measured, and
the D6 table reports a loss on its third row.

## Final gates

Run at HEAD (`0b17cf4`), all passing:

```text
cargo fmt --check
cargo clippy -p ergodis-rules -p ergodis-verify -p ergodis-runtime --all-targets -- -D warnings
cargo test -p ergodis-rules -p ergodis-verify -p ergodis-runtime    # 113 passed, 0 failed
cargo test                                                          # 815 passed, 0 failed
cargo test --test evidence_manifest                                 # 2 passed, 0 failed
scripts/public-lint.sh evidence                                     # clean
python3 crates/rules/tests/native_abi.py <target>/release/libergodis_rules.so <cache>/native.json
  -> "native C ABI: 129 min-plus programs, one Boolean closure, independent oracle,
      source/claim/handle/capacity lifecycle gates passed"
nix shell nixpkgs#lld --command bash -c "RUSTFLAGS='-C linker=wasm-ld' \
  cargo build -p ergodis-rules --release --target wasm32-unknown-unknown"   # built
node crates/rules/tests/wasm_abi.mjs <target>/wasm32-unknown-unknown/release/ergodis_rules.wasm \
  <cache>/native.json
  -> "WASM existing module host: 129 programs, native certificate and Python oracle
      parity, lifecycle gates passed"
```

The WASM arm turned out to be quick (a cached `nix shell` plus a five-second build), so it
was run rather than skipped.

### One build hazard, not a test failure

`cargo test` over the default members failed three times in a row with five `E0599`
errors — `no method named round_bound found for struct Grounded` — while
`cargo test -p ergodis-rules -p ergodis-verify -p ergodis-runtime` passed on the same tree.
The build log shows `ergodis-rules` compiling before `ergodis-verify`, so a stale
`ergodis-verify` rlib was being linked. Touching `crates/verify/src/lib.rs` cleared it and
`cargo test` has passed twice since. The cause is the shared out-of-tree target directory
in `.cargo/config.toml` (`~/.cache/ergodis/target/ergodis`) being written concurrently by
another checkout of the same workspace — there are six other live git worktrees of this
repository, including the one holding the concurrent property-test branch. This is a
foreign-work interaction, not a defect in the C1176 changes, but it is worth raising: any
two agents building this repository at once can hand each other a stale dependency, and the
symptom looks exactly like a broken commit.

## What is not done and why

1. **No wire field for the measured round count.** D1 fixes the schemas, so `Verified::rounds`
   is an in-process observation only. A reader of a serialized certificate still learns the
   claimed bound, not the sharp count. The review's EXT-1 wanted both on the wire; that
   needs a schema version and was explicitly ruled out.
2. **The incremental identity is faster but not cheap.** `with_fact` still clones the typed
   `Program` and serializes its whole facts array, because `Prepared` owns its source and
   the identity is defined over that array. The measurement above quantifies both. Going
   further means changing the identity definition or the ownership model, neither of which
   is in scope.
3. **No evaluator selection policy.** D6 establishes that a dense-frontier workload exists
   and that the frontier loses on it. It does not locate the crossover, which lies
   somewhere between 93 and 512 visited products per round out of 1,024, and it does not
   propose a rule for choosing an evaluator.
4. **`exact_carrier` is still only declared, never read by an algorithm.** D4 gave it a
   generated property and a documented meaning, but nothing gates on it. The review's
   observation that it is "the contract's single declared precondition with no consumer"
   is now half answered: it has a test, not a consumer.
5. **`Stability::Uniform(p)` for `p > 0` is rejected at compile time, not supported.** The
   gates make the wrong bound a build failure rather than deriving the bound from `p`.
   EXT-3 suggested the derivation as the better option; that is a carrier-admission change
   and would need its own Lean statement.

## Open questions for the reviewer

1. Should `Prepared` stop owning a full `Program` and hold the facts separately from the
   rules, so that a fact update neither clones nor re-serializes the rule list? That is the
   only remaining lever on the per-update cost that does not touch the identity definition,
   and the measurement says it is worth roughly a third of the update.
2. `round_bound = min(N, M + 1)` is now the admitted maximum. Should the runtime writers
   claim it, as they do, or claim the sharp measured count from the most recent cold
   evaluation plus a proof obligation that later inputs cannot be slower? The current
   choice is the safe one and is what makes the retained `VerifiedGraph` budget reusable.
3. The negative control is a complete DAG with convex hop costs. Is that the workload shape
   worth retaining as the standing negative control, or should it be a cyclic graph, which
   would also exercise the retraction restart path under a dense frontier?
4. Should `Error::Invariance` be distinguishable on the wire from a replay failure for
   consumers of the C ABI, which currently collapses every rule-contract error to one
   `INVALID` code?

## Remaining core property tests (second sub-agent)

The six review properties outside the semantics items (PROP-TEST 7, 8, 12, 13, 14, 15:
grammar totality, provider ABI totality, lineage fork depth and origin toggle, parallel
versus serial allocation surfaces, lowering synthesis completeness) were written on the
branch `task/c1176-properties` and are reported separately in
`2026-09-13-c1176-core-properties.md`. They were cherry-picked onto core `main` as
`709d6c5`, `8672d0b`, `4243381`, `a77a81f`, `9fc5a55`, with the manifest refreshed in
`2074025`. The allocation-surface test carries `required-features = ["parallel"]`, so a
plain `cargo test` skips it; run it with `--features parallel`.

## Independent audit (parent session)

Both sub-agents' diffs were read in full against the settled decisions, and every gate was
rerun on the merged tree from a clean state rather than trusted from the reports:

```text
cargo fmt --check                                                  # clean
cargo clippy --all-targets -- -D warnings                          # clean
cargo clippy --all-targets --features parallel -- -D warnings      # clean
cargo test --workspace                                             # 76 test binaries, all ok
cargo test --features parallel --test allocation_surface_properties # ok
scripts/public-lint.sh evidence                                    # clean
python3 python/generate_evidence.py --check                        # clean
```

Points checked by hand and found sound:

- `Grounded::rebind` reproduces the identity `ground` defines: the `,"facts":` marker cannot
  occur inside any string field because every string in an admitted program is a validated
  identifier or a fixed schema/carrier name, and the split is verified byte for byte against
  the facts serialization at construction. A misuse of the public `rebind` obligation
  yields a certificate the verifier refuses, never one it accepts.
- The invariance check runs after the binding check, so the permutation indices are in
  range, and before replay, so an orbit-breaking claim is refused with `Invariance`.
- The producer's loop cap `min(N, M+1)` applies to the Boolean carrier's min-plus lift
  unchanged, since the lift preserves the grounding's shape.
- The incremental sweep count is bounded by the same cap in the code path itself, so the
  runtime replacement property would fail with `Budget` if a warm start ever exceeded it.
- The competitive fixture's per-hop convexity is capped at exponent 20, so the "improves in
  each of the first `y` rounds" statement is only checked, not proved, for `y > 20`; the
  test asserts the property the A/B needs (at least half the outputs change in each of the
  first `domain/2` rounds at domains 8, 16 and 32), which is the claim the evidence uses.

Two observations for the lane, neither a defect in this task: the shared Cargo target
directory in `.cargo/config.toml` produced one stale-rlib build failure while two checkouts
built concurrently, and the evidence generator rewrites tracked `__pycache__` files, which
were left modified in the `c1176-props` worktree under `~/.cache/ergodis/worktrees/`
rather than discarded.

## Closeout pass (`ej` + `tt`)

- **Cheap upgrade taken**: none beyond the items above; the merged suite and docs agree and
  no wire schema moved.
- **Symmetry declarations can now pay for themselves.** With invariance checked, the
  replay only needs orbit representatives: the checker could replay the quotient system and
  extend by invariance, dividing checking cost by the orbit size. That is the first real
  use of the symmetry payload and is logged on the discovery track, not allocated.
- **A frontier-density switch is the obvious evaluator policy.** The frontier's per-visit
  overhead is roughly 2x a contiguous scan's, so a per-round rule "full scan when the
  active set exceeds about half the outputs" is a two-line heuristic; the crossover sweep
  the fixture module makes cheap would calibrate it. Successor material for whoever owns
  evaluator policy, not done here.
- **The identity cost floor is a design decision for Tavis.** Getting `replace` below the
  facts-serialization floor needs a tree-structured identity (a schema change) or a
  `Prepared` that holds facts apart from rules; both are out of this task's remit.

## Mystery ledger

1. **The frontier loses while visiting half as many products.** On the competitive fixture
   the frontier visits 16,369 products per evaluation against the full scan's 32,768, and
   is still 1.62 times slower. Settled as a measurement, not as a mechanism: the per-visit
   cost of the dependency index, the round marks and the scattered writes must exceed a
   contiguous scan's per-product cost by more than 2x, but nothing here separates the
   indirection from the branch misprediction or the cache behaviour. Evidence gap: no
   hardware counters were collected for this A/B, unlike the C1161 bundle which used
   `perf`. Owning successor: whoever decides evaluator policy.
2. **The crossover density is unlocated.** Three points — 33, 93 and 512 improving products
   per round out of 1,024 — bracket it but do not find it. Settled only to the extent that
   it lies between the dense ring and the competitive graph. Evidence gap: a density sweep,
   which the fixture module now makes cheap to write.
3. **`round_bound` is startlingly tight on the shipped fixtures.** For every distance
   program the bound is `domain + 1` and the measured count is `domain`, off by exactly one
   in every case tested, because there is one relation whose slots are all outputs. The
   `ej` pass settled why: `M + 1` counts distinct product outputs plus the fixedness scan,
   and a chain reaching every output uses all of them. It is not tight in general — the
   `min` with N binds instead whenever a program has more relations than derivation depth.
   No gap; recorded because the bound looked suspiciously exact.
4. **Nothing in the admitted source language can force the producer's
   `Err(Error::Budget)`.** After D2 the producer's loop bound equals the proven convergence
   bound, so the branch is dead for every admitted source, and no generated program in any
   property has reached it. Settled as far as the Lean statements go; the residual gap is
   that the Rust grounding is not itself formally verified, so the branch stays as the
   loop's only unchecked exit. No successor needed.
5. **The stale-rlib build failure described above.** Settled as a shared-target-directory
   race, not a code defect: the same tree passes after a touch and has passed twice since.
   Evidence gap: it was not reproduced deliberately, so the exact interleaving that
   produces it is unknown. Owning successor: whoever owns the build-directory policy in
   `.cargo/config.toml`, since the fix is a per-worktree target directory or a build lock,
   and both are outside this lane.
