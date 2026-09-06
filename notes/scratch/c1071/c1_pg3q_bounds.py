"""C1071 Part C1: smallest k allowed in PG(3,q) by three coverage bounds.

For an ordinary complete cap (h = 0) in PG(3,q), theta_3 = q^3+q^2+q+1, N = C(k,2),
m = floor(k/2).

  (a) first moment:      theta_3 - k <= N (q-1)
  (b) refined (13):      theta_3 - k <= N (q - 2 + 1/(k-q-2))          [needs k >= q+3]
  (c) balanced pencil:   theta_3 - k <= N (q - 1 - max{B/m, B/(B+1)})
                         with t = q+1, k-2 = t s + b, B = B_3(k,q) = t C(s,2) + s b

Run:
  python3 notes/scratch/c1071/c1_pg3q_bounds.py
"""

from math import comb


def theta3(q):
    return q**3 + q**2 + q + 1


def B3(k, q):
    t = q + 1
    s, b = divmod(k - 2, t)
    return t * comb(s, 2) + s * b


def smallest_first_moment(q):
    for k in range(3, 20 * q + 20):
        if theta3(q) - k <= comb(k, 2) * (q - 1):
            return k
    return None


def smallest_refined(q):
    # only defined for k >= q+3 (so k-q-2 >= 1); scan from q+3 upward
    for k in range(q + 3, 20 * q + 20):
        if theta3(q) - k <= comb(k, 2) * (q - 2 + 1.0 / (k - q - 2)):
            return k
    return None


def smallest_pencil(q):
    for k in range(3, 20 * q + 20):
        B = B3(k, q)
        m = k // 2
        if m < 1:
            continue
        loss = max(B / m, B / (B + 1)) if B > 0 else 0.0
        if theta3(q) - k <= comb(k, 2) * (q - 1 - loss):
            return k
    return None


print(f"{'q':>3} {'theta_3':>9} {'first':>6} {'refined':>8} {'pencil':>7} "
      f"{'B3@pencil':>10} {'sqrt2*q':>8}")
for q in range(3, 14):
    kf = smallest_first_moment(q)
    kr = smallest_refined(q)
    kp = smallest_pencil(q)
    print(f"{q:>3} {theta3(q):>9} {kf:>6} {kr:>8} {kp:>7} {B3(kp, q):>10} "
          f"{2**0.5*q:>8.3f}")

print()
print("detail: for each q, the last excluded k under each bound")
for q in range(3, 14):
    kf, kr, kp = smallest_first_moment(q), smallest_refined(q), smallest_pencil(q)
    print(f"q={q}: first excludes up to k={kf-1}, refined up to k={kr-1}, "
          f"pencil up to k={kp-1}")

print()
print("C5: q=13, k=21")
print("  theta_3 - 21 =", theta3(13) - 21)
print("  C(21,2)*(11 + 1/6) =", comb(21, 2) * (11 + 1 / 6),
      "= exact", comb(21, 2) * 67, "/ 6 =", comb(21, 2) * 67 / 6)
print("  k-q-2 =", 21 - 13 - 2, " so 1/(k-q-2) = 1/6 and q-2 = 11: matches (13)")
print("  refined bound violated:", theta3(13) - 21 > comb(21, 2) * (11 + 1 / 6))
print("  first moment at k=21:", theta3(13) - 21, "<=", comb(21, 2) * 12,
      "->", theta3(13) - 21 <= comb(21, 2) * 12)
