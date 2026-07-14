#!/usr/bin/env python3
"""Independent bitset verifier for the normalized C99 (f,e)=(2,3) census."""
import importlib.util
from itertools import combinations, product
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "gf25", ROOT / "rust/scripts/r7_semilinear_q25.py")
gf = importlib.util.module_from_spec(spec)
spec.loader.exec_module(gf)

add, sub, mul = gf.add, gf.sub, gf.mul
normalize, frobenius, det = gf.normalize, gf.frobenius, gf.det

def cross(a, b):
    return normalize((
        sub(mul(a[1], b[2]), mul(a[2], b[1])),
        sub(mul(a[2], b[0]), mul(a[0], b[2])),
        sub(mul(a[0], b[1]), mul(a[1], b[0])),
    ))

def dot(p, l):
    return add(add(mul(p[0], l[0]), mul(p[1], l[1])), mul(p[2], l[2]))

points = sorted({normalize(v) for v in product(range(25), repeat=3) if any(v)})
fixed = [p for p in points if frobenius(p) == p]
orbits, seen = [], set()
for p in points:
    q = frobenius(p)
    if p != q and p not in seen:
        orbits.append((p, q)); seen.update((p, q))
assert len(points) == 651 and len(fixed) == 31 and len(orbits) == 310

A, B = fixed[:2]
base_occupied = {l for l in fixed if dot(A, l) == 0 or dot(B, l) == 0}
assert len(base_occupied) == 11
mate = [cross(p, q) for p, q in orbits]
carrier_mask = {}
for i, m in enumerate(mate): carrier_mask[m] = carrier_mask.get(m, 0) | (1 << i)
line_forbidden = {}
for l in points:
    mask = 0
    for i, (p, _q) in enumerate(orbits):
        if dot(p, l) == 0: mask |= 1 << i
    line_forbidden[l] = mask
all_candidates = (1 << len(orbits)) - 1

def is_arc(C):
    return all(det(*t) != 0 for t in combinations(C, 3))

good = [i for i, pq in enumerate(orbits) if is_arc((A, B, *pq))]
compat = set()
for ia, i in enumerate(good):
    for j in good[ia+1:]:
        if is_arc((A, B, *orbits[i], *orbits[j])):
            compat.add((i, j))

count, minimum, witness = 0, 10**9, None
for ai, i in enumerate(good):
    for bj in range(ai+1, len(good)):
        j = good[bj]
        if (i, j) not in compat: continue
        for k in good[bj+1:]:
            if (i, k) not in compat or (j, k) not in compat: continue
            C = (A, B, *orbits[i], *orbits[j], *orbits[k])
            if not is_arc(C): continue
            count += 1
            occupied = base_occupied | {mate[i], mate[j], mate[k]}
            assert len(occupied) == 14
            occupied_mask = 0
            for l in occupied: occupied_mask |= carrier_mask.get(l, 0)
            forbidden_mask = 0
            for x, y in combinations(C, 2): forbidden_mask |= line_forbidden[cross(x, y)]
            legal = (all_candidates & ~occupied_mask & ~forbidden_mask).bit_count()
            if legal < minimum: minimum, witness = legal, (i, j, k, C)

assert count == 469600
assert minimum == 32
print(f"normalized_arcs={count} min_legal={minimum} orbit_indices={witness[:3]}")
print("witness=" + repr(witness[3]))
