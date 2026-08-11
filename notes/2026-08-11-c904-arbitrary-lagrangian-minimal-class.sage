#!/usr/bin/env sage
"""Bounded census of primitive minimal classes for arbitrary prime gluings.

For G=p I_g, enumerate every Lagrangian K in the discriminant symplectic
space F_p^(2g).  Form the corresponding principal overlattice, its complete
integral Neron--Severi coefficient lattice, and the order of
Theta^(g-1)/(g-1)! modulo the lattice of (g-1)-fold divisor products.

This is a finite reconnaissance certificate, not an unrestricted theorem.
"""

from collections import Counter
from itertools import combinations, combinations_with_replacement, permutations, product


def alternating_matrix(field, rank):
    identity = identity_matrix(field, rank)
    zero = zero_matrix(field, rank)
    return block_matrix(field, [[zero, identity], [-identity, zero]])


def lagrangians(prime, rank):
    field = GF(prime)
    ambient = VectorSpace(field, 2 * rank)
    alternating = alternating_matrix(field, rank)
    for subspace in ambient.subspaces(rank):
        basis = subspace.basis_matrix()
        if basis * alternating * basis.transpose() == 0:
            yield basis


def lagrangian_invariants(lagrangian):
    """Elementary relative-position invariants for the dyadic rank-three case."""
    field = lagrangian.base_ring()
    rank = lagrangian.ncols() // 2
    ambient = VectorSpace(field, 2 * rank)
    subspace = ambient.subspace(lagrangian.rows())
    first = ambient.subspace([ambient.basis()[i] for i in range(rank)])
    second = ambient.subspace([ambient.basis()[rank + i] for i in range(rank)])
    diagonal = ambient.subspace([
        ambient.basis()[i] + ambient.basis()[rank + i] for i in range(rank)
    ])
    characteristic = vector(field, [1] * rank)
    marked = (
        vector(field, list(characteristic) + [0] * rank) in subspace,
        vector(field, [0] * rank + list(characteristic)) in subspace,
        vector(field, list(characteristic) + list(characteristic)) in subspace,
    )
    q_zero = all(vector(field, row[:rank]).dot_product(
        vector(field, row[rank:])) == 0 for row in lagrangian.rows())
    return (subspace.intersection(first).dimension(),
            subspace.intersection(second).dimension(),
            subspace.intersection(diagonal).dimension(),
            int(q_zero), tuple(int(value) for value in marked))


def subspace_key(matrix_value):
    reduced = matrix_value.row_space().basis_matrix().echelon_form()
    return tuple(tuple(int(value) for value in row) for row in reduced.rows())


def dyadic_orbits(order_by_key, rank):
    field = GF(2)
    linear_group = []
    for entries in product(field, repeat=4):
        value = matrix(field, 2, 2, entries)
        if value.det() != 0:
            linear_group.append(value)
    assert len(linear_group) == 6

    def transform(key, permutation, multiplier):
        rows = []
        for row_tuple in key:
            row = vector(field, row_tuple)
            first = vector(field, [row[permutation[i]] for i in range(rank)])
            second = vector(field, [row[rank + permutation[i]] for i in range(rank)])
            new_first = multiplier[0, 0] * first + multiplier[0, 1] * second
            new_second = multiplier[1, 0] * first + multiplier[1, 1] * second
            rows.append(vector(field, list(new_first) + list(new_second)))
        return subspace_key(matrix(field, rows))

    remaining = set(order_by_key)
    records = []
    while remaining:
        representative = min(remaining)
        orbit = {
            transform(representative, permutation, multiplier)
            for permutation in permutations(range(rank))
            for multiplier in linear_group
        }
        assert orbit <= set(order_by_key)
        orders = {order_by_key[key] for key in orbit}
        assert len(orders) == 1
        records.append((len(orbit), next(iter(orders)), representative))
        remaining -= orbit
    return sorted(records, key=lambda record: (record[1], record[0], record[2]))


def principal_lattice(prime, lagrangian):
    rank = lagrangian.nrows()
    dimension = 2 * rank
    lifted = lagrangian.change_ring(ZZ)
    scaled_lattice = span(ZZ, list((prime * identity_matrix(ZZ, dimension)).rows())
                          + list(lifted.rows()))
    basis = scaled_lattice.basis_matrix().change_ring(QQ) / prime
    source = prime * alternating_matrix(ZZ, rank)
    principal = basis * source * basis.transpose()
    assert principal.denominator() == 1
    principal = principal.change_ring(ZZ)
    assert abs(principal.det()) == 1
    return basis, principal


def ns_lattice(basis):
    rank = basis.nrows() // 2
    positions = [(i, j) for i in range(rank) for j in range(i, rank)]
    columns = []
    zero = zero_matrix(QQ, rank)
    for i, j in positions:
        coefficient = zero_matrix(QQ, rank)
        coefficient[i, j] = coefficient[j, i] = 1
        form = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        columns.append(vector(QQ, (basis * form * basis.transpose()).list()))
    linear = matrix(QQ, columns).transpose()
    denominator = lcm(value.denominator() for value in linear.list())
    integral = (denominator * linear).change_ring(ZZ)
    augmented = integral.augment(-denominator * identity_matrix(ZZ,
                                                                 linear.nrows()))
    kernel = augmented.right_kernel().basis_matrix()
    projected = [vector(ZZ, row[:linear.ncols()]) for row in kernel.rows()]
    lattice = span(ZZ, projected)
    assert lattice.rank() == len(positions)
    return positions, lattice


