# C1031 — Ergodis visualization exploration: task report

**Lane**: `complete-ports`
**Task**: C1031
**Date**: 2026-08-31
**Status**: exploration complete; production build not started and not allocated

## Companion documents

- Charter and state-of-the-art survey: `notes/2026-08-31-c1031-ergodis-visualization-goal.md`
- What Ergodis emits, established by running it: `notes/2026-08-31-c1031-ergodis-visualization-data-model.md`
- Recommended architecture: `notes/2026-08-31-c1031-ergodis-visualization-architecture.md`

## What was delivered

A surveyed design space, a recommended architecture, and a working console driven entirely by real
Ergodis output. The console has five views — candidate lineage, behaviour archive, object space and
its reduction, reduction cascade with cost, and evaluator replay — plus a rail carrying the campaign
counters, the mutation-operator distribution, and a signal-availability list reporting which
telemetry channels the loaded run actually has.

Prototype source lives on branch `c1031-ergodis-viz` in the worktree
`/home/tavis/.cache/c1031-ergodis-viz`, under `tools/c1031-viz`: `bake_run.py` reads a run directory
into one payload, `build.py` injects it into the page template, and `smoke.mjs` loads the built page
in headless Chromium, clicks every tab, and fails on any page error. A terminal interface was
delegated in parallel and is reported separately.

The main tree carries design documents only; no Ergodis core source was modified anywhere.

## Validation

- Headless Chromium gate on the primary run: 257 lineage nodes, 253 derivation edges, 8 cascade
  stages, 9 stage rows, 4 archive classes, 5 cost rows, 6 rejection rows, 2 trace panels, 200 ledger
  rows, 33 scientific-notation cells, no page errors, no horizontal overflow.
- **Genericity check.** A second, independently created campaign with different bounds — 159
  candidates, 155 edges, 3 ledger events, no client-side population file, and no evaluator traces —
  renders through the same pipeline with no page errors and correct counts, degrading gracefully on
  the artifacts it lacks. The console is a tool that reads run directories, not a page built around
  one run.

## Findings that change what should be built

1. **No core instrumentation is needed for the primary views.** A run directory is already a
   complete self-describing record, and `ergodisctl --json` returns a stable envelope a backend can
   forward verbatim.
2. **Lineage views must be built on `evolve-start`, not `evolve`.** The client-side path emits no
   parent or operator fields at all. The daemon path emits the genealogy but omits the
   first-obstruction detail the client-side path carries. Converging the two evidence schemas is a
   core change and belongs in its own task.
3. **Scope is a first-class visual element.** The best plan in the primary run restricts itself to
   one root orbit and only then compares two counts; outside that orbit it returns false for reasons
   unrelated to its formula, and a trace of an out-of-scope object contains zero operations.
4. **Reduction authority must be encoded in edge style.** Exact filters and necessary-only
   conditions are different claims, and the g41 cascade contains both.
5. **The one real gap is time.** No ledger event or progress record carries a timestamp. This blocks
   a completion estimate in seconds and the scrubable performance replay. One monotonic clock read
   per durable ledger event fixes it, on a path that already writes and flushes.

## `ej` + `tt` closeout pass

Run after the console passed its browser gate. Two genuine defects surfaced, both fixed.

**The behaviour count had no denominator, and the missing denominator inverted its meaning.** A
predicate over `n` objects can express at most `2^n` distinct bit-vectors. The primary run's batch
has two objects, so at most four behaviours exist, and the search found four. The console had been
reporting this as a 64:1 redundancy ratio — as though the search were wasting effort — when in fact
it had exhausted the behaviour space completely. The count now carries its ceiling and says so.

This generalizes into a display rule, and it is the same rule as the perfect-classifier one already
recorded: **a count of discovered things is meaningless without the size of the space it was drawn
from.** Both the behaviour count and the perfect-classifier count now carry theirs.

**The three rejection counters were drawn as one funnel, and they do not partition anything.** Their
sum, 286, exceeds the 257 candidates tested, which is what prompted the check. Reading
`control/evolution.rs`: `structural_rejections` counts duplicate candidate shapes discarded *before*
the tested counter increments; `outcome_expansion_rejections` is counted in the parent-selection
loop over survivors offered as expansion parents, an entirely different population; only
`cascade_rejections` is a subset of the tested candidates. They are now grouped by population, each
with its own denominator, and the view states that they do not sum.

**Free upgrades taken.** The baker turned out to be run-agnostic, so a second run was created and put
through the whole pipeline as a genericity gate rather than assumed. The headless gate was extended
to exercise every tab and to count the rendered elements of each view, so a view that breaks only
when shown fails the gate.

**Doors opened.** The baked payload is a single JSON contract over a run directory. The web console
and the delegated terminal interface can both consume it, which was not planned and means one reader
serves two front ends. The same payload is also the natural request body for a future backend, so
the prototype's data layer survives into production rather than being thrown away.

