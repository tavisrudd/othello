# C1126 — campaign information architecture working layout

**Lane**: `ergodis`. 2026-09-07. Complete for the existing console data sources.

The user requested continuation of the analogue-dashboard/design proposal. Applied
that proposal as a working layout in the private campaign console, retaining real
C1124 evidence and all C1125 portable workflows. No core or runtime contract changes.

## Result

- Campaigns and Library are the global navigation. Browser execution is a New
  browser run action, not a peer of a campaign or a file format.
- Campaigns lists the configured native campaign using its actual name, purpose
  and saved/connected state. Loaded browser sessions appear as selectable runs,
  explicitly tab-local. No durable campaign schema or aggregation is fabricated.
- The campaign's Overview keeps this run's reduction, quotient compilation and
  remaining cascade sections above lineage. Historical g41 scope is explicit.
- The compilation diagram has a bounded height, keyboard/pointer stage selection
  and immediately visible selected-stage scope. Its full counts remain in the table.
- The candidate inspector sits beside lineage instead of reduction. It follows
  Archive/Space/Replay navigation to preserve existing inspection workflows.
- Supporting details and provenance stay visible below the graph, without new
  collapse controls. The header remains short.

The implementation and reference rationale live under
`ergodis-private/analysis/campaign-console/`; `information-architecture.md` marks
what is implemented and what remains a proposal.

## Validation

Actual Chromium workspace gate passed at desktop and narrow widths: navigation
labels, native campaign catalog, two restored/imported browser sessions, inspector
placement, stage selection, no horizontal overflow, and all existing bundle verify,
save/reopen/reload/fork and WASM campaign/checkpoint workflows. Checkpoint replay
preserves the exact snapshot. Native console gate passed with 3,199 drawn lineage
nodes, 178 archive rows, two trace panels, four view entries and no browser errors.
JavaScript syntax and whitespace checks pass. No solver changes or new search run.

One initial browser run failed its save assertion without recording the action
status. The test now includes that diagnostic. The failure did not recur in the
next two full workspace runs; its cause was not established, and it is not claimed
as a repaired persistence defect. Existing repository code was unchanged.

Logs: `/tmp/claude-run-quiet/20260907-171702-node-workspace-smoke.mjs-url-127.0.0.18767-shot-architecture.png`
and `20260907-171716-node-smoke.mjs-url-127.0.0.18767`.
Screenshots inspected: `~/.cache/ergodis/c1125-console/architecture.png` and
`architecture-catalog.png`. Preview remains http://127.0.0.1:8767/ on the previously
owned server; no server restart or process intervention was needed.

## Remaining boundaries and next review

This is a working presentation of the configured native campaign plus browser
sessions, not a repository-wide campaign catalog. Native launch, durable campaign
aggregation, compatible-run comparisons, and executable bundle bridging still need
real contract implementations. WASM remains bounded GF(2), not native evolution.

Next: review this concrete layout, then select a real compatible WASM workload and
its explicit bundle/checkpoint bridge. No next task ID allocated. No incidental
research discovery arose from the UI work.
