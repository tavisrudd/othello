# C1033 — Saved-run notebook lineage and accounting

Date: 2026-09-07. Lane: `ergodis`. Status: this slice complete; C1033 remains open.
Private commit: `81af202`. Uses C1123 exporter/loader commits `c835284`, `2820c67`.

## Result

`ergodis-private/analysis/notebooks/saved-runs.ipynb` consumes a saved repository
projection through the existing notebook-callable DuckDB loader. It presents
published-head accounting, an SVG update/fork ancestry graph, attempt states,
reservations and observed physical work. Users choose a projection path and can
select a run by full ID; selection retains its cross-run ancestors. SQL cells
expose exact accounting and lineage joins for further exploration.

`python/ergodis_notebook/saved_runs.py` renders the view. Layout uses topological
depth rather than record sequence because forks restart sequence at zero.
Multiple retained branches of one run receive separate tracks; records cannot
hide behind a node at the same depth. Update edges are solid, forks dashed,
and selected published heads blue. Full identities are in tooltips/expandable
tables; local R/A labels keep the main exact-counter tables readable.

The graph refuses more than 128 selected records explicitly. SQL still exposes
all admitted projection rows. Missing run selections, broken references and
cycles reject; text is escaped. Empty repositories display clearly. No current
verification result is inferred, no campaign starts, and no live repository is
read. Unknown work remains a lower bound and conservative charges remain visible.
Host-defined units are explicit; this view makes no cross-run comparability claim.

## Validation

The committed `analysis/check_saved_runs_notebook.py` checks actual notebook
execution through nbclient/IPython and the same renderer used by the notebook.
It consumes the C1123 native fixture generator's final exported state.

Passed: exact rendered `18446744073709551615` charges/reservations and
`9007199254740993` observed work; update/fork SVG edges; all-run and selected-run
ancestry; interrupted/active attempts; empty state; invalid selection/limits;
cycle rejection; escaped text; and same-run sibling tracks with distinct node
positions. SQL notebook cells execute without errors. The source notebook has
no saved outputs; executed outputs stay in the persistent cache.

Replay from `ergodis-private`:

```sh
uv run --with duckdb==1.5.5 --with nbformat --with nbclient --with ipykernel python -B analysis/check_saved_runs_notebook.py --fixtures /home/tavis/.cache/ergodis/c1123-projection-final --output /home/tavis/.cache/ergodis/c1033-saved-runs/executed.ipynb
```

Fixture regeneration: private `analysis/repository-projection.md`; use a fresh
native fixture directory and pass its path to the notebook checker. The tests
and generator are committed, so the cache is not sole evidence.
Final notebook run-quiet capture: `20260907-154951-uv-run-with-duckdb1.5.5...`.
A successful local IPython run emits its default TCP transport warning; no
server was exposed or long-lived notebook service launched by this check.

Headless Chromium rendered the generated HTML at 1280 by 1400. Inspected the
final screenshot at `/home/tavis/.cache/ergodis/c1033-saved-runs/notebook-final.png`;
all primary counter columns fit and the graph is visible. Capture:
`20260907-155012-chromium-headless...`. This is actual notebook execution plus
browser inspection of its rendered output, not a JupyterLab interaction test.
`git diff --cached --check` passes. No Rust/core/WASM changes or performance
claim; the previously recorded foreign Rust Clippy issue was not revisited.
Test-generated Python bytecode from the prior bridge run was removed; checks
now disable bytecode writes. Cache GC ran in dry-run mode only.

## Closeout and next step

Cheap closeout checks settled fork-depth layout and overlapping retained branches.
The visual review moved long identities out of the main counter tables without
losing access to them. No incidental mathematical discovery to log; no genuine
research mystery arose. The graph cap and detached-source behavior are explicit
product boundaries.

C1033's saved-repository consumption is complete. Its standing live campaign
frontier remains: exercise a longer evolution campaign and render candidate
parent/child mutation lineage. That vocabulary is distinct from immutable saved
run update/fork ancestry; this slice does not invent a mapping between them.
Sage/certificate-index extensions remain as described in the original C1033
report. C1033 is not archived by this slice.
