#!/usr/bin/env python3
"""Basis-level replay of the C682 virtual-level residue explanation."""

from __future__ import annotations

import importlib.util
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
NONTRIVIAL_PATH = (
    HERE / "2026-07-29-c682-nontrivial-plateau-controllability.py"
)
EXCEPTIONAL_PATH = HERE / "2026-07-30-c682-exceptional-monotone-schur.py"
EXCEPTIONAL_CERTIFICATE = (
    HERE / "2026-07-30-c682-exceptional-monotone-schur.json"
)


def load(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def counts_from_basis(rows):
    first_by_name = {}
    for name, _, h_power, *_ in rows:
        first_by_name.setdefault(name, h_power % 3)
    residues = list(first_by_name.values())
    return [residues.count(residue) for residue in range(3)]


def exponents(counts):
    c0, c1, c2 = counts
    return [c2, c2 + c1, c0 + c1 + c2, c0 + c1, c0]


def stored_exponents(row):
    lookup = {
        Fraction(item["root"]): item["multiplicity"]
        for item in row["roots"]
    }
    return [
        lookup.get(Fraction(numerator, 3), 0)
        for numerator in (-2, -1, 0, 1, 2)
    ]


def main() -> None:
    nontrivial = load(NONTRIVIAL_PATH, "virtual_level_nontrivial_replay")
    expected_nontrivial = {
        "2": [0, 1, 1],
        "3": [1, 1, 1],
        "3p": [1, 1, 1],
    }
    for label, expected in expected_nontrivial.items():
        rows = nontrivial.incoming_system(label, 2)["lower"]
        assert counts_from_basis(rows) == expected

    exceptional = load(EXCEPTIONAL_PATH, "virtual_level_exceptional_replay")
    operators = json.loads(exceptional.OPERATORS.read_text(encoding="utf-8"))
    certificate = json.loads(
        EXCEPTIONAL_CERTIFICATE.read_text(encoding="utf-8")
    )
    for label, offset in exceptional.TYPES:
        type_name = f"{label}_{offset}"
        for phase in range(3):
            degree = offset + 20 * (15 + phase)
            lower, _, _ = exceptional.BASE.operator_matrix(
                label, degree - 6, 3, operators
            )
            counts = counts_from_basis(lower)
            stored = certificate["types"][type_name]["backward_block"][
                "phases_by_r_mod_3"
            ][str(phase)]
            assert exponents(counts) == stored_exponents(stored)

    print("PASS: C682 virtual levels reconstructed from exact free bases")


if __name__ == "__main__":
    main()
