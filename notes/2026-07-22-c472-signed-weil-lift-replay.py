#!/usr/bin/env python3
"""Independent 24-point permutation replay for C472."""

from __future__ import annotations

import hashlib
import itertools
import json
from collections import Counter, deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
N = 12
P = 3


def compose(left, right):
    return bytes(left[right[i]] for i in range(len(right)))


def inverse(permutation):
    answer = bytearray(len(permutation))
    for old, new in enumerate(permutation):
        answer[new] = old
    return bytes(answer)


def group_generated(generators):
    identity = bytes(range(len(generators[0])))
    group = {identity}
    queue = deque(group)
    while queue:
        current = queue.popleft()
        for generator in generators:
            target = compose(generator, current)
            if target not in group:
                group.add(target)
                queue.append(target)
    return group


def to_24(permutation, signs):
    images = []
    for negative in (0, 1):
        for old in range(N):
            flip = int(signs[old] == 2)
            images.append(permutation[old] + N * (negative ^ flip))
    return bytes(images)


def decode(element):
    permutation = bytes(element[i] % N for i in range(N))
    signs = tuple(2 if element[i] >= N else 1 for i in range(N))
    assert element == to_24(permutation, signs)
    return permutation, signs


def order(element):
    identity = bytes(range(len(element)))
    value = identity
    for result in range(1, 1000):
        value = compose(element, value)
        if value == identity:
            return result
    raise AssertionError("order bound")


def act_word(element, word):
    permutation, signs = decode(element)
    answer = [0] * N
    for old, value in enumerate(word):
        answer[permutation[old]] = signs[old] * value % P
    return tuple(answer)


def projectivize(word):
    first = next(value for value in word if value)
    inverse_value = pow(first, -1, P)
    return tuple(value * inverse_value % P for value in word)


