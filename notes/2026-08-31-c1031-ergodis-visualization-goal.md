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

### Still to survey

- **Remaining experiment-tracking dashboards**: Weights & Biases, Aim, TensorBoard, Ray Dashboard,
  MLflow. Take the interaction patterns for long-running jobs — live metric streams, run comparison,
  and pruning/early-stop display. The Optuna entry above already covers the core pattern; this is
  for what the others add beyond it.
- **Proof and certificate presentation**: the Lean infoview, Alectryon, Why3's IDE, Isabelle/jEdit,
  proof-object and dependency-graph browsers. The question to answer: how do these make a
  machine-checked object legible without asking the reader to read the whole object?
- **DAG layout engines**, which the library survey above did not settle: ELK, dagre, d3-dag, and
  Sugiyama-style layered layout generally. Layout cost was named as a dominant performance factor,
  so this is the open half of the rendering question. Also check GPU-accelerated large-graph
  renderers such as Cosmograph.
- **Provenance and workflow-DAG UIs**: Airflow, Prefect, Dagster, Nextflow Tower, and the W3C PROV
  visual conventions. These solve "show a large DAG of completed and running work to an operator"
  and their affordances are worth copying rather than reinventing.
- **Program-synthesis and genetic-programming lineage tools**, and MAP-Elites archive
  visualizations specifically, since the archive-class structure in the control plane
  (`MAX_ARCHIVE_CLASSES`) is quality-diversity shaped.
- **Rust TUI**: `ratatui` as the low-cost path, plus what a Rust web backend would look like
  (`axum` + server-sent events or WebSocket over the existing Unix socket).

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

**Next step on resume**: read OpenEvolve's `scripts/visualizer.py` as actual code — it is the
closest existing thing to the evolve-campaign view and will either be adaptable or will show why
not. Then settle the DAG layout-engine question left open above. Then read
`ergodis/src/control/vm.rs` and `ergodis/src/bin/ergodisctl.rs` in full to fix the real data model
before writing any UI code. Only after those three should the prototype be started.
