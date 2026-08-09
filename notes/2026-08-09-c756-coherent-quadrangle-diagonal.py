#!/usr/bin/env python3
"""Exact prime-field census of coherent C756 quadrangle diagonal types."""

from __future__ import annotations

import argparse
import collections
import importlib.util
import json
from pathlib import Path


SOURCE = Path(__file__).with_name("2026-08-08-c756-signed-elliptic-fusion.py")
OUTPUT = Path(__file__).with_suffix(".json")
PRIMES = (5, 7, 11, 13, 17, 19, 23)


def load_source():
    spec = importlib.util.spec_from_file_location("c756_signed_fusion", SOURCE)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def normalize(v, q):
    for entry in v:
        if entry % q:
            inverse = pow(entry % q, -1, q)
            return tuple(x * inverse % q for x in v)
    raise ValueError("zero projective vector")


def cross(u, v, q):
    return normalize(
        (
            u[1] * v[2] - u[2] * v[1],
            u[2] * v[0] - u[0] * v[2],
            u[0] * v[1] - u[1] * v[0],
        ),
        q,
    )


def det3(a, b, c, q):
    return sum(
        a[i]
        * (b[(i + 1) % 3] * c[(i + 2) % 3] - b[(i + 2) % 3] * c[(i + 1) % 3])
        for i in range(3)
    ) % q


def point_q(point, q):
    return (point[1] ** 2 - point[0] * point[2]) % q


def certify(q, source):
    nonsquare, roots, signed = source.matrix_for(q)
    points = [(1, a, (a * a - nonsquare * b * b) % q) for a, b in roots]
    epsilon = source.chi(-1, q)
    size = len(points)
    forward_neighbors = [
        {j for j in range(i + 1, size) if signed[i][j]}
        for i in range(size)
    ]
    histogram = collections.Counter()

    for i in range(size):
        for j in sorted(forward_neighbors[i]):
            for k in sorted(forward_neighbors[i] & forward_neighbors[j]):
                if k <= j:
                    continue
                if signed[i][j] * signed[j][k] * signed[k][i] != epsilon:
                    continue
                if det3(points[i], points[j], points[k], q) == 0:
                    continue
                common = forward_neighbors[i] & forward_neighbors[j] & forward_neighbors[k]
                for ell in sorted(common):
                    if ell <= k:
                        continue
                    if any(
                        signed[a][b] * signed[b][ell] * signed[ell][a] != epsilon
                        for a, b in ((i, j), (i, k), (j, k))
                    ):
                        continue
                    if any(
                        det3(points[a], points[b], points[ell], q) == 0
                        for a, b in ((i, j), (i, k), (j, k))
                    ):
                        continue

                    quad = [points[x] for x in (i, j, k, ell)]
                    joins = {
                        (a, b): cross(quad[a], quad[b], q)
                        for a in range(4)
                        for b in range(a + 1, 4)
                    }
                    internal_diagonals = 0
                    for first, second in (
                        ((0, 1), (2, 3)),
                        ((0, 2), (1, 3)),
                        ((0, 3), (1, 2)),
                    ):
                        diagonal = cross(joins[first], joins[second], q)
                        internal_diagonals += source.chi(point_q(diagonal, q), q) == -1
                    histogram[internal_diagonals] += 1

    total = sum(histogram.values())
    diagonal_character_sum = sum((3 - 2 * r) * count for r, count in histogram.items())
    return {
        "q": q,
        "internal_points": size,
        "coherent_quadrangles": total,
        "internal_diagonal_histogram": {str(r): count for r, count in sorted(histogram.items())},
        "diagonal_character_sum": diagonal_character_sum,
    }


def certificate():
    source = load_source()
    return {
        "schema": "c756-coherent-quadrangle-diagonal-v1",
        "dependency": "Python 3 standard library",
        "source": SOURCE.name,
        "cases": [certify(q, source) for q in PRIMES],
    }


def serialized():
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    actual = serialized()
    if args.write:
        OUTPUT.write_text(actual, encoding="utf-8")
        return
    expected = OUTPUT.read_text(encoding="utf-8")
    if actual != expected:
        raise SystemExit("certificate mismatch: regenerate with --write")
    print("ok: coherent quadrangle diagonal census reproduced")


if __name__ == "__main__":
    main()
