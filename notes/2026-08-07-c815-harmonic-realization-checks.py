#!/usr/bin/env python3
"""Exact checks for the degree-six harmonic realization of the Clebsch four-space.

Every quantity below is computed in exact arithmetic over Q(sqrt 5) with sympy.
The script certifies the numerical inputs of the harmonic-realization section of
the Clebsch passages manuscript, and the auxiliary identities selected as the
formalization route for that section:

  face-axis geometry   the ten displayed vectors have squared norm 3 and their
                       pairwise squared inner products are 5 on disjoint label
                       pairs and 1 on intersecting label pairs, so the labelling
                       realizes the Kneser graph KG(5,2);
  Legendre values      P_6(1) = 1, P_6(sqrt5/3) = -65/243, P_6(1/3) = 47/243;
  zonal harmonicity    the homogenized zonal polynomial of a unit axis is
                       harmonic;
  apolar identity      Z_u(d)Z_v = 10395 P_6(u.v) for unit u, v, which is the
                       addition theorem in the apolar normalization;
  Gaussian recursion   the Gaussian moment functional satisfies N(x_i p) =
                       N(d_i p), and N(p q) = p(d) q when p is harmonic;
  Gram matrix          the normalized spherical Gram matrix of the ten zonal
                       harmonics is (196 I + 47 J - 112 A)/(243 * 13), with
                       eigenvalues 110/1053, 140/1053 and 28/1053;
  rotation generators  three explicit rotations over Q(sqrt 5) permute the ten
                       axes and induce (2 5)(3 4), (3 5 4) and (1 2)(3 5) on the
                       five labels, which generate the alternating group;
  spherical cubic      the normalized spherical cubic of the pair-sum harmonic
                       equals -784000/1247103 times sigma_3, as an identity in
                       the five sum-zero label weights, and its marked value on
                       (4,-1,-1,-1,-1) is -15680000/1247103.

Sphere averages are taken with the normalized measure d(omega)/(4 pi) and are
evaluated through the closed monomial formula

  (1/4pi) int omega_1^(2a) omega_2^(2b) omega_3^(2c) =
      (2a-1)!!(2b-1)!!(2c-1)!! / (2a+2b+2c+1)!!,

monomials with an odd exponent averaging to zero.  Identifying that functional
with the surface integral is the one classical input this script does not check.

Replay from the repository root:

    uv run --with sympy python3 notes/2026-08-07-c815-harmonic-realization-checks.py \
        --out notes/2026-08-07-c815-harmonic-realization-checks.json

    uv run --with sympy python3 notes/2026-08-07-c815-harmonic-realization-checks.py \
        --check notes/2026-08-07-c815-harmonic-realization-checks.json
"""

from __future__ import annotations

import argparse
import itertools
import json
import sys

import sympy as sp

X1, X2, X3 = sp.symbols("x1 x2 x3")
XS = (X1, X2, X3)

PHI = (1 + sp.sqrt(5)) / 2
PHI_INV = PHI - 1

# The ten face axes of the manuscript, indexed by the two-subsets of {1,...,5}.
FACE_AXIS = {
    (1, 2): (-1, -1, -1),
    (1, 3): (-1, -1, 1),
    (1, 4): (-1, 1, -1),
    (1, 5): (-1, 1, 1),
    (3, 4): (0, -PHI_INV, -PHI),
    (2, 5): (0, -PHI_INV, PHI),
    (4, 5): (-PHI_INV, -PHI, 0),
    (2, 3): (-PHI_INV, PHI, 0),
    (3, 5): (-PHI, 0, -PHI_INV),
    (2, 4): (PHI, 0, -PHI_INV),
}
LABELS = sorted(FACE_AXIS)

# Rotations over Q(sqrt 5) permuting the ten axes.
ROTATIONS = {
    "diagonal_two_fold": sp.diag(1, -1, -1),
    "coordinate_three_cycle": sp.Matrix([[0, 0, 1], [1, 0, 0], [0, 1, 0]]),
    "golden_two_fold": sp.Rational(1, 2)
    * sp.Matrix(
        [
            [-PHI, PHI_INV, -1],
            [PHI_INV, -1, -PHI],
            [-1, -PHI, PHI_INV],
        ]
    ),
}


