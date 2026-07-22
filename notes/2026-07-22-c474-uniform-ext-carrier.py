#!/usr/bin/env python3
"""C474 exact Ext^1 certificates for the two frozen Lagrangian carriers."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import tempfile
from collections import deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
OUT = NOTES / "2026-07-22-c474-uniform-ext-carrier.json"
INPUTS = {
    "c406": NOTES / "2026-07-20-c406-matching-orbit-scout.json",
    "c465": NOTES / "2026-07-21-c465-mod3-weil-golay.json",
    "c471": NOTES / "2026-07-22-c471-hadamard-degeneration-complex.json",
    "c472": NOTES / "2026-07-22-c472-signed-weil-lift.json",
    "c473": NOTES / "2026-07-22-c473-arithmetic-orientation.json",
}


def digest(path: Path) -> dict[str, object]:
    data = path.read_bytes()
    return {"path": str(path.relative_to(ROOT)), "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}


def inv(x: int, p: int) -> int:
    return pow(x % p, p - 2, p)


def rref(rows, p: int, width: int | None = None):
    a = [[x % p for x in row] for row in rows if any(x % p for x in row)]
    n = width if width is not None else (len(rows[0]) if rows else 0)
    pivots = []
    for col in range(n):
        pivot = next((i for i in range(len(pivots), len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        rank = len(pivots)
        a[rank], a[pivot] = a[pivot], a[rank]
        scale = inv(a[rank][col], p)
        a[rank] = [(scale * x) % p for x in a[rank]]
        for i in range(len(a)):
            if i != rank and a[i][col]:
                scale = a[i][col]
                a[i] = [(x - scale * y) % p for x, y in zip(a[i], a[rank])]
        pivots.append(col)
    return [tuple(row) for row in a[:len(pivots)]], pivots


def nullspace(rows, p: int, width: int):
    rr, pivots = rref(rows, p, width)
    free = [j for j in range(width) if j not in pivots]
    basis = []
    for f in free:
        v = [0] * width
        v[f] = 1
        for i, col in enumerate(pivots):
            v[col] = (-rr[i][f]) % p
        basis.append(tuple(v))
    return basis


def coordinates(v, basis, p: int):
    if not basis:
        assert not any(x % p for x in v)
        return tuple()
    transposed = [list(col) for col in zip(*basis)]
    aug = [row + [x % p] for row, x in zip(transposed, v)]
    rr, pivots = rref(aug, p, len(basis) + 1)
    assert len([x for x in pivots if x < len(basis)]) == len(basis)
    out = [0] * len(basis)
    for row, col in zip(rr, pivots):
        if col < len(basis):
            out[col] = row[-1]
    assert tuple(sum(out[i] * basis[i][j] for i in range(len(basis))) % p for j in range(len(v))) == tuple(x % p for x in v)
    return tuple(out)


def matmul(a, b, p: int):
    if not a:
        return tuple()
    bt = tuple(zip(*b))
    return tuple(tuple(sum(x * y for x, y in zip(row, col)) % p for col in bt) for row in a)


def matvec(a, v, p: int):
    return tuple(sum(x * y for x, y in zip(row, v)) % p for row in a)


def identity(n: int):
    return tuple(tuple(int(i == j) for j in range(n)) for i in range(n))


def matrix_inverse(a, p: int):
    n = len(a)
    aug = [list(row) + list(identity(n)[i]) for i, row in enumerate(a)]
    rr, pivots = rref(aug, p, 2 * n)
    assert pivots[:n] == list(range(n))
    return tuple(tuple(row[n:]) for row in rr[:n])


def act_vector(v, perm):
    out = [0] * len(v)
    for i, x in enumerate(v):
        out[perm[i]] = x
    return tuple(out)


def restricted_matrix(basis, perm, p: int):
    return tuple(coordinates(act_vector(v, perm), basis, p) for v in basis)


def extend_basis(sub, ambient, p: int):
    out = list(sub)
    for row in ambient:
        if len(rref([*out, row], p)[0]) > len(out):
            out.append(row)
    assert len(out) == len(ambient)
    return tuple(out)


def compose_perm(g, h):
    """Product matching row actions: apply g, then h."""
    return tuple(h[g[i]] for i in range(len(g)))


def hom_action(w, v, p: int):
    """Matrix of F |-> w F v^-1 on row-major Hom(W,V)."""
    d = len(v)
    vinv = matrix_inverse(v, p)
    cols = []
    for k in range(d * d):
        f = [[0] * d for _ in range(d)]
        f[k // d][k % d] = 1
        image = matmul(matmul(w, f, p), vinv, p)
        cols.append(tuple(x for row in image for x in row))
    return tuple(tuple(cols[j][i] for j in range(d * d)) for i in range(d * d))


def block_data(action, d: int, p: int):
    v = tuple(tuple(action[i][j] for j in range(d)) for i in range(d))
    zero = tuple(tuple(action[i][j] for j in range(d, 2 * d)) for i in range(d))
    assert not any(any(row) for row in zero)
    c = tuple(tuple(action[i][j] for j in range(d)) for i in range(d, 2 * d))
    w = tuple(tuple(action[i][j] for j in range(d, 2 * d)) for i in range(d, 2 * d))
    z = matmul(c, matrix_inverse(v, p), p)
    return v, w, z


def enumerate_group(generators):
    ident = tuple(range(len(generators[0])))
    words = {ident: tuple()}
    queue = deque([ident])
    while queue:
        g = queue.popleft()
        for s, generator in enumerate(generators):
            h = compose_perm(g, generator)
            if h not in words:
                words[h] = words[g] + (s,)
                queue.append(h)
    return words


def cocycle_constraints(generators, hom_generators, p: int):
    words = enumerate_group(generators)
    n = len(hom_generators[0])
    width = len(generators) * n
    ident_perm = tuple(range(len(generators[0])))
    expressions = {ident_perm: tuple(tuple(0 for _ in range(width)) for _ in range(n))}
    actions = {ident_perm: identity(n)}
    constraints = []
    queue = deque([ident_perm])
    injections = []
    for s in range(len(generators)):
        injections.append(tuple(tuple(int(j == s * n + i) for j in range(width)) for i in range(n)))
    while queue:
        g = queue.popleft()
        for s, generator in enumerate(generators):
            h = compose_perm(g, generator)
            candidate = tuple(tuple((x + y) % p for x, y in zip(a, b)) for a, b in zip(
                expressions[g], matmul(actions[g], injections[s], p)))
            action_h = matmul(actions[g], hom_generators[s], p)
            if h not in expressions:
                expressions[h] = candidate
                actions[h] = action_h
                queue.append(h)
            else:
                assert actions[h] == action_h
                constraints.extend(tuple((x - y) % p for x, y in zip(a, b)) for a, b in zip(candidate, expressions[h]))
    constraint_rref, _ = rref(constraints, p, width)
    z_basis = nullspace(constraint_rref, p, width)
    return words, expressions, actions, constraint_rref, z_basis


def coboundaries(hom_generators, p: int):
    n = len(hom_generators[0])
    columns = []
    for j in range(n):
        column = []
        for action in hom_generators:
            column.extend((int(i == j) - action[i][j]) % p for i in range(n))
        columns.append(tuple(column))
    return rref(columns, p, len(hom_generators) * n)[0], tuple(columns)


def solve_in_basis(v, basis, p: int):
    return coordinates(v, basis, p)


def solve_affine(rows, rhs, p: int, width: int):
    augmented = [list(row) + [value % p] for row, value in zip(rows, rhs)]
    rr, pivots = rref(augmented, p, width + 1)
    assert width not in pivots
    solution = [0] * width
    for row, pivot in zip(rr, pivots):
        if pivot < width:
            solution[pivot] = row[-1]
    assert all(sum(a * b for a, b in zip(row, solution)) % p == value % p
               for row, value in zip(rows, rhs))
    return tuple(solution)


def commutant_dimension(generators, p: int):
    d = len(generators[0])
    rows = []
    for g in generators:
        for i in range(d):
            for j in range(d):
                row = [0] * (d * d)
                for k in range(d):
                    row[i * d + k] = (row[i * d + k] + g[k][j]) % p
                    row[k * d + j] = (row[k * d + j] - g[i][k]) % p
                rows.append(tuple(row))
    return d * d - len(rref(rows, p, d * d)[0])


def all_group_cocycle(perms, expressions, vector, p: int):
    return {g: matvec(expressions[g], vector, p) for g in perms}


def verify_all_pairs(perms, actions, values, p: int):
    checked = 0
    for g in perms:
        for h in perms:
            gh = compose_perm(g, h)
            rhs = tuple((x + y) % p for x, y in zip(values[g], matvec(actions[g], values[h], p)))
            assert values[gh] == rhs
            checked += 1
    return checked


def permutation_order(g):
    identity_perm = tuple(range(len(g)))
    power = identity_perm
    for order in range(1, len(g) * 4 + 1):
        power = compose_perm(power, g)
        if power == identity_perm:
            return order
    raise AssertionError("permutation order bound failed")


def nilpotent_jordan_data(operator, p: int, exponent: int):
    n = len(operator)
    ranks = [n]
    power = identity(n)
    for _ in range(exponent):
        power = matmul(power, operator, p)
        ranks.append(len(rref(power, p, n)[0]))
    assert ranks[-1] == 0
    blocks = {}
    extended = ranks + [0]
    for size in range(1, exponent + 1):
        count = extended[size - 1] - 2 * extended[size] + extended[size + 1]
        if count:
            blocks[f"J{size}"] = count
    assert sum(int(name[1:]) * count for name, count in blocks.items()) == n
    return {"nilpotent_power_ranks_including_identity": ranks, "jordan_blocks": blocks}


def matrix_rank_from_flat(vector, d: int, p: int):
    return len(rref([vector[i * d:(i + 1) * d] for i in range(d)], p, d)[0])


def matrix_determinant_from_flat(vector, d: int, p: int):
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
        scale = inv(matrix[column][column], p)
        matrix[column] = [x * scale % p for x in matrix[column]]
        for i in range(column + 1, d):
            scale = matrix[i][column] % p
            matrix[i] = [(x - scale * y) % p for x, y in zip(matrix[i], matrix[column])]
    return determinant


def word_matrix(generators, word, p: int):
    out = identity(len(generators[0]))
    for generator_index in word:
        out = matmul(out, generators[generator_index], p)
    return out


def module_intertwiner_data(source_generators, target_generators, p: int, required: bool = True):
    """Certify an isomorphism X with A X = X B for two row-action modules."""
    n = len(source_generators[0])
    equations = []
    for a, b in zip(source_generators, target_generators):
        for i in range(n):
            for j in range(n):
                row = [0] * (n * n)
                for k in range(n):
                    row[k * n + j] = (row[k * n + j] + a[i][k]) % p
                    row[i * n + k] = (row[i * n + k] - b[k][j]) % p
                equations.append(tuple(row))
    basis = nullspace(equations, p, n * n)
    assert len(basis) <= 20
    invertible = []
    for coefficients in itertools.product(range(p), repeat=len(basis)):
        vector = tuple(sum(coefficients[k] * basis[k][i] for k in range(len(basis))) % p
                       for i in range(n * n))
        if matrix_rank_from_flat(vector, n, p) == n:
            invertible.append(vector)
    if not invertible:
        assert not required
        return None
    canonical = min(invertible)
    return {
        "hom_space_dimension": len(basis),
        "invertible_intertwiner_count": len(invertible),
        "canonical_intertwiner": list(canonical),
        "intertwining_relations_verified": True,
    }


def module_idempotent_data(generators, p: int):
    n = len(generators[0])
    equations = []
    for action in generators:
        for i in range(n):
            for j in range(n):
                row = [0] * (n * n)
                for k in range(n):
                    row[k * n + j] = (row[k * n + j] + action[i][k]) % p
                    row[i * n + k] = (row[i * n + k] - action[k][j]) % p
                equations.append(tuple(row))
    basis = nullspace(equations, p, n * n)
    assert len(basis) <= 20
    idempotent_ranks = {}
    for coefficients in itertools.product(range(p), repeat=len(basis)):
        vector = tuple(sum(coefficients[k] * basis[k][i] for k in range(len(basis))) % p
                       for i in range(n * n))
        matrix = tuple(tuple(vector[i * n + j] for j in range(n)) for i in range(n))
        if matmul(matrix, matrix, p) == matrix:
            matrix_rank = matrix_rank_from_flat(vector, n, p)
            idempotent_ranks[str(matrix_rank)] = idempotent_ranks.get(str(matrix_rank), 0) + 1
    return {"endomorphism_ring_dimension": len(basis), "idempotent_rank_counts": idempotent_ranks}


def binary_d8_realization(words, hom_actions, v_generators, w_generators, target_g, reflection, p: int):
    """Realize the q=7 Sylow restriction by reflection-relative syzygies."""
    assert p == 2
    sylow_generators = [target_g, reflection]
    sylow_words = enumerate_group(sylow_generators)
    elements = sorted(sylow_words)
    element_index = {g: i for i, g in enumerate(elements)}
    target_word = words[target_g]
    reflection_word = words[reflection]
    coefficient_generators = [hom_actions[target_g], hom_actions[reflection]]

    identity_perm = tuple(range(len(target_g)))
    other_reflection = compose_perm(target_g, reflection)
    relative_modules = {}
    for label, subgroup_generator in (("H0=<s>", reflection), ("H1=<rs>", other_reflection)):
        subgroup = (identity_perm, subgroup_generator)
        cosets = sorted({tuple(sorted(compose_perm(h, x) for h in subgroup)) for x in elements})
        coset_index = {coset: i for i, coset in enumerate(cosets)}
        coset_permutations = []
        for generator in sylow_generators:
            coset_permutations.append(tuple(coset_index[tuple(sorted(
                compose_perm(h, compose_perm(coset[0], generator)) for h in subgroup))]
                for coset in cosets))
        augmentation_basis = tuple(tuple(int(j == i) ^ int(j == 3) for j in range(4)) for i in range(3))
        kernel_generators = [restricted_matrix(augmentation_basis, perm, 2) for perm in coset_permutations]
        dual_generators = [tuple(zip(*matrix_inverse(action, 2))) for action in kernel_generators]
        relative_modules[f"Omega(D8/{label})"] = kernel_generators
        relative_modules[f"Omega(D8/{label})^*"] = dual_generators

    endpoint_records = {}
    endpoint_standard_generators = {}
    for name, generators in (("socle", v_generators), ("head", w_generators)):
        endpoint_generators = [word_matrix(generators, target_word, 2),
                               word_matrix(generators, reflection_word, 2)]
        matches = []
        for label, standard_generators in relative_modules.items():
            isomorphism = module_intertwiner_data(
                endpoint_generators, standard_generators, 2, required=False)
            if isomorphism is not None:
                matches.append((label, standard_generators, isomorphism))
        assert len(matches) == 2, [label for label, _, _ in matches]
        relative_label, standard_generators, relative_isomorphism = matches[0]
        endpoint_standard_generators[name] = standard_generators
        end_generators = [hom_action(a, a, 2) for a in endpoint_generators]
        identity_vector = tuple(int(i == j) for i in range(3) for j in range(3))
        trace_zero_basis = rref([
            *(tuple(int(i == position) for i in range(9)) for position in (1, 2, 3, 5, 6, 7)),
            tuple(int(i in (0, 8)) for i in range(9)),
            tuple(int(i in (4, 8)) for i in range(9)),
        ], 2, 9)[0]
        assert len(trace_zero_basis) == 8
        assert all(sum(vector[i * 3 + i] for i in range(3)) % 2 == 0 for vector in trace_zero_basis)
        trace_zero_actions = []
        for action in end_generators:
            trace_zero_actions.append(tuple(coordinates(
                tuple(sum(vector[k] * action[k][j] for k in range(9)) % 2 for j in range(9)),
                trace_zero_basis, 2) for vector in trace_zero_basis))
        trace_zero_words = enumerate_group(sylow_generators)
        trace_zero_group_actions = {
            g: word_matrix(trace_zero_actions, trace_zero_words[g], 2) for g in trace_zero_words
        }
        cyclic_vectors = []
        for coefficients in itertools.product(range(2), repeat=8):
            if not any(coefficients):
                continue
            orbit = [tuple(sum(coefficients[k] * action[k][j] for k in range(8)) % 2
                           for j in range(8)) for action in trace_zero_group_actions.values()]
            if len(rref(orbit, 2, 8)[0]) == 8:
                cyclic_vectors.append(coefficients)
        assert cyclic_vectors
        endpoint_records[name] = {
            "relative_syzygy_identification": relative_label,
            "equivalent_relative_syzygy_descriptions": [label for label, _, _ in matches],
            "relative_syzygy_explicit_isomorphism": relative_isomorphism,
            "endomorphism_decomposition": "End(U)|D8 = k direct-sum kD8",
            "trivial_summand_generator_identity_matrix_flat": list(identity_vector),
            "projective_summand": "trace-zero endomorphisms",
            "projective_summand_dimension": 8,
            "regular_cyclic_vector_count": len(cyclic_vectors),
            "canonical_regular_cyclic_vector_in_trace_zero_basis": list(min(cyclic_vectors)),
            "all_eight_orbit_vectors_are_a_basis": True,
        }

    socle_standard = endpoint_standard_generators["socle"]
    head_standard = endpoint_standard_generators["head"]
    tensor_square_generators = [hom_action(w, v, 2) for v, w in zip(socle_standard, head_standard)]
    coefficient_isomorphism = module_intertwiner_data(
        coefficient_generators, tensor_square_generators, 2)
    regular_permutations = [tuple(element_index[compose_perm(h, generator)] for h in elements)
                            for generator in sylow_generators]
    regular_basis = identity(8)
    regular_generators = [restricted_matrix(regular_basis, permutation, 2)
                          for permutation in regular_permutations]
    trivial_plus_regular = [tuple(
        [tuple([1, *([0] * 8)])]
        + [tuple([0, *row]) for row in regular]) for regular in regular_generators]
    stable_trivial_isomorphism = module_intertwiner_data(
        coefficient_generators, trivial_plus_regular, 2, required=False)
    assert stable_trivial_isomorphism is None
    cover_rows = []
    for generator in sylow_generators:
        for h in elements:
            row = [0] * len(elements)
            row[element_index[h]] = 1
            row[element_index[compose_perm(generator, h)]] ^= 1
            cover_rows.append(tuple(row))
    omega2_basis = nullspace(tuple(zip(*cover_rows)), 2, 16)
    assert len(omega2_basis) == 9
    domain_permutations = [tuple([*permutation, *(8 + i for i in permutation)])
                           for permutation in regular_permutations]
    omega2_generators = [restricted_matrix(omega2_basis, permutation, 2)
                         for permutation in domain_permutations]
    omega_minus2_generators = [tuple(zip(*matrix_inverse(action, 2))) for action in omega2_generators]
    assert module_intertwiner_data(coefficient_generators, omega2_generators, 2, required=False) is None
    assert module_intertwiner_data(coefficient_generators, omega_minus2_generators, 2, required=False) is None
    coefficient_idempotents = module_idempotent_data(coefficient_generators, 2)
    assert coefficient_idempotents["idempotent_rank_counts"] == {"0": 1, "9": 1}

    return {
        "presentation": "D8=<r,s | r^4=s^2=1, srs=r^-1>",
        "generator_words_in_global_generator_indices": [list(target_word), list(reflection_word)],
        "endpoint_realizations": endpoint_records,
        "coefficient_module": {
            "dimension": 9,
            "realization": "Hom(U*,U)=U tensor U is the tensor square of the recorded reflection-relative syzygy",
            "relative_syzygy_square_explicit_isomorphism": coefficient_isomorphism,
            "r_restriction": "J4^2 direct-sum J1",
            "not_isomorphic_to_trivial_plus_regular": True,
            "not_isomorphic_to_ordinary_Omega_plus_or_minus_2": True,
            "indecomposability_certificate": coefficient_idempotents,
        },
        "cohomological_identification": "H^1(D8,Hom(U*,U)) is H^1 with coefficients in the square of a reflection-relative endotrivial generator",
        "full_sylow_endotriviality_proved_internally": True,
    }


def cyclic_restriction_data(words, actions, values, p: int, d: int):
    n = len(next(iter(actions.values())))
    identity_matrix = identity(n)
    census = {}
    examples = {}
    for g in words:
        order = permutation_order(g)
        if order % p:
            continue
        action = actions[g]
        columns = [tuple((int(i == j) - action[i][j]) % p for i in range(n)) for j in range(n)]
        b1_rank = len(rref(columns, p, n)[0])
        detected = len(rref([*columns, values[g]], p, n)[0]) == b1_rank + 1
        norm = [[0] * n for _ in range(n)]
        power = identity_matrix
        for _ in range(order):
            norm = [[(norm[i][j] + power[i][j]) % p for j in range(n)] for i in range(n)]
            power = matmul(power, action, p)
        h1_dimension = n - len(rref(norm, p, n)[0]) - b1_rank
        key = (order, h1_dimension, detected)
        census[key] = census.get(key, 0) + 1
        candidate = (len(words[g]), words[g], g, values[g])
        if detected and (key not in examples or candidate < examples[key]):
            examples[key] = candidate
    rows = [{"element_order": order, "cyclic_h1_dimension": h1_dimension,
             "frozen_restriction_nonzero": detected, "element_count": count}
            for (order, h1_dimension, detected), count in sorted(census.items())]
    target_order = 4 if p == 2 else 3
    target = next(row for row in rows if row["element_order"] == target_order and row["frozen_restriction_nonzero"])
    example = examples[(target_order, target["cyclic_h1_dimension"], True)]
    assert target["cyclic_h1_dimension"] == 1
    target_g, target_z = example[2], example[3]
    target_action = actions[target_g]
    difference = tuple(tuple((target_action[i][j] - int(i == j)) % p for j in range(n)) for i in range(n))
    target_jordan = nilpotent_jordan_data(difference, p, target_order)
    image_basis = rref([tuple(difference[i][j] for i in range(n)) for j in range(n)], p, n)[0]
    fixed_basis = nullspace(difference, p, n)
    fixed_image_intersection_dimension = len(image_basis) + len(fixed_basis) - len(rref([*image_basis, *fixed_basis], p, n)[0])
    assert len(fixed_basis) - fixed_image_intersection_dimension == 1
    difference_squared = matmul(difference, difference, p)
    gauge = solve_affine(difference_squared, matvec(difference, target_z, p), p, n)
    coboundary = tuple((gauge[i] - matvec(target_action, gauge, p)[i]) % p for i in range(n))
    fixed_cocycle = tuple((target_z[i] + coboundary[i]) % p for i in range(n))
    assert not any(matvec(difference, fixed_cocycle, p))
    assert len(rref([*image_basis, fixed_cocycle], p, n)[0]) == len(image_basis) + 1
    mechanism = {
        "coefficient_module_jordan_decomposition": target_jordan,
        "fixed_space_dimension": len(fixed_basis),
        "image_intersection_fixed_dimension": fixed_image_intersection_dimension,
        "fixed_quotient_dimension": 1,
        "canonical_gauge_vector": list(gauge),
        "canonical_fixed_cocycle_value": list(fixed_cocycle),
        "canonical_fixed_map_rank": matrix_rank_from_flat(fixed_cocycle, d, p),
        "cohomology_source": "the unique trivial J1 block; full-length Jordan blocks are free/projective",
    }
    factorization_candidates = []
    fixed_image_basis = []
    for coefficients in itertools.product(range(p), repeat=len(fixed_basis)):
        vector = tuple(sum(coefficients[k] * fixed_basis[k][i] for k in range(len(fixed_basis))) % p
                       for i in range(n))
        if len(rref([*image_basis, vector], p, n)[0]) == len(image_basis):
            if len(rref([*fixed_image_basis, vector], p, n)[0]) > len(fixed_image_basis):
                fixed_image_basis = list(rref([*fixed_image_basis, vector], p, n)[0])
        difference_from_frozen = tuple((vector[i] - target_z[i]) % p for i in range(n))
        if (matrix_rank_from_flat(vector, d, p) == d
                and len(rref([*image_basis, difference_from_frozen], p, n)[0]) == len(image_basis)):
            factorization_candidates.append(vector)
    assert len(fixed_image_basis) == fixed_image_intersection_dimension
    factorization_intertwiner = min(factorization_candidates)
    factorization_rhs = tuple((factorization_intertwiner[i] - target_z[i]) % p for i in range(n))
    factorization_gauge = solve_affine(
        tuple(tuple((int(i == j) - target_action[i][j]) % p for j in range(n)) for i in range(n)),
        factorization_rhs, p, n)
    mechanism["local_character_intertwiner_factorization"] = {
        "invertible_fixed_intertwiner_count_in_frozen_class": len(factorization_candidates),
        "canonical_intertwiner": list(factorization_intertwiner),
        "canonical_intertwiner_rank": d,
        "gauge_from_frozen_cocycle": list(factorization_gauge),
        "normal_form": "z(g^a)=a*phi for the additive character a in the coefficient field",
        "character_kernel_order": target_order // p,
    }
    determinant_constant = matrix_determinant_from_flat(fixed_cocycle, d, p)
    determinant_coefficients = [
        (matrix_determinant_from_flat(tuple((fixed_cocycle[i] + basis_vector[i]) % p for i in range(n)), d, p)
         - determinant_constant) % p
        for basis_vector in fixed_image_basis]
    determinant_counts = {str(value): 0 for value in range(p)}
    for coefficients in itertools.product(range(p), repeat=len(fixed_image_basis)):
        vector = tuple((fixed_cocycle[i] + sum(coefficients[k] * fixed_image_basis[k][i]
                                               for k in range(len(fixed_image_basis)))) % p
                       for i in range(n))
        determinant = matrix_determinant_from_flat(vector, d, p)
        affine_value = (determinant_constant
                        + sum(a * b for a, b in zip(coefficients, determinant_coefficients))) % p
        assert determinant == affine_value
        determinant_counts[str(determinant)] += 1
    mechanism["determinant_on_frozen_fixed_gauge_coset"] = {
        "coset_dimension": len(fixed_image_basis),
        "affine_constant": determinant_constant,
        "affine_linear_coefficients": determinant_coefficients,
        "value_counts": determinant_counts,
        "verified_on_every_coset_point": True,
    }
    if p == 2:
        square = compose_perm(target_g, target_g)
        square_action = actions[square]
        square_difference = tuple(tuple((square_action[i][j] - int(i == j)) % p for j in range(n)) for i in range(n))
        mechanism["square_subgroup_jordan_decomposition"] = nilpotent_jordan_data(square_difference, p, 2)
        mechanism["fixed_cocycle_value_on_square"] = list(tuple(
            (fixed_cocycle[i] + matvec(target_action, fixed_cocycle, p)[i]) % p for i in range(n)))
        assert not any(mechanism["fixed_cocycle_value_on_square"])
        fixed_vectors = [tuple(sum(coeff[k] * fixed_basis[k][i] for k in range(len(fixed_basis))) % p
                               for i in range(n))
                         for coeff in itertools.product(range(p), repeat=len(fixed_basis))]
        nonzero_class_fixed = [v for v in fixed_vectors
                               if len(rref([*image_basis, v], p, n)[0]) == len(image_basis) + 1]
        rank_distribution = {}
        for vector in nonzero_class_fixed:
            map_rank = matrix_rank_from_flat(vector, d, p)
            rank_distribution[str(map_rank)] = rank_distribution.get(str(map_rank), 0) + 1
        mechanism["nonzero_fixed_class_representatives"] = len(nonzero_class_fixed)
        mechanism["nonzero_fixed_class_map_rank_distribution"] = rank_distribution
        mechanism["inflates_from_quotient_C4_over_C2"] = True
        identity_perm = tuple(range(len(target_g)))
        inverse_target = next(h for h in words if compose_perm(target_g, h) == identity_perm)
        reflections = [h for h in words if permutation_order(h) == 2
                       and compose_perm(compose_perm(h, target_g), h) == inverse_target]
        reflection = min(reflections, key=lambda h: (len(words[h]), words[h], h))
        sylow_words, sylow_expressions, _, sylow_constraints, sylow_z_basis = cocycle_constraints(
            [target_g, reflection], [actions[target_g], actions[reflection]], p)
        sylow_b_basis, _ = coboundaries([actions[target_g], actions[reflection]], p)
        sylow_h_basis = []
        sylow_span = list(sylow_b_basis)
        for cocycle in sylow_z_basis:
            if len(rref([*sylow_span, cocycle], p, len(cocycle))[0]) > len(sylow_span):
                sylow_h_basis.append(cocycle)
                sylow_span.append(cocycle)
        local_b_basis, _ = coboundaries([actions[target_g]], p)
        restricted_h = [cocycle[:n] for cocycle in sylow_h_basis]
        restriction_rank = len(rref([*local_b_basis, *restricted_h], p, n)[0]) - len(local_b_basis)
        frozen_sylow = tuple([*values[target_g], *values[reflection]])
        central_involution = compose_perm(target_g, target_g)
        central_b_basis, _ = coboundaries([actions[central_involution]], p)
        reflection_b_basis, _ = coboundaries([actions[reflection]], p)
        restriction_profiles = []
        for coefficients in itertools.product(range(p), repeat=len(sylow_h_basis)):
            if not any(coefficients):
                continue
            cocycle = tuple(sum(coefficients[k] * sylow_h_basis[k][i]
                                 for k in range(len(sylow_h_basis))) % p
                             for i in range(2 * n))
            sylow_values = {g: matvec(sylow_expressions[g], cocycle, p) for g in sylow_words}
            restriction_profiles.append({
                "h1_coordinates": list(coefficients),
                "C4_nonzero": len(rref([*local_b_basis, cocycle[:n]], p, n)[0]) == len(local_b_basis) + 1,
                "central_C2_nonzero": len(rref([*central_b_basis, sylow_values[central_involution]], p, n)[0]) == len(central_b_basis) + 1,
                "reflection_C2_nonzero": len(rref([*reflection_b_basis, sylow_values[reflection]], p, n)[0]) == len(reflection_b_basis) + 1,
            })
        assert sum(not profile["reflection_C2_nonzero"] for profile in restriction_profiles) == 1
        assert not any(profile["central_C2_nonzero"] for profile in restriction_profiles)
        conjugators = []
        identity_perm = tuple(range(len(target_g)))
        for x in words:
            x_inverse = next(h for h in words if compose_perm(x, h) == identity_perm)
            if compose_perm(compose_perm(x, central_involution), x_inverse) == reflection:
                conjugators.append(x)
        conjugator = min(conjugators, key=lambda h: (len(words[h]), words[h], h))
        frozen_sylow_coordinates = solve_in_basis(frozen_sylow, [*sylow_b_basis, *sylow_h_basis], p)[-len(sylow_h_basis):]
        mechanism["binary_sylow_ladder"] = {
            "sylow_group": "D8",
            "sylow_order": len(sylow_words),
            "sylow_index": len(words) // len(sylow_words),
            "reflection_word_generator_indices": list(words[reflection]),
            "sylow_z1_dimension": len(sylow_z_basis),
            "sylow_b1_dimension": len(sylow_b_basis),
            "sylow_h1_dimension": len(sylow_h_basis),
            "restriction_to_C4_rank": restriction_rank,
            "restriction_to_C4_kernel_dimension": len(sylow_h_basis) - restriction_rank,
            "global_restriction_image_dimension": 1,
            "global_restriction_is_injective_by_odd_index_transfer": True,
            "frozen_sylow_class_nonzero": len(rref([*sylow_b_basis, frozen_sylow], p, len(frozen_sylow))[0]) == len(sylow_b_basis) + 1,
            "relation_constraint_rank": len(sylow_constraints),
            "nonzero_h1_restriction_profiles": restriction_profiles,
            "central_to_reflection_conjugator_word_generator_indices": list(words[conjugator]),
            "central_to_reflection_conjugator_count": len(conjugators),
            "reflection_restriction_kernel_dimension": 1,
            "fusion_stable_upper_bound_dimension": 1,
            "frozen_sylow_h1_coordinates": list(frozen_sylow_coordinates),
            "structural_global_dimension_proof": "odd-index transfer injects global H1 into D8 H1; involution fusion forces the reflection-kernel line; the frozen class is nonzero on that line",
        }
        v4_records = []
        for label, v4_reflection in (("<r^2,s>", reflection),
                                     ("<r^2,rs>", compose_perm(target_g, reflection))):
            v4_generators = [central_involution, v4_reflection]
            v4_actions = [actions[g] for g in v4_generators]
            v4_words, _, _, _, v4_z_basis = cocycle_constraints(v4_generators, v4_actions, p)
            v4_b_basis, _ = coboundaries(v4_actions, p)
            frozen_v4 = tuple([*values[central_involution], *values[v4_reflection]])
            v4_h_dimension = len(v4_z_basis) - len(v4_b_basis)
            frozen_nonzero = len(rref([*v4_b_basis, frozen_v4], p, 2 * n)[0]) == len(v4_b_basis) + 1
            involution_restrictions = []
            for involution in sorted(g for g in v4_words if g != identity_perm):
                involution_b, _ = coboundaries([actions[involution]], p)
                involution_restrictions.append(
                    len(rref([*involution_b, values[involution]], p, n)[0]) == len(involution_b) + 1)
            assert not any(involution_restrictions)
            d8_profiles = []
            for coefficients in itertools.product(range(p), repeat=len(sylow_h_basis)):
                if not any(coefficients):
                    continue
                sylow_cocycle = tuple(sum(coefficients[k] * sylow_h_basis[k][i]
                                           for k in range(len(sylow_h_basis))) % p
                                       for i in range(2 * n))
                v4_value = tuple([
                    *matvec(sylow_expressions[central_involution], sylow_cocycle, p),
                    *matvec(sylow_expressions[v4_reflection], sylow_cocycle, p),
                ])
                v4_nonzero = len(rref([*v4_b_basis, v4_value], p, 2 * n)[0]) == len(v4_b_basis) + 1
                c2_nonzero = []
                for involution in sorted(g for g in v4_words if g != identity_perm):
                    involution_b, _ = coboundaries([actions[involution]], p)
                    involution_value = matvec(sylow_expressions[involution], sylow_cocycle, p)
                    c2_nonzero.append(
                        len(rref([*involution_b, involution_value], p, n)[0]) == len(involution_b) + 1)
                d8_profiles.append({
                    "d8_h1_coordinates": list(coefficients),
                    "v4_restriction_nonzero": v4_nonzero,
                    "three_C2_restrictions_nonzero": c2_nonzero,
                    "v4_restriction_is_essential": v4_nonzero and not any(c2_nonzero),
                })
            v4_records.append({
                "subgroup": label,
                "h1_dimension": v4_h_dimension,
                "frozen_restriction_nonzero": frozen_nonzero,
                "frozen_restrictions_to_three_C2_subgroups_nonzero": involution_restrictions,
                "frozen_class_is_essential_on_V4": frozen_nonzero,
                "all_nonzero_D8_h1_restriction_profiles": d8_profiles,
            })
        mechanism["binary_elementary_abelian_detection"] = {
            "subgroups_inside_recorded_D8": v4_records,
            "definition_of_essential_here": "nonzero on V4 and zero on every proper nontrivial subgroup C2",
        }
    return {
        "p_divisible_order_census": rows,
        "minimal_detecting_cyclic_order": target_order,
        "detecting_element_count_at_minimal_order": target["element_count"],
        "detecting_cyclic_subgroup_count": target["element_count"] // 2,
        "restriction_isomorphism": "global H1 and target cyclic H1 are one-dimensional and restriction is nonzero",
        "shortest_detecting_word_generator_indices": list(example[1]),
        "shortest_detecting_permutation": list(example[2]),
        "shortest_detecting_cocycle_value": list(example[3]),
        "local_module_mechanism": mechanism,
    }


def matching_case(q: int, p: int, type_name: str, frozen, upstream):
    # Reuse only C406's frozen matching; all sheets, relations, and actions are rebuilt here.
    def norm(a, b, c, d):
        values = (a % q, b % q, c % q, d % q)
        first = next(x for x in values if x)
        scale = pow(first, q - 2, q)
        return tuple(x * scale % q for x in values)

    matrices = sorted({norm(a, b, c, d) for a, b, c, d in itertools.product(range(q), repeat=4)
                       if (a * d - b * c) % q})

    def point_perm(g):
        a, b, c, d = g
        out = []
        for x in range(q + 1):
            if x == q:
                out.append(q if c == 0 else a * inv(c, q) % q)
            else:
                den = (c * x + d) % q
                out.append(q if den == 0 else (a * x + b) * inv(den, q) % q)
        return tuple(out)

    def canon(pairs):
        return tuple(sorted(tuple(sorted(pair)) for pair in pairs))

    def act_matching(perm, matching):
        return canon((perm[a], perm[b]) for a, b in matching)

    def orbit(base, perms):
        return sorted({act_matching(g, base) for g in perms})

    base = canon(frozen["coxeter_invariant_matching"])
    pgl_perms = [point_perm(g) for g in matrices]
    psl_perms = [perm for g, perm in zip(matrices, pgl_perms)
                 if pow((g[0] * g[3] - g[1] * g[2]) % q, (q - 1) // 2, q) == 1]
    all_matchings = orbit(base, pgl_perms)
    sheet0 = orbit(base, psl_perms)
    sheet1 = [x for x in all_matchings if x not in set(sheet0)]
    index = {x: i for i, x in enumerate(sheet1)}
    point_generators = [point_perm((1, 1, 0, 1)), point_perm((0, q - 1, 1, 0))]
    generators = [tuple(index[act_matching(g, x)] for x in sheet1) for g in point_generators]

    def relation(shared):
        return [tuple(int((len(set(a) & set(b)) == 1) == shared) for b in sheet1) for a in sheet0]

    shared = rref(relation(True), p, q)[0]
    disjoint = rref(relation(False), p, q)[0]
    assert [list(x) for x in shared] == upstream["spaces"]["shared_edge_row_span"]["basis"]
    assert [list(x) for x in disjoint] == upstream["spaces"]["disjoint_row_span"]["basis"]
    augmentation = rref([tuple((int(i == j) - int(j == q - 1)) % p for j in range(q)) for i in range(q - 1)], p, q)[0]
    carrier_basis = extend_basis(shared, augmentation, p)
    d = len(shared)
    actions = [restricted_matrix(carrier_basis, g, p) for g in generators]
    blocks = [block_data(a, d, p) for a in actions]
    v_generators = [x[0] for x in blocks]
    w_generators = [x[1] for x in blocks]
    frozen_vector = tuple(x for block in blocks for row in block[2] for x in row)
    hom_generators = [hom_action(w, v, p) for v, w, _ in blocks]
    words, expressions, group_actions, constraints, z_basis = cocycle_constraints(generators, hom_generators, p)
    b_basis, _ = coboundaries(hom_generators, p)
    h_basis = []
    span = list(b_basis)
    for z in z_basis:
        if len(rref([*span, z], p, len(z))[0]) > len(span):
            h_basis.append(z)
            span.append(z)
    assert len(h_basis) == 1
    assert len(rref([*b_basis, frozen_vector], p, len(frozen_vector))[0]) == len(b_basis) + 1
    quotient_coordinate = solve_in_basis(frozen_vector, [*b_basis, *h_basis], p)[-1]
    detector = solve_affine([*b_basis, *h_basis], [0] * len(b_basis) + [1], p, len(frozen_vector))
    assert all(sum(a * b for a, b in zip(detector, coboundary)) % p == 0 for coboundary in b_basis)
    assert sum(a * b for a, b in zip(detector, h_basis[0])) % p == 1
    assert sum(a * b for a, b in zip(detector, frozen_vector)) % p == quotient_coordinate
    values = all_group_cocycle(words, expressions, frozen_vector, p)
    pair_checks = verify_all_pairs(words, group_actions, values, p)
    local_detection = cyclic_restriction_data(words, group_actions, values, p, d)
    detecting_word = local_detection["shortest_detecting_word_generator_indices"]
    endpoint_jordan = {}
    for name, endpoint_generators in (("socle", v_generators), ("head", w_generators)):
        endpoint_action = word_matrix(endpoint_generators, detecting_word, p)
        endpoint_difference = tuple(tuple((endpoint_action[i][j] - int(i == j)) % p for j in range(d))
                                    for i in range(d))
        endpoint_jordan[name] = nilpotent_jordan_data(
            endpoint_difference, p, local_detection["minimal_detecting_cyclic_order"])
    assert endpoint_jordan["socle"] == endpoint_jordan["head"]
    mechanism = local_detection["local_module_mechanism"]
    mechanism["endpoint_jordan_decomposition"] = endpoint_jordan
    mechanism["endpoints_are_isomorphic_on_detecting_cyclic_subgroup"] = True
    full_block = f"J{local_detection['minimal_detecting_cyclic_order']}"
    hom_blocks = mechanism["coefficient_module_jordan_decomposition"]["jordan_blocks"]
    assert hom_blocks.get("J1") == 1 and set(hom_blocks) <= {"J1", full_block}
    mechanism["endpoint_is_endotrivial"] = True
    mechanism["stable_endpoint_class"] = "Omega^1(J1)"
    mechanism["stable_hom_class"] = "J1; every other Hom summand is free/projective"
    carrier_action = word_matrix(actions, detecting_word, p)
    carrier_difference = tuple(tuple((carrier_action[i][j] - int(i == j)) % p for j in range(2 * d))
                               for i in range(2 * d))
    split_generators = []
    for v, w in zip(v_generators, w_generators):
        split_generators.append(tuple(
            [tuple([*v[i], *([0] * d)]) for i in range(d)]
            + [tuple([*([0] * d), *w[i]]) for i in range(d)]))
    split_action = word_matrix(split_generators, detecting_word, p)
    split_difference = tuple(tuple((split_action[i][j] - int(i == j)) % p for j in range(2 * d))
                             for i in range(2 * d))
    carrier_jordan = nilpotent_jordan_data(
        carrier_difference, p, local_detection["minimal_detecting_cyclic_order"])
    split_jordan = nilpotent_jordan_data(
        split_difference, p, local_detection["minimal_detecting_cyclic_order"])
    assert (carrier_jordan["nilpotent_power_ranks_including_identity"][-2]
            == split_jordan["nilpotent_power_ranks_including_identity"][-2] + 1)
    mechanism["carrier_jordan_surgery"] = {
        "nonsplit_carrier": carrier_jordan,
        "split_endpoint_sum": split_jordan,
        "top_nonzero_nilpotent_power": local_detection["minimal_detecting_cyclic_order"] - 1,
        "top_power_rank_gap_nonsplit_minus_split": 1,
        "diagnostic": "the local carrier is nonsplit exactly when the recorded top nilpotent-power rank jumps by one",
    }
    if p == 2:
        target_g = tuple(local_detection["shortest_detecting_permutation"])
        reflection_word = tuple(mechanism["binary_sylow_ladder"]["reflection_word_generator_indices"])
        reflection = next(g for g in words if words[g] == reflection_word)
        mechanism["full_D8_realization"] = binary_d8_realization(
            words, group_actions, v_generators, w_generators, target_g, reflection, p)
        mechanism["orbit_category_endpoint_model"] = {
            "sylow_group": "D8",
            "stabilizer": "reflection subgroup H=<s> of order 2",
            "transitive_orbit": "D8/H of size 4",
            "endpoint": "reduced linearization ker(F2[D8/H] -> F2)",
            "projective_summand_dimension": 0,
        }
    else:
        mechanism["orbit_category_endpoint_model"] = {
            "sylow_group": "C3",
            "stabilizer": "trivial subgroup H=1",
            "transitive_orbit": "C3/H of size 3",
            "endpoint": "reduced linearization ker(F3[C3] -> F3) plus one free F3[C3] summand",
            "projective_summand_dimension": 3,
        }
    ordered = sorted(words)
    return {
        "q": q,
        "field": p,
        "group": f"PSL_2({q})",
        "group_order": len(words),
        "endpoint_dimension": d,
        "generator_permutations": [list(x) for x in generators],
        "socle_generator_matrices": [[list(row) for row in x] for x in v_generators],
        "head_generator_matrices": [[list(row) for row in x] for x in w_generators],
        "hom_generator_matrices": [[list(row) for row in x] for x in hom_generators],
        "cohomology": {
            "cochain_parameter_dimension": 2 * d * d,
            "relation_constraint_rank": len(constraints),
            "z1_dimension": len(z_basis),
            "b1_dimension": len(b_basis),
            "h1_dimension": len(h_basis),
            "z1_basis": [list(x) for x in z_basis],
            "b1_rref_basis": [list(x) for x in b_basis],
            "h1_basis": [list(x) for x in h_basis],
            "h1_coordinate_functional": list(detector),
        },
        "frozen_extension": {
            "generator_cocycle_matrices": [[[x for x in row] for row in block[2]] for block in blocks],
            "generator_cocycle_vector": list(frozen_vector),
            "h1_coordinate_against_recorded_basis": quotient_coordinate,
            "h1_detector_value": quotient_coordinate,
            "is_nonzero": True,
            "all_group_values": [{"permutation": list(g), "value": list(values[g])} for g in ordered],
            "ordered_pair_cocycle_checks": pair_checks,
        },
        "endpoint_endomorphism_dimensions": {
            "socle": commutant_dimension(v_generators, p),
            "head": commutant_dimension(w_generators, p),
        },
        "carrier_rigidity": {
            "endomorphism_dimension": commutant_dimension(actions, p),
            "automorphism_group_order": p - 1,
            "projectivized_ext_points": 1,
            "extension_middle_module_classes_split_vs_nonsplit": 2,
        },
        "extension_moduli_groupoid": {
            "cocycle_object_count": p ** len(z_basis),
            "endpoint_fixed_gauge_group_order": p ** (d * d),
            "gauge_action_is_free": len(b_basis) == d * d,
            "contractible_components_after_endpoint_fixed_gauge": p,
            "nonzero_components_before_endpoint_scalar_quotient": p - 1,
            "unpointed_nonsplit_components": 1,
            "unpointed_nonsplit_loop_group_order": p - 1,
            "unpointed_nonsplit_homotopy_type": "point" if p == 2 else "B(C2)",
            "coarse_nonzero_moduli_space": "P^0",
            "geometric_nonzero_quotient_stack": "B(G_m); its F_p-rational loop group is F_p^*",
        },
        "local_detection": local_detection,
        "nonzero_ext_orbit": {
            "number_of_nonzero_classes": p - 1,
            "endpoint_scalar_group_order": (p - 1) ** 2,
            "number_of_orbits": 1,
            "module_isomorphism_classes_of_nonsplit_extensions": 1,
        },
    }


def build_certificate():
    frozen_data = json.loads(INPUTS["c406"].read_text())
    frozen = {x["type"]: x for x in frozen_data["types"]}
    upstream = {x["q"]: x for x in json.loads(INPUTS["c465"].read_text())["cases"]}
    cases = [matching_case(7, 2, "B3", frozen["B3"], upstream[7]),
             matching_case(11, 3, "H3", frozen["H3"], upstream[11])]
    return {
        "schema": "c474-uniform-ext-carrier-v2",
        "inputs": {name: digest(path) for name, path in INPUTS.items()},
        "cases": cases,
        "theorem_scope": {
            "quantified_domain": ["frozen B3 matching sheet at (q,p)=(7,2)", "frozen H3 matching sheet at (q,p)=(11,3)"],
            "common_conclusion": "Ext^1_{F_p PSL_2(q)}(S_q^*,S_q) is one-dimensional and the frozen augmentation is its nonzero class; all nonzero classes give one module-isomorphism orbit",
            "uniform_family_status": "not asserted: the period and Gram identities do not define endpoint modules or control Ext outside the two frozen exceptional matching actions",
        },
        "trusted_boundary": ["exact prime-field linear algebra", "complete finite group enumeration from two frozen generators", "all ordered-pair cocycle verification", "explicit Sylow-module intertwiners and exhaustive D8 endomorphism-ring idempotent check"],
    }


def canonical_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = canonical_bytes(build_certificate())
    if args.check:
        assert OUT.read_bytes() == data
        print(f"checked {OUT.relative_to(ROOT)} ({len(data)} bytes)")
    else:
        with tempfile.NamedTemporaryFile(dir=OUT.parent, delete=False) as handle:
            handle.write(data)
            temp = Path(handle.name)
        temp.replace(OUT)
        print(f"wrote {OUT.relative_to(ROOT)} ({len(data)} bytes)")


if __name__ == "__main__":
    main()
