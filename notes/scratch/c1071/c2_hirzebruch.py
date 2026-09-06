"""C1071 Part C2: Hirzebruch bookkeeping for the secant line arrangement of a
rank-three MATCH(k, floor(k/2), 1) realization.

d = C(k,2) lines (the secants).  Multiplicity k-1 at each of the k arc points
(t_{k-1} = k), multiplicity m = floor(k/2) at each concurrence point of a matching
block, and no other multiple points.  Block count from the pair identity
  C(d,2) = k*C(k-1,2) + t_m * C(m,2).

LHS_a = t_2 + t_3           (reviewer's quoted form)
LHS_b = t_2 + (3/4) t_3     (Hirzebruch's usual form)
RHS   = d + sum_{r>=5} (r-4) t_r

Run:
  python3 notes/scratch/c1071/c2_hirzebruch.py
"""

from fractions import Fraction
from math import comb

print(f"{'k':>3} {'d':>5} {'m':>3} {'t_m':>10} {'int':>4} {'pairs ok':>9} "
      f"{'t_2':>5} {'t_3':>5} {'LHS_a':>7} {'LHS_b':>8} {'RHS':>5} "
      f"{'a holds':>8} {'b holds':>8}")

for k in range(4, 13):
    d = comb(k, 2)
    m = k // 2
    num = comb(d, 2) - k * comb(k - 1, 2)
    den = comb(m, 2)
    if den == 0:
        print(f"{k:>3} {d:>5} {m:>3} {'C(m,2)=0':>10}")
        continue
    tm_frac = Fraction(num, den)
    is_int = tm_frac.denominator == 1
    tm = int(tm_frac) if is_int else None

    # multiplicities present: k-1 at arc points (count k), m at t_m points
    mult = {}
    mult[k - 1] = mult.get(k - 1, 0) + k
    if tm is not None:
        mult[m] = mult.get(m, 0) + tm

    pairs_ok = (k * comb(k - 1, 2) + (tm or 0) * comb(m, 2) == comb(d, 2))

    t2 = mult.get(2, 0)
    t3 = mult.get(3, 0)
    rhs = d + sum((r - 4) * c for r, c in mult.items() if r >= 5)
    lhs_a = t2 + t3
    lhs_b = Fraction(t2) + Fraction(3, 4) * t3

    print(f"{k:>3} {d:>5} {m:>3} {str(tm_frac):>10} {str(is_int):>4} "
          f"{str(pairs_ok):>9} {t2:>5} {t3:>5} {lhs_a:>7} {str(lhs_b):>8} "
          f"{rhs:>5} {str(lhs_a >= rhs):>8} {str(lhs_b >= rhs):>8}")

print()
print("multiplicity spectra (r: t_r), and the t_d = t_{d-1} = 0 hypothesis:")
for k in range(4, 13):
    d = comb(k, 2)
    m = k // 2
    if comb(m, 2) == 0:
        print(f"k={k}: m={m}, C(m,2)=0, spectrum undefined by this formula")
        continue
    tm_frac = Fraction(comb(d, 2) - k * comb(k - 1, 2), comb(m, 2))
    tm = int(tm_frac) if tm_frac.denominator == 1 else tm_frac
    spec = {k - 1: k}
    spec[m] = spec.get(m, 0) + (tm if isinstance(tm, int) else 0)
    maxmult = max(spec)
    print(f"k={k}: d={d}, spectrum {sorted(spec.items())}, max mult {maxmult}, "
          f"d-1={d-1}, t_d=t_(d-1)=0 since max<{d-1}: {maxmult < d - 1}")
