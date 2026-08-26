#!/usr/bin/env sage-python
"""Work-in-progress constructor for strict type-I3 Cox descent.

This source is checkpointed for continuation, but it has no accepted JSON
artifact yet.  Do not cite it as a certificate.  The current expensive gate is
documented in ``2026-08-25-c958-safe-checkpoint.md``.
"""

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import sys

from sage.all import PolynomialRing
from sage.misc.sage_eval import sage_eval

if sys.flags.optimize:
    raise RuntimeError("verification must run with Python assertions enabled")


ROOT = Path(__file__).resolve().parents[1]
SECTIONS_INPUT = ROOT / "notes/2026-08-25-c958-type-i3-exceptional-sections.json"
BLOWDOWN_INPUT = ROOT / "notes/2026-08-25-c958-type-i3-split-blowdown.json"
INVERSE_INPUT = ROOT / "notes/2026-08-25-c958-type-i3-normalized-split-inverse.json"
BLOWDOWN_SOURCE = ROOT / "notes/2026-08-25-c958-type-i3-split-blowdown.py"
INVERSE_SOURCE = ROOT / "notes/2026-08-25-c958-type-i3-split-inverse.py"


def progress(message):
    print(f"c958 type-I3 Cox descent: {message}", file=sys.stderr, flush=True)


def exact_polynomial_quotient(dividend, divisor):
    """Exact sparse long division over coefficient fields unsupported by Singular."""
    ring = dividend.parent()
    generators = ring.gens()
    divisor_terms = divisor.dict()
    assert divisor_terms
    divisor_exponents = max(divisor_terms)
    divisor_coefficient = divisor_terms[divisor_exponents]
    quotient = ring.zero()
    remainder = dividend
    while remainder:
        remainder_terms = remainder.dict()
        exponents = max(remainder_terms)
        if not all(left >= right for left, right in zip(exponents, divisor_exponents)):
            return None
        difference = tuple(left - right for left, right in zip(exponents, divisor_exponents))
        term = remainder_terms[exponents] / divisor_coefficient
        for generator, exponent in zip(generators, difference):
            term *= generator**exponent
        quotient += term
        remainder -= term * divisor
    if dividend != quotient * divisor:
        return None
    return quotient


def strip_known_common_factors(values, candidates):
    common = values[0].parent().one()
    changed = True
    while changed:
        changed = False
        for candidate in candidates:
            quotients = [exact_polynomial_quotient(value, candidate) for value in values]
            if all(quotient is not None for quotient in quotients):
                values = quotients
                common *= candidate
                changed = True
                break
    assert all(
        not all(exact_polynomial_quotient(value, candidate) is not None for value in values)
        for candidate in candidates
    )
    return values, common


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_blowdown_source():
    specification = importlib.util.spec_from_file_location("c958_i3_blowdown", BLOWDOWN_SOURCE)
    module = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(module)
    return module


def load_inverse_source():
    specification = importlib.util.spec_from_file_location("c958_i3_inverse", INVERSE_SOURCE)
    module = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(module)
    return module


def build_automorphisms(field, a, beta, r, d, g, delta, base_depth=5):
    a_field = field
    for _ in range(base_depth):
        a_field = a_field.base_field()
    base_identity = a_field.hom(a_field.gen())
    differences = (d, (-3 * r - d) / 2, (3 * r - d) / 2)
    vandermonde = differences[0] * differences[1] * differences[2]
    delta_squared = (-32 * g - 52) * a**4 - (24 * g + 36) * a * beta
    delta2 = 4 * a * vandermonde * delta / delta_squared

    def endomorphism(delta_image, d_image, r_image, g_image):
        return field.hom(
            [delta_image, d_image, r_image, g_image, beta],
            base_morphism=base_identity,
        )

    answer = {
        "sigma": endomorphism(delta, differences[1], (-r + d) / 2, g),
        "tau": endomorphism(delta, -d, r, g),
        "kappa": endomorphism(delta2, d, r, -g),
        "iota": endomorphism(-delta, d, r, g),
    }
    generators = (delta, d, r, g, beta, a)
    assert all(all(morphism(value).parent() is field for value in generators)
               for morphism in answer.values())
    return answer


