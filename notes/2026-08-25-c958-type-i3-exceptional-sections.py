#!/usr/bin/env python3
"""Derive the sixteen exceptional sections of the type-I3 cubic fibre."""

import argparse
import itertools
import json
from pathlib import Path

import sympy as sp


a, beta, r, d, g, delta = sp.symbols("a beta r d g delta")
A, B, C, D = sp.symbols("A B C D")
s, t = sp.symbols("s t")
delta_squared = (-32 * g - 52) * a**4 - (24 * g + 36) * a * beta
RELATIONS = [
    delta**2 - delta_squared,
    g**2 - 3,
    d**2 + 3 * r**2 - 4 * a**2,
    r**3 - a**2 * r + a**3 + beta,
]
DOMAIN = sp.QQ.frac_field(a, beta)
GROEBNER = sp.groebner(RELATIONS, delta, g, d, r, order="lex", domain=DOMAIN)
assert [str(poly.LM(order=GROEBNER.order)) for poly in GROEBNER.polys] == [
    "delta**2*g**0*d**0*r**0",
    "delta**0*g**2*d**0*r**0",
    "delta**0*g**0*d**2*r**0",
    "delta**0*g**0*d**0*r**3",
]


def remainder(expression):
    numerator = sp.fraction(sp.cancel(expression))[0]
    return sp.cancel(
        GROEBNER.reduce(sp.Poly(numerator, delta, g, d, r, domain=DOMAIN))[1].as_expr()
    )


def equal(left, right):
    return remainder(left - right) == 0


def canonical(expression):
    return str(sp.factor(sp.cancel(expression)))


def label(subset):
    subset = frozenset(subset)
    if len(subset) == 1:
        return f"E{next(iter(subset))}"
    if len(subset) == 3:
        complement = sorted(set(range(1, 6)) - subset)
        return f"L{complement[0]}{complement[1]}"
    if len(subset) == 5:
        return "Q"
    raise ValueError(subset)


def permute_subset(subset, permutation, flipped):
    image = {permutation[index - 1] for index in subset}
    return frozenset(image.symmetric_difference(flipped))


def apply_automorphism(expression, images):
    dummy = sp.symbols("dummy_r dummy_d dummy_g dummy_delta")
    staged = expression.xreplace(dict(zip((r, d, g, delta), dummy)))
    return sp.cancel(staged.xreplace(dict(zip(dummy, (images[r], images[d], images[g], images[delta])))))


