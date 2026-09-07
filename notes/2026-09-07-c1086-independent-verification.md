# C1086 — Independent finite verification context

Date: 2026-09-07. Lane: ergodis. Status: complete. Mode: intent-based.
Implementation: core `08221f2`.
Baseline core: `57af8b4`. User approved the verification bounded context and continued execution.

## Scope and decision

Extract the existing independent finite GF(2) coordinate-restriction checker into a small leaf
crate with no solver dependency. Core admission becomes a cold adapter around an opaque verified
restriction. Verification owns mathematical problem/claim/evidence; origin, search mode, discovery
and orchestration remain outside it. Preserve problem/candidate identities and exact bounded
outcomes; checker source identity deliberately changes, requiring fresh checking of historical
receipts. Do not claim a generic certificate framework or machine-checked proof.

The explicit verification request advances this dependency cut before orchestration extraction;
the next runtime can depend on verifier and solver without tangling their contexts.

## Ownership

Terra source: crates/verify and src/admission.rs. Terra tests: tests/admission_pipeline.rs plus
new tests/verifier_boundary.rs. Parent: Cargo workspace/dependency, architecture/glossary/docs,
review and lifecycle. Luna: sole validation build owner after review. No hot solver/layout work.

## Implementation and review

- Leaf `ergodis-verify::binary_composition` owns raw bounded ProblemSpec, independently validated
  canonical Problem, coordinate restriction, VerificationBudget, opaque VerifiedRestriction,
  schema/rule/source-bound VerificationRecord and exact verify/replay. No search mode, provenance,
  native Matrix/CostTable, solver, filesystem, scheduler or plugin loader in the leaf.
- Core retains candidate/origin identity, native solver data, discovery and public admission API.
  It cold-converts inputs, stores the leaf problem/token and checks the token scope plus core
  receipt bindings before entering the existing solver. No solver hot-loop/layout changes.
- Cheap native shape/field preflight precedes entry extraction/copying; the leaf independently
  validates raw shapes/values again. The bridge checks unchanged canonical identity encoding.
- Parent review restored budget-before-candidate error ordering, fixed a token borrow/move and
  private ContentId import, and strengthened the opaque Problem compile-fail check so it fails
  on field privacy rather than merely missing constructor fields.
- Source rule ID/version is distinct from implementation digest. Both leaf source files enter
  the new implementation hash. Old core receipts intentionally fail exact replay under this
  implementation; historical records remain unmodified and need fresh checking or explicit
  reconstruction/fork. No legacy checker dispatch is implemented.
- Root workspace includes root+verify as default members with resolver2; wasm is excluded so its
  release profile remains independent. No release-profile/MSRV/dependency-version change intended.
  Committed dependency-boundary script checks Cargo's resolved normal/build graph.

## Frozen compatibility anchors

An independent pre-extraction Python encoding pinned the existing admission fixture:

- Problem: `8999846286cd4aa51185a11935c3d89795cde473bb7704f81e97039ec5dd179c`.
- Candidate: `5f3debb0d1c63ee6041d35c88aee943158ff1d85bd226c17fa8ba6333a398130`.
- Old checker: `0e3afc667762301bcbe39577fd25d10de2327caac8f72f8638552bacf0957cb0`.

Root tests preserve the first two and require the old checker identity to fail replay. The exact
fixture and anchors are committed in tests/admission_pipeline.rs, not only recorded in this note.

## Validation

Luna completed the sole sequential build window; all gates passed:

- Workspace formatting and all-target/all-feature clippy with warnings denied.
- Workspace all-feature tests with 12 Rayon workers, including leaf unit tests and four
  compile-fail API checks; default core clippy and focused admission/verifier/campaign/reduction tests.
- Independent Python fixture checks: composition generator, 12 admission cases, 41 scalar cases
  and 10 campaign traces.
- Standalone verifier all-target clippy and wasm32 release check. Locked dependency gate:
  four approved direct dependencies, 24 normal/build packages, no solver or host package.
- Excluded WASM release check, wasm-pack web release, and Chromium Worker/WASM composition,
  reduction corpus and three rejection checks. This does not add a browser verification API.

Browser log: `/tmp/claude-run-quiet/20260907-093630-nix-shell-nixpkgsnodejs-nixpkgschromium-command-node-browser-smoke.mjs`.
Parent confirmed root and WASM profiles unchanged, MSRV 1.87 unchanged, and no dependency version
or checksum changes: only the local verifier package was added. Cargo updated the root lockfile
format from 3 to 4. Cache audit passed in dry-run mode; nothing deleted:
`/tmp/claude-run-quiet/20260907-093857-cache-gc.sh`.

## Closeout and next boundary

Terra independently reviewed the final API/documentation mapping and found no material mismatch.
This cut reduces the dependency and audit surface; it does not prove checker soundness, provide
succinct certificates or make checking cheaper. The bounded direct enumeration remains unchanged.
No hot evaluator/solver body or record layout changed, and no performance improvement is claimed.
The next implementation slice moves Campaign workflow into the portable runtime and defines the
bounded shared client/session contract; it must preserve current semantics without a cyclic core
reexport. Historical receipt compatibility remains explicit: old receipts need fresh checking,
not silent relabelling as exact replay. No incidental discovery warranted a discovery-track entry.
