#!/usr/bin/env sage
"""Small-rank exact census for root--weight/Weyl principal gluings.

For G_N=N I-J, construct the scalar S_N-stable principal overlattices.
At a prime power p^a||N, the local multiplicity Lagrangian
  p^k R x p^(a-k) R, 0<=k<=floor(a/2), R=Z/p^a,
represents every elementary-divisor type up to swapping.  Compute the full
integral NS lattice and the order of the minimal class modulo products of
g-1 divisor classes.
"""

from itertools import combinations, combinations_with_replacement, product


def root_gram(number):
    rank = number - 1
    return (number * identity_matrix(ZZ, rank)
            - matrix(ZZ, rank, rank, [1] * rank**2))


def principal_lattice(number, local_indices):
    rank = number - 1
    gram = root_gram(number)
    inverse = gram.inverse()
    generators = [number * vector(ZZ, [ZZ(i == j) for i in range(2 * rank)])
                  for j in range(2 * rank)]

    for prime, exponent in factor(number):
        prime = ZZ(prime)
        exponent = ZZ(exponent)
        local_modulus = prime**exponent
        index = ZZ(local_indices[prime])
        assert 0 <= index <= exponent // 2
        away = number // local_modulus
        first_scale = away * prime**index
        second_scale = away * prime**(exponent - index)
        for source in range(rank - 1):
            unit = vector(ZZ, [ZZ(i == source) for i in range(rank)])
            for first_value, second_value in ((first_scale, 0),
                                              (0, second_scale)):
                if first_value % number == 0 and second_value % number == 0:
                    continue
                glued = vector(QQ,
                               list(inverse * (first_value * unit))
                               + list(inverse * (second_value * unit)))
                generators.append(vector(ZZ, [ZZ(number * value)
                                               for value in glued]))

    scaled = span(ZZ, generators)
    assert scaled.rank() == 2 * rank
    basis = scaled.basis_matrix().change_ring(QQ) / number
    zero = zero_matrix(ZZ, rank)
    source_form = block_matrix(ZZ, [[zero, gram], [-gram, zero]])
    principal = basis * source_form * basis.transpose()
    assert principal.denominator() == 1
    principal = principal.change_ring(ZZ)
    assert abs(principal.det()) == 1
    return gram, basis, principal


def ns_lattice(basis):
    rank = basis.nrows() // 2
    positions = [(i, j) for i in range(rank) for j in range(i, rank)]
    columns = []
    for i, j in positions:
        coefficient = zero_matrix(QQ, rank)
        coefficient[i, j] = coefficient[j, i] = 1
        zero = zero_matrix(QQ, rank)
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
            answer[indices] = answer.get(indices, 0) + ((-1)**inversions
                                                         * left_value
                                                         * right_value)
    return {indices: value for indices, value in answer.items() if value}


def minimal_order(basis, principal, positions, lattice):
    dimension = basis.nrows() // 2
    zero = zero_matrix(QQ, dimension)
    divisors = []
    for coordinates in lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions, dimension)
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        form = basis * source * basis.transpose()
        assert form.denominator() == 1
        divisors.append(two_form(form.change_ring(ZZ)))

    target_indices = list(combinations(range(2 * dimension), 2 * dimension - 2))
    theta = two_form(principal)
    power = {tuple(): ZZ.one()}
    for _ in range(dimension - 1):
        power = wedge(power, theta)
    factorial_value = factorial(dimension - 1)
    assert all(value % factorial_value == 0 for value in power.values())
    minimal = vector(ZZ, [power.get(target, 0) // factorial_value
                          for target in target_indices])

    rows = []
    for indices in combinations_with_replacement(range(len(divisors)),
                                                  dimension - 1):
        value = {tuple(): ZZ.one()}
        for index in indices:
            value = wedge(value, divisors[index])
        rows.append(vector(ZZ, [value.get(target, 0)
                                for target in target_indices]))
    product_lattice = span(ZZ, rows)
    assert minimal in span(QQ, rows)
    coordinates = product_lattice.coordinate_vector(minimal)
    order = lcm(value.denominator() for value in coordinates)
    return len(rows), product_lattice.rank(), order


def main():
    cases = []
    for number in (3, 4, 5, 6, 7):
        local_ranges = []
        primes = []
        for prime, exponent in factor(number):
            prime = ZZ(prime)
            primes.append(prime)
            local_ranges.append(range(ZZ(exponent) // 2 + 1))
        for indices in product(*local_ranges):
            local = dict(zip(primes, indices))
            gram, basis, principal = principal_lattice(number, local)
            positions, lattice = ns_lattice(basis)
            count, rank, order = minimal_order(basis, principal, positions,
                                                lattice)
            record = (number, tuple(sorted(local.items())), lattice.rank(), count,
                      rank, order)
            print("case", record)
            assert order == 1
            cases.append(record)
    print("C904 root-weight minimal-class census")
    print("columns: N, local elementary indices, NS rank, monomials, span rank, minimal order")
    print(f"cases={cases}")
    print("all tested principal Weyl gluings have divisor-product minimal class")
    print("PASS")


if __name__ == "__main__":
    main()
