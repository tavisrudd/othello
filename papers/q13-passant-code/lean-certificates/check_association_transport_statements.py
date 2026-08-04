#!/usr/bin/env python3
"""Emulate the Lean definitions of the association-transport packet on the committed literals.

This does not re-derive the mathematics; it checks that each Lean statement, read literally as
Lean will elaborate it, is the statement intended -- transpose orientation, factor order, and the
arity of each index type.
"""

import re
import sys
from pathlib import Path

PKG = Path(__file__).parent / "PassantCodeQ13"
Q = 13

VERBOSE = "--verbose" in sys.argv
failures = []


def check(name, condition):
    if VERBOSE:
        print(f"{'ok  ' if condition else 'FAIL'}  {name}")
    if not condition:
        failures.append(name)


def read_lists(path):
    text = path.read_text()
    out = {}
    for match in re.finditer(r"def (\w+) : List Nat := \[(.*?)\]", text, re.S):
        out[match.group(1)] = [int(v) for v in match.group(2).replace("\n", " ").split(",")]
    return out


DATA = read_lists(PKG / "AssociationTransport/RelationData.lean")
ORBITS = read_lists(PKG / "MinimumWords/OrbitData.lean")


# --- the geometry, from RelativeConicArcs.PassantCodeQ13.Geometry / AssociationAlgebra -----------

def projective_triples():
    return ([(1, y, z) for y in range(Q) for z in range(Q)]
            + [(0, 1, z) for z in range(Q)] + [(0, 0, 1)])


def discriminant(p):
    return (p[1] * p[1] - p[0] * p[2]) % Q


SQUARES = {v * v % Q for v in range(1, Q)}
INTERNAL = [p for p in projective_triples()
            if discriminant(p) != 0 and discriminant(p) not in SQUARES]


def rho(i, j):
    u, v = INTERNAL[i], INTERNAL[j]
    polar = (2 * u[1] * v[1] - u[0] * v[2] - u[2] * v[0]) % Q
    return polar * polar % Q * pow(discriminant(u) * discriminant(v) % Q, Q - 2, Q) % Q


# --- the Lean definitions ------------------------------------------------------------------------

def mask_matrix(rows, row_card, column_card):
    """maskMatrix rows : Matrix (Fin row_card) (Fin column_card) Bool."""
    return [[bool((rows[r] if r < len(rows) else 0) >> c & 1) for c in range(column_card)]
            for r in range(row_card)]


def relation_boolean_matrix(value):
    """relationBooleanMatrix value : Matrix Coordinate Coordinate Bool."""
    return [[r != c and rho(r, c) == value for c in range(78)] for r in range(78)]


def orbit_support_boolean_matrix(orbit):
    """orbitSupportBooleanMatrix orbit : Matrix OrbitCoordinate Coordinate Bool."""
    return mask_matrix(orbit, 91, 78)


def transpose(m):
    return [list(row) for row in zip(*m)]


def boolean_parity_product(left, right):
    """booleanParityProduct: rows of left by columns of right, parity of the pairwise conjunction."""
    middle = len(right)
    return [[bool(sum(1 for m in range(middle) if left[r][m] and right[m][c]) % 2)
             for c in range(len(right[0]))] for r in range(len(left))]


def selected_row_xor(selector, rows):
    """selectedRowXor selector 0 rows."""
    value = 0
    for position, row in enumerate(rows):
        if selector >> position & 1:
            value ^= row
    return value


def mask_product(left, right):
    return [selected_row_xor(row, right) for row in left]


def mask_xor(left, right):
    return [a ^ b for a, b in zip(left, right)]


def identity_masks(card):
    return [1 << index for index in range(card)]


def boolean_identity_matrix(card):
    return [[r == c for c in range(card)] for r in range(card)]


# --- the statements, one per Lean theorem --------------------------------------------------------

RELATIONS = {0: "relationRowsRhoZero", 9: "relationRowsRhoNine",
             10: "relationRowsRhoTen", 12: "relationRowsRhoTwelve"}
