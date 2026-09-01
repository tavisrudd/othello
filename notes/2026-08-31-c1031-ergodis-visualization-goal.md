# C1031 — Ergodis visualization and operator dashboard: 4-hour exploration charter

**Lane**: `complete-ports`
**Task**: C1031
**Allocated**: 2026-08-31
**Status**: CHARTERED; NOT STARTED
**Budget**: 4 hours of working time, measured from the first resume after the current
usage-quota window resets — not from the 2026-08-31 chartering session, which was cut short by
quota within minutes of allocation.

## Resume protocol

This document is the authority for the task. On any resume — new session, compaction, or a pause
caused by a usage-quota window — do this and nothing else first:

1. Read this file completely.
2. Read the **Progress log** at the bottom. It records elapsed budget and the exact next step.
3. Continue from that next step. Do not re-plan from scratch and do not re-run the state-of-the-art
   survey if the log says it is done.
4. Append to the progress log at every stopping point, including the elapsed-time accounting, so
   the next resume is cold-readable.

The 4-hour budget is wall-clock working time actually spent on the task, summed across resumes,
not 4 hours of calendar time. Quota pauses do not consume budget.

## Goal

Explore how Ergodis can show what it is doing and what it has found. Two audiences, both first
class:

1. **Teaching and explanation.** Someone who does not know the system should be able to watch a run
   and come away understanding what a solve, a certificate, and an evolution campaign actually are,
   and why a particular result follows from a particular chain of steps.
2. **Operator situational awareness.** Someone running a long campaign should be able to see, at a
   glance and then in depth, what has been found, what is currently being explored, where the search
   is stuck, and where the interesting frontier is.

The deliverable of this task is a decision-grade exploration, not a finished product: a surveyed
design space, a recommended architecture, and at least one working vertical-slice prototype against
real Ergodis output.

## What there is to visualize

Concrete substrate already present in the tree. Confirmed by inspection on 2026-08-31.

- **Ergodis core**: `papers/complete-repair-ports/ergodis/`. Private adapters and campaign fixtures:
  `ergodis-private/` (sibling; one-way dependency, private never crosses into core).
- **Control plane**: `ergodis/src/control/` is a feature-gated experimental control plane for long
  theorem-search campaigns, deliberately built so ordinary solves carry no controller state. It
  already has almost everything a dashboard needs as a data source:
  - `mod.rs` — `Campaign`, `Manifest`, `Request`, `Response`, a Unix-socket server (`serve`), a
    256-entry event ring, up to 64 watchers, and a run directory. Schema strings are
    `ergodis-control-experimental-v0`, `ergodis-campaign-data-v0`, `ergodis-attack-plan-v0`.
  - `vm.rs` — the attack-plan expression VM: `PlanExpr`, `PlanOp`, `PlanSpec`, `PlanDocument`,
    `CompiledPlan`, `Evaluation`, `PlanRole`, `PlanScope`, `FeatureBatch`,
    `FeatureGeneratorProvenance`. **Plans are already DAGs of operations** — this is the most
    obvious native DAG in the system and the strongest candidate for the central visual object.
  - `text.rs` — `parse_expression_plan` / `format_expression_plan`, a human-readable plan syntax.
    A visual plan editor and a text plan are therefore two views of one artifact.
  - `evolution.rs` — `run_evolution`, `EvolutionBounds`, `EvolutionProgress`: the evolve campaigns.
  - `synthesis.rs` — `learn_decision_tree`: another native tree/DAG object.
  - `client.rs` — `PlanArena`.
- **Operator CLI**: `ergodis/src/bin/ergodisctl.rs` already exposes the verbs a dashboard would
  wrap: `status`, `pulse`, `trace`, `note`, `agent-brief`, `candidate-apply`,
  `candidate-deactivate`, `feature-ceiling`, `obstruction-first`, `exceptional`, `evolve-cancel`,
  `shutdown`. Read the exact request/response shapes from this file rather than guessing.
- **Campaign driver**: `ergodis/src/bin/ergodis_campaign.rs`; RPC entry `ergodis_rpc.rs`;
  `theorem_search.rs`; `binary_kernel_search.rs`; shard ledger in `css_distance_shard_ledger.rs`.
