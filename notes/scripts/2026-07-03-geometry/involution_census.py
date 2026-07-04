#!/usr/bin/env python3
"""Defective-involution census for placement-game families (2026-07-03).

For each (piece, board-topology, n): enumerate a pool of candidate involutions
(point reflections, axis reflections, transposes, half-period translations),
keep those that are graph automorphisms, and compute the obstruction set
  Obs(f) = Fix(f) ∪ F(f),  F(f) = {s : f(s) != s and s ~ f(s)}.
Reports the minimum |Obs| over the pool and classifies:
  EMPTY            -> mirror-solved outright (Copying Lemma, G=0 for the mover-loss side)
  STEAL            -> Obs ⊆ N[p] for a unique fixed p (center-steal repairable, G>=1)
  THIN             -> |Obs| = O(n) out of n^2
  FAT              -> |Obs| = Θ(n^2)
Also computes exact Grundy values for the special graphs (hypercube, Petersen,
Kneser K(6,3), cycles/circulants, small torus pieces) as sanity anchors.
"""
import sys, time
sys.setrecursionlimit(100000)
from cgtlib import make_grundy

STEPS = {
    'grid':   [(1,0),(-1,0),(0,1),(0,-1)],
    'king':   [(a,b) for a in (-1,0,1) for b in (-1,0,1) if (a,b)!=(0,0)],
    'knight': [(1,2),(2,1),(-1,2),(-2,1),(1,-2),(2,-1),(-1,-2),(-2,-1)],
}

def build_attacks(n, piece, wrap_r=False, wrap_c=False):
    """Closed-neighborhood bitmasks. Ray pieces: rows/cols never wrap-dependent
    (equality is equality); diagonals wrap in the wrapped coordinate(s)."""
    N = n*n
    att = [0]*N
    for r in range(n):
        for c in range(n):
            s = r*n + c
            m = 1 << s
            for r2 in range(n):
                for c2 in range(n):
                    if (r2, c2) == (r, c):
                        continue
                    dr, dc = r2 - r, c2 - c
                    hit = False
                    if piece in ('rook', 'queen') and (dr == 0 or dc == 0):
                        hit = True
                    if not hit and piece in ('bishop', 'queen'):
                        if wrap_r and wrap_c:
                            hit = (dr - dc) % n == 0 or (dr + dc) % n == 0
                        elif wrap_c:      # cylinder: r exact, c mod n
                            hit = (dc - dr) % n == 0 or (dc + dr) % n == 0
                        elif wrap_r:
                            hit = (dr - dc) % n == 0 or (dr + dc) % n == 0
                        else:
                            hit = dr == dc or dr == -dc
                    if not hit and piece in STEPS:
                        for (a, b) in STEPS[piece]:
                            rr = (r + a) % n if wrap_r else r + a
                            cc = (c + b) % n if wrap_c else c + b
                            if rr == r2 and cc == c2:
                                hit = True
                                break
                    if hit:
                        m |= 1 << (r2*n + c2)
            att[s] = m
    return att

def involution_pool(n, wrap_r, wrap_c):
    out = []
    A_range = range(n) if wrap_r else [n-1]
    B_range = range(n) if wrap_c else [n-1]
    for A in A_range:
        for B in B_range:
            out.append((f'point({A},{B})',
                        lambda r, c, A=A, B=B: ((A-r) % n, (B-c) % n)))
    for A in A_range:
        out.append((f'axis-r({A})', lambda r, c, A=A: ((A-r) % n, c)))
    for B in B_range:
        out.append((f'axis-c({B})', lambda r, c, B=B: (r, (B-c) % n)))
    if wrap_r == wrap_c:  # transpose maps need a symmetric topology
        G_range = range(n) if wrap_r else [0]
        for g in G_range:
            out.append((f'transp({g})', lambda r, c, g=g: ((c+g) % n, (r-g) % n)))
        out.append(('anti-transp', lambda r, c: ((n-1-c) % n, (n-1-r) % n)))
    if wrap_r and wrap_c and n % 2 == 0:
        h = n // 2
        for (dr, dc) in [(h, 0), (0, h), (h, h)]:
            out.append((f'transl({dr},{dc})',
                        lambda r, c, dr=dr, dc=dc: ((r+dr) % n, (c+dc) % n)))
    return out

