"""At the P^2 caustic, decouple the coalesced 2x2 block, shear it, and read the
exponents.  Same normalisation as Section 8 of the C912 memo:

  z d_z Y = (z^{-1} U - mu) Y
  decoupling gauge g = I + z g1 + z^2 g2, block-diagonal parts set to zero
  block data after the exponential twist:  z^{-1} N + A0 + z A1 + ...
     A0 = -mu|block
     A1 = mu_{12} mu_{21} (U_1 - u_other)^{-1}
  shear diag(1,z) in a frame with N = nu E_12:
     R = nu E_12 + diag((A0)_11, (A0)_22 - 1) + (A1)_21 E_21
  exponents = eigenvalues of R
"""
import numpy as np
from p2_caustic import U_of, disc, refine

np.set_printoptions(precision=10, suppress=False)

MU = np.diag([-1.0 + 0j, 0.0 + 0j, 1.0 + 0j])

def analyse(s_star, label):
    U = U_of(s_star)
    ev = np.linalg.eigvals(U)
    # identify the coalesced pair and the simple eigenvalue
    pairs = [(abs(ev[i] - ev[j]), i, j) for i in range(3) for j in range(i + 1, 3)]
    pairs.sort()
    _, i, j = pairs[0]
    k = ({0, 1, 2} - {i, j}).pop()
    u0 = 0.5 * (ev[i] + ev[j])
    u1 = ev[k]

    # generalised eigenspace for u0 = kernel of (U-u0)^2 ; eigenvector for u1
    M = U - u0 * np.eye(3)
    M2 = M @ M
    _, S, Vh = np.linalg.svd(M2)
    block_basis = Vh[1:].conj().T           # two smallest singular directions
    w, V = np.linalg.eig(U)
    v1 = V[:, np.argmin(abs(w - u1))].reshape(3, 1)
    T = np.hstack([block_basis, v1])
    Tinv = np.linalg.inv(T)

    Ub = Tinv @ U @ T
    Mub = Tinv @ MU @ T
    U1 = Ub[:2, :2]
    off_check = max(abs(Ub[:2, 2]).max(), abs(Ub[2, :2]).max())

    mu11 = Mub[:2, :2]
    mu12 = Mub[:2, 2:3]
    mu21 = Mub[2:3, :2]

    N = U1 - u0 * np.eye(2)
    A0 = -mu11
    A1 = mu12 @ mu21 @ np.linalg.inv(U1 - u1 * np.eye(2))

    # frame with N = nu E_12 :  e1 spans im N, e2 any vector with N e2 = nu e1
    uN, sN, VhN = np.linalg.svd(N)
    e1 = uN[:, 0].reshape(2, 1)
    e2 = VhN[0].conj().reshape(2, 1)
    F = np.hstack([e1, e2])
    Finv = np.linalg.inv(F)
    Nf = Finv @ N @ F
    nu = Nf[0, 1]
    A0f = Finv @ A0 @ F
    A1f = Finv @ A1 @ F

    f = A0f[1, 0]
    R = np.array([[A0f[0, 0], nu], [A1f[1, 0], A0f[1, 1] - 1.0]], dtype=complex)
    rho = np.linalg.eigvals(R)

    print(f"\n=== {label}:  s* = {s_star:.10f} ===")
    print(f"  |disc| = {abs(disc(s_star)):.3e}   block off-diagonal residue = {off_check:.2e}")
    print(f"  coalesced eigenvalue u0 = {u0:.8f}, other u1 = {u1:.8f}")
    print(f"  nilpotent part N (should be nonzero, N^2=0):")
    print(f"    N = {np.round(Nf, 10).tolist()},  nu = {nu:.8f}, |N^2| = {abs(Nf@Nf).max():.2e}")
    print(f"  f = (A0)_21 = {f:.3e}   (must vanish for regular singularity)")
    print(f"  R = {np.round(R, 8).tolist()}")
    print(f"  tr R = {np.trace(R):.10f}    (cubic gave -1)")
    print(f"  det R = {np.linalg.det(R):.10f}   (cubic gave 5/36 = {5/36:.10f})")
    print(f"  exponents rho = {np.round(rho, 8)}")
    print(f"  monodromy eigenvalues exp(2 pi i rho) = {np.round(np.exp(2j*np.pi*rho), 8)}")
    for r in rho:
        for (p, q) in ((1, 6), (5, 6), (-1, 6), (-5, 6), (1, 2), (1, 3), (2, 3), (0, 1)):
            if abs((r - p / q) - round(float((r - p / q).real))) < 1e-5 and abs(r.imag) < 1e-5:
                print(f"    rho = {r:.8f}  ==  {p}/{q}  mod Z")
                break

for s0 in (1.9557401913 + 0j, 1.6041320555 - 1.2475623739j):
    s_star = refine(s0)
    analyse(s_star, "real caustic" if abs(s_star.imag) < 1e-6 else "complex caustic")
