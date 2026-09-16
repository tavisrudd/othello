# C1195 — end-to-end Datalog benchmark suite from Rel source against Soufflé

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: QUEUED — AFTER C1192; min-plus rows gated on C1194. Rule-contract programme step 5.
Ranked fourth among the Datalog programme's next steps
(`2026-09-16-ergodis-datalog-programme-review.md`).

## Why

The programme's measurable claim is "faster than the tools that compiler's author would
otherwise use". The only comparison so far (C1182) is Soufflé on hand-built two-atom Boolean
programs fed to the evaluator directly. Nothing measures the product path: Rel source → scan →
parse → admit → lower → evaluate → certificate, on programs with negation and aggregation, at
sizes beyond the old domain ceiling. Step 5's suite (`2026-09-12-datalog-benchmark-suites.md`) is
allocated here; its min-plus rows wait on C1194 and its reach on C1192.

## Deliverable

- Private harness under `analysis/datalog-comparison/` extended to take Rel source, run the whole
  pipeline through `rel-lower`/the tools binary, and compare against Soufflé 2.5 (compiled and
  interpreter, single-threaded, same rule sets, exact tuple-set agreement) per the C1182 protocol
  and the external-benchmark programme (`2026-09-11-ergodis-external-benchmark-programme.md`).
- Rows: TC and SG (Boolean; the C1182 families at N up to what C1192 allows), a stratified
  negation row and an aggregation row on the same graphs, TC over the counting semiring only if
  the carrier exists, SSSP and CC once C1194 lands. Every row records stage times (frontend,
  lowering, evaluation, certificate emission, checking) separately, whole-process wall and
  instructions, peak RSS, and the certificate size.
- Citation-only tables for RecStep, BigDatalog, DDlog, Umbra, VLog, RDFox, Rel as the suites
  document lists them; no cross-engine number is claimed without a matched local run.

## Acceptance

- Results and replay bundles committed to the evidence repository per the reproducibility
  conventions, each with its exact replay command and hashes; a report with per-row tables,
  intervals, load, the negative rows where Soufflé wins, and a Mystery ledger; audit.
- No engine claim beyond the rule classes measured; the confinement sentence from C1182 is
  carried forward and widened only by rows actually run.

## Out of scope

Parallel evaluation; egglog and the exact-cover / minimum-fault rows (separate allocation once
their inputs exist); publication (C1149).
