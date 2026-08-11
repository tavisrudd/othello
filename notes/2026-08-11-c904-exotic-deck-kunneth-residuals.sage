#!/usr/bin/env sage
"""Exact mod-2 exotic-deck action on the C904 p15/p24 residual tensors.

This is the representation-theoretic implementation.  The residual C3 acts
on H1 as five copies of its natural irreducible F2-module, and the exotic
deck acts by Frobenius, giving S3=C3 semidirect C2.  The p15 quotient degree
is the divided (unordered) coefficient trace, not the ordered top pairing.
"""

import argparse
from itertools import combinations

F = GF(2)
n = 10

g2 = matrix(F, [[1, 1], [1, 0]])
s2 = matrix(F, [[0, 1], [1, 0]])
g = block_diagonal_matrix([g2 for _ in range(5)])
s = block_diagonal_matrix([s2 for _ in range(5)])
assert g^3 == identity_matrix(F, n)
assert s^2 == identity_matrix(F, n)
assert s * g * s == g^2


def exterior_basis(degree):
    return list(combinations(range(n), degree))


def exterior_action(action, degree):
    basis = exterior_basis(degree)
    index = {item: row for row, item in enumerate(basis)}
    result = matrix(F, len(basis))
    for column, source in enumerate(basis):
        terms = {(): F.one()}
        for source_index in source:
            new_terms = {}
            for partial, coefficient in terms.items():
                for target_index in range(n):
                    scalar = action[target_index, source_index]
                    if not scalar or target_index in partial:
                        continue
                    target = tuple(sorted(partial + (target_index,)))
                    new_terms[target] = (
                        new_terms.get(target, F.zero()) + coefficient * scalar
                    )
            terms = new_terms
        for target, coefficient in terms.items():
            result[index[target], column] = coefficient
    return result


def wedge_theta(degree):
    source = exterior_basis(degree)
    target = exterior_basis(degree + 2)
    target_index = {item: row for row, item in enumerate(target)}
    result = matrix(F, len(target), len(source))
    for column, item in enumerate(source):
        for pair_index in range(5):
            pair = (2 * pair_index, 2 * pair_index + 1)
            if pair[0] in item or pair[1] in item:
                continue
            result[target_index[tuple(sorted(item + pair))], column] += 1
    return result


actions_g = {degree: exterior_action(g, degree) for degree in range(1, 8)}
actions_s = {degree: exterior_action(s, degree) for degree in range(1, 8)}

for degree in range(1, 6):
    assert actions_g[degree + 2] * wedge_theta(degree) == (
        wedge_theta(degree) * actions_g[degree]
    )
    assert actions_s[degree + 2] * wedge_theta(degree) == (
        wedge_theta(degree) * actions_s[degree]
    )


def quotient_with_actions(source_degree):
    target_degree = source_degree + 2
    target = VectorSpace(F, binomial(n, target_degree))
    quotient = target.quotient(wedge_theta(source_degree).column_space())

    def induced(action):
        columns = [
            quotient(action * quotient.lift(basis_vector))
            for basis_vector in quotient.basis()
        ]
        return matrix(F, [list(column) for column in columns]).transpose()

    return quotient, induced(actions_g[target_degree]), induced(actions_s[target_degree])


def subspace_action(subspace, ambient_action):
    columns = [
        subspace.coordinate_vector(ambient_action * basis_vector)
        for basis_vector in subspace.basis()
    ]
    return matrix(F, [list(column) for column in columns]).transpose()


q15, q15_g, q15_s = quotient_with_actions(5)
q24, q24_g, q24_s = quotient_with_actions(4)
u24 = wedge_theta(2).column_space()
u24_g = subspace_action(u24, actions_g[4])
u24_s = subspace_action(u24, actions_s[4])

assert q15_s^2 == 1 and q15_s * q15_g * q15_s == q15_g^2
assert q24_s^2 == 1 and q24_s * q24_g * q24_s == q24_g^2
assert u24_s^2 == 1 and u24_s * u24_g * u24_s == u24_g^2


def top_wedge(left_degree, left, right_degree, right, extra_theta=False):
    """Coefficient of e_0...e_9; signs disappear in characteristic two."""
    left_basis = exterior_basis(left_degree)
    right_basis = exterior_basis(right_degree)
    value = F.zero()
    for left_index in left.support():
        left_item = left_basis[left_index]
        for right_index in right.support():
            right_item = right_basis[right_index]
            if set(left_item).intersection(right_item):
                continue
            used = set(left_item).union(right_item)
            coefficient = left[left_index] * right[right_index]
            if not extra_theta:
                if len(used) == n:
                    value += coefficient
                continue
            for pair_index in range(5):
                pair = {2 * pair_index, 2 * pair_index + 1}
                if used.isdisjoint(pair) and len(used.union(pair)) == n:
                    value += coefficient
    return value


def p15_pairing():
    result = matrix(F, n, q15.dimension())
    for i in range(n):
        left = vector(F, n, [1 if j == i else 0 for j in range(n)])
        for j, quotient_basis in enumerate(q15.basis()):
            right = q15.lift(quotient_basis)
            result[i, j] = top_wedge(1, left, 7, right, extra_theta=True)
    return result


def p24_pairing():
    result = matrix(F, u24.dimension(), q24.dimension())
    for i, left in enumerate(u24.basis()):
        for j, quotient_basis in enumerate(q24.basis()):
            right = q24.lift(quotient_basis)
            result[i, j] = top_wedge(4, left, 6, right)
    return result


