#!/usr/bin/env python3
"""Independent finite-action replay for C449 (does not import the primary checker)."""

from __future__ import annotations

import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def normalize(matrix, prime):
    pivot = next(value % prime for value in matrix if value % prime)
    inverse = pow(pivot, -1, prime)
    return tuple(value * inverse % prime for value in matrix)


def multiply(left, right, prime):
    a, b, c, d = left
    e, f, g, h = right
    return normalize(
        (a * e + b * g, a * f + b * h, c * e + d * g, c * f + d * h), prime
    )


def action(matrix, point, prime):
    a, b, c, d = matrix
    x, y = (1, 0) if point == "inf" else (point, 1)
    u, v = (a * x + b * y) % prime, (c * x + d * y) % prime
    return "inf" if v == 0 else u * pow(v, -1, prime) % prime


def direct_record(matrix, prime):
    identity = (1, 0, 0, 1)
    current = identity
    powers = []
    while current not in powers:
        powers.append(current)
        current = multiply(matrix, current, prime)
    assert current == identity
    points = list(range(prime)) + ["inf"]
    unseen = set(points)
    orbits = []
    while unseen:
        start = min(unseen, key=lambda point: prime if point == "inf" else point)
        orbit = []
        point = start
        while point not in orbit:
            orbit.append(point)
            unseen.remove(point)
            point = action(matrix, point, prime)
        orbits.append(orbit)
    return powers, orbits


def replay():
    certificate = json.loads((HERE / "2026-07-21-c449-split-coxeter-torus.json").read_text())
    m1 = json.loads((HERE / "2026-07-21-c441-vertex-reduction-bijection.json").read_text())
    for record in certificate["finite_generator_images"]:
        prime = record["prime_q"]
        matrix = tuple(record["generator_matrix_in_frozen_P1_frame"])
        powers, orbits = direct_record(matrix, prime)
        assert len(powers) == record["coxeter_square_order"] == (prime - 1) // 2
        assert sorted(len(orbit) for orbit in orbits) == [1, 1, (prime - 1) // 2, (prime - 1) // 2]
        determinant = (matrix[0] * matrix[3] - matrix[1] * matrix[2]) % prime
        assert determinant in {value * value % prime for value in range(1, prime)}
        diagonal_psl = {
            normalize((value * value % prime, 0, 0, 1), prime)
            for value in range(1, prime)
        }
        assert set(powers) == diagonal_psl
        squares = {value * value % prime for value in range(1, prime)}
        nonsquares = set(range(1, prime)) - squares
        assert {frozenset(orbit) for orbit in orbits if len(orbit) > 1} == {
            frozenset(squares), frozenset(nonsquares)
        }
        outer = tuple(record["outer_PGL_over_PSL_coset"]["matrix"])
        assert {action(outer, value, prime) for value in squares} == nonsquares
        module = record["action_decomposition"]["permutation_module_restriction"]
        assert module["invariant_dimension"] == 4
        assert module["trivial_character_multiplicity"] == 4
        assert module["nontrivial_character_multiplicity"] == 2

    # Separate block check directly against the frozen M1 table.
    tables = m1["cases"]
    assert {
        row["point"] for row in tables["A3_octahedron"]["bijection_table"]
        if row["block"] == "real"
    } == {1, 4}
    assert {
        row["point_pi"] for row in tables["B3_cube"]["bijection_table"]
        if row["block"] == "upper"
    } == {3, 5, 6}
    assert {
        row["point_pi"] for row in tables["H3_icosahedron"]["bijection_table"]
        if row["block"] == "beta"
    } == {1, 3, 4, 5, 9}
    bridge = certificate["h3_galois_torus_bridge"]
    assert bridge["sigma_orbit_on_C5_generators"] == [9, 4, 5, 3]
    assert pow(bridge["frozen_generator_at_pi"], 2, 11) == bridge["frozen_generator_at_pibar"]
    assert pow(bridge["frozen_generator_at_pi"], 4, 11) == pow(bridge["frozen_generator_at_pi"], -1, 11)
    print("C449 independent replay: OK (five prime images, split PSL tori, exact orbit partitions)")


if __name__ == "__main__":
    replay()
