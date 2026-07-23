#!/usr/bin/env python3
"""Independent point-scanning replay for the C419 F_7 certificate."""

from __future__ import annotations

import hashlib
import json
from collections import Counter, defaultdict
from itertools import combinations, product
from pathlib import Path

Q = 7
Vector = tuple[int, int, int]
CERT = Path(__file__).with_name(
    "2026-07-20-c418-c419-c410-successors-c419.json"
)


def normalize(v: Vector) -> Vector:
    for value in v:
        if value % Q:
            inverse = pow(value, -1, Q)
            return tuple((inverse * x) % Q for x in v)  # type: ignore[return-value]
    raise ValueError("zero vector")


def projective_objects() -> tuple[Vector, ...]:
    return tuple(
        sorted(
            {
                normalize(v)
                for v in product(range(Q), repeat=3)
                if any(value % Q for value in v)
            }
        )
    )


def dot(a: Vector, b: Vector) -> int:
    return sum(x * y for x, y in zip(a, b)) % Q


def cross_raw(a: Vector, b: Vector) -> Vector:
    return normalize(
        (
            a[1] * b[2] - a[2] * b[1],
            a[2] * b[0] - a[0] * b[2],
            a[0] * b[1] - a[1] * b[0],
        )
    )


def determinant(a: Vector, b: Vector, c: Vector) -> int:
    return dot(a, cross_raw(b, c))


def circuits(configuration: tuple[Vector, ...]) -> tuple[tuple[int, int, int], ...]:
    return tuple(
        triple
        for triple in combinations(range(len(configuration)), 3)
        if determinant(*(configuration[i] for i in triple)) == 0
    )


POINTS = projective_objects()
LINES = projective_objects()
INCIDENT_LINES = {
    point: tuple(line for line in LINES if dot(line, point) == 0) for point in POINTS
}


def external_lines(configuration: tuple[Vector, ...]) -> tuple[Vector, ...]:
    return tuple(
        line
        for line in LINES
        if all(dot(line, point) != 0 for point in configuration)
    )


def scan_multiplicities(lines: tuple[Vector, ...]) -> dict[Vector, tuple[Vector, ...]]:
    return {
        point: incident
        for point in POINTS
        if len(
            incident := tuple(line for line in lines if dot(line, point) == 0)
        )
        >= 2
    }


def characteristic(lines: tuple[Vector, ...]) -> list[int]:
    blocks = scan_multiplicities(lines)
    singular_sum = sum(len(incident) - 1 for incident in blocks.values())
    return [len(lines) - 1 - singular_sum, singular_sum, -len(lines), 1]


def weighted_adjoint(lines: tuple[Vector, ...]) -> dict[str, object]:
    singular = scan_multiplicities(lines)
    adjoint = tuple(singular)
    weights = tuple(len(singular[point]) - 1 for point in adjoint)
    adjoint_blocks = {
        point: indices
        for point in POINTS
        if len(
            indices := tuple(
                i for i, line in enumerate(adjoint) if dot(line, point) == 0
            )
        )
        >= 2
    }
    incident_counts = [0] * len(adjoint)
    for indices in adjoint_blocks.values():
        for i in indices:
            incident_counts[i] += 1
    coeffs: dict[int, list[int]] = {
        0: [
            1,
            1 - len(adjoint),
            1 - len(adjoint)
            + sum(len(indices) - 1 for indices in adjoint_blocks.values()),
        ]
    }
    for i, weight in enumerate(weights):
        coeffs.setdefault(weight, [0, 0, 0])
        coeffs[weight][1] += 1
        coeffs[weight][2] += 1 - incident_counts[i]
    correction = Counter()
    for indices in adjoint_blocks.values():
        depth = sum(weights[i] for i in indices)
        correction[depth] += 1
        coeffs.setdefault(depth, [0, 0, 0])
        coeffs[depth][2] += 1
    direct = Counter(
        sum(weight for line, weight in zip(adjoint, weights) if dot(line, point) == 0)
        for point in POINTS
    )
    evaluated = Counter(
        {
            depth: Q * Q * poly[0] + Q * poly[1] + poly[2]
            for depth, poly in coeffs.items()
        }
    )
    if direct != evaluated:
        raise AssertionError("point scan and universal polynomial disagree")
    return {
        "adjoint_line_count": len(adjoint),
        "indexed_copy_count": sum(weights),
        "projective_depth_count_polynomials_q2_q_1": {
            str(depth): poly for depth, poly in sorted(coeffs.items()) if any(poly)
        },
        "cross_incidence_correction_by_depth": {
            str(depth): count for depth, count in sorted(correction.items())
        },
    }


