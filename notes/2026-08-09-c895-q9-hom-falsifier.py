#!/usr/bin/env python3
"""Exact q=9 falsifier for the C895 finite-group Hom basis.

The field is F_3[a]/(a^2+1).  The script constructs the polynomial modules
directly and solves the full generator intertwining equations over F_9.
It is a bounded check only, not a proof of the all-q Lucas theorem.
"""

import argparse
import hashlib
import json
import math
from pathlib import Path


OUTPUT = Path(__file__).with_suffix(".json")


def add(x, y):
    return ((x % 3 + y % 3) % 3) + 3 * (((x // 3) + (y // 3)) % 3)


def neg(x):
    return ((-x % 3) % 3) + 3 * ((-(x // 3) % 3) % 3)


def mul(x, y):
    a, b = x % 3, x // 3
    c, d = y % 3, y // 3
    return ((a * c + 2 * b * d) % 3) + 3 * ((a * d + b * c) % 3)


def power(x, n):
    answer = 1
    while n:
        if n & 1:
            answer = mul(answer, x)
        x = mul(x, x)
        n //= 2
    return answer


def inv(x):
    assert x
    return power(x, 7)


def scalar(n):
    return n % 3


def product(values):
    answer = 1
    for value in values:
        answer = mul(answer, value)
    return answer


def matmul(a, b):
    rows, inner, cols = len(a), len(b), len(b[0])
    assert len(a[0]) == inner
    return [
        [
            sum_field(mul(a[i][k], b[k][j]) for k in range(inner))
            for j in range(cols)
        ]
        for i in range(rows)
    ]


def sum_field(values):
    answer = 0
    for value in values:
        answer = add(answer, value)
    return answer


def sym_power(g, n):
    """Matrix on X^(n-i)Y^i; columns are images of basis vectors."""
    a, b = g[0]
    c, d = g[1]
    matrix = [[0 for _ in range(n + 1)] for _ in range(n + 1)]
    for i in range(n + 1):
        for r in range(n - i + 1):
            for s in range(i + 1):
                j = r + s
                coefficient = product(
                    [
                        scalar(math.comb(n - i, r)),
                        power(a, n - i - r),
                        power(b, r),
                        scalar(math.comb(i, s)),
                        power(c, i - s),
                        power(d, s),
                    ]
                )
                matrix[j][i] = add(matrix[j][i], coefficient)
    return matrix


def sym_square(matrix):
    n = len(matrix)
    pairs = [(i, j) for i in range(n) for j in range(i, n)]
    index = {pair: k for k, pair in enumerate(pairs)}
    answer = [[0 for _ in pairs] for _ in pairs]
    for column, (i, j) in enumerate(pairs):
        for r in range(n):
            for s in range(n):
                pair = (r, s) if r <= s else (s, r)
                term = mul(matrix[r][i], matrix[s][j])
                answer[index[pair]][column] = add(
                    answer[index[pair]][column], term
                )
    return answer


def kronecker(a, b):
    ar, ac, br, bc = len(a), len(a[0]), len(b), len(b[0])
    answer = [[0 for _ in range(ac * bc)] for _ in range(ar * br)]
    for i in range(ar):
        for j in range(ac):
            for r in range(br):
                for s in range(bc):
                    answer[i * br + r][j * bc + s] = mul(a[i][j], b[r][s])
    return answer


def frobenius_matrix(g):
    return [[power(value, 3) for value in row] for row in g]


def rref(matrix):
    rows = [row[:] for row in matrix if any(row)]
    if not rows:
        return rows, []
    columns = len(rows[0])
    pivot_row = 0
    pivots = []
    for column in range(columns):
        pivot = next(
            (i for i in range(pivot_row, len(rows)) if rows[i][column]), None
        )
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        scale = inv(rows[pivot_row][column])
        rows[pivot_row] = [mul(scale, value) for value in rows[pivot_row]]
        for i in range(len(rows)):
            if i == pivot_row or not rows[i][column]:
                continue
            factor = rows[i][column]
            rows[i] = [
                add(rows[i][j], neg(mul(factor, rows[pivot_row][j])))
                for j in range(columns)
            ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(rows):
            break
    return rows, pivots


def rank(matrix):
    return len(rref(matrix)[1])


def nullspace(matrix, columns):
    rows, pivots = rref(matrix)
    free = [column for column in range(columns) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * columns
        vector[free_column] = 1
        for row_index in range(len(pivots) - 1, -1, -1):
            pivot = pivots[row_index]
            total = sum_field(
                mul(rows[row_index][column], vector[column])
                for column in free
            )
            vector[pivot] = neg(total)
        basis.append(vector)
    return basis


def intertwiner_equations(targets, sources):
    target_dimension = len(targets[0])
    source_dimension = len(sources[0])
    variables = target_dimension * source_dimension
    equations = []
    for target, source in zip(targets, sources):
        for out_index in range(target_dimension):
            for in_index in range(source_dimension):
                row = [0] * variables
                for middle in range(target_dimension):
                    variable = middle * source_dimension + in_index
                    row[variable] = add(row[variable], target[out_index][middle])
                for middle in range(source_dimension):
                    variable = out_index * source_dimension + middle
                    row[variable] = add(row[variable], neg(source[middle][in_index]))
                equations.append(row)
    return equations, variables


def intertwiner_dimension(targets, sources):
    equations, variables = intertwiner_equations(targets, sources)
    return variables - rank(equations)


def intertwiner_basis(targets, sources):
    equations, variables = intertwiner_equations(targets, sources)
    return nullspace(equations, variables)


def matrix(a, b, c, d):
    return [[a, b], [c, d]]


def generators(full_roots):
    alpha = 3
    primitive = next(x for x in range(2, 9) if power(x, 4) != 1)
    roots = list(range(9)) if full_roots else [1, alpha]
    answer = [matrix(1, t, 0, 1) for t in roots]
    answer.extend(
        [
            matrix(0, neg(1), 1, 0),
            matrix(primitive, 0, 0, inv(primitive)),
        ]
    )
    return answer, primitive


def source_matrices(group_generators, c0, c1):
    return [
        kronecker(sym_power(g, c0), sym_power(frobenius_matrix(g), c1))
        for g in group_generators
    ]


def target_matrices(group_generators):
    return [sym_square(sym_power(g, 3)) for g in group_generators]


def compute():
    compact_generators, primitive = generators(False)
    full_generators, primitive_again = generators(True)
    assert primitive == primitive_again and power(primitive, 8) == 1
    compact_targets = target_matrices(compact_generators)
    full_targets = target_matrices(full_generators)
    rows = []
    extra_intertwiner = None
    for c0 in range(3):
        for c1 in range(3):
            if (c0 + c1) % 2:
                continue
            compact = intertwiner_dimension(
                compact_targets, source_matrices(compact_generators, c0, c1)
            )
            full = intertwiner_dimension(
                full_targets, source_matrices(full_generators, c0, c1)
            )
            assert compact == full
            predicted = 1 if (c0, c1) == (0, 2) else 0
            rows.append(
                {
                    "digits": [c0, c1],
                    "source_dimension": (c0 + 1) * (c1 + 1),
                    "hom_dimension": full,
                    "predicted_dimension": predicted,
                    "matches": full == predicted,
                }
            )
            if (c0, c1) == (2, 0):
                basis = intertwiner_basis(
                    full_targets, source_matrices(full_generators, c0, c1)
                )
                assert len(basis) == full == 1
                pairs = [(i, j) for i in range(4) for j in range(i, 4)]
                entries = []
                for target_index, pair in enumerate(pairs):
                    for source_index in range(3):
                        value = basis[0][target_index * 3 + source_index]
                        if value:
                            entries.append(
                                {
                                    "source_index": source_index,
                                    "target_pair": list(pair),
                                    "coefficient_encoding": value,
                                }
                            )
                extra_intertwiner = {
                    "source_digits": [2, 0],
                    "source_basis": ["X^2", "XY", "Y^2"],
                    "target_W_basis": ["X^3", "X^2Y", "XY^2", "Y^3"],
                    "target_symmetric_basis_order": pairs,
                    "nonzero_entries": entries,
                }
    return {
        "schema": "c895-q9-hom-falsifier-v1",
        "field": "F_3[a]/(a^2+1)",
        "q": 9,
        "target": "Sym^2(Sym^3 natural)",
        "target_dimension": 10,
        "primitive_element_encoding": primitive,
        "generator_cross_check": "u(1),u(a),w,h versus all u(t),w,h",
        "central_even_simple_rows": rows,
        "extra_intertwiner": extra_intertwiner,
        "all_match": all(row["matches"] for row in rows),
        "boundary": "bounded falsifier only; not an all-q Hom proof",
    }


def canonical(data):
    return json.dumps(data, indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    assert args.write ^ args.check
    rendered = canonical(compute())
    if args.write:
        OUTPUT.write_text(rendered)
    else:
        assert OUTPUT.read_text() == rendered
    print(hashlib.sha256(rendered.encode()).hexdigest())


if __name__ == "__main__":
    main()
