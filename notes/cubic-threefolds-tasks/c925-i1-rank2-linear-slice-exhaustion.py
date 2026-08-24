#!/usr/bin/env python3
"""Exhaust type-I1 invariant rank-two subtori and linear OADP slices."""

import argparse
import itertools
import json
import math
from collections import Counter, defaultdict
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


def sign_line(signs):
    equations = sp.Matrix.vstack(*(
        generator - sign * sp.eye(5)
        for generator, sign in zip(COCHARACTER_GENERATORS, signs)
    ))
    space = equations.nullspace()
    assert len(space) == 1
    return primitive(space[0])


def convex_hull(points):
    points = sorted(set(points))

    def cross(origin, left, right):
        return (
            (left[0]-origin[0])*(right[1]-origin[1])
            - (left[1]-origin[1])*(right[0]-origin[0])
        )

    lower = []
    for point in points:
        while len(lower) >= 2 and cross(lower[-2], lower[-1], point) <= 0:
            lower.pop()
        lower.append(point)
    upper = []
    for point in reversed(points):
        while len(upper) >= 2 and cross(upper[-2], upper[-1], point) <= 0:
            upper.pop()
        upper.append(point)
    return lower[:-1] + upper[:-1]


def normalized_area(vertices):
    return abs(sum(
        vertices[index][0]*vertices[(index+1) % len(vertices)][1]
        - vertices[(index+1) % len(vertices)][0]*vertices[index][1]
        for index in range(len(vertices))
    ))


def affine_weight_action(points, linear_action):
    """Find the unique affine translate of the dual action preserving weights."""
    vectors = [sp.Matrix(point) for point in points]
    point_set = set(points)
    dual = linear_action.inv().T
    for target in vectors:
        shift = target - dual*vectors[0]
        images = [tuple(dual*vector + shift) for vector in vectors]
        if set(images) == point_set:
            return dict(zip(points, images))
    raise AssertionError("cocharacter action did not preserve the weight polygon")


def edge_orbit_sizes(vertices, actions):
    edges = {
        frozenset((vertices[index], vertices[(index+1) % len(vertices)]))
        for index in range(len(vertices))
    }
    unseen = set(edges)
    sizes = []
    while unseen:
        first = unseen.pop()
        orbit = {first}
        queue = [first]
        while queue:
            edge = queue.pop()
            for action in actions:
                image = frozenset(action[point] for point in edge)
                if image not in orbit:
                    orbit.add(image)
                    unseen.discard(image)
                    queue.append(image)
        sizes.append(len(orbit))
    return sorted(sizes)


def unimodular_completion(rank_two_basis):
    candidates = [
        sp.Matrix(entries)
        for entries in itertools.product(range(-1, 2), repeat=5)
        if any(entries)
    ]
    for extra in itertools.combinations(candidates, 3):
        completion = sp.Matrix.hstack(rank_two_basis, *extra)
        if abs(completion.det()) == 1:
            return completion
    raise AssertionError("saturated rank-two lattice lacked a small completion")


# The rational type-I1 representation is multiplicity-free:
# three distinct sign characters and one irreducible two-dimensional summand.
signs = ((1, -1), (-1, 1), (-1, -1))
sign_vectors = [sign_line(character) for character in signs]
assert sign_vectors == [
    sp.Matrix([0, 0, 0, 1, 1]),
    sp.Matrix([0, 0, 1, 0, 1]),
    sp.Matrix([0, 0, 1, 1, 0]),
]
irreducible_basis = sp.Matrix.hstack(
    sp.Matrix([1, -1, 0, 0, 0]),
    sp.Matrix([1, 2, 1, 1, 3]),
)
decomposition_basis = sp.Matrix.hstack(*sign_vectors, irreducible_basis)
assert decomposition_basis.det() != 0

irreducible_actions = []
irreducible_left_inverse = (
    (irreducible_basis.T*irreducible_basis).inv()*irreducible_basis.T
)
for generator in COCHARACTER_GENERATORS:
    action = irreducible_left_inverse*generator*irreducible_basis
    assert irreducible_basis*action == generator*irreducible_basis
    irreducible_actions.append(action)
for character in itertools.product((1, -1), repeat=2):
    equations = sp.Matrix.vstack(*(
        action-value*sp.eye(2)
        for action, value in zip(irreducible_actions, character)
    ))
    assert equations.nullspace() == []

