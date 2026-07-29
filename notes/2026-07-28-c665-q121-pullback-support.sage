#!/usr/bin/env sage
"""Shared exact support for the q=121 C665 pullback detectors.

Let i:L(6)->F be the unique embedded head found by the adjacent
affine-socle checker.  This module constructs the point-vector cocycle,
a split-torus-fixed lift of the affine quotient, and the unique embedded
L(6).  It is imported by focused quotient detectors and is not a standalone
checker.
"""

import importlib.machinery
import importlib.util
from pathlib import Path

from sage.all import PolynomialRing


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-07-28-c665-q121-affine-socle.sage"
def load_base():
    loader = importlib.machinery.SourceFileLoader(
        "c665_q121_affine_base", str(BASE_PATH)
    )
    spec = importlib.util.spec_from_loader(loader.name, loader)
    if spec is None:
        raise RuntimeError(f"cannot load {BASE_PATH}")
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


base = load_base()
FIELD = base.FIELD
A = base.A
Q = base.Q
SOURCE_DEGREE = base.DEGREE
TORUS_MODULUS = base.TORUS_MODULUS
R = PolynomialRing(FIELD, names=("X", "Y", "Z"))
X, Y, Z = R.gens()
CONIC = X * Z - Y**2
SOURCE_MONOMIALS = tuple(
    X**i * Y**j * Z**k for i, j, k in base.EXPONENTS
)
FIELD_ELEMENTS = tuple(FIELD)
FIELD_INDEX = {
    value: index for index, value in enumerate(FIELD_ELEMENTS)
}
ENDPOINTS = tuple(
    (value, FIELD.one()) for value in FIELD_ELEMENTS
) + ((FIELD.one(), FIELD.zero()),)
BASE_MATCHING = tuple(
    (index, index + 1) for index in range(0, Q + 1, 2)
)


def projective_image(g, endpoint):
    aa, bb, cc, dd = map(FIELD, g)
    s, t = ENDPOINTS[endpoint]
    numerator = aa * s + bb * t
    denominator = cc * s + dd * t
    if denominator == 0:
        return Q
    return FIELD_INDEX[numerator / denominator]


def image_matching(g, matching):
    return tuple(
        sorted(
            tuple(
                sorted(
                    (
                        projective_image(g, left),
                        projective_image(g, right),
                    )
                )
            )
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


def conic_images(g):
    aa, bb, cc, dd = map(FIELD, g)
    return (
        dd**2 * X - 2 * bb * dd * Y + bb**2 * Z,
        -cc * dd * X + (aa * dd + bb * cc) * Y - aa * bb * Z,
        cc**2 * X - 2 * aa * cc * Y + aa**2 * Z,
    )


def action_data(g):
    aa, bb, cc, dd = map(FIELD, g)
    determinant = aa * dd - bb * cc
    images = conic_images(g)
    transformed_matching = image_matching(g, BASE_MATCHING)
    transformed_product = matching_product(transformed_matching)
    rho_base = BASE_PRODUCT(*images)
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
    assert remainder == 0 and cocycle.degree() <= SOURCE_DEGREE
    linear_scale = determinant**2 / product_scale
    return images, linear_scale, cocycle


def act_polynomial(polynomial, data):
    images, linear_scale, _ = data
    return linear_scale * polynomial(*images)


def polynomial_from_source_vector(coefficients):
    return sum(
        (
            coefficient * monomial
            for coefficient, monomial in zip(coefficients, SOURCE_MONOMIALS)
            if coefficient
        ),
        R.zero(),
    )


def same_torus_character(left, right):
    return (left - right) % TORUS_MODULUS == 0


def split_torus_fixed_lift(generators, torus_data):
    primitive = FIELD.multiplicative_generator()
    torus_element = (primitive, 0, 0, primitive**-1)
    images, linear_scale, cocycle = torus_data
    assert images == (
        primitive**-2 * X,
        Y,
        primitive**2 * Z,
    )
    correction = R.zero()
    for exponent, coefficient in cocycle.dict().items():
        i, j, k = tuple(exponent)
        eigenvalue = linear_scale * primitive ** (2 * (k - i))
        if eigenvalue == 1:
            assert coefficient == 0
        else:
            correction += -coefficient / (eigenvalue - 1) * (
                X**i * Y**j * Z**k
            )
    assert act_polynomial(correction, torus_data) - correction + cocycle == 0
    adjusted = []
    for data in generators:
        _, _, cocycle_g = data
        adjusted.append(
            cocycle_g + act_polynomial(correction, data) - correction
        )
    return torus_element, correction, adjusted


def embedding_polynomials():
    parameters = (FIELD.one(), A)
    translation_columns = [
        [
            base.translation_column(exponent, parameter)
            for exponent in base.EXPONENTS
        ]
        for parameter in parameters
    ]
    inversion_columns = [
        base.inversion_column(exponent) for exponent in base.EXPONENTS
    ]
    simple_actions = [
        base.binary_translation(parameter, base.L6_DEGREE)
        for parameter in parameters
    ] + [base.binary_inversion(base.L6_DEGREE)]
    embedding, variables, kernel = base.embedding_hom_dimension(
        translation_columns + [inversion_columns],
        simple_actions,
        base.L6_WEIGHTS,
    )
    assert embedding["dimension"] == 1
    vector = kernel.basis()[0]
    columns = []
    for simple_column in range(base.SIMPLE_DEGREE + 1):
        coefficients = [FIELD.zero()] * len(base.EXPONENTS)
        for f_row in range(len(base.EXPONENTS)):
            variable = variables.get((f_row, simple_column))
            if variable is not None:
                coefficients[f_row] = vector[variable]
        columns.append(polynomial_from_source_vector(coefficients))
    return embedding, columns, simple_actions
