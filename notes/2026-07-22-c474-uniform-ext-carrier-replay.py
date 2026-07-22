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
