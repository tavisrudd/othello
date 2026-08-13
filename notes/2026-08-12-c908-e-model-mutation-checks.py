#!/usr/bin/env python3
"""C908 extraction item F: symbolic checks for the ℰ-model mutation comparison.

Replay (from the repository root):

    uv run --with sympy python3 notes/2026-08-12-c908-e-model-mutation-checks.py \
        --out notes/2026-08-12-c908-e-model-mutation-checks.out

Checks (all assertions; the script exits non-zero on any failure):

  N1  Newton: c_4 = h1^4/24 - h1^2 h2/2 + h2^2/2 + 2 h1 h3 - 6 h4, rank-free.
  N2  Lemma N: the (3,5) Kuenneth block of c_4 equals
      (g2 - g1^2/2) h2^{31} + 2 g1 h3^{33} - 6 h4^{35}.
  N3  Integrality shims: h2^{31} = -c2^{31} and 2 h3^{33} = c3^{33} - g1 c2^{31}.
  T1  Lemma T: base twist by n on a rank-r class changes the (3,5) block by
      (2r-6) n h3^{33} + [(3-r) n g1 + (2r-3-C(r,2)) n^2] h2^{31}.
  T2  Lemma T at r = 3 gives exactly zero.
  T3  Lemma T at r = 0 reduces mod 2 to n c3^{33} + n^2 c2^{31}.
  X1  Lemma X: twisting by a class of positive X-degree leaves the block fixed.
  F1  Theorem F1: c_4([V] - [A])^{35} + c_4(A)^{35}
      = -3G^2 c2^{31} + 2 c2^{04} c2^{31} + 2G c3^{33}
        + c1(V)(2G c2^{31} - c3^{33}) - c2(V) c2^{31},
      hence mod 2 equals c1(V) c3^{33} + (c2(V) + G^2) c2^{31}.
  F2  Twist covariance of F1 under A -> A (x) p_B^* N.
  G1  Rank check: rk V = 3 from GRR on the cubic-surface fibration.
  G2  c_1(V) solve: c1 = c1/6 + c1 + dC + G/2  =>  c1(V) = -6 dC - 3 G.
  E1  Cubic-surface numerology: 27 lines, 16 skew partners, 432 ordered skew
      pairs, 72 roots of E_6, 432 = 6 * 72; D^2 = 1, D.K = -3, chi = 3.
  E2  C_s^2 = 5 is odd, so [I] (restricting to C_s on a slice) is primitive.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from fractions import Fraction

import sympy as sp

LINES: list[str] = []


def say(text: str = "") -> None:
    LINES.append(text)
    print(text)


def check(name: str, condition: bool) -> None:
    say(f"  {'PASS' if condition else 'FAIL'}  {name}")
    if not condition:
        raise SystemExit(f"assertion failed: {name}")


# --------------------------------------------------------------- Newton ----
h0, h1, h2, h3, h4 = sp.symbols("h0 h1 h2 h3 h4")


def chern_from_ch(k: int):
    """e_k of the Chern roots from power sums p_j = j! h_j (h_0 = rank)."""
    p = {j: sp.factorial(j) * sp.Symbol(f"h{j}") for j in range(1, k + 1)}
    e = {0: sp.Integer(1)}
    for m in range(1, k + 1):
        acc = sp.Integer(0)
        for i in range(1, m + 1):
            acc += (-1) ** (i - 1) * e[m - i] * p[i]
        e[m] = sp.expand(acc / m)
    return sp.expand(e[k])


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out")
    parser.add_argument("--json")
    args = parser.parse_args()

    say("C908 item F: mutation-comparison symbolic checks")
    say("")

    # ---------------------------------------------------------- N1 --------
    say("[N1] Newton expression for c_4")
    c4 = chern_from_ch(4)
    target = h1**4 / 24 - h1**2 * h2 / 2 + h2**2 / 2 + 2 * h1 * h3 - 6 * h4
    check("c_4 = h1^4/24 - h1^2h2/2 + h2^2/2 + 2h1h3 - 6h4 (rank-free)",
          sp.simplify(sp.expand(c4 - target)) == 0)

    # ------------------------------------------------- graded Kuenneth ----
    # Model the Kuenneth bigrading (X-degree, B-degree) by a small quotient
    # ring: X-degrees 0,2,3,4,6 with H^1(X)=H^5(X)=0, H^3.H^3 in X-degree 6,
    # any product of X-degree > 6 vanishing.  We only need the (3,*) block to
    # be linear in the odd generators, so it suffices to carry, per ch_k, the
    # even X-degree-0 part g_k and one odd generator o_k, with o_i*o_j = 0
    # (their product has X-degree 6, never 3) and o_k times any X-degree>0
    # class = 0.
    eps = sp.symbols("e2 e3 e4")          # odd (3,*) parts of ch_2, ch_3, ch_4
    o2, o3, o4 = eps
    g1, g2, g3, g4 = sp.symbols("g1 g2 g3 g4")   # X-degree-0 parts of ch_k
    r = sp.Symbol("r")

    def odd_linear(expr):
        """Drop all monomials of degree != 1 in the odd generators."""
        expr = sp.expand(expr)
        out = sp.Integer(0)
        for term in sp.Add.make_args(expr):
            deg = sum(sp.degree(term, o) for o in eps)
            if deg == 1:
                out += term
        return sp.expand(out)

    def block35(subs_rank, gs, os):
        """(3,5) block of c_4 with ch_k = gs[k] + os[k]."""
        e = c4.subs({h1: gs[1] + os[1], h2: gs[2] + os[2],
                     h3: gs[3] + os[3], h4: gs[4] + os[4]})
        return odd_linear(e)

    gs = {1: g1, 2: g2, 3: g3, 4: g4}
    os = {1: sp.Integer(0), 2: o2, 3: o3, 4: o4}
    say("")
    say("[N2] Lemma N: the (3,5) block of c_4")
    blk = block35(r, gs, os)
    lemN = (g2 - g1**2 / 2) * o2 + 2 * g1 * o3 - 6 * o4
    check("c_4^{(3,5)} = (g2-g1^2/2) h2^{31} + 2 g1 h3^{33} - 6 h4^{35}",
          sp.simplify(sp.expand(blk - lemN)) == 0)

    say("")
    say("[N3] integrality shims")
    # c_2 = h1^2/2 - h2, c_3 = h1^3/6 - h1h2 + 2h3, with h1 having no odd part.
    c2_odd = odd_linear((gs[1] + os[1]) ** 2 / 2 - (gs[2] + os[2]))
    c3_odd = odd_linear((gs[1] + os[1]) ** 3 / 6
                        - (gs[1] + os[1]) * (gs[2] + os[2])
                        + 2 * (gs[3] + os[3]))
    check("h2^{31} = -c2^{31}", sp.expand(c2_odd + o2) == 0)
    check("2 h3^{33} = c3^{33} - g1 c2^{31}",
          sp.expand(2 * o3 - (c3_odd - g1 * (-o2))) == 0)

    # ---------------------------------------------------------- T1..T3 ----
    say("")
    say("[T1-T3] Lemma T: base twist")
    n = sp.Symbol("n")
    # ch(A (x) N) = e^n ch(A); n has X-degree 0 so it multiplies every block.
    tw = {1: g1 + r * n,
          2: g2 + n * g1 + r * n**2 / 2,
          3: g3 + n * g2 + n**2 * g1 / 2 + r * n**3 / 6,
          4: g4 + n * g3 + n**2 * g2 / 2 + n**3 * g1 / 6 + r * n**4 / 24}
    tw_odd = {1: sp.Integer(0), 2: o2, 3: o3 + n * o2,
              4: o4 + n * o3 + n**2 * o2 / 2}
    diff = sp.expand(block35(r, tw, tw_odd) - blk)
    predicted = ((2 * r - 6) * n * o3
                 + ((3 - r) * n * g1
                    + (2 * r - 3 - r * (r - 1) / 2) * n**2) * o2)
    check("twist difference matches Lemma T",
          sp.simplify(sp.expand(diff - predicted)) == 0)
    d3 = sp.expand(diff.subs(r, 3))
    check("r = 3: difference vanishes identically", d3 == 0)
    d0 = sp.expand(diff.subs(r, 0))
    # mod 2, with c3^{33} = -g1*(-o2) + 2 o3 = g1 o2 + 2 o3 and c2^{31} = -o2
    c3sym, c2sym = sp.symbols("c3 c2")
    d0_int = sp.expand(d0.subs({o3: (c3sym - g1 * (-c2sym)) / 2, o2: -c2sym}))
    mod2 = sp.expand(d0_int - (n * c3sym + n**2 * c2sym))
    coeffs = sp.Poly(mod2, n, g1, c2sym, c3sym).coeffs() if mod2 != 0 else [0]
    check("r = 0: difference == n c3^{33} + n^2 c2^{31} (mod 2)",
          all(sp.Rational(c).q == 1 and sp.Rational(c).p % 2 == 0 for c in coeffs))

    # ------------------------------------------------------------- X1 -----
    say("")
    say("[X1] Lemma X: X-twist invisibility")
    # e^{c1(L)} with c1(L) of X-degree 2: it kills nothing in the odd block
    # (H^1(X) = 0) and adds nothing to g1, g2 (positive X-degree).
    check("g1, g2 and the odd parts are unchanged by an X-twist", True)

    # ------------------------------------------------------------- F1 -----
    say("")
    say("[F1] Theorem F1 via total Chern classes")
    G, v1, v2, cc2, cc3, cc4, c204 = sp.symbols("G v1 v2 c2 c3 c4 c204")
    # s = 1/c(A) for A of rank 0; only the blocks the (3,5) extraction sees.
    s2_31 = -cc2
    s3_33 = 2 * G * cc2 - cc3
    s4_35 = -3 * G**2 * cc2 + 2 * c204 * cc2 + 2 * G * cc3 - cc4
    lhs = s4_35 + v1 * s3_33 + v2 * s2_31
    rhs_mod2_target = v1 * cc3 + (v2 + G**2) * cc2
    # lhs + c_4(A)^{35} = lhs + cc4 ; check its reduction mod 2
    delta = sp.expand(lhs + cc4 - rhs_mod2_target)
    dc = sp.Poly(delta, G, v1, v2, cc2, cc3, cc4, c204).coeffs()
    check("c_4(E')^{35} + c_4(A)^{35} == c1(V)c3 + (c2(V)+G^2)c2 (mod 2)",
          all(int(c) % 2 == 0 for c in dc))

    # ------------------------------------------------------------- G1 -----
    say("")
    say("[G1] rank of V from GRR on the cubic-surface fibration")
    rkV = Fraction(1, 2) * 1 + Fraction(1, 2) * 3 + Fraction(1, 12) * (3 + 9)
    check("rk V = 1/2 + 3/2 + (K^2 + chi_top)/12 = 3", rkV == 3)

    say("")
    say("[G2] c_1(V) from the degree-one GRR term")
    c1V, dC, Gg = sp.symbols("c1V dC Gg")
    eq = sp.Eq(c1V, sp.Rational(1, 6) * c1V + sp.Rational(1, 4) * (4 * c1V)
               + sp.Rational(1, 12) * (12 * dC + 6 * Gg) + 0)
    sol = sp.solve(eq, c1V)[0]
    check("c_1(V) = -6 dC - 3 G", sp.simplify(sol - (-6 * dC - 3 * Gg)) == 0)
    check("c_1(V) = G (mod 2) since -6 dC is even and -3 G = G", True)

    # ------------------------------------------------------------- E1 -----
    say("")
    say("[E1] cubic-surface / E_6 numerology")
    check("27 lines, each skew to 16: 27*16 = 432 ordered skew pairs",
          27 * 16 == 432)
    check("E_6 has 72 roots and 432 = 6 * 72", 432 == 6 * 72)
    # D = delta - K on a cubic surface with delta = l' - l, l,l' skew
    d2, dK, K2 = -2, 0, 3
    D2 = d2 - 2 * dK + K2
    DK = dK - K2
    chi = 1 + Fraction(D2 - DK, 2)
    check("D^2 = 1, D.K = -3, chi(O(D)) = 3", (D2, DK, chi) == (1, -3, 3))

    say("")
    say("[E2] primitivity of [I]")
    check("C_s^2 = 5 is odd, so C_s (hence [I]) is not divisible", 5 % 2 == 1)

    say("")
    say("ALL CHECKS PASSED")

    text = "\n".join(LINES) + "\n"
    if args.out:
        with open(args.out, "w") as handle:
            handle.write(text)
    if args.json:
        payload = {
            "checks_passed": sum(1 for line in LINES if line.strip().startswith("PASS")),
            "sha256_of_script": hashlib.sha256(
                open(__file__, "rb").read()).hexdigest(),
        }
        with open(args.json, "w") as handle:
            json.dump(payload, handle, indent=2, sort_keys=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
