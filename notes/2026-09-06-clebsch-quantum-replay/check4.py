import sys
sys.path.insert(0, "/tmp/claude-1000/-home-tavis-src-othello-rust/"
                   "936bbcce-b386-4c99-97f5-4318b618ed8d/scratchpad/"
                   "clebsch-replay")
import numpy as np
from common import data, eps, gmat


def rank_np(M, p):
    """Rank of an integer matrix mod prime p (numpy, int64)."""
    A = np.array(M, dtype=np.int64) % p
    nr, nc = A.shape
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
        r += 1
        if r == nr:
            break
    return r


for p in (7, 11) if __name__ == "__main__" else ():
    n, k = 2 * p, p - 1
    E, _, _ = data(p)
    ep = np.array([1] * p + [p - 1] * p, dtype=np.int64)
    Earr = np.array(E, dtype=np.int64) % p
    G = np.array(gmat(p), dtype=np.int64) % p  # p x n basis of L
    print(f"--- p={p}")

    # radical of T on L: v in L with sum_i eps_i v_i (g_b)_i (g_c)_i = 0 all b,c
    rows = []
    for b in range(p):
        for c in range(b, p):
            w = (ep * G[b] * G[c]) % p              # linear functional on v
            rows.append([int(x) for x in (w @ G.T) % p])  # in coords of L
    Msys = np.array(rows, dtype=np.int64) % p
    rk = rank_np(Msys, p)
    print("  radical dim (inside L) =", p - rk, "(claim 1)")
    # is the all-ones vector (coefficient e_0 in the G basis) in the radical?
    v = np.zeros(p, dtype=np.int64)
    v[0] = 1
    print("  <1> in radical:", bool(np.all((Msys @ v) % p == 0)))

    # descended trilinear form on F_p^k
    T = np.einsum('i,ia,ib,ic->abc', ep, Earr, Earr, Earr) % p
    eqs = []
    for al in range(k):
        for be in range(k):
            for ga in range(k):
                r1 = np.zeros(k * k, dtype=np.int64)
                r2 = np.zeros(k * k, dtype=np.int64)
                for mu in range(k):
                    r1[mu * k + al] += T[mu, be, ga]
                    r1[mu * k + be] -= T[al, mu, ga]
                    r2[mu * k + be] += T[al, mu, ga]
                    r2[mu * k + ga] -= T[al, be, mu]
                eqs.append(r1 % p)
                eqs.append(r2 % p)
    Meq = np.array(eqs, dtype=np.int64) % p
    rc = rank_np(Meq, p)
    print("  centroid system rank =", rc, "of", k * k,
          "-> centroid dim =", k * k - rc,
          "(claim rank", 35 if p == 7 else 99, ")")
    # confirm identity is a solution and that solution space is scalars
    Ident = np.eye(k, dtype=np.int64).reshape(-1)
    print("  identity solves:", bool(np.all((Meq @ Ident) % p == 0)))
