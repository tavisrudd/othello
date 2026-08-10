#!/usr/bin/env python3
"""Derive the elliptic-factor j-map of the integral A5 cubic pencil.

Replay under Nix:
  nix-shell -p 'python3.withPackages (ps: [ ps.sympy ])' --run \
    'python notes/2026-08-10-c904-a5-pencil-j-map.py'

The computation Fourier-diagonalizes a D5 subgroup, normalizes the resulting
cubic to van Geemen--Yamauchi's standard form, and substitutes their printed
formula for the elliptic Prym factor.  All arithmetic is exact.
"""

import importlib.util
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
BOUNDARY_SCRIPT = HERE / "2026-08-10-c904-a5-pencil-boundary.py"


def load_boundary_module():
    spec = importlib.util.spec_from_file_location("a5_boundary", BOUNDARY_SCRIPT)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def cyclotomic_reduce(expression, zeta):
    numerator, denominator = sp.fraction(sp.cancel(expression))
    modulus = zeta**4 + zeta**3 + zeta**2 + zeta + 1
    reduced = sp.rem(sp.Poly(numerator, zeta), sp.Poly(modulus, zeta)).as_expr()
    return sp.cancel(reduced / denominator)


def multiply_forms(forms):
    polynomial = {(0, 0, 0, 0, 0): sp.Integer(1)}
    for form in forms:
        product = {}
        for exponents, coefficient in polynomial.items():
            for index, scalar in enumerate(form):
                target = list(exponents)
                target[index] += 1
                target = tuple(target)
                product[target] = product.get(target, 0) + coefficient * scalar
        polynomial = product
    return polynomial


def add_polynomial(target, source, scalar=1):
    for exponents, coefficient in source.items():
        target[exponents] = target.get(exponents, 0) + scalar * coefficient


def main():
    boundary = load_boundary_module()
    zeta, t = sp.symbols("zeta t")
    finite_coordinates = [
        tuple(zeta ** ((frequency * index) % 5) / 5 for frequency in range(5))
        for index in range(5)
    ]
    coordinates = finite_coordinates + [(-1, 0, 0, 0, 0)]
    power_poly = {}
    for coordinate in coordinates:
        add_polynomial(power_poly, multiply_forms((coordinate,) * 3))
    orbit_poly = {}
    for sign, triples in (
        (1, boundary.TRIPLES_PLUS),
        (-1, boundary.TRIPLES_MINUS),
    ):
        for i, j, k in triples:
            add_polynomial(
                orbit_poly,
                multiply_forms((coordinates[i], coordinates[j], coordinates[k])),
                sign,
            )

    def coefficient(exponents):
        monomial = tuple(exponents)
        left = cyclotomic_reduce(power_poly.get(monomial, 0), zeta)
        right = cyclotomic_reduce(orbit_poly.get(monomial, 0), zeta)
        return sp.factor(left), sp.factor(right)

    monomials = {
        "y3": (3, 0, 0, 0, 0),
        "xyz": (1, 1, 0, 0, 1),
        "xu2": (0, 1, 2, 0, 0),
        "yuv": (1, 0, 1, 1, 0),
        "zv2": (0, 0, 0, 2, 1),
        "z2u": (0, 0, 1, 0, 2),
        "x2v": (0, 2, 0, 1, 0),
    }
    pairs = {name: coefficient(exponents) for name, exponents in monomials.items()}
    for name, pair in pairs.items():
        print(f"{name}: P={pair[0]}, Q={pair[1]}")

    raw = {name: sp.factor(left + t * right) for name, (left, right) in pairs.items()}
    assert sp.simplify(raw["xu2"] - raw["zv2"]) == 0
    assert sp.simplify(raw["z2u"] - raw["x2v"]) == 0
    A, B, D = raw["xu2"], raw["yuv"], raw["z2u"]
    F, G = raw["y3"], raw["xyz"]
    r = sp.cancel(2 * A / D)
    w = sp.cancel(4 * A**2 / (B * D))
    scale = sp.cancel(2 * A**2 / D)
    a = sp.factor(sp.cancel(F * w**3 / scale))
    b = sp.factor(sp.cancel(G * w * r**2 / scale))
    print(f"van Geemen--Yamauchi a(t): {a}")
    print(f"van Geemen--Yamauchi b(t): {b}")

    u = sp.symbols("u")
    cyclotomic_scalar = cyclotomic_reduce(2 * zeta**3 + 2 * zeta**2 + 1, zeta)
    assert cyclotomic_reduce(cyclotomic_scalar**2, zeta) == 5
    a_u = -32 * (u - 3) ** 4 / (9 * (u + 1) ** 3 * (u + 3) ** 2)
    b_u = -8 * (u - 3) ** 2 * (u - 1) / ((u + 1) * (u + 3) ** 2)
    assert sp.cancel(a - a_u.subs(u, cyclotomic_scalar * t)) == 0
    assert sp.cancel(b - b_u.subs(u, cyclotomic_scalar * t)) == 0
    delta = (
        512 * a_u**2 + 27 * a_u**3 + 48 * a_u**2 * b_u + 128 * a_u * b_u**2
        + 6 * a_u**2 * b_u**2 + 30 * a_u * b_u**3 + a_u**2 * b_u**3
        + 8 * b_u**4 + 2 * a_u * b_u**4 + b_u**5
    )
    numerator_core = (
        64 * a_u**2 + 4 * a_u**2 * b_u + 16 * a_u * b_u**2
        + a_u**2 * b_u**2 + 2 * a_u * b_u**3 + b_u**4
    )
    delta_num, delta_den = map(sp.factor, sp.fraction(sp.together(delta)))
    core_num, core_den = map(sp.factor, sp.fraction(sp.together(numerator_core)))
    a_num, a_den = map(sp.factor, sp.fraction(sp.together(a_u)))
    j_invariant = sp.factor(
        -16 * core_num**3 * a_den**5 * delta_den
        / (core_den**3 * a_num**5 * delta_num)
    )
    print(f"elliptic-factor j(u), u^2=5t^2: {j_invariant}")
    j_t = sp.factor(j_invariant.subs(u**2, 5 * t**2))
    T = sp.symbols("T")
    modular_j = (T + 27) * (T + 3) ** 3 / T
    assert sp.factor(j_t - modular_j.subs(T, 81 * t**2)) == 0
    companion_j = sp.factor(modular_j.subs(T, 729 / T))
    print(f"elliptic-factor j(t): {j_t}")
    print(f"X0(3) Hauptmodul T=81t^2: j=(T+27)(T+3)^3/T")
    print(f"3-isogenous companion j: {companion_j}")
    print("Fricke correspondence on unmarked cubic parameter s=t^2: s -> 1/(9s)")
    print(f"standard-form discriminant factor: {delta_num}/{delta_den}")
    print("PASS")


if __name__ == "__main__":
    main()
