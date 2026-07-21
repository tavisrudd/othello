#!/usr/bin/env python3
"""Independent direct replay of the load-bearing C447 claims."""

from __future__ import annotations

import json
import re
from itertools import product
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CERT = json.loads((ROOT / "notes/2026-07-21-c447-cap-knife-edge.json").read_text())
FEAT = (ROOT / "notes/data/codex-feat11-c15.out").read_text().splitlines()
Q = 11
INF = 11


def inv(x):
    return pow(x % Q, -1, Q)


def norm(m):
    z = next(x % Q for x in m if x % Q)
    return tuple(x * inv(z) % Q for x in m)


def pgl():
    return sorted({norm(m) for m in product(range(Q), repeat=4) if (m[0] * m[3] - m[1] * m[2]) % Q})


def act(m, x):
    a, b, c, d = m
    if x == INF:
        return INF if c == 0 else a * inv(c) % Q
    den = (c * x + d) % Q
    return INF if den == 0 else (a * x + b) * inv(den) % Q


def edge(a, b):
    return tuple(sorted((a, b)))


def matching(raw):
    return {edge(INF if a == "inf" else a, INF if b == "inf" else b) for a, b in raw}


def image(g, M):
    return {edge(act(g, a), act(g, b)) for a, b in M}


def mat_vec(m, v):
    return tuple(sum(m[i][j] * v[j] for j in range(3)) % Q for i in range(3))


def pnorm(v):
    return norm(v)


def main():
    G = pgl()
    assert len(G) == 1320
    frozen = CERT["frozen_c406"]
    plus = matching(frozen["base_singleton_matching"])
    minus = matching(frozen["j_mate_singleton_matching"])
    Aplus = {g for g in G if image(g, plus) == plus}
    Aminus = {g for g in G if image(g, minus) == minus}
    pair_stab = {g for g in G if {frozenset(image(g, plus)), frozenset(image(g, minus))} == {frozenset(plus), frozenset(minus)}}
    assert (len(Aplus), len(Aminus), len(pair_stab)) == (60, 60, 24)
    assert all(pow((g[0] * g[3] - g[1] * g[2]) % Q, 5, Q) == 1 for g in Aplus | Aminus)

    class_lines = {}
    child_lines = {4: [], 7: []}
    for line in FEAT:
        match = re.match(r"CLS q=11 cls=(4|7) S3=\[\(([^)]+)\), \(([^)]+)\), \(([^)]+)\)\].* onP=(\d+) onN=(\d+)", line)
        if match:
            class_lines[int(match.group(1))] = ([tuple(map(int, match.group(i).split(", "))) for i in (2, 3, 4)], int(match.group(5)), int(match.group(6)))
        match = re.match(r"X q=11 cls=(4|7) x=(\d+),(\d+) val=([PN]) pos=(on|ext|int)", line)
        if match and match.group(5) == "on":
            child_lines[int(match.group(1))].append(((int(match.group(2)), int(match.group(3))), match.group(4)))

    for record in CERT["knife_edge_classes"]:
        cls = record["class"]
        S3, onP, onN = class_lines[cls]
        assert (onP, onN, len(child_lines[cls])) == (2, 5, 7)
        rho = record["hyperbola"]["rho"]
        A = record["hyperbola"]["A"]
        B = record["hyperbola"]["B"]
        assert all((r - rho) * (c - A) % Q == B for r, c in S3 + [cell for cell, _ in child_lines[cls]])
        frame = {INF, 0, *((r - rho) % Q for r, _ in S3)}
        D = {g for g in G if {act(g, x) for x in frame} == frame}
        assert len(D) == 10
        assert sum(pow((g[0] * g[3] - g[1] * g[2]) % Q, 5, Q) == 1 for g in D) == 5
        p_pair = {(r - rho) % Q for (r, _), value in child_lines[cls] if value == "P"}
        assert len(p_pair) == 2
        assert edge(*p_pair) not in plus and edge(*p_pair) not in minus
        cap_to_standard = record["cap_to_standard_projectivity"]
        for r, c in S3 + [cell for cell, _ in child_lines[cls]]:
            w = (r - rho) % Q
            assert pnorm(mat_vec(cap_to_standard, (r, c, 1))) == pnorm((1, w, w * w % Q))
        assert record["symmetry_compatible_projectivities_to_singleton"] == {"base": 0, "j_mate": 0}
        assert record["symmetry_compatible_projectivities_to_unordered_singleton_pair"] == 0

    r4, r7 = CERT["knife_edge_classes"]
    frame4 = {INF if x == "inf" else x for x in r4["frame_parameters"]}
    frame7 = {INF if x == "inf" else x for x in r7["frame_parameters"]}
    p4 = set(r4["child_orbits"][0]["parameters"])
    p7 = set(r7["child_orbits"][0]["parameters"])
    n4 = set(r4["child_orbits"][1]["parameters"])
    n7 = set(r7["child_orbits"][1]["parameters"])
    equivalences = [g for g in G if {act(g, x) for x in frame4} == frame7 and {act(g, x) for x in p4} == p7 and {act(g, x) for x in n4} == n7]
    assert len(equivalences) == 10 and equivalences[0] == (0, 1, 4, 10)
    assert CERT["cap_knife_edge_class_equivalence"]["projectivity_count"] == 10

    assert CERT["acceptance"]["golden_singleton_identification"] == "REFUTED_AS_AN_EQUIVARIANT_IDENTIFICATION"
    print("C447 independent replay: PASS")


if __name__ == "__main__":
    main()
