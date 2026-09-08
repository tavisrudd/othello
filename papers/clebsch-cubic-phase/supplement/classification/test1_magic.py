"""Test 1: stabilizer Renyi magic of the Clebsch phase states |F_7>, |F_11> versus
product cubic-phase qudits, disjoint CCZ-type blocks, the translation-trade family
cubic, and the trace cubic Tr(u^3) of the field extension F_{p^k}.

For a diagonal cubic phase state |F> on k qudits of dimension p, the exact Pauli
spectrum is |<F|X(v)Z(w)|F>| = p^{-rank H_F(v)/2} for w in Im H_F(v), 0 otherwise
(Hessian-rank formula in the manuscript).  With N_r = #{v : rank H_F(v) = r},

    sum_P |<P>|^{2a} = sum_r N_r p^{r(1-a)},
    M_a = (1-a)^{-1} log( p^{-k} sum_P |<P>|^{2a} )       (stabilizer Renyi entropy),
    M_lin = 1 - p^{-k} sum_P |<P>|^4                       (linear stabilizer entropy).

Normalization check: a stabilizer state has p^k Paulis at modulus 1 and M_a = 0; a
single cubic-phase qudit |M> = p^{-1/2} sum_z w^{z^3}|z> has N_0 = 1, N_1 = p-1.

Rank censuses are recomputed here for every k = 6 cubic over F_7 with the Rust census
binary from Hessian-rank (`rank11`, exact, all of PG(5,7)); the p = 11 Clebsch census is
taken from the recorded spectrum and rechecked against 11^10.
"""
from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parents[1]/"reconstruction"))

import itertools
import math
import os
import subprocess
import sys
from fractions import Fraction

from common import E7, E11, eps  # noqa: E402

RANK_BIN = str(Path(__file__).resolve().parents[1]/"spectra/rank11/target/release/rank11")
HERE = os.path.dirname(os.path.abspath(__file__))

# ---------------------------------------------------------------- censuses
CENSUS_F11 = {0: 1, 5: 120, 6: 14520, 7: 80520, 8: 21442960, 9: 2387485210, 10: 23528401270}


def hess_tensor_from_cubes(p, k, terms):
    """terms: list of (coefficient, linear-form vector a) meaning sum c (a.u)^3.
    Returns A[m][j][l] = sum_i c_i a_i[m] a_i[j] a_i[l] mod p (the unscaled Hessian tensor)."""
    A = [[[0] * k for _ in range(k)] for _ in range(k)]
    for c, a in terms:
        for m in range(k):
            if a[m] % p == 0:
                continue
            for j in range(k):
                if a[j] % p == 0:
                    continue
                for l in range(k):
                    A[m][j][l] = (A[m][j][l] + c * a[m] * a[j] * a[l]) % p
    return A


def hess_tensor_from_poly(p, k, coeffs):
    """coeffs: dict {(i,j,l) sorted tuple: c} for the cubic sum c u_i u_j u_l.
    Returns the symmetric tensor A with F(u) = sum_{m,j,l} A[m][j][l] u_m u_j u_l."""
    A = [[[0] * k for _ in range(k)] for _ in range(k)]
    for (i, j, l), c in coeffs.items():
        perms = set(itertools.permutations((i, j, l)))
        share = Fraction(c, len(perms))
        # divide by the number of distinct permutations: needs inverse mod p
        num, den = share.numerator, share.denominator
        val = num * pow(den, p - 2, p) % p
        for (a, b, d) in perms:
            A[a][b][d] = (A[a][b][d] + val) % p
    return A


def write_tensor(path, p, k, A):
    with open(path, "w") as fh:
        fh.write(f"{p} {k}\n")
        for m in range(k):
            for j in range(k):
                fh.write(" ".join(str(A[m][j][l] % p) for l in range(k)) + "\n")


def census_via_binary(path, p, k):
    out = subprocess.run([RANK_BIN, path, "--low", "0"], capture_output=True, text=True, check=True).stdout
    counts = {}
    for line in out.splitlines():
        # lines of the form "rank r : lines"
        parts = line.split()
        # "rank  r lines  L vectors  V"
        if len(parts) >= 4 and parts[0] == "rank" and parts[1].isdigit() and parts[2] == "lines":
            counts[int(parts[1])] = int(parts[3])
    # projective lines -> vectors
    N = {0: 1}
    for r, lines in counts.items():
        if r == 0:
            continue
        N[r] = lines * (p - 1)
    assert sum(N.values()) == p ** k, (N, out)
    return N


def sre(p, k, N, alpha):
    """Exact: returns (log-argument as Fraction, M_alpha as float in nats)."""
    s = sum(Fraction(n) * Fraction(p) ** (r * (1 - alpha)) for r, n in N.items())
    arg = s / Fraction(p) ** k
    return arg, math.log(arg) / (1 - alpha)


def report(name, p, k, N):
    a2, m2 = sre(p, k, N, 2)
    a3, m3 = sre(p, k, N, 3)
    mlin = 1 - a2
    rmin = min(r for r in N if r > 0)
    print(f"  {name:38s} rmin={rmin:2d} max|<P>|=p^-{rmin}/2  "
          f"M2={m2:8.4f} ({m2/k:.4f}/qudit)  M3={m3:8.4f}  Mlin={float(mlin):.6f}  "
          f"sum|<P>|^4 = {a2 * p**k}")
    return m2


