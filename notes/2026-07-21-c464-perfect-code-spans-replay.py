#!/usr/bin/env python3
"""Independent replay of the C464 certificate; imports no primary code."""

from __future__ import annotations

import hashlib
import itertools
import json
import math
from pathlib import Path


NOTES = Path(__file__).resolve().parent
REPO = NOTES.parent
CERTIFICATE = NOTES / "2026-07-21-c464-perfect-code-spans.json"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def add_to_basis(basis: dict[int, list[int]], vector: list[int], p: int) -> bool:
    v = [x % p for x in vector]
    while any(v):
        lead = next(i for i, x in enumerate(v) if x)
        if lead not in basis:
            inverse = pow(v[lead], -1, p)
            v = [(inverse * x) % p for x in v]
            basis[lead] = v
            return True
        multiplier = v[lead]
        v = [(x - multiplier * y) % p for x, y in zip(v, basis[lead])]
    return False


def rank(rows: list[list[int]], p: int) -> int:
    basis: dict[int, list[int]] = {}
    for row in rows:
        add_to_basis(basis, row, p)
    return len(basis)


def span_from_incidence(rows: list[list[int]], p: int) -> set[tuple[int, ...]]:
    span = {tuple(0 for _ in rows[0])}
    for row in rows:
        old = list(span)
        span = {tuple((word[j] + scalar * row[j]) % p for j in range(len(row)))
                for word in old for scalar in range(p)}
    return span


def distribution(words: set[tuple[int, ...]], n: int) -> dict[str, int]:
    answer = {str(i): 0 for i in range(n + 1)}
    for word in words:
        answer[str(sum(x != 0 for x in word))] += 1
    return answer


