# C1085 — Portable scalar language and bounded codecs

Date: 2026-09-07. Lane: ergodis. Status: complete.
Core implementation commit: `57af8b4`.
Baseline core: `6269cd1`. Implements stage 1 of C1084.

## Scope

Extract the scalar/text language and feature-batch codecs into default-feature core ownership;
retain native control compatibility and keep hot evaluators/layouts unchanged. Validate shared
semantics on native and WASM builds. Establish the domain glossary and persisted run-record metadata
contract requested alongside execution. Runtime/session hosting and actual record persistence are
subsequent slices, not claimed here.

## Ownership

Terra source agent: src/** extraction. Terra test agent: tests/** portable and codec coverage.
Parent: architecture metadata amendment, public language/glossary documentation, review and task
lifecycle. Luna: validation after source review; one build owner. Existing python/__pycache__ is
untracked generated state, not part of this task.

## Naming and persisted record design

C1084 now specifies campaign/run records and immutable artifacts with implementation/system
metadata, independent theorem/parameter provenance, attempt accounting and versioned user notes.
The public glossary (`docs/glossary.md`) supplies bounded contexts, command/event/type naming and
user-facing vocabulary. Metadata capture remains planned for repository stage; this extraction
does not claim to persist it. User explicitly authorized highest-value execution and reinforced
DDD, domain-user terminology, crate boundaries and unchanged performance discipline.

## Implementation and review

- Default `scalar` module owns typed plan/expression/text parsing and compilation, FeatureDag
  lowering and FeatureBatch evaluation. Native `control` retains reexports; `ControlError` aliases
  portable `ScalarError`. Protocol/schema strings and logical hashing are unchanged.
- `FeatureBatch::read_jsonl_from(reader, FeatureBatchReadLimits)` explicitly bounds rows, cells,
  raw total bytes and raw line bytes including delimiters, before decoding/appending. Header cell
  multiplication is checked. Native path wrapper preserves prior row/cell-only limit behavior;
  new untrusted integrations must choose finite explicit byte caps.
- Parent requested the explicit byte limits after initial extraction retained only the legacy
  row/cell checks. Parent also required portable error naming and legacy CRLF/EOF behavior.
- Initial suffix review found only error/visibility naming changes beyond the cold reader. Final
  lexical comparison against `6269cd1` confirms identical bodies for all seven evaluate/evaluate_row/
  evaluate_value/evaluate_value_untraced/evaluate_value_impl/applies methods after error-alias
  normalization (combined token digest `352269d8188e66bf3b564087185b32e796c59d6ec6c670c7c8799eb6d2d2381d`).
  Later differences are formatting, target-specific layout assertions and conditional inclusion of
  diagnostic helpers. No evaluator algorithm, hot record fields or hot-loop instrumentation changed.
  This is source-preservation evidence, not a performance speedup claim or hardware A/B measurement.
- Semantic integration tests now import scalar without control-plane. A feature-gated test
  exercises actual lowering/evaluation through the legacy control reexports. Stream tests cover
  roundtrip/evaluation, malformed data, bounds, checked dimensions, I/O and line endings.
- Glossary explicitly separates orchestration, mathematical engine, verification and repository
  contexts and uses domain-user vocabulary. Git-inspired run snapshots/branches/forks retain
  typed provenance and do not imply automatic merge or inherited admission. The architecture
  now routes campaign workflow ownership to the portable runtime in stage 2; this stage does
  not add runtime context to solver inputs or kernel records.

## Validation corrections

The first all-feature clippy run caught a remaining multiline `vm::evaluate_plan_cascaded`
import in native evolution. Parent redirected it to scalar ownership; a scoped follow-up search
found no remaining vm/text child-module references under control. No behavior change was needed.
The failed invocation was not repeated until this source correction.

The wasm32 compile then exposed CompiledPredicate's inherited native-only 24-byte assertion.
The parent retained native64 size24/alignment8 and added exact target32 size16/alignment8, reflecting
its smaller boxed-slice pointer. No fields, evaluator algorithm or native layout changed. The
existing universal alignment guard remains strict; this does not claim arbitrary 32-bit targets.

Default/WASM builds exposed diagnostic helpers used only by native control. Parent gated row_json,
op_count and the tracing wrapper (also retained for unit tests), then gated its serde_json::Value
import when default clippy caught that leftover. No blanket warning suppression or helper body
change was introduced. Final targeted gates cover these conditional-compilation changes.

## Validation

All required gates passed. Luna owned sequential compilation; parent performed final format and
scoped ownership/link checks. Full all-feature clippy/tests passed after the native import fix.
Later changes only added target-specific assertions and conditional inclusion of diagnostic
helpers; the final default and WASM gates below validate those affected configurations. The
all-feature helper definitions/bodies remain unchanged.

- Format check, all-target/all-feature clippy with warnings denied, full all-feature native tests
  with 12 Rayon workers, default cargo check and final default-library clippy with warnings denied.
- Default scalar unit tests: 15 passed. Default integration tests: 13 passed (4 plan, 4 FeatureDag
  lowering, 5 stream codec). All-feature tests additionally cover legacy control reexports.
- Four independent Python fixture checks passed: general composition fixtures plus 12 admission,
  41 scalar-plan and 10 campaign-transition cases. No reference semantics changed.
- wasm32 release compile passed, including strict 16-byte/8-aligned CompiledPredicate guard;
  wasm-pack web release passed with wasm-ld. Chromium smoke passed composition, the reduction
  corpus and three rejected requests. This remains regression evidence for existing JS exports,
  not a new scalar JavaScript API or certification of other browsers/OSes.
- Public doc links and no-internal-task-ID checks passed. Scoped diff checks passed. Cache GC
  ran in dry-run mode only; no shared artifacts were removed.

Supporting logs (committed source/tests are the durable authority):

- Final format: `/tmp/claude-run-quiet/20260907-091435-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-fmt-all-check`.
- Full native suite: `/tmp/claude-run-quiet/20260907-090554-RAYON_NUM_THREADS12-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-test-all-fe`.
- Default clippy: `/tmp/claude-run-quiet/20260907-091214-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsclippy-command-cargo-clippy-lib-no-def`.
- Default scalar unit/integration suites: `20260907-091252-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-test-no-default-features-lib-sc` and `20260907-091256-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-test-no-default-features-test-p` under `/tmp/claude-run-quiet/`.
- Browser: `/tmp/claude-run-quiet/20260907-091345-nix-shell-nixpkgsnodejs-nixpkgschromium-command-node-browser-smoke.mjs`.
- Cache audit: `/tmp/claude-run-quiet/20260907-091309-cache-gc.sh`.

Replay from the core root through run-quiet, using the shared target directory:

```sh
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo fmt --all -- --check
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy --all-targets --all-features -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc --command env RAYON_NUM_THREADS=12 cargo test --all-features
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy --lib --no-default-features -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo test --no-default-features --lib scalar::
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo test --no-default-features --test plan_semantics --test feature_lowering_semantics --test scalar_feature_batch_stream
nix shell nixpkgs#python3 --command python3 python/generate_fixtures.py --check
nix shell nixpkgs#python3 --command python3 python/admission_semantics.py --check
nix shell nixpkgs#python3 --command python3 python/plan_semantics.py --check
nix shell nixpkgs#python3 --command python3 python/campaign_semantics.py --check
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo check --manifest-path wasm/Cargo.toml --target wasm32-unknown-unknown --release
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#wasm-pack nixpkgs#lld --command env RUSTFLAGS='-C linker=wasm-ld' wasm-pack build wasm --target web --release --out-dir www/pkg
```

Browser smoke from `wasm/scripts`: `nix shell nixpkgs#nodejs nixpkgs#chromium --command node browser-smoke.mjs`.


## Current limitations

The browser exports remain composition/reduction only; compiling scalar code for wasm32 is not
browser execution coverage for scalar plans. Native path compatibility intentionally retains
legacy row/cell-only limits. Serialized FeatureBatch header dimensions still use the existing
schema; this task does not introduce a new wire version. Generic runtime metadata collection,
run persistence, history DAG/fork APIs, notebook/Python modernization and moving the bounded
campaign workflow into the orchestration crate are planned successors, not delivered functions.

## Closeout and next work

No incidental mathematical discovery arose; naming, byte limits and layout findings were direct
acceptance work. Review corrected ambiguous “verified artifacts” and separated current transient
Campaign Snapshot/RunReport from planned durable RunSnapshot/RunRecord. Do not manufacture a
research mystery from ordinary migration details.

Next highest-value slice: establish the portable orchestration crate, move Campaign workflow there
with explicit consumer migration (no cyclic core compatibility reexport), and implement its bounded
shared session/client contract. Then persist run records, metadata, annotations and fork lineage
through the repository boundary. Preserve the documented no-control-in-kernels dependency firewall.
