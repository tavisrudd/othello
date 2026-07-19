#!/usr/bin/env python3
"""Exact checker for C360's symbolic conic-MDS basis-sensitivity theorem."""

from __future__ import annotations

import argparse
import importlib.util
import json
from fractions import Fraction
from itertools import combinations
from pathlib import Path


HERE = Path(__file__).resolve().parent
STEM = "2026-07-19-c360-conic-mds-basis-sensitivity"
C354_STEM = "2026-07-18-c354-conic-mds-service-spectrum"
SCHEMA = "c360-conic-mds-basis-sensitivity-v1"


def load_c354():
    path = HERE / f"{C354_STEM}.py"
    spec = importlib.util.spec_from_file_location("c354_checker", path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C354 = load_c354()


def point(field, x: int, y: int, z: int):
    return C354.normalize(field, (x, y, z))


def prime_element(field, value: int) -> int:
    return value % field.p


def parameter_point(field, value: int | None):
    if value is None:
        return (1, 0, 0)
    return (field.mul(value, value), value, 1)


def mask_for_parameters(field, values: tuple[int | None, ...]) -> int:
    servers = C354.conic(field)
    return sum(1 << servers.index(parameter_point(field, value)) for value in values)


def direct_recoveries(field, frame):
    """Enumerate minimal recovery sets without C354's secant/triple constructor."""
    servers = C354.conic(field)
    answer = set()

    def recovers(target, subset):
        if len(subset) == 1:
            return servers[subset[0]] == target
        if len(subset) == 2:
            return C354.det3(field, target, servers[subset[0]], servers[subset[1]]) == 0
        return C354.det3(field, servers[subset[0]], servers[subset[1]], servers[subset[2]]) != 0

    for color, target in enumerate(frame):
        for size in (1, 2, 3):
            for subset in combinations(range(field.q + 1), size):
                if not recovers(target, subset):
                    continue
                if any(
                    recovers(target, proper)
                    for proper_size in range(1, size)
                    for proper in combinations(subset, proper_size)
                ):
                    continue
                answer.add((color, sum(1 << index for index in subset)))
    return answer


def add_weight(allocation, color: int, mask: int, weight: Fraction):
    if weight:
        allocation[(color, mask)] = allocation.get((color, mask), Fraction(0)) + weight


def check_allocation(field, recoveries, allocation):
    assert set(allocation) <= recoveries
    loads = []
    for server in range(field.q + 1):
        load = sum(weight for (_, mask), weight in allocation.items() if mask & (1 << server))
        assert load <= 1
        loads.append(load)
    demand = tuple(
        sum(weight for (edge_color, _), weight in allocation.items() if edge_color == color)
        for color in range(3)
    )
    return demand, tuple(loads)


def external_axis_allocation(field, recoveries, color: int):
    pairs = sorted(mask for edge_color, mask in recoveries if edge_color == color and mask.bit_count() == 2)
    used = 0
    for mask in pairs:
        used |= mask
    tangents = [index for index in range(field.q + 1) if not used & (1 << index)]
    assert len(tangents) == 2 and len(pairs) == (field.q - 1) // 2
    split = pairs[0]
    endpoints = [index for index in range(field.q + 1) if split & (1 << index)]
    allocation = {}
    for mask in pairs:
        add_weight(allocation, color, mask, Fraction(1, 2) if mask == split else Fraction(1))
    for endpoint in endpoints:
        triple = (1 << tangents[0]) | (1 << tangents[1]) | (1 << endpoint)
        add_weight(allocation, color, triple, Fraction(1, 2))
    return allocation


def check_external_axis_dual(field, recoveries, color: int):
    pairs = [mask for edge_color, mask in recoveries if edge_color == color and mask.bit_count() == 2]
    used = 0
    for mask in pairs:
        used |= mask
    cover = tuple(
        Fraction(1, 2) if used & (1 << server) else Fraction(1, 4)
        for server in range(field.q + 1)
    )
    assert sum(cover) == Fraction(field.q, 2)
    for edge_color, mask in recoveries:
        if edge_color == color:
            assert sum(cover[server] for server in range(field.q + 1) if mask & (1 << server)) >= 1


def frame_a(field):
    one = 1
    minus_one = field.neg(one)
    u = next(value for value in range(1, field.q) if value not in (one, minus_one))
    inverse_u = field.inverse(u)
    half = field.inverse(prime_element(field, 2))
    y = field.mul(half, field.add(u, inverse_u))
    return (
        point(field, 0, 1, 0),
        point(field, 1, y, 1),
        point(field, 1, 0, minus_one),
    ), u


def frame_b(field):
    half = field.inverse(prime_element(field, 2))
    return (
        point(field, 1, 0, field.neg(1)),
        point(field, 1, half, 0),
        point(field, 1, field.neg(half), 0),
    )


def a_allocation(field, recoveries):
    allocation = {}
    add_weight(
        allocation,
        1,
        mask_for_parameters(field, (prime_element(field, 1), prime_element(field, -1))),
        Fraction(1),
    )
    for color, mask in recoveries:
        if color == 2 and mask.bit_count() == 2:
            add_weight(allocation, color, mask, Fraction(1))
    return allocation


def b_facet_allocation(field, recoveries):
    """A third equality point for lambda_0+2lambda_1+2lambda_2=q."""
    e = lambda value: prime_element(field, value)
    allocation = {}
    if field.p == 5:
        add_weight(allocation, 0, mask_for_parameters(field, (e(0), None)), Fraction(1))
        add_weight(allocation, 1, mask_for_parameters(field, (e(-1), e(3))), Fraction(1))
        omitted = mask_for_parameters(field, (e(0), e(3)))
        for color, mask in recoveries:
            if color == 2 and mask.bit_count() == 2 and mask != omitted:
                add_weight(allocation, color, mask, Fraction(1))
    elif field.p == 3:
        add_weight(allocation, 0, mask_for_parameters(field, (e(0), None)), Fraction(1, 3))
        add_weight(allocation, 1, mask_for_parameters(field, (e(0), e(-1))), Fraction(1, 3))
        special = mask_for_parameters(field, (e(0), e(1)))
        for color, mask in recoveries:
            if color == 2 and mask.bit_count() == 2:
                add_weight(allocation, color, mask, Fraction(1, 3) if mask == special else Fraction(1))
        add_weight(allocation, 2, mask_for_parameters(field, (None, e(1), e(-1))), Fraction(2, 3))
    else:
        add_weight(allocation, 0, mask_for_parameters(field, (e(0), None)), Fraction(1, 3))
        add_weight(allocation, 1, mask_for_parameters(field, (e(-1), e(3))), Fraction(1, 3))
        special = {
            mask_for_parameters(field, (e(0), e(-2))),
            mask_for_parameters(field, (e(3), e(-5))),
        }
        for color, mask in recoveries:
            if color == 2 and mask.bit_count() == 2:
                add_weight(allocation, color, mask, Fraction(2, 3) if mask in special else Fraction(1))
        add_weight(allocation, 2, mask_for_parameters(field, (None, e(-1), e(-2))), Fraction(1, 3))
        add_weight(allocation, 2, mask_for_parameters(field, (None, e(-1), e(-5))), Fraction(1, 3))
    return allocation


def affine_determinant(points):
    a, b, c = points
    return (
        (b[0] - a[0]) * (c[1] - a[1])
        - (b[1] - a[1]) * (c[0] - a[0])
    )


def orbit_row(field, frame, field_json):
    representative = min(
        tuple(sorted(C354.act(field, matrix, target) for target in frame))
        for matrix in C354.conic_group(field)
    )
    rows = [row for row in field_json["orbits"] if tuple(map(tuple, row["representative"])) == representative]
    assert len(rows) == 1
    return rows[0]


def check_field(q: int, c354_json):
    field = C354.FiniteField(q)
    A, u = frame_a(field)
    B = frame_b(field)
    for frame in (A, B):
        assert C354.det3(field, *frame)
        assert [C354.point_type(field, target) for target in frame] == ["E", "E", "E"]

    recoveries_a = direct_recoveries(field, A)
    recoveries_b = direct_recoveries(field, B)
    for recoveries in (recoveries_a, recoveries_b):
        for color in range(3):
            check_external_axis_dual(field, recoveries, color)
    demand_a, loads_a = check_allocation(field, recoveries_a, a_allocation(field, recoveries_a))
    assert demand_a == (Fraction(0), Fraction(1), Fraction(q - 1, 2))
    assert all(load == 1 for load in loads_a)

    cover = tuple(Fraction(0) if server == C354.conic(field).index((1, 0, 0)) else Fraction(1)
                  for server in range(q + 1))
    coefficients = (1, 2, 2)
    for color, mask in recoveries_b:
        weight = sum(cover[server] for server in range(q + 1) if mask & (1 << server))
        assert weight >= coefficients[color]
    assert sum(cover) == q
    assert sum(coefficients[i] * demand_a[i] for i in range(3)) == q + 1

    axis_1, _ = check_allocation(field, recoveries_b, external_axis_allocation(field, recoveries_b, 1))
    axis_2, _ = check_allocation(field, recoveries_b, external_axis_allocation(field, recoveries_b, 2))
    third, _ = check_allocation(field, recoveries_b, b_facet_allocation(field, recoveries_b))
    assert axis_1 == (0, Fraction(q, 2), 0)
    assert axis_2 == (0, 0, Fraction(q, 2))
    equality_points = (axis_1, axis_2, third)
    assert all(sum(coefficients[i] * demand[i] for i in range(3)) == q for demand in equality_points)
    assert third[0] > 0
    assert affine_determinant([(point[1], point[2]) for point in equality_points]) != 0

    one, minus_one = prime_element(field, 1), prime_element(field, -1)
    tangents_a2 = {parameter_point(field, one), parameter_point(field, minus_one)}
    target_a1_pairs = {mask for color, mask in recoveries_a if color == 1 and mask.bit_count() == 2}
    assert mask_for_parameters(field, (one, minus_one)) in target_a1_pairs

    def tangent_set(recoveries, color):
        used = 0
        for edge_color, mask in recoveries:
            if edge_color == color and mask.bit_count() == 2:
                used |= mask
        servers = C354.conic(field)
        return {servers[index] for index in range(q + 1) if not used & (1 << index)}

    assert tangents_a2 == tangent_set(recoveries_a, 2)
    assert len(tangent_set(recoveries_b, 1) & tangent_set(recoveries_b, 2)) == 1
    assert (1, 0, 0) in tangent_set(recoveries_b, 1) & tangent_set(recoveries_b, 2)

    field_json = c354_json["fields"][str(q)]
    row_a = orbit_row(field, A, field_json)
    row_b = orbit_row(field, B, field_json)
    assert row_a["type"] == row_b["type"] == "EEE"
    assert row_a["region"] != row_b["region"]
    spectrum_b = next(row for row in field_json["spectra"] if row["index"] == row_b["region"])
    facets_b = spectrum_b["certificate"]["facets"]
    assert any(sorted(facet[:3]) == [1, 2, 2] and facet[3] == q for facet in facets_b)

    return {
        "q": q,
        "parameter_u": u,
        "frame_a": [list(target) for target in A],
        "frame_b": [list(target) for target in B],
        "type": "EEE",
        "axis_intercepts": [str(Fraction(q, 2))] * 3,
        "a_demand": [str(value) for value in demand_a],
        "b_separating_facet": [1, 2, 2, q],
        "b_facet_third_equality_point": [str(value) for value in third],
        "involution_relation_a": "target 1 exchanges the two fixed points of target 2",
        "involution_relation_b": "targets 1 and 2 share exactly the fixed point infinity; their product is nonidentity unipotent",
        "c354_orbit_a": row_a["index"],
        "c354_orbit_b": row_b["index"],
        "c354_region_a": row_a["region"],
        "c354_region_b": row_b["region"],
        "recovery_sets_a": len(recoveries_a),
        "recovery_sets_b": len(recoveries_b),
    }


def generate():
    c354_path = HERE / f"{C354_STEM}.json"
    c354_json = json.loads(c354_path.read_text())
    fields = [check_field(q, c354_json) for q in (5, 7, 9, 11)]
    return {
        "schema": SCHEMA,
        "theorem_domain": "all odd prime powers q >= 5",
        "symbolic_frames": {
            "A": [[0, 1, 0], ["1", "(u+u^-1)/2", "1"], [1, 0, -1]],
            "B": [[1, 0, -1], ["1", "1/2", "0"], ["1", "-1/2", "0"]],
            "condition": "u in F_q^* minus {1,-1}",
        },
        "separating_demand": ["0", "1", "(q-1)/2"],
        "separating_facet_for_B": ["1", "2", "2", "q"],
        "facet_dual": "weight 0 at infinity and weight 1 at every finite conic server",
        "fields": fields,
        "c354_dependency": f"{C354_STEM}.py and .json",
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = generate()
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"
    tracked = HERE / f"{STEM}.json"
    if args.check:
        assert tracked.read_text() == rendered
        print(f"checked {len(result['fields'])} fields and symbolic all-odd-q formulas")
        return
    output = args.output or tracked
    output.write_text(rendered)
    print(output)


if __name__ == "__main__":
    main()
