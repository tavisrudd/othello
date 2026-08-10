# Independent Sage replay for the modular six-axis discriminant test.

from sage.all import (
    EllipticCurve,
    GF,
    QQ,
    Permutation,
    PermutationGroup,
    PolynomialRing,
    matrix,
    vector,
)

from contextlib import redirect_stdout
from io import StringIO
from itertools import product
from pathlib import Path
import sys

axis_perms = [
    (0, 2, 4, 1, 5, 3),
    (3, 5, 0, 2, 1, 4),
]
letter_perms = [
    (1, 2, 3, 4, 0),
    (1, 2, 0, 3, 4),
]


def heart_matrix(perm, F):
    # Aug(F^6)/<1>, with basis [e_i-e_5], i=0,...,3.
    cols = []
    for i in range(4):
        y = [F(0)] * 6
        y[perm[i]] += 1
        y[perm[5]] -= 1
        cols.append(vector(F, [y[j] - y[4] for j in range(4)]))
    return matrix(F, cols).transpose()


def natural_matrix(perm, F):
    # Aug(F^5), with basis e_i-e_4, i=0,...,3.
    cols = []
    for i in range(4):
        y = [F(0)] * 5
        y[perm[i]] += 1
        y[perm[4]] -= 1
        cols.append(vector(F, y[:4]))
    return matrix(F, cols).transpose()


def hom_basis(source, target, F):
    rows = []
    for A, B in zip(source, target):
        for i in range(4):
            for j in range(4):
                row = [F(0)] * 16
                for k in range(4):
                    row[4 * i + k] += A[k, j]
                    row[4 * k + j] -= B[i, k]
                rows.append(row)
    return matrix(F, rows).right_kernel().basis()


def first_invertible(basis, F):
    for coeffs in product(F, repeat=len(basis)):
        if all(c == 0 for c in coeffs):
            continue
        v = sum((c * b for c, b in zip(coeffs, basis)), vector(F, 16))
        X = matrix(F, 4, 4, list(v))
        if X.is_invertible():
            return X
    return None


def emit():
    print("Independent Sage replay")
    assert PermutationGroup([Permutation([x + 1 for x in p]) for p in axis_perms]).order() == 60
    assert PermutationGroup([Permutation([x + 1 for x in p]) for p in letter_perms]).order() == 60
    for p in (2, 3):
        F = GF(p)
        H = [heart_matrix(g, F) for g in axis_perms]
        V = [natural_matrix(g, F) for g in letter_perms]
        hom = hom_basis(H, V, F)
        end_H = hom_basis(H, H, F)
        end_V = hom_basis(V, V, F)
        iso = first_invertible(hom, F)
        print(f"p={p}: Hom={len(hom)} End=({len(end_H)},{len(end_V)}) iso={iso is not None}")
        assert (iso is not None) == (p == 3)
    F4 = GF(4, "w")
    slopes = [None] + list(F4)
    generators = (
        ((F4(1), F4(1)), (F4(0), F4(1))),
        ((F4(1), F4(0)), (F4(1), F4(1))),
    )

    def act(g, slope):
        if slope is None:
            denominator, numerator = g[0][1], g[1][1]
        else:
            denominator = g[0][0] + g[0][1] * slope
            numerator = g[1][0] + g[1][1] * slope
        return None if denominator == 0 else numerator / denominator

    unseen = set(slopes)
    orbit_sizes = []
    while unseen:
        seed = unseen.pop()
        orbit, frontier = {seed}, [seed]
        while frontier:
            point = frontier.pop()
            for g in generators:
                image = act(g, point)
                if image not in orbit:
                    orbit.add(image)
                    unseen.discard(image)
                    frontier.append(image)
        orbit_sizes.append(len(orbit))
    assert sorted(orbit_sizes) == [2, 3]
    print("P1(F4) orbit sizes under GL2(F2): 2,3; no fixed line")
    RT = PolynomialRing(QQ, "T")
    T = RT.gen()
    RX = PolynomialRing(RT, "x")
    x = RX.gen()
    b = T + 27
    two_division = 4 * x**3 + b**2 * x**2 + 2 * b**3 * x + b**4
    assert two_division.discriminant() == 16 * T * (T + 27)**8
    q = -QQ(5) / 27
    base_j = 16 * (q**2 + 14 * q + 1)**3 / (q * (q - 1)**4)
    assert base_j == QQ(357911) / 2160
    print("independent covers: square classes T,D; composite genus-one j=357911/2160")
    c = -QQ(594) / 5
    e = -QQ(19683) / 5
    base_curve = EllipticCurve(QQ, [0, -2 * c, 0, c**2 - 4 * e, 0])
    minimal = base_curve.global_minimal_model()
    assert minimal.a_invariants() == (1, -1, 0, 333, -7259)
    assert minimal.conductor() == 450
    assert minimal.rank(proof=True) == 0
    assert tuple(minimal.torsion_subgroup().invariants()) == (2,)
    print("composite base: conductor=450 rank=0 torsion=Z/2; no affine rational points")
    print("PASS")


stream = StringIO()
with redirect_stdout(stream):
    emit()
rendered = stream.getvalue()
target = Path(__file__).with_name("2026-08-10-c904-kernel-v4-replay.out")
if sys.argv[1:] == ["--write"]:
    target.write_text(rendered)
elif sys.argv[1:] == ["--check"]:
    assert target.read_text() == rendered
    print("CHECK PASS")
elif not sys.argv[1:]:
    print(rendered, end="")
else:
    raise SystemExit("usage: kernel-v4-replay.sage [--write|--check]")
