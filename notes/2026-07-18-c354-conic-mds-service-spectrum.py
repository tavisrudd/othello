#!/usr/bin/env python3
"""Exact small-field census for C354's conic-MDS service spectrum.

The only floating-point operation is discovery of projected vertices.  Every
reported vertex is then certified by a rational allocation, and every reported
upper facet by a rational fractional vertex cover.  These two certificate
families prove equality with the projected fractional-matching polytope.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import tempfile
from collections import Counter, defaultdict
from fractions import Fraction
from itertools import combinations, permutations, product
from pathlib import Path


STEM = "2026-07-18-c354-conic-mds-service-spectrum"
SCHEMA = "c354-conic-mds-service-spectrum-v1"
Point = tuple[int, int, int]
Frame = tuple[Point, Point, Point]


class FiniteField:
    """Deterministic polynomial-basis fields for q=5,7,9,11."""

    def __init__(self, q: int) -> None:
        if q == 9:
            self.p, self.degree = 3, 2
        else:
            self.p, self.degree = q, 1
        assert self.p**self.degree == q and self.p in (3, 5, 7, 11)
        self.q = q
        self.modulus = () if self.degree == 1 else (1, 0)  # x^2 + 1 over F_3

    def coefficients(self, value: int) -> tuple[int, ...]:
        answer = []
        for _ in range(self.degree):
            answer.append(value % self.p)
            value //= self.p
        return tuple(answer)

    def encode(self, coefficients: list[int] | tuple[int, ...]) -> int:
        answer = 0
        place = 1
        for coefficient in coefficients:
            answer += (coefficient % self.p) * place
            place *= self.p
        return answer

    def add(self, left: int, right: int) -> int:
        return self.encode([a + b for a, b in zip(self.coefficients(left), self.coefficients(right))])

    def neg(self, value: int) -> int:
        return self.encode([-a for a in self.coefficients(value)])

    def sub(self, left: int, right: int) -> int:
        return self.add(left, self.neg(right))

    def mul(self, left: int, right: int) -> int:
        if self.degree == 1:
            return left * right % self.p
        a = self.coefficients(left)
        b = self.coefficients(right)
        coefficients = [0] * 3
        for i in range(2):
            for j in range(2):
                coefficients[i + j] = (coefficients[i + j] + a[i] * b[j]) % self.p
        leading = coefficients[2]
        coefficients[0] -= leading * self.modulus[0]
        coefficients[1] -= leading * self.modulus[1]
        return self.encode(coefficients[:2])

    def pow(self, value: int, exponent: int) -> int:
        answer = 1
        while exponent:
            if exponent & 1:
                answer = self.mul(answer, value)
            value = self.mul(value, value)
            exponent >>= 1
        return answer

    def inverse(self, value: int) -> int:
        assert value
        return self.pow(value, self.q - 2)

    def character(self, value: int) -> int:
        if value == 0:
            return 0
        result = self.pow(value, (self.q - 1) // 2)
        return 1 if result == 1 else -1


def normalize(field: FiniteField, vector: tuple[int, ...]) -> tuple[int, ...]:
    scale = field.inverse(next(entry for entry in vector if entry))
    return tuple(field.mul(scale, entry) for entry in vector)


def det3(field: FiniteField, a: Point, b: Point, c: Point) -> int:
    positive = field.add(
        field.add(field.mul(a[0], field.mul(b[1], c[2])), field.mul(a[1], field.mul(b[2], c[0]))),
        field.mul(a[2], field.mul(b[0], c[1])),
    )
    negative = field.add(
        field.add(field.mul(a[2], field.mul(b[1], c[0])), field.mul(a[1], field.mul(b[0], c[2]))),
        field.mul(a[0], field.mul(b[2], c[1])),
    )
    return field.sub(positive, negative)


def projective_points(field: FiniteField) -> tuple[Point, ...]:
    return tuple(
        sorted(
            {
                normalize(field, vector)
                for vector in product(range(field.q), repeat=3)
                if any(vector)
            }
        )
    )


def conic(field: FiniteField) -> tuple[Point, ...]:
    points = [(field.mul(t, t), t, 1) for t in range(field.q)]
    points.append((1, 0, 0))
    return tuple(sorted(points))


def point_type(field: FiniteField, point: Point) -> str:
    x, y, z = point
    discriminant = field.sub(field.mul(y, y), field.mul(x, z))
    return {0: "O", 1: "E", -1: "I"}[field.character(discriminant)]


def conic_group(field: FiniteField) -> tuple[tuple[int, ...], ...]:
    """The symmetric-square copy of PGL(2,q), normalized projectively."""
    two = 2 % field.p
    matrices = set()
    for a, b, c, d in product(range(field.q), repeat=4):
        determinant = field.sub(field.mul(a, d), field.mul(b, c))
        if not determinant:
            continue
        base = normalize(field, (a, b, c, d))
        a0, b0, c0, d0 = base
        matrices.add(
            (
                field.mul(a0, a0), field.mul(two, field.mul(a0, b0)), field.mul(b0, b0),
                field.mul(a0, c0), field.add(field.mul(a0, d0), field.mul(b0, c0)), field.mul(b0, d0),
                field.mul(c0, c0), field.mul(two, field.mul(c0, d0)), field.mul(d0, d0),
            )
        )
    answer = tuple(sorted(matrices))
    assert len(answer) == field.q * (field.q**2 - 1)
    return answer


def act(field: FiniteField, matrix: tuple[int, ...], point: Point) -> Point:
    entries = []
    for row in range(3):
        value = 0
        for column in range(3):
            value = field.add(value, field.mul(matrix[3 * row + column], point[column]))
        entries.append(value)
    return normalize(field, tuple(entries))  # type: ignore[return-value]


def frame_orbits(field: FiniteField) -> tuple[dict[str, object], ...]:
    points = projective_points(field)
    group = conic_group(field)
    frames = {
        tuple(sorted(frame))
        for frame in combinations(points, 3)
        if det3(field, *frame)
    }
    expected = len(points) * (len(points) - 1) * field.q**2 // 6
    assert len(frames) == expected
    orbits = []
    while frames:
        seed = min(frames)
        orbit = {
            tuple(sorted(act(field, matrix, point) for point in seed))
            for matrix in group
        }
        representative = min(orbit)
        frames.difference_update(orbit)
        orbits.append(
            {
                "representative": representative,
                "orbit_size": len(orbit),
                "stabilizer_order": len(group) // len(orbit),
                "type": "".join(sorted(point_type(field, point) for point in representative)),
            }
        )
    return tuple(sorted(orbits, key=lambda item: item["representative"]))


def recovery_edges(field: FiniteField, frame: Frame) -> tuple[tuple[int, int], ...]:
    servers = conic(field)
    edges = []
    for color, target in enumerate(frame):
        singles = []
        pairs = []
        for index, server in enumerate(servers):
            if server == target:
                singles.append(1 << index)
        for left, right in combinations(range(len(servers)), 2):
            if det3(field, target, servers[left], servers[right]) == 0:
                pairs.append((1 << left) | (1 << right))
        minimal = set(singles)
        if not singles:
            minimal.update(pairs)
        forbidden = set(singles) | set(pairs)
        for triple in combinations(range(len(servers)), 3):
            mask = sum(1 << index for index in triple)
            if not any(edge & mask == edge for edge in forbidden):
                minimal.add(mask)
        edges.extend((color, mask) for mask in sorted(minimal))
    return tuple(edges)


def direct_recovery_edges(field: FiniteField, frame: Frame) -> tuple[tuple[int, int], ...]:
    """Independent subset-by-subset definition of all minimal recovery sets."""
    servers = conic(field)
    answer = []

    def recovers(target: Point, subset: tuple[int, ...]) -> bool:
        if len(subset) == 1:
            return servers[subset[0]] == target
        if len(subset) == 2:
            return det3(field, target, servers[subset[0]], servers[subset[1]]) == 0
        assert len(subset) == 3
        return det3(field, servers[subset[0]], servers[subset[1]], servers[subset[2]]) != 0

    for color, target in enumerate(frame):
        for size in (1, 2, 3):
            for subset in combinations(range(len(servers)), size):
                if not recovers(target, subset):
                    continue
                if any(recovers(target, proper) for proper_size in range(1, size) for proper in combinations(subset, proper_size)):
                    continue
                answer.append((color, sum(1 << index for index in subset)))
    return tuple(sorted(answer))


def rational(value: float, denominator: int = 1_000_000) -> Fraction:
    if abs(value) < 1e-9:
        return Fraction(0)
    return Fraction(float(value)).limit_denominator(denominator)


def fraction_text(value: Fraction) -> str:
    return str(value.numerator) if value.denominator == 1 else f"{value.numerator}/{value.denominator}"


def normalize_inequality(values: tuple[Fraction, Fraction, Fraction, Fraction]) -> tuple[int, int, int, int]:
    denominator = math.lcm(*(value.denominator for value in values))
    integers = [value.numerator * (denominator // value.denominator) for value in values]
    divisor = math.gcd(*map(abs, integers))
    integers = [value // divisor for value in integers]
    return tuple(integers)  # type: ignore[return-value]


def exact_facets(vertices: tuple[tuple[Fraction, Fraction, Fraction], ...]) -> tuple[tuple[int, int, int, int], ...]:
    facets = set()
    for first, second, third in combinations(vertices, 3):
        u = tuple(second[i] - first[i] for i in range(3))
        v = tuple(third[i] - first[i] for i in range(3))
        normal = (
            u[1] * v[2] - u[2] * v[1],
            u[2] * v[0] - u[0] * v[2],
            u[0] * v[1] - u[1] * v[0],
        )
        if not any(normal):
            continue
        bound = sum(normal[i] * first[i] for i in range(3))
        slacks = [bound - sum(normal[i] * point[i] for i in range(3)) for point in vertices]
        if all(slack >= 0 for slack in slacks):
            pass
        elif all(slack <= 0 for slack in slacks):
            normal = tuple(-entry for entry in normal)
            bound = -bound
            slacks = [-slack for slack in slacks]
        else:
            continue
        incident = [vertices[index] for index, slack in enumerate(slacks) if slack == 0]
        if len(incident) < 3:
            continue
        facets.add(normalize_inequality((*normal, bound)))
    return tuple(sorted(facets))


def canonical_facet_signature(
    facets: tuple[tuple[int, int, int, int], ...]
) -> tuple[str, tuple[int, int, int]]:
    candidates = []
    for permutation in permutations(range(3)):
        permuted = tuple(
            sorted((facet[permutation[0]], facet[permutation[1]], facet[permutation[2]], facet[3]) for facet in facets)
        )
        signature = ";".join(",".join(map(str, facet)) for facet in permuted)
        candidates.append((signature, permutation))
    return min(candidates)


def project_region(field: FiniteField, frame: Frame) -> dict[str, object]:
    try:
        import numpy as np
        from scipy.optimize import linprog
        from scipy.spatial import ConvexHull
    except ImportError as exc:
        raise SystemExit(
            "run through: nix-shell -p 'python3.withPackages (ps: [ ps.scipy ])' --run \"python3 ...\""
        ) from exc

    edges = recovery_edges(field, frame)
    assert edges == direct_recovery_edges(field, frame)
    server_count = field.q + 1
    edge_count = len(edges)
    incidence = np.zeros((server_count, edge_count))
    for column, (_, mask) in enumerate(edges):
        for server in range(server_count):
            incidence[server, column] = bool(mask & (1 << server))

    allocations: dict[tuple[Fraction, Fraction, Fraction], tuple[Fraction, ...]] = {}

    def support(direction: tuple[float, float, float]) -> tuple[Fraction, Fraction, Fraction]:
        objective = np.array([-direction[color] for color, _ in edges])
        result = linprog(objective, A_ub=incidence, b_ub=np.ones(server_count), bounds=(0, None), method="highs")
        assert result.success, result.message
        allocation = tuple(rational(value) for value in result.x)
        loads = [sum(allocation[column] for column in range(edge_count) if incidence[server, column]) for server in range(server_count)]
        assert all(load <= 1 for load in loads)
        point = tuple(sum(allocation[column] for column, (color, _) in enumerate(edges) if color == target) for target in range(3))
        allocations[point] = allocation
        return point  # type: ignore[return-value]

    points: set[tuple[Fraction, Fraction, Fraction]] = set()

    def add_downward_closure(
        point: tuple[Fraction, Fraction, Fraction], allocation: tuple[Fraction, ...]
    ) -> set[tuple[Fraction, Fraction, Fraction]]:
        additions = set()
        for keep in product((False, True), repeat=3):
            projected = tuple(point[color] if keep[color] else Fraction(0) for color in range(3))
            projected_allocation = tuple(
                value if keep[color] else Fraction(0)
                for value, (color, _) in zip(allocation, edges)
            )
            allocations[projected] = projected_allocation
            additions.add(projected)  # type: ignore[arg-type]
        return additions

    zero = (Fraction(0), Fraction(0), Fraction(0))
    zero_allocation = tuple(Fraction(0) for _ in edges)
    points.update(add_downward_closure(zero, zero_allocation))
    for direction in ((1.0, 0.0, 0.0), (0.0, 1.0, 0.0), (0.0, 0.0, 1.0), (1.0, 1.0, 1.0)):
        point = support(direction)
        points.update(add_downward_closure(point, allocations[point]))

    for _ in range(200):
        numeric = np.array([[float(value) for value in point] for point in sorted(points)])
        hull = ConvexHull(numeric)
        additions = set()
        for normal0, normal1, normal2, offset in hull.equations:
            normal = (normal0, normal1, normal2)
            if min(normal) < -1e-7:
                continue
            candidate = support(normal)
            current = max(sum(normal[i] * float(point[i]) for i in range(3)) for point in points)
            achieved = sum(normal[i] * float(candidate[i]) for i in range(3))
            if achieved > current + 1e-7:
                additions.update(add_downward_closure(candidate, allocations[candidate]))
        if not additions:
            break
        points.update(additions)
    else:
        raise AssertionError("projection refinement did not terminate")

    numeric = np.array([[float(value) for value in point] for point in sorted(points)])
    hull = ConvexHull(numeric)
    vertices = tuple(sorted(tuple(sorted(points)[index]) for index in hull.vertices))
    facets = exact_facets(vertices)

    upper_facets = [facet for facet in facets if min(facet[:3]) >= 0]
    duals = {}
    for facet in upper_facets:
        coefficients = facet[:3]
        bound = facet[3]
        dual_matrix = np.zeros((edge_count, server_count))
        for row, (_, mask) in enumerate(edges):
            for server in range(server_count):
                dual_matrix[row, server] = -bool(mask & (1 << server))
        right = np.array([-coefficients[color] for color, _ in edges])
        result = linprog(np.ones(server_count), A_ub=dual_matrix, b_ub=right, bounds=(0, None), method="highs")
        assert result.success, result.message
        cover = tuple(rational(value) for value in result.x)
        assert sum(cover) == bound, (facet, cover, sum(cover))
        for color, mask in edges:
            assert sum(cover[server] for server in range(server_count) if mask & (1 << server)) >= coefficients[color]
        duals[facet] = cover

    for vertex in vertices:
        allocation = allocations[vertex]
        loads = [sum(allocation[column] for column, (_, mask) in enumerate(edges) if mask & (1 << server)) for server in range(server_count)]
        assert all(load <= 1 for load in loads)

    signature, coordinate_permutation = canonical_facet_signature(facets)
    certificate = {
        "canonical_coordinate_permutation": coordinate_permutation,
        "edge_count": edge_count,
        "facets": [list(facet) for facet in facets],
        "vertices": [[fraction_text(value) for value in vertex] for vertex in vertices],
        "primal_allocations": [
            [[index, fraction_text(value)] for index, value in enumerate(allocations[vertex]) if value]
            for vertex in vertices
        ],
        "dual_covers": {
            ",".join(map(str, facet)): [fraction_text(value) for value in duals[facet]]
            for facet in upper_facets
        },
    }
    return {"signature": signature, "certificate": certificate}


def census(fields: tuple[int, ...]) -> dict[str, object]:
    output: dict[str, object] = {"schema": SCHEMA, "fields": {}}
    for q in fields:
        field = FiniteField(q)
        orbits = frame_orbits(field)
        spectra: dict[str, dict[str, object]] = {}
        orbit_rows = []
        for orbit_index, orbit in enumerate(orbits):
            frame = orbit["representative"]
            assert isinstance(frame, tuple)
            region = project_region(field, frame)
            signature = region["signature"]
            assert isinstance(signature, str)
            if signature not in spectra:
                spectra[signature] = {
                    "certificate": region["certificate"],
                    "certificate_frame": frame,
                    "orbit_count": 0,
                    "frame_count": 0,
                    "types": Counter(),
                }
            record = spectra[signature]
            record["orbit_count"] = int(record["orbit_count"]) + 1
            record["frame_count"] = int(record["frame_count"]) + int(orbit["orbit_size"])
            types = record["types"]
            assert isinstance(types, Counter)
            types[str(orbit["type"])] += 1
            orbit_rows.append(
                {
                    "index": orbit_index,
                    "representative": frame,
                    "type": orbit["type"],
                    "orbit_size": orbit["orbit_size"],
                    "stabilizer_order": orbit["stabilizer_order"],
                    "region": signature,
                }
            )
        spectrum_rows = []
        for index, (signature, record) in enumerate(sorted(spectra.items())):
            types = record.pop("types")
            assert isinstance(types, Counter)
            record["types"] = dict(sorted(types.items()))
            record["index"] = index
            record["signature"] = signature
            spectrum_rows.append(record)
        signature_index = {row["signature"]: row["index"] for row in spectrum_rows}
        for row in orbit_rows:
            row["region"] = signature_index[row["region"]]
        output["fields"][str(q)] = {
            "point_count": q * q + q + 1,
            "frame_count": sum(int(orbit["orbit_size"]) for orbit in orbits),
            "orbit_count": len(orbits),
            "spectrum_count": len(spectrum_rows),
            "spectra": spectrum_rows,
            "orbits": orbit_rows,
        }
    return output


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--fields", nargs="+", type=int, default=[5, 7, 9, 11])
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    fields = tuple(args.fields)
    assert all(q in (5, 7, 9, 11) for q in fields)
    result = census(fields)
    payload = canonical_bytes(result)
    if args.check:
        tracked = Path(__file__).with_suffix(".json")
        assert fields == (5, 7, 9, 11), "--check uses the complete field set"
        assert tracked.read_bytes() == payload
        print(f"CHECKED {tracked.name} {len(payload)} bytes sha256={hashlib.sha256(payload).hexdigest()}")
    elif args.output:
        args.output.write_bytes(payload)
        print(f"WROTE {args.output} {len(payload)} bytes sha256={hashlib.sha256(payload).hexdigest()}")
    else:
        print(payload.decode(), end="")


if __name__ == "__main__":
    main()
