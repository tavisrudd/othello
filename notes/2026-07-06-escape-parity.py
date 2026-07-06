"""Test a PARITY SHORTCUT for the escape crux (2026-07-06-frame-reduction.md).

For every legal size-3 grid position S3 (a 3-cell partial-permutation cap), let
  total(S3) = # legal size-4 extensions,
  bad(S3)   = # extensions to an even-N (odd-maximal-completable) size-4 position,
  escape    = total - bad = # P size-4 children.
The crux needs escape >= 1.  If total were always ODD and bad always EVEN, escape would be odd
=> >= 1, proving the frame is P.  This script tabulates the parities of total, bad, escape over
ALL size-3 positions, to confirm or KILL that shortcut.
"""
import sys
from itertools import product
from gf import GF
from collections import Counter
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

    g(0, 0)

    tot_par = Counter(); bad_par = Counter(); esc_par = Counter()
    esc_min = None
    tot_vals = Counter()
    def dfs(chosen, forbidden, depth, start):
        nonlocal esc_min
        if depth == 3:
            avail = ALL & ~chosen & ~forbidden
            tot = 0; nP = 0
            a = avail
            while a:
                y = a & (-a); a ^= y
                yi = y.bit_length() - 1
                tot += 1
                nf = add_forbid(forbidden, chosen, yi)
                if g(chosen | y, nf) == 0:
                    nP += 1
            bad = tot - nP
            tot_par[tot & 1] += 1
            bad_par[bad & 1] += 1
            esc_par[nP & 1] += 1
            tot_vals[tot] += 1
            if esc_min is None or nP < esc_min:
                esc_min = nP
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
    return esc_min, tot_par, bad_par, esc_par, dict(sorted(tot_vals.items()))


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [5, 7, 9, 11]
    for q in qs:
        em, tp, bp, ep, tv = solve(q)
        print(f"q={q:>2}  min-escape={em}", flush=True)
        print(f"       total  parity {{odd:{tp[1]}, even:{tp[0]}}}  distinct-totals={tv}")
        print(f"       bad    parity {{odd:{bp[1]}, even:{bp[0]}}}")
        print(f"       escape parity {{odd:{ep[1]}, even:{ep[0]}}}", flush=True)
    print("ESCAPE_PARITY_DONE")
