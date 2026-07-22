#!/usr/bin/env python3
"""Independent finite replay for C473 arithmetic orientation."""

from __future__ import annotations

import hashlib
import itertools
import json
from collections import deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"


def normalized(values, q):
    values = tuple(x % q for x in values)
    inverse = pow(next(x for x in values if x), -1, q)
    return tuple(x * inverse % q for x in values)


def determinant(g, q):
    return (g[0] * g[3] - g[1] * g[2]) % q


def point_action(g, q):
    a, b, c, d = g
    result = []
    for x in range(q + 1):
        if x == q:
            result.append(q if c == 0 else a * pow(c, -1, q) % q)
        else:
            denominator = (c * x + d) % q
            result.append(q if denominator == 0 else
                          (a * x + b) * pow(denominator, -1, q) % q)
    return tuple(result)


def matching(pairs):
    return tuple(sorted(tuple(sorted((int(a), int(b)))) for a, b in pairs))


def image_matching(obj, permutation):
    return matching((permutation[a], permutation[b]) for a, b in obj)


def matching_orbit(obj, permutations):
    return sorted({image_matching(obj, permutation) for permutation in permutations})


def induced(permutation, objects):
    index = {obj: i for i, obj in enumerate(objects)}
    return tuple(index[image_matching(obj, permutation)] for obj in objects)


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(right)))


def power(permutation, exponent):
    result = tuple(range(len(permutation)))
    for _ in range(exponent):
        result = compose(permutation, result)
    return result


def act(word, permutation):
    result = [0] * len(word)
    for old, value in enumerate(word):
        result[permutation[old]] = value
    return tuple(result)


def row_reduce(rows, p):
    if not rows:
        return []
    a = [[value % p for value in row] for row in rows if any(value % p for value in row)]
    k = 0
    for column in range(len(rows[0])):
        pivot = next((i for i in range(k, len(a)) if a[i][column]), None)
        if pivot is None:
            continue
        a[k], a[pivot] = a[pivot], a[k]
        scale = pow(a[k][column], -1, p)
        a[k] = [scale * value % p for value in a[k]]
        for i in range(len(a)):
            if i != k and a[i][column]:
                scale = a[i][column]
                a[i] = [(x - scale * y) % p for x, y in zip(a[i], a[k])]
        k += 1
    return a[:k]


def coords(word, basis, p):
    for coefficients in itertools.product(range(p), repeat=len(basis)):
        rebuilt = tuple(sum(coefficients[i] * basis[i][j] for i in range(len(basis))) % p
                        for j in range(len(word)))
        if rebuilt == tuple(word):
            return list(coefficients)
    raise AssertionError("coordinate failure")


def polynomial_apply(word, permutation, polynomial, p):
    result = [0] * len(word)
    current = tuple(word)
    for coefficient in polynomial:
        result = [(x + coefficient * y) % p for x, y in zip(result, current)]
        current = act(current, permutation)
    return tuple(result)


def polynomial_multiply(left, right, p):
    answer = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            answer[i + j] = (answer[i + j] + x * y) % p
    return answer


def matrix_multiply(left, right, p):
    return tuple(tuple(sum(left[i][k] * right[k][j] for k in range(len(right))) % p
                       for j in range(len(right[0]))) for i in range(len(left)))


def matrix_group(generators, p):
    generators = [tuple(tuple(row) for row in matrix) for matrix in generators]
    dimension = len(generators[0])
    identity = tuple(tuple(int(i == j) for j in range(dimension))
                     for i in range(dimension))
    group = {identity}
    queue = deque(group)
    while queue:
        current = queue.popleft()
        for generator in generators:
            target = matrix_multiply(generator, current, p)
            if target not in group:
                group.add(target)
                queue.append(target)
    return group


