"""Measure the SIZE-3 ESCAPE MARGIN for the frame reduction's crux.

Frame reduction (2026-07-06-frame-reduction.md): PG(2,q)=P  <=>  every size-3 grid position
has a P size-4 child.  This script computes, over ALL legal size-3 grid positions, the number
of P (size-4) children each has -- the "escape margin".  The crux needs min >= 1 for all q.
Watching the minimum (and its growth) is a finer falsification signal than min-dev-size:
if the minimum ever hits 0, some size-3 position is trapped (all size-4 children N) => frame
would be N => PG(2,q)=N (counterexample).

Grid game as in 2026-07-05-grid-game.py.  Full P/N memo, then post-process size-3 nodes.
"""
import sys
from itertools import product
from gf import GF
sys.setrecursionlimit(1 << 20)


def solve(q):
    F = GF(q)
    cells = list(product(range(q), repeat=2))
    N = len(cells)

    def cross(p, a, b):
        ux, uy = F.sub(a[0], p[0]), F.sub(a[1], p[1])
        wx, wy = F.sub(b[0], p[0]), F.sub(b[1], p[1])
        return F.sub(F.mul(ux, wy), F.mul(uy, wx)) == 0

    row_mask = [0] * N; col_mask = [0] * N
    for i, (r, c) in enumerate(cells):
        for j, (r2, c2) in enumerate(cells):
            if i == j:
                continue
            if r2 == r: row_mask[i] |= 1 << j
            if c2 == c: col_mask[i] |= 1 << j
    rc_mask = [row_mask[i] | col_mask[i] for i in range(N)]
    line_third = [[0] * N for _ in range(N)]
    for i in range(N):
        for j in range(N):
            if i == j: continue
            m = 0
            for k in range(N):
                if k != i and k != j and cross(cells[i], cells[j], cells[k]):
                    m |= 1 << k
            line_third[i][j] = m

    ALL = (1 << N) - 1
    memo = {}

    def add_forbid(forbidden, chosen, yi):
        nf = forbidden | rc_mask[yi]
        c = chosen
        while c:
            b = c & (-c); c ^= b
            nf |= line_third[yi][b.bit_length() - 1]
        return nf

    def g(chosen, forbidden):
        v = memo.get(chosen)
        if v is not None:
            return v
        avail = ALL & ~chosen & ~forbidden
        res = 0
        a = avail
        while a:
            y = a & (-a); a ^= y
            yi = y.bit_length() - 1
            nf = add_forbid(forbidden, chosen, yi)
            if g(chosen | y, nf) == 0:
                res = 1
                break
        memo[chosen] = res
        return res

    root = g(0, 0)

    # enumerate all legal size-3 positions; for each count P size-4 children.
    # (rebuild forbidden as we go; only need popcount==3 chosen masks that were memoized)
    from collections import Counter
    margins = Counter()
    minmargin = None
    minrep = [None]      # cells of a min-achieving triangle + (total legal ext, P ext)
    # DFS to collect size-3 legal positions with their forbidden masks
    def dfs(chosen, forbidden, depth, start):
        nonlocal minmargin
        if depth == 3:
            avail = ALL & ~chosen & ~forbidden
            nP = 0; ntot = 0
            a = avail
            while a:
                y = a & (-a); a ^= y
                yi = y.bit_length() - 1
                ntot += 1
                nf = add_forbid(forbidden, chosen, yi)
                if g(chosen | y, nf) == 0:   # child is P
                    nP += 1
            margins[nP] += 1
            if minmargin is None or nP < minmargin:
                minmargin = nP
                tri = [cells[i] for i in range(N) if (chosen >> i) & 1]
                minrep[0] = (tri, ntot, nP)
            return
        avail = ALL & ~chosen & ~forbidden
        a = avail
        while a:
            y = a & (-a); a ^= y
            yi = y.bit_length() - 1
            if yi < start:
                continue
            nf = add_forbid(forbidden, chosen, yi)
            dfs(chosen | y, nf, depth + 1, yi + 1)

    dfs(0, 0, 0, 0)
    return root, minmargin, dict(sorted(margins.items())), len(memo), minrep[0]


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [3, 5, 7, 9]
    print(f"{'q':>3} {'root':>4} {'min-escape':>10}  margin-histogram(#Pchildren:count)")
    for q in qs:
        root, mn, hist, st, rep = solve(q)
        if mn is None:
            print(f"{q:>3} {'P' if root==0 else 'N':>4} {'(none)':>10}  "
                  f"no size-3 positions (frame is a maximal cap, size 2)", flush=True)
            continue
        hs = " ".join(f"{k}:{v}" for k, v in hist.items())
        print(f"{q:>3} {'P' if root==0 else 'N':>4} {mn:>10}  {hs}", flush=True)
        if rep is not None:
            tri, ntot, nP = rep
            print(f"       min-triangle {tri}  total-ext={ntot} P-ext={nP} "
                  f"(N-ext={ntot-nP})", flush=True)
    print("ESCAPE_MARGIN_DONE")
