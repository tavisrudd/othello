from fractions import Fraction as F
from math import comb
from itertools import combinations
import sympy as sp

def K(j, w, n):
    return sum((-1)**i * comb(w, i) * comb(n - w, j - i) for i in range(0, j + 1))

def feasible_exact(n, dperp, sidon=True):
    ws = [w for w in range(8, n + 1, 8)]
    v = len(ws)
    # equality constraints: sum_w A_w K_j(w) = -K_j(0), j=1..dperp-1
    Aeq = sp.Matrix([[K(j, w, n) for w in ws] for j in range(1, dperp)])
    beq = sp.Matrix([-comb(n, j) for j in range(1, dperp)])
    # particular solution + nullspace (rational, exact)
    sol = Aeq.gauss_jordan_solve(beq, freevar=True)
    xp_sym, free = sol
    free = list(free)
    d = len(free)
    # parameterize: A = xp(t) linear in free vars t
    # build affine map A_w = c0[w] + sum_k M[w][k] t_k exactly
    subs0 = {f: 0 for f in free}
    c0 = [xp_sym[i].subs(subs0) for i in range(v)]
    M = [[sp.simplify(xp_sym[i].coeff(f)) for f in free] for i in range(v)]
    cons = []  # (row (list of Fractions over t), rhs): row . t <= rhs
    def add_leq(coefs, rhs):
        cons.append(([F(sp.nsimplify(c)) if not isinstance(c, F) else c for c in coefs], F(sp.nsimplify(rhs))))
    # A_w >= 0  ->  -M t <= c0
    for i in range(v):
        add_leq([-M[i][k] for k in range(d)], c0[i])
    # B_j >= 0 for j = dperp..n :  -(sum_w K_j(w) A_w) <= K_j(0)
    for j in range(dperp, n + 1):
        row = [-sum(K(j, ws[i], n) * M[i][k] for i in range(v)) for k in range(d)]
        rhs = comb(n, j) + sum(K(j, ws[i], n) * c0[i] for i in range(v))
        add_leq(row, rhs)
    # Sidon: sum A_w >= n^2/2 - 1  -> -(sum) t <= sum c0 - (n^2/2 - 1)
    if sidon and dperp >= 5:
        row = [-sum(M[i][k] for i in range(v)) for k in range(d)]
        rhs = sum(c0) - (F(n * n, 2) - 1)
        add_leq(row, rhs)
    # Fourier–Motzkin eliminate all t
    def fm(cons, d):
        for var in range(d):
            pos, neg, zer = [], [], []
            for (a, b) in cons:
                if a[var] > 0: pos.append((a, b))
                elif a[var] < 0: neg.append((a, b))
                else: zer.append((a, b))
            new = list(zer)
            for (a1, b1) in pos:
                for (a2, b2) in neg:
                    # a1/a1[var] + (-a2)/(-a2[var]) combos: eliminate
                    c1, c2 = a1[var], -a2[var]
                    a = [x * c2 + y * c1 for x, y in zip(a1, a2)]
                    b = b1 * c2 + b2 * c1
                    new.append((a, b))
            # dedupe / prune trivially true
            seen = set(); pruned = []
            for (a, b) in new:
                if all(x == 0 for x in a):
                    if b < 0: return False   # 0 <= b < 0 : infeasible
                    continue
                g = None
                for x in a + [b]:
                    pass
                key = tuple(a) + (b,)
                # normalize by first nonzero abs
                nz = next(x for x in a if x != 0)
                s = abs(nz)
                key = tuple(x / s for x in a) + (b / s,)
                if key not in seen:
                    seen.add(key); pruned.append((a, b))
            cons = pruned
            if len(cons) > 30000: raise RuntimeError("FM blowup")
        # all vars eliminated: remaining constraints are 0 <= b
        for (a, b) in cons:
            if b < 0: return False
        return True
    return fm(cons, d)

# sanity checks against known codes
print("sanity (16, 4) [RM(1,4) exists]  ->", feasible_exact(16, 4))
print("sanity (16, 5) [hand-proved impossible] ->", feasible_exact(16, 5))
print()
for n in range(16, 89, 8):
    try:
        f = feasible_exact(n, 5)
        print(f"n={n:3d}: triply-even with d_perp>=5  ->  {'feasible (no conclusion)' if f else 'INFEASIBLE — exact certificate'}")
    except RuntimeError as e:
        print(f"n={n:3d}: {e}")
