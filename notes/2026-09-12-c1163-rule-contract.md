# C1163 — finite weighted rule contract

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE. Lean contract, recursive source program, independent certificate checker,
and native/actual-WASM C ABI replay pass. Next: C1164 Lean oracle.

## Result and ownership

The contract describes finite relations over a declared idempotent semiring, ordered polynomial
rules, scalar stability, checked symmetries, and source-bound least-fixpoint certificates.
The first carrier is saturating nonnegative u32 min-plus. A small Datalog-style parser is an
adapter to the typed relational IR, with one or two ordered body atoms per rule. MLIR is optional;
no full Rel implementation or external compiler integration is claimed.

The retained program is `dist(y) :- dist(x), edge(x,y).` over four nodes with edges
0→1:7, 0→2:2, 1→3:3, 2→1:1, 3→2:0 and initial dist(0)=0. Its grounding has
16 edge coordinates, four distances and one unit: N=21. The full producer reaches
[0,3,2,6] after four rounds, with 80 product checks including the final fixedness scan.
The certificate records all 21 values, four rounds and a SHA-256 source identity.
The separate semi-naive verifier replays from zero, so unsupported cyclic fixed points fail.

Core implementation: `f21e4e0`; retained certificate and compiled ABI replay: `adacd0f`;
checksum refresh and final proof-boundary documentation: `996ea90`.
Owned core paths are `crates/rules`, `crates/verify/src/rule_contract.rs`, its verifier export
and implementation-identity registration, workspace Cargo files, `SHA256SUMS`, and
`docs/rule-contract.md`. The provider uses existing `ergodis_modules::Api` and the existing
WASM `ModuleProvider` host. No private adapter, served demo rebuild, public export or push.

## Formal contract and trust boundary

Monorepo authority is the new `WeightedRules` Lean library:

- `Contract.lean` (`1bc04c132`): scalar laws, information order, polynomial monotonicity,
  finite convergence certificates, lowering commutation and symmetry invariance.
  `certificate_least` proves both fixedness and comparison with every fixed point;
  `certificates_agree` proves uniqueness of certified values.
- `BoundedMinPlus.lean` (`cb25d7eba`): all bounded min-plus semiring laws, scalar
  zero-stability, comparison-minus laws, the concrete 21-coordinate program,
  `distanceCertificate`, `distance_least`, and `distance_values` by kernel reduction.
- `Relations.lean` (`a6cfbf668`): ground tuples and complete bijective scalar coordinates.
  `relational_certificate_least` transports scalar leastness under an explicit source-step
  commutation square. `distance_signature_count` proves the 21-coordinate count.
- `AxiomAudit.lean` (`07e4f6f55`, `eff2a2c70`): 13 terminal declarations audited. No sorry,
  native oracle or nonstandard axiom. `step_mono`, `certificate_least` and
  `distance_signature_count` use no axioms; remaining dependencies are subsets of
  `propext`, `Quot.sound`, and `Classical.choice`.

The Lean model does not formally verify the Rust parser, JSON codec, grounding, source hash
or C ABI. Producer and checker share admission/grounding but use independent evaluation
algorithms. A concrete certificate proves convergence within N; a universal N-step convergence
theorem for every admitted source has not been formalized here. The checker accepts only an
actual fixed iterate within the declared scalar bound. C1164 owns reflective import and proof
terms from external certificates; C1161 owns runtime integration and incremental execution.

The executable schema admits domain≤32, relations≤32, arity≤3, source rules≤128,
variables/rule≤3, scalar coordinates≤4096 including the unit, grounded products≤65536,
symmetries≤8, and (N+1)×products≤16777216. JSON is bounded at 1 MiB.
Input relations cannot be rule heads; head variables must occur in the body. Constants,
repeated variables and ordered nonlinear products are checked. A symmetry must be a full
bijection preserving facts and the ordered product multiset; it does not enable quotienting.
`u32::MAX` is infinity, including saturated sums. Claims about unbounded costs need a separate
representability argument. Source identity preserves typed declaration order, including symmetries.

## Validation and replay

All gates pass:

- Full native formatting, all-target/all-feature Clippy with warnings denied, and all-feature
  tests: **902 passed, zero failed, two ignored**, 58 suites, including existing Python parity
  and evidence checks. The first broad run exposed only stale Cargo.toml/Cargo.lock checksums;
  the normal generator changed those two manifest entries and no evidence results. The rerun
  passed. No test was skipped or gate relaxed to obtain this result.
- 128 seeded Python Floyd-Warshall cases (seed5731, domains2–8; absent edges, zero cycles and
  saturation), plus the retained example. Native C ABI and actual WASM execute all **129**
  programs, compare every distance against the oracle, and produce identical baseline
  certificate bytes. Replay uses the existing WASM host and no imports.
- Source/schema/range/role/symmetry/certificate/bound mutations; forged source IDs and all
  scalar-value mutations; short output buffers; stale, foreign and released handles; busy
  plan release; independent workspaces. Four workspaces agree in values and work counts.
- 100 evaluations perform 8000 product checks with zero allocator calls in the evaluator.
  No existing solver hot loop changed. This is a new capability, not a speedup claim;
  no single-query parallel acceleration or comparator ranking is asserted.
- Guarded Lean elaboration and queue target plus aggregate gates pass for all four modules.
  Final guarded axiom audit emits all 13 declarations successfully.
- Cache GC dry run completed; no cache entries deleted.

