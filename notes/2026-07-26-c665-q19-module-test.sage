#!/usr/bin/env sage
"""Test the projective-multiplicity obstruction on the q=19 A5 sheet.

The sheet permutation character is computed in GAP.  Its nonprincipal
projective summand has simple socle of dimension 13.  Independently, the
script constructs the 46-dimensional affine conic-quotient module and its
1081-dimensional symmetric square, then computes

    Hom_PSL2(19)(Sym^12(F_19^2), Sym^2(E)).

If this Hom-space has dimension at most one, the quadratic module cannot
contain two copies of the 38-dimensional nonprincipal projective summand.
"""

import argparse
import importlib.util
import json
from pathlib import Path

from sage.all import GF, PolynomialRing, identity_matrix, matrix, vector
from sage.libs.gap.libgap import libgap


Q = 19
F = GF(Q)
HERE = Path(__file__).resolve().parent
PULLBACK_CERTIFICATE = HERE / "2026-07-26-c665-q19-quadratic-pullback.json"


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load("c665_base", HERE / "2026-07-26-c665-balanced-matching-completeness.py")
R = PolynomialRing(F, names=("X", "Y", "Z"))
X, Y, Z = R.gens()

A5_MATCHING = (
    (0, 1),
    (2, 10),
    (3, 14),
    (4, 8),
    (5, 17),
    (6, 18),
    (7, 16),
    (9, 15),
    (11, 12),
    (13, 19),
)


def homogeneous_exponents(degree):
    return tuple(
        (i, j, degree - i - j)
        for i in range(degree + 1)
        for j in range(degree - i + 1)
    )


def monomial(exponent):
    i, j, k = exponent
    return X**i * Y**j * Z**k


def matching_product(matching):
    endpoints = tuple((F(x), F.one()) for x in range(Q)) + ((F.one(), F.zero()),)
    answer = R.one()
    for left, right in matching:
        si, ti = endpoints[left]
        sj, tj = endpoints[right]
        answer *= ti * tj * X - (si * tj + ti * sj) * Y + si * sj * Z
    return answer


DEGREE = (Q - 3) // 2
EXPONENTS = homogeneous_exponents(DEGREE)
BASIS = tuple(monomial(exponent) for exponent in EXPONENTS)
BASIS_INDEX = {exponent: i for i, exponent in enumerate(EXPONENTS)}
CONIC = X * Z - Y**2
BASE_PRODUCT = matching_product(A5_MATCHING)


def coefficient_vector(poly):
    answer = [F.zero()] * len(BASIS)
    for exponent, coefficient in poly.dict().items():
        answer[BASIS_INDEX[tuple(exponent)]] = coefficient
    return answer


def conic_action(g):
    """Column-action matrix on k plus degree-eight conic quotients."""
    a, b, c, d = map(F, g)
    determinant = a * d - b * c
    images = (
        d**2 * X - 2 * b * d * Y + b**2 * Z,
        -c * d * X + (a * d + b * c) * Y - a * b * Z,
        c**2 * X - 2 * a * c * Y + a**2 * Z,
    )

    def rho(poly):
        return poly(*images)

    transformed_conic = rho(CONIC)
    assert transformed_conic == determinant**2 * CONIC
    entries = tuple(int(value) for value in (a, b, c, d))
    endpoint_action = tuple(
        BASE.mobius(entries, x, Q) for x in range(Q + 1)
    )
    transformed_matching = BASE.image(endpoint_action, A5_MATCHING)
    transformed_product = matching_product(transformed_matching)
    rho_base = rho(BASE_PRODUCT)
    pivot = next(exponent for exponent, value in transformed_product.dict().items() if value)
    product_scale = rho_base.monomial_coefficient(monomial(pivot))
    product_scale /= transformed_product.monomial_coefficient(monomial(pivot))
    assert rho_base == product_scale * transformed_product

    cocycle, remainder = (transformed_product - BASE_PRODUCT).quo_rem(CONIC)
    assert remainder == 0 and cocycle.degree() <= DEGREE

    dimension = 1 + len(BASIS)
    action = matrix(F, dimension, dimension)
    action[0, 0] = 1
    for row, value in enumerate(coefficient_vector(cocycle), start=1):
        action[row, 0] = value
    for column, basis_vector in enumerate(BASIS, start=1):
        transformed = determinant**2 / product_scale * rho(basis_vector)
        for row, value in enumerate(coefficient_vector(transformed), start=1):
            action[row, column] = value
    return action