- **Private-side campaign machinery** (untracked or new as of 2026-08-31, check before relying on
  it): `ergodis-private/src/bin/campaign_rpc.rs`, `blind_evolve_harness.rs`,
  `blind_raw_holdout_harness.rs`, `banked_rule_evolve_*`, `banked_semantic_evolve_*`,
  `g133_evolve_adapter.rs`.
- **Evidence and certificates**: `ergodis-private/evidence/*.json`,
  `ergodis-private/examples/data/campaign-*.jsonl`, and the reproducibility bundles described in
  `notes/research-reproducibility-conventions.md` (report + generator + compact certificate +
  SHA-256 hashes + replay command).

The four object families the dashboard must cover, in the user's words: **results, certificates,
traces, and live solves or evolve campaigns.**

Added by the user on 2026-08-31 as explicit further requirements, all first-class deliverables
rather than extras:

- **The search state spaces and how they are reduced**, by theorems that were provided and by
  theorems the system learned, together with **root counts**, the reductions themselves, and
  **estimates of completion time**.
- **A replay and performance view**, in the manner of the csysdig and sysdig explorer views over a
  recorded trace: Ergodis's own events scrubbed against machine performance data — counters, CPU,
  resident set — wherever that data is available.
- **The C1016 evolution feature graph and its progress display**, as a source of ideas.
- **The compilation itself**, visualized as its own object.
- **The quotient DAG and tablebase.**
- **A live operator surface, not a static infographic.** Every element on screen must be one that
  could realistically exist in a running system: generic, driven only by data a campaign emits, and
  correct for any run rather than written about one. Case-specific narrative prose is out. Large
  numbers are shown in scientific notation.

The last three turn out to be one shape of object — a staged reduction cascade with a surviving root
count at every node — and the C1016 record already holds the numbers, including real `perf stat`
instruction, cycle, and resident-set counters for completed compilations. The companion note works
this through.

The companion note `notes/2026-08-31-c1031-ergodis-visualization-data-model.md` records what the
system actually emits, established by reading the control plane and by running a real campaign end
to end. It maps each of the requirements above onto data that already exists, and it identifies the
one real gap: the client-side `evolve` path emits no parent or operator fields, so lineage views
must be built on the daemon-owned `evolve-start` path instead. Read it before designing any view.

## State of the art to survey

A partial survey was done in the chartering session before quota cut it off. What follows is the
seeded list; the task should extend it, not restart it.

### Already found (2026-08-31, chartering session)

- **OpenEvolve** — the open-source implementation of Google DeepMind's AlphaEvolve. Ships
  `scripts/visualizer.py`, which is close to a direct template for the evolve-campaign view: a
  network visualization of the program-evolution branching, node radius set by the fitness metric
  currently selected, parent/child navigation, click-through to a node's code and prompts in a
  sidebar, real-time metric tracking to spot convergence, and node highlighting by selected metric
  such as top score or MAP-Elites cell membership. Read this code before designing the lineage view.
  <https://github.com/algorithmicsuperintelligence/openevolve>
- **SATVIS** — interactive visualization of saturation-based proof attempts in the Vampire
  first-order theorem prover. The closest prior art for "explain why this conclusion followed":
  <https://arxiv.org/pdf/2001.04100>
- **SAT-IT** — a web-based interactive CDCL tracer whose distinguishing feature is non-linear
  "what-if" exploration: the user reverts the solver to a chosen decision and it re-simulates the
  preceding assignments. Directly relevant to the teaching goal.
  <https://arxiv.org/html/2606.28819>
- **SAT-Web** — browser-only educational SAT visualization with search trees and variable
  interaction graphs over a traced DPLL solver. <https://ceur-ws.org/Vol-4008/POS_paper08.pdf>
- **SATViz** — real-time animation of clausal proofs, focused on recently learned clauses.
  <https://arxiv.org/pdf/2209.05838>
- **SATGraf** — visualizes how the community structure of a CNF formula evolves during solving.

