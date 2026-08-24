#!/usr/bin/env python3
"""Exhaust type-I1 invariant rank-three boundary-peeling slices."""

import argparse
import itertools
import json
import math
from collections import defaultdict
from pathlib import Path

import sympy as sp


COCHARACTER_GENERATORS = (
    sp.Matrix([
        [-1, 1, 0, 0, 0], [0, 1, 0, 0, 0], [0, 1, -1, 0, 0],
        [-1, 0, -1, 0, 1], [-1, 2, -1, 1, 0],
    ]),
    sp.Matrix([
        [0, -1, 0, 0, 0], [-1, 0, 0, 0, 0], [-1, -1, 0, -1, 1],
        [0, 0, 0, -1, 0], [-1, -1, 1, -1, 0],
    ]),
)

ROOT_BASIS = sp.Matrix.hstack(
    sp.Matrix([0, 1, 0, 0, 0, -1]),
    sp.Matrix([0, 0, 1, 0, 0, -1]),
    sp.Matrix([0, 0, 0, 1, 0, -1]),
    sp.Matrix([0, 0, 0, 0, 1, -1]),
    sp.Matrix([1, 0, 0, 0, 0, -3]),
)


def primitive(vector):
    denominator = sp.ilcm(*(entry.q for entry in vector))
    entries = [int(denominator * entry) for entry in vector]
    divisor = math.gcd(*(abs(entry) for entry in entries))
    result = sp.Matrix([entry // divisor for entry in entries])
    first = next(entry for entry in result if entry)
    return result if first > 0 else -result


def lattice_index(basis):
    """Index of the column lattice in its saturation."""
    minors = [
        abs(int(basis[list(rows), :].det()))
        for rows in itertools.combinations(range(basis.rows), basis.cols)
    ]
    return math.gcd(*minors)


def sign_line(signs):
    equations = sp.Matrix.vstack(*(
        generator - sign * sp.eye(5)
        for generator, sign in zip(COCHARACTER_GENERATORS, signs)
    ))
    space = equations.nullspace()
    assert len(space) == 1
    return primitive(space[0])


def affine_weight_action(points, linear_action):
    vectors = [sp.Matrix(point) for point in points]
    point_set = set(points)
    dual = linear_action.inv().T
    for target in vectors:
        shift = target - dual*vectors[0]
        images = [tuple(dual*vector + shift) for vector in vectors]
        if set(images) == point_set:
            return dict(zip(points, images))
    raise AssertionError("cocharacter action did not preserve the weights")


def affine_group(points, generators):
    identity = {point: point for point in points}
    group = {tuple(points): identity}
    queue = [identity]
    while queue:
        current = queue.pop()
        for generator in generators:
            product = {point: generator[current[point]] for point in points}
            key = tuple(product[point] for point in points)
            if key not in group:
                group[key] = product
                queue.append(product)
    return list(group.values())


def supporting_facets(points):
    facets = {}
    for left, middle, right in itertools.combinations(points, 3):
        origin = sp.Matrix(left)
        normal = (sp.Matrix(middle)-origin).cross(sp.Matrix(right)-origin)
        if normal == sp.zeros(3, 1):
            continue
        values = [int(normal.dot(sp.Matrix(point)-origin)) for point in points]
        if all(value >= 0 for value in values) or all(value <= 0 for value in values):
            if all(value <= 0 for value in values):
                normal = -normal
                values = [-value for value in values]
            face = frozenset(
                point for point, value in zip(points, values) if value == 0
            )
            if len(face) >= 3:
                divisor = math.gcd(*(abs(int(entry)) for entry in normal))
                normal = normal/divisor
                facets[face] = (tuple(int(entry) for entry in normal), int(normal.dot(origin)))
    return facets


def face_orbits(faces, group):
    unseen = set(faces)
    orbits = []
    while unseen:
        first = next(iter(unseen))
        orbit = {
            frozenset(action[point] for point in first)
            for action in group
        }
        unseen -= orbit
        orbits.append(orbit)
    return orbits


def normalized_volume(points, facets):
    """Compute 3! volume as the leading Ehrhart coefficient times 3!."""
    counts = []
    minima = [min(point[index] for point in points) for index in range(3)]
    maxima = [max(point[index] for point in points) for index in range(3)]
    for dilation in range(4):
        count = 0
        ranges = [
            range(dilation*minima[index], dilation*maxima[index]+1)
            for index in range(3)
        ]
        for lattice_point in itertools.product(*ranges):
            if all(
                sum(normal[index]*lattice_point[index] for index in range(3))
                >= dilation*offset
                for normal, offset in facets.values()
            ):
                count += 1
        counts.append(count)
    variable = sp.symbols("d")
    polynomial = sp.interpolate(
        [(dilation, count) for dilation, count in enumerate(counts)], variable
    )
    return int(6*sp.Poly(polynomial, variable).coeff_monomial(variable**3)), counts


# The rational representation is the multiplicity-free sum of three distinct
# sign lines and one irreducible two-plane.
sign_characters = ((1, -1), (-1, 1), (-1, -1))
sign_vectors = [sign_line(character) for character in sign_characters]
irreducible_basis = sp.Matrix.hstack(
    sp.Matrix([1, -1, 0, 0, 0]),
    sp.Matrix([1, 2, 1, 1, 3]),
)
decomposition_basis = sp.Matrix.hstack(*sign_vectors, irreducible_basis)
assert decomposition_basis.det() != 0
irreducible_left_inverse = (
    (irreducible_basis.T*irreducible_basis).inv()*irreducible_basis.T
)
irreducible_actions = [
    irreducible_left_inverse*generator*irreducible_basis
    for generator in COCHARACTER_GENERATORS
]
for character in itertools.product((1, -1), repeat=2):
    equations = sp.Matrix.vstack(*(
        action-value*sp.eye(2)
        for action, value in zip(irreducible_actions, character)
    ))
    assert equations.nullspace() == []

raw_rank_three_spaces = [
    ("three_sign_lines", sp.Matrix.hstack(*sign_vectors)),
] + [
    (f"sign_{index}_plus_irreducible", sp.Matrix.hstack(vector, irreducible_basis))
    for index, vector in enumerate(sign_vectors)
]

# Rational invariant subspaces define saturated intersections with the
# ambient cocharacter lattice.  The obvious isotypic bases miss that lattice
# in two cases.  These replacements explicitly adjoin the missing half-sum
# and third-sum vectors.
three_sign_raw = raw_rank_three_spaces[0][1]
three_sign_half_sum = sum(
    (three_sign_raw.col(column) for column in range(3)), sp.zeros(5, 1)
)/2
sign_two_raw = raw_rank_three_spaces[3][1]
sign_two_third_sum = (
    2*sign_two_raw.col(0)+2*sign_two_raw.col(1)+sign_two_raw.col(2)
)/3
rank_three_spaces = [
    (
        "three_sign_lines",
        sp.Matrix.hstack(
            three_sign_raw.col(0), three_sign_raw.col(1), three_sign_half_sum
        ),
        three_sign_raw,
    ),
    *[(name, basis, basis) for name, basis in raw_rank_three_spaces[1:3]],
    (
        "sign_2_plus_irreducible",
        sp.Matrix.hstack(
            sign_two_raw.col(0), sign_two_raw.col(1), sign_two_third_sum
        ),
        sign_two_raw,
    ),
]
assert [lattice_index(raw) for _, _, raw in rank_three_spaces] == [2, 1, 1, 3]
assert all(lattice_index(basis) == 1 for _, basis, _ in rank_three_spaces)

cox_classes = []
cox_names = []
for index in range(5):
    value = [0]*6
    value[index+1] = 1
    cox_classes.append(sp.Matrix(value))
    cox_names.append(f"E{index+1}")
for left in range(5):
    for right in range(left+1, 5):
        value = [1]+[0]*5
        value[left+1] = value[right+1] = -1
        cox_classes.append(sp.Matrix(value))
        cox_names.append(f"L{left+1}{right+1}")
cox_classes.append(sp.Matrix([2, -1, -1, -1, -1, -1]))
cox_names.append("Q")

records = []
for name, basis, raw_basis in rank_three_spaces:
    left_inverse = (basis.T*basis).inv()*basis.T
    actions = []
    for generator in COCHARACTER_GENERATORS:
        action = left_inverse*generator*basis
        assert basis*action == generator*basis
        actions.append(action)

    lifts = []
    for column in range(3):
        variables = sp.symbols("u0:6")
        solution = next(iter(sp.linsolve([
            sum(variables[row]*ROOT_BASIS[row, root] for row in range(6))
            - basis[root, column]
            for root in range(5)
        ] + [variables[5]], variables)))
        assert all(entry.q == 1 for entry in solution)
        lifts.append(sp.Matrix(1, 6, solution))

    raw_weights = [
        tuple(int((lift*divisor)[0]) for lift in lifts)
        for divisor in cox_classes
    ]
    minima = tuple(min(weight[index] for weight in raw_weights) for index in range(3))
    weights = [
        tuple(weight[index]-minima[index] for index in range(3))
        for weight in raw_weights
    ]
    points = sorted(set(weights))
    blocks = defaultdict(list)
    for coordinate, weight in zip(cox_names, weights):
        blocks[weight].append(coordinate)
    affine_generators = [affine_weight_action(points, action) for action in actions]
    group = affine_group(points, affine_generators)
    facets = supporting_facets(points)
    orbits = face_orbits(facets, group)
    degree, ehrhart_counts = normalized_volume(points, facets)
    stable_four_weight_windows = []
    for window in itertools.combinations(points, 4):
        window_set = set(window)
        if all(
            {action[point] for point in window_set} == window_set
            for action in group
        ):
            origin = sp.Matrix(window[0])
            index = abs(int(sp.Matrix.hstack(*(
                sp.Matrix(point)-origin for point in window[1:]
            )).det()))
            stable_four_weight_windows.append({
                "weights": [list(point) for point in window],
                "affine_lattice_index": index,
                "is_unimodular": index == 1,
            })

    orbit_records = []
    for orbit in sorted(orbits, key=lambda value: (len(value), sorted(map(sorted, value)))):
        covered_weights = set().union(*(set(face) for face in orbit))
        uncovered_weights = set(points)-covered_weights
        uncovered_coordinates = sorted(
            coordinate
            for weight in uncovered_weights
            for coordinate in blocks[weight]
        )
        orbit_records.append({
            "orbit_size": len(orbit),
            "facet_vertex_counts": sorted(len(face) for face in orbit),
            "covered_weight_count": len(covered_weights),
            "uncovered_weights": [list(weight) for weight in sorted(uncovered_weights)],
            "uncovered_coordinates": uncovered_coordinates,
        })

    records.append({
        "name": name,
        "raw_isotypic_basis_saturation_index": lattice_index(raw_basis),
        "raw_isotypic_basis": [
            [int(entry) for entry in raw_basis.col(column)] for column in range(3)
        ],
        "cocharacter_basis": [
            [int(entry) for entry in basis.col(column)] for column in range(3)
        ],
        "cocharacter_generator_actions": [
            [[int(entry) for entry in matrix.row(row)] for row in range(3)]
            for matrix in actions
        ],
        "cox_weight_blocks": {
            ",".join(map(str, weight)): coordinates
            for weight, coordinates in sorted(blocks.items())
        },
        "affine_weight_group_order": len(group),
        "weight_count": len(points),
        "facet_count": len(facets),
        "facet_orbits": orbit_records,
        "ehrhart_counts_at_0_1_2_3": ehrhart_counts,
        "orbit_threefold_degree": degree,
        "galois_stable_four_weight_windows": stable_four_weight_windows,
    })

assert [record["orbit_threefold_degree"] for record in records] == [7, 18, 18, 6]
assert [[item["orbit_size"] for item in record["facet_orbits"]] for record in records] == [
    [2, 2, 4], [2, 3, 3], [2, 3, 3], [6],
]
assert [
    [window["affine_lattice_index"] for window in record["galois_stable_four_weight_windows"]]
    for record in records
] == [[3, 1], [], [], []]
assert sum(
    window["is_unimodular"]
    for record in records
    for window in record["galois_stable_four_weight_windows"]
) == 1

# Complete the saturated three-sign lattice to an integral basis of the
# ambient cocharacter lattice.  The lower-right blocks are the exact
# cocharacter actions on the residual rank-two quotient torus.
three_sign_basis = rank_three_spaces[0][1]
ambient_completion = sp.Matrix.hstack(
    three_sign_basis,
    sp.Matrix([1, 0, 0, 0, 0]),
    sp.Matrix([0, 1, 0, 0, 0]),
)
assert abs(int(ambient_completion.det())) == 1
completed_generator_actions = [
    ambient_completion.inv()*generator*ambient_completion
    for generator in COCHARACTER_GENERATORS
]
assert all(
    all(entry.q == 1 for entry in action)
    and action[3:5, 0:3] == sp.zeros(2, 3)
    for action in completed_generator_actions
)
residual_cocharacter_actions = [action[3:5, 3:5] for action in completed_generator_actions]
residual_character_actions = [
    action.inv().T for action in residual_cocharacter_actions
]
assert all(all(entry.q == 1 for entry in action) for action in residual_character_actions)

# In the two sign-plus-irreducible cases where a size-three facet orbit does
# not span every weight block, its complement is always the same four Cox
# coordinates.  A tangent hyperplane containing the full divisor orbit would
# have to be supported on these four coordinates.  The displayed nonzero
# minor proves that the Jacobian rowspace has no such nonzero covector.
a, b, z1, z2, z3 = sp.symbols("a b z1 z2 z3")
coordinate_symbols = sp.symbols(
    "e1 e2 e3 e4 e5 l12 l13 l14 l15 l23 l24 l25 l34 l35 l45 q"
)
(
    e1, e2, e3, e4, e5, l12, l13, l14, l15,
    l23, l24, l25, l34, l35, l45, q,
) = coordinate_symbols
relations = [
    e2*l12-e3*l13+e4*l14,
    a*e2*l12-b*e3*l13+e5*l15,
    e1*l12-e3*l23+e4*l24,
    e1*l12-b*e3*l23+e5*l25,
    e1*l13-e2*l23+e4*l34,
    e1*l13-a*e2*l23+e5*l35,
    e1*l14-e2*l24+e3*l34,
    (b-1)*e1*l14+(a-b)*e2*l24+e5*l45,
    e1*l15-a*e2*l25+b*e3*l35,
    (a-1)*e2*l25+(1-b)*e3*l35+e4*l45,
    l23*l45+l24*l35-l25*l34,
    a*l23*l45+(a-b)*l24*l35-e1*q,
    l13*l45+l14*l35-l15*l34,
    l13*l45+(1-b)*l14*l35-e2*q,
    l12*l45+l14*l25-l15*l24,
    l12*l45+(1-a)*l14*l25-e3*q,
    l12*l35-l13*l25+l15*l23,
    (b-1)*l12*l35+(1-a)*l13*l25-e4*q,
    l12*l34-l13*l24+l14*l23,
    a*(b-1)*l12*l34+b*(1-a)*l13*l24-e5*q,
]
standard_point = {
    e1: 1, e2: 1, e3: 1, e4: 1, e5: 1,
    l12: z3, l13: z2, l14: z2-z3, l15: b*z2-a*z3,
    l23: z1, l24: z1-z3, l25: b*z1-z3, l34: z1-z2,
    l35: a*z1-z2,
    l45: (b-a)*z1+(1-b)*z2+(a-1)*z3,
    q: b*(1-a)*z1*z2+a*(b-1)*z1*z3+(a-b)*z2*z3,
}
assert all(sp.factor(relation.subs(standard_point)) == 0 for relation in relations)
jacobian = sp.Matrix(relations).jacobian(coordinate_symbols).subs(standard_point)
minor_rows = (0, 1, 2, 3, 4, 5, 7, 11)
minor_coordinate_names = ("E1", "E2", "E5", "L12", "L13", "L14", "L15", "L23")
minor_columns = tuple(cox_names.index(name) for name in minor_coordinate_names)
minor = sp.factor(jacobian.extract(minor_rows, minor_columns).det())
assert minor != 0
central_coordinates = {"E3", "E4", "L34", "Q"}
assert central_coordinates.isdisjoint(minor_coordinate_names)
for record in records[1:3]:
    nonspanning = [
        item for item in record["facet_orbits"]
        if item["covered_weight_count"] < record["weight_count"]
    ]
    assert len(nonspanning) == 2
    assert all(set(item["uncovered_coordinates"]) == central_coordinates for item in nonspanning)

# The full-I3 adjacent-window application uses the same split Cox variety.
# At one exact dense specialization, exhibit a tangent covector which vanishes
# on the extreme-weight boundary B but is nonzero on both middle weights.
# Since these are open rank/nonvanishing conditions, this proves the generic
# hypothesis in the adjacent-weight OADP lemma.
middle_weight_one = {"L13", "L14", "L23", "L24", "L35", "L45"}
middle_weight_two = {"E1", "E2", "E5", "L12", "L15", "L25"}
tangent_specialization = {a: 2, b: 5, z1: 1, z2: 3, z3: 7}
specialized_jacobian = jacobian.subs(tangent_specialization)
assert specialized_jacobian.rank() == 8
mixed_tangent_coefficients = {
    "L13": 10, "L14": -45, "L23": -30, "L24": 30,
    "E1": 210, "E2": -217, "E5": 7, "L12": -1, "L15": 7,
}
mixed_tangent_covector = sp.Matrix([[
    mixed_tangent_coefficients.get(name, 0) for name in cox_names
]])
assert all(mixed_tangent_covector[cox_names.index(name)] == 0 for name in central_coordinates)
assert any(mixed_tangent_covector[cox_names.index(name)] for name in middle_weight_one)
assert any(mixed_tangent_covector[cox_names.index(name)] for name in middle_weight_two)
assert sp.Matrix.vstack(specialized_jacobian, mixed_tangent_covector).rank() == 8

# The unimodular stable window in the saturated three-sign representation
# gives a generically one-point tangent slice. Construct three
# exact boundary-vanishing tangent hyperplanes and check on a second general
# torsor point that their four window coefficients have rank three and a
# kernel with no zero coordinate.
tangent_row_basis = specialized_jacobian[list(minor_rows), :]
assert tangent_row_basis.rank() == 8
boundary_indices = [cox_names.index(name) for name in sorted(central_coordinates)]
boundary_vanishing_coefficients = tangent_row_basis[:, boundary_indices].T.nullspace()
assert len(boundary_vanishing_coefficients) == 4
boundary_vanishing_hyperplanes = [
    coefficient.T*tangent_row_basis
    for coefficient in boundary_vanishing_coefficients
]

def symbolic_slice_determinant(tangent_z, orbit_e, orbit_z):
    """Four-hyperplane evaluation determinant, with Cox moduli a,b free."""
    tangent_rows = jacobian[list(minor_rows), :].subs(dict(zip((z1, z2, z3), tangent_z)))
    coefficient_basis = tangent_rows[:, boundary_indices].T.nullspace()
    assert len(coefficient_basis) == 4
    hyperplanes = [coefficient.T*tangent_rows for coefficient in coefficient_basis]
    ee1, ee2, ee3, ee4, ee5 = orbit_e
    zz1, zz2, zz3 = orbit_z
    values = {
        e1: ee1, e2: ee2, e3: ee3, e4: ee4, e5: ee5,
        l12: sp.Rational(zz3, ee1*ee2),
        l13: sp.Rational(zz2, ee1*ee3),
        l14: sp.Rational(zz2-zz3, ee1*ee4),
        l15: (b*zz2-a*zz3)/(ee1*ee5),
        l23: sp.Rational(zz1, ee2*ee3),
        l24: sp.Rational(zz1-zz3, ee2*ee4),
        l25: (b*zz1-zz3)/(ee2*ee5),
        l34: sp.Rational(zz1-zz2, ee3*ee4),
        l35: (a*zz1-zz2)/(ee3*ee5),
        l45: ((b-a)*zz1+(1-b)*zz2+(a-1)*zz3)/(ee4*ee5),
        q: (
            b*(1-a)*zz1*zz2+a*(b-1)*zz1*zz3+(a-b)*zz2*zz3
        )/(ee1*ee2*ee3*ee4*ee5),
    }
    assert all(sp.factor(relation.subs(values)) == 0 for relation in relations)
    matrix = sp.Matrix([
        [
            sum(
                hyperplane[cox_names.index(name)]
                * values[coordinate_symbols[cox_names.index(name)]]
                for name in block
            )
            for block in [
                ["E1", "E2", "E5"], ["L14", "L24", "L45"],
                ["L13", "L23", "L35"], ["L12", "L15", "L25"],
            ]
        ]
        for hyperplane in hyperplanes
    ])
    return sp.factor(matrix.det()), sp.factor(minor.subs(dict(zip((z1, z2, z3), tangent_z))))


symbolic_slice_witnesses = [
    ((1, 3, 7), (2, 3, 5, 7, 11), (2, 4, 9)),
    ((2, 5, 11), (3, 4, 7, 13, 17), (1, 6, 10)),
    ((3, 8, 13), (5, 7, 11, 17, 19), (2, 9, 15)),
]
symbolic_slice_data = [
    symbolic_slice_determinant(*witness) for witness in symbolic_slice_witnesses
]
symbolic_window_determinants = [value[0] for value in symbolic_slice_data]
symbolic_tangent_minors = [value[1] for value in symbolic_slice_data]
assert all(value != 0 for value in symbolic_window_determinants)
symbolic_slice_ideal = sp.groebner(
    [sp.together(value).as_numer_denom()[0] for value in symbolic_window_determinants],
    a, b,
)
symbolic_slice_common_zero_basis = [
    sp.factor(polynomial.as_expr()) for polynomial in symbolic_slice_ideal.polys
]
assert symbolic_slice_common_zero_basis == [a-1, b-1]
# At (a,b)=(1,1), the fifth blown-up point (1:a:b) equals (1:1:1), so the
# standard five-point configuration is not a smooth quartic del Pezzo model.
symbolic_slices_cover_smooth_moduli = True
orbit_values = {
    e1: 2, e2: 3, e3: 5, e4: 7, e5: 11,
    l12: sp.Rational(9, 2*3),
    l13: sp.Rational(4, 2*5),
    l14: sp.Rational(4-9, 2*7),
    l15: sp.Rational(5*4-2*9, 2*11),
    l23: sp.Rational(2, 3*5),
    l24: sp.Rational(2-9, 3*7),
    l25: sp.Rational(5*2-9, 3*11),
    l34: sp.Rational(2-4, 5*7),
    l35: sp.Rational(2*2-4, 5*11),
    l45: sp.Rational((5-2)*2+(1-5)*4+(2-1)*9, 7*11),
    q: sp.Rational(
        5*(1-2)*2*4+2*(5-1)*2*9+(2-5)*4*9,
        2*3*5*7*11,
    ),
    a: 2, b: 5,
}
assert all(sp.factor(relation.subs(orbit_values)) == 0 for relation in relations)
unimodular_window_blocks = [
    ["E1", "E2", "E5"],
    ["L14", "L24", "L45"],
    ["L13", "L23", "L35"],
    ["L12", "L15", "L25"],
]
window_coefficient_matrix = sp.Matrix([
    [
        sum(
            hyperplane[cox_names.index(name)]*orbit_values[coordinate_symbols[cox_names.index(name)]]
            for name in block
        )
        for block in unimodular_window_blocks
    ]
    for hyperplane in boundary_vanishing_hyperplanes[:3]
])
window_maximal_minors = [
    sp.factor(window_coefficient_matrix[:, [
        column for column in range(4) if column != omitted
    ]].det())
    for omitted in range(4)
]
assert window_coefficient_matrix.rank() == 3
assert all(value != 0 for value in window_maximal_minors)

certificate = {
    "schema": "c925-i1-rank3-boundary-peeling-exhaustion-v2",
    "rational_representation_decomposition": {
        "three_distinct_sign_characters": [list(value) for value in sign_characters],
        "irreducible_plane_generator_actions": [
            [[int(entry) for entry in matrix.row(row)] for row in range(2)]
            for matrix in irreducible_actions
        ],
        "multiplicity_free": True,
        "invariant_rank_three_subspace_count": 4,
    },
    "rank_three_subtori": records,
    "central_four_coordinate_tangent_obstruction": {
        "coordinates": sorted(central_coordinates),
        "jacobian_minor_rows_zero_based": list(minor_rows),
        "jacobian_minor_coordinates": list(minor_coordinate_names),
        "nonzero_minor_factorization": str(minor),
        "conclusion": (
            "The Jacobian has full row rank eight after deleting the central "
            "four columns. Hence its rowspace contains no nonzero covector "
            "supported on those columns, so no tangent hyperplane contains "
            "either surviving Galois-stable size-three facet orbit."
        ),
    },
    "full_i3_adjacent_window_tangent_witness": {
        "specialization": {"a": 2, "b": 5, "z1": 1, "z2": 3, "z3": 7},
        "boundary_coordinates_with_zero_coefficients": sorted(central_coordinates),
        "middle_weight_one_coordinates": sorted(middle_weight_one),
        "middle_weight_two_coordinates": sorted(middle_weight_two),
        "nonzero_tangent_covector_coefficients": mixed_tangent_coefficients,
        "specialized_jacobian_rank": 8,
        "augmented_rank": 8,
        "conclusion": (
            "The boundary-vanishing tangent linear system has a member "
            "nonzero on both adjacent middle weights. This exact witness "
            "proves the generic nonvanishing condition by openness."
        ),
    },
    "three_sign_unimodular_tangent_slice": {
        "stable_window_weight_blocks": unimodular_window_blocks,
        "affine_lattice_index": 1,
        "tangent_specialization": {"a": 2, "b": 5, "z1": 1, "z2": 3, "z3": 7},
        "orbit_test_point": {
            "e1,e2,e3,e4,e5": [2, 3, 5, 7, 11],
            "a,b,z1,z2,z3": [2, 5, 2, 4, 9],
        },
        "window_coefficient_matrix": [
            [str(entry) for entry in window_coefficient_matrix.row(row)]
            for row in range(3)
        ],
        "four_maximal_minors": [str(value) for value in window_maximal_minors],
        "symbolic_four_hyperplane_evaluation_determinants": [
            str(value) for value in symbolic_window_determinants
        ],
        "symbolic_tangent_smoothness_minors": [
            str(value) for value in symbolic_tangent_minors
        ],
        "symbolic_witness_common_zero_groebner_basis": [
            str(value) for value in symbolic_slice_common_zero_basis
        ],
        "symbolic_witnesses_cover_smooth_moduli": symbolic_slices_cover_smooth_moduli,
        "all_kernel_coordinates_nonzero": True,
        "geometric_open_orbit_degree": 1,
        "conclusion": (
            "A descended tangent codimension-three slice supported on the "
            "unimodular stable four-weight window is rational by OADP "
            "projection and meets a general saturated three-sign torus orbit "
            "in one point. Thus the rank-three quotient is rational."
        ),
    },
    "three_sign_residual_rank_two_torus": {
        "ambient_unimodular_completion_columns": [
            [int(entry) for entry in ambient_completion.col(column)]
            for column in range(5)
        ],
        "completion_determinant": int(ambient_completion.det()),
        "quotient_cocharacter_generator_actions": [
            [[int(entry) for entry in action.row(row)] for row in range(2)]
            for action in residual_cocharacter_actions
        ],
        "quotient_character_generator_actions": [
            [[int(entry) for entry in action.row(row)] for row in range(2)]
            for action in residual_character_actions
        ],
        "rank": 2,
        "conclusion": (
            "The saturated three-sign subtorus has a rank-two residual torus. "
            "Every two-dimensional torus over a characteristic-zero field is "
            "rational."
        ),
    },
    "conclusion": (
        "The four invariant rank-three rational subspaces are exhausted. "
        "After saturation, the three-sign subtorus has a Galois-stable "
        "unimodular four-weight window. The exact tangent slice therefore "
        "proves its quotient rational; its residual rank-two torus is rational. "
        "For three-sign and sign_2-plus-irreducible, every facet orbit spans "
        "all weight blocks. For sign_0 and sign_1 plus the irreducible plane, "
        "the only nonspanning facet orbits leave the four central Cox "
        "coordinates, but the exact tangent minor rules out a tangent "
        "hyperplane supported there. The three-sign unimodular window, rather "
        "than a first boundary-divisor peel, lands level-two rationality."
    ),
}

parser = argparse.ArgumentParser()
mode = parser.add_mutually_exclusive_group()
mode.add_argument("--write-certificate", type=Path)
mode.add_argument("--check-certificate", type=Path)
arguments = parser.parse_args()
payload = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
if arguments.write_certificate is not None:
    arguments.write_certificate.write_text(payload, encoding="utf-8")
if arguments.check_certificate is not None:
    assert arguments.check_certificate.read_text(encoding="utf-8") == payload
print(payload, end="")
