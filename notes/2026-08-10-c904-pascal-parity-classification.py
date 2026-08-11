#!/usr/bin/env python3
"""Classify formal mod-2 twist invariants through weight three.

For each multiset of virtual ranks modulo four on at most five index
classes, compute the degree-three invariant quotient by products of a
degree-one invariant with a degree-two invariant and by Sq^2 of degree-two
invariants.  Pure bitset row reduction makes the census exact and replayable.

Run with:
  uv run python notes/2026-08-10-c904-pascal-parity-classification.py
"""

from itertools import combinations_with_replacement


def add(left, right):
    return left ^ right


def mul(left, right):
    result = set()
    for a in left:
        for b in right:
            monomial = tuple(x + y for x, y in zip(a, b))
            if monomial in result:
                result.remove(monomial)
            else:
                result.add(monomial)
    return result


def term(nvars, variable=None, power=1):
    exponent = [0] * nvars
    if variable is not None:
        exponent[variable] = power
    return {tuple(exponent)}


def weighted_monomials(nbundles, total):
    weights = (1, 2, 3) * nbundles
    answer = []

    def visit(index, remaining, prefix):
        if index == len(weights):
            if remaining == 0:
                answer.append(tuple(prefix))
            return
        for value in range(remaining // weights[index] + 1):
            visit(index + 1, remaining - value * weights[index],
                  prefix + [value])

    visit(0, total, [])
    return answer


def substitutions(ranks):
    nbundles = len(ranks)
    nvars = 3 * nbundles + 1
    ell_index = nvars - 1
    ell = term(nvars, ell_index)
    ell2 = term(nvars, ell_index, 2)
    ell3 = term(nvars, ell_index, 3)
    answer = []
    for index, rank in enumerate(ranks):
        c1 = term(nvars, 3 * index)
        c2 = term(nvars, 3 * index + 1)
        c3 = term(nvars, 3 * index + 2)
        first = add(c1, ell) if rank % 2 else c1
        second = c2
        if (rank - 1) % 2:
            second = add(second, mul(ell, c1))
        if (rank * (rank - 1) // 2) % 2:
            second = add(second, ell2)
        third = c3
        if (rank - 2) % 2:
            third = add(third, mul(ell, c2))
        if ((rank - 1) * (rank - 2) // 2) % 2:
            third = add(third, mul(ell2, c1))
        if (rank * (rank - 1) * (rank - 2) // 6) % 2:
            third = add(third, ell3)
        answer.extend((first, second, third))
    return tuple(answer)


def transform(monomial, substitution):
    result = term(len(monomial) + 1)
    for variable, exponent in enumerate(monomial):
        for _ in range(exponent):
            result = mul(result, substitution[variable])
    return result


def lift(monomial):
    return {tuple(monomial) + (0,)}


def nullspace(equations, ncolumns):
    rows = [row for row in equations if row]
    pivots = []
    pivot_row = 0
    for column in range(ncolumns):
        found = next((row for row in range(pivot_row, len(rows))
                      if rows[row] >> column & 1), None)
        if found is None:
            continue
        rows[pivot_row], rows[found] = rows[found], rows[pivot_row]
        for row in range(len(rows)):
            if row != pivot_row and rows[row] >> column & 1:
                rows[row] ^= rows[pivot_row]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(rows):
            break
    free = [column for column in range(ncolumns) if column not in pivots]
    basis = []
    for column in free:
        value = 1 << column
        for row, pivot in enumerate(pivots):
            if rows[row] >> column & 1:
                value |= 1 << pivot
        basis.append(value)
    return basis


def invariant_basis(ranks, degree):
    nbundles = len(ranks)
    domain = weighted_monomials(nbundles, degree)
    substitution = substitutions(ranks)
    images = [add(transform(value, substitution), lift(value))
              for value in domain]
    targets = sorted(set().union(*images)) if images else []
    target_index = {value: i for i, value in enumerate(targets)}
    equations = [0] * len(targets)
    for column, image in enumerate(images):
        for value in image:
            equations[target_index[value]] |= 1 << column
    return domain, nullspace(equations, len(domain))


def vector_poly(vector, monomials):
    return {monomials[i] for i in range(len(monomials))
            if vector >> i & 1}


def poly_vector(polynomial, index):
    answer = 0
    for value in polynomial:
        answer ^= 1 << index[value]
    return answer


def sq2(polynomial, nbundles):
    answer = set()
    nvars = 3 * nbundles
    for monomial in polynomial:
        variables = [i for i, exponent in enumerate(monomial)
                     for _ in range(exponent)]
        if len(variables) == 1:
            variable = variables[0]
            assert variable % 3 == 1
            bundle = variable // 3
            c1c2 = [0] * nvars
            c1c2[3 * bundle] = c1c2[3 * bundle + 1] = 1
            c3 = [0] * nvars
            c3[3 * bundle + 2] = 1
            answer = add(answer, {tuple(c1c2), tuple(c3)})
        else:
            assert len(variables) == 2
            assert all(variable % 3 == 0 for variable in variables)
            i, j = variables
            if i != j:
                first = list(monomial)
                second = list(monomial)
                first[i] += 1
                second[j] += 1
                answer = add(answer, {tuple(first), tuple(second)})
    return answer


def rank(vectors):
    pivots = {}
    for vector in vectors:
        value = vector
        while value:
            pivot = value.bit_length() - 1
            if pivot in pivots:
                value ^= pivots[pivot]
            else:
                pivots[pivot] = value
                break
    return len(pivots)


def quotient_data(ranks):
    data = [invariant_basis(ranks, degree) for degree in (1, 2, 3)]
    mon1, inv1 = data[0]
    mon2, inv2 = data[1]
    mon3, inv3 = data[2]
    polys1 = [vector_poly(value, mon1) for value in inv1]
    polys2 = [vector_poly(value, mon2) for value in inv2]
    index3 = {value: i for i, value in enumerate(mon3)}
    obvious = [poly_vector(mul(left, right), index3)
               for left in polys1 for right in polys2]
    for value in polys2:
        square = sq2(value, len(ranks))
        # Naturality: Sq^2 of an invariant must still be invariant.
        obvious.append(poly_vector(square, index3))
    obvious_rank = rank(obvious)
    combined = rank(obvious + inv3)
    assert combined == len(inv3)
    return (len(inv1), len(inv2), len(inv3), obvious_rank,
            len(inv3) - obvious_rank)


def main():
    exceptional = []
    totals = {}
    for nbundles in range(1, 6):
        counts = {}
        for ranks in combinations_with_replacement(range(4), nbundles):
            value = quotient_data(ranks)
            residual = value[-1]
            counts[residual] = counts.get(residual, 0) + 1
            if residual:
                exceptional.append((ranks, value))
        totals[nbundles] = counts
    print("C904 formal Pascal parity classification, ranks modulo 4")
    for nbundles, counts in totals.items():
        print(f"  bundles={nbundles}: residual-dimension counts={sorted(counts.items())}")
    print(f"exceptional rank multisets={exceptional}")
    target = quotient_data((0, 0, 2, 3))
    print(f"target ranks (0,0,2,3): dims d1,d2,d3,obvious,residual={target}")
    print("PASS")


if __name__ == "__main__":
    main()
