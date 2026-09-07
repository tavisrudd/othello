# C1125 — portable operator workspace

**Lane**: `ergodis` · 2026-09-07 · complete within the existing portable backend contracts.

Private implementation: `ergodis-private` commit `bd0acc4`. Core source unchanged.
The existing built core WASM package was exercised directly; no new solver build or
performance claim. Allocation ledger committed separately in `c83aafcf4`.

## Delivered

The private campaign-console server now opens a workspace with Campaign, Bundles
and WASM entries. Core JS clients/Workers and the WASM package are served through an
exact asset allowlist from the sibling checkout; there is no second bundle parser
or campaign transition model in the UI. Native controller access remains read-only.

Bundles: 16 MiB bounded file import, records/identities/missing dependencies,
explicit supported snapshot verification, selected-spec child download with fresh
UUIDv7, start/fork save through the existing IndexedDB repository, selection/reopen
and download. Reopening clears verification presentation. Later record heads remain
inspectable; this UI does not fabricate repository transactions to save them.

WASM: CampaignSpec schema 1 JSON import, opaque checkpoint restore, multiple
independent tab-local campaign selections, candidate JSON proposal, budgeted check,
execute/cancel/resume, checkpoint export. 4 MiB input bound, single-flight controls,
failed replacement imports retain the previously accepted session, and failed
workers require explicit recovery. Runtime responses retain evidence, result
coverage, counters and session revision separately.

User UX corrections are persistent direction: no collapse-to-simplify workaround.
The Campaign entry shows this run's reduction, historical g41 quotient compilation,
stages/space/cost, then candidate lineage. Counters/operators/signals and provenance
remain visible below the graph. Header contains workload title, saved/connected
state and one purpose sentence; IDs, hashes, socket, epoch and full scope are below
the fold. g41 is still historical reference data, not new current-run measurements.

## Capability boundaries

The current portable WASM campaign supports bounded finite GF(2) restrictions;
it does not run the native feature-corpus evolutionary backend. No synthetic demo
is preloaded. User CampaignSpec/checkpoint files drive browser execution. Portable
RunBundle carries opaque domain payloads and is not a CampaignSpec codec; no
bundle-to-execution bridge or repository-backed campaign recording is claimed.
Those require a separate implementation slice. This is intentionally visible in
the product, not an implied automatic resume action.

## Validation

`node analysis/campaign-console/workspace-smoke.mjs --url http://127.0.0.1:8768/`
passes actual Chromium/Workers/WASM bundle parse, verify, corrupt rejection, local
save/reopen/reload, fork inspection, campaign create/check/execute/cancel/resume,
proposal, checkpoint export and restore with exact snapshot equality and cost 0,
and invalid spec rejection without losing accepted state. Core synthetic conformance
fixtures occur only in this test, never as a user-facing default workload.

Native static and served console smoke gates pass: 3,199 drawn candidates, 178
archive rows, two evaluator traces, all four navigation entries, no page errors or
horizontal overflow. Existing native evidence is C1124's actual q2 campaign; no new
native search was needed for this presentation/client integration. Python AST,
JS syntax, diff whitespace, MIME and non-allowlisted path rejection checks pass.
The WASM Make target uses the existing core README build command; its invocation
was inspected with make -n, not rerun for unchanged core code.

Browser screenshots inspected at
`~/.cache/ergodis/c1125-console/workspace.png`; generated snapshot at `index.html`.
Logs: `/tmp/claude-run-quiet/20260907-163838-node-workspace-smoke.mjs-url-127.0.0.18768`
and `20260907-163830-node-smoke.mjs-url-127.0.0.18768`.
A first integration gate caught reading fields outside the session response
envelope; corrected to `response.response` and the full browser gate passed.

## Review and next gate

Review preview: http://127.0.0.1:8767/ (restarted owned read-only server PID 1864166).
Its PID/log remain `~/.cache/ergodis/c1124-final/preview.pid` and `preview.log`.
Only this owned service was restarted; foreign port 8765 was untouched. Browser
library persistence is origin-scoped, so changing ports selects a separate library.

Next integration gap: domain-bound bundle/checkpoint execution bridge and the
native evolutionary backend's portable execution capability. Select a real
compatible recovery workload for an immediate WASM demonstration before claiming
broader campaign support. No successor ID allocated. No incidental discovery-track
observation arose from ordinary UI integration.