def main():
    print("Normalization check: single cubic-phase qudit")
    for p in (7, 11):
        N = {0: 1, 1: p - 1}
        a2, m2 = sre(p, 1, N, 2)
        print(f"  p={p}: sum|<P>|^4 = {a2*p}, M2 = log({1/a2}) = {m2:.6f}; stabilizer state M2 = {sre(p,1,{0:p},2)[1]:.1f}")

    for p, E in ((7, E7), (11, E11)):
        k = p - 1
        d = p ** k
        print(f"\n=== p = {p}, k = {k} qudits, d = p^k ===")
        print(f"  pure-state upper bound M2 <= log((d+1)/2) = {math.log((d+1)/2):.4f}  ({math.log((d+1)/2)/k:.4f}/qudit)")
        ep = eps(p)
        terms = [(ep[i], [E[i][j] % p for j in range(k)]) for i in range(2 * p)]
        results = {}
        if p == 7:
            A = hess_tensor_from_cubes(p, k, terms)
            path = os.path.join(HERE, "out", "t1_clebsch7.txt")
            write_tensor(path, p, k, A)
            N = census_via_binary(path, p, k)
            print(f"  Clebsch census recomputed: {dict(sorted(N.items()))}")
        else:
            N = CENSUS_F11
        results["clebsch"] = report(f"Clebsch |F_{p}>", p, k, N)

        # product of k cubic-phase qudits: N_r = C(k,r)(p-1)^r
        Nprod = {r: math.comb(k, r) * (p - 1) ** r for r in range(k + 1)}
        results["product"] = report(f"|M>^(x{k}) product", p, k, Nprod)

        # CCZ-type blocks: u0u1u2 + u3u4u5 (+ ... ) ; for p=11: 3 blocks + one cubic-phase qudit
        if p == 7:
            A = hess_tensor_from_poly(p, k, {(0, 1, 2): 1, (3, 4, 5): 1})
            path = os.path.join(HERE, "out", "t1_ccz7.txt")
            write_tensor(path, p, k, A)
            Nccz = census_via_binary(path, p, k)
            results["ccz"] = report("CCZ x2 (u0u1u2+u3u4u5)", p, k, Nccz)
        else:
            # exact by multiplicativity of the Pauli spectrum over tensor factors:
            # one CCZ block on 3 qudits of dim p: census computed directly (p^3 vectors)
            def rank_mod(M, p):
                M = [row[:] for row in M]
                r = 0
                for c in range(len(M[0])):
                    piv = next((i for i in range(r, len(M)) if M[i][c] % p), None)
                    if piv is None:
                        continue
                    M[r], M[piv] = M[piv], M[r]
                    iv = pow(M[r][c], p - 2, p)
                    M[r] = [x * iv % p for x in M[r]]
                    for i in range(len(M)):
                        if i != r and M[i][c] % p:
                            f = M[i][c]
                            M[i] = [(M[i][j] - f * M[r][j]) % p for j in range(len(M[0]))]
                    r += 1
                return r
            N1 = {}
            for v in itertools.product(range(p), repeat=3):
                H = [[0, v[2], v[1]], [v[2], 0, v[0]], [v[1], v[0], 0]]
                r = rank_mod(H, p)
                N1[r] = N1.get(r, 0) + 1
            # tensor: N_total[r] = convolution over factors
            def conv(Na, Nb):
                out = {}
                for ra, na in Na.items():
                    for rb, nb in Nb.items():
                        out[ra + rb] = out.get(ra + rb, 0) + na * nb
                return out
            Nccz = conv(conv(conv(N1, N1), N1), {0: 1, 1: p - 1})
            results["ccz"] = report("CCZ x3 + one |M> (10 qudits)", p, k, Nccz)

        # translation-trade family cubic: F = -3 u_{k-1} q(u_0..u_{k-2}), q = sum u_i^2 + (sum u_i)^2
        coeffs = {}
        kk = k - 1
        for i in range(kk):
            for j in range(kk):
                key = tuple(sorted((i, j, k - 1)))
                c = (1 if i == j else 0) + 1  # u_i u_j from (sum u)^2 plus u_i^2
                coeffs[key] = (coeffs.get(key, 0) - 3 * c) % p
        A = hess_tensor_from_poly(p, k, coeffs)
        if p == 7:
            path = os.path.join(HERE, "out", "t1_translation7.txt")
            write_tensor(path, p, k, A)
            Ntr = census_via_binary(path, p, k)
            results["translation"] = report("translation-trade cubic (p=7)", p, k, Ntr)

        # trace cubic Tr_{F_{p^k}/F_p}(u^3): every nonzero v has rank k
        Ntrace = {0: 1, k: p ** k - 1}
        results["trace"] = report(f"Tr(u^3) on F_{{{p}^{k}}}", p, k, Ntrace)

        print("  Verdict: Clebsch M2 - product M2 = %.4f ; Clebsch M2 - CCZ M2 = %.4f ; trace M2 - Clebsch M2 = %.4f"
              % (results["clebsch"] - results["product"], results["clebsch"] - results["ccz"],
                 results["trace"] - results["clebsch"]))

    # exact rational values for the headline (p = 7)
    print("\nExact values, p = 7 (sum_P |<P>|^4 = sum_r N_r 7^{-r}):")
    for name, N in (("Clebsch", {0: 1, 3: 48, 4: 2940, 5: 26502, 6: 88158}),
                    ("product", {r: math.comb(6, r) * 6 ** r for r in range(7)}),
                    ("trace", {0: 1, 6: 7 ** 6 - 1})):
        s = sum(Fraction(n, 7 ** r) for r, n in N.items())
        print(f"  {name:8s} sum|<P>|^4 = {s} = {float(s):.6f};  exp(M2) = 7^6 / that = {Fraction(7**6)/s} = {float(Fraction(7**6)/s):.3f}")


if __name__ == "__main__":
    main()
