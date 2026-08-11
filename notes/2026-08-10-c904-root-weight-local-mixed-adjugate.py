#!/usr/bin/env python3
"""Exact normalization check for the root--weight local cofactor proof.

The coefficient of t_1...t_r in a determinant is computed directly from
the Leibniz formula.  This verifies that diagonal matrix units give scalar
mixed determinant 1 and that the degree-(d-1) mixed-adjugate map on symmetric
integer matrices contains every symmetric matrix unit without a factorial or
an off-diagonal factor 2.
"""

from itertools import permutations


def permutation_sign(perm):
    inversions = sum(perm[i] > perm[j]
                     for i in range(len(perm))
                     for j in range(i + 1, len(perm)))
    return -1 if inversions % 2 else 1


def mixed_minor(matrices, rows, columns):
    """Coefficient of the squarefree product in the mixed determinant."""
    size = len(rows)
    assert size == len(columns) == len(matrices)
    if size == 0:
        return 1
    total = 0
    for column_perm in permutations(range(size)):
        sign = permutation_sign(column_perm)
        for assignment in permutations(range(size)):
            term = sign
            for position, row in enumerate(rows):
                matrix_index = assignment[position]
                column = columns[column_perm[position]]
                term *= matrices[matrix_index][row][column]
            total += term
    return total


def matrix_unit(size, i, j=None):
    if j is None:
        j = i
    result = [[0 for _ in range(size)] for _ in range(size)]
    result[i][j] = 1
    if i != j:
        result[j][i] = 1
    return result


def mixed_adjugate(size, matrices):
    assert len(matrices) == size - 1
    result = [[0 for _ in range(size)] for _ in range(size)]
    for row in range(size):
        for column in range(size):
            minor_rows = [i for i in range(size) if i != column]
            minor_columns = [j for j in range(size) if j != row]
            result[row][column] = ((-1) ** (row + column)
                                   * mixed_minor(matrices,
                                                 minor_rows,
                                                 minor_columns))
    return result


def support(matrix):
    return {(i, j): value
            for i, row in enumerate(matrix)
            for j, value in enumerate(row) if value}


def main():
    print("root-weight local mixed-adjugate normalization")
    for size in range(1, 7):
        diagonal = [matrix_unit(size, i) for i in range(size)]
        determinant = mixed_minor(diagonal, list(range(size)),
                                  list(range(size)))
        assert determinant == 1

        signs = set()
        for i in range(size):
            value = mixed_adjugate(size,
                                   [diagonal[k] for k in range(size)
                                    if k != i])
            assert support(value) == {(i, i): 1}

        for i in range(size):
            for j in range(i + 1, size):
                factors = [matrix_unit(size, i, j)]
                factors.extend(diagonal[k] for k in range(size)
                               if k not in (i, j))
                value = mixed_adjugate(size, factors)
                nonzero = support(value)
                assert set(nonzero) == {(i, j), (j, i)}
                assert nonzero[(i, j)] == nonzero[(j, i)]
                assert abs(nonzero[(i, j)]) == 1
                signs.add(nonzero[(i, j)])

        sign_text = "none" if not signs else ",".join(map(str, sorted(signs)))
        print(f"d={size}: det=1 diagonal=primitive offdiag_signs={sign_text} PASS")
    print("OVERALL PASS")


if __name__ == "__main__":
    main()
