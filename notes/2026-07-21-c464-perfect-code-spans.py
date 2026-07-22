#!/usr/bin/env python3
"""Generate the deterministic C464 perfect-code span certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
from pathlib import Path


NOTES = Path(__file__).resolve().parent
REPO = NOTES.parent
OUTPUT = NOTES / "2026-07-21-c464-perfect-code-spans.json"
INPUT_HASHES = {
    "notes/2026-07-20-c406-matching-orbit-scout.json":
        "fec533bb91f864100ebf5875952244d9d9e03ed69a0abda767360907a55bb246",
    "notes/2026-07-21-c450-weil-cross-sheet.json":
        "a6fc2d854732011c82b6b5c1440b407b64041bd31f4bac59adec15c1f127353f",
    "notes/2026-07-21-c450-weil-cross-sheet.md":
        "a2a44443bda868a4c2abc309e3f20e0e862116a081afa8e28254f2054ae44b71",
    "notes/2026-07-21-c452-qr-barker.json":
        "6f5829b2de929bfa40f5c6c657896e58fd26f9c2157bde89b7387757b4f887c2",
    "notes/2026-07-21-c452-qr-barker.md":
        "c65ab22994b4bcb45621bb9d5f3358fd602ee28b5b7daf55fbc982ece75288d7",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_inputs() -> None:
    for relative, expected in INPUT_HASHES.items():
        actual = sha256(REPO / relative)
        if actual != expected:
            raise RuntimeError(f"input hash mismatch for {relative}: {actual} != {expected}")


def rref(rows: list[list[int]], p: int) -> tuple[list[list[int]], list[int]]:
    a = [[x % p for x in row] for row in rows]
    if not a:
        return [], []
    m, n = len(a), len(a[0])
    pivot_row = 0
    pivots: list[int] = []
    for column in range(n):
        pivot = next((i for i in range(pivot_row, m) if a[i][column]), None)
        if pivot is None:
            continue
        a[pivot_row], a[pivot] = a[pivot], a[pivot_row]
        inverse = pow(a[pivot_row][column], -1, p)
        a[pivot_row] = [(inverse * x) % p for x in a[pivot_row]]
        for i in range(m):
            if i != pivot_row and a[i][column]:
                multiplier = a[i][column]
                a[i] = [(x - multiplier * y) % p for x, y in zip(a[i], a[pivot_row])]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == m:
            break
    return a[:pivot_row], pivots


def nullspace(rows: list[list[int]], p: int) -> list[list[int]]:
    reduced, pivots = rref(rows, p)
    n = len(rows[0])
    free = [j for j in range(n) if j not in pivots]
    basis = []
    for column in free:
        vector = [0] * n
        vector[column] = 1
        for i, pivot in enumerate(pivots):
            vector[pivot] = (-reduced[i][column]) % p
        basis.append(vector)
    return rref(basis, p)[0]


def vector_sum(coefficients: tuple[int, ...], rows: list[list[int]], p: int) -> list[int]:
    return [sum(c * row[j] for c, row in zip(coefficients, rows)) % p
            for j in range(len(rows[0]))]


def enumerate_code(generator: list[list[int]], p: int) -> list[list[int]]:
    return [vector_sum(c, generator, p)
            for c in itertools.product(range(p), repeat=len(generator))]


def weight_distribution(words: list[list[int]], n: int) -> dict[str, int]:
    counts = {str(weight): 0 for weight in range(n + 1)}
    for word in words:
        counts[str(sum(x != 0 for x in word))] += 1
    return counts


def sphere_data(n: int, p: int, dimension: int, minimum_distance: int) -> dict[str, object]:
    radius = (minimum_distance - 1) // 2
    terms = [math.comb(n, i) * (p - 1) ** i for i in range(radius + 1)]
    volume = sum(terms)
    code_size = p ** dimension
    ambient_size = p ** n
    return {
        "ambient_size": ambient_size,
        "code_size": code_size,
        "code_size_times_sphere_volume": code_size * volume,
        "equality": code_size * volume == ambient_size,
        "radius": radius,
        "sphere_terms": terms,
        "sphere_volume": volume,
    }


def matmul(left: list[list[int]], right: list[list[int]], p: int) -> list[list[int]]:
    return [[sum(x * right[k][j] for k, x in enumerate(row)) % p
             for j in range(len(right[0]))] for row in left]


def coefficients_for(target: list[int], basis: list[list[int]], p: int) -> list[int]:
    for coefficients in itertools.product(range(p), repeat=len(basis)):
        if vector_sum(coefficients, basis, p) == target:
            return list(coefficients)
    raise AssertionError("target is not in the asserted span")


def hamming_equivalence(source: list[list[int]]) -> dict[str, object]:
    parity_check = [[(value >> bit) & 1 for value in range(1, 8)]
                    for bit in (2, 1, 0)]
    standard_generator = nullspace(parity_check, 2)
    for permutation in itertools.permutations(range(7)):
        permuted = [[row[j] for j in permutation] for row in source]
        if rref(permuted, 2)[0] != standard_generator:
            continue
        row_operation = [coefficients_for(row, permuted, 2) for row in standard_generator]
        if matmul(row_operation, permuted, 2) != standard_generator:
            raise AssertionError("failed explicit Hamming generator equivalence")
        return {
            "coordinate_permutation_new_to_old_zero_based": list(permutation),
            "equation": "row_operation_matrix * permuted_source_generator = standard_generator_matrix over F_2",
            "permuted_source_generator": permuted,
            "row_operation_matrix": row_operation,
            "source_generator_matrix": source,
            "standard_generator_matrix": standard_generator,
            "standard_parity_check_columns_are_binary_1_through_7": parity_check,
            "verified_product": matmul(row_operation, permuted, 2),
        }
    raise AssertionError("no coordinate permutation identifies the span with the standard Hamming code")


def relation_record(matrix: list[list[int]], p: int) -> dict[str, object]:
    generator, _ = rref(matrix, p)
    words = enumerate_code(generator, p)
    distribution = weight_distribution(words, len(matrix))
    nonzero_weights = [int(w) for w, count in distribution.items() if int(w) and count]
    minimum_distance = min(nonzero_weights)
    return {
        "code_size": len(words),
        "enumeration": f"all {p}^{len(generator)} coefficient tuples in lexicographic order",
        "field_order": p,
        "generator_matrix_rref": generator,
        "incidence_matrix": matrix,
        "length": len(matrix),
        "minimum_distance": minimum_distance,
        "parity_check_matrix_rref": nullspace(generator, p),
        "rank": len(generator),
        "sphere_packing": sphere_data(len(matrix), p, len(generator), minimum_distance),
        "weight_distribution_all_weights": distribution,
    }


def dot(left: list[int], right: list[int], p: int) -> int:
    return sum(x * y for x, y in zip(left, right)) % p


def build() -> dict[str, object]:
    verify_inputs()
    c452 = json.loads((NOTES / "2026-07-21-c452-qr-barker.json").read_text())
    c450 = json.loads((NOTES / "2026-07-21-c450-weil-cross-sheet.json").read_text())
    c406_pin = c452["inputs"]["notes/2026-07-20-c406-matching-orbit-scout.json"]
    if c406_pin != INPUT_HASHES["notes/2026-07-20-c406-matching-orbit-scout.json"]:
        raise RuntimeError("C452 does not carry the frozen C406 certificate pin")

    cases = []
    for frozen in c452["cases"]:
        q = frozen["q"]
        p = 2 if q == 7 else 3
        difference_set = frozen["cross_disjointness_difference_set"]
        disjoint = [[int((column - row) % q in difference_set) for column in range(q)]
                    for row in range(q)]
        if disjoint != frozen["cross_disjointness_matrix"]:
            raise RuntimeError(f"C452 circulant reconstruction failed at q={q}")
        shared = [[1 - x for x in row] for row in disjoint]
        relations = {
            "disjoint": relation_record(disjoint, p),
            "shared_edge": relation_record(shared, p),
        }

        c450_case = next(case for case in c450["finite_actions"] if case["q"] == q)
        checks = {}
        for name in ("disjoint", "shared_edge"):
            expected_rank = c450_case["relations"][name]["ranks_mod_2_3"][str(p)]
            computed_rank = relations[name]["rank"]
            agreement = computed_rank == expected_rank
            checks[name] = {
                "agreement": agreement,
                "c450_certified_modular_nullity": q - expected_rank,
                "c450_certified_modular_rank": expected_rank,
                "computed_nullity": q - computed_rank,
                "computed_rank": computed_rank,
            }
            if not agreement:
                raise RuntimeError(
                    f"BLOCKER: q={q} {name} rank {computed_rank} disagrees with C450 {expected_rank}"
                )

        disjoint_generator = relations["disjoint"]["generator_matrix_rref"]
        shared_generator = relations["shared_edge"]["generator_matrix_rref"]
        orthogonal = all(dot(x, y, p) == 0 for x in disjoint_generator for y in shared_generator)
        dimensions_sum = len(disjoint_generator) + len(shared_generator) == q
        cases.append({
            "design_complement_pair": {
                "dimensions_sum_to_length": dimensions_sum,
                "shared_edge_span_equals_disjoint_dual": orthogonal and dimensions_sum,
                "spans_are_mutually_orthogonal": orthogonal,
            },
            "field_order": p,
            "frozen_cross_disjointness_difference_set": difference_set,
            "hamming_7_4_3_generator_equivalence": (
                hamming_equivalence(disjoint_generator) if q == 7 else None
            ),
            "q": q,
            "rank_cross_check_against_c450": checks,
            "relations": relations,
            "type": frozen["type"],
        })

    return {
        "cases": cases,
        "inputs": INPUT_HASHES,
        "method": "exact prime-field row reduction and exhaustive enumeration of every codeword",
        "schema": "c464-perfect-code-spans-v1",
        "scope": {
            "classification_claims": False,
            "equivariance_certified": False,
            "named_identifications": ["binary [7,4,3] Hamming", "ternary [11,6,5] Golay"],
        },
        "task": "C464",
    }


def encoded(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="compare with the tracked certificate")
    args = parser.parse_args()
    result = encoded(build())
    if args.check:
        if not OUTPUT.exists() or OUTPUT.read_bytes() != result:
            raise SystemExit("certificate is missing or stale")
        print("C464 primary check: PASS")
    else:
        OUTPUT.write_bytes(result)
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
