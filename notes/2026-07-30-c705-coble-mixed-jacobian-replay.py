#!/usr/bin/env python3
"""Independent SymPy replay for the exact characteristic-zero Coble claims."""

import sympy as sp


def main():
    x = sp.symbols("x00 x01 x02 x10 x11 x12 x20 x21 x22")
    z = sp.symbols("z0:4")
    y = sp.symbols("y0:5")
    alpha = (6, 17, 1, -7, -19)
    a0, a1, a2, a3, a4 = alpha

    burkhardt = a0**4 + 8 * a0 * sum(a**3 for a in alpha[1:]) + 48 * a1 * a2 * a3 * a4
    burkhardt_grad = (
        4 * a0**3 + 8 * sum(a**3 for a in alpha[1:]),
        24 * a0 * a1**2 + 48 * a2 * a3 * a4,
        24 * a0 * a2**2 + 48 * a1 * a3 * a4,
        24 * a0 * a3**2 + 48 * a1 * a2 * a4,
        24 * a0 * a4**2 + 48 * a1 * a2 * a3,
    )
    assert burkhardt == 0 and any(burkhardt_grad)

    lines = (
        ((0, 1, 2), (3, 4, 5), (6, 7, 8)),
        ((0, 3, 6), (1, 4, 7), (2, 5, 8)),
        ((0, 4, 8), (1, 5, 6), (2, 3, 7)),
        ((0, 5, 7), (1, 3, 8), (2, 4, 6)),
    )
    f = sp.Rational(a0, 3) * sum(t**3 for t in x)
    for a, family in zip(alpha[1:], lines):
        f += 2 * a * sum(x[i] * x[j] * x[k] for i, j, k in family)
    f = sp.expand(f)

    cubic_witness = (2, -2, -2, -4, 2, 2, -3, -1, -3)
    cubic_sub = dict(zip(x, cubic_witness))
    assert f.subs(cubic_sub) == 0
    cubic_hessian_det = sp.hessian(f, x).subs(cubic_sub).det()
    assert cubic_hessian_det == -309382232474386432

    gamma_plus = (
        y[0],
        y[1],
        y[1],
        y[2],
        y[3],
        y[4],
        y[2],
        y[4],
        y[3],
    )
    s = sp.expand(f.subs(dict(zip(x, gamma_plus))))
    gamma_matrix = sp.zeros(9, 5)
    for i, expression in enumerate(gamma_plus):
        gamma_matrix[i, y.index(expression)] = 1
    ambient_compression = sp.simplify(
        gamma_matrix.T
        * sp.hessian(f, x).subs(dict(zip(x, gamma_plus)))
        * gamma_matrix
    )
    assert ambient_compression == sp.hessian(s, y)

    gamma_minus = (0, z[0], -z[0], z[1], z[2], z[3], -z[1], -z[3], -z[2])
    source_sub = dict(zip(x, gamma_minus))
    q = tuple(sp.expand(sp.diff(f, x[i]).subs(source_sub)) for i in (1, 3, 4, 5))
    expected_q = (
        a0 * z[0] ** 2 - 2 * a2 * z[2] * z[3] - 2 * a3 * z[1] * z[3] - 2 * a4 * z[1] * z[2],
        a0 * z[1] ** 2 + 2 * a1 * z[2] * z[3] + 2 * a3 * z[0] * z[3] - 2 * a4 * z[0] * z[2],
        a0 * z[2] ** 2 + 2 * a1 * z[1] * z[3] - 2 * a2 * z[0] * z[3] + 2 * a4 * z[0] * z[1],
        a0 * z[3] ** 2 + 2 * a1 * z[1] * z[2] + 2 * a2 * z[0] * z[2] - 2 * a3 * z[0] * z[1],
    )
    assert q == tuple(map(sp.expand, expected_q))
    jacobian = sp.Matrix(q).jacobian(z)
    weddle = sp.Poly(sp.expand(jacobian.det()), z)
    primitive_weddle = sp.Poly(
        566 * z[0] ** 3 * z[1]
        - 44 * z[0] ** 3 * z[2]
        + 241 * z[0] ** 3 * z[3]
        - 250 * z[0] * z[1] ** 3
        - 545 * z[0] * z[1] * z[2] * z[3]
        - 250 * z[0] * z[2] ** 3
        - 250 * z[0] * z[3] ** 3
        + 44 * z[1] ** 3 * z[2]
        + 241 * z[1] ** 3 * z[3]
        + 566 * z[1] * z[2] ** 3
        - 566 * z[1] * z[3] ** 3
        - 241 * z[2] ** 3 * z[3]
        - 44 * z[2] * z[3] ** 3,
        z,
    )
    assert weddle == 768 * primitive_weddle
    factors = sp.factor_list(weddle)[1]
    assert len(factors) == 1 and factors[0][0].total_degree() == 4 and factors[0][1] == 1

    generic = jacobian.subs(dict(zip(z, (1, 2, 4, 8))))
    assert generic.det() != 0
    ramification = jacobian.subs(dict(zip(z, (0, 0, 0, 1))))
    assert ramification.rank() == 3
    adj = ramification.adjugate()
    assert adj.rank() == 1 and ramification * adj == sp.zeros(4)

    print(
        "PASS exact Q replay: smooth Burkhardt parameter; full Coble-cubic Hessian; "
        "tau-plus Hessian compression; irreducible Weddle determinant; rank-one adjugate"
    )


if __name__ == "__main__":
    main()
