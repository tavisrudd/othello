# C1086 — Independent finite verification context

Date: 2026-09-07. Lane: ergodis. Status: in progress. Mode: intent-based.
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
