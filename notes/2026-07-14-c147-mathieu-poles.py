#!/usr/bin/env python3
"""
New-property probe: do the 132 hexads of S(5,6,12), realized on the 12 points of
the conic XZ=Y^2 in PG(2,11) via P^1(F_11), separate from the other C(12,6)=924
6-subsets under conic-polarity invariants of their 15 chord-poles?

Invariants per 6-subset H of conic points:
  t(H)  = number of collinear triples among the 15 poles of the chords of H
          (= number of concurrent chord-triples, by polarity);
  a(H)  = is the 15-pole set... we also record the line-type profile of pole pairs.
"""
from collections import Counter
from itertools import combinations

Q = 11


def norm(x, y, z):
    x %= Q; y %= Q; z %= Q
    if x:
        iv = pow(x, Q - 2, Q); return (1, y * iv % Q, z * iv % Q)
    if y:
        iv = pow(y, Q - 2, Q); return (0, 1, z * iv % Q)
    return (0, 0, 1)


def cross(a, b):
    return norm(a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0])


def dot(a, b):
    return (a[0] * b[0] + a[1] * b[1] + a[2] * b[2]) % Q


# P^1(F_11) labels 0..10 and 'inf' -> conic points
labels = list(range(Q)) + ['inf']
cpt = {t: ((t * t % Q, t, 1) if t != 'inf' else (1, 0, 0)) for t in labels}

# PSL(2,11) as Mobius maps on labels (matrices with square det, projectively)
QRs = {x * x % Q for x in range(1, Q)}


def mobius(m, t):
    a, b, c, d = m
    if t == 'inf':
        return 'inf' if c % Q == 0 else (a * pow(c, Q - 2, Q)) % Q
    num, den = (a * t + b) % Q, (c * t + d) % Q
    if den == 0:
        return 'inf'
    return (num * pow(den, Q - 2, Q)) % Q


psl = []
for a in range(Q):
    for b in range(Q):
        for c in range(Q):
            for d in range(Q):
                det = (a * d - b * c) % Q
                if det == 0 or det not in QRs:
                    continue
                v = (a, b, c, d)
                fn = next(x for x in v if x)
                if fn != 1:
                    continue
                psl.append(v)
assert len(psl) == 660, len(psl)

# blocks of S(5,6,12) as a PSL(2,11)-orbit; try standard seeds
for seed in ({0, 1, 3, 4, 5, 9}, {'inf', 1, 3, 4, 5, 9}, {'inf', 0, 1, 3, 4, 5},
             {'inf', 0, 1, 2, 6, 9}, {'inf', 0, 3, 4, 5, 9}):
    orbit = {frozenset(mobius(m, t) for t in seed) for m in psl}
    if len(orbit) == 132:
        # Steiner check: every 5-subset in exactly one block
        cnt = Counter()
        for blk in orbit:
            for five in combinations(sorted(blk, key=str), 5):
                cnt[frozenset(five)] += 1
        if len(cnt) == 792 and set(cnt.values()) == {1}:
            hexads = orbit
            print(f"S(5,6,12) realized: seed {sorted(seed, key=str)} -> 132 blocks, Steiner verified")
            break
else:
    raise SystemExit("no Steiner seed worked")

# polarity: bilinear form matrix B for XZ - Y^2 (x^T B y = x0 y2 + x2 y0 - 2 x1 y1)
# pole of line l = B^{-1} l ; B = [[0,0,1],[0,-2,0],[1,0,0]], B^{-1} = [[0,0,1],[0,-(2^{-1}),0],[1,0,0]]
half_inv = pow(2, Q - 2, Q)


def pole(line):
    l0, l1, l2 = line
    return norm(l2, (-half_inv * l1) % Q, l0)


def invariants(H):
    ps = [cpt[t] for t in H]
    poles = [pole(cross(a, b)) for a, b in combinations(ps, 2)]
    assert len(set(poles)) == 15
    t = sum(1 for x, y, z in combinations(poles, 3) if dot(cross(x, y), z) == 0)
    return t


hex_t = Counter()
non_t = Counter()
for H in combinations(labels, 6):
    t = invariants(H)
    if frozenset(H) in hexads:
        hex_t[t] += 1
    else:
        non_t[t] += 1
print(f"concurrent-chord-triple count t: hexads {dict(sorted(hex_t.items()))}")
print(f"                             non-hexads {dict(sorted(non_t.items()))}")
