#!/usr/bin/env sage
"""Full NS(JxJ) divisor-cube image in the p15 inverse-Lefschetz lattice."""

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


def actual_divisors(basis):
    positions, linear_map = ns_integrality_matrix(basis)
    _, ns_lattice = congruence_kernel_lattice(linear_map)
    zero = zero_matrix(QQ, 5)
    result = []
    for coordinates in ns_lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions)
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        principal = basis * source * basis.transpose()
        assert principal.denominator() == 1
        result.append(two_form(principal.change_ring(ZZ)))
    assert len(result) == 15
    return result


def integral_endomorphism_lattice(basis):
    """Integral points in the 25-dimensional coefficient-endomorphism space."""
    rational_rows = []
    for i in range(5):
        for j in range(5):
            coefficient = zero_matrix(QQ, 5)
            coefficient[i, j] = 1
            ambient = block_diagonal_matrix(coefficient, coefficient)
            principal = basis * ambient.transpose() * basis.inverse()
            rational_rows.append(vector(QQ, principal.list()))
    denominator = lcm(entry.denominator() for row in rational_rows for entry in row)
    seed = span(ZZ, [vector(ZZ, denominator * row) for row in rational_rows])
    endomorphisms = seed.saturation()
    assert endomorphisms.rank() == 25
    matrices = [matrix(ZZ, 10, 10, row)
                for row in endomorphisms.basis_matrix().rows()]
    return endomorphisms, matrices


def one_form(index):
    return {(index,): ZZ.one()}


def inverse_lefschetz_contraction(surface, theta):
    """The left-factor contraction shared by all cross divisors."""
    theta2 = wedge(theta, theta)
    top = tuple(range(10))
    contraction = zero_matrix(ZZ, 10, 10)
    for left_index in range(10):
        for input_index in range(10):
            value = wedge(wedge(wedge(theta2, surface), one_form(input_index)),
                          one_form(left_index))
            contraction[left_index, input_index] = value.get(top, 0)
    return contraction


def main(output_path=None):
    _, _, basis, symplectic = principal_lattice("omega", 1)
    theta = two_form(symplectic)
    divisors = actual_divisors(basis)
    end_lattice, endomorphisms = integral_endomorphism_lattice(basis)

    surface_pairs = []
    surfaces = []
    for i in range(len(divisors)):
        for j in range(i, len(divisors)):
            surface_pairs.append((i, j))
            surfaces.append(wedge(divisors[i], divisors[j]))
    assert len(surfaces) == 120

    # For T on the second factor, (1 x T)^*P has cross block Omega*T^t.
    crosses = [symplectic * endomorphism.transpose()
               for endomorphism in endomorphisms]
    maps = []
    divided_maps = []
    for pair, surface in zip(surface_pairs, surfaces):
        contraction = inverse_lefschetz_contraction(surface, theta)
        for cross in crosses:
            # cross has coefficient cross[left,right].
            action = vector(ZZ, (cross.transpose() * contraction).list())
            maps.append(action)
            divided_maps.append(action)
            if pair[0] == pair[1]:
                assert all(value % 2 == 0 for value in action)
                divided_maps.append(vector(ZZ, [value // 2 for value in action]))
    assert len(maps) == 3000
    map_lattice = span(ZZ, maps)
    assert map_lattice.rank() == 25
    divided_map_lattice = span(ZZ, divided_maps)
    assert divided_map_lattice.rank() == 25

    # Normalization check: P times theta^2/2 acts by +/-12 on L(H1).
    theta2 = wedge(theta, theta)
    assert all(value % 2 == 0 for value in theta2.values())
    theta2_divided = {indices: value // 2 for indices, value in theta2.items()}
    canonical = symplectic.transpose() * \
        inverse_lefschetz_contraction(theta2_divided, theta)
    identity = identity_matrix(ZZ, 10)
    assert canonical in (12 * identity, -12 * identity)

    identity_vector = vector(ZZ, identity.list())
    assert identity_vector in end_lattice
    identity_coordinates = map_lattice.coordinate_vector(identity_vector)
    identity_order = lcm(value.denominator() for value in identity_coordinates)
    divided_identity_coordinates = divided_map_lattice.coordinate_vector(identity_vector)
    divided_identity_order = lcm(value.denominator()
                                 for value in divided_identity_coordinates)

    # Exact quotient of the full integral Hodge-endomorphism order by the
    # divisor-cube p15 image.
    coordinate_rows = []
    for row in map_lattice.basis_matrix().rows():
        coordinates = end_lattice.coordinate_vector(row)
        assert all(value.denominator() == 1 for value in coordinates)
        coordinate_rows.append(vector(ZZ, coordinates))
    inclusion = matrix(ZZ, coordinate_rows)
    assert inclusion.nrows() == inclusion.ncols() == 25
    quotient_invariants = tuple(value for value in inclusion.elementary_divisors()
                                if abs(value) != 1)

    divided_coordinate_rows = []
    for row in divided_map_lattice.basis_matrix().rows():
        coordinates = end_lattice.coordinate_vector(row)
        assert all(value.denominator() == 1 for value in coordinates)
        divided_coordinate_rows.append(vector(ZZ, coordinates))
    divided_inclusion = matrix(ZZ, divided_coordinate_rows)
    divided_quotient_invariants = tuple(
        value for value in divided_inclusion.elementary_divisors()
        if abs(value) != 1
    )

    assert identity_order * identity_vector in map_lattice
    assert all(multiplier * identity_vector not in map_lattice
               for multiplier in range(1, identity_order))
    assert divided_identity_order * identity_vector in divided_map_lattice

    lines = [
        "C904 full NS(JxJ) divisor-cube p15 lattice",
        f"NS(A) rank={len(divisors)}; End(A) rank={end_lattice.rank()}; NS(AxA) rank={2*len(divisors)+end_lattice.rank()}",
        f"p51 generators=120*25={len(maps)}; image rank={map_lattice.rank()}",
        f"canonical P*(theta^2/2) scalar={canonical[0,0]}",
        f"End(A)/p15-image Smith nonunits={quotient_invariants}",
        f"normalized identity order in p15 image={identity_order}",
        f"divided-square generators={15*25}; End(A)/divided-p15 Smith nonunits={divided_quotient_invariants}",
        f"normalized identity order in divided-p15 image={divided_identity_order}",
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
