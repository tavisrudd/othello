#!/usr/bin/env python3
"""C756 exact defect-two subresultant and slope-moment certificate."""

from __future__ import annotations

import argparse
import json
from collections import Counter, defaultdict
from itertools import combinations
from pathlib import Path


Q = 13
EXAMPLES = {
    "two_double_directions": {
        "points": [(0, 0), (1, 0), (2, 1), (3, 4), (4, 10), (5, 1)],
        "residual_roots": [0, 10],
    },
    "one_triple_direction": {
        "points": [(0, 0), (1, 0), (4, 1), (10, 1), (2, 2), (12, 2)],
        "residual_roots": [0, 0],
    },
}


def trim(a: list[int]) -> list[int]:
    while len(a) > 1 and a[-1] % Q == 0:
        a.pop()
    return [x % Q for x in a]


def add(a: list[int], b: list[int]) -> list[int]:
    out = [0] * max(len(a), len(b))
    for i in range(len(out)):
        out[i] = ((a[i] if i < len(a) else 0) + (b[i] if i < len(b) else 0)) % Q
    return trim(out)


def scale(a: list[int], c: int) -> list[int]:
    return trim([(c * x) % Q for x in a])


def mul(a: list[int], b: list[int]) -> list[int]:
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] = (out[i + j] + x * y) % Q
    return trim(out)


def evaluate(a: list[int], t: int) -> int:
    value = 0
    for coefficient in reversed(a):
        value = (value * t + coefficient) % Q
    return value


def divide_exact(a: list[int], b: list[int]) -> list[int]:
    remainder = trim(a[:])
    quotient = [0] * max(1, len(remainder) - len(b) + 1)
    inverse = pow(b[-1], -1, Q)
    while len(remainder) >= len(b) and remainder != [0]:
        degree = len(remainder) - len(b)
        coefficient = remainder[-1] * inverse % Q
        quotient[degree] = coefficient
        for j, value in enumerate(b):
            remainder[degree + j] = (remainder[degree + j] - coefficient * value) % Q
        remainder = trim(remainder)
    assert remainder == [0]
    return trim(quotient)


def slope(p: tuple[int, int], r: tuple[int, int]) -> int:
    return (p[1] - r[1]) * pow((p[0] - r[0]) % Q, -1, Q) % Q


def direction_data(points: list[tuple[int, int]]) -> tuple[list[int], dict[int, list[list[int]]]]:
    by_direction: dict[int, list[list[int]]] = defaultdict(list)
    for i, j in combinations(range(len(points)), 2):
        by_direction[slope(points[i], points[j])].append([i, j])
    repeated = {t: edges for t, edges in sorted(by_direction.items()) if len(edges) > 1}
    slopes = sorted(t for t, edges in by_direction.items() for _ in edges)
    return slopes, repeated


def subresultant_coefficients(points: list[tuple[int, int]]) -> tuple[list[int], list[int]]:
    """Return A(T), B(T) for Sres_1(H,H_U)=A(T)U+B(T), up to common sign."""
    n = len(points)
    a_poly = [0]
    b_poly = [0]
    for omitted in range(n):
        delta = [1]
        retained = [i for i in range(n) if i != omitted]
        for i, j in combinations(retained, 2):
            # Root r_i(T)=y_i-x_i*T, so r_i-r_j has these coefficients.
            difference = [
                (points[i][1] - points[j][1]) % Q,
                (points[j][0] - points[i][0]) % Q,
            ]
            delta = mul(delta, difference)
        weight = mul(delta, delta)
        root = [points[omitted][1] % Q, (-points[omitted][0]) % Q]
        a_poly = add(a_poly, weight)
        b_poly = add(b_poly, scale(mul(root, weight), -1))
    return a_poly, b_poly


def repeated_intercepts(points: list[tuple[int, int]], direction: int) -> list[int]:
    values = Counter((y - direction * x) % Q for x, y in points)
    return sorted(value for value, multiplicity in values.items() if multiplicity > 1)


def analyze(name: str, raw: dict[str, object]) -> dict[str, object]:
    points = list(raw["points"])
    roots = list(raw["residual_roots"])
    assert len({x for x, _ in points}) == len(points)

    slopes, repeated = direction_data(points)
    expected_slopes = sorted(list(range(Q)) + roots)
    assert slopes == expected_slopes
    for edges in repeated.values():
        assert len({vertex for edge in edges for vertex in edge}) == 2 * len(edges)

    moments = []
    for exponent in range(1, 5):
        direct = sum(pow(value, exponent, Q) for value in slopes) % Q
        residual = sum(pow(value, exponent, Q) for value in roots) % Q
        assert direct == residual
        moments.append({"exponent": exponent, "edge_sum": direct, "residual_sum": residual})

    a_poly, b_poly = subresultant_coefficients(points)
    e_poly = [1]
    for root in roots:
        e_poly = mul(e_poly, [(-root) % Q, 1])
    e_square = mul(e_poly, e_poly)
    a_quotient = divide_exact(a_poly, e_square)
    b_quotient = divide_exact(b_poly, e_square)

    exceptional = set(repeated)
    for direction in range(Q):
        av = evaluate(a_poly, direction)
        bv = evaluate(b_poly, direction)
        intercepts = repeated_intercepts(points, direction)
        if direction in exceptional:
            assert av == 0 and bv == 0
            assert len(intercepts) == len(repeated[direction])
        else:
            assert av != 0
            assert len(intercepts) == 1
            assert (-bv * pow(av, -1, Q)) % Q == intercepts[0]

    n = len(points)
    assert len(a_poly) - 1 == (n - 1) * (n - 2)
    assert len(b_poly) - 1 == (n - 1) * (n - 2) + 1
    assert len(a_quotient) - 1 == (n - 1) * (n - 2) - 4
    assert len(b_quotient) - 1 == (n - 1) * (n - 2) - 3

    return {
        "name": name,
        "points": [list(point) for point in points],
        "direction_multiplicities": sorted(Counter(slopes).values(), reverse=True),
        "repeated_directions": [
            {"direction": direction, "edges": edges}
            for direction, edges in repeated.items()
        ],
        "residual_roots": roots,
        "moments": moments,
        "subresultant": {
            "a_degree": len(a_poly) - 1,
            "b_degree": len(b_poly) - 1,
            "forced_factor": "E(T)^2",
            "a_quotient_degree": len(a_quotient) - 1,
            "b_quotient_degree": len(b_quotient) - 1,
            "a_quotient_coefficients_low_to_high": a_quotient,
            "b_quotient_coefficients_low_to_high": b_quotient,
        },
    }


def certificate() -> dict[str, object]:
    return {
        "schema": 1,
        "task": "C756",
        "field_order": Q,
        "claim": (
            "both defect-two direction shapes occur for affine six-arcs over F_13, "
            "their first four slope moments equal the residual-root moments, and "
            "after the forced E(T)^2 factor the first-subresultant coefficients "
            "have degrees 16 and 17"
        ),
        "examples": [analyze(name, raw) for name, raw in EXAMPLES.items()],
    }


def canonical_bytes(value: dict[str, object]) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    data = canonical_bytes(certificate())
    if args.write:
        args.write.write_bytes(data)
    elif args.check:
        expected = args.check.read_bytes()
        if data != expected:
            raise SystemExit("certificate mismatch")
        print("certificate ok")
    else:
        print(data.decode(), end="")


if __name__ == "__main__":
    main()
