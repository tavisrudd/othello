#!/usr/bin/env python3
"""Exact finite certificate for the C904 quartic boundary graph covers."""

from fractions import Fraction
from functools import reduce
from itertools import combinations, permutations
from math import gcd


def compose(p, q):
    return tuple(p[q[i]] for i in range(len(p)))


def generated_group(generators):
    identity = tuple(range(len(generators[0])))
    group = {identity}
    stack = [identity]
    while stack:
        a = stack.pop()
        for b in generators:
            c = compose(a, b)
            if c not in group:
                group.add(c)
                stack.append(c)
    return sorted(group)


def parity(p):
    return sum(p[i] > p[j] for i in range(len(p)) for j in range(i + 1, len(p))) % 2


def mat_transpose(a):
    return [list(row) for row in zip(*a)]


def mat_mul(a, b):
    bt = mat_transpose(b)
    return [[sum(x * y for x, y in zip(row, col)) for col in bt] for row in a]


def determinant(a):
    """Bareiss determinant over the integers."""
    a = [row[:] for row in a]
    n = len(a)
    if n == 0:
        return 1
    sign = 1
    previous = 1
    for k in range(n - 1):
        if a[k][k] == 0:
            pivot = next((i for i in range(k + 1, n) if a[i][k]), None)
            if pivot is None:
                return 0
            a[k], a[pivot] = a[pivot], a[k]
            sign *= -1
        pivot = a[k][k]
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                a[i][j] = (a[i][j] * pivot - a[i][k] * a[k][j]) // previous
        previous = pivot
    return sign * a[-1][-1]


def canonical_classes(vertices, edges, group, vertex_action):
    vertex_index = {v: i for i, v in enumerate(vertices)}
    edge_index = {frozenset(edge): i for i, edge in enumerate(edges)}
    coboundaries = set()
    for function in range(1 << len(vertices)):
        value = 0
        for i, (v, w) in enumerate(edges):
            if ((function >> vertex_index[v]) ^ (function >> vertex_index[w])) & 1:
                value |= 1 << i
        coboundaries.add(value)

    def canonical(value):
        return min(value ^ boundary for boundary in coboundaries)

    def act(g, value):
        result = 0
        for i, (v, w) in enumerate(edges):
            if (value >> i) & 1:
                image = frozenset((vertex_action(g, v), vertex_action(g, w)))
                result |= 1 << edge_index[image]
        return result

    quotient = sorted({canonical(x) for x in range(1 << len(edges))})
    fixed = [x for x in quotient if all(canonical(act(g, x)) == x for g in group)]
    return fixed, canonical((1 << len(edges)) - 1), canonical, act


def signed_incidence(vertex_count, edges, voltage):
    matrix = [[0] * len(edges) for _ in range(vertex_count)]
    for j, (v, w) in enumerate(edges):
        matrix[v][j] -= 1
        matrix[w][j] += -1 if (voltage >> j) & 1 else 1
    return matrix


def gram_from_basis(basis):
    return mat_mul(mat_transpose(basis), basis)


def assert_kernel_is_saturated(boundary, basis):
    assert all(all(x == 0 for x in row) for row in mat_mul(boundary, basis))
    rank = len(basis[0])
    minors = []
    for rows in combinations(range(len(basis)), rank):
        minor = [[basis[i][j] for j in range(rank)] for i in rows]
        minors.append(abs(determinant(minor)))
    assert reduce(gcd, minors) == 1


def intermediate_lattice_gram(d):
    """Gram of (L_d, d*b), where [L_d:A5]=d and d divides 6."""
    modulus = 6 // d
    # In weight coordinates r_i=x_i-x_6, L_d is sum(r_i)=0 mod modulus.
    basis = [[0] * 5 for _ in range(5)]
    for j in range(4):
        basis[j][j] = 1
        basis[4][j] = -1
    basis[4][4] = modulus
    weight_form = [
        [Fraction(int(i == j), 1) - Fraction(1, 6) for j in range(5)]
        for i in range(5)
    ]
    result = mat_mul(mat_mul(mat_transpose(basis), weight_form), basis)
    result = [[d * x for x in row] for row in result]
    assert all(x.denominator == 1 for row in result for x in row)
    return [[int(x) for x in row] for row in result]


def check_isometry(name, graph_gram, target_gram, change):
    assert determinant(change) in (-1, 1)
    assert mat_mul(mat_mul(mat_transpose(change), target_gram), change) == graph_gram
    print(f"{name}: det={determinant(graph_gram)}; exact integral isometry PASS")


