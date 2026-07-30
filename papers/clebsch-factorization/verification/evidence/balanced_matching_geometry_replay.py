#!/usr/bin/env python3
"""Independent generator-based replay of the balanced matching geometry."""

from __future__ import annotations

import itertools
import json
from pathlib import Path


CERTIFICATE = Path(__file__).with_name("balanced_matching_geometry.json")


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(left)))


def generated_group(generators):
    identity = tuple(range(len(generators[0])))
    group = {identity}
    frontier = [identity]
    while frontier:
        current = frontier.pop()
        for generator in generators:
            product = compose(generator, current)
            if product not in group:
                group.add(product)
                frontier.append(product)
    return group


def groups(q):
    translation = tuple((x + 1) % q if x < q else q for x in range(q + 1))
    inversion = tuple(q if x == 0 else 0 if x == q else -pow(x, -1, q) % q for x in range(q + 1))
    squares = {x * x % q for x in range(1, q)}
    nonsquare = next(x for x in range(2, q) if x not in squares)
    dilation = tuple(nonsquare * x % q if x < q else q for x in range(q + 1))
    psl = generated_group((translation, inversion))
    pgl = generated_group((translation, inversion, dilation))
    assert len(psl) == q * (q * q - 1) // 2
    assert len(pgl) == q * (q * q - 1)
    return pgl, psl


def matchings(vertices):
    if not vertices:
        yield ()
        return
    first = vertices[0]
    for i in range(1, len(vertices)):
        for rest in matchings(vertices[1:i] + vertices[i + 1 :]):
            yield ((first, vertices[i]),) + rest


def act(permutation, matching):
    return tuple(sorted(tuple(sorted((permutation[a], permutation[b]))) for a, b in matching))


def partition(group, objects):
    unseen = set(objects)
    answer = []
    while unseen:
        base = min(unseen)
        part = {act(g, base) for g in group}
        answer.append(part)
        unseen -= part
    return sorted(answer, key=lambda part: (len(part), min(part)))


def polynomial_product(left, right, q):
    answer = {}
    for a, ca in left.items():
        for b, cb in right.items():
            exponent = tuple(a[i] + b[i] for i in range(3))
            answer[exponent] = (answer.get(exponent, 0) + ca * cb) % q
    return {e: c for e, c in answer.items() if c}


def secant_product(matching, q):
    endpoints = [(x, 1) for x in range(q)] + [(1, 0)]
    answer = {(0, 0, 0): 1}
    for i, j in matching:
        si, ti = endpoints[i]
        sj, tj = endpoints[j]
        answer = polynomial_product(
            answer,
            {
                (1, 0, 0): ti * tj % q,
                (0, 1, 0): -(si * tj + ti * sj) % q,
                (0, 0, 1): si * sj % q,
            },
            q,
        )
    return answer


def quotient_coefficients(difference, degree, q):
    quotient = {}
    for a in range(degree, -1, -1):
        for b in range(degree - a + 1):
            c = degree - a - b
            coefficient = difference.get((a + 1, b, c + 1), 0)
            if b >= 2:
                coefficient += quotient.get((a + 1, b - 2, c + 1), 0)
            quotient[(a, b, c)] = coefficient % q
    conic = {(1, 0, 1): 1, (0, 2, 0): -1 % q}
    rebuilt = polynomial_product(quotient, conic, q)
    support = set(rebuilt) | set(difference)
    assert all(rebuilt.get(e, 0) == difference.get(e, 0) % q for e in support)
    return [quotient[e] for e in sorted(quotient)]


def matrix_rank(matrix, q):
    data = [[x % q for x in row] for row in matrix]
    row = 0
    for column in range(len(data[0]) if data else 0):
        pivot = next((i for i in range(row, len(data)) if data[i][column]), None)
        if pivot is None:
            continue
        data[row], data[pivot] = data[pivot], data[row]
        inverse = pow(data[row][column], -1, q)
        for j in range(column, len(data[row])):
            data[row][j] = data[row][j] * inverse % q
        for i in range(row + 1, len(data)):
            if data[i][column]:
                scale = data[i][column]
                for j in range(column, len(data[i])):
                    data[i][j] = (data[i][j] - scale * data[row][j]) % q
        row += 1
        if row == len(data):
            break
    return row


def independent_rows(matrix, q):
    answer = []
    old_rank = 0
    for row in matrix:
        new_rank = matrix_rank(answer + [row], q)
        if new_rank > old_rank:
            answer.append(row)
            old_rank = new_rank
    return answer


