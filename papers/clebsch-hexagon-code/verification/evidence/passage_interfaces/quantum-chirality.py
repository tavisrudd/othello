#!/usr/bin/env python3
"""Exact chirality comparison certificate for the chirality-conjugate AME(6,11) pair."""

from __future__ import annotations

import argparse
import collections
import hashlib
import itertools
import json
from pathlib import Path
from typing import Iterable, Sequence

Q = 11
N = 6
ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "quantum-chirality.json"
INPUTS = {
    "quantum-state-equivalence.json":
        "f82387f28f93a208365e770d0c4c6f16836c552291e88a6c8e7e441b1c4aec57",
    "quantum-family-classification.json":
        "e1848efe1af3fcc8ac11c66ba6387dadf8b4ca678c5278fdc8f4e13ac3f13069",
    "quantum-pencil-arithmetic.json":
        "529eb9467ac78baaf04f2ecafa124b6eaa72c05766446e0ceaceb8ed761eb132",
}

Vector = tuple[int, ...]
Matrix = tuple[Vector, ...]


def inv(value: int) -> int:
    return pow(value % Q, Q - 2, Q)


def rref(rows: Iterable[Sequence[int]]) -> tuple[Matrix, tuple[int, ...]]:
    matrix = [list(value % Q for value in row) for row in rows]
    if not matrix:
        return (), ()
    pivots: list[int] = []
    row = 0
    for column in range(len(matrix[0])):
        pivot = next((index for index in range(row, len(matrix)) if matrix[index][column]), None)
        if pivot is None:
            continue
        matrix[row], matrix[pivot] = matrix[pivot], matrix[row]
        scale = inv(matrix[row][column])
        matrix[row] = [(scale * value) % Q for value in matrix[row]]
        for index in range(len(matrix)):
            if index != row and matrix[index][column]:
                factor = matrix[index][column]
                matrix[index] = [
                    (left - factor * right) % Q
                    for left, right in zip(matrix[index], matrix[row])
                ]
        pivots.append(column)
        row += 1
        if row == len(matrix):
            break
    return tuple(tuple(entry for entry in line) for line in matrix if any(line)), tuple(pivots)


def rowspace(rows: Iterable[Sequence[int]]) -> Matrix:
    return rref(rows)[0]


def nullspace(rows: Matrix, width: int | None = None) -> Matrix:
    if rows:
        width = len(rows[0])
    if width is None:
        raise ValueError("nullspace width is required for an empty matrix")
    reduced, pivots = rref(rows)
    free = [column for column in range(width) if column not in pivots]
    basis = []
    for column in free:
        vector = [0] * width
        vector[column] = 1
        for pivot_row, pivot_column in enumerate(pivots):
            vector[pivot_column] = (-reduced[pivot_row][column]) % Q
        basis.append(tuple(vector))
    return tuple(basis)


def matmul(left: Matrix, right: Matrix) -> Matrix:
    return tuple(
        tuple(sum(left[i][k] * right[k][j] for k in range(len(right))) % Q
              for j in range(len(right[0])))
        for i in range(len(left))
    )


def inverse3(matrix: Matrix) -> Matrix:
    augmented = tuple(
        tuple(matrix[i]) + tuple(int(i == j) for j in range(3))
        for i in range(3)
    )
    reduced, pivots = rref(augmented)
    if pivots[:3] != (0, 1, 2):
        raise AssertionError("singular 3x3 matrix")
    return tuple(row[3:] for row in reduced)


def matvec(matrix: Matrix, vector: Vector) -> Vector:
    return tuple(sum(matrix[i][j] * vector[j] for j in range(3)) % Q for i in range(3))


def canonical_projective(vector: Vector) -> Vector:
    scale = inv(next(value for value in vector if value))
    return tuple(scale * value % Q for value in vector)


def frame_transform(points: Matrix, frame: tuple[int, int, int, int]) -> Matrix:
    a, b, c, d = (points[index] for index in frame)
    basis = tuple(tuple((a, b, c)[column][row] for column in range(3)) for row in range(3))
    basis_inverse = inverse3(basis)
    coordinates = matvec(basis_inverse, d)
    if not all(coordinates):
        raise AssertionError("four arc points did not form a projective frame")
    scaled_basis = tuple(
        tuple((a, b, c)[column][row] * coordinates[column] % Q for column in range(3))
        for row in range(3)
    )
    return inverse3(scaled_basis)


def projectivity_for_party_map(source: Matrix, target: Matrix, party_map: tuple[int, ...]) -> Matrix | None:
    source_frame = frame_transform(source, (0, 1, 2, 3))
    target_frame = frame_transform(target, tuple(party_map[index] for index in range(4)))
    projectivity = matmul(inverse3(target_frame), source_frame)
    if all(
        canonical_projective(matvec(projectivity, source[index]))
        == canonical_projective(target[party_map[index]])
        for index in range(N)
    ):
        return projectivity
    return None


