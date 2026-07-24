#!/usr/bin/env python3
"""Independent compact replay for the C531 certificate.

This checker does not import the generator.  It reconstructs finite-field
tables, checks every recorded root witness directly, verifies the complete
q=8 negative, and checks the orbit-size identities predicted by the
PGL2(F4) cocycle classification.
"""

from __future__ import annotations

from itertools import combinations
import json
from pathlib import Path


STEM = "2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata"
INF = "inf"


def deg(x: int) -> int:
    return x.bit_length() - 1


def reduce_polynomial(x: int, modulus: int) -> int:
    n = deg(modulus)
    while deg(x) >= n:
        x ^= modulus << (deg(x) - n)
    return x


def multiply(x: int, y: int, modulus: int) -> int:
    answer = 0
    for bit in range(y.bit_length()):
        if (y >> bit) & 1:
            answer ^= x << bit
    return reduce_polynomial(answer, modulus)


def power(x: int, n: int, modulus: int) -> int:
    answer = 1
    while n:
        if n & 1:
            answer = multiply(answer, x, modulus)
        x = multiply(x, x, modulus)
        n >>= 1
    return answer


def polynomial_from_roots(roots: list[int], modulus: int) -> list[int]:
    coefficients = [1]
    for root in roots:
        answer = [0] * (len(coefficients) + 1)
        for i, coefficient in enumerate(coefficients):
            answer[i] ^= multiply(coefficient, root, modulus)
            answer[i + 1] ^= coefficient
        coefficients = answer
    return coefficients + [0] * (9 - len(coefficients))


def evaluate(coefficients: list[int], x: int, modulus: int) -> int:
    answer = 0
    for coefficient in reversed(coefficients):
        answer = multiply(answer, x, modulus) ^ coefficient
    return answer


def kernel_test(
    representative: list[int], coefficients: list[int], modulus: int
) -> bool:
    first = 0
    second = 0
    for value, index in zip(representative, (2, 3, 6, 7)):
        first ^= multiply(value, coefficients[index - 1], modulus)
        second ^= multiply(value, coefficients[index], modulus)
    return first == second == 0


def check_witnesses(control: dict[str, object]) -> None:
    q = control["q"]
    modulus = int(control["modulus_hex"], 16)
    for orbit in control["orbits"]:
        witness = orbit["split_squarefree_witness"]
        if witness is None:
            continue
        roots = [
            int(root, 16)
            for root in witness["roots_hex"]
            if root != INF
        ]
        coefficients = polynomial_from_roots(roots, modulus)
        expected = [
            int(coefficient, 16)
            for coefficient in witness["coefficients_low_to_high_hex"]
        ]
        assert coefficients == expected
        assert len(set(roots)) == len(roots)
        for root in roots:
            assert evaluate(coefficients, root, modulus) == 0
        if INF in witness["roots_hex"]:
            assert coefficients[8] == 0
        else:
            assert coefficients[8] == 1
        representative = [
            int(coordinate, 16) for coordinate in orbit["representative_hex"]
        ]
        assert kernel_test(representative, coefficients, modulus)
    assert sum(orbit["orbit_size"] for orbit in control["orbits"]) == (
        q**3 + q**2 + q + 1
    )
    graph = [o for o in control["orbits"] if o["kind"] == "graph"]
    off_graph = [
        o for o in control["orbits"] if o["kind"] == "rank1_off_graph"
    ]
    rank_two = [o for o in control["orbits"] if o["kind"] == "rank2"]
    assert [o["orbit_size"] for o in graph] == [q + 1]
    assert [o["orbit_size"] for o in off_graph] == [q * (q + 1)]
    assert sum(o["orbit_size"] for o in rank_two) == q * (q * q - 1)
    for orbit in control["orbits"]:
        assert (
            orbit["orbit_size"] * orbit["stabilizer_order"]
            == q * (q * q - 1)
        )


def check_q8_negative(control: dict[str, object]) -> None:
    assert control["q"] == 8
    modulus = int(control["modulus_hex"], 16)
    split_free = [
        orbit
        for orbit in control["orbits"]
        if orbit["split_squarefree_witness"] is None
    ]
    assert len(split_free) == 1
    orbit = split_free[0]
    assert orbit["kind"] == "rank2"
    assert orbit["orbit_size"] == 168
    assert orbit["stabilizer_order"] == 3
    representative = [
        int(coordinate, 16) for coordinate in orbit["representative_hex"]
    ]
    checked = 0
    for roots in combinations(list(range(8)) + [INF], 8):
        finite_roots = [root for root in roots if root != INF]
        coefficients = polynomial_from_roots(finite_roots, modulus)
        assert not kernel_test(representative, coefficients, modulus)
        checked += 1
    assert checked == 9


def check_reciprocal_construction(modulus: int) -> None:
    m = deg(modulus)
    q = 1 << m
    basis = (1, 2, 4)
    space = {
        (basis[0] if mask & 1 else 0)
        ^ (basis[1] if mask & 2 else 0)
        ^ (basis[2] if mask & 4 else 0)
        for mask in range(8)
    }
    assert len(space) == 8
    roots = [0] + [power(v, q - 2, modulus) for v in space if v]
    coefficients = polynomial_from_roots(roots, modulus)
    assert coefficients[2] == coefficients[3] == 0
    assert len(set(roots)) == 8


def main() -> None:
    path = Path(__file__).with_name(f"{STEM}.json")
    data = json.loads(path.read_text())
    assert data["schema"] == "c531-degree-nine-lucas-carrier-strata-v1"
    controls = data["bounded_controls"]
    assert [control["q"] for control in controls] == [8, 16, 32]
    for control in controls:
        check_witnesses(control)
        check_reciprocal_construction(int(control["modulus_hex"], 16))
    check_q8_negative(controls[0])

    even = data["rank_two_rational_twists"]["m_even"]
    odd = data["rank_two_rational_twists"]["m_odd"]
    assert sorted(even["centralizer_orders"]) == [3, 4, 5, 5, 60]
    assert sorted(odd["centralizer_orders"]) == [2, 3, 6]
    for control, centralizers in (
        (controls[0], odd["centralizer_orders"]),
        (controls[1], even["centralizer_orders"]),
        (controls[2], odd["centralizer_orders"]),
    ):
        q = control["q"]
        group_order = q * (q * q - 1)
        expected = sorted(group_order // c for c in centralizers)
        actual = sorted(
            orbit["orbit_size"]
            for orbit in control["orbits"]
            if orbit["kind"] == "rank2"
        )
        assert actual == expected

    normalization = data["rank_two_six_root_normalization"]
    assert normalization["Delta"] == "A1*A3+A2^2"
    assert normalization["Ns"] == "A0*A3+A1*A2"
    assert normalization["Np"] == "A1^2+A0*A2"
    assert normalization["residue_on_Ns"] == "Delta^2*A1/A3"
    print("C531 independent replay: OK")


if __name__ == "__main__":
    main()
