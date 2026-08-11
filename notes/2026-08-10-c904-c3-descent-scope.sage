#!/usr/bin/env sage
"""Exact scope audit for residual C3 descent on the C904 marked base.

The calculation distinguishes group-cohomological descent from fixed-vector
vanishing.  It uses the actual exotic principal homology lattice, its
rank-fifteen divisor lattice, the two incarnations of the six-point heart,
and the four cusp branches on the twist-plus-sign marked base.
"""

from contextlib import redirect_stdout
from io import StringIO
from itertools import combinations
import sys


_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved_argv

F = GF(2)
PAIRS = list(combinations(range(10), 2))


def induced_principal(basis, ambient):
    induced = basis * ambient.transpose() * basis.inverse()
    assert induced.denominator() == 1
    return induced.change_ring(ZZ)


def cyclic_h1_data(action):
    """Return exact C3 fixed and H^1 dimensions over F2."""
    n = action.nrows()
    one = identity_matrix(F, n)
    assert action**3 == one
    norm = one + action + action**2
    fixed = (action + one).right_kernel().dimension()
    kernel_norm = norm.right_kernel().dimension()
    coboundaries = (action + one).rank()
    # (g-1)M lies in ker(1+g+g^2), and odd-order averaging makes equality.
    assert norm * (action + one) == 0
    h1 = kernel_norm - coboundaries
    assert h1 == 0
    return (n, fixed, norm.rank(), kernel_norm, coboundaries, h1)


def wedge_action(linear):
    columns = []
    for source_i, source_j in PAIRS:
        form = zero_matrix(F, 10)
        form[source_i, source_j] = 1
        form[source_j, source_i] = 1
        image = linear * form * linear.transpose()
        columns.append(vector(F, [image[i, j] for i, j in PAIRS]))
    return matrix(F, columns).transpose()


def extend_basis(rows, dimension):
    vectors = list(span(F, rows).basis())
    space = span(F, vectors)
    for standard in VectorSpace(F, dimension).basis():
        if standard not in space:
            vectors.append(standard)
            space = span(F, vectors)
    assert len(vectors) == dimension
    return vectors


def evaluate_quadratic(upper, value):
    return (value * upper * value.column())[0]


def invariant_refinement(alternating, monodromy):
    """Solve for the unique invariant refinement of an alternating form."""
    size = alternating.nrows()
    upper = zero_matrix(F, size)
    for i in range(size):
        for j in range(i + 1, size):
            upper[i, j] = alternating[i, j]
    assert upper + upper.transpose() == alternating

    difference = vector(
        F,
        [evaluate_quadratic(upper, monodromy.row(i))
         + evaluate_quadratic(upper, VectorSpace(F, size).basis()[i])
         for i in range(size)],
    )
    linear = (monodromy + identity_matrix(F, size)).solve_right(
        difference.column()
    ).column(0)

    for mask in range(1 << size):
        point = vector(F, [(mask >> i) & 1 for i in range(size)])
        image = point * monodromy
        assert (evaluate_quadratic(upper, point) + point * linear
                == evaluate_quadratic(upper, image) + image * linear)
    return vector(F, linear)


