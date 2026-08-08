#!/usr/bin/env python3
"""C756: exact small-field checks for the passant-code equality bridge.

The finite-field and conic-plane implementation is imported from the independently
tracked invariant-half computation.  This script adds two checks:

* exhaustive enumeration of the binary passant code for q = 3, 5, 7, 9, including
  comparison of its words of weight (q+3)/2 with internal conic-external arcs;
* exhaustive verification of the norm-minus-one triangle identity over selected prime
  and extension fields.

It writes no files.  Its stdout is canonical JSON.

Replay from the repository root:
  python3 notes/2026-08-08-c756-passant-code-equality.py
"""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
DEPENDENCY = HERE / "2026-08-02-c756-invariant-half-clique.py"
OUTPUT = HERE / "2026-08-08-c756-passant-code-equality.json"


def load_dependency():
    spec = importlib.util.spec_from_file_location("c756_invariant_half", DEPENDENCY)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {DEPENDENCY}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


INV = load_dependency()


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def determinant(F, u, v, w):
    add, mul, neg = F.add, F.mul, F.neg
    t1 = mul(u[0], add(mul(v[1], w[2]), neg(mul(v[2], w[1]))))
    t2 = mul(u[1], add(mul(v[0], w[2]), neg(mul(v[2], w[0]))))
    t3 = mul(u[2], add(mul(v[0], w[1]), neg(mul(v[1], w[0]))))
    return add(add(t1, neg(t2)), t3)


def passant_rows(P, points):
    """Rows of M_q, using polarity from internal points to passant lines."""
    return [sum(1 << j for j, v in enumerate(points) if P.B(u, v) == 0)
            for u in points]


def binary_nullspace(rows, width):
    """Return a deterministic basis of the right nullspace of binary row masks."""
    pivots = {}
    for original in rows:
        row = original
        while row:
            pivot = (row & -row).bit_length() - 1
            if pivot in pivots:
                row ^= pivots[pivot]
            else:
                pivots[pivot] = row
                break
    free = [j for j in range(width) if j not in pivots]
    basis = []
    for f in free:
        word = 1 << f
        for pivot in sorted(pivots, reverse=True):
            if (pivots[pivot] & word).bit_count() & 1:
                word |= 1 << pivot
        assert all(not ((row & word).bit_count() & 1) for row in rows)
        basis.append(word)
    return basis


def all_codewords(basis):
    words = [0]
    for vector in basis:
        words += [word ^ vector for word in words]
    return words


def line_masks(F, points):
    width = len(points)
    out = [[0] * width for _ in range(width)]
    for i in range(width):
        for j in range(i + 1, width):
            mask = 0
            for k in range(width):
                if determinant(F, points[i], points[j], points[k]) == 0:
                    mask |= 1 << k
            out[i][j] = out[j][i] = mask
    return out


def enumerate_external_arcs(nbr, lines, target):
    """Enumerate masks of target-cliques with no collinear triple."""
    width = len(nbr)
    found = []

    def search(chosen, candidates, mask):
        if len(chosen) == target:
            found.append(mask)
            return
        if len(chosen) + candidates.bit_count() < target:
            return
        while candidates:
            vertex_bit = candidates & -candidates
            vertex = vertex_bit.bit_length() - 1
            candidates ^= vertex_bit
            nxt = candidates & nbr[vertex]
            for old in chosen:
                nxt &= ~lines[old][vertex]
            search(chosen + [vertex], nxt, mask | vertex_bit)

    search([], (1 << width) - 1, 0)
    return found


