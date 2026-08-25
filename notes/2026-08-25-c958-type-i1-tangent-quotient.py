#!/usr/bin/env python3
"""Certify ground Cox coordinates and split triangularity for C958."""

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[1]
INPUTS = {
    "split_section": (
        ROOT / "notes/2026-08-24-c958-generic-split-parametrization.json",
        "06f4ad8e57fcbfec0ddb5cd16b9ad683bfd499bf13fa8f7adc8c79d07f627e21",
    ),
    "descent_action": (
        ROOT / "notes/2026-08-24-c958-type-i1-descent-action.json",
        "8755c5cf2d3acce3c670558ea3bee26fcad0691301a2e40231b41cf40e87ee25",
    ),
    "cox_descent": (
        ROOT / "notes/2026-08-25-c958-type-i1-cox-descent-cocycle.json",
        "c7057b2471d76873e1cf358d7044241e64da76ae8e0bb44ae1c8c51d191accd7",
    ),
    "full_coboundary": (
        ROOT / "notes/2026-08-25-c958-type-i1-full-coboundary.json",
        "2dfbac5ca93ffe8257f30ddc4380a416e538362820cc243ba8a25644fdddc654",
    ),
}
GENERATOR = ROOT / "notes/2026-08-24-c958-generic-split-parametrization.py"
FULL_GENERATOR = ROOT / "notes/2026-08-25-c958-type-i1-full-coboundary.py"


