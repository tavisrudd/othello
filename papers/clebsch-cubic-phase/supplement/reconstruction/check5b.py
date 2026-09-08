import sys
import itertools
import numpy as np
from common import data


def tensor(p):
    E, _, _ = data(p)
    ep = np.array([1] * p + [p - 1] * p, dtype=np.int64)
    A = np.array(E, dtype=np.int64) % p
    return np.einsum('i,ia,ib,ic->abc', ep, A, A, A) % p


def rank_small(M, p, k):
    m = [row[:] for row in M]
    r = 0
    for c in range(k):
        piv = -1
        for i in range(r, k):
            if m[i][c]:
                piv = i
                break
        if piv < 0:
            continue
        m[r], m[piv] = m[piv], m[r]
        inv = pow(m[r][c], p - 2, p)
        if inv != 1:
            m[r] = [(x * inv) % p for x in m[r]]
        for i in range(r + 1, k):
            f = m[i][c]
            if f:
                mr = m[r]
                m[i] = [(m[i][j] - f * mr[j]) % p for j in range(k)]
        r += 1
    return r


p, k = 7, 6
T = tensor(7)
rows = []
for a in (0, 5):
    for b in range(k):
        rows.append([int(x) for x in T[a, b, :]])
R = np.array(rows, dtype=np.int64) % p
sols = []
for v in itertools.product(range(p), repeat=k):
    va = np.array(v, dtype=np.int64)
    if va.any() and not ((R @ va) % p).any():
        sols.append(v)
print("p=7: nonzero v killing rows 0 and 5 of H:", sols)
for v in sols[:3]:
    H = ((np.array(v) @ T.reshape(k * k, k).T) % p).reshape(k, k).tolist()
    print("   v =", v, " rank H(v) =", rank_small(H, p, k))
print("   total such nonzero v:", len(sols))
