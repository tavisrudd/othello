#!/usr/bin/env python3
"""Independent pure-Python replay of the C470 certificate."""

from __future__ import annotations

import hashlib
import itertools
import json
from collections import Counter, deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
CERTIFICATE = NOTES / "2026-07-22-c470-golay-hadamard-automorphisms.json"
Q = 3
N = 12


def compose(left, right):
    return bytes(left[right[i]] for i in range(len(right)))


def inverse(permutation):
    answer = bytearray(len(permutation))
    for old, new in enumerate(permutation):
        answer[new] = old
    return bytes(answer)


def conjugate(element, by):
    return compose(inverse(by), compose(element, by))


def generated_group(generators):
    identity = bytes(range(len(generators[0])))
    group = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            target = compose(generator, current)
            if target not in group:
                group.add(target)
                queue.append(target)
    return group


def generated_paired_group(left_generators, right_generators):
    identity = (bytes(range(N)), bytes(range(N)))
    group = {identity}
    queue = deque([identity])
    while queue:
        left, right = queue.popleft()
        for left_generator, right_generator in zip(left_generators, right_generators):
            target = (compose(left_generator, left), compose(right_generator, right))
            if target not in group:
                group.add(target)
                queue.append(target)
    return group


def projectivize(word):
    first = next(value for value in word if value)
    inverse_value = pow(first, -1, Q)
    return tuple(value * inverse_value % Q for value in word)


def enumerate_code(generator):
    for coefficients in itertools.product(range(Q), repeat=len(generator)):
        yield tuple(sum(coefficients[row] * generator[row][column]
                        for row in range(len(generator))) % Q
                    for column in range(len(generator[0])))


def act_word(permutation, mask, word):
    target = [0] * N
    for old, value in enumerate(word):
        sign = 2 if (mask >> old) & 1 else 1
        target[permutation[old]] = sign * value % Q
    return tuple(target)


def act_support(permutation, support):
    return tuple(sorted(permutation[i] for i in support))


def signed_compose(left, right):
    left_permutation, left_mask = left
    right_permutation, right_mask = right
    permutation = compose(left_permutation, right_permutation)
    mask = right_mask
    for old in range(N):
        if (left_mask >> right_permutation[old]) & 1:
            mask ^= 1 << old
    return permutation, mask


def signed_inverse(element):
    permutation, mask = element
    inverse_p = inverse(permutation)
    inverse_mask = 0
    for old in range(N):
        if (mask >> old) & 1:
            inverse_mask |= 1 << permutation[old]
    return inverse_p, inverse_mask


def signed_conjugate(element, by):
    return signed_compose(signed_inverse(by), signed_compose(element, by))


def generated_signed_group(generators):
    identity = (bytes(range(N)), 0)
    group = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            target = signed_compose(generator, current)
            if target not in group:
                group.add(target)
                queue.append(target)
    return group


def mask_from_signs(signs):
    return sum((value == 2) << i for i, value in enumerate(signs))


def row_action(permutation, mask, points):
    index = {point: i for i, point in enumerate(points)}
    return bytes(index[projectivize(act_word(permutation, mask, point))] for point in points)


