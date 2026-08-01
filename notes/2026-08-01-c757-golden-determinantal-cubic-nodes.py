#!/usr/bin/env python3
"""Generate and check the exact Golden determinantal cubic-node certificate."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import subprocess
import tempfile
from fractions import Fraction
from itertools import combinations
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-08-01-c757-golden-determinantal-cubic-nodes.json"
MANIFEST = ROOT / "2026-08-01-c757-golden-determinantal-cubic-nodes.sha256"
REPLAY = ROOT / "2026-08-01-c757-golden-determinantal-cubic-nodes-replay.py"
BASE_C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
ZERO = (0, 0, 0, 0, 0)
Poly = dict[tuple[int, ...], Fraction]


def add(*polys: Poly) -> Poly:
    result: Poly = {}
    for poly in polys:
        for monomial, coefficient in poly.items():
            result[monomial] = result.get(monomial, Fraction(0)) + coefficient
    return {m: c for m, c in result.items() if c}


def scale(poly: Poly, scalar: int | Fraction) -> Poly:
    return {m: Fraction(scalar) * c for m, c in poly.items() if scalar * c}


def mul(left: Poly, right: Poly) -> Poly:
    result: Poly = {}
    for lm, lc in left.items():
        for rm, rc in right.items():
            monomial = tuple(lm[i] + rm[i] for i in range(5))
            result[monomial] = result.get(monomial, Fraction(0)) + lc * rc
    return {m: c for m, c in result.items() if c}


def derivative(poly: Poly, index: int) -> Poly:
    result = {}
    for monomial, coefficient in poly.items():
        if monomial[index]:
            target = tuple(e - int(i == index) for i, e in enumerate(monomial))
            result[target] = coefficient * monomial[index]
    return result


def evaluate(poly: Poly, point: tuple[Fraction, ...]) -> Fraction:
    return sum(
        coefficient * math.prod(point[i] ** monomial[i] for i in range(5))
        for monomial, coefficient in poly.items()
    )


def determinant(matrix: list[list[Fraction]]) -> Fraction:
    if not matrix:
        return Fraction(1)
    return sum(
        (-1) ** column
        * matrix[0][column]
        * determinant([row[:column] + row[column + 1 :] for row in matrix[1:]])
        for column in range(len(matrix))
    )


def golden_cubic() -> Poly:
    variables: list[Poly] = [
        {tuple(int(i == j) for j in range(5)): Fraction(1)} for i in range(5)
    ]
    variables.append(
        {tuple(int(i == j) for j in range(5)): Fraction(-1) for i in range(5)}
    )
    result: Poly = {}
    for i, j, k in combinations(range(6), 3):
        sign = BASE_C[i][j] * BASE_C[j][k] * BASE_C[k][i]
        result = add(result, scale(mul(mul(variables[i], variables[j]), variables[k]), sign))
    return result


def singular_expression(poly: Poly) -> str:
    terms = []
    for monomial, coefficient in sorted(poly.items(), reverse=True):
        if coefficient.denominator != 1:
            raise AssertionError("the frozen cubic must be integral")
        factors = []
        for index, exponent in enumerate(monomial):
            if exponent == 1:
                factors.append(f"x{index}")
            elif exponent:
                factors.append(f"x{index}^{exponent}")
        body = "*".join(factors) or "1"
        terms.append(f"{coefficient.numerator:+d}*{body}")
    return "".join(terms).lstrip("+")


def singular_audit(poly: Poly) -> tuple[dict[str, int], str]:
    expression = singular_expression(poly)
    source = f'''
LIB "primdec.lib";
ring r=0,(x0,x1,x2,x3,x4),dp;
poly f={expression};
ideal J=jacob(f); ideal G=std(J);
proc idealZero(ideal I) {{ int i; for(i=1;i<=size(I);i++){{if(I[i]!=0){{return(0);}}}} return(1); }}
list AP=minAssGTZ(J);
ideal A=subst(J,x4,1)+ideal(x4-1); ideal AG=std(A); ideal AR=std(radical(A));
int projectiveDegree=vdim(AG);
int affineRadical=idealZero(reduce(AG,AR)) && idealZero(reduce(AR,AG));
ideal B=std(J+ideal(x4)); ideal BR=std(radical(B));
ideal M=std(ideal(x0,x1,x2,x3,x4));
int boundaryEmpty=idealZero(reduce(BR,M)) && idealZero(reduce(M,BR));
"C757 projective_dimension",dim(G)-1;
"C757 projective_degree",projectiveDegree;
"C757 minimal_primes",size(AP);
"C757 chart_quotient_dimension",vdim(AG);
"C757 chart_radical",affineRadical;
"C757 boundary_empty",boundaryEmpty;
'''
    completed = subprocess.run(
        ["nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"],
        input=source,
        text=True,
        capture_output=True,
        check=True,
    )
    values: dict[str, int] = {}
    for line in completed.stdout.splitlines():
        if line.startswith("C757 "):
            _, key, value = line.split()
            values[key] = int(value)
    expected_keys = {
        "projective_dimension",
        "projective_degree",
        "minimal_primes",
        "chart_quotient_dimension",
        "chart_radical",
        "boundary_empty",
    }
    if values.keys() != expected_keys:
        raise AssertionError(f"incomplete Singular output: {values}")
    version = subprocess.run(
        ["nix", "shell", "nixpkgs#singular", "--command", "Singular", "--version"],
        text=True,
        capture_output=True,
        check=True,
    ).stdout.splitlines()[0]
    return values, version


def fraction_text(value: Fraction) -> str:
    return str(value.numerator) if value.denominator == 1 else f"{value.numerator}/{value.denominator}"


def build_certificate() -> dict:
    cubic = golden_cubic()
    audit, singular_version = singular_audit(cubic)
    expected_audit = {
        "projective_dimension": 0,
        "projective_degree": 6,
        "minimal_primes": 6,
        "chart_quotient_dimension": 6,
        "chart_radical": 1,
        "boundary_empty": 1,
    }
    if audit != expected_audit:
        raise AssertionError(f"unexpected singular scheme: {audit}")

    projective_points = []
    chart_points = []
    hessian_determinants = []
    derivatives = [derivative(cubic, i) for i in range(5)]
    hessian = [[derivative(derivatives[i], j) for j in range(4)] for i in range(4)]
    for exceptional in range(6):
        point6 = tuple(-5 if i == exceptional else 1 for i in range(6))
        projective_points.append(list(point6))
        scale_factor = Fraction(point6[4])
        point5 = tuple(Fraction(point6[i], scale_factor) for i in range(5))
        chart_points.append([fraction_text(value) for value in point5])
        if evaluate(cubic, point5) != 0 or any(evaluate(partial, point5) != 0 for partial in derivatives):
            raise AssertionError(f"candidate is not singular: {point6}")
        matrix = [[evaluate(hessian[i][j], point5) for j in range(4)] for i in range(4)]
        hessian_determinants.append(fraction_text(determinant(matrix)))
    if any(Fraction(value) == 0 for value in hessian_determinants):
        raise AssertionError("a candidate is not an ordinary double point")

    terms = [
        {"exponents": list(monomial), "coefficient": fraction_text(coefficient)}
        for monomial, coefficient in sorted(cubic.items())
    ]
    return {
        "schema": "golden-determinantal-cubic-nodes-v1",
        "ambient": "sum(x_0,...,x_5)=0 with x_5=-(x_0+...+x_4)",
        "base_conference_matrix": [list(row) for row in BASE_C],
        "cubic_terms": terms,
        "singular_audit": audit,
        "singular_version": singular_version,
        "projective_nodes": projective_points,
        "x4_equals_one_chart_points": chart_points,
        "dehomogenized_hessian_determinants": hessian_determinants,
        "classical_comparison": {
            "source": "Igor Dolgachev, Corrado Segre and nodal cubic threefolds, arXiv:1501.06432, Remark 3.6",
            "cache_key": "arXiv:1501.06432",
            "pdf_sha256": "98a898303e06a395bad95888a826e677a955d4b8fc88914c6ede54e31406601e",
            "statement": "for an isolated singular locus of a 3x3 linear determinantal cubic threefold, the Milnor numbers sum to six",
            "golden_total_milnor_number": 6,
        },
    }


def certificate_bytes() -> bytes:
    return (json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n").encode()


def manifest_bytes(cert: bytes) -> bytes:
    entries = []
    for path, data in (
        (Path(__file__), Path(__file__).read_bytes()),
        (REPLAY, REPLAY.read_bytes()),
        (OUTPUT, cert),
    ):
        entries.append(f"{hashlib.sha256(data).hexdigest()}  {path.name}\n")
    return "".join(entries).encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    cert = certificate_bytes()
    manifest = manifest_bytes(cert)
    if args.check:
        if OUTPUT.read_bytes() != cert:
            raise SystemExit("certificate drift")
        if MANIFEST.read_bytes() != manifest:
            raise SystemExit("checksum manifest drift")
        print("golden determinantal cubic node certificate: ok")
        return
    OUTPUT.write_bytes(cert)
    MANIFEST.write_bytes(manifest)
    print(f"wrote {OUTPUT.name} and {MANIFEST.name}")


if __name__ == "__main__":
    main()
