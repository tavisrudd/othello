#!/usr/bin/env python3
"""Enumerate mod-2 twist-invariant tautological classes through codimension 3.

Run with:
  uv run python notes/2026-08-10-c904-universal-sheaf-twist-invariants.py

The four index classes have virtual ranks (0,0,2,3).  For each class i the
variables a_i,b_i,c_i denote Chern classes c1,c2,c3 of weights 1,2,3.  The
script computes invariants under simultaneous tensoring by a line bundle,
then compares degree-three invariants with the span of divisor cubes and
Sq^2 of degree-two invariants.
"""

from itertools import combinations_with_replacement, product


RANKS = (0, 0, 2, 3)
NVAR = 12
LVAR = 12
WEIGHTS = (1, 2, 3) * 4


def add_poly(left, right):
    result = set(left)
    for monomial in right:
        if monomial in result:
            result.remove(monomial)
        else:
            result.add(monomial)
    return result


def mul_poly(left, right):
    result = set()
    for a in left:
        for b in right:
            monomial = tuple(x + y for x, y in zip(a, b))
            if monomial in result:
                result.remove(monomial)
            else:
                result.add(monomial)
    return result


def one_term(var_count, variable=None, power=1):
    exponent = [0] * var_count
    if variable is not None:
        exponent[variable] = power
    return {tuple(exponent)}


