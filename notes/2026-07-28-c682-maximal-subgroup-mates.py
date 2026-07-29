#!/usr/bin/env python3
"""Certify the finite shadow of the C682 normalizer-mate correspondence."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
NOTES = REPOSITORY / "notes"
DEFORMATION_SCRIPT = NOTES / "2026-07-28-c682-transvectant-deformation-map.py"
DEFORMATION_CERTIFICATE = DEFORMATION_SCRIPT.with_suffix(".json")
RESOLVENT_CERTIFICATE = NOTES / "2026-07-28-c682-rank-four-resolvent.json"
INCIDENCE_CERTIFICATE = NOTES / "2026-07-28-c682-incidence-moduli.json"
OUTPUT = Path(__file__).with_suffix(".json")
PRIME = 11


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


DEFORMATION = load_module("c682_deformation_for_mates", DEFORMATION_SCRIPT)
DIVIDED = DEFORMATION.DIVIDED
MM = DEFORMATION.MM


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_pgl(entries: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    entries = tuple(value % PRIME for value in entries)
    pivot = next(value for value in entries if value)
    inverse = pow(pivot, -1, PRIME)
    return tuple(value * inverse % PRIME for value in entries)


def determinant(entries: tuple[int, int, int, int]) -> int:
    a, b, c, d = entries
    return (a * d - b * c) % PRIME


def multiply(
    left: tuple[int, int, int, int],
    right: tuple[int, int, int, int],
) -> tuple[int, int, int, int]:
    a, b, c, d = left
    e, f, g, h = right
    return canonical_pgl(
        (
            a * e + b * g,
            a * f + b * h,
            c * e + d * g,
            c * f + d * h,
        )
    )


def inverse(entries: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    a, b, c, d = entries
    return canonical_pgl((d, -b, -c, a))


def conjugate(
    element: tuple[int, int, int, int],
    member: tuple[int, int, int, int],
) -> tuple[int, int, int, int]:
    return multiply(multiply(element, member), inverse(element))


def enumerate_pgl2() -> tuple[tuple[int, int, int, int], ...]:
    elements = {
        canonical_pgl(entries)
        for entries in itertools.product(range(PRIME), repeat=4)
        if any(entries) and determinant(entries)
    }
    assert len(elements) == PRIME * (PRIME**2 - 1)
    return tuple(sorted(elements))


def permutation_cyclic_subgroup(element):
    identity = tuple(range(len(element)))
    subgroup = {identity}
    power = identity
    while True:
        power = MM.compose(element, power)
        if power == identity:
            break
        subgroup.add(power)
    return frozenset(subgroup)


def permutation_normalizer(group, subgroup):
    return frozenset(
        element
        for element in group
        if frozenset(
            MM.compose(MM.compose(element, member), MM.inverse(element))
            for member in subgroup
        )
        == subgroup
    )


def matrix_normalizer(ambient, subgroup):
    return frozenset(
        element
        for element in ambient
        if frozenset(conjugate(element, member) for member in subgroup) == subgroup
    )


def matvec(matrix, vector):
    return [
        sum(matrix[row][column] * vector[column] for column in range(len(vector)))
        % PRIME
        for row in range(len(matrix))
    ]


def same_row_space(left, right):
    return (
        MM.rank(left, PRIME)
        == MM.rank(right, PRIME)
        == MM.rank(left + right, PRIME)
        == 3
    )


def transform_kernel(kernel, element):
    action = DIVIDED.symmetric_action_mod(element, 6, 3, PRIME)
    return [matvec(action, row) for row in kernel]


def build_certificate():
    deformation = json.loads(DEFORMATION_CERTIFICATE.read_text())
    resolvent = json.loads(RESOLVENT_CERTIFICATE.read_text())
    incidence = json.loads(INCIDENCE_CERTIFICATE.read_text())

    workspace = DIVIDED.C651.h3_workspace()
    parent_group = frozenset(workspace["parent_group"])
    assert len(parent_group) == 60
    conic_parameters = tuple(MM.COXETER.conic_parameterization(PRIME)[1])
    permutation_to_matrix = {
        element: canonical_pgl(
            tuple(DIVIDED.recover_pgl_matrix(element, conic_parameters))
        )
        for element in parent_group
    }
    matrix_group = frozenset(permutation_to_matrix.values())
    assert len(matrix_group) == 60

    a4_subgroups, _five_action = DIVIDED.C651.natural_five_action(parent_group)
    representative_a4 = min(a4_subgroups, key=lambda subgroup: tuple(sorted(subgroup)))

    order_five = min(
        element
        for element in parent_group
        if DIVIDED.C651.element_order(element) == 5
    )
    representative_d5 = permutation_normalizer(
        parent_group, permutation_cyclic_subgroup(order_five)
    )
    assert len(representative_d5) == 10

    order_three = min(
        element
        for element in parent_group
        if DIVIDED.C651.element_order(element) == 3
    )
    representative_s3 = permutation_normalizer(
        parent_group, permutation_cyclic_subgroup(order_three)
    )
    assert len(representative_s3) == 6

    subgroup_rows = (
        ("A4", representative_a4, 5, 24),
        ("D5", representative_d5, 6, 20),
        ("S3", representative_s3, 10, 12),
    )

    all_pgl = enumerate_pgl2()
    points = resolvent["explicit_resolvent"]["points"]
    orbits = resolvent["A5_orbits"]["point_index_orbits"]
    orbit_by_size = {len(orbit): orbit for orbit in orbits}
    radial_index = orbit_by_size[1][0]
    radial_kernel = points[radial_index]["kernel_rref"]
    assert all(
        same_row_space(radial_kernel, transform_kernel(radial_kernel, element))
        for element in matrix_group
    )

    rows = []
    for label, subgroup_permutations, index, expected_normalizer_order in subgroup_rows:
        subgroup = frozenset(
            permutation_to_matrix[element] for element in subgroup_permutations
        )
        assert len(subgroup) == 60 // index
        assert matrix_normalizer(matrix_group, subgroup) == subgroup

        ambient_normalizer = matrix_normalizer(all_pgl, subgroup)
        assert len(ambient_normalizer) == expected_normalizer_order
        assert subgroup < ambient_normalizer
        nontrivial_coset = sorted(ambient_normalizer - subgroup)
        tau = nontrivial_coset[0]
        assert multiply(tau, tau) in subgroup

        mate_kernel = transform_kernel(radial_kernel, tau)
        matching_indices = [
            point_index
            for point_index, point in enumerate(points)
            if same_row_space(mate_kernel, point["kernel_rref"])
        ]
        assert len(matching_indices) == 1
        mate_index = matching_indices[0]
        assert mate_index in orbit_by_size[index]

        stabilizer = frozenset(
            element
            for element in matrix_group
            if same_row_space(
                points[mate_index]["kernel_rref"],
                transform_kernel(points[mate_index]["kernel_rref"], element),
            )
        )
        assert stabilizer == subgroup
        assert same_row_space(
            radial_kernel,
            transform_kernel(points[mate_index]["kernel_rref"], tau),
        )
        assert all(
            same_row_space(
                mate_kernel,
                transform_kernel(radial_kernel, other_tau),
            )
            for other_tau in nontrivial_coset
        )

        rows.append(
            {
                "type": label,
                "subgroup_order": len(subgroup),
                "index": index,
                "ambient_normalizer_order": len(ambient_normalizer),
                "normalizer_quotient_order": len(ambient_normalizer) // len(subgroup),
                "subgroup_matrices": [list(element) for element in sorted(subgroup)],
                "normalizer_coset_representative": list(tau),
                "normalizer_coset_size": len(nontrivial_coset),
                "mate_point_index": mate_index,
                "mate_parameter": {
                    "t": points[mate_index]["parameter_t"],
                    "s": points[mate_index]["sheet_s"],
                },
                "mate_kernel_rref": points[mate_index]["kernel_rref"],
                "mate_orbit_indices": orbit_by_size[index],
                "stabilizer_equals_selected_subgroup": True,
                "coset_choice_independent": True,
                "normalizer_involution_swaps_base_and_mate": True,
            }
        )

    incidence_rows = {
        row["type"]: row
        for row in rows
        if row["type"] in {"D5", "S3"}
    }
    assert len(incidence["D5_common_axis_branches"]["rows"]) == 6
    assert len(incidence["S3_opposite_face_branches"]["rows"]) == 10
    assert incidence_rows["D5"]["mate_point_index"] in orbit_by_size[6]
    assert incidence_rows["S3"]["mate_point_index"] in orbit_by_size[10]

    d5_indices = orbit_by_size[6]
    s3_indices = orbit_by_size[10]
    incident_pairs = []
    intersection_dimensions = []
    for d5_index in d5_indices:
        row = []
        for s3_index in s3_indices:
            dimension = 6 - MM.rank(
                points[d5_index]["kernel_rref"]
                + points[s3_index]["kernel_rref"],
                PRIME,
            )
            assert dimension in (0, 1)
            row.append(dimension)
            if dimension == 1:
                incident_pairs.append([d5_index, s3_index])
        intersection_dimensions.append(row)
    assert [sum(row) for row in intersection_dimensions] == [5] * 6
    assert [
        sum(intersection_dimensions[row][column] for row in range(6))
        for column in range(10)
    ] == [3] * 10
    assert len(incident_pairs) == 30

    inputs = (
        DEFORMATION_SCRIPT,
        DEFORMATION_CERTIFICATE,
        RESOLVENT_CERTIFICATE,
        INCIDENCE_CERTIFICATE,
    )
    return {
        "schema": "c682-maximal-subgroup-mates-v1",
        "field": "F_11",
        "groups": {
            "ambient": "PGL_2(F_11)",
            "ambient_order": len(all_pgl),
            "icosahedral_subgroup": "A5",
            "icosahedral_subgroup_order": len(matrix_group),
            "base_rank_four_point_index": radial_index,
            "base_kernel_rref": radial_kernel,
        },
        "normalizer_mates": rows,
        "intrinsic_D5_S3_incidence": {
            "D5_points": [
                {
                    "point_index": index,
                    "kernel_rref": points[index]["kernel_rref"],
                }
                for index in d5_indices
            ],
            "S3_points": [
                {
                    "point_index": index,
                    "kernel_rref": points[index]["kernel_rref"],
                }
                for index in s3_indices
            ],
            "kernel_intersection_dimension_matrix": intersection_dimensions,
            "incident_point_index_pairs": incident_pairs,
            "D5_row_degrees": [5] * 6,
            "S3_column_degrees": [3] * 10,
            "criterion": (
                "A D5 mate and an S3 mate are incident exactly when their "
                "three-dimensional kernel planes meet in dimension one; "
                "equivalently their apolar four-planes meet in dimension two."
            ),
        },
        "checked_statement": (
            "For H=A4,D5,S3, the unique nonidentity coset in "
            "N_PGL2(F11)(H)/H sends the A5-fixed kernel to the existing "
            "rank-four point in the A5/H orbit, independently of the coset "
            "representative, and swaps the two H-fixed kernels. The intrinsic "
            "kernel-intersection rank condition recovers the (6_5,10_3) "
            "D5-S3 incidence."
        ),
        "characteristic_zero_boundary": (
            "The certificate checks the F_11 specialization only. The "
            "characteristic-zero correspondence and the normalizer "
            "classifications are proved group-theoretically in the report."
        ),
        "inputs": {
            path.relative_to(REPOSITORY).as_posix(): {
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in inputs
        },
        "toolchain": {"python": "3.x standard library"},
    }


def canonical_json(payload) -> str:
    return json.dumps(payload, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = canonical_json(build_certificate())
    if arguments.check:
        assert OUTPUT.read_text() == rendered
        print("maximal-subgroup mate certificate: ok")
    else:
        OUTPUT.write_text(rendered)
        print(OUTPUT)


if __name__ == "__main__":
    main()
