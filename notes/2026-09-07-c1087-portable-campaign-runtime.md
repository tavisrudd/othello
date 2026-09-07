# C1087 — Portable campaign runtime and shared session contract

Date: 2026-09-07. Lane: ergodis. Status: in progress. Mode: intent-based.
Baseline core: `08221f2`. Allocation: `5758c1817`.

## Scope

Implement stage 2 of the approved C1084 architecture: move the bounded finite Campaign workflow
above the solver into ergodis-runtime and add the first bounded synchronous in-process service
contract. Preserve existing transition/checkpoint semantics and native kernel specialization.
No cyclic core compatibility reexport. Browser hosts, durable history and asynchronous jobs remain
later stages, as do native daemon/client migration and private module loading.

## Ownership and acceptance

Terra extracts the aggregate/tests and independently audits consumers; second Terra reviews and
implements the service module. Parent owns public cold compile boundary, workspace, service tests,
dependency gate, docs and lifecycle. Luna will own the sequential build window after source review.
Existing native/Python/WASM/browser gates stay required; add runtime default/parallel checks,
serialized contract adversarial tests and dependency direction validation.

No solver hot loop or hot record changes are intended. The runtime calls existing cold solver
entries; metadata, retries, session IDs and revision checks stay above those entries.

## Status

Source work in progress; no validated implementation commit yet.