def dot(a, b):
    return sp.expand(sum(u * v for u, v in zip(a, b)))


def double_factorial(n: int) -> sp.Integer:
    value = sp.Integer(1)
    while n > 1:
        value *= n
        n -= 2
    return value


def sphere_moment(poly):
    """Normalized spherical average of a polynomial in x1, x2, x3."""
    p = sp.Poly(sp.expand(poly), *XS)
    total = sp.Integer(0)
    for (a, b, c), coeff in zip(p.monoms(), p.coeffs()):
        if a % 2 or b % 2 or c % 2:
            continue
        total += (
            coeff
            * double_factorial(a - 1)
            * double_factorial(b - 1)
            * double_factorial(c - 1)
            / double_factorial(a + b + c + 1)
        )
    return sp.simplify(sp.expand(total))


def gaussian_moment(poly):
    """Standard Gaussian moment functional on polynomials in x1, x2, x3."""
    p = sp.Poly(sp.expand(poly), *XS)
    total = sp.Integer(0)
    for (a, b, c), coeff in zip(p.monoms(), p.coeffs()):
        if a % 2 or b % 2 or c % 2:
            continue
        total += (
            coeff
            * double_factorial(a - 1)
            * double_factorial(b - 1)
            * double_factorial(c - 1)
        )
    return sp.simplify(sp.expand(total))


def legendre_six(s):
    return sp.Rational(1, 16) * (231 * s**6 - 315 * s**4 + 105 * s**2 - 5)


def zonal(u):
    """Homogeneous degree-six zonal harmonic of a unit axis u."""
    ux = sum(a * b for a, b in zip(u, XS))
    r2 = sum(a**2 for a in XS)
    return sp.expand(
        sp.Rational(1, 16)
        * (231 * ux**6 - 315 * ux**4 * r2 + 105 * ux**2 * r2**2 - 5 * r2**3)
    )


def laplacian(poly):
    return sp.expand(sum(sp.diff(poly, t, 2) for t in XS))


def apolar(p, q):
    """p(d) q, the apolar pairing of two polynomials of the same degree."""
    poly = sp.Poly(sp.expand(p), *XS)
    total = sp.Integer(0)
    for (a, b, c), coeff in zip(poly.monoms(), poly.coeffs()):
        total += coeff * sp.diff(q, X1, a, X2, b, X3, c)
    return sp.expand(total)


def reduce_unit(expr, symbols):
    """Reduce an expression modulo the unit-length relations of the symbols."""
    relations = [sum(s**2 for s in group) - 1 for group in symbols]
    gens = [s for group in symbols for s in group]
    _, rem = sp.reduced(
        sp.Poly(sp.expand(expr), *gens),
        [sp.Poly(rel, *gens) for rel in relations],
    )
    return sp.simplify(rem.as_expr())


def unit_axes():
    return {e: tuple(sp.radsimp(c / sp.sqrt(3)) for c in v) for e, v in FACE_AXIS.items()}


def check_face_axis_geometry(results):
    norms_ok = all(sp.simplify(dot(v, v) - 3) == 0 for v in FACE_AXIS.values())
    products = {}
    for e, f in itertools.combinations(LABELS, 2):
        value = sp.simplify(dot(FACE_AXIS[e], FACE_AXIS[f]) ** 2)
        disjoint = not (set(e) & set(f))
        products[(e, f)] = (value, 5 if disjoint else 1)
    kneser_ok = all(sp.simplify(v - w) == 0 for v, w in products.values())
    results["face_axis_squared_norm"] = 3 if norms_ok else None
    results["face_axis_kneser_squared_products"] = (
        {"disjoint": 5, "intersecting": 1} if kneser_ok else None
    )