- **Optuna Dashboard** — the reference design for watching a long optimization run. Its Live Update
  mode continuously refreshes the optimization-history plot, the hyperparameter-importance ranking,
  and the analytics sections, so an operator can see convergence starting and intervene or stop
  early. Its parallel-coordinates plot is the standard way to show high-dimensional configuration
  space against an objective; there is an OptunaHub variant that draws the trajectories as monotonic
  Pchip curves instead of straight lines specifically to cut visual clutter in high dimensions.
  Worth copying: live-update semantics, importance ranking as a first-class panel, and
  parallel coordinates as the campaign-configuration view.
  <https://optuna.readthedocs.io/en/stable/tutorial/10_key_features/005_visualization.html>
  and <https://hub.optuna.org/visualization/>
- **Interactive graph library landscape, as of 2026.** The working rule from current comparisons is:
  Cytoscape.js when graph algorithms and layouts are part of the product rather than setup code
  (it is the richest all-in-one toolkit, ~500K weekly downloads); Sigma.js when the graph is large,
  because it is a WebGL renderer over graphology and handles 100K+ nodes, at the cost of not being
  batteries-included for analysis; vis-network for interactive diagrams; AntV G6 for small to
  moderate graphs with rich styling; React Flow for node-based editor UIs, low-code workflow
  builders, and diagram builders, but it is weak for large-scale exploratory graph analysis. The
  comparisons also warn that published node-count limits are directional only — layout cost, edge
  density, label rendering, and hit-testing dominate real perceived performance, so any choice has
  to be tested on a representative Ergodis graph on the target machine.
  <https://www.pkgpulse.com/guides/cytoscape-vs-vis-network-vs-sigma-graph-visualization-2026>
  and <https://linkurious.com/blog/top-javascript-graph-libraries/>

  Provisional read for this task, to be confirmed rather than assumed: an attack-plan DAG is small
  and editor-shaped, which points at React Flow or Cytoscape.js; an evolution lineage graph over a
  long campaign is large and exploratory, which points at Sigma.js. If both views are wanted, that
  is an argument for two renderers rather than one compromise.

- **Alectryon**, with **LeanInk** as its Lean 4 adapter, is the reference answer to the question of
  how a machine-checked object is made readable without asking anyone to read the whole object. It
  processes Rocq and Lean snippets embedded in ordinary prose and shows the goal state and the
  messages for each input sentence, so the proof is presented as a document with the machine's
  intermediate state available on demand rather than as a listing. Its interaction grammar is worth
  copying wholesale: interactive fragments are marked with bubbles, hovering reveals detail, tapping
  pins it open, and keyboard navigation moves between fragments. The lesson for Ergodis is that the
  narrative stays primary and the machine state is progressively disclosed underneath it — which is
  exactly the shape the teaching goal needs for a plan and its evaluation.
  <https://github.com/cpitclaudel/alectryon> and <https://github.com/leanprover/LeanInk>
- **Layered DAG layout engines.** The current picture is that `d3-dag` is a small bundle against
  elkjs's roughly 500 KB of transpiled Java, offers layering, coordinate-assignment, and
  crossing-minimization strategies that dagre does not — including an integer-programming-optimal
  crossing minimization and the Zherebko and Grid layouts — and its fast quality preset runs about
  four times faster than dagre version 3 while its medium preset is about twice as slow with better
  output. ELK is the layer-based engine to reach for when nodes have ports and an inherent
  direction. Cytoscape.js can drive dagre, elkjs, or webcola behind one interface, which is a
  reasonable hedge. No published benchmark compares all three head to head on a graph like ours, so
  the choice should be settled by testing on a real lineage graph.
  <https://github.com/erikbrinkman/d3-dag> and <https://arxiv.org/pdf/2311.00533>

  In the event the prototype needed none of them: a generation-layered lineage graph and a staged
  compilation cascade both have a known layer assignment, so the only real work is ordering within a
  layer, which a parent-position sort handles well enough at this scale. Reach for a layout library
  when a view appears whose layering is not already given by the data.

### Still to survey

- **Remaining experiment-tracking dashboards**: Weights & Biases, Aim, TensorBoard, Ray Dashboard,
  MLflow. Take the interaction patterns for long-running jobs — live metric streams, run comparison,
  and pruning/early-stop display. The Optuna entry above already covers the core pattern; this is
  for what the others add beyond it.
