#!/usr/bin/env sage-python
"""Work-in-progress type-I3 Cox coboundary constructor.

This depends on the not-yet-produced type-I3 Cox-descent JSON.  It is a
continuation scaffold, not a certificate or a completed mathematical claim.
"""

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import sys

from sage.all import Matrix, PolynomialRing, QQ, prod
from sage.misc.sage_eval import sage_eval

if sys.flags.optimize:
    raise RuntimeError("verification must run with Python assertions enabled")


ROOT = Path(__file__).resolve().parents[1]
COX_INPUT = ROOT / "notes/2026-08-25-c958-type-i3-cox-descent.json"
BLOWDOWN_INPUT = ROOT / "notes/2026-08-25-c958-type-i3-split-blowdown.json"
BLOWDOWN_SOURCE = ROOT / "notes/2026-08-25-c958-type-i3-split-blowdown.py"
COX_SOURCE = ROOT / "notes/2026-08-25-c958-type-i3-cox-descent.py"
ID5 = tuple(range(5))


def load_module(path, name):
    specification = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(module)
    return module


def permute_mask(permutation_value, mask):
    result = 0
    for index in range(5):
        if mask & (1 << index):
            result |= 1 << permutation_value[index]
    return result


def compose_weyl(left, right):
    lp, lf = left
    rp, rf = right
    return tuple(lp[rp[index]] for index in range(5)), lf ^ permute_mask(lp, rf)


def inverse_weyl(value):
    permutation_value, flipped = value
    inverse = tuple(permutation_value.index(index) for index in range(5))
    return inverse, permute_mask(inverse, flipped)


def cycle(*indices):
    permutation_value = list(ID5)
    for left, right in zip(indices, indices[1:] + indices[:1]):
        permutation_value[left - 1] = right - 1
    return tuple(permutation_value)


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


