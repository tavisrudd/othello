#!/usr/bin/env sage
"""Exact q=25 universal-affine quadratic pullback calculation for C665.

The field is Sage's canonical GF(5^2).  The script constructs the point-vector
affine conic-fibre module from a fixed matching and computes H- and
outer-equivariant Hom spaces from the two exceptional-head candidates
L(1) tensor L(1)^(1) and L(2) tensor L(2)^(1).  Both Hom spaces vanish, so
the linear-parity cross channel is absent and no quadratic pullback exists.
"""

import argparse
import json
from pathlib import Path

from sage.all import (
    GF,
    PolynomialRing,
    block_matrix,
    identity_matrix,
    matrix,
    vector,
)
from sage.libs.gap.libgap import libgap


Q = 25
P = 5
F = GF(Q, name="a")
A = F.gen()
HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-26-c665-q25-pullback.json"

R = PolynomialRing(F, names=("X", "Y", "Z"))
X, Y, Z = R.gens()
CONIC = X * Z - Y**2

FIELD_ELEMENTS = tuple(F)
FIELD_INDEX = {value: i for i, value in enumerate(FIELD_ELEMENTS)}
ENDPOINTS = tuple((value, F.one()) for value in FIELD_ELEMENTS) + (
    (F.one(), F.zero()),
)
BASE_MATCHING = tuple((i, i + 1) for i in range(0, Q + 1, 2))
DEGREE = (Q - 3) // 2


def homogeneous_exponents(degree):
    return tuple(
        (i, j, degree - i - j)
        for i in range(degree + 1)
        for j in range(degree - i + 1)
    )


EXPONENTS = homogeneous_exponents(DEGREE)
BASIS = tuple(X**i * Y**j * Z**k for i, j, k in EXPONENTS)
BASIS_INDEX = {exponent: i for i, exponent in enumerate(EXPONENTS)}


def projective_image(g, endpoint):
    a, b, c, d = map(F, g)
    s, t = ENDPOINTS[endpoint]
    numerator = a * s + b * t
    denominator = c * s + d * t
    if denominator == 0:
        return Q
    return FIELD_INDEX[numerator / denominator]


def image_matching(g, matching):
    return tuple(
        sorted(
            tuple(sorted((projective_image(g, left), projective_image(g, right))))
            for left, right in matching
        )
    )


def matching_product(matching):
    answer = R.one()
    for left, right in matching:
        si, ti = ENDPOINTS[left]
        sj, tj = ENDPOINTS[right]
        answer *= (
            ti * tj * X
            - (si * tj + ti * sj) * Y
            + si * sj * Z
        )
    return answer


BASE_PRODUCT = matching_product(BASE_MATCHING)


def coefficient_vector(poly):
    answer = [F.zero()] * len(BASIS)
    for exponent, coefficient in poly.dict().items():
        answer[BASIS_INDEX[tuple(exponent)]] = coefficient
    return answer


def conic_action(g):
    """Column-action matrix on k plus degree-eleven conic quotients."""
    a, b, c, d = map(F, g)
    determinant = a * d - b * c
    images = (
        d**2 * X - 2 * b * d * Y + b**2 * Z,
        -c * d * X + (a * d + b * c) * Y - a * b * Z,
        c**2 * X - 2 * a * c * Y + a**2 * Z,
    )

    def rho(poly):
        return poly(*images)

    assert rho(CONIC) == determinant**2 * CONIC
    transformed_matching = image_matching(g, BASE_MATCHING)
    transformed_product = matching_product(transformed_matching)
    rho_base = rho(BASE_PRODUCT)
    pivot = next(
        exponent
        for exponent in sorted(transformed_product.dict())
        if transformed_product.dict()[exponent]
    )
    pivot_monomial = X**pivot[0] * Y**pivot[1] * Z**pivot[2]
    product_scale = rho_base.monomial_coefficient(pivot_monomial)
    product_scale /= transformed_product.monomial_coefficient(pivot_monomial)
    assert rho_base == product_scale * transformed_product

    cocycle, remainder = (transformed_product - BASE_PRODUCT).quo_rem(CONIC)
    assert remainder == 0 and cocycle.degree() <= DEGREE

    dimension = 1 + len(BASIS)
    action = matrix(F, dimension, dimension)
    action[0, 0] = 1
    for row, value in enumerate(coefficient_vector(cocycle), start=1):
        action[row, 0] = value
    for column, basis_vector in enumerate(BASIS, start=1):
        transformed = determinant**2 / product_scale * rho(basis_vector)
        for row, value in enumerate(coefficient_vector(transformed), start=1):
            action[row, column] = value
    return action


def binary_symmetric_power(g, degree):
    """Column action on a contragredient binary symmetric power."""
    S = PolynomialRing(F, names=("s", "t"))
    s, t = S.gens()
    a, b, c, d = map(F, g)
    images = (d * s - b * t, -c * s + a * t)
    basis = tuple(s**i * t ** (degree - i) for i in range(degree + 1))
    action = matrix(F, degree + 1, degree + 1)
    for column, basis_vector in enumerate(basis):
        transformed = basis_vector(*images)
        for exponent, coefficient in transformed.dict().items():
            action[exponent[0], column] = coefficient
    return action