def code_check(p, exponent):
    F = INV.GF(p, exponent)
    P = INV.Plane(F)
    points, nbr = P.graph()
    width = len(points)
    rows = passant_rows(P, points)
    expected_row_weight = (F.q + 1) // 2
    assert {row.bit_count() for row in rows} == {expected_row_weight}
    assert len(set(rows)) == width

    basis = binary_nullspace(rows, width)
    words = all_codewords(basis)
    nonzero_weights = [word.bit_count() for word in words if word]
    minimum = min(nonzero_weights)
    equality_weight = (F.q + 3) // 2
    equality_words = sorted(word for word in words if word.bit_count() == equality_weight)

    lines = line_masks(F, points)
    arcs = sorted(enumerate_external_arcs(nbr, lines, equality_weight))
    assert equality_words == arcs
    for word in equality_words:
        assert all(not ((row & word).bit_count() & 1) for row in rows)

    return {
        "q": F.q,
        "length": width,
        "row_weight": expected_row_weight,
        "dimension": len(basis),
        "enumerated_codewords": len(words),
        "minimum_distance": minimum,
        "lower_bound": equality_weight,
        "equality_words": len(equality_words),
        "external_arcs_of_equality_size": len(arcs),
        "equality_supports_match_arcs": equality_words == arcs,
    }


def line_evaluate(F, line, point):
    return F.add(
        F.add(F.mul(line[0], point[0]), F.mul(line[1], point[1])),
        F.mul(line[2], point[2]),
    )


def line_discriminant(F, line):
    """Square class deciding intersections with y^2 - 4*x*w = 0."""
    return F.add(F.mul(line[1], line[1]), F.neg(F.mul(line[0], line[2])))


