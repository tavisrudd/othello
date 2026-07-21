#!/usr/bin/env python3
"""C443 M3b blocker certificate: enumerate the frozen golden A5 matching lifts.

This checker stops at the first literal M3a falsifier.  It does not construct quotient tensors
after the required unique 1+10 golden sheet fails to exist.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
from collections import Counter
from fractions import Fraction as F
from pathlib import Path


HERE = Path(__file__).resolve().parent
STEM = "2026-07-21-c443-commuting-with-reduction"
REPORT_PATH = HERE / f"{STEM}.md"
REPLAY_PATH = HERE / f"{STEM}-replay.py"
JSON_PATH = HERE / f"{STEM}.json"
SHA_PATH = HERE / f"{STEM}.sha256"
SPEC_PATH = HERE / "2026-07-21-c443-commuting-reduction-spec.md"
SCHEMA = "c443-golden-sheet-lift-blocker-v1"

INPUT_STEMS = (
    "2026-07-20-c406-matching-orbit-scout",
    "2026-07-21-c440-conventions-freeze",
    "2026-07-21-c441-vertex-reduction-bijection",
    "2026-07-21-c442-antipodal-singleton-reduction",
    "2026-07-21-c458-golden-sheet-frame-freeze",
)


def load_module(stem: str):
    path = HERE / f"{stem}.py"
    spec = importlib.util.spec_from_file_location(stem.replace("-", "_"), path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C440 = load_module("2026-07-21-c440-conventions-freeze")
C441 = load_module("2026-07-21-c441-vertex-reduction-bijection")
C442 = load_module("2026-07-21-c442-antipodal-singleton-reduction")
C406 = load_module("2026-07-20-c406-matching-module")
C399 = C406.C399

Z5 = C440.Z5
ZOPS = C440.ops(Z5)
ZERO = ZOPS["ZERO"]
ONE = ZOPS["ONE"]
ZETA = Z5((0, 1, 0, 0))
ZETA4 = Z5((-1, -1, -1, -1))
PHI = ONE + ZETA + ZETA4
RHO = ZETA - ZETA4
TWO = Z5((2, 0, 0, 0))


def zconst(value) -> Z5:
    return Z5((F(value), F(0), F(0), F(0)))


def zpow(value: Z5, exponent: int) -> Z5:
    result = ONE
    while exponent:
        if exponent & 1:
            result = result * value
        value = value * value
        exponent //= 2
    return result


def zauto(value: Z5, power: int) -> Z5:
    return sum(
        (zconst(coefficient) * zpow(ZETA, power * index) for index, coefficient in enumerate(value.c)),
        ZERO,
    )


def kappa(value: Z5) -> Z5:
    return zauto(value, 4)


def determinant(matrix):
    if len(matrix) == 2:
        return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
    return (
        matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    )


def vec_dot(left, right):
    return sum((a * b for a, b in zip(left, right)), ZERO)


def vec_cross(left, right):
    return (
        left[1] * right[2] - left[2] * right[1],
        left[2] * right[0] - left[0] * right[2],
        left[0] * right[1] - left[1] * right[0],
    )


def mat_vec(matrix, vector):
    return tuple(vec_dot(row, vector) for row in matrix)


def mat_inverse(matrix):
    det = determinant(matrix)
    cofactors = []
    for row in range(3):
        cofactor_row = []
        for column in range(3):
            minor = [
                [matrix[i][j] for j in range(3) if j != column]
                for i in range(3)
                if i != row
            ]
            sign = ONE if (row + column) % 2 == 0 else -ONE
            cofactor_row.append(sign * determinant(minor))
        cofactors.append(cofactor_row)
    adjugate = tuple(tuple(cofactors[column][row] for column in range(3)) for row in range(3))
    return tuple(tuple(ZOPS["div"](entry, det) for entry in row) for row in adjugate)


def point_key(point):
    return tuple(tuple((value.numerator, value.denominator) for value in coordinate.c) for coordinate in point)


def normalize_point(point):
    pivot = next(coordinate for coordinate in point if not coordinate.iszero())
    return tuple(ZOPS["div"](coordinate, pivot) for coordinate in point)


def q_to_z5(value):
    return zconst(value[0]) + zconst(value[1]) * PHI


def mat2_mul(left, right):
    return (
        left[0] * right[0] + left[1] * right[2],
        left[0] * right[1] + left[1] * right[3],
        left[2] * right[0] + left[3] * right[2],
        left[2] * right[1] + left[3] * right[3],
    )


def mat2_inverse(matrix):
    a, b, c, d = matrix
    det = a * d - b * c
    return tuple(ZOPS["div"](entry, det) for entry in (d, -b, -c, a))


def normalize_pair(pair):
    return ZOPS["norm_pt"](pair)


def mat2_apply(matrix, point):
    a, b, c, d = matrix
    s, t = point
    return normalize_pair((a * s + b * t, c * s + d * t))


def frame_to_standard(frame):
    zero_point, one_point, infinity_point = frame
    s0, t0 = zero_point
    s1, t1 = one_point
    si, ti = infinity_point
    numerator = t0 * s1 - s0 * t1
    denominator = ti * s1 - si * t1
    assert not numerator.iszero() and not denominator.iszero()
    scale = ZOPS["div"](numerator, denominator)
    return (t0, -s0, scale * ti, -scale * si)


def reduce_z5(value: Z5, root: int, prime: int = 11):
    result = 0
    for index, coefficient in enumerate(value.c):
        denominator = coefficient.denominator % prime
        assert denominator
        result += coefficient.numerator * pow(denominator, -1, prime) * pow(root, index, prime)
    return result % prime


def reduce_pair(pair, root):
    return C399.normalize_pair(tuple(reduce_z5(value, root) for value in pair), 11)


def reduce_projective_point(point, root):
    return C399.normalize_mod(tuple(reduce_z5(value, root) for value in point), 11)


def pgl_bridge(source_points, target_points):
    source_to_standard = frame_to_standard(source_points[:3])
    target_set = set(target_points)
    candidates = []
    for target_frame in itertools.permutations(target_points, 3):
        if len(set(target_frame)) < 3:
            continue
        target_to_standard = frame_to_standard(target_frame)
        bridge = mat2_mul(mat2_inverse(target_to_standard), source_to_standard)
        if {mat2_apply(bridge, point) for point in source_points} != target_set:
            continue
        det = bridge[0] * bridge[3] - bridge[1] * bridge[2]
        if all(reduce_z5(det, root) for root in (3, 4, 5, 9)):
            candidates.append(bridge)
    assert candidates
    return min(
        candidates,
        key=lambda matrix: tuple(
            tuple((coefficient.numerator, coefficient.denominator) for coefficient in entry.c)
            for entry in matrix
        ),
    )


def matching_image(permutation, matching):
    return tuple(sorted(tuple(sorted((permutation[left], permutation[right]))) for left, right in matching))


def perfect_matchings(vertices):
    vertices = tuple(vertices)
    if not vertices:
        yield ()
        return
    first = vertices[0]
    for offset in range(1, len(vertices)):
        second = vertices[offset]
        rest = vertices[1:offset] + vertices[offset + 1 :]
        for tail in perfect_matchings(rest):
            yield tuple(sorted(((first, second),) + tail))


def matching_orbits(matchings, group):
    unseen = set(matchings)
    result = []
    while unseen:
        representative = min(unseen)
        orbit = {matching_image(element, representative) for element in group}
        result.append(tuple(sorted(orbit)))
        unseen -= orbit
    return tuple(sorted(result, key=lambda orbit: (len(orbit), orbit[0])))


def is_one_factorization(matchings):
    counts = Counter(pair for matching in matchings for pair in matching)
    return len(counts) == 66 and set(counts.values()) == {1}


def serialize_z5(value: Z5):
    return [
        str(coefficient.numerator)
        if coefficient.denominator == 1
        else f"{coefficient.numerator}/{coefficient.denominator}"
        for coefficient in value.c
    ]


def serialize_matching(matching):
    return [list(pair) for pair in matching]


def serialize_orbit(orbit):
    return [serialize_matching(matching) for matching in orbit]


def canonical_hash(value):
    payload = json.dumps(value, separators=(",", ":"), sort_keys=True).encode()
    return hashlib.sha256(payload).hexdigest()


def input_hashes():
    result = {}
    for stem in INPUT_STEMS:
        for suffix in (".py", ".json", ".sha256"):
            path = HERE / f"{stem}{suffix}"
            if path.exists():
                data = path.read_bytes()
                result[path.name] = {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}
    return result


def expected_matching(record, parameter_index):
    def endpoint(value):
        pair = (0, 1) if value == "inf" else (1, int(value))
        return parameter_index[pair]

    return tuple(sorted(tuple(sorted((endpoint(left), endpoint(right)))) for left, right in record))


def cycle_lengths(permutation):
    unseen = set(range(len(permutation)))
    result = []
    while unseen:
        start = min(unseen)
        current = start
        length = 0
        while current in unseen:
            unseen.remove(current)
            length += 1
            current = permutation[current]
        result.append(length)
    return sorted(result)


def finite_quotient_vectors(factorization, endpoints, base_product):
    vectors = []
    for matching in sorted(factorization):
        product = C406.matching_product(matching, endpoints, 11)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % 11
            for exponent in set(product) | set(base_product)
        }
        vectors.append(C406.quotient_by_conic(difference, 4, 11))
    return vectors


def finite_moment(vectors, degree):
    powers = [C406.symmetric_power(vector, degree, 11) for vector in vectors]
    return [sum(entries) % 11 for entries in zip(*powers)]


def vector_linear_combination(left, right, left_scale=1, right_scale=-1):
    return [
        (left_scale * left[index] + right_scale * right[index]) % 11
        for index in range(len(left))
    ]


def build_certificate():
    m0_json = json.loads((HERE / "2026-07-21-c440-conventions-freeze.json").read_text())
    h3 = C441.build_h3(C440, m0_json)
    source_roots = tuple(sorted(h3["roots"], key=lambda point: tuple(coordinate.c for coordinate in point)))

    u = (-PHI, RHO, ONE)
    e = (PHI, -RHO, ONE)
    w = vec_cross(u, e)
    b_matrix = tuple(tuple(column[row] for column in (u, w, e)) for row in range(3))
    inverse_b = mat_inverse(b_matrix)
    assert vec_dot(u, u).iszero() and vec_dot(e, e).iszero()
    assert vec_dot(u, e) == TWO and vec_dot(w, w) == zconst(-4)
    test = (zconst(2), zconst(3), zconst(5))
    assert vec_dot(mat_vec(b_matrix, test), mat_vec(b_matrix, test)) == zconst(4) * (
        test[0] * test[2] - test[1] * test[1]
    )

    qgroup = C442.q_closure([C442.qnormmat(C442.q_refl(root)) for root in C442.q_roots(C442.QPHI)])
    group = tuple(tuple(tuple(q_to_z5(entry) for entry in row) for row in matrix) for matrix in qgroup)
    orbit_u = {normalize_point(mat_vec(matrix, u)) for matrix in group}
    assert len(group) == 60 and len(orbit_u) == 12

    target_parameters = []
    for point in sorted(orbit_u, key=point_key):
        x_coordinate, y_coordinate, z_coordinate = mat_vec(inverse_b, point)
        parameter = (x_coordinate, y_coordinate) if not x_coordinate.iszero() else (y_coordinate, z_coordinate)
        parameter = normalize_pair(parameter)
        s, t = parameter
        assert normalize_point(mat_vec(b_matrix, (s * s, s * t, t * t))) == point
        target_parameters.append(parameter)
    bridge = pgl_bridge(source_roots, tuple(target_parameters))
    primitive_roots = tuple(
        (bridge[0] * s + bridge[1] * t, bridge[2] * s + bridge[3] * t) for s, t in source_roots
    )

    points = tuple(sorted(orbit_u, key=point_key))
    point_index = {point: index for index, point in enumerate(points)}
    permutations = tuple(
        tuple(point_index[normalize_point(mat_vec(matrix, point))] for point in points) for matrix in group
    )
    assert len(set(permutations)) == 60
    root_by_point = {}
    for root in primitive_roots:
        s, t = root
        point = normalize_point(mat_vec(b_matrix, (s * s, s * t, t * t)))
        root_by_point[point] = root
    ordered_roots = tuple(root_by_point[point] for point in points)

    six_arc = tuple(tuple(q_to_z5(entry) for entry in point) for point in C442.q_six(C442.QPHI))
    polar_matching = tuple(
        sorted(
            tuple(sorted(index for index, point in enumerate(points) if vec_dot(pole, point).iszero()))
            for pole in six_arc
        )
    )
    assert all(len(pair) == 2 for pair in polar_matching)
    assert all(matching_image(permutation, polar_matching) == polar_matching for permutation in permutations)

    all_matchings = tuple(perfect_matchings(range(12)))
    orbits = matching_orbits(all_matchings, permutations)
    fixed_orbits = [orbit for orbit in orbits if len(orbit) == 1]
    assert len(fixed_orbits) == 1 and fixed_orbits[0][0] == polar_matching
    candidates = tuple(
        orbit for orbit in orbits if len(orbit) == 10 and is_one_factorization((polar_matching,) + orbit)
    )
    assert len(candidates) == 4

    kappa_vertex_permutation = tuple(
        point_index[normalize_point(tuple(kappa(coordinate) for coordinate in point))] for point in points
    )
    candidate_index = {frozenset(orbit): index for index, orbit in enumerate(candidates)}
    kappa_candidate_permutation = tuple(
        candidate_index[
            frozenset(matching_image(kappa_vertex_permutation, matching) for matching in orbit)
        ]
        for orbit in candidates
    )
    assert cycle_lengths(kappa_candidate_permutation) == [2, 2]

    scout = json.loads((HERE / "2026-07-20-c406-matching-orbit-scout.json").read_text())
    h3_record = next(record for record in scout["types"] if record["type"] == "H3")
    conic, parameters = C399.conic_parameterization(11)
    conic_index = {point: index for index, point in enumerate(conic)}
    parameter_index = {parameter: index for index, parameter in enumerate(parameters)}
    full_group, psl_group = C406.full_pgl(11, parameters)
    finite_base = tuple(tuple(pair) for pair in h3_record["coxeter_invariant_matching"])
    finite_orbit = frozenset(C406.matching_image(element, finite_base) for element in full_group)
    base_sheet = frozenset(C406.matching_image(element, finite_base) for element in psl_group)
    other_sheet = finite_orbit - base_sheet
    assert len(finite_orbit) == 22 and len(base_sheet) == len(other_sheet) == 11

    c458 = json.loads((HERE / "2026-07-21-c458-golden-sheet-frame-freeze.json").read_text())
    polar_record = c458["golden_sheet_frame"]["polar_pair_matching"]
    expected_polar = {
        "pi": expected_matching(polar_record["reduction_at_pi_phi_to_8"]["matching"], parameter_index),
        "pibar": expected_matching(polar_record["reduction_at_pibar_phi_to_4"]["matching"], parameter_index),
    }

    reduction_records = []
    reduced_factorizations = {}
    for root in (3, 4, 5, 9):
        vertex_map = tuple(conic_index[reduce_projective_point(point, root)] for point in points)
        reduced_polar = matching_image(vertex_map, polar_matching)
        candidate_records = []
        for index, candidate in enumerate(candidates):
            reduced_factorization = frozenset(
                matching_image(vertex_map, matching) for matching in (polar_matching,) + candidate
            )
            reduced_factorizations[(root, index)] = reduced_factorization
            label = "base" if reduced_factorization == base_sheet else "outer" if reduced_factorization == other_sheet else None
            rendered = [serialize_matching(matching) for matching in sorted(reduced_factorization)]
            candidate_records.append(
                {
                    "candidate": index,
                    "frozen_sheet": label,
                    "is_frozen_C406_sheet": label is not None,
                    "reduced_factorization_sha256": canonical_hash(rendered),
                }
            )
        phi_value = reduce_z5(PHI, root)
        expected_name = "pi" if phi_value == 8 else "pibar"
        reduction_records.append(
            {
                "zeta": root,
                "phi": phi_value,
                "golden_prime": expected_name,
                "polar_matching": serialize_matching(reduced_polar),
                "polar_matches_C458": reduced_polar == expected_polar[expected_name],
                "candidates": candidate_records,
                "target_hit_count": sum(record["is_frozen_C406_sheet"] for record in candidate_records),
            }
        )

    assert all(record["target_hit_count"] == 1 for record in reduction_records)
    hit_counts = [
        sum(record["candidates"][index]["is_frozen_C406_sheet"] for record in reduction_records)
        for index in range(len(candidates))
    ]
    assert hit_counts == [1, 1, 1, 1]

    base_product = C406.matching_product(finite_base, parameters, 11)
    finite_moments = {}
    for root in (3, 4, 5, 9):
        for index in range(len(candidates)):
            vectors = finite_quotient_vectors(reduced_factorizations[(root, index)], parameters, base_product)
            for degree in (1, 2, 3):
                finite_moments[(root, index, degree)] = finite_moment(vectors, degree)
    target_moments = {}
    for degree in (1, 2, 3):
        base_moment = finite_moment(finite_quotient_vectors(base_sheet, parameters, base_product), degree)
        other_moment = finite_moment(finite_quotient_vectors(other_sheet, parameters, base_product), degree)
        target_moments[degree] = vector_linear_combination(base_moment, other_moment)

    kappa_pairs = sorted(
        {tuple(sorted((index, image))) for index, image in enumerate(kappa_candidate_permutation)}
    )
    inv_two = pow(2, -1, 11)
    pair_review = []
    for pair in kappa_pairs:
        moments = {}
        for root in (3, 4, 5, 9):
            for degree in (1, 2, 3):
                moments[(root, degree)] = vector_linear_combination(
                    finite_moments[(root, pair[0], degree)],
                    finite_moments[(root, pair[1], degree)],
                    inv_two,
                    inv_two,
                )
        pair_record = {"candidates": list(pair), "degrees": {}}
        for degree in (1, 2, 3):
            mu_at_pi = vector_linear_combination(moments[(3, degree)], moments[(9, degree)])
            target = target_moments[degree]
            pair_record["degrees"][str(degree)] = {
                "descent_agrees_at_pi_roots_3_4": moments[(3, degree)] == moments[(4, degree)],
                "descent_agrees_at_pibar_roots_5_9": moments[(5, degree)] == moments[(9, degree)],
                "mu_at_pi_equals_C406_base_minus_outer": mu_at_pi == target,
                "mu_at_pi_equals_negative_C406_base_minus_outer": mu_at_pi
                == [(-value) % 11 for value in target],
                "mu_at_pi_support": sum(value != 0 for value in mu_at_pi),
                "mu_at_pi_sha256": hashlib.sha256(bytes(mu_at_pi)).hexdigest(),
                "target_support": sum(value != 0 for value in target),
                "target_sha256": hashlib.sha256(bytes(target)).hexdigest(),
            }
        pair_review.append(pair_record)

    orbit_census = Counter(len(orbit) for orbit in orbits)
    serialized_candidates = [serialize_orbit(orbit) for orbit in candidates]
    bridge_det = bridge[0] * bridge[3] - bridge[1] * bridge[2]
    return {
        "schema": SCHEMA,
        "task": "C443",
        "executor": "5.6-sol-xhigh, standing in for the program's Fable formulation role",
        "verdict": "BLOCKED_AT_REQUIRED_UNIQUE_ONE_PLUS_TEN_GOLDEN_SHEET",
        "consumes": input_hashes(),
        "blocker": {
            "m3a_clause": "the unique size-ten H-orbit O_10 for which {M_0} union O_10 is a one-factorization",
            "expected_one_factorizing_size_ten_orbits": 1,
            "observed_one_factorizing_size_ten_orbits": len(candidates),
            "guardrail_trigger": "orbit/fibre size differs from the frozen specification",
            "halt_stage": "before secant products, conic division, denominator set N, or moments mu_1,mu_2,mu_3",
            "kappa_fixed_candidates": sum(index == image for index, image in enumerate(kappa_candidate_permutation)),
            "kappa_candidate_permutation": list(kappa_candidate_permutation),
            "kappa_candidate_cycle_lengths": cycle_lengths(kappa_candidate_permutation),
            "candidate_target_hit_counts_across_four_cyclotomic_primes": hit_counts,
            "bounded_formulation_review": {
                "C448_help": "retain the canonical orbit-valued object; do not promote a chosen member to a canonical selector",
                "canonical_object_here": "the unordered four-element set of one-factorizing companion orbits",
                "why_no_repair_within_M3a": "no member is kappa-fixed and no member realizes a frozen C406 sheet at more than one of zeta=3,4,5,9; uniform averaging on either kappa-pair descends but has nonzero reduced first signed moment instead of C406's zero first moment",
                "paper_boundary": "M1-M2 and C458 remain valid; this blocks the specified global secant-product tensor lift, not every abstract integral tensor with the same special fibres",
            },
        },
        "geometry": {
            "golden_group_order": len(group),
            "vertex_count": len(points),
            "perfect_matching_count": len(all_matchings),
            "matching_orbit_count": len(orbits),
            "matching_orbit_size_census": {str(size): orbit_census[size] for size in sorted(orbit_census)},
            "fixed_matching_orbit_count": len(fixed_orbits),
            "polar_matching": serialize_matching(polar_matching),
            "size_ten_orbit_count": orbit_census[10],
            "one_factorizing_size_ten_orbit_count": len(candidates),
            "all_four_complete_K12_one_factorizations": all(
                is_one_factorization((polar_matching,) + candidate) for candidate in candidates
            ),
            "candidate_orbits": serialized_candidates,
            "candidate_orbits_sha256": canonical_hash(serialized_candidates),
            "kappa_vertex_permutation": list(kappa_vertex_permutation),
            "B": [[serialize_z5(value) for value in row] for row in b_matrix],
            "det_B": serialize_z5(determinant(b_matrix)),
            "q_after_B_is_4_times_XZ_minus_Y2": True,
            "pgl_bridge": [serialize_z5(value) for value in bridge],
            "pgl_bridge_determinant": serialize_z5(bridge_det),
            "pgl_bridge_determinant_reductions": {
                str(root): reduce_z5(bridge_det, root) for root in (3, 4, 5, 9)
            },
        },
        "finite_reductions": {
            "field": "F_11",
            "frozen_C406_orbit_size": len(finite_orbit),
            "frozen_sheet_sizes": [len(base_sheet), len(other_sheet)],
            "records": reduction_records,
            "each_root_has_exactly_one_candidate_hit": True,
            "no_candidate_hits_more_than_one_root": True,
            "kappa_pair_moment_review": pair_review,
        },
        "unreached_acceptance_objects": {
            "exact_denominator_set_N": None,
            "products_square": None,
            "quotient_square": None,
            "moment_square": None,
            "mu3_plus_minus_6_shadow": None,
        },
    }


def canonical_json(certificate):
    return json.dumps(certificate, indent=2, sort_keys=True) + "\n"


def manifest_text(json_data: bytes):
    entries = []
    for path in (REPORT_PATH, SPEC_PATH, Path(__file__), REPLAY_PATH, JSON_PATH):
        data = json_data if path == JSON_PATH else path.read_bytes()
        entries.append((hashlib.sha256(data).hexdigest(), len(data), path.name))
    return "".join(f"{digest}  {size}  {name}\n" for digest, size, name in entries)


def main(argv):
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args(argv)
    data = canonical_json(build_certificate()).encode()
    manifest = manifest_text(data)
    if args.check:
        ok = JSON_PATH.exists() and JSON_PATH.read_bytes() == data
        ok = ok and SHA_PATH.exists() and SHA_PATH.read_text() == manifest
        print("C443 BLOCKER CHECK OK" if ok else "C443 BLOCKER CHECK FAILED")
        return 0 if ok else 1
    JSON_PATH.write_bytes(data)
    SHA_PATH.write_text(manifest)
    print(f"wrote {JSON_PATH.name} ({len(data)} bytes) and {SHA_PATH.name}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