def build(inverse_input=INVERSE_INPUT, allow_one_sided=False):
    sections_bytes = SECTIONS_INPUT.read_bytes()
    blowdown_bytes = BLOWDOWN_INPUT.read_bytes()
    inverse_bytes = inverse_input.read_bytes()
    sections = json.loads(sections_bytes)
    blowdown = json.loads(blowdown_bytes)
    inverse = json.loads(inverse_bytes)
    assert sections["schema"] == "c958-type-i3-exceptional-sections-v1"
    assert blowdown["schema"] == "c958-type-i3-split-blowdown-v1"
    assert blowdown["input_sha256"] == hashlib.sha256(sections_bytes).hexdigest()
    if inverse["schema"] == "c958-type-i3-normalized-split-inverse-one-sided-v1":
        assert allow_one_sided
    else:
        assert inverse["schema"] == "c958-type-i3-normalized-split-inverse-v1"
    assert inverse["input_sha256"] == {
        "blowdown": hashlib.sha256(blowdown_bytes).hexdigest(),
        "sections": hashlib.sha256(sections_bytes).hexdigest(),
        "blowdown_source": sha256(BLOWDOWN_SOURCE),
    }
    field, a, beta, r, d, g, delta = load_blowdown_source().build_field()
    progress("loaded the exact original degree-24 field and pinned inputs")

    def parse(value):
        return field(sage_eval(
            value,
            locals={"a": a, "beta": beta, "r": r, "d": d, "g": g,
                    "delta": delta},
        ))

    def parse_normalized(value):
        return field(sage_eval(
            value,
            locals={
                "a": field.one(), "beta": beta / a**3, "r": r / a,
                "d": d / a, "g": g, "delta": delta / a**2,
            },
        ))

    ambient = PolynomialRing(field, names=("Y1", "Y2", "Y3", "Y4"))
    y1, y2, y3, y4 = ambient.gens()
    plane = PolynomialRing(field, names=("Z1", "Z2", "Z3"))
    z1, z2, z3 = plane.gens()
    plane_fraction = plane.fraction_field()
    quadric_monomials = [
        y1**2, y1 * y2, y1 * y3, y1 * y4, y2**2,
        y2 * y3, y2 * y4, y3**2, y3 * y4, y4**2,
    ]
    plane_cubic_monomials = [
        z1**3, z1**2 * z2, z1**2 * z3, z1 * z2**2, z1 * z2 * z3,
        z1 * z3**2, z2**3, z2**2 * z3, z2 * z3**2, z3**3,
    ]
    quadrics = {
        coordinate: sum(
            (parse(value) * monomial for value, monomial in zip(
                blowdown["quadric_coefficients"][coordinate], quadric_monomials,
            )),
            ambient.zero(),
        )
        for coordinate in ("Z1", "Z2", "Z3")
    }
    normalized_quadric_vectors = {
        coordinate: [parse_normalized(value) for value in values]
        for coordinate, values in blowdown["quadric_coefficients"].items()
    }
    normalized_variables = (y1 / a, y2 / a, y3, y4 / a)
    normalized_quadric_monomials = [
        normalized_variables[0]**2,
        normalized_variables[0] * normalized_variables[1],
        normalized_variables[0] * normalized_variables[2],
        normalized_variables[0] * normalized_variables[3],
        normalized_variables[1]**2,
        normalized_variables[1] * normalized_variables[2],
        normalized_variables[1] * normalized_variables[3],
        normalized_variables[2]**2,
        normalized_variables[2] * normalized_variables[3],
        normalized_variables[3]**2,
    ]
    normalized_quadrics = {
        coordinate: sum(
            (value * monomial for value, monomial in zip(
                normalized_quadric_vectors[coordinate], normalized_quadric_monomials,
            )),
            ambient.zero(),
        )
        for coordinate in ("Z1", "Z2", "Z3")
    }
    plane_coordinate_scales = {}
    for coordinate in ("Z1", "Z2", "Z3"):
        pivot = next(
            monomial for monomial in quadric_monomials
            if normalized_quadrics[coordinate].monomial_coefficient(monomial)
        )
        plane_coordinate_scales[coordinate] = (
            quadrics[coordinate].monomial_coefficient(pivot)
            / normalized_quadrics[coordinate].monomial_coefficient(pivot)
        )
        assert quadrics[coordinate] == (
            plane_coordinate_scales[coordinate] * normalized_quadrics[coordinate]
        )
    automorphisms = build_automorphisms(field, a, beta, r, d, g, delta)

    normalized_field, n_beta, n_r, n_d, n_g, n_delta = (
        load_inverse_source().build_normalized_field()
    )
    n_a = normalized_field.one()

    def parse_in_normalized_field(value):
        return normalized_field(sage_eval(
            value,
            locals={
                "a": n_a, "beta": n_beta, "r": n_r, "d": n_d,
                "g": n_g, "delta": n_delta,
            },
        ))

    normalized_ambient = PolynomialRing(
        normalized_field, names=("NY1", "NY2", "NY3", "NY4"),
    )
    ny1, ny2, ny3, ny4 = normalized_ambient.gens()
    normalized_plane = PolynomialRing(normalized_field, names=("NZ1", "NZ2", "NZ3"))
    nz1, nz2, nz3 = normalized_plane.gens()
    n_quadric_monomials = [
        ny1**2, ny1 * ny2, ny1 * ny3, ny1 * ny4, ny2**2,
        ny2 * ny3, ny2 * ny4, ny3**2, ny3 * ny4, ny4**2,
    ]
    n_cubic_monomials = [
        nz1**3, nz1**2 * nz2, nz1**2 * nz3, nz1 * nz2**2, nz1 * nz2 * nz3,
        nz1 * nz3**2, nz2**3, nz2**2 * nz3, nz2 * nz3**2, nz3**3,
    ]
    n_quadrics = {
        coordinate: sum(
            (parse_in_normalized_field(value) * monomial
             for value, monomial in zip(
                 blowdown["quadric_coefficients"][coordinate], n_quadric_monomials,
             )),
            normalized_ambient.zero(),
        )
        for coordinate in ("Z1", "Z2", "Z3")
    }
    n_inverse_forms = [sum(
        (parse_in_normalized_field(value) * monomial
         for value, monomial in zip(vector, n_cubic_monomials)),
        normalized_plane.zero(),
    ) for vector in inverse["inverse_cubic_coefficients"]]
    n_inverse_hom = normalized_ambient.hom(n_inverse_forms, normalized_plane)
    n_alpha = parse_in_normalized_field(blowdown["split_quartic_moduli"]["a_split"])
    n_gamma = parse_in_normalized_field(blowdown["split_quartic_moduli"]["b_split"])
    normalized_exceptional_candidates = [
        nz3, nz2, nz2 - nz3, n_gamma * nz2 - n_alpha * nz3,
        nz1, nz1 - nz3, n_gamma * nz1 - nz3, nz1 - nz2,
        n_alpha * nz1 - nz2,
        ((n_gamma - n_alpha) * nz1 + (1 - n_gamma) * nz2
         + (n_alpha - 1) * nz3),
        (n_gamma * (1 - n_alpha) * nz1 * nz2
         + n_alpha * (n_gamma - 1) * nz1 * nz3
         + (n_alpha - n_gamma) * nz2 * nz3),
    ]
    n_automorphisms = build_automorphisms(
        normalized_field, n_a, n_beta, n_r, n_d, n_g, n_delta, base_depth=4,
    )
    normalized_generators = (n_delta, n_d, n_r, n_g, n_beta)
    original_normalized_generators = (delta / a**2, d / a, r / a, g, beta / a**3)
    for name in automorphisms:
        assert all(
            parse_normalized(
                str(n_automorphisms[name](normalized_value))
                .replace("^", "**").replace("c958g", "g")
                .replace("c958r", "r").replace("c958d", "d")
                .replace("c958e", "delta")
            ) == automorphisms[name](original_value)
            for normalized_value, original_value in zip(
                normalized_generators, original_normalized_generators,
            )
        )
    n_coefficient_maps = {
        name: normalized_ambient.hom(
            normalized_ambient.gens(), normalized_ambient, base_map=morphism,
        )
        for name, morphism in n_automorphisms.items()
    }

    def normalized_text(value):
        return (str(value).replace("^", "**").replace("c958g", "g")
                .replace("c958r", "r").replace("c958d", "d")
                .replace("c958e", "delta"))

    def lift_normalized_polynomial(value):
        return sum((
            parse_normalized(normalized_text(coefficient))
            * z1**exponents[0] * z2**exponents[1] * z3**exponents[2]
            for exponents, coefficient in value.dict().items()
        ), plane.zero())

    input_rescaling = plane.hom([
        z1 / plane_coordinate_scales["Z1"],
        z2 / plane_coordinate_scales["Z2"],
        z3 / plane_coordinate_scales["Z3"],
    ], plane)
    plane_actions = {}
    normalized_plane_actions = {}
    for name, coefficient_map in n_coefficient_maps.items():
        normalized_values = [n_inverse_hom(coefficient_map(n_quadrics[coordinate]))
                             for coordinate in ("Z1", "Z2", "Z3")]
        normalized_values, normalized_common = strip_known_common_factors(
            normalized_values, normalized_exceptional_candidates,
        )
        assert normalized_common
        normalized_plane_actions[name] = normalized_values
        values = [
            automorphisms[name](plane_coordinate_scales[coordinate])
            * input_rescaling(lift_normalized_polynomial(value))
            for coordinate, value in zip(("Z1", "Z2", "Z3"), normalized_values)
        ]
        assert all(value in plane for value in values)
        plane_actions[name] = [plane(value) for value in values]
        progress(f"computed the marked-plane action of {name}")

    alpha = parse(blowdown["split_quartic_moduli"]["a_split"])
    gamma = parse(blowdown["split_quartic_moduli"]["b_split"])

    def cox_forms(alpha_value, gamma_value, coordinates):
        x, y, w = coordinates
        answer = {f"E{index}": plane.one() for index in range(1, 6)}
        answer.update({
            "L12": w,
            "L13": y,
            "L14": y - w,
            "L15": gamma_value * y - alpha_value * w,
            "L23": x,
            "L24": x - w,
            "L25": gamma_value * x - w,
            "L34": x - y,
            "L35": alpha_value * x - y,
            "L45": ((gamma_value - alpha_value) * x
                     + (1 - gamma_value) * y + (alpha_value - 1) * w),
            "Q": (gamma_value * (1 - alpha_value) * x * y
                  + alpha_value * (gamma_value - 1) * x * w
                  + (alpha_value - gamma_value) * y * w),
        })
        return answer

    labels = [f"E{index}" for index in range(1, 6)]
    labels += [f"L{left}{right}" for left in range(1, 6) for right in range(left + 1, 6)]
    labels += ["Q"]
    source_forms = cox_forms(alpha, gamma, (z1, z2, z3))

    # Two explicit ground points away from the distinguished line.  They give
    # concrete candidates for the later tangent point and orbit-test point,
    # rather than appealing only to density of rational torsor points.
    cubic = (
        y3 * (a * y1**2 + 2 * a * y1 * y2 + (a**3 + beta) * y3**2)
        + y4 * (y1**2 + y1 * y2 + y2**2 - a**2 * y3**2 + y4**2)
    )

    def normalized_ground_surface_point(c):
        return [c - (1 + n_beta) / c, c, normalized_field.one(), -1]

    normalized_ground_surface_points = [
        normalized_ground_surface_point(normalized_field(c)) for c in (1, 2)
    ]
    normalized_ground_plane_points = [
        [n_quadrics[name](*point) for name in ("Z1", "Z2", "Z3")]
        for point in normalized_ground_surface_points
    ]
    assert all(any(point) for point in normalized_ground_plane_points)

    # Lift the normalized points without choosing a projective pivot.  Dividing
    # by such a pivot in the original nested function field triggers a costly
    # generic extended-gcd computation, while every assertion below is
    # homogeneous and therefore needs no normalization.
    ground_surface_points = [[
        a * parse_normalized(normalized_text(point[0])),
        a * parse_normalized(normalized_text(point[1])),
        parse_normalized(normalized_text(point[2])),
        a * parse_normalized(normalized_text(point[3])),
    ] for point in normalized_ground_surface_points]
    ground_plane_points = [[
        plane_coordinate_scales[name]
        * parse_normalized(normalized_text(value))
        for name, value in zip(("Z1", "Z2", "Z3"), point)
    ] for point in normalized_ground_plane_points]
    assert all(cubic(*point) == 0 for point in ground_surface_points)
    assert all(any(cubic.derivative(variable)(*point) != 0 for variable in ambient.gens())
               for point in ground_surface_points)
    assert any(ground_surface_points[0][left] * ground_surface_points[1][right]
               != ground_surface_points[0][right] * ground_surface_points[1][left]
               for left, right in ((0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)))
    assert all(all(cox_forms(alpha, gamma, point).values())
               for point in ground_plane_points)
    for name, morphism in n_automorphisms.items():
        for point in normalized_ground_plane_points:
            mapped = [value(*point) for value in normalized_plane_actions[name]]
            expected = [morphism(value) for value in point]
            assert all(mapped[left] * expected[right] == mapped[right] * expected[left]
                       for left, right in ((0, 1), (0, 2), (1, 2)))
    progress("certified the explicit pair of smooth ground surface points")

    raw_scalars = {}

    def constant_ratio(numerator, denominator):
        value = plane_fraction(numerator) / plane_fraction(denominator)
        top, bottom = value.numerator(), value.denominator()
        assert top.degree() == 0 and bottom.degree() == 0
        return field(top.constant_coefficient() / bottom.constant_coefficient())

    for name, action in sections["generator_actions"].items():
        morphism = automorphisms[name]
        target_forms = cox_forms(
            morphism(alpha), morphism(gamma), plane_actions[name],
        )
        raw_exceptional = {
            index: source_forms[action[f"E{index}"]] for index in range(1, 6)
        }
        scalars = {action[f"E{index}"]: field.one() for index in range(1, 6)}
        for left in range(1, 6):
            for right in range(left + 1, 6):
                target = f"L{left}{right}"
                source = action[target]
                scalars[source] = constant_ratio(
                    target_forms[target],
                    source_forms[source] * raw_exceptional[left] * raw_exceptional[right],
                )
        source = action["Q"]
        scalars[source] = constant_ratio(
            target_forms["Q"], source_forms[source]
            * raw_exceptional[1] * raw_exceptional[2] * raw_exceptional[3]
            * raw_exceptional[4] * raw_exceptional[5],
        )
        assert set(scalars) == set(labels)
        raw_scalars[name] = scalars
    progress("computed all raw Cox coordinate scalars")

    distinguished = [parse(value) for value in blowdown["distinguished_sixth_point"]]
    ground_plane = [value / distinguished[2] for value in distinguished]
    ground_lift_polys = cox_forms(alpha, gamma, ground_plane)
    ground_lift = {label: field(value) for label, value in ground_lift_polys.items()}
    assert all(ground_lift.values())

    strict_scalars = {}
    for name, action in sections["generator_actions"].items():
        morphism = automorphisms[name]
        inverse_action = {image: source for source, image in action.items()}
        strict_scalars[name] = {
            source: morphism(ground_lift[inverse_action[source]]) / ground_lift[source]
            for source in labels
        }
        mapped_point = [value(*ground_plane) for value in plane_actions[name]]
        expected_point = [morphism(value) for value in distinguished]
        assert all(mapped_point[0] * expected_point[index]
                   == mapped_point[index] * expected_point[0] for index in (1, 2))

    action_tuples = {
        name: tuple(action[label] for label in labels)
        for name, action in sections["generator_actions"].items()
    }

    def compose_permutation(left, right):
        return tuple(left[labels.index(right[index])] for index in range(len(labels)))

    identity = tuple(labels)
    field_generators = (delta, d, r, g, beta, a)
    elements = {
        identity: {
            "images": field_generators,
            "scalars": {label: field.one() for label in labels},
            "word": [],
        }
    }
    queue = [identity]
    generator_names = tuple(automorphisms)
    while queue:
        current_key = queue.pop(0)
        current = elements[current_key]

        def apply_current(value):
            # Simultaneous substitution through a field endomorphism reconstructed
            # from the stored images; the base parameter a is fixed.
            a_field = field
            for _ in range(5):
                a_field = a_field.base_field()
            morphism = field.hom(
                list(current["images"][:5]), base_morphism=a_field.hom(a_field.gen())
            )
            return morphism(value)

        for name in generator_names:
            generator_action = action_tuples[name]
            product_key = compose_permutation(current_key, generator_action)
            generator_map = automorphisms[name]
            product_images = tuple(apply_current(generator_map(value))
                                   for value in field_generators)
            product_scalars = {
                label: apply_current(strict_scalars[name][generator_action[labels.index(label)]])
                * current["scalars"][generator_action[labels.index(label)]]
                for label in labels
            }
            if product_key in elements:
                previous = elements[product_key]
                assert previous["images"] == product_images
                assert previous["scalars"] == product_scalars
            else:
                elements[product_key] = {
                    "images": product_images,
                    "scalars": product_scalars,
                    "word": current["word"] + [name],
                }
                queue.append(product_key)
    assert len(elements) == 24
    progress("certified the strict semilinear Cox action of order 24")

    def text(value):
        return (str(value).replace("^", "**").replace("c958g", "g")
                .replace("c958r", "r").replace("c958d", "d")
                .replace("c958e", "delta"))

    return {
        "schema": "c958-type-i3-cox-descent-v1",
        "input_sha256": {
            "exceptional_sections": hashlib.sha256(sections_bytes).hexdigest(),
            "split_blowdown": hashlib.sha256(blowdown_bytes).hexdigest(),
            "split_inverse": hashlib.sha256(inverse_bytes).hexdigest(),
            "split_blowdown_source": sha256(BLOWDOWN_SOURCE),
        },
        "upstream_inverse_schema": inverse["schema"],
        "normalized_plane_coordinate_scales": {
            name: text(value) for name, value in plane_coordinate_scales.items()
        },
        "generator_order": list(generator_names),
        "generator_actions": sections["generator_actions"],
        "generator_field_images_delta_d_r_g": {
            name: [text(automorphisms[name](value)) for value in (delta, d, r, g)]
            for name in generator_names
        },
        "marked_plane_actions": {
            name: [text(value) for value in plane_actions[name]] for name in generator_names
        },
        "raw_coordinate_scalars": {
            name: {label: text(value) for label, value in raw_scalars[name].items()}
            for name in generator_names
        },
        "ground_point_marked_plane": [text(value) for value in distinguished],
        "ground_surface_point_pair": [{
            "ambient": [text(value) for value in surface_point],
            "marked_plane": [text(value) for value in plane_point],
        } for surface_point, plane_point in zip(ground_surface_points, ground_plane_points)],
        "ground_lift": {label: text(value) for label, value in ground_lift.items()},
        "strict_coordinate_scalars": {
            name: {label: text(value) for label, value in strict_scalars[name].items()}
            for name in generator_names
        },
        "generated_group_order": len(elements),
        "canonical_group_words": sorted(
            (item["word"] for item in elements.values()), key=lambda word: (len(word), word)
        ),
        "certified": [
            "the four radical substitutions are endomorphisms of the degree-24 splitting field",
            "conjugating the split blowdown through its inverse gives the displayed marked-plane actions",
            "the marked-plane actions induce the certified odd-subset permutations on all Cox forms",
            "the distinguished-line contraction supplies a nonvanishing ground Cox lift",
            "two explicit distinct smooth off-line ground points give nonvanishing marked-plane Cox sections",
            "normalization at that lift gives a strict semilinear Cox descent action of order 24",
        ],
        "not_certified": [
            "the Hilbert-90 coboundary in the rank-eleven permutation basis",
            "ground tangent coordinates or their inverse",
            "the final stabilized cubic maps",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--inverse-input", type=Path, default=INVERSE_INPUT)
    parser.add_argument("--allow-one-sided-checkpoint", action="store_true")
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", type=Path)
    mode.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    output = arguments.write or arguments.check
    if arguments.allow_one_sided_checkpoint:
        assert ROOT not in output.resolve().parents
    payload = json.dumps(
        build(arguments.inverse_input, arguments.allow_one_sided_checkpoint),
        indent=2,
        sort_keys=True,
    ) + "\n"
    if arguments.write:
        arguments.write.write_text(payload)
    else:
        assert arguments.check.read_text() == payload


if __name__ == "__main__":
    main()