def coefficient_matrix(coordinates, positions, rank):
    answer = zero_matrix(ZZ, rank)
    for value, (i, j) in zip(coordinates, positions):
        answer[i, j] = answer[j, i] = value
    return answer


def two_form(value):
    return {(i, j): ZZ(value[i, j])
            for i in range(value.nrows()) for j in range(i + 1, value.ncols())
            if value[i, j]}


def wedge(left, right):
    answer = {}
    for left_indices, left_value in left.items():
        left_set = set(left_indices)
        for right_indices, right_value in right.items():
            if left_set.intersection(right_indices):
                continue
            inversions = sum(i > j for i in left_indices for j in right_indices)
            indices = tuple(sorted(left_indices + right_indices))
            answer[indices] = answer.get(indices, 0) + ((-1) ** inversions
                                                         * left_value
                                                         * right_value)
    return {indices: value for indices, value in answer.items() if value}


def minimal_order(basis, principal, positions, lattice):
    rank = basis.nrows() // 2
    zero = zero_matrix(QQ, rank)
    divisors = []
    for coordinates in lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions, rank)
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        form = basis * source * basis.transpose()
        assert form.denominator() == 1
        divisors.append(two_form(form.change_ring(ZZ)))

    target_indices = list(combinations(range(2 * rank), 2 * rank - 2))
    theta = two_form(principal)
    power = {tuple(): ZZ.one()}
    for _ in range(rank - 1):
        power = wedge(power, theta)
    divisor_factorial = factorial(rank - 1)
    assert all(value % divisor_factorial == 0 for value in power.values())
    minimal = vector(ZZ, [power.get(target, 0) // divisor_factorial
                          for target in target_indices])

    rows = []
    for indices in combinations_with_replacement(range(len(divisors)), rank - 1):
        value = {tuple(): ZZ.one()}
        for index in indices:
            value = wedge(value, divisors[index])
        rows.append(vector(ZZ, [value.get(target, 0)
                                for target in target_indices]))
    product_lattice = span(ZZ, rows)
    if minimal not in span(QQ, rows):
        return "outside-rational-span", product_lattice.rank(), len(rows)
    coordinates = product_lattice.coordinate_vector(minimal)
    order = lcm(value.denominator() for value in coordinates)
    return ZZ(order), product_lattice.rank(), len(rows)


def run_case(prime, rank):
    histogram = Counter()
    invariant_histogram = Counter()
    ns_smith_histogram = Counter()
    ns_mod_prime_histogram = Counter()
    order_by_key = {}
    count = 0
    expected = prod(prime ** i + 1 for i in range(1, rank + 1))
    for lagrangian in lagrangians(prime, rank):
        basis, principal = principal_lattice(prime, lagrangian)
        positions, lattice = ns_lattice(basis)
        order, product_rank, monomial_count = minimal_order(
            basis, principal, positions, lattice)
        histogram[(int(lattice.rank()), int(product_rank), int(monomial_count),
                   str(order))] += 1
        if prime == 2 and rank == 3:
            order_by_key[subspace_key(lagrangian)] = str(order)
            invariant_histogram[(lagrangian_invariants(lagrangian), str(order))] += 1
            ns_basis = lattice.basis_matrix()
            ns_smith = tuple(int(value) for value in ns_basis.elementary_divisors())
            ns_smith_histogram[(ns_smith, str(order))] += 1
            reduced = ns_basis.change_ring(GF(prime)).row_space().basis_matrix().echelon_form()
            signature = tuple(tuple(int(value) for value in row) for row in reduced.rows())
            ns_mod_prime_histogram[(signature, str(order))] += 1
        count += 1
    assert count == expected
    print(f"case p={prime} g={rank} lagrangians={count}")
    for key in sorted(histogram):
        print(f"  ns_rank={key[0]} product_rank={key[1]} "
              f"monomials={key[2]} minimal_order={key[3]} count={histogram[key]}")
    if invariant_histogram:
        print("  ns_smith_histogram")
        for key in sorted(ns_smith_histogram):
            print(f"    smith={key[0]} minimal_order={key[1]} "
                  f"count={ns_smith_histogram[key]}")
        mixed_signatures = {}
        for (signature, order), multiplicity in ns_mod_prime_histogram.items():
            mixed_signatures.setdefault(signature, {})[order] = multiplicity
        print(f"  ns_mod2_signatures={len(mixed_signatures)} "
              f"mixed_order_signatures={sum(len(value) > 1 for value in mixed_signatures.values())}")
        orbit_records = dyadic_orbits(order_by_key, rank)
        orbit_histogram = Counter(record[1] for record in orbit_records)
        print(f"  diagonal_S3_times_GL2_orbits={len(orbit_records)} "
              f"order_orbit_histogram={dict(sorted(orbit_histogram.items()))}")
        print(f"  elementary_relative_position_types={len(invariant_histogram)}")
    return histogram


