#!/usr/bin/env python3
"""Independent replay of the exceptional q=19 six-point conic obstruction."""

from itertools import combinations
import json
import sys


Q = 19


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


def evaluate(form, p):
    x, y, z = p
    row = (x * x, y * y, z * z, x * y, x * z, y * z)
    return sum(a * b for a, b in zip(form, row)) % Q


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: q19-exception-check.py INPUT.json OUTPUT.json")
    with open(sys.argv[1], encoding="ascii") as source:
        data = json.load(source)
    arc = [tuple(p) for p in data["arc_survivor"]]
    claimed_uncovered = [tuple(p) for p in data["arc_survivor_uncovered"]]
    form = data["five_point_conic"]
    points = sorted({
        norm((x, y, z))
        for x in range(Q) for y in range(Q) for z in range(Q)
        if x or y or z
    })
    arc_set = set(arc)
    covered = {
        p for p in points
        if any(det(a, b, p) == 0 for a, b in combinations(arc, 2))
    }
    uncovered = [p for p in points if p not in arc_set and p not in covered]
    conic_points = [p for p in points if evaluate(form, p) == 0]
    checks = {
        "arc_has_nine_points": len(arc_set) == 9,
        "selected_is_arc": all(det(a, b, c) for a, b, c in combinations(arc, 3)),
        "uncovered_matches": uncovered == claimed_uncovered,
        "uncovered_has_nine_points": len(uncovered) == 9,
        "uncovered_is_arc": all(
            det(a, b, c) for a, b, c in combinations(uncovered, 3)
        ),
        "first_five_on_conic": all(evaluate(form, p) == 0 for p in uncovered[:5]),
        "sixth_off_conic": evaluate(form, uncovered[5]) != 0,
        "exactly_three_uncovered_off_conic": sum(
            evaluate(form, p) != 0 for p in uncovered
        ) == 3,
        "conic_has_twenty_points": len(conic_points) == Q + 1,
        "exactly_one_selected_on_conic": sum(
            evaluate(form, p) == 0 for p in arc
        ) == 1,
    }
    result = {
        "schema": "c643-q19-exception-replay-v1",
        "q": Q,
        "checks": checks,
        "sixth_value": evaluate(form, uncovered[5]),
        "verified": all(checks.values()),
    }
    with open(sys.argv[2], "w", encoding="ascii") as out:
        json.dump(result, out, separators=(",", ":"), sort_keys=True)
        out.write("\n")
    if not result["verified"]:
        raise SystemExit("exception replay failed")


if __name__ == "__main__":
    main()
