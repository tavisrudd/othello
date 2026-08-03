#!/usr/bin/env python3
"""Independent replay for the C516 residual-quadratic certificate."""

from __future__ import annotations

import json
import math
from pathlib import Path

HERE = Path(__file__).resolve().parent
DATA = json.loads(
    (HERE / "2026-07-23-c516-prs-redundancy-nine.json").read_text()
)
PAPER_DATA = (
    HERE.parent
    / "papers"
    / "beyond4_prs"
    / "supplement"
    / "R9-SLICE-DATA.md"
)


# F_49 = F_7[tau]/(tau^2-3), encoded as a+7b.
def add(x, y):
    return ((x % 7 + y % 7) % 7) + 7 * (((x // 7) + (y // 7)) % 7)


def neg(x):
    return ((-x) % 7) + 7 * ((-(x // 7)) % 7)


def sub(x, y):
    return add(x, neg(y))


def mul(x, y):
    a, b = x % 7, x // 7
    c, d = y % 7, y // 7
    return ((a * c + 3 * b * d) % 7) + 7 * ((a * d + b * c) % 7)


def power(x, exponent):
    out = 1
    while exponent:
        if exponent & 1:
            out = mul(out, x)
        x = mul(x, x)
        exponent //= 2
    return out


def scale(integer, x):
    out = 0
    for _ in range(integer % 7):
        out = add(out, x)
    return out


def padd(left, right):
    out = [0] * max(len(left), len(right))
    for i in range(len(out)):
        out[i] = add(
            left[i] if i < len(left) else 0,
            right[i] if i < len(right) else 0,
        )
    while out and out[-1] == 0:
        out.pop()
    return out


def pneg(poly):
    return [neg(value) for value in poly]


def psub(left, right):
    return padd(left, pneg(right))


def pmul(left, right):
    if not left or not right:
        return []
    out = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            out[i + j] = add(out[i + j], mul(x, y))
    while out and out[-1] == 0:
        out.pop()
    return out


def ppow(poly, exponent):
    out = [1]
    while exponent:
        if exponent & 1:
            out = pmul(out, poly)
        poly = pmul(poly, poly)
        exponent //= 2
    return out


def peval(poly, value):
    out = 0
    for coefficient in reversed(poly):
        out = add(mul(out, value), coefficient)
    return out


def product_fixed_and_moving(roots):
    fixed = [1]
    for root in roots:
        fixed = pmul(fixed, [(-root) % 7, 1])
    # Coefficients p_i are linear polynomials in the moving root x.
    coefficients = [[0] for _ in range(6)]
    for i, value in enumerate(fixed):
        coefficients[i] = padd(coefficients[i], [0, (-value) % 7])
        coefficients[i + 1] = padd(coefficients[i + 1], [value])
    return coefficients


def residual_branch(roots, ell):
    coefficients = product_fixed_and_moving(roots)
    h = [1, 0, ell, 0, 1]

    def p(index):
        return coefficients[index] if 0 <= index < 6 else []

    hankel = []
    for shift in (-1, 0, 1, 2):
        value = []
        for j in range(5):
            value = padd(value, [mul(h[j], term) for term in p(j + shift)])
        hankel.append(value)
    hm1, h0, h1, h2 = hankel
    determinant = psub(pmul(h0, h2), pmul(h1, h1))
    trace = psub(pmul(hm1, h2), pmul(h0, h1))
    norm = psub(pmul(hm1, h1), pmul(h0, h0))
    branch = psub(ppow(trace, 2), [scale(4, value) for value in pmul(norm, determinant)])
    return determinant, trace, norm, branch


def quartic_discriminant(poly):
    coefficients = poly + [0] * (5 - len(poly))
    e, d, c, b, a = coefficients[:5]

    def term(integer, *factors):
        out = integer % 7
        for factor in factors:
            out = mul(out, factor)
        return out

    values = [
        term(256, power(a, 3), power(e, 3)),
        term(-192, power(a, 2), b, d, power(e, 2)),
        term(-128, power(a, 2), power(c, 2), power(e, 2)),
        term(144, power(a, 2), c, power(d, 2), e),
        term(-27, power(a, 2), power(d, 4)),
        term(144, a, power(b, 2), c, power(e, 2)),
        term(-6, a, power(b, 2), power(d, 2), e),
        term(-80, a, b, power(c, 2), d, e),
        term(18, a, b, c, power(d, 3)),
        term(16, a, power(c, 4), e),
        term(-4, a, power(c, 3), power(d, 2)),
        term(-27, power(b, 4), power(e, 2)),
        term(18, power(b, 3), c, d, e),
        term(-4, power(b, 3), power(d, 3)),
        term(-4, power(b, 2), power(c, 3), e),
        term(1, power(b, 2), power(c, 2), power(d, 2)),
    ]
    out = 0
    for value in values:
        out = add(out, value)
    return out


def trim7(coefficients):
    coefficients = [value % 7 for value in coefficients]
    while coefficients and coefficients[-1] == 0:
        coefficients.pop()
    return coefficients


def add_poly7(left, right):
    out = [0] * max(len(left), len(right))
    for index in range(len(out)):
        out[index] = (
            (left[index] if index < len(left) else 0)
            + (right[index] if index < len(right) else 0)
        ) % 7
    return trim7(out)


def multiply_poly7(left, right):
    out = [0] * (len(left) + len(right) - 1)
    for i, left_value in enumerate(left):
        for j, right_value in enumerate(right):
            out[i + j] = (
                out[i + j] + left_value * right_value
            ) % 7
    return trim7(out)


def replay_discriminants():
    rows = DATA["normal_squarefree_family"]["base_fibres"]
    for row in rows:
        roots = tuple(row["fixed_roots"])
        recorded = row["discriminant_coefficients_low_first"]
        for ell in range(49):
            determinant, trace, norm, branch = residual_branch(roots, ell)
            assert len(determinant) - 1 <= 2
            assert len(trace) - 1 <= 2
            assert len(norm) - 1 <= 2
            assert len(branch) - 1 <= 4
            assert quartic_discriminant(branch) == peval(recorded, ell)
    coefficients = DATA["normal_squarefree_family"][
        "bezout_coefficients_low_first"
    ]
    total = []
    for row, coefficient in zip(rows, coefficients, strict=True):
        total = add_poly7(
            total,
            multiply_poly7(
                row["discriminant_coefficients_low_first"],
                coefficient,
            ),
        )
    assert total == [1]
    paper_text = PAPER_DATA.read_text()
    coefficients = DATA["normal_squarefree_family"][
        "bezout_coefficients_low_first"
    ]
    for index, (row, coefficient) in enumerate(
        zip(rows, coefficients, strict=True),
        start=1,
    ):
        roots_text = json.dumps(
            row["fixed_roots"],
            separators=(",", ":"),
        )
        discriminant_text = json.dumps(
            row["discriminant_coefficients_low_first"],
            separators=(",", ":"),
        )
        coefficient_text = json.dumps(
            coefficient,
            separators=(",", ":"),
        )
        assert (
            f"| {index} | `{roots_text}` | `{discriminant_text}` |"
            in paper_text
        )
        assert (
            f"| {index} | `{coefficient_text}` |"
            in paper_text
        )
    quartic_vectors = {
        "partition_4": [1, 0, 0, 0, 0],
        "partition_31": [0, 1, 0, 0, 0],
        "partition_22": [0, 0, 1, 0, 0],
        "partition_211": [0, 1, 6, 0, 0],
    }
    for name, row in DATA["multiple_root_normal_forms"].items():
        values = [
            quartic_vectors[name],
            row["fixed_roots"],
            row["reduced_branch_coefficients_x_low_first"],
        ]
        rendered = [
            json.dumps(value, separators=(",", ":"))
            for value in values
        ]
        assert all(f"`{value}`" in paper_text for value in rendered)
        assert f"| {row['reduced_branch_discriminant']} |" in paper_text


def replay_residual_linear_system():
    roots = (0, 1, 2, 4)
    ell = 10
    determinant, trace, norm, _ = residual_branch(roots, ell)
    for moving in (3, 8, 17, 31):
        d_value = peval(determinant, moving)
        if d_value == 0:
            continue
        s_value = mul(peval(trace, moving), power(d_value, 47))
        u_value = mul(peval(norm, moving), power(d_value, 47))
        p_coefficients = [
            peval(poly, moving) for poly in product_fixed_and_moving(roots)
        ]
        q_coefficients = [u_value, neg(s_value), 1]
        product = pmul(p_coefficients, q_coefficients)
        h = [1, 0, ell, 0, 1]
        row0 = sum(
            (
                mul(h[j], product[j + 2])
                for j in range(5)
            ),
            0,
        )
        row1 = sum(
            (
                mul(h[j], product[j + 1])
                for j in range(5)
            ),
            0,
        )
        # Python's integer sum is not field addition.
        row0 = 0
        row1 = 0
        for j in range(5):
            row0 = add(row0, mul(h[j], product[j + 2]))
            row1 = add(row1, mul(h[j], product[j + 1]))
        assert row0 == row1 == 0


def replay_thresholds_and_counts():
    thresholds = DATA["thresholds"]
    deletion = thresholds["four_marker_deletion"]
    integer = thresholds["exact_integer_threshold"]
    assert deletion == 36
    assert (integer - 1) + 1 - 2 * math.sqrt(integer - 1) <= deletion
    assert integer + 1 - 2 * math.sqrt(integer) > deletion
    assert integer == 50
    assert thresholds["first_prime_power"] == 53

    modular_deletion = DATA["divisor_degrees_on_modular_curve"]
    assert sum(
        modular_deletion[key]
        for key in (
            "fixed_root_diagonal",
            "determinant",
            "branch",
            "four_fixed_root_collisions",
            "moving_root_collision",
        )
    ) == modular_deletion["total_deletion_bound"] == 32

    # Inclusion-exclusion on the eight evaluation hyperplanes in P^4(F_7).
    rootless_vectors = sum(
        (-1) ** k * math.comb(8, k) * (7 ** (5 - k) - 1)
        for k in range(5)
    )
    assert rootless_vectors // 6 == 819
    assert DATA["q7_rootless_deep_quartics"] == 819


def replay_orbits():
    rows = {row["d"]: row for row in DATA["persistent_orbits"]["rows"]}
    for d in (1, 2, 4, 8):
        classes = {min(x, (-x) % d) if d > 1 else 0 for x in range(d)}
        assert len(classes) == rows[d]["sigma_pgl_orbits"]
    d = 8
    classes = [{x, (-x) % d} for x in range(d)]
    canonical = {min(block) for block in classes}
    for multiplier, expected in ((1, 5), (7, 5), (3, 4), (5, 4)):
        seen = set()
        count = 0
        for representative in canonical:
            if representative in seen:
                continue
            count += 1
            current = representative
            while current not in seen:
                seen.add(current)
                current = min(
                    (multiplier * current) % d,
                    (-multiplier * current) % d,
                )
        assert count == expected


def main():
    replay_discriminants()
    replay_residual_linear_system()
    replay_thresholds_and_counts()
    replay_orbits()
    print(
        "C516 replay passed: F49 discriminant interpolation, Bezout identity, "
        "residual equations, thresholds, q=7 count, and orbit fusion"
    )


if __name__ == "__main__":
    main()
