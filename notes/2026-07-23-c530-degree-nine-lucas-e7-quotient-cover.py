#!/usr/bin/env python3
"""Generate the compact exact certificate for C530.

Only integer arithmetic and polynomial arithmetic over F_2 are used.  The
finite-field rows are bounded controls for the all-m hand proof in the report.
"""

from __future__ import annotations

import argparse
import json
from math import comb
from pathlib import Path
import tempfile


STEM = "2026-07-23-c530-degree-nine-lucas-e7-quotient-cover"


def degree(f: int) -> int:
    return f.bit_length() - 1


def poly_mod(f: int, modulus: int) -> int:
    n = degree(modulus)
    while degree(f) >= n:
        f ^= modulus << (degree(f) - n)
    return f


def poly_mul(a: int, b: int) -> int:
    out = 0
    while b:
        if b & 1:
            out ^= a
        a <<= 1
        b >>= 1
    return out


def poly_gcd(a: int, b: int) -> int:
    while b:
        a, b = b, poly_mod(a, b)
    return a


def square_mod(a: int, modulus: int) -> int:
    return poly_mod(poly_mul(a, a), modulus)


def irreducible(f: int, m: int) -> bool:
    x = 2
    z = x
    for i in range(1, m + 1):
        z = square_mod(z, f)
        if i <= m // 2 and poly_gcd(z ^ x, f) != 1:
            return False
    return z == x


def first_irreducible(m: int) -> int:
    for low in range(1, 1 << m, 2):
        f = (1 << m) | low
        if irreducible(f, m):
            return f
    raise AssertionError(f"no irreducible polynomial of degree {m}")


def gf_mul(a: int, b: int, modulus: int) -> int:
    return poly_mod(poly_mul(a, b), modulus)


def roots_to_polynomial(roots: list[int], modulus: int) -> list[int]:
    coeffs = [1]
    for root in roots:
        nxt = [0] * (len(coeffs) + 1)
        for i, coeff in enumerate(coeffs):
            nxt[i + 1] ^= coeff
            nxt[i] ^= gf_mul(coeff, root, modulus)
        coeffs = nxt
    return coeffs


def subspace_witness(m: int) -> dict[str, object]:
    modulus = first_irreducible(m)
    basis = [1, 2, 4]
    roots = sorted(
        {
            (basis[0] if mask & 1 else 0)
            ^ (basis[1] if mask & 2 else 0)
            ^ (basis[2] if mask & 4 else 0)
            for mask in range(8)
        }
    )
    assert len(roots) == 8
    coeffs = roots_to_polynomial(roots, modulus)
    support = [i for i, c in enumerate(coeffs) if c]
    assert support[0] == 1 and support[-1] == 8
    assert set(support) <= {0, 1, 2, 4, 8}
    assert coeffs[6] == coeffs[7] == 0
    for root in roots:
        value = 0
        power = 1
        for coeff in coeffs:
            value ^= gf_mul(coeff, power, modulus)
            power = gf_mul(power, root, modulus)
        assert value == 0
    return {
        "m": m,
        "q": 1 << m,
        "modulus_hex": hex(modulus),
        "basis_hex": [hex(x) for x in basis],
        "roots_hex": [hex(x) for x in roots],
        "coefficients_low_to_high_hex": [hex(x) for x in coeffs],
        "support": support,
    }


def action_support() -> dict[str, object]:
    rows = {}
    for j in range(10):
        terms = []
        for r in range(3):
            s = 2 - r
            if (
                r <= 9 - j
                and s <= j
                and comb(9 - j, r) % 2
                and comb(j, s) % 2
            ):
                terms.append(
                    {
                        "a": r,
                        "b": 9 - j - r,
                        "c": s,
                        "d": j - s,
                    }
                )
        if terms:
            rows[str(j)] = terms
    assert sorted(map(int, rows)) == [2, 3, 6, 7]
    return {
        "nonzero_target_coordinates": rows,
        "factored_projective_coordinates": [
            "b^5",
            "b^4*d",
            "b*d^4",
            "d^5",
        ],
        "common_factor": "(a*d+b*c)^2",
        "stabilizer_condition": "b=0",
    }


def gl3_count() -> dict[str, int]:
    invertible = 0
    for cols in range(1 << 9):
        vectors = [
            sum(((cols >> (3 * col + row)) & 1) << row for row in range(3))
            for col in range(3)
        ]
        span = {
            (vectors[0] if mask & 1 else 0)
            ^ (vectors[1] if mask & 2 else 0)
            ^ (vectors[2] if mask & 4 else 0)
            for mask in range(8)
        }
        invertible += len(span) == 8
    assert invertible == 168
    return {"GL3_F2": invertible, "AGL3_F2": 8 * invertible, "AGL1_F8": 8 * 7}


def certificate() -> dict[str, object]:
    return {
        "schema": "c530-degree-nine-e7-quotient-cover-v1",
        "field_characteristic": 2,
        "kernel_basis_exponents": [0, 1, 2, 3, 4, 5, 8],
        "known_U3_exponents": [0, 1, 8],
        "additive_affine_exponents": [0, 1, 2, 4, 8],
        "framed_incidence": {
            "free_roots": ["a", "b", "c", "d"],
            "S": "a+b+c+d",
            "h_equals_u_plus_v": "1+S",
            "E": "a*b+a*c+a*d+b*c+b*d+c*d",
            "p_equals_u_times_v": "1+E+S+S^2",
            "quadratic": "z^2+h*z+p",
            "artin_schreier_rhs": "p/h^2",
            "h_zero_semantics": "u=v; excluded on the squarefree ordered-root open",
            "residue_at_h_zero": "1+b*c+b*d+c*d+b+c+d+(b+c+d)^2",
            "residue_partial_b": "1+c+d",
            "geometric_deck_group": "C2",
        },
        "e7_action": action_support(),
        "ordering_groups": gl3_count(),
        "bounded_subspace_controls": [subspace_witness(m) for m in range(3, 13)],
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    data = certificate()
    payload = canonical_bytes(data)
    if args.check:
        with tempfile.TemporaryDirectory() as tmp:
            candidate = Path(tmp) / f"{STEM}.json"
            candidate.write_bytes(payload)
            expected = args.check.read_bytes()
            if candidate.read_bytes() != expected:
                raise SystemExit(f"certificate mismatch: {args.check}")
        print(f"OK {args.check}")
    else:
        output = args.output or Path(__file__).with_suffix(".json")
        output.write_bytes(payload)
        print(output)


if __name__ == "__main__":
    main()