pair15 = p15_pairing()
pair24 = p24_pairing()
assert pair15.rank() == 10
assert pair24.rank() == 44
assert g.transpose() * pair15 * q15_g == pair15
assert s.transpose() * pair15 * q15_s == pair15
assert u24_g.transpose() * pair24 * q24_g == pair24
assert u24_s.transpose() * pair24 * q24_s == pair24


def invariant_tensor_data(left_g, left_s, right_g, right_s, pairing):
    tensor_g = left_g.tensor_product(right_g)
    tensor_s = left_s.tensor_product(right_s)
    dimension = tensor_g.nrows()
    equations_c3 = tensor_g - identity_matrix(F, dimension)
    equations_s3 = equations_c3.stack(
        tensor_s - identity_matrix(F, dimension)
    )
    fixed_c3 = equations_c3.right_kernel()
    fixed_s3 = equations_s3.right_kernel()
    degree = vector(F, pairing.list())
    odd_c3 = any(degree.dot_product(row) for row in fixed_c3.basis())
    odd_s3 = any(degree.dot_product(row) for row in fixed_s3.basis())
    return fixed_c3, fixed_s3, odd_c3, odd_s3


def centralizer(*actions):
    """Basis of simultaneous commuting endomorphisms."""
    variables = n * n
    rows = []
    for action in actions:
        for i in range(n):
            for j in range(n):
                row = [F.zero()] * variables
                for k in range(n):
                    row[n * i + k] += action[k, j]
                    row[n * k + j] -= action[i, k]
                rows.append(row)
    return [matrix(F, n, n, list(value))
            for value in matrix(F, rows).right_kernel().basis()]


def p15_divided_degree_data():
    """The full-S3 p15 tensor space and its unordered degree functional.

    Via the perfect pairing, an invariant tensor T corresponds to the
    endomorphism A=T*pair15^t.  The S3-centralizer is M5(F2): each 2-by-2
    block is a scalar.  Symmetric-square descent divides the ordered trace
    by two, so its degree is trace of the 5-by-5 scalar coefficient matrix.
    """
    basis = centralizer(g, s)
    assert len(basis) == 25
    coefficient_matrices = []
    degrees = []
    inverse_pairing = pair15.transpose().inverse()
    tensor_s = s.tensor_product(q15_s)
    tensor_g = g.tensor_product(q15_g)
    identity_tensor = None
    for action in basis:
        coefficient = zero_matrix(F, 5)
        for i in range(5):
            for j in range(5):
                block = action.matrix_from_rows_and_columns(
                    [2 * i, 2 * i + 1], [2 * j, 2 * j + 1]
                )
                assert block in (zero_matrix(F, 2), identity_matrix(F, 2))
                coefficient[i, j] = block[0, 0]
        tensor = action * inverse_pairing
        tensor_vector = vector(F, tensor.list()).column()
        assert tensor_g * tensor_vector == tensor_vector
        assert tensor_s * tensor_vector == tensor_vector
        coefficient_matrices.append(coefficient)
        degrees.append(coefficient.trace())
        if action == identity_matrix(F, n):
            identity_tensor = tensor
    assert span(F, [vector(F, value.list()) for value in coefficient_matrices]).dimension() == 25
    # The chosen centralizer basis need not contain I as a basis vector;
    # construct and check it separately.
    identity_tensor = identity_matrix(F, n) * inverse_pairing
    identity_vector = vector(F, identity_tensor.list()).column()
    assert tensor_g * identity_vector == identity_vector
    assert tensor_s * identity_vector == identity_vector
    identity_coefficient_degree = F(5)
    assert identity_coefficient_degree == 1
    return len(basis), any(degrees), identity_coefficient_degree


p15 = invariant_tensor_data(g, s, q15_g, q15_s, pair15)
p24 = invariant_tensor_data(u24_g, u24_s, q24_g, q24_s, pair24)
p15_divided = p15_divided_degree_data()


def fixed_dimension(action):
    return (action - identity_matrix(F, action.nrows())).right_kernel().dimension()


def common_fixed_dimension(*actions):
    equations = (actions[0] - identity_matrix(F, actions[0].nrows()))
    for action in actions[1:]:
        equations = equations.stack(
            action - identity_matrix(F, action.nrows())
        )
    return equations.right_kernel().dimension()


def main(output_path=None):
    lines = [
        "C904 exotic deck on dyadic Kunneth residuals",
        "deck relations: s^2=1 and s*g*s=g^-1 on every residual module",
        f"Q15: dim={q15.dimension()} deck-fixed={fixed_dimension(q15_s)} full-S3-fixed={common_fixed_dimension(q15_g, q15_s)}",
        f"Q24: dim={q24.dimension()} deck-fixed={fixed_dimension(q24_s)} full-S3-fixed={common_fixed_dimension(q24_g, q24_s)}",
        f"p15 pairing rank={pair15.rank()} tensor fixed dimensions C3/full-S3={p15[0].dimension()}/{p15[1].dimension()}",
        f"p15 ordered mod2 contraction odd C3/full-S3={p15[2]}/{p15[3]}",
        f"p15 divided coefficient-trace space dim={p15_divided[0]} odd-exists={p15_divided[1]} identity-degree={ZZ(p15_divided[2])}",
        f"p24 pairing rank={pair24.rank()} tensor fixed dimensions C3/full-S3={p24[0].dimension()}/{p24[1].dimension()}",
        f"p24 quotient contraction odd C3/full-S3={p24[2]}/{p24[3]}",
        "PASS",
    ]
    output = "\n".join(lines) + "\n"
    if output_path:
        with open(output_path, "w", encoding="utf-8") as stream:
            stream.write(output)
    else:
        print(output, end="")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output")
    arguments, _ = parser.parse_known_args()
    main(arguments.output)
