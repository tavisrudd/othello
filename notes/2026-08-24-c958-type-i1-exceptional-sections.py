#!/usr/bin/env python3
"""Derive the sixteen exceptional sections of the type-I1 conic bundle."""

import argparse
import itertools
import json
from pathlib import Path

import sympy as sp


a, beta, r, d, v = sp.symbols("a beta r d v")
A, B, C, D = sp.symbols("A B C D")
s, t = sp.symbols("s t")

RELATIONS = [
    v**2 - 3 * a * (2 * a**3 - beta),
    d**2 + 3 * r**2 - 12 * a**2,
    r**3 - 3 * a**2 * r - beta,
]
DOMAIN = sp.QQ.frac_field(a, beta)
GROEBNER = sp.groebner(RELATIONS, v, d, r, order="lex", domain=DOMAIN)
assert [str(poly.LM(order=GROEBNER.order)) for poly in GROEBNER.polys] == [
    "v**2*d**0*r**0",
    "v**0*d**2*r**0",
    "v**0*d**0*r**3",
]


def remainder(expression):
    numerator = sp.fraction(sp.cancel(expression))[0]
    return sp.cancel(GROEBNER.reduce(sp.Poly(numerator, v, d, r, domain=DOMAIN))[1].as_expr())


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
    dummy_r, dummy_d, dummy_v = sp.symbols("dummy_r dummy_d dummy_v")
    staged = expression.xreplace({r: dummy_r, d: dummy_d, v: dummy_v})
    return sp.cancel(staged.xreplace({dummy_r: images[r], dummy_d: images[d], dummy_v: images[v]}))


