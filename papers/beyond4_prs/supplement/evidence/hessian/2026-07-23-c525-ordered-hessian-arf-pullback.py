#!/usr/bin/env python3
"""Generate the compact C525 ordered-Hessian certificate."""

from __future__ import annotations

import argparse
import itertools
import json
from pathlib import Path


def add(x: int, y: int) -> int:
    return x ^ y


def mul(x: int, y: int) -> int:
    value = 0
    a, b = x, y
    while b:
        if b & 1:
            value ^= a
        b >>= 1
        a <<= 1
        if a & 4:
            a ^= 0b111  # x^2+x+1
    return value


def inv(x: int) -> int:
    if not x:
        raise ZeroDivisionError
    for y in range(1, 4):
        if mul(x, y) == 1:
            return y
    raise AssertionError


def square(x: int) -> int:
    return mul(x, x)


def rref_key(rows: tuple[tuple[int, ...], tuple[int, ...]]) -> tuple[tuple[int, ...], ...] | None:
    matrix = [list(rows[0]), list(rows[1])]
    rank = 0
    for column in range(4):
        pivot = next((i for i in range(rank, 2) if matrix[i][column]), None)
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        scale = inv(matrix[rank][column])
        matrix[rank] = [mul(scale, x) for x in matrix[rank]]
        for i in range(2):
            if i != rank and matrix[i][column]:
                factor = matrix[i][column]
                matrix[i] = [
                    add(matrix[i][j], mul(factor, matrix[rank][j]))
                    for j in range(4)
                ]
        rank += 1
    if rank != 2:
        return None
    return tuple(tuple(row) for row in matrix)


def all_lines_f4() -> list[tuple[tuple[int, ...], tuple[int, ...]]]:
    vectors = [v for v in itertools.product(range(4), repeat=4) if any(v)]
    keys = {
        key
        for i, left in enumerate(vectors)
        for right in vectors[i + 1 :]
        if (key := rref_key((left, right))) is not None
    }
    return sorted(keys)


def hessian(point: tuple[int, ...]) -> tuple[int, int, int]:
    A, B, C, D = point
    return add(mul(A, C), square(B)), add(mul(A, D), mul(B, C)), add(mul(B, D), square(C))


def hessian_pencil(
    U: tuple[int, ...], V: tuple[int, ...]
) -> tuple[list[int], list[int], list[int]]:
    A, B, C, D = U
    a, b, c, d = V
    nu = [add(mul(A, C), square(B)), add(mul(A, c), mul(a, C)), add(mul(a, c), square(b))]
    ns = [
        add(mul(A, D), mul(B, C)),
        add(add(mul(A, d), mul(a, D)), add(mul(B, c), mul(b, C))),
        add(mul(a, d), mul(b, c)),
    ]
    delta = [add(mul(B, D), square(C)), add(mul(B, d), mul(b, D)), add(mul(b, d), square(c))]
    return nu, ns, delta


def homogeneous_multiply(left: list[int], right: list[int]) -> list[int]:
    answer = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            answer[i + j] = add(answer[i + j], mul(x, y))
    return answer


def reducible_over_f4(nu: list[int], ns: list[int], delta: list[int]) -> bool:
    target = homogeneous_multiply(nu, delta)
    for ell in itertools.product(range(4), repeat=3):
        lhs = [0] * 5
        for i, value in enumerate(ell):
            lhs[2 * i] = add(lhs[2 * i], square(value))
        product = homogeneous_multiply(list(ell), ns)
        lhs = [add(lhs[i], product[i]) for i in range(5)]
        if lhs == target:
            return True
    return False


def evaluate_quadratic(poly: list[int], u: int, v: int) -> int:
    return add(add(mul(poly[0], square(u)), mul(poly[1], mul(u, v))), mul(poly[2], square(v)))


def has_vertical_f4(nu: list[int], ns: list[int], delta: list[int]) -> bool:
    points = [(1, value) for value in range(4)] + [(0, 1)]
    return any(
        not evaluate_quadratic(nu, u, v)
        and not evaluate_quadratic(ns, u, v)
        and not evaluate_quadratic(delta, u, v)
        for u, v in points
    )


