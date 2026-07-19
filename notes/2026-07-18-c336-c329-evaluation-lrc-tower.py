#!/usr/bin/env python3
"""Deterministic small-field replay for C336's extremal equality types."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import tempfile
from pathlib import Path


MODULUS = 0b1000011  # x^6 + x + 1, irreducible over GF(2)
DEGREE = 6
ORDER = 1 << DEGREE


def add(a: int, b: int) -> int:
    return a ^ b


def mul(a: int, b: int) -> int:
    out = 0
    while b:
        if b & 1:
            out ^= a
        b >>= 1
        a <<= 1
        if a & ORDER:
            a ^= MODULUS
    return out


def power(a: int, n: int) -> int:
    out = 1
    while n:
        if n & 1:
            out = mul(out, a)
        a = mul(a, a)
        n >>= 1
    return out


def inv(a: int) -> int:
    assert a
    return power(a, ORDER - 2)


def div(a: int, b: int) -> int:
    return mul(a, inv(b))


def point(x: int, height: int) -> tuple[int, int, int]:
    return (1, x, add(mul(x, x), height))


def determinant(p: tuple[int, int, int], q: tuple[int, int, int],
                r: tuple[int, int, int]) -> int:
    a = mul(p[0], add(mul(q[1], r[2]), mul(q[2], r[1])))
    b = mul(p[1], add(mul(q[0], r[2]), mul(q[2], r[0])))
    c = mul(p[2], add(mul(q[0], r[1]), mul(q[1], r[0])))
    return add(add(a, b), c)


def line(p: tuple[int, int, int], q: tuple[int, int, int]) -> tuple[int, int, int]:
    coeffs = (
        add(mul(p[1], q[2]), mul(p[2], q[1])),
        add(mul(p[2], q[0]), mul(p[0], q[2])),
        add(mul(p[0], q[1]), mul(p[1], q[0])),
    )
    pivot = next(c for c in coeffs if c)
    return tuple(div(c, pivot) for c in coeffs)


def line_eval(coeffs: tuple[int, int, int], p: tuple[int, int, int]) -> int:
    return add(add(mul(coeffs[0], p[0]), mul(coeffs[1], p[1])),
               mul(coeffs[2], p[2]))


def conic_eval(height: int, p: tuple[int, int, int]) -> int:
    # XZ + Y^2 + height*X^2
    return add(add(mul(p[0], p[2]), mul(p[1], p[1])),
               mul(height, mul(p[0], p[0])))


def is_arc(points: list[tuple[int, int, int]]) -> bool:
    return all(determinant(*triple) != 0 for triple in itertools.combinations(points, 3))


def find_fixture() -> dict[str, object]:
    subfield = [a for a in range(ORDER) if power(a, 8) == a]
    omegas = [a for a in range(ORDER)
              if add(add(mul(a, a), a), 1) == 0 and a not in subfield]
    rhos = [a for a in subfield if a not in (0, 1)]
    candidates = [a for a in range(1, ORDER)]
    omega, rho = omegas[0], rhos[0]
    repair_x = sorted({add(omega, r) for r in subfield} |
                      {add(mul(rho, omega), r) for r in subfield})
    assert len(repair_x) == 16
    repair = [point(x, 0) for x in repair_x]
    gamma1, gamma2 = next((a, b) for a in candidates for b in candidates
                          if a != b and add(a, b) not in subfield)
    seed1 = [point(x, gamma1) for x in subfield]
    seed2 = [point(x, gamma2) for x in subfield]
    points = repair + seed1 + seed2
    return {
        "Q": 8,
        "omega": omega,
        "rho": rho,
        "carrier_heights": [0, gamma1, gamma2],
        "layers": [repair, seed1, seed2],
        "points": points,
        "subfield": subfield,
        "is_arc": is_arc(points),
    }


def zero_count(points: list[tuple[int, int, int]], conics: list[int],
               secant: tuple[int, int, int] | None = None) -> int:
    count = 0
    for p in points:
        value = 1
        for height in conics:
            value = mul(value, conic_eval(height, p))
        if secant is not None:
            value = mul(value, line_eval(secant, p))
        count += value == 0
    return count


def polynomial_value(d: int, p: tuple[int, int, int]) -> int:
    value = 0
    coefficient = 1
    for a in range(d + 1):
        for b in range(d - a + 1):
            c = d - a - b
            term = mul(power(p[0], a), mul(power(p[1], b), power(p[2], c)))
            value = add(value, mul(coefficient, term))
            coefficient = add(mul(coefficient, 2), 1)
    return value


def interpolate(xs: list[int], ys: list[int], target: int) -> int:
    total = 0
    for i, x_i in enumerate(xs):
        basis = 1
        for j, x_j in enumerate(xs):
            if i != j:
                basis = mul(basis, div(add(target, x_j), add(x_i, x_j)))
        total = add(total, mul(ys[i], basis))
    return total


def replay() -> dict[str, object]:
    assert all(mul(a, power(a, ORDER - 2)) == 1 for a in range(1, ORDER))
    fixture = find_fixture()
    q = fixture["Q"]
    heights = fixture["carrier_heights"]
    layers = fixture["layers"]
    points = fixture["points"]
    assert isinstance(q, int) and isinstance(heights, list)
    assert isinstance(layers, list) and isinstance(points, list)

    secant_all = next(line(*pair) for pair in itertools.combinations(points, 2)
                       if sum(line_eval(line(*pair), p) == 0 for p in points) == 2)
    outside = layers[1] + layers[2]
    secant_outside_repair = next(
        line(*pair) for pair in itertools.combinations(outside, 2)
        if sum(line_eval(line(*pair), p) == 0 for p in outside) == 2)
    secant_seed2 = line(layers[2][0], layers[2][1])
    examples = {
        "d1_secant": zero_count(points, [], secant_all),
        "d2_repair_carrier": zero_count(points, [heights[0]]),
        "d3_repair_carrier_times_residual_secant": zero_count(
            points, [heights[0]], secant_outside_repair),
        "d4_two_carriers": zero_count(points, [heights[0], heights[1]]),
        "d5_two_carriers_times_remaining_seed_secant": zero_count(
            points, [heights[0], heights[1]], secant_seed2),
    }
    expected = {"d1_secant": 2, "d2_repair_carrier": 2 * q,
                "d3_repair_carrier_times_residual_secant": 2 * q + 2,
                "d4_two_carriers": 3 * q,
                "d5_two_carriers_times_remaining_seed_secant": 3 * q + 2}
    assert examples == expected

    interpolation_checks: dict[str, dict[str, int]] = {}
    for d in range(1, 6):
        group_size = 2 * d + 1
        checked = 0
        availability = []
        for layer in layers:
            layer_availability = (len(layer) - 1) // group_size
            availability.append(layer_availability)
            for target_index, target_point in enumerate(layer):
                others = [p for i, p in enumerate(layer) if i != target_index]
                for start in range(0, layer_availability * group_size, group_size):
                    group = others[start:start + group_size]
                    recovered = interpolate([p[1] for p in group],
                                            [polynomial_value(d, p) for p in group],
                                            target_point[1])
                    assert recovered == polynomial_value(d, target_point)
                    checked += 1
        interpolation_checks[str(d)] = {
            "group_size": group_size,
            "repair_availability": availability[0],
            "seed_availability": availability[1],
            "recoveries_checked": checked,
        }

    for i, h_i in enumerate(heights):
        for j, h_j in enumerate(heights):
            if i != j:
                assert h_i != h_j
                assert all(not (conic_eval(h_i, p) == 0 and conic_eval(h_j, p) == 0)
                           for p in points)

    return {
        "schema": "c336-c329-evaluation-lrc-tower-v1",
        "field": {"ambient": "GF(64)", "subfield": "GF(8)",
                  "modulus_bits": bin(MODULUS), "element_encoding": "polynomial basis integers",
                  "nonzero_inverses_checked": ORDER - 1},
        "fixture": {"omega": fixture["omega"], "rho": fixture["rho"],
                    "carrier_heights": heights, "partition_size": len(points),
                    "is_arc": fixture["is_arc"]},
        "extremal_equality_zero_counts": examples,
        "local_interpolation": interpolation_checks,
        "scope": ("Carrier-component equality types and interpolation only. The small carrier partition "
                  "is not asserted to satisfy C329's arc conditions; arc existence and the all-Q Bezout "
                  "upper bounds are proof inputs, not computational claims."),
    }


def serialized() -> bytes:
    return (json.dumps(replay(), indent=2, sort_keys=True) + "\n").encode()


def verify_manifest(stem: Path) -> None:
    for line_text in stem.with_suffix(".sha256").read_text().splitlines():
        digest, name = line_text.split("  ", 1)
        actual = hashlib.sha256(stem.with_name(name).read_bytes()).hexdigest()
        if actual != digest:
            raise SystemExit(f"hash mismatch for {name}: {actual} != {digest}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    stem = Path(__file__).with_suffix("")
    payload = serialized()
    if args.check:
        with tempfile.TemporaryDirectory(prefix="c336-replay-") as tmp:
            candidate = Path(tmp) / stem.with_suffix(".json").name
            candidate.write_bytes(payload)
            tracked = stem.with_suffix(".json")
            if candidate.read_bytes() != tracked.read_bytes():
                raise SystemExit("tracked JSON differs from deterministic regeneration")
        verify_manifest(stem)
        print("C336 replay and SHA-256 manifest verified")
    else:
        output = args.output or stem.with_suffix(".json")
        output.write_bytes(payload)


if __name__ == "__main__":
    main()
