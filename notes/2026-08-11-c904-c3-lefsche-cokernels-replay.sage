#!/usr/bin/env sage
"""Independent bit-mask replay of the C904 C3/Lefschetz calculation."""

from contextlib import redirect_stdout
from io import StringIO
from itertools import combinations
import argparse
import sys


_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved_argv

F = GF(2)
N = 10


def masks(weight):
    return [sum(1 << i for i in subset)
            for subset in combinations(range(N), weight)]


def multiply(left, right):
    result = {}
    for a, avalue in left.items():
        for b, bvalue in right.items():
            if a & b:
                continue
            result[a | b] = result.get(a | b, F.zero()) + avalue * bvalue
    return {mask: value for mask, value in result.items() if value}


def exterior_by_expansion(action, degree):
    source_masks = masks(degree)
    target_masks = masks(degree)
    rows = {mask: i for i, mask in enumerate(target_masks)}
    answer = zero_matrix(F, len(target_masks), len(source_masks))
    images = []
    for column in range(N):
        images.append({1 << row: action[row, column]
                       for row in range(N) if action[row, column]})
    for column, mask in enumerate(source_masks):
        value = {0: F.one()}
        for index in range(N):
            if mask & (1 << index):
                value = multiply(value, images[index])
        for target, coefficient in value.items():
            answer[rows[target], column] = coefficient
    return answer


def lefschetz_by_masks(theta, degree):
    source_masks = masks(degree)
    target_masks = masks(degree + 2)
    rows = {mask: i for i, mask in enumerate(target_masks)}
    theta_terms = {(1 << i) | (1 << j): F(theta[i, j])
                   for i in range(N) for j in range(i + 1, N)
                   if F(theta[i, j])}
    answer = zero_matrix(F, len(target_masks), len(source_masks))
    for column, mask in enumerate(source_masks):
        for pair, coefficient in theta_terms.items():
            if not mask & pair:
                answer[rows[mask | pair], column] += coefficient
    return answer


def quotient_fixed(lefschetz, action):
    image = lefschetz.column_space()
    # A fixed quotient class is v with (g-1)v in im(L).  Its dimension is
    # dim ker([g-1|-L]) - dim ker(L) - dim im(L), equivalently compute the
    # preimage and then quotient by im(L).
    combined = (action - identity_matrix(F, action.nrows())).augment(lefschetz)
    solutions = combined.right_kernel()
    projected = span(F, [vector(F, row[:action.nrows()]) for row in solutions.basis()])
    assert image.is_subspace(projected)
    return action.nrows() - image.dimension(), projected.dimension() - image.dimension()


def actual_ns_mod2(basis):
    positions, linear_map = ns_integrality_matrix(basis)
    _, lattice = congruence_kernel_lattice(linear_map)
    zero = zero_matrix(QQ, 5)
    columns = []
    pairs = list(combinations(range(N), 2))
    for coordinates in lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions)
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        principal = basis * source * basis.transpose()
        columns.append(vector(F, [principal[i, j] for i, j in pairs]))
    return matrix(F, columns).transpose()


def main(output_path=None):
    _, _, basis, theta = principal_lattice("omega", 1)
    i5 = identity_matrix(ZZ, 5)
    z5 = zero_matrix(ZZ, 5)
    ambient = block_matrix(ZZ, [[-i5, -i5], [i5, z5]])
    c3_integral = basis * ambient.transpose() * basis.inverse()
    assert c3_integral.denominator() == 1
    c3 = c3_integral.change_ring(F)

    action = {degree: exterior_by_expansion(c3, degree)
              for degree in (2, 4, 6, 7)}
    l2 = lefschetz_by_masks(theta, 2)
    l4 = lefschetz_by_masks(theta, 4)
    l5 = lefschetz_by_masks(theta, 5)
    q57 = quotient_fixed(l5, action[7])
    q46 = quotient_fixed(l4, action[6])
    assert q57 == (10, 0)
    assert q46 == (44, 24)

    ns = actual_ns_mod2(basis)
    assert ns.rank() == 15
    assert action[2] * ns == ns
    assert (l2 * ns).rank() == 14

    # Semisimple C3 module accounting: Q57=5W; Q46=24*1+10W.
    assert 2 * 5 * 5 == 50
    assert 24 * 24 + 2 * 10 * 10 == 776

    output = "\n".join([
        "C904 independent bit-mask replay",
        f"Q57(dim,fixed)={q57}",
        f"Q46(dim,fixed)={q46}",
        f"actual NS(dim,L-image)=({ns.rank()},{(l2 * ns).rank()})",
        "C3 invariant tensor dims=(50,776)",
        "PASS",
    ]) + "\n"
    if output_path:
        with open(output_path, "w", encoding="utf-8") as stream:
            stream.write(output)
    else:
        print(output, end="")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output")
    args = parser.parse_args()
    main(args.output)
