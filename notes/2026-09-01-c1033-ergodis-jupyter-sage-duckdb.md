# C1033 — Ergodis integration with DuckDB, Jupyter, and Sage

**Lane**: `complete-ports`
**Task**: C1033
**Date**: 2026-09-01
**Scope**: tooling only. No Ergodis core edit, no manuscript or public-surface claim, no new
evidence and no change to any existing evidence file.

## Status of this session

A first session, roughly forty minutes. The DuckDB layer is implemented and run against the real
private evidence tree. Jupyter and Sage are assessed and their entry points are pinned, but neither
was built or executed here; everything said about them below is design and availability, not a
measured result.

## What was built: a SQL catalog over the private evidence tree

`ergodis-private/analysis/ergodis_catalog.sql` defines read-only DuckDB views over the evidence
that already exists, and `ergodis-private/analysis/ergodis-sql` opens a shell with them loaded:

    analysis/ergodis-sql -c "select * from ab_summary"

DuckDB comes from nixpkgs (1.4.3) through `nix shell`; nothing is installed into the profile, and
no file in the tree is written.

The views are:

| View | What it covers |
|-------------------------|---------------------------------------------------------------|
| `bench_raw`, `bench`    | every interleaved benchmark TSV in `evidence/`, one canonical seconds column |
| `ab_slots`, `ab_pairs`  | the two arms of each comparison, paired observation by observation |
| `ab_summary`            | geometric-mean time/cycle/instruction ratio and paired `t` per comparison |
| `campaign_batch_lines`  | every line of every campaign JSONL under `examples/data/`      |
| `campaign_batch_header` | the feature-batch headers (schema, presentation, problem, fields) |
| `campaign_batch_row`    | the labelled feature rows                                      |
| `certificates`          | each JSON certificate as a JSON value                          |
| `certificate_index`     | candidate, parameters, certified distance, conclusion, boundary |
| `native_scale`          | the native scaling JSONL records                               |
| `run_ledger`, `run_manifest` | macros over a live campaign run directory                 |

### The finding that shaped the design

The evidence tree is far more uniform than it looks. Every interleaved A/B file in `evidence/`
is a two-arm design keyed by `round` and `backend`, with counters under the same column names
(`cycles`, `instructions`, `branches`, `branch_misses`), and three interchangeable spellings of
elapsed time (`elapsed_ns`, `wall_seconds`, `task_clock_ms`). Some files add `mode`, `order`, and
`threads` keys. That is enough regularity for one generic pairing rule to cover the whole tree, so
the paired-ratio statistic that each task currently recomputes in its own Python script is now a
single query.

One correction the data forced: `round` is the **global interleave slot, not a pair index**. Within
one comparison the arms alternate, so one arm holds the odd slots and the other the even ones, and
`order` names which arm led that phase. Joining the two arms on equal `round` therefore returns
nothing at all. The pairing is positional — each arm's k-th observation against the other arm's
k-th — which is what the interleaved protocol was designed to support. Anyone reusing this evidence
outside the catalog needs the same correction.

### Verified output

`ab_summary` covers 18 order-separated comparisons from the twelve benchmark TSVs plus 8 more from
the mode-keyed projective-action files. The ratios reproduce the direction and magnitude of the
results already recorded for those tasks — for instance the binary-field typed fastpath comparison
gives parent/candidate geometric means of 1.35 and 1.26 across its two interleave phases, with
paired `t` of 25.24 and 3.21, i.e. the typed candidate is the faster arm. `certificate_index`
resolves 6 exact-distance certificates with their parameters and boundary sentences.

This is a reading layer over existing evidence. It is not itself evidence for any claim, and it does
not replace the per-task replay scripts that a reproducibility bundle requires.

## Where the campaign integration actually lands

C1031 established that a campaign run directory is already a complete self-describing record: a
`manifest.json` provenance header, an append-only `ledger.jsonl` of `{seq, epoch, kind, synopsis,
plan}` events flushed on every append, and an `evidence/` directory of bulk artifacts. Because the
ledger is flushed per append, DuckDB can query a run *while it is still running* — the
`run_ledger(dir)` macro is a live timeline query with no new instrumentation in the core. That is
the same conclusion C1031 reached for its dashboard, arrived at from the analysis side.

