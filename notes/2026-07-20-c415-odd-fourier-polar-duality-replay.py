#!/usr/bin/env python3
"""C415 independent replay in the standard Veronese frame.

Independence from the primary checker:
- group elements are rebuilt as 2x2 homographies from their parameter
  permutations and lifted to the plane by the symmetric square, with no
  frame_map or Coxeter-frame matrix reuse;
- perpendicularity is the Veronese conic polar form 2 y y' - x z' - z x'
  instead of the transported dot product;
- secant poles are computed through the inverse polar Gram matrix;
- the transformed side is evaluated through odd differences of the full
  eigenmatrix image E c(M) (qz-ell rule on every orbit class), never through
  the primary's divided incidence matrix N;
- orbit alignment with the primary uses only its stored representative
  points and the frozen frame bridges, then every profile table must agree.
"""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
PRIMARY_JSON = HERE / "2026-07-20-c415-odd-fourier-polar-duality.json"
C406_PATH = HERE / "2026-07-20-c406-matching-module.py"
C406_SHA256 = "a1fef3680a7d12d64a1c483e7032cbaa3a1f575883b2bd8b964d58aa8ac38d51"
C406_CERT_PATH = HERE / "2026-07-20-c406-matching-module.json"
C406_CERT_SHA256 = "e39bf131f3d818dfbcbeb1f2d4dfa9a6ba7645c41cdd6fe9600957c0fe1dc4b2"
SCOUT_PATH = HERE / "2026-07-20-c406-matching-orbit-scout.json"
SCOUT_SHA256 = "fec533bb91f864100ebf5875952244d9d9e03ed69a0abda767360907a55bb246"
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


def load_json(path: Path, expected_sha256: str | None = None):
    if expected_sha256 is not None:
        assert hashlib.sha256(path.read_bytes()).hexdigest() == expected_sha256
    return json.loads(path.read_text())


def polar_gram(prime):
    return ((0, 0, -1 % prime), (0, 2, 0), ((-1) % prime, 0, 0))


def polar_gram_inverse(prime):
    inv2 = pow(2, -1, prime)
    return ((0, 0, (-1) % prime), (0, inv2, 0), ((-1) % prime, 0, 0))


def gram_perp(gram, left, right, prime):
    return (
        sum(gram[i][j] * left[i] * right[j] for i in range(3) for j in range(3))
        % prime
        == 0
    )


def normalize(vector, prime):
    pivot = next(value for value in vector if value % prime)
    scale = pow(pivot, -1, prime)
    return tuple(value * scale % prime for value in vector)


def matrix_vector(matrix, vector, prime):
    return tuple(
        sum(matrix[row][column] * vector[column] for column in range(3)) % prime
        for row in range(3)
    )


def homography_from_permutation(parameters, permutation, prime):
    """The unique 2x2 matrix realizing the parameter permutation on P^1."""

    def frame_matrix(p0, p1, p2):
        # columns alpha*p0, beta*p1 with alpha p0 + beta p1 = p2
        determinant = (p0[0] * p1[1] - p0[1] * p1[0]) % prime
        assert determinant
        inverse = pow(determinant, -1, prime)
        alpha = (p2[0] * p1[1] - p2[1] * p1[0]) * inverse % prime
        beta = (p0[0] * p2[1] - p0[1] * p2[0]) * inverse % prime
        assert alpha and beta
        return (
            (alpha * p0[0] % prime, beta * p1[0] % prime),
            (alpha * p0[1] % prime, beta * p1[1] % prime),
        )

    def invert2(matrix):
        determinant = (matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]) % prime
        inverse = pow(determinant, -1, prime)
        return (
            (matrix[1][1] * inverse % prime, -matrix[0][1] * inverse % prime),
            (-matrix[1][0] * inverse % prime, matrix[0][0] * inverse % prime),
        )

    def multiply2(left, right):
        return tuple(
            tuple(
                sum(left[i][k] * right[k][j] for k in range(2)) % prime
                for j in range(2)
            )
            for i in range(2)
        )

    source = frame_matrix(parameters[0], parameters[1], parameters[2])
    target = frame_matrix(
        parameters[permutation[0]],
        parameters[permutation[1]],
        parameters[permutation[2]],
    )
    matrix = multiply2(target, invert2(source))
    for index, (s, t) in enumerate(parameters):
        image = (
            (matrix[0][0] * s + matrix[0][1] * t) % prime,
            (matrix[1][0] * s + matrix[1][1] * t) % prime,
        )
        expected = parameters[permutation[index]]
        cross = (image[0] * expected[1] - image[1] * expected[0]) % prime
        assert cross == 0 and image != (0, 0)
    return matrix


