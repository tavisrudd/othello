# C1130 — Executable application workspace

**PRIVATE — contributor report; do not ship or publish.**
**Lane**: `ergodis`. Date: 2026-09-08.
**Status**: bounded application/browser slice complete, private `5e22031`;
inverse parity/result hierarchy follow-up `aefe3fb`.
C1130 feature completeness and production execution-interface adoption remain open.

## Delivered

The input/query workspace now executes the complete supplied QEC model and the
existing LRC counted-repair model through independently built private WASM modules.
It uses the canonical public module Worker and core WASM artifact. No solver,
provider binary, native path or Rust layout changed in this browser slice.
The existing application preview at http://127.0.0.1:8769/ and the tested preview
at http://127.0.0.1:8770/ serve the same generated page and module packages. The
main campaign console on 8767 remains separate.

Private Application / QecApplication / RecoveryApplication classes own cold typed
model/query codecs and answer interpretation. ModuleSession owns the common
load/prepare/workspace/call lifecycle over the public module Worker. Existing
InputQueryView subclasses own presentation. These are browser adapters, not a new
universal mathematical Model or a generalization of CampaignSession.

Create runnable session explicitly loads the package, compiles the model and
prepares owned workspace. Run invokes the actual family readouts. QEC/LRC do not
manufacture a GF(2) reduction or a mandatory Check→Execute path. Query edits clear
stale answers while retaining the compiled plan and physical Worker generation.
Selecting a component or measurement round preserves the query/result. Input
replacement explicitly closes the previous session and creates a new snapshot.
Malformed imports reject before replacing the accepted context; native model
admission still happens on explicit creation. Returning to snapshot keeps the
completed displayed result and hides query controls.

## Application contracts and source

QEC uses the complete flattened/decomposed d5/r5 Stim memory-Z DEM: 120 detectors,
1,953 error instructions and 502 merged native matching edges. Circuit noise 0.001
at the four sites recorded in the loading spike; native sampler seed 2026, shot 13,
five detector events. Native reference: minimum quantized matching weight 552,
logical parity 1, no overflow, class costs 1143 / 552 available. The query covers
all detectors; editable parity controls show the selected round. Full DEM text
can be loaded directly, initially with an empty syndrome.

Display geometry/mechanisms are derived from the same DEM bytes sent to Rust,
with a checked comparison against the independent Stim-generated fixture. Imported
geometry cannot replace the execution source. Missing coordinates use an index
layout. The plot shows source mechanisms and observed events, not a correction-path
witness that the backend does not return. Minimum matching weight is not logical
maximum likelihood; overflow and class-cost availability remain explicit.

Recovery uses the actual Azure LRC(12,2,2) counted-repair interpretation: six data
resource capacities, local parity, two global parity capacities and round-robin
demand. The default is the existing HostileInstances benchmark scenario, seed 2026,
with capacities [14,2,1,2,4,2,0,0,9] and six pending repairs. It is a modeled
application workload, not a production trace. The old GF(256) RS display remains
in historical source/data and is not misrepresented as runnable LRC functionality.

One retained plan serves repaired count, target decision, six-by-three repair-mode
counts, nine resource loads and a batched comparison of neighboring budgets. Extra
capacity splits between global parity domains, with the odd unit assigned to the
first. The comparison range respects u32 capacity admission; valid current queries
remain usable even when no positive top-up is admissible. The default scenario is
data-limited: extra parity alone does not increase its one repaired shard. This
optimizes counted repair capacity, not recovery of user file bytes.

FT10 remains an inspect-only precedence/machine view: these modules do not provide
a general FT10 job-shop solver. Existing specialized native scheduling capabilities
remain part of the wider C1130 inventory; no new mathematical solver was invented
for this demonstration. The Hadamard corpus views retain their actual weighted data.

## Inverse parity frontier and result hierarchy

The recovery result now plots minimum extra global-parity capacity against desired
repairs. Batched binary searches call the existing WASM count readout on the same
plan, holding all input capacities and demand fixed. The current balanced top-up
rule remains part of the query; this is not an optimizer over arbitrary allocations
between parity domains. The search stops once both global parity domains can cover
the whole demand, or at the checked u32 top-up limit. Only the former establishes
that remaining unattainability comes from non-global resources. Targets beyond
demand remain unattainable. For more than 128 pending repairs, targets are sampled
and labelled as such; every returned point is exact, and the requested target is
always included. No arbitrary budget-search cutoff is presented as impossibility.

