"""C1071 Part B1: unpack the stored characteristic-two lexicographic basis of the
classical MATCH(10,5,1) realization ideal and check its factorization over F2.

Run:
  uv run --with sympy python3 notes/scratch/c1071/b1_lexbasis.py
"""

import json
from pathlib import Path

import sympy
from sympy import GF, Poly, symbols

ROOT = Path(__file__).resolve().parents[3]
JSON_PATH = ROOT / "papers/arcs_complete_outside_conic/check_match10_rank_three.json"

data = json.loads(JSON_PATH.read_text())
basis = data["classical_char2_lex_basis"]
arc_factor = data["classical_char2_arc_factor"]

print("stored lex basis (characteristic 2, lp ordering):")
for g in basis:
    print("   ", g)
print("stored arc factor:", arc_factor)
print()

y9 = symbols("y9")
uni = Poly(y9**5 + y9**4 + y9**3 + y9, y9, domain=GF(2))
print("univariate generator:", uni.as_expr())
print("factorization over GF(2):", sympy.factor_list(uni.as_expr(), modulus=2))
print()

# the three roots of y^3+y+1 in F8, and Frobenius orbit
cube = Poly(y9**3 + y9 + 1, y9, domain=GF(2))
print("y^3+y+1 irreducible over GF(2):", cube.is_irreducible)
print("roots in F2:", [a for a in (0, 1) if (a**3 + a + 1) % 2 == 0])

# build F8 = F2[t]/(t^3+t+1) and list roots + x9 = y9^3
def mulmod(a, b):
    # a,b are 3-bit ints representing polys in t; reduce mod t^3+t+1 (0b1011)
    r = 0
    while b:
        if b & 1:
            r ^= a
        b >>= 1
        a <<= 1
        if a & 0b1000:
            a ^= 0b1011
    return r


def powmod(a, n):
    r = 1
    for _ in range(n):
        r = mulmod(r, a)
    return r


roots = [a for a in range(8) if powmod(a, 3) ^ a ^ 1 == 0]
print("roots of t^3+t+1 in F8 (as bit-vectors over basis 1,t,t^2):", roots)
print("Frobenius orbit of the first root:",
      [roots[0], mulmod(roots[0], roots[0]), powmod(roots[0], 4)])
print("x9 = t^3 at each root:", [(a, powmod(a, 3)) for a in roots])
print("arc inequation x9(x9-1) != 0 at each root:",
      [(a, powmod(a, 3) != 0 and powmod(a, 3) != 1) for a in roots])
print("t=0 gives x9 = 0 (excluded); t=1 gives x9 = 1 (excluded):",
      powmod(0, 3), powmod(1, 3))