def rref(rows):
    if not rows:
        return []
    a = [[x % P for x in row] for row in rows if any(x % P for x in row)]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next((i for i in range(rank, len(a)) if a[i][column]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        scale = pow(a[rank][column], -1, P)
        a[rank] = [scale * x % P for x in a[rank]]
        for i in range(len(a)):
            if i != rank and a[i][column]:
                scale = a[i][column]
                a[i] = [(x - scale * y) % P for x, y in zip(a[i], a[rank])]
        rank += 1
    return a[:rank]


def coordinates(vector, basis):
    pivots = [next(i for i, value in enumerate(row) if value) for row in basis]
    coefficients = [vector[i] % P for i in pivots]
    assert [sum(coefficients[k] * basis[k][j] for k in range(len(basis))) % P
            for j in range(len(vector))] == list(vector)
    return coefficients


def restricted(element, basis):
    return [coordinates(act_word(element, tuple(row)), basis) for row in basis]


def row_action(vector, matrix):
    return tuple(sum(vector[i] * matrix[i][j] for i in range(len(vector))) % P
                 for j in range(len(vector)))


def cyclic_span(vector, matrices):
    basis = rref([vector])
    while True:
        enlarged = rref([*basis, *(row_action(row, matrix)
                                    for row in basis for matrix in matrices)])
        if enlarged == basis:
            return basis
        basis = enlarged


def normal_closure(seed, generators):
    seeds = [seed]
    while True:
        subgroup = group_generated(seeds)
        additions = []
        for element in seeds:
            for generator in generators:
                conjugate = compose(inverse(generator), compose(element, generator))
                if conjugate not in subgroup:
                    additions.append(conjugate)
        if not additions:
            return subgroup
        seeds.extend(additions)


def main():
    certificate = json.loads((NOTES / "2026-07-22-c472-signed-weil-lift.json").read_text())
    c470 = json.loads((NOTES / "2026-07-22-c470-golay-hadamard-automorphisms.json").read_text())
    c471 = json.loads((NOTES / "2026-07-22-c471-hadamard-degeneration-complex.json").read_text())
    c465 = json.loads((NOTES / "2026-07-21-c465-mod3-weil-golay.json").read_text())
    for name, record in certificate["inputs"].items():
        data = (ROOT / name).read_bytes()
        assert len(data) == record["bytes"]
        assert hashlib.sha256(data).hexdigest() == record["sha256"]

    ambient_generators = [to_24(record["coordinate_permutation"], record["chosen_signs"])
                          for record in c470["monomial_group"][
                              "standard_M12_generator_lifts"]]
    ambient = group_generated(ambient_generators)
    assert len(ambient) == 190080

    frozen_generators = [bytes(permutation) for permutation in c470[
        "two_M11_parents_and_frozen_intersection"]["frozen_generators"]]
    frozen = group_generated(frozen_generators)
    assert len(frozen) == 660
    preimage = {element for element in ambient if decode(element)[0] in frozen}
    assert len(preimage) == 1320
    identity24 = bytes(range(24))
    global_minus = bytes(list(range(12, 24)) + list(range(12)))
    kernel = {element for element in preimage if decode(element)[0] == bytes(range(12))}
    assert kernel == {identity24, global_minus}

    pure = {to_24(permutation, [1] * N) for permutation in frozen}
    assert pure < preimage and len(pure) == 660
    assert {compose(z, g) for z in kernel for g in pure} == preimage
    assert all(compose(to_24(g, [1] * N), to_24(h, [1] * N)) ==
               to_24(compose(g, h), [1] * N) for g in frozen for h in frozen)

    t = to_24(frozen_generators[0], [1] * N)
    s = to_24(frozen_generators[1], [1] * N)
    lift_table = []
    for central_on_t in (0, 1):
        for central_on_s in (0, 1):
            lifted_t = compose(global_minus, t) if central_on_t else t
            lifted_s = compose(global_minus, s) if central_on_s else s
            generated = group_generated([lifted_t, lifted_s])
            lift_table.append({
                "central_on_T": central_on_t,
                "central_on_S": central_on_s,
                "generated_order": len(generated),
                "order_T": order(lifted_t),
                "order_S": order(lifted_s),
                "order_S_times_T": order(compose(lifted_s, lifted_t)),
                "is_complement": len(generated) == 660 and global_minus not in generated,
            })
    assert lift_table == certificate["alternate_attack_stress_test"][
        "generator_lift_exhaustion"]
    assert sum(record["is_complement"] for record in lift_table) == 1
    commutator = compose(inverse(s), compose(inverse(t), compose(s, t)))
    derived = normal_closure(commutator, [s, t, global_minus])
    assert derived == pure
    center = {element for element in preimage if all(
        compose(element, generator) == compose(generator, element)
        for generator in (s, t, global_minus))}
    assert center == kernel
    census = Counter(order(element) for element in preimage)
    assert dict(sorted(census.items())) == {
        1: 1, 2: 111, 3: 110, 5: 264, 6: 330, 10: 264, 11: 120, 22: 120,
    }
    assert certificate["full_preimage"]["element_order_census"] == {
        str(key): value for key, value in sorted(census.items())}

    points = [tuple(word) for word in c470["hadamard_row_action"][
        "projective_weight_12_points"]]
    point_index = {point: i for i, point in enumerate(points)}
    signed_pair_stabilizer = set()
    for element in preimage:
        permutation, signs = decode(element)
        transformed = act_word(element, points[0])
        row = point_index[projectivize(transformed)]
        scalar = next(value for value in transformed if value)
        if permutation[11] == 11 and signs[11] == 1 and row == 0 and scalar == 1:
            signed_pair_stabilizer.add(element)
    assert signed_pair_stabilizer == pure

    coordinate_parent = set()
    row_parent = set()
    for element in ambient:
        permutation, signs = decode(element)
        transformed = act_word(element, points[0])
        row = point_index[projectivize(transformed)]
        scalar = next(value for value in transformed if value)
        if permutation[11] == 11 and signs[11] == 1:
            coordinate_parent.add(element)
        if row == 0 and scalar == 1:
            row_parent.add(element)
    assert len(coordinate_parent) == len(row_parent) == 7920
    assert coordinate_parent & row_parent == pure
    gluing = certificate["two_parent_signed_gluing"]
    assert gluing["intersection_order"] == 660
    recorded_generators = []
    for parent_name, parent in (("coordinate_oriented_parent", coordinate_parent),
                                ("row_oriented_parent", row_parent)):
        generators = []
        for record in gluing[parent_name]["generators"]:
            signs = [2 if (record["sign_mask"] >> i) & 1 else 1 for i in range(N)]
            generators.append(to_24(record["permutation"], signs))
        assert group_generated(generators) == parent
        recorded_generators.extend(generators)
    assert group_generated(recorded_generators) == ambient
    value = identity24
    for index in gluing["central_witness_word_generator_indices"]:
        value = compose(recorded_generators[index], value)
    assert value == global_minus

    hadamard = c471["integral_matrix_factorization"]["hadamard_matrix_H"]
    raw_rows = [tuple(value % P for value in row) for row in hadamard]
    raw_index = {projectivize(row): i for i, row in enumerate(raw_rows)}
    positive, negative = set(), set()
    for element in ambient:
        permutation, signs = decode(element)
        coordinate, coordinate_sign = permutation[11], (1 if signs[11] == 1 else -1)
        transformed = act_word(element, raw_rows[0])
        row = raw_index[projectivize(transformed)]
        row_sign = 1 if transformed == raw_rows[row] else -1
        assert transformed == tuple((row_sign * value) % P for value in raw_rows[row])
        positive.add((coordinate, coordinate_sign, row, row_sign))
        negative.add((coordinate, coordinate_sign, row, -row_sign))
    assert len(positive) == len(negative) == 288 and positive.isdisjoint(negative)
    assert {a * b * hadamard[row][coordinate]
            for coordinate, a, row, b in positive} == {1}
    assert {a * b * hadamard[row][coordinate]
            for coordinate, a, row, b in negative} == {-1}
    assert certificate["signed_pair_geometry"]["orbit_partition"] == [
        {"size": 288, "integral_inner_product": 1, "stabilizer_order": 660},
        {"size": 288, "integral_inner_product": -1, "stabilizer_order": 660},
    ]

    carrier = c471["c469_carrier_identification"]["extended_code_basis_rref"]
    matrices = {
        "T": restricted(t, carrier),
        "S": restricted(s, carrier),
        "central_z": restricted(global_minus, carrier),
    }
    assert matrices == certificate["six_dimensional_action"]["literal_generator_matrices"]
    assert matrices["central_z"] == [[2 * int(i == j) for j in range(6)]
                                      for i in range(6)]
    shortened = c471["puncture_shorten_bridge"]["shortened_basis_rref"]
    five_space = rref([row + [0] for row in shortened])
    assert all(rref([act_word(generator, tuple(row)) for row in five_space]) == five_space
               for generator in (t, s))
    assert all(act_word(generator, tuple([1] * 12)) == tuple([1] * 12)
               for generator in (t, s))
    ambient_matrices = [restricted(generator, carrier) for generator in ambient_generators]
    assert ambient_matrices == certificate["six_dimensional_action"][
        "full_signed_Mathieu_generator_matrices"]
    cyclic_dimensions = sorted({
        len(cyclic_span(vector, ambient_matrices))
        for vector in itertools.product(range(P), repeat=6) if any(vector)
    })
    assert cyclic_dimensions == certificate["six_dimensional_action"][
        "full_signed_Mathieu_cyclic_submodule_dimensions"] == [6]
    assert certificate["six_dimensional_action"][
        "full_signed_Mathieu_action_irreducible"] is True

    case = next(item for item in c465["cases"] if item["q"] == 11)
    genuine = [row for row in case["brauer"]["sl_brauer_irreducibles"]
               if row["index"] in (7, 8)]
    assert all(row["values"][1] == "-6" and row["values"][2] == "0"
               for row in genuine)
    assert case["brauer"]["modules"]["perfect_code"]["brauer_values"][1] == "2"
    assert certificate["genuine_Weil_comparison"]["comparison_verdict"] == \
        "neither genuine Gerardin reduction matches"
    twists = certificate["all_scalar_twists_audit"]
    assert twists["abelianization_order"] == 2
    assert twists["linear_character_count_over_F3"] == 2
    assert twists["all_same_preimage_linearizations_exhausted"] is True
    alternatives = {item["candidate"]: item["rescues_genuine_six_space"]
                    for item in certificate["alternative_inputs_audit"]}
    assert alternatives["different central lifts of frozen T and S"] is False
    assert alternatives["different linear character twist of the same split preimage"] is False
    assert alternatives["abstract nonsplit Schur cover SL_2(11) with a genuine degree-six module"] is True
    assert certificate["downstream_impact"]["logical_damage"].startswith(
        "localized to the optional upper-Weil branch")
    assert certificate["unqualified_green_reframing"]["negative_retained"].startswith(
        "the proposed same-carrier genuine signed-Weil realization does not exist")
    assert certificate["missing_ingredient"]["group_level"].startswith(
        "the nonzero Schur-multiplier class")
    assert certificate["projective_obstruction"]["projective_conjugacy_possible"] is False
    assert certificate["projective_obstruction"][
        "genuine_action_has_proper_invariant_projective_subspace"] is False
    assert certificate["tao_global_gluing_reframing"]["computed_answer"].startswith(
        "the full signed Mathieu action on the same six-space is irreducible")
    routes = {item["route"]: item["status"]
              for item in certificate["rough_objective_alt_attacks"]}
    assert routes["Bockstein quadratic refinement"] == "strongest intrinsic candidate"
    assert routes["lower-Weil replacement objective"] == "already achieved"

    print("C472 independent replay: PASS")
    print("preimage/direct factor/derived = 1320/(2x660)/660; signed Weil door closed")


if __name__ == "__main__":
    main()