def digit_simple_action(g, digits):
    factors = []
    for index, digit in enumerate(digits):
        factor = binary_symmetric_power(g, digit)
        if index:
            factor = factor.apply_map(lambda value: value ** (P**index))
        factors.append(factor)
    answer = factors[0]
    for factor in factors[1:]:
        answer = answer.tensor_product(factor)
    return answer


def normalized_simple_action(g, digits):
    a, b, c, d = map(F, g)
    determinant = a * d - b * c
    highest_weight = sum(digit * P**i for i, digit in enumerate(digits))
    assert highest_weight % 2 == 0
    return determinant ** (-highest_weight // 2) * digit_simple_action(g, digits)


def gap_module(column_actions):
    generators = [
        libgap(action.transpose().dense_matrix()) for action in column_actions
    ]
    return libgap.GModuleByMats(generators, libgap.GF(Q))


def hom_basis(source, target):
    homomorphisms = libgap.MTX["BasisModuleHomomorphisms"](source, target)
    rows = [list(matrix(F, homomorphism).list()) for homomorphism in homomorphisms]
    if not rows:
        return matrix(F, 0, 0)
    echelon = matrix(F, rows).echelon_form()
    return matrix(F, [row for row in echelon.rows() if row])


def outer_on_hom(basis, source_dilation, target_dilation):
    if basis.nrows() == 0:
        return (0, 0)
    source_outer = source_dilation.transpose()
    target_outer = target_dilation.transpose()
    rows = []
    for row in basis.rows():
        hom = matrix(
            F, source_dilation.nrows(), target_dilation.nrows(), row
        )
        transformed = source_outer.inverse() * hom * target_outer
        flat = vector(F, transformed.list())
        coordinates = basis.solve_left(flat)
        assert coordinates * basis == flat
        rows.append(coordinates)
    induced = matrix(F, rows)
    identity = identity_matrix(F, induced.nrows())
    return (
        (induced - identity).right_kernel().dimension(),
        (induced + identity).right_kernel().dimension(),
    )


def direct_hom_dimension(source_actions, target_actions):
    """Independent intertwiner nullity using explicit block equations."""
    source_dimension = source_actions[0].nrows()
    target_dimension = target_actions[0].nrows()
    identity = identity_matrix(F, target_dimension)
    systems = []
    for source, target in zip(source_actions, target_actions):
        blocks = []
        for output_column in range(source_dimension):
            block_row = []
            for input_column in range(source_dimension):
                block = -source[input_column, output_column] * identity
                if input_column == output_column:
                    block += target
                block_row.append(block)
            blocks.append(block_row)
        systems.append(block_matrix(blocks))
    return matrix(F, 0, source_dimension * target_dimension).stack(
        systems[0]
    ).stack(systems[1]).stack(systems[2]).right_kernel().dimension()


def calculate():
    translation_one = (1, 1, 0, 1)
    translation_a = (1, A, 0, 1)
    inversion = (0, -1, 1, 0)
    primitive = F.multiplicative_generator()
    dilation = (primitive, 0, 0, 1)
    h_generators = (translation_one, translation_a, inversion)
    affine_actions = [conic_action(g) for g in h_generators]
    affine_dilation = conic_action(dilation)
    affine_module = gap_module(affine_actions)
    records = []
    for name, digits in (("A4", (1, 1)), ("S4", (2, 2))):
        simple_actions = [digit_simple_action(g, digits) for g in h_generators]
        simple_dilation = normalized_simple_action(dilation, digits)
        simple_module = gap_module(simple_actions)
        affine_homs = hom_basis(simple_module, affine_module)
        direct_dimension = direct_hom_dimension(
            simple_actions, affine_actions
        )
        assert direct_dimension == affine_homs.nrows()
        records.append(
            {
                "subgroup_type": name,
                "steinberg_digits": list(digits),
                "simple_dimension": simple_dilation.nrows(),
                "hom_to_affine_dimension": affine_homs.nrows(),
                "direct_linear_hom_dimension": direct_dimension,
                "hom_to_affine_outer": list(
                    outer_on_hom(
                        affine_homs, simple_dilation, affine_dilation
                    )
                ),
                "quadratic_pullback_required": affine_homs.nrows() != 0,
            }
        )
    assert all(
        record["hom_to_affine_dimension"] == 0 for record in records
    )
    return {
        "schema": 1,
        "q": Q,
        "p": P,
        "field_modulus": str(F.modulus()),
        "base_matching": [list(edge) for edge in BASE_MATCHING],
        "affine_dimension": affine_dilation.nrows(),
        "h_generators": [
            [str(value) for value in generator] for generator in h_generators
        ],
        "outer_dilation": [str(value) for value in dilation],
        "conclusion": (
            "both exceptional heads are absent from the affine socle; "
            "the linear-parity cross channel is therefore absent"
        ),
        "records": records,
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()

    result = calculate()
    encoded = json.dumps(result, default=int, indent=2, sort_keys=True) + "\n"
    if args.write:
        CERTIFICATE.write_text(encoded)
        print(f"wrote {CERTIFICATE.name}")
    elif args.check:
        assert CERTIFICATE.read_text() == encoded
        print(f"checked {CERTIFICATE.name}")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
