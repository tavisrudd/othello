#!/usr/bin/env python3
"""Bounded-interaction sum experiments (2026-07-03).

Setting: Node-Kayles position decomposing as A ⊔ B plus a small set of cross
edges. k=0 is Sprague-Grundy XOR. These experiments map which hypotheses on the
cross edges bound |G(A +x B) - G(A)^G(B)| or preserve outcome, and which fail
(with minimal counterexamples).

exp1  one uniform cross edge, random A,B          -> delta-G histogram
exp1b pendant reduction (A = K1)                  -> max shift sweep
exp2  clique-interface complete-cross (<=2 events) -> delta-G histogram
exp3  symmetric doubles + m defect pairs          -> max G ladder (D1-general test)
exp4  hypothesis kills: P-preserving / simplicial / dead-zone endpoints
"""
import random, itertools
from collections import Counter

def grundy(att, full):
    memo = {}
    def g(avail):
        if avail == 0:
            return 0
        v = memo.get(avail)
        if v is not None:
            return v
        seen = set()
        a = avail
        while a:
            b = a & -a
            s = b.bit_length() - 1
            a ^= b
            seen.add(g(avail & ~att[s]))
        v = 0
        while v in seen:
            v += 1
        memo[avail] = v
        return v
    return g(full)

def rand_graph(k, p, rng):
    att = [1 << i for i in range(k)]
    for i in range(k):
        for j in range(i+1, k):
            if rng.random() < p:
                att[i] |= 1 << j
                att[j] |= 1 << i
    return att

def join(attA, attB, cross):
    """cross: list of (u in A-index, v in B-index). Returns joint att masks."""
    ka, kb = len(attA), len(attB)
    att = [attA[i] for i in range(ka)] + [attB[j] << ka for j in range(kb)]
    for (u, v) in cross:
        att[u] |= 1 << (ka + v)
        att[ka + v] |= 1 << u
    return att

def exp1(rng, samples=1500):
    print('== exp1: one random cross edge between random A, B ==')
    hist = Counter()
    worst = None
    flips = 0
    tot = 0
    for (ka, kb) in [(4, 4), (5, 5), (6, 5)]:
        for _ in range(samples):
            A = rand_graph(ka, 0.4, rng)
            B = rand_graph(kb, 0.4, rng)
            gA = grundy(A, (1 << ka) - 1)
            gB = grundy(B, (1 << kb) - 1)
            u = rng.randrange(ka)
            v = rng.randrange(kb)
            gJ = grundy(join(A, B, [(u, v)]), (1 << (ka+kb)) - 1)
            d = abs(gJ - (gA ^ gB))
            hist[d] += 1
            tot += 1
            if ((gA ^ gB) == 0) != (gJ == 0):
                flips += 1
            if worst is None or d > worst[0]:
                worst = (d, ka, kb, gA, gB, gJ)
    print(f'  |G_joined - G_A^G_B| histogram: {dict(sorted(hist.items()))}')
    print(f'  outcome flips: {flips}/{tot}   worst: |d|={worst[0]} '
          f'(|A|={worst[1]},|B|={worst[2]}, gA={worst[3]}, gB={worst[4]}, gJ={worst[5]})')

def exp1b(rng, samples=800):
    print('== exp1b: pendant reduction A=K1 (single cross edge = pendant add) ==')
    worst = 0
    hist = Counter()
    for kb in (7, 8, 9):
        for p in (0.25, 0.4):
            for _ in range(samples):
                B = rand_graph(kb, p, rng)
                gB = grundy(B, (1 << kb) - 1)
                v = rng.randrange(kb)
                gJ = grundy(join([1], B, [(0, v)]), (1 << (kb+1)) - 1)
                d = abs(gJ - (gB ^ 1))
                hist[d] += 1
                worst = max(worst, d)
    print(f'  |G(B+pendant) - G_B^1| histogram: {dict(sorted(hist.items()))}  max={worst}')

