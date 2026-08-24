#!/usr/bin/env python3
"""Exact type-I1 rank-two slice and level-three descent-frontier check."""

import argparse
import itertools
import json
import math
from pathlib import Path

import sympy as sp


# Column actions on the D5 cocharacter lattice of the anticanonical quotient
# torus.  These are inverse transposes of the character actions in the T-Z
# convention used by the other C925 certificates.
COCHARACTER_GENERATORS = (
    sp.Matrix([
        [-1, 1, 0, 0, 0],
        [0, 1, 0, 0, 0],
        [0, 1, -1, 0, 0],
        [-1, 0, -1, 0, 1],
        [-1, 2, -1, 1, 0],
    ]),
    sp.Matrix([
        [0, -1, 0, 0, 0],
        [-1, 0, 0, 0, 0],
        [-1, -1, 0, -1, 1],
        [0, 0, 0, -1, 0],
        [-1, -1, 1, -1, 0],
    ]),
)

ROOT_BASIS = sp.Matrix.hstack(
    sp.Matrix([0, 1, 0, 0, 0, -1]),
    sp.Matrix([0, 0, 1, 0, 0, -1]),
    sp.Matrix([0, 0, 0, 1, 0, -1]),
    sp.Matrix([0, 0, 0, 0, 1, -1]),
    sp.Matrix([1, 0, 0, 0, 0, -3]),
)


def matrix_key(matrix):
    return tuple(int(entry) for entry in matrix)


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


# Reconstruct the type-I1 image and the two independent sign directions.
group = {matrix_key(sp.eye(5)): sp.eye(5)}
queue = [sp.eye(5)]
while queue:
    value = queue.pop()
    for generator in COCHARACTER_GENERATORS:
        product = value * generator
        key = matrix_key(product)
        if key not in group:
            group[key] = product
            queue.append(product)
assert len(group) == 12

v1 = sign_line((1, -1))
v2 = sign_line((-1, 1))
assert v1 == sp.Matrix([0, 0, 0, 1, 1])
assert v2 == sp.Matrix([0, 0, 1, 0, 1])

# The rank-two sublattice is saturated; this is a unimodular completion.
completion = sp.Matrix.hstack(
    v1,
    v2,
    sp.eye(5).col(0),
    sp.eye(5).col(1),
    sp.eye(5).col(2),
)
assert completion.det() == 1

quotient_character_actions = []
for generator in COCHARACTER_GENERATORS:
    changed = completion.inv() * generator * completion
    assert changed[2:, :2] == sp.zeros(3, 2)
    quotient_cocharacter = changed[2:, 2:]
    quotient_character_actions.append(quotient_cocharacter.inv().T)

expected_quotient_character_actions = [
    sp.Matrix([[-1, 0, 0], [1, 1, -1], [0, 0, -1]]),
    sp.Matrix([[0, -1, 0], [-1, 0, 0], [0, 0, -1]]),
]
assert quotient_character_actions == expected_quotient_character_actions

# Pair the rank-two cocharacters with every Cox coordinate.
cox_classes = []
cox_names = []
for index in range(5):
    value = [0] * 6
    value[index + 1] = 1
    cox_classes.append(sp.Matrix(value))
    cox_names.append(f"E{index + 1}")
for left in range(5):
    for right in range(left + 1, 5):
        value = [1] + [0] * 5
        value[left + 1] = -1
        value[right + 1] = -1
        cox_classes.append(sp.Matrix(value))
        cox_names.append(f"L{left + 1}{right + 1}")
cox_classes.append(sp.Matrix([2, -1, -1, -1, -1, -1]))
cox_names.append("Q")

lifts = []
for cocharacter in (v1, v2):
    variables = sp.symbols("u0:6")
    solution = next(iter(sp.linsolve([
        sum(variables[row] * ROOT_BASIS[row, column] for row in range(6))
        - cocharacter[column]
        for column in range(5)
    ] + [variables[5]], variables)))
    assert all(entry.q == 1 for entry in solution)
    lifts.append(sp.Matrix(1, 6, solution))

assert lifts == [
    sp.Matrix([[1, 0, 0, 0, 1, 0]]),
    sp.Matrix([[1, 0, 0, 1, 0, 0]]),
]

