"""Exact checks for the design of the spherical cubic restriction module.

These are the quantities the planned Lean module
`RelativeConicArcs.SphericalCubicRestriction` targets, and which the broader
certificate `notes/2026-08-07-c815-harmonic-realization-checks.py` does not
record: the doubled-coordinate normalization of a zonal form, the explicit
monomial form of the marked harmonic field, its splitting into a
transposition-odd and a transposition-even harmonic, the four cubic moments of
that splitting (two of which vanish by the transposition), and the word tables
that carry the three icosahedral label permutations onto the label triples the
coefficient argument compares.

Labels are `0..4`, matching `Fin 5` in the Lean development; the axis
coordinates and the three rotations are transcribed from
`lean/RelativeConicArcs/IcosahedralFaceAxes.lean`.

Replay from the repository root:

    uv run --with sympy python3 notes/2026-08-07-c815-spherical-cubic-design-checks.py \
      --check notes/2026-08-07-c815-spherical-cubic-design-checks.json
"""

from __future__ import annotations

import argparse
import itertools
import json
import sys

import sympy as sp

X1, X2, X3 = sp.symbols("x1 x2 x3")
COORDS = (X1, X2, X3)
QUADRIC = X1**2 + X2**2 + X3**2
S5 = sp.sqrt(5)


def golden(a: int, b: int):
    """The element `a + b*sqrt 5` of the ring the Lean file calls `ℤ√5`."""
    return a + b * S5


DOUBLED_AXES = {
    (0, 1): (-2, -2, -2),
    (0, 2): (-2, -2, 2),
    (0, 3): (-2, 2, -2),
    (0, 4): (-2, 2, 2),
    (2, 3): (0, golden(1, -1), golden(-1, -1)),
    (1, 4): (0, golden(1, -1), golden(1, 1)),
    (3, 4): (golden(1, -1), golden(-1, -1), 0),
    (1, 2): (golden(1, -1), golden(1, 1), 0),
    (2, 4): (golden(-1, -1), 0, golden(1, -1)),
    (1, 3): (golden(1, 1), 0, golden(1, -1)),
}

LABELS = sorted(DOUBLED_AXES)

# The three label permutations induced by the three rotations, as images of
# `0..4`; transcribed from `IcosahedralFaceAxes.labelPermutation`.
GENERATORS = {
    "g0": (0, 4, 3, 2, 1),
    "g1": (0, 1, 4, 2, 3),
    "g2": (1, 0, 4, 3, 2),
}

# The normalization that clears both square roots from a zonal form written in
# doubled axis coordinates: `27648 = 16 * 12^3`.
ZONAL_SCALE = 27648


def dot(u, v):
    return sp.expand(sum(a * b for a, b in zip(u, v)))


def doubled_zonal(axis):
    """`27648` times the zonal form of the unit vector `axis / (2 sqrt 3)`."""
    t2 = sp.expand(dot(axis, COORDS) ** 2)
    return sp.expand(
        231 * t2**3
        - 3780 * t2**2 * QUADRIC
        + 15120 * t2 * QUADRIC**2
        - 8640 * QUADRIC**3
    )


def gaussian_moment(poly):
    poly = sp.Poly(sp.expand(poly), X1, X2, X3)
    total = 0
    for monomial, coefficient in zip(poly.monoms(), poly.coeffs()):
        if any(exponent % 2 for exponent in monomial):
            continue
        weight = sp.prod([sp.factorial2(exponent - 1) for exponent in monomial])
        total += coefficient * weight
    return sp.simplify(sp.expand(total))


def normalized_mean(poly, degree):
    return sp.nsimplify(sp.simplify(gaussian_moment(poly) / sp.factorial2(degree + 1)))


def check_axis_geometry(results):
    norms = {dot(a, a) for a in DOUBLED_AXES.values()}
    products = set()
    for p, q in itertools.combinations(LABELS, 2):
        value = sp.simplify(dot(DOUBLED_AXES[p], DOUBLED_AXES[q]) ** 2)
        disjoint = not (set(p) & set(q))
        products.add((disjoint, value))
    results["doubled_axis_squared_norms"] = sorted(str(n) for n in norms)
    results["doubled_axis_squared_products"] = sorted(
        [str(d), str(v)] for d, v in products
    )


def check_zonal_normalization(results, zonals):
    """The doubled-coordinate zonal is `27648` times a harmonic form."""
    residuals = []
    for p in LABELS:
        z = zonals[p]
        laplacian = sp.expand(
            sp.diff(z, X1, 2) + sp.diff(z, X2, 2) + sp.diff(z, X3, 2)
        )
        residuals.append(sp.simplify(laplacian))
    results["doubled_zonal_scale"] = ZONAL_SCALE
    results["doubled_zonal_laplacians_vanish"] = all(r == 0 for r in residuals)


def marked_field(zonals):
    """`27648` times the harmonic field of the marked weight `(4,-1,-1,-1,-1)`."""
    weight = {0: 4, 1: -1, 2: -1, 3: -1, 4: -1}
    return sp.expand(
        sum((weight[p[0]] + weight[p[1]]) * zonals[p] for p in LABELS)
    )


