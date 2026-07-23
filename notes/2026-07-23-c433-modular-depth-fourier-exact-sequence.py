#!/usr/bin/env python3
"""Generate/check the C433 modular depth/Fourier exact-sequence certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
from pathlib import Path

P = 11
ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-23-c433-modular-depth-fourier-exact-sequence.json"
INPUTS = {
    "c378": ROOT / "2026-07-19-c378-clebsch-common-duality.json",
    "c411": ROOT / "2026-07-20-c411-double-coset-hecke.json",
    "c412": ROOT / "2026-07-20-c412-relative-cubic-depth-plane.json",
    "c430": ROOT / "2026-07-20-c430-conceptual-balanced-half-rigidity.json",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def transpose(a: list[list[int]]) -> list[list[int]]:
    return [list(row) for row in zip(*a)]


def matmul(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) % P for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def rref(a: list[list[int]]) -> tuple[list[list[int]], list[int]]:
    out = [[x % P for x in row] for row in a]
    row = 0
    pivots: list[int] = []
    for col in range(len(out[0]) if out else 0):
        pivot = next((i for i in range(row, len(out)) if out[i][col]), None)
        if pivot is None:
            continue
        out[row], out[pivot] = out[pivot], out[row]
        inv = pow(out[row][col], -1, P)
        out[row] = [(inv * x) % P for x in out[row]]
        for i in range(len(out)):
            if i != row and out[i][col]:
                scale = out[i][col]
                out[i] = [(x - scale * y) % P for x, y in zip(out[i], out[row])]
        pivots.append(col)
        row += 1
    return out, pivots


def rank(a: list[list[int]]) -> int:
    return len(rref(a)[1])


def column_basis(a: list[list[int]]) -> list[list[int]]:
    _, pivots = rref(a)
    return [[a[i][j] % P for i in range(len(a))] for j in pivots]


def nullspace(a: list[list[int]]) -> list[list[int]]:
    rr, pivots = rref(a)
    free = [j for j in range(len(a[0])) if j not in pivots]
    basis = []
    for j in free:
        v = [0] * len(a[0])
        v[j] = 1
        for i, pivot in enumerate(pivots):
            v[pivot] = (-rr[i][j]) % P
        basis.append(v)
    return basis


def inverse(a: list[list[int]]) -> list[list[int]]:
    n = len(a)
    aug = [
        [x % P for x in a[i]] + [int(i == j) for j in range(n)]
        for i in range(n)
    ]
    row = 0
    for col in range(n):
        pivot = next(i for i in range(row, n) if aug[i][col])
        aug[row], aug[pivot] = aug[pivot], aug[row]
        inv = pow(aug[row][col], -1, P)
        aug[row] = [(inv * x) % P for x in aug[row]]
        for i in range(n):
            if i != row and aug[i][col]:
                scale = aug[i][col]
                aug[i] = [(x - scale * y) % P for x, y in zip(aug[i], aug[row])]
        row += 1
    return [row[n:] for row in aug]


def canonical_lines(vectors: list[list[int]]) -> list[list[int]]:
    normalized = []
    for vector in vectors:
        first = next(x for x in vector if x % P)
        inv = pow(first % P, -1, P)
        normalized.append([(inv * x) % P for x in vector])
    return sorted(normalized)


def commutant_equations(operators: list[list[list[int]]]) -> list[list[int]]:
    equations = []
    n = len(operators[0])
    for operator in operators:
        for i in range(n):
            for j in range(n):
                row = [0] * (n * n)
                for k in range(n):
                    row[i * n + k] = (row[i * n + k] + operator[k][j]) % P
                    row[k * n + j] = (row[k * n + j] - operator[i][k]) % P
                equations.append(row)
    return equations


def weighted_gram(
    left: list[list[int]], right: list[list[int]], weights: list[int]
) -> list[list[int]]:
    return [
        [
            sum(left[k][i] * weights[k] * right[k][j] for k in range(len(weights))) % P
            for j in range(len(right[0]))
        ]
        for i in range(len(left[0]))
    ]


def normalize_ray(vector: list[int]) -> list[int]:
    first = next(x for x in vector if x % P)
    inv = pow(first % P, -1, P)
    return [(inv * x) % P for x in vector]


def generate() -> dict:
    data = {name: json.loads(path.read_text()) for name, path in INPUTS.items()}
    assert data["c378"]["field"] == P
    fourier = data["c378"]["odd_fourier_matrix"]
    assert all(x % P == 0 for row in fourier for x in row)
    divided = [[(x // P) % P for x in row] for row in fourier]

    profiles = data["c411"]["depth_map"]["positive_profiles_in_weight_order"]
    sizes = [1, 4, 6]
    depth = [
        [(sizes[j] * profiles[j][i]) % P for j in range(3)]
        for i in range(4)
    ]
    fourier_depth = matmul(divided, depth)

    fourier_image = column_basis(divided)
    fourier_kernel = nullspace(divided)
    depth_image = column_basis(depth)
    joined = transpose(depth_image + fourier_image)

    assert rank(divided) == 2
    assert matmul(divided, divided) == [[0] * 4 for _ in range(4)]
    assert rank(transpose(fourier_image + fourier_kernel)) == 2
    assert rank(depth) == 2
    assert canonical_lines(nullspace(depth)) == [[1, 1, 1]]
    assert rank(joined) == 4
    assert rank(fourier_depth) == 2
    assert canonical_lines(nullspace(fourier_depth)) == [[1, 1, 1]]
    assert data["c412"]["target"]["profile_plane_dimension"] == 2
    h3 = next(case for case in data["c430"]["cases"] if case["type"] == "H3")
    assert h3["socle_identification"]["a4_fixed_depth_socle_coordinates"] == [1, 1, 1]

    depth_basis_matrix = transpose(depth_image)
    fourier_on_depth_basis = matmul(divided, depth_basis_matrix)
    adapted_basis = [
        depth_basis_matrix[i] + fourier_on_depth_basis[i]
        for i in range(4)
    ]
    contracting_in_adapted_basis = [
        [0, 0, 1, 0],
        [0, 0, 0, 1],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
    ]
    homotopy = matmul(
        matmul(adapted_basis, contracting_in_adapted_basis),
        inverse(adapted_basis),
    )
    identity = [[int(i == j) for j in range(4)] for i in range(4)]
    assert matmul(homotopy, homotopy) == [[0] * 4 for _ in range(4)]
    assert [
        [(x + y) % P for x, y in zip(left, right)]
        for left, right in zip(matmul(divided, homotopy), matmul(homotopy, divided))
    ] == identity
    depth_projector = matmul(homotopy, divided)
    radical_projector = matmul(divided, homotopy)
    grading = [
        [(x - y) % P for x, y in zip(left, right)]
        for left, right in zip(depth_projector, radical_projector)
    ]
    zero = [[0] * 4 for _ in range(4)]
    assert matmul(depth_projector, depth_projector) == depth_projector
    assert matmul(radical_projector, radical_projector) == radical_projector
    assert matmul(depth_projector, radical_projector) == zero
    assert matmul(radical_projector, depth_projector) == zero
    assert rank(depth_projector) == rank(radical_projector) == 2
    assert rank([[x for row in matrix for x in row] for matrix in
                 [depth_projector, homotopy, divided, radical_projector]]) == 4
    assert matmul(grading, grading) == identity
    assert [
        [(x + y) % P for x, y in zip(left, right)]
        for left, right in zip(matmul(grading, divided), matmul(divided, grading))
    ] == zero
    assert [
        [(x + y) % P for x, y in zip(left, right)]
        for left, right in zip(matmul(grading, homotopy), matmul(homotopy, grading))
    ] == zero
    commutant_kernel = nullspace(commutant_equations([divided, homotopy]))
    assert len(commutant_kernel) == 4
    commutant_basis = [
        [vector[4 * i:4 * i + 4] for i in range(4)]
        for vector in commutant_kernel
    ]
    valencies = data["c378"]["common_refinement_valencies"]
    odd_pairs = data["c378"]["J_odd_relation_pairs"]
    odd_valencies = [valencies[a] for a, b in odd_pairs]
    assert all(valencies[a] == valencies[b] for a, b in odd_pairs)
    common = math.gcd(*odd_valencies)
    metric = [value // common for value in odd_valencies]
    metric_adjoint = [
        [pow(metric[i], -1, P) * divided[j][i] * metric[j] % P for j in range(4)]
        for i in range(4)
    ]
    assert metric_adjoint == divided
    target_basis = transpose(
        [[x % P for x in profiles[1]], [x % P for x in profiles[2]]]
    )
    target_gram = weighted_gram(target_basis, target_basis, metric)
    radical_basis_matrix = transpose(fourier_image)
    radical_gram = weighted_gram(radical_basis_matrix, radical_basis_matrix, metric)
    assert rank(target_gram) == 2
    assert radical_gram == [[0, 0], [0, 0]]

    isometries = []
    for coefficients in itertools.product(range(P), repeat=4):
        matrix = [
            [
                sum(coefficients[t] * commutant_basis[t][i][j] for t in range(4)) % P
                for j in range(4)
            ]
            for i in range(4)
        ]
        gram_image = [
            [
                sum(matrix[k][i] * metric[k] * matrix[k][j] for k in range(4)) % P
                for j in range(4)
            ]
            for i in range(4)
        ]
        if gram_image == [[metric[i] if i == j else 0 for j in range(4)] for i in range(4)]:
            isometries.append({"coefficients": list(coefficients), "matrix": matrix})
    assert len(isometries) == 4
    nonscalar = next(
        item["matrix"]
        for item in isometries
        if item["matrix"] not in [identity, [[(-x) % P for x in row] for row in identity]]
    )

    def target_coordinates(vector: list[int]) -> list[int]:
        return next(
            [x, y]
            for x in range(P)
            for y in range(P)
            if all(
                (target_basis[i][0] * x + target_basis[i][1] * y - vector[i]) % P == 0
                for i in range(4)
            )
        )

    target_action_columns = []
    for j in range(2):
        image = [
            sum(nonscalar[i][k] * target_basis[k][j] for k in range(4)) % P
            for i in range(4)
        ]
        target_action_columns.append(target_coordinates(image))
    target_action = transpose(target_action_columns)
    target_dual_action = transpose(inverse(target_action))
    doubled_line = data["c412"]["target"]["hessian_doubled_line"]
    residual_line = data["c412"]["target"]["residual_simple_line"]

    def dual_image(line: list[int]) -> list[int]:
        return normalize_ray(
            [sum(target_dual_action[i][j] * line[j] for j in range(2)) % P for i in range(2)]
        )

    doubled_image = dual_image(doubled_line)
    residual_image = dual_image(residual_line)
    assert doubled_image == normalize_ray(doubled_line)
    assert residual_image != normalize_ray(residual_line)

    return {
        "schema": "c433-modular-depth-fourier-exact-sequence-v1",
        "field": P,
        "inputs": {
            name: {"file": path.name, "bytes": path.stat().st_size, "sha256": sha256(path)}
            for name, path in INPUTS.items()
        },
        "oriented_relation_pairs": data["c378"]["J_odd_relation_pairs"],
        "divided_fourier_mod_11": divided,
        "divided_fourier_rank": rank(divided),
        "divided_fourier_square_is_zero": True,
        "fourier_image_basis": fourier_image,
        "fourier_kernel_basis": fourier_kernel,
        "fourier_image_equals_kernel": True,
        "positive_orbit_sizes": sizes,
        "positive_profiles_integral": profiles,
        "weighted_depth_matrix_mod_11": depth,
        "depth_rank": rank(depth),
        "depth_kernel_basis": nullspace(depth),
        "depth_image_basis": depth_image,
        "depth_image_intersection_fourier_kernel_dimension": 0,
        "depth_image_plus_fourier_kernel_rank": rank(joined),
        "fourier_after_depth_matrix": fourier_depth,
        "fourier_after_depth_rank": rank(fourier_depth),
        "fourier_after_depth_kernel_basis": nullspace(fourier_depth),
        "exact_sequences": [
            "0 -> <(1,1,1)> -> U_odd ->^D P_depth -> 0",
            "0 -> <(1,1,1)> -> U_odd ->^(Fbar D) L_F -> 0",
            "0 -> L_F -> O_odd ->^Fbar L_F -> 0",
        ],
        "canonical_placement": {
            "O_odd_equals_P_depth_direct_sum_L_F": True,
            "Fbar_restricts_to_isomorphism_P_depth_to_L_F": True,
            "literal_sequence_D_then_Fbar_is_not_exact_at_O_odd": True,
            "contracting_homotopy_mod_11": homotopy,
            "contracting_homotopy_square_is_zero": True,
            "Fbar_h_plus_h_Fbar_is_identity": True,
            "depth_projector_h_Fbar": depth_projector,
            "fourier_radical_projector_Fbar_h": radical_projector,
            "internal_grading_involution": grading,
            "grading_square_is_identity": True,
            "grading_anticommutes_with_Fbar_and_h": True,
            "generated_algebra": "matrix units {hF,h,F,Fh} give Mat_2(F_11), acting with multiplicity 2",
            "joint_commutant_dimension": len(commutant_basis),
            "joint_commutant_basis": commutant_basis,
            "residual_ambiguity": "GL_2 on the multiplicity space; Fbar and h alone do not select a binary basis or the C412 cubic flag",
            "canonical_valency_metric_diagonal": metric,
            "Fbar_is_self_adjoint_for_valency_metric": True,
            "fourier_radical_is_lagrangian": True,
            "depth_plane_gram_in_C412_basis_v2_v3": target_gram,
            "depth_plane_is_nondegenerate": True,
            "commutant_valency_isometry_group_order": len(isometries),
            "commutant_valency_isometries": isometries,
            "projective_commutant_valency_isometry_group_order": 2,
            "nontrivial_projective_isometry_on_C412_target": target_action,
            "doubled_line_image_under_nontrivial_projective_isometry": doubled_image,
            "residual_line_image_under_nontrivial_projective_isometry": residual_image,
            "ordered_C412_cubic_flag_stabilizer_in_isometry_group": "scalar {+I,-I}; projectively trivial",
        },
        "a5_restriction_boundary": {
            "group_order": 60,
            "component_degrees": [5, 6],
            "characteristic_divides_group_order": False,
            "characteristic_divides_component_degree": [False, False],
            "conclusion": "semisimple Mackey interface; the socle extension is ambient PSL2(11), not A5 incidence degeneration",
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    rendered = json.dumps(generate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
    else:
        if OUTPUT.read_text() != rendered:
            raise SystemExit("tracked certificate differs from regenerated output")
    print("C433 certificate OK")


if __name__ == "__main__":
    main()