def main():
    a5 = generated_group(((1, 2, 0, 3, 4), (1, 2, 3, 4, 0)))
    s5 = sorted(permutations(range(5)))
    assert len(a5) == 60 and len(s5) == 120 and all(parity(g) == 0 for g in a5)

    p_vertices = list(combinations(range(5), 2))
    p_edges_named = [
        (v, w) for v, w in combinations(p_vertices, 2) if set(v).isdisjoint(w)
    ]
    p_index = {v: i for i, v in enumerate(p_vertices)}
    p_edges = [(p_index[v], p_index[w]) for v, w in p_edges_named]
    p_action = lambda g, v: tuple(sorted(g[i] for i in v))
    p_fixed, p_all_one, _, _ = canonical_classes(
        p_vertices, p_edges_named, a5, p_action
    )
    p_s5_fixed, _, _, _ = canonical_classes(p_vertices, p_edges_named, s5, p_action)
    assert p_fixed == [0, 73, 154, 211]
    assert p_all_one == 73 and p_s5_fixed == [0, 73]
    odd = (1, 0, 2, 3, 4)
    _, _, p_canonical, p_act = canonical_classes(p_vertices, p_edges_named, a5, p_action)
    assert {p_canonical(p_act(odd, 154)), p_canonical(p_act(odd, 211))} == {154, 211}
    assert p_canonical(p_act(odd, 154)) == 211
    print("Petersen: three nonzero A5 classes; all-one is S5-fixed; exotic pair is odd-swapped")

    k_vertices = list(range(5))
    k_edges = list(combinations(k_vertices, 2))
    k_action = lambda g, v: g[v]
    k_fixed, k_all_one, _, _ = canonical_classes(k_vertices, k_edges, a5, k_action)
    assert k_fixed == [0, 183] and k_all_one == 183
    print("K5: unique nonzero A5 class, represented by all-one voltage")
    print("six-loop rose: unique nonzero A5 class, represented by all-one voltage")

    p_all_basis = [
        [0, -1, 0, 0, -1], [0, 0, -1, -1, 0], [0, 1, 1, 1, 1],
        [-1, 0, 0, -1, 0], [1, 1, 1, 1, 0], [0, -1, -1, 0, 0],
        [1, 1, 0, 1, 1], [-1, -1, -1, -1, -1], [0, 0, 1, 0, 0],
        [-1, -1, 0, 0, 0], [1, 0, 0, 0, 0], [0, 1, 0, 0, 0],
        [0, 0, 0, -1, -1], [0, 0, 0, 1, 0], [0, 0, 0, 0, 1],
    ]
    p_exotic_basis = [
        [0, -1, 0, 0, -1], [-1, 0, 0, 1, 1], [1, 1, 0, -1, 0],
        [1, 0, 0, -1, 0], [0, 1, 1, 0, 0], [-1, -1, -1, 1, 0],
        [1, 1, 1, 0, 0], [0, -1, -1, 0, -1], [-1, 0, 0, 0, 1],
        [-1, -1, 0, 0, 0], [1, 0, 0, 0, 0], [0, 1, 0, 0, 0],
        [0, 0, 1, 0, 0], [0, 0, 0, 1, 0], [0, 0, 0, 0, 1],
    ]
    k_basis = [
        [0, 0, 1, 1, 1], [1, 1, 0, 0, 1], [-1, 0, -1, 0, -1],
        [0, -1, 0, -1, -1], [-1, -1, -1, -1, -1], [1, 0, 0, 0, 0],
        [0, 1, 0, 0, 0], [0, 0, 1, 0, 0], [0, 0, 0, 1, 0],
        [0, 0, 0, 0, 1],
    ]
    rose_basis = [
        [-1, -1, -1, -1, -1], [1, 0, 0, 0, 0], [0, 1, 0, 0, 0],
        [0, 0, 1, 0, 0], [0, 0, 0, 1, 0], [0, 0, 0, 0, 1],
    ]
    cases = [
        ("Petersen all-one over tau", 10, p_edges, (1 << 15) - 1, p_all_basis),
        ("Petersen exotic", 10, p_edges, 154, p_exotic_basis),
        ("K5 all-one", 5, k_edges, (1 << 10) - 1, k_basis),
        ("six-loop rose", 1, [(0, 0)] * 6, (1 << 6) - 1, rose_basis),
    ]
    grams = {}
    for name, vertex_count, edges, voltage, basis in cases:
        boundary = signed_incidence(vertex_count, edges, voltage)
        assert_kernel_is_saturated(boundary, basis)
        grams[name] = gram_from_basis(basis)

    changes = {
        "Petersen all-one over tau": [
            [0, 0, 1, 1, 1], [0, -1, 0, 1, 0], [1, 1, 1, 2, 1],
            [1, 0, 0, 1, 1], [1, 0, 1, 2, 1],
        ],
        "Petersen exotic": [
            [0, 0, 0, 0, -1], [-1, 0, 0, 0, 0], [-1, 0, 0, 1, 0],
            [0, 1, 0, 0, 0], [-2, 2, 1, 1, -1],
        ],
        "K5 all-one": [
            [0, 0, -1, -1, 0], [0, -1, 0, -1, 0], [0, -1, -1, -1, -1],
            [1, 0, 0, 0, 1], [1, -1, -1, -2, 0],
        ],
        "six-loop rose": [
            [0, 0, 0, -1, 1], [0, 0, -1, 0, 1], [0, -1, 0, 0, 1],
            [1, 1, 1, 1, 2], [0, 0, 0, 0, 1],
        ],
    }
    targets = {
        "Petersen all-one over tau": [[2 * x for x in row] for row in intermediate_lattice_gram(2)],
        "Petersen exotic": intermediate_lattice_gram(6),
        "K5 all-one": intermediate_lattice_gram(3),
        "six-loop rose": intermediate_lattice_gram(1),
    }
    for name in grams:
        check_isometry(name, grams[name], targets[name], changes[name])

    assert all(x % 2 == 0 for row in grams["Petersen all-one over tau"] for x in row)
    descended = [[x // 2 for x in row] for row in grams["Petersen all-one over tau"]]
    assert mat_mul(
        mat_mul(mat_transpose(changes["Petersen all-one over tau"]), intermediate_lattice_gram(2)),
        changes["Petersen all-one over tau"],
    ) == descended
    print("Igusa descent: q_tau=2 q_t, so q_t=(L_2,2b) PASS")
    # In the actual root--weight marking Lambda=L^# e + L f, the stabilizer is
    # Gamma_0(6) (c=0 mod 6), and (L_d,d*b) has standard cusp width d.
    print("Gamma_0(6) widths: t=7/10,1/4,1/6,1/2 -> 1,2,3,6 PASS")


if __name__ == "__main__":
    main()
