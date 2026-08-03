#!/usr/bin/env python3
"""Intrinsic quotient experiments for C620's degree-nine Lucas carrier."""

from __future__ import annotations

import importlib.util
import argparse
import hashlib
import json
import random
from itertools import combinations, product
from pathlib import Path


HERE = Path(__file__).resolve().parent
C531_PATH = HERE / "2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata.py"
SPEC = importlib.util.spec_from_file_location("c531", C531_PATH)
assert SPEC is not None and SPEC.loader is not None
C531 = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(C531)

def gf_add_product(total: int, left: int, right: int, modulus: int) -> int:
    return total ^ C531.gf_mul(left, right, modulus)


def evaluate_action_entry(source: int, target: int, matrix: tuple[int, int, int, int], modulus: int) -> int:
    a, b, c, d = matrix
    total = 0
    for ea, eb, ec, ed in C531.action_entry(source, target):
        term = C531.gf_pow(a, ea, modulus)
        term = C531.gf_mul(term, C531.gf_pow(b, eb, modulus), modulus)
        term = C531.gf_mul(term, C531.gf_pow(c, ec, modulus), modulus)
        term = C531.gf_mul(term, C531.gf_pow(d, ed, modulus), modulus)
        total ^= term
    return total


def canonical(point: tuple[int, ...], modulus: int) -> tuple[int, ...]:
    return C531.canonical(point, modulus)


def carrier_matrix(matrix: tuple[int, int, int, int], modulus: int) -> tuple[tuple[int, ...], ...]:
    return tuple(
        tuple(evaluate_action_entry(source, target, matrix, modulus) for target in range(2, 8))
        for source in range(2, 8)
    )


def act(point: tuple[int, ...], matrix: tuple[tuple[int, ...], ...], modulus: int) -> tuple[int, ...]:
    out = []
    for target in range(6):
        value = 0
        for source in range(6):
            value = gf_add_product(value, point[source], matrix[source][target], modulus)
        out.append(value)
    return canonical(tuple(out), modulus)


def projective_points(q: int) -> list[tuple[int, ...]]:
    out: list[tuple[int, ...]] = []
    for pivot in range(6):
        for tail in product(range(q), repeat=5 - pivot):
            out.append((0,) * pivot + (1,) + tail)
    return out


def multiply_by_linear(coefficients: tuple[int, ...], root: int, modulus: int) -> tuple[int, ...]:
    out = [0] * (len(coefficients) + 1)
    for i, coefficient in enumerate(coefficients):
        out[i] = gf_add_product(out[i], coefficient, root, modulus)
        out[i + 1] ^= coefficient
    return tuple(out)


def divisor_rows(q: int, modulus: int) -> list[tuple[tuple[int, ...], tuple[int, ...], tuple[int, ...]]]:
    infinity = q
    out = []
    for roots in combinations(range(q + 1), 8):
        coefficients = (1,)
        for root in roots:
            if root != infinity:
                coefficients = multiply_by_linear(coefficients, root, modulus)
        coefficients += (0,) * (9 - len(coefficients))
        out.append((coefficients[1:7], coefficients[2:8], roots))
    return out


def divisor_row(roots: tuple[int, ...], q: int, modulus: int) -> tuple[tuple[int, ...], tuple[int, ...]]:
    coefficients = (1,)
    for root in roots:
        if root != q:
            coefficients = multiply_by_linear(coefficients, root, modulus)
    coefficients += (0,) * (9 - len(coefficients))
    return coefficients[1:7], coefficients[2:8]


def dot(left: tuple[int, ...], right: tuple[int, ...], modulus: int) -> int:
    value = 0
    for x, y in zip(left, right):
        value = gf_add_product(value, x, y, modulus)
    return value