def load_module(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def simplify(value):
    return sp.factor(sp.cancel(value))


def substitute(value, variable, image):
    return simplify(value.subs(variable, image, simultaneous=True))


def build():
    loaded = {}
    for name, (path, expected) in INPUTS.items():
        raw = path.read_bytes()
        assert hashlib.sha256(raw).hexdigest() == expected
        loaded[name] = json.loads(raw)

    generic = load_module(GENERATOR, "c958_split")
    full = load_module(FULL_GENERATOR, "c958_full")
    source = generic.load_source()
    lattice = source.type_i3_lattice_data()
    cox_names = lattice["cox_names"]
    z = full.z

    action_data = loaded["descent_action"]
    cocycle_data = loaded["cox_descent"]
    coordinate_actions = action_data["type_i1_generator_coordinate_actions"]
    field_images = [
        sp.sympify(cocycle_data["mobius_actions"][name], locals=vars(full))
        for name in ("sigma", "tau", "iota")
    ]
    projective_point = [
        sp.sympify(value, locals=vars(full))
        for value in cocycle_data["ground_point_marked_plane"]
    ]
    affine_point = (
        simplify(projective_point[0] / projective_point[2]),
        simplify(projective_point[1] / projective_point[2]),
        sp.Integer(1),
    )
    ground_lift_by_name = full.cox_forms(z, affine_point)
    ground_lift = sp.Matrix([ground_lift_by_name[name] for name in cox_names])

    # delta_g(x)_i=c_g[i] g(x_{p_g[i]}).
    generators = []
    for action, field_image in zip(coordinate_actions, field_images):
        inverse_action = {image: source_name for source_name, image in action.items()}
        permutation = tuple(cox_names.index(inverse_action[name]) for name in cox_names)
        coefficients = []
        for row, name in enumerate(cox_names):
            conjugate = substitute(ground_lift_by_name[inverse_action[name]], z, field_image)
            normalized = simplify(conjugate / ground_lift_by_name[name])
            coefficients.append(simplify(1 / normalized))
            assert simplify(coefficients[-1] * conjugate - ground_lift[row]) == 0
        generators.append((field_image, permutation, tuple(coefficients)))

    identity = (z, tuple(range(16)), tuple(sp.Integer(1) for _ in range(16)))

    def compose(left, right):
        left_field, left_permutation, left_coefficients = left
        right_field, right_permutation, right_coefficients = right
        return (
            substitute(right_field, z, left_field),
            tuple(right_permutation[left_permutation[row]] for row in range(16)),
            tuple(
                simplify(
                    left_coefficients[row]
                    * substitute(right_coefficients[left_permutation[row]], z, left_field)
                )
                for row in range(16)
            ),
        )

    elements = {sp.sstr(z): identity}
    queue = [identity]
    while queue:
        current = queue.pop(0)
        for generator_element in generators:
            product = compose(current, generator_element)
            key = sp.sstr(product[0])
            if key not in elements:
                elements[key] = product
                queue.append(product)
    assert len(elements) == 12

    theta_ranks = []
    for power in range(12):
        trial_basis = sp.zeros(16, 16)
        for field_image, permutation, coefficients in elements.values():
            conjugate_theta = substitute(z**power, z, field_image)
            for row in range(16):
                trial_basis[row, permutation[row]] += coefficients[row] * conjugate_theta
        theta_ranks.append(trial_basis.subs(z, 2).applyfunc(sp.cancel).rank())
    theta_power = next(power for power, rank in enumerate(theta_ranks) if rank == 16)
    descent_basis = sp.zeros(16, 16)
    for field_image, permutation, coefficients in elements.values():
        conjugate_theta = substitute(z**theta_power, z, field_image)
        for row in range(16):
            descent_basis[row, permutation[row]] += coefficients[row] * conjugate_theta
    specialized_basis = descent_basis.subs(z, 2).applyfunc(sp.cancel)
    specialized_determinant = sp.factor(specialized_basis.det())
    assert specialized_determinant != 0

    invariant_specializations = []
    for field_image, permutation, coefficients in generators:
        transformed = sp.zeros(16, 16)
        for row in range(16):
            for column in range(16):
                transformed[row, column] = (
                    coefficients[row]
                    * descent_basis[permutation[row], column].subs(z, field_image, simultaneous=True)
                ).subs(z, 2)
        invariant_specializations.append(
            all(
                sp.cancel(transformed[row, column] - specialized_basis[row, column]) == 0
                for row in range(16)
                for column in range(16)
            )
        )
    assert all(invariant_specializations)

    symbols, coordinates, _, _, _, _ = source.cox_data(cox_names)
    a, b, z1, z2, z3 = symbols
    by_name = dict(zip(cox_names, coordinates))
    e1, e2, e3, e4, e5 = sp.symbols("e1 e2 e3 e4 e5")
    values = {
        by_name["E1"]: e1,
        by_name["E2"]: e2,
        by_name["E3"]: e3,
        by_name["E4"]: e4,
        by_name["E5"]: e5,
        by_name["L12"]: z3 / (e1 * e2),
        by_name["L13"]: z2 / (e1 * e3),
        by_name["L14"]: (z2 - z3) / (e1 * e4),
        by_name["L15"]: (b * z2 - a * z3) / (e1 * e5),
        by_name["L23"]: z1 / (e2 * e3),
        by_name["L24"]: (z1 - z3) / (e2 * e4),
        by_name["L25"]: (b * z1 - z3) / (e2 * e5),
        by_name["L34"]: (z1 - z2) / (e3 * e4),
        by_name["L35"]: (a * z1 - z2) / (e3 * e5),
        by_name["L45"]: ((b - a) * z1 + (1 - b) * z2 + (a - 1) * z3) / (e4 * e5),
        by_name["Q"]: (
            b * (1 - a) * z1 * z2
            + a * (b - 1) * z1 * z3
            + (a - b) * z2 * z3
        ) / (e1 * e2 * e3 * e4 * e5),
    }
    slice_rows = [
        [sp.sympify(entry, locals={"a": a, "b": b}) for entry in row]
        for row in loaded["split_section"]["slice_hyperplane_coefficients"]
    ]
    slice_equations = []
    for row in slice_rows:
        expression = sum(row[index] * values[coordinate] for index, coordinate in enumerate(coordinates))
        numerator = sp.together(expression.subs(e3, 1)).as_numer_denom()[0]
        polynomial = sp.Poly(numerator, z1, z2, z3)
        assert polynomial.total_degree() == 1
        slice_equations.append(numerator)
    coefficient_matrix, _ = sp.linear_eq_to_matrix(slice_equations, (z1, z2, z3))
    triangular_witness = {a: 2, b: 3, e1: 2, e2: 3, e4: 5, e5: 7}
    specialized_coefficient_matrix = coefficient_matrix.subs(triangular_witness)
    triangular_determinant = sp.factor(specialized_coefficient_matrix.det())
    assert triangular_determinant != 0

    determinant_text = sp.sstr(specialized_determinant)
    return {
        "schema": "c958-type-i1-tangent-quotient-infrastructure-v1",
        "input_sha256": {name: expected for name, (_, expected) in INPUTS.items()},
        "strict_cox_descent": {
            "group_order": len(elements),
            "coordinate_orbit_sizes": [12, 4],
            "ground_lift_marked_plane": [sp.sstr(value) for value in affine_point],
            "all_three_generators_fix_ground_lift": True,
        },
        "ground_coordinate_basis": {
            "formula": f"H[row,p_g(row)]+=c_g[row]*g(z^{theta_power}), summed over all g",
            "theta": f"z^{theta_power}",
            "theta_power_ranks_0_through_11": theta_ranks,
            "specialization": "z=2",
            "rank": specialized_basis.rank(),
            "matrix_at_specialization": [
                [sp.sstr(specialized_basis[row, column]) for column in range(16)]
                for row in range(16)
            ],
            "determinant": determinant_text,
            "determinant_sha256": hashlib.sha256(determinant_text.encode()).hexdigest(),
            "generator_invariance_at_specialization": invariant_specializations,
            "symbolic_invariance_reason": "left multiplication permutes the twelve orbit-trace summands",
        },
        "split_slice_inverse": {
            "projective_gauge": "E3=1",
            "free_parameters": ["E1", "E2", "E4", "E5"],
            "solved_parameters": ["z1", "z2", "z3"],
            "formula": "z=adj(M(E))*b(E)/det(M(E))",
            "linearity_degrees": [1, 1, 1],
            "nonzero_witness": {"a": 2, "b": 3, "E1": 2, "E2": 3, "E4": 5, "E5": 7},
            "coefficient_determinant_at_witness": sp.sstr(triangular_determinant),
            "coefficient_matrix_at_witness": [
                [sp.sstr(specialized_coefficient_matrix[row, column]) for column in range(3)]
                for row in range(3)
            ],
        },
        "certified": [
            "the normalized type-I1 Cox descent datum generates twelve semilinear actions",
            "the orbit-trace matrix is a ground coordinate basis on a dense open",
            "the three split tangent-section equations are linear in the marked-plane coordinates",
            "Cramer's rule recovers those three coordinates from four exceptional parameters",
        ],
        "not_certified": [
            "the inverse from five ground tangent coordinates to the four exceptional parameters",
            "both composites of a ground-field map Z/T3 to P4",
            "the final cubic-product maps or the type-I3 analogue",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", type=Path)
    mode.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    payload = json.dumps(build(), indent=2, sort_keys=True) + "\n"
    if arguments.write:
        arguments.write.write_text(payload)
    else:
        assert arguments.check.read_text() == payload


if __name__ == "__main__":
    main()