def build():
    cox_bytes = COX_INPUT.read_bytes()
    blowdown_bytes = BLOWDOWN_INPUT.read_bytes()
    cox = json.loads(cox_bytes)
    blowdown = json.loads(blowdown_bytes)
    assert cox["schema"] == "c958-type-i3-cox-descent-v1"
    assert cox["upstream_inverse_schema"] == "c958-type-i3-normalized-split-inverse-v1"
    assert blowdown["schema"] == "c958-type-i3-split-blowdown-v1"
    assert cox["input_sha256"]["split_blowdown"] == hashlib.sha256(blowdown_bytes).hexdigest()
    assert cox["input_sha256"]["split_blowdown_source"] == hashlib.sha256(
        BLOWDOWN_SOURCE.read_bytes()
    ).hexdigest()
    blowdown_source = load_module(BLOWDOWN_SOURCE, "c958_i3_blowdown")
    cox_source = load_module(COX_SOURCE, "c958_i3_cox")
    field, a, beta, r, d, g, delta = blowdown_source.build_field()
    automorphisms = cox_source.build_automorphisms(field, a, beta, r, d, g, delta)

    def parse_field(value):
        return field(sage_eval(
            value,
            locals={"a": a, "beta": beta, "r": r, "d": d, "g": g,
                    "delta": delta},
        ))

    plane = PolynomialRing(field, names=("U", "V", "W"))
    U, V, W = plane.gens()
    affine = PolynomialRing(field, names=("u", "v"))
    u, v = affine.gens()
    affine_fraction = affine.fraction_field()

    def parse_plane(value):
        return plane(sage_eval(
            value,
            locals={"a": a, "beta": beta, "r": r, "d": d, "g": g,
                    "delta": delta, "Z1": U, "Z2": V, "Z3": W},
        ))

    alpha = parse_field(blowdown["split_quartic_moduli"]["a_split"])
    gamma = parse_field(blowdown["split_quartic_moduli"]["b_split"])

    def cox_forms(alpha_value, gamma_value, coordinates):
        x, y, w = coordinates
        one = affine_fraction.one()
        answer = {f"E{index}": one for index in range(1, 6)}
        answer.update({
            "L12": w, "L13": y, "L14": y - w,
            "L15": gamma_value * y - alpha_value * w,
            "L23": x, "L24": x - w, "L25": gamma_value * x - w,
            "L34": x - y, "L35": alpha_value * x - y,
            "L45": ((gamma_value - alpha_value) * x
                     + (1 - gamma_value) * y + (alpha_value - 1) * w),
            "Q": (gamma_value * (1 - alpha_value) * x * y
                  + alpha_value * (gamma_value - 1) * x * w
                  + (alpha_value - gamma_value) * y * w),
        })
        return {label: affine_fraction(value) for label, value in answer.items()}

    labels = [f"E{index}" for index in range(1, 6)]
    labels += [f"L{left}{right}" for left in range(1, 6) for right in range(left + 1, 6)]
    labels += ["Q"]
    classes = {}
    for label in labels:
        divisor = [0] * 6
        if label.startswith("E"):
            divisor[int(label[1])] = 1
        elif label.startswith("L"):
            divisor[0] = 1
            divisor[int(label[1])] = -1
            divisor[int(label[2])] = -1
        else:
            divisor[0] = 2
            for index in range(1, 6):
                divisor[index] = -1
        classes[label] = tuple(divisor)

    generator_names = tuple(cox["generator_order"])
    source_generators = {
        "sigma": (cycle(1, 2, 3), 0),
        "tau": (cycle(2, 3), flip(1, 2, 3, 5)),
        "kappa": (cycle(4, 5), 0),
        "iota": (ID5, flip(4, 5)),
    }
    target_generators = (
        (cycle(2, 5), flip(1, 2, 3, 5)),
        (disjoint_cycles((3, 4), (1, 5, 2)), flip(3, 4)),
    )
    p5_generators = (
        permutation(5, ((1, 2), (3, 4))),
        permutation(5, ((0, 2, 1),)),
    )
    b_generators = (
        permutation(11, ((0, 1), (2, 4), (3, 5), (6, 7), (8, 9))),
        permutation(11, ((0, 5, 2), (1, 4, 3), (7, 8))),
    )
    identity_pair = (tuple(range(5)), tuple(range(11)))
    representation = {(ID5, 0): identity_pair}
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
    chosen = ((0, 1, 4, 2, 3), 0)
    chosen_inverse = inverse_weyl(chosen)

    def target_element(source):
        return compose_weyl(compose_weyl(chosen, source), chosen_inverse)

    source_pairs = {
        name: representation[target_element(source_generators[name])]
        for name in generator_names
    }

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

    generic_section = cox_forms(alpha, gamma, (u, v, 1))
    strict_scalars = {
        name: {label: parse_field(cox["strict_coordinate_scalars"][name][label])
               for label in labels}
        for name in generator_names
    }
    plane_actions = {
        name: [parse_plane(value) for value in cox["marked_plane_actions"][name]]
        for name in generator_names
    }
    coordinate_actions = cox["generator_actions"]
    generator_picard_cocycles = {}
    generator_permutation_cocycles = {}
    generator_affine_actions = {}
    basis = Matrix(QQ, 11, 11, [value for column in B_COLUMNS for value in column]).transpose()
    assert basis.det() == -1
    basis_inverse = basis.inverse()

    for name in generator_names:
        morphism = automorphisms[name]
        homogeneous = [value(u, v, 1) for value in plane_actions[name]]
        plane_map = (affine_fraction(homogeneous[0] / homogeneous[2]),
                     affine_fraction(homogeneous[1] / homogeneous[2]))
        transformed = cox_forms(
            morphism(alpha), morphism(gamma), (plane_map[0], plane_map[1], 1),
        )
        action = coordinate_actions[name]
        section_cocycle = {
            target: transformed[target]
            / (strict_scalars[name][action[target]] * generic_section[action[target]])
            for target in labels
        }
        target_scalars = {
            label: section_cocycle[source_of_target[label]] for label in labels
        }
        old = [None] * 11
        for index in range(1, 6):
            old[index] = target_scalars[f"E{index}"]
        old[0] = target_scalars["L12"] * old[1] * old[2]
        old[6:] = [affine_fraction.one()] * 5
        for label in labels:
            value = affine_fraction.one()
            for index, exponent in enumerate(classes[label]):
                value *= old[index] ** exponent
            assert value == target_scalars[label]
        b_cocycle = [
            prod(old[row] ** basis[row, column] for row in range(11))
            for column in range(11)
        ]
        generator_picard_cocycles[name] = old[:6]
        generator_permutation_cocycles[name] = b_cocycle
        generator_affine_actions[name] = plane_map

    # Enumerate the source group together with its permutation-basis action.
    source_elements = {(ID5, 0): {"word": [], "pair": identity_pair}}
    queue = [(ID5, 0)]
    while queue:
        current = queue.pop(0)
        for name in generator_names:
            product = compose_weyl(current, source_generators[name])
            pair = (
                compose_permutation(source_elements[current]["pair"][0], source_pairs[name][0]),
                compose_permutation(source_elements[current]["pair"][1], source_pairs[name][1]),
            )
            if product in source_elements:
                assert source_elements[product]["pair"] == pair
            else:
                source_elements[product] = {
                    "word": source_elements[current]["word"] + [name], "pair": pair,
                }
                queue.append(product)
    assert len(source_elements) == 24

    orbit_data = []
    remaining = set(range(11))
    while remaining:
        representative = min(remaining)
        orbit = {item["pair"][1][representative] for item in source_elements.values()}
        stabilizers = [item["word"] for item in source_elements.values()
                       if item["pair"][1][representative] == representative]
        transports = {
            target: next(item["word"] for item in source_elements.values()
                         if item["pair"][1][representative] == target)
            for target in sorted(orbit)
        }
        orbit_data.append((representative, sorted(orbit), stabilizers, transports))
        remaining -= orbit

    field_generators = (delta, d, r, g, beta)
    a_field = field
    for _ in range(5):
        a_field = a_field.base_field()
    base_identity = a_field.hom(a_field.gen())

    def numerical_element(word, initial_u, initial_v):
        images = field_generators
        current_u, current_v = field(initial_u), field(initial_v)
        values = [field.one()] * 11
        current_permutation = tuple(range(11))
        for name in word:
            current_map = field.hom(list(images), base_morphism=base_identity)
            evaluator = affine_fraction.hom(
                [current_u, current_v], field, base_map=current_map,
            )
            generator_values = [evaluator(value) for value in generator_permutation_cocycles[name]]
            generator_permutation = source_pairs[name][1]
            values = [generator_values[index] * values[generator_permutation[index]]
                      for index in range(11)]
            next_u, next_v = (evaluator(value) for value in generator_affine_actions[name])
            generator_map = automorphisms[name]
            images = tuple(current_map(generator_map(value)) for value in field_generators)
            current_u, current_v = next_u, next_v
            current_permutation = compose_permutation(current_permutation, generator_permutation)
        return values, current_permutation

    witness = None
    for candidate in ((2, 3), (3, 5), (5, 7), (7, 11)):
        evaluated = {
            tuple(item["word"]): numerical_element(item["word"], *candidate)
            for item in source_elements.values()
        }
        sums = []
        for representative, _, stabilizers, _ in orbit_data:
            total = sum((evaluated[tuple(word)][0][representative] for word in stabilizers),
                        field.zero())
            if not total:
                break
            sums.append(total)
        if len(sums) == len(orbit_data):
            witness = {"u_v": list(candidate), "nonzero_seed_values": sums}
            break
    assert witness is not None

    def text(value):
        return (str(value).replace("^", "**").replace("c958g", "g")
                .replace("c958r", "r").replace("c958d", "d")
                .replace("c958e", "delta"))

    return {
        "schema": "c958-type-i3-full-coboundary-slp-v1",
        "input_sha256": {
            "cox_descent": hashlib.sha256(cox_bytes).hexdigest(),
            "split_blowdown": hashlib.sha256(blowdown_bytes).hexdigest(),
            "cox_descent_source": hashlib.sha256(COX_SOURCE.read_bytes()).hexdigest(),
        },
        "group_order": len(source_elements),
        "permutation_basis_determinant": int(basis.det()),
        "generator_affine_actions_u_v": {
            name: [text(value) for value in generator_affine_actions[name]]
            for name in generator_names
        },
        "generator_picard_cocycles_H_E1_E2_E3_E4_E5": {
            name: [text(value) for value in generator_picard_cocycles[name]]
            for name in generator_names
        },
        "generator_permutation_cocycles": {
            name: [text(value) for value in generator_permutation_cocycles[name]]
            for name in generator_names
        },
        "canonical_group_words": [item["word"] for item in source_elements.values()],
        "permutation_actions_on_b_1_based": [
            [index + 1 for index in item["pair"][1]] for item in source_elements.values()
        ],
        "hilbert90_orbits": [{
            "representative_b_index_1_based": representative + 1,
            "orbit_indices_1_based": [index + 1 for index in orbit],
            "stabilizer_words": stabilizers,
            "transporter_words": {str(index + 1): word for index, word in transports.items()},
            "seed_formula": "sum of u_g[representative] over the displayed stabilizer",
            "transport_formula": "h_target=g(h_representative)*u_g[representative]",
        } for representative, orbit, stabilizers, transports in orbit_data],
        "nonvanishing_witness": {
            "u_v": witness["u_v"],
            "nonzero_seed_values": [text(value) for value in witness["nonzero_seed_values"]],
        },
        "permutation_basis_columns": [list(column) for column in B_COLUMNS],
        "inverse_basis_rows": [[int(basis_inverse[row, column]) for column in range(11)]
                               for row in range(11)],
        "pullback_recipe": "h_old[j]=product_i h_b[i]^(B_inverse[i,j]); retain H,E1,...,E5",
        "certified": [
            "the four type-I3 generators are matched to the TZ rank-eleven permutation basis",
            "comparison with the generic Cox section gives the displayed rank-six cocycle",
            "the rank-six values agree on all sixteen Cox divisor classes",
            "the unimodular TZ basis turns the cocycle into permutation coordinates",
            "orbitwise multiplicative Hilbert 90 gives the displayed finite coboundary SLP",
            "the exact degree-24 field witness proves every selected seed is nonzero",
        ],
        "not_certified": [
            "fully expanded coboundary numerators and denominators",
            "ground tangent coordinates and their inverse",
            "the final stabilized cubic maps",
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