def macwilliams(counts: dict[str, int], n: int, p: int) -> list[int]:
    size = sum(counts.values())
    answer = []
    for j in range(n + 1):
        total = 0
        for w in range(n + 1):
            polynomial = sum(
                (-1) ** s * (p - 1) ** (j - s)
                * math.comb(w, s) * math.comb(n - w, j - s)
                for s in range(j + 1)
                if s <= w and j - s <= n - w
            )
            total += counts[str(w)] * polynomial
        assert total % size == 0
        answer.append(total // size)
    return answer


def multiply(left: list[list[int]], right: list[list[int]], p: int) -> list[list[int]]:
    return [[sum(left[i][k] * right[k][j] for k in range(len(right))) % p
             for j in range(len(right[0]))] for i in range(len(left))]


def main() -> None:
    cert = json.loads(CERTIFICATE.read_text())
    assert cert["schema"] == "c464-perfect-code-spans-v1"
    for relative, expected in cert["inputs"].items():
        assert digest(REPO / relative) == expected

    frozen = json.loads((NOTES / "2026-07-21-c452-qr-barker.json").read_text())
    c450 = json.loads((NOTES / "2026-07-21-c450-weil-cross-sheet.json").read_text())
    frozen_by_q = {case["q"]: case for case in frozen["cases"]}
    c450_by_q = {case["q"]: case for case in c450["finite_actions"]}

    for case in cert["cases"]:
        q, p = case["q"], case["field_order"]
        difference_set = frozen_by_q[q]["cross_disjointness_difference_set"]
        disjoint = [[int((j - i) % q in difference_set) for j in range(q)] for i in range(q)]
        assert disjoint == frozen_by_q[q]["cross_disjointness_matrix"]
        matrices = {"disjoint": disjoint, "shared_edge": [[1 - x for x in row] for row in disjoint]}

        replay_spans = {}
        for name, matrix in matrices.items():
            recorded = case["relations"][name]
            assert recorded["incidence_matrix"] == matrix
            computed_rank = rank(matrix, p)
            expected_rank = c450_by_q[q]["relations"][name]["ranks_mod_2_3"][str(p)]
            assert computed_rank == expected_rank == recorded["rank"]
            assert q - computed_rank == case["rank_cross_check_against_c450"][name]["computed_nullity"]

            words = span_from_incidence(matrix, p)
            replay_spans[name] = words
            weights = distribution(words, q)
            assert len(words) == p ** computed_rank == recorded["code_size"]
            assert weights == recorded["weight_distribution_all_weights"]
            minimum = min(int(w) for w, count in weights.items() if int(w) and count)
            assert minimum == recorded["minimum_distance"]
            minimum_words = {word for word in words if sum(x != 0 for x in word) == minimum}
            minimum_supports = {tuple(i for i, value in enumerate(word) if value)
                                for word in minimum_words}
            row_multiples = {
                tuple((scalar * x) % p for x in row)
                for row in matrix for scalar in range(1, p)
            }
            coverage = recorded["incidence_minimum_word_coverage"]
            row_supports = {tuple(i for i, value in enumerate(word) if value)
                            for word in row_multiples}
            assert row_multiples <= minimum_words
            assert coverage["distinct_nonzero_scalar_multiples"] == len(row_multiples)
            assert coverage["total_minimum_words"] == len(minimum_words)
            divisor = math.gcd(len(row_multiples), len(minimum_words))
            assert coverage["fraction_of_minimum_words"] == [
                len(row_multiples) // divisor, len(minimum_words) // divisor
            ]
            assert coverage["exhausts_all_minimum_words"] == (row_multiples == minimum_words)
            assert coverage["distinct_minimum_word_supports"] == len(minimum_supports)
            assert coverage["incidence_row_supports"] == len(row_supports)
            assert coverage["remaining_minimum_word_supports"] == len(minimum_supports - row_supports)
            radius = (minimum - 1) // 2
            terms = [math.comb(q, i) * (p - 1) ** i for i in range(radius + 1)]
            sphere = recorded["sphere_packing"]
            assert terms == sphere["sphere_terms"]
            assert sum(terms) == sphere["sphere_volume"]
            assert (len(words) * sum(terms) == p ** q) == sphere["equality"]

            generator_words = span_from_incidence(recorded["generator_matrix_rref"], p)
            assert generator_words == words
            for parity_row in recorded["parity_check_matrix_rref"]:
                assert all(sum(x * y for x, y in zip(parity_row, word)) % p == 0 for word in words)

        dot_zero = all(sum(x * y for x, y in zip(left, right)) % p == 0
                       for left in replay_spans["disjoint"] for right in replay_spans["shared_edge"])
        assert dot_zero
        assert len(replay_spans["disjoint"]) * len(replay_spans["shared_edge"]) == p ** q
        assert case["design_complement_pair"]["shared_edge_span_equals_disjoint_dual"]
        disjoint_counts = case["relations"]["disjoint"]["weight_distribution_all_weights"]
        shared_counts = case["relations"]["shared_edge"]["weight_distribution_all_weights"]
        pair = case["design_complement_pair"]
        all_one = tuple([1] * q)
        assert replay_spans["shared_edge"] <= replay_spans["disjoint"]
        assert all_one in replay_spans["disjoint"] and all_one not in replay_spans["shared_edge"]
        quotient_union = set()
        for entry in pair["all_one_quotient_coset_distributions"]:
            scalar = entry["all_one_scalar"]
            coset = {tuple((value + scalar) % p for value in word)
                     for word in replay_spans["shared_edge"]}
            quotient_union |= coset
            assert distribution(coset, q) == entry["weight_distribution_all_weights"]
        assert quotient_union == replay_spans["disjoint"]
        assert pair["direct_sum_with_all_one_line"] and pair["quotient_dimension"] == 1
        assert macwilliams(disjoint_counts, q, p) == [shared_counts[str(i)] for i in range(q + 1)]
        assert macwilliams(shared_counts, q, p) == [disjoint_counts[str(i)] for i in range(q + 1)]
        assert pair["macwilliams_disjoint_to_shared_coefficients"] == macwilliams(disjoint_counts, q, p)
        assert pair["macwilliams_shared_to_disjoint_coefficients"] == macwilliams(shared_counts, q, p)
        assert pair["macwilliams_transforms_agree"]

        if q == 7:
            eq = case["hamming_7_4_3_generator_equivalence"]
            source = eq["source_generator_matrix"]
            permutation = eq["coordinate_permutation_new_to_old_zero_based"]
            permuted = [[row[j] for j in permutation] for row in source]
            assert permuted == eq["permuted_source_generator"]
            assert multiply(eq["row_operation_matrix"], permuted, 2) == eq["standard_generator_matrix"]
            parity = eq["standard_parity_check_columns_are_binary_1_through_7"]
            assert multiply(parity, [list(column) for column in zip(*eq["standard_generator_matrix"])], 2) == [[0] * 4 for _ in range(3)]
            standard_words = span_from_incidence(eq["standard_generator_matrix"], 2)
            assert distribution(standard_words, 7) == case["relations"]["disjoint"]["weight_distribution_all_weights"]

    assert cert["cases"][0]["relations"]["disjoint"]["sphere_packing"]["equality"]
    assert cert["cases"][1]["relations"]["disjoint"]["sphere_packing"]["equality"]
    print("C464 independent replay: PASS")


if __name__ == "__main__":
    main()
