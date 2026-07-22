#!/usr/bin/env python3
"""Independent replay of the C474 Ext and frozen-cocycle certificate."""

from __future__ import annotations

import hashlib
import itertools
import json
from collections import deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
CERT = NOTES / "2026-07-22-c474-uniform-ext-carrier.json"
C465 = NOTES / "2026-07-21-c465-mod3-weil-golay.json"
C473 = NOTES / "2026-07-22-c473-arithmetic-orientation.json"


def rank(vectors, p: int, width: int) -> int:
    pivots = {}
    for source in vectors:
        row = [x % p for x in source]
        while True:
            lead = next((j for j, x in enumerate(row) if x), None)
            if lead is None:
                break
            if lead not in pivots:
                scale = pow(row[lead], p - 2, p)
                pivots[lead] = tuple(scale * x % p for x in row)
                break
            scale = row[lead]
            row = [(x - scale * y) % p for x, y in zip(row, pivots[lead])]
    assert all(len(v) == width for v in pivots.values())
    return len(pivots)


def canonical_basis(vectors, p: int, width: int):
    rows = [[x % p for x in v] for v in vectors]
    out = []
    for col in range(width):
        pivot = next((i for i in range(len(out), len(rows)) if rows[i][col]), None)
        if pivot is None:
            continue
        rows[len(out)], rows[pivot] = rows[pivot], rows[len(out)]
        scale = pow(rows[len(out)][col], p - 2, p)
        rows[len(out)] = [scale * x % p for x in rows[len(out)]]
        for i in range(len(rows)):
            if i != len(out) and rows[i][col]:
                scale = rows[i][col]
                rows[i] = [(x - scale * y) % p for x, y in zip(rows[i], rows[len(out)])]
        out.append(tuple(rows[len(out)]))
    return tuple(out)


def kernel_basis(matrix, p: int, width: int):
    rows = [[x % p for x in row] for row in matrix]
    pivots = []
    for column in range(width):
        pivot = next((i for i in range(len(pivots), len(rows)) if rows[i][column]), None)
        if pivot is None:
            continue
        current = len(pivots)
        rows[current], rows[pivot] = rows[pivot], rows[current]
        scale = pow(rows[current][column], p - 2, p)
        rows[current] = [scale * x % p for x in rows[current]]
        for i in range(len(rows)):
            if i != current and rows[i][column]:
                scale = rows[i][column]
                rows[i] = [(x - scale * y) % p for x, y in zip(rows[i], rows[current])]
        pivots.append(column)
    reduced = rows[:len(pivots)]
    free = [i for i in range(width) if i not in pivots]
    out = []
    for column in free:
        vector = [0] * width
        vector[column] = 1
        for row, pivot in zip(reduced, pivots):
            vector[pivot] = (-row[column]) % p
        out.append(tuple(vector))
    return tuple(out)


def linear_solution(matrix, rhs, p: int):
    width = len(matrix[0])
    rows = [[x % p for x in row] + [value % p] for row, value in zip(matrix, rhs)]
    pivot_row = 0
    pivots = []
    for column in range(width):
        pivot = next((i for i in range(pivot_row, len(rows)) if rows[i][column]), None)
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        scale = pow(rows[pivot_row][column], p - 2, p)
        rows[pivot_row] = [scale * x % p for x in rows[pivot_row]]
        for i in range(len(rows)):
            if i != pivot_row and rows[i][column]:
                scale = rows[i][column]
                rows[i] = [(x - scale * y) % p for x, y in zip(rows[i], rows[pivot_row])]
        pivots.append(column)
        pivot_row += 1
    assert all(any(row[:-1]) or not row[-1] for row in rows)
    solution = [0] * width
    for row, column in zip(rows, pivots):
        solution[column] = row[-1]
    assert mv(matrix, solution, p) == tuple(x % p for x in rhs)
    return tuple(solution)


def nilpotent_data(operator, p: int, exponent: int):
    n = len(operator)
    ranks = [n]
    power = eye(n)
    for _ in range(exponent):
        power = mm(power, operator, p)
        ranks.append(rank(power, p, n))
    assert ranks[-1] == 0
    extended = ranks + [0]
    blocks = {}
    for size in range(1, exponent + 1):
        count = extended[size - 1] - 2 * extended[size] + extended[size + 1]
        if count:
            blocks[f"J{size}"] = count
    return {"nilpotent_power_ranks_including_identity": ranks, "jordan_blocks": blocks}


def determinant_from_flat(vector, d: int, p: int):
    matrix = [list(vector[i * d:(i + 1) * d]) for i in range(d)]
    determinant = 1
    for column in range(d):
        pivot = next((i for i in range(column, d) if matrix[i][column] % p), None)
        if pivot is None:
            return 0
        if pivot != column:
            matrix[column], matrix[pivot] = matrix[pivot], matrix[column]
            determinant = (-determinant) % p
        determinant = determinant * matrix[column][column] % p
        scale = pow(matrix[column][column] % p, p - 2, p)
        matrix[column] = [scale * x % p for x in matrix[column]]
        for i in range(column + 1, d):
            scale = matrix[i][column] % p
            matrix[i] = [(x - scale * y) % p for x, y in zip(matrix[i], matrix[column])]
    return determinant


