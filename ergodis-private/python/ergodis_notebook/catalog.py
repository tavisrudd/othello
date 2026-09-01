"""The DuckDB evidence catalog, as a notebook object.

Same views as the `analysis/ergodis-sql` shell, from the same SQL file, so the
notebook and the shell cannot drift apart in what a paired ratio means.
"""

from __future__ import annotations

import os
from pathlib import Path
from typing import Any

from .paths import PRIVATE_ROOT, catalog_sql


def open_catalog(root: os.PathLike[str] | str | None = None) -> Any:
    """Return an in-memory DuckDB connection with the evidence views loaded.

    The catalog's globs are relative to the private crate root, so the
    connection sets its working directory there.  Requires the `duckdb` Python
    package; the notebook launcher supplies it.
    """
    import duckdb

    base = Path(root) if root is not None else PRIVATE_ROOT
    connection = duckdb.connect()
    connection.execute(f"set file_search_path = '{base}'")
    previous = Path.cwd()
    os.chdir(base)
    try:
        connection.execute(catalog_sql().read_text())
    finally:
        os.chdir(previous)
    return connection


def ab_summary(connection: Any) -> Any:
    """The paired A/B table for every interleaved benchmark in `evidence/`.

    A `time_geomean` below one means `arm_b` is the faster arm; `t` is the
    paired statistic on log ratios.
    """
    return connection.execute("select * from ab_summary").df()


def run_ledger(connection: Any, run_dir: os.PathLike[str] | str) -> Any:
    """Query one campaign's ledger as a table, live or after the fact."""
    return connection.execute(
        "select * from run_ledger(?)", [str(run_dir)]
    ).df()
