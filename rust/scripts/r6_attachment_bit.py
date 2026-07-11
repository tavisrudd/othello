#!/usr/bin/env python3
"""Frozen shortest-cycle trace attachment bit; geometry-only cohort audit.

Run from rust/:

    python3 scripts/r6_attachment_bit.py
"""

from collections import Counter
from itertools import combinations
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
import r5_q11_voltage_signature as R


def trace_sets(U, a, q):
    """Old deleted free-fiber reciprocal coordinates on D0 and Da."""
    frame = (0, *U)
    d0 = set()
    da = set()
    for u, v in combinations(frame, 2):
        if (u + v) % q:
            d0.add(u * v * R.inv(u + v, q) % q)
            da.add((u * v - a) * R.inv(u + v, q) % q)
    for u in U:
        d0.add(a * u * R.inv(a + u * u, q) % q)
    d0.discard(0)
    da.discard(0)
    return d0, da


def tau_algebra(U, a, q, side, parameter):
    """Parity of full-gain deleted target fibers from reciprocal b or d."""
    d0, da = trace_sets(U, a, q)
    blockers = set()
    if side == "0":
        for u in U:
            alpha = (a + u*u) * R.inv(u*u, q) % q
            blockers.add((alpha*parameter - a*R.inv(u, q)) % q)
        deleted = da
    else:
        for u in U:
            alpha = (a + u*u) * R.inv(u*u, q) % q
            blockers.add((parameter + a*R.inv(u, q)) * R.inv(alpha, q) % q)
        deleted = d0
    full_fibers = set()
    for z in blockers:
        if z and (-z) % q in blockers and z in deleted:
            assert (-z) % q in deleted
            full_fibers.add(min(z, (-z) % q))
    return len(full_fibers) % 2


def tau_graph(U, a, q):
    colors, relation = R.build_graph(U, a, q, False)
    C = lambda t: R.norm((t*t, t, 1), q)
    locations = {}
    for p in range(q):
        locations.setdefault(R.norm((0, 1, p), q), set()).add("0")
        locations.setdefault(R.norm((-a*p, 1, p), q), set()).add("a")
    locations.setdefault(C(0), set()).add("0")
    locations.setdefault(R.norm((-a, 0, 1), q), set()).add("a")
    points = sorted(locations)
    live = [i for i, color in enumerate(colors) if color[1] == "L"]
    new_colors = []
    for i in live:
        side = colors[i][0]
        mate = next(j for j in range(len(points)) if relation[i][j] & 2)
        assert mate != i
        full_fibers = set()
        for k, color in enumerate(colors):
            if color[1] != "D" or color[0] in (side, "I"):
                continue
            km = next(j for j in range(len(points)) if relation[k][j] & 2)
            if k != km and relation[i][k] & 1 and relation[i][km] & 1:
                full_fibers.add(tuple(sorted((k, km))))
        tau = len(full_fibers) % 2

        X, Y, Z = points[i]
        assert Z
        if side == "0":
            assert X == 0
            parameter = Y * R.inv(Z, q) % q
        else:
            scale = R.inv(Z, q)
            assert X * scale % q == (-a) % q
            parameter = Y * scale % q
        assert tau == tau_algebra(U, a, q, side, parameter)
        new_colors.append((side, tau))
    return new_colors, [[relation[i][j] for j in live] for i in live]


def cap_key(row, q):
    C = lambda t: R.norm((t*t, t, 1), q)
    points = (C(0), *(C(u) for u in row["U"]), R.norm((-row["a"], 0, 1), q))
    return R.canonical_six_cap(points, q)


def audit(q):
    records, rows, _ = R.geometry_records(q, True, True)
    representatives = []
    for row in rows:
        row["graph"] = tau_graph(row["U"], row["a"], q)
        for gid, representative in enumerate(representatives):
            if R.isomorphic(row["graph"], representative["graph"]):
                row["gid"] = gid
                break
        else:
            row["gid"] = len(representatives)
            representatives.append(row)

    by_signature = {i: set() for i in range(len(representatives))}
    by_cap = {}
    by_profile = {}
    labels = {(cls, cell): value for cls, record in records.items()
              for cell, value, _position in record["children"]}
    signature_labels = {i: set() for i in range(len(representatives))}
    profile_labels = {}
    for row in rows:
        key = cap_key(row, q)
        by_signature[row["gid"]].add(key)
        by_cap.setdefault(key, set()).add(row["gid"])
        profile = tuple((side, tuple(sorted(color[1] for color in row["graph"][0]
                                             if color[0] == side)))
                        for side in ("0", "a"))
        by_profile.setdefault(profile, set()).add(key)
        value = labels[(row["cls"], row["cell"])]
        signature_labels[row["gid"]].add(value)
        profile_labels.setdefault(profile, set()).add(value)

    print(f"q={q} incidences={len(rows)} tau_classes={len(representatives)} "
          f"cap_orbits={len(by_cap)} "
          f"max_cap_orbits_per_tau={max(map(len, by_signature.values()))} "
          f"multi_cap_tau={sum(len(x)>1 for x in by_signature.values())} "
          f"max_tau_per_cap={max(map(len, by_cap.values()))} "
          f"tau_profiles={len(by_profile)} "
          f"max_cap_orbits_per_profile={max(map(len, by_profile.values()))} "
          f"mixed_tau_classes={sum(len(x)>1 for x in signature_labels.values())} "
          f"mixed_profiles={sum(len(x)>1 for x in profile_labels.values())}")
    if q == 11:
        pair = []
        for a in (9, 5):
            graph = tau_graph((1, 4, 7, 10), a, q)
            pair.append(graph)
            print(f"collision a={a} colors={graph[0]} stats={R.graph_stats(graph)}")
        print("collision_tau_isomorphic=" + ("YES" if R.isomorphic(*pair) else "NO"))


def main():
    print("FROZEN tau(v)=parity of deleted opposite-side sigma-fibers supporting both gains")
    print("INTERPRETATION unbalanced length-2 quotient cycles incident with live fiber v")
    for q in (11, 13, 17):
        audit(q)


if __name__ == "__main__":
    main()
