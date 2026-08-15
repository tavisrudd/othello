"""Diagnostic: where is the truncated P^2 big quantum product actually associative?
Associativity failure = truncation error, so ||[C_H, C_H2]|| bounds the region we may trust.
"""
import numpy as np
from math import factorial, comb

def kontsevich_N(dmax):
    N = {1: 1.0}
    for d in range(2, dmax + 1):
        tot = 0.0
        for dA in range(1, d):
            dB = d - dA
            t1 = dA * dA * dB * dB * comb(3 * d - 4, 3 * dA - 2)
            t2 = dA ** 3 * dB * comb(3 * d - 4, 3 * dA - 1)
            tot += N[dA] * N[dB] * (t1 - t2)
        N[d] = tot
    return N

def make(dmax):
    N = kontsevich_N(dmax)
    def ABCD(s):
        A = B = C = D = 0.0
        for d in range(1, dmax + 1):
            nd = N[d]
            for k, which in ((4, 0), (3, 1), (2, 2), (1, 3)):
                e = 3 * d - k
                if e < 0:
                    continue
                t = nd * s ** e / factorial(e)
                if which == 0: A += t
                elif which == 1: B += t * d
                elif which == 2: C += t * d ** 2
                else: D += t * d ** 3
        return A, B, C, D
    return N, ABCD

for dmax in (6, 9, 12, 15):
    N, ABCD = make(dmax)
    print(f"\nDMAX={dmax}  N_max={N[dmax]:.3e}")
    print("     s      ||[C_H,C_H2]||     min eigen-gap of U")
    for s in (0.2, 0.5, 0.8, 1.0, 1.2, 1.5, 1.9557):
        A, B, C, D = ABCD(s)
        CH = np.array([[0, C, B], [1, D, C], [0, 1, 0]], float)
        CH2 = np.array([[0, B, A], [0, C, B], [1, 0, 0]], float)
        U = 3 * CH - s * CH2
        ev = np.linalg.eigvals(U)
        gap = min(abs(ev[i] - ev[j]) for i in range(3) for j in range(i + 1, 3))
        print(f"  {s:6.4f}   {np.abs(CH @ CH2 - CH2 @ CH).max():.3e}      {gap:.4f}")
