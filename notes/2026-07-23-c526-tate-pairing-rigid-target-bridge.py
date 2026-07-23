#!/usr/bin/env python3
"""Exact C526 inventory of natural Tate-plane pairings."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
C406_PATH = ROOT / "notes/2026-07-20-c406-matching-module.py"
C406_INPUT = ROOT / "notes/2026-07-20-c406-matching-orbit-scout.json"
C412_INPUT = ROOT / "notes/2026-07-20-c412-relative-cubic-depth-plane.json"
C433_INPUT = ROOT / "notes/2026-07-23-c433-modular-depth-fourier-exact-sequence.json"
OUTPUT = ROOT / "notes/2026-07-23-c526-tate-pairing-rigid-target-bridge.json"
P = 11


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


C406 = load_module("c406_for_c526", C406_PATH)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def transpose(matrix):
    return [list(column) for column in zip(*matrix)]


def matmul(left, right):
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right))) % P
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def matvec(matrix, vector):
    return [sum(a * b for a, b in zip(row, vector)) % P for row in matrix]


def determinant2(matrix):
    return (matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]) % P


def inverse2(matrix):
    scale = pow(determinant2(matrix), -1, P)
    return [
        [scale * matrix[1][1] % P, -scale * matrix[0][1] % P],
        [-scale * matrix[1][0] % P, scale * matrix[0][0] % P],
    ]


def normalize_line(vector):
    pivot = next(value for value in vector if value % P)
    scale = pow(pivot, -1, P)
    return [scale * value % P for value in vector]


def square_class(value):
    value %= P
    if not value:
        return "zero"
    return "square" if pow(value, (P - 1) // 2, P) == 1 else "nonsquare"


def isotropy_type(gram):
    if not determinant2(gram):
        return "degenerate"
    isotropic = any(
        (x or y)
        and (
            gram[0][0] * x * x
            + 2 * gram[0][1] * x * y
            + gram[1][1] * y * y
        )
        % P
        == 0
        for x in range(P)
        for y in range(P)
    )
    return "split/isotropic" if isotropic else "anisotropic"


def symmetric_matrix(coordinates, dimension):
    pairs = list(itertools.combinations_with_replacement(range(dimension), 2))
    matrix = [[0] * dimension for _ in range(dimension)]
    for value, (left, right) in zip(coordinates, pairs):
        matrix[left][right] = value
        matrix[right][left] = value
    return matrix


def reconstruct():
    scout = json.loads(C406_INPUT.read_text())
    record = next(item for item in scout["types"] if item["type"] == "H3")
    conic, parameters = C406.C399.conic_parameterization(P)
    del conic
    full_group, psl_group = C406.full_pgl(P, parameters)
    base_matching = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted({C406.matching_image(element, base_matching) for element in full_group})
    orbit_index = {matching: index for index, matching in enumerate(orbit)}
    base_product = C406.matching_product(base_matching, tuple(parameters), P)
    quotient_vectors = []
    for matching in orbit:
        product = C406.matching_product(matching, tuple(parameters), P)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % P
            for exponent in set(product) | set(base_product)
        }
        quotient_vectors.append(C406.quotient_by_conic(difference, 4, P))
    image_matrix = transpose(quotient_vectors)
    _, coordinate_pivots = C406.rref(transpose(image_matrix), P)
    reduced_vectors = [[vector[index] for index in coordinate_pivots] for vector in quotient_vectors]
    _, point_basis_indices = C406.rref(transpose(reduced_vectors), P)
    point_basis_matrix = transpose([reduced_vectors[index] for index in point_basis_indices])
    point_basis_inverse = C406.matrix_inverse(point_basis_matrix, P)
    base_index = orbit_index[base_matching]

    def induced_action(element):
        action = C406.action_permutation(element, orbit, orbit_index)
        moved_base = action[base_index]
        target_basis = transpose(
            [
                [
                    (reduced_vectors[action[index]][coordinate] - reduced_vectors[moved_base][coordinate])
                    % P
                    for coordinate in range(len(coordinate_pivots))
                ]
                for index in point_basis_indices
            ]
        )
        return matmul(target_basis, point_basis_inverse)

    psl_generators = C406.permutation_generators(psl_group)
    outer_element = min(full_group - psl_group)
    w_actions = [induced_action(element) for element in psl_generators + [outer_element]]
    cube_actions = [C406.symmetric_cube_action(action, P) for action in w_actions]
    equations = []
    for index, action in enumerate(cube_actions):
        eigenvalue = 1 if index < len(psl_generators) else P - 1
        equations.extend(
            [
                [
                    (action[row][column] - (eigenvalue if row == column else 0)) % P
                    for column in range(len(action))
                ]
                for row in range(len(action))
            ]
        )
    relative_basis = C406.nullspace(equations, P)

    pairs = list(itertools.combinations_with_replacement(range(len(w_actions[0])), 2))
    form_equations = []
    for action in w_actions:
        for left, right in pairs:
            row = []
            for first, second in pairs:
                coefficient = action[first][left] * action[second][right]
                if first != second:
                    coefficient += action[second][left] * action[first][right]
                if (first, second) == (left, right):
                    coefficient -= 1
                row.append(coefficient % P)
            form_equations.append(row)
    form_coordinates = C406.nullspace(form_equations, P)
    assert len(form_coordinates) == 2
    form_basis = [symmetric_matrix(coordinates, len(w_actions[0])) for coordinates in form_coordinates]
    return relative_basis, cube_actions, form_basis


def mixed_symmetric_cube_form(form_triple, cube_basis):
    """Polarized symmetric-cube pairing, averaged over assignments of the three forms."""
    form_orders = list(itertools.permutations(range(3)))
    inverse_six = pow(6, -1, P)

    def stabilizer(indices):
        return 6 // len(set(itertools.permutations(indices)))

    result = [[0] * len(cube_basis) for _ in cube_basis]
    for row, left in enumerate(cube_basis):
        for column, right in enumerate(cube_basis):
            value = 0
            for form_order in form_orders:
                for right_order in itertools.permutations(right):
                    product = 1
                    for slot in range(3):
                        product *= form_triple[form_order[slot]][left[slot]][right_order[slot]]
                    value += product
            # C406 uses orbit-sum symmetric tensors, not polynomial monomials.
            scale = pow(stabilizer(left) * stabilizer(right), -1, P)
            result[row][column] = value * inverse_six * scale % P
    return result


def quotient_gram(relative_basis, ambient_gram):
    return matmul(matmul(relative_basis, ambient_gram), transpose(relative_basis))


def descend_to_contraction_plane(relative_gram):
    contraction = [[8, 1, 0], [0, 8, 1]]
    section = [[7, 6], [0, 7], [0, 0]]
    assert matmul(contraction, section) == [[1, 0], [0, 1]]
    kernel = [1, 3, 9]
    assert matvec(contraction, kernel) == [0, 0]
    assert matvec(relative_gram, kernel) == [0, 0, 0]
    return matmul(matmul(transpose(section), relative_gram), section)


def flag_gram(gram, flag):
    return [
        [
            sum(flag[i][a] * gram[a][b] * flag[j][b] for a in range(2) for b in range(2)) % P
            for j in range(2)
        ]
        for i in range(2)
    ]


def projective_pair_invariant(gram):
    if not gram[0][0] or not gram[1][1]:
        return None
    return gram[0][1] ** 2 * pow(gram[0][0] * gram[1][1], -1, P) % P


def record_for_gram(label, relative_gram, source_gram, ambient_w_form_rank=None):
    source_flag = [[1, 9], [1, 3]]
    flagged = flag_gram(source_gram, source_flag)
    record = {
        "label": label,
        "relative_rank": C406.rank(relative_gram, P),
        "relative_radical": C406.nullspace(relative_gram, P),
        "tate_plane_gram_in_contraction_coordinates": source_gram,
        "rank": C406.rank(source_gram, P),
        "determinant": determinant2(source_gram),
        "determinant_square_class": square_class(determinant2(source_gram)),
        "type": isotropy_type(source_gram),
        "ordered_rank_one_rank_nine_flag_gram": flagged,
        "ordered_flag_pair_invariant": projective_pair_invariant(flagged),
    }
    if ambient_w_form_rank is not None:
        record["ambient_W_form_rank"] = ambient_w_form_rank
    return record


def build_certificate():
    relative_basis, cube_actions, form_basis = reconstruct()
    c412 = json.loads(C412_INPUT.read_text())
    c412_contraction = c412["source"]["depth_correlation_candidates"]["rank_one_form_contraction"]
    assert c412_contraction["matrix_from_relative_basis_to_invariant_form_pencil"] == [
        [8, 1, 0],
        [0, 8, 1],
    ]
    assert c412_contraction["rank_one_form_projective_parameters"] == [1, 7]
    rank_nine_parameters = next(
        item["form_projective_parameters"]
        for item in c412["source"]["depth_correlation_candidates"][
            "bilinear_form_pencil_source_to_depth_compositions"
        ]
        if item["form_rank"] == 9
    )
    assert rank_nine_parameters == [1, 6]
    cube_basis = list(itertools.combinations_with_replacement(range(10), 3))
    rank_one_form = [
        [(form_basis[0][i][j] + 7 * form_basis[1][i][j]) % P for j in range(10)]
        for i in range(10)
    ]
    rank_nine_form = [
        [(form_basis[0][i][j] + 6 * form_basis[1][i][j]) % P for j in range(10)]
        for i in range(10)
    ]
    assert C406.rank(rank_one_form, P) == 1
    assert C406.rank(rank_nine_form, P) == 9
    canonical_forms = [rank_one_form, rank_nine_form]
    mixed_labels = ["Q1^3", "Q1^2*Q9", "Q1*Q9^2", "Q9^3"]
    mixed_indices = [(0, 0, 0), (0, 0, 1), (0, 1, 1), (1, 1, 1)]
    records = []
    mixed_relative_grams = []
    for label, indices in zip(mixed_labels, mixed_indices):
        ambient_gram = mixed_symmetric_cube_form(
            tuple(canonical_forms[index] for index in indices), cube_basis
        )
        relative_gram = quotient_gram(relative_basis, ambient_gram)
        mixed_relative_grams.append(relative_gram)
        source_gram = descend_to_contraction_plane(relative_gram)
        records.append(record_for_gram(label, relative_gram, source_gram))

    # Verify the four polarizations span every pure pairing from the invariant-form pencil.
    pure_records = []
    for parameters in [(1, value) for value in range(P)] + [(0, 1)]:
        form = [
            [
                sum(parameters[k] * form_basis[k][i][j] for k in range(2)) % P
                for j in range(10)
            ]
            for i in range(10)
        ]
        ambient_gram = mixed_symmetric_cube_form((form, form, form), cube_basis)
        relative_gram = quotient_gram(relative_basis, ambient_gram)
        canonical_parameters = [
            (parameters[1] - 6 * parameters[0]) % P,
            (7 * parameters[0] - parameters[1]) % P,
        ]
        left, right = canonical_parameters
        expected = [
            [
                (
                    left**3 * mixed_relative_grams[0][i][j]
                    + 3 * left**2 * right * mixed_relative_grams[1][i][j]
                    + 3 * left * right**2 * mixed_relative_grams[2][i][j]
                    + right**3 * mixed_relative_grams[3][i][j]
                )
                % P
                for j in range(3)
            ]
            for i in range(3)
        ]
        assert relative_gram == expected
        source_gram = descend_to_contraction_plane(relative_gram)
        pure_record = record_for_gram(
            list(parameters), relative_gram, source_gram, C406.rank(form, P)
        )
        assert pure_record["ordered_rank_one_rank_nine_flag_gram"] == [
            [9 * left**3 % P, 0],
            [0, left * right**2 % P],
        ]
        pure_records.append(pure_record)

    mixed_plane_vectors = [
        [gram[0][0], gram[0][1], gram[1][1]]
        for gram in (record["tate_plane_gram_in_contraction_coordinates"] for record in records)
    ]
    mixed_pairing_span_dimension = C406.rank(mixed_plane_vectors, P)
    assert mixed_pairing_span_dimension == 2
    assert all(record["ordered_rank_one_rank_nine_flag_gram"][0][1] == 0 for record in records)
    assert sum(record["rank"] == 2 for record in pure_records) == 10
    assert all(
        record["determinant_square_class"] == "square" and record["type"] == "anisotropic"
        for record in pure_records
        if record["rank"] == 2
    )
    source_reflection = [[9, 4], [2, 2]]
    assert matmul(source_reflection, source_reflection) == [[1, 0], [0, 1]]
    source_flag = [[1, 9], [1, 3]]
    assert normalize_line(matvec(source_reflection, source_flag[0])) == normalize_line(source_flag[0])
    assert normalize_line(matvec(source_reflection, source_flag[1])) == normalize_line(source_flag[1])
    assert all(
        matmul(
            transpose(source_reflection),
            matmul(record["tate_plane_gram_in_contraction_coordinates"], source_reflection),
        )
        == record["tate_plane_gram_in_contraction_coordinates"]
        for record in records
    )

    c433 = json.loads(C433_INPUT.read_text())
    target_gram = c433["canonical_placement"]["depth_plane_gram_in_C412_basis_v2_v3"]
    target_flag = [[1, 10], [1, 9]]
    target_vector_flag_gram = flag_gram(target_gram, target_flag)
    target_dual_flag_gram = flag_gram(inverse2(target_gram), target_flag)
    assert target_vector_flag_gram[0][1] == 2
    assert target_dual_flag_gram[0][1] == 5
    target = {
        "depth_plane_gram": target_gram,
        "rank": C406.rank(target_gram, P),
        "determinant": determinant2(target_gram),
        "determinant_square_class": square_class(determinant2(target_gram)),
        "type": isotropy_type(target_gram),
        "ordered_doubled_residual_flag": target_flag,
        "vector_convention_flag_gram": target_vector_flag_gram,
        "vector_convention_pair_invariant": projective_pair_invariant(target_vector_flag_gram),
        "dual_convention_flag_gram": target_dual_flag_gram,
        "dual_convention_pair_invariant": projective_pair_invariant(target_dual_flag_gram),
    }

    return {
        "schema": "c526-tate-pairing-rigid-target-bridge-v1",
        "field": P,
        "inputs": {
            path.name: {"bytes": path.stat().st_size, "sha256": sha256(path)}
            for path in (C406_PATH, C406_INPUT, C412_INPUT, C433_INPUT)
        },
        "source_pairing_inventory": {
            "construction": "four polarized Sym^3 monomials in the canonical rank-one and rank-nine members Q1,Q9 of the invariant bilinear-form pencil on W",
            "canonical_W_form_parameters_in_C412_basis": {
                "Q1": [1, 7],
                "Q9": [1, 6],
            },
            "mixed_polarization_records": records,
            "mixed_pairing_span_dimension_on_tate_plane": mixed_pairing_span_dimension,
            "mixed_pairing_span_characterization": "the full two-dimensional space of symmetric Tate-plane forms making the ordered rank-one/rank-nine lines orthogonal",
            "closed_formula_in_ordered_flag_basis": {
                "general_polarized_pairing": "alpha*Q1^3 + beta*Q1*Q9^2 gives diag(9*alpha,4*beta); the other two canonical monomials vanish",
                "pure_pairing_for_Q_equals_cQ1_plus_dQ9": "diag(9*c^3,c*d^2)",
                "pure_pairing_is_perfect_exactly_when": "c*d != 0",
                "perfect_pure_projective_members": 10,
                "perfect_pure_pairings_are_all": "anisotropic with square determinant",
            },
            "canonical_nondegenerate_pairing_exists": False,
            "canonical_nondegeneracy_obstruction": "the four scale-free monomial lines are individually zero or rank one; combining the two surviving rank-one forms requires a relative normalization of Q1 and Q9",
            "pairing_independent_flag_reflection": {
                "matrix_in_contraction_coordinates": source_reflection,
                "square_is_identity": True,
                "fixes_both_ordered_flag_lines_projectively": True,
                "preserves_every_induced_pairing": True,
                "perfect_source_metric_plus_flag_projective_stabilizer_contains": "C2",
            },
            "pure_pencil_records": pure_records,
        },
        "target": target,
        "tate_duality_and_adjointness": {
            "invariant_coinvariant_evaluation": "B(r,[m])=B(r,m) is well-defined for invariant r",
            "tate_descent": "im(N)=ker(pi) is radical for B(r,pi(s)), so evaluation descends to R/im(N) times ker(N)",
            "pulled_same_plane_pairing": "under pi:R/im(N)->ker(N), Tate evaluation is exactly the displayed symmetric quotient Gram form",
            "projection_adjoint_behavior": "B(r,pi(s))=B(pi(r),s)=B(r,s)",
            "norm_adjoint_behavior": "B(Nx,y)=B(x,Ny); hence the norm-induced coinvariant form is symmetric",
        },
        "naturality_boundary": {
            "outer_covariance": "the twisted outer character occurs twice in a bilinear pairing, so every polarized form is PGL_2(11)-invariant",
            "a5_restriction": "11 does not divide |A5|=60, so restriction is semisimple and supplies no normalization or extra pairing choice",
        },
        "comparison": {
            "source_ordered_flag_is_orthogonal_for_every_induced_pairing": True,
            "target_ordered_flag_is_nonorthogonal_in_vector_convention": True,
            "target_ordered_flag_is_nonorthogonal_in_dual_convention": True,
            "target_metric_plus_ordered_flag_projective_stabilizer": "trivial: nonzero norms force each line eigenvalue to have the same square, and nonzero cross-pairing forces their ratio to be 1",
            "source_metric_plus_ordered_flag_projective_stabilizer_contains_C2": True,
            "projective_isometry_exists": False,
            "exact_obstruction": "orthogonality of the ordered flag is preserved by isometry and independent rescaling of its two lines, but the source cross-pairing is 0 while the target cross-pairing is 2 (or 5 in the dual convention)",
        },
        "verdict": "NEGATIVE: no natural nondegenerate source pairing, and even every noncanonical perfect pairing induced by the full polarized ambient pencil has the wrong ordered-flag orbit",
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT.name}")
    elif not OUTPUT.exists() or OUTPUT.read_text() != rendered:
        raise SystemExit(f"stale certificate: run {Path(__file__).name} --write")
    else:
        print("C526 Tate-pairing inventory certificate OK")


if __name__ == "__main__":
    main()
