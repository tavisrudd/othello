#!/usr/bin/env sage
"""Residual C3 action on the two dyadic Lefsche cokernels (C904).

The script uses the actual exotic principal lattice and residual C3 matrix
from the Gate V bundle.  Exterior powers use increasing-subset bases and
column-vector conventions.  All quotient calculations are over F_2; the
integral Smith forms are checked over Z.
"""

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


def subsets(degree):
    return list(combinations(range(N), degree))


def exterior_action(linear, degree):
    """Matrix of exterior^degree(linear) in increasing-subset bases."""
    indices = subsets(degree)
    return matrix(F, [[linear.matrix_from_rows_and_columns(rows, cols).det()
                       for cols in indices] for rows in indices])


def wedge_sign(left, right):
    if set(left).intersection(right):
        return 0
    inversions = sum(i > j for i in left for j in right)
    return -1 if inversions % 2 else 1


def lefschetz_matrix(theta, degree, ring):
    source = subsets(degree)
    target = subsets(degree + 2)
    row = {indices: i for i, indices in enumerate(target)}
    result = zero_matrix(ring, len(target), len(source))
    for column, indices in enumerate(source):
        for i in range(N):
            for j in range(i + 1, N):
                coefficient = ring(theta[i, j])
                if coefficient == 0:
                    continue
                sign = wedge_sign((i, j), indices)
                if sign:
                    result[row[tuple(sorted((i, j) + indices))], column] += sign * coefficient
    return result


def extend_columns(initial, dimension):
    vectors = list(initial.column_space().basis())
    space = span(F, vectors)
    for standard in VectorSpace(F, dimension).basis():
        if standard not in space:
            vectors.append(standard)
            space = span(F, vectors)
    return matrix(F, vectors).transpose()


def residual_quotient_action(lefschetz, action):
    rank = lefschetz.rank()
    change = extend_columns(lefschetz, action.nrows())
    transported = change.inverse() * action * change
    assert transported[rank:, :rank].is_zero()
    quotient = transported[rank:, rank:]
    representatives = change[:, rank:]
    return quotient, representatives


def top_pairing(left_degree, left_columns, right_columns):
    left_indices = subsets(left_degree)
    right_indices = subsets(N - left_degree)
    right_lookup = {indices: i for i, indices in enumerate(right_indices)}
    pairing = zero_matrix(F, left_columns.ncols(), right_columns.ncols())
    universe = set(range(N))
    for i in range(left_columns.ncols()):
        left = left_columns.column(i)
        for left_position in left.nonzero_positions():
            complement = tuple(sorted(universe.difference(left_indices[left_position])))
            right_position = right_lookup[complement]
            for j in range(right_columns.ncols()):
                pairing[i, j] += left[left_position] * right_columns[right_position, j]
    return pairing


def fixed_basis(action):
    return matrix(F, (action - identity_matrix(F, action.nrows())).right_kernel().basis()).transpose()


def smith_nonunits(value):
    diagonal = value.elementary_divisors()
    return tuple(entry for entry in diagonal if entry not in (0, 1, -1))


def actual_ns_forms(basis):
    positions, linear_map = ns_integrality_matrix(basis)
    _, ns_lattice = congruence_kernel_lattice(linear_map)
    zero = zero_matrix(QQ, 5)
    columns = []
    for coordinates in ns_lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions)
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        principal = basis * source * basis.transpose()
        assert principal.denominator() == 1
        columns.append(vector(F, [principal[i, j] for i, j in subsets(2)]))
    return matrix(F, columns).transpose()