def symmetric_square(matrix, prime):
    (a, b), (c, d) = matrix
    return (
        (a * a % prime, 2 * a * b % prime, b * b % prime),
        (a * c % prime, (a * d + b * c) % prime, b * d % prime),
        (c * c % prime, 2 * c * d % prime, d * d % prime),
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


def orbit_partition(lifts, points, prime):
    point_index = {point: index for index, point in enumerate(points)}
    unseen = set(range(len(points)))
    orbits = []
    while unseen:
        seed = min(unseen)
        part = {
            point_index[normalize(matrix_vector(matrix, points[seed], prime), prime)]
            for matrix in lifts
        }
        unseen -= part
        orbits.append(sorted(points[position] for position in part))
    return orbits


def eigenmatrix_rows(point_orbits, gram, prime):
    """qz-ell rule per orbit class with the polar-form perpendicularity."""
    rows = []
    for orbit in point_orbits:
        representative = orbit[0]
        row = []
        for target in point_orbits:
            zero_lines = sum(
                gram_perp(gram, representative, point, prime) for point in target
            )
            row.append(prime * zero_lines - len(target))
        rows.append(row)
    return rows


def profile_tables(
    matchings,
    endpoints,
    point_orbits,
    odd_pairs,
    gram,
    gram_inverse,
    prime,
):
    tables = []
    secant_count = (prime + 1) // 2
    for matching in matchings:
        lines = secant_lines(endpoints, matching, prime)
        depth_by_point = {}
        for orbit in point_orbits:
            for point in orbit:
                depth = sum(
                    sum(a * b for a, b in zip(line, point)) % prime == 0
                    for line in lines
                )
                if depth:
                    depth_by_point[point] = depth
        zero_set = set(depth_by_point)
        zero_counts = [
            sum(point in zero_set for point in orbit) for orbit in point_orbits
        ]
        depth_profile = [
            zero_counts[left] - zero_counts[right] for left, right in odd_pairs
        ]
        polar_sums = [
            sum(
                sum(gram_perp(gram, zero, point, prime) for point in orbit)
                for zero in zero_set
            )
            for orbit in point_orbits
        ]
        polar_profile = [
            polar_sums[left] - polar_sums[right] for left, right in odd_pairs
        ]
        poles = [
            normalize(matrix_vector(gram_inverse, line, prime), prime)
            for line in lines
        ]
        pole_counts = [
            sum(point in orbit for point in poles) for orbit in point_orbits
        ]
        pole_profile = [
            pole_counts[left] - pole_counts[right] for left, right in odd_pairs
        ]
        deep_points = [
            (point, depth - 1)
            for point, depth in depth_by_point.items()
            if depth >= 2
        ]
        deep_sums = [
            sum(
                weight * sum(gram_perp(gram, point, deep, prime) for point in orbit)
                for deep, weight in deep_points
            )
            for orbit in point_orbits
        ]
        deep_profile = [
            deep_sums[left] - deep_sums[right] for left, right in odd_pairs
        ]
        assert all(
            polar_profile[i] == prime * pole_profile[i] - deep_profile[i]
            for i in range(4)
        )
        tables.append(
            {
                "matching": matching,
                "zero_counts": zero_counts,
                "depth_profile": depth_profile,
                "polar_profile": polar_profile,
                "pole_profile": pole_profile,
                "deep_profile": deep_profile,
                "zero_locus_size": len(zero_set),
            }
        )
    return tables


def verify_odd_transform(tables, eigenmatrix, odd_pairs, prime):
    """The qz-ell theorem, phrased through raw eigenmatrix entries only.

    Transposed odd block action: sum_j (E[l_j][l_i]-E[l_j][r_i]) D_j = q S_i
    and the same action sends S to q^2 D.  The odd row differences of the
    full count transform E c(M) reproduce the untransposed M_odd D as a
    numerical check of the J-parity lemma.
    """
    for record in tables:
        counts = record["zero_counts"]
        polar = record["polar_profile"]
        depth = record["depth_profile"]
        image = [
            sum(row[s] * counts[s] for s in range(len(counts)))
            for row in eigenmatrix
        ]
        for i, (l_i, r_i) in enumerate(odd_pairs):
            transposed_on_depth = sum(
                (eigenmatrix[l_j][l_i] - eigenmatrix[l_j][r_i]) * depth[j]
                for j, (l_j, _r_j) in enumerate(odd_pairs)
            )
            assert transposed_on_depth == prime * polar[i]
            transposed_on_polar = sum(
                (eigenmatrix[l_j][l_i] - eigenmatrix[l_j][r_i]) * polar[j]
                for j, (l_j, _r_j) in enumerate(odd_pairs)
            )
            assert transposed_on_polar == prime * prime * depth[i]
            row_difference = sum(
                (eigenmatrix[l_i][l_j] - eigenmatrix[l_i][r_j]) * depth[j]
                for j, (l_j, r_j) in enumerate(odd_pairs)
            )
            assert image[l_i] - image[r_i] == row_difference


def align_odd_pairs(point_orbits, primary_pairs, to_standard, prime):
    """Map the primary's stored odd-pair representatives onto replay orbits."""
    orbit_lookup = {}
    for index, orbit in enumerate(point_orbits):
        for point in orbit:
            orbit_lookup[point] = index
    aligned = []
    for left_point, right_point in primary_pairs:
        left_standard = normalize(
            matrix_vector(to_standard, tuple(left_point), prime), prime
        )
        right_standard = normalize(
            matrix_vector(to_standard, tuple(right_point), prime), prime
        )
        aligned.append((orbit_lookup[left_standard], orbit_lookup[right_standard]))
    return aligned


def stabilizer(c406, group, matching):
    return frozenset(
        element
        for element in group
        if c406.matching_image(element, matching) == matching
    )


def replay_h3(c406, primary):
    prime = 11
    scout = load_json(SCOUT_PATH, SCOUT_SHA256)
    c406_certificate = load_json(C406_CERT_PATH, C406_CERT_SHA256)
    record_h3 = next(item for item in scout["types"] if item["type"] == "H3")
    bridge = next(
        item for item in c406_certificate["types"] if item["type"] == "H3"
    )["outer_sheet_sign"]["c378_depth_fourier_bridge"]
    standard_to_h3 = bridge["standard_to_h3_projectivity"]
    h3_to_standard = c406.matrix_inverse(standard_to_h3, prime)

    conic, parameters = c406.C399.conic_parameterization(prime)
    endpoints = tuple(parameters)
    full_group, psl_group = c406.full_pgl(prime, endpoints)
    base_matching = tuple(tuple(pair) for pair in record_h3["coxeter_invariant_matching"])
    matchings = sorted(
        {c406.matching_image(element, base_matching) for element in full_group}
    )
    plus_sheet = {c406.matching_image(element, base_matching) for element in psl_group}
    base_stabilizer = stabilizer(c406, full_group, base_matching)
    assert len(base_stabilizer) == 60

    # The golden mate is an arithmetic datum: five distinct minus-sheet
    # matchings meet the base stabilizer in an A4 with identical orbit
    # combinatorics, so the mate is selected by the frozen C378 golden map J
    # acting on the C399 conic points, not by intersection combinatorics.
    c378_certificate = load_json(C378_CERT_PATH, C378_CERT_SHA256)
    golden_map = c378_certificate["golden_map_J"]
    conic_index = {point: index for index, point in enumerate(conic)}
    j_action = tuple(
        conic_index[
            normalize(matrix_vector(golden_map, tuple(point), prime), prime)
        ]
        for point in conic
    )
    mate = c406.matching_image(j_action, base_matching)
    assert mate != base_matching and mate not in plus_sheet
    common_permutations = base_stabilizer & stabilizer(c406, full_group, mate)
    assert len(common_permutations) == 12

    points = sorted(
        {
            normalize(vector, prime)
            for vector in itertools.product(range(prime), repeat=3)
            if vector != (0, 0, 0)
        }
    )
    lifts = {
        symmetric_square(
            homography_from_permutation(endpoints, permutation, prime), prime
        )
        for permutation in common_permutations
    }
    point_orbits = orbit_partition(lifts, points, prime)
    gram = polar_gram(prime)
    gram_inverse = polar_gram_inverse(prime)

    odd_pairs = align_odd_pairs(
        point_orbits,
        primary["H3"]["odd_pair_orbit_representatives"],
        h3_to_standard,
        prime,
    )
    assert all(left != right for left, right in odd_pairs)

    identity = tuple(range(prime + 1))
    exchanges = [
        element
        for element in full_group
        if element not in psl_group
        and c406.matching_image(element, base_matching) == mate
        and c406.compose(element, element) == identity
        and frozenset(
            c406.compose(c406.compose(element, member), c406.inverse(element))
            for member in common_permutations
        )
        == frozenset(common_permutations)
    ]
    assert exchanges
    for exchange in exchanges:
        exchange_lift = symmetric_square(
            homography_from_permutation(endpoints, exchange, prime), prime
        )
        orbit_lookup = {}
        for index, orbit in enumerate(point_orbits):
            for point in orbit:
                orbit_lookup[point] = index
        for left, right in odd_pairs:
            image = orbit_lookup[
                normalize(
                    matrix_vector(exchange_lift, point_orbits[left][0], prime), prime
                )
            ]
            assert image == right

    eigenmatrix = eigenmatrix_rows(point_orbits, gram, prime)
    tables = profile_tables(
        matchings, endpoints, point_orbits, odd_pairs, gram, gram_inverse, prime
    )
    verify_odd_transform(tables, eigenmatrix, odd_pairs, prime)

    primary_rows = primary["H3"]["matchings"]
    assert len(primary_rows) == len(tables) == 22
    for row, primary_row in zip(tables, primary_rows):
        assert [list(pair) for pair in row["matching"]] == primary_row["matching"]
        for key in ("depth_profile", "polar_profile", "pole_profile", "deep_profile"):
            assert row[key] == primary_row[key], (key, row["matching"])
        assert row["zero_locus_size"] == primary_row["zero_locus_size"]
    print("H3 replay OK: 22 matchings, all profile tables agree")


def replay_b3(c406, primary):
    prime = 7
    conic, parameters = c406.C399.conic_parameterization(prime)
    endpoints = tuple(parameters)
    full_group, psl_group = c406.full_pgl(prime, endpoints)
    identity = tuple(range(prime + 1))
    points = sorted(
        {
            normalize(vector, prime)
            for vector in itertools.product(range(prime), repeat=3)
            if vector != (0, 0, 0)
        }
    )
    gram = polar_gram(prime)
    gram_inverse = polar_gram_inverse(prime)

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

    parent_group = c406.coxeter_group("B3", prime, conic)
    parent_fixed = [
        matching
        for matching in perfect_matchings(tuple(range(prime + 1)))
        if all(
            c406.matching_image(element, matching) == matching
            for element in parent_group
        )
    ]
    assert len(parent_fixed) == 1
    base_matching = parent_fixed[0]
    matchings = sorted(
        {c406.matching_image(element, base_matching) for element in full_group}
    )
    assert len(matchings) == 14
    base_stabilizer = stabilizer(c406, full_group, base_matching)
    assert len(base_stabilizer) == 24

    def conjugate(element, group):
        inv = c406.inverse(element)
        return frozenset(
            c406.compose(c406.compose(element, member), inv) for member in group
        )

    opposite = sorted(
        {conjugate(element, base_stabilizer) for element in full_group - psl_group},
        key=lambda group: sorted(group),
    )
    assert len(opposite) == 7

    # Coxeter-frame transport for aligning against the primary's stored
    # representatives: an independent plane frame solver, no c341 reuse.
    standard_conic = [
        (left * left % prime, left * right % prime, right * right % prime)
        for left, right in endpoints
    ]

    def plane_frame_map(sources, targets):
        rows = []
        for point_position in range(4):
            source = sources[point_position]
            target = targets[point_position]
            for output_coordinate in range(3):
                row = [0] * 13
                for input_coordinate in range(3):
                    row[3 * output_coordinate + input_coordinate] = source[
                        input_coordinate
                    ]
                row[9 + point_position] = -target[output_coordinate] % prime
                rows.append(row)
        solutions = c406.nullspace(rows, prime)
        assert len(solutions) == 1
        return [solutions[0][3 * row : 3 * row + 3] for row in range(3)]

    coxeter_to_standard = plane_frame_map(conic[:4], standard_conic[:4])

    for seam_index, other in enumerate(opposite):
        common_permutations = set(base_stabilizer) & set(other)
        seam_record = primary["B3"]["seams"][seam_index]
        assert seam_record["common_group_order"] == len(common_permutations)
        swaps = sorted(
            element
            for element in full_group - psl_group
            if conjugate(element, frozenset(base_stabilizer)) == other
            and conjugate(element, other) == frozenset(base_stabilizer)
            and c406.compose(element, element) == identity
        )
        assert len(swaps) == 4
        lifts = {
            symmetric_square(
                homography_from_permutation(endpoints, permutation, prime), prime
            )
            for permutation in common_permutations
        }
        point_orbits = orbit_partition(lifts, points, prime)
        assert sorted(len(orbit) for orbit in point_orbits) == sorted(
            seam_record["point_orbit_sizes"]
        )
        eigenmatrix = eigenmatrix_rows(point_orbits, gram, prime)

        for exchange_index, exchange in enumerate(swaps):
            summary = seam_record["exchanges"][exchange_index]
            assert summary["exchange_permutation"] == list(exchange)
            odd_pairs = align_odd_pairs(
                point_orbits,
                summary["odd_pair_orbit_representatives"],
                coxeter_to_standard,
                prime,
            )
            exchange_lift = symmetric_square(
                homography_from_permutation(endpoints, exchange, prime), prime
            )
            orbit_lookup = {}
            for index, orbit in enumerate(point_orbits):
                for point in orbit:
                    orbit_lookup[point] = index
            for left, right in odd_pairs:
                image = orbit_lookup[
                    normalize(
                        matrix_vector(exchange_lift, point_orbits[left][0], prime),
                        prime,
                    )
                ]
                assert image == right

            tables = profile_tables(
                matchings,
                endpoints,
                point_orbits,
                odd_pairs,
                gram,
                gram_inverse,
                prime,
            )
            verify_odd_transform(tables, eigenmatrix, odd_pairs, prime)
            rebuilt = [
                {
                    "matching": [list(pair) for pair in row["matching"]],
                    "depth_profile": row["depth_profile"],
                    "polar_profile": row["polar_profile"],
                    "pole_profile": row["pole_profile"],
                    "deep_profile": row["deep_profile"],
                    "zero_locus_size": row["zero_locus_size"],
                }
                for row in tables
            ]
            digest = hashlib.sha256(
                json.dumps(rebuilt, separators=(",", ":"), sort_keys=True).encode()
            ).hexdigest()
            assert digest == summary["matching_table_sha256"], (
                seam_index,
                exchange_index,
            )
    print("B3 replay OK: 7 seams x 4 exchanges, all table digests agree")


def main():
    primary = json.loads(PRIMARY_JSON.read_text())
    assert primary["schema"] == "c415-odd-fourier-polar-duality-v1"
    c406 = load_module("c406_for_c415_replay", C406_PATH, C406_SHA256)
    replay_h3(c406, primary)
    replay_b3(c406, primary)
    print("C415 independent replay OK")


if __name__ == "__main__":
    main()
