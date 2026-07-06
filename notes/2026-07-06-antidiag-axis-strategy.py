r"""The clean q-odd planar strategy: bulk-forced ANTIDIAGONAL mirror + on-axis reply.

Discovery (2026-07-06-mirror-family.py): the antidiagonal (transpose-type) involution phi
mirrors the grid game where central symmetry sigma_c fails (sigma_c dies at q=9). phi's
problem-set is its single FIXED LINE ell (direction (1,1), a NON-burned direction). Because
ell is pointwise-fixed by phi, replying to an ell-move with ANOTHER ell-cell keeps the
position phi-symmetric (both cells are phi-fixed) -- unlike the cross, where no reply can
stay symmetric. And a cap meets ell in <=2 points, so ell is played <=2 times total.

Strategy S(phi):  [phi = antidiagonal involution, x2 := phi(x1)]
  - P1 plays x1 (WLOG (0,0)); P2 plays x2 = phi(x1).       # {x1,x2} phi-symmetric, off ell
  - P1 plays bulk cell x (phi(x) differs in row & col): P2 replies phi(x).   # forced mirror
  - P1 plays axis cell x in ell: P2 replies some legal ell-cell y != x.       # stay symmetric

This script tests the AXIS-RESTRICTED strategy (ell-move answered ONLY by an ell-cell, no
bulk escape) -- the clean, provable form. If it stays stuck-free up to large q, it is the
candidate uniform q-odd proof. One representative phi per q (a=1, s=1) unless --all.
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


def phi_antidiag(q, F, cells, idx, a, s):
    ainv = F.inv(a)
    def f(r, c):
        return (F.add(F.mul(a, c), s), F.sub(F.mul(ainv, r), F.mul(ainv, s)))
    phi = [idx[f(*cells[i])] for i in range(len(cells))]
    assert all(phi[phi[i]] == i for i in range(len(cells))), "phi not an involution"
    return phi


def test_axis_strategy(q, F, cells, idx, N, rc_mask, line_third, phi, x1i):
    ALL = (1 << N) - 1
    x2i = phi[x1i]
    axis = [i for i in range(N) if phi[i] == i]           # the fixed line ell
    forced_ok = [False] * N
    for x in range(N):
        px = phi[x]
        rx, cx = cells[x]; rp, cp = cells[px]
        forced_ok[x] = (px != x) and (rp != rx) and (cp != cx)

    def fb(forbidden, chosen, yi):
        nf = forbidden | rc_mask[yi]
        c = chosen
        while c:
            b = c & (-c); c ^= b
            nf |= line_third[yi][b.bit_length() - 1]
        return nf

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
                    res = False                     # forced mirror illegal => strategy fails
                else:
                    nf2 = fb(nf, nchosen, ri)
                    if not p1(nchosen | rbit, nf2):
                        res = False
            else:
                # yi is on the fixed line ell (or a degenerate reply cell): answer within ell
                ok = False
                for zi in axis:
                    zb = 1 << zi
                    if zi == yi or (nchosen & zb) or (nf & zb):
                        continue
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
    return p1(ch2, f2), len(memo)


def main(qs, test_all=False):
    allok = True
    for q in qs:
        F, cells, idx, N, rc_mask, line_third = build_grid(q)
        x1i = idx[(0, 0)]
        params = ([(a, s) for a in range(1, q) for s in range(1, q)]
                  if test_all else [(1, 1)])
        results = []
        for (a, s) in params:
            phi = phi_antidiag(q, F, cells, idx, a, s)
            if phi[x1i] == x1i:
                continue
            r2, c2 = cells[phi[x1i]]
            if r2 == 0 or c2 == 0:                 # x2 must be a legal 2nd move
                continue
            win, st = test_axis_strategy(q, F, cells, idx, N, rc_mask, line_third, phi, x1i)
            results.append((a, s, win, st))
        nwin = sum(1 for *_, w, _ in [(r[0], r[1], r[2], r[3]) for r in results] if w)
        nwin = sum(1 for r in results if r[2])
        tot = len(results)
        st0 = results[0][3] if results else 0
        ok = (nwin == tot and tot > 0)
        allok &= ok
        tag = ("ALL WIN" if ok else f"{nwin}/{tot} win")
        print(f"q={q:>3}  phi tested={tot:>4}  axis-strategy: {tag:>10}  "
              f"(states~{st0})  -> {'stuck-free' if ok else 'FAILS'}", flush=True)
    print("ANTIDIAG_AXIS_DONE" + ("" if allok else "  (SOME FAIL)"))
    return allok


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [3, 5, 7, 9, 11]
    test_all = "--all" in sys.argv
    main(qs, test_all)
