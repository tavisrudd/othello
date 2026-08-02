import numpy as np
from math import comb
from scipy.optimize import linprog

def K(j, w, n):
    return sum((-1)**i * comb(w, i) * comb(n - w, j - i) for i in range(0, j + 1))

def lp_feasible(n, dperp, verbose=False):
    """Feasibility of weight distribution of a LINEAR triply-even code, d(C^perp) >= dperp.
       Variables A_w, w in {8,16,...,<=n}. Constraints:
         sum_w A_w K_j(w) = -C(n,j)   for j = 1..dperp-1        (B_j = 0)
         sum_w A_w K_j(w) >= -C(n,j)  for j = dperp..n           (B_j >= 0)
         A_w >= 0
         sum_w A_w >= n^2/2 - 1       (Sidon bound: d^perp>=5 => |C| >= n^2/2)
    """
    ws = [w for w in range(8, n + 1, 8)]
    if not ws: return False
    m = len(ws)
    A_eq = [[K(j, w, n) for w in ws] for j in range(1, dperp)]
    b_eq = [-comb(n, j) for j in range(1, dperp)]
    A_ub = [[-K(j, w, n) for w in ws] for j in range(dperp, n + 1)]
    b_ub = [comb(n, j) for j in range(dperp, n + 1)]
    if dperp >= 5:
        A_ub.append([-1.0] * m); b_ub.append(-(n * n / 2 - 1))
    res = linprog(c=[0.0] * m, A_ub=np.array(A_ub, dtype=float), b_ub=np.array(b_ub, dtype=float),
                  A_eq=np.array(A_eq, dtype=float), b_eq=np.array(b_eq, dtype=float),
                  bounds=[(0, None)] * m, method='highs')
    return res.status == 0

print("Sanity: n=256, dperp=8 (RM(2,8) exists) ->", lp_feasible(256, 8))
print("Sanity: n=16,  dperp=4 (RM(1,4) exists) ->", lp_feasible(16, 4))
print()
print("Feasibility of triply-even with d_perp >= 5:")
for n in [16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 128, 144, 160, 176, 192, 208, 224, 240, 256]:
    f5 = lp_feasible(n, 5)
    print(f"  n={n:4d}:  d_perp>=5 {'FEASIBLE' if f5 else 'INFEASIBLE (LP certificate)'}")
