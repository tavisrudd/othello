#!/usr/bin/env python3
"""Frozen q=11 affine-cocycle gate for the d=4 maximum-pencil cohort.

The value-blind phase partitions the 64 marked incidences by

* the multiplicative order of alpha_r / alpha_s, where
  alpha_u = 1 + a/u^2 and U = {+/-r,+/-s}; and
* the pair (live-cover isomorphism class, multiplier order).

Only ``--unblind`` joins these precomputed keys to the exact P/N labels.  It
also compares them with the unmarked PGL(3,11) six-cap orbit partition.  Run
from rust/:

    python3 scripts/r8_q11_cocycle_gate.py --geometry
    python3 scripts/r8_q11_cocycle_gate.py --unblind
"""

import argparse
from collections import Counter, defaultdict
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
import r5_q11_voltage_signature as R


Q = 11


def multiplicative_order(x):
    """Order of nonzero x in F_11^*."""
    x %= Q
    assert x
    value = 1
    for order in range(1, Q):
        value = value * x % Q
        if value == 1:
            return order
    raise AssertionError("F_11 multiplicative order not found")


def multiplier_order(row):
    """Gauge-invariant order of alpha_r/alpha_s (unchanged by inversion)."""
    a = row["a"]
    squares = sorted({u * u % Q for u in row["U"]})
    assert len(squares) == 2
    alphas = [(1 + a * pow(square, -1, Q)) % Q for square in squares]
    # Externality gives a + u^2 != 0, hence both multipliers are nonzero.
    assert all(alphas)
    ratio = alphas[0] * pow(alphas[1], -1, Q) % Q
    return multiplicative_order(ratio)


def cap_key(row):
    """Unmarked PGL(3,11) orbit key of the selected six-cap."""
    conic = lambda t: R.norm((t * t, t, 1), Q)
    points = (
        conic(0),
        *(conic(u) for u in row["U"]),
        R.norm((-row["a"], 0, 1), Q),
    )
    return R.canonical_six_cap(points, Q)


def summarize(rows, key_name, key_fn, labels=None):
    groups = defaultdict(lambda: {"labels": Counter(), "caps": set(), "n": 0})
    for row in rows:
        group = groups[key_fn(row)]
        group["caps"].add(row["cap_id"])
        group["n"] += 1
        if labels is not None:
            group["labels"][labels[(row["cls"], row["cell"])]] += 1

    mixed = None if labels is None else sum(
        len(group["labels"]) > 1 for group in groups.values()
    )
    print(
        f"PARTITION name={key_name} classes={len(groups)}"
        + ("" if mixed is None else f" mixed={mixed}")
        + f" cap_orbits={len({row['cap_id'] for row in rows})}"
        + f" max_caps_per_class={max(len(group['caps']) for group in groups.values())}"
    )
    reverse = defaultdict(set)
    for row in rows:
        reverse[row["cap_id"]].add(key_fn(row))
    print(f"  max_classes_per_cap={max(map(len, reverse.values()))}")
    for key, group in sorted(groups.items(), key=lambda item: str(item[0])):
        if key_name == "live+ord":
            shown_key = f"live_gid={key[0]} multiplier_order={key[1]}"
        else:
            shown_key = f"multiplier_order={key}"
        label_text = "" if labels is None else f" labels={dict(group['labels'])}"
        print(
            f"  {shown_key}{label_text} caps={len(group['caps'])}"
            f" incidences={group['n']}"
        )
    return groups, reverse


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--geometry", action="store_true")
    parser.add_argument("--unblind", action="store_true")
    args = parser.parse_args()
    if not args.geometry and not args.unblind:
        parser.error("choose --geometry or --unblind")

    records, rows, live_representatives = R.geometry_records(
        Q, all_frames=True, live_only=True
    )
    _, full_rows, full_representatives = R.geometry_records(
        Q, all_frames=True, live_only=False
    )
    assert len(rows) == len(full_rows) == 64
    assert len({(row["cls"], row["cell"]) for row in rows}) == 56

    cap_keys = sorted({cap_key(row) for row in rows})
    cap_ids = {key: index for index, key in enumerate(cap_keys)}
    for row in rows:
        row["cap_id"] = cap_ids[cap_key(row)]
        row["multiplier_order"] = multiplier_order(row)

    print(
        "COHORT q=11 incidences=64 unique_children=56 "
        f"live_blocks={len(live_representatives)} "
        f"full_trace_blocks={len(full_representatives)} "
        f"unmarked_pgl_cap_orbits={len(cap_keys)}"
    )
    order_key = lambda row: row["multiplier_order"]
    joined_key = lambda row: (row["gid"], row["multiplier_order"])
    summarize(rows, "ord", order_key)
    _, joined_reverse = summarize(rows, "live+ord", joined_key)

    split_cap_ids = sorted(
        cap_id for cap_id, keys in joined_reverse.items() if len(keys) > 1
    )
    print(f"PGL-SPLIT cap_orbits={split_cap_ids}")
    for cap_id in split_cap_ids:
        keys = sorted(joined_reverse[cap_id])
        representatives = sorted({
            (row["U"], row["a"], row["gid"], row["multiplier_order"])
            for row in rows if row["cap_id"] == cap_id
        })
        print(f"  cap_orbit={cap_id} joined_keys={keys} representatives={representatives}")

    collision_rows = [
        row for row in rows
        if tuple(row["U"]) == (1, 4, 7, 10) and row["a"] in (5, 9)
    ]
    collision_orbits = {
        a: sorted({row["cap_id"] for row in collision_rows if row["a"] == a})
        for a in (5, 9)
    }
    print(f"COLLISION-ORBITS a5={collision_orbits[5]} a9={collision_orbits[9]}")

    if not args.unblind:
        return

    # This is the only phase that reads exact game values.
    labels = {
        (cls, cell): value
        for cls, record in records.items()
        for cell, value, _position in record["children"]
    }
    print(f"UNBLIND totals={dict(Counter(labels[(row['cls'], row['cell'])] for row in rows))}")
    summarize(rows, "ord", order_key, labels)
    summarize(rows, "live+ord", joined_key, labels)
    for row in collision_rows:
        print(
            f"COLLISION a={row['a']} value={labels[(row['cls'], row['cell'])]} "
            f"live_gid={row['gid']} multiplier_order={row['multiplier_order']} "
            f"cap_orbit={row['cap_id']} cls={row['cls']} key={row['key']} "
            f"cell={row['cell']}"
        )


if __name__ == "__main__":
    main()
