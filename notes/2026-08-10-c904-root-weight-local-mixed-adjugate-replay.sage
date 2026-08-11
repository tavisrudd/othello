#!/usr/bin/env sage
"""Independent polynomial-ring replay of the local cofactor identities."""


def matrix_unit(size, i, j=None):
    if j is None:
        j = i
    result = zero_matrix(ZZ, size)
    result[i, j] = 1
    if i != j:
        result[j, i] = 1
    return result


def coefficient_determinant(matrices, rows=None, columns=None):
    count = len(matrices)
    if count == 0:
        return ZZ.one()
    if rows is None:
        rows = list(range(count))
    if columns is None:
        columns = list(range(count))
    ring = PolynomialRing(ZZ, count, names=[f"t{i}" for i in range(count)])
    variables = ring.gens()
    mixed = sum((matrices[i].change_ring(ring) * variables[i]
                 for i in range(count)),
                zero_matrix(ring, matrices[0].nrows()))
    minor = mixed.matrix_from_rows_and_columns(rows, columns)
    return minor.det().monomial_coefficient(prod(variables))


def mixed_adjugate(size, matrices):
    result = zero_matrix(ZZ, size)
    for row in range(size):
        for column in range(size):
            rows = [i for i in range(size) if i != column]
            columns = [j for j in range(size) if j != row]
            result[row, column] = ((-1)**(row + column)
                                   * coefficient_determinant(matrices,
                                                             rows,
                                                             columns))
    return result


print("independent polynomial replay")
for size in range(1, 7):
    diagonal = [matrix_unit(size, i) for i in range(size)]
    assert coefficient_determinant(diagonal) == 1
    for i in range(size):
        expected = matrix_unit(size, i)
        assert mixed_adjugate(size,
                              [diagonal[k] for k in range(size)
                               if k != i]) == expected
    for i in range(size):
        for j in range(i + 1, size):
            factors = [matrix_unit(size, i, j)]
            factors.extend(diagonal[k] for k in range(size)
                           if k not in (i, j))
            value = mixed_adjugate(size, factors)
            assert value == matrix_unit(size, i, j) or value == -matrix_unit(size, i, j)
    print(f"d={size}: determinant and symmetric-unit identities PASS")
print("OVERALL PASS")
