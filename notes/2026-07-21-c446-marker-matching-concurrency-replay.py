#!/usr/bin/env python3
"""Independent exhaustive replay of C446's matching-concurrency verdict."""

from __future__ import annotations

import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FROZEN = HERE / "2026-07-20-c406-matching-orbit-scout.json"
CERTIFICATE = HERE / "2026-07-21-c446-marker-matching-concurrency.json"


def normalize(vector, prime):
    vector = tuple(value % prime for value in vector)
    scale = pow(next(value for value in vector if value), -1, prime)
    return tuple(scale * value % prime for value in vector)


def matchings(vertices):
    if not vertices:
        yield ()
        return
    first = vertices[0]
    for index in range(1, len(vertices)):
        second = vertices[index]
        rest = vertices[1:index] + vertices[index + 1 :]
        for tail in matchings(rest):
            yield ((first, second),) + tail


def line(p, q, prime):
    return normalize(
        (
            p[1] * q[2] - p[2] * q[1],
            p[2] * q[0] - p[0] * q[2],
            p[0] * q[1] - p[1] * q[0],
        ),
        prime,
    )


def det(rows, prime):
    a, b, c = rows[0]
    d, e, f = rows[1]
    g, h, i = rows[2]
    return (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)) % prime


def intersection(left, right, prime):
    return normalize(
        (
            left[1] * right[2] - left[2] * right[1],
            left[2] * right[0] - left[0] * right[2],
            left[0] * right[1] - left[1] * right[0],
        ),
        prime,
    )


def is_concurrent(matching, conic, prime):
    lines = [line(conic[a], conic[b], prime) for a, b in matching]
    point = intersection(lines[0], lines[1], prime)
    return all(sum(a * b for a, b in zip(secant, point)) % prime == 0 for secant in lines)


def pgl_orbit(base, endpoints, prime):
    index = {point: i for i, point in enumerate(endpoints)}
    orbit = set()
    seen_actions = set()
    for a, b, c, d in itertools.product(range(prime), repeat=4):
        if (a * d - b * c) % prime == 0:
            continue
        action = tuple(
            index[normalize((a * s + b * t, c * s + d * t), prime)] for s, t in endpoints
        )
        if action in seen_actions:
            continue
        seen_actions.add(action)
        orbit.add(tuple(sorted(tuple(sorted((action[x], action[y]))) for x, y in base)))
    assert len(seen_actions) == prime * (prime * prime - 1)
    return orbit


def main():
    frozen = json.loads(FROZEN.read_text())
    certificate = json.loads(CERTIFICATE.read_text())
    replay = []
    for item in frozen["types"]:
        prime = item["field_order"]
        conic = tuple(tuple(point) for point in item["conic_points"])
        endpoints = tuple(tuple(point) for point in item["p1_endpoints"])
        base = tuple(tuple(edge) for edge in item["coxeter_invariant_matching"])
        target = pgl_orbit(base, endpoints, prime)
        all_matchings = tuple(matchings(tuple(range(prime + 1))))
        concurrent = {matching for matching in all_matchings if is_concurrent(matching, conic, prime)}
        # A point with no tangent through it lies on (q+1)/2 secants, hence
        # determines one concurrent perfect matching.  There are q(q-1)/2
        # such points (often called interior points of the conic).
        expected_secant_pencil_points = prime * (prime - 1) // 2
        assert len(concurrent) == expected_secant_pencil_points
        assert target.isdisjoint(concurrent)
        replay.append((item["type"], len(all_matchings), len(concurrent), len(target & concurrent)))

    assert replay == [("A3", 15, 10, 0), ("B3", 105, 21, 0), ("H3", 10395, 55, 0)]
    assert certificate["summary"]["matching_records_checked"] == 41
    assert certificate["summary"]["concurrent_records"] == 0
    print("C446 independent replay OK: A3 0/5, B3 0/14, H3 0/22 concurrent")


if __name__ == "__main__":
    main()
