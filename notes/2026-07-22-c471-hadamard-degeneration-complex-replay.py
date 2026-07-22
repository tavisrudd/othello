#!/usr/bin/env python3
"""Independent finite replay of the C471 certificate (imports no C471 code)."""

from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
P = 3


def rr(rows):
    rows = list(rows)
    if not rows:
        return ()
    a = [[x % P for x in row] for row in rows if any(x % P for x in row)]
    k = 0
    for column in range(len(rows[0])):
        pivot = next((i for i in range(k, len(a)) if a[i][column]), None)
        if pivot is None:
            continue
        a[k], a[pivot] = a[pivot], a[k]
        scale = pow(a[k][column], -1, P)
        a[k] = [scale * x % P for x in a[k]]
        for i in range(len(a)):
            if i != k and a[i][column]:
                scale = a[i][column]
                a[i] = [(x - scale * y) % P for x, y in zip(a[i], a[k])]
        k += 1
    return tuple(tuple(row) for row in a[:k])


def span(basis):
    return {tuple(sum(coeffs[i] * basis[i][j] for i in range(len(basis))) % P
                  for j in range(len(basis[0])))
            for coeffs in itertools.product(range(P), repeat=len(basis))}


def multiply_vector(matrix, vector):
    return tuple(sum(x * y for x, y in zip(row, vector)) % P for row in matrix)


def act(vector, permutation):
    result = [0] * len(vector)
    for old, value in enumerate(vector):
        result[permutation[old]] = value
    return tuple(result)


def normalized_matrix(values, q=11):
    values = tuple(x % q for x in values)
    inverse = pow(next(x for x in values if x), -1, q)
    return tuple(x * inverse % q for x in values)


def determinant(g, q=11):
    return (g[0] * g[3] - g[1] * g[2]) % q


def point_action(g, q=11):
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


def matching_image(obj, permutation):
    return matching((permutation[a], permutation[b]) for a, b in obj)


def orbit(obj, permutations):
    return sorted({matching_image(obj, permutation) for permutation in permutations})


def rank_affine_retraction(ambient, subspace, permutations):
    def coords(vector, basis):
        pivots = [next(i for i, x in enumerate(row) if x) for row in basis]
        answer = tuple(vector[i] for i in pivots)
        assert tuple(sum(answer[k] * basis[k][j] for k in range(len(basis))) % P
                     for j in range(len(vector))) == tuple(vector)
        return answer

    def restricted(basis, permutation):
        return [coords(act(row, permutation), basis) for row in basis]

    ambient_actions = [restricted(ambient, g) for g in permutations]
    sub_actions = [restricted(subspace, g) for g in permutations]
    inclusion = [coords(row, ambient) for row in subspace]
    n, d = len(ambient), len(subspace)
    equations, values = [], []
    for aa, ss in zip(ambient_actions, sub_actions):
        for i in range(n):
            for j in range(d):
                equation = [0] * (n * d)
                for k in range(n):
                    equation[k * d + j] = (equation[k * d + j] + aa[i][k]) % P
                for k in range(d):
                    equation[i * d + k] = (equation[i * d + k] - ss[k][j]) % P
                equations.append(equation)
                values.append(0)
    for a in range(d):
        for j in range(d):
            equation = [0] * (n * d)
            for i in range(n):
                equation[i * d + j] = inclusion[a][i]
            equations.append(equation)
            values.append(int(a == j))
    return len(rr(equations)), len(rr([row + [value]
                                       for row, value in zip(equations, values)]))