The result panel has a distinct Result label, large repaired/demand metric, explicit
target status, current query and direct minimum-budget conclusion. The inverse plot
sits directly beneath the answer, with the current budget and selected target marked.
Hover/focus exposes exact point values. Unattainable targets occupy a separate marked
row rather than a fabricated numeric cost. Run brings the result into view and focuses
its labelled region. QEC uses the same result hierarchy. Redundant repair-request
heading and post-run instructional prose are removed; witness loads remain below.

Browser checks compare the whole small parity-limited frontier with independent
enumeration of local/global repair totals, including minimum-cost predecessor
rejection; zero capacity, the actual default data bottleneck, excess demand and
saturated parity are also covered. Existing native-reference, witness, plan reuse,
portable import/replay and narrow layout checks remain active. One expanded run
failed loading a later QEC Worker; the Worker error handler now retains error text
and source location. Subsequent execution passed; the intermittent load failure's
root cause is still unestablished and must not be described as fixed.

## General loading and persistence boundaries

Load accepts family JSON, raw .dem, portable schema-1 CampaignSpec/checkpoint JSON
and portable bundles. Download input preserves edited queries and reopens read-only.
Portable CampaignSpec/checkpoints retain the existing Check reduction, Solve and
checkpoint replay controls. Bundles remain inspection-only without an implicit
executable-domain conversion. Opening data is distinct from activating a solver.

Application diagnostic results include the actual query, source/model-byte digest,
provider digest and Worker-generation-scoped plan handle. They are not portable
RunRecord/checkpoints or independent certificates. Application-to-CampaignSession,
repository/bundle execution and main campaign-console integration remain future work.
The UI does not present unsupported application checkpoint or continuation buttons.

## Validation and replay

Private analysis/campaign-console/mockups/README.md gives exact build/serve/test
commands. Committed application-inputs.json, application-references.json,
prepare-applications.py and application-validation.json bind the fixture, native
answers, provider manifests, canonical engine hash and retained test outputs.
The provider binaries are the previously validated proprietary-notice payloads
from private `5da6805`; the browser slice introduces no alternate WASM build.

Actual Chromium gates pass:

- QEC minimum weight, parity, defect count, overflow and class costs versus native;
  changed/repeated queries under the same compiled plan and Worker generation.
- LRC counts and budget batch versus native; target decisions; independently
  reconstructed witness loads and demand/capacity checks; saturated-capacity case.
- Selection preserves execution context; query changes clear results; replacement
  inputs are used; malformed inputs preserve accepted context; downloads reopen as
  snapshots; raw DEM executes after explicit creation.
- Imported portable problem has the independently evident optimum/witness, followed
  by checkpoint replay; portable bundle remains inspect-only; FT10 has no Run action.
- Six presentation views preserve shared corpus selection, weighted baseline,
  QEC round slices and all 100 FT10 operations. Narrow viewport has no horizontal
  overflow. Desktop and narrow screenshots were visually inspected.

The pure JS contract gate compares all QEC display geometry/mechanisms with the
Stim fixture and rejects unsupported schemas/queries; it checks the index-layout
fallback and LRC resource shape. Provider/native allocation and performance gates
remain those of the module spike: no solver code or binaries were rebuilt here.
There is no new native performance claim.

Final application log and output are sealed in application-validation.json;
retained screenshots live under ~/.cache/ergodis/application-workspace/.
One expanded harness run observed a missing result during its import sequence;
per-action rejection diagnostics and explicit context assertions were added.
Three subsequent full replays and the later expanded final gates passed. The
transient's root cause was not established; no numerical disagreement was observed.

Preview PID/log locations: ~/.cache/ergodis/application-workspace/ for 8770;
~/.cache/ergodis/input-query-mockups/ for the updated 8769 alias. The old cached
page is historical data, not the page now served by that alias.

## Remaining C1130 gates

Within-provider plan reuse suffices for this single-Worker application session.
It does not close native cross-worker immutable-plan sharing: the experimental
provider still has exclusive ownership and parallel workers duplicate plans.
Keep ABI adoption open through shared-plan/owned-executor tests and native
single/parallel performance acceptance. Add labelled composition as the third
family, integrate the execution surface with CampaignSession and the main console,
then perform the requested private glossary pass. Full capability inventory and
closure still include wider recovery/scheduling/readouts/updates/checkpoints and
removal/generalization of arbitrary spike bindings (including QEC's one-observable
limit). This browser milestone does not close full WASM feature completeness.