def binary_symmetric_power(g, degree):
    """Column-action matrix for Sym^degree of the contragredient standard module."""
    S = PolynomialRing(F, names=("s", "t"))
    s, t = S.gens()
    a, b, c, d = map(F, g)
    images = (d * s - b * t, -c * s + a * t)
    basis = tuple(s**i * t ** (degree - i) for i in range(degree + 1))
    action = matrix(F, degree + 1, degree + 1)
    for column, vector in enumerate(basis):
        transformed = vector(*images)
        for exponent, coefficient in transformed.dict().items():
            action[exponent[0], column] = coefficient
    return action


def symmetric_square(action):
    """Column-action matrix on the ordinary symmetric square."""
    dimension = action.nrows()
    pairs = tuple((i, j) for i in range(dimension) for j in range(i, dimension))
    pair_index = {pair: index for index, pair in enumerate(pairs)}
    result = matrix(F, len(pairs), len(pairs), sparse=True)
    for column, (i, j) in enumerate(pairs):
        left = tuple(action.column(i).dict().items())
        right = tuple(action.column(j).dict().items())
        for a, ca in left:
            for b, cb in right:
                pair = (a, b) if a <= b else (b, a)
                result[pair_index[pair], column] += ca * cb
    return result


def gap_module(column_actions):
    # GAP's MeatAxe convention uses row vectors.
    generators = [libgap(action.transpose().dense_matrix()) for action in column_actions]
    return libgap.GModuleByMats(generators, libgap.GF(Q))