- **Proof and certificate presentation**: the Lean infoview, Alectryon, Why3's IDE, Isabelle/jEdit,
  proof-object and dependency-graph browsers. The question to answer: how do these make a
  machine-checked object legible without asking the reader to read the whole object?
- **Provenance and workflow-DAG UIs**: Airflow, Prefect, Dagster, Nextflow Tower, and the W3C PROV
  visual conventions. These solve "show a large DAG of completed and running work to an operator"
  and their affordances are worth copying rather than reinventing.
- **Program-synthesis and genetic-programming lineage tools**, and MAP-Elites archive
  visualizations specifically, since the archive-class structure in the control plane
  (`MAX_ARCHIVE_CLASSES`) is quality-diversity shaped.
- **GPU-accelerated large-graph renderers** such as Cosmograph, which matter only if a campaign's
  lineage grows past the tens of thousands of nodes that plain SVG stops handling comfortably.

### Search hygiene

If any part of the survey ends up supporting a paper-facing novelty or priority claim, it must
follow `notes/literature-audit-conventions.md`. A design survey for internal tooling does not.
Check the shared literature cache at `/tmp/persistent/tavis/lit-search/` before fetching any paper.

## Design questions the exploration must answer

1. **What is the central visual object?** Candidates: the attack-plan DAG from `vm.rs`; the
   evolution lineage tree; the certificate dependency graph; a campaign timeline. Probably more than
   one view, but one of them is the front door and that choice drives everything else.
2. **How does a result connect back to its evidence?** The teaching goal is only met if a user can
   start from a finding and walk backwards through the trace to the inputs and the certificate that
   support it, and forwards from an input to what it enabled.
3. **What does "stuck" look like on screen?** Operators need to see a plateau, a saturated feature
   ceiling, or an unproductive branch without reading a log.
4. **Live versus post-hoc.** Is the same UI serving a running campaign over the control socket and a
   finished run from its on-disk artifacts, or are those two different tools? Prefer one tool with
   two data sources if it can be done without contorting either.
5. **TUI or web.** The user's stated preference is that a rich interactive web UI with DAG
   visualization would be better, with a simple TUI as the acceptable fallback. Decide on evidence,
   including how much of the control plane's data is already JSON-over-socket and therefore nearly
   free to serve to a browser.
6. **What must not change.** The control plane is deliberately feature-gated so ordinary solves
   carry no controller state, filesystem traffic, atomics, or hot-loop branches. Any dashboard
   proposal that requires instrumenting the hot path is wrong unless it stays behind the same gate.

## Deliverables

1. A dated survey and design note under `notes/`, covering the state of the art with named tools and
   what each one contributes, the design-question answers above, and a recommended architecture.
2. At least one working vertical-slice prototype driven by real Ergodis output — not a mockup with
   invented data. The cheapest real slice is likely: render one real attack-plan DAG, or one real
   evolution lineage, in a browser from an actual run directory or checkpoint.
3. A short list of what a full build would cost and what the next task should be, with an EV call.
4. The `ej` + `tt` closeout pass and a Mystery ledger, per the workspace guide's rule for
   substantial C-items.

## Scope and constraints

- **Working-tree rule, set by the user on 2026-08-31 and binding for the whole task.** In this main
  tree the task is design only: notes, surveys, and design documents. No Rust changes to the Ergodis
  core here at all. Any prototype code — Rust or otherwise — goes in a separate git worktree.
  Reading the core, and building or running it to produce sample data, is fine; editing it here is
  not. This is not much of a constraint in practice, because the lineage and ledger artifacts
  described below are already written to disk by the existing code, so a viewer needs no core
  changes to have real data.
- **Owned paths**: `ergodis-private/` for adapters, fixtures, and any prototype that depends on
  private research identifiers; `papers/complete-repair-ports/ergodis/` only for changes that are
  genuinely reusable and public-surface-safe. This task is exploration — prefer writing the
  prototype on the private side and keep the public Ergodis surface untouched unless there is a
  clear reason.
