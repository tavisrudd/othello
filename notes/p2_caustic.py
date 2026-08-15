"""P^2 big quantum cohomology: find a caustic (coalescing Euler eigenvalues)
and compute the exponents of the coalesced block.

Conventions match the C912 memo:
  z^2 d_z Y = (U - z mu) Y,  i.e.  z d_z Y = (z^{-1}U - mu) Y
basis (1, H, H^2), mu = diag(-1,0,1), q = 1, bulk parameter s in the H^2 direction.
"""
import numpy as np
from math import factorial

DMAX = 9

def kontsevich_N(dmax):
    N = {1: 1.0}
    for d in range(2, dmax + 1):
        tot = 0.0
        for dA in range(1, d):
            dB = d - dA
            if dA not in N or dB not in N:
                continue
            from math import comb
            t1 = dA * dA * dB * dB * comb(3 * d - 4, 3 * dA - 2)
            t2 = dA ** 3 * dB * comb(3 * d - 4, 3 * dA - 1)
            tot += N[dA] * N[dB] * (t1 - t2)
        N[d] = tot
    return N

N = kontsevich_N(DMAX)

def ABCD(s):
    """A=d_s^3 F, B=d_t d_s^2 F, C=d_t^2 d_s F, D=d_t^3 F at q=1."""
    A = B = C = D = 0.0 + 0j
    for d in range(1, DMAX + 1):
        nd = N[d]
        for (k, acc) in ((4, 'A'), (3, 'B'), (2, 'C'), (1, 'D')):
            e = 3 * d - k
            if e < 0:
                continue
            term = nd * s ** e / factorial(e)
            if acc == 'A':
                A += term
            elif acc == 'B':
                B += term * d
            elif acc == 'C':
                C += term * d ** 2
            else:
                D += term * d ** 3
    return A, B, C, D

def U_of(s):
    A, B, C, D = ABCD(s)
    return np.array([
        [0.0 + 0j, 3 * C - s * B, 3 * B - s * A],
        [3.0 + 0j, 3 * D - s * C, 3 * C - s * B],
        [-s + 0j,  3.0 + 0j,      0.0 + 0j],
    ], dtype=complex)

def disc(s):
    ev = np.linalg.eigvals(U_of(s))
    d = 1.0 + 0j
    for i in range(3):
        for j in range(i + 1, 3):
            d *= (ev[i] - ev[j]) ** 2
    return d

# sanity: s=0 must give lambda^3 = 27 q = 27
print("U(0) eigenvalues:", np.sort_complex(np.linalg.eigvals(U_of(0.0))))
print("expected 3*cube roots of 1 times 3:", np.sort_complex(np.array([3 * np.exp(2j * np.pi * k / 3) for k in range(3)])))

# scan for near-collisions
best = []
for re in np.linspace(-2.0, 2.0, 81):
    for im in np.linspace(-2.0, 2.0, 81):
        s = re + 1j * im
        try:
            ev = np.linalg.eigvals(U_of(s))
        except Exception:
            continue
        gaps = [abs(ev[i] - ev[j]) for i in range(3) for j in range(i + 1, 3)]
        best.append((min(gaps), s))
best.sort(key=lambda t: t[0])
print("\nsmallest eigenvalue gaps on the scan:")
for g, s in best[:6]:
    print(f"  gap={g:.4f}  s={s:.4f}")

# refine with Muller / secant on disc(s)=0
def refine(s0):
    s_prev, s_cur = s0 * 0.98, s0
    f_prev, f_cur = disc(s_prev), disc(s_cur)
    for _ in range(200):
        if abs(f_cur - f_prev) < 1e-300:
            break
        s_new = s_cur - f_cur * (s_cur - s_prev) / (f_cur - f_prev)
        s_prev, f_prev = s_cur, f_cur
        s_cur, f_cur = s_new, disc(s_new)
        if abs(f_cur) < 1e-24:
            break
    return s_cur

for _, s0 in best[:3]:
    s_star = refine(s0)
    ev = np.linalg.eigvals(U_of(s_star))
    gaps = sorted(abs(ev[i] - ev[j]) for i in range(3) for j in range(i + 1, 3))
    print(f"\nrefined s* = {s_star:.10f}   |disc| = {abs(disc(s_star)):.3e}")
    print(f"  eigenvalues: {np.round(ev, 8)}")
    print(f"  smallest gap: {gaps[0]:.3e}")
