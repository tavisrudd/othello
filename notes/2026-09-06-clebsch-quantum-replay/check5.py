import sys
import itertools
import random
sys.path.insert(0, "/tmp/claude-1000/-home-tavis-src-othello-rust/"
                   "936bbcce-b386-4c99-97f5-4318b618ed8d/scratchpad/"
                   "clebsch-replay")
import numpy as np
from common import data
from check4 import rank_np


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


# ---------------- diagonal-vanishing certificate, both p ----------------
for p in (7, 11):
    k = p - 1
    T = tensor(p)
    zero_diag = [a for a in range(k) if not T[a, a, :].any()]
    print(f"--- p={p}: Hessian diagonal entries H_aa identically zero for a in",
          zero_diag)
    rows = []
    for a in zero_diag:
        for b in range(k):
            rows.append([int(x) for x in T[a, b, :]])
    if rows:
        rk = rank_np(rows, p)
        print(f"    forcing rows {zero_diag} of H(v) to vanish: {len(rows)}"
              f" linear equations in {k} unknowns, rank = {rk}"
              f" -> solution space dim {k - rk}")

# ---------------- p=7 exhaustive ----------------
p, k = 7, 6
T7 = tensor(7)
Tm = T7.reshape(k * k, k)                     # H_flat(v) = Tm @ v
V = np.array(list(itertools.product(range(p), repeat=k)), dtype=np.int64)
V = V[1:]                                      # drop v = 0
H = (V @ Tm.T) % p                             # (N, 36)
Hm = H.reshape(-1, k, k)
# rank<=1 test via all 2x2 minors
minors_zero = np.ones(Hm.shape[0], dtype=bool)
for i in range(k):
    for j in range(i + 1, k):
        for a in range(k):
            for b in range(a + 1, k):
                m = (Hm[:, i, a] * Hm[:, j, b] - Hm[:, i, b] * Hm[:, j, a]) % p
                minors_zero &= (m == 0)
nonzero_H = Hm.reshape(-1, k * k).any(axis=1)
rank1 = minors_zero & nonzero_H
print(f"--- p=7 exhaustive over all {Hm.shape[0]} nonzero v in F_7^6:")
print("    # v with rank(H(v)) == 1 :", int(rank1.sum()))
print("    # v with H(v) == 0       :", int((~nonzero_H).sum()))
ranks = np.zeros(Hm.shape[0], dtype=np.int8)
Hl = Hm.tolist()
for idx, M in enumerate(Hl):
    ranks[idx] = rank_small(M, p, k)
import collections
dist = collections.Counter(ranks.tolist())
print("    rank distribution:", dict(sorted(dist.items())))
print("    minimum rank over nonzero v:", int(ranks.min()))

# ---------------- p=11 random sampling ----------------
p, k = 11, 10
T11 = tensor(11)
Tm11 = T11.reshape(k * k, k)
rng = np.random.default_rng(20260906)
N = 100000
Vs = rng.integers(0, p, size=(N, k), dtype=np.int64)
Vs = Vs[Vs.any(axis=1)]
Hs = ((Vs @ Tm11.T) % p).reshape(-1, k, k).tolist()
mn = k + 1
cnt = collections.Counter()
for M in Hs:
    r = rank_small(M, p, k)
    cnt[r] += 1
    if r < mn:
        mn = r
print(f"--- p=11 random sample of {len(Hs)} nonzero v:")
print("    rank distribution:", dict(sorted(cnt.items())))
print("    minimum rank seen:", mn)