def check_legendre_values(results):
    results["legendre_six_values"] = {
        "one": str(sp.nsimplify(legendre_six(sp.Integer(1)))),
        "sqrt5_over_3": str(sp.nsimplify(sp.simplify(legendre_six(sp.sqrt(5) / 3)))),
        "one_third": str(sp.nsimplify(legendre_six(sp.Rational(1, 3)))),
    }


def check_zonal_identities(results):
    u = sp.symbols("u1 u2 u3")
    v = sp.symbols("v1 v2 v3")
    zu = zonal(u)
    zv = zonal(v)
    results["zonal_laplacian_mod_unit"] = str(reduce_unit(laplacian(zu), [u]))
    pairing = apolar(zu, zv)
    target = 10395 * legendre_six(dot(u, v))
    results["apolar_zonal_pairing_residual"] = str(
        reduce_unit(sp.expand(pairing - target), [u, v])
    )


def check_gaussian_recursion(results):
    residuals = []
    for exponents in itertools.product(range(4), repeat=3):
        monomial = X1 ** exponents[0] * X2 ** exponents[1] * X3 ** exponents[2]
        for i, xi in enumerate(XS):
            lhs = gaussian_moment(xi * monomial)
            rhs = gaussian_moment(sp.diff(monomial, xi))
            residuals.append(sp.simplify(lhs - rhs))
    results["gaussian_integration_by_parts_residuals"] = (
        0 if all(r == 0 for r in residuals) else None
    )
    # N(p q) = p(d) q for p harmonic homogeneous, q homogeneous of equal degree.
    harmonic_pairs = [
        (X1**2 - X2**2, X1**2 + 3 * X2 * X3),
        (X1 * X2, X3**2 - X1 * X2),
        (zonal((1, 0, 0)), zonal((0, 1, 0))),
    ]
    residuals = []
    for p, q in harmonic_pairs:
        residuals.append(sp.simplify(gaussian_moment(sp.expand(p * q)) - apolar(p, q)))
    results["gaussian_apolar_residuals"] = 0 if all(r == 0 for r in residuals) else None


def check_gram(results, zonals):
    gram = sp.zeros(10, 10)
    for i, e in enumerate(LABELS):
        for j, f in enumerate(LABELS):
            if j < i:
                gram[i, j] = gram[j, i]
            else:
                gram[i, j] = sphere_moment(sp.expand(zonals[e] * zonals[f]))
    expected = {}
    for i, e in enumerate(LABELS):
        for j, f in enumerate(LABELS):
            if e == f:
                expected[(i, j)] = sp.Rational(1, 13)
            elif not (set(e) & set(f)):
                expected[(i, j)] = sp.Rational(1, 13) * sp.Rational(-65, 243)
            else:
                expected[(i, j)] = sp.Rational(1, 13) * sp.Rational(47, 243)
    ok = all(sp.simplify(gram[i, j] - expected[(i, j)]) == 0 for i in range(10) for j in range(10))
    results["spherical_gram_equals_kernel_over_thirteen"] = bool(ok)
    eigs = {str(sp.nsimplify(k)): int(m) for k, m in gram.eigenvals().items()}
    results["spherical_gram_eigenvalues"] = dict(sorted(eigs.items()))
    return gram


def check_rotations(results):
    data = {}
    for name, R in ROTATIONS.items():
        orthogonal = sp.simplify(R.T * R - sp.eye(3)) == sp.zeros(3, 3)
        det_one = sp.simplify(R.det()) == 1
        induced = {}
        ok = True
        for e in LABELS:
            image = sp.expand(R * sp.Matrix(FACE_AXIS[e]))
            hit = None
            for f in LABELS:
                target = sp.Matrix(FACE_AXIS[f])
                if sp.simplify(image - target) == sp.zeros(3, 1) or sp.simplify(
                    image + target
                ) == sp.zeros(3, 1):
                    hit = f
                    break
            if hit is None:
                ok = False
                break
            induced[e] = hit
        label_permutation = None
        if ok:
            for candidate in itertools.permutations(range(1, 6)):
                sigma = {i + 1: candidate[i] for i in range(5)}
                if all(set(induced[e]) == {sigma[e[0]], sigma[e[1]]} for e in LABELS):
                    label_permutation = [sigma[i] for i in range(1, 6)]
                    break
        data[name] = {
            "orthogonal": bool(orthogonal),
            "determinant_one": bool(det_one),
            "label_permutation": label_permutation,
        }
    results["rotation_generators"] = dict(sorted(data.items()))