## Mystery ledger

- **Settled — where lineage lives.** Only the daemon evolution path writes parent and operator
  fields. Established by running both paths on identical seeds and bounds and profiling the record
  schemas.
- **Settled — why one evaluator trace is empty.** Scope exclusion, not a defect: the evaluator
  returns before executing any operation when the object is outside the plan's scope. Confirmed by
  reading `applies` and by tracing both objects, one inside the scope and one outside.
- **Settled — the rejection counters do not partition.** Three different populations, confirmed
  against the source, as above.
- **Settled — the behaviour archive was complete, not redundant.** Four of four expressible
  behaviours on a two-object batch.
- **Open — the two evolution paths disagree on candidate count.** From identical seeds and identical
  bounds, the client-side path evaluated 735 candidates and the daemon path 257, both arriving at
  the same four behaviour classes. The gap is nearly threefold and is unexplained. It may be
  different deduplication, different beam refill, or different mutation ordering. **Evidence gap**:
  no run-to-run comparison of the two mutation loops was performed. This is a question about the
  search, not about visualization, so it should be raised as its own item rather than pursued here.
- **Open, and owned by whoever closes the time gap** — whether a completion estimate can be made
  accurate. Per-generation candidate counts are visibly uneven (4, 66, 89, 98 in the primary run),
  so a linear extrapolation from the candidate counter will be wrong. Conditioning on generation is
  the obvious repair, but it cannot be tested until timestamps exist.
- **No genuine mystery remains in the visualization work itself.** Every view is driven by data whose
  provenance and meaning were checked against the source.

## Second pass: real corpora

The exploration above ran against a two-row smoke fixture, which the user correctly identified as
dominating every figure on screen. Five campaigns were then generated on genuine research corpora
and both interfaces rebuilt against them.

| campaign | corpus | candidates | behaviour classes | perfect |
|---|---|---|---|---|
| g=133 order-2092 exact q2 cells, excluded label | 225 objects × 30 features | 9,638 | 233 | 4 |
| g=133 exact q2 cells, survives label | 225 × 30 | 4,372 | 92 | 4 |
| g=133 exact q3 cells, survives label | 325 × 30 | 2,992 | 97 | 1,173 |
| C1016 banked semantic system, 55 features | 1,024 × 55 | 99,966 | 3,595 | 0 |
| C1016 banked semantic system, 21 features | 1,024 × 21 | 4,562 | 589 | 6 |

What the real data changed, beyond the schema facts recorded in the data-model note:

- **The launch bounds were hardcoded and are now read from the run.** The console had a candidate
  budget and generation count baked in from the fixture. Real runs use a beam of 128 or 256, up to
  32 generations, and a 100,000-candidate budget. Those values live only in the `evolve-start`
  response, so the console now reads them and reports the bound as unknown when the response was
  not saved.
- **A time axis exists after all, supplied by the launching harness.** The architecture note is
  corrected accordingly. Elapsed time, sample count, recent candidate rate, and a projected
  remaining time now come from a polled progress series with wall-clock stamps.
- **Huge lineages are sampled to a structural skeleton.** The 99,966-candidate run cannot be drawn
  or embedded whole. Expansion parents, the first candidate of every behaviour class, and the
  ancestry closure of whatever is kept are all retained, so no drawn edge dangles and no generation
  proportion is distorted; every aggregate is still computed over the full file, and the view states
  how many of how many are drawn.
- **The object space is now an independent check.** The console re-implements the plan stack machine
  and evaluates the selected plan over every object. Its recomputed weighted-correct is compared
  against the value the daemon recorded — two separate evaluators over the same objects — and the
  match is displayed. On the g=133 excluded-cells run both give 15,724,800 exactly.
- **Each run shows its own reduction.** The corpus generator's report carries weighted roots,
  survivors, and exclusions, so the cascade view now leads with the loaded run's real reduction and
  keeps the g=41 quotient compilation below it as a named worked reference.

Two findings in the search itself, worth their own attention:

- On the g=133 excluded-cells campaign the best plan is `evolve-g0-c6`, a **generation-zero seed**,
  already perfect at 15,724,800 of 15,724,800. The campaign then tested 9,638 further candidates
  without improving on it.
- The g=133 **q3 filter excludes nothing**: its report records zero weighted exclusions against
  15,724,800 roots, which is why that campaign's label is constant and why it reports 1,173 perfect
  classifiers. A console that showed the perfect count without the exclusion share would read this
  degenerate run as the most successful of the five.

## Recommended next move

A production build is ordinary construction against interfaces that already exist, and it is not
allocated. Before it, the cheap high-value item is the timestamp: one monotonic clock reading per
durable ledger event unlocks both the completion estimate and the performance replay, and it is a
small, well-bounded core change that nothing else in this exploration required.
