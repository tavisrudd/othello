#!/usr/bin/env python3
"""Exact algebraic certificate for C483 and extraction of frozen C478 controls."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from dataclasses import dataclass
from pathlib import Path


STEM = Path(__file__).with_suffix("")
CERTIFICATE = STEM.with_suffix(".json")
C478 = STEM.parent / "2026-07-22-c478-exceptional-family-controls.json"

VARIABLES = ("a", "b", "c", "d", "s", "t")
NVARIABLES = len(VARIABLES)


@dataclass(frozen=True)
class Poly:
    terms: dict[tuple[int, ...], int]

    @staticmethod
    def constant(value: int) -> "Poly":
        return Poly({(0,) * NVARIABLES: value} if value else {})

    @staticmethod
    def variable(index: int) -> "Poly":
        exponent = [0] * NVARIABLES
        exponent[index] = 1
        return Poly({tuple(exponent): 1})

    def __add__(self, other: "Poly | int") -> "Poly":
        other = other if isinstance(other, Poly) else Poly.constant(other)
        answer = dict(self.terms)
        for monomial, coefficient in other.terms.items():
            answer[monomial] = answer.get(monomial, 0) + coefficient
            if answer[monomial] == 0:
                del answer[monomial]
        return Poly(answer)

    __radd__ = __add__

    def __neg__(self) -> "Poly":
        return Poly({monomial: -coefficient for monomial, coefficient in self.terms.items()})

    def __sub__(self, other: "Poly | int") -> "Poly":
        return self + (-other if isinstance(other, Poly) else -other)

    def __rsub__(self, other: int) -> "Poly":
        return Poly.constant(other) - self

    def __mul__(self, other: "Poly | int") -> "Poly":
        other = other if isinstance(other, Poly) else Poly.constant(other)
        answer: dict[tuple[int, ...], int] = {}
        for left, left_coefficient in self.terms.items():
            for right, right_coefficient in other.terms.items():
                monomial = tuple(x + y for x, y in zip(left, right))
                answer[monomial] = answer.get(monomial, 0) + left_coefficient * right_coefficient
        return Poly({monomial: coefficient for monomial, coefficient in answer.items() if coefficient})

    __rmul__ = __mul__

    def __pow__(self, exponent: int) -> "Poly":
        answer = Poly.constant(1)
        for _ in range(exponent):
            answer *= self
        return answer


ZERO = Poly.constant(0)
ONE = Poly.constant(1)
a, b, c, d, s, t = (Poly.variable(index) for index in range(NVARIABLES))


def determinant(matrix: list[list[Poly]]) -> Poly:
    if len(matrix) == 1:
        return matrix[0][0]
    answer = ZERO
    for column, entry in enumerate(matrix[0]):
        if not entry.terms:
            continue
        minor = [row[:column] + row[column + 1 :] for row in matrix[1:]]
        term = entry * determinant(minor)
        answer = answer - term if column % 2 else answer + term
    return answer


def assert_equal(left: Poly, right: Poly, label: str) -> None:
    if left != right:
        raise AssertionError(f"polynomial identity failed: {label}")


def rational_add(left, right):
    return left[0] * right[1] + right[0] * left[1], left[1] * right[1]


def rational_neg(value):
    return -value[0], value[1]


def rational_sub(left, right):
    return rational_add(left, rational_neg(right))


def rational_mul(left, right):
    return left[0] * right[0], left[1] * right[1]


def rational_equal(left, right, label):
    assert_equal(left[0] * right[1], right[0] * left[1], label)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def algebra_certificate() -> dict:
    L0 = b * c + a + d - a * d - b - c
    L1 = a * b * c + b * c * d + a * d - a * b * d - a * c * d - b * c
    points = (
        (ONE, ZERO, ZERO),
        (ZERO, ONE, ZERO),
        (ZERO, ZERO, ONE),
        (ONE, ONE, ONE),
        (ONE, a, b),
        (ONE, c, d),
    )
    delta456 = determinant([list(points[index]) for index in (3, 4, 5)])
    assert_equal(L0, -delta456, "L0=-det(h4,h5,h6)")

    veronese = []
    for x, y, z in points:
        veronese.append([x * x, y * y, z * z, x * y, x * z, y * z])
    assert_equal(determinant(veronese), L1, "L1=det(v2(h1),...,v2(h6))")

    X, Y = b * c, a * d
    source = (a, b, c, d, X, Y)
    expected_factors = (
        (a - b) * (a - c) * (d - 1),
        (a - b) * (b - d) * (c - 1),
        (a - c) * (b - 1) * (c - d),
        (b - d) * (c - d) * (a - 1),
        (b - 1) * (c - 1) * (a * d - b * c),
        (a - 1) * (d - 1) * (a * d - b * c),
    )
    for index, (coordinate, expected) in enumerate(zip(source, expected_factors)):
        assert_equal(L1 - L0 * coordinate, expected, f"Gale numerator {index}")

    D = a * d - b * c
    partner = (
        (D * (d - 1), (b - d) * (c - d)),
        (D * (c - 1), (a - c) * (c - d)),
        (D * (b - 1), (a - b) * (b - d)),
        (D * (a - 1), (a - b) * (a - c)),
    )
    ap, bp, cp, dp = partner
    L0_partner = rational_sub(
        rational_add(
            rational_add(rational_mul(bp, cp), ap),
            dp,
        ),
        rational_add(
            rational_add(rational_mul(ap, dp), bp),
            cp,
        ),
    )
    L1_partner = rational_sub(
        rational_add(
            rational_add(rational_mul(rational_mul(ap, bp), cp), rational_mul(rational_mul(bp, cp), dp)),
            rational_mul(ap, dp),
        ),
        rational_add(
            rational_add(rational_mul(rational_mul(ap, bp), dp), rational_mul(rational_mul(ap, cp), dp)),
            rational_mul(bp, cp),
        ),
    )
    denominator = (a - b) * (a - c) * (b - d) * (c - d)
    rho = (D, denominator)
    rational_equal(L0_partner, rational_neg(rational_mul(rho, (L0**2, ONE))), "L0 under Gale")
    rational_equal(
        L1_partner,
        rational_neg(rational_mul(rational_mul(rho, rho), (L0**2 * L1, ONE))),
        "L1 under Gale",
    )

    line = tuple(s + t * coordinate for coordinate in source)
    Q = line[4] * line[0] * line[3] - line[5] * line[1] * line[2]
    assert_equal(Q, s * t * (L0 * s + L1 * t), "kernel-cubic factorization")
    assert_equal(L1**2, L1**2 - 4 * L0 * ZERO, "quadratic discriminant")

    return {
        "collision_factor": "L0=-det(h4,h5,h6)",
        "collision_polynomial": "bc+a+d-ad-b-c",
        "branch_factor": "L1=det(v2(h1),...,v2(h6))",
        "branch_polynomial": "abc+bcd+ad-abd-acd-bc",
        "kernel_cubic": "Q(se+tz)=st(L0*s+L1*t)",
        "reduced_quadratic": "q=s(L0*s+L1*t)",
        "quadratic_discriminant": "L1^2 in every characteristic",
        "sheet_orientation": "tau=L1/L0^2 satisfies tau(Gale(A))=-tau(A)",
        "artin_schreier_orientation": "eta=L0/(L0+L0#) satisfies eta#=1-eta, hence eta#=eta+1 in characteristic two",
        "overlap_law_odd": "tau_i/tau_j is Gale-invariant and the ratios form a multiplicative Cech cocycle",
        "overlap_law_characteristic_two": "a_ij=eta_i+eta_j is Gale-invariant and kappa_j-kappa_i=a_ij^2+a_ij",
        "gale_numerator_factors": [
            "(a-b)(a-c)(d-1)",
            "(a-b)(b-d)(c-1)",
            "(a-c)(b-1)(c-d)",
            "(b-d)(c-d)(a-1)",
            "(b-1)(c-1)(ad-bc)",
            "(a-1)(d-1)(ad-bc)",
        ],
    }


def frozen_controls() -> list[dict]:
    payload = json.loads(C478.read_text())
    answer = []
    for row in payload["c398_non_grs_controls"]:
        profiles = row["galois_equivariant_syndrome_subset_recovery_profile"]
        answer.append(
            {
                "q": row["q"],
                "child_size": row["locus_size"],
                "fixed_child_parent_count": row["fixed_child_parent_count"],
                "minimum_recovering_centres": row[
                    "minimum_recovering_galois_equivariant_syndrome_count"
                ],
                "profiles_through_minimum": profiles,
            }
        )
    expected = [(8, 4, 6, 3), (9, 6, 8, 3), (9, 7, 2, 2), (11, 12, 22, 3)]
    observed = [
        (row["q"], row["child_size"], row["fixed_child_parent_count"], row["minimum_recovering_centres"])
        for row in answer
    ]
    if observed != expected:
        raise AssertionError(f"C478 frozen-control drift: {observed}")
    return answer


def canonical_bytes(value) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def build_certificate() -> dict:
    return {
        "schema": "c483-reconstruction-discriminant-v1",
        "algebra": algebra_certificate(),
        "frozen_c478_input": {
            "path": C478.name,
            "bytes": C478.stat().st_size,
            "sha256": sha256(C478),
        },
        "frozen_child_relative_controls": frozen_controls(),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--emit", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.emit == args.check:
        parser.error("choose exactly one of --emit or --check")
    payload = canonical_bytes(build_certificate())
    if args.emit:
        CERTIFICATE.write_bytes(payload)
        print(f"wrote {CERTIFICATE.name} ({len(payload)} bytes)")
        return
    if CERTIFICATE.read_bytes() != payload:
        raise SystemExit("tracked certificate differs from exact regeneration")
    print("ok:", CERTIFICATE.name, len(payload), "bytes", hashlib.sha256(payload).hexdigest())


if __name__ == "__main__":
    main()
