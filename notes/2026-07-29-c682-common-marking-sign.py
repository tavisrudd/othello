#!/usr/bin/env python3
"""Fix the C682 common-marking sign between the golden and mod-11 designs."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
NOTES = REPOSITORY / "notes"
GOLD_SCRIPT = NOTES / "2026-07-29-c682-d5-s3-kernel-incidence.py"
GOLD_CERTIFICATE = GOLD_SCRIPT.with_suffix(".json")
MATES_SCRIPT = NOTES / "2026-07-28-c682-maximal-subgroup-mates.py"
MATES_CERTIFICATE = MATES_SCRIPT.with_suffix(".json")
RESOLVENT_CERTIFICATE = NOTES / "2026-07-28-c682-rank-four-resolvent.json"
DEFORMATION_SCRIPT = NOTES / "2026-07-28-c682-transvectant-deformation-map.py"
DEFORMATION_CERTIFICATE = DEFORMATION_SCRIPT.with_suffix(".json")
OUTPUT = Path(__file__).with_suffix(".json")
PRIME = 11


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


GOLD = load_module("c682_gold_for_common_marking", GOLD_SCRIPT)
MATES = load_module("c682_mates_for_common_marking", MATES_SCRIPT)
DIVIDED = MATES.DIVIDED
MM = MATES.MM


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def characteristic_zero_marking():
    zeta5 = GOLD.ZETA**6
    order_five = [[zeta5**2, GOLD.ZERO], [GOLD.ZERO, GOLD.ONE]]
    u = zeta5 - zeta5**4
    v = zeta5**2 - zeta5**3
    involution = [[v, u], [u, -v]]
    order_three = GOLD.matrix_product(order_five, involution)
    group = GOLD.generate_group([order_five, involution])
    return group, order_five, involution, order_three


def finite_marking():
    workspace = DIVIDED.C651.h3_workspace()
    parent_group = frozenset(workspace["parent_group"])
    order_five = min(
        element
        for element in parent_group
        if DIVIDED.C651.element_order(element) == 5
    )
    involution = min(
        element
        for element in parent_group
        if DIVIDED.C651.element_order(element) == 2
        and DIVIDED.C651.element_order(MM.compose(order_five, element)) == 3
    )
    conic_parameters = tuple(MM.COXETER.conic_parameterization(PRIME)[1])
    permutation_to_matrix = {
        element: MATES.canonical_pgl(
            tuple(DIVIDED.recover_pgl_matrix(element, conic_parameters))
        )
        for element in parent_group
    }
    return parent_group, order_five, involution, permutation_to_matrix


def simultaneous_homomorphism(
    characteristic_generators,
    finite_generators,
):
    identity_characteristic = GOLD.canonical_matrix(
        [[GOLD.ONE, GOLD.ZERO], [GOLD.ZERO, GOLD.ONE]]
    )
    identity_finite = tuple(range(len(finite_generators[0])))
    mapping = {identity_characteristic: identity_finite}
    queue = [identity_characteristic]
    for current in queue:
        for characteristic_generator, finite_generator in zip(
            characteristic_generators, finite_generators
        ):
            target = GOLD.canonical_matrix(
                GOLD.matrix_product(current, characteristic_generator)
            )
            image = MM.compose(mapping[current], finite_generator)
            if target in mapping:
                assert mapping[target] == image
            else:
                mapping[target] = image
                queue.append(target)
    assert len(mapping) == 60
    assert len(set(mapping.values())) == 60
    return mapping


def characteristic_stabilizers(group, order_five, involution):
    order_three = GOLD.matrix_product(order_five, involution)
    base_form = [GOLD.ZERO] * 13
    base_form[1] = GOLD.ONE
    base_form[6] = GOLD.Qzeta30(11)
    base_form[11] = GOLD.Qzeta30(-1)

    d5_outer = [[GOLD.ZERO, GOLD.ONE], [GOLD.ONE, GOLD.ZERO]]
    s3_outer = GOLD.construct_s3_normalizer(order_three)
    d5_forms = GOLD.orbit_forms(
        group, GOLD.transform_form(base_form, d5_outer)
    )
    s3_forms = GOLD.orbit_forms(
        group, GOLD.transform_form(base_form, s3_outer)
    )
    d5_subgroup = GOLD.subgroup_normalizer(group, order_five)
    s3_subgroup = GOLD.subgroup_normalizer(group, order_three)

    def orbit_stabilizers(forms, subgroup):
        return [
            frozenset(
                GOLD.conjugate_subgroup(subgroup, orbit_representative)
            )
            for _form, orbit_representative in forms
        ]

    return (
        orbit_stabilizers(d5_forms, d5_subgroup),
        orbit_stabilizers(s3_forms, s3_subgroup),
    )


def transport_stabilizers(stabilizers, homomorphism):
    return [
        frozenset(homomorphism[element] for element in stabilizer)
        for stabilizer in stabilizers
    ]


def stored_point_stabilizers(parent_group, permutation_to_matrix, points, indices):
    result = {}
    for point_index in indices:
        kernel = points[point_index]["kernel_rref"]
        result[point_index] = frozenset(
            element
            for element in parent_group
            if MATES.same_row_space(
                kernel,
                MATES.transform_kernel(
                    kernel, permutation_to_matrix[element]
                ),
            )
        )
    return result


def unique_point_map(stabilizers, stored_stabilizers):
    answer = []
    for stabilizer in stabilizers:
        matches = [
            point_index
            for point_index, stored_stabilizer in stored_stabilizers.items()
            if stabilizer == stored_stabilizer
        ]
        assert len(matches) == 1
        answer.append(matches[0])
    assert len(set(answer)) == len(answer)
    return answer


def build_certificate():
    gold_certificate = json.loads(GOLD_CERTIFICATE.read_text())
    mates_certificate = json.loads(MATES_CERTIFICATE.read_text())
    resolvent = json.loads(RESOLVENT_CERTIFICATE.read_text())

    group, characteristic_a, characteristic_b, _characteristic_c = (
        characteristic_zero_marking()
    )
    parent_group, finite_a, finite_b, permutation_to_matrix = finite_marking()
    homomorphism = simultaneous_homomorphism(
        (characteristic_a, characteristic_b), (finite_a, finite_b)
    )
    assert set(homomorphism) == set(group)
    assert set(homomorphism.values()) == set(parent_group)

    d5_characteristic_stabilizers, s3_characteristic_stabilizers = (
        characteristic_stabilizers(
            group, characteristic_a, characteristic_b
        )
    )
    d5_stabilizers = transport_stabilizers(
        d5_characteristic_stabilizers, homomorphism
    )
    s3_stabilizers = transport_stabilizers(
        s3_characteristic_stabilizers, homomorphism
    )
    stored = mates_certificate["intrinsic_D5_S3_incidence"]
    d5_point_order = [row["point_index"] for row in stored["D5_points"]]
    s3_point_order = [row["point_index"] for row in stored["S3_points"]]
    points = resolvent["explicit_resolvent"]["points"]
    stored_stabilizers = stored_point_stabilizers(
        parent_group,
        permutation_to_matrix,
        points,
        d5_point_order + s3_point_order,
    )
    d5_golden_to_point = unique_point_map(d5_stabilizers, stored_stabilizers)
    s3_golden_to_point = unique_point_map(s3_stabilizers, stored_stabilizers)
    assert set(d5_golden_to_point) == set(d5_point_order)
    assert set(s3_golden_to_point) == set(s3_point_order)

    plus = gold_certificate["incidence"]["lambda_plus_incidence"]
    plus_in_stored_order = [
        [
            plus[d5_golden_to_point.index(d5_point)][
                s3_golden_to_point.index(s3_point)
            ]
            for s3_point in s3_point_order
        ]
        for d5_point in d5_point_order
    ]
    stored_matrix = stored["kernel_intersection_dimension_matrix"]
    minus_in_stored_order = [
        [1 - entry for entry in row] for row in plus_in_stored_order
    ]
    assert plus_in_stored_order == stored_matrix
    assert minus_in_stored_order != stored_matrix

    def fibre_for_finite_generators(candidate_a, candidate_b):
        candidate_homomorphism = simultaneous_homomorphism(
            (characteristic_a, characteristic_b),
            (candidate_a, candidate_b),
        )
        candidate_d5_map = unique_point_map(
            transport_stabilizers(
                d5_characteristic_stabilizers, candidate_homomorphism
            ),
            stored_stabilizers,
        )
        candidate_s3_map = unique_point_map(
            transport_stabilizers(
                s3_characteristic_stabilizers, candidate_homomorphism
            ),
            stored_stabilizers,
        )
        candidate_matrix = [
            [
                plus[candidate_d5_map.index(d5_point)][
                    candidate_s3_map.index(s3_point)
                ]
                for s3_point in s3_point_order
            ]
            for d5_point in d5_point_order
        ]
        if candidate_matrix == stored_matrix:
            return "lambda_plus"
        if [
            [1 - entry for entry in row] for row in candidate_matrix
        ] == stored_matrix:
            return "lambda_minus"
        raise AssertionError("candidate marking matches neither golden fibre")

    finite_a_squared = MM.compose(finite_a, finite_a)
    convention_audit = {}
    for label, candidate_a, expected in (
        ("a_11", finite_a, "lambda_plus"),
        ("a_11_squared", finite_a_squared, "lambda_minus"),
    ):
        compatible_involutions = sorted(
            element
            for element in parent_group
            if DIVIDED.C651.element_order(element) == 2
            and DIVIDED.C651.element_order(
                MM.compose(candidate_a, element)
            )
            == 3
        )
        outcomes = sorted(
            {
                fibre_for_finite_generators(candidate_a, candidate_b)
                for candidate_b in compatible_involutions
            }
        )
        assert len(compatible_involutions) == 5
        assert outcomes == [expected]
        convention_audit[label] = {
            "compatible_involution_count": len(compatible_involutions),
            "stored_matrix_fibre_for_every_choice": expected,
        }

    finite_a_matrix = permutation_to_matrix[finite_a]
    finite_b_matrix = permutation_to_matrix[finite_b]
    trace = (finite_a_matrix[0] + finite_a_matrix[3]) % PRIME
    determinant = MATES.determinant(finite_a_matrix)
    ratio_plus_inverse = (
        trace * trace * pow(determinant, -1, PRIME) - 2
    ) % PRIME
    sqrt_five = (-2 * ratio_plus_inverse - 1) % PRIME
    assert sqrt_five == 4
    assert sqrt_five * sqrt_five % PRIME == 5
    denominator = 820125 % PRIME
    divided_scale = 2208 * pow(denominator, -1, PRIME) % PRIME
    plus_divided_digit = divided_scale * sqrt_five % PRIME
    minus_divided_digit = -plus_divided_digit % PRIME
    assert plus_divided_digit == 6
    assert minus_divided_digit == 5

    inputs = (
        GOLD_SCRIPT,
        GOLD_CERTIFICATE,
        MATES_SCRIPT,
        MATES_CERTIFICATE,
        RESOLVENT_CERTIFICATE,
        DEFORMATION_SCRIPT,
        DEFORMATION_CERTIFICATE,
    )
    return {
        "schema": "c682-common-marking-sign-v1",
        "frozen_marking": {
            "characteristic_zero": {
                "a": "diag(zeta_5^2,1)",
                "b": "[[zeta_5^2-zeta_5^3, zeta_5-zeta_5^4], "
                "[zeta_5-zeta_5^4, -(zeta_5^2-zeta_5^3)]]",
                "orders": {"a": 5, "b": 2, "a_times_b": 3},
                "sqrt5": "2*(zeta_30^2+zeta_30^3-zeta_30^7)-1",
            },
            "finite": {
                "selection": (
                    "a_11 is the lexicographically least order-5 element "
                    "of the stored parent permutation group; b_11 is the "
                    "least involution for which a_11*b_11 has order 3"
                ),
                "a_11_permutation": list(finite_a),
                "b_11_permutation": list(finite_b),
                "a_11_pgl_matrix": list(finite_a_matrix),
                "b_11_pgl_matrix": list(finite_b_matrix),
                "orders": {"a_11": 5, "b_11": 2, "a_11_times_b_11": 3},
            },
            "transport": (
                "the unique right-word homomorphism a->a_11, b->b_11"
            ),
            "transported_group_order": len(homomorphism),
            "sqrt5_mod_11": sqrt_five,
            "convention_sensitivity": convention_audit,
        },
        "stabilizer_matching": {
            "D5_golden_index_to_stored_point_index": d5_golden_to_point,
            "S3_golden_index_to_stored_point_index": s3_golden_to_point,
            "stored_D5_point_order": d5_point_order,
            "stored_S3_point_order": s3_point_order,
            "lambda_plus_in_stored_order": plus_in_stored_order,
            "stored_kernel_incidence_matrix": stored_matrix,
            "lambda_plus_equals_stored": True,
            "lambda_minus_equals_stored": False,
        },
        "sign_conclusion": {
            "stored_matrix_fibre": "lambda_plus",
            "stored_matrix_centered_theta": "+sqrt(5)",
            "stored_matrix_sqrt5_mod_11": 4,
            "stored_matrix_divided_cross_gram_digit_mod_11": plus_divided_digit,
            "complement_divided_cross_gram_digit_mod_11": minus_divided_digit,
            "digit_note": "6=-5 mod 11 and 5=+5 mod 11",
        },
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
        print("C682 common-marking sign certificate: ok")
    else:
        OUTPUT.write_text(rendered)
        print(OUTPUT)


if __name__ == "__main__":
    main()
