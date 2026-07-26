#!/usr/bin/env sage
"""Exact q=49 affine-socle gate for C665.

Construct the universal point-vector affine conic-fibre module E and test
the characteristic-seven exceptional heads before constructing Sym^2(E):

  A4, S4: L(1) tensor L(1)^(1);
  A5:     L(3) tensor L(3)^(1).

GAP MeatAxe intertwiners and an exact reduced Sage block-linear solve
independently prove that both Hom spaces vanish.  The reduction first traps
every possible image in the small primary kernel of one combined group
algebra element.  A quadratic pullback is requested only when this affine
Hom space is nonzero.
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


Q = 49
P = 7
F = GF(Q, name="a")
A = F.gen()
HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-26-c665-q49-affine-socle.json"

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
    """Column-action matrix on k plus degree-23 conic quotients."""
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
    action = matrix(F, dimension, dimension, sparse=True)
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
    binary_ring = PolynomialRing(F, names=("s", "t"))
    s, t = binary_ring.gens()
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


def reduced_direct_hom(source_actions, target_actions):
    """Independent Hom solve after an exact primary-kernel reduction."""
    weights = (F.one(), A, A**2)
    source_combined = sum(
        (weight * action for weight, action in zip(weights, source_actions)),
        matrix(F, source_actions[0].nrows()),
    )
    target_combined = sum(
        (weight * action for weight, action in zip(weights, target_actions)),
        matrix(F, target_actions[0].nrows(), sparse=True),
    )
    source_minpoly = source_combined.minimal_polynomial()
    target_annihilator = source_minpoly(target_combined)
    image_container = target_annihilator.right_kernel().basis_matrix().transpose()
    reduced_dimension = image_container.ncols()
    systems = []
    for source, target in zip(source_actions, target_actions):
        target_image = target * image_container
        blocks = []
        for output_column in range(source.nrows()):
            block_row = []
            for input_column in range(source.nrows()):
                block = -source[input_column, output_column] * image_container
                if input_column == output_column:
                    block += target_image
                block_row.append(block)
            blocks.append(block_row)
        systems.append(block_matrix(blocks, sparse=True))
    system = systems[0].stack(systems[1]).stack(systems[2])
    return {
        "weights": [str(weight) for weight in weights],
        "source_minpoly_degree": source_minpoly.degree(),
        "target_primary_kernel_dimension": reduced_dimension,
        "hom_dimension": system.right_kernel().dimension(),
    }


def calculate(probe=False):
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
    for subgroup_types, digits in (
        (("A4", "S4"), (1, 1)),
        (("A5",), (3, 3)),
    ):
        simple_actions = [digit_simple_action(g, digits) for g in h_generators]
        simple_dilation = normalized_simple_action(dilation, digits)
        simple_module = gap_module(simple_actions)
        affine_homs = hom_basis(simple_module, affine_module)
        direct = (
            None
            if probe
            else reduced_direct_hom(simple_actions, affine_actions)
        )
        if direct is not None:
            assert direct["hom_dimension"] == affine_homs.nrows()
        records.append(
            {
                "subgroup_types": list(subgroup_types),
                "steinberg_digits": list(digits),
                "simple_dimension": simple_dilation.nrows(),
                "hom_to_affine_dimension": affine_homs.nrows(),
                "independent_reduced_linear_solve": direct,
                "hom_to_affine_outer": list(
                    outer_on_hom(
                        affine_homs, simple_dilation, affine_dilation
                    )
                ),
                "quadratic_pullback_required": affine_homs.nrows() != 0,
            }
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
            "quadratic pullback is required exactly for records whose "
            "exceptional head embeds in the universal affine socle"
        ),
        "records": records,
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--probe", action="store_true")
    args = parser.parse_args()

    result = calculate(probe=args.probe)
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
