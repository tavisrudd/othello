"""check1: rebuild the cubics from E_p, verify against B1/B2, expose the Hessian tensor."""
from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parents[1]/"reconstruction"))

import sys

from common import data, eps  # noqa: E402

import sympy as sp  # noqa: E402


def cubic_from_E(p):
    E, _, _ = data(p)
    k = p - 1
    ep = eps(p)
    u = sp.symbols(f"u0:{k}")
    F = 0
    for i in range(2 * p):
        F += ep[i] * (sum(E[i][j] * u[j] for j in range(k))) ** 3
    return sp.Poly(sp.expand(F), *u), u


def hess_tensor(p):
    """A[m] = symmetric k x k matrix with A[m][j][l] = T(e_j, e_l, e_m) so that
    T(v)_{jl} = sum_m v_m A[m][j][l].  T(a,b,c) = sum_i eps_i (x_i.a)(x_i.b)(x_i.c)."""
    E, _, _ = data(p)
    k = p - 1
    ep = eps(p)
    A = [[[0] * k for _ in range(k)] for _ in range(k)]
    for i in range(2 * p):
        x = [E[i][j] % p for j in range(k)]
        for m in range(k):
            if x[m] == 0:
                continue
            for j in range(k):
                if x[j] == 0:
                    continue
                for l in range(k):
                    A[m][j][l] = (A[m][j][l] + ep[i] * x[m] * x[j] * x[l]) % p
    return A


if __name__ == "__main__":
    from common import B1, B2

    for p, claim in ((7, B1), (11, B2)):
        k = p - 1
        F, u = cubic_from_E(p)
        Fc = sp.Poly(sp.sympify(claim, locals=dict(zip([s.name for s in u], u))), *u)
        d = sp.Poly(F.as_expr() - Fc.as_expr(), *u)
        ok = all(c % p == 0 for c in d.coeffs()) if d.coeffs() else True
        print(f"p={p}: F(from E) == {'B1' if p == 7 else 'B2'} mod {p}: {ok}")

        # cross-check the tensor against the symbolic Hessian
        A = hess_tensor(p)
        Fp = sp.Poly(sp.expand(F.as_expr()), *u)
        bad = 0
        for j in range(k):
            for l in range(k):
                h = sp.expand(sp.diff(Fp.as_expr(), u[j], u[l]))
                t = sum(u[m] * A[m][j][l] for m in range(k))
                dd = sp.Poly(sp.expand(h - 6 * t), *u)
                if dd.coeffs() and any(c % p for c in dd.coeffs()):
                    bad += 1
        print(f"      Hessian == 6 * sum_m v_m A[m] mod {p}: {bad == 0} (mismatches {bad})")
        # save tensor
        with open(f"tensor{p}.txt", "w") as fh:
            fh.write(f"{p} {k}\n")
            for m in range(k):
                for j in range(k):
                    fh.write(" ".join(str(A[m][j][l]) for l in range(k)) + "\n")
        print(f"      wrote tensor{p}.txt")
