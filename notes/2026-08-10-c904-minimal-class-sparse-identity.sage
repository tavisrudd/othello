#!/usr/bin/env sage
"""Extract a deterministic sparse divisor identity for the C904 minimal class."""

from contextlib import redirect_stdout
from io import StringIO
import random
import sys


saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = saved_argv


def tracked_identity(rows, target):
    """Return exact coefficients of target in the lattice spanned by rows."""
    source = matrix(ZZ, rows)
    hermite, transform = source.hermite_form(transformation=True)
    nonzero_indices = [i for i, row in enumerate(hermite.rows())
                       if not row.is_zero()]
    basis_rows = [hermite.row(i) for i in nonzero_indices]
    lattice = span(ZZ, basis_rows)
    if target not in lattice:
        return None
    coordinates = lattice.coordinate_vector(target)
    coefficients = zero_vector(ZZ, len(rows))
    for coordinate, row_index in zip(coordinates, nonzero_indices):
        assert coordinate.denominator() == 1
        coefficients += ZZ(coordinate) * transform.row(row_index)
    assert coefficients * source == target
    return coefficients


def greedy_reduce(indices, product_rows, target, order):
    current = list(indices)
    for index in order(list(current)):
        if index not in current:
            continue
        candidate = [value for value in current if value != index]
        if target in span(ZZ, [product_rows[value] for value in candidate]):
            current = candidate
    coefficients = tracked_identity([product_rows[index] for index in current], target)
    assert coefficients is not None
    return current, coefficients


def main():
    _, _, basis, symplectic = principal_lattice()
    positions, linear_map = ns_integrality_matrix(basis)
    _, ns_lattice = congruence_kernel_lattice(linear_map)
    (product_lattice, saturated_product_lattice, minimal, _, _,
     initial_support, _, product_rows, monomials) = (
        divisor_product_lattice(
            basis, symplectic, positions, ns_lattice, find_identity=True
        )
    )
    monomial_index = {monomial: i for i, monomial in enumerate(monomials)}
    initial_indices = [monomial_index[monomial]
                       for monomial, _ in initial_support]

    orders = [
        ("forward", lambda values: list(values)),
        ("reverse", lambda values: list(reversed(values))),
        ("row-l1", lambda values: sorted(
            values,
            key=lambda i: (sum(abs(x) for x in product_rows[i]), i),
            reverse=True,
        )),
    ]
    candidates = []
    for name, order in orders:
        indices, coefficients = greedy_reduce(
            initial_indices, product_rows, minimal, order
        )
        support = [(index, ZZ(coefficient))
                   for index, coefficient in zip(indices, coefficients)
                   if coefficient]
        assert sum((coefficient * product_rows[index]
                    for index, coefficient in support),
                   zero_vector(ZZ, 45)) == minimal
        candidates.append((len(support),
                           sum(abs(coefficient) for _, coefficient in support),
                           name, support))

    # Deterministic search for a 15-monomial rational basis whose target
    # coordinates are integral.  Work in the saturated rank-15 lattice.
    assert product_lattice.index_in(saturated_product_lattice) == 1
    coordinate_rows = [vector(ZZ, saturated_product_lattice.coordinate_vector(row))
                       for row in product_rows]
    target_coordinates = vector(
        ZZ, saturated_product_lattice.coordinate_vector(minimal)
    )
    nonzero_indices = [i for i, row in enumerate(coordinate_rows)
                       if not row.is_zero()]
    generator = random.Random(int(904))
    successful_bases = 0
    for trial in range(5000):
        indices = generator.sample(nonzero_indices, 15)
        basis_matrix = matrix(ZZ, [coordinate_rows[i] for i in indices])
        if basis_matrix.rank() != 15:
            continue
        coefficients = basis_matrix.transpose().solve_right(target_coordinates)
        if any(coefficient.denominator() != 1 for coefficient in coefficients):
            continue
        successful_bases += 1
        support = [(index, ZZ(coefficient))
                   for index, coefficient in zip(indices, coefficients)
                   if coefficient]
        candidates.append((len(support),
                           sum(abs(coefficient) for _, coefficient in support),
                           f"random-basis-{trial}", support))
    candidates.sort(key=lambda item: (item[0], item[1], item[2]))
    support_size, l1, name, support = candidates[0]

    unique_rows = len({tuple(row) for row in product_rows})
    zero_rows = sum(row.is_zero() for row in product_rows)
    print("C904 sparse primitive divisor identity")
    print(f"monomials={len(monomials)} unique-rows={unique_rows} zero-rows={zero_rows}")
    print(f"initial-support={len(initial_support)} reduced-support={support_size} L1={l1} order={name}")
    print(f"random-integral-bases={successful_bases}/5000")
    for index, coefficient in support:
        print(f"  {coefficient:+d} * D{monomials[index]}")
    used_divisors = sorted({divisor for index, _ in support
                            for divisor in monomials[index]})
    group = generated_axis_group()
    ns_basis = ns_lattice.basis_matrix().LLL()
    print("used-divisor-types:")
    for divisor in used_divisors:
        coefficient_matrix_value = coefficient_matrix(ns_basis.row(divisor), positions)
        orbit = {
            tuple((action.transpose() * coefficient_matrix_value * action).list())
            for action in group
        }
        positive, negative, nullity = QuadraticForm(
            QQ, coefficient_matrix_value
        ).signature_vector()
        print(
            f"  D{divisor}: rank={coefficient_matrix_value.rank()} "
            f"signature=({positive},{negative},{nullity}) "
            f"det={coefficient_matrix_value.det()} orbit={len(orbit)}"
        )
    print("PASS")


if __name__ == "__main__":
    main()
