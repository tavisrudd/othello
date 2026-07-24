#!/usr/bin/env python3
"""Exact C397 Clifford, operator-pushing, and signed-sheet certificate."""

from __future__ import annotations

import argparse
import collections
import hashlib
import importlib.util
import itertools
import json
import sys
import tempfile
from fractions import Fraction
from pathlib import Path
from typing import Iterable, Sequence


HERE = Path(__file__).resolve().parent
INPUT_C374 = HERE / "2026-07-19-c374-clebsch-ame-equivalence.py"
INPUT_C374_SHA256 = "15a99411b06f46f07e9b77a8593541031d98b4353fa0d9076d8452e2484ca694"
INPUT_C396 = HERE / "2026-07-23-c396-holonomy-completeness.py"
INPUT_C396_SHA256 = "b536913531c7393e92633b2c6521df50aa32a823a95cc4e92285a0955cc8fa49"
OUTPUT = HERE / "2026-07-23-c397-ame-perfect-tensor-physics.json"
Q = 11
N = 6

Vector = tuple[int, ...]
Matrix = tuple[Vector, ...]
Matrix2 = tuple[tuple[int, int], tuple[int, int]]
Permutation = tuple[int, ...]
GroupElement = tuple[Permutation, tuple[Matrix2, ...]]


