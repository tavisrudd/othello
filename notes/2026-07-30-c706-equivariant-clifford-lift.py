#!/usr/bin/env python3
"""Exact C706 certificate for the equivariant Clebsch--Clifford lift."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-30-c706-equivariant-clifford-lift.json"
IDENTITY_PERMUTATION = tuple(range(6))
IDENTITY_VECTOR_MAP = tuple(range(16))
ZERO_SIGN = (0,) * 16
C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
UNITARY_A_NUMERATOR = (
    ((0, -1), (-1, 0), (-1, 0), (0, 1)),
    ((0, -1), (-1, 0), (1, 0), (0, -1)),
    ((-1, 0), (0, -1), (0, -1), (1, 0)),
    ((1, 0), (0, 1), (0, -1), (1, 0)),
)
UNITARY_B_NUMERATOR = (
    ((1, 0), (0, -1), (0, -1), (-1, 0)),
    ((0, 1), (-1, 0), (1, 0), (0, 1)),
    ((0, 1), (1, 0), (-1, 0), (0, 1)),
    ((-1, 0), (0, -1), (0, -1), (1, 0)),
)


def dot2(left, right):
    return (left & right).bit_count() % 2


ODD_CHARACTERISTICS = tuple(
    (a, b)
    for a in range(4)
    for b in range(4)
    if dot2(a, b)
)


def duad_vector(left, right):
    a_left, b_left = ODD_CHARACTERISTICS[left]
    a_right, b_right = ODD_CHARACTERISTICS[right]
    x = b_left ^ b_right
    z = a_left ^ a_right
    return x | (z << 2)


DUADS = tuple(itertools.combinations(range(6), 2))
VECTOR_TO_DUAD = {duad_vector(*duad): duad for duad in DUADS}


def symplectic(left, right):
    x, z = left & 3, left >> 2
    y, t = right & 3, right >> 2
    return dot2(x, t) ^ dot2(z, y)


def pauli_exponent(left, right):
    """P(left)P(right)=i^c P(left+right), with Hermitian P."""
    x, z = left & 3, left >> 2
    y, t = right & 3, right >> 2
    return (
        (x & z).bit_count()
        + (y & t).bit_count()
        + 2 * (z & y).bit_count()
        - ((x ^ y) & (z ^ t)).bit_count()
    ) % 4


def compose_permutations(left, right):
    return tuple(left[right[index]] for index in range(6))


def permutation_parity(permutation):
    return sum(
        permutation[i] > permutation[j]
        for i in range(6)
        for j in range(i + 1, 6)
    ) % 2


def permutation_order(permutation):
    power = IDENTITY_PERMUTATION
    for order in range(1, 61):
        power = compose_permutations(permutation, power)
        if power == IDENTITY_PERMUTATION:
            return order
    raise AssertionError


def induced_vector_map(permutation):
    result = {0: 0}
    for left, right in DUADS:
        target = tuple(sorted((permutation[left], permutation[right])))
        result[duad_vector(left, right)] = duad_vector(*target)
    vector_map = tuple(result[vector] for vector in range(16))
    assert all(
        vector_map[left ^ right] == vector_map[left] ^ vector_map[right]
        for left in range(16)
        for right in range(16)
    )
    assert all(
        symplectic(left, right)
        == symplectic(vector_map[left], vector_map[right])
        for left in range(16)
        for right in range(16)
    )
    return vector_map


def compose_vector_maps(left, right):
    return tuple(left[right[vector]] for vector in range(16))


def sign_polarization(vector_map, left, right):
    difference = (
        pauli_exponent(vector_map[left], vector_map[right])
        - pauli_exponent(left, right)
    ) % 4
    assert difference % 2 == 0
    return difference // 2


def canonical_sign(vector_map):
    """One q with U P(v) U^-1=(-1)^q(v)P(gv), fixing q(e_i)=0."""
    result = [0] * 16
    for vector in range(16):
        partial = 0
        value = 0
        for bit in range(4):
            if (vector >> bit) & 1:
                value ^= sign_polarization(vector_map, partial, 1 << bit)
                partial ^= 1 << bit
        result[vector] = value
    assert all(
        result[left ^ right] ^ result[left] ^ result[right]
        == sign_polarization(vector_map, left, right)
        for left in range(16)
        for right in range(16)
    )
    return tuple(result)


def linear_sign(bits):
    return tuple(
        sum(((bits >> bit) & 1) * ((vector >> bit) & 1) for bit in range(4))
        % 2
        for vector in range(16)
    )


def xor_signs(*signs):
    return tuple(
        sum(sign[vector] for sign in signs) % 2 for vector in range(16)
    )


def compose_lifts(left, right):
    """Composition left after right."""
    left_map, left_sign = left
    right_map, right_sign = right
    return (
        compose_vector_maps(left_map, right_map),
        tuple(
            right_sign[vector] ^ left_sign[right_map[vector]]
            for vector in range(16)
        ),
    )


def lift_from_assignment(generator_maps, generator_signs, index, assignment):
    correction = (assignment >> (4 * index)) & 15
    return (
        generator_maps[index],
        xor_signs(generator_signs[index], linear_sign(correction)),
    )


def evaluate_word(generator_maps, generator_signs, word, assignment):
    result = (IDENTITY_VECTOR_MAP, ZERO_SIGN)
    for index in reversed(word):
        result = compose_lifts(
            lift_from_assignment(
                generator_maps, generator_signs, index, assignment
            ),
            result,
        )
    return result


def relation_system(generator_maps, relations):
    generator_signs = tuple(canonical_sign(vector_map) for vector_map in generator_maps)
    width = 4 * len(generator_maps)
    rows = []
    rhs = []
    for word in relations:
        base_map, base_sign = evaluate_word(
            generator_maps, generator_signs, word, 0
        )
        assert base_map == IDENTITY_VECTOR_MAP
        effects = [
            evaluate_word(generator_maps, generator_signs, word, 1 << bit)[1]
            for bit in range(width)
        ]
        for vector in range(16):
            row = sum(
                (effects[bit][vector] ^ base_sign[vector]) << bit
                for bit in range(width)
            )
            rows.append(row)
            rhs.append(base_sign[vector])
    return generator_signs, rows, rhs, width


def gf2_rank(rows, width):
    work = list(rows)
    rank = 0
    for column in range(width):
        pivot = next(
            (
                row
                for row in range(rank, len(work))
                if (work[row] >> column) & 1
            ),
            None,
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        for row in range(len(work)):
            if row != rank and ((work[row] >> column) & 1):
                work[row] ^= work[rank]
        rank += 1
    return rank


def system_ranks(rows, rhs, width):
    coefficient_rank = gf2_rank(rows, width)
    augmented = [
        row | (value << width) for row, value in zip(rows, rhs)
    ]
    return coefficient_rank, gf2_rank(augmented, width + 1)


def valid_assignments(generator_maps, generator_signs, relations):
    width = 4 * len(generator_maps)
    result = []
    for assignment in range(1 << width):
        if all(
            evaluate_word(generator_maps, generator_signs, word, assignment)
            == (IDENTITY_VECTOR_MAP, ZERO_SIGN)
            for word in relations
        ):
            result.append(assignment)
    return tuple(result)


def generated_lift_group(generator_maps, generator_signs, assignment):
    generators = tuple(
        lift_from_assignment(
            generator_maps, generator_signs, index, assignment
        )
        for index in range(len(generator_maps))
    )
    identity = (IDENTITY_VECTOR_MAP, ZERO_SIGN)
    seen = {identity}
    frontier = [identity]
    while frontier:
        element = frontier.pop()
        for generator in generators:
            target = compose_lifts(generator, element)
            if target not in seen:
                seen.add(target)
                frontier.append(target)
    return frozenset(seen)


def generated_permutation_group(generators):
    seen = {IDENTITY_PERMUTATION}
    frontier = [IDENTITY_PERMUTATION]
    while frontier:
        element = frontier.pop()
        for generator in generators:
            target = compose_permutations(generator, element)
            if target not in seen:
                seen.add(target)
                frontier.append(target)
    return frozenset(seen)


def assignment_from_generator_lifts(generator_signs, lifts):
    assignment = 0
    for index, (_, sign) in enumerate(lifts):
        difference = xor_signs(sign, generator_signs[index])
        assert difference == linear_sign(
            sum(difference[1 << bit] << bit for bit in range(4))
        )
        for bit in range(4):
            assignment |= difference[1 << bit] << (4 * index + bit)
    return assignment


def pauli_conjugate_assignment(
    generator_maps, generator_signs, assignment, pauli_vector
):
    kernel = (
        IDENTITY_VECTOR_MAP,
        tuple(symplectic(pauli_vector, vector) for vector in range(16)),
    )
    lifts = []
    for index in range(len(generator_maps)):
        source = lift_from_assignment(
            generator_maps, generator_signs, index, assignment
        )
        lifts.append(compose_lifts(kernel, compose_lifts(source, kernel)))
    return assignment_from_generator_lifts(generator_signs, lifts)


def is_linear(sign):
    return sign[0] == 0 and all(
        sign[left ^ right] == sign[left] ^ sign[right]
        for left in range(16)
        for right in range(16)
    )


def conference_bit(vector):
    if vector == 0:
        return 0
    left, right = VECTOR_TO_DUAD[vector]
    return int(C[left][right] < 0)


def conference_stabilizer():
    result = []
    for permutation in itertools.permutations(range(6)):
        if permutation_parity(permutation):
            continue
        switching = [1] + [
            C[0][index] * C[permutation[0]][permutation[index]]
            for index in range(1, 6)
        ]
        if all(
            C[permutation[left]][permutation[right]]
            == switching[left] * switching[right] * C[left][right]
            for left, right in DUADS
        ):
            result.append((permutation, tuple(switching)))
    assert len(result) == 60
    return tuple(result)


def conference_switching_group():
    result = []
    for permutation in itertools.permutations(range(6)):
        epsilon = -1 if permutation_parity(permutation) else 1
        switching = [1] + [
            epsilon * C[0][index] * C[permutation[0]][permutation[index]]
            for index in range(1, 6)
        ]
        if all(
            C[permutation[left]][permutation[right]]
            == epsilon * switching[left] * switching[right] * C[left][right]
            for left, right in DUADS
        ):
            result.append(permutation)
    assert len(result) == 120
    return frozenset(result)


def gaussian_add(left, right):
    return left[0] + right[0], left[1] + right[1]


def gaussian_multiply(left, right):
    return (
        left[0] * right[0] - left[1] * right[1],
        left[0] * right[1] + left[1] * right[0],
    )


def gaussian_matrix_multiply(left, right):
    return tuple(
        tuple(
            gaussian_add(
                gaussian_add(
                    gaussian_multiply(left[row][0], right[0][column]),
                    gaussian_multiply(left[row][1], right[1][column]),
                ),
                gaussian_add(
                    gaussian_multiply(left[row][2], right[2][column]),
                    gaussian_multiply(left[row][3], right[3][column]),
                ),
            )
            for column in range(4)
        )
        for row in range(4)
    )


def gaussian_matrix_power(matrix, exponent):
    identity = tuple(
        tuple((1, 0) if row == column else (0, 0) for column in range(4))
        for row in range(4)
    )
    result = identity
    for _ in range(exponent):
        result = gaussian_matrix_multiply(matrix, result)
    return result


def assert_scalar_numerator(matrix, scalar, denominator):
    assert all(
        matrix[row][column]
        == (
            (scalar[0] * denominator, scalar[1] * denominator)
            if row == column
            else (0, 0)
        )
        for row in range(4)
        for column in range(4)
    )


def build_certificate():
    all_vector_maps = {
        induced_vector_map(permutation)
        for permutation in itertools.permutations(range(6))
    }
    assert len(all_vector_maps) == 720

    adjacent = tuple(
        tuple(
            index + 1 if value == index else index if value == index + 1 else value
            for value in range(6)
        )
        for index in range(5)
    )
    adjacent_maps = tuple(induced_vector_map(permutation) for permutation in adjacent)
    coxeter_relations = (
        tuple((index, index) for index in range(5))
        + tuple(
            (left, right, left, right)
            for left in range(5)
            for right in range(left + 2, 5)
        )
        + tuple(
            (index, index + 1, index, index + 1, index, index + 1)
            for index in range(4)
        )
    )
    _, full_rows, full_rhs, full_width = relation_system(
        adjacent_maps, coxeter_relations
    )
    full_ranks = system_ranks(full_rows, full_rhs, full_width)
    assert full_ranks == (15, 16)

    stabilizer = conference_stabilizer()
    golden_group = frozenset(permutation for permutation, _ in stabilizer)
    generator_a = (0, 2, 4, 1, 5, 3)
    generator_b = (1, 0, 3, 2, 4, 5)
    assert generator_a in golden_group and generator_b in golden_group
    assert (
        permutation_order(generator_a),
        permutation_order(generator_b),
        permutation_order(compose_permutations(generator_a, generator_b)),
    ) == (5, 2, 3)
    assert generated_permutation_group((generator_a, generator_b)) == golden_group

    golden_permutations = (generator_a, generator_b)
    golden_maps = tuple(induced_vector_map(permutation) for permutation in golden_permutations)
    golden_relations = ((0, 0, 0, 0, 0), (1, 1), (0, 1, 0, 1, 0, 1))
    golden_signs, golden_rows, golden_rhs, golden_width = relation_system(
        golden_maps, golden_relations
    )
    golden_ranks = system_ranks(golden_rows, golden_rhs, golden_width)
    assert golden_ranks == (2, 2)
    splittings = valid_assignments(
        golden_maps, golden_signs, golden_relations
    )
    assert len(splittings) == 64
    assert all(
        len(generated_lift_group(golden_maps, golden_signs, assignment)) == 60
        for assignment in splittings
    )

    splitting_set = set(splittings)
    conjugacy_orbits = []
    unseen = set(splittings)
    while unseen:
        source = min(unseen)
        orbit = {
            pauli_conjugate_assignment(
                golden_maps, golden_signs, source, pauli_vector
            )
            for pauli_vector in range(16)
        }
        assert orbit <= splitting_set and len(orbit) == 16
        conjugacy_orbits.append(frozenset(orbit))
        unseen -= orbit
    assert len(conjugacy_orbits) == 4

    conference = tuple(conference_bit(vector) for vector in range(16))
    linear_difference_permutations = []
    for permutation in itertools.permutations(range(6)):
        vector_map = induced_vector_map(permutation)
        difference = tuple(
            conference[vector] ^ conference[vector_map[vector]]
            for vector in range(16)
        )
        if is_linear(difference):
            linear_difference_permutations.append(permutation)
    assert frozenset(linear_difference_permutations) == golden_group

    base_assignment = min(splittings)
    golden_twist = base_assignment
    generator_differences = []
    for index, vector_map in enumerate(golden_maps):
        difference = tuple(
            conference[vector] ^ conference[vector_map[vector]]
            for vector in range(16)
        )
        assert is_linear(difference)
        bits = sum(difference[1 << bit] << bit for bit in range(4))
        generator_differences.append(bits)
        golden_twist ^= bits << (4 * index)
    assert golden_twist in splitting_set
    orbit_index = {
        assignment: index
        for index, orbit in enumerate(conjugacy_orbits)
        for assignment in orbit
    }
    assert orbit_index[base_assignment] != orbit_index[golden_twist]

    # Extra-juice boundary: the Clifford extension itself still splits on
    # the full order-120 conference switching normalizer S5, even though
    # the distinguished conference H1 class does not extend across its odd
    # coset.
    switching_group = conference_switching_group()
    orientation_reverser = min(
        permutation
        for permutation in switching_group
        if permutation_parity(permutation)
    )
    assert permutation_order(orientation_reverser) == 4
    assert (
        generated_permutation_group(
            (generator_a, generator_b, orientation_reverser)
        )
        == switching_group
    )
    switching_maps = golden_maps + (induced_vector_map(orientation_reverser),)
    switching_signs = tuple(canonical_sign(vector_map) for vector_map in switching_maps)
    generator_orders = (5, 2, 4)
    individual_candidates = []
    for index, order in enumerate(generator_orders):
        individual_candidates.append(
            tuple(
                bits
                for bits in range(16)
                if evaluate_word(
                    switching_maps,
                    switching_signs,
                    (index,) * order,
                    bits << (4 * index),
                )
                == (IDENTITY_VECTOR_MAP, ZERO_SIGN)
            )
        )
    switching_census = {}
    switching_splittings = []
    for corrections in itertools.product(*individual_candidates):
        assignment = sum(
            correction << (4 * index)
            for index, correction in enumerate(corrections)
        )
        subgroup = generated_lift_group(
            switching_maps, switching_signs, assignment
        )
        key = (len(subgroup), len({element[0] for element in subgroup}))
        switching_census[key] = switching_census.get(key, 0) + 1
        if key == (120, 120):
            switching_splittings.append(assignment)
    assert switching_census == {(120, 120): 32, (1920, 120): 480}

    switching_unseen = set(switching_splittings)
    switching_orbits = []
    while switching_unseen:
        source = min(switching_unseen)
        orbit = {
            pauli_conjugate_assignment(
                switching_maps,
                switching_signs,
                source,
                pauli_vector,
            )
            for pauli_vector in range(16)
        }
        assert orbit <= set(switching_splittings) and len(orbit) == 16
        switching_orbits.append(frozenset(orbit))
        switching_unseen -= orbit
    assert len(switching_orbits) == 2
    extendable_golden_classes = sorted(
        {orbit_index[assignment & 255] for assignment in switching_splittings}
    )
    assert len(extendable_golden_classes) == 2
    assert orbit_index[base_assignment] in extendable_golden_classes
    assert orbit_index[golden_twist] not in extendable_golden_classes

    # Exact Schrödinger intertwiners for the base A5 splitting.  Both have
    # denominator 2.  Their raw scalar relations are a^5=i, b^2=1,
    # (ab)^3=i.  Rephasing a by -i and b by -1 makes all three relations 1,
    # so the remaining U(1)-valued projective multiplier is trivial.
    assert_scalar_numerator(
        gaussian_matrix_power(UNITARY_A_NUMERATOR, 5), (0, 1), 2**5
    )
    assert_scalar_numerator(
        gaussian_matrix_power(UNITARY_B_NUMERATOR, 2), (1, 0), 2**2
    )
    product_numerator = gaussian_matrix_multiply(
        UNITARY_A_NUMERATOR, UNITARY_B_NUMERATOR
    )
    assert_scalar_numerator(
        gaussian_matrix_power(product_numerator, 3), (0, 1), 4**3
    )

    return {
        "schema": "c706-equivariant-clifford-lift-v1",
        "ground_field": "F2",
        "symplectic_group": "Sp4(F2) ~= S6",
        "symplectic_action_size": len(all_vector_maps),
        "clifford_mod_phase_extension": "1 -> F2^4 -> Clifford_2/phases -> Sp4(F2) -> 1",
        "full_S6_coxeter_system": {
            "variables": full_width,
            "coefficient_rank": full_ranks[0],
            "augmented_rank": full_ranks[1],
            "splits": False,
            "obstruction": "nonzero class in H^2(S6,F2^4)",
            "five_equation_contradiction_rows": (
                2,
                256,
                196608,
                257,
                196611,
            ),
            "five_equation_contradiction_rhs": (1, 1, 1, 1, 1),
        },
        "golden_A5": {
            "order": len(golden_group),
            "generators": (generator_a, generator_b),
            "presentation_orders": (5, 2, 3),
            "lift_variables": golden_width,
            "coefficient_rank": golden_ranks[0],
            "augmented_rank": golden_ranks[1],
            "splittings": len(splittings),
            "pauli_conjugacy_orbits": len(conjugacy_orbits),
            "orbit_sizes": sorted(map(len, conjugacy_orbits)),
            "H1_dimension": 2,
            "scalar_projective_multiplier": {
                "raw_relations": "U_a^5=iI, U_b^2=I, (U_a U_b)^3=iI",
                "rephasing": "U_a -> -i U_a, U_b -> -U_b",
                "class": "trivial in H^2(A5,U(1))",
            },
        },
        "conference_phase": {
            "permutations_with_linear_phase_difference": len(
                linear_difference_permutations
            ),
            "equals_golden_A5": True,
            "generator_linear_corrections": generator_differences,
            "base_splitting_assignment": base_assignment,
            "twisted_splitting_assignment": golden_twist,
            "base_conjugacy_class": orbit_index[base_assignment],
            "twisted_conjugacy_class": orbit_index[golden_twist],
            "class_nonzero_in_H1_A5_F2_4": True,
            "extends_to_conference_S5": False,
        },
        "conference_S5_boundary": {
            "order": len(switching_group),
            "orientation_reverser": orientation_reverser,
            "orientation_reverser_order": permutation_order(
                orientation_reverser
            ),
            "candidate_lift_census": {
                "split_complements_of_order_120": switching_census[(120, 120)],
                "full_preimages_of_order_1920": switching_census[(1920, 120)],
            },
            "splittings": len(switching_splittings),
            "pauli_conjugacy_orbits": len(switching_orbits),
            "H1_dimension": 1,
            "extendable_A5_conjugacy_classes": extendable_golden_classes,
            "golden_conference_class_extends": False,
        },
        "verdict": (
            "The full S6 Clifford extension is nonsplit. Its golden A5 "
            "restriction splits in 64 ways forming four Pauli-conjugacy "
            "classes; conference rephasing selects a nonzero H1 class."
        ),
        "scope": (
            "The class controls the integral conference marking and its "
            "triangle coboundary K, not the full-S6 Joubert tensor or the "
            "sqrt(5) eigenfield."
        ),
    }


def canonical_bytes(payload):
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    encoded = canonical_bytes(build_certificate())
    if args.check:
        assert OUTPUT.read_bytes() == encoded
        print(hashlib.sha256(encoded).hexdigest())
    else:
        OUTPUT.write_bytes(encoded)
        print(OUTPUT)


if __name__ == "__main__":
    main()
