#!/usr/bin/env python3
"""Exact certificate for the intrinsic C682 E8 principal-symbol cubic."""

from __future__ import annotations

import argparse
import importlib.util
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE = HERE / "2026-07-28-c682-klein-e8-free-covariant.py"
BASE_CERTIFICATE = HERE / "2026-07-28-c682-klein-e8-free-covariant.json"
CERTIFICATE = HERE / "2026-07-29-c682-intrinsic-e8-symbol.json"


def load_base():
    spec = importlib.util.spec_from_file_location("klein_e8_free_base", BASE)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load the exact free-covariant engine")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def falling(value: int, order: int) -> int:
    result = 1
    for offset in range(order):
        result *= value - offset
    return result


def polynomial_scale(polynomial, scalar):
    return {
        monomial: scalar * coefficient
        for monomial, coefficient in polynomial.items()
        if scalar * coefficient
    }


def polynomial_add(*polynomials):
    result = {}
    for polynomial in polynomials:
        for monomial, coefficient in polynomial.items():
            result[monomial] = result.get(monomial, 0) + coefficient
            if result[monomial] == 0:
                del result[monomial]
    return result


def radial_value(a, b, data, module):
    tools, klein, hessian, jacobian, _ = data
    first_coefficient = (
        20 * falling(a, 3)
        + 50 * falling(a, 2) * b
        + 55 * falling(a, 2)
    )
    pieces = []
    if first_coefficient:
        first = tools.multiply(
            module.polynomial_power(klein, a - 2, tools),
            module.polynomial_power(hessian, b, tools),
        )
        pieces.append(polynomial_scale(first, first_coefficient))
    second_coefficient = -80000 * falling(b, 3)
    if second_coefficient:
        second = tools.multiply(
            module.polynomial_power(klein, a + 3, tools),
            module.polynomial_power(hessian, b - 3, tools),
        )
        pieces.append(polynomial_scale(second, second_coefficient))
    radial = polynomial_add(*pieces)
    return tools.multiply(jacobian, radial) if radial else {}


def direct_value(a, b, data, module):
    tools, klein, hessian, _, _ = data
    source = tools.multiply(
        module.polynomial_power(klein, a, tools),
        module.polynomial_power(hessian, b, tools),
    )
    raw = tools.transvectant(source, klein, 3)
    return module.exact_divide(raw, 132) if raw else {}


def multiplication_by_t(data, module):
    tools, klein, hessian, jacobian, generators = data
    rows = {}
    for name, degree, generator in generators:
        target_degree = degree + 30
        candidates = module.candidates_of_degree(
            target_degree,
            klein,
            hessian,
            generators,
            tools,
        )
        solution = module.solve_columns(
            [
                module.coefficient_vector(candidate, target_degree)
                for _, _, _, candidate in candidates
            ],
            module.coefficient_vector(
                tools.multiply(jacobian, generator),
                target_degree,
            ),
        )
        rows[name] = {
            f"{target_name}:F^{f_power}:h^{h_power}": str(coefficient)
            for (target_name, f_power, h_power, _), coefficient in zip(
                candidates, solution
            )
            if coefficient
        }
    return rows


def matrix_multiplication_rows(base_certificate):
    principal = base_certificate["principal_symbol"]
    even = ("g2", "g10", "g18")
    odd = ("g12", "g20", "g28")
    rows = {name: {} for name in even + odd}
    for matrix_name, sources, targets in (
        ("multiplier_matrix_left_to_right", even, odd),
        ("multiplier_matrix_right_to_left", odd, even),
    ):
        matrix = principal[matrix_name]
        for row_index, source in enumerate(sources):
            for column_index, target in enumerate(targets):
                for term in matrix[row_index][column_index]:
                    coefficient = Fraction(term["coefficient"]) / 10
                    key = (
                        f"{target}:F^{term['F_power']}:h^{term['h_power']}"
                    )
                    rows[source][key] = str(coefficient)
    return rows


def certificate():
    module = load_base()
    data = module.build_data()
    grid = [(a, b) for a in range(7) for b in range(7)]
    failures = [
        [a, b]
        for a, b in grid
        if direct_value(a, b, data, module)
        != radial_value(a, b, data, module)
    ]
    assert not failures

    multiplication_rows = multiplication_by_t(data, module)
    base_certificate = json.loads(BASE_CERTIFICATE.read_text(encoding="utf-8"))
    symbol_rows = matrix_multiplication_rows(base_certificate)
    assert multiplication_rows == symbol_rows

    discriminant_h3_f3 = -4 * 5**3 * (-8000)
    discriminant_f8 = -27 * 2**2 * (-8000) ** 2
    assert discriminant_h3_f3 == 4_000_000
    assert discriminant_f8 == -4_000_000 * 1728

    return {
        "schema": "c682-intrinsic-e8-symbol-v1",
        "invariants": {
            "F_degree": 12,
            "h_degree": 20,
            "t_degree": 30,
            "relation": "t^2=1728 F^5-h^3",
            "even_parameter_ring": "R=Q[F,h]",
        },
        "radial_operator": {
            "definition": "R(a)=((a,F)_3)/(132 t)",
            "normal_ordered_formula": (
                "20 F dF^3 + 50 h dF^2 dh - 80000 F^3 dh^3 "
                "+ 55 dF^2"
            ),
            "order": 3,
            "weighted_degree": -24,
            "principal_symbol": (
                "10 p = 20 F xi^3 + 50 h xi^2 eta "
                "- 80000 F^3 eta^3"
            ),
            "exact_grid": {"a": "0..6", "b": "0..6", "checks": len(grid)},
        },
        "intrinsic_symbol": {
            "p": "2 F xi^3 + 5 h xi^2 eta - 8000 F^3 eta^3",
            "interpretation": (
                "one tenth of the principal symbol of the radial third "
                "transvectant after its odd output is divided by t"
            ),
            "discriminant": (
                "4000000 F^3(h^3-1728F^5)=-4000000 F^3 t^2"
            ),
            "weighted_degree": -24,
        },
        "module_symbol": {
            "identity_on_every_covariant_block": "sigma_3(D)=10 p m_t",
            "D": "(.,F)_3/132",
            "m_t": "multiplication by t on the rank-six 3-covariant module",
            "multiplication_rows": multiplication_rows,
        },
        "universal_consequence": {
            "statement": (
                "On every binary-icosahedral covariant module free over "
                "Q[F,h], sigma_3(D)=10 p times multiplication by t."
            ),
            "reason": (
                "The top Leibniz term differentiates only the invariant "
                "coefficient; its odd radial output is 10 t p, leaving "
                "multiplication by t on the covariant generator."
            ),
            "matrix_factorizations": (
                "The finite factors m_t are the McKay-node E8 matrix "
                "factorizations of t^2=1728F^5-h^3."
            ),
        },
        "proof_boundary": [
            "Weighted order at most three leaves exactly the four displayed radial Weyl monomials.",
            "Direct exact transvection fixes their coefficients and verifies 49 monomial inputs.",
            "Exact free-basis decomposition identifies A/10 and B/10 with multiplication by t on all six generators.",
            "The universal all-block statement is a formal principal-symbol consequence of the third-transvectant Leibniz rule.",
            "The result identifies the cubic intrinsically but makes no novelty or priority claim.",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = json.dumps(certificate(), indent=2, sort_keys=True) + "\n"
    if arguments.check:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 intrinsic E8 symbol certificate")
    else:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")


if __name__ == "__main__":
    main()
