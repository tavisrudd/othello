from __future__ import annotations

import argparse
import json
from itertools import combinations_with_replacement
from pathlib import Path

import sympy as sp


def check(condition: bool, message: str) -> None:
    if not condition:
        raise ArithmeticError(message)


def coefficient_vector(poly: sp.Expr, variables: tuple, monomials: list) -> sp.Matrix:
    polynomial = sp.Poly(poly, *variables)
    return sp.Matrix([polynomial.coeff_monomial(m) for m in monomials])


def signed_permutation_group(generators: tuple[tuple[int, ...], ...]) -> set:
    identity = tuple(range(1, len(generators[0]) + 1))
    group, pending = {identity}, [identity]
    while pending:
        element = pending.pop()
        for generator in generators:
            product = tuple(
                (1 if i > 0 else -1) * generator[abs(i) - 1] for i in element
            )
            if product not in group:
                group.add(product)
                pending.append(product)
    return group


def run_checks() -> dict:
    u, v, x, z, y = sp.symbols("u v x z y")
    variables = (u, v, x, z, y)
    cubic_monomials = [
        sp.prod(variables[i] for i in indices)
        for indices in combinations_with_replacement(range(5), 3)
    ]
    seed = (
        (z - x) * u**2 + 6*y*u*v + 3*(z + x)*v**2 - z**3
        + sp.Rational(3, 4)*(x**2 + 3*y**2)*z + y**3
    )
    derivatives = [sp.diff(seed, variable) for variable in variables]
    jacobian_basis = sp.groebner(derivatives, *variables)
    pure_power_remainders = [jacobian_basis.reduce(variable**6)[1] for variable in variables]
    check(all(remainder == 0 for remainder in pure_power_remainders), "Seed smoothness check failed")
    deformations = (x**3, x**2*y, y**3)
    orbit = sp.Matrix.hstack(*(
        coefficient_vector(variable*derivative, variables, cubic_monomials)
        for variable in variables for derivative in derivatives
    ))
    family_directions = sp.Matrix.hstack(*(
        coefficient_vector(monomial, variables, cubic_monomials)
        for monomial in deformations
    ))
    cubic_ranks = (orbit.rank(), orbit.row_join(family_directions).rank())
    check(cubic_ranks == (25, 28), "Cubic moduli rank check failed")

    a, t, s, beta, w, h = sp.symbols("a t s beta w h")
    A = a**2 + 3
    c = t**3 - sp.Rational(3, 4)*A*t - beta
    discriminant = sp.factor(sp.discriminant(c, t))
    expected_discriminant = sp.Rational(27, 16)*A**3 - 27*beta**2
    check(sp.expand(discriminant - expected_discriminant) == 0, "Cubic discriminant failed")
    e_plus_sq = (s-a)*c.subs(t, s)
    e_minus_sq = (-s-a)*c.subs(t, -s)
    norm_remainder = sp.rem(sp.expand(e_plus_sq*e_minus_sq-discriminant/9), s**2-A, s)
    check(norm_remainder == 0, "Component splitting norm identity failed")

    Q1 = -a*u**2 + 6*u*v + 3*a*v**2 + beta*w**2 - z*h
    Q2 = u**2 + 3*v**2 + sp.Rational(3, 4)*A*w**2 - z**2 + w*h
    pencil_matrix = sp.hessian(Q1+t*Q2, (u, v, w, z, h))/2
    pencil_determinant = sp.factor(pencil_matrix.det())
    check(sp.expand(pencil_determinant-sp.Rational(3, 4)*(t**2-A)*c) == 0,
          "Quadrics pencil determinant failed")
    generic_cubic = (
        w*(-a*u**2 + 6*u*v + 3*a*v**2 + beta*w**2)
        + z*(u**2 + 3*v**2 + sp.Rational(3, 4)*A*w**2-z**2)
    )
    check(sp.expand(w*Q1+z*Q2-generic_cubic) == 0, "Birational projection identity failed")
    point = {u: 0, v: 0, w: 0, z: 0, h: 1}
    check(Q1.subs(point) == 0 and Q2.subs(point) == 0, "Rational point failed")

    r1, r2 = sp.symbols("r1 r2")
    r3 = -r1-r2
    root_A = sp.Rational(4, 3)*(r1**2+r1*r2+r2**2)
    check(sp.expand((r2-r3)**2-3*(root_A-r1**2)) == 0, "Root-difference identity failed")
    generators = (
        (1, 2, 3, 5, 4),
        (1, 2, 3, -4, -5),
        (2, 3, 1, 4, 5),
        (-1, -3, -2, 4, -5),
    )
    group = signed_permutation_group(generators)
    check(len(group) == 24, "Signed permutation group order failed")
    check(all(sum(i < 0 for i in g) % 2 == 0 for g in group), "Group not in W(D5)")

    sextic = 16*y**6-(x**2+3*y**2)**3
    sextic_monomials = [x**i*y**(6-i) for i in range(7)]
    binary_variables = (x, y)
    sextic_orbit = sp.Matrix.hstack(*(
        coefficient_vector(q*sp.diff(sextic, r), binary_variables, sextic_monomials)
        for q in binary_variables for r in binary_variables
    ))
    sextic_directions = sp.Matrix.hstack(*(
        coefficient_vector(32*y**3*m, binary_variables, sextic_monomials)
        for m in deformations
    ))
    genus_two_ranks = (sextic_orbit.rank(), sextic_orbit.row_join(sextic_directions).rank())
    check(genus_two_ranks == (4, 7), "Genus-two moduli rank failed")
    affine_sextic = sextic.subs({x: a, y: 1})
    sextic_gcd = sp.gcd(affine_sextic, sp.diff(affine_sextic, a))
    check(sextic_gcd == 1, "Seed genus-two curve is not smooth")

    return {
        "sympy_version": sp.__version__,
        "all_checks_passed": True,
        "scope": "Exact algebra only; imports the geometric theorems stated in the proof note.",
        "seed_cubic": str(seed),
        "seed_smoothness": {
            "sixth_power_remainders": dict(zip(map(str, variables), map(str, pure_power_remainders))),
            "jacobian_groebner_basis": [str(p.as_expr()) for p in jacobian_basis.polys],
        },
        "cubic_moduli": {
            "orbit_rank": cubic_ranks[0],
            "augmented_rank": cubic_ranks[1],
            "independent_directions": list(map(str, deformations)),
            "direction_remainders": [str(jacobian_basis.reduce(m)[1]) for m in deformations],
        },
        "quartic_del_pezzo": {
            "quadrics": [str(Q1), str(Q2)],
            "pencil_determinant": str(pencil_determinant),
            "cubic_discriminant": str(discriminant),
            "component_norm_identity_remainder": str(norm_remainder),
        },
        "type_I3": {"generators": generators, "group_order": len(group)},
        "genus_two": {
            "seed_sextic": str(sp.expand(sextic)),
            "squarefree_gcd": str(sextic_gcd),
            "orbit_rank": genus_two_ranks[0],
            "augmented_rank": genus_two_ranks[1],
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = json.dumps(run_checks(), indent=2) + "\n"
    if args.output is None:
        print(result, end="")
    else:
        args.output.write_text(result, encoding="utf-8")


if __name__ == "__main__":
    main()