def run_dyadic_orbit_case(rank):
    keys = {subspace_key(lagrangian): None for lagrangian in lagrangians(2, rank)}
    expected = prod(2 ** i + 1 for i in range(1, rank + 1))
    assert len(keys) == expected

    # First obtain the source-symmetry orbits without running HNF on every
    # Lagrangian.  The minimal order is constant on each orbit.
    remaining = set(keys)
    orbit_representatives = []
    field = GF(2)
    linear_group = [matrix(field, 2, 2, entries)
                    for entries in product(field, repeat=4)
                    if matrix(field, 2, 2, entries).det() != 0]

    def transformed_key(key, permutation, multiplier):
        rows = []
        for row_tuple in key:
            row = vector(field, row_tuple)
            first = vector(field, [row[permutation[i]] for i in range(rank)])
            second = vector(field, [row[rank + permutation[i]] for i in range(rank)])
            rows.append(vector(field,
                               list(multiplier[0, 0] * first
                                    + multiplier[0, 1] * second)
                               + list(multiplier[1, 0] * first
                                      + multiplier[1, 1] * second)))
        return subspace_key(matrix(field, rows))

    while remaining:
        representative = min(remaining)
        orbit = {
            transformed_key(representative, permutation, multiplier)
            for permutation in permutations(range(rank))
            for multiplier in linear_group
        }
        assert orbit <= set(keys)
        orbit_representatives.append((representative, len(orbit)))
        remaining -= orbit

    histogram = Counter()
    records = []
    for representative, orbit_size in orbit_representatives:
        lagrangian = matrix(field, representative)
        basis, principal = principal_lattice(2, lagrangian)
        positions, lattice = ns_lattice(basis)
        order, product_rank, monomial_count = minimal_order(
            basis, principal, positions, lattice)
        histogram[str(order)] += orbit_size
        records.append((orbit_size, str(order), representative,
                        int(lattice.rank()), int(product_rank), int(monomial_count)))

    print(f"case p=2 g={rank} lagrangians={expected} "
          f"source_symmetry_orbits={len(records)}")
    print(f"  weighted_minimal_order_histogram={dict(sorted(histogram.items()))}")
    orbit_histogram = Counter(record[1] for record in records)
    print(f"  order_orbit_histogram={dict(sorted(orbit_histogram.items()))}")
    return histogram


def symmetric_regular_nilpotents(rank):
    field = GF(2)
    positions = [(i, j) for i in range(rank) for j in range(i, rank)]
    found = []
    variable = polygen(field)
    for entries in product(field, repeat=len(positions)):
        value = zero_matrix(field, rank)
        for entry, (i, j) in zip(entries, positions):
            value[i, j] = value[j, i] = entry
        if value.charpoly() == variable ** rank and value ** (rank - 1) != 0:
            found.append(value)
    print(f"symmetric_regular_nilpotents_F2 rank={rank} count={len(found)}")
    if found:
        print(f"  representative={tuple(tuple(int(entry) for entry in row) for row in found[0].rows())}")
        graph = block_matrix(field, [[identity_matrix(field, rank), found[0]]])
        basis, principal = principal_lattice(2, graph)
        positions, lattice = ns_lattice(basis)
        order, product_rank, monomial_count = minimal_order(
            basis, principal, positions, lattice)
        print(f"  graph_minimal_order={order} product_rank={product_rank} "
              f"monomials={monomial_count}")
    return found


def run_graph_example(prime, slope_rows, expected_order):
    field = GF(prime)
    slope = matrix(field, slope_rows)
    rank = slope.nrows()
    assert slope == slope.transpose()
    graph = block_matrix(field, [[identity_matrix(field, rank), slope]])
    basis, principal = principal_lattice(prime, graph)
    positions, lattice = ns_lattice(basis)
    order, product_rank, monomial_count = minimal_order(
        basis, principal, positions, lattice)
    assert order == expected_order
    print(f"graph_counterexample p={prime} g={rank} minimal_order={order} "
          f"ns_rank={lattice.rank()} product_rank={product_rank} "
          f"monomials={monomial_count}")


def main():
    print("C904 arbitrary Lagrangian minimal-class bounded census")
    all_histograms = {}
    for prime, rank in ((2, 2), (2, 3), (3, 2), (3, 3)):
        all_histograms[(prime, rank)] = run_case(prime, rank)
    run_dyadic_orbit_case(4)
    symmetric_regular_nilpotents(3)
    symmetric_regular_nilpotents(4)
    run_graph_example(3, [
        [1, 1, 0, 0],
        [1, 1, 2, 2],
        [0, 2, 1, 0],
        [0, 2, 0, 1],
    ], 3)
    print("bounded_domain=full_lagrangians:(2,2),(2,3),(3,2),(3,3); "
          "source_orbits:(2,4); explicit_graph:(3,4)")
    print("PASS")


if __name__ == "__main__":
    main()
