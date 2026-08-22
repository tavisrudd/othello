#!/usr/bin/env python3
"""Exact F_2 certificate for the R10 Albanese-graph parity step.

Engel--de Gaay Fortman--Schreieder reduce the R10 case of their
divisibility argument to a 160-variable linear system over F_2.  This
checker reconstructs that system from the displayed 5 by 10 matrix and
certifies something stronger than equality of two ranks: each of the ten
colour-profile rows is an explicit linear combination of the 160 constraint
rows.

The calculation is finite combinatorics.  It does not verify the geometric
reduction to regular matroids, the classification of regular matroids, or the
deduction from the parity statement to non-algebraicity of the minimal theta
class.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parent
CERTIFICATE = ROOT / "r10_albanese_parity_certificate.json"
LEAN_MODULE = (
    ROOT.parent
    / "lean/TavisRuddFiniteGeom/Papers/CubicStabilizationIrrationality/Comparison/R10AlbaneseParity.lean"
)
SCHEMA = "cubic-stabilization-irrationality-r10-albanese-parity-v1"

R10 = [
    [1, 0, 0, 0, 0, -1, 1, 0, 0, 1],
    [0, 1, 0, 0, 0, 1, -1, 1, 0, 0],
    [0, 0, 1, 0, 0, 0, 1, -1, 1, 0],
    [0, 0, 0, 1, 0, 0, 0, 1, -1, 1],
    [0, 0, 0, 0, 1, 1, 0, 0, 1, -1],
]


def dual_columns_mod_two() -> list[list[int]]:
    """Columns of [P^t | I_5], where R10=[I_5 | P]."""
    p = [row[5:] for row in R10]
    dual = [
        [p[column][row] & 1 for column in range(5)]
        + [int(row == column) for column in range(5)]
        for row in range(5)
    ]
    return [[dual[row][column] for row in range(5)] for column in range(10)]


def reduced_edges() -> list[tuple[int, int, int]]:
    """The 160 oriented edges used for the reduced p=2 graph."""
    edges: list[tuple[int, int, int]] = []
    for colour, column in enumerate(dual_columns_mod_two()):
        pivot = next(index for index, value in enumerate(column) if value)
        column_mask = sum(value << (4 - index) for index, value in enumerate(column))
        for start in range(32):
            if (start >> (4 - pivot)) & 1:
                continue
            edges.append((colour, start, start ^ column_mask))
    assert len(edges) == 160
    return edges


def constraint_rows() -> list[int]:
    """Pack every 160-entry F_2 row into a Python integer."""
    rows = [0] * 160
    for edge_index, (colour, start, end) in enumerate(reduced_edges()):
        if colour < 5:
            components = [colour]
        else:
            components = [row for row in range(5) if R10[row][colour] & 1]
        for component in components:
            rows[32 * component + start] ^= 1 << edge_index
            rows[32 * component + end] ^= 1 << edge_index
    return rows


def profile_rows() -> list[int]:
    edges = reduced_edges()
    return [
        sum(1 << edge_index for edge_index, edge in enumerate(edges) if edge[0] == colour)
        for colour in range(10)
    ]


def row_basis_with_witnesses(rows: list[int]) -> dict[int, tuple[int, int]]:
    """Echelon basis together with combinations of the original rows."""
    basis: dict[int, tuple[int, int]] = {}
    for row_index, original in enumerate(rows):
        vector = original
        witness = 1 << row_index
        while vector:
            pivot = vector.bit_length() - 1
            if pivot not in basis:
                basis[pivot] = (vector, witness)
                break
            basis_vector, basis_witness = basis[pivot]
            vector ^= basis_vector
            witness ^= basis_witness
    return basis


def express_in_basis(vector: int, basis: dict[int, tuple[int, int]]) -> int:
    witness = 0
    while vector:
        pivot = vector.bit_length() - 1
        if pivot not in basis:
            raise AssertionError("profile row is not in the constraint row span")
        basis_vector, basis_witness = basis[pivot]
        vector ^= basis_vector
        witness ^= basis_witness
    return witness


def xor_selected(rows: list[int], selection: int) -> int:
    value = 0
    for row_index, row in enumerate(rows):
        if (selection >> row_index) & 1:
            value ^= row
    return value


def direct_rank(rows: list[int], width: int) -> int:
    """Independent left-to-right elimination, without witness tracking."""
    work = rows[:]
    rank = 0
    for column in range(width):
        pivot = next(
            (row for row in range(rank, len(work)) if (work[row] >> column) & 1),
            None,
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        for row in range(len(work)):
            if row != rank and ((work[row] >> column) & 1):
                work[row] ^= work[rank]
        rank += 1
    return rank


def packed_sha256(rows: list[int]) -> str:
    packed = b"".join(row.to_bytes(20, "little") for row in rows)
    return hashlib.sha256(packed).hexdigest()


def lean_match_values(source: str, start: str, end: str, pattern: str) -> list[int]:
    block = source.split(start, 1)[1].split(end, 1)[0]
    return [int(value, 0) for value in re.findall(pattern, block)]


def check_lean_semantic_constants(combinations: list[int]) -> None:
    """Prevent the independent Lean checker and this reconstruction drifting."""
    source = LEAN_MODULE.read_text(encoding="utf-8")
    dual_masks = [sum(value << (4 - row) for row, value in enumerate(column))
                  for column in dual_columns_mod_two()]
    component_masks = [1 << colour for colour in range(5)] + [
        sum((R10[row][colour] & 1) << row for row in range(5))
        for colour in range(5, 10)
    ]
    assert lean_match_values(
        source, "def dualColumnMask", "/-- The components", r"=>\s+(\d+)"
    ) == dual_masks
    assert lean_match_values(
        source, "def componentMask", "/-- Insert a zero", r"=>\s+(\d+)"
    ) == component_masks
    assert lean_match_values(
        source, "def combinationMask", "/-- The admissibility matrix", r"=>\s+(0x[0-9a-f]+)"
    ) == combinations


def build_certificate() -> dict[str, object]:
    constraints = constraint_rows()
    profiles = profile_rows()
    basis = row_basis_with_witnesses(constraints)
    combinations = [express_in_basis(profile, basis) for profile in profiles]

    for profile, combination in zip(profiles, combinations, strict=True):
        assert xor_selected(constraints, combination) == profile
    check_lean_semantic_constants(combinations)

    constraint_rank = direct_rank(constraints, 160)
    augmented_rank = direct_rank(constraints + profiles, 160)
    assert constraint_rank == len(basis) == 125
    assert augmented_rank == constraint_rank

    return {
        "schema": SCHEMA,
        "source": {
            "paper": "Engel--de Gaay Fortman--Schreieder, arXiv:2507.15704v3, Proposition 7.6",
            "authors_code_commit": "6305aa878949d17e793e99cd6cb7203f30dbf64c",
        },
        "input": {
            "field": "F_2",
            "matroid": "R10",
            "matrix": R10,
            "reduced_graph": True,
        },
        "dimensions": {
            "vertices": 32,
            "edges": 160,
            "constraint_rows": 160,
            "profile_rows": 10,
            "constraint_rank": constraint_rank,
            "augmented_rank": augmented_rank,
            "solution_dimension": 160 - constraint_rank,
        },
        "row_hashes": {
            "constraints_packed_little_endian_sha256": packed_sha256(constraints),
            "profiles_packed_little_endian_sha256": packed_sha256(profiles),
        },
        "profile_factorizations": [
            {
                "colour": colour,
                "constraint_row_indices": [
                    row for row in range(160) if (combination >> row) & 1
                ],
                "combination_mask_hex": f"{combination:040x}",
                "profile_mask_hex": f"{profiles[colour]:040x}",
            }
            for colour, combination in enumerate(combinations)
        ],
        "independent_cross_check": (
            "A second left-to-right elimination, independent of the witness-producing "
            "right-pivot basis, gives rank(constraints)=rank(constraints+profiles)=125."
        ),
        "lean_semantic_cross_check": (
            "The replay parses the Lean module and checks its ten dual-column masks, "
            "ten component-support masks, and ten combination masks against this "
            "independent reconstruction."
        ),
        "trust_boundary": (
            "This certifies only the finite R10 F_2 Albanese-graph statement: every "
            "colour profile vanishes on every solution of the 160 constraint equations. "
            "It does not verify the geometric reduction to this system, the regular-matroid "
            "structure theorem, or the deduction to the minimal theta class."
        ),
    }


def canonical_json(value: object) -> str:
    return json.dumps(value, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = canonical_json(build_certificate())
    if args.check:
        if not CERTIFICATE.is_file() or CERTIFICATE.read_text(encoding="utf-8") != rendered:
            raise SystemExit("R10 Albanese parity certificate is stale; regenerate without --check")
        print("R10 Albanese parity exact certificate: CHECK OK")
        return
    CERTIFICATE.write_text(rendered, encoding="utf-8")
    print(f"wrote {CERTIFICATE.name}")


if __name__ == "__main__":
    main()
