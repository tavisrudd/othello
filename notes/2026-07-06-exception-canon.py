"""Confirm the q=9 exception structure at q=11,13 via the canonical grid solver.

Claim to verify at each q:
  (A) every odd-size P-position is a MAXIMAL cap (no non-maximal odd P);
  (B) parity holds ('P iff |S| even') for every position that is NOT an odd maximal cap
      and NOT one-move-from-an-odd-maximal cap;
  i.e. the ONLY defects are odd maximal caps, propagating back one level.

We tally, per canonical class: P/N, size, maximal?  Then report deviations from parity by
size and whether the odd P-classes are exactly the maximal ones.
"""
import sys
from itertools import product
from collections import Counter
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
                if t in (0, 1): continue
                m |= 1 << idx[(F.add(ri, F.mul(t, dr)), F.add(ci, F.mul(t, dc)))]
            line_third[i][j] = m
    return F, cells, idx, N, rc_mask, line_third


def make_canon(F, cells, idx):
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
            return 1
        best = None
        for ui in occ:
            ur, uc = cells[ui]
            for vi in occ:
                if vi == ui: continue
                vr, vc = cells[vi]
                tvr, tvc = sub(vr, ur), sub(vc, uc)
                for sw in (0, 1):
                    pvr, pvc = (tvc, tvr) if sw else (tvr, tvc)
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


def solve(q):
    F, cells, idx, N, rc_mask, line_third = build(q)
    canon = make_canon(F, cells, idx)
    ALL = (1 << N) - 1
    memo = {}          # key -> res (0=P,1=N)
    info = {}          # key -> (size, maximal)

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
        size = bin(chosen).count("1")
        res = 0
        a = avail
        while a:                       # NO early break: fully expand for complete tallies
            y = a & (-a); a ^= y
            yi = y.bit_length() - 1
            nf = fb(forbidden, chosen, yi)
            if g(chosen | y, nf) == 0:
                res = 1
        memo[key] = res
        info[key] = (size, avail == 0)
        return res

    root = g(0, 0)
    return root, memo, info


def analyze(q):
    root, memo, info = solve(q)
    dev_odd_P_maximal = 0
    dev_odd_P_nonmax = 0
    dev_even_N = 0
    by_size = Counter()      # size -> (#P, #N) as canonical classes
    P_by_size = Counter(); N_by_size = Counter()
    odd_max_sizes = Counter()
    for key, res in memo.items():
        size, maximal = info[key]
        isP = (res == 0)
        if isP:
            P_by_size[size] += 1
        else:
            N_by_size[size] += 1
        if size % 2 == 1 and isP:
            if maximal:
                dev_odd_P_maximal += 1
                odd_max_sizes[size] += 1
            else:
                dev_odd_P_nonmax += 1
        if size % 2 == 0 and not isP:
            dev_even_N += 1
    print(f"q={q}: root={'P (2nd wins)' if root==0 else 'N (1st wins)'} classes={len(memo)}")
    print(f"  odd-but-P: maximal={dev_odd_P_maximal} NON-maximal={dev_odd_P_nonmax}"
          f"   (odd maximal cap sizes seen: {dict(odd_max_sizes)})")
    print(f"  even-but-N classes={dev_even_N}")
    # show which sizes deviate from parity
    devsizes = []
    for s in sorted(set(P_by_size) | set(N_by_size)):
        exp_P = (s % 2 == 0)
        bad = (N_by_size[s] if exp_P else P_by_size[s])
        if bad:
            devsizes.append((s, P_by_size[s], N_by_size[s]))
    print(f"  deviating sizes (size,#P,#N): {devsizes}", flush=True)


if __name__ == "__main__":
    qs = eval(sys.argv[1]) if len(sys.argv) > 1 else [9, 11, 13]
    for q in qs:
        analyze(q)
    print("EXC_CANON_DONE")
