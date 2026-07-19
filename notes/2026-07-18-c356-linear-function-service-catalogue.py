#!/usr/bin/env python3
"""Exact q=5,7 checker for C356's internal-conic function catalogue."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


FIELDS = (5, 7)
OUTPUT = Path(__file__).with_suffix(".json")


def normalize(vector: tuple[int, ...], q: int) -> tuple[int, ...]:
    for value in vector:
        if value % q:
            scale = pow(value, -1, q)
            return tuple((scale * entry) % q for entry in vector)
    raise ValueError("zero vector has no projective normalization")


def projective_points(q: int) -> tuple[tuple[int, int, int], ...]:
    return tuple(
        sorted(
            {
                normalize(vector, q)
                for vector in itertools.product(range(q), repeat=3)
                if any(vector)
            }
        )
    )


def conic(q: int) -> tuple[tuple[int, int, int], ...]:
    return tuple((1, t, t * t % q) for t in range(q)) + ((0, 0, 1),)


def determinant(a: tuple[int, ...], b: tuple[int, ...], c: tuple[int, ...], q: int) -> int:
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % q


def coefficient_pair(
    target: tuple[int, int, int],
    left: tuple[int, int, int],
    right: tuple[int, int, int],
    q: int,
) -> tuple[int, int]:
    answers = []
    for alpha in range(q):
        for beta in range(q):
            if tuple((alpha * left[i] + beta * right[i]) % q for i in range(3)) == target:
                answers.append((alpha, beta))
    if len(answers) != 1 or 0 in answers[0]:
        raise AssertionError((target, left, right, answers))
    return answers[0]


def catalogue(q: int) -> tuple[tuple[tuple[int, int, int], tuple[tuple[int, int], ...]], ...]:
    carrier = conic(q)
    expected_pairs = (q + 1) // 2
    result = []
    for point in projective_points(q):
        if point in carrier:
            continue
        edges = tuple(
            (i, j)
            for i in range(q + 1)
            for j in range(i + 1, q + 1)
            if determinant(carrier[i], carrier[j], point, q) == 0
        )
        if len(edges) == expected_pairs:
            result.append((point, edges))
    return tuple(result)


def rainbow_assignment(
    matchings: tuple[tuple[tuple[int, int], ...], ...]
) -> tuple[tuple[int, int], ...] | None:
    order = sorted(range(len(matchings)), key=lambda i: len(matchings[i]))
    chosen: list[tuple[int, int] | None] = [None] * len(matchings)

    def visit(depth: int, used: int) -> bool:
        if depth == len(order):
            return True
        index = order[depth]
        for edge in matchings[index]:
            mask = (1 << edge[0]) | (1 << edge[1])
            if not used & mask:
                chosen[index] = edge
                if visit(depth + 1, used | mask):
                    return True
        chosen[index] = None
        return False

    return tuple(chosen) if visit(0, 0) else None


def field_certificate(q: int) -> dict[str, object]:
    carrier = conic(q)
    entries = catalogue(q)
    size = (q + 1) // 2
    assert len(entries) == q * (q - 1) // 2

    # Each matching partitions the servers. Downloading the two raw stored
    # symbols makes a server's transcript simply CONTACT or SILENT.
    for point, edges in entries:
        assert sorted(vertex for edge in edges for vertex in edge) == list(range(q + 1))
        for left, right in edges:
            alpha, beta = coefficient_pair(point, carrier[left], carrier[right], q)
            for data in itertools.product(range(q), repeat=3):
                stored_left = sum(data[i] * carrier[left][i] for i in range(3)) % q
                stored_right = sum(data[i] * carrier[right][i] for i in range(3)) % q
                wanted = sum(data[i] * point[i] for i in range(3)) % q
                assert (alpha * stored_left + beta * stored_right) % q == wanted

    concurrency_profile = []
    maximum_universal_concurrency = 0
    for request_count in range(1, size + 1):
        total_lists = 0
        failures = 0
        distinct_lists = 0
        distinct_failures = 0
        first_failure = None
        for request_indices in itertools.combinations_with_replacement(
            range(len(entries)), request_count
        ):
            total_lists += 1
            is_distinct = len(set(request_indices)) == request_count
            distinct_lists += int(is_distinct)
            assignment = rainbow_assignment(tuple(entries[index][1] for index in request_indices))
            if assignment is None:
                failures += 1
                distinct_failures += int(is_distinct)
                if first_failure is None:
                    first_failure = {
                        "request_indices": list(request_indices),
                        "requests": [list(entries[index][0]) for index in request_indices],
                    }
        if failures == 0:
            maximum_universal_concurrency = request_count
        concurrency_profile.append(
            {
                "requests": request_count,
                "multisets_checked": total_lists,
                "failures": failures,
                "distinct_request_sets_checked": distinct_lists,
                "distinct_request_failures": distinct_failures,
                "first_failure": first_failure,
            }
        )

    return {
        "q": q,
        "servers": q + 1,
        "information_dimension": 3,
        "catalogue_projective_functions": len(entries),
        "recovery_pairs_per_function": size,
        "download_symbols_per_request": 2,
        "single_server_contact_probability": f"1/{size}",
        "single_server_privacy": "exact for the uniform-pair raw-symbol protocol",
        "collusion_privacy": "not claimed",
        "maximum_universal_integral_concurrency": maximum_universal_concurrency,
        "integral_concurrency_profile": concurrency_profile,
    }


def generate() -> dict[str, object]:
    return {
        "schema": "c356-linear-function-service-catalogue-v1",
        "fields": [field_certificate(q) for q in FIELDS],
        "scope": "prime fields q=5,7; internal projective functions; pair recoveries only",
    }


def serialized(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    content = serialized(generate())
    if args.check:
        tracked = OUTPUT.read_bytes()
        if tracked != content:
            raise SystemExit("tracked JSON differs from regenerated certificate")
        print(f"OK {OUTPUT.name} sha256={hashlib.sha256(content).hexdigest()} bytes={len(content)}")
    else:
        OUTPUT.write_bytes(content)
        print(f"WROTE {OUTPUT.name} sha256={hashlib.sha256(content).hexdigest()} bytes={len(content)}")


if __name__ == "__main__":
    main()
