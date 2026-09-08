"""Step 1: rebuild the 22-point configuration and check it against E11 / B2."""
from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parents[2]/"reconstruction"))

import sys


import sympy as sp                                   # noqa: E402
from common import E11, B2                           # noqa: E402
from geom11 import P, EXP11, build, M11              # noqa: E402


def main():
    ms, es, xs, alphas = build()
    print(f"orbit size {len(ms)}; sheet sizes "
          f"{sum(1 for e in es if e == 1)}/{sum(1 for e in es if e != 1)}")
    print(f"scaling factors alpha_M used: {sorted(set(alphas))}")
    zero = [i for i, v in enumerate(xs) if not any(v)]
    print(f"zero vectors at indices {zero}; base matching there: {ms[zero[0]] == M11}")

    ref = {tuple(r) for r in E11}
    got = {tuple(v) for v in xs}
    print(f"reconstructed point set == E11 row set: {ref == got}")
    ref_pos = {tuple(r) for r in E11[:P]}
    got_pos = {tuple(v) for v, e in zip(xs, es) if e == 1}
    print(f"positive sheets agree: {ref_pos == got_pos}"
          f"  (or swapped: {ref_pos == {tuple(v) for v, e in zip(xs, es) if e != 1}})")

    # F_11 from the reconstructed configuration, compared with B2
    u = sp.symbols("u0:10")
    F = 0
    for v, e in zip(xs, es):
        F += e * (sum(int(v[j]) * u[j] for j in range(10))) ** 3
    F = sp.Poly(sp.expand(F), *u)
    B = sp.Poly(sp.sympify(B2), *u)
    for lam in range(1, P):
        if all((c - lam * B.coeff_monomial(m)) % P == 0
               for m, c in zip(B.monoms(), [F.coeff_monomial(m) for m in B.monoms()])) \
           and all(c % P == 0 for m, c in F.terms() if B.coeff_monomial(m) == 0):
            print(f"F_reconstructed == {lam} * B2  (mod 11)")
            break
    else:
        print("no scalar relates the reconstructed F to B2")


if __name__ == "__main__":
    main()
