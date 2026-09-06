"""C1071 Part C4 follow-up: is the plane-section LP minimum equal to the pencil
bound C(k,2)(k-q-3)/6 identically, or only at the covering scale?

Sweep q and k and compare.

Run:
  uv run --with scipy --with numpy python3 notes/scratch/c1071/c4b_lp_sweep.py
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
    return (res.fun if res.success else None), res


print(f"{'q':>3} {'k':>4} {'LP min':>13} {'pencil':>13} {'diff':>12} "
      f"{'B3':>4} {'nonzero p_j':>28}")
for q in (5, 7, 8, 9, 11, 13, 16, 25):
    for k in (q + 2, q + 3, q + 5, round(2**0.5 * q) + 2, 2 * q + 2, 2 * q + 6):
        if k < 4 or k > q**2 + 1:
            continue
        val, res = lp_min(q, k)
        pencil = comb(k, 2) * max(k - q - 3, 0) / 6.0
        t = q + 1
        s, b = divmod(k - 2, t)
        B3 = t * comb(s, 2) + s * b
        pencil_exact = comb(k, 2) * B3 / 6.0
        nz = ",".join(f"{j}:{v:.1f}" for j, v in enumerate(res.x) if v > 1e-6) \
            if res.success else "fail"
        if val is None:
            print(f"{q:>3} {k:>4} {'infeasible':>13}")
            continue
        print(f"{q:>3} {k:>4} {val:>13.4f} {pencil_exact:>13.4f} "
              f"{val - pencil_exact:>12.4f} {B3:>4} {nz[:28]:>28}")
