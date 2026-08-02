from fractions import Fraction as F
from math import comb

def K(j, w, n):
    return sum((-1)**i * comb(w, i) * comb(n - w, j - i) for i in range(0, j + 1))

def solve_affine(Aeq, beq, v):
    """exact: return (c0, M, d) with solution set {c0 + M t}, or None if inconsistent"""
    rows = [[F(x) for x in row] + [F(b)] for row, b in zip(Aeq, beq)]
    piv_cols = []
    r = 0
    for c in range(v):
        piv = next((i for i in range(r, len(rows)) if rows[i][c] != 0), None)
        if piv is None: continue
        rows[r], rows[piv] = rows[piv], rows[r]
        pr = rows[r]; pv = pr[c]
        rows[r] = [x / pv for x in pr]
        for i in range(len(rows)):
            if i != r and rows[i][c] != 0:
                f = rows[i][c]
                rows[i] = [x - f * y for x, y in zip(rows[i], rows[r])]
        piv_cols.append(c); r += 1
    for i in range(r, len(rows)):
        if rows[i][v] != 0: return None
    free = [c for c in range(v) if c not in piv_cols]
    d = len(free)
    c0 = [F(0)] * v
    M = [[F(0)] * d for _ in range(v)]
    for k, fc in enumerate(free): M[fc][k] = F(1)
    for i, pc in enumerate(piv_cols):
        c0[pc] = rows[i][v]
        for k, fc in enumerate(free):
            M[pc][k] = -rows[i][fc]
    return c0, M, d

def feasible_exact(n, dperp, sidon=True, cap=40000):
    ws = [w for w in range(8, n + 1, 8)]
    v = len(ws)
    Aeq = [[K(j, w, n) for w in ws] for j in range(1, dperp)]
    beq = [-comb(n, j) for j in range(1, dperp)]
    sol = solve_affine(Aeq, beq, v)
    if sol is None: return False
    c0, M, d = sol
    cons = []
    def add(row, rhs): cons.append(([F(x) for x in row], F(rhs)))
    for i in range(v):
        add([-M[i][k] for k in range(d)], c0[i])
    for j in range(dperp, n + 1):
        row = [-sum(K(j, ws[i], n) * M[i][k] for i in range(v)) for k in range(d)]
        rhs = comb(n, j) + sum(K(j, ws[i], n) * c0[i] for i in range(v))
        add(row, rhs)
    if sidon and dperp >= 5:
        add([-sum(M[i][k] for i in range(v)) for k in range(d)],
            sum(c0) - (F(n * n, 2) - 1))
    for var in range(d):
        pos = [(a, b) for a, b in cons if a[var] > 0]
        neg = [(a, b) for a, b in cons if a[var] < 0]
        zer = [(a, b) for a, b in cons if a[var] == 0]
        new = list(zer)
        for a1, b1 in pos:
            for a2, b2 in neg:
                c1, c2 = a1[var], -a2[var]
                a = [x * c2 + y * c1 for x, y in zip(a1, a2)]
                b = b1 * c2 + b2 * c1
                new.append((a, b))
        seen = set(); pruned = []
        for a, b in new:
            if all(x == 0 for x in a):
                if b < 0: return False
                continue
            nz = abs(next(x for x in a if x != 0))
            key = tuple(x / nz for x in a) + (b / nz,)
            if key not in seen:
                seen.add(key); pruned.append((a, b))
        cons = pruned
        if len(cons) > cap: raise RuntimeError(f"FM blowup ({len(cons)})")
    return all(b >= 0 for a, b in cons)

print("sanity (16, 4) [RM(1,4) exists]    ->", feasible_exact(16, 4))
print("sanity (16, 5) [hand-proved infeas]->", feasible_exact(16, 5))
print()
for n in range(16, 97, 8):
    try:
        f = feasible_exact(n, 5)
        print(f"n={n:3d}: d_perp>=5 -> {'feasible (no conclusion)' if f else 'INFEASIBLE (exact certificate)'}")
    except RuntimeError as e:
        print(f"n={n:3d}: {e}")
