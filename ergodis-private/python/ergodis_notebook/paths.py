"""Locating -- and if necessary building -- the Ergodis binaries.

Two crates are in play: the public core at `papers/complete-repair-ports/ergodis`
(which owns `ergodis`, `ergodis-campaign`, and `ergodisctl`) and the private
crate at `ergodis-private` (which owns the domain adapters).  A notebook should
not have to know which is which, so `binary` searches both.
"""

from __future__ import annotations

import os
import subprocess
from functools import lru_cache
from pathlib import Path

PRIVATE_ROOT = Path(__file__).resolve().parents[2]
WORKSPACE_ROOT = PRIVATE_ROOT.parent
PUBLIC_ROOT = WORKSPACE_ROOT / "papers" / "complete-repair-ports" / "ergodis"

CRATES = (PRIVATE_ROOT, PUBLIC_ROOT)


class BinaryNotFound(RuntimeError):
    """A requested binary is neither built nor declared by either crate."""


def _search_dirs() -> list[Path]:
    override = os.environ.get("ERGODIS_BIN_DIR")
    dirs = [Path(override)] if override else []
    dirs += [crate / "target" / "release" for crate in CRATES]
    dirs += [crate / "target" / "debug" for crate in CRATES]
    return dirs


@lru_cache(maxsize=None)
def _declaring_crate(name: str) -> Path | None:
    """Which crate's manifest declares this binary, for `cargo build --bin`."""
    needle = f'name = "{name}"'
    for crate in CRATES:
        manifest = crate / "Cargo.toml"
        if manifest.exists() and needle in manifest.read_text():
            return crate
    return None


def binary(name: str, build: bool = False) -> Path:
    """Return the path to a built Ergodis binary.

    With `build=True` a missing binary is compiled in release mode from whichever
    crate declares it.  The default is to fail instead, because a cargo build is
    not something a notebook cell should start by surprise.
    """
    for directory in _search_dirs():
        candidate = directory / name
        if candidate.is_file() and os.access(candidate, os.X_OK):
            return candidate
    if not build:
        raise BinaryNotFound(
            f"{name} is not built; call ergodis_notebook.build('{name}') "
            f"or set ERGODIS_BIN_DIR"
        )
    return cargo_build(name)


def cargo_build(name: str, quiet: bool = True) -> Path:
    """Build one binary in release mode and return its path."""
    crate = _declaring_crate(name)
    if crate is None:
        raise BinaryNotFound(f"no crate declares a binary named {name}")
    command = ["cargo", "build", "--release", "--bin", name]
    result = subprocess.run(
        command,
        cwd=crate,
        capture_output=quiet,
        text=True,
    )
    if result.returncode != 0:
        tail = (result.stderr or "").strip().splitlines()[-20:]
        raise BinaryNotFound(
            f"cargo build of {name} failed:\n" + "\n".join(tail)
        )
    return binary(name)


def catalog_sql() -> Path:
    """The DuckDB catalog that defines the evidence views."""
    return PRIVATE_ROOT / "analysis" / "ergodis_catalog.sql"
