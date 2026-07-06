r"""Canonicalizing grid-game solver -> extend the PG(2,q)=P ladder past q=11.

The residual grid game (2026-07-05-grid-game.py) IS PG(2,q) after the opening pair:
q x q grid, legal = partial permutation (<=1/row, <=1/col) AND affine cap, P1 first;
PG(2,q)=P  <=>  first-player LOSS. The naive memo is ~q^2-independent and blows up
(q=13 ~ 3*10^8 states). But the grid game's automorphism group
  G = { (r,c) -> (a*r+s, b*c+t) } |x swap(r<->c),   a,b in F*, s,t in F
preserves the game (it preserves the row/col parallel classes AND collinearity), so
game value is a G-invariant of the chosen set. Canonicalizing `chosen` under a subgroup
H <= G merges H-equivalent positions soundly.

Cheap sound canonical form (H = translations |x swap, optionally |x torus):
  min over  [ (swap?) o (torus a,b) o (translate an occupied cell to origin) ]  of the bitmask.
Translations need only |S| candidates (the min-image has an occupied cell at origin), so the
common case is ~|S| * (swap) * (torus) cheap bitmask remaps. Value(chosen)=Value(canon(chosen))
and forbidden is a function of chosen, so memoizing on canon(chosen) is exact.

Validate: q=3,5,7,9,11 must all report first-player LOSS (=P), matching the naive solver.
"""
import sys
from itertools import product
from gf import GF

sys.setrecursionlimit(1 << 20)


def build(q, use_torus):
    F = GF(q)
    cells = list(product(range(q), repeat=2))       # (row, col)
    idx = {c: i for i, c in enumerate(cells)}
    N = len(cells)

    def cross(p, a, b):
        u0, u1 = F.sub(a[0], p[0]), F.sub(a[1], p[1])
        w0, w1 = F.sub(b[0], p[0]), F.sub(b[1], p[1])
        return F.sub(F.mul(u0, w1), F.mul(u1, w0)) == 0

    row_mask = [0] * N; col_mask = [0] * N
    for i, (r, c) in enumerate(cells):
        for j, (r2, c2) in enumerate(cells):
            if i == j: continue
            if r2 == r: row_mask[i] |= 1 << j
            if c2 == c: col_mask[i] |= 1 << j
    rc_mask = [row_mask[i] | col_mask[i] for i in range(N)]
    # line_third[i][j] = the q-2 cells collinear with i,j (excluding i,j), via parametrization
    # point(t) = cells[i] + t*(cells[j]-cells[i]);  t=0->i, t=1->j.  O(N^2 q), not O(N^3).
    line_third = [[0] * N for _ in range(N)]
    for i in range(N):
        ri, ci = cells[i]
        for j in range(N):
            if i == j: continue
            rj, cj = cells[j]
            dr, dc = F.sub(rj, ri), F.sub(cj, ci)
            m = 0
            for t in range(q):
                if t == 0 or t == 1:
                    continue
                k = idx[(F.add(ri, F.mul(t, dr)), F.add(ci, F.mul(t, dc)))]
                m |= 1 << k
            line_third[i][j] = m

    # linear/swap generators as cell-index perms (applied AFTER translating anchor to origin).
    # torus (a,b): (r,c)->(a r, b c);  swap: (r,c)->(c,r).
    lin_perms = []
    tors = [(a, b) for a in range(1, q) for b in range(1, q)] if use_torus else [(1, 1)]
    for sw in (False, True):
        for (a, b) in tors:
            perm = [0] * N
            for i, (r, c) in enumerate(cells):
                r2, c2 = (F.mul(a, r), F.mul(b, c))
                if sw:
                    r2, c2 = c2, r2
                perm[i] = idx[(r2, c2)]
            lin_perms.append(perm)
    # translation perms: translate by (ds,dt): (r,c)->(r+ds, c+dt) in F_q (GF add, NOT %q --
    # matters for prime-power q where addition is digitwise mod p).  Index by (ds,dt).
    trans = {}
    for ds in range(q):
        for dt in range(q):
            perm = [0] * N
            for i, (r, c) in enumerate(cells):
                perm[i] = idx[(F.add(r, ds), F.add(c, dt))]
            trans[(ds, dt)] = perm
    return F, cells, idx, N, rc_mask, line_third, lin_perms, trans


def make_canon(q, cells, N, lin_perms, trans, F):
    def remap(mask, perm):
        out = 0
        m = mask
        while m:
            b = m & (-m); m ^= b
            out |= 1 << perm[b.bit_length() - 1]
        return out

    def canon(chosen):
        if chosen == 0:
            return 0
        best = None
        for lp in lin_perms:
            s1 = remap(chosen, lp)
            # translate an occupied cell of s1 to origin (min over occupied cells)
            o = s1
            occ1 = []
            while o:
                b = o & (-o); o ^= b
                occ1.append(b.bit_length() - 1)
            for u in occ1:
                r, c = cells[u]
                cand = remap(s1, trans[(F.sub(0, r), F.sub(0, c))])
                if best is None or cand < best:
                    best = cand
        return best
    return canon


def solve(q, use_torus=False, report=True):
    F, cells, idx, N, rc_mask, line_third, lin_perms, trans = build(q, use_torus)
    canon = make_canon(q, cells, N, lin_perms, trans, F)
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
              f"canon-states={len(memo):>10}  torus={int(use_torus)}  -> {outc}", flush=True)
    return root, len(memo)


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [3, 5, 7, 9, 11]
    use_torus = "--torus" in sys.argv
    for q in qs:
        solve(q, use_torus=use_torus)
    print("GRID_CANON_DONE")
