#!/usr/bin/env python3
"""Generate the deterministic C464 perfect-code span certificate."""

from __future__ import annotations

import argparse
from collections import Counter
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


def macwilliams_transform(distribution: dict[str, int], n: int, p: int) -> list[int]:
    code_size = sum(distribution.values())
    transformed = []
    for target_weight in range(n + 1):
        numerator = 0
        for source_weight in range(n + 1):
            krawtchouk = 0
            for intersection in range(target_weight + 1):
                outside = target_weight - intersection
                if intersection <= source_weight and outside <= n - source_weight:
                    krawtchouk += (
                        (-1) ** intersection
                        * (p - 1) ** outside
                        * math.comb(source_weight, intersection)
                        * math.comb(n - source_weight, outside)
                    )
            numerator += distribution[str(source_weight)] * krawtchouk
        if numerator % code_size:
            raise AssertionError("nonintegral MacWilliams coefficient")
        transformed.append(numerator // code_size)
    return transformed


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
    minimum_words = {tuple(word) for word in words if sum(x != 0 for x in word) == minimum_distance}
    minimum_supports = {tuple(i for i, value in enumerate(word) if value)
                        for word in minimum_words}
    row_multiples = {
        tuple((scalar * x) % p for x in row)
        for row in matrix
        for scalar in range(1, p)
    }
    rows_are_minimum = row_multiples <= minimum_words
    row_supports = {tuple(i for i, value in enumerate(word) if value) for word in row_multiples}
    common = math.gcd(len(row_multiples), len(minimum_words))
    return {
        "code_size": len(words),
        "enumeration": f"all {p}^{len(generator)} coefficient tuples in lexicographic order",
        "field_order": p,
        "generator_matrix_rref": generator,
        "incidence_matrix": matrix,
        "incidence_minimum_word_coverage": {
            "all_nonzero_scalar_multiples_are_minimum_words": rows_are_minimum,
            "distinct_nonzero_scalar_multiples": len(row_multiples),
            "exhausts_all_minimum_words": rows_are_minimum and row_multiples == minimum_words,
            "fraction_of_minimum_words": [
                len(row_multiples) // common,
                len(minimum_words) // common,
            ],
            "distinct_minimum_word_supports": len(minimum_supports),
            "incidence_row_supports": len(row_supports),
            "remaining_minimum_word_supports": len(minimum_supports - row_supports),
            "total_minimum_words": len(minimum_words),
        },
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
        disjoint_distribution = relations["disjoint"]["weight_distribution_all_weights"]
        shared_distribution = relations["shared_edge"]["weight_distribution_all_weights"]
        disjoint_transform = macwilliams_transform(disjoint_distribution, q, p)
        shared_transform = macwilliams_transform(shared_distribution, q, p)
        disjoint_coefficients = [disjoint_distribution[str(i)] for i in range(q + 1)]
        shared_coefficients = [shared_distribution[str(i)] for i in range(q + 1)]
        disjoint_words = {tuple(word) for word in enumerate_code(disjoint_generator, p)}
        shared_words = {tuple(word) for word in enumerate_code(shared_generator, p)}
        all_one = tuple([1] * q)
        quotient_cosets = []
        quotient_union = set()
        for scalar in range(p):
            coset = {tuple((value + scalar) % p for value in word) for word in shared_words}
            quotient_union |= coset
            quotient_cosets.append({
                "all_one_scalar": scalar,
                "weight_distribution_all_weights": weight_distribution([list(word) for word in coset], q),
            })
        dual_is_subcode = shared_words <= disjoint_words
        all_one_splits = all_one in disjoint_words and all_one not in shared_words
        quotient_exhausts = quotient_union == disjoint_words
        if not (dual_is_subcode and all_one_splits and quotient_exhausts):
            raise AssertionError(f"q={q}: failed C=C^perp direct-sum <1> check")
        support_structure = None
        projective_support_spectrum = None
        if q == 11:
            minimum_supports = {
                tuple(i for i, value in enumerate(word) if value)
                for word in disjoint_words if sum(value != 0 for value in word) == 5
            }
            row_supports = [tuple(i for i, value in enumerate(row) if value)
                            for row in disjoint]
            residual_supports = minimum_supports - set(row_supports)
            edge_map = []
            formula_supports = set()
            for left, right in itertools.combinations(range(q), 2):
                codeword = tuple((1 - disjoint[left][i] - disjoint[right][i]) % p
                                 for i in range(q))
                support = tuple(i for i, value in enumerate(codeword) if value)
                if codeword not in disjoint_words or len(support) != 5:
                    raise AssertionError("K11 edge formula did not produce a minimum word")
                formula_supports.add(support)
                edge_map.append({"row_pair": [left, right], "residual_support": list(support)})
            if formula_supports != residual_supports or len(formula_supports) != math.comb(q, 2):
                raise AssertionError("K11 edge formula does not biject onto residual supports")
            four_counts = Counter(subset for block in minimum_supports
                                  for subset in itertools.combinations(block, 4))
            selected_pair_counts = Counter(subset for block in row_supports
                                           for subset in itertools.combinations(block, 2))
            residual_pair_counts = Counter(subset for block in residual_supports
                                           for subset in itertools.combinations(block, 2))
            intersection_patterns = Counter(
                tuple(sorted(Counter(len(set(block) & set(row))
                                     for row in row_supports).items()))
                for block in residual_supports
            )
            assert Counter(four_counts.values()) == {1: math.comb(q, 4)}
            assert Counter(selected_pair_counts.values()) == {2: math.comb(q, 2)}
            assert Counter(residual_pair_counts.values()) == {10: math.comb(q, 2)}
            assert intersection_patterns == {((1, 3), (2, 2), (3, 6)): 55}
            support_structure = {
                "all_minimum_supports_form_steiner_4_11_5_1": True,
                "all_minimum_support_count": len(minimum_supports),
                "all_four_subsets_covered_once": len(four_counts),
                "selected_rows_form_2_11_5_2": True,
                "residual_supports_form_2_11_5_10": True,
                "residual_support_count": len(residual_supports),
                "residual_intersections_with_selected_rows": {"1": 3, "2": 2, "3": 6},
                "k11_edge_bijection_formula": "support(1 - row_i - row_j) = complement(support(row_i) symmetric_difference support(row_j)) over F_3",
                "k11_edge_to_residual_support": edge_map,
            }
            projective_support_spectrum = {}
            supports_by_weight = {}
            for weight in (5, 6, 8, 9, 11):
                weight_words = [word for word in disjoint_words
                                if sum(value != 0 for value in word) == weight]
                support_fibres: dict[tuple[int, ...], list[tuple[int, ...]]] = {}
                projective_words = set()
                for word in weight_words:
                    support = tuple(i for i, value in enumerate(word) if value)
                    support_fibres.setdefault(support, []).append(word)
                    first = next(value for value in word if value)
                    inverse = pow(first, -1, p)
                    projective_words.add(tuple(inverse * value % p for value in word))
                supports_by_weight[weight] = set(support_fibres)
                projective_support_spectrum[str(weight)] = {
                    "word_count": len(weight_words),
                    "projective_scalar_orbits": len(projective_words),
                    "support_count": len(support_fibres),
                    "words_per_support_histogram": {
                        str(size): count
                        for size, count in sorted(Counter(map(len, support_fibres.values())).items())
                    },
                }
            assert supports_by_weight[6] == {
                tuple(i for i in range(q) if i not in support)
                for support in supports_by_weight[5]
            }
            assert supports_by_weight[8] == set(itertools.combinations(range(q), 8))
            assert supports_by_weight[9] == set(itertools.combinations(range(q), 9))
            assert supports_by_weight[11] == {tuple(range(q))}
            projective_support_spectrum["forced_support_families"] = {
                "weight_6_are_complements_of_weight_5": True,
                "weight_8_are_all_8_subsets": True,
                "weight_9_are_all_9_subsets": True,
                "weight_11_has_full_support": True,
            }
        cases.append({
            "design_complement_pair": {
                "all_one_quotient_coset_distributions": quotient_cosets,
                "all_one_word_generates_quotient": all_one_splits,
                "direct_sum_with_all_one_line": True,
                "dimensions_sum_to_length": dimensions_sum,
                "dual_is_subcode_of_disjoint_span": dual_is_subcode,
                "macwilliams_disjoint_to_shared_coefficients": disjoint_transform,
                "macwilliams_shared_to_disjoint_coefficients": shared_transform,
                "macwilliams_transforms_agree": (
                    disjoint_transform == shared_coefficients
                    and shared_transform == disjoint_coefficients
                ),
                "shared_edge_span_equals_disjoint_dual": orthogonal and dimensions_sum,
                "spans_are_mutually_orthogonal": orthogonal,
                "quotient_dimension": 1,
                "quotient_cosets_exhaust_disjoint_span": quotient_exhausts,
            },
            "field_order": p,
            "frozen_cross_disjointness_difference_set": difference_set,
            "hamming_7_4_3_generator_equivalence": (
                hamming_equivalence(disjoint_generator) if q == 7 else None
            ),
            "q": q,
            "rank_cross_check_against_c450": checks,
            "relations": relations,
            "projective_weight_support_spectrum": projective_support_spectrum,
            "third_order_minimum_support_structure": support_structure,
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
