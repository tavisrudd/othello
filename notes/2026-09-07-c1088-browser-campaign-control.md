# C1088 — Browser campaign control demo

Date: 2026-09-07. Lane: ergodis. Status: complete. Mode: intent-based.
Baseline core: `75c1021`. Allocation: `61a5665ad`.
Implementation: core `ea1f563`.

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

## Implementation and review

- Separate campaign page preserves the original composition workflow. It presents the bounded
  sample, proof/heuristic modes, proposal/check/execute/cancel/resume, logical spend and opaque
  checkpoint file exchange. Raw response is an optional detail rather than the main interaction.
- Worker owns WASM; client owns one outstanding request, generation/correlation checks and service
  revisions. Startup/request deadlines close and terminate ambiguous sessions; no automatic retry
  or unbounded queue. Correlated malformed responses and invalid revisions also close the client.
- The accepted candidate's actual origins are displayed; draft edits cannot replace them. Import
  first passes Rust replay, then reads metadata only for display from the original unchanged text.
  A failed import leaves the previous active campaign and known checkpoint intact.
- Review corrected mistaken assumptions about the runtime's adjacent `kind`/`response` envelope,
  startup controls, stale response handling, timeout resource lifetime and import selection.
- Independent client fault tests passed initially. The first UI run exposed two 66-character
  sample IDs instead of 64, causing initialization to stop before event handlers. Corrected IDs,
  disabled initial controls and explicit readiness waiting address that source defect. The initial
  validator's suggestion that WASM lacked the binding was incorrect: the existing direct browser
  corpus already exercised it successfully. No WASM rebuild is required.

## Validation and closeout

All gates pass under Luna's sole sequential validation ownership:

- Five independent client fault tests, including single-flight rejection, stale correlation,
  response shape/revision tracking, byte caps, malformed-response closure and startup/request
  timeout disposal. Syntax checks cover every new JS/MJS module.
- Full Chromium smoke: existing composition and reduction/runtime corpora, then actual campaign
  page controls through the real Worker and WASM. It exercises checked exact solving, Cancel/
  Paused/Resume, rejected restriction versus MissingAdmission, unchecked heuristic restriction,
  exported checkpoint bytes, failed-import preservation and successful replay restoration.
  Accepted provenance is unchanged by draft edits and correctly recovered after import.
- Workspace formatting, all-target/all-feature clippy with warnings denied and all-feature tests
  (48 seconds in the shared target), plus all four Python fixture checks (12/41/10 semantic cases).
- Desktop screenshot reviewed; state is alongside controls, provenance uses the full panel width,
  advanced declarations/response are collapsible, and import remains keyboard focusable. The final
  browser gate repeats the actual workflow after these CSS/HTML/JS refinements.

Final browser log:
`/tmp/claude-run-quiet/20260907-101822-nix-shell-nixpkgsnodejs-nixpkgschromium-command-node-browser-smoke.mjs`.
Workspace test log:
`/tmp/claude-run-quiet/20260907-101450-RAYON_NUM_THREADS12-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-test-worksp`.

A later smoke retry exposed the inherited composition probe reading documentElement before the
initial HTML existed. The poll now tolerates that initial empty document, retaining its timeout
and existing navigation-context retry. This was a test-harness startup defect, not a missing UI
selector or WASM binding.

The final screenshot is a review aid at
`~/.cache/ergodis/browser-control-review/campaign-demo.png`; reproducible source and browser tests
are committed. Documentation link checks and scoped whitespace checks pass. Cache audit passed
in dry-run mode with no deletion: `/tmp/claude-run-quiet/20260907-101913-cache-gc.sh`.
No Rust, lockfile, profile, kernel or layout edits, and no performance improvement claimed.

Baseline and final packaged WASM SHA-256 are identical:
`05da01e5b7be8f8bf5afd3dfef7fb1e3af318382c8a58a726465687b2aec1c78`.

## Next boundary

The next slice defines durable run records/artifact references and a repository boundary outside
the mathematical engine, with version/environment/provenance metadata and annotations. Keep
viewing, verification, replay, activation/resumption and fork lineage distinct; a live process is
not required to view older work. Browser/native storage adapters and crash publication must share
the same bounded contract. Stage-5 responsive autonomous execution and stage-6 industry modules
remain later work. No incidental finding warrants a discovery-track entry.