def census(n, piece, wrap_r, wrap_c, verbose_shape=False):
    att = build_attacks(n, piece, wrap_r, wrap_c)
    N = n*n
    cands = []
    for name, f in involution_pool(n, wrap_r, wrap_c):
        perm = [0]*N
        ok = True
        for r in range(n):
            for c in range(n):
                rr, cc = f(r, c)
                if not (0 <= rr < n and 0 <= cc < n):
                    ok = False
                    break
                perm[r*n+c] = rr*n + cc
            if not ok:
                break
        if not ok or any(perm[perm[s]] != s for s in range(N)):
            continue
        if all(perm[s] == s for s in range(N)):
            continue
        # automorphism check
        auto = True
        for s in range(N):
            img = 0
            m = att[s]
            while m:
                b = m & -m
                img |= 1 << perm[b.bit_length()-1]
                m ^= b
            if img != att[perm[s]]:
                auto = False
                break
        if not auto:
            continue
        fix = [s for s in range(N) if perm[s] == s]
        F = [s for s in range(N) if perm[s] != s and att[s] >> perm[s] & 1]
        obs = set(fix) | set(F)
        if not obs:
            cls = 'EMPTY'
        elif len(fix) == 1 and all(att[fix[0]] >> s & 1 for s in obs):
            cls = 'STEAL'
        elif len(obs) <= 6*n:
            cls = 'THIN'
        else:
            cls = 'FAT'
        cands.append((cls, len(obs), name, obs, fix, F))
    if not cands:
        return None
    rank = {'EMPTY': 0, 'STEAL': 1, 'THIN': 2, 'FAT': 3}
    cands.sort(key=lambda x: (rank[x[0]], x[1]))
    cls, o, name, obs, fix, F = cands[0]
    shape = ''
    if verbose_shape and obs:
        shape = ' obs=' + ','.join(f'({s//n},{s%n})' for s in sorted(obs))
    return name, o, len(fix), len(F), cls, shape

def main_census():
    topos = [('plane', False, False), ('cylinder', False, True), ('torus', True, True)]
    pieces = ['grid', 'king', 'knight', 'rook', 'bishop', 'queen']
    for topo, wr, wc in topos:
        print(f'== {topo} ==')
        for piece in pieces:
            for n in (4, 5, 6, 7, 8):
                r = census(n, piece, wr, wc, verbose_shape=(n == 6))
                if r:
                    name, o, nf, nF, cls, shape = r
                    print(f'  {piece:7s} n={n}: min|Obs|={o:3d} (fix={nf}, F={nF}) '
                          f'class={cls:5s} via {name}{shape}')
        print()

# ---- exact values for special graphs ----
def grundy_of(att):
    N = len(att)
    g, _ = make_grundy(att, N)
    return g((1 << N) - 1)

def hypercube_att(d):
    N = 1 << d
    return [ (1 << x) | sum(1 << (x ^ (1 << i)) for i in range(d)) for x in range(N) ]

def kneser_att(n, k):
    from itertools import combinations
    vs = list(combinations(range(n), k))
    idx = {v: i for i, v in enumerate(vs)}
    att = []
    for v in vs:
        m = 1 << idx[v]
        sv = set(v)
        for w in vs:
            if not (sv & set(w)):
                m |= 1 << idx[w]
        att.append(m)
    return att

def cycle_att(k):
    return [ (1 << i) | (1 << ((i+1) % k)) | (1 << ((i-1) % k)) for i in range(k) ]

def main_specials():
    print('== special graphs (exact Grundy) ==')
    for d in (1, 2, 3, 4):
        print(f'  hypercube Q_{d}: G = {grundy_of(hypercube_att(d))}')
    print(f'  Petersen K(5,2): G = {grundy_of(kneser_att(5, 2))}')
    print(f'  Kneser  K(6,3): G = {grundy_of(kneser_att(6, 3))}  '
          f'(graph = perfect matching on 10 pairs -> predict 0)')
    print('  cycles C_k: ' + ' '.join(
        f'C{k}={grundy_of(cycle_att(k))}' for k in range(3, 13)))
    for piece, n, note in [('knight', 4, 'even torus knight: parity dodge predicts 0'),
                           ('grid',   4, 'even torus grid:   parity dodge predicts 0'),
                           ('bishop', 4, 'even torus bishop: parity dodge predicts 0'),
                           ('bishop', 6, 'even torus bishop n=6'),
                           ('king',   4, 'even torus king: 4 isolated fixed squares'),
                           ('rook',   4, 'torus rook = plane rook, parity law 0'),
                           ('grid',   4, 'plane even grid: F empty predicts 0')]:
        wrap = 'torus' in note or 'torus' == note.split()[1] if False else None
        wr = wc = ('torus' in note)
        t0 = time.time()
        g = grundy_of(build_attacks(n, piece, wr, wc))
        print(f'  {"torus" if wr else "plane"} {piece} n={n}: G = {g}   '
              f'[{note}] ({time.time()-t0:.1f}s)')

if __name__ == '__main__':
    main_census()
    main_specials()
