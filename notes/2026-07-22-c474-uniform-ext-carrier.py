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
    return rref(columns, p, 2 * n)[0], tuple(columns)


def solve_in_basis(v, basis, p: int):
    return coordinates(v, basis, p)


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
    values = all_group_cocycle(words, expressions, frozen_vector, p)
    pair_checks = verify_all_pairs(words, group_actions, values, p)
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
        },
        "frozen_extension": {
            "generator_cocycle_matrices": [[[x for x in row] for row in block[2]] for block in blocks],
            "generator_cocycle_vector": list(frozen_vector),
            "h1_coordinate_against_recorded_basis": quotient_coordinate,
            "is_nonzero": True,
            "all_group_values": [{"permutation": list(g), "value": list(values[g])} for g in ordered],
            "ordered_pair_cocycle_checks": pair_checks,
        },
        "endpoint_endomorphism_dimensions": {
            "socle": commutant_dimension(v_generators, p),
            "head": commutant_dimension(w_generators, p),
        },
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
        "schema": "c474-uniform-ext-carrier-v1",
        "inputs": {name: digest(path) for name, path in INPUTS.items()},
        "cases": cases,
        "theorem_scope": {
            "quantified_domain": ["frozen B3 matching sheet at (q,p)=(7,2)", "frozen H3 matching sheet at (q,p)=(11,3)"],
            "common_conclusion": "Ext^1_{F_p PSL_2(q)}(S_q^*,S_q) is one-dimensional and the frozen augmentation is its nonzero class; all nonzero classes give one module-isomorphism orbit",
            "uniform_family_status": "not asserted: the period and Gram identities do not define endpoint modules or control Ext outside the two frozen exceptional matching actions",
        },
        "trusted_boundary": ["exact prime-field linear algebra", "complete finite group enumeration from two frozen generators", "all ordered-pair cocycle verification"],
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