def exp2(rng, samples=1500):
    print('== exp2: clique interfaces X_A, X_B + complete bipartite cross ==')
    hist = Counter()
    flips = 0
    tot = 0
    worst = None
    for _ in range(samples * 3):
        ka = kb = 6
        A = rand_graph(ka, 0.4, rng)
        B = rand_graph(kb, 0.4, rng)
        sa = rng.choice([1, 2, 3])
        sb = rng.choice([1, 2, 3])
        XA = rng.sample(range(ka), sa)
        XB = rng.sample(range(kb), sb)
        for i, j in itertools.combinations(XA, 2):  # force cliques
            A[i] |= 1 << j
            A[j] |= 1 << i
        for i, j in itertools.combinations(XB, 2):
            B[i] |= 1 << j
            B[j] |= 1 << i
        gA = grundy(A, (1 << ka) - 1)
        gB = grundy(B, (1 << kb) - 1)
        cross = [(u, v) for u in XA for v in XB]
        gJ = grundy(join(A, B, cross), (1 << (ka+kb)) - 1)
        d = abs(gJ - (gA ^ gB))
        hist[d] += 1
        tot += 1
        if ((gA ^ gB) == 0) != (gJ == 0):
            flips += 1
        if worst is None or d > worst[0]:
            worst = (d, sa, sb, gA, gB, gJ)
    print(f'  histogram: {dict(sorted(hist.items()))}')
    print(f'  outcome flips: {flips}/{tot}   worst d={worst[0]} '
          f'(|XA|={worst[1]},|XB|={worst[2]}, gA={worst[3]}, gB={worst[4]}, gJ={worst[5]})')

def make_double(k, in_edges, cross_pairs, defects):
    """Symmetric double: sides L=0..k-1, R=k..2k-1, mirror i <-> i+k.
    in_edges: iterable of (i,j) i<j within L (mirrored to R).
    cross_pairs: iterable of (i,j), i != j -> edges (i, j+k) AND (j, i+k).
    defects: iterable of i -> edge (i, i+k)."""
    N = 2 * k
    att = [1 << i for i in range(N)]
    def add(a, b):
        att[a] |= 1 << b
        att[b] |= 1 << a
    for (i, j) in in_edges:
        add(i, j)
        add(i + k, j + k)
    for (i, j) in cross_pairs:
        add(i, j + k)
        add(j, i + k)
    for i in defects:
        add(i, i + k)
    return att

def exp3_exhaustive(k):
    print(f'== exp3: symmetric doubles, exhaustive k={k} ==')
    pairs = list(itertools.combinations(range(k), 2))
    maxg = {}
    ce = {}
    for in_bits in range(1 << len(pairs)):
        in_edges = [pairs[t] for t in range(len(pairs)) if in_bits >> t & 1]
        for cr_bits in range(1 << len(pairs)):
            cross = [pairs[t] for t in range(len(pairs)) if cr_bits >> t & 1]
            for m in range(k + 1):
                for defects in itertools.combinations(range(k), m):
                    att = make_double(k, in_edges, cross, defects)
                    g = grundy(att, (1 << (2*k)) - 1)
                    if g > maxg.get(m, -1):
                        maxg[m] = g
                        ce[m] = (in_edges, cross, defects)
    for m in sorted(maxg):
        print(f'  m={m}: max G = {maxg[m]}   witness: in={ce[m][0]} cross={ce[m][1]} defect={ce[m][2]}')

def exp3_sampled(rng, k, samples=3000):
    print(f'== exp3: symmetric doubles, sampled k={k} ==')
    pairs = list(itertools.combinations(range(k), 2))
    for m in range(0, 4):
        maxg = -1
        wit = None
        hist = Counter()
        for _ in range(samples):
            in_edges = [pq for pq in pairs if rng.random() < 0.35]
            cross = [pq for pq in pairs if rng.random() < 0.15]
            defects = rng.sample(range(k), m)
            att = make_double(k, in_edges, cross, defects)
            g = grundy(att, (1 << (2*k)) - 1)
            hist[g] += 1
            if g > maxg:
                maxg = g
                wit = (in_edges, cross, defects)
        print(f'  m={m}: G histogram {dict(sorted(hist.items()))}  max={maxg}')
        if maxg > (0 if m == 0 else 2*m - 1):
            print(f'      witness: in={wit[0]} cross={wit[1]} defect={wit[2]}')