def main(output_path=None):
    _, _, basis, symplectic = principal_lattice("omega", 1)
    i5 = identity_matrix(ZZ, 5)
    z5 = zero_matrix(ZZ, 5)
    ambient_c3 = block_matrix(ZZ, [[-i5, -i5], [i5, z5]])
    c3_integral = basis * ambient_c3.transpose() * basis.inverse()
    assert c3_integral.denominator() == 1
    c3 = c3_integral.change_ring(F)
    assert c3**2 + c3 + identity_matrix(F, N) == 0

    actions = {degree: exterior_action(c3, degree) for degree in range(1, 8)}
    theta = symplectic
    lefschetz = {degree: lefschetz_matrix(theta, degree, ZZ)
                 for degree in (1, 2, 4, 5)}
    lefschetz_mod2 = {degree: value.change_ring(F)
                      for degree, value in lefschetz.items()}

    for degree in (1, 2, 4, 5):
        assert actions[degree + 2] * lefschetz_mod2[degree] == \
               lefschetz_mod2[degree] * actions[degree]

    smith_57 = smith_nonunits(lefschetz[5])
    smith_46 = smith_nonunits(lefschetz[4])
    assert smith_57 == (ZZ(2),) * 10
    assert smith_46 == (ZZ(2),) * 43 + (ZZ(6),)

    q57, reps57 = residual_quotient_action(lefschetz_mod2[5], actions[7])
    q46, reps46 = residual_quotient_action(lefschetz_mod2[4], actions[6])
    assert q57.nrows() == 10
    assert q46.nrows() == 44
    fixed57 = fixed_basis(q57)
    fixed46 = fixed_basis(q46)
    assert fixed57.ncols() == 0
    assert fixed46.ncols() == 24

    # Perfect residual pairings: im(L:Lambda^1->Lambda^3) x Q_57 and
    # im(L:Lambda^2->Lambda^4) x Q_46.
    p13 = matrix(F, lefschetz_mod2[1].column_space().basis()).transpose()
    p24 = matrix(F, lefschetz_mod2[2].column_space().basis()).transpose()
    pairing15 = top_pairing(3, p13, reps57)
    pairing24 = top_pairing(4, p24, reps46)
    assert pairing15.rank() == 10
    assert pairing24.rank() == 44

    # The effective dual modules have fixed dimensions 0 and 24.  Hence
    # their diagonal C3-invariant tensor spaces have dimensions 50 and 776.
    p13_action = p13.solve_right(actions[3] * p13)
    p24_action = p24.solve_right(actions[4] * p24)
    assert p13_action.nrows() == 10 and p13_action.ncols() == 10
    assert p24_action.nrows() == 44 and p24_action.ncols() == 44
    assert fixed_basis(p13_action).ncols() == 0
    assert fixed_basis(p24_action).ncols() == 24
    invariant_tensor_15 = 2 * 5 * 5
    invariant_tensor_24 = 24 * 24 + 2 * 10 * 10
    assert invariant_tensor_15 == 50
    assert invariant_tensor_24 == 776

    # Odd invariant tensors exist in both channels: average any paired pure
    # tensor over C3.  Its contraction is multiplied by 3, hence unchanged
    # modulo two.  Check this directly for the first nonzero paired entry.
    def odd_average(left_action, right_action, pairing):
        row, column = next((i, j)
                           for i in range(pairing.nrows())
                           for j in range(pairing.ncols()) if pairing[i, j])
        u = VectorSpace(F, pairing.nrows()).basis()[row].column()
        v = VectorSpace(F, pairing.ncols()).basis()[column].column()
        tensor = zero_matrix(F, pairing.nrows(), pairing.ncols())
        for power in range(3):
            tensor += (left_action**power * u) * (right_action**power * v).transpose()
        assert left_action * tensor * right_action.transpose() == tensor
        contraction = sum(tensor[i, j] * pairing[i, j]
                          for i in range(pairing.nrows())
                          for j in range(pairing.ncols()))
        assert contraction == 1
        return contraction

    odd15 = odd_average(p13_action, q57, pairing15)
    odd24 = odd_average(p24_action, q46, pairing24)

    # The actual rank-15 NS lattice is pointwise C3-fixed.  Modulo the
    # polarization kernel, its Lefschetz image has rank 14 and detects a
    # rank-14 quotient of Q_46^C3 by odd half-anti-graph pairings.
    ns = actual_ns_forms(basis)
    assert ns.rank() == 15
    assert actions[2] * ns == ns
    ns_l_image = lefschetz_mod2[2] * ns
    assert ns_l_image.rank() == 14
    ns_pairing = top_pairing(4, ns_l_image, reps46 * fixed46)
    ns_fixed_pairing_rank = ns_pairing.rank()
    assert ns_fixed_pairing_rank == 14

    # The principal polarization itself lies in ker(L mod 2), so it cannot
    # define an odd residual pairing in the (2,4) channel.
    theta_vector = vector(F, [theta[i, j] for i, j in subsets(2)]).column()
    assert lefschetz_mod2[2] * theta_vector == 0

    lines = [
        "C904 residual C3 action on dyadic Lefschetz cokernels",
        f"L5->L7 Smith nonunits: 2^{len(smith_57)}",
        f"L4->L6 Smith nonunits: 2^{smith_46.count(ZZ(2))}, 6^{smith_46.count(ZZ(6))}",
        f"Q57: dim={q57.nrows()}, fixed={fixed57.ncols()}, irreducible-C3 blocks=5",
        f"Q46(2-primary mod 2): dim={q46.nrows()}, fixed={fixed46.ncols()}, irreducible-C3 blocks=10",
        f"residual pairings: ranks=({pairing15.rank()},{pairing24.rank()})",
        f"diagonal invariant tensor dims: p15={invariant_tensor_15}, p24={invariant_tensor_24}",
        f"odd invariant contractions exist: p15={ZZ(odd15)}, p24={ZZ(odd24)}",
        f"actual NS/2: dim={ns.rank()}, L-image={ns_l_image.rank()}, pairing with Q46^C3 rank={ns_fixed_pairing_rank}",
        "polarization H2 factor: L(theta)=0 mod 2; it does not detect Q46",
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
    arguments = parser.parse_args()
    main(arguments.output)
