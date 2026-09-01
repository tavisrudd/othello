# C1031 — what Ergodis already emits, and what a dashboard can therefore show

**Lane**: `complete-ports`
**Task**: C1031
**Date**: 2026-08-31
**Charter**: `notes/2026-08-31-c1031-ergodis-visualization-goal.md`

Everything below was established by reading the Ergodis control plane and by running a real campaign
end to end, not by inference from documentation. The run was performed in the dedicated worktree at
`/home/tavis/.cache/c1031-ergodis-viz` on branch `c1031-ergodis-viz`; no Ergodis core source was
modified anywhere.

## Headline

A dashboard needs no new instrumentation in the Ergodis core to get its primary data. A campaign run
directory is already a complete, self-describing, append-only record of the search, and the daemon
evolution path already writes a full parent-child lineage graph with labelled mutation operators.
The visualization problem is a rendering and interpretation problem, not a telemetry problem.

There is one real gap, described under "The two evolution paths do not emit the same evidence"
below, and it decides which entry point a lineage view must be built on.

## The campaign run directory

`ergodis-campaign --data <batch.jsonl> --run-dir <dir> --socket <path>` creates a private run
directory, mode 0700, containing exactly three things:

- `manifest.json` — schema, run id, nonce, socket path, pid, code commit, the BLAKE3 hash of the
  input feature batch (`presentation_hash`), the problem name, and the feature-generator provenance.
  This is the provenance header for everything else, and it is what lets a view state exactly which
  code and which inputs produced what is on screen.
- `ledger.jsonl` — the durable append-only event log, byte-capped, flushed on every append. Each
  record is `{seq, epoch, kind, synopsis, plan}`. The event kinds emitted are `started`,
  `group-compiled`, `tree-synthesized`, `candidate-tested`, `evolution-started`,
  `evolution-finished`, `exceptional-query`, and `note`. `note` is operator-written annotation, so
  the log already interleaves what the machine did with what a person observed — a timeline view
  gets human commentary for free.
- `evidence/` — the bulk artifacts: batch evaluation results, synthesized decision-tree plans, and
  evolution lineage files, each named by a caller-supplied slug.

In memory the campaign additionally holds an event ring of the most recent 256 events and up to 64
watchers, so a live view can subscribe rather than poll. Limits worth knowing when sizing a UI: at
most 64 active plans, at most 4096 archived outcome classes, at most 4096 candidates per batch, a
64 KiB protocol frame, and a 10-second socket timeout.

## The data being searched over

A campaign's input is a JSONL feature batch under schema `ergodis-campaign-data-v0`. The header
gives `presentation`, `problem`, the ordered `fields` list, the row count, and optional generator
provenance; each subsequent line is `{id, weight, expected, values}` where `values` is a vector of
integers aligned to `fields`.

So the search space is, concretely, **a labelled set of mathematical objects described by integer
feature vectors, with `expected` recording whether the property of interest holds.** The example
used for this exploration is the C880 live branch-ordering batch, whose fields are `depth`,
`selected_count`, `candidate`, `branch_count`, `unresolved_count`, `child_unresolved_count`,
`child_packing`, `root_candidate`, `root_orbit`, `root_ordinal`, `root_total`, `root_sized`,
`root_initial_unresolved`, `root_initial_packing`, and `root_initial_branches`. Several of those are
root-indexed, which matters for the root-count view the user asked for.

## What a candidate theorem is

A plan is a document under schema `ergodis-attack-plan-v0`, in either of two surface forms that
`PlanDocument` accepts untagged:

- an **expression** form, `ExpressionPlanSpec`, whose `expr` is a tree over
  `field`, `const`, `add`, `sub`, `mul`, `min`, `max`, `eq`, `ne`, `lt`, `le`, `gt`, `ge`, `and`,
  `or`, `not`, `abs`, and `select`; and
- a **bytecode** form, `PlanSpec`, whose `program` is a flat stack-machine op list.

`ExpressionPlanSpec::lower` compiles the first into the second, bounded at 128 nodes and depth 32.
Every plan carries a `role` of either `diagnostic` or `ordering` and an `output` of either
`predicate` or `score`, plus an optional `scope` restricting it to a field and a bit mask.

The consequence for visualization is direct: **the expression tree is the natural visual object for
a single theorem, and the text form in `control/text.rs` is an equivalent serialization of the same
thing.** A visual plan editor and the existing plan text syntax are two views of one artifact, so a
graphical editor could round-trip through `parse_expression_plan` / `format_expression_plan` with no
new format. Note the expression is a tree, not a general DAG — there is no sharing of subterms — so
tree layout, not general graph layout, is the right choice for this view.

