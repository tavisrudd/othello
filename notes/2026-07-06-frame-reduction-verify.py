"""Verify the FRAME REDUCTION for the projective planar cap game.

Claim (to be proved by hand, verified here):
  PG(2,q) = P  <=>  the size-4 position (a projective FRAME = 4 points in general
  position, no 3 collinear) is a P-position (mover loses).

Reason: PGL(3,q) acts transitively on points (size 1), on ordered pairs (size 2), on
triangles (size 3), and on frames/quadrangles (size 4).  So sizes 0..4 are EACH a single
orbit, and the game value is constant on each.  The normal-play recursion then gives a
chain of equivalences:

  value(empty)=P  <=>  size1=N  <=>  size2=P  <=>  size3=N  <=>  size4=P.

We verify, in the equivalent RESIDUAL GRID GAME (opening pair a,b sent to infinity; board
= F_q x F_q; legal = partial-permutation matrix + affine cap), that:
  (i)  every size-1 grid position has the same game value  (single orbit)
  (ii) every size-2 grid position has the same game value  (single orbit)
  (iii) value(empty grid) = P  <=>  value(size-2 grid position {(0,0),(1,1)}) = P
        (the grid size-2 position = the projective size-4 FRAME).

The grid solver already fixes the infinity pair, so grid-size k = projective-size k+2.
"""
import sys
from itertools import product
from gf import GF

sys.setrecursionlimit(1 << 20)


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
    return F, cells, N, rc_mask, line_third


def make_solver(q):
    F, cells, N, rc_mask, line_third = build(q)
    ALL = (1 << N) - 1
    idx = {c: i for i, c in enumerate(cells)}
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
            nf = forbidden | rc_mask[yi]
            c = chosen
            while c:
                b = c & (-c); c ^= b
                nf |= line_third[yi][b.bit_length() - 1]
            if g(chosen | y, nf) == 0:
                res = 1
                break
        memo[chosen] = res
        return res

    def forbidden_of(cellset):
        """Forbidden mask induced by a set of chosen cells (indices)."""
        nf = 0
        cl = list(cellset)
        for i in cl:
            nf |= rc_mask[i]
        for a in range(len(cl)):
            for b in range(len(cl)):
                if a != b:
                    nf |= line_third[cl[a]][cl[b]]
        return nf

    def value_at(cellset):
        chosen = 0
        for i in cellset:
            chosen |= 1 << i
        return g(chosen, forbidden_of(cellset))

    return F, cells, N, idx, g, value_at, memo


def check(q):
    F, cells, N, idx, g, value_at, memo = make_solver(q)

    root = g(0, 0)  # value of empty grid

    # (i) all size-1 positions same value
    v1 = set(value_at([i]) for i in range(N))

    # (ii) all size-2 legal positions same value (must be a legal cap: diff row & col)
    v2 = set()
    size2_reps = []
    for i in range(N):
        for j in range(i + 1, N):
            (r1, c1), (r2, c2) = cells[i], cells[j]
            if r1 == r2 or c1 == c2:
                continue  # not a partial permutation -> illegal
            v2.add(value_at([i, j]))
            size2_reps.append((i, j))

    # the canonical frame position {(0,0),(1,1)}
    frame_val = value_at([idx[(0, 0)], idx[(1, 1)]])

    ok_i = (len(v1) == 1)
    ok_ii = (len(v2) == 1)
    # reduction: root P (==0) iff frame is P (==0)
    ok_iii = ((root == 0) == (frame_val == 0))
    # and the theorem's chain: root == frame_val (both P or both N)
    ok_chain = (root == frame_val)

    print(f"q={q:>2}  root={'P' if root==0 else 'N'}  "
          f"size1-values={sorted(v1)} (single orbit: {ok_i})  "
          f"size2-values={sorted(v2)} (single orbit: {ok_ii})  "
          f"frame(={{(0,0),(1,1)}})={'P' if frame_val==0 else 'N'}  "
          f"root==frame: {ok_chain}  states={len(memo)}", flush=True)
    return ok_i and ok_ii and ok_iii and ok_chain


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [2, 3, 4, 5, 7]
    allok = True
    for q in qs:
        allok &= check(q)
    print("FRAME_REDUCTION_VERIFY_DONE", "ALL_OK" if allok else "FAILED")