def projective_party_maps(source: Matrix, target: Matrix) -> tuple[tuple[int, ...], ...]:
    return tuple(
        permutation
        for permutation in itertools.permutations(range(N))
        if projectivity_for_party_map(source, target, permutation) is not None
    )


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[index]] for index in range(N))


def permutation_order(permutation: tuple[int, ...]) -> int:
    power = tuple(range(N))
    for order in range(1, 61):
        power = compose(permutation, power)
        if power == tuple(range(N)):
            return order
    raise AssertionError("unexpected permutation order")


def pencil_points(t: int) -> Matrix:
    return tuple(
        tuple(value % Q for value in point)
        for point in (
            (0, 1, 1 - t), (0, 1, t - 1),
            (1, 1 - t, 0), (1, t - 1, 0),
            (1, 0, -t), (1, 0, t),
        )
    )


def parity_check(t: int) -> Matrix:
    points = pencil_points(t)
    return tuple(tuple(points[column][row] for column in range(N)) for row in range(3))


def kernel_generator(t: int) -> Matrix:
    return rowspace(nullspace(parity_check(t)))


def codewords(generator: Matrix) -> set[Vector]:
    return {
        tuple(sum(coefficients[i] * generator[i][j] for i in range(3)) % Q for j in range(N))
        for coefficients in itertools.product(range(Q), repeat=3)
    }


def stabilizer(generator: Matrix) -> Matrix:
    zero = (0,) * N
    dual = nullspace(generator)
    return rowspace(tuple(row) + zero for row in generator) + rowspace(zero + tuple(row) for row in dual)


def shortenings(generator: Matrix) -> dict[tuple[int, int], Matrix]:
    lagrangian = stabilizer(generator)
    result = {}
    for omitted in itertools.combinations(range(N), 2):
        equations = tuple(
            tuple(lagrangian[row][coordinate] for row in range(N))
            for party in omitted
            for coordinate in (party, N + party)
        )
        coefficients = nullspace(equations)
        if len(coefficients) != 2:
            raise AssertionError("unexpected shortening dimension")
        result[omitted] = coefficients
    return result


def ambient_shortenings(generator: Matrix) -> dict[tuple[int, int], Matrix]:
    lagrangian = stabilizer(generator)
    result = {}
    for omitted in itertools.combinations(range(N), 2):
        equations = tuple(
            tuple(lagrangian[row][coordinate] for row in range(N))
            for party in omitted
            for coordinate in (party, N + party)
        )
        result[omitted] = tuple(
            tuple(sum(coefficients[i] * lagrangian[i][j] for i in range(N)) % Q for j in range(2 * N))
            for coefficients in nullspace(equations)
        )
    return result


def indexed_moment_ranks(spaces: dict[tuple[int, int], Matrix]) -> dict[tuple[tuple[int, int], ...], int]:
    return {
        triple: len(rowspace(row for omitted in triple for row in spaces[omitted]))
        for triple in itertools.combinations(sorted(spaces), 3)
    }


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_witnesses() -> tuple[dict[str, object], dict[str, object]]:
    for relative, expected in INPUTS.items():
        if digest(ROOT / relative) != expected:
            raise AssertionError(f"input hash mismatch: {relative}")
    source = json.loads((ROOT / "quantum-family-classification.json").read_text())
    family = next(item for item in source["classes"] if 8 in item["parameters"])
    return family["parameter_witnesses"]["8"], family["parameter_witnesses"]["4"]


