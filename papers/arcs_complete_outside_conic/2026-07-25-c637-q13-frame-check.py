#!/usr/bin/env python3
"""Independent frame-marked check of the C637 q=13 quadratic ranks."""

from itertools import combinations
import json
import sys

Q = 13


def inv(x):
    return pow(x, Q - 2, Q)


def norm(p):
    z = inv(next(x for x in p if x))
    return tuple(z * x % Q for x in p)


def det(a, b, c):
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % Q


def qrow(p):
    x, y, z = p
    return (x * x % Q, y * y % Q, z * z % Q,
            x * y % Q, x * z % Q, y * z % Q)


def rank(rows):
    a = [list(row) for row in rows]
    r = 0
    for col in range(6):
        pivot = next((i for i in range(r, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        z = inv(a[r][col])
        a[r] = [(z * x) % Q for x in a[r]]
        for i in range(len(a)):
            if i != r and a[i][col]:
                w = a[i][col]
                a[i] = [(x - w * y) % Q for x, y in zip(a[i], a[r])]
        r += 1
        if r == 6:
            break
    return r


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: q13-frame-check.py OUTPUT.json")
    points = sorted({
        norm((x, y, z))
        for x in range(Q) for y in range(Q) for z in range(Q)
        if x or y or z
    })
    index = {p: i for i, p in enumerate(points)}
    frame = tuple(index[p] for p in ((0, 0, 1), (0, 1, 0), (1, 0, 0), (1, 1, 1)))

    line_masks = {}
    for i, j in combinations(range(len(points)), 2):
        line_masks[i, j] = sum(
            1 << x for x, p in enumerate(points)
            if det(points[i], points[j], p) == 0
        )

    candidates = [
        x for x in range(len(points))
        if x not in frame
        and all(det(points[i], points[j], points[x]) for i, j in combinations(frame, 2))
    ]
    rank_counts = [0] * 7
    tested = 0
    all_mask = (1 << len(points)) - 1
    for extras in combinations(candidates, 3):
        arc = frame + extras
        if any(
            det(points[i], points[j], points[k]) == 0
            for i, j, k in combinations(extras, 3)
        ):
            continue
        if any(
            det(points[i], points[j], points[k]) == 0
            for i, j in combinations(extras, 2)
            for k in frame
        ):
            continue
        covered = 0
        for i, j in combinations(arc, 2):
            covered |= line_masks[min(i, j), max(i, j)]
        uncovered_mask = all_mask ^ covered
        rows = [
            qrow(points[x]) for x in range(len(points))
            if uncovered_mask >> x & 1
        ]
        r = rank(rows)
        rank_counts[r] += 1
        tested += 1

    result = {
        "schema": "secant-hull-frame-check-v1",
        "q": Q,
        "k": 7,
        "points": len(points),
        "frame_candidates": len(candidates),
        "tested_frame_marked_arcs": tested,
        "rank_counts": rank_counts,
        "verdict": "all_full_rank" if rank_counts[6] == tested else "rank_drop",
    }
    with open(sys.argv[1], "w", encoding="ascii") as out:
        json.dump(result, out, separators=(",", ":"), sort_keys=True)
        out.write("\n")


if __name__ == "__main__":
    main()