## Jupyter: assessed, not built

`python3Packages.jupyterlab` 4.4.5 and `python3Packages.duckdb` 1.4.3 are both in nixpkgs, and
`evcxr` 0.21.1 provides a Rust kernel. Three distinct integrations are possible and they are not
equally worthwhile:

1. **A Python kernel holding the DuckDB catalog.** Cheapest and highest value: the notebook opens
   an in-memory DuckDB, runs `ergodis_catalog.sql`, and every cell is a query against the same
   views the shell uses. Plots come from the query results. Nothing is duplicated between the shell
   and the notebook, so the catalog stays the single definition of what a paired ratio means.
2. **A Rust kernel through evcxr, depending on the ergodis crate directly.** This gets a notebook
   that can call compiled kernels and adapters, which the Python route cannot. It costs a compile
   per cell block and it pulls the private crate into an interactive session, so it is worth it only
   for interactive exploration of a live search, not for evidence analysis.
3. **A notebook as a report artifact.** Rejected for anything paper-facing. The reproducibility
   convention wants a committed script, a certificate, and an exact replay command; a notebook with
   embedded output is a worse version of all three. Notebooks are for exploration here, and their
   findings graduate into scripts.

The recommendation is (1) now, (2) only if a live-campaign exploration session actually needs
compiled kernels, and never (3).

## Sage: assessed, not built

Sage 10.7 is in nixpkgs. Sage's value to this lane is as an **independent oracle**, not as a
compute engine — Ergodis is already the fast path, and the reproducibility convention asks for an
independent replay of computational claims wherever one exists. Sage supplies exactly the objects
the private work manipulates: finite fields and their extensions, cyclotomic and multiplier-orbit
algebras, integer linear algebra and Smith normal form, permutation and matrix groups, and linear
codes with their weight enumerators. Each of those has been hand-rolled as a Python oracle at least
once in this lane's history.

The concrete first target is the class of oracle that C1016 keeps rebuilding: multiplier-orbit and
quotient-shift computations over `Z/18` and its relatives, currently checked by bespoke flat
enumeration. A Sage oracle for those is shorter, independently maintained, and genuinely independent
of the Rust implementation in a way that a Python script written alongside it is not.

The cost is that Sage is a heavy closure and slow to start, so it belongs in an explicitly invoked
oracle script, not in any hot path or default check. Nothing in this session tested that closure's
build time on this host, which is the first thing to measure before committing to the route.

## What is deliberately not here

No Parquet materialization of the evidence tree. The tree is small enough that globbing the source
files directly is fast, and a materialized copy would be a second thing that can disagree with the
committed evidence. If the tree grows past the point where globbing is slow, the fix is a cache with
a content hash, not a checked-in Parquet mirror.

## Next steps

1. Build the notebook route: a `nix develop` shell or flake app with JupyterLab plus the DuckDB
   Python package, and one notebook that loads `ergodis_catalog.sql` and reproduces the `ab_summary`
   table. This is the step that turns the catalog into something usable interactively.
2. Point `run_ledger` at a live campaign and confirm the live-timeline query works during a real
   run rather than after it. The append-and-flush behavior says it will; that has not been observed.
3. Measure the Sage closure build on this host, then write one multiplier-orbit oracle against a
   reduction that already has an independent Python check, and confirm the two agree.
4. Decide whether `certificate_index` should be widened. Only 6 of the 33 JSON documents in
   `evidence/` share the exact-distance certificate shape; the rest are unrelated schemas, and the
   question is whether a second index view for the pilot/instrument documents earns its place.

## Vibe check

Good. The DuckDB layer was cheaper than expected and immediately reveals that the evidence tree has
one shape rather than a dozen, which is the reusable finding. The interleave-slot correction is the
kind of thing that silently produces an empty result rather than a wrong one, so it cost time but no
credibility. Jupyter and Sage are still on paper.

---

`go C1033 complete-ports build the JupyterLab + DuckDB notebook shell and confirm the live campaign ledger query`
