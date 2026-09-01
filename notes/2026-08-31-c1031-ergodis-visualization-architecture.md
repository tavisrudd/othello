# C1031 — recommended architecture for an Ergodis console

**Lane**: `complete-ports`
**Task**: C1031
**Date**: 2026-08-31
**Charter**: `notes/2026-08-31-c1031-ergodis-visualization-goal.md`
**Data model**: `notes/2026-08-31-c1031-ergodis-visualization-data-model.md`

## Recommendation in one paragraph

Build a browser console, not a terminal one, and build it as a thin local server that shells out to
`ergodisctl --json` for live campaigns, reads run directories directly for finished ones, and loads
the C1032 WebAssembly adapter into a Web Worker so the page can re-evaluate plans itself without a
round trip. Nothing in the Ergodis core changes. The three data paths already exist and were each
exercised during this exploration.

## Why a browser and not a terminal interface

The terminal option was taken seriously, and `ratatui` would produce something usable in a day. It
loses on two specific grounds rather than on general polish.

The first is that the central objects are graphs whose value comes from spatial layout. A candidate
lineage over four generations already has 257 nodes and 253 edges; a real campaign will have far
more. A quotient compilation cascade is a small graph but a genuinely two-dimensional one, with
fan-out to four per-shift filters and fan-in at the intersection. Terminal cells cannot carry
continuous position, node area, or edge curvature, so a terminal version of either object degrades
to a list, and a list is what the operator already has in `ergodisctl`.

The second is the teaching goal, which is half the point of the task. Explaining what Ergodis does
means letting someone click a candidate, follow its derivation back to a seed, see the object that
refutes it, and step through the evaluation. That is a hypertext interaction, and every affordance
it needs — hover, selection, linked highlighting across panels, deep links into a specific
candidate — is native to a browser and laborious in a terminal.

Recommendation: **web console.** Keep a very small `ergodisctl`-based status summary for terminal
use, but do not build a second full interface there.

## The three data paths, all verified

**Finished runs: read the run directory.** `manifest.json`, `ledger.jsonl`, and `evidence/` are a
complete self-describing record. The prototype's `bake_run.py` reads exactly these and produces a
single JSON payload; no running process is required, and a run can be inspected months later.

**Live campaigns: shell out to `ergodisctl --json`.** Every command returns the stable envelope
`{schema, request_id, run_id, epoch, ok, result}`. A backend can forward `result` verbatim without
reimplementing the Unix-socket protocol, the nonce handshake, or the framing. This is the single
biggest cost saving available and it is the reason the whole thing is cheap. The control plane also
supports watchers, so a later version can subscribe instead of polling.

**Interactive re-evaluation: the C1032 WebAssembly adapter.** C1032 established, on branch
`codex/c1032-ergodis-wasm`, that the sequential Ergodis library cross-compiles to
`wasm32-unknown-unknown` and runs the production labelled-composition path in a dedicated browser
Web Worker, with native and Python-oracle parity on cost, witness labels, and transition counts, and
a headless Chromium smoke gate. The optimized payload is about 132 KB uncompressed.

That last path is what makes the console more than a viewer. A page that can call into Ergodis can
offer a what-if panel — edit a plan, see it evaluated against the object space immediately — with no
server round trip and no risk to the running campaign. Note the boundary C1032 drew deliberately:
the Wasm adapter does not link the control plane, filesystem, affinity, checkpoint, CLI, or parallel
search, and only labelled GF(2) composition currently has a JavaScript schema. So live campaigns
stay native and the browser gets exact evaluation. **The architecture is a hybrid, and that split is
a feature: the browser never drives a campaign, it only re-examines it.**

## Views, in priority order

Each of these is either built in the prototype or specified from data confirmed to exist.

1. **Reduction cascade.** The staged compilation with a surviving root count at every node,
   logarithmic node area, and edge style encoding reduction authority — solid for an exact filter,
   dashed for a necessary condition that grants no witness authority beyond it. This is the view
   that explains what Ergodis is for, and it should be the front door for a newcomer. Built.
