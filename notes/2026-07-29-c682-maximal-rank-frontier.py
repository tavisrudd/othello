#!/usr/bin/env python3
"""Bounded maximal-rank test and induction falsifier for C682."""

from __future__ import annotations

import argparse
import importlib.util
import json
from concurrent.futures import ProcessPoolExecutor
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE = HERE / "2026-07-28-c682-klein-e8-first-failure-replay.py"
CERTIFICATE = HERE / "2026-07-29-c682-maximal-rank-frontier.json"
PRIMES = (1_000_000_007, 1_000_000_009)
STOP = 300
DIMENSIONS = {
    "1": 1,
    "2": 2,
    "3": 3,
    "4s": 4,
    "5": 5,
    "6": 6,
    "3p": 3,
    "4": 4,
    "2p": 2,
}
KERNEL_BY_RESIDUE = {
    0: 1,
    1: 2,
    2: 3,
    6: 3,
    10: 3,
    11: 2,
    12: 1,
}


def load_base():
    spec = importlib.util.spec_from_file_location("maximal_rank_base", BASE)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load modular Klein engine")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def forced_nullity(base, degree: int) -> int:
    source = base.mckay_decomposition(degree)
    target = base.mckay_decomposition(degree + 6)
    return sum(
        DIMENSIONS[module]
        * max(multiplicity - target.get(module, 0), 0)
        for module, multiplicity in source.items()
    )


def formula_nullity(degree: int) -> int:
    return KERNEL_BY_RESIDUE.get(degree % 20, 0)


def sweep(arguments: tuple[int, int]) -> list[list[int]]:
    prime, stop = arguments
    base = load_base()
    rows = []
    for degree in range(stop + 1):
        matrix = base.delta_matrix(degree, prime)
        actual = degree + 1 - base.matrix_rank(matrix, prime)
        forced = forced_nullity(base, degree)
        expected = formula_nullity(degree)
        assert actual == forced == expected
        if actual:
            rows.append([degree, actual])
    return rows


def plateau_witness(base) -> dict:
    degrees = list(range(118, 161, 6))
    multiplicities = [
        base.mckay_decomposition(degree).get("1", 0)
        for degree in degrees
    ]
    assert degrees == [118, 124, 130, 136, 142, 148, 154, 160]
    assert multiplicities == [1, 2, 2, 2, 2, 2, 2, 3]
    return {
        "module": "1",
        "degree_step": 6,
        "degrees": degrees,
        "multiplicities": multiplicities,
        "obstruction": (
            "The multiplicity-two plateau has only a smaller left boundary "
            "and a larger right boundary. Equal-rank edges transport a full "
            "corner inside the plateau but provide no noncircular anchor."
        ),
    }


def build_certificate(
    primes: tuple[int, int] = PRIMES,
    stop: int = STOP,
) -> dict:
    with ProcessPoolExecutor(max_workers=2) as executor:
        spectra = list(
            executor.map(sweep, [(prime, stop) for prime in primes])
        )
    assert spectra[0] == spectra[1]
    base = load_base()
    return {
        "schema": "c682-maximal-rank-frontier-v1",
        "operator": "Delta_n=(.,Phi_12)_3",
        "searched_domain": f"all integer degrees 0..{stop}",
        "fields": [f"F_{prime}" for prime in primes],
        "kernel_series_candidate": (
            "(1+2t+3t^2+3t^6+3t^10+2t^11+t^12)/(1-t^20)"
        ),
        "nonzero_kernel_rows": spectra[0],
        "maximal_rank_result": (
            "For every tested degree, total kernel dimension equals the "
            "sum of representation-theoretically forced block defects; "
            "therefore every McKay block has maximal rank in 0..300."
        ),
        "multiplicity_induction_falsifier": plateau_witness(base),
        "claim_boundary": (
            "Maximal rank is finite two-prime evidence through degree 300. "
            "The plateau is an exact McKay-multiplicity obstruction to the "
            "proposed induction, not a corner counterexample."
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    if arguments.check:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 maximal-rank frontier")
    else:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")


if __name__ == "__main__":
    main()
