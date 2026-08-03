#!/usr/bin/env python3
"""Generate the compact R9 residual-quadratic certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
from pathlib import Path

P = 7


class Poly:
    """Sparse polynomial over F_7 in (x, L)."""

    def __init__(self, terms=None):
        self.terms = {
            mon: value % P
            for mon, value in (terms or {}).items()
            if value % P
        }

    @staticmethod
    def constant(value):
        return Poly({(0, 0): value})

    @staticmethod
    def x():
        return Poly({(1, 0): 1})

    @staticmethod
    def ell():
        return Poly({(0, 1): 1})

    def __add__(self, other):
        other = as_poly(other)
        out = dict(self.terms)
        for mon, value in other.terms.items():
            out[mon] = (out.get(mon, 0) + value) % P
            if out[mon] == 0:
                del out[mon]
        return Poly(out)

    __radd__ = __add__

    def __neg__(self):
        return Poly({mon: -value for mon, value in self.terms.items()})

    def __sub__(self, other):
        return self + (-as_poly(other))

    def __rsub__(self, other):
        return as_poly(other) - self

    def __mul__(self, other):
        other = as_poly(other)
        out = {}
        for (ix, il), left in self.terms.items():
            for (jx, jl), right in other.terms.items():
                mon = (ix + jx, il + jl)
                out[mon] = (out.get(mon, 0) + left * right) % P
        return Poly(out)

    __rmul__ = __mul__

    def __pow__(self, exponent):
        assert exponent >= 0
        out = Poly.constant(1)
        base = self
        while exponent:
            if exponent & 1:
                out = out * base
            base = base * base
            exponent //= 2
        return out

    def coefficient_x(self, degree):
        return UniPoly(
            {
                il: value
                for (ix, il), value in self.terms.items()
                if ix == degree
            }
        )

    def degree_x(self):
        return max((ix for ix, _ in self.terms), default=-1)

    def evaluate(self, x_value, ell_value):
        return sum(
            value * pow(x_value, ix, P) * pow(ell_value, il, P)
            for (ix, il), value in self.terms.items()
        ) % P


def as_poly(value):
    return value if isinstance(value, Poly) else Poly.constant(value)


class UniPoly:
    """Dense-enough univariate polynomial over F_7, stored low first."""

    def __init__(self, coefficients=None):
        if isinstance(coefficients, dict):
            size = max(coefficients, default=-1) + 1
            coefficients = [coefficients.get(i, 0) for i in range(size)]
        self.c = [value % P for value in (coefficients or [])]
        while self.c and self.c[-1] == 0:
            self.c.pop()

    def __add__(self, other):
        other = as_unipoly(other)
        size = max(len(self.c), len(other.c))
        return UniPoly(
            [
                (self.c[i] if i < len(self.c) else 0)
                + (other.c[i] if i < len(other.c) else 0)
                for i in range(size)
            ]
        )

    __radd__ = __add__

    def __neg__(self):
        return UniPoly([-value for value in self.c])

    def __sub__(self, other):
        return self + (-as_unipoly(other))

    def __rsub__(self, other):
        return as_unipoly(other) - self

    def __mul__(self, other):
        other = as_unipoly(other)
        if not self.c or not other.c:
            return UniPoly()
        out = [0] * (len(self.c) + len(other.c) - 1)
        for i, left in enumerate(self.c):
            for j, right in enumerate(other.c):
                out[i + j] = (out[i + j] + left * right) % P
        return UniPoly(out)

    __rmul__ = __mul__

    def __pow__(self, exponent):
        out = UniPoly([1])
        base = self
        while exponent:
            if exponent & 1:
                out = out * base
            base = base * base
            exponent //= 2
        return out

    def divmod(self, other):
        other = as_unipoly(other)
        assert other.c
        remainder = self.c[:]
        quotient = [0] * max(1, len(remainder) - len(other.c) + 1)
        inverse = pow(other.c[-1], -1, P)
        while len(remainder) >= len(other.c):
            shift = len(remainder) - len(other.c)
            scale = remainder[-1] * inverse % P
            quotient[shift] = scale
            for i, value in enumerate(other.c):
                remainder[shift + i] = (
                    remainder[shift + i] - scale * value
                ) % P
            while remainder and remainder[-1] == 0:
                remainder.pop()
        return UniPoly(quotient), UniPoly(remainder)

    def monic(self):
        if not self.c:
            return self
        inverse = pow(self.c[-1], -1, P)
        return UniPoly([inverse * value for value in self.c])

    def evaluate(self, value):
        out = 0
        for coefficient in reversed(self.c):
            out = (out * value + coefficient) % P
        return out

    def derivative(self):
        return UniPoly(
            [i * self.c[i] for i in range(1, len(self.c))]
        )


def as_unipoly(value):
    return value if isinstance(value, UniPoly) else UniPoly([value])


def gcd(left, right):
    while right.c:
        _, remainder = left.divmod(right)
        left, right = right, remainder
    return left.monic()


def extended_gcd(left, right):
    """Return monic gcd and Bezout coefficients over F_7[L]."""
    old_r, r = left, right
    old_s, s = UniPoly([1]), UniPoly()
    old_t, t = UniPoly(), UniPoly([1])
    while r.c:
        quotient, remainder = old_r.divmod(r)
        old_r, r = r, remainder
        old_s, s = s, old_s - quotient * s
        old_t, t = t, old_t - quotient * t
    scale = pow(old_r.c[-1], -1, P)
    return (
        old_r * scale,
        old_s * scale,
        old_t * scale,
    )


def bezout_family(polynomials):
    """Return gcd and one coefficient per polynomial."""
    common = polynomials[0]
    coefficients = [UniPoly([1])]
    for polynomial in polynomials[1:]:
        common, left, right = extended_gcd(common, polynomial)
        coefficients = [left * coefficient for coefficient in coefficients]
        coefficients.append(right)
    return common, coefficients


def product_linear_roots(roots):
    """Coefficients of prod(T-r)*(T-x), low first, as polynomials in x."""
    fixed = [1]
    for root in roots:
        out = [0] * (len(fixed) + 1)
        for i, value in enumerate(fixed):
            out[i] = (out[i] - root * value) % P
            out[i + 1] = (out[i + 1] + value) % P
        fixed = out
    x = Poly.x()
    coefficients = [Poly.constant(0) for _ in range(6)]
    for i, value in enumerate(fixed):
        coefficients[i] = coefficients[i] - value * x
        coefficients[i + 1] = coefficients[i + 1] + value
    return coefficients


def residual_data(roots, h):
    """Return D, Ns, Nu, K for a four-root base and moving fifth root."""
    coefficients = product_linear_roots(roots)

    def p(index):
        return (
            coefficients[index]
            if 0 <= index < len(coefficients)
            else Poly.constant(0)
        )

    hankel = []
    for shift in (-1, 0, 1, 2):
        hankel.append(sum(h[j] * p(j + shift) for j in range(5)))
    hm1, h0, h1, h2 = hankel
    determinant = h0 * h2 - h1 * h1
    trace_numerator = hm1 * h2 - h0 * h1
    norm_numerator = hm1 * h1 - h0 * h0
    branch = trace_numerator**2 - 4 * norm_numerator * determinant
    return determinant, trace_numerator, norm_numerator, branch


def quartic_discriminant(branch):
    # A*x^4+B*x^3+C*x^2+D*x+E
    a, b, c, d, e = [
        branch.coefficient_x(degree) for degree in range(4, -1, -1)
    ]
    return (
        256 * a**3 * e**3
        - 192 * a**2 * b * d * e**2
        - 128 * a**2 * c**2 * e**2
        + 144 * a**2 * c * d**2 * e
        - 27 * a**2 * d**4
        + 144 * a * b**2 * c * e**2
        - 6 * a * b**2 * d**2 * e
        - 80 * a * b * c**2 * d * e
        + 18 * a * b * c * d**3
        + 16 * a * c**4 * e
        - 4 * a * c**3 * d**2
        - 27 * b**4 * e**2
        + 18 * b**3 * c * d * e
        - 4 * b**3 * d**3
        - 4 * b**2 * c**3 * e
        + b**2 * c**2 * d**2
    )


def small_discriminant(poly):
    coefficients = poly.c + [0] * (5 - len(poly.c))
    degree = len(poly.c) - 1
    if degree == 2:
        c, b, a = coefficients[:3]
        return (b * b - 4 * a * c) % P
    if degree == 3:
        d, c, b, a = coefficients[:4]
        return (
            b * b * c * c
            - 4 * a * c**3
            - 4 * b**3 * d
            - 27 * a * a * d * d
            + 18 * a * b * c * d
        ) % P
    raise ValueError(f"unsupported reduced degree {degree}")


def branch_coefficients(branch, ell_value=0):
    degree = branch.degree_x()
    return [
        branch.evaluate(x_value=0, ell_value=ell_value)
        if degree == 0
        else branch.coefficient_x(i).evaluate(ell_value)
        for i in range(degree + 1)
    ]


def canonical_projective_vectors(q, length):
    for pivot in range(length):
        for tail in itertools.product(range(q), repeat=length - pivot - 1):
            yield (0,) * pivot + (1,) + tail


def projective_rootless_quartics_q7():
    count = 0
    for coefficients in canonical_projective_vectors(7, 5):
        finite_root = any(
            sum(
                coefficient * pow(value, degree, 7)
                for degree, coefficient in enumerate(coefficients)
            )
            % 7
            == 0
            for value in range(7)
        )
        infinity_root = coefficients[-1] == 0
        if not finite_root and not infinity_root:
            count += 1
    return count


def hasse_threshold(deletion):
    q = 2
    while q + 1 - 2 * math.sqrt(q) <= deletion:
        q += 1
    return q


def first_prime_power_at_least(bound):
    def is_prime_power(value):
        for prime in range(2, value + 1):
            if any(prime % divisor == 0 for divisor in range(2, int(prime**0.5) + 1)):
                continue
            power = prime
            while power < value:
                power *= prime
            if power == value:
                return True
        return False

    value = bound
    while not is_prime_power(value):
        value += 1
    return value


def nucleus_support(n, characteristic):
    return [
        j
        for j in range(n + 1)
        if all(
            math.comb(row, j) % characteristic == 0
            for row in range(j, n + 1)
            if row >= 1
        )
    ]


def top_nucleus_support(n, characteristic):
    return [
        j
        for j in range(1, n)
        if math.comb(n, j) % characteristic == 0
    ]


def consecutive_lift(lower_support, syndrome_degree):
    return [
        j
        for j in range(syndrome_degree + 1)
        if j in lower_support and j - 1 in lower_support
    ]


def orbit_table():
    rows = []
    for d in (1, 2, 4, 8):
        inversion_classes = 1 + d // 2 if d > 1 else 1
        pgl_total = inversion_classes + 1
        rows.append(
            {
                "d": d,
                "sigma_pgl_orbits": inversion_classes,
                "total_pgl_orbits_odd_characteristic": pgl_total,
                "sigma_pgamma_orbits": (
                    {"p_mod_8_pm1": 5, "p_mod_8_pm3": 4}
                    if d == 8
                    else {"all": inversion_classes}
                ),
            }
        )
    return rows


def build_certificate():
    ell = Poly.ell()
    normal_h = [1, 0, ell, 0, 1]
    bases = [
        (0, 1, 2, 3),
        (0, 1, 2, 4),
        (0, 1, 2, 5),
        (0, 1, 2, 6),
        (0, 1, 3, 4),
        (1, 2, 3, 4),
    ]
    discriminants = []
    discriminant_polynomials = []
    common = None
    for roots in bases:
        determinant, trace, norm, branch = residual_data(roots, normal_h)
        discriminant = quartic_discriminant(branch)
        common = discriminant if common is None else gcd(common, discriminant)
        discriminant_polynomials.append(discriminant)
        discriminants.append(
            {
                "fixed_roots": list(roots),
                "determinant_degree_x": determinant.degree_x(),
                "trace_numerator_degree_x": trace.degree_x(),
                "norm_numerator_degree_x": norm.degree_x(),
                "branch_degree_x": branch.degree_x(),
                "discriminant_coefficients_low_first": discriminant.c,
            }
        )
    bezout_gcd, bezout_coefficients = bezout_family(
        discriminant_polynomials
    )
    assert bezout_gcd.c == [1]

    degenerate_forms = {}
    forms = {
        "partition_4": ((1, 2, 3, 4), [1, 0, 0, 0, 0]),
        "partition_31": ((0, 2, 4, 6), [0, 1, 0, 0, 0]),
        "partition_22": ((0, 1, 2, 3), [0, 0, 1, 0, 0]),
        "partition_211": ((0, 1, 2, 3), [0, 1, -1, 0, 0]),
    }
    for name, (roots, form) in forms.items():
        determinant, trace, norm, branch = residual_data(roots, form)
        branch_poly = UniPoly(
            [
                branch.coefficient_x(i).evaluate(0)
                for i in range(branch.degree_x() + 1)
            ]
        )
        if name in {"partition_4", "partition_31"}:
            assert branch_poly.c[:2] == [0, 0]
            reduced = UniPoly(branch_poly.c[2:])
        else:
            assert gcd(branch_poly, branch_poly.derivative()).c == [1]
            reduced = branch_poly
        degenerate_forms[name] = {
            "fixed_roots": list(roots),
            "determinant_coefficients_x_low_first": [
                determinant.coefficient_x(i).evaluate(0)
                for i in range(determinant.degree_x() + 1)
            ],
            "branch_coefficients_x_low_first": [
                branch.coefficient_x(i).evaluate(0)
                for i in range(branch.degree_x() + 1)
            ],
            "reduced_branch_coefficients_x_low_first": reduced.c,
            "reduced_branch_discriminant": (
                quartic_discriminant(branch).evaluate(0)
                if len(reduced.c) - 1 == 4
                else small_discriminant(reduced)
            ),
        }

    four_marker_deletion = 12 + 4 * 6
    # Point deletions on the normalized residual double cover.  Divisors
    # pulled back from the moving-root line double, except the ramified
    # branch divisor.
    modular_curve_deletion = 8 + 4 + 4 + 4 * 2 + 8
    return {
        "schema": "r9-prs-redundancy-nine-v1",
        "field_characteristic": 7,
        "residual_formula": {
            "hankel_contractions": [
                "H_j=sum_(i=0)^4 a_i p_(i+j), with p_k=0 outside 0..5"
            ],
            "determinant": "D=H_0*H_2-H_1^2",
            "trace_numerator": "N_s=H_-1*H_2-H_0*H_1",
            "norm_numerator": "N_u=H_-1*H_1-H_0^2",
            "branch": "K=N_s^2-4*N_u*D",
            "residual_quadratic": "D*T^2-N_s*T+N_u",
            "collision_resultant": "Res(P,D*T^2-N_s*T+N_u)",
        },
        "normal_squarefree_family": {
            "quartic": "[1,0,L,0,1]",
            "catalecticant_determinant": "L*(1-L^2)",
            "base_fibres": discriminants,
            "discriminant_gcd_coefficients_low_first": common.c,
            "expected_gcd_coefficients_low_first": [1],
            "bezout_coefficients_low_first": [
                coefficient.c for coefficient in bezout_coefficients
            ],
        },
        "multiple_root_normal_forms": degenerate_forms,
        "divisor_degrees_on_modular_curve": {
            "fixed_root_diagonal": 8,
            "determinant": 4,
            "branch": 4,
            "four_fixed_root_collisions": 8,
            "moving_root_collision": 8,
            "total_deletion_bound": modular_curve_deletion,
        },
        "bad_base_discriminant_degree_bound": {
            "degree_per_base_root": 24,
            "total_degree": 96,
            "base_vandermonde_degree": 6,
            "field_size_strictly_greater_than": 102,
            "first_characteristic_seven_field": 343,
        },
        "thresholds": {
            "four_marker_deletion": four_marker_deletion,
            "exact_integer_threshold": hasse_threshold(four_marker_deletion),
            "first_prime_power": first_prime_power_at_least(
                hasse_threshold(four_marker_deletion)
            ),
            "modular_curve_deletion": modular_curve_deletion,
            "modular_curve_integer_threshold": hasse_threshold(
                modular_curve_deletion
            ),
        },
        "modular_lifts": [
            {
                "characteristic": 5,
                "degree_seven_top_nucleus_support": top_nucleus_support(7, 5),
                "degree_eight_consecutive_lift": consecutive_lift(
                    top_nucleus_support(7, 5), 8
                ),
                "status": "shallow for every q>5",
            },
            {
                "characteristic": 7,
                "degree_seven_top_nucleus_support": top_nucleus_support(7, 7),
                "degree_eight_consecutive_lift": consecutive_lift(
                    top_nucleus_support(7, 7), 8
                ),
                "status": "binary-quartic carrier; shallow for q>=343",
            },
        ],
        "q7_projective_quartics": (7**5 - 1) // 6,
        "q7_rootless_deep_quartics": projective_rootless_quartics_q7(),
        "persistent_orbits": {
            "sigma_parameter": "T/T^8 modulo inversion and Frobenius",
            "tangent_cocycle": "z -> z+8u",
            "total_deep_points": "q(q+1)^2/2",
            "rows": orbit_table(),
            "characteristic_two_total_pgl_pgamma_orbits": [3, 3],
            "d8_total_pgamma_orbits": {
                "p_mod_8_pm1": 6,
                "p_mod_8_pm3": 5,
            },
        },
    }


def canonical_bytes(data):
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = build_certificate()
    payload = canonical_bytes(data)
    if args.check:
        if args.output is None:
            raise SystemExit("--check requires --output")
        if args.output.read_bytes() != payload:
            raise SystemExit("tracked certificate differs from regeneration")
    elif args.output:
        args.output.write_bytes(payload)
    else:
        print(payload.decode(), end="")
    print(
        json.dumps(
            {
                "bytes": len(payload),
                "sha256": hashlib.sha256(payload).hexdigest(),
                "q7_rootless": data["q7_rootless_deep_quartics"],
                "threshold": data["thresholds"]["first_prime_power"],
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
