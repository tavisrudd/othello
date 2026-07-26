#!/usr/bin/env python3
"""Exact party-permutation extensions for the C624 AME--LU examples."""

from __future__ import annotations

import argparse
import collections
import hashlib
import importlib.util
import itertools
import json
import tempfile
from pathlib import Path
from typing import Iterable, Sequence


HERE = Path(__file__).resolve().parent
C374_PATH = HERE / "2026-07-19-c374-clebsch-ame-equivalence.py"
C374_SHA256 = "15a99411b06f46f07e9b77a8593541031d98b4353fa0d9076d8452e2484ca694"
C397_PATH = HERE / "2026-07-23-c397-ame-perfect-tensor-physics.json"
C397_SHA256 = "c0a2df44ad991f59bb95182544bf4ac8d39d7a997c6bd1ea987e4020266c1dfd"
OUTPUT = HERE / "2026-07-25-c624-ame-lu-party-extension-examples.json"
N = 6

Vector = tuple[int, ...]
Matrix = tuple[Vector, ...]
Matrix2 = tuple[tuple[int, int], tuple[int, int]]
Permutation = tuple[int, ...]
GroupElement = tuple[Permutation, tuple[Matrix2, ...]]


def load_c374():
    actual = hashlib.sha256(C374_PATH.read_bytes()).hexdigest()
    if actual != C374_SHA256:
        raise AssertionError(f"stale C374 input: {actual}")
    spec = importlib.util.spec_from_file_location("c624_c374", C374_PATH)
    if spec is None or spec.loader is None:
        raise AssertionError("cannot import C374")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C374 = load_c374()


def set_field(q: int) -> None:
    C374.Q = q


def m2_mul(left: Matrix2, right: Matrix2, q: int) -> Matrix2:
    return (
        (
            (left[0][0] * right[0][0] + left[0][1] * right[1][0]) % q,
            (left[0][0] * right[0][1] + left[0][1] * right[1][1]) % q,
        ),
        (
            (left[1][0] * right[0][0] + left[1][1] * right[1][0]) % q,
            (left[1][0] * right[0][1] + left[1][1] * right[1][1]) % q,
        ),
    )


def m2_inv(block: Matrix2, q: int) -> Matrix2:
    determinant = (block[0][0] * block[1][1] - block[0][1] * block[1][0]) % q
    inverse_determinant = pow(determinant, q - 2, q)
    return (
        (
            block[1][1] * inverse_determinant % q,
            -block[0][1] * inverse_determinant % q,
        ),
        (
            -block[1][0] * inverse_determinant % q,
            block[0][0] * inverse_determinant % q,
        ),
    )


def identity_element() -> GroupElement:
    identity = ((1, 0), (0, 1))
    return tuple(range(N)), (identity,) * N


def compose(first: GroupElement, second: GroupElement, q: int) -> GroupElement:
    """The product first*second in the source-to-target convention."""
    p, a = first
    r, b = second
    return (
        tuple(r[p[i]] for i in range(N)),
        tuple(m2_mul(b[p[i]], a[i], q) for i in range(N)),
    )


def inverse_element(element: GroupElement, q: int) -> GroupElement:
    permutation, blocks = element
    inverse_permutation = tuple(permutation.index(i) for i in range(N))
    return (
        inverse_permutation,
        tuple(m2_inv(blocks[inverse_permutation[i]], q) for i in range(N)),
    )


def power(element: GroupElement, exponent: int, q: int) -> GroupElement:
    result = identity_element()
    base = element
    while exponent:
        if exponent & 1:
            result = compose(result, base, q)
        base = compose(base, base, q)
        exponent //= 2
    return result


def encode_element(element: GroupElement) -> tuple[int, ...]:
    permutation, blocks = element
    return permutation + tuple(value for block in blocks for row in block for value in row)


def permutation_compose(first: Permutation, second: Permutation) -> Permutation:
    return tuple(second[first[i]] for i in range(N))


def permutation_inverse(permutation: Permutation) -> Permutation:
    return tuple(permutation.index(i) for i in range(N))


