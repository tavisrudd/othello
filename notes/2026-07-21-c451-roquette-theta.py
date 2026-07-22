#!/usr/bin/env python3
"""Pre-gate C451 certificate: matching Lagrangians and Cartier--Manin matrices."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
INPUT = ROOT / "notes/2026-07-20-c406-matching-orbit-scout.json"
OUTPUT = ROOT / "notes/2026-07-21-c451-roquette-theta.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def rank2(rows: list[int]) -> int:
    rows = rows[:]
    rank = 0
    while rows:
        pivot = max(rows)
        rows.remove(pivot)
        if not pivot:
            continue
        bit = 1 << (pivot.bit_length() - 1)
        rows = [row ^ pivot if row & bit else row for row in rows]
        rank += 1
    return rank


def pairing(left: int, right: int) -> int:
    return (left & right).bit_count() & 1


def subset(mask: int, size: int) -> list[int]:
    return [i for i in range(size) if mask >> i & 1]


def symplectic_basis(size: int) -> list[dict[str, list[int]]]:
    # The even-subset quotient has basis {i,last}, 0 <= i < size-2.
    work = [(1 << i) | (1 << (size - 1)) for i in range(size - 2)]
    pairs = []
    while work:
        left = work.pop(0)
        partner = next(i for i, row in enumerate(work) if pairing(left, row))
        right = work.pop(partner)
        reduced = []
        for row in work:
            row ^= pairing(row, right) * left
            row ^= pairing(row, left) * right
            reduced.append(row)
        work = reduced
        pairs.append({"a": subset(left, size), "b": subset(right, size)})
    flat = [sum(1 << i for i in pair[key]) for pair in pairs for key in ("a", "b")]
    gram = [[pairing(x, y) for y in flat] for x in flat]
    expected = [
        [int(i // 2 == j // 2 and i != j) for j in range(len(flat))]
        for i in range(len(flat))
    ]
    assert gram == expected
    return pairs


def projective_matrices(q: int, determinant_square: bool) -> list[tuple[int, ...]]:
    squares = {x * x % q for x in range(1, q)}
    matrices = set()
    for a, b, c, d in itertools.product(range(q), repeat=4):
        det = (a * d - b * c) % q
        if not det or (det in squares) != determinant_square:
            continue
        raw = (a, b, c, d)
        first = next(x for x in raw if x)
        inverse = pow(first, -1, q)
        matrices.add(tuple(x * inverse % q for x in raw))
    return sorted(matrices)


def permutation(matrix: tuple[int, ...], endpoints: list[list[int]], q: int) -> tuple[int, ...]:
    a, b, c, d = matrix
    index = {tuple(point): i for i, point in enumerate(endpoints)}
    result = []
    for x, y in endpoints:
        u, v = (a * x + b * y) % q, (c * x + d * y) % q
        if u:
            point = (1, v * pow(u, -1, q) % q)
        else:
            point = (0, 1)
        result.append(index[point])
    return tuple(result)


def act_matching(matching: tuple[tuple[int, int], ...], perm: tuple[int, ...]) -> tuple[tuple[int, int], ...]:
    return tuple(sorted(tuple(sorted((perm[a], perm[b]))) for a, b in matching))


def matching_vectors(matching: tuple[tuple[int, int], ...]) -> list[int]:
    # Omitting any one edge removes the unique all-branch-points relation.
    return [(1 << a) | (1 << b) for a, b in matching[:-1]]


def union_cycle_count(left: tuple[tuple[int, int], ...], right: tuple[tuple[int, int], ...]) -> int:
    vertices = {v for edge in left for v in edge}
    adjacency = {v: set() for v in vertices}
    for a, b in left + right:
        adjacency[a].add(b)
        adjacency[b].add(a)
    components = 0
    unseen = set(vertices)
    while unseen:
        components += 1
        stack = [unseen.pop()]
        while stack:
            for neighbor in adjacency[stack.pop()]:
                if neighbor in unseen:
                    unseen.remove(neighbor)
                    stack.append(neighbor)
    return components


def intersection_dimension(left: tuple[tuple[int, int], ...], right: tuple[tuple[int, int], ...]) -> int:
    g = len(left) - 1
    size = 2 * len(left)
    quotient_rank = rank2(matching_vectors(left) + matching_vectors(right) + [(1 << size) - 1]) - 1
    linear_algebra = 2 * g - quotient_rank
    cycles = union_cycle_count(left, right) - 1
    assert linear_algebra == cycles
    return linear_algebra


def cartier_manin(p: int) -> dict[str, object]:
    g = (p - 1) // 2
    coefficients = {}
    for k in range(g + 1):
        exponent = g + (p - 1) * k
        coefficients[exponent] = math.comb(g, k) * (-1) ** (g - k) % p
    matrix = [
        [coefficients.get(p * (i + 1) - (j + 1), 0) for j in range(g)]
        for i in range(g)
    ]
    assert all(entry == 0 for row in matrix for entry in row)
    return {
        "coefficient_support": [[degree, coefficients[degree]] for degree in sorted(coefficients)],
        "matrix_convention": "H[i,j] = coefficient of x^(p*(i+1)-(j+1)) in (x^p-x)^((p-1)/2)",
        "matrix": matrix,
        "rank": 0,
        "p_rank": 0,
        "a_number": g,
        "jacobian_superspecial": True,
        "jacobian_supersingular": True,
    }


def build() -> dict[str, object]:
    source = json.loads(INPUT.read_text())
    records = []
    for frozen in source["types"]:
        name, q = frozen["type"], frozen["field_order"]
        endpoints = frozen["p1_endpoints"]
        size, g = len(endpoints), (q - 1) // 2
        base = tuple(tuple(edge) for edge in frozen["coxeter_invariant_matching"])
        psl = projective_matrices(q, True)
        permutations = [permutation(matrix, endpoints, q) for matrix in psl]
        orbit = sorted({act_matching(base, perm) for perm in permutations})
        assert [len(orbit)] == frozen["psl_target_orbit_sizes"][:1]
        # For B3/H3 the other frozen sheet is the complementary PSL orbit in the PGL orbit.
        all_pgl = projective_matrices(q, True) + projective_matrices(q, False)
        full_orbit = sorted({act_matching(base, permutation(matrix, endpoints, q)) for matrix in all_pgl})
        sheets = [orbit]
        complement = sorted(set(full_orbit) - set(orbit))
        if complement:
            sheets.append(complement)
        assert [len(sheet) for sheet in sheets] == frozen["psl_target_orbit_sizes"]

        sheet_records = []
        for sheet_index, sheet in enumerate(sheets):
            edge_counts = {edge: 0 for edge in itertools.combinations(range(size), 2)}
            lagrangians = []
            for matching in sheet:
                for edge in matching:
                    edge_counts[edge] += 1
                basis = matching_vectors(matching)
                assert rank2(basis) == g
                assert all(pairing(x, y) == 0 for x in basis for y in basis)
                lagrangians.append({
                    "matching": [list(edge) for edge in matching],
                    "basis_even_subsets": [subset(row, size) for row in basis],
                    "dimension": g,
                })
            incidence = [[intersection_dimension(left, right) for right in sheet] for left in sheet]
            transverse_off_diagonal = all(
                incidence[i][j] == 0 for i in range(len(sheet)) for j in range(len(sheet)) if i != j
            )
            off_diagonal_histogram = {
                str(dimension): sum(
                    incidence[i][j] == dimension
                    for i in range(len(sheet))
                    for j in range(i + 1, len(sheet))
                )
                for dimension in sorted({
                    incidence[i][j]
                    for i in range(len(sheet))
                    for j in range(i + 1, len(sheet))
                })
            }
            assert set(edge_counts.values()) == {1}
            sheet_records.append({
                "sheet": sheet_index,
                "matching_count": len(sheet),
                "weierstrass_pair_class_count": len(edge_counts),
                "weierstrass_pair_multiplicities": sorted(set(edge_counts.values())),
                "lagrangians": lagrangians,
                "intersection_dimensions": incidence,
                "unordered_off_diagonal_intersection_histogram": off_diagonal_histogram,
                "pairwise_transverse": transverse_off_diagonal,
            })
        records.append({
            "type": name,
            "q": q,
            "genus": g,
            "branch_points": endpoints,
            "j2_model": {
                "description": "even subsets of branch labels modulo complementation",
                "dimension": 2 * g,
                "pairing": "cardinality of intersection modulo 2",
                "symplectic_basis": symplectic_basis(size),
            },
            "packings": sheet_records,
            "cartier_manin": cartier_manin(q),
        })
    return {
        "schema": "c451-roquette-theta-pre-gate-v1",
        "status": "pre_theta_judgment_gate",
        "input": {
            "path": "notes/2026-07-20-c406-matching-orbit-scout.json",
            "sha256": sha256(INPUT),
        },
        "types": records,
        "theta_gate": {
            "crossed": False,
            "parity_values": None,
            "row_verdict": None,
        },
    }


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    encoded = canonical_bytes(build())
    if args.write:
        OUTPUT.write_bytes(encoded)
        return
    with tempfile.TemporaryDirectory() as directory:
        candidate = Path(directory) / OUTPUT.name
        candidate.write_bytes(encoded)
        if not OUTPUT.exists() or candidate.read_bytes() != OUTPUT.read_bytes():
            raise SystemExit(f"stale or missing certificate: run {Path(__file__).name} --write")


if __name__ == "__main__":
    main()
