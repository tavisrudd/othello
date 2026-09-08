"""check6: the analogous Waring bracket for F_11 (bonus), and the rank-based lower bounds.

Lower bound mechanism (both primes): if F = sum_{i=1}^r c_i l_i^3 with the l_i pairwise
non-proportional, then H_F(v) = 6 sum_i c_i l_i(v) a_i a_i^T (a_i = coefficient vector of
l_i), so rank H_F(v) <= #{i : l_i(v) != 0}.  Picking v != 0 in the common kernel of any
k-1 linearly independent a_i gives rank H_F(v) <= r - (k-1) >= r_min, i.e. r >= r_min + k-1.
"""
from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parents[1]/"reconstruction"))

import itertools
import sys


import numpy as np  # noqa: E402
import sympy as sp  # noqa: E402
from common import data, eps  # noqa: E402

INVT = {}


def rref(M, p):
    R = M.copy() % p
    rows, cols = R.shape
    piv, r = [], 0
    inv = INVT.setdefault(p, [0] + [pow(x, p - 2, p) for x in range(1, p)])
    for c in range(cols):
        nz = np.nonzero(R[r:, c])[0]
        if nz.size == 0:
            continue
        i = r + nz[0]
        if i != r:
            R[[r, i]] = R[[i, r]]
        R[r] = (R[r] * inv[R[r, c]]) % p
        f = R[:, c].copy()
        f[r] = 0
        R = (R - np.outer(f, R[r])) % p
        piv.append(c)
        r += 1
        if r == rows:
            break
    return R, piv


def cube_vec(a, p, k, idx3):
    v = np.zeros(len(idx3), dtype=np.int64)
    for i in range(k):
        if not a[i] % p:
            continue
        for j in range(i, k):
            if not a[j] % p:
                continue
            for l in range(j, k):
                if not a[l] % p:
                    continue
                mult = len(set(itertools.permutations((i, j, l))))
                v[idx3[(i, j, l)]] = (v[idx3[(i, j, l)]] + mult * a[i] * a[j] * a[l]) % p
    return v


def main():
    for p, rmin in ((7, 3), (11, 5)):
        k = p - 1
        E, _, _ = data(p)
        ep = eps(p)
        mon3 = list(itertools.combinations_with_replacement(range(k), 3))
        idx3 = {t: i for i, t in enumerate(mon3)}
        nz = [i for i in range(2 * p) if any(x % p for x in E[i])]
        lin = []
        for i in nz:
            a = [E[i][j] % p for j in range(k)]
            if ep[i] != 1:
                a = [(-x) % p for x in a]
            lin.append(a)
        u = sp.symbols(f"u0:{k}")
        F = sum(ep[i] * (sum(E[i][j] * u[j] for j in range(k))) ** 3 for i in range(2 * p))
        S = sum((sum(a[j] * u[j] for j in range(k))) ** 3 for a in lin)
        d = sp.Poly(sp.expand(S - F), *u)
        ok = (not d.coeffs()) or all(c % p == 0 for c in d.coeffs())
        cols = np.array([cube_vec(a, p, k, idx3) for a in lin], dtype=np.int64)
        _, piv = rref(cols, p)
        # are the linear forms pairwise non-proportional?
        cls = set()
        for a in lin:
            lead = next(x for x in a if x % p)
            iv = pow(lead, p - 2, p)
            cls.add(tuple(x * iv % p for x in a))
        print(f"p={p}: E_p has {2*p} rows, {len(nz)} nonzero "
              f"(zero rows at index {[i for i in range(2*p) if i not in nz]})")
        print(f"  F_{p} equals the sum of those {len(lin)} cubes mod {p}: {ok}"
              f"   -> Waring rank <= {len(lin)}")
        print(f"  linear forms pairwise non-proportional: {len(cls) == len(lin)}"
              f" ({len(cls)} projective classes)")
        print(f"  cubic space dim = {len(mon3)}; rank of the {len(lin)} cubes = {len(piv)}"
              f"  -> representation unique: {len(piv) == len(lin)}")
        print(f"  rank-census lower bound: r >= r_min + (k-1) = {rmin} + {k-1} = {rmin+k-1}")
        # the r = r_min + k - 1 case is excluded by the count of minimum-rank points
        r0 = rmin + k - 1
        need = sp.binomial(r0, k - 1)
        print(f"  the case r = {r0} forces an arc, hence C({r0},{k-1}) = {need} distinct "
              f"points of rank {rmin}; only {p+1} exist -> r >= {r0+1}")


if __name__ == "__main__":
    main()
