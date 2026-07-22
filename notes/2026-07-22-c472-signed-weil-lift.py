#!/usr/bin/env python3
"""Generate the exact C472 signed-preimage and Weil-discriminator certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter, deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
OUT = NOTES / "2026-07-22-c472-signed-weil-lift.json"
P = 3
N = 12
IDENTITY_PERMUTATION = bytes(range(N))
GLOBAL_MASK = (1 << N) - 1
INPUT_HASHES = {
    "notes/2026-07-22-c470-golay-hadamard-automorphisms.json":
        "694ddb709dce8b4b513b33fa899d23fe538528d76a0d82ec6b8779305e6f9a07",
    "notes/2026-07-22-c471-hadamard-degeneration-complex.json":
        "3676e3b8b1c7c92f9c74b80c90b572d3322c73a2509cd96b5718e769fb0e5a15",
    "notes/2026-07-21-c465-mod3-weil-golay.json":
        "62dc3855782f570699d534907a91028523d393863a8b45189782a13a44614958",
    "notes/2026-07-21-c450-weil-cross-sheet.json":
        "a6fc2d854732011c82b6b5c1440b407b64041bd31f4bac59adec15c1f127353f",
    "notes/2026-07-21-c455-fourier-weil.json":
        "7fa8d433190b8bcac53127ce4d36fde0620f4048bbcdf74a7096217d018a46f9",
}


def verify_inputs():
    result = {}
    for name, expected in INPUT_HASHES.items():
        data = (ROOT / name).read_bytes()
        actual = hashlib.sha256(data).hexdigest()
        if actual != expected:
            raise RuntimeError(f"input hash drift for {name}")
        result[name] = {"bytes": len(data), "sha256": actual}
    return result


def compose(left, right):
    return bytes(left[right[i]] for i in range(len(right)))


def inverse(permutation):
    answer = bytearray(len(permutation))
    for old, new in enumerate(permutation):
        answer[new] = old
    return bytes(answer)


def generated_group(generators):
    group = {IDENTITY_PERMUTATION}
    queue = deque(group)
    while queue:
        current = queue.popleft()
        for generator in generators:
            target = compose(generator, current)
            if target not in group:
                group.add(target)
                queue.append(target)
    return group


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
    inverse_permutation = inverse(permutation)
    inverse_mask = 0
    for old in range(N):
        if (mask >> old) & 1:
            inverse_mask |= 1 << permutation[old]
    return inverse_permutation, inverse_mask


def signed_commutator(left, right):
    return signed_compose(signed_inverse(left), signed_compose(
        signed_inverse(right), signed_compose(left, right)))


def signed_conjugate(element, by):
    return signed_compose(signed_inverse(by), signed_compose(element, by))


def generated_signed_group(generators):
    identity = (IDENTITY_PERMUTATION, 0)
    group = {identity}
    queue = deque(group)
    while queue:
        current = queue.popleft()
        for generator in generators:
            target = signed_compose(generator, current)
            if target not in group:
                group.add(target)
                queue.append(target)
    return group


def signed_order(element):
    identity = (IDENTITY_PERMUTATION, 0)
    value = identity
    for order in range(1, 1000):
        value = signed_compose(element, value)
        if value == identity:
            return order
    raise AssertionError("signed element order exceeded bound")


def mask_from_signs(signs):
    return sum((value == 2) << i for i, value in enumerate(signs))


def projectivize(word):
    first = next(value for value in word if value)
    inverse_value = pow(first, -1, P)
    return tuple(value * inverse_value % P for value in word)


def signed_act(element, word):
    permutation, mask = element
    answer = [0] * N
    for old, value in enumerate(word):
        sign = 2 if (mask >> old) & 1 else 1
        answer[permutation[old]] = sign * value % P
    return tuple(answer)


def row_action_with_scalars(element, points):
    index = {point: i for i, point in enumerate(points)}
    row_permutation, scalars = [], []
    for point in points:
        transformed = signed_act(element, point)
        row_permutation.append(index[projectivize(transformed)])
        scalars.append(next(value for value in transformed if value))
    return tuple(row_permutation), tuple(scalars)


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
    pivots = [next(i for i, x in enumerate(row) if x) for row in basis]
    coefficients = [vector[i] % P for i in pivots]
    rebuilt = [sum(coefficients[k] * basis[k][j] for k in range(len(basis))) % P
               for j in range(len(vector))]
    if rebuilt != [x % P for x in vector]:
        raise AssertionError("vector outside asserted carrier")
    return coefficients


def restricted_matrix(element, basis):
    return [coordinates(signed_act(element, row), basis) for row in basis]


def normal_closure(seed, generators):
    normal_generators = [seed]
    while True:
        subgroup = generated_signed_group(normal_generators)
        additions = []
        for element in normal_generators:
            for generator in generators:
                conjugate = signed_conjugate(element, generator)
                if conjugate not in subgroup:
                    additions.append(conjugate)
        if not additions:
            return subgroup
        normal_generators.extend(additions)


def small_generating_set(group):
    generators = []
    generated = {(IDENTITY_PERMUTATION, 0)}
    for element in sorted(group):
        if element not in generated:
            generators.append(element)
            generated = generated_signed_group(generators)
            if generated == group:
                return generators
    raise AssertionError("failed to generate signed subgroup")


def shortest_word(target, generators):
    identity = (IDENTITY_PERMUTATION, 0)
    parents = {identity: None}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for index, generator in enumerate(generators):
            candidate = signed_compose(generator, current)
            if candidate in parents:
                continue
            parents[candidate] = (current, index)
            if candidate == target:
                word = []
                while candidate != identity:
                    candidate, step = parents[candidate]
                    word.append(step)
                return list(reversed(word)), len(parents)
            queue.append(candidate)
    raise AssertionError("target absent from generated group")


def build():
    inputs = verify_inputs()
    c470 = json.loads((NOTES / "2026-07-22-c470-golay-hadamard-automorphisms.json").read_text())
    c471 = json.loads((NOTES / "2026-07-22-c471-hadamard-degeneration-complex.json").read_text())
    c465 = json.loads((NOTES / "2026-07-21-c465-mod3-weil-golay.json").read_text())
    c455 = json.loads((NOTES / "2026-07-21-c455-fourier-weil.json").read_text())

    signed_generators = []
    for record in c470["monomial_group"]["standard_M12_generator_lifts"]:
        signed_generators.append((bytes(record["coordinate_permutation"]),
                                  mask_from_signs(record["chosen_signs"])))
    signed_group = generated_signed_group(signed_generators)
    assert len(signed_group) == 190080

    frozen_generators = [bytes(permutation) for permutation in c470[
        "two_M11_parents_and_frozen_intersection"]["frozen_generators"]]
    frozen_group = generated_group(frozen_generators)
    assert len(frozen_group) == 660
    preimage = {(permutation, mask) for permutation, mask in signed_group
                if permutation in frozen_group}
    assert len(preimage) == 1320
    central = (IDENTITY_PERMUTATION, GLOBAL_MASK)
    kernel = {element for element in preimage if element[0] == IDENTITY_PERMUTATION}
    assert kernel == {(IDENTITY_PERMUTATION, 0), central}

    pure_section = {(permutation, 0) for permutation in frozen_group}
    assert pure_section < preimage and len(pure_section) == 660
    cocycle_nonzero = 0
    for left in frozen_group:
        for right in frozen_group:
            if signed_compose((left, 0), (right, 0)) != (compose(left, right), 0):
                cocycle_nonzero += 1
    assert cocycle_nonzero == 0
    assert {signed_compose(z, section) for z in kernel for section in pure_section} == preimage

    t = (frozen_generators[0], 0)
    s = (frozen_generators[1], 0)
    b = signed_compose(s, t)
    relation_orders = {
        "T": signed_order(t),
        "S": signed_order(s),
        "S*T": signed_order(b),
        "S*(S*T)=T": signed_order(signed_compose(s, b)),
        "[S,S*T]": signed_order(signed_commutator(s, b)),
        "central_z": signed_order(central),
    }
    assert relation_orders == {
        "T": 11, "S": 2, "S*T": 3, "S*(S*T)=T": 11,
        "[S,S*T]": 5, "central_z": 2,
    }
    assert all(signed_compose(central, generator) == signed_compose(generator, central)
               for generator in (t, s))
    lift_choice_table = []
    for central_on_t, central_on_s in itertools.product((0, 1), repeat=2):
        lifted_t = signed_compose(central, t) if central_on_t else t
        lifted_s = signed_compose(central, s) if central_on_s else s
        lifted_st = signed_compose(lifted_s, lifted_t)
        generated = generated_signed_group([lifted_t, lifted_s])
        lift_choice_table.append({
            "central_on_T": central_on_t,
            "central_on_S": central_on_s,
            "generated_order": len(generated),
            "order_T": signed_order(lifted_t),
            "order_S": signed_order(lifted_s),
            "order_S_times_T": signed_order(lifted_st),
            "is_complement": len(generated) == 660 and central not in generated,
        })
    assert lift_choice_table == [
        {"central_on_T": 0, "central_on_S": 0, "generated_order": 660,
         "order_T": 11, "order_S": 2, "order_S_times_T": 3,
         "is_complement": True},
        {"central_on_T": 0, "central_on_S": 1, "generated_order": 1320,
         "order_T": 11, "order_S": 2, "order_S_times_T": 6,
         "is_complement": False},
        {"central_on_T": 1, "central_on_S": 0, "generated_order": 1320,
         "order_T": 22, "order_S": 2, "order_S_times_T": 6,
         "is_complement": False},
        {"central_on_T": 1, "central_on_S": 1, "generated_order": 1320,
         "order_T": 22, "order_S": 2, "order_S_times_T": 3,
         "is_complement": False},
    ]
    center = {element for element in preimage if all(
        signed_compose(element, generator) == signed_compose(generator, element)
        for generator in (t, s, central))}
    assert center == {(IDENTITY_PERMUTATION, 0), central}
    derived = normal_closure(signed_commutator(s, t), [s, t, central])
    assert derived == pure_section

    order_census = dict(sorted(Counter(signed_order(element) for element in preimage).items()))
    assert order_census == {1: 1, 2: 111, 3: 110, 5: 264, 6: 330,
                            10: 264, 11: 120, 22: 120}

    points = [tuple(word) for word in c470["hadamard_row_action"][
        "projective_weight_12_points"]]
    signed_pair_stabilizer = set()
    for element in preimage:
        permutation, mask = element
        row_permutation, row_scalars = row_action_with_scalars(element, points)
        if (permutation[11] == 11 and not ((mask >> 11) & 1)
                and row_permutation[0] == 0 and row_scalars[0] == 1):
            signed_pair_stabilizer.add(element)
    assert signed_pair_stabilizer == pure_section

    coordinate_parent_complement = set()
    row_parent_complement = set()
    for element in signed_group:
        permutation, mask = element
        row_permutation, row_scalars = row_action_with_scalars(element, points)
        if permutation[11] == 11 and not ((mask >> 11) & 1):
            coordinate_parent_complement.add(element)
        if row_permutation[0] == 0 and row_scalars[0] == 1:
            row_parent_complement.add(element)
    assert len(coordinate_parent_complement) == len(row_parent_complement) == 7920
    assert coordinate_parent_complement & row_parent_complement == pure_section
    pure_parent_generators = [bytes(permutation) for permutation in c470[
        "coordinate_and_design_groups"]["pure_coordinate_code_group"][
            "generators_old_to_new_zero_based"]]
    parity_parent_generators = [bytes(permutation) for permutation in c470[
        "two_M11_parents_and_frozen_intersection"]["parity_stabilizer_generators"]]
    pure_parent = generated_group(pure_parent_generators)
    parity_parent = generated_group(parity_parent_generators)
    assert {element[0] for element in coordinate_parent_complement} == parity_parent
    assert {element[0] for element in row_parent_complement} == pure_parent
    assert sum(element[1] == 0 for element in coordinate_parent_complement) == 660
    assert all(element[1] == 0 for element in row_parent_complement)
    coordinate_parent_preimage = {element for element in signed_group
                                  if element[0] in parity_parent}
    row_parent_preimage = {element for element in signed_group if element[0] in pure_parent}
    assert len(coordinate_parent_preimage) == len(row_parent_preimage) == 15840
    assert {signed_compose(z, g) for z in kernel for g in coordinate_parent_complement} == \
        coordinate_parent_preimage
    assert {signed_compose(z, g) for z in kernel for g in row_parent_complement} == \
        row_parent_preimage
    coordinate_parent_generators = small_generating_set(coordinate_parent_complement)
    row_parent_generators = small_generating_set(row_parent_complement)
    parent_generators = coordinate_parent_generators + row_parent_generators
    parent_join = generated_signed_group(parent_generators)
    assert parent_join == signed_group
    central_word, central_word_search_size = shortest_word(central, parent_generators)

    hadamard = c471["integral_matrix_factorization"]["hadamard_matrix_H"]
    raw_rows = [tuple(value % P for value in row) for row in hadamard]
    raw_row_index = {projectivize(row): i for i, row in enumerate(raw_rows)}
    positive_orbit = set()
    negative_orbit = set()
    for element in signed_group:
        permutation, mask = element
        coordinate = permutation[11]
        coordinate_sign = -1 if (mask >> 11) & 1 else 1
        transformed = signed_act(element, raw_rows[0])
        row = raw_row_index[projectivize(transformed)]
        if transformed == raw_rows[row]:
            row_sign = 1
        else:
            assert transformed == tuple(2 * value % P for value in raw_rows[row])
            row_sign = -1
        positive_orbit.add((coordinate, coordinate_sign, row, row_sign))
        negative_orbit.add((coordinate, coordinate_sign, row, -row_sign))
    all_signed_pairs = {(coordinate, coordinate_sign, row, row_sign)
                        for coordinate in range(N) for coordinate_sign in (-1, 1)
                        for row in range(N) for row_sign in (-1, 1)}
    assert len(positive_orbit) == len(negative_orbit) == 288
    assert positive_orbit.isdisjoint(negative_orbit)
    assert positive_orbit | negative_orbit == all_signed_pairs
    assert {coordinate_sign * row_sign * hadamard[row][coordinate]
            for coordinate, coordinate_sign, row, row_sign in positive_orbit} == {1}
    assert {coordinate_sign * row_sign * hadamard[row][coordinate]
            for coordinate, coordinate_sign, row, row_sign in negative_orbit} == {-1}

    carrier = c471["c469_carrier_identification"]["extended_code_basis_rref"]
    shortened = c471["puncture_shorten_bridge"]["shortened_basis_rref"]
    extended_shortened = rref([row + [0] for row in shortened])
    ones = [1] * N
    assert rref([*extended_shortened, ones]) == carrier
    generator_actions = {
        "T": restricted_matrix(t, carrier),
        "S": restricted_matrix(s, carrier),
        "central_z": restricted_matrix(central, carrier),
    }
    assert generator_actions["central_z"] == [[2 * int(i == j) for j in range(6)]
                                                for i in range(6)]
    assert all(rref([signed_act(generator, row) for row in extended_shortened]) ==
               extended_shortened for generator in (t, s))
    assert signed_act(t, ones) == tuple(ones) and signed_act(s, ones) == tuple(ones)

    case = next(item for item in c465["cases"] if item["q"] == 11)
    brauer = case["brauer"]
    psl_classes = brauer["concrete_p_regular_classes"]
    perfect_values = brauer["modules"]["perfect_code"]["brauer_values"]
    split_class_records = []
    for central_exponent in (0, 1):
        for order, size, value in zip(psl_classes["orders"], psl_classes["sizes"],
                                      perfect_values):
            split_class_records.append({
                "central_exponent": central_exponent,
                "projective_order": order,
                "lift_order": order if central_exponent == 0 else (2 if order == 1 else
                              (order if order == 2 else 2 * order)),
                "class_size": size,
                "brauer_value": value if central_exponent == 0 else f"-({value})",
            })
    genuine_rows = [row for row in brauer["sl_brauer_irreducibles"]
                    if row["index"] in (7, 8)]
    assert [row["values"][1] for row in genuine_rows] == ["-6", "-6"]
    assert [row["values"][2] for row in genuine_rows] == ["0", "0"]
    assert c455["central_action"] == "rho(-I_6)=-R; on the certified even spaces it is -I"

    return {
        "schema": "c472-signed-weil-lift-v1",
        "task": "C472",
        "verdict": "sharp negative: the frozen preimage is the split direct product C2 x PSL_2(11), and its signed six-space is reducible 1_- + 5_epsilon,- rather than either irreducible genuine Weil six-space",
        "inputs": inputs,
        "full_preimage": {
            "construction": "enumerate the 190080 literal signed monomial elements generated by C470 and retain exactly those whose coordinate permutation lies in C470's frozen 660-set",
            "ambient_signed_group_order": len(signed_group),
            "projective_frozen_group_order": len(frozen_group),
            "preimage_order": len(preimage),
            "kernel": [
                {"permutation": list(element[0]), "sign_mask": element[1]}
                for element in sorted(kernel)
            ],
            "central_generator": {"permutation": list(central[0]),
                                  "sign_mask": central[1],
                                  "coordinate_signs": [2] * N},
            "literal_complement_generators": {
                "T": {"permutation": list(t[0]), "sign_mask": t[1]},
                "S": {"permutation": list(s[0]), "sign_mask": s[1]},
            },
            "relation_orders": relation_orders,
            "concrete_relation_profile": "with a=S and b=S*T: a^2=b^3=(ab)^11=[a,b]^5=1; the generated complement has exactly 660 elements",
            "center_order": len(center),
            "derived_subgroup_order": len(derived),
            "derived_subgroup_equals_complement": True,
            "element_order_census": {str(order): count for order, count in order_census.items()},
        },
        "extension_decision": {
            "type": "split direct product C2 x PSL_2(11)",
            "nonsplit_2_PSL2_11": False,
            "pure_section_size": len(pure_section),
            "multiplication_map_C2_times_section_is_bijective": True,
            "section_formula": "s(g)=(g,0), the literal pure coordinate lift",
            "cocycle_formula": "c(g,h)=s(g)s(h)s(gh)^(-1)=0 for every ordered pair",
            "ordered_pairs_checked": len(frozen_group) ** 2,
            "nonzero_cocycle_pairs": cocycle_nonzero,
            "uniqueness_of_complement": "PSL_2(11) is perfect, so Hom(PSL_2(11),C2)=0; the direct product has no second graph complement",
            "nonsplit_order_discriminator": "the preimage has 110 noncentral involutions; in SL_2(11) the 110 lifts of projective involutions have order 4",
            "cohomological_restriction": "the nonzero ambient central-extension class restricts to zero on the frozen PSL_2(11) hinge; the alternative nonsplit class exists abstractly but is not realized by this embedding",
        },
        "signed_pair_geometry": {
            "base_pair": {"coordinate": "+e_11", "Hadamard_row": "+h_0"},
            "stabilizer_order": len(signed_pair_stabilizer),
            "stabilizer_equals_pure_section": True,
            "projection_to_frozen_group_bijective": True,
            "interpretation": "choosing both signs lifts C470's projective base cell and supplies the explicit complement",
            "all_signed_pair_count": len(all_signed_pairs),
            "orbit_partition": [
                {"size": len(positive_orbit), "integral_inner_product": 1,
                 "stabilizer_order": len(signed_group) // len(positive_orbit)},
                {"size": len(negative_orbit), "integral_inner_product": -1,
                 "stabilizer_order": len(signed_group) // len(negative_orbit)},
            ],
            "orbits_exhaust_all_signed_pairs": True,
            "geometric_cocycle_trivialization": "orientation of a signed coordinate/Hadamard-row pair selects the order-660 complement; simultaneous global sign preserves its inner-product orbit but does not fix the oriented pair",
        },
        "two_parent_signed_gluing": {
            "coordinate_oriented_parent": {
                "description": "stabilizer of +e_11; a signed complement over C470's parity-coordinate M11",
                "order": len(coordinate_parent_complement),
                "full_preimage_order": len(coordinate_parent_preimage),
                "pure_elements": sum(element[1] == 0 for element in
                                     coordinate_parent_complement),
                "generators": [{"permutation": list(element[0]), "sign_mask": element[1]}
                               for element in coordinate_parent_generators],
            },
            "row_oriented_parent": {
                "description": "stabilizer of +h_0; the literal pure complement over C470's transitive M11",
                "order": len(row_parent_complement),
                "full_preimage_order": len(row_parent_preimage),
                "pure_elements": sum(element[1] == 0 for element in row_parent_complement),
                "generators": [{"permutation": list(element[0]), "sign_mask": element[1]}
                               for element in row_parent_generators],
            },
            "intersection_order": len(coordinate_parent_complement & row_parent_complement),
            "intersection_equals_frozen_pure_complement": True,
            "join_order": len(parent_join),
            "join_equals_full_signed_group": True,
            "central_witness_word_generator_indices": central_word,
            "central_witness_word_length": len(central_word),
            "central_witness_BFS_states": central_word_search_size,
            "interpretation": "both M11 parent preimages split and agree on the split PSL_2(11) hinge, but their chosen complements generate the globally nonsplit signed group and recover its center",
        },
        "six_dimensional_action": {
            "carrier_basis_rref": carrier,
            "literal_generator_matrices": generator_actions,
            "central_scalar_over_F3": 2,
            "central_Brauer_value": "-6",
            "complement_decomposition": "1 direct-sum 5_epsilon",
            "full_preimage_composition_factors": ["1_-", "5_epsilon,-"],
            "semisimple": True,
            "invariant_line_generator": ones,
            "five_space_basis": extended_shortened,
            "relation_to_C471": "the signed Bockstein transports this same split action canonically between the kernel and cokernel carriers",
            "brauer_character_formula": "chi(z^e,g)=(-1)^e*(1+chi_5_epsilon(g))",
            "p_regular_class_records": split_class_records,
        },
        "genuine_Weil_comparison": {
            "C465_genuine_degree_six_rows": genuine_rows,
            "both_genuine_rows_irreducible": True,
            "both_genuine_rows_central_value": "-6",
            "central_value_matches_but_is_not_sufficient": True,
            "split_carrier_value_on_pure_projective_involution": "2",
            "split_carrier_value_on_central_times_projective_involution": "-2",
            "nonsplit_genuine_value_on_order_4_lift": "0",
            "group_level_obstruction": "C2 x PSL_2(11) is not SL_2(11): projective involutions lift to involutions, not order-four elements",
            "module_level_obstruction": "1_- direct-sum 5_epsilon,- is reducible, while both genuine degree-six Brauer rows are irreducible",
            "comparison_verdict": "neither genuine Gerardin reduction matches",
            "C455_consistency": "the central -I requirement is necessary and passes, but the extension and irreducibility discriminators fail",
        },
        "alternate_attack_stress_test": {
            "generator_lift_exhaustion": lift_choice_table,
            "generator_lift_conclusion": "among all four central choices for lifts of T and S, only the pure pair generates a 660-element complement; every other pair generates the full preimage and fails T^11=1 or (ST)^3=1",
            "independent_attacks": [
                "geometric: the oriented signed-pair stabilizer is a bijective 660-element lift",
                "cohomological: the literal pure section has zero cocycle on all 435600 pairs",
                "group-theoretic: center 2, derived subgroup 660, and 110 noncentral involutions force the split profile",
                "representation-theoretic: the invariant line plus simple five-space gives reducible 1_-+5_epsilon,-",
                "Brauer/order: genuine modules live on order-four involution lifts and have value 0, while the split lifts have order 2 and values +/-2",
            ],
            "all_attacks_agree": True,
        },
        "sharp_alternative": {
            "signed_genuine_Weil_realization_exists": False,
            "door_closed": "the unique frozen complement gives only the central-sign twist of C465's 1+5 permutation carrier; no different signed six-dimensional action remains inside C470's exact preimage",
            "C465_frozen_action_negative_unchanged": True,
        },
        "scope": {
            "imports_abstract_2M12_label_for_extension_decision": False,
            "full_Mathieu_classification_extended": False,
            "arithmetic_orientation_claimed": False,
            "Ext_group_claimed": False,
        },
    }


def canonical_bytes(payload):
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = canonical_bytes(build())
    if args.check:
        if not OUT.exists() or OUT.read_bytes() != data:
            raise SystemExit("C472 certificate is stale; regenerate without --check")
        print("C472 certificate check: PASS")
    else:
        OUT.write_bytes(data)
        print(f"wrote {OUT.relative_to(ROOT)} ({len(data)} bytes)")


if __name__ == "__main__":
    main()