def permutation_power(permutation: Permutation, exponent: int) -> Permutation:
    result = tuple(range(N))
    while exponent:
        if exponent & 1:
            result = permutation_compose(result, permutation)
        permutation = permutation_compose(permutation, permutation)
        exponent //= 2
    return result


def permutation_order(permutation: Permutation) -> int:
    value = tuple(range(N))
    for order in range(1, 121):
        value = permutation_compose(value, permutation)
        if value == tuple(range(N)):
            return order
    raise AssertionError("permutation order exceeds S6")


def permutation_is_odd(permutation: Permutation) -> bool:
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(N)
        for j in range(i + 1, N)
    )
    return inversions % 2 == 1


def permutation_closure(generators: Sequence[Permutation]) -> tuple[Permutation, ...]:
    identity = tuple(range(N))
    known = {identity}
    queue = collections.deque([identity])
    moves = tuple(generators) + tuple(permutation_inverse(g) for g in generators)
    while queue:
        current = queue.popleft()
        for move in moves:
            value = permutation_compose(current, move)
            if value not in known:
                known.add(value)
                queue.append(value)
    return tuple(sorted(known))


def group_closure(
    generators: Sequence[GroupElement], q: int, limit: int | None = None
) -> tuple[GroupElement, ...] | None:
    identity = identity_element()
    known = {encode_element(identity): identity}
    queue = collections.deque([identity])
    moves = tuple(generators) + tuple(inverse_element(g, q) for g in generators)
    while queue:
        current = queue.popleft()
        for move in moves:
            value = compose(current, move, q)
            key = encode_element(value)
            if key not in known:
                known[key] = value
                if limit is not None and len(known) > limit:
                    return None
                queue.append(value)
    return tuple(known[key] for key in sorted(known))