def matrix_rank(rows: list[list[int]], modulus: int) -> int:
    work = [row[:] for row in rows]
    rank = 0
    for column in range(len(work[0])):
        pivot = next((i for i in range(rank, len(work)) if work[i][column]), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = C531.gf_pow(work[rank][column], (1 << (modulus.bit_length() - 1)) - 2, modulus)
        work[rank] = [C531.gf_mul(value, inverse, modulus) for value in work[rank]]
        for i in range(len(work)):
            if i != rank and work[i][column]:
                factor = work[i][column]
                work[i] = [x ^ C531.gf_mul(factor, y, modulus) for x, y in zip(work[i], work[rank])]
        rank += 1
    return rank


def coefficient_map_rank(point: tuple[int, ...], modulus: int) -> int:
    z2, z3, z4, z5, z6, z7 = point
    return matrix_rank(
        [
            [z3, z4, z5, z6, z7, 0],
            [z2, z3, z4, z5, z6, z7],
            [0, z2, z3, z4, z5, z6],
            [0, 0, z2, z3, z4, z5],
        ],
        modulus,
    )


def complement_point(u: tuple[int, int, int, int]) -> tuple[int, ...]:
    return u[0], u[1], 1, 0, u[2], u[3]


def normalized_complement_action(
    u: tuple[int, int, int, int], matrix: tuple[tuple[int, ...], ...], modulus: int
) -> tuple[int, int, int, int]:
    image = act(complement_point(u), matrix, modulus)
    assert image[2] and image[3] == 0
    inverse = C531.gf_pow(image[2], (1 << (modulus.bit_length() - 1)) - 2, modulus)
    normalized = tuple(C531.gf_mul(value, inverse, modulus) for value in image)
    assert normalized[2:4] == (1, 0)
    return normalized[0], normalized[1], normalized[4], normalized[5]


def complement_orbit_representatives(q: int, modulus: int) -> list[tuple[int, int, int, int]]:
    primitive = C531.primitive_element(q, modulus)
    generators = [
        (1, 1, 0, 1),
        (primitive, 0, 0, 1),
    ]
    matrices = [carrier_matrix(g, modulus) for g in generators]
    unseen = set(product(range(q), repeat=4))
    representatives: list[tuple[int, int, int, int]] = []
    while unseen:
        representative = min(unseen)
        orbit = {representative}
        frontier = [representative]
        while frontier:
            point = frontier.pop()
            for matrix in matrices:
                image = normalized_complement_action(point, matrix, modulus)
                if image not in orbit:
                    orbit.add(image)
                    frontier.append(image)
        unseen.difference_update(orbit)
        representatives.append(representative)
    return representatives


def candidate_divisors(q: int, modulus: int) -> list[tuple[tuple[int, ...], tuple[int, ...], tuple[int, ...]]]:
    if q == 16:
        return divisor_rows(q, modulus)
    rng = random.Random(620_000 + q)
    seen: set[tuple[int, ...]] = set()
    out = []
    while len(out) < 100_000:
        roots = tuple(sorted(rng.sample(range(q + 1), 8)))
        if roots in seen:
            continue
        seen.add(roots)
        r1, r2 = divisor_row(roots, q, modulus)
        out.append((r1, r2, roots))
    return out


def mobius(point: int, matrix: tuple[int, int, int, int], q: int, modulus: int) -> int:
    a, b, c, d = matrix
    if point == q:
        if c == 0:
            return q
        return C531.gf_mul(a, C531.gf_pow(c, q - 2, modulus), modulus)
    numerator = C531.gf_mul(a, point, modulus) ^ b
    denominator = C531.gf_mul(c, point, modulus) ^ d
    if denominator == 0:
        return q
    return C531.gf_mul(numerator, C531.gf_pow(denominator, q - 2, modulus), modulus)


def projective_additive_rows_q16(modulus: int) -> list[tuple[tuple[int, ...], tuple[int, ...], tuple[int, ...]]]:
    q = 16
    primitive = C531.primitive_element(q, modulus)
    generators = [(1, 1, 0, 1), (primitive, 0, 0, 1), (0, 1, 1, 0)]
    root_sets = {
        tuple(x for x in range(q) if (x & functional).bit_count() % 2 == value)
        for functional in range(1, q)
        for value in (0, 1)
    }
    frontier = list(root_sets)
    while frontier:
        roots = frontier.pop()
        for matrix in generators:
            image = tuple(sorted(mobius(root, matrix, q, modulus) for root in roots))
            if image not in root_sets:
                root_sets.add(image)
                frontier.append(image)
    out = []
    for roots in sorted(root_sets):
        r1, r2 = divisor_row(roots, q, modulus)
        out.append((r1, r2, roots))
    return out


def bounded_certificate(q: int) -> dict[str, object]:
    assert q in (16, 32)
    m = q.bit_length() - 1
    modulus = C531.first_irreducible(m)
    representatives = complement_orbit_representatives(q, modulus)
    candidates = candidate_divisors(q, modulus)
    additive_rows = projective_additive_rows_q16(modulus) if q == 16 else []
    records = []
    rank_counts: dict[int, int] = {}
    for u in representatives:
        point = complement_point(u)
        rank = coefficient_map_rank(point, modulus)
        rank_counts[rank] = rank_counts.get(rank, 0) + 1
        witness = next(
            (roots for r1, r2, roots in candidates if dot(point, r1, modulus) == 0 and dot(point, r2, modulus) == 0),
            None,
        )
        if witness is None:
            raise AssertionError(f"candidate bank missed orbit {u}")
        additive_flag = -1
        if q == 16:
            additive_flag = int(any(
                dot(point, r1, modulus) == 0 and dot(point, r2, modulus) == 0
                for r1, r2, _ in additive_rows
            ))
        records.append([*u, *witness, additive_flag])
    result = {
        "schema": "c620-higher-lucas-quotient-v2",
        "record_layout": ["u0", "u1", "u2", "u3", "root0", "root1", "root2", "root3", "root4", "root5", "root6", "root7", "projective_additive_flag"],
        "field_order": q,
        "modulus": modulus,
        "normalized_slice": "(z2,z3,z4,z5,z6,z7)=(u0,u1,1,0,u2,u3)",
        "borel_generators": [[1, 1, 0, 1], [C531.primitive_element(q, modulus), 0, 0, 1]],
        "orbit_count": len(representatives),
        "map_rank_orbit_counts": {str(key): value for key, value in sorted(rank_counts.items())},
        "c531_source_sha256": hashlib.sha256(C531_PATH.read_bytes()).hexdigest(),
        "records": records,
    }
    if q == 16:
        result["projective_additive_divisor_count"] = len(additive_rows)
        result["orbits_without_projective_additive_witness"] = sum(
            record[-1] == 0 for record in records
        )
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("q", type=int, choices=(16, 32))
    destination = parser.add_mutually_exclusive_group()
    destination.add_argument("--output", type=Path)
    destination.add_argument("--check", type=Path)
    args = parser.parse_args()
    data = bounded_certificate(args.q)
    encoded = json.dumps(data, sort_keys=True, separators=(",", ":")) + "\n"
    if args.check is not None:
        if args.check.read_text() != encoded:
            raise AssertionError(f"certificate drift: {args.check}")
        print(json.dumps({"checked": str(args.check), "orbit_count": data["orbit_count"]}, sort_keys=True))
    elif args.output is None:
        print(json.dumps({key: value for key, value in data.items() if key != "records"}, sort_keys=True))
    else:
        args.output.write_text(encoded)
        print(json.dumps({"output": str(args.output), "orbit_count": data["orbit_count"]}, sort_keys=True))


if __name__ == "__main__":
    main()
