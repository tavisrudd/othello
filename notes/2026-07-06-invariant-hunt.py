"""Empirical invariant hunt for the grid cap game (= PG(2,q) residual).

Fully solve small q, label every reachable position P (mover loses) / N (mover wins).
Naive parity ("P iff |S| even") is FALSE for q>=9. Measure WHERE it fails and look for a
correction: what geometric feature distinguishes the exceptions?

For each position we record |S| and P/N. Hypothesis H0: P iff |S| even. Report the
exception rate and, for exceptions, structural features (does the position already have a
"blocked but unused" row? a near-full line? etc.).
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
    row_of = [0] * N
    col_of = [0] * N
    for i, (r, c) in enumerate(cells):
        row_of[i] = r
        col_of[i] = c
        m = 0
        for j, (r2, c2) in enumerate(cells):
            if i != j and (r2 == r or c2 == c):
                m |= 1 << j
        rc_mask[i] = m

    def cross(p, a, b):
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
                if k != i and k != j and cross(cells[i], cells[j], cells[k]):
                    m |= 1 << k
            line_third[i][j] = m
    return N, rc_mask, line_third, cells


def solve(q):
    N, rc_mask, line_third, cells = build(q)
    ALL = (1 << N) - 1
    memo = {}          # chosen -> (pn, size)   pn: True=N(mover wins), False=P(mover loses)
    # we must also carry 'forbidden' but it is a function of chosen; recompute lazily is slow.
    # Instead memo on chosen only (forbidden determined by chosen). Store forbidden too.

    def forb(chosen):
        f = 0
        cc = chosen
        idxs = []
        while cc:
            b = cc & (-cc)
            cc ^= b
            idxs.append(b.bit_length() - 1)
        for a in idxs:
            f |= rc_mask[a]
        for x in range(len(idxs)):
            for y in range(x + 1, len(idxs)):
                f |= line_third[idxs[x]][idxs[y]]
        return f

    def g(chosen):
        v = memo.get(chosen)
        if v is not None:
            return v
        f = forb(chosen)
        avail = ALL & ~chosen & ~f
        size = bin(chosen).count("1")
        pn = False  # assume P (mover loses); becomes N if any move leads to P
        a = avail
        while a:
            y = a & (-a)
            a ^= y
            child = chosen | y
            cpn, _ = g(child)
            if cpn is False:  # child is P => mover can move to a P => mover wins => N
                pn = True
                break
        memo[chosen] = (pn, size)
        return memo[chosen]

    g(0)
    return memo


def analyze(q):
    memo = solve(q)
    # naive H0: P iff size even.  P == (pn is False).
    exc_even_but_N = 0     # size even but position is N (mover wins) -> P2 can't just rely on parity
    exc_odd_but_P = 0      # size odd but position is P
    total = len(memo)
    p_by_size = Counter()
    n_by_size = Counter()
    for chosen, (pn, size) in memo.items():
        if pn:
            n_by_size[size] += 1
        else:
            p_by_size[size] += 1
        isP = not pn
        if size % 2 == 0 and not isP:
            exc_even_but_N += 1
        if size % 2 == 1 and isP:
            exc_odd_but_P += 1
    root_pn = memo[0][0]
    print(f"q={q}: states={total} root={'N (1st wins)' if root_pn else 'P (2nd wins)'}")
    sizes = sorted(set(p_by_size) | set(n_by_size))
    print("  size :  P-count  N-count")
    for s in sizes:
        print(f"  {s:>4} : {p_by_size.get(s,0):>8} {n_by_size.get(s,0):>8}")
    print(f"  H0 exceptions: even-but-N={exc_even_but_N}  odd-but-P={exc_odd_but_P}"
          f"  (total {exc_even_but_N+exc_odd_but_P}/{total})", flush=True)


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [3, 5, 7]
    for q in qs:
        analyze(q)
    print("HUNT_DONE")