def load_input(name: str, path: Path, digest: str):
    actual = hashlib.sha256(path.read_bytes()).hexdigest()
    if actual != digest:
        raise AssertionError(f"stale {name} input: {actual}")
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise AssertionError(f"cannot load {name}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


C374 = load_input("c397_c374", INPUT_C374, INPUT_C374_SHA256)
C396 = load_input("c397_c396", INPUT_C396, INPUT_C396_SHA256)
C395 = C396.C395


def pencil_code(t: int) -> Matrix:
    columns = (
        (0, 1, 1 - t),
        (0, 1, t - 1),
        (1, 1 - t, 0),
        (1, t - 1, 0),
        (1, 0, -t),
        (1, 0, t),
    )
    parity = tuple(tuple(columns[j][i] % Q for j in range(N)) for i in range(3))
    return C374.nullspace(parity)


def flat_block(block: Matrix2) -> tuple[int, int, int, int]:
    return block[0] + block[1]


def encode_element(element: GroupElement) -> tuple[int, ...]:
    permutation, blocks = element
    return permutation + tuple(value for block in blocks for value in flat_block(block))


def identity_element() -> GroupElement:
    block = ((1, 0), (0, 1))
    return tuple(range(N)), (block,) * N


def compose(first: GroupElement, second: GroupElement) -> GroupElement:
    """Apply first, then second."""
    p, a = first
    q, b = second
    return (
        tuple(q[p[i]] for i in range(N)),
        tuple(C374.m2_mul(b[p[i]], a[i]) for i in range(N)),
    )


def inverse_element(element: GroupElement) -> GroupElement:
    p, blocks = element
    pinv = tuple(p.index(i) for i in range(N))
    return pinv, tuple(C374.m2_inv(blocks[pinv[i]]) for i in range(N))


def closure(generators: Sequence[GroupElement]) -> tuple[GroupElement, ...]:
    identity = identity_element()
    known = {encode_element(identity): identity}
    queue = collections.deque([identity])
    moves = tuple(generators) + tuple(inverse_element(g) for g in generators)
    while queue:
        current = queue.popleft()
        for generator in moves:
            value = compose(current, generator)
            key = encode_element(value)
            if key not in known:
                known[key] = value
                queue.append(value)
    return tuple(known[key] for key in sorted(known))


def enumerate_symplectic_automorphisms(code: Matrix) -> tuple[GroupElement, ...]:
    data = C374.minimal_support_data(code)
    space = C374.stabilizer_space(code)
    all_sl2 = C374.sl2()
    supports_by_pair = {
        (a, b): next(s for s in sorted(data) if a in s and b in s)
        for a in range(N)
        for b in range(a + 1, N)
    }
    result: list[GroupElement] = []
    for permutation in itertools.permutations(range(N)):
        for anchor in all_sl2:
            local: list[Matrix2] = [((1, 0), (0, 1)) for _ in range(N)]
            local[0] = anchor
            valid = True
            for b in range(1, N):
                support = supports_by_pair[(0, b)]
                target_support = tuple(sorted(permutation[i] for i in support))
                source_rel = C374.relation(data, support, 0, b)
                target_rel = C374.relation(
                    data, target_support, permutation[0], permutation[b]
                )
                local[b] = C374.m2_mul(
                    C374.m2_mul(target_rel, anchor), C374.m2_inv(source_rel)
                )
                if C374.m2_det(local[b]) != 1:
                    valid = False
                    break
            if not valid:
                continue
            for support in sorted(data):
                a = support[0]
                target_support = tuple(sorted(permutation[i] for i in support))
                for b in support[1:]:
                    lhs = C374.m2_mul(
                        local[b], C374.relation(data, support, a, b)
                    )
                    rhs = C374.m2_mul(
                        C374.relation(
                            data, target_support, permutation[a], permutation[b]
                        ),
                        local[a],
                    )
                    if lhs != rhs:
                        valid = False
                        break
                if not valid:
                    break
            if valid:
                element = permutation, tuple(local)
                if C374.transform_stabilizer(space, *element) != space:
                    raise AssertionError("support propagation admitted a false automorphism")
                result.append(element)
    encoded = [encode_element(element) for element in result]
    if len(set(encoded)) != len(encoded):
        raise AssertionError("duplicate automorphism")
    return tuple(result)


def generating_set(group: Sequence[GroupElement]) -> tuple[GroupElement, ...]:
    generators: list[GroupElement] = []
    generated = closure(generators)
    known = {encode_element(element) for element in generated}
    for element in sorted(group, key=encode_element):
        if encode_element(element) in known:
            continue
        generators.append(element)
        generated = closure(generators)
        known = {encode_element(value) for value in generated}
        if len(known) == len(group):
            break
    if known != {encode_element(element) for element in group}:
        raise AssertionError("generators do not recover enumerated group")
    return tuple(generators)


def act_label(block: Matrix2, label: tuple[int, int]) -> tuple[int, int]:
    x, z = label
    return (
        (block[0][0] * x + block[0][1] * z) % Q,
        (block[1][0] * x + block[1][1] * z) % Q,
    )


def pushing_orbits(group: Sequence[GroupElement]) -> tuple[dict[str, object], ...]:
    labels = tuple((x, z) for x in range(Q) for z in range(Q) if (x, z) != (0, 0))
    relations = {
        (leg, label, omitted)
        for leg in range(N)
        for label in labels
        for omitted in itertools.combinations(tuple(i for i in range(N) if i != leg), 2)
    }
    unseen = set(relations)
    orbits: list[dict[str, object]] = []
    while unseen:
        seed = min(unseen)
        orbit = set()
        leg, label, omitted = seed
        support = set(range(N)) - set(omitted)
        for permutation, blocks in group:
            target_leg = permutation[leg]
            target_label = act_label(blocks[leg], label)
            target_support = {permutation[i] for i in support}
            target_omitted = tuple(sorted(set(range(N)) - target_support))
            orbit.add((target_leg, target_label, target_omitted))
        unseen -= orbit
        orbits.append(
            {
                "representative": {
                    "input_leg": leg,
                    "input_pauli_label": list(label),
                    "omitted_output_legs": list(omitted),
                },
                "size": len(orbit),
            }
        )
    if sum(int(orbit["size"]) for orbit in orbits) != len(relations):
        raise AssertionError("pushing orbits do not partition the relation set")
    return tuple(sorted(orbits, key=lambda item: (int(item["size"]), str(item["representative"]))))


def matrix2_closure(generators: Sequence[Matrix2]) -> set[Matrix2]:
    identity = ((1, 0), (0, 1))
    known = {identity}
    queue = collections.deque([identity])
    moves = tuple(generators) + tuple(C374.m2_inv(value) for value in generators)
    while queue:
        current = queue.popleft()
        for move in moves:
            value = C374.m2_mul(move, current)
            if value not in known:
                known.add(value)
                queue.append(value)
    return known


def matrix2_generators(group: Sequence[Matrix2]) -> tuple[Matrix2, ...]:
    generators: list[Matrix2] = []
    known = matrix2_closure(generators)
    for value in sorted(group, key=flat_block):
        if value in known:
            continue
        generators.append(value)
        known = matrix2_closure(generators)
        if len(known) == len(group):
            break
    if known != set(group):
        raise AssertionError("logical blocks were not generated")
    return tuple(generators)


def element_json(element: GroupElement) -> dict[str, object]:
    permutation, blocks = element
    return {
        "party_permutation_source_to_target": list(permutation),
        "local_symplectic_blocks": [
            [list(block[0]), list(block[1])] for block in blocks
        ],
    }


def code_certificate(name: str, code: Matrix) -> dict[str, object]:
    group = enumerate_symplectic_automorphisms(code)
    generators = generating_set(group)
    image = sorted({element[0] for element in group})
    kernel = tuple(element for element in group if element[0] == tuple(range(N)))
    logical: list[dict[str, object]] = []
    for leg in range(N):
        blocks = tuple(
            sorted(
            {
                element[1][leg]
                for element in group
                if element[0][leg] == leg
            },
                key=flat_block,
            )
        )
        block_generators = matrix2_generators(blocks)
        logical.append(
            {
                "input_leg": leg,
                "symplectic_order": len(blocks),
                "symplectic_generators": [
                    [list(block[0]), list(block[1])] for block in block_generators
                ],
                "projective_logical_clifford_order_including_paulis": len(blocks)
                * Q
                * Q,
            }
        )
    permutation_counts = collections.Counter(element[0] for element in group)
    if set(permutation_counts.values()) != {len(kernel)}:
        raise AssertionError("party projection fibres are not kernel cosets")
    independent_closure = closure(generators)
    if {encode_element(x) for x in independent_closure} != {
        encode_element(x) for x in group
    }:
        raise AssertionError("independent group closure failed")
    return {
        "name": name,
        "code_generator": [list(row) for row in code],
        "symplectic_automorphism_order": len(group),
        "party_permutation_image_order": len(image),
        "fixed_party_symplectic_kernel_order": len(kernel),
        "projective_local_clifford_order_including_stabilizer_paulis": len(group)
        * Q**N,
        "every_party_permutation_has_lifts": len(set(permutation_counts.values())) == 1,
        "generators": [element_json(element) for element in generators],
        "logical_encoder_views": logical,
        "minimum_output_support_for_nonidentity_single_input_pauli": 3,
        "pushing_relation_count": N * (Q * Q - 1) * 10,
        "pushing_orbits": list(pushing_orbits(group)),
    }


def poly_json(poly: Sequence[Fraction]) -> list[int | str]:
    result: list[int | str] = []
    for value in poly:
        result.append(value.numerator if value.denominator == 1 else str(value))
    return result


def symbolic_sheet_certificate() -> dict[str, object]:
    qtrim, qadd, qneg, qmul = C396.qtrim, C396.qadd, C396.qneg, C396.qmul
    zero, one, t = qtrim((0,)), qtrim((1,)), qtrim((0, 1))
    sub = lambda a, b: qadd(a, qneg(b))
    points = (
        (zero, one, qtrim((1, -1))),
        (zero, one, qtrim((-1, 1))),
        (one, qtrim((1, -1)), zero),
        (one, qtrim((-1, 1)), zero),
        (one, zero, qneg(t)),
        (one, zero, t),
    )
    bracket_rows = []
    for pair in itertools.combinations(range(1, N), 2):
        first = (0,) + pair
        second = tuple(index for index in range(N) if index not in first)
        value = C396.qmul(
            C396.qdet3(tuple(points[index] for index in first)),
            C396.qdet3(tuple(points[index] for index in second)),
        )
        if C395.permutation_sign(first + second) < 0:
            value = C396.qneg(value)
        bracket_rows.append(
            {
                "partition": [
                    [index + 1 for index in first],
                    [index + 1 for index in second],
                ],
                "polynomial_low_to_high": poly_json(value),
            }
        )
    projection_brackets = []
    for i, j in itertools.combinations(range(N), 2):
        a, b = points[i], points[j]
        cross = (
            sub(qmul(a[1], b[2]), qmul(a[2], b[1])),
            sub(qmul(a[2], b[0]), qmul(a[0], b[2])),
            sub(qmul(a[0], b[1]), qmul(a[1], b[0])),
        )
        projection_brackets.append(
            {
                "pair": [i + 1, j + 1],
                "coefficients_of_center_r_s_v": [poly_json(value) for value in cross],
            }
        )

    # A symbolic Gale generator and exact isoduality.  The columns below use
    # free kernel coordinates x_4,x_5,x_6.
    rat, radd, rneg, rmul, rdiv = (
        C396.rat,
        C396.radd,
        C396.rneg,
        C396.rmul,
        C396.rdiv,
    )
    two_t_minus_two = qtrim((-2, 2))
    dpoly = qtrim((1, -1, 1))
    epoly = qtrim((1, -3, 1))
    gale_columns = (
        (
            rat((1, -1)),
            rneg(rdiv(rat(dpoly), rat(two_t_minus_two))),
            rneg(rdiv(rat(epoly), rat(two_t_minus_two))),
        ),
        (
            rat((1, -1)),
            rneg(rdiv(rat(epoly), rat(two_t_minus_two))),
            rneg(rdiv(rat(dpoly), rat(two_t_minus_two))),
        ),
        (rat((-1,)), rat((-1,)), rat((-1,))),
        (rat((1,)), rat((0,)), rat((0,))),
        (rat((0,)), rat((1,)), rat((0,))),
        (rat((0,)), rat((0,)), rat((1,))),
    )
    transform = (
        (rat((1,)), rat((-1,)), rat((-1,))),
        (rat((0,)), rat((1, -1)), rat((-1, 1))),
        (rat((0, 1)), rat((0,)), rat((0,))),
    )
    gale_permutation = (0, 1, 4, 5, 3, 2)
    multipliers = (rat((0, 1)), rat((0, -1)), rat((1,)), rat((1,)), rat((-1,)), rat((-1,)))
    polynomial_points = tuple(
        tuple(rat(coordinate) for coordinate in point) for point in points
    )
    for index, column in enumerate(gale_columns):
        image = tuple(
            radd(radd(rmul(row[0], column[0]), rmul(row[1], column[1])), rmul(row[2], column[2]))
            for row in transform
        )
        target = tuple(
            rmul(multipliers[index], coordinate)
            for coordinate in polynomial_points[gale_permutation[index]]
        )
        if image != target:
            raise AssertionError("symbolic Gale isoduality failed")

    # Direct finite replay over three good prime fields independently checks
    # the symbolic fixed-permutation identity through canonical projective
    # normalization.
    gale_checks = []
    for prime in (11, 13, 101):
        field = C396.FiniteField(prime, (0, 1))
        checked = 0
        for integer in range(2, prime):
            value = field.element(integer)
            if any(
                polynomial == field.zero
                for polynomial in (
                    value,
                    field.sub(value, field.one),
                    field.peval((1, -1, 1), value),
                    field.peval((1, -3, 1), value),
                    field.peval((1, -4, 7, -4, 1), value),
                )
            ):
                continue
            parent = C395.ff_points(field, value)
            gale_matrix = C396.code_from_points(field, parent)
            gale_points = tuple(
                tuple(gale_matrix[row][column] for row in range(3))
                for column in range(N)
            )
            target = tuple(parent[gale_permutation[index]] for index in range(N))
            if not C396.pairwise_projectively_equivalent(field, gale_points, target):
                raise AssertionError("fixed Gale permutation failed")
            checked += 1
        gale_checks.append({"prime": prime, "admitted_parameters_checked": checked})
    return {
        "ten_signed_complementary_bracket_coordinates": bracket_rows,
        "five_coordinate_basis_indices": [0, 1, 5, 6, 7],
        "projection_sextic_brackets": projection_brackets,
        "projection_ratio_definition": "R1_ijkl=dij*dkl/(dik*djl), R2_ijkl=dij*dkl/(dil*djk)",
        "gale_source_to_target_party_permutation_zero_based": list(gale_permutation),
        "gale_permutation_parity": "odd",
        "gale_row_transform": [
            [[1], [-1], [-1]],
            [[0], [1, -1], [-1, 1]],
            [[0, 1], [0], [0]],
        ],
        "gale_column_multipliers": [[0, 1], [0, -1], [1], [1], [-1], [-1]],
        "gale_transform_determinant_low_to_high": [0, 2, -2],
        "gale_identity_denominator": "2(t-1)",
        "gale_fixes_complementary_bracket_products_and_w": True,
        "gale_finite_replays": gale_checks,
        "w_flip_projective_permutations_zero_based": [
            [0, 1, 2, 3, 5, 4],
            [0, 1, 4, 5, 2, 3],
        ],
        "w_flip_permutation_parities": ["odd", "even"],
        "gale_branch_divisor": "six points on a conic: z=-1/4 on the pencil",
        "w_to_z_branch_divisor": "w=0 or infinity: B=0 or A=0 on the parameter line",
    }


def rank_mod(rows: Iterable[Sequence[int]], prime: int) -> int:
    matrix = [[value % prime for value in row] for row in rows]
    rank = 0
    width = len(matrix[0]) if matrix else 0
    for column in range(width):
        pivot = next(
            (index for index in range(rank, len(matrix)) if matrix[index][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        scale = pow(matrix[rank][column], prime - 2, prime)
        matrix[rank] = [(scale * value) % prime for value in matrix[rank]]
        for index in range(len(matrix)):
            if index == rank or matrix[index][column] == 0:
                continue
            scale = matrix[index][column]
            matrix[index] = [
                (left - scale * right) % prime
                for left, right in zip(matrix[index], matrix[rank])
            ]
        rank += 1
        if rank == len(matrix):
            break
    return rank


def perm_compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[index]] for index in range(len(left)))


def perm_inverse(permutation: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(permutation.index(index) for index in range(len(permutation)))


def contraction_rank(
    code: Sequence[Sequence[int]], sigmas: Sequence[tuple[int, ...]], copies: int, prime: int
) -> int:
    rows: list[list[int]] = []
    for party in range(N):
        column = [code[row][party] % prime for row in range(3)]
        for copy in range(copies):
            equation = [0] * (6 * copies)
            for coordinate, value in enumerate(column):
                equation[3 * copy + coordinate] = value
                equation[3 * copies + 3 * sigmas[party][copy] + coordinate] = -value
            rows.append(equation)
    return rank_mod(rows, prime)


def normalized_contraction_signature(
    code: Sequence[Sequence[int]], copies: int, prime: int
) -> dict[tuple[tuple[int, ...], ...], int]:
    symmetric = tuple(itertools.permutations(range(copies)))
    identity = tuple(range(copies))
    result: dict[tuple[tuple[int, ...], ...], int] = {}
    for tail in itertools.product(symmetric, repeat=N - 1):
        sigmas = (identity,) + tail
        result[tail] = contraction_rank(code, sigmas, copies, prime)
    return result


def permuted_signature_key(
    tail: tuple[tuple[int, ...], ...], party_permutation: Permutation
) -> tuple[tuple[int, ...], ...]:
    identity = tuple(range(len(tail[0])))
    source = (identity,) + tail
    target: list[tuple[int, ...] | None] = [None] * N
    for party in range(N):
        target[party_permutation[party]] = source[party]
    raw = tuple(value for value in target if value is not None)
    left = perm_inverse(raw[0])
    return tuple(perm_compose(left, raw[index]) for index in range(1, N))


def q13_lu_contraction_certificate() -> dict[str, object]:
    prime = 13
    codes = {"z4_t2": pencil_code_mod(2, prime), "z12_t3": pencil_code_mod(3, prime)}
    signatures = {
        copies: {
            name: normalized_contraction_signature(code, copies, prime)
            for name, code in codes.items()
        }
        for copies in (2, 3)
    }
    comparisons: dict[str, object] = {}
    for copies in (2, 3):
        left = signatures[copies]["z4_t2"]
        right = signatures[copies]["z12_t3"]
        matching_parties = []
        witnesses = []
        for party_permutation in itertools.permutations(range(N)):
            mismatch = next(
                (
                    (tail, rank, right[permuted_signature_key(tail, party_permutation)])
                    for tail, rank in left.items()
                    if rank != right[permuted_signature_key(tail, party_permutation)]
                ),
                None,
            )
            if mismatch is None:
                matching_parties.append(list(party_permutation))
            elif len(witnesses) < 3:
                tail, left_rank, right_rank = mismatch
                witnesses.append(
                    {
                        "party_permutation": list(party_permutation),
                        "normalized_sigma_tail": [list(value) for value in tail],
                        "left_rank": left_rank,
                        "right_rank": right_rank,
                    }
                )
        comparisons[str(copies)] = {
            "normalized_contractions_checked": len(left),
            "party_permutations_checked": 720,
            "matching_party_permutations": matching_parties,
            "sample_mismatch_witnesses": witnesses,
            "left_rank_histogram": dict(
                sorted(collections.Counter(left.values()).items())
            ),
            "right_rank_histogram": dict(
                sorted(collections.Counter(right.values()).items())
            ),
        }
    candidates = [
        tuple(permutation)
        for permutation in comparisons["3"]["matching_party_permutations"]
    ]
    identity4 = tuple(range(4))
    left_code = codes["z4_t2"]
    right_code = codes["z12_t3"]
    surviving = set(candidates)
    eliminated: dict[Permutation, dict[str, object]] = {}
    separating_tails = (
        (
            (3, 2, 1, 0),
            (0, 1, 3, 2),
            (2, 3, 0, 1),
            (1, 0, 3, 2),
            (2, 0, 1, 3),
        ),
        (
            (0, 2, 1, 3),
            (3, 2, 0, 1),
            (3, 1, 0, 2),
            (2, 0, 3, 1),
            (1, 3, 2, 0),
        ),
    )
    for tail in separating_tails:
        left_rank = contraction_rank(
            left_code, (identity4,) + tail, 4, prime
        )
        for party_permutation in tuple(sorted(surviving)):
            target_tail = permuted_signature_key(tail, party_permutation)
            right_rank = contraction_rank(
                right_code, (identity4,) + target_tail, 4, prime
            )
            if left_rank != right_rank:
                eliminated[party_permutation] = {
                    "normalized_sigma_tail": [list(value) for value in tail],
                    "left_rank": left_rank,
                    "right_rank": right_rank,
                }
                surviving.remove(party_permutation)
    if surviving:
        raise AssertionError("degree-four witnesses did not eliminate all degree-three candidates")
    comparisons["4_staged"] = {
        "input_candidates_from_m3": len(candidates),
        "normalized_contractions_checked": len(separating_tails),
        "matching_party_permutations": [list(value) for value in sorted(surviving)],
        "elimination_witnesses": [
            {
                "party_permutation": list(permutation),
                **eliminated[permutation],
            }
            for permutation in sorted(eliminated)
        ],
        "separating_tails": [
            [list(value) for value in tail] for tail in separating_tails
        ],
    }
    symmetrized_histograms = {}
    first_tail = separating_tails[0]
    for name, code in codes.items():
        histogram = collections.Counter(
            contraction_rank(
                code,
                (identity4,) + permuted_signature_key(first_tail, party_permutation),
                4,
                prime,
            )
            for party_permutation in itertools.permutations(range(N))
        )
        symmetrized_histograms[name] = dict(sorted(histogram.items()))
    comparisons["4_party_symmetrized"] = {
        "seed_normalized_sigma_tail": [list(value) for value in first_tail],
        "party_orbit_size": 720,
        "rank_histograms": symmetrized_histograms,
        "orbit_sum_in_units_of_13^-9": {
            "z4_t2": sum(
                count * prime ** (21 - rank)
                for rank, count in symmetrized_histograms["z4_t2"].items()
            ),
            "z12_t3": sum(
                count * prime ** (21 - rank)
                for rank, count in symmetrized_histograms["z12_t3"].items()
            ),
        },
    }
    return {
        "field_order": prime,
        "classes": {
            name: [list(row) for row in code] for name, code in codes.items()
        },
        "normalization": "sigma_0=id after common bra-copy relabelling",
        "invariant_value_from_rank": "I=q^(3m-rank)",
        "comparisons_by_copy_number": comparisons,
    }


def nullspace_mod(rows: Iterable[Sequence[int]], width: int, prime: int) -> Matrix:
    matrix = [[value % prime for value in row] for row in rows]
    pivot_row = 0
    pivots: list[int] = []
    for column in range(width):
        pivot = next(
            (index for index in range(pivot_row, len(matrix)) if matrix[index][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        scale = pow(matrix[pivot_row][column], prime - 2, prime)
        matrix[pivot_row] = [
            (scale * value) % prime for value in matrix[pivot_row]
        ]
        for index in range(len(matrix)):
            if index == pivot_row or matrix[index][column] == 0:
                continue
            scale = matrix[index][column]
            matrix[index] = [
                (left - scale * right) % prime
                for left, right in zip(matrix[index], matrix[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
    free = [column for column in range(width) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * width
        vector[free_column] = 1
        for index, pivot_column in enumerate(pivots):
            vector[pivot_column] = -matrix[index][free_column] % prime
        basis.append(tuple(vector))
    return tuple(basis)


def pencil_code_mod(t: int, prime: int) -> Matrix:
    columns = (
        (0, 1, 1 - t),
        (0, 1, t - 1),
        (1, 1 - t, 0),
        (1, t - 1, 0),
        (1, 0, -t),
        (1, 0, t),
    )
    parity = tuple(
        tuple(columns[column][row] % prime for column in range(N))
        for row in range(3)
    )
    return nullspace_mod(parity, N, prime)


def build_certificate() -> dict[str, object]:
    codes: list[tuple[str, Matrix]] = [
        ("non_grs_t2_z1", pencil_code(2)),
        ("non_grs_t10_z9", pencil_code(10)),
    ]
    for representative, orbit_size in C374.grs_evaluation_orbits():
        label = "grs_" + "_".join("infinity" if x == Q else str(x) for x in representative)
        codes.append((f"{label}_orbit_{orbit_size}", C374.grs_code(representative)))
    return {
        "schema": "c397-ame-perfect-tensor-physics-v1",
        "field_order": Q,
        "inputs": {
            INPUT_C374.name: INPUT_C374_SHA256,
            INPUT_C396.name: INPUT_C396_SHA256,
        },
        "clifford_and_operator_pushing": [
            code_certificate(name, code) for name, code in codes
        ],
        "signed_sheet": symbolic_sheet_certificate(),
        "q13_arbitrary_lu_contractions": q13_lu_contraction_certificate(),
    }


def canonical_bytes(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(build_certificate())
    if args.write:
        OUTPUT.write_bytes(payload)
        return
    with tempfile.TemporaryDirectory() as directory:
        replay = Path(directory) / OUTPUT.name
        replay.write_bytes(payload)
        if not OUTPUT.exists():
            raise AssertionError(f"missing tracked certificate {OUTPUT}")
        if replay.read_bytes() != OUTPUT.read_bytes():
            raise AssertionError("certificate replay differs")
    print("C397 exact certificate replay: PASS")


if __name__ == "__main__":
    main()