def primitive_root(q: int) -> int:
    factors = {p for p in range(2, q) if (q - 1) % p == 0 and all(p % d for d in range(2, int(p**0.5) + 1))}
    for value in range(2, q):
        if all(pow(value, (q - 1) // p, q) != 1 for p in factors):
            return value
    raise AssertionError("no primitive root")


def pencil_code(q: int, t: int) -> Matrix:
    set_field(q)
    columns = (
        (0, 1, 1 - t),
        (0, 1, t - 1),
        (1, 1 - t, 0),
        (1, t - 1, 0),
        (1, 0, -t),
        (1, 0, t),
    )
    parity = tuple(tuple(columns[j][i] % q for j in range(N)) for i in range(3))
    return C374.nullspace(parity)


def grs_code(q: int, evaluation_set: Sequence[int]) -> Matrix:
    set_field(q)
    return C374.rowspace(
        (
            tuple(1 for _ in evaluation_set),
            tuple(x % q for x in evaluation_set),
            tuple((x * x) % q for x in evaluation_set),
        )
    )


def valid_lift(
    code: Matrix, permutation: Permutation, anchor: Matrix2, q: int
) -> GroupElement | None:
    set_field(q)
    data = C374.minimal_support_data(code)
    space = C374.stabilizer_space(code)
    supports_by_pair = {
        (a, b): next(s for s in sorted(data) if a in s and b in s)
        for a in range(N)
        for b in range(a + 1, N)
    }
    local: list[Matrix2] = [((1, 0), (0, 1)) for _ in range(N)]
    local[0] = anchor
    for b in range(1, N):
        support = supports_by_pair[(0, b)]
        target_support = tuple(sorted(permutation[i] for i in support))
        source_relation = C374.relation(data, support, 0, b)
        target_relation = C374.relation(
            data, target_support, permutation[0], permutation[b]
        )
        local[b] = m2_mul(
            m2_mul(target_relation, anchor, q), m2_inv(source_relation, q), q
        )
        if C374.m2_det(local[b]) != 1:
            return None
    for support in sorted(data):
        a = support[0]
        target_support = tuple(sorted(permutation[i] for i in support))
        for b in support[1:]:
            lhs = m2_mul(local[b], C374.relation(data, support, a, b), q)
            rhs = m2_mul(
                C374.relation(
                    data, target_support, permutation[a], permutation[b]
                ),
                local[a],
                q,
            )
            if lhs != rhs:
                return None
    element = permutation, tuple(local)
    if C374.transform_stabilizer(space, *element) != space:
        raise AssertionError("support propagation admitted a false lift")
    return element


def sl2(q: int) -> tuple[Matrix2, ...]:
    result = []
    for a, b, c, d in itertools.product(range(q), repeat=4):
        if (a * d - b * c) % q == 1:
            result.append(((a, b), (c, d)))
    return tuple(result)


def kernel_and_section(
    code: Matrix, q: int, kind: str
) -> tuple[tuple[GroupElement, ...], dict[Permutation, GroupElement]]:
    identity_block = ((1, 0), (0, 1))
    fourier_block = ((0, 1), (-1 % q, 0))
    if kind == "torus":
        anchors = (identity_block, fourier_block)
        generator = primitive_root(q)
        kernel_anchors = tuple(
            ((pow(generator, exponent, q), 0), (0, pow(generator, -exponent, q)))
            for exponent in range(q - 1)
        )
    elif kind == "sl2":
        anchors = (identity_block,)
        kernel_anchors = sl2(q)
    else:
        raise AssertionError(kind)
    kernel = tuple(
        lift
        for anchor in kernel_anchors
        if (lift := valid_lift(code, tuple(range(N)), anchor, q)) is not None
    )
    if len(kernel) != len(kernel_anchors):
        raise AssertionError(
            f"fixed-party kernel is smaller than asserted: "
            f"{len(kernel)} != {len(kernel_anchors)} over F_{q}"
        )
    section: dict[Permutation, GroupElement] = {}
    for permutation in itertools.permutations(range(N)):
        candidates = [
            lift
            for anchor in anchors
            if (lift := valid_lift(code, permutation, anchor, q)) is not None
        ]
        if candidates:
            section[permutation] = min(candidates, key=encode_element)
    section[tuple(range(N))] = identity_element()
    return kernel, section


def element_order(element: GroupElement, q: int, bound: int) -> int:
    value = identity_element()
    for order in range(1, bound + 1):
        value = compose(value, element, q)
        if value == identity_element():
            return order
    return bound + 1


def two_generators(group: Sequence[Permutation]) -> tuple[Permutation, ...]:
    identity = tuple(range(N))
    if len(group) == 1:
        return ()
    for first in group:
        if first == identity:
            continue
        if len(permutation_closure((first,))) == len(group):
            return (first,)
    for first in group:
        if first == identity:
            continue
        for second in group:
            if second == identity:
                continue
            if len(permutation_closure((first, second))) == len(group):
                return first, second
    raise AssertionError("party group is not two-generated")


def all_lifts(
    section_lift: GroupElement, kernel: Sequence[GroupElement], q: int
) -> tuple[GroupElement, ...]:
    return tuple(compose(k, section_lift, q) for k in kernel)


def find_complement(
    party_group: Sequence[Permutation],
    section: dict[Permutation, GroupElement],
    kernel: Sequence[GroupElement],
    q: int,
) -> tuple[bool, tuple[GroupElement, ...] | None, dict[str, int]]:
    generators = two_generators(party_group)
    if not generators:
        return True, (), {"candidate_tuples_checked": 1}
    fibers = []
    for permutation in generators:
        order = permutation_order(permutation)
        candidates = tuple(
            lift
            for lift in all_lifts(section[permutation], kernel, q)
            if element_order(lift, q, order) == order
        )
        fibers.append(candidates)
    checked = 0
    if len(generators) == 1:
        if fibers[0]:
            return True, (fibers[0][0],), {"candidate_tuples_checked": 1}
        return False, None, {"candidate_tuples_checked": 0}
    for first in fibers[0]:
        for second in fibers[1]:
            checked += 1
            subgroup = group_closure((first, second), q, limit=len(party_group))
            if subgroup is None or len(subgroup) != len(party_group):
                continue
            if len({element[0] for element in subgroup}) == len(party_group):
                return True, (first, second), {"candidate_tuples_checked": checked}
    return False, None, {"candidate_tuples_checked": checked}


def action_on_stabilizer(code: Matrix, element: GroupElement, q: int) -> Matrix:
    set_field(q)
    space = C374.stabilizer_space(code)
    pivots = C374.rref(space)[1]
    transformed_rows = []
    for row in space:
        transformed = C374.transform_stabilizer((row,), *element)
        if len(transformed) != 1:
            raise AssertionError("nonzero stabilizer row vanished")
        transformed_rows.append(tuple(transformed[0][pivot] for pivot in pivots))
    return tuple(transformed_rows)


def matrix2_json(block: Matrix2) -> list[list[int]]:
    return [list(row) for row in block]


def element_json(element: GroupElement) -> dict[str, object]:
    return {
        "party_permutation_source_to_target": list(element[0]),
        "local_symplectic_blocks": [
            matrix2_json(block) for block in element[1]
        ],
    }


def identify_party_group(group: Sequence[Permutation]) -> str:
    order_histogram = collections.Counter(permutation_order(g) for g in group)
    key = (len(group), tuple(sorted(order_histogram.items())))
    known = {
        (4, ((1, 1), (2, 3))): "V4",
        (5, ((1, 1), (5, 4))): "C5",
        (6, ((1, 1), (2, 3), (3, 2))): "S3",
        (12, ((1, 1), (2, 3), (3, 8))): "A4",
        (12, ((1, 1), (2, 7), (3, 2), (6, 2))): "D12",
        (24, ((1, 1), (2, 9), (3, 8), (4, 6))): "S4",
        (120, ((1, 1), (2, 25), (3, 20), (4, 30), (5, 24), (6, 20))): "S5",
    }
    return known.get(key, f"order-{len(group)}:{dict(sorted(order_histogram.items()))}")


def outer_action_label(
    kind: str,
    q: int,
    kernel: Sequence[GroupElement],
    conjugation: Sequence[int],
) -> str:
    if kind == "torus":
        image = conjugation[1]
        if image == 1:
            return "identity_on_T"
        if image == q - 2:
            return "inversion_on_T"
        return f"power_{image}_on_T"
    anchors = [element[1][0] for element in kernel]
    index = {block: i for i, block in enumerate(anchors)}
    upper = ((1, 1), (0, 1))
    lower = ((1, 0), (1, 1))
    upper_image = anchors[conjugation[index[upper]]]
    lower_image = anchors[conjugation[index[lower]]]
    witnesses: list[Matrix2] = []
    for a, b, c, d in itertools.product(range(q), repeat=4):
        determinant = (a * d - b * c) % q
        if determinant == 0:
            continue
        candidate = ((a, b), (c, d))
        candidate_inverse = m2_inv(candidate, q)
        if (
            m2_mul(m2_mul(candidate, upper, q), candidate_inverse, q)
            == upper_image
            and m2_mul(m2_mul(candidate, lower, q), candidate_inverse, q)
            == lower_image
        ):
            witnesses.append(candidate)
            break
    if not witnesses:
        raise AssertionError("SL2 automorphism is not induced by GL2 conjugation")
    determinant = (
        witnesses[0][0][0] * witnesses[0][1][1]
        - witnesses[0][0][1] * witnesses[0][1][0]
    ) % q
    return (
        "inner_on_SL2"
        if pow(determinant, (q - 1) // 2, q) == 1
        else "diagonal_outer_on_SL2"
    )


def analyze(
    name: str,
    q: int,
    code: Matrix,
    kernel_kind: str,
    expected_party_order: int,
    provenance: dict[str, object],
) -> dict[str, object]:
    set_field(q)
    kernel, section = kernel_and_section(code, q, kernel_kind)
    party_group = tuple(sorted(section))
    if len(party_group) != expected_party_order:
        raise AssertionError(
            f"{name}: party order {len(party_group)} != {expected_party_order}"
        )
    if permutation_closure(two_generators(party_group)) != party_group:
        raise AssertionError("party generators do not close")
    kernel_index = {encode_element(element): i for i, element in enumerate(kernel)}
    identity_kernel_index = kernel_index[encode_element(identity_element())]
    factor_set: list[list[int]] = []
    factor_elements: list[list[GroupElement]] = []
    associativity_test_thirds = (tuple(range(N)),) + two_generators(party_group)
    for left in party_group:
        row = []
        element_row = []
        for right in party_group:
            product = compose(section[left], section[right], q)
            factor = compose(
                product,
                inverse_element(section[permutation_compose(left, right)], q),
                q,
            )
            if factor[0] != tuple(range(N)):
                raise AssertionError("factor set did not land in kernel")
            row.append(kernel_index[encode_element(factor)])
            element_row.append(factor)
        factor_set.append(row)
        factor_elements.append(element_row)
    identity_index = party_group.index(tuple(range(N)))
    if any(
        value != identity_kernel_index for value in factor_set[identity_index]
    ) or any(
        row[identity_index] != identity_kernel_index for row in factor_set
    ):
        raise AssertionError("factor set is not normalized")
    party_index = {permutation: i for i, permutation in enumerate(party_group)}
    for left in party_group:
        i = party_index[left]
        section_left = section[left]
        section_left_inverse = inverse_element(section_left, q)
        for right in party_group:
            j = party_index[right]
            left_right = permutation_compose(left, right)
            ij = party_index[left_right]
            for third in associativity_test_thirds:
                k = party_index[third]
                right_third = permutation_compose(right, third)
                jk = party_index[right_third]
                lhs = compose(
                    factor_elements[i][j], factor_elements[ij][k], q
                )
                acted = compose(
                    compose(section_left, factor_elements[j][k], q),
                    section_left_inverse,
                    q,
                )
                rhs = compose(acted, factor_elements[i][jk], q)
                if lhs != rhs:
                    raise AssertionError("nonabelian factor-set identity failed")
    splits, complement, search = find_complement(
        party_group, section, kernel, q
    )
    trivializing_cochain: list[int] | None = None
    if complement is not None:
        complement_group = group_closure(complement, q)
        if complement_group is None or len(complement_group) != len(party_group):
            raise AssertionError("bad complement")
        complement_section = {element[0]: element for element in complement_group}
        trivializing_cochain = []
        for permutation in party_group:
            correction = compose(
                complement_section[permutation],
                inverse_element(section[permutation], q),
                q,
            )
            trivializing_cochain.append(
                kernel_index[encode_element(correction)]
            )
        for left in party_group:
            for right in party_group:
                if compose(
                    complement_section[left], complement_section[right], q
                ) != complement_section[permutation_compose(left, right)]:
                    raise AssertionError("complement section is not homomorphic")
    generators = two_generators(party_group)
    generator_data = []
    action_classes: dict[Permutation, str] = {}
    action_permutations: dict[Permutation, list[int]] = {}
    for permutation in party_group:
        section_lift = section[permutation]
        section_lift_inverse = inverse_element(section_lift, q)
        conjugation = []
        for kernel_element in kernel:
            image = compose(
                compose(section_lift, kernel_element, q),
                section_lift_inverse,
                q,
            )
            conjugation.append(kernel_index[encode_element(image)])
        action_permutations[permutation] = conjugation
        action_classes[permutation] = outer_action_label(
            kernel_kind, q, kernel, conjugation
        )
    for permutation in generators:
        section_lift = section[permutation]
        conjugation = action_permutations[permutation]
        generator_data.append(
            {
                "permutation": list(permutation),
                "permutation_order": permutation_order(permutation),
                "section_lift": element_json(section_lift),
                "stabilizer_pauli_action_matrix": [
                    list(row) for row in action_on_stabilizer(code, section_lift, q)
                ],
                "kernel_conjugation_permutation": conjugation,
                "outer_action_class": action_classes[permutation],
            }
        )
    even_classes = {
        action_classes[permutation]
        for permutation in party_group
        if not permutation_is_odd(permutation)
    }
    odd_classes = {
        action_classes[permutation]
        for permutation in party_group
        if permutation_is_odd(permutation)
    }
    if complement is not None:
        complement_json = [element_json(element) for element in complement]
    else:
        complement_json = None
    return {
        "name": name,
        "field_order": q,
        "provenance": provenance,
        "code_generator": [list(row) for row in code],
        "gamma": {
            "structure": f"F_{q}^6 semidirect {kernel_kind}",
            "pauli_order": q**6,
            "linear_kernel_kind": kernel_kind,
            "linear_kernel_order": len(kernel),
            "order": q**6 * len(kernel),
        },
        "pi": {
            "isomorphism_type": identify_party_group(party_group),
            "order": len(party_group),
            "elements": [list(permutation) for permutation in party_group],
            "generators": [list(permutation) for permutation in generators],
        },
        "gamma_tilde": {
            "structure": f"F_{q}^6 semidirect H",
            "linear_group_order": len(kernel) * len(party_group),
            "order": q**6 * len(kernel) * len(party_group),
        },
        "normalized_section": [
            element_json(section[permutation]) for permutation in party_group
        ],
        "normalized_factor_set_kernel_indices": factor_set,
        "identity_kernel_index": identity_kernel_index,
        "normalized_factor_set_statistics": {
            "entry_count": len(party_group) ** 2,
            "identity_entry_count": sum(
                value == identity_kernel_index
                for row in factor_set
                for value in row
            ),
            "distinct_kernel_values": len(
                {value for row in factor_set for value in row}
            ),
        },
        "kernel_anchor_blocks": [
            matrix2_json(element[1][0]) for element in kernel
        ],
        "outer_action_generator_data": generator_data,
        "outer_action_summary": {
            "even_party_classes": sorted(even_classes),
            "odd_party_classes": sorted(odd_classes),
            "factors_through_party_sign": (
                len(even_classes) == 1 and len(odd_classes) <= 1
            ),
        },
        "splits": splits,
        "complement_generators": complement_json,
        "trivializing_cochain_kernel_indices": trivializing_cochain,
        "complement_search": search,
        "logical_linear_enlargement": (
            "T_to_N(T)" if kernel_kind == "torus" and len(party_group) > 1 else "none"
        ),
    }


def build_certificate() -> dict[str, object]:
    cases = [
        (
            "q11_pencil_t2_z1_h3_class",
            11,
            pencil_code(11, 2),
            "torus",
            120,
            {"family": "pencil", "parameter": 2, "z": 1, "also_h3_class": True},
        ),
        (
            "q11_pencil_t10_z9",
            11,
            pencil_code(11, 10),
            "torus",
            24,
            {"family": "pencil", "parameter": 10, "z": 9},
        ),
        (
            "q11_grs_0_1_2_3_4_5",
            11,
            grs_code(11, (0, 1, 2, 3, 4, 5)),
            "sl2",
            4,
            {"family": "GRS", "evaluation_set": [0, 1, 2, 3, 4, 5]},
        ),
        (
            "q11_grs_0_1_2_3_4_6",
            11,
            grs_code(11, (0, 1, 2, 3, 4, 6)),
            "sl2",
            5,
            {"family": "GRS", "evaluation_set": [0, 1, 2, 3, 4, 6]},
        ),
        (
            "q11_grs_0_1_2_3_5_6",
            11,
            grs_code(11, (0, 1, 2, 3, 5, 6)),
            "sl2",
            6,
            {"family": "GRS", "evaluation_set": [0, 1, 2, 3, 5, 6]},
        ),
        (
            "q11_grs_0_1_2_3_5_9",
            11,
            grs_code(11, (0, 1, 2, 3, 5, 9)),
            "sl2",
            12,
            {"family": "GRS", "evaluation_set": [0, 1, 2, 3, 5, 9]},
        ),
        (
            "q17_tetrahedral_tminus1_grs",
            17,
            pencil_code(17, 16),
            "sl2",
            24,
            {"family": "pencil", "parameter": -1, "z": 4, "enhancement": "S4/GRS"},
        ),
        (
            "q31_tetrahedral_tminus1_h3",
            31,
            pencil_code(31, 30),
            "torus",
            120,
            {"family": "pencil", "parameter": -1, "z": 1, "enhancement": "A5", "also_h3_class": True},
        ),
    ]
    for q in (11, 19, 29, 31):
        roots = [t for t in range(q) if (t * t - t - 1) % q == 0]
        if len(roots) != 2:
            raise AssertionError(f"F_{q} does not split the H3 polynomial")
        cases.append(
            (
                f"q{q}_integral_h3_tau{roots[0]}",
                q,
                pencil_code(q, roots[0]),
                "torus",
                120,
                {
                    "family": "integral_H3",
                    "tau": roots[0],
                    "tau_conjugate": roots[1],
                    "minimal_polynomial": "tau^2-tau-1",
                },
            )
        )
    analyses = [analyze(*case) for case in cases]
    actual_c397_hash = hashlib.sha256(C397_PATH.read_bytes()).hexdigest()
    if actual_c397_hash != C397_SHA256:
        raise AssertionError(f"stale C397 input: {actual_c397_hash}")
    c397 = json.loads(C397_PATH.read_text())
    q11_names = [
        "q11_pencil_t2_z1_h3_class",
        "q11_pencil_t10_z9",
        "q11_grs_0_1_2_3_4_5",
        "q11_grs_0_1_2_3_4_6",
        "q11_grs_0_1_2_3_5_6",
        "q11_grs_0_1_2_3_5_9",
    ]
    for analysis, old in zip(
        (next(item for item in analyses if item["name"] == name) for name in q11_names),
        c397["clifford_and_operator_pushing"],
        strict=True,
    ):
        if analysis["gamma"]["linear_kernel_order"] != old["fixed_party_symplectic_kernel_order"]:
            raise AssertionError("C397 fixed-kernel cross-check failed")
        if analysis["pi"]["order"] != old["party_permutation_image_order"]:
            raise AssertionError("C397 party-image cross-check failed")
        if analysis["gamma_tilde"]["linear_group_order"] != old["symplectic_automorphism_order"]:
            raise AssertionError("C397 symplectic-order cross-check failed")
    return {
        "schema": "c624-ame-lu-party-extension-examples-v1",
        "input": {
            C374_PATH.name: C374_SHA256,
            C397_PATH.name: C397_SHA256,
        },
        "conventions": {
            "party_permutations": "source_to_target",
            "group_product": "apply left factor, then right factor",
            "gamma": "projective fixed-party product-Clifford automorphism group modulo one-site scalar phases",
            "gamma_tilde": "same group with realized party permutations",
            "pauli_kernel": "the six-dimensional CSS stabilizer label space",
            "section": "identity-normalized; lexicographically least lift with anchor I before Fourier J",
            "factor_set": "s(pi)s(rho)s(pi*rho)^-1, indexed into kernel_elements",
        },
        "cases": analyses,
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (
        json.dumps(data, sort_keys=True, separators=(",", ":")) + "\n"
    ).encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    generated = canonical_bytes(certificate)
    if args.check:
        if not OUTPUT.exists():
            raise SystemExit(f"missing certificate: {OUTPUT}")
        if OUTPUT.read_bytes() != generated:
            with tempfile.NamedTemporaryFile(prefix="c624-", suffix=".json", delete=False) as handle:
                handle.write(generated)
                temporary = handle.name
            raise SystemExit(f"certificate mismatch; regenerated copy: {temporary}")
        print(f"PASS {len(certificate['cases'])} cases; {len(generated)} bytes")
    else:
        OUTPUT.write_bytes(generated)
        print(f"WROTE {OUTPUT} ({len(generated)} bytes)")


if __name__ == "__main__":
    main()
