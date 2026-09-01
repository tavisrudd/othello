# C1033 — Ergodis integration with DuckDB, Jupyter, and Sage

**Lane**: `complete-ports`
**Task**: C1033
**Date**: 2026-09-01
**Scope**: tooling only. No Ergodis core edit, no manuscript or public-surface claim, no new
evidence and no change to any existing evidence file.

## Status

Three sessions. All three integrations -- DuckDB, Jupyter, and Sage -- are implemented and run end to end
against committed artifacts and a real controlled search.

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

## What was built: Sage as an independent oracle

Sage 10.7 comes from nixpkgs as a pure cache fetch -- 604 paths, about 1.09 GiB downloaded and
3.25 GiB unpacked, with nothing built locally. `analysis/ergodis-sage` runs a script inside
`nix shell nixpkgs#sage`, so nothing is installed into the profile and later runs start in seconds.

Sage's value here is that it is a genuinely different implementation, not a faster one. Ergodis is
already the fast path, and the reproducibility convention asks for an independent replay wherever
one exists. Sage supplies natively exactly the objects this work manipulates -- finite fields and
their extensions, permutation and matrix groups, integer and GF(2) linear algebra, linear codes --
each of which has been hand-rolled as a Python oracle at least once in this lane's history.

### The target, and why it changed

The plan named the C1016 multiplier-orbit and quotient-shift computations over `Z/18`. That target
was dropped: the C1016 kernels, corpora, and their Python checks are currently **uncommitted work
belonging to another session**, and an oracle is worth nothing if it is written against files that
can change underneath it. The retarget keeps the same shape -- an orbit computation over a finite
group with an existing independent Python check -- while using committed artifacts.

### What the oracle checks

`analysis/sage/check_qldpc_certificate.py` re-verifies the six committed C1018 quantum LDPC
exact-distance certificates in `evidence/`. Each certificate is self-describing: it publishes its
group, the two protographs of the lifted product, both check ranks, the dimension, the
automorphism and coordinate-orbit counts, and any logical witness. The oracle rebuilds each code
from that data alone and checks, against the published numbers:

* the group is the one named -- right order, and isomorphic to Sage's own construction of it;
* the coordinate count and the check-row weights;
* the CSS commutation `Hx Hz^T = 0`;
* both check ranks, and the dimension as `n - rank(Hx) - rank(Hz)`;
* the even-weight-kernel claim, which holds exactly when the all-ones vector lies in that side's
  row space, since the pairing of a word with all-ones is its weight modulo two;
* the combined support component count, through a Sage graph;
* that right translation by each element centralizing the B entries really is a code automorphism,
  and that the verified translations and the coordinate orbits they induce match the anchor notes;
  and
* each published logical witness -- zero physical syndrome, outside the stabilizer row space, and at
  the certified weight.

The construction is assembled as block matrices of left- and right-regular representation matrices
over GF(2), which is a different formulation from the existing checker's integer-bitmask loops.

### Result

All 102 checks pass across all six certificates, with the replay command

    analysis/ergodis-sage analysis/sage/check_qldpc_certificate.py

The independently recomputed parameters are `[[1428,186,18]]`, `[[1496,198,16]]`,
`[[1496,192,16]]`, `[[1496,198,14]]`, `[[1500,81,18]]`, and `[[1500,76,20]]`. Sage confirms the two
non-abelian cases are the dicyclic group `Dic_11`, which it independently identifies as `C11 : C4`,
and confirms the automorphism and orbit structure that the exact searches relied on to reduce their
anchor sets: 42 of 42 translations giving 34 orbits of 1428 coordinates for the first code, 2 of 44
giving 748 of 1496 for the dicyclic pair, and 60 of 60 giving 25 of 1500 for the last two. The two
published logical witnesses, at weights 16 and 14, are independently confirmed to be genuine
logicals.

This is a check of the published certificates, not a new distance claim: the exhaustive
enumeration that establishes each distance is not reproduced here, and the oracle says nothing
about it.

### One correction the work forced

Sage reads a bare tuple of points as a **cycle**, not as a one-line image list. Building the regular
representation from image lists silently produced a different group -- the order was wrong and the
isomorphism check failed, which is how it was caught. The generators are now converted through
`Permutation(images).cycle_tuples()`. Anyone building a permutation group from a multiplication
table in Sage hits the same trap.

## What is deliberately not here

No Parquet materialization of the evidence tree. The tree is small enough that globbing the source
files directly is fast, and a materialized copy would be a second thing that can disagree with the
committed evidence. If the tree grows past the point where globbing is slow, the fix is a cache with
a content hash, not a checked-in Parquet mirror.

## Next steps

1. Drive a real long campaign from the notebook rather than a half-minute control: the evolution
   path (`evolve-start`, `evolve-status`) has a full parent-child lineage graph with labelled
   mutation operators that nothing in the notebook currently renders, and lineage is the natural
   next view.
2. Decide whether `certificate_index` should be widened. Only 6 of the 33 JSON documents in
   `evidence/` share the exact-distance certificate shape; the rest are unrelated schemas, and the
   question is whether a second index view for the pilot/instrument documents earns its place.
3. Point the Sage oracle at the C1016 multiplier-orbit reductions once that work is committed. The
   original target is still the right one; it was only blocked on the files being another session's
   uncommitted work.
4. Raise with the core owner: the ledger synopsis for an activated **ordering** plan reads
   "diagnostic plan activated". The event is correct and carries the plan name; only the wording is
   wrong. Not touched here, since it is a core-side string.

## Vibe check

Good, and complete for what the task set out to do. All three integrations are done and verified
against real artifacts: SQL over the whole evidence tree, a notebook that launches, watches, and
steers a live search, and a Sage oracle that independently reproduces every published parameter of
six quantum LDPC certificates. Nothing needed a change to the Ergodis core. The sharp edges found
along the way -- socket path length, bytecode-only plans, the epoch compare-and-swap, and Sage's
cycle-versus-image reading -- are all guarded in code or written down.

---

`go C1033 complete-ports drive a long evolution campaign from the notebook and render its lineage graph`
