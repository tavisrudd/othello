"""C1071 Part C4 follow-up 2: locate the k at which the plane-section LP minimum
first strictly exceeds the exact pencil bound C(k,2) B_3(k,q) / 6.

Run:
  uv run --with scipy --with numpy python3 notes/scratch/c1071/c4c_crossover.py
"""

from math import comb

import numpy as np
from scipy.optimize import linprog


def lp_min(q, k):
    theta3 = q**3 + q**2 + q + 1
    jmax = min(k, q + 2)
    js = list(range(jmax + 1))
    A_eq = np.array([
        [1.0] * len(js),
        [float(j) for j in js],
        [float(comb(j, 2)) for j in js],
        [float(comb(j, 3)) for j in js],
    ])
    b_eq = np.array([
        float(theta3),
        float(k * (q**2 + q + 1)),
        float(comb(k, 2) * (q + 1)),
        float(comb(k, 3)),
    ])
    c = [float(comb(j, 4)) for j in js]
    res = linprog(c, A_eq=A_eq, b_eq=b_eq, bounds=[(0, None)] * len(js),
                  method="highs")
    return res


def pencil(q, k):
    t = q + 1
    s, b = divmod(k - 2, t)
    return comb(k, 2) * (t * comb(s, 2) + s * b) / 6.0


for q in (5, 7, 13):
    print(f"q = {q}  (2q+4 = {2*q+4})")
    first = None
    for k in range(4, 3 * q + 8):
        res = lp_min(q, k)
        if not res.success:
            print(f"  k={k}: LP infeasible")
            continue
        p = pencil(q, k)
        d = res.fun - p
        flag = ""
        if d > 1e-6 and first is None:
            first = k
            flag = "   <-- first strict excess"
        p0 = res.x[0]
        print(f"  k={k:>3}  LP={res.fun:>11.4f}  pencil={p:>11.4f}  "
              f"diff={d:>10.4f}  p_0={p0:>9.2f}{flag}")
    print(f"  first k with LP > pencil: {first}\n")
