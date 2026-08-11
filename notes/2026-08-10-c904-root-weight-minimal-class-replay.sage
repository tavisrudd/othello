#!/usr/bin/env sage
"""Independent product-lattice replay for the small root--weight cases.

The primary certificate enumerates every symmetric divisor monomial.  This
replay instead closes the integral lattice degree by degree: wedge a basis of
the current product lattice with the divisor basis, take an integral HNF
basis, and iterate.  The two algorithms therefore have different product
generation paths.
"""

from contextlib import redirect_stdout
from io import StringIO
from itertools import combinations, product


with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-root-weight-minimal-class.sage")


def dynamic_order(basis, principal, positions, lattice):
    dimension = basis.nrows() // 2
    zero = zero_matrix(QQ, dimension)
    divisors = []
    for coordinates in lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions, dimension)
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        form = basis * source * basis.transpose()
        assert form.denominator() == 1
        divisors.append(two_form(form.change_ring(ZZ)))

    current = [{tuple(): ZZ.one()}]
    dimensions = []
    targets = None
    product_lattice = None
    for degree in range(1, dimension):
        targets = list(combinations(range(2 * dimension), 2 * degree))
        rows = []
        for left in current:
            for divisor in divisors:
                value = wedge(left, divisor)
                rows.append(vector(ZZ, [value.get(target, 0)
                                        for target in targets]))
        product_lattice = span(ZZ, rows)
        dimensions.append(product_lattice.rank())
        current = [{target: coefficient for target, coefficient
                    in zip(targets, row) if coefficient}
                   for row in product_lattice.basis_matrix().rows()]

    theta = two_form(principal)
    power = {tuple(): ZZ.one()}
    for _ in range(dimension - 1):
        power = wedge(power, theta)
    divisor = factorial(dimension - 1)
    minimal = vector(ZZ, [power.get(target, 0) // divisor for target in targets])
    assert all(power.get(target, 0) % divisor == 0 for target in targets)
    coordinates = product_lattice.coordinate_vector(minimal)
    order = lcm(value.denominator() for value in coordinates)
    return tuple(dimensions), order


def main_replay():
    records = []
    for number in (3, 4, 5, 6):
        primes = []
        ranges = []
        for prime, exponent in factor(number):
            prime = ZZ(prime)
            primes.append(prime)
            ranges.append(range(ZZ(exponent) // 2 + 1))
        for indices in product(*ranges):
            local = dict(zip(primes, indices))
            _, basis, principal = principal_lattice(number, local)
            positions, lattice = ns_lattice(basis)
            dimensions, order = dynamic_order(basis, principal, positions,
                                                lattice)
            assert order == 1
            records.append((number, tuple(sorted(local.items())), dimensions,
                            order))
    print("C904 independent dynamic root-weight replay")
    print(f"records={records}")
    print("all replayed minimal orders are one")
    print("PASS")


if __name__ == "__main__":
    main_replay()
