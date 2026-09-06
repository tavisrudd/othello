"""C1071 Part C4: plane-section moment LP lower bound on c_4 in PG(3,q).

A coplanar four-subset of a cap A lies in exactly one plane, so
  c_4(A) = sum_pi C(n_pi, 4),
while the lower moments are fixed by k alone (using that A is a cap, so any three
points span a unique plane):
  sum_pi 1          = theta_3 = q^3+q^2+q+1
  sum_pi n_pi       = k (q^2+q+1)
  sum_pi C(n_pi,2)  = C(k,2)(q+1)
  sum_pi C(n_pi,3)  = C(k,3)

LP relaxation: variables p_j >= 0 = number of planes meeting A in j points,
j = 0..min(k, q+2); minimize sum_j C(j,4) p_j subject to the four equalities.

Compare against the pencil bound c_4 >= C(k,2)(k-q-3)/6.

Run:
  uv run --with scipy --with numpy python3 notes/scratch/c1071/c4_plane_lp.py
"""

from math import comb

import numpy as np
from scipy.optimize import linprog

print(f"{'q':>3} {'k':>4} {'jmax':>5} {'LP min c_4':>14} {'pencil bound':>14} "
      f"{'LP/pencil':>10} {'status':>8}")

rows = []
for q in (13, 16, 25):
    k = round(2**0.5 * q) + 2
    theta3 = q**3 + q**2 + q + 1
    jmax = min(k, q + 2)
    js = list(range(jmax + 1))

    A_eq = [
        [1.0 for j in js],
        [float(j) for j in js],
        [float(comb(j, 2)) for j in js],
        [float(comb(j, 3)) for j in js],
    ]
    b_eq = [
        float(theta3),
        float(k * (q**2 + q + 1)),
        float(comb(k, 2) * (q + 1)),
        float(comb(k, 3)),
    ]
    c = [float(comb(j, 4)) for j in js]

    res = linprog(c, A_eq=np.array(A_eq), b_eq=np.array(b_eq),
                  bounds=[(0, None)] * len(js), method="highs")
    pencil = comb(k, 2) * (k - q - 3) / 6.0
    lp = res.fun if res.success else float("nan")
    ratio = lp / pencil if pencil else float("inf")
    print(f"{q:>3} {k:>4} {jmax:>5} {lp:>14.4f} {pencil:>14.4f} {ratio:>10.4f} "
          f"{('ok' if res.success else res.message[:8]):>8}")
    rows.append((q, k, lp, pencil, res))

print()
print("optimal plane-occupancy profiles (nonzero p_j, rounded):")
for q, k, lp, pencil, res in rows:
    if not res.success:
        continue
    jmax = min(k, q + 2)
    nz = [(j, v) for j, v in enumerate(res.x) if v > 1e-6]
    print(f"  q={q}, k={k}: " + ", ".join(f"p_{j}={v:.4f}" for j, v in nz))

print()
print("leading-term comparison at the covering scale k = sqrt2 q + O(1):")
print("  pencil bound c_4 >= C(k,2)(k-q-3)/6 ~ ((sqrt2-1)/6) q^3 =",
      f"{(2**0.5 - 1)/6:.6f} q^3")
for q, k, lp, pencil, res in rows:
    if res.success:
        print(f"  q={q}: LP min / q^3 = {lp/q**3:.6f},  "
              f"pencil / q^3 = {pencil/q**3:.6f}")
