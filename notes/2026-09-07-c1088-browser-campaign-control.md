# C1088 — Browser campaign control demo

Date: 2026-09-07. Lane: ergodis. Status: in progress. Mode: intent-based.
Baseline core: `75c1021`. Allocation: `61a5665ad`.

## Scope

Stage 3 of the C1084 plan: interactive browser controls over the portable runtime, with a Worker
owning the synchronous WASM session and an explicit bounded client coordinator. Create/propose/
check/execute/cancel/resume, status and opaque checkpoint file exchange. Display search mode,
theorem/parameter provenance, verification and result coverage independently. Preserve existing
composition demo. No solver/kernel or native64 representation changes.

The UI remains responsive while the Worker executes. Cancel gates later commands; it does not
interrupt an active synchronous solve. Import replays a checkpoint into a new campaign; it is
neither saved solver-stack continuation nor durable history activation. No generic autonomous
scheduler, private module loader, persistence repository or remote host is claimed.

## Ownership and validation

Terra owns session-client.js/session-worker.js; second Terra owns campaign.html/js/css. Parent owns
independent browser integration tests, landing link, docs/review and lifecycle. Luna owns the
sequential acceptance window after review. Browser tests must exercise the real UI/Worker/WASM,
not just isolated mocked request flow. Existing native/Python/browser regression gates stand.

Implementation in progress; no source commit yet.