def exp4(rng):
    print('== exp4: hypothesis kills (single cross edge, endpoint conditions) ==')
    # (i) P-preserving endpoints: G(A-u)=G(A), G(B-v)=G(B) -> outcome preserved?
    found = None
    for trial in range(60000):
        ka = rng.choice([3, 4, 5])
        kb = rng.choice([3, 4, 5])
        A = rand_graph(ka, 0.45, rng)
        B = rand_graph(kb, 0.45, rng)
        fullA, fullB = (1 << ka) - 1, (1 << kb) - 1
        gA = grundy(A, fullA)
        gB = grundy(B, fullB)
        u = rng.randrange(ka)
        v = rng.randrange(kb)
        if grundy(A, fullA & ~(1 << u)) != gA:
            continue
        if grundy(B, fullB & ~(1 << v)) != gB:
            continue
        gJ = grundy(join(A, B, [(u, v)]), (1 << (ka+kb)) - 1)
        if ((gA ^ gB) == 0) != (gJ == 0):
            found = (ka, kb, A, B, u, v, gA, gB, gJ)
            break
    if found:
        ka, kb, A, B, u, v, gA, gB, gJ = found
        print(f'  P-preserving endpoints: COUNTEREXAMPLE |A|={ka} |B|={kb} '
              f'u={u} v={v} gA={gA} gB={gB} gJ={gJ}')
        print(f'    A adj: {[bin(a) for a in A]}  B adj: {[bin(b) for b in B]}')
    else:
        print('  P-preserving endpoints: no outcome flip found (checked random field)')
    # (ii) simplicial endpoints
    found = None
    hist = Counter()
    for trial in range(60000):
        ka = rng.choice([4, 5, 6])
        kb = rng.choice([4, 5, 6])
        A = rand_graph(ka, 0.45, rng)
        B = rand_graph(kb, 0.45, rng)
        u = rng.randrange(ka)
        v = rng.randrange(kb)
        def simplicial(att, x, kk):
            nb = [i for i in range(kk) if i != x and att[x] >> i & 1]
            return all(att[i] >> j & 1 for i, j in itertools.combinations(nb, 2))
        if not simplicial(A, u, ka) or not simplicial(B, v, kb):
            continue
        gA = grundy(A, (1 << ka) - 1)
        gB = grundy(B, (1 << kb) - 1)
        gJ = grundy(join(A, B, [(u, v)]), (1 << (ka+kb)) - 1)
        d = abs(gJ - (gA ^ gB))
        hist[d] += 1
        if ((gA ^ gB) == 0) != (gJ == 0) and found is None:
            found = (ka, kb, u, v, gA, gB, gJ)
    print(f'  simplicial endpoints: delta hist {dict(sorted(hist.items()))}  '
          f'{"COUNTEREXAMPLE " + str(found) if found else "no flip found"}')
    # (iii) dead zone: all cross A-endpoints inside N_A[w] for one w
    found = None
    for trial in range(60000):
        ka, kb = 5, 5
        A = rand_graph(ka, 0.45, rng)
        B = rand_graph(kb, 0.45, rng)
        w = rng.randrange(ka)
        nbw = [i for i in range(ka) if A[w] >> i & 1]
        if len(nbw) < 2:
            continue
        us = rng.sample(nbw, 2)
        vs = rng.sample(range(kb), 2)
        cross = list(zip(us, vs))
        gA = grundy(A, (1 << ka) - 1)
        gB = grundy(B, (1 << kb) - 1)
        gJ = grundy(join(A, B, cross), (1 << (ka+kb)) - 1)
        if ((gA ^ gB) == 0) != (gJ == 0):
            found = (A, B, w, cross, gA, gB, gJ)
            break
    print(f'  dead-zone (cross endpoints in N[w]): '
          f'{"COUNTEREXAMPLE gA=%d gB=%d gJ=%d" % found[4:] if found else "no flip found"}')

if __name__ == '__main__':
    rng = random.Random(20260703)
    exp1(rng)
    exp1b(rng)
    exp2(rng)
    exp3_exhaustive(3)
    exp3_sampled(rng, 5)
    exp3_sampled(rng, 6, samples=1500)
    exp4(rng)
