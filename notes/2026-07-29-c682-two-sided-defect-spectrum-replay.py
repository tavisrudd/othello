#!/usr/bin/env python3
"""Independent-prime replay of the C682 two-sided defect spectrum."""

from __future__ import annotations

import importlib.util
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
MAIN = HERE / "2026-07-29-c682-two-sided-defect-spectrum.py"
REPLAY_PRIMES = (998_244_353, 1_000_000_009)


def load_main():
    spec = importlib.util.spec_from_file_location("defect_spectrum_main", MAIN)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load defect-spectrum certificate")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def main() -> None:
    certificate = load_main().make_certificate(primes=REPLAY_PRIMES)
    assert certificate["relevant_repeated_defects"] == [[22, ["3"]]]
    print("PASS: C682 two-sided defect spectrum replay")


if __name__ == "__main__":
    main()
