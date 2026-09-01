# C1033 — Ergodis integration with DuckDB, Jupyter, and Sage

**Lane**: `complete-ports`
**Task**: C1033
**Date**: 2026-09-01
**Scope**: tooling only. No Ergodis core edit, no manuscript or public-surface claim, no new
evidence and no change to any existing evidence file.

## Status

Two sessions. The DuckDB layer and the Jupyter integration are both implemented and run
end to end against the real private evidence tree and a real controlled search. Sage is
assessed and its entry point pinned, but it was not built or executed; everything said
about Sage below is design and availability, not a measured result.

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

## What was built: launching, watching, and steering a solve from Jupyter

`ergodis-private/python/ergodis_notebook/` is a Python package that drives the native control
plane, and `analysis/ergodis-notebook` opens JupyterLab with it importable. Dependencies come
from `uv`, not from a nix shell or the system profile, so the first run resolves them into uv's
cache and later runs start immediately.

The package has five parts:

* `control.py` reimplements the campaign socket protocol in pure Python. The wire format is a
  Unix stream socket carrying a four-byte little-endian length followed by JSON, one request and
  one response per connection, with a handshake on schema, request id, and run id. Doing this in
  Python rather than shelling out to the `campaign_rpc` binary means a notebook session needs no
  cargo build and every control op is a Python call.
* `campaign.py` launches or attaches to a campaign, exposes the control ops as methods, and reads
  the ledger incrementally. The campaign flushes on every append, so a byte offset is a sound
  cursor and the ledger is readable while the run is live.
* `solve.py` starts a search that attaches to a campaign and tails its progress file, and also
  covers ordinary one-shot JSON workflows.
* `plan.py` builds candidate plans and lowers the readable expression form to the bytecode the
  socket actually accepts, with the same node and depth limits as the core.
* `monitor.py` renders one updating notebook cell -- provenance header, campaign state, the latest
  progress snapshot with each counter's change since the previous one, and the ledger tail -- and
  keeps every snapshot it collected so the run is analyzable afterwards without re-reading
  anything.

### Verified end to end

`analysis/notebooks/solve-monitor.ipynb` runs the whole path and was executed headlessly through
`nbconvert`: it starts a campaign on the C880 live branch-ordering feature batch, runs the
aligned-attachment search at `points=8, budget=10`, collects 64 progress snapshots over about a
minute, activates an ordering plan while the search is still running, and reads the run back as
SQL. `analysis/check_notebook_integration.py` is the same path as an assertion script; all
eighteen of its checks pass.

The steering result is the one worth stating plainly: **a plan activated from a notebook cell is
picked up by the already-running search without restarting it.** Activation advances the
campaign's epoch, the search notices at its next safe point and swaps in a preallocated arena, and
the search's own progress snapshots show `notified_epoch` rising from 0 to 1 partway through the
run, with the final result reporting one notification. The exact answer and state count are
unchanged, which is the design: an ordering plan changes what is explored first and cannot change
what is admitted.

### Three things that bite, all now guarded or documented

**Run directories must be short.** A controlled search binds its watcher datagram socket *inside*
the run directory, and Unix socket paths are capped at 108 bytes. A run directory under a deep
working path makes the search fail at startup with "the optional search controller rejected a
safe-point operation", which says nothing about paths and cost real time to diagnose here.
`Campaign.launch` now checks the length up front and says what to do, and the notebook launcher
defaults the run root to `$XDG_RUNTIME_DIR`.

**The control socket accepts bytecode plans only.** The core's `PlanDocument` accepts both the
expression and bytecode surface forms, but `candidate-try` and `candidate-apply` deserialize
`PlanSpec` directly, so an expression document is rejected with "unknown field `expr`". Lowering
therefore has to happen client-side, which `plan.py` does.

**Activation is a compare-and-swap.** `candidate-apply` and `candidate-deactivate` require an
`expect_epoch` and refuse a stale one, so two steerers cannot both believe they installed the
newest plan. The epoch is carried on the response envelope rather than in `status`, so
`Campaign.epoch()` reads it from a `noop`.

### The routes not taken

A Rust kernel through `evcxr` 0.21.1 would let a notebook call compiled kernels directly, which the
Python route cannot. It costs a compile per cell block and pulls the private crate into an
interactive session, so it is worth it only if interactive exploration actually needs compiled
kernels -- driving and watching a search does not.

A notebook as a report artifact is rejected for anything paper-facing. The reproducibility
convention wants a committed script, a certificate, and an exact replay command; a notebook with
embedded output is a worse version of all three. Notebooks are for exploration, and their findings
graduate into scripts -- which is why the notebook's path also exists as
`check_notebook_integration.py`.

### Where the browser WebAssembly slice fits

C1032's prototype exposes one bounded sequential composition workflow through a narrow WebAssembly
adapter in a Web Worker, and deliberately excludes the filesystem, control-plane, affinity, and
parallel-search surfaces. So it is not a smaller version of this: the browser slice is the exact
one-shot workflow surface, and the notebook is the control plane. What they share is the JSON
request/response discipline, which is worth keeping aligned -- a payload accepted by `run_json`
here is the payload the browser adapter takes.

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

1. Measure the Sage closure build on this host, then write one multiplier-orbit oracle against a
   reduction that already has an independent Python check, and confirm the two agree. This is the
   only one of the three integrations still entirely on paper.
2. Drive a real long campaign from the notebook rather than a half-minute control: the evolution
   path (`evolve-start`, `evolve-status`) has a full parent-child lineage graph with labelled
   mutation operators that nothing in the notebook currently renders, and lineage is the natural
   next view.
3. Decide whether `certificate_index` should be widened. Only 6 of the 33 JSON documents in
   `evidence/` share the exact-distance certificate shape; the rest are unrelated schemas, and the
   question is whether a second index view for the pilot/instrument documents earns its place.
4. Raise with the core owner: the ledger synopsis for an activated **ordering** plan reads
   "diagnostic plan activated". The event is correct and carries the plan name; only the wording is
   wrong. Not touched here, since it is a core-side string.

## Vibe check

Better than expected. Two of the three integrations are done and verified against real runs, and
live steering from a notebook cell works on the first controlled search it was pointed at -- the
control plane needed no changes, only a client. The three sharp edges found along the way (socket
path length, bytecode-only plans, the epoch compare-and-swap) are all now either guarded in code or
written down. Sage is the only part still on paper.

---

`go C1033 complete-ports write the Sage oracle for a banked multiplier-orbit reduction and check it against the existing Python oracle`
