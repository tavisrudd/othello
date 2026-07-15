#!/usr/bin/env python3
"""
C147 --- full verifier for the hexad polarity-defect characterization.

CLAIM: a 6-subset H of the twelve points of the conic XZ=Y^2 in PG(2,11) satisfies
t(H) = 60 iff H is a block of one of the two S(5,6,12) Steiner systems on P^1(F_11),
where t(H) counts the concurrent triples among H's fifteen chords (equivalently, by
conic polarity, the collinear triples among the fifteen chord-poles).

Each point of H forces C(5,3) = 10 concurrent triples at itself, so t(H) >= 60 always,
with equality iff no three chords of H meet away from H itself. That bound is the null,
declared before the census.

This closes the gap left by 2026-07-14-c147-mathieu-poles.py, which Steiner-verified
only ONE system and so left the claim's second half resting on an unreproduced
computation. Everything asserted here is checked by `assert`; the script exits nonzero
on any failure.
"""
from collections import Counter
from itertools import combinations

Q = 11
QRS = {x * x % Q for x in range(1, Q)}          # {1,3,4,5,9}
NONRESIDUE = next(n for n in range(2, Q) if n not in QRS)   # 2


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


def mobius(m, t):
    a, b, c, d = m
    if t == 'inf':
        return 'inf' if c % Q == 0 else (a * pow(c, Q - 2, Q)) % Q
    num, den = (a * t + b) % Q, (c * t + d) % Q
    if den == 0:
        return 'inf'
    return (num * pow(den, Q - 2, Q)) % Q


def group(square_det):
    """Projective Mobius maps with square (PSL) or non-square det, normalized."""
    out = []
    for a in range(Q):
        for b in range(Q):
            for c in range(Q):
                for d in range(Q):
                    det = (a * d - b * c) % Q
                    if det == 0 or (det in QRS) != square_det:
                        continue
                    v = (a, b, c, d)
                    if next(x for x in v if x) != 1:      # projective normalization
                        continue
                    out.append(v)
    return out


labels = list(range(Q)) + ['inf']
cpt = {t: ((t * t % Q, t, 1) if t != 'inf' else (1, 0, 0)) for t in labels}

PSL = group(True)
OUTER = group(False)                       # the non-identity PGL/PSL coset
assert len(PSL) == 660, len(PSL)
assert len(OUTER) == 660, len(OUTER)
print(f"PSL(2,11): {len(PSL)} maps;  PGL\\PSL coset: {len(OUTER)} maps")


def is_steiner(blocks):
    """Every 5-subset of the 12 points lies in exactly one block."""
    cnt = Counter()
    for blk in blocks:
        for five in combinations(sorted(blk, key=str), 5):
            cnt[frozenset(five)] += 1
    return len(cnt) == 792 and set(cnt.values()) == {1}


def orbit_of(seed, grp):
    return {frozenset(mobius(m, t) for t in seed) for m in grp}


# ---- system 1: a PSL(2,11)-orbit that is Steiner -------------------------------
for seed in ({0, 1, 3, 4, 5, 9}, {'inf', 1, 3, 4, 5, 9}, {'inf', 0, 1, 3, 4, 5},
             {'inf', 0, 1, 2, 6, 9}, {'inf', 0, 3, 4, 5, 9}):
    sys1 = orbit_of(seed, PSL)
    if len(sys1) == 132 and is_steiner(sys1):
        print(f"system 1: PSL-orbit of {sorted(seed, key=str)} -> 132 blocks, Steiner VERIFIED")
        break
else:
    raise SystemExit("no Steiner seed worked")

# ---- system 2: image of system 1 under an outer (non-square-det) map -----------
g = (1, 0, 0, NONRESIDUE)                  # t -> t / nonresidue ; det = nonresidue
assert (g[0] * g[3] - g[1] * g[2]) % Q not in QRS
sys2 = {frozenset(mobius(g, t) for t in blk) for blk in sys1}

assert len(sys2) == 132, len(sys2)
assert is_steiner(sys2), "system 2 is NOT Steiner"
print(f"system 2: image of system 1 under t -> t/{NONRESIDUE} -> 132 blocks, Steiner VERIFIED")

# system 2 is also a PSL-orbit (PSL is normal in PGL, so an outer image of an orbit
# is an orbit) -- checked rather than assumed:
rep2 = next(iter(sys2))
assert orbit_of(rep2, PSL) == sys2, "system 2 is not a single PSL-orbit"
print("system 2 is a single PSL-orbit (PSL normal in PGL) -- CHECKED")

# ---- the two systems are distinct, disjoint, and swapped by the outer coset ----
assert sys1 != sys2, "the outer map fixed the system"
assert sys1.isdisjoint(sys2), "the two systems share a block"
print(f"systems disjoint: |sys1 U sys2| = {len(sys1 | sys2)} = 132 + 132")

back = {frozenset(mobius(g, t) for t in blk) for blk in sys2}
assert back == sys1, "the outer map does not swap the two systems"
print("the outer coset swaps system 1 <-> system 2 -- CHECKED (chirality motif)")

# every outer map carries sys1 to sys2 (not just the chosen one)
assert all({frozenset(mobius(m, t) for t in blk) for blk in sys1} == sys2 for m in OUTER)
print(f"all {len(OUTER)} outer maps carry system 1 -> system 2 -- CHECKED")

# ---- the invariant ------------------------------------------------------------
half_inv = pow(2, Q - 2, Q)


def pole(line):
    """Pole of a line under the polarity of XZ = Y^2."""
    l0, l1, l2 = line
    return norm(l2, (-half_inv * l1) % Q, l0)


def t_of(H):
    ps = [cpt[x] for x in H]
    poles = [pole(cross(a, b)) for a, b in combinations(ps, 2)]
    assert len(set(poles)) == 15                       # the 15 chords have distinct poles
    return sum(1 for x, y, z in combinations(poles, 3) if dot(cross(x, y), z) == 0)


spectrum = Counter()
t60 = set()
for H in combinations(labels, 6):
    t = t_of(H)
    spectrum[t] += 1
    if t == 60:
        t60.add(frozenset(H))

print(f"\nt-spectrum over all {sum(spectrum.values())} 6-subsets: {dict(sorted(spectrum.items()))}")

# ---- the claim ----------------------------------------------------------------
assert min(spectrum) == 60, "the forced lower bound t >= 60 FAILS"
assert 61 not in spectrum, "t = 61 occurs -- the spectrum gap is not real"
assert spectrum == Counter({60: 264, 62: 330, 63: 220, 64: 110}), spectrum
assert len(t60) == 264, len(t60)
assert t60 == (sys1 | sys2), "the t=60 stratum is NOT the union of the two systems"

print("\nnull t >= 60 (each point forces C(5,3)=10):        HOLDS, min = 60")
print("spectrum gap at 61:                                 HOLDS, 61 never occurs")
print("t=60 stratum == system 1 U system 2, exactly:       VERIFIED (264 = 132 + 132)")
print("\nCLAIM VERIFIED: a 6-subset of the conic has no three chords concurrent off it")
print("                iff it is a hexad of one of the two S(5,6,12) systems.")
