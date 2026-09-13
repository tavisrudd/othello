# C1174 — generic carrier convergence and the Boolean carrier

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: COMPLETE. Closes E2 and E3 of
`2026-09-12-c1171-rule-programme-review.md`.

## Verdict

1. **The convergence layer is now carrier-generic.**
   `lean/WeightedRules/OrderedConvergence.lean` defines an *ordered
   inflationary* algebra: an idempotent semiring `A` on a `LinearOrder`
   carrier with `A.add a b = min a b`, `a ≤ A.mul a b` and `b ≤ A.mul a b`
   (`WeightedRules.OrderedInflationary`, a `Prop`-valued structure). For every
   such algebra and every grounded program on `n` coordinates,
   `OrderedInflationary.iterate_fixed` proves fixedness after `n` rounds,
   `OrderedInflationary.rule_output_fixed` after `min n (m + 1)` rounds over
   `m` distinct rule outputs, with the certificate constructions and leastness
   theorems (`certificate`, `iterate_least`, `ruleOutputCertificate`,
   `rule_output_least`). The proof is the C1165/C1168 counting argument with
   every `.val`/`omega` step replaced by linear-order reasoning; no finiteness
   of the carrier and no comparison minus is assumed. `ruleOutputs` and
   `ruleOutputBound` moved into this module unchanged.
