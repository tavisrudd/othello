#!/usr/bin/env python3
"""Certify the complete rank-four scheme of the C682 ten-pair pencil."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import math
import subprocess
import tempfile
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
NOTES = REPOSITORY / "notes"
CORE = Path(__file__).with_suffix(".cpp")
OUTPUT = Path(__file__).with_suffix(".json")
DEFORMATION_SCRIPT = NOTES / "2026-07-28-c682-transvectant-deformation-map.py"
DEFORMATION_CERTIFICATE = DEFORMATION_SCRIPT.with_suffix(".json")
PRIME = 11


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


DEFORMATION = load_module("c682_deformation", DEFORMATION_SCRIPT)
MM = DEFORMATION.MM


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def matrix_multiply(left, right):
    return [
        [
            sum(
                left[row][middle] * right[middle][column]
                for middle in range(len(right))
            )
            % PRIME
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def matrix_inverse(matrix):
    size = len(matrix)
    augmented = [
        row[:]
        + [int(row_index == column) for column in range(size)]
        for row_index, row in enumerate(matrix)
    ]
    for column in range(size):
        pivot = next(
            row
            for row in range(column, size)
            if augmented[row][column] % PRIME
        )
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        scale = pow(augmented[column][column], -1, PRIME)
        augmented[column] = [
            scale * value % PRIME for value in augmented[column]
        ]
        for row in range(size):
            if row == column or augmented[row][column] == 0:
                continue
            scale = augmented[row][column]
            augmented[row] = [
                (left - scale * right) % PRIME
                for left, right in zip(augmented[row], augmented[column])
            ]
    return [row[size:] for row in augmented]


def exponent_vectors(total: int, variables: int = 10, prefix=()):
    if variables == 1:
        return [prefix + (total,)]
    return [
        exponent
        for value in range(total, -1, -1)
        for exponent in exponent_vectors(
            total - value, variables - 1, prefix + (value,)
        )
    ]


def evaluate_monomial(point, exponent):
    return math.prod(
        pow(point[index], exponent[index], PRIME)
        for index in range(len(exponent))
    ) % PRIME


def operator_basis():
    divided = json.loads(
        DEFORMATION.DIVIDED_CERTIFICATE.read_text(encoding="utf-8")
    )
    primitive = divided["sym6_primitive_matrix"]
    directions = [
        DEFORMATION.third_matrix(
            [int(index == basis) for index in range(13)]
        )
        for basis in range(13)
    ]
    quotient_coordinates = [
        index
        for index in range(13)
        if index not in DEFORMATION.FROBENIUS_INDICES
    ]
    return [primitive] + [
        [
            [5 * value % PRIME for value in row]
            for row in directions[index]
        ]
        for index in quotient_coordinates
    ]


def run_macaulay_core(basis):
    compiler = [
        "c++",
        "-O3",
        "-std=c++20",
        "-DNDEBUG",
        str(CORE),
    ]
    with tempfile.TemporaryDirectory(prefix="c682-rank-four-") as directory:
        binary = Path(directory) / "rank-four-resolvent"
        subprocess.run(
            compiler + ["-o", str(binary)],
            cwd=REPOSITORY / "rust",
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        serialized = " ".join(
            str(basis[variable][row][column])
            for variable in range(10)
            for row in range(13)
            for column in range(7)
        )
        completed = subprocess.run(
            [str(binary), "--degree6", "--matrices"],
            cwd=REPOSITORY / "rust",
            check=True,
            input=serialized,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
    parsed = {}
    for line in completed.stdout.splitlines():
        key, *values = line.split()
        parsed[key] = [int(value) for value in values]
    assert parsed["quintic_rank"] == [1980]
    assert parsed["sextic_rank"] == [4983]
    assert parsed["quintic_quotient"] == parsed["sextic_quotient"] == [22]
    assert parsed["coordinate_multiplication_ranks"] == [
        22,
        20,
        20,
        20,
        20,
        16,
        20,
        20,
        20,
        20,
    ]
    return parsed


def parameter_point(parameter: int, sheet: int):
    t = parameter % PRIME
    s = sheet % PRIME
    return [
        1,
        t,
        5 * t**2 % PRIME,
        4 * t**3 % PRIME,
        8 * t**4 % PRIME,
        (10 + 9 * t**5 + s) % PRIME,
        (9 * t**6 + 6 * s * t) % PRIME,
        (8 * t**7 + 4 * s * t**2) % PRIME,
        (4 * t**8 + 9 * s * t**3) % PRIME,
        (5 * t**9 + 4 * s * t**4) % PRIME,
    ]


def operator_at(point, basis):
    return [
        [
            sum(
                point[index] * basis[index][row][column]
                for index in range(10)
            )
            % PRIME
            for column in range(7)
        ]
        for row in range(13)
    ]


def tangent_equation_rank(matrix, basis):
    right_kernel = MM.nullspace(matrix, PRIME)
    left_kernel = MM.nullspace(
        [list(column) for column in zip(*matrix)], PRIME
    )
    equations = []
    for left in left_kernel:
        for right in right_kernel:
            equations.append(
                [
                    sum(
                        left[row]
                        * sum(
                            direction[row][column] * right[column]
                            for column in range(7)
                        )
                        for row in range(13)
                    )
                    % PRIME
                    for direction in basis
                ]
            )
    return MM.rank(equations, PRIME)


def action(matrix, point):
    return tuple(
        DEFORMATION.normalize_projective(
            DEFORMATION.matvec(matrix, point, PRIME)
        )
    )


def orbit_partition(points, generators):
    unseen = set(points)
    orbits = []
    while unseen:
        orbit = {min(unseen)}
        frontier = list(orbit)
        while frontier:
            point = frontier.pop()
            for generator in generators:
                image = action(generator, point)
                if image not in orbit:
                    orbit.add(image)
                    frontier.append(image)
        assert orbit <= set(points)
        unseen -= orbit
        orbits.append(sorted(points.index(point) for point in orbit))
    return sorted(orbits, key=lambda orbit: (len(orbit), orbit))


def in_star_sum_subspace(point, intertwiner):
    pair_point = DEFORMATION.solve_coordinates(intertwiner, point)
    star_matrix = [
        [int(vertex in pair) for vertex in range(5)]
        for pair in itertools.combinations(range(5), 2)
    ]
    augmented = [
        star_matrix[row] + [pair_point[row]] for row in range(10)
    ]
    return MM.rank(augmented, PRIME) == 5


def reshape(values, size=22):
    assert len(values) == size * size
    return [
        values[offset : offset + size]
        for offset in range(0, len(values), size)
    ]


def certificate():
    deformation = json.loads(
        DEFORMATION_CERTIFICATE.read_text(encoding="utf-8")
    )
    basis = operator_basis()
    macaulay = run_macaulay_core(basis)
    degree_five_exponents = exponent_vectors(5)
    degree_six_exponents = exponent_vectors(6)
    quintic_standard = macaulay["quintic_standard"]
    sextic_standard = macaulay["sextic_standard"]
    standard_five = [
        degree_five_exponents[index] for index in quintic_standard
    ]
    standard_six = [
        degree_six_exponents[index] for index in sextic_standard
    ]
    points = sorted(
        tuple(parameter_point(parameter, sheet))
        for parameter in range(PRIME)
        for sheet in (1, -1)
    )
    assert len(points) == len(set(points)) == 22
    evaluation_five = [
        [evaluate_monomial(point, exponent) for exponent in standard_five]
        for point in points
    ]
    evaluation_six = [
        [evaluate_monomial(point, exponent) for exponent in standard_six]
        for point in points
    ]
    assert MM.rank(evaluation_five, PRIME) == 22
    assert MM.rank(evaluation_six, PRIME) == 22

    multiplication = [
        reshape(macaulay[f"multiplication_{index}"]) for index in range(10)
    ]
    assert MM.rank(multiplication[0], PRIME) == 22
    for variable in range(10):
        for point_index, point in enumerate(points):
            for source in range(22):
                assert (
                    sum(
                        multiplication[variable][source][target]
                        * evaluation_six[point_index][target]
                        for target in range(22)
                    )
                    - point[variable] * evaluation_five[point_index][source]
                ) % PRIME == 0
    inverse_x0 = matrix_inverse(multiplication[0])
    localized_multiplication = [
        matrix_multiply(matrix, inverse_x0) for matrix in multiplication
    ]
    assert localized_multiplication[0] == [
        [int(row == column) for column in range(22)]
        for row in range(22)
    ]
    assert all(
        matrix_multiply(localized_multiplication[left], localized_multiplication[right])
        == matrix_multiply(
            localized_multiplication[right], localized_multiplication[left]
        )
        for left in range(10)
        for right in range(10)
    )

    intertwiner = deformation["ej_ten_pair_carrier"][
        "intertwiner_pair_to_extended_normal"
    ]
    point_rows = []
    kernel_signatures = set()
    for point in points:
        matrix = operator_at(point, basis)
        kernel = MM.nullspace(matrix, PRIME)
        assert MM.rank(matrix, PRIME) == 4
        assert len(kernel) == 3
        assert DEFORMATION.isotropy_rows(kernel) == [[0, 0, 0]] * 3
        assert tangent_equation_rank(matrix, basis) == 9
        reduced_kernel, _pivots = MM.rref(kernel, PRIME)
        kernel_signature = tuple(
            tuple(row) for row in reduced_kernel if any(row)
        )
        kernel_signatures.add(kernel_signature)
        point_rows.append(
            {
                "extended_normal_line": list(point),
                "parameter_t": point[1],
                "sheet_s": (
                    point[5] - 10 - 9 * point[1] ** 5
                )
                % PRIME,
                "operator_rank": 4,
                "kernel_dimension": 3,
                "fifth_transvectant_isotropic": True,
                "projective_tangent_equation_rank": 9,
                "kernel_rref": [list(row) for row in kernel_signature],
            }
        )
    assert len(kernel_signatures) == 22

    pair_edges = list(itertools.combinations(range(5), 2))
    pair_points = [
        DEFORMATION.solve_coordinates(intertwiner, point) for point in points
    ]
    quadratic_rows = []
    for point, pair_point in zip(points, pair_points):
        total_square = sum(pair_point) ** 2 % PRIME
        diagonal = sum(value**2 for value in pair_point) % PRIME
        adjacent = sum(
            pair_point[left] * pair_point[right]
            for left in range(10)
            for right in range(left + 1, 10)
            if set(pair_edges[left]) & set(pair_edges[right])
        ) % PRIME
        sheet = (point[5] - 10 - 9 * point[1] ** 5) % PRIME
        assert (
            7 * total_square + 9 * diagonal + 10 * adjacent
        ) % PRIME == sheet
        quadratic_rows.append([total_square, diagonal, adjacent])
    assert MM.rank(quadratic_rows, PRIME) == 3

    star_indices = [
        index
        for index, point in enumerate(points)
        if in_star_sum_subspace(point, intertwiner)
    ]
    assert len(star_indices) == 6
    known_points = {
        tuple(
            deformation["kernel_map"][
                "selected_recovered_extended_normal_line"
            ]
        )
    } | {
        tuple(row["extended_normal_line"])
        for row in deformation["ej_rank_drop_clebsch_frame"][
            "conjugate_orbit_rows"
        ]
    }
    assert {points[index] for index in star_indices} == known_points

    generators = [
        row["extended_normal_action"]
        for row in deformation["ej_ten_pair_carrier"]["generators"]
    ]
    orbits = orbit_partition(points, generators)
    assert [len(orbit) for orbit in orbits] == [1, 5, 6, 10]
    assert sorted(star_indices) == sorted(orbits[0] + orbits[1])
    orbit_sheets = [
        {
            (
                points[index][5]
                - 10
                - 9 * points[index][1] ** 5
            )
            % PRIME
            for index in orbit
        }
        for orbit in orbits
    ]
    assert orbit_sheets == [{1}, {10}, {10}, {1}]

    inputs = {
        Path(__file__),
        CORE,
        DEFORMATION_SCRIPT,
        DEFORMATION_CERTIFICATE,
        DEFORMATION.DIVIDED_SCRIPT,
        DEFORMATION.DIVIDED_CERTIFICATE,
    }
    for relative in deformation["inputs"]:
        candidate = REPOSITORY / relative
        if candidate.exists():
            inputs.add(candidate)
    return {
        "schema": "c682-rank-four-resolvent-v1",
        "field": "F_11",
        "operator_pencil": {
            "source": "P(P10)=P(1+V4+V5)",
            "matrix_shape": [13, 7],
            "operator_basis": basis,
            "rank_condition": "all 5-by-5 minors vanish",
            "projective_ambient_dimension": 9,
        },
        "macaulay_certificate": {
            "degree_five_monomials": len(degree_five_exponents),
            "degree_five_minor_span_rank": macaulay["quintic_rank"][0],
            "degree_five_quotient_dimension": 22,
            "degree_six_monomials": len(degree_six_exponents),
            "degree_six_minor_multiple_span_rank": macaulay["sextic_rank"][0],
            "degree_six_quotient_dimension": 22,
            "coordinate_multiplication_ranks_5_to_6": macaulay[
                "coordinate_multiplication_ranks"
            ],
            "bockstein_coordinate_x0_isomorphism": True,
            "quintic_standard_monomial_indices": quintic_standard,
            "sextic_standard_monomial_indices": sextic_standard,
            "multiplication_matrices_degree_5_to_6": multiplication,
            "evaluation_rank_on_22_points_degree_5": 22,
            "evaluation_rank_on_22_points_degree_6": 22,
            "proof_conclusion": (
                "Surjectivity of x0:A_5->A_6 gives "
                "S_d=I_d+x0^(d-5)S_5 for d>=6.  Hence the projective "
                "Hilbert function is at most 22 in every later degree; "
                "the 22 distinct displayed points force equality and "
                "scheme-theoretic exhaustiveness."
            ),
        },
        "explicit_resolvent": {
            "coordinate_order": [
                "x0",
                "x1",
                "x2",
                "x3",
                "x4",
                "x5",
                "x6",
                "x7",
                "x8",
                "x9",
            ],
            "parameter_space": "t in F_11 and s in {+1,-1}",
            "coordinate_formula": [
                "1",
                "t",
                "5*t^2",
                "4*t^3",
                "8*t^4",
                "10+9*t^5+s",
                "9*t^6+6*s*t",
                "8*t^7+4*s*t^2",
                "4*t^8+9*s*t^3",
                "5*t^9+4*s*t^4",
            ],
            "coordinate_algebra": "F_11[t,s]/(t^11-t,s^2-1)",
            "points": point_rows,
            "all_22_points_have_rank_exactly_four": True,
            "all_22_kernels_are_fifth_transvectant_isotropic": True,
            "kernel_map_is_injective_on_the_22_points": True,
            "all_22_points_are_projectively_reduced": True,
        },
        "A5_orbits": {
            "orbit_sizes": [len(orbit) for orbit in orbits],
            "point_index_orbits": orbits,
            "stabilizer_orders": [60 // len(orbit) for orbit in orbits],
            "interpretation": (
                "The complete rank-four scheme is the reduced "
                "1+5+6+10 Platonic resolvent."
            ),
            "generator_actions": generators,
        },
        "quadratic_sheet_separator": {
            "pair_coordinate_order": [list(pair) for pair in pair_edges],
            "formula": (
                "s=7*(sum_e p_e)^2+9*sum_e p_e^2+"
                "10*sum_{e~f}p_e*p_f, where e~f means that the two "
                "K5 edges share a vertex"
            ),
            "centralizer_basis_coefficients": [7, 9, 10],
            "invariant_quadratic_evaluation_rank": 3,
            "sheet_values": [1, 10],
            "sheet_plus_orbit_sizes": [1, 10],
            "sheet_minus_orbit_sizes": [5, 6],
            "idempotents": (
                "e_+=(1+s)/2 and e_-=(1-s)/2 split the rank-four "
                "coordinate algebra into two A5-stable length-11 factors"
            ),
            "conclusion": (
                "The 1+5+6+10 partition is organized by a canonical "
                "A5-invariant quadratic: the plus sheet is 1+10 and "
                "the minus sheet is 5+6."
            ),
        },
        "corrected_1_plus_5_theorem": {
            "linear_subspace": "P(1+V4), the star-sum subspace of P10",
            "point_indices": star_indices,
            "point_count": len(star_indices),
            "equals_previous_radial_plus_A5_over_A4_orbit": True,
            "scheme_theoretically_reduced": True,
            "intertwiner_pair_to_extended_normal": intertwiner,
            "conclusion": (
                "The full P(P10) rank-four scheme has 22 points, not six. "
                "Its canonical P(1+V4) linear section is exactly the "
                "reduced 1+5 Clebsch operator resolvent."
            ),
        },
        "trust_boundary": [
            "The C++ core expands every 5-by-5 minor and performs exact F_11 Macaulay row reduction in degrees five and six.",
            "The Python layer verifies the 22-point parameterization, evaluation bases, multiplication tables, exact ranks, isotropy, tangent ranks, A5 orbits, and the six-point star-sum section.",
            "The result is the marked characteristic-11 operator pencil; no characteristic-zero or integral globalization is claimed.",
            "The literal six-point exhaustiveness claim is disproved and is not promoted to Paper III.",
        ],
        "inputs": {
            str(path.relative_to(REPOSITORY)): {
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in sorted(inputs)
        },
        "toolchain": {
            "python": subprocess.run(
                ["python3", "--version"],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
            ).stdout.strip(),
            "cxx": subprocess.run(
                ["c++", "--version"],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
            ).stdout.splitlines()[0],
            "cxx_flags": ["-O3", "-std=c++20", "-DNDEBUG"],
        },
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    generated = certificate()
    serialized = json.dumps(generated, indent=2, sort_keys=True) + "\n"
    if arguments.check:
        assert OUTPUT.read_text(encoding="utf-8") == serialized
        print(
            "PASS c682 rank-four resolvent: "
            "22 reduced points, A5 orbits 1+5+6+10, "
            "and exact P(1+V4) section 1+5"
        )
        return
    OUTPUT.write_text(serialized, encoding="utf-8")
    print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
