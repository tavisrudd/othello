#!/usr/bin/env python3
"""C415: exact polar/perpendicular-incidence meaning of the odd Fourier images.

Certified statement, uniform over H3/q=11 and every B3/q=7 seam exchange:
with D(M) the signed zero-depth profile on the four J-paired point-orbit
classes and S(M) the signed polar zero-depth profile
S_i(M) = sum_{y in O_left_i} #(Z(M) cap y^perp)
       - sum_{y in O_right_i} #(Z(M) cap y^perp),
the ordinary odd Fourier block from the qz-ell rule satisfies

    M_odd = q * N^T          (entrywise; N is the signed incidence matrix
                              N[i][j] = z(l_j, l_i) - z(l_j, r_i)),
    N * N = q * I_4,
    N * D(M) = S(M),         equivalently M_odd^T D(M) = q S(M),
    M_odd^T S(M) = q^2 D(M),

and S decomposes geometrically as S_i = q * Pole_i(M) - Deep_i(M), where
Pole_i counts secant poles (the dual matching points under the conic
polarity) on the signed orbit pair and Deep_i counts polars of depth>=2
crossing points weighted by depth-1.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
C341_PATH = HERE / "2026-07-18-c341-a5-subgroup-decoder.py"
C341_SHA256 = "4419cf398eae700b54e79b8b3ffe237d9ae2ddcefe496fcdadecfc78dddfa5be"
C406_PATH = HERE / "2026-07-20-c406-matching-module.py"
C406_SHA256 = "a1fef3680a7d12d64a1c483e7032cbaa3a1f575883b2bd8b964d58aa8ac38d51"
C406_CERT_PATH = HERE / "2026-07-20-c406-matching-module.json"
C406_CERT_SHA256 = "e39bf131f3d818dfbcbeb1f2d4dfa9a6ba7645c41cdd6fe9600957c0fe1dc4b2"
SCOUT_PATH = HERE / "2026-07-20-c406-matching-orbit-scout.json"
SCOUT_SHA256 = "fec533bb91f864100ebf5875952244d9d9e03ed69a0abda767360907a55bb246"
C411_PATH = HERE / "2026-07-20-c411-double-coset-hecke.json"
C411_SHA256 = "23f0a100356f0a369f00d81011e8d8d6b9d867b9de45a7b0625fc2889323b014"
C378_CERT_PATH = HERE / "2026-07-19-c378-clebsch-common-duality.json"
C378_CERT_SHA256 = "3b311e5ee8ba5d09510fe18e4c5f3e30223c804d49b7c5b206e125ce1ad879dc"


def load_module(name: str, path: Path, expected_sha256: str):
    assert hashlib.sha256(path.read_bytes()).hexdigest() == expected_sha256
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def load_json(path: Path, expected_sha256: str):
    assert hashlib.sha256(path.read_bytes()).hexdigest() == expected_sha256
    return json.loads(path.read_text())


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def sha256_of(value: object) -> str:
    return hashlib.sha256(
        json.dumps(value, separators=(",", ":"), sort_keys=True).encode()
    ).hexdigest()


def dot(left, right, prime):
    return sum(a * b for a, b in zip(left, right)) % prime


def matrix_transpose_vector(matrix, vector, prime):
    return tuple(
        sum(matrix[row][column] * vector[row] for row in range(3)) % prime
        for column in range(3)
    )


def secant_lines(endpoints, matching, prime):
    result = []
    for left, right in matching:
        (s_i, t_i), (s_j, t_j) = endpoints[left], endpoints[right]
        result.append(
            (
                t_i * t_j % prime,
                -(s_i * t_j + t_i * s_j) % prime,
                s_i * s_j % prime,
            )
        )
    return result


def incidence_count(source_representative, target_orbit, prime):
    return sum(dot(source_representative, point, prime) == 0 for point in target_orbit)


def odd_block_data(point_orbits, odd_pairs, prime):
    """The qz-ell odd Fourier block and its integral incidence square root."""
    representatives = [min(orbit) if orbit else None for orbit in point_orbits]
    pair_sizes = []
    for left, right in odd_pairs:
        assert len(point_orbits[left]) == len(point_orbits[right])
        pair_sizes.append(len(point_orbits[left]))
    m_odd = [
        [
            prime
            * (
                incidence_count(representatives[l_i], point_orbits[l_j], prime)
                - incidence_count(representatives[l_i], point_orbits[r_j], prime)
            )
            for (l_j, r_j) in odd_pairs
        ]
        for (l_i, _r_i) in odd_pairs
    ]
    # Representative independence: the incidence difference is constant on orbits.
    for (l_i, _r_i), row in zip(odd_pairs, m_odd):
        for source in point_orbits[l_i]:
            for column, (l_j, r_j) in enumerate(odd_pairs):
                difference = prime * (
                    incidence_count(source, point_orbits[l_j], prime)
                    - incidence_count(source, point_orbits[r_j], prime)
                )
                assert difference == row[column]
    n_matrix = [[m_odd[j][i] // prime for j in range(4)] for i in range(4)]
    assert all(m_odd[j][i] == prime * n_matrix[i][j] for i in range(4) for j in range(4))
    n_square = [
        [sum(n_matrix[i][k] * n_matrix[k][j] for k in range(4)) for j in range(4)]
        for i in range(4)
    ]
    assert n_square == [[prime * (i == j) for j in range(4)] for i in range(4)]
    m_square = [
        [sum(m_odd[i][k] * m_odd[k][j] for k in range(4)) for j in range(4)]
        for i in range(4)
    ]
    assert m_square == [[prime**3 * (i == j) for j in range(4)] for i in range(4)]
    return m_odd, n_matrix, pair_sizes


def apply_matrix(matrix, vector):
    return [sum(row[j] * vector[j] for j in range(len(vector))) for row in matrix]


def polar_records(
    points,
    point_orbits,
    odd_pairs,
    zero_set,
    depth_by_point,
    poles,
    secant_count,
    prime,
):
    """D, S, Pole, Deep profiles plus the pointwise decomposition check."""
    orbit_of_point = {}
    for index, orbit in enumerate(point_orbits):
        for point in orbit:
            orbit_of_point[point] = index
    zero_counts = [sum(point in zero_set for point in orbit) for orbit in point_orbits]
    depth_profile = [zero_counts[left] - zero_counts[right] for left, right in odd_pairs]

    rho = {}
    for point in points:
        rho[point] = sum(dot(point, zero, prime) == 0 for zero in zero_set)
    polar_sums = [sum(rho[point] for point in orbit) for orbit in point_orbits]
    polar_profile = [polar_sums[left] - polar_sums[right] for left, right in odd_pairs]

    pole_counter = Counter(poles)
    deep_points = [
        (point, depth - 1) for point, depth in depth_by_point.items() if depth >= 2
    ]
    pole_counts = [
        sum(pole_counter.get(point, 0) for point in orbit) for orbit in point_orbits
    ]
    pole_profile = [pole_counts[left] - pole_counts[right] for left, right in odd_pairs]
    deep_sums = [
        sum(
            weight * sum(dot(point, deep, prime) == 0 for point in orbit)
            for deep, weight in deep_points
        )
        for orbit in point_orbits
    ]
    deep_profile = [deep_sums[left] - deep_sums[right] for left, right in odd_pairs]

    # Pointwise decomposition rho(y) = k + q*#poles(y) - sum_deep (depth-1)[y in z^perp].
    for point in points:
        deep_term = sum(
            weight
            for deep, weight in deep_points
            if dot(point, deep, prime) == 0
        )
        assert rho[point] == (
            secant_count + prime * pole_counter.get(point, 0) - deep_term
        )
    assert all(
        polar_profile[i] == prime * pole_profile[i] - deep_profile[i] for i in range(4)
    )
    return {
        "zero_locus_size": len(zero_set),
        "relation_zero_counts": zero_counts,
        "depth_profile": depth_profile,
        "polar_profile": polar_profile,
        "pole_profile": pole_profile,
        "deep_profile": deep_profile,
        "deep_point_excess": sorted(weight for _point, weight in deep_points),
    }


def matching_geometry(matching, endpoints, frame_to_standard, points, prime):
    """Zero locus, per-point depth, and secant poles in the orbit frame."""
    lines = secant_lines(endpoints, matching, prime)
    depth_by_point = {}
    zero_set = set()
    for point in points:
        standard_point = tuple(
            sum(frame_to_standard[row][column] * point[column] for column in range(3))
            % prime
            for row in range(3)
        )
        depth = sum(dot(line, standard_point, prime) == 0 for line in lines)
        if depth:
            zero_set.add(point)
            depth_by_point[point] = depth
    poles = []
    for line in lines:
        functional = matrix_transpose_vector(frame_to_standard, line, prime)
        pivot = next(value for value in functional if value)
        scale = pow(pivot, -1, prime)
        poles.append(tuple(value * scale % prime for value in functional))
    return zero_set, depth_by_point, poles


def h3_certificate(c341, c406):
    prime = 11
    scout = load_json(SCOUT_PATH, SCOUT_SHA256)
    c406_certificate = load_json(C406_CERT_PATH, C406_CERT_SHA256)
    c411_certificate = load_json(C411_PATH, C411_SHA256)
    c378_certificate = load_json(C378_CERT_PATH, C378_CERT_SHA256)
    scout_h3 = next(record for record in scout["types"] if record["type"] == "H3")
    c406_h3 = next(
        record for record in c406_certificate["types"] if record["type"] == "H3"
    )
    bridge = c406_h3["outer_sheet_sign"]["c378_depth_fourier_bridge"]
    standard_to_h3 = bridge["standard_to_h3_projectivity"]
    h3_to_standard = c406.matrix_inverse(standard_to_h3, prime)

    conic, parameters = c406.C399.conic_parameterization(prime)
    endpoints = tuple(parameters)
    full_group, psl_group = c406.full_pgl(prime, endpoints)
    base_matching = tuple(tuple(pair) for pair in scout_h3["coxeter_invariant_matching"])
    matchings = sorted(
        {c406.matching_image(element, base_matching) for element in full_group}
    )
    matching_index = {matching: index for index, matching in enumerate(matchings)}
    assert len(matchings) == 22

    plus_group, labels, plus_relations = c406.C378.scheme(c341, 8)
    minus_group, minus_labels, minus_relations = c406.C378.scheme(c341, 4)
    assert labels == minus_labels
    intersection_group = plus_group & minus_group
    assert len(intersection_group) == 12

    common_relations = c406.C378.orbits(
        c341, c406.C378.linear_group(intersection_group), c341.all_vectors(prime)
    )
    common_metadata = []
    for relation in common_relations:
        plus_index = next(
            index for index, target in enumerate(plus_relations) if relation <= target
        )
        minus_index = next(
            index for index, target in enumerate(minus_relations) if relation <= target
        )
        common_metadata.append((plus_index, minus_index, min(relation), relation))
    common_metadata.sort(key=lambda item: item[:3])
    common_relations = [item[3] for item in common_metadata]
    relation_permutation = []
    for relation in common_relations:
        image = {c341.mat_vec(c406.C378.J, vector, prime) for vector in relation}
        relation_permutation.append(
            next(index for index, target in enumerate(common_relations) if image == target)
        )
    odd_pairs = [
        (index, image)
        for index, image in enumerate(relation_permutation)
        if index < image
    ]
    assert odd_pairs == [(1, 10), (3, 13), (6, 14), (9, 11)]
    point_orbits = [
        sorted(
            {
                c341.normalize(vector, prime)
                for vector in relation
                if vector != (0, 0, 0)
            }
        )
        for relation in common_relations
    ]
    points = sorted(set().union(*point_orbits[1:]))
    assert len(points) == prime * prime + prime + 1 == 133
    assert all(dot(point, point, prime) == 0 for point in conic)

    # The certified C378 odd Fourier block is exactly q times the transposed
    # incidence-difference matrix N, and N is an integral square root of q.
    eigenmatrix = c406.C378.fourier_matrix(c341, common_relations)
    m_odd_from_eigenmatrix = [
        [
            eigenmatrix[l_i][l_j] - eigenmatrix[l_i][r_j]
            for (l_j, r_j) in odd_pairs
        ]
        for (l_i, _r_i) in odd_pairs
    ]
    assert m_odd_from_eigenmatrix == c378_certificate["odd_fourier_matrix"]
    m_odd, n_matrix, pair_sizes = odd_block_data(point_orbits, odd_pairs, prime)
    assert m_odd == m_odd_from_eigenmatrix
    assert pair_sizes == [6, 6, 12, 12]

    j_action = None
    conic_index = {point: index for index, point in enumerate(conic)}
    j_permutation = []
    for point in conic:
        moved = c341.mat_vec(c406.C378.J, point, prime)
        pivot = next(value for value in moved if value % prime)
        scale = pow(pivot, -1, prime)
        j_permutation.append(
            conic_index[tuple(value * scale % prime for value in moved)]
        )
    j_action = tuple(j_permutation)

    matching_records = []
    profiles = {}
    for matching in matchings:
        zero_set, depth_by_point, poles = matching_geometry(
            matching, endpoints, h3_to_standard, points, prime
        )
        record = polar_records(
            points,
            point_orbits,
            odd_pairs,
            zero_set,
            depth_by_point,
            poles,
            len(matching),
            prime,
        )
        transformed = apply_matrix(n_matrix, record["depth_profile"])
        assert transformed == record["polar_profile"]
        assert apply_matrix(n_matrix, record["polar_profile"]) == [
            prime * value for value in record["depth_profile"]
        ]
        record["matching"] = [list(pair) for pair in matching]
        matching_records.append(record)
        profiles[matching] = (
            tuple(record["depth_profile"]),
            tuple(record["polar_profile"]),
        )

    for matching in matchings:
        mate = c406.matching_image(j_action, matching)
        depth, polar = profiles[matching]
        mate_depth, mate_polar = profiles[mate]
        assert mate_depth == tuple(-value for value in depth)
        assert mate_polar == tuple(-value for value in polar)

    # Cross-check the six C411 double-coset representative depth rows.
    for representative in c411_certificate["double_cosets"]["representatives"]:
        matching = tuple(
            tuple(pair) for pair in representative["representative_matching"]
        )
        index = matching_index[matching]
        assert (
            matching_records[index]["relation_zero_counts"]
            == representative["relation_zero_counts"]
        )
        assert (
            matching_records[index]["depth_profile"]
            == representative["depth_profile"]
        )

    depth_rows = [record["depth_profile"] for record in matching_records]
    polar_rows = [record["polar_profile"] for record in matching_records]
    depth_plane = c406.nullspace([[v % prime for v in row] for row in depth_rows], prime)
    polar_plane = c406.nullspace([[v % prime for v in row] for row in polar_rows], prime)
    joint_rank = c406.rank(
        [[v % prime for v in row] for row in depth_rows + polar_rows], prime
    )

    return {
        "field": prime,
        "secant_count": 6,
        "matching_count": len(matchings),
        "odd_relation_pairs": [list(pair) for pair in odd_pairs],
        "odd_pair_projective_sizes": pair_sizes,
        "odd_pair_orbit_representatives": [
            [list(min(point_orbits[left])), list(min(point_orbits[right]))]
            for left, right in odd_pairs
        ],
        "m_odd": m_odd,
        "n_matrix": n_matrix,
        "n_square_scalar": prime,
        "m_odd_equals_q_times_n_transpose": True,
        "matchings": matching_records,
        "distinct_depth_profiles": len({tuple(row) for row in depth_rows}),
        "distinct_polar_profiles": len({tuple(row) for row in polar_rows}),
        "depth_profile_plane_mod_q": depth_plane,
        "polar_profile_plane_mod_q": polar_plane,
        "joint_depth_polar_rank_mod_q": joint_rank,
        "zero_locus_sizes": sorted(
            {record["zero_locus_size"] for record in matching_records}
        ),
        "deep_point_excess_multisets": sorted(
            {tuple(record["deep_point_excess"]) for record in matching_records}
        ),
    }


def b3_certificate(c341, c406):
    prime = 7
    conic, parameters = c406.C399.conic_parameterization(prime)
    endpoints = tuple(parameters)
    assert all(dot(point, point, prime) == 0 for point in conic)
    full_group, psl_group = c406.full_pgl(prime, endpoints)
    parent = c406.coxeter_group("B3", prime, conic)
    identity = tuple(range(prime + 1))

    def conjugate(element, group):
        inv = c406.inverse(element)
        return frozenset(
            c406.compose(c406.compose(element, member), inv) for member in group
        )

    def perfect_matchings(vertices):
        if not vertices:
            return [()]
        first = vertices[0]
        result = []
        for index in range(1, len(vertices)):
            second = vertices[index]
            remainder = vertices[1:index] + vertices[index + 1 :]
            for tail in perfect_matchings(remainder):
                result.append(tuple(sorted(((first, second),) + tail)))
        return result

    def fixed_matching(group):
        fixed = [
            matching
            for matching in perfect_matchings(tuple(range(prime + 1)))
            if all(c406.matching_image(element, matching) == matching for element in group)
        ]
        assert len(fixed) == 1
        return fixed[0]

    def determinant(matrix):
        return (
            matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
            - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
            + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
        ) % prime

    def canonical_so3_lift(permutation):
        matrix = c341.frame_map(
            conic[:4], [conic[permutation[index]] for index in range(4)], prime
        )
        gram = c341.mat_mul(tuple(zip(*matrix)), matrix, prime)
        multiplier = gram[0][0]
        assert gram == tuple(
            tuple(multiplier * int(i == j) % prime for j in range(3)) for i in range(3)
        )
        scalar = multiplier * pow(determinant(matrix), -1, prime) % prime
        lift = tuple(tuple(scalar * entry % prime for entry in row) for row in matrix)
        assert determinant(lift) == 1
        return lift

    standard_conic = [
        (left * left % prime, left * right % prime, right * right % prime)
        for left, right in endpoints
    ]
    standard_to_coxeter = c341.frame_map(standard_conic[:4], conic[:4], prime)
    coxeter_to_standard = c406.matrix_inverse(standard_to_coxeter, prime)

    base_matching = fixed_matching(parent)
    matchings = sorted(
        {c406.matching_image(element, base_matching) for element in full_group}
    )
    assert len(matchings) == 14
    points = sorted(
        {
            c341.normalize(vector, prime)
            for vector in itertools.product(range(prime), repeat=3)
            if vector != (0, 0, 0)
        }
    )
    assert len(points) == prime * prime + prime + 1 == 57

    opposite = sorted(
        {conjugate(element, parent) for element in full_group - psl_group},
        key=lambda group: sorted(group),
    )
    assert len(opposite) == 7

    seam_records = []
    for other in opposite:
        common_permutations = set(parent) & set(other)
        seam_type = {6: "S3", 8: "D8"}[len(common_permutations)]
        swaps = sorted(
            element
            for element in full_group - psl_group
            if conjugate(element, parent) == other
            and conjugate(element, other) == frozenset(parent)
            and c406.compose(element, element) == identity
        )
        assert len(swaps) == 4
        common_lifts = {
            canonical_so3_lift(element) for element in common_permutations
        }

        def point_action(matrix, point):
            return c341.normalize(c341.mat_vec(matrix, point, prime), prime)

        point_index = {point: index for index, point in enumerate(points)}
        unseen = set(range(len(points)))
        raw_orbits = []
        while unseen:
            seed = min(unseen)
            part = {
                point_index[point_action(matrix, points[seed])]
                for matrix in common_lifts
            }
            unseen -= part
            raw_orbits.append(sorted(part))
        raw_orbits.sort(key=lambda part: (len(part), part[0]))
        point_orbits = [
            sorted(points[position] for position in part) for part in raw_orbits
        ]

        exchange_summaries = []
        for exchange in swaps:
            exchange_lift = canonical_so3_lift(exchange)
            orbit_lookup = {}
            for index, orbit in enumerate(point_orbits):
                for point in orbit:
                    orbit_lookup[point] = index
            orbit_permutation = [
                orbit_lookup[point_action(exchange_lift, orbit[0])]
                for orbit in point_orbits
            ]
            assert all(
                orbit_permutation[orbit_permutation[index]] == index
                for index in range(len(point_orbits))
            )
            odd_pairs = [
                (index, image)
                for index, image in enumerate(orbit_permutation)
                if index < image
            ]
            assert len(odd_pairs) == 4
            m_odd, n_matrix, pair_sizes = odd_block_data(
                point_orbits, odd_pairs, prime
            )

            matching_rows = []
            profile_map = {}
            for matching in matchings:
                zero_set, depth_by_point, poles = matching_geometry(
                    matching, endpoints, coxeter_to_standard, points, prime
                )
                record = polar_records(
                    points,
                    point_orbits,
                    odd_pairs,
                    zero_set,
                    depth_by_point,
                    poles,
                    len(matching),
                    prime,
                )
                transformed = apply_matrix(n_matrix, record["depth_profile"])
                assert transformed == record["polar_profile"]
                assert apply_matrix(n_matrix, record["polar_profile"]) == [
                    prime * value for value in record["depth_profile"]
                ]
                matching_rows.append(
                    {
                        "matching": [list(pair) for pair in matching],
                        "depth_profile": record["depth_profile"],
                        "polar_profile": record["polar_profile"],
                        "pole_profile": record["pole_profile"],
                        "deep_profile": record["deep_profile"],
                        "zero_locus_size": record["zero_locus_size"],
                    }
                )
                profile_map[matching] = (
                    tuple(record["depth_profile"]),
                    tuple(record["polar_profile"]),
                )

            exchange_matching_action = {
                matching: c406.matching_image(exchange, matching)
                for matching in matchings
            }
            for matching in matchings:
                depth, polar = profile_map[matching]
                mate_depth, mate_polar = profile_map[exchange_matching_action[matching]]
                assert mate_depth == tuple(-value for value in depth)
                assert mate_polar == tuple(-value for value in polar)

            depth_rows = [row["depth_profile"] for row in matching_rows]
            polar_rows = [row["polar_profile"] for row in matching_rows]
            exchange_summaries.append(
                {
                    "exchange_permutation": list(exchange),
                    "odd_pair_projective_sizes": pair_sizes,
                    "odd_pair_orbit_representatives": [
                        [list(min(point_orbits[left])), list(min(point_orbits[right]))]
                        for left, right in odd_pairs
                    ],
                    "m_odd": m_odd,
                    "n_matrix": n_matrix,
                    "distinct_depth_profiles": len({tuple(r) for r in depth_rows}),
                    "distinct_polar_profiles": len({tuple(r) for r in polar_rows}),
                    "joint_depth_polar_rank_mod_q": c406.rank(
                        [[v % prime for v in row] for row in depth_rows + polar_rows],
                        prime,
                    ),
                    "matching_table_sha256": sha256_of(matching_rows),
                    "representative_rows": matching_rows[:2],
                }
            )

        seam_records.append(
            {
                "seam_type": seam_type,
                "common_group_order": len(common_permutations),
                "point_orbit_sizes": [len(orbit) for orbit in point_orbits],
                "exchanges": exchange_summaries,
            }
        )

    assert Counter(record["seam_type"] for record in seam_records) == {
        "S3": 4,
        "D8": 3,
    }
    return {
        "field": prime,
        "secant_count": 4,
        "matching_count": len(matchings),
        "seam_type_counts": {"S3": 4, "D8": 3},
        "seams": seam_records,
    }


def build():
    c341 = load_module("c341_for_c415", C341_PATH, C341_SHA256)
    c406 = load_module("c406_for_c415", C406_PATH, C406_SHA256)
    h3 = h3_certificate(c341, c406)
    b3 = b3_certificate(c341, c406)
    return {
        "schema": "c415-odd-fourier-polar-duality-v1",
        "theorem": (
            "For H3/q=11 and every B3/q=7 seam exchange, the ordinary qz-ell odd "
            "Fourier block satisfies M_odd = q N^T with N the signed "
            "perpendicular-incidence matrix between odd orbit pairs, N^2 = q I, "
            "N D(M) = S(M) for every matching M, and "
            "S_i = q Pole_i - Deep_i geometrically."
        ),
        "H3": h3,
        "B3": b3,
        "A3_control": {
            "field": 5,
            "reason": (
                "the S4 parent meets the outer determinant coset, so there is no "
                "two-sheet exchange, no odd orbit pairs, and the duality "
                "statement is vacuous; A3 remains the nonsplitting control"
            ),
        },
        "trusted_inputs": {
            C341_PATH.name: C341_SHA256,
            C406_PATH.name: C406_SHA256,
            C406_CERT_PATH.name: C406_CERT_SHA256,
            SCOUT_PATH.name: SCOUT_SHA256,
            C411_PATH.name: C411_SHA256,
            C378_CERT_PATH.name: C378_CERT_SHA256,
        },
        "verdict": (
            "THEOREM; THE ODD FOURIER IMAGE OF THE DEPTH PROFILE IS THE SIGNED "
            "POLAR ZERO-DEPTH PROFILE, WITH AN INTEGRAL INCIDENCE SQUARE ROOT OF q "
            "AND AN EXACT POLE/DEEP-POINT DUAL FACTORIZATION"
        ),
        "boundary": (
            "No twisted weight-4/6 section identity, seam selector, modular "
            "lattice comparison, or novelty claim is certified; the adjointness "
            "core is classical double counting."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(build())
    if args.write:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT.name} ({len(payload)} bytes)")
        return
    assert OUTPUT.read_bytes() == payload, "stale certificate: rerun with --write"
    print("C415 odd-Fourier polar duality certificate OK")


if __name__ == "__main__":
    main()
