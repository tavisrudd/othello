#!/usr/bin/env python3
"""Deterministic bounded local search for a q=19 ten-arc outside one conic."""

import json
import math
import random
import sys

Q = 19
K = 10
SEED = 637019
RESTARTS = 400
STEPS = 25_000


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


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: q19-witness-search.py OUTPUT.json")
    points = sorted({
        norm((x, y, z))
        for x in range(Q) for y in range(Q) for z in range(Q)
        if x or y or z
    })
    conic = {i for i, (x, y, z) in enumerate(points) if (x * z - y * y) % Q == 0}
    outside = [i for i in range(len(points)) if i not in conic]
    outside_mask = sum(1 << i for i in outside)
    line_masks = {}
    for a_pos, a in enumerate(outside):
        for b in outside[a_pos + 1:]:
            line_masks[a, b] = sum(
                1 << i for i, p in enumerate(points)
                if det(points[a], points[b], p) == 0
            )

    def legal(arc, candidate, omit=None):
        retained = [x for i, x in enumerate(arc) if i != omit]
        return candidate not in retained and all(
            det(points[a], points[b], points[candidate])
            for i, a in enumerate(retained) for b in retained[:i]
        )

    def holes(arc):
        covered = 0
        for i, a in enumerate(arc):
            for b in arc[:i]:
                covered |= line_masks[min(a, b), max(a, b)]
        return (outside_mask & ~covered).bit_count()

    rng = random.Random(SEED)
    best_arc = None
    best_holes = len(outside)
    tested = 0
    for restart in range(RESTARTS):
        arc = []
        while len(arc) < K:
            candidates = [x for x in outside if legal(arc, x)]
            if not candidates:
                arc = []
                continue
            arc.append(rng.choice(candidates))
        score = holes(arc)
        for step in range(STEPS):
            tested += 1
            if score < best_holes:
                best_holes, best_arc = score, sorted(arc)
            if score == 0:
                break
            pos = rng.randrange(K)
            candidate = rng.choice(outside)
            if not legal(arc, candidate, pos):
                continue
            trial = arc.copy()
            trial[pos] = candidate
            trial_score = holes(trial)
            temperature = max(0.15, 2.5 * (1.0 - step / STEPS))
            if trial_score <= score or rng.random() < math.exp((score - trial_score) / temperature):
                arc, score = trial, trial_score
        if best_holes == 0:
            break

    result = {
        "schema": "fixed-conic-local-search-v1",
        "q": Q,
        "k": K,
        "seed": SEED,
        "restart_limit": RESTARTS,
        "steps_per_restart": STEPS,
        "tested_swaps": tested,
        "best_uncovered_outside_conic": best_holes,
        "verdict": "witness" if best_holes == 0 else "no_witness_found",
        "arc": [points[i] for i in best_arc],
        "conic": "X*Z-Y^2",
    }
    with open(sys.argv[1], "w", encoding="ascii") as out:
        json.dump(result, out, separators=(",", ":"), sort_keys=True)
        out.write("\n")


if __name__ == "__main__":
    main()