def row_action_with_scalars(permutation, mask, points):
    index = {point: i for i, point in enumerate(points)}
    row_permutation = []
    scalars = []
    for point in points:
        transformed = act_word(permutation, mask, point)
        row_permutation.append(index[projectivize(transformed)])
        scalars.append(next(value for value in transformed if value))
    return bytes(row_permutation), tuple(scalars)


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    for name, record in certificate["inputs"].items():
        path = ROOT / name
        assert path.stat().st_size == record["bytes"]
        assert hashlib.sha256(path.read_bytes()).hexdigest() == record["sha256"]

    generator = certificate["extended_code"]["generator_matrix"]
    codewords = set(enumerate_code(generator))
    assert len(codewords) == 729
    assert Counter(sum(value != 0 for value in word) for word in codewords) == {
        0: 1, 6: 264, 9: 440, 12: 24,
    }
    support_fibres = Counter(
        tuple(i for i, value in enumerate(word) if value)
        for word in codewords if sum(value != 0 for value in word) == 6
    )
    hexads = set(support_fibres)
    assert len(hexads) == 132 and set(support_fibres.values()) == {2}
    five_counts = Counter(subset for block in hexads for subset in itertools.combinations(block, 5))
    assert Counter(five_counts.values()) == {1: 792}

    group_record = certificate["coordinate_and_design_groups"]
    m_generators = [bytes(p) for p in group_record["hexad_design_group"][
        "generators_old_to_new_zero_based"]]
    M = generated_group(m_generators)
    assert len(M) == 95040
    assert all(act_support(generator_p, block) in hexads
               for generator_p in m_generators for block in hexads)
    ordered_five_orbit = {
        tuple(permutation[i] for i in range(5)) for permutation in M
    }
    assert len(ordered_five_orbit) == 12 * 11 * 10 * 9 * 8

    p_generators = [bytes(p) for p in group_record["pure_coordinate_code_group"][
        "generators_old_to_new_zero_based"]]
    P = generated_group(p_generators)
    assert len(P) == 7920
    assert all(act_word(permutation, 0, row) in codewords
               for permutation in p_generators for row in generator)
    assert len({permutation[0] for permutation in P}) == 12

    parents = certificate["two_M11_parents_and_frozen_intersection"]
    k_generators = [bytes(p) for p in parents["parity_stabilizer_generators"]]
    K = generated_group(k_generators)
    assert len(K) == 7920 and all(permutation[11] == 11 for permutation in K)
    assert all(act_support(permutation, block) in hexads
               for permutation in k_generators for block in hexads)
    f_generators = [bytes(p) for p in parents["frozen_generators"]]
    F = generated_group(f_generators)
    assert len(F) == 660
    assert P & K == F
    assert generated_group(p_generators + k_generators) == M
    assert len(P) // len(F) == len(K) // len(F) == 12

    monomial = certificate["monomial_group"]
    signed_generators = []
    for record in monomial["standard_M12_generator_lifts"]:
        permutation = bytes(record["coordinate_permutation"])
        mask = mask_from_signs(record["chosen_signs"])
        signed_generators.append((permutation, mask))
        assert act_word(permutation, mask, generator[0]) in codewords
        assert all(act_word(permutation, mask, row) in codewords for row in generator)
    L = generated_signed_group(signed_generators)
    assert len(L) == 190080
    assert {permutation for permutation, _ in L} == M
    kernel = {(permutation, mask) for permutation, mask in L
              if permutation == bytes(range(N))}
    assert kernel == {(bytes(range(N)), 0), (bytes(range(N)), (1 << N) - 1)}

    # Independently recover perfectness: the normal closure of the basic commutator is all of L.
    a, b = signed_generators
    commutator = signed_compose(
        signed_inverse(a), signed_compose(signed_inverse(b), signed_compose(a, b)))
    normal_generators = [commutator]
    while True:
        derived = generated_signed_group(normal_generators)
        additions = []
        for element in normal_generators:
            for generator_p in signed_generators:
                target = signed_conjugate(element, generator_p)
                if target not in derived:
                    additions.append(target)
        if not additions:
            break
        normal_generators.extend(additions)
    assert len(derived) == 190080
    assert (bytes(range(N)), (1 << N) - 1) in derived

    points = [tuple(word) for word in certificate["hadamard_row_action"][
        "projective_weight_12_points"]]
    assert set(points) == {projectivize(word) for word in codewords if all(word)}
    induced = [row_action(permutation, mask, points)
               for permutation, mask in signed_generators]
    assert [list(p) for p in induced] == certificate["hadamard_row_action"][
        "induced_generator_permutations"]
    R = generated_group(induced)
    assert len(R) == 95040
    x = bytes(certificate["hadamard_row_action"]["carrier_conjugator_old_to_new_zero_based"])
    # GAP's right-action conjugation convention is opposite our function-composition convention.
    assert {conjugate(permutation, inverse(x)) for permutation in M} == R
    aligned = [conjugate(permutation, x) for permutation in induced]
    assert all(permutation in M for permutation in aligned)
    assert not any(
        conjugate(m_generators[0], candidate) == aligned[0]
        and conjugate(m_generators[1], candidate) == aligned[1]
        for candidate in M
    )
    row_record = certificate["hadamard_row_action"]
    image_pure_generators = [bytes(p) for p in row_record[
        "outer_image_pure_M11_generators"]]
    image_puncture_generators = [bytes(p) for p in row_record[
        "outer_image_puncture_M11_generators"]]
    image_pure = generated_group(image_pure_generators)
    image_puncture = generated_group(image_puncture_generators)
    assert len(image_pure) == len(image_puncture) == 7920
    y_pk = bytes(row_record["pure_to_puncture_class_conjugator"])
    y_kp = bytes(row_record["puncture_to_pure_class_conjugator"])
    assert {conjugate(element, inverse(y_pk)) for element in image_pure} == K
    assert {conjugate(element, inverse(y_kp)) for element in image_puncture} == P
    assert not any(all(conjugate(g, inverse(candidate)) in P
                       for g in image_pure_generators) for candidate in M)
    assert not any(all(conjugate(g, inverse(candidate)) in K
                       for g in image_puncture_generators) for candidate in M)
    assert bytes(row_record["outer_square_inner_conjugator"]) in M

    bipartite = certificate["second_order_signed_bipartite_geometry"]
    paired = generated_paired_group(m_generators, induced)
    assert len(paired) == 95040
    assert len({(left[11], right[0]) for left, right in paired}) == 144
    cell_stabilizer = {left for left, right in paired if left[11] == 11 and right[0] == 0}
    assert cell_stabilizer == F
    assert bipartite["pair_count"] == 144
    assert bipartite["base_cell_stabilizer_order"] == 660
    for record, signed_generator in zip(
            bipartite["generator_signing_equivariance"], signed_generators):
        row_permutation, scalars = row_action_with_scalars(*signed_generator, points)
        assert record["Hadamard_row_permutation"] == list(row_permutation)
        assert record["Hadamard_row_scalars"] == list(scalars)

    frozen_rows = [row_action(permutation, 0, points) for permutation in f_generators]
    frozen_row_group = generated_group(frozen_rows)
    unseen = set(range(12))
    orbit_sizes = []
    while unseen:
        base = min(unseen)
        orbit = {permutation[base] for permutation in frozen_row_group}
        unseen -= orbit
        orbit_sizes.append(len(orbit))
    assert sorted(orbit_sizes) == [1, 11]

    print("C470 independent replay: PASS")
    print("orders M12/M11/PSL/2.M12 = 95040/7920/660/190080; outer Hadamard action verified")


if __name__ == "__main__":
    main()