def sheet_character_record():
    group = libgap.PSL(2, Q)
    subgroup = next(
        subgroup
        for subgroup in libgap.MaximalSubgroups(group)
        if int(libgap.Size(subgroup)) == 60
    )
    permutation_character = libgap.PermutationCharacter(group, subgroup)
    irreducibles = libgap.Irr(libgap.CharacterTable(group))
    degrees = [int(constituent[0]) for constituent in irreducibles]
    multiplicities = [
        int(libgap.ScalarProduct(permutation_character, constituent))
        for constituent in irreducibles
    ]
    brauer_table = libgap.BrauerTable(libgap.CharacterTable("L2(19)"), Q)
    decomposition = [
        [int(entry) for entry in row]
        for row in libgap.DecompositionMatrix(brauer_table)
    ]
    return degrees, multiplicities, decomposition


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--norm-only", action="store_true")
    parser.add_argument("--affine-indecompose", action="store_true")
    parser.add_argument("--indecompose", action="store_true")
    parser.add_argument("--pgl-hom", action="store_true")
    parser.add_argument("--pgl-hom-fast", action="store_true")
    parser.add_argument("--affine-pgl-hom", action="store_true")
    parser.add_argument("--affine-fixed-line", action="store_true")
    parser.add_argument("--outer-check", action="store_true")
    parser.add_argument("--pullback", action="store_true")
    parser.add_argument("--pullback-write", action="store_true")
    parser.add_argument("--pullback-check", action="store_true")
    args = parser.parse_args()

    degrees, multiplicities, decomposition = sheet_character_record()
    assert degrees == [1, 9, 9, 18, 18, 18, 18, 19, 20, 20, 20, 20]
    assert multiplicities == [1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0]
    principal_pim = [row[0] for row in decomposition]
    dimension_38_pim = [row[6] for row in decomposition]
    assert [
        principal_pim[i] + dimension_38_pim[i]
        for i in range(len(multiplicities))
    ] == multiplicities

    translation = (1, 1, 0, 1)
    inversion = (0, -1, 1, 0)
    affine_actions = [conic_action(translation), conic_action(inversion)]
    simple_actions = [
        binary_symmetric_power(translation, 12),
        binary_symmetric_power(inversion, 12),
    ]
    quadratic_actions = [symmetric_square(action) for action in affine_actions]

    assert affine_actions[0] ** Q == identity_matrix(F, 46)
    assert affine_actions[1] ** 2 == identity_matrix(F, 46)
    assert (affine_actions[0] * affine_actions[1]) ** 3 == identity_matrix(F, 46)
    assert simple_actions[0] ** Q == identity_matrix(F, 13)
    assert simple_actions[1] ** 2 == identity_matrix(F, 13)
    assert (simple_actions[0] * simple_actions[1]) ** 3 == identity_matrix(F, 13)

    if args.affine_fixed_line:
        dilation = (2, 0, 0, 1)
        affine_dilation = conic_action(dilation)
        fixed = (
            (affine_actions[0] - 1).stack(affine_actions[1] - 1)
        ).right_kernel()
        assert fixed.dimension() == 1
        fixed_vector = fixed.basis()[0]
        dilated = affine_dilation * fixed_vector
        eigenvalue = next(
            dilated[index] / fixed_vector[index]
            for index in range(len(fixed_vector))
            if fixed_vector[index] != 0
        )
        assert dilated == eigenvalue * fixed_vector
        print(
            "affine H-fixed line: dimension, quotient coordinate, outer eigenvalue =",
            fixed.dimension(),
            fixed_vector[0],
            eigenvalue,
        )
        return

    if args.outer_check:
        dilation = (2, 0, 0, 1)
        affine_dilation = conic_action(dilation)
        simple_dilation = F(2) ** (-6) * binary_symmetric_power(dilation, 12)
        quadratic_dilation = symmetric_square(affine_dilation)
        exponent = pow(2, -1, Q)
        print(
            "simple conjugation:",
            simple_dilation.inverse() * simple_actions[0] * simple_dilation
            == simple_actions[0] ** exponent,
            simple_dilation * simple_actions[0] * simple_dilation.inverse()
            == simple_actions[0] ** 2,
        )
        print(
            "quadratic conjugation:",
            quadratic_dilation.inverse() * quadratic_actions[0] * quadratic_dilation
            == quadratic_actions[0] ** exponent,
            quadratic_dilation * quadratic_actions[0] * quadratic_dilation.inverse()
            == quadratic_actions[0] ** 2,
        )
        return

    if args.affine_pgl_hom:
        dilation = (2, 0, 0, 1)
        affine_dilation = conic_action(dilation)
        simple_dilation = F(2) ** (-6) * binary_symmetric_power(dilation, 12)
        simple = gap_module(simple_actions)
        affine = gap_module(affine_actions)
        homomorphisms = libgap.MTX["BasisModuleHomomorphisms"](simple, affine)
        hom_rows = [list(matrix(F, hom).list()) for hom in homomorphisms]
        basis = matrix(F, hom_rows).echelon_form()
        basis = matrix(F, [row for row in basis.rows() if row])
        source_outer = simple_dilation.transpose()
        target_outer = affine_dilation.transpose()
        induced_rows = []
        for row in basis.rows():
            hom = matrix(F, simple_dilation.nrows(), affine_dilation.nrows(), row)
            transformed = source_outer.inverse() * hom * target_outer
            flat = vector(F, transformed.list())
            induced_rows.append(basis.solve_left(flat))
        induced = matrix(F, induced_rows)
        identity = identity_matrix(F, induced.nrows())
        print(
            "outer action on affine Hom: dimension, plus, minus =",
            induced.nrows(),
            (induced - identity).right_kernel().dimension(),
            (induced + identity).right_kernel().dimension(),
        )
        return

    if args.pullback or args.pullback_write or args.pullback_check:
        dilation = (2, 0, 0, 1)
        affine_dilation = conic_action(dilation)
        simple_dilation = F(2) ** (-6) * binary_symmetric_power(dilation, 12)
        quadratic_dilation = symmetric_square(affine_dilation)

        # In the point-vector convention epsilon is the first coordinate.
        # The polarized contraction sends e0^2 to 2e0, e0*f to f, and
        # Sym^2(F) to zero.
        affine_dimension = affine_dilation.nrows()
        pairs = tuple(
            (i, j)
            for i in range(affine_dimension)
            for j in range(i, affine_dimension)
        )
        contraction = matrix(F, affine_dimension, len(pairs))
        for column, pair in enumerate(pairs):
            if pair == (0, 0):
                contraction[0, column] = 2
            elif pair[0] == 0:
                contraction[pair[1], column] = 1
        for affine_action, quadratic_action in zip(
            affine_actions + [affine_dilation],
            quadratic_actions + [quadratic_dilation],
        ):
            assert contraction * quadratic_action == affine_action * contraction

        simple = gap_module(simple_actions)
        affine = gap_module(affine_actions)
        quadratic = gap_module(quadratic_actions)

        def hom_basis(source, target):
            homomorphisms = libgap.MTX["BasisModuleHomomorphisms"](
                source, target
            )
            rows = [list(matrix(F, hom).list()) for hom in homomorphisms]
            basis = matrix(F, rows).echelon_form()
            return matrix(F, [row for row in basis.rows() if row])

        source_basis = hom_basis(simple, quadratic)
        target_basis = hom_basis(simple, affine)
        assert source_basis.nrows() == 10
        assert target_basis.nrows() == 1

        pullback_rows = []
        for row in source_basis.rows():
            hom = matrix(
                F, simple_dilation.nrows(), quadratic_dilation.nrows(), row
            )
            contracted = hom * contraction.transpose()
            flat = vector(F, contracted.list())
            coordinates = target_basis.solve_left(flat)
            assert coordinates * target_basis == flat
            pullback_rows.append(coordinates)
        pullback_map = matrix(F, pullback_rows)

        def outer_on_hom(basis, target_dilation):
            source_outer = simple_dilation.transpose()
            target_outer = target_dilation.transpose()
            rows = []
            for row in basis.rows():
                hom = matrix(
                    F, simple_dilation.nrows(), target_dilation.nrows(), row
                )
                transformed = source_outer.inverse() * hom * target_outer
                flat = vector(F, transformed.list())
                coordinates = basis.solve_left(flat)
                assert coordinates * basis == flat
                rows.append(coordinates)
            return matrix(F, rows)

        source_outer = outer_on_hom(source_basis, quadratic_dilation)
        target_outer = outer_on_hom(target_basis, affine_dilation)
        source_identity = identity_matrix(F, source_outer.nrows())
        target_identity = identity_matrix(F, target_outer.nrows())
        source_plus = (source_outer - source_identity).right_kernel().dimension()
        source_minus = (source_outer + source_identity).right_kernel().dimension()
        target_plus = (target_outer - target_identity).right_kernel().dimension()
        target_minus = (target_outer + target_identity).right_kernel().dimension()
        assert (source_plus, source_minus) == (10, 0)
        assert (target_plus, target_minus) == (0, 1)
        assert pullback_map.rank() == 0
        record = {
                "q": Q,
                "simple_dimension": simple_dilation.nrows(),
                "hom_to_quadratic_dimension": source_basis.nrows(),
                "hom_to_quadratic_outer": [source_plus, source_minus],
                "hom_to_affine_dimension": target_basis.nrows(),
                "hom_to_affine_outer": [target_plus, target_minus],
                "contraction_map_rank": pullback_map.rank(),
                "quadratic_pullback_split": False,
            }
        encoded = json.dumps(record, default=int, indent=2, sort_keys=True) + "\n"
        if args.pullback_write:
            PULLBACK_CERTIFICATE.write_text(encoded)
            print(f"wrote {PULLBACK_CERTIFICATE.name}")
        elif args.pullback_check:
            assert PULLBACK_CERTIFICATE.read_text() == encoded
            print(f"checked {PULLBACK_CERTIFICATE.name}")
        else:
            print(encoded, end="")
        return

    if args.pgl_hom:
        dilation = (2, 0, 0, 1)
        affine_dilation = conic_action(dilation)
        simple_dilation = F(2) ** (-6) * binary_symmetric_power(dilation, 12)
        quadratic_dilation = symmetric_square(affine_dilation)
        quadratic = gap_module(quadratic_actions + [quadratic_dilation])
        canonical = gap_module(simple_actions + [simple_dilation])
        twisted = gap_module(simple_actions + [-simple_dilation])
        canonical_hom = libgap.MTX["BasisModuleHomomorphisms"](
            canonical, quadratic
        )
        twisted_hom = libgap.MTX["BasisModuleHomomorphisms"](
            twisted, quadratic
        )
        print(
            "PGL Hom dimensions (canonical, determinant-twisted):",
            int(libgap.Length(canonical_hom)),
            int(libgap.Length(twisted_hom)),
        )
        return

    if args.pgl_hom_fast:
        dilation = (2, 0, 0, 1)
        affine_dilation = conic_action(dilation)
        simple_dilation = F(2) ** (-6) * binary_symmetric_power(dilation, 12)
        quadratic_dilation = symmetric_square(affine_dilation)
        simple = gap_module(simple_actions)
        quadratic = gap_module(quadratic_actions)
        homomorphisms = libgap.MTX["BasisModuleHomomorphisms"](
            simple, quadratic
        )
        hom_rows = []
        for homomorphism in homomorphisms:
            hom = matrix(F, homomorphism)
            assert hom.dimensions() == (
                simple_dilation.nrows(),
                quadratic_dilation.nrows(),
            )
            hom_rows.append(list(hom.list()))
        basis = matrix(F, hom_rows).echelon_form()
        basis = matrix(F, [row for row in basis.rows() if row])
        induced_rows = []
        source_outer = simple_dilation.transpose()
        target_outer = quadratic_dilation.transpose()
        source_inverse = source_outer.inverse()
        for row in basis.rows():
            hom = matrix(F, simple_dilation.nrows(), quadratic_dilation.nrows(), row)
            transformed = source_inverse * hom * target_outer
            flat = list(transformed.list())
            coordinates = basis.solve_left(vector(F, flat))
            assert coordinates * basis == vector(F, flat)
            induced_rows.append(coordinates)
        induced = matrix(F, induced_rows)
        identity = identity_matrix(F, induced.nrows())
        plus = (induced - identity).right_kernel().dimension()
        minus = (induced + identity).right_kernel().dimension()
        print("outer action on Hom: dimension, plus, minus =", induced.nrows(), plus, minus)
        return

    if args.affine_indecompose:
        affine = gap_module(affine_actions)
        summands = libgap.MTX["Indecomposition"](affine)
        records = []
        for entry in summands:
            summand = entry[1]
            dimension = int(libgap.MTX["Dimension"](summand))
            radical_dimension = int(
                libgap.Length(libgap.MTX["BasisRadical"](summand))
            )
            socle_dimension = int(
                libgap.Length(libgap.MTX["BasisSocle"](summand))
            )
            records.append(
                (dimension, dimension - radical_dimension, socle_dimension)
            )
        print("affine indecomposable (dimension, head, socle):", sorted(records))
        return

    if args.norm_only:
        dilation_action = symmetric_square(conic_action((2, 0, 0, 1)))
        norm = matrix(F, quadratic_actions[0].nrows(), sparse=True)
        power = identity_matrix(F, quadratic_actions[0].nrows(), sparse=True)
        for _ in range(Q):
            norm += power
            power = quadratic_actions[0] * power
        print("universal translation norm rank:", norm.rank())
        print(
            "outer difference on norm image rank:",
            ((dilation_action - 1) * norm).rank(),
        )
        return

    simple = gap_module(simple_actions)
    quadratic = gap_module(quadratic_actions)
    if args.indecompose:
        summands = libgap.MTX["Indecomposition"](quadratic)
        records = []
        for entry in summands:
            summand = entry[1]
            dimension = int(libgap.MTX["Dimension"](summand))
            radical_dimension = int(
                libgap.Length(libgap.MTX["BasisRadical"](summand))
            )
            socle_dimension = int(
                libgap.Length(libgap.MTX["BasisSocle"](summand))
            )
            records.append(
                (dimension, dimension - radical_dimension, socle_dimension)
            )
        print("indecomposable (dimension, head, socle):", sorted(records))
        return
    homomorphisms = libgap.MTX["BasisModuleHomomorphisms"](simple, quadratic)
    hom_dimension = int(libgap.Length(homomorphisms))
    quadratic_dual = libgap.MTX["DualModule"](quadratic)
    dual_homomorphisms = libgap.MTX["BasisModuleHomomorphisms"](
        simple, quadratic_dual
    )
    dual_hom_dimension = int(libgap.Length(dual_homomorphisms))
    print("q=19 A5 sheet ordinary constituents:", multiplicities)
    print("nonprincipal PIM: dimension 38, simple socle dimension 13")
    print("quadratic conic module dimension:", quadratic_actions[0].nrows())
    print("Hom(S_13, Sym^2(E)) dimension:", hom_dimension)
    print("Hom(S_13, Sym^2(E)^*) dimension:", dual_hom_dimension)


if __name__ == "__main__":
    main()