def main():
    certificate = json.loads((NOTES / "2026-07-22-c471-hadamard-degeneration-complex.json").read_text())
    c465 = json.loads((NOTES / "2026-07-21-c465-mod3-weil-golay.json").read_text())
    c469 = json.loads((NOTES / "2026-07-21-c469-witt-golay-equivariance.json").read_text())
    c470 = json.loads((NOTES / "2026-07-22-c470-golay-hadamard-automorphisms.json").read_text())
    c406 = json.loads((NOTES / "2026-07-20-c406-matching-orbit-scout.json").read_text())
    c452 = json.loads((NOTES / "2026-07-21-c452-qr-barker.json").read_text())

    for name, record in certificate["inputs"].items():
        data = (ROOT / name).read_bytes()
        assert len(data) == record["bytes"]
        assert hashlib.sha256(data).hexdigest() == record["sha256"]

    supports = c469["object_orders"]["selected_supports"]
    hadamard = [[1] * 12]
    for support in supports:
        support = set(support)
        hadamard.append([(-1 if i in support else 1) for i in range(11)] + [-1])
    assert hadamard == certificate["integral_matrix_factorization"]["hadamard_matrix_H"]
    for i in range(12):
        for j in range(12):
            assert sum(hadamard[i][k] * hadamard[j][k] for k in range(12)) == 12 * (i == j)
            assert sum(hadamard[k][i] * hadamard[k][j] for k in range(12)) == 12 * (i == j)
    assert {tuple(x % 2 for x in row) for row in hadamard} == {tuple([1] * 12)}
    smith = certificate["integral_matrix_factorization"]["smith_normal_form"]["diagonal"]
    assert smith == [1] + [2] * 5 + [6] * 5 + [12]
    assert all(smith[i + 1] % smith[i] == 0 for i in range(11))
    assert all(smith[i] * smith[11 - i] == 12 for i in range(12))
    assert sum(value % 2 != 0 for value in smith) == 1
    assert sum(value % 3 != 0 for value in smith) == 6

    h3 = [[x % P for x in row] for row in hadamard]
    h3t = [list(row) for row in zip(*h3)]
    row_space = span(rr(h3))
    column_space = span(rr(h3t))
    kernel = set()
    transpose_kernel = set()
    for vector in itertools.product(range(P), repeat=12):
        if not any(multiply_vector(h3, vector)):
            kernel.add(vector)
        if not any(multiply_vector(h3t, vector)):
            transpose_kernel.add(vector)
    assert len(kernel) == len(transpose_kernel) == 729
    assert kernel == row_space
    assert transpose_kernel == column_space
    assert row_space != column_space
    for vector in kernel:
        divided = tuple(sum(hadamard[i][j] * vector[j] for j in range(12)) // 3 % 3
                        for i in range(12))
        assert multiply_vector(h3t, divided) == vector
    for vector in transpose_kernel:
        divided = tuple(sum(hadamard[j][i] * vector[j] for j in range(12)) // 3 % 3
                        for i in range(12))
        assert multiply_vector(h3, divided) == vector

    for source, recorded in zip(
            c470["second_order_signed_bipartite_geometry"]["generator_signing_equivariance"],
            certificate["c470_carrier_geometry"][
                "signed_adjoint_intertwiners_for_C470_standard_generators"]):
        signs = [1 if value == 1 else -1 for value in source["coordinate_signs"]]
        coordinate = [[0] * 12 for _ in range(12)]
        for old, new in enumerate(source["coordinate_permutation"]):
            coordinate[new][old] = signs[old]
        row = [[0] * 12 for _ in range(12)]
        for old, new in enumerate(source["Hadamard_row_permutation"]):
            transformed = tuple(sum(coordinate[i][j] * hadamard[old][j]
                                    for j in range(12)) for i in range(12))
            target = tuple(hadamard[new])
            scalar = 1 if transformed == target else -1
            assert transformed == tuple(scalar * x for x in target)
            row[new][old] = scalar
        assert coordinate == recorded["coordinate_signed_monomial_matrix_R"]
        assert row == recorded["Hadamard_row_signed_monomial_matrix_M"]
        for i in range(12):
            for j in range(12):
                left = sum(coordinate[i][k] * hadamard[j][k] for k in range(12))
                right = sum(hadamard[k][i] * row[k][j] for k in range(12))
                assert left == right

    punctured = {word[:11] for word in kernel}
    shortened = {word[:11] for word in kernel if word[11] == 0}
    assert len(punctured) == 729 and len(shortened) == 243

    base = matching(next(item for item in c406["types"] if item["type"] == "H3")[
        "coxeter_invariant_matching"])
    matrices = sorted({normalized_matrix(g) for g in itertools.product(range(11), repeat=4)
                       if determinant(g)})
    pgl = [point_action(g) for g in matrices]
    squares = {x * x % 11 for x in range(1, 11)}
    psl = [point_action(g) for g in matrices if determinant(g) in squares]
    all_objects = orbit(base, pgl)
    first_sheet = set(orbit(base, psl))
    c465_coordinates = [obj for obj in all_objects if obj not in first_sheet]
    c452_case = next(item for item in c452["cases"] if item["q"] == 11)
    c469_coordinates = [matching(obj) for obj in c452_case["sheets"][1]]
    index = {obj: i for i, obj in enumerate(c465_coordinates)}
    relabel = tuple(index[obj] for obj in c469_coordinates)
    assert list(relabel) == certificate["puncture_shorten_bridge"][
        "c465_coordinate_relabeling_old_c469_to_new_c465"]

    case = next(item for item in c465["cases"] if item["q"] == 11)
    perfect_basis = case["spaces"]["disjoint_row_span"]["basis"]
    core_basis = case["spaces"]["shared_edge_row_span"]["basis"]
    assert {act(word, relabel) for word in punctured} == span(rr(perfect_basis))
    assert {act(word, relabel) for word in shortened} == span(rr(core_basis))

    actions = c469["group"]["generator_actions"]
    permutations = [tuple(actions[name]["on_code_coordinates"])
                    for name in ("translation_T", "inversion_S")]
    assert all({act(word, g) for word in punctured} == punctured for g in permutations)
    assert all({act(word, g) for word in shortened} == shortened for g in permutations)
    augmentation = rr([[int(i == j) - int(j == 10) for j in range(11)] for i in range(10)])
    coefficient_rank, augmented_rank = rank_affine_retraction(
        augmentation, rr(shortened), permutations)
    assert (coefficient_rank, augmented_rank) == (50, 51)
    assert certificate["flag_from_operator"]["equivariant_retraction_system"][
        "retraction_exists"] is False

    print("C471 independent replay: PASS")


if __name__ == "__main__":
    main()
