#!/usr/bin/env python3
"""Independent modular replay for the remaining C682 plateau anchors."""

import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
CORE_PATH = HERE / "2026-07-29-c682-signed-block-wronskian-replay.py"
OPERATORS = HERE / "2026-07-29-c682-remaining-plateau-wronskians-operators.json"
CERTIFICATE = HERE / "2026-07-29-c682-remaining-plateau-wronskians.json"
PRIMES = (1_000_000_007, 1_000_000_009)
FAMILIES = {
    "2_13": {"module": "2", "base_degree": 73},
    "3_14": {"module": "3", "base_degree": 74},
    "3p_14": {"module": "3p", "base_degree": 74},
    "3p_18": {"module": "3p", "base_degree": 78},
}
GENERATOR_DEGREES = {
    "1": (0, 30),
    "2": (1, 11, 19, 29),
    "3": (2, 10, 12, 18, 20, 28),
    "3p": (6, 10, 14, 16, 20, 24),
}


def load_core():
    spec = importlib.util.spec_from_file_location(
        "remaining_plateau_modular_core", CORE_PATH
    )
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


CORE = load_core()


def multiplicity(module, degree):
    total = 0
    for generator_degree in GENERATOR_DEGREES[module]:
        remainder = degree - generator_degree
        if remainder < 0:
            continue
        total += sum(
            1
            for h_power in range(remainder // 20 + 1)
            if (remainder - 20 * h_power) % 12 == 0
        )
    return total


def plateau_phases():
    out = {}
    for module in GENERATOR_DEGREES:
        residues = []
        for residue in range(60):
            degree = 600 + residue
            current = multiplicity(module, degree)
            if (
                multiplicity(module, degree - 6) == current - 1
                and multiplicity(module, degree + 6) == current
            ):
                residues.append(residue)
        out[module] = residues
    return out


def main():
    operators = json.loads(OPERATORS.read_text(encoding="utf-8"))
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    phases = plateau_phases()
    assert phases == {
        "1": [4, 24, 44],
        "2": [3, 13, 23, 33, 43, 53],
        "3": [12, 14, 32, 34, 52, 54],
        "3p": [10, 14, 18, 30, 34, 38, 50, 54, 58],
    }
    assert {
        module: sorted({residue % 20 for residue in residues})
        for module, residues in phases.items()
    } == {"1": [4], "2": [3, 13], "3": [12, 14], "3p": [10, 14, 18]}
    for prime in PRIMES:
        for family, specification in FAMILIES.items():
            module = specification["module"]
            CORE.FAMILIES[module] = specification["base_degree"]
            selected = {module: operators[family]}
            spaces, matrices = CORE.direct_operators(
                module, 13, prime, selected
            )
            assert CORE.boundary_determinant(
                module, spaces, matrices, prime
            )
            assert CORE.smith_valuations_at_infinity(
                module, prime, selected
            ) == certificate["families"][family][
                "smith_valuations_at_infinity"
            ]
    print("PASS: independent modular remaining-plateau replay")


if __name__ == "__main__":
    main()