# Maschke plus multiplicity-freeness now exhausts invariant rank-two rational
# subspaces: choose two sign lines, or take the irreducible plane.
rank_two_spaces = [
    ("sign_square", sp.Matrix.hstack(sign_vectors[0], sign_vectors[1]), [3, 25, 2]),
    ("sign_rectangle_1", sp.Matrix.hstack(sign_vectors[0], sign_vectors[2]), [3, 19, 2]),
    ("sign_rectangle_2", sp.Matrix.hstack(sign_vectors[1], sign_vectors[2]), [3, 19, 2]),
    ("irreducible_hexagon", irreducible_basis, [3, 6, 3]),
]

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
for name, basis, carat_class in rank_two_spaces:
    left_inverse = (basis.T*basis).inv()*basis.T
    actions = []
    for generator in COCHARACTER_GENERATORS:
        action = left_inverse*generator*basis
        assert basis*action == generator*basis
        assert all(entry.q == 1 for entry in action)
        actions.append(action)

    lifts = []
    for column in range(2):
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
    minima = tuple(min(weight[index] for weight in raw_weights) for index in range(2))
    weights = [
        tuple(weight[index]-minima[index] for index in range(2))
        for weight in raw_weights
    ]
    blocks = defaultdict(list)
    for coordinate, weight in zip(cox_names, weights):
        blocks[weight].append(coordinate)
    vertices = convex_hull(weights)
    degree = normalized_area(vertices)
    affine_actions = [affine_weight_action(sorted(set(weights)), action) for action in actions]
    edge_sizes = edge_orbit_sizes(vertices, affine_actions)

    completion = unimodular_completion(basis)
    quotient_character_actions = []
    for generator in COCHARACTER_GENERATORS:
        changed = completion.inv()*generator*completion
        assert changed[2:, :2] == sp.zeros(3, 2)
        quotient_character_actions.append(changed[2:, 2:].inv().T)

    records.append({
        "name": name,
        "cocharacter_basis": [
            [int(entry) for entry in basis.col(column)] for column in range(2)
        ],
        "cocharacter_generator_actions": [
            [[int(entry) for entry in matrix.row(row)] for row in range(2)]
            for matrix in actions
        ],
        "cox_weight_blocks": {
            f"{weight[0]},{weight[1]}": coordinates
            for weight, coordinates in sorted(blocks.items())
        },
        "weight_polygon_vertices": [list(vertex) for vertex in vertices],
        "orbit_surface_degree": degree,
        "boundary_edge_orbit_sizes": edge_sizes,
        "proper_descended_linear_slice_open_degree_cannot_be_one": (
            degree % math.gcd(*edge_sizes) == 0
            and 1 % math.gcd(*edge_sizes) != degree % math.gcd(*edge_sizes)
        ),
        "quotient_character_generator_actions": [
            [[int(entry) for entry in matrix.row(row)] for row in range(3)]
            for matrix in quotient_character_actions
        ],
        "quotient_character_carat_class": carat_class,
        "quotient_torus_rational": carat_class not in ([3, 6, 3],),
    })

assert [record["orbit_surface_degree"] for record in records] == [2, 6, 6, 6]
assert [record["boundary_edge_orbit_sizes"] for record in records] == [
    [2, 2], [2, 2], [2, 2], [3, 3],
]
assert all(
    record["proper_descended_linear_slice_open_degree_cannot_be_one"]
    for record in records
)

certificate = {
    "schema": "c925-i1-rank2-linear-slice-exhaustion-v1",
    "rational_representation_decomposition": {
        "three_distinct_sign_characters": [list(character) for character in signs],
        "irreducible_plane_generator_actions": [
            [[int(entry) for entry in matrix.row(row)] for row in range(2)]
            for matrix in irreducible_actions
        ],
        "multiplicity_free": True,
        "invariant_rank_two_subspace_count": 4,
    },
    "rank_two_subtori": records,
    "conclusion": (
        "All four type-I1 invariant rational rank-two subspaces are exhausted. "
        "Their toric orbit surfaces have degrees 2,6,6,6. For the three sign-"
        "pair cases the boundary-edge orbits have size two, so a proper "
        "descended codimension-two linear section has even open degree. In "
        "the irreducible hexagon case the boundary-edge orbits have size "
        "three, so open degree is divisible by three; moreover its residual "
        "torus has non-retract-rational CARAT class (3,6,3). No invariant "
        "rank-two subtorus can therefore yield level three by a descended "
        "linear one-point OADP slice."
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
