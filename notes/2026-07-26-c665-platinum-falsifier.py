#!/usr/bin/env python3
"""Bounded exact falsifier for C665's trade-only Platinum conjecture."""

from __future__ import annotations

import hashlib
import importlib.util
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-07-26-c665-balanced-matching-completeness.py"
OUTPUT = Path(__file__).with_suffix(".json")
SCHEMA = "c665-platinum-falsifier-v1"


def load_base():
    spec = importlib.util.spec_from_file_location("c665_base", BASE_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


BASE = load_base()


def gf9_add(x, y):
    return ((x % 3 + y % 3) % 3) + 3 * ((x // 3 + y // 3) % 3)


def gf9_neg(x):
    return ((-x % 3) % 3) + 3 * ((-(x // 3) % 3) % 3)


def gf9_mul(x, y):
    a, b = x % 3, x // 3
    c, d = y % 3, y // 3
    return ((a * c + 2 * b * d) % 3) + 3 * ((a * d + b * c) % 3)


def gf9_pow(x, exponent):
    answer = 1
    while exponent:
        if exponent & 1:
            answer = gf9_mul(answer, x)
        x = gf9_mul(x, x)
        exponent //= 2
    return answer


def gf9_inv(x):
    assert x
    return gf9_pow(x, 7)


def gf9_matrix_normalize(entries):
    pivot = next(x for x in entries if x)
    scale = gf9_inv(pivot)
    return tuple(gf9_mul(scale, x) for x in entries)


def gf9_mobius(entries, x):
    a, b, c, d = entries
    if x == 9:
        return 9 if c == 0 else gf9_mul(a, gf9_inv(c))
    numerator = gf9_add(gf9_mul(a, x), b)
    denominator = gf9_add(gf9_mul(c, x), d)
    return 9 if denominator == 0 else gf9_mul(numerator, gf9_inv(denominator))


def q9_groups():
    actions = {}
    for a in range(9):
        for b in range(9):
            for c in range(9):
                for d in range(9):
                    determinant = gf9_add(gf9_mul(a, d), gf9_neg(gf9_mul(b, c)))
                    entries = (a, b, c, d)
                    if determinant == 0 or gf9_matrix_normalize(entries) != entries:
                        continue
                    action = tuple(gf9_mobius(entries, x) for x in range(10))
                    actions[action] = determinant
    squares = {gf9_mul(x, x) for x in range(1, 9)}
    pgl = set(actions)
    psl = {g for g, determinant in actions.items() if determinant in squares}
    assert len(pgl) == 720 and len(psl) == 360
    return pgl, psl


def q9_census():
    pgl, psl = q9_groups()
    matchings = list(BASE.perfect_matchings(range(10)))
    full_parts = BASE.subgroup_orbits(pgl, matchings)
    records = []
    for part in full_parts:
        special_parts = BASE.subgroup_orbits(psl, part)
        records.append(
            {
                "size": len(part),
                "psl_orbit_sizes": sorted(len(x) for x in special_parts),
            }
        )
    assert len(matchings) == 945
    assert len(records) == 9
    assert not any(len(record["psl_orbit_sizes"]) == 2 for record in records)
    return {
        "field_model": "F_3[a]/(a^2+1), encoded a0+3*a1",
        "perfect_matching_count": len(matchings),
        "orbit_size_histogram": dict(
            sorted(Counter(record["size"] for record in records).items())
        ),
        "split_orbit_count": 0,
    }


def q13_census():
    q = 13
    pgl, psl = BASE.projective_groups(q)
    matchings = list(BASE.perfect_matchings(range(q + 1)))
    full_parts = BASE.subgroup_orbits(pgl, matchings)
    split = []
    for part in full_parts:
        special_parts = BASE.subgroup_orbits(psl, part)
        if len(special_parts) == 2:
            split.append(len(part))
    affine_bound = 1 + len(BASE.homogeneous_basis((q - 3) // 2))
    square_bound = affine_bound * (affine_bound + 1) // 2
    assert len(matchings) == 135135
    assert len(full_parts) == 128
    assert Counter(split) == Counter({364: 1, 1092: 10, 2184: 21})
    assert square_bound == 253 < min(split)
    return {
        "perfect_matching_count": len(matchings),
        "full_orbit_count": len(full_parts),
        "split_orbit_size_histogram": dict(sorted(Counter(split).items())),
        "ambient_affine_dimension_bound": affine_bound,
        "ambient_quadratic_dimension_bound": square_bound,
        "minimum_split_trade_dimension_bound": min(split) - square_bound,
    }


def evaluation_summary(q, representative):
    pgl, psl = BASE.projective_groups(q)
    full_orbit = sorted(BASE.orbit(pgl, representative))
    special_parts = BASE.subgroup_orbits(psl, full_orbit)
    base_product = BASE.matching_product(full_orbit[0], q)
    quotient_degree = (q - 3) // 2
    points = []
    for matching in full_orbit:
        product = BASE.matching_product(matching, q)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % q
            for exponent in set(product) | set(base_product)
        }
        points.append(BASE.quotient_by_conic(difference, quotient_degree, q))
    rows = BASE.row_basis(
        [[1] * len(points)] + [list(column) for column in zip(*points)], q
    )
    square = [
        [x * y % q for x, y in zip(rows[i], rows[j])]
        for i in range(len(rows))
        for j in range(i, len(rows))
    ]
    square_rank = BASE.rank(square, q)
    return {
        "representative": [list(edge) for edge in representative],
        "orbit_size": len(full_orbit),
        "psl_orbit_sizes": sorted(len(x) for x in special_parts),
        "affine_linear_rank": len(rows),
        "schur_square_rank": square_rank,
        "quadratic_trade_dimension": len(full_orbit) - square_rank,
    }


Q17_REPRESENTATIVES = (
    ((0, 1), (2, 7), (3, 4), (5, 10), (6, 9), (8, 13), (11, 12), (14, 15), (16, 17)),
    ((0, 1), (2, 3), (4, 5), (6, 16), (7, 13), (8, 14), (9, 15), (10, 12), (11, 17)),
    ((0, 1), (2, 4), (3, 10), (5, 12), (6, 16), (7, 9), (8, 17), (11, 14), (13, 15)),
)

Q19_A5_REPRESENTATIVE = (
    (0, 1),
    (2, 10),
    (3, 14),
    (4, 8),
    (5, 17),
    (6, 18),
    (7, 16),
    (9, 15),
    (11, 12),
    (13, 19),
)


def certificate():
    q17 = [evaluation_summary(17, representative) for representative in Q17_REPRESENTATIVES]
    assert [(x["orbit_size"], x["quadratic_trade_dimension"]) for x in q17] == [
        (204, 84),
        (408, 193),
        (612, 288),
    ]
    q19 = evaluation_summary(19, Q19_A5_REPRESENTATIVE)
    assert (q19["orbit_size"], q19["quadratic_trade_dimension"]) == (114, 14)
    return {
        "schema": SCHEMA,
        "scope": {
            "statement": (
                "bounded falsification of the conjecture that a unique two-valued "
                "quadratic trade forces lambda=1"
            ),
            "exhaustive_fields": [9, 13],
            "q17_scope": (
                "three explicit split competitors of sizes 204, 408, and 612; "
                "the certificate evaluates them but does not certify subgroup-list exhaustion"
            ),
            "q19_scope": "small exceptional A5-stabilized split competitor only",
        },
        "q9": q9_census(),
        "q13": q13_census(),
        "q17": q17,
        "q19_exceptional": q19,
        "verdict": "no counterexample in the certified bounded scope",
    }


def main():
    data = (json.dumps(certificate(), indent=2, sort_keys=True) + "\n").encode()
    OUTPUT.write_bytes(data)
    print(f"C665 Platinum falsifier: OK sha256={hashlib.sha256(data).hexdigest()}")


if __name__ == "__main__":
    main()