2. **Candidate lineage.** The evolution genealogy, coloured by mutation operator, sized by how much
   of the labelled data the candidate gets right, with the derivation path back to a seed
   highlighted on selection. Must be driven by `evolve-start`, not `evolve`. Built.
3. **Behaviour archive.** Outcome classes rather than candidate counts, with the discovery curve of
   distinct behaviours against candidates tested. The flattening of that curve is the best available
   "the search is saturating" signal. Built.
4. **Object space and reduction.** The feature batch as objects with named integer coordinates,
   shaded by whether the active plan applies to them, with root-orbit grouping and the exact
   `ceiling` as the denominator for any reduction claim. Built.
5. **Replay and trace.** Step through one evaluation operation by operation for one chosen object.
   Built, and it exposed the scope subtlety described below.
6. **Performance.** Instructions, cycles, and peak resident set per stage, with cost per root
   eliminated as the headline column. Built from committed C1016 evidence; a live version needs the
   timestamp gap closed first.

## The console is an instrument, not an explainer

Set by the user on 2026-08-31 and binding on everything above. Every element must be one that could
exist in a running system: generic, computed from data the campaign emits, and correct for any run.
No prose written about a particular run, no narrative panels, no editorial reading of the numbers.
Where a caption is needed it explains the encoding — what node area means, what a dashed edge means
— never what this run happened to do.

Two practical consequences. Large numbers are shown in scientific notation, because root counts and
instruction counts span too many orders of magnitude for grouped digits to be comparable at a
glance. And a panel that would otherwise be commentary becomes a data panel instead: rather than a
paragraph saying that timestamps are missing, the console carries a signal-availability list that
reports, per telemetry channel, whether this run has it — event stream, lineage edges, evaluator
traces, search counters, cost counters, timestamps. That list is generic, it is true of whatever run
is loaded, and it tells an operator exactly which views will be populated.

## Three findings that constrain any design

**Scope must be on screen next to the formula.** The best plan this exploration's run produced is
not interesting for its comparison but for its scope: the search restricted itself to a single root
orbit and only then compared two counts. Outside that orbit the plan returns false for reasons that
have nothing to do with its formula. A view showing only the formula teaches the wrong thing, and a
trace of an out-of-scope object comes back with zero operations — the absence of steps is the
explanation, and a console that rendered it as a blank panel would be actively misleading.

**A perfect-classifier count is never shown without the size of the evidence it is perfect on.** The
C1016 record has an evolution that found seventeen plans classifying a 315-object corpus perfectly,
whose best was strictly weaker than the actual theorem. Corpus perfection is not pruning authority.

**Reduction authority is not uniform.** Some edges are proved, some are exact computations, some are
necessary conditions only. Drawing them identically erases the distinction the research programme is
organized around.

## The one gap worth closing in the core

Neither ledger events nor the evolution progress record carries a timestamp, so nothing on disk says
how long anything took. This blocks two things the user asked for: a completion estimate in units of
time rather than candidates, and the scrubable recorded-trace replay in the manner of the sysdig
explorer views.

The fix is one monotonic clock reading per durable ledger event, on a path that already performs a
file write and a flush, so the cost is negligible and it stays outside the solve hot path. Machine
counters — CPU, resident set, cycles — should be sampled by the harness that launches a campaign
rather than by the solver, which preserves the property that ordinary solves carry no
instrumentation. That is a core change and therefore a separate task; it should not be folded into
C1031.

## Build estimate

The prototype took a few hours including the survey. A production version is roughly: a small
`axum` or Python backend wrapping `ergodisctl` with a watcher subscription, two to three days; the
five views hardened with real filtering and deep links, three to four days; the Wasm what-if panel,
two days on top of C1032's existing adapter, plus schema work for whatever second workflow is
wanted. Nothing here is research risk; it is all ordinary construction against interfaces that
already exist.
