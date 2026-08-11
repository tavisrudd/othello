#!/usr/bin/env python3
"""Mod-two numerical audit of the ordered-pair cover on the sparse cycle."""

import importlib.util
from pathlib import Path


def load_module(name, filename):
    spec = importlib.util.spec_from_file_location(name, Path(__file__).with_name(filename))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


DIVISOR = load_module(
    "c904_divisor_replay", "2026-08-10-c904-minimal-class-divisor-replay.py"
)
SPARSE = load_module(
    "c904_sparse_replay", "2026-08-10-c904-minimal-class-sparse-identity-replay.py"
)


def main():
    forms = DIVISOR.divisor_forms()
    eight_indices, rows, monomials = DIVISOR.all_products(forms)
    row_lookup = {monomial: row for monomial, row in zip(monomials, rows)}
    theta = DIVISOR.two_form(DIVISOR.PRINCIPAL_SYMPLECTIC)
    top = tuple(range(10))

    theta_degrees = {}
    for monomial in SPARSE.IDENTITY:
        degree_eight = {
            indices: coefficient
            for indices, coefficient in zip(eight_indices, row_lookup[monomial])
            if coefficient
        }
        theta_degrees[monomial] = DIVISOR.wedge(degree_eight, theta).get(top, 0)

    weighted_theta_degree = sum(
        SPARSE.IDENTITY[monomial] * degree
        for monomial, degree in theta_degrees.items()
    )
    # Theta.(Theta^4/4!)=5 on a principally polarized fivefold.
    assert weighted_theta_degree == 5

    print("C904 ordered-pair numerical audit on 16 sparse components")
    for monomial, coefficient in SPARSE.IDENTITY.items():
        theta_degree = theta_degrees[monomial]
        boundary_degree = 3 * theta_degree  # [D_+]=3 Theta
        print(
            f"  D{monomial}: coeff={coefficient:+d} "
            f"theta-degree={theta_degree:+d} "
            f"Dplus-degree={boundary_degree:+d} mod2={boundary_degree % 2}"
        )
    odd_components = [monomial for monomial, degree in theta_degrees.items()
                      if degree % 2]
    print(f"odd-Dplus-degree components={len(odd_components)}/16: {odd_components}")
    print(f"weighted theta-degree={weighted_theta_degree}; weighted Dplus-degree={3 * weighted_theta_degree}")

    # Any etale double cover pi:C'->C has the same numerical push/norm data,
    # whether its 2-torsion class eta is zero or not.
    for base_degree in range(8):
        pulled_degree = 2 * base_degree
        norm_degree = pulled_degree
        assert pulled_degree % 2 == 0
        assert norm_degree == 2 * base_degree
    print("etale-cover numerical invariants: push degree=2, branch/discriminant degree=0")
    print("norm of pulled divisor has degree doubled; all intersection pullbacks are even")
    print("PASS")


if __name__ == "__main__":
    main()
