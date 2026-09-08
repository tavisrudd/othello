"""check2: exhaustive Hessian-rank distribution and Pauli histogram for p=7,
for F_7 and the two comparison resources on the same 6 qudits."""
from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parents[1]/"reconstruction"))

import itertools
import sys
import time
from fractions import Fraction

import sympy as sp  # noqa: E402
from check1 import hess_tensor  # noqa: E402

P = 7
K = 6


def tensor_from_poly(expr, u, p):
    """A[m][j][l] = T(e_j,e_l,e_m) = (1/6) d^3 F / du_m du_j du_l, mod p."""
    k = len(u)
    inv6 = pow(6, p - 2, p)
    A = [[[0] * k for _ in range(k)] for _ in range(k)]
    for m in range(k):
        dm = sp.diff(expr, u[m])
        for j in range(k):
            dmj = sp.diff(dm, u[j])
            for l in range(k):
                A[m][j][l] = int(sp.diff(dmj, u[l])) * inv6 % p
    return A


def rank_mod_p(mat, p):
    m = [row[:] for row in mat]
    n = len(m)
    r = 0
    for c in range(n):
        piv = -1
        for i in range(r, n):
            if m[i][c]:
                piv = i
                break
        if piv < 0:
            continue
        m[r], m[piv] = m[piv], m[r]
        inv = pow(m[r][c], p - 2, p)
        m[r] = [x * inv % p for x in m[r]]
        for i in range(n):
            if i != r and m[i][c]:
                f = m[i][c]
                m[i] = [(m[i][j] - f * m[r][j]) % p for j in range(n)]
        r += 1
        if r == n:
            break
    return r


def rank_distribution(A, p, k, collect_min=False):
    counts = [0] * (k + 1)
    minset = []
    for v in itertools.product(range(p), repeat=k):
        H = [[0] * k for _ in range(k)]
        for m in range(k):
            vm = v[m]
            if not vm:
                continue
            Am = A[m]
            for j in range(k):
                Hj, Amj = H[j], Am[j]
                for l in range(k):
                    Hj[l] += vm * Amj[l]
        H = [[x % p for x in row] for row in H]
        r = rank_mod_p(H, p)
        counts[r] += 1
        if collect_min:
            minset.append((r, v))
    return counts, minset


def histogram(counts, p, k):
    """returns list of (r, N_r, n_paulis, |exp| as 'p^-r/2'), plus zero count and parseval."""
    rows = []
    zero = 0
    total_sq = Fraction(0)
    for r, N in enumerate(counts):
        if N == 0:
            continue
        npa = N * p ** r
        rows.append((r, N, npa))
        zero += N * (p ** k - p ** r)
        total_sq += Fraction(npa, p ** r)
    return rows, zero, total_sq


def report(name, counts, p, k):
    rows, zero, tot = histogram(counts, p, k)
    print(f"\n== {name}  (p={p}, k={k})")
    print("  rank distribution N_r:", {r: c for r, c in enumerate(counts) if c})
    print("  sum N_r =", sum(counts), "== p^k =", p ** k, sum(counts) == p ** k)
    print("  Pauli histogram (|<P>| = p^{-r/2}):")
    for r, N, npa in rows:
        print(f"    r={r}  |<P>|=p^-{r}/2 = {p ** (-r / 2):.6f}   #Paulis = {npa}")
    print(f"    |<P>|=0 : #Paulis = {zero}")
    print("  total Paulis =", sum(n for _, _, n in rows) + zero, "== p^2k =", p ** (2 * k),
          sum(n for _, _, n in rows) + zero == p ** (2 * k))
    print("  sum |<P>|^2 =", tot, "== p^k:", tot == p ** k)
    nz = [r for r, c in enumerate(counts) if c and r > 0]
    rmin = min(nz)
    print(f"  min nonzero-v rank r_min = {rmin}  -> max nonscalar |<P>| = p^-{rmin}/2 ="
          f" {p ** (-rmin / 2):.6f}   (N_rmin = {counts[rmin]})")
    return rows, zero, tot


if __name__ == "__main__":
    u = sp.symbols("u0:6")
    t0 = time.time()

    A_F7 = hess_tensor(7)
    A_prod = tensor_from_poly(sum(x ** 3 for x in u), u, P)
    A_ccz = tensor_from_poly(u[0] * u[1] * u[2] + u[3] * u[4] * u[5], u, P)

    res = {}
    for name, A, collect in (("F_7 (Clebsch)", A_F7, True),
                             ("product |M>^{x6}, F=sum u_i^3", A_prod, False),
                             ("two CCZ blocks, F=u0u1u2+u3u4u5", A_ccz, False)):
        t = time.time()
        counts, ms = rank_distribution(A, P, K, collect_min=collect)
        print(f"\n[{time.time() - t:.1f}s] {name}")
        res[name] = report(name, counts, P, K)
        if collect:
            nz = [r for r, c in enumerate(counts) if c and r > 0]
            rmin = min(nz)
            mv = [v for r, v in ms if r == rmin]
            with open("minrank7.txt", "w") as fh:
                fh.write(f"# r_min={rmin} count={len(mv)}\n")
                for v in mv:
                    fh.write(" ".join(map(str, v)) + "\n")
            print(f"  wrote minrank7.txt ({len(mv)} vectors at rank {rmin})")
    print(f"\ntotal {time.time() - t0:.1f}s")
