#!/usr/bin/env python3
"""Certify the classical incidence traces of the C682 D5/S3 branches."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
NOTES = REPOSITORY / "notes"
RANK_SCRIPT = NOTES / "2026-07-28-c682-rank-four-resolvent.py"
RANK_CERTIFICATE = RANK_SCRIPT.with_suffix(".json")
DEFORMATION_CERTIFICATE = (
    NOTES / "2026-07-28-c682-transvectant-deformation-map.json"
)
OUTPUT = Path(__file__).with_suffix(".json")
PRIME = 11


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


RANK = load_module("c682_rank_four", RANK_SCRIPT)
DEFORMATION = RANK.DEFORMATION
MM = DEFORMATION.MM


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def normalize_projective(vector):
    first = next(value for value in vector if value % PRIME)
    inverse = pow(first, -1, PRIME)
    return tuple(inverse * value % PRIME for value in vector)


def canonical_q_coordinates(vector, frame):
    equations = [
        [frame[column][row] for column in range(5)] + [vector[row]]
        for row in range(7)
    ]
    equations.append([1, 1, 1, 1, 1, 0])
    reduced, pivots = MM.rref(equations, PRIME)
    assert pivots[:5] == [0, 1, 2, 3, 4]
    solution = [0] * 5
    for row, pivot in zip(reduced, pivots):
        if pivot < 5:
            solution[pivot] = row[-1] % PRIME
    assert all(
        (
            sum(solution[index] * frame[index][row] for index in range(5))
            - vector[row]
        )
        % PRIME
        == 0
        for row in range(7)
    )
    assert sum(solution) % PRIME == 0
    return solution


def cubic_restriction(line_coordinates):
    left, right = line_coordinates
    return [
        sum(value**3 for value in left) % PRIME,
        3 * sum(left[index] ** 2 * right[index] for index in range(5))
        % PRIME,
        3 * sum(left[index] * right[index] ** 2 for index in range(5))
        % PRIME,
        sum(value**3 for value in right) % PRIME,
    ]


def kernel(point, basis):
    matrix = RANK.operator_at(point["extended_normal_line"], basis)
    assert MM.rank(matrix, PRIME) == 4
    result = MM.nullspace(matrix, PRIME)
    assert len(result) == 3
    return result


def certificate():
    rank_data = json.loads(RANK_CERTIFICATE.read_text(encoding="utf-8"))
    deformation_data = json.loads(
        DEFORMATION_CERTIFICATE.read_text(encoding="utf-8")
    )
    points = rank_data["explicit_resolvent"]["points"]
    orbit_indices = rank_data["A5_orbits"]["point_index_orbits"]
    orbit_by_size = {len(orbit): orbit for orbit in orbit_indices}
    assert sorted(orbit_by_size) == [1, 5, 6, 10]

    frame = deformation_data["ej_rank_drop_clebsch_frame"][
        "clebsch_frame_with_first_vector_xyz_and_sum_zero"
    ]
    assert len(frame) == 5
    assert all(
        sum(frame[index][coordinate] for index in range(5)) % PRIME == 0
        for coordinate in range(7)
    )

    basis = RANK.operator_basis()
    radial_index = orbit_by_size[1][0]
    radial_kernel = kernel(points[radial_index], basis)

    branch_rows = {}
    branch_intersections = {}
    for size, label in ((6, "D5"), (10, "S3")):
        rows = []
        intersections = []
        for point_index in orbit_by_size[size]:
            branch_kernel = kernel(points[point_index], basis)
            common = DEFORMATION.apolar_annihilator(
                radial_kernel + branch_kernel
            )
            intersections.append(common)
            coordinates = [
                canonical_q_coordinates(vector, frame) for vector in common
            ]
            rows.append(
                {
                    "point_index": point_index,
                    "parameter_t": points[point_index]["parameter_t"],
                    "sheet_s": points[point_index]["sheet_s"],
                    "common_annihilator_dimension": len(common),
                    "common_annihilator_rref": MM.rref(common, PRIME)[0][
                        : len(common)
                    ],
                    "canonical_q_coordinate_rref": MM.rref(
                        coordinates, PRIME
                    )[0][: len(coordinates)],
                }
            )
        branch_rows[label] = rows
        branch_intersections[label] = intersections

    assert all(
        row["common_annihilator_dimension"] == 2
        for row in branch_rows["D5"]
    )
    assert all(
        cubic_restriction(row["canonical_q_coordinate_rref"])
        == [0, 0, 0, 0]
        for row in branch_rows["D5"]
    )
    assert all(
        MM.rank(left + right, PRIME) == 4
        for left, right in itertools.combinations(
            branch_intersections["D5"], 2
        )
    )

    pair_sum_lookup = {}
    pair_difference_lines = set()
    for left, right in itertools.combinations(range(5), 2):
        pair_sum = [
            (frame[left][coordinate] + frame[right][coordinate]) % PRIME
            for coordinate in range(7)
        ]
        pair_difference = [
            (frame[left][coordinate] - frame[right][coordinate]) % PRIME
            for coordinate in range(7)
        ]
        pair_sum_lookup[normalize_projective(pair_sum)] = [left + 1, right + 1]
        pair_difference_lines.add(normalize_projective(pair_difference))
    assert len(pair_sum_lookup) == len(pair_difference_lines) == 10

    observed_s3 = {}
    for row, common in zip(
        branch_rows["S3"], branch_intersections["S3"], strict=True
    ):
        assert len(common) == 1
        line = normalize_projective(common[0])
        assert line in pair_sum_lookup
        assert line not in pair_difference_lines
        q_coordinates = row["canonical_q_coordinate_rref"][0]
        assert sum(value**3 for value in q_coordinates) % PRIME != 0
        pair = pair_sum_lookup[line]
        row["pair_sum_label"] = pair
        row["clebsch_cubic_value_nonzero"] = True
        observed_s3[tuple(pair)] = line
    assert set(observed_s3) == set(itertools.combinations(range(1, 6), 2))

    return {
        "schema": "c682-incidence-moduli-v1",
        "field": "F_11",
        "inputs": {
            path.name: {
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in (
                RANK_SCRIPT,
                RANK_CERTIFICATE,
                RANK.DEFORMATION_SCRIPT,
                DEFORMATION_CERTIFICATE,
            )
        },
        "fixed_icosahedron": {
            "radial_point_index": radial_index,
            "clebsch_frame_relation": "q1+q2+q3+q4+q5=0",
        },
        "D5_common_axis_branches": {
            "orbit_size": 6,
            "common_annihilator_vector_dimension": 2,
            "all_six_projective_lines_lie_on_clebsch_cubic": True,
            "all_six_projective_lines_are_pairwise_skew": True,
            "rows": branch_rows["D5"],
        },
        "S3_opposite_face_branches": {
            "orbit_size": 10,
            "common_annihilator_vector_dimension": 1,
            "common_cubics": "the ten pair sums q_alpha+q_beta",
            "distinct_from_eckardt_differences_q_alpha-q_beta": True,
            "all_common_cubics_lie_off_clebsch_cubic": True,
            "rows": branch_rows["S3"],
        },
        "interpretation": {
            "D5": (
                "six common-fivefold-axis pencils, the exceptional "
                "Schlaefli six on the Clebsch cubic surface"
            ),
            "S3": (
                "ten opposite-face-axis mates over the centered edge "
                "points q_alpha+q_beta of the Sylvester pentahedron"
            ),
        },
        "trust_boundary": (
            "Exact finite-field operator kernels, apolar intersections, "
            "Clebsch-frame coordinates, cubic restrictions, and incidence "
            "counts. The characteristic-zero moduli interpretation uses "
            "Hitchin's open-orbit and common-axis theorems."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--check",
        action="store_true",
        help="compare the regenerated certificate with the tracked JSON",
    )
    arguments = parser.parse_args()
    rendered = json.dumps(certificate(), indent=2, sort_keys=True) + "\n"
    if arguments.check:
        assert OUTPUT.read_text(encoding="utf-8") == rendered
        print("C682 incidence-moduli certificate: PASS")
    else:
        OUTPUT.write_text(rendered, encoding="utf-8")
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
