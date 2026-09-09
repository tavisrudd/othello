# C1130 — Evolve progress view and measurement gap

**PRIVATE — contributor context only. Do not ship, export or publish.**
**Lane**: `ergodis`. Date: 2026-09-08.
**Status**: visualization/trace-reader slice implemented, private `a9e4793`.
The requested live discovery-to-solver reduction demonstration is NOT complete.

## Delivered

Application workspace now links to `/evolve` on ports 8769/8770. The read-only
view polls a small projection of the existing native console's `/api/payload`
on 8767. It labels this native campaign telemetry, not browser/WASM execution.
The source reports 19,997 candidates, 178 behavior classes and two timed samples.
Only one interval-average discovery rate can be calculated; a trend or rate
improvement cannot be inferred. Live discovery and final summary store counters
under different nested keys; both now parse correctly.

The viewer accepts a bounded recorded `ergodis.progress.v1` JSON trace, plotting
states remaining, original-space coverage/s, actual processed states/s, marginal
reduction cascade, selectable reduction markers, and an optional dashed matched
baseline. It reports a single end-to-end baseline ratio only when both traces
finish. Missing baseline/completion means payoff is unavailable, without an
extrapolated break-even claim. Imported declarations are explicitly reported
admissions; this UI does not run their checkers or establish mathematical authority.

Counts remain decimal strings at the input boundary and BigInt in arithmetic.
Plots/rates use approximate Number coordinates. Counts are limited to 78 digits,
trace files to 4 MiB and samples to 10,000. Required sample fields:
`elapsed_s`, `visited`, `processed`, `eliminated`, `remaining`.
Trace fields: `schema`, `run_id`, `scope`, `initial_states`, `samples`.
A positive change in eliminated count requires `reduction: {id, status: admitted,
evidence}`. Reductions are computed as differences of cumulative eliminated
counts, not added from overlapping individual percentages. Validation enforces
visited + eliminated + remaining = initial_states and monotone time/counters.
This checks arithmetic consistency, not the underlying disjointness proof.

An optional `baseline` is another trace with the same `scope`, initial count and
64-hex `spec_sha256`. Matching declarations do not independently authenticate the
input identity. Times must include discovery/checking/compilation/solve overhead.
A restart or changed scope requires another trace rather than silently resetting
counters. The first sample is an observation; no rate is inferred before it.

## What is missing

The native Hadamard campaign is a diagnostic corpus-discovery run. Its static
problem reductions predate this Evolve run. Neither corpus-perfect candidates,
behavior-class discovery, nor the known input reduction supplies an admitted
runtime solve-state elimination trace. The new view deliberately reports missing
states/rates/cascade/payoff instead of drawing fictional gains.

Next required implementation is a real admitted-reduction solver consumer and
coarse host measurements: original problem/spec identity, disjoint covered and
remaining counts, measured processing work, admitted reduction application and
checker references, phase timings, plus an equal-scope baseline. Feed these from
actual safe boundaries; do not put formatting/clocks/serialization in hot loops.
Bind the existing Evolve driver to WASM separately; do not label this native
observer as the WASM port. Existing native performance gates still apply to any
future solver/code-generation change. No Rust or provider payload changed here.

## Validation and preview ownership

Node accounting tests pass exact large-integer conservation, cumulative marginal
cuts, malformed/nonmonotone samples, rejected candidate-as-admission labels and
nested running/final telemetry formats. Their fixtures are TEST ONLY and are not
loaded as campaign evidence in the UI.

Full application/browser gate passes on 8769, including all earlier QEC/recovery/
scheduling/surface workflows, real Evolve source display, test-only trace import,
linked reduction selection, absent baseline behavior, and mobile width. First
browser run exposed the nested final-summary format; reader/test corrected before
the passing rerun. Final log:
`/tmp/claude-run-quiet/20260908-195939-nix-shell-nixpkgsnodejs-nixpkgschromium-command-node-run-smoke.mjs-url-127.0.0.18/stdout.log`.
Screenshot `~/.cache/ergodis/application-workspace/evolve-evolve.png` was inspected.

Replay:
```sh
nix shell nixpkgs#nodejs --command node analysis/campaign-console/mockups/evolve-progress.test.mjs
nix shell nixpkgs#nodejs nixpkgs#chromium --command node analysis/campaign-console/mockups/run-smoke.mjs --url http://127.0.0.1:8769/ --shot /home/tavis/.cache/ergodis/application-workspace/evolve.png
```

Owned application preview servers were restarted after verifying exact command
lines: 8769 PID3738708, 8770 PID3738709. Existing server.pid/server.log locations
remain unchanged. Main native console on 8767 was only read; no intervention.
Accepted capacity-fit WASM providers and canonical core package remain unchanged.