def build_tangent_graph(p, exponent):
    """Build the local Segre-tangent graph used by Paper IV, for general q."""
    F = INV.GF(p, exponent)
    P = INV.Plane(F)
    points, gamma_neighbors = P.graph()
    base = points[0]
    base_index = 0
    neighbor_indices = [j for j in range(len(points))
                        if (gamma_neighbors[base_index] >> j) & 1]
    relevant_indices = [base_index] + neighbor_indices

    secants = {}
    for point_index in relevant_indices:
        point = points[point_index]
        lines = [line for line in P.pts
                 if line_evaluate(F, line, point) == 0
                 and F.chi(line_discriminant(F, line)) == 1]
        assert len(lines) == (F.q + 1) // 2
        secants[point_index] = lines

    tangent_products = {}
    for first_index in relevant_indices:
        for second_index in relevant_indices:
            if first_index == second_index:
                continue
            value = 1
            for line in secants[first_index]:
                value = F.mul(value, line_evaluate(F, line, points[second_index]))
            tangent_products[first_index, second_index] = value

    local_neighbors = [0] * len(neighbor_indices)
    tangent_sign = -1 if ((F.q + 1) // 2 + 1) % 2 else 1
    for left in range(len(neighbor_indices)):
        q_index = neighbor_indices[left]
        for right in range(left + 1, len(neighbor_indices)):
            r_index = neighbor_indices[right]
            if not ((gamma_neighbors[q_index] >> r_index) & 1):
                continue
            numerator = F.mul(
                F.mul(tangent_products[base_index, q_index],
                      tangent_products[q_index, r_index]),
                tangent_products[r_index, base_index],
            )
            denominator = F.mul(
                F.mul(tangent_products[base_index, r_index],
                      tangent_products[r_index, q_index]),
                tangent_products[q_index, base_index],
            )
            assert numerator != 0 and denominator != 0
            signed_denominator = denominator if tangent_sign == 1 else F.neg(denominator)
            if numerator == signed_denominator:
                local_neighbors[left] |= 1 << right
                local_neighbors[right] |= 1 << left

    return F.q, local_neighbors, tangent_sign


def tangent_graph_check(p, exponent):
    """Summarize the local Segre-tangent graph used by Paper IV."""
    q, local_neighbors, tangent_sign = build_tangent_graph(p, exponent)

    omega, _ = INV.max_clique(local_neighbors, len(local_neighbors))
    degree_counts = {}
    for row in local_neighbors:
        degree = row.bit_count()
        degree_counts[str(degree)] = degree_counts.get(str(degree), 0) + 1
    return {
        "q": q,
        "vertices": len(local_neighbors),
        "edges": sum(row.bit_count() for row in local_neighbors) // 2,
        "degree_multiplicities": dict(sorted(degree_counts.items(), key=lambda item: int(item[0]))),
        "clique_number": omega,
        "required_tangent_holonomy": tangent_sign,
        "forbidden_equality_target": (q + 1) // 2,
        "target_excluded": omega < (q + 1) // 2,
    }


class QuadraticExtension:
    """F(s), s^2 = epsilon, represented by pairs a + s*b."""

    def __init__(self, F):
        self.F = F
        self.epsilon = next(x for x in range(1, F.q) if F.chi(x) == -1)

    def add(self, x, y):
        return (self.F.add(x[0], y[0]), self.F.add(x[1], y[1]))

    def neg(self, x):
        return (self.F.neg(x[0]), self.F.neg(x[1]))

    def mul(self, x, y):
        F = self.F
        return (
            F.add(F.mul(x[0], y[0]), F.mul(self.epsilon, F.mul(x[1], y[1]))),
            F.add(F.mul(x[0], y[1]), F.mul(x[1], y[0])),
        )

    def conjugate(self, x):
        return (x[0], self.F.neg(x[1]))

    def norm(self, x):
        return self.mul(x, self.conjugate(x))[0]

    def inverse(self, x):
        F = self.F
        inverse_norm = F.inv(self.norm(x))
        conjugate = self.conjugate(x)
        return (F.mul(conjugate[0], inverse_norm), F.mul(conjugate[1], inverse_norm))

    def div(self, x, y):
        return self.mul(x, self.inverse(y))


def triangle_holonomy_check(p, exponent):
    F = INV.GF(p, exponent)
    E = QuadraticExtension(F)
    minus_one = F.neg(1)
    roots = [(a, b) for a in range(F.q) for b in range(F.q)
             if (a, b) != (0, 0) and E.norm((a, b)) == minus_one]
    assert len(roots) == F.q + 1

    checked = 0
    for z1, z2, z3 in itertools.combinations(roots, 3):
        d12 = E.add(z1, E.neg(z2))
        d23 = E.add(z2, E.neg(z3))
        d31 = E.add(z3, E.neg(z1))
        numerator = E.mul(E.mul(d12, d23), d31)
        denominator = E.mul(E.mul(z1, z2), z3)
        x = E.div(numerator, denominator)
        x_squared = E.mul(x, x)
        product_norms = F.mul(F.mul(E.norm(d12), E.norm(d23)), E.norm(d31))
        assert E.conjugate(x) == E.neg(x)
        assert x_squared[1] == 0
        assert x_squared[0] == product_norms
        assert F.chi(product_norms) == -1
        checked += 1

    return {
        "q": F.q,
        "epsilon": E.epsilon,
        "norm_minus_one_roots": len(roots),
        "triples_checked": checked,
        "all_triangle_products_nonsquare": True,
    }


def generate():
    prime_powers = {9: (3, 2), 25: (5, 2), 27: (3, 3), 49: (7, 2)}
    holonomy_fields = [3, 5, 7, 9, 11, 13, 19, 23, 25, 27, 31, 43, 49]
    tangent_fields = [5, 7, 9, 11, 13, 17, 19, 23, 25, 27, 29, 31,
                      37, 41, 43, 49]
    return {
        "schema": "c756-passant-code-equality-v1",
        "dependency": {
            "path": "notes/2026-08-02-c756-invariant-half-clique.py",
            "sha256": sha256(DEPENDENCY),
            "bytes": DEPENDENCY.stat().st_size,
        },
        "code_checks": [code_check(q, 1) if q not in prime_powers
                        else code_check(*prime_powers[q]) for q in [3, 5, 7, 9]],
        "tangent_graph_checks": [
            tangent_graph_check(q, 1) if q not in prime_powers
            else tangent_graph_check(*prime_powers[q])
            for q in tangent_fields
        ],
        "triangle_holonomy_checks": [
            triangle_holonomy_check(q, 1) if q not in prime_powers
            else triangle_holonomy_check(*prime_powers[q])
            for q in holonomy_fields
        ],
    }


def main():
    rendered = json.dumps(generate(), indent=1, sort_keys=True) + "\n"
    if sys.argv[1:] == ["--check"]:
        tracked = OUTPUT.read_text()
        if tracked != rendered:
            raise SystemExit(f"generated output differs from {OUTPUT}")
        print(f"ok: {OUTPUT.name}")
        return
    if sys.argv[1:]:
        raise SystemExit("usage: passant-code-equality.py [--check]")
    print(rendered, end="")


if __name__ == "__main__":
    main()