def build_certificate() -> dict[str, object]:
    witness8, witness4 = load_witnesses()
    p8 = tuple(witness8["source_to_canonical_party"])
    p4 = tuple(witness4["source_to_canonical_party"])
    s8 = tuple(witness8["transformed_column_scalars"])
    s4 = tuple(witness4["transformed_column_scalars"])
    inverse_p4 = {canonical: party for party, canonical in enumerate(p4)}
    party_map = tuple(inverse_p4[p8[party]] for party in range(N))
    scalars = tuple(s8[party] * inv(s4[party_map[party]]) % Q for party in range(N))

    a8 = tuple(tuple(row) for row in witness8["row_transform"])
    a4 = tuple(tuple(row) for row in witness4["row_transform"])
    projectivity = matmul(inverse3(a4), a8)
    h8 = parity_check(8)
    h4 = parity_check(4)
    for source in range(N):
        left = tuple(sum(projectivity[i][k] * h8[k][source] for k in range(3)) % Q for i in range(3))
        target = party_map[source]
        right = tuple(scalars[source] * h4[i][target] % Q for i in range(3))
        if left != right:
            raise AssertionError("direct parity-check intertwiner failed")

    g8 = kernel_generator(8)
    g4 = kernel_generator(4)
    words8 = codewords(g8)
    words4 = codewords(g4)
    transported = {
        tuple(next(scalars[source] * word[source] % Q
                   for source in range(N) if party_map[source] == target)
              for target in range(N))
        for word in words8
    }
    if len(words8) != Q ** 3 or transported != words4:
        raise AssertionError("exhaustive codeword transport failed")

    ranks8 = indexed_moment_ranks(shortenings(g8))
    ranks4 = indexed_moment_ranks(shortenings(g4))
    ambient8 = indexed_moment_ranks(ambient_shortenings(g8))
    ambient4 = indexed_moment_ranks(ambient_shortenings(g4))
    if ranks8 != ambient8 or ranks4 != ambient4:
        raise AssertionError("independent ambient moment replay disagrees")
    direct_mismatches = [triple for triple in ranks8 if ranks8[triple] != ranks4[triple]]
    transport_mismatches = []
    for triple, rank in ranks8.items():
        mapped = tuple(sorted(tuple(sorted(party_map[index] for index in omitted)) for omitted in triple))
        if ranks4[mapped] != rank:
            transport_mismatches.append(triple)
    if direct_mismatches or transport_mismatches:
        raise AssertionError("degree-six moment should be blind both directly and after transport")

    equivalences = projective_party_maps(pencil_points(8), pencil_points(4))
    source_automorphisms = projective_party_maps(pencil_points(8), pencil_points(8))
    target_automorphisms = projective_party_maps(pencil_points(4), pencil_points(4))
    if party_map not in equivalences or tuple(range(N)) in equivalences:
        raise AssertionError("fixed-label projective boundary failed")
    target_orbit = {compose(automorphism, party_map) for automorphism in target_automorphisms}
    source_orbit = {compose(party_map, automorphism) for automorphism in source_automorphisms}
    if target_orbit != set(equivalences) or source_orbit != set(equivalences):
        raise AssertionError("equivalence set is not the expected bitorsor")
    source_profile = collections.Counter(permutation_order(item) for item in source_automorphisms)
    target_profile = collections.Counter(permutation_order(item) for item in target_automorphisms)
    expected_profile = {1: 1, 2: 15, 3: 20, 5: 24}
    if source_profile != expected_profile or target_profile != expected_profile:
        raise AssertionError("automorphism group does not have the A5 order profile")

    return {
        "schema": "chirality-ame-chirality-v1",
        "field_order": Q,
        "input_sha256": INPUTS,
        "states": {
            "source_chirality": {"parameter": 8, "parity_check": h8, "kernel_generator": g8},
            "conjugate_chirality": {"parameter": 4, "parity_check": h4, "kernel_generator": g4},
            "convention": "|Psi_t> = 11^(-3/2) sum_{c in ker(H_t)} |c>",
        },
        "equivalence": {
            "source_to_target_party": party_map,
            "source_coordinate_scalars": scalars,
            "party_cycle_notation": "(2 4 3 5)",
            "local_basis_map": "S_lambda|x> = |lambda*x mod 11>",
            "projective_row_intertwiner": projectivity,
            "checked_codewords": len(words8),
            "transported_support_equals_target": True,
            "projective_party_map_count": len(equivalences),
            "projective_party_maps": equivalences,
        },
        "equivalence_bitorsor": {
            "source_automorphism_count": len(source_automorphisms),
            "target_automorphism_count": len(target_automorphisms),
            "source_element_order_profile": dict(sorted(source_profile.items())),
            "target_element_order_profile": dict(sorted(target_profile.items())),
            "left_target_action_is_free_transitive": True,
            "right_source_action_is_free_transitive": True,
            "group_type": "A5",
            "canonical_equivalence": False,
        },
        "degree_six_lu_invariant_check": {
            "definition": "mu(E1,E2,E3)=Tr(A_E1 A_E2 A_E3), E is the omitted party pair",
            "amplitude_bidegree": [3, 3],
            "total_degree": 6,
            "value_rule": "mu=11^(-rank)",
            "direct_label_mismatch_count": len(direct_mismatches),
            "party_transport_mismatch_count": len(transport_mismatches),
            "independent_ambient_replay": True,
        },
        "labeled_boundary": {
            "identity_party_map_is_projective_monomial_equivalence": False,
            "surviving_datum": "the ordered projective six-arc chirality, not an unlabeled quantum LU invariant",
            "fixed_label_arbitrary_lu_equivalence": "not decided by this certificate",
        },
        "verdict": {
            "lu_equivalent_with_party_permutation": True,
            "equivalence_is_local_clifford": True,
            "unlabeled_separating_lu_invariant_exists": False,
            "recommended_framing": "labeled/advice",
        },
    }


def encoded(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = encoded(build_certificate())
    if args.write:
        OUTPUT.write_bytes(payload)
    elif OUTPUT.read_bytes() != payload:
        raise SystemExit("tracked certificate differs from exact regeneration")
    print("chirality comparison certificate OK")


if __name__ == "__main__":
    main()
