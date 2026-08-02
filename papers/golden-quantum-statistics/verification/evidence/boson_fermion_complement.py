#!/usr/bin/env python3
"""Generate the exact Golden boson--fermion certificate.

Run with the paper's pinned Python environment containing SymPy 1.14.0.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "boson_fermion_complement.json"

BASE_C = sp.Matrix(
    [
        [0, 1, 1, 1, -1, -1],
        [1, 0, -1, -1, -1, -1],
        [1, -1, 0, 1, 1, -1],
        [1, -1, 1, 0, -1, 1],
        [-1, -1, 1, -1, 0, -1],
        [-1, -1, -1, 1, -1, 0],
    ]
)
BASE_TOTAL = (
    ((0, 1), (2, 3), (4, 5)),
    ((0, 2), (1, 4), (3, 5)),
    ((0, 3), (1, 5), (2, 4)),
    ((0, 4), (1, 3), (2, 5)),
    ((0, 5), (1, 2), (3, 4)),
)
BALANCED = tuple(itertools.combinations(range(6), 3))
OCCUPATIONS_3_IN_3 = tuple(
    occupation
    for occupation in itertools.product(range(4), repeat=3)
    if sum(occupation) == 3
)
OCCUPATIONS_3_IN_6 = tuple(
    occupation
    for occupation in itertools.product(range(4), repeat=6)
    if sum(occupation) == 3
)


def permanent(matrix: sp.Matrix) -> sp.Expr:
    assert matrix.rows == matrix.cols
    return sp.simplify(
        sum(
            sp.prod(matrix[i, permutation[i]] for i in range(matrix.rows))
            for permutation in itertools.permutations(range(matrix.rows))
        )
    )


def occupation_probability(matrix: sp.Matrix, occupation: tuple[int, ...]) -> sp.Expr:
    rows = [i for i, count in enumerate(occupation) for _ in range(count)]
    repeated = matrix[rows, :]
    denominator = math.prod(math.factorial(count) for count in occupation)
    return sp.simplify(permanent(repeated) ** 2 / denominator)


def gram_schmidt_projector_basis(sign: int) -> sp.Matrix:
    """The frozen pivot-frame gauge: GS of P_sign e_0,e_1,e_2."""
    sqrt5 = sp.sqrt(5)
    projector = (sp.eye(6) + sign * BASE_C / sqrt5) / 2
    output: list[sp.Matrix] = []
    for column in range(3):
        vector = projector[:, column]
        for previous in output:
            vector = sp.simplify(vector - previous.dot(vector) * previous)
        vector = sp.simplify(vector / sp.sqrt(sp.simplify(vector.dot(vector))))
        output.append(vector)
    return sp.Matrix.hstack(*output)


def parity(permutation: tuple[int, ...]) -> int:
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(6)
        for j in range(i + 1, 6)
    )
    return -1 if inversions % 2 else 1


def total_key(permutation: tuple[int, ...]) -> tuple:
    return tuple(
        sorted(
            tuple(
                sorted(
                    tuple(sorted((permutation[i], permutation[j])))
                    for i, j in matching
                )
            )
            for matching in BASE_TOTAL
        )
    )


def protocol_representatives() -> tuple[tuple[int, ...], ...]:
    representatives: dict[tuple, tuple[int, ...]] = {}
    for permutation in itertools.permutations(range(6)):
        representatives.setdefault(total_key(permutation), permutation)
    assert len(representatives) == 6
    return tuple(representatives[key] for key in sorted(representatives))


def expr_string(value: sp.Expr) -> str:
    return str(sp.radsimp(sp.simplify(value)))


def q5_simplify(value: sp.Expr) -> sp.Expr:
    """Recognize a quantity known independently to lie in Q(sqrt(5))."""
    return sp.nsimplify(sp.N(value, 80), [sp.sqrt(5)], full=True)


def jc_terms(matrix: sp.Matrix) -> tuple[sp.Expr, sp.Expr, sp.Expr, sp.Expr]:
    """The four nonnegative layers in Corollary 1 of Jabbour--Cerf."""
    indices = range(3)
    terms: list[sp.Expr] = []
    for size in range(4):
        total = 0
        for rows in itertools.combinations(indices, size):
            complement_rows = tuple(i for i in indices if i not in rows)
            for columns in itertools.combinations(indices, size):
                complement_columns = tuple(i for i in indices if i not in columns)
                determinant = sp.Integer(1) if size == 0 else matrix.extract(rows, columns).det()
                complementary = (
                    sp.Integer(1)
                    if size == 3
                    else permanent(matrix.extract(complement_rows, complement_columns))
                )
                total += determinant**2 * complementary**2
        terms.append(sp.simplify(total))
    residual = terms[0] - terms[1] + terms[2] - terms[3]
    assert abs(complex(sp.N(residual, 80))) < 1e-70
    return tuple(terms)  # type: ignore[return-value]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def generate() -> dict:
    sqrt5 = sp.sqrt(5)
    q_plus = gram_schmidt_projector_basis(+1)
    q_minus = gram_schmidt_projector_basis(-1)
    assert sp.simplify(q_plus.T * q_plus) == sp.eye(3)
    assert sp.simplify(q_minus.T * q_minus) == sp.eye(3)
    assert sp.simplify(q_minus.T * q_plus) == sp.zeros(3)
    assert sp.simplify(BASE_C * q_plus - sqrt5 * q_plus) == sp.zeros(6, 3)
    assert sp.simplify(BASE_C * q_minus + sqrt5 * q_minus) == sp.zeros(6, 3)

    variables = sp.symbols("x0:6")
    k_matrix = sp.simplify(q_minus.T * sp.diag(*variables) * q_plus)
    boson_permanent = sp.expand(permanent(k_matrix))
    scaled_permanent = sp.Poly(
        sp.expand(100 * sqrt5 * boson_permanent), *variables, extension=sqrt5
    )
    coefficients = []
    for monomial, coefficient in scaled_permanent.terms():
        coefficient = sp.simplify(coefficient)
        assert coefficient.is_Integer
        coefficients.append({"exponents": list(monomial), "coefficient": int(coefficient)})
    assert len(coefficients) == 44

    z_base = sp.expand(
        sum(
            BASE_C[i, j] * BASE_C[j, k] * BASE_C[k, i]
            * variables[i] * variables[j] * variables[k]
            for i, j, k in itertools.combinations(range(6), 3)
        )
    )
    determinant_ratio = sp.simplify(k_matrix.det() * 10 * sqrt5 / z_base)
    assert determinant_ratio in (-1, 1)

    representatives = protocol_representatives()
    balanced_records = []
    jc_layer_spectra: dict[tuple[str, ...], int] = {}
    full_branch_spectra: dict[tuple[str, ...], int] = {}
    full_six_mode_spectra: dict[tuple[str, ...], int] = {}
    probability_vectors = set()
    amplitude_vectors = set()

    for negative_support in BALANCED:
        control = tuple(-1 if i in negative_support else 1 for i in range(6))
        substitutions = dict(zip(variables, control))
        base_k = sp.simplify(k_matrix.subs(substitutions))
        h = sp.simplify(base_k.T * base_k)
        trace1 = q5_simplify(sp.trace(h))
        trace2 = q5_simplify(sp.trace(h * h))
        determinant = q5_simplify(h.det())
        assert trace1 == sp.Rational(9, 5)
        assert trace2 == sp.Rational(33, 25)
        assert determinant == sp.Rational(16, 125)
        trace3 = q5_simplify(sp.trace(h**3))
        h3 = sp.simplify((trace1**3 + 3 * trace1 * trace2 + 2 * trace3) / 6)
        h2 = sp.simplify((trace1**2 + trace2) / 2)
        e2 = sp.simplify((trace1**2 - trace2) / 2)
        s21 = sp.simplify((trace1**3 - trace3) / 3)
        assert h3 == sp.Rational(313, 125)
        assert h2 == sp.Rational(57, 25)
        assert e2 == sp.Rational(24, 25)
        assert s21 == sp.Rational(8, 5)
        assert sp.simplify(h3 - determinant - trace1 * trace2) == 0
        assert sp.simplify(h3 - trace1 * h2 + e2 * trace1 - determinant) == 0
        assert sp.simplify(h3 + 2 * s21 + determinant - trace1**3) == 0

        y_coordinates = []
        z_coordinates = []
        for representative in representatives:
            permuted = tuple(control[representative[i]] for i in range(6))
            protocol_substitution = dict(zip(variables, permuted))
            y_coordinates.append(int(scaled_permanent.as_expr().subs(protocol_substitution)))
            z_value = z_base.subs(protocol_substitution) * parity(representative)
            z_coordinates.append(int(z_value))
        assert all(abs(value) == 8 for value in z_coordinates)
        amplitude_vectors.add(tuple(y_coordinates))
        probability_vector = tuple(sp.Rational(value * value, 50000) for value in y_coordinates)
        probability_vectors.add(probability_vector)

        branch_probabilities = tuple(
            occupation_probability(base_k, occupation)
            for occupation in OCCUPATIONS_3_IN_3
        )
        assert abs(complex(sp.N(sum(branch_probabilities) - permanent(h), 80))) < 1e-70
        branch_key = tuple(sorted(expr_string(value) for value in branch_probabilities))
        full_branch_spectra[branch_key] = full_branch_spectra.get(branch_key, 0) + 1

        full_transfer = sp.Matrix.vstack(q_plus.T, q_minus.T) * sp.diag(*control) * q_plus
        six_mode_probabilities = tuple(
            occupation_probability(full_transfer, occupation)
            for occupation in OCCUPATIONS_3_IN_6
        )
        assert abs(complex(sp.N(sum(six_mode_probabilities) - 1, 80))) < 1e-70
        six_key = tuple(sorted(expr_string(value) for value in six_mode_probabilities))
        full_six_mode_spectra[six_key] = full_six_mode_spectra.get(six_key, 0) + 1

        jc = tuple(q5_simplify(value) for value in jc_terms(base_k))
        jc_key = tuple(expr_string(value) for value in jc)
        jc_layer_spectra[jc_key] = jc_layer_spectra.get(jc_key, 0) + 1

        balanced_records.append(
            {
                "negative_support": list(negative_support),
                "scaled_permanent_coordinates": y_coordinates,
                "collision_free_probabilities": [expr_string(value) for value in probability_vector],
                "oriented_segre_coordinates": z_coordinates,
                "base_protocol_postselected_output_probabilities": [
                    {"occupation": list(occupation), "probability": expr_string(probability)}
                    for occupation, probability in zip(OCCUPATIONS_3_IN_3, branch_probabilities)
                ],
                "base_protocol_postselected_total": expr_string(sum(branch_probabilities)),
                "base_protocol_full_six_mode_output_probabilities": [
                    {"occupation": list(occupation), "probability": expr_string(probability)}
                    for occupation, probability in zip(OCCUPATIONS_3_IN_6, six_mode_probabilities)
                ],
                "jabbour_cerf_layers_m0_to_m3": [expr_string(value) for value in jc],
            }
        )

    assert len(amplitude_vectors) == 20
    assert len(probability_vectors) == 4
    collision_free_patterns: dict[tuple[str, ...], int] = {}
    for vector in probability_vectors:
        key = tuple(sorted(expr_string(value) for value in vector))
        collision_free_patterns[key] = sum(
            tuple(sorted(expr_string(value) for value in candidate)) == key
            for candidate in (
                tuple(sp.Rational(value * value, 50000) for value in record["scaled_permanent_coordinates"])
                for record in balanced_records
            )
        )
    assert sorted(collision_free_patterns.values()) == [8, 12]

    return {
        "schema": "golden-boson-fermion-complement-v1",
        "sympy_version": sp.__version__,
        "port_gauge": {
            "definition": "Gram-Schmidt(P_+ e0,P_+ e1,P_+ e2) and Gram-Schmidt(P_- e0,P_- e1,P_- e2), with positive square roots",
            "q_plus": [[expr_string(q_plus[i, j]) for j in range(3)] for i in range(6)],
            "q_minus": [[expr_string(q_minus[i, j]) for j in range(3)] for i in range(6)],
            "warning": "permanent coordinates and occupation-resolved bosonic probabilities depend on this O(3)xO(3) port gauge",
        },
        "exact_permanent": {
            "formula": "per(K_base(x))=Y(x)/(100 sqrt(5))",
            "scaled_integer_polynomial_terms": coefficients,
            "term_count": len(coefficients),
            "determinant_formula": f"det(K_base(x))={int(determinant_ratio)} Z_base(x)/(10 sqrt(5))",
        },
        "six_protocols": {
            "transport_rule": "Y_T(x)=Y_base(x_{p(0)},...,x_{p(5)}); for odd p the Golden eigenspaces exchange and transposition leaves the permanent unchanged",
            "lexicographic_representatives": [list(permutation) for permutation in representatives],
            "representative_dependence": "changing a representative by the synthematic-total stabilizer rotates internal ports and changes Y_T",
        },
        "balanced_invariant": {
            "squared_singular_values": ["1/5", "4/5", "4/5"],
            "trace_H": "9/5",
            "trace_H_squared": "33/25",
            "fermionic_exterior_cube_probability_e3": "16/125",
            "bosonic_symmetric_cube_probability_sum_h3": "313/125",
            "bosonic_uniform_input_average_h3_over_10": "313/1250",
            "identity": "h3-e3=tr(H) tr(H^2)=297/125",
            "boson_to_fermion_average_ratio": "313/160",
            "degree_two_complete_symmetric_h2": "57/25",
            "degree_two_exterior_e2": "24/25",
            "degree_three_schur_s21": "8/5",
            "trace_level_muir_identity": "h3-e1 h2+e2 h1-e3=0 with layers (313,513,216,16)/125",
            "schur_weyl_identity": "h3+2 s21+e3=tr(H)^3=729/125",
        },
        "balanced_census": {
            "records": balanced_records,
            "calibrated_amplitude_vectors": len(amplitude_vectors),
            "calibrated_probability_vectors": len(probability_vectors),
            "collision_free_probability_multiset_counts": [
                {"sorted_probabilities": list(key), "balanced_masks": count}
                for key, count in sorted(collision_free_patterns.items())
            ],
            "postselected_base_protocol_spectrum_class_counts": sorted(full_branch_spectra.values()),
            "full_six_mode_base_protocol_spectrum_class_counts": sorted(full_six_mode_spectra.values()),
            "jabbour_cerf_layer_class_counts": sorted(jc_layer_spectra.values()),
        },
        "trusted_boundary": {
            "certifies": [
                "the exact pivot-gauge permanent polynomial",
                "all 20 balanced masks for all six transported protocols",
                "all ten postselected V_- occupations and all 56 six-mode occupations for the base protocol",
                "the 3x3 Jabbour-Cerf alternating minor identity at every balanced base-protocol block",
                "the basis-free symmetric/exterior cube trace identity and balanced values",
            ],
            "does_not_certify": [
                "a gauge-independent permanent coordinate",
                "a platform noise threshold",
                "novelty in the literature",
            ],
        },
    }


def render(payload: dict) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = render(generate())
    if args.check:
        if not OUTPUT.exists() or OUTPUT.read_bytes() != rendered:
            raise SystemExit(f"stale certificate: {OUTPUT}")
        print(f"ok {OUTPUT.name} {sha256(OUTPUT)}")
        return
    OUTPUT.write_bytes(rendered)
    print(f"wrote {OUTPUT.name} {len(rendered)} bytes")


if __name__ == "__main__":
    main()
