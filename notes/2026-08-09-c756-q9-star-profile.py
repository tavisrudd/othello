#!/usr/bin/env sage-python
"""Exact q=9 census for the C756 saturated-internal star-blocking gate."""

from __future__ import annotations

import argparse
import collections
import json
from pathlib import Path

from sage.all import GF


OUTPUT = Path(__file__).with_suffix(".json")


def normalize(v, field):
    for entry in v:
        if entry:
            inv = entry**-1
            return tuple(inv * x for x in v)
    raise ValueError("zero projective vector")


def cross(u, v, field):
    return normalize(
        (
            u[1] * v[2] - u[2] * v[1],
            u[2] * v[0] - u[0] * v[2],
            u[0] * v[1] - u[1] * v[0],
        ),
        field,
    )


def incident(line, point):
    return sum(a * x for a, x in zip(line, point)) == 0


def certificate():
    field = GF(9, name="u", modulus="primitive")
    elems = list(field)
    vectors = [(x, y, z) for x in elems for y in elems for z in elems if (x, y, z) != (0, 0, 0)]
    points = sorted(set(normalize(v, field) for v in vectors), key=str)
    lines = points
    conic = [p for p in points if p[0] * p[2] - p[1] ** 2 == 0]

    line_size = {line: sum(incident(line, p) for p in conic) for line in lines}
    line_kind = {0: "passant", 1: "tangent", 2: "secant"}
    assert collections.Counter(line_size.values()) == {0: 36, 1: 10, 2: 45}

    half = field(2) ** -1

    def polar_point(line):
        a, b, c = line
        return normalize((c, -b * half, a), field)

    def polar_line(point):
        x, y, z = point
        return normalize((z, -2 * y, x), field)

    internal = [p for p in points if line_size[polar_line(p)] == 0]
    assert len(internal) == 36

    adjacency = [set() for _ in internal]
    joins = {}
    for i, p in enumerate(internal):
        for j in range(i + 1, len(internal)):
            line = cross(p, internal[j], field)
            joins[i, j] = line
            if line_size[line] == 0:
                adjacency[i].add(j)
                adjacency[j].add(i)

    def enumerate_arcs(target):
        found = []

        def search(chosen, candidates):
            if len(chosen) == target:
                found.append(tuple(chosen))
                return
            if len(chosen) + len(candidates) < target:
                return
            while candidates:
                v = candidates.pop(0)
                # Pairwise passant does not itself forbid a third point on the same
                # passant, so impose the arc condition explicitly.
                collinear = any(
                    incident(joins[min(i, j), max(i, j)], internal[v])
                    for pos, i in enumerate(chosen)
                    for j in chosen[pos + 1 :]
                )
                if not collinear:
                    tail = [w for w in candidates if w in adjacency[v]]
                    search(chosen + [v], tail)

        search([], list(range(len(internal))))
        return found

    quadrangles = enumerate_arcs(4)
    arcs = enumerate_arcs(6)

    diagonal_type_hist = collections.Counter()
    for arc in quadrangles:
        p = [internal[i] for i in arc]
        opposite_pairs = (((0, 1), (2, 3)), ((0, 2), (1, 3)), ((0, 3), (1, 2)))
        internal_diagonals = 0
        for (i, j), (k, ell) in opposite_pairs:
            diagonal = cross(cross(p[i], p[j], field), cross(p[k], p[ell], field), field)
            internal_diagonals += line_size[polar_line(diagonal)] == 0
        diagonal_type_hist[internal_diagonals] += 1

    avoid_hist = collections.Counter()
    max_blocked = -1
    max_examples = []
    profile_hist = collections.Counter()
    for arc in arcs:
        arrangement = {polar_line(internal[i]) for i in arc}
        vertices = set()
        for pos, i in enumerate(arc):
            for j in arc[pos + 1 :]:
                chord = joins[min(i, j), max(i, j)]
                vertices.add(polar_point(chord))
        assert len(vertices) == 15
        assert all(line_size[polar_line(v)] == 0 for v in vertices)

        avoiding = [line for line in lines if not any(incident(line, v) for v in vertices)]
        avoiding_nontangent = [line for line in avoiding if line_size[line] != 1]
        avoid_hist[len(avoiding_nontangent)] += 1
        blocked_nontangent = 81 - len(avoiding_nontangent)
        encoded_arc = [[str(x) for x in internal[i]] for i in arc]
        if blocked_nontangent > max_blocked:
            max_blocked = blocked_nontangent
            max_examples = [encoded_arc]
        elif blocked_nontangent == max_blocked and len(max_examples) < 3:
            max_examples.append(encoded_arc)

        ordinary = [line for line in lines if line not in arrangement and line_size[line] != 1]
        by_kind = collections.Counter()
        for line in ordinary:
            j = sum(incident(line, v) for v in vertices)
            by_kind[(line_kind[line_size[line]], j)] += 1
        profile_hist[tuple(sorted(by_kind.items()))] += 1

    profiles = []
    for profile, count in sorted(profile_hist.items(), key=lambda item: (-item[1], str(item[0]))):
        profiles.append(
            {
                "count": count,
                "line_counts": {f"{kind}_{j}": value for (kind, j), value in profile},
            }
        )

    return {
        "schema": "c756-q9-star-profile-v1",
        "dependency": "SageMath 10.7",
        "field": "GF(9) with Sage primitive modulus",
        "projective_points": len(points),
        "conic_points": len(conic),
        "internal_points": len(internal),
        "passant_quadrangles": len(quadrangles),
        "internal_diagonal_histogram": {
            str(k): v for k, v in sorted(diagonal_type_hist.items())
        },
        "saturated_internal_arcs": len(arcs),
        "covering_arcs": avoid_hist[0],
        "avoiding_nontangent_histogram": {str(k): v for k, v in sorted(avoid_hist.items())},
        "maximum_blocked_nontangent_points": max_blocked,
        "maximum_total_nontangent_points": 81,
        "maximizer_examples": max_examples,
        "ordinary_line_profiles": profiles,
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
    print("ok: q=9 saturated-internal star profile reproduced")


if __name__ == "__main__":
    main()
