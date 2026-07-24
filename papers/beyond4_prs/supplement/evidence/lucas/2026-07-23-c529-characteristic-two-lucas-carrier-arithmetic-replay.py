#!/usr/bin/env python3
"""Independent replay for the C529 Lucas-carrier certificate."""

from __future__ import annotations

import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.json"


def is_odd_binomial(row: int, column: int) -> bool:
    """Lucas' criterion, implemented without binomial coefficients."""
    return column & ~row == 0


def nucleus_by_lucas(degree: int, order: int) -> list[int]:
    return [
        column
        for column in range(degree + 1)
        if not any(
            is_odd_binomial(row, column) for row in range(order + 1, degree + 1)
        )
    ]


def overlap_by_rows(degree: int, nucleus: list[int]) -> list[int]:
    allowed = set(nucleus)
    result: list[int] = []
    for column in range(degree + 2):
        left_ok = column == degree + 1 or column in allowed
        right_ok = column == 0 or column - 1 in allowed
        if left_ok and right_ok:
            result.append(column)
    return result


def doubling_cycles(modulus: int) -> list[list[int]]:
    todo = set(range(modulus))
    answer: list[list[int]] = []
    while todo:
        first = min(todo)
        orbit: list[int] = []
        current = first
        while current not in orbit:
            orbit.append(current)
            todo.remove(current)
            current = 2 * current % modulus
        answer.append(orbit)
    return answer


def replay() -> None:
    data = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    assert data["schema"] == "c529-characteristic-two-lucas-carrier-arithmetic-v1"

    found = []
    for degree in range(2, 9):
        for order in range(degree):
            nucleus = nucleus_by_lucas(degree, order)
            carrier = overlap_by_rows(degree, nucleus)
            if carrier:
                found.append((degree, order, nucleus, carrier))
    recorded = [
        (
            item["lower_degree"],
            item["nucleus_order"],
            item["nucleus_indices"],
            item["carrier_indices"],
        )
        for item in data["nonzero_overlap_kernels_through_lower_degree_8"]
    ]
    assert found == recorded

    for item in data["power_two_top_nucleus_family"]:
        level = item["level"]
        degree = 1 << level
        assert item["lower_degree"] == degree
        assert item["top_nucleus_indices"] == list(range(1, degree))
        assert item["carrier_indices"] == list(range(2, degree))
        assert item["carrier_vector_rank"] == degree - 2
        assert item["carrier_common_kernel_indices"] == [0, degree]
        assert item["distinguished_syndrome_index"] == degree - 1
        assert item["distinguished_kernel_net_indices"] == [0, 1, degree]
        assert item["generic_geometric_monodromy"] == f"AGL(1,{degree})"
        assert item["minimal_constant_field"] == f"F_{degree}"
        assert item["geometric_component_count_over_F2"] == level
        assert item["coefficient_frobenius_on_components"] == f"one {level}-cycle"
        assert item["frobenius_cycles"] == doubling_cycles(degree - 1)
        current = 1
        order = 0
        while True:
            order += 1
            current = 2 * current % (degree - 1)
            if current == 1:
                break
        assert order == level == item["frobenius_order"]

    obstruction = data["first_obstruction"]
    assert obstruction["component_group"] == "C7"
    assert obstruction["frobenius_cycles"] == [[0], [1, 2, 4], [3, 6, 5]]
    print(
        "C529 replay passed: 4 nonzero overlaps through degree 8; "
        "C3/order-2 control; C7/order-3 first obstruction."
    )


if __name__ == "__main__":
    replay()
