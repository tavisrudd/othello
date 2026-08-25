#!/usr/bin/env python3
"""Construct the type-I1 Cox coboundary through the TZ permutation basis."""

import argparse
import hashlib
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[1]
ACTION_INPUT = ROOT / "notes/2026-08-24-c958-type-i1-descent-action.json"
ACTION_SHA256 = "8755c5cf2d3acce3c670558ea3bee26fcad0691301a2e40231b41cf40e87ee25"
COCYCLE_INPUT = ROOT / "notes/2026-08-25-c958-type-i1-cox-descent-cocycle.json"
COCYCLE_SHA256 = "c7057b2471d76873e1cf358d7044241e64da76ae8e0bb44ae1c8c51d191accd7"

z, u, v, U, V, W, Y1, Y2, Y3, Y4, Z1, Z2, Z3 = sp.symbols(
    "z u v U V W Y1 Y2 Y3 Y4 Z1 Z2 Z3"
)
ID5 = tuple(range(5))


def permute_mask(permutation, mask):
    result = 0
    for index in range(5):
        if mask & (1 << index):
            result |= 1 << permutation[index]
    return result


def compose_weyl(left, right):
    """Apply right, then left."""
    lp, lf = left
    rp, rf = right
    return tuple(lp[rp[index]] for index in range(5)), lf ^ permute_mask(lp, rf)


def inverse_weyl(value):
    permutation, flipped = value
    inv = tuple(permutation.index(index) for index in range(5))
    return inv, permute_mask(inv, flipped)


def cycle(*indices):
    permutation = list(ID5)
    for left, right in zip(indices, indices[1:] + indices[:1]):
        permutation[left - 1] = right - 1
    return tuple(permutation)


def disjoint_cycles(*cycles):
    result = ID5
    for entries in cycles:
        result = compose_weyl((cycle(*entries), 0), (result, 0))[0]
    return result


def flip(*indices):
    return sum(1 << (index - 1) for index in indices)


