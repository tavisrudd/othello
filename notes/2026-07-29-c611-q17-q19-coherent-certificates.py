#!/usr/bin/env python3
"""Generate the C611 q=17,19 coherent-orbit and rational-LP certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter
from fractions import Fraction
from pathlib import Path
from typing import Iterator

Point = tuple[int, int, int]
Matrix2 = tuple[int, int, int, int]

ROOT = Path(__file__).resolve().parents[1]
PAPER = ROOT / "papers" / "clebsch-rigidity" / "verification"
DEFAULT_OUTPUT = ROOT / "notes" / "2026-07-29-c611-q17-q19-coherent-certificates.json"


def normalize(vector: Point, q: int) -> Point:
    for value in vector:
        if value % q:
            inverse = pow(value, q - 2, q)
            return tuple(inverse * coordinate % q for coordinate in vector)  # type: ignore[return-value]
    raise ValueError("zero projective vector")


def points(q: int) -> list[Point]:
    answer = [(1, y, z) for y in range(q) for z in range(q)]
    answer.extend((0, 1, z) for z in range(q))
    answer.append((0, 0, 1))
    return answer


def cross(left: Point, right: Point, q: int) -> Point:
    return normalize(
        (
            left[1] * right[2] - left[2] * right[1],
            left[2] * right[0] - left[0] * right[2],
            left[0] * right[1] - left[1] * right[0],
        ),
        q,
    )


def dot(left: Point, right: Point, q: int) -> int:
    return sum(x * y for x, y in zip(left, right)) % q


def passant(left: Point, right: Point, q: int) -> bool:
    a, b, c = cross(left, right, q)
    discriminant = (b * b - 4 * a * c) % q
    return discriminant != 0 and pow(discriminant, (q - 1) // 2, q) == q - 1


def pgl2(q: int) -> Iterator[Matrix2]:
    seen: set[Matrix2] = set()
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    if (a * d - b * c) % q == 0:
                        continue
                    raw = (a, b, c, d)
                    first = next(value for value in raw if value)
                    inverse = pow(first, q - 2, q)
                    matrix = tuple(inverse * value % q for value in raw)
                    if matrix not in seen:
                        seen.add(matrix)  # type: ignore[arg-type]
                        yield matrix  # type: ignore[misc]


def act(matrix: Matrix2, point: Point, q: int) -> Point:
    a, b, c, d = matrix
    x, y, z = point
    return normalize(
        (
            a * a * x + 2 * a * b * y + b * b * z,
            a * c * x + (a * d + b * c) * y + b * d * z,
            c * c * x + 2 * c * d * y + d * d * z,
        ),
        q,
    )


def edge_key(left: int, right: int) -> tuple[int, int]:
    return (left, right) if left < right else (right, left)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def rooted_arcs(
    root: tuple[int, int],
    off: list[Point],
    neighbors: list[int],
    q: int,
    size: int,
) -> set[tuple[int, ...]]:
    selected = list(root)
    candidates = neighbors[root[0]] & neighbors[root[1]]
    candidates &= ~(1 << root[0])
    candidates &= ~(1 << root[1])
    answer: set[tuple[int, ...]] = set()

    def visit(remaining: int) -> None:
        if len(selected) == size:
            answer.add(tuple(sorted(selected)))
            return
        while remaining:
            bit = remaining & -remaining
            remaining ^= bit
            vertex = bit.bit_length() - 1
            if any(
                dot(cross(off[selected[i]], off[selected[j]], q), off[vertex], q) == 0
                for i in range(len(selected))
                for j in range(i + 1, len(selected))
            ):
                continue
            selected.append(vertex)
            visit(remaining & neighbors[vertex])
            selected.pop()

    visit(candidates)
    return answer


def field_certificate(q: int) -> dict[str, object]:
    input_path = PAPER / f"conic_filling_q{q}.json"
    old = json.loads(input_path.read_text())
    all_points = points(q)
    conic = {
        point for point in all_points if (point[0] * point[2] - point[1] ** 2) % q == 0
    }
    off = [point for point in all_points if point not in conic]
    index = {point: i for i, point in enumerate(off)}

    neighbors = [0] * len(off)
    passant_edges: set[tuple[int, int]] = set()
    for left in range(len(off)):
        for right in range(left + 1, len(off)):
            if passant(off[left], off[right], q):
                passant_edges.add((left, right))
                neighbors[left] |= 1 << right
                neighbors[right] |= 1 << left

    matrices = list(pgl2(q))
    permutations = [[index[act(matrix, point, q)] for point in off] for matrix in matrices]
    roots = [
        edge_key(*(index[tuple(point)] for point in record["representative"]))
        for record in old["roots"]
    ]

    edge_orbit: dict[tuple[int, int], int] = {}
    for orbit_index, root in enumerate(roots):
        orbit = {
            edge_key(permutation[root[0]], permutation[root[1]])
            for permutation in permutations
        }
        if any(edge in edge_orbit for edge in orbit):
            raise AssertionError("input edge roots overlap")
        edge_orbit.update((edge, orbit_index) for edge in orbit)
    if set(edge_orbit) != passant_edges:
        raise AssertionError("input edge roots do not cover the passant edges")

    raw_rooted: set[tuple[int, ...]] = set()
    for root in roots:
        raw_rooted |= rooted_arcs(root, off, neighbors, q, 6)
    canonical = sorted(
        {
            min(tuple(sorted(permutation[x] for x in arc)) for permutation in permutations)
            for arc in raw_rooted
        }
    )

    triple_cache: dict[tuple[int, int, int], tuple[int, int, int]] = {}

    def canonical_triple(triple: tuple[int, int, int]) -> tuple[int, int, int]:
        if triple not in triple_cache:
            triple_cache[triple] = min(
                tuple(sorted(permutation[x] for x in triple))
                for permutation in permutations
            )
        return triple_cache[triple]

    triple_types = sorted(
        {
            canonical_triple(triple)
            for arc in canonical
            for triple in itertools.combinations(arc, 3)
        }
    )
    triple_type_index = {triple: i for i, triple in enumerate(triple_types)}

    orbit_records = []
    for arc in canonical:
        images = {
            tuple(sorted(permutation[x] for x in arc)) for permutation in permutations
        }
        stabilizer = len(matrices) // len(images)
        common = (1 << len(off)) - 1
        for vertex in arc:
            common &= neighbors[vertex]
        extensions = []
        while common:
            bit = common & -common
            common ^= bit
            vertex = bit.bit_length() - 1
            if all(
                dot(cross(off[arc[i]], off[arc[j]], q), off[vertex], q) != 0
                for i in range(6)
                for j in range(i + 1, 6)
            ):
                extensions.append(vertex)
        if extensions:
            raise AssertionError("six-arc unexpectedly extends")

        pair_signature = [0] * len(roots)
        for i in range(6):
            for j in range(i + 1, 6):
                pair_signature[edge_orbit[edge_key(arc[i], arc[j])]] += 1
        point_types = [0, 0]
        for vertex in arc:
            x, y, z = off[vertex]
            value = (x * z - y * y) % q
            point_types[0 if pow(value, (q - 1) // 2, q) == 1 else 1] += 1
        triple_signature = [0] * len(triple_types)
        for triple in itertools.combinations(arc, 3):
            triple_signature[triple_type_index[canonical_triple(triple)]] += 1
        orbit_records.append(
            {
                "representative": [list(off[vertex]) for vertex in arc],
                "stabilizer_order": stabilizer,
                "orbit_size": len(images),
                "point_type_counts_square_nonsquare": point_types,
                "passant_pair_orbit_signature": pair_signature,
                "triple_orbit_signature": [
                    [i, count] for i, count in enumerate(triple_signature) if count
                ],
                "valid_extensions": 0,
            }
        )

    signature_counts: dict[tuple[int, ...], int] = {}
    for record in orbit_records:
        signature = tuple(record["passant_pair_orbit_signature"])  # type: ignore[arg-type]
        signature_counts[signature] = signature_counts.get(signature, 0) + 1
    triple_signature_counts: dict[tuple[tuple[int, int], ...], int] = {}
    for record in orbit_records:
        signature = tuple(
            tuple(entry) for entry in record["triple_orbit_signature"]  # type: ignore[union-attr]
        )
        triple_signature_counts[signature] = triple_signature_counts.get(signature, 0) + 1
    pair_fibres: dict[tuple[int, ...], list[int]] = {}
    for i, record in enumerate(orbit_records):
        signature = tuple(record["passant_pair_orbit_signature"])  # type: ignore[arg-type]
        pair_fibres.setdefault(signature, []).append(i)
    pair_collisions = []
    for indices in pair_fibres.values():
        if len(indices) == 1:
            continue
        sparse = [
            dict(orbit_records[i]["triple_orbit_signature"])  # type: ignore[arg-type]
            for i in indices
        ]
        separator = next(
            triple_type
            for triple_type in range(len(triple_types))
            if len({signature.get(triple_type, 0) for signature in sparse}) > 1
        )
        pair_collisions.append(
            {
                "orbit_indices": indices,
                "first_triple_separator": separator,
                "separator_counts": [
                    signature.get(separator, 0) for signature in sparse
                ],
            }
        )

    rational_records = []
    for root, old_record in zip(roots, old["roots"]):
        candidates = [
            vertex
            for vertex in range(len(off))
            if vertex not in root
            and passant(off[root[0]], off[vertex], q)
            and passant(off[root[1]], off[vertex], q)
            and dot(cross(off[root[0]], off[root[1]], q), off[vertex], q) != 0
        ]
        max_one_root = 0
        max_zero_root = 0
        for line in all_points:
            root_count = sum(dot(line, off[vertex], q) == 0 for vertex in root)
            candidate_count = sum(dot(line, off[vertex], q) == 0 for vertex in candidates)
            if root_count == 1:
                max_one_root = max(max_one_root, candidate_count)
            elif root_count == 0:
                max_zero_root = max(max_zero_root, candidate_count)
        denominator = max(2, max_one_root, (max_zero_root + 1) // 2)
        weight = Fraction(1, denominator)

        for line in all_points:
            root_count = sum(dot(line, off[vertex], q) == 0 for vertex in root)
            candidate_count = sum(dot(line, off[vertex], q) == 0 for vertex in candidates)
            if candidate_count * weight > 2 - root_count:
                raise AssertionError("uniform point weight violates a line constraint")
        if 2 * weight > 1:
            raise AssertionError("uniform point weight violates a forbidden-pair constraint")

        objective = len(candidates) * weight
        rational_records.append(
            {
                "root": old_record["representative"],
                "candidate_points": len(candidates),
                "max_candidates_on_line_through_one_root": max_one_root,
                "max_candidates_on_line_through_no_root": max_zero_root,
                "uniform_weight": [weight.numerator, weight.denominator],
                "feasible_objective": [objective.numerator, objective.denominator],
            }
        )
    rational_shapes = Counter(
        (
            record["candidate_points"],
            record["max_candidates_on_line_through_one_root"],
            record["max_candidates_on_line_through_no_root"],
            tuple(record["uniform_weight"]),
            tuple(record["feasible_objective"]),
        )
        for record in rational_records
    )

    passant_line = next(
        line for line in all_points if all(dot(line, point, q) != 0 for point in conic)
    )
    line_points = [point for point in all_points if dot(passant_line, point, q) == 0]
    if len(line_points) != q + 1 or any(point in conic for point in line_points):
        raise AssertionError("passant-line witness is malformed")
    if any(
        not passant(line_points[i], line_points[j], q)
        for i in range(q + 1)
        for j in range(i + 1, q + 1)
    ):
        raise AssertionError("passant-line points are not a pairwise-passant clique")

    return {
        "q": q,
        "input": {
            "path": str(input_path.relative_to(ROOT)),
            "bytes": input_path.stat().st_size,
            "sha256": sha256(input_path),
        },
        "off_conic_points": len(off),
        "passant_edges": len(passant_edges),
        "edge_orbits": len(roots),
        "rooted_six_arcs_encountered": len(raw_rooted),
        "six_arc_orbits": len(orbit_records),
        "total_labelled_six_arcs": sum(record["orbit_size"] for record in orbit_records),
        "distinct_pair_signatures": len(signature_counts),
        "largest_pair_signature_fibre": max(signature_counts.values()),
        "pair_signature_collisions": pair_collisions,
        "triple_orbit_types": [
            [list(off[vertex]) for vertex in triple] for triple in triple_types
        ],
        "distinct_triple_signatures": len(triple_signature_counts),
        "largest_triple_signature_fibre": max(triple_signature_counts.values()),
        "stabilizer_distribution": {
            str(order): count
            for order, count in sorted(
                Counter(record["stabilizer_order"] for record in orbit_records).items()
            )
        },
        "orbits": orbit_records,
        "rational_root_lp_obstructions": rational_records,
        "rational_root_lp_shapes": [
            {
                "candidate_points": shape[0],
                "max_candidates_on_line_through_one_root": shape[1],
                "max_candidates_on_line_through_no_root": shape[2],
                "uniform_weight": list(shape[3]),
                "feasible_objective": list(shape[4]),
                "root_orbits": count,
            }
            for shape, count in sorted(rational_shapes.items())
        ],
        "pair_coherent_obstruction": {
            "passant_line": list(passant_line),
            "pairwise_passant_clique_size": len(line_points),
            "arc_size_on_that_line": 2,
        },
    }


def generate() -> dict[str, object]:
    return {
        "schema": "c611-q17-q19-coherent-certificates-v1",
        "fields": [field_certificate(q) for q in (17, 19)],
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(generate())
    if args.check:
        if args.output.read_bytes() != payload:
            raise SystemExit(f"stale certificate: {args.output}")
        print(f"OK {args.output}")
    else:
        args.output.write_bytes(payload)
        print(f"wrote {args.output}")


if __name__ == "__main__":
    main()
