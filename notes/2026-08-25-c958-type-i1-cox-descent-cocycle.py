#!/usr/bin/env python3
"""Certify the marked-plane action and residual type-I1 Cox descent datum."""

import argparse
import hashlib
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[1]
INPUTS = {
    "exceptional_sections": (
        ROOT / "notes/2026-08-24-c958-type-i1-exceptional-sections.json",
        "cb7ad6fbd78b44f692d28c057c6d591ffcca87e6f0973a50ad23d002c17fab24",
    ),
    "split_blowdown": (
        ROOT / "notes/2026-08-24-c958-type-i1-split-blowdown.json",
        "4e1d3dd013ea7fdf998d775386e905afb4be298b601b369fbe84347d44021fba",
    ),
    "split_inverse": (
        ROOT / "notes/2026-08-24-c958-type-i1-split-inverse.json",
        "1bf26a4d9793743fdb2c05ce0c4536977ebc403bab34b7afe8631d980ae3e497",
    ),
    "residual_torus": (
        ROOT / "notes/2026-08-25-c958-type-i1-residual-norm-torus.json",
        "da4037611943c566bfd9041d989bb444845ddd729032b62b54bd57685671b105",
    ),
}

z, U, V, W, a = sp.symbols("z U V W a")
Y1, Y2, Y3, Y4 = sp.symbols("Y1 Y2 Y3 Y4")
Z1, Z2, Z3 = sp.symbols("Z1 Z2 Z3")


def canonical(expression):
    return sp.factor(sp.cancel(expression))


def A(argument):
    return canonical(
        (argument - 1)
        * (argument + 3)
        * (argument**2 - 3)
        / (2 * argument * (argument**2 - 6 * argument - 3))
    )


def B(argument):
    return canonical(
        -(argument - 3)
        * (argument + 1)
        * (argument**2 - 3)
        / (2 * argument * (argument**2 + 6 * argument - 3))
    )


def cox_forms(argument, coordinates):
    x, y, zz = coordinates
    aa, bb = A(argument) ** 2, B(argument) ** 2
    result = {f"E{index}": sp.Integer(1) for index in range(1, 6)}
    result.update(
        {
            "L12": zz,
            "L13": y,
            "L14": y - zz,
            "L15": bb * y - aa * zz,
            "L23": x,
            "L24": x - zz,
            "L25": bb * x - zz,
            "L34": x - y,
            "L35": aa * x - y,
            "L45": (bb - aa) * x + (1 - bb) * y + (aa - 1) * zz,
            "Q": bb * (1 - aa) * x * y
            + aa * (bb - 1) * x * zz
            + (aa - bb) * y * zz,
        }
    )
    return result


def residual_weight(label, point):
    first, second = point
    if label == "E1":
        return first
    if label == "E2":
        return second
    if label.startswith("E"):
        return sp.Integer(1)
    if label.startswith("L"):
        answer = sp.Integer(1)
        if "1" in label[1:]:
            answer /= first
        if "2" in label[1:]:
            answer /= second
        return canonical(answer)
    assert label == "Q"
    return canonical(1 / (first * second))


