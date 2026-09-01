#!/usr/bin/env python3
"""End-to-end check of the notebook integration (C1033).

Exercises the whole path a notebook uses, without a notebook: launch a campaign,
attach a controlled search, tail its progress, activate an ordering plan while
the search is still running, confirm the search acknowledged it, and read the
run back through the DuckDB catalog.

    python3 analysis/check_notebook_integration.py

Needs `ergodis-campaign` and `alignment-controlled` built in release mode, and
the `duckdb` Python package for the catalog stage (skipped with a note if it is
absent).  Takes about a minute.
"""

from __future__ import annotations

import os
import shutil
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

from ergodis_notebook import (  # noqa: E402
    Campaign,
    alignment_search,
    check_run_dir_length,
    plan,
)
from ergodis_notebook.control import ControlError  # noqa: E402
from ergodis_notebook.monitor import flatten  # noqa: E402

FAILURES: list[str] = []


def check(condition: bool, description: str) -> None:
    status = "ok  " if condition else "FAIL"
    print(f"  {status} {description}")
    if not condition:
        FAILURES.append(description)


def run_root() -> Path:
    """Somewhere short enough for a search's watcher socket to bind."""
    base = Path(
        os.environ.get(
            "ERGODIS_RUN_ROOT",
            f"{os.environ.get('XDG_RUNTIME_DIR', '/tmp')}/ergodis-runs",
        )
    )
    base.mkdir(parents=True, exist_ok=True)
    return base


def main() -> int:
    data = ROOT / "examples" / "data" / "campaign-c880-live-ordering.jsonl"
    run_dir = run_root() / "check-notebook-integration"
    shutil.rmtree(run_dir, ignore_errors=True)

    print("run directory length guard")
    try:
        check_run_dir_length("/" + "x" * 200)
        check(False, "an over-long run directory is rejected")
    except ControlError:
        check(True, "an over-long run directory is rejected")
    check_run_dir_length(run_dir)

    print("campaign")
    campaign = Campaign.launch(data=data, run_dir=run_dir)
    try:
        status = campaign.status()
        check(status["health"] == "ready", "campaign reports ready")
        check(status["rows"] > 0, "feature batch loaded")
        check("child_unresolved_count" in status["fields"], "fields visible")
        campaign.note("check_notebook_integration")
        check(
            any(event.kind == "note" for event in campaign.events()),
            "operator note reaches the ledger",
        )

        print("search")
        progress_file = run_dir / "progress.jsonl"
        solve = alignment_search(
            campaign,
            points=8,
            budget=10,
            progress_file=progress_file,
            pulse_interval=4096,
        )
        snapshots: list[dict] = []
        deadline = time.monotonic() + 20.0
        while not snapshots and time.monotonic() < deadline:
            time.sleep(0.5)
            snapshots += solve.new_progress()
        check(bool(snapshots), "progress snapshots stream while the search runs")
        check(
            bool(snapshots) and "solver.states" in flatten(snapshots[0]),
            "snapshots carry live solver counters",
        )

        print("steering")
        ordering = plan.plan(
            "check-ordering",
            plan.field("child_unresolved_count"),
            role="ordering",
            output="score",
        )
        check(
            ordering["program"] == [{"op": "field", "name": "child_unresolved_count"}],
            "expression lowers to bytecode",
        )
        check(plan.scope_mask([6]) == 64, "scope mask is a membership bitset")
        before = campaign.epoch()
        campaign.candidate_apply(ordering)
        check(campaign.epoch() == before + 1, "activation advances the epoch")

        while solve.alive():
            snapshots += solve.new_progress()
            time.sleep(0.5)
        snapshots += solve.new_progress()
        check(solve.wait(timeout=60) == 0, "search exits cleanly")

        epochs = {record["notified_epoch"] for record in snapshots}
        check(
            max(epochs) > 0,
            "the running search acknowledged the plan without restarting",
        )
        result = solve.result()
        check(result["control"]["notifications"] > 0, "search reports the notification")
        check(result["metrics"]["states"] > 0, "search reports exact metrics")

        print("catalog")
        try:
            from ergodis_notebook import open_catalog

            catalog = open_catalog()
            ledger = catalog.execute(
                "select * from run_ledger(?)", [str(run_dir)]
            ).fetchall()
            check(len(ledger) >= 2, "the run's ledger is queryable as SQL")
            summary = catalog.execute("select count(*) from ab_summary").fetchone()
            check(summary[0] > 0, "the evidence A/B summary is non-empty")
        except ImportError:
            print("  skip duckdb not installed; catalog stage not checked")
    finally:
        campaign.shutdown()

    check(not campaign.alive(), "campaign stops on shutdown")

    if FAILURES:
        print(f"\n{len(FAILURES)} check(s) failed")
        return 1
    print("\nall checks passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
