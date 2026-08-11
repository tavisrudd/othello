#!/usr/bin/env sage
"""Exact finite checks for the uniform root/weight gluing theorem.

For the A_{n-1} root/weight sandwich G_n=nI-J, verify the Smith form and
the scalar commutant of the full S_n modular heart.  Then verify the two
PGL_2(F_p) orbits on P^1(F_{p^2}) that govern extension-field gluings.
"""

from itertools import product


def permutation_matrix(permutation, field):
    n = len(permutation)
    value = zero_matrix(field, n)
    for source, target in enumerate(permutation):
        value[target, source] = 1
    return value


def heart_actions(n, prime):
    field = GF(prime)
    # U=sum-zero with basis e_i-e_{n-1}.  Since p|n, the all-one vector has
    # U-coordinates (1,...,1) and spans the trivial submodule T.
    u_basis = matrix(field, n, n - 1)
    for i in range(n - 1):
        u_basis[i, i] = 1
        u_basis[n - 1, i] = -1
    t = vector(field, [1] * (n - 1))
    quotient_basis = [t]
    span_now = span(field, quotient_basis)
    for standard in VectorSpace(field, n - 1).basis():
        if standard not in span_now:
            quotient_basis.append(standard)
            span_now = span(field, quotient_basis)
    change = matrix(field, quotient_basis).transpose()

    permutations = []
    for i in range(n - 1):
        permutation = list(range(n))
        permutation[i], permutation[i + 1] = permutation[i + 1], permutation[i]
        permutations.append(permutation)

    answer = []
    for permutation in permutations:
        image = permutation_matrix(permutation, field) * u_basis
        u_action = u_basis.solve_right(image)
        transported = change.inverse() * u_action * change
        assert transported[1:n - 1, 0].is_zero()
        answer.append(transported[1:n - 1, 1:n - 1])
    return answer


def commutant_dimension(actions):
    field = actions[0].base_ring()
    dimension = actions[0].nrows()
    equations = []
    for action in actions:
        for i in range(dimension):
            for j in range(dimension):
                row = [field.zero()] * (dimension * dimension)
                for k in range(dimension):
                    row[dimension * i + k] += action[k, j]
                    row[dimension * k + j] -= action[i, k]
                equations.append(row)
    return matrix(field, equations).right_kernel().dimension()


def canonical_projective(value):
    if value is None:
        return None
    return value


def mobius(matrix_value, point):
    a, b, c, d = matrix_value
    if point is None:
        return None if c == 0 else a / c
    denominator = c * point + d
    return None if denominator == 0 else (a * point + b) / denominator


def pgl2(prime, extension):
    base = GF(prime)
    representatives = {}
    for a, b, c, d in product(base, repeat=4):
        determinant = a * d - b * c
        if determinant == 0:
            continue
        entries = [extension(a), extension(b), extension(c), extension(d)]
        first = next(value for value in entries if value != 0)
        normalized = tuple(value / first for value in entries)
        representatives[normalized] = normalized
    return list(representatives.values())


def orbit_partition(prime):
    extension = GF(prime**2, name="w")
    points = [None] + list(extension)
    group = pgl2(prime, extension)
    unseen = set(points)
    orbits = []
    while unseen:
        point = next(iter(unseen))
        orbit = {canonical_projective(mobius(element, point))
                 for element in group}
        unseen -= orbit
        orbits.append(orbit)
    return sorted(len(orbit) for orbit in orbits), len(group)


def main():
    records = []
    for n in range(4, 13):
        gram = n * identity_matrix(ZZ, n - 1) - matrix(ZZ, n - 1, n - 1,
                                                       [1] * (n - 1)**2)
        smith = tuple(ZZ(value) for value in gram.elementary_divisors())
        assert smith == (1,) + (n,) * (n - 2)
        for prime, _ in factor(n):
            actions = heart_actions(n, ZZ(prime))
            centralizer = commutant_dimension(actions)
            assert centralizer == 1
            records.append((n, ZZ(prime), n - 2, centralizer))

    orbit_records = []
    for prime in (2, 3, 5, 7):
        sizes, order = orbit_partition(prime)
        assert sizes == sorted([prime + 1, prime * (prime - 1)])
        assert order == prime * (prime**2 - 1)
        orbit_records.append((prime, sizes, order))

    print("C904 Weyl-heart extension gluing audit")
    print(f"S_n heart records (n,p,dim,commutant_dim)={records}")
    print(f"PGL2(Fp) orbit records (p,sizes,order)={orbit_records}")
    print("full Weyl hearts have scalar commutant; extension-field slopes require symmetry restriction")
    print("PASS")


if __name__ == "__main__":
    main()
