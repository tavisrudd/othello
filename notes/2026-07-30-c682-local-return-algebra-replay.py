#!/usr/bin/env python3
"""Second-prime replay for the C682 local-return block audit."""

from __future__ import annotations

import importlib.util
from pathlib import Path


HERE = Path(__file__).resolve().parent
PRIMARY = HERE / "2026-07-30-c682-local-return-algebra.py"
REPLAY_PRIME = 1_000_000_009


def load():
    spec = importlib.util.spec_from_file_location(
        "local_return_primary", PRIMARY
    )
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {PRIMARY}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> None:
    certificate = load().classify(prime=REPLAY_PRIME)
    failure = certificate["classification"]["unique_failure"]
    assert failure == {
        "module": "3",
        "degree": 22,
        "multiplicity": 2,
        "common_commutant_dimension": 2,
    }
    assert all(
        row["failures"] == []
        for label, row in certificate["blocks"].items()
        if label != "3"
    )
    print("PASS: C682 local-return block audit at second prime")


if __name__ == "__main__":
    main()