2. **The min-plus statements are unchanged and are now corollaries.**
   `Convergence.lean` proves `boundedMinPlus_orderedInflationary` and derives
   every public theorem of C1165 (`boundedMinPlus_iterate_succ_cost`,
   `boundedMinPlus_step_improvement`, `boundedMinPlus_improvement_round_le`,
   `boundedMinPlus_iterate_fixed`, `boundedMinPlus_iterate_add`,
   `boundedMinPlusCertificate`, `boundedMinPlus_iterate_least`) and of C1168
   (`boundedMinPlus_rule_output_fixed`, `ruleOutputCertificate`,
   `boundedMinPlus_rule_output_least`) with identical statements, bridging
   the numerical forms through `Fin.le_def`/`Fin.lt_def`. Every downstream
   module (reflection, sharpness, incremental, support, round-convention and
   the oracle examples) builds unchanged. The existing audits pass with one
   expected-message change: `boundedMinPlus_step_improvement`, now an
   instance of the generic linear-order proof, acquires `Classical.choice`
   (from Mathlib's order lemmas) alongside `propext` and `Quot.sound`; the
   other min-plus terminals keep their recorded sets.
3. **The Boolean carrier is a second Lean instance.** `BooleanRules.lean`
   defines `booleanRules : ScalarAlgebra Bool` (or/and), its zero-stability
   and comparison minus, and proves `booleanRules_orderedInflationary` at
   `W := Boolᵒᵈ` (the order `true < false`); `booleanRules_iterate_fixed`,
   `booleanRules_iterate_least` and `booleanRules_rule_output_least` follow
   by instantiation. A three-vertex transitive closure (19 coordinates, 36
   products) is kernel-checked in three rounds (`closureCertificate`,
   `closure_least`, `closure_values`).
4. **The Boolean carrier is the image of min-plus under an exact lift.**
   `boolLift : true ↦ 0, false ↦ infinity` is a semiring homomorphism
   (`boolLift_add`, `boolLift_mul`), and `boolLift_iterate` proves
   `iterate boundedMinPlus (liftProgram P) k = boolLift ∘ iterate booleanRules P k`
   for every round `k`. This is the theorem behind the producer design in
   item 5: the min-plus kernel evaluates a Boolean source exactly, with the
   same round count, and no hot loop changes.
5. **The Rust contract admits `semiring: "boolean"`.** In
   `crates/verify/src/rule_contract.rs` a `Carrier` enum and a `WireValue`
   trait (implemented for `BoundedMinPlus` and `weight::Boolean`) make
   grounding carrier-aware: facts are values in the carrier's wire encoding
   (`0`/`1` for Boolean, any other value refused with the new
   `Error::Encoding`), duplicates combine by the carrier's alternative, and
   the unit slot holds the carrier's one. `verify` returns a `Verified` enum
   and replays over the declared carrier through the generic
   `composition_graph::verify::<W>`; Boolean certificates carry
   `finite-boolean-certificate.v1`, support certificates
   `finite-boolean-support-certificate.v1`, and a min-plus-labelled
   certificate for a Boolean source is refused before replay. The support
   checker (`support.rs`) is now generic over `TransitionWeight`, using
   absorption `a + v = v` in place of numerical comparison, so one
   implementation serves both carriers; the Lean `Support` proof was already
   stated for every algebra with decidable equality.
6. **The producer runs Boolean sources on the min-plus kernel.**
   `Prepared` holds the lifted inputs; `evaluate_into`, `update_into` and
   `with_fact` use them, and `current_certificate`, `wire_values` and
   `support_certificate` decode `infinity ↦ 0`, otherwise `1`. The
   `propagate` loop is untouched. The provider descriptor lists both
   carriers with their certificate formats under `semirings`; the recursive
   incremental runtime (`crates/runtime/src/recursive.rs`) admits min-plus
   sources only and rejects Boolean ones with `Error::Schema`.
7. **Benchmark rows.** `crates/rules/tests/closure.json` (transitive closure
   over a five-vertex graph with the cycle `1 → 2 → 3 → 1` and an explicit
   absent fact) and `crates/rules/tests/same_generation.json` (same
   generation over a seven-node tree, with the standard three-atom recursive
   rule split through a helper relation `up` to fit the two-atom, three-variable
   rule admission) are checked end to end in `tests/boolean.rs`: producer
   values against a naive Boolean oracle, sharp round count, every value flip
   rejected by Boolean replay, encoding and cross-carrier rejection, the
   min-plus lift agreeing coordinate-wise with the same round count, support
   certificates with witness mutations rejected, and incremental add/remove
   of an edge with the fresh solution. The current admission limits (domain
   at most 32, at most three variables per rule) size these as fixtures, not
   as the step-5 benchmark suite, which remains gated on the concrete
   workload.
8. **Generic-carrier replay properties** (`tests/properties.rs`, 512 cases
   each): over generated Boolean programs the producer equals naive Boolean
   iteration with no allocation in the loop, the generic Boolean replay
   accepts the certificate at its round count and returns `Budget` one round
   earlier, the round count respects both structural bounds, the support
   certificate checks, and the min-plus lift decodes to the same valuation
   with the same round count; every single value flip is rejected.

## Design decision: kernel reuse rather than a generic hot loop

Two routes were available for the producer: monomorphize `propagate` over a
carrier trait, or evaluate the Boolean lift on the existing kernel. The lift
is exact (`boolLift_iterate`), costs nothing in the hot loop, and keeps the
C1161/C1167 performance evidence pinned to an unchanged kernel; a generic
loop would have required the PERFORMANCE.md before/after profile and
counter A/B for a change whose Boolean instantiation would compile to the
same instructions. The lift also makes the "one parameter away" observation
of the review literal: a Boolean program is the min-plus program whose facts
are `0` or `infinity`. The verifier deliberately does not use the lift, so the
Boolean certificate is checked by a different carrier implementation than the
one that produced it.

## Validation

| Gate | Result |
|---|---|
| `guarded-lean` on `OrderedConvergence`, `Convergence`, `OutputConvergence`, `BooleanRules`, `OrderedConvergenceAxiomAudit` | pass |
| Queue build of root `WeightedRules` (all audits, round-convention and support families, live oracle examples against the rebuilt native library) | pass (run `20260913-162727-250d2282`, after run `20260913-162347-207a8e29` exposed the one audit-message change above) |
| `cargo fmt --check` (Nix rustfmt 1.9.0), `cargo clippy --all-targets --all-features -- -D warnings` | clean |
| `cargo test --all-features` (whole core workspace) | pass, every workspace suite |
| `scripts/public-lint.sh crates`, `docs` | clean |
| Native ABI gate `native_abi.py` (the min-plus oracle programs plus the Boolean closure through selectors 1–4) | pass |
| WASM release build of `ergodis-rules` | pass (Nix `lld`) |

Axiom audit: the generic terminals and the Boolean convergence theorems use
`propext`, `Classical.choice`, `Quot.sound` (Finset cardinality);
`boundedMinPlus_orderedInflationary` and `boolLift_iterate` use `propext`,
`Quot.sound`; `booleanRules_orderedInflationary` uses `propext`;
`booleanRules_zero_stable` and `booleanMinus` use none. No `sorryAx`, native
decision or external process axiom appears.

## Reproducibility bundle

| File | SHA-256 |
|---|---|
| `lean/WeightedRules/OrderedConvergence.lean` | `c686681852e85e0db2bfc2bb1eed35c6846e88e60b2daf32fd8ede2c2ef776c2` |
| `lean/WeightedRules/Convergence.lean` | `d4cc75148dd2256f0cac26b211f52b7beb9d1148e694d7bf8c65386a7a6360ac` |
| `lean/WeightedRules/OutputConvergence.lean` | `53f23f97e1dc1916ba8fb90bfe554089381dbefe5e23ab7c5d89d1b0653308b2` |
| `lean/WeightedRules/BooleanRules.lean` | `a1ab2599a81e6783cc3f22b2e2b02123a9fa2dfdbe3f77ccb6e759822258a674` |
| `lean/WeightedRules/OrderedConvergenceAxiomAudit.lean` | `b2eafb18931bdb3899c1b840ecca0d3556acf8c64e9d0a9a6554df51db7f0aee` |
| `lean/WeightedRules/OutputConvergenceAxiomAudit.lean` | `f8517acf6098c168394f03a4d154b0b5e99366073d60d76df34b53305176fa95` |
| `ergodis/crates/verify/src/rule_contract.rs` | `498cc8f673ff3f826456e46520be60281e5ac88a9fd82b431d5f774c66a86d39` |
| `ergodis/crates/verify/src/support.rs` | `2ab011d3578a626cd87d85c8ac15d9fea7766de36681c44f5ca735a6ee74ff58` |
| `ergodis/crates/rules/src/lib.rs` | `6745ca2903be2a82222ba41872b86b1f4a69c2eee1a9c7f98475c4ccf8b8d442` |
| `ergodis/crates/rules/tests/boolean.rs` | `7852288fc027394ecd32ed54c496420f96dc7d4e705333267f812050b2dafc01` |
| `ergodis/crates/rules/tests/properties.rs` | `c2043c1928f36943e61fc58f6b2facd86ccecda60491d52c00b895c99b15844c` |
| `ergodis/crates/rules/tests/closure.json` | `993b9a1507a4da2bbf9c6cca56978e5f635382271aaee2b26967c6a2a1e69f78` |
| `ergodis/crates/rules/tests/same_generation.json` | `07276e9f47b135f14980ce19618e3721b5811eb2b069afda34f648fd2b87e447` |
| `ergodis/crates/rules/tests/native_abi.py` | `2b4acdd957d8e6190942eed5a04669947b59d1b6d5c0e1766559360d52090d16` |

Replay: the Lean commands are `lean/scripts/guarded-lean` on each module and
`lean/scripts/lean-build-queue.py build WeightedRules --cores 20-23` with
`ERGODIS_RULE_LIBRARY` pointing at the release `libergodis_rules.so`; the
Rust commands are those in the validation table from the core repository root.
The independent replay of every Lean certificate is the kernel; the
independent replay of every Rust certificate is the verifier's carrier-typed
semi-naive replay and, for the fixtures, the naive Boolean oracle in the tests.

## Not done, and why

- The reflective checker `checkCertificate`, `CheckedSolution`, the oracle
  elaborator and the incremental modules remain bounded-min-plus specific.
  Generalizing them is a separate change touching the oracle fixture family;
  the Boolean instance is certified in Lean through the generic `Certificate`
  structure and `decide`, not through the external oracle.
- The WASM ABI gate (`wasm_abi.mjs`) was not rerun; the WASM release build
  was checked. C1175's release hygiene owns the rerun.
- Bounded max-min and max-times carriers are covered by the generic theorem
  but have no Rust weight implementation; adding one is a `WireValue`
  implementation plus a fixture, and no benchmark row needs them yet.
- Under the Nix `rustfmt` 1.9.0, HEAD `eead07b` was not format-clean in one
  line of `crates/rules/examples/lean_boundary_fixtures.rs`; the C1173 check
  used a different rustfmt. This commit reformats that line. Pin the
  formatter in C1175.

## Mystery ledger — ej + tt

- **Is the Boolean carrier a genuine second instance or a disguised
  min-plus?** Both, and that is the point: the generic theorem proves its
  bounds directly, and `boolLift_iterate` proves the producer's reuse of the
  min-plus kernel exact. Nothing open.
- **Does the generic theorem need a top or bottom element?** No hypothesis
  is stated; both follow: `le_zero` and `one_le` derive that zero is the
  greatest and one the least carrier value from the semiring laws and
  inflation. Settled.
- **Why `Boolᵒᵈ` rather than a fresh order?** The cost convention
  (`add = min`) matches the review's phrasing and min-plus; Boolean needs the
  dual of Mathlib's `false < true`. Stating the structure in the information
  order instead (`add = max`, deflationary product) would swap which
  instance needs the dual. A cosmetic choice; recorded so it is not
  re-derived.
- **Where is linearity used?** Exactly once: `contributions_witness` needs
  a minimum over the listed products to be attained by one of them
  (`min_lt_iff`). Over a lattice with `add = meet` the improved value could
  be a meet of several products with no single improving rule, and the
  per-rule attribution that drives the count would fail. Both inflation
  hypotheses are used, one per factor, in `step_improvement`; product
  monotonicity is not a hypothesis but a consequence of distributivity
  (`mul_le_mul`). So the structure is minimal for this proof, and a lattice
  generalization is a different argument, not a weakening.
- **Open boundary, not a mystery:** the round-count identity between the
  producer and the formal iterate (C1172) is pinned for min-plus by the
  round-convention fixtures; for Boolean it follows from `boolLift_iterate`
  and the min-plus pin rather than from a Boolean fixture family. A Boolean
  round-convention module would need the oracle path generalized (first
  item above).
- No incidental discovery-track entry: every conclusion here was sought by
  the task.
