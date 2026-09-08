"""check4: p=11 Pauli histogram from the exhaustive rank census, and identification of the
minimum-rank locus (both p) as the rational normal curve of perfect (p-3)-th powers."""
from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parents[1]/"reconstruction"))

import sys
from fractions import Fraction

from check1 import hess_tensor  # noqa: E402
from check2 import rank_mod_p  # noqa: E402

# exhaustive projective rank census produced by rank11/src/main.rs on tensor11.txt
LINES11 = {5: 12, 6: 1452, 7: 8052, 8: 2144296, 9: 238748521, 10: 2352840127}


def hrank(A, v, p):
    k = len(v)
    H = [[sum(v[m] * A[m][j][l] for m in range(k)) % p for l in range(k)] for j in range(k)]
    return rank_mod_p(H, p)


def sub7(z, s):
    """u = (a, b, s+c, 3s+c, d, e) with (a,b,c,d,e) = z."""
    a, b, c, d, e = z
    return [a % 7, b % 7, (s + c) % 7, (3 * s + c) % 7, d % 7, e % 7]


def sub11(z, s):
    """u = (z0, z1, 7z2, 6z3, 3s+6z4, s+3z4, 6z5, 7z6, z7, z8)."""
    z0, z1, z2, z3, z4, z5, z6, z7, z8 = z
    return [z0 % 11, z1 % 11, 7 * z2 % 11, 6 * z3 % 11, (3 * s + 6 * z4) % 11,
            (s + 3 * z4) % 11, 6 * z5 % 11, 7 * z6 % 11, z7 % 11, z8 % 11]


def main():
    p, k = 11, 10
    print("== p=11 exhaustive Hessian-rank census (projective, from Rust) ==")
    Nv = {0: 1}
    for r, ln in LINES11.items():
        Nv[r] = ln * (p - 1)
    tot = sum(Nv.values())
    print(f"  sum N_r = {tot}  == p^k = {p**k}  {tot == p**k}")
    print("  Pauli histogram:")
    zero = 0
    ssq = Fraction(0)
    npau = 0
    for r in sorted(Nv):
        n = Nv[r] * p ** r
        npau += n
        zero += Nv[r] * (p ** k - p ** r)
        ssq += Fraction(n, p ** r)
        print(f"    r={r:2d}  N_r={Nv[r]:>13}  |<P>|=11^-{r}/2={p ** (-r / 2):.3e}  "
              f"#Paulis={n}")
    print(f"    |<P>|=0  #Paulis={zero}")
    print(f"  total Paulis = {npau + zero}  == p^2k = {p ** (2 * k)}  "
          f"{npau + zero == p ** (2 * k)}")
    print(f"  sum |<P>|^2 = {ssq} == p^k: {ssq == p ** k}")

    print("\n== minimum-rank locus as the rational normal curve of (p-3)-th powers ==")
    for p_, k_, sub, deg in ((7, 6, sub7, 4), (11, 10, sub11, 8)):
        A = hess_tensor(p_)
        pts = []
        for c in range(p_):
            z = [pow(c, i, p_) for i in range(deg + 1)]
            pts.append((c, sub(z, 0)))
        z = [0] * deg + [1]
        pts.append(("inf", sub(z, 0)))
        rks = [(c, v, hrank(A, v, p_)) for c, v in pts]
        rmin = min(r for _, _, r in rks)
        allmin = all(r == rmin for _, _, r in rks)
        print(f"  p={p_}: s=0, f=(S+cT)^{deg}, {len(pts)} points; all have Hessian rank "
              f"{rmin}: {allmin}  (census r_min = {rmin}, count = {p_ + 1} lines)")
        for c, v, r in rks[:3]:
            print(f"      c={c}: u={v} rank={r}")
        print(f"      ... (c up to {p_ - 1} and c=inf)")


if __name__ == "__main__":
    main()