def check_spherical_cubic(results, zonals):
    y = sp.symbols("y1 y2 y3 y4 y5")
    weight = {i + 1: y[i] for i in range(5)}
    pair_sum = {e: weight[e[0]] + weight[e[1]] for e in LABELS}
    field = sp.expand(sum(pair_sum[e] * zonals[e] for e in LABELS))

    quadratic = sphere_moment(sp.expand(field**2))
    cubic = sphere_moment(sp.expand(field**3))

    sum_zero = sum(y)
    sigma3 = sp.Rational(1, 3) * sum(t**3 for t in y)

    def reduce_sum_zero(expr):
        _, rem = sp.reduced(
            sp.Poly(sp.expand(expr), *y), [sp.Poly(sum_zero, *y)]
        )
        return sp.simplify(sp.expand(rem.as_expr()))

    quad_target = sp.Rational(140, 351) * sum(t**2 for t in y)
    cubic_target = sp.Rational(-784000, 1247103) * sigma3
    results["spherical_quadratic_residual_mod_sum_zero"] = str(
        reduce_sum_zero(quadratic - quad_target)
    )
    results["spherical_cubic_residual_mod_sum_zero"] = str(
        reduce_sum_zero(cubic - cubic_target)
    )

    marked = {y[0]: 4, y[1]: -1, y[2]: -1, y[3]: -1, y[4]: -1}
    results["marked_quadratic_moment"] = str(sp.nsimplify(quadratic.subs(marked)))
    results["marked_cubic_moment"] = str(sp.nsimplify(cubic.subs(marked)))
    results["marked_sigma_three"] = str(sp.nsimplify(sigma3.subs(marked)))


def check_pair_sum_eigenspace(results):
    y = sp.symbols("y1 y2 y3 y4 y5")
    weight = {i + 1: y[i] for i in range(5)}
    residuals = []
    for e in LABELS:
        neighbours = [f for f in LABELS if not (set(e) & set(f))]
        value = sum(weight[f[0]] + weight[f[1]] for f in neighbours)
        residual = sp.expand(value + 2 * (weight[e[0]] + weight[e[1]]))
        _, rem = sp.reduced(sp.Poly(residual, *y), [sp.Poly(sum(y), *y)])
        residuals.append(sp.simplify(rem.as_expr()))
    results["pair_sum_petersen_eigenvalue"] = -2 if all(r == 0 for r in residuals) else None


def run() -> dict:
    results: dict = {"schema": "clebsch-harmonic-realization-checks/1"}
    zonals = {e: zonal(u) for e, u in unit_axes().items()}
    check_face_axis_geometry(results)
    check_legendre_values(results)
    check_zonal_identities(results)
    check_gaussian_recursion(results)
    check_gram(results, zonals)
    check_rotations(results)
    check_pair_sum_eigenspace(results)
    check_spherical_cubic(results, zonals)
    return results


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--out", help="write the certificate to this path")
    parser.add_argument("--check", help="compare against a tracked certificate")
    args = parser.parse_args()

    results = run()
    text = json.dumps(results, indent=2, sort_keys=True) + "\n"

    if args.check:
        with open(args.check, encoding="utf-8") as handle:
            tracked = handle.read()
        if tracked != text:
            sys.stderr.write("certificate mismatch\n")
            return 1
        sys.stdout.write("certificate matches\n")
        return 0

    if args.out:
        with open(args.out, "w", encoding="utf-8") as handle:
            handle.write(text)
    else:
        sys.stdout.write(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
