#!/usr/bin/env python3
"""Independent replay of the C474 Ext and frozen-cocycle certificate."""

from __future__ import annotations

import hashlib
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