def check_marked_field(results, zonals):
    scaled = marked_field(zonals)
    field = sp.expand(scaled / ZONAL_SCALE)
    poly = sp.Poly(field, X1, X2, X3)
    monomials = {
        "".join(str(e) for e in monomial): str(sp.radsimp(coefficient))
        for monomial, coefficient in zip(poly.monoms(), poly.coeffs())
    }
    results["marked_field_monomials"] = dict(sorted(monomials.items()))
    results["marked_field_all_exponents_even"] = all(
        all(e % 2 == 0 for e in monomial) for monomial in poly.monoms()
    )
    return field


def harmonic_basis():
    u, v, w = X1**2, X2**2, X3**2
    odd = sp.expand((u * v**2 + v * w**2 + w * u**2) - (u**2 * v + v**2 * w + w**2 * u))
    even = sp.expand(
        (u**3 + v**3 + w**3)
        - sp.Rational(15, 2) * (u**2 * v + v**2 * w + w**2 * u
                                + u * v**2 + v * w**2 + w * u**2)
        + 90 * u * v * w
    )
    return odd, even


def check_basis(results, field):
    odd, even = harmonic_basis()
    swap = {X1: X2, X2: X1}
    results["basis_odd_is_transposition_odd"] = (
        sp.simplify(sp.expand(odd.subs(swap, simultaneous=True) + odd)) == 0
    )
    results["basis_even_is_transposition_even"] = (
        sp.simplify(sp.expand(even.subs(swap, simultaneous=True) - even)) == 0
    )
    results["basis_laplacians_vanish"] = all(
        sp.simplify(sp.expand(sp.diff(h, X1, 2) + sp.diff(h, X2, 2) + sp.diff(h, X3, 2))) == 0
        for h in (odd, even)
    )

    a = -385 * S5 / 24
    b = sp.Rational(35, 12)
    results["marked_field_odd_coefficient"] = str(a)
    results["marked_field_even_coefficient"] = str(b)
    results["marked_field_splits"] = (
        sp.simplify(sp.expand(field - (a * odd + b * even))) == 0
    )

    moments = {
        "odd^3": normalized_mean(sp.expand(odd**3), 18),
        "odd^2 even": normalized_mean(sp.expand(odd**2 * even), 18),
        "odd even^2": normalized_mean(sp.expand(odd * even**2), 18),
        "even^3": normalized_mean(sp.expand(even**3), 18),
    }
    results["cubic_moments"] = {k: str(v) for k, v in moments.items()}
    results["quadratic_moments"] = {
        "odd^2": str(normalized_mean(sp.expand(odd**2), 12)),
        "odd even": str(normalized_mean(sp.expand(odd * even), 12)),
        "even^2": str(normalized_mean(sp.expand(even**2), 12)),
    }

    cubic = sp.simplify(
        a**3 * moments["odd^3"]
        + 3 * a**2 * b * moments["odd^2 even"]
        + 3 * a * b**2 * moments["odd even^2"]
        + b**3 * moments["even^3"]
    )
    results["marked_cubic_value"] = str(cubic)
    results["marked_cubic_matches_manuscript"] = (
        sp.simplify(cubic - sp.Rational(-15680000, 1247103)) == 0
    )
    direct = normalized_mean(sp.expand(field**3), 18)
    results["marked_cubic_direct_agrees"] = sp.simplify(direct - cubic) == 0
    quadratic = normalized_mean(sp.expand(field**2), 12)
    results["marked_quadratic_value"] = str(quadratic)
    results["marked_quadratic_matches_gram_module"] = (
        sp.simplify(quadratic - sp.Rational(2800, 351)) == 0
    )


def compose(a, b):
    return tuple(a[b[i]] for i in range(5))


def closure(names):
    identity = (0, 1, 2, 3, 4)
    words = {identity: []}
    frontier = [identity]
    while frontier:
        nxt = []
        for permutation in frontier:
            for name in names:
                image = compose(GENERATORS[name], permutation)
                if image not in words:
                    words[image] = [name] + words[permutation]
                    nxt.append(image)
        frontier = nxt
    return words


def check_words(results):
    full = closure(["g0", "g1", "g2"])
    stabilizer = closure(["g0", "g1"])

    def parity(p):
        inversions = sum(
            1 for i, j in itertools.combinations(range(5), 2) if p[i] > p[j]
        )
        return inversions % 2

    results["generated_order"] = len(full)
    results["generated_all_even"] = all(parity(p) == 0 for p in full)
    results["stabilizer_order"] = len(stabilizer)
    results["stabilizer_fixes_zero"] = all(p[0] == 0 for p in stabilizer)
    results["stabilizer_ordered_pair_images"] = len({(p[1], p[2]) for p in stabilizer})

    point_words = {}
    for target in range(1, 5):
        word = min((w for p, w in full.items() if p[0] == target), key=len)
        point_words[str(target)] = " ".join(word)
    results["point_words"] = point_words

    pair_words = {}
    for image, word in sorted(
        ((p[1], p[2]), w) for p, w in stabilizer.items()
    ):
        key = "%d%d" % image
        if key not in pair_words or len(word) < len(pair_words[key].split()):
            pair_words[key] = " ".join(word)
    results["stabilizer_pair_words"] = dict(sorted(pair_words.items()))


def run():
    results = {
        "schema": "c815-spherical-cubic-design-checks-1",
        "labels": "zero-indexed, matching Fin 5 in the Lean development",
    }
    zonals = {p: doubled_zonal(DOUBLED_AXES[p]) for p in LABELS}
    check_axis_geometry(results)
    check_zonal_normalization(results, zonals)
    field = check_marked_field(results, zonals)
    check_basis(results, field)
    check_words(results)
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