ORBIT_SPEC = {"Symmetric": ("orbitSymmetricSupports", "orbitSymmetricColumns", 9),
              "DihedralA": ("orbitDihedralASupports", "orbitDihedralAColumns", 9),
              "DihedralB": ("orbitDihedralBSupports", "orbitDihedralBColumns", 12),
              "DihedralC": ("orbitDihedralCSupports", "orbitDihedralCColumns", 10)}

for value, name in RELATIONS.items():
    check(f"{name}_entry_certificate",
          mask_matrix(DATA[name], 78, 78) == relation_boolean_matrix(value))
    check(f"{name}_length", len(DATA[name]) == 78)

for orbit, (supports, columns, _) in ORBIT_SPEC.items():
    check(f"{orbit}Columns_entry_certificate",
          mask_matrix(DATA[columns], 78, 91)
          == transpose(orbit_support_boolean_matrix(ORBITS[supports])))
    check(f"{orbit}Supports_length", len(ORBITS[supports]) == 91)
    check(f"{orbit}Columns_length", len(DATA[columns]) == 78)

for orbit, (supports, columns, target) in ORBIT_SPEC.items():
    gram_masks = mask_product(DATA[columns], ORBITS[supports])
    check(f"{orbit} gram mask identity", gram_masks == DATA[RELATIONS[target]])
    # the same product, computed as booleanParityProduct on the semantic matrices
    N = orbit_support_boolean_matrix(ORBITS[supports])
    check(f"{orbit} gram is N-transpose times N",
          mask_matrix(gram_masks, 78, 78) == boolean_parity_product(transpose(N), N))
    kernel_masks = mask_product(DATA["relationRowsRhoZero"], DATA[columns])
    check(f"{orbit} kernel mask identity", kernel_masks == [0] * 78)
    check(f"{orbit} kernel is A0 times N-transpose",
          mask_matrix(kernel_masks, 78, 91)
          == boolean_parity_product(relation_boolean_matrix(0), transpose(N)))

for source, target in ((9, 10), (10, 12), (12, 9)):
    check(f"A{source} squared is A{target}",
          mask_product(DATA[RELATIONS[source]], DATA[RELATIONS[source]]) == DATA[RELATIONS[target]])
rhs = mask_xor(identity_masks(78),
               mask_xor(DATA[RELATIONS[9]], mask_xor(DATA[RELATIONS[10]], DATA[RELATIONS[12]])))
check("A0 squared is I + A9 + A10 + A12",
      mask_product(DATA[RELATIONS[0]], DATA[RELATIONS[0]]) == rhs)
check("identityMasks 78 is the Boolean identity",
      mask_matrix(identity_masks(78), 78, 78) == boolean_identity_matrix(78))

check("A10 A9 is A12 + A9",
      mask_product(DATA[RELATIONS[10]], DATA[RELATIONS[9]])
      == mask_xor(DATA[RELATIONS[12]], DATA[RELATIONS[9]]))
B = DATA[RELATIONS[9]]
B2 = mask_product(B, B)
B3 = mask_product(B2, B)
B4 = mask_product(B3, B)
check("B squared is A10", B2 == DATA[RELATIONS[10]])
check("B cubed is B squared times B, and equals A12 + A9",
      B3 == mask_xor(DATA[RELATIONS[12]], DATA[RELATIONS[9]]))
check("B to the fourth is B squared squared", B4 == mask_product(B2, B2))
check("B to the fourth is A12", B4 == DATA[RELATIONS[12]])
check("B^4 + B^3 + B vanishes", mask_xor(mask_xor(B4, B3), B) == [0] * 78)

check("maskProduct A9 A9 agrees with booleanParityProduct",
      mask_matrix(mask_product(DATA[RELATIONS[9]], DATA[RELATIONS[9]]), 78, 78)
      == boolean_parity_product(relation_boolean_matrix(9), relation_boolean_matrix(9)))

if failures:
    print(f"{len(failures)} failure(s): " + ", ".join(failures))
    sys.exit(1)
print("q=13 association transport statements: PASS")