def coordinates(vector, basis, p: int):
    d = len(basis)
    equations = [[basis[j][i] for j in range(d)] + [vector[i] % p] for i in range(len(vector))]
    row = 0
    pivots = []
    for col in range(d):
        pivot = next(i for i in range(row, len(equations)) if equations[i][col])
        equations[row], equations[pivot] = equations[pivot], equations[row]
        scale = pow(equations[row][col], p - 2, p)
        equations[row] = [scale * x % p for x in equations[row]]
        for i in range(len(equations)):
            if i != row and equations[i][col]:
                scale = equations[i][col]
                equations[i] = [(x - scale * y) % p for x, y in zip(equations[i], equations[row])]
        pivots.append((row, col))
        row += 1
    answer = [0] * d
    for i, col in pivots:
        answer[col] = equations[i][-1]
    assert all(sum(answer[j] * basis[j][i] for j in range(d)) % p == vector[i] % p for i in range(len(vector)))
    return tuple(answer)


def mm(a, b, p: int):
    columns = tuple(zip(*b))
    return tuple(tuple(sum(x * y for x, y in zip(row, col)) % p for col in columns) for row in a)


def mv(a, v, p: int):
    return tuple(sum(x * y for x, y in zip(row, v)) % p for row in a)


def eye(n: int):
    return tuple(tuple(int(i == j) for j in range(n)) for i in range(n))


def inverse(a, p: int):
    n = len(a)
    rows = [list(a[i]) + list(eye(n)[i]) for i in range(n)]
    for col in range(n):
        pivot = next(i for i in range(col, n) if rows[i][col] % p)
        rows[col], rows[pivot] = rows[pivot], rows[col]
        scale = pow(rows[col][col] % p, p - 2, p)
        rows[col] = [scale * x % p for x in rows[col]]
        for i in range(n):
            if i != col and rows[i][col] % p:
                scale = rows[i][col] % p
                rows[i] = [(x - scale * y) % p for x, y in zip(rows[i], rows[col])]
    return tuple(tuple(x % p for x in row[n:]) for row in rows)


def act(v, permutation):
    out = [0] * len(v)
    for old, value in enumerate(v):
        out[permutation[old]] = value
    return tuple(out)


def action_matrix(basis, permutation, p: int):
    return tuple(coordinates(act(v, permutation), basis, p) for v in basis)


def product(g, h):
    return tuple(h[g[i]] for i in range(len(g)))


def group_words(generators):
    identity = tuple(range(len(generators[0])))
    words = {identity: tuple()}
    queue = deque([identity])
    while queue:
        g = queue.popleft()
        for i, generator in enumerate(generators):
            h = product(g, generator)
            if h not in words:
                words[h] = words[g] + (i,)
                queue.append(h)
    return words


