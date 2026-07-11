#!/usr/bin/env python3
"""Exact static two-defect boundary SG census for q=11 and q=13.

This is a read-only diagnostic: it reconstructs every character-half center on
every maximum-capacity d=4 pencil line in the committed S4 summaries, computes
the Node-Kayles SG value of the *static* game induced on the two defect lines,
and only then joins the already-recorded full-child P/N label.

Run from rust/:

    python3 scripts/r5_static_boundary_sg.py
"""

from collections import Counter, defaultdict
from functools import lru_cache
from itertools import combinations
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from c73_secant_algebra import DATA, PRIME_FILES, analyze, parse
from c74_fan_orbits import Field, normalize_pair


def norm(q, point):
    for value in point:
        if value % q:
            scale = pow(value % q, q - 2, q)
            return tuple(x * scale % q for x in point)
    raise ValueError("zero projective vector")


def cross(q, x, y):
    return norm(q, (
        x[1] * y[2] - x[2] * y[1],
        x[2] * y[0] - x[0] * y[2],
        x[0] * y[1] - x[1] * y[0],
    ))


def dot(q, x, y):
    return sum(a * b for a, b in zip(x, y)) % q


def conic(q, parameter):
    return (1, 0, 0) if parameter == q else norm(q, (parameter * parameter, parameter, 1))


def node_kayles_sg(adjacency):
    n = len(adjacency)

    @lru_cache(None)
    def sg(mask):
        options = {
            sg(mask & ~(adjacency[v] | (1 << v)))
            for v in range(n) if (mask >> v) & 1
        }
        value = 0
        while value in options:
            value += 1
        return value

    return sg((1 << n) - 1)


def static_boundary(q, parameters, center):
    selected = [
        conic(q, 0),
        *(conic(q, u) for u in parameters),
        norm(q, (-center, 0, 1)),
    ]
    assert len(selected) == 6
    assert all(dot(q, cross(q, x, y), z) for x, y, z in combinations(selected, 3))
    secants = [cross(q, x, y) for x, y in combinations(selected, 2)]

    # D_0: X=0 and D_a: X+aZ=0, including their point at infinity once.
    points = {norm(q, (0, b, 1)) for b in range(q)}
    points |= {norm(q, (-center, d, 1)) for d in range(q)}
    points.add((0, 1, 0))
    live = sorted(
        point for point in points
        if point not in selected and all(dot(q, line, point) for line in secants)
    )

    adjacency = [0] * len(live)
    for i, x in enumerate(live):
        for j in range(i + 1, len(live)):
            line = cross(q, x, live[j])
            if any(dot(q, line, point) == 0 for point in selected):
                adjacency[i] |= 1 << j
                adjacency[j] |= 1 << i
    return len(live), node_kayles_sg(adjacency)


def normalized_center(q, record, first, last, cell):
    """Invert the stored grid embedding and apply Sym^2(first,last)->(0,infinity)."""
    row, column = cell
    x = (row - record["rho"]) % q
    y = 1
    z = (column - record["A"]) * pow(record["B"], q - 2, q) % q
    if first == q:
        alpha, beta, gamma, delta = 0, 1, 1, -last
    elif last == q:
        alpha, beta, gamma, delta = 1, -first, 0, 1
    else:
        alpha, beta, gamma, delta = 1, -first, 1, -last
    xp = (alpha * alpha * x + 2 * alpha * beta * y + beta * beta * z) % q
    yp = (alpha * gamma * x + (alpha * delta + beta * gamma) * y
          + beta * delta * z) % q
    zp = (gamma * gamma * x + 2 * gamma * delta * y + delta * delta * z) % q
    assert yp == 0 and zp != 0
    return -xp * pow(zp, q - 2, q) % q


def census(q):
    field = Field(q)
    records = analyze(q, parse(os.path.join(DATA, PRIME_FILES[q])))
    geometry = Counter()
    by_class = defaultdict(Counter)
    labeled = []

    for cls, record in sorted(records.items()):
        frame = [0, q, *record["tframe"]]
        maximum = max(candidate["nlegal"] for candidate in record["cand"].values())
        for (first_raw, last), candidate in record["cand"].items():
            if candidate["nlegal"] != maximum:
                continue
            first = q if first_raw == "oo" else 0 if first_raw == "0" else first_raw
            parameters = [
                normalize_pair(field, t, first, last)
                for t in frame if t != first
            ]
            products = {
                x * y % q for i, x in enumerate(parameters) for y in parameters[i + 1:]
            }
            # This script is specifically the d=4 defect-phase census.  Per-frame
            # maximum does not imply d=4 in general; skip any other stratum.
            if len(products) != 4:
                continue

            labels = {}
            for cell, value, position in candidate["hit"]:
                if position == "on":
                    continue
                center = normalized_center(q, record, first, last, cell)
                assert center not in labels
                labels[center] = (value, position, cell)

            for center in range(1, q):
                # D_a is external precisely on this character half.
                if center in products or pow((-center) % q, (q - 1) // 2, q) != q - 1:
                    continue
                live, sg = static_boundary(q, parameters, center)
                assert center in labels
                value, _position, cell = labels[center]
                geometry[(live, sg)] += 1
                by_class[cls][sg] += 1
                labeled.append((cls, first_raw, last, center, live, sg, value, cell))

    joint = Counter((row[5], row[6]) for row in labeled)
    minimum_onp = min(record["onP"] for record in records.values())
    knife = [row for row in labeled if records[row[0]]["onP"] == minimum_onp]
    knife_joint = Counter((row[5], row[6]) for row in knife)
    print(f"q={q} d4_centers={len(labeled)} size_sg={dict(sorted(geometry.items()))}")
    print(f"q={q} class_sg={dict(sorted((c, dict(sorted(h.items()))) for c, h in by_class.items()))}")
    print(f"q={q} label_joint={dict(sorted(joint.items()))}")
    print(f"q={q} knife_n={len(knife)} knife_joint={dict(sorted(knife_joint.items()))}")


def main():
    for q in (11, 13):
        census(q)


if __name__ == "__main__":
    main()
