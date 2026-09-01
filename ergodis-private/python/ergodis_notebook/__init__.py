"""Drive Ergodis from a Jupyter notebook: launch solves, watch them, query the
evidence.

The three surfaces are:

* `Campaign` -- start or attach to the long-running control plane, send any
  control op, read the append-only ledger while the run is live;
* `Solve` / `alignment_search` -- start a search that attaches to a campaign and
  streams progress snapshots, and `run_json` for ordinary one-shot workflows; and
* `Monitor` -- one updating cell showing provenance, live counters, and the
  ledger tail, which leaves the collected snapshots behind for analysis.

`open_catalog` gives the same DuckDB evidence views as the `analysis/ergodis-sql`
shell.

Typical session::

    from ergodis_notebook import Campaign, Monitor, alignment_search

    campaign = Campaign.launch(data=batch, run_dir=run_dir)
    solve = alignment_search(campaign, points=6, budget=10,
                             progress_file=run_dir / "progress.jsonl")
    monitor = Monitor(campaign, solve).watch()
    frame = monitor.progress_frame()
"""

from . import plan
from .campaign import Campaign, LedgerEvent, LedgerTail, check_run_dir_length
from .catalog import ab_summary, open_catalog, run_ledger
from .control import ControlError, Manifest, send_full, send_request
from .monitor import Monitor, flatten
from .paths import BinaryNotFound, binary, cargo_build, catalog_sql
from .plan import scope_mask
from .solve import ProgressTail, Solve, alignment_search, run_json

__all__ = [
    "BinaryNotFound",
    "Campaign",
    "ControlError",
    "LedgerEvent",
    "LedgerTail",
    "Manifest",
    "Monitor",
    "ProgressTail",
    "Solve",
    "ab_summary",
    "alignment_search",
    "binary",
    "cargo_build",
    "catalog_sql",
    "check_run_dir_length",
    "flatten",
    "open_catalog",
    "plan",
    "run_json",
    "run_ledger",
    "scope_mask",
    "send_full",
    "send_request",
]


def build(*names: str) -> list:
    """Build the named binaries in release mode; returns their paths."""
    return [cargo_build(name) for name in names]
