#!/usr/bin/env python3
"""Exact projective and conic profile of the exceptional q=19 residue."""

from collections import Counter
from itertools import combinations, permutations
import json
import sys


Q = 19


def inv(x):
    return pow(x % Q, Q - 2, Q)


def norm(p):
    p = tuple(x % Q for x in p)
    z = inv(next(x for x in p if x))
    return tuple(z * x % Q for x in p)


def det(a, b, c):
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % Q


def qrow(p):
    x, y, z = p
    return (x * x % Q, y * y % Q, z * z % Q,
            x * y % Q, x * z % Q, y * z % Q)


def kernel_vector(rows):
    a = [list(row) for row in rows]
    pivot_row = [-1] * 6
    rank = 0
    for col in range(6):
        pivot = next((i for i in range(rank, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        z = inv(a[rank][col])
        a[rank] = [z * x % Q for x in a[rank]]
        for i in range(len(a)):
            if i != rank and a[i][col]:
                w = a[i][col]
                a[i] = [(x - w * y) % Q for x, y in zip(a[i], a[rank])]
        pivot_row[col] = rank
        rank += 1
    free = next(col for col in range(5, -1, -1) if pivot_row[col] == -1)
    out = [0] * 6
    out[free] = 1
    for col in range(5, -1, -1):
        if pivot_row[col] == -1:
            continue
        out[col] = -sum(
            a[pivot_row[col]][j] * out[j] for j in range(col + 1, 6)
        ) % Q
    z = inv(next(x for x in out if x))
    return tuple(z * x % Q for x in out)


def evaluate(form, p):
    return sum(a * b for a, b in zip(form, qrow(p))) % Q


def conic_tangent(form, p):
    x, y, z = p
    a, b, c, d, e, f = form
    return norm((
        2 * a * x + d * y + e * z,
        2 * b * y + d * x + f * z,
        2 * c * z + e * x + f * y,
    ))


def on_line(line, p):
    return sum(a * b for a, b in zip(line, p)) % Q == 0


def mat_inv(m):
    a = [list(row) + [int(i == j) for j in range(3)] for i, row in enumerate(m)]
    for col in range(3):
        pivot = next(i for i in range(col, 3) if a[i][col])
        a[col], a[pivot] = a[pivot], a[col]
        z = inv(a[col][col])
        a[col] = [z * x % Q for x in a[col]]
        for i in range(3):
            if i != col and a[i][col]:
                w = a[i][col]
                a[i] = [(x - w * y) % Q for x, y in zip(a[i], a[col])]
    return tuple(tuple(row[3:]) for row in a)


def mat_mul(a, b):
    return tuple(tuple(
        sum(a[i][k] * b[k][j] for k in range(3)) % Q
        for j in range(3)
    ) for i in range(3))


def mat_vec(a, v):
    return tuple(sum(a[i][j] * v[j] for j in range(3)) % Q for i in range(3))


def columns(vs):
    return tuple(tuple(vs[j][i] for j in range(3)) for i in range(3))


def frame_normalizer(frame):
    basis = columns(frame[:3])
    basis_inv = mat_inv(basis)
    fourth = mat_vec(basis_inv, frame[3])
    diagonal = tuple(
        tuple(inv(fourth[i]) if i == j else 0 for j in range(3))
        for i in range(3)
    )
    return mat_mul(diagonal, basis_inv)


def projectivity(source_frame, target_frame):
    return mat_mul(mat_inv(frame_normalizer(target_frame)),
                   frame_normalizer(source_frame))


def image_set(matrix, points):
    return frozenset(norm(mat_vec(matrix, p)) for p in points)


def normalized_matrix(matrix):
    flat = [x for row in matrix for x in row]
    z = inv(next(x for x in flat if x))
    return tuple(tuple(z * x % Q for x in row) for row in matrix)


IDENTITY = ((1, 0, 0), (0, 1, 0), (0, 0, 1))


def matrix_power(matrix, exponent):
    out = IDENTITY
    for _ in range(exponent):
        out = mat_mul(out, matrix)
    return out


def scalar_ratio(a, b):
    pivot = next(
        (b[i][j] for i in range(3) for j in range(3) if b[i][j]), None
    )
    if pivot is None:
        return None
    location = next(
        (i, j) for i in range(3) for j in range(3) if b[i][j]
    )
    scalar = a[location[0]][location[1]] * inv(pivot) % Q
    if all(a[i][j] == scalar * b[i][j] % Q
           for i in range(3) for j in range(3)):
        return scalar
    return None


def projective_order(matrix):
    for exponent in range(1, 28):
        if scalar_ratio(matrix_power(matrix, exponent), IDENTITY) is not None:
            return exponent
    raise RuntimeError("projective order exceeds search bound")


def automorphisms(source, required_sets):
    source_frame = tuple(source[:4])
    target_ground = required_sets[0]
    expected = [frozenset(s) for s in required_sets]
    found = {}
    for target_frame in permutations(target_ground, 4):
        matrix = normalized_matrix(projectivity(source_frame, target_frame))
        if all(image_set(matrix, s) == target for s, target in zip(required_sets, expected)):
            found[matrix] = [
                [target_ground.index(norm(mat_vec(matrix, p))) for p in source]
            ]
    return sorted(found)


def equivalences(source, target):
    source_frame = tuple(source[:4])
    target_set = frozenset(target)
    found = set()
    for target_frame in permutations(target, 4):
        matrix = normalized_matrix(projectivity(source_frame, target_frame))
        if image_set(matrix, source) == target_set:
            found.add(matrix)
    return sorted(found)


def point_type(p, conic_points):
    if p in conic_points:
        return "on"
    secants = sum(
        det(a, b, p) == 0 for a, b in combinations(conic_points, 2)
    )
    if secants == (Q + 1) // 2:
        return "internal"
    if secants == (Q - 1) // 2:
        return "external"
    raise RuntimeError("invalid conic point type")


def line_type_histogram(a_set, u_set, points):
    lines = {}
    for p, q in combinations(points, 2):
        line = norm((
            p[1] * q[2] - p[2] * q[1],
            p[2] * q[0] - p[0] * q[2],
            p[0] * q[1] - p[1] * q[0],
        ))
        lines[line] = None
    histogram = Counter()
    for line in lines:
        a_count = sum(
            (line[0] * p[0] + line[1] * p[1] + line[2] * p[2]) % Q == 0
            for p in a_set
        )
        u_count = sum(
            (line[0] * p[0] + line[1] * p[1] + line[2] * p[2]) % Q == 0
            for p in u_set
        )
        histogram[a_count, u_count] += 1
    return histogram


def secant_multiplicities(arc, points):
    chosen = set(arc)
    counts = Counter()
    point_counts = {}
    for p in points:
        if p in chosen:
            continue
        r = sum(det(a, b, p) == 0 for a, b in combinations(arc, 2))
        counts[r] += 1
        point_counts[p] = r
    return counts, point_counts


def cubic_row(p):
    x, y, z = p
    return (
        x ** 3 % Q, y ** 3 % Q, z ** 3 % Q,
        x * x * y % Q, x * x * z % Q,
        y * y * x % Q, y * y * z % Q,
        z * z * x % Q, z * z * y % Q,
        x * y * z % Q,
    )


def linear_kernel_basis(rows, columns_count):
    a = [[x % Q for x in row] for row in rows]
    pivots = []
    rank = 0
    for col in range(columns_count):
        pivot = next((i for i in range(rank, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        z = inv(a[rank][col])
        a[rank] = [z * x % Q for x in a[rank]]
        for i in range(len(a)):
            if i != rank and a[i][col]:
                w = a[i][col]
                a[i] = [(x - w * y) % Q for x, y in zip(a[i], a[rank])]
        pivots.append(col)
        rank += 1
    free = [col for col in range(columns_count) if col not in pivots]
    basis = []
    for free_col in free:
        vector = [0] * columns_count
        vector[free_col] = 1
        for row, col in reversed(list(enumerate(pivots))):
            vector[col] = -sum(
                a[row][j] * vector[j] for j in range(col + 1, columns_count)
            ) % Q
        z = inv(next(x for x in vector if x))
        basis.append(tuple(z * x % Q for x in vector))
    return basis


def evaluate_cubic(form, p):
    return sum(a * b for a, b in zip(form, cubic_row(p))) % Q


def semi_invariant_multiplier(form, matrix, points):
    p = next(p for p in points if evaluate_cubic(form, p))
    multiplier = (
        evaluate_cubic(form, mat_vec(matrix, p))
        * inv(evaluate_cubic(form, p))
    ) % Q
    if not all(
        evaluate_cubic(form, mat_vec(matrix, x))
        == multiplier * evaluate_cubic(form, x) % Q
        for x in points
    ):
        raise RuntimeError("cubic is not a semi-invariant")
    return multiplier


def add_labels(a, b):
    return ((a[0] + b[0]) % 3, (a[1] + b[1]) % 3)


def sub_labels(a, b):
    return ((a[0] - b[0]) % 3, (a[1] - b[1]) % 3)


def neg_label(a):
    return ((-a[0]) % 3, (-a[1]) % 3)


def direction_label(a, b):
    difference = sub_labels(b, a)
    negative = neg_label(difference)
    return min(difference, negative)


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: q19-residue-profile.py INPUT.json OUTPUT.json")
    with open(sys.argv[1], encoding="ascii") as source:
        data = json.load(source)
    a_set = [tuple(p) for p in data["arc_survivor"]]
    u_set = [tuple(p) for p in data["arc_survivor_uncovered"]]
    points = sorted({
        norm((x, y, z))
        for x in range(Q) for y in range(Q) for z in range(Q)
        if x or y or z
    })

    conics = Counter()
    conic_records = {}
    subset_records = []
    for subset in combinations(range(len(u_set)), 5):
        form = kernel_vector([qrow(u_set[i]) for i in subset])
        conic_points = tuple(p for p in points if evaluate(form, p) == 0)
        if len(conic_points) != Q + 1:
            raise RuntimeError("five-subset conic is singular")
        conics[form] += 1
        if form not in conic_records:
            u_on = tuple(i for i, p in enumerate(u_set) if p in conic_points)
            a_types = Counter(point_type(p, conic_points) for p in a_set)
            u_types = Counter(point_type(p, conic_points) for p in u_set)
            conic_records[form] = {
                "form": list(form),
                "u_on": list(u_on),
                "u_on_count": len(u_on),
                "a_types": dict(sorted(a_types.items())),
                "u_types": dict(sorted(u_types.items())),
            }
        subset_records.append({
            "subset": list(subset),
            "form": list(form),
            "u_on_count": conic_records[form]["u_on_count"],
            "a_on_count": conic_records[form]["a_types"].get("on", 0),
        })

    a_aut = automorphisms(a_set, [a_set])
    u_aut = automorphisms(u_set, [u_set])
    pair_aut = automorphisms(a_set, [a_set, u_set])
    a_to_u = equivalences(a_set, u_set)
    u_to_a = equivalences(u_set, a_set)
    a_mult, a_point_counts = secant_multiplicities(a_set, points)
    u_mult, u_point_counts = secant_multiplicities(u_set, points)
    line_hist = line_type_histogram(a_set, u_set, points)

    nonidentity = [matrix for matrix in pair_aut if matrix != IDENTITY]
    generator_g = nonidentity[0]
    g_subgroup = {
        normalized_matrix(matrix_power(generator_g, exponent))
        for exponent in range(3)
    }
    generator_h = next(matrix for matrix in nonidentity if matrix not in g_subgroup)
    group_matrices = {
        (i, j): normalized_matrix(
            mat_mul(matrix_power(generator_g, i), matrix_power(generator_h, j))
        )
        for i in range(3) for j in range(3)
    }
    if set(group_matrices.values()) != set(pair_aut):
        raise RuntimeError("chosen generators do not generate the pair stabilizer")
    a_by_label = {
        label: norm(mat_vec(matrix, a_set[0]))
        for label, matrix in group_matrices.items()
    }
    u_by_label = {
        label: norm(mat_vec(matrix, u_set[0]))
        for label, matrix in group_matrices.items()
    }
    if set(a_by_label.values()) != set(a_set) or set(u_by_label.values()) != set(u_set):
        raise RuntimeError("chosen generators do not act regularly")
    a_labels = {point: label for label, point in a_by_label.items()}
    u_labels = {point: label for label, point in u_by_label.items()}

    chord_direction_profile = {}
    for direction in sorted({
        direction_label(x, y)
        for x, y in combinations(group_matrices, 2)
    }):
        hit_count = 0
        offsets = Counter()
        for x, y in combinations(group_matrices, 2):
            if direction_label(x, y) != direction:
                continue
            hits = [
                a for a in a_set
                if det(u_by_label[x], u_by_label[y], a) == 0
            ]
            if hits:
                if len(hits) != 1:
                    raise RuntimeError("a U-secant contains multiple A-points")
                hit_count += 1
                third = neg_label(add_labels(x, y))
                offsets[sub_labels(a_labels[hits[0]], third)] += 1
        chord_direction_profile[f"{direction[0]},{direction[1]}"] = {
            "secants": 9,
            "secants_hitting_a": hit_count,
            "a_label_minus_third_u_label": {
                f"{offset[0]},{offset[1]}": count
                for offset, count in sorted(offsets.items())
            },
        }

    cubic_a_basis = linear_kernel_basis([cubic_row(p) for p in a_set], 10)
    cubic_u_basis = linear_kernel_basis([cubic_row(p) for p in u_set], 10)
    if len(cubic_a_basis) != 1 or len(cubic_u_basis) != 1:
        raise RuntimeError("nine-point orbit does not determine a unique cubic")
    cubic_a = cubic_a_basis[0]
    cubic_u = cubic_u_basis[0]
    pencil = []
    for parameter in list(range(Q)) + ["infinity"]:
        form = cubic_u if parameter == "infinity" else tuple(
            (cubic_a[i] + parameter * cubic_u[i]) % Q for i in range(10)
        )
        pencil.append({
            "parameter": parameter,
            "rational_points": sum(evaluate_cubic(form, p) == 0 for p in points),
        })
    common_pencil_base_points = [
        p for p in points
        if evaluate_cubic(cubic_a, p) == 0
        and evaluate_cubic(cubic_u, p) == 0
    ]

    six_point_conics = [
        record for record in conic_records.values()
        if record["u_on_count"] == 6
    ]
    six_point_relative_profiles = []
    six_point_tangent_profiles = []
    for record in six_point_conics:
        a_on = [
            p for p in a_set
            if evaluate(tuple(record["form"]), p) == 0
        ]
        if len(a_on) != 1:
            raise RuntimeError("six-point conic lacks its unique A-point")
        a_label = a_labels[a_on[0]]
        u_off_labels = [
            u_labels[u_set[i]]
            for i in range(9) if i not in record["u_on"]
        ]
        six_point_relative_profiles.append(sorted(
            sub_labels(label, a_label) for label in u_off_labels
        ))
        tangent = conic_tangent(tuple(record["form"]), a_on[0])
        six_point_tangent_profiles.append({
            "a_label": [a_label[0], a_label[1]],
            "line": list(tangent),
            "a_points": sum(on_line(tangent, p) for p in a_set),
            "u_points": sum(on_line(tangent, p) for p in u_set),
        })

    conic_profile = Counter()
    for form, record in conic_records.items():
        key = (
            record["u_on_count"],
            record["a_types"].get("on", 0),
            record["a_types"].get("internal", 0),
            record["a_types"].get("external", 0),
        )
        conic_profile[key] += 1

    result = {
        "schema": "c644-q19-residue-profile-v1",
        "q": Q,
        "a": [list(p) for p in a_set],
        "u": [list(p) for p in u_set],
        "five_subsets": len(subset_records),
        "distinct_five_point_conics": len(conics),
        "conic_subset_multiplicity_counts": dict(sorted(Counter(conics.values()).items())),
        "conic_profile_fields": [
            "u_on", "a_on", "a_internal", "a_external"
        ],
        "conic_profile": {
            ",".join(map(str, key)): count
            for key, count in sorted(conic_profile.items())
        },
        "maximum_u_on_conic": max(r["u_on_count"] for r in conic_records.values()),
        "maximum_a_on_conic": max(r["a_types"].get("on", 0)
                                  for r in conic_records.values()),
        "conics": sorted(conic_records.values(),
                         key=lambda r: (r["u_on_count"], r["form"])),
        "automorphism_orders": {
            "a": len(a_aut),
            "u": len(u_aut),
            "ordered_pair": len(pair_aut),
            "a_to_u_equivalences": len(a_to_u),
            "u_to_a_equivalences": len(u_to_a),
        },
        "a_automorphisms": [[list(row) for row in m] for m in a_aut],
        "u_automorphisms": [[list(row) for row in m] for m in u_aut],
        "pair_automorphisms": [[list(row) for row in m] for m in pair_aut],
        "a_to_u": [[list(row) for row in m] for m in a_to_u],
        "a_secant_multiplicities_off_a": dict(sorted(a_mult.items())),
        "u_secant_multiplicities_off_u": dict(sorted(u_mult.items())),
        "a_points_by_u_secant_multiplicity": Counter(
            u_point_counts[p] for p in a_set
        ),
        "u_points_by_a_secant_multiplicity": Counter(
            a_point_counts[p] for p in u_set
        ),
        "union_is_arc": all(
            det(x, y, z) for x, y, z in combinations(a_set + u_set, 3)
        ),
        "line_type_fields": ["a_points", "u_points"],
        "line_type_histogram": {
            f"{key[0]},{key[1]}": count for key, count in sorted(line_hist.items())
        },
        "heisenberg_generators": {
            "g": [list(row) for row in generator_g],
            "h": [list(row) for row in generator_h],
            "g_projective_order": projective_order(generator_g),
            "h_projective_order": projective_order(generator_h),
            "g_cube_scalar": scalar_ratio(matrix_power(generator_g, 3), IDENTITY),
            "h_cube_scalar": scalar_ratio(matrix_power(generator_h, 3), IDENTITY),
            "commutator_scalar": scalar_ratio(
                mat_mul(generator_g, generator_h),
                mat_mul(generator_h, generator_g),
            ),
        },
        "orbit_labels": {
            "a": {
                f"{label[0]},{label[1]}": list(point)
                for label, point in sorted(a_by_label.items())
            },
            "u": {
                f"{label[0]},{label[1]}": list(point)
                for label, point in sorted(u_by_label.items())
            },
        },
        "u_chord_direction_profile": chord_direction_profile,
        "invariant_cubics": {
            "monomial_order": [
                "X^3", "Y^3", "Z^3", "X^2Y", "X^2Z",
                "Y^2X", "Y^2Z", "Z^2X", "Z^2Y", "XYZ",
            ],
            "a": list(cubic_a),
            "u": list(cubic_u),
            "g_multiplier_a": semi_invariant_multiplier(
                cubic_a, generator_g, points
            ),
            "h_multiplier_a": semi_invariant_multiplier(
                cubic_a, generator_h, points
            ),
            "g_multiplier_u": semi_invariant_multiplier(
                cubic_u, generator_g, points
            ),
            "h_multiplier_u": semi_invariant_multiplier(
                cubic_u, generator_h, points
            ),
            "rational_common_base_points": [
                list(p) for p in common_pencil_base_points
            ],
            "pencil_rational_point_counts": pencil,
            "pencil_point_count_histogram": dict(sorted(Counter(
                member["rational_points"] for member in pencil
            ).items())),
        },
        "six_point_conic_relative_u_off_profiles": [
            [[label[0], label[1]] for label in profile]
            for profile in sorted(six_point_relative_profiles)
        ],
        "six_point_conic_relative_profile_count": len(set(
            tuple(profile) for profile in six_point_relative_profiles
        )),
        "six_point_conic_tangent_profiles": sorted(
            six_point_tangent_profiles, key=lambda record: record["a_label"]
        ),
    }
    with open(sys.argv[2], "w", encoding="ascii") as out:
        json.dump(result, out, separators=(",", ":"), sort_keys=True)
        out.write("\n")


if __name__ == "__main__":
    main()
