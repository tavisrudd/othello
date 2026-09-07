"""Follow-up to Test 3(c): is the logical cubic of the distance-three polynomial codes
[[p, (p-5)/2, 3]]_p (S = RS_2, L = RS_{(p-1)/2}, Lagrange-type weights) a coupled resource?

Logical coordinates: L/S has basis x^2, ..., x^{b-1}; F(u) = sum_i w_i (sum_j u_j alpha_i^j)^3
with w spanning (S o L o L)^perp.  Exhaustive Hessian-rank census over F_p^k and M_2, compared
with the product and bipartition bounds (same conventions as test1_magic.py).
"""
import itertools
import math
from fractions import Fraction

from conic import rank, rref
from test3c_rs import rs_basis, perp


def main():
    for p in (7, 11, 13):
        a, b = 2, (p - 1) // 2
        pts = list(range(p))
        S = rs_basis(p, a, pts)
        L = rs_basis(p, b, pts)
        SLL = rref([[(s * x * y) % p for s, x, y in zip(S[i], L[j], L[l])]
                    for i in range(a) for j in range(b) for l in range(j, b)], p)[0]
        W = perp(SLL, p, p)
        assert len(W) == 1, len(W)
        w = W[0]
        k = b - a
        # logical cubic F(u) = sum_i w_i (sum_{j} u_j alpha_i^{j+2})^3 ; Hessian tensor
        A = [[[0] * k for _ in range(k)] for _ in range(k)]
        for i, al in enumerate(pts):
            x = [pow(al, j + 2, p) for j in range(k)]
            for m in range(k):
                for j in range(k):
                    for l in range(k):
                        A[m][j][l] = (A[m][j][l] + w[i] * x[m] * x[j] * x[l]) % p
        N = {}
        for v in itertools.product(range(p), repeat=k):
            H = [[sum(v[m] * A[m][j][l] for m in range(k)) % p for l in range(k)] for j in range(k)]
            r = rank(H, p) if any(v) else 0
            N[r] = N.get(r, 0) + 1
        s = sum(Fraction(n, p ** r) for r, n in N.items())
        m2 = math.log(Fraction(p ** k) / s)
        prod = k * math.log(p * p / (2 * p - 1))
        bip = max((math.log((p ** c + 1) / 2) + math.log((p ** (k - c) + 1) / 2)) for c in range(1, k // 2 + 1)) if k >= 2 else float("nan")
        print(f"p={p} [[{p},{k},3]]_{p}: weights w={w}; Hessian census {dict(sorted(N.items()))}; "
              f"r_min={min(r for r in N if r)}; M2={m2:.4f} vs product {prod:.4f}, max bipartition product bound {bip:.4f}; "
              f"pure-state bound {math.log((p**k+1)/2):.4f}")


if __name__ == "__main__":
    main()
