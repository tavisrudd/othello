from fractions import Fraction as F
from math import comb
import sys

def K(j, w, n):
    return sum((-1)**i * comb(w, i) * comb(n - w, j - i) for i in range(0, j + 1))

def justified_R(n):
    """|C| = 2^k and Sidon (from d_perp>=5) gives 2^k >= n(n-1)/2 + 1; round up to power of 2.
       Constraint used: sum_{w>0} A_w = |C| - 1 >= R."""
    need = n * (n - 1) // 2 + 1
    p = 1
    while p < need: p <<= 1
    return p - 1

def feasible_simplex(n, dperp=5, use_sidon=True, verbose=False):
    ws = [w for w in range(8, n + 1, 8)]
    v = len(ws)
    if v == 0: return False
    # structural variables: A_0..A_{v-1}, slacks s_j (j=dperp..n), sS, u_0..u_{v-1}
    m_ineq = n - dperp + 1
    NA, NS = v, m_ineq
    idx_A = list(range(v))
    idx_s = list(range(v, v + m_ineq))
    idx_sS = v + m_ineq
    idx_u = list(range(v + m_ineq + 1, v + m_ineq + 1 + v))
    N = v + m_ineq + 1 + v
    rows = []   # (coeff list over structural vars, rhs, basic_var or None)
    # equalities j=1..dperp-1, flipped to make rhs positive: sum(-K_j(w)) A_w = C(n,j)
    for j in range(1, dperp):
        co = [F(0)] * N
        for i, w in enumerate(ws): co[idx_A[i]] = F(-K(j, w, n))
        rows.append((co, F(comb(n, j)), None))
    # inequalities j=dperp..n: original sum K_j(w) A_w - s_j = -C(n,j); flipped: sum(-K) A + s = C(n,j)
    for t, j in enumerate(range(dperp, n + 1)):
        co = [F(0)] * N
        for i, w in enumerate(ws): co[idx_A[i]] = F(-K(j, w, n))
        co[idx_s[t]] = F(1)
        rows.append((co, F(comb(n, j)), idx_s[t]))
    # Sidon: sum A_w - sS = R
    if use_sidon and dperp >= 5:
        co = [F(0)] * N
        for i in range(v): co[idx_A[i]] = F(1)
        co[idx_sS] = F(-1)
        rows.append((co, F(justified_R(n)), None))
    # upper bounds A_w + u_w = C(n,w)
    for i, w in enumerate(ws):
        co = [F(0)] * N
        co[idx_A[i]] = F(1); co[idx_u[i]] = F(1)
        rows.append((co, F(comb(n, w)), idx_u[i]))
    m = len(rows)
    # add artificials where no basic var assigned
    art = []
    T = []       # tableau rows: coeffs over N + len(art) cols, then rhs
    basis = []
    for co, b, bv in rows:
        T.append((list(co), b))
        basis.append(bv)
    n_art = sum(1 for bv in basis if bv is None)
    total = N + n_art
    ai = 0
    for r in range(m):
        co, b = T[r]
        co = co + [F(0)] * n_art
        if basis[r] is None:
            co[N + ai] = F(1)
            basis[r] = N + ai
            ai += 1
        T[r] = (co, b)
    # Phase I objective: minimize sum of artificials. reduced-cost row = sum of artificial rows
    obj = [F(0)] * total
    val = F(0)
    for r in range(m):
        if basis[r] >= N:
            co, b = T[r]
            for c in range(total): obj[c] += co[c]
            val += b
    for c in range(N, total): obj[c] = F(0)   # basic artificials: reduced cost 0
    # in this convention: entering col = any col j < N (or any nonbasic) with obj[j] > 0 (Bland: smallest)
    it = 0
    while True:
        it += 1
        enter = None
        for c in range(N):   # structural columns only (artificials never re-enter)
            if obj[c] > 0:
                enter = c; break
        if enter is None: break
        # ratio test
        best = None; leave = None
        for r in range(m):
            a = T[r][0][enter]
            if a > 0:
                ratio = T[r][1] / a
                if best is None or ratio < best or (ratio == best and basis[r] < basis[leave]):
                    best = ratio; leave = r
        if leave is None:
            # unbounded phase-I cannot happen (objective bounded below by 0)
            raise RuntimeError("phase-I unbounded?!")
        # pivot
        co, b = T[leave]
        piv = co[enter]
        co = [x / piv for x in co]; b = b / piv
        T[leave] = (co, b); basis[leave] = enter
        for r in range(m):
            if r == leave: continue
            co2, b2 = T[r]
            f = co2[enter]
            if f != 0:
                T[r] = ([x - f * y for x, y in zip(co2, co)], b2 - f * b)
        f = obj[enter]
        if f != 0:
            obj = [x - f * y for x, y in zip(obj, co)]
            val = val - f * b
        if it > 20000: raise RuntimeError("iteration cap")
    return val == 0   # feasible iff artificials driven to zero

if __name__ == "__main__":
    n, dp = int(sys.argv[1]), int(sys.argv[2])
    f = feasible_simplex(n, dp)
    print(f"n={n}, dperp>={dp}: {'FEASIBLE (no conclusion)' if f else 'INFEASIBLE (exact certificate)'}")