def profiles(configuration: tuple[Vector, ...]) -> dict[str, object]:
    selected = set(configuration)
    sizes = {line: sum(dot(line, point) == 0 for point in configuration) for line in LINES}
    coordinate = []
    syndrome = []
    for point in POINTS:
        incident = INCIDENT_LINES[point]
        if point in selected:
            coordinate.append(
                (
                    sum((sizes[line] - 1) * (sizes[line] - 2) // 2 for line in incident),
                    sum((sizes[line] - 1) // 2 for line in incident),
                )
            )
        else:
            syndrome.append(
                sum(sizes[line] * (sizes[line] - 1) // 2 for line in incident)
            )
    return {
        "line_section_histogram": [
            list(item) for item in sorted(Counter(sizes.values()).items())
        ],
        "coordinate_repair_availability": [list(item) for item in sorted(coordinate)],
        "excluded_syndrome_multiplicities": sorted(syndrome),
        "excluded_syndrome_histogram": [
            list(item) for item in sorted(Counter(syndrome).items())
        ],
        "punctured_dual_weight_two_counts": sorted(
            (Q - 1) * repair for repair, _ in coordinate
        ),
    }


def canonical(value: object) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def digest(value: object) -> str:
    return hashlib.sha256(canonical(value).encode()).hexdigest()


def record(configuration: tuple[Vector, ...]) -> dict[str, object]:
    arrangement = external_lines(configuration)
    u = {
        "characteristic_polynomial_ascending": characteristic(arrangement),
        "weighted_adjoint": weighted_adjoint(arrangement),
    }
    p = profiles(configuration)
    return {
        "U": u,
        "U_digest": digest(u),
        "P": p,
        "P_digest": digest(
            {
                "coordinate": p["coordinate_repair_availability"],
                "syndrome": p["excluded_syndrome_multiplicities"],
                "puncture": p["punctured_dual_weight_two_counts"],
            }
        ),
    }


def rank(rows: list[list[int]]) -> int:
    matrix = [[value % Q for value in row] for row in rows]
    answer = 0
    for column in range(len(matrix[0]) if matrix else 0):
        pivot = next(
            (i for i in range(answer, len(matrix)) if matrix[i][column]), None
        )
        if pivot is None:
            continue
        matrix[answer], matrix[pivot] = matrix[pivot], matrix[answer]
        inverse = pow(matrix[answer][column], -1, Q)
        matrix[answer] = [(inverse * value) % Q for value in matrix[answer]]
        for i in range(len(matrix)):
            if i != answer and matrix[i][column]:
                scale = matrix[i][column]
                matrix[i] = [
                    (x - scale * y) % Q
                    for x, y in zip(matrix[i], matrix[answer])
                ]
        answer += 1
    return answer


def c430_pattern(blocks: tuple[tuple[int, ...], ...]) -> tuple[list[int], int]:
    parts = (blocks, blocks)
    centered = []
    part_rows = []
    for part in parts:
        inverse = pow(len(part), -1, Q)
        centroid = [
            sum(j in block for block in part) * inverse % Q for j in range(7)
        ]
        rows = [
            [(int(j in block) - centroid[j]) % Q for j in range(7)]
            for block in part
        ]
        centered.extend(rows)
        part_rows.append(rows)
    feature_rank = rank(centered)
    moment = [
        [sum(row[i] * row[j] for row in centered) % Q for j in range(7)]
        for i in range(7)
    ]
    return [rank(rows) for rows in part_rows], feature_rank - rank(moment)


def main() -> None:
    certificate = json.loads(CERT.read_text())
    base = (
        (1, 0, 0),
        (1, 1, 0),
        (1, 2, 0),
        (1, 0, 1),
        (1, 0, 2),
        (1, 1, 2),
    )
    secants = tuple(
        sorted({cross_raw(base[i], base[j]) for i, j in combinations(range(6), 2)})
    )
    generic = tuple(
        point for point in POINTS if all(dot(line, point) for line in secants)
    )
    expected = (
        (0, 1, 4),
        (1, 2, 1),
        (1, 3, 1),
        (1, 5, 5),
        (1, 6, 1),
    )
    if generic != expected:
        raise AssertionError("independent determinant filter changed")
    groups: dict[str, list[tuple[Vector, str]]] = defaultdict(list)
    for point in generic:
        configuration = base + (point,)
        if circuits(configuration) != ((0, 1, 2), (0, 3, 4)):
            raise AssertionError("generic circuit type changed")
        result = record(configuration)
        groups[result["U_digest"]].append((point, result["P_digest"]))
    if sorted(len(fibre) for fibre in groups.values()) != [1, 4]:
        raise AssertionError("independent U fibres changed")
    if not all(len({p_digest for _, p_digest in fibre}) == 1 for fibre in groups.values()):
        raise AssertionError("independent replay finds a P split")
    if c430_pattern(((0, 1, 2), (0, 3, 4))) != ([1, 1], 0):
        raise AssertionError("independent C430 pattern changed")
    cert_fibres = certificate["fixed_U_strata"]["fibres"]
    cert_partition = sorted(
        sorted(tuple(point) for point in fibre["points"]) for fibre in cert_fibres
    )
    replay_partition = sorted(
        sorted(point for point, _ in fibre) for fibre in groups.values()
    )
    if cert_partition != replay_partition:
        raise AssertionError("certificate and independent partitions differ")
    left = record(base + ((1, 3, 5),))
    right = record(base + ((1, 3, 6),))
    if left["U_digest"] != right["U_digest"] or left["P_digest"] == right["P_digest"]:
        raise AssertionError("independent calibration check changed")
    if circuits(base + ((1, 3, 5),)) == circuits(base + ((1, 3, 6),)):
        raise AssertionError("independent calibration incidence check changed")
    print(
        canonical(
            {
                "status": "ok",
                "method": "independent projective-point incidence scan",
                "generic_points": len(generic),
                "fixed_U_fibre_sizes": sorted(len(fibre) for fibre in groups.values()),
                "certificate_sha256": hashlib.sha256(CERT.read_bytes()).hexdigest(),
            }
        )
    )


if __name__ == "__main__":
    main()
