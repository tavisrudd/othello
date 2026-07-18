# C162 — import blast radius, and why the cost half does not exist yet

**Lane**: `build-sys`
**Date**: 2026-07-18
**Status**: blast-radius analyzer landed; rebuild-cost ranking is blocked on instrumentation that
does not exist, and this report says what it would take.

C162 stream 2 asked for "the project-local import/reverse-dependency blast-radius analyzer", ranking
hubs "by rebuild cost as well as dependent count". The dependent-count half is delivered and exact.
The cost half turned out to rest on a false premise, which is the more useful result.

## The exact result

`lean/scripts/lean-blast-radius.py` computes the transitive reverse closure of the project-local
import DAG: for a module `M`, every module that would be invalidated by editing `M`. Over the
git-tracked `.lean` files under `lean/`, that graph is 10,878 modules and 30,270 project-local import
edges, and it is acyclic, as Lean requires.

The top of the ranking is a single foundational stack:

| Dependents | % of tree | Direct importers | Module |
|-----------:|----------:|-----------------:|--------|
| 10,439 | 96.0% | 10 | `CapGame.BuildGame` |
| 10,373 | 95.4% | 3 | `ProjectiveCap.Grid` |
| 10,371 | 95.3% | 7 | `ProjectiveCap.GridGame` |
| 10,285 | 94.5% | 5 | `ProjectiveCap.Projective` |
| 10,281 | 94.5% | 11 | `ProjectiveCap.PlaneTransitivity` |
| 10,274 | 94.4% | 2 | `RelativeConicArcs.Plane` |
| 10,273 | 94.4% | 3 | `RelativeConicArcs.Arc` |

The full top-25 is in the committed certificate.

Two things are worth reading off this table. Editing any of ten foundational modules invalidates
roughly 95% of the tree, so there is no such thing as a cheap local edit to that stack. And the
direct-importer column is small — two to eleven — so the radius comes from chain depth, not from
wide fan-out. A module can be imported directly by two things and still own the whole repository.

## The cost half, and the premise that failed

The plan was to weight each dependent by a rebuild cost, so that a hub over thousands of trivial
generated leaves would rank below one over a few expensive aggregators. That needs a *per-module*
elaboration cost. The build queue's telemetry looked like the obvious source: 32 targets with
measured `wall_clock`.

It is not per-module. `wall_clock` for a target covers building everything beneath it that was not
already trace-current, so it is a closure measurement whose value also depends on the cache state at
the time. Using it as a unit cost and summing over a reverse closure would count the same elaboration
once per dependent — thousands of times over for the modules at the top of the table above.

The clearest evidence is the shape of the expensive targets:

| Measured | Own olean | Forward closure | Target |
|---------:|----------:|----------------:|--------|
| 16,231 s | 34,320 B | 5,989 | `RelativeConicArcs.Q25ResidualConclusionData.All` |
| 11,032 s | 34,128 B | 1,802 | `RelativeConicArcs.Q25ResidualTransportData.All` |
| 7,517 s | 34,120 B | 3,542 | `RelativeConicArcs.Q25ResidualDispatchData.All` |
| 7,424 s | 34,224 B | 3,178 | `RelativeConicArcs.Q25ResidualClassLinkData.All` |

Four and a half hours attributed to a module with a 34 KB olean. The time belongs to a closure of
thousands of generated leaves, not to the aggregator's own elaboration. Dividing gives a per-module
average of roughly 2.7 s for the first row and 6.1 s for the second — plausible rates, and a
reminder that they differ by more than a factor of two between trees.

This also invalidated the natural sanity check. An early version of this work correlated olean size
against measured seconds across those 32 targets and got Spearman rho = -0.044, which reads as
"olean size is a worthless proxy". That conclusion does not follow: the comparison puts a
closure-level time against a single module's output size, so it measures the mismatch, not the
proxy. The number is recorded here because it is exactly the kind of result that would otherwise get
cited as a finding.