def build():
    loaded = {}
    for name, (path, expected_hash) in INPUTS.items():
        raw = path.read_bytes()
        assert hashlib.sha256(raw).hexdigest() == expected_hash
        loaded[name] = json.loads(raw)

    generator_actions = loaded["exceptional_sections"]["generator_actions"]
    residual_actions = loaded["residual_torus"]["residual_cocharacter_actions"]
    assert residual_actions == [[[0, -1], [1, -1]], [[-1, 1], [0, 1]], [[1, 0], [0, 1]]]

    alpha, gamma = A(z) ** 2, B(z) ** 2
    z_images = {"sigma": -(z + 3) / (z - 1), "tau": 3 / z, "iota": -3 / z}
    tau_alpha, tau_gamma = A(z_images["tau"]) ** 2, B(z_images["tau"]) ** 2
    tau_monomials = (
        (gamma * V - alpha * W) * (U - V) * (U - W),
        (alpha * U - V) * (V - W) * (U - W),
        (gamma * U - W) * (V - W) * (U - V),
    )
    plane_actions = {
        "sigma": (V, W, U),
        "tau": (
            tau_monomials[0],
            tau_alpha * tau_monomials[1],
            tau_gamma * tau_monomials[2],
        ),
        "iota": (V * W, alpha * U * W, gamma * U * V),
    }

    # Bind the plane actions to the independently certified split forward and inverse maps.
    inverse_forms = [
        sp.sympify(value, locals=globals()).subs(
            {Z1: U, Z2: V, Z3: W}, simultaneous=True
        )
        for value in loaded["split_inverse"]["inverse_cubic_forms"]
    ]
    blowdown = loaded["split_blowdown"]
    quadric_monomials = [sp.sympify(value, locals=globals()) for value in blowdown["quadric_monomial_order"]]
    blowdown_forms = []
    for coordinate in ("Z1", "Z2", "Z3"):
        coefficients = [
            sp.sympify(value, locals=globals())
            for value in blowdown["quadric_coefficients"][coordinate]
        ]
        blowdown_forms.append(sum(value * monomial for value, monomial in zip(coefficients, quadric_monomials)))
    inverse_substitution = dict(zip((Y1, Y2, Y3, Y4), inverse_forms))
    for generator in ("sigma", "tau", "iota"):
        conjugate_blowdown = [
            sp.together(
                form.subs(z, z_images[generator], simultaneous=True).subs(
                    inverse_substitution, simultaneous=True
                )
            )
            for form in blowdown_forms
        ]
        candidate = plane_actions[generator]
        assert all(
            canonical(conjugate_blowdown[left] * candidate[right] - conjugate_blowdown[right] * candidate[left])
            == 0
            for left, right in ((0, 1), (0, 2))
        )

    source_forms = cox_forms(z, (U, V, W))
    coordinate_scalars = {}
    for generator, action in generator_actions.items():
        target_forms = cox_forms(z_images[generator], plane_actions[generator])
        raw_exceptional = {
            index: source_forms[action[f"E{index}"]] for index in range(1, 6)
        }
        scalars = {action[f"E{index}"]: sp.Integer(1) for index in range(1, 6)}
        for left in range(1, 6):
            for right in range(left + 1, 6):
                target = f"L{left}{right}"
                source = action[target]
                scalars[source] = canonical(
                    target_forms[target]
                    / (source_forms[source] * raw_exceptional[left] * raw_exceptional[right])
                )
        source = action["Q"]
        scalars[source] = canonical(
            target_forms["Q"] / (source_forms[source] * sp.prod(raw_exceptional.values()))
        )
        assert set(scalars) == set(source_forms)
        assert all(not value.has(U, V, W) for value in scalars.values())
        coordinate_scalars[generator] = scalars

    base_substitution = {Y1: 1, Y2: 0, Y3: 0, Y4: 1}
    raw_base_point = [canonical(form.subs(base_substitution)) for form in blowdown_forms]
    base_scale = next(value for value in raw_base_point if value != 0)
    base_point = tuple(canonical(value / base_scale) for value in raw_base_point)
    expected_base_point = (
        sp.Integer(1),
        canonical(-(z - 1) ** 2 * (z**2 - 3) / (2 * (z**2 - 6 * z - 3))),
        canonical(-(z + 1) ** 2 * (z**2 - 3) / (2 * (z**2 + 6 * z - 3))),
    )
    assert base_point == expected_base_point
    base_affine = (canonical(base_point[0] / base_point[2]), canonical(base_point[1] / base_point[2]))
    residual_gauges = {
        "sigma": (sp.Integer(1), sp.Integer(1)),
        "tau": (
            canonical((base_affine[0] - 1) / (base_affine[1] - 1)),
            canonical((base_affine[0] - 1) / (base_affine[0] - base_affine[1])),
        ),
        "iota": (canonical(1 / base_affine[0]), canonical(1 / base_affine[1])),
    }

    gauged_scalars = {}
    residual_cocycles = {}
    for generator, action in generator_actions.items():
        inverse_action = {image: source for source, image in action.items()}
        gauged_scalars[generator] = {
            source: canonical(
                coordinate_scalars[generator][source]
                * residual_weight(inverse_action[source], residual_gauges[generator])
            )
            for source in source_forms
        }
        raw_exceptional = {index: source_forms[action[f"E{index}"]] for index in range(1, 6)}
        residual_cocycles[generator] = (
            canonical(residual_gauges[generator][0] * raw_exceptional[1] / raw_exceptional[3]),
            canonical(residual_gauges[generator][1] * raw_exceptional[2] / raw_exceptional[3]),
        )
        affine_base_substitution = {U: base_affine[0], V: base_affine[1], W: 1}
        assert all(
            canonical(value.subs(affine_base_substitution) - 1) == 0
            for value in residual_cocycles[generator]
        )

    relations = [
        (["sigma", "sigma", "sigma"], []),
        (["tau", "tau"], []),
        (["iota", "iota"], []),
        (["tau", "sigma", "tau"], ["sigma", "sigma"]),
        (["iota", "sigma"], ["sigma", "iota"]),
        (["iota", "tau"], ["tau", "iota"]),
    ]

    def compose_coordinate_maps(word):
        labels = list(source_forms)
        permutation = {label: label for label in labels}
        scalars = {label: sp.Integer(1) for label in labels}
        current_z = z
        for generator in word:
            action = generator_actions[generator]
            new_permutation = {}
            new_scalars = {}
            for target in labels:
                intermediate = action[target]
                new_permutation[target] = permutation[intermediate]
                new_scalars[target] = canonical(
                    gauged_scalars[generator][intermediate].subs(z, current_z, simultaneous=True)
                    * scalars[intermediate]
                )
            permutation, scalars = new_permutation, new_scalars
            current_z = canonical(z_images[generator].subs(z, current_z, simultaneous=True))
        return current_z, permutation, scalars

    relation_defects = {}
    for left, right in relations:
        left_z, left_permutation, left_scalars = compose_coordinate_maps(left)
        right_z, right_permutation, right_scalars = compose_coordinate_maps(right)
        assert canonical(left_z - right_z) == 0
        assert left_permutation == right_permutation
        defect = {
            label: canonical(left_scalars[label] / right_scalars[label]) for label in source_forms
        }
        residual_defect = (
            canonical(defect["E1"] / defect["E3"]),
            canonical(defect["E2"] / defect["E3"]),
        )
        assert residual_defect == (1, 1)
        relation_defects[" ".join(left) + " = " + " ".join(right or ["1"])] = ["1", "1"]

    def string_dict(values):
        return {key: str(canonical(value)) for key, value in values.items()}

    return {
        "schema": "c958-type-i1-cox-descent-cocycle-v1",
        "input_sha256": {name: expected for name, (_, expected) in INPUTS.items()},
        "pulled_back_residual_characters": ["E1-E3", "E2-E3"],
        "mobius_actions": {name: str(canonical(value)) for name, value in z_images.items()},
        "marked_plane_actions": {
            name: [str(canonical(value)) for value in plane_actions[name]] for name in plane_actions
        },
        "ground_surface_point": "[Y1:Y2:Y3:Y4]=[1:0:0:1]",
        "ground_point_marked_plane": [str(value) for value in base_point],
        "residual_gauges": {
            name: [str(value) for value in residual_gauges[name]] for name in residual_gauges
        },
        "residual_cocycles": {
            name: [str(value) for value in residual_cocycles[name]] for name in residual_cocycles
        },
        "gauged_coordinate_scalars": {
            name: string_dict(gauged_scalars[name]) for name in gauged_scalars
        },
        "relation_residual_defects": relation_defects,
        "formula_sizes": {
            "plane_actions_total": sum(len(str(value)) for values in plane_actions.values() for value in values),
            "coordinate_scalars_total": sum(
                len(str(value)) for values in gauged_scalars.values() for value in values.values()
            ),
            "residual_cocycles_total": sum(
                len(str(value)) for values in residual_cocycles.values() for value in values
            ),
        },
        "certified": [
            "the three marked-plane actions equal q_{g(z)} composed with the split inverse F_z",
            "the Cox coordinate relabeling scalars depend only on the splitting parameter",
            "the residual quotient characters in the source marking are E1-E3 and E2-E3",
            "normalization at the displayed ground point fixes its quotient Cox lift",
            "every defining relation of C2 times S3 has trivial residual defect after normalization",
            "the displayed residual cocycle is a strict descent datum on the T3 quotient",
        ],
        "not_certified": [
            "a generic coboundary trivializing the displayed residual cocycle",
            "the product map from the surface and norm-one torus to the quotient",
            "the final stabilized maps for the cubic family",
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
