#!/usr/bin/env python3
"""Exact lattice certificate for the C904 quartic--cubic Hecke neighbor.

The common six-axis polarization has a two-primary discriminant heart of
dimension four.  The quartic and cubic principal lattices use two distinct
maximal-isotropic graphs.  Distinct points of P1(F4) are transverse, so the
integral comparison reduces to four copies of the elementary transverse
2-gluing, plus one common unimodular symplectic plane.

This script proves the claimed Smith type and polarized multiplier over Z.
The geometric identification of the two variations and the literature
boundary are kept in the accompanying human report.
"""

from contextlib import redirect_stdout
from io import StringIO
from itertools import product
from pathlib import Path
import sys

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form


def integer_valuation(value, prime):
    exponent = 0
    while value % prime == 0:
        value //= prime
        exponent += 1
    return exponent, value


def hilbert_symbol_integer(a, b, prime):
    """Hilbert symbol for positive integers at a finite prime."""
    alpha, unit_a = integer_valuation(a, prime)
    beta, unit_b = integer_valuation(b, prime)
    if prime == 2:
        epsilon_a = ((unit_a - 1) // 2) & 1
        epsilon_b = ((unit_b - 1) // 2) & 1
        omega_a = ((unit_a * unit_a - 1) // 8) & 1
        omega_b = ((unit_b * unit_b - 1) // 8) & 1
        parity = epsilon_a * epsilon_b + alpha * omega_b + beta * omega_a
    else:
        legendre_a = 1 if pow(unit_a % prime, (prime - 1) // 2, prime) == 1 else -1
        legendre_b = 1 if pow(unit_b % prime, (prime - 1) // 2, prime) == 1 else -1
        sign = -1 if ((prime - 1) // 2) & 1 else 1
        return sign ** (alpha * beta) * legendre_a ** beta * legendre_b ** alpha
    return -1 if parity & 1 else 1


def hasse_invariant(diagonal, prime):
    result = 1
    for left in range(len(diagonal)):
        for right in range(left + 1, len(diagonal)):
            result *= hilbert_symbol_integer(diagonal[left], diagonal[right], prime)
    return result


def gf4_mul(a, b):
    """F4=F2[w]/(w^2+w+1), encoded by a0+2*a1."""
    a0, a1 = a & 1, (a >> 1) & 1
    b0, b1 = b & 1, (b >> 1) & 1
    return ((a0 * b0 + a1 * b1) & 1) | (
        ((a0 * b1 + a1 * b0 + a1 * b1) & 1) << 1
    )


def gf4_add(a, b):
    return a ^ b


def gf4_vec_scale(a, vector):
    return tuple(gf4_mul(a, x) for x in vector)


def graph(slope):
    """The F2 vectors of a graph H -> H, H=F4^2; None is vertical."""
    elements = tuple(product(range(4), repeat=2))
    if slope is None:
        return {((0, 0), x) for x in elements}
    return {(x, gf4_vec_scale(slope, x)) for x in elements}


def block_diag(blocks):
    rows = sum(block.rows for block in blocks)
    cols = sum(block.cols for block in blocks)
    result = sp.zeros(rows, cols)
    r = c = 0
    for block in blocks:
        result[r:r + block.rows, c:c + block.cols] = block
        r += block.rows
        c += block.cols
    return result


def main():
    # The two quadratic markings needed on the cubic side become an explicit
    # biquadratic cover after pullback along the corrected X0(6)->X0(3) map.
    t = sp.symbols("t")
    capital_t = sp.factor(
        -4 * (4 * t - 1)**2 * (10 * t - 7)
        / ((2 * t - 1)**2 * (6 * t - 1))
    )
    twist = sp.factor((capital_t + 27) * (capital_t - sp.Rational(729, 5)))
    mod2_radical = -(10 * t - 7) * (6 * t - 1)
    twist_radical = (
        -5 * (2 * t + 1) * (26 * t - 11)
        * (796 * t**2 - 596 * t + 79)
    )
    assert sp.factor(capital_t / mod2_radical) == (
        4 * (4 * t - 1)**2 / ((2 * t - 1)**2 * (6 * t - 1)**2)
    )
    assert sp.factor(twist / twist_radical) == (
        (2 * t + 1)**2 / (25 * (2 * t - 1)**4 * (6 * t - 1)**2)
    )
    discriminants = (
        sp.discriminant(mod2_radical, t),
        sp.discriminant(twist_radical, t),
        sp.discriminant(sp.expand(mod2_radical * twist_radical), t),
    )
    assert all(value != 0 for value in discriminants)
    assert sp.gcd(sp.Poly(mod2_radical, t), sp.Poly(twist_radical, t)).degree() == 0
    # Parametrize the genus-zero mod-2 cover through (t,u)=(1/4,3/2).
    # The remaining square root gives a hyperelliptic genus-three model for
    # the full biquadratic marking cover.
    x = sp.symbols("x")
    t_of_x = (x**2 - 12 * x + 148) / (4 * (x**2 + 60))
    u_of_x = sp.Rational(3, 2) + x * (t_of_x - sp.Rational(1, 4))
    assert sp.factor(u_of_x**2 - mod2_radical.subs(t, t_of_x)) == 0
    hyperelliptic_polynomial = sp.factor(
        -5
        * (3 * x**2 - 12 * x + 268)
        * (9 * x**2 - 228 * x + 164)
        * (9 * x**2 - 36 * x - 1244)
        * (9 * x**2 + 156 * x - 604)
    )
    assert sp.factor(
        twist_radical.subs(t, t_of_x)
        - hyperelliptic_polynomial / (16 * (x**2 + 60)**4)
    ) == 0
    assert sp.degree(hyperelliptic_polynomial, x) == 8
    assert sp.discriminant(hyperelliptic_polynomial, x) != 0

    # The five A5-stable halves are P1(F4).  Every distinct pair is
    # transverse as an F2-subspace of H+H (dimension 8 over F2).
    slopes = (None, 0, 1, 2, 3)
    graphs = {slope: graph(slope) for slope in slopes}
    assert all(len(value) == 2**4 for value in graphs.values())
    intersections = {
        (left, right): len(graphs[left] & graphs[right])
        for left in slopes
        for right in slopes
    }
    assert all(
        size == (2**4 if left == right else 1)
        for (left, right), size in intersections.items()
    )
    # In particular each S6-rational slope and each exotic F4\F2 slope are
    # transverse.  This is independent of which member of either orbit is
    # selected by the marking.
    assert all(
        intersections[(rational, exotic)] == 1
        for rational in (None, 0, 1)
        for exotic in (2, 3)
    )

    h = 4  # rank of the two-primary six-point heart
    m = 1  # the remaining unimodular coefficient direction
    g = h + m
    j2 = sp.Matrix([[0, 1], [-1, 0]])

    # Ambient common lattice: four symplectic planes of scale two and one
    # unimodular plane.  Br and Be are bases of the two self-dual overlattices.
    omega0 = block_diag([2 * j2] * h + [j2] * m)
    rational_blocks = [sp.diag(sp.Rational(1, 2), 1)] * h + [sp.eye(2)] * m
    exotic_blocks = [sp.diag(1, sp.Rational(1, 2))] * h + [sp.eye(2)] * m
    br = block_diag(rational_blocks)
    be = block_diag(exotic_blocks)

    jr = sp.simplify(br.T * omega0 * br)
    je = sp.simplify(be.T * omega0 * be)
    principal_form = block_diag([j2] * g)
    assert jr == principal_form == je

    # Scalar 1 does not send the rational gluing lattice into the exotic
    # one.  Scalar 2 does, and is primitive.  Its integral matrix is computed
    # in the two principal bases.
    identity_comparison = sp.simplify(be.inv() * br)
    assert any(not entry.is_Integer for entry in identity_comparison)
    f = sp.simplify(be.inv() * (2 * br))
    assert all(entry.is_Integer for entry in f)
    assert sp.gcd_list([int(entry) for entry in f]) == 1
    assert f.T * je * f == 4 * jr

    snf = smith_normal_form(f, domain=sp.ZZ)
    invariants = tuple(abs(int(snf[index, index])) for index in range(2 * g))
    expected = (1,) * h + (2,) * (2 * m) + (4,) * h
    assert invariants == expected
    assert abs(int(f.det())) == 4**g == 2**10

    # The six oriented axis norms form a tight frame: sum N_i=6.  Therefore
    # the cross-axis correspondence 6*id is exactly three times the primitive
    # map f=2*id, but not six times an integral map.
    six_identity = sp.simplify(be.inv() * (6 * br))
    assert six_identity == 3 * f
    assert all(entry.is_Integer for entry in six_identity)
    assert any(not entry.is_Integer for entry in six_identity / 6)

    # The six axes also expose the exact parity ceiling of the simplest Chow
    # upgrade.  In the five-axis basis their coefficient polarization is
    # G=6I-J, while the sixth axis is minus the sum of the first five.  Thus
    # the sum of the six elliptic curve classes is six times the ppav minimal
    # curve class.  It does not produce the missing odd class.
    coefficient_gram = 6 * sp.eye(5) - sp.ones(5)
    simplex_axes = [sp.eye(5).col(index) for index in range(5)]
    simplex_axes.append(-sp.ones(5, 1))
    axis_class_sum = sum(
        (vector * vector.T for vector in simplex_axes), sp.zeros(5)
    )
    assert coefficient_gram.det() == 6**4
    assert axis_class_sum == sp.eye(5) + sp.ones(5)
    assert coefficient_gram * axis_class_sum == 6 * sp.eye(5)

    # A second tempting shortcut is a polarized similitude from the product
    # ppav E^5.  Rational LDL diagonalization gives the square-equivalent
    # form <5,30,2,1,3>.  Its Hasse invariants are -1 at 2 and 3, whereas the
    # product form <1,1,1,1,1> has invariant +1 everywhere.  Since the
    # determinant forces any scalar multiplier to be a rational square, G is
    # not rationally similar to the product principal polarization.
    lower, diagonal_matrix = coefficient_gram.LDLdecomposition(hermitian=False)
    assert lower * diagonal_matrix * lower.T == coefficient_gram
    assert tuple(diagonal_matrix.diagonal()) == (
        5, sp.Rational(24, 5), sp.Rational(9, 2), 4, 3
    )
    square_class_diagonal = (5, 30, 2, 1, 3)
    hasse = {
        prime: hasse_invariant(square_class_diagonal, prime)
        for prime in (2, 3, 5)
    }
    assert hasse == {2: -1, 3: -1, 5: 1}

    # Generic version: h transverse scale-two planes and m common planes.
    # This records the theorem rather than just the fivefold instance.
    for hh in range(1, 7):
        for mm in range(0, 4):
            gg = hh + mm
            ambient = block_diag([2 * j2] * hh + [j2] * mm)
            left = block_diag(
                [sp.diag(sp.Rational(1, 2), 1)] * hh + [sp.eye(2)] * mm
            )
            right = block_diag(
                [sp.diag(1, sp.Rational(1, 2))] * hh + [sp.eye(2)] * mm
            )
            comparison = sp.simplify(right.inv() * (2 * left))
            form_left = sp.simplify(left.T * ambient * left)
            form_right = sp.simplify(right.T * ambient * right)
            assert comparison.T * form_right * comparison == 4 * form_left
            diagonal = smith_normal_form(comparison, domain=sp.ZZ)
            got = tuple(abs(int(diagonal[i, i])) for i in range(2 * gg))
            want = (1,) * hh + (2,) * (2 * mm) + (4,) * hh
            assert got == want
            assert abs(int(comparison.det())) == 4**gg

    print("Quartic--cubic transverse two-gluing certificate")
    print(f"  X0(6)->X0(3): T(t)={capital_t}")
    print(f"  mod-2 marking square class R(t)={sp.factor(mod2_radical)}")
    print(f"  twist marking square class S(t)={sp.factor(twist_radical)}")
    print("  genera of R, S, and RS double covers: 0,1,2; biquadratic cover genus=3")
    print(f"  genus-3 parametrization t(x)={sp.factor(t_of_x)}")
    print(f"  hyperelliptic model Y^2={hyperelliptic_polynomial}")
    print("  P1(F4) graphs: every distinct pair has zero vector as its only intersection")
    print("  rational S6 orbit={infinity,0,1}; exotic A5 orbit={w,w+1}")
    print("  common lattice: four scale-2 symplectic planes plus one unimodular plane")
    print("  primitive integral comparison: f=2*id")
    print("  polarized multiplier: f^dagger f=[4]")
    print(f"  Smith invariants={invariants}")
    print("  kernel=(Z/2)^2 + (Z/4)^4; degree=2^10")
    print("  six-axis tight-frame map=6*id=3f")
    print("  sum of six elliptic axis classes=6 times the ppav minimal curve class")
    print("  G=6I-J has Hasse invariants -1 at p=2,3: no product-ppav similitude")
    print("  general transverse-gluing theorem checked for 1<=h<=6, 0<=m<=3")
    print("PASS")


if __name__ == "__main__":
    stream = StringIO()
    with redirect_stdout(stream):
        main()
    rendered = stream.getvalue()
    target = Path(__file__).with_suffix(".out")
    if sys.argv[1:] == ["--write"]:
        target.write_text(rendered)
    elif sys.argv[1:] == ["--check"]:
        assert target.read_text() == rendered
        print("CHECK PASS")
    elif not sys.argv[1:]:
        print(rendered, end="")
    else:
        raise SystemExit("usage: quartic-cubic-hecke-neighbor.py [--write|--check]")