def derive_sections():
    roots = [r, (-r + d) / 2, (-r - d) / 2]
    differences = [d, (-3 * r - d) / 2, (3 * r - d) / 2]
    u = -3 * (r**2 - a**2) * d
    e2 = v * u / (9 * (2 * a**3 - beta))
    assert equal(u**2, 27 * (2 * a**3 + beta) * (2 * a**3 - beta))
    assert equal(e2**2, a * (2 * a**3 + beta))
    standard_monomials = [
        r**ri * d**di * v**vi
        for vi in range(2)
        for di in range(2)
        for ri in range(3)
    ]
    fixed_vectors = []
    for element in (sp.Integer(1), u, v, u * v):
        normal = sp.Poly(remainder(element), v, d, r, domain=DOMAIN)
        fixed_vectors.append([normal.coeff_monomial(monomial) for monomial in standard_monomials])
    assert sp.Matrix(fixed_vectors).rank() == 4

    sections = {}
    signs_by_label = {}
    for signs in itertools.product((1, -1), repeat=5):
        equations = [
            (root - 2 * a) * (A + B * root)
            + sign * difference * (C + D * root)
            for root, difference, sign in zip(roots, differences, signs[:3])
        ]
        equations.append(6 * a * (C + 2 * a * D) + signs[3] * v)
        solutions = sp.solve(equations, (A, B, C, D), dict=True, simplify=False)
        assert len(solutions) == 1
        solution = {symbol: sp.cancel(solutions[0][symbol]) for symbol in (A, B, C, D)}
        assert all(remainder(equation.subs(solution)) == 0 for equation in equations)
        fifth = 2 * a * (solution[A] - 2 * a * solution[B]) + signs[4] * e2
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
            s * (beta * s**2 + 2 * a * (3 * y2**2 - y1**2))
            + t * (y1**2 + 3 * y2**2 + 3 * a**2 * s**2 - t**2)
        )
        polynomial = sp.Poly(sp.together(cubic), s, t)
        assert all(remainder(coefficient) == 0 for coefficient in polynomial.coeffs())

    assert len(sections) == 16
    expected = {f"E{index}" for index in range(1, 6)}
    expected |= {f"L{left}{right}" for left in range(1, 6) for right in range(left + 1, 6)}
    expected.add("Q")
    assert set(sections) == expected
    for left, right in itertools.combinations(sections, 2):
        assert any(not equal(sections[left][symbol], sections[right][symbol]) for symbol in (A, B, C, D))

    automorphisms = {
        "sigma": {
            "permutation": (2, 3, 1, 4, 5),
            "flipped": frozenset(),
            "images": {r: (-r + d) / 2, d: (-3 * r - d) / 2, v: v},
        },
        "tau": {
            "permutation": (1, 3, 2, 4, 5),
            "flipped": frozenset((1, 2, 3, 5)),
            "images": {r: r, d: -d, v: v},
        },
        "iota": {
            "permutation": (1, 2, 3, 4, 5),
            "flipped": frozenset((4, 5)),
            "images": {r: r, d: d, v: -v},
        },
    }
    action_table = {}
    for generator, data in automorphisms.items():
        table = {}
        for name, solution in sections.items():
            subset = frozenset(index + 1 for index, sign in enumerate(signs_by_label[name]) if sign == 1)
            image_name = label(permute_subset(subset, data["permutation"], data["flipped"]))
            image_solution = sections[image_name]
            for symbol in (A, B, C, D):
                transformed = apply_automorphism(solution[symbol], data["images"])
                assert equal(transformed, image_solution[symbol])
            table[name] = image_name
        action_table[generator] = table

    sigma = automorphisms["sigma"]["images"]
    tau = automorphisms["tau"]["images"]
    iota = automorphisms["iota"]["images"]
    for generator in (sigma, tau, iota):
        for relation in RELATIONS:
            assert remainder(apply_automorphism(relation, generator)) == 0
    sigma2 = {symbol: apply_automorphism(sigma[symbol], sigma) for symbol in (r, d, v)}
    sigma3 = {symbol: apply_automorphism(sigma2[symbol], sigma) for symbol in (r, d, v)}
    assert all(equal(sigma3[symbol], symbol) for symbol in (r, d, v))
    assert not equal(sigma[r], r)
    assert all(equal(apply_automorphism(tau[symbol], tau), symbol) for symbol in (r, d, v))
    assert all(equal(apply_automorphism(iota[symbol], iota), symbol) for symbol in (r, d, v))
    for symbol in (r, d, v):
        tau_sigma_tau = apply_automorphism(
            apply_automorphism(apply_automorphism(symbol, tau), sigma), tau
        )
        assert equal(tau_sigma_tau, sigma2[symbol])
        assert equal(
            apply_automorphism(apply_automorphism(symbol, sigma), iota),
            apply_automorphism(apply_automorphism(symbol, iota), sigma),
        )
        assert equal(
            apply_automorphism(apply_automorphism(symbol, tau), iota),
            apply_automorphism(apply_automorphism(symbol, iota), tau),
        )
    assert equal(apply_automorphism(u, sigma), u)
    assert equal(apply_automorphism(u, tau), -u)
    assert equal(apply_automorphism(u, iota), u)

    order = [f"E{index}" for index in range(1, 6)]
    order += [f"L{left}{right}" for left in range(1, 6) for right in range(left + 1, 6)]
    order += ["Q"]
    return {
        "schema": "c958-type-i1-exceptional-sections-v1",
        "base_field": "K=Q(a,beta)",
        "splitting_algebra": {
            "presentation": [str(relation) for relation in RELATIONS],
            "basis": [
                f"r^{ri}*d^{di}*v^{vi}"
                for vi in range(2)
                for di in range(2)
                for ri in range(3)
            ],
            "degree": 12,
            "u": canonical(u),
            "u_squared": "27*(2*a^3+beta)*(2*a^3-beta)",
            "e2": canonical(e2),
            "fixed_c3_subfield_basis": ["1", "u", "v", "u*v"],
        },
        "line_graph_convention": "Y1=A*Y3+B*Y4, Y2=C*Y3+D*Y4",
        "component_sign_convention": "a plus sign at i means the line meets F_i^+; valid choices are the odd subsets",
        "sections": {
            name: {
                "plus_subset": [index + 1 for index, sign in enumerate(signs_by_label[name]) if sign == 1],
                "coefficients": {str(symbol): canonical(sections[name][symbol]) for symbol in (A, B, C, D)},
            }
            for name in order
        },
        "generator_actions": action_table,
        "certified": [
            "the splitting algebra has the displayed C2 times S3 automorphisms",
            "the twelve displayed standard monomials form a basis of the splitting algebra",
            "u is C3-fixed and the displayed e2 has the required square",
            "exactly the sixteen odd component choices give distinct line sections",
            "every displayed section lies on the generic cubic surface",
            "the three Galois generators permute the sections by the odd-subset W(D5) action",
        ],
        "not_certified": [
            "pairwise incidence or the blowdown map to P2",
            "a scalar-normalized Cox embedding of the universal torsor",
            "a ground-field tangent section or quotient map",
            "maps for the cubic product",
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
