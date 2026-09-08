# C1129 — Loaded domain workspace and staged WASM actions

**Lane**: `ergodis`
**Disposition**: complete bounded browser implementation. Private commit `daf812d`.

The six-view design lab now loads domain JSON, portable schema-1 CampaignSpec,
opaque campaign checkpoints and portable bundles. Loading always creates a
read-only snapshot view. Opening a bundle invokes the portable parser, never a
campaign or an implicit domain conversion. A user explicitly creates/restores a
Browser/WASM session before query editing or execution becomes available.

## Information architecture

One emphasized next action follows the state: Create runnable session → Run →
Run again. A four-stage strip marks Inspect input / Create session / Run query /
Review result. Snapshot and runnable contexts have explicit labels and distinct
border colors. Unsupported domain snapshots expose no execution action.

Run performs Check and, only on admitted evidence, Execute. Individual controls
are named Check reduction and Solve and sit below the visualization with session
and file actions. Solve appears only after admission. Download checkpoint appears
only when available. Query/source changes clear stale results, admission and
checkpoints. Completed results remain recorded when returning to snapshot mode.
No disclosure panels were introduced.

## Actual execution and limits

The QEC adapter projects the loaded Stim model onto six nearest detector
coordinates and up to eight distinct nonzero fault masks. The existing portable
campaign Worker/WASM runtime solves minimum mechanism count, with editable parity
queries and returned witness source IDs. Visible witness edges are highlighted.
The checked restriction fixes an already-zero padding coordinate. The scope is
explicitly this supplied finite projection: not whole-code decoding, likelihood
optimality, or an independent certificate that projection preserves decoding.

Scheduling FT10 and the explicit GF(256) RS(12,8) recovery view are inspect-only;
those domain backends are not exposed by this WASM interface. Imported domain
geometry and metadata have bounded validation. Recovery preserves the stated
matrix/rack layout with uniform per-rack costs. No core or solver hot-path change.

## Validation and replay

From `/home/tavis/src/ergodis-private`:

```sh
python3 -B analysis/campaign-console/mockups/build.py --output "$HOME/.cache/ergodis/input-query-mockups/index.html"
python3 -B analysis/campaign-console/mockups/serve.py --page "$HOME/.cache/ergodis/input-query-mockups/index.html" --port 8769
node analysis/campaign-console/mockups/run-smoke.mjs --url http://127.0.0.1:8769/ --shot "$HOME/.cache/ergodis/input-query-mockups/runnable.png"
node analysis/campaign-console/mockups/smoke.mjs --url http://127.0.0.1:8769/ --shot "$HOME/.cache/ergodis/input-query-mockups"
```

Both actual Chromium gates passed, no browser errors. The runtime gate checks
stage visibility and Solve admission gating, independently enumerates the finite
optimum and verifies witness parity, edits and reruns queries, invalidates results,
replays checkpoints, accepts domain/bundle loads and rejects malformed imports
without replacing the accepted context. The six-view gate checks shared selection,
weighted corpus comparison, QEC round slices, all FT10 operations and snapshot-only
recovery helpers. `git diff --check` passed. Screenshots visually inspected.
Latest logs: `/tmp/claude-run-quiet/20260908-114007-node-run-smoke.mjs-url-127.0.0.18769-shot-runnable.png`
and `/tmp/claude-run-quiet/20260908-114010-node-smoke.mjs-url-127.0.0.18769-shot-input-query-mockups`.

Preview: http://127.0.0.1:8769/#qec. Owned localhost server PID 3000766;
PID/log files under `~/.cache/ergodis/input-query-mockups/`. Server reads regenerated
page and committed JS on each request. Existing campaign console on 8767 is unchanged.
No incidental mathematical discovery; no discovery-track entry is warranted.

Next unallocated slice: integrate this loaded-domain/session interaction into the
main campaign workspace and select the next real domain backend contract.