def derive_sections():
    roots = [r, (-r + d) / 2, (-r - d) / 2]
    differences = [d, (-3 * r - d) / 2, (3 * r - d) / 2]
    vandermonde = sp.factor(sp.prod(differences))
    discriminant = -23 * a**6 - 54 * a**3 * beta - 27 * beta**2
    assert equal(vandermonde**2, discriminant)
    root4 = 2 * a * g / 3
    root5 = -root4
    delta2 = sp.cancel(4 * a * vandermonde * delta / delta_squared)
    expected_delta2_squared = (32 * g - 52) * a**4 + (24 * g - 36) * a * beta
    assert equal(delta2**2, expected_delta2_squared)

    sections = {}
    signs_by_label = {}
    for signs in itertools.product((1, -1), repeat=5):
        equations = [
            2 * (root + a) * (A + B * root)
            + (root + 2 * a + sign * difference) * (C + D * root)
            for root, difference, sign in zip(roots, differences, signs[:3])
        ]
        equations.append(
            2 * a * (3 + 2 * g) * (A + B * root4)
            + a * (6 + 2 * g) * (C + D * root4) + signs[3] * delta
        )
        solution_set = sp.solve(equations, (A, B, C, D), dict=True, simplify=False)
        assert len(solution_set) == 1
        solution = {symbol: sp.cancel(solution_set[0][symbol]) for symbol in (A, B, C, D)}
        assert all(remainder(equation.subs(solution)) == 0 for equation in equations)
        fifth = (
            2 * a * (3 - 2 * g) * (solution[A] + solution[B] * root5)
            + a * (6 - 2 * g) * (solution[C] + solution[D] * root5)
            + signs[4] * delta2
        )
        if remainder(fifth) != 0:
            continue
        plus_subset = frozenset(index + 1 for index, sign in enumerate(signs) if sign == 1)
        assert len(plus_subset) % 2 == 1
        name = label(plus_subset)
        assert name not in sections
        sections[name] = solution
        signs_by_label[name] = signs

        y1 = solution[A] * s + solution[B] * t
        y2 = solution[C] * s + solution[D] * t
        cubic = (
            s * (a * y1**2 + 2 * a * y1 * y2 + (a**3 + beta) * s**2)
            + t * (y1**2 + y1 * y2 + y2**2 - a**2 * s**2 + t**2)
        )
        for coefficient in sp.Poly(sp.together(cubic), s, t).coeffs():
            assert remainder(coefficient) == 0

    expected = {f"E{index}" for index in range(1, 6)}
    expected |= {f"L{left}{right}" for left in range(1, 6) for right in range(left + 1, 6)}
    expected.add("Q")
    assert set(sections) == expected

    automorphisms = {
        "sigma": {
            "permutation": (2, 3, 1, 4, 5), "flipped": frozenset(),
            "images": {r: roots[1], d: differences[1], g: g, delta: delta},
        },
        "tau": {
            "permutation": (1, 3, 2, 4, 5), "flipped": frozenset((1, 2, 3, 5)),
            "images": {r: r, d: -d, g: g, delta: delta},
        },
        "kappa": {
            "permutation": (1, 2, 3, 5, 4), "flipped": frozenset(),
            "images": {r: r, d: d, g: -g, delta: delta2},
        },
        "iota": {
            "permutation": (1, 2, 3, 4, 5), "flipped": frozenset((4, 5)),
            "images": {r: r, d: d, g: g, delta: -delta},
        },
    }
    action_table = {}
    for generator, data in automorphisms.items():
        table = {}
        for name, solution in sections.items():
            subset = frozenset(
                index + 1 for index, sign in enumerate(signs_by_label[name]) if sign == 1
            )
            image_name = label(permute_subset(subset, data["permutation"], data["flipped"]))
            for symbol in (A, B, C, D):
                assert equal(
                    apply_automorphism(solution[symbol], data["images"]),
                    sections[image_name][symbol],
                )
            table[name] = image_name
        action_table[generator] = table
        for relation in RELATIONS:
            assert remainder(apply_automorphism(relation, data["images"])) == 0

    order = [f"E{index}" for index in range(1, 6)]
    order += [f"L{left}{right}" for left in range(1, 6) for right in range(left + 1, 6)]
    order += ["Q"]
    identity = tuple(order)
    generator_permutations = [tuple(table[name] for name in order)
                              for table in action_table.values()]
    permutation_group = {identity}
    queue = [identity]
    while queue:
        current = queue.pop()
        for generator in generator_permutations:
            product = tuple(generator[order.index(current[index])] for index in range(16))
            if product not in permutation_group:
                permutation_group.add(product)
                queue.append(product)
    assert len(permutation_group) == 24
    return {
        "schema": "c958-type-i3-exceptional-sections-v1",
        "base_field": "K=Q(a,beta)",
        "splitting_algebra": {
            "presentation": [str(relation) for relation in RELATIONS],
            "degree": 24,
            "vandermonde": canonical(vandermonde),
            "delta2": canonical(delta2),
        },
        "line_graph_convention": "Y1=A*Y3+B*Y4, Y2=C*Y3+D*Y4",
        "sections": {
            name: {
                "plus_subset": [
                    index + 1 for index, sign in enumerate(signs_by_label[name]) if sign == 1
                ],
                "coefficients": {
                    str(symbol): canonical(sections[name][symbol])
                    for symbol in (A, B, C, D)
                },
            }
            for name in order
        },
        "generator_actions": action_table,
        "generated_permutation_group_order": len(permutation_group),
        "certified": [
            "the degree-24 splitting algebra has the displayed type-I3 automorphisms",
            "exactly the sixteen odd component choices give line sections",
            "every displayed section lies on the generic cubic surface",
            "the four generators act by the stated type-I3 odd-subset permutations",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", type=Path)
    mode.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    payload = json.dumps(derive_sections(), indent=2, sort_keys=True) + "\n"
    if arguments.write:
        arguments.write.write_text(payload)
    else:
        assert arguments.check.read_text() == payload


if __name__ == "__main__":
    main()