def plucker(U: tuple[int, ...], V: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(add(mul(U[i], V[j]), mul(U[j], V[i])) for i in range(4) for j in range(i + 1, 4))


def on_persistent_surface(p: tuple[int, ...]) -> bool:
    z0, z1, z2, z3, z4, z5 = p
    matrix = ((z0, z1, z2), (z1, add(z3, z2), z4), (z2, z4, z5))
    return all(
        add(mul(matrix[i][j], matrix[k][l]), mul(matrix[i][l], matrix[k][j])) == 0
        for i in range(3)
        for k in range(i + 1, 3)
        for j in range(3)
        for l in range(j + 1, 3)
    )


def on_complementary_conic(p: tuple[int, ...]) -> bool:
    z0, z1, z2, z3, z4, z5 = p
    return z0 == 0 and z5 == 0 and z2 == z3 and mul(z1, z4) == square(z2)


def certificate() -> dict[str, object]:
    lines = all_lines_f4()
    counts = {
        "all_lines": len(lines),
        "inseparable": 0,
        "reducible_separable": 0,
        "reducible_separable_without_rational_vertical": 0,
        "persistent_surface": 0,
        "complementary_conic": 0,
        "unexplained_reducible_separable_without_rational_vertical": 0,
    }
    for U, V in lines:
        nu, ns, delta = hessian_pencil(U, V)
        p = plucker(U, V)
        inseparable = not any(ns)
        reducible = not inseparable and reducible_over_f4(nu, ns, delta)
        vertical = has_vertical_f4(nu, ns, delta)
        persistent = on_persistent_surface(p)
        complementary = on_complementary_conic(p)
        counts["inseparable"] += int(inseparable)
        counts["reducible_separable"] += int(reducible)
        counts["reducible_separable_without_rational_vertical"] += int(reducible and not vertical)
        counts["persistent_surface"] += int(persistent)
        counts["complementary_conic"] += int(complementary)
        counts["unexplained_reducible_separable_without_rational_vertical"] += int(
            reducible and not vertical and not persistent
        )
        if inseparable and not (persistent or complementary):
            raise AssertionError(("unclassified inseparable line", U, V, p))
    if counts["all_lines"] != 357:
        raise AssertionError(counts)
    if counts["unexplained_reducible_separable_without_rational_vertical"]:
        raise AssertionError(counts)

    bounds = []
    for n in range(5, 13):
        root_count = n - 4
        quadratic_plus_one = root_count * (n + 3) // 2 + 1
        disjoint_blocks = 5 * root_count
        bounds.append(
            {
                "degree": n,
                "quadratic_strict_bound": root_count * (n + 3) // 2,
                "disjoint_five_blocks": disjoint_blocks,
                "base_selection_threshold": min(quadratic_plus_one, disjoint_blocks),
                "deletion": 3 * n - 4,
            }
        )

    return {
        "schema": "c525-ordered-hessian-arf-pullback-v1",
        "field_check": {"field": "F4=x^2+x+1", **counts},
        "universal": {
            "line": "U*u+V*v in P(Gamma^3 E)",
            "incidence": "Nu(u,v)*X^2+Ns(u,v)*X*Y+D(u,v)*Y^2",
            "bidegree": [2, 2],
            "arithmetic_genus": 1,
            "vertical_factor": "line meets the twisted cubic",
            "separable_external_factorization": "persistent surface q*E",
            "inseparable_locus": "two rulings of Q: Ns=0",
        },
        "persistent_surface": {
            "parametrization": "[a^2,a*b,a*c,b^2+a*c,b*c,c^2]",
            "ideal": "2x2 minors of [[z0,z1,z2],[z1,z3+z2,z4],[z2,z4,z5]]",
            "meaning": "line q*E for q=a*X^2+b*X*Y+c*Y^2",
        },
        "complementary_ruling_conic": {
            "ideal": ["z0", "z5", "z2+z3", "z1*z4+z2^2"],
            "contained_root_line_pullback": "rank at most one by consecutive-linear-form proportionality",
        },
        "normal_forms": {
            "semisimple": "g(t)=c*t forces c^2+c+1=0 and line <X^2Y,XY^2>=XY*E",
            "unipotent": "g(t)=t+1 forces delta=gamma=0 and a*gamma=1, contradiction",
        },
        "bounds": {
            "quadratic_strict_formula": "q>(n-4)*(n+3)/2",
            "disjoint_block_formula": "q>=5*(n-4)",
            "best_integer_threshold": "min((n-4)*(n+3)/2+1,5*(n-4))",
            "deletion_formula": "3*n-4",
            "table": bounds,
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    encoded = json.dumps(certificate(), indent=2, sort_keys=True) + "\n"
    if args.check:
        if not args.output.exists() or args.output.read_text() != encoded:
            raise SystemExit(f"certificate mismatch: {args.output}")
    else:
        args.output.write_text(encoded)


if __name__ == "__main__":
    main()
