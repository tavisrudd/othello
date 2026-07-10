#!/usr/bin/env python3
"""Tie-line concurrence check for C74/C73.

Part 1 reads existing prime-field feat data and reports the common legal child
of every tied d=4 L-family, with values used only in the final score.
Part 2 computes the corresponding label-blind projective intersection for the
eight q=25 full-PGL five-set representatives.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from c73_secant_algebra import DATA, PRIME_FILES, analyze, parse
from c74_fan_orbits import Field, act, line_pencil_summary, orbit_map, pgl_matrices


def existing():
    for q in (11, 13, 17, 19):
        recs = analyze(q, parse(os.path.join(DATA, PRIME_FILES[q])))
        for cls, rec in sorted(recs.items()):
            mx = max(d["nlegal"] for d in rec["cand"].values())
            selected = [d for d in rec["cand"].values() if d["nlegal"] == mx]
            if len(selected) not in (3, 5):
                continue
            common = set.intersection(*[{z for z, _v, _p in d["hit"]} for d in selected])
            labels = {z: (v, p) for z, v, p in rec["children"]}
            print(f"KNOWN q={q} cls={cls} ties={len(selected)} "
                  f"common={[(z, labels[z]) for z in sorted(common)]}")


def cross(F, x, y):
    return (F.sub(F.mul(x[1], y[2]), F.mul(x[2], y[1])),
            F.sub(F.mul(x[2], y[0]), F.mul(x[0], y[2])),
            F.sub(F.mul(x[0], y[1]), F.mul(x[1], y[0])))


def dot(F, x, y):
    return F.add(F.add(F.mul(x[0], y[0]), F.mul(x[1], y[1])), F.mul(x[2], y[2]))


def norm(F, x):
    a = next(v for v in x if v)
    ai = F.inv(a)
    return tuple(F.mul(v, ai) for v in x)


def conic(F, t):
    return (1, 0, 0) if t == F.q else (F.mul(t, t), t, 1)


def q25():
    F = Field(25)
    G = pgl_matrices(F)
    rows, _owner, _sizes, _stabs = orbit_map(F, 5, G)
    conic_points = {norm(F, conic(F, t)) for t in range(F.q + 1)}
    for idx, A in enumerate(rows):
        _hist, dmin, keys = line_pencil_summary(F, A)
        if len(keys) not in (3, 5):
            continue
        lines = [cross(F, conic(F, e), conic(F, w)) for e, w in keys]
        z = norm(F, cross(F, lines[0], lines[1]))
        concurrent = all(dot(F, line, z) == 0 for line in lines)
        illegal_chords = sum(
            dot(F, cross(F, conic(F, A[i]), conic(F, A[j])), z) == 0
            for i in range(5) for j in range(i + 1, 5)
        )
        print(f"BLIND q=25 row={idx} dmin={dmin} ties={len(keys)} concurrent={concurrent} "
              f"z={z} onconic={z in conic_points} illegal-chords={illegal_chords}")


if __name__ == "__main__":
    existing()
    q25()