def weighted_monomials(weight):
    result = []

    def rec(index, remaining, exponent):
        if index == NVAR:
            if remaining == 0:
                result.append(tuple(exponent))
            return
        variable_weight = WEIGHTS[index]
        for value in range(remaining // variable_weight + 1):
            exponent.append(value)
            rec(index + 1, remaining - value * variable_weight, exponent)
            exponent.pop()

    rec(0, weight, [])
    return result


def substitution_for_bundle(index):
    """Return transformed a_i,b_i,c_i as F2 polynomials including l."""
    var_count = NVAR + 1
    a = one_term(var_count, 3 * index)
    b = one_term(var_count, 3 * index + 1)
    c = one_term(var_count, 3 * index + 2)
    ell = one_term(var_count, LVAR)
    ell2 = one_term(var_count, LVAR, 2)
    ell3 = one_term(var_count, LVAR, 3)
    rank = RANKS[index]

    aa = a
    if rank % 2:
        aa = add_poly(aa, ell)

    bb = b
    if (rank - 1) % 2:
        bb = add_poly(bb, mul_poly(ell, a))
    if (rank * (rank - 1) // 2) % 2:
        bb = add_poly(bb, ell2)

    cc = c
    if (rank - 2) % 2:
        cc = add_poly(cc, mul_poly(ell, b))
    if ((rank - 1) * (rank - 2) // 2) % 2:
        cc = add_poly(cc, mul_poly(ell2, a))
    if (rank * (rank - 1) * (rank - 2) // 6) % 2:
        cc = add_poly(cc, ell3)
    return aa, bb, cc


SUBSTITUTIONS = tuple(substitution_for_bundle(i) for i in range(4))


def transform_monomial(monomial):
    result = one_term(NVAR + 1)
    for variable, exponent in enumerate(monomial):
        bundle, offset = divmod(variable, 3)
        factor = SUBSTITUTIONS[bundle][offset]
        for _ in range(exponent):
            result = mul_poly(result, factor)
    return result


def lift_original(monomial):
    return {tuple(monomial) + (0,)}


def rref_nullspace(rows, column_count):
    rows = [row for row in rows if row]
    pivot_columns = []
    pivot_row = 0
    for column in range(column_count):
        found = next((r for r in range(pivot_row, len(rows)) if rows[r] >> column & 1), None)
        if found is None:
            continue
        rows[pivot_row], rows[found] = rows[found], rows[pivot_row]
        for r in range(len(rows)):
            if r != pivot_row and (rows[r] >> column) & 1:
                rows[r] ^= rows[pivot_row]
        pivot_columns.append(column)
        pivot_row += 1
        if pivot_row == len(rows):
            break
    free_columns = [column for column in range(column_count) if column not in pivot_columns]
    basis = []
    for free in free_columns:
        vector = 1 << free
        for r, pivot in enumerate(pivot_columns):
            if (rows[r] >> free) & 1:
                vector |= 1 << pivot
        basis.append(vector)
    return basis


def invariant_basis(weight):
    domain = weighted_monomials(weight)
    images = [add_poly(transform_monomial(monomial), lift_original(monomial)) for monomial in domain]
    target = sorted(set().union(*images))
    target_index = {monomial: i for i, monomial in enumerate(target)}
    equations = [0] * len(target)
    for column, image in enumerate(images):
        for monomial in image:
            equations[target_index[monomial]] |= 1 << column
    basis = rref_nullspace(equations, len(domain))
    for vector in basis:
        image = set()
        for column, transformed in enumerate(images):
            if vector >> column & 1:
                image = add_poly(image, transformed)
        assert not image
    return domain, basis


def vector_to_poly(vector, monomials):
    return {monomials[i] for i in range(len(monomials)) if vector >> i & 1}


def poly_to_vector(polynomial, monomial_index):
    vector = 0
    for monomial in polynomial:
        vector ^= 1 << monomial_index[monomial]
    return vector


def sq2_degree_two(polynomial):
    result = set()
    for monomial in polynomial:
        variables = [i for i, exponent in enumerate(monomial) for _ in range(exponent)]
        if len(variables) == 1:
            variable = variables[0]
            assert variable % 3 == 1
            bundle = variable // 3
            a = [0] * NVAR
            a[3 * bundle] = 1
            a[3 * bundle + 1] = 1
            c = [0] * NVAR
            c[3 * bundle + 2] = 1
            result = add_poly(result, {tuple(a), tuple(c)})
        else:
            assert len(variables) == 2 and all(variable % 3 == 0 for variable in variables)
            i, j = variables
            if i == j:
                continue
            first = list(monomial)
            first[i] += 1
            second = list(monomial)
            second[j] += 1
            result = add_poly(result, {tuple(first), tuple(second)})
    return result


def span_rank(vectors):
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


data = {weight: invariant_basis(weight) for weight in (1, 2, 3)}
for weight in (1, 2, 3):
    monomials, basis = data[weight]
    print(f"degree {weight}: monomials={len(monomials)} invariant_dim={len(basis)}")

monomials1, invariants1 = data[1]
monomials2, invariants2 = data[2]
monomials3, invariants3 = data[3]
index3 = {monomial: i for i, monomial in enumerate(monomials3)}

degree_one_polys = [vector_to_poly(vector, monomials1) for vector in invariants1]
degree_two_polys = [vector_to_poly(vector, monomials2) for vector in invariants2]

obvious = []
for i, j, k in combinations_with_replacement(range(len(degree_one_polys)), 3):
    obvious.append(
        poly_to_vector(
            mul_poly(mul_poly(degree_one_polys[i], degree_one_polys[j]), degree_one_polys[k]),
            index3,
        )
    )
for degree_one, degree_two in product(degree_one_polys, degree_two_polys):
    obvious.append(poly_to_vector(mul_poly(degree_one, degree_two), index3))
for polynomial in degree_two_polys:
    squared = sq2_degree_two(polynomial)
    transformed = set()
    for monomial in squared:
        transformed = add_poly(
            transformed,
            add_poly(transform_monomial(monomial), lift_original(monomial)),
        )
    assert not transformed
    obvious.append(poly_to_vector(squared, index3))

invariant_vectors3 = invariants3
obvious_rank = span_rank(obvious)
combined_rank = span_rank(obvious + invariant_vectors3)
print(f"obvious degree-3 span rank={obvious_rank}")
print(f"all degree-3 invariant rank={len(invariant_vectors3)}")
print(f"rank after adjoining all invariants={combined_rank}")
print(f"residual invariant quotient dimension={combined_rank - obvious_rank}")
