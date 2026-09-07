import sys
import itertools
sys.path.insert(0, "/tmp/claude-1000/-home-tavis-src-othello-rust/"
                   "936bbcce-b386-4c99-97f5-4318b618ed8d/scratchpad/"
                   "clebsch-replay")
import numpy as np
from common import gmat, A7_CLAIM, A11_CLAIM


def nullspace(G, p):
    """Basis of {x : G x = 0} for G given as list of rows, mod p."""
    A = np.array(G, dtype=np.int64) % p
    nr, nc = A.shape
    piv = []
    r = 0
    for c in range(nc):
        nz = np.nonzero(A[r:, c])[0]
        if nz.size == 0:
            continue
        i = r + nz[0]
        if i != r:
            A[[r, i]] = A[[i, r]]
        A[r] = (A[r] * pow(int(A[r, c]), p - 2, p)) % p
        col = A[:, c].copy()
        col[r] = 0
        A = (A - np.outer(col, A[r])) % p
        piv.append(c)
        r += 1
        if r == nr:
            break
    free = [c for c in range(nc) if c not in piv]
    basis = []
    for f in free:
        v = np.zeros(nc, dtype=np.int64)
        v[f] = 1
        for i, c in enumerate(piv):
            v[c] = (-A[i, f]) % p
        basis.append(v)
    return np.array(basis, dtype=np.int64) % p


def enumerate_code(B, p):
    """Weight distribution of the code spanned by rows of B."""
    d, n = B.shape
    N = p ** d
    idx = np.arange(N, dtype=np.int64)
    C = np.empty((N, d), dtype=np.int64)
    for j in range(d):
        C[:, j] = (idx // (p ** j)) % p
    W = (C @ B) % p
    wt = (W != 0).sum(axis=1)
    return np.bincount(wt, minlength=n + 1)


# ---------------- p = 7 ----------------
p = 7
G = gmat(7)
Garr = np.array(G, dtype=np.int64)
K = nullspace(G, 7)
print("p=7: dim ker G =", K.shape[0])
distL = enumerate_code(Garr, 7)
distK = enumerate_code(K, 7)
print("p=7: A_w for L      :", {w: int(c) for w, c in enumerate(distL) if c})
print("p=7: A_w for ker G  :", {w: int(c) for w, c in enumerate(distK) if c})
print("p=7: L enumerator == ker G enumerator:", bool((distL == distK).all()))
claim = np.zeros(15, dtype=np.int64)
for w, c in A7_CLAIM.items():
    claim[w] = c
print("p=7: matches claimed table:", bool((distL == claim).all()))
if not (distL == claim).all():
    print("     diffs:", {w: (int(distL[w]), int(claim[w]))
                          for w in range(15) if distL[w] != claim[w]})
print("p=7: total =", int(distL.sum()), "= 7^7:", int(distL.sum()) == 7 ** 7)
nz = [w for w in range(1, 15) if distL[w]]
print("p=7: minimum nonzero weight =", min(nz))

# witness word p=7
w7 = np.zeros(14, dtype=np.int64)
for s, v in zip((0, 1, 2, 4, 7, 13), (2, 2, 5, 5, 6, 1)):
    w7[s] = v
print("p=7 witness in ker G:", not ((Garr @ w7) % 7).any(),
      "weight:", int((w7 != 0).sum()))

# ---------------- p = 11 ----------------
p = 11
G11 = np.array(gmat(11), dtype=np.int64)
w11 = np.zeros(22, dtype=np.int64)
for s, v in zip((0, 1, 2, 3, 4, 9, 17, 20), (2, 2, 9, 9, 2, 9, 10, 1)):
    w11[s] = v
print("p=11 witness in ker G:", not ((G11 @ w11) % 11).any(),
      "weight:", int((w11 != 0).sum()))


def rank7(cols, p, nr):
    m = [list(c) for c in cols]           # rows = the chosen columns, len nr
    k = len(m)
    r = 0
    for c in range(nr):
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
                m[i] = [(m[i][j] - f * mr[j]) % p for j in range(nr)]
        r += 1
        if r == k:
            break
    return r


cols = [tuple(int(x) for x in G11[:, j]) for j in range(22)]
bad = 0
worst = None
for S in itertools.combinations(range(22), 7):
    if rank7([cols[j] for j in S], 11, 11) < 7:
        bad += 1
        if worst is None:
            worst = S
print("p=11: column subsets of size 7 with rank < 7 :", bad, worst)
print("      -> no nonzero kernel word of weight <= 7:", bad == 0)
