#!/usr/bin/env python3
"""Test the proposed proof structure for the hexad characterization at q=11."""
from collections import Counter
from itertools import combinations

Q = 11
QRS = {x * x % Q for x in range(1, Q)}
labels = list(range(Q)) + ['inf']


def norm(x, y, z):
    x %= Q; y %= Q; z %= Q
    if x:
        iv = pow(x, Q - 2, Q); return (1, y * iv % Q, z * iv % Q)
    if y:
        iv = pow(y, Q - 2, Q); return (0, 1, z * iv % Q)
    return (0, 0, 1)


def cross(a, b):
    return norm(a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0])


def dot(a, b):
    return (a[0]*b[0] + a[1]*b[1] + a[2]*b[2]) % Q


cpt = {t: (norm(t*t % Q, t, 1) if t != 'inf' else norm(1, 0, 0)) for t in labels}
conic_pts = set(cpt.values())
assert len(conic_pts) == 12

allpts = set()
for x in range(Q):
    for y in range(Q):
        for z in range(Q):
            if (x, y, z) != (0, 0, 0):
                allpts.add(norm(x, y, z))
offconic = allpts - conic_pts
assert len(allpts) == Q*Q + Q + 1 and len(offconic) == Q*Q


def mobius(m, t):
    a, b, c, d = m
    if t == 'inf':
        return 'inf' if c % Q == 0 else (a * pow(c, Q-2, Q)) % Q
    num, den = (a*t + b) % Q, (c*t + d) % Q
    return 'inf' if den == 0 else (num * pow(den, Q-2, Q)) % Q


PGL = []
for a in range(Q):
    for b in range(Q):
        for c in range(Q):
            for d in range(Q):
                if (a*d - b*c) % Q == 0:
                    continue
                v = (a, b, c, d)
                if next(x for x in v if x) != 1:
                    continue
                PGL.append(v)
assert len(PGL) == 1320, len(PGL)


def perm(m):
    return tuple(mobius(m, t) for t in labels)


idx = {t: i for i, t in enumerate(labels)}
perms = {}
for m in PGL:
    perms[m] = perm(m)

# involutions of PGL(2,11): p*p = id, p != id
identity = tuple(labels)
involutions = []
for m, p in perms.items():
    if p == identity:
        continue
    if tuple(p[idx[p[i]]] for i in range(12)) == identity:
        involutions.append(m)
print(f"involutions in PGL(2,11): {len(involutions)}")
ext_inv = [m for m in involutions if sum(1 for i, t in enumerate(labels) if perms[m][i] == t) == 2]
int_inv = [m for m in involutions if sum(1 for i, t in enumerate(labels) if perms[m][i] == t) == 0]
print(f"  with 2 fixed points on the conic (external centre): {len(ext_inv)}")
print(f"  with 0 fixed points on the conic (internal centre): {len(int_inv)}")
print(f"  off-conic points: {len(offconic)} = 66 external + 55 internal")

# ---- t(H) via chord concurrences ------------------------------------------------
def t_of(H):
    chords = [cross(cpt[a], cpt[b]) for a, b in combinations(H, 2)]
    cnt = Counter()
    for P in offconic:
        m = sum(1 for L in chords if dot(P, L) == 0)
        if m:
            cnt[m] += 1
    maxm = max(cnt) if cnt else 0
    t = 60 + sum(v * (m*(m-1)*(m-2)//6) for m, v in cnt.items())
    return t, maxm


# ---- the claimed identity -------------------------------------------------------
def fpf_involutions(H):
    """involutions tau with tau(H)=H and no fixed point of tau inside H"""
    hs = set(H)
    out = []
    for m in involutions:
        p = perms[m]
        img = {p[idx[t]] for t in hs}
        if img != hs:
            continue
        if any(p[idx[t]] == t for t in hs):
            continue
        out.append(m)
    return out


maxm_global = 0
bad = 0
spectrum = Counter()
tvals = {}
for H in combinations(labels, 6):
    t, maxm = t_of(H)
    maxm_global = max(maxm_global, maxm)
    n_fpf = len(fpf_involutions(H))
    if t - 60 != n_fpf:
        bad += 1
    spectrum[t] += 1
    tvals[frozenset(H)] = t

assert maxm_global <= 3, maxm_global
assert bad == 0, bad
assert spectrum == Counter({60: 264, 62: 330, 63: 220, 64: 110}), spectrum

print(f"\nmax m_P over off-conic points, all H: {maxm_global}   (claim: <= 3)")
print(f"identity  t(H) - 60 == #fpf involutions stabilising H:  {'HOLDS for all 924' if bad == 0 else f'FAILS for {bad}'}")
print(f"spectrum: {dict(sorted(spectrum.items()))}")

# ---- PGL orbits on 6-subsets ----------------------------------------------------
seen = set()
orbits = []
for H in combinations(labels, 6):
    key = frozenset(H)
    if key in seen:
        continue
    orb = set()
    for m in PGL:
        p = perms[m]
        orb.add(frozenset(p[idx[t]] for t in H))
    seen |= orb
    orbits.append(orb)

print(f"\nPGL(2,11)-orbits on the 924 six-subsets: {len(orbits)}")
assert len(orbits) == 4, len(orbits)
observed_orbits = set()
for orb in sorted(orbits, key=len, reverse=True):
    rep = tuple(sorted(next(iter(orb)), key=str))
    stab = 1320 // len(orb)
    t = tvals[frozenset(rep)]
    nf = len(fpf_involutions(rep))
    # involutions in the stabiliser (fpf or not)
    hs = set(rep)
    n_inv_stab = sum(1 for m in involutions
                     if {perms[m][idx[x]] for x in hs} == hs)
    observed_orbits.add((len(orb), stab, t, n_inv_stab, nf))
    print(f"  orbit size {len(orb):3}  |Stab| = {stab:2}  t = {t}  "
          f"involutions in Stab: {n_inv_stab}  of which fpf on H: {nf}")

assert observed_orbits == {
    (264, 5, 60, 0, 0),
    (330, 4, 62, 3, 2),
    (220, 6, 63, 3, 3),
    (110, 12, 64, 7, 4),
}, observed_orbits
print("all involution identities, spectra, and orbit rows passed")