raw_weights = [
    tuple(int((lift * divisor)[0]) for lift in lifts)
    for divisor in cox_classes
]
minima = tuple(min(weight[index] for weight in raw_weights) for index in range(2))
weights = [
    tuple(weight[index] - minima[index] for index in range(2))
    for weight in raw_weights
]
weight_blocks = {
    f"{left},{right}": [
        name for name, weight in zip(cox_names, weights)
        if weight == (left, right)
    ]
    for left, right in itertools.product((0, 1), repeat=2)
}
assert weight_blocks == {
    "0,0": ["E1", "E2", "E5", "L34"],
    "0,1": ["E3", "L14", "L24", "L45"],
    "1,0": ["E4", "L13", "L23", "L35"],
    "1,1": ["L12", "L15", "L25", "Q"],
}

# The generators invert the second and first P1 factors, respectively.
# Thus the two opposite vertical boundary rulings are Galois conjugate, and
# their ambient coordinate spaces together span the whole representation.
block_actions = [
    {f"{i},{j}": f"{i},{1-j}" for i, j in itertools.product((0, 1), repeat=2)},
    {f"{i},{j}": f"{1-i},{j}" for i, j in itertools.product((0, 1), repeat=2)},
]
vertical_zero = weight_blocks["0,0"] + weight_blocks["0,1"]
vertical_one = weight_blocks["1,0"] + weight_blocks["1,1"]
assert set(vertical_zero).isdisjoint(vertical_one)
assert set(vertical_zero + vertical_one) == set(cox_names)

# Exact Cox Jacobian at the standard dense family of universal-torsor
# points e_i=1, l_ij=f_ij(z), q=f_Q(z).  Its restriction to one boundary
# ruling's eight-coordinate space has generic rank six.  Therefore its
# affine tangent space meets that coordinate space in dimension two, so a
# tangent hyperplane containing this ruling exists over the splitting field.
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
assert all(sp.expand(relation.subs(standard_point)) == 0 for relation in relations)
jacobian = sp.Matrix(relations).jacobian(coordinate_symbols).subs(standard_point)
edge_columns = [cox_names.index(name) for name in vertical_zero]
edge_jacobian = jacobian[:, edge_columns]
assert edge_jacobian.rank() == 6
minor_rows = (0, 1, 2, 3, 4, 7)
minor_columns = (0, 1, 2, 3, 4, 5)
minor = sp.factor(edge_jacobian.extract(minor_rows, minor_columns).det())
expected_minor = sp.factor(
    z3*(b*z1-z3)*(
        a*b*z1*z2-a*b*z1*z3+a*z1*z3-a*z2*z3
        -b*z1*z2+b*z2*z3
    )
)
assert minor == expected_minor

certificate = {
    "schema": "c925-i1-level3-descent-frontier-v1",
    "type_i1_group_order": len(group),
    "rank_two_sign_cocharacters": [
        [int(entry) for entry in vector] for vector in (v1, v2)
    ],
    "picard_cocharacter_lifts": [
        [int(entry) for entry in lift] for lift in lifts
    ],
    "cox_weight_blocks": weight_blocks,
    "generator_actions_on_weight_blocks": block_actions,
    "one_boundary_ruling_coordinate_space": vertical_zero,
    "galois_conjugate_opposite_ruling_coordinate_space": vertical_one,
    "opposite_ruling_spaces_span_all_coordinates": True,
    "boundary_ruling_jacobian_generic_rank": 6,
    "nonzero_six_minor_rows_zero_based": list(minor_rows),
    "nonzero_six_minor_columns_zero_based": list(minor_columns),
    "nonzero_six_minor_factorization": str(minor),
    "quotient_character_generator_actions": [
        [[int(entry) for entry in matrix.row(row)] for row in range(3)]
        for matrix in quotient_character_actions
    ],
    "quotient_character_carat_class": [3, 25, 2],
    "conclusion": (
        "The two sign directions have four Cox weight blocks of size four, "
        "so general orbit closures are Segre quadrics. Over a splitting "
        "field, the tangent space meets a boundary-ruling coordinate space "
        "in projective dimension one, enabling the expected one-boundary-" 
        "plus-one-open tangent slice. The ruling does not descend: a type-I1 "
        "generator exchanges it with the opposite ruling, and the two "
        "coordinate spaces span all P15. The residual rank-three character "
        "lattice has CARAT class (3,25,2)."
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