Exact Rust/native/WASM replay commands and source format are committed in core
`docs/rule-contract.md`. The native replay optionally regenerates the tracked certificate;
ordinary replay leaves it unchanged. The independent oracle is `crates/rules/tests/oracle.py`.

Full native gate, from `~/src/ergodis` (wrapped in `~/.claude/bin/run-quiet`):

```sh
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#rustfmt nixpkgs#clippy nixpkgs#python3 -c sh -c 'cargo fmt --check && CARGO_BUILD_JOBS=8 cargo clippy --all-targets --all-features -- -D warnings && CARGO_BUILD_JOBS=8 RAYON_NUM_THREADS=4 cargo test --all-features -- --test-threads=4'
```

Lean replay from `othello/rust`, using only the guarded entry points, in dependency order
Contract, BoundedMinPlus, Relations, AxiomAudit:

```sh
../lean/scripts/guarded-lean WeightedRules/Contract.lean
../lean/scripts/lean-build-queue.py build WeightedRules.Contract --cores 20-23
../lean/scripts/guarded-lean WeightedRules/BoundedMinPlus.lean
../lean/scripts/lean-build-queue.py build WeightedRules.BoundedMinPlus --cores 20-23
../lean/scripts/guarded-lean WeightedRules/Relations.lean
../lean/scripts/lean-build-queue.py build WeightedRules.Relations --cores 20-23
../lean/scripts/guarded-lean WeightedRules/AxiomAudit.lean
../lean/scripts/lean-build-queue.py build WeightedRules.AxiomAudit --cores 20-23
```

Gate runs (committed sources/scripts/certificate are authority):

- Full native: the `cargo fmt` / `clippy` / `test` command above, at core `996ea90`.
- Native/WASM builds and execution: the committed replay commands in core
  `docs/rule-contract.md`, at core `adacd0f`.
- Final stronger ABI replay: `python3 native_abi.py` against the compiled
  `libergodis_rules` library, at core `adacd0f`.
- Lean queue builds of `lean/WeightedRules/Contract.lean`,
  `BoundedMinPlus.lean`, `Relations.lean` and `AxiomAudit.lean`, at the per-module
  commits listed above.
- Final axiom output: elaborated from `lean/WeightedRules/AxiomAudit.lean` at
  `eff2a2c70`.

The run-quiet logs and Lean queue run directories were session-local and not retained.

SHA-256 of committed core files under `crates/rules/tests/`:

| File | SHA-256 |
|---|---|
| distance.dl | ac9c153c1b5359d99e366f1198c3e05a307245de4375dbc313b6a7ffad719fa7 |
| distance.json | c1753deeb27988c580abaa64faeee602ecd3bedb3c8573dd9380073118b67994 |
| distance.certificate.json | 3304ff419c460a5bb9d1079afb8aa7424c13da67a937775e4983c1a8cde9e891 |
| oracle.py | 36c936ae835e230888ad21afbbf346853057c796c1142de20645e01ad5fecf6b |
| native_abi.py | dde0fbd3588ba1c7965c78dbcb8f6c605fcaf246a24d7255e6de83b39b4a9225 |
| wasm_abi.mjs | 9d5d35065830d9779bf61f31718251c3131e2b36fddb866f48a0a720f02b74cf |

## Mystery ledger — explicit ej+tt closeout

The post-acceptance ej+tt pass asked whether a scalar encoding can silently merge tuples,
whether fixedness alone establishes leastness, and which convergence claim the evidence proves.
The cheap upgrade was the complete relation-coordinate bijection and transport theorem;
it is committed and its guarded/aggregate/axiom gates pass. A second closeout review after
all gates found no further task-owned correctness gap.

| Feature | Disposition and evidence gap |
|---|---|
| Scalar 0-stability versus matrix dimension | Settled: count all scalar tuples, including auxiliary unit; the concrete count21 is kernel-proved. No claim that a min-plus matrix algebra is 0-stable. |
| Cyclic fixed points may be unsupported | Settled: producer/checker start at zero; `certificate_least` proves minimality in information order. Mutation controls reject fabricated values. |
| Source lowering might omit coordinates | Settled at contract level by a full bijection and explicit commutation hypothesis. Rust grounding correspondence remains outside the formal trust boundary; C1164 consumes the formal checker. |
| N rounds versus a checked finite certificate | Concrete4≤21 settled by kernel proof and both executable evaluators. Universal convergence theorem remains explicitly unproved here; runtime guarantee belongs with C1161. |
| Retractions and parallelism | C1160 specifies safe retraction replay; this provider freshly evaluates each call. Incremental runtime and parallel speed evidence remain C1161/benchmark work. |
| Symmetry could imply a quotient optimization | It does not: declarations are checked structural automorphisms only. Measurement/optimization remains C1158. |
| Saturation conflates absent and expensive paths | Declared bounded-carrier semantics; unbounded interpretation requires representability evidence. |

No genuine unexplained mystery remains inside the completed scope. Review against the discovery
track discriminator found no incidental observation: these are planned deliverables and explicit
successor boundaries, so no manufactured discovery entry was appended.

## Next

C1164 is the highest-EV next item: turn the existing portable producer and explicit Lean contract
into an oracle returning independently checked proof terms. Programme order remains
C1164 → C1161 → unallocated join engine/benchmarks → C1162; Macready's concrete workload still
shapes later adapter and benchmark choices.