So the tool ships with size proxies that are labelled unvalidated, and `cost-model` reports that no
validation is possible and why, rather than presenting a ranking that looks quantitative:

```text
per-module cost measurements available: 0
measured targets in telemetry: 32 (closure-level)
proxy validation possible: False
```

## What would close it

A per-module cost model needs per-module elaboration timing. The available routes, cheapest first:

1. Record, per queue run, which targets in a closure were already trace-current. The queue already
   distinguishes `built` from `skipped-current` per target; extending that to the modules Lake
   actually elaborates would turn each run into many per-module observations.
2. Elaborate with Lean's profiler on a representative sample and fit per-tree rates, accepting that
   generated leaves within one tree are near-uniform.
3. Time individual modules through `guarded-lean` during an existing build window.

Route 1 costs no extra Lean time, which matters here: the only thing more expensive than a bad cost
model is measuring it by rebuilding the tree. None of this is scheduled; it needs a C-ID and a
decision, and both belong to the user.

## What this establishes and what it does not

It establishes, over the git-tracked `.lean` files under `lean/` at commit `be65dda7`: the
project-local import graph as written in source headers, its acyclicity, and the exact transitive
dependent set of every module.

It does **not** establish rebuild cost in any unit, that a module with fewer dependents is cheaper
to touch, or anything about Lean's resolved import closure. The scanner reads source headers, so
`open`, `export`, and macro-generated dependencies are outside it — the same trusted boundary the
C326 spine states, whose scanner this reuses rather than duplicating.

**Working-tree caveat.** The scan reads tracked files as they stand on disk, and at generation time
one tracked file carried uncommitted edits from the `relconic` lane
(`Q25ResidualCoverPrototype/RowConclusion.lean`, two added imports). The ranking was recomputed with
those two edges removed and the top-15 modules and their dependent counts were **identical**, so the
committed certificate does not depend on another lane's in-flight work.

## Replay

Working directory `/home/tavis/src/othello/lean`:

```text
python3 scripts/test_lean_blast_radius.py                        # 22 hermetic tests, no Lean tree
python3 scripts/lean-blast-radius.py hubs --top 15
python3 scripts/lean-blast-radius.py radius RelativeConicArcs.Plane
python3 scripts/lean-blast-radius.py targets                     # closure-level measured times
python3 scripts/lean-blast-radius.py cost-model                  # why cost ranking is unavailable
```

The committed certificate regenerates byte-identically, and contains only graph-derived fields so it
does not depend on local build outputs or the host telemetry cache:

```text
python3 scripts/lean-blast-radius.py hubs --json --graph-only --top 25 \
  > ../notes/2026-07-18-c162-blast-radius.json
```

`targets` and `cost-model` read `~/.cache/othello-lean-build`, which is host-local and prunable;
their output is reported here but deliberately not committed as a certificate.

## Artifacts

| Path | SHA-256 | Bytes |
|---|---|---|
| `lean/scripts/lean-blast-radius.py` | `c9dacd3447606e5e13e04734d355d616b1e8199f892412888d5734912edaf591` | 22203 |
| `lean/scripts/test_lean_blast_radius.py` | `e998d9c78fbb40a1597747d9e003a69f76e1a1a5fa85c52d19a6343d21bd3df2` | 8638 |
| `notes/2026-07-18-c162-blast-radius.json` | `6916267b22db05f5e5bf523b0c700ee50b11060223084798890b16d119c1d082` | 3016 |

## Cross-checks

The reverse closure is the load-bearing computation, so it is tested against hand-computed answers on
graphs shaped to break a wrong implementation: a diamond, where a shared dependent must be counted
once and a naive path sum double-counts it; a chain, which a one-hop implementation truncates; and a
disconnected component that must not leak into another's closure. Cycle refusal, external-import
exclusion, topological ordering, median telemetry, truncated run records, and unparseable durations
each have a case, and the report test asserts that the tool never claims a validated cost model.

The independent check on the real graph is the invariance recomputation described above: the same
ranking derived from a graph with the two uncommitted edges removed.