def kernel(matrix, q):
    data = [[x % q for x in row] for row in matrix]
    columns = len(data[0]) if data else 0
    pivots = []
    row = 0
    for column in range(columns):
        pivot = next((i for i in range(row, len(data)) if data[i][column]), None)
        if pivot is None:
            continue
        data[row], data[pivot] = data[pivot], data[row]
        inverse = pow(data[row][column], -1, q)
        data[row] = [x * inverse % q for x in data[row]]
        for i in range(len(data)):
            if i != row and data[i][column]:
                scale = data[i][column]
                data[i] = [(x - scale * y) % q for x, y in zip(data[i], data[row])]
        pivots.append(column)
        row += 1
        if row == len(data):
            break
    free = [column for column in range(columns) if column not in pivots]
    answer = []
    for free_column in free:
        vector = [0] * columns
        vector[free_column] = 1
        for i, pivot in enumerate(pivots):
            vector[pivot] = -data[i][free_column] % q
        answer.append(vector)
    return answer


def schur_rank(rows, degree, q):
    products = []
    for choice in itertools.combinations_with_replacement(range(len(rows)), degree):
        product = [1] * len(rows[0])
        for index in choice:
            product = [a * b % q for a, b in zip(product, rows[index])]
        products.append(product)
    return matrix_rank(products, q)


def algebra_data(full_orbit, special_parts, q):
    ordered = sorted(full_orbit)
    base_product = secant_product(ordered[0], q)
    degree = (q - 3) // 2
    points = []
    for matching in ordered:
        product = secant_product(matching, q)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % q
            for exponent in set(product) | set(base_product)
        }
        points.append(quotient_coefficients(difference, degree, q))
    rows = [[1] * len(points)] + [list(column) for column in zip(*points)]
    linear = independent_rows(rows, q)
    square_rows = []
    for i in range(len(linear)):
        for j in range(i, len(linear)):
            square_rows.append([a * b % q for a, b in zip(linear[i], linear[j])])
    trades = kernel(square_rows, q)
    result = {
        "affine_linear_rank": len(linear),
        "schur_square_rank": matrix_rank(square_rows, q),
        "schur_cube_rank": schur_rank(linear, 3, q),
        "quadratic_trade_dimension": len(trades),
    }
    if len(trades) == 1:
        trade = trades[0]
        scale = pow(next(x for x in trade if x), -1, q)
        trade = [x * scale % q for x in trade]
        values = sorted(set(trade))
        levels = [[ordered[i] for i, x in enumerate(trade) if x == value] for value in values]
        edge_multiplicities = []
        for level in levels:
            counts = {edge: 0 for edge in itertools.combinations(range(q + 1), 2)}
            for matching in level:
                for edge in matching:
                    counts[edge] += 1
            edge_multiplicities.append(sorted(set(counts.values())))
        result.update(
            {
                "quadratic_trade_full_support": all(trade),
                "quadratic_trade_values": values,
                "recovered_level_sizes": [len(level) for level in levels],
                "recovered_edge_multiplicities": edge_multiplicities,
                "recovered_levels_are_one_factorizations": edge_multiplicities == [[1], [1]],
                "recovered_partition_equals_psl_orbits": {frozenset(x) for x in levels}
                == {frozenset(x) for x in special_parts},
            }
        )
    return result


def replay_field(q):
    pgl, psl = groups(q)
    full_parts = partition(pgl, list(matchings(tuple(range(q + 1)))))
    summary = []
    for full_part in full_parts:
        special_parts = partition(psl, full_part)
        row = (len(full_part), sorted(len(part) for part in special_parts))
        if (q == 5 and len(full_part) == 10) or (
            len(full_part) == 2 * q and row[1] == [q, q]
        ):
            row += (algebra_data(full_part, special_parts, q),)
        summary.append(row)
    return summary


def main():
    certificate = json.loads(CERTIFICATE.read_text())
    expected = {}
    for field in certificate["fields"]:
        rows = []
        for orbit in field["orbits"]:
            row = (orbit["size"], orbit["psl_orbit_sizes"])
            if "evaluation" in orbit:
                evaluation = orbit["evaluation"]
                row += ({key: value for key, value in evaluation.items() if key != "quotient_degree"},)
            rows.append(row)
        expected[field["q"]] = rows
    actual = {q: replay_field(q) for q in (5, 7, 11)}
    assert actual == expected, (actual, expected)
    assert [
        q
        for q, rows in actual.items()
        if any(size == 2 * q and psl_sizes == [q, q] for size, psl_sizes, *_ in rows)
    ] == [7, 11]
    print("independent balanced matching replay: OK (q=5,7,11; all matching orbits)")


if __name__ == "__main__":
    main()