def main():
    certificate = json.loads((NOTES / "2026-07-22-c473-arithmetic-orientation.json").read_text())
    c406 = json.loads((NOTES / "2026-07-20-c406-matching-orbit-scout.json").read_text())
    c465 = json.loads((NOTES / "2026-07-21-c465-mod3-weil-golay.json").read_text())
    for name, record in certificate["inputs"].items():
        data = (ROOT / name).read_bytes()
        assert len(data) == record["bytes"]
        assert hashlib.sha256(data).hexdigest() == record["sha256"]
    frozen = {case["type"]: case for case in c406["types"]}
    c465_cases = {case["q"]: case for case in c465["cases"]}

    for record in certificate["cases"]:
        q, p, type_name = record["q"], record["characteristic"], record["type"]
        base = matching(frozen[type_name]["coxeter_invariant_matching"])
        matrices = sorted({normalized(values, q)
                           for values in itertools.product(range(q), repeat=4)
                           if determinant(values, q)})
        pgl = [point_action(matrix, q) for matrix in matrices]
        squares = {x * x % q for x in range(1, q)}
        psl = [point_action(matrix, q) for matrix in matrices
               if determinant(matrix, q) in squares]
        all_objects = matching_orbit(base, pgl)
        first = set(matching_orbit(base, psl))
        first_ordered = matching_orbit(base, psl)
        second = [obj for obj in all_objects if obj not in first]
        t0 = induced(point_action((1, 1, 0, 1), q), first_ordered)
        t = induced(point_action((1, 1, 0, 1), q), second)
        s = induced(point_action((0, q - 1, 1, 0), q), second)
        assert list(t) == record["frozen_generators"]["T_permutation_old_to_new"]
        assert list(s) == record["frozen_generators"]["S_permutation_old_to_new"]

        core = c465_cases[q]["spaces"]["shared_edge_row_span"]["basis"]
        intertwiner = record["intertwiner"]
        cyclic = [tuple(row) for row in intertwiner["matrix_rows_into_frozen_coordinates"]]
        assert row_reduce(cyclic, p) == core
        for generator, source_matrix in ((t, intertwiner["T_source_matrix"]),
                                         (s, intertwiner["S_source_matrix"])):
            for row, coefficients in zip(cyclic, source_matrix):
                assert act(row, generator) == tuple(
                    sum(coefficients[i] * cyclic[i][j] for i in range(len(cyclic))) % p
                    for j in range(q))
        assert len(matrix_group([intertwiner["T_source_matrix"],
                                 intertwiner["S_source_matrix"]], p)) == q * (q * q - 1) // 2

        factors = [item["polynomial_constant_first"]
                   for item in record["cyclotomic_period_factors"]]
        assert polynomial_multiply(factors[0], factors[1], p) == [1] * q
        assert {(-factor[-2]) % p for factor in factors} == {0, p - 1}
        selected = record["selected_factor_constant_first"]
        assert all(not any(polynomial_apply(row, t, selected, p)) for row in core)
        assert selected in factors
        assert record["selected_alpha_residue"] == (-selected[-2]) % p
        assert (record["selected_alpha_residue"], record["selected_prime"]) in (
            (0, "p_0"), (p - 1, "p_-1"))
        assert (record["selected_alpha_residue"] ** 2 +
                record["selected_alpha_residue"] + (q + 1) // 4) % p == 0
        shared = [[int(len(set(left) & set(right)) == 1) for right in second]
                  for left in first_ordered]
        opposite = row_reduce([list(row) for row in zip(*shared)], p)
        assert opposite == record["opposite_sheet"]["core_basis_rref"]
        opposite_polynomial = record["opposite_sheet"]["selected_factor_constant_first"]
        assert all(not any(polynomial_apply(row, t0, opposite_polynomial, p))
                   for row in opposite)
        assert record["opposite_sheet"]["selected_alpha_residue"] == \
            record["other_alpha_residue"]

        exponent_table = {item["exponent"]: item for item in
                          record["normalization_exponent_table"]}
        for exponent in range(1, q):
            item = exponent_table[exponent]
            powered = power(t, exponent)
            polynomial = item["minimal_polynomial_constant_first"]
            assert all(not any(polynomial_apply(row, powered, polynomial, p)) for row in core)
            expected_legendre = 1 if exponent in squares else -1
            assert item["legendre_symbol"] == expected_legendre
            expected_root = (record["selected_alpha_residue"] if expected_legendre == 1
                             else record["other_alpha_residue"])
            assert item["residue_root"] == expected_root

    selected = {case["q"]: case["selected_prime"] for case in certificate["cases"]}
    assert selected == {7: "p_-1", 11: "p_0"}
    assert certificate["uniform_statement"]["absolute_canonical_orientation"] is False
    assert certificate["uniform_statement"]["relative_to_marked_sheet_and_period_generator"] is True
    print("C473 independent replay: PASS")
    print("selected primes q=7/q=11 = p_-1/p_0; outer gauges exchange both")


if __name__ == "__main__":
    main()
