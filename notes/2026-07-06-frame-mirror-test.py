r"""Test MIRROR strategies starting from the FRAME position S0={(0,0),(1,1)} (grid size 2 =
projective size 4).  By the frame reduction (2026-07-06-frame-reduction-verify.py),
PG(2,q)=P  <=>  S0 is a P-position.  So if P2 (the player NOT to move at S0) wins from S0 by
a mirror, PG(2,q)=P.

NEW vs the prior mirror scripts (2026-07-06-mirror-family.py / -qodd-bulk-forced.py): those
had P2 create the size-2 position by replying phi(x1) to P1's opening x1, which REQUIRES
phi(x1)!=x1 -- so the TRANSPOSE tau(r,c)=(c,r) (which FIXES x1) was skipped.  Here the size-2
position is the frame {(0,0),(1,1)}, which is FIXED SETWISE by the whole frame-stabilizer
4-group {id, sigma_c, tau, sigma_c*tau}, and tau's fixed locus (the main diagonal r=c) is DEAD
(collinear with the frame).  So tau-from-frame is a legitimate, previously-untested mirror.

For each involution phi fixing the frame setwise, run the bulk-forced test: P2 replies phi(x)
to a bulk move (phi(x) differs from x in both coords), free reply on the problem set.  Report
which phi win, and for how large q.
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


def frame_involutions(q, F, cells, idx):
    """The frame-stabilizer 4-group as cell-index permutations, restricted to involutions
    fixing {(0,0),(1,1)} setwise.  sigma_c(r,c)=(1-r,1-c); tau(r,c)=(c,r);
    sigma_c*tau(r,c)=(1-c,1-r)."""
    def perm(f):
        return [idx[f(*cells[i])] for i in range(len(cells))]
    sub = F.sub
    maps = {
        "sigma_c (r,c)->(1-r,1-c)": lambda r, c: (sub(1, r), sub(1, c)),
        "tau     (r,c)->(c,r)":     lambda r, c: (c, r),
        "sc*tau  (r,c)->(1-c,1-r)": lambda r, c: (sub(1, c), sub(1, r)),
    }
    out = []
    for label, f in maps.items():
        phi = perm(f)
        # confirm involution + fixes frame setwise
        assert all(phi[phi[i]] == i for i in range(len(cells)))
        fr = {idx[(0, 0)], idx[(1, 1)]}
        assert {phi[i] for i in fr} == fr
        out.append((label, phi))
    return out


def test_phi(q, F, cells, idx, N, rc_mask, line_third, phi):
    ALL = (1 << N) - 1

    def fb(forbidden, chosen, yi):
        nf = forbidden | rc_mask[yi]
        c = chosen
        while c:
            b = c & (-c); c ^= b
            nf |= line_third[yi][b.bit_length() - 1]
        return nf

    forced_ok = [False] * N
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

    # build the frame position {(0,0),(1,1)}
    a, b = idx[(0, 0)], idx[(1, 1)]
    f1 = fb(0, 0, a)
    ch1 = 1 << a
    f2 = fb(f1, ch1, b)
    ch2 = ch1 | (1 << b)
    return p1(ch2, f2)


def main(q):
    F, cells, idx, N, rc_mask, line_third = build_grid(q)
    results = []
    for label, phi in frame_involutions(q, F, cells, idx):
        win = test_phi(q, F, cells, idx, N, rc_mask, line_third, phi)
        results.append((label, win))
    any_win = any(w for _, w in results)
    print(f"q={q:>2}  " + "  ".join(f"[{l.split()[0]}:{'WIN' if w else 'fail'}]"
                                    for l, w in results)
          + f"   -> {'MIRROR WINS' if any_win else 'ALL FAIL'}", flush=True)
    return any_win


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [3, 5, 7, 9, 11]
    allok = True
    for q in qs:
        allok &= main(q)
    print("FRAME_MIRROR_TEST_DONE" + ("" if allok else "  (SOME q ALL-FAIL)"))
