r"""Decisive test: does the FREE antidiagonal mirror survive past q=9?

sigma_c (central symmetry) free mirror dies at q=9. The antidiagonal mirror (free
problem-set replies) wins q<=9. Axis-RESTRICTED antidiagonal dies at q=11. So the open
question is whether the antidiagonal with FREE axis handling keeps winning at q=11,13 --
if yes, the mechanism is real; if no, it is small-case luck like sigma_c.

Single representative phi (a=1, s=1), free replies to axis moves. Also emits a diagnostic
of the FIRST failing line if it fails.
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
            if i == j: continue
            if cells[j][0] == r: row_mask[i] |= 1 << j
            if cells[j][1] == c: col_mask[i] |= 1 << j
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


def run(q, a=1, s=1, axis_only=False):
    F, cells, idx, N, rc_mask, line_third = build_grid(q)
    ainv = F.inv(a)
    def f(r, c):
        return (F.add(F.mul(a, c), s), F.sub(F.mul(ainv, r), F.mul(ainv, s)))
    phi = [idx[f(*cells[i])] for i in range(N)]
    assert all(phi[phi[i]] == i for i in range(N))
    x1i = idx[(0, 0)]; x2i = phi[x1i]
    axis = [i for i in range(N) if phi[i] == i]
    forced_ok = [False] * N
    for x in range(N):
        px = phi[x]; rx, cx = cells[x]; rp, cp = cells[px]
        forced_ok[x] = (px != x) and (rp != rx) and (cp != cx)
    ALL = (1 << N) - 1

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
        a2 = avail
        while a2 and res:
            y = a2 & (-a2); a2 ^= y
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
                cand = axis if axis_only else range(N)
                ok = False
                for zi in cand:
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

    f1 = fb(0, 0, x1i); ch1 = 1 << x1i
    f2 = fb(f1, ch1, x2i); ch2 = ch1 | (1 << x2i)
    win = p1(ch2, f2)
    mode = "axis-only" if axis_only else "free"
    print(f"q={q:>3}  phi(a={a},s={s}) {mode:>9}  states={len(memo):>9}  "
          f"-> P2 {'WINS' if win else 'FAILS'}", flush=True)
    return win


if __name__ == "__main__":
    q = int(sys.argv[1]) if len(sys.argv) > 1 else 11
    axis_only = "--axis" in sys.argv
    run(q, axis_only=axis_only)
    print("ANTIDIAG_FREE_LARGE_DONE")