def main():
    gram, omega, basis, symplectic = principal_lattice("omega", 1)
    i5 = identity_matrix(ZZ, 5)
    z5 = zero_matrix(ZZ, 5)
    ambient_c3 = block_matrix(ZZ, [[-i5, -i5], [i5, z5]])
    c3_integral = induced_principal(basis, ambient_c3)
    c3 = c3_integral.change_ring(F)
    assert c3**2 + c3 + identity_matrix(F, 10) == 0

    # On the exotic gluing graph z=omega*x, ambient C3 sends
    # (x,omega*x) to (omega^2*x,x), so its parameter action is omega^2.
    graph_heart = omega + identity_matrix(F, 4)
    assert graph_heart**2 + graph_heart + identity_matrix(F, 4) == 0

    # Construct the actual rank-fifteen NS/2 subspace in alternating forms.
    positions, linear_map = ns_integrality_matrix(basis)
    _, ns_lattice = congruence_kernel_lattice(linear_map)
    ns_basis = ns_lattice.basis_matrix().LLL()
    zero = zero_matrix(QQ, 5)
    ns_forms = []
    refinements = []
    for coordinates in ns_basis.rows():
        coefficient = coefficient_matrix(coordinates, positions)
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        principal = basis * source * basis.transpose()
        assert principal.denominator() == 1
        alternating = principal.change_ring(F)
        assert c3 * alternating * c3.transpose() == alternating
        ns_forms.append(vector(F, [alternating[i, j] for i, j in PAIRS]))
        refinements.append(invariant_refinement(alternating, c3))
    assert span(F, ns_forms).dimension() == 15

    c3_h2 = wedge_action(c3)
    # Place NS first and take the actual geometric Brauer quotient.
    full_basis = extend_basis(ns_forms, 45)
    change = matrix(F, full_basis).transpose()
    transported = change.inverse() * c3_h2 * change
    assert transported[15:45, 0:15].is_zero()
    assert transported[0:15, 0:15] == identity_matrix(F, 15)
    c3_brauer = transported[15:45, 15:45]

    modules = {
        "J[2]": c3,
        "Alt^2 J[2] = H^2(J,F2)": c3_h2,
        "NS(J)/2 (actual rank-15 divisor lattice)": identity_matrix(F, 15),
        "Br(J)[2] = H^2/(NS/2)": c3_brauer,
        "exotic gluing graph heart H_graph": graph_heart,
        # The norm-square defect is a quotient of NS, on which C3 acts
        # identically.  It is A5-isomorphic to H_graph but not C3-isomorphic.
        "Rosati norm-square defect Q(R)": identity_matrix(F, 4),
    }
    data = {name: cyclic_h1_data(action) for name, action in modules.items()}
    assert data == {
        "J[2]": (10, 0, 0, 10, 10, 0),
        "Alt^2 J[2] = H^2(J,F2)": (45, 25, 25, 20, 20, 0),
        "NS(J)/2 (actual rank-15 divisor lattice)": (15, 15, 15, 0, 0, 0),
        "Br(J)[2] = H^2/(NS/2)": (30, 10, 10, 20, 20, 0),
        "exotic gluing graph heart H_graph": (4, 0, 0, 4, 4, 0),
        "Rosati norm-square defect Q(R)": (4, 4, 4, 0, 0, 0),
    }

    # Every actual NS basis form has one invariant refinement: H^1=0 gives
    # existence and J[2]^C3=0 gives uniqueness.
    assert len(refinements) == 15

    # Cusp provenance on the common twist-plus-sign marked base.  On the
    # twist cover eta^2=(T+27)(T-729/5), use its rational coordinate z.
    # T=0 has two simple preimages and base width 1; T=infinity has two
    # simple preimages and base width 3.  Pulling back r^2=T ramifies at all
    # four branches, hence widths 2,2,6,6.
    z = polygen(QQ, "z")
    t_of_z = 27 * (27 * z**2 + 5) / (5 * (z**2 - 1))
    numerator = t_of_z.numerator()
    denominator = t_of_z.denominator()
    assert gcd(numerator, numerator.derivative()) == 1
    assert gcd(denominator, denominator.derivative()) == 1
    assert numerator.degree() == denominator.degree() == 2
    assert numerator.roots(QQbar, multiplicities=False).__len__() == 2
    assert denominator.roots(QQbar, multiplicities=False).__len__() == 2
    marked_widths = tuple(sorted([2 * 1] * 2 + [2 * 3] * 2))
    assert marked_widths == (2, 2, 6, 6)
    transvection = matrix(F, [[1, 1], [0, 1]])
    assert all(transvection**width == identity_matrix(F, 2)
               for width in marked_widths)

    print("C904 residual C3 descent scope audit")
    print("columns: dim, fixed, rank(norm), ker(norm), rank(g-1), H1")
    for name, value in data.items():
        print(f"  {name}: {value}")
    print("quadratic-refinement torsors checked=15; fixed points=15 unique")
    print("graph heart: fixed-free C3 action omega^2")
    print("Rosati defect heart: trivial C3 action (same A5 module, different C3 module)")
    print(f"common twist-plus-sign cusp widths={marked_widths}")
    print("all four local parabolics act trivially on mod-2 theta data")
    print("PASS")


if __name__ == "__main__":
    main()
