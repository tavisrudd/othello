r"""Generalized 'bulk-forced mirror + free problem-set' tester over the WHOLE family of
grid-hypergraph involutions, for the q-odd planar kernel.

Grid game (residual of PG(2,q) after opening pair): q x q grid, legal = partial permutation
(<=1/row, <=1/col) AND affine cap. P1 first; PG(2,q)=P <=> first-player loss.

An involution automorphism of the grid hypergraph is an affine map with MONOMIAL linear part
(diagonal or antidiagonal) -- these are the only maps preserving both collinearity and the
row/col classes. The involutions split into:
  * DIAGONAL diag(-1,-1)+t = central symmetry sigma_c : problem-set = c's row U c's col
    ("the cross", 2 burned-direction lines). [2026-07-06-qodd-bulk-forced.py: WINS q<=7,
     FAILS q=9 even with free cross + any center.]
  * DIAGONAL diag(-1,1)/(1,-1): reflection, phi(x) shares a col/row with x for EVERY x
    => whole board is problem-set, not a mirror. Skipped.
  * ANTIDIAGONAL (swap-type) phi(r,c) = (a*c+s, a^{-1} r - a^{-1} s), a in F*, s in F:
    problem-set = its single FIXED LINE (direction (a,1)), q live cells. NEVER tested as a
    bulk-forced mirror. THIS SCRIPT.

Strategy tested: after P1 plays x1 (WLOG (0,0)), P2 picks an involution phi from the family
with x2:=phi(x1) a legal reply (so {x1,x2} is phi-symmetric), then FORCES phi on the bulk
(cells where phi(x) differs from x in both row and col) and replies FREELY (any legal cell)
to a problem-set move. Because a cap meets any single line in <=2 points, the fixed-line
problem-set can be triggered <=2 times -- same bounded structure as the cross, different
geometry. Question: does SOME antidiagonal phi win for q=9 (and beyond)?
"""
import sys
from itertools import product
from gf import GF

sys.setrecursionlimit(1 << 20)


def build_grid(q):
    F = GF(q)
    cells = list(product(range(q), repeat=2))
    idx = {c: i for i, c in enumerate(cells)}
    N = len(cells)

    def cl(p, a, b):
        u0, u1 = F.sub(a[0], p[0]), F.sub(a[1], p[1])
        w0, w1 = F.sub(b[0], p[0]), F.sub(b[1], p[1])
        return F.sub(F.mul(u0, w1), F.mul(u1, w0)) == 0

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
                if k != i and k != j and cl(cells[i], cells[j], cells[k]):
                    m |= 1 << k
            line_third[i][j] = m
    return F, cells, idx, N, rc_mask, line_third


def test_phi(q, F, cells, idx, N, rc_mask, line_third, phi, x1i, x2i):
    """phi: involution as cell-index array. Force phi on bulk; free on problem-set.
    problem-set(x) = (phi[x]==x) or shares row/col with phi[x). Return True if P2 wins
    from S={x1,x2} (P1 to move)."""
    ALL = (1 << N) - 1

    def fb(forbidden, chosen, yi):
        nf = forbidden | rc_mask[yi]
        c = chosen
        while c:
            b = c & (-c); c ^= b
            nf |= line_third[yi][b.bit_length() - 1]
        return nf

    forced_ok = [False] * N   # True if phi[x] is a valid mirror reply target for a bulk x
    for x in range(N):
        px = phi[x]
        rx, cx = cells[x]; rp, cp = cells[px]
        forced_ok[x] = (px != x) and (rp != rx) and (cp != cx)

    memo = {}

    def p1(chosen, forbidden):
        v = memo.get(chosen)
        if v is not None:
            return v
        avail = ALL & ~chosen & ~forbidden
        res = True
        a = avail
        while a and res:
            y = a & (-a); a ^= y
            yi = y.bit_length() - 1
            nf = fb(forbidden, chosen, yi)
            nchosen = chosen | y
            if forced_ok[yi]:
                ri = phi[yi]; rbit = 1 << ri
                if (nchosen & rbit) or (nf & rbit):
                    res = False
                else:
                    nf2 = fb(nf, nchosen, ri)
                    if not p1(nchosen | rbit, nf2):
                        res = False
            else:
                avail2 = ALL & ~nchosen & ~nf
                ok = False
                b = avail2
                while b:
                    zb = b & (-b); b ^= zb
                    zi = zb.bit_length() - 1
                    nf2 = fb(nf, nchosen, zi)
                    if p1(nchosen | zb, nf2):
                        ok = True; break
                if not ok:
                    res = False
        memo[chosen] = res
        return res

    f1 = fb(0, 0, x1i)
    ch1 = 1 << x1i
    f2 = fb(f1, ch1, x2i)
    ch2 = ch1 | (1 << x2i)
    return p1(ch2, f2)


def antidiag_involutions(q, F, cells, idx, x1i):
    """Yield (phi_array, x2i, label) for antidiagonal involutions phi with x2=phi(x1) legal.
    phi(r,c) = (a*c + s, a^{-1}(r - s)),  a in F*, s in F*  (s!=0 keeps x2 off x1's row/col)."""
    x1 = cells[x1i]
    for a in range(1, q):
        ainv = F.inv(a)
        for s in range(q):
            # phi(r,c) = (a*c + sr, ainv*(r - sc)) with the involution constraint sr=s, sc=?
            # Use the derived form: phi(r,c)=(a*c+s, ainv*r - ainv*s). Check involution + fixed line.
            def make(a=a, ainv=ainv, s=s):
                def f(r, c):
                    return (F.add(F.mul(a, c), s), F.sub(F.mul(ainv, r), F.mul(ainv, s)))
                return f
            f = make()
            # verify involution
            ok = all(f(*f(r, c)) == (r, c) for (r, c) in cells)
            if not ok:
                continue
            phi = [idx[f(*cells[i])] for i in range(len(cells))]
            x2i = phi[x1i]
            if x2i == x1i:
                continue
            r2, c2 = cells[x2i]; r1, c1 = x1
            if r2 == r1 or c2 == c1:
                continue   # x2 not a legal 2nd move
            yield phi, x2i, f"antidiag a={a} s={s}"


def main(q):
    F, cells, idx, N, rc_mask, line_third = build_grid(q)
    x1i = idx[(0, 0)]
    wins = []
    seen = set()
    for phi, x2i, label in antidiag_involutions(q, F, cells, idx, x1i):
        key = tuple(phi)
        if key in seen:
            continue
        seen.add(key)
        if test_phi(q, F, cells, idx, N, rc_mask, line_third, phi, x1i, x2i):
            wins.append(label)
    print(f"q={q:>2}  antidiag involutions tried={len(seen):>4}  winning={len(wins):>4}  "
          f"-> {'ANTIDIAG MIRROR WINS' if wins else 'all antidiag FAIL'}", flush=True)
    for w in wins[:6]:
        print(f"      {w}")
    return len(wins) > 0


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [3, 5, 7, 9]
    allok = True
    for q in qs:
        allok &= main(q)
    print("MIRROR_FAMILY_DONE" + ("" if allok else "  (SOME q ALL-FAIL)"))
