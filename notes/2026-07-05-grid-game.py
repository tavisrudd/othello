"""The residual grid game = PG(2,q) cap game after the opening pair {a,b} (handoff R2,
reformulated). Put line L=ab at infinity in a basis of the two burned directions a,b.
The affine plane becomes the q x q grid F_q x F_q; the two burned directions become
ROWS and COLUMNS. A residual cap is a set of cells with:
  - at most one cell per row and per column (partial permutation matrix), and
  - no three cells collinear on any affine line.
P1 moves first (into the empty grid). Claim (handoff): PG(2,q)=P  <=>  this grid game is
a FIRST-PLAYER LOSS, for every prime power q.

This is an INDEPENDENT implementation of the same residual (no projective points, no line
masks, no GF-line construction — only field arithmetic for collinearity), so matching the
projective solver's outcome cross-checks both the solver AND the R2 reformulation.
"""
import sys
from itertools import product
from gf import GF

sys.setrecursionlimit(1 << 20)


def solve(q, verbose=False):
    F = GF(q)
    cells = list(product(range(q), repeat=2))     # (row, col)
    idx = {c: i for i, c in enumerate(cells)}
    N = len(cells)

    def cross(p, a, b):
        # (a-p) x (b-p) == 0  <=>  p,a,b collinear (affine)
        ux, uy = F.sub(a[0], p[0]), F.sub(a[1], p[1])
        wx, wy = F.sub(b[0], p[0]), F.sub(b[1], p[1])
        return F.sub(F.mul(ux, wy), F.mul(uy, wx)) == 0

    # for each cell, forbidden-on-add sets: same row, same col, and (per existing pair)
    # the third-collinear cell. Rows/cols precomputed as masks.
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

    # third collinear cell for ordered pair (i,j): the (q-2) others on line ij. Store as mask.
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

    ALL = (1 << N) - 1
    memo = {}

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
            nf = forbidden | rc_mask[yi]      # row+col of new cell now blocked
            c = chosen
            while c:
                b = c & (-c); c ^= b
                nf |= line_third[yi][b.bit_length() - 1]
            if g(chosen | y, nf) == 0:
                res = 1
                break
        memo[chosen] = res
        return res

    root = g(0, 0)
    if verbose:
        print(f"grid q={q}: first-player {'LOSS (P2 wins => PG(2,q)=P)' if root==0 else 'WIN'}"
              f"  states={len(memo)}", flush=True)
    return root, len(memo)


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [2, 3, 4, 5, 7]
    print(f"{'q':>3} {'grid first-player':>18} {'states':>9}  expect PG(2,q)")
    for q in qs:
        root, st = solve(q)
        fp = "LOSS" if root == 0 else "WIN"
        pg = "P (2nd)" if root == 0 else "N (1st)"
        print(f"{q:>3} {fp:>18} {st:>9}  -> {pg}", flush=True)
    print("GRID_GAME_DONE")
