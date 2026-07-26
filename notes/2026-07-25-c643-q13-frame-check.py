#!/usr/bin/env python3
"""Independent frame-marked check of the C643 q=13 collinear-triple mechanism."""

from collections import Counter
from importlib.util import module_from_spec, spec_from_file_location
from itertools import combinations
import json
from pathlib import Path
import sys


SOURCE = Path(__file__).with_name("2026-07-25-c637-q13-frame-check.py")
SPEC = spec_from_file_location("c637_q13", SOURCE)
if SPEC is None or SPEC.loader is None:
    raise RuntimeError("cannot load the independent C637 checker")
C637 = module_from_spec(SPEC)
SPEC.loader.exec_module(C637)


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: c643-q13-frame-check.py OUTPUT.json")
    points = sorted({
        C637.norm((x, y, z))
        for x in range(C637.Q) for y in range(C637.Q) for z in range(C637.Q)
        if x or y or z
    })
    index = {p: i for i, p in enumerate(points)}
    frame = tuple(index[p] for p in ((0, 0, 1), (0, 1, 0), (1, 0, 0), (1, 1, 1)))
    line_masks = {
        (i, j): sum(
            1 << x for x, p in enumerate(points)
            if C637.det(points[i], points[j], p) == 0
        )
        for i, j in combinations(range(len(points)), 2)
    }
    candidates = [
        x for x in range(len(points))
        if x not in frame
        and all(
            C637.det(points[i], points[j], points[x])
            for i, j in combinations(frame, 2)
        )
    ]

    tested = 0
    collinear = 0
    uncovered_sizes = Counter()
    borderline_triples = Counter()
    all_mask = (1 << len(points)) - 1
    for extras in combinations(candidates, 3):
        arc = frame + extras
        if any(
            C637.det(points[i], points[j], points[k]) == 0
            for i, j, k in combinations(extras, 3)
        ):
            continue
        if any(
            C637.det(points[i], points[j], points[k]) == 0
            for i, j in combinations(extras, 2)
            for k in frame
        ):
            continue
        covered = 0
        for i, j in combinations(arc, 2):
            covered |= line_masks[min(i, j), max(i, j)]
        uncovered = all_mask ^ covered
        uncovered_indices = [
            x for x in range(len(points)) if uncovered >> x & 1
        ]
        uncovered_sizes[len(uncovered_indices)] += 1
        has_triple = any(
            (line_masks[min(i, j), max(i, j)] & uncovered).bit_count() >= 3
            for i, j in combinations(uncovered_indices, 2)
        )
        if len(uncovered_indices) == C637.Q + 1:
            triple_count = sum(
                C637.det(points[i], points[j], points[k]) == 0
                for i, j, k in combinations(uncovered_indices, 3)
            )
            borderline_triples[triple_count] += 1
        collinear += has_triple
        tested += 1

    result = {
        "schema": "c643-q13-frame-collinearity-v1",
        "q": C637.Q,
        "k": 7,
        "points": len(points),
        "frame_candidates": len(candidates),
        "tested_frame_marked_arcs": tested,
        "collinear_triple_certificates": collinear,
        "uncovered_size_counts": dict(sorted(uncovered_sizes.items())),
        "q_plus_one_collinear_triple_counts": dict(sorted(borderline_triples.items())),
        "verdict": "all_nonarcs" if collinear == tested else "arc_survivor",
    }
    with open(sys.argv[1], "w", encoding="ascii") as out:
        json.dump(result, out, separators=(",", ":"), sort_keys=True)
        out.write("\n")


if __name__ == "__main__":
    main()
