#!/usr/bin/env python3
"""Exact q=11 partition lattice: live signature versus PGL orbit versus P/N."""

from collections import Counter, defaultdict
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
import r5_q11_voltage_signature as R


Q = 11


def cap_key(row):
    C = lambda t: R.norm((t*t, t, 1), Q)
    points = (C(0), *(C(u) for u in row["U"]), R.norm((-row["a"], 0, 1), Q))
    return R.canonical_six_cap(points, Q)


def main():
    records, rows, representatives = R.geometry_records(Q, all_frames=True, live_only=True)
    labels = {}
    for cls, record in records.items():
        for cell, value, _position in record["children"]:
            old = labels.setdefault((cls, cell), value)
            assert old == value

    keys = sorted({cap_key(row) for row in rows})
    orbit_id = {key: i for i, key in enumerate(keys)}
    table = defaultdict(Counter)
    children = defaultdict(set)
    for row in rows:
        gid = row["gid"]
        oid = orbit_id[cap_key(row)]
        value = labels[(row["cls"], row["cell"])]
        table[gid][(oid, value)] += 1
        children[gid].add((row["cls"], row["cell"], oid, value))

    print(f"q={Q} incidences={len(rows)} live_blocks={len(representatives)} "
          f"pgl_orbits={len(keys)}")
    mixed = []
    multi_orbit = []
    for gid in sorted(table):
        orbit_values = sorted(table[gid].items())
        orbit_ids = {pair[0] for pair in table[gid]}
        values = {pair[1] for pair in table[gid]}
        if len(orbit_ids) > 1:
            multi_orbit.append(gid)
        if len(values) > 1:
            mixed.append(gid)
        print(f"L{gid} incidences={sum(table[gid].values())} "
              f"unique_children={len(children[gid])} orbit_values={orbit_values}")
    print(f"multi_orbit_live_blocks={multi_orbit}")
    print(f"mixed_value_live_blocks={mixed}")
    assert multi_orbit == mixed and len(mixed) == 1
    print("THEOREM_INPUT sole_multi_orbit_block_is_sole_mixed_block=YES")


if __name__ == "__main__":
    main()
