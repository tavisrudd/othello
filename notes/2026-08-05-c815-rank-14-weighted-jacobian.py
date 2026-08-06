#!/usr/bin/env python3
"""Structural rank certificate for the weighted Jacobian of C809 Theorem D.

Independent of the C809 bundle: every object used here is rebuilt from scratch,
the Hodge compound cubic is cross-checked against the commutator Pfaffian, and
the rank statement is verified both directly and through the equivariant
reduction that the accompanying report proves.

Replay from the repository root:

    python3 notes/2026-08-05-c815-rank-14-weighted-jacobian.py \
      --check notes/2026-08-05-c815-rank-14-weighted-jacobian.json

Standard library only; all arithmetic is exact over the integers and rationals.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from itertools import combinations, permutations
from pathlib import Path

EDGES = list(combinations(range(6), 2))
TRIPLES = list(combinations(range(6), 3))
EDGE_INDEX = {edge: position for position, edge in enumerate(EDGES)}

GOLDEN = [
    [0, 1, 1, 1, 1, 1],
    [1, 0, 1, 1, -1, -1],
    [1, 1, 0, -1, 1, -1],
    [1, 1, -1, 0, -1, 1],
    [1, -1, 1, -1, 0, 1],
    [1, -1, -1, 1, 1, 0],
]

OPPOSITE_ORIENTATION = [
    [0, 1, 1, 1, 1, 1],
    [1, 0, -1, -1, 1, 1],
    [1, -1, 0, 1, -1, 1],
    [1, -1, 1, 0, 1, -1],
    [1, 1, -1, 1, 0, -1],
    [1, 1, 1, -1, -1, 0],
]

GENERIC = [
    [0, 2, -1, 3, 1, -2],
    [2, 0, 1, -2, 4, 1],
    [-1, 1, 0, 2, -3, 1],
    [3, -2, 2, 0, 1, 2],
    [1, 4, -3, 1, 0, -1],
    [-2, 1, 1, 2, -1, 0],
]

def determinant(matrix):
    if not matrix:
        return 1
    return sum(
        (-1) ** column
        * matrix[0][column]
        * determinant([row[:column] + row[column + 1 :] for row in matrix[1:]])
        for column in range(len(matrix))
    )


def permutation_sign(sequence):
    inversions = sum(
        sequence[i] > sequence[j]
        for i in range(len(sequence))
        for j in range(i + 1, len(sequence))
    )
    return (-1) ** inversions


def triangle_coefficient(matrix, triple):
    i, j, k = triple
    return matrix[i][j] * matrix[j][k] * matrix[k][i]


def compound_coefficient(matrix, triple):
    """Coefficient of the third-compound (Hodge) cubic, C704 orientation."""
    complement = tuple(i for i in range(6) if i not in triple)
    cross = [[matrix[i][j] for j in triple] for i in complement]
    return -permutation_sign(complement + triple) * determinant(cross)


# --- commutator Pfaffian, used only as an independent check on the compound ---

def polynomial_add(left, right):
    result = dict(left)
    for monomial, coefficient in right.items():
        result[monomial] = result.get(monomial, 0) + coefficient
    return {m: c for m, c in result.items() if c}


def polynomial_multiply(left, right):
    result = {}
    for ml, cl in left.items():
        for mr, cr in right.items():
            monomial = tuple(sorted(ml + mr))
            result[monomial] = result.get(monomial, 0) + cl * cr
    return {m: c for m, c in result.items() if c}


def commutator_pfaffian(matrix):
    """Pf([D_x, A]) as a polynomial in x, expanded over perfect matchings."""

    def entry(i, j):
        # [D_x, A]_{ij} = (x_i - x_j) a_ij
        return {(i,): matrix[i][j], (j,): -matrix[i][j]}

    def recurse(indices):
        if not indices:
            return {(): 1}
        first = indices[0]
        total = {}
        for position in range(1, len(indices)):
            second = indices[position]
            rest = indices[1:position] + indices[position + 1 :]
            term = polynomial_multiply(entry(first, second), recurse(rest))
            if position % 2 == 0:
                term = {m: -c for m, c in term.items()}
            total = polynomial_add(total, term)
        return total

    return recurse(tuple(range(6)))


def compound_polynomial(matrix):
    return {
        triple: compound_coefficient(matrix, triple)
        for triple in TRIPLES
        if compound_coefficient(matrix, triple)
    }


def check_pfaffian_agreement(matrix):
    """The compound cubic is minus the commutator Pfaffian, up to the fixed sign."""
    pfaffian = commutator_pfaffian(matrix)
    squarefree = {m: c for m, c in pfaffian.items() if len(set(m)) == len(m)}
    if squarefree != pfaffian:
        return False
    compound = compound_polynomial(matrix)
    ratios = set()
    for triple in TRIPLES:
        p = pfaffian.get(triple, 0)
        h = compound.get(triple, 0)
        if h == 0 and p == 0:
            continue
        if h == 0 or p == 0:
            return False
        ratios.add(Fraction(p, h))
    return str(ratios.pop()) if len(ratios) == 1 else None


# --- the weighted equality locus and its Jacobian ---

def equality_value(matrix, triple, orientation):
    return compound_coefficient(matrix, triple) - orientation * 4 * triangle_coefficient(
        matrix, triple
    )


def equality_jacobian(matrix, orientation):
    """Exact Jacobian: every equation is multilinear in the fifteen entries."""
    jacobian = []
    for triple in TRIPLES:
        row = []
        for i, j in EDGES:
            changed = [entries[:] for entries in matrix]
            changed[i][j] = changed[j][i] = 1
            at_one = equality_value(changed, triple, orientation)
            changed[i][j] = changed[j][i] = 0
            at_zero = equality_value(changed, triple, orientation)
            row.append(at_one - at_zero)
        jacobian.append(row)
    return jacobian


def row_reduce(rows, columns):
    rows = [[Fraction(value) for value in row] for row in rows]
    pivots, rank = [], 0
    for column in range(columns):
        pivot = next((r for r in range(rank, len(rows)) if rows[r][column]), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        scale = rows[rank][column]
        rows[rank] = [value / scale for value in rows[rank]]
        for r in range(len(rows)):
            if r != rank and rows[r][column]:
                factor = rows[r][column]
                rows[r] = [a - factor * b for a, b in zip(rows[r], rows[rank])]
        pivots.append(column)
        rank += 1
    return rows[:rank], pivots


def kernel_basis(rows, columns):
    reduced, pivots = row_reduce(rows, columns)
    free = [c for c in range(columns) if c not in pivots]
    basis = []
    for f in free:
        vector = [Fraction(0)] * columns
        vector[f] = Fraction(1)
        for index, column in enumerate(pivots):
            vector[column] = -reduced[index][f]
        basis.append(vector)
    return basis, len(pivots)


def edge_vector(matrix):
    return [matrix[i][j] for i, j in EDGES]


# --- the stabilizer group ---

def signed_stabilizer(matrix):
    """Signed permutations (sigma, eps) fixing the matrix, normalized by eps_0 = 1."""
    group = []
    for sigma in permutations(range(6)):
        eps = [1] * 6
        for i in range(1, 6):
            # row 0 of the golden representative is all ones, which pins eps
            eps[i] = matrix[sigma[0]][sigma[i]] * matrix[0][i]
        if all(
            eps[i] * eps[j] * matrix[sigma[i]][sigma[j]] == matrix[i][j]
            for i, j in EDGES
        ):
            group.append((sigma, tuple(eps)))
    return group


def act_on_edges(element, vector):
    sigma, eps = element
    image = [0] * 15
    for (i, j), value in zip(EDGES, vector):
        a, b = sigma[i], sigma[j]
        image[EDGE_INDEX[(min(a, b), max(a, b))]] = eps[i] * eps[j] * value
    return image


def act_on_triples(element, vector):
    sigma, _ = element
    image = [0] * 20
    for triple, value in zip(TRIPLES, vector):
        image[TRIPLES.index(tuple(sorted(sigma[i] for i in triple)))] = value
    return image


def cycle_type(sigma):
    seen = [False] * 6
    lengths = []
    for i in range(6):
        if not seen[i]:
            length, j = 0, i
            while not seen[j]:
                seen[j] = True
                j = sigma[j]
                length += 1
            lengths.append(length)
    return tuple(sorted(lengths, reverse=True))


IDENTITY = (tuple(range(6)), (1,) * 6)


def multiply(left, right):
    """Composition of signed permutations, normalized by eps_0 = 1.

    The global sign acts trivially on edge weights, so the faithful group is the
    quotient by {+-1} and every element has a unique representative with eps_0 = 1.
    """
    s1, e1 = left
    s2, e2 = right
    sigma = tuple(s2[s1[i]] for i in range(6))
    eps = tuple(e1[i] * e2[s1[i]] for i in range(6))
    if eps[0] == -1:
        eps = tuple(-value for value in eps)
    return (sigma, eps)


def element_order(element):
    current, order = element, 1
    while current != IDENTITY:
        current, order = multiply(current, element), order + 1
        if order > 60:
            raise AssertionError("element of unbounded order")
    return order


def is_simple_order_sixty(group):
    """A5 is the unique group of order 60 with no nontrivial proper normal subgroup."""
    members = set(group)
    if len(members) != 60 or any(multiply(a, b) not in members for a in group for b in group):
        return False
    inverse = {}
    for g in group:
        h = g
        while multiply(g, h) != IDENTITY:
            h = multiply(h, g)
        inverse[g] = h
    for generator in group:
        if generator == IDENTITY:
            continue
        closure = {IDENTITY, generator}
        frontier = [generator]
        while frontier:
            element = frontier.pop()
            candidates = [multiply(multiply(g, element), inverse[g]) for g in group]
            candidates += [multiply(element, other) for other in list(closure)]
            for candidate in candidates:
                if candidate not in closure:
                    closure.add(candidate)
                    frontier.append(candidate)
        if len(closure) != 60:
            return False
    return True


# --- equivariant reduction to the fixed space of an order-three element ---

def signed_edge_orbits(element):
    """Orbits of the fifteen edges under the signed action, with transport signs."""
    sigma, eps = element
    orbits, seen = [], set()
    for (i, j) in EDGES:
        if (i, j) in seen:
            continue
        orbit, current, sign = [], (i, j), 1
        while True:
            seen.add(current)
            orbit.append((current, sign))
            sign = sign * eps[current[0]] * eps[current[1]]
            a, b = sigma[current[0]], sigma[current[1]]
            current = (min(a, b), max(a, b))
            if current == (i, j):
                break
        if sign != 1:
            # the orbit sum would be forced to vanish; record it as unusable
            orbit = None
        orbits.append(orbit)
    return orbits


def fixed_space_basis(element):
    basis = []
    for orbit in signed_edge_orbits(element):
        if orbit is None:
            continue
        vector = [0] * 15
        for edge, sign in orbit:
            vector[EDGE_INDEX[edge]] = sign
        basis.append(vector)
    return basis


def orbit_coordinates(basis, vector):
    """Coordinates of a fixed vector in the disjointly supported orbit basis."""
    coordinates = []
    for b in basis:
        value = None
        for k in range(15):
            if b[k]:
                quotient = Fraction(vector[k], b[k])
                if value is None:
                    value = quotient
                elif value != quotient:
                    return None
        coordinates.append(value)
    return coordinates


def reduced_rows(jacobian, basis):
    rows = []
    for row in jacobian:
        rows.append([sum(row[k] * b[k] for k in range(15)) for b in basis])
    return rows


CLASS_KEY = {(1, 1, 1, 1, 1, 1): 0, (2, 2, 1, 1): 1, (3, 3): 2, (5, 1): 3}

# Values of the trivial, four-dimensional and five-dimensional characters of A5
# on the classes (identity, involution, order three, order five).
A5_CHARACTERS = {"trivial": ((1, 1, 1, 1), 1), "four": ((4, 0, 1, -1), 4), "five": ((5, 1, -1, 0), 5)}


def isotypic_projector(group, values, dimension):
    projector = [[Fraction(0)] * 15 for _ in range(15)]
    for element in group:
        value = values[CLASS_KEY[cycle_type(element[0])]]
        for k in range(15):
            probe = [0] * 15
            probe[k] = 1
            image = act_on_edges(element, probe)
            for r in range(15):
                projector[r][k] += Fraction(dimension, 60) * value * image[r]
    return projector


def conference_tangent(matrix):
    """Tangent space at the matrix to the generalized conference locus A^2 = lambda I."""
    equations = []
    for i in range(6):
        for j in range(i, 6):
            row = [0] * 16
            for k in range(6):
                if k != i and k != j:
                    row[EDGE_INDEX[tuple(sorted((k, j)))]] += matrix[i][k]
                    row[EDGE_INDEX[tuple(sorted((i, k)))]] += matrix[k][j]
            if i == j:
                row[15] -= 1
            equations.append(row)
    basis, rank = kernel_basis(equations, 16)
    return [vector[:15] for vector in basis], rank


def spans_agree(first, second):
    """Do two lists of vectors span the same subspace of the fifteen-dimensional space?"""
    _, rank_first = kernel_basis([[v[k] for v in first] for k in range(15)], len(first))
    _, rank_second = kernel_basis([[v[k] for v in second] for k in range(15)], len(second))
    joined = list(first) + list(second)
    _, rank_joined = kernel_basis([[v[k] for v in joined] for k in range(15)], len(joined))
    return rank_first == rank_second == rank_joined


def column_space(projector):
    columns = [[projector[r][k] for r in range(15)] for k in range(15)]
    basis = []
    for column in columns:
        candidate = basis + [column]
        _, rank = kernel_basis(
            [[v[k] for v in candidate] for k in range(15)], len(candidate)
        )
        if rank == len(candidate):
            basis = candidate
    return basis


def rank_modulo(matrix, prime):
    rows = [[value % prime for value in row] for row in matrix]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next((r for r in range(rank, len(rows)) if rows[r][column] % prime), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        inverse = pow(rows[rank][column], prime - 2, prime)
        rows[rank] = [(value * inverse) % prime for value in rows[rank]]
        for r in range(len(rows)):
            if r != rank and rows[r][column] % prime:
                factor = rows[r][column]
                rows[r] = [(a - factor * b) % prime for a, b in zip(rows[r], rows[rank])]
        rank += 1
    return rank


def invariant_factors(matrix):
    """Smith normal form diagonal, canonically chained through prime valuations."""
    work = [row[:] for row in matrix]
    height, width = len(work), len(work[0])
    diagonal = []
    position = 0
    while position < min(height, width):
        pivot = None
        for i in range(position, height):
            for j in range(position, width):
                if work[i][j] and (
                    pivot is None or abs(work[i][j]) < abs(work[pivot[0]][pivot[1]])
                ):
                    pivot = (i, j)
        if pivot is None:
            break
        i0, j0 = pivot
        work[position], work[i0] = work[i0], work[position]
        for row in work:
            row[position], row[j0] = row[j0], row[position]
        cleared = False
        while not cleared:
            cleared = True
            for i in range(position + 1, height):
                if work[i][position]:
                    quotient = work[i][position] // work[position][position]
                    work[i] = [a - quotient * b for a, b in zip(work[i], work[position])]
                    if work[i][position]:
                        work[position], work[i] = work[i], work[position]
                        cleared = False
            for j in range(position + 1, width):
                if work[position][j]:
                    quotient = work[position][j] // work[position][position]
                    for row in work:
                        row[j] -= quotient * row[position]
                    if work[position][j]:
                        for row in work:
                            row[position], row[j] = row[j], row[position]
                        cleared = False
        diagonal.append(abs(work[position][position]))
        position += 1
    # chain the diagonal: for each prime the sorted valuations are the invariant ones
    primes = set()
    for value in diagonal:
        remaining, factor = value, 2
        while factor * factor <= remaining:
            while remaining % factor == 0:
                primes.add(factor)
                remaining //= factor
            factor += 1
        if remaining > 1:
            primes.add(remaining)
    factors = [1] * len(diagonal)
    for prime in sorted(primes):
        valuations = []
        for value in diagonal:
            valuation, remaining = 0, value
            while remaining % prime == 0:
                valuation += 1
                remaining //= prime
            valuations.append(valuation)
        for index, valuation in enumerate(sorted(valuations)):
            factors[index] *= prime ** valuation
    return factors


def compute():
    result = {}

    # 0. the compound cubic is the commutator Pfaffian, checked away from the locus
    result["compound_to_commutator_pfaffian_ratio"] = sorted(
        {
            check_pfaffian_agreement(matrix)
            for matrix in (GENERIC, GOLDEN, OPPOSITE_ORIENTATION)
        }
    )

    # 1. the two golden representatives lie on their oriented equality loci
    result["golden_on_locus"] = all(
        equality_value(GOLDEN, triple, 1) == 0 for triple in TRIPLES
    ) and all(
        equality_value(OPPOSITE_ORIENTATION, triple, -1) == 0 for triple in TRIPLES
    )

    for name, matrix, orientation in (
        ("plus", GOLDEN, 1),
        ("minus", OPPOSITE_ORIENTATION, -1),
    ):
        jacobian = equality_jacobian(matrix, orientation)
        basis, rank = kernel_basis(jacobian, 15)
        a0 = edge_vector(matrix)

        # 2. Euler: the scaling direction is in the kernel, structurally
        euler = all(sum(row[c] * a0[c] for c in range(15)) == 0 for row in jacobian)

        # 3. the kernel is exactly the scaling line
        kernel_is_line = len(basis) == 1 and orbit_scalar(basis[0], a0) is not None

        group = signed_stabilizer(matrix)
        orders = sorted(element_order(g) for g in group)
        order_profile = {str(o): orders.count(o) for o in sorted(set(orders))}
        parity = sorted({permutation_sign(g[0]) for g in group})

        # 4a. the compound cubic transforms by sgn(sigma) * det(diag(eps)); on the
        #     stabilizer both factors are +1, which is why the Jacobian is equivariant
        #     for the plain permutation action on triples
        signs = set()
        for sigma, eps in group:
            product = 1
            for value in eps:
                product *= value
            signs.add((permutation_sign(sigma), product))
        stabilizer_signs_trivial = signs == {(1, 1)}

        # 4. equivariance of the Jacobian for every group element
        equivariant = True
        for g in group:
            for k in range(15):
                probe = [0] * 15
                probe[k] = 1
                left = apply_matrix_rows(jacobian, act_on_edges(g, probe))
                right = act_on_triples(g, apply_matrix_rows(jacobian, probe))
                if left != right:
                    equivariant = False
                    break
            if not equivariant:
                break

        # 5. character of the fifteen-dimensional signed edge module
        character = {}
        for g in group:
            trace = 0
            for k in range(15):
                probe = [0] * 15
                probe[k] = 1
                trace += act_on_edges(g, probe)[k]
            key = str(element_order(g))
            character.setdefault(key, set()).add(trace)
        character = {k: sorted(v) for k, v in sorted(character.items())}

        # 6. the order-three reduction, for every order-three element
        threes = [g for g in group if element_order(g) == 3]
        reductions = []
        for g in threes:
            basis3 = fixed_space_basis(g)
            rows = reduced_rows(jacobian, basis3)
            distinct = sorted({tuple(row) for row in rows})
            kernel3, rank3 = kernel_basis(
                [[rows[r][b] for b in range(len(basis3))] for r in range(20)],
                len(basis3),
            )
            lifted = [
                [sum(v[b] * basis3[b][k] for b in range(len(basis3))) for k in range(15)]
                for v in kernel3
            ]
            reductions.append(
                {
                    "fixed_dimension": len(basis3),
                    "distinct_rows": len(distinct),
                    "rank": rank3,
                    "kernel_dimension": len(kernel3),
                    "kernel_is_scaling_line": len(lifted) == 1
                    and orbit_scalar(lifted[0], a0) is not None,
                }
            )

        # 7. the conference tangent space is the trivial line plus the four-dimensional
        #    irreducible constituent, which is exactly what the cubic equality cuts
        tangent, conference_rank = conference_tangent(matrix)
        trivial_values, trivial_dimension = A5_CHARACTERS["trivial"]
        four_values, four_dimension = A5_CHARACTERS["four"]
        five_values, five_dimension = A5_CHARACTERS["five"]
        p_trivial = isotypic_projector(group, trivial_values, trivial_dimension)
        p_four = isotypic_projector(group, four_values, four_dimension)
        p_five = isotypic_projector(group, five_values, five_dimension)
        isotypic_dimensions = {
            "trivial": len(column_space(p_trivial)),
            "four": len(column_space(p_four)),
            "five": len(column_space(p_five)),
        }
        trivial_plus_four = column_space(
            [[p_trivial[r][c] + p_four[r][c] for c in range(15)] for r in range(15)]
        )

        # 8. arithmetic of the primitive Jacobian
        primitive = [[value // 2 for value in row] for row in jacobian]
        primitive_is_integral = all(
            value % 2 == 0 for row in jacobian for value in row
        )

        witness = threes[0]
        witness_basis = fixed_space_basis(witness)
        witness_rows = sorted({tuple(row) for row in reduced_rows(jacobian, witness_basis)})

        result[name] = {
            "jacobian_rank": rank,
            "kernel_dimension": len(basis),
            "euler_relation": euler,
            "kernel_is_scaling_line": kernel_is_line,
            "group_order": len(group),
            "element_orders": order_profile,
            "all_permutations_even": parity == [1],
            "group_is_A5": is_simple_order_sixty(group),
            "jacobian_equivariant": equivariant,
            "stabilizer_signs_trivial": stabilizer_signs_trivial,
            "module_character": {k: v for k, v in character.items()},
            "order_three_element_count": len(threes),
            "reductions_uniform": len({json.dumps(r, sort_keys=True) for r in reductions})
            == 1,
            "reduction": reductions[0],
            "witness_element": {
                "permutation": list(witness[0]),
                "signs": list(witness[1]),
            },
            "witness_orbit_basis": [
                [EDGES[k] for k in range(15) if b[k]] for b in witness_basis
            ],
            "witness_scaling_coordinates": [
                str(c) for c in orbit_coordinates(witness_basis, a0)
            ],
            "witness_distinct_rows": [list(row) for row in witness_rows],
            "isotypic_dimensions": isotypic_dimensions,
            "conference_tangent_rank": conference_rank,
            "conference_tangent_dimension": len(tangent),
            "conference_tangent_is_trivial_plus_four": spans_agree(tangent, trivial_plus_four),
            "primitive_jacobian_is_integral": primitive_is_integral,
            "primitive_entry_values": sorted({v for row in primitive for v in row}),
            "invariant_factors": invariant_factors(primitive),
            "primitive_rank_modulo": {
                str(prime): rank_modulo(primitive, prime) for prime in (2, 3, 5, 7, 11, 13)
            },
        }

    return result


def apply_matrix_rows(jacobian, vector):
    return [sum(row[c] * vector[c] for c in range(15)) for row in jacobian]


def orbit_scalar(vector, target):
    """Return c with vector = c * target, or None."""
    scalar = None
    for v, t in zip(vector, target):
        if t == 0:
            if v != 0:
                return None
            continue
        quotient = Fraction(v, t)
        if scalar is None:
            scalar = quotient
        elif scalar != quotient:
            return None
    return scalar


def canonical(payload):
    return json.dumps(payload, sort_keys=True, indent=2) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", type=Path, help="write the certificate")
    parser.add_argument("--check", type=Path, help="compare against a certificate")
    arguments = parser.parse_args()
    payload = compute()

    for name in ("plus", "minus"):
        block = payload[name]
        assert block["jacobian_rank"] == 14, name
        assert block["kernel_is_scaling_line"], name
        assert block["euler_relation"], name
        assert block["group_order"] == 60, name
        assert block["group_is_A5"], name
        assert block["all_permutations_even"], name
        assert block["jacobian_equivariant"], name
        assert block["stabilizer_signs_trivial"], name
        assert block["reductions_uniform"], name
        assert block["reduction"]["fixed_dimension"] == 5, name
        assert block["reduction"]["rank"] == 4, name
        assert block["reduction"]["kernel_is_scaling_line"], name
        assert block["isotypic_dimensions"] == {"trivial": 1, "four": 4, "five": 10}, name
        assert block["conference_tangent_rank"] == 11, name
        assert block["conference_tangent_dimension"] == 5, name
        assert block["conference_tangent_is_trivial_plus_four"], name
        assert block["primitive_jacobian_is_integral"], name
        assert block["primitive_rank_modulo"]["3"] == 14, name
        assert block["primitive_rank_modulo"]["5"] == 11, name
    assert payload["compound_to_commutator_pfaffian_ratio"] == ["-1"]
    assert payload["golden_on_locus"]

    text = canonical(payload)
    if arguments.write:
        arguments.write.write_text(text)
        print(f"wrote {arguments.write}")
    if arguments.check:
        stored = arguments.check.read_text()
        if stored != text:
            raise SystemExit("certificate mismatch")
        print("certificate matches")
    if not arguments.write and not arguments.check:
        print(text, end="")


if __name__ == "__main__":
    main()