## What evaluating a theorem produces

`Evaluation` records `rows`, `weighted_rows`, `weighted_correct`, `weighted_false_positive`,
`weighted_false_negative`, `weighted_true`, `first_mismatch`, `first_false`, `minimum_score`,
`maximum_score`, and `outcome_hash`.

Two of these deserve emphasis.

**`outcome_hash` is a behavioral descriptor.** It is a BLAKE3 hash of the plan's predicate bit-vector
across all rows, so two syntactically different plans with the same hash are indistinguishable on the
current data. The campaign keeps `archive: BTreeMap<outcome_hash, plan_name>` and reports
`outcome_classes` in `status`. This is quality-diversity structure that already exists: the search's
real progress is not how many candidates were tested but **how many distinct behaviors were found**,
and the ratio of the two is a direct, already-computed measure of how redundant the search has
become. That ratio is the strongest available "are we stuck?" signal and it should be on the front
page of any operator view.

**`first_mismatch` and `first_false` are counterexample pointers**, and the evolution evidence
expands the first of them into a `first_obstruction` object carrying the full named feature map of
the offending row. That is exactly the material the teaching goal needs: for any rejected candidate
theorem, the UI can show the specific mathematical object that refutes it, with every feature
named.

## The two evolution paths do not emit the same evidence

This is the one finding that changes what to build, and it was found by running both.

`ergodisctl evolve` runs the beam search **client-side** and writes records shaped
`{generation, plan, result:{hash, equivalent_to, evaluation, first_obstruction, groups}}`. On the
example run this produced 735 candidates across four generations — and **no `parent_hash` and no
`operator` on any record.** There are no lineage edges in this file at all. It is a flat population
log with rich per-candidate detail.

`ergodisctl evolve-start` runs the same beam search **inside the daemon** via
`control/evolution.rs`, streams to `evidence/<slug>-<job id>.jsonl`, and writes records shaped
`{generation, parent_hash, operator, plan, hash, equivalent_to, evaluation}`. On the example run this
produced 257 candidates, 253 of which carry a parent, across four generations, with the mutation
operator labelled on every record. The operators observed were `seed`, `scope-initialize`,
`field-substitute`, `comparison-substitute`, `constant-shift`, and `scope-toggle`. Both runs found
the same four outcome classes.

**Therefore any lineage or genealogy view must be built on `evolve-start`, not on `evolve`.** The
client-side path can drive a population or archive view but cannot draw the tree. Conversely the
daemon path currently omits `first_obstruction`, so the counterexample detail that the teaching view
wants lives only in the client-side file. Neither file alone supports both views.

The cheapest resolution, and a candidate follow-up task, is to make the two record shapes converge —
add `parent_hash` and `operator` to the client-side path, or `first_obstruction` to the daemon path,
or define one evidence schema and emit it from both. That is a core change and so is out of scope
for this task's main tree; it should be raised as its own C-item rather than smuggled in here.

## Search progress and completion estimates

The daemon exposes `EvolutionProgress` as `{tested, generation, perfect, done, cancel_requested}`,
updated with relaxed atomics on a cache-line-padded 64-byte struct, and pollable through
`evolve-status`. The completed-job summary adds `tested`, `perfect`, `outcome_classes`,
`structural_rejections`, `outcome_expansion_rejections`, `cascade_rejections`, `rows_evaluated`,
`bytes`, `truncated`, `cancelled`, `low_priority`, and the `best` candidate with its
`weighted_correct`, `false_positive`, and `complexity`.

For the completion-time estimate the user asked for, the available and reliable basis is:
`max_candidates` and `generations` are hard bounds set at launch, `tested` is a live monotone
counter against them, and the three rejection counters decompose *why* candidates are being
discarded. A remaining-time estimate is therefore a straightforward extrapolation of the tested rate
against the candidate bound, and it can be made much better than a naive linear projection by
conditioning on generation, because per-generation candidate counts are visibly uneven — the example
run went 4, 66, 89, 98. The rejection counters also give the estimate an accuracy caveat worth
displaying: when `cascade_rejections` dominates, candidates are being abandoned early and the
per-candidate cost is far below average, so a rate extrapolated from a cascade-heavy stretch will be
too optimistic once the beam refills.