def hom_matrix(w, v, p: int):
    d = len(v)
    vi = inverse(v, p)
    images = []
    for index in range(d * d):
        unit = [[0] * d for _ in range(d)]
        unit[index // d][index % d] = 1
        image = mm(mm(w, unit, p), vi, p)
        images.append(tuple(x for row in image for x in row))
    return tuple(tuple(images[col][row] for col in range(d * d)) for row in range(d * d))


def intertwiner_summary(source_generators, target_generators, p: int):
    n = len(source_generators[0])
    equations = []
    for source, target in zip(source_generators, target_generators):
        for i in range(n):
            for j in range(n):
                equation = [0] * (n * n)
                for k in range(n):
                    equation[k * n + j] = (equation[k * n + j] + source[i][k]) % p
                    equation[i * n + k] = (equation[i * n + k] - target[k][j]) % p
                equations.append(tuple(equation))
    basis = kernel_basis(equations, p, n * n)
    invertible = []
    for coefficients in itertools.product(range(p), repeat=len(basis)):
        vector = tuple(sum(coefficients[k] * basis[k][i] for k in range(len(basis))) % p
                       for i in range(n * n))
        if rank([vector[i * n:(i + 1) * n] for i in range(n)], p, n) == n:
            invertible.append(vector)
    if not invertible:
        return None
    return {
        "hom_space_dimension": len(basis),
        "invertible_intertwiner_count": len(invertible),
        "canonical_intertwiner": list(min(invertible)),
        "intertwining_relations_verified": True,
    }


def idempotent_summary(generators, p: int):
    n = len(generators[0])
    equations = []
    for action in generators:
        for i in range(n):
            for j in range(n):
                equation = [0] * (n * n)
                for k in range(n):
                    equation[k * n + j] = (equation[k * n + j] + action[i][k]) % p
                    equation[i * n + k] = (equation[i * n + k] - action[k][j]) % p
                equations.append(tuple(equation))
    basis = kernel_basis(equations, p, n * n)
    counts = {}
    for coefficients in itertools.product(range(p), repeat=len(basis)):
        vector = tuple(sum(coefficients[k] * basis[k][i] for k in range(len(basis))) % p
                       for i in range(n * n))
        matrix = tuple(tuple(vector[i * n + j] for j in range(n)) for i in range(n))
        if mm(matrix, matrix, p) == matrix:
            matrix_rank = rank(matrix, p, n)
            counts[str(matrix_rank)] = counts.get(str(matrix_rank), 0) + 1
    return {"endomorphism_ring_dimension": len(basis), "idempotent_rank_counts": counts}


def word_action(generators, word, p: int):
    result = eye(len(generators[0]))
    for generator_index in word:
        result = mm(result, generators[generator_index], p)
    return result


def local_cocycle_spaces(generators, actions, p: int):
    words = group_words(generators)
    n = len(actions[0])
    width = len(generators) * n
    identity = tuple(range(len(generators[0])))
    expressions = {identity: tuple(tuple(0 for _ in range(width)) for _ in range(n))}
    group_actions = {identity: eye(n)}
    queue = deque([identity])
    constraints = []
    while queue:
        g = queue.popleft()
        for generator_index, generator in enumerate(generators):
            h = product(g, generator)
            injection = tuple(tuple(int(j == generator_index * n + i) for j in range(width))
                              for i in range(n))
            candidate = tuple(tuple((x + y) % p for x, y in zip(a, b)) for a, b in zip(
                expressions[g], mm(group_actions[g], injection, p)))
            action_h = mm(group_actions[g], actions[generator_index], p)
            if h not in expressions:
                expressions[h] = candidate
                group_actions[h] = action_h
                queue.append(h)
            else:
                constraints.extend(tuple((x - y) % p for x, y in zip(a, b))
                                   for a, b in zip(candidate, expressions[h]))
    z_basis = kernel_basis(constraints, p, width)
    coboundaries = []
    for j in range(n):
        vector = []
        for action in actions:
            vector.extend((int(i == j) - action[i][j]) % p for i in range(n))
        coboundaries.append(tuple(vector))
    return words, z_basis, canonical_basis(coboundaries, p, width)


def derive_case(record, upstream, oriented):
    q, p, d = record["q"], record["field"], record["endpoint_dimension"]
    core = tuple(tuple(x) for x in upstream["spaces"]["shared_edge_row_span"]["basis"])
    augmentation = canonical_basis(
        [tuple((int(i == j) - int(j == q - 1)) % p for j in range(q)) for i in range(q - 1)], p, q)
    basis = list(core)
    for vector in augmentation:
        if rank([*basis, vector], p, q) > len(basis):
            basis.append(vector)
    basis = tuple(basis)
    generators = [tuple(oriented["frozen_generators"][name]) for name in
                  ("T_permutation_old_to_new", "S_permutation_old_to_new")]
    assert [list(x) for x in generators] == record["generator_permutations"]
    carrier_actions = [action_matrix(basis, g, p) for g in generators]
    vs, ws, frozen_blocks, homs = [], [], [], []
    for matrix in carrier_actions:
        v = tuple(tuple(matrix[i][j] for j in range(d)) for i in range(d))
        assert not any(matrix[i][j] for i in range(d) for j in range(d, 2 * d))
        c = tuple(tuple(matrix[i][j] for j in range(d)) for i in range(d, 2 * d))
        w = tuple(tuple(matrix[i][j] for j in range(d, 2 * d)) for i in range(d, 2 * d))
        z = mm(c, inverse(v, p), p)
        vs.append(v)
        ws.append(w)
        frozen_blocks.append(z)
        homs.append(hom_matrix(w, v, p))
    assert [[list(row) for row in x] for x in frozen_blocks] == record["frozen_extension"]["generator_cocycle_matrices"]
    assert [[list(row) for row in x] for x in homs] == record["hom_generator_matrices"]

    words = group_words(generators)
    n, width = d * d, 2 * d * d
    actions = {}
    expressions = {}
    identity_perm = tuple(range(q))
    for g, word in words.items():
        action_now = eye(n)
        expression = [[0] * width for _ in range(n)]
        for s in word:
            for i in range(n):
                for j in range(n):
                    expression[i][s * n + j] = (expression[i][s * n + j] + action_now[i][j]) % p
            action_now = mm(action_now, homs[s], p)
        actions[g] = action_now
        expressions[g] = tuple(tuple(row) for row in expression)
    assert actions[identity_perm] == eye(n)

    constraints = []
    for g in words:
        for s, generator in enumerate(generators):
            h = product(g, generator)
            for i in range(n):
                candidate = list(expressions[g][i])
                for j in range(n):
                    candidate[s * n + j] = (candidate[s * n + j] + actions[g][i][j]) % p
                constraints.append(tuple((candidate[j] - expressions[h][i][j]) % p for j in range(width)))
    relation_rank = rank(constraints, p, width)
    z_dimension = width - relation_rank
    coboundaries = []
    for j in range(n):
        vector = []
        for h in homs:
            vector.extend((int(i == j) - h[i][j]) % p for i in range(n))
        coboundaries.append(tuple(vector))
    b_dimension = rank(coboundaries, p, width)
    frozen = tuple(x for block in frozen_blocks for row in block for x in row)
    assert all(sum(a * b for a, b in zip(row, frozen)) % p == 0 for row in constraints)
    assert rank([*coboundaries, frozen], p, width) == b_dimension + 1
    detector = tuple(record["cohomology"]["h1_coordinate_functional"])
    assert all(sum(a * b for a, b in zip(detector, coboundary)) % p == 0
               for coboundary in coboundaries)
    assert sum(a * b for a, b in zip(detector, record["cohomology"]["h1_basis"][0])) % p == 1
    assert sum(a * b for a, b in zip(detector, frozen)) % p == record["frozen_extension"]["h1_detector_value"]
    assert z_dimension - b_dimension == record["cohomology"]["h1_dimension"] == 1
    assert relation_rank == record["cohomology"]["relation_constraint_rank"]
    assert z_dimension == record["cohomology"]["z1_dimension"]
    assert b_dimension == record["cohomology"]["b1_dimension"]

    stored = {tuple(item["permutation"]): tuple(item["value"]) for item in record["frozen_extension"]["all_group_values"]}
    for g in words:
        assert stored[g] == mv(expressions[g], frozen, p)
    checks = 0
    for g in words:
        for h in words:
            gh = product(g, h)
            expected = tuple((x + y) % p for x, y in zip(stored[g], mv(actions[g], stored[h], p)))
            assert stored[gh] == expected
            checks += 1
    assert checks == record["frozen_extension"]["ordered_pair_cocycle_checks"]

    local_rows = {}
    local_examples = {}
    for g in words:
        if g == identity_perm:
            continue
        power = identity_perm
        order = 0
        while True:
            power = product(power, g)
            order += 1
            if power == identity_perm:
                break
        if order % p:
            continue
        action_g = actions[g]
        columns = [tuple((int(i == j) - action_g[i][j]) % p for i in range(n)) for j in range(n)]
        b1_local = rank(columns, p, n)
        detected = rank([*columns, stored[g]], p, n) == b1_local + 1
        norm = [[0] * n for _ in range(n)]
        action_power = eye(n)
        for _ in range(order):
            norm = [[(norm[i][j] + action_power[i][j]) % p for j in range(n)] for i in range(n)]
            action_power = mm(action_power, action_g, p)
        h1_local = n - rank(norm, p, n) - b1_local
        key = (order, h1_local, detected)
        local_rows[key] = local_rows.get(key, 0) + 1
        candidate = (len(words[g]), words[g], g, stored[g])
        if detected and (key not in local_examples or candidate < local_examples[key]):
            local_examples[key] = candidate
    replay_census = [{"element_order": order, "cyclic_h1_dimension": h1_local,
                      "frozen_restriction_nonzero": detected, "element_count": count}
                     for (order, h1_local, detected), count in sorted(local_rows.items())]
    local = record["local_detection"]
    assert replay_census == local["p_divisible_order_census"]
    target_order = local["minimal_detecting_cyclic_order"]
    target_key = next(key for key in local_examples if key[0] == target_order)
    example = local_examples[target_key]
    assert list(example[1]) == local["shortest_detecting_word_generator_indices"]
    assert list(example[2]) == local["shortest_detecting_permutation"]
    assert list(example[3]) == local["shortest_detecting_cocycle_value"]
    assert local["detecting_element_count_at_minimal_order"] == local_rows[target_key]
    assert local["detecting_cyclic_subgroup_count"] == local_rows[target_key] // 2
    target_g, target_z = example[2], example[3]
    target_action = actions[target_g]
    difference = tuple(tuple((target_action[i][j] - int(i == j)) % p for j in range(n)) for i in range(n))
    mechanism = local["local_module_mechanism"]
    assert nilpotent_data(difference, p, target_order) == mechanism["coefficient_module_jordan_decomposition"]
    difference_squared = mm(difference, difference, p)
    gauge = linear_solution(difference_squared, mv(difference, target_z, p), p)
    coboundary = tuple((gauge[i] - mv(target_action, gauge, p)[i]) % p for i in range(n))
    fixed_cocycle = tuple((target_z[i] + coboundary[i]) % p for i in range(n))
    assert list(gauge) == mechanism["canonical_gauge_vector"]
    assert list(fixed_cocycle) == mechanism["canonical_fixed_cocycle_value"]
    assert not any(mv(difference, fixed_cocycle, p))
    image_basis = canonical_basis([tuple(difference[i][j] for i in range(n)) for j in range(n)], p, n)
    fixed_basis = kernel_basis(difference, p, n)
    assert all(not any(mv(difference, vector, p)) for vector in fixed_basis)
    intersection_dimension = rank(difference, p, n) - rank(difference_squared, p, n)
    assert len(fixed_basis) == mechanism["fixed_space_dimension"]
    assert intersection_dimension == mechanism["image_intersection_fixed_dimension"]
    assert len(fixed_basis) - intersection_dimension == mechanism["fixed_quotient_dimension"] == 1
    assert rank([*image_basis, fixed_cocycle], p, n) == len(image_basis) + 1
    fixed_map_rank = rank([fixed_cocycle[i * d:(i + 1) * d] for i in range(d)], p, d)
    assert fixed_map_rank == mechanism["canonical_fixed_map_rank"]
    endpoint_jordan = {}
    for name, endpoint_generators in (("socle", vs), ("head", ws)):
        endpoint_action = eye(d)
        for generator_index in example[1]:
            endpoint_action = mm(endpoint_action, endpoint_generators[generator_index], p)
        endpoint_difference = tuple(tuple((endpoint_action[i][j] - int(i == j)) % p for j in range(d))
                                    for i in range(d))
        endpoint_jordan[name] = nilpotent_data(endpoint_difference, p, target_order)
    assert endpoint_jordan == mechanism["endpoint_jordan_decomposition"]
    assert endpoint_jordan["socle"] == endpoint_jordan["head"]
    assert mechanism["endpoints_are_isomorphic_on_detecting_cyclic_subgroup"] is True
    assert mechanism["endpoint_is_endotrivial"] is True
    assert mechanism["stable_endpoint_class"] == "Omega^1(J1)"
    assert mechanism["stable_hom_class"] == "J1; every other Hom summand is free/projective"
    orbit_model = mechanism["orbit_category_endpoint_model"]
    if p == 2:
        assert orbit_model == {
            "sylow_group": "D8",
            "stabilizer": "reflection subgroup H=<s> of order 2",
            "transitive_orbit": "D8/H of size 4",
            "endpoint": "reduced linearization ker(F2[D8/H] -> F2)",
            "projective_summand_dimension": 0,
        }
    else:
        assert orbit_model == {
            "sylow_group": "C3",
            "stabilizer": "trivial subgroup H=1",
            "transitive_orbit": "C3/H of size 3",
            "endpoint": "reduced linearization ker(F3[C3] -> F3) plus one free F3[C3] summand",
            "projective_summand_dimension": 3,
        }
    factorization_candidates = []
    fixed_image_basis = []
    for coefficients in itertools.product(range(p), repeat=len(fixed_basis)):
        vector = tuple(sum(coefficients[k] * fixed_basis[k][i] for k in range(len(fixed_basis))) % p
                       for i in range(n))
        if rank([*image_basis, vector], p, n) == len(image_basis):
            if rank([*fixed_image_basis, vector], p, n) > len(fixed_image_basis):
                fixed_image_basis = list(canonical_basis([*fixed_image_basis, vector], p, n))
        if rank([vector[i * d:(i + 1) * d] for i in range(d)], p, d) != d:
            continue
        difference_from_frozen = tuple((vector[i] - target_z[i]) % p for i in range(n))
        if rank([*image_basis, difference_from_frozen], p, n) == len(image_basis):
            factorization_candidates.append(vector)
    factorization = mechanism["local_character_intertwiner_factorization"]
    factorization_intertwiner = min(factorization_candidates)
    factorization_rhs = tuple((factorization_intertwiner[i] - target_z[i]) % p for i in range(n))
    identity_minus_action = tuple(tuple((int(i == j) - target_action[i][j]) % p for j in range(n))
                                  for i in range(n))
    factorization_gauge = linear_solution(identity_minus_action, factorization_rhs, p)
    assert len(factorization_candidates) == factorization["invertible_fixed_intertwiner_count_in_frozen_class"]
    assert list(factorization_intertwiner) == factorization["canonical_intertwiner"]
    assert list(factorization_gauge) == factorization["gauge_from_frozen_cocycle"]
    assert factorization["canonical_intertwiner_rank"] == d
    assert factorization["character_kernel_order"] == target_order // p
    determinant_record = mechanism["determinant_on_frozen_fixed_gauge_coset"]
    determinant_constant = determinant_from_flat(fixed_cocycle, d, p)
    determinant_coefficients = [
        (determinant_from_flat(tuple((fixed_cocycle[i] + basis_vector[i]) % p for i in range(n)), d, p)
         - determinant_constant) % p
        for basis_vector in fixed_image_basis]
    determinant_counts = {str(value): 0 for value in range(p)}
    for coefficients in itertools.product(range(p), repeat=len(fixed_image_basis)):
        vector = tuple((fixed_cocycle[i] + sum(coefficients[k] * fixed_image_basis[k][i]
                                               for k in range(len(fixed_image_basis)))) % p
                       for i in range(n))
        determinant = determinant_from_flat(vector, d, p)
        assert determinant == (determinant_constant
                               + sum(a * b for a, b in zip(coefficients, determinant_coefficients))) % p
        determinant_counts[str(determinant)] += 1
    assert determinant_record["coset_dimension"] == len(fixed_image_basis)
    assert determinant_record["affine_constant"] == determinant_constant
    assert determinant_record["value_counts"] == determinant_counts
    assert determinant_record["verified_on_every_coset_point"] is True
    carrier_action = eye(2 * d)
    split_action = eye(2 * d)
    for generator_index in example[1]:
        carrier_action = mm(carrier_action, carrier_actions[generator_index], p)
        v, w = vs[generator_index], ws[generator_index]
        split_generator = tuple(
            [tuple([*v[i], *([0] * d)]) for i in range(d)]
            + [tuple([*([0] * d), *w[i]]) for i in range(d)])
        split_action = mm(split_action, split_generator, p)
    carrier_difference = tuple(tuple((carrier_action[i][j] - int(i == j)) % p for j in range(2 * d))
                               for i in range(2 * d))
    split_difference = tuple(tuple((split_action[i][j] - int(i == j)) % p for j in range(2 * d))
                             for i in range(2 * d))
    surgery = mechanism["carrier_jordan_surgery"]
    assert nilpotent_data(carrier_difference, p, target_order) == surgery["nonsplit_carrier"]
    assert nilpotent_data(split_difference, p, target_order) == surgery["split_endpoint_sum"]
    assert surgery["top_nonzero_nilpotent_power"] == target_order - 1
    assert surgery["top_power_rank_gap_nonsplit_minus_split"] == 1
    if p == 2:
        square = product(target_g, target_g)
        square_action = actions[square]
        square_difference = tuple(tuple((square_action[i][j] - int(i == j)) % p for j in range(n)) for i in range(n))
        assert nilpotent_data(square_difference, p, 2) == mechanism["square_subgroup_jordan_decomposition"]
        square_value = tuple((fixed_cocycle[i] + mv(target_action, fixed_cocycle, p)[i]) % p for i in range(n))
        assert list(square_value) == mechanism["fixed_cocycle_value_on_square"]
        rank_distribution = {}
        nonzero_count = 0
        for coefficients in itertools.product(range(p), repeat=len(fixed_basis)):
            vector = tuple(sum(coefficients[k] * fixed_basis[k][i] for k in range(len(fixed_basis))) % p
                           for i in range(n))
            if rank([*image_basis, vector], p, n) == len(image_basis) + 1:
                nonzero_count += 1
                map_rank = rank([vector[i * d:(i + 1) * d] for i in range(d)], p, d)
                rank_distribution[str(map_rank)] = rank_distribution.get(str(map_rank), 0) + 1
        assert nonzero_count == mechanism["nonzero_fixed_class_representatives"]
        assert rank_distribution == mechanism["nonzero_fixed_class_map_rank_distribution"], (rank_distribution, mechanism["nonzero_fixed_class_map_rank_distribution"])
        assert mechanism["inflates_from_quotient_C4_over_C2"] is True
        inverse_target = next(h for h in words if product(target_g, h) == identity_perm)
        reflections = [h for h in words if product(product(h, target_g), h) == inverse_target
                       and product(h, h) == identity_perm]
        reflection = min(reflections, key=lambda h: (len(words[h]), words[h], h))
        sylow_generators = [target_g, reflection]
        sylow_hom_generators = [actions[target_g], actions[reflection]]
        sylow_words = group_words(sylow_generators)
        sylow_expressions = {}
        sylow_actions = {}
        for g, word in sylow_words.items():
            action_now = eye(n)
            expression = [[0] * (2 * n) for _ in range(n)]
            for s in word:
                for i in range(n):
                    for j in range(n):
                        expression[i][s * n + j] = (expression[i][s * n + j] + action_now[i][j]) % p
                action_now = mm(action_now, sylow_hom_generators[s], p)
            sylow_actions[g] = action_now
            sylow_expressions[g] = tuple(tuple(row) for row in expression)
        sylow_constraints = []
        for g in sylow_words:
            for s, generator in enumerate(sylow_generators):
                h = product(g, generator)
                for i in range(n):
                    candidate = list(sylow_expressions[g][i])
                    for j in range(n):
                        candidate[s * n + j] = (candidate[s * n + j] + sylow_actions[g][i][j]) % p
                    sylow_constraints.append(tuple((candidate[j] - sylow_expressions[h][i][j]) % p
                                                    for j in range(2 * n)))
        sylow_relation_rank = rank(sylow_constraints, p, 2 * n)
        sylow_z_basis = kernel_basis(sylow_constraints, p, 2 * n)
        sylow_coboundaries = []
        for j in range(n):
            vector = []
            for action in sylow_hom_generators:
                vector.extend((int(i == j) - action[i][j]) % p for i in range(n))
            sylow_coboundaries.append(tuple(vector))
        sylow_b_basis = canonical_basis(sylow_coboundaries, p, 2 * n)
        sylow_h_basis = []
        sylow_span = list(sylow_b_basis)
        for cocycle in sylow_z_basis:
            if rank([*sylow_span, cocycle], p, 2 * n) > len(sylow_span):
                sylow_h_basis.append(cocycle)
                sylow_span.append(cocycle)
        local_coboundaries = [tuple((int(i == j) - target_action[i][j]) % p for i in range(n))
                                for j in range(n)]
        local_b_rank = rank(local_coboundaries, p, n)
        restriction_rank = rank([*local_coboundaries, *(cocycle[:n] for cocycle in sylow_h_basis)], p, n) - local_b_rank
        frozen_sylow = tuple([*stored[target_g], *stored[reflection]])
        ladder = mechanism["binary_sylow_ladder"]
        assert list(words[reflection]) == ladder["reflection_word_generator_indices"]
        assert len(sylow_words) == ladder["sylow_order"] == 8
        assert len(words) // len(sylow_words) == ladder["sylow_index"] == 21
        assert sylow_relation_rank == ladder["relation_constraint_rank"]
        assert len(sylow_z_basis) == ladder["sylow_z1_dimension"]
        assert len(sylow_b_basis) == ladder["sylow_b1_dimension"]
        assert len(sylow_h_basis) == ladder["sylow_h1_dimension"]
        assert restriction_rank == ladder["restriction_to_C4_rank"]
        assert len(sylow_h_basis) - restriction_rank == ladder["restriction_to_C4_kernel_dimension"]
        assert rank([*sylow_b_basis, frozen_sylow], p, 2 * n) == len(sylow_b_basis) + 1
        assert ladder["frozen_sylow_class_nonzero"] is True
        assert ladder["global_restriction_is_injective_by_odd_index_transfer"] is True
        central_involution = product(target_g, target_g)
        central_coboundaries = [tuple((int(i == j) - actions[central_involution][i][j]) % p
                                      for i in range(n)) for j in range(n)]
        reflection_coboundaries = [tuple((int(i == j) - actions[reflection][i][j]) % p
                                         for i in range(n)) for j in range(n)]
        central_b_rank = rank(central_coboundaries, p, n)
        reflection_b_rank = rank(reflection_coboundaries, p, n)
        profiles = []
        for coefficients in itertools.product(range(p), repeat=len(sylow_h_basis)):
            if not any(coefficients):
                continue
            cocycle = tuple(sum(coefficients[k] * sylow_h_basis[k][i]
                                 for k in range(len(sylow_h_basis))) % p
                             for i in range(2 * n))
            central_value = mv(sylow_expressions[central_involution], cocycle, p)
            reflection_value = mv(sylow_expressions[reflection], cocycle, p)
            profiles.append({
                "h1_coordinates": list(coefficients),
                "C4_nonzero": rank([*local_coboundaries, cocycle[:n]], p, n) == local_b_rank + 1,
                "central_C2_nonzero": rank([*central_coboundaries, central_value], p, n) == central_b_rank + 1,
                "reflection_C2_nonzero": rank([*reflection_coboundaries, reflection_value], p, n) == reflection_b_rank + 1,
            })
        assert profiles == ladder["nonzero_h1_restriction_profiles"]
        conjugators = []
        for x in words:
            x_inverse = next(h for h in words if product(x, h) == identity_perm)
            if product(product(x, central_involution), x_inverse) == reflection:
                conjugators.append(x)
        conjugator = min(conjugators, key=lambda h: (len(words[h]), words[h], h))
        assert list(words[conjugator]) == ladder["central_to_reflection_conjugator_word_generator_indices"]
        assert len(conjugators) == ladder["central_to_reflection_conjugator_count"]
        frozen_coordinates = coordinates(frozen_sylow, [*sylow_b_basis, *sylow_h_basis], p)[-len(sylow_h_basis):]
        assert list(frozen_coordinates) == ladder["frozen_sylow_h1_coordinates"]
        assert ladder["reflection_restriction_kernel_dimension"] == 1
        assert ladder["fusion_stable_upper_bound_dimension"] == 1

        v4_replay = []
        for label, v4_reflection in (("<r^2,s>", reflection),
                                     ("<r^2,rs>", product(target_g, reflection))):
            v4_generators = [central_involution, v4_reflection]
            v4_words, v4_z_basis, v4_b_basis = local_cocycle_spaces(
                v4_generators, [actions[g] for g in v4_generators], 2)
            frozen_v4 = tuple([*stored[central_involution], *stored[v4_reflection]])
            frozen_nonzero = rank([*v4_b_basis, frozen_v4], 2, 2 * n) == len(v4_b_basis) + 1
            c2_restrictions = []
            for involution in sorted(g for g in v4_words if g != identity_perm):
                c2_coboundaries = [tuple((int(i == j) - actions[involution][i][j]) % 2
                                          for i in range(n)) for j in range(n)]
                c2_rank = rank(c2_coboundaries, 2, n)
                c2_restrictions.append(
                    rank([*c2_coboundaries, stored[involution]], 2, n) == c2_rank + 1)
            d8_profiles = []
            for coefficients in itertools.product(range(2), repeat=len(sylow_h_basis)):
                if not any(coefficients):
                    continue
                sylow_cocycle = tuple(sum(coefficients[k] * sylow_h_basis[k][i]
                                           for k in range(len(sylow_h_basis))) % 2
                                       for i in range(2 * n))
                v4_value = tuple([
                    *mv(sylow_expressions[central_involution], sylow_cocycle, 2),
                    *mv(sylow_expressions[v4_reflection], sylow_cocycle, 2),
                ])
                v4_nonzero = rank([*v4_b_basis, v4_value], 2, 2 * n) == len(v4_b_basis) + 1
                profile_c2 = []
                for involution in sorted(g for g in v4_words if g != identity_perm):
                    c2_coboundaries = [tuple((int(i == j) - actions[involution][i][j]) % 2
                                              for i in range(n)) for j in range(n)]
                    c2_rank = rank(c2_coboundaries, 2, n)
                    involution_value = mv(sylow_expressions[involution], sylow_cocycle, 2)
                    profile_c2.append(
                        rank([*c2_coboundaries, involution_value], 2, n) == c2_rank + 1)
                d8_profiles.append({
                    "d8_h1_coordinates": list(coefficients),
                    "v4_restriction_nonzero": v4_nonzero,
                    "three_C2_restrictions_nonzero": profile_c2,
                    "v4_restriction_is_essential": v4_nonzero and not any(profile_c2),
                })
            v4_replay.append({
                "subgroup": label,
                "h1_dimension": len(v4_z_basis) - len(v4_b_basis),
                "frozen_restriction_nonzero": frozen_nonzero,
                "frozen_restrictions_to_three_C2_subgroups_nonzero": c2_restrictions,
                "frozen_class_is_essential_on_V4": frozen_nonzero and not any(c2_restrictions),
                "all_nonzero_D8_h1_restriction_profiles": d8_profiles,
            })
        assert v4_replay == mechanism["binary_elementary_abelian_detection"]["subgroups_inside_recorded_D8"]

        full = mechanism["full_D8_realization"]
        elements = sorted(sylow_words)
        identity = identity_perm
        other_reflection = product(target_g, reflection)
        relative_modules = {}
        for label, subgroup_generator in (("H0=<s>", reflection), ("H1=<rs>", other_reflection)):
            subgroup = (identity, subgroup_generator)
            cosets = sorted({tuple(sorted(product(h, x) for h in subgroup)) for x in elements})
            coset_index = {coset: i for i, coset in enumerate(cosets)}
            coset_permutations = []
            for generator in (target_g, reflection):
                coset_permutations.append(tuple(coset_index[tuple(sorted(
                    product(h, product(coset[0], generator)) for h in subgroup))]
                    for coset in cosets))
            augmentation_basis = tuple(tuple(int(j == i) ^ int(j == 3) for j in range(4))
                                       for i in range(3))
            kernel_generators = [action_matrix(augmentation_basis, permutation, 2)
                                 for permutation in coset_permutations]
            dual_generators = [tuple(zip(*inverse(action, 2))) for action in kernel_generators]
            relative_modules[f"Omega(D8/{label})"] = kernel_generators
            relative_modules[f"Omega(D8/{label})^*"] = dual_generators

        endpoint_standard = {}
        for name, generators in (("socle", vs), ("head", ws)):
            endpoint_generators = [word_action(generators, words[target_g], 2),
                                   word_action(generators, words[reflection], 2)]
            matches = []
            for label, standard in relative_modules.items():
                summary = intertwiner_summary(endpoint_generators, standard, 2)
                if summary is not None:
                    matches.append((label, standard, summary))
            endpoint_record = full["endpoint_realizations"][name]
            assert [label for label, _, _ in matches] == endpoint_record["equivalent_relative_syzygy_descriptions"]
            label, standard, summary = matches[0]
            assert label == endpoint_record["relative_syzygy_identification"]
            assert summary == endpoint_record["relative_syzygy_explicit_isomorphism"]
            endpoint_standard[name] = standard

            end_generators = [hom_matrix(action, action, 2) for action in endpoint_generators]
            trace_zero_basis = canonical_basis([
                *(tuple(int(i == position) for i in range(9)) for position in (1, 2, 3, 5, 6, 7)),
                tuple(int(i in (0, 8)) for i in range(9)),
                tuple(int(i in (4, 8)) for i in range(9)),
            ], 2, 9)
            trace_actions = []
            for action in end_generators:
                trace_actions.append(tuple(coordinates(
                    tuple(sum(vector[k] * action[k][j] for k in range(9)) % 2 for j in range(9)),
                    trace_zero_basis, 2) for vector in trace_zero_basis))
            trace_group_actions = [word_action(trace_actions, word, 2) for word in sylow_words.values()]
            cyclic_vectors = []
            for coefficients in itertools.product(range(2), repeat=8):
                if not any(coefficients):
                    continue
                orbit = [tuple(sum(coefficients[k] * action[k][j] for k in range(8)) % 2
                               for j in range(8)) for action in trace_group_actions]
                if rank(orbit, 2, 8) == 8:
                    cyclic_vectors.append(coefficients)
            assert len(cyclic_vectors) == endpoint_record["regular_cyclic_vector_count"]
            assert list(min(cyclic_vectors)) == endpoint_record["canonical_regular_cyclic_vector_in_trace_zero_basis"]
            assert endpoint_record["projective_summand_dimension"] == 8
            assert endpoint_record["all_eight_orbit_vectors_are_a_basis"] is True

        standard_coefficient = [hom_matrix(w, v, 2) for v, w in zip(
            endpoint_standard["socle"], endpoint_standard["head"])]
        coefficient_summary = intertwiner_summary(
            [actions[target_g], actions[reflection]], standard_coefficient, 2)
        assert coefficient_summary == full["coefficient_module"]["relative_syzygy_square_explicit_isomorphism"]
        assert full["coefficient_module"]["dimension"] == 9
        element_index = {g: i for i, g in enumerate(elements)}
        regular_permutations = [tuple(element_index[product(h, generator)] for h in elements)
                                for generator in (target_g, reflection)]
        regular_generators = [action_matrix(eye(8), permutation, 2)
                              for permutation in regular_permutations]
        trivial_plus_regular = [tuple(
            [tuple([1, *([0] * 8)])]
            + [tuple([0, *row]) for row in regular]) for regular in regular_generators]
        assert intertwiner_summary([actions[target_g], actions[reflection]], trivial_plus_regular, 2) is None
        assert full["coefficient_module"]["not_isomorphic_to_trivial_plus_regular"] is True
        cover_rows = []
        for generator in (target_g, reflection):
            for h in elements:
                row = [0] * 8
                row[element_index[h]] = 1
                row[element_index[product(generator, h)]] ^= 1
                cover_rows.append(tuple(row))
        omega2_basis = kernel_basis(tuple(zip(*cover_rows)), 2, 16)
        domain_permutations = [tuple([*permutation, *(8 + i for i in permutation)])
                               for permutation in regular_permutations]
        omega2_generators = [action_matrix(omega2_basis, permutation, 2)
                             for permutation in domain_permutations]
        omega_minus2_generators = [tuple(zip(*inverse(action, 2))) for action in omega2_generators]
        assert intertwiner_summary([actions[target_g], actions[reflection]], omega2_generators, 2) is None
        assert intertwiner_summary([actions[target_g], actions[reflection]], omega_minus2_generators, 2) is None
        assert full["coefficient_module"]["not_isomorphic_to_ordinary_Omega_plus_or_minus_2"] is True
        assert idempotent_summary([actions[target_g], actions[reflection]], 2) == \
            full["coefficient_module"]["indecomposability_certificate"]
        assert full["full_sylow_endotriviality_proved_internally"] is True

    def centralizer_dimension(matrices):
        equations = []
        for a in matrices:
            for i in range(d):
                for j in range(d):
                    row = [0] * (d * d)
                    for k in range(d):
                        row[i * d + k] = (row[i * d + k] + a[k][j]) % p
                        row[k * d + j] = (row[k * d + j] - a[i][k]) % p
                    equations.append(tuple(row))
        return d * d - rank(equations, p, d * d)

    assert centralizer_dimension(vs) == centralizer_dimension(ws) == 1
    assert centralizer_dimension(carrier_actions) == record["carrier_rigidity"]["endomorphism_dimension"] == 1
    assert record["carrier_rigidity"]["automorphism_group_order"] == p - 1
    assert record["carrier_rigidity"]["projectivized_ext_points"] == 1
    assert record["carrier_rigidity"]["extension_middle_module_classes_split_vs_nonsplit"] == 2
    moduli = record["extension_moduli_groupoid"]
    assert moduli["cocycle_object_count"] == p ** z_dimension
    assert moduli["endpoint_fixed_gauge_group_order"] == p ** (d * d)
    assert moduli["gauge_action_is_free"] is True
    assert moduli["contractible_components_after_endpoint_fixed_gauge"] == p
    assert moduli["nonzero_components_before_endpoint_scalar_quotient"] == p - 1
    assert moduli["unpointed_nonsplit_components"] == 1
    assert moduli["unpointed_nonsplit_loop_group_order"] == p - 1
    assert moduli["unpointed_nonsplit_homotopy_type"] == ("point" if p == 2 else "B(C2)")
    assert moduli["coarse_nonzero_moduli_space"] == "P^0"
    assert moduli["geometric_nonzero_quotient_stack"] == "B(G_m); its F_p-rational loop group is F_p^*"
    assert len(words) == record["group_order"]
    return {"q": q, "relation_rank": relation_rank, "z1": z_dimension, "b1": b_dimension,
            "h1": z_dimension - b_dimension, "pair_checks": checks}


def main():
    certificate = json.loads(CERT.read_text())
    for item in certificate["inputs"].values():
        path = ROOT / item["path"]
        data = path.read_bytes()
        assert len(data) == item["bytes"]
        assert hashlib.sha256(data).hexdigest() == item["sha256"]
    c465 = {x["q"]: x for x in json.loads(C465.read_text())["cases"]}
    c473 = {x["q"]: x for x in json.loads(C473.read_text())["cases"]}
    results = [derive_case(case, c465[case["q"]], c473[case["q"]]) for case in certificate["cases"]]
    print(json.dumps({"status": "ok", "cases": results}, sort_keys=True))


if __name__ == "__main__":
    main()
