#!/usr/bin/env python3
"""Exact falsifier search for the C431 rank-four weighted-adjoint conjecture."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import random
from collections import Counter
from functools import lru_cache
from pathlib import Path

Q = 5
R = 4
SCHEMA = "c431-rank-four-weighted-adjoint-v1"


def inv(a: int) -> int:
    return pow(a % Q, -1, Q)


def normalize(v: tuple[int, ...]) -> tuple[int, ...]:
    for x in v:
        if x % Q:
            scale = inv(x)
            return tuple((scale * y) % Q for y in v)
    raise ValueError("zero vector has no projective normalization")


def projective_points() -> tuple[tuple[int, ...], ...]:
    return tuple(
        sorted(
            {
                normalize(v)
                for v in itertools.product(range(Q), repeat=R)
                if any(v)
            }
        )
    )


POINTS = projective_points()
BASIS = tuple(tuple(int(i == j) for i in range(R)) for j in range(R))
RESIDUAL = tuple(p for p in POINTS if p not in BASIS)
POINT_INDEX = {point: i for i, point in enumerate(POINTS)}
FULL_MASK = (1 << len(POINTS)) - 1


def dot(a: tuple[int, ...], b: tuple[int, ...]) -> int:
    return sum(x * y for x, y in zip(a, b)) % Q


INCIDENCE_MASKS = tuple(
    sum(1 << i for i, point in enumerate(POINTS) if dot(normal, point) == 0)
    for normal in POINTS
)
INCIDENCE_INDICES = tuple(
    tuple(i for i in range(len(POINTS)) if mask & (1 << i))
    for mask in INCIDENCE_MASKS
)


def rank(rows: tuple[tuple[int, ...], ...]) -> int:
    a = [list(row) for row in rows]
    pivot_row = 0
    for col in range(R):
        pivot = next((i for i in range(pivot_row, len(a)) if a[i][col] % Q), None)
        if pivot is None:
            continue
        a[pivot_row], a[pivot] = a[pivot], a[pivot_row]
        scale = inv(a[pivot_row][col])
        a[pivot_row] = [(scale * x) % Q for x in a[pivot_row]]
        for i in range(len(a)):
            if i != pivot_row and a[i][col] % Q:
                scale = a[i][col]
                a[i] = [(x - scale * y) % Q for x, y in zip(a[i], a[pivot_row])]
        pivot_row += 1
    return pivot_row


@lru_cache(maxsize=None)
def projective_line(a: tuple[int, ...], b: tuple[int, ...]) -> tuple[tuple[int, ...], ...]:
    if b < a:
        return projective_line(b, a)
    return tuple(
        sorted(
            {
                normalize(tuple((u * x + v * y) % Q for x, y in zip(a, b)))
                for u, v in itertools.product(range(Q), repeat=2)
                if u or v
            }
        )
    )


def plane_data(
    arrangement: tuple[tuple[int, ...], ...]
) -> tuple[tuple[tuple[int, ...], int, int], ...]:
    """Return (dual-plane normal, multiplicity-excess weight, |Mobius|)."""
    planes = []
    for normal in POINTS:
        contained = tuple(s for s in arrangement if dot(s, normal) == 0)
        if rank(contained) != 3:
            continue
        lines = {
            projective_line(a, b)
            for a, b in itertools.combinations(contained, 2)
            if rank((a, b)) == 2
        }
        line_excess = sum(
            max(0, sum(p in line for p in contained) - 1) for line in lines
        )
        mobius_abs = 1 - len(contained) + line_excess
        if mobius_abs <= 0:
            raise AssertionError("rank-three geometric-lattice Mobius sign failure")
        planes.append((normal, len(contained) - 1, mobius_abs))
    return tuple(planes)


def depth_spectra(
    arrangement: tuple[tuple[int, ...], ...]
) -> tuple[tuple[tuple[int, int], ...], tuple[tuple[int, int], ...]]:
    planes = plane_data(arrangement)
    multiplicity = Counter()
    mobius = Counter()
    for test in POINTS:
        if test in arrangement:
            continue
        multiplicity[
            sum(weight for normal, weight, _ in planes if dot(test, normal) == 0)
        ] += 1
        mobius[
            sum(weight for normal, _, weight in planes if dot(test, normal) == 0)
        ] += 1
    return tuple(sorted(multiplicity.items())), tuple(sorted(mobius.items()))


def code_data(
    arrangement: tuple[tuple[int, ...], ...], *, verify_direct: bool = False
) -> dict[str, object] | None:
    complement = tuple(
        point
        for point in POINTS
        if all(dot(mirror, point) != 0 for mirror in arrangement)
    )
    if rank(complement) != R:
        return None

    sections = {
        test: sum(dot(test, point) == 0 for point in complement) for test in POINTS
    }
    section_histogram = tuple(sorted(Counter(sections.values()).items()))
    projective_weights = Counter({0: 1})
    for section_size in sections.values():
        projective_weights[len(complement) - section_size] += Q - 1

    if verify_direct:
        direct_weights = Counter()
        for coefficient in itertools.product(range(Q), repeat=R):
            direct_weights[
                sum(dot(coefficient, point) != 0 for point in complement)
            ] += 1
        if projective_weights != direct_weights:
            raise AssertionError("projective and direct code enumerators disagree")

    return {
        "length": len(complement),
        "complement": [list(point) for point in complement],
        "section_histogram": [list(item) for item in section_histogram],
        "weight_enumerator": [list(item) for item in sorted(projective_weights.items())],
    }


def arrangement_record(
    arrangement: tuple[tuple[int, ...], ...], *, verify_direct: bool = False
) -> dict[str, object] | None:
    code = code_data(arrangement, verify_direct=verify_direct)
    if code is None:
        return None
    multiplicity, mobius = depth_spectra(arrangement)
    return {
        "arrangement": [list(point) for point in arrangement],
        "multiplicity_excess_depth_spectrum": [list(item) for item in multiplicity],
        "mobius_depth_spectrum": [list(item) for item in mobius],
        "code": code,
    }


def validate_rank_four_section_identity(
    arrangement: tuple[tuple[int, ...], ...]
) -> None:
    complement = tuple(
        point
        for point in POINTS
        if all(dot(mirror, point) != 0 for mirror in arrangement)
    )
    for test in POINTS:
        if test in arrangement:
            continue
        test_index = POINT_INDEX[test]
        restriction_lines = Counter(
            INCIDENCE_MASKS[POINT_INDEX[mirror]] & INCIDENCE_MASKS[test_index]
            for mirror in arrangement
        )
        distinct_lines = tuple(restriction_lines)
        concurrency = {
            point_index: sum(line & (1 << point_index) != 0 for line in distinct_lines)
            for point_index in INCIDENCE_INDICES[test_index]
        }
        excess = sum(max(0, count - 1) for count in concurrency.values())
        depth = excess + sum(
            (multiplicity - 1)
            * sum(concurrency[point_index] >= 2 for point_index in INCIDENCE_INDICES[test_index] if line & (1 << point_index))
            for line, multiplicity in restriction_lines.items()
        )
        section_size = sum(dot(test, point) == 0 for point in complement)
        predicted_section = (
            Q * Q
            + Q
            + 1
            - len(arrangement) * (Q + 1)
            + depth
            + sum(
                (multiplicity - 1)
                * (
                    Q
                    + 1
                    - sum(
                        concurrency[point_index] >= 2
                        for point_index in INCIDENCE_INDICES[test_index]
                        if line & (1 << point_index)
                    )
                )
                for line, multiplicity in restriction_lines.items()
            )
        )
        if predicted_section != section_size:
            raise AssertionError("rank-four restriction-line identity failed")


def signature(record: dict[str, object]) -> tuple[object, ...]:
    return tuple(tuple(x) for x in record["multiplicity_excess_depth_spectrum"])


def code_signature(record: dict[str, object]) -> tuple[object, ...]:
    code = record["code"]
    assert isinstance(code, dict)
    return (
        code["length"],
        tuple(tuple(x) for x in code["weight_enumerator"]),
    )


@lru_cache(maxsize=None)
def rank_mask(mask: int) -> int:
    return rank(tuple(POINTS[i] for i in range(len(POINTS)) if mask & (1 << i)))


def fast_invariants(
    arrangement_indices: tuple[int, ...]
) -> tuple[
    tuple[tuple[int, int], ...],
    tuple[object, ...],
    tuple[int, int, int, int, int] | None,
] | None:
    arrangement_mask = sum(1 << i for i in arrangement_indices)
    complement_mask = FULL_MASK
    for i in arrangement_indices:
        complement_mask &= ~INCIDENCE_MASKS[i]
    complement_mask &= FULL_MASK
    length = complement_mask.bit_count()
    sections = tuple((complement_mask & mask).bit_count() for mask in INCIDENCE_MASKS)
    if length == 0 or max(sections) == length:
        return None

    active_planes = []
    for normal_index, plane_mask in enumerate(INCIDENCE_MASKS):
        contained = arrangement_mask & plane_mask
        multiplicity = contained.bit_count()
        if multiplicity >= 3 and rank_mask(contained) == 3:
            active_planes.append((normal_index, multiplicity - 1))

    depths = [0] * len(POINTS)
    for normal_index, weight in active_planes:
        for test_index in INCIDENCE_INDICES[normal_index]:
            depths[test_index] += weight
    depth_histogram = Counter(
        depth
        for test_index, depth in enumerate(depths)
        if not arrangement_mask & (1 << test_index)
    )
    first_by_depth: dict[int, tuple[int, int]] = {}
    pointwise_conflict = None
    for test_index, (depth, section_size) in enumerate(zip(depths, sections)):
        if arrangement_mask & (1 << test_index):
            continue
        previous = first_by_depth.get(depth)
        if previous is not None and previous[1] != section_size:
            pointwise_conflict = (
                previous[0],
                test_index,
                depth,
                previous[1],
                section_size,
            )
            break
        first_by_depth.setdefault(depth, (test_index, section_size))
    section_histogram = Counter(sections)
    weight_enumerator = Counter({0: 1})
    for section_size, count in section_histogram.items():
        weight_enumerator[length - section_size] += (Q - 1) * count
    return (
        tuple(sorted(depth_histogram.items())),
        (length, tuple(sorted(weight_enumerator.items()))),
        pointwise_conflict,
    )


def search() -> dict[str, object]:
    checked_total = 0
    spanning_complement_total = 0
    per_size = []
    first_pointwise = None
    basis_indices = tuple(POINT_INDEX[point] for point in BASIS)
    residual_indices = tuple(POINT_INDEX[point] for point in RESIDUAL)
    search_batches = []
    for size in range(5, 7):
        search_batches.append(
            (
                size,
                itertools.combinations(residual_indices, size - R),
                "exhaustive lexicographic",
            )
        )
    rng = random.Random(431)
    random_size = 8
    random_target = 300_000
    random_extras = set()
    while len(random_extras) < random_target:
        random_extras.add(tuple(sorted(rng.sample(residual_indices, random_size - R))))
    search_batches.append(
        (random_size, iter(sorted(random_extras)), "seed-431 deterministic sample")
    )

    for size, extras_iterator, search_kind in search_batches:
        seen: dict[
            bytes, tuple[tuple[int, ...], tuple[object, ...], tuple[tuple[int, int], ...]]
        ] = {}
        checked_size = 0
        spanning_size = 0
        for extras in extras_iterator:
            arrangement_indices = tuple(sorted(basis_indices + extras))
            checked_total += 1
            checked_size += 1
            invariants = fast_invariants(arrangement_indices)
            if invariants is None:
                continue
            spanning_complement_total += 1
            spanning_size += 1
            key, current_code_signature, pointwise_conflict = invariants
            if pointwise_conflict is not None and first_pointwise is None:
                arrangement = tuple(POINTS[i] for i in arrangement_indices)
                record = arrangement_record(arrangement, verify_direct=True)
                assert record is not None
                first, second, depth, first_section, second_section = pointwise_conflict
                first_pointwise = {
                    "arrangement": record,
                    "pointwise_tests": [
                        {
                            "normal": list(POINTS[first]),
                            "depth": depth,
                            "section_size": first_section,
                        },
                        {
                            "normal": list(POINTS[second]),
                            "depth": depth,
                            "section_size": second_section,
                        },
                    ],
                }
            digest = hashlib.blake2b(repr(key).encode(), digest_size=16).digest()
            previous = seen.get(digest)
            if (
                previous is not None
                and previous[2] == key
                and previous[1] != current_code_signature
            ):
                previous_arrangement = tuple(POINTS[i] for i in previous[0])
                arrangement = tuple(POINTS[i] for i in arrangement_indices)
                previous = arrangement_record(
                    previous_arrangement, verify_direct=True
                )
                record = arrangement_record(arrangement, verify_direct=True)
                assert previous is not None and record is not None
                if signature(previous) != key or signature(record) != key:
                    raise AssertionError("bitset and coordinate depth spectra disagree")
                if code_signature(previous) == code_signature(record):
                    raise AssertionError("coordinate replay lost the enumerator split")
                validate_rank_four_section_identity(previous_arrangement)
                validate_rank_four_section_identity(arrangement)
                previous_enumerator = dict(previous["code"]["weight_enumerator"])
                current_enumerator = dict(record["code"]["weight_enumerator"])
                enumerator_difference = {
                    weight: current_enumerator.get(weight, 0)
                    - previous_enumerator.get(weight, 0)
                    for weight in sorted(set(previous_enumerator) | set(current_enumerator))
                    if current_enumerator.get(weight, 0)
                    != previous_enumerator.get(weight, 0)
                }
                if enumerator_difference != {
                    17: 4,
                    18: -16,
                    19: 24,
                    20: -16,
                    21: 4,
                }:
                    raise AssertionError("unexpected enumerator-difference factor")
                per_size.append(
                    {
                        "arrangement_size": size,
                        "search_kind": search_kind,
                        "normalized_arrangements_checked": checked_size,
                        "spanning_complements_checked": spanning_size,
                    }
                )
                return {
                    "schema": SCHEMA,
                    "field_order": Q,
                    "rank": R,
                    "projective_point_count": len(POINTS),
                    "normalization": {
                        "fixed_basis": [list(point) for point in BASIS],
                        "residual_points": len(RESIDUAL),
                        "search_order": search_kind,
                    },
                    "weight_conventions": {
                        "multiplicity_excess": "w(X)=number_of_mirrors_through_X-1",
                        "mobius": "w(X)=abs(mu_A(X))",
                    },
                    "stop_condition": "first searched pair sharing the punctured multiplicity-excess depth spectrum but having different code weight enumerators",
                    "search_counts": {
                        "normalized_arrangements_checked": checked_total,
                        "spanning_complements_checked": spanning_complement_total,
                        "per_completed_or_partial_size": per_size,
                    },
                    "mechanism_witness": first_pointwise,
                    "enumerator_difference": {
                        "orientation": "second witness minus first witness",
                        "coefficients": [
                            [weight, coefficient]
                            for weight, coefficient in enumerator_difference.items()
                        ],
                        "factorization": "4*z^17*(1-z)^4",
                        "vanishing_moment_orders": [0, 1, 2, 3],
                    },
                    "witnesses": [previous, record],
                }
            seen.setdefault(
                digest, (arrangement_indices, current_code_signature, key)
            )
        per_size.append(
            {
                "arrangement_size": size,
                "search_kind": search_kind,
                "normalized_arrangements_checked": checked_size,
                "spanning_complements_checked": spanning_size,
            }
        )
    raise RuntimeError("no aggregate counterexample in configured exact search batches")


def canonical_bytes(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    if bool(args.output) == bool(args.check):
        parser.error("choose exactly one of --output or --check")
    payload = search()
    generated = canonical_bytes(payload)
    path = args.output or args.check
    assert path is not None
    if args.check:
        tracked = path.read_bytes()
        if tracked != generated:
            raise SystemExit(
                f"mismatch: generated sha256={hashlib.sha256(generated).hexdigest()} "
                f"tracked sha256={hashlib.sha256(tracked).hexdigest()}"
            )
        print(
            f"OK {path} bytes={len(tracked)} sha256={hashlib.sha256(tracked).hexdigest()}"
        )
    else:
        path.write_bytes(generated)
        print(
            f"WROTE {path} bytes={len(generated)} sha256={hashlib.sha256(generated).hexdigest()}"
        )


if __name__ == "__main__":
    main()
