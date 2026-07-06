"""Characterize the parity-law exceptions at q=9 (grid cap game).

Naive law 'P iff |S| even' holds for q<=7, breaks at q=9. Two exception classes:
  (E1) even-but-N : |S| even yet mover WINS  (a trap P2 must avoid entering)
  (E2) odd-but-P  : |S| odd  yet mover LOSES (P2 stuck; includes odd maximal caps)

Questions:
  - Are the odd-but-P positions EXACTLY the maximal ones? (maximal => P always)
  - Structural signature of each exception class: #empty rows/cols, #free cells still
    open (empty-row x empty-col cells not yet forbidden), etc.
"""
import sys
from itertools import product
from collections import Counter
from gf import GF

sys.setrecursionlimit(1 << 22)


def build(q):
    F = GF(q)
    cells = list(product(range(q), repeat=2))
    N = len(cells)
    rc_mask = [0] * N
    row_of = [c[0] for c in cells]
    col_of = [c[1] for c in cells]
    for i, (r, c) in enumerate(cells):
        m = 0
        for j, (r2, c2) in enumerate(cells):
            if i != j and (r2 == r or c2 == c):
                m |= 1 << j
        rc_mask[i] = m

    def crossf(p, a, b):
        ux, uy = F.sub(a[0], p[0]), F.sub(a[1], p[1])
        wx, wy = F.sub(b[0], p[0]), F.sub(b[1], p[1])
        return F.sub(F.mul(ux, wy), F.mul(uy, wx)) == 0

    line_third = [[0] * N for _ in range(N)]
    for i in range(N):
        for j in range(N):
            if i == j:
                continue
            m = 0
            for k in range(N):
                if k != i and k != j and crossf(cells[i], cells[j], cells[k]):
                    m |= 1 << k
            line_third[i][j] = m
    return N, rc_mask, line_third, cells, row_of, col_of


def solve(q):
    N, rc_mask, line_third, cells, row_of, col_of = build(q)
    ALL = (1 << N) - 1
    memo = {}

    def forb(chosen):
        f = 0
        idxs = []
        cc = chosen
        while cc:
            b = cc & (-cc); cc ^= b
            idxs.append(b.bit_length() - 1)
        for a in idxs:
            f |= rc_mask[a]
        for x in range(len(idxs)):
            for y in range(x + 1, len(idxs)):
                f |= line_third[idxs[x]][idxs[y]]
        return f, idxs

    def g(chosen):
        v = memo.get(chosen)
        if v is not None:
            return v[0]
        f, idxs = forb(chosen)
        avail = ALL & ~chosen & ~f
        pn = False
        a = avail
        while a:
            y = a & (-a); a ^= y
            if g(chosen | y) is False:
                pn = True
                break
        memo[chosen] = (pn, len(idxs), avail)
        return pn

    g(0)
    return memo, N, cells, row_of, col_of


def analyze(q):
    memo, N, cells, row_of, col_of = solve(q)
    e1 = Counter()   # even-but-N by (#free open cells)
    e2 = Counter()
    odd_P = 0
    odd_P_maximal = 0
    e1_sig = Counter()
    e2_sig = Counter()
    for chosen, (pn, size, avail) in memo.items():
        isP = not pn
        maximal = (avail == 0)
        # empty rows/cols
        used_rows = set()
        used_cols = set()
        cc = chosen
        while cc:
            b = cc & (-cc); cc ^= b
            i = b.bit_length() - 1
            used_rows.add(row_of[i]); used_cols.add(col_of[i])
        er = q - len(used_rows); ec = q - len(used_cols)
        navail = bin(avail).count("1")
        if size % 2 == 0 and not isP:
            e1_sig[(size, er, ec, navail)] += 1
        if size % 2 == 1 and isP:
            odd_P += 1
            if maximal:
                odd_P_maximal += 1
            e2_sig[(size, er, ec, navail, maximal)] += 1
    print(f"q={q}: odd-but-P total={odd_P}  of which maximal={odd_P_maximal}"
          f"  non-maximal={odd_P - odd_P_maximal}")
    print("  E2 (odd-but-P) signatures (size,emptyR,emptyC,#avail,maximal): count")
    for k, v in sorted(e2_sig.items()):
        print(f"     {k}: {v}")
    print("  E1 (even-but-N) signatures (size,emptyR,emptyC,#avail): count")
    for k, v in sorted(e1_sig.items()):
        print(f"     {k}: {v}")
    print(flush=True)


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [9]
    for q in qs:
        analyze(q)
    print("EXC_DONE")