Beam search also gives a genuine notion of *reduction* rather than just progress. `can_enter_beam`
prunes a candidate as soon as its best possible completion cannot enter the survivor set, ranked by
`(weighted_correct descending, false_positive ascending, complexity ascending)`. `structural_rejections`,
`outcome_expansion_rejections`, and `cascade_rejections` are three named, separately counted
mechanisms by which the candidate space is cut down. Showing those three as a live decomposition of
the search funnel answers "what is the search actually doing right now" better than any single
number, and it is already computed.

## The state-space and reduction views the user asked for

Recorded on 2026-08-31 as an explicit requirement, and mapped here to what exists.

1. **The space being searched.** Two different spaces are in play and must not be conflated: the
   *object space*, which is the row set of the feature batch, and the *theorem space*, which is the
   set of expressible plans. The object space has a natural view — rows as points in the named
   feature coordinates, with `expected` as the label. The theorem space is only ever sampled, never
   enumerated, so the only view that can be supported by evidence is the archive of discovered
   outcome classes rather than the space itself.
2. **Reduction by a provided or learned theorem.** An active `diagnostic` plan partitions the rows;
   an `ordering` plan sorts them. Applying a plan to the object-space view and shading rows by
   predicate outcome shows directly how much of the space that theorem accounts for, and
   `weighted_false_positive` and `weighted_false_negative` show exactly where it fails. Composing
   several active plans shows the residual — the part of the space no current theorem explains —
   and that residual is the thing an operator most needs to see.
3. **Root counts.** The C880 feature set is explicitly root-indexed, with `root_orbit`,
   `root_candidate`, `root_ordinal`, `root_total`, `root_sized`, and the three `root_initial_*`
   fields. Grouping the object space by root and showing surviving-candidate counts per root is
   therefore available today with no new data. `ceiling` gives the exact best possible
   classification achievable from the current feature vectors, so a per-root ceiling is a hard,
   computed bound on how much reduction any theorem over these features could ever deliver — that
   is the right denominator for a reduction display, and it is far more informative than progress
   against an arbitrary target.
4. **Completion estimates.** As described in the previous section.
5. **Decision-tree attacks.** `synthesize` learns a bounded exact decision tree and writes it as a
   replayable plan, emitting a `tree-synthesized` event. A learned tree is itself a second natural
   tree-shaped visual object, and its splits are literally a recursive reduction of the object
   space — the same view as item 2, applied recursively.

## Operator affordances the CLI already exposes

`ergodisctl` verbs, which a UI would wrap rather than replace: `capabilities`, `status`, `noop`,
`probation`, `pulse`, `plan-get`, `ceiling`, `group-compile`, `synthesize`, `agent-brief`, `try`,
`batch`, `evolve`, `evolve-start`, `evolve-status`, `evolve-cancel`, `apply`, `deactivate`,
`obstruction`, `exceptional`, `trace`, `note`, `shutdown`.

Three are worth calling out for a UI. `try` evaluates a candidate without activating it, which makes
a what-if panel safe by construction. `exceptional` ranks and returns at most 32 outlier rows by a
plan's value, which is a ready-made "show me the interesting objects" query. `trace` writes one
bounded localized evaluator trace under the run directory, which is the per-row execution detail a
teaching view needs to animate a single evaluation through the expression tree.

`--json` on every command emits the stable response envelope
`{schema, request_id, run_id, epoch, ok, result}`, so a backend can shell out to `ergodisctl` and
forward results verbatim without reimplementing the protocol. That is the fastest credible path to a
working web UI and it requires no core changes at all.

## Constraint that bounds every design

The control plane is feature-gated behind `control-plane` in `ergodis/Cargo.toml` and is documented
as existing so that ordinary solves retain no controller state, filesystem traffic, atomics, or
hot-loop branches. No dashboard proposal may put instrumentation in the solve hot path. In practice
this is not limiting, because everything above is already produced outside that path.

## Reproduction

Built and run in the worktree, release profile, feature `control-plane`:

```
cargo build --release --features control-plane --bin ergodis-campaign --bin ergodisctl
./target/release/ergodis-campaign \
  --data ergodis-private/examples/data/campaign-c880-live-ordering.jsonl \
  --run-dir <run> --socket <run>.sock
./target/release/ergodisctl --run-dir <run> --json evolve-start \
  --evidence-name lineage2 --generations 4 --beam 16 --max-candidates 1200 <seeds>.jsonl
```

The seed file was four hand-written diagnostic predicates over the C880 fields. The C880 batch is a
two-row smoke fixture, which is enough to exercise every code path and to produce a real 257-node
lineage graph, but it is too small to make a visually interesting object-space view. Producing a
larger real feature batch is a prerequisite for a convincing demo and should be treated as part of
the prototype work rather than assumed away.