- The public Ergodis surface is under an 84-file gate per the `complete-ports` handoff. Do not add
  public files without checking that gate first.
- Do not touch the manuscript, the Lean packages, or any other lane's work.
- This is tooling, not a paper claim. The manuscript admission rule does not apply, and nothing here
  enters the paper spine.
- The lane peg is `complete-ports` because that lane owns the Ergodis source tree. If this line of
  work continues past C1031, a dedicated lane is probably the right structure — raise it with the
  user rather than deciding it here.

## Progress log

Append one entry per stopping point. Record elapsed working time so the 4-hour budget is auditable.

### 2026-08-31 — chartering only, ~0h of budget consumed

Allocated C1031, inspected the Ergodis control plane and CLI surface to establish what data exists,
ran two of the planned state-of-the-art searches, and wrote this charter. The quota window ended
minutes into the session, so the budget clock has not meaningfully started.

A second short window later the same day added the Optuna Dashboard and the 2026 graph-library
comparison to the survey. A recurring in-session cron job was registered to re-enter this task
whenever the REPL is idle and quota permits; it is session-only and expires after seven days, so a
cold session must be resumed by hand from this file.

### 2026-08-31 — budget clock started 22:28 local; first working block

The user authorized starting, then set the working-tree rule recorded under Scope and constraints,
then added the search-state-space, reduction, root-count, and completion-estimate requirement.

Created the prototype worktree `/home/tavis/.cache/c1031-ergodis-viz` on branch
`c1031-ergodis-viz`. Built the Ergodis control-plane binaries there and ran a real campaign against
the C880 live-ordering fixture, then ran both evolution entry points. This produced a real 257-node
lineage graph with 253 parent edges, six named mutation operators, and four outcome classes, plus a
735-candidate population log. Wrote the findings up as
`notes/2026-08-31-c1031-ergodis-visualization-data-model.md`.

The load-bearing result is that no core instrumentation is needed: a run directory is already a
complete self-describing record, and `ergodisctl --json` already speaks a stable response envelope
that a backend can forward verbatim.

### 2026-08-31, second block — roughly 50 minutes of budget consumed in total

Built and published the vertical-slice console. It has five views over the real run: the reduction
cascade, the candidate lineage, the behaviour archive, the object space and its reduction, and the
step-by-step evaluation replay. Source lives in the worktree under `tools/c1031-viz`, committed
there as `0beac8b29`.

The user pointed at the C1032 browser-WebAssembly prototype, which changes the architecture
recommendation: the sequential Ergodis library runs in a browser Web Worker with native parity, so
the console can re-evaluate plans in the page rather than only replaying recorded output. Wrote the
recommendation up as `notes/2026-08-31-c1031-ergodis-visualization-architecture.md`.

### 2026-08-31, third block — roughly 1 hour 20 minutes of budget consumed in total

The user set the binding constraint that the console must be a live operator surface rather than a
static explainer: every element generic and data-driven, no case-specific narrative, scientific
notation for large numbers. Reworked the console accordingly and added the controls a live surface
needs. Ran the `ej` plus `tt` closeout, which found and fixed two real defects, and proved the
pipeline generic against a second independently created run. Task report with the Mystery ledger is
`notes/2026-08-31-c1031-ergodis-visualization-report.md`.

**Next step on resume**: the exploration deliverables are complete. Remaining budget is best spent
on whichever of these the user chooses — folding in the delegated terminal interface once it lands,
or hardening the console against a larger feature batch than the two-object smoke fixture. Ask
before starting a production build; it is not allocated.

**Superseded next step from the first block**: build the vertical-slice viewer in the worktree against
`/home/tavis/.cache/c1031-runs/run1`, starting with the lineage graph from the `evolve-start`
evidence file. Then read OpenEvolve's `scripts/visualizer.py` as actual code — it is the
closest existing thing to the evolve-campaign view and will either be adaptable or will show why
not. Then settle the DAG layout-engine question left open above. Then read
`ergodis/src/control/vm.rs` and `ergodis/src/bin/ergodisctl.rs` in full to fix the real data model
before writing any UI code. Only after those three should the prototype be started.
