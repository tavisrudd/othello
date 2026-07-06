"""Test the COUNTING route for the q-odd planar cap game.

Grid game = PG(2,q) residual (2026-07-05-grid-game.py): cells of F_q x F_q, legal =
partial permutation matrix (<=1/row, <=1/col) AND affine cap (no 3 collinear). P1 first.

CLAIM UNDER TEST: every MAXIMAL legal position (no cell addable) has EVEN size.
If true => every play line ends after an even number of moves => P2 makes the last move
=> P2 wins with NO strategy => PG(2,q)=P, uniformly, for free.

We enumerate every legal set exactly once (adding cells in increasing index order) and
record the size-parity of the maximal ones. Also report the full size distribution of
maximal positions so we can see the structure if parity is mixed.
"""
import sys
from itertools import product
from collections import Counter
from gf import GF


def build(q):
    F = GF(q)
    cells = list(product(range(q), repeat=2))
    N = len(cells)

    def cross(p, a, b):
        ux, uy = F.sub(a[0], p[0]), F.sub(a[1], p[1])
        wx, wy = F.sub(b[0], p[0]), F.sub(b[1], p[1])
        return F.sub(F.mul(ux, wy), F.mul(uy, wx)) == 0

    row_mask = [0] * N
    col_mask = [0] * N
    for i, (r, c) in enumerate(cells):
        for j, (r2, c2) in enumerate(cells):
            if i == j:
                continue
            if r2 == r:
                row_mask[i] |= 1 << j
            if c2 == c:
                col_mask[i] |= 1 << j
    rc_mask = [row_mask[i] | col_mask[i] for i in range(N)]
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
    return N, rc_mask, line_third


def maximal_sizes(q):
    N, rc_mask, line_third = build(q)
    ALL = (1 << N) - 1
    sizes = Counter()

    # DFS: add cells in strictly increasing index; forbidden = blocked cells; avail(next)
    # restricted to indices > last added. Maximal <=> NO cell (any index) addable.
    def rec(chosen, forbidden, size, start):
        # can any cell at all be added (for maximality test, over ALL indices)?
        avail_all = ALL & ~chosen & ~forbidden
        if avail_all == 0:
            sizes[size] += 1
            return
        # recurse only on cells with index >= start (dedupe), whole set still enumerated
        a = avail_all & ~((1 << start) - 1)
        # if no higher-index cell addable but lower ones exist, this set is not maximal
        # and its maximal extensions are reached via other DFS orders — but to record THIS
        # set's maximality we already handled avail_all==0 above; here avail_all!=0 so not
        # maximal, we just keep extending with higher indices (its maximal supersets get
        # counted). No count here.
        while a:
            y = a & (-a)
            a ^= y
            yi = y.bit_length() - 1
            nf = forbidden | rc_mask[yi]
            c = chosen
            while c:
                b = c & (-c)
                c ^= b
                nf |= line_third[yi][b.bit_length() - 1]
            rec(chosen | y, nf, size + 1, yi + 1)

    rec(0, 0, 0, 0)
    return sizes


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [3, 5, 7]
    for q in qs:
        sizes = maximal_sizes(q)
        odd = sum(v for k, v in sizes.items() if k % 2 == 1)
        even = sum(v for k, v in sizes.items() if k % 2 == 0)
        dist = " ".join(f"{k}:{v}" for k, v in sorted(sizes.items()))
        verdict = "ALL EVEN (free P proof!)" if odd == 0 else f"MIXED ({odd} odd maximal positions)"
        print(f"q={q}: maximal-position sizes  {dist}")
        print(f"       even={even} odd={odd}  => {verdict}", flush=True)
    print("PARITY_DONE")
