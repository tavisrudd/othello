# Independent Sage replay for the modular six-axis discriminant test.

from sage.all import (
    EllipticCurve,
    GF,
    QQ,
    Permutation,
    PermutationGroup,
    PolynomialRing,
    SymmetricGroup,
    ZZ,
    matrix,
    vector,
)

from contextlib import redirect_stdout
from io import StringIO
from itertools import permutations, product
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


def five_heart_matrix(perm, F):
    # Aug(F^5)/<1>, with basis e_i-e_4, i=0,...,2.
    cols = []
    for i in range(3):
        y = [F(0)] * 5
        y[perm[i]] += 1
        y[perm[4]] -= 1
        cols.append(vector(F, [y[j] - y[3] for j in range(3)]))
    return matrix(F, cols).transpose()


def hom_basis(source, target, F):
    n = source[0].nrows()
    rows = []
    for A, B in zip(source, target):
        for i in range(n):
            for j in range(n):
                row = [F(0)] * (n * n)
                for k in range(n):
                    row[n * i + k] += A[k, j]
                    row[n * k + j] -= B[i, k]
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
    symplectic_summary = None
    primitive_endos = None
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
        if p == 2:
            positions = [(i, j) for i in range(4) for j in range(i + 1, 4)]
            forms = []
            for entries in product(F, repeat=6):
                B = matrix(F, 4, 4)
                for (i, j), value in zip(positions, entries):
                    B[i, j] = value
                    B[j, i] = value
                if all(g.transpose() * B * g == B for g in H):
                    forms.append(B)
            endomorphisms = []
            for coeffs in product(F, repeat=len(end_H)):
                v = sum((c * b for c, b in zip(coeffs, end_H)), vector(F, 16))
                endomorphisms.append(matrix(F, 4, 4, list(v)))
            nondegenerate = [B for B in forms if B.rank() == 4]
            assert len(forms) == 4 and len(nondegenerate) == 3
            assert all(W.transpose() * nondegenerate[0] == nondegenerate[0] * W
                       for W in endomorphisms)
            symplectic_summary = (len(nondegenerate), len(endomorphisms))
            zero = matrix(F, 4, 4)
            identity = matrix.identity(F, 4)
            primitive_endos = [W for W in endomorphisms if W not in (zero, identity)]
            assert len(primitive_endos) == 2
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
    assert symplectic_summary == (3, 4)
    print("three invariant symplectic forms; all four F4 endomorphisms self-adjoint")
    F2 = GF(2)
    all_six_perms = list(permutations(range(6)))
    stabilizer_sizes = []
    for W in (matrix(F2, 4, 4), matrix.identity(F2, 4), *primitive_endos):
        stabilizer_sizes.append(sum(heart_matrix(s, F2) * W == W * heart_matrix(s, F2)
                                    for s in all_six_perms))
    assert stabilizer_sizes == [720, 720, 60, 60]
    assert all(heart_matrix(g, F2) * W == W * heart_matrix(g, F2)
               for g in axis_perms for W in primitive_endos)
    S6 = SymmetricGroup(6)
    axis_group = S6.subgroup([S6([x + 1 for x in p]) for p in axis_perms])
    normalizer = []
    for s in all_six_perms:
        sigma = S6([x + 1 for x in s])
        if all(sigma * g * sigma.inverse() in axis_group for g in axis_group.gens()):
            normalizer.append((s, sigma))
    assert len(normalizer) == 120
    outside = next(s for s, sigma in normalizer if sigma not in axis_group)
    A = heart_matrix(outside, F2)
    conjugates = [A * W * A.inverse() for W in primitive_endos]
    assert all(W in primitive_endos for W in conjugates)
    assert all(A * W * A.inverse() != W for W in primitive_endos)
    print("S6 graph stabilizers 720,720,60,60; the order-120 normalizer swaps the exotic pair")
    winger_gram = matrix(ZZ, 4, 4, lambda i, j: 12 if i == j else -3)
    cubic_gram = matrix(ZZ, 5, 5, lambda i, j: 5 if i == j else -1)
    assert tuple(winger_gram.elementary_divisors()) == (3, 15, 15, 15)
    assert tuple(cubic_gram.elementary_divisors()) == (1, 6, 6, 6, 6)
    print("twin simplex Smith forms: Winger (3,15,15,15), cubic (1,6,6,6,6)")
    F5 = GF(5)
    H5 = [five_heart_matrix(g, F5) for g in letter_perms]
    assert len(hom_basis(H5, H5, F5)) == 1
    spans = []
    for v in F5**3:
        if v == 0:
            continue
        seed = tuple(v)
        orbit = {seed}
        frontier = [seed]
        while frontier:
            point = frontier.pop()
            for g in H5:
                image_point = tuple(g * vector(F5, point))
                if image_point not in orbit:
                    orbit.add(image_point)
                    frontier.append(image_point)
        spans.append(matrix(F5, list(orbit)).rank())
    assert min(spans) == 3
    print("Winger 5-residue: simple 3D heart with scalar endomorphisms")
    RT = PolynomialRing(QQ, "T")
    T = RT.gen()
    RX = PolynomialRing(RT, "x")
    x = RX.gen()
    b = T + 27
    two_division = 4 * x**3 + b**2 * x**2 + 2 * b**3 * x + b**4
    assert two_division.discriminant() == 16 * T * (T + 27)**8
    RY = PolynomialRing(QQ, "y")
    y = RY.gen()
    assert 4 * y**3 + 27 * (y + 1)**2 == (4 * y + 3) * (y + 3)**2
    RU = PolynomialRing(QQ, "u")
    u = RU.gen()
    y_of_u = -(u**2 + 3) / 4
    T_of_y = -(4 * y_of_u + 3) * (y_of_u + 3)**2 / (y_of_u + 1)**2
    assert T_of_y == u**2 * (9 - u**2)**2 / (1 - u**2)**2
    print("degree-3 root cover and full S3 splitting cover are rational resolvents")
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
