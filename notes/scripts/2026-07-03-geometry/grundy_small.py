#!/usr/bin/env python3
"""Full Grundy values (no alpha-beta) for small queen boards.
Validates vs A344227, gives root option-value multisets (deferred experiment 4
of the conjecture note) and G(R_n) for the central-diagonal residuals.
"""
import sys, time
sys.setrecursionlimit(100000)
from small_boards import build
from collections import Counter

def grundy_solve(n):
    attacks = build(n)
    N = n * n
    full = (1 << N) - 1
    memo = {}
    def grundy(avail):
        if avail == 0:
            return 0
        v = memo.get(avail)
        if v is not None:
            return v
        vals = set()
        a = avail
        while a:
            b = a & -a
            i = b.bit_length() - 1
            vals.add(grundy(avail & ~attacks[i]))
            a ^= b
        g = 0
        while g in vals:
            g += 1
        memo[avail] = g
        return g

    t0 = time.time()
    g_root = grundy(full)
    # root option multiset over D4 classes
    fs = [lambda r, c: (r, c), lambda r, c: (c, n-1-r), lambda r, c: (n-1-r, n-1-c),
          lambda r, c: (n-1-c, r), lambda r, c: (r, n-1-c), lambda r, c: (n-1-r, c),
          lambda r, c: (c, r), lambda r, c: (n-1-c, n-1-r)]
    seen = set(); reps = []
    for r in range(n):
        for c in range(n):
            if (r, c) in seen: continue
            orbit = {f(r, c) for f in fs}
            seen |= orbit; reps.append((r, c))
    opts = {}
    for (r, c) in reps:
        opts[(r, c)] = grundy(full & ~attacks[r * n + c])
    m = n // 2 - 1
    gR = opts.get((m, m)) if n % 2 == 0 else None
    hist = Counter(opts.values())
    print(f"n={n}: G={g_root}  (A344227 check)  root-option G-histogram (D4 classes): "
          f"{dict(sorted(hist.items()))}  "
          f"{'G(R_'+str(n)+')='+str(gR)+' (central strike residual)' if gR is not None else ''}"
          f"  [{len(memo)} positions, {time.time()-t0:.1f}s]")
    if n % 2 == 1:
        ctr = (n // 2, n // 2)
        print(f"     center option G = {opts[ctr]}; full option map: {opts}")

if __name__ == '__main__':
    for n in [5, 6, 7, 8, 9, 10]:
        grundy_solve(n)
