#!/usr/bin/env python3
"""Exact C710 certificate for McKay/Hamming E8 and the R10 seam."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from itertools import combinations, permutations, product
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-30-c710-e8-hamming-marking.json"
C705_JSON = ROOT / "2026-07-30-c705-clebsch-pauli-doily.json"

MCKAY_NODES = ("1", "2", "3", "4s", "5", "6", "3p", "4", "2p")
MCKAY_DIMENSIONS = (1, 2, 3, 4, 5, 6, 3, 4, 2)
MCKAY_EDGES = (
    ("1", "2"),
    ("2", "3"),
    ("3", "4s"),
    ("4s", "5"),
    ("5", "6"),
    ("6", "3p"),
    ("6", "4"),
    ("4", "2p"),
)
FINITE_NODES = MCKAY_NODES[1:]
HAMMING_ROWS = (0xFF, 0xF0, 0xCC, 0xAA)
R10_CHECK_ROWS = tuple(
    int(row, 2)
    for row in (
        "1100110000",
        "1110001000",
        "0111000100",
        "0011100010",
        "1001100001",
    )
)
BASE_C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
NODE_PARTITIONS = tuple(
    frozenset(partition)
    for partition in combinations(range(6), 3)
    if 0 in partition
)


def determinant(matrix):
    if not matrix:
        return 1
    return sum(
        (-1) ** column
        * matrix[0][column]
        * determinant(
            [
                row[:column] + row[column + 1 :]
                for row in matrix[1:]
            ]
        )
        for column in range(len(matrix))
    )


def rational_rank(matrix):
    from fractions import Fraction

    work = [[Fraction(entry) for entry in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        scale = work[row][column]
        work[row] = [entry / scale for entry in work[row]]
        for index in range(len(work)):
            if index != row and work[index][column]:
                scale = work[index][column]
                work[index] = [
                    work[index][j] - scale * work[row][j]
                    for j in range(len(work[0]))
                ]
        row += 1
    return row


def span(rows):
    code = {0}
    for row in rows:
        code |= {word ^ row for word in tuple(code)}
    return code


def weight_enumerator(code):
    return dict(sorted(Counter(word.bit_count() for word in code).items()))


def dot(left, right):
    return sum(a * b for a, b in zip(left, right))


def mckay_cartan():
    index = {node: i for i, node in enumerate(MCKAY_NODES)}
    matrix = [
        [2 * int(i == j) for j in range(len(MCKAY_NODES))]
        for i in range(len(MCKAY_NODES))
    ]
    for left, right in MCKAY_EDGES:
        i, j = index[left], index[right]
        matrix[i][j] = matrix[j][i] = -1
    return matrix


def hamming_roots(code):
    roots = []
    for coordinate in range(8):
        for sign in (-2, 2):
            roots.append(
                tuple(sign if index == coordinate else 0 for index in range(8))
            )
    for word in code:
        if word.bit_count() != 4:
            continue
        support = tuple(index for index in range(8) if (word >> index) & 1)
        for signs in product((-1, 1), repeat=4):
            roots.append(
                tuple(
                    signs[support.index(index)] if index in support else 0
                    for index in range(8)
                )
            )
    return tuple(roots)


def construction_a_roots(code, length):
    roots = []
    for coordinate in range(length):
        for sign in (-2, 2):
            roots.append(
                tuple(
                    sign if index == coordinate else 0
                    for index in range(length)
                )
            )
    for word in code:
        if word.bit_count() != 4:
            continue
        support = tuple(index for index in range(length) if (word >> index) & 1)
        for signs in product((-1, 1), repeat=4):
            roots.append(
                tuple(
                    signs[support.index(index)] if index in support else 0
                    for index in range(length)
                )
            )
    return tuple(roots)


def has_e8_simple_system(roots, first_root):
    edges = {
        frozenset(edge)
        for edge in ((0, 1), (1, 2), (2, 3), (3, 4), (4, 5), (4, 6), (6, 7))
    }
    chosen = {0: first_root}

    def extend(index):
        if index == 8:
            return True
        for root in roots:
            if root in chosen.values():
                continue
            if all(
                dot(root, chosen[prior])
                == (-2 if frozenset((index, prior)) in edges else 0)
                for prior in range(index)
            ):
                chosen[index] = root
                if extend(index + 1):
                    return True
                del chosen[index]
        return False

    return extend(1)


EXPLICIT_ROOTS = {
    "2": (2, 0, 0, 0, 0, 0, 0, 0),
    "3": (-1, -1, 0, 0, 0, 0, -1, -1),
    "4s": (0, 2, 0, 0, 0, 0, 0, 0),
    "5": (0, -1, -1, 0, 0, -1, 1, 0),
    "6": (0, 0, 2, 0, 0, 0, 0, 0),
    "3p": (0, 0, -1, -1, 0, 0, -1, 1),
    "4": (0, 0, -1, 1, -1, 1, 0, 0),
    "2p": (0, 0, 0, 0, 2, 0, 0, 0),
}


def delete_bit(word, coordinate):
    return (word & ((1 << coordinate) - 1)) | (
        (word >> (coordinate + 1)) << coordinate
    )


def code_minor(code, operations):
    result = code
    length = 10
    for coordinate, shorten in sorted(operations, reverse=True):
        result = {
            delete_bit(word, coordinate)
            for word in result
            if not shorten or not ((word >> coordinate) & 1)
        }
        length -= 1
    return result, length


def code_dimension(code):
    assert len(code) & (len(code) - 1) == 0
    return len(code).bit_length() - 1


def code_parameters(code, length):
    enumerator = weight_enumerator(code)
    return {
        "length": length,
        "dimension": code_dimension(code),
        "minimum_distance": min(weight for weight in enumerator if weight),
        "weight_enumerator": {str(weight): count for weight, count in enumerator.items()},
    }


def induced_node_permutation(permutation):
    result = []
    for partition in NODE_PARTITIONS:
        image = frozenset(permutation[index] for index in partition)
        if 0 not in image:
            image = frozenset(set(range(6)) - image)
        result.append(NODE_PARTITIONS.index(image))
    return tuple(result)


def conference_switch_data(permutation):
    for global_factor in (1, -1):
        switches = (1,) + tuple(
            global_factor
            * BASE_C[permutation[0]][permutation[index]]
            * BASE_C[0][index]
            for index in range(1, 6)
        )
        if all(
            BASE_C[permutation[i]][permutation[j]]
            == global_factor * switches[i] * switches[j] * BASE_C[i][j]
            for i, j in combinations(range(6), 2)
        ):
            return global_factor, switches
    return None


def representation_obstruction():
    node_actions = {
        induced_node_permutation(permutation)
        for permutation in permutations(range(6))
    }
    assert len(node_actions) == 720
    ordered_pair_orbit = {
        (action[0], action[1]) for action in node_actions
    }
    assert len(ordered_pair_orbit) == 90

    conference_actions = {
        induced_node_permutation(permutation)
        for permutation in permutations(range(6))
        if conference_switch_data(permutation) is not None
    }
    assert len(conference_actions) == 120
    orbital = {(action[0], action[1]) for action in conference_actions}
    assert len(orbital) == 30
    adjacency = [
        [int((i, j) in orbital) for j in range(10)] for i in range(10)
    ]
    assert {sum(row) for row in adjacency} == {3}
    eigenspace_dimensions = {
        eigenvalue: 10
        - rational_rank(
            [
                [
                    adjacency[i][j] - eigenvalue * int(i == j)
                    for j in range(10)
                ]
                for i in range(10)
            ]
        )
        for eigenvalue in (-2, 1, 3)
    }
    assert eigenspace_dimensions == {-2: 4, 1: 5, 3: 1}
    return {
        "S6_node_module": "Q^10 = 1 + irreducible 9 (two-transitive action)",
        "S6_invariant_dimensions": [0, 1, 9, 10],
        "conference_S5_node_module": "Q^10 = 1 + 4 + 5",
        "conference_S5_orbital_graph": "Petersen graph",
        "conference_S5_eigenspace_dimensions": {
            str(eigenvalue): dimension
            for eigenvalue, dimension in sorted(eigenspace_dimensions.items())
        },
        "conference_S5_invariant_dimensions": [0, 1, 4, 5, 6, 9, 10],
        "rank8_verdict": (
            "no S6-, conference-S5-, or golden-A5-equivariant rank-8 "
            "subspace or quotient exists"
        ),
    }


def build_certificate():
    cartan = mckay_cartan()
    assert rational_rank(cartan) == 8
    assert all(
        sum(cartan[i][j] * MCKAY_DIMENSIONS[j] for j in range(9)) == 0
        for i in range(9)
    )
    finite_gram = [row[1:] for row in cartan[1:]]
    assert determinant(finite_gram) == 1

    hamming = span(HAMMING_ROWS)
    assert weight_enumerator(hamming) == {0: 1, 4: 14, 8: 1}
    assert all(
        (left & right).bit_count() % 2 == 0
        for left in hamming
        for right in hamming
    )
    roots = hamming_roots(hamming)
    assert len(roots) == len(set(roots)) == 240
    explicit = [EXPLICIT_ROOTS[node] for node in FINITE_NODES]
    assert all(root in roots for root in explicit)
    explicit_gram = [
        [dot(left, right) // 2 for right in explicit] for left in explicit
    ]
    assert explicit_gram == finite_gram
    assert determinant(explicit_gram) == 1
    affine_root = tuple(
        -sum(
            MCKAY_DIMENSIONS[index + 1] * explicit[index][coordinate]
            for index in range(8)
        )
        for coordinate in range(8)
    )
    assert affine_root in roots
    assert dot(affine_root, affine_root) == 4
    assert [
        dot(affine_root, root) // 2 for root in explicit
    ] == [-1, 0, 0, 0, 0, 0, 0, 0]

    r10 = {
        word
        for word in range(1 << 10)
        if all((word & check).bit_count() % 2 == 0 for check in R10_CHECK_ROWS)
    }
    assert weight_enumerator(r10) == {0: 1, 4: 15, 6: 15, 10: 1}
    nonintegral_witness = next(
        (left, right)
        for left in r10
        for right in r10
        if (left & right).bit_count() % 2
    )
    q10_roots = construction_a_roots(r10, 10)
    assert len(q10_roots) == len(set(q10_roots)) == 260
    coordinate_root = (2,) + (0,) * 9
    weight_four_root = next(
        root for root in q10_roots if all(abs(entry) <= 1 for entry in root)
    )
    assert not has_e8_simple_system(q10_roots, coordinate_root)
    assert not has_e8_simple_system(q10_roots, weight_four_root)
    minor_records = Counter()
    for left, right in combinations(range(10), 2):
        for kind, operations in (
            ("puncture_puncture", ((left, False), (right, False))),
            ("shorten_shorten", ((left, True), (right, True))),
            ("shorten_puncture", ((left, True), (right, False))),
            ("shorten_puncture", ((left, False), (right, True))),
        ):
            minor, length = code_minor(r10, operations)
            record = code_parameters(minor, length)
            key = (
                kind,
                record["dimension"],
                record["minimum_distance"],
                tuple(sorted(record["weight_enumerator"].items())),
            )
            minor_records[key] += 1
    assert len(minor_records) == 3
    minor_table = []
    for (kind, dimension, distance, enumerator), count in sorted(minor_records.items()):
        minor_table.append(
            {
                "operation": kind,
                "count": count,
                "parameters": [8, dimension, distance],
                "weight_enumerator": dict(enumerator),
            }
        )
    assert {
        record["operation"]: record["parameters"] for record in minor_table
    } == {
        "puncture_puncture": [8, 5, 2],
        "shorten_shorten": [8, 3, 4],
        "shorten_puncture": [8, 4, 3],
    }
    assert all(record["weight_enumerator"] != {"0": 1, "4": 14, "8": 1} for record in minor_table)
    c705 = json.loads(C705_JSON.read_text())["ordinary_gauge_classification"]
    assert c705["isodual_permutation_count"] == 720
    assert c705["isodual_cycle_type_distribution"]["2,2,2,2,2"] == 36

    return {
        "schema": "c710-e8-hamming-marking-v1",
        "mckay_lattice": {
            "basis": list(MCKAY_NODES),
            "dimension_vector": list(MCKAY_DIMENSIONS),
            "affine_cartan_rank": 8,
            "radical": "dimension vector of the nine 2.A5 irreducibles",
            "finite_basis": list(FINITE_NODES),
            "finite_gram": finite_gram,
            "determinant": 1,
        },
        "hamming_construction_a": {
            "generator_rows_hex": [f"{row:02x}" for row in HAMMING_ROWS],
            "weight_enumerator": {"0": 1, "4": 14, "8": 1},
            "root_count": len(roots),
            "coordinate_convention": (
                "L={x/sqrt(2): x in Z^8, x mod 2 in H8}; "
                "root numerators have squared length 4"
            ),
        },
        "explicit_isometry": {
            "map_from_mckay_finite_nodes_to_root_numerators": {
                node: list(EXPLICIT_ROOTS[node]) for node in FINITE_NODES
            },
            "gram_equality": "dot(root_i,root_j)/2 = finite McKay Cartan",
            "basis_certificate": "common Gram determinant 1",
            "affine_root_numerator": list(affine_root),
            "affine_root_relation": (
                "alpha_0=-sum_i dim(rho_i) alpha_i"
            ),
        },
        "r10_q10": {
            "parameters": [10, 5, 4],
            "weight_enumerator": {"0": 1, "4": 15, "6": 15, "10": 1},
            "construction_a": (
                "covolume-one isodual Q10, but nonintegral because R10 "
                "is not self-orthogonal"
            ),
            "nonintegral_codeword_witnesses": [
                f"{nonintegral_witness[0]:010b}",
                f"{nonintegral_witness[1]:010b}",
            ],
            "odd_support_intersection": (
                nonintegral_witness[0] & nonintegral_witness[1]
            ).bit_count(),
            "root_count": len(q10_roots),
            "root_orbits": {
                "coordinate_type": 20,
                "weight_four_type": 240,
            },
            "e8_root_subsystem": (
                "none; exhaustive simple-system search from representatives "
                "of both root orbits"
            ),
            "all_two_coordinate_minors": minor_table,
            "hamming_minor_count": 0,
            "structural_reason": (
                "R10 is regular and all its minors are regular, whereas "
                "the extended Hamming matroid has a Fano minor"
            ),
        },
        "equivariance": representation_obstruction(),
        "bad_prime_comparison": {
            "2": (
                "R10 is isodual but not self-orthogonal, so Q10 is "
                "nonintegral; H8 is doubly-even self-dual and gives integral E8"
            ),
            "3": "both E8 Gram models remain unimodular; no lattice degeneration",
            "5": (
                "both E8 Gram models remain unimodular; the golden "
                "ramification belongs to the operator/eigenspace marking"
            ),
        },
        "nearest_positive_repair": {
            "lattice": "II_(10,10)",
            "construction": (
                "for L=ConstructionA(R10), use L direct-sum L* with "
                "bilinear form <(x,f),(y,g)>=f(y)+g(x)"
            ),
            "properties": (
                "even unimodular of signature (10,10); its Gram matrix "
                "in dual bases is [[0,I10],[I10,0]]"
            ),
            "exchange": (
                "an isoduality P:L->L* gives the exchange isometry "
                "J_P(x,f)=((P*)^-1 f,Px); it is involutive exactly when "
                "P=P*"
            ),
            "self_adjoint_isodualities": 36,
            "self_adjoint_meaning": (
                "the 36 fixed-point-free W10 polarities; their coordinate "
                "cycle type 2^5 gives fixed and anti-fixed graph signatures "
                "(5,5), and the golden six retain F20 stabilizers"
            ),
            "meaning": (
                "Q10 and its dual, not positive-definite E8, are the "
                "natural lattice carrier of the W10 sister exchange"
            ),
        },
        "verdict": (
            "the bare McKay and Hamming E8 lattices are explicitly "
            "isometric, but no simultaneous Clebsch marking exists: "
            "R10 has no H8 two-coordinate minor and its 10-node module "
            "has no equivariant rank-8 subspace or quotient; even without "
            "equivariance Q10 contains no E8 root subsystem"
        ),
    }


def canonical_bytes(data):
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    encoded = canonical_bytes(build_certificate())
    if args.write:
        OUTPUT.write_bytes(encoded)
    else:
        assert OUTPUT.read_bytes() == encoded
    print(
        json.dumps(
            {
                "certificate": OUTPUT.name,
                "bytes": len(encoded),
                "sha256": hashlib.sha256(encoded).hexdigest(),
                "status": "written" if args.write else "verified",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
