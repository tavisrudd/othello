# C1087 — Portable campaign runtime and shared session contract

Date: 2026-09-07. Lane: ergodis. Status: complete. Mode: intent-based.
Baseline core: `08221f2`. Allocation: `5758c1817`.
Implementation: core `75c1021`.

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

## Implementation and review

- `ergodis-runtime` owns Campaign and its unchanged transition/checkpoint semantics. Source parity
  against baseline holds after the core import and `compile_problem` substitutions. Its default
  dependency selects no core features; `parallel` forwards explicitly to the existing native core.
- Core exports the cold `reduction_language::compile_problem` constructor, without exposing
  workflow state or internal canonicalization storage. No core-to-runtime reexport or dependency.
- Both campaign integration suites and the unchanged Python-generated fixture move under runtime.
  The Python generator's output path follows the fixture. Narrow consumer inventory found no
  external use of this finite Campaign API; old native `control::Campaign` and Python APIs are
  separate implementations and remain unmigrated.
- SessionService owns named campaigns, schema/generation-bound requests, expected service
  revisions, successful-response replay and explicit conflict/resync errors. Synchronous typed
  and preflight-bounded JSON dispatch share one implementation. All observable u64 counters become
  decimal strings; checkpoint JSON remains opaque with its old schema.
- Review caught operation-less retry fingerprints, dropped duplicate responses and mismatched
  checkpoint/frame limits; these were corrected before validation. Parent additionally made
  capacity planning nonmutating, delayed eviction until successful commit, and removed recoverable
  post-Apply commit errors with a bounded response invariant. Rejected commands preserve prior
  retry records. The Apply response bound has an explicit 64 KiB assertion.
- Seven service test groups cover idempotency, operation/payload conflicts, stale revisions and
  generations, eviction, rejected-command cache preservation, replay restoration and malformed
  frames. All ten independent Python campaign traces also run through serialized service requests.
- `scripts/check-runtime-dependencies.py` enforces the default runtime/core/verifier direction;
  the independent verifier gate remains separate. Public docs distinguish implemented service,
  old native APIs, future transport adapters and durable history.
- To satisfy the stage-2 actual native/WASM corpus gate, the WASM package has a thin
  `CampaignSession` constructor/dispatchJson binding. Chromium runs the same ten campaign traces,
  response retries and checkpoint restoration. This is conformance plumbing, not the stage-3
  interactive Worker/client demo. Successful responses use adjacent `kind`/`response` tagging.

## Validation

All gates passed under Luna's sole sequential build ownership:

- Workspace formatting and all-target/all-feature clippy with warnings denied.
- Workspace all-feature tests with 12 Rayon workers; runtime default and final all-feature tests;
  root default clippy and focused reduction/admission/verifier tests.
- Four independent Python fixture checks, including 12 admission cases, 41 scalar cases and
  ten campaign traces. Both locked dependency-direction scripts pass.
- Default runtime wasm32 release check, excluded WASM release check, wasm-pack web release and
  Chromium composition/reduction/runtime-campaign conformance. The service envelope change was
  followed by fresh runtime tests, workspace formatting/clippy and the final WASM package/browser gate.

Final gate logs:

- Runtime tests: `/tmp/claude-run-quiet/20260907-095900-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-test-p-ergodis-runtime-all-feat`.
- Browser: `/tmp/claude-run-quiet/20260907-095934-nix-shell-nixpkgsnodejs-nixpkgschromium-command-node-browser-smoke.mjs`.

Parent checked owned documentation links, Python syntax, unchanged native/WASM release profiles
and unchanged MSRV. Lockfiles add only the local runtime package/dependency; no third-party version
churn. Cache audit passed in dry-run mode, with nothing deleted:
`/tmp/claude-run-quiet/20260907-100019-cache-gc.sh`.

Build-maintenance observations: full workspace tests took 1m15s in the shared warm target. Before
adding the runtime binding, the packaged WASM was 216,787 bytes; afterward it is 427,689 bytes
(raw release module 676,108 bytes). These are same-session artifact-size observations, not clean
or controlled incremental-build benchmarks and not solver performance claims. A clean/protocol-edit/
host-edit/kernel-edit timing matrix remains build-maintenance follow-up; no cache purge was done
to manufacture a clean sample. No hot kernel body, record layout or native dispatch was changed.

Final independent Terra review found no remaining authority/retry/bounds contradiction. Task
findings were intended deliverables; no incidental discovery-track entry was warranted.

## Limits and follow-on

One coordinator allocates monotone u32 request IDs across a service. Session-generation uniqueness
is a host contract, not a claim of persisted fencing. Successful responses are retained within
configured bounds; rejected service requests are not cached. No multi-client allocation protocol,
transport error envelope, filesystem repository or daemon migration exists yet. The browser has a
direct synchronous service binding; stage 3 adds the actual Worker/client control demo.
Durable run records, annotations, fork
history and activation fencing remain stage 4. No inherited private/native API is falsely declared
migrated by this finite portable slice.