def compose_permutation(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def permutation(size, cycles):
    result = list(range(size))
    for entries in cycles:
        for index, value in enumerate(entries):
            result[value] = entries[(index + 1) % len(entries)]
    return tuple(result)


def simplify(value):
    return sp.factor(sp.cancel(value))


def substitute(value, image):
    return simplify(value.subs(z, image, simultaneous=True))


def A(argument):
    return simplify(
        (argument - 1) * (argument + 3) * (argument**2 - 3)
        / (2 * argument * (argument**2 - 6 * argument - 3))
    )


def B(argument):
    return simplify(
        -(argument - 3) * (argument + 1) * (argument**2 - 3)
        / (2 * argument * (argument**2 + 6 * argument - 3))
    )


def cox_forms(argument, coordinates):
    x, y, w = coordinates
    aa, bb = A(argument) ** 2, B(argument) ** 2
    result = {f"E{index}": sp.Integer(1) for index in range(1, 6)}
    result.update({
        "L12": w,
        "L13": y,
        "L14": y - w,
        "L15": bb * y - aa * w,
        "L23": x,
        "L24": x - w,
        "L25": bb * x - w,
        "L34": x - y,
        "L35": aa * x - y,
        "L45": (bb - aa) * x + (1 - bb) * y + (aa - 1) * w,
        "Q": bb * (1 - aa) * x * y + aa * (bb - 1) * x * w + (aa - bb) * y * w,
    })
    return {label: simplify(value) for label, value in result.items()}


def residual_weight(label, point):
    first, second = point
    if label == "E1":
        return first
    if label == "E2":
        return second
    if label.startswith("E"):
        return sp.Integer(1)
    if label.startswith("L"):
        value = sp.Integer(1)
        if "1" in label[1:]:
            value /= first
        if "2" in label[1:]:
            value /= second
        return simplify(value)
    assert label == "Q"
    return simplify(1 / (first * second))


def build():
    action_bytes = ACTION_INPUT.read_bytes()
    cocycle_bytes = COCYCLE_INPUT.read_bytes()
    assert hashlib.sha256(action_bytes).hexdigest() == ACTION_SHA256
    assert hashlib.sha256(cocycle_bytes).hexdigest() == COCYCLE_SHA256
    action_data = json.loads(action_bytes)
    cocycle_data = json.loads(cocycle_bytes)

    labels = [f"E{index}" for index in range(1, 6)]
    labels += [f"L{left}{right}" for left in range(1, 6) for right in range(left + 1, 6)]
    labels += ["Q"]
    classes = {}
    for label in labels:
        vector = [0] * 6
        if label.startswith("E"):
            vector[int(label[1])] = 1
        elif label.startswith("L"):
            vector[0] = 1
            vector[int(label[1])] = -1
            vector[int(label[2])] = -1
        else:
            vector[0] = 2
            for index in range(1, 6):
                vector[index] = -1
        classes[label] = tuple(vector)

    source_generators = (
        (cycle(1, 2, 3), 0),
        (cycle(2, 3), flip(1, 2, 3, 5)),
        (ID5, flip(4, 5)),
    )
    target_generators = (
        (cycle(2, 5), flip(1, 2, 3, 5)),
        (disjoint_cycles((3, 4), (1, 5, 2)), flip(3, 4)),
    )
    chosen = ((0, 1, 4, 2, 3), 0)
    chosen_inverse = inverse_weyl(chosen)

    p5_generators = (
        permutation(5, ((1, 2), (3, 4))),
        permutation(5, ((0, 2, 1),)),
    )
    b_generators = (
        permutation(11, ((0, 1), (2, 4), (3, 5), (6, 7), (8, 9))),
        permutation(11, ((0, 5, 2), (1, 4, 3), (7, 8))),
    )

    # Pair every element of the TZ type-I3 Weyl group with its actions on the
    # auxiliary rank-five and permutation rank-eleven bases.
    identity_pair = (tuple(range(5)), tuple(range(11)))
    representation = {((ID5, 0)): identity_pair}
    queue = [(ID5, 0)]
    while queue:
        current = queue.pop(0)
        current_pair = representation[current]
        for generator, p5, bperm in zip(target_generators, p5_generators, b_generators):
            product = compose_weyl(current, generator)
            pair = (
                compose_permutation(current_pair[0], p5),
                compose_permutation(current_pair[1], bperm),
            )
            if product in representation:
                assert representation[product] == pair
            else:
                representation[product] = pair
                queue.append(product)
    assert len(representation) == 24

    def target_element(source):
        return compose_weyl(compose_weyl(chosen, source), chosen_inverse)

    source_to_pair = {
        generator: representation[target_element(generator)] for generator in source_generators
    }

    coordinate_actions = action_data["type_i1_generator_coordinate_actions"]
    field_actions = [
        sp.sympify(cocycle_data["mobius_actions"][name])
        for name in ("sigma", "tau", "iota")
    ]
    plane_generator_forms = [
        [sp.sympify(value) for value in cocycle_data["marked_plane_actions"][name]]
        for name in ("sigma", "tau", "iota")
    ]
    gauged_generator_scalars = [
        {label: sp.sympify(cocycle_data["gauged_coordinate_scalars"][name][label])
         for label in labels}
        for name in ("sigma", "tau", "iota")
    ]

    residual_gauges = [
        tuple(sp.sympify(value) for value in cocycle_data["residual_gauges"][name])
        for name in ("sigma", "tau", "iota")
    ]
    raw_generator_scalars = []
    for generator_index in range(3):
        inverse_action = {
            image: source for source, image in coordinate_actions[generator_index].items()
        }
        raw_generator_scalars.append({
            source: simplify(
                gauged_generator_scalars[generator_index][source]
                / residual_weight(inverse_action[source], residual_gauges[generator_index])
            )
            for source in labels
        })

    # Lift the ground surface point to the split Cox torsor by setting the five
    # exceptional coordinates to one.  The raw Cox maps carry the standard
    # generic lift to its conjugate exactly.
    projective_point = [sp.sympify(value) for value in cocycle_data["ground_point_marked_plane"]]
    affine_point = [simplify(projective_point[0] / projective_point[2]),
                    simplify(projective_point[1] / projective_point[2]), sp.Integer(1)]
    ground_lift = cox_forms(z, affine_point)
    assert all(value != 0 for value in ground_lift.values())
    generator_scalars = []
    for generator_index, (name, field_image) in enumerate(zip(
        ("sigma", "tau", "iota"), field_actions
    )):
        action = coordinate_actions[generator_index]
        inverse_action = {image: source for source, image in action.items()}
        normalized = {
            source: simplify(
                substitute(ground_lift[inverse_action[source]], field_image)
                / ground_lift[source]
            )
            for source in labels
        }
        twist = {
            source: simplify(normalized[source] / raw_generator_scalars[generator_index][source])
            for source in labels
        }
        twist_old = [None] * 6
        for index in range(1, 6):
            twist_old[index] = twist[f"E{index}"]
        twist_old[0] = simplify(twist["L12"] * twist_old[1] * twist_old[2])
        assert all(
            simplify(
                sp.prod(twist_old[index] ** classes[label][index] for index in range(6))
                / twist[label]
            ) == 1
            for label in labels
        )
        generator_scalars.append(normalized)

    def compose_elements(scalar_generators):
        identity_scalars = {label: sp.Integer(1) for label in labels}
        identity_action = {label: label for label in labels}
        result = {
            (ID5, 0): {
                "field": z,
                "scalars": identity_scalars,
                "action": identity_action,
                "pair": identity_pair,
                "word": [],
            }
        }
        queue = [(ID5, 0)]
        while queue:
            current_key = queue.pop(0)
            current = result[current_key]
            for generator_index, generator in enumerate(source_generators):
                product_key = compose_weyl(current_key, generator)
                generator_action = coordinate_actions[generator_index]
                product_field = substitute(field_actions[generator_index], current["field"])
                product_scalars = {
                    label: simplify(
                        substitute(scalar_generators[generator_index][generator_action[label]], current["field"])
                        * current["scalars"][generator_action[label]]
                    )
                    for label in labels
                }
                product_action = {
                    label: current["action"][generator_action[label]] for label in labels
                }
                generator_pair = source_to_pair[generator]
                product_pair = (
                    compose_permutation(current["pair"][0], generator_pair[0]),
                    compose_permutation(current["pair"][1], generator_pair[1]),
                )
                product = {
                    "field": product_field,
                    "scalars": product_scalars,
                    "action": product_action,
                    "pair": product_pair,
                    "word": current["word"] + [generator_index],
                }
                if product_key in result:
                    previous = result[product_key]
                    assert simplify(previous["field"] - product_field) == 0
                    assert previous["action"] == product_action
                    assert previous["pair"] == product_pair
                    for label in labels:
                        ratio = simplify(previous["scalars"][label] / product_scalars[label])
                        assert ratio == 1, (previous["word"], product["word"], label, ratio)
                else:
                    result[product_key] = product
                    queue.append(product_key)
        assert len(result) == 12
        return result

    elements = compose_elements(generator_scalars)
    # Rename the source marking by the chosen Weyl element.
    all_five = (1 << 5) - 1
    mask_to_label = {1 << index: f"E{index + 1}" for index in range(5)}
    for left in range(5):
        for right in range(left + 1, 5):
            mask_to_label[all_five ^ (1 << left) ^ (1 << right)] = f"L{left + 1}{right + 1}"
    mask_to_label[all_five] = "Q"
    label_to_mask = {label: mask for mask, label in mask_to_label.items()}

    def act_weyl(value, mask):
        return permute_mask(value[0], mask) ^ value[1]

    source_of_target = {
        target: mask_to_label[act_weyl(chosen_inverse, label_to_mask[target])]
        for target in labels
    }

    B_COLUMNS = (
        (2, 0, -1, -1, -1, -1, -1, 0, -1, -2, -1),
        (1, -1, 0, 0, 0, 0, -1, -1, 0, -1, -2),
        (2, -1, 0, -1, -1, -1, -1, -1, 0, -2, -1),
        (1, 0, -1, 0, 0, 0, 0, -1, -1, -1, -2),
        (1, 0, 0, 0, 0, -1, -1, 0, -1, -1, -2),
        (2, -1, -1, -1, -1, 0, 0, -1, -1, -2, -1),
        (-3, 1, 1, 2, 1, 1, 1, 1, 1, 3, 1),
        (-2, 1, 1, 0, 0, 1, 1, 1, 1, 1, 3),
        (-1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 3),
        (-3, 1, 1, 1, 2, 1, 1, 1, 1, 3, 1),
        (3, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2),
    )
    basis = sp.Matrix.hstack(*(sp.Matrix(column) for column in B_COLUMNS))
    assert basis.det() == -1
    basis_inverse = basis.inv()

    generic_section = cox_forms(z, (u, v, 1))
    generator_old_cocycles = []
    generator_b_cocycles = []
    generator_base_actions = []
    for generator_index, generator in enumerate(source_generators):
        homogeneous = [
            simplify(value.subs({U: u, V: v, W: 1}, simultaneous=True))
            for value in plane_generator_forms[generator_index]
        ]
        plane = (simplify(homogeneous[0] / homogeneous[2]),
                 simplify(homogeneous[1] / homogeneous[2]))
        transformed_section = cox_forms(field_actions[generator_index], (plane[0], plane[1], 1))
        action = coordinate_actions[generator_index]
        section_cocycle = {
            target: simplify(
                transformed_section[target]
                / (generator_scalars[generator_index][action[target]]
                   * generic_section[action[target]])
            )
            for target in labels
        }
        target_scalars = {
            label: section_cocycle[source_of_target[label]] for label in labels
        }
        old = [None] * 11
        for index in range(1, 6):
            old[index] = target_scalars[f"E{index}"]
        old[0] = simplify(target_scalars["L12"] * old[1] * old[2])
        old[6:] = [sp.Integer(1)] * 5

        def evaluate_class(vector):
            return simplify(sp.prod(old[index] ** vector[index] for index in range(6)))

        for label in labels:
            ratio = simplify(evaluate_class(classes[label]) / target_scalars[label])
            assert ratio == 1, (generator_index, label, ratio)
        assert all(
            simplify(value.subs({u: affine_point[0], v: affine_point[1]}, simultaneous=True)) == 1
            for value in old[:6]
        )
        b_cocycle = [
            simplify(sp.prod(old[row] ** basis[row, column] for row in range(11)))
            for column in range(11)
        ]
        generator_old_cocycles.append(old)
        generator_b_cocycles.append(b_cocycle)
        generator_base_actions.append((field_actions[generator_index], plane[0], plane[1]))

    names = ("1", "s", "s2", "t", "st", "s2t", "i", "si", "s2i", "ti", "sti", "s2ti")
    words = (
        (), (0,), (0, 0), (1,), (0, 1), (0, 0, 1),
        (2,), (0, 2), (0, 0, 2), (1, 2), (0, 1, 2), (0, 0, 1, 2),
    )
    key_by_name = {}
    for name, word in zip(names, words):
        key = (ID5, 0)
        for generator_index in word:
            key = compose_weyl(key, source_generators[generator_index])
        assert key not in key_by_name.values()
        key_by_name[name] = key
    assert set(key_by_name.values()) == set(elements)
    name_by_key = {key: name for name, key in key_by_name.items()}

    # Evaluate the straight-line cocycle at one exact point.  This is used only
    # to prove that the Hilbert--90 seed sums below are nonzero rational
    # functions; the formulas themselves remain symbolic SLPs.
    def evaluate(expression, point):
        value = sp.cancel(expression.subs({z: point[0], u: point[1], v: point[2]}, simultaneous=True))
        if value.has(sp.zoo, sp.nan) or value.is_finite is False:
            raise ZeroDivisionError
        return value

    def numeric_element(word, initial_point):
        point = initial_point
        values = [sp.Integer(1)] * 11
        permutation_value = tuple(range(11))
        for generator_index in word:
            generator_values = [evaluate(value, point)
                                for value in generator_b_cocycles[generator_index]]
            generator_permutation = source_to_pair[source_generators[generator_index]][1]
            values = [simplify(generator_values[index] * values[generator_permutation[index]])
                      for index in range(11)]
            action_values = [evaluate(value, point)
                             for value in generator_base_actions[generator_index]]
            point = (action_values[0], action_values[1], action_values[2])
            permutation_value = compose_permutation(permutation_value, generator_permutation)
        return point, values, permutation_value

    numeric_by_name = None
    seed_witness = None
    orbit_data = []
    remaining = set(range(11))
    while remaining:
        representative_index = min(remaining)
        orbit = {element["pair"][1][representative_index] for element in elements.values()}
        stabilizer_names = sorted(
            name_by_key[key] for key, element in elements.items()
            if element["pair"][1][representative_index] == representative_index
        )
        transporters = {
            str(target_index + 1): next(
                name_by_key[key] for key, element in elements.items()
                if element["pair"][1][representative_index] == target_index
            )
            for target_index in sorted(orbit)
        }
        orbit_data.append({
            "representative_b_index_1_based": representative_index + 1,
            "orbit_indices_1_based": [index + 1 for index in sorted(orbit)],
            "stabilizer_elements": stabilizer_names,
            "transporters": transporters,
            "seed_formula": "sum_{g in stabilizer} u_g[representative]",
            "transport_formula": "h_target = g(h_representative) * u_g[representative]",
        })
        remaining -= orbit

    for candidate in ((2, 5, 7), (5, 2, 11), (7, 13, 3), (11, 17, 19)):
        try:
            trial = {
                name: numeric_element(word, tuple(sp.Rational(value) for value in candidate))
                for name, word in zip(names, words)
            }
            sums = []
            for data in orbit_data:
                index = data["representative_b_index_1_based"] - 1
                total = sum((trial[name][1][index] for name in data["stabilizer_elements"]),
                            sp.Integer(0))
                if total == 0:
                    raise ZeroDivisionError
                sums.append(total)
            numeric_by_name = trial
            seed_witness = {"point_z_u_v": list(candidate), "nonzero_seed_values": [str(value) for value in sums]}
            break
        except (ZeroDivisionError, TypeError):
            continue
    assert numeric_by_name is not None

    generator_names = ("sigma", "tau", "iota")
    operation_profile = {
        "canonical_word_generator_steps": sum(len(word) for word in words),
        "generator_base_action_count_ops": [
            sum(int(sp.count_ops(value)) for value in values) for values in generator_base_actions
        ],
        "generator_picard_cocycle_count_ops": [
            sum(int(sp.count_ops(value)) for value in values[:6]) for values in generator_old_cocycles
        ],
        "generator_permutation_cocycle_count_ops": [
            sum(int(sp.count_ops(value)) for value in values) for values in generator_b_cocycles
        ],
        "hilbert90_seed_terms": sum(len(data["stabilizer_elements"]) for data in orbit_data),
        "hilbert90_seed_additions": sum(len(data["stabilizer_elements"]) - 1 for data in orbit_data),
        "nontrivial_orbit_transports": sum(len(data["orbit_indices_1_based"]) - 1 for data in orbit_data),
        "picard_pullback_nonzero_exponents": sum(
            basis_inverse[row, column] != 0 for row in range(11) for column in range(6)
        ),
        "picard_pullback_l1_exponent_sum": sum(
            abs(int(basis_inverse[row, column])) for row in range(11) for column in range(6)
        ),
        "picard_pullback_max_abs_exponent": max(
            abs(int(basis_inverse[row, column])) for row in range(11) for column in range(6)
        ),
        "interpretation": "syntactic replay profile, not an asymptotic complexity theorem",
    }
    return {
        "schema": "c958-type-i1-full-coboundary-slp-v1",
        "input_sha256": {"descent_action": ACTION_SHA256, "cox_descent": COCYCLE_SHA256},
        "group_order": len(elements),
        "permutation_basis_determinant": int(basis.det()),
        "generator_base_actions_z_u_v": {
            name: [str(value) for value in values]
            for name, values in zip(generator_names, generator_base_actions)
        },
        "generator_picard_cocycles_H_E1_E2_E3_E4_E5": {
            name: [str(value) for value in values[:6]]
            for name, values in zip(generator_names, generator_old_cocycles)
        },
        "generator_permutation_cocycles": {
            name: [str(value) for value in values]
            for name, values in zip(generator_names, generator_b_cocycles)
        },
        "canonical_group_words": {
            name: [generator_names[index] for index in word] for name, word in zip(names, words)
        },
        "cocycle_word_recursion": "u_(w g)[i] = w(u_g[i]) * u_w[g(i)], following each listed word from left to right",
        "permutation_actions_on_b_1_based": {
            name: [index + 1 for index in elements[key]["pair"][1]]
            for name, key in key_by_name.items()
        },
        "hilbert90_orbits": orbit_data,
        "nonvanishing_witness": seed_witness,
        "permutation_basis_columns": [list(column) for column in B_COLUMNS],
        "inverse_basis_rows": [[int(basis_inverse[row, column]) for column in range(11)]
                               for row in range(11)],
        "pullback_recipe": "h_old[j] = product_i h_b[i]^(B_inverse[i,j]); retain j=H,E1,...,E5",
        "operation_profile": operation_profile,
        "certified": [
            "the type-I1 generators are matched to the restricted TZ rank-eleven permutation basis",
            "ground-lift normalization makes the three Cox maps satisfy every defining group relation exactly",
            "comparison with the affine generic Cox section gives the displayed rank-six generator cocycle",
            "the rank-six generator values evaluate correctly on all sixteen Cox divisor classes",
            "the TZ unimodular basis turns this cocycle into the displayed permutation-coordinate SLP",
            "orbitwise multiplicative Hilbert 90 gives the displayed finite coboundary recipe",
            "the exact numerical witness proves every chosen Hilbert-90 seed is a nonzero rational function",
            "the unimodular inverse basis pulls the SLP back to a rank-six Picard-torus coboundary",
        ],
        "not_certified": [
            "fully expanded numerator and denominator polynomials for the coboundary",
            "the final forward and inverse maps for the stabilized cubic",
            "type-I3 formulas",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", type=Path)
    mode.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    payload = json.dumps(build(), indent=2, sort_keys=True) + "\n"
    if arguments.write:
        arguments.write.write_text(payload)
    else:
        assert arguments.check.read_text() == payload


if __name__ == "__main__":
    main()
