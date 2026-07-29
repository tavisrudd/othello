#!/usr/bin/env python3
"""Alternate-prime replay of the C682 maximal-rank frontier."""

from __future__ import annotations

import importlib.util
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
MAIN = HERE / "2026-07-29-c682-maximal-rank-frontier.py"
PRIMES = (998_244_353, 1_000_000_009)


def load_main():
    spec = importlib.util.spec_from_file_location("maximal_rank_main", MAIN)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load maximal-rank frontier")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def main() -> None:
    certificate = load_main().build_certificate(primes=PRIMES)
    assert certificate["multiplicity_induction_falsifier"]["multiplicities"] == [
        1,
        2,
        2,
        2,
        2,
        2,
        2,
        3,
    ]
    print("PASS: independent C682 maximal-rank frontier replay")


if __name__ == "__main__":
    main()
