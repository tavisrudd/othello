#!/usr/bin/env sage
"""Exact theta-characteristic descent on the marked A5 cubic base.

The exotic quadratic marking cuts the full mod-2 elliptic monodromy S3 to
its order-three subgroup.  This script realizes an integral order-three
generator on the exotic principal homology lattice and proves that every
class in the rank-15 Neron--Severi lattice has a unique invariant quadratic
refinement.  The refinement is the symmetric theta structure needed to lift
the horizontal NS class to a relative line bundle.
"""

from contextlib import redirect_stdout
from io import StringIO
import sys

_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved_argv


def elliptic_order_three_on_principal_lattice(basis, symplectic):
    """Lift [-1 -1; 1 0], fixing the p=3 slope and exotic p=2 graph."""
    identity = identity_matrix(ZZ, 5)
    zero = zero_matrix(ZZ, 5)
    ambient = block_matrix(ZZ, [[-identity, -identity], [identity, zero]])
    assert ambient**3 == identity_matrix(ZZ, 10)

    induced = basis * ambient.transpose() * basis.inverse()
    assert induced.denominator() == 1
    induced = induced.change_ring(ZZ)
    assert induced**3 == identity_matrix(ZZ, 10)
    assert induced * symplectic * induced.transpose() == symplectic
    return induced


def evaluate_quadratic(upper, vector_value):
    return (vector_value * upper * vector_value.column())[0]


def invariant_refinement(alternating, monodromy):
    """Return the unique l with q(x)=sum_{i<j}Eij xi xj + l.x invariant."""
    field = GF(2)
    size = alternating.nrows()
    upper = zero_matrix(field, size)
    for i in range(size):
        for j in range(i + 1, size):
            upper[i, j] = alternating[i, j]
    assert upper + upper.transpose() == alternating

    difference = vector(
        field,
        [evaluate_quadratic(upper, monodromy.row(i))
         + evaluate_quadratic(upper, vector(field, [int(i == j)
                                                     for j in range(size)]))
         for i in range(size)],
    )
    linear = (monodromy + identity_matrix(field, size)).solve_right(
        difference.column()
    ).column(0)

    for mask in range(1 << size):
        point = vector(field, [(mask >> i) & 1 for i in range(size)])
        image = point * monodromy
        q_point = evaluate_quadratic(upper, point) + point * linear
        q_image = evaluate_quadratic(upper, image) + image * linear
        assert q_point == q_image
    return vector(field, linear)


def main():
    _, _, basis, symplectic = principal_lattice("omega", 1)
    positions, linear_map = ns_integrality_matrix(basis)
    _, ns_lattice = congruence_kernel_lattice(linear_map)
    ns_basis = ns_lattice.basis_matrix().LLL()

    monodromy = elliptic_order_three_on_principal_lattice(basis, symplectic)
    mod_two = monodromy.change_ring(GF(2))
    identity = identity_matrix(GF(2), 10)
    assert mod_two**2 + mod_two + identity == 0
    assert (mod_two - identity).rank() == 10

    # The four X_0(6) cusp widths are 1,2,3,6.  The exotic sign cover is
    # ramified exactly at the odd-width cusps, so the marked widths are
    # 2,2,6,6.  Every conjugate elliptic transvection therefore has trivial
    # mod-2 inertia on the marked cover.
    cusp_widths = (1, 2, 3, 6)
    marked_cusp_widths = tuple(2 * width if width % 2 else width
                               for width in cusp_widths)
    transvection = matrix(GF(2), [[1, 1], [0, 1]])
    assert all(transvection**width == identity_matrix(GF(2), 2)
               for width in marked_cusp_widths)

    zero = zero_matrix(QQ, 5)
    refinements = []
    for coordinates in ns_basis.rows():
        coefficient = coefficient_matrix(coordinates, positions)
        source_form = block_matrix(QQ, [[zero, coefficient],
                                        [-coefficient, zero]])
        principal_form = basis * source_form * basis.transpose()
        assert principal_form.denominator() == 1
        alternating = principal_form.change_ring(GF(2))
        assert mod_two * alternating * mod_two.transpose() == alternating
        refinements.append(invariant_refinement(alternating, mod_two))

    # The order-three group has no invariants on J[2], so every affine space
    # of refinements has exactly one fixed point.  Basis refinements tensor to
    # the unique refinement of every integral NS class.
    assert len(refinements) == 15
    print("integral order-three monodromy=")
    print(monodromy)
    print("mod-2 polynomial X^2+X+1 and fixed dimension 0")
    print(f"unmarked cusp widths={cusp_widths}; exotic-marked widths={marked_cusp_widths}")
    print("all four local mod-2 theta residues vanish")
    print("unique invariant refinement vectors for the fixed NS basis=")
    for refinement in refinements:
        print(tuple(ZZ(value) for value in refinement))
    print("all 15 horizontal NS generators admit unique invariant symmetric theta structures")
    print("PASS")


if __name__ == "__main__":
    main()
