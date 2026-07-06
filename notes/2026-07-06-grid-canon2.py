r"""Stronger canonicalizing grid solver (full group, anchored) -> PG(2,q)=P far past q=13.

Same grid game as 2026-07-06-grid-canon.py, but canonicalizes `chosen` under the FULL grid
automorphism group  G = { (r,c)->(a r + s, b c + t) } |x swap,  a,b in F*, s,t in F, via an
ANCHOR construction (no brute orbit enumeration):

  every occupied cell has a distinct row and distinct col (partial-permutation constraint), so
  for any ordered pair (u,v) of occupied cells and a swap choice, there is a UNIQUE g in G with
  g(u)=(0,0) and g(v)=(1,1)  [translate u->0, optional swap, then torus scaling v'->(1,1);
  v' has both coords nonzero]. Take the min bitmask over all (u,v,swap). This min is a
  G-invariant orbit representative (the candidate set is G-equivariant), so memoizing on it is
  exact -- and it folds in the torus, unlike grid-canon.py (translation+swap only).

Cost O(|S|^3) per canon but MANY fewer states (full-group orbits), so larger q is reachable.
Cross-checks grid-canon.py / the naive projective solver (all P) for q<=13.
"""
import sys
from itertools import product
from gf import GF

sys.setrecursionlimit(1 << 20)


def build(q):
    F = GF(q)
    cells = list(product(range(q), repeat=2))
    idx = {c: i for i, c in enumerate(cells)}
    N = len(cells)
    row_mask = [0] * N; col_mask = [0] * N
    for i, (r, c) in enumerate(cells):
        for j, (r2, c2) in enumerate(cells):
            if i == j: continue
            if c2 == c: col_mask[i] |= 1 << j
            if r2 == r: row_mask[i] |= 1 << j
    rc_mask = [row_mask[i] | col_mask[i] for i in range(N)]
    line_third = [[0] * N for _ in range(N)]
    for i in range(N):
        ri, ci = cells[i]
        for j in range(N):
            if i == j: continue
            rj, cj = cells[j]
            dr, dc = F.sub(rj, ri), F.sub(cj, ci)
            m = 0
            for t in range(q):
                if t == 0 or t == 1: continue
                m |= 1 << idx[(F.add(ri, F.mul(t, dr)), F.add(ci, F.mul(t, dc)))]
            line_third[i][j] = m
    return F, cells, idx, N, rc_mask, line_third


def make_canon(F, cells, idx, N):
    sub = F.sub; mul = F.mul; inv = F.inv

    def canon(chosen):
        if chosen == 0:
            return 0
        occ = []
        m = chosen
        while m:
            b = m & (-m); m ^= b
            occ.append(b.bit_length() - 1)
        if len(occ) == 1:
            return 1  # single cell -> canonical mask has just origin's bit... use sentinel 1
        best = None
        for ui in occ:
            ur, uc = cells[ui]
            for vi in occ:
                if vi == ui: continue
                vr, vc = cells[vi]
                # translate u->0
                tvr, tvc = sub(vr, ur), sub(vc, uc)   # v after translation
                for sw in (0, 1):
                    if sw:
                        pvr, pvc = tvc, tvr
                    else:
                        pvr, pvc = tvr, tvc
                    # both nonzero (distinct row & col from u); scale ->(1,1)
                    a, b = inv(pvr), inv(pvc)
                    mask = 0
                    for xi in occ:
                        xr, xc = cells[xi]
                        yr, yc = sub(xr, ur), sub(xc, uc)
                        if sw:
                            yr, yc = yc, yr
                        mask |= 1 << idx[(mul(a, yr), mul(b, yc))]
                    if best is None or mask < best:
                        best = mask
        return best
    return canon


def solve(q, report=True):
    F, cells, idx, N, rc_mask, line_third = build(q)
    canon = make_canon(F, cells, idx, N)
    ALL = (1 << N) - 1
    memo = {}

    def fb(forbidden, chosen, yi):
        nf = forbidden | rc_mask[yi]
        c = chosen
        while c:
            b = c & (-c); c ^= b
            nf |= line_third[yi][b.bit_length() - 1]
        return nf

    def g(chosen, forbidden):
        key = canon(chosen)
        v = memo.get(key)
        if v is not None:
            return v
        avail = ALL & ~chosen & ~forbidden
        res = 0
        a = avail
        while a:
            y = a & (-a); a ^= y
            yi = y.bit_length() - 1
            nf = fb(forbidden, chosen, yi)
            if g(chosen | y, nf) == 0:
                res = 1
                break
        memo[key] = res
        return res

    root = g(0, 0)
    outc = "P (2nd) [PG(2,q)=P]" if root == 0 else "N (1st)"
    if report:
        print(f"q={q:>3}  grid first-player {'LOSS' if root==0 else 'WIN':>4}  "
              f"canon-states={len(memo):>9}  -> {outc}", flush=True)
    return root, len(memo)


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [3, 5, 7, 9, 11, 13]
    for q in qs:
        solve(q)
    print("GRID_CANON2_DONE")
