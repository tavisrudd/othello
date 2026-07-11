#!/usr/bin/env python3
"""Frozen one-shot tests of the first polarity and trace-overlap candidates.

The predicates are defined before the P/N join:

* POLAR_GOOD: every live y_d has chi(d^2+a)=+1;
* OVERLAP_GOOD: common-deleted-neighbor profiles of live sigma fibers differ
  between D0 and Da.

For each, any GOOD/N incidence kills sufficiency and any marked maximum pencil
without a GOOD center kills coverage.  Run from rust/:

    python3 scripts/r6_attachment_kills.py
"""

from collections import Counter, defaultdict
from itertools import combinations
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
import r5_q11_voltage_signature as R


def polar_profile(q, U, a):
    C = lambda t: R.norm((t*t, t, 1), q)
    selected = [C(0), *(C(u) for u in U), R.norm((-a, 0, 1), q)]
    profile = []
    live_d = []
    for d in range(1, q):
        point = R.norm((-a, d, 1), q)
        deleted = any(R.det(point, x, y, q) == 0
                      for x, y in combinations(selected, 2))
        if not deleted:
            value = R.chi(d*d+a, q)
            assert value != 0
            live_d.append(d)
            profile.append(value)
    return tuple(sorted(profile)), tuple(live_d)


def overlap_profile(q, U, a):
    colors, relation = R.build_graph(U, a, q, False)
    live = [i for i, color in enumerate(colors) if color[1] == "L"]
    dead = [i for i, color in enumerate(colors) if color[1] == "D"]
    seen = set()
    answer = {"0": [], "a": []}
    for i in live:
        if i in seen:
            continue
        mates = [j for j in live if relation[i][j] & 2]
        assert len(mates) == 1
        j = mates[0]
        seen.update((i, j))
        assert colors[i][0] == colors[j][0] in answer
        common = sum(bool(relation[i][k] & 1) and bool(relation[j][k] & 1)
                     for k in dead)
        answer[colors[i][0]].append(common)
    return tuple(sorted(answer["0"])), tuple(sorted(answer["a"]))


def universal_trace_rows(q, U, a):
    colors, relation = R.build_graph(U, a, q, False)
    live = [i for i, color in enumerate(colors) if color[1] == "L"]
    dead = [i for i, color in enumerate(colors) if color[1] == "D"]
    return sum(all(relation[d][v] & 1 for v in live) for d in dead)


def audit(q):
    records, rows, _ = R.geometry_records(q, all_frames=True, live_only=True)
    labels = {(cls, cell): value for cls, record in records.items()
              for cell, value, _position in record["children"]}
    seen = set()
    polar_good = defaultdict(list)
    overlap_good = defaultdict(list)
    polar_n = []
    overlap_n = []
    polar_totals = Counter()
    overlap_totals = Counter()

    for row in rows:
        incidence = (row["cls"], row["key"], row["cell"])
        if incidence in seen:
            continue
        seen.add(incidence)
        value = labels[(row["cls"], row["cell"])]
        pp, live_d = polar_profile(q, row["U"], row["a"])
        pg = bool(pp) and set(pp) == {1}
        op0, opa = overlap_profile(q, row["U"], row["a"])
        og = op0 != opa
        line = (row["cls"], row["key"])
        if pg:
            polar_good[line].append(row["cell"])
            polar_totals[value] += 1
            if value == "N":
                polar_n.append((*incidence, row["a"], live_d, pp))
        if og:
            overlap_good[line].append(row["cell"])
            overlap_totals[value] += 1
            if value == "N":
                overlap_n.append((*incidence, row["a"], op0, opa))

    lines = {(row["cls"], row["key"]) for row in rows}
    polar_uncovered = sorted(lines-set(polar_good), key=str)
    overlap_uncovered = sorted(lines-set(overlap_good), key=str)
    print(f"q={q} incidences={len(seen)} lines={len(lines)}")
    print(f"  POLAR GOOD={dict(polar_totals)} "
          f"KILL_sufficiency={'YES' if polar_n else 'NO'} first_N={polar_n[:1]} "
          f"KILL_coverage={'YES' if polar_uncovered else 'NO'} "
          f"uncovered={len(polar_uncovered)}")
    print(f"  OVERLAP GOOD={dict(overlap_totals)} "
          f"KILL_sufficiency={'YES' if overlap_n else 'NO'} first_N={overlap_n[:1]} "
          f"KILL_coverage={'YES' if overlap_uncovered else 'NO'} "
          f"uncovered={len(overlap_uncovered)}")

    if q == 11:
        mu_joint = Counter()
        for row in rows:
            value = labels[(row["cls"], row["cell"])]
            mu = universal_trace_rows(q, row["U"], row["a"])
            mu_joint[(row["gid"], mu, value)] += 1
        print(f"  MU live_gid_mu_label={dict(sorted(mu_joint.items()))}")
        for a in (9, 5):
            print(f"  collision a={a} polar={polar_profile(11,(1,4,7,10),a)[0]} "
                  f"overlap={overlap_profile(11,(1,4,7,10),a)} "
                  f"mu={universal_trace_rows(11,(1,4,7,10),a)}")


def main():
    print("FROZEN POLAR_GOOD=all live Da points have chi(d^2+a)=+1")
    print("FROZEN OVERLAP_GOOD=D0 and Da live-fiber common-deleted profiles differ")
    for q in (11, 13, 17):
        audit(q)


if __name__ == "__main__":
    main()
